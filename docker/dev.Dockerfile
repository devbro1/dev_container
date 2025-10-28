FROM --platform=amd64 ubuntu:noble-20250910

EXPOSE 80:80
EXPOSE 3000:3000
EXPOSE 3001:3001
EXPOSE 3002:3002

SHELL ["/bin/bash", "-i", "-c"]
WORKDIR /root/

RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata
RUN apt-get install -y git curl wget bash-completion oathtool
RUN apt-get install -y yq jq unzip vim wkhtmltopdf zip unzip tar
RUN apt install -y gnupg software-properties-common mandoc groff
RUN apt install -y chromium age apt-transport-https ca-certificates
RUN apt install -y postgresql-client mysql-client
RUN apt install -y build-essential gcc g++
RUN apt install -y procps dos2unix python3 python3-pip lsof golang redis-tools
## PHP INSTALLATION (uncomment if needed)
# RUN apt install -y xdg-utils nginx php php-cli php-fpm php-pgsql php-mbstring php-xml php-json php-pdo php-pear php-cli php-common php-fpm php-pgsql php-bcmath php-mysqlnd php-opcache php-gd php-soap php-intl
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN apt-get update && apt-get install -y google-cloud-cli

RUN git config --global user.email "farzadk@gmail.com"
RUN git config --global user.name "Farzad Khalafi"
RUN git config --global core.eol lf
RUN git config --global core.autocrlf false
RUN git config --global pull.rebase false


RUN curl -o /tmp/install_brew.sh https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
RUN chmod +x /tmp/install_brew.sh
RUN touch /.dockerenv
RUN NONINTERACTIVE=1 HAVE_SUDO_ACCESS=1 /tmp/install_brew.sh
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"
RUN brew install localstack terraform
RUN brew install nvm gh az asdf
RUN brew install rust 
RUN brew install aws-vault awscli sops
RUN brew install hashicorp/tap/vault glab

RUN /home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh && nvm install  v24.3.0 \
    && nvm alias default v24.3.0 \
    && nvm use default \
    && npm install -g yarn \
    && yarn global add snyk nx


WORKDIR /root/

COPY docker/bashrc /root/.bashrc
CMD ["tail", "-f", "/dev/null"]