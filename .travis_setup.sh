#!/bin/sh

if [[ $TRAVIS != true ]]; then
  echo 'not in a Travis environment (check $TRAVIS)'
  exit 1
fi

export TRAVIS_SECURE_ENV_VARS=true
SCRIPT_ROOT=`pwd`

install_moonscript() {
  git clone https://github.com/cahna/moonscript.git -b moonc-behavior-tests ./moonscript
  cd moonscript
  sudo luarocks make
  cd "$SCRIPT_ROOT"
  rm -rf moonscript
}

install_openresty() {
  git clone https://github.com/openresty/ngx_openresty.git 
  cd ngx_openresty
  make
  cd ngx_openresty*
  ./configure --with-luajit --with-http_postgres_module -j4
  make
  sudo make install
  cd "$SCRIPT_ROOT"
  rm -rf ngx_openresty
}

install_moonscript
install_openresty

