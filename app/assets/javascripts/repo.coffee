jQuery ->
 Morris.Bar
  element: 'repo_chart'
  data: $('#repo_chart').data('repo')
  xkey: 'name'
  ykeys: ['open_issues_count']
  labels: ['Issue Count']
$('#print').click ->
    printMe()
printMe = ->
  xepOnline.Formatter.Format "repo_chart"
