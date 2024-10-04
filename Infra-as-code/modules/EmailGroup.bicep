param emailAddresses array
param emailName string

resource emailActionGroup 'microsoft.insights/actionGroups@2023-01-01' = {
  name: 'Nexus e-mail action group'
  location: 'global'
  properties: {
    groupShortName: 'Nexus'
    enabled: true
    emailReceivers: [for emailAddress in emailAddresses: {
      name: '${emailName} - ${emailAddress}'
      emailAddress: emailAddress
      useCommonAlertSchema: true
    }]
  }
}

output id string = emailActionGroup.id
