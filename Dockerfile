FROM ubuntu:latest

COPY Gemfile /

ARG AWS_RUNAS_VERSION=3.5.1
ADD https://github.com/mmmorris1975/aws-runas/releases/download/3.5.1/aws-runas_${AWS_RUNAS_VERSION}_amd64.deb /root/aws-runas_3.5.1_amd64.deb

RUN \
    apt-get update && \
    apt-get install -y ruby-full ruby-bundler build-essential python3-pip curl git lsb-release software-properties-common libcap2-bin vim jq && \
    curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    apt-add-repository -y "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    apt-get update && apt-get install terraform && \
    bundle install && \
    curl -L "$(curl -s https://api.github.com/repos/aquasecurity/tfsec/releases/latest | grep -o -E -m 1 "https://.+?tfsec-linux-amd64")" > tfsec && chmod +x tfsec && mv tfsec /usr/bin/ && \
    curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash && \
    curl -sSLo ./terraform-docs.tar.gz https://terraform-docs.io/dl/v0.16.0/terraform-docs-v0.16.0-$(uname)-amd64.tar.gz && tar -xzf terraform-docs.tar.gz && chmod +x terraform-docs && mv terraform-docs /usr/bin/ && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install && rm -rf awscliv2.zip aws && \
    apt-get remove -y software-properties-common lsb-release && apt-get -y autoremove && \
    dpkg -i /root/aws-runas_${AWS_RUNAS_VERSION}_amd64.deb && \
    rm /root/aws-runas_${AWS_RUNAS_VERSION}_amd64.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /workspace && \
    pip install pre-commit && \
    pip install -U checkov && \
    pip install six

WORKDIR /workspace
ENV CHEF_LICENSE="accept"

