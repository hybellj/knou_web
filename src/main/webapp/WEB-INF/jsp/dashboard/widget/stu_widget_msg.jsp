<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<div id="msgListBox">

	<div id="msgCat1" class="tab-content" style="display: block;">
	    <!-- push list -->
	    <div class="alrim_item_area">
	        <div class="item_box push">
	            <a href="#0" class="item_txt">
	                <p class="desc">
	                    <span class="name">경영수리와 통계1반</span>
	                    <span class="date">2025.05.17</span>
	                </p>
	                <p class="tit">과제 제출 기간이 얼마 남지 않았습니다. 기간내에 제출해주세요</p>
	            </a>
	            <div class="state">
	                <label class="label check_no">읽지않음</label>
	            </div>
	        </div>
	        <div class="item_box push">
	            <a href="#0" class="item_txt">
	                <p class="desc">
	                    <span class="name">데이터베이스의 이해와 활용</span>
	                    <span class="date">2025.05.17</span>
	                </p>
	                <p class="tit">토론 등록되었습니다. </p>
	            </a>
	            <div class="state">
	                <label class="label check_no">읽지않음</label>
	            </div>
	        </div>
	        <div class="item_box push">
	            <a href="#0" class="item_txt">
	                <p class="desc">
	                    <span class="name">경영수리와 통계1반</span>
	                    <span class="date">2025.05.17</span>
	                </p>
	                <p class="tit">중간고사 7일 전입니다.</p>
	            </a>
	            <div class="state">
	                <label class="label check_ok">읽음</label>
	            </div>
	        </div>

	    </div>
	</div>

	<div id="msgCat2" class="tab-content" style="display: none;">
	    <!-- SMS list -->
	    <div class="alrim_item_area">
	        <div class="item_box sms">
	            <a href="#0" class="item_txt">
	                <p class="desc">
	                    <span class="name">관리자</span>
	                    <span class="date">2025.05.17</span>
	                </p>
	                <p class="tit">안녕하세요. 서버 점검 안내 드립니다.</p>
	            </a>
	            <div class="state">
	                <label class="label check_ok">읽음</label>
	            </div>
	        </div>
	        <div class="item_box sms">
	            <a href="#0" class="item_txt">
	                <p class="desc">
	                    <span class="name">관리자</span>
	                    <span class="date">2025.05.17</span>
	                </p>
	                <p class="tit">안녕하세요. 서버 점검 안내 드립니다.</p>
	            </a>
	            <div class="state">
	                <label class="label check_ok">읽음</label>
	            </div>
	        </div>
	        <div class="item_box sms">
	            <a href="#0" class="item_txt">
	                <p class="desc">
	                    <span class="name">관리자</span>
	                    <span class="date">2025.05.17</span>
	                </p>
	                <p class="tit">안녕하세요. 서버 점검 안내 드립니다.</p>
	            </a>
	            <div class="state">
	                <label class="label check_ok">읽음</label>
	            </div>
	        </div>
	    </div>
	</div>

	<div id="msgCat3" class="tab-content" style="display: none;">
	    <!-- msg list -->
	    <div class="alrim_item_area">
	        <div class="item_box msg">
	            <a href="#0" class="item_txt">
	                <p class="desc">
	                    <span class="name">김학생</span>
	                    <span class="date">2025.05.17</span>
	                </p>
	                <p class="tit">교수님! 경영통계 수업 듣는 학생입니다.</p>
	            </a>
	            <div class="state">
	                <label class="label check_ok">읽음</label>
	            </div>
	        </div>
	        <div class="item_box msg">
	            <a href="#0" class="item_txt">
	                <p class="desc">
	                    <span class="name">김학생</span>
	                    <span class="date">2025.05.17</span>
	                </p>
	                <p class="tit">안녕하세요. 교수님~</p>
	            </a>
	            <div class="state">
	                <label class="label check_ok">읽음</label>
	            </div>
	        </div>
	    </div>
	</div>

	<div id="msgCat4" class="tab-content" style="display: none;">
	    <!-- talk list -->
	    <div class="alrim_item_area">
	        <div class="item_box talk">
	            <a href="#0" class="item_txt">
	                <p class="desc">
	                    <span class="name">AI와 빅데이터 경영입문 2반</span>
	                    <span class="date">2025.05.17</span>
	                </p>
	                <p class="tit">과제가 등록 되었습니다. 확인해주세요.</p>
	            </a>
	            <div class="state">
	                <label class="label check_ok">읽음</label>
	            </div>
	        </div>
	        <div class="item_box talk">
	            <a href="#0" class="item_txt">
	                <p class="desc">
	                    <span class="name">경영수리와 통계1반</span>
	                    <span class="date">2025.05.17</span>
	                </p>
	                <p class="tit">출석 체크가 완료 되었습니다.</p>
	            </a>
	            <div class="state">
	                <label class="label check_ok">읽음</label>
	            </div>
	        </div>
	    </div>
	</div>

</div>

<script>
let msgWidgetCat = "msgCat1";

// 알림(메시지) 위젯 설정
function setMsgWidget() {
	let inTitle = ``;
	let subTitle = `
		<nav class="tab-type1">
        <nav class="alrim tab-type1 msg-cat-btns">
	        <a href="#_" class="btn current" cat="msgCat1"><span><img src="/webdoc/assets/img/common/alrim_icon_push.svg" aria-hidden="true" alt="PUSH"></span><small class="msg_num" id="widgetPushCnt">0</small></a>
			<a href="#_" class="btn" cat="msgCat2"><span><img src="/webdoc/assets/img/common/alrim_icon_sms.svg" aria-hidden="true" alt="SMS"></span><small class="msg_num" id="widgetSmsCnt">0</small></a>
			<a href="#_" class="btn" cat="msgCat3"><span><img src="/webdoc/assets/img/common/alrim_icon_msg.svg" aria-hidden="true" alt="<spring:message code='msg.title.msg.shrtnt'/>"></span><small class="msg_num" id="widgetShrtntCnt">0</small></a>
			<a href="#_" class="btn" cat="msgCat4"><span><img src="/webdoc/assets/img/common/alrim_icon_talk.svg" aria-hidden="true" alt="<spring:message code='msg.title.msg.alimTalk'/>"></span><small class="msg_num" id="widgetAlimtalkCnt">0</small></a>
		</nav>
		<div class="btn-wrap">
			<a href="#0" class="btn_more" aria-label="더보기" onclick="moveMsgWidgetMore();return false;"><i class="xi-plus"></i></a>
		</div>`;

	dashboardWidget.addInTitle("wigt_stu_msg", inTitle);
	dashboardWidget.addSubTitle("wigt_stu_msg", subTitle);

	$("#wigt_stu_msg_title").css({"flex-wrap":"nowrap","white-space":"nowrap"}); // 타이틀 영역 줄넘김 방지(임시)

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
	dashboardWidget.showLoading("wigt_stu_msg", false);
}

// 더보기 이동
function moveMsgWidgetMore() {
	//moveMenu(null, "URL", "upMenuId", "menuId", "알림");
}

setMsgWidget();

</script>