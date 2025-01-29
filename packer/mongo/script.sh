#!/bin/bash

# Esperar a que el servicio MongoDB inicie
echo "Esperando a que MongoDB inicie..."
sleep 10

# Verificar que MongoDB esté corriendo
if systemctl status mongod | grep -q "active (running)"; then
  echo "MongoDB está corriendo correctamente."
else
  echo "Error: MongoDB no está corriendo."
  exit 1
fi

# Crear una base de datos y colección de ejemplo
echo "Creando base de datos y colección de ejemplo..."
mongo <<EOF
use ejemploDB
db.createCollection("usuarios")
EOF

# Insertar un documento de ejemplo
echo "Insertando un documento de ejemplo..."
mongo <<EOF
use ejemploDB
db.usuarios.insert({ nombre: "Juan", edad: 30 })
EOF

# Verificar que el documento haya sido insertado
echo "Verificando la inserción del documento..."
mongo <<EOF
use ejemploDB
db.usuarios.find().pretty()
EOF
