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

    <!-- ② 학습요소 참여현황 헤더 -->
    <div class="board_top">
        <h3 class="board-title" id="elemSectionTitle">학습요소 참여 현황</h3>
    </div>

    <!-- ③ 학습요소 목록 (course_history 구조) -->
    <div class="course_history">
        <div class="h_top">
            <div class="h_left">
                <strong class="tit" id="elemTypeTitle">-</strong>
            </div>
        </div>
        <div class="h_content">
            <ul class="accordion course_week" id="elemList">
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
    var elemType = _p.get("elemType") || "ASMT";

    /* elemType → 한국어 명칭, label 클래스 */
    var elemTypeMap = {
        QNA:  { nm: "Q&A", cls: "s_basic"  },
        ASMT: { nm: "과제", cls: "s_work"   },
        QUIZ: { nm: "퀴즈", cls: "s_test"   },
        SRVY: { nm: "설문", cls: "s_basic"  },
        DSCC: { nm: "토론", cls: "s_debate" }
    };

    $(function () {
        var info = elemTypeMap[elemType] || { nm: "학습요소", cls: "s_basic" };
        $("#elemTypeTitle").text(info.nm + " 참여현황");
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

    /* ==========================================
       수강생 기본정보
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
       학습요소 제출 목록 조회
       ========================================== */
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

    /* ==========================================
       학습요소 목록 렌더링 (accordion course_week + lecture_box work 구조)
       ========================================== */
    function renderElemList(list) {
        var $ul   = $("#elemList").empty();
        var info  = elemTypeMap[elemType] || { nm: "학습요소", cls: "s_basic" };

        if (!list || list.length === 0) {
            $ul.html('<li><div class="t_center" style="padding:20px; color:#aaa;">학습요소 정보가 없습니다.</div></li>');
            return;
        }

        list.forEach(function (elem, idx) {
            var isOpen = (idx === 0);
            var liId   = "elemLi_"   + idx;
            var contId = "elemCont_" + idx;

            // 학습 상태 라벨 (state 클래스)
            var lrnSts = elem.lrnSts || "-";

            // 점수 (state score 클래스)
            var scoreHtml = elem.scoreText
                ? '<span class="state score">' + escHtml(elem.scoreText) + '</span>'
                : '';

            var $li = $('<li class="' + (isOpen ? 'active' : '') + '" id="' + liId + '"></li>');

            /* -- title-wrap (lecture_box work 구조) -- */
            var $titleWrap = $('<div class="title-wrap"></div>');
            var $a = $('<a class="title" href="#"></a>');

            var $lbox = $(
                '<div class="lecture_box work">'
                + '<div class="lecture_tit">'
                + '<p class="labels"><label class="label ' + info.cls + '">' + escHtml(info.nm) + '</label></p>'
                + '<strong>' + escHtml(elem.cntntsTitle || '') + '</strong>'
                + '</div>'
                + '<p class="desc">'
                + '<span>제출기간<strong>'
                + escHtml((elem.lrnStDt || '-') + (elem.lrnEndDt ? ' ~ ' + elem.lrnEndDt : ''))
                + '</strong></span>'
                + '</p>'
                + '<div class="btn_right">'
                + scoreHtml
                + '<label class="state">' + escHtml(lrnSts) + '</label>'
                + '</div>'
                + '<i class="arrow xi-angle-' + (isOpen ? 'up' : 'down') + '"></i>'
                + '</div>'
            );

            $a.append($lbox);
            $a.on("click", function (e) {
                e.preventDefault();
                toggleElem(liId, contId, $lbox.find(".arrow"));
            });
            $titleWrap.append($a);

            /* -- cont (제출기록 테이블) -- */
            var $cont = $('<div class="cont" id="' + contId + '"></div>');
            if (!isOpen) {
                $cont.hide();
            }

            var colInfo = getColInfo(elemType);
            var $tblWrap = $(
                '<div class="table-wrap">'
                + '<table class="table-type1">'
                + '<colgroup>' + colInfo.colgroup + '</colgroup>'
                + '<thead><tr><th colspan="' + colInfo.colCount + '" class="all">제출기록</th></tr></thead>'
                + '<tbody id="sbmsnBody_' + idx + '"><tr><td colspan="' + colInfo.colCount + '" class="t_center" style="color:var(--txt_04);">조회 중...</td></tr></tbody>'
                + '</table></div>'
            );
            $cont.append($tblWrap);

            if (elem.cntntsId) {
                loadSbmsnLog(elem.cntntsId, idx, colInfo.colCount);
            } else {
                $("#sbmsnBody_" + idx).html(
                    '<tr><td colspan="' + colInfo.colCount + '" class="t_center" style="color:var(--txt_04);">제출 기록이 없습니다.</td></tr>'
                );
            }

            $li.append($titleWrap).append($cont);
            $ul.append($li);
        });
    }

    /* ==========================================
       제출 기록 조회 및 렌더링
       ========================================== */
    function loadSbmsnLog(cntntsId, idx, colCount) {
        $.ajax({
            url: CTX + "/cls/selectStdntElemSbmsnLog.do",
            type: "GET", dataType: "json",
            data: { sbjctId: sbjctId, cntntsId: cntntsId, userId: userId, elemType: elemType },
            success: function (res) {
                var $tbody = $("#sbmsnBody_" + idx).empty();
                var list   = res && res.returnList ? res.returnList : [];

                if (list.length === 0) {
                    $tbody.html('<tr><td colspan="' + colCount + '" class="t_center" style="color:var(--txt_04);">제출 기록이 없습니다.</td></tr>');
                    return;
                }

                list.forEach(function (r, i) {
                    var row = '<tr><td class="t_center" data-th="번호">' + (i + 1) + '</td>';

                    if (elemType === 'ASMT') {
                        row += '<td class="t_center" data-th="제출일시">' + escHtml(r.sbmsnDttm  || '') + '</td>'
                            + '<td class="t_left"   data-th="첨부파일">' + escHtml(r.fileNm     || '') + '</td>'
                            + '<td class="t_center" data-th="크기">'     + escHtml(r.fileSzText || '') + '</td>'
                            + '<td class="t_center" data-th="다운로드">'
                            + '<button type="button" class="btn basic small" onclick="downloadFile(\'' + escJs(r.fileId) + '\')">다운로드</button>'
                            + '</td>';
                    } else if (elemType === 'QUIZ') {
                        row += '<td class="t_center" data-th="제출일시">' + escHtml(r.sbmsnDttm  || '') + '</td>'
                            + '<td class="t_center" data-th="점수">'     + escHtml(r.score      || '-') + '</td>'
                            + '<td class="t_center" data-th="결과">'     + escHtml(r.resultText || '-') + '</td>';
                    } else if (elemType === 'QNA') {
                        row += '<td class="t_center" data-th="등록일시">' + escHtml(r.sbmsnDttm || '') + '</td>'
                            + '<td class="t_left"   data-th="제목">'     + escHtml(r.title     || '') + '</td>';
                    } else {
                        row += '<td class="t_center" data-th="제출일시">' + escHtml(r.sbmsnDttm || '') + '</td>'
                            + '<td class="t_left"   data-th="내용">'     + escHtml(r.contents  || '') + '</td>';
                    }

                    row += '</tr>';
                    $tbody.append(row);
                });
            },
            error: function () {
                $("#sbmsnBody_" + idx).html(
                    '<tr><td colspan="' + colCount + '" class="t_center" style="color:var(--txt_04);">제출 기록이 없습니다.</td></tr>'
                );
            }
        });
    }

    /* ==========================================
       elemType별 colgroup / colCount 정의
       ========================================== */
    function getColInfo(type) {
        if (type === 'ASMT') {
            return {
                colCount: 5,
                colgroup: '<col style="width:8%"><col style="width:20%"><col style=""><col style="width:15%"><col style="width:15%">'
            };
        } else if (type === 'QUIZ') {
            return {
                colCount: 4,
                colgroup: '<col style="width:8%"><col style="width:32%"><col style="width:30%"><col style="width:30%">'
            };
        } else if (type === 'QNA') {
            return {
                colCount: 3,
                colgroup: '<col style="width:8%"><col style="width:32%"><col style="">'
            };
        } else {
            return {
                colCount: 3,
                colgroup: '<col style="width:8%"><col style="width:32%"><col style="">'
            };
        }
    }

    function toggleElem(liId, contId, $arrowIcon) {
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

    function downloadFile(fileId) {
        if (!fileId) return;
        location.href = CTX + "/common/fileDown.do?fileId=" + encodeURIComponent(fileId);
    }

    /* ==========================================
       메시지 보내기
       ========================================== */
    function doSendMsg() {
        if (!userId) {
            UiComm.showMessage("학습자 정보가 없습니다.", "warning");
            return;
        }
        var rcvUserInfoStr = userId + ";" + ($("#infoNm").text() || "") + ";;";
        var form = window.parent && window.parent.alarmForm;
        if (!form) {
            UiComm.showMessage("메시지 발송 폼을 찾을 수 없습니다.", "warning");
            return;
        }
        form.action = '<%=CommConst.SYSMSG_URL_SEND%>';
        form.target = "msgWindow";
        form.elements['alarmType'].value = "S";
        form.elements['rcvUserInfoStr'].value = rcvUserInfoStr;
        window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");
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