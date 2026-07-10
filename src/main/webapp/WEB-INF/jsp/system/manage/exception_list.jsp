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
            $("#orgId").on("change", function() {
            	var orgId = $(this).val();
                loadDeptList(orgId);
              	loadSubjectList(orgId, '');
              	loadList(1);
            });
            
         	// 기관 선택 변경 시 학과/부서 목록 업데이트
            $("#deptId").on("change", function() {
            	var orgId = $("#orgId").val();
                var deptId = $(this).val();
                loadSubjectList(orgId, deptId);
                loadList(1);
            });
         	
         	// 기관 선택 변경 시 학과/부서 목록 업데이트
            $("#subjectId").on("change", function() {            	
                loadList(1);
            }); 

            // 페이지당 건수 변경 이벤트
            $("#listScale").on("change", function() {
                LIST_SCALE = this.value;
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

        /* 기관별 학과/부서 목록 조회 */
		function loadDeptList(orgId) {
		    $.ajax({
		        url: "/admByOrgDeptList.do",
		        type: "GET",
		        data: { orgId: orgId || '' },
		        dataType: "json",
		        success: function(data) {
		            
		            var $deptSelect = $("#deptId");
		            $deptSelect.empty();
		
		            // data.result가 없거나 0이더라도 returnList에 데이터가 있으면 타도록 조건 완화
		            if(data.returnList && data.returnList.length > 0) {
		
		                $deptSelect.append('<option value="">전체</option>');
		
		                $.each(data.returnList, function(idx, dept) {
		                	
		                    var deptId = dept.deptId || '';
		                    $deptSelect.append(
		                        $('<option>').val(dept.deptId).text(dept.deptnm)
		                    );
		                });
		
		            } else {
		                $deptSelect.append(
		                    '<option value="">조회된 학과/부서가 없습니다.</option>'
		                );
		            }
		
		            // ★ Chosen 플러그인 화면 강제 업데이트 (정답 구간)
		            $deptSelect.trigger("chosen:updated");
		        },
		        error: function(xhr, status, error) {
		            console.error("학과/부서 조회 실패:", error);
		        }
		    });
		}
        
        /* 기관별, 부서별 과목목록조회 */
        function loadSubjectList(orgId, deptId) {
            console.log('들어와야지');
            $.ajax({
                url: "/subject/admByOrgByDeptSubjectSelect.do",
                type: "GET",
                data: { 
                    orgId: orgId || '',
                    deptId: deptId || ''
                },
                dataType: "json",
                success: function(data) {
                	console.log('success');
                	
                    var $subjectSelect = $("#subjectId");
                    $subjectSelect.empty();
        
                    if(data.returnList && data.returnList.length > 0) {
        
                        $subjectSelect.append('<option value="">전체</option>');
        
                        $.each(data.returnList, function(idx, subject) {
                            var sbjctCode = subject.sbjctId || '';
                            $subjectSelect.append(
                                $('<option>').val(sbjctCode).text(subject.sbjctnm)
                            );
                        });
        
                    } else {
                        $subjectSelect.append(
                            '<option value="">조회된 과목이 없습니다.</option>'
                        );
                    }
                    
                    console.log($subjectSelect.html());
        
                    // [해결책] 시스템에 사용 중인 UI 플러그인을 강제 리프레시합니다.
                    // 1. Chosen 플러그인용
                    $subjectSelect.trigger("chosen:updated");
                    
                    // 2. Select2 플러그인용 (만약 프레임워크가 Select2를 쓰고 있다면 필요)
                    if ($.fn.select2) {
                        $subjectSelect.trigger("change");
                    }
                    
                    // 3. 만약 공통 UI 리프레시 유틸이 존재한다면 (UiComm 등) 호출 예시
                    // UiComm.refreshSelect("#subjectId"); 
                },
                error: function(xhr, status, error) {
                    console.error("과목조회 조회 실패:", error);
                }
            });
        }        

        /* 페이지당 건수 변경: 1페이지로 reset 후 조회 */
        function changeListScale() {
        	recordCntPerPage = document.getElementById("listScale").value;
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

        /* 엑셀 다운로드: 현재 검색조건을 excelForm으로 복사해서 submit */
        function excelDown() {
            var excelUrl = "<c:url value='/system/manage/admExceptionListExcelDown.do'/>";

            // 엑셀 그리드 정의 (컬럼 설정) 
            var excelGrid = {
                colModel: [
                    {label: '번호', 		name: 'lineNo', 		align: 'center', 	width: '1000'},
                    {label: '기관', 		name: 'orgnm', 			align: 'left', 		width: '3000'},
                    {label: '학과/부서', 	name: 'deptnm', 		align: 'left', 		width: '3000'},
                    {label: '학번/사번', 	name: 'stdntNo', 		align: 'center', 	width: '2000'},
                    {label: '일시', 		name: 'regDttm', 		align: 'center', 	width: '3000'},
                    {label: '이름', 		name: 'usernm', 		align: 'center', 	width: '2000'},
                    {label: '오류페이지', 	name: 'sysErrPageNm', 	align: 'left', 		width: '5000'}
                ]
            };

            var src = document.getElementById("searchForm");
            var tgt = document.getElementById("excelForm");

            tgt.action = excelUrl;
            tgt.method = "post";
            tgt.innerHTML = "";

            // 검색조건 복사
            for (var i = 0; i < src.elements.length; i++) {
                var el = src.elements[i];
                if (!el.name || el.disabled) continue;
                if ((el.type === "checkbox" || el.type === "radio") && !el.checked) continue;

                var h = document.createElement("input");
                h.type = "hidden";
                h.name = el.name;
                h.value = el.value == null ? "" : el.value;
                tgt.appendChild(h);
            }

            // excelGrid 추가
            var gridInput = document.createElement("input");
            gridInput.type = "hidden";
            gridInput.name = "excelGrid";
            gridInput.value = JSON.stringify(excelGrid);
            tgt.appendChild(gridInput);

            tgt.submit();
        }

        /* 목록 조회 */
        function loadList(pageNo) {
        	
        	console.log('페이지번호-' + pageNo + ', recordCntPerPage-' + recordCntPerPage);
        	
            var url = "/system/manage/admExceptionListPaging.do";
            var param = {
                orgId: 			$("#orgId").val() || '',
                deptId: 		$("#deptId").val() || '',
                stdntNo: 		$("#searchType").val() === 'id' ? $("#searchText").val() : '',
                usernm: 		$("#searchType").val() === 'name' ? $("#searchText").val() : '',
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

        /* 에러 목록 데이터 생성 (Tabulator용) */
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
                    orgnm: 			item.orgnm 	|| '-',
                    deptnm: 		item.deptnm || '-',
                    stdntNo: 		item.stdntNo 	|| '-',
                    regDttm: 		UiComm.formatDate(item.regDttm, "datetime2") || '-',
                    usernm: 		item.usernm 	|| '-',
                    sysErrPagenm: 	item.sysErrPageNm 	|| '-',
                    sysErrMsg: 		item.sysErrMsg 	|| '-',
                    sysErrId: 		item.sysErrId 	|| '',
                    detail: 		detailBtn
                });
            });
            return dataList;
        }

        /* 모달 닫기 */
        function closeErrorModal() {
            var modal = document.getElementById('errorDetailModal');
            modal.classList.remove('active');
            modal.setAttribute('aria-hidden', 'true');
            document.body.style.overflow = '';
        }

        /* 상세보기 */
        function goDetail(sysErrId) {
        	
            if(!sysErrId) {
                alert("에러 메시지 ID가 없습니다.");
                return;
            }
            var url = "/system/manage/admExceptionDtl.do";
            var param = {
                sysErrId: sysErrId
            };
            
            $.ajax({
                url: url,
                type: "POST",
                data: param,
                dataType: "json",
                success: function(data) {
                	
                    if (data.result > 0) {
                        var errData = data.returnVO;

                        // 모달 내용 업데이트
                        var modalContent =
			            '<div style="line-height:1.8;">' +
			            '<p><strong>오류위치 :</strong> ' + (errData.sysErrReqUrl || '-') + '</p>' +
			            '<p><strong>사용자 :</strong> ' + (errData.userId || '-' ) + '</p>' +
			            '<p><strong>접속IP :</strong> ' + (errData.cntnIp || '-' ) + '</p>' +
			            '<p><strong>추적ID :</strong> ' + (errData.traceId || '-' ) + '</p>' +
		                '<p><strong>발생일시 :</strong> ' + (errData.sysErrDt || '-' || errData.sysErrDayofweek || '-') + '</p>' +
			                '<p><strong>오류유형 :</strong> ' + (errData.sysErrTycd || '-') + '</p>' +
			                '<div style="background:#f5f5f5;padding:10px;border-radius:4px;white-space:pre-wrap;word-break:break-all;">' +
			                    (errData.sysErrMsg || '-') +
			                '</div>' +
			            '</div>';
			
				        $('#errorDetailModalBody').html(modalContent);
				
				        // modal.js 사용
				        document.getElementById("btnOpenErrorModal").click();
                       
                    } else {
                        alert(data.message || "상세 정보를 조회할 수 없습니다.");
                    }
                },
                error: function(xhr, status, error) {
                    alert("에러가 발생했습니다!");
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
						<h2 class="page-title">전체 시스템오류 현황</h2> <%-- 현재 메뉴명 --%>
                    	<uiex:navibar type="admin"/><%-- 네비게이션바 --%>
                    </div>

                    <!-- 검색 영역(2줄): 셀렉트/입력 중심 -->
                    <div class="search-typeA">
                        <div class="item">
                            <span class="item_tit"><label for="orgId">기관</label></span>
                            <div class="itemList">
                                <select class="form-select" id="orgId" name="orgId" title="기관" style="width:300px;">
                                    <option value="">전체</option>
                                    <c:forEach var="item" items="${orgList}">
                                        <option value="${item.orgId}">${item.orgnm}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit"><label for="deptId">학과/부서</label></span>
                            <div class="itemList">
                                <select class="form-select" id="deptId" name="deptId" title="학과/부서" style="width:300px;">
                                    <option value="">전체</option>
                                    <c:forEach var="item" items="${deptList}">
                                        <option value="${item.deptId}">${item.deptnm}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit"><label for="subjectId">과목</label></span>
                            <div class="itemList">
                                <select class="form-select" id="subjectId" name="subjectId" title="과목" style="width:300px;">
                                    <option value="">전체</option>
                                    <c:forEach var="item" items="${subjectList}">
                                        <option value="${item.sbjctId}">${item.sbjctnm}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit"><label for="searchType">검색조건</label></span>
                            <div class="itemList">
                                <select class="form-select mr5" id="searchType" name="searchType" title="검색항목">
                                    <option value="id" <c:if test="${param.searchType=='stdntNo'}">selected</c:if>>학번/사번</option>
                                    <option value="name" <c:if test="${param.searchType=='usernm'}"></c:if>>이름</option>
                                </select>
                                <input class="form-control wide"
                                       type="text"
                                       id="searchText"
                                       name="searchText"
                                       value="${fn:escapeXml(param.searchText)}"
                                       placeholder="검색어 입력"
                                       onkeydown="return onEnterSearch(event);" />
                            </div>
                        </div>
                        <div class="button-area">
                            <button type="button" class="btn search" onclick="goSearch(1);">검색</button>
                        </div>
                    </div>

                    <!-- 목록 상단(제목/엑셀/페이지사이즈) -->
                    <div class="board_top">
                        <h3 class="board-title">오류 현황 목록</h3>
                        <div class="right-area">
                            <button type="button" class="btn type2" onclick="excelDown();">엑셀 다운로드</button>
                            <select class="form-select type-num"
                                    id="listScale"
                                    name="listScale"
                                    title="페이지당 리스트수를 선택하세요."
                                    onchange="changeListScale();">
                                <option value="10"  <c:if test="${param.listScale=='10' || empty param.listScale}">selected</c:if>>10</option>
                                <option value="20"  <c:if test="${param.listScale=='20' }">selected</c:if>>20</option>
                                <option value="30"  <c:if test="${param.listScale=='30' }">selected</c:if>>30</option>
                                <option value="50"  <c:if test="${param.listScale=='50' }">selected</c:if>>50</option>
                                <option value="100" <c:if test="${param.listScale=='100'}">selected</c:if>>100</option>
                            </select>
                        </div>
                    </div>

                    <!-- 엑셀 submit 전용 폼 -->
                    <form id="excelForm" method="post"></form>

                    <!-- 시스템 오류 목록 (tabulator) -->
                    <div id = "list"></div>
                    <script>
                    let listTable = UiTable("list", {
                        lang: "ko",
                        pageFunc: function(pageNo) {
                        		loadList(pageNo);
                            },
                        columns: [
                            {title:"No", 		field:"no", 			headerHozAlign:"center", 	hozAlign:"center", 	widthGrow: 1, 	minWidth:80 },
                            {title:"기관", 		field:"orgnm", 			headerHozAlign:"center", 	hozAlign:"center", 	widthGrow: 1, 	minWidth:120},
                            {title:"학과/부서", 	field:"deptnm", 		headerHozAlign:"center",	hozAlign:"center", 	widthGrow: 1, 	minWidth:150},
                            {title:"과목(분반)", 	field:"sbjctnm", 		headerHozAlign:"center",	hozAlign:"center", 	widthGrow: 1, 	minWidth:150},
                            {title:"일시", 		field:"regDttm", 		headerHozAlign:"center", 	hozAlign:"center", 	widthGrow: 1, 	minWidth:180},
                            {title:"학번/사번", 	field:"stdntNo", 		headerHozAlign:"center", 	hozAlign:"center", 	widthGrow: 1, 	minWidth:120},
                            {title:"이름", 		field:"usernm", 		headerHozAlign:"center", 	hozAlign:"center", 	widthGrow: 1, 	minWidth:100},
                            {title:"오류제목", 	field:"sysErrPagenm", 	visible:false, 				headerHozAlign:"center", 	hozAlign:"left", 	widthGrow: 4, 	minWidth:200},
                            {title:"오류내용", 	field:"sysErrMsg", 		headerHozAlign:"center", 	hozAlign:"left", 	widthGrow: 4, 	minWidth:200},
                            {title:"", 			field:"sysErrId"},
                            {title:"상세보기", 	field:"detail", 		headerHozAlign:"center", 	hozAlign:"center", 	widthGrow: 1, 	minWidth:120, formatter:"html"}
                        ]
                    });
                    </script>

                </div>
            </div>

        </div>
    </main>

    <!-- 시스템 오류 상세보기 모달 -->
    <div class="modal-overlay" id="errorDetailModal" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="errorDetailModalTitle">
        <div class="modal-content" tabindex="-1">
            <div class="modal-header">
                <h2 id="errorDetailModalTitle">시스템 오류 내용 상세보기</h2>
                <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
            </div>
            <div class="modal-body" id="errorDetailModalBody"></div>
        </div>
    </div>
    <script src="<%=request.getContextPath()%>/webdoc/assets/js/modal.js" defer></script>
    <button	type="button"	id="btnOpenErrorModal"	data-modal-open="errorDetailModal" style="display:none;"></button>
</div>
</body>
</html>