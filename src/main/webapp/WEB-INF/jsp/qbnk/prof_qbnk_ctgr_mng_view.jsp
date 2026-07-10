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
					qbnkCtgrListSelect(1);
				}
			});

			if(!PAGE_INDEX) {
				PAGE_INDEX = 1;
			}

			qbnkCtgrListSelect(PAGE_INDEX);
		});

		// list scale 변경
		function changeListScale() {
			LIST_SCALE = scale;
			qbnkCtgrListSelect(1);
		}

		/**
		 * 문제은행문항목록조회
		 * @param pageNo	이동페이지
		 */
		function qbnkCtgrListSelect(pageNo) {
			PAGE_INDEX   = pageNo || PAGE_INDEX;
			SEARCH_VALUE = $("#searchValue").val();

			const url   = "/qbnk/profQbnkCtgrAllListAjax.do";
			const param = {
				currentPageNo 		: PAGE_INDEX,
				recordCountPerPage 	: LIST_SCALE,
				searchValue 		: SEARCH_VALUE,
				pageSize 			: 10,
				upQbnkCtgrId 		: $("#upQbnkCtgrId").val(),
				qbnkCtgrId 			: $("#qbnkCtgrId").val(),
				sbjctId 			: $("#sbjctId").val(),
				userId 				: $("#searchUserId").val(),
				searchKey			: "${qbnkSbjct.sbjctId }"
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

    	        		ctgrListTable.clearData();
    	        		ctgrListTable.replaceData(dataList);
    	        		ctgrListTable.setPageInfo(data.pageInfo);
                    } else {
                    	UiComm.showMessage(data.message, "error");
                    }
                },
                error		: () => UiComm.showMessage("<spring:message code='quiz.error.list' />", "error"),/* 리스트 조회 중 에러가 발생하였습니다. */
                complete	: () => UiComm.showLoading(false)
		    });
		}

		// 문항 리스트 HTML 생성
		function createQstnListHTML(ctgrList) {
			let dataList = [];

			if(ctgrList.length == 0) {
				return dataList;
			}

			ctgrList.forEach(function(v,i) {
				let mng  = "<a href='javascript:qbnkCtgrModifyFrmInit(\"" + v.qbnkCtgrId + "\")' class='btn basic small'><spring:message code='common.button.modify' /></a>";/* 수정 */
				 	mng += "<a href='javascript:qbnkCtgrDelete(\"" + v.qbnkCtgrId + "\")' class='btn basic small'><spring:message code='common.button.delete' /></a>";/* 삭제 */

				dataList.push({
					no: 			v.lineNo,
					upQbnkCtgrnm: 	v.upQbnkCtgrnm,
					ctgrnm: 		v.ctgrnm,
					sbjctnm: 		v.sbjctnm + " " + (v.dvclasNo || "-") + "<spring:message code='quiz.label.decls' />",/* 반 */
					usernm: 		v.usernm,
					mng: 			mng
				});
			});

			return dataList;
		}

		/**
		* 문제은행하위분류목록조회
		* @param qbnkCtgrId		문제은행분류아이디
		*/
		function subQbnkCtgrList(qbnkCtgrId) {
			const url   = "/qbnk/profQbnkCtgrListAjax.do";
			const param = {
				encParams : EPARAM,
				addParams : UiComm.makeEncParams({upQbnkCtgrId : qbnkCtgrId})
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

		// 문제은행분류등록
		function qbnkCtgrRegist() {
			let validator = UiValidator("qbnkCtgrForm");
			validator.then(function(result) {
				if (result) {
					const url = "/qbnk/qbnkCtgrRegistAjax.do";
					ajaxCall(url, $("#qbnkCtgrForm").serialize(), function(data) {
						if (data.result > 0) {
							location.reload();
					    } else {
					    	UiComm.showMessage(data.message, "error");
					    }
					}, function(xhr, status, error) {
						if($("#qbnkCtgrForm input[name=qbnkCtgrId]").val() == "") {
							UiComm.showMessage("<spring:message code='quiz.error.insert' />", "error");	/* 저장 중 에러가 발생하였습니다. */
						} else {
							UiComm.showMessage("<spring:message code='quiz.error.update' />", "error");	/* 수정 중 에러가 발생하였습니다. */
						}
					}, true);
				}
			});
		}

		/**
		* 다음분류순번조회
		* @param upQbnkCtgrId	상위문제은행분류아이디
		*/
		function nextCtgrSeqnoSelect(upQbnkCtgrId) {
			$("#qbnkCtgrForm input[name=upQbnkCtgrId]").val(upQbnkCtgrId);

			const url  = "/qbnk/qbnkNextCtgrSeqnoSelectAjax.do";
			const data = {
				upQbnkCtgrId 	: upQbnkCtgrId,
				userId 			: "${qbnkSbjct.userId }"
			};

			ajaxCall(url, data, function(data) {
				$("#qbnkCtgrForm input[name=ctgrSeqno]").val(data.result);
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");/* 에러가 발생했습니다! */
			}, true);
		}

		/**
		* 문제은행분류수정폼초기화
		* @param qbnkCtgrId		문제은행분류아이디
		*/
		function qbnkCtgrModifyFrmInit(qbnkCtgrId) {
			const url  = "/qbnk/qbnkCtgrSelectAjax.do";
			const data = {
				qbnkCtgrId : qbnkCtgrId
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		let qbnkCtgrVO = data.data;

	        		// 상위분류 변경 제거
	        		$("#qbnkCtgrForm select[name=selectUpQbnkCtgrId]").val(qbnkCtgrVO.upQbnkCtgrId);
	        		$("#qbnkCtgrForm select[name=selectUpQbnkCtgrId]").attr("disabled", true).trigger("chosen:updated");

	        		$("#qbnkCtgrForm input[name=smstrChrtId]").val(qbnkCtgrVO.smstrChrtId);
	        		$("#qbnkCtgrForm input[name=upQbnkCtgrId]").val(qbnkCtgrVO.upQbnkCtgrId);
	        		$("#qbnkCtgrForm input[name=qbnkCtgrId]").val(qbnkCtgrVO.qbnkCtgrId);
	        		$("#qbnkCtgrForm input[name=ctgrSeqno]").val(qbnkCtgrVO.ctgrSeqno);
	        		$("#qbnkCtgrForm input[name=ctgrnm]").val(qbnkCtgrVO.ctgrnm);
	        		$("#qbnkCtgrForm textarea[name=ctgrExpln]").val(qbnkCtgrVO.ctgrExpln);
	            }
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");/* 에러가 발생했습니다! */
			}, true);
		}

		/**
		* 문제은행분류삭제
		* @param qbnkCtgrId		문제은행분류아이디
		*/
		function qbnkCtgrDelete(qbnkCtgrId) {
			const selectUrl  = "/qbnk/qbnkCtgrUseCntSelectAjax.do";
			const selectData = {
				qbnkCtgrId : qbnkCtgrId
			};

			ajaxCall(selectUrl, selectData, function(data) {
				if (data.result > 0) {
					let cnt = data.data;

					if(cnt.ctgrCnt > 0) {
						UiComm.showMessage("<spring:message code='quiz.alert.not.delete.sub.category' />", "warning");/* 하위분류가 있어 삭제 할 수 없습니다. */
					} else if(cnt.qstnCnt > 0) {
						UiComm.showMessage("<spring:message code='quiz.alert.not.delete.sub.qstn' />", "warning");/* 하위문항이 있어 삭제 할 수 없습니다. */
					} else {
						const url  = "/qbnk/qbnkCtgrDeleteAjax.do";
						const data = {
							"qbnkCtgrId" : qbnkCtgrId
						};

						ajaxCall(url, data, function(data) {
							if (data.result > 0) {
								location.reload();
						    } else {
						    	UiComm.showMessage(data.message, "error");
						    }
						}, function(xhr, status, error) {
							UiComm.showMessage("<spring:message code='quiz.error.delete' />", "error");/* 삭제 중 에러가 발생하였습니다. */
						}, true);
					}
			    } else {
			    	UiComm.showMessage(data.message, "error");
			    }
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");/* 에러가 발생했습니다! */
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
					            <li class="mw120"><a onclick="quizViewMv('', 'QBNKLIST')"><spring:message code="quiz.common.qbnk" /><!-- 문제은행 --></a></li>
					            <li class="select mw120"><a onclick="quizViewMv('', 'QBNKCTGR')"><spring:message code="quiz.tab.category" /><!-- 분류코드 관리 --></a></li>
					        </ul>
					    </div>
		        		<div class="page-info">
				        	<h2 class="page-title">
                                <spring:message code="quiz.tab.category" /><!-- 분류코드 관리 -->
                            </h2>
				        </div>
				        <div class="board_top">
				        	<spring:message code="quiz.label.regist.category" /><!-- 분류코드 등록 -->
				        	<div class="right-area">
				        		<button type="button" class="btn type2" onclick="qbnkCtgrRegist()"><spring:message code="common.button.save" /><!-- 저장 --></button>
				        	</div>
				        </div>
				        <form id="qbnkCtgrForm">
				        	<input type="hidden" name="smstrChrtId" value="${qbnkSbjct.smstrChrtId }" />
					        <input type="hidden" name="ctgrSeqno"	value="${fn:length(upQbnkCtgrList)+1 }" />
					        <input type="hidden" name="qbnkCtgrId" />
					        <input type="hidden" name="upQbnkCtgrId" />
					        <table class="table-type5">
					        	<colgroup>
					        		<col class="width-20per" />
					        		<col class="" />
					        	</colgroup>
					        	<tbody>
					        		<tr>
					        			<th><label><spring:message code="quiz.label.upper.category" /><!-- 상위분류 --></label></th>
					        			<td>
					        				<select class="form-select" name="selectUpQbnkCtgrId" onchange="nextCtgrSeqnoSelect(this.value)">
		                                		<option value=""><spring:message code="quiz.label.upper.category" /></option><!-- 상위분류 -->
			                                    <c:forEach var="item" items="${upQbnkCtgrList }">
										        	<option value="${item.qbnkCtgrId }">${item.ctgrnm }</option>
										        </c:forEach>
			                                </select>
					        			</td>
					        		</tr>
					        		<tr>
					        			<th><label class="req"><spring:message code="common.label.crsauth.crscd" /><!-- 과목코드 -->/<spring:message code="common.subject" /><!-- 과목 --></label></th>
					        			<td>
					        				<input class="form-control" type="text" name="sbjctId" value="${qbnkSbjct.sbjctId }" readonly="true" autocomplete="off" required="true">
					        				<span>( ${qbnkSbjct.sbjctnm } ${qbnkSbjct.dvclasNo }<spring:message code="quiz.label.decls" /><!-- 반 --> )</span>
					        			</td>
					        		</tr>
					        		<tr>
					        			<th><label><spring:message code="common.label.prof.no" /><!-- 교수사번 -->/<spring:message code="common.label.prof.nm" /><!-- 교수명 --></label></th>
					        			<td>
					        				<input class="form-control" type="text" name="userId" value="${qbnkSbjct.userId }" readonly="true" autocomplete="off">
					        				<span>( ${qbnkSbjct.usernm } <spring:message code="common.professor" /><!-- 교수 --> )</span>
					        			</td>
					        		</tr>
					        		<tr>
					        			<th><label class="req" for="ctgrnm"><spring:message code="quiz.label.category.nm" /><!-- 분류명 --></label></th>
					        			<td><input class="form-control width-100per" type="text" name="ctgrnm" autocomplete="off" required="true"></td>
					        		</tr>
					        		<tr>
					        			<th><label class="req" for="ctgrExpln"><spring:message code="quiz.label.explan" /><!-- 설명 --></label></th>
					        			<td><textarea class="width-100per min-height-100px" name="ctgrExpln" required="true"></textarea></td>
					        		</tr>
					        	</tbody>
					        </table>
				        </form>

						<div id="qbnkCtgrListArea">
							<div class="board_top margin-top-3">
	                            <h3 class="board-title"><spring:message code="quiz.label.category.code" /><!-- 분류코드 --></h3>
	                        </div>
	                        <div class="board_top">
								<select class="form-select" id="upQbnkCtgrId" onchange="subQbnkCtgrList(this.value)">
                               		<option value=""><spring:message code="quiz.label.upper.category" /></option><!-- 상위분류 -->
	                                <c:forEach var="item" items="${upQbnkCtgrList }">
							        	<option value="${item.qbnkCtgrId }">${item.ctgrnm }</option>
							        </c:forEach>
	                            </select>
	                            <select class="form-select" id="qbnkCtgrId" onchange="qbnkCtgrListSelect(1)">
                               		<option value=""><spring:message code="quiz.label.sub.category" /></option><!-- 하위분류 -->
	                            </select>
	                            <select class="form-select" id="sbjctId" onchange="qbnkCtgrListSelect(1)">
                               		<option value=""><spring:message code="common.subject" /></option><!-- 과목 -->
							        <c:forEach var="item" items="${sbjctList }">
							        	<option value="${item.sbjctId }">${item.sbjctnm }</option>
							        </c:forEach>
	                            </select>
	                            <select class="form-select" id="searchUserId" onchange="qbnkCtgrListSelect(1)" disabled>
                               		<option value=""><spring:message code="common.charge.professor" /><!-- 담당교수 --></option>
							        <c:forEach var="item" items="${profList }">
							        	<option value="${item.userId }" ${item.userId eq qbnkSbjct.userId ? 'selected' : '' }>${item.usernm }</option>
							        </c:forEach>
	                            </select>
	                            <input class="form-control wide" type="text" id="searchValue" placeholder="<spring:message code='quiz.placeholder.input.category.sbjct.prof.nm' />"><!-- 분류명/과목/담당교수 입력 -->
	                            <button type="button" class="btn basic icon" onclick="qbnkCtgrListSelect(1)"><i class="xi-search"></i></button>
	                        	<div class="right-area">
									<uiex:listScale func="changeListScale" value="" />
	                        	</div>
	                        </div>

	                        <%-- 퀴즈 리스트 --%>
							<div id="list"></div>

							<script>
								// 리스트 테이블
								let ctgrListTable = UiTable("list", {
									lang: "ko",
									pageFunc: qbnkCtgrListSelect,
									columns: [
										{title:"No", 													field:"no",				headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},
										{title:"<spring:message code='quiz.label.upper.category' />", 	field:"upQbnkCtgrnm",	headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:150},/* 상위분류 */
										{title:"<spring:message code='quiz.label.sub.category' />", 	field:"ctgrnm",			headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:150},/* 하위분류 */
										{title:"<spring:message code='common.subject' />", 				field:"sbjctnm", 		headerHozAlign:"center", hozAlign:"center", width:0, 	minWidth:150},/* 과목 */
										{title:"<spring:message code='common.charge.professor' />", 	field:"usernm", 		headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100},/* 담당교수 */
										{title:"<spring:message code='common.mgr' />", 					field:"mng", 			headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:100},/* 관리 */
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