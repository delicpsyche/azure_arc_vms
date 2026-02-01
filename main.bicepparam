using './main.bicep'

// Change as needed
param location = 'centralindia'
param vmSize = 'Standard_D4s_v3'
 

// add as many VMs to the array , currently 2 VMs will deploy 
param vmNames = [
  'prod-ci-dc02-win01'
  'prod-ci-dc02-win02'
]
 
// FILL
param adminUsername = 'windcadmin01'
param adminPassword = ''  // FILL IN THE PASSWORD
 
param vnetAddressPrefix = '172.16.10.0/24'
param subnetPrefix = '172.16.10.0/26'


// FILL
// Your public IP address - use '*' . #curl ifconfig.me to get IP
param rdpSourceIpAddress = ''  // Example: '203.0.113.0/32' or '203.0.113.45'


// FILL
// Make sure Arc SP has been granged the necessary role for the RG scope
param arcTenantId = ''   // Tenant ID
param arcSubscriptionId = ''  // Subscription ID
param arcResourceGroup = ''   // Resource Group Name
param arcServicePrincipalId = '' // Client/App ID of the SP
param arcServicePrincipalSecret = ''   //Client Secret
param arcLocation = ''   // Location


