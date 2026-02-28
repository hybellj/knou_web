<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
    	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
    	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	    <script type="text/javascript" src="/webdoc/js/iframe.js"></script>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    </head>
    <script type="text/javascript">
	    $(document).ready(function() {
	    });
	    
	    // 엑셀 다운로드
	    function excelDown() {
	    	var excelGrid = {
		        colModel:[
		            {label:'<spring:message code="common.number.no" />',		name:'lineNo',      align:'center',	width:'1500'},	
		            {label:"<spring:message code='crs.label.belong.dept' />",				name:'deptNm',   	align:'left',   width:'8000'},/* 소속학과 */
		            {label:"<spring:message code='common.label.userdept.grade' />",			name:'hy',   	   	align:'center', width:'1500'},/* 학년 */
		            {label:"<spring:message code='common.label.student.number' />", 		name:'userId',      align:'right',  width:'5000'},/* 학번 */
		            {label:"<spring:message code='user.title.userinfo.manage.user.nm' />",	name:'userNm',      align:'left',   width:'5000'},/* 성명 */
		            {label:"<spring:message code='user.title.userinfo.user.stats' />", 		name:'schregGbn',   align:'left',   width:'3000'},/* 학적상태 */
		            {label:"<spring:message code='common.label.exchange' /><spring:message code='common.label.total.point' />",	name:'exchTotScr',  align:'left',   width:'1500'},/* 환산점수 */
		            {label:"<spring:message code='common.label.grade' />",					name:'scoreGrade',  align:'left',   width:'1500'},/* 등급 */
		            {label:"<spring:message code='score.label.ranking' />", 				name:'ranking',		align:'left',   width:'1500'},/* 순위 */
		        ]
		    };
		    
		    $("form[name='excelForm']").remove();
		    var excelForm = $('<form></form>');
		    excelForm.attr("name","excelForm");
		    excelForm.attr("method", "POST");
		    excelForm.attr("action","/grade/gradeMgr/gradeStdStatusExcelDown.do");
		    excelForm.append($('<input/>', {type: 'hidden', name: 'crsCreCd', 		value: "${creCrsVO.crsCreCd}"}));
		    excelForm.append($('<input/>', {type: 'hidden', name: 'excelGrid', 		value:JSON.stringify(excelGrid)}));
		    excelForm.appendTo('body');
		    excelForm.submit();
	    }
	    
	    // 항목별 점수
	    function stdDetailScore(stdNo, crsCreCd) {
	    	var dataMap = {
	    		crsCreCd : crsCreCd,
	    		stdNo 	 : stdNo,
	    		action 	 : "/grade/gradeMgr/gradeDetailPopup.do",
	    		form 	 : "gradeStatusForm",
	    		type	 : "detail"
	    	};
	    	window.parent.postMessage(dataMap, "*");
	    }
	    
	    // 닫기
	    function closePop() {
	    	var dataMap = {
	    		type : "close"
		    };
		    window.parent.postMessage(dataMap, "*");
	    }
    </script>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<body class="modal-page">
        <div id="wrap">
        	<h3 class="sec_head"><spring:message code="crs.button.termlink.course" /><!-- 과목 정보 --></h3>
        	<table class="tBasic">
        		<tbody>
        			<tr>
        				<th><spring:message code="common.phy.dept_name" /><!-- 관장학과 --></th>
        				<td>${creCrsVO.mngtDeptNm }</td>
        				<th><spring:message code="crs.label.crecrs.nm" /><!-- 과목명 --></th>
        				<td>${creCrsVO.crsCreNm }</td>
        				<th><spring:message code="crs.label.crs.cd" /><!-- 학수번호 --></th>
        				<td>${creCrsVO.crsCd }</td>
        			</tr>
        			<tr>
        				<th><spring:message code="crs.label.decls" /><!-- 분반 --></th>
        				<td>${creCrsVO.declsNo }</td>
        				<th><spring:message code="crs.label.rep.professor" /><!-- 담당교수 --></th>
        				<td>${creCrsVO.tchNm }</td>
        				<th><spring:message code="crs.label.rep.professor.no" /><!-- 담당교수 사번 --></th>
        				<td>${creCrsVO.tchNo }</td>
        			</tr>
        			<tr>
        				<th><spring:message code="common.label.crsauth.comtype" /><!-- 이수구분 --></th>
        				<td>${creCrsVO.compDvNm }</td>
        				<th><spring:message code="common.label.credit" /><!-- 학점 --></th>
        				<td>${creCrsVO.credit }</td>
        				<th><spring:message code="crs.attend.person.nm" /><!-- 수강인원 --></th>
        				<td>${creCrsVO.stdCnt }</td>
        			</tr>
        		</tbody>
        	</table>
        	<div class="option-content mt20">
        		<h3 class="sec_head"><spring:message code="score.label.std.list.score.status" /><!-- 수강생 목록 및 성적처리 현황 --></h3>
        		<p>[ <spring:message code="message.all" /><!-- 총 --> <span class="fcBlue">${fn:length(stdList) }</span><spring:message code="message.count" /><!-- 건 --> ]</p>
        		<div class="mla">
        			<button type="button" class="ui green button" onclick="excelDown()"><spring:message code="common.button.excel_down" /><!-- 엑셀 다운로드 --></button>
        		</div>
        	</div>
        	<table class="table mt10" data-sorting="false" data-paging="false" data-empty="<spring:message code='common.content.not_found' />"><!-- 등록된 내용이 없습니다. -->
	        	<thead>
	        		<tr>
	        			<th><spring:message code="common.number.no" /><!-- NO --></th>
	        			<th><spring:message code="crs.label.belong.dept" /><!-- 소속학과 --></th>
	        			<th><spring:message code="common.label.userdept.grade" /><!-- 학년 --></th>
	        			<th><spring:message code="common.label.student.number" /><!-- 학번 --></th>
	        			<th><spring:message code="user.title.userinfo.manage.user.nm" /><!-- 성명 --></th>
	        			<th><spring:message code="user.title.userinfo.user.stats" /><!-- 학적상태 --></th>
	        			<th><spring:message code='common.label.exchange' /><spring:message code='common.label.total.point' /><!-- 환산총점 --></th>
	        			<th><spring:message code="common.label.grade" /><!-- 등급 --></th>
	        			<th><spring:message code="score.label.ranking" /><!-- 순위 --></th>
	        			<th><spring:message code="score.label.calculation.date" /><!-- 산출일시 --></th>
	        			<th><spring:message code="score.label.exchange.date" /><!-- 환산일시 --></th>
	        			<th><spring:message code="score.label.each.item.score" /><!-- 항목별 점수 --></th>
	        		</tr>
	        	</thead>
	        	<tbody>
	        		<c:forEach var="item" items="${stdList }">
	        			<tr>
	        				<td>${item.lineNo }</td>
	        				<td>${item.deptNm }</td>
	        				<td>${item.hy }</td>
	        				<td>${item.userId }</td>
	        				<td>${item.userNm }</td>
	        				<td>${item.schregGbn }</td>
	        				<td>${item.exchTotScr }</td>
	        				<td>${item.scoreGrade }</td>
	        				<td>${item.ranking }</td>
	        				<td>-</td>
	        				<td>-</td>
	        				<td><button type="button" class="ui orange small button" onclick="stdDetailScore('${item.stdNo}', '${item.crsCreCd }')"><spring:message code="score.label.each.item.score" /><!-- 항목별 점수 --></button></td>
	        			</tr>
	        		</c:forEach>
	        	</tbody>
	        </table>

            <div class="bottom-content">
                <button type="button" class="ui basic button" onclick="closePop()"><spring:message code="team.common.close"/></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
