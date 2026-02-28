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

<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="wrap">
<style>
  #star a{
   text-decoration: none;
   color: gray;
  }
  #star a.on{
   color: orange;
  } 
</style>
<script>
$(document).ready(function () {
	$('#star a').click(function(){
		 $(this).parent().children("a").removeClass("on");    
		 $(this).addClass("on").prevAll("a").addClass("on");
		 $("#score").val($(this).attr("value"));
	});
});

// 상호평가 저장
function saveEvalStar() {
	var score = $("#score").val();
	
	if(score == "0") {
		alert("<spring:message code='forum.alert.star.none'/>"); // 별점은 1개이상 선택되어야 합니다
		return false;
	}

	var url  = "/forum/forumHome/forumMutInsert.do";
	var data = {
		"mutSn" : "${vo.mutSn}",
		"forumCd"  	: "${vo.forumCd}",
		"stdNo" 	: "${vo.stdNo}",
		"score"	: $("#score").val(),
		"cmnt" : $("#cmnt").val()
	};
	
	ajaxCall(url, data, function(data) {
		if (data.result > 0) {
			if("${vo.mutSn}" != "") {
				alert("<spring:message code='forum.alert.mut.update' />"); // 상호평가 정상적으로 수정되었습니다.
			} else {
				alert("<spring:message code='forum.alert.mut.insert' />"); // 상호평가 정상적으로 저장되었습니다.
			}
    		window.parent.listForumUser(1);
    		window.parent.closeModal();
        } else {
         	alert(data.message);
        }
	}, function(xhr, status, error) {
		alert("<spring:message code='forum.alert.mut.error' />"); // 상호평가 처리 중 에러가 발생하였습니다.
	}, true);
}
</script>

<input type="hidden" name="score" id="score" value="${vo.score}" />
<c:forEach var="item" items="${atclUserList}" varStatus="status">
<div class="ui card wmax">
	<div class="content card-item-center">
			<div class="flex fac">
				<span class="label circle mr10"><img src="/webdoc/img/no_user.gif" alt="<spring:message code="forum.common.user.img" />"><!-- 학습자이미지 --></span>
				<span class="label mr10">${item.regNm}(${item.rgtrId})</span>
				<span class="label mr10 fcBlue">${item.ctsLen}<spring:message code="forum.label.word" /></span><!-- 자 -->
				<fmt:parseDate var="regDttm" pattern="yyyyMMddHHmmss" value="${item.regDttm }" />
				<fmt:formatDate var="regDttm" pattern="yyyy.MM.dd(HH:mm)" value="${regDttm }" />
				<span class="label mr10"><spring:message code="forum.label.reg.dttm" /> : ${regDttm}</span><!-- 작성일시 -->
				<span class="label mr10"><spring:message code="forum.label.attachFile" /> : -</span><!-- 첨부파일 -->
			</div>
		</div>
		<div class="ui segment ml25 mr25 mt10 mb10">
			<pre>${item.cts}</pre>
		</div>	
	</div>
</div>
</c:forEach>
	<ul class="tbl-simple st2 mt10">
		<li>
			<dl>
				<dt><label for="subjectLabel" class="req"><spring:message code="forum.label.mutEval.star"/></label></dt><!-- 별점 평가 -->
				<dd>
					<div class="ui fluid input">
						<div id="star">
							<c:forEach var="i" begin="1" end="5">
								<c:choose>
									<c:when test="${ vo.score ge i }">
										<a href="#" value="${i}" class="on"><i class="star icon"></i></a>
									</c:when>
									<c:otherwise>
										<a href="#" value="${i}"><i class="star icon"></i></a>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</div>
					</div>
				</dd>
			</dl>
		</li>
		<li>
			<dl class="row">
				<dt><label for="contentTextArea"><spring:message code="forum.label.eval.cmnt" /></label></dt><!-- 평가 의견 -->
				<dd>
					<div style="height:100px">
						<textarea rows="5" cols="50" name="cmnt" id="cmnt">${vo.cmnt}</textarea>
					</div>
				</dd>
			</dl>
		</li>
	</ul>
	
	<div class="bottom-content mt70">
		<button class="ui blue button" onclick="saveEvalStar()"><spring:message code="forum.button.save" /></button><!-- 저장 -->
		<button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="forum.button.close" /></button><!-- 닫기 -->
	</div>
</div>
<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>
