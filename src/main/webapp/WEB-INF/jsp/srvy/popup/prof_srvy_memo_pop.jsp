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
			const url  = "/srvy/srvyProfMemoModifyAjax.do";
			const data = {
				srvyId 		: "${vo.srvyId}",
				srvyPtcpId  : "${profMemo.srvyPtcpId}",
				userId 		: "${profMemo.userId}",
				profMemo	: $("#profMemo").val()
			};

			$.ajax({
		        url 	  	: url,
		        async	  	: false,
		        type 	  	: "POST",
		        dataType  	: "json",
		        data 	  	: JSON.stringify(data),
		        contentType	: "application/json; charset=UTF-8",
		        beforeSend	: () => UiComm.showLoading(true),
                success		: function (data) {
                    if (data.result > 0) {
                    	UiComm.showMessage("<spring:message code='srvy.alert.insert.memo' />", "success");	/* 메모 저장이 완료되었습니다. */
    	        		window.parent.srvyPtcpListSelect();
    	        		window.parent.closeDialog();
                    } else {
                    	UiComm.showMessage(data.message, "error");
                    }
                },
                error		: () => UiComm.showMessage("<spring:message code='srvy.error.memo.insert' />", "error"),	/* 메모 저장 중 에러가 발생하였습니다. */
                complete	: () => UiComm.showLoading(false)
		    });
		}
	</script>

	<body class="modal-body">
		<div class="board_top class">
            <h3 class="board-title">${vo.sbjctnm } ${vo.dvclasNo }<spring:message code="srvy.label.decls" /><!-- 반 --></h3>
            <div class="right-area">
                <div class="feedback-info">
                    <p class="desc">
                        <span><strong>${srvyPtcpnt.deptnm }</strong></span>
                        <span><strong>${srvyPtcpnt.stdntNo }</strong></span>
                        <span><strong>${srvyPtcpnt.usernm }</strong></span>
                        <span class="score"><strong>${srvyPtcpnt.ptcpEvlScr }<spring:message code="srvy.label.score.point" /><!-- 점 --></strong></span>
                    </p>
                </div>
            </div>
        </div>

        <!--등록-->
        <div class="table-wrap mt10">
            <table class="table-type5 in_table">
                <tbody>
                    <tr>
                        <td>
                            <textarea class="form-control" id="profMemo" style="width:100%;height:100px" maxLenCheck="byte,4000,true,true">${profMemo.profMemo }</textarea>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

		<div class="modal_btns">
            <button class="btn type1" onclick="profMemoRegist()"><spring:message code="srvy.button.save" /></button><!-- 저장 -->
            <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="srvy.button.close" /></button><!-- 닫기 -->
		</div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
