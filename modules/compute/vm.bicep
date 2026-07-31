param location string
param subnetId string
param vmName string
param adminUsername string
// param vmSize string = 'Standard_DS1_v2'
param KeyVaultName string

@secure()
param adminPassword string 

param tags object

resource nic 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  name: '${vmName}-nic'
  location: location
  tags: tags

  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'

        properties: {
          subnet: {
            id: subnetId
          }

          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

// resource existingKeyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing ={
//   name:KeyVaultName
// }

// resource breakGlassSecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
//   parent: existingKeyVault
//   name:'${vmName}-breakglass-admin'
//   properties:{
//     value: adminPassword
//   }
// }

resource vm 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: vmName
  location: location
  tags: tags

  identity: {
    type: 'SystemAssigned'
  }

  properties: {
    hardwareProfile: {
      // vmSize: 'Standard_D2s_v3'

      vmSize: 'Standard_D2s_v5'
    }

    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }

    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-azure-edition'
        version: 'latest'
      }

      osDisk: {
        createOption: 'FromImage'
      }
    }



    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}


// resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing ={
//   name:KeyVaultName
// }

// resource secret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
//   parent: keyVault
//   name: 'vmAdminPassword'

//   properties: {
//     value: adminPassword
//     contentType: 'Password'
    
//   }
  
// }



output vmId string = vm.id
output principalId string = vm.identity.principalId
