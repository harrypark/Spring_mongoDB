<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en">
    <head></head>
    <body>
    	<h5>Chatbot Data Test</h5>
    	<ul>
    		<li>mongoDB Test 01 ---> <a href="<c:url value='/intent/top10' />">Go</a> (가로bar, Progress, datatable)</li>
    		<li>mongoDB Test 02 ---> <a href="<c:url value='/intent/daily' />">Go</a> (Top10 일별 카운트 line chart)</li>
    		<li>mongoDB Test 03 ---> <a href="<c:url value='/dashboard' />">Go</a> (Usage Daily, Hourly chart)</li>
    		<li>mongoDB Test 04 ---> <a href="<c:url value='/#' />"></a> (Intent modal)</li>
    		<li>mongoDB Test 05 ---> <a href="<c:url value='/confidence' />">Go</a> (confidence )</li>
    		<li>mongoDB Test 06 ---> <a href="<c:url value='/conversation' />">Go</a> (Conversation) Data Table완료</li>
    		<li>mongoDB Test 07 ---> <a href="<c:url value='/conversation/serverSide' />">Go</a> (Conversation Server Side) Excel제외</li>
    	</ul>
    
    </body>
</html>