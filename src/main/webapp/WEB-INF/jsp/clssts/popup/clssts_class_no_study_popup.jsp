<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="dashboard"/>
    </jsp:include>
</head>
<body>
<div class="pop-body">

    <%-- 팝업 헤더 --%>
    <div class="board_top">
        <h3 class="board-title">
            <span id="popSubTitle">${wkNo}<spring:message code="common.week"/><%-- 주차 --%> <spring:message code="cls.title.notlearned"/><%-- 미학습자 --%></span>
            <span class="total_num"><spring:message code="common.page.total"/><%-- 총 --%><strong id="popTotalCnt">0</strong><spring:message code="cls.label.people"/><%-- 명 --%></span>
        </h3>
        <div class="right-area">
            <button type="button" class="btn basic" id="btnSendMsg">
                <spring:message code="cls.button.send.message"/><%-- 메시지 보내기 --%>
            </button>
            <button type="button" class="btn type2" id="btnExcelDown">
                <spring:message code="button.download.excel"/><%-- 엑셀 다운로드 --%>
            </button>
        </div>
    </div>

    <%-- 미학습자 목록 테이블 --%>
    <div class="table-wrap">
        <table class="table-type2">
            <colgroup>
                <col style="width:8%">
                <col style="width:18%">
                <col style="width:20%">
                <col style="width:14%">
                <col style="width:14%">
                <col style="width:14%">
                <col style="width:12%">
            </colgroup>
            <thead>
            <tr>
                <th><spring:message code="common.number.no"/></th><%-- 번호 --%>
                <th><spring:message code="common.dept_name"/></th><%-- 학과 --%>
                <th><spring:message code="common.subject"/></th><%-- 과목 --%>
                <th><spring:message code="cls.label.representative.id"/></th><%-- 대표아이디 --%>
                <th><spring:message code="cls.label.student.no"/></th><%-- 학번 --%>
                <th><spring:message code="common.name"/></th><%-- 이름 --%>
                <th><spring:message code="cls.label.progress.rate"/></th><%-- 진도율 --%>

            </tr>
            </thead>
            <tbody id="notLrnnBody">
            <tr>
                <td colspan="7" class="t_center"><spring:message code="cls.label.loading"/><%-- 조회 중... --%></td>
            </tr>
            </tbody>
        </table>
    </div>

    <%-- 닫기 버튼 --%>
    <div class="modal_btns">
        <button type="button" class="btn type2" onclick="closePopup()"><spring:message code="button.close"/><%-- 닫기 --%></button>
    </div>

</div>

<script type="text/javascript">
    var CTX = "<%=request.getContextPath()%>";
    var _p = new URLSearchParams(location.search);
    var sbjctId = _p.get("sbjctId") || "";
    var sbjctnm = '<c:out value="${sbjctnm}"/>' || _p.get("sbjctnm") || ""; // fallback
    var dvclasNo = _p.get("dvclasNo") || "";
    var sbjctDisplay = sbjctnm ? (sbjctnm + (dvclasNo ? " " + dvclasNo + '<spring:message code="cls.label.decls.name"/><%-- 반 --%>' : "")) : "-";
    var wkNo = parseInt(_p.get("wkNo") || "0", 10);

    var currentUserIds = [];
    var currentUsers = [];

    $(function () {
        $("#popSubTitle").text(wkNo + '<spring:message code="common.week"/><%-- 주차 --%> ' + '<spring:message code="cls.title.notlearned"/><%-- 미학습자 --%>');

        loadNotLrnnList();

        $("#btnSendMsg").on("click", function () {
            if (!currentUserIds || currentUserIds.length === 0) {
                UiComm.showMessage('<spring:message code="cls.alert.no.notlearned.user"/><%-- 현재 조회된 미학습자가 없습니다. --%>',
                    "warning");
                return;
            }

            var rcvUserInfoStr = currentUsers.map(function (u) {
                return u.userId + ";" + u.usernm + ";;";
            }).join("|");

            // form.onsubmit = window.open() → window.open() 직접 호출 후 submit
            var form = window.parent && window.parent.alarmForm;
            if (!form) {
                UiComm.showMessage('<spring:message code="cls.alert.message.form.notfound"/><%-- 메시지 발송 폼을 찾을 수 없습니다. --%>', "warning");
                return;
            }

            form.action = '<%=CommConst.SYSMSG_URL_SEND%>';
            form.target = "msgWindow";
            form.elements["alarmType"].value = "S";
            form.elements["rcvUserInfoStr"].value = rcvUserInfoStr;
            window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");
            form.submit();
        });

        $("#btnExcelDown").on("click", function () {
            downloadExcel();
        });
    });

    function closePopup() {
        try {
            var dlgId = null;
            if (window.frameElement) {
                dlgId = $(window.frameElement).closest("[data-dialog-id]").data("dialog-id");
            }
            if (dlgId && window.parent && typeof window.parent.UiDialog === "function") {
                var dlg = window.parent.UiDialog(dlgId);
                if (dlg && typeof dlg.close === "function") {
                    dlg.close();
                    return;
                }
            }
            $(window.frameElement).closest(".ui-dialog").find(".ui-dialog-titlebar-close").trigger("click");
        } catch (e) {
            window.close();
        }
    }

    /* ===========================
       미학습자 목록 조회
       =========================== */
    function loadNotLrnnList() {
        ajaxCall(CTX + "/clssts/selectClsStsClassNoStudyWeek.do", {
                sbjctId: sbjctId,
                dvclasNo: dvclasNo,
                wkNo: wkNo
            },
            function (res) {
                var $body = $("#notLrnnBody").empty();

                if (!res || res.result !== 1 || !res.returnList || res.returnList.length === 0) {
                    currentUserIds = [];
                    currentUsers = [];
                    $("#popTotalCnt").text("0");

                    $body.append(
                        '<tr><td colspan="7" class="t_center"><spring:message code="common.no.data.result"/></td></tr>'<%--조회된 데이터가 없습니다--%>
                    );
                    return;
                }

                var list = res.returnList;

                currentUsers = list.map(function (x) {
                    return {
                        userId: x.userId || "",
                        usernm: x.usernm || ""
                    };
                }).filter(function (x) {
                    return !!x.userId;
                });

                currentUserIds = currentUsers.map(function (x) {
                    return x.userId;
                });

                $("#popTotalCnt").text(list.length);

                list.forEach(function (item, idx) {
                    $body.append(
                        '<tr>'
                        + '<td class="t_center" data-th="' + '<spring:message code="common.number.no"/>' + '">' + UiComm.escapeHtml(String(item.lineNo || (idx + 1))) + '</td>' <%-- 번호 --%>
                        + '<td class="t_center" data-th="' + '<spring:message code="common.dept_name"/>' + '">' + UiComm.escapeHtml(item.deptnm || "-") + '</td>' <%-- 학과 --%>
                        + '<td class="t_center" data-th="' + '<spring:message code="common.subject"/>' + '">' + UiComm.escapeHtml(sbjctDisplay) + '</td>' <%-- 과목 --%>
                        + '<td class="t_center" data-th="' + '<spring:message code="cls.label.representative.id"/>' + '">' + UiComm.escapeHtml(String(item.userId || "-")) + '</td>' <%-- 대표아이디 --%>
                        + '<td class="t_center" data-th="' + '<spring:message code="cls.label.student.no"/>' + '">' + UiComm.escapeHtml(String(item.stdntNo || "-")) + '</td>' <%-- 학번 --%>
                        + '<td class="t_center" data-th="' + '<spring:message code="common.name"/>' + '">' + UiComm.escapeHtml(item.usernm || "-") + '</td>' <%-- 이름 --%>
                        + '<td class="t_center" data-th="' + '<spring:message code="cls.label.progress.rate"/>' + '">' + UiComm.escapeHtml(String(item.prgrt || "0")) + '%</td>' <%-- 진도율 --%>
                        + '</tr>'
                    );
                });
            },
            function () {
                $("#notLrnnBody").html(
                    '<tr><td colspan="7" class="t_center"><spring:message code="fail.common.msg"/></td></tr>'<%--에러가 발생하였습니다--%>
                );
            },
            false
        );
    }

    /* ===========================
       엑셀 다운로드
       =========================== */
    function downloadExcel() {
        var excelGrid = {
            colModel: [
                {label: '<spring:message code="common.number.no"/><%-- 번호 --%>', name: "lineNo", align: "center", width: "3000"},
                {label: '<spring:message code="common.dept_name"/><%-- 학과 --%>', name: "deptnm", align: "center", width: "7000"},
                {label: '<spring:message code="common.subject"/><%-- 과목 --%>', name: "sbjctnm", align: "center", width: "9000"},
                {label: '<spring:message code="cls.label.representative.id"/><%-- 대표아이디 --%>', name: "userId", align: "center", width: "7000"},
                {label: '<spring:message code="cls.label.student.no"/><%-- 학번 --%>', name: "stdntNo", align: "center", width: "7000"},
                {label: '<spring:message code="common.name"/><%-- 이름 --%>', name: "usernm", align: "center", width: "6000"},
                {label: '<spring:message code="cls.label.progress.rate"/><%-- 진도율 --%>', name: "prgrt", align: "center", width: "5000"}
            ]
        };

        $("form[name=notLrnnExcelForm]").remove();

        var $form = $('<form name="notLrnnExcelForm" method="post"></form>');
        $form.attr("action", CTX + "/clssts/selectClsStsClassNoStudyWeekExcelDown.do");
        $form.append($("<input/>", {type: "hidden", name: "sbjctId", value: sbjctId}));
        $form.append($("<input/>", {type: "hidden", name: "sbjctnm", value: sbjctnm}));
        $form.append($("<input/>", {type: "hidden", name: "dvclasNo", value: dvclasNo}));
        $form.append($("<input/>", {type: "hidden", name: "wkNo", value: wkNo}));
        $form.append($("<input/>", {type: "hidden", name: "excelGrid", value: JSON.stringify(excelGrid)}));
        $form.appendTo("body").submit();
    }

</script>
</body>
</html>
