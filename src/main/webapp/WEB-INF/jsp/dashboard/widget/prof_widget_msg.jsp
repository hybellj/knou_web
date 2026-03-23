<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<div id="msgListBox">
        <div id="msgCat1" class="tab-content" style="display: block;">
            <!-- push list -->
            <div class="alrim_item_area">
                <c:choose>
                    <c:when test="${not empty pushList}">
                        <c:forEach var="item" items="${pushList}">
                            <div class="item_box push">
                                <a href="#0" class="item_txt" data-sndng-id="${item.sndngId}" data-sndng-tycd="PUSH">
                                    <p class="desc">
                                        <span class="name"><c:out value="${not empty item.sbjctnm ? item.sbjctnm : item.sndngnm}"/></span>
                                        <span class="date"><uiex:formatDate value="${item.sndngDttm}" type="datetime2"/></span>
                                    </p>
                                    <p class="tit"><c:out value="${item.sndngTtl}"/></p>
                                </a>
                                <div class="state">
                                    <c:choose>
                                        <c:when test="${item.readYn eq 'N'}"><label class="label check_no"><spring:message code="msg.alim.label.unread"/></label></c:when>
                                        <c:otherwise><label class="label check_ok"><spring:message code="msg.alim.label.read"/></label></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="item_box push">
                            <p class="item_txt" style="text-align:center; padding:20px 0; color:#999;"><spring:message code="common.content.not_found"/></p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div id="msgCat2" class="tab-content" style="display: none;">
            <!-- SMS list -->
            <div class="alrim_item_area">
                <c:choose>
                    <c:when test="${not empty smsList}">
                        <c:forEach var="item" items="${smsList}">
                            <div class="item_box sms">
                                <a href="#0" class="item_txt" data-sndng-id="${item.sndngId}" data-sndng-tycd="SMS">
                                    <p class="desc">
                                        <span class="name"><c:out value="${not empty item.sbjctnm ? item.sbjctnm : item.sndngnm}"/></span>
                                        <span class="date"><uiex:formatDate value="${item.sndngDttm}" type="datetime2"/></span>
                                    </p>
                                    <p class="tit"><c:out value="${item.sndngTtl}"/></p>
                                </a>
                                <div class="state">
                                    <c:choose>
                                        <c:when test="${item.readYn eq 'N'}"><label class="label check_no"><spring:message code="msg.alim.label.unread"/></label></c:when>
                                        <c:otherwise><label class="label check_ok"><spring:message code="msg.alim.label.read"/></label></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="item_box sms">
                            <p class="item_txt" style="text-align:center; padding:20px 0; color:#999;"><spring:message code="common.content.not_found"/></p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div id="msgCat3" class="tab-content" style="display: none;">
            <!-- msg list -->
            <div class="alrim_item_area">
                <c:choose>
                    <c:when test="${not empty msgList}">
                        <c:forEach var="item" items="${msgList}">
                            <div class="item_box msg">
                                <a href="#0" class="item_txt" data-sndng-id="${item.sndngId}" data-sndng-tycd="SHRTNT">
                                    <p class="desc">
                                        <span class="name"><c:out value="${not empty item.sbjctnm ? item.sbjctnm : item.sndngnm}"/></span>
                                        <span class="date"><uiex:formatDate value="${item.sndngDttm}" type="datetime2"/></span>
                                    </p>
                                    <p class="tit"><c:out value="${item.sndngTtl}"/></p>
                                </a>
                                <div class="state">
                                    <c:choose>
                                        <c:when test="${item.readYn eq 'N'}"><label class="label check_no"><spring:message code="msg.alim.label.unread"/></label></c:when>
                                        <c:otherwise><label class="label check_ok"><spring:message code="msg.alim.label.read"/></label></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="item_box msg">
                            <p class="item_txt" style="text-align:center; padding:20px 0; color:#999;"><spring:message code="common.content.not_found"/></p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div id="msgCat4" class="tab-content" style="display: none;">
            <!-- talk list -->
            <div class="alrim_item_area">
                <c:choose>
                    <c:when test="${not empty talkList}">
                        <c:forEach var="item" items="${talkList}">
                            <div class="item_box talk">
                                <a href="#0" class="item_txt" data-sndng-id="${item.sndngId}" data-sndng-tycd="ALIM_TALK">
                                    <p class="desc">
                                        <span class="name"><c:out value="${not empty item.sbjctnm ? item.sbjctnm : item.sndngnm}"/></span>
                                        <span class="date"><uiex:formatDate value="${item.sndngDttm}" type="datetime2"/></span>
                                    </p>
                                    <p class="tit"><c:out value="${item.sndngTtl}"/></p>
                                </a>
                                <div class="state">
                                    <c:choose>
                                        <c:when test="${item.readYn eq 'N'}"><label class="label check_no"><spring:message code="msg.alim.label.unread"/></label></c:when>
                                        <c:otherwise><label class="label check_ok"><spring:message code="msg.alim.label.read"/></label></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="item_box talk">
                            <p class="item_txt" style="text-align:center; padding:20px 0; color:#999;"><spring:message code="common.content.not_found"/></p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

</div>

<script>
let msgWidgetCat = "msgCat1";

// 알림(메시지) 위젯 설정
function setMsgWidget() {
	let inTitle = ``;
	let subTitle = `
		<nav class="alrim tab-type1 msg-cat-btns">
			<a href="#_" class="btn current" cat="msgCat1"><span><img src="/webdoc/assets/img/common/alrim_icon_push.svg" aria-hidden="true" alt="PUSH"></span><small class="msg_num" id="widgetPushCnt">${unreadCnt.pushCnt}</small></a>
			<a href="#_" class="btn" cat="msgCat2"><span><img src="/webdoc/assets/img/common/alrim_icon_sms.svg" aria-hidden="true" alt="SMS"></span><small class="msg_num" id="widgetSmsCnt">${unreadCnt.smsCnt}</small></a>
			<a href="#_" class="btn" cat="msgCat3"><span><img src="/webdoc/assets/img/common/alrim_icon_msg.svg" aria-hidden="true" alt="<spring:message code='msg.title.msg.shrtnt'/>"></span><small class="msg_num" id="widgetShrtntCnt">${unreadCnt.shrtntCnt}</small></a>
			<a href="#_" class="btn" cat="msgCat4"><span><img src="/webdoc/assets/img/common/alrim_icon_talk.svg" aria-hidden="true" alt="<spring:message code='msg.title.msg.alimTalk'/>"></span><small class="msg_num" id="widgetAlimtalkCnt">${unreadCnt.alimtalkCnt}</small></a>
		</nav>
		<div class="btn-wrap">
			<a href="#0" class="btn_more" aria-label="더보기" onclick="moveMsgWidgetMore();return false;"><i class="xi-plus"></i></a>
		</div>`;

	dashboardWidget.addInTitle("wigt_prof_msg", inTitle);
	dashboardWidget.addSubTitle("wigt_prof_msg", subTitle);

	$("#wigt_prof_msg_title").css({"flex-wrap":"nowrap","white-space":"nowrap"}); // 타이틀 영역 줄넘김 방지(임시)

	// 알림 카테고리 선택
	$("nav.msg-cat-btns a.btn").on("click", function() {
		let cat = $(this).attr("cat");
		changeMsgCat(cat);
		return false;
	});

	// 알림 카테고리 변경
	function changeMsgCat(cat) {
		$("#msgListBox .tab-content").hide();
		$("#"+cat).show();

		$("nav.msg-cat-btns a.btn").removeClass("current");
		$("nav.msg-cat-btns a.btn[cat="+cat+"]").addClass("current");
	}

	changeMsgCat(msgWidgetCat);
}

/* 알림 아이템 클릭 */
$(document).on('click', '#msgListBox .item_txt[data-sndng-tycd]', function(e) {
	e.preventDefault();
	let sndngTycd = $(this).data('sndng-tycd');
	let sndngId = $(this).data('sndng-id');

	if (!sndngId) return;

	if (sndngTycd === 'SHRTNT') {
		location.href = '/profMsgShrtntRcvnDetail.do?msgShrtntSndngId=' + encodeURIComponent(sndngId);
	}
});

// 더보기 이동
function moveMsgWidgetMore() {
	let activeCat = $("nav.msg-cat-btns a.btn.current").attr("cat");

	if (activeCat === 'msgCat3') {
		location.href = '/profMsgShrtntListView.do';
	}
}

setMsgWidget();

</script>
