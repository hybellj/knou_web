<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/admin/admin-default.css" />
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/admin/reset.css" />
    </head>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<script type="text/javascript">
		$(document).ready(function() {
			crsCreList("load");
		});
		
		// 과목 목록
		function crsCreList(type) {
			var url  = "/std/stdMgr/listStudentCreCrs.do";
			var data = {
				  creYear	: $("#creYear").val()
				, creTerm	: $("#creTerm").val()
				, userId	: "${vo.userId}"
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		var returnList = data.returnList || [];
	        		var html = "<option value='ALL'>과목</option>";
	        		
	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
	        				var isSelected = type == "load" && v.crsCreCd == "${vo.crsCreCd}" ? "selected" : i == 0 ? "selected" : "";
	        				html += "<option value=\""+v.crsCreCd+"\" "+isSelected+">"+v.crsCreNm+" ("+v.declsNo+")</option>";
	        			});
	        		}
	        		
	        		$("#crsCreCd").empty().html(html);
	        		$("#crsCreCd").dropdown();
		        	setTimeout(function() {
		        		$("#crsCreCd").trigger("change");
		        	},100);
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
			});
		}
		
		// 주차 목록
		function scheduleList() {
			var url  = "/lesson/lessonHome/listLessonSchedule.do";
			var data = {
				  crsCreCd	: $("#crsCreCd").val() == "ALL" ? "" : $("#crsCreCd").val()
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		var returnList = data.returnList || [];
	        		var html = "<option value='ALL' selected><spring:message code='lesson.button.all.lesson.schedule' /></option>";/* 전체 주차 */
	        		
	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
	        				html += "<option value=\""+v.lessonScheduleId+"\">"+v.lessonScheduleNm+"</option>";
	        			});
	        		}
	        		
	        		$("#lessonScheduleId").empty().html(html);
	        		$("#lessonScheduleId").dropdown();
					$("#lessonScheduleId").trigger("change");
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
			});
		}
		
		// 학습기록 목록
		function stdScheduleList() {
			var url  = "/lesson/lessonHome/listStdLessonRecord.do";
			var data = {
				  crsCreCd			: $("#crsCreCd").val() == "ALL" ? "" : $("#crsCreCd").val()
				, userId 			: "${stdVO.userId}"
				, lessonScheduleId 	: $("#lessonScheduleId").val()
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		var returnList = data.returnList || [];
	        		var html = "";
	        		
	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
	        				var regDttm = v.regDttm.substring(0,4) + "." + v.regDttm.substring(4,6) + "." + v.regDttm.substring(6,8) + " " + v.regDttm.substring(8,10) + ":" + v.regDttm.substring(10,12) + ":" + v.regDttm.substring(12,14);
	        				var studyTm = Math.floor(v.studyTm / 60) + ":" + lpad((v.studyTm % 60), 2, "0");
	        				html += "<tr>";
	        				html += "	<td> " + (returnList.length - i) + "</td>";
	        				html += "	<td>"+ regDttm + "</td>";
	        				//html += "	<td>" + v.crsCreNm + " (" + v.declsNo + ")</td>";
	        				//html += "	<td>" + v.lessonScheduleOrder + "</td>";
	        				//html += "	<td>" + v.lessonTimeOrder + "</td>";
	        				//html += "	<td>" + v.lessonCntsNm + "</td>";
	        				html += "	<td>[" + v.studyCnt + "] " + studyTm + "</td>";
	        				html += "	<td>" + v.studyDeviceCd + "</td>";
	        				html += "	<td>" + v.studyBrowserCd + "</td>";
	        				html += "	<td>" + v.regIp + "</td>";
	        				html += "</tr>";
	        			});
	        		}
	        		
	        		$("#scheduleTbody").empty().html(html);
	        		$("#scheduleTable").footable();
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
			}, true);
		}
		
		// 왼쪽 자릿수 채우기
		function lpad(str, padLength, padStr) {
			str += "";
			padStr += "";
			while(str.length < padLength) {
				str = padStr + str;
			}
			str = str.length >= padLength ? str.substring(0, padLength) : str;
			return str;
		}
	</script>

	<body class="modal-page <%-- <%=SessionInfo.getThemeMode(request)%> --%>">
        <div id="wrap">
        	<div class="option-content">
        		<select class="ui dropdown mr5" id="creYear" onchange="crsCreList('search')">
        			<c:forEach var="item" items="${yearList }">
        				<option value="${item }" ${item eq vo.creYear ? 'selected' : '' }>${item }</option>
        			</c:forEach>
        		</select>
        		<select class="ui dropdown mr5" id="creTerm" onchange="crsCreList('search')">
        			<c:forEach var="item" items="${termList }">
        				<option value="${item.codeCd }" ${item.codeCd eq vo.creTerm ? 'selected' : '' }>${item.codeNm }</option>
       				</c:forEach>
        		</select>
        		<select class="ui dropdown mr5" id="crsCreCd" onchange="scheduleList()">
        		</select>
        		<select class="ui dropdown mr5" id="lessonScheduleId" onchange="stdScheduleList()">
        			<option value="ALL"><spring:message code="lesson.button.all.lesson.schedule" /><!-- 전체 주차 --></option>
        		</select>
        	</div>
        	<div class="option-content mt20 mb20">
        		<h3><spring:message code="lesson.label.study.history" /><!-- 학습기록 --> | </h3>
        		<span class="fcBlue f110">${stdVO.deptNm } / ${stdVO.userId } / ${stdVO.userNm }</span>
        	</div>
        	<table class="table type2" data-sorting="false" data-paging="false" data-empty="<spring:message code='user.common.empty' />" id="scheduleTable"><!-- 등록된 내용이 없습니다. -->
        		<thead>
        			<tr>
        				<th class="scope">No</th>
        				<th class="scope"><spring:message code="lesson.label.study.reg.date" /><!-- 학습기록시간 --></th>
        				<%-- <th class="scope"><spring:message code="lesson.label.crscrenm" /><!-- 과목 --></th>
        				<th class="scope"><spring:message code="lesson.label.schedule" /><!-- 주차 --></th>
        				<th class="scope"><spring:message code="lesson.label.time" /><!-- 교시 --></th>
        				<th class="scope"><spring:message code="lesson.label.video.lesson.time.nm" /><!-- 동영상명(교시명) --></th> --%>
        				<th class="scope"><spring:message code="lesson.label.study.time" /><!-- 학습시간 --></th>
        				<th class="scope">Device</th>
        				<th class="scope"><spring:message code="lesson.label.type" /><!-- 구분 --></th>
        				<th class="scope">IP</th>
        			</tr>
        		</thead>
        		<tbody id="scheduleTbody"></tbody>
        	</table>

            <div class="bottom-content mt50">
                <button class="ui basic button" onclick="window.parent.closeModal()"><spring:message code="user.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
