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
    <style>
        body { background: #fff; font-size: 13px; }
        .pop-body { padding: 20px; }

        /* ── 수강생 정보 ── */
        .stdnt-info-card {
            display: flex;
            gap: 18px;
            align-items: flex-start;
            border: 1px solid #dde3ee;
            border-radius: 6px;
            padding: 14px 16px;
            background: #fafbfd;
            position: relative;
            margin-bottom: 16px;
        }
        .stdnt-photo-placeholder {
            width: 76px; height: 96px;
            border: 1px solid #ccc; border-radius: 4px;
            background: #e8eaf0;
            display: flex; align-items: center; justify-content: center;
            color: #aaa; font-size: 12px; flex-shrink: 0;
        }
        .stdnt-details { flex: 1; }
        .stdnt-details table { width: 100%; border: none; }
        .stdnt-details table td {
            padding: 3px 8px; font-size: 13px;
            border: none; background: transparent;
        }
        .stdnt-details table td:first-child { color: #666; width: 88px; }
        .stdnt-details table td:last-child  { font-weight: 500; }
        .btn-send-top {
            position: absolute; top: 10px; right: 10px;
        }

        /* ── 섹션 헤더 ── */
        .sec-hd {
            display: flex; align-items: center;
            justify-content: space-between;
            background: #f4f6fb;
            border-left: 4px solid #3b6dbf;
            padding: 7px 12px;
            font-size: 14px; font-weight: bold;
            margin: 14px 0 8px;
        }
        .sec-hd .legend { font-size: 12px; font-weight: normal; color: #555; }

        /* ── 주차 선택 + 요약 바 ── */
        .wk-ctrl-row {
            display: flex; align-items: center; gap: 10px;
            margin-bottom: 8px; flex-wrap: wrap;
        }
        .wk-summary-bar {
            display: flex; align-items: center; gap: 8px;
            padding: 8px 14px;
            background: #f0f3fa; border-radius: 4px;
            font-size: 13px; flex-wrap: wrap;
        }
        .sts-badge {
            display: inline-block;
            padding: 2px 10px;
            border-radius: 12px; font-weight: bold; font-size: 13px;
        }
        .sts-O   { background: #dbeafe; color: #1d4ed8; }
        .sts-TRI { background: #ffedd5; color: #c2410c; }
        .sts-X   { background: #fee2e2; color: #b91c1c; }
        .txt-divider { color: #bbb; }

        /* ── 출석 처리 버튼 ── */
        .atnd-btn-area { display: flex; gap: 6px; align-items: center; }
        .btn-atnd-proc   { background: #2185D0; color: #fff; border: none; border-radius: 4px; padding: 5px 14px; cursor: pointer; font-size: 12px; }
        .btn-atnd-cancel { background: #fff; color: #555; border: 1px solid #ccc; border-radius: 4px; padding: 5px 14px; cursor: pointer; font-size: 12px; }
        .btn-atnd-proc:hover   { background: #1a6aab; }
        .btn-atnd-cancel:hover { background: #f5f5f5; }

        /* ── 학습기간 정보 바 ── */
        .lrn-period-bar {
            font-size: 12px; color: #555;
            background: #f9fafb; border: 1px solid #e5e7eb;
            border-radius: 4px; padding: 6px 12px;
            margin-bottom: 10px;
        }

        /* ── 차시 목록 ── */
        .chsi-block {
            border: 1px solid #dde3ee; border-radius: 6px;
            margin-bottom: 10px; overflow: hidden;
        }
        .chsi-header {
            display: flex; align-items: center;
            justify-content: space-between;
            background: #f4f6fb; padding: 9px 14px;
            cursor: pointer; user-select: none;
        }
        .chsi-header:hover { background: #eef1f8; }
        .chsi-header .chsi-title { font-weight: bold; font-size: 13px; }
        .chsi-header .chsi-right { display: flex; align-items: center; gap: 10px; font-size: 12px; color: #555; }

        /* 학습 상태 뱃지 */
        .lrn-sts-badge {
            display: inline-block; padding: 1px 8px;
            border-radius: 10px; font-size: 11px; font-weight: bold;
        }
        .sts-done { background: #dcfce7; color: #166534; }
        .sts-ing  { background: #fef9c3; color: #854d0e; }
        .sts-none { background: #f1f5f9; color: #64748b; }

        .chsi-body {
            padding: 10px 14px;
            border-top: 1px solid #e5e7eb;
            display: none; /* 기본 접힘 */
        }
        .chsi-cntns-row {
            display: flex; align-items: center; gap: 8px;
            margin-bottom: 8px; font-size: 13px;
        }
        .cntns-type-tag {
            display: inline-block; background: #3b6dbf; color: #fff;
            border-radius: 3px; padding: 1px 7px; font-size: 11px;
        }
        .cntns-period { font-size: 12px; color: #666; margin-bottom: 8px; }

        /* ── 학습기록 테이블 ── */
        .log-table-wrap { overflow-x: auto; }
        .log-table {
            width: 100%; border-collapse: collapse;
            font-size: 12px; min-width: 700px;
        }
        .log-table thead th {
            background: #f0f3fa; text-align: center;
            padding: 5px 6px; border: 1px solid #dde3ee;
            font-size: 12px; white-space: nowrap;
        }
        .log-table tbody td {
            padding: 4px 6px; border: 1px solid #eee;
            text-align: center; white-space: nowrap;
        }
        .log-table tbody tr:hover { background: #fafbfd; }
        .log-empty { text-align: center; padding: 14px; color: #aaa; }

        /* ── 닫기 ── */
        .pop-footer { text-align: center; margin-top: 20px; padding-top: 14px; border-top: 1px solid #eee; }

        /* ── 로딩 스피너 ── */
        .loading-area { text-align: center; padding: 30px; color: #aaa; font-size: 13px; }

        /* tooltip 스타일 주석 */
        .atnd-tooltip {
            display: none;
            position: absolute;
            background: #fef08a; border: 1px solid #ca8a04;
            border-radius: 4px; padding: 5px 10px;
            font-size: 11px; color: #713f12;
            z-index: 100; white-space: nowrap;
            top: 36px; right: 0;
        }
        .atnd-btn-wrap { position: relative; }
        .atnd-btn-wrap:hover .atnd-tooltip { display: block; }
    </style>
</head>
<body>
<div class="pop-body">

    <!-- ① 수강생 정보 -->
    <div class="sec-hd" style="margin-top:0;">
        수강생 정보
        <div class="btn-send-top" style="position:static;">
            <button type="button" class="btn basic" onclick="doSendMsg()">
                <i class="xi-mail-o"></i> 보내기
            </button>
        </div>
    </div>
    <div class="stdnt-info-card">
        <div class="stdnt-photo-placeholder">
            <i class="xi-user" style="font-size:30px;"></i>
        </div>
        <div class="stdnt-details">
            <table>
                <tr><td>기관</td>      <td id="infoOrg">-</td></tr>
                <tr><td>이름</td>      <td id="infoNm" style="color:#e74c3c;font-weight:bold;">-</td></tr>
                <tr><td>학번</td>      <td id="infoStdntNo">-</td></tr>
                <tr><td>아이디</td>    <td id="infoUserId">-</td></tr>
                <tr><td>휴대폰번호</td><td id="infoMobile">-</td></tr>
                <tr><td>사용 이메일</td><td id="infoEmail">-</td></tr>
            </table>
        </div>
    </div>

    <!-- ② 주차별 학습기록 섹션 -->
    <div class="sec-hd">
        주차별 학습기록
        <span class="legend">
            <b style="color:#2185D0;">O</b> : 출석&nbsp;
            <b style="color:#F2711C;">△</b> : 지각&nbsp;
            <b style="color:#DB2828;">X</b> : 결석
        </span>
    </div>

    <!-- 주차 선택 + 출석처리 버튼 -->
    <div class="wk-ctrl-row">
        <div>
            <label for="selWkNo" style="font-size:13px;margin-right:4px;">주차 선택</label>
            <select class="form-select" id="selWkNo" style="width:90px;" onchange="loadWkDetail()">
                <c:forEach begin="1" end="15" var="w">
                    <option value="${w}">${w}주차</option>
                </c:forEach>
            </select>
        </div>
        <!-- ③ 출석 처리 / 취소 버튼 - 출석인증 기간에만 노출 -->
        <div class="atnd-btn-area" id="atndBtnArea" style="display:none;">
            <div class="atnd-btn-wrap">
                <button type="button" class="btn-atnd-proc" id="btnAtndProc" onclick="doAtndProcess()">출석 처리</button>
                <!-- tooltip: 출석인증 시작일시에 버튼 노출 -->
                <div class="atnd-tooltip">※ 출석인증 시작일시에 버튼 노출<br>※ 14주차 마지막일시 버튼 숨김</div>
            </div>
            <button type="button" class="btn-atnd-cancel" id="btnAtndCancel" onclick="doAtndCancel()">출석 처리 취소</button>
        </div>
    </div>

    <!-- 주차 요약 바 -->
    <div class="wk-summary-bar" id="wkSummaryBar">
        <span id="atndStsSpan">-</span>
        <span class="txt-divider">|</span>
        <span id="totalLrnMinSpan">-</span>
        <span class="txt-divider">|</span>
        <span>학습시간 <b id="inPrdSpan">-</b></span>
        <span class="txt-divider">(기간 후 : <b id="aftPrdSpan">-</b>)</span>
    </div>

    <!-- 학습기간 + 학습방식 -->
    <div class="lrn-period-bar" id="lrnPeriodBar">
        학습기간 조회 중...
    </div>

    <!-- ④ 차시 목록 (펼침/접힘) -->
    <div id="chsiListArea">
        <div class="loading-area">조회 중...</div>
    </div>

    <!-- 닫기 -->
    <div class="pop-footer">
        <button type="button" class="btn type2" onclick="doClose()"><spring:message code="button.close"/></button><%-- 닫기 --%>
    </div>
</div>

<script type="text/javascript">
    var CTX      = "<%=request.getContextPath()%>";
    var sbjctId  = "${sbjctId}";
    var dvclasNo = "${dvclasNo}";
    var userId   = "${userId}";
    var initWkNo = parseInt("${wkNo}", 10) || 1;

    /* 현재 주차 출석인증 버튼 표시 여부 */
    var currentAtndCertUseYn = "N";
    var currentLastWkYn      = "N";

    /* ==========================================
       초기화
       ========================================== */
    $(function () {
        /* 초기 주차 세팅 */
        $("#selWkNo").val(initWkNo);

        /* 수강생 기본정보 로드 */
        loadStdntInfo();

        /* 주차 학습기록 로드 */
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
       주차 학습 상세 로드 (주차 드롭다운 변경 시 호출)
       ========================================== */
    function loadWkDetail() {
        var wkNo = parseInt($("#selWkNo").val(), 10);

        /* 초기화 */
        $("#wkSummaryBar").css("opacity", "0.5");
        $("#atndBtnArea").hide();
        $("#chsiListArea").html('<div class="loading-area">조회 중...</div>');

        $.ajax({
            url: CTX + "/cls/selectStdntWkLrnSummary.do",
            type: "GET", dataType: "json",
            data: {
                sbjctId: sbjctId,
                userId:  userId,
                wkNo:    wkNo
            },
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
            $("#totalLrnMinSpan").text('-');
            $("#inPrdSpan").text('-');
            $("#aftPrdSpan").text('-');
            $("#lrnPeriodBar").text('<spring:message code="common.no.data.result"/>'); // 데이터가 없습니다.
            $("#atndBtnArea").hide();
            return;
        }

        /* 출결 상태 뱃지 */
        var sts = d.atndSts || "X";
        var stsClass = (sts === "O") ? "sts-O" : (sts === "△") ? "sts-TRI" : "sts-X";
        $("#atndStsSpan").html('<span class="sts-badge ' + stsClass + '">' + sts + '</span>');

        /* 총 학습시간 */
        $("#totalLrnMinSpan").text((d.totalLrnMin || 0) + '분');

        /* 기간내 학습시간 */
        var inPrd  = (d.inPrdLrnMin  || 0) + '분 ' + (d.inPrdLrnSec  || 0) + '초';
        var aftPrd = (d.aftPrdLrnMin || 0) + '분 ' + (d.aftPrdLrnSec || 0) + '초';
        $("#inPrdSpan").text(inPrd);
        $("#aftPrdSpan").text(aftPrd);

        /* 학습기간 + 분수 + 학습방식 */
        var period = "학습기간 ";
        if (d.lrnStDt && d.lrnEndDt) {
            period += d.lrnStDt + " ~ " + d.lrnEndDt;
        }
        if (d.totDurMin) period += " / " + d.totDurMin + "분";
        if (d.lrnMthd)   period += " / " + d.lrnMthd;
        $("#lrnPeriodBar").text(period || "-");

        /* 출석 처리 버튼 표시 여부 */
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
            $area.html('<div class="loading-area" style="color:#aaa;">차시 정보가 없습니다.</div>');
            return;
        }

        list.forEach(function (chsi, idx) {
            var isOpen   = (idx === 0); /* 첫 번째 차시 기본 펼침 */
            var stsClass = chsi.lrnSts === "학습완료" ? "sts-done"
                         : chsi.lrnSts === "학습중"   ? "sts-ing"  : "sts-none";
            var bodyId   = "chsiBody_" + idx;

            /* 차시 블록 */
            var $block = $('<div class="chsi-block"></div>');

            /* 헤더 */
            var $hd = $('<div class="chsi-header"></div>');
            $hd.html(
                '<span class="chsi-title">[ ' + chsi.chsiNo + '차시 ] ' + escHtml(chsi.chsiTitle || '') + '</span>'
                + '<span class="chsi-right">'
                +   '<span class="lrn-sts-badge ' + stsClass + '">' + escHtml(chsi.lrnSts || '') + '</span>'
                +   '<i class="xi-angle-' + (isOpen ? 'up' : 'down') + '-thin" id="icon_' + idx + '"></i>'
                + '</span>'
            );
            $hd.on("click", function () { toggleChsi(idx, bodyId); });

            /* 바디 */
            var $bd = $('<div class="chsi-body" id="' + bodyId + '"></div>');
            if (isOpen) $bd.show();

            /* 콘텐츠 정보 */
            var $cntntsRow = $('<div class="chsi-cntns-row"></div>');
            $cntntsRow.html(
                '<span class="cntns-type-tag">' + escHtml(chsi.cntntsTypeNm || '동영상') + '</span>'
                + '<span>' + escHtml(chsi.cntntsTitle || '') + '</span>'
            );

            var atndTrgt = chsi.atndTrgtYn === "Y" ? " / 출결대상" : "";
            var $period  = $('<div class="cntns-period"></div>');
            $period.text(
                "학습기간 " + (chsi.lrnStDt || '') + " ~ " + (chsi.lrnEndDt || '')
                + (chsi.lrnMin ? " / " + chsi.lrnMin + "분" : "") + atndTrgt
            );

            /* 학습기록 테이블 */
            var $logWrap = $('<div class="log-table-wrap"></div>');
            var $logTbl  = $('<table class="log-table"></table>');
            $logTbl.append(
                '<thead><tr>'
                + '<th style="width:8%">No</th>'
                + '<th style="width:20%">일시</th>'
                + '<th style="width:10%">재생위치</th>'
                + '<th style="width:12%">OS</th>'
                + '<th style="width:38%">브라우저/동작</th>'
                + '<th style="width:12%">IP</th>'
                + '</tr></thead>'
            );
            var $tbody = $('<tbody></tbody>');

            if (chsi.logList && chsi.logList.length > 0) {
                chsi.logList.forEach(function (log) {
                    $tbody.append(
                        '<tr>'
                        + '<td>' + escHtml(log.lineNo  || '') + '</td>'
                        + '<td>' + escHtml(log.logDttm  || '') + '</td>'
                        + '<td>' + escHtml(log.playPos  || '') + '</td>'
                        + '<td>' + escHtml(log.osNm     || '') + '</td>'
                        + '<td style="text-align:left;">' + escHtml(log.actInfo   || '') + '</td>'
                        + '<td>' + escHtml(log.ipAddr   || '') + '</td>'
                        + '</tr>'
                    );
                });
            } else {
                $tbody.html('<tr><td colspan="6" class="log-empty">학습 기록이 없습니다.</td></tr>');
            }

            $logTbl.append($tbody);
            $logWrap.append($logTbl);

            $bd.append($cntntsRow).append($period).append($logWrap);
            $block.append($hd).append($bd);
            $area.append($block);
        });
    }

    /* ==========================================
       차시 펼침 / 접힘 토글
       ========================================== */
    function toggleChsi(idx, bodyId) {
        var $bd   = $("#" + bodyId);
        var $icon = $("#icon_" + idx);
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
                    loadWkDetail(); /* 상태 재조회 */
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
       보내기
       ========================================== */
    function doSendMsg() {
        /* TODO: 메시지 보내기 레이어 팝업 연결 */
        alert("메시지 보내기 기능 연결 예정 (userId: " + userId + ")");
    }

    /* ==========================================
       닫기
       ========================================== */
    function doClose() {
        try {
            if (window.parent && typeof window.parent.UiDialog === "function") {
                window.parent.UiDialog.close("stdntWkDetailPop");
            } else { window.close(); }
        } catch (e) { window.close(); }
    }

    /* HTML 이스케이프 */
    function escHtml(v) {
        return String(v)
            .replace(/&/g, "&amp;").replace(/</g, "&lt;")
            .replace(/>/g, "&gt;").replace(/"/g, "&quot;");
    }
</script>
</body>
</html>
