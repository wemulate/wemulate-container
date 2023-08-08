FROM ubuntu
ARG S6_OVERLAY_VERSION=3.1.5.0

RUN apt-get update && apt-get install -y nginx xz-utils python3 python3-pip unzip curl wget && \
    rm -f /etc/nginx/sites-enabled/default && \
    rm -f /etc/nginx/sites-available/default && \
    rm -f /var/www/html/index.nginx-debian.html

RUN curl -sSL https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz | tar -Jxpf - -C /  && \
	curl -sSL https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-i686.tar.xz | tar -Jxpf - -C /
ADD s6-rc.d /etc/s6-overlay/s6-rc.d
# ADD cont-init.d /etc/cont-init.d
ADD wemulate_init.sh wemulate_init.sh
ADD nginx.conf /etc/nginx/nginx.conf

ENTRYPOINT ["/init"]
    

# Install wemulate, wemulate-api and wemulate-frontend
RUN pip3 install wemulate wemulate-api && \
    wget -O /var/www/html/release.zip https://github.com/wemulate/wemulate-frontend/releases/latest/download/release.zip && \
    unzip -o -q /var/www/html/release.zip -d /var/www/html/ && \
    rm -f /var/www/html/release.zip

# see all original env vars in all processes
ENV S6_KEEP_ENV=1

ENV MGMT_INTERFACE=eth0

EXPOSE 80 8080 

CMD ["bash"]