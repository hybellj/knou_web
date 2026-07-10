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
        let RECORD_COUNT_PER_PAGE = Number('<c:out value="${userActvHstryVO.recordCountPerPage}" />') || 10;
        let EPARAM = '<c:out value="${encParams}" />';
        let userActvHstryTable;

        $(function () {
            $("#searchValue").on("keydown", function (e) {
                if (e.keyCode === 13) {
                    listPaging(1);
                }
            });

            $("#smstrChrtId, #deptId").on("change", function () {
                loadSbjctList(true);
            });

            $("#sbjctId, #srvcActnGbncd").on("change", function () {
                listPaging(1);
            });

            userActvHstryTable = UiTable("userActvHstryList", {
                pageFunc: listPaging,
                columns: [
                    {title: "No", field: "no", headerHozAlign: "center", hozAlign: "center", width: 55, minWidth: 55, headerSort: false},
                    {title: "년도", field: "dgrsYr", headerHozAlign: "center", hozAlign: "center", width: 70, minWidth: 70, headerSort: false},
                    {title: "학기", field: "dgrsSmstrChrt", headerHozAlign: "center", hozAlign: "center", width: 70, minWidth: 70, headerSort: false},
                    {title: "기관", field: "orgnm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 100, headerSort: false},
                    {title: "학과/부서", field: "deptnm", headerHozAlign: "center", hozAlign: "left", width: 0, minWidth: 120, headerSort: false},
                    {title: "과목", field: "sbjctnm", headerHozAlign: "center", hozAlign: "left", width: 0, minWidth: 180, headerSort: false},
                    {title: "대표ID", field: "userId", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 100, headerSort: false},
                    {title: "학번/사번", field: "stdntNo", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 100, headerSort: false},
                    {title: "이름", field: "usernm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 90, headerSort: false},
                    {title: "액션구분", field: "srvcActnGbnnm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 120, headerSort: false},
                    {title: "액션내용", field: "srvcActnExpln", headerHozAlign: "center", hozAlign: "left", width: 0, minWidth: 200, headerSort: false},
                    {title: "요청URL", field: "userReqUrl", headerHozAlign: "center", hozAlign: "left", width: 0, minWidth: 240, headerSort: false},
                    {title: "접속일시", field: "actvDttm", headerHozAlign: "center", hozAlign: "center", width: 150, minWidth: 150, headerSort: false},
                    {title: "접속IP", field: "cntnIp", headerHozAlign: "center", hozAlign: "center", width: 120, minWidth: 120, headerSort: false}
                ]
            });

            listPaging(1);
        });

        function listPaging(pageIndex) {
            PAGE_INDEX = pageIndex;

            const extData = {
                orgId: $("#orgId").val(),
                currentPageNo: PAGE_INDEX,
                recordCountPerPage: RECORD_COUNT_PER_PAGE,
                pageSize: PAGE_SCALE,
                smstrChrtId: $("#smstrChrtId").val(),
                deptId: $("#deptId").val(),
                sbjctId: $("#sbjctId").val(),
                srvcActnGbncd: $("#srvcActnGbncd").val(),
                searchSdttm: getSearchDttm("dateSt", "timeSt", "00"),
                searchEdttm: getSearchDttm("dateEd", "timeEd", "59"),
                userTycds: getCheckedCodes("userTycdList"),
                searchValue: $("#searchValue").val()
            };

            const param = {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams(extData)
            };

            ajaxCall("/crs/opHstry/admUserActvHstryListAjax.do", param, function (data) {
                if (data.encParams != null && data.encParams !== "") {
                    EPARAM = data.encParams;
                }

                if (data.result > 0) {
                    const returnList = data.returnList || [];
                    $("#totalCnt").text(data.pageInfo ? data.pageInfo.totalRecordCount : returnList.length);
                    userActvHstryTable.clearData();
                    userActvHstryTable.replaceData(createUserActvHstryList(returnList, data.pageInfo));
                    userActvHstryTable.setPageInfo(data.pageInfo);
                } else {
                    UiComm.showMessage(data.message || "조회 중 오류가 발생했습니다.", "error");
                }
            }, function () {
                UiComm.showMessage("조회 중 오류가 발생했습니다.", "error");
            }, true);
        }

        function loadSbjctList(triggerSearch) {
            const extData = {
                orgId: $("#orgId").val(),
                smstrChrtId: $("#smstrChrtId").val(),
                deptId: $("#deptId").val()
            };

            const param = {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams(extData)
            };

            ajaxCall("/crs/opHstry/admUserActvHstrySbjctListAjax.do", param, function (data) {
                if (data.encParams != null && data.encParams !== "") {
                    EPARAM = data.encParams;
                }

                const $sbjct = $("#sbjctId");
                $sbjct.empty().append($("<option/>", {value: "", text: "전체"}));

                (data.returnList || []).forEach(function (v) {
                    let text = v.sbjctnm || "";
                    if (v.dvclasNo) {
                        text += " (" + v.dvclasNo + "반)";
                    }
                    if (v.crclmnNo) {
                        text += " [" + v.crclmnNo + "]";
                    }
                    $sbjct.append($("<option/>", {value: v.sbjctId, text: text}));
                });

                $sbjct.val("").trigger("chosen:updated");

                if (triggerSearch) {
                    listPaging(1);
                }
            }, function () {
                UiComm.showMessage("과목 조회 중 오류가 발생했습니다.", "error");
                if (triggerSearch) {
                    listPaging(1);
                }
            }, true);
        }

        function excelDown() {
            const columns = [
                {label: "No", name: "no", align: "center", width: "1000"},
                {label: "년도", name: "dgrsYr", align: "center", width: "2000"},
                {label: "학기", name: "dgrsSmstrChrt", align: "center", width: "2000"},
                {label: "기관", name: "orgnm", align: "center", width: "3500"},
                {label: "학과/부서", name: "deptnm", align: "left", width: "4000"},
                {label: "과목", name: "sbjctnm", align: "left", width: "6000"},
                {label: "대표ID", name: "userId", align: "center", width: "3000"},
                {label: "학번/사번", name: "stdntNo", align: "center", width: "3000"},
                {label: "이름", name: "usernm", align: "center", width: "3000"},
                {label: "액션구분", name: "srvcActnGbnnm", align: "center", width: "3000"},
                {label: "액션내용", name: "srvcActnExpln", align: "left", width: "6000"},
                {label: "요청URL", name: "userReqUrl", align: "left", width: "7000"},
                {label: "접속일시", name: "actvDttm", align: "center", width: "4000"},
                {label: "접속IP", name: "cntnIp", align: "center", width: "3000"}
            ];

            $("form[name=excelForm]").remove();
            const excelForm = $('<form name="excelForm" method="post"></form>');
            excelForm.attr("action", "/crs/opHstry/admUserActvHstryExcelDown.do");
            excelForm.append($('<input/>', {type: "hidden", name: "orgId", value: $("#orgId").val()}));
            excelForm.append($('<input/>', {type: "hidden", name: "smstrChrtId", value: $("#smstrChrtId").val()}));
            excelForm.append($('<input/>', {type: "hidden", name: "deptId", value: $("#deptId").val()}));
            excelForm.append($('<input/>', {type: "hidden", name: "sbjctId", value: $("#sbjctId").val()}));
            excelForm.append($('<input/>', {type: "hidden", name: "srvcActnGbncd", value: $("#srvcActnGbncd").val()}));
            excelForm.append($('<input/>', {type: "hidden", name: "searchSdttm", value: getSearchDttm("dateSt", "timeSt", "00")}));
            excelForm.append($('<input/>', {type: "hidden", name: "searchEdttm", value: getSearchDttm("dateEd", "timeEd", "59")}));
            excelForm.append($('<input/>', {type: "hidden", name: "userTycds", value: getCheckedCodes("userTycdList")}));
            excelForm.append($('<input/>', {type: "hidden", name: "searchValue", value: $("#searchValue").val()}));
            excelForm.append($('<input/>', {type: "hidden", name: "excelGrid", value: JSON.stringify({colModel: columns})}));
            excelForm.appendTo("body");
            excelForm.submit();
        }

        function createUserActvHstryList(list, pageInfo) {
            const dataList = [];
            if (!list || list.length === 0) {
                return dataList;
            }

            list.forEach(function (v) {
                const no = pageInfo ? pageInfo.totalRecordCount - v.lineNo + 1 : v.lineNo;
                dataList.push({
                    no: no,
                    dgrsYr: valueText(v.dgrsYr),
                    dgrsSmstrChrt: valueText(v.dgrsSmstrChrt),
                    orgnm: valueText(v.orgnm),
                    deptnm: valueText(v.deptnm),
                    sbjctnm: valueText(v.sbjctnm),
                    userId: valueText(v.userId),
                    stdntNo: valueText(v.stdntNo),
                    usernm: valueText(v.usernm),
                    srvcActnGbnnm: valueText(v.srvcActnGbnnm),
                    srvcActnExpln: valueText(v.srvcActnExpln),
                    userReqUrl: valueText(v.userReqUrl),
                    actvDttm: v.actvDttm ? UiComm.formatDate(v.actvDttm, "datetime2") : "-",
                    cntnIp: valueText(v.cntnIp)
                });
            });

            return dataList;
        }

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

        function getCheckedCodes(name) {
            const codes = [];
            $("input[name='" + name + "']:checked").each(function () {
                codes.push($(this).val());
            });
            return codes.join(",");
        }

        function valueText(value) {
            if (value === null || value === undefined || value === "") {
                return "-";
            }
            return value;
        }

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
                        <h2 class="page-title">사용자접속이력</h2>
                        <uiex:navibar type="admin"/>
                    </div>

                    <input type="hidden" id="orgId" name="orgId" value="<c:out value='${userActvHstryVO.orgId}'/>"/>

                    <div class="search-typeA">
                        <div class="item">
                            <span class="item_tit">기관</span>
                            <div class="itemList">
                                <c:out value="${userCtx.loginUser.orgnm}"/>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit"><label for="smstrChrtId">년도/학기</label></span>
                            <div class="itemList">
                                <select class="form-select" id="smstrChrtId" name="smstrChrtId" title="년도/학기" style="width:300px;">
                                    <option value="">전체</option>
                                    <c:forEach var="item" items="${yrSmstrList}">
                                        <option value="${item.smstrChrtId}" ${item.smstrChrtId eq userActvHstryVO.smstrChrtId ? 'selected' : ''}>
                                            <c:out value="${item.smstrChrtnm}"/>
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit"><label for="deptId">학과/부서</label></span>
                            <div class="itemList">
                                <select id="deptId" name="deptId" class="form-select" title="학과/부서" style="width:220px;">
                                    <option value="">전체</option>
                                    <c:forEach var="dept" items="${deptList}">
                                        <option value="${dept.deptId}" ${dept.deptId eq userActvHstryVO.deptId ? 'selected' : ''}>
                                            <c:out value="${dept.deptnm}"/>
                                        </option>
                                    </c:forEach>
                                </select>
                                <select id="sbjctId" name="sbjctId" class="form-select" title="과목" style="width:300px;">
                                    <option value="">전체</option>
                                    <c:forEach var="sbjct" items="${sbjctList}">
                                        <option value="${sbjct.sbjctId}" ${sbjct.sbjctId eq userActvHstryVO.sbjctId ? 'selected' : ''}>
                                            <c:out value="${sbjct.sbjctnm}"/>
                                            <c:if test="${not empty sbjct.dvclasNo}"> (<c:out value="${sbjct.dvclasNo}"/>반)</c:if>
                                            <c:if test="${not empty sbjct.crclmnNo}"> [<c:out value="${sbjct.crclmnNo}"/>]</c:if>
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
                                    <span class="custom-input"><input type="checkbox" name="userTycdList" id="userTyStdnt" value="STDNT"><label for="userTyStdnt">학습자</label></span>
                                    <span class="custom-input"><input type="checkbox" name="userTycdList" id="userTyProf" value="PROF"><label for="userTyProf">교수</label></span>
                                    <span class="custom-input"><input type="checkbox" name="userTycdList" id="userTyTut" value="TUT"><label for="userTyTut">튜터</label></span>
                                    <span class="custom-input"><input type="checkbox" name="userTycdList" id="userTyTa" value="TA"><label for="userTyTa">조교</label></span>
                                </div>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit"><label for="srvcActnGbncd">액션구분</label></span>
                            <div class="itemList">
                                <select id="srvcActnGbncd" name="srvcActnGbncd" class="form-select" title="액션구분" style="width:220px;">
                                    <option value="">전체</option>
                                    <c:forEach var="code" items="${srvcActnGbncdList}">
                                        <option value="${code.cd}" ${code.cd eq userActvHstryVO.srvcActnGbncd ? 'selected' : ''}>
                                            <c:out value="${code.cdnm}"/>
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit"><label for="searchValue">검색어</label></span>
                            <div class="itemList">
                                <input type="text" id="searchValue" name="searchValue" class="form-control w350" value="<c:out value='${userActvHstryVO.searchValue}'/>" placeholder="대표ID/학번/사번/이름" autocomplete="off"/>
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

                    <div id="userActvHstryList"></div>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>
