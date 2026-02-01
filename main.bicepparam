using './main.bicep'

// Change as needed
param location = 'centralindia'
param vmSize = 'Standard_D4s_v3'
 

// add as many VMs to the array , currently 2 VMs will deploy 
param vmNames = [
  'prod-ci-dc02-win01'
  'prod-ci-dc02-win02'
]
 
param adminUsername = 'Administrator'
param adminPassword = ''  // fill the password
 
param vnetAddressPrefix = '172.16.10.0/24'
param subnetPrefix = '172.16.10.0/26'
 

// Make sure Arc SP has been granged the necessary role for the RG scope

param arcTenantId = ''   // Tenant ID
param arcSubscriptionId = ''  // Subscription ID
param arcResourceGroup = ''   // Resource Group Name
param arcServicePrincipalId = '' // Client/App ID of the SP
param arcServicePrincipalSecret = ''   //Client Secret
param arcLocation = ''   // Location
