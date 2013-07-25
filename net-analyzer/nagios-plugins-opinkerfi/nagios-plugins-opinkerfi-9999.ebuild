# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils git-2

DESCRIPTION="Small army of nagios-plugins either made or maintained by opinkerfi"
HOMEPAGE="https://github.com/opinkerfi/nagios-plugins"
EGIT_REPO_URI="https://github.com/opinkerfi/nagios-plugins.git"

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="|| ( net-analyzer/nagios-core net-analyzer/nrpe )"
RDEPEND="${DEPEND}"

src_install() {
# find . -type f -print | grep -v git | grep -v spec | grep -v README | grep -v LICENSE | grep -v COPYING | grep -v rel-eng  sed 's/^.\//    doins ${WORKDIR}\/${P}\//g'

	insinto /usr/lib64/nagios/plugins/

    doins ${WORKDIR}/${P}/misc/nagios_autodiscover
    doins ${WORKDIR}/${P}/misc/check_tftp.py
    doins ${WORKDIR}/${P}/misc/check_snmp_tcpconnection.sh
    doins ${WORKDIR}/${P}/misc/check_ports
    doins ${WORKDIR}/${P}/misc/check_oracle_query.py
    doins ${WORKDIR}/${P}/misc/check_mssql_query.py
    doins ${WORKDIR}/${P}/crit2warn.sh/crit2warn.sh
    doins ${WORKDIR}/${P}/check_yum/sudoers.d/check_yum
    doins ${WORKDIR}/${P}/check_yum/nrpe.d/check_yum.cfg
    doins ${WORKDIR}/${P}/check_yum/check_yum
    doins ${WORKDIR}/${P}/check_windows_dfs.pl/check_windows_dfs.pl
    doins ${WORKDIR}/${P}/check_vmware/check_vmware_wbem
    doins ${WORKDIR}/${P}/check_uptime/nrpe.d/check_uptime.cfg
    doins ${WORKDIR}/${P}/check_uptime/check_uptime.sh
    doins ${WORKDIR}/${P}/check_time/nrpe.d/check_time.cfg
    doins ${WORKDIR}/${P}/check_time/check_time.sh
    doins ${WORKDIR}/${P}/check_squid/check_squid.pl
    doins ${WORKDIR}/${P}/check_snmp/check_snmp_temperature.pl
    doins ${WORKDIR}/${P}/check_snmp/check_snmp_patchlevel.pl
    doins ${WORKDIR}/${P}/check_snmp/check_snmp_mem.pl
    doins ${WORKDIR}/${P}/check_snmp/check_snmp_load.pl
    doins ${WORKDIR}/${P}/check_snmp/check_snmp_interfaces
    doins ${WORKDIR}/${P}/check_snmp/check_snmp_int.pl
    doins ${WORKDIR}/${P}/check_snmp/check_snmp_env.pl
    doins ${WORKDIR}/${P}/check_snmp/check_snmp_cpfw.pl
    doins ${WORKDIR}/${P}/check_snmp/check_snmp_connectivity
    doins ${WORKDIR}/${P}/check_smssend/nrpe.d/check_smssend.cfg
    doins ${WORKDIR}/${P}/check_smssend/check_smssend
    doins ${WORKDIR}/${P}/check_selinux/check_selinux
    doins ${WORKDIR}/${P}/check_rhcs/nrpe.d/check_rhcs.cfg
    doins ${WORKDIR}/${P}/check_rhcs/check_rhcs_manualfencing.sh
    doins ${WORKDIR}/${P}/check_rhcs/check_rhcs_fence
    doins ${WORKDIR}/${P}/check_rhcs/check_rhcs_cman_group.sh
    doins ${WORKDIR}/${P}/check_rhcs/check_rhcs
    doins ${WORKDIR}/${P}/check_proc/check_procs.sh
    doins ${WORKDIR}/${P}/check_package_updates/nrpe.d/check_package_updates.cfg
    doins ${WORKDIR}/${P}/check_package_updates/check_package_updates
    doins ${WORKDIR}/${P}/check_nagios/nrpe.d/check_nagios.cfg
    doins ${WORKDIR}/${P}/check_nagios/check_nagios_plugin_existance
    doins ${WORKDIR}/${P}/check_nagios/check_nagios_needs_reload
    doins ${WORKDIR}/${P}/check_nagios/check_nagios_ghostservices
    doins ${WORKDIR}/${P}/check_nagios/check_nagios_configuration
    doins ${WORKDIR}/${P}/check_multipath/nrpe.d/check_multipath.cfg
    doins ${WORKDIR}/${P}/check_multipath/nagios-okplugin-check_multipath-0.0.3-1.el6.x86_64.rpm
    doins ${WORKDIR}/${P}/check_multipath/nagios-okplugin-check_multipath-0.0.3-1.el6.src.rpm
    doins ${WORKDIR}/${P}/check_multipath/check_multipath
    doins ${WORKDIR}/${P}/check_mtr/check_mtr
    doins ${WORKDIR}/${P}/check_msa_hardware-pl/check_msa_hardware-pl
    doins ${WORKDIR}/${P}/check_linux_modules.pl/nrpe.d/check_module.cfg
    doins ${WORKDIR}/${P}/check_linux_modules.pl/check_linux_modules.pl
    doins ${WORKDIR}/${P}/check_kerb.sh/check_kerb.sh
    doins ${WORKDIR}/${P}/check_ironport/xml.status
    doins ${WORKDIR}/${P}/check_ironport/check_ironport.py
    doins ${WORKDIR}/${P}/check_ironport/check_ironport
    doins ${WORKDIR}/${P}/check_ipa/nrpe.d/check_ipa.cfg
    doins ${WORKDIR}/${P}/check_ipa/check_ipa_replication
    doins ${WORKDIR}/${P}/check_ifoperstate/check_ifoperstate
    doins ${WORKDIR}/${P}/check_ibm_bladecenter/check_ibm_bladecenter.py
    doins ${WORKDIR}/${P}/check_http_ntlm/check_http_ntlm.pl
    doins ${WORKDIR}/${P}/check_http_multi/check_http_multi
    doins ${WORKDIR}/${P}/check_hpasm/sudoers.d/check_hpasm
    doins ${WORKDIR}/${P}/check_hpasm/nrpe.d/check_hpasm.cfg
    doins ${WORKDIR}/${P}/check_hpasm/check_hpasm
    doins ${WORKDIR}/${P}/check_hparray/check_hparray.cfg
    doins ${WORKDIR}/${P}/check_hparray/check_hparray
    doins ${WORKDIR}/${P}/check_hpacucli/sudoers.d/check_hpacucli
    doins ${WORKDIR}/${P}/check_hpacucli/nrpe.d/check_hpacucli.cfg
    doins ${WORKDIR}/${P}/check_hpacucli/check_hpacucli.py
    doins ${WORKDIR}/${P}/check_exchange/check_exchange_storagegroups.pl
    doins ${WORKDIR}/${P}/check_eva/nrpe.d/check_eva.cfg
    doins ${WORKDIR}/${P}/check_eva/check_eva.py
    doins ${WORKDIR}/${P}/check_emc_clariion/status.cli
    doins ${WORKDIR}/${P}/check_emc_clariion/checkcommands.cfg
    doins ${WORKDIR}/${P}/check_emc_clariion/check_emc_clariion.pl
    doins ${WORKDIR}/${P}/check_emc_clariion/check_emc_centera.pl
    doins ${WORKDIR}/${P}/check_emc_clariion/capacity.cli
    doins ${WORKDIR}/${P}/check_drbd/nrpe.d/check_drbd.cfg
    doins ${WORKDIR}/${P}/check_drbd/check_drbd
    doins ${WORKDIR}/${P}/check_disks.pl/check_disks.pl
    doins ${WORKDIR}/${P}/check_dataprotector/nrpe.d/check_dataprotector.cfg
    doins ${WORKDIR}/${P}/check_dataprotector/check_dp_tablespace.sh
    doins ${WORKDIR}/${P}/check_dataprotector/check_dp_tablespace
    doins ${WORKDIR}/${P}/check_dataprotector/check_dp_services
    doins ${WORKDIR}/${P}/check_dataprotector/check_dp_pool
    doins ${WORKDIR}/${P}/check_dataprotector/check_dp_mountrequest
    doins ${WORKDIR}/${P}/check_dataprotector/check_dp_idb
    doins ${WORKDIR}/${P}/check_dataprotector/check_dp_backups
    doins ${WORKDIR}/${P}/check_cpu.sh/nrpe.d/check_cpu.cfg
    doins ${WORKDIR}/${P}/check_cpu.sh/check_cpu.sh
    doins ${WORKDIR}/${P}/check_cisco_qos/check_cisco_qos.sh
    doins ${WORKDIR}/${P}/check_cisco_qos/check_cisco_qos.pl
    doins ${WORKDIR}/${P}/check_cifs/check_cifs
    doins ${WORKDIR}/${P}/check_ccm/check_ccm.py
    doins ${WORKDIR}/${P}/check_brocade/examples/services.cfg
    doins ${WORKDIR}/${P}/check_brocade/examples/servicegroups.cfg
    doins ${WORKDIR}/${P}/check_brocade/examples/hosts.cfg
    doins ${WORKDIR}/${P}/check_brocade/examples/hostgroups.cfg
    doins ${WORKDIR}/${P}/check_brocade/examples/contactgroups.cfg
    doins ${WORKDIR}/${P}/check_brocade/examples/commands.cfg
    doins ${WORKDIR}/${P}/check_brocade/check_brocade_interfaces.py
    doins ${WORKDIR}/${P}/check_brocade/check_brocade_env
    doins ${WORKDIR}/${P}/check_bond/nrpe.d/check_bond.cfg
    doins ${WORKDIR}/${P}/check_bond/check_bond
    doins ${WORKDIR}/${P}/check_bl/check_bl
    doins ${WORKDIR}/${P}/check_apcext.pl/check_snmp_apc_ups
    doins ${WORKDIR}/${P}/check_apcext.pl/check_apcext.pl
}

pkg_postinst() {
	elog "See: https://github.com/opinkerfi/nagios-plugins/ for individual plugin configuration options"
}
