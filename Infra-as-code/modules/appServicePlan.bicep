param environment string
param location string
param applicationName string

var sku = {
  name: 'S1'
  capacity: 1
}

resource appServicePlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: 'asp-${applicationName}-${environment}'
  location: location
  sku: sku
}

output serverFarmName string = appServicePlan.name
