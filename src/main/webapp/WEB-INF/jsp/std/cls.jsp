<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="dashboard"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>

    <script type="text/javascript">
        var CTX = "<%=request.getContextPath()%>";

        var PAGE_INDEX = 1;
        var LIST_SCALE = 20;

        $(document).ready(function () {

            var ls = $("#listScale").val();
            if (ls) LIST_SCALE = parseInt(ls, 10);

            $("#btnSearch").on("click", function () {
                loadClsList(1);
            });

            $("#srchYear, #srchTerm, #srchUniv, #srchDept").on("change", function () {
                loadSubjectOptions(true);
            });

            $("#srchSbjt").on("change", function () {
                loadClsList(1);
            });

            loadSubjectOptions(false);
        });

        function clsListPaging(page) {
            loadClsList(page || 1);
        }

        function loadClsList(pageIndex) {
            PAGE_INDEX = pageIndex || 1;

            $("#pageIndex").val(PAGE_INDEX);
            $("#listScale").val(LIST_SCALE);

            var url   = CTX + "/cls/selectClsListPaging.do";
            var param = {
                searchYr:      $("#srchYear").val() || "",
                searchSmstr:   $("#srchTerm").val() || "",
                univGbn:       $("#srchUniv").val() || "",
                deptId:        $("#srchDept").val() || "",
                sbjctId:       $("#srchSbjt").val() || "",
                pageIndex:     PAGE_INDEX,
                listScale:     LIST_SCALE
            };

            UiComm.showLoading(true);

            $.ajax({
                url:      url,
                type:     "GET",
                data:     param,
                dataType: "json",
                success: function (data) {
                    if (data && data.result > 0) {
                        var returnList = data.returnList || [];
                        var pageInfo   = data.pageInfo   || null;

                        var tableData = createClsListData(returnList);

                        clsListTable.clearData();
                        clsListTable.replaceData(tableData);
                        if (pageInfo) clsListTable.setPageInfo(pageInfo);

                        if (pageInfo) {
                            $("#totalCnt").text(pageInfo.totalRecordCount || 0);
                            $("#totalCnt2").text(pageInfo.totalRecordCount || 0);
                            $("#curPage").text(pageInfo.currentPageNo || 1);
                            $("#totalPage").text(pageInfo.totalPageCount || 1);
                        } else {
                            $("#totalCnt").text(returnList.length);
                            $("#totalCnt2").text(returnList.length);
                            $("#curPage").text(PAGE_INDEX);
                            $("#totalPage").text(1);
                        }
                    } else {
                        clsListTable.setData([]);
                        $("#totalCnt").text("0");
                        $("#totalCnt2").text("0");
                        $("#curPage").text("1");
                        $("#totalPage").text("1");
                    }
                },
                error: function (xhr, status, error) {
                    console.error("전체수업현황 목록 조회 실패:", error);
                    UiComm.showMessage("에러가 발생했습니다!", "error");
                    clsListTable.setData([]);
                    $("#totalCnt").text("0");
                    $("#totalCnt2").text("0");
                    $("#curPage").text("1");
                    $("#totalPage").text("1");
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
                var smstr = (item.sbjctSmstr || "").toString().trim();

                var crclmnNoLink =
                    '<a href="#_" class="fcRed" ' +
                    'onclick="goDetail(\'' + escapeJs(item.sbjctId) + '\', \'' + escapeJs(item.dvclasNo) + '\');return false;">' +
                    escapeHtml(item.crclmnNo || '') + '</a>';

                dataList.push({
                    lineNo:     item.lineNo,
                    sbjctYr:    item.sbjctYr,
                    sbjctSmstr: smstr,
                    orgNm:      item.orgNm || '-',
                    deptnm:     item.deptnm,
                    crclmnNo:   crclmnNoLink,
                    sbjctnm:    item.sbjctnm,
                    dvclasNo:   item.dvclasNo,
                    crdts:      item.crdts,
                    usernm:     item.usernm,
                    tutor:      "",
                    asst:       "",
                    sbjctId:    item.sbjctId
                });
            });

            return dataList;
        }

        function escapeHtml(v) {
            if (v === null || v === undefined) return "";
            return String(v)
                .replace(/&/g, "&amp;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;")
                .replace(/"/g, "&quot;");
        }

        function goDetail(sbjctId, dvclasNo) {
            UiComm.showLoading(true);
            location.href = CTX + "/cls/selectClsStdntListView.do?sbjctId=" + encodeURIComponent(sbjctId)
                + "&dvclasNo=" + encodeURIComponent(dvclasNo);
        }

        function escapeJs(v) {
            if (v === null || v === undefined) return "";
            return String(v).replace(/\\/g, "\\\\").replace(/'/g, "\\'");
        }

        function changeListScale(scale) {
            LIST_SCALE = parseInt(scale || "20", 10);
            $("#listScale").val(LIST_SCALE);
            loadClsList(1);
        }

        function loadSubjectOptions(loadListAfter) {
            var currentValue = $("#srchSbjt").val() || "";

            $.ajax({
                url: CTX + "/cls/selectClsSubjectList.do",
                type: "GET",
                dataType: "json",
                data: {
                    searchYr: $("#srchYear").val() || "",
                    searchSmstr: $("#srchTerm").val() || "",
                    univGbn: $("#srchUniv").val() || "",
                    deptId: $("#srchDept").val() || ""
                },
                success: function (data) {
                    var list = (data && data.returnList) ? data.returnList : [];
                    var html = ['<option value="">운영과목</option>'];

                    list.forEach(function (item) {
                        var value = item.sbjctId || "";
                        var label = (item.sbjctnm || "");
                        if (item.dvclasNo) {
                            label += " (" + item.dvclasNo + "반)";
                        }
                        if (item.crclmnNo) {
                            label += " [" + item.crclmnNo + "]";
                        }

                        html.push(
                            '<option value="' + escapeHtml(value) + '"' +
                            (currentValue === value ? ' selected' : '') +
                            '>' + escapeHtml(label) + '</option>'
                        );
                    });

                    $("#srchSbjt").html(html.join(""));
                    if ($("#srchSbjt").val() !== currentValue) {
                        $("#srchSbjt").val("");
                    }
                },
                complete: function () {
                    if (loadListAfter !== false) {
                        loadClsList(1);
                    } else {
                        loadClsList(1);
                    }
                }
            });
        }
    </script>
</head>

<%-- ✅ FIX 1: style="" 추가 (공통 규격 맞춤) --%>
<body class="home colorA" style="">
<div id="wrap" class="main">

    <!-- common header -->
    <%-- ✅ FIX 2: include 방식 bbs 페이지 기준으로 <%@ include file %> 로 원복 --%>
    <%@ include file="/WEB-INF/jsp/common_new/home_header.jsp" %>
    <!-- //common header -->

    <main class="common">

        <!-- gnb -->
        <%@ include file="/WEB-INF/jsp/common_new/home_gnb_prof.jsp" %>
        <!-- //gnb -->

        <!-- content -->
        <div id="content" class="content-wrap common">
            <div class="dashboard_sub">

                <!-- page_tab -->
                <%@ include file="/WEB-INF/jsp/common_new/home_page_tab.jsp" %>
                <!-- //page_tab -->

                <div class="sub-content">
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

                    <form id="clsListForm" onsubmit="return false;">
                        <input type="hidden" id="pageIndex" name="pageIndex" value="<c:out value='${empty vo.pageIndex ? 1 : vo.pageIndex}'/>"/>
                        <input type="hidden" id="listScale" name="listScale" value="<c:out value='${empty vo.listScale ? 20 : vo.listScale}'/>"/>
                        <input type="hidden" id="pageScale" name="pageScale" value="<c:out value='${empty vo.pageScale ? 10 : vo.pageScale}'/>"/>

                        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><label for="srchYear">학년도/학기</label></span>
                                <div class="itemList">
                                    <c:set var="currentYear" value="<%= java.time.Year.now().getValue() %>" />
                                    <c:set var="selectedYr"  value="${empty vo.searchYr    ? currentYear : vo.searchYr}" />
                                    <c:set var="selectedSm"  value="${empty vo.searchSmstr ? '1'         : vo.searchSmstr}" />

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

                                    <select class="form-select" id="srchSbjt" name="sbjctId">
                                        <option value="">운영과목</option>
                                        <c:forEach var="item" items="${subjectList}">
                                            <option value="${item.sbjctId}" <c:if test="${vo.sbjctId == item.sbjctId}">selected</c:if>>
                                                ${item.sbjctnm}<c:if test="${not empty item.dvclasNo}"> (${item.dvclasNo}반)</c:if><c:if test="${not empty item.crclmnNo}"> [${item.crclmnNo}]</c:if>
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="button-area">
                                <button type="button" class="btn search" id="btnSearch">검색</button>
                            </div>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title">
                                운영과목
                                <span class="note2">[총 건수 : <b id="totalCnt">0</b>건]</span>
                            </h3>
                            <div class="right-area">
                                <uiex:listScale func="changeListScale" value="${empty vo.listScale ? 20 : vo.listScale}" />
                            </div>
                        </div>
                    </form>

                    <div id="clsListTable"></div>

                    <script type="text/javascript">
                        let clsListTable = UiTable("clsListTable", {
                            lang: "ko",
                            pageFunc: clsListPaging,
                            rowClick: function(e, row) {
                                var data = row.getData();
                                if (data.sbjctId) {
                                    goDetail(data.sbjctId, data.dvclasNo);
                                }
                            },
                            columns: [
                                {title:"번호",    field:"lineNo",    headerHozAlign:"center", hozAlign:"center", width:70,  minWidth:70},
                                {title:"년도",    field:"sbjctYr",   headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:80},
                                {title:"학기",    field:"sbjctSmstr",headerHozAlign:"center", hozAlign:"center", width:60,  minWidth:60},
                                {title:"기관",    field:"orgNm",     headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},
                                {title:"학과",    field:"deptnm",    headerHozAlign:"center", hozAlign:"left",   width:150, minWidth:150},
                                {title:"과목코드", field:"crclmnNo",  headerHozAlign:"center", hozAlign:"center", width:110, minWidth:110, formatter:"html"},
                                {title:"과목명",  field:"sbjctnm",   headerHozAlign:"center", hozAlign:"left",   width:0,   minWidth:220},
                                {title:"분반",    field:"dvclasNo",  headerHozAlign:"center", hozAlign:"center", width:70,  minWidth:70},
                                {title:"학점",    field:"crdts",     headerHozAlign:"center", hozAlign:"center", width:60,  minWidth:60},
                                {title:"공동교수", field:"usernm",    headerHozAlign:"center", hozAlign:"center", width:110, minWidth:110},
                                {title:"튜터",    field:"tutor",     headerHozAlign:"center", hozAlign:"center", width:90,  minWidth:90},
                                {title:"조교",    field:"asst",      headerHozAlign:"center", hozAlign:"center", width:90,  minWidth:90},
                                {title:"",        field:"sbjctId",   visible:false},
                                {title:"",        field:"dvclasNo",  visible:false}
                            ]
                        });
                    </script>

                    <div class="board_foot">
                        <div class="page_info">
                            <span class="total_page">전체 <b id="totalCnt2">0</b>건</span>
                            <span class="current_page">현재 페이지 <strong id="curPage">1</strong>/<span id="totalPage">1</span></span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- //content -->

        <!-- common footer -->
        <%-- ✅ FIX 3: footer를 </main> 닫기 전 안쪽으로 이동 (bbs 페이지와 동일한 구조) --%>
        <%@ include file="/WEB-INF/jsp/common_new/home_footer.jsp" %>
        <!-- //common footer -->

    </main>
    <!-- //dashboard -->

</div>
</body>
</html>

