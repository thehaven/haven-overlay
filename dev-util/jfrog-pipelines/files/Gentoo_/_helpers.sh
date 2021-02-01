#!/bin/bash -e

# Helper methods ##########################################
###########################################################

export PLATFORM_DEPENDENCIES_DIR="$DEPENDENCIES_DIR/x86_64"

__install_python() {
  ################## Install python ######################################
  if type python &> /dev/null && true; then
    log_proc_msg "'python' already installed"
    local required_python_version=2.7
    local installed_python_version=$(python -c 'import sys; major, minor, patch = sys.version_info[:3]; print("{0}.{1}.{2}".format(major, minor, patch))')

    check_semver $installed_python_version
    log_proc_msg "Found Python version $installed_python_version"

    if compare_semver $installed_python_version $required_python_version; then
      log_proc_error "The installed version of Python is not supported. Python should be version $required_python_version"
      exit 1
    fi

    local installed_python_major_version=$(python -c 'import sys; print(sys.version_info[0])')
    if [ "$installed_python_major_version" != "2" ]; then
      log_proc_error "The installed version of Python is not supported. Python should be version $required_python_version"
      exit 1
    fi
  else
    log_proc_msg "Installing 'python'"
    apt-get install -y python
    # This fails the first time for some reason
    # local python_zip="$PLATFORM_DEPENDENCIES_DIR/deb/python2.7_2.tar.gz"
    # local python_deb="$TMP_DIR/python"
    # mkdir -p "$python_deb"
    # tar -xvzf "$python_zip" -C "$python_deb"
    # pushd $python_deb
    # log_proc_msg "Installing python from dir: $python_deb"
    # dpkg -i *.deb
    # popd
  fi
}

__install_jq() {
  ################## Install jq  #########################################
  if type jq &> /dev/null && true; then
    log_proc_msg "'jq' already installed"
    local required_jq_version=1.5
    local installed_jq_version=$(jq --version | cut -d '-' -f 2)

    check_semver $installed_jq_version
    log_proc_msg "Found jq version $installed_jq_version"

    if compare_semver $installed_jq_version $required_jq_version; then
      log_proc_error "The installed version of jq is not supported. jq should be at least version $required_jq_version"
      exit 1
    fi
  else
    log_proc_msg "Installing 'jq'"
    local jq_location="$PLATFORM_DEPENDENCIES_DIR/bin/jq"
    cp -vr "$jq_location" "/usr/bin/jq"
  fi
}

__install_yq() {
  ################## Install yq #######################################
  if type yq &> /dev/null && true; then
    log_proc_msg "'yq' already installed"
    local required_yq_version=2.4.0
    local installed_yq_version=$(yq --version | cut -d ' ' -f 3)

    check_semver $installed_yq_version
    log_proc_msg "Found yq version $installed_yq_version"

    if compare_semver $installed_yq_version $required_yq_version; then
      log_proc_error "The installed version of yq is not supported. yq should be at least version $required_yq_version"
      exit 1
    fi
  else
    log_proc_msg "Installing 'yq'"
    local yq_location="$PLATFORM_DEPENDENCIES_DIR/bin/yq"
    cp -vr "$yq_location" "/usr/bin/yq"
  fi
}

__install_curl() {
  ################## Install curl  #######################################
  if type curl &> /dev/null && true; then
    log_proc_msg "'curl' already installed"
    local required_curl_version=7.29.0
    local installed_curl_version=$(curl --version | head -n 1 | cut -d ' ' -f 2)

    check_semver $installed_curl_version
    log_proc_msg "Found curl version $installed_curl_version"

    if compare_semver $installed_curl_version $required_curl_version; then
      log_proc_error "The installed version of curl is not supported. curl should be at least version $required_curl_version"
      exit 1
    fi
  else
    log_proc_msg "Installing 'curl'"
    local curl_zip="$PLATFORM_DEPENDENCIES_DIR/deb/curl_7.47.tar.gz"
    local curl_deb="$TMP_DIR/curl"
    mkdir -p "$curl_deb"
    tar -xvzf "$curl_zip" -C "$curl_deb"
    pushd $curl_deb
    dpkg -i *.deb
    popd
  fi
}

__install_nc() {
  ################## Install netcat #######################################
  if type nc &> /dev/null && true; then
    log_proc_msg "'netcat' already installed"
  else
    log_proc_msg "Installing 'netcat'"
    local nc_zip="$PLATFORM_DEPENDENCIES_DIR/deb/nc1.10.tar.gz"
    local nc_deb="$TMP_DIR/nc"
    mkdir -p "$nc_deb"
    tar -xvzf "$nc_zip" -C "$nc_deb"
    pushd $nc_deb
    dpkg -i *.deb
    popd
  fi

}

__install_psql() {
  if type psql &> /dev/null && true; then
    log_proc_msg "'psql' already installed"
    local required_psql_version=9.5
    local installed_psql_version=$(psql --version | cut -d ' ' -f 3)

    check_semver $installed_psql_version
    log_proc_msg "Found psql version $installed_psql_version"

    if compare_semver $installed_psql_version $required_psql_version; then
      log_proc_error "The installed version of psql is not supported. psql should be at least version $required_psql_version"
      exit 1
    fi
  else
    log_proc_msg "Installing psql 9.5"
    tar -xzf $PLATFORM_DEPENDENCIES_DIR/zip/postgresql-9.5.17-1-linux-x64-binaries.tar.gz  -C $TMP_DIR
    mv $TMP_DIR/pgsql/bin/* /usr/local/bin
    mv $TMP_DIR/pgsql/lib/* /usr/local/lib

    log_proc_msg "psql 9.5 successfully installed"
  fi
}

__install_docker() {
  ################## Install Docker  #####################################
  if type docker &> /dev/null && true; then
    log_proc_msg "'docker' already installed"
    local required_docker_version=dev
    local installed_docker_version=$(docker version --format {{.Server.Version}})

    check_semver $installed_docker_version
    log_proc_msg "Found docker version $installed_docker_version"

    if compare_semver $installed_docker_version $required_docker_version; then
      log_proc_error "The installed version of docker is not supported. Docker should be at least version $required_docker_version"
      exit 1
    fi
  else
    log_proc_error "'docker' not installed. Please install docker to continue installation"
    exit 1
  fi
}

__install_docker_compose() {
  log_proc_msg "Installing docker compose"
  if type docker-compose &> /dev/null && true; then
    log_proc_msg "'docker-compose' already installed"
    local required_compose_version=1.24
    local installed_compose_version=$(docker-compose version --short)

    check_semver $installed_compose_version
    log_proc_msg "Found docker-compose version $installed_compose_version"

    if compare_semver $installed_compose_version $required_compose_version; then
      log_proc_error "The installed version of docker-compose is not supported. Docker Compose should be at least version $required_compose_version"
      exit 1
    fi
  else
    local compose_binary="$PLATFORM_DEPENDENCIES_DIR/bin/docker-compose"
    cp -vr $compose_binary /usr/local/bin/docker-compose
    docker-compose --version
  fi
}

install_dependencies() {
  log_proc_marker "Installing dependencies"
  #__install_docker
  if [ "$EUID" -ne 0 ]; then
    log_proc_warn "Skipping dependency installation since user doesn't have admin privileges"
  else
    __install_python
    #__install_jq
    #__install_yq
    __install_curl
    __install_nc
    __install_psql
    __install_docker_compose
  fi
}

pull_service_images() {
  if [ "$SKIP_IMAGE_PULL" == true ]; then
    return
  fi

  log_proc_marker "Pulling service images"
  local image_tag="$PIPELINES_CORE_CONTROLPLANEVERSION"
  if [ ! -z "$1" ]; then
    image_tag="$1"
  fi

  if check_db_variables; then
    # Installing database
    docker pull "$PIPELINES_CORE_REGISTRYURL/$PIPELINES_SHARED_DB_IMAGE:$image_tag"
  fi

  docker pull "$PIPELINES_CORE_REGISTRYURL/$PIPELINES_SHARED_ROUTER_IMAGE:$image_tag"
  docker pull "$PIPELINES_CORE_REGISTRYURL/$PIPELINES_SHARED_VAULT_IMAGE:$image_tag"
  docker pull "$PIPELINES_CORE_REGISTRYURL/$PIPELINES_SHARED_MSG_IMAGE:$image_tag"
  docker pull "$PIPELINES_CORE_REGISTRYURL/$PIPELINES_SHARED_REDIS_IMAGE:$image_tag"
  docker pull "$PIPELINES_CORE_REGISTRYURL/$PIPELINES_CORE_INSTALLERIMAGE:$image_tag"
  docker pull "$PIPELINES_CORE_REGISTRYURL/$PIPELINES_CORE_SERVICES_API_IMAGE:$image_tag"
  docker pull "$PIPELINES_CORE_REGISTRYURL/$PIPELINES_CORE_SERVICES_WWW_IMAGE:$image_tag"
  docker pull "$PIPELINES_CORE_REGISTRYURL/$PIPELINES_CORE_SERVICES_PIPELINESYNC_IMAGE:$image_tag"

  log_proc_marker "All images pulled successfully"
}
