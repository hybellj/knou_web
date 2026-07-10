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
    let ORG_ID = '<c:out value="${orgId}" />';

    // list scale 변경
    function changeListScale(scale) {
        LIST_SCALE = scale;
        listPaging(1);
    }

 	// 글쓰기
	function moveWriteAtcl() {
		document.location.href = "/menu/menuMgr/admAuthRegist.do?encParams="+EPARAM;
	}

	function moveModifyAtcl(mode, userId) {

		var extData = {
			mode        : mode,
			userId	    : userId,
			authrtTycd  : 'ALL'
        };

		if(mode === 'U') {
			var url = "/menu/menuMgr/admMgrAddPopupView.do?encParams=" + EPARAM + "&addParams=" + UiComm.makeEncParams(extData);
			var returnUrl = "/menu/menuMgr/admAuthMngListView.do?encParams=${encParams}";
	        var sysMgrAddDialog = UiDialog("sysMgrAddDialog", {
	            title: "관리자 수정"
	            , width: 1200
	            , height: 800
	            , modal: true
	            , resizable: true
	            , draggable: true
	            , autoresize: false
	            , url: url
	            , close: function() {
	                listPaging(1);  // 팝업 닫힐 때 부모 리스트 재조회
	            }
	        });
		} else {
			UiComm.showMessage("정말 삭제하시겠습니까?", "confirm")
			.then(function(result) {
				if (result) {
					var url = "/menu/menuMgr/admAuthDelete.do";
        			var returnUrl = "/menu/menuMgr/admAuthMngListView.do?encParams=${encParams}";
        			var data = {
        				userId	: userId
        			};

        			ajaxCall(url, data, function(data) {
        	        	if (data.result > 0) {
        	        		var queryInfo = {};

        	        		UiComm.showMessage(data.message || "저장되었습니다.", "success")
        					.then(function(result) {
        						document.location.href = returnUrl;
        					});
        	            } else {
        	            	UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error"); // 에러 메세지
        	            }
        			},
            		function(xhr, status, error) {
            			UiComm.showMessage("<spring:message code='fail.common.msg'/>","error"); // 에러가 발생했습니다!
            		}, true);
				}
				else {
				}
			});
		}
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
                <div class="admin_sub">

                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">${uiex:getCurMenunm()}</h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>관리자</li>
                                    <li><span class="current">${uiex:getCurMenunm()}</span></li>
                                </ul>
                            </div>
                        </div>

                        <!-- search typeB -->
                        <div class="search-typeB">
                            <div class="item">
                                <span class="item_tit"><label for="selectSearch">관리자 구분</label></span>
                                <div class="itemList">
                                    <select class="ui dropdown" id="admGbncd">
								        <option value="">관리자 구분</option>
								        <c:forEach var="list" items="${filterOptions.admGbnList}">
								            <option value="${list.authrtCd}">${list.authrtnm}</option>
								        </c:forEach>
								    </select>
                                </div>
                                <span class="item_tit"><label for="selectSearch">기관</label></span>
                                <div class="itemList">
                                    <select class="ui dropdown" id="orgId">
								        <option value=""><spring:message code="bbs.label.org" /></option>
								        <c:forEach var="list" items="${filterOptions.orgList}">
								            <option value="${list.orgId}">${list.orgnm}</option>
								        </c:forEach>
								    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="selectSearch">검색어</label></span>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" name="" id="searchValue" value="" placeholder="이름/연락처 입력">
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="listPaging(1)"><spring:message code='button.search'/></button><%-- 검색 --%>
                            </div>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title">관리자 목록</h3>
                            <div class="right-area">
                                <button type="button" class="btn basic">메시지 보내기</button>
                                <button type="button" class="btn type2">엑셀 다운로드</button>
                                <button type="button" class="btn type2" onclick="moveWriteAtcl()">등록</button>
                                <uiex:listScale func="changeListScale" value="${vo.listScale}" />
                            </div>
                        </div>

                        <!--table-type-->
                        <div class="table-wrap">
                        	<div id="admAuthMngList"></div>
                        </div>
                        <!--//table-type-->
                        <script type="text/javascript">
                            let admAuthMngListTable;

                            $(function () {
                                let cols = [
                                    {title: "<spring:message code='common.no'/>", field: "no", headerHozAlign:"center", hozAlign:"center", width: 50, minWidth: 50},
                                    {title: "관리자 구분",  field: "authrtnm", headerHozAlign: "center", hozAlign: "center", width: 130, minWidth: 130},
                                    {title: "기관",  field: "orgnm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 150},
                                    {title: "사용자 유형", field: "userTycd", headerHozAlign: "center", hozAlign: "center", width: 180, minWidth: 180},
                                    {title: "이름",  field: "usernm", headerHozAlign: "center", hozAlign: "center", width: 120, minWidth: 120},
                                    {title: "연락처",  field: "cntct", headerHozAlign: "center", hozAlign: "center", width: 120, minWidth: 120},
                                    {title: "이메일",  field: "eml", headerHozAlign: "center", hozAlign: "left", width: 250, minWidth: 250},
                                    {title: "관리",   field: "mng", headerHozAlign: "center", hozAlign: "center", width: 120, minWidth: 120}
                                ];

                                admAuthMngListTable = UiTable("admAuthMngList", {
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
                                	authrtCd    : $("#admGbncd").val(),
									orgId       : $("#orgId").val(),
									searchValue : $("#searchValue").val(),
                                    pageIndex   : PAGE_INDEX,
                                    listScale   : LIST_SCALE
                                };

                                let param = {
                                    encParams: EPARAM,
                                    addParams: UiComm.makeEncParams(extData)
                                };

                                $.ajax({
                                    url: "/menu/menuMgr/admAuthMngListViewAjax.do",
                                    data: param,
                                    type: "GET",
                                    success: function (data) {
                                        if (data.encParams != null && data.encParams !== '') {
                                            EPARAM = data.encParams;
                                        }

                                        if (data.result > 0) {
                                            let returnList = data.returnList || [];

                                            // 테이블 데이터 세팅
                                            let dataList = createOrgListHTML(returnList, data.pageInfo);
                                            admAuthMngListTable.clearData();
                                            admAuthMngListTable.replaceData(dataList);
                                            admAuthMngListTable.setPageInfo(data.pageInfo);

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

                                list.forEach(function(v, i) {

                                	var mngHtml = "<button"
                                        + " type=\"button\""
                                        + " class=\"btn basic small\""
                                        + " onclick=\"moveModifyAtcl("
                                        +     "'" + ('U'        || '') + "',"
                                        +     "'" + (v.userId   || '') + "'"
                                        + ")\"><spring:message code='sys.button.modify'/></button>"
                                        + "<span style=\"margin: 0 1px;\"></span>"
                                        + "<button"
                                        + " type=\"button\""
                                        + " class=\"btn basic small\""
                                        + " onclick=\"moveModifyAtcl("
                                        +     "'" + ('D'        || '') + "',"
                                        +     "'" + (v.userId   || '') + "'"
                                        + ")\"><spring:message code='sys.button.delete'/></button>";

                                    dataList.push({
                                        no: v.lineNo,
                                        authrtnm: v.authrtnm,
                                        orgnm: v.orgnm,
                                        userTycd: v.userTycd,
                                        usernm: v.usernm,
                                        cntct: v.cntct,
                                        eml: v.eml,
                                        mng: mngHtml
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

                        <%-- 테이블의 페이징 정보 생성할때 아래 내용 참조하여 작업하고 아래와 같은 HTML 코드를 직접 만들지 않는다.
                        	1) UiTable() 함수를 사용하여 테이블 생성할경우는 해당 프로그램에서 페이지 정보 생성하도록 한다.
                        	2) Controller에서 페이지정보(PageInfo) 객체를 받아을 경우 <uiex:paging> 태그를 사용하여 생성한다.
                        	   <uiex:paging pageInfo="${pageInfo}" pageFunc="listPaging"/>
                        --%>
                        <!-- board foot -->

                    </div>
                </div>

            </div>
            <!-- //content -->

        </main>
        <!-- //admin-->


    </div>

</body>
</html>

