<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="dashboard"/>
    </jsp:include>
</head>
<body>
<div class="pop-body">

    <div class="board_top class">
        <h3 class="board-title">
            <c:out value="${sbjctnm}"/>
            <c:if test="${not empty dvclasNo}">
                <c:out value=" ${dvclasNo}"/><spring:message code="cls.label.decls.name"/><%-- 반 --%>
            </c:if>
        </h3>
    </div>

    <div class="sub-box">
        <div class="board_top">
            <h3 class="board-title"><spring:message code="cls.label.student.info"/><%-- 수강생 정보 --%></h3>
            <div class="right-area">
                <button type="button" class="btn basic" onclick="doSendMsg()"><spring:message code="cls.button.send.message"/><%-- 메시지 보내기 --%></button>
            </div>
        </div>
        <div class="user-wrap mb10">
            <div class="user-img">
                <div class="user-photo">
                    <img id="infoPhoto" src="" alt="photo" hidden style="width:100%; height:100%; object-fit:cover;">
                </div>
            </div>
            <div class="table_list">
                <ul class="list"><li class="head"><label><spring:message code="cls.label.org"/><%-- 기관 --%></label></li><li id="infoOrg">-</li></ul>
                <ul class="list"><li class="head"><label><spring:message code="common.name"/><%-- 이름 --%></label></li><li id="infoNm">-</li></ul>
                <ul class="list"><li class="head"><label><spring:message code="cls.label.student.no"/><%-- 학번 --%></label></li><li id="infoStdntNo">-</li></ul>
                <ul class="list"><li class="head"><label><spring:message code="common.id"/><%-- 아이디 --%></label></li><li id="infoUserId">-</li></ul>
                <ul class="list"><li class="head"><label><spring:message code="cls.label.mobile.number"/><%-- 휴대폰번호 --%></label></li><li id="infoMobile">-</li></ul>
                <ul class="list"><li class="head"><label><spring:message code="common.email"/><%-- 이메일 --%></label></li><li id="infoEmail">-</li></ul>
            </div>
        </div>
    </div>

    <div class="board_top">
        <h3 class="board-title"><spring:message code="cls.label.weekly.record"/><%-- 주차별 학습기록 --%></h3>
        <span class="info_inline">
            <select class="form-select type-num w100" id="selWkNo" onchange="loadWeekDetail()">
                <c:forEach begin="1" end="${not empty wkCnt ? wkCnt : 15}" var="w">
                    <option value="${w}" ${wkNo == w ? 'selected' : ''}>${w}<spring:message code="common.week"/><%-- 주차 --%></option>
                </c:forEach>
            </select>
        </span>
        <div class="right-area">
            <div class="state-txt-label">
                <p><span class="state_ok">○</span> <spring:message code="cls.label.attendance"/><%-- 출석 --%></p>
                <p><span class="state_late">△</span> <spring:message code="cls.label.late"/><%-- 지각 --%></p>
                <p><span class="state_no">X</span> <spring:message code="cls.label.absence"/><%-- 결석 --%></p>
            </div>
        </div>
    </div>

    <div class="course_history">
        <div class="h_top" id="wkSummaryArea">
            <div class="h_left">
                <strong class="tit" id="wkTitleLeft">-</strong>
                <p class="desc">
                    <span><spring:message code="cls.label.learning.period"/><%-- 학습기간 --%> <strong id="wkPeriodSpan">-</strong></span>
                    <span><strong id="wkTotMinSpan">-</strong></span>
                    <span><strong id="wkMthdSpan">-</strong></span>
                </p>
            </div>
            <div class="h_right">
                <p class="desc">
                    <span><span id="atndStsSpan" class="state_no">-</span><strong id="atndStsLabelSpan">-</strong></span>
                    <span><strong id="reqMinSpan">-</strong></span>
                    <span><spring:message code="cls.label.learning.time"/><%-- 학습시간 --%> <strong id="lrnTimeSpan">-</strong></span>
                </p>
            </div>
        </div>

        <div class="h_content">
            <ul class="accordion course_week" id="chsiList">
                <li>
                    <div class="t_center" style="padding:20px; color:#aaa;"><spring:message code="cls.label.loading"/><%-- 조회 중... --%></div>
                </li>
            </ul>
        </div>
    </div>

    <div class="modal_btns">
        <button type="button" class="btn type2" onclick="closePopup()"><spring:message code="common.button.close"/><%-- 닫기 --%></button>
    </div>
</div>

<script type="text/javascript">
    var CTX = "<%=request.getContextPath()%>";
    var EPARAM = '<c:out value="${encParams}" />';
    var sbjctId = '<c:out value="${sbjctId}" />';
    var dvclasNo = '<c:out value="${dvclasNo}" />';
    var userId = '<c:out value="${userId}" />';
    var initWkNo = parseInt('<c:out value="${wkNo}" />', 10) || 1;
    var chsiLogCache = {};
    var chsiLogLoading = {};

    $(function () {
        $("#selWkNo").val(initWkNo);
        loadStudentInfo();
        loadWeekDetail();
    });

    function closePopup() {
        try {
            var dlgId = null;
            if (window.frameElement) {
                dlgId = $(window.frameElement).closest('[data-dialog-id]').data('dialog-id');
            }
            if (dlgId && window.parent && typeof window.parent.UiDialog === 'function') {
                var dlg = window.parent.UiDialog(dlgId);
                if (dlg && typeof dlg.close === 'function') {
                    dlg.close();
                    return;
                }
            }
            $(window.frameElement).closest('.ui-dialog').find('.ui-dialog-titlebar-close').trigger('click');
        } catch(e) {
            window.close();
        }
    }

    function loadStudentInfo() {
        ajaxCall(CTX + "/lrnsts/selectLrnStsDetail.do", baseData(), function (res) {
                if (!res || res.result !== 1 || !res.returnVO) {
                    return;
                }

                if (res.encParams) {
                    EPARAM = res.encParams;
                }

                var d = res.returnVO;
                $("#infoOrg").text(nvl(d.orgNm));
                $("#infoNm").text(nvl(d.usernm));
                $("#infoStdntNo").text(nvl(d.stdntNo));
                $("#infoUserId").text(nvl(d.userId));
                $("#infoMobile").text(nvl(d.mobileNo));
                $("#infoEmail").text(nvl(d.email));
                renderProfilePhoto(d.photoFileId);
            }, null, false);
    }

    function loadWeekDetail() {
        var wkNo = parseInt($("#selWkNo").val(), 10) || 1;
        var data = baseData();
        data.wkNo = wkNo;

        chsiLogCache = {};
        chsiLogLoading = {};
        $("#chsiList").html('<li><div class="t_center" style="padding:20px; color:#aaa;"><spring:message code="cls.label.loading"/><%-- 조회 중... --%></div></li>');

        ajaxCall(CTX + "/lrnsts/selectLrnStsWkLrnSummary.do", data, function (res) {
                if (!res || res.result !== 1 || !res.returnVO) {
                    renderWeekSummary(null, wkNo);
                    renderChsiList([]);
                    return;
                }

                if (res.encParams) {
                    EPARAM = res.encParams;
                }

                renderWeekSummary(res.returnVO, wkNo);
                renderChsiList(res.returnVO.chsiList || []);
            }, function () {
                renderWeekSummary(null, wkNo);
                renderChsiList([]);
            }, false);
    }

    function renderWeekSummary(d, wkNo) {
        $("#wkTitleLeft").text(wkNo + "<spring:message code='common.week'/> <spring:message code='cls.label.weekly.record'/>"); <%-- 주차별 학습기록 --%>

        if (!d) {
            $("#wkPeriodSpan").text("-");
            $("#wkTotMinSpan").text("-");
            $("#wkMthdSpan").text("-");
            $("#atndStsSpan").attr("class", "state_no").text("-");
            $("#atndStsLabelSpan").text("-");
            $("#reqMinSpan").text("-");
            $("#lrnTimeSpan").text("-");
            return;
        }

        $("#wkPeriodSpan").text((nvlDate(d.lrnStDt) + " ~ " + nvlDate(d.lrnEndDt)).replace("- ~ -", "-"));
        $("#wkTotMinSpan").text(nvlNum(d.totDurMin) + '<spring:message code="date.minute"/><%-- 분 --%>');
        $("#wkMthdSpan").text(nvl(d.lrnMthd));

        var stsInfo = getStsInfo(d.atndSts);
        $("#atndStsSpan").attr("class", stsInfo.cls).text(stsInfo.mark);
        $("#atndStsLabelSpan").text(stsInfo.label);
        $("#reqMinSpan").text('<spring:message code="common.page.total"/><%-- 총 --%> ' + '<spring:message code="cls.label.learning.time"/><%-- 학습시간 --%> ' + nvlNum(d.totalLrnMin) + '<spring:message code="date.minute"/><%-- 분 --%>');
        $("#lrnTimeSpan").text(
            nvlNum(d.inPrdLrnMin) + '<spring:message code="date.minute"/><%-- 분 --%> ' + nvlNum(d.inPrdLrnSec) + '<spring:message code="date.second"/><%-- 초 --%>'
            + " (" + '<spring:message code="cls.label.after.period"/><%-- 기간 후 --%>' + " : "
            + nvlNum(d.aftPrdLrnMin) + '<spring:message code="date.minute"/><%-- 분 --%> ' + nvlNum(d.aftPrdLrnSec) + '<spring:message code="date.second"/><%-- 초 --%>)'
        );
    }

    function renderChsiList(list) {
        var $ul = $("#chsiList").empty();

        if (!list || list.length === 0) {
            $ul.html('<li><div class="t_center" style="padding:20px; color:#aaa;"><spring:message code="cls.empty.chasi.info"/><%-- 차시 정보가 없습니다. --%></div></li>');
            return;
        }

        $.each(list, function (idx, chsi) {
            var isOpen = idx === 0;
            var liId = "chsiLi_" + idx;
            var contId = "chsiCont_" + idx;
            var logBodyId = "logBody_" + idx;
            var stsInfo = getLearnStsInfo(chsi.lrnSts);

            var html = ''
                + '<li class="' + (isOpen ? 'active' : '') + '" id="' + liId + '">'
                + '  <div class="title-wrap">'
                + '      <div class="chasi_tit">[ ' + UiComm.escapeHtml(String(nvl(chsi.chsiNo))) + '차시 ] ' + UiComm.escapeHtml(String(nvl(chsi.chsiTitle))) + '</div>'
                + '      <a class="title" href="#_" onclick="toggleChsi(\'' + liId + '\',\'' + contId + '\',\'' + escapeJs(chsi.cntntsId || '') + '\',' + idx + '); return false;">'
                + '          <div class="lecture_box">'
                + '              <div class="lecture_tit">'
                + '                  <p class="labels"><label class="label s_basic">' + UiComm.escapeHtml(String(nvl(chsi.cntntsTypeNm))) + '</label></p>'
                + '                  <strong>' + UiComm.escapeHtml(String(nvl(chsi.cntntsTitle))) + '</strong>'
                + '              </div>'
                + '              <div class="btn_right">'
                + '                  <label class="state ' + stsInfo.cls + '">' + UiComm.escapeHtml(String(stsInfo.label)) + '</label>'
                + '              </div>'
                + '              <i class="arrow xi-angle-' + (isOpen ? 'up' : 'down') + '"></i>'
                + '          </div>'
                + '      </a>'
                + '  </div>'
                + '  <div class="cont" id="' + contId + '"' + (isOpen ? '' : ' style="display:none;"') + '>'
                + '      <div class="table-wrap scroll">'
                + '          <table class="table-type1">'
                + '              <colgroup><col style="width:7%"><col style="width:24%"><col><col style="width:16%"><col style="width:16%"></colgroup>'
                + '              <thead><tr><th colspan="5" class="all"><spring:message code="cls.label.learning.history"/><%-- 학습기록 --%></th></tr></thead>'
                + '              <tbody id="' + logBodyId + '"><tr><td colspan="5" class="t_center" style="color:var(--txt_04);"><spring:message code="cls.label.loading"/><%-- 조회 중... --%></td></tr></tbody>'
                + '          </table>'
                + '      </div>'
                + '  </div>'
                + '</li>';

            $ul.append(html);

            if (isOpen && chsi.cntntsId) {
                loadLog(chsi.cntntsId, idx);
            }
        });
    }

    function toggleChsi(liId, contId, cntntsId, idx) {
        var $li = $("#" + liId);
        var $cont = $("#" + contId);
        var $icon = $li.find(".arrow");

        if (!chsiLogCache[cntntsId] && !chsiLogLoading[cntntsId]) {
            loadLog(cntntsId, idx);
        }

        if ($cont.is(":visible")) {
            $cont.slideUp(150);
            $li.removeClass("active");
            $icon.removeClass("xi-angle-up").addClass("xi-angle-down");
        } else {
            $cont.slideDown(150);
            $li.addClass("active");
            $icon.removeClass("xi-angle-down").addClass("xi-angle-up");
        }
    }

    function loadLog(cntntsId, idx) {
        var data = baseData();
        data.cntntsId = cntntsId;
        data.wkNo = parseInt($("#selWkNo").val(), 10) || 1;
        chsiLogLoading[cntntsId] = true;
        renderLogLoading(idx);

        ajaxCall(CTX + "/lrnsts/selectLrnStsLrnLogList.do", data, function (res) {
                var list = (res && res.result === 1 && res.returnList) ? res.returnList : [];
                if (res && res.encParams) {
                    EPARAM = res.encParams;
                }
                chsiLogCache[cntntsId] = list;
                renderLogBody(idx, list);
                chsiLogLoading[cntntsId] = false;
            }, function () {
                chsiLogCache[cntntsId] = [];
                renderLogBody(idx, []);
                chsiLogLoading[cntntsId] = false;
            }, false);
    }

    function renderLogLoading(idx) {
        $("#logBody_" + idx).html('<tr><td colspan="5" class="t_center" style="color:var(--txt_04);"><spring:message code="cls.label.loading"/><%-- 조회 중... --%></td></tr>');
    }

    function renderLogBody(idx, logList) {
        var $tbody = $("#logBody_" + idx).empty();

        if (!logList || logList.length === 0) {
            $tbody.html('<tr><td colspan="5" class="t_center" style="color:var(--txt_04);"><spring:message code="cls.empty.learning.record"/><%-- 학습기록이 없습니다. --%></td></tr>');
            return;
        }

        $.each(logList, function (_, log) {
            $tbody.append(
                '<tr>'
                + '<td class="t_center">' + UiComm.escapeHtml(String(nvl(log.lineNo))) + '</td>'
                + '<td class="t_center">' + UiComm.escapeHtml(String(nvl(log.logDttm))) + '</td>'
                + '<td class="t_center">' + UiComm.escapeHtml(String(nvl(log.playPos))) + '</td>'
                + '<td class="t_left">' + UiComm.escapeHtml(String(nvl(log.actInfo))) + '</td>'
                + '<td class="t_center">' + UiComm.escapeHtml(String(nvl(log.ipAddr))) + '</td>'
                + '</tr>'
            );
        });
    }

    function baseData() {
        var data = { sbjctId: sbjctId, userId: userId };
        if (EPARAM) {
            data.encParams = EPARAM;
        }
        return data;
    }

    function getStsInfo(sts) {
        if (sts === "ATND") return { cls: "state_ok", mark: "○", label: "<spring:message code='cls.label.attendance'/>" }; <%-- 출석 --%>
        if (sts === "LATE") return { cls: "state_late", mark: "△", label: "<spring:message code='cls.label.late'/>" }; <%-- 지각 --%>
        if (sts === "ABSNT") return { cls: "state_no", mark: "X", label: "<spring:message code='cls.label.absence'/>" }; <%-- 결석 --%>
        return { cls: "state_none", mark: "-", label: "<spring:message code='cls.label.study.notlearned'/>" }; <%-- 미학습 --%>
    }

    function getLearnStsInfo(sts) {
        if (sts === "학습완료") return { cls: "state_ok", label: "<spring:message code='cls.label.study.complete'/>" }; <%-- 학습완료 --%>
        if (sts === "학습중") return { cls: "state_late", label: "<spring:message code='cls.label.study.progress'/>" }; <%-- 학습중 --%>
        return { cls: "state_no", label: "<spring:message code='cls.label.study.notlearned'/>" }; <%-- 미학습 --%>
    }

    function doSendMsg() {
        if (!userId) {
            return;
        }

        var form = resolveAlarmForm();
        if (!form) {
            if (typeof UiComm !== "undefined" && UiComm.showMessage) {
                UiComm.showMessage("<spring:message code='cls.alert.message.form.notfound'/>", "warning"); <%-- 메시지 발송 폼을 찾을 수 없습니다. --%>
            }
            return;
        }

        var rcvUserInfoStr = resolveMessageReceiverInfo();
        if (!rcvUserInfoStr) {
            if (typeof UiComm !== "undefined" && UiComm.showMessage) {
                UiComm.showMessage("<spring:message code='cls.alert.message.form.notfound'/>", "warning"); <%-- 메시지 발송 폼을 찾을 수 없습니다. --%>
            }
            return;
        }

        form.action = "<%=CommConst.SYSMSG_URL_SEND%>";
        form.target = "msgWindow";
        form.elements["alarmType"].value = "S";
        form.elements["rcvUserInfoStr"].value = rcvUserInfoStr;
        window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");
        form.submit();
    }

    function resolveMessageReceiverInfo() {
        var $receiverInfo = $("#messageReceiverInfo");
        return $receiverInfo.length > 0 ? ($receiverInfo.val() || "") : "";
    }

    function resolveAlarmForm() {
        try {
            if (window.parent && window.parent !== window && window.parent.alarmForm) {
                return window.parent.alarmForm;
            }
        } catch (e) {}
        return null;
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

    function nvl(value) {
        return value === null || value === undefined || value === "" ? "-" : value;
    }

    function nvlNum(value) {
        return value === null || value === undefined || value === "" ? 0 : value;
    }

    function nvlDate(value) {
        return value === null || value === undefined || value === "" ? "-" : value;
    }

    function escapeJs(value) {
        return String(value).replace(/\\/g, "\\\\").replace(/'/g, "\\'");
    }
</script>
</body>
</html>
