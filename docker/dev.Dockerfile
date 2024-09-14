#command to build:
#docker build --tag test1:v1.1 .

FROM --platform=amd64 ubuntu:noble-20240407.1

EXPOSE 80:80
EXPOSE 3000:3000

SHELL ["/bin/bash", "-i", "-c"]
WORKDIR /root/

# preload ssh keys
COPY --chmod=600 docker/ssh /root/.ssh/

RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata
RUN apt-get install -y git nginx curl wget bash-completion oathtool jq unzip vim build-essential wkhtmltopdf gnupg software-properties-common mandoc groff
RUN apt-get install -y chromium nginx
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

COPY docker/bashrc /root/.bashrc

RUN brew install localstack terraform nvm aws-vault awscli sops gh

RUN nvm install  v22.8.0 \
    && nvm alias default v22.8.0 \
    && nvm use default \
    && npm install -g yarn \
    && yarn global add snyk nx

RUN apt install -y postgresql-client mysql-client



# RUN curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
#   gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
#   --dearmor

# RUN echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-7.0.list
# RUN apt-get update; apt-get install -y mongodb-org


# COPY docker/nginx_all_sites.conf /etc/nginx/sites-enabled/default
# COPY docker/start_all.sh /root/start_all.sh

RUN git config --global user.email "meow@devbro.com"
RUN git config --global user.name "meow meow"
RUN git config --global core.eol lf
RUN git config --global core.autocrlf false
RUN git config --global pull.rebase false

# RUN aws configure set region ca-central-1
WORKDIR /root/source_code/
WORKDIR /root/
COPY docker/init_script.sh ./init_script.sh
COPY docker/run-at-start.sh ./run-at-start.sh
RUN chmod 777 /root/init_script.sh /root/run-at-start.sh .
CMD ["/root/run-at-start.sh"]


#########################################
# RUN yum clean all && yum update -y && yum autoremove -y && yum clean all

# RUN yum -y install php \
#     nginx postgresql\
#     wget zip unzip make rsync git vim bash-completion tar epel-release dnf-utils

# RUN dnf install -y http://rpms.remirepo.net/enterprise/remi-release-9.rpm
# RUN dnf -y module reset php
# RUN dnf -y module install php:remi-8.2

# RUN dnf install -y php php-cli php-fpm php-pgsql php-mbstring php-xml php-json php-pdo php-pecl-zip php-pear gcc php-devel
# RUN pecl install Xdebug

# RUN yum install -y libX11 atk cups libxkbcommon libXcomposite pango alsa-lib at-spi2-core at-spi2-atk libdrm libXdamage libXfixes libXrandr libgbm \
#     php-cli php-common php-fpm php-pgsql php-bcmath php-mysqlnd php-opcache php-gd php-pecl-apcu php-pecl-igbinary php-pecl-memcache php-pecl-memcached php-pecl-igbinary-devel php-soap php-sodium php-pecl-msgpack php-pecl-ssh2 php-intl \
#     ImageMagick oathtool procps dos2unix

# COPY docker/nginx.conf /etc/nginx/nginx.conf
# RUN mkdir /run/php-fpm/

# RUN sed -i 's/^display_errors = Off$/display_errors = On/' /etc/php.ini
# RUN sed -i 's/^display_startup_errors = Off$/display_startup_errors = On/' /etc/php.ini
# RUN sed -i 's/^upload_max_filesize = .*$/upload_max_filesize = 20M/' /etc/php.ini
# RUN sed -i 's/^memory_limit = .*$/memory_limit = 3000M/' /etc/php.ini
# COPY ./docker/php.d/20-xdebug.ini /etc/php.d/20-xdebug.ini

# WORKDIR /root/php-composer/
# RUN wget https://getcomposer.org/installer -O composer-installer.php
# RUN php composer-installer.php --filename=composer --install-dir=/usr/local/bin 
# RUN composer global require laravel/installer
# RUN export PATH=$PATH:/root/.composer/vendor/bin



