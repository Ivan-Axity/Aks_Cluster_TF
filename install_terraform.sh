#!/bin/bash

# Actualizar el sistema y instalar paquetes necesarios
echo "Actualizando el sistema y instalando paquetes necesarios..."
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
if [ $? -ne 0 ]; then
    echo "Error durante la actualización o instalación de paquetes. Salida."
    exit 1
fi
echo "Actualización e instalación completadas."

# Descargar y añadir las llaves de HashiCorp
echo "Descargando y añadiendo las llaves de HashiCorp..."
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
if [ $? -ne 0 ]; then
    echo "Error al añadir las llaves de HashiCorp. Salida."
    exit 1
fi
echo "Llaves añadidas exitosamente."

# Verificar la huella digital de la llave
echo "Verificando la huella digital de la llave..."
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
if [ $? -ne 0 ]; then
    echo "Error al verificar la huella digital. Salida."
    exit 1
fi
echo "Huella digital verificada."

# Añadir el repositorio de HashiCorp
echo "Añadiendo el repositorio de HashiCorp..."
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null
if [ $? -ne 0 ]; then
    echo "Error al añadir el repositorio de HashiCorp. Salida."
    exit 1
fi
echo "Repositorio añadido exitosamente."

# Actualizar el sistema nuevamente
echo "Actualizando el sistema nuevamente..."
sudo apt update
if [ $? -ne 0 ]; then
    echo "Error durante la actualización. Salida."
    exit 1
fi
echo "Actualización completada."

# Instalar Terraform
echo "Instalando Terraform..."
sudo apt-get install terraform
if [ $? -ne 0 ]; then
    echo "Error al instalar Terraform. Salida."
    exit 1
fi
echo "Terraform instalado exitosamente."

# Mostrar la versión de Terraform
echo "Verificando la versión de Terraform instalada..."
terraform version
if [ $? -eq 0 ]; then
    echo "Instalación completada con éxito."
else
    echo "Hubo un problema al verificar la versión de Terraform. Instalación incompleta."
fi