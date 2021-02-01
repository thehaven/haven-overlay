#!/bin/bash
set -e
set -o pipefail

################### Description ###############################
# basic shell script to create swap space on the hosts
#
################### Verified Platforms ########################
# ubuntu 16.04
###############################################################

readonly MAX_FILE_DESCRIPTORS=90000
readonly MAX_WATCHERS=524288

update_descriptor_limits() {
  echo "fs.file-max=$MAX_FILE_DESCRIPTORS" | tee -a /etc/sysctl.conf
  echo "*   hard  nofile  $MAX_FILE_DESCRIPTORS" | tee -a /etc/security/limits.conf
  echo "*   soft  nofile  $MAX_FILE_DESCRIPTORS" | tee -a /etc/security/limits.conf
  echo "*   hard  nproc $MAX_FILE_DESCRIPTORS" | tee -a /etc/security/limits.conf
  echo "*   hard  nproc $MAX_FILE_DESCRIPTORS" | tee -a /etc/security/limits.conf
}

update_watchers() {
  echo $MAX_WATCHERS | tee -a /proc/sys/fs/inotify/max_user_watches
  echo "fs.inotify.max_user_watches=$MAX_WATCHERS" | tee -a /etc/sysctl.conf
}

update_network_limits() {
  echo "net.ipv4.ip_forward = 1" | tee -a /etc/sysctl.conf
}

refresh_settings() {
  sysctl -p
}

main() {
  update_descriptor_limits
  update_watchers
  update_network_limits
  refresh_settings
}

main
