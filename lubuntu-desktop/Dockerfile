FROM ubuntu:18.04

MAINTAINER osugizmo

ARG DEFUSER=bionic 
ARG DEFHOME=/home/${DEFUSER}
ARG DEFSHELL=/bin/bash

ENV DEBIAN_FRONTEND=noninteractive

COPY km-e0010411.ini /tmp
COPY linux_signing_key.pub /tmp
COPY microsoft.gpg /tmp

# set -xにて実行コマンドを標準エラー出力に表示
RUN set -x && \

    : "パッケージの更新" && \
    apt-get -y update && \
    apt-get -y upgrade && \

    : "システムコマンドの追加とタイムゾーンの設定" && \
    apt-get -y install tzdata sudo keyboard-configuration && \
    echo "${TZ}}" > /etc/timezone && \
    rm /etc/localtime && \
    ln -s /user/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \

    : "基本的なコマンドの追加" && \ 
    apt-get -y install tree curl wget git nano vim vim-gnome unzip  && \

    : "言語パッケージの追加と設定" && \
    apt-get -y install language-pack-ja-base language-pack-ja ibus-mozc && \
    locale-gen ja_JP.UTF-8 && \
    update-locale LANG=ja_JP.UTF-8 LANGUAGE=ja_JP:ja && \

    : "フォントのインストール" && \
    apt-get -y install unifont synaptic scim-anthy fcitx-anthy fonts-takao-* fonts-ipafont fonts-ipaexfont && \

    : "LXDEのインストール" && \
    apt-get -y install lxde && \
    apt-get -y install xdg-user-dirs-gtk && \
    LANGUAGE=C LC_MESSAGE=C xdg-user-dirs-gtk-update && \


    : "RDPサーバーのインストール、カーソル関係の不具合対策、日本語キーマップ追加" && \
    apt-get -y install xrdp && \
    sed -e 's/^new_cursors=true/new_cursors=false/g' -i /etc/xrdp/xrdp.ini && \
    mv -f /tmp/km-e0010411.ini /etc/xrdp/km-e0010411.ini && \
    mv -f /etc/xrdp/km-e0010411.ini /etc/xrdp/km-0411.ini && \
    ln -nfs /etc/xrdp/km-0411.ini /etc/xrdp/km-e0010411.ini && \
    ln -nfs /etc/xrdp/km-0411.ini /etc/xrdp/km-e2020411.ini && \
    ln -nfs /etc/xrdp/km-0411.ini /etc/xrdp/km-e0210411.ini && \

    : "LXDE、XRDP用ユーザー設定(初期パスワードはユーザ名なので接続後変更すること！)" && \
    useradd -m ${DEFUSER} && \
    gpasswd -a ${DEFUSER} sudo && \
    echo "${DEFUSER}:${DEFUSER}" | chpasswd && \
    sed -i.bak -e 's/${DEFHOME}:/${DEFHOME}:${DEFSHELL}/g' /etc/passwd && \
    echo lxsession -s LXDE -e LXDE > ${DEFHOME}/.xsession && \
    chown ${DEFUSER}:${DEFUSER} ${DEFHOME}/.xsession && \
    mkdir ${DEFHOME}/workspace && \
    chown ${DEFUSER}:${DEFUSER} ${DEFHOME}/workspace && \
    mkdir ${DEFHOME}/app && \
    chown ${DEFUSER}:${DEFUSER} ${DEFHOME}/app && \
    mkdir ${DEFHOME}/build && \
    chown ${DEFUSER}:${DEFUSER} ${DEFHOME}/build && \
    mkdir ${DEFHOME}/download && \
    chown ${DEFUSER}:${DEFUSER} ${DEFHOME}/download && \

    : "Chromeのインストール" && \
    : "wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - " && \
    cat /tmp/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
    apt-get -y update && \
    apt-get -y install google-chrome-stable && \
    rm /etc/apt/sources.list.d/google.list && \

    : "Visual Studio Codeのインストール" && \
    : "curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg" && \
    install -o root -g root -m 644 /tmp/microsoft.gpg /etc/apt/trusted.gpg.d/ && \
    sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' && \
    apt-get -y install apt-transport-https && \
    apt-get -y update && \
    apt-get -y install code && \

    : "Node.jsのインストール" && \
    apt-get -y install nodejs npm && \
    npm cache clean && \
    npm install n -g && \
    n stable && \
    ln -sf /usr/local/bin/node /usr/bin/node && \
    apt-get -y purge nodejs && \
    apt-get -y purge npm && \
    node -v && \
    n 8.10.0 && \
    node -v && \

    : "後始末" && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/* && \
    echo finished

# 環境構築後の環境変数設定
ENV TZ=Asia/Tokyo
ENV LANG=ja_JP.UTF-8
ENV LC_ALL=${LANG}
ENV LC_CYPE=${LANG}

# 解放ポートの設定
EXPOSE 3389

# 実行コマンド
ENTRYPOINT [""]
CMD ["env", "dpkg", "-l", "/bin/bash"]

