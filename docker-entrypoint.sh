#!/bin/bash

mkdir -p /minecraft/.home
export HOME=/minecraft/.home
export MAVEN_OPTS="-Dmaven.repo.local=${HOME}/.m2"

exit_server(){
  echo 'Stopping MC Server..'
  kill -SIGTERM "$(ps aux | grep java | grep -v grep | awk '{print $1}')"
}
trap "exit_server" SIGINT SIGTERM

case "$1" in
  server)
    mkdir -p /minecraft/buildtools
    cd /minecraft

    if [[ ! -f "spigot.jar" ]]; then
      (/docker-entrypoint.sh update)
    fi

    if [[ ! -f "eula.txt" ]] || grep -q "eula=false" "eula.txt"; then
      (/docker-entrypoint.sh eula)
    fi

    exec java -Xms1G -Xmx1G -XX:+UseConcMarkSweepGC -jar spigot.jar nogui
  ;;

  update)
    mkdir -p /minecraft/buildtools
    cd /minecraft/buildtools
    rm spigot*.jar
    curl -z BuildTools.jar -o BuildTools.jar https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
    java -jar BuildTools.jar --rev $SPIGOT_VERSION
    cp spigot*.jar ../spigot.jar
  ;;

  eula)
    mkdir -p /minecraft/buildtools
    echo "Read the Minecraft EULA at https://account.mojang.com/documents/minecraft_eula"
    echo "Press 'y' to accept or 'n' to decline."
    while : ; do
      read -n 1 k <&1
      if [[ $k = "y" ]] ; then
        cd /minecraft
        echo "eula=true" > eula.txt
        printf "\nYou have accepted the EULA - you can now run the server.\n"
        break
      elif [[ $k = "n" ]] ; then
        printf "\nYou have declined the EULA - you can not run the server.\n"
        break
      else
        printf "\nPress 'y' to accept or 'n' to decline.\n"
      fi
    done
  ;;

  *)
    exec "$@"
  ;;

esac

exit 0
