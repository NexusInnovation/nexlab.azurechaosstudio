param applicationName string
param environment string
param appServiceId string
param actionGroupId string
@allowed(['Http4xx', 'Http5xx', 'HealthCheckStatus'])
param metricName string
param alertName string
param alertDescription string = ''
@allowed([0, 1, 2, 3, 4])
param severity int = 2
@allowed(['LessThan', 'LessThanOrEqual', 'GreaterThan', 'GreaterThanOrEqual'])
param operator string
param threshold int
@allowed(['Average', 'Count', 'Maximum', 'Minimum', 'Total'])
param timeAggregation string

resource alertRule 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: 'ma-${applicationName}-${alertName}-${environment}'
  location: 'global'
  properties: {
    description: alertDescription
    severity: severity
    enabled: true
    scopes: [
      appServiceId
    ]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allOf: [
        {
          name: 'Criterion1'
          criterionType: 'StaticThresholdCriterion'
          metricName: metricName
          operator: operator
          threshold: threshold
          timeAggregation: timeAggregation
        }
      ]
    }
    actions: [
      {
        actionGroupId: actionGroupId
      }
    ]
  }
}
