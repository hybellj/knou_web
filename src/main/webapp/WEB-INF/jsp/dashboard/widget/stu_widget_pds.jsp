<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

	<ul class="dash_item_listA">
	    <li>                                       
	        <a href="#0" class="item_txt">                                            
	            <p class="tit">1주차 강의자료 업로드​</p>
	            <p class="desc">
	                <span class="name">[대학원] 경영수리와 통계1반</span> 
	                <span class="date">2025.05.17</span> 
	            </p>
	        </a>
	        <div class="state">
	            <a href="#0" class="btn btn_down">다운로드</a>
	        </div>
	    </li>
	    <li>                                       
	        <a href="#0" class="item_txt">                                            
	            <p class="tit">실전 NoSQL 데이터베이스 활용 자료입니다.</p>
	            <p class="desc">
	                <span class="name">[대학원] 데이터베이스의 이해와 활용</span> 
	                <span class="date">2025.05.17</span> 
	            </p>
	        </a>
	        <div class="state">
	            <a href="#0" class="btn btn_down">다운로드</a>
	        </div>
	    </li>
	    <li>                                        
	        <a href="#0" class="item_txt">                                            
	            <p class="tit">New TEPS 공식기출문제집 정리 파일</p>
	            <p class="desc">
	                <span class="name">[평생교육] New TEPS 실전 연습-기본편</span> 
	                <span class="date">2025.05.17</span> 
	            </p>
	        </a>
	        <div class="state">
	            <a href="#0" class="btn btn_down">다운로드</a>
	        </div>
	    </li>
	</ul>

<script>

// 강의자료실 위젯 설정
function setPdsWidget() {
	let inTitle = ``;
	let subTitle = `
		<div class="btn-wrap">
			<a href="#0" class="btn_more" aria-label="더보기" onclick="movePdsWidgetMore();return false;"><i class="xi-plus"></i></a>
		</div>`;

	dashboardWidget.addInTitle("wigt_stu_pds", inTitle);
	dashboardWidget.addSubTitle("wigt_stu_pds", subTitle);
}

// 더보기 이동
function movePdsWidgetMore() {
	//moveMenu(null, "URL", "upMenuId", "menuId", "강의자료실");
}

setPdsWidget();

</script>