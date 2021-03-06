#!/bin/bash

url_x86_64="https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64"
url_x86="https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-386"
url_arm="https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-arm"
url_arm64="https://github.com/bugparty/gitlab-runner-manager/releases/download/gitlab-runner/gitlab-runner-linux-arm64"
red='\e[91m'
green='\e[92m'
yellow='\e[93m'
magenta='\e[95m'
cyan='\e[96m'
none='\e[0m'

# Root
[[ $(id -u) != 0 ]] && echo -e "\n Please run as  ${red}root ${none} ${yellow}~(^_^) ${none}\n" && exit 1

archs=`uname -m`
case "$archs" in
    i?86) runner_url="$url_x86";;
    x86_64) runner_url="$url_x86_64" ;;
   arm) runner_url="$url_arm" ;;
   aarch64) runner_url="$url_arm64" ;;
esac
echo "download gitlab-runner $runner_url"
if ! wget -O /usr/local/bin/gitlab-runner "$runner_url"; then
   echo -e "$red download failed,exit! $none" && exit 1
fi

chmod +x /usr/local/bin/gitlab-runner
useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash
usermod -a -G docker gitlab-runner
gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner
gitlab-runner start
echo -e "$green install succeed! $none"
echo 'type gitlab-runner register to registe your machine'
