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

    <!-- ① 수강생 정보 -->
    <div class="sub-box">
        <div class="board_top">
            <h3 class="board-title">수강생 정보</h3>
            <div class="right-area">
                <button type="button" class="btn basic" onclick="doSendMsg()">메시지 보내기</button>
            </div>
        </div>
        <div class="user-wrap mb10">
            <div class="user-img">
                <div class="user-photo">
                    <i class="xi-user" style="font-size:32px; color:#ccc;"></i>
                </div>
            </div>
            <div class="table_list">
                <ul class="list"><li class="head"><label>기관</label></li><li id="infoOrg">-</li></ul>
                <ul class="list"><li class="head"><label>이름</label></li><li id="infoNm">-</li></ul>
                <ul class="list"><li class="head"><label>학번</label></li><li id="infoStdntNo">-</li></ul>
                <ul class="list"><li class="head"><label>아이디</label></li><li id="infoUserId">-</li></ul>
                <ul class="list"><li class="head"><label>휴대폰번호</label></li><li id="infoMobile">-</li></ul>
                <ul class="list"><li class="head"><label>사용 이메일</label></li><li id="infoEmail">-</li></ul>
            </div>
        </div>
    </div>

    <!-- ② 주차별 학습기록 -->
    <div class="board_top">
        <h3 class="board-title">주차별 학습기록</h3>
        <span class="info_inline">
            <select class="form-select" id="selWkNo" style="width:100px;" onchange="loadWkDetail()">
                <c:forEach begin="1" end="${not empty wkCnt ? wkCnt : 15}" var="w">
                    <option value="${w}" ${param.wkNo == w ? 'selected' : ''}>${w}주차</option>
                </c:forEach>
            </select>
        </span>
        <div class="right-area">
            <div class="state-txt-label">
                <p><span class="state_ok"   aria-label="출석">○</span> 출석</p>
                <p><span class="state_late" aria-label="지각">△</span> 지각</p>
                <p><span class="state_no"   aria-label="결석">X</span> 결석</p>
            </div>
        </div>
    </div>

    <!-- ③ 주차 요약 + 차시 목록 -->
    <div class="course_history">

        <!-- 주차 요약 -->
        <div class="h_top" id="wkSummaryArea">
            <div class="h_left">
                <strong class="tit" id="wkTitleLeft">-</strong>
                <p class="desc" id="wkDescLeft">
                    <span>학습기간 <strong id="wkPeriodSpan">-</strong></span>
                    <span><strong id="wkTotMinSpan">-</strong></span>
                    <span><strong id="wkMthdSpan">-</strong></span>
                </p>
            </div>
            <div class="h_right">
                <p class="desc">
                    <span><span id="atndStsSpan" class="state_no" aria-label="결석">-</span><strong id="atndStsLabelSpan">-</strong></span>
                    <span><strong id="reqMinSpan">-</strong></span>
                    <span>학습시간<strong id="lrnTimeSpan">- ( 기간 후 : - )</strong></span>
                </p>
                <!-- 출석 상태에 따라 버튼 하나씩만 노출 -->
                <div id="atndBtnArea" style="display:none;">
                    <button type="button" class="btn s_type2" id="btnAtndProcess" onclick="doAtndProcess()">출석처리</button>
                    <button type="button" class="btn s_type2" id="btnAtndCancel"  onclick="doAtndCancel()" style="display:none; margin-left:4px;">출석처리 취소</button>
                </div>
            </div>
        </div>

        <!-- 차시 목록 -->
        <div class="h_content">
            <ul class="accordion course_week" id="chsiList">
                <li>
                    <div class="t_center" style="padding:20px; color:#aaa;">조회 중...</div>
                </li>
            </ul>
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
    var initWkNo = parseInt(_p.get("wkNo") || "1", 10) || 1;
    var currentWkSchdlId = "";
    var chsiLogCache = {};
    var chsiLogLoading = {};

    $(function () {
        $("#selWkNo").val(initWkNo);
        loadStdntInfo();
        loadWkDetail();
    });

    /* =====================================================
       팝업 닫기
       ===================================================== */
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
        } catch (e) {
            window.close();
        }
    }

    /* =====================================================
       수강생 기본정보
       ===================================================== */
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

    /* =====================================================
       주차 학습 상세 조회
       ===================================================== */
    function loadWkDetail() {
        var wkNo = parseInt($("#selWkNo").val(), 10);

        chsiLogCache = {};
        chsiLogLoading = {};

        $("#atndBtnArea").hide();
        $("#chsiList").html('<li><div class="t_center" style="padding:20px; color:#aaa;">조회 중...</div></li>');

        $.ajax({
            url: CTX + "/cls/selectStdntWkLrnSummary.do",
            type: "GET", dataType: "json",
            data: { sbjctId: sbjctId, userId: userId, wkNo: wkNo },
            success: function (res) {
                if (!res || res.result !== 1) {
                    renderWkSummary(null, wkNo);
                    renderChsiList([]);
                    return;
                }
                renderWkSummary(res.returnVO, wkNo);
                renderChsiList(res.returnVO ? (res.returnVO.chsiList || []) : []);
            },
            error: function () {
                renderWkSummary(null, wkNo);
                renderChsiList([]);
            }
        });
    }

    /* =====================================================
       주차 요약 렌더링
       ===================================================== */
    function renderWkSummary(d, wkNo) {
        var wkLabel = wkNo + "주차 학습기록";

        if (!d) {
            currentWkSchdlId = "";
            $("#wkTitleLeft").text(wkLabel);
            $("#wkPeriodSpan").text("-");
            $("#wkTotMinSpan").text("-");
            $("#wkMthdSpan").text("-");
            $("#atndStsSpan").attr("class", "state_no").attr("aria-label", "결석").text("-");
            $("#atndStsLabelSpan").text("-");
            $("#reqMinSpan").text("-");
            $("#lrnTimeSpan").text("- ( 기간 외: - )");
            $("#atndBtnArea").hide();
            return;
        }

        currentWkSchdlId = d.lctrWknoSchdlId || "";

        $("#wkTitleLeft").text(wkLabel);

        var period = (d.lrnStDt && d.lrnEndDt) ? d.lrnStDt + " ~ " + d.lrnEndDt : "-";
        $("#wkPeriodSpan").text(period);
        $("#wkTotMinSpan").text((d.totDurMin || 0) + "분");
        $("#wkMthdSpan").text(d.lrnMthd || "-");

        //            stsTxt/stsCls/stsLbl 은 화면 표시용으로 별도 분리
        var sts    = d.atndSts || "ABSNT";
        var stsCls = sts === "ATND" ? "state_ok"   : sts === "LATE" ? "state_late" : "state_no";
        var stsLbl = sts === "ATND" ? "출석"        : sts === "LATE" ? "지각"       : "결석";
        var stsTxt = sts === "ATND" ? "○"           : sts === "LATE" ? "△"          : "X";

        $("#atndStsSpan").attr("class", stsCls).attr("aria-label", stsLbl).text(stsTxt);
        $("#atndStsLabelSpan").text(stsLbl);

        $("#reqMinSpan").text((d.totalLrnMin || 0) + "분");

        var inPrd  = (d.inPrdLrnMin  || 0) + "분 " + (d.inPrdLrnSec  || 0) + "초";
        var aftPrd = (d.aftPrdLrnMin || 0) + "분 " + (d.aftPrdLrnSec || 0) + "초";
        $("#lrnTimeSpan").text(inPrd + " ( 기간 외: " + aftPrd + " )");

        // 버튼 영역 노출 조건: 출석인증 기간 내 + 마지막 주차 아님
        if ((d.atndCertUseYn || "N") === "Y" && (d.lastWkYn || "N") !== "Y") {
            $("#atndBtnArea").show();

            if (sts === "ATND") {
                // 이미 출석 → 취소 버튼만 표시
                $("#btnAtndProcess").hide();
                $("#btnAtndCancel").show();
            } else {
                // 지각/결석 → 출석처리 버튼만 표시
                $("#btnAtndProcess").show();
                $("#btnAtndCancel").hide();
            }
        } else {
            $("#atndBtnArea").hide();
        }
    }

    /* =====================================================
       차시 목록 렌더링
       ===================================================== */
    function renderChsiList(list) {
        var $ul = $("#chsiList").empty();

        if (!list || list.length === 0) {
            $ul.html('<li><div class="t_center" style="padding:20px; color:#aaa;">차시 정보가 없습니다.</div></li>');
            return;
        }

        list.forEach(function (chsi, idx) {
            var isOpen = (idx === 0);
            var liId   = "chsiLi_"   + idx;
            var contId = "chsiCont_" + idx;

            var lrnSts = chsi.lrnSts || "";
            var stsCls = lrnSts === "학습완료" ? "state_ok" : lrnSts === "학습중" ? "state_late" : "state_no";

            var $li = $('<li class="' + (isOpen ? 'active' : '') + '" id="' + liId + '"></li>');

            var $titleWrap = $(
                '<div class="title-wrap">'
                + '<div class="chasi_tit">[ ' + escHtml(chsi.chsiNo || '') + '차시 ] '
                + escHtml(chsi.chsiTitle || '') + '</div>'
                + '</div>'
            );

            var $a    = $('<a class="title" href="#"></a>');
            var $lbox = $(
                '<div class="lecture_box">'
                + '<div class="lecture_tit">'
                + '<p class="labels"><label class="label s_basic">' + escHtml(chsi.cntntsTypeNm || '') + '</label></p>'
                + '<strong>' + escHtml(chsi.cntntsTitle || '') + '</strong>'
                + '</div>'
                + '<div class="btn_right">'
                + '<label class="state ' + stsCls + '">' + escHtml(lrnSts || '-') + '</label>'
                + '</div>'
                + '<i class="arrow xi-angle-' + (isOpen ? 'up' : 'down') + '"></i>'
                + '</div>'
            );
            var $arrowIcon = $lbox.find(".arrow");

            $a.append($lbox);
            $a.on("click", function (e) {
                e.preventDefault();

                if (!chsiLogCache[chsi.cntntsId] && !chsiLogLoading[chsi.cntntsId]) {
                    loadChsiLog(chsi.cntntsId, idx);
                }

                toggleChsi(liId, contId, $arrowIcon);
            });
            $titleWrap.append($a);

            var $cont    = $('<div class="cont" id="' + contId + '"></div>');
            var $tblWrap = $(
                '<div class="table-wrap scroll">'
                + '<table class="table-type1">'
                + '<colgroup>'
                + '<col style="width:7%"><col style="width:20%"><col style="width:10%">'
                + '<col style="width:14%"><col style=""><col style="width:16%">'
                + '</colgroup>'
                + '<thead><tr><th colspan="6" class="all">학습기록</th></tr></thead>'
                + '<tbody id="logBody_' + idx + '">'
                + '<tr><td colspan="6" class="t_center" style="color:var(--txt_04);">조회 중...</td></tr>'
                + '</tbody>'
                + '</table></div>'
            );

            if (!isOpen) $cont.hide();
            $cont.append($tblWrap);

            if (isOpen && chsi.cntntsId) {
                loadChsiLog(chsi.cntntsId, idx);
            } else {
                renderLogBody(idx, []);
            }

            $li.append($titleWrap).append($cont);
            $ul.append($li);
        });
    }

    function loadChsiLog(cntntsId, idx) {
        chsiLogLoading[cntntsId] = true;
        renderLogLoading(idx);

        $.ajax({
            url: CTX + "/cls/selectStdntLrnLog.do",
            type: "GET",
            dataType: "json",
            data: {
                sbjctId: sbjctId,
                userId: userId,
                wkNo: parseInt($("#selWkNo").val(), 10),
                cntntsId: cntntsId
            },
            success: function (res) {
                var list = (res && res.returnList) ? res.returnList : [];
                chsiLogCache[cntntsId] = list;
                renderLogBody(idx, list);
            },
            error: function () {
                chsiLogCache[cntntsId] = [];
                renderLogBody(idx, []);
            },
            complete: function () {
                chsiLogLoading[cntntsId] = false;
            }
        });
    }

    function renderLogBody(idx, logList) {
        var $tbody = $("#logBody_" + idx).empty();

        if (!logList || logList.length === 0) {
            $tbody.html('<tr><td colspan="6" class="t_center" style="color:var(--txt_04);">학습 기록이 없습니다.</td></tr>');
            return;
        }

        logList.forEach(function (log) {
            $tbody.append(
                '<tr>'
                + '<td class="t_center" data-th="번호">'    + escHtml(log.lineNo  || '') + '</td>'
                + '<td class="t_center" data-th="접속일시">' + escHtml(log.logDttm || '') + '</td>'
                + '<td class="t_center" data-th="학습시간">' + escHtml(log.playPos || '') + '</td>'
                + '<td class="t_center" data-th="운영체제">' + escHtml(log.osNm    || '') + '</td>'
                + '<td class="t_left"   data-th="내용">'     + escHtml(log.actInfo || '') + '</td>'
                + '<td class="t_center" data-th="IP">'       + escHtml(log.ipAddr  || '') + '</td>'
                + '</tr>'
            );
        });
    }

    function renderLogLoading(idx) {
        $("#logBody_" + idx).html(
            '<tr><td colspan="6" class="t_center" style="color:var(--txt_04);">조회 중...</td></tr>'
        );
    }

    function toggleChsi(liId, contId, $arrowIcon) {
        var $li   = $("#" + liId);
        var $cont = $("#" + contId);

        if ($cont.is(":visible")) {
            $cont.slideUp(150);
            $li.removeClass("active");
            $arrowIcon.removeClass("xi-angle-up").addClass("xi-angle-down");
        } else {
            $cont.slideDown(150);
            $li.addClass("active");
            $arrowIcon.removeClass("xi-angle-down").addClass("xi-angle-up");
        }
    }

    /* =====================================================
       출석처리 후 부모 창 갱신
       ===================================================== */
    function refreshParentWeeklyPage(callbackName) {
        try {
            if (!callbackName) return;

            var targets = collectParentWindows();
            if (!targets || targets.length === 0) return;

            for (var i = 0; i < targets.length; i++) {
                var win = targets[i];

                try {
                    if (win && typeof win[callbackName] === "function") {
                        win[callbackName]();
                    }
                } catch (e) {
                    console.error("weekly parent callback relay fail", e);
                }
            }
        } catch (e) {
            console.error("weekly parent refresh failed", e);
        }
    }
    /**
     * 현재 창부터 최상위까지 부모 창 목록을 수집
     * 동일 origin 인 창만 포함 (cross-origin 은 접근 자체가 차단되므로 try/catch 로 걸러짐)
     */
    function collectParentWindows() {
        var wins   = [];
        var cursor = window;

        // 최대 10단계까지만 순회 (무한 루프 방지)
        for (var i = 0; i < 10; i++) {
            try {
                var parent = cursor.parent;
                if (!parent || parent === cursor) break; // 최상위 도달
                wins.push(parent);
                cursor = parent;
            } catch (e) {
                break; // cross-origin 창 → 더 이상 올라갈 수 없음
            }
        }

        return wins;
    }

    /* =====================================================
       출석 처리
       ===================================================== */
    function doAtndProcess() {
        var wkNo = parseInt($("#selWkNo").val(), 10);

        if (!currentWkSchdlId) {
            UiComm.showMessage("주차 스케줄 정보를 찾을 수 없습니다.", "error");
            return;
        }

        UiComm.showMessage(wkNo + "주차 출석 처리하시겠습니까?", "confirm")
            .then(function (result) {
                if (!result) return;
                $.ajax({
                    url: CTX + "/cls/updateAtndlcProcess.do",
                    type: "POST", dataType: "json",
                    data: {
                        sbjctId:         sbjctId,
                        userId:          userId,
                        wkNo:            wkNo,
                        lctrWknoSchdlId: currentWkSchdlId
                    },
                    success: function (res) {
                        UiComm.showMessage((res && res.message) || "출석 처리가 완료되었습니다.", "success");
                        if (res && res.result === 1) {
                            loadWkDetail();
                            refreshParentWeeklyPage("saveForcedAttendCallBack");
                        }
                    },
                    error: function () {
                        UiComm.showMessage("오류가 발생했습니다.", "error");
                    }
                });
            });
    }

    /* =====================================================
       출석 처리 취소
       ===================================================== */
    function doAtndCancel() {
        var wkNo = parseInt($("#selWkNo").val(), 10);

        if (!currentWkSchdlId) {
            UiComm.showMessage("주차 스케줄 정보를 찾을 수 없습니다.", "error");
            return;
        }

        UiComm.showMessage(wkNo + "주차 출석 처리를 취소하시겠습니까?", "confirm")
            .then(function (result) {
                if (!result) return;
                $.ajax({
                    url: CTX + "/cls/updateAtndlcCancel.do",
                    type: "POST", dataType: "json",
                    data: {
                        sbjctId:         sbjctId,
                        userId:          userId,
                        wkNo:            wkNo,
                        lctrWknoSchdlId: currentWkSchdlId
                    },
                    success: function (res) {
                        UiComm.showMessage((res && res.message) || "출석 처리가 취소되었습니다.", "success");
                        if (res && res.result === 1) {
                            loadWkDetail();
                            refreshParentWeeklyPage("cancelForcedAttendCallBack");
                        }
                    },
                    error: function () {
                        UiComm.showMessage("오류가 발생했습니다.", "error");
                    }
                });
            });
    }

    /* =====================================================
       메시지 보내기
       ===================================================== */
    function doSendMsg() {
        if (!userId) {
            UiComm.showMessage("학습자 정보가 없습니다.", "warning");
            return;
        }

        var usernm         = $("#infoNm").text() || "";
        var rcvUserInfoStr = userId + ";" + usernm + ";;";

        var form = window.parent && window.parent.alarmForm;
        if (!form) {
            UiComm.showMessage("메시지 발송 폼을 찾을 수 없습니다.", "warning");
            return;
        }

        form.action = '<%=CommConst.SYSMSG_URL_SEND%>';
        form.target = "msgWindow";
        form.elements['alarmType'].value      = "S";
        form.elements['rcvUserInfoStr'].value = rcvUserInfoStr;
        window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");
        form.submit();
    }

    /* =====================================================
       유틸
       ===================================================== */
    function escHtml(v) {
        return String(v)
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;");
    }
</script>
</body>
</html>
