<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/forum/common/forum_common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />

<script type="text/javascript">
$(document).ready(function() {
});

function forumView(tab) {
	var urlMap = {
		"0" : "/forum/forumLect/Form/infoManage.do",	// 토론정보
		"1" : "/forum/forumLect/Form/bbsManage.do",		// 토론방
		"2" : "/forum/forumLect/Form/scoreManage.do"	// 토론평가
	};

	var url  = urlMap[tab];
	var form = $("<form></form>");
	form.attr("method", "POST");
	form.attr("name", "manageForm");
	form.attr("action", url);
	form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: '<c:out value="${forumVo.crsCreCd}" />'}));
	form.append($('<input/>', {type: 'hidden', name: 'forumCd',  value: '<c:out value="${forumVo.forumCd}" />'}));
	form.appendTo("body");
	form.submit();
}

// 목록
function viewForumList() {
	var url  = "/forum/forumLect/Form/forumList.do";
	var form = $("<form></form>");
	form.attr("method", "POST");
	form.attr("name", "listForm");
	form.attr("action", url);
	form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: "${forumVo.crsCreCd}"}));
	form.appendTo("body");
	form.submit();
}

// 토론 수정
function editForum(forumCd,forumStartDttm) {

	/*
		var date = new Date();
		var year = date.getFullYear();
		var month = ("0" + (1 + date.getMonth())).slice(-2);
		var day = ("0" + date.getDate()).slice(-2);
		var hours = ("0" + date.getHours()).slice(-2);
		var minutes = ("0" + date.getMinutes()).slice(-2);
		var seconds = ("0" + date.getSeconds()).slice(-2);
	
		var today = year + month + day + hours + minutes + seconds;
	
		//과제가 시작했으면 수정 X
		if(forumStartDttm <= today ){
			alert("<spring:message code='forum.alert.ontask.not.modify'/>"); // 진행중인 토론은 수정이 불가능합니다.
			return false;
		}else{
	*/

	var url  = "/forum/forumLect/Form/editForumForm.do";
	var form = $("<form></form>");
	form.attr("method", "POST");
	form.attr("name", "editForm");
	form.attr("action", url);
	form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: '<c:out value="${forumVo.crsCreCd}" />'}));
	form.append($('<input/>', {type: 'hidden', name: 'forumCd',   value: '<c:out value="${forumVo.forumCd}" />'}));
	form.appendTo("body");
	form.submit();
	
	/*
		}
	*/
}

//토론삭제
function delForum(forumCd) {
	var result = confirm("<spring:message code='forum.alert.confirm.delete'/>"); // 정말 토론을 삭제 하시겠습니까?

	if(!result){return false;}

	var form = $("<form></form>");
	form.attr("method", "POST");
	form.attr("name", "forumForm");
	form.attr("action", "/forum/forumLect/Form/delForum.do");
	form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: '<c:out value="${forumVo.crsCreCd}" />'}));
	form.append($('<input/>', {type: 'hidden', name: 'forumCd', value: forumCd}));
	form.appendTo("body");
	form.submit();
}

// 팀 구성원 보기
function teamMemberView(teamCtgrCd) {
	$("#teamCtgrCd").val(teamCtgrCd);
	$("#teamMemberForm").attr("target", "teamMemberIfm");
	$("#teamMemberForm").attr("action", "/forum/forumLect/teamMemberList.do");
	$("#teamMemberForm").submit();
	$('#teamMember').modal('show');
}
</script>

<body class="<%=SessionInfo.getThemeMode(request)%>">
<form id="teamMemberForm" name="teamMemberForm" action="" method="POST">
<input type="hidden" name="teamCtgrCd" id="teamCtgrCd">
</form>
    <div id="wrap" class="pusher">
        <!-- class_top 인클루드  -->
        <%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>

        <div id="container">
            <%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>
            <!-- 본문 content 부분 -->
            <div class="content stu_section">
		        <%@ include file="/WEB-INF/jsp/common/class_location.jsp" %>
		        <%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>
		        
                <div class="ui form">
                    <div class="layout2">

                        <div id="info-item-box">
                            <h2 class="page-title flex-item flex-wrap gap4 columngap16">
                               <spring:message code='forum.label.forum'/><!-- 토론 -->
                                <div class="ui breadcrumb small">
                                    <small class="section"><spring:message code='forum.label.forum.info.manage'/><!-- 토론정보 및 관리 --></small>
                                    <i class="right chevron icon divider"></i>
                                    <small class="section"><spring:message code='forum.label.forum.info'/><!-- 토론정보 --></small>
                                </div>
                            </h2>
                            <div class="button-area">
			                    <a href="javascript:void(0)" class="ui basic button" onclick="editForum('${forumVo.forumCd}','${forumVo.forumStartDttm}')"><spring:message code='forum.button.mod'/><!-- 수정 --></a>
								<a href="javascript:void(0)" class="ui basic button" onclick="delForum('${forumVo.forumCd}');"><spring:message code='forum.button.del'/><!-- 삭제 --></a>
								<a href="javascript:void(0)" class="ui basic button" onclick="viewForumList()"><spring:message code='forum.label.list'/><!-- 목록 --></a>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col">

                                <div class="listTab">
                                    <ul class="">  
										<li class="select mw120"><a href="javascript:void(0)" onclick="forumView(0)"><spring:message code='forum.label.forum.info'/><!-- 토론정보 --></a></li>
										<li class="mw120"><a  href="javascript:void(0)" onclick="forumView(1)"><spring:message code='forum.label.forum.bbs'/><!-- 토론방 --></a></li>
										<li class="mw120"><a href="javascript:void(0)" onclick="forumView(2)"><spring:message code='forum.label.score.eval'/><!-- 성적평가 --></a></li>
                                    </ul>
                                </div>
                                
                                
                <div class="ui segment">
                    <div>



						<div class="ui grid stretched">
							<div class="sixteen wide tablet eight wide computer column">
								<div class="ui segment">
									<ul class="tbl-simple">
										<li>
											<dl>
												<dt>
													<label for="taskTypeLabel"><spring:message code='forum.label.forum.title'/><!-- 토론명 --></label>
												</dt>
												<dd>${forumVo.forumTitle}</dd>
											</dl>
										</li>
										<li>
											<dl>
												<dt>
													<label for="subjectLabel"><spring:message code='forum.label.forum.artl'/><!-- 토론 내용 --></label>
												</dt>
												<dd></dd>
											</dl>
											<div class="ui segment">
												<pre>${forumVo.forumArtl}</pre>
											</div>
										</li>
										<li>
											<fmt:parseDate var="startDateFmt" pattern="yyyyMMddHHmmss" value="${forumVo.forumStartDttm }" />
											<fmt:formatDate var="forumStartDttm" pattern="yyyy.MM.dd(HH:mm)" value="${startDateFmt }" />
											<fmt:parseDate var="endDateFmt" pattern="yyyyMMddHHmmss" value="${forumVo.forumEndDttm }" />
											<fmt:formatDate var="forumEndDttm" pattern="yyyy.MM.dd(HH:mm)" value="${endDateFmt }" />
											<dl>
												<dt>
													<label for="dateLabel"><spring:message code='forum.label.forum.date'/><!-- 토론기간 --></label>
												</dt>
												<dd>${forumStartDttm} ~ ${forumEndDttm}</dd>
											</dl>
											<dl>
												<dt>
													<label for="teamLabel"><spring:message code='forum.label.evalCtgr'/><!-- 평가방법 --></label>
												</dt>
												<dd>
												<c:choose>
													<c:when test="${forumVo.evalCtgr eq 'P'}">
														<spring:message code='forum.label.evalctgr.score'/><!-- 점수형 -->
													</c:when>
													<c:otherwise>
														<spring:message code='forum.label.evalctgr.rubric'/><!-- 루브릭 -->(${forumVo.evalTitle})
													</c:otherwise>
												</c:choose>
												</dd>
											</dl>
											<dl>
												<dt>
													<label for="teamLabel"><spring:message code='forum.label.scoreAplyYn'/><!-- 성적 반영 여부 --></label>
												</dt>
												<dd>
												<c:choose>
													<c:when test="${forumVo.scoreAplyYn eq 'Y'}">
														<spring:message code='forum.common.yes'/><!-- 예 -->
													</c:when>
													<c:otherwise>
														<spring:message code='forum.common.no'/><!-- 아니오 -->
													</c:otherwise>
												</c:choose>
												</dd>
											</dl>
											<dl>
												<dt>
													<label for="stypeLabel"><spring:message code='forum.label.aplyAsnYn'/></label><!-- 댓글 답변 요청 -->
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
											</dl>
											<dl>
												<dt>
													<label for="contLabel" class="fcBlue"><spring:message code='forum.label.teamForumYn'/><!-- 팀 토론 여부 --></label>
												</dt>
												<dd class="fcBlue">
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
									</ul>
								</div>
							</div>
							<div class="sixteen wide tablet eight wide computer column">
								<div class="ui segment">
									<ul class="tbl-simple">
										<li>
											<dl>
												<dt>
													<label for="taskTypeLabel"><spring:message code='forum.label.add.option'/><!-- 옵션 --></label>
												</dt>
												<dd></dd>
											</dl>
										</li>
									</ul>
									<div class="ui segment">
										<ul class="tbl-simple">
											<li>
												<ul class="num-chk d-inline-block">
													<li><a class="${forumVo.scoreOpenYn eq 'Y' ? 'bcGreen' : 'bcLgrey'}"></a></li>
												</ul>
												<label for="taskTypeLabel"><spring:message code='forum.label.scoreOpen'/><!-- 성적 공개 --></label> : 
												<c:choose>
													<c:when test="${forumVo.scoreOpenYn eq 'Y'}">
														<spring:message code='forum.common.yes'/><!-- 예 -->
													</c:when>
													<c:otherwise>
														<spring:message code='forum.common.no'/><!-- 아니오 -->
													</c:otherwise>
												</c:choose>
											</li>
										</ul>
									</div>
									<div class="ui segment">
										<ul class="tbl-simple">
											<li>
												<ul class="num-chk d-inline-block">
													<li><a class="${forumVo.aplyAsnYn eq 'Y' ? 'bcGreen' : 'bcLgrey'}"></a></li>
												</ul>
												<label for="taskTypeLabel"><spring:message code='forum.label.aplyAsnYn'/><!-- 댓글 답변 요청 --></label> : 
												<c:choose>
													<c:when test="${forumVo.aplyAsnYn eq 'Y'}">
														<spring:message code='forum.common.yes'/><!-- 예 -->
													</c:when>
													<c:otherwise>
														<spring:message code='forum.common.no'/><!-- 아니오 -->
													</c:otherwise>
												</c:choose>
											</li>
										</ul>
									</div>
									<div class="ui segment">
										<ul class="tbl-simple">
											<li>
												<ul class="num-chk d-inline-block">
													<li><a class="${forumVo.prosConsForumCfg eq 'Y' ? 'bcGreen' : 'bcLgrey'}"></a></li>
												</ul>
												<label for="taskTypeLabel"><spring:message code='forum.label.prosCons'/><!-- 찬반 토론으로 설정 --> </label> : 
												<c:choose>
													<c:when test="${forumVo.prosConsForumCfg eq 'Y'}">
														<spring:message code='forum.common.yes'/><!-- 예 -->
													</c:when>
													<c:otherwise>
														<spring:message code='forum.common.no'/><!-- 아니오 -->
													</c:otherwise>
												</c:choose>
											</li>
											<li class="ml20">
												<dl>
													<dt>
														<label for="taskTypeLabel"><spring:message code='forum.label.prosConsRate'/><!-- 찬반 비율 공개  --></label>
													</dt>
													<dd>
													<c:choose>
														<c:when test="${forumVo.prosConsRateOpenYn eq 'Y'}">
															<spring:message code='forum.label.open.y'/><!-- 공개 -->
														</c:when>
														<c:otherwise>
															<spring:message code='forum.label.open.n'/><!-- 비공개 -->
														</c:otherwise>
													</c:choose>
													</dd>
												</dl>
												<dl>
													<dt>
														<label for="taskTypeLabel"><spring:message code='forum.label.regOpen'/><!-- 작성자 공개 --></label>
													</dt>
													<dd>
													<c:choose>
														<c:when test="${forumVo.regOpenYn eq 'Y'}">
															<spring:message code='forum.label.open.y'/><!-- 공개 -->
														</c:when>
														<c:otherwise>
															<spring:message code='forum.label.open.n'/><!-- 비공개 -->
														</c:otherwise>
													</c:choose>
													</dd>
												</dl>
												<dl>
													<dt>
														<label for="taskTypeLabel"><spring:message code='forum.label.multiAtcl'/><!-- 의견글 복수 등록 --></label>
													</dt>
													<dd>
													<c:choose>
														<c:when test="${forumVo.multiAtclYn eq 'Y'}">
															<spring:message code='forum.label.poss'/><!-- 가능 -->
														</c:when>
														<c:otherwise>
															<spring:message code='forum.label.imposs'/><!-- 불가능 -->
														</c:otherwise>
													</c:choose>
													</dd>
												</dl>
												<dl>
													<dt>
														<label for="taskTypeLabel"><spring:message code='forum.label.prosConsMod'/><!-- 찬반의견 변경 --></label>
													</dt>
													<dd>
													<c:choose>
														<c:when test="${forumVo.prosConsModYn eq 'Y'}">
															<spring:message code='forum.label.poss'/><!-- 가능 -->
														</c:when>
														<c:otherwise>
															<spring:message code='forum.label.imposs'/><!-- 불가능 -->
														</c:otherwise>
													</c:choose>
													</dd>
												</dl>
											</li>
										</ul>
									</div>
									<div class="ui segment">
										<ul class="tbl-simple">
											<li>
												<ul class="num-chk d-inline-block">
													<li><a class="${forumVo.mutEvalYn eq 'Y' ? 'bcGreen' : 'bcLgrey' }"></a></li>
												</ul>
												<label for="taskTypeLabel"><spring:message code='forum.label.mutEvalYn'/><!-- 상호평가 사용 --></label> : 
												<c:choose>
													<c:when test="${forumVo.mutEvalYn eq 'Y'}">
														<spring:message code='forum.common.yes'/><!-- 예 -->
													</c:when>
													<c:otherwise>
														<spring:message code='forum.common.no'/><!-- 아니오 -->
													</c:otherwise>
												</c:choose>
											</li>
										</ul>
									</div>
								</div>
							</div>
						</div>
					</div>
                </div>
                            </div>
                        </div>
                    </div>
                </div>
<!-- 팀 구성원 보기 모달 -->
<div class="modal fade" id="teamMember" tabindex="-1" role="dialog" aria-labelledby="<spring:message code='forum.label.team.member.view'/>" aria-hidden="true"><!-- 팀 구성원 보기 -->
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code='forum.button.close'/>"><!-- 닫기 -->
					<span aria-hidden="true">&times;</span>
				</button>
				<h4 class="modal-title"><spring:message code='forum.label.team.member.view'/><!-- 팀 구성원 보기 --></h4>
			</div>
			<div class="modal-body">
				<iframe src="" id="teamMemberIfm" name="teamMemberIfm" width="100%" scrolling="no"></iframe>
			</div>
		</div>
	</div>
</div>
<!-- 팀 구성원 보기 모달 -->
<script>
$('iframe').iFrameResize();
window.closeModal = function(){
	$('.modal').modal('hide');
};
</script>

            </div>
        </div>
        <!-- //본문 content 부분 -->
    </div>
    <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
    </div>
</body>
</html>