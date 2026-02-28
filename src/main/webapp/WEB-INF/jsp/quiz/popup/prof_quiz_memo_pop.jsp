<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    </head>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<script type="text/javascript">
		$(document).ready(function() {
		});

		// 메모 저장
		function profMemoRegist() {
			var url  = "/quiz/quizProfMemoModifyAjax.do";
			var data = {
				"examDtlId" : "${vo.examDtlVO.examDtlId}",
				"tkexamId"  : "${profMemo.tkexamId}",
				"userId" 	: "${profMemo.userId}",
				"profMemo"	: $("#profMemo").val()
			};

			$.ajax({
		        url 	  : url,
		        async	  : false,
		        type 	  : "POST",
		        dataType  : "json",
		        data 	  : JSON.stringify(data),
		        contentType: "application/json; charset=UTF-8",
		    }).done(function(data) {
		    	if (data.result > 0) {
		    		alert("<spring:message code='exam.alert.insert.memo' />");/* 메모 저장이 완료되었습니다. */
	        		window.parent.quizTkexamListSelect();
	        		window.parent.closeDialog();
		        } else {
		        	alert(data.message);
		        }
		    }).fail(function() {
		    	alert("<spring:message code='exam.error.memo.insert' />");/* 메모 저장 중 에러가 발생하였습니다. */
		    });
		}
	</script>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
        	<div class="ui message info-item-box gap4">
        		${vo.sbjctnm } ${vo.dvclasNo }반
		        <div class="mla fcBlue">
		            <b>${quizExamnee.deptnm } ${quizExamnee.stdntNo } ${quizExamnee.usernm } <span class="f150">${quizExamnee.totScr }<spring:message code="exam.label.score.point" /></span><!-- 점 --></b>
		        </div>
		    </div>
        	<div>
        		<textarea id="profMemo" rows="10" cols="30">${profMemo.profMemo }</textarea>
        	</div>

            <div class="bottom-content mt70">
                <button class="ui blue button" onclick="profMemoRegist()"><spring:message code="exam.button.save" /></button><!-- 저장 -->
                <button class="ui black cancel button" onclick="window.parent.closeDialog();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
