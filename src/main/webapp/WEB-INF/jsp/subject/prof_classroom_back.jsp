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

        <!-- common header -->
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
							<!-- //flex -->

						</div>
						<!-- info-right-->

					</div>
					<!-- //강의실 상단 -->


					<!-- segment row -->
					<div class="segment-row">

						<!-- 과목공지사항 -->
						<div class="segment">
                            <div class="box_title">
                                <i class="icon-svg-notice"></i>
                                <h3 class="h3">과목 공지사항
                                <c:if test="${not empty subjectVM.subjectTopNoticeList}">
                                	<small class="msg_num">${subjectVM.badge.noticeUnreadCnt}</small></h3><!-- 과목 공지사항-->
                                </c:if>                                
                                <div class="btn-wrap">
                                    <a href="/bbs/bbsHome/bbsAtclListView.do?bbsId=${subjectVM.subjectBbsIds.ntcBbsId}" class="btn_more"><i class="xi-plus"></i></a>
                                </div>
                            </div>
                            <div class="box_content">
                            	<ul class="dash_item_listA">
		                            <c:choose>
									    <c:when test="${empty subjectVM.subjectTopNoticeList}">
									        <li>과목공지사항이 없습니다</li>
									    </c:when>
									    <c:otherwise>
		                                	<c:forEach var="item" items="${subjectVM.subjectTopNoticeList}">
		                                		<c:set var="cnt" value="0"/>
			                                    <c:if test="${item.topic eq 'SUBJECT_TOP_NOTICE' and cnt lt 3}">
				                                    <li class="dot">
				                                        <a href="/bbs/bbsHome/bbsAtclListView.do?bbsId=${item.bbsId}" class="item_txt">
				                                            <p class="tit">${item.atclTtl}</p>
				                                            <p class="desc">
				                                                <span class="date" style="display:inline-block; width:90px;"><uiex:formatDate value="${item.regDttm}" type="date"/></span>
				                                            </p>
				                                        </a>
				                                        <div class="state">
				                                        	<c:choose>
					                                            <c:when test="${empty item.vwerId}">
					                                            	<label class="label check_no">읽지않음</label>
					                                            </c:when>
											         			<c:otherwise>
											         				<label class="label check">읽음</label>
											         			</c:otherwise>
											         		</c:choose>
				                                        </div>
				                                    </li>
				                                    <c:set var="cnt" value="${cnt + 1}"/>
				                            	</c:if>
		                                    </c:forEach>
									    </c:otherwise>
									</c:choose>
								</ul>
                            </div>
                        </div>
						<!-- //공지사항 -->

                        <!-- 강의Q&A -->
                        <div class="segment">
                            <div class="box_title">
                                <i class="icon-svg-question"></i>
                                <h3 class="h3">강의 Q&A 
                                <c:if test="${not empty subjectVM.subjectTopLctrQnaList}">
                                	<small class="msg_num">${subjectVM.badge.qnaNoreplyCnt}</small>
                                </c:if>
                                </h3>
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
		                                		<c:set var="cnt" value="0"/>
			                                    <c:if test="${item.topic eq 'SUBJECT_TOP_LCTR_QNA' and cnt lt 3}">
			                                    	<li>
				                                        <div class="user">
				                                           <span class="user_img"></span>
				                                        </div>
				                                        <a href="/bbs/bbsHome/bbsAtclListView.do?bbsId=${item.bbsId}" class="item_txt">
				                                            <p class="tit">${item.atclTtl}</p>
				                                            <p class="desc">
				                                                <span class="name">${item.usernm}</span>
				                                                <span class="date" style="display:inline-block; width:90px;"><uiex:formatDate value="${item.regDttm}" type="date"/></span>
				                                            </p>
				                                        </a>
				                                        <div class="state">
					                                        <c:choose>
					                                            <c:when test="${empty item.answerCnt}">
					                                            	<label class="label check_no">미답변</label>
					                                            </c:when>
											         			<c:otherwise>
											         				<label class="label check_reply">답변</label>
											         			</c:otherwise>
											         		</c:choose>
											         	</div>
				                                    </li>
				                                    <c:set var="cnt" value="${cnt + 1}"/>
				                            	</c:if>
		                                    </c:forEach>
	                                	</ul>
								    </c:otherwise>
								</c:choose>
							</div>
						</div>
                        <!-- //강의Q&A -->

                        <!-- 1:1 상담 -->
                        <div class="segment">
                            <div class="box_title">
                                <i class="icon-svg-message"></i>
                                <h3 class="h3">1:1 상담
                                	<c:if test="${not empty subjectVM.profSubjectTopOneOnOneList}">
                                		<small class="msg_num">${subjectVM.badge.oneOnOneNoreplyCnt}</small>
                                	</c:if>
                                </h3>
                                <div class="btn-wrap">
                                    <a href="/bbs/bbsHome/bbsAtclListView.do?bbsId=${subjectVM.subjectBbsIds.oneOnOneBbsId}" class="btn_more"><i class="xi-plus"></i></a>
                                </div>
                            </div>
                            <div class="box_content">
                           		<ul class="dash_item_listA">
		                            <c:choose>
									    <c:when test="${empty subjectVM.profSubjectTopOneOnOneList}">
									        <li>1:1 상담이 없습니다</li>
									    </c:when>
									    <c:otherwise>
		                                	<c:forEach var="item" items="${subjectVM.profSubjectTopOneOnOneList}">
			                                    <c:set var="cnt" value="0"/>
													<c:if test="${item.topic eq 'PROF_SUBJECT_TOP_1ON1' and cnt lt 3}">
													<li>
				                                        <div class="user">
				                                           <span class="user_img"><img src="<%=request.getContextPath()%>/webdoc/assets/img/common/photo_user_sample3.jpg" aria-hidden="true" alt="사진"></span>
				                                        </div>
				                                        <a href="/bbs/bbsHome/bbsAtclListView.do?bbsId=${item.bbsId}" class="item_txt">
				                                            <p class="tit">${item.atclTtl}​</p>
				                                            <p class="desc">
				                                                <span class="name">${item.usernm}</span>
				                                                <span class="date" style="display:inline-block; width:90px;"><uiex:formatDate value="${item.regDttm}" type="date"/></span>
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
				                                    <c:set var="cnt" value="${cnt + 1}"/>
				                            	</c:if>
			                                </c:forEach>
	                               		</c:otherwise>
	                            	</c:choose>
	                            </ul>
							</div>
                        </div>
                        <!-- //1대1상담 -->

                    </div>
					<!-- //segment row -->

					<!-- segment-->		
					<div class="segment">
					
						<!-- 강의목록top -->
						<div class="board_top">
                            <i class="icon-svg-openbook"></i>
                            <h3 class="board-title">강의목록</h3>
                        </div>
                        <div class="week_attend_list">
                        	<c:choose>
							    <c:when test="${empty subjectVM.profLectureScheduleList}">
							        <li>학습주차일정정보가 없습니다.</li>
							    </c:when>
							    <c:otherwise>
		                        	<c:forEach var="item" items="${subjectVM.profLectureScheduleList}" varStatus="status">
			                            <div class="state">
			                                <span class="week">${item.lctrWkno}</span>
			                                <span class="percent">${status.index < 4 ? "100%" : status.index < 6 ? "10%" : "0%"}</span>
			                            </div>
		                            </c:forEach>
		                        </c:otherwise>
		                	</c:choose>
                        </div>
                        <div class="board_top course">
                            <button type="button" class="btn basic">주차 접음</button>
                            <select class="form-select">
                            	<option value="전체 주차">전체 주차</option>
                            	<c:forEach var="item" items="${subjectVM.byWeeknoLectureSchdlList}">
                            		<c:if test="${item.srcTbl == 'TB_LMS_LCTR_WKNO_SCHDL' && item.firstOrd == 0 }">                                
		                                <option value="${item.wkno}">${item.wkno}주차</option>
		                            </c:if>
	                            </c:forEach>
                            </select>
                            <div class="right-area">
                                <button type="button" class="btn basic icon" aria-label="주차 오름차순"><i class="xi-sort-asc"></i></button>
                                <button type="button" class="btn basic icon" aria-label="주차 내림차순"><i class="xi-sort-desc"></i></button>
                            </div>
                        </div>
						<!-- //강의목록top -->
						
                        <!-- course_list 목록형-->
                        <div class="course_list">
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
		                                            <strong>${item.wkno}주차 ${item.nm}</strong>
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
				                                                    <span>시험일시<strong><uiex:formatDate value="${item.sdttm}" type="date"/></strong></span>
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
				                                                    <span>시험일시<strong><uiex:formatDate value="${item.sdttm}" type="date"/></strong></span>
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
				                                                        <span>시작일시 :<strong><uiex:formatDate value="${item.sdttm}" type="date"/></strong></span>
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
		                                                    <a href="/asmt2/profAsmtListView.do?subjectId=${subjectVM.subjectVO.sbjctId}"><i class="icon-svg-edit" aria-hidden="true"></i><span>과제</span></a>
		                                                    <a href="/quiz/profQuizListView.do?subjectId=${subjectVM.subjectVO.sbjctId}"><i class="icon-svg-quiz" aria-hidden="true"></i><span>퀴즈</span></a>
		                                                    <a href="/exam/profExamListView.do?subjectId=${subjectVM.subjectVO.sbjctId}"><i class="icon-svg-alarm-clock" aria-hidden="true"></i><span>시험</span></a>
		                                                    <a href="/forum2/forumLect/profForumListView.do?subjectId=${subjectVM.subjectVO.sbjctId}"><i class="icon-svg-message-chat" aria-hidden="true"></i><span>토론</span></a>
		                                                    <a href="/srvy/profSrvyListView.do?subjectId=${subjectVM.subjectVO.sbjctId}"><i class="icon-svg-check-done" aria-hidden="true"></i><span>설문</span></a>
		                                                    <a href="/smnr/profSmnrListView.do?subjectId=${subjectVM.subjectVO.sbjctId}"><i class="icon-svg-presentation" aria-hidden="true"></i><span>세미나</span></a>		                                                    
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
                        
					</div>
					<!-- //segment-->

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