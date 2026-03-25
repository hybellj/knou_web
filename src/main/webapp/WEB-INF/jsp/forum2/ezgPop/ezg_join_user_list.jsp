<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
<script type="text/javascript">
$(document).ready(function() {
	var selUser = $("a[name=ezgTargetUser].select");
	if (selUser.length == 0) {
		// 선택된 유저가 없을 때 중간 화면에 뿌려줄 토론글
//		getForumContsView("", "ALL");
		displayNoselectuserBlock(true);
	} else {
		getForumContsView($(selUser).attr("data-userId"), $(selUser).attr("data-stdId"));
	}

	$("#selectedUserId").val($(selUser).attr("data-userId"));
	$("#selectedUserNm").val($(selUser).attr("data-userNm"));
	$("#selectedStdId").val($(selUser).attr("data-stdId"));
	getTargetUserInfoAndScore(selUser);
});

// toggle join user
function toggleJoinUser(obj) {
	if ($(obj).hasClass("select")) {
		$(obj).removeClass("select");
		$("#selectedUserId").val('');
		$("#selectedUserNm").val('');
		$("#selectedStdId").val('');
		getForumContsView("", "");
		getTargetUserInfoAndScore(null);
		displayNoselectuserBlock(true);
		$("#cntFdbk").text("0<spring:message code='forum.label.cnt.feedback'/>"); //개의 피드백 
	} else {
		$('.active-toggle-btn').removeClass("select");
		$(obj).addClass("select");
		$("#selectedUserId").val($(obj).attr("data-userId"));
		$("#selectedUserNm").val($(obj).attr("data-userNm"));
		$("#selectedStdId").val($(obj).attr("data-stdId"));
		
		let topPos = $(obj).position().top - 50;
		let box = $("#rubric_card");
		if (topPos < 0) {
			box.scrollTop( box.scrollTop() + topPos);
		}
		else if ((topPos + $(obj).height() + 10) > box.height()) {
			box.scrollTop(box.scrollTop() + (topPos + $(obj).height() - box.height()) + 10);
		}
		
		getForumContsView($(obj).attr("data-userId"), $(obj).attr("data-stdId"));
		getTargetUserInfoAndScore(obj);
		displayNoselectuserBlock(false);
	}
	
	$('#fileUpDiv').css("visibility","hidden");
	var fileUploader = dx5.get("fileUploader");
	if (fileUploader != null && fileUploader.getFileCount() > 0) {
		fileUploader.removeAll();
	}
}

// 제줄자의 평가점수 및 유저 정보 조회
function getTargetUserInfoAndScore(obj) {
	getTotalScoreInputView($(obj).attr("data-userId"), $(obj).attr("data-stdId"));
	getTargetUserInfoView($(obj).attr("data-userId"), $(obj).attr("data-stdId"));
	getForumFeedbackView($(obj).attr("data-userId"), $(obj).attr("data-stdId"));
}
</script>

<input type="hidden" id="selectedUserId" value="" />
<input type="hidden" id="selectedUserNm" value="" />
<input type="hidden" id="selectedStdId" value="" />
<input type="hidden" id="ezgForumCtgrCd" value="${forumVO.forumCtgrCd}" />

<c:if test="${not empty resultList}">
	<c:set var="stdNos" value="" />
	<!-- <div id="dot_list"> -->
	<c:forEach items="${resultList }" var="item" varStatus="status">
		<c:if test="${status.index eq '0'}">
			<c:set var="stdNos" value="${item.userId}" />
		</c:if>
		<c:if test="${status.index ne '0'}">
			<c:set var="stdNos" value="${stdNos},${item.userId}" />
		</c:if>
		<a href="javascript:;" name="ezgTargetUser" onClick="toggleJoinUser(this)" data-userId="${item.userId}" data-userId="${item.userId}" data-userNm="${item.userNm}" data-stdId="${item.stdId}" class="card active-toggle-btn ${item.joinStatus == 'JOIN'?'submit':''} ${vo.stdId == item.stdId?'select':''}">
			<div class="content stu_card">
			<c:if test="${item.evalYn == 'Y'}">
				<div class="icon_box">
					<i class="ion-android-done"></i>
				</div>
			</c:if>
				<div class="text_box">
					<div class="meta"><c:out value='${item.deptNm}' /></div>
					<div class="user"><c:out value='${item.userNm}' /><span><c:out value='${item.userId}' /></span></div>
				</div>
			</div>
		</a>
	</c:forEach>
	<!-- </div> -->
	<input type="hidden" id="stdNos" value="${stdNos}">
</c:if>
