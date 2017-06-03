// PyroScope - rTorrent Command Extensions
// Copyright (c) 2011 The PyroScope Project <pyroscope.project@gmail.com>
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along
// with this program; if not, write to the Free Software Foundation, Inc.,
// 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

#include "config.h"
#include "globals.h"

#include <cstdio>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <ctime>
#include <rak/path.h>
#include <rak/functional.h>
#include <rak/functional_fun.h>
#if RT_HEX_VERSION < 0x000904
    #include <sigc++/adaptors/bind.h>
#endif

#include "core/download.h"
#include "core/manager.h"
#include "core/view_manager.h"
#include "rpc/parse.h"
#include "torrent/tracker.h"
#include "torrent/tracker_list.h"
#include "ui/root.h"
#include "ui/download_list.h"
#include "ui/element_base.h"
#include "ui/element_download_list.h"

#include "globals.h"
#include "control.h"
#include "command_helpers.h"

#if (RT_HEX_VERSION >= 0x000901)
    #define _cxxstd_ tr1
#else
    #define _cxxstd_ std
#endif


// handle for message log file
namespace core {
int log_messages_fd = -1;
};


// return the "main" tracker for this download item
torrent::Tracker* get_active_tracker(torrent::Download* item) {
    torrent::TrackerList* tl = item->tracker_list();
    torrent::Tracker* tracker = 0;

    for (int trkidx = 0; trkidx < tl->size(); trkidx++) {
        tracker = tl->at(trkidx);
        if (tracker->is_usable() && tracker->type() == torrent::Tracker::TRACKER_HTTP
                && tracker->scrape_complete() + tracker->scrape_incomplete() > 0) {
            break;
        }
        tracker = 0;
    }
    if (!tracker && tl->size()) tracker = tl->at(0);

    return tracker;
}


// return the domain name of the "main" tracker of the given download item
std::string get_active_tracker_domain(torrent::Download* item) {
    std::string url;
    torrent::Tracker* tracker = get_active_tracker(item);

    if (tracker && !tracker->url().empty()) {
        url = tracker->url();

        // snip url to domain name
        if (url.compare(0, 7, "http://")  == 0) url = url.substr(7);
        if (url.compare(0, 8, "https://") == 0) url = url.substr(8);
        if (url.find('/') > 0) url = url.substr(0, url.find('/'));
        if (url.find(':') > 0) url = url.substr(0, url.find(':'));

        // remove some common cruft
        const char* domain_cruft[] = {
            "tracker", "1.", "2.", "001.", ".",
            "www.",
            0
        };
        for (const char** cruft = domain_cruft; *cruft; cruft++) {
            int cruft_len = strlen(*cruft);
            if (url.compare(0, cruft_len, *cruft) == 0) url = url.substr(cruft_len);
        }
    }

    return url;
}


/*  @DOC
    compare=order,command1=[,...]

        Compares two items like `less=` or `greater=`, but allows to compare
        by several different sort criteria, and ascending or descending
        order per given field. The first parameter is a string of order
        indicators, either `aA+` for ascending or `dD-` for descending.
        The default, i.e. when there's more fields than indicators, is
        ascending. Field types other than value or string are treated
        as equal (or in other words, they're ignored).

        If all fields are equal, then items are ordered in a random, but
        stable fashion.

        Configuration example:
            # VIEW: Show active and incomplete torrents (in view #9) and update every 20 seconds
            #       Items are grouped into complete, incomplete, and queued, in that order.
            #       Within each group, they're sorted by upload and then download speed.
            view_sort_current = active,"compare=----,d.is_open=,d.complete=,d.up.rate=,d.down.rate="
            schedule = filter_active,12,20,"view.filter = active,\"or={d.up.rate=,d.down.rate=,not=$d.complete=}\" ;view.sort=active"
*/
torrent::Object apply_compare(rpc::target_type target, const torrent::Object::list_type& args) {
    if (!rpc::is_target_pair(target))
        throw torrent::input_error("Can only compare a target pair.");

    if (args.size() < 2)
        throw torrent::input_error("Need at least order and one field.");

    torrent::Object::list_const_iterator itr = args.begin();
    std::string order = (itr++)->as_string();
    const char* current = order.c_str();

    torrent::Object result1;
    torrent::Object result2;

    for (torrent::Object::list_const_iterator last = args.end(); itr != last; itr++) {
        std::string field = itr->as_string();
        result1 = rpc::parse_command_single(rpc::get_target_left(target), field);
        result2 = rpc::parse_command_single(rpc::get_target_right(target), field);

        if (result1.type() != result2.type())
            throw torrent::input_error(std::string("Type mismatch in compare of ") + field);

        bool descending = *current == 'd' || *current == 'D' || *current == '-';
        if (*current) {
            if (!descending && !(*current == 'a' || *current == 'A' || *current == '+'))
                throw torrent::input_error(std::string("Bad order '") + *current + "' in " + order);
            ++current;
        }

        switch (result1.type()) {
            case torrent::Object::TYPE_VALUE:
                if (result1.as_value() != result2.as_value())
                    return (int64_t) (descending ^ (result1.as_value() < result2.as_value()));
                break;

            case torrent::Object::TYPE_STRING:
                if (result1.as_string() != result2.as_string())
                    return (int64_t) (descending ^ (result1.as_string() < result2.as_string()));
                break;

            default:
                break; // treat unknown types as equal
        }
    }

    // if all else is equal, ensure stable sort order based on memory location
    return (int64_t) (target.second < target.third);
}


static std::map<int, std::string> bound_commands[ui::DownloadList::DISPLAY_MAX_SIZE];

/*  @DOC
    ui.bind_key=display,key,"command1=[,...]"

        Binds the given key on a specified display to execute the commands when pressed.

        "display" must be one of "download_list", ...
        "key" can be either a single character for normal keys,
            ^ plus a character for control keys, or a 4 digit octal key code.

        Configuration example:
            # VIEW: Bind view #7 to the "rtcontrol" result
            schedule = bind_7,1,0,"ui.bind_key=download_list,7,ui.current_view.set=rtcontrol"
*/
torrent::Object apply_ui_bind_key(rpc::target_type target, const torrent::Object& rawArgs) {
    const torrent::Object::list_type& args = rawArgs.as_list();

    if (args.size() != 3)
        throw torrent::input_error("Expecting display, key, and commands.");

    // Parse positional arguments
    torrent::Object::list_const_iterator itr = args.begin();
    const std::string& element  = (itr++)->as_string();
    const std::string& keydef   = (itr++)->as_string();
    const std::string& commands = (itr++)->as_string();

    // Get key index from definition
    if (keydef.empty() || keydef.size() > (keydef[0] == '0' ? 4 : keydef[0] == '^' ? 2 : 1))
        throw torrent::input_error("Bad key definition.");
    int key = keydef[0];
    if (key == '^' && keydef.size() > 1) key = keydef[1] & 31;
    if (key == '0' && keydef.size() != 1) {
        if (keydef.size() != 4)
            throw torrent::input_error("Bad key definition (expected 4 digit octal code).");
        key = (int) strtol(keydef.c_str(), (char **) NULL, 8);
    }

    // Look up display
    ui::DownloadList::Display displayType = ui::DownloadList::DISPLAY_MAX_SIZE;
    if (element == "download_list") {
        displayType = ui::DownloadList::DISPLAY_DOWNLOAD_LIST;
    } else {
        throw torrent::input_error(std::string("Unknown display ") + element);
    }
    ui::DownloadList* dl_list = control->ui()->download_list();
    if (!dl_list)
        throw torrent::input_error("No download list.");
    ui::ElementBase* display = dl_list->display(displayType);
    if (!display)
        throw torrent::input_error("Display not found.");

    // Bind the key to the given commands
    bool new_binding = display->bindings().find(key) == display->bindings().end();
    bound_commands[displayType][key] = commands; // keep hold of the string, so the c_str() below remains valid
    switch (displayType) {
        case ui::DownloadList::DISPLAY_DOWNLOAD_LIST:
            display->bindings()[key] =
#if RT_HEX_VERSION < 0x000904
                sigc::bind(sigc::mem_fun(*(ui::ElementDownloadList*)display, &ui::ElementDownloadList::receive_command),
#else
                _cxxstd_::bind(&ui::ElementDownloadList::receive_command, (ui::ElementDownloadList*)display,
#endif
                bound_commands[displayType][key].c_str());
            break;
        default:
            return torrent::Object();
    }

    if (!new_binding) {
        std::string msg = "Replaced key binding";
        msg += " for " + keydef + " in " + element + " with " + commands.substr(0, 30);
        if (commands.size() > 30) msg += "...";
        control->core()->push_log(msg.c_str());
    }

    return torrent::Object();
}


torrent::Object cmd_ui_focus_home() {
    ui::DownloadList* dl_list = control->ui()->download_list();
    core::View* dl_view = dl_list->current_view();

    if (!dl_view->empty_visible()) {
        dl_view->set_focus(dl_view->begin_visible());
        dl_view->set_last_changed();
    }

    return torrent::Object();
}


torrent::Object cmd_ui_focus_end() {
    ui::DownloadList* dl_list = control->ui()->download_list();
    core::View* dl_view = dl_list->current_view();

    if (!dl_view->empty_visible()) {
        dl_view->set_focus(dl_view->end_visible() - 1);
        dl_view->set_last_changed();
    }

    return torrent::Object();
}


static int ui_page_size() {
    // TODO: map 0 to the current view size, for adaptive scrolling
    return std::max(1, (int) rpc::call_command_value("ui.focus.page_size"));
}


torrent::Object cmd_ui_focus_pgup() {
    ui::DownloadList* dl_list = control->ui()->download_list();
    core::View* dl_view = dl_list->current_view();

    int skip = ui_page_size();
    if (!dl_view->empty_visible()) {
        if (dl_view->focus() == dl_view->end_visible())
            dl_view->set_focus(dl_view->end_visible() - 1);
        else if (dl_view->focus() - dl_view->begin_visible() >= skip)
            dl_view->set_focus(dl_view->focus() - skip);
        else
            dl_view->set_focus(dl_view->begin_visible());
        dl_view->set_last_changed();
    }

    return torrent::Object();
}


torrent::Object cmd_ui_focus_pgdn() {
    ui::DownloadList* dl_list = control->ui()->download_list();
    core::View* dl_view = dl_list->current_view();

    int skip = ui_page_size();
    if (!dl_view->empty_visible()) {
        if (dl_view->focus() == dl_view->end_visible())
            dl_view->set_focus(dl_view->begin_visible());
        else if (dl_view->end_visible() - dl_view->focus() > skip)
            dl_view->set_focus(dl_view->focus() + skip);
        else
            dl_view->set_focus(dl_view->end_visible() - 1);
        dl_view->set_last_changed();
    }

    return torrent::Object();
}


torrent::Object cmd_log_messages(const torrent::Object::string_type& arg) {
    if (arg.empty()) {
        control->core()->push_log_std("Closing message log file.");
    }

    if (core::log_messages_fd >= 0) {
        ::close(core::log_messages_fd);
        core::log_messages_fd = -1;
    }

    if (!arg.empty()) {
        core::log_messages_fd = open(rak::path_expand(arg).c_str(), O_WRONLY | O_APPEND | O_CREAT, 0644);

        if (core::log_messages_fd < 0) {
            throw torrent::input_error("Could not open message log file.");
        }

        control->core()->push_log_std("Opened message log file '" + rak::path_expand(arg) + "'.");
    }

    return torrent::Object();
}


// Backports from 0.9.2
#if (API_VERSION < 3)
template <typename InputIterator, typename OutputIterator> OutputIterator
pyro_transform_hex(InputIterator first, InputIterator last, OutputIterator dest) {
  const char* hex = "0123456789abcdef";
  while (first != last) {
    *(dest++) = (*first >> 4)[hex];
    *(dest++) = (*first & 15)[hex];

    ++first;
  }

  return dest;
}


torrent::Object d_chunks_seen(core::Download* download) {
    const uint8_t* seen = download->download()->chunks_seen();

    if (seen == NULL)
        return std::string();

    uint32_t size = download->download()->file_list()->size_chunks();
    std::string result;
    result.resize(size * 2);
    pyro_transform_hex((const char*)seen, (const char*)seen + size, result.begin());

    return result;
}
#endif


torrent::Object cmd_d_tracker_domain(core::Download* download) {
    return get_active_tracker_domain(download->download());
}


#if RT_HEX_VERSION <= 0x000906
// https://github.com/rakshasa/rtorrent/commit/1f5e4d37d5229b63963bb66e76c07ec3e359ecba
torrent::Object cmd_system_env(const torrent::Object::string_type& arg) {
    if (arg.empty()) {
        throw torrent::input_error("system.env: Missing variable name.");
    }

    char* val = getenv(arg.c_str());
    return std::string(val ? val : "");
}

// https://github.com/rakshasa/rtorrent/commit/30d8379391ad4cb3097d57aa56a488d061e68662
torrent::Object cmd_ui_current_view() {
    return control->ui()->download_list()->current_view()->name();
}
#endif


void initialize_command_pyroscope() {
// Backports from 0.9.2
#if (API_VERSION < 3)
    // https://github.com/rakshasa/rtorrent/commit/b28f2ea8070
    // https://github.com/rakshasa/rtorrent/commit/020de10f38210a07a567aeebbe385a4faaf4b517
    CMD2_DL("d.chunks_seen", _cxxstd_::bind(&d_chunks_seen, _cxxstd_::placeholders::_1));

    // https://github.com/rakshasa/rtorrent/commit/5bed4f01ad
    CMD2_TRACKER("t.is_usable",          _cxxstd_::bind(&torrent::Tracker::is_usable, _cxxstd_::placeholders::_1));
    CMD2_TRACKER("t.is_busy",            _cxxstd_::bind(&torrent::Tracker::is_busy, _cxxstd_::placeholders::_1));
#endif

#if RT_HEX_VERSION <= 0x000906
    // these are merged into 0.9.7+ mainline!
    CMD2_ANY_STRING("system.env", _cxxstd_::bind(&cmd_system_env, _cxxstd_::placeholders::_2));
    CMD2_ANY("ui.current_view", _cxxstd_::bind(&cmd_ui_current_view));
#endif

    CMD2_ANY_LIST("compare", &apply_compare);
    CMD2_ANY("ui.bind_key", &apply_ui_bind_key);
    CMD2_DL("d.tracker_domain", _cxxstd_::bind(&cmd_d_tracker_domain, _cxxstd_::placeholders::_1));
    CMD2_ANY_STRING("log.messages", _cxxstd_::bind(&cmd_log_messages, _cxxstd_::placeholders::_2));
    CMD2_ANY("ui.focus.home", _cxxstd_::bind(&cmd_ui_focus_home));
    CMD2_ANY("ui.focus.end", _cxxstd_::bind(&cmd_ui_focus_end));
    CMD2_ANY("ui.focus.pgup", _cxxstd_::bind(&cmd_ui_focus_pgup));
    CMD2_ANY("ui.focus.pgdn", _cxxstd_::bind(&cmd_ui_focus_pgdn));
    CMD2_VAR_VALUE("ui.focus.page_size", 50);
}
