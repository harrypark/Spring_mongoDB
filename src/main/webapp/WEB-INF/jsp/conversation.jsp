<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en">
    <head>
    	<title>conversation</title>
    	
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
		    	
    	</style>
    </head>
    <body>
    <div class="container">
    	<h4><a href="<c:url value='/index'/>">Home</a></h4>
    	<form id="searchParam">
    	<div class="row border">
    		
    		<div class="col-3">
    			<select name="skillUuid" id="skillUuid">
		    		<option value="c9d7e581-723f-11ea-bc9b-022e2bbe7be0">피자주문</option>
		    	 </select>
    		</div>
    		<div class="col-3">
				    <input type="radio" name="categoryType" id="option1" value="daily" checked /> daily
				    <input type="radio" name="categoryType" id="option2" value="hourly" /> hourly
    		</div>
    		<div class="col-4">
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
				callApiIntentData(); //api 호출
			});

		});

		
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