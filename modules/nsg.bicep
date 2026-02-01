param location string
param rdpSourceIpAddress string = '*' // Default to allow all, set to your public IP for security

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
          sourceAddressPrefix: rdpSourceIpAddress
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}
 
output nsgId string = nsg.id
