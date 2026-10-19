#!/bin/bash

# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/hacking-resources/refs/heads/main/SystemdSandbox/Packages/Debian/13/Download.sh | bash

# Instalar dependencias
  sudo apt-get -y update
  sudo apt-get -y install curl systemd-container tar

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
  cat /tmp/base-debian-13.tar.xz.part-* | sudo tar --acls --xattrs --xattrs-include='*' --sparse --numeric-owner --same-owner --same-permissions -xJvf - -C /var/lib/machines/

# Notificar fin de ejecución
  echo ""
  echo "  Contenedor de Debian 13 descargado y descomprimido en /var/lib/machines/base-debian-13/"
  echo ""
  echo "    Para renombrarlo, ejecuta:"
  echo ""
  echo "      vNuevoNombre='DebianPruebas'"
  echo '      sudo sed -i -e "s|base-debian-13|$vNuevoNombre|g" /var/lib/machines/base-debian-13/etc/hostname'
  echo '      sudo sed -i -e "s|base-debian-13|$vNuevoNombre|g" /var/lib/machines/base-debian-13/etc/hosts'
  echo '      sudo mv -fv /var/lib/machines/base-debian-13/ /var/lib/machines/$vNuevoNombre/'
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
