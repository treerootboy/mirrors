#!/bin/bash
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

  yum update
}

install_ubuntu_mirror() {
  sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
  apt update
}

install_debian_mirror() {
  curl -o /etc/apt/sources.list https://raw.githubusercontent.com/treerootboy/mirrors/master/os/debian/$VERSION_ID
  apt update
}

install_alpine_mirror() {
  sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
  apk update
}

###########
#   OS    #
###########
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

# pip
mkdir ~/pip
cat <<EOF > ~/pip/pip.conf
 [global]
 index-url = https://mirrors.aliyun.com/pypi/simple/

 [install]
 trusted-host=mirrors.aliyun.com
EOF

# composer
which composer && composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

# npm
echo '\n#alias for cnpm\nalias cnpm="npm --registry=https://registry.npm.taobao.org \
  --cache=$HOME/.npm/.cache/cnpm \
  --disturl=https://npm.taobao.org/dist \
  --userconfig=$HOME/.cnpmrc"' >> ~/.bashrc && source ~/.bashrc


# golang
export GOPROXY=https://mirrors.aliyun.com/goproxy/
