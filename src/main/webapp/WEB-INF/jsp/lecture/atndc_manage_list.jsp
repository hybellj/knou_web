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

	let EPARAM = '<c:out value="${encParams}" />';

	var listAttandanceTable = null;
	
	$(document).ready(function() {
		
		$("#listAttandanceArea").show();
	
	    // 테이블 생성
	    listAttandanceTable = new Tabulator("#listAttandance", {
	        layout: "fitColumns",
	        pagination: false,
	        placeholder: "조회된 데이터가 없습니다.",
	        columns: [
	            {   title: "학과",       	field: "deptnm", 	headerHozAlign:"center",    hozAlign:"center",  width: "20%" },
	            {   title: "학번",       	field: "stdntNo", 	headerHozAlign:"center",    hozAlign:"center",  width: "20%" },
	            {	title: "이름",       	field: "usernm",	headerHozAlign:"center",    hozAlign:"center",  width: "20%" },
	            {	title: "수강생아이디",  visible: false,    	field: "userId"},
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
	                var tableData = createListData(data.returnList);	
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
	function createListData(list) {	
	    var dataList = [];	
	    if (!list) {
	        return dataList;
	    }	
	    $.each(list, function(idx, item) {
	    	//console.log(item);	    	
	    	// goDetail에 들어갈 Key 값 추출
	        var schdlId    = item.lctrWknoSchdlId || "";
	        var userId     = item.userId || "";
	        
	        dataList.push({
	            deptnm 		: item.deptnm 	|| "-",
	            stdntNo 	: item.stdntNo 	|| "-",
	            usernm 		: item.usernm 	|| "-",
	            lrnStscd 	: item.lrnStscd || "-",
	            userId		: item.userId	|| "-",
	            detail : '<button type="button" class="btn basic small" onclick="goDetail(\'' + schdlId + '\', \'' + userId + '\')">상세보기</button>'
	        });	
	    });	
	    return dataList;
	}	
	
	
	function goDetail(lctrWknoSchdlId, stdntId){
		const extData = { "lctrWknoSchdlId": lctrWknoSchdlId , "stdntId": stdntId };		
		dialog101 = UiDialog("attandanceDetailView", {
	        title: "출석상세",
	        width: 1250,
	        height: 768,
	        url: "/lctr/attandanceDetailView.do?encParams=" + EPARAM + "&addParams=" + UiComm.makeEncParams(extData),
	        autoresize: true
	    });
	}

</script>
</head>
<body class="class ${uiex:getTheme()} "><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main" style="padding:3px">
    	<div id="content" class="content-wrap common" style="padding:3px">
			<div class="course_history">
				<div class="h_top">
	                <div class="h_left">
	                    <strong class="tit">1주차 출결관리</strong>
	                </div>
	                <div class="h_right">
	                    <p class="desc">
	                        <span>학습기간<strong>2025.06.02 ~ 2025.06.10</strong></span>
	                        <span>출석<strong>35</strong></span>
	                        <span>지각<strong>3</strong></span>
	                        <span>결석<strong>2</strong></span>
	                    </p>
	                </div>
	            </div>
	            <div class="h_content">
	                <ul class="accordion course_week">
	                    <li class=""><!-- 클릭시 active 추가 -->
	                        <div class="title-wrap">
	                            <a class="title" href="#">
	                                <div class="lecture_box type2">
	                                    <div class="lecture_tit">
	                                        <p class="labels">
	                                            <label class="label s_chasi">1차시</label>
	                                            <label class="label s_basic">동영상</label>
	                                        </p>
	                                        <strong>우리 생활 주변의 데이터베이스</strong>
	                                    </div>
	                                    <div class="btn_right">
	                                        <span>출석율 <strong class="fcBlue">52%</strong></span>
	                                    </div>
	                                    <i class="arrow xi-angle-down"></i>
	                                </div>
	                            </a>
	                        </div>
	                        <div class="cont">
	                            <div class="video-wrap">
	                                <video controls playsinline>
	                                    <source src="https://www.w3schools.com/html/mov_bbb.mp4" type="video/mp4" />
	                                </video>
	                            </div>
	                        </div>
	                    </li>
	                    <li class=""><!-- 클릭시 active 추가 -->
	                        <div class="title-wrap">
	                            <a class="title" href="#">
	                                <div class="lecture_box type2">
	                                    <div class="lecture_tit">
	                                        <p class="labels">
	                                            <label class="label s_chasi">2차시</label>
	                                            <label class="label s_basic">동영상</label>
	                                        </p>
	                                        <strong>데이터베이스 관리 시스템</strong>
	                                    </div>
	                                    <div class="btn_right">
	                                        <span>출석율 <strong class="fcBlue">63%</strong></span>
	                                    </div>
	                                    <i class="arrow xi-angle-down"></i>
	                                </div>
	                            </a>
	                        </div>
	                        <div class="cont">
	                            <div class="video-wrap">
	                                <video controls playsinline>
	                                    <source src="https://www.w3schools.com/html/mov_bbb.mp4" type="video/mp4" />
	                                </video>
	                            </div>
	                        </div>
	                    </li>
	                </ul>	
	            </div>
	         </div>
	
	         <div class="board_top mt30">
	            <!-- search small -->
	            <div class="search-typeC">
	                <input class="form-control" type="text" name="" id="inputSearch1" value="" placeholder="이름/학번/학과 입력">
	                <button type="button" class="btn basic icon search" aria-label="검색"><i class="icon-svg-search"></i></button>
	            </div>
	            <div class="right-area">
	                <button type="button" class="btn basic">메시지 보내기</button>
	                <button type="button" class="btn type2">일괄 출석 관리</button>
	                <button type="button" class="btn type2">엑셀 다운로드</button>
	            </div>
	         </div>
	
			 <!-- 출결관리 -->
	         <div class="table-wrap">
	            <!-- 출결관리 -->
	            <div id="listAttandanceArea" style="display:none; width:100%">         
					<div id="listAttandance" style=""></div>
		        </div>
			</div>			
			<!-- //출결관리 --> 
			
		</div>
		<!--  //content -->
				
	</div>
	<!--  //main -->
	
</body>  
</html>