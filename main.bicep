targetScope = 'resourceGroup'
 
param location string
param adminUsername string
@secure()
param adminPassword string
 
param vmSize string
param vmNames array
 
param vnetAddressPrefix string
param subnetPrefix string
 
param arcTenantId string
param arcSubscriptionId string
param arcResourceGroup string
param arcServicePrincipalId string
@secure()
param arcServicePrincipalSecret string
param arcLocation string
 
module nsg './modules/nsg.bicep' = {
  name: 'nsgDeploy'
  params: {
    location: location
  }
}
 
module vnet './modules/vnet.bicep' = {
  name: 'vnetDeploy'
  params: {
    location: location
    vnetAddressPrefix: vnetAddressPrefix
    subnetPrefix: subnetPrefix
    nsgId: nsg.outputs.nsgId
  }
}
 
var vmIndexRange = range(0, length(vmNames))
 
module vms './modules/windowsVmArc.bicep' = [
  for idx in vmIndexRange: {
    name: 'vm-${vmNames[idx]}'
    params: {
      location: location
      vmName: vmNames[idx]
 
      // Windows NetBIOS-safe (≤15 chars)
      computerName: 'dc02w${idx + 1}'
 
      vmSize: vmSize
      adminUsername: adminUsername
      adminPassword: adminPassword
      subnetId: vnet.outputs.subnetId
 
      arcTenantId: arcTenantId
      arcSubscriptionId: arcSubscriptionId
      arcResourceGroup: arcResourceGroup
      arcServicePrincipalId: arcServicePrincipalId
      arcServicePrincipalSecret: arcServicePrincipalSecret
      arcLocation: arcLocation
    }
  }
]
