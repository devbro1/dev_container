#command to build:
#docker build --tag test1:v1.1 .
#make sure to delete from docker desktop before building

FROM rockylinux:9.2.20230513

EXPOSE 80:80
EXPOSE 3000:3000

#change default shell from sh to bash
SHELL ["/bin/bash", "-c"]
WORKDIR /root/

#change timezone to eastern/toronto
RUN ln -sf /usr/share/zoneinfo/America/Toronto /etc/localtime

COPY docker/bashrc /root/.bashrc

#set SSH keys
COPY docker/ssh /root/.ssh/
RUN chmod 600 /root/.ssh/*

RUN yum clean all && yum update -y && yum autoremove -y && yum clean all

RUN yum -y install php \
    nginx postgresql\
    wget zip unzip make rsync git vim bash-completion tar epel-release dnf-utils

RUN dnf install -y http://rpms.remirepo.net/enterprise/remi-release-9.rpm
RUN dnf -y module reset php
RUN dnf -y module install php:remi-8.2

RUN dnf install -y php php-cli php-fpm php-pgsql php-mbstring php-xml php-json php-pdo php-pecl-zip php-pear gcc php-devel
RUN pecl install Xdebug

RUN yum install -y libX11 atk cups libxkbcommon libXcomposite pango alsa-lib at-spi2-core at-spi2-atk libdrm libXdamage libXfixes libXrandr libgbm \
    php-cli php-common php-fpm php-pgsql php-bcmath php-mysqlnd php-opcache php-gd php-pecl-apcu php-pecl-igbinary php-pecl-memcache php-pecl-memcached php-pecl-igbinary-devel php-soap php-sodium php-pecl-msgpack php-pecl-ssh2 php-intl \
    ImageMagick oathtool procps dos2unix

RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash \
    && . /root/.nvm/nvm.sh \
    && nvm install v20.9.0 \
    && nvm install v21.1.0 \
    && nvm use v20.9.0 \
    && npm install -g yarn

COPY docker/nginx.conf /etc/nginx/nginx.conf
RUN mkdir /run/php-fpm/

RUN sed -i 's/^display_errors = Off$/display_errors = On/' /etc/php.ini
RUN sed -i 's/^display_startup_errors = Off$/display_startup_errors = On/' /etc/php.ini
RUN sed -i 's/^upload_max_filesize = .*$/upload_max_filesize = 20M/' /etc/php.ini
RUN sed -i 's/^memory_limit = .*$/memory_limit = 3000M/' /etc/php.ini
COPY ./docker/php.d/20-xdebug.ini /etc/php.d/20-xdebug.ini

WORKDIR /root/php-composer/
RUN wget https://getcomposer.org/installer -O composer-installer.php
RUN php composer-installer.php --filename=composer --install-dir=/usr/local/bin 
RUN composer global require laravel/installer
RUN export PATH=$PATH:/root/.composer/vendor/bin

RUN git config --global user.email "meow@gmail.com"
RUN git config --global user.name "Meow Meow"
RUN git config --global core.eol lf
RUN git config --global core.autocrlf false
RUN git config --global pull.rebase false
COPY ./docker/git/ /root/.git_template/
RUN git config --global init.templatedir '~/.git_template'

WORKDIR /root/source_code/
# RUN git clone git@github.com:USERNAME/REPO_NAME.git

WORKDIR /root/
COPY docker/init_script.sh ./init_script.sh
COPY docker/run-at-start.sh ./run-at-start.sh
RUN chmod 777 /root/init_script.sh /root/run-at-start.sh .
CMD ["/root/init_script.sh"]
