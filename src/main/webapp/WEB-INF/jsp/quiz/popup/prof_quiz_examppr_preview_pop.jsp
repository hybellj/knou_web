<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
   	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
	</jsp:include>

	<script type="text/javascript">
		$(document).ready(function() {
			if(${vo.qstnDsplyGbncd eq 'EACH'}) {
				controllNextPrevBtn();
			}
		});

		// 포커스 이동
		function focusMove(id) {
			var locate = parseInt($("#"+id).offset().top + 210);
			$(window.parent.document.getElementsByClassName("ui-dialog")).scrollTop(locate);
		}

		/**
	     *  이전 다음 버튼 표시
	     */
	    function controllNextPrevBtn() {
	        var curQstnSeqno = Number($("div.question-box:visible").attr("data-qstnSeqno"));
	        var qstnCnt   = $("div.question-box").length;

	        $("div.question-box").hide();
            $("div.question-box[data-qstnSeqno=1]").show();
	        $("#btnPrevQstn").hide();
	        $("#btnNextQstn").hide();
	        if (curQstnSeqno > 1) {
	            $("#btnPrevQstn").show();
	        }
	        if (curQstnSeqno < qstnCnt) {
	            $("#btnNextQstn").show();
	        }
	    }

	    /**
	     *  이전 버튼 클릭 시 앞 문제로 이동
	     */
	    function goPrevQstn() {
	        var curQstn   = $("div.question-box:visible");
	        var curQstnNo = Number(curQstn.attr("data-qstnSeqno"));
	        if (curQstnNo > 1) {
	            $("#btnNextQstn").show();
	            $("div.question-box").hide();
	            $("div.question-box[data-qstnSeqno=" + (curQstnNo - 1) + "]").show();
	            if (curQstnNo - 1 == 1) {
	                $("#btnPrevQstn").hide();
	            }
	        }
	    }

	    /**
	     *  다음 버튼 클릭 시 뒤 문제로 이동
	     */
	    function goNextQstn() {
	        var curQstn   = $("div.question-box:visible");
	        var curQstnNo = Number(curQstn.attr("data-qstnSeqno"));

	        var qstnCnt = $("div.question-box").length;
	        if (curQstnNo < qstnCnt) {
	            $("#btnPrevQstn").show();
	            $("div.question-box").hide();
	            $("div.question-box[data-qstnSeqno=" + (curQstnNo + 1) + "]").show();
	            if (curQstnNo + 1 == qstnCnt) {
	                $("#btnNextQstn").hide();
	            }
	        }
	    }

	    /**
		* 퀴즈 팀 선택
		* @param {String}  examDtlId - 선택 팀에 대한 시험상세아이디
		*/
	 	function quizTeamSelect(examDtlId) {
			var data = "examBscId=${vo.examBscId}&examDtlVO.examDtlId="+examDtlId;

			window.parent.$(".ui-dialog:visible iframe").last().attr("src", "/quiz/profQuizExampprPreviewPopup.do?"+data);
	 	}
	</script>
</head>
<body class="modal-page">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<div id="wrap">
		<c:if test="${vo.examGbncd eq 'QUIZ_TEAM' }">
			<div class="top-content btn_area margin-bottom-3">
				<c:forEach var="item" items="${quizTeamList }">
					<button class="btn ${item.examDtlId eq vo.examDtlVO.examDtlId ? 'type1' : 'type2' }" name="teamButton" value="${item.examDtlId }" onclick="quizTeamSelect('${item.examDtlId }')">${item.teamnm }</button>
				</c:forEach>
			</div>
		</c:if>

		<div class="qstnInfo flex-item gap-3 margin-bottom-5">
		    <c:if test="${vo.examQstnsCmptnyn ne 'Y' && vo.examQstnsCmptnyn ne 'M' }">
	    		<div class="msg-box">
	                <p class="txt">
	                	<i class="icon-svg-warning" aria-hidden="true"></i>
	                	<spring:message code="exam.alert.already.qstn.submit.n" /><!-- 문제 출제가 완료되지 않았습니다. -->
	                </p>
	            </div>
		    </c:if>
		    <c:forEach var="item" items="${qstnList }" varStatus="varStatus">
		    	<div class="custom-input padding-3">
		       	<p class="checkmark padding-left-3">${varStatus.count }</p>
		    	</div>
			</c:forEach>
		</div>

		<%@ include file="/WEB-INF/jsp/quiz/common/quiz_preview_inc.jsp" %>

		<div class="btns">
           	<c:if test="${vo.qstnDsplyGbncd eq 'EACH'}">
            	<a href="javascript:goPrevQstn();" class="btn type1" id="btnPrevQstn"><spring:message code="exam.label.prev" /></a><!-- 이전 -->
            	<a href="javascript:goNextQstn();" class="btn type1" id="btnNextQstn"><spring:message code="exam.label.next" /></a><!-- 다음 -->
            </c:if>
			<button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>
