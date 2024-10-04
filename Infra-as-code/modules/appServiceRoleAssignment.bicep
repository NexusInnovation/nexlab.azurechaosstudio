param appServiceName string
param principalIds array
param roleDefinitionResourceId string
param resourceGroupName string = ''

resource appService 'Microsoft.Web/sites@2023-12-01' existing = {
  scope: resourceGroup(resourceGroupName)
  name: appServiceName
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for principalId in principalIds: {
    name: guid(appService.id, principalId, roleDefinitionResourceId)
    properties: {
      roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionResourceId)
      principalId: principalId
      principalType: 'ServicePrincipal'
    }
  }
]
