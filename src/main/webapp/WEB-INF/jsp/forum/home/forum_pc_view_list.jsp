<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp"%>

<c:if test="${viewYn eq 'Y'}">
	<script type="text/javascript">
		$(document).ready(function() {
		});
		
		function moreView(atclSn) {
			$("#cts_" + atclSn).removeClass("more-view").addClass("more-view");
		}
	</script>
	<c:if test="${forumVo.prosConsRateOpenYn eq 'Y'}">
		<ul class="process-bar mb20">
			<fmt:formatNumber value="${(forumVo.forumAtclPorsCnt / forumVo.forumAtclCnt)*100}" pattern="#,##" var="numberType" />
			<fmt:formatNumber value="${(forumVo.forumAtclConsCnt / forumVo.forumAtclCnt)*100}" pattern="#,##" var="numberType1" />
			<fmt:parseNumber var="blue" integerOnly="true" value="${numberType}" />
			<fmt:parseNumber var="softgrey" integerOnly="true"
				value="${numberType1}" />
			<c:choose>
				<c:when test="${forumVo.forumAtclCnt < 1}">
					<li class="bar-blue" style="width: 0%;"><spring:message code='forum.label.pros' /> 0% (${forumVo.forumAtclPorsCnt}<spring:message code='forum.label.person' />)</li>
					<!-- 찬성 --><!-- 명 -->
					<li class="bar-orange" style="width: 0%;"><spring:message code='forum.label.cons' /> 0% (${forumVo.forumAtclConsCnt}<spring:message code='forum.label.person' />)</li>
					<!-- 반대 --><!--명  -->
				</c:when>
				<c:otherwise>
					<li class="bar-blue" style="width: ${blue}%;"><spring:message code='forum.label.pros' /> ${blue}% (${forumVo.forumAtclPorsCnt}<spring:message code='forum.label.person' />)</li>
					<!-- 찬성 --><!--명  -->
					<li class="bar-orange" style="width: ${softgrey}%;"><spring:message code='forum.label.cons' /> ${softgrey}% (${forumVo.forumAtclConsCnt}<spring:message code='forum.label.person' />)</li>
					<!-- 반대 --><!--  명-->
				</c:otherwise>
			</c:choose>
		</ul>
	</c:if>
	
	<div class="ui grid stretched mb10">
		<!-- 찬성 의견 디자인 수정 부분 -->
		<div class="sixteen wide mobile eight wide tablet eight wide computer column">
			<div class="ui info message argBox">
				<div class="option-content header2">
					<spring:message code='forum.label.pros.opinion' /><!-- 찬성 의견 -->
				</div>
				
				<c:forEach var="forumAtclVO" items="${forumAtclList}" varStatus="status">
					<c:if test="${forumAtclVO.prosConsTypeCd eq 'P'}">
						<div class="mt0 p0 msg">
							<div class="option-content">
								<a href="#0" onclick="recomBtn('${forumAtclVO.atclSn}','${forumAtclVO.recomStatus}')">
									<c:choose>
										<c:when test="${forumAtclVO.recomStatus eq 'Y'}">
											<i class="blue thumbs up icon" />
										</c:when>
										<c:otherwise>
											<i class="blue thumbs up outline icon" />
										</c:otherwise>
									</c:choose>
								</a>
								<span class="mra">${forumAtclVO.likes}</span>
								<c:if test="${forumAtclVO.rgtrId eq userId && forumAtclVO.delYn eq 'N'}">
								<div class="ui top right pointing dropdown right-box" tabindex="0">
									<span class="bars"><spring:message code='forum.label.menu' /><!-- 메뉴  --></span>
									<div class="menu" tabindex="-1">
										<a href="#0" class="item" onclick="editAtclBtn('${forumAtclVO.atclSn}','${forumAtclVO.rgtrId}','P')"><spring:message code='forum.button.mod' /></a><!-- 수정 -->
										<a href="#0" class="item" onclick="delAtcl('${forumAtclVO.atclSn}','${forumAtclVO.rgtrId}')"><spring:message code='forum.button.del' /></a><!-- 삭제 -->
									</div>
								</div>
								</c:if>
							</div>
	
							<ul class="flex gap4 f080 mt10 mb10 opacity7">
								<input type="hidden" name="maxOdr" value="${forumAtclVO.maxOdr}">
								<li>
									<c:choose>
										<c:when test="${forumVo.regOpenYn eq 'Y'}">
											<li>${forumAtclVO.regNm}(${forumAtclVO.userId})</li>
										</c:when>
										<c:otherwise>
											<c:choose>
												<c:when test="${forumAtclVO.rgtrId eq userId}">
													<li>${forumAtclVO.regNm}(${forumAtclVO.userId})</li>
												</c:when>
												<c:otherwise>
													<li>■■■(●●●●)</li>
												</c:otherwise>
											</c:choose>
										</c:otherwise>
									</c:choose>
								</li>
								<fmt:parseDate var="regDttmFmt" pattern="yyyyMMddHHmmss" value="${forumAtclVO.modDttm}" />
								<fmt:formatDate var="regDttm" pattern="yyyy.MM.dd(HH:mm)" value="${regDttmFmt}" />
								<li><span>${regDttm}</span></li>
							</ul>
							
							<c:choose>
								<c:when test="${forumAtclVO.delYn eq 'Y'}">
									<div class="flex flex-column align-items-start p4">
										<span class="ui red label roundrect p2 pl4 pr4 f080"><spring:message code='forum.label.del.forum.atcl' /><!-- 삭제된 토론 글 입니다. --></span>
									</div>
								</c:when>
								<c:otherwise>
									<a href="#0" class="fix-box">
										<pre id="cts_${forumAtclVO.atclSn}" onclick="moreView('${forumAtclVO.atclSn}')"><c:out value="${forumAtclVO.cts}" /></pre>
									</a>
								</c:otherwise>
							</c:choose>
			
							<div class="comment border0 mt10">
								<div class="ui box flex-item">
									<div class="flex-item mra">
										<c:if test="${forumAtclVO.cmntCount > 0}">
										<button type="button" class="toggle_commentlist flex-item" id="cmntOpen${status.index}" onclick="cmntView('<c:out value="${forumAtclVO.atclSn}"/>','${status.index}');">
											<i class="xi-message-o f120 mr5" aria-hidden="true"></i>${forumAtclVO.cmntCount}<span class="desktop_elem"><spring:message code='forum.label.cnt.forum.cmnt' /><!-- 개의 댓글이 있습니다. --></span>
											<i class="xi-angle-down-min" aria-hidden="true"></i>
										</button>
										</c:if>
									</div>
									<c:if test="${PROFESSOR_VIRTUAL_LOGIN_YN ne 'Y' && forumVo.writeAuth eq 'Y'}">
									<a class="ui basic small button mla" id="cmntWrite${status.index}" onclick="cmntWrite('<c:out value="${forumAtclVO.atclSn}"/>','${status.index }');"><spring:message code='forum.button.cmnt' /> <spring:message code='forum.button.write' /><!-- 댓글 작성하기 --></a>
									</c:if>
								</div>
								<div class="toggle_box commentwrite" id="toggleBox${status.index}">
									<ul class="comment-write" id="comment${status.index}">
										<li><textarea rows="3" class="wmax" placeholder="<spring:message code='forum.label.input.cmnt.cmnt'/>" id="cmntText${status.index}"></textarea><!-- 댓글에 댓글을 입력하세요  --></li>
										<c:if test="${vo.aplyAsnYn eq 'Y'}">
											<%-- <li><input type='checkbox' name='ansReqYn${status.index}' id='ansReqYn${status.index}' class='mr10' /> <label><spring:message code='forum.checkbox.label.request'/><!-- 답변을 요청합니다. --></label></li> --%>
										</c:if>
										<li id="addBtn${status.index}"><a href="javascript:addCmnt('<c:out value="${forumAtclVO.atclSn}"/>','','${status.index}');" class="ui basic grey small button"><spring:message code='forum.button.reg' /><!--등록  --></a></li>
									</ul>
								</div>
	
								<!-- commentlist -->
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
																<em class="mra">${item.regNm} <c:if test="${item.delYn ne 'Y'}">(${item.cmntCtsLen}<spring:message code='forum.label.word'/><!-- 자 -->)</c:if> <code>${regDate}</code></em>
															<c:if test="${PROFESSOR_VIRTUAL_LOGIN_YN ne 'Y' and item.delYn ne 'Y'}">
																<button type="button" class="toggle_btn" onclick="btnAddCmnt('${cmnt.index}','${status.index}','${item.atclSn}','${item.cmntSn}')"><spring:message code='forum.button.cmnt'/><!-- 댓글 --></button>
															</c:if>
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
																		<span class="ui red label roundrect p2 pl4 pr4 f080"><spring:message code='forum.label.del.forum.cmnt'/><!-- 삭제된 댓글 입니다. --></span>
																	</c:when>
																	<c:otherwise>
																		<div id="cmntCts${cmnt.index}${status.index}"><c:out value="${item.cmntCts}" /></div>
																	</c:otherwise>
																</c:choose>
																</div>
															</li>
															<c:if test="${item.delYn ne 'Y'}">
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
															</c:if>
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
																<em class="mra">${item.regNm} <c:if test="${item.delYn ne 'Y'}">(${item.cmntCtsLen}<spring:message code='forum.label.word'/><!-- 자 -->)</c:if> <code>${regDate}</code></em>
																<c:if test="${PROFESSOR_VIRTUAL_LOGIN_YN ne 'Y' and item.delYn ne 'Y'}">
																<button type="button" class="toggle_btn" onclick="btnAddCmnt('${cmnt.index}','${status.index}','${item.atclSn}','${item.cmntSn}')"><spring:message code='forum.button.cmnt'/><!-- 댓글 --></button>
																</c:if>
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
																	<span class="ui red label roundrect p2 pl4 pr4 f080"><spring:message code='forum.label.del.forum.cmnt'/><!-- 삭제된 댓글 입니다. --></span>
																	</c:when>
																	<c:otherwise>
																	<em class="mra">@${item.parRegNm}</em> <div id="cmntCts${cmnt.index}${status.index}"><c:out value="${item.cmntCts}" /></div>
																	</c:otherwise>
																</c:choose>
																</div>
															</li>
															<c:if test="${item.delYn ne 'Y'}">
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
															</c:if>
														</ul>
													</li>
												</ul>
											</c:otherwise>
										</c:choose>
									</c:if>
								</c:forEach>
								</div>
								<!-- //commentlist -->
							</div>
						</div>
					</c:if>
				</c:forEach>
			</div>
		</div>
		<!-- 찬성 의견 디자인 수정 부분 -->
	
		<!-- 반대 의견 디자인 수정 부분 -->
		<div class="sixteen wide mobile eight wide tablet eight wide computer column">
			<div class="ui warning message argBox">
				<div class="option-content header2">
					<spring:message code='forum.label.cons.opinion' /><!--반대 의견  -->
				</div>
	
				<c:forEach var="forumAtclVO" items="${forumAtclList}" varStatus="status">
					<c:if test="${forumAtclVO.prosConsTypeCd eq 'C'}">
						<div class="mt0 p0 msg">
							<div class="option-content">
								<a href="#0" onclick="recomBtn('${forumAtclVO.atclSn}','${forumAtclVO.recomStatus}')">
									<c:choose>
										<c:when test="${forumAtclVO.recomStatus eq 'Y'}">
											<i class="red thumbs up icon" />
										</c:when>
										<c:otherwise>
											<i class="red thumbs up outline icon" />
										</c:otherwise>
									</c:choose>
								</a>
								<span class="mra">${forumAtclVO.likes }</span>
								<c:if test="${forumAtclVO.rgtrId eq userId && forumAtclVO.delYn eq 'N'}">
								<div class="ui top right pointing dropdown right-box" tabindex="0">
									<span class="bars"><spring:message code='forum.label.menu' /><!-- 메뉴  --></span>
									<div class="menu" tabindex="-1">
										<a href="#0" class="item" onclick="editAtclBtn('${forumAtclVO.atclSn}','${forumAtclVO.rgtrId}','C')"><spring:message code='forum.button.mod' /></a><!-- 수정 -->
										<a href="#0" class="item" onclick="delAtcl('${forumAtclVO.atclSn}','${forumAtclVO.rgtrId}')"><spring:message code='forum.button.del' /></a><!-- 삭제 -->
									</div>
								</div>
								</c:if>
							</div>
							<ul class="flex gap4 f080 mt10 mb10 opacity7">
								<input type="hidden" name="maxOdr" value="${forumAtclVO.maxOdr}">
								<c:choose>
									<c:when test="${forumVo.regOpenYn eq 'Y'}">
										<li>${forumAtclVO.regNm}(${forumAtclVO.userId})</li>
									</c:when>
									<c:otherwise>
										<c:choose>
											<c:when test="${forumAtclVO.rgtrId eq userId}">
												<li>${forumAtclVO.regNm}(${forumAtclVO.userId})</li>
											</c:when>
											<c:otherwise>
												<li>■■■(●●●●)</li>
											</c:otherwise>
										</c:choose>
									</c:otherwise>
								</c:choose>
								<fmt:parseDate var="regDttmFmt" pattern="yyyyMMddHHmmss" value="${forumAtclVO.modDttm}" />
								<fmt:formatDate var="regDttm" pattern="yyyy.MM.dd(HH:mm)" value="${regDttmFmt}" />
								<li><span>${regDttm}</span></li>
							</ul>
			
							<c:choose>
								<c:when test="${forumAtclVO.delYn eq 'Y'}">
									<div class="flex flex-column align-items-start p4">
										<span class="ui red label roundrect p2 pl4 pr4 f080"><spring:message code='forum.label.del.forum.atcl' /><!-- 삭제된 토론 글 입니다. --></span>
									</div>
								</c:when>
								<c:otherwise>
									<a href="#0" class="fix-box">
										<pre id="cts_${forumAtclVO.atclSn}" onclick="moreView('${forumAtclVO.atclSn}')"><c:out value="${forumAtclVO.cts}" /></pre>
									</a>
								</c:otherwise>
							</c:choose>
			
							<div class="comment border0 mt10">
								<div class="ui box flex-item">
									<div class="flex-item mra">
									<c:if test="${forumAtclVO.cmntCount > 0}">
										<i class="xi-message-o f120 mr5" aria-hidden="true"></i>
										<button type="button" class="toggle_commentlist flex-item" id="cmntOpen${status.index}" onclick="cmntView('<c:out value="${forumAtclVO.atclSn}"/>','${status.index }');">${forumAtclVO.cmntCount}<spring:message code='forum.label.cnt.forum.cmnt' /><!--개의 댓글이 있습니다  --></button>
										<i class="xi-angle-down-min" aria-hidden="true"></i>
									</c:if>
									</div>
									<c:if test="${PROFESSOR_VIRTUAL_LOGIN_YN ne 'Y' && forumVo.writeAuth eq 'Y'}">
									<a class="ui basic small button mla" id="cmntWrite${status.index}" onclick="cmntWrite('<c:out value="${forumAtclVO.atclSn}"/>','${status.index }');"><spring:message code='forum.button.cmnt' /> <spring:message code='forum.button.write' /><!-- 댓글 작성하기 --></a>
									</c:if>
								</div>
								<div class="toggle_box commentwrite" id="toggleBox${status.index}">
									<ul class="comment-write" id="comment${status.index}">
										<li><textarea rows="3" class="wmax" placeholder="<spring:message code='forum.label.input.cmnt.cmnt'/>" id="cmntText${status.index}"></textarea><!-- 댓글에 댓글을 입력하세요  --></li>
										<c:if test="${vo.aplyAsnYn eq 'Y'}">
											<%-- <li><input type='checkbox' name='ansReqYn${status.index}' id='ansReqYn${status.index}' class='mr10' /> <label><spring:message code='forum.checkbox.label.request'/><!-- 답변을 요청합니다. --></label></li> --%>
										</c:if>
										<li id="addBtn${status.index}"><a href="javascript:addCmnt('<c:out value="${forumAtclVO.atclSn}"/>','','${status.index}');" class="ui basic grey small button"><spring:message code='forum.button.reg' /><!--등록  --></a></li>
									</ul>
								</div>
			
								<!-- commentlist -->
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
																<em class="mra">${item.regNm} <c:if test="${item.delYn ne 'Y'}">(${item.cmntCtsLen}<spring:message code='forum.label.word'/><!-- 자 -->)</c:if> <code>${regDate}</code></em>
															<c:if test="${PROFESSOR_VIRTUAL_LOGIN_YN ne 'Y' and item.delYn ne 'Y'}">
																<button type="button" class="toggle_btn" onclick="btnAddCmnt('${cmnt.index}','${status.index}','${item.atclSn}','${item.cmntSn}')"><spring:message code='forum.button.cmnt'/><!-- 댓글 --></button>
															</c:if>
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
																		<span class="ui red label roundrect p2 pl4 pr4 f080"><spring:message code='forum.label.del.forum.cmnt'/><!-- 삭제된 댓글 입니다. --></span>
																	</c:when>
																	<c:otherwise>
																		<div id="cmntCts${cmnt.index}${status.index}"><c:out value="${item.cmntCts}" /></div>
																	</c:otherwise>
																</c:choose>
																</div>
															</li>
															<c:if test="${item.delYn ne 'Y'}">
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
															</c:if>
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
																<em class="mra">${item.regNm} <c:if test="${item.delYn ne 'Y'}">(${item.cmntCtsLen}<spring:message code='forum.label.word'/><!-- 자 -->)</c:if> <code>${regDate}</code></em>
																<c:if test="${PROFESSOR_VIRTUAL_LOGIN_YN ne 'Y' and item.delYn ne 'Y'}">
																<button type="button" class="toggle_btn" onclick="btnAddCmnt('${cmnt.index}','${status.index}','${item.atclSn}','${item.cmntSn}')"><spring:message code='forum.button.cmnt'/><!-- 댓글 --></button>
																</c:if>
																<c:if test="${item.rgtrId eq userId and item.delYn eq 'N'}">
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
																	<span class="ui red label roundrect p2 pl4 pr4 f080"><spring:message code='forum.label.del.forum.cmnt'/><!-- 삭제된 댓글 입니다. --></span>
																	</c:when>
																	<c:otherwise>
																	<em class="mra">@${item.parRegNm}</em> <div id="cmntCts${cmnt.index}${status.index}"><c:out value="${item.cmntCts}" /></div>
																	</c:otherwise>
																</c:choose>
																</div>
															</li>
															<c:if test="${item.delYn ne 'Y'}">
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
															</c:if>
														</ul>
													</li>
												</ul>
											</c:otherwise>
										</c:choose>
									</c:if>
								</c:forEach>
								</div>
								<!-- //commentlist -->
							</div>
						</div>
					</c:if>
				</c:forEach>
			</div>
		</div>
		<!-- 반대 의견 디자인 수정 부분 -->
	</div>
</c:if>