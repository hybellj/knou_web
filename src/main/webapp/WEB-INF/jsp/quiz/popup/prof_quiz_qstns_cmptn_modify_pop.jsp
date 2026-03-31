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

		// 퀴즈 문제 수정
		function updateExamSubmit() {
			var url  = "/quiz/quizQstnsCmptnModifyAjax.do";
			var data = {
				"examBscId"      		: "${vo.examBscId}",
				"examDtlVO.examDtlId"   : "${vo.examDtlVO.examDtlId }",
				"examGbncd"   			: "${vo.examGbncd}",
				"searchGubun" 			: "${vo.searchGubun}",
				"searchKey"   			: "${vo.searchKey}"
			};
			UiComm.showLoading(true);

			$.ajax({
	            url 	 : url,
	            async	 : false,
	            type 	 : "POST",
	            dataType : "json",
	            data 	 : data,
	        }).done(function(data) {
	        	UiComm.showLoading(false);
	        	if (data.result > 0) {
	        		window.parent.location.reload();
	        		window.parent.closeDialog();
	            } else {
	            	UiComm.showMessage(data.message, "error");
	            }
	        }).fail(function() {
	        	UiComm.showLoading(false);
	        	UiComm.showMessage("<spring:message code='exam.error.qstn.submit' />", "error");	/* 문항 출제 중 에러가 발생하였습니다. */
	        });
		}
	</script>

	<body class="modal-page">
        <div id="wrap">
        	<div class="msg-box basic fcBlue">
        		주의사항
                <ul class="list-asterisk">
                    <li>일부 학생이 이미 퀴즈에 참여하였습니다.</li>
                    <li>학생들이 이미 퀴즈를 풀었거나 시작했으므로 편집에 주의하십시오.</li>
                    <li>변경 내용이 많은 경우 이전 버전의 퀴즈를 푼 학생들의 평가를 재검토하는 것이 좋습니다.</li>
                </ul>
            </div>

            <div class="flex-item gap-2">
            	<p><spring:message code="common.update.msg" /></p><!-- 수정하시겠습니까? -->
            	<button class="btn type1" onclick="updateExamSubmit()"><spring:message code="forum.button.modify.do" /></button><!-- 수정하기 -->
                <button class="btn type1" onclick="window.parent.closeDialog();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
