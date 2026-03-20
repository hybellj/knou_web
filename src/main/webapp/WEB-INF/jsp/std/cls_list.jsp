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

                    <!-- page-info / breadcrumb -->
                    <div class="page-info">
                        <h2 class="page-title">전체수업현황</h2>
                        <div class="navi_bar">
                            <ul>
                                <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                <li>강의</li>
                                <li><span class="current">전체수업현황</span></li>
                            </ul>
                        </div>
                    </div>

                    <!-- 검색 영역 -->
                    <form id="clsListForm" onsubmit="return false;">
                        <input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${empty vo.pageIndex ? 1 : vo.pageIndex}'/>"/>
                        <input type="hidden" id="listScale" name="listScale" value="<c:out value='${empty vo.listScale ? 20 : vo.listScale}'/>"/>
                        <input type="hidden" id="pageScale" name="pageScale" value="<c:out value='${empty vo.pageScale ? 10 : vo.pageScale}'/>"/>

                        <!-- 학년도/학기 + 운영과목 검색 -->
                        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><label for="srchYear">학년도/학기</label></span>
                                <div class="itemList">
                                    <% pageContext.setAttribute("currentYear", java.time.Year.now().getValue()); %>
                                    <c:set var="selectedYr" value="${empty vo.searchYr ? currentYear : vo.searchYr}"/>
                                    <c:set var="selectedSm" value="${empty vo.searchSmstr ? '1' : vo.searchSmstr}"/>

                                    <select class="form-select" id="srchYear" name="searchYr">
                                        <c:forEach var="year" begin="${currentYear - 3}" end="${currentYear}" step="1">
                                            <option value="${year}" <c:if test="${selectedYr == year.toString()}">selected</c:if>>${year}년</option>
                                        </c:forEach>
                                    </select>
                                    <select class="form-select" id="srchTerm" name="searchSmstr">
                                        <option value="1" <c:if test="${selectedSm == '1'}">selected</c:if>>1학기</option>
                                        <option value="2" <c:if test="${selectedSm == '2'}">selected</c:if>>2학기</option>
                                    </select>
                                </div>
                            </div>

                            <div class="item">
                                <span class="item_tit"><label for="srchSbjt">운영과목</label></span>
                                <div class="itemList">
                                    <select class="form-select" id="srchUniv" name="univGbn">
                                        <option value="">학위원</option>
                                        <option value="C" <c:if test="${vo.univGbn == 'C'}">selected</c:if>>학부</option>
                                        <option value="G" <c:if test="${vo.univGbn == 'G'}">selected</c:if>>대학원</option>
                                    </select>
                                    <select class="form-select" id="srchDept" name="deptId">
                                        <option value="">학과</option>
                                        <c:forEach var="item" items="${deptList}">
                                            <option value="${item.deptId}" <c:if test="${vo.deptId == item.deptId}">selected</c:if>>${item.deptnm}</option>
                                        </c:forEach>
                                    </select>
                                    <select class="form-select wide" id="srchSbjt" name="sbjctId">
                                        <option value="">운영과목</option>
                                        <c:forEach var="item" items="${subjectList}">
                                            <option value="${item.sbjctId}" <c:if test="${vo.sbjctId == item.sbjctId}">selected</c:if>>
                                                    ${item.sbjctnm}<c:if test="${not empty item.dvclasNo}"> (${item.dvclasNo}반)</c:if><c:if test="${not empty item.crclmnNo}"> [${item.crclmnNo}]</c:if>
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="item">
                                <span class="item_tit"><label for="srchKeyword">검색어</label></span>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" id="srchKeyword"
                                           name="searchKeyword" placeholder="과목명/과목코드/학과/교수명 입력"
                                           value="<c:out value='${vo.searchKeyword}'/>">
                                </div>
                            </div>

                            <div class="button-area">
                                <button type="button" class="btn search" id="btnSearch">검색</button>
                            </div>
                        </div>

                        <!-- 목록 헤더: 총건수 + 목록수 조절 -->
                        <div class="board_top">
                            <h3 class="board-title">
                                운영과목
                                <span class="total_num">총 <strong id="totalCnt">0</strong>건</span>
                            </h3>
                            <div class="right-area">
                                <uiex:listScale func="changeListScale" value="${empty vo.listScale ? 20 : vo.listScale}"/>
                            </div>
                        </div>
                    </form>

                    <!-- 목록 테이블 (UiTable 렌더링) -->
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
        initClsListTable();

        var ls = $("#listScale").val();
        if (ls) LIST_SCALE = parseInt(ls, 10);

        $("#btnSearch").on("click", function () {
            loadClsList(1);
        });

        // 학년도/학기/학위원/학과 변경 시 과목 드롭다운 갱신
        $("#srchYear, #srchTerm, #srchUniv, #srchDept").on("change", function () {
            loadSubjectOptions();
        });

        // 과목 선택 시 즉시 검색
        $("#srchSbjt").on("change", function () {
            loadClsList(1);
        });

        // 검색어 엔터
        $("#srchKeyword").on("keydown", function (e) {
            if (e.keyCode === 13) { e.preventDefault(); loadClsList(1); }
        });

        loadSubjectOptions();
    });

    /* ===========================
       UiTable 초기화
       =========================== */
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
                {title:"번호",     field:"lineNo",     headerHozAlign:"center", hozAlign:"center", width:70,  minWidth:70},
                {title:"년도",     field:"sbjctYr",    headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:80},
                {title:"학기",     field:"sbjctSmstr", headerHozAlign:"center", hozAlign:"center", width:60,  minWidth:60},
                {title:"기관",     field:"orgNm",      headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},
                {title:"학과",     field:"deptnm",     headerHozAlign:"center", hozAlign:"left",   width:150, minWidth:150},
                {title:"과목코드", field:"crclmnNo",   headerHozAlign:"center", hozAlign:"center", width:110, minWidth:110, formatter:"html"},
                {title:"과목명",   field:"sbjctnm",    headerHozAlign:"center", hozAlign:"left",   width:0,   minWidth:220},
                {title:"분반",     field:"dvclasNo",   headerHozAlign:"center", hozAlign:"center", width:70,  minWidth:70},
                {title:"학점",     field:"crdts",      headerHozAlign:"center", hozAlign:"center", width:60,  minWidth:60},
                {title:"공동교수",     field:"usernm",     headerHozAlign:"center", hozAlign:"center", width:110, minWidth:110},
                {title:"튜터",     field:"tutor",      headerHozAlign:"center", hozAlign:"center", width:90,  minWidth:90},
                {title:"조교",     field:"asst",       headerHozAlign:"center", hozAlign:"center", width:90,  minWidth:90},
                {title:"",         field:"sbjctId",    visible:false}
            ]
        });
    }

    function clsListPaging(page) {
        loadClsList(page || 1);
    }

    /* ===========================
       목록 조회
       =========================== */
    function loadClsList(pageIndex) {
        PAGE_INDEX = pageIndex || 1;
        $("#pageIndex").val(PAGE_INDEX);
        $("#listScale").val(LIST_SCALE);

        UiComm.showLoading(true);

        $.ajax({
            url: CTX + "/cls/selectClsListPaging.do",
            type: "GET",
            dataType: "json",
            data: {
                searchYr:      $("#srchYear").val()    || "",
                searchSmstr:   $("#srchTerm").val()    || "",
                univGbn:       $("#srchUniv").val()    || "",
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
                console.error("전체수업현황 목록 조회 실패:", error);
                UiComm.showMessage("에러가 발생했습니다!", "error");
                clsListTable.setData([]);
                $("#totalCnt").text("0");
            },
            complete: function () {
                UiComm.showLoading(false);
            }
        });
    }

    function createClsListData(list) {
        var dataList = [];
        if (!list || list.length === 0) return dataList;

        list.forEach(function (item) {
            var crclmnNoLink =
                '<a href="#_" class="link" '
                + 'onclick="goDetail(\'' + escapeJs(item.sbjctId) + '\',\''
                + escapeJs(item.dvclasNo) + '\',\''
                + escapeJs(item.sbjctnm) + '\');return false;">'
                + escapeHtml(item.crclmnNo || '')
                + '</a>';

            dataList.push({
                lineNo:     item.lineNo,
                sbjctYr:    item.sbjctYr,
                sbjctSmstr: (item.sbjctSmstr || "").toString().trim(),
                orgNm:      item.orgNm   || "-",
                deptnm:     item.deptnm,
                crclmnNo:   crclmnNoLink,
                sbjctnm:    item.sbjctnm,
                dvclasNo:   item.dvclasNo,
                crdts:      item.crdts,
                usernm:     item.usernm  || "-",
                tutor:      item.tutor   || "-",
                asst:       item.asst    || "-",
                sbjctId:    item.sbjctId
            });
        });

        return dataList;
    }

    /* ===========================
       상세 페이지 이동
       =========================== */
    function goDetail(sbjctId, dvclasNo, sbjctnm) {
        UiComm.showLoading(true);
        location.href = CTX + "/cls/selectClsStdntListView.do"
            + "?sbjctId="  + encodeURIComponent(sbjctId)
            + "&dvclasNo=" + encodeURIComponent(dvclasNo)
            + "&sbjctnm="  + encodeURIComponent(sbjctnm || "");
    }

    /* ===========================
       목록 수 변경
       =========================== */
    function changeListScale(scale) {
        LIST_SCALE = parseInt(scale || "20", 10);
        $("#listScale").val(LIST_SCALE);
        loadClsList(1);
    }

    /* ===========================
       과목 드롭다운 갱신
       =========================== */
    function loadSubjectOptions() {
        var currentValue = $("#srchSbjt").val() || "";

        $.ajax({
            url: CTX + "/cls/selectClsSubjectList.do",
            type: "GET",
            dataType: "json",
            data: {
                searchYr:    $("#srchYear").val() || "",
                searchSmstr: $("#srchTerm").val() || "",
                univGbn:     $("#srchUniv").val() || "",
                deptId:      $("#srchDept").val() || ""
            },
            success: function (data) {
                var list = (data && data.returnList) ? data.returnList : [];
                var html = ['<option value="">운영과목</option>'];

                list.forEach(function (item) {
                    var value = item.sbjctId || "";
                    var label = item.sbjctnm || "";
                    if (item.dvclasNo) label += " (" + item.dvclasNo + "반)";
                    if (item.crclmnNo) label += " [" + item.crclmnNo + "]";

                    html.push(
                        '<option value="' + escapeHtml(value) + '"'
                        + (currentValue === value ? " selected" : "")
                        + ">" + escapeHtml(label) + "</option>"
                    );
                });

                $("#srchSbjt").html(html.join(""));
                if ($("#srchSbjt").val() !== currentValue) {
                    $("#srchSbjt").val("");
                }
            },
            complete: function () {
                loadClsList(1);
            }
        });
    }

    function escapeHtml(v) {
        if (v === null || v === undefined) return "";
        return String(v)
            .replace(/&/g, "&amp;").replace(/</g, "&lt;")
            .replace(/>/g, "&gt;").replace(/"/g, "&quot;");
    }

    function escapeJs(v) {
        if (v === null || v === undefined) return "";
        return String(v).replace(/\\/g, "\\\\").replace(/'/g, "\\'");
    }
</script>

</body>
</html>