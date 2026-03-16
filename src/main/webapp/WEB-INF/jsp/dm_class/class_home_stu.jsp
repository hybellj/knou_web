<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/dm_inc/home_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/dm_assets/css/classroom.css" />
<script src="/webdoc/dm_assets/js/d3.v4/d3.v4.js"></script><!-- chart d3.js -->

<body class="class colorA "><!-- 컬러선택시 클래스변경 -->
	<div id="wrap" class="main">
		<!-- common header -->
			<jsp:include page="../dm_inc/class_header.jsp">
            	<jsp:param name="univGbn" value="${univGbn}" />
      		</jsp:include>
		<!-- //common header -->
    
		<!-- classroom -->
		<main class="common">

			<!-- 사이드메뉴 -->
			<%-- <%@ include file="/WEB-INF/jsp/dm_inc/class_gnb_prof.jsp" %> --%>
			<jsp:include page="/WEB-INF/jsp/dm_inc/class_gnb_stu.jsp">
	            <jsp:param name="menuType" value="${menuType}" />
	            <jsp:param name="menuGbn" value="${menuGbn}" />
	            <jsp:param name="orgId" value="${orgId}" />
	      	</jsp:include>
			<!-- //사이드메뉴 -->

			<!-- content -->
			<div id="content" class="content-wrap common">
				<div class="class_sub_top">
					<div class="navi_bar">                                
						<ul>
							<li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
							<li>대시보드</li>
							<li>강의실</li>
							<li><span class="current">내강의실</span></li>                                 
						</ul>                                                                         
					</div>  
					<div class="btn-wrap">
						<div class="first">
							<select class="form-select" style="font-size:15px; pointer-events: none !important;">
							    <option value="">과정(테넌시)</option>
							
							    <option value="univ"
							        ${univGbn == 'UNIV' ? 'selected="selected"' : ''} 
							        ${univGbn == 'UNIV' ? 'disabled="disabled"' : ''}>
							        대학원
							    </option>
							
							    <option value="coll"
							        ${univGbn == 'coll' ? 'selected="selected"' : ''} 
							        ${univGbn == 'coll' ? 'disabled="disabled"' : ''}>
							        학위과정
							    </option>
							</select>
                            
                            <select class="form-select wide">
                                <option value="">학과</option>
                                <option value="정보과학과">정보과학과</option>
                                <option value="정보과학과">정보과학과</option>
                                <option value="실용중국어학과">실용중국어학과</option>
                                <option value="실용중국어학과">실용중국어학과</option>
                                <option value="행정학과">행정학과</option>
                                <option value="행정학과">행정학과</option>
                                <option value="평생교육학과">평생교육학과</option>
                                <option value="평생교육학과">평생교육학과</option>
                                <option value="간호학과">간호학과</option>
                                <option value="간호학과">간호학과</option>
                            </select>
						</div>
						<div class="sec">
							<button type="button" class="btn type1"><i class="xi-book-o"></i>학습자 매뉴얼</button>
							<button type="button" class="btn type1" onclick="location.href='/dashboard/dashboard.do'"><i class="xi-info-o"></i>강의실 나가기</button>
						</div>                          
					</div>
				</div>  

				<div class="class_sub">
					<!-- 강의실 상단 -->
					<div class="segment class-area stu">
						<div class="info-left">
							<div class="class_info">
								<p class="labels">
									<label class="label uniA">대학원</label>
								</p>    
								<h2>데이터베이스의 이해와 활용 1반</h2>                                
							</div>
							<div class="class_detail">
							    <div class="detail_txt">
									<p class="desc">
										<span>교수:<strong>홍길동</strong></span>
										<span>튜터:<strong>김여름</strong></span>
										<span>학점:<strong>3학점</strong></span>
								    </p>
									<p class="desc">
										<span>학습기간:<strong>2025.06.02 ~ 2025.06.10</strong></span>
									</p>
								</div>
							
								<div class="classSection">                        
									<div class="cls_btn">
										<a href="#0" class="btn"><em>강의</em>계획서</a>
										<a href="#0" class="btn"><em>평가</em>기준</a>
										<!-- <a href="/dashboard/main.do" class="btn"><em>강의실</em>나가기</a> -->
									</div>
								</div>
							</div>                            
						</div>
						
				    	<div class="info-right">
							<div class="flex">
								<div class="item_list">
									<div class="item user">
										<div class="item_icon"><i class="icon-svg-group" aria-hidden="true"></i></div>
										<div class="item_tit">
											<a href="#0" class="btn ">접속현황<i class="xi-angle-down-min"></i></a>
										    <!-- 접속 현황 레이어 -->
											<div class="user-option-wrap">
												<div class="option_head">
													<div class="sort_btn"> 
														<button type="button">이름<i class="sort xi-long-arrow-up" aria-hidden="true"></i></button>
														<button type="button">이름<i class="sort xi-long-arrow-down" aria-hidden="true"></i></button>
													</div>
													<p class="user_num">접속: 37</p>
													<button type="button" class="btn-close" aria-label="접속현황 닫기"><i class="icon-svg-close"></i></button>
												</div>                                                
												<ul class="user_area">
													<li>
														<div class="user-info">
															<div class="user-photo">
																<img src="/webdoc/dm_assets/img/common/photo_user_sample2.jpg" aria-hidden="true" alt="사진">
															</div>
															<div class="user-desc">
																<p class="name">나방송</p>
																<!-- <p class="subject"><span class="major">[대학원]</span>정보와기술</p> -->
															</div> 
															<!-- <div class="btn_wrap">
																<button type="button"><i class="xi-info-o"></i></button> 
																<button type="button"><i class="xi-bell-o"></i></button>
															</div> -->                                                         
														</div>
													</li>
													<li>
														<div class="user-info">
															<div class="user-photo">
																<img src="/webdoc/dm_assets/img/common/photo_user_sample3.jpg" aria-hidden="true" alt="사진">
															</div>
															<div class="user-desc">
																<p class="name">최남단</p>
																<!-- <p class="subject"><span class="major">[대학원]</span>데이터베이스의 이해와 활용</p> -->
															</div> 
															<!-- <div class="btn_wrap">
																<button type="button"><i class="xi-info-o"></i></button> 
																<button type="button"><i class="xi-bell-o"></i></button>
															</div> -->                                                            
														</div>
													</li>
													<li>
														<div class="user-info">
															<div class="user-photo">
																<img src="/webdoc/dm_assets/img/common/photo_user_sample2.jpg" aria-hidden="true" alt="사진">
															</div>
															<div class="user-desc">
																<p class="name">나방송</p>
																<!-- <p class="subject"><span class="major">[대학원]</span>정보와기술</p> -->
															</div> 
															<!-- <div class="btn_wrap">
																	<button type="button"><i class="xi-info-o"></i></button> 
																	<button type="button"><i class="xi-bell-o"></i></button>
															</div> -->                                                         
													    </div>
													</li>
													<li>
														<div class="user-info">
															<div class="user-photo">
																<img src="/webdoc/dm_assets/img/common/photo_user_sample2.jpg" aria-hidden="true" alt="사진">
															</div>
															<div class="user-desc">
																<p class="name">최남단</p>
																<!-- <p class="subject"><span class="major">[대학원]</span>데이터베이스의 이해와 활용</p> -->
															</div> 
															<!-- <div class="btn_wrap">
																<button type="button"><i class="xi-info-o"></i></button> 
																<button type="button"><i class="xi-bell-o"></i></button>
															</div> -->                                                            
														</div>
													</li>
													<li>
														<div class="user-info">
															<div class="user-photo">
																<img src="/webdoc/dm_assets/img/common/photo_user_sample3.jpg" aria-hidden="true" alt="사진">
															</div>
															<div class="user-desc">
																<p class="name">최남단</p>
																<!-- <p class="subject"><span class="major">[대학원]</span>데이터베이스의 이해와 활용</p> -->
															</div> 
															<!-- <div class="btn_wrap">
																<button type="button"><i class="xi-info-o"></i></button> 
																<button type="button"><i class="xi-bell-o"></i></button>
															</div> -->                                                            
														</div>
												    </li>
												</ul>
											                
											</div>
											<!-- //접속 현황 레이어 -->                                        
										</div>
										<div class="item_info">
										    <span class="big">37</span>
										    <span class="small">250</span>
										</div>                                                                            
									</div>
									
									<div class="item week">
										<div class="item_icon"><i class="icon-svg-calendar-check-02" aria-hidden="true"></i></div>
										<div class="item_tit">2025.04.14 ~ 04.20</div>
										<div class="item_info">
											<span class="big">7</span>
											<span class="small">주차</span>
										</div>
									</div>
								</div>
								
								<div class="chart_list">
									<div class="chart_my">
										<div class="chart_wrap">
										<div id="arcMy" class="donut_chart"></div>
										<div class="middle_text">
											<span class="chart_value_my"></span>
											<span><em>나의</em><em>진도율</em></span>
										</div>
									</div>                                    
								</div>
	
								<div class="chart_average">
									<div class="chart_wrap">
										<div id="arcAverage" class="donut_chart"></div>
										<div class="middle_text">
											<span class="chart_value_average"></span>
											<span><em>평균</em><em>진도율</em></span>
										</div>
									</div>
								</div>
	
								<script>
									$(document).ready(function () {
								
								        // 나의 진도율 차트 그리기
								        function drawChartMy() {
								            var containerWidth = $('#arcMy').width();
								            var size = Math.min(containerWidth, 140);
								            var width = size;
								            var height = size;
								            var outerRadius = size / 2 * 0.98; // 90% 크기
								            var innerRadius = outerRadius * 0.7;
								
								            d3.select("#arcMy").selectAll("svg").remove();
								
								            function fn_getArc(ammount, total) {
								                return d3.arc()
								                    .innerRadius(innerRadius)
								                    .outerRadius(outerRadius)
								                    .startAngle(0)
								                    .endAngle(fn_getPercent_pie(ammount, total))
								                    .cornerRadius(100);
								            }
								
								            // pie 각도 함수
								            function fn_getPercent_pie(ammount, total) {
								                var ratio = ammount / total;
								                return Math.PI * 2 * ratio;
								            }
								
								            // 데이터
								            var data = { cnt: 70, all: 100 };
								
								            var svg = d3.select("#arcMy")
								                .append("svg")
								                .attr("width", width)
								                .attr("height", height)
								                .append("g")
								                .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");
								
								            // 그라데이션 정의
								            var defs = svg.append("defs");
								
								            var gradient = defs.append("linearGradient")
								                .attr("id", "attendanceGradientMy")
								                .attr("x1", "0%").attr("y1", "0%")
								                .attr("x2", "100%").attr("y2", "100%");
								
								            gradient.append("stop")
								                .attr("offset", "0%")
								                .attr("stop-color", "#E25DCA");
								
								            gradient.append("stop")
								                .attr("offset", "100%")
								                .attr("stop-color", "#F283DD");
								
								            // 배경
								            svg.append("path")
								                .attr("class", "arc")
								                .attr("d", fn_getArc(100, 100))
								                .attr("fill", "#EBEBEB");
								
								            // 실제 데이터
								            svg.append("path")
								                .attr("class", "arcMy")
								                .attr("d", fn_getArc(data.cnt, data.all))
								                .attr("fill", "url(#attendanceGradientMy)");
								
								            // 중앙 텍스트 업데이트
								            $('.chart_value_my').text(data.cnt + '%'); 
								        }
								
								        // 평균 진도율 차트 그리기
								        function drawChartAverage() {
								            var containerWidth = $('#arcAverage').width();
								            var size = Math.min(containerWidth, 140);
								            var width = size;
								            var height = size;
								            var outerRadius = size / 2 * 0.98; // 90% 크기
								            var innerRadius = outerRadius * 0.7;
								
								            d3.select("#arcAverage").selectAll("svg").remove();
								
								            function fn_getArc(ammount, total) {
								                return d3.arc()
								                    .innerRadius(innerRadius)
								                    .outerRadius(outerRadius)
								                    .startAngle(0)
								                    .endAngle(fn_getPercent_pie(ammount, total))
								                    .cornerRadius(100);
								            }
								
								            // pie 각도 함수
								            function fn_getPercent_pie(ammount, total) {
								                var ratio = ammount / total;
								                return Math.PI * 2 * ratio;
								            }
								
								            // 데이터
								            var data = { cnt: 60, all: 100 };
								
								            var svg = d3.select("#arcAverage")
								                .append("svg")
								                .attr("width", width)
								                .attr("height", height)
								                .append("g")
								                .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");
								
								            // 그라데이션 정의
								            var defs = svg.append("defs");
								
								            var gradient = defs.append("linearGradient")
								                .attr("id", "attendanceGradientAverage")
								                .attr("x1", "0%").attr("y1", "0%")
								                .attr("x2", "100%").attr("y2", "100%");
								
								            gradient.append("stop")
								                .attr("offset", "0%")
								                .attr("stop-color", "#41A5EC");
								
								            gradient.append("stop")
								                .attr("offset", "100%")
								                .attr("stop-color", "#84C2EE");
								
								            // 배경
								            svg.append("path")
								                .attr("class", "arc")
								                .attr("d", fn_getArc(100, 100))
								                .attr("fill", "#EBEBEB");
								
								            // 실제 데이터
								            svg.append("path")
								                .attr("class", "arc")
								                .attr("d", fn_getArc(data.cnt, data.all))
								                .attr("fill", "url(#attendanceGradientAverage)");
								
								            // 중앙 텍스트 업데이트
								            $('.chart_value_average').text(data.cnt + '%'); 
								        }
								
								        // 차트 그리기
								        drawChartMy();
								        drawChartAverage();
								
								        // 창 크기 변경 시 다시 그리기
								        $(window).resize(function () {
								            drawChartMy();
								            drawChartAverage();
								        });
								    });
								</script>
							</div>
	
						</div>
	
					</div>
	                        
				</div>
				<!-- //강의실 상단 -->
                    
				<div class="segment-row">

					<!-- 공지사항 -->
					<div class="segment">
                            <div class="box_title">  
                                <i class="icon-svg-notice"></i>                     
                                <h3 class="h3">과목 공지사항</h3>
                                <div class="btn-wrap">
                                    <a href="#0" class="btn_more"><i class="xi-plus"></i></a>
                                </div>
                            </div>
                            <div class="box_content">
                                <ul class="dash_item_listA">
                                    <li class="dot">                                       
                                        <a href="#0" class="item_txt">                                            
                                            <p class="tit">1학기 성적처리 기준 안내입니다.</p>
                                            <p class="desc">
                                                <span class="date">2025.05.17</span> 
                                            </p>
                                        </a>
                                        <div class="state">
                                            <label class="label check_no">읽지않음</label>
                                        </div>
                                    </li>
                                    <li class="dot">                                       
                                        <a href="#0" class="item_txt">                                            
                                            <p class="tit">퀴즈가 등록되었습니다.</p>
                                            <p class="desc">
                                                <span class="date">2025.05.17</span> 
                                            </p>
                                        </a>
                                        <div class="state">
                                            <label class="label check_ok">읽음</label>
                                        </div>
                                    </li>
                                    <li class="dot">                                        
                                        <a href="#0" class="item_txt">                                            
                                            <p class="tit">중간고사 기간 안내입니다.</p>
                                            <p class="desc">
                                                <span class="date">2025.05.17</span> 
                                            </p>
                                        </a>
                                        <div class="state">
                                            <label class="label check_ok">읽음</label>
                                        </div>
                                    </li>
                                </ul>  
                            </div>

                        </div>

                        <!-- 강의Q&A -->
                        <div class="segment">
                            <div class="box_title">
                                <i class="icon-svg-question"></i>
                                <h3 class="h3">강의 Q&A <small class="msg_num">1</small></h3>
                                <div class="btn-wrap">
                                    <a href="#0" class="btn_more"><i class="xi-plus"></i></a>
                                </div>
                            </div>
                            <div class="box_content">
                                <ul class="dash_item_listA">
                                    <li>
                                        <div class="user">
                                           <span class="user_img"></span>
                                        </div>
                                        <a href="#0" class="item_txt">                                            
                                            <p class="tit">과제 제출 언제까지 인가요?</p>
                                            <p class="desc">
                                                <span class="name">김길동</span> 
                                                <span class="date">2025.05.17</span> 
                                            </p>
                                        </a>
                                        <div class="state">
                                            <label class="label check_no">미답변</label>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="user">
                                           <span class="user_img"><img src="/webdoc/dm_assets/img/common/photo_user_sample2.jpg" aria-hidden="true" alt="사진"></span>
                                        </div>
                                        <a href="#0" class="item_txt">                                            
                                            <p class="tit">강의 내용 중에 이해가 안되는 부분이 있습니다.</p>
                                            <p class="desc">
                                                <span class="name">김길동</span> 
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
                                                <span class="name">김길동</span> 
                                                <span class="date">2025.05.17</span> 
                                            </p>
                                        </a>
                                        <div class="state">
                                            <label class="label check_reply">답변</label>
                                        </div>
                                    </li>
                                </ul>                               
							</div>      

                        </div>

                        <!-- 자료실 -->
                        <div class="segment">
                            <div class="box_title">  
                                <i class="icon-svg-save"></i>                     
                                <h3 class="h3">강의자료실</h3>
                                <div class="btn-wrap">
                                    <a href="#0" class="btn_more"><i class="xi-plus"></i></a>
                                </div>
                            </div>
                            <div class="box_content">
                                <ul class="dash_item_listA">
                                    <li class="dot">                                       
                                        <a href="#0" class="item_txt">                                            
                                            <p class="tit">1주차 강의자료 업로드</p>
                                            <p class="desc">
                                                <span class="date">2025.05.17</span> 
                                            </p>
                                        </a>
                                        <div class="state">
                                            <a href="#0" class="btn btn_down">다운로드</a>
                                        </div>
                                    </li>
                                    <li class="dot">                                       
                                        <a href="#0" class="item_txt">                                            
                                            <p class="tit">실전 NoSQL 데이터베이스 활용 자료입니다.</p>
                                            <p class="desc">
                                                <span class="date">2025.05.17</span> 
                                            </p>
                                        </a>
                                        <div class="state">
                                            <a href="#0" class="btn btn_down">다운로드</a>
                                        </div>
                                    </li>
                                    <li class="dot">                                        
                                        <a href="#0" class="item_txt">                                            
                                            <p class="tit">SQL 성능 튜닝 예제 모음집</p>
                                            <p class="desc">
                                                <span class="date">2025.05.17</span> 
                                            </p>
                                        </a>
                                        <div class="state">
                                            <a href="#0" class="btn btn_down">다운로드</a>
                                        </div>
                                    </li>
                                </ul>  
                            </div>

                        </div>
                        
                    </div>

                    <div class="segment">
                        <div class="state-info-label">
                            <p class="pre"><i class="icon-svg-state"></i>학습 미진행</p>
                            <p class="ok"><i class="icon-svg-state"></i>학습완료</p>
                            <p class="ing"><i class="icon-svg-state"></i>학습 진행중</p>
                            <p class="no"><i class="icon-svg-state"></i>학습 미완료</p>
                        </div>
                        <div class="week_area"> 
                            <div class="info-week">                    
                                <div class="title">학습현황</div>
                                <div class="week_state_list">
                                    <div class="state">
                                        <div class="state_icon ok" aria-label="학습완료"><i class="icon-svg-state"></i></div>                                
                                        <span class="week">1</span>                                                               
                                    </div>
                                    <div class="state">
                                        <div class="state_icon ok" aria-label="학습완료"><i class="icon-svg-state"></i></div>                                
                                        <span class="week">2</span>                                                               
                                    </div>
                                    <div class="state">
                                        <div class="state_icon ok" aria-label="학습완료"><i class="icon-svg-state"></i></div>                                
                                        <span class="week">3</span>                                                               
                                    </div>
                                    <div class="state">
                                        <div class="state_icon ok" aria-label="학습완료"><i class="icon-svg-state"></i></div>                                
                                        <span class="week">4</span>                                                               
                                    </div>
                                    <div class="state">
                                        <div class="state_icon ok" aria-label="학습완료"><i class="icon-svg-state"></i></div>                                
                                        <span class="week">5</span>                                                               
                                    </div>
                                    <div class="state">
                                        <div class="state_icon no" aria-label="학습 미완료"><i class="icon-svg-state"></i></div>                                
                                        <span class="week">6</span>                                                               
                                    </div>
                                    <div class="state">
                                        <div class="state_icon ok" aria-label="학습완료"><i class="icon-svg-state"></i></div>                                
                                        <span class="week">7</span>                                                               
                                    </div>
                                    <div class="state">
                                        <div class="state_icon test_ok" aria-label="시험 완료"><i class="icon-svg-state"></i></div>                                
                                        <span class="week">중간</span>                                                               
                                    </div>
                                    <div class="state">
                                        <div class="state_icon ing" aria-label="학습 진행중"><i class="icon-svg-state"></i></div>                                
                                        <span class="week">9</span>                                                               
                                    </div>
                                    <div class="state">
                                        <div class="state_icon" aria-label="학습 미진행"><i class="icon-svg-state"></i></div>                                
                                        <span class="week">10</span>                                                               
                                    </div>
                                    <div class="state">
                                        <div class="state_icon" aria-label="학습 미진행"><i class="icon-svg-state"></i></div>                                
                                        <span class="week">11</span>                                                               
                                    </div>
                                    <div class="state">
                                        <div class="state_icon" aria-label="학습 미진행"><i class="icon-svg-state"></i></div>                                
                                        <span class="week">12</span>                                                               
                                    </div>
                                    <div class="state">
                                        <div class="state_icon" aria-label="학습 미진행"><i class="icon-svg-state"></i></div>                                
                                        <span class="week">13</span>                                                               
                                    </div>
                                    <div class="state">
                                        <div class="state_icon" aria-label="학습 미진행"><i class="icon-svg-state"></i></div>                                
                                        <span class="week">14</span>                                                               
                                    </div>
                                    <div class="state">
                                        <div class="state_icon test" aria-label="시험 미진행"><i class="icon-svg-state"></i></div>                                
                                        <span class="week">기말</span>                                                               
                                    </div>
                                    
                                </div>
                            </div>
                            <div class="info-set">
                                <i class="icon-svg-alarm-clock" aria-hidden="true"></i>
                                <div class="info">
                                    <p class="point">
                                        <span class="tit">중간고사:</span>
                                        <span>2025.04.26 16:00</span>
                                    </p>
                                    <p class="desc">
                                        <span class="tit">시간:</span>
                                        <span>40분</span>
                                    </p>                                                       
                                </div>
                                <div class="info">
                                    <p class="point">
                                        <span class="tit">기말고사:</span>
                                        <span>2025.07.02 16:00</span>
                                    </p>
                                    <p class="desc">
                                        <span class="tit">시간:</span>
                                        <span>40분</span>
                                    </p>                                                       
                                </div>
                            </div>
                        </div>
                        

                        <div class="board_top">
                            <i class="icon-svg-openbook"></i>
                            <h3 class="board-title">강의목록</h3>                            
                            <div class="right-area">
                                <button type="button" class="btn basic">주차 접음</button>
                                <select class="form-select">
                                    <option value="전체 주차">전체 주차</option>
                                    <option value="1주차">1주차</option>
                                    <option value="2주차">2주차</option>
                                    <option value="3주차">3주차</option>
                                    <option value="4주차">4주차</option>
                                    <option value="5주차">5주차</option>
                                </select>
                                <a href="#0" class="btn_list_type on" aria-label="리스트형 보기"><i class="icon-svg-list" aria-hidden="true"></i></a>
                                <a href="#0" class="btn_list_type" aria-label="카드형 보기"><i class="icon-svg-grid" aria-hidden="true"></i></a>
                            </div>                         
                        </div>                        
						
						<!-- 강의목록 -->
						<div class="course_list">
                            <ul class="accordion course_week">
                                <li class="active"><!-- 클릭시 active 추가 -->
                                    <div class="title-wrap"> 
                                        <a class="title" href="#">
                                            <i class="arrow xi-angle-down"></i> 
                                            <strong>[1주차] 1강. 번역입문</strong>
                                            <p class="labels">
                                                <label class="label s_online">온라인</label>
                                                <label class="label s_finish">마감</label>
                                                <label class="label s_ing">공개</label>
                                            </p>                                             
                                            <p class="desc">
                                                <span>학습기간<strong>2025.03.04 ~ 2025.03.09 / 106분</strong></span>
                                            </p>
                                        </a>                                        
                                        <div class="btn_right">
											<div class="desc_info">
												<span>진도율<strong class="navy">52%</strong></span>
											</div>
                                            <button class="btn s_basic down">음성</button>
                                            <button class="btn s_type2">강의보기</button>
                                        </div>                                                                    
                                    </div>

                                    <div class="cont">                                        
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">텍스트</label>
                                                </p>   
                                                <strong>학습개요</strong>
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">동영상</label>
                                                </p>   
                                                <strong>학습하기</strong>
                                            </div>
                                            <div class="btn_right">
                                                <div class="desc_info">
                                                    <span>진도율<strong class="navy">52%</strong></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_work">과제</label>
                                                </p>   
                                                <strong>ER 다이어그램을 그리고 그것을 관계형 모델로 변환해보기</strong>
                                            </div>
                                            <div class="btn_right mr">
                                            	<p class="desc">
                                                	<span>기간 <strong> 2025.03.06 10:00 ~ 2025.04.12 22:00&nbsp;&nbsp;</strong></span>
                                                	<button class="btn s_basic">과제제출<i class="icon-svg-arrow"></i></button>
                                            	</p>
                                            	
                                            </div>
                                        </div>
										<div class="lecture_box">
										    <div class="lecture_tit">
												<p class="labels">                                                    
													<label class="label s_debate">토론</label>
												</p>   
												<strong>찬반토론</strong>
											</div>
											<div class="btn_right mr">
												<p class="desc">
													<span>기간 <strong> 2025.03.06 10:00 ~ 2025.04.12 22:00&nbsp;&nbsp;</strong></span>
													<button class="btn s_basic">토론참여<i class="icon-svg-arrow"></i></button>
												</p>
											</div>
										</div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">                                                    
                                                    <label class="label s_basic">자료</label>
                                                </p>   
                                                <strong>PDF : 학습자료제목</strong>
                                            </div>
                                            <div class="btn_right mr">                                               
                                                <button class="btn s_basic down">학습자료</button>                                                
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">                                                    
                                                    <label class="label s_basic">자료</label>
                                                </p>   
                                                <strong>웹링크 : 학습자료제목 학습자료제목 2</strong>
                                            </div>
                                            <div class="btn_right mr">                                               
                                                <button class="btn s_basic">학습자료 <i class="icon-svg-link" aria-hidden="true"></i></button>                                                
                                            </div>
                                        </div>
                                    </div>
                                </li>
                                
                                <li class=""><!-- 클릭시 active 추가 -->
                                    <div class="title-wrap"> 
                                        <a class="title" href="#">
                                            <i class="arrow xi-angle-down"></i> 
                                            <strong>[2주차] 2강. 무생물주어의 처리</strong>
                                            <p class="labels">
                                                <label class="label s_online">온라인</label>
                                                <label class="label s_finish">마감</label>
                                                <label class="label s_ing">공개</label>
                                            </p>                                             
                                            <p class="desc">
                                                <span>학습기간<strong>2025.03.10 ~ 2025.03.16 / 98분</strong></span>
                                            </p>
                                        </a>                                        
                                        <div class="btn_right">
                                        	<div class="desc_info">
												<span>진도율<strong class="navy">52%</strong></span>
											</div>
                                            <button class="btn s_basic down">음성</button>
                                            <button class="btn s_type2">강의보기</button>
                                        </div>                                                                    
                                    </div>

                                    <div class="cont">                                        
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">텍스트</label>
                                                </p>   
                                                <strong>학습개요</strong>
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">동영상</label>
                                                </p>   
                                                <strong>오늘의 학습</strong>
                                            </div>
                                            <div class="btn_right">
                                            	<div class="desc_info">
                                                    <span>진도율<strong class="navy">52%</strong></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">텍스트</label>
                                                </p>   
                                                <strong>구글 클래스룸 사용법</strong>
                                            </div>
                                            <div class="btn_right">
                                            	<!-- <div class="desc_info">
                                                    <span>진도율<strong class="navy">52%</strong></span>
                                                </div> -->
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">동영상</label>
                                                </p>   
                                                <strong>학습하기 ① - make를 활용한 무생물주어</strong>
                                            </div>
                                            <div class="btn_right">
                                            	<div class="desc_info">
                                                    <span>진도율<strong class="navy">52%</strong></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">시험지</label>
                                                </p>   
                                                <strong>연습문제 ①</strong>
                                            </div>
                                            <div class="btn_right">
                                            	<!-- <div class="desc_info">
                                                    <span>진도율<strong class="navy">52%</strong></span>
                                                </div> -->
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">LTI</label>
                                                </p>   
                                                <strong>복습하기 - 구글 클래스룸 ①</strong>
                                            </div>
                                            <div class="btn_right">
                                            	<!-- <div class="desc_info">
                                                    <span>진도율<strong class="navy">52%</strong></span>
                                                </div> -->
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">동영상</label>
                                                </p>   
                                                <strong>학습하기 ② - 소유격이 포함된 무생물주어</strong>
                                            </div>
                                            <div class="btn_right">
                                            	<div class="desc_info">
                                                    <span>진도율<strong class="navy">52%</strong></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">시험지</label>
                                                </p>   
                                                <strong>연습문제 ②</strong>
                                            </div>
                                            <div class="btn_right">
                                            	<!-- <div class="desc_info">
                                                    <span>진도율<strong class="navy">52%</strong></span>
                                                </div> -->
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">LTI</label>
                                                </p>   
                                                <strong>복습하기 - 구글 클래스룸 ②</strong>
                                            </div>
                                            <div class="btn_right">
                                            	<!-- <div class="desc_info">
                                                    <span>진도율<strong class="navy">52%</strong></span>
                                                </div> -->
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">동영상</label>
                                                </p>   
                                                <strong>학습하기 ③ - 시간을 나타내는 무생물주어</strong>
                                            </div>
                                            <div class="btn_right">
                                            	<div class="desc_info">
                                                    <span>진도율<strong class="navy">52%</strong></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">시험지</label>
                                                </p>   
                                                <strong>연습문제 ③</strong>
                                            </div>
                                            <div class="btn_right">
                                            	<!-- <div class="desc_info">
                                                    <span>진도율<strong class="navy">52%</strong></span>
                                                </div> -->
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">LTI</label>
                                                </p>   
                                                <strong>복습하기 - 구글 클래스룸 ③</strong>
                                            </div>
                                            <div class="btn_right">
                                            	<!-- <div class="desc_info">
                                                    <span>진도율<strong class="navy">52%</strong></span>
                                                </div> -->
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">동영상</label>
                                                </p>   
                                                <strong>학습하기 ④ - 감정 변화를 나타내는 동사 구문</strong>
                                            </div>
                                            <div class="btn_right">
                                            	<div class="desc_info">
                                                    <span>진도율<strong class="navy">52%</strong></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">시험지</label>
                                                </p>   
                                                <strong>연습문제 ④</strong>
                                            </div>
                                            <div class="btn_right">
                                            	<!-- <div class="desc_info">
                                                    <span>진도율<strong class="navy">52%</strong></span>
                                                </div> -->
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">LTI</label>
                                                </p>   
                                                <strong>복습하기 - 구글 클래스룸 ④</strong>
                                            </div>
                                            <div class="btn_right">
                                            	<!-- <div class="desc_info">
                                                    <span>진도율<strong class="navy">52%</strong></span>
                                                </div> -->
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">동영상</label>
                                                </p>   
                                                <strong>학습하기 ⑤ - 기타 무생물주어 구문</strong>
                                            </div>
                                            <div class="btn_right">
                                            	<div class="desc_info">
                                                    <span>진도율<strong class="navy">52%</strong></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">시험지</label>
                                                </p>   
                                                <strong>연습문제 ⑤</strong>
                                            </div>
                                            <div class="btn_right">
                                            	<!-- <div class="desc_info">
                                                    <span>진도율<strong class="navy">52%</strong></span>
                                                </div> -->
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">LTI</label>
                                                </p>   
                                                <strong>복습하기 - 구글 클래스룸 ⑤</strong>
                                            </div>
                                            <div class="btn_right">
                                            	<!-- <div class="desc_info">
                                                    <span>진도율<strong class="navy">52%</strong></span>
                                                </div> -->
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">                                                    
                                                    <label class="label s_debate">토론</label>
                                                </p>   
                                                <strong>찬반토론</strong>
                                            </div>
                                            <div class="btn_right mr">
                                                <p class="desc">
													<span>기간 <strong> 2025.03.06 10:00 ~ 2025.04.12 22:00&nbsp;&nbsp;</strong></span>
												</p>
                                                <button class="btn s_basic">과제제출<i class="icon-svg-arrow"></i></button>                                             
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">                                                    
                                                    <label class="label s_basic">자료</label>
                                                </p>   
                                                <strong>PDF : 학습자료제목</strong>
                                            </div>
                                            <div class="btn_right mr">                                               
                                                <button class="btn s_basic down">학습자료</button>
                                            </div>
                                        </div>


                                    </div>
                                </li>  
                                
                                <li class=""><!-- 클릭시 active 추가 -->
                                    <div class="title-wrap"> 
                                        <a class="title" href="#">
                                            <i class="arrow xi-angle-down"></i> 
                                            <strong>[3주차] 3강. 대명사 지우기</strong>
                                            <p class="labels">
                                                <label class="label s_online">온라인</label>
                                                <label class="label s_finish">마감</label>
                                                <label class="label s_ing">공개</label>
                                            </p>                                             
                                            <p class="desc">
                                                <span>학습기간<strong>2025.03.17 ~ 2025.03.23 / 102분</strong></span>
                                            </p>
                                        </a>                                        
                                        <div class="btn_right">
                                        	<div class="desc_info">
												<span>진도율<strong class="navy">52%</strong></span>
											</div>
                                            <button class="btn s_type2">강의보기</button>
                                        </div>                                                                    
                                    </div>

                                    <div class="cont">
	                                    <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">텍스트</label>
                                                </p>   
                                                <strong>학습개요</strong>
                                            </div>
                                            <div class="btn_right">
                                            	<!-- <div class="desc_info">
                                                    <span>진도율<strong class="navy">52%</strong></span>
                                                </div> -->
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">텍스트</label>
                                                </p>   
                                                <strong>오늘의 학습</strong>
                                            </div>
                                            <div class="btn_right">
                                            	<!-- <div class="desc_info">
                                                    <span>진도율<strong class="navy">52%</strong></span>
                                                </div> -->
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">동영상</label>
                                                </p>   
                                                <strong>학습하기 ① - make를 활용한 무생물주어</strong>
                                            </div>
                                            <div class="btn_right">
                                            	<div class="desc_info">
                                                    <span>진도율<strong class="navy">52%</strong></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">시험지</label>
                                                </p>   
                                                <strong>연습문제 ①</strong>
                                            </div>
                                            <div class="btn_right">
                                            	<!-- <div class="desc_info">
                                                    <span>진도율<strong class="navy">52%</strong></span>
                                                </div> -->
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">LTI</label>
                                                </p>   
                                                <strong>복습하기 - 구글 클래스룸 ①</strong>
                                            </div>
                                            <div class="btn_right">
                                            	<!-- <div class="desc_info">
                                                    <span>진도율<strong class="navy">52%</strong></span>
                                                </div> -->
                                            </div>
                                        </div>
                                        <div class="lecture_box seminar">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_seminar">세미나</label>
                                                </p>   
                                                <strong>화상세미나</strong>
                                            </div>
                                            <div class="seminar_detail">
                                                <div class="row">
                                                    <button class="btn go_seminar">화상 세미나 참여하기</button>
                                                    <div class="desc_info">
                                                        <span>시작일시 :<strong>2025.06.02 16:00</strong></span>
                                                        <span>진행시간 :<strong>1시간 20분</strong></span>
                                                    </div>
                                                </div>
                                                <div class="row message red">
                                                    [중요] 반드시 Zoom Meeting 프로그램을 실행하여 참가해 주세요.<br>
                                                    <span class="caution">Zoom 프로그램이 아닌 브라우저 상의 "브라우저에서 참가"를 클릭하여 입장한 경우에는 출결이 기록되지 않습니다.</span> 
                                                </div>
                                                <div class="row message">
                                                    <div class="list-tit">참가에 실패하는 경우</div>
                                                    <ul class="list-bullet">
                                                        <li>화상강의 참가가 원할히 진행되지 않을 경우 아래 버튼을 클릭하여 시도할 수 있습니다.</li>
                                                        <li>참가 등록 시 아래 표시된 본인 LMS 상의 이메일 주소를 입력해야 자동 출석인정 합니다.</li>
                                                    </ul>

                                                    <div class="list-tit-bg">이메일 직접 등록하여 참가</div>
                                                    <ul class="list-bullet">
                                                        <li>참가 등록시 입력할 이메일 주소 : <strong class="fcRed">아이디@knou.ac.kr</strong></li>
                                                    </ul>
                                                </div>
                                            </div>
                                        </div>                                        
                                    </div>
                                </li> 
                                
                                <li class=""><!-- 클릭시 active 추가 -->
                                    <div class="title-wrap"> 
                                        <a class="title" href="#">
                                            <i class="arrow xi-angle-down"></i> 
                                            <strong>[4주차] 4강. 수동태 뒤집기</strong>
                                            <p class="labels">
                                                <label class="label s_offline">오프라인</label>
                                            </p>
                                            <p class="desc">
                                                <span>학습기간<strong>2025.03.24 ~ 2025.03.30 / 63분</strong></span>
                                            </p>
                                        </a>                                        
                                        <div class="btn_right">
                                            <!-- <button class="btn s_type2">강의보기</button> -->
                                        </div>                                                                    
                                    </div>

                                    <div class="cont">
                                    	<div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">동영상</label>
                                                </p>   
                                                <strong>오늘의 학습</strong>
                                            </div>
                                            <div class="btn_right">
                                            	<div class="desc_info">
                                                    <span>진도율<strong class="navy">52%</strong></span>
                                                </div>
                                            </div>
                                        </div>
                                    	<div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_work">과제</label>
                                                </p>   
                                                <strong>ER 다이어그램을 그리고 그것을 관계형 모델로 변환해보기</strong>
                                            </div>
                                            <div class="btn_right mr">
                                            	<p class="desc">
	                                                <span>기간 <strong>2025.03.24 10:00 ~ 2025.03.30 22:00&nbsp;&nbsp;</strong></span>
	                                            </p>
                                                <button class="btn s_basic">과제제출<i class="icon-svg-arrow"></i></button>
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">                                                    
                                                    <label class="label s_debate">토론</label>
                                                </p>   
                                                <strong>찬반토론</strong>
                                            </div>
                                            <div class="btn_right mr">
                                                <p class="desc">
	                                                <span>기간 <strong>2025.03.24 10:00 ~ 2025.03.30 22:00&nbsp;&nbsp;</strong></span>
	                                            </p>
                                                <button class="btn s_basic">토론참여<i class="icon-svg-arrow"></i></button>                                                 
                                            </div>
                                        </div>                                  
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">                                                    
                                                    <label class="label s_basic">자료</label>
                                                </p>   
                                                <strong>수동태 뒤집기</strong>
                                            </div>
                                            <div class="btn_right">                                               
                                                <button class="btn s_basic down">학습자료</button>                                                
                                            </div>
                                        </div>                                     
                                    </div>
                                </li>
                                
                                <li class=""><!-- 클릭시 active 추가 -->
                                    <div class="title-wrap"> 
                                        <a class="title" href="#">
                                            <i class="arrow xi-angle-down"></i> 
                                            <strong>[5주차] 5강. 일치 강박 벗어나기</strong>
                                            <p class="labels">
                                                <label class="label s_online">온라인</label>
                                            </p>                                             
                                            <p class="desc">
                                                <span>학습기간<strong>2025.03.30 ~ 2025.04.06 / 75분</strong></span>
                                            </p>
                                        </a>                                        
                                        <div class="btn_right">
                                        	<button class="btn s_basic down">음성</button>
                                            <button class="btn s_type2">강의보기</button>
                                        </div>                                                                    
                                    </div>

                                    <div class="cont">        
                                    	<div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">동영상</label>
                                                </p>   
                                                <strong>오늘의 학습</strong>
                                            </div>
                                            <div class="btn_right">
                                            	<div class="desc_info">
                                                    <span>진도율<strong class="navy">52%</strong></span>
                                                </div>
                                            </div>
                                        </div>
                                    	<div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_work">과제</label>
                                                </p>   
                                                <strong>ER 다이어그램을 그리고 그것을 관계형 모델로 변환해보기</strong>
                                            </div>
                                            <div class="btn_right mr">
                                                <p class="desc">
	                                                <span>기간 <strong>2025.03.30 10:00 ~ 2025.04.06 22:00&nbsp;&nbsp;</strong></span>
	                                            </p>
                                                <button class="btn s_basic">과제제출<i class="icon-svg-arrow"></i></button>
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">                                                    
                                                    <label class="label s_debate">토론</label>
                                                </p>   
                                                <strong>찬반토론</strong>
                                            </div>
                                            <div class="btn_right mr">
                                            	<p class="desc">
	                                                <span>기간 <strong>2025.03.30 10:00 ~ 2025.04.06 22:00&nbsp;&nbsp;</strong></span>
	                                            </p>
                                                <button class="btn s_basic">토론참여<i class="icon-svg-arrow"></i></button> 
                                            </div>
                                        </div>                                
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">                                                    
                                                    <label class="label s_basic">자료</label>
                                                </p>   
                                                <strong>일치 강박 벗어나기</strong>
                                            </div>
                                            <div class="btn_right">                                               
                                                <button class="btn s_basic down">학습자료</button>                                                
                                            </div>
                                        </div>                                     
                                    </div>
                                </li>
                                
                                <li class=""><!-- 클릭시 active 추가 -->
                                    <div class="title-wrap"> 
                                        <a class="title" href="#">
                                            <i class="arrow xi-angle-down"></i> 
                                            <strong>[6주차] 6강. 형용사의 변신</strong>
                                            <p class="labels">
                                                <label class="label s_offline">오프라인</label>
                                            </p>                                             
                                            <p class="desc">
                                                <span>학습기간<strong>2025.04.07 ~ 2025.04.13 / -분</strong></span>
                                            </p>
                                        </a>                                        
                                        <div class="btn_right">
                                            <button class="btn s_type2">강의보기</button>
                                        </div>                                                                    
                                    </div>

                                    <div class="cont">           
                                    	<div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">동영상</label>
                                                </p>   
                                                <strong>오늘의 학습</strong>
                                            </div>
                                            <div class="btn_right">
                                            	<div class="desc_info">
                                                    <span>진도율<strong class="navy">52%</strong></span>
                                                </div>
                                            </div>
                                        </div>
                                    	<div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_work">과제</label>
                                                </p>   
                                                <strong>ER 다이어그램을 그리고 그것을 관계형 모델로 변환해보기</strong>
                                            </div>
                                            <div class="btn_right mr">
                                            	<p class="desc">
	                                                <span>기간 <strong>2025.04.07 10:00 ~ 2025.04.13 22:00&nbsp;&nbsp;</strong></span>
	                                            </p>
                                                <button class="btn s_basic">과제제출<i class="icon-svg-arrow"></i></button>
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">                                                    
                                                    <label class="label s_debate">토론</label>
                                                </p>   
                                                <strong>찬반토론</strong>
                                            </div>
                                            <div class="btn_right mr">
                                                <p class="desc">
	                                                <span>기간 <strong>2025.04.07 10:00 ~ 2025.04.13 22:00&nbsp;&nbsp;</strong></span>
	                                            </p>
                                                <button class="btn s_basic">토론참여<i class="icon-svg-arrow"></i></button>                                                 
                                            </div>
                                        </div>                             
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">                                                    
                                                    <label class="label s_basic">자료</label>
                                                </p>   
                                                <strong>형용사의 변신</strong>
                                            </div>
                                            <div class="btn_right">                                               
                                                <button class="btn s_basic set">학습자료</button>                                                
                                            </div>
                                        </div>                                     
                                    </div>
                                </li>
                                
                                <li class=""><!-- 클릭시 active 추가 -->
                                    <div class="title-wrap"> 
                                        <a class="title" href="#">
                                            <i class="arrow xi-angle-down"></i> 
                                            <strong>[7주차] 7강. 문장부호의 번역</strong>
                                            <p class="labels">
                                                <label class="label s_offline">오프라인</label>
                                            </p>                                             
                                            <p class="desc">
                                                <span>학습기간<strong>2025.04.14 ~ 2025.04.20  / -분</strong></span>
                                            </p>
                                        </a>                                        
                                        <div class="btn_right">
                                            <button class="btn s_type2">강의보기</button>
                                        </div>                                                                    
                                    </div>

                                    <div class="cont">           
                                    	<div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">동영상</label>
                                                </p>   
                                                <strong>오늘의 학습</strong>
                                            </div>
                                            <div class="btn_right">
                                            	<div class="desc_info">
                                                    <span>진도율<strong class="navy">52%</strong></span>
                                                </div>
                                            </div>
                                        </div>
                                    	<div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_work">과제</label>
                                                </p>   
                                                <strong>ER 다이어그램을 그리고 그것을 관계형 모델로 변환해보기</strong>
                                            </div>
                                            <div class="btn_right mr">
                                            	<p class="desc">
	                                                <span>기간 <strong>2025.04.14 10:00 ~ 2025.04.20 22:00&nbsp;&nbsp;</strong></span>
	                                            </p>
                                                <button class="btn s_basic">과제제출<i class="icon-svg-arrow"></i></button>
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">                                                    
                                                    <label class="label s_debate">토론</label>
                                                </p>   
                                                <strong>찬반토론</strong>
                                            </div>
                                           	<div class="btn_right mr">
                                                <p class="desc">
	                                                <span>기간 <strong>2025.04.14 10:00 ~ 2025.04.20 22:00&nbsp;&nbsp;</strong></span>
	                                            </p>
                                                <button class="btn s_basic">토론참여<i class="icon-svg-arrow"></i></button>                                                 
                                            </div>
                                        </div>                             
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">                                                    
                                                    <label class="label s_basic">자료</label>
                                                </p>   
                                                <strong>문장부호의 번역</strong>
                                            </div>
                                            <div class="btn_right">                                               
                                                <button class="btn s_basic set">학습자료</button>                                                
                                            </div>
                                        </div>                                     
                                    </div>
                                </li>
                                
                                <li class=""><!-- 클릭시 active 추가 -->
                                    <div class="title-wrap"> 
                                        <a class="title" href="#">
                                            <i class="arrow xi-angle-down"></i> 
                                            <strong>[8주차] 8강. 중간평가</strong>
                                            <p class="labels">
                                                <label class="label s_online">온라인</label>
                                            </p>                                             
                                            <p class="desc">
                                                <span>학습기간<strong>2025.04.21 ~ 2025.04.27 / -분</strong></span>
                                            </p>
                                        </a>                                        
                                        <div class="btn_right">
                                            <button class="btn s_type1">결시신청</button>
                                            <button class="btn s_type1">장애인/고령자 지원신청</button>
                                        </div>                                                                    
                                    </div>

                                    <div class="cont">  
                                    	<div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">                                                    
                                                    <label class="label s_basic">텍스트</label>
                                                </p>   
                                                <strong>중간평가 안내</strong>
                                            </div>
                                        </div>                                       
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">                                                    
                                                    <label class="label s_test">시험</label>
                                                </p>   
                                                <strong>중간고사</strong>
                                            </div>
                                            <div class="btn_right">
                                            	<p class="desc">
	                                                <span>시험일시<strong> 2025.04.27 16:00&nbsp;&nbsp;</strong></span>
	                                            </p>
                                                <button class="btn s_type2">시험응시</button>                                                
                                            </div>
                                        </div> 
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">                                                    
                                                    <label class="label s_test">대체과제</label>
                                                </p>   
                                                <strong>대체과제명</strong>
                                            </div>
                                            <div class="btn_right">
                                                <p class="desc">
	                                                <span>기간 <strong> 2025.04.21 10:00 ~ 2025.04.27 22:00&nbsp;&nbsp;</strong></span>
	                                            </p>
                                                <button class="btn s_basic">과제제출<i class="icon-svg-arrow"></i></button>
                                            </div>
                                        </div>                                    
                                    </div>
                                </li>
                                
                                <li class=""><!-- 클릭시 active 추가 -->
                                    <div class="title-wrap"> 
                                        <a class="title" href="#">
                                            <i class="arrow xi-angle-down"></i> 
                                            <strong>[9주차] 9강. 자상한 보충</strong>
                                            <p class="labels">
                                                <label class="label s_online">온라인</label>
                                            </p>                                             
                                            <p class="desc">
                                                <span>학습기간<strong>2025.04.28 ~ 2025.05.04 / -분</strong></span>
                                            </p>
                                        </a>                                        
                                        <div class="btn_right">
                                            <button class="btn s_basic down">음성</button>
                                            <button class="btn s_type2">강의보기</button>
                                        </div>                                                                    
                                    </div>

                                    <div class="cont">         
                                    	<div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">동영상</label>
                                                </p>   
                                                <strong>오늘의 학습</strong>
                                            </div>
                                            <div class="btn_right">
                                            	<div class="desc_info">
                                                    <span>진도율<strong class="navy">52%</strong></span>
                                                </div>
                                            </div>
                                        </div>
                                    	<div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_work">과제</label>
                                                </p>   
                                                <strong>ER 다이어그램을 그리고 그것을 관계형 모델로 변환해보기</strong>
                                            </div>
                                            <div class="btn_right mr">
                                                <p class="desc">
	                                                <span>기간 <strong> 2025.04.28 10:00 ~ 2025.05.04 22:00&nbsp;&nbsp;</strong></span>
	                                            </p>
                                                <button class="btn s_basic">과제제출<i class="icon-svg-arrow"></i></button>
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">                                                    
                                                    <label class="label s_debate">토론</label>
                                                </p>   
                                                <strong>찬반토론</strong>
                                            </div>
                                            <div class="btn_right mr">
                                                <p class="desc">
	                                                <span>기간 <strong> 2025.04.28 10:00 ~ 2025.05.04 22:00&nbsp;&nbsp;</strong></span>
	                                            </p>
                                                <button class="btn s_basic">토론참여<i class="icon-svg-arrow"></i></button>                                               
                                            </div>
                                        </div>                               
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">                                                    
                                                    <label class="label s_basic">자료</label>
                                                </p>   
                                                <strong>자상한 보충</strong>
                                            </div>
                                            <div class="btn_right">                                               
                                                <button class="btn s_basic down">학습자료</button>                                                
                                            </div>
                                        </div>                                     
                                    </div>
                                </li>
                                
                                <li class=""><!-- 클릭시 active 추가 -->
                                    <div class="title-wrap"> 
                                        <a class="title" href="#">
                                            <i class="arrow xi-angle-down"></i> 
                                            <strong>[10주차] 10강. 상쾌한 압축</strong>
                                            <p class="labels">
                                                <label class="label s_online">온라인</label>
                                            </p>                                             
                                            <p class="desc">
                                                <span>학습기간<strong>2025.05.07 ~ 2025.05.11 / -분</strong></span>
                                            </p>
                                        </a>                                        
                                        <div class="btn_right">
                                            <button class="btn s_type2">강의보기</button>
                                        </div>                                                                    
                                    </div>

                                    <div class="cont">        
                                    	<div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">동영상</label>
                                                </p>   
                                                <strong>오늘의 학습</strong>
                                            </div>
                                            <div class="btn_right">
                                            	<div class="desc_info">
                                                    <span>진도율<strong class="navy">52%</strong></span>
                                                </div>
                                            </div>
                                        </div>
                                    	<div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_work">과제</label>
                                                </p>   
                                                <strong>ER 다이어그램을 그리고 그것을 관계형 모델로 변환해보기</strong>
                                            </div>
                                            <div class="btn_right mr">
                                                <p class="desc">
	                                                <span>기간 <strong> 2025.05.07 10:00 ~ 2025.05.11 22:00&nbsp;&nbsp;</strong></span>
	                                            </p>
                                                <button class="btn s_basic">과제제출<i class="icon-svg-arrow"></i></button>
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">                                                    
                                                    <label class="label s_debate">토론</label>
                                                </p>   
                                                <strong>찬반토론</strong>
                                            </div>
                                            <div class="btn_right mr">
                                                <p class="desc">
	                                                <span>기간 <strong> 2025.05.07 10:00 ~ 2025.05.11 22:00&nbsp;&nbsp;</strong></span>
	                                            </p>
                                                <button class="btn s_basic">토론참여<i class="icon-svg-arrow"></i></button>                                               
                                            </div>
                                        </div>                                
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">                                                    
                                                    <label class="label s_basic">자료</label>
                                                </p>   
                                                <strong>상쾌한 압축</strong>
                                            </div>
                                            <div class="btn_right">                                               
                                                <button class="btn s_basic down">학습자료</button>                                                
                                            </div>
                                        </div>                                     
                                    </div>
                                </li>
                                
                                <li class=""><!-- 클릭시 active 추가 -->
                                    <div class="title-wrap"> 
                                        <a class="title" href="#">
                                            <i class="arrow xi-angle-down"></i> 
                                            <strong>[11주차] 11강. 반전의 묘미</strong>
                                            <p class="labels">
                                                <label class="label s_offline">오프라인</label>
                                            </p>                                             
                                            <p class="desc">
                                                <span>학습기간<strong>2025.05.12 ~ 2025.05.18 / -분</strong></span>
                                            </p>
                                        </a>                                        
                                        <div class="btn_right">
                                            <button class="btn s_type2">강의보기</button>
                                        </div>                                                                    
                                    </div>

                                    <div class="cont">         
                                    	<div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">동영상</label>
                                                </p>   
                                                <strong>오늘의 학습</strong>
                                            </div>
                                            <div class="btn_right">
                                            	<div class="desc_info">
                                                    <span>진도율<strong class="navy">52%</strong></span>
                                                </div>
                                            </div>
                                        </div>
                                    	<div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_work">과제</label>
                                                </p>   
                                                <strong>ER 다이어그램을 그리고 그것을 관계형 모델로 변환해보기</strong>
                                            </div>
                                            <div class="btn_right mr">
                                                <p class="desc">
	                                                <span>기간 <strong> 2025.05.12 10:00 ~ 2025.05.18 22:00&nbsp;&nbsp;</strong></span>
	                                            </p>
                                                <button class="btn s_basic">과제제출<i class="icon-svg-arrow"></i></button>
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">                                                    
                                                    <label class="label s_debate">토론</label>
                                                </p>   
                                                <strong>찬반토론</strong>
                                            </div>
                                            <div class="btn_right mr">
                                                <p class="desc">
	                                                <span>기간 <strong> 2025.05.12 10:00 ~ 2025.05.18 22:00&nbsp;&nbsp;</strong></span>
	                                            </p>
                                                <button class="btn s_basic">토론참여<i class="icon-svg-arrow"></i></button>                                               
                                            </div>
                                        </div>                               
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">                                                    
                                                    <label class="label s_basic">자료</label>
                                                </p>   
                                                <strong>반전의 묘미</strong>
                                            </div>
                                            <div class="btn_right">                                               
                                                <button class="btn s_basic down">학습자료</button>                                                
                                            </div>
                                        </div>                                     
                                    </div>
                                </li>
                                
                                <li class=""><!-- 클릭시 active 추가 -->
                                    <div class="title-wrap"> 
                                        <a class="title" href="#">
                                            <i class="arrow xi-angle-down"></i> 
                                            <strong>[12주차] 12강. 순차번역의 흐름</strong>
                                            <p class="labels">
                                                <label class="label s_offline">오프라인</label>
                                            </p>                                             
                                            <p class="desc">
                                                <span>학습기간<strong>2025.05.19 ~ 2025.05.25 / -분</strong></span>
                                            </p>
                                        </a>                                        
                                        <div class="btn_right">
                                            <button class="btn s_type2">강의보기</button>
                                        </div>                                                                    
                                    </div>

                                    <div class="cont">       
                                    	<div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">동영상</label>
                                                </p>   
                                                <strong>오늘의 학습</strong>
                                            </div>
                                            <div class="btn_right">
                                            	<div class="desc_info">
                                                    <span>진도율<strong class="navy">52%</strong></span>
                                                </div>
                                            </div>
                                        </div>
                                    	<div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_work">과제</label>
                                                </p>   
                                                <strong>ER 다이어그램을 그리고 그것을 관계형 모델로 변환해보기</strong>
                                            </div>
                                            <div class="btn_right mr">
                                                <p class="desc">
	                                                <span>기간 <strong> 2025.05.19 10:00 ~ 2025.05.25 22:00&nbsp;&nbsp;</strong></span>
	                                            </p>
                                                <button class="btn s_basic">과제제출<i class="icon-svg-arrow"></i></button>
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">                                                    
                                                    <label class="label s_debate">토론</label>
                                                </p>   
                                                <strong>찬반토론</strong>
                                            </div>
                                            <div class="btn_right mr">
                                                <p class="desc">
	                                                <span>기간 <strong> 2025.05.19 10:00 ~ 2025.05.25 22:00&nbsp;&nbsp;</strong></span>
	                                            </p>
                                                <button class="btn s_basic">토론참여<i class="icon-svg-arrow"></i></button>                                               
                                            </div>
                                        </div>                                 
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">                                                    
                                                    <label class="label s_basic">자료</label>
                                                </p>   
                                                <strong>순차번역의 흐름</strong>
                                            </div>
                                            <div class="btn_right">                                               
                                                <button class="btn s_basic down">학습자료</button>                                                
                                            </div>
                                        </div>                                     
                                    </div>
                                </li>
                                
                                <li class=""><!-- 클릭시 active 추가 -->
                                    <div class="title-wrap"> 
                                        <a class="title" href="#">
                                            <i class="arrow xi-angle-down"></i> 
                                            <strong>[13주차] 13강. 비유 살리기</strong>
                                            <p class="labels">
                                                <label class="label s_offline">오프라인</label>
                                            </p>                                             
                                            <p class="desc">
                                                <span>학습기간<strong>2025.05.26 ~ 2025.06.01 / -분</strong></span>
                                            </p>
                                        </a>                                        
                                        <div class="btn_right">
                                            <button class="btn s_type2">강의보기</button>
                                        </div>                                                                    
                                    </div>

                                    <div class="cont">        
                                    	<div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">동영상</label>
                                                </p>   
                                                <strong>오늘의 학습</strong>
                                            </div>
                                            <div class="btn_right">
                                            	<div class="desc_info">
                                                    <span>진도율<strong class="navy">52%</strong></span>
                                                </div>
                                            </div>
                                        </div> 
                                    	<div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_work">과제</label>
                                                </p>   
                                                <strong>ER 다이어그램을 그리고 그것을 관계형 모델로 변환해보기</strong>
                                            </div>
                                            <div class="btn_right mr">
                                                <p class="desc">
	                                                <span>기간 <strong> 2025.05.26 10:00 ~ 2025.06.01 22:00&nbsp;&nbsp;</strong></span>
	                                            </p>
                                                <button class="btn s_basic">과제제출<i class="icon-svg-arrow"></i></button>                                               
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">                                                    
                                                    <label class="label s_debate">토론</label>
                                                </p>   
                                                <strong>찬반토론</strong>
                                            </div>
                                            <div class="btn_right mr">
                                                <p class="desc">
	                                                <span>기간 <strong> 2025.05.26 10:00 ~ 2025.06.01 22:00&nbsp;&nbsp;</strong></span>
	                                            </p>
                                                <button class="btn s_basic">토론참여<i class="icon-svg-arrow"></i></button>                                               
                                            </div>
                                        </div>                               
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">                                                    
                                                    <label class="label s_basic">자료</label>
                                                </p>   
                                                <strong>비유 살리기</strong>
                                            </div>
                                            <div class="btn_right">                                               
                                                <button class="btn s_basic down">학습자료</button>                                                
                                            </div>
                                        </div>                                     
                                    </div>
                                </li>
                                
                                <li class=""><!-- 클릭시 active 추가 -->
                                    <div class="title-wrap"> 
                                        <a class="title" href="#">
                                            <i class="arrow xi-angle-down"></i> 
                                            <strong>[14주차] 14강. 기타</strong>
                                            <p class="labels">
                                                <label class="label s_offline">오프라인</label>
                                            </p>                                             
                                            <p class="desc">
                                                <span>학습기간<strong>2025.06.02 ~ 2025.06.08 / -분</strong></span>
                                            </p>
                                        </a>                                        
                                        <div class="btn_right">
                                            <button class="btn s_type2">강의보기</button>
                                        </div>                                                                    
                                    </div>

                                    <div class="cont">     
                                    	<div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_basic">동영상</label>
                                                </p>   
                                                <strong>오늘의 학습</strong>
                                            </div>
                                            <div class="btn_right">
                                            	<div class="desc_info">
                                                    <span>진도율<strong class="navy">52%</strong></span>
                                                </div>
                                            </div>
                                        </div>
                                    	<div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">
                                                    <label class="label s_work">과제</label>
                                                </p>   
                                                <strong>ER 다이어그램을 그리고 그것을 관계형 모델로 변환해보기</strong>
                                            </div>
                                            <div class="btn_right mr">
                                                <p class="desc">
	                                                <span>기간 <strong> 2025.06.02 10:00 ~ 2025.06.08 22:00&nbsp;&nbsp;</strong></span>
	                                            </p>
                                                <button class="btn s_basic">과제제출<i class="icon-svg-arrow"></i></button>                                               
                                            </div>
                                        </div>
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">                                                    
                                                    <label class="label s_debate">토론</label>
                                                </p>   
                                                <strong>찬반토론</strong>
                                            </div>
                                            <div class="btn_right mr">
                                                <p class="desc">
	                                                <span>기간 <strong> 2025.06.02 10:00 ~ 2025.06.08 22:00&nbsp;&nbsp;</strong></span>
	                                            </p>
                                                <button class="btn s_basic">토론참여<i class="icon-svg-arrow"></i></button>                                               
                                            </div>
                                        </div>                                   
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">                                                    
                                                    <label class="label s_basic">자료</label>
                                                </p>   
                                                <strong>기타</strong>
                                            </div>
                                            <div class="btn_right">                                               
                                                <button class="btn s_basic down">학습자료</button>                                                
                                            </div>
                                        </div>                                     
                                    </div>
                                </li>

                                <li class=""><!-- 클릭시 active 추가 -->
                                    <div class="title-wrap"> 
                                        <a class="title" href="#">
                                            <i class="arrow xi-angle-down"></i> 
                                            <strong>[15주차] 15강. 기말평가</strong>
                                            <p class="labels">
                                                <label class="label s_online">온라인</label>
                                            </p>                                             
                                            <p class="desc">
                                                <span>학습기간<strong>2025.06.09 ~ 2025.06.15 / -분</strong></span>
                                            </p>
                                        </a>                                        
                                        <div class="btn_right">
                                            <button class="btn s_type1">결시신청</button>
                                            <button class="btn s_type1">장애인/고령자 지원신청</button>
                                        </div>                                                                    
                                    </div>

                                    <div class="cont">
                                    	<div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">                                                    
                                                    <label class="label s_basic">텍스트</label>
                                                </p>   
                                                <strong>기말평가 안내</strong>
                                            </div>
                                        </div>                                       
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">                                                    
                                                    <label class="label s_test">시험</label>
                                                </p>   
                                                <strong>기말고사</strong>
                                            </div>
                                            <div class="btn_right">
                                                <div class="desc_info">
                                                    <span>시험일시<strong>2025.07.22 16:00</strong></span>                                                    
                                                </div>                                               
                                                <button class="btn s_basic">시험응시<i class="icon-svg-arrow"></i></button>                                               
                                            </div>
                                        </div> 
                                        <div class="lecture_box">
                                            <div class="lecture_tit">
                                                <p class="labels">                                                    
                                                    <label class="label s_test">대체과제</label>
                                                </p>   
                                                <strong>대체과제명</strong>
                                            </div>
                                            <div class="btn_right">
                                                <div class="desc_info">
                                                    <span>기간 <strong>2025.07.21 10:00 ~ 2025.07.23 22:00&nbsp;&nbsp;</strong></span>                                                    
                                                </div>                                               
                                                <button class="btn s_basic">과제제출<i class="icon-svg-arrow"></i></button>                                                
                                            </div>
                                        </div>                                    
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <!-- //강의목록 -->
                        
                    </div>
                                                        
                </div>   
                
            </div>
            <!-- //content -->
        

        </main>
        <!-- //classroom-->

    </div>

</body>
</html>

