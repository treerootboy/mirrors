#!/bin/bash
log_info() {
    echo -e "\033[32m$1\033[0m\n"
}

install_centos_mirror() {
  curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-$VERSION_ID.repo

  # epel 在 centos 8 有不同的处理
  if [ "$VERSION_ID" -gt 7 ]; then
    yum install -y https://mirrors.aliyun.com/epel/epel-release-latest-8.noarch.rpm
    sed -i 's|^#baseurl=https://download.fedoraproject.org/pub|baseurl=https://mirrors.aliyun.com|' /etc/yum.repos.d/epel*
    sed -i 's|^metalink|#metalink|' /etc/yum.repos.d/epel*
  else
    curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-$VERSION_ID.repo
  fi

  yum update -y
}

install_ubuntu_mirror() {
  sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
  apt update -y
}

install_debian_mirror() {
  curl -o /etc/apt/sources.list https://raw.githubusercontent.com/treerootboy/mirrors/master/os/debian/$VERSION_ID
  apt update -y
}

install_alpine_mirror() {
  sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
  apk update -y
}

###########
#   OS    #
###########
log_info "正在安装软件库镜像..."
source /etc/os-release
case $ID in
centos)
  install_centos_mirror
  ;;

ubuntu)
  install_ubuntu_mirror
  ;;

debian)
  install_debian_mirror
  ;;

alpine)
  install_alpine_mirror
  ;;
esac

###########
# package #
###########

# docker
log_info "正在设置 docker 镜像..."
mkdir -p /etc/docker
cat <<EOF > /etc/docker/daemon.json
{
  "registry-mirrors": [
    "https://nprgmgnb.mirror.aliyuncs.com"
  ]
}
EOF

# pip
log_info "正在设置 pip 镜像..."
mkdir -p ~/pip
cat <<EOF > ~/pip/pip.conf
 [global]
 index-url = https://mirrors.aliyun.com/pypi/simple/

 [install]
 trusted-host=mirrors.aliyun.com
EOF

# composer
log_info "正在设置 composer 镜像..."
which composer && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

# npm
log_info "正在设置 npm 镜像..."
if [ `grep 'registry.npm.taobao.org' ~/.bashrc -c` -eq 0 ]; then
echo '#alias for cnpm
alias cnpm="npm --registry=https://registry.npm.taobao.org
  --cache=$HOME/.npm/.cache/cnpm
  --disturl=https://npm.taobao.org/dist
  --userconfig=$HOME/.cnpmrc"' >> ~/.bashrc && source ~/.bashrc
fi


# golang
log_info "正在设置 golang 镜像..."
export GOPROXY=https://mirrors.aliyun.com/goproxy/
