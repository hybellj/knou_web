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
			<img src="/webdoc/dm_assets/img/logo.png" aria-hidden="true" alt="한국방송통신대학교">
		</a>
	</h1>
	
	<div class="first" style="padding-top:2px;">
        <select class="form-select" style="font-size:15px; border-radius:100em;">
            <option value="">전체</option>
            <option value="대학원">대학원</option>
            <option value="학위과정">학위과정</option>
        </select>
        <select class="form-select wide" style="font-size:15px; margin-left: 5px; border-radius:100em;">
            <option value="">전체</option>
            <option value="관리자">관리자</option>
            <option value="교수">교수</option>
            <option value="학생">학생</option>
        </select>
    </div>

	<ul class="util">
		<li class="widget_setting"><!-- 버튼 클릭시 on 클래스 추가 -->
			<a href="#0" data-medi-ui="widget"><i class="icon-svg-widget" aria-hidden="true"></i>위젯설정</a>
			 			
			<div class="menu">
				<div class="widget_set_group">
				</div>
				<div class="widget_set_group_color">
				</div>	
				<div class="info-txt2">
					<i class="icon-svg-move"></i>
					<span>드래그하여 위젯을 원하는 위치로 이동하세요.</span>
				</div>
				<div class="btns">
					<button type="button" class="btn type5" onclick="saveWidgetSetting()">저장</button>
					<button type="button" class="btn gray2" onclick="closeModal()">취소</button>
				</div>				
			</div> 
		</li>
		<li class="info_time"><span>이전로그인 2025.12.05 15:17 (211.157.234.211)</span></li>
		<li class="zoom-control">
			<div class="icon_btns">				
				<div class="zoom_btn" aria-label="확대"><i class="xi-zoom-in"></i></div>
				<div class="zoom_btn" aria-label="축소"><i class="xi-zoom-out"></i></div>
				<div class="zoom_btn" aria-label="새로고침"><i class="xi-refresh"></i></div>
			</div>
			<script>
			var WIDGET_SETTING_LIST = [];
	  		
		   	$(document).ready(function() {
				widgetSetting();
				/* widgetSettingColor(); */
		   	});
		   	
		   	function popLectEvalModal() {
		   		setCookie("popLectEvalYn", "Y", 1); // 1일
		   		window.parent.closeModal();
		   	}
		   	
		   	function widgetSetting() {
				// 과제 유형에 따라 분기
		        var url = "/dashboard/widgetSettingChk.do";
				var data = {
					userId: "${userId}"
				};
				
				ajaxCall(url, data, function(data) {
				    if (data.result > 0) {
				    	var html = "";
		        			html +="<div class='info-tit'>"
		        			html +="	<span>사용할 위젯을 선택하세요</span>"
		        			html +="</div>"
		        			html +="<div class='widget-list'>"
		        			html +="	<span class='custom-input'>"
					    	html +="		<input type='checkbox' " + "id='" + data.data.widgetId1 + "' " + "name='" + data.data.widgetId1 + "' " + "data-posx='" + data.data.posX1 + "' " + "data-posy='" + data.data.posY1 + "' " + "data-posw='" + data.data.posW1 + "' " + "data-posh='" + data.data.posH1 + "' " + "data-visible-yn='" + data.data.visibleYn1 + "' " + "data-widget-name='" + data.data.widgetName1 + "'>";
					    	html +="		<label for=" + data.data.widgetId1 + ">TODAY</label>"
					    	html +="	</span>"
		 					html +="	<span class='custom-input'>"
		 					html +="  		<input type='checkbox' " + "id='" + data.data.widgetId2 + "' " + "name='" + data.data.widgetId2 + "' " + "data-posx='" + data.data.posX2 + "' " + "data-posy='" + data.data.posY2 + "' " + "data-posw='" + data.data.posW2 + "' " + "data-posh='" + data.data.posH2 + "' " + "data-visible-yn='" + data.data.visibleYn2 + "' " + "data-widget-name='" + data.data.widgetName2 + "'>";
		 					html +="		<label for=" + data.data.widgetId2 + ">알림</label>"
		 					html +="	</span>"
		 					html +="	<span class='custom-input'>"
							html +="		<input type='checkbox' " + "id='" + data.data.widgetId3 + "' " + "name='" + data.data.widgetId3 + "' " + "data-posx='" + data.data.posX3 + "' " + "data-posy='" + data.data.posY3 + "' " + "data-posw='" + data.data.posW3 + "' " + "data-posh='" + data.data.posH3 + "' " + "data-visible-yn='" + data.data.visibleYn3 + "' " + "data-widget-name='" + data.data.widgetName3 + "'>";
							html +="		<label for=" + data.data.widgetId3 + ">공지사항</label>"
							html +="	</span>"
							html +="	<span class='custom-input'>"
							html +="		<input type='checkbox' " + "id='" + data.data.widgetId4 + "' " + "name='" + data.data.widgetId4 + "' " + "data-posx='" + data.data.posX4 + "' " + "data-posy='" + data.data.posY4 + "' " + "data-posw='" + data.data.posW4 + "' " + "data-posh='" + data.data.posH4 + "' " + "data-visible-yn='" + data.data.visibleYn4 + "' " + "data-widget-name='" + data.data.widgetName4 + "'>";
							html +="		<label for=" + data.data.widgetId4 + ">이달의 학사일정</label>"
							html +="	</span>"
							html +="	<span class='custom-input'>"
							html +="		<input type='checkbox' " + "id='" + data.data.widgetId5 + "' " + "name='" + data.data.widgetId5 + "' " + "data-posx='" + data.data.posX5 + "' " + "data-posy='" + data.data.posY5 + "' " + "data-posw='" + data.data.posW5 + "' " + "data-posh='" + data.data.posH5 + "' " + "data-visible-yn='" + data.data.visibleYn5 + "' " + "data-widget-name='" + data.data.widgetName5 + "'>";
							html +="		<label for=" + data.data.widgetId5 + ">강의Q&A</label>"
							html +="	</span>"
							html +="	<span class='custom-input'>"
							html +="		<input type='checkbox' " + "id='" + data.data.widgetId6 + "' " + "name='" + data.data.widgetId6 + "' " + "data-posx='" + data.data.posX6 + "' " + "data-posy='" + data.data.posY6 + "' " + "data-posw='" + data.data.posW6 + "' " + "data-posh='" + data.data.posH6 + "' " + "data-visible-yn='" + data.data.visibleYn6 + "' " + "data-widget-name='" + data.data.widgetName6 + "'>";
							html +="		<label for=" + data.data.widgetId6 + ">1:1상담</label>"
							html +="	</span>"
							html +="	<span class='custom-input'>"
							html +="		<input type='checkbox' " + "id='" + data.data.widgetId7 + "' " + "name='" + data.data.widgetId7 + "' " + "data-posx='" + data.data.posX7 + "' " + "data-posy='" + data.data.posY7 + "' " + "data-posw='" + data.data.posW7 + "' " + "data-posh='" + data.data.posH7 + "' " + "data-visible-yn='" + data.data.visibleYn7 + "' " + "data-widget-name='" + data.data.widgetName7 + "'>";
							html +="		<label for=" + data.data.widgetId7 + ">강의목록</label>"
							html +="	</span>"
							html +="</div>"
						    
				        	$(".widget_set_group").empty().append(html);

					    	/* $(".table").footable(); */
					    	/* $('.ui.rating').rating({interactive : false}); */
					    	
					    	for (var i = 1; i <= 7; i++) {
					    	    var key = "visibleYn" + i;
					    	    var widgetId = data.data.widgetId1.slice(0, -1);
					    	    
					    	    if (data.data[key] === 'Y') {
					    	        $("#"+ widgetId + i).prop("checked", true);
					    	    }
					    	}
				    } else {
				        alert(data.message);
				    }
				}, function(xhr, status, error) {
				    alert("<spring:message code='fail.common.msg' />");
				}, true);
			}
		   	
		   	function widgetSettingColor() {
				// 과제 유형에 따라 URL 분기(개인, 팀)
		        var url = "/dashboard/widgetSettingColor.do";
				var data = {};
				
				ajaxCall(url, data, function(data) {
				    if (data.result > 0) {
				    	var html = "";
				    		html +="<div class='info-tit'>"
				    		html +="	<span>컬러를 선택하세요</span>"
				    		html +="</div>"
				    		html +="<div class='widget-list'>"
						    html +="	<span class='custom-input'>"
						    html +="		<input type='radio' id='color1' name='color' checked>"
						    html +="		<label for='color1'>기본</label>"
					        html +="	</span>"
					        html +="	<span class='custom-input'>"
					        html +="		<input type='radio' id='color2' name='color'>"
					        html +="		<label for='color2'>블루</label>"
					        html +="	</span>"
					        html +="	<span class='custom-input'>"
					        html +="		<input type='radio' id='color3' name='color'>"
					        html +="		<label for='color3'>민트</label>"
					        html +="	</span>"
					        html +="	<span class='custom-input'>"
							html +="		<input type='radio' id='color4' name='color'>"
							html +="		<label for='color4'>오렌지</label>"
							html +="	</span>"
							html +="	<span class='custom-input'>"
							html +="		<input type='radio' id='color5' name='color'>"
							html +="		<label for='color5'>레드</label>"
							html +="	</span>"
							html +="	<span class='custom-input'>"
							html +="		<input type='radio' id='color6' name='color'>"
							html +="		<label for='color6'>퍼플</label>"
							html +="	</span>"
							html +="</div>"
							      
				        	$(".widget_set_group_color").empty().append(html);

					    	/* $(".table").footable();
					    	$('.ui.rating').rating({interactive : false}); */
					    	
				    	    if (data.data.color === 'COLOR1') {
				    	        $("#color1").prop("checked", true);
				    	    } else if (data.data.color === 'COLOR2') {
				    	    	$("#color2").prop("checked", true);
				    	    } else if (data.data.color === 'COLOR3') {
				    	    	$("#color3").prop("checked", true);
				    	    } else if (data.data.color === 'COLOR4') {
				    	    	$("#color4").prop("checked", true);
				    	    } else if (data.data.color === 'COLOR5') {
				    	    	$("#color5").prop("checked", true);
				    	    } else if (data.data.color === 'COLOR6') {
				    	    	$("#color6").prop("checked", true);
				    	    }
				    } else {
				        alert(data.message);
				    }
				}, function(xhr, status, error) {
				    alert("<spring:message code='fail.common.msg' />");
				}, true);
			}
		   	
		   	function setCookie(name, value, days) {
			    var expires = "";
			    if (days) {
			        var date = new Date();
			        date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
			        expires = "; expires=" + date.toUTCString();
			    }
			    document.cookie = name + "=" + value + expires + "; path=/";
			}
			
			function closeModal() {
			    location.reload();
			}
			
			function saveWidgetSetting() {
			  var widgets = [];
			  
			  // 1. 체크박스
			  $(".widget_set_group input[type='checkbox']").each(function() {
				  let widget = {
				    widgetId:   $(this).attr("id"),
				    widgetName: $(this).data("widgetName"),
				    posX:       $(this).data("posx"),
				    posY:       $(this).data("posy"),
				    posW:       $(this).data("posw"),
				    posH:       $(this).data("posh"),
				    visibleYn:  $(this).is(":checked") ? "Y" : "N",
				    userGbn:    "${userGbn}"
				  };

				  widgets.push(widget);
			  });

			  // 2. 라디오 버튼 값 수집
			  var selectedColor = $(".radio-group input[type='radio']:checked").attr("id");
			  
			  // 3. JSON 데이터 구성
			  var data = {
			    widgets: widgets,
			    color: selectedColor,
			    userId: "${userId}"
			  };
			  
			  // 4. AJAX 전송
			  $.ajax({
			    url: "/dashboard/saveWidgetSetting.do",
			    type: "POST",
			    data: JSON.stringify(data),
			    contentType: "application/json; charset=utf-8",
			    dataType: "json",
			    success: function(result) {
			    	
			    switch (selectedColor) {
			        case "color1":
			            document.body.style.backgroundColor = "red";  // 바디 배경을 빨간색으로
			            break;
			        case "color2":
			        	document.body.style.backgroundColor = "red";  // 바디 배경을 빨간색으로
			            break;
			        case "color3":
			        	document.body.style.backgroundColor = "red";  // 바디 배경을 빨간색으로
			            break;
			        case "color4":
			        	document.body.style.backgroundColor = "red";  // 바디 배경을 빨간색으로
			            break;
			        case "color5":
			        	document.body.style.backgroundColor = "red";  // 바디 배경을 빨간색으로
			            break;
			        case "color6":
			            baseScore = 60;
			            break;
			        default:
			            break;
			    }

			      alert("변경사항이 저장되었습니다.");
			      console.log("서버 응답:", result);
			      closeModal();
			    },
			    error: function(xhr, status, error) {
			      console.error("저장 실패:", error);
			      alert("저장 중 오류가 발생했습니다.");
			    }
			  });
			}
			
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
			<a href="#0" data-medi-ui="mode"><i class="icon-svg-moon-star" aria-hidden="true"></i></a>    
		</li>				
		<li class="log">
			<a href="/user/userHome/logout.do"><i class="icon-svg-logout" aria-hidden="true"></i></a>
		</li>
		
	</ul>
		
</header>
