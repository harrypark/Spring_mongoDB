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
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
		
		
		
		<script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
		<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>

		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
<!--     	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous"> -->
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
    		
    		<div class="col-2">
    			<select name="schSkillUuid" id="schSkillUuid">
		    		<option value="c9d7e581-723f-11ea-bc9b-022e2bbe7be0">피자주문</option>
		    	 </select>
    		</div>
    		<div class="col-3">confidence :
				 <select name="schConfidence" id="schConfidence">
		    		<option value="all">All</option>
		    		<option value="020">0~20%</option>
		    		<option value="2040">20~40%</option>
		    		<option value="4060">40~60%</option>
		    		<option value="6080">60~80%</option>
		    		<option value="80100">80~100%</option>
		    	 </select>
    		</div>
    		<div class="col-2">InputType :
				 <select name="schInputType" id="schInputType">
		    		<option value="all">All</option>
		    		 <c:forEach items="${inputType}" var="value">
		    		 	<c:set var="a" value="${fn:substring(value,0,1)}"/>
		    		 	<c:set var="b1" value="${fn:substring(value,1,-1)}"/>
		    		 	<c:set var="b2" value="${fn:toLowerCase(b1)}"/>
				          <option value="${a}${b2}">${a}${b2}</option>
				     </c:forEach>
		    	 </select>
    		</div>
    		<div class="col-3">
    			<input type="hidden" name="schStartDt" id="schStartDt" value=""/>
    			<input type="hidden" name="schEndDt" id="schEndDt" value=""/>
    			<input type="text" name="dateRange" id="dateRange" class="dateRange" value=""/>
    		</div>
    		
    		<div class="col-2">
    			<button type="button" class="btn btn-outline-secondary" id="button-container">search</button>
    		</div>
    	</div>
    	<div class="row border">
    		<div class="col-2">
    		</div>
    		<div class="col-3">
    			Intent : <input type="text" id="schIntent" name="schInt">
    		</div>
    		<div class="col-3">
    			User : <input type="text" id="schUser" name="schUser">
    		</div>
    		
    		<div class="col-4">
    		</div>
    	</div>
    	</form>
    	<div class="row border">
    		<div class="col container" id="usage">
    			<table id="example" class="display" style="width:100%">
			        <thead>
			            <tr>
			                <th>Date</th>
			                <th>Input Type</th>
			                <th>User Input Text</th>
			                <th>Intent</th>
			                <th>Confidence(%)</th>
			                <th>User</th>
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
    var table;
		$(function(){
 			 $('#schStartDt').val(moment().subtract(6, 'days').format('YYYYMMDD'));
 			 $('#schEndDt').val(moment().format('YYYYMMDD'));
 			var columns = ["DATE", "INPUT_TYPE", "INPUT_TEXT", "INTENT","INTENT_CONFIDENCE","USER"];
 			 table = $('#example').dataTable({
                pageLength: 10,
                pagingType : "full_numbers",
                bPaginate: true,
                bLengthChange: true,
                lengthMenu : [ [ 1, 3, 5, 10, -1 ], [ 1, 3, 5, 10, "All" ] ],
                responsive: true,
                //bAutoWidth: false,
                processing: true,
                ordering: false,
                bServerSide: true,
                searching: false,
                rowId:'id',
                ajax : {
                    "url":"/api/conversation/serverSide",
                    "type":"POST",
                    "data": function (d) {
                    	d.schSkillUuid = $('#schSkillUuid').val();
                        d.schStartDt = $('#schStartDt').val();
                        d.schEndDt = $('#schEndDt').val();
                        d.schConfidence = $('#schConfidence').val();
                        d.schInputType = $('#schInputType').val();
                        d.schIntent = $('#schIntent').val();
                        d.schUser = $('#schUser').val();
                        
                    }
                }, 
                //sAjaxSource : "/api/conversation/serverSide?startDt="+$('#startDt').val()+"&endDt="+$('#endDt').val()+"&skillUuid="+$('#skillUuid').val()+"&columns="+columns,
                sServerMethod: "POST",
                columns : [
                    {data: "date"},
                    {data: "inputType"},
                    {data: "inputText"},
                    {data: "intent"},
                    {data: "intentConfidence"},
                    {data: "user"}
                ],
                /*
                columnDefs : [
                    {
                        "targets": [1,2,3,4,5,6],
                        "visible": true,
                    },
                    {
                        "targets": [0],
                        "visible": false,
                    },
                ]
 				*/
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
				//callApiConversationData(); //api 호출
				//table.column(searchType).search(searchValue).draw();
				table.draw();

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
			
			

		});

		
		var callApiConversationData = function(){
			$('#example').dataTable().fnClearTable(); // 테이블 클리어
			$.ajax({
				  url: '<c:url value="/api/conversation/data"/>',
				  data: $("#searchParam").serialize(),
				  success: function( result ) {
					  console.log(result);
						
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

						

					}
				});
		} 

	

		</script>
    </body>
</html>