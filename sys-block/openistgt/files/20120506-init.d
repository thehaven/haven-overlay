#!/sbin/runscript
# Copyright 1999-2010 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later

MEM_SIZE=1048576
DAEMON=/usr/bin/istgt
CONFIG_FILE=/etc/istgt/istgt.conf
PID_FILE=/var/run/istgt.pid
NAME="iSCSI Enterprise Target for FreeBSD"

ARGS=""
[ -n "$MODE" ] && ARGS="${ARGS} -m ${MODE}"
[ -n "$FACILITY" ] && ARGS="${ARGS} -l ${FACILITY}"
[ -n "$DEBUGLEVEL" ] && ARGS="${ARGS} -D -t ${DEBUGLEVEL}"
[ -n "$CONFIG" ] && ARGS="${ARGS} -c ${CONFIG}"


depend() {
	use net
	after modules
}
checkconfig() {
	if [ ! -f $CONFIG_FILE ]; then
		eerror "Config file $CONFIG_FILE does not exist!"
		return 1
	fi
#	if [ -z "$DISABLE_MEMORY_WARNINGS" ]; then
#		check_memsize
#	fi
}

check_memsize() {
	local wr md sysctl_key v k
	for wr in r w; do
		for md in max default; do
			sysctl_key="net.core.${wr}mem_${md}"
			v="$(sysctl -n ${sysctl_key})"
			if [ "${v}" -lt "${MEM_SIZE}" ]; then
				ewarn "$sysctl_key ($v) is lower than recommended ${MEM_SIZE}"
			fi
		done
	done
	for wr in "" r w; do
		sysctl_key="net.inet.tcp_${wr}mem"
		set -- $(sysctl -n ${sysctl_key})
		for k in min default max ; do
			if [ "${1}" -lt "${MEM_SIZE}" ]; then
				ewarn "$sysctl_key:$k (${1}) is lower than recommended ${MEM_SIZE}"
			fi
			shift
		done
	done
}

start() {
	checkconfig || return 1
	ebegin "Starting ${NAME}"
	start-stop-daemon --start --exec $DAEMON --quiet -- ${ARGS}
	eend $?
}

stop() {
	ebegin "Stopping ${NAME}"
	start-stop-daemon --stop --quiet --exec $DAEMON --pidfile $PID_FILE
	ret=$?
	eend $ret
	[ $ret -ne 0 ] && return 1

	# ugly, but pid file is not removed by openistgt
	rm -f $PID_FILE
}

# vim: tw=72:
