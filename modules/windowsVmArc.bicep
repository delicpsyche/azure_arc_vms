param location string
param vmName string
param computerName string
param vmSize string
param adminUsername string
@secure()
param adminPassword string
param subnetId string
 
param arcTenantId string
param arcSubscriptionId string
param arcResourceGroup string
param arcServicePrincipalId string
@secure()
param arcServicePrincipalSecret string
param arcLocation string
 
resource pip 'Microsoft.Network/publicIPAddresses@2023-11-01' = {
  name: '${vmName}-pip'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}
 
resource nic 'Microsoft.Network/networkInterfaces@2023-11-01' = {
  name: '${vmName}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetId
          }
          publicIPAddress: {
            id: pip.id
          }
        }
      }
    ]
  }
}
 
resource vm 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: computerName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
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
 
resource arcExt 'Microsoft.Compute/virtualMachines/extensions@2023-09-01' = {
  parent: vm
  name: 'InstallArc'
  location: location
  dependsOn: [
    vm
  ]
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: [
        'https://raw.githubusercontent.com/delicpsyche/azure_arc_vms/main/scripts/install_arc_agent.ps1'
      ]
    }
    protectedSettings: {
      commandToExecute: 'powershell -ExecutionPolicy Unrestricted -File install_arc_agent.ps1 -tenantId "${arcTenantId}" -subscriptionId "${arcSubscriptionId}" -resourceGroup "${arcResourceGroup}" -location "${arcLocation}" -appId "${arcServicePrincipalId}" -password "${arcServicePrincipalSecret}" -adminUsername "${adminUsername}"'
    }
  }
}
