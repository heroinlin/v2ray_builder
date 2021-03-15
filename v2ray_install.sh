#/bin/bash

echo -e "\033[35m  V2ray install shell...\033[0m"

export install_type=0
export current_root=${PWD}

function usage ()
{
	echo -e "\033[34m **********************  shell scripts usage document  ********************** \033[0m"
	echo "                                                                             "
	echo -e "\033[35m  bash v2ray_install.sh  <install_type>\033[0m"
    echo -e "  default install_type is \033[35m $install_type  \033[0m"
    echo -e "\033[35m  check install_type to 1 to install use certificates \033[0m"
	echo -e "  else will install no certificates \033[0m"                           
	echo "                                                                             "
	echo -e "\033[34m  ***************************************************************************** \033[0m"
	return 1
}

################################################################################
################################ get full path   ###############################
function getfullpath ()
{
	local dir=$(dirname $1)
	local base=$(basename $1)
	if test -d ${dir}; then
		pushd ${dir} >/dev/null 2>&1
		echo ${PWD}/${base}
		popd >/dev/null 2>&1
		return 0
	fi
	return 1
}

function docker_install()
{   
    echo -e "\033[34m **********************  start to install docker ********************** \033[0m"
    sudo apt-get update

    sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    sudo apt-key fingerprint 0EBFCD88

    sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

   sudo apt-get update

   sudo apt-get install -y docker-ce docker-ce-cli containerd.io

    echo -e "\033[34m **********************  docker install finish ********************** \033[0m"
}

function docker_compose_install()
{               
    echo -e "\033[34m *****************  start to install docker-compose ***************** \033[0m"                                                
    sudo curl -L https://github.com/docker/compose/releases/download/1.23.2/run.sh > /usr/local/bin/docker-compose
    
    sudo chmod +x /usr/local/bin/docker-compose

    docker-compose version
    echo -e "\033[34m ******************  docker-compose install finish ****************** \033[0m"
}

function pull_v2ray()
{
    echo -e "\033[34m *****************  start to pull v2ray image ***************** \033[0m"
    sudo docker pull v2ray/official
    echo -e "\033[34m ******************  v2ray image pull finish ****************** \033[0m"
}

function start_v2ray_server()
{
    echo -e "\033[34m *****************  start v2ray server ***************** \033[0m"
    cd $current_root
    if [ $install_type = '1' ]; then
        cp docker-compose_crt.yml docker-compose.yml
    else
        cp docker-compose_default.yml docker-compose.yml
    fi
    docker-compose up -d
}

if [ $# -lt 1 ]; then
	install_type=0
else 
	if [ $1 = '-h' ] || [ $1 = 'help' ] || [ $1 = '--help' ]; then
		usage
		exit 1
	else
		install_type=$1
	fi
fi
docker_install
docker_compose_install
pull_v2ray
start_v2ray_server