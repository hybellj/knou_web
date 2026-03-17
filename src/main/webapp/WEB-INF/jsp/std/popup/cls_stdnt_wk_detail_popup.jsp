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

    <!-- ① 수강생 정보 -->
    <div class="sub-box">
        <div class="board_top">
            <h3 class="board-title">수강생 정보</h3>
            <div class="right-area">
                <button type="button" class="btn basic" onclick="doSendMsg()">
                    <i class="xi-mail-o"></i> 메시지 보내기
                </button>
            </div>
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
                    <li id="infoNm" style="color:#e74c3c; font-weight:bold;">-</li>
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

    <!-- ② 주차별 학습기록 -->
    <div class="sub-box">
        <div class="board_top">
            <h3 class="board-title">주차별 학습기록</h3>
            <div class="right-area">
                <%-- 출결 범례 --%>
                <div class="state-txt-label">
                    <p><span class="state_ok" aria-label="출석">○</span> 출석</p>
                    <p><span class="state_late" aria-label="지각">△</span> 지각</p>
                    <p><span class="state_no" aria-label="결석">X</span> 결석</p>
                </div>
            </div>
        </div>

        <%-- 주차 선택 + 출석처리 버튼 --%>
        <div class="board_top" style="margin-bottom:8px;">
            <div style="display:flex; align-items:center; gap:8px;">
                <label for="selWkNo" style="font-size:13px; white-space:nowrap;">주차 선택</label>
                <select class="form-select" id="selWkNo" style="width:100px;" onchange="loadWkDetail()">
                    <c:forEach begin="1" end="15" var="w">
                        <option value="${w}" ${param.wkNo == w ? 'selected' : ''}>${w}주차</option>
                    </c:forEach>
                </select>
            </div>
            <%-- 출석 처리 버튼 (출석인증 기간에만 노출) --%>
            <div class="right-area" id="atndBtnArea" style="display:none;">
                <button type="button" class="btn type1" id="btnAtndProc" onclick="doAtndProcess()">출석 처리</button>
                <button type="button" class="btn type2" id="btnAtndCancel" onclick="doAtndCancel()">출석 처리 취소</button>
            </div>
        </div>

        <%-- 주차 요약 바 --%>
        <div class="msg-box basic" id="wkSummaryBar" style="display:flex; align-items:center; gap:12px; flex-wrap:wrap;">
            <span id="atndStsSpan">-</span>
            <span style="color:#bbb;">|</span>
            <span id="totalLrnMinSpan">-</span>
            <span style="color:#bbb;">|</span>
            <span>학습시간 <b id="inPrdSpan">-</b></span>
            <span style="color:#bbb;">(기간 후 : <b id="aftPrdSpan">-</b>)</span>
        </div>

        <%-- 학습기간 정보 --%>
        <div class="msg-box" style="margin-top:6px;" id="lrnPeriodBar">
            학습기간 조회 중...
        </div>

        <%-- 차시 목록 --%>
        <div id="chsiListArea" style="margin-top:12px;">
            <div style="text-align:center; padding:30px; color:#aaa;">조회 중...</div>
        </div>
    </div>

    <%-- 닫기 버튼 --%>
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
    var initWkNo = parseInt(_p.get("wkNo") || "1", 10) || 1;

    var currentAtndCertUseYn = "N";
    var currentLastWkYn      = "N";

    /* ==========================================
       초기화
       ========================================== */
    $(function () {
        $("#selWkNo").val(initWkNo);
        loadStdntInfo();
        loadWkDetail();
    });

    /* ==========================================
       수강생 기본정보 로드
       ========================================== */
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

    /* ==========================================
       주차 학습 상세 로드
       ========================================== */
    function loadWkDetail() {
        var wkNo = parseInt($("#selWkNo").val(), 10);

        $("#wkSummaryBar").css("opacity", "0.5");
        $("#atndBtnArea").hide();
        $("#chsiListArea").html('<div style="text-align:center; padding:30px; color:#aaa;">조회 중...</div>');

        $.ajax({
            url: CTX + "/cls/selectStdntWkLrnSummary.do",
            type: "GET", dataType: "json",
            data: { sbjctId: sbjctId, userId: userId, wkNo: wkNo },
            success: function (res) {
                $("#wkSummaryBar").css("opacity", "1");
                if (!res || res.result !== 1) {
                    renderWkSummary(null);
                    renderChsiList([]);
                    return;
                }
                renderWkSummary(res.returnVO);
                renderChsiList(res.returnVO ? (res.returnVO.chsiList || []) : []);
            },
            error: function () {
                renderWkSummary(null);
                renderChsiList([]);
            }
        });
    }

    /* ==========================================
       주차 요약 렌더링
       ========================================== */
    function renderWkSummary(d) {
        if (!d) {
            $("#atndStsSpan").html('-');
            $("#totalLrnMinSpan, #inPrdSpan, #aftPrdSpan").text('-');
            $("#lrnPeriodBar").text('데이터가 없습니다.');
            $("#atndBtnArea").hide();
            return;
        }

        var sts      = d.atndSts || "X";
        var stsClass = (sts === "O") ? "state_ok" : (sts === "△") ? "state_late" : "state_no";
        $("#atndStsSpan").html('<span class="' + stsClass + ' total_label" style="font-size:15px;">' + sts + '</span>');

        $("#totalLrnMinSpan").text((d.totalLrnMin || 0) + '분');
        $("#inPrdSpan").text((d.inPrdLrnMin  || 0) + '분 ' + (d.inPrdLrnSec  || 0) + '초');
        $("#aftPrdSpan").text((d.aftPrdLrnMin || 0) + '분 ' + (d.aftPrdLrnSec || 0) + '초');

        var period = "학습기간 ";
        if (d.lrnStDt && d.lrnEndDt) period += d.lrnStDt + " ~ " + d.lrnEndDt;
        if (d.totDurMin) period += " / " + d.totDurMin + "분";
        if (d.lrnMthd)   period += " / " + d.lrnMthd;
        $("#lrnPeriodBar").text(period || "-");

        currentAtndCertUseYn = d.atndCertUseYn || "N";
        currentLastWkYn      = d.lastWkYn      || "N";
        if (currentAtndCertUseYn === "Y" && currentLastWkYn !== "Y") {
            $("#atndBtnArea").show();
        } else {
            $("#atndBtnArea").hide();
        }
    }

    /* ==========================================
       차시 목록 렌더링
       ========================================== */
    function renderChsiList(list) {
        var $area = $("#chsiListArea").empty();

        if (!list || list.length === 0) {
            $area.html('<div style="text-align:center; padding:20px; color:#aaa;">차시 정보가 없습니다.</div>');
            return;
        }

        list.forEach(function (chsi, idx) {
            var isOpen   = (idx === 0);
            var bodyId   = "chsiBody_" + idx;
            var iconId   = "chsiIcon_" + idx;

            var stsClass = chsi.lrnSts === "학습완료" ? "fcBlue"
                : chsi.lrnSts === "학습중"   ? "fcOrange" : "fcGrey";

            var $block = $('<div class="sub-box" style="margin-bottom:8px; padding:0; border:1px solid #dde3ee; border-radius:6px; overflow:hidden;"></div>');

            // 헤더
            var $hd = $(
                '<div style="display:flex; align-items:center; justify-content:space-between; padding:10px 14px; background:#f4f6fb; cursor:pointer;">'
                + '<span style="font-weight:bold; font-size:13px;">[ ' + chsi.chsiNo + '차시 ] ' + escHtml(chsi.chsiTitle || '') + '</span>'
                + '<span style="display:flex; align-items:center; gap:10px; font-size:12px;">'
                +   '<span class="' + stsClass + '">' + escHtml(chsi.lrnSts || '') + '</span>'
                +   '<i class="xi-angle-' + (isOpen ? 'up' : 'down') + '-thin" id="' + iconId + '"></i>'
                + '</span>'
                + '</div>'
            );
            $hd.on("click", function () { toggleChsi(idx, bodyId, iconId); });

            // 바디
            var $bd = $('<div id="' + bodyId + '" style="padding:12px 14px; border-top:1px solid #e5e7eb; display:' + (isOpen ? 'block' : 'none') + ';"></div>');

            // 콘텐츠 정보
            var atndTrgt = chsi.atndTrgtYn === "Y" ? " / 출결대상" : "";
            $bd.append(
                '<div style="margin-bottom:8px; font-size:13px;">'
                + '<span style="display:inline-block; background:#3b6dbf; color:#fff; border-radius:3px; padding:1px 7px; font-size:11px; margin-right:6px;">'
                + escHtml(chsi.cntntsTypeNm || '동영상') + '</span>'
                + escHtml(chsi.cntntsTitle || '')
                + '</div>'
                + '<div style="font-size:12px; color:#666; margin-bottom:10px;">'
                + '학습기간 ' + (chsi.lrnStDt || '') + ' ~ ' + (chsi.lrnEndDt || '')
                + (chsi.lrnMin ? ' / ' + chsi.lrnMin + '분' : '') + atndTrgt
                + '</div>'
            );

            // 학습기록 테이블
            var $tbl = $(
                '<div class="table-wrap">'
                + '<table class="table-type2">'
                + '<colgroup>'
                + '<col style="width:8%"><col style="width:20%"><col style="width:10%">'
                + '<col style="width:12%"><col style="width:38%"><col style="width:12%">'
                + '</colgroup>'
                + '<thead><tr>'
                + '<th>No</th><th>일시</th><th>재생위치</th>'
                + '<th>OS</th><th>브라우저/동작</th><th>IP</th>'
                + '</tr></thead>'
                + '<tbody id="logBody_' + idx + '"></tbody>'
                + '</table></div>'
            );

            var $tbody = $tbl.find('tbody');
            if (chsi.logList && chsi.logList.length > 0) {
                chsi.logList.forEach(function (log) {
                    $tbody.append(
                        '<tr>'
                        + '<td class="t_center">' + escHtml(log.lineNo  || '') + '</td>'
                        + '<td class="t_center">' + escHtml(log.logDttm  || '') + '</td>'
                        + '<td class="t_center">' + escHtml(log.playPos  || '') + '</td>'
                        + '<td class="t_center">' + escHtml(log.osNm     || '') + '</td>'
                        + '<td class="t_left">'   + escHtml(log.actInfo  || '') + '</td>'
                        + '<td class="t_center">' + escHtml(log.ipAddr   || '') + '</td>'
                        + '</tr>'
                    );
                });
            } else {
                $tbody.html('<tr><td colspan="6" class="t_center" style="color:#aaa;">학습 기록이 없습니다.</td></tr>');
            }

            $bd.append($tbl);
            $block.append($hd).append($bd);
            $area.append($block);
        });
    }

    /* ==========================================
       차시 펼침 / 접힘
       ========================================== */
    function toggleChsi(idx, bodyId, iconId) {
        var $bd   = $("#" + bodyId);
        var $icon = $("#" + iconId);
        if ($bd.is(":visible")) {
            $bd.slideUp(150);
            $icon.removeClass("xi-angle-up-thin").addClass("xi-angle-down-thin");
        } else {
            $bd.slideDown(150);
            $icon.removeClass("xi-angle-down-thin").addClass("xi-angle-up-thin");
        }
    }

    /* ==========================================
       출석 처리
       ========================================== */
    function doAtndProcess() {
        var wkNo = parseInt($("#selWkNo").val(), 10);
        if (!confirm(wkNo + "주차 출석 처리를 하시겠습니까?")) return;
        $.ajax({
            url: CTX + "/cls/updateAtndlcProcess.do",
            type: "POST", dataType: "json",
            data: { sbjctId: sbjctId, userId: userId, wkNo: wkNo },
            success: function (res) {
                if (res && res.result === 1) {
                    alert(res.message || "출석 처리가 완료되었습니다.");
                    loadWkDetail();
                } else {
                    alert((res && res.message) || "출석 처리에 실패하였습니다.");
                }
            },
            error: function () { alert("오류가 발생하였습니다."); }
        });
    }

    /* ==========================================
       출석 처리 취소
       ========================================== */
    function doAtndCancel() {
        var wkNo = parseInt($("#selWkNo").val(), 10);
        if (!confirm(wkNo + "주차 출석 처리를 취소하시겠습니까?")) return;
        $.ajax({
            url: CTX + "/cls/updateAtndlcCancel.do",
            type: "POST", dataType: "json",
            data: { sbjctId: sbjctId, userId: userId, wkNo: wkNo },
            success: function (res) {
                if (res && res.result === 1) {
                    alert(res.message || "출석 처리가 취소되었습니다.");
                    loadWkDetail();
                } else {
                    alert((res && res.message) || "출석 처리 취소에 실패하였습니다.");
                }
            },
            error: function () { alert("오류가 발생하였습니다."); }
        });
    }

    /* ==========================================
       메시지 보내기
       ========================================== */
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

    function doSendMsg() {
        if (!userId) { alert("학습자 정보가 없습니다."); return; }

        var usernm         = $("#infoNm").text() || "";
        var rcvUserInfoStr = userId + ";" + usernm + ";;";

        var form = window.parent.alarmForm;
        form.action = '<%=CommConst.SYSMSG_URL_SEND%>';
        form.target = "msgWindow";
        form[name='alarmType'].value      = "S";
        form[name='rcvUserInfoStr'].value = rcvUserInfoStr;
        form.onsubmit = window.open("about:blank", "msgWindow",
            "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");
        form.submit();
    }

    function escHtml(v) {
        return String(v)
            .replace(/&/g, "&amp;").replace(/</g, "&lt;")
            .replace(/>/g, "&gt;").replace(/"/g, "&quot;");
    }
</script>
</body>
</html>