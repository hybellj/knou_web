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
			document.querySelectorAll('.quiz_paper_list li').forEach(function(li) {
			    li.addEventListener('click', function() {
			        let seqno = this.querySelector('span').textContent.trim();

			        // 해당 question_area 찾아서 표시 후 스크롤
			        var target = document.querySelector('.question_area[data-qstnseqno="' + seqno + '"]');

			        if (target) {
			            target.scrollIntoView({ behavior: 'smooth', block: 'start' });
			        }
			    });
			});
		});
	</script>
</head>
<body class="modal-body">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<div class="quiz_paper_wrap">
		<div class="quiz_paper_list">
	        <ol>
	        	<c:forEach var="item" items="${qstnList }" varStatus="varStatus">
		            <li><span>${varStatus.count }</span></li>
				</c:forEach>
	        </ol>
	    </div>

		<%@ include file="/WEB-INF/jsp/quiz/common/quiz_preview_inc.jsp" %>

		<div class="modal_btns">
			<button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="common.button.close" /></button><!-- 닫기 -->
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>
