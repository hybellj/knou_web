<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/quiz/common/quiz_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="module" value="table"/>
	</jsp:include>

	<script type="text/javascript">
		var dialog;

		$(document).ready(function () {
			qbnkQstnListSelect(1);

			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					qbnkQstnListSelect(1);
				}
			});
		});

		/**
		 * 문제은행 화면 이동
		 * @param {String}  sbjctId 	- 과목아이디
		 */
		function qbnkViewMv(tab) {
			var urlMap = {
				"1" : "/qbnk/profQbnkListView.do",		// 문제은행 목록 화면
				"2" : "/qbnk/profQbnkCtgrMngView.do"	// 분류코드 관리 화면
			};

			var kvArr = [];
			kvArr.push({'key' : 'sbjctId', 		'val' : "${vo.sbjctId}"});

			submitForm(urlMap[tab], kvArr);
		}

		/**
		* 문제은행 문항화면 이동
		* @param {String}  sbjctId 		- 과목아이디
		* @param {String}  qbnkQstnId 	- 문제은행문항아이디
		*/
		function qbnkQstnViewMv(qbnkQstnId, tab) {
			var urlMap = {
				"1" : "/qbnk/profQbnkQstnRegistView.do",	// 문제은행문항 등록 화면
				"2" : "/qbnk/profQbnkQstnModifyView.do"		// 문제은행문항 수정 화면
			};

			var kvArr = [];
			kvArr.push({'key' : 'sbjctId', 		'val' : "${vo.sbjctId}"});
			kvArr.push({'key' : 'qbnkQstnId', 	'val' : qbnkQstnId});

			submitForm(urlMap[tab], kvArr);
		}

		// list scale 변경
		function changeListScale() {
			qbnkQstnListSelect(1);
		}

		/**
		 * 문제은행문항목록조회
		 * @param {Integer} pageIndex 		- 현재 페이지
		 * @param {String}  listScale 		- 페이징 목록 수
		 * @param {String}  upQbnkCtgrId 	- 상위문제은행분류아이디
		 * @param {String}  qbnkCtgrId 		- 문제은행분류아이디
		 * @param {String}  sbjctId 		- 과목아이디
		 * @param {String}  userRprsId 		- 사용자대표아이디
		 * @param {String}  searchValue 	- 검색어(문항제목)
		 * @returns {list} 문제은행문항 목록
		 */
		function qbnkQstnListSelect(page) {
			var url  = "/qbnk/profQbnkQstnListAjax.do";
			var data = {
				"pageIndex" 	: page,
				"listScale" 	: $('[id^="listScale"]').eq(0).val(),
				"upQbnkCtgrId" 	: $("#upQbnkCtgrId").val(),
				"qbnkCtgrId" 	: $("#qbnkCtgrId").val(),
				"sbjctId" 		: $("#sbjctId").val(),
				"userRprsId" 	: $("#userRprsId").val(),
				"searchValue" 	: $("#searchValue").val()
			};

			UiComm.showLoading(true);
			$.ajax({
		        url 	  : url,
		        async	  : false,
		        type 	  : "POST",
		        dataType  : "json",
		        data 	  : JSON.stringify(data),
		        contentType: "application/json; charset=UTF-8",
		    }).done(function(data) {
		    	UiComm.showLoading(false);
	        	if (data.result > 0) {
	        		var returnList = data.returnList || [];
	        		var dataList = createQstnListHTML(returnList);	// 문항 리스트 HTML 생성

	        		qstnListTable.clearData();
	        		qstnListTable.replaceData(dataList);
	        		qstnListTable.setPageInfo(data.pageInfo);
	            } else {
	            	UiComm.showMessage(data.message, "error");
	            }
		    }).fail(function() {
		    	UiComm.showLoading(false);
	        	UiComm.showMessage("<spring:message code='exam.error.list' />", "error");/* 리스트 조회 중 에러가 발생하였습니다. */
		    });
		}

		// 문항 리스트 HTML 생성
		function createQstnListHTML(qstnList) {
			let dataList = [];

			if(qstnList.length == 0) {
				return dataList;
			} else {
				qstnList.forEach(function(v,i) {
					// 과목
					var sbjctnm = v.sbjctnm + " " + v.dvclasNo + "반";
					// 제목
					var qstnTtl = "<a href='javascript:qbnkQstnViewMv(\""+v.qbnkQstnId+"\", 2)' class='header header-icon link'>" + UiComm.escapeHtml(v.qstnTtl) + "</a>";
					var mng = "<a href='javascript:qbankQstnView(\"" + v.qbnkQstnId + "\")' class='btn basic small'>문제보기</a>";

					dataList.push({
						no: 			v.lineNo,
						upQbnkCtgrnm: 	v.upQbnkCtgrnm,
						ctgrnm: 		v.ctgrnm,
						sbjctnm: 		sbjctnm,
						usernm: 		v.usernm,
						qstnTtl: 		qstnTtl,
						qstnRspnsTynm: 	v.qstnRspnsTynm,
						qstnDfctlvTynm: v.qstnDfctlvTynm,
						mng: 			mng
					});
				});
			}

			return dataList;
		}

		/**
		 * 문제보기팝업
		 * @param {String}  qbnkQstnId - 문제은행문항아이디
		 */
		function qbankQstnView(qbnkQstnId) {
			dialog = UiDialog("dialog1", {
				title: "문제보기",
				width: 600,
				height: 500,
				url: "/qbnk/profQbnkQstnViewPopup.do?qbnkQstnId="+qbnkQstnId,
				autoresize: true
			});
		}

		/**
		 * 문제은행하위분류목록조회
		 * @param {Integer} qbnkCtgrId 	- 문제은행분류아이디
		 * @param {String}  userRprsId 	- 사용자대표아이디
		 * @param {String}  sbjctId 	- 과목아이디
		 * @returns {list} 문제은행하위분류 목록
		 */
	    function subQbnkCtgrList(qbnkCtgrId) {
	    	var url  = "/qbnk/profQbnkCtgrListAjax.do";
			var data = {
				"upQbnkCtgrId" 	: qbnkCtgrId,
				"userRprsId"	: "${vo.userRprsId}",
				"sbjctId"		: "${vo.sbjctId}"
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		var returnList = data.returnList || [];
	        		html = "<option value=''><spring:message code='exam.label.sub.categori' /></option>";/* 하위분류 */

	        		if(returnList.length > 0 && qbnkCtgrId != "") {
	        			returnList.forEach(function(v, i) {
							html += "<option value='" + v.qbnkCtgrId + "'>" + v.ctgrnm + "</option>";
		        		});
	        		}

	        		$("#qbnkCtgrId").empty().append(html);
	        		$("#qbnkCtgrId").val('').trigger("chosen:updated");
	        		$("#qbnkCtgrId option[value='']").prop("selected", true).trigger("change");
	            } else {
	            	UiComm.showMessage(data.message, "error");
	            }
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='exam.error.list' />", "error");/* 리스트 조회 중 에러가 발생하였습니다. */
			}, true);
	    }
	</script>
</head>

<body class="class colorA">
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>
        <!-- //common header -->

        <!-- classroom -->
        <main class="common">

        	<!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp"/>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
            	<div class="class_sub_top">
					<div class="navi_bar">
						<ul>
							<li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
							<li>강의실</li>
							<li><span class="current">내강의실</span></li>
						</ul>
					</div>
					<div class="btn-wrap">
						<div class="first">
							<select class="form-select">
								<option value="2025년 2학기">2025년 2학기</option>
								<option value="2025년 1학기">2025년 1학기</option>
							</select>
							<select class="form-select wide">
								<option value="">강의실 바로가기</option>
								<option value="2025년 2학기">2025년 2학기</option>
								<option value="2025년 1학기">2025년 1학기</option>
							</select>
						</div>
						<div class="sec">
							<button type="button" class="btn type1"><i class="xi-book-o"></i>교수 매뉴얼</button>
							<button type="button" class="btn type1"><i class="xi-info-o"></i>학습안내정보</button>
						</div>
					</div>
				</div>

				<div class="class_sub">
		        	<div class="sub-content">
		        		<div class="listTab">
					        <ul>
					            <li class="select mw120"><a onclick="qbnkViewMv(1)">문제은행</a></li>
					            <li class="mw120"><a onclick="qbnkViewMv(2)">분류코드 관리</a></li>
					        </ul>
					    </div>
		        		<div class="page-info">
				        	<h2 class="page-title">
                                <spring:message code="exam.label.qbank" /><!-- 문제은행 -->
                            </h2>
				        </div>
				        <div class="search-typeA">
				        	<input type="hidden" id="userRprsId" value="${vo.userRprsId }" />
                            <div class="item">
                                <span class="item_tit"><label for="upQbnkCtgrId">분류</label></span>
                                <div class="itemList">
                                	<select class="form-select" id="upQbnkCtgrId" onchange="subQbnkCtgrList(this.value)">
                                		<option value=""><spring:message code="exam.label.upper.categori" /></option><!-- 상위분류 -->
	                                    <c:forEach var="item" items="${upQbnkCtgrList }">
							            	<option value="${item.qbnkCtgrId }">${item.ctgrnm }</option>
							            </c:forEach>
	                                </select>
                                	<select class="form-select" id="qbnkCtgrId" onchange="qbnkQstnListSelect(1)">
                                		<option value=""><spring:message code="exam.label.sub.categori" /></option><!-- 하위분류 -->
	                                </select>
                                </div>
                            </div>
                            <div class="item">
                            	<span class="item_tit"><label for="sbjctId">과목</label></span>
                            	<div class="itemList">
                            		<select class="form-select" id="sbjctId" onchange="qbnkQstnListSelect(1)">
                                		<option value=""><spring:message code="crs.label.crecrs" /></option><!-- 과목 -->
							            <c:forEach var="item" items="${qbnkSearchSbjctList }">
								        	<option value="${item.sbjctId }">${item.sbjctnm }</option>
								        </c:forEach>
	                                </select>
                            	</div>
                            </div>
                            <div class="item">
                            	<span class="item_tit"><label for="searchUserRprsId">담당교수</label></span>
                            	<div class="itemList">
                            		<select class="form-select" id="searchUserRprsId" onchange="qbnkQstnListSelect(1)" disabled>
                                		<option value="">담당교수</option>
							            <c:forEach var="item" items="${qbnkSearchProfList }">
								        	<option value="${item.userRprsId }" ${item.userRprsId eq vo.userRprsId ? 'selected' : '' }>${item.usernm }</option>
								        </c:forEach>
	                                </select>
                            	</div>
                            </div>
                            <div class="item">
                            	<span class="item_tit"><label for="searchValue">검색어</label></span>
                            	<div class="itemList">
                            		<input class="form-control wide" type="text" id="searchValue" placeholder="제목 입력">
                            	</div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="qbnkQstnListSelect(1)">검색</button>
                            </div>
                        </div>

						<div id="qbnkListArea">
							<div class="board_top">
	                            <h3 class="board-title">목록</h3>
	                            <div class="right-area">
									<a href="javascript:qbnkQstnViewMv('', 1)" class="btn type2">문제 등록</a>

									<%-- 목록 스케일 선택 --%>
									<uiex:listScale func="changeListScale" value="" />
	                            </div>
	                        </div>

	                        <%-- 퀴즈 리스트 --%>
							<div id="list"></div>

							<script>
								// 리스트 테이블
								let qstnListTable = UiTable("list", {
									lang: "ko",
									pageFunc: qbnkQstnListSelect,
									columns: [
										{title:"No", 		field:"no",				headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},
										{title:"상위분류", 	field:"upQbnkCtgrnm",	headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:150},
										{title:"하위분류", 	field:"ctgrnm",			headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:150},
										{title:"과목", 		field:"sbjctnm", 		headerHozAlign:"center", hozAlign:"center", width:0, 	minWidth:150},
										{title:"담당교수", 	field:"usernm", 		headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100},
										{title:"제목", 		field:"qstnTtl", 		headerHozAlign:"center", hozAlign:"left", 	width:0,	minWidth:280},
										{title:"문제유형", 	field:"qstnRspnsTynm",	headerHozAlign:"center", hozAlign:"center", width:150,	minWidth:100},
										{title:"난이도", 		field:"qstnDfctlvTynm",	headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},
										{title:"관리", 		field:"mng", 			headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:100},
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