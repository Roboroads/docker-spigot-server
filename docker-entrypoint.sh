#!/bin/sh
set -o errexit

mkdir -p /minecraft/.home
export HOME=/minecraft/.home

case "$1" in
  server)
    mkdir -p /minecraft/buildtools
    cd /minecraft

    if [[ ! -f "spigot.jar" ]]; then
      (/docker-entrypoint.sh update);
    fi

    if [[ ! -f "eula.txt" ]] || grep -q "eula=false" "eula.txt"; then
      echo "You have to accept Minecrafts EULA to be able to start the server."
      echo "Use the same docker run command you used, but append eula to read/accept it."
      echo " E.g.: docker run ... -it Roboroads/spigot eula"
      exit 1
    fi

    java -Xms1G -Xmx1G -XX:+UseConcMarkSweepGC -jar spigot.jar nogui
  ;;

  update)
    mkdir -p /minecraft/buildtools
    cd /minecraft/buildtools
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
