#!/bin/bash

# Instalar dependencias de Mega SDK
sudo apt-get update
sudo apt-get install -y g++ libcurl4-openssl-dev libc-ares-dev libssl-dev libfreeimage-dev
wget https://github.com/meganz/sdk/archive/refs/tags/v3.8.0.tar.gz
tar xf v3.8.0.tar.gz
cd sdk-3.8.0
make
sudo make install
cd ..

# Clonar repositorio de MegaSync
git clone https://github.com/meganz/MEGAsync.git
cd MEGAsync

# Compilar MegaSync
qmake CONFIG+=no_gui
make -j$(nproc)

# Configurar credenciales de Mega
./MEGAsync/megacli

# Crear script para sincronización
cat <<EOT >> sync.sh
#!/bin/bash

# Ruta de la carpeta a sincronizar (DCIM en este caso)
folder="/storage/emulated/0/DCIM"

# Comprobar si está dentro del horario permitido (00:00 a 07:00)
hour=\$(date +"%H")
if [ \$hour -ge 0 ] && [ \$hour -lt 7 ]; then
    # Sincronizar con Mega
    ./MEGAsync/MEGAsync \$folder
fi
EOT

# Dar permisos de ejecución al script
chmod +x sync.sh
