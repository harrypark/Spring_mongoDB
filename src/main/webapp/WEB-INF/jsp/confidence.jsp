<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en">
    <head>
    	<title>confidence</title>
    	
    	<script src="https://code.highcharts.com/highcharts.js"></script>
		<script src="https://code.highcharts.com/modules/exporting.js"></script>
		<script src="https://code.highcharts.com/modules/export-data.js"></script>
		<script src="https://code.highcharts.com/modules/accessibility.js"></script>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
		<script src="https://cdn.datatables.net/1.10.20/js/jquery.dataTables.min.js"></script>
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
		
		
		
		<script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
		<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>

		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
<!--     	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous"> -->
    	<link rel="stylesheet" href="https://cdn.datatables.net/1.10.20/css/jquery.dataTables.min.css">
		<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
		    	
    	<style type="text/css">
		   .container {
			    height: 458px;
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
    		<div class="col-6 container">
    			<div class="row border" style="height: 50px;">
    				<div class="col">
		    			<div>Total Avg.</div>
		    			<div class="progress">
						  <div id="confidenceAvg" class="progress-bar bg-success" role="progressbar" style="width: 0%;" aria-valuenow="0.0" aria-valuemin="0" aria-valuemax="100"></div>
						</div>
    				</div>
    			</div>
    			<div class="row border">
    				<div class="col" id="scatterChart">
    				</div>
    			</div>
    		</div>
    		<div class="col-6 container">
    			
    		</div>
    	</div>
    	<div class="row border">
    		<div class="col container" id="usage">
    			<table id="example" class="display" style="width:100%">
			        <thead>
			            <tr>
			                <th>Date</th>
			                <th>0~20%</th>
			                <th>20~40%</th>
			                <th>40~60%</th>
			                <th>60~80%</th>
			                <th>80~100%</th>
			            </tr>
			        </thead>
			    </table>
    		</div>
    	</div>
    </div>
    
    <!-- Modal -->
   
	<div class="modal fade bd-example-modal-lg" id="modalpopupid" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog modal-lg" role="document" >
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Modal title</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <div class="container-fluid">
		    <div class="row border">
		      <div class="col-md-6">.col-md-3 .ml-auto</div>
		      <div class="col-md-6">.col-md-2 .ml-auto</div>
		    </div>
		    <div class="row border">
		      <div class="col-md-6">.col-md-3 .ml-auto</div>
		      <div class="col-md-6">.col-md-2 .ml-auto</div>
		    </div>
		    <div class="row border">
		      <div class="col">.col-md-6 .ml-auto</div>
		    </div>
		  </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary">Save changes</button>
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>
    
    
    
    
    <script type="text/javascript">
		
		$(function(){
 			 $('#schStartDt').val(moment().subtract(6, 'days').format('YYYYMMDD'));
 			 $('#schEndDt').val(moment().format('YYYYMMDD'));


//  			  todayIntentConfidenceAvg = result.today.toFixed(2);
			  $('#confidenceAvg').attr('aria-valuenow',35.25).css('width',35.25+'%').text(35.25+'%');
			
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
				callApiConfidenceData(); //api 호출
			});

			var table = $('#example').DataTable();
			$('#example').on( 'click', 'tr', function () {
			    var id = $(this).attr('id');
			    console.log(id);
			 
			    $("#modalpopupid").modal("show"); 
			} );

			$('#modalpopupid').on('show.bs.modal', function (e) {
				  console.log('모달 show');
			})
			
			
			scatterChart("scatterChart",null);
		});

		
		var callApiConfidenceData = function(){
			$('#example').dataTable().fnClearTable(); // 테이블 클리어
			$.ajax({
				  url: '<c:url value="/api/intent/confidence"/>',
				  data: $("#searchParam").serialize(),
				  success: function( result ) {
					  console.log(result);
						/*
						for(var i=0; i<result.length;i++ ){
							data = result[i];
							var rowIndex = $('#example').dataTable().fnAddData([
									data.date,data.inputType,data.inputText,data.intent,data.intentConfidence.toFixed(2) , data.user , 'detail'
								]);
							var row = $('#example').dataTable().fnGetNodes(rowIndex);
							$(row).attr('id', data.id);
// 					 		$(nTr).click(function(){
// 								console.log($(this).attr('id');
// 						 	});
						}
						$('#example').dataTable().fnDraw();
						*/
						

					}
				});
		} 

		var scatterChart = function(renderTo,data_array){
			Highcharts.chart(renderTo, {
			    chart: {
			        type: 'scatter',
			        zoomType: 'xy'
			    },
			    title: {
			        text: 'Height Versus Weight of 507 Individuals by Gender'
			    },
			    subtitle: {
			        text: 'Source: Heinz  2003'
			    },
			    xAxis: {
			    	min: 0,
			    	max:100,
			        title: {
			            enabled: true,
			            text: 'Height (cm)'
			        },
			        startOnTick: true,
			        endOnTick: true,
			        showLastLabel: true
			    },
			    yAxis: {
			    	min: 0,
			        title: {
			            text: 'Weight (kg)'
			        }
			    },
			    legend: {
			        layout: 'vertical',
			        align: 'left',
			        verticalAlign: 'top',
			        x: 100,
			        y: 70,
			        floating: true,
			        backgroundColor: Highcharts.defaultOptions.chart.backgroundColor,
			        borderWidth: 1
			    },
			    plotOptions: {
			        scatter: {
			            marker: {
			                radius: 5,
			                states: {
			                    hover: {
			                        enabled: true,
			                        lineColor: 'rgb(100,100,100)'
			                    }
			                }
			            },
			            states: {
			                hover: {
			                    marker: {
			                        enabled: false
			                    }
			                }
			            },
			            tooltip: {
			                headerFormat: '<b>{series.name}</b><br>',
			                pointFormat: '{point.x} cm, {point.y} kg'
			            }
			        }
			    },
			    series: [{
			        name: 'Male',
			        color: 'rgba(119, 152, 191, .5)',
			        data: [[31.28, 2.0], [34.49, 1.0], [34.65, 1.0], [35.71, 1.0], [38.37, 1.0]]
			    }]
			});	
		}

	

		</script>
    </body>
</html>