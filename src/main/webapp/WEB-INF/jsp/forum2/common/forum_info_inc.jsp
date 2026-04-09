<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>

<fmt:parseDate var="startDateFmt" pattern="yyyyMMddHHmm" value="${dscsVO.dscsSdttm}" />
<fmt:formatDate var="forumStartDttm" pattern="yyyy.MM.dd(HH:mm)" value="${startDateFmt}" />
<fmt:parseDate var="endDateFmt" pattern="yyyyMMddHHmm" value="${dscsVO.dscsEdttm}" />
<fmt:formatDate var="forumEndDttm" pattern="yyyy.MM.dd(HH:mm)" value="${endDateFmt}" />

<div class="elements_wrap forum_info_wrap">
	<ul class="accordion">
		<li class="active forum_info_item">
			<div class="title-wrap">
				<a class="title" href="#0">
					<div class="lecture_tit">
						<strong>${dscsVO.dscsTtl}</strong>
						<p class="desc">
							<span><spring:message code='forum.label.forum.date' /><!-- 토론기간 --> : <strong>${forumStartDttm} ~ ${forumEndDttm}</strong></span>
							<span><spring:message code='forum.label.scoreAply' /><!-- 성적반영 --> :
								<strong>
									<c:choose>
										<c:when test="${dscsVO.mrkRfltyn eq 'Y'}">
											<spring:message code='forum.common.yes'/><!-- 예 -->
										</c:when>
										<c:otherwise>
											<spring:message code='forum.common.no'/><!-- 아니오 -->
										</c:otherwise>
									</c:choose>
								</strong>
							</span>
							<span><spring:message code='forum.label.score.open' /><!-- 성적공개 --> :
								<strong>
									<c:choose>
										<c:when test="${dscsVO.mrkOyn eq 'Y'}">
											<spring:message code='forum.common.yes'/><!-- 예 -->
										</c:when>
										<c:otherwise>
											<spring:message code='forum.common.no'/><!-- 아니오 -->
										</c:otherwise>
									</c:choose>
								</strong>
							</span>
						</p>
					</div>
					<i class="arrow xi-angle-down"></i>
				</a>
			</div>
			<div class="cont content" style="padding:0;">
				<div class="table_list forum_info_list">
					<ul class="list">
						<li class="head"><label for="forum_info_contents"><spring:message code='forum.label.forum.artl'/><!-- 토론 내용 --></label></li>
						<li>
							<div class="tb_content">
								<textarea class="form-control wmax resize-none" rows="6" id="forum_info_contents" readonly>${dscsVO.dscsCts}</textarea>
							</div>
						</li>
					</ul>

					<ul class="list">
						<li class="head"><label><spring:message code='forum.label.forum.date'/><!-- 토론기간 --></label></li>
						<li>${forumStartDttm} ~ ${forumEndDttm}</li>
					</ul>

					<ul class="list">
						<li class="head"><label><spring:message code='forum.label.scoreAply'/><!-- 성적반영 --></label></li>
						<li>
							<c:choose>
								<c:when test="${dscsVO.mrkRfltyn eq 'Y'}">
									<spring:message code='forum.common.yes'/><!-- 예 -->
								</c:when>
								<c:otherwise>
									<spring:message code='forum.common.no'/><!-- 아니오 -->
								</c:otherwise>
							</c:choose>
						</li>
						<li class="head"><label><spring:message code='forum.label.forum.gradeRef'/><!-- 성적반영비율 --></label></li>
						<li>
							<c:choose>
								<c:when test="${dscsVO.mrkRfltyn ne 'Y'}">-</c:when>
								<c:otherwise>${dscsVO.mrkRfltrt}%</c:otherwise>
							</c:choose>
						</li>
					</ul>

					<ul class="list">
						<li class="head"><label><spring:message code='forum.label.score.open'/><!-- 성적공개 --></label></li>
						<li>
							<c:choose>
								<c:when test="${dscsVO.mrkOyn eq 'Y'}">
									<spring:message code='forum.common.yes'/><!-- 예 -->
								</c:when>
								<c:otherwise>
									<spring:message code='forum.common.no'/><!-- 아니오 -->
								</c:otherwise>
							</c:choose>
						</li>
					</ul>

					<ul class="list">
						<li class="head"><label><spring:message code='forum.label.evalCtgr'/><!-- 평가 방법 --></label></li>
						<li>
							<c:choose>
								<c:when test="${dscsVO.evlScrTycd eq 'SCR'}">
									<spring:message code='forum.label.evalctgr.score'/><!-- 점수형 -->
								</c:when>
								<c:otherwise>
									<spring:message code='forum.label.evalctgr.participate'/><!-- 참여형 -->
									<small class="note ml10"><spring:message code='forum.label.evalctgr.participate.desc'/><!-- ( 토론 참여 : 100점, 미참여 : 0점 자동배점 ) --></small>
								</c:otherwise>
							</c:choose>
						</li>
					</ul>

					<ul class="list">
						<li class="head"><label><spring:message code='forum.label.attachFile'/><!-- 첨부파일 --></label></li>
						<li>
							<div class="add_file_list forum_attach_list">
								<c:if test="${not empty dscsVO.fileList}">
									<uiex:filedownload fileList="${dscsVO.fileList}"/>
								</c:if>
							</div>
						</li>
					</ul>

					<ul class="list">
						<li class="head"><label><spring:message code='forum.label.teamForumYn'/><!-- 팀 토론 --></label></li>
						<li class="in_table">
							<c:choose>
								<c:when test="${dscsVO.dscsUnitTycd eq 'TEAM'}">
									<div class="view_con forum_team_info">
										<div><spring:message code='forum.common.yes'/><!-- 예 --></div>
										<c:choose>
											<c:when test="${dscsVO.byteamDscsUseyn eq 'Y'}">
												<div><spring:message code='forum.label.lrngrp'/><%--학습그룹--%> : ${dscsVO.dscsGrpnm}</div>
												<div><spring:message code='forum.label.lrngrp.dscs.setting'/><%--학습그룹별 토론 설정--%> : <spring:message code='forum.label.use.y'/><!-- 사용 --></div>
											</c:when>
											<c:otherwise>
												<div><spring:message code='forum.label.lrngrp.dscs.setting'/><%--학습그룹별 토론 설정--%> : <spring:message code='forum.label.use.n'/><!-- 미사용 --></div>
											</c:otherwise>
										</c:choose>
									</div>

									<c:if test="${dscsVO.byteamDscsUseyn eq 'Y'}">
										<div class="table-wrap mb30">
											<table class="table-type5 in_table forum_team_table">
												<colgroup>
													<col class="width-5per" />
													<col class="width-15per" />
													<col />
												</colgroup>
												<c:forEach var="item" items="${dscsVO.teamDscsList}" varStatus="status">
													<tbody>
														<tr>
															<th rowspan="4" class="group-header"><label>${item.teamnm}</label></th>
															<th><label><spring:message code='forum.label.lrngrp.mebers'/><!-- 학습그룹 구성원 --></label></th>
															<td>${item.leaderNm} ??${item.teamMbrCnt}</td>
														</tr>
														<tr>
															<th><label><spring:message code='forum.label.team.ttl'/><!-- 부주제 --></label></th>
															<td>${item.dscsTtl}</td>
														</tr>
														<tr>
															<th><label><spring:message code='forum.label.content'/><!-- 내용 --></label></th>
															<td>
																<label class="width-100per">
																	<textarea rows="4" class="form-control resize-none" readonly>${item.dscsCts}</textarea>
																</label>
															</td>
														</tr>
														<tr>
															<th><label><spring:message code='forum.label.attachFile'/><!-- 첨부파일 --></label></th>
															<td>
																<div class="add_file_list forum_team_attach_list">
																	<c:choose>
																		<c:when test="${not empty item.fileList}">
																			<uiex:filedownload fileList="${item.fileList}"/>
																		</c:when>
																		<c:otherwise>-</c:otherwise>
																	</c:choose>
																</div>
															</td>
														</tr>
													</tbody>
												</c:forEach>
											</table>
										</div>
									</c:if>
								</c:when>
								<c:otherwise>
									<div class="view_con forum_team_info"><spring:message code='forum.common.no'/><!-- 아니오 --></div>
								</c:otherwise>
							</c:choose>
						</li>
					</ul>

					<ul class="list">
						<li class="head"><label><spring:message code='forum.label.otherViewYn'/><!-- 참여글 보기 옵션 --></label></li>
						<li>
							<c:choose>
								<c:when test="${dscsVO.otherViewYn eq 'Y'}">
									<spring:message code='forum.common.yes'/><!-- 예 -->
								</c:when>
								<c:otherwise>
									<spring:message code='forum.common.no'/><!-- 아니오 -->
								</c:otherwise>
							</c:choose>
						</li>
					</ul>

					<ul class="list">
						<li class="head"><label><spring:message code='forum.label.aplyAsnYn'/><!-- 댓글 답변 요청 --></label></li>
						<li>
							<c:choose>
								<c:when test="${dscsVO.aplyAsnYn eq 'Y'}">
									<spring:message code='forum.common.yes'/><!-- 예 -->
								</c:when>
								<c:otherwise>
									<spring:message code='forum.common.no'/><!-- 아니오 -->
								</c:otherwise>
							</c:choose>
						</li>
					</ul>

					<ul class="list">
						<li class="head"><label><spring:message code='forum.label.prosCons'/><!-- 찬반토론 --></label></li>
						<li>
							<c:choose>
								<c:when test="${dscsVO.prosConsForumCfg eq 'Y'}">
									<div class="view_con forum_pros_cons_info">
										<c:if test="${dscsVO.prosConsRateOpenYn eq 'Y'}">
											<div><spring:message code='forum.label.prosConsRate'/><!-- 찬반 비율 공개 --> : <spring:message code='forum.common.yes'/><!-- 예 --></div>
										</c:if>
										<c:if test="${dscsVO.regOpenYn eq 'Y'}">
											<div><spring:message code='forum.label.regOpen'/><!-- 작성자 공개 --> : <spring:message code='forum.common.yes'/><!-- 예 --></div>
										</c:if>
										<c:if test="${dscsVO.multiAtclYn eq 'Y'}">
											<div><spring:message code='forum.label.multiAtcl'/><!-- 의견글 복수 등록 --> : <spring:message code='forum.common.yes'/><!-- 예 --></div>
										</c:if>
										<c:if test="${dscsVO.prosConsModYn eq 'Y'}">
											<div><spring:message code='forum.label.prosConsMod'/><!-- 찬반의견 변경 --> : <spring:message code='forum.common.yes'/><!-- 예 --></div>
										</c:if>
									</div>
								</c:when>
								<c:otherwise>
									<spring:message code='forum.common.no'/><!-- 아니오 -->
								</c:otherwise>
							</c:choose>
						</li>
					</ul>
				</div>
			</div>
		</li>
	</ul>
</div>
