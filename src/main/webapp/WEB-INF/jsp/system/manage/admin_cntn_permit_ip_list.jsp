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
	<script type="text/javascript">
	
		function cntnPrmIpRegist() {
		    // TODO: IP 등록 팝업 열기 또는 등록 페이지 이동 로직 구현
		    alert("IP 등록 함수가 호출되었습니다.");
		}
	
        // 전역 변수
        var pageNo = 1;
        var recordCntPerPage = 10;
        
        var ipPageNo = 1;
        var ipRecordCntPerPage = 10;

        $(document).ready(function() {
            // 기관 선택 변경 시 학과/부서 목록 업데이트 및 1페이지 검색
            $("#orgId").on("change", function() {
                var orgId = $(this).val();
                loadDeptList(orgId, 'log');
                loadList(1); 
            });
            
            // 학과/부서 선택 변경 시 1페이지 검색
            $("#deptId").on("change", function() {
                loadList(1); 
            });
            
            
            $("#ipOrgId").on("change", function() {
                var orgId = $(this).val();
                loadDeptList(orgId, 'ip');
                loadListIp(1); 
            });
            
            // 학과/부서 선택 변경 시 1페이지 검색
            $("#ipDeptId").on("change", function() {
                loadListIp(1); 
            });            

            // 최초 로드 시 1페이지 호출
            loadList(1);
            
            loadListIp(1);
        });

        /* 검색 버튼 클릭 */
        function goSearch(pageNo, type) {
        	if ( type === 'log')
            	loadList(pageNo);
        	
        	if ( type === 'ip')
        		loadListIp(pageNo);
        }

        /* 기관별 학과/부서 목록 조회 */
        function loadDeptList(orgId, type) {
            $.ajax({
                url: "/admByOrgDeptList.do",
                type: "GET",
                data: { orgId: orgId || '' },
                dataType: "json",
                success: function(data) {                	
                	var $deptSelect = (type === 'ip') ? $("#ipDeptId") : $("#deptId");
                    
                    $deptSelect.empty();
                    $deptSelect.append('<option value="">전체</option>'); // 언제나 기본 '전체'는 제공

                    if(data.returnList && data.returnList.length > 0) {
                        $.each(data.returnList, function(idx, dept) {
                            $deptSelect.append($('<option>').val(dept.deptId).text(dept.deptnm));
                        });
                    } else {
                        // 옵션 추가가 아니라, disabled를 걸거나 안내용 dummy 옵션으로 처리하는 것이 좋습니다.
                        $deptSelect.find('option').text("학과/부서 없음"); 
                    }

                    // 대상 셀렉트 박스만 정확하게 UI 업데이트 트리거
                    if ($.isFunction($.fn.chosen) || $deptSelect.data('chosen')) {
                        $deptSelect.trigger("chosen:updated");
                    }
                },
                error: function(xhr, status, error) {
                    console.error("학과/부서 조회 실패:", error);
                }
            });
        }           

        /* 검색어 입력창에서 Enter → 1페이지 조회 */
        function onEnterSearch(e, type) {
            if (e && e.keyCode === 13) {
                e.preventDefault();
                
                if ( type === 'log')
                	loadList(1);
                if ( type === 'ip')
                	loadListIp(1);
                return false;
            }
            return true;
        }
        
        /* 목록 조회 AJAX */
        function loadListIp(pageNo) {

            var url = "/system/manage/admCntnPermitIpListPaging.do";
            var param = {
                orgId:      $("#ipOrgId").val() || '',
                deptId:     $("#ipDeptId").val() || '',
                searchText: $("#ipSearchText").val() || '',
                currentPageNo: 		pageNo,                
                recordCountPerPage:	ipRecordCntPerPage,
                pageSize : 			10
            };

            if (typeof UiComm !== "undefined" && UiComm.showLoading) {
                UiComm.showLoading(true);
            }

            $.ajax({
                url:      url,
                type:     "POST",
                data:     param,
                dataType: "json",
                success: function(data) {
                	
                    if (data && data.returnList) {
                        var returnList = data.returnList || [];
                        
                        var pageInfo = data.pageInfo || { totalRecordCount: returnList.length, pageNo: pageNo };

                        var tableData = createListDataIp(returnList, pageInfo);

                        // Tabulator 인스턴스에 데이터 바인딩
                        listTableIp.clearData();
                        listTableIp.replaceData(tableData);
                        
                        // 공통 UiTable의 페이징 컴포넌트 갱신 기능 호출
                        if (typeof listTableIp.setPageInfo === "function") {
                        	listTableIp.setPageInfo(pageInfo);
                        	
                        } else if (typeof listTableIp.setPage === "function") {
                            // 대안 메서드가 존재할 경우 처리
                            listTableIp.setPage(pageNo);
                        }
                    } else {
                    	listTableIp.setData([]);
                    }
                },
                error: function(xhr, status, error) {                	
                    var errorMsg = xhr.responseText || "오류가 발생했습니다.";              
                    if (typeof UiComm !== "undefined" && UiComm.showMessage) {
                        UiComm.showMessage(errorMsg, "error");
                    } else {
                        alert(errorMsg);
                    }
                    listTableIp.setData([]);
                },
                complete: function() {
                    if (typeof UiComm !== "undefined" && UiComm.showLoading) {
                        UiComm.showLoading(false);
                    }
                }
            });
        }
        
        /* 목록 데이터 생성 (Tabulator용 가공) */
        function createListDataIp(list, pageInfo) {
            let dataListIp = [];

            if(!list || list.length == 0) {
                return dataListIp;
            }

            var totalCount = pageInfo.totalRecordCount || list.length;

            list.forEach(function(item, idx) {
                var lineNo = item.lineNo ? (totalCount - item.lineNo + 1) : (totalCount - idx);
                
                dataListIp.push({
                    no:         		lineNo,
                    cntnPrmIp:   		item.cntnPrmIp  || '-',
                    admCntnPrmIpId:   	item.admCntnPrmIpId  || '-',
                    bandVl:      		item.bandVl     || '-',
                    bandChkyn:     		item.bandChkyn    || '-'
                });
            });
            return dataListIp;
        }        

        /* 목록 조회 AJAX */
        function loadList(pageNo) {            

            var url = "/log2/admCntnLogListPaging.do";
            var param = {
                orgId:      $("#orgId").val() || '',
                deptId:     $("#deptId").val() || '',
                searchText: $("#searchText").val() || '',
                currentPageNo: 		pageNo,                
                recordCountPerPage:	recordCntPerPage,
                pageSize : 			10
            };

            if (typeof UiComm !== "undefined" && UiComm.showLoading) {
                UiComm.showLoading(true);
            }

            $.ajax({
                url:      url,
                type:     "GET",
                data:     param,
                dataType: "json",
                success: function(data) {
                    if (data && data.returnList) {
                        var returnList = data.returnList || [];
                        var pageInfo = data.pageInfo || { totalRecordCount: returnList.length, pageNo: pageNo };

                        var tableData = createListData(returnList, pageInfo);

                        // Tabulator 인스턴스에 데이터 바인딩
                        listTable.clearData();
                        listTable.replaceData(tableData);
                        
                        // 공통 UiTable의 페이징 컴포넌트 갱신 기능 호출
                        if (typeof listTable.setPageInfo === "function") {
                            listTable.setPageInfo(pageInfo);
                        } else if (typeof listTable.setPage === "function") {
                            // 대안 메서드가 존재할 경우 처리
                            listTable.setPage(pageNo);
                        }
                    } else {
                        listTable.setData([]);
                    }
                },
                error: function(xhr, status, error) {                	
                    var errorMsg = xhr.responseText || "오류가 발생했습니다.";              
                    if (typeof UiComm !== "undefined" && UiComm.showMessage) {
                        UiComm.showMessage(errorMsg, "error");
                    } else {
                        alert(errorMsg);
                    }
                    listTable.setData([]);
                },
                complete: function() {
                    if (typeof UiComm !== "undefined" && UiComm.showLoading) {
                        UiComm.showLoading(false);
                    }
                }
            });
        }

        /* 목록 데이터 생성 (Tabulator용 가공) */
        function createListData(list, pageInfo) {
            let dataList = [];

            if(!list || list.length == 0) {
                return dataList;
            }

            var totalCount = pageInfo.totalRecordCount || list.length;

            list.forEach(function(item, idx) {
                var lineNo = item.lineNo ? (totalCount - item.lineNo + 1) : (totalCount - idx);
                
                dataList.push({
                    no:         lineNo,
                    userId:     item.userId    || '-',
                    orgnm:      item.orgnm     || '-',
                    deptId:     item.deptId    || '-',
                    stdntNo:    item.stdntNo   || '-',                    
                    usernm:     item.usernm    || '-',
                    cntnIp:     item.cntnIp    || '-',
                    sessSdttm:  (typeof UiComm !== "undefined") ? UiComm.formatDate(item.sessSdttm, "datetime2") : (item.sessSdttm || '-'),
                    sessEdttm:  (typeof UiComm !== "undefined") ? UiComm.formatDate(item.sessEdttm, "datetime2") : (item.sessEdttm || '-'),
                    sessMin:    (typeof UiComm !== "undefined") ? UiComm.formatDate(item.sessMin,   "datetime2") : (item.sessMin || '-')
                });
            });
            return dataList;
        }

        function setAccessFree() { alert("접속 제한 없음 설정"); }
        function setAccessRestriction() { alert("IP 접속 제한 설정"); }
    </script>
</head>

<body class="admin">
<div id="wrap" class="main">

    <form id="moveForm" method="post"></form>
    <jsp:include page="/WEB-INF/jsp/common_new/admin_header.jsp"/>

    <main class="common">
        <jsp:include page="/WEB-INF/jsp/common_new/admin_aside.jsp"/>
        <div id="content" class="content-wrap common">			
	            
            <div class="admin_sub">
                <div class="sub-content">
                    <div class="page-info">
                        <h2 class="page-title">관리자 IP관리</h2>
                        <uiex:navibar type="admin"/>
                    </div>

                    <div class="search-typeA">
                        <div class="item">
                            <span class="item_tit"><label>접속제한설정</label></span>
                            <button type="button" style="background:#000; color:#fff; border:1px solid #000;" class="btn basic small" onclick="setAccessFree();">접속 제한 없음</button>
                            <button type="button" style="background:#fff; color:#000; border:1px solid #ccc;" class="btn basic small" onclick="setAccessRestriction();">IP 접속 제한</button>                       			
                        </div>
                    </div>
                    
                    <div class="search-typeA">
                        <div class="item">
                        	<div class="itemList">
                            	<span class="item_tit">
                            		<label for="ipOrgId">접속허용 IP 등록</label>
                            		<button type="button" style="background:#000; color:#fff; border:1px solid #000;" class="btn basic small" onclick="cntnPrmIpRegist();">추가</button>
                            	</span>                            	
                            </div>
                        </div>
                    </div>
                    
                    <div class="search-typeA">
                    	<div class="item">
                            <div class="itemList">
                                <select class="form-select" id="ipOrgId" name="orgId" title="기관" style="width:200px;">
                                    <option value="">전체</option>
                                    <c:forEach var="item" items="${orgList}">
                                        <option value="${item.orgId}">${item.orgnm}</option>
                                    </c:forEach>
                                </select>
                                <select class="form-select" id="ipDeptId" name="deptId" title="학과/부서" style="width:200px;">
                                    <option value="">전체</option>
                                    <c:forEach var="item" items="${deptList}">
                                        <option value="${item.deptId}">${item.deptnm}</option>
                                    </c:forEach>
                                </select>                                
                                <input class="form-control wide" type="text" id="ipSearchText" name="searchText" value="${fn:escapeXml(param.searchText)}"
                                       placeholder="학번/사번, 접속자, 접속IP 검색" onkeydown="return onEnterSearch(event, 'ip');" />
                                <button type="button" class="btn search" onclick="goSearch(1, 'ip');">검색</button>
                            </div>
                        </div>
                    </div>
                    
                    <div id="listIp"></div>
                    
                    <script>
                    // UiTable 바인딩 (컴포넌트 스크립트)
                    let listTableIp = UiTable("listIp", {
                        lang: "ko",
                        pageFunc: function(page, size) {
                            // Tabulator 내부 pagination 호출을 직접 가로채서 안전하게 매핑 수행
                            loadListIp(page, size);
                        },
                        columns: [
                            {title:"No",        	field:"no",             	headerHozAlign:"center",    hozAlign:"center",  widthGrow: 1,   minWidth:80 },
                            {title:"접속 허용 IP주소",  field:"cntnPrmIp",          headerHozAlign:"center",    hozAlign:"center",  widthGrow: 1,   minWidth:120},
                            {title:"관리", 			field:"admCntnPrmIpId",     headerHozAlign:"center",    hozAlign:"center",  widthGrow: 1,   minWidth:150},
                            {title:"대역값", 			field:"bandVl",     		headerHozAlign:"center",    hozAlign:"center",  widthGrow: 1,   minWidth:150},
                            {title:"대역체크여부", 		field:"bandChkyn",     		headerHozAlign:"center",    hozAlign:"center",  widthGrow: 1,   minWidth:150}                            
                        ]
                    });
                    </script>
                    
                    <br><br><br><br><br>
                    
                    <div class="search-typeA">
                        <div class="item">
                            <span class="item_tit" style="width:150px;"><label for="orgId">관리자 접속기록조회</label></span>
                            <div class="itemList">
                                <select class="form-select" id="orgId" name="orgId" title="기관" style="width:200px;">
                                    <option value="">전체</option>
                                    <c:forEach var="item" items="${orgList}">
                                        <option value="${item.orgId}">${item.orgnm}</option>
                                    </c:forEach>
                                </select>
                                <select class="form-select" id="deptId" name="deptId" title="학과/부서" style="width:200px;">
                                    <option value="">전체</option>
                                    <c:forEach var="item" items="${deptList}">
                                        <option value="${item.deptId}">${item.deptnm}</option>
                                    </c:forEach>
                                </select>
                                <input class="form-control wide" type="text" id="searchText" name="searchText" value="${fn:escapeXml(param.searchText)}"
                                       placeholder="학번/사번, 접속자, 접속IP 검색" onkeydown="return onEnterSearch(event, 'log');" />
                                <button type="button" class="btn search" onclick="goSearch(1, 'log');">검색</button>
                            </div>
                        </div> 
                    </div>
                    
                    <div id="list"></div>
                    <script>
                    // UiTable 바인딩 (컴포넌트 스크립트)
                    let listTable = UiTable("list", {
                        lang: "ko",
                        pageFunc: function(page, size) {
                            // Tabulator 내부 pagination 호출을 직접 가로채서 안전하게 매핑 수행
                            loadList(page, size);
                        },
                        columns: [
                            {title:"No",        field:"no",             headerHozAlign:"center",    hozAlign:"center",  widthGrow: 1,   minWidth:80 },
                            {title:"기관",      	field:"orgnm",          headerHozAlign:"center",    hozAlign:"center",  widthGrow: 1,   minWidth:120},
                            {title:"학과/부서", 	field:"deptId",         headerHozAlign:"center",    hozAlign:"center",  widthGrow: 1,   minWidth:150},
                            {title:"학번/사번", 	field:"stdntNo",        headerHozAlign:"center",    hozAlign:"center",  widthGrow: 1,   minWidth:120},
                            {title:"접속자",    	field:"usernm",         headerHozAlign:"center",    hozAlign:"center",  widthGrow: 1,   minWidth:100},
                            {title:"접속IP",    	field:"cntnIp",         headerHozAlign:"center",    hozAlign:"center",  widthGrow: 1,   minWidth:100},
                            {title:"시작일시",  	field:"sessSdttm",      headerHozAlign:"center",    hozAlign:"center",  widthGrow: 1,   minWidth:100},
                            {title:"종료일시",  	field:"sessEdttm",      headerHozAlign:"center",    hozAlign:"center",  widthGrow: 1,   minWidth:100},
                            {title:"접속시간",  	field:"sessMin",        headerHozAlign:"center",    hozAlign:"center",  widthGrow: 1,   minWidth:100}
                        ]
                    });
                    </script>

                </div>
            </div>

        </div>
    </main>

</div>
</body>
</html>