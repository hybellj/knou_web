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
            
        });
        
        function goModify() {
        	
        	UiComm.showMessage('수정하시겠습니까?', 'confirm').then(function(ok) {
                if(!ok) {
                    return;
                } else {
                
		            $.ajax({
		                url : "/acad/schdl/admAcademicScheduleModify.do",
		                type : "POST",
		                dataType : "json",
		                data : $("#modifyForm").serialize()
		                
		            }).done(function(data) {
		
		                if (data.result > 0 || data.successCount > 0) {
		                	UiComm.showMessage("수정 완료하였습니다.");
		
		                    // 현재 페이지 그대로 유지
		                    // 필요시 수정된 PK 세팅
		                    // $("#acadSchdlId").val(data.acadSchdlId);
		
		                } else {
		                	UiComm.showMessage(data.message || "수정에 실패하였습니다.");
		                }
		
		            }).fail(function(xhr) {
		            	UiComm.showMessage("수정 중 오류가 발생하였습니다.");
		            });
                }
        	});
        }
        
        function goList(){        	
        	// 파라미터를 구질구질하게 붙이지 않고 깔끔하게 원래 목록 URL로만 보냅니다.
            // 인터셉터가 GLOBAL 세션에서 대메뉴/소메뉴 ID를 자동으로 매핑해 줍니다.
            location.href = "/acad/schdl/admAcademicScheduleListView.do";
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
						<h2 class="page-title">업무 일정관리</h2> <%-- 현재 메뉴명 --%>
                    	<uiex:navibar type="admin"/><%-- 네비게이션바 --%>
                    </div>
                    <!-- 검색 영역(2줄): 셀렉트/입력 중심 -->
                    
                    수정
                   	<div class="button-area">
	                    <button type="button" class="btn search" onclick="goModify();">수정</button>
	                    <button type="button" class="btn search" onclick="goList();">목록</button>
					</div>

					<form id="modifyForm" name="modifyForm">
						<input type="hidden" id="acadSchdlId" name="acadSchdlId" value="${param.acadSchdlId}">
	                    <div class="search-typeA">
	                     	<div class="item">
	                            <span class="item_tit"><label for="orgId">기관</label></span>
	                            <input type="hidden" id="orgId" name="orgId" value="${userCtx.loginUser.orgId}">
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
	                            <span class="item_tit"><label for="searchType">시작일시/종료일시</label></span>
	                            <div class="itemList">
	                                <input type="text" id="acadSchdlSdttm" name="acadSchdlSdttm" value="20260610172900"> 
	                                - <input type="text" id="acadSchdlEdttm" name="acadSchdlEdttm" value="20260630172900">
	                            </div>
	                        </div>
	                        <div class="item">
	                            <span class="item_tit"><label for="searchType">업무일정명</label></span>
	                            <div class="itemList">                                
	                            	<input type="text" id="acadSchdlTynm" name="acadSchdlTynm" value="일정">
	                            </div>
	                        </div>
	                        <div class="item">
	                            <span class="item_tit"><label for="searchType">업무코드</label></span>
	                            	<input type="text" id="acadSchdlTycd" name="acadSchdlTycd" value="PROF_ACS_PSBL_PRD">
	                            <div class="itemList">                                
	                            </div>
	                        </div>
	                        <div class="item">
	                            <span class="item_tit"><label for="searchType">설명</label></span>
	                            <div class="itemList">                                
	                            	<input type="text" id="acadSchdlExpln" name="acadSchdlExpln" value="설명수정">  
	                            </div>
	                        </div> 
	                    </div>
                    </form>
                    
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>