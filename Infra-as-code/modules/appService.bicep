param environment string
param location string
param serverFarmName string
param keyVaultUri string
param appInsightsInstrumentationKey string
param applicationName string
param secretName string

resource appService 'Microsoft.Web/sites@2023-12-01' = {
  name: 'app-${applicationName}-${environment}'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: resourceId('Microsoft.Web/serverfarms', serverFarmName)
    clientAffinityEnabled: false
    httpsOnly: true
    siteConfig: {
      alwaysOn: true
      healthCheckPath: '/health'
      minTlsVersion: '1.3'
      http20Enabled: true
      netFrameworkVersion: '8.0'
      appSettings: [
        {
          name: 'KeyVaultUrl'
          value: keyVaultUri
        }
        {
          name: 'KeyVaultSecretName'
          value: secretName
        }
        {
          name: 'ASPNETCORE_ENVIRONMENT'
          value: environment
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsightsInstrumentationKey
        }
        {
          name: 'APPINSIGHTS_PROFILERFEATURE_VERSION'
          value: '1.0.0'
        }
        {
          name: 'DiagnosticServices_EXTENSION_VERSION'
          value: '~3'
        }
        {
          name: 'InstrumentationEngine_EXTENSION_VERSION'
          value: '~1'
        }
        {
          name: 'XDT_MicrosoftApplicationInsights_BaseExtensions'
          value: '~1'
        }
        {
          name: 'XDT_MicrosoftApplicationInsights_Mode'
          value: 'recommended'
        }
        {
          name: 'XDT_MicrosoftApplicationInsights_PreemptSdk'
          value: 'disabled'
        }
        {
          name: 'ApplicationInsightsAgent_EXTENSION_VERSION'
          value: '~2'
        }
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
      ]
      metadata: [
        {
          name: 'CURRENT_STACK'
          value: 'dotnetcore'
        }
      ]
    }
  }
}

resource appConfigLogs 'Microsoft.Web/sites/config@2023-12-01' = {
  name: 'logs'
  parent: appService
  properties: {
    applicationLogs: {
      fileSystem: {
        level: 'Information'
      }
    }
    detailedErrorMessages: {
      enabled: true
    }
    failedRequestsTracing: {
      enabled: true
    }
    httpLogs: {
      fileSystem: {
        enabled: true
        retentionInDays: 7
        retentionInMb: 50
      }
    }
  }
}

output principalId string = appService.identity.principalId
output appServiceName string = appService.name
output appServiceId string = appService.id
