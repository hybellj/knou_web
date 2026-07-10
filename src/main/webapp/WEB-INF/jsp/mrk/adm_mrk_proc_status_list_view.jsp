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
        let mrkProcStatusTable;
        let dialog;

        $(function () {
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
         * 현재 검색 조건으로 성적처리현황 목록을 조회한다.
         */
        function listSearch() {
            const extData = {
                orgId: $("#orgId").val(),
                smstrChrtId: $("#smstrChrtId").val(),
                searchValue: $("#searchValue").val(),
                mrkProcStatusCds: getCheckedCodes("mrkProcStatusCdList")
            };

            const param = {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams(extData)
            };

            ajaxCall("/crs/opHstry/admMrkProcStatusListAjax.do", param, function (data) {
                if (data.encParams != null && data.encParams !== "") {
                    EPARAM = data.encParams;
                }

                if (data.result > 0) {
                    const returnList = data.returnList || [];
                    $("#totalCnt").text(returnList.length);
                    mrkProcStatusTable.clearData();
                    mrkProcStatusTable.replaceData(createMrkProcStatusList(returnList));
                    resetMsgTargetHeader();
                } else {
                    UiComm.showMessage(data.message || "조회 중 오류가 발생했습니다.", "error");
                }
            }, function () {
                UiComm.showMessage("조회 중 오류가 발생했습니다.", "error");
            }, true);
        }

        /**
         * 현재 검색 조건에 맞는 성적처리현황 목록을 엑셀로 다운로드한다.
         */
        function excelDown() {
            const columns = [
                {label: "No", name: "no", align: "center", width: "1000"},
                {label: "기관", name: "orgnm", align: "center", width: "3500"},
                {label: "년도", name: "dgrsYr", align: "center", width: "2000"},
                {label: "학기", name: "dgrsSmstrChrt", align: "center", width: "2000"},
                {label: "과목코드", name: "crclmnNo", align: "center", width: "3000"},
                {label: "과목", name: "sbjctnm", align: "left", width: "6000"},
                {label: "분반", name: "dvclasNo", align: "center", width: "1500"},
                {label: "교수", name: "profUsernm", align: "center", width: "3000"},
                {label: "튜터", name: "tutUsernm", align: "center", width: "3000"},
                {label: "기간 예외", name: "prdExcpYn", align: "center", width: "2000"},
                {label: "성적 산출 단계", name: "mrkProcStatusNm", align: "center", width: "3000"}
            ];

            $("form[name=excelForm]").remove();
            const excelForm = $('<form name="excelForm" method="post"></form>');
            excelForm.attr("action", "/crs/opHstry/admMrkProcStatusExcelDown.do");
            excelForm.append($('<input/>', {type: "hidden", name: "orgId", value: $("#orgId").val()}));
            excelForm.append($('<input/>', {type: "hidden", name: "smstrChrtId", value: $("#smstrChrtId").val()}));
            excelForm.append($('<input/>', {type: "hidden", name: "searchValue", value: $("#searchValue").val()}));
            excelForm.append($('<input/>', {type: "hidden", name: "mrkProcStatusCds", value: getCheckedCodes("mrkProcStatusCdList")}));
            excelForm.append($('<input/>', {type: "hidden", name: "excelGrid", value: JSON.stringify({colModel: columns})}));
            excelForm.appendTo("body");
            excelForm.submit();
        }

        /**
         * 선택된 체크박스 값을 콤마 구분 문자열로 변환한다.
         */
        function getCheckedCodes(name) {
            const codes = [];
            $("input[name='" + name + "']:checked").each(function () {
                codes.push($(this).val());
            });
            return codes.join(",");
        }

        /**
         * 서버 조회 목록을 UiTable에서 사용하는 행 데이터로 변환한다.
         */
        function createMrkProcStatusList(list) {
            const dataList = [];
            if (!list || list.length === 0) {
                return dataList;
            }

            list.forEach(function (v, index) {
                // 서버에서 계산한 MRK_PROC_STATUS_CD 기준으로 성적 산출 단계 4개 컬럼 중 하나만 강조한다.
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
                    prdExcpYn: escapeText(v.prdExcpYn || "N"),
                    mrkProcStatusCd: normalizeText(v.mrkProcStatusCd),
                    beforeStatus: createStepHtml(v.mrkProcStatusCd, "BEFORE"),
                    ingStatus: createStepHtml(v.mrkProcStatusCd, "ING"),
                    finalStatus: createStepHtml(v.mrkProcStatusCd, "FINAL"),
                    cancelStatus: createStepHtml(v.mrkProcStatusCd, "CANCEL"),
                    logBtn: createLogButton(v)
                });
            });

            return dataList;
        }

        /**
         * 성적 산출 단계 표시용 도형 HTML을 생성한다.
         */
        function createStepHtml(statusCd, targetCd) {
            // 인코딩 차이를 피하기 위해 원형 기호는 HTML 엔티티로 출력한다.
            if (statusCd === targetCd) {
                return '<span class="state_ok">●</span>';
            }
            return '<span class="state_ok">○</span>';
        }

        /**
         * 교수/튜터 컬럼 헤더에 전체 선택 체크박스를 표시한다.
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
         * 교수/튜터 메시지 대상 선택 체크박스를 행 단위로 표시한다.
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
         * 교수/튜터 전체 선택 체크박스 상태를 각 행 체크박스에 반영한다.
         */
        function toggleMsgTargetAll(roleCd, checked) {
            $(".op-hstry-msg-target[data-role-cd='" + roleCd + "']").prop("checked", checked);
            syncMsgTargetHeader(roleCd);
        }

        /**
         * 목록 재조회 후 교수/튜터 전체 선택 체크박스를 초기화한다.
         */
        function resetMsgTargetHeader() {
            ["PROF", "TUT"].forEach(function (roleCd) {
                $("#msgTargetAll" + roleCd).prop({checked: false, indeterminate: false});
            });
        }

        /**
         * 개별 선택 상태에 맞춰 교수/튜터 전체 선택 체크박스 상태를 동기화한다.
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
         * TODO
         * 선택한 교수/튜터 메시지 발송 대상을 확인하고 발송 화면을 호출한다.
         */
        function openMsgSendDialog() {
            const targetList = getSelectedMsgTargets();
            if (targetList.length === 0) {
                UiComm.showMessage("메시지를 보낼 대상을 선택해 주세요.", "info");
                return;
            }
            UiComm.showMessage("개발예정, 선택 대상 " + targetList.length + "명", "info");
        }

        /**
         * 선택된 교수/튜터 체크박스에서 메시지 발송 대상 목록을 수집한다.
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
         * 성적처리 로그 조회 버튼 HTML을 생성한다.
         */
        function createLogButton(item) {
            return "<button type=\"button\" class=\"btn basic small\" onclick=\"openMrkProcLog('" + escapeAttr(item.sbjctId) + "')\">보기</button>";
        }

        /**
         * 선택 과목의 성적처리 로그 팝업을 dialog로 호출한다.
         */
        function openMrkProcLog(sbjctId) {
            dialog = UiDialog("dialog1", {
                title: "성적처리 로그조회",
                width: 1480,
                height: 800,
                url: "/crs/opHstry/admMrkProcLogPop.do?sbjctId=" + encodeURIComponent(normalizeText(sbjctId)) + "&encParams=" + EPARAM,
                autoresize: true
            });
        }

        /**
         * UiDialog 팝업을 닫는다.
         */
        function closeDialog() {
            if (dialog) {
                dialog.close();
                dialog = null;
            }
        }

        /**
         * null 또는 undefined 값을 빈 문자열로 정규화한다.
         */
        function normalizeText(value) {
            if (value === null || value === undefined) {
                return "";
            }
            return String(value);
        }

        /**
         * 화면 표시용 문자열을 HTML 이스케이프하고 빈 값은 '-'로 표시한다.
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
                        <h2 class="page-title">성적처리현황</h2>
                        <uiex:navibar type="admin"/>
                    </div>

                    <input type="hidden" id="orgId" name="orgId" value="<c:out value='${mrkProcStatusVO.orgId}'/>"/>

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
                                        <option value="${item.smstrChrtId}" ${item.smstrChrtId eq mrkProcStatusVO.smstrChrtId ? 'selected' : ''}>
                                            <c:out value="${item.smstrChrtnm}"/>
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit">성적산출단계</span>
                            <div class="itemList">
                                <div class="checkbox_type">
                                    <span class="custom-input"><input type="checkbox" name="mrkProcStatusCdList" id="statusBefore" value="BEFORE"><label for="statusBefore">산출 전</label></span>
                                    <span class="custom-input"><input type="checkbox" name="mrkProcStatusCdList" id="statusIng" value="ING"><label for="statusIng">산출 중</label></span>
                                    <span class="custom-input"><input type="checkbox" name="mrkProcStatusCdList" id="statusFinal" value="FINAL"><label for="statusFinal">최종확정</label></span>
                                    <span class="custom-input"><input type="checkbox" name="mrkProcStatusCdList" id="statusCancel" value="CANCEL"><label for="statusCancel">평가취소</label></span>
                                </div>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit"><label for="searchValue">검색어</label></span>
                            <div class="itemList">
                                <input type="text" id="searchValue" name="searchValue" class="form-control w350" value="<c:out value='${mrkProcStatusVO.searchValue}'/>" placeholder="과목/과목코드/교수 입력" autocomplete="off"/>
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
                        <div id="mrkProcStatusList"></div>
                        <script>
                            mrkProcStatusTable = UiTable("mrkProcStatusList", {
                                lang: "ko",
                                rowHeight: 45,
                                columnHeaderVertAlign: "middle",
                                columns: [
                                    {title: "No", field: "no", headerHozAlign: "center", hozAlign: "center", width: 40, minWidth: 40, headerSort: false},
                                    {title: "기관", field: "orgnm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 90, headerSort: true},
                                    {title: "년도", field: "dgrsYr", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 70, headerSort: true},
                                    {title: "학기", field: "dgrsSmstrChrt", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 70, headerSort: true},
                                    {title: "과목코드", field: "crclmnNo", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 90, headerSort: false},
                                    {title: "과목", field: "sbjctnm", headerHozAlign: "center", hozAlign: "left", width: 0, minWidth: 180, headerSort: false},
                                    {title: "분반", field: "dvclasNo", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 60, headerSort: false},
                                    {title: "교수", field: "profUsernm", titleFormatter: createMsgTargetHeaderFormatter("PROF", "교수"), formatter: createMsgTargetFormatter("PROF", "교수", "profUserId", "profUsernm"), headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 120, headerSort: false},
                                    {title: "튜터", field: "tutUsernm", titleFormatter: createMsgTargetHeaderFormatter("TUT", "튜터"), formatter: createMsgTargetFormatter("TUT", "튜터", "tutUserId", "tutUsernm"), headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 120, headerSort: false},
                                    {title: "기간 예외", field: "prdExcpYn", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 80, headerSort: false},
                                    {
                                        title: "성적 산출 단계", headerHozAlign: "center", columns: [
                                            {title: "산출 전", field: "beforeStatus", formatter: "html", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 70, headerSort: false},
                                            {title: "산출 중", field: "ingStatus", formatter: "html", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 70, headerSort: false},
                                            {title: "최종확정", field: "finalStatus", formatter: "html", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 75, headerSort: false},
                                            {title: "평가취소", field: "cancelStatus", formatter: "html", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 75, headerSort: false}
                                        ]
                                    },
                                    {title: "성적처리<br/>로그", field: "logBtn", formatter: "html", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 90, headerSort: false}
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
