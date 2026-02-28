<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!DOCTYPE html>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
<script type="text/javascript">
$(document).ready(function() {
	if("${fdbkSize}" == 0){
		$("#fdbkUi").hide();
		$("#fdbkTitle").hide();
		$("#fdbkDiv").hide();
	}
});

function toggleArticleBlock() {
	if ($(".article").hasClass("show")) {
		$(".article").removeClass("show");
	} else {
		$(".article").addClass("show");
	}
}
</script>
<c:if test="${forumVo.forumCtgrCd eq 'NORMAL' && CLASS_USER_TYPE ne 'CLASS_LEARNER'  && (empty forumVo.searchMenu || forumVo.searchMenu != 'EZG') && forumVo.evalCritUseYn eq 'N'}">
	<div class="inline field">
	    <label class="label-title"><spring:message code="forum.label.record" /></label><a id="scoreText">${forumJoinUserVo.score }<spring:message code='forum.label.point'/></a> <%-- 성적 --%> <%-- 점 --%>
	             	<div class="ui right labeled small input" name="scoreInput" style="display:none;">
	                    <input type="number" min="0" id="${forumJoinUserVo.stdNo }" name="refLabel" class="w60" maxlength="3" value="${forumJoinUserVo.score}" onkeyup="checkValid(this);">
	                    <div class="ui basic label"><spring:message code='forum.label.point'/></div> <%--점  --%>
	                </div>
	</div>
</c:if>
<div class="comment">
	<c:if test="${forumVo.forumCtgrCd eq 'NORMAL' && CLASS_USER_TYPE ne 'CLASS_LEARNER' && forumVo.evalCritUseYn eq 'N'}">
    	<div class="ui divider"></div>
    </c:if>
    <c:if test="${CLASS_USER_TYPE ne 'CLASS_LEARNER'}">
	    <div class="title">
	    <c:if test="${not empty forumVo.searchMenu && forumVo.searchMenu == 'EZG'}"> 
	        <h2><button type="button" class="ui basic black button f080" onClick="toggleArticleBlock()">${fn:length(forumFdbkList)}<spring:message code='forum.label.cnt.feedback'/></button></h2> <%-- 개의 피드백 --%>
	    </c:if>	    
	        <a class="ui basic black button toggle_btn flex-left-auto" onclick="btnAddFdbk()"><spring:message code='forum.button.feedback.write'/></a> <%-- 피드백 작성하기 --%>
	    </div>
	    <div class="toggle_box" id="toggle">
	        <ul class="comment-write">
	            <li><textarea rows="3" class="wmax" placeholder="<spring:message code='forum.label.input.feedback'/>" id="fdbkCts"></textarea></li> <%-- 피드백을 입력하세요 --%>
	            <li id="addBtn"><a href="#" class="ui basic grey small button" onclick="addFdbkCts();"><spring:message code='forum.button.reg'/></a></li> <%-- 등록 --%>
	        </ul>
	    </div>
    </c:if>
    <div class="article show">
    	<c:forEach var="forumFdbkVO" items="${forumFdbkList}" varStatus="status">
	    	<c:choose>
	    		<c:when test="${forumFdbkVO.level eq 1}">
	    			<ul>
			            <li class="imgBox"><div class="initial-img sm c-${forumFdbkVO.userIdColor}">${forumFdbkVO.userNm}</div></li>
			            <li>
			                <ul>
			                	<c:choose>
			                		<c:when test="${forumFdbkVO.delYn eq 'Y'}">
			                			 <li id="cts${status.index }"><spring:message code='forum.label.del.content'/></li> <%-- 삭제된 글 입니다. --%>
			                		</c:when>
			                		<c:otherwise>
			                			 <li id="cts${status.index }">${forumFdbkVO.fdbkCts}</li>
			                		</c:otherwise>
			                	</c:choose>
			                    <li class="tr">
			                    	<c:if test="${forumFdbkVO.delYn eq 'N'}">
				                        <em class="toggle_btn" onclick="btnAddFCmnt('${status.index }','${forumFdbkVO.forumFdbkCd}')"><spring:message code='forum.button.cmnt'/></em> <%-- 댓글 --%>
				                         <c:if test="${CLASS_USER_TYPE ne 'CLASS_LEARNER' && forumFdbkVO.rgtrId eq USER_ID}">
					                        <em><a href="#" onclick="btnEditFdbk('${status.index }','${forumFdbkVO.forumFdbkCd}')"><spring:message code='forum.button.mod'/></a></em> <%--수정  --%>
					                        <em><a href="#" onclick="delFdbk('${forumFdbkVO.forumFdbkCd}')"><spring:message code='forum.button.del'/></a></em> <%-- 삭제 --%>
				                        </c:if>
			                        </c:if>
			                        <fmt:parseDate var="regDttmFmt" pattern="yyyyMMddHHmmss" value="${forumFdbkVO.modDttm }" />
									<fmt:formatDate var="regDttm" pattern="yyyy.MM.dd(HH:mm)" value="${regDttmFmt }" />
			                        <em>${forumFdbkVO.regNm} (${forumFdbkVO.userId}) <code>${regDttm }</code></em>
			                    </li>
			                    <li class="toggle_box" id="toggle${status.index }">
			                        <ul class="comment-write">
			                            <li><textarea rows="3" class="wmax" placeholder="<spring:message code='forum.label.input.cmnt'/>" id="fdbkCmnt${status.index }"></textarea></li> <%-- 댓글을 입력하세요 --%>
			                            <li id="addBtnFCmnt"><a href="#" class="ui basic grey small button" onclick="addFCmntCts('${status.index }','','${forumFdbkVO.forumFdbkCd}')"><spring:message code='forum.button.reg'/></a></li> <%-- 등록 --%>
			                        </ul>
			                    </li>
			                </ul>
			            </li>
			        </ul>
	    		</c:when>
	    		<c:otherwise>
		    		<ul class="co_inner">
		            <li class="imgBox">
		         	<%--
		         		<c:choose>
			            	<c:when test="${forumFdbkVO.userId eq forumJoinUserVo.userId}">
			            		<div class="initial-img sm c-2">
			            	</c:when>
			            	<c:otherwise>
			            		<div class="initial-img sm c-6">
			            	</c:otherwise>
		            	</c:choose>
		            --%>
		            <div class="initial-img sm c-${forumFdbkVO.userIdColor}">
		            ${forumFdbkVO.userNm}</div></li>
		            <li>
		                <ul>        	
		                    <li>
		                    <c:if test="${not empty forumFdbkVO.toUserNm || forumFdbkVO.toUserNm ne ''}">
		                    	<span>To. ${forumFdbkVO.toUserNm}</span>
		                    </c:if>
		                    <c:choose>
		                		<c:when test="${forumFdbkVO.delYn eq 'Y'}">
		                			  <a id="cts${status.index }"><spring:message code='forum.label.del.content'/></a></li> <%-- 삭제된 글 입니다. --%>
		                		</c:when>
		                		<c:otherwise>
		                			  <a id="cts${status.index }">${forumFdbkVO.fdbkCts}</a></li>
		                		</c:otherwise>
		                	</c:choose>
		                   
		                    <li class="tr">
		                    	<c:if test="${forumFdbkVO.delYn eq 'N'}">
			                        <em class="toggle_btn" onclick="btnAddFCmnt('${status.index }','${forumFdbkVO.forumFdbkCd}')"><spring:message code='forum.button.cmnt'/></em> <%--  댓글--%>
			                        <c:if test="${CLASS_USER_TYPE ne 'CLASS_LEARNER' && forumFdbkVO.rgtrId eq USER_ID}">
			                        	<em><a href="#" onclick="btnEditFCmnt('${status.index }','${forumFdbkVO.forumFdbkCd}')"><spring:message code='forum.button.mod'/></a></em> <%-- 수정 --%>
				                    	<em><a href="#" onclick="delFdbk('${forumFdbkVO.forumFdbkCd}')"><spring:message code='forum.button.del'/></a></em> <%-- 삭제 --%>
				                    </c:if>
			                    </c:if>
			                    <fmt:parseDate var="regDttmFmt" pattern="yyyyMMddHHmmss" value="${forumFdbkVO.modDttm }" />
								<fmt:formatDate var="regDttm" pattern="yyyy.MM.dd(HH:mm)" value="${regDttmFmt }" />
		                        <em>${forumFdbkVO.regNm} (${forumFdbkVO.userId}) <code>${regDttm }</code></em>
		                    </li>
		                    <li class="toggle_box" id="toggle${status.index }">
		                        <ul class="comment-write">
		                            <li><textarea rows="3" class="wmax" placeholder="<spring:message code='forum.label.input.cmnt'/>" id="fdbkCmnt${status.index }"></textarea></li> <%-- 댓글을 입력하세요 --%>
		                            <li id="addBtnFCmnt"><a href="#" class="ui basic grey small button"  onclick="addFCmntCts('${status.index }','','${forumFdbkVO.forumFdbkCd}')"><spring:message code='forum.button.reg'/></a></li> <%--등록  --%>
		                        </ul>
		                    </li>
		                </ul>
		            </li>
		        </ul>
	    		</c:otherwise>
	    	</c:choose>
        </c:forEach>
    </div>
</div>