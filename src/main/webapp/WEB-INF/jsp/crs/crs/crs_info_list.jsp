<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <script type="text/javascript" src="/webdoc/js/common_admin.js"></script>
</head>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
function crsInfo(){
 	$("#listInfo").load("/crs/crsMgr/crsWrite.do", 
	{
	}
	,function (){
	});
}
 
function togleUseYn(obj_id) {
	var useYn = "Y";
	if($("#"+obj_id+"").is(":checked")) {
 		useYn = "N"; 
 	} 
	var crsCd = obj_id.substr(obj_id.indexOf('_')+1);
	$.getJSON("/crs/crsMgr/editUseYn.do",
	{
		"crsCd" : crsCd
	   	, "useYn" : useYn
	},
	function(data) {
		if(data.result > 0) {
			$("#note-box").removeClass("warning");
			
			if(useYn == "N"){
				// 사용 여부 설정을 미사용으로 설정 하였습니다.
				alert('<spring:message code="crs.no.use.type.setting.undisclosed" />');
			} else if(useYn == "Y"){
				// 사용 여부 설정을 사용으로 설정 하였습니다.
				alert('<spring:message code="crs.no.use.type.setting.disclosed" />');
			}
		} else{
			$("#note-box").prop("class","warning");
			if(data.message != null && data.message != "") {
				alert(data.message);
			} else {
				// 사용 여부 설정 변경에 실패하였습니다.
				alert('<spring:message code="crs.use.type.setting.fail" />');
			}
		}
	});
}

<%--과정 관리 폼 --%>
function edit(crsCd) {
	$("#crsListForm").attr("action","/crs/crsMgr/Form/crsWriteForm.do");
   	$("#crsCd").val(crsCd);
   	$("#crsListForm").submit();
}

<%-- 과목 삭제 Confirm --%>
function removeCrsConfirm(crsCd, creCrsCnt, crsNm) {
	<%--하위 데이터 체크--%>
	if(creCrsCnt > 0) {
		// 개설된 과정이 있습니다. 과목을 삭제 할 수 없습니다.
		alert('<spring:message code="crs.lecture.already.open.delete.fail" />');
		return;
	} else{
		
		<%-- 과정 삭제 --%>
		// 과목을 삭제하려고 합니다. 삭제 하시겠습니까?
		var confirm = window.confirm("<spring:message code='crs.confirm.delete.lecture' />");
		if(confirm) {
			
			var url  = "/crs/crsMgr/removeCrs.do";
			var data = {
					"crsCd" : crsCd
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					// 과목 삭제 성공하였습니다.
					alert("<spring:message code='crs.alert.lecture.delete.success' />");
					listSeminar();
	            } else {
	            	// 과목 삭제 실패하였습니다.
	             	alert("<spring:message code='crs.alert.lecture.delete.fail' />");
	            }
			}, function(xhr, status, error) {
				// 요청에 대해 정상적인 응답을 받지 못하였습니다. 관리자에게 문의 하십시오.
				alert('<spring:message code="errors.json" />');
			});
		}
	}
}

/*
function removeCrs(crsCd) {
	$.ajax({
		type : "POST",
		url : "/crs/crsMgr/removeCrs.do",
		data: {crsCd : crsCd},
		dataType: "json",
		success : function(data){
			if(data.result > 0) {
				alert("과목 삭제 하였습니다.");
				crsList();
			} else {
				alert("과목 삭제 실패하였습니다.");
				return;
			}
		},
		error : function(request, status, error) {			
            요청에 대해 정상적인 응답을 받지 못하였습니다. 관리자에게 문의 하십시오.
            alert('<spring:message code="errors.json" />');
			return;
		}
	});	
}
*/

</script>

<form class="ui form" id="crsListForm" name="crsListForm" method="POST" action="">
<input type="hidden" id="crsCd" name="crsCd" >
</form>
<table class="table" data-sorting="true" data-paging="false" data-empty="<spring:message code="common.nodata.msg"/>"> <%-- 등록된 내용이 없습니다. --%>
	<thead>
		<tr>
			<th scope="col" data-type="number" class="num"><spring:message code="common.number.no"/></th> <%-- NO. --%>
			<th scope="col"><spring:message code="crs.label.crs.category"/></th> <%-- 과목분류 --%>
			<th scope="col"><spring:message code="crs.title.education.method"/></th> <%-- 강의 형태 --%>
			<th scope="col"><spring:message code="crs.crsnm"/></th> <%-- 과목명 --%>
			<th scope="col" data-breakpoints="xs"><spring:message code="contents.label.crscd" /></th> <%-- 학수번호 --%>
			<th scope="col" data-breakpoints="xs"><spring:message code="crs.course.cnt"/></th> <%-- 개설과목 수 --%>
			<th scope="col" data-sortable="false" data-breakpoints="xs"><spring:message code="common.label.use.type.yn"/></th> <%-- 사용 여부 --%>
			<th scope="col" data-sortable="false" data-breakpoints="xs sm"><spring:message code="common.mgr"/></th> <%-- 관리 --%>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="item"  items="${crsList}"  varStatus="status">
		<tr>
			<td><c:out value="${item.lineNo}"/></td>
			<%-- <td><c:out value="${pageInfo.rowNum(status.index)}"/></td> --%>
			<td><c:out value="${item.crsTypeNm}"/></td>
			<td><c:out value="${item.crsOperTypeNm}"/></td>
			<td><c:out value="${item.crsNm}"/></td>
			<td><c:out value="${item.crsCd}"/></td>
			<td><c:out value="${item.creCrsCnt}"/></td>
			<td>
				<div class="ui toggle checkbox" onclick="togleUseYn('useYn_${item.crsCd}');">
					<input type="checkbox" id="useYn_${item.crsCd}" <c:if test="${item.useYn eq 'Y'}">checked</c:if>>
				</div>
			</td>
			<td>
				<div class="manage_buttons">
					<a href="#0" class="ui basic small button" onclick="edit('${item.crsCd}');"><spring:message code='button.edit'/></a> <%-- 수정 --%> 
					<a href="#0" class="ui basic small button" onclick="removeCrsConfirm('${item.crsCd}','${item.creCrsCnt}','${item.crsNm}');"><spring:message code='button.delete'/></a> <%-- 삭제 --%>
				</div>
			</td>
		</tr>
		</c:forEach>
	</tbody>
</table>
<tagutil:paging pageInfo="${pageInfo}" funcName="crsList"/> 
</html>