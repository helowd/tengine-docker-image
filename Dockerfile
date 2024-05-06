FROM centos:7.9.2009

ENV TENGINE_VERSION 3.0.0

ENV CONFIG "\
        --prefix=/usr/local/nginx \
        --add-module=modules/ngx_http_reqstat_module \
        --add-module=modules/ngx_http_upstream_check_module \
        "

WORKDIR /opt/tengine

RUN yum install -y gcc pcre pcre-devel openssl openssl-devel \
        && curl -L "https://github.com/alibaba/tengine/archive/$TENGINE_VERSION.tar.gz" -o tengine.tar.gz \
        && mkdir -p /usr/local/src \
        && tar -zxC /usr/local/src -f tengine.tar.gz \
        && rm tengine.tar.gz \
        && cd /usr/local/src/tengine-$TENGINE_VERSION \
        && ./configure $CONFIG \
        && make \
        && make install \
	&& mkdir -p /usr/local/nginx/conf/conf.d

COPY nginx.conf /usr/local/nginx/conf/nginx.conf
COPY conf.d/default.conf /usr/local/nginx/conf/conf.d/default.conf

EXPOSE 80 443

CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
