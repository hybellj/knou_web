<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
	<jsp:param name="module" value="chart"/>
	<jsp:param name="style" value="classroom"/>
</jsp:include>
<script>
	$(function(){
    	// 여기에 코드 작성
		drawChartMy();
		drawChartAverage();
	});

	function loadLctrPlandocPopView(sbjctId) {
	    fetch('/lctr/plandoc/profLctrPlandocPopView.do?sbjctId=' + encodeURIComponent(sbjctId))
	        .then(response => response.text())
	        .then(data => {
	            const div = document.getElementById('lecturePlanDoc');
	            div.style.display = "block";
	            div.style.position = "fixed";
	            div.style.top = "50%";
	            div.style.left = "50%";
	            div.style.width = "800px";
	            div.style.maxHeight = "80vh";
	            div.style.overflow = "auto";
	            div.style.zIndex = "9999";
	            div.style.background = "#fff";
	            div.style.padding = "20px";
	            div.style.transform = "translate(-50%, -50%)";
	            div.innerHTML = data;
	        })
	        .catch(error => {
	            document.getElementById('lecturePlanDoc').innerHTML = '에러 발생';
	            console.error(error);
	        });
	}
</script>
<link rel="stylesheet" type="text/css" href="/webdoc/assets/css/classroom.css" />
<body class="class colorA "><!-- 컬러선택시 클래스변경 -->
<div style="display:none;" id="lecturePlanDoc"></div>
    <div id="wrap" class="main">

        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>
        <!-- //common header -->

        <!-- classroom -->
        <main class="common">

			<!-- gnb -->
			<jsp:include page="/WEB-INF/jsp/common_new/class_gnb_stu.jsp"/>
			<!-- //gnb -->

			<!-- content -->
			<div id="content" class="content-wrap common">
				<div class="class_sub_top">
					<div class="navi_bar">
						<ul>
							<li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
							<li>강의실</li>
							<li><span class="current">내강의실</span></li>
						</ul>
					</div>
					<div class="btn-wrap">
						<div class="first">
							<select class="form-select">
								<option value="2025년 2학기">2026년 2학기</option>
								<option value="2025년 1학기">2026년 1학기</option>
							</select>
							<select class="form-select wide">
								<option value="">강의실 바로가기</option>
								<option value="2025년 2학기">2026년 2학기</option>
								<option value="2025년 1학기">2026년 1학기</option>
							</select>
						</div>
						<div class="sec">
							<button type="button" class="btn type1"><i class="xi-book-o"></i>교수 매뉴얼</button>
							<button type="button" class="btn type1"><i class="xi-info-o"></i>학습안내정보</button>
						</div>
					</div>
				</div>

				<!-- class_sub -->
				<div class="class_sub">

					<!-- 강의실 상단 -->
					<div class="segment class-area stu" style="boarder:1px solid red">

						<!-- info-left -->
						<div class="info-left"  style="boarder:1px solid red">
                            <div class="class_info">
                                <p class="labels">
                                    <label class="label uniA">대학원</label><!-- 대학원 -->
                                </p>
                                <h2>${subjectVM.subjectVO.sbjctnm}</h2><!--  과목명 -->
                            </div>
                            <div class="class_detail">
                                <div class="detail_txt"><!-- 교수명 --><!-- 튜터명 --><!-- 학점 -->
                                    <p class="desc">
                                        <span>교수:<strong>${subjectVM.subjectAdms.profnm}</strong></span>
                                        <span>튜터:<strong>${subjectVM.subjectAdms.tutnm}</strong></span>
                                        <span>학점:<strong>${subjectVM.subjectVO.crdts}학점</strong></span>
                                    </p>
                                    <p class="desc"><!-- 학습기간 --><!-- 수강시작일시 --><!-- 수강종료일시 -->
                                        <span>학습기간:<strong><uiex:formatDate value="${subjectVM.subjectVO.atndlcSdttm}" type="date"/>
                                        ~ <uiex:formatDate value="${subjectVM.subjectVO.atndlcEdttm}" type="date"/></strong></span>
                                    </p>
                                </div>

                                <div class="classSection">
                                    <div class="cls_btn">
                                    	<a href="javascript:void(0); onclick=loadLctrPlandocPopView('${subjectVM.subjectVO.sbjctId}');" class="btn"><em>강의</em>계획서</a><!-- 강의 --><!-- 계획서-->
                                        <a href="#0" class="btn"><em>평가</em>기준</a><!-- 평가 --><!-- 기준-->
                                        <a href="/dashboard/dashboard.do" class="btn"><em>강의실</em>나가기</a><!-- 강의실 --><!-- 나가기-->
                                    </div>
                                </div>
                            </div>
                        </div>
						<!--//info-left -->

						<!-- info-right-->
						<div class="info-right" style="boarder:1px solid red">

							<!-- flex -->
							<div class="flex">

								<!-- item_list-->
								<div class="item_list">

									<!-- item user-->
									<div class="item user">
	                                    <div class="item_icon"><i class="icon-svg-group" aria-hidden="true"></i></div>

	                                    <!-- item_tit -->
	                                    <div class="item_tit">
		                                    <a href="#0" class="btn ">접속현황<i class="xi-angle-down-min"></i></a><!-- 접속현황 -->

		                                    <!-- 접속현황레이어팝업-->
		                                    <div class="user-option-wrap">
		                                        <div class="option_head">
		                                            <div class="sort_btn">
		                                                <button type="button">이름<i class="sort xi-long-arrow-up" aria-hidden="true"></i></button><!-- 이름(학생명) -->
		                                                <button type="button">이름<i class="sort xi-long-arrow-down" aria-hidden="true"></i></button><!-- 이름(학생명) -->
		                                            </div>
		                                            <p class="user_num">접속: 37</p><!-- 접속 -->
		                                            <button type="button" class="btn-close" aria-label="접속현황 닫기"><!-- 접속현황닫기 -->
		                                                <i class="icon-svg-close"></i>
		                                            </button>
		                                        </div>
	                                            <ul class="user_area"><!-- 현재접속자목록 li loop-->
	                                                <li>
	                                                    <div class="user-info">
	                                                        <div class="user-photo">
	                                                            <img src="/webdoc/assets/img/common/photo_user_sample2.jpg" aria-hidden="true" alt="사진"> <!-- 사진 -->
	                                                        </div>
	                                                        <div class="user-desc">
	                                                            <p class="name">나방송</p>
	                                                            <p class="subject"><span class="major">[대학원]</span>정보와기술</p> <!-- 대학원 --> <!-- 과목명 -->
	                                                        </div>
	                                                        <div class="btn_wrap">
	                                                            <button type="button"><i class="xi-info-o"></i></button><!-- 정보 -->
	                                                            <button type="button"><i class="xi-bell-o"></i></button><!-- 알림 -->
	                                                        </div>
	                                                    </div>
	                                                </li>
	                                                <li>
	                                                    <div class="user-info">
	                                                        <div class="user-photo">
	                                                            <img src="/webdoc/assets/img/common/photo_user_sample3.jpg" aria-hidden="true" alt="사진">
	                                                        </div>
	                                                        <div class="user-desc">
	                                                            <p class="name">최남단</p>
	                                                            <p class="subject"><span class="major">[대학원]</span>데이터베이스의 이해와 활용</p>
	                                                        </div>
	                                                        <div class="btn_wrap">
	                                                            <button type="button"><i class="xi-info-o"></i></button>
	                                                            <button type="button"><i class="xi-bell-o"></i></button>
	                                                        </div>
	                                                    </div>
	                                                </li>
	                                                <li>
	                                                    <div class="user-info">
	                                                        <div class="user-photo">
	                                                            <img src="/webdoc/assets/img/common/photo_user_sample2.jpg" aria-hidden="true" alt="사진">
	                                                        </div>
	                                                        <div class="user-desc">
	                                                            <p class="name">나방송</p>
	                                                            <p class="subject"><span class="major">[대학원]</span>정보와기술</p>
	                                                        </div>
	                                                        <div class="btn_wrap">
	                                                            <button type="button"><i class="xi-info-o"></i></button>
	                                                            <button type="button"><i class="xi-bell-o"></i></button>
	                                                        </div>
	                                                    </div>
	                                                </li>
	                                                <li>
	                                                    <div class="user-info">
	                                                        <div class="user-photo">
	                                                            <img src="/webdoc/assets/img/common/photo_user_sample2.jpg" aria-hidden="true" alt="사진">
	                                                        </div>
	                                                        <div class="user-desc">
	                                                            <p class="name">최남단</p>
	                                                            <p class="subject"><span class="major">[대학원]</span>데이터베이스의 이해와 활용</p>
	                                                        </div>
	                                                        <div class="btn_wrap">
	                                                            <button type="button"><i class="xi-info-o"></i></button>
	                                                            <button type="button"><i class="xi-bell-o"></i></button>
	                                                        </div>
	                                                    </div>
	                                                </li>
	                                                <li>
	                                                    <div class="user-info">
	                                                        <div class="user-photo">
	                                                            <img src="/webdoc/assets/img/common/photo_user_sample3.jpg" aria-hidden="true" alt="사진">
	                                                        </div>
	                                                        <div class="user-desc">
	                                                            <p class="name">최남단</p>
	                                                            <p class="subject"><span class="major">[대학원]</span>데이터베이스의 이해와 활용</p>
	                                                        </div>
	                                                        <div class="btn_wrap">
	                                                            <button type="button"><i class="xi-info-o"></i></button>
	                                                            <button type="button"><i class="xi-bell-o"></i></button>
	                                                        </div>
	                                                    </div>
	                                                </li>
	                                            </ul>

	                                        </div>
	                                        <!-- //접속현황레이어팝업-->
	                                    </div>
	                                    <!-- //item_tit -->

	                                    <div class="item_info">
	                                        <span class="big">37</span><!-- 현재접속자수 -->
	                                        <span class="small">250</span><!-- 전체접속자수 -->
	                                    </div>
	                                </div>
	                                <!-- //item user-->

									<div class="item attend">
	                                    <div class="item_icon"><i class="icon-svg-pie-chart-01" aria-hidden="true"></i></div>
	                                    <div class="item_tit">7주차 출석 40 / 50</div>
	                                    <div class="item_info">
	                                        <span class="big">80</span>
	                                        <span class="small">%</span>
	                                    </div>
	                                </div>

									<div class="item week">
	                                       <div class="item_icon"><i class="icon-svg-calendar-check-02" aria-hidden="true"></i></div>
	                                       <div class="item_tit">2025.04.14 ~ 04.20</div><!-- 주차기간 -->
	                                       <div class="item_info">
	                                           <span class="big">7</span><!-- 현재주차 -->
	                                           <span class="small">주차</span><!-- 주차 -->
	                                       </div>
	                                </div>

                                </div>
                                <!-- //item_list -->

								<!-- chart_list -->
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
											// 나의진도율차트그리기
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

		                                 	// 평균진도율차트그리기
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
		                            </script>

		                        </div>
		                        <!-- //chart_list -->

		                    </div>
		                    <!--  //flex -->

						</div>
						<!-- //info-right-->

					</div>
					<!-- //강의실 상단 -->

					<!-- segment row -->
					<div class="segment-row">

						<!-- 공지사항 -->
						<div class="segment">
                            <div class="box_title">
                                <i class="icon-svg-notice"></i>
                                <h3 class="h3">과목 공지사항 <small class="msg_num">${subjectVM.badge.noticeUnreadCnt}</small></h3><!-- 과목 공지사항-->
                                <div class="btn-wrap">
                                    <a href="/bbs/bbsHome/bbsAtclListView.do?bbsId=${subjectVM.subjectBbsIds.ntcBbsId}" class="btn_more"><i class="xi-plus"></i></a>
                                </div>
                            </div>
                            <div class="box_content">
	                            <c:choose>
								    <c:when test="${empty subjectVM.subjectTopNoticeList}">
								        <li>공지사항이 없습니다</li>
								    </c:when>
								    <c:otherwise>
								        <ul class="dash_item_listA">
		                                	<c:forEach var="item" items="${subjectVM.subjectTopNoticeList}">
			                                    <li class="dot">
			                                        <a href="/bbs/bbsHome/bbsAtclListView.do?bbsId=${item.bbsId}" class="item_txt">
			                                            <p class="tit">${item.atclTtl}</p>
			                                            <p class="desc">
			                                                <span class="date" style="display:inline-block; width:90px;"><uiex:formatDate value="${item.regDttm}" type="date"/></span>
			                                            </p>
			                                        </a>
			                                        <div class="state">
			                                        	<c:choose>
				                                            <c:when test="${empty item.readyn}">
				                                            	<label class="label check_no">읽지않음</label>
				                                            </c:when>
										         			<c:otherwise>
										         				<label class="label check">읽음</label>
										         			</c:otherwise>
										         		</c:choose>
			                                        </div>
			                                    </li>
		                                    </c:forEach>
	                                	</ul>
								    </c:otherwise>
								</c:choose>
                            </div>
                        </div>
						<!-- //공지사항 -->

                        <!-- 강의Q&A -->
                        <div class="segment">
                            <div class="box_title">
                                <i class="icon-svg-question"></i>
                                <h3 class="h3">강의 Q&A <small class="msg_num">${subjectVM.badge.qnaNoreplyCnt}</small></h3>
                                <div class="btn-wrap">
                                    <a href="/bbs/bbsHome/bbsAtclListView.do?bbsId=${subjectVM.subjectBbsIds.qnaBbsId}" class="btn_more"><i class="xi-plus"></i></a>
                                </div>
                            </div>
                            <div class="box_content">
                            	<c:choose>
								    <c:when test="${empty subjectVM.subjectTopLctrQnaList}">
								        <li>QNA가 없습니다</li>
								    </c:when>
								    <c:otherwise>
								        <ul class="dash_item_listA">
		                                	<c:forEach var="item" items="${subjectVM.subjectTopLctrQnaList}">
			                                    <li>
			                                        <div class="user">
			                                           <span class="user_img"></span>
			                                        </div>
			                                        <a href="#0" class="item_txt">
			                                            <p class="tit">${item.atclTtl}</p>
			                                            <p class="desc">
			                                                <span class="name">${item.usernm}</span>
			                                                <span class="date"><uiex:formatDate value="${item.regDttm}" type="date"/></span>
			                                            </p>
			                                        </a>
			                                        <div class="state">
				                                        <c:choose>
				                                            <c:when test="${empty item.answerAtclId}">
				                                            	<label class="label check_no">미답변</label>
				                                            </c:when>
										         			<c:otherwise>
										         				<label class="label check_reply">답변</label>
										         			</c:otherwise>
										         		</c:choose>
										         	</div>
			                                    </li>
		                                    </c:forEach>
	                                	</ul>
								    </c:otherwise>
								</c:choose>
							</div>
						</div>
                        <!-- //강의Q&A -->

                        <!-- 자료실 -->
                        <div class="segment">
                            <div class="box_title">
                                <i class="icon-svg-save"></i>
                                <h3 class="h3">자료실</h3>
                                <div class="btn-wrap">
                                    <a href="/bbs/bbsHome/bbsAtclListView.do?bbsId=${subjectVM.subjectBbsIds.datarmBbsId}" class="btn_more"><i class="xi-plus"></i></a>
                                </div>
                            </div>
                            <div class="box_content">
                            	<c:choose>
								    <c:when test="${empty subjectVM.stdntSubjectTopDatarmList}">
								        <li>자료가 없습니다</li>
								    </c:when>
								    <c:otherwise>
								        <ul class="dash_item_listA">
		                                	<c:forEach var="item" items="${subjectVM.stdntSubjectTopDatarmList}">
			                                    <li class="dot">
				                                    <a href="/bbs/bbsHome/bbsAtclListView.do?bbsId=${item.bbsId}" class="item_txt">
			                                            <p class="tit">${item.atclTtl}</p>
			                                            <p class="desc">
			                                                <span class="date" style="display:inline-block; width:90px;"><uiex:formatDate value="${item.regDttm}" type="date"/></span>
			                                            </p>
			                                        </a>
			                                        <div class="state">
			                                            <c:choose>
				                                            <c:when test="${empty item.readyn}">
				                                            	&nbsp;
				                                            </c:when>
										         			<c:otherwise>
										         				<a href="#0" class="btn btn_down">다운로드</a>
										         			</c:otherwise>
										         		</c:choose>

			                                        </div>
			                                    </li>
		                                    </c:forEach>
	                                	</ul>
								    </c:otherwise>
								</c:choose>
                            </div><!-- //box_content -->
                        </div>
                        <!-- //자료실 -->

                    </div>
					<!-- //segment row -->


					<!-- segment-->
					<div class="segment">

						<div class="state-info-label">
	                        <p class="pre"><i class="icon-svg-state"></i>학습 미진행</p>
	                        <p class="ok"><i class="icon-svg-state"></i>학습완료</p>
	                        <p class="ing"><i class="icon-svg-state"></i>학습 진행중</p>
	                        <p class="no"><i class="icon-svg-state"></i>학습 미완료</p>
	                    </div>

	                    <!-- week_area -->
	                    <div class="week_area">
	                        <div class="info-week"><!-- info-week -->
	                            <div class="title">학습현황</div>
	                            <div class="week_state_list"><!-- week_state_list -->
	                            	<c:choose>
									    <c:when test="${empty subjectVM.lectureScheduleList}">
									        <li>학습주차일정정보가 없습니다.</li>
									    </c:when>
								    	<c:otherwise>
			                       			<c:forEach var="item" items="${subjectVM.lectureScheduleList}">
			                                   <div class="state">
			                                       <div class="state_icon ok" aria-label="학습완료"><i class="icon-svg-state"></i></div>
			                                       <span class="week">학생${item.lctrWkno}</span>
			                                   </div>
			                               	</c:forEach>
			                           	</c:otherwise>
			                       	</c:choose>
	                            </div><!--//week_state_list -->
	                        </div>
	                        <!-- //info-week -->

	                        <!-- info-set -->
	                        <div class="info-set">
	                            <i class="icon-svg-alarm-clock" aria-hidden="true"></i>
	                            <div class="info">
	                                <p class="point">
	                                    <span class="tit">중간고사:</span>
	                                    <span><uiex:formatDate value="${subjectVM.middleLastExam.midExamSdttm}" type="date"/></span>
	                                </p>
	                                <p class="desc">
	                                    <span class="tit">시간:</span>
	                                    <span>${subjectVM.middleLastExam.midExamMnts}분</span>
	                                </p>
	                            </div>
	                            <div class="info">
	                                <p class="point">
	                                    <span class="tit">기말고사:</span>
	                                    <span><uiex:formatDate value="${subjectVM.middleLastExam.lstExamSdttm}" type="date"/></span>
	                                </p>
	                                <p class="desc">
	                                    <span class="tit">시간:</span>
	                                    <span>${subjectVM.middleLastExam.lstExamMnts}분</span>
	                                </p>
	                            </div>
	                        </div>
	                        <!-- //info-set -->
	                    </div>
	                    <!-- //week_area -->

	                    <!--  강의목록top -->
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
	                    <!--//강의목록top -->

                        <!-- course_list 목록형 [목록형은 교수의 목록형과 같이 사용-->
                        <div class="course_list" style="display:none;">
	                        <ul class="accordion course_week">
		                        <c:set var="PREV_LCTR_WKNO_SCHDL_ID" value="" />
								<c:forEach var="item" items="${subjectVM.byWeeknoLectureSchdlList}">
								    <!-- 주차 -->
								    <c:if test="${item.srcTbl == 'TB_LMS_LCTR_WKNO_SCHDL' && item.firstOrd == 0 }"> <!-- 0이면 주차 타이틀, 1이면 학습콘텐츠, 2이면 학습자료추가-->
								        <c:set var="PREV_LCTR_WKNO_SCHDL_ID" value="${item.lctrWknoSchdlId}" />
								        <!-- active 추가 -->
		                                <li class="active">
		                                    <div class="title-wrap">
		                                        <a class="title" href="#">
		                                            <i class="arrow xi-angle-down"></i>
		                                            <strong>${item.seqno}주차 ${item.nm}</strong>
		                                            <p class="labels">
		                                                <label class="label s_online">온라인</label>
		                                                <label class="label s_offline">오프라인</label>
		                                                <label class="label s_ing">공개</label>
		                                                <label class="label s_finish">마감</label>
		                                     	       </p>
		                                            <p class="desc">
		                                                <span>학습기간<strong>
		                                                	<span class="date"><uiex:formatDate value="${item.sdttm}" type="date"/></span>
		                                                	 ~ <span class="date"><uiex:formatDate value="${item.edttm}" type="date"/></span>
		                                                	</strong></span>
		                                                <span>출석<strong>35</strong></span>
		                                                <span>지각<strong>3</strong></span>
		                                                <span>결석<strong>2</strong></span>
		                                            </p>
		                                        </a>
			                                    <div class="btn_right">
		                                            <button class="btn s_basic down">음성</button>
		                                            <button class="btn s_basic down">강의노트</button>
		                                            <button class="btn s_type1">출결관리</button>
		                                            <button class="btn s_type2">강의보기</button>
		                                            <div class="dropdown">
		                                                <button type="button" class="btn basic icon set settingBtn" aria-label="주차 관리">
		                                                    <i class="xi-ellipsis-v"></i>
		                                                </button>
		                                                <div class="optionWrap option-wrap">
		                                                    <div class="item"><a href="#0">주차 수정</a></div>
		                                                    <div class="item"><a href="#0">주차 추가</a></div>
		                                                </div>
		                                            </div>
			                                     </div>
			                                </div>

			                                <!-- divcont -->
			                            	<div class="cont">
									</c:if>
								    <!--//주차-->

										    <!-- 학습콘텐츠 -->
										    <c:if test="${item.firstOrd == '1'}">
										    <!-- n차시와 성적활동 -->

										    <c:choose>

		                                        <c:when test="${ item.seqno != 0 }">
									                <div class="lecture_box">
			                                            <div class="lecture_tit">
			                                                <p class="labels">
			                                                   	<label class="label s_chasi">${item.seqno}차시</label>
			                                                    <label class="label s_basic">동영상</label>
			                                                </p>
			                                                <strong>${item.nm}</strong>
			                                            </div>
			                                            <div class="btn_right">
			                                                <div class="desc_info">
			                                                    <span>출석율<strong class="navy">52%</strong></span>
			                                                </div>
			                                                <button class="btn s_basic play">강의보기</button>
			                                                <div class="dropdown">
			                                                    <button type="button" class="btn basic icon set settingBtn" aria-label="차시 관리">
			                                                        <i class="xi-ellipsis-v"></i>
			                                                    </button>
			                                                    <div class="optionWrap option-wrap">
			                                                        <div class="item"><a href="#0">차시 수정</a></div>
			                                                        <div class="item"><a href="#0">차시 삭제</a></div>
			                                                    </div>
			                                                </div>
			                                            </div>
			                                        </div>
			                                    </c:when>

			                                    <c:when test="${ item.seqno == 0 }">

			                                    	<c:if test="${item.srcTbl == 'TB_LMS_EXAM_BSC.EXAM'}">
				                                    	<div class="lecture_box">
				                                            <div class="lecture_tit">
				                                                <p class="labels">
				                                                   	<label class="label s_test">시험</label>
				                                                </p>
				                                                <strong>${item.nm}</strong>
				                                            </div>
				                                            <div class="btn_right">
				                                                <div class="desc_info">
				                                                    <span>시험일시<strong>2025.07.22 16:00</strong></span>
				                                                </div>
				                                                <button class="btn s_basic">시험응시<i class="icon-svg-arrow"></i></button>
				                                            </div>
				                                        </div>
			                                        </c:if>

			                                        <c:if test="${item.srcTbl == 'TB_LMS_EXAM_BSC.QUIZ'}">
				                                    	<div class="lecture_box">
				                                            <div class="lecture_tit">
				                                                <p class="labels">
				                                                   	<label class="label s_test">퀴즈</label>
				                                                </p>
				                                                <strong>${item.nm}</strong>
				                                            </div>
				                                            <div class="btn_right">
				                                                <div class="desc_info">
				                                                    <span>시험일시<strong>2025.07.22 16:00</strong></span>
				                                                </div>
				                                                <button class="btn s_basic">시험응시<i class="icon-svg-arrow"></i></button>
				                                            </div>
				                                        </div>
			                                        </c:if>

			                                    	<c:if test="${item.srcTbl == 'TB_LMS_ASMT'}">
				                                    	<div class="lecture_box">
				                                            <div class="lecture_tit">
				                                                <p class="labels">
				                                                   	<label class="label s_work">과제</label>
				                                                </p>
				                                                <strong>${item.nm}</strong>
				                                            </div>
				                                            <div class="btn_right mr">
				                                                <div class="desc_info">
				                                                    <span>제출<strong>20</strong></span>
				                                                    <span>지각<strong>12</strong></span>
				                                                    <span>미제출<strong>2</strong></span>
				                                                </div>
				                                                <button class="btn s_basic set">과제관리</button>
				                                            </div>
				                                        </div>
			                                        </c:if>

			                                        <c:if test="${item.srcTbl == 'TB_LMS_DSCS'}">
				                                    	<div class="lecture_box">
				                                            <div class="lecture_tit">
				                                                <p class="labels">
				                                                   	<label class="label s_debate">토론</label>
				                                                </p>
				                                                <strong>${item.nm}</strong>
				                                            </div>
				                                            <div class="btn_right mr">
				                                                <div class="desc_info">
				                                                    <span>참여<strong>18</strong></span>
                                                    				<span>미참여<strong>2</strong></span>
				                                                </div>
				                                                <button class="btn s_basic set">토론관리</button>
				                                            </div>
				                                        </div>
			                                        </c:if>

			                                        <c:if test="${item.srcTbl == 'TB_LMS_SRVY'}">
				                                    	<div class="lecture_box">
				                                            <div class="lecture_tit">
				                                                <p class="labels">
				                                                   	<label class="label s_seminar">설문</label>
				                                                </p>
				                                                <strong>${item.nm}</strong>
				                                            </div>
				                                            <div class="btn_right mr">
				                                                <div class="desc_info">
				                                                    <span>참여<strong>18</strong></span>
                                                    				<span>미참여<strong>2</strong></span>
				                                                </div>
				                                                <button class="btn s_basic set">설문관리</button>
				                                            </div>
				                                        </div>
			                                        </c:if>

			                                        <c:if test="${item.srcTbl == 'TB_LMS_SMNR'}">
				                                    	<div class="lecture_box seminar">
				                                            <div class="lecture_tit">
				                                                <p class="labels">
				                                                   	<label class="label s_seminar">세미나</label>
				                                                </p>
				                                                <strong>${item.nm}</strong>
				                                            </div>
				                                            <div class="btn_right mr">
				                                                <div class="desc_info">
				                                                    <span>출석<strong>20</strong></span>
				                                                    <span>지각<strong>3</strong></span>
				                                                    <span>결석<strong>1</strong></span>
				                                                </div>
				                                                <button class="btn s_basic set">세미나관리</button>
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
			                                        </c:if>

			                                        <c:if test="${item.srcTbl == 'TB_LMS_BBS'}">
				                                    	<div class="lecture_box">
				                                            <div class="lecture_tit">
				                                                <p class="labels">
				                                                   	<label class="label s_chasi">자료</label>
				                                                </p>
				                                                <strong>${item.nm}</strong>
				                                            </div>
				                                            <div class="btn_right mr">
				                                                <button class="btn s_basic set">학습자료</button>
				                                            </div>
				                                        </div>
			                                        </c:if>

			                                	</c:when>
			                                </c:choose>
											</c:if>
									<!--//학습콘텐츠 -->

										<!--학습자료추가 -->
							    		<c:if test="${item.srcTbl == 'TB_LMS_LCTR_WKNO_SCHDL' && item.firstOrd == 2}">
										        <div class="lecture_add_box">
		                                            <div class="box_item">
		                                                <div class="title">학습자료 추가<i class="xi-plus-min"></i></div>
		                                                <div class="item_btns">
		                                                    <a href="#0"><i class="icon-svg-play-circle" aria-hidden="true"></i><span>동영상</span></a>
		                                                    <a href="#0"><i class="icon-svg-layout-alt" aria-hidden="true"></i><span>PDF</span></a>
		                                                    <a href="#0"><i class="icon-svg-paperclip" aria-hidden="true"></i><span>파일</span></a>
		                                                    <a href="#0"><i class="icon-svg-share" aria-hidden="true"></i><span>소셜</span></a>
		                                                    <a href="#0"><i class="icon-svg-link" aria-hidden="true"></i><span>웹링크</span></a>
		                                                    <a href="#0"><i class="icon-svg-type-square" aria-hidden="true"></i><span>텍스트</span></a>
		                                                </div>
		                                            </div>
		                                            <div class="box_item">
		                                                <div class="title">학습요소 추가<i class="xi-plus-min"></i></div>
		                                                <div class="item_btns">
		                                                    <a href="/asmt2/profAsmtListView.do?sbjctId=${subjectVM.subjectVO.sbjctId}"><i class="icon-svg-edit" aria-hidden="true"></i><span>과제</span></a>
		                                                    <a href="/quiz/profQuizListView.do?sbjctId=${subjectVM.subjectVO.sbjctId}"><i class="icon-svg-quiz" aria-hidden="true"></i><span>퀴즈</span></a>
		                                                    <a href="/exam/profExamListView.do?sbjctId=${subjectVM.subjectVO.sbjctId}"><i class="icon-svg-alarm-clock" aria-hidden="true"></i><span>시험</span></a>
		                                                    <a href="/forum2/forumLect/profForumListView.do?sbjctId=${subjectVM.subjectVO.sbjctId}"><i class="icon-svg-message-chat" aria-hidden="true"></i><span>토론</span></a>
		                                                    <a href="/srvy/profSrvyListView.do?sbjctId=${subjectVM.subjectVO.sbjctId}"><i class="icon-svg-check-done" aria-hidden="true"></i><span>설문</span></a>
		                                                    <a href="/smnr/profSmnrListView.do?sbjctId=${subjectVM.subjectVO.sbjctId}"><i class="icon-svg-presentation" aria-hidden="true"></i><span>세미나</span></a>
		                                                </div>
		                                            </div>
		                                        </div>
		                                     </div>
		                                     <!-- //divcont -->
                                			</li>
										</c:if>
									<!--//학습자료추가 -->
								</c:forEach>
							</ul>
                        </div>
                        <!-- //course_list 목록형 -->


                        <!-- courst_list 카드형 -->
                        <div class="course_list">
                            <ul class="course_week_card">
                            	<c:forEach var="item" items="${subjectVM.byWeeknoLectureSchdlList}">

                            		<c:if test="${item.srcTbl == 'TB_LMS_LCTR'}">
		                                <li>
		                                    <div class="card_item">
		                                        <div class="item_header">
		                                            <div class="title_area">
		                                                <p class="tit">${item.wkno}주차 ${item.seqno}차시 강의</p>
		                                            </div>
		                                             <div class="lecture_tit">
		                                                <p class="labels">
		                                                    <label class="label s_basic">동영상</label>
		                                                </p>
		                                                <strong>${item.nm}</strong>
		                                            </div>
		                                        </div>
		                                        <div class="extra">
		                                            <p class="desc">
		                                                <span>학습기간<strong><span class="date"><uiex:formatDate value="${item.sdttm}" type="date"/>
		                                                 ~ <span class="date"><uiex:formatDate value="${item.edttm}" type="date"/></strong></span>
		                                                <span>강의시간<strong>106분</strong><strong>순차학습</strong></span>
		                                                <span>진도율<strong class="navy">52%</strong></span>
		                                            </p>
		                                        </div>
		                                        <div class="bottom_button">
		                                            <button class="go">강의보기<i class="icon-svg-play-circle" aria-hidden="true"></i></button>
		                                        </div>
		                                    </div>
		                                </li>
		                        	</c:if>

	                                <c:if test="${item.srcTbl == 'TB_LMS_ASMT'}">
		                                <li>
		                                    <div class="card_item">
		                                        <div class="item_header">
		                                            <div class="title_area">
		                                                <p class="tit">${item.wkno}주차 과제</p>
		                                            </div>
		                                             <div class="lecture_tit">
		                                                <p class="labels">
		                                                    <label class="label s_work">과제</label>
		                                                </p>
		                                                <strong>${item.nm}</strong>
		                                            </div>
		                                        </div>
		                                        <div class="extra">
		                                            <p class="desc">
		                                                <span>학습기간<strong><span class="date"><uiex:formatDate value="${item.sdttm}" type="date"/> ~
		                                                <span class="date"><uiex:formatDate value="${item.edttm}" type="date"/></strong></span>
		                                                <span>강의시간<strong>106분</strong><strong>순차학습</strong></span>
		                                                <span>진도율<strong class="navy">52%</strong></span>
		                                            </p>
		                                        </div>
		                                        <div class="bottom_button">
		                                            <button class="go">제출하기<i class="icon-svg-arrow" aria-hidden="true"></i></button>
		                                        </div>
		                                    </div>
		                                </li>
		                        	</c:if>


		                        	<c:if test="${item.srcTbl == 'TB_LMS_DSCS'}">
		                                <li>
		                                    <div class="card_item">
		                                        <div class="item_header">
		                                            <div class="title_area">
		                                                <p class="tit">${item.wkno}주차 토론</p>
		                                            </div>
		                                             <div class="lecture_tit">
		                                                <p class="labels">
		                                                    <label class="label s_debate">토론</label>
		                                                </p>
		                                                <strong>${item.nm}</strong>
		                                            </div>
		                                        </div>
		                                        <div class="extra">
		                                            <p class="desc">
		                                                <span>학습기간<strong><span class="date"><uiex:formatDate value="${item.sdttm}" type="date"/> ~
		                                                <span class="date"><uiex:formatDate value="${item.edttm}" type="date"/></strong></span>
		                                                <span>강의시간<strong>106분</strong><strong>순차학습</strong></span>
		                                                <span>진도율<strong class="navy">52%</strong></span>
		                                            </p>
		                                        </div>
		                                        <div class="bottom_button">
		                                            <button class="go">참여하기<i class="icon-svg-arrow" aria-hidden="true"></i></button>
		                                        </div>
		                                    </div>
		                                </li>
		                        	</c:if>

		                        	<c:if test="${item.srcTbl == 'TB_LMS_SRVY'}">
		                                <li>
		                                    <div class="card_item">
		                                        <div class="item_header">
		                                            <div class="title_area">
		                                                <p class="tit">${item.wkno}주차 설문</p>
		                                            </div>
		                                             <div class="lecture_tit">
		                                                <p class="labels">
		                                                    <label class="label s_seminar">설문</label>
		                                                </p>
		                                                <strong>${item.nm}</strong>
		                                            </div>
		                                        </div>
		                                        <div class="extra">
		                                            <p class="desc">
		                                                <span>학습기간<strong><span class="date"><uiex:formatDate value="${item.sdttm}" type="date"/> ~
		                                                <span class="date"><uiex:formatDate value="${item.edttm}" type="date"/></strong></span>
		                                                <span>강의시간<strong>106분</strong><strong>순차학습</strong></span>
		                                                <span>진도율<strong class="navy">52%</strong></span>
		                                            </p>
		                                        </div>
		                                        <div class="bottom_button">
		                                            <button class="go">참여하기<i class="icon-svg-arrow" aria-hidden="true"></i></button>
		                                        </div>
		                                    </div>
		                                </li>
		                        	</c:if>

		                        	<c:if test="${item.srcTbl == 'TB_LMS_SMNR'}">
		                                <li>
		                                    <div class="card_item">
		                                        <div class="item_header">
		                                            <div class="title_area">
		                                                <p class="tit">${item.wkno}주차 세미나</p>
		                                            </div>
		                                             <div class="lecture_tit">
		                                                <p class="labels">
		                                                    <label class="label s_seminar">설문</label>
		                                                </p>
		                                                <strong>${item.nm}</strong>
		                                            </div>
		                                        </div>
		                                        <div class="extra">
		                                            <p class="desc">
		                                                <span>학습기간<strong><span class="date"><uiex:formatDate value="${item.sdttm}" type="date"/></strong></span>
		                                                <span>강의시간<strong>106분</strong><strong>순차학습</strong></span>
		                                                <span>진도율<strong class="navy">52%</strong></span>
		                                            </p>
		                                        </div>
		                                        <div class="bottom_button">
		                                            <button class="go">참여하기<i class="icon-svg-arrow" aria-hidden="true"></i></button>
		                                        </div>
		                                    </div>
		                                </li>
		                        	</c:if>

		                        	<c:if test="${item.srcTbl == 'TB_LMS_EXAM_BSC.EXAM'}">
		                                <li>
		                                    <div class="card_item">
		                                        <div class="item_header">
		                                            <div class="title_area">
		                                                <p class="tit">${item.wkno}주차 ${item.nm}</p>
		                                            </div>
		                                             <div class="lecture_tit">
		                                                <p class="labels">
		                                                    <label class="label s_test">시험</label>
		                                                </p>
		                                                <strong>${item.nm}</strong>
		                                            </div>
		                                        </div>
		                                        <div class="extra">
		                                            <p class="desc">
		                                                <span>학습기간<strong><span class="date"><uiex:formatDate value="${item.sdttm}" type="date"/></strong></span>
		                                                <span>시험시간<strong>50분</strong><strong>순차학습</strong></span>
		                                                <span><strong>출석인정</strong></span>
		                                            </p>
		                                        </div>
		                                        <div class="bottom_button">
		                                            <button class="go">시험응시<i class="icon-svg-arrow" aria-hidden="true"></i></button>
		                                        </div>
		                                    </div>
		                                </li>
		                        	</c:if>

		                        	<c:if test="${item.srcTbl == 'TB_LMS_EXAM_BSC.QUIZ'}">
		                                <li>
		                                    <div class="card_item">
		                                        <div class="item_header">
		                                            <div class="title_area">
		                                                <p class="tit">${item.wkno}주차 ${item.nm}</p>
		                                            </div>
		                                             <div class="lecture_tit">
		                                                <p class="labels">
		                                                    <label class="label s_test">퀴즈</label>
		                                                </p>
		                                                <strong>${item.nm}</strong>
		                                            </div>
		                                        </div>
		                                        <div class="extra">
		                                            <p class="desc">
		                                                <span>학습기간<strong><span class="date"><uiex:formatDate value="${item.sdttm}" type="date"/></strong></span>
		                                                <span>시험시간<strong>50분</strong><strong>순차학습</strong></span>
		                                                <span><strong>출석인정</strong></span>
		                                            </p>
		                                        </div>
		                                        <div class="bottom_button">
		                                            <button class="go">퀴즈응시<i class="icon-svg-arrow" aria-hidden="true"></i></button>
		                                        </div>
		                                    </div>
		                                </li>
		                        	</c:if>

                                </c:forEach>
                            </ul>
                        </div>
                        <!-- //courst_list 카드형 -->

					</div>
					<!--  //segment -->

				</div>
				<!-- //class_sub -->

			</div>
			<!-- //content -->
        </main>
        <!-- //main-->
    </div>
    <!-- //div main -->
</body>
</html>