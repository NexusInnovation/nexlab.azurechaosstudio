param name string
param keyVault string
@secure()
param value string

resource secret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  name: '${keyVault}/${name}'
  properties: {
    value: value
  }
}

output secretName string = name
