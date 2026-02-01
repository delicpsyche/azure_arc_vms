param location string
param vnetAddressPrefix string
param subnetPrefix string
param nsgId string
 
resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: 'prod-ci-dc02-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: subnetPrefix
          networkSecurityGroup: {
            id: nsgId
          }
        }
      }
    ]
  }
}
 
output subnetId string = vnet.properties.subnets[0].id
