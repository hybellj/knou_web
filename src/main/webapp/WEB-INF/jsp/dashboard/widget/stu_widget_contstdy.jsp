<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

	<ul class="ing_list"> 
	    <li>
	        <div class="item_box">                                                                                              
	            <div class="s_txt">
	                <p class="tit">[대학원] 데이터베이스의 이해와 활용</p>
	                <p class="desc"><i class="xi-subdirectory-arrow"></i>우리 생활 주변의 데이터베이스</p>
	            </div>  
	            <div class="s_btn">
	                <a href="#0" onclick="moveContstdy('param');return false;" aria-label="이어보기" class="btn btn_play">
	                    <i class="xi-play"></i>
	                </a>
	            </div> 
	        </div>          
	    </li>
	    <li>
	        <div class="item_box">                                                                                              
	            <div class="s_txt">
	                <p class="tit">[평생교육] New TEPS 실전 연습-기본편</p>
	                <p class="desc"><i class="xi-subdirectory-arrow"></i>Test 1회 Listening Comprehension</p>
	            </div>  
	            <div class="s_btn">
	                <a href="#0" onclick="moveContstdy('param');return false;" aria-label="이어보기" class="btn btn_play">
	                    <i class="xi-play"></i>
	                </a>
	            </div> 
	        </div>          
	    </li>
	    <li>
	        <div class="item_box">                                                                                              
	            <div class="s_txt">
	                <p class="tit">[대학원] 데이터베이스의 이해와 활용</p>
	                <p class="desc"><i class="xi-subdirectory-arrow"></i>우리 생활 주변의 데이터베이스</p>
	            </div>  
	            <div class="s_btn">
	                <a href="#0" onclick="moveContstdy('param');return false;" aria-label="이어보기" class="btn btn_play">
	                    <i class="xi-play"></i>
	                </a>
	            </div> 
	        </div>          
	    </li>
	</ul>

<script>

// 강의 이어보기 위젯 설정
function setContstdyWidget() {
	let inTitle = ``;
	let subTitle = ``;

	dashboardWidget.addInTitle("wigt_stu_contstdy", inTitle);
	dashboardWidget.addSubTitle("wigt_stu_contstdy", subTitle);
}

// 강의 이어보기 이동
function moveContstdy(param) {
	// 강의 이어보기 이동 처리
}

setContstdyWidget();

</script>