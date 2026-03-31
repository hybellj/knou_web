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

<body class="home colorA ${bodyClass}">
<div id="wrap" class="main">

    <jsp:include page="/WEB-INF/jsp/common_new/home_header.jsp"/>

    <main class="common">

        <jsp:include page="/WEB-INF/jsp/common_new/home_gnb_prof.jsp"/>

        <div id="content" class="content-wrap common">
            <div class="dashboard_sub">
                <div class="sub-content">

                    <%-- ===== 페이지 타이틀 ===== --%>
                    <div class="page-info">
                        <h2 class="page-title">전체수업현황</h2>
                        <div class="navi_bar">
                            <ul>
                                <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                <li><spring:message code="dashboard.lesson"/></li>
                                <li><span class="current">전체수업현황</span></li>
                            </ul>
                        </div>
                    </div>

                    <%-- ===== 검색 영역 ===== --%>
                    <form id="clsListForm" onsubmit="return false;">
                        <input type="hidden" id="pageIndex" name="pageIndex"
                               value="<c:out value='${empty vo.pageIndex ? 1 : vo.pageIndex}'/>"/>
                        <input type="hidden" id="listScale" name="listScale"
                               value="<c:out value='${empty vo.listScale ? 20 : vo.listScale}'/>"/>
                        <input type="hidden" id="pageScale" name="pageScale"
                               value="<c:out value='${empty vo.pageScale ? 10 : vo.pageScale}'/>"/>

                        <div class="search-typeA">

                            <%-- 학년도 / 학기 --%>
                            <div class="item">
                                <span class="item_tit">
                                    <label for="srchYear">
                                        <spring:message code="common.year"/>/<spring:message code="common.term"/> <%-- 학년도/학기 --%>
                                    </label>
                                </span>
                                <div class="itemList">
                                    <c:set var="selectedYr" value="${vo.searchYr}"/>

                                    <select class="form-select" id="srchYear" name="searchYr">
                                        <c:forEach var="item" items="${yearList}">
                                            <option value="${item}" ${item eq selectedYr ? 'selected' : ''}>
                                                    ${item}년
                                            </option>
                                        </c:forEach>
                                    </select>

                                    <select class="form-select" id="srchTerm" name="smstrChrtId">
                                        <option value=""><spring:message code="crs.label.open.term" /></option> <%--개설학기--%>
                                    </select>
                                </div>
                            </div>

                            <%-- 운영과목 (학위원 / 학과 / 과목) --%>
                            <div class="item">
                                <span class="item_tit"><label for="srchSbjt">운영과목</label></span> 
                                <div class="itemList">
                                    <select class="form-select" id="srchOrg" name="searchOrgId">
                                        <option value="">기관</option>
                                        <c:forEach var="item" items="${orgList}">
                                            <option value="${item.orgId}" <c:if test="${vo.searchOrgId == item.orgId}">selected</c:if>>
                                                    ${item.orgnm}
                                            </option>
                                        </c:forEach>
                                    </select>

                                    <select class="form-select" id="srchDept" name="deptId">
                                        <option value="">학과</option> 
                                        <c:forEach var="item" items="${deptList}">
                                            <option value="${item.deptId}"
                                                    <c:if test="${vo.deptId == item.deptId}">selected</c:if>>
                                                    ${item.deptnm}
                                            </option>
                                        </c:forEach>
                                    </select>

                                    <select class="form-select wide" id="srchSbjt" name="sbjctId">
                                        <option value="">운영과목</option> 
                                        <c:forEach var="item" items="${subjectList}">
                                            <option value="${item.sbjctId}"
                                                    <c:if test="${vo.sbjctId == item.sbjctId}">selected</c:if>>
                                                    ${item.sbjctnm}
                                                <c:if test="${not empty item.dvclasNo}"> (${item.dvclasNo}반)</c:if>
                                                <c:if test="${not empty item.crclmnNo}"> [${item.crclmnNo}]</c:if>
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <%-- 검색어 --%>
                            <div class="item">
                                <span class="item_tit">
                                    <label for="srchKeyword">
                                        <spring:message code="common.search.keyword"/> <%--  검색어 --%>
                                    </label>
                                </span>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" id="srchKeyword"
                                           name="searchKeyword"
                                           placeholder="과목명/과목코드/학과/교수명 입력" 
                                           value="<c:out value='${vo.searchKeyword}'/>">
                                </div>
                            </div>

                            <div class="button-area">
                                <button type="button" class="btn search" id="btnSearch">
                                    <spring:message code="button.search"/> <%-- 검색 --%>
                                </button>
                            </div>

                        </div>

                        <%-- 목록 헤더: 총건수 + 목록수 조절 --%>
                        <div class="board_top">
                            <h3 class="board-title">
                                운영과목 
                                <span class="total_num">
                                    <spring:message code="common.page.total"/> <%-- 총 --%>
                                    <strong id="totalCnt">0</strong>
                                    <spring:message code="common.page.total_count"/> <%-- 건 --%>
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
    var CTX        = "<%=request.getContextPath()%>";
    var PAGE_INDEX = 1;
    var LIST_SCALE = 20;
    var clsListTable = null;

    $(document).ready(function () {
        var ls = $("#listScale").val();
        if (ls) LIST_SCALE = parseInt(ls, 10);

        initClsListTable();
        changeSmstrChrt(); // 드롭다운 갱신 + 목록 최초 조회

        // 검색 버튼
        $("#btnSearch").on("click", function () {
            loadClsList(1);
        });

        // 학년도/학기/학위원/학과 변경 → 과목 드롭다운 갱신 + 목록 재조회
        $("#srchYear").on("change", function () {
            changeSmstrChrt();
        });

        $("#srchTerm, #srchOrg, #srchDept").on("change", function () {
            loadSubjectOptions(true);
        });

        // 과목 선택 → 즉시 목록 조회
        $("#srchSbjt").on("change", function () {
            loadClsList(1);
        });

        // 검색어 엔터
        $("#srchKeyword").on("keydown", function (e) {
            if (e.keyCode === 13) { e.preventDefault(); loadClsList(1); }
        });
    });

    /* =====================================================
       UiTable 초기화
       ===================================================== */
    function initClsListTable() {
        clsListTable = UiTable("clsListTable", {
            lang: "ko",
            pageFunc: clsListPaging,
            rowClick: function (e, row) {
                var data = row.getData();
                if (data.sbjctId) {
                    goDetail(data.sbjctId, data.dvclasNo, data.sbjctnm);
                }
            },
            columns: [
                { title: "<spring:message code='common.number.no'/>",          field: "lineNo",     headerHozAlign: "center", hozAlign: "center", width: 70,  minWidth: 70  }, <%-- 번호 --%>
                { title: "<spring:message code='common.year'/>",               field: "sbjctYr",    headerHozAlign: "center", hozAlign: "center", width: 80,  minWidth: 80  }, <%-- 년도 --%>
                { title: "<spring:message code='common.term'/>",               field: "sbjctSmstr", headerHozAlign: "center", hozAlign: "center", width: 60,  minWidth: 60  }, <%-- 학기 --%>
                { title: "기관",                                                field: "orgNm",      headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 100 }, 
                { title: "학과",                                                field: "deptnm",     headerHozAlign: "center", hozAlign: "left",   width: 150, minWidth: 150 }, 
                { title: "<spring:message code='crs.common.subject.code'/>",   field: "crclmnNo",   headerHozAlign: "center", hozAlign: "center", width: 110, minWidth: 110, formatter: "html" }, <%-- 과목코드 --%>
                { title: "<spring:message code='dashboard.course_name'/>",     field: "sbjctnm",    headerHozAlign: "center", hozAlign: "left",   width: 0,   minWidth: 220 }, <%-- 과목명 --%>
                { title: "분반",                                                field: "dvclasNo",   headerHozAlign: "center", hozAlign: "center", width: 70,  minWidth: 70  }, 
                { title: "학점",                                                field: "crdts",      headerHozAlign: "center", hozAlign: "center", width: 60,  minWidth: 60  }, 
                { title: "공동교수",                                            field: "coProfNm",   headerHozAlign: "center", hozAlign: "center", width: 110, minWidth: 110 }, 
                { title: "튜터",                                                field: "tutor",      headerHozAlign: "center", hozAlign: "center", width: 90,  minWidth: 90  }, 
                { title: "조교",                                                field: "asst",       headerHozAlign: "center", hozAlign: "center", width: 90,  minWidth: 90  }, 
                { title: "",                                                    field: "sbjctId",    visible: false }
            ]
        });
    }

    function clsListPaging(page) {
        loadClsList(page || 1);
    }

    /* =====================================================
       운영과목 목록 조회
       ===================================================== */
    function loadClsList(pageIndex) {
        PAGE_INDEX = pageIndex || 1;
        $("#pageIndex").val(PAGE_INDEX);
        $("#listScale").val(LIST_SCALE);

        UiComm.showLoading(true);

        $.ajax({
            url:      CTX + "/cls/selectClsListPaging.do",
            type:     "GET",
            dataType: "json",
            data: {
                searchYr:      $("#srchYear").val()    || "",
                smstrChrtId:   $("#srchTerm").val()    || "",
                searchOrgId:   $("#srchOrg").val()     || "",
                deptId:        $("#srchDept").val()    || "",
                sbjctId:       $("#srchSbjt").val()    || "",
                searchKeyword: $("#srchKeyword").val() || "",
                pageIndex:     PAGE_INDEX,
                listScale:     LIST_SCALE
            },
            success: function (data) {
                if (data && data.result > 0) {
                    var returnList = data.returnList || [];
                    var pageInfo   = data.pageInfo   || null;

                    clsListTable.replaceData(createClsListData(returnList));

                    if (pageInfo) {
                        clsListTable.setPageInfo(pageInfo);
                        $("#totalCnt").text(pageInfo.totalRecordCount || 0);
                    } else {
                        $("#totalCnt").text(returnList.length);
                    }
                } else {
                    clsListTable.setData([]);
                    $("#totalCnt").text("0");
                }
            },
            error: function (xhr, status, error) {
                console.error("[cls_list] 목록 조회 실패:", error);
                UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error");
                clsListTable.setData([]);
                $("#totalCnt").text("0");
            },
            complete: function () {
                UiComm.showLoading(false);
            }
        });
    }

    function createClsListData(list) {
        if (!list || list.length === 0) return [];

        return list.map(function (item) {
            var crclmnNoLink = '<a href="#_" class="link"'
                + ' onclick="goDetail(\'' + escapeJs(item.sbjctId)  + '\','
                +                    '\'' + escapeJs(item.dvclasNo) + '\','
                +                    '\'' + escapeJs(item.sbjctnm)  + '\');return false;">'
                + escapeHtml(item.crclmnNo || '')
                + '</a>';

            return {
                lineNo:     item.lineNo,
                sbjctYr:    item.sbjctYr,
                sbjctSmstr: (item.sbjctSmstr || "").toString().trim(),
                orgNm:      item.orgNm    || "-",
                deptnm:     item.deptnm   || "-",
                crclmnNo:   crclmnNoLink,
                sbjctnm:    item.sbjctnm  || "-",
                dvclasNo:   item.dvclasNo || "-",
                crdts:      item.crdts,
                coProfNm:   item.coProfNm || "-",
                tutor:      item.tutor    || "-",
                asst:       item.asst     || "-",
                sbjctId:    item.sbjctId
            };
        });
    }

    /* =====================================================
       상세 페이지 이동
       ===================================================== */
    function goDetail(sbjctId, dvclasNo, sbjctnm) {
        UiComm.showLoading(true);
        location.href = CTX + "/cls/selectClsStdntListView.do"
            + "?sbjctId="  + encodeURIComponent(sbjctId)
            + "&dvclasNo=" + encodeURIComponent(dvclasNo  || "")
            + "&sbjctnm="  + encodeURIComponent(sbjctnm   || "");
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
       과목 드롭다운 갱신
       triggerSearch: true 이면 드롭다운 갱신 후 목록도 재조회
       ===================================================== */
    function changeSmstrChrt() {
        var $term = $("#srchTerm");
        var currentValue = "${vo.smstrChrtId}";

        $term.empty();
        $term.append('<option value="">개설학기</option>');

        $.ajax({
            url: CTX + "/crs/termMgr/smstrListByDgrsYr.do",
            type: "GET",
            dataType: "json",
            data: {
                dgrsYr: $("#srchYear").val() || ""
            },
            success: function (data) {
                if (data && data.result > 0) {
                    var list = data.returnList || [];

                    list.forEach(function (item) {
                        var value = item.smstrChrtId || "";
                        var label = item.smstrChrtnm || "";

                        $term.append('<option value="' + escapeHtml(value) + '">' + escapeHtml(label) + '</option>');
                    });

                    if (currentValue && $term.find("option[value='" + currentValue + "']").length > 0) {
                        $term.val(currentValue);
                    } else {
                        $term.val("");
                    }
                } else {
                    $term.val("");
                }

                loadSubjectOptions(true);
            },
            error: function () {
                $term.val("");
                loadSubjectOptions(true);
            }
        });
    }

    function loadSubjectOptions(triggerSearch) {
        var currentValue = $("#srchSbjt").val() || "";

        $.ajax({
            url:      CTX + "/cls/selectClsSubjectList.do",
            type:     "GET",
            dataType: "json",
            data: {
                searchYr: $("#srchYear").val() || "",
                smstrChrtId: $("#srchTerm").val() || "",
                searchOrgId: $("#srchOrg").val() || "",
                deptId: $("#srchDept").val() || ""
            },
            success: function (data) {
                var list = (data && data.returnList) ? data.returnList : [];
                var $sbj = $("#srchSbjt");

                $sbj.empty();
                $sbj.append('<option value="">운영과목</option>');

                list.forEach(function (item) {
                    var value = item.sbjctId || "";
                    var label = item.sbjctnm || "";
                    if (item.dvclasNo) label += " (" + item.dvclasNo + "반)";
                    if (item.crclmnNo) label += " [" + item.crclmnNo + "]";

                    $sbj.append('<option value="' + escapeHtml(value) + '">' + escapeHtml(label) + '</option>');
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
            error: function () {
                if (triggerSearch) {
                    loadClsList(1);
                }
            }
        });
    }

    /* =====================================================
       유틸
       ===================================================== */
    function escapeHtml(v) {
        if (v == null) return "";
        return String(v)
            .replace(/&/g,  "&amp;")
            .replace(/</g,  "&lt;")
            .replace(/>/g,  "&gt;")
            .replace(/"/g,  "&quot;");
    }

    function escapeJs(v) {
        if (v == null) return "";
        return String(v)
            .replace(/\\/g, "\\\\")
            .replace(/'/g,  "\\'");
    }
</script>

</body>
</html>
