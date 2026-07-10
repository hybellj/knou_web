<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>
    <script type="text/javascript">
        var ORG_ID = '<c:out value="${orgId}" />';
        var SBJCT_ID = '<c:out value="${contsExrcsQstnPageInfo.sbjctId}" />';
        var SEARCH_SBJCT_ID = '<c:out value="${contsExrcsQstnPageInfo.searchSbjctId}" />';
        var SMSTR_CHRT_ID = '<c:out value="${contsExrcsQstnPageInfo.smstrChrtId}" />';
        var YR_SMSTR_LIST = [];
        var PAGE_INDEX = 1;
        var LIST_SCALE = 10;

        $(document).ready(function() {
            fetchYrSmstrList(function() {
                selectAdmExrcsQstnList(1);
            });

            $("#searchValue").on("keydown", function(e) {
                if(e.keyCode == 13) {
                    selectAdmExrcsQstnList(1);
                }
            });

            $("#selectSbjctDvclas").val(SEARCH_SBJCT_ID || SBJCT_ID);
            $("#selectSbjctDvclas").trigger("chosen:updated");
        });

        // 연습문제 조회 조건의 년도/학기(기수) 목록을 구성한다.
        function fetchYrSmstrList(callback) {
            ajaxCall("/common/admYrSmstrSelect.do", {
                orgId: ORG_ID
            }, function(res) {
                if(res.result > 0) {
                    YR_SMSTR_LIST = res.returnList || [];
                }
                renderYrSmstrOptions();
                if($.isFunction(callback)) {
                    callback();
                }
            });
        }

        function renderYrSmstrOptions() {
            var html = '<option value=""><spring:message code="contents.label.all"/></option>'; /* 전체 */
            var selectedValue = SMSTR_CHRT_ID || "";
            YR_SMSTR_LIST.forEach(function(v) {
                var smstrChrtId = v.smstrChrtId || "";
                if(!selectedValue && (v.nowSmstryn || v.nowSmstrYn || "") == "Y") {
                    selectedValue = smstrChrtId;
                }
                html += '<option value="' + escapeHtml(smstrChrtId) + '">' + escapeHtml(v.yrSmstrnm || v.yrSmstrNm || "") + '</option>';
            });
            $("#selectYrSmstr").html(html);
            $("#selectYrSmstr").val(selectedValue);
            $("#selectYrSmstr").trigger("chosen:updated");
        }

        // 완료된 연습문제 목록을 조회한다.
        function selectAdmExrcsQstnList(pageIndex) {
            PAGE_INDEX = pageIndex || 1;
            ajaxCall("/contents/admConts/admLctrContsExrcsQstnList.do", {
                orgId: ORG_ID,
                sbjctId: SBJCT_ID,
                smstrChrtId: $("#selectYrSmstr").val(),
                searchSbjctId: $("#selectSbjctDvclas").val(),
                dvclasNo: $("#selectSbjctDvclas option:selected").data("dvclasNo") || "",
                searchValue: $("#searchValue").val(),
                currentPageNo: PAGE_INDEX,
                recordCountPerPage: LIST_SCALE,
                pageSize: 10
            }, function(res) {
                if(res.result > 0) {
                    var dataList = createExrcsQstnListData(res.returnList || [], res.pageInfo);
                    exrcsQstnListTable.clearData();
                    exrcsQstnListTable.replaceData(dataList);
                    exrcsQstnListTable.setPageInfo(res.pageInfo);
                } else {
                    UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>", "error"); /* 에러가 발생했습니다! */
                }
            }, function() {
                UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error"); /* 에러가 발생했습니다! */
            });
        }

        function createExrcsQstnListData(list, pageInfo) {
            var dataList = [];
            (list || []).forEach(function(item) {
                var row = {};
                row.no = pageInfo.totalRecordCount - item.lineNo + 1;
                row.dgrsYr = escapeHtml(item.dgrsYr || "-");
                row.dgrsSmstrChrt = escapeHtml(item.dgrsSmstrChrt || "-");
                row.sbjctnm = escapeHtml(item.sbjctnm || "-");
                row.dvclasNo = escapeHtml(item.dvclasNo || "-");
                row.qstnTtl = escapeHtml(item.qstnTtl || "-");
                row.select = '<button type="button" class="btn basic small" onclick="chooseExrcsQstn(\'' + escapeJs(item.exrcsSddnQstnBscId || "") + '\', \'' + escapeJs(item.qstnTtl || "") + '\')"><spring:message code="sys.button.select"/></button>'; /* 선택 */
                dataList.push(row);
            });
            return dataList;
        }

        function chooseExrcsQstn(exrcsSddnQstnBscId, qstnTtl) {
            if(window.parent && window.parent !== window && typeof window.parent.selectExrcsQstn === "function") {
                window.parent.selectExrcsQstn({
                    exrcsSddnQstnBscId: exrcsSddnQstnBscId,
                    qstnTtl: qstnTtl
                });
            }
        }

        function escapeHtml(value) {
            return String(value == null ? "" : value)
                    .replace(/&/g, "&amp;")
                    .replace(/</g, "&lt;")
                    .replace(/>/g, "&gt;")
                    .replace(/"/g, "&quot;")
                    .replace(/'/g, "&#39;");
        }

        function escapeJs(value) {
            return String(value == null ? "" : value)
                    .replace(/\\/g, "\\\\")
                    .replace(/'/g, "\\'")
                    .replace(/\r/g, "")
                    .replace(/\n/g, " ");
        }
    </script>
</head>
<body class="modal-page">
    <div class="wrap">
        <div class="board_top in_table">
            <div class="search_box">
                <select class="form-select w200 chosen" id="selectYrSmstr" title="<spring:message code='crs.label.year.term.cohort'/><%--년도/학기(기수)--%> <spring:message code='sys.button.select'/><%--선택--%>"></select>
                <select class="form-select w250 chosen" id="selectSbjctDvclas" title="<spring:message code='common.label.decls.no'/><%--분반--%> <spring:message code='sys.button.select'/><%--선택--%>">
                    <c:forEach var="dvclas" items="${sbjctDvclasList}">
                        <option value="${dvclas.sbjctId}" data-dvclas-no="${dvclas.dvclasNo}" <c:if test="${dvclas.sbjctId eq contsExrcsQstnPageInfo.searchSbjctId}">selected="selected"</c:if>>
                            <c:out value="${dvclas.sbjctnm}"/> <c:out value="${dvclas.dvclasNo}"/><spring:message code="common.label.decls.no"/><%--분반--%>
                        </option>
                    </c:forEach>
                </select>
                <div class="search-typeC">
                <input type="text" class="form-control w250" id="searchValue" placeholder="<spring:message code='contents.placeholder.exercise.test.paper.title'/>"/>
                <button type="button" class="btn basic icon search" onclick="selectAdmExrcsQstnList(1);" aria-label="검색"><i class="icon-svg-search"></i></button>
                </div>
            </div>
        </div>

        <div id="exrcsQstnList"></div>
        <script type="text/javascript">
            var exrcsQstnListTable = UiTable("exrcsQstnList", {
                lang: "ko",
                pageFunc: selectAdmExrcsQstnList,
                columns: [
                    {title:"<spring:message code='contents.label.number'/>" /* 번호 */, field:"no", headerHozAlign:"center", hozAlign:"center", width:60, minWidth:50},
                    {title:"<spring:message code='contents.label.year'/>" /* 년도 */, field:"dgrsYr", headerHozAlign:"center", hozAlign:"center", width:90, minWidth:80},
                    {title:"<spring:message code='contents.label.semester'/>" /* 학기 */, field:"dgrsSmstrChrt", headerHozAlign:"center", hozAlign:"center", width:90, minWidth:80},
                    {title:"<spring:message code='contents.label.subject.name'/>" /* 과목명 */, field:"sbjctnm", headerHozAlign:"center", hozAlign:"left", width:180, minWidth:150},
                    {title:"<spring:message code='common.label.decls.no'/>" /* 분반 */, field:"dvclasNo", headerHozAlign:"center", hozAlign:"center", width:80, minWidth:70},
                    {title:"<spring:message code='contents.label.exercise.test.paper.title'/>" /* 연습문제 시험지 제목 */, field:"qstnTtl", headerHozAlign:"center", hozAlign:"left", width:0, minWidth:240},
                    {title:"<spring:message code='sys.button.select'/>" /* 선택 */, field:"select", headerHozAlign:"center", hozAlign:"center", width:90, minWidth:80}
                ]
            });
        </script>

        <div class="btns">
            <button type="button" class="btn type2" onclick="if(window.parent && window.parent.closeExrcsQstnListPop){window.parent.closeExrcsQstnListPop();}"><spring:message code="common.button.close"/><%--닫기--%></button>
        </div>
    </div>
</body>
</html>
