<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
	<jsp:param name="style" value="classroom"/>
</jsp:include>
<link rel="stylesheet" type="text/css" href="/webdoc/assets/css/classroom.css" />

<script type="text/javascript">
function loadLctrPlandocPopView(sbjctId) {	
    fetch('/lctr/plandoc/profLctrPlandocPopView.do?subjectId=' + encodeURIComponent(sbjctId))
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


function loadLessonProgressManage(sbjctId) {	
    fetch('/lesson/lessonMgr/lessonProgressManage.do?subjectId=' + encodeURIComponent(sbjctId))
        .then(response => response.text())
        .then(data => {
            const div = document.getElementById('lessonProgressManagePopView');
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
            document.getElementById('lessonProgressManagePopView').innerHTML = '에러 발생';
            console.error(error);
        });
}
</script>
<body class="class colorA "><!-- 컬러선택시 클래스변경 -->
<div style="display:none;" id="lecturePlanDoc"></div>
<div style="display:none;" id="lessonProgressManagePopView"></div>
    <div id="wrap" class="main">

        <!-- common header --> <!--  filename: prof_layout_classroom.jsp -->
        <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>
        <!-- //common header -->

        <!-- classroom -->
        <main class="common">

			<!-- gnb -->
			<jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp"/>
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
								<option value="2026년 1학기">2026년 1학기</option>
								<option value="2026년 2학기">2026년 2학기</option>
							</select>
							<select class="form-select wide">
								<option value="">강의실 바로가기</option>
								<option value="2026년 1학기">2026년 1학기</option>
								<option value="2026년 2학기">2026년 2학기</option>
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
					<div class="segment class-area">

						<!-- info-left -->
						<div class="info-left">
							<div class="class_info">
                                <h2>${subjectVM.subjectVO.sbjctnm}</h2>
                                <div class="classSection">
                                    <div class="cls_btn">
                                        <a href="javascript:void(0); onclick=loadLctrPlandocPopView('${subjectVM.subjectVO.sbjctId}');" class="btn">강의 계획서</a>
                                        <a href="javascript:void(0); onclick=loadLessonProgressManage('${subjectVM.subjectVO.sbjctId}');" class="btn" class="btn">학습진도관리</a>
                                        <a href="#0" class="btn">평가 기준</a>
                                    </div>
                                </div>
                            </div>
                            <div class="info-cnt">
                                <div class="info_iconSet">
                                	<c:forEach var="item" items="${subjectVM.subjectLearingActvList}">
	                                    <a href="/bbs/bbsHome/bbsAtclListView.do?subjectId=${subjectVM.subjectVO.sbjctId}" class="info"><span>공지</span><div class="num_txt">${item.ntcCnt}</div></a>
	                                    <a href="/bbs/bbsHome/bbsAtclListView.do?subjectId=${subjectVM.subjectVO.sbjctId}" class="info"><span>Q&A</span><div class="num_txt point">${item.qnaCnt}</div></a>
	                                    <a href="/bbs/bbsHome/bbsAtclListView.do?subjectId=${subjectVM.subjectVO.sbjctId}" class="info"><span>1:1</span><div class="num_txt point">${item.oneononeCnt}</div></a>
	                                    <a href="/asmt2/profAsmtListView.do?subjectId=${subjectVM.subjectVO.sbjctId}" class="info"><span>과제</span><div class="num_txt">${item.asmtCnt}</div></a>
	                                    <a href="/forum2/forumLect/profForumListView.do?subjectId=${subjectVM.subjectVO.sbjctId}" class="info"><span>토론</span><div class="num_txt">${item.dscsCnt}</div></a>
	                                    <a href="/smnr/profSmnrListView.do?subjectId=${subjectVM.subjectVO.sbjctId}" class="info"><span>세미나</span><div class="num_txt">${item.smnrCnt}</div></a>
	                                    <a href="/quiz/profQuizListView.do?subjectId=${subjectVM.subjectVO.sbjctId}" class="info"><span>퀴즈</span><div class="num_txt">${item.quizCnt}</div></a>
	                                    <a href="/srvy/profSrvyListView.do?subjectId=${subjectVM.subjectVO.sbjctId}" class="info"><span>설문</span><div class="num_txt">${item.srvyCnt}</div></a>
	                                    <a href="/exam/profExamListView.do?subjectId=${subjectVM.subjectVO.sbjctId}" class="info"><span>시험</span><div class="num_txt">${item.examCnt}</div></a>	                                    
                                    </c:forEach>
                                </div>
                                <div class="info-set">
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
                            </div>
						</div>
						<!--//info-left -->

						<!-- info-right-->
						<div class="info-right">

							<!-- flex -->
							<div class="flex">

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
	                                            <p class="user_num">접속: ${sbjctConnectStdCnt}</p><!-- 접속 -->
	                                            <button type="button" class="btn-close" aria-label="접속현황 닫기"><!-- 접속현황닫기 -->
	                                                <i class="icon-svg-close"></i>
	                                            </button>
	                                        </div>
                                            <ul class="user_area"><!-- 현재접속자목록 li loop-->
                                            	<c:if test="${not empty stdntSubjectConnectList}">
	                                            	<c:forEach var="item" items="${stdntSubjectConnectList}">				                                    
		                                                <li>
		                                                    <div class="user-info">
		                                                        <div class="user-photo">
		                                                            <img src="/webdoc/assets/img/common/photo_user_sample2.jpg" aria-hidden="true" alt="사진"> <!-- 사진 -->
		                                                        </div>
		                                                        <div class="user-desc">
		                                                            <p class="name">${item.usernm}</p>
		                                                            <p class="subject"><span class="major">[${item.orgnm}]</span>${item.sbjctnm}</p> <!-- 대학원 --> <!-- 과목명 -->
		                                                        </div>
		                                                        <div class="btn_wrap">
		                                                            <button type="button"><i class="xi-info-o"></i></button><!-- 정보 -->
		                                                            <button type="button"><i class="xi-bell-o"></i></button><!-- 알림 -->
		                                                        </div>
		                                                    </div>
		                                                </li>
		                                        	</c:forEach>
		                                    	</c:if>		                                                                                        
                                            </ul>
                                        </div>
                                        <!-- //접속현황레이어팝업-->
                                    </div>
                                    <!-- //item_tit -->

                                    <div class="item_info">
                                        <span class="big">${sbjctConnectStdCnt}</span><!-- 과목접속자수 -->
                                        <span class="small">${sbjctTotalStdCnt}</span><!-- 과목수강생수 -->
                                    </div>
                                </div>
                                <!-- //item user-->

								<div class="item attend">
                                    <div class="item_icon"><i class="icon-svg-pie-chart-01" aria-hidden="true"></i></div>
                                    <div class="item_tit">${lctrWknoSchdlVO.lctrWkno}주차 출석 ${lctrWknoAtndcrt.atndCnt} / ${sbjctTotalStdCnt}</div>
                                    <div class="item_info">
                                        <span class="big">${lctrWknoAtndcrt.atndRate}</span>
                                        <span class="small">%</span>
                                    </div>
                                </div>

								<div class="item week">
                                       <div class="item_icon"><i class="icon-svg-calendar-check-02" aria-hidden="true"></i></div>
                                       <div class="item_tit"><uiex:formatDate value="${lctrWknoSchdlVO.lctrWknoSymd}" type="date"/>
                                       ~ <uiex:formatDate value="${lctrWknoSchdlVO.lctrWknoEymd}" type="monthday"/></div><!-- 주차기간 -->
                                       <div class="item_info">
                                           <span class="big">${lctrWknoSchdlVO.lctrWkno}</span><!-- 현재주차 -->
                                           <span class="small">주차</span><!-- 주차 -->
                                       </div>
                                </div>
							</div>
							<!-- //flex -->

						</div>
						<!-- info-right-->

					</div>
					<!-- //강의실 상단 -->

					<!-- contents-->	
					<jsp:include page="${contentPage}" />
					<!-- //contents-->

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