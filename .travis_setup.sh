#!/bin/sh

# Install openresty
git clone https://github.com/openresty/ngx_openresty.git 
cd ngx_openresty
make
cd ngx_openresty*
./configure --with-luajit --with-http_postgres_module -j4
make
sudo make install
