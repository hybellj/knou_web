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
            display: flex; gap: 18px; align-items: flex-start;
            border: 1px solid #dde3ee; border-radius: 6px;
            padding: 14px 16px; background: #fafbfd;
            margin-bottom: 16px;
        }
        .stdnt-photo-placeholder {
            width: 76px; height: 96px;
            border: 1px solid #ccc; border-radius: 4px;
            background: #e8eaf0;
            display: flex; align-items: center; justify-content: center;
            color: #aaa; flex-shrink: 0;
        }
        .stdnt-details { flex: 1; }
        .stdnt-details table { width: 100%; border: none; }
        .stdnt-details table td {
            padding: 3px 8px; font-size: 13px;
            border: none; background: transparent;
        }
        .stdnt-details table td:first-child { color: #666; width: 88px; }
        .stdnt-details table td:last-child  { font-weight: 500; }

        /* ── 섹션 헤더 ── */
        .sec-hd {
            display: flex; align-items: center;
            justify-content: space-between;
            background: #f4f6fb; border-left: 4px solid #3b6dbf;
            padding: 7px 12px; font-size: 14px; font-weight: bold;
            margin: 14px 0 8px;
        }

        /* ── 학습요소 블록 ── */
        .elem-block {
            border: 1px solid #dde3ee; border-radius: 6px;
            margin-bottom: 10px; overflow: hidden;
        }
        .elem-header {
            display: flex; align-items: center;
            justify-content: space-between;
            background: #f4f6fb; padding: 9px 14px;
            cursor: pointer; user-select: none;
        }
        .elem-header:hover { background: #eef1f8; }
        .elem-header .elem-title { font-weight: bold; font-size: 13px; }
        .elem-header .elem-right { display: flex; align-items: center; gap: 10px; font-size: 12px; color: #555; }

        /* 점수 뱃지 */
        .score-badge {
            display: inline-block; background: #1d4ed8; color: #fff;
            border-radius: 10px; padding: 1px 10px;
            font-size: 12px; font-weight: bold;
        }

        /* 학습 상태 뱃지 */
        .lrn-sts-badge {
            display: inline-block; padding: 1px 8px;
            border-radius: 10px; font-size: 11px; font-weight: bold;
        }
        .sts-done { background: #dcfce7; color: #166534; }
        .sts-end  { background: #f1f5f9; color: #64748b; }
        .sts-none { background: #fee2e2; color: #b91c1c; }

        /* 펼침/접음 */
        .elem-body {
            padding: 10px 14px;
            border-top: 1px solid #e5e7eb;
            display: none;
        }
        .elem-period {
            font-size: 12px; color: #666;
            margin-bottom: 10px;
        }

        /* ── 제출기록 테이블 ── */
        .sbmsn-table {
            width: 100%; border-collapse: collapse; font-size: 12px;
        }
        .sbmsn-table thead th {
            background: #f0f3fa; text-align: center;
            padding: 5px 8px; border: 1px solid #dde3ee;
            font-size: 12px;
        }
        .sbmsn-table tbody td {
            padding: 5px 8px; border: 1px solid #eee;
            text-align: center;
        }
        .sbmsn-table tbody tr:hover { background: #fafbfd; }
        .sbmsn-empty { text-align: center; padding: 14px; color: #aaa; }

        /* 다운로드 버튼 */
        .btn-file-down {
            display: inline-flex; align-items: center; gap: 4px;
            color: #3b6dbf; font-size: 12px; cursor: pointer;
            background: none; border: none; padding: 0;
        }
        .btn-file-down:hover { text-decoration: underline; }

        .pop-footer { text-align: center; margin-top: 20px; padding-top: 14px; border-top: 1px solid #eee; }
        .loading-area { text-align: center; padding: 30px; color: #aaa; font-size: 13px; }
    </style>
</head>
<body>
<div class="pop-body">

    <!-- 제목 + 보내기 -->
    <div style="display:flex; align-items:center; justify-content:space-between; margin-bottom:14px;">
        <h3 id="popMainTitle" style="font-size:16px; font-weight:bold; margin:0;">학습자 학습요소 참여현황</h3>
        <button type="button" class="btn basic" onclick="doSendMsg()">
            <i class="xi-mail-o"></i> <spring:message code="button.msg.send"/><%-- 보내기 --%>
        </button>
    </div>

    <!-- 수강생 정보 -->
    <div class="sec-hd" style="margin-top:0;">수강생 정보</div>
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

    <!-- 학습요소 참여현황 목록 -->
    <div class="sec-hd" id="elemSectionTitle">학습요소 참여 현황</div>
    <div id="elemListArea">
        <div class="loading-area"><spring:message code="common.processing"/></div><%-- 조회 중... --%>
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
    var elemType = "${elemType}";  /* ★ 추가: "ASMT" | "QUIZ" | "QNA" | "SRVY" | "DSCC" */

    /* elemType 한글 매핑 */
    var elemTypeNmMap = {
        QNA:  'Q&A',
        ASMT: '과제',
        QUIZ: '퀴즈',
        SRVY: '설문',
        DSCC: '토론'
    };

    /* ==========================================
       초기화
       ========================================== */
    $(function () {
        /* ★ 팝업 타이틀 / 섹션 타이틀 동적 변경 */
        var typeNm = elemTypeNmMap[elemType] || '학습요소';
        $("#popMainTitle").text("학습자 " + typeNm + " 참여현황");
        $("#elemSectionTitle").text(typeNm + " 참여 현황");

        loadStdntInfo();
        loadElemSbmsnList();
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
       학습요소 목록 로드
       ★ 수정: elemType 파라미터 추가
       ========================================== */
    function loadElemSbmsnList() {
        $.ajax({
            url: CTX + "/cls/selectStdntElemSbmsnList.do",
            type: "GET", dataType: "json",
            data: { sbjctId: sbjctId, userId: userId, elemType: elemType },  /* ★ elemType 추가 */
            success: function (res) {
                renderElemList(res && res.returnList ? res.returnList : []);
            },
            error: function () {
                renderElemList([]);
            }
        });
    }

    /* ==========================================
       학습요소 목록 렌더링
       ========================================== */
    function renderElemList(list) {
        var $area = $("#elemListArea").empty();

        if (!list || list.length === 0) {
            $area.html('<div class="loading-area" style="color:#aaa;">학습요소 정보가 없습니다.</div>');
            return;
        }

        list.forEach(function (elem, idx) {
            var isOpen = (idx === 0);
            var bodyId = "elemBody_" + idx;

            var stsClass = elem.lrnSts === "제출완료" ? "sts-done"
                : elem.lrnSts === "학습종료" ? "sts-end" : "sts-none";

            var scoreText = elem.scoreText || "";

            var $block = $('<div class="elem-block"></div>');

            /* 헤더 */
            var $hd = $('<div class="elem-header"></div>');
            $hd.html(
                '<span class="elem-title">[ ' + escHtml(elem.cntntsTypeNm || elemTypeNmMap[elemType] || '학습요소') + ' ] '
                + escHtml(elem.cntntsTitle || '') + '</span>'
                + '<span class="elem-right">'
                + (scoreText ? '<span class="score-badge">' + escHtml(scoreText) + '</span>' : '')
                + '<span class="lrn-sts-badge ' + stsClass + '">'
                + escHtml(elem.lrnSts || '') + '</span>'
                + '<i class="xi-angle-' + (isOpen ? 'up' : 'down') + '-thin" id="elemIcon_' + idx + '"></i>'
                + '</span>'
            );
            $hd.on("click", function () { toggleElem(idx, bodyId); });

            /* 바디 */
            var $bd = $('<div class="elem-body" id="' + bodyId + '"></div>');
            if (isOpen) $bd.show();

            /* 제출 기간 */
            if (elem.lrnStDt) {
                var periodText = "제출기간 " + escHtml(elem.lrnStDt || '-');
                if (elem.lrnEndDt) periodText += " ~ " + escHtml(elem.lrnEndDt);
                $bd.append('<div class="elem-period">' + periodText + '</div>');
            }

            /* ★ 제출기록 테이블 헤더 - elemType에 따라 분기 */
            var $tbl = $('<table class="sbmsn-table"></table>');
            var $thead = $('<thead><tr>' + getTableHeader(elemType) + '</tr></thead>');
            var $tbody = $('<tbody></tbody>');

            if (elem.cntntsId) {
                loadSbmsnLog(elem.cntntsId, elemType, $tbody);
            } else {
                $tbody.html('<tr><td colspan="5" class="sbmsn-empty">제출 기록이 없습니다.</td></tr>');
            }

            $tbl.append($thead).append($tbody);
            $bd.append($tbl);
            $block.append($hd).append($bd);
            $area.append($block);
        });
    }

    /* ==========================================
       ★ 추가: elemType별 테이블 헤더 반환
       ========================================== */
    function getTableHeader(type) {
        if (type === 'ASMT') {
            return '<th style="width:8%">No</th>'
                + '<th style="width:30%">제출일시</th>'
                + '<th style="width:38%">파일명</th>'
                + '<th style="width:12%">크기</th>'
                + '<th style="width:12%">다운로드</th>';
        } else if (type === 'QUIZ') {
            return '<th style="width:8%">No</th>'
                + '<th style="width:32%">제출일시</th>'
                + '<th style="width:30%">점수</th>'
                + '<th style="width:30%">결과</th>';
        } else if (type === 'QNA') {
            return '<th style="width:8%">No</th>'
                + '<th style="width:32%">등록일시</th>'
                + '<th style="width:60%">제목</th>';
        } else {
            /* SRVY / DSCC 공통 */
            return '<th style="width:8%">No</th>'
                + '<th style="width:32%">제출일시</th>'
                + '<th style="width:60%">내용</th>';
        }
    }

    /* ==========================================
       ★ 수정: elemType별 제출기록 Ajax 로드
              URL: selectStdntElemSbmsnLog.do (기존 selectStdntAsmtSbmsnLog.do 대체)
              파라미터: cntntsId + elemType
       ========================================== */
    function loadSbmsnLog(cntntsId, type, $tbody) {
        var colSpan = (type === 'ASMT') ? 5
            : (type === 'QUIZ') ? 4 : 3;

        $tbody.html('<tr><td colspan="' + colSpan + '" class="sbmsn-empty"><spring:message code="common.processing"/></td></tr>');

        $.ajax({
            url: CTX + "/cls/selectStdntElemSbmsnLog.do",  /* ★ URL 변경 */
            type: "GET", dataType: "json",
            data: { cntntsId: cntntsId, userId: userId, elemType: type },  /* ★ 파라미터 변경 */
            success: function (res) {
                $tbody.empty();
                var list = res && res.returnList ? res.returnList : [];

                if (list.length === 0) {
                    $tbody.html('<tr><td colspan="' + colSpan + '" class="sbmsn-empty">제출 기록이 없습니다.</td></tr>');
                    return;
                }

                list.forEach(function (r, i) {
                    var row = '<tr><td>' + (i + 1) + '</td>'
                        + '<td>' + escHtml(r.sbmsnDttm || '') + '</td>';

                    if (type === 'ASMT') {
                        row += '<td style="text-align:left;">' + escHtml(r.fileNm || '') + '</td>'
                            + '<td>' + escHtml(r.fileSzText || '') + '</td>'
                            + '<td>'
                            +   '<button type="button" class="btn-file-down" onclick="downloadFile(\'' + escJs(r.fileId) + '\')">'
                            +   '<i class="xi-download"></i>'
                            +   '</button>'
                            + '</td>';
                    } else if (type === 'QUIZ') {
                        row += '<td>' + escHtml(r.score || '-') + '</td>'
                            + '<td>' + escHtml(r.resultText || '-') + '</td>';
                    } else if (type === 'QNA') {
                        row += '<td style="text-align:left;">' + escHtml(r.title || '') + '</td>';
                    } else {
                        /* SRVY / DSCC */
                        row += '<td style="text-align:left;">' + escHtml(r.contents || '') + '</td>';
                    }

                    row += '</tr>';
                    $tbody.append(row);
                });
            },
            error: function () {
                $tbody.html('<tr><td colspan="' + colSpan + '" class="sbmsn-empty">제출 기록이 없습니다.</td></tr>');
            }
        });
    }

    /* ==========================================
       펼침 / 접힘 토글
       ========================================== */
    function toggleElem(idx, bodyId) {
        var $bd   = $("#" + bodyId);
        var $icon = $("#elemIcon_" + idx);
        if ($bd.is(":visible")) {
            $bd.slideUp(150);
            $icon.removeClass("xi-angle-up-thin").addClass("xi-angle-down-thin");
        } else {
            $bd.slideDown(150);
            $icon.removeClass("xi-angle-down-thin").addClass("xi-angle-up-thin");
        }
    }

    /* ==========================================
       파일 다운로드 (ASMT 전용)
       ========================================== */
    function downloadFile(fileId) {
        if (!fileId) return;
        location.href = CTX + "/common/fileDown.do?fileId=" + encodeURIComponent(fileId);
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
                window.parent.UiDialog.close("stdntElemPop");
            } else { window.close(); }
        } catch (e) { window.close(); }
    }

    function escHtml(v) {
        return String(v)
            .replace(/&/g, "&amp;").replace(/</g, "&lt;")
            .replace(/>/g, "&gt;").replace(/"/g, "&quot;");
    }
    function escJs(v) {
        return String(v || "").replace(/\\/g, "\\\\").replace(/'/g, "\\'");
    }
</script>
</body>
</html>
