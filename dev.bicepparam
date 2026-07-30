using './Main.bicep'

param environment = 'dev'
param vmName = 'dev-vm'
param location = 'westus2'
param adminUsername = 'azureuser'
param adminPassword = ''
param rgname = 'rg-hexais-${environment}'
