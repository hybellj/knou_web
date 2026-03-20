<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

	<div id="tab21" class="tab-content" style="display: block;">
	    <ul class="dash_item_listA">
	        <li>
	            <div class="noti_label">
	                <label class="labelA">전체</label>
	            </div>
	            <a href="#0" class="item_txt">
	                <p class="tit">1학기 성적처리 기준 안내입니다.</p>
	                <p class="desc">
	                    <span class="date">2026.05.17</span>
	                </p>
	            </a>
	            <div class="state">
	                <label class="label check_no">읽지않음</label>
	            </div>
	        </li>
	        <li>
	            <div class="noti_label">
	                <label class="labelB">과목</label>
	            </div>
	            <a href="#0" class="item_txt">
	                <p class="tit">성적 처리 기준에 대해 질문이 있습니다.</p>
	                <p class="desc">
	                    <span class="name">[대학원] 경영수리와 통계1반</span>
	                    <span class="date">2026.05.17</span>
	                </p>
	            </a>
	            <div class="state">
	                <label class="label check_ok">읽음</label>
	            </div>
	        </li>
	        <li>
	            <div class="noti_label">
	                <label class="labelB">과목</label>
	            </div>
	            <a href="#0" class="item_txt">
	                <p class="tit">이번 수업 정말 잘 들었습니다. 많은 도움이 되었어요</p>
	                <p class="desc">
	                    <span class="name">[평생교육] New TEPS 실전 연습-기본편</span>
	                    <span class="date">2026.05.17</span>
	                </p>
	            </a>
	            <div class="state">
	                <label class="label check_ok">읽음</label>
	            </div>
	        </li>
	    </ul>
	</div>

	<div id="tab22" class="tab-content" style="display: none;">
	    <ul class="dash_item_listA">
	        <li>
	            <div class="noti_label">
	                <label class="labelA">전체</label>
	            </div>
	            <a href="#0" class="item_txt">
	                <p class="tit">1학기 성적처리 기준 안내입니다.</p>
	                <p class="desc">
	                    <span class="date">2026.05.17</span>
	                </p>
	            </a>
	            <div class="state">
	                <label class="label check_no">읽지않음</label>
	            </div>
	        </li>
	        <li>
	            <div class="noti_label">
	                <label class="labelA">전체</label>
	            </div>
	            <a href="#0" class="item_txt">
	                <p class="tit">1학기 성적처리 기준 안내입니다.</p>
	                <p class="desc">
	                    <span class="date">2026.05.17</span>
	                </p>
	            </a>
	            <div class="state">
	                <label class="label check_ok">읽음</label>
	            </div>
	        </li>
	        <li>
	            <div class="noti_label">
	                <label class="labelA">전체</label>
	            </div>
	            <a href="#0" class="item_txt">
	                <p class="tit">1학기 성적처리 기준 안내입니다.</p>
	                <p class="desc">
	                    <span class="date">2026.05.17</span>
	                </p>
	            </a>
	            <div class="state">
	                <label class="label check_ok">읽음</label>
	            </div>
	        </li>
	    </ul>
	</div>

	<div id="tab23" class="tab-content" style="display: none;">
	    <ul class="dash_item_listA">
	        <li>
	            <div class="noti_label">
	                <label class="labelB">과목</label>
	            </div>
	            <a href="#0" class="item_txt">
	                <p class="tit">이번 수업 정말 잘 들었습니다. 많은 도움이 되었어요</p>
	                <p class="desc">
	                    <span class="name">[평생교육] New TEPS 실전 연습-기본편</span>
	                    <span class="date">2026.05.17</span>
	                </p>
	            </a>
	            <div class="state">
	                <label class="label check_ok">읽음</label>
	            </div>
	        </li>
	        <li>
	            <div class="noti_label">
	                <label class="labelB">과목</label>
	            </div>
	            <a href="#0" class="item_txt">
	                <p class="tit">성적 처리 기준에 대해 질문이 있습니다.</p>
	                <p class="desc">
	                    <span class="name">[대학원] 경영수리와 통계1반</span>
	                    <span class="date">2026.05.17</span>
	                </p>
	            </a>
	            <div class="state">
	                <label class="label check_ok">읽음</label>
	            </div>
	        </li>
	        <li>
	            <div class="noti_label">
	                <label class="labelB">과목</label>
	            </div>
	            <a href="#0" class="item_txt">
	                <p class="tit">이번 수업 정말 잘 들었습니다. 많은 도움이 되었어요</p>
	                <p class="desc">
	                    <span class="name">[평생교육] New TEPS 실전 연습-기본편</span>
	                    <span class="date">2026.05.17</span>
	                </p>
	            </a>
	            <div class="state">
	                <label class="label check_ok">읽음</label>
	            </div>
	        </li>
	    </ul>
	</div>

<script>

// 공지사항 위젯 설정
function setNoticeWidget() {
	let inTitle = ``;
	let subTitle = `
		<nav class="tab-type1">
		    <a href="#tab21" class="btn current"><span>전체</span></a>
		    <a href="#tab22" class="btn "><span>전체공지</span></a>
		    <a href="#tab23" class="btn "><span>과목공지</span></a>
		</nav>
		<div class="btn-wrap">
		    <a href="#_" class="btn_more" aria-label="더보기" onclick="moveNoticeWidgetMore();return false;"><i class="xi-plus"></i></a>
		</div>`;

	dashboardWidget.addInTitle("card3", inTitle);
	dashboardWidget.addSubTitle("card3", subTitle);

}

// 더보기 이동
function moveNoticeWidgetMore() {
	moveMenu(null, "/bbs/bbsHome/bbsAtclListView.do?bbsId=LMSBASIC_NOTICE", "PRO0000000074", "PRO0000000080", "전체공지");
}

setNoticeWidget();

</script>