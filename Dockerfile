#Add FROM
FROM centos:9.0
LABEL maintainer="Ahmed F <ahmed.fathy@gmail.com>"
LABEL role="Nginx with LUA"
ENV DEVEL_KIT_MODULE_VERSION="0.3.1"
ENV LUA_MODULE_VERSION="0.10.21"
ENV NGINX_VERSION="1.21.6"
ENV LANG="en_US.UTF-8"
RUN apk update && apk add --no-cache luajit && \
# CONFIG="--prefix=/etc/nginx \
# --sbin-path=/usr/sbin/nginx 		\ 
# --modules-path=/usr/lib/nginx/modules 		\ 
# --conf-path=/etc/nginx/nginx.conf 		\ 
# --error-log-path=/var/log/nginx/error.log 		\ 
# --http-log-path=/var/log/nginx/access.log 		\ 
# --pid-path=/var/run/nginx.pid 		\ 
# --lock-path=/var/run/nginx.lock 		\ 
# --http-client-body-temp-path=/var/cache/nginx/client_temp 		\ 
# --http-proxy-temp-path=/var/cache/nginx/proxy_temp 		\ 
# --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp 		\ 
# --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp 		\ 
# --http-scgi-temp-path=/var/cache/nginx/scgi_temp 		\ 
# --user=nginx 		\ 
# --group=nginx 		\ 
# --with-http_ssl_module 		\ 
# --with-http_realip_module 		\ 
# --with-http_addition_module 		\ 
# --with-http_sub_module 		\ 
# --with-http_dav_module 		\ 
# --with-http_flv_module 		\ 
# --with-http_mp4_module 		\ 
# --with-http_gunzip_module 		\ 
# --with-http_gzip_static_module 		\ 
# --with-http_random_index_module 		\ 
# --with-http_secure_link_module 		\ 
# --with-http_stub_status_module 		\ 
# --with-http_auth_request_module 		\ 
# --with-http_xslt_module=dynamic		\ 
# --with-http_image_filter_module=dynamic		\ 
# --with-http_geoip_module 		\ 
# --with-http_perl_module=dynamic 		\ 
# --with-threads 		\ 
# --with-stream 		\ 
# --with-stream_ssl_module 		\ 
# --with-stream_geoip_module=dynamic 		\ 
# --with-http_slice_module 		\ 
# --with-mail 		\ 
# --with-mail_ssl_module 		\ 
# --with-file-aio 		\ 
# --with-http_v2_module 		\ 
# --with-ipv6 		\ 
# --add-module=/usr/src/ngx_devel_kit-$DEVEL_KIT_MODULE_VERSION 		\ 
# --add-module=/usr/src/lua-nginx-module-$LUA_MODULE_VERSION " && \
CONFIG="--prefix=/etc/nginx --sbin-path=/usr/sbin/nginx    --modules-path=/usr/lib/nginx/modules    --conf-path=/etc/nginx/nginx.conf    --error-log-path=/var/log/nginx/error.log    --http-log-path=/var/log/nginx/access.log    --pid-path=/var/run/nginx.pid    --lock-path=/var/run/nginx.lock    --http-client-body-temp-path=/var/cache/nginx/client_temp    --http-proxy-temp-path=/var/cache/nginx/proxy_temp    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp    --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp    --http-scgi-temp-path=/var/cache/nginx/scgi_temp    --user=nginx    --group=nginx    --with-http_ssl_module    --with-http_realip_module    --with-http_addition_module    --with-http_sub_module    --with-http_dav_module    --with-http_flv_module    --with-http_mp4_module    --with-http_gunzip_module    --with-http_gzip_static_module    --with-http_random_index_module    --with-http_secure_link_module    --with-http_stub_status_module    --with-http_auth_request_module    --with-http_xslt_module=dynamic   --with-http_image_filter_module=dynamic   --with-http_geoip_module    --with-http_perl_module=dynamic    --with-threads    --with-stream    --with-stream_ssl_module    --with-stream_geoip_module=dynamic    --with-http_slice_module    --with-mail    --with-mail_ssl_module    --with-file-aio    --with-http_v2_module    --with-ipv6    --add-module=/usr/src/ngx_devel_kit-0.3.1    --add-module=/usr/src/lua-nginx-module-0.10.21" && \
echo $CONFIG  && \
addgroup -S nginx 	&& \
adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx && \
apk add --no-cache --virtual .build-deps gcc libc-dev \
make openssl-dev pcre-dev zlib-dev linux-headers curl gnupg  libxslt-dev gd-dev geoip-dev perl-dev luajit-dev && \  
    curl -fSL http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz -o nginx.tar.gz && \
curl -fSL http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz.asc  -o nginx.tar.gz.asc 	&& \
curl -fSL https://github.com/vision5/ngx_devel_kit/archive/refs/tags/v$DEVEL_KIT_MODULE_VERSION.tar.gz -o ndk.tar.gz 	&& \
curl -fSL https://github.com/openresty/lua-nginx-module/archive/refs/tags/v$LUA_MODULE_VERSION.tar.gz -o lua.tar.gz && \
mkdir -p /usr/src 	&& \
tar -zxC /usr/src -f nginx.tar.gz 	&& \
tar -zxC /usr/src -f ndk.tar.gz 	&& \
tar -zxC /usr/src -f lua.tar.gz 	&& \
rm nginx.tar.gz ndk.tar.gz lua.tar.gz 	&& \
cd /usr/src/nginx-$NGINX_VERSION && \
export LUAJIT_LIB=/usr/lib/ && \
export LUAJIT_INC=/usr/include/luajit-2.1/ && \
./configure $CONFIG --with-debug && \
make -j$(getconf _NPROCESSORS_ONLN) && \
mv objs/nginx objs/nginx-debug 	&& \
mv objs/ngx_http_xslt_filter_module.so objs/ngx_http_xslt_filter_module-debug.so 	&& \
mv objs/ngx_http_image_filter_module.so objs/ngx_http_image_filter_module-debug.so 	&& \
mv objs/ngx_http_perl_module.so objs/ngx_http_perl_module-debug.so 	&& \
mv objs/ngx_stream_geoip_module.so objs/ngx_stream_geoip_module-debug.so && \
./configure $CONFIG 	&& \
make -j$(getconf _NPROCESSORS_ONLN) 	&& \
make install && \
rm -rf /etc/nginx/html/ 	&& \
mkdir /etc/nginx/conf.d/ 	&& \
mkdir -p /usr/share/nginx/html/ 	&& \
install -m644 html/index.html /usr/share/nginx/html/ 	&& \
install -m644 html/50x.html /usr/share/nginx/html/ 	&& \
install -m755 objs/nginx-debug /usr/sbin/nginx-debug 	&& \
install -m755 objs/ngx_http_xslt_filter_module-debug.so /usr/lib/nginx/modules/ngx_http_xslt_filter_module-debug.so 	&& \
install -m755 objs/ngx_http_image_filter_module-debug.so /usr/lib/nginx/modules/ngx_http_image_filter_module-debug.so 	&& \
install -m755 objs/ngx_http_perl_module-debug.so /usr/lib/nginx/modules/ngx_http_perl_module-debug.so 	&& \
install -m755 objs/ngx_stream_geoip_module-debug.so /usr/lib/nginx/modules/ngx_stream_geoip_module-debug.so && \
ln -s ../../usr/lib/nginx/modules /etc/nginx/modules 	&& \
strip /usr/sbin/nginx* 	&& strip /usr/lib/nginx/modules/*.so 	&& \
rm -rf /usr/src/nginx-$NGINX_VERSION 		&& \
apk add --no-cache --virtual .gettext gettext 	&& \
mv /usr/bin/envsubst /tmp/ 		&& \
runDeps="$(scanelf --needed --nobanner /usr/sbin/nginx /usr/lib/nginx/modules/*.so /tmp/envsubst | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' 			| sort -u 			| xargs -r apk info --installed 			| sort -u 	)" 	&& \
apk add --no-cache --virtual .nginx-rundeps $runDeps 	&& \
apk del .build-deps 	&& apk del .gettext 	&& \
mv /tmp/envsubst /usr/local/bin/ 		&& \
ln -sf /dev/stdout /var/log/nginx/access.log 	&& \
ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]
