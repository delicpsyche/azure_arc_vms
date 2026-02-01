## Pre-requisites 

```
az provider register --namespace Microsoft.HybridCompute
az provider register --namespace Microsoft.GuestConfiguration
az provider register --namespace Microsoft.HybridConnectivity
```

Check and confim the registration succeeded

```powershell
Get-AzResourceProvider |
Where-Object { $_.ProviderNamespace -in @(
    "Microsoft.HybridCompute",
    "Microsoft.GuestConfiguration",
    "Microsoft.HybridConnectivity"
)} | Select-Object ProviderNamespace, RegistrationState
```


## Create Resrouce Group
```powershell
az group create --name "<Resource Group Name>" --location "<Location>"
```

## Create the Service Principal
```powershell
az ad sp create-for-rbac  --name spn-arc-onboarding   --skip-assignment
```

_Save the ID/secret to be used later for params_
```json
  {
  "appId": "XXXXXX-XXXX-XXXX-YYYY-YYYYYYYYY",
  "displayName": "spn-arc-onboarding",
  "password": "asdfkjqewron@!#lj23465adad",
  "tenant": "XXXXXX-de04-CCCC-BBBB-XXXXXXXXX"
}
```

## Assign necessary Roles
```powershell
az role assignment create  --assignee '<SPN App/Client ID>'  --role "Azure Connected Machine Onboarding"  --scope '/subscriptions/<Subscription ID>/resourceGroups/<Resource Group Name>'
```


## Modify the main.bicepparm
Modify the values with your custom attributes

### NSG update for PIP
```powershell
# Get your IP
$myIp = (Invoke-RestMethod https://ifconfig.me/ip).Trim()
Write-Host "Your IP: $myIp"

# Update the bicepparam file automatically
(Get-Content main.bicepparam) -replace "param rdpSourceIpAddress = ''", "param rdpSourceIpAddress = '$myIp/32'" | Set-Content main.bicepparam
```


## Deployment
```powershell
az deployment group create -g <Resource Group Name> -f main.bicep -p main.bicepparam
```