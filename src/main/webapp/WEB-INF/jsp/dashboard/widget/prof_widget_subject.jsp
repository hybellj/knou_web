<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<script>

let EPARAM = '<c:out value="${encParams}" />';

function moveClassRoom(sbjctId) {
    const extData = {
        sbjctId: sbjctId
    };

    location.href = "/subject/subject.do?encParams=" + EPARAM + "&addParams=" + UiComm.makeEncParams(extData);
}

</script>
<div id="subjectListBox">
	<%-- 전체 과목 --%>
	<div id="subjectCat1" class="tab-content" style="display: block;">
            <div class="box_title" style="display:none;"> <i class="xi-arrows m_handle" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
                <h3 class="h3">강의과목</h3>
                <div class="btn-wrap">

                    <select class="form-select">
                    </select>

                    <a href="#tab30" class="btn_list_type" aria-label="리스트형 보기"><i class="icon-svg-list" aria-hidden="true"></i></a>
                    <a href="#tab40" class="btn_list_type on" aria-label="카드형 보기"><i class="icon-svg-grid" aria-hidden="true"></i></a>
                </div>
            </div>

			<!--  카드형 -->
			<div id="tab30" class="box_content view_card">
                <div class="tab-content" style="display: block;">
                    <ul class="lecture_list">
                        <c:choose>
							<c:when test="${empty dashVM.lctrSbjctSummaryList}">
  								<li>[카드형]강의과목이 없습니다</li>
							</c:when>
						<c:otherwise>
						<c:set var="cnt" value="0" />
						<c:forEach var="item" items="${dashVM.lctrSbjctSummaryList}">
                            <li>
                                <div class="card_item">
                                    <div class="item_header">
                                        <div class="title_area">
                                            <p class="info_detail">
                                                <c:choose>
												    <c:when test="${item.orgTycd eq 'LMSBASIC'}"><c:set var="styClass" value="uniA"/><c:set var="AvgPrgrRt" value="45.3"/></c:when>
												    <c:when test="${item.orgTycd eq 'KNOU'}"><c:set var="styClass" value="uniB"/><c:set var="AvgPrgrRt" value="30.9"/></c:when>
												    <c:when test="${item.orgTycd eq 'SMART'}"><c:set var="styClass" value="uniC"/><c:set var="AvgPrgrRt" value="55.5"/></c:when>
												    <c:when test="${item.orgTycd eq 'CITT'}"><c:set var="styClass" value="uniD"/><c:set var="AvgPrgrRt" value="60.3"/></c:when>
												    <c:when test="${item.orgTycd eq 'GDSC_BIZ'}"><c:set var="styClass" value="uniE"/><c:set var="AvgPrgrRt" value="70.0"/></c:when>
												    <c:otherwise><c:set var="styClass" value="uniA"/><c:set var="AvgPrgrRt" value="48.5"/></c:otherwise>
												</c:choose>
                                       			<span class="label <c:out value='${styClass}'/>">${item.orgShrtnm}</span>
                                                <span class="info_txt">수강 ${item.atndlcCnt}명</span>
                                                <span class="info_txt">튜터 ${item.tutUsernm}</span>
                                                <span class="info_txt">${item.crdts}학점</span>
                                            </p>
                                            <p class="tit"><a href="#" class='link' onclick='moveClassRoom("${item.sbjctId}"); return false;'>${item.sbjctnm}</a></p>
                                        </div>
                                    </div>
                                    <div class="extra">h 
                                        <div class="info">
                                            <p class="point">
                                                <span class="tit">중간고사:</span>
                                                <c:if test="${empty item.midExamSdttm}">
                                                	<span>미정</span>
                                                </c:if>
                                                <c:if test="${not empty item.midExamSdttm}">
                                                	<span><uiex:formatDate value="${item.midExamSdttm}" type="datetime"/></span>
                                                </c:if>
                                            </p>
                                            <p class="desc">
                                                <span class="tit">시간:</span>
                                                <span>${item.midExamMnts}분</span>
                                            </p>
                                        </div>
                                        <div class="info">
                                            <p class="point">
                                                <span class="tit">기말고사:</span>
                                                <c:if test="${empty item.lstExamSdttm}">
                                                	<span>미정</span>
                                                </c:if>
                                                <c:if test="${not empty item.lstExamSdttm}">
                                                	<span><uiex:formatDate value="${item.lstExamSdttm}" type="datetime"/></span>
                                                </c:if>
                                            </p>
                                            <p class="desc">
                                                <span class="tit">시간:</span>
                                                <span>${item.lstExamMnts}분</span>
                                            </p>
                                        </div>
                                        <div class="my_prog_rate">
                                            <div class="progress">
                                                <div class="bar blue_type" style="width: <c:out value='${AvgPrgrRt}'/>%;"></div>
                                            </div>
                                            <span class="prog_num">평균 진도율</span><span class="meta"><c:out value='${AvgPrgrRt}'/>%</span>
                                        </div>
                                    </div>
                                    <div class="bottom_button">
                                       <ul class="card_btns">
                                       		<c:if test="${not empty item.ntcBbsId}">
                                       			<c:if test="${item.ntcCnt != 0}">
	                                            	<li><a href="javascript:void(0);"
		                                    		onclick='moveMenu(this, "/bbs/bbsLect/bbsAtclListView.do?bbsTycd=NTC", "ROOT", "PROLECT000002", "공지사항", "self", { sbjctId : "${item.sbjctId}"} ); return false;'
		                                    		title="공지사항">공지<span style="color:#007bff;">${item.ntcCnt}</span></a></li>
		                                    	</c:if>
	                                    		<c:if test="${item.ntcCnt == 0}">
                                           			<li><a href="#0">공지<span>0</span></a></li>
                                           		</c:if>
                                           	</c:if>
                                            <c:if test="${empty item.ntcBbsId}">
                                            	<li><a href="#0">공지<span>0</span></a></li>
                                            </c:if>
                                           	<c:if test="${not empty item.qnaBbsId}">
                                           		<c:if test="${item.qnaCnt != 0}">
                                           			<li><a href="javascript:void(0);"
	                                    			onclick='moveMenu(this, "/bbs/bbsLect/bbsAtclListView.do?bbsTycd=QNA", "ROOT", "PROLECT000004", "Q&A", "self", { sbjctId : "${item.sbjctId}"}); return false;'
                                           			title="Q&A">Q&A<span style="color:red;">${item.qnaCnt}</span></a>
                                           		</c:if>
                                           		<c:if test="${item.qnaCnt == 0}">
                                           			<li><a href="#0">Q&A<span>0</span></a></li>
                                           		</c:if>
                                           	</c:if>
                                           	<c:if test="${empty item.qnaBbsId}">
                                           		<li><a href="#0">Q&A<span>0</span></a></li>
                                           	</c:if>
                                           	<c:if test="${not empty item.oneononeBbsId}">
                                           		<c:if test="${item.oneononeCnt != 0}">
                                           			<li><a href="javascript:void(0);"
	                                    			onclick='moveMenu(this, "/bbs/bbsLect/bbsAtclListView.do?bbsTycd=1ON1", "ROOT", "PROLECT000005", "1ON1", "self", { sbjctId : "${item.sbjctId}"}); return false;'
                                           			title="1ON1">1 : 1<span style="color:red;">${item.oneononeCnt}</span></a></li>
                                           		</c:if>
                                           		<c:if test="${item.oneononeCnt == 0}">
                                           			<li><a href="#0">1 : 1<span>0</span></a></li>
                                           		</c:if>
                                           	</c:if>
                                           	<c:if test="${empty item.oneononeBbsId}">
                                           		<li><a href="#0">1 : 1<span>0</span></a></li>
                                           	</c:if>
                                           	<li><a href="javascript:void(0);" onclick='moveMenu(this, "/asmt2/profAsmtListView.do", "ROOT", "PROLECT000008", "과제", "self", { sbjctId : "${item.sbjctId}" } );return false;' title="과제" class="info">과제<span>${item.asmtCnt}</span></a></li>
                                            <li><a href="javascript:void(0);" onclick='moveMenu(this, "/forum2/forumLect/profForumListView.do", "ROOT", "PROLECT000011", "토론", "self", { sbjctId : "${item.sbjctId}" } );return false;' title="토론" class="info">토론<span>${item.dscsCnt}</span></a></li>
                                            <li><a href="javascript:void(0);" onclick='moveMenu(this, "/smnr/profSmnrListView.do", "ROOT", "PROLECT000012", "세미나", "self", { sbjctId : "${item.sbjctId}"} );return false;' title="세미나" class="info">세미나<span>${item.smnrCnt}</span></a></li>
                                            <li><a href="javascript:void(0);" onclick='moveMenu(this, "/quiz/profQuizListView.do", "ROOT", "PROLECT000009", "퀴즈", "self", { sbjctId : "${item.sbjctId}" } );return false;' title="퀴즈" class="info">퀴즈<span>${item.quizCnt}</span></a></li>
                                            <li><a href="javascript:void(0);" onclick='moveMenu(this, "/srvy/profSrvyListView.do", "ROOT", "PROLECT000010", "설문", "self", { sbjctId : "${item.sbjctId}"} );return false;' title="설문" class="info">설문<span>${item.srvyCnt}</span></a></li>
                                            <li><a href="javascript:void(0);" onclick='moveMenu(this, "/exam/profExamListView.do", "ROOT", "PROLECT000013", "시험", "self", { sbjctId : "${item.sbjctId}"} );return false;' title="시험" class="info">시험<span>${item.examCnt}</span></a></li>
                                        </ul>
                                    </div>
                                </div>
                            </li>
                     </c:forEach>
                     </c:otherwise>
                   </c:choose>
                    </ul>
                </div>
            </div>

            <!-- 목록형 -->
            <div id="tab40" class="box_content view_list">
                <div class="tab-content" style="display: block;">
                    <ul class="lecture_list2">
                     	<c:choose>
							<c:when test="${empty dashVM.lctrSbjctSummaryList}">
							   <li>강의과목이 없습니다</li>
							</c:when>
							<c:otherwise>
							<c:set var="cnt" value="0" />
							<c:forEach var="item" items="${dashVM.lctrSbjctSummaryList}">
                            <li>
                                <div class="card_item">
                                    <div class="item_header">
                                    <c:choose>
									    <c:when test="${item.orgTycd eq 'LMSBASIC'}"><c:set var="styClass" value="uniA"/><c:set var="AvgPrgrRt" value="45.3"/></c:when>
									    <c:when test="${item.orgTycd eq 'KNOU'}"><c:set var="styClass" value="uniB"/><c:set var="AvgPrgrRt" value="30.9"/></c:when>
									    <c:when test="${item.orgTycd eq 'SMART'}"><c:set var="styClass" value="uniC"/><c:set var="AvgPrgrRt" value="55.5"/></c:when>
									    <c:when test="${item.orgTycd eq 'CITT'}"><c:set var="styClass" value="uniD"/><c:set var="AvgPrgrRt" value="60.3"/></c:when>
									    <c:when test="${item.orgTycd eq 'GDSC_BIZ'}"><c:set var="styClass" value="uniE"/><c:set var="AvgPrgrRt" value="70.0"/></c:when>
									    <c:otherwise><c:set var="styClass" value="uniA"/><c:set var="AvgPrgrRt" value="48.5"/></c:otherwise>
									</c:choose>
                                        <span class="label <c:out value='${styClass}'/>">${item.orgShrtnm}</span>
                                        <div class="title_area">
                                            <p class="info_detail">
                                                <span class="info_txt">수강 ${item.atndlcCnt}명</span>
                                                <span class="info_txt">튜터 ${item.tutUsernm}</span>
                                                <span class="info_txt">${item.crdts}학점</span>
                                            </p>
                                            <p class="tit"><a href="#" class='link' onclick='moveClassRoom("${item.sbjctId}"); return false;'>${item.sbjctnm}</a></p>
                                        </div>
                                        <div class="extra">
                                            <div class="my_prog_rate">
                                                <span class="prog_num">평균 진도율</span><span class="meta"><c:out value='${AvgPrgrRt}'/>%</span>
                                                <div class="progress">
                                                    <div class="bar blue_type" style="width: <c:out value='${AvgPrgrRt}'/>%;"></div>
                                                </div>
                                            </div>
                                            <div class="info">
                                                <p class="point">
                                                    <span class="tit">중간고사:</span>
                                                    <c:if test="${empty item.midExamSdttm}">
                                                 	<span>미정</span>
                                                 </c:if>
                                                 <c:if test="${not empty item.midExamSdttm}">
                                                 	<span><uiex:formatDate value="${item.midExamSdttm}" type="datetime"/></span>
                                                 </c:if>
                                                </p>
                                                <p class="desc">
                                                    <span class="tit">시간:</span>
                                                    <span>${item.midExamMnts}분</span>
                                                </p>
                                            </div>
                                            <div class="info">
                                                <p class="point">
                                                    <span class="tit">기말고사:</span>
                                                 <c:if test="${empty item.lstExamSdttm}">
                                                 	<span>미정</span>
                                                 </c:if>
                                                 <c:if test="${not empty item.lstExamSdttm}">
                                                 	<span><uiex:formatDate value="${item.lstExamSdttm}" type="datetime"/></span>
                                                 </c:if>
                                                </p>
                                                <p class="desc">
                                                    <span class="tit">시간:</span>
                                                    <span>${item.lstExamMnts}분</span>
                                                </p>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="bottom_button">
                                       <ul class="card_btns">
                                            <c:if test="${not empty item.ntcBbsId}">
                                            	<c:if test="${item.ntcCnt != 0}">
	                                            	<li><a href="javascript:void(0);"
		                                    		onclick='moveMenu(this, "/bbs/bbsLect/bbsAtclListView.do?bbsTycd=NTC", "ROOT", "PROLECT000002", "공지사항", "self", { sbjctId : "${item.sbjctId}" } );return false;'
		                                    		title="공지사항">공지 ${item.ntcCnt}</a></li>
		                                    	</c:if>
		                                    	<c:if test="${item.ntcCnt == 0}">
                                           			<li><a href="#0">공지<span>0</span></a></li>
                                           		</c:if>
                                            </c:if>
                                            <c:if test="${empty item.ntcBbsId}">
                                            	<li><a href="#0">공지<span>0</span></a></li>
                                            </c:if>
                                           	<c:if test="${not empty item.qnaBbsId}">
                                           		<c:if test="${item.qnaCnt != 0}">
                                           			<li><a href="javascript:void(0);"
	                                    			onclick='moveMenu(this, "/bbs/bbsLect/bbsAtclListView.do?bbsTycd=QNA", "ROOT", "PROLECT000004", "Q&A", "self", { sbjctId : "${item.sbjctId}" } );return false;'
	                                    			title="Q&A">Q&A<span style="color:red;">${item.qnaCnt}</span></a></li>
                                           		</c:if>
                                           		<c:if test="${item.qnaCnt == 0}">
                                           			<li><a href="#0">Q&A<span>0</span></a></li>
                                           		</c:if>
                                           	</c:if>
                                           	<c:if test="${empty item.qnaBbsId}">
                                           		<li><a href="#0">Q&A<span>0</span></a></li>
                                           	</c:if>
                                           	<c:if test="${not empty item.oneononeBbsId}">
                                           		<c:if test="${item.oneononeCnt != 0}">
                                           			<li><a href="javascript:void(0);"
	                                    			onclick='moveMenu(this, "/bbs/bbsLect/bbsAtclListView.do?bbsTycd=1ON1", "ROOT", "PROLECT000005", "1ON1", "self", { sbjctId : "${item.sbjctId}" } );return false;'
	                                    			title="1ON1">1 : 1<span style="color:red;">${item.oneononeCnt}</span></a></li>
                                           		</c:if>
                                           		<c:if test="${item.oneononeCnt == 0}">
                                           			<li><a href="#0">1 : 1<span>0</span></a></li>
                                           		</c:if>
                                           	</c:if>
                                           	<c:if test="${empty item.oneononeBbsId}">
                                           		<li><a href="#0">1 : 1<span>0</span></a></li>
                                           	</c:if>
                                            <li><a href="javascript:void(0);" onclick='moveMenu(this, "/asmt2/profAsmtListView.do", "ROOT", "PROLECT000008", "과제", "self", { sbjctId : "${item.sbjctId}" } );return false;' title="과제" class="info">과제<span>${item.asmtCnt}</span></a></li>
                                            <li><a href="javascript:void(0);" onclick='moveMenu(this, "/forum2/forumLect/profForumListView.do", "ROOT", "PROLECT000011", "토론", "self", { sbjctId : "${item.sbjctId}" } );return false;' title="토론" class="info">토론<span>${item.dscsCnt}</span></a></li>
                                            <li><a href="javascript:void(0);" onclick='moveMenu(this, "/smnr/profSmnrListView.do", "ROOT", "PROLECT000012", "세미나", "self", { sbjctId : "${item.sbjctId}"} );return false;' title="세미나" class="info">세미나<span>${item.smnrCnt}</span></a></li>
                                            <li><a href="javascript:void(0);" onclick='moveMenu(this, "/quiz/profQuizListView.do", "ROOT", "PROLECT000009", "퀴즈", "self", { sbjctId : "${item.sbjctId}" } );return false;' title="퀴즈" class="info">퀴즈<span>${item.quizCnt}</span></a></li>
                                            <li><a href="javascript:void(0);" onclick='moveMenu(this, "/srvy/profSrvyListView.do", "ROOT", "PROLECT000010", "설문", "self", { sbjctId : "${item.sbjctId}"} );return false;' title="설문" class="info">설문<span>${item.srvyCnt}</span></a></li>
                                            <li><a href="javascript:void(0);" onclick='moveMenu(this, "/exam/profExamListView.do", "ROOT", "PROLECT000013", "시험", "self", { sbjctId : "${item.sbjctId}"} );return false;' title="시험" class="info">시험<span>${item.examCnt}</span></a></li>
                                        </ul>
                                    </div>
                                </div>
                            </li>
                   			</c:forEach>
                      	</c:otherwise>
                  	</c:choose>
                   	</ul>
                </div>
            </div>

	</div>
</div>

<script>
// 강의과목 위젯 설정
function setSubjectWidget() {
	let inTitle = ``;
	let subTitle = `
		<div class="btn-wrap subject-select">
		    <a href="#0" class="btn_list_type btn_list" mode="list" aria-label="List View" style="display:inline-flex"><i class="icon-svg-list" aria-hidden="true"></i></a>
		    <a href="#0" class="btn_list_type btn_card" mode="card" aria-label="Card View" style="display:none"><i class="icon-svg-grid" aria-hidden="true"></i></a>
		</div>`;

	// 위젯 타이틀 내용 설정
	dashboardWidget.addInTitle("wigt_prof_subject", inTitle);
	dashboardWidget.addSubTitle("wigt_prof_subject", subTitle);

	// localdb에서 카테고리, mode 가져오기
	let subjectCat = "subjectCat1";
	let listMode = "list";

	if(typeof UiComm !== "undefined" && UiComm.db) {
		subjectCat = UiComm.db.getItem("prof:widget_subject_cat") || "subjectCat1";
		listMode = UiComm.db.getItem("prof:widget_subject_mode") || "list";
	}

	// 과목 카테고리 선택 이벤트 바인딩
	$(document).off("click", "nav.subject-cat-btns a.btn").on("click", "nav.subject-cat-btns a.btn", function() {
		let cat = $(this).attr("cat");
		changeSubjectCat(cat);
		return false;
	});

	// 목록형/카드형 선택 이벤트 바인딩
	$(document).off("click", ".btn-wrap.subject-select a.btn_list_type").on("click", ".btn-wrap.subject-select a.btn_list_type", function() {
		let mode = $(this).attr("mode");
		chageSubjectListMode(mode);
		return false;
	});

	// 과목 기관(카테고리) 변경 함수
	function changeSubjectCat(cat) {
		// 메인 카테고리 전환 숨김/보임 처리
		$("#subjectListBox > .tab-content").hide();
		$("#" + cat).show();

		$("nav.subject-cat-btns a.btn").removeClass("current");
		$("nav.subject-cat-btns a.btn[cat=" + cat + "]").addClass("current");

		if(typeof UiComm !== "undefined" && UiComm.db) {
			UiComm.db.setItem("prof:widget_subject_cat", cat);
		}
		subjectCat = cat;

		// 카테고리가 바뀔 때 현재 설정된 listMode 세팅 재적용
		chageSubjectListMode(listMode);
	}

	// 과목 목록형/카드형 변경 함수
	function chageSubjectListMode(mode) {
		// 현재 활성화된 카테고리(#subjectCat1 등) 내부의 요소만 제어하도록 범위 제한
		let $currentCat = $("#" + subjectCat);

		if (mode === "list") {
			$currentCat.find(".view_card").hide();
			$currentCat.find(".view_list").show();
			$(".btn-wrap.subject-select a.btn_list_type.btn_list").hide();
			$(".btn-wrap.subject-select a.btn_list_type.btn_card").css("display", "inline-flex");
		} else {
			$currentCat.find(".view_list").hide();
			$currentCat.find(".view_card").show();
			$(".btn-wrap.subject-select a.btn_list_type.btn_card").hide();
			$(".btn-wrap.subject-select a.btn_list_type.btn_list").css("display", "inline-flex");
		}

		if(typeof UiComm !== "undefined" && UiComm.db) {
			UiComm.db.setItem("prof:widget_subject_mode", mode);
		}
		listMode = mode;
	}

	// 초기 실행
	changeSubjectCat(subjectCat);
}

$(document).ready(function() {
	setSubjectWidget();
});
</script>