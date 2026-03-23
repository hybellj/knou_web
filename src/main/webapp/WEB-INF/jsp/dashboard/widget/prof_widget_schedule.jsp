<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

	<ul class="sche_list">
	    <li>
	        <div class="item_box">
	            <div class="s_date">03.04 ~ 03.10</div>
	            <div class="s_txt">
	                <p class="tit">중간고사 시험문제 등록/출제/검수</p>
	                <p class="desc">[대학원] 데이터베이스의 이해와 활용</p>
	            </div>
	        </div>
	    </li>
	    <li>
	        <div class="item_box">
	            <div class="s_date">03.05 ~ 03.12</div>
	            <div class="s_txt">
	                <p class="tit">결시원 승인</p>
	                <p class="desc">[대학원] 경영수리와 통계1반</p>
	            </div>
	        </div>
	    </li>
	    <li>
	        <div class="item_box">
	            <div class="s_date">03.12 ~ 03.15</div>
	            <div class="s_txt">
	                <p class="tit">2026학년도 1학기 중간고사</p>
	                <p class="desc">[대학원] 경영수리와 통계1반</p>
	            </div>
	        </div>
	    </li>
	    <li>
	        <div class="item_box">
	            <div class="s_date">03.18 ~ 03.22</div>
	            <div class="s_txt">
	                <p class="tit">시험문제 등록/출제/검수</p>
	                <p class="desc">[대학원] 데이터베이스의 이해와 활용</p>
	            </div>
	        </div>
	    </li>
	</ul>

<script>

// 이달의 학사일정 위젯 설정
function setScheduleWidget() {
	let inTitle = ``;
	let subTitle = `
		<div class="btn-wrap">
	        <div class="schedule-head">
	            <a class="btn-prev" href="#" aria-label="이전달" onclick="changeScheduleMonth('prev');return false;"><i class="xi-angle-left-min"></i></a>
	            <div class="this-month">3<small>월</small></div>
	            <a class="btn-next" href="#" aria-label="다음달" onclick="changeScheduleMonth('next');return false;"><i class="xi-angle-right-min"></i></a>
	        </div>
	    </div>`;

	dashboardWidget.addInTitle("wigt_prof_schedule", inTitle);
	dashboardWidget.addSubTitle("wigt_prof_schedule", subTitle);
}

// 학사일정 이전달/다음달 변경
function changeScheduleMonth(type) {
	// 이전달/다음달 변경 처리
	console.log("change schedume month="+type);
}

setScheduleWidget();

</script>