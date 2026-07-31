// param location string = resourceGroup().location
targetScope = 'subscription'
param location string
param environment string
param vmName string
param adminUsername string
@secure()
param adminPassword string 
param rgname string


var tags = {
  Environment: environment
  Owner: 'CloudTeam'
  Project: 'LandingZone'
}


module mgmodule './modules/resourcegroup.bicep' = {
    name: '${deployment().name}-MGMODULE'
  scope: subscription()
  params: {
    rgname: rgname
    location: location

  }
}
//
// NSG
// test
//
module nsg './modules/networking/nsg.bicep' = {
  name: 'nsgDeploy'
  scope: resourceGroup(rgname)
  dependsOn: [
    mgmodule
  ]
  params: {
    location: location
    nsgName: '${vmName}-nsg'
    tags: {
      Environment: environment
      Owner: 'CloudTeam'
      Project: 'LandingZone'
    }
  }
}


// VNET

module vnet './modules/networking/vnet.bicep' = {
  name: 'vnetDeploy'
  scope: resourceGroup(rgname)
  dependsOn: [
    mgmodule
  ]
  params: {
    vnetName: 'enterprise-vnet'
    subnetname: 'app-subnet'
    location: location
    nsgId: nsg.outputs.nsgId
    tags: tags
  }
}
// module vnet2 './modules/networking/vnet.bicep' = {
//   name: 'vnetDeploy02'
//   scope: resourceGroup(rgname)
//   dependsOn: [
//     mgmodule
//   ]
//   params: {
//     vnetName: 'enterprise-vnet02'
//     subnetname: 'app-subnet02'
//     location: location
//     nsgId: nsg.outputs.nsgId
//     tags: tags
//   }
// }
// demo
// demo2



// KEY VAULT

module keyVault './modules/security/keyvault.bicep' = {
  name: 'uniqueString-hello'
  scope:resourceGroup(rgname)
  dependsOn:[
    mgmodule
  ]
  params: {
    keyVaultName:'kv011'
    location: location
    // adminPassword: adminPassword
    tags: tags
  }
}
// module keyVault1 './modules/security/keyvault.bicep' = {
//   name: 'uniqueString-hello'
//   scope:resourceGroup(rgname)
//   dependsOn:[
//     mgmodule
//   ]
//   params: {
//     keyVaultName:'kv02'
//     location: location
//     // adminPassword: adminPassword
//     tags: tags
//   }
// }


// VM
//
// module vm './modules/compute/vm.bicep' = {
//   name: 'vmDeploy'
//   scope: resourceGroup(rgname)
//   dependsOn: [
//     mgmodule
//   ]
//   params: {
//     location: location
//     vmName: vmName
//     subnetId: vnet.outputs.subnetId
//     adminUsername: adminUsername
//     adminPassword: adminPassword
//     tags: tags
//   }

// }


// VM Module
//
module vm2 './modules/compute/vm.bicep' = {
  name: 'vmDeploy'
  scope: resourceGroup(rgname)
  dependsOn: [
    mgmodule
  ]
  params: {
    location: location
    vmName: vmName
    subnetId: vnet.outputs.subnetId
    adminUsername: adminUsername
    adminPassword: adminPassword
    KeyVaultName: keyVault.outputs.keyVaultName
    tags: tags
  }
}
module vm3 './modules/compute/vm.bicep' = {
  name: 'vmDeploy'
  scope: resourceGroup(rgname)
  dependsOn: [
    mgmodule
  ]
  params: {
    location: location
    vmName: 'dev-vm2'
    subnetId: vnet.outputs.subnetId
    adminUsername: adminUsername
    adminPassword: adminPassword
    KeyVaultName: keyVault.outputs.keyVaultName
    tags: tags
  }
}

// testing
// param virtualMachines array

// module vm './modules/compute/vm.bicep' = [for vm in virtualMachines: {
//   name: 'vm-${vm.name}'
//   scope:resourceGroup(rgname)

//   params: {
//     location:location
//     vmName: vm.name
//     adminUsername: vm.adminUsername
//     subnetId: vm.subnetId
//     KeyVaultName: vm.keyVaultName

//     // Password comes from the virtualMachines array
//     adminPassword: vm.adminPassword
//     tags:vm.tags
//   }
// }]

// module vm2 './modules/compute/vm.bicep' = {
//   name: 'vmDeploy02'

//   params: {
//     location: location
//     vmName: 'appvm02'
//     subnetId: vnet.outputs.subnetId
//     adminUsername: adminUsername
//     adminPassword: adminPassword
//     tags: tags
//   }
// }

//
// ALERT
//
// module alert './modules/monitoring/alert.bicep' = {
//   name: 'alertDeploy'
//   scope: resourceGroup(rgname)
//   dependsOn: [
//     mgmodule
//   ]
//   params: {
//     vmId: vm.outputs.vmId
//   }
// }

// route table 
// Route Table
// Route Table (module reference)
// targetScope = 'resourceGroup'

// param location string = resourceGroup().location

// module routeTable './modules/routing/routetable.bicep' = {
//   name: 'routeTableDeployment'
//   scope: resourceGroup(rgname)
//   dependsOn: [
//     mgmodule
//   ]

//   params: {
//     routeTableName: 'rt-dev-001'
//     location: location

//     disableBgpRoutePropagation: false

//     routes: [
//       {
//         name: 'default-route'

//         properties: {
//           addressPrefix: '0.0.0.0/0'
//           nextHopType: 'VirtualAppliance'
//           nextHopIpAddress: '10.0.0.4'
//         }
//       }
//       {
//         name: 'internal-route'

//         properties: {
//           addressPrefix: '10.1.0.0/16'
//           nextHopType: 'VnetLocal'
//         }
//       }
//     ]
//   }
// }

















































// param rgName string = 'myEnterpriseRG'
// targetScope = 'subscription'
// param location string = 'eastus'
// param rgTags object = {
//   environment: 'production'
//   owner: 'enterprise-team'
//   costCenter: 'CC1234'
//   compliance: 'ISO27001'
// }

// resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
//   name: rgName
//   location: location
//   tags: rgTags
// }

// module vnet './modules/networking/vnet.bicep' = {
//   name: 'vnetDeployment'
//   scope: rg
//   params: {
//     vnetName: 'enterprise-vnet'
//     location: location
//     addressSpace: [
//       '10.0.0.0/16'
//     ]
//     vnetTags: rgTags
//   }
// }


