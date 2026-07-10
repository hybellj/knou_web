<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="dashboard"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>

<script type="text/javascript">

    let EPARAM = "";

    const SBJCT_ID = "SBJCT20260001";

    // 활동 설정
    const ACTIVITY_CONFIG = {
        asmt : {
            name      : "과제",
            areaId    : "asmtArea",
            tableId   : "asmtList",
            listFunc  : getAsmtList,
            ratioUrl  : "/asmt2/mrkRfltrtSingleModify.do",
            ratioKey  : "asmtId",
            mrkUrl    : "/asmt2/profAsmtMrkOynModifyAjax.do",
            dataKey   : "asmtId"
        },
        dscs : {
            name      : "토론",
            areaId    : "dscsArea",
            tableId   : "dscsList",
            listFunc  : getDscsList,
            ratioUrl  : "/forum2/forumLect/dscsMrkRfltrtModify.do",
            ratioKey  : "dscsId",
            mrkUrl    : "/forum2/forumLect/dscsMrkOynModify.do",
            dataKey   : "dscsId"
        },
        quiz : {
            name      : "퀴즈",
            areaId    : "quizArea",
            tableId   : "quizList",
            listFunc  : getQuizList,
            ratioUrl  : "/quiz/quizMrkRfltrtModify.do",
            ratioKey  : "examBscId",
            dataKey   : "examBscId"
        },
        srvy : {
            name      : "설문",
            areaId    : "srvyArea",
            tableId   : "srvyList",
            listFunc  : getSrvyList,
            ratioUrl  : "/srvy/srvyMrkRfltrtModify.do",
            ratioKey  : "srvyId",
            dataKey   : "srvyId"
        },
        smnr : {
            name      : "세미나",
            areaId    : "smnrArea",
            tableId   : "smnrList",
            listFunc  : getSmnrList,
            ratioUrl  : "/smnr/smnrMrkRfltrtModify.do",
            ratioKey  : "smnrId",
            dataKey   : "smnrId"
        }
    };

    // 탭 최초 조회 여부
    const loadedTabs = {
        asmt : false,
        dscs : false,
        quiz : false,
        srvy : false,
        smnr : false
    };

    // 테이블 객체
    const tableMap = {};

    $(document).ready(function () {
        initTables();
        loadTab("asmt");
        bindEvents();
    });

    /**
     * 이벤트 바인딩
     */
    function bindEvents() {
        // 과제 링크 / 루브릭
        $(document).on("click", ".link-view", function (e) {
            e.preventDefault();
            const id = $(this).data("id");
            asmtViewMv(id);
        });

        $(document).on("click", ".rubric-link", function (e) {
            e.preventDefault();
            const id = $(this).data("id");
            openRubricPopup(id);
        });
    }

    /**
     * 테이블 초기화
     */
    function initTables() {
        initTable("quiz", "퀴즈명");
        initTable("smnr", "세미나명");
        initTable("asmt", "과제명");
        initTable("srvy", "설문명");
        initTable("dscs", "토론명");
    }

    /**
     * 공통 테이블 생성
     */
    function initTable(type, titleName) {
        const tableId = ACTIVITY_CONFIG[type].tableId;
        
        console.log(type, tableId);
        
        const columns = [
            { title : "No", field : "no", hozAlign : "center", headerHozAlign : "center", width: 50 },
            { title : "구분", field : "gbnnm", hozAlign : "center", headerHozAlign : "center",  width: 100 },
            { title : titleName, field : "ttl", hozAlign : "center", headerHozAlign : "center",  width: 250, formatter : ttlFormatter },
            { title : "제출기간", field : "period", hozAlign : "center", headerHozAlign : "center",  width: 300 }
        ];
        // 과제 / 설문
        if (type === "asmt" || type === "srvy") {
            columns.push(
                {
                    title : "연장제출마감",
                    field : "extSbmsnEnd",
                    hozAlign : "center",
                    headerHozAlign : "center",
                    width : 100
                }
            );
        }
        // 과제 / 토론 / 설문
        if (type === "asmt" || type === "dscs" || type === "srvy") {
            columns.push(
                {
                    title : "평가방법",
                    field : "evlScrTynm",
                    hozAlign : "center",
                    headerHozAlign : "center",
                    width : 150,
                    formatter : rubricFormatter
                }
            );
        }
        // 공통
        columns.push(
            {
                title : "성적반영비율",
                field : "ratioHtml",
                hozAlign : "center",
                headerHozAlign : "center",
                width : 100
            },
            {
                title : "성적공개",
                field : "mrkOynHtml",
                hozAlign : "center",
                headerHozAlign : "center",
                width : 100,
                formatter : "html"
            },
            {
                title : "진행상태",
                field : "sts",
                hozAlign : "center",
                headerHozAlign : "center",
                width : 80
            }
        );

        tableMap[type] = UiTable(tableId, {
            columns : columns
        });
    }

    /**
     * 탭 전환
     */
    function loadTab(type) {
        Object.keys(ACTIVITY_CONFIG).forEach(function (key) {
            $("#" + ACTIVITY_CONFIG[key].areaId).hide();
        });

        $("#" + ACTIVITY_CONFIG[type].areaId).show();
        if (loadedTabs[type]) {
            return;
        }

        loadedTabs[type] = true;
        ACTIVITY_CONFIG[type].listFunc(SBJCT_ID);
    }    

    /**
     * 과제 목록
     */
    function getAsmtList(sbjctId) {
        $.ajax({
            url : "/asmt2/bySubjectAsmtList.do",
            type : "POST",
            data : {
                orgId : "LMSBASIC",
                sbjctId : sbjctId,
                encParams : EPARAM
            }
        }).done(function (data) {
            if (data.encParams) {
                EPARAM = data.encParams;
            }

            if (data.result > 0) {
                const list = data.returnList.map(function (v) {
                    return createRowData("asmt", {
                        id          : v.asmtId,
                        no          : v.rnum,
                        gbnnm       : v.asmtGbnnm,
                        ttl         : v.asmtTtl,
                        period      : UiComm.formatDate(v.asmtSbmsnSdttm, "datetime2")+ " ~ " + UiComm.formatDate(v.asmtSbmsnEdttm, "datetime2"),
                        evlScrTynm  : v.evlScrTynm,
                        ratio       : v.mrkRfltrt + " %",
                        mrkOyn      : v.mrkOyn,
                        sts         : v.asmtPrgrsSts
                    });
                });
                tableMap.asmt.replaceData(list);
            }
        });
    }

    /**
     * 토론 목록
     */
    function getDscsList(sbjctId) {
        $.ajax({
            url : "/forum2/forumLect/bySubjectDscsList.do",
            type : "POST",
            data : {
                sbjctId : sbjctId
            }
        }).done(function (data) {

            if (data.result > 0) {
                const list = data.returnList.map(function (v) {
                    return createRowData("dscs", {
                        id          : v.dscsId,
                        no          : v.rnum,
                        gbnnm       : "",
                        ttl         : v.dscsTtl,
                        period      : UiComm.formatDate(v.dscsSdttm, "datetime2")+ " ~ "+ UiComm.formatDate(v.dscsEdttm, "datetime2"),
                        evlScrTynm  : v.evlScrTynm,
                        ratio       : v.mrkRfltrt + " %",
                        mrkOyn      : v.mrkOyn,
                        sts         : v.dscsPrgrsSts
                    });
                });

                tableMap.dscs.replaceData(list);
            }
        });
    }

    /**
     * 퀴즈 목록
     */
    function getQuizList(sbjctId) {
        $.ajax({
            url : "/quiz/bySubjectQuizList.do",
            type : "POST",
            data : {
                sbjctId : sbjctId
            }
        }).done(function (data) {
            if (data.result > 0) {
                const list = data.returnList.map(function (v) {
                    return createRowData("quiz", {
                        id          : v.examBscId,
                        no          : v.rnum,
                        gbnnm       : "퀴즈",
                        ttl         : v.examTtl,
                        period      : UiComm.formatDate(v.quizSdttm, "datetime2")+ " ~ " + UiComm.formatDate(v.quizEdttm, "datetime2"),
                        ratio       : v.mrkRfltrt + " %",
                        sts         : v.quizPrgrsSts
                    });
                });
                tableMap.quiz.replaceData(list);
            }
        });
    }

    /**
     * 설문 목록
     */
    function getSrvyList(sbjctId) {
        $.ajax({
            url : "/srvy/bySubjectSrvyList.do",
            type : "POST",
            data : {
                sbjctId : sbjctId
            }
        }).done(function (data) {
            if (data.result > 0) {
                const list = data.returnList.map(function (v) {
                    return createRowData("srvy", {
                        id          : v.srvyId,
                        no          : v.rnum,
                        gbnnm       : "설문",
                        ttl         : v.srvyTtl,
                        period      : "",
                        ratio       : v.mrkRfltrt + " %",
                        sts         : ""
                    });
                });
                tableMap.srvy.replaceData(list);
            }
        });
    }

    /**
     * 세미나 목록
     */
    function getSmnrList(sbjctId) {
        $.ajax({
            url : "/smnr/bySubjectSmnrList.do",
            type : "POST",
            data : {
                sbjctId : sbjctId
            }
        }).done(function (data) {
            if (data.result > 0) {
                const list = data.returnList.map(function (v) {
                    return createRowData("smnr", {
                        id          : v.smnrId,
                        no          : v.lineNo,
                        gbnnm       : "세미나",
                        ttl         : v.smnrnm,
                        period      : UiComm.formatDate(v.smnrSdttm, "datetime2")+ " ~ "+ UiComm.formatDate(v.smnrEdttm, "datetime2"),
                        ratio       : v.mrkRfltrt + " %",
                        sts         : ""
                    });
                });
                tableMap.smnr.replaceData(list);
            }
        });
    }

    /**
     * 공통 Row 생성
     */
    function createRowData(type, row) {
        return {
            id            : row.id,
            no            : row.no,
            gbnnm         : row.gbnnm || "",
            ttl           : row.ttl || "",
            period        : row.period || "",
            evlScrTynm    : row.evlScrTynm || "",
            ratioHtml     : row.ratio || "",
            mrkOynHtml    : createMrkOynHtml(type, row.id, row.mrkOyn),
            sts           : row.sts || ""
        };
    }

    /**
     * 공개여부 html 생성
     */
    function createMrkOynHtml(type, id, mrkOyn) {
        if (!mrkOyn) {
            return "";
        }
        return (mrkOyn === "Y" ? "공개" : "비공개");
    }

    /**
     * 제목 formatter
     */
    function ttlFormatter(cell) {
        const row = cell.getRow().getData();
        return ''
            + '<a href="#" '
            + 'class="link-view" '
            + 'data-id="' + row.id + '">'
            + cell.getValue()
            + '</a>';
    }

    /**
     * 루브릭 formatter
     */
    function rubricFormatter(cell) {
        const row = cell.getRow().getData();
        const value = cell.getValue() || "";
        if (value.indexOf("루브릭") > -1) {
            return ''
                + '<a href="#" '
                + 'class="rubric-link" '
                + 'data-id="' + row.id + '" '
                + 'style="color:#2563eb;font-weight:600;text-decoration:underline;">'
                + value
                + '</a>';
        }
        return value;
    }

    /**
     * 루브릭 팝업
     */
    function openRubricPopup(asmtId) {
        const url = "/asmt2/profRubricPop.do?asmtId=" + encodeURIComponent(asmtId);
        window.open(url, "rubricPop", "width=900,height=700,scrollbars=yes,resizable=yes");
    }

    /**
     * 현재 탭 재조회
     */
    function reloadCurrentTab(type) {
        ACTIVITY_CONFIG[type].listFunc(SBJCT_ID);
    }

</script>
</head>
<body>
<body class="class ${uiex:getTheme()} ">
                    <div class="board_top">
                        <h3 class="board-title">평가비중</h3>
                    </div>

                    <!-- 평가비율 -->
                    <div class="table-wrap">
                        <table class="table-type1">
						    <colgroup>
						        <col style="width: 20%;"> 
						        
						        <c:forEach var="item" items="${actvRateView.mrkItmStngList}">
						            <col style="width:10%">
						        </c:forEach>
						    </colgroup>
						    <thead>
						    <tr>
						        <th>평가항목</th>
						        <c:forEach var="item" items="${actvRateView.mrkItmStngList}">
						            <th><c:out value="${item.mrkItmTynm}"/></th>
						        </c:forEach>
						    </tr>
						    </thead>
						    <tbody>
						    <tr>
						        <th data-th="평가항목">비율 (%)</th>
						        <c:forEach var="item" items="${actvRateView.mrkItmStngList}">
						            <td data-th="${item.mrkItmTynm}">
						                <c:choose>
						                    <c:when test="${item.mrkItmUseyn eq 'Y'}">
						                        <c:out value="${item.mrkRfltrt}"/>
						                    </c:when>
						                    <c:otherwise>-</c:otherwise>
						                </c:choose>
						            </td>
						        </c:forEach>
						    </tr>                           
						    </tbody>
						</table>                        
                    </div>
</body>
</html>