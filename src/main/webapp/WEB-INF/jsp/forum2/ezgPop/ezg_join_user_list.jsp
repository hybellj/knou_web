<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<script type="text/javascript">
$(document).ready(function() {
	var selUser = $("[name=ezgTargetUser].select");
	if (selUser.length == 0) {
		selUser = $("[name=ezgTargetUser].card:first");
	} else {
		selUser = selUser.first();
	}

	if(selUser.length > 0) {
		selectUser(selUser);
	} else {
		displayNoselectuserBlock(true);
		getTargetUserInfoAndScore(null);
	}
});

// 개인 토론 학습자 선택 상태를 전환한다.
function toggleJoinUser(obj) {
	if ($(obj).hasClass("select")) {
		$(obj).removeClass("select active");
		$("#selectedUserId").val('');
		$("#selectedUserNm").val('');
		$("#selectedStdId").val('');
		getDscsContsView("", "");
		getTargetUserInfoAndScore(null);
		displayNoselectuserBlock(true);
		$("#cntFdbk").text("0<spring:message code='forum.label.cnt.feedback'/>"); //개의 피드백 
	} else {
		selectUser(obj);
	}
	
	$('#fileUpDiv').css("visibility","hidden");
	var fileUploader = dx5.get("fileUploader");
	if (fileUploader != null && fileUploader.getFileCount() > 0) {
		fileUploader.removeAll();
	}
}

// 개인 토론 학습자를 선택한다.
function selectUser(obj) {
	if(!obj || $(obj).length == 0) {
		displayNoselectuserBlock(true);
		return;
	}

	$('.active-toggle-btn').removeClass("select active");
	$(obj).addClass("select active");
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

	getDscsContsView($(obj).attr("data-userId"), $(obj).attr("data-stdId"));
	getTargetUserInfoAndScore(obj);
	displayNoselectuserBlock(false);
}

// 제줄자의 평가점수 및 유저 정보 조회
function getTargetUserInfoAndScore(obj) {
	getScoreInputView($(obj).attr("data-userId"), $(obj).attr("data-stdId"));
	getDscsFeedbackView($(obj).attr("data-userId"), $(obj).attr("data-stdId"));
}
</script>

<input type="hidden" id="selectedUserId" value="" />
<input type="hidden" id="selectedUserNm" value="" />
<input type="hidden" id="selectedStdId" value="" />

<c:if test="${not empty resultList}">
	<c:set var="stdNos" value="" />
	<div class="stu_list">
		<ul>
			<c:forEach items="${resultList }" var="item" varStatus="status">
				<c:if test="${status.index eq '0'}">
					<c:set var="stdIds" value="${item.userId}" />
				</c:if>
				<c:if test="${status.index ne '0'}">
					<c:set var="stdIds" value="${stdIds},${item.userId}" />
				</c:if>
				<li name="ezgTargetUser" onClick="toggleJoinUser(this)" data-userId="${item.userId}" data-userNm="${item.userNm}" data-stdId="${item.stdId}" class="card active-toggle-btn ${item.joinStatus == 'JOIN'?'submit':''} ${dscsVO.stdId == item.stdId?'select active':''}">
					<%-- 평가완료 아이콘 --%>
					<div class="icon_box">
						<c:if test="${item.evlyn == 'Y'}">
							<span><i class="xi-check icon"></i></span>
						</c:if>
					</div>
					<span><c:out value='${item.deptnm}' /></span>
					<p><c:out value='${item.userNm}' /><c:if test="${not empty item.stdntNo}"><span>(<c:out value='${item.stdntNo}' />)</span></c:if></p>
				</li>
			</c:forEach>
		</ul>
	</div>
	<input type="hidden" id="stdIds" value="${stdIds}">
</c:if>
