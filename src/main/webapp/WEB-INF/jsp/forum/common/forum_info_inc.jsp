<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<div class="ui styled fluid accordion week_lect_list card" style="border: none;">
	<div class="title">
		<div class="title_cont">
			<div class="left_cont">
				<div class="lectTit_box">
					<p class="lect_name">${forumVo.forumTitle}</p>
					<fmt:parseDate var="startDateFmt" pattern="yyyyMMddHHmmss"
						value="${forumVo.forumStartDttm }" />
					<fmt:formatDate var="forumStartDttm"
						pattern="yyyy.MM.dd(HH:mm)" value="${startDateFmt }" />
					<fmt:parseDate var="endDateFmt" pattern="yyyyMMddHHmmss"
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
	<div class="content menu_off">
		<ul class="tbl" style="display: block !important;">
			<li>
				<dl>
					<dt>
						<label for="subjectLabel"><spring:message code='forum.label.forum.artl'/><!-- 토론 내용 --></label>
					</dt>
					<dd>
						<div class="ui segment">
							<pre>${forumVo.forumArtl}</pre>
						</div>
					</dd>
				</dl>
			</li>
			<li>
				<dl>
					<dt>
						<label for="extSendLabel"><spring:message code='forum.label.forum.date'/><!-- 토론기간 --></label>
					</dt>
					<dd>
						${forumStartDttm} ~ ${forumEndDttm}
					</dd>
					<dt>
						<label for="test"><spring:message code='forum.label.aplyAsnYn' /><!-- 댓글 답변 요청 --></label>
					</dt>
					<dd>
						<c:choose>
							<c:when test="${forumVo.aplyAsnYn eq 'Y'}">
								<spring:message code='forum.common.yes'/><!-- 예 -->
							</c:when>
							<c:otherwise>
								<spring:message code='forum.common.no'/><!-- 아니오 -->
							</c:otherwise>
						</c:choose>
					</dd>
				</dl>
			</li>
			<li>
				<dl>
					<dt>
						<label for="test"><spring:message code='forum.label.period.after' /><!-- 지각제출 --></label>
					</dt>
					<dd>
						<c:choose>
							<c:when test="${forumVo.periodAfterWriteYn eq 'Y'}">
								<spring:message code='forum.common.yes'/><!-- 예 -->
							</c:when>
							<c:otherwise>
								<spring:message code='forum.common.no'/><!-- 아니오 -->
							</c:otherwise>
						</c:choose>
					</dd>
					<dt>
						<label for="test"><spring:message code='forum.label.otherViewYn' /><!-- 본인의 토론글 등록 후 다른 참여글 보기 --></label>
					</dt>
					<dd>
						<c:choose>
							<c:when test="${forumVo.otherViewYn eq 'Y'}">
								<spring:message code='forum.common.yes'/><!-- 예 -->
							</c:when>
							<c:otherwise>
								<spring:message code='forum.common.no'/><!-- 아니오 -->
							</c:otherwise>
						</c:choose>
					</dd>
				</dl>
			</li>
			<li>
				<dl>
					<dt>
						<label for="test"><spring:message code='forum.label.evalCtgr'/><!-- 평가 방법 --></label>
					</dt>
					<dd>
						<c:choose>
							<c:when test="${forumVo.evalCtgr eq 'P'}">
								<spring:message code='forum.label.evalctgr.score'/><!-- 점수형 -->
							</c:when>
							<c:otherwise>
								<spring:message code='forum.label.evalctgr.participate'/><!-- 참여형 -->
							</c:otherwise>
						</c:choose>
					</dd>
					<dt>
						<label for="test"><spring:message code='forum.label.yesno' /><!-- 찬반토론 --></label>
					</dt>
					<dd>
						<c:choose>
							<c:when test="${forumVo.prosConsForumCfg eq 'Y'}">
						<c:if test="${forumVo.prosConsRateOpenYn eq 'Y'}">
							<div><spring:message code='forum.label.prosConsRate'/><!-- 찬반 비율 공개 --> : <spring:message code='forum.common.yes'/><!-- 예 --></div>
						</c:if>
						<c:if test="${forumVo.regOpenYn eq 'Y'}">
							<div><spring:message code='forum.label.regOpen'/><!-- 작성자 공개 --> : <spring:message code='forum.common.yes'/><!-- 예 --></div>
						</c:if>
						<c:if test="${forumVo.prosConsModYn eq 'Y'}"> 
							<div><spring:message code='forum.label.prosConsMod'/><!-- 찬반의견 변경 --> : <spring:message code='forum.common.yes'/><!-- 예 --></div>
						</c:if> 
							</c:when>
							<c:otherwise>
								<spring:message code='forum.common.no'/><!-- 아니오 -->
							</c:otherwise>
						</c:choose>
					</dd>
				</dl>
			</li>
			<li>
				<dl>
					<dt>
						<label for="test"><spring:message code='forum.label.forum.gradeRef' /><!-- 성적반영비율 --></label>
					</dt>
					<dd>
						<c:choose>
							<c:when test="${forumVo.scoreAplyYn ne 'Y' }">
								-
							</c:when>
							<c:otherwise>
								${forumVo.scoreRatio}%
							</c:otherwise>
						</c:choose>
					</dd>
					<dt>
						<label for="test"><spring:message code='forum.label.type.teamForum' /><!-- 팀토론 --></label>
					</dt>
					<dd>
						<c:choose>
							<c:when test="${forumVo.forumCtgrCd eq 'TEAM'}">
								<spring:message code='forum.common.yes'/><!-- 예 -->
							</c:when>
							<c:otherwise>
								<spring:message code='forum.common.no'/><!-- 아니오 -->
							</c:otherwise>
						</c:choose>
						<c:if test="${forumVo.forumCtgrCd eq 'TEAM'}">
							| ${forumVo.crsCreNm}<spring:message code='forum.label.team.member.info'/><!-- 반 팀구성 --> <button class="ui icon small button" onclick="teamMemberView('${forumVo.teamCtgrCd}')"><spring:message code='forum.label.team.member.view'/><!-- 팀 구성원 보기 --></button>
						</c:if>
					</dd>
				</dl>
			</li>
			<li>
				<dl>
					<dt>
						<label for="contLabel"><spring:message code='forum.label.attachFile'/><!-- 첨부파일 --></label>
					</dt>
					<dd>
						<c:forEach var="list" items="${forumVo.fileList }">
							<button class="ui icon small button" id="file_${list.fileSn }" title="<spring:message code='forum.label.attachFile.download'/>" onclick="fileDown('${list.fileSn}', '${list.repoCd }')"><i class="ion-android-download"></i> </button><!-- 파일다운로드 -->
							<script>
								byteConvertor("${list.fileSize}", "${list.fileNm}", "file_${list.fileSn}");
							</script>
						</c:forEach>
					</dd>
					<dt>
						<label for="test"><spring:message code='forum.label.mut.eval' /><!-- 상호평가 --></label>
					</dt>
					<dd>
						<c:choose>
							<c:when test="${forumVo.mutEvalYn eq 'Y' }">
						<fmt:parseDate var="evalStartDateFmt" pattern="yyyyMMddHHmmss" value="${forumVo.evalStartDttm}" />
						<fmt:formatDate var="evalStartDttm" pattern="yyyy.MM.dd(HH:mm)" value="${evalStartDateFmt}" />
						<fmt:parseDate var="evalEndDateFmt" pattern="yyyyMMddHHmmss" value="${forumVo.evalEndDttm}" />
						<fmt:formatDate var="evalEndDttm" pattern="yyyy.MM.dd(HH:mm)" value="${evalEndDateFmt}" />
						<div>
						<spring:message code='forum.label.date'/><!-- 기간 --> : ${evalStartDttm} ~ ${evalEndDttm}
						</div>
						<div>
						<spring:message code='forum.label.result.open'/><!-- 결과공개 --> : 
							<c:choose>
								<c:when test="${forumVo.evalRsltOpenYn eq 'Y'}">
									<spring:message code='forum.common.yes'/><!-- 예 -->
								</c:when>
								<c:otherwise>
									<spring:message code='forum.common.no'/><!-- 아니오 -->
								</c:otherwise>
							</c:choose>
						</div> 
							</c:when>
							<c:otherwise>
								<spring:message code='forum.common.no'/><!-- 아니오 -->
							</c:otherwise>
						</c:choose>
					</dd>
				</dl>
			</li>
		</ul>
	</div>
</div>