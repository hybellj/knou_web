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
        var curSbjctId      = '<c:out value="${examVO.sbjctId}" />';
        var curTkexamMthdCd = '<c:out value="${vo.tkexamMthdCd}" />';

        var curByteamSubrexamUseyn = '${vo.byteamSubrexamUseyn}';   // 팀 여부
        var hasSubSubject = '${examVO.teamGrpSubsbjctUseyn}';        // 부 주제
        var dsblInfoListTable = null;

        /*****************************************************************************
         * tabulator 관련 기능
         * 1. initDsblInfoListTable :   컬럼 정의 (대상자 전체 | 팀)
         * 2. createDsblInfoListHtml:   각 컬럼에 들어갈 데이터 세팅 및 요소 생성
         * 3. loadDsblInfoList :        컬럼에 들어갈 데이터 ajax 호출
         * 4. changeInfoListScale :     페이지 row수 세팅
         *****************************************************************************/
        /* 1 */
        function initDsblInfoListTable() {
            if (dsblInfoListTable) return;
            var dsblInfoColumns = [
                {title:"No", field:"lineNo", headerHozAlign:"center", hozAlign:"center", width:50,  minWidth:50},
                {title:"<spring:message code='exam.label.dept' />", field:"deptnm", headerHozAlign:"center", hozAlign:"center", width:120, minWidth:120},               /* 학과 */
                {title:"<spring:message code='exam.label.user.no' />", field:"stntNo", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},            /* 학번 */
                {title:"<spring:message code='exam.label.user.nm' />", field:"usernm", headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:80},             /* 이름 */
                {title:"<spring:message code='exam.label.dsbl' />/<spring:message code='exam.label.snrs' />",field:"userStatus", headerHozAlign:"center", hozAlign:"center", width:100,  minWidth:100}, /* 장애인 */ /* 고령자 */
                {title:"<spring:message code='exam.label.dsbl.req.degree' />", field:"dsblGrdnm", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100}, /* 장애정도 */
                {title:"<spring:message code='exam.label.applicate.term' />", field:"examGbn", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},    /* 신청학기 */
                {title:"<spring:message code='exam.label.std.request' />", field:"examSprtAplyTynm", headerHozAlign:"center", hozAlign:"center", width:0, minWidth:200},/* 학생요청사항 */
                {title:"<spring:message code='exam.label.process.status' />", field:"addMnts", headerHozAlign:"center", hozAlign:"center", width:0, minWidth:200},      /* 처리상태 */
                {title:"<spring:message code='exam.label.cancel.request' />", field:"cancleReq", headerHozAlign:"center", hozAlign:"center", width:120, minWidth:120},  /* 취소요청 */
                {title:"<spring:message code='exam.label.manage' />", field:"manage", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100}              /* 관리 */
            ];
            dsblInfoListTable = UiTable("examDsblList", {
                lang: "ko",
                selectRow: "checkbox",
                pageFunc: loadDsblInfoList,
                columns: dsblInfoColumns
            });
        }
        /* 2 */
        function createDsblInfoListHtml(list) {
            let dataList = [];
            if (list.length == 0) {
                return dataList;
            } else {
                list.forEach(function(v, i) {
                    // 학번
                    var stdntNo;
                    if (v.stdntNo == null || v.stdntNo == '') {
                        stdntNo = '-';
                    } else {
                        stdntNo = v.stdntNo;
                    }
                    // 장애인/고령자
                    var userStatus;
                    if (v.userStatus == 'Seniors') {
                        userStatus = "<spring:message code='exam.label.snrs' />"; /* 고령자 */
                    } else {
                        userStatus = v.dsblTynm;
                    }
                    // 장애 정도
                    var dsblGrdnm;
                    if (v.userStatus == 'Seniors') {
                        dsblGrdnm = '-'
                    } else {
                        dsblGrdnm = v.dsblGrdnm
                    }
                    // 신청 학기
                    var examGbn = "<spring:message code='exam.label.mid' />" + '/' + "<spring:message code='exam.label.final' />";  /* 중간 */ /* 기말 */
                    // 요청사항
                    var examSprtAplyTynm = v.examSprtAplyTynm + "/" + v.examSprtAplyTynm;

                    // 관리 버튼
                    var manageBtns = "";
                        manageBtns += "<div style='display:flex;align-items:center;gap:0 3px'>";
                        manageBtns += "<a href='javascript:examDsblUserDtlPopup(\"" + v.sbjctId + "\", \"" + v.userId + "\")' class='btn basic small'><spring:message code='exam.label.view.detail' /></a>"; /* 상세 보기 */
                        manageBtns += "&nbsp;</div>"

                    dataList.push({
                        lineNo:             v.lineNo
                        , deptnm:           v.deptnm
                        , stdntNo:          stdntNo
                        , usernm:           v.usernm
                        , userStatus:       userStatus
                        , dsblGrdnm:        dsblGrdnm
                        , examGbn:          examGbn
                        , examSprtAplyTynm: examSprtAplyTynm
                        , addMnts:          v.sprtRslt
                        , cancleReq:        v.cnclAplyStsnm
                        , manage:           manageBtns
                        , userId:           v.userId
                        , sbjctId:          v.sbjctId
                        , mobileNo:         v.mobileNo
                        , email:            v.email
                    });
                });
            }
            return dataList;
        }
        /* 3 */
        function loadDsblInfoList(pageIndex) {
            initDsblInfoListTable();
            PAGE_INDEX = pageIndex || PAGE_INDEX;
            UiComm.showLoading(true);
            $.ajax({
                url: "/exam/dsblUserPaging.do",
                type: "GET",
                data: {
                    sbjctId             : curSbjctId,
                    aplyStscd           : $("#aplyStscd").val(),
                    evlyn    		    : $("#evlyn").val(),
                    searchValue 	    : $("#searchValue").val(),
                    pageIndex           : PAGE_INDEX,
                    listScale           : LIST_SCALE
                },
                dataType: "json",
                success: function(data) {
                    if (data.result > 0) {
                        var returnList = data.returnList || [];
                        var dataList   = createDsblInfoListHtml(returnList);
                        dsblInfoListTable.clearData();
                        dsblInfoListTable.replaceData(dataList);
                        dsblInfoListTable.setPageInfo(data.pageInfo);
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
            loadDsblInfoList(1);
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

        /*****************************************************************************
         * 검색 영역 기능
         * 1. examDsblListSelect :      수강생 검색
         * 2. resetListSelect :         수강생 전체 검색 및 검색영역 초기화
         *****************************************************************************/
        /* 1 */
        function examDsblListSelect (){
            loadDsblInfoList(1);
        }
        /* 2 */
        function resetListSelect() {
            $("#aplyStscd").val('').trigger('chosen:updated');
            $("#evlyn").val('').trigger("chosen:updated");
            $("#searchValue").val("");
            examDsblListSelect();
        }

        /*****************************************************************************
         * 엑셀 관련 기능
         * 1. examDsblStatusExcelDown:    장애인/고령자 지원현황 엑셀 다운로드
         * 2.
         *****************************************************************************/
        /* 1 */
        function examDsblStatusExcelDown() {
            var excelGrid = { colModel: [] };

            excelGrid.colModel.push({label: 'No.', name: 'lineNo', align: 'center', width: '1000'});
            excelGrid.colModel.push({label: '<spring:message code="exam.label.dept" />', name: 'deptnm', align: 'left', width: '5000'});                        /* 학과 */
            excelGrid.colModel.push({label: '<spring:message code="exam.label.user.no" />', name: 'stdntNo', align: 'center', width: '5000'});                  /* 학번 */
            excelGrid.colModel.push({label: '<spring:message code="exam.label.user.nm" />', name: 'usernm', align: 'center', width: '5000'});                   /* 이름 */
            excelGrid.colModel.push({label: '<spring:message code='exam.label.dsbl' />/<spring:message code='exam.label.snrs' />', name: 'usrStatusNm', align: 'center', width: '3000'});   /* 장애인 */ /* 고령자 */
            excelGrid.colModel.push({label: '<spring:message code='exam.label.dsbl.req.degree' />', name: 'dsblGrdnmNm', align: 'center', width: '3000'});      /* 장애정도 */
            excelGrid.colModel.push({label: '<spring:message code='exam.label.applicate.term' />', name: 'examGbn', align: 'center', width: '3000'});           /* 신청학기 */
            excelGrid.colModel.push({label: '<spring:message code='exam.label.std.request' />', name: 'examSprtAplyTynmRpt', align: 'center', width: '8000'});  /* 학생요청사항 */
            excelGrid.colModel.push({label: '<spring:message code='exam.label.process.status' />', name: 'addMnts', align: 'center', width: '5000'});           /* 처리상태 */
            excelGrid.colModel.push({label: '<spring:message code='exam.label.cancel.request' />', name: 'cancleReq', align: 'center', width: '3000'});         /* 취소요청 */

            var kvArr = [];
            kvArr.push({'key': 'sbjctId',       'val': curSbjctId});
            kvArr.push({'key': 'aplyStscd',     'val': $("#aplyStscd").val()});
            kvArr.push({'key': 'searchValue',   'val': $("#searchValue").val()});
            kvArr.push({'key': 'excelGrid',     'val': JSON.stringify(excelGrid)});

            submitForm("/exam/profExamDsblStatusExcelDown.do", "", "", kvArr);
        }

        /*****************************************************************************
         * 팝업 관련 기능
         * 1. examDsblUserDtlPopup:     지원사항 상세보기
         * 2. sendMsg :                 메세지 보내기
         *****************************************************************************/
        /* 1 */
        function examDsblUserDtlPopup(sbjctId, userId) {
            var data = "sbjctId="+curSbjctId+"&userId="+userId;

            dialog = UiDialog("dialog1", {
                title: "<spring:message code='exam.label.dsbl' />/<spring:message code='exam.label.snrs' /> <spring:message code='exam.label.view.detail' />",  /* 장애인 */ /* 고령자 */ /* 상세보기 */
                width: 1000,
                height: 900,
                url: "/exam/examDsblUserDtlPopup.do?"+data
            });
        }
        /* 2 */
        function sendMsg() {
            var rcvUserInfoStr = "";
            var sendCnt = 0;

            $.each($('#examInfoList').find("input:checkbox[name=evalChk]:not(:disabled):checked"), function() {
                sendCnt++;
                if (sendCnt > 1) rcvUserInfoStr += "|";
                rcvUserInfoStr += $(this).attr("user_id");
                rcvUserInfoStr += ";" + $(this).attr("user_nm");
                rcvUserInfoStr += ";" + $(this).attr("mobile");
                rcvUserInfoStr += ";" + $(this).attr("email");
            });

            if (dsblInfoListTable.getSelectedData("userId").length == 0) {
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
            loadDsblInfoList();

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
                                    <a onclick="profExamViewMv(1)">
                                        <spring:message code='exam.label.exam' /><!-- 시험 -->
                                        <spring:message code='exam.label.info.score.manage' /><!-- 정보 및 평가 -->
                                    </a>
                                </li>
                                <c:if test="${vo.tkexamMthdCd eq 'RLTM' and (examVO.examGbncd eq 'EXAM_LST'
                                                                            or examVO.examGbncd eq 'EXAM_LST_TEAM'
                                                                            or examVO.examGbncd eq 'EXAM_MID'
                                                                            or examVO.examGbncd eq 'EXAM_MID_TEAM')}">
                                    <li class="mw120">
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
                                    <li class="mw120 select" style = "pointer-events: none;">
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
                                <spring:message code='exam.label.dsbl' />/<!-- 장애인 -->
                                <spring:message code='exam.label.snrs' /> <!-- 고령자 -->
                                <spring:message code='exam.label.support.stts' /><!-- 지원 현황 -->
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
                                                            <button type="button" class = "btn basic" onclick="profExamViewMv(2)">
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
                                                            <button type="button" class = "btn basic" onclick="profExamViewMv(3)">
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
                                                            <button type="button" class = "btn basic" onclick="profExamViewMv(4)" style = "pointer-events: none;">
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
                            <!-- 장애인/고령자 지원현황 상단영역 -->
                            <div class="board_top mb0">
                                <h4 class="sub-title">[${examVO.examGbnnm}]<spring:message code='exam.label.dsbl' />/<spring:message code='exam.label.snrs' /> <spring:message code='exam.label.support.stts' /></h4><!-- 장애인 --><!-- 고령자 --><!-- 지원 현황 -->
                                <div class="right-area">
                                    <a href="javascript:sendMsg()" class="btn basic small"><spring:message code='exam.button.eval.send' /></a><!-- 보내기 -->
                                </div>
                            </div>
                            <!-- 장애인/고령자 지원현황 검색영역 -->
                            <div class="board_top in_table">
                                <select class="form-select" id="aplyStscd">
                                    <option value=""><spring:message code='exam.label.process.status' /></option><!-- 처리상태 -->
                                    <option value="all"><spring:message code="exam.common.search.all" /></option><!-- 전체 -->
                                    <option value="1"><spring:message code='exam.label.process.n' /></option><!-- 처리대기 -->
                                    <option value="2"><spring:message code='exam.label.process.y' /></option><!-- 처리완료 -->
                                </select>
                                <!-- search small -->
                                <div class="search-typeC">
                                    <input class="form-control" type="text" id="searchValue" value="" placeholder="<spring:message code="message.search.input.dept.user.user.nm" />"><!-- 학과/학번/성명 입력 -->
                                    <button type="button" class="btn basic icon search" onclick="examDsblListSelect()"><i class="icon-svg-search"></i></button>
                                </div>
                                <button type="button" class="btn type1" onclick="resetListSelect()"><spring:message code='exam.label.std' /> <spring:message code='exam.common.search.all' /></button><!-- 수강생 --><!-- 전체 -->
                                <div class="right-area">
                                    <a href="javascript:examDsblStatusExcelDown()" class="btn type1 small"><spring:message code='exam.button.excel.down' /></a><!-- 엑셀 다운로드 -->
                                    <uiex:listScale func="changeInfoListScale" value="10" />
                                </div>
                            </div>
                            <div id = "dsblListArea">
                                <div id="examDsblList"></div>
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
