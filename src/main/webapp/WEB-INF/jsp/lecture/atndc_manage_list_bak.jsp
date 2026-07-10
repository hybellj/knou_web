<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="dashboard"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>

<script type="text/javascript">

	var listAttandanceTable = null;
	
	$(document).ready(function() {
		
		$("#listAttandanceArea").show();
	
	    // 테이블 생성
	    listAttandanceTable = new Tabulator("#listAttandance", {
	        layout: "fitColumns",
	        //layout: "fitData",
	        pagination: false,
	        placeholder: "조회된 데이터가 없습니다.",
	        columns: [
	            {   title: "학과",       	field: "deptnm", 	headerHozAlign:"center",    hozAlign:"center",  width: "20%" },
	            {   title: "학번",       	field: "stdntNo", 	headerHozAlign:"center",    hozAlign:"center",  width: "20%" },
	            {	title: "이름",       	field: "usernm",	headerHozAlign:"center",    hozAlign:"center",  width: "20%" },
	            {	title: "출결상태",		field: "lrnStscd",	headerHozAlign:"center",    hozAlign:"center",  width: "20%" },
	            {	title: "상세",		field: "detail",	headerHozAlign:"center",    hozAlign:"center",  width: "20%", formatter: "html"}
	        ]
	    });	
	    	
	    loadListAttandance();
	});	
	
	/* 목록 조회 */
	function loadListAttandance() {
	
	    $.ajax({
	        url: "/lctr/attandanceList.do",
	        type: "POST",
	        dataType: "json",
	        data: {
	            orgId: $("#orgId").val() || '',
	            searchValue: $("#searchType").val() || '',
	            lctrWknoSchdlId: '${param.lctrWknoSchdlId}'
	        },
	        beforeSend: function() {
	            UiComm.showLoading(true);
	        },
	        success: function(data) {
	        	
	            if (data.result > 0) {	
	                var tableData = createListData(data.returnList || [],data.pageInfo);	
	                listAttandanceTable.setData(tableData);	
	            } else {	
	                listAttandanceTable.clearData();
	            }	
	        },
	        error: function(xhr) {	
	            console.log(xhr);	
	            UiComm.showMessage("오류가 발생했습니다.", "error");	
	            if (listAttandanceTable) {
	            	listAttandanceTable.clearData();
	            }	
	        },
	        complete: function() {
	            UiComm.showLoading(false);
	        }
	    });
	}	
	
	/* 데이터 생성 */
	function createListData(list, pageInfo) {	
	    var dataList = [];	
	    if (!list) {
	        return dataList;
	    }	
	    $.each(list, function(idx, item) {	
	        dataList.push({
	            deptnm 		: item.deptnm 	|| "-",
	            stdntNo 	: item.stdntNo 	|| "-",
	            usernm 		: item.usernm 	|| "-",
	            lrnStscd 	: item.lrnStscd || "-",
	            detail 		: '<button type="button" class="btn basic small" onclick="goDetail(\'${param.lctrWknoSchdlId}\')">상세보기</button>'
	        });	
	    });	
	    return dataList;
	}	
	
	function goDetail(lctrWknoSchdlId){
		const url = "/lrn/lrnDataAddPop.do?lctrWknoSchdlId=" + lctrWknoSchdlId;
	    window.open(url,"lrnDataAddPop","width=1024,height=768,scrollbars=yes,resizable=yes");
	}

</script>
</head>
                <div class="sub-content">
                    <div class="board_top">
                        <h3 class="board-title">1주차 출결관리 - 학습기간: 2026.03.05 ~ 2026.03.16 / 출석 35 / 지각 3 / 결석 2</h3>
                        <div class="search-typeA">
	                        <div class="item">
	                            <div class="itemList">
	                            	1차시 통영상 콘텐츠 제목 1  / 출석률 52%      
	                            </div>	                            
	                            <div class="itemList">
	                            	2차시 통영상 콘텐츠 제목 2  / 출석률 63%       
	                            </div>
	                        </div> 
	                    </div>
                    </div>

                    <!-- 출결관리 -->
                    <div class="table-wrap">
                    
                    	<div class="board_top in_table">
                    	
                            <!-- search small -->
                            <div class="search-typeC">
                                <input class="form-control" type="text" name="" id="inputSearch1" value="" placeholder="학과/학번/이름 입력">
                                <button type="button" class="btn basic icon search" aria-label="검색"><i class="icon-svg-search"></i></button>
                            </div>
                            
                           	<div> 
                                <button type="button" class="btn gray1" onclick="">보내기</button>
                                <button type="button" class="btn gray1" onclick="">일괄 출석 처리</button>
                                <button type="button" class="btn gray1" onclick="">일괄 출석 취소</button>
                                <button type="button" class="btn gray1" onclick="">엑셀다운로드</button>	                                
	                        </div>
                        </div>                 
		                
		                <div class="board_top t_line">
                            <h4 class="sub-title">출결관리</h4>
                        </div>
                        
                        <!-- 출결관리 -->
                        <div id="listAttandanceArea" style="display:none; width:100%">         
	                        <div id="listAttandance" style=""></div>
	                    </div>
                        <!-- //출결관리 -->
                    </div>         	
            	</div> 
</html>