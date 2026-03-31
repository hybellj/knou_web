<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
<script type="text/javascript">
$(document).ready(function() {
	var selUser = $("a[name=ezgTargetUser].select");
	if (selUser.length == 0) {
		selUser = $("a[name=ezgTargetUser]:first");
		// 선택된 유저가 없을 때 중간 화면에 뿌려줄 토론글
		selectTeam(selUser);
	} else if (selUser.length == 1) {
		selectTeam(selUser);
	} else {
		selUser = $("a[name=ezgTargetUser].select:last");
		selectUser(selUser);
	}
});

// toggle join user
function toggleJoinUser(obj) {
	var teamCd = $(obj).attr("data-teamCd");
	var userId = $(obj).data("userid");
	
	if(userId !== undefined || userId !== "") {
		$("a[name=ezgTargetUser][data-teamCd=" + teamCd + "]").removeClass("select");
	}
	
	if ($(obj).hasClass("select")) {
		var selTeam = $("a[name=ezgTargetUser][data-teamCd=" + teamCd + "]:first");
		selectTeam(selTeam);
	} else {
		selectUser(obj);
	}
}

// 팀 선택 반전
function selectTeam(obj) {
	var childForumCd = $(obj).attr("data-forumCd");
	if (childForumCd) { $("#ezgForumCd").val(childForumCd); }
	$('.active-toggle-btn').removeClass("select");
	$(obj).addClass("select");
	var teamCd = $(obj).attr("data-teamCd");
	$("a[name=ezgTargetUser][data-teamCd=" + teamCd + "]").addClass("select");
	$("#selectedUserId").val('');
	$("#selectedUserNm").val('');
	$("#selectedStdId").val('');
	$("#selectedTeamCd").val($(obj).attr("data-teamCd"));
	getForumContsView(null, "ALL", $(obj).attr("data-teamCd"), $(obj).attr("data-teamStdIds"));
	getTargetUserInfoAndScore(obj);
	$("#forumFeedbackBlock").empty();
}

// 팀원 선택 반전
function selectUser(obj) {
	var childForumCd = $(obj).attr("data-forumCd");
	if (childForumCd) { $("#ezgForumCd").val(childForumCd); }
	$('.active-toggle-btn').removeClass("select");
	$(obj).addClass("select");
	var teamCd = $(obj).attr("data-teamCd");
	let topPos = $(obj).position().top - 50;
	let box = $("#rubric_card");
	if (topPos < 0) {
		box.scrollTop( box.scrollTop() + topPos);
	}
	else if ((topPos + $(obj).height() + 10) > box.height()) {
		box.scrollTop(box.scrollTop() + (topPos + $(obj).height() - box.height()) + 10);
	}
	
	$("a[name=ezgTargetUser][data-teamCd=" + teamCd + "]:first").addClass("select");
	$("#selectedUserId").val($(obj).attr("data-userId"));
	$("#selectedUserNm").val($(obj).attr("data-userNm"));
	$("#selectedStdId").val($(obj).attr("data-StdId"));
	$("#selectedTeamCd").val($(obj).attr("data-teamCd"));
	getForumContsView($(obj).attr("data-userId"), $(obj).attr("data-StdId"), $(obj).attr("data-teamCd"), $(obj).attr("data-teamStdIds"));
	getTargetUserInfoAndScore(obj)
}

// 제줄자의 평가점수 및 유저 정보 조회
function getTargetUserInfoAndScore(obj) {
	getTotalScoreInputView($(obj).attr("data-userId"), $(obj).attr("data-StdId"), $(obj).attr("data-teamCd"));
	getTargetUserInfoView($(obj).attr("data-userId"), $(obj).attr("data-StdId"));
	getForumFeedbackView($(obj).attr("data-userId"), $(obj).attr("data-StdId"), $(obj).attr("data-teamCd"));
}
</script>
<input type="hidden" id="selectedUserId" value="" />
<input type="hidden" id="selectedUserNm" value="" />
<input type="hidden" id="selectedStdId" value="" />
<input type="hidden" id="selectedTeamCd" value="" />
<input type="hidden" id="ezgForumCtgrCd" value="${forumVO.forumCtgrCd}" />
<c:if test="${not empty resultList}">
	<c:forEach items="${resultList }" var="item" varStatus="status">
		<a href="javascript:;" name="ezgTargetUser" onClick="selectTeam(this)" data-teamCd="${item.teamCd}" data-teamStdIds="${item.teamStdIds}" data-forumCd="${item.formCd}" class="ui grey label m0 tr active-toggle-btn flex-none ${vo.teamCd == item.teamCd?'select':''}">
			<!-- <div class="content stu_card"> -->
				<!-- <div class="text_box"> -->
					<div class="user"><span><c:out value='${item.teamNm}' /></span></div>
				<!-- </div> -->
			<!-- </div> -->
		</a>

		<c:if test="${not empty item.teamMembers}">
			<c:forEach items="${item.teamMembers }" var="team" varStatus="teamStatus">
				<a href="javascript:;" name="ezgTargetUser" onClick="toggleJoinUser(this)" data-userId="${team.userId}" data-userId="${team.userId}" data-userNm="${team.userNm}" data-StdId="${team.stdId}" data-teamCd="${item.teamCd}" data-teamStdIds="${item.teamStdIds}" data-forumCd="${item.formCd}" class="card active-toggle-btn ${team.joinStatus == 'JOIN'?'submit':''} ${vo.stdId == team.stdId?'select':''}">
					<div class="content stu_card">
					<c:if test="${item.evalYn == 'Y' || team.leaderYn == 'Y'}">
						<div class="icon_box">
							<i class="ion-android-done"></i>
						</div>
					</c:if>
						<div class="text_box">
							<div class="meta">
							<c:if test="${team.leaderYn == 'Y'}">
								<label class="ui basic mini label"><spring:message code="forum.label.team.leader" /><!-- 팀장 --></label>
							</c:if>
								<c:out value='${team.deptNm}' />
							</div>
							<div class="user">
								<c:out value='${team.userId}' />
								<span><c:out value='${team.userNm}' /></span>
							</div>
						</div>
					</div>
				</a>
			</c:forEach>
		</c:if>
	</c:forEach>
</c:if>
