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

        $(function() {
            // 체크박스 클릭 감지
            $(document).on("change", "#excpList .tabulator-row input[type='checkbox']", function() {
                const $checkbox = $(this);
                // 체크박스가 속한 현재 행(Row) 전체 엘리먼트를 찾음
                const $row = $checkbox.closest(".tabulator-row");

                // console.log("체크박스 변경 감지됨!", "체크여부:", $checkbox.is(":checked"), "현재 행 정보:", $row);

                // 현재 체크박스가 체크된 상태인지 확인
                if ($checkbox.is(":checked")) {
                    // 1. 체크되었을 때: 글자(span) 숨기고 input 세트들 노출
                    $row.find(".tabulator-cell > span").hide();
                    $row.find(".tabulator-cell > input[id$='_procRsn'], .tabulator-cell > div[name$='_procDttm']").show();

                    $row.find(".datepicker").datepicker();
                    $row.find(".timepicker").timepicker();
                } else {
                    // 2. 체크 해제되었을 때: input 세트 숨기고 다시 원래 글자(span) 노출
                    $row.find(".tabulator-cell > input[id$='_procRsn'], .tabulator-cell > div[name$='_procDttm']").hide();
                    $row.find(".tabulator-cell > span").show();
                }
            });
        });

        // recordCountPerPage 변경
        function changeRecoredCnt(scale) {
            RECORD_COUNT_PER_PAGE = scale;
            listPaging(1);
        }

        // 학기기수 세팅 변경
        function changeSmstrChrt() {
            let $dgrsSmstrChrt = $('#dgrsSmstrChrt');

            // 기존 옵션 초기화
            $dgrsSmstrChrt.empty();

            $.ajax({
                url  : "/crs/termMgr/admSmstrListByDgrsYrAjax.do",
                data : {
                    dgrsYr 	: $("#dgrsYr").val()
                    <%--	,orgId	: $("#orgId").val() --%>
                },
                type : "GET",
                success: function(data) {
                    if (data.result > 0) {
                        let resultList = data.returnList;

                        $dgrsSmstrChrt.append(`<option value='ALL'><spring:message code="crs.label.open.term" /></option>`);

                        $.each(resultList, function(i, smstrChrtVO) {
                            $dgrsSmstrChrt.append(`<option value="\${smstrChrtVO.smstrChrtId}">\${smstrChrtVO.smstrChrtnm}</option>`);
                            /* $dgrsSmstrChrt.append('<option'+' value="'+smstrChrtVO.smstrChrtId+'" >' + smstrChrtVO.smstrChrtnm + '</option>'); */
                        })

                        $dgrsSmstrChrt.trigger("chosen:updated");
                    }else {
                        alert(data.message);
                    }
                },
                error: function(xhr, status, error) {
                    alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
                }
            });
        }

        // 학습현황 목록
        function listPaging(pageNo) {
            UiComm.showLoading(true);

            CURRENT_PAGE_NO = pageNo;

            let param = {
                currentPageNo       : CURRENT_PAGE_NO,
                recordCountPerPage  : RECORD_COUNT_PER_PAGE,
                yrSmstr             : $("#yrSmstr").val() || "",
                smstrChrtGbncd      : $("#yrSmstr option:selected").data("type") || "",
                orgId		        : $("#orgId").val(),
                sbjctId		        : $("#sbjctId").val(),
                searchValue         : $("#searchValue").val(),
            };

            $.ajax({
                url	: "/mrk/admMrkProcExcpProcListAjax.do",
                data: param,
                type: "GET",
                headers: {"X-Requested-With": "XMLHttpRequest"},
                success: function(data) {
                    if (data.encParams != null && data.encParams !== '') {
                        EPARAM = data.encParams;
                    }

                    if (data.result > 0) {
                        let returnList = data.returnList || [];

                        let excpList = createListHtml(returnList);
                        excpListTable.clearData();
                        excpListTable.replaceData(excpList);
                        excpListTable.setPageInfo(data.pageInfo);

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
        function createListHtml(list) {
            let dataList = [];

            list.forEach(item => {
                let procSdttm = formatDttm(item.procSdttm) || "-";
                let procEdttm = formatDttm(item.procEdttm) || "-";
                let regDttm = formatDttm(item.regDttm) || "-";
                let procRsn = item.procRsn || "-";

                dataList.push({
                    no      : item.lineNo,
                    mrkProcExcpProcId : item.mrkProcExcpProcId || "", // 삭제 시 필요
                    orgnm   : item.orgnm,
                    dgrsYr  : item.dgrsYr + "년",
                    dgrsSmstr : item.dgrsSmstr,
                    crclmnNo: item.crclmnNo,
                    sbjctId : item.sbjctId,
                    sbjctnm : item.sbjctnm,
                    dvclasNo: item.dvclasNo,
                    profnm  : item.profnm,
                    tutnm   : item.tutnm,
                    procRsn   : ` <span>\${procRsn}</span>
                                    <input type="text" id="\${item.sbjctId}_procRsn" style="display: none"> `,
                    procSdttm : `<span>\${procSdttm}</span>
                                   <div name="\${item.sbjctId}_procDttm" style="display: none">
                                       <input type="text" placeholder="시작일" id="\${item.sbjctId}_sDt" class="datepicker" toDate="\${item.sbjctId}_eDt" timeId="\${item.sbjctId}_sTm" style="max-width: 95px!important; min-width: unset!important;">
                                       <input type="text" placeholder="시작시간" id="\${item.sbjctId}_sTm" class="timepicker" dateId="\${item.sbjctId}_sDt" style="max-width: 70px!important; min-width: unset!important;">
                                   </div>`,
                    procEdttm : `<span>\${procEdttm}</span>
                                    <div name="\${item.sbjctId}_procDttm" style="display: none">
                                       <input type="text" placeholder="종료일" id="\${item.sbjctId}_eDt" class="datepicker" fromDate="\${item.sbjctId}_sDt" timeId="\${item.sbjctId}_eTm" style="max-width: 95px!important; min-width: unset!important;">
                                       <input type="text" placeholder="종료시간" id="\${item.sbjctId}_eTm" class="timepicker" dateId="\${item.sbjctId}_eDt" style="max-width: 70px!important; min-width: unset!important;">
                                    </div>`,
                    regDttm    : regDttm,
                })
            });

            return dataList;
        }

        // 날짜 포맷 변경
        function formatDttm(dttmStr) {
            if (!dttmStr || dttmStr.length < 14) return dttmStr;

            // 문자열을 위치대로 쪼개서 포맷 조립
            const yyyy = dttmStr.substring(0, 4);
            const MM   = dttmStr.substring(4, 6);
            const dd   = dttmStr.substring(6, 8);
            const HH   = dttmStr.substring(8, 10);
            const mm   = dttmStr.substring(10, 12);
            const ss   = dttmStr.substring(12, 14);

            return `\${yyyy}.\${MM}.\${dd} \${HH}:\${mm}`; // yyyy.MM.dd HH:mm
        }

        // 엑셀 다운로드
        function excelDown() {
            $("form[name='excelForm']").remove();
            var excelGrid = {
                colModel:[
                    {label:"<spring:message code='common.no' />", name:'lineNo', align:'center', width:'3000'}, /* 번호 */
                    {label:"<spring:message code='common.year' />", name:'dgrsYr', align:'center', width:'3000'}, /* 년도 */
                    {label:"<spring:message code='common.term' />", name:'dgrsSmstr', align:'center', width:'3000'}, /* 학기 */
                    {label:"<spring:message code='common.label.org' />", name:'orgnm', align:'center', width:'3000'}, /* 기관 */
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
            form.append($('<input/>', {type: 'hidden', name: 'dgrsYr', 	value: $("#dgrsYr").val()}));
            form.append($('<input/>', {type: 'hidden', name: 'smstrChrtId', value: $("#dgrsSmstrChrt").val()}));
            form.append($('<input/>', {type: 'hidden', name: 'orgId', 		value: $("#orgId").val()}));
            form.append($('<input/>', {type: 'hidden', name: 'deptId', 		value: ($("#deptId").val() || "").replace("ALL", "")}));
            form.append($('<input/>', {type: 'hidden', name: 'smstrChrtId', value: ($("#dgrsSmstrChrt").val() || "").replace("ALL", "")}));
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
                                    <select class="form-select" id="orgId" ${disabled}><!-- 기관 -->
                                        <option value="">기관</option>
                                        <c:forEach var="list" items="${filterOptions.orgList }">
                                            <option value="${list.orgId }" ${list.orgId eq filterOptions.orgId ? 'selected' : '' }>${list.orgnm }</option>
                                        </c:forEach>
                                    </select>
                                    <%--<select class="form-select" id="deptId">
                                        <option value=""><spring:message code="exam.label.dept" /></option><!-- 학과 -->
                                        <c:forEach var="list" items="${filterOptions.deptList }">
                                            <option value="${list.deptId }">${list.deptnm }</option>
                                        </c:forEach>
                                    </select>--%>
                                </div>
                            </div>

                            <div class="item">
                                <span class="item_tit"><label for="selectDate">학사년도/학기(기수)</label></span>
                                <div class="itemList">
                                    <select class="form-select" id="yrSmstr">
                                        <option value=""><spring:message code="msg.common.label.yearSmstr" /></option>
                                        <c:forEach var="item" items="${filterOptions.yrSmstrList }" varStatus="i">
                                            <option value="${item.dgrsYr}${item.dgrsSmstrChrt}" <%--${i.index eq 0 ? 'selected' : '' }--%> data-type="${item.smstrChrtGbncd}">${item.yrSmstrnm}</option>
                                        </c:forEach>
                                    </select>
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
                                    <input type="text" id="searchValue" name="searchValue" class="form-control w350" value="" placeholder="<spring:message code="lesson.common.placeholder3" />" autocomplete="off"/>
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="listPaging(1)"><spring:message code="sys.button.search" /></button>
                            </div>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title"><spring:message code="score.label.grade.input.date.exc" /></h3><%--성적처리 예외처리--%>
                            <div class="right-area">
                                <button type="button" class="btn type2" onclick="excpSave()"><spring:message code="common.button.save" /></button><%--저장--%>
                                <button type="button" class="btn type2" onclick="excpDelete()"><spring:message code="common.button.delete" /></button><%--삭제--%>
                                <button type="button" class="btn type2" onclick="openExcpListLogPop()"><spring:message code="score.label.exc.log" /></button><%--예외처리로그--%>
                                <button type="button" class="btn type2" onclick="excelDown()"><spring:message code="exam.button.excel.down" /></button><%--엑셀 다운로드--%>
                                <uiex:listScale func="changeRecoredCnt" value="${pageInfo.recordCountPerPage}" />
                            </div>
                        </div>

                        <div class="table-wrap">
                            <div id="excpList"></div>
                        </div>

                        <script type="text/javascript">
                            let excpListTable;

                            $(function () {

                                excpListTable = UiTable("excpList", {
                                    lang: "ko",
                                    table: "excpList",
                                    selectRow: "checkbox",
                                    columns: [
                                        {title: "<spring:message code='common.no'/>",                   field: "no",        headerHozAlign:"center", hozAlign:"center", width: 40, minWidth: 40},
                                        {title: "<spring:message code="common.label.org" />",           field: "orgnm",     headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 130, headerSort:true},
                                        {title: "<spring:message code="common.year" />",                field: "dgrsYr",    headerHozAlign: "center", hozAlign: "center", width: 70, minWidth: 70, headerSort:true},
                                        {title: "<spring:message code="common.term.cohort" />",         field: "dgrsSmstr", headerHozAlign: "center", hozAlign: "center", width: 95, minWidth: 95, headerSort:true},
                                        {title: "<spring:message code="common.label.crsauth.crscd" />", field: "crclmnNo",  headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100},
                                        {title: "<spring:message code="common.subject" />",             field: "sbjctnm",   headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 130},
                                        {title: "<spring:message code="common.label.decls.no" />",      field: "dvclasNo",  headerHozAlign: "center", hozAlign: "center", width: 45, minWidth: 45},
                                        {title: "<spring:message code="common.professor" />",           field: "profnm",    headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 65},
                                        {title: "<spring:message code="common.usertype.tutor" />",      field: "tutnm",     headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 65},
                                        {title: "<spring:message code="common.date.start.dt" />",       field: "procSdttm",headerHozAlign: "center", hozAlign: "center", width: 170, minWidth: 170},
                                        {title: "<spring:message code="common.date.end.dt" />",         field: "procEdttm",headerHozAlign: "center", hozAlign: "center", width: 170, minWidth: 170},
                                        {title: "<spring:message code="score.label.reason.exception" />",field: "procRsn", headerHozAlign: "center", hozAlign: "center", width: 150, minWidth: 150},
                                        {title: "<spring:message code="score.label.process.date" />",   field: "regDttm",  headerHozAlign: "center", hozAlign: "center", width: 140, minWidth: 140},
                                    ],
                                    pageFunc: listPaging,
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

    <script type="text/javascript">
        let dialog;

        // 예외처리 등록
        function excpSave() {
            const excpMapList = []; // Object배열
            const rows = excpListTable.getSelectedRows(); // 선택된 과목

            if (rows.length === 0) return UiComm.showMessage('<spring:message code="std.alert.no_select_crscre"/>', "warning"); <%-- 선택된 과목이 없습니다. --%>

            rows.forEach(row => {
                const rowData = row.getData();
                const sbjctId = rowData["sbjctId"];

                const sDateId = sbjctId + "_sDt";
                const sTimeId = sbjctId + "_sTm";
                const eDateId = sbjctId + "_eDt";
                const eTimeId = sbjctId + "_eTm";

                if ( !$("#" + sDateId).val() || !$("#" + sTimeId).val() || !$("#" + eDateId).val()|| !$("#" + eTimeId).val() ) {
                    return UiComm.showMessage('<spring:message code="common.required.object.msg"/>', "warning");<%-- 필수입력항목 값을 입력하세요. --%>
                }

                const data = {
                    sbjctId: sbjctId,
                    procSdttm: UiComm.getDateTimeVal(sDateId, sTimeId) + "00",
                    procEdttm: UiComm.getDateTimeVal(eDateId, eTimeId) + "59",
                    procRsn: $("#" + sbjctId + "_procRsn").val()
                };

                excpMapList.push(data);
            });

            if (excpMapList.length === 0) return false;

            $.ajax({
                url: "/mrk/admMrkProcExcpProcRegist.do",
                type : "POST",
                data: JSON.stringify(excpMapList),
                dataType: "json",
                headers: {"X-Requested-With": "XMLHttpRequest"},
                contentType : "application/json; charset=utf-8",
                success: function (data) {
                    if (data.result > 0) {
                        UiComm.showMessage('<spring:message code="info.regok.msg" />');<%-- 저장되었습니다. --%>
                        listPaging(CURRENT_PAGE_NO);
                    } else{
                        UiComm.showMessage(data.message, "error");
                    }
                },
                error: function(xhr, status, error) {
                    UiComm.showMessage('<spring:message code="fail.common.msg" />', "error"); // 에러가 발생했습니다!
                },
                complete: function () {
                    UiComm.showLoading(false);
                }
            });
        }

        // 예외처리 삭제
        function excpDelete() {
            const excpMapList = []; // Object배열
            const rows = excpListTable.getSelectedRows(); // 선택된 과목

            if (rows.length === 0) return UiComm.showMessage('<spring:message code="std.alert.no_select_crscre"/>', "warning"); <%-- 선택된 과목이 없습니다. --%>

            rows.forEach(row => {
                const rowData = row.getData();
                const sbjctId = rowData["sbjctId"];

                const data = {
                    mrkProcExcpProcId: rowData["mrkProcExcpProcId"] || "",
                    sbjctId: sbjctId
                };

                excpMapList.push(data);
            });

            if (excpMapList.length === 0) return false;

            $.ajax({
                url: "/mrk/admMrkProcExcpProcRegist.do",
                type : "POST",
                data: JSON.stringify(excpMapList),
                dataType: "json",
                headers: {"X-Requested-With": "XMLHttpRequest"},
                contentType : "application/json; charset=utf-8",
                success: function (data) {
                    if (data.result > 0) {
                        UiComm.showMessage('<spring:message code="common.alert.delete.success" />'); <%-- 삭제 완료하였습니다. --%>
                        listPaging(1);
                    } else{
                        UiComm.showMessage(data.message, "error");
                    }
                },
                error: function(xhr, status, error) {
                    UiComm.showMessage('<spring:message code="fail.common.msg" />', "error"); // 에러가 발생했습니다!
                },
                complete: function () {
                    UiComm.showLoading(false);
                }
            });
        }

        // 예외처리 로그 팝업 open
        function openExcpListLogPop() {
            dialog = UiDialog("mrkProcExcpProcListDialog", {
                title: "<spring:message code="score.label.grade.input.date.exc.log"/>", <%-- 성적처리 예외처리 로그 --%>
                width: 1200,
                height: 750,
                url: "/mrk/admAllMrkProcExcpProcListPop.do",
                // autoresize: true
            });
        }

        /**
         * 팝업 dialog 닫기 (window.parent.closeDialog()로 호출됨)
         */
        function closeDialog() {
            if (dialog) {
                dialog.close();
            }
        }
    </script>
</body>
</html>