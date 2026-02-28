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
        var PAGE_INDEX = 1;
        var LIST_SCALE = 10;

        $(document).ready(function() {
            // 기관 선택 변경 시 학과/부서 목록 업데이트
            $("#orgId").on("change", function() {
                loadDeptList($(this).val());
            });

            // 페이지당 건수 변경 이벤트
            $("#listScale").on("change", function() {
                LIST_SCALE = this.value;
                loadErrorList(1);
            });

            // 검색어 입력창에서 Enter 키
            $("#searchText").on("keydown", function(e) {
                if(e.keyCode == 13) {
                    e.preventDefault();
                    loadErrorList(1);
                }
            });

            // 페이지 로딩 시 목록 조회
            loadErrorList(1);
        });

        /* 검색 버튼 클릭 */
        function goSearch(page) {
            loadErrorList(page || 1);
        }

        /* 기관별 학과/부서 목록 조회 */
        function loadDeptList(orgId) {
            $.ajax({
                url: "/user/userMgr/deptList.do",
                type: "GET",
                data: { orgId: orgId || '' },
                dataType: "json",
                success: function(response) {
                    var $deptSelect = $("#deptCd");
                    $deptSelect.empty();
                    $deptSelect.append('<option value="">전체</option>');

                    if(response.result > 0 && response.returnList) {
                        $.each(response.returnList, function(idx, dept) {
                            $deptSelect.append(
                                $('<option></option>')
                                    .val(dept.deptId)
                                    .text(dept.deptnm)
                            );
                        });
                    }
                },
                error: function(xhr, status, error) {
                    console.error("학과/부서 목록 조회 실패:", error);
                }
            });
        }

        /* 페이지당 건수 변경: 1페이지로 reset 후 조회 */
        function changeListScale() {
            LIST_SCALE = document.getElementById("listScale").value;
            loadErrorList(1);
        }

        /* 검색어 입력창에서 Enter → 1페이지 조회 */
        function onEnterSearch(e) {
            if (e && e.keyCode === 13) {
                e.preventDefault();
                loadErrorList(1);
                return false;
            }
            return true;
        }

        /* 엑셀 다운로드: 현재 검색조건을 excelForm으로 복사해서 submit */
        function excelDown() {
            var excelUrl = "<c:url value='/sys/sysMgr/sysErrListExcelDown.do'/>";

            // 엑셀 그리드 정의 (컬럼 설정) 
            var excelGrid = {
                colModel: [
                    {label: '번호', name: 'lineNo', align: 'center', width: '1000'},
                    {label: '기관', name: 'orgnm', align: 'left', width: '3000'},
                    {label: '학과/부서', name: 'deptnm', align: 'left', width: '3000'},
                    {label: '학번/사번', name: 'stdntNo', align: 'center', width: '2000'},
                    {label: '일시', name: 'regDttm', align: 'center', width: '3000'},
                    {label: '이름', name: 'usernm', align: 'center', width: '2000'},
                    {label: '오류페이지', name: 'sysErrPageNm', align: 'left', width: '5000'}
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

        /* 목록 조회 AJAX */
        function loadErrorList(pageIndex) {
            PAGE_INDEX = pageIndex || 1;

            var url = "/sys/sysMgr/sysErrList.do";
            var param = {
                orgId: $("#orgId").val() || '',
                deptId: $("#deptCd").val() || '',
                stdntNo: $("#searchType").val() === 'id' ? $("#searchText").val() : '',
                usernm: $("#searchType").val() === 'name' ? $("#searchText").val() : '',
                pageIndex: pageIndex,
                listScale: LIST_SCALE
            };

            // 로딩 표시
            UiComm.showLoading(true);

            $.ajax({
                url: url,
                type: "GET",
                data: param,
                dataType: "json",
                success: function(data) {
                    if (data.result > 0) {
                        var returnList = data.returnList || [];
                        var pageInfo = data.pageInfo;

                        // 테이블 데이터 생성
                        var tableData = createErrListData(returnList, pageInfo);

                        // 테이블에 데이터 설정
                        errListTable.clearData();
                        errListTable.replaceData(tableData);
                        errListTable.setPageInfo(pageInfo);
                    } else {
                        errListTable.setData([]);
                    }
                },
                error: function(xhr, status, error) {
                    UiComm.showMessage("에러가 발생했습니다!", "error");
                    errListTable.setData([]);
                },
                complete: function() {
                    // 로딩 닫기
                    UiComm.showLoading(false);
                }
            });
        }

        /* 에러 목록 데이터 생성 (Tabulator용) */
        function createErrListData(list, pageInfo) {
            let dataList = [];

            if(!list || list.length == 0) {
                return dataList;
            }

            list.forEach(function(item) {
                var lineNo = pageInfo.totalRecordCount - item.lineNo + 1;

                var detailBtn = '<button type="button" class="btn basic small" onclick="goDetail(\'' + item.sysErrMsgId + '\');">상세 보기</button>';

                dataList.push({
                    no: lineNo,
                    orgnm: item.orgnm || '-',
                    deptnm: item.deptnm || '-',
                    stdntNo: item.stdntNo || '-',
                    regDttm: item.regDttm || '-',
                    usernm: item.usernm || '-',
                    sysErrPagenm: item.sysErrPageNm || '-',
                    sysErrMsgId: item.sysErrMsgId || '',
                    detail: detailBtn
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
        function goDetail(sysErrMsgId) {
            if(!sysErrMsgId) {
                alert("에러 메시지 ID가 없습니다.");
                return;
            }

            var url = "/sys/sysMgr/sysErrDtl.do";
            var param = {
                sysErrMsgId: sysErrMsgId
            };

            $.ajax({
                url: url,
                type: "GET",
                data: param,
                dataType: "json",
                success: function(data) {
                    if (data.result > 0) {
                        var errData = data.returnVO;

                        // 모달 내용 업데이트
                        var modalContent =
                            '<div style="line-height: 1.8;">' +
                            '<p><strong>오류 위치:</strong> ' + (errData.errLocation || '-') + '</p>' +
                            '<p><strong></strong> ' + (errData.regDttm || '-') + '</p>' +
                            '<p><strong></strong> ' + (errData.errType || '-') + '</p>' +
                            '<div style="background-color: #f5f5f5; padding: 10px; border-radius: 4px; white-space: pre-wrap; word-break: break-all;">' +
                            (errData.sysErrMsgCts || '-') +
                            '</div>' +
                            '</div>';

                        $('#errorDetailModalBody').html(modalContent);

                        // 모달 열기
                        var modal = document.getElementById('errorDetailModal');
                        modal.classList.add('active');
                        modal.setAttribute('aria-hidden', 'false');
                        document.body.style.overflow = 'hidden';
                        modal.querySelector('.modal-content').focus();

                        // 모달 닫기 이벤트 (X 버튼, 배경 클릭, ESC 키)
                        var closeBtn = modal.querySelector('.modal-close');
                        var overlay = modal;

                        // X 버튼 클릭 시
                        closeBtn.onclick = function() {
                            closeErrorModal();
                        };

                        // 배경(overlay) 클릭 시
                        overlay.onclick = function(e) {
                            if (e.target === overlay) {
                                closeErrorModal();
                            }
                        };

                        // ESC 키 눌렀을 때
                        document.onkeydown = function(e) {
                            if (e.key === 'Escape' && modal.classList.contains('active')) {
                                closeErrorModal();
                                document.onkeydown = null; // 이벤트 제거
                            }
                        };
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

            <!-- 상단(주차/기간): 공통 규격 유지 -->
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
            </div>

            <div class="admin_sub">
                <div class="sub-content">

                    <div class="page-info">
                        <h2 class="page-title">전체 시스템오류 현황</h2>
                    </div>

                    <!-- 검색 영역(2줄): 셀렉트/입력 중심 -->
                    <form id="searchForm" method="post" action="/menu/menuMgr/systemErrorStatus.do">
                        <input type="hidden" id="pageIndex" name="pageIndex"
                               value="${param.pageIndex != null ? param.pageIndex : 1}" />

                        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><label for="orgId">기관</label></span>
                                <div class="itemList">
                                    <select class="form-select" id="orgId" name="orgId" title="기관">
                                        <option value="">전체</option>
                                        <c:forEach var="org" items="${orgList}">
                                            <option value="${org.orgId}">${org.orgnm}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="item">
                                <span class="item_tit"><label for="deptCd">학과/부서</label></span>
                                <div class="itemList">
                                    <select class="form-select" id="deptCd" name="deptCd" title="학과/부서">
                                        <option value="">전체</option>
                                        <c:forEach var="dept" items="${deptList}">
                                            <option value="${dept.deptId}">${dept.deptnm}</option>
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
                                    <option value="10" <c:if test="${param.listScale=='10' || empty param.listScale}">selected</c:if>>10</option>
                                    <option value="20" <c:if test="${param.listScale=='20'}">selected</c:if>>20</option>
                                    <option value="30" <c:if test="${param.listScale=='30'}">selected</c:if>>30</option>
                                    <option value="50" <c:if test="${param.listScale=='50'}">selected</c:if>>50</option>
                                    <option value="100" <c:if test="${param.listScale=='100'}">selected</c:if>>100</option>
                                </select>
                            </div>
                        </div>
                    </form>

                    <!-- 엑셀 submit 전용 폼 -->
                    <form id="excelForm" method="post"></form>

                    <!-- 시스템 오류 목록 (tabulator) -->
                    <div id = "errList"></div>
                    <script>
                    let errListTable = UiTable("errList", {
                        lang: "ko",
                        pageFunc: loadErrorList,
                        columns: [
                            {title:"No", field:"no", headerHozAlign:"center", hozAlign:"center", width:80, minWidth:80},
                            {title:"기관", field:"orgnm", headerHozAlign:"center", hozAlign:"center", width:120, minWidth:120},
                            {title:"학과/부서", field:"deptnm", headerHozAlign:"center", hozAlign:"center", width:150, minWidth:150},
                            {title:"학번/사번", field:"stdntNo", headerHozAlign:"center", hozAlign:"center", width:120, minWidth:120},
                            {title:"일시", field:"regDttm", headerHozAlign:"center", hozAlign:"center", width:180, minWidth:180},
                            {title:"이름", field:"usernm", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},
                            {title:"오류페이지", field:"sysErrPagenm", headerHozAlign:"center", hozAlign:"left", width:0, minWidth:200},
                            {title:"", field:"sysErrMsgId", visible:false},
                            {title:"상세보기", field:"detail", headerHozAlign:"center", hozAlign:"center", width:120, minWidth:120, formatter:"html"}
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
            <div class="modal-body" id="errorDetailModalBody">
            </div>
        </div>
    </div>

    <script src="<%=request.getContextPath()%>/webdoc/assets/js/modal.js" defer></script>

</div>
</body>
</html>