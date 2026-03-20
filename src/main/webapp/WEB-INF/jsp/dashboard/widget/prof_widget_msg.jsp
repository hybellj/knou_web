<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

	<div id="tab11" class="tab-content" style="display: block;">
	    <div class="alrim_item_area" id="widgetPushList">
	        <div class="item_box push">
	            <p class="item_txt" style="text-align:center; padding:20px 0; color:#999;"><spring:message code='msg.alim.label.loading'/></p>
	        </div>
	    </div>
	</div>
	<div id="tab12" class="tab-content" style="display: none;">
	    <div class="alrim_item_area" id="widgetSmsList">
	        <div class="item_box sms">
	            <p class="item_txt" style="text-align:center; padding:20px 0; color:#999;"><spring:message code='msg.alim.label.loading'/></p>
	        </div>
	    </div>
	</div>
	<div id="tab13" class="tab-content" style="display: none;">
	    <div class="alrim_item_area" id="widgetMsgList">
	        <div class="item_box msg">
	            <p class="item_txt" style="text-align:center; padding:20px 0; color:#999;"><spring:message code='msg.alim.label.loading'/></p>
	        </div>
	    </div>
	</div>
	<div id="tab14" class="tab-content" style="display: none;">
	    <div class="alrim_item_area" id="widgetTalkList">
	        <div class="item_box talk">
	            <p class="item_txt" style="text-align:center; padding:20px 0; color:#999;"><spring:message code='msg.alim.label.loading'/></p>
	        </div>
	    </div>
	</div>

<script>

// 알림(메시지) 위젯 설정
function setMsgWidget() {
	let inTitle = ``;
	let subTitle = `
		<nav class="tab-type1">
        <nav class="tab-type1">
			<a href="#tab11" class="btn current"><span>PUSH</span><small class="msg_num" id="widgetPushCnt">0</small></a>
			<a href="#tab12" class="btn"><span>SMS</span><small class="msg_num" id="widgetSmsCnt">0</small></a>
			<a href="#tab13" class="btn"><span><spring:message code='msg.title.msg.shrtnt'/></span><small class="msg_num" id="widgetShrtntCnt">0</small></a>
			<a href="#tab14" class="btn"><span><spring:message code='msg.title.msg.alimTalk'/></span><small class="msg_num" id="widgetAlimtalkCnt">0</small></a>
		</nav>
		<div class="btn-wrap">
			<a href="#0" class="btn_more" aria-label="더보기"><i class="xi-plus"></i></a>
		</div>`;

	dashboardWidget.addInTitle("card6", inTitle);
	dashboardWidget.addSubTitle("card6", subTitle);
}

setMsgWidget();

</script>