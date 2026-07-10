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

    <div class="sub-box">
        <div class="board_top">
            <h3 class="board-title"><spring:message code="cls.label.student.info" /> <%-- 수강생 정보 --%></h3>
            <div class="right-area">
                <button type="button" class="btn basic" onclick="doSendMsg()"><spring:message code="cls.button.send.message" /> <%-- 메시지 보내기 --%></button>
            </div>
        </div>
        <div class="user-wrap mb10">
            <div class="user-img">
                <div class="user-photo">
                    <img id="infoPhoto" src="" alt="photo" hidden style="width:100%; height:100%; object-fit:cover;">
                </div>
            </div>
            <div class="table_list">
                <ul class="list"><li class="head"><label><spring:message code="cls.label.org" /> <%-- 기관 --%></label></li><li id="infoOrg">-</li></ul>
                <ul class="list"><li class="head"><label><spring:message code="common.name"/></label></li><li id="infoNm">-</li></ul><%--이름--%>
                <ul class="list"><li class="head"><label><spring:message code="cls.label.student.no" /> <%-- 학번 --%></label></li><li id="infoStdntNo">-</li></ul>
                <ul class="list"><li class="head"><label><spring:message code="common.id"/></label></li><li id="infoUserId">-</li></ul><%--아이디--%>
                <ul class="list"><li class="head"><label><spring:message code="cls.label.mobile.number" /> <%-- 휴대폰번호 --%></label></li><li id="infoMobile">-</li></ul>
                <ul class="list"><li class="head"><label><spring:message code="cls.label.user.email" /> <%-- 사용 이메일 --%></label></li><li id="infoEmail">-</li></ul>
            </div>
        </div>
    </div>

    <div class="board_top">
        <h3 class="board-title" id="elemSectionTitle"><spring:message code="cls.title.element.status" /> <%-- 학습요소 참여현황 --%></h3>
    </div>

    <div class="course_history">
        <div class="h_top">
            <div class="h_left">
                <strong class="tit" id="elemTypeTitle">-</strong>
            </div>
        </div>
        <div class="h_content">
            <ul class="accordion course_week" id="elemList">
                <li>
                    <div class="t_center" style="padding:20px; color:#aaa;"><spring:message code="cls.label.loading" /> <%-- 조회 중... --%></div>
                </li>
            </ul>
        </div>
    </div>

    <div class="modal_btns">
        <button type="button" class="btn type2" onclick="closePopup()"><spring:message code="button.close" /> <%-- 닫기 --%></button>
    </div>

</div>

<script type="text/javascript">
    var CTX      = "<%=request.getContextPath()%>";
    var _p       = new URLSearchParams(location.search);
    var sbjctId  = _p.get("sbjctId")  || "";
    var dvclasNo = _p.get("dvclasNo") || "";
    var userId   = _p.get("userId")   || "";
    var elemType = _p.get("elemType") || "ASMT";

    var elemTypeMap = {
        ASMT: { nm: '<spring:message code="cls.label.assignment" />', cls: "s_work"   }, <%-- 과제 --%>
        QUIZ: { nm: '<spring:message code="cls.label.quiz" />', cls: "s_test"   }, <%-- 퀴즈 --%>
        SRVY: { nm: '<spring:message code="cls.label.survey" />', cls: "s_seminar"  }, <%-- 설문 --%>
        DSCS: { nm: '<spring:message code="cls.label.discussion" />', cls: "s_debate" }  <%-- 토론 --%>
    };

    <%-- 요소 유형별 팝업 제목/기간/기록명 --%>
    var elemUiMap = {
        ASMT: { title: '<spring:message code="cls.title.assignment.submit.status" />', period: '<spring:message code="cls.label.submit.period" />', history: '<spring:message code="cls.label.submit.history" />' }, <%-- 과제 제출현황/제출기간/제출기록 --%>
        QUIZ: { title: '<spring:message code="cls.title.quiz.stare.status" />', period: '<spring:message code="cls.label.stare.period" />', history: '<spring:message code="cls.label.stare.history" />' }, <%-- 퀴즈 응시현황/응시기간/응시기록 --%>
        SRVY: { title: '<spring:message code="cls.title.survey.join.status" />', period: '<spring:message code="cls.label.survey.period" />', history: '<spring:message code="cls.label.join.history" />' }, <%-- 설문 참여현황/설문기간/참여기록 --%>
        DSCS: { title: '<spring:message code="cls.title.discussion.join.status" />', period: '<spring:message code="cls.label.join.period" />', history: '<spring:message code="cls.label.join.history" />' } <%-- 토론 참여현황/참여기간/참여기록 --%>
    };
    var quizDatetimeLabel = '<spring:message code="cls.label.stare.datetime" />'; <%-- 응시일시 --%>
    var participateDatetimeLabel = '<spring:message code="cls.label.join.datetime" />'; <%-- 참여일시 --%>
    var divisionLabel = '<spring:message code="cls.label.division" />'; <%-- 구분 --%>
    var forumPostLabel = '<spring:message code="cls.label.join.post" />'; <%-- 참여글 --%>
    var forumCommentLabel = '<spring:message code="cls.label.comment.count" />'; <%-- 댓글수 --%>

    function getElemUi() {
        return elemUiMap[elemType] || { title: "", period: '<spring:message code="cls.label.learning.period" />', history: '<spring:message code="cls.label.record" />' }; <%-- 학습기간/기록 --%>
    }

    function getEmptyHistoryText() {
        if (elemType === 'QUIZ') {
            return '<spring:message code="cls.empty.stare.history" />'; <%-- 응시 기록이 없습니다. --%>
        } else if (elemType === 'SRVY' || elemType === 'DSCS') {
            return '<spring:message code="cls.empty.join.history" />'; <%-- 참여 기록이 없습니다. --%>
        }
        return '<spring:message code="cls.empty.submit.history" />'; <%-- 제출 기록이 없습니다. --%>
    }

    function renderEmptyHistory($tbody, colCount) {
        $tbody.html('<tr><td colspan="' + colCount + '" class="t_center" style="color:var(--txt_04);">' + getEmptyHistoryText() + '</td></tr>');
    }

    $(function () {
        var info = elemTypeMap[elemType] || { nm: '<spring:message code="cls.label.learning.element" /><%-- 학습요소 --%>', cls: "s_basic" };
        $("#elemTypeTitle").text(info.nm + " " + '<spring:message code="common.label.status.join" />'); <%-- 참여현황 --%>
        $("#elemTypeTitle").text(getElemUi().title || $("#elemTypeTitle").text());
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
        ajaxCall(CTX + "/clssts/selectClsStsStdntInfo.do", { sbjctId: sbjctId, userId: userId }, function (res) {
                if (res && res.result === 1 && res.returnVO) {
                    var v = res.returnVO;
                    $("#infoOrg").text(v.orgnm || "-");
                    $("#infoNm").text(v.usernm || "-");
                    $("#infoStdntNo").text(v.stdntNo || "-");
                    $("#infoUserId").text(v.userId || "-");
                    $("#infoMobile").text(v.mobileNo || "-");
                    $("#infoEmail").text(v.email || "-");
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

    function loadElemSbmsnList() {
        ajaxCall(CTX + "/clssts/selectClsStsStdntElemSbmsnList.do", { sbjctId: sbjctId, userId: userId, elemType: elemType }, function (res) {
                renderElemList(res && res.returnList ? res.returnList : []);
            },
            function () { renderElemList([]); },
            false
        );
    }

    function renderElemList(list) {
        var $ul = $("#elemList").empty();
        var info = elemTypeMap[elemType] || { nm: '<spring:message code="cls.label.learning.element" /><%-- 학습요소 --%>', cls: "s_basic" };

        if (!list || list.length === 0) {
            $ul.html('<li><div class="t_center" style="padding:20px; color:#aaa;"><spring:message code="cls.empty.element.info" /> <%-- 학습요소 정보가 없습니다. --%></div></li>');
            return;
        }

        list.forEach(function (elem, idx) {
            var isOpen = (idx === 0);
            var liId   = "elemLi_" + idx;
            var contId = "elemCont_" + idx;
            var lrnSts = elem.lrnSts || "-";
            var scoreHtml = elem.scoreText ? '<span class="state score">' + UiComm.escapeHtml(elem.scoreText) + '</span>' : '';

            var $li = $('<li class="' + (isOpen ? 'active' : '') + '" id="' + liId + '"></li>');
            var $titleWrap = $('<div class="title-wrap"></div>');
            var $a = $('<a class="title" href="#"></a>');

            var $lbox = $(
                '<div class="lecture_box work">'
                + '<div class="lecture_tit">'
                + '<p class="labels"><label class="label ' + info.cls + '">' + UiComm.escapeHtml(info.nm) + '</label></p>'
                + '<strong>' + UiComm.escapeHtml(elem.cntntsTitle || '') + '</strong>'
                + '</div>'
                + '<p class="desc">'
                + '<span><spring:message code="cls.label.submit.period" /> <%-- 제출기간 --%><strong>' + UiComm.escapeHtml((elem.lrnStDt || '-') + (elem.lrnEndDt ? ' ~ ' + elem.lrnEndDt : '')) + '</strong></span>'
                + '</p>'
                + '<div class="btn_right">'
                + scoreHtml
                + '<label class="state">' + UiComm.escapeHtml(lrnSts) + '</label>'
                + '</div>'
                + '<i class="arrow xi-angle-' + (isOpen ? 'up' : 'down') + '"></i>'
                + '</div>'
            );
            $lbox.find(".desc span").contents().first()[0].nodeValue = getElemUi().period;

            $a.append($lbox).on("click", function (e) {
                e.preventDefault();
                toggleElem(liId, contId, $lbox.find(".arrow"));
            });
            $titleWrap.append($a);

            var $cont = $('<div class="cont" id="' + contId + '"></div>');
            if (!isOpen) { $cont.hide(); }

            var colInfo = getColInfo(elemType);
            var $tblWrap = $(
                '<div class="table-wrap">'
                + '<table class="table-type1">'
                + '<colgroup>' + colInfo.colgroup + '</colgroup>'
                + '<thead><tr><th colspan="' + colInfo.colCount + '" class="all"><spring:message code="cls.label.submit.history" /> <%-- 제출기록 --%></th></tr></thead>'
                + '<tbody id="sbmsnBody_' + idx + '"><tr><td colspan="' + colInfo.colCount + '" class="t_center" style="color:var(--txt_04);"><spring:message code="cls.label.loading" /> <%-- 조회 중... --%></td></tr></tbody>'
                + '</table></div>'
            );
            $tblWrap.find("th.all").text(getElemUi().history);
            $cont.append($tblWrap);

            if (elem.cntntsId) {
                loadSbmsnLog(elem.cntntsId, idx, colInfo.colCount);
            } else {
                renderEmptyHistory($("#sbmsnBody_" + idx), colInfo.colCount);
            }

            $li.append($titleWrap).append($cont);
            $ul.append($li);
        });
    }

    function loadSbmsnLog(cntntsId, idx, colCount) {
        ajaxCall(CTX + "/clssts/selectClsStsStdntElemSbmsnLog.do", { sbjctId: sbjctId, cntntsId: cntntsId, userId: userId, elemType: elemType }, function (res) {
                var $tbody = $("#sbmsnBody_" + idx).empty();
                var list = res && res.returnList ? res.returnList : [];

                if (list.length === 0) {
                    renderEmptyHistory($tbody, colCount);
                    return;
                }

                list.forEach(function (r, i) {
                    var row = '<tr><td class="t_center" data-th="<spring:message code="common.number.no"/>">' + (i + 1) + '</td>';<%--번호--%>

                    <%-- 퀴즈는 점수 결과가 아니라 응시 이력(일시/구분/IP)을 표시 --%>
                    if (elemType === 'QUIZ') {
                        row += '<td class="t_center" data-th="' + quizDatetimeLabel + '">' + UiComm.escapeHtml(r.sbmsnDttm || '') + '</td>'
                            + '<td class="t_center" data-th="' + divisionLabel + '">' + UiComm.escapeHtml(r.actionText || '-') + '</td>'
                            + '<td class="t_center" data-th="IP">' + UiComm.escapeHtml(r.ipAddr || '-') + '</td></tr>';
                        $tbody.append(row);
                        return;
                    }

                    if (elemType === 'ASMT') {
                        var encDownParam = r.encDownParam || "";
                        var downloadHtml = encDownParam
                            ? '<button type="button" class="btn basic small fileDownBtn" data-enc-down-param="' + UiComm.escapeHtml(encDownParam) + '"><spring:message code="button.download" /> <%-- 다운로드 --%></button>'
                            : '-';
                        row += '<td class="t_center" data-th="<spring:message code="cls.label.submit.datetime" />"><%-- 제출일시 --%>' + UiComm.escapeHtml(r.sbmsnDttm || '') + '</td>'
                            + '<td class="t_left" data-th="<spring:message code="cls.label.attachment" />"><%-- 첨부파일 --%>' + UiComm.escapeHtml(r.fileNm || '') + '</td>'
                            + '<td class="t_center" data-th="<spring:message code="common.label.list.size" />"><%-- 크기 --%>' + UiComm.escapeHtml(r.fileSzText || '') + '</td>'
                            + '<td class="t_center" data-th="<spring:message code="button.download" />"><%-- 다운로드 --%>'
                            + downloadHtml
                            + '</td>';
                    } else if (elemType === 'DSCS') {
                        row += '<td class="t_center" data-th="' + participateDatetimeLabel + '">' + UiComm.escapeHtml(r.sbmsnDttm || '') + '</td>'
                            + '<td class="t_left" data-th="<spring:message code="cls.label.content" />"><%-- 내용 --%>' + forumPostLabel + ' '
                            + UiComm.escapeHtml(String(r.postCnt || '0')) + ', ' + forumCommentLabel + ' ' + UiComm.escapeHtml(String(r.commentCnt || '0')) + '</td>';
                    } else {
                        row += '<td class="t_center" data-th="' + participateDatetimeLabel + '">' + UiComm.escapeHtml(r.sbmsnDttm || '') + '</td>'
                            + '<td class="t_left" data-th="<spring:message code="cls.label.content" />"><%-- 내용 --%>' + UiComm.escapeHtml(r.contents || '') + '</td>';
                    }

                    row += '</tr>';
                    $tbody.append(row);
                });
            },
            function () {
                renderEmptyHistory($("#sbmsnBody_" + idx), colCount);
            },
            false
        );
    }

    function getColInfo(type) {
        if (type === 'ASMT') {
            return { colCount: 5, colgroup: '<col style="width:8%"><col style="width:20%"><col style=""><col style="width:15%"><col style="width:15%">' };
        } else if (type === 'QUIZ') {
            return { colCount: 4, colgroup: '<col style="width:8%"><col style="width:32%"><col style="width:30%"><col style="width:30%">' };
        } else {
            return { colCount: 3, colgroup: '<col style="width:8%"><col style="width:32%"><col style="">' };
        }
    }

    function toggleElem(liId, contId, $arrowIcon) {
        var $li = $("#" + liId);
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

    $(document).on("click", ".fileDownBtn", function (e) {
        e.preventDefault();
        downloadFile($(this).data("encDownParam"));
    });

    function downloadFile(encDownParam) {
        if (!encDownParam) return;
        UiFileDownloader(encDownParam);
    }

    function doSendMsg() {
        if (!userId) {
            UiComm.showMessage('<spring:message code="cls.empty.student.info" />', "warning"); <%-- 학습자 정보가 없습니다. --%>
            return;
        }
        var rcvUserInfoStr = userId + ";" + ($("#infoNm").text() || "") + ";;";
        var form = window.parent && window.parent.alarmForm;
        if (!form) {
            UiComm.showMessage('<spring:message code="cls.alert.message.form.notfound" />', "warning"); <%-- 메시지 발송 폼을 찾을 수 없습니다. --%>
            return;
        }
        form.action = '<%=CommConst.SYSMSG_URL_SEND%>';
        form.target = "msgWindow";
        form.elements['alarmType'].value = "S";
        form.elements['rcvUserInfoStr'].value = rcvUserInfoStr;
        window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");
        form.submit();
    }

</script>
</body>
</html>
