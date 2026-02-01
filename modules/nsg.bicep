param location string
 
resource nsg 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: 'prod-ci-dc02-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-RDP'
        properties: {
          priority: 1000
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}
 
output nsgId string = nsg.id
