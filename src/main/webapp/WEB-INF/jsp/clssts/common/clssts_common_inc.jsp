<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>

<%--
    clssts/clssts_detail.jsp와 clssts/clssts_class_detail.jsp에서
    주차별 수업현황/학습요소 참여현황 본문과 스크립트를 공통으로 사용한다.
--%>
<c:if test="${empty clsTabId}">
    <c:set var="clsTabId" value="clsTab"/>
</c:if>
<c:if test="${empty clsListViewUrl}">
    <c:set var="clsListViewUrl" value=""/>
</c:if>

<c:choose>
    <c:when test="${clsShowStudentYearColumns}">
        <c:set var="stdntBodyColspan" value="${wkCnt + 9}"/>
    </c:when>
    <c:otherwise>
        <c:set var="stdntBodyColspan" value="${wkCnt + 7}"/>
    </c:otherwise>
</c:choose>

<div id="tabWeekly" class="tab-content">
    <div class="board_top">
        <h4 class="sub-title"><spring:message code="cls.label.weekly.notlearned.ratio"/><%-- 주차별 미학습자 비율 --%></h4>
    </div>

    <div class="table-wrap">
        <table class="table-type1">
            <colgroup>
                <col style="width:7%">
                <c:forEach begin="1" end="${wkCnt}">
                    <col>
                </c:forEach>
                <col style="width:7%">
            </colgroup>
            <thead>
            <tr>
                <th><spring:message code="common.type"/></th><%-- 구분 --%>
                <c:forEach begin="1" end="${wkCnt}" var="w">
                    <th>${w}</th>
                </c:forEach>
                <th><spring:message code="cls.label.average"/><%-- 평균 --%></th>
            </tr>
            </thead>
            <tbody id="wklyBody">
            <tr>
                <td colspan="${wkCnt + 2}" class="t_center">
                    <spring:message code="cls.empty.weekly.data"/><%-- 주차 정보가 없습니다. --%>
                </td>
            </tr>
            </tbody>
        </table>
    </div>

    <div class="board_top" style="margin-top:16px;">
        <h4 class="sub-title">
            <spring:message code="cls.title.student.learning.status"/><%-- 학습자 학습현황 --%>
            <span class="total_num"><spring:message code="common.page.total"/><%-- 총 --%> <strong id="stdntTotalCnt">0</strong><spring:message code="cls.label.people"/><%-- 명 --%></span>
        </h4>

        <div class="state-txt-label">
            <p><span class="state_ok" aria-label='<spring:message code="cls.label.attendance"/><%-- 출석 --%>'>○</span> <spring:message code="cls.label.attendance"/><%-- 출석 --%></p>
            <p><span class="state_late" aria-label='<spring:message code="cls.label.late"/><%-- 지각 --%>'>△</span> <spring:message code="cls.label.late"/><%-- 지각 --%></p>
            <p><span class="state_no" aria-label='<spring:message code="cls.label.absence"/><%-- 결석 --%>'>X</span> <spring:message code="cls.label.absence"/><%-- 결석 --%></p>
        </div>

        <div class="right-area">
            <select class="form-select" id="absnWknoFrom" title="<spring:message code='cls.label.absent.week.from'/><%-- 결석주차 시작 --%>">
                <option value="0"><spring:message code="cls.label.absent.week"/><%-- 결석주차 --%></option>
                <c:forEach begin="1" end="${wkCnt}" var="w">
                    <option value="${w}">${w}<spring:message code="common.week"/><%-- 주차 --%></option>
                </c:forEach>
            </select>
            <span class="txt-sort">~</span>
            <select class="form-select" id="absnWknoTo" title="<spring:message code='cls.label.absent.week.to'/><%-- 결석주차 종료 --%>">
                <option value="0"><spring:message code="cls.label.absent.week"/><%-- 결석주차 --%></option>
                <c:forEach begin="1" end="${wkCnt}" var="w">
                    <option value="${w}">${w}<spring:message code="common.week"/><%-- 주차 --%></option>
                </c:forEach>
            </select>

            <div class="search-typeC">
                <input class="form-control"
                       type="text"
                       id="srchKeyword2"
                       placeholder="<spring:message code='cls.placeholder.student.search'/>"><%-- 이름/학번/학과 입력 --%>
                <button type="button"
                        class="btn basic icon search"
                        onclick="searchStdntList(1)">
                    <i class="icon-svg-search"></i>
                </button>
            </div>

            <button type="button" class="btn basic" onclick="openSendMsg()">
                <spring:message code="cls.button.send.message"/><%-- 메시지 보내기 --%>
            </button>

            <button type="button" class="btn type2" onclick="downloadExcel()">
                <spring:message code="button.download.excel"/><%-- 엑셀 다운로드 --%>
            </button>
        </div>
    </div>

    <div class="table-wrap">
        <table class="table-type2">
            <c:choose>
                <c:when test="${clsShowStudentYearColumns}">
                    <colgroup>
                        <col style="width:3%">
                        <col style="width:3%">
                        <col style="width:8%">
                        <col style="width:9%">
                        <col style="width:8%">
                        <col style="width:8%">
                        <col style="width:5%">
                        <col style="width:5%">
                        <c:forEach begin="1" end="${wkCnt}">
                            <col>
                        </c:forEach>
                        <col style="width:9%">
                    </colgroup>
                    <thead>
                    <tr>
                        <th>
                            <span class="custom-input onlychk">
                                <input type="checkbox" id="chkStdntAll">
                                <label for="chkStdntAll"></label>
                            </span>
                        </th>
                        <th><spring:message code="common.number.no"/><%-- 번호 --%></th>
                        <th><spring:message code="common.dept_name"/><%-- 학과 --%></th>
                        <th><spring:message code="cls.label.representative.id"/><%-- 대표아이디 --%></th>
                        <th><spring:message code="cls.label.student.no"/><%-- 학번 --%></th>
                        <th><spring:message code="common.name"/><%-- 이름 --%></th>
                        <th><spring:message code="cls.label.student.year"/><%-- 입학년도 --%></th>
                        <th><spring:message code="cls.label.school.year"/><%-- 학년 --%></th>
                        <c:forEach begin="1" end="${wkCnt}" var="w">
                            <th>${w}</th>
                        </c:forEach>
                        <th><spring:message code="cls.label.attendance.status"/><%-- 출석/지각/결석 --%></th>
                    </tr>
                    </thead>
                </c:when>
                <c:otherwise>
                    <colgroup>
                        <col style="width:3%">
                        <col style="width:4%">
                        <col style="width:9%">
                        <col style="width:10%">
                        <col style="width:9%">
                        <col style="width:9%">
                        <c:forEach begin="1" end="${wkCnt}">
                            <col>
                        </c:forEach>
                        <col style="width:10%">
                    </colgroup>
                    <thead>
                    <tr>
                        <th>
                            <span class="custom-input onlychk">
                                <input type="checkbox" id="chkStdntAll">
                                <label for="chkStdntAll"></label>
                            </span>
                        </th>
                        <th><spring:message code="common.number.no"/><%-- 번호 --%></th>
                        <th><spring:message code="common.dept_name"/><%-- 학과 --%></th>
                        <th><spring:message code="cls.label.representative.id"/><%-- 대표아이디 --%></th>
                        <th><spring:message code="cls.label.student.no"/><%-- 학번 --%></th>
                        <th><spring:message code="common.name"/><%-- 이름 --%></th>
                        <c:forEach begin="1" end="${wkCnt}" var="w">
                            <th>${w}</th>
                        </c:forEach>
                        <th><spring:message code="cls.label.attendance.status"/><%-- 출석/지각/결석 --%></th>
                    </tr>
                    </thead>
                </c:otherwise>
            </c:choose>
            <tbody id="stdntBody">
            <tr>
                <td colspan="${stdntBodyColspan}" class="t_center">
                    <spring:message code="cls.empty.student.info"/><%-- 학습자 정보가 없습니다. --%>
                </td>
            </tr>
            </tbody>
        </table>
    </div>

    <div class="board_foot">
        <div class="page_info">
            <span class="total_page"><spring:message code="common.all"/><%-- 전체 --%> <b id="stdntTotalCnt2">0</b><spring:message code="common.page.total_count"/><%-- 건 --%></span>
            <span class="current_page">
                <spring:message code="common.paging.cur_page"/><%-- 현재 페이지 --%>
                <strong id="stdntCurPage">1</strong>/<span id="stdntTotalPage">1</span>
            </span>
        </div>
        <div class="board_pager">
            <span class="inner">
                <button class="page" type="button"
                        title="<spring:message code='common.paging.first_page'/>"<%-- 처음 페이지 --%>
                        aria-label="<spring:message code='common.paging.first_page'/>"<%-- 처음 페이지 --%>
                        onclick="searchStdntList(1)">
                    <i class="icon-page-first"></i>
                </button>
                <button class="page" type="button"
                        title="<spring:message code='common.paging.prev_page'/>"<%-- 이전 페이지 --%>
                        aria-label="<spring:message code='common.paging.prev_page'/>"<%-- 이전 페이지 --%>
                        onclick="moveStdntPage('prev')">
                    <i class="icon-page-prev"></i>
                </button>
                <span class="pages" id="stdntPagerPages"></span>
                <button class="page" type="button"
                        title="<spring:message code='common.paging.next_page'/>"<%-- 다음 페이지 --%>
                        aria-label="<spring:message code='common.paging.next_page'/>"<%-- 다음 페이지 --%>
                        onclick="moveStdntPage('next')">
                    <i class="icon-page-next"></i>
                </button>
                <button class="page" type="button"
                        title="<spring:message code='common.paging.last_page'/>"<%-- 마지막 페이지 --%>
                        aria-label="<spring:message code='common.paging.last_page'/>"<%-- 마지막 페이지 --%>
                        onclick="searchStdntList(stdntTotalPageCount)">
                    <i class="icon-page-last"></i>
                </button>
            </span>
        </div>
    </div>

    <div style="height:120px;"></div>
</div>

<div id="tabElement" class="tab-content" style="display:none;">
    <div class="board_top" style="margin-top:16px;">
        <h4 class="sub-title">
            <spring:message code="cls.title.element.status"/><%-- 학습요소 참여현황 --%>
            <span class="total_num"><spring:message code="common.page.total"/><%-- 총 --%> <strong id="elemStdntTotalCnt">0</strong><spring:message code="cls.label.people"/><%-- 명 --%></span>
        </h4>

        <div class="right-area">
            <div class="search-typeC">
                <input class="form-control"
                       type="text"
                       id="elemStdntKeyword"
                       placeholder="<spring:message code='cls.placeholder.student.search'/>"><%-- 이름/학번/학과 입력 --%>
                <button type="button"
                        class="btn basic icon search"
                        onclick="searchElemStdntList(1)">
                    <i class="icon-svg-search"></i>
                </button>
            </div>

            <button type="button" class="btn basic" onclick="openElemSendMsg()">
                <spring:message code="cls.button.send.message"/><%-- 메시지 보내기 --%>
            </button>

            <button type="button" class="btn type2" onclick="downloadElemStdntExcel()">
                <spring:message code="button.download.excel"/><%-- 엑셀 다운로드 --%>
            </button>
        </div>
    </div>

    <div class="table-wrap">
        <table class="table-type2">
            <colgroup>
                <col style="width:3%">
                <col style="width:4%">
                <col style="width:10%">
                <col style="width:10%">
                <col style="width:10%">
                <col style="width:9%">
                <col style="width:7%">
                <col style="width:8%">
                <col style="width:8%">
                <col style="width:8%">
                <col style="width:8%">
                <col style="width:7%">
                <col style="width:7%">
                <col style="width:7%">
            </colgroup>
            <thead>
            <tr>
                <th>
                    <span class="custom-input onlychk">
                        <input type="checkbox" id="chkElemAll">
                        <label for="chkElemAll"></label>
                    </span>
                </th>
                <th><spring:message code="common.number.no"/><%-- 번호 --%></th>
                <th><spring:message code="common.dept_name"/><%-- 학과 --%></th>
                <th><spring:message code="cls.label.representative.id"/><%-- 대표아이디 --%></th>
                <th><spring:message code="cls.label.student.no"/><%-- 학번 --%></th>
                <th><spring:message code="common.name"/><%-- 이름 --%></th>
                <th><spring:message code="cls.label.qna"/><%-- Q&A --%><br/><span class="fs-sm">(<spring:message code="cls.label.reply"/><%-- 답변 --%>/<spring:message code="cls.label.register"/><%-- 등록 --%>)</span></th>
                <th><spring:message code="cls.label.discussion.board"/><%-- 토론방 --%><br/><span class="fs-sm">(<spring:message code="cls.label.comment.count"/><%-- 댓글수 --%>)</span></th>
                <th><spring:message code="cls.label.assignment"/><%-- 과제 --%><br/><span class="fs-sm">(<spring:message code="cls.label.submit"/><%-- 제출 --%>/<spring:message code="common.all"/><%-- 전체 --%>)</span></th>
                <th><spring:message code="cls.label.quiz"/><%-- 퀴즈 --%><br/><span class="fs-sm">(<spring:message code="cls.label.stare"/><%-- 응시 --%>/<spring:message code="common.all"/><%-- 전체 --%>)</span></th>
                <th><spring:message code="cls.label.survey"/><%-- 설문 --%><br/><span class="fs-sm">(<spring:message code="common.label.join"/><%-- 참여 --%>/<spring:message code="common.all"/><%-- 전체 --%>)</span></th>
                <th><spring:message code="cls.label.discussion"/><%-- 토론 --%><br/><span class="fs-sm">(<spring:message code="common.label.join"/><%-- 참여 --%>/<spring:message code="common.all"/><%-- 전체 --%>)</span></th>
                <th><spring:message code="cls.label.midterm"/><%-- 중간고사 --%></th>
                <th><spring:message code="cls.label.finalterm"/><%-- 기말고사 --%></th>
            </tr>
            </thead>
            <tbody id="elemStdntBody">
            <tr>
                <td colspan="14" class="t_center">
                    <spring:message code="cls.empty.element.info"/><%-- 학습요소 정보가 없습니다. --%>
                </td>
            </tr>
            </tbody>
        </table>
    </div>

    <div class="board_foot">
        <div class="page_info">
            <span class="total_page"><spring:message code="common.all"/><%-- 전체 --%> <b id="elemStdntTotalCnt2">0</b><spring:message code="cls.label.people"/><%-- 명 --%></span>
            <span class="current_page">
                <spring:message code="common.paging.cur_page"/><%-- 현재 페이지 --%>
                <strong id="elemStdntCurPage">1</strong>/<span id="elemStdntTotalPage">1</span>
            </span>
        </div>
        <div class="board_pager">
            <span class="inner">
                <button class="page"
                        type="button"
                        title="<spring:message code='common.paging.first_page'/>"<%-- 처음 페이지 --%>
                        aria-label="<spring:message code='common.paging.first_page'/>"<%-- 처음 페이지 --%>
                        onclick="searchElemStdntList(1)">
                    <i class="icon-page-first"></i>
                </button>
                <button class="page"
                        type="button"
                        title="<spring:message code='common.paging.prev_page'/>"<%-- 이전 페이지 --%>
                        aria-label="<spring:message code='common.paging.prev_page'/>"<%-- 이전 페이지 --%>
                        onclick="moveElemPage('prev')">
                    <i class="icon-page-prev"></i>
                </button>
                <span class="pages" id="elemPagerPages"></span>
                <button class="page"
                        type="button"
                        title="<spring:message code='common.paging.next_page'/>"<%-- 다음 페이지 --%>
                        aria-label="<spring:message code='common.paging.next_page'/>"<%-- 다음 페이지 --%>
                        onclick="moveElemPage('next')">
                    <i class="icon-page-next"></i>
                </button>
                <button class="page"
                        type="button"
                        title="<spring:message code='common.paging.last_page'/>"<%-- 마지막 페이지 --%>
                        aria-label="<spring:message code='common.paging.last_page'/>"<%-- 마지막 페이지 --%>
                        onclick="searchElemStdntList(elemStdntTotalPageCount)">
                    <i class="icon-page-last"></i>
                </button>
            </span>
        </div>
    </div>

    <div style="height:120px;"></div>
</div>

<form name="alarmForm" method="POST" target="msgWindow">
    <input type="hidden" name="alarmType" value="S"/>
    <input type="hidden" name="sysCd" value="LMS"/>
    <input type="hidden" name="orgId" value="${orgId}"/>
    <input type="hidden" name="bussGbn" value="LMS"/>
    <input type="hidden" name="smsSndType" value="P"/>
    <input type="hidden" name="rcvUserInfoStr" value=""/>
</form>

<script>
    var CTX = "<%=request.getContextPath()%>";
    var EPARAM = '<c:out value="${encParams}" />';
    var sbjctId = "${sbjctId}";
    var dvclasNo = "${dvclasNo}";
    var initTab = "${initTab}";
    var MAX_WK = Number("${wkCnt}");

    var clsTabSelector = "#${clsTabId}";
    var clsShowStudentYearColumns = ${clsShowStudentYearColumns};
    var clsListViewUrl = '<c:out value="${clsListViewUrl}"/>';
    var clsWklyStatsUrl = '<c:out value="${clsWklyStatsUrl}"/>';
    var clsNotLrnnPopupUrl = '<c:out value="${clsNotLrnnPopupUrl}"/>';
    var clsStdntListUrl = '<c:out value="${clsStdntListUrl}"/>';
    var clsStdntPopupUrl = '<c:out value="${clsStdntPopupUrl}"/>';
    var clsStdntWkDetailPopupUrl = '<c:out value="${clsStdntWkDetailPopupUrl}"/>';
    var clsStdntExcelUrl = '<c:out value="${clsStdntExcelUrl}"/>';
    var clsElemStatsUrl = '<c:out value="${clsElemStatsUrl}"/>';
    var clsElemPopupUrl = '<c:out value="${clsElemPopupUrl}"/>';
    var clsElemExcelUrl = '<c:out value="${clsElemExcelUrl}"/>';

    var stdntCurrentPageNo = 1;
    var stdntTotalPageCount = 1;
    var elemStdntCurrentPageNo = 1;
    var elemStdntTotalPageCount = 1;
    var lastStdntUsers = [];
    var lastElemUsers = [];

    function normalizeDialogCloseButton() {
        setTimeout(function () {
            $(".ui-dialog:visible").last().find(".ui-dialog-titlebar-close")
                .removeAttr("title")
                .attr("aria-label", '<spring:message code="button.close"/><%-- 닫기 --%>');
        }, 100);
    }

    $(function () {
        $(clsTabSelector + " a").on("click", function (e) {
            e.preventDefault();
            $(clsTabSelector + " a").removeClass("current");
            $(this).addClass("current");

            var target = $(this).attr("href");
            $(".tab-content").hide();
            $(target).show();

            var tabKey = $(this).data("tab");
            var $crumbTitle = $("#crumbTitle");
            if ($crumbTitle.length) {
                $crumbTitle.text(tabKey === "element"
                    ? "<spring:message code='cls.title.element.status'/><%-- 학습요소 참여현황 --%>"
                    : "<spring:message code='cls.title.weekly'/><%-- 주차별 수업현황 --%>");
            }

            if (tabKey === "weekly") {
                loadWklyStats();
                searchStdntList(1);
            } else {
                searchElemStdntList(1);
            }
        });

        $("#chkStdntAll").on("change", function () {
            $("#stdntBody input[type=checkbox]").prop("checked", $(this).is(":checked"));
        });

        $("#chkElemAll").on("change", function () {
            $("#elemStdntBody input[type=checkbox]").prop("checked", $(this).is(":checked"));
        });

        $("#srchKeyword2").on("keydown", function (e) {
            if (e.keyCode === 13) {
                e.preventDefault();
                searchStdntList(1);
            }
        });

        $("#elemStdntKeyword").on("keydown", function (e) {
            if (e.keyCode === 13) {
                e.preventDefault();
                searchElemStdntList(1);
            }
        });

        if (initTab === "element") {
            $(clsTabSelector + ' a[href="#tabElement"]').trigger("click");
        } else {
            $(clsTabSelector + ' a[href="#tabWeekly"]').trigger("click");
        }
    });

    function loadWklyStats() {
        var extData = {
            sbjctId: sbjctId
        };

        var param = {
            encParams: EPARAM,
            addParams: UiComm.makeEncParams(extData)
        };

        ajaxCall(CTX + clsWklyStatsUrl, param, function (res) {
                if (res && res.encParams) {
                    EPARAM = res.encParams;
                }

                var $body = $("#wklyBody").empty();

                if (!res || res.result !== 1 || !res.returnList || res.returnList.length === 0) {
                    $body.append(
                        '<tr><td colspan="' + (MAX_WK + 2) + '" class="t_center">'
                        + '<spring:message code="common.no.data.result"/><%-- 조회된 데이터가 없습니다 --%>'
                        + '</td></tr>'
                    );
                    return;
                }

                var rates = new Array(MAX_WK).fill(null);
                res.returnList.forEach(function (r) {
                    var wk = parseInt(r.wkNo, 10);
                    if (wk >= 1 && wk <= MAX_WK) {
                        rates[wk - 1] = (r.notLrnnRt == null ? null : Number(r.notLrnnRt));
                    }
                });

                var sumNotLrnnCnt = 0;
                var sumTotalCnt = 0;

                res.returnList.forEach(function (r) {
                    sumNotLrnnCnt += Number(r.notLrnnCnt || 0);
                    sumTotalCnt += Number(r.totalCnt || 0);
                });

                var avg = sumTotalCnt > 0 ? (sumNotLrnnCnt / sumTotalCnt * 100) : null;
                var tr = '<tr><td class="t_center" data-th="<spring:message code="common.type"/>"><spring:message code="cls.label.ratio"/></td>'; <%-- 구분/비율 --%>

                for (var i = 0; i < MAX_WK; i++) {
                    if (typeof rates[i] === "number") {
                        tr += '<td class="t_center" data-th="' + (i + 1) + '<spring:message code="common.week"/><%-- 주차 --%>">'
                            + '<a href="#_" class="link" onclick="openNotLrnnList(' + (i + 1) + ');return false;">'
                            + rates[i].toFixed(2) + '</a></td>';
                    } else {
                        tr += '<td class="t_center">-</td>';
                    }
                }

                tr += '<td class="t_center" data-th="<spring:message code="cls.label.average"/>">' <%-- 평균 --%>
                    + (avg == null ? '-' : avg.toFixed(2))
                    + '</td></tr>';

                $body.append(tr);
            },
            function () {
                $("#wklyBody").html(
                    '<tr><td colspan="' + (MAX_WK + 2) + '" class="t_center">'
                    + '<spring:message code="fail.common.msg"/><%-- 에러가 발생하였습니다 --%>'
                    + '</td></tr>'
                );
            },
            false
        );
    }

    function openNotLrnnList(wkNo) {
        UiDialog("notLrnnPop", {
            title: wkNo + '<spring:message code="common.week"/><%-- 주차 --%> ' + '<spring:message code="cls.title.notlearned.status"/><%-- 미학습자 현황 --%>',
            width: 1100,
            height: 800,
            url: CTX + clsNotLrnnPopupUrl + "?sbjctId=" + encodeURIComponent(sbjctId)
                + "&dvclasNo=" + encodeURIComponent(dvclasNo)
                + "&wkNo=" + wkNo
                + "&encParams=" + encodeURIComponent(EPARAM)
        });
        normalizeDialogCloseButton();
    }

    function goClsList() {
        if (!clsListViewUrl) {
            return;
        }
        location.href = CTX + clsListViewUrl + "?encParams=" + encodeURIComponent(EPARAM);
    }

    function searchStdntList(page) {
        stdntCurrentPageNo = page;

        var extData = {
            sbjctId: sbjctId,
            searchValue: $("#srchKeyword2").val(),
            absnWknoFrom: parseInt($("#absnWknoFrom").val(), 10) || 0,
            absnWknoTo: parseInt($("#absnWknoTo").val(), 10) || 0,
            pageIndex: page
        };

        var param = {
            encParams: EPARAM,
            addParams: UiComm.makeEncParams(extData)
        };

        ajaxCall(CTX + clsStdntListUrl, param, function (res) {
                if (res && res.encParams) {
                    EPARAM = res.encParams;
                }
                var $body = $("#stdntBody").empty();
                var cnt = res && res.pageInfo ? res.pageInfo.totalRecordCount : 0;
                stdntTotalPageCount = res && res.pageInfo ? res.pageInfo.totalPageCount : 1;

                $("#stdntTotalCnt").text(cnt);
                $("#stdntTotalCnt2").text(cnt);
                $("#stdntCurPage").text(page);
                $("#stdntTotalPage").text(stdntTotalPageCount);
                renderStdntPager(page, stdntTotalPageCount);

                if (!res || res.result !== 1 || !res.returnList || res.returnList.length === 0) {
                    lastStdntUsers = [];
                    $body.append(
                        '<tr><td colspan="' + ${stdntBodyColspan} + '" class="t_center">'
                        + '<spring:message code="common.no.data.result"/><%-- 조회된 데이터가 없습니다 --%>'
                        + '</td></tr>'
                    );
                    return;
                }

                var list = res.returnList || [];
                var perPage = (res.pageInfo && res.pageInfo.recordCountPerPage) ? res.pageInfo.recordCountPerPage : 20;

                lastStdntUsers = list.map(function (x) {
                    return {
                        userId: x.userId || "",
                        usernm: x.usernm || "",
                        mobileNo: x.mobileNo || "",
                        email: x.email || ""
                    };
                }).filter(function (x) {
                    return !!x.userId;
                });

                function sts(v) {
                    if (v === "ATND") {
                        <%-- 출석 --%>
                        return '<span class="state_ok" aria-label="<spring:message code="cls.label.attendance"/>">○</span>';
                    }
                    if (v === "LATE") {
                        <%-- 지각 --%>
                        return '<span class="state_late" aria-label="<spring:message code="cls.label.late"/>">△</span>';
                    }
                    if (v === "ABSNT") {
                        <%-- 결석 --%>
                        return '<span class="state_no" aria-label="<spring:message code="cls.label.absence"/>">X</span>';
                    }
                    if (v === "NOTSTARTED" || v === "STUDY") {
                        <%-- 미학습 --%>
                        return '<span class="state_none" aria-label="<spring:message code="cls.label.study.notlearned"/>">-</span>';
                    }
                    return "-";
                }

                function wkCell(uid, wkNo, v) {
                    return '<td class="t_center" data-th="' + wkNo + '<spring:message code="common.week"/><%-- 주차 --%>">'
                        + '<a href="#_" class="wkCell" data-user-id="' + UiComm.escapeHtml(uid) + '" data-wk-no="' + wkNo + '">'
                        + sts(v)
                        + '</a></td>';
                }

                list.forEach(function (item, idx) {
                    var no = ((stdntCurrentPageNo - 1) * perPage) + idx + 1;
                    var uid = String(item.userId || "");
                    var uidHtml = UiComm.escapeHtml(uid);
                    var chkId = "chkStdnt_" + idx;

                    var wkMap = {};
                    (item.wkStsList || []).forEach(function (x) {
                        wkMap[x.wkNo] = x.atndSts;
                    });

                    var row = '<tr>'
                        + '<td class="t_center"><span class="custom-input onlychk">'
                        + '<input type="checkbox" id="' + chkId + '"'
                        + ' data-user-id="' + uidHtml + '"'
                        + ' data-user-nm="' + UiComm.escapeHtml(item.usernm || "") + '"'
                        + ' data-mobile="' + UiComm.escapeHtml(item.mobileNo || "") + '"'
                        + ' data-email="' + UiComm.escapeHtml(item.email || "") + '"'
                        + '><label for="' + chkId + '"></label></span></td>'
                        + '<td class="t_center" data-th="<spring:message code="common.number.no"/>">' + no + '</td>' <%-- 번호 --%>
                        + '<td class="t_center" data-th="' + '<spring:message code="common.dept_name"/>' + '">' + UiComm.escapeHtml(item.deptnm || '-') + '</td>' <%-- 학과 --%>
                        + '<td class="t_center" data-th="' + '<spring:message code="cls.label.representative.id"/>' + '">' + UiComm.escapeHtml(String(item.userId || '-')) + '</td>' <%-- 대표아이디 --%>
                        + '<td class="t_center" data-th="' + '<spring:message code="cls.label.student.no"/>' + '">' + UiComm.escapeHtml(String(item.stdntNo || '-')) + '</td>' <%-- 학번 --%>
                        + '<td class="t_center" data-th="' + '<spring:message code="common.name"/>' + '"><a href="#_" class="link stdntName" data-user-id="' + uidHtml + '">' + UiComm.escapeHtml(item.usernm || '-') + '</a></td>'; <%-- 이름 --%>

<c:if test="${clsShowStudentYearColumns}">
                    row += '<td class="t_center" data-th="' + '<spring:message code="cls.label.student.year"/>' + '">' + UiComm.escapeHtml(String(item.entyR || '-')) + '</td>' <%-- 입학년도 --%>
                        + '<td class="t_center" data-th="' + '<spring:message code="cls.label.school.year"/>' + '">' + UiComm.escapeHtml(String(item.scyr || '-')) + '</td>'; <%-- 학년 --%>
</c:if>

                    for (var w = 1; w <= MAX_WK; w++) {
                        row += wkCell(uid, w, wkMap[w]);
                    }

                    row += '<td class="t_center" data-th="' + '<spring:message code="cls.label.attendance.status"/>' + '">' <%-- 출석/지각/결석 --%>
                        + '<span class="state_ok total_label" aria-label="' + '<spring:message code="cls.label.attendance"/>' + '">' + (item.atndCnt || 0) + '</span>' <%-- 출석 --%>
                        + '<span class="state_late total_label" aria-label="' + '<spring:message code="cls.label.late"/>' + '">' + (item.lateCnt || 0) + '</span>' <%-- 지각 --%>
                        + '<span class="state_no total_label" aria-label="' + '<spring:message code="cls.label.absence"/>' + '">' + (item.absnCnt || 0) + '</span>' <%-- 결석 --%>
                        + '</td></tr>';

                    $body.append(row);
                });
            },
            null,
            false
        );
    }

    function renderStdntPager(cur, total) {
        var html = '';
        var pageSize = 5;
        var startPage = Math.floor((cur - 1) / pageSize) * pageSize + 1;
        var endPage = Math.min(startPage + pageSize - 1, total);

        for (var p = startPage; p <= endPage; p++) {
            html += '<button class="page' + (p === cur ? ' active' : '') + '" type="button"'
                + ' onclick="searchStdntList(' + p + ')">' + p + '</button>';
        }

        $("#stdntPagerPages").html(html);
    }

    function moveStdntPage(direction) {
        if (direction === "prev" && stdntCurrentPageNo > 1) {
            searchStdntList(stdntCurrentPageNo - 1);
        } else if (direction === "next" && stdntCurrentPageNo < stdntTotalPageCount) {
            searchStdntList(stdntCurrentPageNo + 1);
        }
    }

    $(document).on("click", ".stdntName", function (e) {
        e.preventDefault();

        var userId = $(this).data("userId");
        if (!userId) {
            UiComm.showMessage('<spring:message code="cls.alert.invalid.student.info"/><%-- 선택한 학습자 정보를 불러올 수 없습니다. --%>', "warning");
            return;
        }

        UiDialog("stdntLrnPop", {
            title: "<spring:message code='cls.title.student.learning.status'/><%-- 학습자 학습현황 --%>",
            width: 1140,
            height: 820,
            url: CTX + clsStdntPopupUrl + "?sbjctId=" + encodeURIComponent(sbjctId)
                + "&dvclasNo=" + encodeURIComponent(dvclasNo)
                + "&userId=" + encodeURIComponent(userId)
                + "&userIds=" + encodeURIComponent(lastStdntUsers.map(function (x) {
                    return x.userId;
                }).filter(function (id) {
                    return !!id;
                }).join(","))
                + "&wkNo=1"
                + "&encParams=" + encodeURIComponent(EPARAM)
        });
        normalizeDialogCloseButton();
    });

    $(document).on("click", ".wkCell", function (e) {
        e.preventDefault();

        var userId = $(this).data("userId");
        var wkNo = $(this).data("wkNo");

        if (!userId) {
            UiComm.showMessage('<spring:message code="cls.alert.invalid.student.info"/><%-- 선택한 학습자 정보를 불러올 수 없습니다. --%>', "warning");
            return;
        }

        UiDialog("stdntWeekLrnPop_" + userId + "_" + wkNo, {
            title: "<spring:message code='cls.title.student.weekly'/>", <%-- 학습자 주차별 학습현황 --%>
            width: 1140,
            height: 820,
            url: CTX + clsStdntWkDetailPopupUrl + "?sbjctId=" + encodeURIComponent(sbjctId)
                + "&dvclasNo=" + encodeURIComponent(dvclasNo)
                + "&userId=" + encodeURIComponent(userId)
                + "&wkNo=" + wkNo
                + "&encParams=" + encodeURIComponent(EPARAM)
        });
        normalizeDialogCloseButton();
    });

    function openSendMsg() {
        var checkedUsers = [];

        $("#stdntBody input[type=checkbox]:checked").each(function () {
            var userId = $(this).data("userId");
            if (!userId) {
                return;
            }

            checkedUsers.push({
                userId: userId,
                usernm: $(this).data("userNm") || "",
                mobileNo: $(this).data("mobile") || "",
                email: $(this).data("email") || ""
            });
        });

        var targets = checkedUsers.length > 0 ? checkedUsers : lastStdntUsers;
        if (!targets || targets.length === 0) {
            UiComm.showMessage("<spring:message code='cls.alert.no.user'/>", "warning");<%-- 선택된 학습자가 없습니다 --%>
            return;
        }

        var rcvUserInfoStr = targets.map(function (u) {
            return [u.userId, u.usernm, u.mobileNo, u.email].join(";");
        }).join("|");

        var form = document.alarmForm;
        if (!form) {
            UiComm.showMessage('<spring:message code="cls.alert.message.form.notfound"/><%-- 메시지 발송 폼을 찾을 수 없습니다. --%>', "warning");
            return;
        }

        form.action = '<%=CommConst.SYSMSG_URL_SEND%>';
        form.target = "msgWindow";
        form.elements["alarmType"].value = "S";
        form.elements["rcvUserInfoStr"].value = rcvUserInfoStr;
        window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");
        form.submit();
    }

    function downloadExcel() {
        var colModel = [
            {label: '<spring:message code="common.number.no"/>', name: 'lineNo', align: 'center', width: '3000'}, <%-- 번호 --%>
            {label: '<spring:message code="common.dept_name"/>', name: 'deptnm', align: 'center', width: '7000'}, <%-- 학과 --%>
            {label: '<spring:message code="cls.label.representative.id"/>', name: 'userId', align: 'center', width: '7000'}, <%-- 대표아이디 --%>
            {label: '<spring:message code="cls.label.student.no"/>', name: 'stdntNo', align: 'center', width: '7000'}, <%-- 학번 --%>
            {label: '<spring:message code="common.name"/>', name: 'usernm', align: 'center', width: '6000'} <%-- 이름 --%>
        ];

<c:if test="${clsShowStudentYearColumns}">
        colModel.push(
            {label: '<spring:message code="cls.label.student.year"/>', name: 'entyR', align: 'center', width: '5000'}, <%-- 입학년도 --%>
            {label: '<spring:message code="cls.label.school.year"/>', name: 'scyr', align: 'center', width: '3000'} <%-- 학년 --%>
        );
</c:if>

        for (var w = 1; w <= MAX_WK; w++) {
            colModel.push({label: String(w), name: 'wk' + w + 'Sts', align: 'center', width: '2500'});
        }

        colModel.push(
            {label: '<spring:message code="cls.label.attendance"/>', name: 'atndCnt', align: 'center', width: '3000'}, <%-- 출석 --%>
            {label: '<spring:message code="cls.label.late"/>', name: 'lateCnt', align: 'center', width: '3000'}, <%-- 지각 --%>
            {label: '<spring:message code="cls.label.absence"/>', name: 'absnCnt', align: 'center', width: '3000'} <%-- 결석 --%>
        );

        $("form[name=excelForm]").remove();

        var $form = $('<form name="excelForm" method="post"></form>');
        $form.attr("action", CTX + clsStdntExcelUrl);
        $form.append($('<input/>', {type: 'hidden', name: 'sbjctId', value: sbjctId}));
        $form.append($('<input/>', {type: 'hidden', name: 'searchValue', value: $("#srchKeyword2").val()}));
        $form.append($('<input/>', {type: 'hidden', name: 'absnWknoFrom', value: parseInt($("#absnWknoFrom").val(), 10) || 0}));
        $form.append($('<input/>', {type: 'hidden', name: 'absnWknoTo', value: parseInt($("#absnWknoTo").val(), 10) || 0}));
        $form.append($('<input/>', {type: 'hidden', name: 'excelGrid', value: JSON.stringify({colModel: colModel})}));
        $form.appendTo("body").submit();
    }

    function searchElemStdntList(page) {
        elemStdntCurrentPageNo = page;

        var extData = {
            sbjctId: sbjctId,
            keyword: $("#elemStdntKeyword").val(),
            pageIndex: page,
            listScale: 20
        };

        var param = {
            encParams: EPARAM,
            addParams: UiComm.makeEncParams(extData)
        };

        ajaxCall(CTX + clsElemStatsUrl, param, function (res) {
                if (res && res.encParams) {
                    EPARAM = res.encParams;
                }
                var $body = $("#elemStdntBody").empty();
                var cnt = res && res.pageInfo ? res.pageInfo.totalRecordCount : 0;
                elemStdntTotalPageCount = res && res.pageInfo ? res.pageInfo.totalPageCount : 1;

                $("#elemStdntTotalCnt").text(cnt);
                $("#elemStdntTotalCnt2").text(cnt);
                $("#elemStdntCurPage").text(page);
                $("#elemStdntTotalPage").text(elemStdntTotalPageCount);
                renderElemPager(page, elemStdntTotalPageCount);

                var list = (res && res.returnList) ? res.returnList : [];

                lastElemUsers = list.map(function (x) {
                    return {
                        userId: x.userId || "",
                        usernm: x.usernm || "",
                        mobileNo: x.mobileNo || "",
                        email: x.email || ""
                    };
                }).filter(function (x) {
                    return !!x.userId;
                });

                if (!res || res.result !== 1 || list.length === 0) {
                    lastElemUsers = [];
                    $body.append(
                        '<tr><td colspan="14" class="t_center">'
                        + '<spring:message code="common.no.data.result"/><%-- 조회된 데이터가 없습니다 --%>'
                        + '</td></tr>'
                    );
                    return;
                }

                function linkCount(uid, text, elemType) {
                    return '<a href="#_" class="link elemCntLink" data-user-id="' + UiComm.escapeHtml(uid) + '" data-elem-type="' + UiComm.escapeHtml(elemType) + '">' + UiComm.escapeHtml(text) + '</a>';
                }

                list.forEach(function (r, idx) {
                    var uid = String(r.userId || '');
                    var uidHtml = UiComm.escapeHtml(uid);
                    var chkId = 'chkElem_' + idx;
                    var qa = (r.qaAnsCnt || 0) + '/' + (r.qaRegCnt || 0);
                    var asmt = (r.asmtSbmsnCnt || 0) + '/' + (r.asmtTrgtCnt || 0);
                    var quiz = (r.quizSbmsnCnt || 0) + '/' + (r.quizTrgtCnt || 0);
                    var srvy = (r.srvySbmsnCnt || 0) + '/' + (r.srvyTrgtCnt || 0);
                    var dscs = (r.dscsSbmsnCnt || 0) + '/' + (r.dscsTrgtCnt || 0);

                    $body.append(
                        '<tr>'
                        + '<td class="t_center"><span class="custom-input onlychk">'
                        + '<input type="checkbox" id="' + chkId + '"'
                        + ' data-user-id="' + uidHtml + '"'
                        + ' data-user-nm="' + UiComm.escapeHtml(r.usernm || '-') + '"'
                        + ' data-mobile="' + UiComm.escapeHtml(r.mobileNo || '-') + '"'
                        + ' data-email="' + UiComm.escapeHtml(r.email || '-') + '"'
                        + '><label for="' + chkId + '"></label></span></td>'
                        + '<td class="t_center">' + (r.lineNo || idx + 1) + '</td>'
                        + '<td class="t_center">' + UiComm.escapeHtml(r.deptnm || '-') + '</td>'
                        + '<td class="t_center">' + UiComm.escapeHtml(String(r.userId || '-')) + '</td>'
                        + '<td class="t_center">' + UiComm.escapeHtml(String(r.stdntNo || '-')) + '</td>'
                        + '<td class="t_center"><a href="#_" class="link elemStdntName" data-user-id="' + uidHtml + '">' + UiComm.escapeHtml(r.usernm || '-') + '</a></td>'
                        + '<td class="t_center">' + qa + '</td>'
                        + '<td class="t_center">' + (r.talkReplyCnt == null ? '0' : r.talkReplyCnt) + '</td>'
                        + '<td class="t_center">' + linkCount(uid, asmt, 'ASMT') + '</td>'
                        + '<td class="t_center">' + linkCount(uid, quiz, 'QUIZ') + '</td>'
                        + '<td class="t_center">' + linkCount(uid, srvy, 'SRVY') + '</td>'
                        + '<td class="t_center">' + linkCount(uid, dscs, 'DSCS') + '</td>'
                        + '<td class="t_center">' + (r.midScore == null || r.midScore === '' ? '-' : r.midScore) + '</td>'
                        + '<td class="t_center">' + (r.finalScore == null || r.finalScore === '' ? '-' : r.finalScore) + '</td>'
                        + '</tr>'
                    );
                });
            },
            function () {
                $("#elemStdntBody").html(
                    '<tr><td colspan="14" class="t_center">'
                    + '<spring:message code="fail.common.msg"/><%-- 에러가 발생하였습니다 --%>'
                    + '</td></tr>'
                );
            },
            false
        );
    }

    function renderElemPager(cur, total) {
        var html = '';
        var pageSize = 5;
        var startPage = Math.floor((cur - 1) / pageSize) * pageSize + 1;
        var endPage = Math.min(startPage + pageSize - 1, total);

        for (var p = startPage; p <= endPage; p++) {
            html += '<button class="page' + (p === cur ? ' active' : '') + '" type="button"'
                + ' onclick="searchElemStdntList(' + p + ')">' + p + '</button>';
        }
        $("#elemPagerPages").html(html);
    }

    function moveElemPage(direction) {
        if (direction === "prev" && elemStdntCurrentPageNo > 1) {
            searchElemStdntList(elemStdntCurrentPageNo - 1);
        } else if (direction === "next" && elemStdntCurrentPageNo < elemStdntTotalPageCount) {
            searchElemStdntList(elemStdntCurrentPageNo + 1);
        }
    }

    $(document).on("click", ".elemStdntName", function (e) {
        e.preventDefault();

        var userId = $(this).data("userId");
        if (!userId) {
            UiComm.showMessage('<spring:message code="cls.alert.invalid.student.info"/><%-- 선택한 학습자 정보를 불러올 수 없습니다. --%>', "warning");
            return;
        }

        UiDialog("stdntLrnPop_" + userId, {
            title: "<spring:message code='cls.title.student.learning.status'/><%-- 학습자 학습현황 --%>",
            width: 1140,
            height: 820,
            url: CTX + clsStdntPopupUrl + "?sbjctId=" + encodeURIComponent(sbjctId)
                + "&dvclasNo=" + encodeURIComponent(dvclasNo)
                + "&userId=" + encodeURIComponent(userId)
                + "&userIds=" + encodeURIComponent(lastElemUsers.map(function (x) {
                    return x.userId;
                }).filter(function (id) {
                    return !!id;
                }).join(","))
                + "&wkNo=1"
                + "&encParams=" + encodeURIComponent(EPARAM)
        });
        normalizeDialogCloseButton();
    });

    $(document).on("click", ".elemCntLink", function (e) {
        e.preventDefault();
        openStdntElemPopup($(this).data("userId"), $(this).data("elemType"));
    });

    function openStdntElemPopup(userId, elemType) {
        UiDialog("stdntElemPop", {
            title: "<spring:message code='cls.title.student.element.status'/><%-- 학습자 학습요소 참여현황 --%>",
            width: 1140,
            height: 820,
            url: CTX + clsElemPopupUrl + "?sbjctId=" + encodeURIComponent(sbjctId)
                + "&dvclasNo=" + encodeURIComponent(dvclasNo)
                + "&userId=" + encodeURIComponent(userId)
                + "&elemType=" + encodeURIComponent(elemType || "ASMT")
                + "&encParams=" + encodeURIComponent(EPARAM)
        });
        normalizeDialogCloseButton();
    }

    function openElemSendMsg() {
        var checkedUsers = [];

        $("#elemStdntBody input[type=checkbox]:checked").each(function () {
            var userId = $(this).data("userId");
            if (!userId) return;
            checkedUsers.push({
                userId: userId,
                usernm: $(this).data("userNm") || "",
                mobileNo: $(this).data("mobile") || "",
                email: $(this).data("email") || ""
            });
        });

        var targets = checkedUsers.length > 0 ? checkedUsers : lastElemUsers;
        if (!targets || targets.length === 0) {
            UiComm.showMessage("<spring:message code='cls.alert.no.user'/><%-- 선택된 학습자가 없습니다. --%>", "warning");
            return;
        }

        var rcvUserInfoStr = targets.map(function (u) {
            return [u.userId, u.usernm, u.mobileNo, u.email].join(";");
        }).join("|");

        var form = document.alarmForm;
        if (!form) {
            UiComm.showMessage('<spring:message code="cls.alert.message.form.notfound"/><%-- 메시지 발송 폼을 찾을 수 없습니다. --%>', "warning");
            return;
        }

        form.action = '<%=CommConst.SYSMSG_URL_SEND%>';
        form.target = "msgWindow";
        form.elements["alarmType"].value = "S";
        form.elements["rcvUserInfoStr"].value = rcvUserInfoStr;
        window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");
        form.submit();
    }

    function downloadElemStdntExcel() {
        var excelGrid = {
            colModel: [
                {label: '<spring:message code="common.number.no"/>', name: 'lineNo', align: 'center', width: '3000'}, <%-- 번호 --%>
                {label: '<spring:message code="common.dept_name"/>', name: 'deptnm', align: 'center', width: '7000'}, <%-- 학과 --%>
                {label: '<spring:message code="cls.label.representative.id"/>', name: 'userId', align: 'center', width: '7000'}, <%-- 대표아이디 --%>
                {label: '<spring:message code="cls.label.student.no"/>', name: 'stdntNo', align: 'center', width: '7000'}, <%-- 학번 --%>
                {label: '<spring:message code="common.name"/>', name: 'usernm', align: 'center', width: '6000'}, <%-- 이름 --%>
                {label: '<spring:message code="cls.label.qna"/>(<spring:message code="cls.label.reply"/>/<spring:message code="cls.label.register"/>)', name: 'qaText', align: 'center', width: '6000'}, <%-- Q&A(답변/등록) --%>
                {label: '<spring:message code="cls.label.discussion.board"/>(<spring:message code="cls.label.comment.count"/>)', name: 'talkReplyCnt', align: 'center', width: '4000'}, <%-- 토론방(댓글수) --%>
                {label: '<spring:message code="cls.label.assignment"/>(<spring:message code="cls.label.submit"/>/<spring:message code="common.all"/>)', name: 'asmtText', align: 'center', width: '6000'}, <%-- 과제(제출/전체) --%>
                {label: '<spring:message code="cls.label.quiz"/>(<spring:message code="cls.label.stare"/>/<spring:message code="common.all"/>)', name: 'quizText', align: 'center', width: '6000'}, <%-- 퀴즈(응시/전체) --%>
                {label: '<spring:message code="cls.label.survey"/>(<spring:message code="common.label.join"/>/<spring:message code="common.all"/>)', name: 'srvyText', align: 'center', width: '6000'}, <%-- 설문(참여/전체) --%>
                {label: '<spring:message code="cls.label.discussion"/>(<spring:message code="common.label.join"/>/<spring:message code="common.all"/>)', name: 'dscsText', align: 'center', width: '6000'}, <%-- 토론(참여/전체) --%>
                {label: '<spring:message code="cls.label.midterm"/>', name: 'midScore', align: 'center', width: '4000'}, <%-- 중간고사 --%>
                {label: '<spring:message code="cls.label.finalterm"/>', name: 'finalScore', align: 'center', width: '4000'} <%-- 기말고사 --%>
            ]
        };

        $("form[name=excelForm]").remove();

        var $form = $('<form name="excelForm" method="post"></form>');
        $form.attr("action", CTX + clsElemExcelUrl);
        $form.append($('<input/>', {type: 'hidden', name: 'sbjctId', value: sbjctId}));
        $form.append($('<input/>', {type: 'hidden', name: 'keyword', value: $("#elemStdntKeyword").val()}));
        $form.append($('<input/>', {type: 'hidden', name: 'excelGrid', value: JSON.stringify(excelGrid)}));
        $form.appendTo("body").submit();
    }

    function saveForcedAttendCallBack() {
        searchStdntList(stdntCurrentPageNo || 1);
        loadWklyStats();
    }

    function cancelForcedAttendCallBack() {
        searchStdntList(stdntCurrentPageNo || 1);
        loadWklyStats();
    }
</script>
