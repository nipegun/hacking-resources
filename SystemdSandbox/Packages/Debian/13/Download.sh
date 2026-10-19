#!/bin/bash

# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/hacking-resources/refs/heads/main/SystemdSandbox/Packages/Debian/13/Download.sh | bash

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
  vNuevoNombreHost=$(dialog --stdout --title "Nombre del contenedor" --inputbox "Introduce el nombre (sin usar espacios):" 8 50)

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
  echo "  Contenedor de Debian 13 descargado y descomprimido en /var/lib/machines/base-debian-13/"
  echo ""
  echo "    Para bootearlo, ejecuta:"
  echo ""
  echo '      sudo systemd-nspawn -U -D /var/lib/machines/$vNuevoNombre/ --boot'
  echo ""
  echo "    Si quieres que también acceda a una carpeta del host:"
  echo ""
  echo '      sudo systemd-nspawn -U -D /var/lib/machines/$vNuevoNombre/ --bind="/home/nipegun/Escritorio/Code:/mnt/host" --boot'
  echo ""
  echo "    La contraseña del root es 'raizraiz'."
  echo ""

