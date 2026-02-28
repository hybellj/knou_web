<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt"    		uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"     		uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="form"   		uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" 		uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="validator" 	uri="http://www.springmodules.org/tags/commons-validator" %>
<%@ taglib prefix="ui"     		uri="http://egovframework.gov/ctl/ui" %>

<!DOCTYPE html>
<html lang="ko">
<head>
	<script type="text/javascript" src="/webdoc/js/jquery.min.js"></script>
	<jsp:include page="/WEB-INF/jsp/common/common.jsp" />
	<meta charset="UTF-8">
	<meta name="title" content="">
	<meta http-equiv="pragma" content="no-cache" />
	<meta http-equiv="Cache-Control" content="No-Cache" />
	<meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi" />
	<title>sampleMain</title>

	<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
	<script type="text/javascript">
		$(function(){
		});
		
		goTmpLogin = function(orgId, deptCd, userId, userType){
			var _data = {
					orgId : orgId
			      , deptCd : deptCd
			      , userId : userId
			      , userType : userType
			}
			
			ajaxCall("/tmpLoginUserInfo.do", _data, function(data){
				var rData = data.returnVO;
			  	if(rData != null){
			  		// console.log(JSON.stringify(rData));
			  		alert(rData.userNm + "님으로 로그인합니다.");
			  		
			  		if("LEARNER" === rData.userType) {
			  			//location.href = "/dashboard/stuDashboard.do";
			  		} else {
			  			//location.href = "/dashboard/tcrDashboard.do";
			  		}
			  		
			  		/*
			  		var userData = {	}
			  		ajaxCall("/tmpSetLoginUserInfo.do", {userData : userData}, function(data){
						console.log("session succ");
				    }, function(xhr, status, error){
				    	console.log("session fail");
				    });
			  		*/

		  	    } else {
		  	    	/* "유저정보가 맞지 않습니다." */
		  	    	alert('<spring:message code="user.messgae.userinfo.no.match" />');
		  	    	return;
		  	    }
		    }, function(xhr, status, error){});
		}
	</script>
</head>
<body>
	<div class="ui-wrap">
		<%--
		<header class="header">
			<jsp:include page="/WEB-INF/jsp/common/frontGnb.jsp" />
		</header>
		--%>

		<div class="container">
			<%--
			<div class="lnb">
				<jsp:include page="/WEB-INF/jsp/common/frontLnb.jsp" />
			</div>
			--%>

			<div class="contents">
				<div class="sixteen wide column">
                    <div class="layout2">
                        <div class="row">
                            <!-- list table형 -->
                            <table class="table c_table" id="dataTable" data-sorting="true" data-paging="false" data-empty="<spring:message code="common.nodata.msg" />">
                                <thead>
                                    <tr>
                                        <th scope="col" data-breakpoints="xs sm md">orgId</th>
                                        <th scope="col" data-breakpoints="xs sm md">orgNm</th>
                                        <th scope="col" data-breakpoints="xs sm md">deptCd</th>
                                        <th scope="col" data-breakpoints="xs sm md">deptNm</th>
                                        <th scope="col" data-breakpoints="xs sm md">userId</th>
                                        <th scope="col" data-breakpoints="xs sm md">userId</th>
                                        <th scope="col" data-breakpoints="xs sm md">userType</th>
                                        <th scope="col" data-breakpoints="xs sm md">userTypeNm</th>
                                        <th scope="col" data-breakpoints="xs sm md">userName</th>
                                        <th scope="col" data-breakpoints="xs sm md">admType</th>
                                        <th scope="col" data-breakpoints="xs sm md">mngType</th>
                                    </tr>
                                </thead>
                                <tbody>
                                	<c:forEach var="data" items="${list}">
                                		<tr>
	                                        <td>${data.orgId}</td>
	                                        <td>${data.orgNm}</td>
	                                        <td>${data.deptCd}</td>
	                                        <td>${data.deptNm}</td>
	                                        <td>${data.userId}</td>
	                                        <td>${data.userId}</td>
	                                        <td>${data.userType}</td>
	                                        <td>${data.userTypeNm}</td>
	                                        <td><a href="javascript:goTmpLogin('${data.orgId}', '${data.deptCd}', '${data.userId}', '${data.userType}')">${data.userNm}</a></td>
	                                        <td>${data.admType}</td>
	                                        <td>${data.mngType}</td>
                                		</tr>
                                	</c:forEach>
                                </tbody>
                            </table>
                            <!-- //list table형 -->
                        </div>
                    </div>   
                </div>
			</div>				
		</div>
		<%--
		<footer class="footer">
			<jsp:include page="/WEB-INF/jsp/common/frontFooter.jsp" />
		</footer>
		--%>
	</div>
</body>
</html>