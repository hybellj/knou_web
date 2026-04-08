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
            <div class="alrim_item_area" id="widgetSmsList">
                <div class="item_box sms">
                    <p class="item_txt" style="text-align:center; padding:20px 0; color:#999;"><spring:message code="msg.alim.label.loading"/></p>
                </div>
            </div>
        </div>

        <div id="msgCat3" class="tab-content" style="display: none;">
            <div class="alrim_item_area" id="widgetMsgList">
                <div class="item_box msg">
                    <p class="item_txt" style="text-align:center; padding:20px 0; color:#999;"><spring:message code="msg.alim.label.loading"/></p>
                </div>
            </div>
        </div>

        <div id="msgCat4" class="tab-content" style="display: none;">
            <div class="alrim_item_area" id="widgetTalkList">
                <div class="item_box talk">
                    <p class="item_txt" style="text-align:center; padding:20px 0; color:#999;"><spring:message code="msg.alim.label.loading"/></p>
                </div>
            </div>
        </div>

</div>

<script>
let msgWidgetCat = "msgCat1";

let WIDGET_CHNL_MAP = {
	'msgCat2': { chnlCd: 'SMS',       targetId: '#widgetSmsList',  itemClass: 'sms',  listKey: 'list',  tycd: 'SMS' },
	'msgCat3': { chnlCd: 'SHRTNT',    targetId: '#widgetMsgList',  itemClass: 'msg',  listKey: 'list',  tycd: 'SHRTNT' },
	'msgCat4': { chnlCd: 'ALIM_TALK', targetId: '#widgetTalkList', itemClass: 'talk', listKey: 'list', tycd: 'ALIM_TALK' }
};
let widgetLoadedChnl = { 'msgCat1': true };

// 알림(메시지) 위젯 설정
function setMsgWidget() {
	let inTitle = ``;
	let subTitle = `
		<nav class="alrim tab-type1 msg-cat-btns">
			<a href="#_" class="btn current" cat="msgCat1"><span><img src="/webdoc/assets/img/common/alrim_icon_push.svg" aria-hidden="true" alt="PUSH"></span><small class="msg_num" id="widgetPushCnt">0</small></a>
			<a href="#_" class="btn" cat="msgCat2"><span><img src="/webdoc/assets/img/common/alrim_icon_sms.svg" aria-hidden="true" alt="SMS"></span><small class="msg_num" id="widgetSmsCnt">0</small></a>
			<a href="#_" class="btn" cat="msgCat3"><span><img src="/webdoc/assets/img/common/alrim_icon_msg.svg" aria-hidden="true" alt="<spring:message code='msg.title.msg.shrtnt'/>"></span><small class="msg_num" id="widgetShrtntCnt">0</small></a>
			<a href="#_" class="btn" cat="msgCat4"><span><img src="/webdoc/assets/img/common/alrim_icon_talk.svg" aria-hidden="true" alt="<spring:message code='msg.title.msg.alimTalk'/>"></span><small class="msg_num" id="widgetAlimtalkCnt">0</small></a>
		</nav>
		<div class="btn-wrap">
			<a href="#0" class="btn_more" aria-label="더보기" onclick="moveMsgWidgetMore();return false;"><i class="xi-plus"></i></a>
		</div>`;

	dashboardWidget.addInTitle("wigt_prof_msg", inTitle);
	dashboardWidget.addSubTitle("wigt_prof_msg", subTitle);

	$("#wigt_prof_msg_title").css({"flex-wrap":"nowrap","white-space":"nowrap"});

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

		// PUSH 외 채널: 최초 클릭 시 AJAX 조회
		if (!widgetLoadedChnl[cat] && WIDGET_CHNL_MAP[cat]) {
			fn_widgetLoadChnl(cat);
		}
	}

	changeMsgCat(msgWidgetCat);

	// 헤더 AJAX 결과에서 배지 카운트 동기화
	$('#widgetPushCnt').text($('#headerPushCnt').text() || 0);
	$('#widgetSmsCnt').text($('#headerSmsCnt').text() || 0);
	$('#widgetShrtntCnt').text($('#headerShrtntCnt').text() || 0);
	$('#widgetAlimtalkCnt').text($('#headerAlimtalkCnt').text() || 0);
}

/* 채널별 목록 AJAX 조회 */
function fn_widgetLoadChnl(cat) {
	let info = WIDGET_CHNL_MAP[cat];
	if (!info) return;

	ajaxCall('/alimChnlListAjax.do', { chnlCd: info.chnlCd, listCnt: 5 }, function(data) {
		if (data.result > 0 && data.returnVO) {
			let list = data.returnVO[info.listKey];
			alimNotiRenderList(info.tycd, list, info.targetId, info.itemClass);
			widgetLoadedChnl[cat] = true;
		}
	}, function() {
		console.error('위젯 알림 목록 조회 실패: ' + info.chnlCd);
	}, false, {type: 'GET'});
}

/* 알림 아이템 클릭 */
$(document).on('click', '#msgListBox .item_txt[data-sndng-tycd]', function(e) {
	e.preventDefault();
	let sndngTycd = $(this).data('sndng-tycd');
	let sndngId = $(this).data('sndng-id');

	if (!sndngId) return;

	if (sndngTycd === 'SHRTNT') {
		location.href = '/profMsgShrtntRcvnSelectView.do?msgShrtntSndngId=' + encodeURIComponent(sndngId);
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
