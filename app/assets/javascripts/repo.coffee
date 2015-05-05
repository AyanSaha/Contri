jQuery ->
 Morris.Line
  element: 'repo_chart'
  data: $('#repo_chart').data('repo')
  xkey: 'name'
  ykeys: ['open_issues_count']
  labels: ['Issue Count']
