<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="module" value="table,editor,fileuploader"/>
	</jsp:include>

	<script type="text/javascript">
        /* Tabulator 공통 페이징 */
        var PAGE_INDEX = 1;
        var LIST_SCALE = 10;
        var absnceInfoListTable = null;

        /**
         * 목록에서 보낸 탭 타입 (버튼)
         * 시험 ID, 시험 방식을 받게 됨.
         * 시험 방식에 따라 보여지는 레이아웃이 다르게 됨.
         */
        var curTabType              = '<c:out value="${vo.tabType}" />';
        var curExamBscId           = '<c:out value="${vo.examBscId}" />';
        var curTkexamMthdCd        = '<c:out value="${vo.tkexamMthdCd}" />';
        var curByteamSubrexamUseyn = '<c:out value="${vo.byteamSubrexamUseyn}" />';   // 팀 여부
        var hasSubSubject          = '<c:out value="${examVO.teamGrpSubsbjctUseyn}" />';  // 부 주제
        var absnceYn               = '<c:out value="${vo.absnceYn}" />';   // 결시여부
        var dsblYn                 = '<c:out value="${vo.dsblYn}" />';     // 장애여부

        /*****************************************************************************
         * tabulator 관련 기능
         * 1. initAbsnceInfoListTable :     컬럼 정의
         * 2. createAbsnceInfoListHtml :    각 컬럼에 들어갈 데이터 세팅 및 요소 생성
         * 3. loadAbsnceInfoList :          컬럼에 들어갈 데이터 ajax 호출
         * 4. changeInfoListScale :         페이지 row수 세팅
         *****************************************************************************/
        /* 1 */
        function initAbsnceInfoListTable() {
            if (absnceInfoListTable) return;
            var absnceInfoColumns = [
                {title:"No", field:"lineNo", headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:50},
                {title:"<spring:message code='exam.label.crs' />", field:"sbjctnm", headerHozAlign:"center", hozAlign:"center", width:0, minWidth:140},                         /* 과목 */
                {title:"<spring:message code='exam.label.decls.cls' />", field:"dvclaNcknm", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},              /* 분반 */
                {title:"<spring:message code='exam.label.stare.type' />", field:"examGbnnm", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},              /* 구분 */
                {title:"<spring:message code='exam.label.method' />", field:"tkexamMthdNm", headerHozAlign:"center", hozAlign:"center", width:100,  minWidth:100},              /* 방식 */
                {title:"<spring:message code='exam.label.applicate.dttm' />",field:"regDttm", headerHozAlign:"center", hozAlign:"center", width:140,  minWidth:140},            /* 신청일시 */
                {title:"<spring:message code='exam.label.process.status' />", field:"absnceAplyStsnm", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},    /* 처리상태 */
                {title:"<spring:message code='exam.label.process.dttm' />", field:"aprvdttm", headerHozAlign:"center", hozAlign:"center", width:140, minWidth:140},             /* 처리일시 */
                {title:"<spring:message code='exam.label.manage' />", field:"manage", headerHozAlign:"center", hozAlign:"center", width:180, minWidth:180}                      /* 관리 */
            ];
            absnceInfoListTable = UiTable("examAbsnceList", {
                lang: "ko",
                pageFunc: loadAbsnceInfoList,
                columns: absnceInfoColumns
            });
        }
        /* 2 */
        function createAbsnceInfoListHtml(list) {
            // 승인(3) 이력이 있는 examBscId 사전 수집
            var approvedExamBscIds = new Set();
            list.forEach(function(v) {
                if (v.absnceAplyStscd == 3) {
                    approvedExamBscIds.add(v.examBscId);
                }
            });

            let dataList = [];
            if (list.length == 0) {
                return dataList;
            } else {
                list.forEach(function(v, i) {
                    // 분반
                    var dvclaNcknm;
                    if (v.dvclaNcknm != '' && v.dvclaNcknm != null) {
                        dvclaNcknm = v.dvclaNcknm;
                    } else {
                        dvclaNcknm = '-';
                    }
                    // 신청일시 (등록일시)
                    var regDttm;
                    if (v.regDttm != '' && v.regDttm != null) {
                        regDttm = dateFormat("date", v.regDttm);
                    } else {
                        regDttm = "-";
                    }
                    // 처리일시 (승인일시)
                    var aprvdttm;
                    if (v.aprvdttm != '' && v.aprvdttm != null) {
                        aprvdttm = dateFormat("date", v.aprvdttm);
                    } else {
                        aprvdttm = "-";
                    }
                    // 처리상태
                    var absnceAplyStsnm;
                    if (v.absnceAplyStscd == 4) {
                        absnceAplyStsnm = "<a class='fcBlue'>" + v.absnceAplyStsnm + "</a>"
                    } else {
                        absnceAplyStsnm = v.absnceAplyStsnm;
                    }

                    // 관리 버튼
                    var manageBtns = "";
                    manageBtns += "<div style='display:flex;align-items:center;gap:0 3px;'>";
                    /* 3 = 승인, 4 = 거절 */
                    if (v.absnceAplyStscd == 3) {
                        manageBtns += "<a href='javascript:examAbsnceRsltPopup(\"" + v.examBscId + "\", \"" + v.userId + "\")' class='btn basic small'>처리내역</a>";
                    } else if (v.absnceAplyStscd == 4 && !approvedExamBscIds.has(v.examBscId)) {
                        // Todo : 결시 신청 기간내에만 버튼 요소 생성되도록 로직을 수정해야 한다...
                        manageBtns += "<a href='javascript:examAbsncePopup(\"" + v.examBscId + "\", \"" + v.userId + "\", \"" + v.absnceAplyStscd + "\")' class='btn basic small'>재신청</a>";
                    }
                    manageBtns += "&nbsp;</div>"

                    dataList.push({
                        lineNo:             v.lineNo
                        , sbjctnm:          v.sbjctnm
                        , dvclaNcknm:       dvclaNcknm
                        , examGbnnm:        v.examGbnnm
                        , tkexamMthdNm:     v.tkexamMthdNm
                        , regDttm:          regDttm
                        , absnceAplyStsnm:  absnceAplyStsnm
                        , aprvdttm:         aprvdttm
                        , manage:           manageBtns
                        , examBscId:        v.examBscId
                        , examAbsnceId:     v.examAbsnceId
                    });
                });
            }
            return dataList;
        }
        /* 3 */
        function loadAbsnceInfoList(pageIndex) {
            initAbsnceInfoListTable();
            PAGE_INDEX = pageIndex || PAGE_INDEX;
            UiComm.showLoading(true);
            $.ajax({
                url: "/exam/stdntAbsncePaging.do",
                type: "GET",
                data: {
                    encParams   : EPARAM,
                    pageIndex   : PAGE_INDEX,
                    listScale   : LIST_SCALE
                },
                dataType: "json",
                success: function(data) {
                    if (data.result > 0) {
                        var returnList = data.returnList || [];
                        var dataList   = createAbsnceInfoListHtml(returnList);
                        absnceInfoListTable.clearData();
                        absnceInfoListTable.replaceData(dataList);
                        absnceInfoListTable.setPageInfo(data.pageInfo);
                    } else {
                        alert(data.message);
                    }
                },
                error: function() {
                    UiComm.showMessage("<spring:message code='exam.error.list' />", "error"); /* 리스트 조회 중 에러가 발생하였습니다. */
                },
                complete: function() {
                    UiComm.showLoading(false);
                }
            });
        }
        /* 4 */
        function changeInfoListScale(scale) {
            LIST_SCALE = scale;
            loadAbsnceInfoList(1);
        }

        /*****************************************************************************
         * 팀 시험일 경우 생성되는 요소 제어 기능
         * 1. var examDtlInfoList :     examDtlInfoVO 모델 를 JS 배열로 변환
         * 2. examSubAsmtListAppend :   팀 시험 부주제 목록 HTML append
         *****************************************************************************/
        /* 1 */
		var examDtlInfoList = [
			<c:forEach var="dtlInfo" items="${examDtlInfoVO}" varStatus="st">
                {
                    teamGrpId    : '${fn:escapeXml(dtlInfo.teamGrpId)}',
                    teamGrpnm    : '${fn:escapeXml(dtlInfo.teamGrpnm)}',
                    teamId      : '${fn:escapeXml(dtlInfo.teamId)}',
                    teamnm      : '${fn:escapeXml(dtlInfo.teamnm)}',
                    ldrnm       : '${fn:escapeXml(dtlInfo.ldrnm)}',
                    examTtl     : '${fn:escapeXml(dtlInfo.examTtl)}',
                    examCts     : '${fn:escapeXml(dtlInfo.examCts)}',
                    teamMbrTot  : '${fn:escapeXml(dtlInfo.teamMbrTot)}'
                }
                <c:if test="${!st.last}">,</c:if>
			</c:forEach>
		];
		/* 2 */
		function examSubAsmtListAppend() {
			var html = "";
			if (examDtlInfoList.length > 0) {
				examDtlInfoList.forEach(function(v, i) {
                    html += "<tr>";
                    html += "	<th rowspan='3' class='group-header'><label>" + v.teamGrpnm + "</label></th>";
                    html += "	<th><label><spring:message code='exam.label.team.grp' /> <spring:message code='exam.label.team.members' /></label></th>";   /* 팀 그룹 */ /* 구성원 */
                    html += "	<td>" + v.ldrnm + " <spring:message code='exam.label.and' /> " + (v.teamMbrTot - 1) + "<spring:message code='exam.label.stdnt' /></td>";    /* 외 */ /* 명 */
                    html += "</tr>";
                    html += "<tr>";
                    html += "	<th><label><spring:message code='exam.label.sub.tpc' /></label></th>";  /* 부 주제 */
                    html += "	<td>" + UiComm.escapeHtml(v.examTtl) + "</td>";
                    html += "</tr>";
                    html += "<tr>";
                    html += "	<th><label><spring:message code='exam.label.cts' /></label></th>";  /* 내용 */
                    html += "	<td><pre>" + $("<div>").html(v.examCts).text() + "</pre></td>";
                    html += "</tr>";
				});
			}
			$("#examSubsbjctbody").append(html);
		}

        /*****************************************************************************
         * 팝업 관련 기능
         * 1. examAbsncePopup:      학습자 결시신청 팝업
         * 2. examAbsnceRsltPop:    학습자 결시신청 결과 팝업
         *****************************************************************************/
        /* 1 */
        function examAbsncePopup(examBscId, userId, absnceAplyStscd) {
            var data = "examBscId="+ examBscId + "&userId=" + userId;
            var title;
            if (absnceAplyStscd == 4) {
                title = "<spring:message code='exam.label.absnce' /> <spring:message code='exam.label.rapplicate' />"; /* 결시 */ /* 재신청 */
            } else {
                title = "<spring:message code='exam.label.absnce' /> <spring:message code='exam.label.applicate' />";   /* 결시 */ /* 신청 */
            }

            dialog = UiDialog("dialog1", {
                title: title,
                width: 1000,
                height: 1000,
                url: "/exam/stdntAbsnceApplyPopup.do?"+data,
                autoresize: true
            });
        }
        /* 2 */
        function examAbsnceRsltPopup(examBscId, userId) {
            var data = "examBscId="+ examBscId + "&userId=" + userId;

            dialog = UiDialog("dialog1", {
                title: "<spring:message code='exam.label.absnce.aply' /> <spring:message code='exam.label.rslt' />", /* 결시신청 및 결과 */
                width: 800,
                height: 1000,
                url: "/exam/stdntAbsnceRsltPopup.do?"+data,
                autoresize: false
            });
        }

		$(document).ready(function() {
            if (hasSubSubject == 'Y') {
                examSubAsmtListAppend();
            }
            loadAbsnceInfoList();
		});
	</script>
</head>

<body class="class ${uiex:getTheme()} "><!-- 컬러선택시 클래스변경 -->
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
				<!-- class_sub_top -->
				<jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>
				<!-- //class_sub_top -->

                <div class="class_sub">
                    <!-- 강의실 상단 -->
                    <jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>
                    <!-- 콘텐츠 영역 -->
                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">
                                <spring:message code="exam.label.exam" /><!-- 시험 -->
                            </h2>
                        </div>
                        <!-- 콘텐츠 상단 탭 버튼 영역 -->
                        <div class="listTab">
                            <ul>
                                <!-- 실시간/퀴즈 에 따라 버튼 동적 생성 -->
                                <li class="mw120">
                                    <a onclick="stdntExamViewMv(1)">
                                        <spring:message code="exam.label.info.tkexam" /><!-- 시험정보 및 응시 -->
                                    </a>
                                </li>
                                <c:if test="${vo.tkexamMthdCd eq 'RLTM' and (examVO.examGbncd eq 'EXAM_LST'
                                                                            or examVO.examGbncd eq 'EXAM_LST_TEAM'
                                                                            or examVO.examGbncd eq 'EXAM_MID'
                                                                            or examVO.examGbncd eq 'EXAM_MID_TEAM')}">
                                    <c:if test="${vo.absnceYn eq 'Y'}">
                                        <li class="mw120">
                                            <a onclick="stdntExamViewMv(2)">
                                                <spring:message code='exam.label.exam' /> <!-- 시험 -->
                                                <spring:message code='exam.label.sub' /><!-- 대체 -->
                                            </a>
                                        </li>
                                    </c:if>
                                    <li class="mw120 select" style="pointer-events: none;">
                                        <a onclick="stdntExamViewMv(3)" >
                                            <spring:message code="exam.label.absnce.aply.rslt" /><!-- 결시신청 및 결과 -->
                                        </a>
                                    </li>
                                    <c:if test="${vo.dsblYn eq 'Y'}">
                                        <li class="mw120">
                                            <a onclick="stdntExamViewMv(4)">
                                                <spring:message code='exam.label.dsbl' />/<!-- 장애인 -->
                                                <spring:message code='exam.label.snrs' /> <!-- 고령자 -->
                                                <spring:message code='exam.label.sprt' /><!-- 지원 -->
                                            </a>
                                        </li>
                                    </c:if>
                                </c:if>
                            </ul>
                        </div>
                        <!-- 고정 영역 -->
                        <div class="board_top">
                            <i class="icon-svg-openbook"></i>
                            <h3 class="board-title">
                                <spring:message code="exam.label.absnce.aply.rslt" /><!-- 결시신청 및 결과 -->
                            </h3>
                            <div class="right-area">
                                <button type="button" class="btn basic" onclick="stdntExamViewMv(8)">
                                    <spring:message code='exam.button.list' /><!-- 목록 -->
                                </button>
                            </div>
                        </div>
                        <!-- [공통] 시험 정보 영역 -->
                        <!-- accordion -->
                        <div class="elements_wrap">
                            <ul class="accordion">
                                <spring:message code="exam.common.yes" var="yes" /><!-- 예 -->
                                <spring:message code="exam.common.no" var="no" /><!-- 아니오 -->
                                <li class=""><!-- 클릭시 active 추가 -->
                                    <div class="title-wrap">
                                        <a class="title" href="#">
                                            <div class="lecture_tit">
                                                <label class="label s_test mr5">${examVO.examGbnnm}</label><strong>${examVO.examTtl}</strong>
                                                <p class="desc">
                                                    <span><strong class="fcBlack">${examVO.tkexamMthdNm}</strong></span>
                                                    <span><spring:message code='exam.button.stare.start' /> <spring:message code='exam.label.period' /> :<strong><uiex:formatDate value="${examVO.examPsblSdttm}" type="datetime2"/> ~ <uiex:formatDate value="${examVO.examPsblEdttm}" type="datetime2"/></strong></span> <!-- 응시 --><!-- 기간 -->
                                                    <span><spring:message code="exam.label.score.aply.y" /><!-- 성적반영 --> :<strong>${examVO.mrkRfltyn eq 'Y' ? yes : no }</strong></span>
                                                    <span><spring:message code="exam.label.score.open.y" /><!-- 성적공개 --> :<strong>${examVO.mrkOyn eq 'Y' ? yes : no }</strong></span>
                                                </p>
                                            </div>
                                            <i class="arrow xi-angle-down"></i>
                                        </a>
                                    </div>
                                    <div class="cont">
                                        <table class="table-type5">
                                            <colgroup>
                                                <col class="width-15per" />
                                                <col class="" />
                                                <col class="width-15per" />
                                                <col class="" />
                                            </colgroup>
                                            <tbody>
                                                <tr>
                                                    <th><spring:message code='exam.label.exam.stare.type' /></th><!-- 시험 구분 -->
                                                    <td colspan="3">${examVO.examGbnnm}</td>
                                                </tr>
                                                <tr>
                                                    <th><spring:message code='exam.label.exam.type' /></th><!-- 시험 유형 -->
                                                    <td colspan="3">${examVO.tkexamMthdNm}</td>
                                                </tr>
                                                <tr>
                                                    <th><spring:message code='exam.label.exam' /> <spring:message code='exam.label.cts' /></th><!-- 시험 --><!-- 내용 -->
                                                    <td colspan="3">
                                                        <div class="tb_content">
                                                            ${examVO.examCts}
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th><spring:message code='exam.label.exam' /> <spring:message code='exam.label.dttm' /></th><!-- 시험 --><!-- 일시 -->
                                                    <td colspan="3"><uiex:formatDate value="${examVO.examPsblSdttm}" type="datetime2"/> ~ <uiex:formatDate value="${examVO.examPsblEdttm}" type="datetime2"/></td>
                                                </tr>
                                                <tr>
                                                    <th><spring:message code='exam.label.exam' /> <spring:message code='exam.label.time' /></th><!-- 시험 --><!-- 시간 -->
                                                    <td colspan="3">${examVO.examMnts} <spring:message code='exam.label.min.time' /></td><!-- 분 -->
                                                </tr>
                                                <tr>
                                                    <th><spring:message code='exam.label.score.aply.y' /></th><!-- 성적 반영 -->
                                                    <td>${examVO.mrkRfltyn eq 'Y' ? yes : no}</td>
                                                    <th><spring:message code='exam.label.grade.score' /> <spring:message code='exam.label.score.aply.rate' /></th><!-- 성적 --><!-- 반영비율 -->
                                                    <td>${examVO.mrkRfltyn eq 'N' ? '-' : examVO.mrkRfltrt} %</td>
                                                </tr>
                                                <tr>
                                                    <th><spring:message code='exam.label.score.open.y' /></th><!-- 성적 공개 -->
                                                    <td colspan="3">${examVO.mrkOyn eq 'Y' ? yes : no}</td>
                                                </tr>
                                                <tr>
                                                    <th><spring:message code='exam.label.paper.open' /></th><!-- 시험지 공개 -->
                                                    <td colspan="3">${examVO.exampprOyn eq 'Y' ? yes : no}</td>
                                                </tr>
                                                <tr>
                                                    <th><spring:message code='exam.label.team' /> <spring:message code='exam.label.exam' /></th><!-- 팀 --><!-- 시험 -->
                                                    <td colspan="3" class="in_table">
                                                        <c:choose>
                                                            <c:when test="${examVO.byteamSubrexamUseyn eq 'Y' and not empty examDtlInfoVO}">
                                                                <div class="view_con">
                                                                    ${yes}<br>
                                                                    <spring:message code='exam.label.team.grp' /> : ${examDtlInfoVO[0].teamGrpnm}<br><!-- 팀 그룹 -->
                                                                    <spring:message code='exam.label.team.by' /> <spring:message code='exam.label.sub.tpc' /> <spring:message code='exam.label.use.yn' /> : ${examVO.teamGrpSubsbjctUseyn eq 'Y' ? yes : no}<!-- 팀별 --><!-- 부 주제 --><!-- 사용여부 -->
                                                                </div>
                                                                <!-- 팀별 부 주제 사용여부 -->
                                                                <c:if test="${examVO.teamGrpSubsbjctUseyn eq 'Y'}">
                                                                    <div class="table-wrap mb30">
                                                                        <table class="table-type5 in-table">
                                                                            <colgroup>
                                                                                <col class="width-5per" />
                                                                                <col class="width-15per" />
                                                                                <col class="" />
                                                                            </colgroup>
                                                                            <tbody id="examSubsbjctbody">
                                                                            </tbody>
                                                                        </table>
                                                                    </div>
                                                                </c:if>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="view_con">${no}</div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                                <c:if test="${vo.tkexamMthdCd eq 'RLTM' and (examVO.examGbncd eq 'EXAM_LST'
                                                                                            or examVO.examGbncd eq 'EXAM_LST_TEAM'
                                                                                            or examVO.examGbncd eq 'EXAM_MID'
                                                                                            or examVO.examGbncd eq 'EXAM_MID_TEAM')}">
                                                    <c:if test="${vo.absnceYn eq 'Y'}">
                                                        <tr>
                                                            <th><spring:message code='exam.label.exam' /> <spring:message code='exam.label.sub' /></th><!-- 시험 --><!-- 대체 -->
                                                            <td colspan="3">
                                                                <div class = "item_list">
                                                                        ${examVO.examSbstTynm}
                                                                    <button type="button" class = "btn basic" onclick="stdntExamViewMv(2)">
                                                                        <spring:message code='exam.label.exam' /> <!-- 시험 -->
                                                                        <spring:message code='exam.label.sub' /><!-- 대체 -->
                                                                    </button>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </c:if>
                                                    <tr>
                                                        <th><spring:message code="exam.label.absnce.aply.rslt" /></th><!-- 결시신청 및 결과 -->
                                                        <td colspan="3">
                                                            <div class = "item_list">
                                                                <button type="button" class = "btn basic" onclick="stdntExamViewMv(3)" style = "pointer-events: none;">
                                                                    <spring:message code="exam.label.absnce.aply.rslt" /><!-- 결시신청 및 결과 -->
                                                                </button>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <c:if test="${vo.dsblYn eq 'Y'}">
                                                        <tr>
                                                            <th>
                                                                <spring:message code='exam.label.dsbl' />/<!-- 장애인 -->
                                                                <spring:message code='exam.label.snrs' /> <!-- 고령자 -->
                                                                <spring:message code='exam.label.sprt' /><!-- 지원 -->
                                                            </th>
                                                            <td colspan="3">
                                                                <div class = "item_list">
                                                                    <button type="button" class = "btn basic" onclick="stdntExamViewMv(4)">
                                                                        <spring:message code='exam.label.dsbl' />/<!-- 장애인 -->
                                                                        <spring:message code='exam.label.snrs' /> <!-- 고령자 -->
                                                                        <spring:message code='exam.label.sprt' /><!-- 지원 -->
                                                                    </button>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </c:if>
                                                </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <!-- 결시신청 및 결과 상단영역 -->
                        <div>
                            <div class="board_top">
                                <h4 class="sub-title">
                                    <spring:message code="exam.label.absnce.aply.rslt" /><!-- 결시신청 및 결과 -->
                                </h4>
                                <div class="right-area">
                                    <a href="javascript:examAbsncePopup('${vo.examBscId}', '${vo.userId}', 1)" class="btn type2">
                                        <spring:message code="exam.label.absnce.aply" /><!-- 결시신청 -->
                                    </a>
                                    <uiex:listScale func="changeInfoListScale" value="10" />
                                </div>
                            </div>
                            <div id="absnceListArea">
                                <div id="examAbsnceList"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- //content -->
        </main>
        <!-- //classroom-->
    </div>
</body>
</html>
