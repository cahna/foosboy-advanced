FROM ubuntu:14.04
MAINTAINER Conor Heine <conor.heine@gmail.com>
RUN apt-get -qq update
RUN apt-get -qy upgrade
RUN apt-get -qy install build-essential git luajit luarocks libpq5 libpq-dev
RUN apt-get -qy install libpcre3 libpcre3-dev pcregrep libpcre++0
RUN luarocks install moonscript
RUN luarocks install lapis 
RUN luarocks install busted
RUN git clone https://github.com/openresty/ngx_openresty.git /tmp/ngx
RUN cd /tmp/ngx && make && cd ngx_openresty* && ./configure --with-luajit --with-http_postgres_module -j4 && make && make install

