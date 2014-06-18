#!/bin/sh

SCRIPT_ROOT=`pwd`

install_moonscript() {
  git clone https://github.com/cahna/moonscript.git
  cd moonscript
  sudo luarocks make
  cd "$SCRIPT_ROOT"
}

install_openresty() {
  git clone https://github.com/openresty/ngx_openresty.git 
  cd ngx_openresty
  make
  cd ngx_openresty*
  ./configure --with-luajit --with-http_postgres_module -j4
  make
  sudo make install
}

install_moonscript
install_openresty

