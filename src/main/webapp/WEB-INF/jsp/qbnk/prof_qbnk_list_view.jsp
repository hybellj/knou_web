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
		var SEARCH_VALUE	= '<c:out value="${vo.searchValue}" />';
		var PAGE_INDEX		= '<c:out value="${vo.pageIndex}" />';
		var LIST_SCALE		= '<c:out value="${vo.listScale}" />';

		$(document).ready(function () {
			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					qbnkQstnListSelect(1);
				}
			});

			if(!PAGE_INDEX) {
				PAGE_INDEX = 1;
			}

			qbnkQstnListSelect(PAGE_INDEX);
		});

		// list scale 변경
		function changeListScale() {
			LIST_SCALE = scale;
			qbnkQstnListSelect(1);
		}

		/**
		 * 문제은행문항목록조회
		 * @param pageNo	이동페이지
		 */
		function qbnkQstnListSelect(pageNo) {
			PAGE_INDEX   = pageNo || PAGE_INDEX;
			SEARCH_VALUE = $("#searchValue").val();

			const url   = "/qbnk/profQbnkQstnListAjax.do";
			const param = {
				currentPageNo 		: PAGE_INDEX,
				recordCountPerPage 	: LIST_SCALE,
				searchValue 		: SEARCH_VALUE,
				pageSize 			: 10,
				upQbnkCtgrId 		: $("#upQbnkCtgrId").val(),
				qbnkCtgrId 			: $("#qbnkCtgrId").val(),
				sbjctId 			: $("#sbjctId").val(),
				userId 				: $("#searchUserId").val(),
				searchKey			: "${qbnkSbjct.sbjctId}"
			};

			$.ajax({
		        url 	  	: url,
		        type 	  	: "POST",
		        data 	  	: param,
		        dataType  	: "json",
		        beforeSend	: () => UiComm.showLoading(true),
                success		: function (data) {
                    if (data.result > 0) {
    	        		let dataList = createQstnListHTML(data.returnList);	// 문항 리스트 HTML 생성

    	        		qstnListTable.clearData();
    	        		qstnListTable.replaceData(dataList);
    	        		qstnListTable.setPageInfo(data.pageInfo);
                    } else {
                    	UiComm.showMessage(data.message, "error");
                    }
                },
                error		: () => UiComm.showMessage("<spring:message code='quiz.error.list' />", "error"),/* 리스트 조회 중 에러가 발생하였습니다. */
                complete	: () => UiComm.showLoading(false)
		    });
		}

		// 문항 리스트 HTML 생성
		function createQstnListHTML(qstnList) {
			let dataList = [];

			if(qstnList.length == 0) {
				return dataList;
			}

			qstnList.forEach(function(v,i) {
				dataList.push({
					no: 			v.lineNo,
					upQbnkCtgrnm: 	v.upQbnkCtgrnm,
					ctgrnm: 		v.ctgrnm,
					sbjctnm: 		v.sbjctnm + " " + (v.dvclasNo || "-") + "<spring:message code='quiz.label.decls' />"/* 반 */,
					usernm: 		v.usernm,
					qstnTtl: 		"<a href='javascript:quizViewMv(\"\", \"QBNKMODIFY\", \"\", \""+v.qbnkQstnId+"\")' class='header header-icon link'>" + UiComm.escapeHtml(v.qstnTtl) + "</a>",
					qstnRspnsTynm: 	v.qstnRspnsTynm,
					qstnDfctlvTynm: v.qstnDfctlvTynm,
					mng: 			"<a href='javascript:qbankQstnView(\"" + v.qbnkQstnId + "\")' class='btn basic small'><spring:message code='quiz.button.qstn.view' /></a>"/* 문제보기 */
				});
			});

			return dataList;
		}

		/**
		 * 문제보기팝업
		 * @param qbnkQstnId	문제은행문항아이디
		 */
		function qbankQstnView(qbnkQstnId) {
			dialog = UiDialog("dialog1", {
				title		: "<spring:message code='quiz.button.qstn.view' />",/* 문제보기 */
				width		: 800,
				height		: 500,
				url			: "/qbnk/profQbnkQstnViewPopup.do?qbnkQstnId="+qbnkQstnId,
				autoresize	: true
			});
		}

		/**
		 * 문제은행하위분류목록조회
		 * @param qbnkCtgrId	문제은행분류아이디
		 */
	    function subQbnkCtgrList(qbnkCtgrId) {
	    	const url   = "/qbnk/profQbnkCtgrListAjax.do";
	    	const param = {
	    	  	  encParams	: EPARAM
				, addParams	: UiComm.makeEncParams({upQbnkCtgrId : qbnkCtgrId})
	    	};

			ajaxCall(url, param, function(data) {
				if (data.result > 0) {
	        		let returnList = data.returnList || [];
	        		let html = "<option value=''><spring:message code='quiz.label.sub.category' /></option>";/* 하위분류 */

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
				UiComm.showMessage("<spring:message code='quiz.error.list' />", "error");/* 리스트 조회 중 에러가 발생하였습니다. */
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
            <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp"/>
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
		        		<div class="listTab">
					        <ul>
					            <li class="select mw120"><a onclick="quizViewMv('', 'QBNKLIST')"><spring:message code="quiz.common.qbnk" /><!-- 문제은행 --></a></li>
					            <li class="mw120"><a onclick="quizViewMv('', 'QBNKCTGR')"><spring:message code="quiz.tab.category" /><!-- 분류코드 관리 --></a></li>
					        </ul>
					    </div>
		        		<div class="page-info">
				        	<h2 class="page-title">
                                <spring:message code="quiz.common.qbnk" /><!-- 문제은행 -->
                            </h2>
				        </div>
				        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><label for="upQbnkCtgrId"><spring:message code="common.label.ctgr" /><!-- 분류 --></label></span>
                                <div class="itemList">
                                	<select class="form-select" id="upQbnkCtgrId" onchange="subQbnkCtgrList(this.value)">
                                		<option value=""><spring:message code="quiz.label.upper.category" /></option><!-- 상위분류 -->
	                                    <c:forEach var="item" items="${upQbnkCtgrList }">
							            	<option value="${item.qbnkCtgrId }">${item.ctgrnm }</option>
							            </c:forEach>
	                                </select>
                                	<select class="form-select" id="qbnkCtgrId" onchange="qbnkQstnListSelect(1)">
                                		<option value=""><spring:message code="quiz.label.sub.category" /></option><!-- 하위분류 -->
	                                </select>
                                </div>
                            </div>
                            <div class="item">
                            	<span class="item_tit"><label for="sbjctId"><spring:message code="common.subject" /><!-- 과목 --></label></span>
                            	<div class="itemList">
                            		<select class="form-select" id="sbjctId" onchange="qbnkQstnListSelect(1)">
                                		<option value=""><spring:message code="common.subject" /></option><!-- 과목 -->
							            <c:forEach var="item" items="${sbjctList }">
								        	<option value="${item.sbjctId }">${item.sbjctnm }</option>
								        </c:forEach>
	                                </select>
                            	</div>
                            </div>
                            <div class="item">
                            	<span class="item_tit"><label for="searchUserId"><spring:message code="common.charge.professor" /><!-- 담당교수 --></label></span>
                            	<div class="itemList">
                            		<select class="form-select" id="searchUserId" onchange="qbnkQstnListSelect(1)" disabled>
                                		<option value=""><spring:message code="common.charge.professor" /><!-- 담당교수 --></option>
							            <c:forEach var="item" items="${profList }">
								        	<option value="${item.userId }" ${item.userId eq qbnkSbjct.userId ? 'selected' : '' }>${item.usernm }</option>
								        </c:forEach>
	                                </select>
                            	</div>
                            </div>
                            <div class="item">
                            	<span class="item_tit"><label for="searchValue"><spring:message code="common.search.keyword" /><!-- 검색어 --></label></span>
                            	<div class="itemList">
                            		<input class="form-control wide" type="text" id="searchValue" value="${vo.searchValue}" placeholder="<spring:message code='quiz.placeholder.input.ttl' />"><!-- 제목 입력 -->
                            	</div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="qbnkQstnListSelect(1)"><spring:message code="common.button.search" /><!-- 검색 --></button>
                            </div>
                        </div>

						<div id="qbnkListArea">
							<div class="board_top">
	                            <h3 class="board-title"><spring:message code="common.button.list" /><!-- 목록 --></h3>
	                            <div class="right-area">
									<a href="javascript:quizViewMv('', 'QBNKREIGST')" class="btn type2"><spring:message code="quiz.button.qstn.regist" /><!-- 문제 등록 --></a>

									<%-- 목록 스케일 선택 --%>
									<uiex:listScale func="changeListScale" value="${vo.listScale}" />
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
										{title:"No", 													field:"no",				headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},
										{title:"<spring:message code='quiz.label.upper.category' />", 	field:"upQbnkCtgrnm",	headerHozAlign:"center", hozAlign:"center",	width:180,	minWidth:180},/* 상위분류 */
										{title:"<spring:message code='quiz.label.sub.category' />", 	field:"ctgrnm",			headerHozAlign:"center", hozAlign:"center",	width:180,	minWidth:180},/* 하위분류 */
										{title:"<spring:message code='common.subject' />", 				field:"sbjctnm", 		headerHozAlign:"center", hozAlign:"center", width:200, 	minWidth:200},/* 과목 */
										{title:"<spring:message code='common.charge.professor' />", 	field:"usernm", 		headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100},/* 담당교수 */
										{title:"<spring:message code='common.label.title' />", 			field:"qstnTtl", 		headerHozAlign:"center", hozAlign:"left", 	width:0,	minWidth:280},/* 제목 */
										{title:"<spring:message code='quiz.label.qstn.type' />", 		field:"qstnRspnsTynm",	headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100},/* 문제유형 */
										{title:"<spring:message code='quiz.label.dfctlv' />", 			field:"qstnDfctlvTynm",	headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},/* 난이도 */
										{title:"<spring:message code='common.mgr' />", 					field:"mng", 			headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100}/* 관리 */
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