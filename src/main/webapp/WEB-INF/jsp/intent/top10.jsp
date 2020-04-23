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
    	<form id="searchParam">
    	<div class="row border">
    		
    		<div class="col-4">
    			<select name="skillUuid" id="skillUuid">
		    		<option value="c9d7e581-723f-11ea-bc9b-022e2bbe7be0">피자주문</option>
		    	 </select>
    		</div>
    		<div class="col-6">
    			<input type="hidden" name="startDt" id="startDt" value=""/>
    			<input type="hidden" name="endDt" id="endDt" value=""/>
    			<input type="text" name="dateRange" id="dateRange" class="dateRange" value=""/>
    		</div>
    		
    		<div class="col-2">
    			<button type="button" class="btn btn-outline-secondary" id="button-container">search</button>
    		</div>
    	</div>
    	</form>
    	<div class="row border">
    		<div class="col-4 container" id="container_it10"></div>
    		<div class="col-4 container" id="container_et10"></div>
    		<div class="col-4 container bd-example" id="container_avg_confidence">
    			<div>Avg. Confidence</div>
    			<div>today</div>
    			<div class="progress">
				  <div id="todayIntentConfidenceAvg" class="progress-bar bg-success" role="progressbar" style="width: 0%;" aria-valuenow="0.0" aria-valuemin="0" aria-valuemax="100"></div>
				</div>
				<div>last 7days</div>
				<div class="progress">
				  <div id="last7dayIntentConfidenceAvg" class="progress-bar bg-info" role="progressbar" style="width: 0%;" aria-valuenow="0.0" aria-valuemin="0" aria-valuemax="100"></div>
				</div>
    		</div>
    	</div>
    	<div class="row border">
    		<div class="col container" id="usage">
    			<table id="example" class="display" style="width:100%">
			        <thead>
			            <tr>
			                <th>Intent Name</th>
			                <th>Count</th>
			                <th>Avg. Confidence</th>
			                <th>Example</th>
			                <th>Details</th>
			            </tr>
			        </thead>
			    </table>
    		</div>
    	</div>
    </div>
    
    
    
    
    <script type="text/javascript">
		var chart ;
		var chartRange;
		$(function(){
 			 $('#startDt').val(moment().subtract(6, 'days').format('YYYYMMDD'));
 			 $('#endDt').val(moment().format('YYYYMMDD'));
			
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
			  $('#startDt').val(start.format('YYYYMMDD'));
			  $('#endDt').val(end.format('YYYYMMDD'));
			});
			$('#dateRange').on('show.daterangepicker', function(ev, picker) {
				  console.log(picker.startDate.format('YYYY-MM-DD'));
				  console.log(picker.endDate.format('YYYY-MM-DD'));
				});



			
			// 검색 버튼 클릭 이벤트
			$( "button#button-container" ).on( "click", function( event ) {
				callApiIntentTop10(); //api 호출
				callApiEntityTop10(); //api 호출
				callApiConfidenceAvg();
				callApiIntentData();
			});

		});

		
	var callApiIntentTop10 = function(){
		var categories = new Array();
		var data = new Array();	
		$.ajax({
			  url: '<c:url value="/api/intent/top10"/>',
			  data: $("#searchParam").serialize(),
			  success: function( result ) {
				console.log("intentTop10:"+result);
				if(result.length >0){
					for(var i=0; i < result.length ; i++){
						categories.push(result[i].intent);
						data.push(result[i].intentCount);
					}
					options.chart.renderTo = 'container_it10';
					options.title.text='Intent Top10';
					options.subtitle.text = $('#dateRange').val();
					options.xAxis.categories = categories;
					options.series[0].data = data;
					chart = new Highcharts.Chart(options);
				}else{
					$('#container_it10').empty().text('No Data.');
				}
			  }
			});
	} 

	var callApiEntityTop10 = function(){
		var categories = new Array();
		var data = new Array();	
		$.ajax({
			  url: '<c:url value="/api/entity/top10"/>',
			  data: $("#searchParam").serialize(),
			  success: function( result ) {
				console.log("entityTop10:"+result);
				if(result.length >0){
					for(var i=0; i < result.length ; i++){
						categories.push(result[i].value);
						data.push(result[i].entityCount);
					}
					options.chart.renderTo = 'container_et10';
					options.title.text='Entity_value Top10';
					options.subtitle.text = $('#dateRange').val();
					options.xAxis.categories = categories;
					options.series[0].data = data;
					chart = new Highcharts.Chart(options);
				}else{
					$('#container_et10').empty().text('No Data.');
				}
			  }
			});
	} 

	var callApiConfidenceAvg = function(){
		var todayIntentConfidenceAvg = 0.0;
		var last7dayIntentConfidenceAvg = 0.0;
		$.ajax({
			  url: '<c:url value="/api/intent/confidenceAvg"/>',
			  data: {skillUuid : $('#skillUuid').val()},
			  success: function( result ) {
				  console.log("callApiConfidenceAvg:"+result);
				  todayIntentConfidenceAvg = result.today.toFixed(2);
				  last7dayIntentConfidenceAvg = result.last7day.toFixed(2);	
				  $('#todayIntentConfidenceAvg').attr('aria-valuenow',todayIntentConfidenceAvg).css('width',todayIntentConfidenceAvg+'%').text(todayIntentConfidenceAvg+'%');
				  $('#last7dayIntentConfidenceAvg').attr('aria-valuenow',last7dayIntentConfidenceAvg).css('width',last7dayIntentConfidenceAvg+'%').text(last7dayIntentConfidenceAvg+'%');
				
				
				}
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


	var options = {
		    chart: {
		        type: 'bar'
		    },
		    title: {
		        text: 'Intent(Top10)'
		    },
		    subtitle: {
		        text: '' 
		    },
		    xAxis: {
		        categories: null,
		        title: {
		            text: null
		        }
		    },
		    yAxis: {
		     // categories: ['Africa', 'America', 'Asia', 'Europe', 'Oceania'],
		        min: 0,
		        title: {
		            text: '',
		            align: 'high'
		        },
		        labels: {
		            overflow: 'justify'
		        }
		    },
		    tooltip: {
		    	pointFormat: '{point.name}: {point.y}'
		    },
		    plotOptions: {
		        bar: {
		            dataLabels: {
		                enabled: true		            }
		        }
		    },
		    legend: {
		    	enabled: false,
		        
		    },
		    credits: {
		        enabled: false
		    },
		    series: [{
				        data :  null   
				    }]
		}
	
	
		

		</script>
    </body>
</html>