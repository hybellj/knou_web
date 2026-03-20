<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

	<div class="today_line">
		<div class="item today">
			<div class="item_tit">Today</div>
			<div class="item_info">${todayDate}</div>
		</div>
		<div class="item user" style="padding: .6rem 2rem .6rem 2rem;">
			<div class="item_tit">
				<a href="#0" class="btn">접속 <i class="xi-angle-down-min"></i></a>
				<div class="user-option-wrap">
					<div class="option_head">
						<p class="user_num">접속: 1</p>
						<button type="button" class="btn-close"><i class="icon-svg-close"></i></button>
					</div>
					<ul class="user_area"></ul>
				</div>
			</div>
			<div class="item_info">
				<span class="big">${lgnUsrCnt}</span>
				<span class="small">${totStdntCnt}</span>
			</div>
		</div>
	</div>
	<div class="today_subject">
		<ul class="slider_list">
			<li>
				<div class="slide">
					<div class="item_tit">데이터베이스의 이해와 활용 1반</div>
					<div class="item_info">
						<span class="big">37</span>
						<span class="small">250</span>
						<span class="txt">미달</span>
					</div>
				</div>

				<div class="slide">
					<div class="item_tit">경영수리와 통계1반</div>
					<div class="item_info">
						<span class="big">22</span>
						<span class="small">200</span>
						<span class="txt">미달</span>
					</div>
				</div>

				<div class="slide">
					<div class="item_tit">데이터베이스의 이해와 활용 1반</div>
					<div class="item_info">
						<span class="big">37</span>
						<span class="small">250</span>
						<span class="txt">미달</span>
					</div>
				</div>
			</li>
		</ul>
	</div>

<script>

// Today 위젯 설정
function setTodayWidget() {

	setTimeout(() => {
	    $('.slider_list li').not('.slick-initialized').slick({
	        slidesToShow: 1,
	        autoplay: true
	    });
	}, 50);

}

setTodayWidget();

</script>