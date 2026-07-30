param location string

// @secure()
// param adminPassword string

param tags object

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: 'enterprise-kv-0095'
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
    objectId: '9efcd157-e5c9-4dba-a9a3-001cc25a8d04'// paste actual Object ID here
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
