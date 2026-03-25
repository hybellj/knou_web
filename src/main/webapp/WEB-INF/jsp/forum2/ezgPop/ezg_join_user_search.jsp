<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
<script type="text/javascript">
$(document).ready(function() {
});

// 대상 사용자 또는 팀 정열 순서 변경 후 리스트 조회
function sortAndFilterJoinUser() {
	if (typeof getJoinUserOrTeamList == 'function') {
		getJoinUserOrTeamList();
		$("#forumContBlock").empty();
	}
}
</script>
	<select class="ui fluid dropdown" id="ezgSearchSort" onChange="sortAndFilterJoinUser()">
		<option value=""><spring:message code="forum_ezg.label.sel_order" /></option><!-- 정렬 선택 -->
		<option value="USER_ID"><spring:message code="forum_ezg.label.userid_order" /></option><!-- 학번순 -->
		<option value="USER_NM"><spring:message code="forum_ezg.label.nm_order" /></option><!-- 이름순 -->
		<option value="SUBMIT_DT"><spring:message code="forum_ezg.label.submit_order" /></option><!-- 제출자순 -->
	</select>
	<select class="ui fluid dropdown" id="ezgSearchKey" onChange="sortAndFilterJoinUser()">
		<option value="SEL_ALL"><spring:message code="forum_ezg.label.sel_filter" /></option><!-- 필터 선택 -->
		<option value="JOIN"><spring:message code="forum.label.join" /></option><!-- 참여 -->
		<option value="AFTER"><spring:message code="forum.label.after.join" /></option><!-- 지각참여 -->
		<option value="NOTJOIN"><spring:message code="forum.label.not.join" /></option><!-- 미참여 -->
	</select>
