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

        /**
         * 목록에서 보낸 탭 타입 (버튼)
         * 시험 ID, 시험 방식을 받게 됨.
         * 시험 방식에 따라 보여지는 레이아웃이 다르게 됨.
         */
        var curTabType      = '<c:out value="${vo.tabType}" />';
        var curExamBscId    = '<c:out value="${vo.examBscId}" />';
        var curTkexamMthdCd = '<c:out value="${vo.tkexamMthdCd}" />';

        var hasSubSubject = '${examVO.teamGrpSubsbjctUseyn}';        // 부 주제
        var sbstInfoListTable = null;
        var sbstUserInfoListTable = null;
        var examQstnsCmptnyn = null;    // 출제여부 (null: 컬럼 미표시, 'Y'/'N': 컬럼 표시)

        /*****************************************************************************
         * tabulator 관련 기능
         * 1. initSbstInfoListTable :        컬럼 정의 (시험 대체)
         * 2. createSbstInfoListHtml:       각 컬럼에 들어갈 데이터 세팅 및 버튼 요소 생성 (시험 대체)
         * 3. loadSbstInfoList :            컬럼에 들어갈 데이터 ajax 호출 (시험 대체)
         * 4. initSbstUserInfoListTable :   컬럼 정의 (시험 대체 대상자)
         * 5. createSbstUserInfoListHtml:   각 컬럼에 들어갈 데이터 세팅 및 버튼 요소 생성 (시험 대체 대상자)
         * 6. loadSbstUserInfoList :        컬럼에 들어갈 데이터 ajax 호출 (시험 대체 대상자)
         *****************************************************************************/
        /* 1 */
        function initSbstInfoListTable() {
            if (sbstInfoListTable) return;
            var examInfoColumns = [
                {title:"No", field:"lineNo", headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:50},
                {title:"<spring:message code='exam.label.exam' /><spring:message code='exam.label.sub' />", field:"examEvlSbstnm", headerHozAlign:"center", hozAlign:"center", width:120, minWidth:120},    /* 시험 */ /* 대체 */
                {title:"<spring:message code='exam.label.title' />", field:"ttl", headerHozAlign:"center", hozAlign:"left", width:0, minWidth:300},                 /* 제목 */
                {title:"<spring:message code='exam.label.period' />", field:"duringDate", headerHozAlign:"center", hozAlign:"center", width:0, minWidth:300},       /* 기간 */
                {title:"<spring:message code='exam.label.eval.ctgr' />", field:"evl", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},         /* 평가 방법 */
                {title:"<spring:message code='exam.button.reg' /><spring:message code='exam.label.dttm' />", field:"regDttm", headerHozAlign:"center", hozAlign:"center", width:140,  minWidth:140},        /* 등록 */ /* 일시 */
                {title:"<spring:message code='exam.label.exam.submit.yn' />", field:"qstnsCmptyn", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100, visible:false}                      /* 출제여부 */
            ];
            sbstInfoListTable = UiTable("sbstList", {
                lang: "ko",
                pageFunc: loadSbstInfoList,
                columns: examInfoColumns
            });
        }
        /* 2 */
        function createSbstInfoListHtml(list) {
            let dataList = [];
            if (list.length == 0) {
                return dataList;
            } else {
                list.forEach(function(v, i) {
                    // 제목 (과제|퀴즈)
                    var ttl;
                    // 기간 (과제|퀴즈)
                    var duringDate;
                    // 평가 방법 (과제|퀴즈)
                    var evl;
                    if (v.gbn == "ASMT") {
                        ttl = "<a href='javascript:sbstViewMv(\"" + v.examBscId + "\",\"" + v.gbn + "\")' class='header header-icon link'>"
                            + escapeHtml(v.asmtTtl) + "</a>";
                        duringDate = dateFormat("date", v.asmtSbmsnSdttm) + " ~ " + dateFormat("date", v.asmtSbmsnEdttm);
                        evl = v.evlScrTynm;
                    } else {
                        ttl = "<a href='javascript:sbstViewMv(\"" + v.examBscId + "\",\"" + v.gbn + "\")' class='header header-icon link'>"
                            + escapeHtml(v.examTtl) + "</a>";
                        duringDate = dateFormat("date", v.examPsblSdttm) + " ~ " + dateFormat("date", v.examPsblEdttm);
                        evl = "<spring:message code='exam.label.score' /> <spring:message code='exam.tab.eval' />"; /* 점수 */ /* 평가 */
                    }
                    var regDttm = dateFormat("date", v.regDttm);
                    var qstnsCmptyn = v.examQstnsCmptnyn === 'Y'
                        ? "<a><spring:message code='exam.label.qstn.submit.y' /></a>"                   /* 출제완료 */
                        : "<a class='fcRed'><spring:message code='exam.label.qstn.temp.save' /></a>";   /* 임시저장 */

                    dataList.push({
                        lineNo:         v.lineNo
                        , examEvlSbstnm:v.examEvlSbstnm
                        , ttl:          ttl
                        , duringDate:   duringDate
                        , evl:          evl
                        , regDttm:      regDttm
                        , qstnsCmptyn:  qstnsCmptyn
                        , gbn:          v.gbn
                        , asmtId:       v.asmtId
                        , examBscId:    v.examBscId
                    });
                });
            }
            return dataList;
        }
        /* 3 */
        function loadSbstInfoList(pageIndex) {
            initSbstInfoListTable();
            PAGE_INDEX = pageIndex || PAGE_INDEX;
            UiComm.showLoading(true);
            $.ajax({
                url: "/exam/examSbstPaging.do",
                type: "GET",
                data: {
                    examBscId   : curExamBscId,
                    pageIndex   : PAGE_INDEX,
                    listScale   : LIST_SCALE
                },
                dataType: "json",
                success: function(data) {
                    if (data.result > 0) {
                        var returnList = data.returnList || [];
                        examQstnsCmptnyn = returnList.length > 0 ? (returnList[0].examQstnsCmptnyn || null) : null;
                        if (examQstnsCmptnyn !== null) {
                            sbstInfoListTable.showColumn("qstnsCmptyn");
                        } else {
                            sbstInfoListTable.hideColumn("qstnsCmptyn");
                        }
                        var dataList   = createSbstInfoListHtml(returnList);
                        sbstInfoListTable.clearData();
                        sbstInfoListTable.replaceData(dataList);
                        sbstInfoListTable.setPageInfo(data.pageInfo);
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
        function initSbstUserInfoListTable() {
            if (sbstUserInfoListTable) return;
            var examInfoColumns =  [
                {title:"No", field:"lineNo", headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:50},
                {title:"<spring:message code="exam.label.dept" />", field:"deptnm", headerHozAlign:"center", hozAlign:"center", width:140, minWidth:140},               /* 학과 */
                {title:"<spring:message code='exam.label.user.rprs.id' />",field:"userRprsId", headerHozAlign:"center", hozAlign:"center", width:140, minWidth:140},    /* 대표아이디 */
                {title:"<spring:message code="exam.label.user.no" />", field:"stdntNo", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},           /* 학번 */
                {title:"<spring:message code="exam.label.user.nm" />", field:"usernm", headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:80},             /* 이름 */
                {title:"<spring:message code="exam.label.absent.reason" />", field:"absnceCts", headerHozAlign:"center", hozAlign:"left", width:0, minWidth:100},       /* 결시 사유 */
                {title:"<spring:message code="exam.label.appl.rate" />", field:"absnceRfltrt", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},    /* 적용비율 */
                {title:"<spring:message code="exam.label.absent.approve" />", field:"aplyStsStts", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100} /* 결시원 승인 */
            ];
            sbstUserInfoListTable = UiTable("sbstUserList", {
                lang: "ko",
                selectRow: "checkbox",
                pageFunc: loadSbstUserInfoList,
                columns: examInfoColumns
            });
        }
        /* 5 */
        function createSbstUserInfoListHtml(list) {
            let dataList = [];
            if (list.length == 0) {
                return dataList;
            } else {
                list.forEach(function(v, i) {
                    // 학번
                    var stdntNo;
                    if (v.stdntNo == "" || v.stdntNo == null) {
                        stdntNo = "-";
                    } else {
                        stdntNo = v.stdntNo;
                    }
                    // 반영비율
                    var absnceRfltrt;
                    if (v.absnceRfltrt == "" || v.absnceRfltrt == null) {
                        absnceRfltrt = '-'
                    } else {
                        absnceRfltrt = v.absnceRfltrt + "%";
                    }
                    // 결시승인
                    var aplyStsStts;
                    if (v.aplyStsStts == "Y") {
                        aplyStsStts = "<span><spring:message code="exam.label.approve" /></span>";  /* 승인 */
                    } else {
                        aplyStsStts = "<span class='fcRed'><spring:message code="exam.label.unapprove" /></span>";  /* 미승인 */
                    }
                    dataList.push({
                        lineNo:         v.lineNo
                        , deptnm:       v.deptnm
                        , userRprsId:   v.userRprsId
                        , stdntNo:      stdntNo
                        , userId:       v.userId
                        , usernm:       v.usernm
                        , absnceCts:    v.absnceCts
                        , absnceRfltrt: absnceRfltrt
                        , aplyStsStts:  aplyStsStts
                        , mobileNo:     v.mobileNo
                        , email:        v.email
                    });
                });
            }
            return dataList;
        }
        /* 6 */
        function loadSbstUserInfoList(pageIndex) {
            initSbstUserInfoListTable();
            PAGE_INDEX = pageIndex || PAGE_INDEX;
            UiComm.showLoading(true);
            $.ajax({
                url: "/exam/examSbstUserPaging.do",
                type: "GET",
                data: {
                    examBscId   : curExamBscId,
                    pageIndex   : PAGE_INDEX,
                    listScale   : LIST_SCALE
                },
                dataType: "json",
                success: function(data) {
                    if (data.result > 0) {
                        var returnList = data.returnList || [];
                        var dataList   = createSbstUserInfoListHtml(returnList);
                        sbstUserInfoListTable.clearData();
                        sbstUserInfoListTable.replaceData(dataList);
                        sbstUserInfoListTable.setPageInfo(data.pageInfo);
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

        /*****************************************************************************
         * 팀 시험일 경우 생성되는 요소 제어 기능
         * 1. examDtlInfoVO 모델 를 JS 배열로 변환
         * 2. 팀 시험 부주제 목록 HTML append
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
                    html += "	<th rowspan='3' class='group-header'><label>" + v.teamnm + "</label></th>";
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
         * 시험지 보기 버튼 생성 제어 기능
         * 1. var pprInfoList:  pprInfo 모델을 JS 배열로 변환
         * 2. pprBtnAppend:     시험지 버튼 HTML append
         *****************************************************************************/
        /* 1 */
        var pprInfoList = [
            <c:forEach var="pprInfo" items="${pprInfo}" varStatus="st">
            {
                onlnExampprUrl  : '${fn:escapeXml(pprInfo.onlnExampprUrl)}',
                isActive        : '${fn:escapeXml(pprInfo.isActive)}',
                teamId          : '${fn:escapeXml(pprInfo.teamId)}',
                teamnm          : '${fn:escapeXml(pprInfo.teamnm)}'
            }
            <c:if test="${!st.last}">,</c:if>
            </c:forEach>
        ];
        /* 2 */
        function onlnPprBtnAppend() {
            var html = "";
            var isTeamExam = pprInfoList.length > 0 && pprInfoList[0].teamId !== '';
            /* 팀 시험: teamId가 존재하는 경우 */
            if (isTeamExam) {
                pprInfoList.forEach(function(v, i) {
                    html += "<a href='javascript:tkexamStatPop(" + "\"" + v.onlnExampprUrl + "\"" + ")' class='btn type1";
                    if (v.isActive === 'N') {
                        html += " disabled'";
                    } else {
                        html += "'";
                    }
                    html += ">" + v.teamnm + " <spring:message code='exam.label.std.paper' /></a>"; /* 의 시험지 */
                });
            } else {
                /* 일반 시험: teamId가 없는 경우 */
                pprInfoList.forEach(function(v, i) {
                    html += "<a href='javascript:tkexamStatPop(" + "\"" + v.onlnExampprUrl + "\"" + ")' class='btn type1";
                    if (v.isActive === 'N') {
                        html += " disabled'";
                    } else {
                        html += "'";
                    }
                    html += "><spring:message code='exam.label.paper' /> <spring:message code='exam.label.preview' /></a>"; /* 시험지 */ /* 미리보기 */
                });
            }
            $("#onlnPpr").append(html);
        }

        /**
         * 시험 대체 등록|수정 화면 이동
         * @param {String} examBscId    - 시험 기본 ID
         * @param {String} gbn          - 구분 [ASMT|QUIZ]
         */
        function sbstViewMv(examBscId, gbn) {
            var extData = { examBscId: examBscId, gbn: gbn };
            document.location.href = "/exam/profExamSbstWrite.do"
                + "?encParams=" + EPARAM
                + "&addParams=" + UiComm.makeEncParams(extData);
        }

        /* 메세지 전송 기능 */
        function sendMsg() {
            var rcvUserInfoStr = "";
            var sendCnt = 0;

            $.each($('#sbstUserList').find("input:checkbox[name=evalChk]:not(:disabled):checked"), function() {
                sendCnt++;
                if (sendCnt > 1) rcvUserInfoStr += "|";
                rcvUserInfoStr += $(this).attr("user_id");
                rcvUserInfoStr += ";" + $(this).attr("user_nm");
                rcvUserInfoStr += ";" + $(this).attr("mobile");
                rcvUserInfoStr += ";" + $(this).attr("email");
            });

            if (sbstUserInfoListTable.getSelectedData("userId").length == 0) {
                /* 메시지 발송 대상자를 선택하세요. */
                alert("<spring:message code='common.alert.sysmsg.select_user'/>");
                return;
            }

            window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");

            var form = document.alarmForm;
            form.action = "<%=CommConst.SYSMSG_URL_SEND%>";
            form.target = "msgWindow";
            form[name='alarmType'].value = "S"; // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
            form[name='rcvUserInfoStr'].value = rcvUserInfoStr; //보내는사람 정보
            form.submit();
        }

        $(document).ready(function() {
            loadSbstInfoList();
            loadSbstUserInfoList();

            if (hasSubSubject == 'Y') {
                examSubAsmtListAppend();
            }
            onlnPprBtnAppend();
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
                        <!-- 콘텐츠 상단 탭 버튼 영역 -->
                        <div class="page-info">
                            <h2 class="page-title">
                                <spring:message code="exam.label.exam" /><!-- 시험 -->
                            </h2>
                        </div>
                        <div class="listTab">
                            <ul>
                                <!-- 실시간/퀴즈 에 따라 버튼 동적 생성 -->
                                <li class="mw120">
                                    <a onclick="profExamViewMv(1)">
                                        <spring:message code='exam.label.exam' /><!-- 시험 -->
                                        <spring:message code='exam.label.info.score.manage' /><!-- 정보 및 평가 -->
                                    </a>
                                </li>
                                <c:if test="${vo.tkexamMthdCd eq 'RLTM' and (examVO.examGbncd eq 'EXAM_LST'
                                                                            or examVO.examGbncd eq 'EXAM_LST_TEAM'
                                                                            or examVO.examGbncd eq 'EXAM_MID'
                                                                            or examVO.examGbncd eq 'EXAM_MID_TEAM')}">
                                    <li class="mw120 select" style = "pointer-events: none;">
                                        <a onclick="profExamViewMv(2)">
                                            <spring:message code='exam.label.exam' /> <!-- 시험 -->
                                            <spring:message code='exam.label.sub' /><!-- 대체 -->
                                        </a>
                                    </li>
                                    <li class="mw120">
                                        <a onclick="profExamViewMv(3)">
                                            <spring:message code='exam.label.info.absence' /><!-- 결시 내용 및 현황 -->
                                        </a>
                                    </li>
                                    <li class="mw120">
                                        <a onclick="profExamViewMv(4)">
                                            <spring:message code='exam.label.dsbl' />/<!-- 장애인 -->
                                            <spring:message code='exam.label.snrs' /> <!-- 고령자 -->
                                            <spring:message code='exam.label.support.stts' /><!-- 지원 현황 -->
                                        </a>
                                    </li>
                                </c:if>
                                <c:if test="${vo.tkexamMthdCd eq 'QUIZ'}">
                                    <li class="mw120">
                                        <a onclick="profExamViewMv(5)">
                                            <spring:message code='exam.label.subs.quiz.manage' /><!-- 퀴즈 관리 -->
                                        </a>
                                    </li>
                                </c:if>
                            </ul>
                        </div>
                        <!-- 고정 영역 -->
                        <div class="board_top">
                            <i class="icon-svg-openbook"></i>
                            <h3 class="board-title">
                                <spring:message code='exam.label.exam' /> <!-- 시험 -->
                                <spring:message code='exam.label.sub' /><!-- 대체 -->
                            </h3>
                            <div class="right-area">
                                <button type="button" class="btn basic" onclick="profExamViewMv(8)"><spring:message code='exam.button.list' /></button><!-- 목록 -->
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
                                            <c:choose>
                                                <c:when test="${examVO.tkexamMthdCd eq 'RLTM'}">
                                                    <tr>
                                                        <th><spring:message code='exam.label.onln' /> <spring:message code='exam.label.paper' /></th><!-- 온라인 --> <!-- 시험지 -->
                                                        <td colspan="3" id="onlnPpr"></td>
                                                    </tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <tr>
                                                        <th><spring:message code='exam.label.quiz' /> <spring:message code='exam.label.paper' /></th><!-- 퀴즈 --> <!-- 시험지 -->
                                                        <td colspan="3" id="quizPpr"></td>
                                                    </tr>
                                                </c:otherwise>
                                            </c:choose>
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
                                                <tr>
                                                    <th><spring:message code='exam.label.exam' /> <spring:message code='exam.label.sub' /></th><!-- 시험 --><!-- 대체 -->
                                                    <td colspan="3">
                                                        <div class = "item_list">
                                                            ${examVO.examSbstTynm}
                                                            <button type="button" class = "btn basic" onclick="profExamViewMv(2)" style = "pointer-events: none;">
                                                                <spring:message code='exam.label.exam' /> <!-- 시험 -->
                                                                <spring:message code='exam.label.sub' /><!-- 대체 -->
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th><spring:message code='exam.button.miss.status' /></th><!-- 결시 현황 -->
                                                    <td colspan="3">
                                                        <div class = "item_list">
                                                            ${examVO.absnceTot} <spring:message code='exam.label.nm' /><!-- 명 -->
                                                            <button type="button" class = "btn basic" onclick="profExamViewMv(3)" >
                                                                <spring:message code='exam.label.info.absence' /><!-- 결시 내용 및 현황 -->
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th><spring:message code='exam.label.dsbl' />/<spring:message code='exam.label.snrs' /> <spring:message code='exam.label.support.cnt' /></th><!-- 장애인 --><!-- 고령자 --><!-- 지원 인원 -->
                                                    <td colspan="3">
                                                        <div class = "item_list">
                                                            ${examVO.dsblTot} <spring:message code='exam.label.nm' /><!-- 명 -->
                                                            <button type="button" class = "btn basic" onclick="profExamViewMv(4)">
                                                                <spring:message code='exam.label.dsbl' />/<!-- 장애인 -->
                                                                <spring:message code='exam.label.snrs' /> <!-- 고령자 -->
                                                                <spring:message code='exam.label.support.stts' /><!-- 지원 현황 -->
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <div>
                            <!-- 시험 대체 설정 영역 -->
                            <div class="board_top">
                                <h4 class="sub-title">[${examVO.examGbnnm}] <spring:message code='exam.label.exam.sub.set' /></h4><!-- 시험 대체 설정 -->
                                <div class="right-area">
                                    <a href="javascript:sbstViewMv('${vo.examBscId}','')" class="btn type2 small"><spring:message code='exam.button.reg' /></a><!-- 등록 -->
                                </div>
                            </div>
                            <div id = "sbstArea">
                                <div id="sbstList"></div>
                            </div>
                            <!-- 시험 대체 대상자 영역 -->
                            <div class="board_top margin-top-4">
                                <h4 class="sub-title">[${examVO.examGbnnm}] <spring:message code='exam.label.exam' /> <spring:message code='exam.label.sub' /> <spring:message code='exam.label.target.user' /></h4><!-- 시험 --><!-- 대체 --><!-- 대상자 -->
                                <div class="right-area">
                                    <a href="javascript:sendMsg()" class="btn basic small"><spring:message code='exam.button.eval.send' /></a><!-- 보내기 -->
                                </div>
                            </div>
                            <div id = "sbstUserArea">
                                <div id="sbstUserList"></div>
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
