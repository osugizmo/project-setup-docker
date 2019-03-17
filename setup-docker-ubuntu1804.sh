#!/bin/sh
cat /etc/lsb-release

#Updates
#sudo apt -y update
#sudo apt -y upgrade

#Docker
sudo apt -y install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable test edge"
sudo apt -y update
sudo apt -y install docker-ce
docker --version

#[forDebug]起動しているか確認
#sudo systemctl status docker

#一般ユーザーでもsudoなしでDockerコマンドを実行できるようにする
#セキュリティ的にという話もあるが開発環境なので以下を実行
#Socketにもアクセスできるようにしておく
sudo gpasswd -a ubuntu docker
sudo chmod 666 /var/run/docker.sock

#Docker Compose
#以下から導入するバージョンを決める
#https://github.com/docker/compose/blob/master/CHANGELOG.md
export compose='1.21.1'
sudo curl -L https://github.com/docker/compose/releases/download/${compose}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod 0755 /usr/local/bin/docker-compose
docker-compose -v

