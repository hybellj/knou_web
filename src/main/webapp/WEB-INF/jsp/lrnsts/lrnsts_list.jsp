<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="dashboard"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
</head>
<body class="home ${uiex:getTheme()} ${bodyClass}">
<div id="wrap" class="main">
    <jsp:include page="/WEB-INF/jsp/common_new/home_header.jsp">
        <jsp:param name="userId" value="${userId}"/>
    </jsp:include>

    <main class="common">
        <jsp:include page="/WEB-INF/jsp/common_new/home_gnb_stu.jsp"/>

        <div id="content" class="content-wrap common">
            <div class="dashboard_sub">
                <div class="sub-content">

                    <div class="page-info">
                        <h2 class="page-title"><spring:message code="cls.title.my.learning.status"/><%-- 나의 학습현황 --%></h2>
                        <uiex:navibar type="main"/>
                    </div>

                    <form id="searchForm" onsubmit="return false;">
                        <input type="hidden" id="pageIndex" name="pageIndex" value="${empty vo.pageIndex ? 1 : vo.pageIndex}"/>
                        <input type="hidden" id="listScale" name="listScale" value="${empty vo.listScale ? 20 : vo.listScale}"/>
                        <input type="hidden" id="pageScale" name="pageScale" value="${empty vo.pageScale ? 10 : vo.pageScale}"/>
                        <input type="hidden" id="encParams" name="encParams" value="<c:out value='${encParams}'/>"/>

                        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit">
                                    <label for="srchYear"><spring:message code="cls.label.academic.year"/><%-- 학사년도 --%>/<spring:message code="common.term"/><%-- 학기 --%></label>
                                </span>
                                <div class="itemList">
                                    <select class="form-select" id="srchYear" name="searchYr">
                                        <c:forEach var="item" items="${yearList}">
                                            <option value="${item}" ${item eq vo.searchYr ? 'selected' : ''}>${item}<spring:message code="date.year"/><%-- 년 --%></option>
                                        </c:forEach>
                                    </select>

                                    <select class="form-select" id="srchTerm" name="dgrsSmstrChrt">
                                        <option value=""><spring:message code="common.term"/></option>
                                        <c:forEach var="item" items="${smstrChrtList}">
                                            <option value="${item.dgrsSmstrChrt}" <c:if test="${vo.dgrsSmstrChrt eq item.dgrsSmstrChrt}">selected</c:if>>
                                                <c:out value="${item.smstrChrtnm}"/>
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="item">
                                <span class="item_tit">
                                    <label for="srchSbjt"><spring:message code="common.label.enroll.course"/><%-- 수강과목 --%></label>
                                </span>
                                <div class="itemList">
                                    <select class="form-select" id="srchOrg" name="searchOrgId">
                                        <option value=""><spring:message code="cls.label.org"/><%-- 기관 --%></option>
                                        <c:forEach var="item" items="${orgList}">
                                            <option value="${item.orgId}" <c:if test="${vo.searchOrgId eq item.orgId}">selected</c:if>>
                                                <c:out value="${item.orgnm}"/>
                                            </option>
                                        </c:forEach>
                                    </select>

                                    <select class="form-select" id="srchSbjt" name="searchSbjctId">
                                        <option value=""><spring:message code="common.label.enroll.course"/><%-- 수강과목 --%></option>
                                        <c:forEach var="item" items="${subjectList}">
                                            <option value="${item.sbjctId}" <c:if test="${vo.searchSbjctId eq item.sbjctId}">selected</c:if>>
                                                <c:out value="${item.sbjctnm}"/>
                                                <c:if test="${not empty item.dvclasNo}"> (<c:out value="${item.dvclasNo}"/><spring:message code="cls.label.decls.name"/><%-- 반 --%>)</c:if>
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="button-area">
                                <button type="button" class="btn search" id="btnSearch"><spring:message code="button.search"/><%-- 검색 --%></button>
                            </div>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title">
                                <spring:message code="common.label.enroll.course"/><%-- 수강과목 --%>
                                <span class="total_num"><spring:message code="common.page.total"/><%-- 총 --%> <strong id="totalCnt">0</strong><spring:message code="common.page.total_count"/><%-- 건 --%></span>
                            </h3>
                            <div class="right-area">
                                <uiex:listScale func="changeListScale" value="${empty vo.listScale ? 20 : vo.listScale}"/>
                            </div>
                        </div>
                    </form>

                    <div class="table-wrap">
                        <div id="lrnStsListTable"></div>
                    </div>

                </div>
            </div>
        </div>

        <jsp:include page="/WEB-INF/jsp/common_new/home_footer.jsp"/>
    </main>
</div>

<script type="text/javascript">
    var CTX = "<%=request.getContextPath()%>";
    var EPARAM = '<c:out value="${encParams}"/>';
    var USER_ID = '<c:out value="${userId}"/>';
    var INITIAL_TERM_ID = '<c:out value="${vo.dgrsSmstrChrt}"/>';
    var INITIAL_SBJCT_ID = '<c:out value="${vo.searchSbjctId}"/>';
    var PAGE_INDEX = 1;
    var LIST_SCALE = 20;
    var lrnStsListTable = null;

    $(document).ready(function () {
        var listScale = parseInt($("#listScale").val() || "20", 10);
        LIST_SCALE = isNaN(listScale) ? 20 : listScale;

        initLrnStsListTable();
        if ($("#srchTerm option").length > 1) {
            $("#srchTerm").trigger("chosen:updated");
            $("#srchSbjt").trigger("chosen:updated");
            loadLrnStsList(1);
        } else {
            changeSmstrChrt(true);
        }

        $("#btnSearch").on("click", function () {
            loadLrnStsList(1);
        });

        $("#srchYear").on("change", function () {
            INITIAL_TERM_ID = "";
            INITIAL_SBJCT_ID = "";
            changeSmstrChrt(false);
        });

        $("#srchTerm").on("change", function () {
            INITIAL_SBJCT_ID = "";
            loadSubjectList(false);
        });

        $("#srchOrg").on("change", function () {
            INITIAL_SBJCT_ID = "";
            INITIAL_TERM_ID = "";
            changeSmstrChrt(false);
        });
    });

    /**
     * 수강과목 목록 UiTable을 초기화한다.
     */
    function initLrnStsListTable() {
        lrnStsListTable = UiTable("lrnStsListTable", {
            lang: "ko",
            pageFunc: function (pageIndex) {
                loadLrnStsList(pageIndex);
            },
            placeholder: "<spring:message code='cls.empty.enrolled.subject'/>", <%-- 조회된 수강과목이 없습니다. --%>
            rowClick: function (e, row) {
                var data = row.getData();
                if (data && data.sbjctId) {
                    moveDetail(data.sbjctId, data.dvclasNo);
                }
            },
            columns: [
                {
                    title: '<spring:message code="common.number.no"/><%-- 번호 --%>',
                    field: "lineNo",
                    headerHozAlign: "center",
                    hozAlign: "center",
                    width: 70,
                    minWidth: 70
                },
                {
                    title: '<spring:message code="common.year"/><%-- 년도 --%>',
                    field: "sbjctYr",
                    headerHozAlign: "center",
                    hozAlign: "center",
                    width: 80,
                    minWidth: 80
                },
                {
                    title: '<spring:message code="common.term"/><%-- 학기 --%>',
                    field: "sbjctSmstr",
                    headerHozAlign: "center",
                    hozAlign: "center",
                    width: 70,
                    minWidth: 70
                },
                {
                    title: '<spring:message code="cls.label.org"/><%-- 기관 --%>',
                    field: "orgNm",
                    headerHozAlign: "center",
                    hozAlign: "center",
                    width: 150,
                    minWidth: 150
                },
                {
                    title: '<spring:message code="cls.label.subject.name"/><%-- 과목명 --%>',
                    field: "sbjctnm",
                    headerHozAlign: "center",
                    hozAlign: "left",
                    width: 0,
                    minWidth: 160,
                    formatter: "html"
                },
                {
                    title: '<spring:message code="cls.label.decls"/><%-- 분반 --%>',
                    field: "dvclasNo",
                    headerHozAlign: "center",
                    hozAlign: "center",
                    width: 70,
                    minWidth: 70
                },
                {
                    title: '<spring:message code="cls.label.credit"/><%-- 학점 --%>',
                    field: "crdts",
                    headerHozAlign: "center",
                    hozAlign: "center",
                    width: 70,
                    minWidth: 70
                },
                {
                    title: '<spring:message code="cls.label.co.professor"/><%-- 공동교수 --%>',
                    field: "coProfNm",
                    headerHozAlign: "center",
                    hozAlign: "center",
                    width: 110,
                    minWidth: 110
                },
                {
                    title: '<spring:message code="cls.label.tutor"/><%-- 튜터 --%>',
                    field: "tutor",
                    headerHozAlign: "center",
                    hozAlign: "center",
                    width: 90,
                    minWidth: 90
                },
                {
                    title: '<spring:message code="cls.label.teaching.assistant"/><%-- 조교 --%>',
                    field: "asst",
                    headerHozAlign: "center",
                    hozAlign: "center",
                    width: 90,
                    minWidth: 90
                }
            ]
        });
    }

    /**
     * 수강과목 목록을 Ajax로 조회한다.
     */
    function loadLrnStsList(pageIndex) {
        PAGE_INDEX = pageIndex || 1;
        $("#pageIndex").val(PAGE_INDEX);
        $("#listScale").val(LIST_SCALE);

        ajaxCall(CTX + "/lrnsts/selectLrnStsList.do", {
                searchYr: $("#srchYear").val() || "",
                dgrsSmstrChrt: $("#srchTerm").val() || "",
                searchOrgId: $("#srchOrg").val() || "",
                searchSbjctId: $("#srchSbjt").val() || "",
                pageIndex: PAGE_INDEX,
                listScale: LIST_SCALE,
                pageScale: $("#pageScale").val() || 10,
                encParams: EPARAM
            }, function (res) {
                if (res && res.encParams) {
                    EPARAM = res.encParams;
                    $("#encParams").val(EPARAM);
                }

                if (res && res.result > 0) {
                    var returnList = res.returnList || [];
                    var pageInfo = res.pageInfo || null;

                    lrnStsListTable.replaceData(createLrnStsListData(returnList));
                    if (pageInfo) {
                        lrnStsListTable.setPageInfo(pageInfo);
                        $("#totalCnt").text(pageInfo.totalRecordCount || 0);
                    } else {
                        $("#totalCnt").text(returnList.length || 0);
                    }
                } else {
                    lrnStsListTable.replaceData([]);
                    lrnStsListTable.setPageInfo({
                        currentPageNo: 1,
                        firstPageNoOnPageList: 1,
                        lastPageNoOnPageList: 1,
                        lastPageNo: 1,
                        totalPageCount: 1,
                        totalRecordCount: 0
                    });
                    $("#totalCnt").text("0");

                    if (res && res.message) {
                        UiComm.showMessage(res.message, "error");
                    }
                }
            }, function () {
                lrnStsListTable.replaceData([]);
                lrnStsListTable.setPageInfo({
                    currentPageNo: 1,
                    firstPageNoOnPageList: 1,
                    lastPageNoOnPageList: 1,
                    lastPageNo: 1,
                    totalPageCount: 1,
                    totalRecordCount: 0
                });
                $("#totalCnt").text("0");
                UiComm.showMessage('<spring:message code="fail.common.msg"/><%-- 에러가 발생했습니다! --%>', "error");
            }, true);
    }

    /**
     * 서버 목록 데이터를 UiTable 표시 형식으로 변환한다.
     */
    function createLrnStsListData(list) {
        if (!list || list.length === 0) {
            return [];
        }

        return list.map(function (item) {
            var sbjctNmLink = '<a href="#_" class="link" onclick="moveDetail(\''
                + escapeJs(item.sbjctId)
                + '\', \''
                + escapeJs(item.dvclasNo)
                + '\'); return false;">'
                + UiComm.escapeHtml(String(item.sbjctnm || "-"))
                + '</a>';

            return {
                lineNo: item.lineNo || "",
                sbjctYr: item.sbjctYr || "",
                sbjctSmstr: item.sbjctSmstr || "",
                orgNm: item.orgNm || "-",
                sbjctnm: sbjctNmLink,
                dvclasNo: item.dvclasNo || "-",
                crdts: item.crdts || "-",
                coProfNm: item.coProfNm || "-",
                tutor: item.tutor || "-",
                asst: item.asst || "-",
                sbjctId: item.sbjctId || ""
            };
        });
    }

    /**
     * 상세 화면으로 이동한다.
     */
    function moveDetail(sbjctId, dvclasNo) {
        if (!sbjctId) {
            return;
        }

        var url = CTX + "/lrnsts/selectLrnStsDetailView.do"
            + "?sbjctId=" + encodeURIComponent(sbjctId)
            + "&dvclasNo=" + encodeURIComponent(dvclasNo || "")
            + "&userId=" + encodeURIComponent(USER_ID);

        if (EPARAM) {
            url += "&encParams=" + encodeURIComponent(EPARAM);
        }

        location.href = url;
    }

    /**
     * 목록 건수 변경 시 첫 페이지부터 다시 조회한다.
     */
    function changeListScale(scale) {
        LIST_SCALE = parseInt(scale || "20", 10);
        if (isNaN(LIST_SCALE) || LIST_SCALE <= 0) {
            LIST_SCALE = 20;
        }

        $("#listScale").val(LIST_SCALE);
        loadLrnStsList(1);
    }

    /**
     * 학사년도 기준 학기 드롭다운을 갱신한다.
     */
    function changeSmstrChrt(triggerSearch) {
        var $term = $("#srchTerm");
        var currentValue = INITIAL_TERM_ID;

        $.ajax({
            url: CTX + "/lrnsts/selectLrnStsSmstrChrtList.do",
            type: "POST",
            dataType: "json",
            data: {
                searchYr: $("#srchYear").val() || "",
                searchOrgId: $("#srchOrg").val() || "",
                encParams: EPARAM
            },
            success: function (data) {
                $term.empty();
                $term.append('<option value=""><spring:message code="common.term"/></option>');

                if (data && data.result > 0) {
                    var list = data.returnList || [];

                    list.forEach(function (item) {
                        var value = item.dgrsSmstrChrt || "";
                        var label = item.smstrChrtnm || "";
                        $term.append('<option value="' + UiComm.escapeHtml(String(value)) + '">' + UiComm.escapeHtml(String(label)) + '</option>');
                    });
                }

                if (data && data.encParams) {
                    EPARAM = data.encParams;
                    $("#encParams").val(EPARAM);
                }

                if (currentValue && $term.find("option[value='" + currentValue + "']").length > 0) {
                    $term.val(currentValue);
                } else {
                    $term.val("");
                }

                INITIAL_TERM_ID = "";
                $("#srchTerm").trigger("chosen:updated");
                loadSubjectList(triggerSearch);
            },
            error: function () {
                $term.val("");
                $("#srchTerm").trigger("chosen:updated");
                loadSubjectList(triggerSearch);
            }
        });
    }

    /**
     * 검색 조건에 맞는 수강과목 드롭다운을 갱신한다.
     */
    function loadSubjectList(triggerSearch) {
        var $subject = $("#srchSbjt");

        $subject.empty();
        $subject.append('<option value=""><spring:message code="common.label.enroll.course"/><%-- 수강과목 --%></option>');

        ajaxCall(CTX + "/lrnsts/selectLrnStsSubjectList.do", {
                searchYr: $("#srchYear").val() || "",
                dgrsSmstrChrt: $("#srchTerm").val() || "",
                searchOrgId: $("#srchOrg").val() || "",
                encParams: EPARAM
            }, function (res) {
                if (res && res.encParams) {
                    EPARAM = res.encParams;
                    $("#encParams").val(EPARAM);
                }

                var list = (res && res.returnList) ? res.returnList : [];
                list.forEach(function (item) {
                    var value = item.sbjctId || "";
                    var label = item.sbjctnm || "";

                    if (item.dvclasNo) {
                        label += " (" + item.dvclasNo + "<spring:message code='cls.label.decls.name'/><%-- 반 --%>)";
                    }

                    $subject.append('<option value="' + UiComm.escapeHtml(String(value)) + '">' + UiComm.escapeHtml(String(label)) + '</option>');
                });

                if (INITIAL_SBJCT_ID && $subject.find("option[value='" + INITIAL_SBJCT_ID + "']").length > 0) {
                    $subject.val(INITIAL_SBJCT_ID);
                } else {
                    $subject.val("");
                }

                INITIAL_SBJCT_ID = "";
                $("#srchSbjt").trigger("chosen:updated");

                if (triggerSearch) {
                    loadLrnStsList(1);
                }
            }, function () {
                $subject.val("");
                $("#srchSbjt").trigger("chosen:updated");

                if (triggerSearch) {
                    loadLrnStsList(1);
                }
            }, false);
    }

    /**
     * 인라인 스크립트 파라미터 이스케이프 공통 함수이다.
     */
    function escapeJs(value) {
        return String(value || "")
            .replace(/\\/g, "\\\\")
            .replace(/'/g, "\\'")
            .replace(/"/g, '\\"');
    }
</script>
</body>
</html>
