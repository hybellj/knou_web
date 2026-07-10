<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<script type="text/javascript">
$(document).ready(function() {
	var selUser = $("[name=ezgTargetUser].card.select:last");
	if (selUser.length > 0) {
		selectUser(selUser);
		return;
	}

	var selTeam = $("[name=ezgTargetUser].temaTitle.select:first");
	if (selTeam.length == 0) {
		selTeam = $("[name=ezgTargetUser].temaTitle:first");
	}

	if (selTeam.length > 0) {
		selectTeam(selTeam);
	} else {
		displayNoselectuserBlock(true);
		getTargetUserInfoAndScore(null);
	}
});

// 팀토론 학습자 선택 상태를 전환한다.
function toggleJoinUser(obj) {
	var teamId = $(obj).attr("data-team-id");
	var userId = $(obj).data("userid");
	
	if(userId !== undefined || userId !== "") {
		$("[name=ezgTargetUser][data-team-id=" + teamId + "]").removeClass("select active");
	}
	
	if ($(obj).hasClass("select")) {
		var selTeam = $("[name=ezgTargetUser][data-team-id=" + teamId + "]:first");
		selectTeam(selTeam);
	} else {
		selectUser(obj);
	}
}

// 팀 선택 반전
function selectTeam(obj) {
	if(!obj || $(obj).length == 0) {
		displayNoselectuserBlock(true);
		return;
	}

	var childDscsId = $(obj).attr("data-dscs-id");
	if (childDscsId) { $("#ezgDscsId").val(childDscsId); }
	$('.active-toggle-btn').removeClass("select active");
	$(obj).addClass("select active");
	var teamId = $(obj).attr("data-team-id");
	$("[name=ezgTargetUser][data-team-id=" + teamId + "]").addClass("select active");
	$("#selectedUserId").val('');
	$("#selectedUserNm").val('');
	$("#selectedStdId").val('');
	$("#selectedTeamId").val($(obj).attr("data-team-id"));
	getDscsContsView(null, "ALL", $(obj).attr("data-team-id"), $(obj).attr("data-teamStdIds"));
	getTargetUserInfoAndScore(obj);
}

// 팀원 선택 반전
function selectUser(obj) {
	if(!obj || $(obj).length == 0) {
		displayNoselectuserBlock(true);
		return;
	}

	var childDscsId = $(obj).attr("data-dscs-id");
	if (childDscsId) { $("#ezgDscsId").val(childDscsId); }
	$('.active-toggle-btn').removeClass("select active");
	$(obj).addClass("select active");
	var teamId = $(obj).attr("data-team-id");
	let topPos = $(obj).position().top - 50;
	let box = $("#rubric_card");
	if (topPos < 0) {
		box.scrollTop( box.scrollTop() + topPos);
	}
	else if ((topPos + $(obj).height() + 10) > box.height()) {
		box.scrollTop(box.scrollTop() + (topPos + $(obj).height() - box.height()) + 10);
	}
	
	$("[name=ezgTargetUser][data-team-id=" + teamId + "]:first").addClass("select active");
	$("#selectedUserId").val($(obj).attr("data-userId"));
	$("#selectedUserNm").val($(obj).attr("data-userNm"));
	$("#selectedStdId").val($(obj).attr("data-stdId"));
	$("#selectedTeamId").val($(obj).attr("data-team-id"));
	// 개별 학습자 선택 시 팀원 목록(stdList)을 함께 전달하지 않는다.
	getDscsContsView($(obj).attr("data-userId"), $(obj).attr("data-stdId"), $(obj).attr("data-team-id"), "");
	getTargetUserInfoAndScore(obj)
}

// 제출자의 평가점수 및 유저 정보 조회
function getTargetUserInfoAndScore(obj) {
	getScoreInputView($(obj).attr("data-userId"), $(obj).attr("data-stdId"), $(obj).attr("data-team-id"));
	getDscsFeedbackView($(obj).attr("data-userId"), $(obj).attr("data-stdId"), $(obj).attr("data-team-id"));
}
</script>
<input type="hidden" id="selectedUserId" value="" />
<input type="hidden" id="selectedUserNm" value="" />
<input type="hidden" id="selectedStdId" value="" />
<input type="hidden" id="selectedTeamId" value="" />
<c:if test="${not empty resultList}">
	<c:forEach items="${resultList }" var="item" varStatus="status">
		<div class="stu_list">
		<p name="ezgTargetUser" onClick="selectTeam(this)" data-team-id="${item.teamId}" data-teamStdIds="${item.teamStdIds}" data-dscs-id="${item.dscsId}" class="temaTitle active-toggle-btn ${dscsVO.teamId == item.teamId?'select active':''}">
			<c:out value='${item.teamnm}' />
		</p>

		<c:if test="${not empty item.teamMembers}">
			<ul>
			<c:forEach items="${item.teamMembers }" var="team" varStatus="teamStatus">
				<li name="ezgTargetUser" onClick="toggleJoinUser(this)" data-userId="${team.userId}" data-userNm="${team.userNm}" data-stdId="${team.stdId}" data-team-id="${item.teamId}" data-teamStdIds="${item.teamStdIds}" data-dscs-id="${item.dscsId}" class="card active-toggle-btn ${team.joinStatus == 'JOIN'?'submit':''} ${dscsVO.stdId == team.stdId?'select active':''}">
					<%-- 평가완료 아이콘 --%>
					<div class="icon_box">
						<c:if test="${team.evlyn == 'Y'}">
							<span><i class="xi-check icon"></i></span>
						</c:if>
					</div>
					<span>
						<c:if test="${team.leaderYn == 'Y'}">
							<label class="ui basic mini label"><spring:message code="forum.label.team.leader" /></label><!-- 팀장 -->
						</c:if>
						<c:out value='${team.deptNm}' />
					</span>
					<p><c:out value='${team.userNm}' /><c:if test="${not empty team.stdntNo}"><span>(<c:out value='${team.stdntNo}' />)</span></c:if></p>
				</li>
			</c:forEach>
			</ul>
		</c:if>
		</div>
	</c:forEach>
</c:if>
