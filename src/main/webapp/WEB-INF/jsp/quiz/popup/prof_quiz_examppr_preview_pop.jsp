<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
   	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
   	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	<%@ include file="/WEB-INF/jsp/quiz/common/quiz_common_inc.jsp" %>
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />

	<script type="text/javascript">
		$(document).ready(function() {
	    	controllNextPrevBtn();
		});

		// 포커스 이동
		function focusMove(id) {
			var locate = parseInt($("#"+id).offset().top + 210);
			$(window.parent.document.getElementsByClassName("modal fade in")).scrollTop(locate);
		}

		/**
	     *  이전 다음 버튼 표시
	     */
	    function controllNextPrevBtn() {
	        var curQstnNo = Number($("div.question-box:visible").attr("data-qstnSeqno"));
	        var qstnCnt   = $("div.question-box").length;
	        $("#btnPrevQstn").hide();
	        $("#btnNextQstn").hide();
	        if (curQstnNo > 1) {
	            $("#btnPrevQstn").show();
	        }
	        if (curQstnNo < qstnCnt) {
	            $("#btnNextQstn").show();
	        }
	    }

	    /**
	     *  이전 버튼 클릭 시 앞 문제로 이동
	     */
	    function goPrevQstn() {
	    	$("#submitBtn").hide();
	        var curQstn   = $("div.question-box:visible");
	        var curQstnNo = Number(curQstn.attr("data-qstnSeqno"));
	        if (curQstnNo > 1) {
	            $("#btnNextQstn").show();
	            $("div.question-box").hide();
	            $("div.question-box[data-qstnSeqno=" + (curQstnNo - 1) + "]").show();
	            if (curQstnNo - 1 == 1) {
	                $("#btnPrevQstn").hide();
	            }
	            saveTempExamStare(curQstn);
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
	                $("#submitBtn").css("display", "inline-block");
	            }
	            saveTempExamStare(curQstn);
	        }
	    }

	    /**
		* 퀴즈 팀 선택
		* @param {String}  examDtlId - 선택 팀에 대한 시험상세아이디
		*/
	 	function quizTeamSelect(examDtlId) {
			var kvArr = [];
        	kvArr.push({'key' : 'examBscId',   			'val' : "${vo.examBscId}"});
        	kvArr.push({'key' : 'examDtlVO.examDtlId', 	'val' : examDtlId});

        	$("form[name='tempForm']").remove();

    		var form = $("<form></form>");
    		form.attr("method", "POST");
    		form.attr("name", "tempForm");
    		form.attr("action", "/quiz/profQuizExampprPreviewPopup.do");
    		form.attr("target", "quizPopIfm");

    		for(var i=0; i<kvArr.length; i++){
    			form.append($('<input/>', {type: 'hidden', name: kvArr[i].key, value: kvArr[i].val}));
    		}

    		form.appendTo("body");
    		form.submit();
	 	}
	</script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<div id="wrap">
		<c:if test="${vo.examGbncd eq 'QUIZ_TEAM' }">
			<div class="top-content btn_area">
				<c:forEach var="item" items="${quizTeamList }">
					<button class="ui button basic ${item.examDtlId eq vo.examDtlVO.examDtlId ? 'active' : '' }" name="teamButton" value="${item.examDtlId }" onclick="quizTeamSelect('${item.examDtlId }')">${item.teamnm }</button>
				</c:forEach>
			</div>
		</c:if>

		<div class="option-content qstnInfo">
	        <p class="sec_head">${vo.examTtl }</p>
	        <c:if test="${vo.examQstnsCmptnyn ne 'Y' && vo.examQstnsCmptnyn ne 'M' }">
            	<div class="ui small error message">
                    <i class="info circle icon"></i>
                    <spring:message code="exam.alert.already.qstn.submit.n" /><!-- 문제 출제가 완료되지 않았습니다. -->
                </div>
            </c:if>
	        <ul class="num-chk" aria-label="<spring:message code="resh.label.qstn" /><spring:message code="main.sysMenu.auth.menu.link" />">
	        	<c:forEach var="item" items="${qstnList }" varStatus="status">
	        		<c:if test="${item.qstnCnddtSeqno eq '1'}">
	        			<li><a href="javascript:focusMove('qstnDiv_${item.qstnId }')">${item.qstnSeqno }</a></li>
	        		</c:if>
            	</c:forEach>
	        </ul>
		</div>

		<%@ include file="/WEB-INF/jsp/quiz/common/quiz_preview_inc.jsp" %>

		<div class="bottom-content">
           	<c:if test="${vo.qstnDsplyGbncd eq 'EACH'}">
            	<a href="javascript:goPrevQstn();" class="ui button blue" id="btnPrevQstn"><spring:message code="exam.label.prev" /></a><!-- 이전 -->
            	<a href="javascript:goNextQstn();" class="ui button blue" id="btnNextQstn"><spring:message code="exam.label.next" /></a><!-- 다음 -->
            </c:if>
			<button class="ui black cancel button" onclick="window.parent.closeDialog();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>
