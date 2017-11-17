#!/usr/bin/env bash

set -eu

update_nginx_configuration() {
  local app=$1
  local nginx_config_template=$2
  local domain=$3
  local path=$4
  local deploy_path=$5

  sed --in-place "s@YNH_WWW_PATH@${path}@g" ${nginx_config_template}
  sed --in-place "s@YNH_WWW_ALIAS@${deploy_path}/@g" ${nginx_config_template}

  sudo cp ${nginx_config_template} /etc/nginx/conf.d/${domain}.d/${app}.conf
  sudo service nginx reload
}

update_accessibility() {
  local app=$1
  local is_public=$2

  if [[ ${is_public:-0} -eq 1 ]]; then
    ynh_app_setting_set $app unprotected_uris "/"
    sudo yunohost app ssowatconf
  fi
}
