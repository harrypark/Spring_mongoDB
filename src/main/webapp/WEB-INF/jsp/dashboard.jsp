<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en">
    <head>
    	<title>Intent Top10</title>
    	
    	<script src="https://code.highcharts.com/highcharts.js"></script>
		<script src="https://code.highcharts.com/modules/exporting.js"></script>
		<script src="https://code.highcharts.com/modules/export-data.js"></script>
		<script src="https://code.highcharts.com/modules/accessibility.js"></script>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
		<script src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.min.js"></script>
		
		
		
		<script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
		<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>

		
    	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
    	<link rel="stylesheet" href="https://cdn.datatables.net/1.10.20/css/jquery.dataTables.min.css">
		<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
		    	
    	<style type="text/css">
		.container {
		    height: 300px;
		}
		.dateRange {
			width: 200px;
		}
		    	
    	</style>
    </head>
    <body>
    <div class="container">
    	<h4><a href="<c:url value='/index'/>">Home</a></h4>
    	<form id="searchParam">
    	<div class="row border">
    		
    		<div class="col-3">
    			<select name="schSkillUuid" id="schSkillUuid">
		    		<option value="c9d7e581-723f-11ea-bc9b-022e2bbe7be0">피자주문</option>
		    	 </select>
    		</div>
    		<div class="col-3">
				    <input type="radio" name="schCategoryType" id="option1" value="daily" checked /> daily
				    <input type="radio" name="schCategoryType" id="option2" value="hourly" /> hourly
    		</div>
    		<div class="col-4">
    			<input type="hidden" name="schStartDt" id="schStartDt" value=""/>
    			<input type="hidden" name="schEndDt" id="schEndDt" value=""/>
    			<input type="text" name="dateRange" id="dateRange" class="dateRange" value=""/>
    		</div>
    		
    		<div class="col-2">
    			<button type="button" class="btn btn-outline-secondary" id="button-container">search</button>
    		</div>
    	</div>
    	</form>
    	<div class="row border">
    		<div class="col container" id="container_usage"></div>
    	</div>
    </div>
    
    
    
    
    <script type="text/javascript">
		var chart ;
		var chartRange;
		$(function(){
 			 $('#schStartDt').val(moment().subtract(6, 'days').format('YYYYMMDD'));
 			 $('#schEndDt').val(moment().format('YYYYMMDD'));
			
			$('#example').dataTable({
			});

			$('#dateRange').daterangepicker({
			    "autoApply": true,
			    ranges: {
			        'Today': [moment(), moment()],
			        'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
			        'Last 7 Days': [moment().subtract(6, 'days'), moment()],
			        'Last 30 Days': [moment().subtract(29, 'days'), moment()],
			        'This Month': [moment().startOf('month'), moment().endOf('month')],
			        'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
			    },
			    "locale": {
			        "format": "YYYY-MM-DD",
			        "separator": " ~ ",
			        "applyLabel": "Apply",
			        "cancelLabel": "Cancel",
			        "fromLabel": "From",
			        "toLabel": "To",
			        "customRangeLabel": "Custom",
			        "weekLabel": "W",
			        "daysOfWeek": [
			            "Su",
			            "Mo",
			            "Tu",
			            "We",
			            "Th",
			            "Fr",
			            "Sa"
			        ],
			        "monthNames": [
			            "January",
			            "February",
			            "March",
			            "April",
			            "May",
			            "June",
			            "July",
			            "August",
			            "September",
			            "October",
			            "November",
			            "December"
			        ],
			        "firstDay": 1
			    },
			    "alwaysShowCalendars": true,
// 			    "startDate": "04/17/2020",
// 			    "endDate": "04/23/2020",
// 			    "minDate": "01/04/2020",
// 			    "maxDate": "12/31/9999"
			    "startDate": moment().subtract(6, 'days'),
			    "endDate": moment(),
			    "minDate": "2020-03-01",
			    "maxDate": "9999-12-31"
			}, function(start, end, label) {
			  console.log('New date range selected: ' + start.format('YYYY-MM-DD') + ' to ' + end.format('YYYY-MM-DD') + ' (predefined range: ' + label + ')');
			  $('#schStartDt').val(start.format('YYYYMMDD'));
			  $('#schEndDt').val(end.format('YYYYMMDD'));
			});
			$('#dateRange').on('show.daterangepicker', function(ev, picker) {
				  console.log(picker.startDate.format('YYYY-MM-DD'));
				  console.log(picker.endDate.format('YYYY-MM-DD'));
				});



			
			// 검색 버튼 클릭 이벤트
			$( "button#button-container" ).on( "click", function( event ) {
				callApiUsage(); //api 호출
			});

		});

		
	var callApiUsage = function(){
		$.ajax({
			  url: '<c:url value="/api/usage"/>',
			  data: $("#searchParam").serialize(),
			  success: function( result ) {
				console.log("usage:"+result);
				
				columnLineChart(container_usage,  'Usage',0,result.categories,result.list);
			  }
			});
	} 
/*
	[{
        type: 'column',
        name: 'Jane',
        data: [3, 2, 1, 3, 4]
    }, {
        type: 'spline',
        name: 'Average',
        data: [3, 2.67, 3, 6.33, 3.33]
    
    }]
    */
	function columnLineChart(renderTo,  title, yMin, categories, data_array ) {
		new Highcharts.Chart({
			chart: {
				renderTo: renderTo,
				borderRadius: 0,
				backgroundColor: false,
				animation: Highcharts.svg, // don't animate in old IE
				/*
				, events: {
					load: function() {
						// set up the updating of the chart each second
						var series = this.series[0];
						var series2 = this.series[1];
						setInterval(function() {
							var x = (new Date()).getTime(), // current time
								y = Math.random(),
								z = Math.random();
							series.addPoint([x, y], false, true);
							series2.addPoint([x, z], true, true);
						}, 1000);
					}
				}
				*/
				zoomType: 'x'
			},
			title: {
				text: title,
			},
			xAxis: {
				categories: categories,
				title:false,
				lineColor: '#b2c0d0',
				gridLineWidth:false,
				tickColor: '#b2c0d0',
				//alternateGridColor: '#eff5f9',
				labels: {
					style: {
						color: '#3f6b9e'
					}
				}
			},
			yAxis: {
				//max: (unit=='%'?100:yMax),
				min: 0,
				lineWidth: 1,
				lineColor: '#b2c0d0',
				gridLineColor: '#b2c0d0',
				gridLineWidth:1,
				gridLineDashStyle:'dot',
				title:false,
				labels: {
					style: {
						color: '#3f6b9e'
					},
					formatter: function() {
		    			var maxElement = this.axis.max;
		    			var currValue = this.value;
		    			return currValue;

		    		}
				}

			},
			exporting: {
				enabled: false
			},
			credits: {
				enabled:false
			},
			legend: {
				align:'center',
				verticalAlign:'top',
				backgroundColor:'none',
	            borderWidth:0,
	            symbolWidth:9,
	            margin:5,
	            padding:0,
	            itemMarginTop:2,
	            maxHeight:39,
	            navigation: {
	                activeColor: '#3E576F',
	                animation: true,
	                arrowSize: 8,
	                inactiveColor: '#CCC',
	                style: {
	                    fontWeight: 'bold',
	                    color: '#333',
	                    fontSize: '11px'
	                }
	            },
	            itemStyle: {
	               cursor: 'pointer',
	               color: '#3f6b9e',
	               fontSize: '11px',
	               fontWeight:'normal',
	            }
			},
			tooltip: {
				crosshairs: {
					width:1,
					color:'rgba(103, 166, 255, 1)'
				},
				shared: true,
	            backgroundColor: 'rgba(255,255,255,0.5)',
	            borderWidth:1,
	            borderColor:'#b2c0d0',
	            shadow:false,
	            borderRadius:4,
	            style: {
	                color:'#000',
	                fontSize: '11px',
	                fontWeight: 'normal'
	            },
				xDateFormat:'%Y-%m-%d %H:%M:%S',
				pointFormat: '<span style="color:{series.color}">{series.name}</span>:{point.y}<br/>',
				/*
				formatter: function() {
					return '<b>'+ series.name +'</b><br/>'+ Highcharts.dateFormat('%Y-%m-%d %H:%M:%S', point.x) +'<br/>'+ Highcharts.numberFormat(point.y, 2);
				}
				*/
				//valueSuffix: ' ' + unit
			},
			plotOptions: {
				series: {
					fillOpacity: 0.3,
					lineWidth: 1,
					marker: {
						enabled: false,
						lineColor: '#fff',
						lineWidth: 1,
						radius: 2
					}
				}
			},
			series: data_array
		});

	}
	var callApiIntentData = function(){
		$('#example').dataTable().fnClearTable(); // 테이블 클리어
		$.ajax({
			  url: '<c:url value="/api/intent/data"/>',
			  data: $("#searchParam").serialize(),
			  success: function( result ) {
				  console.log(result);
				for(var i=0; i<result.length;i++ ){
					data = result[i];
					 $('#example').dataTable().fnAddData([
							data.intent,	data.intentCount, data.confidenceAvg, data.example , 'detail'
						]);
				}
				$('#example').dataTable().fnDraw();

				}
			});
	} 


	

		</script>
    </body>
</html>