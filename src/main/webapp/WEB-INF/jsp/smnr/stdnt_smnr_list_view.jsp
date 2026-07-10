<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/smnr/common/smnr_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="module" value="table"/>
	</jsp:include>

	<script type="text/javascript">
		var SEARCH_VALUE	= '<c:out value="${vo.searchValue}" />';
		var PAGE_INDEX		= '<c:out value="${vo.pageIndex}" />';
		var LIST_SCALE		= '<c:out value="${vo.listScale}" />';

		$(document).ready(function () {
			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					smnrListSelect(1);
				}
			});

			if(!PAGE_INDEX) {
				PAGE_INDEX = 1;
			}

			smnrListSelect(PAGE_INDEX);
		});

		// list scale 변경
		function changeListScale(scale) {
			LIST_SCALE = scale;
			smnrListSelect(1);
		}

		/**
		 * 세미나목록조회
		 * @param page	이동페이지
		 */
		function smnrListSelect(pageNo) {
			PAGE_INDEX   = pageNo;
			SEARCH_VALUE = $("#searchValue").val();

			const url   = "/smnr/stdntSmnrListAjax.do";
			const param = {
				currentPageNo 		: PAGE_INDEX,
				recordCountPerPage 	: LIST_SCALE,
				searchValue 		: SEARCH_VALUE,
				pageSize 			: 10,
				sbjctId				: "${vo.sbjctId}"
			};

			$.ajax({
                url			: url,
                type		: "POST",
                data		: param,
                dataType	: "json",
                beforeSend	: () => UiComm.showLoading(true),
                success		: function(data) {
                    if (data.result > 0) {
    	            	let dataList = createSmnrListHTML(data.returnList);	// 세미나 리스트 HTML 생성

    	        		smnrListTable.clearData();
    	        		smnrListTable.replaceData(dataList);
    	        		smnrListTable.setPageInfo(data.pageInfo);
                    } else {
                    	UiComm.showMessage(data.message, "error");
                    }
                },
                error		: () => UiComm.showMessage("<spring:message code='exam.error.list' />", "error"),/* 리스트 조회 중 에러가 발생하였습니다. */
                complete	: () => UiComm.showLoading(false)
            });
		}

		// 세미나 리스트 HTML 생성
		function createSmnrListHTML(smnrList) {
			let dataList = [];

			if(smnrList.length == 0) {
				return dataList;
			} else {
				smnrList.forEach(function(v,i) {
					// 참석시간
					let atndScnds = "-";
					let hours = Math.floor(v.atndScnds / 3600);
                    let minutes = Math.floor((v.atndScnds % 3600) / 60);
                    let seconds = v.atndScnds % 60;
                    atndScnds = hours > 0 ? hours + ":" : "";
                    atndScnds += (minutes < 10 ? "0" + minutes : minutes) + ":";
                    atndScnds += seconds < 10 ? "0" + seconds : seconds;
					// 진행상태
					let prgrsStatus = {
						"IN_PROGRESS" 	: "진행 중",
						"PRE_SMNR"		: "진행 전",
						"DONE"			: "마감",
						"ERROR"			: "-"
					};
					// 참석상태
					let atndStatus = "<label class='fcRed'>미참석</label>";
					if(v.atndEdttm != null) {
						atndStatus = "참석";
					}
					// ZOOM 참여
					let manage = "-";
					if(v.smnrPrgrsSts == "IN_PROGRESS" && v.smnrGbncd == "ONLN_SMNR") {
						manage = "<a style='line-height: 40px;' href='javascript:zoomUserStart(\"" + v.smnrId + "\")' class='btn basic small'>참여하기</a>";
					} else if(v.smnrPrgrsSts == "DONE") {
						manage = "<a style='line-height: 40px;' href='javascript:smnrViewMv(\""+v.smnrId+"\", \"VIEW\", \"" + v.upSmnrId + "\")' class='btn basic small'>참여정보​</a>";
					}
					dataList.push({
						no: 				v.lineNo,
						smnrGbn: 			v.smnrGbn == "SMNR_TEAM" ? "세미나 팀" : "세미나",
						smnrGbnnm: 			v.smnrGbnnm,
						smnrnm: 			"<a href='javascript:smnrViewMv(\""+v.smnrId+"\", \"VIEW\", \"" + v.upSmnrId + "\")' class='header header-icon link'>" + v.smnrnm + "</a>",
						smnrDttm: 			UiComm.formatDate(v.smnrSdttm, "datetime2") + " ~ " + UiComm.formatDate(v.smnrEdttm, "datetime2"),
						smnrMnts:			v.smnrMnts + "분",
						atndScnds: 			atndScnds,
						mrkRfltyn: 			v.mrkRfltyn,
						prgrsStatus: 		prgrsStatus[v.smnrPrgrsSts],
						atndStatus: 		atndStatus,
						atndEvlScr: 		v.atndEvlyn == "Y" ? v.atndEvlScr + "점" : "-",
						fdbk: 				"<a href='javascript:fdbkPopup(\"" + v.smnrId + "\")' class='fcBlue'>" + v.fdbkCnt + "</a>",
						manage: 			manage,
						smnrId: 			v.smnrId
					});
				});
			}

			return dataList;
		}

		// 피드백 팝업
        function fdbkPopup(smnrId) {
            const data = "smnrId="+smnrId+"&userId=${vo.userId}";
            dialog = UiDialog("dialog1", {
                title		: "피드백",
                width		: 1000,
                height		: 350,
                url			: "/smnr/smnrFdbkPopup.do?" + data,
                autoresize	: true
            });
        }

		// ZOOM 참여자 시작
		function zoomUserStart(smnrId) {
			const url  = "/zoom/zoomUserUrlSelectAjax.do";
			const data = {
	   			smnrId : smnrId
	   		};

			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					let windowOpener = window.open();
					windowOpener.location = data.data.trgtrCntnUrl;
	        	} else {
	        		UiComm.showMessage(data.message, "error");
	        	}
			}, function(xhr, status, error) {
				UiComm.showMessage('<spring:message code="fail.common.msg" />', "error");// 에러가 발생했습니다!
			}, true);
		}
	</script>
</head>

<body class="class ${uiex:getTheme()}">
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>
        <!-- //common header -->

        <!-- classroom -->
        <main class="common">

        	<!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_stu.jsp"/>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
				<!-- class_sub_top -->
				<jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>
				<!-- //class_sub_top -->

		        <div class="class_sub">
					<!-- class_info -->
					<jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>
					<!-- //class_info -->

		        	<div class="sub-content">
				        <div class="page-info">
				        	<h2 class="page-title">
                                세미나
                            </h2>
				        </div>
				        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><label for="searchValue"><spring:message code='common.search.keyword'/></label></span><%-- 검색어 --%>
                                <div class="itemList">
                                    <input class="form-control wide" type="text" name="" id="searchValue" value="${vo.searchValue}" placeholder="세미나명 입력">
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="smnrListSelect(1)"><spring:message code='button.search'/></button><%-- 검색 --%>
                            </div>
                        </div>

						<div id="smnrListArea">
							<div class="board_top">
	                            <h3 class="board-title">목록</h3>
	                            <div class="right-area">
									<%-- 리스트/카드 선택 버튼 --%>
									<span class="list-card-button"></span>

									<%-- 목록 스케일 선택 --%>
									<uiex:listScale func="changeListScale" value="${vo.listScale}" />
	                            </div>
	                        </div>

	                        <%-- 설문 리스트 --%>
							<div id="list"></div>

							<%-- 게시글 리스트 카드 폼 --%>
							<div id="list_cardForm" class="lecture_box" style="display:none">
								<div class="card-header">
									#[smnrGbn]
									<div class="card-title">
										#[smnrnm]
									</div>
								</div>

								<div class="card-body">
									<div class="desc">
										<p><label class="label-title">진행일시</label><strong>#[smnrDttm]</strong></p>
										<p><label class="label-title">진행시간</label><strong>#[smnrMnts]</strong></p>
										<p><label class="label-title">참석시간</label><strong>#[atndScnds]</strong></p>
										<p><label class="label-title">방식</label><strong>#[smnrGbnnm]</strong></p>
										<p><label class="label-title">성적반영</label><strong>#[mrkRfltyn]</strong></p>
										<p><label class="label-title">평가점수</label><strong>#[atndEvlScr]</strong></p>
										<p><label class="label-title">피드백</label><strong>#[fdbk]</strong></p>
									</div>
								</div>
							</div>

							<script>
								// 리스트 테이블
								let smnrListTable = UiTable("list", {
									lang: "ko",
									pageFunc: smnrListSelect,
									columns: [
										{title:"No", 		field:"no",					headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},
										{title:"구분", 		field:"smnrGbn",			headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},
										{title:"방식", 		field:"smnrGbnnm",			headerHozAlign:"center", hozAlign:"center",	width:130,	minWidth:130},
										{title:"세미나", 		field:"smnrnm",				headerHozAlign:"center", hozAlign:"left",	width:0,	minWidth:200},
										{title:"진행일시", 	field:"smnrDttm", 			headerHozAlign:"center", hozAlign:"center", width:280,	minWidth:280},
										{title:"진행시간", 	field:"smnrMnts", 			headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100},
										{title:"참석시간", 	field:"atndScnds",	 		headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100},
										{title:"성적반영", 	field:"mrkRfltyn",	 		headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},
										{title:"진행상태", 	field:"prgrsStatus", 		headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},
										{title:"참석여부", 	field:"atndStatus", 		headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},
										{title:"평가점수", 	field:"atndEvlScr", 		headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},
										{title:"피드백", 		field:"fdbk", 				headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},
										{title:"ZOOM 참여", 	field:"manage", 			headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:150},
									]
								});
							</script>
						</div>
		        	</div>
		        </div>
            </div>
            <!-- //content -->
        </main>
        <!-- //classroom-->
    </div>
</body>
</html>