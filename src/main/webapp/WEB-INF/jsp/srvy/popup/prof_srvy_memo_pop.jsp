<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
	</jsp:include>
    </head>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<script type="text/javascript">
		$(document).ready(function() {
		});

		// 메모 저장
		function profMemoRegist() {
			var url  = "/srvy/srvyProfMemoModifyAjax.do";
			var data = {
				"srvyId" 		: "${vo.srvyId}",
				"srvyPtcpId"  	: "${profMemo.srvyPtcpId}",
				"userId" 		: "${profMemo.userId}",
				"profMemo"		: $("#profMemo").val()
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
	        		window.parent.srvyPtcpListSelect();
	        		window.parent.closeDialog();
		        } else {
		        	alert(data.message);
		        }
		    }).fail(function() {
		    	alert("<spring:message code='exam.error.memo.insert' />");/* 메모 저장 중 에러가 발생하였습니다. */
		    });
		}
	</script>

	<body class="modal-page">
        <div id="wrap">
        	<div class="msg-box basic board_top">
        		<span>${vo.sbjctnm } ${vo.dvclasNo }반</span>
        		<div class="right-area fcBlue">
        			<b>${srvyPtcpnt.deptnm } ${srvyPtcpnt.stdntNo } ${srvyPtcpnt.usernm } <span class="f150">${srvyPtcpnt.ptcpEvlScr }<spring:message code="exam.label.score.point" /></span><!-- 점 --></b>
        		</div>
            </div>

            <textarea class="form-control" id="profMemo" style="width:100%;height:100px" maxLenCheck="byte,4000,true,true">${profMemo.profMemo }</textarea>

			<div class="btns">
                <button class="btn type1" onclick="profMemoRegist()"><spring:message code="exam.button.save" /></button><!-- 저장 -->
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
			</div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
