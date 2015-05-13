###
History.js Core
@author Benjamin Arthur Lupton <contact@balupton.com>
@copyright 2010-2011 Benjamin Arthur Lupton <contact@balupton.com>
@license New BSD License <http://creativecommons.org/licenses/BSD/>
###
$ ->
  $('#container').highcharts
    chart:
      plotBackgroundColor: null
      plotBorderWidth: null
      plotShadow: false
    title: text: 'Contributions of users'
    tooltip: pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
    plotOptions: pie:
      allowPointSelect: true
      cursor: 'pointer'
      dataLabels:
        enabled: true
        format: '<b>{point.name}</b>: {point.percentage:.1f} %'
        style: color: Highcharts.theme and Highcharts.theme.contrastTextColor or 'black'
    series: [ {
      type: 'pie'
      name: 'Browser share'
      data: $('#container').data('contr')
        
      
        
        
      
    } ]
  
  $('#repo_chart').highcharts
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