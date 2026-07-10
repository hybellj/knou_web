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
	<div id="subjectCat1" class="tab-content" style="display: block; clear: both;">

			<div class="box_title" style="display:none;"> <i class="xi-arrows m_handle" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
                <h3 class="h3">수강과목</h3>
                <div class="btn-wrap">
                    <a href="#tab30" class="btn_list_type" aria-label="리스트형 보기"><i class="icon-svg-list" aria-hidden="true"></i></a>
                    <a href="#tab40" class="btn_list_type on" aria-label="카드형 보기"><i class="icon-svg-grid" aria-hidden="true"></i></a>
                </div>
            </div>

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
                                    <div class="extra">
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
									            <li><a href="javascript:void(0);" onclick='moveMenu(this, "/bbs/bbsLect/bbsAtclListView.do?bbsTycd=NTC", "ROOT", "STDLECT000002", "공지사항", "self", { sbjctId : "${item.sbjctId}"}); return false;' title="미열람공지건수">공지<span>${item.ntcCnt}</span></a></li>
									        </c:if>
									        <c:if test="${empty item.ntcBbsId}">
									            <li><a href="#" class="disabled">공지<span>0</span></a></li>
									        </c:if>

									        <c:if test="${not empty item.qnaBbsId}">
									            <c:if test="${item.qnaCnt != 0}">
									                <li><a href="javascript:void(0);" onclick='moveMenu(this, "/bbs/bbsLect/bbsAtclListView.do?bbsTycd=QNA", "ROOT", "STDLECT000004", "Q&A", "self", { sbjctId : "${item.sbjctId}"}); return false;' title="미응답Q&A건수">Q&A<span class="active">${item.qnaCnt}</span></a></li>
									            </c:if>
									            <c:if test="${item.qnaCnt == 0}">
									                <li><a href="javascript:void(0);" onclick='moveMenu(this, "/bbs/bbsLect/bbsAtclListView.do?bbsTycd=QNA", "ROOT", "STDLECT000004", "Q&A", "self", { sbjctId : "${item.sbjctId}"}); return false;' title="미응답Q&A건수Q&A">Q&A<span>${item.qnaCnt}</span></a></li>
									            </c:if>
									        </c:if>
									        <c:if test="${empty item.qnaBbsId}">
									            <li><a href="#" class="disabled">Q&A<span>0</span></a></li>
									        </c:if>

									        <c:if test="${not empty item.oneononeBbsId}">
									            <c:if test="${item.qnaCnt != 0}">
									                <li><a href="javascript:void(0);" onclick='moveMenu(this, "/bbs/bbsLect/bbsAtclListView.do?bbsTycd=1ON1", "ROOT", "STDLECT000005", "1ON1", "self", { sbjctId : "${item.sbjctId}"}); return false;' title="미응답1ON1건수">1:1<span class="active">${item.oneononeCnt}</span></a></li>
									            </c:if>
									            <c:if test="${item.qnaCnt == 0}">
									                <li><a href="javascript:void(0);" onclick='moveMenu(this, "/bbs/bbsLect/bbsAtclListView.do?bbsTycd=1ON1", "ROOT", "STDLECT000005", "1ON1", "self", { sbjctId : "${item.oneononeCnt}"}); return false;' title="미응답1ON1건수">1:1<span>${item.oneononeCnt}</span></a></li>
									            </c:if>
									        </c:if>
									        <c:if test="${empty item.oneononeBbsId}">
									            <li><a href="#" class="disabled">1:1<span>0</span></a></li>
									        </c:if>

									        <li><a href="javascript:void(0);" onclick='moveMenu(this, "/asmt2/stdntAsmtListView.do", "ROOT", "STDLECT000008", "과제", "self", { sbjctId : "${item.sbjctId}" } );return false;' title="과제" class="info">과제<span>${item.asmtCnt}</span></a></li>
									        <li><a href="javascript:void(0);" onclick='moveMenu(this, "/forum2/forumHome/Form/forumList.do", "ROOT", "STDLECT000011", "토론", "self", { sbjctId : "${item.sbjctId}" } );return false;' title="토론" class="info">토론<span>${item.dscsCnt}</span></a></li>
									        <li><a href="javascript:void(0);" onclick='moveMenu(this, "/smnr/stdntSmnrListView.do", "ROOT", "STDLECT000012", "세미나", "self", { sbjctId : "${item.sbjctId}"} );return false;' title="세미나" class="info">세미나<span>${item.smnrCnt}</span></a></li>
									        <li><a href="javascript:void(0);" onclick='moveMenu(this, "/quiz/stdntQuizListView.do", "ROOT", "STDLECT000009", "퀴즈", "self", { sbjctId : "${item.sbjctId}" } );return false;' title="퀴즈" class="info">퀴즈<span>${item.quizCnt}</span></a></li>
									        <li><a href="javascript:void(0);" onclick='moveMenu(this, "/srvy/stdntSrvyListView.do", "ROOT", "STDLECT000010", "설문", "self", { sbjctId : "${item.sbjctId}"} );return false;' title="설문" class="info">설문<span>${item.srvyCnt}</span></a></li>
									        <li><a href="javascript:void(0);" onclick='moveMenu(this, "/exam/stdntExamListView.do", "ROOT", "STDLECT000013", "시험", "self", { sbjctId : "${item.sbjctId}"} );return false;' title="시험" class="info">시험<span>${item.examCnt}</span></a></li>
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
                                            	<li><a href="javascript:void(0);"
	                                    		onclick='moveMenu(this, "/bbs/bbsLect/bbsAtclListView.do?bbsTycd=NTC", "ROOT", "STDLECT000002", "공지사항", "self", { sbjctId : "${item.sbjctId}" } );return false;'
	                                    		title="공지사항">공지 ${item.qnaCnt}</a></li>
                                            </c:if>
                                            <c:if test="${empty item.ntcBbsId}">
                                            	<li><a href="javascript:void(0);"
	                                    		onclick='moveMenu(this, "/bbs/bbsLect/bbsAtclListView.do?bbsTycd=NTC", "ROOT", "STDLECT000002", "공지사항", "self", { sbjctId : "${item.sbjctId}" } );return false;'
	                                    		title="공지사항">공지 0</a></li>
                                            </c:if>

                                           	<c:if test="${not empty item.qnaBbsId}">
                                           		<c:if test="${item.qnaCnt != 0}">
                                           			<li><a href="javascript:void(0);"
	                                    			onclick='moveMenu(this, "/bbs/bbsLect/bbsAtclListView.do?bbsTycd=QNA", "ROOT", "STDLECT000004", "Q&A", "self", { sbjctId : "${item.sbjctId}" } );return false;'
	                                    			title="Q&A">Q&A<span style="color:red;">${item.qnaCnt}</span></a></li>
                                           		</c:if>
                                           		<c:if test="${item.qnaCnt == 0}">
                                           			<li><a href="javascript:void(0);"
	                                    			onclick='moveMenu(this, "/bbs/bbsLect/bbsAtclListView.do?bbsTycd=QNA", "ROOT", "STDLECT000004", "Q&A", "self", { sbjctId : "${item.sbjctId}" } );return false;'
	                                    			title="Q&A">Q&A<span style="color:#007bff;">${item.qnaCnt}</span></a></li>
                                           		</c:if>
                                           	</c:if>
                                           	<c:if test="${empty item.qnaBbsId}">
                                           		<li><a style="pointer-events:none; color:#333333; font-size:14px; font-weight:bold;">Q&A<span>0</span></a></li>
                                           	</c:if>

                                           	<c:if test="${not empty item.oneononeBbsId}">
                                           		<c:if test="${item.qnaCnt != 0}">
                                           			<li><a href="javascript:void(0);"
	                                    			onclick='moveMenu(this, "/bbs/bbsLect/bbsAtclListView.do?bbsTycd=1ON1", "ROOT", "STDLECT000005", "1ON1", "self", { sbjctId : "${item.sbjctId}" } );return false;'
	                                    			title="1ON1">1 : 1<span style="color:red;">${item.oneononeCnt}</span></a></li>
                                           		</c:if>
                                           		<c:if test="${item.qnaCnt == 0}">
                                           			<li><a href="javascript:void(0);"
	                                    			onclick='moveMenu(this, "/bbs/bbsLect/bbsAtclListView.do?bbsTycd=1ON1", "ROOT", "STDLECT000005", "1ON1", "self", { sbjctId : "${item.sbjctId}" } );return false;'
	                                    			title="1ON1">1 : 1<span style="color:#007bff;">${item.oneononeCnt}</span></a></li>
                                           		</c:if>
                                           	</c:if>
                                           	<c:if test="${empty item.oneononeBbsId}">
                                           		<li><a style="pointer-events:none; color:#333333; font-size:14px; font-weight:bold;">1 : 1<span>0</span></a></li>
                                           	</c:if>
                                            <li><a href="javascript:void(0);" onclick='moveMenu(this, "/asmt2/stdntAsmtListView.do", "ROOT", "STDLECT000008", "과제", "self", { sbjctId : "${item.sbjctId}" } );return false;' title="과제" class="info">과제<span>${item.asmtCnt}</span></a></li>
                                            <li><a href="javascript:void(0);" onclick='moveMenu(this, "/forum2/forumHome/Form/forumList.do", "ROOT", "STDLECT000011", "토론", "self", { sbjctId : "${item.sbjctId}" } );return false;' title="토론" class="info">토론<span>${item.dscsCnt}</span></a></li>
                                            <li><a href="javascript:void(0);" onclick='moveMenu(this, "/smnr/stdntSmnrListView.do", "ROOT", "STDLECT000012", "세미나", "self", { sbjctId : "${item.sbjctId}"} );return false;' title="세미나" class="info">세미나<span>${item.smnrCnt}</span></a></li>
                                            <li><a href="javascript:void(0);" onclick='moveMenu(this, "/quiz/stdntQuizListView.do", "ROOT", "STDLECT000009", "퀴즈", "self", { sbjctId : "${item.sbjctId}" } );return false;' title="퀴즈" class="info">퀴즈<span>${item.quizCnt}</span></a></li>
                                            <li><a href="javascript:void(0);" onclick='moveMenu(this, "/srvy/stdntSrvyListView.do", "ROOT", "STDLECT000010", "설문", "self", { sbjctId : "${item.sbjctId}"} );return false;' title="설문" class="info">설문<span>${item.srvyCnt}</span></a></li>
                                            <li><a href="javascript:void(0);" onclick='moveMenu(this, "/exam/stdntExamListView.do", "ROOT", "STDLECT000013", "시험", "self", { sbjctId : "${item.sbjctId}"} );return false;' title="시험" class="info">시험<span>${item.examCnt}</span></a></li>
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
function setSubjectWidget() {
	// [핵심 변경] 프레임워크 기능을 사용해 상단바에 완전히 얹어버립니다.
	if (typeof dashboardWidget !== "undefined" && dashboardWidget.addSubTitle) {

		// 버튼 및 학기 셀렉트박스 마크업 구성 (flex 정렬 및 내부 간격 추가 확보)
		let buttonHtml = `
			<div class="btn-wrap subject-select" style="display: flex !important; align-items: center; gap: 8px; margin: 0; white-space: nowrap !important; flex-wrap: nowrap !important;">
				<a href="#0" class="btn_list_type btn_list" mode="list" aria-label="List View" style="display:inline-flex;"><i class="icon-svg-list" style="font-size: 18px !important; width: 18px !important; height: 18px !important;" aria-hidden="true"></i></a>
			    <a href="#0" class="btn_list_type btn_card" mode="card" aria-label="Card View" style="display:none;"><i class="icon-svg-grid" style="font-size: 18px !important; width: 18px !important; height: 18px !important;" aria-hidden="true"></i></a>
			</div>`;

		// 대시보드 우측 서브타이틀 영역에 주입
		dashboardWidget.addSubTitle("wigt_stu_subject", buttonHtml);

		// [강제 조치] 대시보드 기본 옵션에 의해 추가 생성되는 중복 타이틀 껍데기 레이아웃이 있다면 강제 삭제 처리
		$("[data-id='wigt_stu_subject']").find(".box_title").not(":first").remove();
	}

	if(typeof UiChosen === "function") UiChosen();

	let subjectCat = "subjectCat1";
	let listMode = "list";

	if(typeof UiComm !== "undefined" && UiComm.db) {
		listMode = UiComm.db.getItem("stu:widget_subject_mode") || "list";
	}

	// 동적 주입된 버튼 이벤트를 포착하기 위해 위임 이벤트 바인딩
	$(document).off("click", ".subject-select a.btn_list_type").on("click", ".subject-select a.btn_list_type", function() {
		let mode = $(this).attr("mode");
		chageSubjectListMode(mode);
		return false;
	});

	function chageSubjectListMode(mode) {
		let $currentCat = $("#" + subjectCat);

		// 크기 지정을 더 명확하게 처리 (너비/높이를 34px로 키우고 보더나 패딩 영향력을 제어)
		let activeBtnStyle = "display: inline-flex !important; align-items: center; justify-content: center; width: 34px !important; height: 34px !important; min-width: 34px !important; padding: 0 !important; border: 1px solid #ccc !important; border-radius: 4px; background: #fff !important;";

		if (mode === "list") {
			$currentCat.find(".view_card").attr("style", "display: none !important;");
			$currentCat.find(".view_list").attr("style", "display: block !important;");

			$(".subject-select .btn_list").attr("style", "display: none !important;");
			$(".subject-select .btn_card").attr("style", activeBtnStyle);
		} else {
			$currentCat.find(".view_list").attr("style", "display: none !important;");
			$currentCat.find(".view_card").attr("style", "display: block !important;");

			$(".subject-select .btn_card").attr("style", "display: none !important;");
			$(".subject-select .btn_list").attr("style", activeBtnStyle);
		}

		if(typeof UiComm !== "undefined" && UiComm.db) {
			UiComm.db.setItem("stu:widget_subject_mode", mode);
		}
		listMode = mode;
	}

	chageSubjectListMode(listMode);
}

$(document).ready(function() {
	setSubjectWidget();
});
</script>