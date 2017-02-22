#
# https://www.phpmyadmin.net/downloads/
#
# $VERSION is an environment variable and can be any version available via the downloads page at https://www.phpmyadmin.net/downloads//
# i.e.: 4.6.6 or 4.7.0-beta1
#
FROM appsoa/docker-centos-base-php70
LABEL maintainer    = "Matthew Davis <matthew@appsoa.io>"
LABEL repository    = appsoa
LABEL image         = docker-centos-webapp-magento
LABEL built_at      = 0000-00-00 00:00:00

ENV MAGENTO_VERSION=2.1.4
ENV FILE_NAME=$MAGENTO_VERSION

COPY /entrypoint.sh /
COPY /entrypoint.d/* /entrypoint.d/
# ONBUILD COPY /entrypoint.d/* /entrypoint.d/
#
# Declare /www as a VOLUME to persist data between restarts.
# On the host side you'll need to specify the local directory
#
# Optionally, you can create a separate disk image to persist data externally.
#
# VOLUME /www
#
# Download Magento2.x.x source from github & extract to disk.
#
# WORKDIR /magento
RUN mkdir /magento && \
    curl https://codeload.github.com/magento/magento2/tar.gz/$MAGENTO_VERSION -o $FILE_NAME.tar.gz && \
# RUN wget https://codeload.github.com/magento/magento2/tar.gz/$MAGENTO_VERSION -o $FILE_NAME.tar.gz && \
    tar -xzf $FILE_NAME.tar.gz -C /magento  --strip-components=1 && \
    # tar -xzvf $FILE_NAME.tar.gz && \
    # ls /magento && \
    # rm -rf $FILE_NAME.tar.gz && \
    # mv $FILE_NAME /www && \
    # cp -R $FILE_NAME /www && \
    cp -R -f /magento/{*,*.*} /www/ && \
    chown -R nginx:nginx /www && \
    rm -rf /magento 

#
# Install php libraries with composer.
#
USER nginx
WORKDIR /www
RUN composer install

EXPOSE 80

# USER root
WORKDIR /
ENTRYPOINT ["/entrypoint.sh"]