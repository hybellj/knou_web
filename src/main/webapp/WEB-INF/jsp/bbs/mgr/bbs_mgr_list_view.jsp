<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>

    <!-- 게시판 공통 -->
    <jsp:include page="/WEB-INF/jsp/bbs/common/bbs_common_inc.jsp"/>

    <script type="text/javascript">
        var ORG_ID       = '<c:out value="${bbsVO.orgId}" />';
        var BBS_ID       = '<c:out value="${bbsVO.bbsId}" />';
        var BBS_TYCD     = '<c:out value="${bbsVO.bbsTycd}" />';
        var BBS_REF_TYCD = '<c:out value="${bbsVO.bbsRefTycd}" />';
        var PAGE_INDEX   = '<c:out value="${bbsVO.pageIndex}" />';
        var TEMPLATE_URL = '<c:out value="${templateUrl}" />';
        var LIST_SCALE   = '<c:out value="${bbsVO.listScale}" />';
        var EPARAM       = '<c:out value="${encParams}" />';

        var ATCL_LV = 1;

        $(document).ready(function() {

            // 년도/학기 변경 시 재조회
            $("#sbjctYr, #sbjctSmstr").on("change", function() {
                listPaging(1);
            });

            // 검색어 입력창에서 Enter
            $("#searchValue").on("keydown", function(e) {
                if(e.keyCode == 13) {
                    e.preventDefault();
                    listPaging(1);
                }
            });

            if(!PAGE_INDEX) {
                PAGE_INDEX = 1;
            }

            if(!TEMPLATE_URL) {
                TEMPLATE_URL = 'bbsMgr';
            }

            // 페이지 로딩 시 목록 조회
            listPaging(PAGE_INDEX);
        });

        /* 검색 버튼 클릭 */
        function goSearch(pageIndex) {
            listPaging(pageIndex);
        }

        /* 게시글(공지) 목록 조회 */
        function listPaging(pageIndex) {
        	if(ORG_ID == 'SYSTEM_DEFAULT') {
				bbsTycd = 'SYS_NTC';
			} else {
				bbsTycd = BBS_TYCD;
			}

            var extData = {
                  orgId       : ORG_ID
                , bbsId       : BBS_ID
                , bbsTycd     : bbsTycd
                , bbsRefTycd  : BBS_REF_TYCD
                , atclLv      : ATCL_LV
                , sbjctYr     : $("#sbjctYr").val()    || ''
                , sbjctSmstr  : $("#sbjctSmstr").val() || ''
                , searchValue : $("#searchValue").val() || ''
                , pageIndex   : pageIndex
                , listScale   : LIST_SCALE
            };

            var url = "/bbs/" + TEMPLATE_URL + "/admBbsAtclListAjax.do";
            var param = {
                  encParams : EPARAM
                , addParams : UiComm.makeEncParams(extData)
            };

            UiComm.showLoading(true);

            ajaxCall(url, param, function(data) {

                if(data.encParams != null && data.encParams != '') {
                    EPARAM = data.encParams;
                }

                if(data.result > 0) {
                    var returnList = data.returnList || [];
                    var dataList   = createAtclListHTML(returnList, data.pageInfo);

                    atclListTable.clearData();
                    atclListTable.replaceData(dataList);
                    atclListTable.setPageInfo(data.pageInfo);
                } else {
                    atclListTable.setData([]);
                }
            }, function(xhr, status, error) {
                UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error"); // 에러가 발생했습니다!
                atclListTable.setData([]);
            }, true);
        }

        /* 목록 데이터 생성 (Tabulator용) */
        function createAtclListHTML(atclList, pageInfo) {
            var dataList = [];

            if(!atclList || atclList.length == 0) {
                return dataList;
            }

            atclList.forEach(function(v, i) {
                var lineNo = pageInfo.totalRecordCount - v.lineNo + 1;

                // 고정 / 중요 라벨
                var isLabelAtcl = v.optnCd == "FIX" || v.optnCd == "IMPT";
                var colLabel = "";
                var col0     = lineNo;

                if(isLabelAtcl) {
                    if(v.optnCd == "FIX") {
                        colLabel = '<label class="label s_c01"><spring:message code="bbs.label.fix" /></label>';  // 고정
                    } else {
                        colLabel = '<label class="label s_c02"><spring:message code="bbs.label.impt" /></label>'; // 중요
                    }
                    col0 = colLabel;
                }

                // 제목 링크 + 신규 아이콘
                var atclTtl = (v.atclTtl || "").replaceAll("<", "&lt;").replaceAll(">", "&gt;");
                var newIcon = (v.isNew == "Y") ? ' <i class="xi-new icon" aria-hidden="true"></i>' : '';
                var title   = '<a href="javascript:void(0);" onclick="viewAtcl(\'' + v.atclId + '\')" class="link">' + atclTtl + newIcon + '</a>';

                // 첨부 아이콘
                var attach = (v.fileCnt > 0) ? "<i class='icon-svg-paperclip' aria-hidden='true'></i>" : "";

                dataList.push({
                    no        : col0,
                    atclTtl   : title,
                    regDttm   : v.regDttm,
                    rgtrnm    : v.rgtrnm,
                    inqCnt    : v.inqCnt,
                    cmntCnt   : v.cmntCnt,
                    attach    : attach,
                    valAtclId : v.atclId,
                    label     : colLabel
                });
            });

            return dataList;
        }

        /* 상세보기 이동 */
        function viewAtcl(atclId) {
            UiComm.showLoading(true);
            var extData = {
                  atclId     : atclId
                , bbsTycd    : BBS_TYCD
                , bbsRefTycd : BBS_REF_TYCD
            };

            document.location.href = "/bbs/" + TEMPLATE_URL + "/admBbsAtclView.do?encParams=" + EPARAM + "&addParams=" + UiComm.makeEncParams(extData);
        }

        /* 글쓰기 이동 */
        function moveWriteAtcl() {
            document.location.href = "/bbs/" + TEMPLATE_URL + "/admBbsAtclWrite.do?encParams=" + EPARAM;
        }

        /* 목록 건수 변경 */
        function changeListScale(scale) {
            LIST_SCALE = scale;
            listPaging(1);
        }
    </script>
</head>

<body class="admin">
<div id="wrap" class="main">

    <!-- 공통 메뉴 이동(moveMenu)용 폼 -->
    <form id="moveForm" method="post"></form>

    <!-- common header -->
    <jsp:include page="/WEB-INF/jsp/common_new/admin_header.jsp"/>
    <!-- //common header -->

    <main class="common">
        <!-- gnb -->
        <jsp:include page="/WEB-INF/jsp/common_new/admin_aside.jsp"/>
        <!-- //gnb -->

        <div id="content" class="content-wrap common">
            <div class="admin_sub">
                <div class="sub-content">

                    <div class="page-info">
                        <h2 class="page-title">${bbsVO.bbsNm}</h2> <%-- 현재 메뉴명 --%>
                        <uiex:navibar type="admin"/> <%-- 네비게이션바 --%>
                    </div>

                    <!-- 검색 영역: 년도/학기 + 검색어 -->
                    <div class="search-typeA">
                        <div class="item">
                            <span class="item_tit"><label for="sbjctYr">년도/학기</label></span>
                            <div class="itemList">
                                <%-- 학년도 --%>
                                <select class="form-select mr5" id="sbjctYr" name="sbjctYr" title="학년도">
                                    <option value=""><spring:message code="crs.label.open.year" /></option>
                                    <c:forEach var="item" items="${filterOptions.yearList}">
                                        <option value="${item}" ${item eq defaultYear ? 'selected' : ''}>${item}</option>
                                    </c:forEach>
                                </select>
                                <%-- 개설학기 --%>
                                <select class="form-select" id="sbjctSmstr" name="sbjctSmstr" title="개설학기">
                                    <option value=""><spring:message code="crs.label.open.term" /></option>
                                    <c:forEach var="list" items="${filterOptions.smstrChrtList}">
                                        <option value="${list.smstrChrtId}" ${list.dgrsSmstrChrt eq defaultTerm ? 'selected' : ''}>${list.smstrChrtnm}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit"><label for="searchValue">검색어</label></span>
                            <div class="itemList">
                                <input class="form-control wide"
                                       type="text"
                                       id="searchValue"
                                       name="searchValue"
                                       value="${fn:escapeXml(param.searchValue)}"
                                       placeholder="작성자/제목 입력" />
                            </div>
                        </div>
                        <div class="button-area">
                            <button type="button" class="btn search" onclick="goSearch(1);">검색</button>
                        </div>
                    </div>

                    <!-- 목록 영역 -->
                    <div id="atclListArea">
                        <div class="board_top">
                            <h3 class="board-title">${bbsVO.bbsNm}</h3>
                            <div class="right-area">
                                <button type="button" class="btn type1" style="white-space:nowrap;" onclick="moveWriteAtcl();">글쓰기</button>
                                <%-- 목록 스케일 선택 --%>
                                <uiex:listScale func="changeListScale" value="${bbsVO.listScale}" />
                            </div>
                        </div>

                        <%-- 게시글(공지) 리스트 (tabulator) --%>
                        <div id="atclList"></div>

                        <script>
                        var atclListTable = UiTable("atclList", {
                            lang: "ko",
                            pageFunc: listPaging,
                            columns: [
                                {title:"No",     field:"no",        headerHozAlign:"center", hozAlign:"center", width:80,    minWidth:60,  formatter:"html"},
                                {title:"<spring:message code='bbs.label.form_title'/>",    field:"atclTtl",   headerHozAlign:"center", hozAlign:"left",   widthGrow:4, minWidth:200, formatter:"html"},
                                {title:"<spring:message code='bbs.label.reg_user'/>",      field:"rgtrnm",    headerHozAlign:"center", hozAlign:"center", width:100,   minWidth:100},
                                {title:"<spring:message code='bbs.label.reg_date'/>",      field:"regDttm",   headerHozAlign:"center", hozAlign:"center", width:120,   minWidth:100, formatter:"date"},
                                {title:"<spring:message code='bbs.label.hit'/>",           field:"inqCnt",    headerHozAlign:"center", hozAlign:"center", width:70,    minWidth:60},
                                {title:"<spring:message code='bbs.label.comment'/>",       field:"cmntCnt",   headerHozAlign:"center", hozAlign:"center", width:70,    minWidth:60},
                                {title:"<spring:message code='bbs.label.attach'/>",        field:"attach",    headerHozAlign:"center", hozAlign:"center", width:70,    minWidth:60,  formatter:"html"},
                                {title:"",       field:"valAtclId", visible:false}
                            ]
                        });
                        </script>
                    </div>

                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>
