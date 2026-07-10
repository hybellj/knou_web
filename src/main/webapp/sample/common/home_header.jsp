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


<header class="common">

	<button type="button" class="btn mobile-elem ctrl-gnb" aria-label="모바일 메뉴 버튼"><i class="icon-svg-menu fs-18px" aria-hidden="true"></i></button>

	<h1 class="logo">
		<a href="#0">
			<img src="<%=request.getContextPath()%>/webdoc/assets/img/logo.svg" aria-hidden="true" alt="한국방송통신대학교">
		</a>
	</h1>
	<div class="option-univ"><!-- 버튼 클릭시 on 클래스 추가 -->		
		<a href="#0" class="go_home" data-medi-ui="univ">전체<i class="icon-svg-arrow-down"></i></a>
		<div class="option-wrap">
			<div class="item selected"><a href="#0">전체</a></div>
			<div class="item"><a href="#0">대학원</a></div>	
			<div class="item"><a href="#0">학위과정</a></div>			
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
							<label for="widgetA">TODAY</label>
						</span>
						<span class="custom-input">
							<input type="checkbox" name="widgetF" id="widgetF" checked>
							<label for="widgetF">알림</label>
						</span>
						<span class="custom-input">
							<input type="checkbox" name="widgetC" id="widgetC" checked>
							<label for="widgetC">공지사항</label>
						</span>
						<span class="custom-input">
							<input type="checkbox" name="widgetB" id="widgetB" checked>
							<label for="widgetB">이달의 학사일정</label>
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
							<input type="checkbox" name="widgetG" id="widgetG" checked>
							<label for="widgetG">강의목록</label>
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
		<li class="zoom-control">
			<div class="icon_btns">				
				<div class="zoom_btn" aria-label="확대"><i class="xi-zoom-in"></i></div>
				<div class="zoom_btn" aria-label="축소"><i class="xi-zoom-out"></i></div>
				<div class="zoom_btn" aria-label="새로고침"><i class="xi-refresh"></i></div>
			</div>
			<script>
				window.currentZoom = 100; 
				function zoomIn() {
					if (window.currentZoom < 110) window.currentZoom += 5; 
					console.log("Zoom In:", window.currentZoom);
					updateZoomClass();
				}

				function zoomOut() {
					if (window.currentZoom > 90) window.currentZoom -= 5; 
					console.log("Zoom Out:", window.currentZoom);
					updateZoomClass();
				}

				function zoomReset() {
					window.currentZoom = 100; 
					console.log("Zoom Reset:", window.currentZoom);
					updateZoomClass();
				}

				function updateZoomClass() {
					console.log("updateZoomClass called");

					document.body.classList.remove(
						"zoom-90","zoom-95","zoom-100","zoom-105","zoom-110"
					);

					const zoomClass = "zoom-" + window.currentZoom;
					console.log("Adding class:", zoomClass);
					document.body.classList.add(zoomClass);
				}

				document.querySelector('[aria-label="확대"]').addEventListener('click', zoomIn);
				document.querySelector('[aria-label="축소"]').addEventListener('click', zoomOut);
				document.querySelector('[aria-label="새로고침"]').addEventListener('click', zoomReset);
			</script>

		</li>					
		<li class="alrim"><!-- 버튼 클릭시 on 클래스 추가 -->  
			<a href="#0" data-medi-ui="mail" title="알림"><i class="icon-svg-bell-01" aria-hidden="true"></i></a>
			<label class="count">12</label>

			<div class="menu">
				<div class="btn-more"><a href="#0"><i class="icon-svg-plus"></i></a></div>
				<!--tab-type1-->
				<nav class="tab-type1">
					<a href="#tab1" class="btn current"><span>PUSH</span><small class="msg_num">99</small></a>
					<a href="#tab2" class="btn "><span>SMS</span><small class="msg_num">3</small></a>
					<a href="#tab3" class="btn "><span>쪽지</span><small class="msg_num">2</small></a>
					<a href="#tab4" class="btn "><span>알림톡</span><small class="msg_num">1</small></a>
				</nav>

				<div class="scrollarea">
					<div id="tab1" class="tab-content" style="display: block;"> <!--탭메뉴 클릭 시 style="display: block;" 또는 style="display: none;"-->
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
							<div class="item_box push">							
								<a href="#0" class="item_txt">
									<p class="desc">
										<span class="name">AI와 빅데이터 경영입문 2반</span> 
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

					<div id="tab2" class="tab-content" style="display: none;">
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

					<div id="tab3" class="tab-content" style="display: none;">
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

					<div id="tab4" class="tab-content" style="display: none;">
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
			</div>
		
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
			<a href="#0" data-medi-ui="mode"><i class="icon-svg-palette" aria-hidden="true"></i></a>
			<div class="menu">
				<div class="widget_set_group">
					<div class="info-tit2">
						<span>컬러 테마를 선택하세요</span>
					</div>
					<div class="widget-list">
						<span class="custom-input">
							<input type="radio" name="wcolor" id="wcolor" data-theme="" checked>
							<label for="wcolor">기본</label>
							<span class="theme-color"></span>
						</span>
						<span class="custom-input">
							<input type="radio" name="wcolor" id="wcolorA" data-theme="colorA">
							<label for="wcolorA">블루</label>
							<span class="theme-color wcolorA"></span>
						</span>
						<span class="custom-input">
							<input type="radio" name="wcolor" id="wcolorB" data-theme="colorB">
							<label for="wcolorB">민트</label>
							<span class="theme-color wcolorB"></span>
						</span>
						<span class="custom-input">
							<input type="radio" name="wcolor" id="wcolorC" data-theme="colorC">
							<label for="wcolorC">오렌지</label>
							<span class="theme-color wcolorC"></span>
						</span>
						<span class="custom-input">
							<input type="radio" name="wcolor" id="wcolorD" data-theme="colorD">
							<label for="wcolorD">레드</label>
							<span class="theme-color wcolorD"></span>
						</span>
						<span class="custom-input">
							<input type="radio" name="wcolor" id="wcolorE" data-theme="colorE">
							<label for="wcolorE">퍼플</label>
							<span class="theme-color wcolorE"></span>
						</span>
						<span class="custom-input">
							<input type="radio" name="wcolor" id="wcolorDark" data-theme="darkmode">
							<label for="wcolorDark">다크모드</label>
							<span class="theme-color wcolorDark"></span>
						</span>
					</div>
				</div>				
				<div class="btns mt10">
					<button type="button" class="btn type5">저장</button>
					<button type="button" class="btn gray2">취소</button>
				</div>
			</div>		
		</li>				
		<li class="log">
			<a href="#0"><i class="icon-svg-logout" aria-hidden="true"></i></a>
		</li>
		
	</ul>
		
</header>
