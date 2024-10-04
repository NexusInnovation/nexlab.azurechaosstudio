param environment string
param location string
param applicationName string

resource appInsightsComponents 'Microsoft.Insights/components@2020-02-02' = {
  name: 'appi-${applicationName}-${environment}'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

output id string = appInsightsComponents.id
output instrumentationKey string = appInsightsComponents.properties.InstrumentationKey
output name string = appInsightsComponents.name
