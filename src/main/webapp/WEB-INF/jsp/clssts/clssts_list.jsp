<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
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

    <jsp:include page="/WEB-INF/jsp/common_new/home_header.jsp"/>

    <main class="common">

        <jsp:include page="/WEB-INF/jsp/common_new/home_gnb_prof.jsp"/>

        <div id="content" class="content-wrap common">
            <div class="dashboard_sub">
                <div class="sub-content">

                    <%-- ===== 페이지 타이틀 ===== --%>
                    <div class="page-info">
                        <h2 class="page-title"><spring:message code="cls.title.list"/><%-- 전체수업현황 --%></h2>
                        <uiex:navibar type="main"/>
                    </div>

                    <%-- ===== 검색 영역 ===== --%>
                    <form id="clsListForm" onsubmit="return false;">
                        <input type="hidden" id="pageIndex" name="pageIndex"
                               value="<c:out value='${empty vo.pageIndex ? 1 : vo.pageIndex}'/>"/>
                        <input type="hidden" id="listScale" name="listScale"
                               value="<c:out value='${empty vo.listScale ? 20 : vo.listScale}'/>"/>

                        <div class="search-typeA">

                            <%-- 학사년도 / 학기 --%>
                            <div class="item">
                                <span class="item_tit">
                                    <label for="srchYear">
                                        <spring:message code="cls.label.academic.year"/><%-- 학사년도 --%>/<spring:message code="common.term"/><%--학기 --%>
                                    </label>
                                </span>
                                <div class="itemList">
                                    <c:set var="selectedYr" value="${vo.searchYr}"/>

                                    <select class="form-select" id="srchYear" name="searchYr">
                                        <c:forEach var="item" items="${yearList}">
                                            <option value="${item}" ${item eq selectedYr ? 'selected' : ''}>
                                                    ${item}<spring:message code="date.year"/><%-- 년 --%>
                                            </option>
                                        </c:forEach>
                                    </select>

                                    <select class="form-select" id="srchTerm" name="searchSmstrCd">
                                        <option value=""><spring:message code="cls.label.open.term"/><%-- 개설학기 --%></option>
                                        <c:forEach var="item" items="${smstrChrtList}">
                                            <option value="${item.dgrsSmstrChrt}" <c:if test="${vo.searchSmstrCd == item.dgrsSmstrChrt}">selected</c:if>>
                                                    ${item.smstrChrtnm}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <%-- 운영과목 (학위원 / 학과 / 과목) --%>
                            <div class="item">
                                <span class="item_tit">
                                    <label for="srchSbjt"><spring:message code="cls.label.operating.subject"/><%-- 운영과목 --%></label>
                                </span>
                                <div class="itemList">
                                    <select class="form-select" id="srchOrg" name="searchOrgId">
                                        <option value=""><spring:message code="cls.label.org"/><%-- 기관 --%></option>
                                        <c:forEach var="item" items="${orgList}">
                                            <option value="${item.orgId}" <c:if test="${vo.searchOrgId == item.orgId}">selected</c:if>>
                                                    ${item.orgnm}
                                            </option>
                                        </c:forEach>
                                    </select>

                                    <select class="form-select" id="srchSbjt" name="sbjctId">
                                        <option value=""><spring:message code="cls.label.operating.subject"/><%-- 운영과목 --%></option>
                                        <c:forEach var="item" items="${subjectList}">
                                            <option value="${item.sbjctId}"
                                                    <c:if test="${vo.sbjctId == item.sbjctId}">selected</c:if>>
                                                    ${item.sbjctnm}
                                                        <c:if test="${not empty item.dvclasNo}"> (${item.dvclasNo}<spring:message code="cls.label.decls.name"/><%-- 반 --%>)</c:if>
                                                <c:if test="${not empty item.crclmnNo}"> [${item.crclmnNo}]</c:if>
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="button-area">
                                <button type="button" class="btn search" id="btnSearch">
                                    <spring:message code="button.search"/><%-- 검색 --%>
                                </button>
                            </div>

                        </div>

                        <%-- 목록 헤더: 총건수 + 목록수 조절 --%>
                        <div class="board_top">
                            <h3 class="board-title">
                                <spring:message code="cls.label.operating.subject"/><%-- 운영과목 --%>
                                <span class="total_num">
                                    <spring:message code="common.page.total"/><%-- 총 --%>
                                    <strong id="totalCnt">0</strong>
                                    <spring:message code="common.page.total_count"/><%-- 건 --%>
                                </span>
                            </h3>
                            <div class="right-area">
                                <uiex:listScale func="changeListScale"
                                                value="${empty vo.listScale ? 20 : vo.listScale}"/>
                            </div>
                        </div>

                    </form>

                    <%-- ===== 목록 테이블 ===== --%>
                    <div class="table-wrap">
                        <div id="clsListTable"></div>
                    </div>

                </div>
            </div>
        </div>

        <jsp:include page="/WEB-INF/jsp/common_new/home_footer.jsp"/>

    </main>
</div>

<script type="text/javascript">
    var CTX = "<%=request.getContextPath()%>";
    var EPARAM = '<c:out value="${encParams}" />';
    var PAGE_INDEX = 1;
    var LIST_SCALE = 20;
    var clsListTable = null;

    $(document).ready(function () {
        var ls = $("#listScale").val();
        if (ls) {
            LIST_SCALE = parseInt(ls, 10);
        }

        initClsListTable();
        loadSubjectOptions(true);

        // 검색 버튼
        $("#btnSearch").on("click", function () {
            loadClsList(1);
        });

        // 검색 조건 변경 시에는 하위 드롭다운만 갱신하고, 목록 조회는 검색 버튼에서 수행
        $("#srchYear").on("change", function () {
            reloadYearFilters(false);
        });

        $("#srchTerm").on("change", function () {
            loadSubjectOptions(false);
        });

        $("#srchOrg").on("change", function () {
            loadSubjectOptions(false);
        });

        // 과목 선택도 검색 버튼으로 확정 적용한다.
    });

    /* =====================================================
       UiTable 초기화
       ===================================================== */
    function initClsListTable() {
        clsListTable = UiTable("clsListTable", {
            lang: "ko",
            pageFunc: function (page) {
                loadClsList(page || 1);
            },
            rowClick: function (e, row) {
                var data = row.getData();
                if (data.sbjctId) {
                    goDetail(data.sbjctId, data.dvclasNo);
                }
            },
            columns: [
                {
                    title: '<spring:message code="common.number.no"/>',<%--번호--%>
                    field: "lineNo",
                    headerHozAlign: "center",
                    hozAlign: "center",
                    width: 70,
                    minWidth: 70
                },
                {
                    title: '<spring:message code="common.year"/>', <%-- 년도 --%>
                    field: "sbjctYr",
                    headerHozAlign: "center",
                    hozAlign: "center",
                    width: 80,
                    minWidth: 80
                },
                {
                    title: '<spring:message code="common.term"/>', <%-- 학기 --%>
                    field: "sbjctSmstr",
                    headerHozAlign: "center",
                    hozAlign: "center",
                    width: 60,
                    minWidth: 60
                },
                {
                    title: '<spring:message code="cls.label.org"/>', <%-- 기관 --%>
                    field: "orgnm",
                    headerHozAlign: "center",
                    hozAlign: "center",
                    width: 130,
                    minWidth: 130
                },
                {
                    title: '<spring:message code="cls.label.subject.code"/>', <%-- 과목코드 --%>
                    field: "crclmnNo",
                    headerHozAlign: "center",
                    hozAlign: "center",
                    width: 110,
                    minWidth: 110,
                    formatter: "html"
                },
                {
                    title: '<spring:message code="cls.label.subject.name"/>', <%-- 과목명 --%>
                    field: "sbjctnm",
                    headerHozAlign: "center",
                    hozAlign: "left",
                    width: 0,
                    minWidth: 180
                },
                {
                    title: '<spring:message code="cls.label.decls"/>', <%-- 분반 --%>
                    field: "dvclasNo",
                    headerHozAlign: "center",
                    hozAlign: "center",
                    width: 70,
                    minWidth: 70
                },
                {
                    title: '<spring:message code="cls.label.credit"/>', <%-- 학점 --%>
                    field: "crdts",
                    headerHozAlign: "center",
                    hozAlign: "center",
                    width: 60,
                    minWidth: 60
                },
                {
                    title: '<spring:message code="cls.label.co.professor"/>', <%-- 공동교수 --%>
                    field: "coProfNm",
                    headerHozAlign: "center",
                    hozAlign: "center",
                    width: 110,
                    minWidth: 110
                },
                {
                    title: '<spring:message code="cls.label.tutor"/>', <%-- 튜터 --%>
                    field: "tutor",
                    headerHozAlign: "center",
                    hozAlign: "center",
                    width: 90,
                    minWidth: 90
                },
                {
                    title: '<spring:message code="common.teaching.assistant"/>', <%-- 조교 --%>
                    field: "asst",
                    headerHozAlign: "center",
                    hozAlign: "center",
                    width: 90,
                    minWidth: 90
                },
                {
                    title: "",
                    field: "sbjctId",
                    visible: false
                }
            ]
        });
    }

    /* =====================================================
       운영과목 목록 조회
       ===================================================== */
    function loadClsList(pageIndex) {
        PAGE_INDEX = pageIndex || 1;
        $("#pageIndex").val(PAGE_INDEX);
        $("#listScale").val(LIST_SCALE);

        ajaxCall(CTX + "/clssts/selectClsStsListPaging.do", {
                searchYr: $("#srchYear").val() || "",
                searchSmstrCd: $("#srchTerm").val() || "",
                searchOrgId: $("#srchOrg").val() || "",
                sbjctId: $("#srchSbjt").val() || "",
                pageIndex: PAGE_INDEX,
                listScale: LIST_SCALE
            },
            function (data) {
                if (data && data.result > 0) {
                    var returnList = data.returnList || [];
                    var pageInfo = data.pageInfo || null;

                    clsListTable.replaceData(createClsListData(returnList));
                    if (pageInfo) {
                        clsListTable.setPageInfo(pageInfo);
                        $("#totalCnt").text(pageInfo.totalRecordCount || 0);
                    } else {
                        $("#totalCnt").text(returnList.length);
                    }
                } else {
                    clsListTable.replaceData([]);
                    clsListTable.setPageInfo({
                        currentPageNo: 1,
                        firstPageNoOnPageList: 1,
                        lastPageNoOnPageList: 1,
                        lastPageNo: 1,
                        totalPageCount: 1,
                        totalRecordCount: 0
                    });
                    $("#totalCnt").text("0");
                }
            },
            function () {
                UiComm.showMessage('<spring:message code="fail.common.msg"/>', "error"); <%-- 에러가 발생하였습니다 --%>
                clsListTable.replaceData([]);
                clsListTable.setPageInfo({
                    currentPageNo: 1,
                    firstPageNoOnPageList: 1,
                    lastPageNoOnPageList: 1,
                    lastPageNo: 1,
                    totalPageCount: 1,
                    totalRecordCount: 0
                });
                $("#totalCnt").text("0");
            },
            true
        );
    }

    function createClsListData(list) {
        if (!list || list.length === 0) {
            return [];
        }

        return list.map(function (item) {
            var crclmnNoLink = '<a href="#_" class="link clsDetailLink"'
                + ' data-sbjct-id="' + UiComm.escapeHtml(String(item.sbjctId || '')) + '"'
                + ' data-dvclas-no="' + UiComm.escapeHtml(String(item.dvclasNo || '')) + '">'
                + UiComm.escapeHtml(String(item.crclmnNo || ''))
                + '</a>';

            return {
                lineNo: item.lineNo,
                sbjctYr: item.sbjctYr,
                sbjctSmstr: (item.sbjctSmstr || "").toString().trim(),
                orgnm: item.orgnm || "-",
                crclmnNo: crclmnNoLink,
                sbjctnm: item.sbjctnm || "-",
                dvclasNo: item.dvclasNo || "-",
                crdts: item.crdts,
                coProfNm: item.coProfNm || "-",
                tutor: item.tutor || "-",
                asst: item.asst || "-",
                sbjctId: item.sbjctId
            };
        });
    }

    $(document).on("click", ".clsDetailLink", function (e) {
        e.preventDefault();
        goDetail($(this).data("sbjctId"), $(this).data("dvclasNo"));
    });

    /* =====================================================
       상세 페이지 이동
       ===================================================== */
    function goDetail(sbjctId, dvclasNo) {
        UiComm.showLoading(true);
        var overrideParams = UiComm.makeEncParams({
            sbjctId: sbjctId
        });

        location.href = CTX + "/clssts/selectClsStsDetailView.do"
            + "?encParams=" + encodeURIComponent(EPARAM)
            + "&addParams=" + encodeURIComponent(overrideParams)
            + "&sbjctId=" + encodeURIComponent(sbjctId)
            + "&dvclasNo=" + encodeURIComponent(dvclasNo || "");
    }

    /* =====================================================
       목록 수 변경 (listScale 드롭다운)
       ===================================================== */
    function changeListScale(scale) {
        LIST_SCALE = parseInt(scale || "20", 10);
        $("#listScale").val(LIST_SCALE);
        loadClsList(1);
    }

    /* =====================================================
       연도 변경 시 기관/학기/학과/과목 필터 재구성
       ===================================================== */
    function reloadYearFilters(triggerSearch) {
        loadOrgOptions(function () {
            loadTermOptions(function () {
                loadSubjectOptions(triggerSearch);
            });
        });
    }

    function loadOrgOptions(callback) {
        var currentValue = $("#srchOrg").val() || "";

        ajaxCall(CTX + "/clssts/selectClsStsOrgList.do", {
                searchYr: $("#srchYear").val() || ""
            },
            function (data) {
                var list = (data && data.returnList) ? data.returnList : [];
                var $org = $("#srchOrg");

                $org.empty();
                $org.append('<option value=""><spring:message code="cls.label.org"/><%-- 기관 --%></option>');

                list.forEach(function (item) {
                    var value = item.orgId || "";
                    var label = item.orgnm || "";

                    if (!value || !label) {
                        return;
                    }

                    $org.append(
                        '<option value="' + UiComm.escapeHtml(String(value)) + '">'
                        + UiComm.escapeHtml(String(label))
                        + '</option>'
                    );
                });

                if (currentValue && $org.find("option[value='" + currentValue + "']").length > 0) {
                    $org.val(currentValue);
                } else {
                    $org.val("");
                }

                if (callback) {
                    callback();
                }
            },
            function () {
                if (callback) {
                    callback();
                }
            },
            false
        );
    }

    function loadTermOptions(callback) {
        var currentValue = $("#srchTerm").val() || "";

        ajaxCall(CTX + "/clssts/selectClsStsTermList.do", {
                searchYr: $("#srchYear").val() || ""
            },
            function (data) {
                var list = (data && data.returnList) ? data.returnList : [];
                var $term = $("#srchTerm");

                $term.empty();
                $term.append('<option value=""><spring:message code="cls.label.open.term"/><%-- 개설학기 --%></option>');

                list.forEach(function (item) {
                    var value = item.dgrsSmstrChrt || "";
                    var label = item.smstrChrtnm || "";

                    if (!value || !label) {
                        return;
                    }

                    $term.append(
                        '<option value="' + UiComm.escapeHtml(String(value)) + '">'
                        + UiComm.escapeHtml(String(label))
                        + '</option>'
                    );
                });

                if (currentValue && $term.find("option[value='" + currentValue + "']").length > 0) {
                    $term.val(currentValue);
                } else {
                    $term.val("");
                }

                if (callback) {
                    callback();
                }
            },
            function () {
                if (callback) {
                    callback();
                }
            },
            false
        );
    }

    function loadSubjectOptions(triggerSearch) {
        var currentValue = $("#srchSbjt").val() || "";

        ajaxCall(CTX + "/clssts/selectClsStsSubjectList.do", {
                searchYr: $("#srchYear").val() || "",
                searchSmstrCd: $("#srchTerm").val() || "",
                searchOrgId: $("#srchOrg").val() || ""
            },
            function (data) {
                var list = (data && data.returnList) ? data.returnList : [];
                var $sbj = $("#srchSbjt");

                $sbj.empty();
                $sbj.append('<option value=""><spring:message code="cls.label.operating.subject"/><%-- 운영과목 --%></option>');

                list.forEach(function (item) {
                    var value = item.sbjctId || "";
                    var label = item.sbjctnm || "";

                    if (item.dvclasNo) {
                        label += " (" + item.dvclasNo + '<spring:message code="cls.label.decls.name"/><%-- 반 --%>' + ")";
                    }
                    if (item.crclmnNo) {
                        label += " [" + item.crclmnNo + "]";
                    }

                    $sbj.append(
                        '<option value="' + UiComm.escapeHtml(String(value)) + '">'
                        + UiComm.escapeHtml(String(label))
                        + '</option>'
                    );
                });

                if (currentValue && $sbj.find("option[value='" + currentValue + "']").length > 0) {
                    $sbj.val(currentValue);
                } else {
                    $sbj.val("");
                }

                $sbj.trigger("chosen:updated");

                // 목록 재조회 요청이 있을 때만 호출
                if (triggerSearch) {
                    loadClsList(1);
                }
            },
            function () {
                if (triggerSearch) {
                    loadClsList(1);
                }
            },
            false
        );
    }

</script>

</body>
</html>
