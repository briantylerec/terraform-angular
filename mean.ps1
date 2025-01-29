# Ejecutar Packer para construir las AMIs
Write-Host "Ejecutando Packer..."
cd packer
packer build ./template.pkr.hcl
cd ..

# Definir las rutas de los archivos de Packer
$PackerFolder = "packer"  # Asegúrate de ajustar la ruta al directorio donde están tus archivos de Packer
$MeanAppPackerFile = "packer-node-manifest.json"
$MongoDBPackerFile = "packer-mongo-manifest.json"

# Obtener el ID de la AMI para Node.js y Nginx (buscando "ami-" en el archivo)
Write-Host "Extrayendo la AMI para Node.js y Nginx..."
$MeanAppAmiId = (Get-Content "$PackerFolder\$MeanAppPackerFile" | Select-String "ami-" -SimpleMatch).Line
$MeanAppAmiId = $MeanAppAmiId.Split(":")[2].Trim()  # Separar por ":" y obtener solo el ID de la AMI

Write-Host "AMI para Node.js y Nginx: $MeanAppAmiId"

# Obtener el ID de la AMI para MongoDB (buscando "ami-" en el archivo)
Write-Host "Extrayendo la AMI para MongoDB..."
$MongoDBAmiId = (Get-Content "$PackerFolder\$MongoDBPackerFile" | Select-String "ami-" -SimpleMatch).Line
$MongoDBAmiId = $MongoDBAmiId.Split(":")[2].Trim()  # Separar por ":" y obtener solo el ID de la AMI

Write-Host "AMI para MongoDB: $MongoDBAmiId"

$MeanAppAmiId = $MeanAppAmiId.Trim(',')
$MongoDBAmiId = $MongoDBAmiId.Trim(',')

# Crear un archivo terraform.tfvars con las AMIs extraídas
$tfvars_content = @"
ami_node = "$MeanAppAmiId
ami_mongo = "$MongoDBAmiId
"@

# Guardar el contenido en terraform.tfvars
$tfvars_content | Out-File -FilePath "terraform.tfvars" -Encoding UTF8

Write-Host "Archivo terraform.tfvars generado exitosamente."

# Ejecutar Terraform: inicializar el directorio, planificar y aplicar
Write-Host "Inicializando Terraform..."
terraform init

Write-Host "Ejecutando Terraform Plan..."
terraform plan -var "ami_node=$MeanAppAmiId" -var "ami_mongo=$MongoDBAmiId"

Write-Host "Aplicando los cambios con Terraform..."
terraform apply -var "ami_node=$MeanAppAmiId" -var "ami_mongo=$MongoDBAmiId" -auto-approve
