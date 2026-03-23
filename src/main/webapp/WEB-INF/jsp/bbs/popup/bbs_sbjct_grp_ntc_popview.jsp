<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="module" value="table"/>
    </jsp:include>

	<script type="text/javascript">
		var PAGE_INDEX      = '<c:out value="${bbsVO.pageIndex}" />';
	    var LIST_SCALE      = '<c:out value="${bbsVO.listScale}" />';
		var editor;         // 에디터 객체
	    var atclListTable;  // 테이블 객체

	    $(document).ready(function() {

	    	if(!PAGE_INDEX) {
				PAGE_INDEX = 1;
			}

	    	atclListTable = UiTable("bbsAtclGrpNtcList", {
                lang: "ko",
                pageFunc: listPaging,
                columns: [
                    {title:"No", field:"no", hozAlign:"center", width:40},
                    {title:"<spring:message code='bbs.label.dept'/>", field:"deptnm", hozAlign:"center", width:100},
                    {title:"<spring:message code='user.title.userinfo.manage.userrprsid'/>", field:"userRprsId", hozAlign:"left", minWidth:100},
                    {title:"<spring:message code='std.label.user_id'/>", field:"userId", hozAlign:"center", width:100},
                    {title:"<spring:message code='user.title.userinfo.manage.usernm'/>", field:"userNm", hozAlign:"center", width:100},
                    {title:"<spring:message code='sys.label.manage'/>", field:"mng", hozAlign:"center", width:60},
                ]
            });

	    	listPaging(1);
	    });

	    function listPaging(pageIndex) {
            PAGE_INDEX = pageIndex;
            var extData = { pageIndex: pageIndex, listScale: LIST_SCALE, bbsId: BBS_ID, atclId: ATCL_ID };
            var url = "/bbs/" + TEMPLATE_URL + "/bbsAtclGrpNtcList.do";
            var data = { eparam: EPARAM, extParam: UiComm.makeExtParam(extData) };

            ajaxCall(url, data, function(data) {
                if (data.eparam != null && data.eparam != '') { EPARAM = data.eparam; }
                if (data.result > 0) {
                    var dataList = createAtclListHTML(data.returnList || [], data.pageInfo);

                    atclListTable.clearData();
                    atclListTable.replaceData(dataList);
                    atclListTable.setPageInfo(data.pageInfo);
                } else {
                    UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error");
                }
            });
        };

	    function createAtclListHTML(atclList, pageInfo) {
            var dataList = [];
            atclList.forEach(function(v, i) {
                dataList.push({
                    no: i + 1,
                    deptnm: v.deptnm,
                    userId: v.userId,
                    userRprsId: v.userRprsId,
                    userNm: v.userNm,
                    mng: v.mng,
                    valAtclId: v.atclId
                });
            });
            return dataList;
        };
	</script>
</head>

<body class="home colorA "  style="">
	<div id="wrap" class="main">
        <main class="common">
            <div class="search-typeA">
               	<div class="item">
				    <span class="item_tit"><label for="sbjctYr">출석 미달자 검색</label></span>

				    <%-- 학년도 선택 --%>
				    <select class="ui dropdown" id="sbjctYr" onchange="changeSmstrChrt()">
				        <option value=""><spring:message code="crs.label.open.year" /></option>
				        <c:forEach var="item" items="${filterOptions.yearList}">
				            <option value="${item}" ${item eq defaultYear ? 'selected' : ''}>
				                ${item}
				            </option>
				        </c:forEach>
				    </select>
				</div>

				<div class="item">
				    <span class="item_tit"><label for="sbjctYr">학습요소 미참여 검색</label></span>

				    <%-- 학년도 선택 --%>
				    <select class="ui dropdown" id="sbjctYr" onchange="changeSmstrChrt()">
				        <option value=""><spring:message code="crs.label.open.year" /></option>
				        <c:forEach var="item" items="${filterOptions.yearList}">
				            <option value="${item}" ${item eq defaultYear ? 'selected' : ''}>
				                ${item}
				            </option>
				        </c:forEach>
				    </select>
				</div>

                <div class="item">
                    <span class="item_tit"><label for="selectCourse">학습그룹 팀 검색</label></span>

                    <select class="ui dropdown" id="orgId">
				        <option value=""><spring:message code="bbs.label.org" /></option>
				        <c:forEach var="list" items="${filterOptions.orgList}">
				            <option value="${list.orgId}">${list.orgnm}</option>
				        </c:forEach>
				    </select>

					<select class="ui dropdown" id="deptId">
				        <option value=""><spring:message code="bbs.label.dept" /></option>
				        <c:forEach var="list" items="${filterOptions.deptList}">
				            <option value="${list.deptId}">${list.deptnm}</option>
				        </c:forEach>
				    </select>

				    <select class="ui dropdown" id="sbjctId">
				        <option value=""><spring:message code="bbs.label.sbjct" /></option>
				        <c:forEach var="list" items="${filterOptions.sbjctList}">
				            <option value="${list.sbjctId}">${list.sbjctnm}</option>
				        </c:forEach>
				    </select>
                </div>

                <div class="item">
                    <span class="item_tit"><label for="searchValue"><spring:message code='common.search.keyword'/></label></span><%-- 검색어 --%>
                    <div class="itemList">
                        <input class="form-control wide" type="text" name="" id="searchValue" value="${param.searchValue}" placeholder="<spring:message code='bbs.common.placeholder'/>"><%-- 작성자/제목/키워드 --%>
                    </div>
                </div>
                <div class="button-area">
                    <button type="button" class="btn search" onclick="listPaging(1)"><spring:message code='button.search'/></button><%-- 검색 --%>
                </div>
            </div>

			<div id="bbsAtclGrpNtcList"></div>

        </main>
	</div>

</body>
</html>