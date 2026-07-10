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
    	var pageNo = 1;
        var recordCntPerPage = 10;

        $(document).ready(function() {
            // 기관 선택 변경 시 학과/부서 목록 업데이트
            /*$("#orgId").on("change", function() {
            	var orgId = $(this).val();
                loadYrSmstrList(orgId);
            });*/

            // 페이지당 건수 변경 이벤트
            $("#recordCntPerPage").on("change", function() {
            	recordCntPerPage = this.value;
                loadList(1);
            });

            // 검색어 입력창에서 Enter 키
            $("#searchText").on("keydown", function(e) {
                if(e.keyCode == 13) {
                    e.preventDefault();
                    loadList(1);
                }
            });

            // 페이지 로딩 시 목록 조회
            loadList(1);
        });

        /* 검색 버튼 클릭 */
        function goSearch(pageNo) {
            loadList(pageNo);
        }

        /* 기관별 년도학기기수조회  */
		/* function loadYrSmstrList(orgId) {
        	var param = {
	                orgId: 			$("#orgId").val() || '',
	                currentPageNo: 		pageNo,                
	                recordCountPerPage:	recordCntPerPage,
	                pageSize : 			10
	            };			
			
		    $.ajax({
		        url: "/common/admYrSmstrSelect.do",
		        type: "GET",
		        data: param,
		        dataType: "json",
		        success: function(data) {
		            
		            var $yrSmstrSelect = $("#yrSmstr");
		            $yrSmstrSelect.empty();
		
		            // data.result가 없거나 0이더라도 returnList에 데이터가 있으면 타도록 조건 완화
		            if(data.returnList && data.returnList.length > 0) {
		
		                //$yrSmstrSelect.append('<option value="">전체</option>'); 전체는 없는 것으로 하기로 함. 20260609
		
		                $.each(data.returnList, function(idx, item) {		                	
		                    $yrSmstrSelect.append(
		                        $('<option>').val(item.yrSmstr).text(item.yrSmstrnm)
		                    );
		                });
		
		            } else {
		                $yrSmstrSelect.append(
		                    '<option value="">조회된 년도/학기가 없습니다.</option>'
		                );
		            }
		
		            // ★ Chosen 플러그인 화면 강제 업데이트 (정답 구간)
		            $yrSmstrSelect.trigger("chosen:updated");
		            
		            console.log("응답=", data);
	                console.log("목록=", data.returnList);
		        },
		        error: function(xhr, status, error) {
		            console.error("년도/학기 조회 실패:", error);
		        }
		    });
		}     */    

        /* 페이지당 건수 변경: 1페이지로 reset 후 조회 */
        function changeRecordCntPerPage() {
        	recordCntPerPage = document.getElementById("recordCntPerPage").value;
            loadList(1);
        }

        /* 검색어 입력창에서 Enter → 1페이지 조회 */
        function onEnterSearch(e) {
            if (e && e.keyCode === 13) {
                e.preventDefault();
                loadList(1);
                return false;
            }
            return true;
        }

        /* 목록 조회 */
        function loadList(pNo) { // 매개변수 이름을 pNo로 변경하여 전역 변수와 구분합니다.
        	
            // ★ 중요: 현재 페이지 번호를 전역 변수 pageNo에 저장해 둡니다.
            pageNo = pNo; 
        	
            var url = "/acad/schdl/admAcademicScheduleListPaging.do";
            var param = {
            	smstrChrtId: 		$("#smstrChrtId").val() || '',
                searchText: 		$("#searchText").val() || '',
                currentPageNo: 		pageNo,                
                recordCountPerPage:	recordCntPerPage,
                pageSize : 			10
            };

            // 로딩 표시
            UiComm.showLoading(true);

            $.ajax({
                url: 	url,
                type: 	"POST",
                data: 	param,
                dataType: "json",
                success: function(data) {
                    if (data.result > 0) {
                        var returnList = data.returnList || [];
                        var pageInfo = data.pageInfo;

                        // 테이블 데이터 생성
                        var tableData = createListData(returnList, pageInfo);

                        // 테이블에 데이터 설정
                        listTable.clearData();
                        listTable.replaceData(tableData);
                        listTable.setPageInfo(pageInfo);
                    } else {
                        listTable.setData([]);
                    }
                },
                error: function(xhr, status, error) {                	
                	var errorMsg = xhr.dataText || " 오류가 발생했습니다. ";                    
                    // UI 모달창에 메시지 출력
                    UiComm.showMessage(errorMsg, "error");
                    listTable.setData([]);
                },
                complete: function() {
                    // 로딩 닫기
                    UiComm.showLoading(false);
                }
            });
        }

        /* 리스트 생성 */
        function createListData(list, pageInfo) {
            let dataList = [];

            if(!list || list.length == 0) {
                return dataList;
            }

            list.forEach(function(item) {
                var lineNo = pageInfo.totalRecordCount - item.lineNo + 1;
                var detailBtn = '<button type="button" class="btn basic small" onclick="goDetail(\'' + item.sysErrId + '\');">상세 보기</button>';
                dataList.push({
                    no: 			lineNo,
                    acadSchdlId:	item.acadSchdlId	|| '-',
                    smstrChrtId: 	item.smstrChrtId	|| '-',
                    smstrChrtnm: 	item.smstrChrtnm 	|| '-',
                    orgnm: 			item.orgnm || '-',
                    schdlTycd: 		item.schdlTycd 	|| '-',
                    schdlTynm: 		item.schdlTynm 	|| '-',
                    schdlExpln: 	item.schdlExpln || '-',
                    schdlSdttm: 	UiComm.formatDate(item.schdlSdttm, "datetime2") || '-',
                    schdlEdttm: 	UiComm.formatDate(item.schdlEdttm, "datetime2") || '-',
                    modifyDelete: 	'<div style="display:flex; justify-content:center; gap:6px;">' +
	                    				'<button type="button" class="btn basic small" onclick="goModify(\'' + item.acadSchdlId + '\');">수정</button> ' +
	                    				'<button type="button" class="btn danger small" onclick="goDelete(\'' + item.acadSchdlId + '\');">삭제</button>' +
                    				'</div>'	
                });
            });
            return dataList;
        }
        
        /* 등록 화면 이동 */
        function goRegist() {
            $("#moveForm").html(
                '<input type="hidden" name="orgId" value="${userCtx.loginUser.orgId}">' +
                '<input type="hidden" name="smstrChrtId" value="' + $("#smstrChrtId").val() + '">'
            );
            $("#moveForm").attr("action", "/acad/schdl/admAcademicScheduleRegistView.do").submit();
        }

        /* 수정 화면 이동 */
        function goModify(acadSchdlId) {
            $("#moveForm").html(
                '<input type="hidden" name="acadSchdlId" value="' + acadSchdlId + '">' +
                '<input type="hidden" name="orgId" value="${userCtx.loginUser.orgId}">' +
                '<input type="hidden" name="smstrChrtId" value="' + $("#smstrChrtId").val() + '">'
            );
            $("#moveForm").attr("action", "/acad/schdl/admAcademicScheduleModifyView.do").submit();
        }

        /* 삭제 */
        function goDelete(acadSchdlId) {

            if (!confirm("삭제하시겠습니까?")) {
                return;
            }

            UiComm.showLoading(true);

            $.ajax({
                url : "/acad/schdl/admAcademicScheduleDelete.do",
                type : "POST",
                data : {
                	acadSchdlId : acadSchdlId
                },
                dataType : "json",
                success : function(data) {
                    if (data.result > 0) {
                        UiComm.showMessage("삭제되었습니다.", "success");
                        
                        if(listTable.getData().length === 1 && pageNo > 1) {
                            pageNo--;
                        }
                     	// 현재 테이블의 행 개수가 1개뿐이었다면 이전 페이지로 이동 (단, 1페이지보다는 커야 함)
                        loadList(pageNo);
                        
                    } else {
                        UiComm.showMessage( data.message || "삭제에 실패했습니다.", "error");
                    }
                },
                error : function(xhr) {                    
                	UiComm.showMessage( xhr.responseText || "삭제 중 오류가 발생했습니다.","error");
                },
                complete : function() {
                    UiComm.showLoading(false);
                }
            });
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
						<h2 class="page-title">강의실접속통계</h2> <%-- 현재 메뉴명 --%>
                    	<uiex:navibar type="admin"/><%-- 네비게이션바 --%>
                    </div>
                    <!-- 검색 영역(2줄): 셀렉트/입력 중심 -->                

                    <div class="search-typeA">
                     	<div class="item">
                            <span class="item_tit"><label for="orgId">기관</label></span>
                            <div class="itemList">
                                ${userCtx.loginUser.orgnm}
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit"><label for="smstrChrtId">년도/학기</label></span>
                            <div class="itemList">
                                <select class="form-select" id="smstrChrtId" name="smstrChrtId" title="년도학기" style="width:300px;"><!-- 전체는 없는 것으로 함 20260609 -->
                                    <c:forEach var="item" items="${yrSmstrList}">
                                        <option value="${item.smstrChrtId}">${item.smstrChrtnm}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit"><label for="searchType">검색어</label></span>
                            <div class="itemList">
                                <input class="form-control wide"
                                       type="text"
                                       id="searchText"
                                       name="searchText"
                                       value="${fn:escapeXml(param.searchText)}"
                                       placeholder="업무일정 검색"
                                       onkeydown="return onEnterSearch(event);" />
                            </div>
                        </div>
                        <div class="button-area">
                            <button type="button" class="btn search" onclick="goSearch(1);">검색</button>
                        </div>
                    </div>

                    <!-- 목록 상단(제목/엑셀/페이지사이즈) -->
                    <div class="board_top">
                        <h3 class="board-title">목록</h3>
                        <div class="right-area">
                            <button type="button" class="btn type2" onclick="goRegist();">등록</button>
                            <select class="form-select type-num"
                                    id="recordCntPerPage"
                                    name="recordCntPerPage"
                                    title="페이지당 리스트수를 선택하세요."
                                    onchange="changeRecordCntPerPage();">
                                <option value="10"  <c:if test="${param.recordCntPerPage=='10' || empty param.recordCntPerPage}">selected</c:if>>10</option>
                                <option value="20"  <c:if test="${param.recordCntPerPage=='20' }">selected</c:if>>20</option>
                                <option value="30"  <c:if test="${param.recordCntPerPage=='30' }">selected</c:if>>30</option>
                                <option value="50"  <c:if test="${param.recordCntPerPage=='50' }">selected</c:if>>50</option>
                                <option value="100" <c:if test="${param.recordCntPerPage=='100'}">selected</c:if>>100</option>
                            </select>
                        </div>
                    </div>

                    <div id = "list"></div>
                    
                    <script>
                    let listTable = UiTable("list", {
                        lang: "ko",
                        pageFunc: function(pageNo) {
                        		loadList(pageNo);
                            },
                        columns: [
                            {title:"No", 			field:"no", 			headerHozAlign:"center", 	hozAlign:"center", 	widthGrow: 1, 	minWidth:80 },
                            {title:"학기기수아이디", 	field:"smstrChrtId", 	visible:false},
                            {title:"학사일정아이디", 	field:"acadSchdlId", 	visible:false},
                            {title:"년도/학기", 		field:"smstrChrtnm", 	headerHozAlign:"center",	hozAlign:"center", 	widthGrow: 2, 	minWidth:150},
                            {title:"기관", 			field:"orgnm", 			headerHozAlign:"center", 	hozAlign:"center", 	widthGrow: 1, 	minWidth:120},
                            {title:"업무일정코드", 		field:"schdlTycd", 		headerHozAlign:"center",	hozAlign:"center", 	widthGrow: 1, 	minWidth:150},
                            {title:"업무일정", 		field:"schdlExpln", 	headerHozAlign:"center", 	hozAlign:"center", 	widthGrow: 3, 	minWidth:180},
                            {title:"시작일시", 		field:"schdlSdttm", 	headerHozAlign:"center", 	hozAlign:"center", 	widthGrow: 1, 	minWidth:120},
                            {title:"종료일시", 		field:"schdlEdttm", 	headerHozAlign:"center", 	hozAlign:"center", 	widthGrow: 1, 	minWidth:100},
                            {title:"관리", 			field:"modifyDelete", 	headerHozAlign:"center", 	hozAlign:"center", 	widthGrow: 1, 	minWidth:200, formatter:"html"}
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