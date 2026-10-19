#!/bin/bash

# Instalar dependencias
  sudo apt-get -y update
  sudo apt-get -y install curl nspawn

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

