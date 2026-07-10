<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
</head>

<body class="admin">
    <script type="text/javascript">
        let RECORD_COUNT_PER_PAGE = '<c:out value="${pageInfo.recordCountPerPage}" />';
        let CURRENT_PAGE_NO = '<c:out value="${pageInfo.currentPageNo}" />';
        let EPARAM = "${encParams}";
        const SEARCH_KEY = "${searchKey}";

        $(function() {
            changeSbjctList();

            $("#deptId").on("change", function() {changeSbjctList();});
        });

        // list scale 변경
        function changeRecoredCnt(scale) {
            RECORD_COUNT_PER_PAGE = scale;
            listPaging(1);
        }

        // 학기기수 세팅 변경
        function changeSmstrChrt() {
            let $sbjctSmstr = $('#sbjctSmstr');

            // 기존 옵션 초기화
            $sbjctSmstr.empty();

            $.ajax({
                url  : "/crs/termMgr/admSmstrListByDgrsYrAjax.do",
                data : {
                    dgrsYr 	: $("#sbjctYr").val()
                    <%--	,orgId	: $("#orgId").val() --%>
                },
                type : "GET",
                success: function(data) {
                    if (data.result > 0) {
                        let resultList = data.returnList;

                        $sbjctSmstr.append(`<option value='ALL'><spring:message code="crs.label.open.term" /></option>`);

                        $.each(resultList, function(i, smstrChrtVO) {
                            $sbjctSmstr.append(`<option value="\${smstrChrtVO.smstrChrtId}">\${smstrChrtVO.smstrChrtnm}</option>`);
                            /* $sbjctSmstr.append('<option'+' value="'+smstrChrtVO.smstrChrtId+'" >' + smstrChrtVO.smstrChrtnm + '</option>'); */
                        })

                        $sbjctSmstr.trigger("chosen:updated");
                    }else {
                        alert(data.message);
                    }
                },
                error: function(xhr, status, error) {
                    alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
                }
            });
        }

        // 학과부서 변경에 따른 개설과목 목록 조회
        function changeSbjctList() {
            let $sbjctOfrngId = $('#sbjctOfrngId');

            // 기존 옵션 초기화
            $sbjctOfrngId.empty();

            let url = "/crs/creCrsMgr/sbjctListAjax.do";

            let data = {
                sbjctYr		: $("#sbjctYr").val(),
                smstrChrtId	: $("#sbjctSmstr").val(),
                orgId		: $("#orgId").val(),
                deptId		: $("#deptId").val()
            };

            $.ajax({
                url	: url,
                data: data,
                type: "GET",
                success	: function(data) {
                    if (data.result > 0) {
                        let resultList = data.returnList;

                        $sbjctOfrngId.append(`<option value='ALL'><spring:message code='sch.cal_course' /></option>`);
                        
                        $.each(resultList, function(i, sbjctOfrngVO) {
                            $sbjctOfrngId.append(`<option value="\${sbjctOfrngVO.sbjctOfrngId}">\${sbjctOfrngVO.sbjctnm}</option>`);
                        })

                        $sbjctOfrngId.trigger("chosen:updated");
                    }else {
                        alert(data.message);
                    }
                }
            });
        }

        // 학습현황 목록
        function listPaging(pageNo) {
            UiComm.showLoading(true);

            CURRENT_PAGE_NO = pageNo;
            // const yrSmstr = $("#yrSmstr").val() || "";
            // const smstrChrtGbncd = $("#yrSmstr option:selected").data("type") || "";

            let param = {
                currentPageNo     : CURRENT_PAGE_NO,
                recordCountPerPage: RECORD_COUNT_PER_PAGE,
                yrSmstr      : $("#yrSmstr").val() || "",
                smstrChrtGbncd : $("#yrSmstr option:selected").data("type") || "",
                orgId		 : $("#orgId").val(),
                deptId		 : ($("#deptId").val() || "").replace("ALL", ""),
                sbjctId      : ($("#sbjctId").val() || "").replace("ALL", ""),
                searchKey    : SEARCH_KEY,
                searchValue  : $("#searchValue").val(),
            };

            $.ajax({
                url	: "/stats/admLrnPrgStsListAjax.do",
                data: param,
                type: "GET",
                headers: {"X-Requested-With": "XMLHttpRequest"},
                success: function(data) {
                    if (data.encParams != null && data.encParams !== '') {
                        EPARAM = data.encParams;
                    }

                    if (data.result > 0) {
                        let returnList = data.returnList || [];

                        let sbjctList = createSbjctListHtml(returnList, data.pageInfo);
                        sbjctListTable.clearData();
                        sbjctListTable.replaceData(sbjctList);
                        sbjctListTable.setPageInfo(data.pageInfo);

                        let totAvgData = [];
                        totAvgData.push(data.data || {});
                        let totAvgList = createTotAvgListHtml(totAvgData);
                        totAvgListTable.clearData();
                        totAvgListTable.replaceData(totAvgList);

                    } else {
                        UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error"); // 에러 메세지
                    }
                },
                error : function(xhr, status, error) {
                    UiComm.showMessage('<spring:message code="fail.common.msg" />', "error"); // 에러가 발생했습니다!
                },
                complete: function (){
                    UiComm.showLoading(false);
                }
            });
        }

        // 테이블 그리기
        function createSbjctListHtml(list, pageInfo) {
            let dataList = [];

            list.forEach(item => {
                dataList.push({
                    no: item.lineNo,
                    orgnm       : item.orgnm,
                    sbjctYr     : item.sbjctYr,
                    sbjctSmstr  : item.sbjctSmstr,
                    deptnm      : item.deptnm,
                    admnm       : item.admnm,
                    sbjctAdmTycd: item.sbjctAdmTycd === 'PROF' ? "교수" : "조교",
                    totLrnCnt   : item.totContsLrnRndCnt,
                    totLrnTime  : item.totContsLrnTotMnts,
                    lrnPrgrt    : item.avgLrnPrgrt + '%',
                    midExamPtcprt : item.midExamPtcprt === -1 ? "-" : item.midExamPtcprt + '%',
                    lstExamPtcprt : item.lstExamPtcprt === -1 ? "-" : item.lstExamPtcprt + '%',
                    asmtPtcprt  : item.asmtPtcprt === -1 ? "-" : item.asmtPtcprt + '%',
                    quizPtcprt  : item.quizPtcprt === -1 ? "-" : item.quizPtcprt + '%',
                    srvyPtcprt  : item.srvyPtcprt === -1 ? "-" : item.srvyPtcprt + '%',
                    dscsPtcprt  : item.dscsPtcprt === -1 ? "-" : item.dscsPtcprt + '%',
                    smnrPtcprt  : item.smnrPtcprt === -1 ? "-" : item.smnrPtcprt + '%',
                    examPtcprt  : item.examPtcprt === -1 ? "-" : item.examPtcprt + '%'
                })
            });

            return dataList;

        }

        function createTotAvgListHtml(list) {
            let dataList = [];

            list.forEach(item => {

                dataList.push({
                    // no: item.lineNo,
                    header: "<spring:message code='common.label.learn.progress.statistics.avg.total'/>",
                    totLrnCnt   : item.totContsLrnRndCnt,
                    totLrnTime  : item.totContsLrnTotMnts,
                    lrnPrgrt    : item.avgLrnPrgrt + '%',
                    midExamPtcprt : item.midExamPtcprt === -1 ? "-" : item.midExamPtcprt + '%',
                    lstExamPtcprt : item.lstExamPtcprt === -1 ? "-" : item.lstExamPtcprt + '%',
                    asmtPtcprt  : item.asmtPtcprt === -1 ? "-" : item.asmtPtcprt + '%',
                    quizPtcprt  : item.quizPtcprt === -1 ? "-" : item.quizPtcprt + '%',
                    srvyPtcprt  : item.srvyPtcprt === -1 ? "-" : item.srvyPtcprt + '%',
                    dscsPtcprt  : item.dscsPtcprt === -1 ? "-" : item.dscsPtcprt + '%',
                    smnrPtcprt  : item.smnrPtcprt === -1 ? "-" : item.smnrPtcprt + '%',
                    examPtcprt  : item.examPtcprt === -1 ? "-" : item.examPtcprt + '%'
                })
            });

            return dataList;

        }

        // 엑셀 다운로드
        function excelDown() {
            $("form[name='excelForm']").remove();
            var excelGrid = {
                colModel:[
                    {label:"<spring:message code='common.no' />", name:'lineNo', align:'center', width:'3000'}, /* 번호 */
                    {label:"<spring:message code='common.year' />", name:'sbjctYr', align:'center', width:'3000'}, /* 년도 */
                    {label:"<spring:message code='common.term' />", name:'sbjctSmstr', align:'center', width:'3000'}, /* 학기 */
                    {label:"<spring:message code='common.label.org' />", name:'orgId', align:'center', width:'3000'}, /* 기관 */
                    {label:"<spring:message code='common.dept_name'/>", name:'deptnm', align:'left', width:'8000'}, /* 학과 */
                    {label:"<spring:message code='common.label.crsauth.crsnm'/>", name:'sbjctnm', align:'left', width:'8000'}, /* 개설과목명 */
                    {label:"<spring:message code='common.label.decls.no' />", name:'dvclasNo', align:'center', width:'3000'}, /* 분반 */
                    {label:"<spring:message code='common.id'/>", name:'userNm', align:'center', width:'5000'}, /* 아이디 */
                    {label:"<spring:message code='common.name'/>", name:'userNm', align:'center', width:'5000'}, /* 이름 */
                    {label:"<spring:message code='common.label.userdept.grade' />", name:'scyr', align:'center', width:'3000'}, /* 학년 */
                    {label:"<spring:message code='common.label.lesson.open.week'/> (A)", name:'allScheduleCnt', align:'left', width:'5000'}, /* 오픈주차 */
                    {label:"<spring:message code='common.label.lesson.learn.week'/> (B)", name:'studyScheduleCnt', align:'left', width:'5000'}, /* 학습주차 */
                    {label:"<spring:message code='lesson.label.study.status.complete.yule'/> (A/B)", name:'studyPersent', align:'left', width:'5000'}, /* 출석율 */
                ]
            };
            let searchKey = $("#noStudyAll").is(":checked") ? "Y" : "";

            let form = $("<form></form>");
            form.attr("method", "POST");
            form.attr("name", "excelForm");
            form.attr("action", "/lesson/lessonHome/lessonProgressExcelDown.do");
            form.append($('<input/>', {type: 'hidden', name: 'sbjctYr', 	value: $("#sbjctYr").val()}));
            form.append($('<input/>', {type: 'hidden', name: 'smstrChrtId', value: $("#sbjctSmstr").val()}));
            form.append($('<input/>', {type: 'hidden', name: 'orgId', 		value: $("#orgId").val()}));
            form.append($('<input/>', {type: 'hidden', name: 'deptId', 		value: ($("#deptId").val() || "").replace("ALL", "")}));
            form.append($('<input/>', {type: 'hidden', name: 'smstrChrtId', value: ($("#sbjctSmstr").val() || "").replace("ALL", "")}));
            form.append($('<input/>', {type: 'hidden', name: 'searchKey', 	value: searchKey}));
            form.append($('<input/>', {type: 'hidden', name: 'searchFrom', 	value: $("#searchFrom").val()}));
            form.append($('<input/>', {type: 'hidden', name: 'searchTo', 	value: $("#searchTo").val()}));
            form.append($('<input/>', {type: 'hidden', name: 'excelGrid', 	value: JSON.stringify(excelGrid)}));
            form.appendTo("body");
            form.submit();
        }
    </script>
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/admin_header.jsp"/>
        <!-- //common header -->

        <!-- dashboard -->
        <main class="common">

            <!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/admin_aside.jsp"/>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="admin_sub">

                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">${uiex:getCurMenunm()}</h2>
                            <uiex:navibar type="admin"/>
                        </div>

                        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><label for="selectDate">기관</label></span>
                                <div class="itemList">
                                    <select class="form-select" id="orgId" disabled><!-- 기관 -->
                                        <option value="">기관</option>
                                        <c:forEach var="list" items="${filterOptions.orgList }">
                                            <option value="${list.orgId }" ${list.orgId eq filterOptions.orgId ? 'selected' : '' }>${list.orgnm }</option>
                                        </c:forEach>
                                    </select>
                                    <select class="form-select" id="deptId">
                                        <option value=""><spring:message code="exam.label.dept" /></option><!-- 학과 -->
                                        <c:forEach var="list" items="${filterOptions.deptList }">
                                            <option value="${list.deptId }">${list.deptnm }</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="item">
                                <span class="item_tit"><label for="selectDate">학사년도/학기</label></span>
                                <div class="itemList">
                                    <select class="form-select" id="yrSmstr">
                                        <option value=""><spring:message code="msg.common.label.yearSmstr" /></option>
                                        <c:forEach var="item" items="${filterOptions.yrSmstrList }" varStatus="i">
                                            <option value="${item.dgrsYr}${item.dgrsSmstrChrt}" <%--${i.index eq 0 ? 'selected' : '' }--%> data-type="${item.smstrChrtGbncd}">${item.yrSmstrnm}</option>
                                        </c:forEach>
                                    </select>
                                    <%--<select class="form-select" id="dgrsYr">
                                        <option value=""><spring:message code="crs.label.open.year" /></option><!-- 개설년도 -->
                                        <c:forEach var="item" items="${filterOptions.yearList }">
                                            <option value="${item }" ${item eq filterOptions.curYear ? 'selected' : '' }>${item }</option>
                                        </c:forEach>
                                    </select>--%>
                                   <%-- <select class="form-select" id="dgrsSmstrChrt"><!-- 개설학기 -->
                                        <option value=""><spring:message code="crs.label.open.term" /></option>
                                        <c:forEach var="list" items="${filterOptions.smstrChrtList }">
                                            &lt;%&ndash; <option value="${list.smstrChrtId }" ${list.dgrsSmstrChrt eq curSmstrChrtVO.dgrsSmstrChrt ? 'selected' : '' }>${list.smstrChrtnm }</option> &ndash;%&gt;
                                            <option value="${list.smstrChrtId }">${list.smstrChrtnm }</option>
                                        </c:forEach>
                                    </select>--%>
                                </div>
                            </div>

                            <div class="item">
                                <span class="item_tit"><label for="selectCourse">운영과목</label></span>
                                <div class="itemList">
                                    <select class="form-select" id="sbjctId">
                                        <option value=""><spring:message code="common.subject" /></option><!-- 과목 -->
                                        <c:forEach var="list" items="${filterOptions.sbjctList }">
                                            <option value="${list.sbjctId }">${list.sbjctnm }</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="item">
                                <span class="item_tit"><label for="searchValue">검색어</label></span>
                                <div class="itemList">
                                    <input type="text" id="searchValue" name="searchValue" class="form-control w350" value="" placeholder="담당자명 입력" autocomplete="off"/>
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="listPaging(1)"><spring:message code="sys.button.search" /></button>
                            </div>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title"><spring:message code="common.label.learn.progress.statistics.sbjctadm"/></h3><%--담당별 학습진도현황--%>
                            <div class="right-area">
                                <button type="button" class="btn basic"><spring:message code="common.button.message.send" /></button>
                                <button type="button" class="btn type2" onclick="excelDown()"><spring:message code="exam.button.excel.down" /></button><!-- 엑셀 다운로드 -->
                                <uiex:listScale func="changeRecoredCnt" value="${pageInfo.recordCountPerPage}" />
                            </div>
                        </div>

                        <div class="table-wrap">
                            <div id="sbjctList"></div>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title"><spring:message code="common.label.learn.progress.statistics.total" /></h3><%--학습진도 전체 평균--%>
                        </div>

                        <div class="table-wrap">
                            <div id="totAvgList"></div>
                        </div>
                        <script type="text/javascript">
                            let sbjctListTable;
                            let totAvgListTable;

                            $(function () {

                                sbjctListTable = UiTable("sbjctList", {
                                    lang: "ko",
                                    table: "sbjctList",
                                    selectRow: "checkbox",
                                    columns: [
                                        {title: "<spring:message code='common.no'/>", field: "no", headerHozAlign:"center", hozAlign:"center", width: 40, minWidth: 40},
                                        {title: "<spring:message code="common.label.org" />",  field: "orgnm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 130, headerSort:true},
                                        {title: "<spring:message code="common.year" />",  field: "sbjctYr", headerHozAlign: "center", hozAlign: "center", width: 70, minWidth: 70},
                                        {title: "<spring:message code="common.term.cohort" />",  field: "sbjctSmstr", headerHozAlign: "center", hozAlign: "center", width: 70, minWidth: 70},
                                        {title: "<spring:message code="common.dept_name" />",  field: "deptnm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 130},
                                        {title: "<spring:message code="common.label.org.chrgr.nm" />",  field: "admnm", headerHozAlign: "center", hozAlign: "center", width: 90, minWidth: 90},
                                        {title: "<spring:message code="common.type" />",  field: "sbjctAdmTycd", headerHozAlign: "center", hozAlign: "center", width: 45, minWidth: 45},
                                        {title: "<spring:message code="common.label.learn.cnt" />",  field: "totLrnCnt", headerHozAlign: "center", hozAlign: "center", width: 70, minWidth: 70},
                                        {title: "<spring:message code="common.label.learn.time" />",  field: "totLrnTime", headerHozAlign: "center", hozAlign: "center", width: 70, minWidth: 70},
                                        {title: "<spring:message code="common.label.learn.ratio.progress" />",  field: "lrnPrgrt", headerHozAlign: "center", hozAlign: "center", width: 70, minWidth: 70},
                                        {
                                            title:"<spring:message code='common.label.learn.ratio.participation'/>", headerHozAlign:"center", // 참여율
                                            columns: [
                                                {title:"<spring:message code='dashboard.exam_mid'/>", field:"midExamPtcprt",   headerHozAlign:"center",  hozAlign:"center", width:65, minWidth: 65}, // 중간고사
                                                {title:"<spring:message code='dashboard.exam_end'/>", field:"lstExamPtcprt",   headerHozAlign:"center",  hozAlign:"center", width:65, minWidth: 65}, // 기말고사
                                                {title:"<spring:message code='dashboard.cor.asmnt'/>", field:"asmtPtcprt",   headerHozAlign:"center",  hozAlign:"center", width:55, minWidth: 55}, // 과제
                                                {title:"<spring:message code='dashboard.cor.quiz'/>", field:"quizPtcprt",   headerHozAlign:"center",  hozAlign:"center", width:55, minWidth: 55}, // 퀴즈
                                                {title:"<spring:message code='dashboard.cor.resch'/>", field:"srvyPtcprt",   headerHozAlign:"center",  hozAlign:"center", width:55, minWidth: 55}, // 설문
                                                {title:"<spring:message code='dashboard.cor.forum'/>", field:"dscsPtcprt",   headerHozAlign:"center",  hozAlign:"center", width:55, minWidth: 55}, // 토론
                                                {title:"<spring:message code='dashboard.seminar'/>", field:"smnrPtcprt",   headerHozAlign:"center",  hozAlign:"center", width:55, minWidth: 55}, // 세미나
                                                {title:"<spring:message code='dashboard.cor.exam'/>", field:"examPtcprt",   headerHozAlign:"center",  hozAlign:"center", width:55, minWidth: 55}, // 수시시험
                                            ]
                                        }
                                    ],
                                    pageFunc: listPaging,
                                });

                                totAvgListTable = UiTable("totAvgList", {
                                    lang: "ko",
                                    table: "totAvgList",
                                    columns: [
                                        {title: "", field: "header", headerHozAlign:"center", hozAlign:"center", width: 0, minWidth: 600},
                                        <%--{title: "<spring:message code="common.label.org" />",  field: "orgnm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 100},--%>
                                        <%--{title: "<spring:message code="common.year" />",  field: "sbjctYr", headerHozAlign: "center", hozAlign: "center", width: 70, minWidth: 70},--%>
                                        <%--{title: "<spring:message code="common.term.cohort" />",  field: "sbjctSmstr", headerHozAlign: "center", hozAlign: "center", width: 50, minWidth: 50},--%>
                                        <%--{title: "<spring:message code="common.dept_name" />",  field: "deptnm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 130},--%>
                                        <%--{title: "<spring:message code="common.subject" />",  field: "sbjctnm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 180},--%>
                                        <%--{title: "<spring:message code="common.label.decls.no" />",  field: "dvclasNo", headerHozAlign: "center", hozAlign: "center", width: 50, minWidth: 50},--%>
                                        {title: "<spring:message code="common.label.learn.cnt" />",  field: "totLrnCnt", headerHozAlign: "center", hozAlign: "center", width: 70, minWidth: 70},
                                        {title: "<spring:message code="common.label.learn.time" />",  field: "totLrnTime", headerHozAlign: "center", hozAlign: "center", width: 70, minWidth: 70},
                                        {title: "<spring:message code="common.label.learn.ratio.progress" />",  field: "lrnPrgrt", headerHozAlign: "center", hozAlign: "center", width: 70, minWidth: 70},
                                        {
                                            title:"<spring:message code='common.label.learn.ratio.participation'/>", headerHozAlign:"center", // 참여율
                                            columns: [
                                                {title:"<spring:message code='dashboard.exam_mid'/>", field:"midExamPtcprt",   headerHozAlign:"center",  hozAlign:"center", width:65, minWidth: 65}, // 중간고사
                                                {title:"<spring:message code='dashboard.exam_end'/>", field:"lstExamPtcprt",   headerHozAlign:"center",  hozAlign:"center", width:65, minWidth: 65}, // 기말고사
                                                {title:"<spring:message code='dashboard.cor.asmnt'/>", field:"asmtPtcprt",   headerHozAlign:"center",  hozAlign:"center", width:55, minWidth: 55}, // 과제
                                                {title:"<spring:message code='dashboard.cor.quiz'/>", field:"quizPtcprt",   headerHozAlign:"center",  hozAlign:"center", width:55, minWidth: 55}, // 퀴즈
                                                {title:"<spring:message code='dashboard.cor.resch'/>", field:"srvyPtcprt",   headerHozAlign:"center",  hozAlign:"center", width:55, minWidth: 55}, // 설문
                                                {title:"<spring:message code='dashboard.cor.forum'/>", field:"dscsPtcprt",   headerHozAlign:"center",  hozAlign:"center", width:55, minWidth: 55}, // 토론
                                                {title:"<spring:message code='dashboard.seminar'/>", field:"smnrPtcprt",   headerHozAlign:"center",  hozAlign:"center", width:55, minWidth: 55}, // 세미나
                                                {title:"<spring:message code='dashboard.cor.exam'/>", field:"examPtcprt",   headerHozAlign:"center",  hozAlign:"center", width:55, minWidth: 55}, // 수시시험
                                            ]
                                        }
                                    ]
                                });

                                listPaging(1);
                            });
                        </script>

                    </div>
                </div>
            </div>
            <!-- //content -->

        </main>
        <!-- //dashboard-->

    </div>


</body>
</html>