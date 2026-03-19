<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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

    <!-- 팝업 헤더 -->
    <div class="board_top">
        <h3 class="board-title">
            <span id="popSubTitle">${wkNo}주차 미학습자</span>
            <span class="total_num">총 <strong id="popTotalCnt">0</strong>명</span>
        </h3>
        <div class="right-area">
            <button type="button" class="btn basic" id="btnSendMsg">
                <spring:message code="button.msg.send"/>
            </button>
            <button type="button" class="btn type2" id="btnExcelDown">
                <spring:message code="button.download.excel"/>
            </button>
        </div>
    </div>

    <!-- 미학습자 목록 테이블 -->
    <div class="table-wrap">
        <table class="table-type2">
            <colgroup>
                <col style="width:8%">
                <col style="width:20%">
                <col style="width:18%">
                <col style="width:14%">
                <col style="width:14%">
                <col style="width:12%">
            </colgroup>
            <thead>
            <tr>
                <th>No</th>
                <th>학과</th>
                <th>학번</th>
                <th>이름</th>
                <th>입학년도</th>
                <th>학년</th>
            </tr>
            </thead>
            <tbody id="notLrnnBody">
            <tr>
                <td colspan="6" class="t_center">조회 중...</td>
            </tr>
            </tbody>
        </table>
    </div>

    <!-- 닫기 버튼 -->
    <div class="modal_btns">
        <button type="button" class="btn type2"
                onclick="closePopup()">
            닫기
        </button>
    </div>

</div>

<script type="text/javascript">
    var CTX      = "<%=request.getContextPath()%>";
    var _p       = new URLSearchParams(location.search);
    var sbjctId  = _p.get("sbjctId")  || "";
    var dvclasNo = _p.get("dvclasNo") || "";
    var wkNo     = parseInt(_p.get("wkNo") || "0", 10);

    var currentUserIds = [];

    $(function () {
        $("#popSubTitle").text(wkNo + "주차 미학습자");

        loadNotLrnnList();

        $("#btnSendMsg").on("click", function () {
            if (!currentUserIds || currentUserIds.length === 0) {
                alert("현재 조회된 미학습자가 없습니다.");
                return;
            }

            // 다수 수신자 rcvUserInfoStr 구성 (| 구분)
            var rcvUserInfoStr = "";
            var $rows = $("#notLrnnBody tr");
            var sendCnt = 0;
            currentUserIds.forEach(function (uid, i) {
                if (sendCnt > 0) rcvUserInfoStr += "|";
                var usernm = $rows.eq(i).find("td").eq(3).text() || "";
                rcvUserInfoStr += uid + ";" + usernm + ";;";
                sendCnt++;
            });

            var form = window.parent.alarmForm;
            form.action = '<%=CommConst.SYSMSG_URL_SEND%>';
            form.target = "msgWindow";
            form[name='alarmType'].value      = "S";
            form[name='rcvUserInfoStr'].value = rcvUserInfoStr;
            form.onsubmit = window.open("about:blank", "msgWindow",
                "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");
            form.submit();
        });

        $("#btnExcelDown").on("click", function () {
            downloadExcel();
        });
    });

    function closePopup() {
        try {
            // UiDialog 반환값 기반 닫기
            var dlgId = null;
            if (window.frameElement) {
                dlgId = $(window.frameElement).closest('[data-dialog-id]').data('dialog-id');
            }
            if (dlgId && window.parent && typeof window.parent.UiDialog === 'function') {
                var dlg = window.parent.UiDialog(dlgId);
                if (dlg && typeof dlg.close === 'function') { dlg.close(); return; }
            }
            // fallback: X버튼 트리거
            $(window.frameElement).closest('.ui-dialog').find('.ui-dialog-titlebar-close').trigger('click');
        } catch(e) {
            window.close();
        }
    }

    /* ===========================
       미학습자 목록 조회
       =========================== */
    function loadNotLrnnList() {
        $.ajax({
            url: CTX + "/cls/selectClsNoStudyWeek.do",
            type: "GET", dataType: "json",
            data: { sbjctId: sbjctId, dvclasNo: dvclasNo, wkNo: wkNo },
            success: function (res) {
                var $body = $("#notLrnnBody").empty();

                if (!res || res.result !== 1 || !res.returnList || res.returnList.length === 0) {
                    currentUserIds = [];
                    $("#popTotalCnt").text("0");
                    $body.append('<tr><td colspan="6" class="t_center">미학습자가 없습니다.</td></tr>');
                    return;
                }

                var list = res.returnList;
                currentUserIds = list.map(function (x) { return x.userId; }).filter(Boolean);
                $("#popTotalCnt").text(list.length);

                list.forEach(function (item, idx) {
                    $body.append(
                        '<tr>'
                        + '<td class="t_center" data-th="No">'      + (idx + 1) + '</td>'
                        + '<td class="t_center" data-th="학과">'     + escHtml(item.deptnm  || '') + '</td>'
                        + '<td class="t_center" data-th="학번">'     + escHtml(item.stdntNo || '') + '</td>'
                        + '<td class="t_center" data-th="이름">'     + escHtml(item.usernm  || '') + '</td>'
                        + '<td class="t_center" data-th="입학년도">' + escHtml(item.entyR   || '-') + '</td>'
                        + '<td class="t_center" data-th="학년">'     + escHtml(item.scyr    || '-') + '</td>'
                        + '</tr>'
                    );
                });
            },
            error: function () {
                $("#notLrnnBody").html('<tr><td colspan="6" class="t_center"><spring:message code="fail.common.msg"/></td></tr>');
            }
        });
    }

    /* ===========================
       엑셀 다운로드
       =========================== */
    function downloadExcel() {
        var excelGrid = {
            colModel: [
                {label:'No',       name:'lineNo',  align:'center', width:'3000'},
                {label:'학과',     name:'deptnm',  align:'center', width:'7000'},
                {label:'학번',     name:'stdntNo', align:'center', width:'7000'},
                {label:'이름',     name:'usernm',  align:'center', width:'6000'},
                {label:'입학년도', name:'entyR',   align:'center', width:'5000'},
                {label:'학년',     name:'scyr',    align:'center', width:'3000'}
            ]
        };

        $("form[name=notLrnnExcelForm]").remove();
        var $form = $('<form name="notLrnnExcelForm" method="post"></form>');
        $form.attr("action", CTX + "/cls/selectClsStdntListExcelDown.do");
        $form.append($('<input/>', {type:'hidden', name:'sbjctId',   value: sbjctId}));
        $form.append($('<input/>', {type:'hidden', name:'dvclasNo',  value: dvclasNo}));
        $form.append($('<input/>', {type:'hidden', name:'wkNo',      value: wkNo}));
        $form.append($('<input/>', {type:'hidden', name:'excelGrid', value: JSON.stringify(excelGrid)}));
        $form.appendTo("body").submit();
    }

    function escHtml(v) {
        return String(v)
            .replace(/&/g, "&amp;").replace(/</g, "&lt;")
            .replace(/>/g, "&gt;").replace(/"/g, "&quot;");
    }
</script>
</body>
</html>