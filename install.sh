###########
#   OS    #
###########
source /etc/os-release
case $ID in
centos):
  install-centos-mirror
  ;;

ubuntu):
  install-ubuntu-mirror
  ;;
  
debian):
  install-debian-mirror
  ;;
  
alpine):
  install-alpine-mirror
  ;;


function install-centos-mirror {
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

function install-ubuntu-mirror {
  sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
  apt update
}

function install-debian-mirror {
#TODO
  apt update
}

function install-alpine-mirror {
#TODO
  apk update
}


###########
# package #
###########

# pip
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
