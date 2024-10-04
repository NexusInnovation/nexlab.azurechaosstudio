param location string = 'eastus' // At the time of writing these are the supported regions : westcentralus,eastus,centralus,westus3,uksouth,westus,northeurope,westeurope,japaneast,northcentralus,eastus2,australiaeast,eastasia,brazilsouth,swedencentral,westus2,southeastasia'
param applicationName string
param appServiceName string
param keyVaultName string
param environment string

// Here you can find the fault library with information such as urn, capability, ... :
// https://learn.microsoft.com/en-us/azure/chaos-studio/chaos-studio-fault-library

resource appService 'Microsoft.Web/sites@2023-12-01' existing = {
  name: appServiceName
}

resource keyVault 'Microsoft.KeyVault/vaults@2024-04-01-preview' existing = {
  name: keyVaultName
}

param experimentSteps array = [
  {
    name: 'Step1'
    branches: [
      {
        name: 'Branch1'
        actions: [
          {
            name: 'urn:csci:microsoft:appService:stop/1.0'
            type: 'continuous'
            duration: 'PT1M'
            selectorId: 'Selector1'
          }
          {
            name: 'urn:csci:microsoft:keyVault:denyAccess/1.0'
            type: 'continuous'
            duration: 'PT5M'
            selectorId: 'Selector2'
          }
        ]
      }
    ]
  }
]

resource chaosAppServiceTarget 'Microsoft.Chaos/targets@2024-03-22-preview' = {
  name: 'Microsoft-AppService'
  location: location
  scope: appService
  properties: {}
}

resource chaosAppServiceCapability 'Microsoft.Chaos/targets/capabilities@2024-03-22-preview' = {
  name: 'Stop-1.0'
  parent: chaosAppServiceTarget
}

resource chaosKeyVaultTarget 'Microsoft.Chaos/targets@2024-03-22-preview' = {
  name: 'Microsoft-KeyVault'
  location: location
  scope: keyVault
  properties: {}
}

resource chaosKeyVaultCapability 'Microsoft.Chaos/targets/capabilities@2024-03-22-preview' = {
  name: 'DenyAccess-1.0'
  parent: chaosKeyVaultTarget
}

resource chaosExperiment 'Microsoft.Chaos/experiments@2024-03-22-preview' = {
  name: 'chexp-${applicationName}-${environment}'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    selectors: [
      {
        id: 'Selector1'
        type: 'List'
        targets: [
          {
            id: chaosAppServiceTarget.id
            type: 'ChaosTarget'
          }
        ]
      }
      {
        id: 'Selector2'
        type: 'List'
        targets: [
          {
            id: chaosKeyVaultTarget.id
            type: 'ChaosTarget'
          }
        ]
      }
    ]
    steps: experimentSteps
  }
}

output principalId string = chaosExperiment.identity.principalId
