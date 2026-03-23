<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

	<ul class="dash_item_listA">
	    <li>
	        <div class="user">
	           <span class="user_img"></span>
	        </div>
	        <a href="#0" class="item_txt">                                            
	            <p class="tit">과제 제출 언제까지 인가요?</p>
	            <p class="desc">
	                <span class="name">[대학원] 경영수리와 통계1반</span> 
	                <span class="date">2025.05.17</span> 
	            </p>
	        </a>
	        <div class="state">
	            <label class="label check_no">미답변</label>
	        </div>
	    </li>
	    <li>
	        <div class="user">
	           <span class="user_img"><img src="/webdoc/assets/img/common/photo_user_sample2.jpg" aria-hidden="true" alt="사진"></span>
	        </div>
	        <a href="#0" class="item_txt">                                            
	            <p class="tit">강의 내용 중에 이해가 안되는 부분이 있습니다.</p>
	            <p class="desc">
	                <span class="name">[대학원] 경영수리와 통계1반</span> 
	                <span class="date">2025.05.17</span> 
	            </p>
	        </a>
	        <div class="state">
	            <label class="label check_reply">답변</label>
	        </div>
	    </li>
	    <li>
	        <div class="user">
	           <span class="user_img"></span>
	        </div>
	        <a href="#0" class="item_txt">                                            
	            <p class="tit">과제 제출 언제까지 인가요?</p>
	            <p class="desc">
	                <span class="name">[평생교육] 광고와 이미지 마케팅</span> 
	                <span class="date">2025.05.17</span> 
	            </p>
	        </a>
	        <div class="state">
	            <label class="label check_reply">답변</label>
	        </div>
	    </li>
	</ul>

<script>

// Q&A 위젯 설정
function setQnaWidget() {
	let inTitle = ` <small class="msg_num">3</small>`;
	let subTitle = `
		<div class="btn-wrap">
			<a href="#0" class="btn_more" aria-label="더보기" onclick="moveQnaWidgetMore();return false;"><i class="xi-plus"></i></a>
		</div>`;

	dashboardWidget.addInTitle("wigt_stu_qna", inTitle);
	dashboardWidget.addSubTitle("wigt_stu_qna", subTitle);
}

// 더보기 이동
function moveQnaWidgetMore() {
	//moveMenu(null, "/bbs/bbsHome/bbsLctrQnaListView.do?bbsId=LMSBASIC_QNA", "PRO0000000001", "PRO0000000075", "강의Q&A");
}

setQnaWidget();

</script>