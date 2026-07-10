<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/asmt2/common/asmt_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
</head>

<body class="class ${uiex:getTheme()} ${bodyClass}">
<div id="wrap" class="main">
    <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>

    <main class="common">
        <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_stu.jsp"/>

        <div id="content" class="content-wrap common">
            <jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>

            <div class="class_sub">
                <jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>

                <div class="sub-content">
                    <div class="page-info">
                        <h2 class="page-title"><spring:message code='asmt.label.asmt'/><%--과제--%></h2>
                    </div>

                    <div id="asmtListArea">
                        <div class="board_top">
                            <h3 class="board-title"><spring:message code='asmt.label.list'/><%--목록--%></h3>
                            <div class="right-area">
                                <div class="search-typeC">
                                    <input class="form-control" type="text" id="searchValue" value="" placeholder="<spring:message code='asmt.label.input.asmt_title'/><%--과제명 입력--%>" autocomplete="off">
                                    <button type="button" class="btn basic icon search" aria-label="<spring:message code='asmt.common.search'/><%--검색--%>" onclick="listPaging(1)">
                                        <i class="icon-svg-search"></i>
                                    </button>
                                </div>

                                <span class="list-card-button"></span>
                                <uiex:listScale func="changeListScale" value="${asmtVO.listScale}"/>
                            </div>
                        </div>

                        <div id="asmtList"></div>

                        <div id="asmtList_cardForm" class="lecture_box" style="display:none">
                            <div class="card-header">
                                <label class="label s_c02">#[asmtGbnnm]</label>
                                <div class="card-title">#[asmtTtl]</div>
                            </div>
                            <div class="card-body">
                                <div class="extra">
                                    <ul class="process-bar">
                                        <li style="width:100%;">#[progressSts] / #[sbmsnSts]</li>
                                    </ul>
                                    <div class="desc">
                                        <p><label><spring:message code='asmt.label.send.date'/><%--제출기간--%></label><strong>#[sbmsnPeriod]</strong></p>
                                        <p><label><spring:message code='asmt.label.ext.send.deadline'/><%--연장제출마감--%></label><strong>#[extdSbmsnEdttm]</strong></p>
                                        <p><label><spring:message code='asmt.label.score.aply'/><%--성적반영--%></label><strong>#[mrkRfltyn]</strong></p>
                                        <%--<p><label><spring:message code='asmt.label.submit.yn'/><%--제출여부--%></label><strong>#[sbmsnSts]</strong></p>--%>
                                        <p><label><spring:message code='asmt.label.eval.score'/><%--평가점수--%></label><strong>#[scr]</strong></p>
                                        <p><label><spring:message code='asmt.label.feedback'/><%--피드백--%></label><strong>#[fdbkHtml]</strong></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<script type="text/javascript">
    let PAGE_INDEX = '<c:out value="${asmtVO.pageIndex}" />';
    let LIST_SCALE = '<c:out value="${asmtVO.listScale}" />';
    let EPARAM = '<c:out value="${encParams}" />';
    const SBJCT_ID = '<c:out value="${asmtVO.sbjctId}" />';
    const ORG_ID = '<c:out value="${asmtVO.orgId}" />';
    let asmtListTable;

    const ASMT_PRGRS_STS_NM = {
        BEFORE: '<spring:message code='asmt.label.progress.before'/><%--진행전--%>',
        PROGRESS: '<spring:message code='asmt.label.progress.ing'/><%--진행 중--%>',
        EXT_PROGRESS: '<spring:message code='asmt.label.progress.ext.ing'/><%--연장진행중--%>',
        CLOSED: '<spring:message code='asmt.label.deadline'/><%--마감--%>'
    };

    $(function () {
        $("#searchValue").on("keyup", function (e) {
            if (e.keyCode === 13) {
                listPaging(1);
            }
        });

        asmtListTable = UiTable("asmtList", {
            pageFunc: listPaging,
            columns: [
                {title: "No", field: "no", headerHozAlign: "center", hozAlign: "center", width: 60, minWidth: 60},
                {title: "<spring:message code='asmt.label.type'/><%--구분--%>", field: "asmtGbnnm", headerHozAlign: "center", hozAlign: "center", width: 110, minWidth: 110},
                {title: "<spring:message code='asmt.label.asmt.title'/><%--과제명--%>", field: "asmtTtl", headerHozAlign: "center", hozAlign: "left", width: 0, minWidth: 220},
                {title: "<spring:message code='asmt.label.send.date'/><%--제출기간--%>", field: "sbmsnPeriod", headerHozAlign: "center", hozAlign: "center", width: 260, minWidth: 280},
                {title: "<spring:message code='asmt.label.ext.send.deadline'/><%--연장제출마감--%>", field: "extdSbmsnEdttm", headerHozAlign: "center", hozAlign: "center", width: 140, minWidth: 280},
                {title: "<spring:message code='asmt.label.score.aply'/><%--성적반영--%>", field: "mrkRfltyn", headerHozAlign: "center", hozAlign: "center", width: 90, minWidth: 90},
                {title: "<spring:message code='asmt.label.progress.status'/><%--진행상태--%>", field: "progressSts", headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100},
                {title: "<spring:message code='asmt.label.submit.yn'/><%--제출여부--%>", field: "sbmsnSts", headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100},
                {title: "<spring:message code='asmt.label.eval.score'/><%--평가점수--%>", field: "scr", headerHozAlign: "center", hozAlign: "center", width: 90, minWidth: 90},
                {title: "<spring:message code='asmt.label.feedback'/><%--피드백--%>", field: "fdbkHtml", headerHozAlign: "center", hozAlign: "center", width: 80, minWidth: 80}
            ]
        });

        listPaging(PAGE_INDEX || 1);
    });

    /**
     * 과제 목록 조회 결과를 테이블/카드 렌더링 데이터로 변환
     */
    function createAsmtListHTML(list, pageInfo) {
        let dataList = [];

        if (!list || list.length === 0) {
            return dataList;
        }

        list.forEach(function (v) {
            const lineNo = pageInfo.totalRecordCount - v.lineNo + 1;
            const asmtId = v.asmtId || "";
            const targetAsmtId = v.targetAsmtId || asmtId;
            const asmtTtl = UiComm.escapeHtml(v.asmtTtl || "");
            const linkAsmtTtl = "<a href='#0' class='link' onclick='moveStdntAsmtView(\"" + targetAsmtId + "\"); return false;'>" + asmtTtl + "</a>";
            const sbmsnSts = getSbmsnSts(v);

            dataList.push({
                no: lineNo,
                asmtGbnnm: v.asmtGbnnm || "-",
                asmtTtl: linkAsmtTtl,
                sbmsnPeriod: formatPeriod(v.asmtSbmsnSdttm, v.asmtSbmsnEdttm),
                extdSbmsnEdttm: v.extdSbmsnEdttm ? UiComm.formatDate(v.extdSbmsnEdttm, "datetime2") : "-",
                mrkRfltyn: v.mrkRfltyn === "Y" ? "Y" : "N",
                progressSts: getAsmtPrgrsStsNm(v.asmtPrgrsSts),
                sbmsnSts: sbmsnSts,
                scr: getScr(v),
                fdbkHtml: getFdbkHtml(targetAsmtId, v.fdbkCnt || 0),
                valAsmtId: v.valAsmtId || ""
            });
        });

        return dataList;
    }

    /**
     * 검색 조건과 페이지 정보를 기준으로 학생 과제 목록 조회
     */
    function listPaging(pageIndex) {
        PAGE_INDEX = pageIndex;

        const extData = {
            orgId: ORG_ID,
            pageIndex: PAGE_INDEX,
            listScale: LIST_SCALE,
            searchValue: $("#searchValue").val(),
            sbjctId: SBJCT_ID
        };

        const param = {
            encParams: EPARAM,
            addParams: UiComm.makeEncParams(extData)
        };

        ajaxCall("/asmt2/stdntAsmtListAjax.do", param, function (data) {
            if (data.encParams != null && data.encParams !== "") {
                EPARAM = data.encParams;
            }

            if (data.result > 0) {
                const dataList = createAsmtListHTML(data.returnList || [], data.pageInfo);
                asmtListTable.clearData();
                asmtListTable.replaceData(dataList);
                asmtListTable.setPageInfo(data.pageInfo);
            } else {
                UiComm.showMessage(data.message, "error");
            }
        }, function () {
            UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");
        }, true);
    }

    /**
     * 목록 표시 건수 변경 및 첫 페이지 재조회
     */
    function changeListScale(scale) {
        LIST_SCALE = scale;
        listPaging(1);
    }

    /**
     * 학생 과제 상세 화면 이동
     */
    function moveStdntAsmtView(asmtId) {
        const extData = {
            asmtId: asmtId,
            sbjctId: SBJCT_ID
        };

        location.href = "/asmt2/stdntAsmtView.do?encParams=" + EPARAM + "&addParams=" + UiComm.makeEncParams(extData);
    }

    /**
     * 피드백 팝업 호출
     */
    function fdbkPopup(asmtId) {
        const extData = {
            asmtId: asmtId
        };

        dialog = UiDialog("dialog1", {
            title: "<spring:message code='asmt.label.feedback'/><%--피드백--%>",
            width: 1000,
            height: 350,
            url: "/asmt2/stdntAsmtFdbkPopup.do?encParams=" + EPARAM + "&addParams=" + UiComm.makeEncParams(extData),
            autoresize: true
        });
    }

    /**
     * 시작/종료 일시를 화면 표시용 제출기간 문자열로 변환
     */
    function formatPeriod(startDttm, endDttm) {
        if (!startDttm || !endDttm) {
            return "-";
        }
        return UiComm.formatDate(startDttm, "datetime2") + " ~ " + UiComm.formatDate(endDttm, "datetime2");
    }

    /**
     * 과제 진행상태 코드를 화면 표시명으로 변환
     */
    function getAsmtPrgrsStsNm(asmtPrgrsSts) {
        if (!asmtPrgrsSts) {
            return "-";
        }
        return ASMT_PRGRS_STS_NM[asmtPrgrsSts] || UiComm.escapeHtml(asmtPrgrsSts);
    }

    /**
     * 제출상태 공통코드 명칭 조회
     */
    function getSbmsnSts(v) {
        return v.sbmsnStsnm || "-";
    }

    /**
     * 피드백 건수 링크 HTML 생성
     */
    function getFdbkHtml(asmtId, fdbkCnt) {
        const cnt = Number(fdbkCnt || 0);
        return "<a href='#0' class='link' onclick='fdbkPopup(\"" + UiComm.escapeHtml(asmtId) + "\"); return false;'>" + cnt + "</a>";
    }

    /**
     * 평가점수를 화면 표시용 문자열로 변환
     */
    function getScr(v) {
        if (v.mrkInqPsblYn !== "Y") {
            return "-";
        }

        if (v.asmtPrgrsSts === "CLOSED" && v.evlyn === "Y" && v.scr != null && v.scr !== "") {
            return v.scr + "<spring:message code='asmt.label.point'/><%--점--%>";
        }

        return "-<spring:message code='asmt.label.point'/><%--점--%>";
    }

</script>
</body>
</html>
