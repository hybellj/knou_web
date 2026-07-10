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
        let RECORD_COUNT_PER_PAGE = Number('<c:out value="${param.recordCountPerPage}" />') || 10;
        let EPARAM = '<c:out value="${encParams}" />';
        let userLgnHstryTable;

        // 화면을 초기화하고 최초 목록을 조회한다.
        $(function () {
            $("#searchValue").on("keydown", function (e) {
                if (e.keyCode === 13) {
                    listPaging(1);
                }
            });

            userLgnHstryTable = UiTable("userLgnHstryList", {
                pageFunc: listPaging,
                columns: [
                    {title: "No", field: "no", headerHozAlign: "center", hozAlign: "center", width: 55, minWidth: 55, headerSort: false},
                    {title: "기관", field: "orgnm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 90, headerSort: false},
                    {title: "학과/부서", field: "deptnm", headerHozAlign: "center", hozAlign: "left", width: 0, minWidth: 120, headerSort: false},
                    {title: "대표ID", field: "userId", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 100, headerSort: false},
                    {title: "학번/사번", field: "stdntNo", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 100, headerSort: false},
                    {title: "이름", field: "usernm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 90, headerSort: false},
                    {title: "기기구분", field: "cntnDvcTycd", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 85, headerSort: false},
                    {title: "브라우저", field: "brwsrnm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 130, headerSort: false},
                    {title: "인증방법", field: "certMthdnm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 110, headerSort: false},
                    {title: "로그인 일시", field: "lgnDttm", headerHozAlign: "center", hozAlign: "center", width: 150, minWidth: 150, headerSort: false},
                    {title: "로그아웃 일시", field: "lgtDttm", headerHozAlign: "center", hozAlign: "center", width: 150, minWidth: 150, headerSort: false},
                    {title: "접속IP", field: "lgnIp", headerHozAlign: "center", hozAlign: "center", width: 120, minWidth: 120, headerSort: false}
                ]
            });

            listPaging(1);
        });

        // 현재 검색조건으로 로그인 이력 목록을 페이징 조회한다.
        function listPaging(pageIndex) {
            PAGE_INDEX = pageIndex;

            const extData = {
                orgId: $("#orgId").val(),
                currentPageNo: PAGE_INDEX,
                recordCountPerPage: RECORD_COUNT_PER_PAGE,
                pageSize: PAGE_SCALE,
                deptId: $("#deptId").val(),
                searchSdttm: getSearchDttm("dateSt", "timeSt", "00"),
                searchEdttm: getSearchDttm("dateEd", "timeEd", "59"),
                acsrTycds: getCheckedCodes("acsrTycdList"),
                searchValue: $("#searchValue").val()
            };

            const param = {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams(extData)
            };

            ajaxCall("/crs/opHstry/admUserLgnHstryListAjax.do", param, function (data) {
                if (data.encParams != null && data.encParams !== "") {
                    EPARAM = data.encParams;
                }

                if (data.result > 0) {
                    const returnList = data.returnList || [];
                    $("#totalCnt").text(data.pageInfo ? data.pageInfo.totalRecordCount : returnList.length);
                    userLgnHstryTable.clearData();
                    userLgnHstryTable.replaceData(createUserLgnHstryList(returnList, data.pageInfo));
                    userLgnHstryTable.setPageInfo(data.pageInfo);
                } else {
                    UiComm.showMessage(data.message || "조회 중 오류가 발생했습니다.", "error");
                }
            }, function () {
                UiComm.showMessage("조회 중 오류가 발생했습니다.", "error");
            }, true);
        }

        // 현재 검색조건으로 로그인 이력 엑셀 파일을 다운로드한다.
        function excelDown() {
            const columns = [
                {label: "No", name: "no", align: "center", width: "1000"},
                {label: "기관", name: "orgnm", align: "center", width: "3500"},
                {label: "학과/부서", name: "deptnm", align: "left", width: "4000"},
                {label: "대표ID", name: "userId", align: "center", width: "3000"},
                {label: "학번/사번", name: "stdntNo", align: "center", width: "3000"},
                {label: "이름", name: "usernm", align: "center", width: "3000"},
                {label: "기기구분", name: "cntnDvcTycd", align: "center", width: "2500"},
                {label: "브라우저", name: "brwsrnm", align: "center", width: "5000"},
                {label: "인증방법", name: "certMthdnm", align: "center", width: "3000"},
                {label: "로그인 일시", name: "lgnDttm", align: "center", width: "4000"},
                {label: "로그아웃 일시", name: "lgtDttm", align: "center", width: "4000"},
                {label: "접속IP", name: "lgnIp", align: "center", width: "3000"}
            ];

            $("form[name=excelForm]").remove();
            const excelForm = $('<form name="excelForm" method="post"></form>');
            excelForm.attr("action", "/crs/opHstry/admUserLgnHstryExcelDown.do");
            excelForm.append($('<input/>', {type: "hidden", name: "orgId", value: $("#orgId").val()}));
            excelForm.append($('<input/>', {type: "hidden", name: "deptId", value: $("#deptId").val()}));
            excelForm.append($('<input/>', {type: "hidden", name: "searchSdttm", value: getSearchDttm("dateSt", "timeSt", "00")}));
            excelForm.append($('<input/>', {type: "hidden", name: "searchEdttm", value: getSearchDttm("dateEd", "timeEd", "59")}));
            excelForm.append($('<input/>', {type: "hidden", name: "acsrTycds", value: getCheckedCodes("acsrTycdList")}));
            excelForm.append($('<input/>', {type: "hidden", name: "searchValue", value: $("#searchValue").val()}));
            excelForm.append($('<input/>', {type: "hidden", name: "excelGrid", value: JSON.stringify({colModel: columns})}));
            excelForm.appendTo("body");
            excelForm.submit();
        }

        // 서버 조회 결과를 테이블 표시용 데이터로 변환한다.
        function createUserLgnHstryList(list, pageInfo) {
            const dataList = [];
            if (!list || list.length === 0) {
                return dataList;
            }

            list.forEach(function (v) {
                const no = pageInfo ? pageInfo.totalRecordCount - v.lineNo + 1 : v.lineNo;
                dataList.push({
                    no: no,
                    orgnm: valueText(v.orgnm),
                    deptnm: valueText(v.deptnm),
                    userId: valueText(v.userId),
                    stdntNo: valueText(v.stdntNo),
                    usernm: valueText(v.usernm),
                    cntnDvcTycd: valueText(v.cntnDvcTycd),
                    brwsrnm: valueText(getBrowserName(v.lgnCntnBrwsr)),
                    certMthdnm: valueText(v.certMthdnm || v.certMthdCd),
                    lgnDttm: formatDttm(v.lgnDttm),
                    lgtDttm: formatDttm(v.lgtDttm),
                    lgnIp: valueText(v.lgnIp)
                });
            });

            return dataList;
        }

        // 날짜/시간 입력값을 yyyyMMddHHmmss 형식의 검색조건으로 변환한다.
        function getSearchDttm(dateId, timeId, sec) {
            const dateValue = UiComm.getDateTimeVal(dateId, null);
            if (dateValue === "") {
                return "";
            }

            let timeValue = $("#" + timeId).val().replaceAll(":", "");
            if (timeValue === "") {
                timeValue = sec === "59" ? "2359" : "0000";
                return dateValue + timeValue + sec;
            }
            return UiComm.getDateTimeVal(dateId, timeId) + sec;
        }

        // 선택된 체크박스 값을 콤마 구분 문자열로 반환한다.
        function getCheckedCodes(name) {
            const codes = [];
            $("input[name='" + name + "']:checked").each(function () {
                codes.push($(this).val());
            });
            return codes.join(",");
        }

        // 일시 문자열을 화면 표시 형식으로 변환한다.
        function formatDttm(value) {
            if (!value) {
                return "-";
            }
            return UiComm.formatDate(value, "datetime2");
        }

        // User-Agent 문자열에서 브라우저 표시명을 추출한다.
        function getBrowserName(userAgent) {
            if (!userAgent) {
                return "";
            }

            const ua = String(userAgent);
            if (ua.indexOf("Edg/") > -1) return "Edge";
            if (ua.indexOf("Chrome/") > -1) return "Chrome";
            if (ua.indexOf("Firefox/") > -1) return "Firefox";
            if (ua.indexOf("Safari/") > -1) return "Safari";
            return ua;
        }

        // 빈 값을 목록 표시용 대체 문자열로 변환한다.
        function valueText(value) {
            if (value === null || value === undefined || value === "") {
                return "-";
            }
            return value;
        }

        // 목록 표시 건수를 변경하고 첫 페이지를 다시 조회한다.
        function changeListScale(listScale) {
            RECORD_COUNT_PER_PAGE = listScale;
            listPaging(1);
        }
    </script>
</head>
<body class="admin">
<div id="wrap" class="main">
    <jsp:include page="/WEB-INF/jsp/common_new/admin_header.jsp"/>

    <main class="common">
        <jsp:include page="/WEB-INF/jsp/common_new/admin_aside.jsp"/>

        <div id="content" class="content-wrap common">
            <div class="admin_sub">
                <div class="sub-content">
                    <div class="page-info">
                        <h2 class="page-title">로그인 이력</h2>
                        <uiex:navibar type="admin"/>
                    </div>

                    <input type="hidden" id="orgId" name="orgId" value="<c:out value='${userLgnHstryVO.orgId}'/>"/>

                    <div class="search-typeA">
                        <div class="item">
                            <span class="item_tit">기관</span>
                            <div class="itemList">
                                <c:out value="${userCtx.loginUser.orgnm}"/>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit"><label for="deptId">학과/부서</label></span>
                            <div class="itemList">
                                <select id="deptId" name="deptId" class="form-select" title="학과/부서" style="width:220px;">
                                    <option value="">전체</option>
                                    <c:forEach var="dept" items="${deptList}">
                                        <option value="${dept.deptId}" ${dept.deptId eq userLgnHstryVO.deptId ? 'selected' : ''}>
                                            <c:out value="${dept.deptnm}"/>
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit">기간</span>
                            <div class="itemList">
                                <input id="dateSt" type="text" name="dateSt" class="datepicker" timeId="timeSt" toDate="dateEd">
                                <input id="timeSt" type="text" name="timeSt" class="timepicker" dateId="dateSt">
                                <span class="txt-sort">~</span>
                                <input id="dateEd" type="text" name="dateEd" class="datepicker" timeId="timeEd" fromDate="dateSt">
                                <input id="timeEd" type="text" name="timeEd" class="timepicker" dateId="dateEd">
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit">사용자구분</span>
                            <div class="itemList">
                                <div class="checkbox_type">
                                    <span class="custom-input"><input type="checkbox" name="acsrTycdList" id="acsrStdnt" value="STDNT"><label for="acsrStdnt">수강생</label></span>
                                    <span class="custom-input"><input type="checkbox" name="acsrTycdList" id="acsrProf" value="PROF"><label for="acsrProf">교수</label></span>
                                    <span class="custom-input"><input type="checkbox" name="acsrTycdList" id="acsrTut" value="TUT"><label for="acsrTut">튜터</label></span>
                                    <span class="custom-input"><input type="checkbox" name="acsrTycdList" id="acsrTa" value="TA"><label for="acsrTa">조교</label></span>
                                </div>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit"><label for="searchValue">검색어</label></span>
                            <div class="itemList">
                                <input type="text" id="searchValue" name="searchValue" class="form-control w350" value="<c:out value='${userLgnHstryVO.searchValue}'/>" placeholder="대표ID/학번/사번/이름 입력" autocomplete="off"/>
                            </div>
                        </div>
                        <div class="button-area">
                            <button type="button" class="btn search" onclick="listPaging(1)">검색</button>
                        </div>
                    </div>

                    <div class="board_top">
                        <h3 class="board-title">목록</h3>
                        <div class="right-area">
                            <button type="button" class="btn type2" onclick="excelDown()">엑셀 다운로드</button>
                            <uiex:listScale func="changeListScale" value="10"/>
                        </div>
                    </div>

                    <div id="userLgnHstryList"></div>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>
