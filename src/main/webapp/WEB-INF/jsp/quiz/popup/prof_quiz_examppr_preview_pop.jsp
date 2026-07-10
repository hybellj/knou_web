<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/quiz/common/quiz_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
   	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
	</jsp:include>

	<script type="text/javascript">
		$(document).ready(function() {
			if(${vo.qstnDsplyGbncd eq 'EACH'}) {
				showQuestion(1);
			}

			document.querySelectorAll('.quiz_paper_list li').forEach(function(li) {
			    li.addEventListener('click', function() {
			        let seqno = this.querySelector('span').textContent.trim();

			        if(${vo.qstnDsplyGbncd eq 'EACH'}) {
				        // 모든 question_area 숨기기
				        document.querySelectorAll('.question_area').forEach(function(el) {
				            el.style.display = 'none';
				        });
				        showQuestion(seqno);
			        }

			        // 해당 question_area 찾아서 표시 후 스크롤
			        var target = document.querySelector('.question_area[data-qstnseqno="' + seqno + '"]');

			        if (target) {
			            target.scrollIntoView({ behavior: 'smooth', block: 'start' });
			        }
			    });
			});
		});

		// 현재문항순번반환
		function getCurSeqno() {
		    return Number($("div.question_area:visible").attr("data-qstnSeqno"));
		}

		// 전체문항수반환
		function getQstnCnt() {
		    return $("div.question_area").length;
		}

		// 해당 순번 문항 표시 및 버튼 제어
		function showQuestion(seqno) {
		    const total = getQstnCnt();

		    $("div.question_area").hide();
		    $("div.question_area[data-qstnSeqno="+seqno+"]").show();

		    $("#btnPrevQstn").toggle(seqno > 1);
		    $("#btnNextQstn").toggle(seqno < total);
		}

		// 이전 문항으로 이동
		function goPrevQstn() {
		    const cur = getCurSeqno();
		    if (cur > 1) showQuestion(cur - 1);
		}

		// 다음 문항으로 이동
		function goNextQstn() {
		    const cur = getCurSeqno();
		    if (cur < getQstnCnt()) showQuestion(cur + 1);
		}

	    /**
		* 퀴즈 팀 선택
		* @param {String}  examDtlId - 선택 팀에 대한 시험상세아이디
		*/
	 	function quizTeamSelect(examDtlId) {
			const data = "examBscId=${vo.examBscId}&examDtlVO.examDtlId="+examDtlId;
			window.parent.$(".ui-dialog:visible iframe").last().attr("src", "/quiz/profQuizExampprPreviewPopup.do?"+data);
	 	}
	</script>
</head>
<body class="modal-body">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<div class="quiz_paper_wrap">
		<c:if test="${vo.examGbncd eq 'QUIZ_TEAM' }">
			<div class="listTab flex align-items-center">
                <ul>
                	<c:forEach var="item" items="${quizTeamList }">
	                    <li class="${item.examDtlId eq vo.examDtlVO.examDtlId ? 'select' : '' }"><a name="teamButton" value="${item.examDtlId }" onclick="quizTeamSelect('${item.examDtlId }')">${item.teamnm }</a></li>
					</c:forEach>
                </ul>
            </div>
		</c:if>

		<div class="quiz_paper_list">
            <ol>
            	<c:forEach var="item" items="${qstnList }" varStatus="varStatus">
	                <li><span>${varStatus.count }</span></li>
				</c:forEach>
            </ol>
        </div>

		<%@ include file="/WEB-INF/jsp/quiz/common/quiz_preview_inc.jsp" %>

		<div class="modal_btns">
           	<c:if test="${vo.qstnDsplyGbncd eq 'EACH'}">
            	<a href="javascript:goPrevQstn();" class="btn type1" id="btnPrevQstn"><spring:message code="quiz.button.prev" /></a><!-- 이전 -->
            	<a href="javascript:goNextQstn();" class="btn type1" id="btnNextQstn"><spring:message code="quiz.button.next" /></a><!-- 다음 -->
            </c:if>
			<button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="common.button.close" /></button><!-- 닫기 -->
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>
