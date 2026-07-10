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

    <div class="board_top class">
        <h3 class="board-title" id="popSbjctNm">
            <c:out value="${sbjctnm}"/>
            <c:if test="${not empty dvclasNo}">
                <c:out value=" ${dvclasNo}"/><spring:message code="cls.label.decls.name"/><%-- 반 --%>
            </c:if>
        </h3>
    </div>

    <!-- ① 수강생 정보 -->
    <div class="sub-box">
        <div class="board_top">
            <h3 class="board-title"><spring:message code="cls.label.student.info"/></h3><%--수강생 정보--%>
            <div class="right-area">
                <button type="button" class="btn basic" onclick="doSendMsg()"><spring:message code="cls.button.send.message"/></button><%--메시지 보내기--%>
            </div>
        </div>
        <div class="user-wrap mb10">
            <div class="user-img">
                <div class="user-photo">
                    <img id="infoPhoto" src="" alt="photo" hidden style="width:100%; height:100%; object-fit:cover;">
                </div>
            </div>
            <div class="table_list">
                <ul class="list"><li class="head"><label><spring:message code="cls.label.org"/></label></li><%--기관--%><li id="infoOrg">-</li></ul>
                <ul class="list"><li class="head"><label><spring:message code="common.name"/></label></li><%--이름--%><li id="infoNm">-</li></ul>
                <ul class="list"><li class="head"><label><spring:message code="cls.label.student.no"/></label></li><%--학번--%><li id="infoStdntNo">-</li></ul>
                <ul class="list"><li class="head"><label><spring:message code="common.id"/></label></li><%--아이디--%><li id="infoUserId">-</li></ul>
                <ul class="list"><li class="head"><label><spring:message code="cls.label.mobile.number"/></label></li><%--휴대폰번호--%><li id="infoMobile">-</li></ul>
                <ul class="list"><li class="head"><label><spring:message code="cls.label.user.email"/></label></li><%--사용 이메일--%><li id="infoEmail">-</li>
                </ul>
            </div>
        </div>
    </div>

    <!-- ② 주차별 학습기록 -->
    <div class="board_top">
        <h3 class="board-title"><spring:message code="cls.label.weekly.record"/></h3><%--주차별 학습기록--%>
        <span class="info_inline">
            <select class="form-select type-num w100" id="selWkNo" onchange="loadWkDetail()">
                <c:forEach begin="1" end="${not empty wkCnt ? wkCnt : 15}" var="w">
                    <option value="${w}" ${param.wkNo == w ? 'selected' : ''}>${w}<spring:message code="common.week"/></option><%--주차--%>
                </c:forEach>
            </select>
        </span>
        <div class="right-area">
            <div class="state-txt-label">
                <p><span class="state_ok" aria-label='<spring:message code="cls.label.attendance"/><%-- 출석 --%>'>○</span><spring:message code="cls.label.attendance"/><%-- 출석 --%></p>
                <p><span class="state_late" aria-label='<spring:message code="cls.label.late"/><%-- 지각 --%>'>△</span><spring:message code="cls.label.late"/><%-- 지각 --%></p>
                <p><span class="state_no" aria-label='<spring:message code="cls.label.absence"/><%-- 결석 --%>'>X</span><spring:message code="cls.label.absence"/><%-- 결석 --%></p>
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
                    <span><spring:message code="cls.label.learning.period"/><%--학습기간--%> <strong id="wkPeriodSpan">-</strong></span>
                    <span><strong id="wkTotMinSpan">-</strong></span>
                    <span><strong id="wkMthdSpan">-</strong></span>
                </p>
            </div>
            <div class="h_right">
                <p class="desc">
                    <span><span id="atndStsSpan" class="state_none" aria-label="<spring:message code='cls.label.study.notlearned'/>">-</span><strong id="atndStsLabelSpan">-</strong></span><%-- 미학습 --%>
                    <span><strong id="reqMinSpan">-</strong></span>
                    <span><spring:message code="cls.label.learning.time"/><%--학습시간--%><strong id="lrnTimeSpan">- ( <spring:message code="cls.label.after.period"/><%--기간 후--%> : - )</strong></span>
                </p>
                <!-- 출석 상태에 따라 버튼 하나씩만 노출 -->
                <div id="atndBtnArea" style="display:none;">
                    <button type="button" class="btn s_type2" id="btnAtndProcess" onclick="doAtndProcess()"><spring:message code="cls.button.attend.process"/></button><%--출석처리--%>
                    <button type="button" class="btn s_type2" id="btnAtndCancel"  onclick="doAtndCancel()" style="display:none; margin-left:4px;"><spring:message code="cls.button.attend.cancel"/></button><%--출석처리 취소--%>
                </div>
            </div>
        </div>

        <!-- 차시 목록 -->
        <div class="h_content">
            <ul class="accordion course_week" id="chsiList">
                <li>
                    <div class="t_center" style="padding:20px; color:#aaa;"><spring:message code="cls.label.loading"/></div><%--조회 중...--%>
                </li>
            </ul>
        </div>

    </div>

    <!-- 닫기 -->
    <div class="modal_btns">
        <button type="button" class="btn type2" onclick="closePopup()"><spring:message code="button.close"/></button><%--닫기--%>
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
        ajaxCall(CTX + "/clssts/selectClsStsStdntInfo.do", { sbjctId: sbjctId, userId: userId }, function (res) {
                if (res && res.result === 1 && res.returnVO) {
                    var v = res.returnVO;
                    $("#infoOrg").text(v.orgnm    || "-");
                    $("#infoNm").text(v.usernm    || "-");
                    $("#infoStdntNo").text(v.stdntNo || "-");
                    $("#infoUserId").text(v.userId   || "-");
                    $("#infoMobile").text(v.mobileNo || "-");
                    $("#infoEmail").text(v.email     || "-");
                    renderProfilePhoto(v.photoFileId);
                }
            },
            null,
            false
        );
    }

    function renderProfilePhoto(photoFileId) {
        if (isRenderablePhotoFileId(photoFileId)) {
            $("#infoPhoto")
                .off("error")
                .on("error", function () {
                    $(this).prop("hidden", true).attr("src", "");
                })
                .attr("src", photoFileId)
                .prop("hidden", false);
        } else {
            $("#infoPhoto").off("error").prop("hidden", true).attr("src", "");
        }
    }

    function isRenderablePhotoFileId(photoFileId) {
        if (!photoFileId) return false;
        var normalized = String(photoFileId).trim();
        if (!normalized || normalized === "user_img") return false;
        if (normalized.indexOf("photo_user_sample") !== -1) return false;
        if (normalized.indexOf("user_no_img") !== -1) return false;
        return normalized.indexOf("data:image") === 0
            || normalized.indexOf("/") === 0
            || normalized.indexOf("http://") === 0
            || normalized.indexOf("https://") === 0
            || normalized.indexOf("blob:") === 0;
    }

    /* =====================================================
       주차 학습 상세 조회
       ===================================================== */
    function loadWkDetail() {
        var wkNo = parseInt($("#selWkNo").val(), 10);

        chsiLogCache = {};
        chsiLogLoading = {};

        $("#atndBtnArea").hide();
        $("#chsiList").html('<li><div class="t_center" style="padding:20px; color:#aaa;"><spring:message code="cls.label.loading"/></div></li>');<%--조회 중...--%>

        ajaxCall(CTX + "/clssts/selectClsStsStdntWkLrnSummary.do", { sbjctId: sbjctId, userId: userId, wkNo: wkNo }, function (res) {
                if (!res || res.result !== 1) {
                    renderWkSummary(null, wkNo);
                    renderChsiList([]);
                    return;
                }
                renderWkSummary(res.returnVO, wkNo);
                renderChsiList(res.returnVO ? (res.returnVO.chsiList || []) : []);
            },
            function () {
                renderWkSummary(null, wkNo);
                renderChsiList([]);
            },
            false
        );
    }

    /* =====================================================
       주차 요약 렌더링
       ===================================================== */
    function renderWkSummary(d, wkNo) {
        var wkLabel = wkNo + '<spring:message code="common.week"/><%-- 주차 --%> ' + '<spring:message code="cls.label.learning.history"/><%-- 학습기록 --%>';

        if (!d) {
            currentWkSchdlId = "";
            $("#wkTitleLeft").text(wkLabel);
            $("#wkPeriodSpan").text("-");
            $("#wkTotMinSpan").text("-");
            $("#wkMthdSpan").text("-");
            $("#atndStsSpan")
                .attr("class", "state_none")
                .attr("aria-label", '<spring:message code="cls.label.study.notlearned"/><%-- 미학습 --%>')
                .text("-");
            $("#atndStsLabelSpan").text("-");
            $("#reqMinSpan").text("-");
            $("#lrnTimeSpan").text("- ( " + '<spring:message code="cls.label.after.period"/><%-- 기간 후 --%>' + " : - )");
            $("#atndBtnArea").hide();
            return;
        }

        currentWkSchdlId = d.lctrWknoSchdlId || "";

        $("#wkTitleLeft").text(wkLabel);

        var period = (d.lrnStDt && d.lrnEndDt) ? d.lrnStDt + " ~ " + d.lrnEndDt : "-";
        $("#wkPeriodSpan").text(period);
        $("#wkTotMinSpan").text((d.totDurMin || 0) + '<spring:message code="date.minute"/><%-- 분 --%>');
        $("#wkMthdSpan").text(d.lrnMthd || "-");

        // stsTxt/stsCls/stsLbl 은 화면 표시용으로 별도 분리
        var sts = d.atndSts || "NOTSTARTED";
        var stsCls = sts === "ATND" ? "state_ok" : sts === "LATE" ? "state_late" : sts === "ABSNT" ? "state_no" : "state_none";
        var stsLbl = sts === "ATND"
            ? '<spring:message code="cls.label.attendance"/><%-- 출석 --%>'
            : sts === "LATE"
                ? '<spring:message code="cls.label.late"/><%-- 지각 --%>'
                : sts === "ABSNT"
                    ? '<spring:message code="cls.label.absence"/><%-- 결석 --%>'
                    : '<spring:message code="cls.label.study.notlearned"/><%-- 미학습 --%>';
        var stsTxt = sts === "ATND" ? "○" : sts === "LATE" ? "△" : sts === "ABSNT" ? "X" : "-";

        $("#atndStsSpan").attr("class", stsCls).attr("aria-label", stsLbl).text(stsTxt);
        $("#atndStsLabelSpan").text(stsLbl);

        $("#reqMinSpan").text((d.totalLrnMin || 0) + '<spring:message code="date.minute"/><%-- 분 --%>');

        var inPrd  = (d.inPrdLrnMin || 0) + '<spring:message code="date.minute"/><%-- 분 --%> ' + (d.inPrdLrnSec || 0) +
            '<spring:message code="date.second"/><%-- 초 --%>';
        var aftPrd = (d.aftPrdLrnMin || 0) + '<spring:message code="date.minute"/><%-- 분 --%> ' + (d.aftPrdLrnSec || 0) +
            '<spring:message code="date.second"/><%-- 초 --%>';
        $("#lrnTimeSpan").text(inPrd + " ( " + '<spring:message code="cls.label.after.period"/><%-- 기간 후 --%>' + " : " +
            aftPrd + " )");

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
            $ul.html('<li><div class="t_center" style="padding:20px; color:#aaa;"><spring:message code="cls.empty.chasi.info"/><%-- 차시 정보가 없습니다. --%></div></li>');
            return;
        }

        list.forEach(function (chsi, idx) {
            var isOpen = (idx === 0);
            var liId   = "chsiLi_"   + idx;
            var contId = "chsiCont_" + idx;

            var lrnSts = chsi.lrnSts || "";
            var stsCls = lrnSts === '<spring:message code="cls.label.study.complete"/><%-- 학습완료 --%>' ? "state_ok" : lrnSts === '<spring:message code="cls.label.study.progress"/><%-- 학습중 --%>' ? "state_late" : "state_no";

            var $li = $('<li class="' + (isOpen ? 'active' : '') + '" id="' + liId + '"></li>');

            var chsiLabel = '[ ' + UiComm.escapeHtml(String(chsi.chsiNo || '')) + '<spring:message code="common.label.lesson.cnts"/><%-- 차시 --%> ]';

            var $titleWrap = $(
                '<div class="title-wrap">'
                + '<div class="chasi_tit">' + chsiLabel + ' '
                + UiComm.escapeHtml(chsi.chsiTitle || '') + '</div>'
                + '</div>'
            );

            var $a    = $('<a class="title" href="#"></a>');
            var $lbox = $(
                '<div class="lecture_box">'
                + '<div class="lecture_tit">'
                + '<p class="labels"><label class="label s_basic">' + UiComm.escapeHtml(chsi.cntntsTypeNm || '') + '</label></p>'
                + '<strong>' + UiComm.escapeHtml(chsi.cntntsTitle || '') + '</strong>'
                + '</div>'
                + '<div class="btn_right">'
                + '<label class="state ' + stsCls + '">' + UiComm.escapeHtml(lrnSts || '-') + '</label>'
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
                + '<col style="width:7%"><col style="width:24%"><col style=""><col style="width:16%"><col style="width:16%">'
                + '</colgroup>'
                + '<thead><tr><th colspan="5" class="all"><spring:message code="cls.label.learning.history"/></th></tr></thead>'<%--학습기록--%>
                + '<tbody id="logBody_' + idx + '">'
                + '<tr><td colspan="5" class="t_center" style="color:var(--txt_04);"><spring:message code="cls.label.loading"/></td></tr>'<%--조회 중...--%>
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

        ajaxCall(CTX + "/clssts/selectClsStsStdntLrnLog.do", {
                sbjctId: sbjctId,
                userId: userId,
                wkNo: parseInt($("#selWkNo").val(), 10),
                cntntsId: cntntsId
            },
            function (res) {
                var list = (res && res.returnList) ? res.returnList : [];
                chsiLogCache[cntntsId] = list;
                renderLogBody(idx, list);
                chsiLogLoading[cntntsId] = false;
            },
            function () {
                chsiLogCache[cntntsId] = [];
                renderLogBody(idx, []);
                chsiLogLoading[cntntsId] = false;
            },
            false
        );
    }

    function renderLogBody(idx, logList) {
        var $tbody = $("#logBody_" + idx).empty();

        if (!logList || logList.length === 0) {
            $tbody.html('<tr><td colspan="5" class="t_center" style="color:var(--txt_04);"><spring:message code="cls.empty.learning.record"/></td></tr>');<%--학습 기록이 없습니다.--%>
            return;
        }

        logList.forEach(function (log) {
            $tbody.append(
                '<tr>'
                + '<td class="t_center" data-th="' + '<spring:message code="common.number.no"/>' + '">' + UiComm.escapeHtml(String(log.lineNo || '')) + '</td>' <%-- 번호 --%>
                + '<td class="t_center" data-th="' + '<spring:message code="cls.label.access.datetime"/>' + '">' + UiComm.escapeHtml(log.logDttm || '') + '</td>' <%-- 접속일시 --%>
                + '<td class="t_center" data-th="' + '<spring:message code="cls.label.learning.time"/>' + '">' + UiComm.escapeHtml(String(log.playPos || '')) + '</td>' <%-- 학습시간 --%>
                + '<td class="t_left" data-th="' + '<spring:message code="cls.label.content"/>' + '">' + UiComm.escapeHtml(log.actInfo || '') + '</td>' <%-- 내용 --%>
                + '<td class="t_center" data-th="' + '<spring:message code="cls.label.ip"/>' + '">' + UiComm.escapeHtml(log.ipAddr || '') + '</td>' <%-- IP --%>
                + '</tr>'
            );
        });
    }

    function renderLogLoading(idx) {
        $("#logBody_" + idx).html(
            '<tr><td colspan="5" class="t_center" style="color:var(--txt_04);"><spring:message code="cls.label.loading"/></td></tr>'<%--조회 중...--%>
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
        if (!callbackName) return;

        var targets = collectParentWindows();
        if (!targets || targets.length === 0) return;

        for (var i = 0; i < targets.length; i++) {
            var win = targets[i];

            try {
                if (win && typeof win[callbackName] === "function") {
                    win[callbackName]();
                }
            } catch (e) {}
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
            UiComm.showMessage('<spring:message code="cls.alert.week.schedule.notfound"/><%-- 주차 스케줄 정보를 찾을 수 없습니다. --%>', "error");
            return;
        }
        var confirmMsg = '<spring:message code="cls.confirm.attend.process.week"/><%-- {0}주차 출석 처리하시겠습니까? --%>'.replace('{0}', wkNo);
        UiComm.showMessage(confirmMsg, "confirm")
            .then(function (result) {
                if (!result) return;
                ajaxCall(CTX + "/clssts/updateClsStsAtndlcProcess.do", {
                        sbjctId:         sbjctId,
                        userId:          userId,
                        wkNo:            wkNo,
                        lctrWknoSchdlId: currentWkSchdlId
                    },
                    function (res) {
                        if (!(res && res.result === 1)) {
                            UiComm.showMessage((res && res.message) || '<spring:message code="fail.common.msg"/>', "error"); <%-- 에러가 발생했습니다! --%>
                            return;
                        }
                        UiComm.showMessage((res && res.message) || '<spring:message code="cls.alert.attend.process.success"/>', "success");<%--출석 처리가 완료되었습니다.--%>
                        if (res && res.result === 1) {
                            loadWkDetail();
                            refreshParentWeeklyPage("saveForcedAttendCallBack");
                        }
                    },
                    function () {
                        UiComm.showMessage('<spring:message code="fail.common.msg"/><%-- 오류가 발생했습니다. --%>', "error");
                    },
                    true
                );
            });
    }

    /* =====================================================
       출석 처리 취소
       ===================================================== */
    function doAtndCancel() {
        var wkNo = parseInt($("#selWkNo").val(), 10);

        if (!currentWkSchdlId) {
            UiComm.showMessage('<spring:message code="cls.alert.week.schedule.notfound"/><%-- 주차 스케줄 정보를 찾을 수 없습니다. --%>', "error");
            return;
        }

        var confirmMsg = '<spring:message code="cls.confirm.attend.cancel.week"/><%-- {0}주차 출석 처리를 취소하시겠습니까? --%>'.replace('{0}', wkNo);
        UiComm.showMessage(confirmMsg, "confirm")
            .then(function (result) {
                if (!result) return;
                ajaxCall(CTX + "/clssts/updateClsStsAtndlcCancel.do", {
                        sbjctId:         sbjctId,
                        userId:          userId,
                        wkNo:            wkNo,
                        lctrWknoSchdlId: currentWkSchdlId
                    },
                    function (res) {
                        if (!(res && res.result === 1)) {
                            UiComm.showMessage((res && res.message) || '<spring:message code="fail.common.msg"/>', "error"); <%-- 에러가 발생했습니다! --%>
                            return;
                        }
                        UiComm.showMessage((res && res.message) || '<spring:message code="cls.alert.attend.cancel.success"/>', "success");<%--출석 처리가 취소되었습니다.--%>
                        if (res && res.result === 1) {
                            loadWkDetail();
                            refreshParentWeeklyPage("cancelForcedAttendCallBack");
                        }
                    },
                    function () {
                        UiComm.showMessage('<spring:message code="fail.common.msg"/><%-- 오류가 발생했습니다. --%>', "error");
                    },
                    true
                );
            });
    }

    /* =====================================================
       메시지 보내기
       ===================================================== */
    function doSendMsg() {
        if (!userId) {
            UiComm.showMessage('<spring:message code="cls.empty.student.info"/>', "warning");<%--학습자 정보가 없습니다.--%>
            return;
        }

        var usernm         = $("#infoNm").text() || "";
        var rcvUserInfoStr = userId + ";" + usernm + ";;";

        var form = window.parent && window.parent.alarmForm;
        if (!form) {
            UiComm.showMessage('<spring:message code="cls.alert.message.form.notfound"/>', "warning");<%--메시지 발송 폼을 찾을 수 없습니다.--%>
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
</script>
</body>
</html>
