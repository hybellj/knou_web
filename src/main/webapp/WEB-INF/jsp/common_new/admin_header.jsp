<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<div id="key_access">
    <ul>
        <li><a href="#gnb" title="주메뉴 위치로 바로가기">주메뉴 바로가기</a></li>
        <li><a href="#head_menu" title="서브메뉴 위치로 바로가기">서브메뉴 바로가기</a></li>
        <li><a href="#content" title="본문 위치로 바로가기">본문 바로가기</a></li>
        <li><a href="#bottom" title="하단 위치로 바로가기">하단 바로가기</a></li>
    </ul>
</div>

<div id="loading_page">
    <p><i class="notched circle loading icon"></i></p>
</div>


<header class="common admin">

	<h1 class="logo">
		<a href="#0">
			<img src="<%=request.getContextPath()%>/webdoc/assets/img/logo_w.png" aria-hidden="true" alt="한국방송통신대학교">
		</a>
	</h1>

	<ul id="head_menu" class="topmenu">
		<li class="depth1">
			<a href="#0"><span>과정(테넌시)관리</span></a>
			<div class="submenu">
				<ul class="depth2">
					<li><a href="#0">기본정보관리</a></li>
					<li><a href="#0">디자인컬러설정</a></li>
					<li><a href="#0">대시보드 위젯설정</a></li>
					<li><a href="#0">강의실메뉴설정</a></li>
					<li><a href="#0">LMS옵션설정</a></li>
					<li><a href="#0">학사연동관리</a></li>
				</ul>
			</div>
		</li>
		<li class="depth1">
			<a href="#0"><span>관리자관리</span></a>
			<div class="submenu">
				<ul class="depth2">
					<li><a href="#0">관리자 권한관리</a></li>
					<li><a href="#0">관리자 메뉴관리</a></li>
				</ul>
			</div>
		</li>
		<li class="depth1">
			<a href="#0"><span>LMS공통관리</span></a>
			<div class="submenu">
				<ul class="depth2">
					<li><a href="#0">온라인 매뉴얼관리</a></li>
				</ul>
			</div>			
		</li>
		<li class="depth1">
			<a href="#0"><span>메시지관리</span></a>
			<div class="submenu">
				<ul class="depth2">
					<li><a href="#0">메시지발송</a></li>
					<li><a href="#0">자동발송안내문구</a></li>
					<li><a href="#0">메시지 발송내역</a></li>
					<li><a href="#0">팝업 메시지관리</a></li>
					<li><a href="#0">알림 수신동의현황</a></li>
				</ul>
			</div>				
		</li>
		<li class="depth1">
			<a href="#0"><span>시스템관리</span></a>
			<div class="submenu">
				<ul class="depth2">
					<li><a href="#0">시스템공지사항</a></li>
					<li><a href="#0">전체 시스템오류현황</a></li>
					<li><a href="#0">공통코드관리</a></li>
					<li><a href="#0">관리자 IP관리</a></li>
				</ul>
			</div>			
		</li>
		<li class="depth1">
			<a href="#0"><span>공개강좌관리</span></a>	
			<div class="submenu">
				<ul class="depth2">
					<li><a href="#0">2depth</a></li>					
				</ul>
			</div>			
		</li>
		<li class="depth1">
			<a href="#0"><span>수업운영도구</span></a>	
			<div class="submenu">
				<ul class="depth2">
					<li><a href="#0">대시보드</a></li>	
					<li><a href="#0">과정관리</a></li>		
					<li><a href="#0">콘텐츠관리</a></li>		
					<li><a href="#0">과목관리</a></li>						
				</ul>
			</div>			
		</li>
	</ul>
	<script>
		document.addEventListener("DOMContentLoaded", function () {
			const menuItems = document.querySelectorAll(".topmenu .depth1");
			const depth2Lists = document.querySelectorAll(".topmenu .depth2");

			function hideAllDepth2() {
				depth2Lists.forEach(d2 => {
					d2.style.display = "none";
				});
			}

			menuItems.forEach(item => {
				item.addEventListener("click", function (e) {
					e.preventDefault();

					hideAllDepth2();

					menuItems.forEach(i => i.classList.remove("active"));
					this.classList.add("active");
				});

				item.addEventListener("mouseenter", function () {

					hideAllDepth2();

					const thisDepth2 = this.querySelector(".depth2");
					if (thisDepth2) {
						thisDepth2.style.display = "flex";
					}
				});

				item.addEventListener("mouseleave", function () {
					hideAllDepth2();
				});
			});
		});
	</script>

	
	<ul class="util">										
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
		<li class="log">
			<a href="#0"><i class="icon-svg-logout" aria-hidden="true"></i></a>
		</li>
		<li class="user">
			<a href="#0"><span class="user_img"><img src="<%=request.getContextPath()%>/webdoc/assets/img/common/photo_user_sample4.jpg" aria-hidden="true" alt="사진"></span></a>
		</li>		
	</ul>
		
</header>
