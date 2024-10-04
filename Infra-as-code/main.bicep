var applicationName = 'NexLabChaosStudio'
var environment = 'Lab'
var location = 'centralus'
var emailAddresses = ['alexandre.paolitto@nexusinno.com']

targetScope = 'subscription'

resource createResourceGroup 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: 'rg-${applicationName}-${environment}'
  location: location
}

module roleAssignments 'modules/roleAssignments.bicep' = {
  scope: createResourceGroup
  name: 'roleAssignments'
}

module keyVault 'modules/keyVault.bicep' = {
  scope: createResourceGroup
  name: 'keyVaultDeployment'
  params: {
    environment: environment
    location: location
    applicationName: applicationName
    enablePurgeProtection: false
  }
}

module appServicePlan 'modules/appServicePlan.bicep' = {
  scope: createResourceGroup
  name: 'appServicePlanDeployment'
  params: {
    environment: environment
    location: location
    applicationName: applicationName
  }
}

module appInsightApi 'modules/appInsight.bicep' = {
  scope: createResourceGroup
  name: 'apiAppInsightDeployment'
  params: {
    environment: environment
    location: location
    applicationName: applicationName
  }
}

module appService 'modules/appService.bicep' = {
  scope: createResourceGroup
  name: 'appServiceDeployment'
  params: {
    environment: environment
    location: location
    applicationName: applicationName
    appInsightsInstrumentationKey: appInsightApi.outputs.instrumentationKey
    serverFarmName: appServicePlan.outputs.serverFarmName
    keyVaultUri: keyVault.outputs.keyVaultUri
    secretName: notSoSecretSecret.outputs.secretName
  }
  dependsOn: [
    appInsightApi
    appServicePlan
    keyVault
    notSoSecretSecret
  ]
}

module chaosTesting 'modules/chaosTesting.bicep' = {
  scope: createResourceGroup
  name: 'chaosTestingDeployment'
  params: {
    location: 'eastus'
    appServiceName: appService.outputs.appServiceName
    applicationName: applicationName
    environment: environment
    keyVaultName: keyVault.outputs.name
  }
  dependsOn: [
    appService
    keyVault
  ]
}

module appServiceRoleAssignment 'modules/appServiceRoleAssignment.bicep' = {
  scope: createResourceGroup
  name: 'appServiceRoleAssignment'
  params: {
    appServiceName: appService.outputs.appServiceName
    roleDefinitionResourceId: roleAssignments.outputs.contributor
    principalIds: [chaosTesting.outputs.principalId]
  }
  dependsOn: [
    appService
    chaosTesting
  ]
}

module keyVaultRoleAssignment 'modules/keyVaultRoleAssignment.bicep' = {
  scope: createResourceGroup
  name: 'keyVaultRoleAssignment'
  params: {
    keyVaultName: keyVault.outputs.name
    roleDefinitionResourceId: roleAssignments.outputs.keyVaultSecretsUser
    principalIds: [appService.outputs.principalId]
  }
  dependsOn: [
    keyVault
    appService
  ]
}

module keyVaultContributorRoleAssignment 'modules/keyVaultRoleAssignment.bicep' = {
  scope: createResourceGroup
  name: 'keyVaultContributorRoleAssignment'
  params: {
    keyVaultName: keyVault.outputs.name
    roleDefinitionResourceId: roleAssignments.outputs.keyVaultContributor
    principalIds: [chaosTesting.outputs.principalId]
  }
  dependsOn: [
    keyVault
    chaosTesting
  ]
}

module notSoSecretSecret 'modules/keyVaultSecret.bicep' = {
  scope: createResourceGroup
  name: 'noSoSecretSecretDeployment'
  params: {
    name: 'mySecret'
    keyVault: keyVault.outputs.name
    value: 'Not so secret'
  }
}

module emailGroup 'modules/EmailGroup.bicep' = {
  scope: createResourceGroup
  name: 'EmailGroupDeployment'
  params: {
    emailAddresses: emailAddresses
    emailName: '${applicationName} ${environment} Notification'
  }
}

var alertRules = [
  'Http4xx'
  'Http5xx'
]

module AppServiceFailureAlertRule 'modules/alertRule.bicep' = [
  for alertRule in alertRules: {
    scope: createResourceGroup
    name: 'AppServiceFailure${alertRule}AlertRuleDeployment'
    params: {
      actionGroupId: emailGroup.outputs.id
      appServiceId: appService.outputs.appServiceId
      applicationName: applicationName
      environment: environment
      alertName: 'App service failure'
      metricName: 'Http4xx'
      operator: 'GreaterThanOrEqual'
      threshold: 1
      timeAggregation: 'Total'
      alertDescription: 'Alert when the calls to the service fails'
    }
    dependsOn: [
      emailGroup
      appService
    ]
  }
]
