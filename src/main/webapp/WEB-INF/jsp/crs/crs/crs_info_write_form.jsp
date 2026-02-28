<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/common/editor_inc.jsp" %>

<script type="text/javascript">
$(document).ready(function(){
	crsInfo("${crsVo.crsCd}");
});

<%-- 1. 등록 페이지 조회 --%>
function crsInfo(crsCd) {
	$("#listInfo").load("/crs/crsMgr/crsWrite.do", 
		{
			"crsCd"  : crsCd
		}
		,function (){
	});
}

<%-- 2. 과목 등록 / 수정 --%>
function add(){

	var _content = editor.getPublishingHtml();
	
	// alert($("#crsTypeCd").val());

	<%-- 과목명 체크 --%>
	var crsNm = $("#crsNm").val();
	if(crsNm == "") {
		/* 과목명을 입력바랍니다. */
		alert('<spring:message code="crs.confirm.insert.lecture.name" />');
		return;
	}
	
	<%--교육방법 체크 --%>
	var crsOperTypeCd = $("#crsOperTypeCdVal").val();
	if(crsOperTypeCd == "") {
		/* 강의형태를 선택해 주세요. */
		alert('<spring:message code="crs.alert.select.course.ctgr" />');
		return;
	}
	$("#crsOperTypeCd").val(crsOperTypeCd);

	<%-- 비교과 일때만 체크 --%>
	if($("#crsTypeCd").val() == "CO") {
		 var nopLimitYn = $('input[name="nopLimitYn"]:checked').val();
		 if(nopLimitYn == "Y"){
				if($("#eduNop").val() == '') {
					/* 교육인원을 입력하세요. */
					alert("<spring:message code='crs.confirm.insert.learner.count'/>");
					return false;
				}
			}
		<%-- if(!ratioCheck()) return; --%>
		if(!selectCheck()) return;

		<%--수료점수--%>
		if($("#cpltScore").val() == '' || $("#cpltScore").val() == null) {
			/* 수료 점수를 입력해주시기 바랍니다. */
			alert("<spring:message code='crs.alert.input.cplt.score'/>");
			return;
		} else if(parseInt($("#cpltScore").val(),10) > 100) {
			/* 수료 점수는 100점을 넘길 수 없습니다. */
			alert("<spring:message code='crs.confirm.complete.score.do.not.over.hundred'/>");
			return;
		}
	}

	var queryString = $("form[name=crsForm]").serialize();
	$.ajax({
		type : "POST", 
		url : "/crs/crsMgr/crsAdd.do",
		data:queryString, 
		dataType: "json",
		success : function(data){
			if(data.result > 0) {
				/* "과목 등록하였습니다." */
				alert('<spring:message code="crs.pop.lecture.regist.success" />');
				crsInfo(data.returnVO.crsCd);
				
			} else {
				/* "과목 등록 실패하였습니다." */
				alert('<spring:message code="crs.pop.lecture.regist.fail" />');
				return;
			}
		},
		error : function(request, status, error) {
			/* "요청에 대해 정상적인 응답을 받지 못하였습니다. 관리자에게 문의 하십시오." */
			alert('<spring:message code="errors.json" />');
			return;
		}
	});
}

function selectCheck() {
	<c:if test="${gubun eq 'A'}">
	var crsOperMthd = $("#crsOperMthd option:selected").val();
	</c:if>
	var enrlCertMthd = $("#enrlCertMthd option:selected").val();

	<c:if test="${gubun eq 'A'}">
		if(crsOperMthd == '99') {
			/* 강의형태를 선택해 주세요. */
			alert('<spring:message code="crs.alert.select.course.ctgr" />');
			return false;
		}
	</c:if>
	if(enrlCertMthd == '99') {
		/* 수강인증 방법을 선택하세요. */
		alert('<spring:message code="crs.confirm.select.lecture.certification" />');
		return false;
	}
	return true;
}

function changeCrsNm() {
	$("#chkDup").val("N");
}

function chkChange() {
	if($("#crsNmOrigin").val() != $("#crsNm").val()){
		$("#chkDup").val("N");
	}
}
</script>

<body>

<div id="wrap" class="pusher">

    <!-- class_top 인클루드  -->
    <!-- header -->
    <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
    <!-- //header -->

    <!-- lnb -->
    <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>
    <!-- //lnb -->

    <div id="container">

        <!-- 본문 content 부분 -->
		<div class="content">

		    <!-- admin_location -->
           	<%-- <%@ include file="/WEB-INF/jsp/common/admin/admin_location.jsp" %> --%>
           	<!-- //admin_location -->
           
			<div id="info-item-box">
				<h2 class="page-title"><spring:message code="button.write.subject"/></h2> <%-- 과목 등록 --%>
				<div class="button-area">
					<a href="#0" class="btn btn-primary" onclick="add();"><spring:message code="button.add"/></a> <%-- 저장 --%> 
					<a href="/crs/crsMgr/Form/crsListForm.do" class="btn btn-negative"><spring:message code="button.list"/></a> <%-- 목록 --%>
				</div>
			</div>

			<div class="ui form">
				<div id="listInfo"></div>
			</div>
		</div>
    </div>
    <!-- //본문 content 부분 -->
    <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
</div>
</body>		
</html>