param location string

// @secure()
// param adminPassword string
param keyVaultName string

param tags object

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  tags: tags

  properties: {
    tenantId: subscription().tenantId

    sku: {
      family: 'A'
      name: 'standard'
    }

    enableRbacAuthorization: false
    accessPolicies: [
  {
    tenantId: subscription().tenantId
    objectId: 'ecf7362b-1f37-4001-a7ab-ad4817c4af66'// paste actual Object ID here
    permissions: {
      secrets: [ 'get', 'list', 'set', 'delete' ]
      keys:    [ 'get', 'list', 'create', 'delete' ]
      certificates: [ 'get', 'list', 'create', 'delete' ]
    }
  }
]


    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    // enablePurgeProtection: true

      // for security
  // softDeleteRetentionInDays: 90

  publicNetworkAccess: 'Enabled'

  networkAcls: {
    bypass: 'AzureServices'
    defaultAction: 'Allow'
  }
  }
}


output keyVaultId string = keyVault.id
output keyVaultName string = keyVault.name
