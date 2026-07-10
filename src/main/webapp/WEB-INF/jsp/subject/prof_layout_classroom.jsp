<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@page import="knou.framework.common.ParamInfo"%>
<%@page import="knou.framework.common.SubjectInfo"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
	<jsp:param name="style" value="classroom"/>
</jsp:include>
<script type="text/javascript">

let dialog1;
let dialog2;
let dialog3;
let dialog4;

$(document).ready(function () {
    initCurrentWeek();
});

let EPARAM = '<c:out value="${encParams}" />';

let allFolded = false;

//const CURRENT_WEEK = "${lctrWknoSchdlVO.lctrWkno}" === "" ? 1 : Number("${lctrWknoSchdlVO.lctrWkno}");

const CURRENT_WEEK = "${lctrWknoSchdlVO.lctrWkno}";

function foldAllWeek() {
    $(".course_week > li").removeClass("active");
}

function toggleWeek(btn) {

	if (!allFolded) {

        // 전체 접기
        $(".course_week > li").removeClass("active");

        $(btn).text("주차 펼침");
        allFolded = true;

    } else {

        $(".course_week > li").removeClass("active");

        // 현재 주차가 없으면 1주차
        const week = Number(CURRENT_WEEK) || 1;

        const $current = $(".course_week > li").eq(week - 1);

        if ($current.length) {
            $current.addClass("active");

            $("html, body").animate({
                scrollTop: $current.offset().top - 100
            }, 300);
        }

        $(btn).text("주차 접음");
        allFolded = false;
    }
}


function moveWeek(weekNo) {

    if (!weekNo || isNaN(weekNo)) {
        return;
    }

    // 모두 접기
    $(".course_week > li").removeClass("active");

    // 선택한 주차
    const $target = $('.course_week > li[data-week="' + weekNo + '"]');

    if (!$target.length) {
        return;
    }

    // 펼치기
    $target.addClass("active");

    // 해당 위치로 이동
    $("html, body").animate({
        scrollTop: $target.offset().top - 100
    }, 300);

    // 버튼 상태
    allFolded = false;
    $("#btnToggleWeek").text("주차 접음");
}

function initCurrentWeek() {

	// 모두 접기
    $(".course_week > li").removeClass("active");

    // 현재 주차가 없으면 모두 닫은 상태 유지
    if (!CURRENT_WEEK) {
        allFolded = true;
        $("#btnToggleWeek").text("주차 펼침");
        return;
    }

    // 현재 주차만 펼치기
    const $current = $(".course_week > li").eq(Number(CURRENT_WEEK) - 1);

    if ($current.length) {
        $current.addClass("active");

        $("html, body").scrollTop($current.offset().top - 100);
    }

    allFolded = false;
    $("#btnToggleWeek").text("주차 접음");
}

function toggleSortWeek() {

    const $btn = $("#btnSortWeek");
    const isAsc = $btn.find("i").hasClass("xi-sort-asc");

    const $list = $(".course_week");
    const $items = $list.children("li").get();

    $items.sort(function(a, b) {
        const weekA = Number($(a).data("week"));
        const weekB = Number($(b).data("week"));

        return isAsc
            ? weekB - weekA   // 내림차순으로 변경
            : weekA - weekB;  // 오름차순으로 변경
    });

    $.each($items, function(_, item) {
        $list.append(item);
    });

    // 아이콘 토글
    $btn.find("i")
        .toggleClass("xi-sort-asc xi-sort-desc");
}

//게시글 보기
function viewAtclLect(atclId, rgtrId, oyn, bbsId, bbsTycd, upMenuId, menuId, sbjctId ) {
	let extData = {
		atclId	: atclId,
		rgtrId 	: rgtrId,
		oyn 	: oyn,
		bbsId 	: bbsId,
		bbsTycd	: bbsTycd,
		upMenuId: upMenuId,
		menuId	: menuId,
		sbjctId	: sbjctId
	};
	document.location.href = "/bbs/bbsLect/bbsAtclView.do?encParams="+EPARAM+"&addParams="+UiComm.makeEncParams(extData);
}

function openAttandanceListPopup(lctrWknoSchdlId) {	
    const extData = { "lctrWknoSchdlId": lctrWknoSchdlId };
	dialog4 = UiDialog("attandanceListViewDialog", {
        title: "출결관리",
        width: 1450,
        height: 768,
        url: "/lctr/attandanceListView.do?encParams=" + EPARAM + "&lctrWknoSchdlId=" + lctrWknoSchdlId,
        autoresize: true
    });
	//const url = "/lctr/attandanceListView.do?lctrWknoSchdlId=" + lctrWknoSchdlId;
    //window.open(url,"attandanceListView","width=1024,height=768,scrollbars=yes,resizable=yes");
}

//paramGbn lctrId일 경우 강의테이블에서 조회하여 강의 보기, wnkoId일 경우 해당 주차의 첫번째 강의를 강의테이블에서 조회하여 강의 보기
function openLecturePopup(transferId, idTypeGbn) {
	/* const extData = { "transferId": transferId , "idTypeGbn": idTypeGbn};
	dialog5 = UiDialog("lectureViewDialog", {
        title: "강의보기",
        width: 1024,
        height: 768,
        url: "/lctr/lectureView.do?transferId=" + transferId + "&idTypeGbn=" + idTypeGbn,
        autoresize: false
    });	 */
	const url = "/lctr/lectureView.do?transferId=" + transferId + "&idTypeGbn=" + idTypeGbn;
    window.open(url,"lectureView","width=1024,height=768,scrollbars=yes,resizable=yes");
}

function lrnDataAdd(dataType, sbjctId, lctrWknoSchdlId) {
    const url = "/lrn/lrnDataAddPop.do?dataType="+dataType+"&sbjctId="+sbjctId+"&lctrWknoSchdlId=" + lctrWknoSchdlId;
    window.open(url,"lrnDataAddPop","width=1024,height=768,scrollbars=yes,resizable=yes");
}

function loadLctrPlandocPopView(sbjctId) {
	const extData = { "sbjctId": sbjctId };
	dialog1 = UiDialog("plandocDialog", {
        title: "강의계획서",
        width: 1300,
        height: 800,
        url: "/lctr/plandoc/profLctrPlandocPopView.do?encParams=" + EPARAM + "&addParams=" + UiComm.makeEncParams(extData),
        autoresize: true
    });
}

function loadLearnProgressPopView(sbjctId) {
	const extData = { "sbjctId": sbjctId };
	dialog2 = UiDialog("learningProgressDialog", {
        title: "학습진도관리",
        width: 1300,
        height: 800,
        url: "/stats/bySubjectLearningProgressListView.do?encParams=" + EPARAM + "&addParams=" + UiComm.makeEncParams(extData),
        autoresize: true
    });
}

function loadEvalWeightPopView(sbjctId) {
	const extData = { "sbjctId": sbjctId };
	dialog3 = UiDialog("evalWeightDialog", {
        title: "평가비중",
        width: 1300,
        height: 800,
        url: "/mrk/evalWeightList.do?encParams=" + EPARAM + "&addParams=" + UiComm.makeEncParams(extData),
        autoresize: true
    });
}

function loadContent(url) {
    fetch(url)
        .then(res => res.text())
        .then(html => {
            document.getElementById("contentPageArea").innerHTML = html;
        })
        .catch(err => console.error(err));
}
</script>
<body class="class ${uiex:getTheme()} "><!-- 컬러선택시 클래스변경 -->
<div style="display:none;" id="lecturePlanDoc"></div>
<div style="display:none;" id="loadLearnProgressPopView"></div>
<div style="display:none;" id="loadEvalWeightPopView"></div>
    <div id="wrap" class="main">

        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>
        <!-- //common header -->

        <!-- classroom -->
        <main class="common">

			<!-- gnb 강의실왼쪽메뉴-->
			<jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp">
				<jsp:param name="sbjctId" value="${sbjctId}"/>
			</jsp:include>
			<!-- //gnb -->

			<!-- content -->
			<div id="content" class="content-wrap common">
				<!-- class_sub_top -->
				<jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>
				<!-- //class_sub_top -->

				<!-- class_sub -->
				<div class="class_sub" id="contentPageArea">

					<!-- 강의실 상단 -->
					<div class="segment class-area">

						<!-- info-left -->
						<div class="info-left">
							<div class="class_info">
								<div class="class_tit">
                                    <p class="labels">
                                    	<c:choose>
										    <c:when test="${subjectVM.subjectVO.orgTycd eq 'LMSBASIC'}"><c:set var="styClass" value="uniA"/></c:when>
										    <c:when test="${subjectVM.subjectVO.orgTycd eq 'KNOU'}"><c:set var="styClass" value="uniB"/></c:when>
										    <c:when test="${subjectVM.subjectVO.orgTycd eq 'SMART'}"><c:set var="styClass" value="uniC"/></c:when>
										    <c:when test="${subjectVM.subjectVO.orgTycd eq 'CITT'}"><c:set var="styClass" value="uniD"/></c:when>
										    <c:when test="${subjectVM.subjectVO.orgTycd eq 'GDSC_BIZ'}"><c:set var="styClass" value="uniE"/></c:when>
										    <c:otherwise><c:set var="styClass" value="uniA"/></c:otherwise>
										</c:choose>
										
                                        <label class="label <c:out value='${styClass}'/>" style="width:150px">${subjectVM.subjectVO.orgnm}<%-- 기관명 --%></label>
                                    </p>
                                    <h2>${subjectVM.subjectVO.sbjctnm}<%-- 과목명 --%></h2>
                                </div>
                                <div class="classSection">
                                    <div class="cls_btn">
                                        <a href="javascript:void(0);" onclick='loadLctrPlandocPopView("${subjectVM.subjectVO.sbjctId}");' class="btn">강의 계획서</a>
                                        <a href="javascript:void(0);" onclick='loadLearnProgressPopView("${subjectVM.subjectVO.sbjctId}");' class="btn" class="btn">학습진도관리</a>
                                        <a href="javascript:void(0);" onclick='loadEvalWeightPopView("${subjectVM.subjectVO.sbjctId}");' class="btn" class="btn">평가 비중</a>
                                    </div>
                                </div>
                            </div>
                            <div class="info-cnt">
                                <div class="info_iconSet">
                                	<c:forEach var="item" items="${subjectVM.subjectLearingActvList}">
	                                    <a href="javascript:void(0);"
	                                    onclick='moveMenu(this, "/bbs/bbsLect/bbsAtclListView.do?bbsTycd=NTC&sbjctId=${subjectVM.subjectVO.sbjctId}", "ROOT", "PROLECT000002", "공지사항", "self");return false;' title="공지사항" class="info">
    									<span>공지</span><div class="num_txt">${item.ntcCnt}</div></a>
	                                    <a href="javascript:void(0);"
	                                    onclick='moveMenu(this, "/bbs/bbsLect/bbsAtclListView.do?bbsTycd=QNA&sbjctId=${subjectVM.subjectVO.sbjctId}", "ROOT", "PROLECT000004", "강의 Q&A", "self");return false;' title="QNA" class="info">
	                                    <span>Q&A</span><div class="num_txt point">${item.qnaCnt}</div></a>
	                                    <a href="javascript:void(0);"
	                                    onclick='moveMenu(this, "/bbs/bbsLect/bbsAtclListView.do?bbsTycd=1ON1&sbjctId=${subjectVM.subjectVO.sbjctId}", "ROOT", "PROLECT000005", "1:1 상담", "self");return false;' titls="1:1" class="info">
	                                    <span>1:1</span><div class="num_txt point">${item.oneononeCnt}</div></a>
	                                    <a href="javascript:void(0);" onclick='moveMenu(this, "/asmt2/profAsmtListView.do", "ROOT", "PROLECT000008", "과제", "self");return false;' title="과제" class="info">
			                			<span>과제</span><div class="num_txt">${item.asmtCnt}</div></a>
	                                    <a href="javascript:void(0);" onclick='moveMenu(this, "/forum2/forumLect/profForumListView.do", "ROOT", "PROLECT000011", "토론", "self");return false;' title="토론" class="info">
			                			<span>토론</span><div class="num_txt">${item.dscsCnt}</div></a>
			                			<a href="javascript:void(0);" onclick='moveMenu(this, "/smnr/profSmnrListView.do", "ROOT", "PROLECT000012", "세미나", "self");return false;' title="세미나" class="info">
	                                    <span>세미나</span><div class="num_txt">${item.smnrCnt}</div></a>
	                                    <a href="javascript:void(0);" onclick='moveMenu(this, "/quiz/profQuizListView.do", "ROOT", "PROLECT000009", "퀴즈", "self");return false;' title="퀴즈" class="info">
	                                    <span>퀴즈</span><div class="num_txt">${item.quizCnt}</div></a>
	                                    <a href="javascript:void(0);" onclick='moveMenu(this, "/srvy/profSrvyListView.do", "ROOT", "PROLECT000010", "설문", "self");return false;' title="설문" class="info">
	                                    <span>설문</span><div class="num_txt">${item.srvyCnt}</div></a>
	                                    <a href="javascript:void(0);" onclick='moveMenu(this, "/exam/profExamListView.do", "ROOT", "PROLECT000013", "시험", "self");return false;' title="시험" class="info">
	                                    <span>시험</span><div class="num_txt">${item.examCnt}</div></a>
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
					<div>
						<jsp:include page="${contentPage}" />
					</div>
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