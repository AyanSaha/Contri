###
History.js Core
@author Benjamin Arthur Lupton <contact@balupton.com>
@copyright 2010-2011 Benjamin Arthur Lupton <contact@balupton.com>
@license New BSD License <http://creativecommons.org/licenses/BSD/>
###
$ ->
  $("#repo_chart").highcharts
    title:
      text: "Github repositories analysis"
      x: -20 #center

    subtitle:
      text: "Source: github.com"
      x: -20

    xAxis:
      categories: $('#repo_chart').data('ydata')

    yAxis:
      title:
        text: "Issues"

      plotLines: [
        value: 0
        width: 1
        color: "#808080"
       ]

    tooltip:
      valueSuffix: ""

    legend:
      layout: "vertical"
      align: "right"
      verticalAlign: "middle"
      borderWidth: 0
    credits:
      enabled: false
    series: [
      name: "Issues"
      data: $('#repo_chart').data('xdata')
   
     ]
  chart=$("#repo_chart").highcharts();
  chart.exportChart
    type: 'application/pdf'
    filename: 'Issues'
