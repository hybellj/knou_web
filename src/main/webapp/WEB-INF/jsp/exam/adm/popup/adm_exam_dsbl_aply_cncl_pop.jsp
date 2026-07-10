<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
	<head>
    	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
			<jsp:param name="style" value="classroom"/>
			<jsp:param name="module" value="table"/>
		</jsp:include>
    </head>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<script type="text/javascript">
        var examSprtAplyGrpId   = '<c:out value="${vo.examSprtAplyGrpId}" />';

        /* 취소 승인,반려 기능 */
        function sprtCnclAply(isAccept, isAply) {
            var url = "/exam/admModifySprtAplyCnclStat.do";
            var cnclAplyStscd = isAccept === "Y" ? "CNCL_APRV" : "CNCL_RJCT";
            var data = {
                "cnclAplyStscd"     : cnclAplyStscd,
                "examSprtAplyGrpId" : examSprtAplyGrpId
            };
            function executeAjax() {
                UiComm.showLoading(true);
                $.ajax({
                    url:            url,
                    async:          false,
                    type:           "POST",
                    dataType:       "json",
                    data:           data,
                }).done(function(data) {
                    UiComm.showLoading(false);
                    if (data.result > 0) {
                        UiComm.showMessage("<spring:message code='exam.alert.insert' />", "info")   /* 정상 저장 되었습니다. */
                            .then(function() {
                                window.parent.loadSprtAplyInfoList(1);
                                window.parent.closeDialog();
                            });
                    } else {
                        UiComm.showMessage(data.message, "error");
                    }
                }).fail(function() {
                    UiComm.showLoading(false);
                    UiComm.showMessage("<spring:message code='exam.error.insert' />", "error"); /* 저장 중 에러가 발생하였습니다. */
                });
            }
            if (isAccept === "Y") {
                UiComm.showMessage("<spring:message code='exam.confirm.approve' />", "confirm") /* 요청 승인 하시겠습니까? */
                    .then(function(result){
                        executeAjax();
                });
            } else {
                UiComm.showMessage("<spring:message code='exam.confirm.companion' />?", "confirm")  /* 요청 반려 하시겠습니까? */
                    .then(function(result){
                        executeAjax();
                });
            }
        }

		$(document).ready(function() {
		});
	</script>

	<body class="modal-page">
        <div id="wrap">
            <div class="board_top margin-top-4">
                <div class="center">
                    <a><spring:message code='exam.alert.msg.sprt.cncl.aply1' /></a><!-- 장애인/고령자 시험지원 취소요청을 승인하시겠습니까? -->
                </div>
            </div>
			<div class="btns">
                <a href="javascript:sprtCnclAply('Y')" class="btn type1 small"><spring:message code='exam.label.approve' /></a><!-- 승인 -->
                <a href="javascript:sprtCnclAply('N')" class="btn type2 small"><spring:message code='exam.label.companion' /></a><!-- 반려 -->
			</div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js></script>
    </body>