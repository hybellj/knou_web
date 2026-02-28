<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<div id="key_access">
    <ul>
        <li><a href="#gnb" title="주메뉴 위치로 바로가기">주메뉴 바로가기</a></li>
        <li><a href="#content" title="본문 위치로 바로가기">본문 바로가기</a></li>
        <li><a href="#bottom" title="하단 위치로 바로가기">하단 바로가기</a></li>
    </ul>
</div>

<div id="loading_page">
    <p><i class="notched circle loading icon"></i></p>
</div>

<!--common header-->
<header class="common">

	<button type="button" class="btn mobile-elem ctrl-gnb" aria-label="모바일 메뉴 버튼"><i class="icon-svg-menu fs-18px" aria-hidden="true"></i></button>

	<h1 class="logo">
		<a href="#0">
			<img src="<%=request.getContextPath()%>/webdoc/assets/img/logo.png" aria-hidden="true" alt="한국방송통신대학교">
		</a>
	</h1>
	<div class="option-univ"><!-- 버튼 클릭시 on 클래스 추가 -->		
		<a href="#0" class="go_home" data-medi-ui="univ">대학원<i class="icon-svg-arrow-down"></i></a>
		<div class="option-wrap">
			<div class="item selected"><a href="#0">대학원</a></div>
			<div class="item"><a href="#0">프라임칼리지</a></div>			
		</div>				
	</div>

	<ul class="util">	
		<li class="widget_setting"><!-- 버튼 클릭시 on 클래스 추가 -->
			<a href="#0" data-medi-ui="widget"><i class="icon-svg-widget" aria-hidden="true"></i>위젯설정</a>
			 			
			<div class="menu">
				<div class="widget_set_group">
					<div class="info-tit">
						<span>사용할 위젯을 선택하세요</span>
					</div>
					<div class="widget-list">										
						<span class="custom-input">
							<input type="checkbox" name="widgetA" id="widgetA" checked>
							<label for="widgetA">Today</label>
						</span>
						<span class="custom-input">
							<input type="checkbox" name="widgetB" id="widgetB" checked>
							<label for="widgetB">이달의 학사일정</label>
						</span>
						<span class="custom-input">
							<input type="checkbox" name="widgetC" id="widgetC" checked>
							<label for="widgetC">공지사항</label>
						</span>
						<span class="custom-input">
							<input type="checkbox" name="widgetD" id="widgetD" checked>
							<label for="widgetD">강의Q&A</label>
						</span>
						<span class="custom-input">
							<input type="checkbox" name="widgetE" id="widgetE" checked>
							<label for="widgetE">1:1상담</label>
						</span>
						<span class="custom-input">
							<input type="checkbox" name="widgetF" id="widgetF" checked>
							<label for="widgetF">알림</label>
						</span>
						<span class="custom-input">
							<input type="checkbox" name="widgetG" id="widgetG" checked>
							<label for="widgetG">강의과목</label>
						</span>   
					</div>	
				</div>
				<div class="widget_set_group">
					<div class="info-tit2">
						<span>컬러를 선택하세요</span>
					</div>
					<div class="widget-list">	
						<span class="custom-input">
							<input type="radio" name="wcolor" id="wcolor" checked="">
							<label for="wcolor">기본</label>
						</span>
						<span class="custom-input">
							<input type="radio" name="wcolor" id="wcolorA">
							<label for="wcolorA">블루</label>
						</span>
						<span class="custom-input">
							<input type="radio" name="wcolor" id="wcolorB">
							<label for="wcolorB">민트</label>
						</span>
						<span class="custom-input">
							<input type="radio" name="wcolor" id="wcolorC">
							<label for="wcolorC">오렌지</label>
						</span>
						<span class="custom-input">
							<input type="radio" name="wcolor" id="wcolorD">
							<label for="wcolorD">레드</label>
						</span>
						<span class="custom-input">
							<input type="radio" name="wcolor" id="wcolorE">
							<label for="wcolorE">퍼플</label>
						</span>																										
					</div>
				</div>	
				<div class="info-txt2">
					<i class="icon-svg-move"></i>
					<span>드래그하여 위젯을 원하는 위치로 이동하세요.</span>
				</div>
				<div class="btns">
					<button type="button" class="btn type5">저장</button>
					<button type="button" class="btn gray2">취소</button>
				</div>				
			</div> 
			
		</li>	
		<li class="info_time"><span>이전로그인 2022.07.18 15:17 (211.157.234.211)</span></li>					
		<li class="alrim"><!-- 버튼 클릭시 on 클래스 추가 -->  
			<a href="#0" data-medi-ui="mail" title="알림"><i class="icon-svg-bell-01" aria-hidden="true"></i></a>
			<label class="count">12</label>

			<div class="menu">  
				<div class="btn-more"><a href="#0"><i class="icon-svg-plus"></i></a></div>
				<div class=" ui pointing secondary tabmenu tMenubar ">
					<a class="tmItem active" data-tab="tabcont1">
						<span>PUSH</span><small class="msg_num">99</small>
					</a>
					<a class="tmItem" data-tab="tabcont2">
						<span>SMS</span><small class="msg_num">3</small>
					</a>
					<a class="tmItem" data-tab="tabcont3">
						<span>쪽지</span><small class="msg_num">2</small>
					</a>
					<a class="tmItem" data-tab="tabcont4">
						<span>알림톡</span><small class="msg_num">1</small>
					</a>
				</div>
				
				<div class="scrollarea"> 
					<div class="ui tab active" data-tab="tabcont1"> 
						<!-- push list -->
						<div class="alrim_item_area">									
							<div class="item_box push">								
								<a href="#0" class="item_txt">
									<p class="tit">
										<span class="name">경영수리와 통계1반</span> 
										<span class="date">2025.05.17 15:25</span> 
									</p>
									<p class="desc">과제 제출 기간이 얼마 남지 않았습니다. 기간내에 제출해주세요</p>
								</a>
								<div class="state">
									<label class="label check_no">읽지않음</label>
								</div>
							</div>
							<div class="item_box push">								
								<a href="#0" class="item_txt">
									<p class="tit">
										<span class="name">데이터베이스의 이해와 활용</span> 
										<span class="date">2025.05.17 15:25</span> 
									</p>
									<p class="desc">토론 등록되었습니다. </p>
								</a>
								<div class="state">
									<label class="label check_no">읽지않음</label>
								</div>
							</div>
							<div class="item_box push">							
								<a href="#0" class="item_txt">
									<p class="tit">
										<span class="name">경영수리와 통계1반</span> 
										<span class="date">2025.05.17 15:25</span> 
									</p>
									<p class="desc">중간고사 7일 전입니다.</p>
								</a>
								<div class="state">
									<label class="label check_ok">읽음</label>
								</div>
							</div>	
							<div class="item_box push">							
								<a href="#0" class="item_txt">
									<p class="tit">
										<span class="name">AI와 빅데이터 경영입문 2반</span> 
										<span class="date">2025.05.17 15:25</span> 
									</p>
									<p class="desc">중간고사 7일 전입니다.</p>
								</a>
								<div class="state">
									<label class="label check_ok">읽음</label>
								</div>
							</div>							
						</div>
					</div>
					
					<div class="ui tab " data-tab="tabcont2"> 
						<!-- SMS list -->
						<div class="alrim_item_area">																
							<div class="item_box sms">							
								<a href="#0" class="item_txt">
									<p class="tit">
										<span class="name">관리자</span> 
										<span class="date">2025.05.17 15:25</span> 
									</p>									
									<p class="desc">안녕하세요. 서버 점검 안내 드립니다.</p>
								</a>
								<div class="state">
									<label class="label check_ok">읽음</label>
								</div>
							</div>
							<div class="item_box sms">									
								<a href="#0" class="item_txt">
									<p class="tit">
										<span class="name">관리자</span> 
										<span class="date">2025.05.17 15:25</span> 
									</p>									
									<p class="desc">안녕하세요. 서버 점검 안내 드립니다.</p>
								</a>
								<div class="state">
									<label class="label check_ok">읽음</label>
								</div>
							</div>
							<div class="item_box sms">									
								<a href="#0" class="item_txt">
									<p class="tit">
										<span class="name">관리자</span> 
										<span class="date">2025.05.17 15:25</span> 
									</p>									
									<p class="desc">안녕하세요. 서버 점검 안내 드립니다.</p>
								</a>
								<div class="state">
									<label class="label check_ok">읽음</label>
								</div>
							</div>								
						</div>
					</div>
					
					<div class="ui tab " data-tab="tabcont3"> 
						<!-- msg list -->
						<div class="alrim_item_area">																							
							<div class="item_box msg">							
								<a href="#0" class="item_txt">
									<p class="tit">
										<span class="name">김학생</span> 
										<span class="date">2025.05.17 15:25</span> 
									</p>
									<p class="desc">교수님! 경영통계 수업 듣는 학생입니다.</p>
								</a>
								<div class="state">
									<label class="label check_ok">읽음</label>
								</div>
							</div>	
                            <div class="item_box msg">						
								<a href="#0" class="item_txt">
									<p class="tit">
										<span class="name">김학생</span> 
										<span class="date">2025.05.17 15:25</span> 
									</p>
									<p class="desc">안녕하세요. 교수님~</p>
								</a>
								<div class="state">
									<label class="label check_ok">읽음</label>
								</div>
							</div>															
						</div>
					</div>    
					
					<div class="ui tab " data-tab="tabcont4"> 
						<!-- talk list -->
						<div class="alrim_item_area">																														
							<div class="item_box talk">								
								<a href="#0" class="item_txt">
									<p class="tit">
										<span class="name">AI와 빅데이터 경영입문 2반</span> 
										<span class="date">2025.05.17 15:25</span> 
									</p>
									<p class="desc">과제가 등록 되었습니다. 확인해주세요.</p>
								</a>
								<div class="state">
									<label class="label check_ok">읽음</label>
								</div>
							</div>	
							<div class="item_box talk">								
								<a href="#0" class="item_txt">
									<p class="tit">
										<span class="name">경영수리와 통계1반</span> 
										<span class="date">2025.05.17 15:25</span> 
									</p>
									<p class="desc">출석 체크가 완료 되었습니다.</p>
								</a>
								<div class="state">
									<label class="label check_ok">읽음</label>
								</div>
							</div>									
						</div>
					</div> 
				</div>

			</div>
				
			<script> 
				$('.tabmenu.tMenubar .tmItem').tab(); 				
			</script>
		</li>           				
		<li class="lang_change"><!-- 버튼 클릭시 on 클래스 추가 -->
			<a href="#0" aria-label="언어선택" data-medi-ui="langs"><i class="icon-svg-globe-01"></i></a>
			<div class="option-wrap">
				<div class="item selected"><a href="#0">한국어</a></div>
				<div class="item"><a href="#0">English</a></div>
				<div class="item"><a href="#0">日本語</a></div>
				<div class="item"><a href="#0">汉语</a></div>				
			</div>			
		</li>		
		<li class="mode">
			<a href="#0" data-medi-ui="mode"><i class="icon-svg-moon-star" aria-hidden="true"></i></a>    
		</li>				
		<li class="log">
			<a href="#0"><i class="icon-svg-logout" aria-hidden="true"></i></a>
		</li>
		
	</ul>
		
</header>
<!--//common header-->