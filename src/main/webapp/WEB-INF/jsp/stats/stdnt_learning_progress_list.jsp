<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="module" value="table"/>
	</jsp:include>
</head>
<script type="text/javascript">

		var dialog;
		// escapeJavaScript="true" 속성을 추가하여 문자열 깨짐 및 문법 에러를 방지합니다.
		var SEARCH_VALUE	= '<c:out value="${vo.searchValue}" escapeXml="false" />';
		var PAGE_INDEX		= '<c:out value="${vo.pageIndex}" />';
		var LIST_SCALE		= '<c:out value="${vo.listScale}" />';
		var EPARAM 			= '<c:out value="${encParams}" />';
		var SBJCT_ID        = '<c:out value="${vo.sbjctId}" />';
		
		var listTable;		

		$(document).ready(function () {
			console.log('start');
			
			if(!PAGE_INDEX) {
				PAGE_INDEX = 1;
			}
			
			// 1. 테이블 초기화 함수 호출
			initListTable();
			
			// 2. 비동기 꼬임 방지를 위해 ready 시점에 명시적으로 첫 데이터 호출
			getList(PAGE_INDEX);
			
			// 검색창 엔터키 이벤트
			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					getList(1);
				}
			});
		});
		
		// list scale 변경
	    function changeListScale(scale) {
	        LIST_SCALE = scale;
	        getList(1);
	    }
		
	    /**
	     * 학습진도목록조회
	     */
	    function getList(page) {	
	        console.log('getList>>>>' + page);
	        PAGE_INDEX = page;
	        
	        var isUnlearned = $("#checkType1").is(":checked") ? "Y" : "N"; 
	        var minPercent  = $("#minPercentInput").val(); 
	        var maxPercent  = $("#maxPercentInput").val(); 

	        var extData = {
	            "pageIndex" 	: page,
	            "listScale" 	: LIST_SCALE,
	            "sbjctId"		: SBJCT_ID,
	            "isUnlearned"   : isUnlearned,
	            "minPercent"    : minPercent,
	            "maxPercent"    : maxPercent
	        };			
	        
	        var url = "/stats/bySubjectLearningProgressListPaging.do";
	        var param = {
	              encParams	: EPARAM
	            , addParams	: UiComm.makeEncParams(extData)
	        };
	        
	        UiComm.showLoading(true);
	        
	        $.ajax({
	            url      : url,
	            type     : "POST",
	            dataType : "json",
	            data     : param
	        }).done(function(data) {

	            console.log('get List Success');
	            UiComm.showLoading(false);

	            if (data.encParams != null && data.encParams != '') {
	                EPARAM = data.encParams;
	            }

	            if (data.result > 0) {

	                // 총 건수 표시
	                if (data.pageInfo) {
	                	$(".totalRecordCount").text(data.pageInfo.totalRecordCount);
	                } else {
	                    $(".totalRecordCount").text("0");
	                }

	                console.log('set list table');

	                const cleanData = createListHTML(data.returnList);

	                // 테이블 데이터 설정
	                listTable.clearData();
	                listTable.replaceData(cleanData);

	                // 페이지 정보 설정
	                if (data.pageInfo) {

	                    listTable.setPageInfo(data.pageInfo);

	                } else {

	                    listTable.setPageInfo({
	                        currentPageNo       : PAGE_INDEX,
	                        recordCountPerPage  : LIST_SCALE,
	                        totalRecordCount    : 0
	                    });
	                }

	                $("#listArea").show();

	            } else {

	                $(".totalRecordCount").text("0");
	                UiComm.showMessage(data.message, "error");
	            }

	        }).fail(function() {

	            UiComm.showLoading(false);
	            $(".totalRecordCount").text("0");

	            UiComm.showMessage("<spring:message code='exam.error.list' />", "error");
	        });

	        console.log('호출완료>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
	    }
		 
	    function initListTable() {
	        console.log('initListTable');
	        
	        listTable = UiTable("list", {
	            selectRow: "checkbox",
	            pageFunc: getList, 
	            columns: [	                
	                { title: "No", 			field: "no", 			hozAlign: "center",	headerHozAlign: "center",	widthGrow: 1 },
	                { title: "이름", 			field: "usernm", 		hozAlign: "center",	headerHozAlign: "center", 	widthGrow: 1 },
	                { title: "사용자아이디", 	field: "userId", 		hozAlign: "center",	headerHozAlign: "center",	widthGrow: 1 },
	                { title: "학번", 			field: "stdntNo", 		hozAlign: "center",	headerHozAlign: "center",	widthGrow: 1 },
	                { title: "학년", 			field: "scyr", 			hozAlign: "center",	headerHozAlign: "center",	widthGrow: 1 },
	                { title: "오픈차시", 		field: "currWkno",		hozAlign: "center",	headerHozAlign: "center",	widthGrow: 1 },
	                { title: "학습차시", 		field: "learnWkno" ,	hozAlign: "center", headerHozAlign: "center", 	widthGrow: 1 },
	                { title: "출석율", 		field: "atndcRt",		hozAlign: "center", headerHozAlign: "center", 	widthGrow: 1 }
	            ]
	        });	        
	    }
		 
		function createListHTML(list) {			 
			console.log('create list');
						
			return list.map(v => ({
				no:				v.lineNo,
				sbjctId: 		v.sbjctId,
				userId: 		v.userId,			    
			    usernm:			v.usernm,
			    stdntNo:		v.stdntNo,
			    scyr: 			v.scyr,
			    currWkno: 		v.currWkno,
			    learnWkno: 		v.learnWkno,
			    atndcRt:		v.atndcRt,		            
			    sts: 			v.extSbmsnEdttm			    
			}));
		}
		 
</script>
<body class="class ${uiex:getTheme()} ">

                        <div class="page-info">
                            <h2 class="page-title">학습진도관리</h2>                            
                        </div>
						<br>
                        <div class="msg-box info">
                            <p class="txt">운영과목과 수강생의 학습현황을 조회할 수 있습니다. <strong>학습 부진자 관리</strong>에 활용하시기 바랍니다.</p>
                        </div>
                        <div class="msg-box basic">
                            <ul class="list-dot">
                                <li>출석율은 현재 오픈 차시 중 정상 출석한 차시에 대한 비율로 표기됩니다.</li>
                                <li>매 주차별로 부진자 (출석율 100% 미만)에게 알림 발송 가능합니다.</li>
                                <li>운영과목 수강생의 수에 따라 조회에 다소 시간이 걸릴 수 있습니다</li>
                            </ul>
                        </div>

                        <div class="search-typeA">                            
                            <div class="item">
                                <div class="itemList">
                                    <span class="custom-input">
                                        <input type="checkbox" name="name" id="checkType1">
                                        <label for="checkType1">미학습자 전체</label>
                                    </span>
                                    <div class="percent_area">
                                        <span class="tit">출석률</span>
                                        <div class="input_btn">
                                            <input class="form-control sm" id="minPercentInput" type="text" maxlength="2"><label>% 이상</label>
                                        </div>
                                        <span class="txt-sort">~</span>
                                        <div class="input_btn">
                                            <input class="form-control sm" id="maxPercentInput" type="text" maxlength="2"><label>% 미만</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="getList(1)"><spring:message code='button.search'/></button>
                            </div>
                        </div>

                        <div class="lecture_status_box full">
                            <div class="box_item">
                                <div class="title">운영과목<i class="xi-angle-right-min"></i></div>
                                <div class="item_txt">
                                    <p class="desc"><i class="icon-svg-group" aria-hidden="true"></i>수강생 수 : <strong><span class="totalRecordCount"></span>명</strong></p>
                                    <p class="desc"><i class="icon-svg-bar-chart" aria-hidden="true"></i>평균 학습 진도율 : <strong>66%</strong></p>
                                </div>
                            </div>
                        </div>

                        <div class="board_top">
                            <h3 class="board-title">학습진도현황</h3> [ 총 건수 : <span class="totalRecordCount"></span> 건]
                            <div class="right-area">
                                <button type="button" class="btn basic">메시지 보내기</button>
                                <button type="button" class="btn basic">엑셀 다운로드</button>
                                <uiex:listScale func="changeListScale" value="${vo.listScale}"/>
                            </div>
                        </div>

                        <div id="listArea" style="display:none;">             
	                        <div id="list"></div>                        
	                        <div id="list_cardForm" class="lecture_box" style="display:none">
	                            <div class="card-header">
	                                <label class="label s_c02"></label>
	                                <div class="card-title"></div>                            
	                            </div>	
	                            <div class="card-body">
	                                <div class="extra">
	                                    <ul class="process-bar">
	                                        <li class="bar-blue" style="width:20%;"></li>
	                                        <li class="bar-grey" style="width:80%;"></li>
	                                    </ul>
	                                    <div class="desc">
	                                        <p><label>이름</label><strong>#[usernm]</strong></p>
	                                        <p><label>사용자아이디</label><strong>#[userId]</strong></p>
	                                        <p><label>학번</label><strong>#[stdntNo]</strong></p>
	                                        <p><label>오픈차시</label><strong>#[currWkno]</strong></p>
	                                        <p><label>학습차시</label><strong>#[learnWkno]</strong></p>
	                                        <p><label>출석율</label><strong>#[atndcRt]</strong></p>
	                                    </div>
	                                </div>
	                            </div>
	                        </div>
                    	</div>                        
                    </div>                    
                </div>
</body>
</html>