param keyVaultName string
param principalIds array
param roleDefinitionResourceId string
param resourceGroupName string = ''

resource keyVault 'Microsoft.KeyVault/vaults@2024-04-01-preview' existing = {
  scope: resourceGroup(resourceGroupName)
  name: keyVaultName
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for principalId in principalIds: {
    name: guid(keyVault.id, principalId, roleDefinitionResourceId)
    properties: {
      roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionResourceId)
      principalId: principalId
      principalType: 'ServicePrincipal'
    }
  }
]
