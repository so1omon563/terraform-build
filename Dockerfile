FROM ubuntu:latest

ARG AWS_RUNAS_VERSION=3.5.2
ADD https://github.com/mmmorris1975/aws-runas/releases/download/${AWS_RUNAS_VERSION}/aws-runas_${AWS_RUNAS_VERSION}_amd64.deb /root/aws-runas_${AWS_RUNAS_VERSION}_amd64.deb

RUN \
    apt-get update && \
    apt-get install -y python3-pip curl git vim jq libcap2-bin unzip zsh fd-find bat && \
    curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash && \
    curl -sSLo ./terraform-docs.tar.gz https://terraform-docs.io/dl/v0.16.0/terraform-docs-v0.16.0-$(uname)-amd64.tar.gz && tar -xzf terraform-docs.tar.gz && chmod +x terraform-docs && mv terraform-docs /usr/bin/ && \
    curl -L "$(curl -s https://api.github.com/repos/aquasecurity/tfsec/releases/latest | grep -o -E -m 1 "https://.+?tfsec-linux-amd64")" > tfsec && chmod +x tfsec && mv tfsec /usr/bin/ && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install && rm -rf awscliv2.zip aws && \
    dpkg -i /root/aws-runas_${AWS_RUNAS_VERSION}_amd64.deb && \
    rm /root/aws-runas_${AWS_RUNAS_VERSION}_amd64.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /workspace && \
    git clone --depth 1 https://github.com/tfutils/tfenv.git ~/.tfenv && \
    echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.zprofile && \
    ln -s ~/.tfenv/bin/* /usr/local/bin && \
    git clone --depth 1 https://github.com/tgenv/tgenv.git ~/.tgenv && \
    echo 'export PATH="$HOME/.tgenv/bin:$PATH"' >> ~/.zprofile && \
    ln -s ~/.tgenv/bin/* /usr/local/bin && \
    pip install pre-commit && \
    pip install -U checkov && \
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all && \
    echo "export HISTFILE=~/.zsh_history" >> ~/.zshrc && \
    echo "export HISTFILE=~/.zsh_history" >> ~/.bashrc && \
    echo "alias tf='terraform'" >> ~/.zshrc && \
    echo "alias tg='terragrunt'" >> ~/.zshrc && \
    usermod -s /bin/zsh root

    RUN \
    SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=~/.zsh_history" && \
    echo $SNIPPET >> ~/.zshrc

WORKDIR /workspace

