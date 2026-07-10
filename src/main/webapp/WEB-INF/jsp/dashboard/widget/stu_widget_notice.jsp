<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

	<div class="noticeListBox">
        <div id="noticeCat1" class="tab-content" style="display: block;">
            <ul class="dash_item_listA">
                <c:choose>
                    <c:when test="${empty dashVM.stdntDashAllNoticeList}">
                        <li>최신공지사항이 없습니다</li>
                    </c:when>
                    <c:otherwise>
                   		<c:set var="cnt" value="0"/>                      
                        <c:forEach var="item" items="${dashVM.stdntDashAllNoticeList}">
                            <c:if test="${item.topic eq 'STDNT_DASH_ALL_NOTICE' and cnt lt 3}">
                                <li>
                                    			<div class="noti_label">
		                                        <c:choose>
		                                            <c:when test="${item.badge eq 'ALL'}">
                                                		<label class="labelA">전체</label>
		                                                </div>
		                                                <a href="javascript:void(0);" 
			                                    			onclick='moveMenu(this, "/bbs/bbsHome/bbsAtclListView.do?bbsTycd=NTC&bbsRefTycd=ORG", "STDMAIN000007", "STDMAIN000007", "전체공지", "tab"); return false;'
			                                    		 	class="item_txt">
				                                    		 <p class="tit">${item.atclTtl}</p>
			                                       			 <p class="desc">
			                                       			 	<span class="date" style="display:inline-block; width:90px;"><uiex:formatDate value="${item.regDttm}" type="date"/></span>
			                                       			 </p>
		                                       			 </a>
                                            		</c:when>
                                            		<c:otherwise>
		                                                <label class="labelB">과목</label>
		                                                </div>
														 <a class="item_txt"
															   href="javascript:void(0)"
															   onclick='lectMoveMenu(
															       this,
															       "/bbs/bbsLect/bbsAtclView.do?bbsTycd=NTC&bbsId=${item.bbsId}&atclId=${item.atclId}&templateUrl=bbsLect&sbjctId=${item.sbjctId}&bbsRefTycd=SBJCT",
															       "ROOT",
															       "STDLECT000002",
															       "공지사항",
															       "self"
															   )'
															   title="공지사항" style="color: currentColor;">
															   	<p class="tit">${item.atclTtl}</p>
	                                        					<p class="desc">
		                                        					<span class="name">[${item.orgnm}] ${item.sbjctnm}</span>
		                                                    		<span class="date" style="display:inline-block; width:90px;"><uiex:formatDate value="${item.regDttm}" type="date"/></span>
	                                                    		</p>
                                                    		</a>
                                            		</c:otherwise>
                                            	</c:choose>
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

        <div id="noticeCat2" class="tab-content" style="display: none;">
            <ul class="dash_item_listA">
                <c:choose>
                    <c:when test="${empty dashVM.dashCrsNoticeList}">
                        <li>전체공지사항이 없습니다</li>
                    </c:when>
                    <c:otherwise>
                    	<c:set var="cnt" value="0"/>                      
                        <c:forEach var="item" items="${dashVM.dashCrsNoticeList}">                        	
                            <c:if test="${item.topic eq 'CRS_NOTICE' and cnt lt 3}">
                                <li>
                                    <div class="noti_label">
                                        <label class="labelA">전체</label>
                                    </div>
                                    	<a href="javascript:void(0);" 
                                   		onclick='moveMenu(this, "/bbs/bbsHome/bbsAtclListView.do?bbsTycd=NTC&bbsRefTycd=ORG", "STDMAIN000007", "STDMAIN000009", "전체공지", "tab"); return false;'
                                   		class="item_txt">
                                        <p class="tit">${item.atclTtl}</p>
                                        <p class="desc">
                                            <span class="date" style="display:inline-block; width:90px;"><uiex:formatDate value="${item.regDttm}" type="date"/></span>
                                        </p>
                                    </a>
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
                                <c:set var="cnt" value="${cnt + 1}" />
                            </c:if>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>

        <div id="noticeCat3" class="tab-content" style="display: none;">
            <ul class="dash_item_listA">
                <c:choose>
                    <c:when test="${empty dashVM.stdntDashSubjectNoticeList}">
                        <li>과목공지사항이 없습니다</li>
                    </c:when>
                    <c:otherwise>          
                    	<c:set var="cnt" value="0" />              
                        <c:forEach var="item" items="${dashVM.stdntDashSubjectNoticeList}">                        	
                            <c:if test="${item.topic eq 'STDNT_DASH_SUBJECT_NOTICE' and cnt lt 3}">
                                <li>
                                    <div class="noti_label">
                                        <label class="labelB">과목</label>
                                    </div>
											 <a class="item_txt"
												   href="javascript:void(0)"
												   onclick='lectMoveMenu(
												       this,
												       "/bbs/bbsLect/bbsAtclView.do?bbsTycd=NTC&bbsId=${item.bbsId}&atclId=${item.atclId}&templateUrl=bbsLect&sbjctId=${item.sbjctId}&bbsRefTycd=SBJCT",
												       "ROOT",
												       "STDLECT000002",
												       "공지사항",
												       "self"
												   )'
												   title="공지사항" style="color: currentColor;">
												   	<p class="tit">${item.atclTtl}</p>
                                   					<p class="desc">
                                    					<span class="name">[${item.orgnm}] ${item.sbjctnm}</span>
                                                		<span class="date" style="display:inline-block; width:90px;"><uiex:formatDate value="${item.regDttm}" type="date"/></span>
                                               		</p>
	                                         </a>
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
                                <c:set var="cnt" value="${cnt + 1}" />
                            </c:if>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
</div>

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
            <a id="noticeMoreBtn"
               href="#_"
               class="btn_more"
               aria-label="더보기"
               onclick="moveNoticeWidgetMore();return false;"
               style="display:none">
                <i class="xi-plus"></i>
            </a>
        </div>`;

    dashboardWidget.addInTitle("wigt_stu_notice", inTitle);
    dashboardWidget.addSubTitle("wigt_stu_notice", subTitle);

    // 저장된 카테고리
    noticeWidgetCat = UiComm.db.getItem("stu:widget_notice_cat") || "noticeCat1";

    // 이벤트 등록
    $("nav.notice-cat-btns a.btn").off("click").on("click", function() {
        let cat = $(this).attr("cat");
        changeNoticeCat(cat);
        return false;
    });

    // 카테고리 변경
    function changeNoticeCat(cat) {

	    // 모든 탭 숨김
	    $(".noticeListBox > .tab-content").hide();
	
	    // 선택한 탭만 표시
	    $(".noticeListBox > #" + cat).show();
	
	    // 버튼 활성화
	    $("nav.notice-cat-btns a.btn").removeClass("current");
	    $('nav.notice-cat-btns a.btn[cat="' + cat + '"]').addClass("current");
	
	    // 더보기 버튼
	    if (cat === "noticeCat1") {
	        $("#noticeMoreBtn").hide();
	    } else {
	        $("#noticeMoreBtn").show();
	    }
	
	    // 상태 저장
	    UiComm.db.setItem("stu:widget_notice_cat", cat);
	    noticeWidgetCat = cat;
	}

    changeNoticeCat("noticeCat1");
}

// 더보기 이동
function moveNoticeWidgetMore() {

    if (noticeWidgetCat === "noticeCat2") {
        moveMenu(
            this,
            "/bbs/bbsHome/bbsAtclListView.do?bbsTycd=NTC&bbsRefTycd=ORG",
            "STDMAIN000007",
            "STDMAIN000009",
            "전체공지",
            "tab"
        );
    }
    else if (noticeWidgetCat === "noticeCat3") {
        moveMenu(
            this,
            "/bbs/bbsHome/bbsAtclListView.do?bbsTycd=NTC&bbsRefTycd=SBJCT",
            "STDMAIN000007",
            "STDMAIN000008",
            "과목공지",
            "tab"
        );
    }
}

setNoticeWidget();
</script>