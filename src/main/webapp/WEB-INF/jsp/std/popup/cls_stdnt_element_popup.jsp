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

    <!-- 타이틀 + 보내기 -->
    <div class="board_top" style="margin-bottom:8px;">
        <h3 class="board-title" id="popMainTitle">학습자 학습요소 참여현황</h3>
        <div class="right-area">
            <button type="button" class="btn basic" onclick="doSendMsg()">
                메시지 보내기
            </button>
        </div>
    </div>

    <!-- ① 수강생 정보 -->
    <div class="sub-box">
        <div class="board_top">
            <h3 class="board-title">수강생 정보</h3>
        </div>
        <div class="user-wrap mb30">
            <div class="user-img">
                <div class="user-photo">
                    <i class="xi-user" style="font-size:32px; color:#ccc;"></i>
                </div>
            </div>
            <div class="table_list">
                <ul class="list">
                    <li class="head"><label>기관</label></li>
                    <li id="infoOrg">-</li>
                </ul>
                <ul class="list">
                    <li class="head"><label>이름</label></li>
                    <li id="infoNm" class="fcRed fweb">-</li>
                </ul>
                <ul class="list">
                    <li class="head"><label>학번</label></li>
                    <li id="infoStdntNo">-</li>
                </ul>
                <ul class="list">
                    <li class="head"><label>아이디</label></li>
                    <li id="infoUserId">-</li>
                </ul>
                <ul class="list">
                    <li class="head"><label>휴대폰번호</label></li>
                    <li id="infoMobile">-</li>
                </ul>
                <ul class="list">
                    <li class="head"><label>사용 이메일</label></li>
                    <li id="infoEmail">-</li>
                </ul>
            </div>
        </div>
    </div>

    <!-- ② 학습요소 참여현황 -->
    <div class="sub-box">
        <div class="board_top">
            <h3 class="board-title" id="elemSectionTitle">학습요소 참여현황</h3>
        </div>
        <div id="elemListArea">
            <div class="t_center" style="padding:20px; color:#aaa;">조회 중...</div>
        </div>
    </div>

    <!-- 닫기 -->
    <div class="modal_btns">
        <button type="button" class="btn type2" onclick="closePopup()">닫기</button>
    </div>

</div>

<script type="text/javascript">
    var CTX      = "<%=request.getContextPath()%>";
    var _p       = new URLSearchParams(location.search);
    var sbjctId  = _p.get("sbjctId")  || "";
    var dvclasNo = _p.get("dvclasNo") || "";
    var userId   = _p.get("userId")   || "";
    var elemType = _p.get("elemType") || "ASMT";

    var elemTypeNmMap = { QNA:'Q&A', ASMT:'과제', QUIZ:'퀴즈', SRVY:'설문', DSCC:'토론' };

    $(function () {
        var typeNm = elemTypeNmMap[elemType] || '학습요소';
        $("#popMainTitle").text("학습자 " + typeNm + " 참여현황");
        $("#elemSectionTitle").text(typeNm + " 참여현황");
        loadStdntInfo();
        loadElemSbmsnList();
    });

    function closePopup() {
        try {
            var dlgId = null;
            if (window.frameElement) {
                dlgId = $(window.frameElement).closest('[data-dialog-id]').data('dialog-id');
            }
            if (dlgId && window.parent && typeof window.parent.UiDialog === 'function') {
                var dlg = window.parent.UiDialog(dlgId);
                if (dlg && typeof dlg.close === 'function') { dlg.close(); return; }
            }
            $(window.frameElement).closest('.ui-dialog').find('.ui-dialog-titlebar-close').trigger('click');
        } catch(e) { window.close(); }
    }

    function loadStdntInfo() {
        $.ajax({
            url: CTX + "/cls/selectClsStdntInfo.do",
            type: "GET", dataType: "json",
            data: { sbjctId: sbjctId, userId: userId },
            success: function (res) {
                if (res && res.result === 1 && res.returnVO) {
                    var v = res.returnVO;
                    $("#infoOrg").text(v.orgNm    || "-");
                    $("#infoNm").text(v.usernm    || "-");
                    $("#infoStdntNo").text(v.stdntNo || "-");
                    $("#infoUserId").text(v.userId   || "-");
                    $("#infoMobile").text(v.mobileNo || "-");
                    $("#infoEmail").text(v.email     || "-");
                }
            }
        });
    }

    function loadElemSbmsnList() {
        $.ajax({
            url: CTX + "/cls/selectStdntElemSbmsnList.do",
            type: "GET", dataType: "json",
            data: { sbjctId: sbjctId, userId: userId, elemType: elemType },
            success: function (res) {
                renderElemList(res && res.returnList ? res.returnList : []);
            },
            error: function () { renderElemList([]); }
        });
    }

    function renderElemList(list) {
        var $area = $("#elemListArea").empty();
        if (!list || list.length === 0) {
            $area.html('<div class="t_center" style="padding:20px; color:#aaa;">학습요소 정보가 없습니다.</div>');
            return;
        }

        list.forEach(function (elem, idx) {
            var isOpen = (idx === 0);
            var bodyId = "elemBody_" + idx;
            var iconId = "elemIcon_" + idx;

            var stsCls = elem.lrnSts === "제출완료" ? "fcBlue"
                : elem.lrnSts === "학습종료" ? "fcGrey" : "fcRed";

            var scoreHtml = elem.scoreText ? '&nbsp;<span class="fcBlue fweb">' + escHtml(elem.scoreText) + '</span>' : '';

            var $block = $('<div style="border:1px solid #dde3ee; border-radius:4px; margin-bottom:8px; overflow:hidden;"></div>');

            var $hd = $(
                '<div style="display:flex; align-items:center; justify-content:space-between; padding:10px 14px; background:#f4f6fb; cursor:pointer;">'
                + '<span class="fweb">[ ' + escHtml(elem.cntntsTypeNm || '') + ' ] '
                + escHtml(elem.cntntsTitle || '') + '</span>'
                + '<span style="display:flex; align-items:center; gap:8px; font-size:12px;">'
                + scoreHtml
                + '<span class="' + stsCls + '">' + escHtml(elem.lrnSts || '') + '</span>'
                + '<i class="xi-angle-' + (isOpen ? 'up' : 'down') + '-thin" id="' + iconId + '"></i>'
                + '</span></div>'
            );
            $hd.on("click", function () { toggleElem(idx, bodyId, iconId); });

            var $bd = $('<div id="' + bodyId + '" style="padding:12px 14px; border-top:1px solid #e5e7eb; display:' + (isOpen ? 'block' : 'none') + ';"></div>');

            if (elem.lrnStDt) {
                $bd.append(
                    '<div class="fs-sm fcGrey" style="margin-bottom:10px;">'
                    + '제출기간 ' + escHtml(elem.lrnStDt)
                    + (elem.lrnEndDt ? ' ~ ' + escHtml(elem.lrnEndDt) : '')
                    + '</div>'
                );
            }

            var $tbl = $(
                '<div class="table-wrap">'
                + '<table class="table-type2">'
                + '<thead><tr>' + getTableHeader(elemType) + '</tr></thead>'
                + '<tbody id="sbmsnBody_' + idx + '"></tbody>'
                + '</table></div>'
            );
            var $tbody = $tbl.find('tbody');
            if (elem.cntntsId) {
                loadSbmsnLog(elem.cntntsId, elemType, $tbody);
            } else {
                $tbody.html('<tr><td colspan="5" class="t_center fcGrey">제출 기록이 없습니다.</td></tr>');
            }

            $bd.append($tbl);
            $block.append($hd).append($bd);
            $area.append($block);
        });
    }

    function getTableHeader(type) {
        if (type === 'ASMT') {
            return '<th style="width:8%">No</th><th style="width:28%">제출일시</th>'
                + '<th style="width:36%">파일명</th><th style="width:14%">크기</th><th style="width:14%">다운로드</th>';
        } else if (type === 'QUIZ') {
            return '<th style="width:8%">No</th><th style="width:32%">제출일시</th>'
                + '<th style="width:30%">점수</th><th style="width:30%">결과</th>';
        } else if (type === 'QNA') {
            return '<th style="width:8%">No</th><th style="width:32%">등록일시</th><th style="width:60%">제목</th>';
        } else {
            return '<th style="width:8%">No</th><th style="width:32%">제출일시</th><th style="width:60%">내용</th>';
        }
    }

    function loadSbmsnLog(cntntsId, type, $tbody) {
        var colSpan = (type === 'ASMT') ? 5 : (type === 'QUIZ') ? 4 : 3;
        $tbody.html('<tr><td colspan="' + colSpan + '" class="t_center fcGrey"><spring:message code="common.processing"/></td></tr>');

        $.ajax({
            url: CTX + "/cls/selectStdntElemSbmsnLog.do",
            type: "GET", dataType: "json",
            data: { cntntsId: cntntsId, userId: userId, elemType: type },
            success: function (res) {
                $tbody.empty();
                var list = res && res.returnList ? res.returnList : [];
                if (list.length === 0) {
                    $tbody.html('<tr><td colspan="' + colSpan + '" class="t_center fcGrey">제출 기록이 없습니다.</td></tr>');
                    return;
                }
                list.forEach(function (r, i) {
                    var row = '<tr><td class="t_center">' + (i + 1) + '</td>'
                        + '<td class="t_center">' + escHtml(r.sbmsnDttm || '') + '</td>';
                    if (type === 'ASMT') {
                        row += '<td class="t_left">' + escHtml(r.fileNm || '') + '</td>'
                            + '<td class="t_center">' + escHtml(r.fileSzText || '') + '</td>'
                            + '<td class="t_center"><button type="button" class="btn basic small" onclick="downloadFile(\'' + escJs(r.fileId) + '\')"><i class="xi-download"></i></button></td>';
                    } else if (type === 'QUIZ') {
                        row += '<td class="t_center">' + escHtml(r.score || '-') + '</td>'
                            + '<td class="t_center">' + escHtml(r.resultText || '-') + '</td>';
                    } else if (type === 'QNA') {
                        row += '<td class="t_left">' + escHtml(r.title || '') + '</td>';
                    } else {
                        row += '<td class="t_left">' + escHtml(r.contents || '') + '</td>';
                    }
                    row += '</tr>';
                    $tbody.append(row);
                });
            },
            error: function () {
                $tbody.html('<tr><td colspan="' + colSpan + '" class="t_center fcGrey">제출 기록이 없습니다.</td></tr>');
            }
        });
    }

    function toggleElem(idx, bodyId, iconId) {
        var $bd = $("#" + bodyId), $icon = $("#" + iconId);
        if ($bd.is(":visible")) {
            $bd.slideUp(150);
            $icon.removeClass("xi-angle-up-thin").addClass("xi-angle-down-thin");
        } else {
            $bd.slideDown(150);
            $icon.removeClass("xi-angle-down-thin").addClass("xi-angle-up-thin");
        }
    }

    function downloadFile(fileId) {
        if (!fileId) return;
        location.href = CTX + "/common/fileDown.do?fileId=" + encodeURIComponent(fileId);
    }

    function doSendMsg() {
        if (!userId) { alert("학습자 정보가 없습니다."); return; }
        var rcvUserInfoStr = userId + ";" + ($("#infoNm").text() || "") + ";;";
        var form = window.parent.alarmForm;
        form.action = '<%=CommConst.SYSMSG_URL_SEND%>';
        form.target = "msgWindow";
        form[name='alarmType'].value      = "S";
        form[name='rcvUserInfoStr'].value = rcvUserInfoStr;
        form.onsubmit = window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");
        form.submit();
    }

    function escHtml(v) {
        return String(v).replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/"/g,"&quot;");
    }
    function escJs(v) {
        return String(v || "").replace(/\\/g,"\\\\").replace(/'/g,"\\'");
    }
</script>
</body>
</html>