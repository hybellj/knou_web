<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>

    <script type="text/javascript">
        let PAGE_INDEX = 1;
        const PAGE_SCALE = 10;
        let RECORD_COUNT_PER_PAGE = 10;
        let EPARAM = '<c:out value="${encParams}" />';
        const SBJCT_ID = '<c:out value="${mrkProcStatusVO.sbjctId}" />';

        const MRK_PROC_HSTRY_TY_LIST = [
            <c:forEach var="code" items="${mrkProcHstryTyList}" varStatus="st">
            {cd: '<c:out value="${code.cd}" />', cdnm: '<c:out value="${code.cdnm}" />'}<c:if test="${!st.last}">, </c:if>
            </c:forEach>
        ];

        let mrkProcLogTable;

        $(function () {
            $("#searchValue").on("keydown", function (e) {
                if (e.keyCode === 13) {
                    listPaging(1);
                }
            });

            const columns = [
                {title: "No", field: "lineNo", headerHozAlign: "center", hozAlign: "center", width: 55, minWidth: 55, headerSort: false},
                {title: "대표ID", field: "userId", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 110, headerSort: false},
                {title: "학번", field: "stdntNo", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 110, headerSort: false},
                {title: "이름", field: "usernm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 90, headerSort: false},
                {title: "구분", field: "scrTynm", headerHozAlign: "center", hozAlign: "center", width: 55, minWidth: 55, headerSort: false}
            ];

            MRK_PROC_HSTRY_TY_LIST.forEach(function (code) {
                columns.push({
                    title: code.cdnm,
                    field: "scr_" + code.cd,
                    headerHozAlign: "center",
                    hozAlign: "center",
                    width: 0,
                    minWidth: 90,
                    headerSort: false
                });
            });

            columns.push({title: "처리일시", field: "regDttm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 135, headerSort: false});
            columns.push({title: "처리자", field: "rgtrnm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 90, headerSort: false});

            columns.forEach(function (column) {
                column.formatter = afterRowCellFormatter;
            });

            mrkProcLogTable = UiTable("mrkProcLogList", {
                lang: "ko",
                rowHeight: 38,
                pageFunc: listPaging,
                columnHeaderVertAlign: "middle",
                columns: columns,
                data: []
            });

            listPaging(1);
        });

        /**
         * 성적처리 로그 목록을 조회한다.
         */
        function listPaging(pageIndex) {
            PAGE_INDEX = pageIndex;

            const extData = {
                sbjctId: SBJCT_ID,
                searchValue: $("#searchValue").val(),
                currentPageNo: PAGE_INDEX,
                recordCountPerPage: RECORD_COUNT_PER_PAGE,
                pageSize: PAGE_SCALE
            };

            ajaxCall("/crs/opHstry/admMrkProcHstryListAjax.do", {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams(extData)
            }, function (data) {
                if (data.encParams != null && data.encParams !== "") {
                    EPARAM = data.encParams;
                }

                if (data.result > 0) {
                    const subjectInfo = (data.data || {}).subjectInfo || {};
                    const pageInfo = data.pageInfo || {};

                    $("#crclmnNo").text(displayValue(subjectInfo.crclmnNo));
                    $("#sbjctnm").text(displayValue(subjectInfo.sbjctnm));
                    $("#sbjctEnnm").text(displayValue(subjectInfo.sbjctEnnm));
                    $("#dvclasNo").text(displayValue(subjectInfo.dvclasNo));
                    $("#crdts").text(displayValue(subjectInfo.crdts));

                    mrkProcLogTable.clearData();
                    mrkProcLogTable.replaceData(createMrkProcLogRows(data.returnList || []));
                    mrkProcLogTable.setPageInfo(pageInfo);
                } else {
                    UiComm.showMessage(data.message || "조회 중 오류가 발생했습니다.", "error");
                }
            }, function () {
                UiComm.showMessage("조회 중 오류가 발생했습니다.", "error");
            }, true);
        }

        /**
         * listScale 변경
         */
        function changeListScale(scale) {
            RECORD_COUNT_PER_PAGE = scale;
            listPaging(1);
        }

        /**
         * 성적처리 로그 목록을 엑셀로 다운로드한다.
         */
        function excelDown() {
            const columns = [
                {label: "No", name: "lineNo", align: "center", width: "1000"},
                {label: "대표ID", name: "userId", align: "center", width: "3000"},
                {label: "학번", name: "stdntNo", align: "center", width: "3000"},
                {label: "이름", name: "usernm", align: "center", width: "2500"}
            ];

            MRK_PROC_HSTRY_TY_LIST.forEach(function (code) {
                columns.push({label: code.cdnm + "(전)", name: "scrBfr" + code.cd, align: "center", width: "2500"});
                columns.push({label: code.cdnm + "(후)", name: "scrAft" + code.cd, align: "center", width: "2500"});
            });

            columns.push({label: "처리일시", name: "regDttm", align: "center", width: "3500"});
            columns.push({label: "처리자", name: "rgtrnm", align: "center", width: "2500"});

            $("form[name=mrkProcLogExcelForm]").remove();
            const excelForm = $('<form name="mrkProcLogExcelForm" method="post"></form>');
            excelForm.attr("action", "/crs/opHstry/admMrkProcHstryExcelDown.do");
            excelForm.append($('<input/>', {type: "hidden", name: "sbjctId", value: SBJCT_ID}));
            excelForm.append($('<input/>', {type: "hidden", name: "searchValue", value: $("#searchValue").val()}));
            excelForm.append($('<input/>', {type: "hidden", name: "excelGrid", value: JSON.stringify({colModel: columns})}));
            excelForm.appendTo("body");
            excelForm.submit();
        }

        /**
         * 학생별 이력 행을 변경 전/후 2행으로 변환한다.
         */
        function createMrkProcLogRows(list) {
            const dataList = [];

            list.forEach(function (v) {
                const beforeRow = {
                    rowTy: "BFR",
                    lineNo: displayValue(v.lineNo),
                    userId: displayValue(v.userId),
                    stdntNo: displayValue(v.stdntNo),
                    usernm: displayValue(v.usernm),
                    scrTynm: "전",
                    regDttm: v.regDttm ? UiComm.formatDate(v.regDttm, "datetime2") : "-",
                    rgtrnm: displayValue(v.rgtrnm)
                };

                const afterRow = {
                    rowTy: "AFT",
                    lineNo: "",
                    userId: "",
                    stdntNo: "",
                    usernm: "",
                    scrTynm: "후",
                    regDttm: "",
                    rgtrnm: ""
                };

                MRK_PROC_HSTRY_TY_LIST.forEach(function (code) {
                    beforeRow["scr_" + code.cd] = displayValue(v["scrBfr" + code.cd]);
                    afterRow["scr_" + code.cd] = displayValue(v["scrAft" + code.cd]);
                });

                dataList.push(beforeRow);
                dataList.push(afterRow);
            });

            return dataList;
        }

        function displayValue(value) {
            return value === null || value === undefined || value === "" ? "-" : value;
        }

        function afterRowCellFormatter(cell) {
            if (cell.getRow().getData().rowTy === "AFT") {
                cell.getElement().classList.add("fcBlue");
            } else {
                cell.getElement().classList.remove("fcBlue");
            }

            return cell.getValue();
        }
    </script>
</head>
<body class="modal-page ${uiex:getTheme()}">

<%--<div class="sub-content">--%>
<div class="board_top">
    <h4 class="sub-title">과목 정보</h4>
</div>


<div class="table-wrap">
    <table class="table-type5">
        <colgroup>
            <col style="width:15%">
            <col>
            <col style="width:15%">
            <col>
        </colgroup>
        <tbody>
        <tr>
            <th scope="row">과목코드</th>
            <td id="crclmnNo">-</td>
            <th scope="row">분반</th>
            <td id="dvclasNo">-</td>
        </tr>
        <tr>
            <th scope="row">과목명(한글)</th>
            <td id="sbjctnm">-</td>
            <th scope="row">과목명(영문)</th>
            <td id="sbjctEnnm">-</td>
        </tr>
        <tr>
            <th scope="row">학과</th>
            <td id="deptnm">-</td>
            <th scope="row">학점</th>
            <td id="crdts">-</td>
        </tr>
        </tbody>
    </table>
</div>


<div class="board_top">
    <h4 class="sub-title">수강생
    </h4>
    <div class="right-area">
        <div class="search-typeC">
            <input type="text" id="searchValue" class="form-control" title="검색어" placeholder="대표ID/이름 입력" autocomplete="off"/>
            <button type="button" class="btn basic icon search" aria-label="검색" onclick="listPaging(1)"><i class="icon-svg-search"></i></button>
        </div>
        <button type="button" class="btn type2" onclick="excelDown()">엑셀 다운로드</button>
        <uiex:listScale func="changeListScale" value="10"/>
    </div>
</div>

<div class="table-wrap">
    <div id="mrkProcLogList"></div>
</div>

<div class="btns">
    <button type="button" class="btn type2" onclick="window.parent.closeDialog();">닫기</button>
</div>
<%--</div>--%>
</body>
</html>
