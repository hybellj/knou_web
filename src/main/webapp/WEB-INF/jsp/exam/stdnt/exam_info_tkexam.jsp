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

        var stdntTkexamStat = '<c:out value="${stdntTkexamStat}" />';   // 응시여부
        var stdntTeamId     = '<c:out value="${stdntExamInfo.teamId}" />';   // 학습자의 팀 ID
        var stdntExamDtlId  = '<c:out value="${stdntExamInfo.examDtlId}" />';   // 학습자의 상세시험 ID

        /**
         * 목록에서 보낸 탭 타입 (버튼)
         * 시험 ID, 시험 방식을 받게 됨.
         * 시험 방식에 따라 보여지는 레이아웃이 다르게 됨.
         */
        var curTabType              = '<c:out value="${vo.tabType}" />';
        var curExamBscId            = '<c:out value="${vo.examBscId}" />';
        var curTkexamMthdCd         = '<c:out value="${vo.tkexamMthdCd}" />';
        var curByteamSubrexamUseyn  = '<c:out value="${vo.byteamSubrexamUseyn}" />';   // 팀 여부
        var hasSubSubject           = '<c:out value="${examVO.teamGrpSubsbjctUseyn}" />';  // 부 주제
        var absnceYn                = '<c:out value="${vo.absnceYn}" />';   // 결시여부
        var dsblYn                  = '<c:out value="${vo.dsblYn}" />';     // 장애여부
        var tkexamYn                = '<c:out value="${vo.tkexamYn}" />';   // 응시여부

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
         * 학습자 응시기록 관련 기능
         * 1. var tkexamHstryList :             tkexamHstry 모델 -> JS 배열로 변환
         * 2. stdntTkexamHstryListAppend :      학습자 시험 응시기록 HTML append
         *****************************************************************************/
        /* 1 */
        var tkexamHstryList = [
            <c:forEach var="tkexamInfo" items="${tkexamHstry}" varStatus="st">
            {
                lineNo          : '${fn:escapeXml(tkexamInfo.lineNo)}',
                examHstryGbnnm  : '${fn:escapeXml(tkexamInfo.examHstryGbnnm)}',
                tkexamSdttm     : '${fn:escapeXml(tkexamInfo.tkexamSdttm)}',
                tkexamEdttm     : '${fn:escapeXml(tkexamInfo.tkexamEdttm)}',
                tkexamDrtn      : '${fn:escapeXml(tkexamInfo.tkexamDrtn)}'
            }
            <c:if test="${!st.last}">,</c:if>
            </c:forEach>
        ];
        /* 2 */
        function stdntTkexamHstryListAppend() {
            var html = "";
            if (tkexamHstryList.length > 0) {
                tkexamHstryList.forEach(function(v, i) {
                    var tkexamSdttm;
                    if (v.tkexamSdttm != '') {
                        tkexamSdttm = dateFormat("date", v.tkexamSdttm);
                    } else {
                        tkexamSdttm = "-";
                    }
                    var tkexamEdttm;
                    if (v.tkexamEdttm != '') {
                        tkexamEdttm = dateFormat("date", v.tkexamEdttm);
                    } else {
                        tkexamEdttm = "-";
                    }
                    var tkexamDrtn;
                    if ((v.tkexamSdttm != '') && (v.tkexamEdttm != '')) {
                        tkexamDrtn = Math.floor(v.tkexamDrtn / 60) + "<spring:message code="exam.label.min.time" /> "    /* 분 */
                                    + (v.tkexamDrtn % 60) + "<spring:message code="exam.label.sec" />";  /* 초 */
                    } else {
                        tkexamDrtn = "-";
                    }
                    html += "<tr>";
                    html += "	<th><label>" + v.lineNo + "</label></th>";
                    html += "	<td><label>" + v.examHstryGbnnm + "</label></td>";
                    html += "	<td><label>" + tkexamSdttm + "</label></td>";
                    html += "	<td><label>" + tkexamEdttm + "</label></td>";
                    html += "	<td><label>" + tkexamDrtn + "</label></td>";
                    html += "</tr>";
                });
            }
            $("#tkexam-history").append(html);
        }

        /*****************************************************************************
         * 팝업 관련 기능
         * 1. stdntTeamMbrPop:      학습자 팀 구성원 조회 팝업
         * 2. tkexamPopup:          학습자 온라인 시험 시스템 시험 응시
         *****************************************************************************/
        /* 1 */
        function stdntTeamMbrPop() {
            dialog = UiDialog("dialog1", {
                title: "<spring:message code="exam.label.team.mbr" />", /* 팀 구성원*/
                width: 800,
                height: 500,
                url: "/exam/stdntTeamMbrPopup.do?teamId=" + stdntTeamId,
                autoresize: false
            });
        }
        /* 2 */
        function tkexamPopup() {
            // Todo: stdntExamDtlId 사용할 것...
            UiComm.showMessage("온라인 시험 시스템 연동시 작성 예정입니다.", "error");
        }

		$(document).ready(function() {
            if (hasSubSubject == 'Y') {
                examSubAsmtListAppend();
            }

            /**
             *  1 -> 시험 시작 전
             *  2 -> 시험 진행 중
             *  3 -> 시험 마감
             */
            switch (stdntTkexamStat) {
                case "1":
                    break;
                case "2":
                    stdntTkexamHstryListAppend();
                    break;
                case "3":
                    break;
            }

            console.log("dtl Id? " + stdntExamDtlId);
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
                                <li class="mw120 select" style="pointer-events: none;">
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
                                    <li class="mw120">
                                        <a onclick="stdntExamViewMv(3)">
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
                                <spring:message code="exam.label.info.tkexam" /><!-- 시험정보 및 응시 -->
                            </h3>
                            <div class="right-area">
                                <c:if test="${vo.byteamSubrexamUseyn eq 'Y'}">
                                    <button type="button" class="btn basic" onclick="stdntTeamMbrPop()">
                                        <spring:message code="exam.label.team.mbr" /><!-- 팀 구성원 -->
                                    </button>
                                </c:if>
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
                                                            <textarea class="form-control wmax" rows="4" id="contTextarea" readonly>${examVO.examCts}</textarea>
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
                                                        <th><spring:message code='exam.label.absnce.aply.rslt' /></th><!-- 결시신청 및 결과 -->
                                                        <td colspan="3">
                                                            <div class = "item_list">
                                                                <button type="button" class = "btn basic" onclick="stdntExamViewMv(3)">
                                                                    <spring:message code='exam.label.absnce.aply.rslt' /><!-- 결시신청 및 결과 -->
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
                        <!-- 시험정보 및 응시 상단영역 -->
                        <div class="board_top">
                            <h4 class="sub-title">
                                <spring:message code='exam.label.exam' /> <!-- 시험 -->
                                <spring:message code='exam.button.stare.start' /><!-- 응시 -->
                            </h4>
                            <div class="right-area">
                            </div>
                        </div>
                        <c:choose>
                            <c:when test="${stdntTkexamStat == 1}">
                                <%-- case1. 시험 시작 전 레이아웃 --%>
                                <div class="msg-box">
                                    <p class="txt"><strong><spring:message code='exam.label.guide' /><!-- 안내 --> : </strong><spring:message code='exam.guide.msg1' /></p><!-- 시험 시작 전입니다. -->
                                </div>
                            </c:when>
                            <c:when test="${stdntTkexamStat == 2}">
                                <%-- case2. 시험 시작 후 레이아웃 --%>
                                <c:choose>
                                    <c:when test="${vo.tkexamYn eq 'N'}">
                                        <div class="msg-box">
                                            <p class="txt"><strong><spring:message code='exam.label.guide' /><!-- 안내 --> : </strong>
                                                <spring:message code='exam.guide.msg2' /> <!-- 시험 응시 전입니다. -->
                                                <spring:message code='exam.guide.msg3' /><!-- 시험을 응시하시기 바랍니다. -->
                                            </p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                    </c:otherwise>
                                </c:choose>
                                <div class="table-wrap">
                                    <table class="table-type1">
                                        <colgroup>
                                            <col class="width-5per">
                                            <col>
                                            <col>
                                            <col>
                                            <col>
                                        </colgroup>
                                        <thead>
                                            <tr>
                                                <th><spring:message code='exam.label.line.no' /></th><!-- 번호 -->
                                                <th><spring:message code='exam.label.hstr.type' /></th><!-- 이력 구분 -->
                                                <th><spring:message code='exam.label.tkexam.strt' /></th><!-- 시험 시작 -->
                                                <th><spring:message code='exam.label.tkexam.end' /></th><!-- 시험 종료 -->
                                                <th><spring:message code='exam.label.tkexam.time' /></th><!-- 응시 시간 -->
                                            </tr>
                                        </thead>
                                        <tbody id="tkexam-history">
                                        </tbody>
                                    </table>
                                </div>
                                <c:choose>
                                    <c:when test="${vo.tkexamYn eq 'N'}">
                                        <div class="btns">
                                            <button type="button" class="btn type1" onclick="tkexamPopup()">
                                                <spring:message code='exam.button.stare' /><!-- 응시하기 -->
                                            </button>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:when test="${stdntTkexamStat == 3}">
                                <%-- case3. 시험 마감 후 레이아웃 --%>
                                <c:choose>
                                    <c:when test="${vo.tkexamYn eq 'N'}">
                                        <div class="msg-box">
                                            <p class="txt"><strong><spring:message code='exam.label.guide' /><!-- 안내 --> : </strong><spring:message code='exam.guide.msg4' /><!-- 해당 시험을 미응시 했습니다. --></p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="table-wrap">
                                            <table class="table-type5">
                                                <colgroup>
                                                    <col class="width-15per">
                                                    <col>
                                                    <col class="width-15per">
                                                    <col>
                                                </colgroup>
                                                <thead>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <th><spring:message code='exam.label.stare.dttm' /></th><!-- 응시일시 -->
                                                        <td colspan="3"><uiex:formatDate value="${tkexamRslt.tkexamSdttm}" type="datetime2"/></td>
                                                    </tr>
                                                    <tr>
                                                        <th><spring:message code='exam.label.tkexam.time' /></th><!-- 응시 시간 -->
                                                        <td colspan="3">${tkexamRslt.tkexamMnts} <spring:message code='exam.label.stare.min' /></td><!-- 분 -->
                                                    </tr>
                                                    <tr>
                                                        <th><spring:message code='exam.label.eval.score' /></th><!-- 평가점수 -->
                                                        <c:choose>
                                                            <c:when test="${examVO.mrkOyn eq 'N'}">
                                                                <td colspan="3"><spring:message code='exam.guide.msg5' /></td><!-- 성적공개가 되지 않는 시험입니다. -->
                                                            </c:when>
                                                            <c:otherwise>
                                                                <td colspan="3">${tkexamRslt.totScr} <spring:message code='exam.label.score.point' /></td><!-- 점 -->
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                        </c:choose>
                    </div>
                </div>
            </div>
            <!-- //content -->
        </main>
        <!-- //classroom-->
    </div>
</body>
</html>
