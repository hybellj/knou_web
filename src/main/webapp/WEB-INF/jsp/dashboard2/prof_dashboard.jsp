<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fnc" uri="http://localhost/common" %><!-- TODO: 차후 삭제 예정-->
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="dashboard"/>
	</jsp:include>
</head>

<body class="home colorA "><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/home_header.jsp"/>
        <!-- //common header -->

        <!-- dashboard -->
        <main class="common">

            <!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_gnb_prof.jsp"/>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
            
            	<!-- dashboard -->
                <div class="dashboard">

					<!-- grid inline -->
                    <div class="grid inline">
                    
                        <!-- Today box -->
                        <div class="box">
                            <div class="box_title">
                                <i class="xi-arrows m_handle" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
                                <h3 class="h3">TODAY</h3>
                            </div>
                            <div class="box_content">
                                <div class="today_line">
                                    <div class="item today">
                                        <div class="item_tit">Today</div>
                                        <div class="item_info">2025.05.20</div>
                                    </div>
                                    <div class="item user">
                                        <div class="item_tit">
                                            <a href="#0" class="btn ">접속
                                                <i class="xi-angle-down-min"></i>
                                            </a>
                                            <!-- 접속 현황 레이어 -->
                                            <div class="user-option-wrap">
                                                <div class="option_head">
                                                    <div class="sort_btn">
                                                        <button type="button" aria-label="이름 오름차순 정렬">이름<i class="sort xi-long-arrow-up" aria-hidden="true"></i></button>
                                                        <button type="button" aria-label="이름 내림차순 정렬">이름<i class="sort xi-long-arrow-down" aria-hidden="true"></i></button>
                                                    </div>
                                                    <p class="user_num">접속: 37</p>
                                                    <button type="button" class="btn-close" aria-label="접속현황 닫기">
                                                        <i class="icon-svg-close"></i>
                                                    </button>
                                                </div>
                                                <ul class="user_area">
                                                    <li>
                                                        <div class="user-info">
                                                            <div class="user-photo">
                                                                <img src="<%=request.getContextPath()%>/webdoc/assets/img/common/photo_user_sample2.jpg" aria-hidden="true" alt="사진">
                                                            </div>
                                                            <div class="user-desc">
                                                                <p class="name">나방송</p>
                                                                <p class="subject"><span class="major">[대학원]</span>정보와기술</p>
                                                            </div>
                                                            <div class="btn_wrap">
                                                                <button type="button" aria-label="학습현황보기"><i class="xi-info-o"></i></button>
                                                                <button type="button" aria-label="알림바로보내기"><i class="xi-bell-o"></i></button>
                                                            </div>
                                                        </div>
                                                    </li>
                                                    <li>
                                                        <div class="user-info">
                                                            <div class="user-photo">
                                                                <img src="<%=request.getContextPath()%>/webdoc/assets/img/common/photo_user_sample3.jpg" aria-hidden="true" alt="사진">
                                                            </div>
                                                            <div class="user-desc">
                                                                <p class="name">최남단</p>
                                                                <p class="subject"><span class="major">[대학원]</span>데이터베이스의 이해와 활용</p>
                                                            </div>
                                                            <div class="btn_wrap">
                                                                <button type="button" aria-label="학습현황보기"><i class="xi-info-o"></i></button>
                                                                <button type="button" aria-label="알림바로보내기"><i class="xi-bell-o"></i></button>
                                                            </div>
                                                        </div>
                                                    </li>
                                                    <li>
                                                        <div class="user-info">
                                                            <div class="user-photo">
                                                                <img src="<%=request.getContextPath()%>/webdoc/assets/img/common/photo_user_sample2.jpg" aria-hidden="true" alt="사진">
                                                            </div>
                                                            <div class="user-desc">
                                                                <p class="name">나방송</p>
                                                                <p class="subject"><span class="major">[대학원]</span>정보와기술</p>
                                                            </div>
                                                            <div class="btn_wrap">
                                                                <button type="button" aria-label="학습현황보기"><i class="xi-info-o"></i></button>
                                                                <button type="button" aria-label="알림바로보내기"><i class="xi-bell-o"></i></button>
                                                            </div>
                                                        </div>
                                                    </li>
                                                    <li>
                                                        <div class="user-info">
                                                            <div class="user-photo">
                                                                <img src="<%=request.getContextPath()%>/webdoc/assets/img/common/photo_user_sample2.jpg" aria-hidden="true" alt="사진">
                                                            </div>
                                                            <div class="user-desc">
                                                                <p class="name">최남단</p>
                                                                <p class="subject"><span class="major">[대학원]</span>데이터베이스의 이해와 활용</p>
                                                            </div>
                                                            <div class="btn_wrap">
                                                                <button type="button" aria-label="학습현황보기"><i class="xi-info-o"></i></button>
                                                                <button type="button" aria-label="알림바로보내기"><i class="xi-bell-o"></i></button>
                                                            </div>
                                                        </div>
                                                    </li>
                                                    <li>
                                                        <div class="user-info">
                                                            <div class="user-photo">
                                                                <img src="<%=request.getContextPath()%>/webdoc/assets/img/common/photo_user_sample3.jpg" aria-hidden="true" alt="사진">
                                                            </div>
                                                            <div class="user-desc">
                                                                <p class="name">최남단</p>
                                                                <p class="subject"><span class="major">[대학원]</span>데이터베이스의 이해와 활용</p>
                                                            </div>
                                                            <div class="btn_wrap">
                                                                <button type="button" aria-label="학습현황보기"><i class="xi-info-o"></i></button>
                                                                <button type="button" aria-label="알림바로보내기"><i class="xi-bell-o"></i></button>
                                                            </div>
                                                        </div>
                                                    </li>
                                                </ul>

                                            </div>
                                        </div>

                                        <div class="item_info">
                                            <span class="big">37</span>
                                            <span class="small">250</span>
                                        </div>

                                    </div>
                                </div>
                                <div class="today_subject">
                                    <div class="slider_list">
                                        <li>
                                            <div class="item_tit">데이터베이스의 이해와 활용 1반</div>
                                            <div class="item_info">
                                                <span class="big">37</span>
                                                <span class="small">250</span>
                                                <span class="txt">미달</span>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="item_tit">경영수리와 통계1반 </div>
                                            <div class="item_info">
                                                <span class="big">22</span>
                                                <span class="small">200</span>
                                                <span class="txt">미달</span>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="item_tit">데이터베이스의 이해와 활용 활용 활용 1반</div>
                                            <div class="item_info">
                                                <span class="big">37</span>
                                                <span class="small">250</span>
                                                <span class="txt">미달</span>
                                            </div>
                                        </li>
                                    </div>
                                    <!-- <script>
                                        $('.slider_list').slick({
                                            infinite: false,
                                            arrows: true,
                                            dots: false,
                                            autoplay: true,
                                            vertical: true,
                                            autoplaySpeed: 5000,
                                            slidesToShow: 1,
                                            slidesToScroll: 1,
                                        });
                                    </script>-->

                                </div>

                            </div>
                        </div>
						<!--//Today box -->

                        <!-- 강의Q&A -->
                        <div class="box">                            <div class="box_title">
                                <i class="xi-arrows m_handle" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
                                <h3 class="h3">강의 Q&A 
                                	<c:choose>
                                		<c:when test="${dashVM.badge.qnaNoreplyCnt eq '0'}">                                			
                                		</c:when>
                                		<c:otherwise>
                                			<small class="msg_num">${dashVM.badge.qnaNoreplyCnt}</small>
                                		</c:otherwise>
                                	</c:choose>
                                </h3>
                                <div class="btn-wrap">
                                    <a href="/bbs/bbsHome/bbsAtclList.do?bbsTycd=QNA" class="btn_more" aria-label="더보기"><i class="xi-plus"></i></a>
                                </div>
                            </div>
                            <div class="box_content">
                            	<ul class="dash_item_listA">
	                            	<c:choose>
									    <c:when test="${empty dashVM.profDashLctrQnaList}">
									        <li>강의Q&A가 없습니다</li>
									    </c:when>
	                                	<c:otherwise>
		                                	<c:forEach var="item" items="${dashVM.profDashLctrQnaList}">
		                                	<c:set var="cnt" value="0"/>
												<c:if test="${item.topic eq 'PROF_DASH_LCTR_QNA' and cnt lt 3}">  
				                                    <li>
				                                        <div class="user">
				                                           <span class="${item.userThumbnail}"></span>
				                                        </div>
				                                        <a href="/bbs/bbsHome/bbsAtclListView.do?bbsId=${item.bbsId}" class="item_txt">
				                                            <p class="tit">${item.atclTtl}</p>
				                                            <p class="desc">
				                                                <span class="name">[${item.orgnm}] ${item.sbjctnm}</span>
				                                                <span class="date">${fnc:dateFormat(item.regDttm, '.')}</span>
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

                        <!-- 1:1 상담 -->
                        <div class="box">
                            <div class="box_title">
                                <i class="xi-arrows m_handle" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
                                <h3 class="h3">1:1 상담 
                                	<c:choose>
                                		<c:when test="${dashVM.badge.oneOnOneNoreplyCnt eq '0'}">                                			
                                		</c:when>
                                		<c:otherwise>
                                			<small class="msg_num">${dashVM.badge.oneOnOneNoreplyCnt}</small>
                                		</c:otherwise>
                                	</c:choose>
                               	</h3>
                                <div class="btn-wrap">
                                    <a href="/bbs/bbsHome/bbsAtclList.do?bbsTycd=1ON1" class="btn_more" aria-label="더보기"><i class="xi-plus"></i></a>
                                </div>
                            </div>
                           
                            <div class="box_content">
                            	<ul class="dash_item_listA">
		                            <c:choose>
									    <c:when test="${empty dashVM.profDashOneOnOneList}">
									        <li>1:1 상담이 없습니다</li>
									    </c:when>
									    <c:otherwise>		                                  
		                                	<c:forEach var="item" items="${dashVM.profDashOneOnOneList}"> 
		                                		<c:set var="cnt" value="0"/>
												<c:if test="${item.topic eq 'PROF_DASH_1ON1' and cnt lt 3}">                                
				                                    <li>
				                                        <div class="user">
				                                           <span class="${item.userThumbnail}"><img src="<%=request.getContextPath()%>/webdoc/assets/img/common/photo_user_sample3.jpg" aria-hidden="true" alt="사진"></span>
				                                        </div>
				                                        <a href="/bbs/bbsHome/bbsAtclListView.do?bbsId=${item.bbsId}" class="item_txt">
				                                            <p class="tit">${item.atclTtl}​</p>
				                                            <p class="desc">
				                                                <span class="name">[${item.orgnm}] ${item.sbjctnm}</span>
				                                                <span class="date">${fnc:dateFormat(item.regDttm, '.')}</span>
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
                        <!-- //1:1 상담 -->
                        
                    </div>                    
                    <!-- //grid inline -->


					<!-- grid divided 위젯 영역 1, 2 분할: group -->
                    <div class="grid divided">
                    
                    	<!-- col-vertical -->
                        <div class="col-vertical">
                            
                            <!-- 알림 -->
                            <div class="box alrim">
                                <div class="box_title">
                                    <i class="xi-arrows m_handle" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
                                    <h3 class="h3">알림</h3>
                                    <!--tab-type1-->
                                    <nav class="tab-type1">
                                        <a href="#tab11" class="btn current"><span>PUSH</span><small class="msg_num">9</small></a>
                                        <a href="#tab12" class="btn "><span>SMS</span><small class="msg_num">3</small></a>
                                        <a href="#tab13" class="btn "><span>쪽지</span><small class="msg_num">2</small></a>
                                        <a href="#tab14" class="btn "><span>알림톡</span><small class="msg_num">1</small></a>
                                    </nav>

                                    <div class="btn-wrap">
                                        <a href="#0" class="btn_more" aria-label="더보기"><i class="xi-plus"></i></a>
                                    </div>
                                </div>
                                <div class="box_content">
                                    <div id="tab11" class="tab-content" style="display: block;"> <!--탭메뉴 클릭 시 style="display: block;" 또는 style="display: none;"-->
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
                                                <a href="/subject2MainView.do?subjectId=SBJCT20260001" class="item_txt">
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

                                        </div>
                                    </div>

                                    <div id="tab12" class="tab-content" style="display: none;">
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

                                    <div id="tab13" class="tab-content" style="display: none;">
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

                                    <div id="tab14" class="tab-content" style="display: none;">
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
							<!-- //알림 -->

                            <!-- 공지사항 -->
                            <div class="box notice">                            
                                <div class="box_title">
                                    <i class="xi-arrows m_handle" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
                                    <h3 class="h3">공지사항</h3>
                                    <!--tab-type1-->
                                    <nav class="tab-type1">
                                        <a href="#tab21" class="btn current"><span style="color:#fff;">최신</span></a>
                                        <a href="#tab22" class="btn"><span>전체공지</span></a>
                                        <a href="#tab23" class="btn"><span>과목공지</span></a>
                                    </nav>
                                    <div class="btn-wrap">
                                        <a href="/bbs/bbsHome/bbsAtclList.do?bbsTycd=NTC" class="btn_more" aria-label="더보기"><i class="xi-plus"></i></a>
                                    </div>
                                </div>
                                
                                <!-- box_content -->
                                <div class="box_content">
                                                                
                                	<!-- tab21 모든공지목록-->
                                    <div id="tab21" class="tab-content" style="display: block;">
                                        <ul class="dash_item_listA">
				                            <c:choose>
											    <c:when test="${empty dashVM.profDashAllNoticeList}">
											        <li>최신공지사항이 없습니다</li>
											    </c:when>
											    <c:otherwise>								        
				                                	<c:forEach var="item" items="${dashVM.profDashAllNoticeList}">
													    <!-- 3건만 출력 -->
													    <c:set var="cnt" value="0"/>
													    <c:if test="${item.topic eq 'PROF_DASH_ALL_NOTICE' and cnt lt 3}">
													        <li>
													            <!-- 공지 유형 라벨 -->
													            <div class="noti_label">
														            <c:choose>
														            	<c:when test="${item.badge eq 'ALL'}">
															                <label class="labelA">전체</label>
															            </c:when>
															            <c:otherwise>
															            	<label class="labelB">과목</label>
															            </c:otherwise>
															    	</c:choose>
													            </div>
													
													            <!-- 공지 링크 및 내용 -->
													            <a href="/bbs/bbsHome/bbsAtclListView.do?bbsId=${item.bbsId}&${item.atclId}" class="item_txt">
													                <p class="tit">${item.atclTtl}</p>
													                <p class="desc">
													                    <c:choose>
													                        <c:when test="${item.badge eq 'ALL'}">
														                            <span class="date">${fnc:dateFormat(item.regDttm, '.')}</span>
													                        </c:when>
													                        <c:otherwise>
													                            <span class="name">[${item.orgnm}] ${item.sbjctnm}</span>
													                            <span class="date">${fnc:dateFormat(item.regDttm, '.')}</span>
													                        </c:otherwise>
													                    </c:choose>
													                </p>
													            </a>
													            													
													            <!-- 읽음/읽지않음 표시 -->
													            <div class="state">
													            	<c:choose>
														            	<c:when test="${item.readYn eq 'N'}">
														                	<label class="label check_no">읽지않음</label>
														                </c:when>
															            <c:otherwise>
															            	<label class="label check_no">읽음</label>
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
                                    <!-- //tab21 -->                                    
                                    
                                    <!-- tab22 전체-->
                                    <div id="tab22" class="tab-content" style="display: none;">
                                        <ul class="dash_item_listA">
				                            <c:choose>
											    <c:when test="${empty dashVM.dashCrsNoticeList}">
											        <li>전체공지사항이 없습니다</li>
											    </c:when>
											    <c:otherwise>							        
				                                	<!-- 3건만 출력 -->
													<c:set var="cnt" value="0"/>
													<c:forEach var="item" items="${dashVM.dashCrsNoticeList}">
													    <!-- 전체공지만출력 -->
													    <c:if test="${item.topic eq 'CRS_NOTICE' and cnt lt 3}">
													        <li>
													            <!-- 공지 유형 라벨 -->
													            <div class="noti_label">
													                <label class="labelA">전체</label>
													            </div>
													
													            <!-- 공지 링크 및 내용 -->
													            <a href="/bbs/bbsHome/bbsAtclListView.do?bbsId=${item.bbsId}&${item.atclId}" class="item_txt">
													                <p class="tit">${item.atclTtl}</p>
													                <p class="desc">
													                    <span class="date">${fnc:dateFormat(item.regDttm, '.')}</span>
													                </p>
													            </a>
													
													            <!-- 읽음/읽지않음 표시 -->
													           	<div class="state">
														           		<c:choose>
														            	<c:when test="${item.readYn eq 'N'}">
														                	<label class="label check_no">읽지않음</label>
														                </c:when>
															            <c:otherwise>
															            	<label class="label check_no">읽음</label>
															            </c:otherwise>
															    	</c:choose>
															    </div>													    	
													        </li>													
													        <!-- 카운터 증가 -->
													        <c:set var="cnt" value="${cnt + 1}" />
													    </c:if>
													</c:forEach>	                                	
											    </c:otherwise>
											</c:choose>
										</ul>                                        
                                    </div>
                                    <!-- //tab22 -->                                    
                                    
                                    <!-- tab23 과목-->
                                    <div id="tab23" class="tab-content" style="display: none;">
                                        <ul class="dash_item_listA">
				                            <c:choose>
											    <c:when test="${empty dashVM.profDashSubjectNoticeList}">
											        <li>과목공지사항이 없습니다</li>
											    </c:when>
											    <c:otherwise>								        
	                                				<c:set var="cnt" value="0" />
													<c:forEach var="item" items="${dashVM.profDashSubjectNoticeList}">
													    <!-- 과목공지만 출력 -->
													    <c:if test="${item.topic eq 'PROF_DASH_SUBJECT_NOTICE' and cnt lt 3}">
													        <li>
													            <!-- 공지 유형 라벨 -->
													            <div class="noti_label">
													                <label class="labelB">과목</label>
													            </div>
													
													            <!-- 공지 링크/내용 -->
													            <a href="/bbs/bbsHome/bbsAtclListView.do?bbsId=${item.bbsId}" class="item_txt">
													                <p class="tit">${item.atclTtl}</p>
													                <p class="desc">
													                    <span class="name">[${item.orgnm}] ${item.sbjctnm}</span>
													                    <span class="date">${fnc:dateFormat(item.regDttm, '.')}</span>
													                </p>
													            </a>
													
													            <!-- 읽음/읽지않음 -->
													            <div class="state">
														            <c:choose>
														            	<c:when test="${item.readYn eq 'N'}">
														                	<label class="label check_no">읽지않음</label>
														                </c:when>
															            <c:otherwise>
															            	<label class="label check_no">읽음</label>
															            </c:otherwise>
															    	</c:choose>
															    </div>
													        </li>
													
													        <!-- 카운터 증가 -->
													        <c:set var="cnt" value="${cnt + 1}" />
													    </c:if>
													</c:forEach>                                	
											    </c:otherwise>
											</c:choose>
										</ul>                                        
                                    </div>
                                    <!-- //tab23 -->
                                    
                                </div>
                                <!-- //box_content -->
                                
                            </div>
                            <!-- //공지사항 -->


                            <!-- 학사일정 -->
                            <div class="box">
                                <div class="box_title padding-right-0">
                                    <i class="xi-arrows m_handle" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
                                    <h3 class="h3"><em>이달의</em> 학사일정</h3>
                                    <div class="btn-wrap">
                                        <div class="schedule-head">
                                            <a class="btn-prev" href="#" aria-label="이전달"><i class="xi-angle-left-min"></i></a>
                                            <div class="this-month">4<small>월</small></div>
                                            <a class="btn-next" href="#" aria-label="다음달"><i class="xi-angle-right-min"></i></a>
                                        </div>
                                    </div>
                                </div>
                                <div class="box_content">
                                    <ul class="sche_list">
                                        <li>
                                            <div class="item_box">
                                                <div class="s_date">03.18 ~ 04.01</div>
                                                <div class="s_txt">
                                                    <p class="tit">중간고사 시험문제 등록/출제/검수</p>
                                                    <p class="desc">[대학원] 데이터베이스의 이해와 활용</p>
                                                </div>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="item_box">
                                                <div class="s_date">04.05 ~ 06.12</div>
                                                <div class="s_txt">
                                                    <p class="tit">결시원 승인</p>
                                                    <p class="desc">[대학원] 경영수리와 통계1반</p>
                                                </div>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="item_box">
                                                <div class="s_date">04.08 ~ 04.11</div>
                                                <div class="s_txt">
                                                    <p class="tit">2025학년도 1학기 중간고사</p>
                                                    <p class="desc">[대학원] 경영수리와 통계1반</p>
                                                </div>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="item_box">
                                                <div class="s_date">04.18 ~ 04.22</div>
                                                <div class="s_txt">
                                                    <p class="tit">시험문제 등록/출제/검수</p>
                                                    <p class="desc">[대학원] 데이터베이스의 이해와 활용</p>
                                                </div>
                                            </div>
                                        </li>

                                    </ul>
                                </div>
                            </div>
                            <!-- //학사일정 -->
                            
                        </div>
						<!-- //col-vertical -->						

                        <!-- 강의과목 -->
                        <div class="box span-2 subject">
                            <div class="box_title">
                                <i class="xi-arrows m_handle" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
                                <h3 class="h3">강의과목</h3>
                                <!--tab-type1-->
                                <nav class="tab-type1">
                                    <a href="#tab31" class="btn current"><span>전체</span></a>
                                    <a href="#tab32" class="btn "><span>대학원</span></a>
                                    <a href="#tab33" class="btn "><span>학위과정</span></a>
                                    <a href="#tab34" class="btn "><span>평생교육</span></a>
                                </nav>

                                <div class="btn-wrap">
                                    <select class="form-select">
                                        <option value="2025년 2학기">2025년 2학기</option>
                                        <option value="2025년 1학기">2025년 1학기</option>
                                    </select>
                                    <a href="#0" class="btn_list_type" aria-label="리스트형 보기"><i class="icon-svg-list" aria-hidden="true"></i></a>
                                    <a href="#0" class="btn_list_type on" aria-label="카드형 보기"><i class="icon-svg-grid" aria-hidden="true"></i></a><!-- 버튼 선택 on 클래스 추가 -->
                                </div>
                            </div>

                            <div class="box_content">
                                <div id="tab31" class="tab-content" style="display: block;">
                                    <!-- 강의목록 -->
                                    <ul class="lecture_list">
                                        <li>
                                            <div class="card_item">
                                                <div class="item_header">
                                                    <div class="title_area">
                                                        <p class="info_detail">
                                                            <span class="label uniA">대학원</span>
                                                            <span class="info_txt">수강 50명</span>
                                                            <span class="info_txt">튜터 김하늘</span>
                                                            <span class="info_txt">3학점</span>
                                                        </p>
                                                        <p class="tit"><a href="/subject2MainView.do?subjectId=SBJCT20260001">데이터베이스의 이해와 활용</a></p>
                                                    </div>
                                                </div>
                                                <div class="extra">
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
                                                            <span>2025.06.07 17:00</span>
                                                        </p>
                                                        <p class="desc">
                                                            <span class="tit">시간:</span>
                                                            <span>40분</span>
                                                        </p>
                                                    </div>
                                                    <div class="my_prog_rate">
                                                        <div class="progress">
                                                            <div class="bar blue_type" style="width: 40%;"></div>
                                                        </div>
                                                        <span class="prog_num">평균 진도율</span><span class="meta">40%</span>
                                                    </div>
                                                </div>
                                                <div class="bottom_button">
                                                   <div class="card_btns">
                                                        <a href="#0">공지<span>2</span></a>
                                                        <a href="#0">Q&A<span>2</span></a>
                                                        <a href="#0">1 : 1<span>2</span></a>
                                                        <a href="#0">과제<span>2</span></a>
                                                        <a href="#0">토론<span>2</span></a>
                                                        <a href="#0">세미나<span>2</span></a>
                                                        <a href="#0">퀴즈<span>2</span></a>
                                                        <a href="#0">설문<span>2</span></a>
                                                        <a href="#0">시험<span>2</span></a>
                                                    </div>
                                                </div>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="card_item">
                                                <div class="item_header">
                                                    <div class="title_area">
                                                        <p class="info_detail">
                                                            <span class="label uniA">대학원</span>
                                                            <span class="info_txt">수강 50명</span>
                                                            <span class="info_txt">튜터 김하늘</span>
                                                            <span class="info_txt">3학점</span>
                                                        </p>
                                                        <p class="tit"><a href="/subject2MainView.do?subjectId=SBJCT20260001">데이터베이스의 이해와 활용</a></p>
                                                    </div>
                                                </div>
                                                <div class="extra">
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
                                                            <span>2025.06.07 17:00</span>
                                                        </p>
                                                        <p class="desc">
                                                            <span class="tit">시간:</span>
                                                            <span>40분</span>
                                                        </p>
                                                    </div>
                                                    <div class="my_prog_rate">
                                                        <div class="progress">
                                                            <div class="bar blue_type" style="width: 40%;"></div>
                                                        </div>
                                                        <span class="prog_num">평균 진도율</span><span class="meta">40%</span>
                                                    </div>
                                                </div>
                                                <div class="bottom_button">
                                                   <div class="card_btns">
                                                        <a href="#0">공지<span>2</span></a>
                                                        <a href="#0">Q&A<span>2</span></a>
                                                        <a href="#0">1 : 1<span>2</span></a>
                                                        <a href="#0">과제<span>2</span></a>
                                                        <a href="#0">토론<span>2</span></a>
                                                        <a href="#0">세미나<span>2</span></a>
                                                        <a href="#0">퀴즈<span>2</span></a>
                                                        <a href="#0">설문<span>2</span></a>
                                                        <a href="#0">시험<span>2</span></a>
                                                    </div>
                                                </div>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="card_item">
                                                <div class="item_header">
                                                    <div class="title_area">
                                                        <p class="info_detail">
                                                            <span class="label uniB">평생교육</span>
                                                            <span class="info_txt">수강 200명</span>
                                                            <span class="info_txt">튜터 한여름</span>
                                                            <span class="info_txt">3학점</span>
                                                        </p>
                                                        <p class="tit"><a href="/subject2MainView.do?subjectId=SBJCT20260001">간결하고 힘찬 영어 쓰기 - 품격 있는 영작</a></p>
                                                    </div>
                                                </div>
                                                <div class="extra">
                                                    <div class="info">
                                                        <p class="point">
                                                            <span class="tit">과제제출:</span>
                                                            <span>2025.04.26 16:00</span>
                                                        </p>

                                                    </div>
                                                    <div class="info">
                                                        <p class="point">
                                                            <span class="tit">기말고사:</span>
                                                            <span>2025.06.07 17:00</span>
                                                        </p>
                                                        <p class="desc">
                                                            <span class="tit">시간:</span>
                                                            <span>40분</span>
                                                        </p>
                                                    </div>
                                                    <div class="my_prog_rate">
                                                        <div class="progress">
                                                            <div class="bar blue_type" style="width: 40%;"></div>
                                                        </div>
                                                        <span class="prog_num">평균 진도율</span><span class="meta">40%</span>
                                                    </div>
                                                </div>
                                                <div class="bottom_button">
                                                   <div class="card_btns">
                                                        <a href="#0">공지<span>2</span></a>
                                                        <a href="#0">Q&A<span>2</span></a>
                                                        <a href="#0">1 : 1<span>2</span></a>
                                                        <a href="#0">과제<span>2</span></a>
                                                        <a href="#0">설문<span>2</span></a>
                                                        <a href="#0">시험<span>2</span></a>
                                                    </div>
                                                </div>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="card_item">
                                                <div class="item_header">
                                                    <div class="title_area">
                                                        <p class="info_detail">
                                                            <span class="label uniB">평생교육</span>
                                                            <span class="info_txt">수강 200명</span>
                                                            <span class="info_txt">온라인</span>
                                                            <span class="info_txt">3학점</span>
                                                        </p>
                                                        <p class="tit"><a href="/subject2MainView.do?subjectId=SBJCT20260001">New TEPS 실전 연습-기본편</a></p>
                                                    </div>
                                                </div>
                                                <div class="extra">
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
                                                            <span>2025.06.07 17:00</span>
                                                        </p>
                                                        <p class="desc">
                                                            <span class="tit">시간:</span>
                                                            <span>40분</span>
                                                        </p>
                                                    </div>
                                                    <div class="my_prog_rate">
                                                        <div class="progress">
                                                            <div class="bar blue_type" style="width: 40%;"></div>
                                                        </div>
                                                        <span class="prog_num">평균 진도율</span><span class="meta">40%</span>
                                                    </div>
                                                </div>
                                                <div class="bottom_button">
                                                   <div class="card_btns">
                                                        <a href="#0">공지<span>2</span></a>
                                                        <a href="#0">Q&A<span>2</span></a>
                                                        <a href="#0">1 : 1<span>2</span></a>
                                                        <a href="#0">설문<span>2</span></a>
                                                        <a href="#0">시험<span>2</span></a>
                                                    </div>
                                                </div>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="card_item">
                                                <div class="item_header">
                                                    <div class="title_area">
                                                        <p class="info_detail">
                                                            <span class="label uniC">학위과정</span>
                                                            <span class="info_txt">수강 50명</span>
                                                            <span class="info_txt">튜터 김하늘</span>
                                                            <span class="info_txt">3학점</span>
                                                        </p>
                                                        <p class="tit"><a href="/subject2MainView.do?subjectId=SBJCT20260001">AI와 빅데이터 경영입문 2반</a></p>
                                                    </div>
                                                </div>
                                                <div class="extra">
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
                                                            <span>2025.06.07 17:00</span>
                                                        </p>
                                                        <p class="desc">
                                                            <span class="tit">시간:</span>
                                                            <span>40분</span>
                                                        </p>
                                                    </div>
                                                    <div class="my_prog_rate">
                                                        <div class="progress">
                                                            <div class="bar blue_type" style="width: 40%;"></div>
                                                        </div>
                                                        <span class="prog_num">평균 진도율</span><span class="meta">40%</span>
                                                    </div>
                                                </div>
                                                <div class="bottom_button">
                                                   <div class="card_btns">
                                                        <a href="#0">공지<span>2</span></a>
                                                        <a href="#0">Q&A<span>2</span></a>
                                                        <a href="#0">1 : 1<span>2</span></a>
                                                        <a href="#0">과제<span>2</span></a>
                                                        <a href="#0">토론<span>2</span></a>
                                                        <a href="#0">세미나<span>2</span></a>
                                                        <a href="#0">퀴즈<span>2</span></a>
                                                        <a href="#0">설문<span>2</span></a>
                                                        <a href="#0">시험<span>2</span></a>
                                                    </div>
                                                </div>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="card_item">
                                                <div class="item_header">
                                                    <div class="title_area">
                                                        <p class="info_detail">
                                                            <span class="label uniC">학위과정</span>
                                                            <span class="info_txt">수강 50명</span>
                                                            <span class="info_txt">튜터 김하늘</span>
                                                            <span class="info_txt">3학점</span>
                                                        </p>
                                                        <p class="tit"><a href="/subject2MainView.do?subjectId=SBJCT20260001">AI와 빅데이터 경영입문 2반</a></p>
                                                    </div>
                                                </div>
                                                <div class="extra">
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
                                                            <span>2025.06.07 17:00</span>
                                                        </p>
                                                        <p class="desc">
                                                            <span class="tit">시간:</span>
                                                            <span>40분</span>
                                                        </p>
                                                    </div>
                                                    <div class="my_prog_rate">
                                                        <div class="progress">
                                                            <div class="bar blue_type" style="width: 40%;"></div>
                                                        </div>
                                                        <span class="prog_num">평균 진도율</span><span class="meta">40%</span>
                                                    </div>
                                                </div>
                                                <div class="bottom_button">
                                                   <div class="card_btns">
                                                        <a href="#0">공지<span>2</span></a>
                                                        <a href="#0">Q&A<span>2</span></a>
                                                        <a href="#0">1 : 1<span>2</span></a>
                                                        <a href="#0">과제<span>2</span></a>
                                                        <a href="#0">토론<span>2</span></a>
                                                    </div>
                                                </div>
                                            </div>
                                        </li>
                                    </ul>
                                </div>

                                <div id="tab32" class="tab-content" style="display: none;">
                                    <div class="no_content">
                                        <div class="no_text">
                                            <i class="icon-cont-none ico f170"></i>
                                            <span>등록된 강의가 없습니다.</span>
                                        </div>
                                    </div>

                                </div>

                                <div id="tab33" class="tab-content" style="display: none;">
                                    학위과정 강의리스트
                                </div>

                                <div id="tab34" class="tab-content" style="display: none;">
                                    평생교육 강의리스트
                                </div>
                            </div>

                        </div>
                        <!-- //강의과목 -->                        
                        
                    </div>                    
                    <!-- //grid divided 위젯 영역 1, 2 분할: group -->                    

                </div>
                <!-- //dashboard -->
                
            </div>
            <!-- //content -->

            <!-- common footer -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_footer.jsp"/>
            <!-- //common footer -->

        </main>
        <!-- //dashboard-->

    </div>
    <!-- //main -->
</body>
</html>