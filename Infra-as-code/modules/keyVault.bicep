param environment string
param location string
param applicationName string
param enablePurgeProtection bool

resource keyVault 'Microsoft.KeyVault/vaults@2024-04-01-preview' = {
  name: 'kv-${applicationName}-${environment}'
  location: location
  properties: {
    enabledForDeployment: false
    enabledForTemplateDeployment: false
    enabledForDiskEncryption: false
    enablePurgeProtection: enablePurgeProtection ? enablePurgeProtection : null // Yes, true or null instead of false is a weird behavior...
    publicNetworkAccess: 'Enabled'
    tenantId: subscription().tenantId
    enableRbacAuthorization: true
    sku: {
      name: 'standard'
      family: 'A'
    }
  }
}

output id string = keyVault.id
output name string = keyVault.name
output keyVaultUri string = keyVault.properties.vaultUri
