<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

					<!-- segment row -->
					<div class="segment-row">
						<!-- 과목공지사항 -->
						<div class="segment">
                            <div class="box_title">
                                <i class="icon-svg-notice"></i>
                                <h3 class="h3">과목 공지사항
                                <c:if test="${subjectVM.badge.noticeUnreadCnt gt 0}">
                                	<small class="msg_num">${subjectVM.badge.noticeUnreadCnt}</small></h3><!-- 과목 공지사항-->
                                </c:if>                                
                                <div class="btn-wrap">
                                    <a href="javascript:void(0);" 
	                                    onclick='moveMenu(this, "/bbs/bbsLect/bbsAtclListView.do?bbsTycd=NTC", "ROOT", "PROLECT000002", "공지사항", "self", { sbjctId : "${subjectVM.subjectVO.sbjctId}", bbsTycd : "NTC"} );return false;' title="공지사항" class="btn_more"><i class="xi-plus"></i></a>
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
				                                    	<a class="item_txt" href="javascript:void(0)" onclick="viewAtclLect('${item.atclId}', '${item.rgtrId}', '${item.oyn}', '${item.bbsId}', '${item.bbsTycd}', 'ROOT','PROLECT000002')" style="color: currentColor;">
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
                                <c:if test="${subjectVM.badge.qnaNoreplyCnt gt 0 }">
                                	<small class="msg_num">${subjectVM.badge.qnaNoreplyCnt}</small>
                                </c:if>
                                </h3>
                                <div class="btn-wrap">
                                    <a href="javascript:void(0);" 
	                                    onclick='moveMenu(this, "/bbs/bbsLect/bbsAtclListView.do?bbsTycd=QNA", "ROOT", "PROLECT000004", "강의 Q&A", "self", { sbjctId : "${subjectVM.subjectVO.sbjctId}"});return false;' class="btn_more"><i class="xi-plus"></i></a>
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
				                                        <a class="item_txt" href="javascript:void(0)" onclick="viewAtclLect('${item.atclId}', '${item.rgtrId}', '${item.oyn}', '${item.bbsId}', '${item.bbsTycd}', 'ROOT','PROLECT000004')" style="color: currentColor;">
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
                                	<c:if test="${ subjectVM.badge.oneOnOneNoreplyCnt gt 0 }">
                                		<small class="msg_num">${ subjectVM.badge.oneOnOneNoreplyCnt}</small>
                                	</c:if>
                                </h3>
                                <div class="btn-wrap">
                                    <a href="javascript:void(0);" 
	                                    onclick='moveMenu(this, "/bbs/bbsLect/bbsAtclListView.do?bbsTycd=1ON1", "ROOT", "PROLECT000005", "1:1 상담", "self", { sbjctId : "${subjectVM.subjectVO.sbjctId}"});return false;' class="btn_more"><i class="xi-plus"></i></a>
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
				                                        <a class="item_txt" href="javascript:void(0)" onclick="viewAtclLect('${item.atclId}', '${item.rgtrId}', '${item.oyn}', '${item.bbsId}', '${item.bbsTycd}', 'ROOT','PROLECT000005')" style="color: currentColor;">
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
                            <button type="button" id="btnToggleWeek" class="btn basic" onclick="toggleWeek(this)">주차 접음</button>
                            <select class="form-select" onchange="moveWeek(this.value)">
                            	<option value="전체 주차">전체 주차</option>
                            	<c:forEach var="item" items="${subjectVM.byWeeknoLectureSchdlList}">
                            		<c:if test="${item.srcTbl == 'TB_LMS_LCTR_WKNO_SCHDL' && item.firstOrd == 0 }">                                
		                                <option value="${item.wkno}">${item.wkno}주차</option>
		                            </c:if>
	                            </c:forEach>
                            </select>
                            <div class="right-area">
							    <button type="button"
							            id="btnSortWeek"
							            class="btn basic icon"
							            aria-label="주차 정렬"
							            onclick="toggleSortWeek()">
							        <i class="xi-sort-asc"></i>
							    </button>
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
		                                <li class="active" data-week="${item.wkno}"> <!-- 제어를 쉽게하기 위해 추가 -->
		                                    <div class="title-wrap">
		                                        <a class="title" href="#">
		                                            <i class="arrow xi-angle-down"></i>
		                                            <strong>${item.wkno}주차 ${item.nm}</strong>
		                                        </a>
		                                        <div class="meta-action-bar">
		                                            <p class="desc">
		                                                <label class="label s_online">공개</label>
		                                               	<label class="label s_chasi">순차학습</label>
		                                               	<label class="label s_finish">마감</label>	                                     	       
		                                                <span>학습기간<strong>
		                                                	<span class="date"><uiex:formatDate value="${item.sdttm}" type="date"/>
		                                                	 ~ <uiex:formatDate value="${item.edttm}" type="date"/></span>
		                                                	</strong></span>
		                                                <span>출석<strong>${item.atndCnt}</strong></span>
		                                                <span>지각<strong>${item.rateCnt}</strong></span>
		                                                <span>결석<strong>${item.absntCnt}</strong></span>		                                                
		                                            </p>
		                                            <div class="btn_right">
				                                    	<button class="btn s_basic down">음성</button>
			                                            <button class="btn s_basic down">강의노트</button>
			                                            <button class="btn s_type1" onclick="openAttandanceListPopup('${item.id}');">출결관리</button><!-- 강의를 들어야 출석이 인정 -->
			                                            <button class="btn s_type2" onclick="openLecturePopup('${item.id}', 'wknoId');">강의보기</button><!-- 해당주차의 첫번째 강의보기 -->
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
			                                                    <span>출석율<strong class="navy">${item.wkno < 4 ? "100%" : item.wkno < 6 ? "10%" : "0%"}</strong></span>
			                                                </div>
			                                                <button class="btn s_basic play" onclick="openLecturePopup('${item.id}', 'lctrId');">강의보기</button><!-- 자기강의 출력 -->
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
				                                                <button type="button"	class="btn s_basic set"  onclick='moveMenu(this, "/asmt2/profAsmtListView.do", "ROOT", "PROLECT000008", "과제", "self");return false;' >
    															과제관리
    															</button>
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
				                                                <button type="button"	class="btn s_basic set"  onclick='moveMenu(this, "/forum2/forumLect/profForumListView.do", "ROOT", "PROLECT000011", "토론", "self");return false;' >
    															토론관리
    															</button>
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
				                                                <button type="button"	class="btn s_basic set"  onclick='moveMenu(this, "/srvy/profSrvyListView.do", "ROOT", "PROLECT000010", "설문", "self"); return false;'>
    																설문관리
																</button>
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
				                                                <button type="button"	class="btn s_basic set"  onclick='moveMenu(this, "/smnr/profSmnrListView.do", "ROOT", "PROLECT000012", "세미나", "self"); return false;s'>
    																세미나관리
																</button>
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
		                                                <div class="item_btns" id="lrnDataMenu_${item.lctrWknoSchdlId}"></div>
														<script type="text/javascript">
														(function () {														
														    const sbjctId = "${subjectVM.subjectVO.sbjctId}";
														    const lctrWknoSchdlId ="${item.lctrWknoSchdlId}";
														    const lrnDataItems = [
														        { type : "mov",    		icon : "icon-svg-play-circle", 	label : "동영상" },
														        { type : "pdf",    		icon : "icon-svg-layout-alt",  	label : "PDF" },
														        { type : "file",   		icon : "icon-svg-paperclip",   	label : "파일" },
														        { type : "social", 		icon : "icon-svg-share",       	label : "소셜" },
														        { type : "link",   		icon : "icon-svg-link",        	label : "웹링크" },
														        { type : "text",   		icon : "icon-svg-type-square", 	label : "텍스트" },
														        { type : "exercise",   	icon : "icon-svg-exercise", 	label : "연습문제" }
														    ];														
														    const target = document.getElementById(
														        "lrnDataMenu_${item.lctrWknoSchdlId}"
														    );														
														    if (!target) {
														        return;
														    }														
														    target.innerHTML = lrnDataItems.map(function(item) {														
														        return ''
														            + '<a href="#0" onclick="lrnDataAdd('
														            + '\'' + item.type + '\', '
														            + '\'' + sbjctId + '\', '
														            + '\'' + lctrWknoSchdlId + '\''
														            + ')">'
														            + '<i class="' + item.icon + '" aria-hidden="true"></i>'
														            + '<span>' + item.label + '</span>'
														            + '</a>';														
														    }).join('');														
														})();
														</script>
		                                            </div>
		                                            <div class="box_item">
		                                                <div class="title">학습요소 추가<i class="xi-plus-min"></i></div>
		                                                <div class="item_btns">
		                                                    <a href="javascript:void(0);" onclick='moveMenu(this, "/asmt2/profAsmtListView.do", "ROOT", "PROLECT000008", "과제", "self", { sbjctId : "${subjectVM.subjectVO.sbjctId}"} );return false;' title="과제" class="info">
			                								<i class="icon-svg-edit" aria-hidden="true"></i><span>과제</span></a>
			                								<a href="javascript:void(0);" onclick='moveMenu(this, "/quiz/profQuizListView.do", "ROOT", "PROLECT000009", "퀴즈", "self", { sbjctId : "${subjectVM.subjectVO.sbjctId}"} );return false;' title="퀴즈" class="info">
	                                    					<i class="icon-svg-quiz" aria-hidden="true"></i><span>퀴즈</span></a>
			                								<a href="javascript:void(0);" onclick='moveMenu(this, "/exam/profExamListView.do", "ROOT", "PROLECT000013", "시험", "self", { sbjctId : "${subjectVM.subjectVO.sbjctId}"} );return false;' title="시험" class="info">
	                                   						<i class="icon-svg-alarm-clock" aria-hidden="true"></i><span>시험</span></a>
		                                                    <a href="javascript:void(0);" onclick='moveMenu(this, "/forum2/forumLect/profForumListView.do", "ROOT", "PROLECT000011", "토론", "self", { sbjctId : "${subjectVM.subjectVO.sbjctId}"} );return false;' title="토론" class="info">
			                								<i class="icon-svg-message-chat" aria-hidden="true"></i><span>토론</span></a>		                                                    
		                                                    <a href="javascript:void(0);" onclick='moveMenu(this, "/srvy/profSrvyListView.do", "ROOT", "PROLECT000010", "설문", "self", { sbjctId : "${subjectVM.subjectVO.sbjctId}"} );return false;' title="설문" class="info">
	                                   						<i class="icon-svg-check-done" aria-hidden="true"></i><span>설문</span></a>
		                                                    <a href="javascript:void(0);" onclick='moveMenu(this, "/smnr/profSmnrListView.do", "ROOT", "PROLECT000012", "세미나", "self", { sbjctId : "${subjectVM.subjectVO.sbjctId}"} );return false;' title="세미나" class="info">
	                                    					<i class="icon-svg-presentation" aria-hidden="true"></i><span>세미나</span></a>	                                                    
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
					
					<script>
					    function openLecturePreview(wkno) {
					        // 1단계에서 만든 파일 경로 (같은 폴더에 있다면 파일명만 적으시면 됩니다)
					        const popupUrl = "/lctr/lecturePreview.do?wkno="+wkno; 
					        
					        // 동영상과 하단 문제 영역을 고려해 새 창의 크기를 넉넉하게 설정 (예: 460x550)
					        const popupWidth = 1024;
					        const popupHeight = 768;
					        
					     	// 화면 정중앙 좌표 계산
					        const dualScreenLeft = window.screenLeft !== undefined ? window.screenLeft : window.screenX;
					        const dualScreenTop = window.screenTop !== undefined ? window.screenTop : window.screenY;
					        const width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
					        const height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

					        const leftPosition = ((width / 2) - (popupWidth / 2)) + dualScreenLeft;
					        const topPosition = ((height / 2) - (popupHeight / 2)) + dualScreenTop;
					        
					        // 💡 백틱(`) 대신 일반 따옴표와 + 기호로 안전하게 연결했습니다.
					        const popupOptions = "width=" + popupWidth + 
					                             ",height=" + popupHeight + 
					                             ",left=" + leftPosition + 
					                             ",top=" + topPosition + 
					                             ",resizable=yes,scrollbars=yes,status=no,toolbar=no,menubar=no";
					        
					        // 새 창 열기
					        const eduWindow = window.open(popupUrl, 'EduPlayerWindow', popupOptions);
					        
					        if (window.focus && eduWindow) {
					            eduWindow.focus();
					        }
					    }
					</script>