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

	var listLrnHstryTable = null;
	
	$(document).ready(function() {		
		$("#listLrnHstryArea").show();	
	    // 테이블 생성
	    listLrnHstryTable = new Tabulator("#listLrnHstryArea", {
	        layout: "fitColumns",
	        pagination: false,
	        placeholder: "조회된 데이터가 없습니다.",
	        columns: [
	            {   title: "번호",       		field: "no", 			headerHozAlign:"center",    hozAlign:"center" },
	            {   title: "학습일시",     	field: "lrnDttm", 		headerHozAlign:"center",    hozAlign:"center" },
	            {	title: "학습시간",     	field: "lrnMnts",		headerHozAlign:"center",    hozAlign:"center" },
	            {	title: "사용자OS",		field: "userOS",		headerHozAlign:"center",    hozAlign:"center" },
	            {	title: "사용자BROWSER",	field: "userBrowser",	headerHozAlign:"center",    hozAlign:"center" },
	            {	title: "사용자IP",		field: "userIp",		headerHozAlign:"center",    hozAlign:"center" }
	        ]
	    });	    	
	    loadListLrnHstry();
	});	
	
	/* 학생의주차별출석목록조회 */
	function loadListLrnHstry() {	
	    $.ajax({
	        url: "/lctr/byWknoStdntAttandanceList.do",
	        type: "POST",
	        dataType: "json",
	        data: {
	            lctrWknoSchdlId: '${lecturVO.lctrWknoSchdlId}',
	            stdntId: '${lecturVO.stdntId}',
	            encParams : EPARAM
	        },
	        beforeSend: function() {
	            UiComm.showLoading(true);
	        },
	        success: function(data) {
	        	
	            if (data.result > 0) {	
	                var tableData = createListData(data.returnList || [],data.pageInfo);	
	                listLrnHstryTable.setData(tableData);	
	            } else {	
	            	listLrnHstryTable.clearData();
	            }	
	        },
	        error: function(xhr) {	
	            console.log(xhr);	
	            UiComm.showMessage("오류가 발생했습니다.", "error");	
	            if (listLrnHstryTable) {
	            	listLrnHstryTable.clearData();
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
	            no 			: ""	|| "-",
	            lrnDttm 	: "" 	|| "-",
	            lrnMnts 	: "" 	|| "-",
	            userOS 		: ""	|| "-",
	            userBrowser : ""	|| "-",
	            userIp		: "" 	|| "-",
	            detail 		: '<button type="button" class="btn basic small" onclick="goDetail(\'${param.lctrWknoSchdlId}\')">상세보기</button>'
	        });	
	    });	
	    return dataList;
	}	
	
</script>
</head>
<body class="class ${uiex:getTheme()} "><!-- 컬러선택시 클래스변경 -->

	<!-- main -->
    <!-- <div id="wrap" class="main">-->
    
    	<!-- content -->
    	<!-- <div id="content" class="content-wrap common" style="padding:3px">-->
    	
            <div class="modal-content modal-xl" tabindex="-1">
                
                <div class="modal-body">

                    <div class="sub-box">
                        <div class="board_top">
                            <h3 class="board-title">수강생 정보</h3>
                            <div class="right-area">
                                <button type="button" class="btn basic">메시지 보내기</button>
                            </div>
                        </div>
                        <div class="user-wrap mb10">
                            <div class="user-img">
                                <div class="user-photo">
                                    <!--프로필 사진-->
                                    <img src="/webdoc/assets/img/common/default_stu.png" alt="사진">
                                </div>
                            </div>

                            <div class="table_list">
                                <ul class="list">
                                    <li class="head"><label>기관</label></li>
                                    <li>대학원 / 평생교육원 / 학위과정</li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label>이름</label></li>
                                    <li>학습자4</li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label>학번</label></li>
                                    <li>2021215478</li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label>아이디</label></li>
                                    <li>TESTID04</li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label>휴대폰번호</label></li>
                                    <li>010-1234-5698</li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label>사용 이메일</label></li>
                                    <li>k202154774@knou.ac.kr (연계 이메일)</li>
                                </ul>
                            </div>

                        </div>
                    </div>
                    
                    <div class="board_top">
                        <h3 class="board-title">주차별 학습기록</h3>
                        <span class="info_inline">
                            <select class="form-select" id="selectDate1">
                                <option value="3주차">3주차</option>
                            </select>
                        </span>                            
                        <div class="right-area">
                            <div class="state-txt-label">
                                <p><span class="state_ok" aria-label="출석">○</span> 출석</p><!-- 출결기준 테이블 학습기간내진행율 만족시 출석 -->
                                <p><span class="state_late" aria-label="지각">△</span> 지각</p><!-- 출결기준 -->
                                <p><span class="state_no" aria-label="결석">X</span> 결석</p>
                            </div>
                        </div>
                    </div>
                    <div class="course_history">
                        <div class="h_top">
                            <div class="h_left">
                                <strong class="tit">3주차 학습기록</strong>
                                <p class="desc">
                                    <span>학습기간<strong>2025.06.02 ~ 2025.06.10</strong></span>
                                    <span><strong>106분[총 동영상 플레이시간] 분으로...</strong></span>
                                    <span><strong>순차학습</strong></span>
                                </p>
                            </div>
                            <div class="h_right">
                                <p class="desc">
                                    <span><span class="state_no" aria-label="결석">X</span><strong>결석, 학습기간안에 출석기준율을 넘어가야 출석, 기간외 합산 출석기준율 넘으면 지각, 기간외까지 합산 기준을 못 넘으면 결석</strong></span>
                                    <span><strong>106분</strong></span>
                                    <span>학습시간<strong>10분 30초 ( 기간 후 : 5분 30초 - 학습기간이외의 학습시간)</strong></span>                                        
                                </p>                                    
                                <button class="btn s_type2">출석처리</button>
                                <button class="btn s_type2">출석처리 취소</button>
                            </div>
                        </div>
                        <div class="h_content">
                            <ul class="accordion course_week">
                                <li class="active"><!-- 클릭시 active 추가 -->
                                    <div class="title-wrap">
                                        <div class="chasi_tit">[ 1차시 ] 차시제목1</div>
                                        <a class="title" href="#">
                                            <div class="lecture_box work">
                                                <div class="lecture_tit">
                                                    <p class="labels">
                                                        <label class="label s_basic">동영상</label>
                                                    </p>
                                                    <strong>우리 생활 주변의 데이터베이스</strong>
                                                </div>
                                                <p class="desc">
                                                    <span>학습기간<strong>2026.03.05 ~ 2026.03.16</strong></span>
                                                    <span><strong>37분</strong></span>
                                                    <span><strong>출결대상</strong></span>
                                                </p>
                                                <div class="btn_right">
                                                    <label class="state">학습완료</label>
                                                </div>
                                                <i class="arrow xi-angle-down"></i>
                                            </div>
                                        </a>                                            
                                    </div>
                                    <div class="cont">
                                        <div class="table-wrap scroll">
                                            <table class="table-type1">
                                                <colgroup>
                                                    <col style="width:7%">
                                                    <col style="width:20%">
                                                    <col style="width:10%">
                                                    <col style="width:14%">
                                                    <col style="">
                                                    <col style="width:16%">                                                        
                                                </colgroup>
                                                <thead>
                                                    <tr>
                                                        <th colspan="6" class="all">학습기록</th>                                                                                          
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td data-th="번호">316</td>
                                                        <td data-th="접속일시">2026.03.15 16:28:32</td>
                                                        <td data-th="학습시간">[1] 25:34</td>
                                                        <td data-th="운영체제">Window10</td> 
                                                        <td data-th="내용">chome, Play, 1.2X (PAGE:3, start 16:13:02)</td> 
                                                        <td data-th="IP">125.207.131.148</td>                                   
                                                    </tr>
                                                    <tr>
                                                        <td data-th="번호">316</td>
                                                        <td data-th="접속일시">2026.03.15 16:28:32</td>
                                                        <td data-th="학습시간">[1] 25:34</td>
                                                        <td data-th="운영체제">Window10</td> 
                                                        <td data-th="내용">chome, Play, 1.2X (PAGE:3, start 16:13:02)</td> 
                                                        <td data-th="IP">125.207.131.148</td>                                   
                                                    </tr>
                                                    <tr>
                                                        <td data-th="번호">316</td>
                                                        <td data-th="접속일시">2026.03.15 16:28:32</td>
                                                        <td data-th="학습시간">[1] 25:34</td>
                                                        <td data-th="운영체제">Window10</td> 
                                                        <td data-th="내용">chome, Play, 1.2X (PAGE:3, start 16:13:02)</td> 
                                                        <td data-th="IP">125.207.131.148</td>                                   
                                                    </tr>
                                                    <tr>
                                                        <td data-th="번호">316</td>
                                                        <td data-th="접속일시">2026.03.15 16:28:32</td>
                                                        <td data-th="학습시간">[1] 25:34</td>
                                                        <td data-th="운영체제">Window10</td> 
                                                        <td data-th="내용">chome, Play, 1.2X (PAGE:3, start 16:13:02)</td> 
                                                        <td data-th="IP">125.207.131.148</td>                                   
                                                    </tr>                                
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </li>                               
                                <li class=""><!-- 클릭시 active 추가 -->
                                    <div class="title-wrap">
                                        <div class="chasi_tit">[ 2차시 ] 차시제목1</div>
                                        <a class="title" href="#">
                                            
                                            <div class="lecture_box work">
                                                <div class="lecture_tit">
                                                    <p class="labels">
                                                        <label class="label s_basic">동영상</label>
                                                    </p>
                                                    <strong>데이터베이스 관리 시스템</strong>
                                                </div>
                                                <p class="desc">
                                                    <span>학습기간<strong>2026.03.05 ~ 2026.03.16</strong></span>
                                                    <span><strong>37분</strong></span>
                                                    <span><strong>출결대상</strong></span>
                                                </p>                                                
                                                <div class="btn_right">
                                                    <label class="state">학습중</label>
                                                </div>
                                                <i class="arrow xi-angle-down"></i>
                                            </div>
                                        </a>                                            
                                    </div>
                                    <div class="cont">
                                        <div class="table-wrap scroll">
                                            <table class="table-type1">
                                                <colgroup>
                                                    <col style="width:7%">
                                                    <col style="width:20%">
                                                    <col style="width:10%">
                                                    <col style="width:14%">
                                                    <col style="">
                                                    <col style="width:16%">                                                        
                                                </colgroup>
                                                <thead>
                                                    <tr>
                                                        <th colspan="6" class="all">학습기록</th>                                                                                          
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td data-th="번호">316</td>
                                                        <td data-th="접속일시">2026.03.15 16:28:32</td>
                                                        <td data-th="학습시간">[1] 25:34</td>
                                                        <td data-th="운영체제">Window10</td> 
                                                        <td data-th="내용">chome, Play, 1.2X (PAGE:3, start 16:13:02)</td> 
                                                        <td data-th="IP">125.207.131.148</td>                                   
                                                    </tr> 
                                                    <tr>
                                                        <td data-th="번호">316</td>
                                                        <td data-th="접속일시">2026.03.15 16:28:32</td>
                                                        <td data-th="학습시간">[1] 25:34</td>
                                                        <td data-th="운영체제">Window10</td> 
                                                        <td data-th="내용">chome, Play, 1.2X (PAGE:3, start 16:13:02)</td> 
                                                        <td data-th="IP">125.207.131.148</td>                                   
                                                    </tr> 
                                                    <tr>
                                                        <td data-th="번호">316</td>
                                                        <td data-th="접속일시">2026.03.15 16:28:32</td>
                                                        <td data-th="학습시간">[1] 25:34</td>
                                                        <td data-th="운영체제">Window10</td> 
                                                        <td data-th="내용">chome, Play, 1.2X (PAGE:3, start 16:13:02)</td> 
                                                        <td data-th="IP">125.207.131.148</td>                                   
                                                    </tr> 
                                                    <tr>
                                                        <td data-th="번호">316</td>
                                                        <td data-th="접속일시">2026.03.15 16:28:32</td>
                                                        <td data-th="학습시간">[1] 25:34</td>
                                                        <td data-th="운영체제">Window10</td> 
                                                        <td data-th="내용">chome, Play, 1.2X (PAGE:3, start 16:13:02)</td> 
                                                        <td data-th="IP">125.207.131.148</td>                                   
                                                    </tr>                                                                                  
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </li>
                            </ul>

                        </div>
                    </div>

                    <div class="modal_btns">
                        <button type="button" class="btn type2">닫기</button>
                    </div>
                </div>
            </div>


	        <!-- Modal 4 출석 관리 사유 -->
	        <div class="modal-overlay" id="modal4" role="dialog" aria-modal="true" aria-hidden="true" aria-labelledby="modal4Title" >
	            <div class="modal-content modal-lg" tabindex="-1">
	                <div class="modal-header">
	                    <h2 id="modal4Title">출석 관리 사유</h2>
	                    <button class="modal-close" aria-label="닫기"><i class="icon-svg-close"></i></button>
	                </div>
	                <div class="modal-body">
	                    <!--등록-->
	                    <textarea class="form-control width-100per min-height-200px" placeholder="사유 입력"></textarea>
	
	                    <div class="modal_btns">
	                        <button type="button" class="btn type2">닫기</button>
	                    </div>
	                </div>
	            </div>
	        </div>
	        <!-- //Modal 4 출석 관리 사유 -->
        
        <!-- </div> -->
        <!-- //content -->
        
	<!-- </div> -->
	<!-- //main -->
</body> 
</html>