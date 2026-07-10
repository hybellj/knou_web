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
        let qnaStatsTable;

        $(function () {
            // 검색어 입력 후 Enter로 목록을 다시 조회한다.
            $("#searchValue").on("keydown", function (e) {
                if (e.keyCode === 13) {
                    listSearch();
                }
            });

            $(document).on("change", ".qna-stats-msg-target", function () {
                syncMsgTargetHeader($(this).data("roleCd"));
            });

            $(document).on("change", ".qna-stats-msg-target-all", function () {
                toggleMsgTargetAll($(this).data("roleCd"), this.checked);
            });

            $("#orgId").on("change", function () {
                loadYrSmstrOptions();
            });

            listSearch();
        });

        /**
         * 질의응답 총괄현황 목록을 조회한다.
         */
        function listSearch() {
            const extData = {
                orgId: $("#orgId").val(),
                yrSmstr: $("#yrSmstr").val(),
                searchValue: $("#searchValue").val()
            };

            const param = {
                encParams: EPARAM,
                addParams: UiComm.makeEncParams(extData)
            };

            ajaxCall("/stats/lrnStatsAnls/admQnaStatsListAjax.do", param, function (data) {
                if (data.encParams != null && data.encParams !== "") {
                    EPARAM = data.encParams;
                }

                if (data.result > 0) {
                    const returnList = data.returnList || [];
                    $("#totalCnt").text(returnList.length);
                    qnaStatsTable.clearData();
                    qnaStatsTable.replaceData(createQnaStatsList(returnList));
                    resetMsgTargetHeader();
                } else {
                    UiComm.showMessage(data.message || "조회 중 오류가 발생했습니다.", "error");
                }
            }, function () {
                UiComm.showMessage("조회 중 오류가 발생했습니다.", "error");
            }, true);
        }

        /**
         * 현재 검색 조건에 맞는 질의응답 총괄현황 목록을 엑셀로 다운로드한다.
         */
        function excelDown() {
            const columns = [
                {label: "No", name: "no", align: "center", width: "1000"},
                {label: "기관", name: "orgnm", align: "center", width: "3500"},
                {label: "년도", name: "sbjctYr", align: "center", width: "2000"},
                {label: "학기", name: "sbjctSmstr", align: "center", width: "2000"},
                {label: "과목코드", name: "crclmnNo", align: "center", width: "3000"},
                {label: "과목", name: "sbjctnm", align: "left", width: "6000"},
                {label: "분반", name: "dvclasNo", align: "center", width: "1500"},
                {label: "교수", name: "profUsernm", align: "center", width: "3000"},
                {label: "튜터", name: "tutUsernm", align: "center", width: "3000"},
                {label: "Q&A 문의", name: "qnaQstnCnt", align: "right", width: "2500"},
                {label: "Q&A 답변", name: "qnaAnsCnt", align: "right", width: "2500"},
                {label: "1:1상담 문의", name: "oneononeQstnCnt", align: "right", width: "2500"},
                {label: "1:1상담 답변", name: "oneononeAnsCnt", align: "right", width: "2500"},
                {label: "피드백", name: "fdbkCnt", align: "right", width: "2500"}
            ];

            $("form[name=excelForm]").remove();
            const excelForm = $('<form name="excelForm" method="post"></form>');
            excelForm.attr("action", "/stats/lrnStatsAnls/admQnaStatsExcelDown.do");
            excelForm.append($('<input/>', {type: "hidden", name: "orgId", value: $("#orgId").val()}));
            excelForm.append($('<input/>', {type: "hidden", name: "yrSmstr", value: $("#yrSmstr").val()}));
            excelForm.append($('<input/>', {type: "hidden", name: "searchValue", value: $("#searchValue").val()}));
            excelForm.append($('<input/>', {type: "hidden", name: "excelGrid", value: JSON.stringify({colModel: columns})}));
            excelForm.appendTo("body");
            excelForm.submit();
        }

        function loadYrSmstrOptions() {
            ajaxCall("/common/admYrSmstrSelect.do", {
                orgId: $("#orgId").val()
            }, function (data) {
                const $yrSmstr = $("#yrSmstr");
                $yrSmstr.empty();
                $yrSmstr.append('<option value="">전체</option>');

                $.each(data.returnList || [], function (index, item) {
                    $yrSmstr.append(
                        '<option value="' + escapeAttr(item.yrSmstr) + '" data-type="' + escapeAttr(item.smstrChrtGbncd) + '">'
                        + escapeText(item.yrSmstrnm)
                        + '</option>'
                    );
                });
                $yrSmstr.trigger("chosen:updated");
            }, function () {
                $("#yrSmstr").html('<option value="">전체</option>');
            }, true);
        }

        function createQnaStatsList(list) {
            const dataList = [];
            if (!list || list.length === 0) {
                return dataList;
            }

            list.forEach(function (v, index) {
                dataList.push({
                    no: list.length - index,
                    orgnm: escapeText(v.orgnm),
                    sbjctYr: escapeText(v.sbjctYr),
                    sbjctSmstr: escapeText(v.sbjctSmstr),
                    sbjctId: normalizeText(v.sbjctId),
                    crclmnNo: escapeText(v.crclmnNo),
                    sbjctnm: escapeText(v.sbjctnm),
                    dvclasNo: escapeText(v.dvclasNo),
                    profUserId: normalizeText(v.profUserId),
                    profUsernm: normalizeText(v.profUsernm),
                    tutUserId: normalizeText(v.tutUserId),
                    tutUsernm: normalizeText(v.tutUsernm),
                    qnaQstnCnt: normalizeNumber(v.qnaQstnCnt),
                    qnaAnsCnt: normalizeNumber(v.qnaAnsCnt),
                    oneononeQstnCnt: normalizeNumber(v.oneononeQstnCnt),
                    oneononeAnsCnt: normalizeNumber(v.oneononeAnsCnt),
                    fdbkCnt: normalizeNumber(v.fdbkCnt)
                });
            });

            return dataList;
        }

        /**
         * 교수/튜터 헤더에 현재 목록 전체 선택 체크박스를 표시한다.
         */
        function createMsgTargetHeaderFormatter(roleCd, roleNm) {
            return function () {
                const checkboxId = "qnaMsgTargetAll" + roleCd;
                return "<span class=\"custom-input\">"
                    + "<input type=\"checkbox\" class=\"qna-stats-msg-target-all\" id=\"" + checkboxId + "\" data-role-cd=\"" + escapeAttr(roleCd) + "\">"
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
                const userIds = rowData[userIdField];
                const usernms = rowData[usernmField];

                if (!userIds || !usernms) {
                    return "-";
                }

                const checkboxId = "qnaMsgTarget" + roleCd + "_" + rowData.sbjctId;
                return "<span class=\"custom-input\">"
                    + "<input type=\"checkbox\" class=\"qna-stats-msg-target\" id=\"" + escapeAttr(checkboxId) + "\""
                    + " data-role-cd=\"" + escapeAttr(roleCd) + "\""
                    + " data-role-nm=\"" + escapeAttr(roleNm) + "\""
                    + " data-user-ids=\"" + escapeAttr(userIds) + "\""
                    + " data-user-nms=\"" + escapeAttr(usernms) + "\""
                    + " data-sbjct-id=\"" + escapeAttr(rowData.sbjctId) + "\""
                    + " data-sbjct-nm=\"" + escapeAttr(rowData.sbjctnm) + "\""
                    + ">"
                    + "<label for=\"" + escapeAttr(checkboxId) + "\">" + escapeText(usernms) + "</label>"
                    + "</span>";
            };
        }

        /**
         * 교수/튜터 헤더 체크박스 선택 상태를 해당 역할의 전체 행에 적용한다.
         */
        function toggleMsgTargetAll(roleCd, checked) {
            $(".qna-stats-msg-target[data-role-cd='" + roleCd + "']").prop("checked", checked);
            syncMsgTargetHeader(roleCd);
        }

        /**
         * 목록 재조회 후 교수/튜터 헤더 체크박스를 초기화한다.
         */
        function resetMsgTargetHeader() {
            ["PROF", "TUT"].forEach(function (roleCd) {
                $("#qnaMsgTargetAll" + roleCd).prop({checked: false, indeterminate: false});
            });
        }

        /**
         * 개별 체크박스 선택 상태에 맞춰 헤더 체크박스의 checked/indeterminate 상태를 동기화한다.
         */
        function syncMsgTargetHeader(roleCd) {
            const $items = $(".qna-stats-msg-target[data-role-cd='" + roleCd + "']");
            const $checked = $items.filter(":checked");
            $("#qnaMsgTargetAll" + roleCd).prop({
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

            $(".qna-stats-msg-target:checked").each(function () {
                const $target = $(this);
                const userIds = normalizeText($target.data("userIds")).split(",");
                const usernms = normalizeText($target.data("userNms")).split(",");

                userIds.forEach(function (userId, index) {
                    userId = normalizeText(userId).trim();
                    if (!userId || userMap[userId]) {
                        return;
                    }

                    userMap[userId] = true;
                    targetList.push({
                        userId: userId,
                        usernm: normalizeText(usernms[index]).trim(),
                        roleCd: $target.data("roleCd"),
                        roleNm: $target.data("roleNm"),
                        sbjctId: $target.data("sbjctId"),
                        sbjctnm: $target.data("sbjctNm")
                    });
                });
            });

            return targetList;
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
         * 숫자 표시값을 정규화한다.
         */
        function normalizeNumber(value) {
            const text = normalizeText(value);
            return text === "" ? "0" : text;
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
                        <h2 class="page-title">질의응답 총괄현황</h2>
                        <uiex:navibar type="admin"/>
                    </div>

                    <div class="search-typeA">
                        <div class="item">
                            <span class="item_tit"><label for="selectDate">기관</label></span>
                            <div class="itemList">
                                <select class="form-select" id="orgId" <c:if test="${!isSystemAdmin}">disabled="disabled"</c:if>><!-- 기관 -->
                                    <c:if test="${isSystemAdmin}">
                                        <option value="">전체</option>
                                    </c:if>
                                    <c:forEach var="list" items="${filterOptions.orgList }">
                                        <option value="${list.orgId }" ${list.orgId eq filterOptions.orgId ? 'selected' : '' }>${list.orgnm }</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit"><label for="yrSmstr">년도/학기(기수)</label></span>
                            <div class="itemList">
                                <select class="form-select" id="yrSmstr" name="yrSmstr" title="년도/학기(기수)" style="width:300px;">
                                    <option value="">전체</option>
                                    <c:forEach var="item" items="${filterOptions.yrSmstrList}">
                                        <c:set var="yrSmstrValue" value="${item.dgrsYr}${item.dgrsSmstrChrt}"/>
                                        <option value="${yrSmstrValue}" ${yrSmstrValue eq qnaStatsVO.yrSmstr ? 'selected' : ''} data-type="${item.smstrChrtGbncd}">
                                            <c:out value="${empty item.yrSmstrnm ? item.smstrChrt : item.yrSmstrnm}"/>
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit"><label for="searchValue">검색어</label></span>
                            <div class="itemList">
                                <input type="text" id="searchValue" name="searchValue" class="form-control w350" value="<c:out value='${qnaStatsVO.searchValue}'/>" placeholder="과목/과목코드/교수 입력" autocomplete="off"/>
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
                        <div id="qnaStatsList"></div>
                        <script>
                            qnaStatsTable = UiTable("qnaStatsList", {
                                lang: "ko",
                                // rowHeight: 45,
                                columnHeaderVertAlign: "middle",
                                columns: [
                                    {title: "No", field: "no", headerHozAlign: "center", hozAlign: "center", width: 40, minWidth: 40, headerSort: false},
                                    {title: "기관", field: "orgnm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 90, headerSort: true},
                                    {title: "년도", field: "sbjctYr", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 70, headerSort: true},
                                    {title: "학기", field: "sbjctSmstr", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 70, headerSort: true},
                                    {title: "과목코드", field: "crclmnNo", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 80, headerSort: false},
                                    {title: "과목", field: "sbjctnm", headerHozAlign: "center", hozAlign: "left", width: 0, minWidth: 200, headerSort: false},
                                    {title: "분반", field: "dvclasNo", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 60, headerSort: false},
                                    {title: "교수", field: "profUsernm", titleFormatter: createMsgTargetHeaderFormatter("PROF", "교수"), formatter: createMsgTargetFormatter("PROF", "교수", "profUserId", "profUsernm"), headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 120, headerSort: false},
                                    {title: "튜터", field: "tutUsernm", titleFormatter: createMsgTargetHeaderFormatter("TUT", "튜터"), formatter: createMsgTargetFormatter("TUT", "튜터", "tutUserId", "tutUsernm"), headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 120, headerSort: false},
                                    {
                                        title: "Q&A", headerHozAlign: "center", columns: [
                                            {title: "문의", field: "qnaQstnCnt", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 65, headerSort: false},
                                            {title: "답변", field: "qnaAnsCnt", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 65, headerSort: false}
                                        ]
                                    },
                                    {
                                        title: "1:1상담", headerHozAlign: "center", columns: [
                                            {title: "문의", field: "oneononeQstnCnt", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 65, headerSort: false},
                                            {title: "답변", field: "oneononeAnsCnt", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 65, headerSort: false}
                                        ]
                                    },
                                    {title: "피드백", field: "fdbkCnt", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 70, headerSort: false}
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
