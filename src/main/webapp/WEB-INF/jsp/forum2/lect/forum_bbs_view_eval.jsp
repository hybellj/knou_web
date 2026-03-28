<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!DOCTYPE html>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
<script type="text/javascript">
$(document).ready(function() {
	$("#searchValue").bind("keydown", enterKeyPress);
	function enterKeyPress(event) {
		if (event.keyCode == '13') {
			event.preventDefault();
			listForum(1);
		}
	}
});
</script>
<c:if test="${CLASS_USER_TYPE ne 'CLASS_LEARNER' && (empty forumVo.searchMenu || forumVo.searchMenu != 'EZG')}">
<h3 class="page-title mt20" id="fourmTitle"><spring:message code="forum.label.forum"/> <spring:message code="forum.label.atcl"/> <spring:message code="forum.label.list"/></h3> <!-- 토론 글 목록 -->
</c:if>
<c:if test="${forumVo.forumCtgrCd eq 'TEAM'}">
<h3 class="page-title mt20"></h3>
</c:if>
<%-- <div class="option-content">
	<div class="ui action input search-box">
		<input type="text" placeholder="<spring:message code='forum.label.user.no'/>,<spring:message code='forum.label.user_id'/>" id="searchValue" value="<c:out value='${forumVo.searchValue}' />"> <!-- 학번,아이디 -->
		<input type="text" style="display: none;"/> 
		<a class="ui icon button"  onclick="listForum(1);">
			<i class="search icon"></i>
		</a>
	</div>
	<div class="button-area">
		<select class="ui dropdown list-num" id="listScale" onchange="listForum();">
			<option value="10" ${forumVo.listScale == 10?'selected':''}>10</option>
			<option value="20" ${forumVo.listScale == 20?'selected':''}>20</option>
			<option value="50" ${forumVo.listScale == 50?'selected':''}>50</option>
			<option value="100" ${forumVo.listScale == 100?'selected':''}>100</option>
		</select>
	</div>
</div> --%>
<c:choose>
	<c:when test="${empty forumAtclList }">
		<div class="flex-container m-hAuto">
			<div class="no_content">
				<i class="icon-cont-none ico f170" aria-hidden="true"></i> 
				<span><spring:message code="forum.common.empty"/></span> <!-- 등록된 내용이 없습니다 -->
			</div>
		</div>
	</c:when>
	<c:otherwise>
		<c:forEach var="forumAtclVO" items="${forumAtclList}" varStatus="status">
		<div class="ui attached message element">
			<div class="ui attached message">
				<div class="header small card-item-center">
					<ul class="viewInfo">
						<li><span><spring:message code="forum.label.reg.user"/></span>${forumAtclVO.rgtrnm}(${forumAtclVO.userId})</li>  <!-- 작성자 -->
						<c:choose>
							<c:when test="${forumAtclVO.atclTypeCd eq 'NORMAL_N' || forumAtclVO.atclTypeCd eq 'TEAM_N'}">
							<c:if test="${forumAtclVO.prosConsTypeCd eq 'F'}">
							<!-- <li><strong class="fcOlive">FeedBack</strong></li> -->
							</c:if>
							</c:when>
							<c:otherwise>
								<c:choose>
									<c:when test="${forumAtclVO.prosConsTypeCd eq 'P'}">
										<li><span><spring:message code="forum.label.pros.cons.type"/></span><strong class="fcBlue"><spring:message code="forum.label.pros"/></strong></li> <!--찬반 구분  --> <!-- 찬성 -->
									</c:when>
									<c:when test="${forumAtclVO.prosConsTypeCd eq 'C'}">
										<li><span><spring:message code="forum.label.pros.cons.type"/></span><strong class="fcRed"><spring:message code="forum.label.cons"/></strong></li> <!--찬반 구분  --> <!-- 반대 -->
									</c:when>
									<c:otherwise>
										<!-- <li><strong class="fcOlive">FeedBack</strong></li> -->
									</c:otherwise>
								</c:choose>
							</c:otherwise>
						</c:choose>
						<fmt:parseDate var="regDttmFmt" pattern="yyyyMMddHHmmss" value="${forumAtclVO.regDttm }" />
						<fmt:formatDate var="regDttm" pattern="yyyy.MM.dd(HH:mm)" value="${regDttmFmt }" />
						<li><span><spring:message code="forum.label.reg.dttm"/></span>${regDttm }</li> <!-- 작성일시 -->
						<li>
							<span><spring:message code="forum.label.attachFile"/></span> <!-- 첨부파일 --> 
							<c:forEach var="attachFiles" items="${forumAtclVO.fileList}" varStatus="status1">
								<c:if test="${status1.index ne 0}">,</c:if>
								<a href="javascript:fileDown('${attachFiles.fileSn}', '${attachFiles.repoCd }');" class="link">${attachFiles.fileNm}</a>
							</c:forEach>
						</li>
					</ul>
					<%-- 
					<div class="mla f120">
						<spring:message code="common.label.same.rate"/><!-- 유사율 --> 
						<c:choose>
							<c:when test="${not empty forumAtclVO.konanMaxCopyRate}">
								<a class="fcBlue" href="${konanCopyScoreUrl}?domain=e_forum&docId=${forumAtclVO.atclSn}" target="_blank">${forumAtclVO.konanMaxCopyRate}%</a>
							</c:when>
							<c:otherwise>
								<span class="mr20"> - </span>
							</c:otherwise>
						</c:choose>
					</div>
					 --%>
				</div>
				<div class="ui segment ml10 mr10 mt10 mb10">
				<c:choose>
					<c:when test="${forumAtclVO.delYn eq 'Y' }">
						<spring:message code="forum.label.del.forum.atcl"/> <!-- 삭제된 토론 글 입니다. -->
					</c:when>
					<c:otherwise>
						<pre id="cts_${forumAtclVO.atclSn }">${forumAtclVO.cts }</pre>
					</c:otherwise>
				</c:choose>
				</div>
				<div class="comment border0 mt10">
					<div class="ui box flex-item">
						<div class="flex-item mra">
							<c:if test="${forumAtclVO.cmntCount > 0}">
								<button type="button" class="toggle_commentlist flex-item" id="cmntOpen${status.index }" onclick="cmntView('<c:out value="${forumAtclVO.atclSn}"/>','${status.index }');">
									<i class="xi-message-o f120 mr5" aria-hidden="true"></i>
									${forumAtclVO.cmntCount}<span class="desktop_elem"><spring:message code="forum.label.cnt.forum.cmnt"/><!-- 개의 댓글이 있습니다. --></span>
									<i class="xi-angle-down-min" aria-hidden="true"></i>
								</button>
							</c:if>
						</div>
					</div>
					<%-- 
					<div class="article" id="article${status.index }">
					</div>
					 --%>
					<!-- cmntList -->
						<div class="article p10 commentlist ui segment border0 on" id="article${status.index}">
						<c:forEach var="item" items="${forumAtclVO.cmntList}" varStatus="cmnt">
							<c:if test="${item.atclSn eq forumAtclVO.atclSn}">
							<fmt:parseDate var="regDateFmt" pattern="yyyyMMddHHmmss" value="${item.modDttm}" />
							<fmt:formatDate var="regDate" pattern="yyyy.MM.dd(HH:mm)" value="${regDateFmt}" />
								<c:choose>
									<c:when test="${item.level eq '1'}">
							<ul>
								<li class="imgBox">
									<div class="initial-img sm c-4">${item.userNm}</div>
								</li>
								<li>
									<ul>
										<li class="flex-item">
											<em class="mra">${item.rgtrnm} (${item.cmntCtsLen}<spring:message code='forum.label.word'/><!-- 자 -->) <code>${regDate}</code></em>
											<button type="button" class="toggle_btn" onclick="btnAddCmnt('${cmnt.index}','${status.index}','${item.atclSn}','${item.cmntSn}')"><spring:message code='forum.button.cmnt'/><!-- 댓글 --></button>
										<c:if test="${item.rgtrId eq userId and item.delYn eq 'N'}">
											<ul class="ui icon top right pointing dropdown" tabindex="0">
												<i class="xi-ellipsis-v p5"></i>
												<div class="menu" tabindex="-1">
													<button type="button" class="item" onClick="btnEditCmnt('${cmnt.index}','${status.index}','${item.level}','${item.cmntSn}','${item.atclSn}')"><spring:message code='forum.button.mod'/></button><!-- 수정 --></button>
													<button type="button" class="item" onClick="delCmnt('${item.rgtrId}','${item.cmntSn}')"><spring:message code='forum.button.del'/><!-- 삭제 --></button>
												</div>
											</ul>
										</c:if>
										</li>
										<li>
											<div class="flex flex-column align-items-start p4">
										<c:choose>
											<c:when test="${item.delYn eq 'Y'}">
												<span class="ui red label"><spring:message code='forum.label.del.forum.cmnt'/><!-- 삭제된 댓글 입니다. --></span>
											</c:when>
											<c:otherwise>
												<div id="cmntCts${cmnt.index}${status.index}">${item.cmntCts}</div>
											</c:otherwise>
										</c:choose>
											</div>
										</li>
										<li class="toggle_box" id="toggleCmnt${cmnt.index}${status.index}" >
											<ul class="comment-write">
												<li>
													<textarea rows="3" class="wmax" id="cmntText${cmnt.index}${status.index}" placeholder="<spring:message code='forum.alert.input.forum_reply'/>"></textarea><!-- 댓글을 입력하세요 -->
												</li>
												<li id="addBtnCmnt">
													<a href="javascript:addCmnt('${item.atclSn}','${item.cmntSn}','${cmnt.index}','${status.index}')" class="ui basic grey small button"><spring:message code='forum.button.reg'/><!-- 등록 --></a>
												</li>
											</ul>
										</li>
									</ul>
								</li>
							</ul>
									</c:when>
									<c:otherwise>
							<ul class="co_inner">
								<li class="imgBox">
									<div class="initial-img sm c-4">${item.userNm}</div>
								</li>
								<li>
									<ul>
										<li class="flex-item">
											<em class="mra">${item.rgtrnm} (${item.cmntCtsLen}<spring:message code='forum.label.word'/><!-- 자 -->) <code>${regDate}</code></em>
											<button type="button" class="toggle_btn" onclick="btnAddCmnt('${cmnt.index}','${status.index}','${item.atclSn}','${item.cmntSn}')"><spring:message code='forum.button.cmnt'/><!-- 댓글 --></button>
											<c:if test="${item.rgtrId eq userId}">
											<ul class="ui icon top right pointing dropdown" tabindex="0">
												<i class="xi-ellipsis-v p5"></i>
												<div class="menu" tabindex="-1">
													<button type="button" class="item" onClick="btnEditCmnt('${cmnt.index}','${status.index}','${item.level}','${item.cmntSn}','${item.atclSn}')"><spring:message code='forum.button.mod'/><!-- 수정 --></button>
													<button type="button" class="item" onClick="delCmnt('${item.rgtrId}','${item.cmntSn}')"><spring:message code='forum.button.del'/><!-- 삭제 --></button>
												</div>
											</ul>
											</c:if>
										</li>
										<li>
											<div class="flex flex-column align-items-start p4">
											<c:choose>
												<c:when test="${item.delYn eq 'Y'}">
												<span class="ui red label"><spring:message code='forum.label.del.forum.cmnt'/><!-- 삭제된 댓글 입니다. --></span>
												</c:when>
												<c:otherwise>
												<em class="mra">@${item.parRgtrNm}</em> <div id="cmntCts${cmnt.index}${status.index}">${item.cmntCts}</div>
												</c:otherwise>
											</c:choose>
											</div>
										</li>
										<li class="toggle_box" id="toggleCmnt${cmnt.index}${status.index}">
											<ul class="comment-write">
												<li>
													<textarea rows="3" class="wmax" id="cmntText${cmnt.index}${status.index}" placeholder="<spring:message code='forum.alert.input.forum_reply'/>"></textarea><!-- 댓글을 입력하세요 -->
												</li>
												<li id="addBtnCmnt">
													<a href="javascript:addCmnt('${item.atclSn}','${item.cmntSn}','${cmnt.index}','${status.index}')" class="ui basic grey small button"><spring:message code='forum.button.reg'/><!-- 등록 --></a>
												</li>
											</ul>
										</li>
									</ul>
								</li>
							</ul>
									</c:otherwise>
								</c:choose>
							</c:if>
						</c:forEach>
						</div>
					<!-- cmntList -->
				</div>
			</div>
		</div>
		</c:forEach>
		<%--<tagutil:paging pageInfo="${pageInfo}" funcName="forumAtclList"/>--%>
	</c:otherwise>
</c:choose>