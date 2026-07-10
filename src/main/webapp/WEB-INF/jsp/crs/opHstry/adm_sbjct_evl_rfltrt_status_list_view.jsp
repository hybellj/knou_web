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
        let EPARAM = '<c:out value="${encParams}" />';
        let evlRfltrtStatusTable;

        $(function () {
            // 검색어 입력 후 Enter로 목록을 다시 조회한다.
            $("#searchValue").on("keydown", function (e) {
                if (e.keyCode === 13) {
                    listSearch();
                }
            });

            $(document).on("change", ".op-hstry-msg-target", function () {
                syncMsgTargetHeader($(this).data("roleCd"));
            });

            $(document).on("change", ".op-hstry-msg-target-all", function () {
                toggleMsgTargetAll($(this).data("roleCd"), this.checked);
            });

            listSearch();
        });

        /**
         * 과목별 평가비중 시행현황 목록을 조회한다.
         */
        function listSearch() {
            const extData = {
                orgId: $("#orgId").val(),
                smstrChrtId: $("#smstrChrtId").val(),
                searchValue: $("#searchValue").val(),
                missingTyCds: getCheckedCodes("missingTyCdList"),
                wrongTyCds: getCheckedCodes("wrongTyCdList")
            };

            const param = {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams(extData)
            };

            ajaxCall("/crs/opHstry/admSbjctEvlRfltrtStatusListAjax.do", param, function (data) {
                if (data.encParams != null && data.encParams !== "") {
                    EPARAM = data.encParams;
                }

                if (data.result > 0) {
                    const returnList = data.returnList || [];
                    $("#totalCnt").text(returnList.length);
                    evlRfltrtStatusTable.clearData();
                    evlRfltrtStatusTable.replaceData(createEvlRfltrtStatusList(returnList));
                    resetMsgTargetHeader();
                } else {
                    UiComm.showMessage(data.message || "조회 중 오류가 발생했습니다.", "error");
                }
            }, function () {
                UiComm.showMessage("조회 중 오류가 발생했습니다.", "error");
            }, true);
        }

        /**
         * 현재 검색 조건에 맞는 과목별 평가비중 시행현황 목록을 엑셀로 다운로드한다.
         */
        function excelDown() {
            const columns = [
                {label: "No", name: "no", align: "center", width: "1000"},
                {label: "기관", name: "orgnm", align: "center", width: "3500"},
                {label: "년도", name: "dgrsYr", align: "center", width: "2000"},
                {label: "학기", name: "dgrsSmstrChrt", align: "center", width: "2000"},
                {label: "과목코드", name: "crclmnNo", align: "center", width: "3000"},
                {label: "과목명", name: "sbjctnm", align: "left", width: "6000"},
                {label: "분반", name: "dvclasNo", align: "center", width: "1500"},
                {label: "교수", name: "profUsernm", align: "center", width: "3000"},
                {label: "튜터", name: "tutUsernm", align: "center", width: "3000"},
                {label: "과제 평가비중", name: "asmt", align: "center", width: "3000", wrapText: "true"},
                {label: "토론 평가비중", name: "dscs", align: "center", width: "3000", wrapText: "true"},
                {label: "퀴즈 평가비중", name: "quiz", align: "center", width: "3000", wrapText: "true"},
                {label: "설문 평가비중", name: "srvy", align: "center", width: "3000", wrapText: "true"},
                {label: "세미나 평가비중", name: "smnr", align: "center", width: "3000", wrapText: "true"},
                {label: "시험 평가비중", name: "exam", align: "center", width: "3000", wrapText: "true"}
            ];

            $("form[name=excelForm]").remove();
            const excelForm = $('<form name="excelForm" method="post"></form>');
            excelForm.attr("action", "/crs/opHstry/admSbjctEvlRfltrtStatusExcelDown.do");
            excelForm.append($('<input/>', {type: "hidden", name: "orgId", value: $("#orgId").val()}));
            excelForm.append($('<input/>', {type: "hidden", name: "smstrChrtId", value: $("#smstrChrtId").val()}));
            excelForm.append($('<input/>', {type: "hidden", name: "searchValue", value: $("#searchValue").val()}));
            excelForm.append($('<input/>', {type: "hidden", name: "missingTyCds", value: getCheckedCodes("missingTyCdList")}));
            excelForm.append($('<input/>', {type: "hidden", name: "wrongTyCds", value: getCheckedCodes("wrongTyCdList")}));
            excelForm.append($('<input/>', {type: "hidden", name: "excelGrid", value: JSON.stringify({colModel: columns})}));
            excelForm.appendTo("body");
            excelForm.submit();
        }

        /**
         * 선택한 평가항목 코드를 콤마 문자열로 변환한다.
         */
        function getCheckedCodes(name) {
            const codes = [];
            $("input[name='" + name + "']:checked").each(function () {
                codes.push($(this).val());
            });
            return codes.join(",");
        }

        /**
         * 서버 조회 목록을 UiTable 데이터로 변환한다.
         */
        function createEvlRfltrtStatusList(list) {
            const dataList = [];
            if (!list || list.length === 0) {
                return dataList;
            }

            list.forEach(function (v, index) {
                dataList.push({
                    no: list.length - index,
                    orgnm: escapeText(v.orgnm),
                    dgrsYr: escapeText(v.dgrsYr),
                    dgrsSmstrChrt: escapeText(v.dgrsSmstrChrt),
                    sbjctId: normalizeText(v.sbjctId),
                    crclmnNo: escapeText(v.crclmnNo),
                    sbjctnm: escapeText(v.sbjctnm),
                    dvclasNo: escapeText(v.dvclasNo),
                    profUserId: normalizeText(v.profUserId),
                    profUsernm: normalizeText(v.profUsernm),
                    tutUserId: normalizeText(v.tutUserId),
                    tutUsernm: normalizeText(v.tutUsernm),
                    asmt: createStatusHtml(v, "asmt"),
                    dscs: createStatusHtml(v, "dscs"),
                    quiz: createStatusHtml(v, "quiz"),
                    srvy: createStatusHtml(v, "srvy"),
                    smnr: createStatusHtml(v, "smnr"),
                    exam: createStatusHtml(v, "exam")
                });
            });

            return dataList;
        }

        /**
         * 교수/튜터 헤더에 현재 목록 전체 선택 체크박스를 표시한다.
         */
        function createMsgTargetHeaderFormatter(roleCd, roleNm) {
            return function () {
                const checkboxId = "msgTargetAll" + roleCd;
                return "<span class=\"custom-input\">"
                    + "<input type=\"checkbox\" class=\"op-hstry-msg-target-all\" id=\"" + checkboxId + "\" data-role-cd=\"" + escapeAttr(roleCd) + "\">"
                    + "<label for=\"" + checkboxId + "\">" + roleNm + "</label>"
                    + "</span>";
            };
        }

        /**
         * 교수/튜터 셀에 메시지 대상 선택 체크박스를 표시한다.
         */
        function createMsgTargetFormatter(roleCd, roleNm, userIdField, usernmField) {
            return function (cell) {
                const rowData = cell.getRow().getData();
                const userId = rowData[userIdField];
                const usernm = rowData[usernmField];

                if (!userId || !usernm) {
                    return "-";
                }

                const checkboxId = "msgTarget" + roleCd + "_" + rowData.sbjctId;
                return "<span class=\"custom-input\">"
                    + "<input type=\"checkbox\" class=\"op-hstry-msg-target\" id=\"" + escapeAttr(checkboxId) + "\""
                    + " data-role-cd=\"" + escapeAttr(roleCd) + "\""
                    + " data-role-nm=\"" + escapeAttr(roleNm) + "\""
                    + " data-user-id=\"" + escapeAttr(userId) + "\""
                    + " data-user-nm=\"" + escapeAttr(usernm) + "\""
                    + " data-sbjct-id=\"" + escapeAttr(rowData.sbjctId) + "\""
                    + " data-sbjct-nm=\"" + escapeAttr(rowData.sbjctnm) + "\""
                    + ">"
                    + "<label for=\"" + escapeAttr(checkboxId) + "\">" + escapeText(usernm) + "</label>"
                    + "</span>";
            };
        }

        /**
         * 교수/튜터 헤더 체크박스 선택 상태를 해당 역할의 전체 행에 적용한다.
         */
        function toggleMsgTargetAll(roleCd, checked) {
            $(".op-hstry-msg-target[data-role-cd='" + roleCd + "']").prop("checked", checked);
            syncMsgTargetHeader(roleCd);
        }

        /**
         * 목록 재조회 후 교수/튜터 헤더 체크박스를 초기화한다.
         */
        function resetMsgTargetHeader() {
            ["PROF", "TUT"].forEach(function (roleCd) {
                $("#msgTargetAll" + roleCd).prop({checked: false, indeterminate: false});
            });
        }

        /**
         * 개별 체크박스 선택 상태에 맞춰 헤더 체크박스의 checked/indeterminate 상태를 동기화한다.
         */
        function syncMsgTargetHeader(roleCd) {
            const $items = $(".op-hstry-msg-target[data-role-cd='" + roleCd + "']");
            const $checked = $items.filter(":checked");
            $("#msgTargetAll" + roleCd).prop({
                checked: $items.length > 0 && $items.length === $checked.length,
                indeterminate: $checked.length > 0 && $items.length !== $checked.length
            });
        }

        /**
         * 선택 대상자를 수집한 뒤 공통 메시지 발송 다이얼로그로 넘긴다.
         */
        function openMsgSendDialog() {
            const targetList = getSelectedMsgTargets();
            if (targetList.length === 0) {
                UiComm.showMessage("메시지를 보낼 대상을 선택해 주세요.", "warning");
                return;
            }

            // TODO: 메시지보내기
            UiComm.showMessage("개발예정, 선택 대상: " + targetList.length + "명", "warning");
        }

        /**
         * 선택된 교수/튜터 체크박스에서 메시지 발송 대상자를 수집한다.
         */
        function getSelectedMsgTargets() {
            const targetList = [];
            const userMap = {};

            $(".op-hstry-msg-target:checked").each(function () {
                const $target = $(this);
                const userId = $target.data("userId");
                if (!userId || userMap[userId]) {
                    return;
                }

                userMap[userId] = true;
                targetList.push({
                    userId: userId,
                    usernm: $target.data("userNm"),
                    roleCd: $target.data("roleCd"),
                    roleNm: $target.data("roleNm"),
                    sbjctId: $target.data("sbjctId"),
                    sbjctnm: $target.data("sbjctNm")
                });
            });

            return targetList;
        }

        /**
         * 평가항목 상태 표시 HTML을 생성한다.
         * 평가비중과 개설 건수가 모두 없으면 '-'만 표시한다.
         */
        function createStatusHtml(item, prefix) {
            const statusCd = String(item[prefix + "StatusCd"] || "NONE");
            const openCnt = item[prefix + "OpenCnt"];
            const rate = item[prefix + "Rfltrt"];
            const hasRate = rate !== null && rate !== undefined && String(rate) !== "";

            if (statusCd === "NONE" && !hasRate) {
                return "-";
            }

            let statusText = getStatusName(statusCd);
            if (statusCd !== "MISS" && openCnt !== null && openCnt !== undefined && String(openCnt) !== "") {
                statusText += "(" + escapeText(openCnt) + ")";
            }

            return escapeText(statusText) + "<br/>" + (hasRate ? escapeText(rate) + "%" : "-");
        }

        /**
         * 평가항목 상태 코드를 화면 표시명으로 변환한다.
         */
        function getStatusName(statusCd) {
            if (statusCd === "MISS") return "미개설";
            if (statusCd === "WRONG") return "오개설";
            if (statusCd === "OPEN") return "개설";
            return "-";
        }

        /**
         * null 값을 빈 문자열로 정규화한다.
         */
        function normalizeText(value) {
            if (value === null || value === undefined) {
                return "";
            }
            return String(value);
        }

        /**
         * 목록 표시 문자열을 이스케이프한다. 빈 값은 '-'로 표시한다.
         */
        function escapeText(value) {
            const text = normalizeText(value);
            if (text === "") {
                return "-";
            }
            return UiComm.escapeHtml(text);
        }

        /**
         * HTML 속성에 출력할 값을 이스케이프한다.
         */
        function escapeAttr(value) {
            return UiComm.escapeHtml(normalizeText(value));
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
                        <h2 class="page-title">과목별 평가비중 시행현황</h2>
                        <uiex:navibar type="admin"/>
                    </div>

                    <input type="hidden" id="orgId" name="orgId" value="<c:out value='${evlRfltrtStatusVO.orgId}'/>"/>

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
                                        <option value="${item.smstrChrtId}" ${item.smstrChrtId eq evlRfltrtStatusVO.smstrChrtId ? 'selected' : ''}>
                                            <c:out value="${item.smstrChrtnm}"/>
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit">미개설</span>
                            <div class="itemList">
                                <div class="checkbox_type">
                                    <span class="custom-input"><input type="checkbox" name="missingTyCdList" id="missingAsmt" value="ASMT"><label for="missingAsmt">과제</label></span>
                                    <span class="custom-input"><input type="checkbox" name="missingTyCdList" id="missingDscs" value="DSCS"><label for="missingDscs">토론</label></span>
                                    <span class="custom-input"><input type="checkbox" name="missingTyCdList" id="missingQuiz" value="QUIZ"><label for="missingQuiz">퀴즈</label></span>
                                    <span class="custom-input"><input type="checkbox" name="missingTyCdList" id="missingSrvy" value="SRVY"><label for="missingSrvy">설문</label></span>
                                    <span class="custom-input"><input type="checkbox" name="missingTyCdList" id="missingSmnr" value="SMNR"><label for="missingSmnr">세미나</label></span>
                                    <span class="custom-input"><input type="checkbox" name="missingTyCdList" id="missingExam" value="EXAM"><label for="missingExam">시험</label></span>
                                </div>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit">오개설</span>
                            <div class="itemList">
                                <div class="checkbox_type">
                                    <span class="custom-input"><input type="checkbox" name="wrongTyCdList" id="wrongAsmt" value="ASMT"><label for="wrongAsmt">과제</label></span>
                                    <span class="custom-input"><input type="checkbox" name="wrongTyCdList" id="wrongDscs" value="DSCS"><label for="wrongDscs">토론</label></span>
                                    <span class="custom-input"><input type="checkbox" name="wrongTyCdList" id="wrongQuiz" value="QUIZ"><label for="wrongQuiz">퀴즈</label></span>
                                    <span class="custom-input"><input type="checkbox" name="wrongTyCdList" id="wrongSrvy" value="SRVY"><label for="wrongSrvy">설문</label></span>
                                    <span class="custom-input"><input type="checkbox" name="wrongTyCdList" id="wrongSmnr" value="SMNR"><label for="wrongSmnr">세미나</label></span>
                                    <span class="custom-input"><input type="checkbox" name="wrongTyCdList" id="wrongExam" value="EXAM"><label for="wrongExam">시험</label></span>
                                </div>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit"><label for="searchValue">검색어</label></span>
                            <div class="itemList">
                                <input type="text" id="searchValue" name="searchValue" class="form-control w350" value="<c:out value='${evlRfltrtStatusVO.searchValue}'/>" placeholder="과목코드/과목명/교수 검색" autocomplete="off"/>
                            </div>
                        </div>
                        <div class="button-area">
                            <button type="button" class="btn search" onclick="listSearch()">검색</button>
                        </div>
                    </div>

                    <div class="board_top">
                        <h3 class="board-title">과목 목록</h3>
                        <span class="total_num">총 <strong id="totalCnt">0</strong>건</span>
                        <div class="right-area">
                            <button type="button" class="btn basic" onclick="openMsgSendDialog()">메시지 보내기</button>
                            <button type="button" class="btn type2" onclick="excelDown()">엑셀 다운로드</button>
                        </div>
                    </div>

                    <div>
                        <div id="evlRfltrtStatusList"></div>
                        <script>
                            evlRfltrtStatusTable = UiTable("evlRfltrtStatusList", {
                                lang: "ko",
                                rowHeight: 70,
                                columnHeaderVertAlign: "middle",
                                columns: [
                                    {title: "No", field: "no", headerHozAlign: "center", hozAlign: "center", width: 40, minWidth: 40, headerSort: false},
                                    {title: "기관", field: "orgnm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 90, headerSort: true},
                                    {title: "년도", field: "dgrsYr", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 70, headerSort: true},
                                    {title: "학기", field: "dgrsSmstrChrt", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 70, headerSort: true},
                                    {title: "과목코드", field: "crclmnNo", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 70, headerSort: false},
                                    {title: "과목명", field: "sbjctnm", headerHozAlign: "center", hozAlign: "left", width: 0, minWidth: 200, headerSort: false},
                                    {title: "분반", field: "dvclasNo", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 60, headerSort: false},
                                    {title: "교수", field: "profUsernm", titleFormatter: createMsgTargetHeaderFormatter("PROF", "교수"), formatter: createMsgTargetFormatter("PROF", "교수", "profUserId", "profUsernm"), headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 120, headerSort: false},
                                    {title: "튜터", field: "tutUsernm", titleFormatter: createMsgTargetHeaderFormatter("TUT", "튜터"), formatter: createMsgTargetFormatter("TUT", "튜터", "tutUserId", "tutUsernm"), headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 120, headerSort: false},
                                    {
                                        title: "과제", headerHozAlign: "center", columns: [
                                            {title: "평가비중", field: "asmt", formatter: "html", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 85, headerSort: false}
                                        ]
                                    },
                                    {
                                        title: "토론", headerHozAlign: "center", columns: [
                                            {title: "평가비중", field: "dscs", formatter: "html", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 85, headerSort: false}
                                        ]
                                    },
                                    {
                                        title: "퀴즈", headerHozAlign: "center", columns: [
                                            {title: "평가비중", field: "quiz", formatter: "html", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 85, headerSort: false}
                                        ]
                                    },
                                    {
                                        title: "설문", headerHozAlign: "center", columns: [
                                            {title: "평가비중", field: "srvy", formatter: "html", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 85, headerSort: false}
                                        ]
                                    },
                                    {
                                        title: "세미나", headerHozAlign: "center", columns: [
                                            {title: "평가비중", field: "smnr", formatter: "html", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 85, headerSort: false}
                                        ]
                                    },
                                    {
                                        title: "시험", headerHozAlign: "center", columns: [
                                            {title: "평가비중", field: "exam", formatter: "html", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 85, headerSort: false}
                                        ]
                                    }
                                ]
                            });
                        </script>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>
