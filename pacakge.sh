# pip
cat <<EOF > ~/pip/pip.conf
[global]
index-url = https://mirrors.aliyun.com/pypi/simple/

[install]
trusted-host=mirrors.aliyun.com
EOF

# composer
composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

# npm
echo '\n#alias for cnpm\nalias cnpm="npm --registry=https://registry.npm.taobao.org \
  --cache=$HOME/.npm/.cache/cnpm \
  --disturl=https://npm.taobao.org/dist \
  --userconfig=$HOME/.cnpmrc"' >> ~/.bashrc && source ~/.bashrc
  
  
# golang
export GOPROXY=https://mirrors.aliyun.com/goproxy/
