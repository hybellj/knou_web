<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>

<div class="accordion">
	<div class="title flex">
		<div class="title_cont">
			<div class="left_cont">
				<div class="lectTit_box">
					<p class="lect_name">${forumVo.forumTitle}</p>
					<fmt:parseDate var="startDateFmt" pattern="yyyyMMddHHmm"
						value="${forumVo.forumStartDttm }" />
					<fmt:formatDate var="forumStartDttm"
						pattern="yyyy.MM.dd(HH:mm)" value="${startDateFmt }" />
					<fmt:parseDate var="endDateFmt" pattern="yyyyMMddHHmm"
						value="${forumVo.forumEndDttm }" />
					<fmt:formatDate var="forumEndDttm"
						pattern="yyyy.MM.dd(HH:mm)" value="${endDateFmt }" />
					<span class="fcGrey"><small><spring:message code='forum.label.forum.date'/><!-- 토론기간 --> : 	${forumStartDttm} ~ ${forumEndDttm}
					| <spring:message code='forum.label.scoreAply'/><!-- 성적반영 --> :
						<c:choose>
							<c:when test="${forumVo.scoreAplyYn eq 'Y'}">
								<spring:message code='forum.common.yes'/><!-- 예 -->
							</c:when>
							<c:otherwise>
								<spring:message code='forum.common.no'/><!-- 아니오 -->
							</c:otherwise>
						</c:choose>
					| <spring:message code='forum.label.score.open'/><!-- 성적공개 --> :
						<c:choose>
							<c:when test="${forumVo.scoreOpenYn eq 'Y'}">
								<spring:message code='forum.common.yes'/><!-- 예 -->
							</c:when>
							<c:otherwise>
								<spring:message code='forum.common.no'/><!-- 아니오 -->
							</c:otherwise>
						</c:choose>
					</small></span>
				</div>
			</div>
		</div>
		<i class="dropdown icon ml20"></i>
	</div>
	<div class="content" style="padding:0;">
		<!--table-type-->
		<div class="table-wrap">
			<table class="table-type2">
				<colgroup>
					<col class="width-20per" />
					<col class="" />
				</colgroup>
				<tbody>
					<tr>
						<th>
							<label for="subjectLabel"><spring:message code='forum.label.forum.artl'/><!-- 토론 내용 --></label>
						</th>
						<td class="t_left" colspan="3"><pre>${forumVo.forumArtl}</pre></td>
					</tr>
					<tr>
						<th>
							<label for="extSendLabel"><spring:message code='forum.label.forum.date'/><!-- 토론기간 --></label>
						</th>
						<td class="t_left" colspan="3">
							${forumStartDttm} ~ ${forumEndDttm}
						</td>
					</tr>
					<tr>
						<th>
							<label for="test"><spring:message code='forum.label.scoreAply'/><!-- 성적반영 --></label>
						</th>
						<td class="t_left">
							<c:choose>
								<c:when test="${forumVo.scoreAplyYn eq 'P'}">
									<spring:message code='forum.common.yes'/><!-- 예 -->
								</c:when>
								<c:otherwise>
									<spring:message code='forum.common.no'/><!-- 아니오 -->
								</c:otherwise>
							</c:choose>
						</td>
						<th>
							<label for="test"><spring:message code='forum.label.forum.gradeRef' /><!-- 성적반영비율 --></label>
						</th>
						<td class="t_left">
							<c:choose>
								<c:when test="${forumVo.scoreAplyYn ne 'Y' }">
									-
								</c:when>
								<c:otherwise>
									${forumVo.scoreRatio}%
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
					<tr>
						<th>
							<label for="test"><spring:message code='forum.label.score.open'/><!-- 성적공개 --></label>
						</th>
						<td class="t_left" colspan="3">
							<c:choose>
								<c:when test="${forumVo.scoreOpenYn eq 'P'}">
									<spring:message code='forum.common.yes'/><!-- 예 -->
								</c:when>
								<c:otherwise>
									<spring:message code='forum.common.no'/><!-- 아니오 -->
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
					<tr>
						<th>
							<label for="test"><spring:message code='forum.label.evalCtgr'/><!-- 평가 방법 --></label>
						</th>
						<td class="t_left" colspan="3">
							<c:choose>
								<c:when test="${forumVo.evalCtgr eq 'P'}">
									<spring:message code='forum.label.evalctgr.score'/><!-- 점수형 -->
								</c:when>
								<c:otherwise>
									<spring:message code='forum.label.evalctgr.participate'/><!-- 참여형 -->
									<span class="fcBlue"><spring:message code='forum.label.evalctgr.participate.desc'/></span><!-- ( 토론 참여 : 100점, 미참여 : 0점 자동배점 ) -->
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
					<tr>
						<th>
							<label for="contLabel"><spring:message code='forum.label.attachFile'/><!-- 첨부파일 --></label>
						</th>
						<td class="t_left" colspan="3">
							<c:forEach var="list" items="${forumVo.fileList }">
								<button class="ui icon small button" id="file_${list.fileSn }" title="<spring:message code='forum.label.attachFile.download'/>" onclick="fileDown('${list.fileSn}', '${list.repoCd }')"><i class="ion-android-download"></i> </button><!-- 파일다운로드 -->
								<script>
									byteConvertor("${list.fileSize}", "${list.fileNm}", "file_${list.fileSn}");
								</script>
							</c:forEach>
						</td>
					</tr>
					<tr>
						<th>
							<label for="test"><spring:message code='forum.label.teamForumYn' /><!-- 팀 토론 --></label>
						</th>
						<td class="t_left" colspan="3">
							<c:choose>
								<c:when test="${forumVo.forumCtgrCd eq 'TEAM'}">
									<spring:message code='forum.common.yes'/><!-- 예 -->
									<c:choose>
										<c:when test="${forumVo.byteamDscsUseyn eq 'Y'}">
											<br/><span><spring:message code='forum.label.lrngrp'/><%--학습그룹--%> : ${forumVo.dscsGrpnm}</span>
											<br/><span><spring:message code='forum.label.lrngrp.dscs.setting'/><%--학습그룹별 토론 설정--%> : </span><spring:message code='forum.label.use.y'/><!-- 사용 -->
											<table class="table-type2">
												<colgroup>
													<col style="width : 10%">
													<col style="width : 15%">
													<col style="width : 60%">
													<col style="width : 15%">
												</colgroup>
												<thead>
												<tr>
													<th><spring:message code='forum.label.team'/></th><!-- 팀 -->
													<th colspan="2"><spring:message code='forum.label.team.ttl'/></th><!-- 부주제 -->
													<th><spring:message code='forum.label.lrngrp.mebers'/></th><!-- 학습그룹 구성원 -->
												</tr>
												</thead>
												<tbody>
												<c:forEach var="item" items="${forumVo.teamDscsList}" varStatus="status">
													<tr>
														<td rowspan="3">${item.teamnm}</td><!-- 팀 -->
														<td style="background-color:#f2f2f2;"><spring:message code='forum.label.team.ttl'/></td><!-- 부주제 -->
														<td style="text-align:left; padding-left:10px;">${item.dscsTtl}</td>
														<td rowspan="3">${item.leaderNm} 외 ${item.teamMbrCnt}</td>
													</tr>
													<tr>
														<td style="background-color:#f2f2f2;"><spring:message code='forum.label.content'/></td><!-- 내용 -->
														<td style="text-align:left; padding:10px;">
															<textarea style="width:95%; height:80px;resize: none; overflow-y: auto;" readonly>${item.dscsCts}</textarea>
														</td>
													</tr>
													<tr>
														<td style="background-color:#f2f2f2;"><spring:message code='forum.label.attachFile'/></td><!-- 첨부파일 -->
														<td style="text-align:left; padding-left:10px;">
															<a href="#">첨부파일_sample_${status.index}.pdf</a> (143.26 KB)
														</td>
													</tr>
												</c:forEach>
												</tbody>
											</table>
										</c:when>
										<c:otherwise>
											<spring:message code='forum.label.use.n'/><!-- 미사용 -->
										</c:otherwise>
									</c:choose>
								</c:when>
								<c:otherwise>
									<spring:message code='forum.common.no'/><!-- 아니오 -->
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
					<tr>
						<th>
							<label for="test"><spring:message code='forum.label.otherViewYn' /><!-- 참여글 보기 옵션 --></label>
						</th>
						<td class="t_left" colspan="3">
							<c:choose>
								<c:when test="${forumVo.otherViewYn eq 'Y'}">
									<spring:message code='forum.common.yes'/><!-- 예 -->
								</c:when>
								<c:otherwise>
									<spring:message code='forum.common.no'/><!-- 아니오 -->
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
					<tr>
						<th>
							<label for="test"><spring:message code='forum.label.aplyAsnYn' /><!-- 댓글 답변 요청 --></label>
						</th>
						<td class="t_left" colspan="3">
							<c:choose>
								<c:when test="${forumVo.aplyAsnYn eq 'Y'}">
									<spring:message code='forum.common.yes'/><!-- 예 -->
								</c:when>
								<c:otherwise>
									<spring:message code='forum.common.no'/><!-- 아니오 -->
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
					<tr>
						<th>
							<label for="test"><spring:message code='forum.label.prosCons' /><!-- 찬반토론 --></label>
						</th>
						<td class="t_left" colspan="3">
							<c:choose>
								<c:when test="${forumVo.prosConsForumCfg eq 'Y'}">
									<c:if test="${forumVo.prosConsRateOpenYn eq 'Y'}">
										<div><spring:message code='forum.label.prosConsRate'/><!-- 찬반 비율 공개 --> : <spring:message code='forum.common.yes'/><!-- 예 --></div>
									</c:if>
									<c:if test="${forumVo.regOpenYn eq 'Y'}">
										<div><spring:message code='forum.label.regOpen'/><!-- 작성자 공개 --> : <spring:message code='forum.common.yes'/><!-- 예 --></div>
									</c:if>
									<c:if test="${forumVo.multiAtclYn eq 'Y'}">
										<div><spring:message code='forum.label.multiAtcl'/><!-- 의견글 복수 등록 --> : <spring:message code='forum.common.yes'/><!-- 예 --></div>
									</c:if>
									<c:if test="${forumVo.prosConsModYn eq 'Y'}">
										<div><spring:message code='forum.label.prosConsMod'/><!-- 찬반의견 변경 --> : <spring:message code='forum.common.yes'/><!-- 예 --></div>
									</c:if>
								</c:when>
								<c:otherwise>
									<spring:message code='forum.common.no'/><!-- 아니오 -->
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</div>
