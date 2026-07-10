<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
					<!-- noticeListBox -->
                            <div id="noticeListBox">
                                <!-- noticeCat1 모든공지목록-->
                               	<div id="noticeCat1" class="tab-content" style="display: block;">
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
												            	<c:choose>
												            		<c:when test="${item.badge eq 'ALL'}">												            
														                <a href="javascript:void(0);" 
							                                    		onclick='moveMenu(this, "/bbs/bbsHome/bbsAtclListView.do?bbsTycd=NTC&bbsRefTycd=ORG", "PROMAIN000014", "PROMAIN000016", "전체공지", "tab"); return false;'
							                                    		 class="item_txt">
														            </c:when>
														            <c:otherwise>
														            	<a class="item_txt" href="javascript:void(0)" onclick="viewAtclLect('${item.atclId}', '${item.rgtrId}', '${item.oyn}', '${item.bbsId}', '${item.bbsTycd}', 'ROOT','PROLECT000002', '${item.sbjctId}')" style="color: currentColor;">
														            </c:otherwise>
														   		</c:choose>												            
														                <p class="tit">${item.atclTtl}</p>
														                <p class="desc">
														                    <c:choose>
														                        <c:when test="${item.badge eq 'ALL'}">
															                            <span class="date" style="display:inline-block; width:90px;"><uiex:formatDate value="${item.regDttm}" type="date"/></span>
														                        </c:when>
														                        <c:otherwise>
														                            <span class="name">[${item.orgnm}] ${item.sbjctnm}</span>
														                            <span class="date" style="display:inline-block; width:90px;"><uiex:formatDate value="${item.regDttm}" type="date"/></span>
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
                                <!-- //noticeCat1 -->
                                <!-- noticeCat2 전체-->
                                <div id="noticeCat2" class="tab-content" style="display: none;">
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
												            <a href="javascript:void(0);" 
							                                    		onclick='moveMenu(this, "/bbs/bbsHome/bbsAtclListView.do?bbsTycd=NTC&bbsRefTycd=ORG", "PROMAIN000014", "PROMAIN000016", "전체공지", "tab"); return false;' class="item_txt">
												                <p class="tit">${item.atclTtl}</p>
												                <p class="desc">
												                    <span class="date" style="display:inline-block; width:90px;"><uiex:formatDate value="${item.regDttm}" type="date"/></span>
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
                                <!-- //noticeCat2 전체-->
                                <!-- noticeCat3 과목-->
                                <div id="noticeCat3" class="tab-content" style="display: none;">
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
												            <a class="item_txt" href="javascript:void(0)" onclick="viewAtclLect('${item.atclId}', '${item.rgtrId}', '${item.oyn}', '${item.bbsId}', '${item.bbsTycd}', 'ROOT','PROLECT000002', '${item.sbjctId}')" style="color: currentColor;">
												            	<p class="tit">${item.atclTtl}</p>
												                <p class="desc">
												                    <span class="name">[${item.orgnm}] ${item.sbjctnm}</span>
			                                                <span class="date" style="display:inline-block; width:90px;"><uiex:formatDate value="${item.regDttm}" type="date"/></span>
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
                                <!-- //noticeCat3 -->

                            </div>
                            <!-- //noticeListBox -->

<script>
let noticeWidgetCat = "noticeCat1";

// 공지사항 위젯 설정
function setNoticeWidget() {
	let inTitle = ``;
	let subTitle = `
		<nav class="tab-type1 notice-cat-btns">
		    <a href="#_" class="btn current" cat="noticeCat1"><span>전체</span></a>
		    <a href="#_" class="btn" cat="noticeCat2"><span>전체공지</span></a>
		    <a href="#_" class="btn" cat="noticeCat3"><span>과목공지</span></a>
		</nav>
		<div class="btn-wrap">
		    <a id="noticeMoreBtn" href="#_" class="btn_more" aria-label="더보기" onclick="moveNoticeWidgetMore();return false;" style="display:none"><i class="xi-plus"></i></a>
		</div>`;

	dashboardWidget.addInTitle("wigt_prof_notice", inTitle);
	dashboardWidget.addSubTitle("wigt_prof_notice", subTitle);


	// 공지 카테고리 선택
	$("nav.notice-cat-btns a.btn").on("click", function() {
		let cat = $(this).attr("cat");
		changeNoticeCat(cat);
		return false;
	});

	// 공지 카테고리 변경
	function changeNoticeCat(cat) {
		$("#noticeListBox .tab-content").hide();
		$("#"+cat).show();

		$("nav.notice-cat-btns a.btn").removeClass("current");
		$("nav.notice-cat-btns a.btn[cat="+cat+"]").addClass("current");

		// 더보기 버튼 보이기/숨기기
		if (cat !== "noticeCat1") {
			$("#noticeMoreBtn").show();
		}
		else {
			$("#noticeMoreBtn").hide();
		}

		// localdb에 카테고리 저장
		UiComm.db.setItem("prof:widget_notice_cat", cat);
		noticeWidgetCat = cat;
	}

	changeNoticeCat(noticeWidgetCat);
}

// 더보기 이동
function moveNoticeWidgetMore(subjectId) {
	// 전체공지
	if (noticeWidgetCat === "noticeCat2") {
		moveMenu(this, "/bbs/bbsHome/bbsAtclListView.do?bbsTycd=NTC&bbsRefTycd=ORG", "PROMAIN000014", "PROMAIN000016", "전체공지", "tab");
	}
	// 과목 공지
	else if (noticeWidgetCat === "noticeCat3") {
		moveMenu(this, "/bbs/bbsHome/bbsAtclListView.do?bbsTycd=NTC&bbsRefTycd=SBJCT", "PROMAIN000014", "PROMAIN000015", "과목공지", "tab", { sbjctId: subjectId } );
	}
}

setNoticeWidget();

</script>