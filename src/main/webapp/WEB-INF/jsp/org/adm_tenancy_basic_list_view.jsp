<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="table"/>
	</jsp:include>
</head>
<script type="text/javascript">
    let LIST_SCALE = '<c:out value="${vo.listScale}" />';
    let PAGE_INDEX = '<c:out value="${vo.pageIndex}" />';
    let EPARAM = '<c:out value="${encParams}" />';

    // list scale 변경
    function changeListScale(scale) {
        LIST_SCALE = scale;
        listPaging(1);
    }
</script>

<body class="admin">
    <div id="wrap" class="main">
        <!-- common header -->
        <%@ include file="/WEB-INF/jsp/common_new/admin_header.jsp" %>
        <!-- //common header -->

        <!-- admin -->
        <main class="common">

            <!-- gnb -->
            <%@ include file="/WEB-INF/jsp/common_new/admin_aside.jsp" %>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <%--<!-- 상단(주차/기간): 공통 규격 유지 -->
		            <div class="admin_sub_top">
		                <div class="date_info">
		                    <i class="icon-svg-calendar" aria-hidden="true"></i>
		                    <c:choose>
		                        <c:when test="${not empty weekInfo}">
		                            ${weekInfo}
		                        </c:when>
		                        <c:otherwise>
		                            2025년 2학기 7주차 : 2025.10.05 (월) ~ 2025.10.16 (목)
		                            <!-- 미정이라 샘플코드랑 동일하게 -->
		                        </c:otherwise>
		                    </c:choose>
		                </div>
		            </div>       --%>

					<div class="admin_sub">
                    <div class="sub-content">
                        <div class="page-info">
							<h2 class="page-title"><%= AdminMenuInfo.getMenu(menuId).getMenunm()%></h2> <%-- 현재 메뉴명 --%>
                        	<uiex:navibar type="admin"/><%-- 네비게이션바 --%>
                        </div>

                        <!-- search typeA -->
                        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><label for="selectSearch">검색어</label></span>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" name="searchValue" id="searchValue" value="" placeholder="기관ID / 기관명 / 담당자입력">
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="listPaging(1)">검색</button>
                            </div>
                        </div>

                        <!-- board top -->
                        <div class="board_top">
                            <h3 class="board-title"><spring:message code="common.button.list"/><%-- 목록 --%> </h3> <small>[ <spring:message code="common.page.total.cnt"/> : <span id="totCnt">0</span> <spring:message code="common.page.total_count"/>]</small>
                            <div class="right-area">
                                <button type="button" class="btn type2" onclick="moveToRegist()"><spring:message code="common.button.create"/><%--등록--%></button>
                                <uiex:listScale func="changeListScale" value="${vo.listScale}" />
                            </div>
                        </div>

                        <!--table-type-->
                        <div class="table-wrap">
                            <div id="orgList"> </div>


	                        <%-- 테이블의 페이징 정보 생성할때 아래 내용 참조하여 작업하고 아래와 같은 HTML 코드를 직접 만들지 않는다.
	                        	1) UiTable() 함수를 사용하여 테이블 생성할경우는 해당 프로그램에서 페이지 정보 생성하도록 한다.
	                        	2) Controller에서 페이지정보(PageInfo) 객체를 받아을 경우 <uiex:paging> 태그를 사용하여 생성한다.
	                        	   <uiex:paging pageInfo="${pageInfo}" pageFunc="listPaging"/>
	                        --%>
	                        <!-- board foot -->

                        </div>
                        <script type="text/javascript">
                            let orgListTable;

                            $(function () {
                                let cols = [
                                    {title: "<spring:message code='common.no'/>", field: "no", headerHozAlign:"center", hozAlign:"center", width: 50, minWidth: 50},
                                    {title: "<spring:message code='common.label.org.id'/>",  field: "orgId", headerHozAlign: "center", hozAlign: "center", width: 130, minWidth: 130},
                                    {title: "<spring:message code='common.label.org.name.full'/>",  field: "orgnm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 150},
                                    {title: "<spring:message code='common.label.org.name.short'/>", field: "orgShrtnm", headerHozAlign:"center", hozAlign:"center", width: 150, minWidth: 150},
                                    {title: "<spring:message code='common.label.org.type'/>",field: "orgTycd",headerHozAlign: "center", hozAlign: "center", width: 180, minWidth: 180},
                                    {title: "<spring:message code='common.label.org.chrgr.nm'/>",  field: "chrgrnm", headerHozAlign: "center", hozAlign: "center", width: 120, minWidth: 120},
                                    {title: "<spring:message code='common.label.org.chrgr.nm'/> <spring:message code='common.label.contact.info'/>",  field: "chrgrCntct", headerHozAlign: "center", hozAlign: "center", width: 120, minWidth: 120},
                                    {title: "<spring:message code='common.label.org.chrgr.nm'/> <spring:message code='common.email'/>",  field: "chrgrEml", headerHozAlign: "center", hozAlign: "left", width: 250, minWidth: 250}
                                ];

                                orgListTable = UiTable("orgList", {
                                    lang: "ko",
                                    table: "list",
                                    columns: cols,    // 컬럼정보
                                    pageFunc: listPaging,
                                });

                                listPaging(1);
                            });

                            // 기관정보 페이징 목록 조회
                            function listPaging(pageIndex) {
                                UiComm.showLoading(true);

                                PAGE_INDEX = pageIndex;

                                let extData = {
                                    searchValue : $("#searchValue").val(),
                                    pageIndex: pageIndex,
                                    listScale: LIST_SCALE
                                };
                                let param = {
                                    encParams: EPARAM,
                                    addParams: UiComm.makeEncParams(extData)
                                };

                                $.ajax({
                                    url: "/org/orgMgr/admOrgListViewAjax.do",
                                    data: param,
                                    type: "GET",
                                    headers: {"X-Requested-With": "XMLHttpRequest"},
                                    success: function (data) {
                                        if (data.encParams != null && data.encParams !== '') {
                                            EPARAM = data.encParams;
                                        }

                                        if (data.result > 0) {
                                            let returnList = data.returnList || [];

                                            // 테이블 데이터 세팅
                                            let dataList = createOrgListHTML(returnList, data.pageInfo);
                                            orgListTable.clearData();
                                            orgListTable.replaceData(dataList);
                                            orgListTable.setPageInfo(data.pageInfo);

                                            $("#totCnt").text(data.pageInfo.totalRecordCount);
                                        } else {
                                            UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error"); // 에러 메세지
                                        }
                                    },
                                    error: function(xhr, status, error) {
                                        UiComm.showMessage('<spring:message code="fail.common.msg" />', "error"); // 에러가 발생했습니다!
                                    },
                                    complete: function (){
                                        UiComm.showLoading(false);
                                    }
                                });
                            }

                            // 테이블 그리기
                            function createOrgListHTML(list, pageInfo) {
                                let dataList = [];

                                list.forEach(item => {
                                    const orgLink = `<a href="#0" class="link" onclick="moveToDtl('\${item.orgId}')">\${item.orgId}</a>`;
                                    let chrgrCntct = setTelNo(item.chrgrCntct);

                                    dataList.push({
                                        // no: item.lineNo,
                                        no: pageInfo.totalRecordCount - item.lineNo + 1,
                                        orgId: orgLink,
                                        orgnm: item.orgnm,
                                        orgShrtnm: item.orgShrtnm,
                                        orgTycd: item.orgTycd,
                                        chrgrnm: item.chrgrnm,
                                        chrgrCntct: chrgrCntct,
                                        chrgrEml: item.chrgrEml
                                    })
                                });

                                return dataList;
                            }

                            // 기관 상세정보 조회
                            function moveToDtl(orgId) {
                                document.location.href = "/org/orgMgr/admOrgDetailView.do?orgId=" + orgId + "&encParams=" + EPARAM;
                            }

                            // 기관 등록
                            function moveToRegist() {
                                document.location.href = "/org/orgMgr/admOrgRegistView.do?encParams=" + EPARAM;
                            }

                            // 전화번호 나누기
                            function setTelNo(telNo) {
                                let len = telNo.length;
                                let part1 = "";
                                let part2 = "";
                                let part3 = "";

                                // 앞자리 구분 (서울 02는 2자리, 나머지는 3자리)
                                let prefixLen = telNo.startsWith("02") ? 2 : 3;

                                // 자르기
                                part1 = telNo.substring(0, prefixLen);         // 지역번호/010
                                part2 = telNo.substring(prefixLen, len - 4);   // 국번 (가운데 전부)
                                part3 = telNo.substring(len - 4);              // 뒷번호 (끝 4자리)

                                return part1 + "-" + part2 + "-" + part3;
                            }
                        </script>
                        <!--//table-type-->

                    </div>
                </div>

            </div>
            <!-- //content -->

        </main>
        <!-- //admin-->

    </div>

</body>
</html>

