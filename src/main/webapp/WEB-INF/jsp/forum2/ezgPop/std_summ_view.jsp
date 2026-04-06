<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
<script type="text/javascript">
$(document).ready(function() {
	$(".ui.dropdown").off("click");
});

// 이전 버튼
function btnPrev() {
	var stdId = $("a[name=ezgTargetUser].select").last().prev().data("stdno");
	var teamId = $("a[name=ezgTargetUser].select").first().prev().data("team-id");
	if(stdId === undefined) {
		var stdId = $("a[name=ezgTargetUser].select").last().prev().prev().data("stdno");
		$("a[data-stdId="+ stdId+"]").click();
	} else {
		$("a[data-stdId="+ stdId+"]").click();
	}
	stdId = "";
};

// 다음 버튼
function btnNext() {
	var stdId = $("a[name=ezgTargetUser].select").last().next().data("stdno");
	var teamId = $("a[name=ezgTargetUser].select").last().next().data("team-id");
	if(stdId === undefined) {
		var stdId = $("a[name=ezgTargetUser].select").last().next().next().data("stdno");
		$("a[data-stdId="+ stdId+"]").click();
	} else {
		$("a[data-stdId="+ stdId+"]").click();
	}
	stdId = "";
};

//메세지 보내기
function sendMsg() {
	var rcvUserInfoStr = "";
	
	rcvUserInfoStr += "${userVO.userId}";
	rcvUserInfoStr += ";" + "${userVO.userNm}"; 
	rcvUserInfoStr += ";" + "${userVO.mobileNo}"; 
	rcvUserInfoStr += ";" + "${userVO.email}"; 
	
	window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");

	var form = $("<form></form>");
//	form.attr("method", "POST");
	form.attr("name", "manageForm");
	form.attr("action", "<%=CommConst.SYSMSG_URL_SEND%>");
	form.attr("target", "msgWindow");
	form.append($('<input/>', {type: 'hidden', name: 'alarmType', value: 'S'})); // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
	form.append($('<input/>', {type: 'hidden', name: 'rcvUserInfoStr',  value: rcvUserInfoStr})); //보내는사람 정보
	form.appendTo("body");
	form.submit();
}
</script>

<form id="stdForm" name="stdForm" action="" method="POST">
	<input type="hidden" name="receiverUserIds" value=""/>
</form>

<c:if test="${vo.searchMenu != 'MutEval' && vo.searchMenu != 'EZG'}">
<%-- <div class="ui attached message">
	<c:if test="${empty vo.searchMenu || vo.searchMenu != 'EZG'}">
	<div class="header"><spring:message code="forum_ezg.label.stu.info"/></div> <!-- 학습자 정보 -->
	</c:if>
	<c:if test="${not empty vo.searchMenu && vo.searchMenu == 'EZG'}">
	<div class="header"><spring:message code="forum_ezg.label.send.user.info"/></div> <!-- 제출자 정보 -->
	</c:if>
</div> --%>
<div class="ui bottom attached segment">
	<div class="field-list mo-100">
</c:if>

		<div class="mb10 flex-item btn_list">
			<button type="button" class="ui basic small button boxShadowNone mra" onclick="btnPrev();"><i class="angle left icon"></i><spring:message code='forum.common.prev'/><!-- 이전 --></button>
			<button type="button" class="ui basic small button boxShadowNone mla" onclick="btnNext();"><spring:message code='forum.common.next'/><!-- 다음 --><i class="angle right icon"></i></button>
		</div>
		<c:if test="${vo.searchMenu != 'EZG' }">
		<div class="fields">
		</c:if>
			<c:if test="${empty vo.searchMenu || vo.searchMenu != 'EZG'}">
			<div class="four wide field flex-item-center mo-none">
				<div class="initial-img lg c-${vo.searchKey }">${userVO.userName }</div>
			</div>
			</c:if>
			<%-- <div class="twelve wide field">
				<div class="fields">
					<div class="five wide field"><label><spring:message code="forum.label.user_id"/></label></div> <!-- 아이디 -->
					<div class="wide field">${userVO.userId }
						<c:if test="${MSG_NOTE eq 'Y' && vo.searchText != 'Modal' && vo.searchMenu != 'EZG'}">
						<button type="button" class="ui circular basic icon button ml5 mt-5" onclick="sendMsg();return false;"><i class="envelope open outline icon"></i></button>
						</c:if>
					</div>
				</div>
				<div class="fields">
					<div class="five wide field"><label><spring:message code="forum.label.user_nm"/></label></div> <!-- 이름 -->
					<div class="eleven wide field">${userVO.userNm }</div>
				</div>
				<div class="fields">
					<div class="five wide field"><label><spring:message code="forum.label.dept.nm"/></label></div> <!-- 학과 -->
					<div class="eleven wide field">${userVO.deptNm }</div>
				</div>
				<div class="fields">
					<div class="five wide field"><label><spring:message code="forum.label.mobile.number"/></label></div> <!-- 휴대전화번호 -->
					<div class="eleven wide field">${userVO.mobileNo }
						<c:if test="${MSG_EMAIL eq 'Y' && vo.searchText != 'Modal' && vo.searchMenu != 'EZG'}">
						<button class="ui circular basic icon button ml5 mt-5"><i class="mobile alternate icon"></i></button>
						</c:if>
					</div>
				</div>
				<div class="fields">
					<div class="five wide field"><label><spring:message code="forum.label.email"/></label></div> <!-- 이메일 -->
					<div class="eleven wide field">${userVO.email }</div>
				</div>
			</div> --%>

			<div class="mt10 mb10">
                <div class="ui attached message">
                    <div class="pt5 pb5"><spring:message code='forum_ezg.label.submit_filter'/><!-- 제출자 --></div>
                </div>
                <div class="ui attached message" id="infoView">
                    <ul class="tbl ">
                        <li>
                            <dl>
                                <dt><spring:message code='forum.label.user_nm'/><!-- 이름 --></dt>
                                <dd>${userVO.userNm}</dd>
                            </dl>
                        </li>
                        <li>
                            <dl>
                                <dt><spring:message code='forum.label.dept.nm'/><!-- 학과 --></dt>
                                <dd>${userVO.deptNm}</dd>
                            </dl>
                        </li>
                        <li>
                            <dl>
                                <dt><spring:message code='forum.label.user.grade'/><!-- 학년 --></dt>
                                <dd>${userVO.hy}</dd>
                            </dl>
                        </li>
                    </ul>
                </div>
            </div>
        <c:if test="${vo.searchMenu != 'EZG' }">
		</div>
		</c:if>
<c:if test="${vo.searchMenu != 'MutEval' && vo.searchMenu != 'EZG'}">
	</div>
</c:if>

<!-- 쪽지보내기 popup -->
<div class="modal fade" id="modalSendMessage" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="common.label.send.message" />" aria-hidden="true">
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="forum.button.close" />"> <!-- 닫기 -->
					<span aria-hidden="true">&times;</span>
				</button>
				<h4 class="modal-title"><spring:message code="common.label.send.message" /></h4> <!-- 쪽지보내기 -->
			</div>
			<div class="modal-body" >
				<iframe src="" width="100%" scrolling="no" id="modalMsgSendIfm" name="modalMsgSendIfm" style="overflow: hidden; height: 794px;"></iframe>
			</div>
		</div>
	</div>
</div>
