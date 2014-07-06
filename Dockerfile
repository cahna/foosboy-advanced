# Docker container for lapis web applications

FROM ubuntu:14.04
MAINTAINER Conor Heine <conor.heine@gmail.com>

# Install dependencies
RUN apt-get -qq update
RUN apt-get -qy upgrade
RUN apt-get -qy install build-essential git luajit luarocks libpq5 libpq-dev
RUN apt-get -qy install openssl libpcre3 libpcre3-dev pcregrep libpcre++0
RUN luarocks install luasec OPENSSL_LIBDIR=/usr/lib/x86_64-linux-gnu
RUN luarocks install moonscript
RUN luarocks install lapis 
RUN luarocks install busted 1.11.0
RUN git clone https://github.com/openresty/ngx_openresty.git /tmp/ngx && \
  cd /tmp/ngx && \
  make && \
  cd ngx_openresty* && \
  ./configure --with-luajit --with-http_postgres_module -j4 && \
  make && \
  make install

WORKDIR /usr/src/app
EXPOSE 8080

VOLUME /usr/src/app/logs
VOLUME /usr/src/app/fastcgi_temp
VOLUME /usr/src/app/client_body_temp
VOLUME /usr/src/app/scgi_temp
VOLUME /usr/src/app/uwsgi_temp
VOLUME /usr/src/app/proxy_temp

CMD lapis build production && lapis server production

