#command to build:
#docker build --tag test1:v1.1 .

FROM --platform=amd64 ubuntu:noble-20250910

EXPOSE 80:80
EXPOSE 3000:3000
EXPOSE 3001:3001
EXPOSE 3002:3002

SHELL ["/bin/bash", "-i", "-c"]
WORKDIR /root/

COPY docker/bashrc /root/.bashrc

RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata
RUN apt install -y git nginx curl wget bash-completion oathtool yq jq unzip vim build-essential wkhtmltopdf gnupg software-properties-common mandoc groff \
    chromium xdg-utils age apt-transport-https ca-certificates \
    postgresql-client mysql-client \
    zip unzip tar gcc g++ \
    php php-cli php-fpm php-pgsql php-mbstring php-xml php-json php-pdo php-pear gcc php-cli php-common php-fpm php-pgsql php-bcmath php-mysqlnd php-opcache php-gd php-soap php-intl \
    procps dos2unix python3 python3-pip lsof golang  

RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN apt-get update && apt-get install -y google-cloud-cli

RUN git config --global user.email "meow@devbro.com"
RUN git config --global user.name "meow meow"
RUN git config --global core.eol lf
RUN git config --global core.autocrlf false
RUN git config --global pull.rebase false



RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

RUN brew install localstack terraform nvm aws-vault awscli sops gh az rust asdf hashicorp/tap/vault glab

RUN nvm install  v24.3.0 \
    && nvm alias default v24.3.0 \
    && nvm use default \
    && npm install -g yarn \
    && yarn global add snyk nx

# RUN aws configure set region ca-central-1
WORKDIR /root/source_code/
WORKDIR /root/
COPY docker/init_script.sh ./init_script.sh
COPY docker/run-at-start.sh ./run-at-start.sh
RUN chmod 777 /root/init_script.sh /root/run-at-start.sh .
CMD ["/root/run-at-start.sh"]

