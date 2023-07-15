#!/bin/bash

########################################################################TODO:#############################################################################
## Ubuntu 18.04.6 LTS (Bionic Beaver) >> nodeJS 18 ^ 사용 불가 >> 이 경우 node_version을 14.21.3
## OS 버전 체크해서 node_version 바꾸는 형식으로 개선하면 좋을 것 같다.
##########################################################################################################################################################

########################################################################TEST##############################################################################
## 테스트 환경

## Ubuntu 18.04.6 LTS (Bionic Beaver) >> node_version을 14.21.3 고쳐서 사용해야 함
## Ubuntu 20.04.6 LTS (Focal Fossa) WSL >> nodeJS 18 (O)

## Rocky Linux 8.8 (Green Obsidian) >> nodeJS 18 (O)
##########################################################################################################################################################

##########################################################################################################################################################
# nvm 경로
nvm_dir="$HOME/.nvm"

## nodeJS version ##
# # nodeJS version - Ubuntu 18.04.6 LTS
# node_version="14.21.3"
# nodeJS version
node_version="18.16.1"
##

# /node_modules
node_modules="node_modules"

#
# CLI
cli="[ 🙏SSOO🙏 ]"
# COLOR
red="\e[31m"
green="\e[32m"
yellow="\e[33m"
reset="\e[0m"
revert="\e[7m"
new_line="\n"
# 종료 멘트
exit_word="$revert==================================종료==================================$reset$new_line"
# 라인
bar="■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■$new_line"
##########################################################################################################################################################

##########################################################################################################################################################
# pm2 설치
install_pm2() {
    local is_pm2=$(command -v pm2)

    if [ -z $is_pm2 ]
    then
        npm install pm2 -g

        pm2 install pm2-logrotate

        pm2 set pm2-logrotate:retain 10
    fi

}
##########################################################################################################################################################

##########################################################################################################################################################
# nvm 설치
install_nvm() {
    # nvm 설치 여부 확인
    if [ ! -d "$nvm_dir" ]
    then
        echo "$cli nvm이 설치되어 있지 않습니다. 제가 설치해드릴게요!"
        # 다운 받고
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
        
        # 바로 사용할 수 있게 반영해주기
        source ~/.bashrc

        echo -e $bar
    fi
    
    # nodeJS 설치 여부 확인 > 설치
    install_nodeJS
}
##########################################################################################################################################################

##########################################################################################################################################################
# nodeJS 설치
install_nodeJS() {

    # nvm 로드하고...
    [ -s "$nvm_dir/nvm.sh" ] && \. "$nvm_dir/nvm.sh" --silent

    
    # Node.js 버전 확인
    local current_node=$(nvm current)
    echo -e "$cli 현재 nodeJS 버전: $yellow$current_node$reset"

    if [ $current_node = "none" ]
    then
        # 지정된 nodeJS version으로 설치 > 첫 설치라서 default alias 자동
        nvm install $node_version
    elif [ "$current_node" != "v$node_version" ]
    then 
        # 설치가 되어있다면, 현재 default version이 지정된 version인지 확인
        nvm install $node_version
        # default alias 변경
        nvm alias default $node_version
    else
        echo -e "$cli 요구되는 nodeJS 버전을 갖추었군요!$new_line"
    fi

    echo -e $bar

    # pm2 설치 여부 확인 > 설치
    install_pm2
}
##########################################################################################################################################################

# 실행하면 실행되는 구간 #
##########################################################################################################################################################
echo -e "$new_line$revert==================================시작==================================$reset$new_line"

# 현재 user
user=$(whoami)
echo -e "$cli 안녕하세요, $green$user$reset! $new_line"
echo -e $bar

check_node=$(command -v node)

if [ -z $check_node ]
then
    install_nvm
else
    current_node=$(node -v)
    if [ $current_node != $node_version ]
    then 
        install_nvm
    fi
fi

echo -e $exit_word