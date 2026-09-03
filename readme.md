
# Projetos

## azure-common
Cria recursos comum a todos os projetos

## azure-vnet
Cria rede para a criação das VMs e AKS

## azure-vm-com-vnet-remote-state
Criação de VM

# Comandos úteis
## Login com app no PowerShell

ARM_CLIENT_ID: Microsoft Entra - ID do app criado
ARM_CLIENT_SECRET: Microsoft Entra - Secret criado no app gerado
ARM_TENANT_ID: ID do diretório
ARM_SUBSCRIPTION_ID: ID da subscription

az login --service-principal --username $env:ARM_CLIENT_ID --password $env:ARM_CLIENT_SECRET --tenant $env:ARM_TENANT_ID

az login --tenant  $env:ARM_TENANT_ID

## Login show info
az account show --query "{subscription:name, subscriptionId:id, tenant:tenantId, user:user.name}" -o json

az account show --query "{name:name, id:id, tenant:tenantId, user:user}" -o json

## Setting subscription
az account set --subscription $env:ARM_SUBSCRIPTION_ID

## Verificar roles
az role assignment list `
  --assignee $env:ARM_CLIENT_ID `
  --all `
  --output table


## Listar recursos
az account show --output table

az group list --output table

az group show `
  --name $env:GROUP `
  --output table

az resource list `
  --resource-group $env:GROUP `
  --output table

az storage account list --output table

az storage container list `
  --account-name $env:STORAGE_ACOUNT `
  --auth-mode login `
  --output table

az storage account list `
  --resource-group $env:GROUP `
  --output table


## Provider Microsoft.Storage

az provider register --namespace Microsoft.Storage

az provider show `
  --namespace Microsoft.Storage `
  --query "registrationState" `
  -o tsv

## Listar VM disponivel por regiao
az vm list-sizes --location brazilsouth --output table

## Listar imagens de SO disponíveis
az vm image list --location brazilsouth --publisher Canonical --offer UbuntuServer --all -o table
