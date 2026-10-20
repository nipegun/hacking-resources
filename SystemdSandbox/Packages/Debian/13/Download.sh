#!/bin/bash

# Ejecución remota (puede requerir permisos sudo):
#  curl -sL https://raw.githubusercontent.com/nipegun/hacking-resources/refs/heads/main/SystemdSandbox/Packages/Debian/13/Download.sh | bash
# Ejecución remota como root (para sistemas sin sudo):
#  curl -sL https://raw.githubusercontent.com/nipegun/hacking-resources/refs/heads/main/SystemdSandbox/Packages/Debian/13/Download.sh | sed 's-sudo--g' | bash

# Actualizar la lista de paquetes disponibles en los repositorios
  echo ""
  echo "  Actualizando la lista de paquetes disponibles en los repositorios..."
  echo ""
  sudo apt-get -y update

# Instalar dependencias
  echo ""
  echo "  Instalando dependencias..."
  echo ""
  sudo apt-get -y install curl systemd-container tar dialog

# Preguntar el nombre del contenedor
  vEstado=0
  vNuevoNombreHost=$(dialog --stdout --input-fd 3 --title "Nombre del contenedor" --inputbox "Introduce el nombre (sin usar espacios):" 8 50 3</dev/tty) || vEstado=$?

  # Si el usuario cancela, utilizar SinNombre
  if [ "$vEstado" -ne 0 ]; then
    vNuevoNombreHost="SinNombre"
  fi

  # Validar el nombre del contenedor
  if [[ ! "$vNuevoNombreHost" =~ ^[A-Za-z0-9]([A-Za-z0-9-]{0,61}[A-Za-z0-9])?$ ]]; then
    echo "Error: el nombre debe contener entre 1 y 63 caracteres, únicamente letras, números y guiones, sin comenzar ni terminar con un guion."
    exit 1
  fi

  # Impedir utilizar el nombre reservado del contenedor original
  if [ "$vNuevoNombreHost" = "base-debian-13" ]; then
    echo "Error: el nombre base-debian-13 está reservado."
    exit 1
  fi

  # Comprobar que no exista otro contenedor con ese nombre
  if [ -e "/var/lib/machines/$vNuevoNombreHost" ] || [ -L "/var/lib/machines/$vNuevoNombreHost" ]; then
    echo "Error: ya existe un contenedor llamado $vNuevoNombreHost."
    exit 1
  fi

# Descargar partes del contenedor de Debian
  echo ""
  echo "  Descargando archivos de partes del contenedor..."
  echo ""
  cd /tmp/
  curl --progress-bar -L https://raw.githubusercontent.com/nipegun/hacking-resources/refs/heads/main/SystemdSandbox/Packages/Debian/13/base-debian-13.tar.xz.part-000 -O
  curl --progress-bar -L https://raw.githubusercontent.com/nipegun/hacking-resources/refs/heads/main/SystemdSandbox/Packages/Debian/13/base-debian-13.tar.xz.part-001 -O
  curl --progress-bar -L https://raw.githubusercontent.com/nipegun/hacking-resources/refs/heads/main/SystemdSandbox/Packages/Debian/13/base-debian-13.tar.xz.part-002 -O
  curl --progress-bar -L https://raw.githubusercontent.com/nipegun/hacking-resources/refs/heads/main/SystemdSandbox/Packages/Debian/13/base-debian-13.tar.xz.part-003 -O
  curl --progress-bar -L https://raw.githubusercontent.com/nipegun/hacking-resources/refs/heads/main/SystemdSandbox/Packages/Debian/13/base-debian-13.tar.xz.part-004 -O
  curl --progress-bar -L https://raw.githubusercontent.com/nipegun/hacking-resources/refs/heads/main/SystemdSandbox/Packages/Debian/13/base-debian-13.tar.xz.part-005 -O

# Descomprimir a su ubicación final
  echo ""
  echo "  Descomprimiendo a su ubicación final..."
  echo ""
  sudo rm -rf /var/lib/machines/base-debian-13/
  cat /tmp/base-debian-13.tar.xz.part-* | sudo tar --acls --xattrs --xattrs-include='*' --sparse --numeric-owner --same-owner --same-permissions -xJvf - -C /var/lib/machines/
  sudo mv /var/lib/machines/base-debian-13/ /var/lib/machines/$vNuevoNombreHost/
  sudo sed -i -e "s|base-debian-13|$vNuevoNombreHost|g" /var/lib/machines/$vNuevoNombreHost/etc/hostname
  sudo sed -i -e "s|base-debian-13|$vNuevoNombreHost|g" /var/lib/machines/$vNuevoNombreHost/etc/hosts

# Notificar fin de ejecución
  echo ""
  echo "  Contenedor de Debian 13 descargado y descomprimido en /var/lib/machines/$vNuevoNombreHost/"
  echo ""
  echo "    Para bootearlo, ejecuta:"
  echo ""
  echo "      sudo systemd-nspawn -U -D /var/lib/machines/$vNuevoNombreHost/ --boot"
  echo ""
  echo "    Si quieres que el contenedor monte una carpeta del host al iniciar, bootealo con:"
  echo ""
  echo "      Manteniendo los UID y GID del anfitrión:"
  echo "        sudo systemd-nspawn -D /var/lib/machines/$vNuevoNombreHost/ --bind='/home/user/Escritorio:/mnt/host' --boot"
  echo ""
  echo "      Activando namespaces para hacer que los UID y GID del contenedor sean diferentes de los del anfitrión:"
  echo "        sudo systemd-nspawn -U -D /var/lib/machines/$vNuevoNombreHost/ --bind='/home/user/Escritorio:/mnt/host' --boot"
  echo ""
  echo "    La contraseña del root es 'raizraiz'."
  echo ""
  echo "    Tienes los siguientes contendores de systemd en /var/lib/machines/"
  echo ""
  #sudo ls -l /var/lib/machines/ | awk '{print $9}'
  sudo find /var/lib/machines/ -mindepth 1 -maxdepth 1 -type d -printf '%f\n'
  echo ""
