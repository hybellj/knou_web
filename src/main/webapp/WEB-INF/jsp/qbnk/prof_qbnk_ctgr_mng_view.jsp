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
			qbnkCtgrListSelect(1);

			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					qbnkCtgrListSelect(1);
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

			submitForm(urlMap[tab], "", "", kvArr);
		}

		// list scale 변경
		function changeListScale() {
			qbnkCtgrListSelect(1);
		}

		/**
		 * 문제은행문항목록조회
		 * @param {Integer} pageIndex 		- 현재 페이지
		 * @param {String}  listScale 		- 페이징 목록 수
		 * @param {String}  upQbnkCtgrId 	- 상위문제은행분류아이디
		 * @param {String}  qbnkCtgrId 		- 문제은행분류아이디
		 * @param {String}  sbjctId 		- 과목아이디
		 * @param {String}  userRprsId 		- 사용자대표아이디
		 * @param {String}  searchValue 	- 검색어(분류명, 과목, 담당교수)
		 * @returns {list} 문제은행문항 목록
		 */
		function qbnkCtgrListSelect(page) {
			var url  = "/qbnk/profQbnkCtgrAllListAjax.do";
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
		        data 	  : data,
		    }).done(function(data) {
		    	UiComm.showLoading(false);
	        	if (data.result > 0) {
	        		var returnList = data.returnList || [];
	        		var dataList = createQstnListHTML(returnList);	// 문항 리스트 HTML 생성

	        		ctgrListTable.clearData();
	        		ctgrListTable.replaceData(dataList);
	        		ctgrListTable.setPageInfo(data.pageInfo);
	            } else {
	            	UiComm.showMessage(data.message, "error");
	            }
		    }).fail(function() {
		    	UiComm.showLoading(false);
	        	UiComm.showMessage("<spring:message code='exam.error.list' />", "error");/* 리스트 조회 중 에러가 발생하였습니다. */
		    });
		}

		// 문항 리스트 HTML 생성
		function createQstnListHTML(ctgrList) {
			let dataList = [];

			if(ctgrList.length == 0) {
				return dataList;
			} else {
				ctgrList.forEach(function(v,i) {
					// 과목
					var sbjctnm = v.sbjctnm + " " + v.dvclasNo + "반";
					// 제목
					var mng  = "<a href='javascript:qbnkCtgrModifyFrmInit(\"" + v.qbnkCtgrId + "\")' class='btn basic small'>수정</a>";
					 	mng += "<a href='javascript:qbnkCtgrDelete(\"" + v.qbnkCtgrId + "\")' class='btn basic small'>삭제</a>";

					dataList.push({
						no: 			v.lineNo,
						upQbnkCtgrnm: 	v.upQbnkCtgrnm,
						ctgrnm: 		v.ctgrnm,
						sbjctnm: 		sbjctnm,
						usernm: 		v.usernm,
						mng: 			mng
					});
				});
			}

			return dataList;
		}

		/**
		* 문제은행하위분류목록조회
		* @param {String} qbnkCtgrId 	- 문제은행분류아이디
		* @param {String} userRprsId 	- 사용자아이디
		* @param {String} sbjctId 		- 과목아이디
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

		// 문제은행분류등록
		function qbnkCtgrRegist() {
			let validator = UiValidator("qbnkCtgrForm");
			validator.then(function(result) {
				if (result) {
					UiComm.showLoading(true);
					var url = "/qbnk/qbnkCtgrRegistAjax.do";
					$.ajax({
					    url 	 : url,
					    async	 : false,
					    type 	 : "POST",
					    dataType : "json",
					    data 	 : $("#qbnkCtgrForm").serialize(),
					}).done(function(data) {
						UiComm.showLoading(false);
						if (data.result > 0) {
							location.reload();
					    }
					}).fail(function() {
						UiComm.showLoading(false);
						if($("#qbnkCtgrForm input[name=qbnkCtgrId]").val() == "") {
							UiComm.showMessage("<spring:message code='exam.error.insert' />", "error");	/* 저장 중 에러가 발생하였습니다. */
						} else {
							UiComm.showMessage("<spring:message code='exam.error.update' />", "error");	/* 수정 중 에러가 발생하였습니다. */
						}
					});
				}
			});
		}

		/**
		* 다음분류순번조회
		* @param {String} upQbnkCtgrId  - 상위문제은행분류아이디
		* @param {String} userRprsId 	- 사용자아이디
		* @returns {list} 문제은행하위분류 목록
		*/
		function nextCtgrSeqnoSelect(upQbnkCtgrId) {
			$("#qbnkCtgrForm input[name=upQbnkCtgrId]").val(upQbnkCtgrId);

			var url  = "/qbnk/qbnkNextCtgrSeqnoSelectAjax.do";
			var data = {
				"upQbnkCtgrId" 	: upQbnkCtgrId,
				"userRprsId" 	: "${qbnkSbjct.userRprsId }"
			};

			ajaxCall(url, data, function(data) {
				$("#qbnkCtgrForm input[name=ctgrSeqno]").val(data.result);
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");/* 에러가 발생했습니다! */
			}, true);
		}

		/**
		* 문제은행분류수정폼초기화
		* @param {String} qbnkCtgrId - 문제은행분류아이디
		*/
		function qbnkCtgrModifyFrmInit(qbnkCtgrId) {
			var url  = "/qbnk/qbnkCtgrSelectAjax.do";
			var data = {
				"qbnkCtgrId" : qbnkCtgrId
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		var qbnkCtgrVO = data.returnVO;

	        		// 상위분류 변경 제거
	        		$("#qbnkCtgrForm select[name=selectUpQbnkCtgrId]").val(qbnkCtgrVO.upQbnkCtgrId);
	        		$("#qbnkCtgrForm select[name=selectUpQbnkCtgrId]").attr("disabled", true).trigger("chosen:updated");

	        		$("#qbnkCtgrForm input[name=smstrChrtId]").val(qbnkCtgrVO.smstrChrtId);
	        		$("#qbnkCtgrForm input[name=crsMstrId]").val(qbnkCtgrVO.crsMstrId);
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
		* @param {String} qbnkCtgrId - 문제은행분류아이디
		*/
		function qbnkCtgrDelete(qbnkCtgrId) {
			var url  = "/qbnk/qbnkCtgrUseCntSelectAjax.do";
			var data = {
				"qbnkCtgrId" : qbnkCtgrId
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					var cnt = data.returnVO;

					if(cnt.ctgrCnt > 0) {
						UiComm.showMessage("하위분류가 있어 삭제 할 수 없습니다.", "warning");
					} else if(cnt.qstnCnt > 0) {
						UiComm.showMessage("하위문항이 있어 삭제 할 수 없습니다.", "warning");
					} else {
						var url  = "/qbnk/qbnkCtgrDeleteAjax.do";
						var data = {
							"qbnkCtgrId" : qbnkCtgrId
						};

						ajaxCall(url, data, function(data) {
							if (data.result > 0) {
								qbnkCtgrListSelect(1);
						    } else {
						    	UiComm.showMessage(data.message, "error");
						    }
						}, function(xhr, status, error) {
							UiComm.showMessage("<spring:message code='exam.error.delete' />", "error");/* 삭제 중 에러가 발생하였습니다. */
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
					            <li class="mw120"><a onclick="qbnkViewMv(1)">문제은행</a></li>
					            <li class="select mw120"><a onclick="qbnkViewMv(2)">분류코드 관리</a></li>
					        </ul>
					    </div>
		        		<div class="page-info">
				        	<h2 class="page-title">
                                분류코드 관리
                            </h2>
				        </div>
				        <div class="board_top">
				        	분류코드 등록
				        	<div class="right-area">
				        		<button type="button" class="btn type2" onclick="qbnkCtgrRegist()">저장</button>
				        	</div>
				        </div>
				        <form id="qbnkCtgrForm">
				        	<input type="hidden" name="smstrChrtId" value="${qbnkSbjct.smstrChrtId }" />
					        <input type="hidden" name="crsMstrId" 	value="${qbnkSbjct.crsMstrId }" />
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
					        			<th><label>상위분류</label></th>
					        			<td>
					        				<select class="form-select" name="selectUpQbnkCtgrId" onchange="nextCtgrSeqnoSelect(this.value)">
		                                		<option value=""><spring:message code="exam.label.upper.categori" /></option><!-- 상위분류 -->
			                                    <c:forEach var="item" items="${upQbnkCtgrList }">
										        	<option value="${item.qbnkCtgrId }">${item.ctgrnm }</option>
										        </c:forEach>
			                                </select>
					        			</td>
					        		</tr>
					        		<tr>
					        			<th><label class="req">과목코드/과목</label></th>
					        			<td>
					        				<input class="form-control" type="text" name="sbjctId" value="${qbnkSbjct.sbjctId }" readonly="true" autocomplete="off" required="true">
					        				<span>( ${qbnkSbjct.sbjctnm } ${qbnkSbjct.dvclasNo }반 )</span>
					        			</td>
					        		</tr>
					        		<tr>
					        			<th><label class="req">대표아이디</label></th>
					        			<td><input class="form-control" type="text" name="userRprsId" value="${qbnkSbjct.userRprsId }" readonly="true" autocomplete="off" required="true"></td>
					        		</tr>
					        		<tr>
					        			<th><label>교수번호/교수명</label></th>
					        			<td>
					        				<input class="form-control" type="text" name="userId" value="${qbnkSbjct.profId }" readonly="true" autocomplete="off">
					        				<span>( ${qbnkSbjct.usernm } 교수 )</span>
					        			</td>
					        		</tr>
					        		<tr>
					        			<th><label class="req" for="ctgrnm">분류명</label></th>
					        			<td><input class="form-control width-100per" type="text" name="ctgrnm" autocomplete="off" required="true"></td>
					        		</tr>
					        		<tr>
					        			<th><label class="req" for="ctgrExpln">설명</label></th>
					        			<td><textarea class="width-100per min-height-100px" name="ctgrExpln" required="true"></textarea></td>
					        		</tr>
					        	</tbody>
					        </table>
				        </form>

						<div id="qbnkCtgrListArea">
							<div class="board_top margin-top-3">
	                            <h3 class="board-title">분류코드</h3>
	                        </div>
	                        <div class="board_top">
	                        	<input type="hidden" id="userRprsId" value="${qbnkSbjct.userRprsId }" />
								<select class="form-select" id="upQbnkCtgrId" onchange="subQbnkCtgrList(this.value)">
                               		<option value=""><spring:message code="exam.label.upper.categori" /></option><!-- 상위분류 -->
	                                <c:forEach var="item" items="${upQbnkCtgrList }">
							        	<option value="${item.qbnkCtgrId }">${item.ctgrnm }</option>
							        </c:forEach>
	                            </select>
	                            <select class="form-select" id="qbnkCtgrId" onchange="qbnkCtgrListSelect(1)">
                               		<option value=""><spring:message code="exam.label.sub.categori" /></option><!-- 하위분류 -->
	                            </select>
	                            <select class="form-select" id="sbjctId" onchange="qbnkCtgrListSelect(1)">
                               		<option value=""><spring:message code="crs.label.crecrs" /></option><!-- 과목 -->
							        <c:forEach var="item" items="${qbnkSearchSbjctList }">
							        	<option value="${item.sbjctId }">${item.sbjctnm }</option>
							        </c:forEach>
	                            </select>
	                            <select class="form-select" id="searchUserRprsId" onchange="qbnkCtgrListSelect(1)" disabled>
                               		<option value="">담당교수</option>
							        <c:forEach var="item" items="${qbnkSearchProfList }">
							        	<option value="${item.userRprsId }" ${item.userRprsId eq qbnkSbjct.userRprsId ? 'selected' : '' }>${item.usernm }</option>
							        </c:forEach>
	                            </select>
	                            <input class="form-control wide" type="text" id="searchValue" placeholder="분류명/과목/담당교수 입력">
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
										{title:"No", 		field:"no",				headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},
										{title:"상위분류", 	field:"upQbnkCtgrnm",	headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:150},
										{title:"하위분류", 	field:"ctgrnm",			headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:150},
										{title:"과목", 		field:"sbjctnm", 		headerHozAlign:"center", hozAlign:"center", width:0, 	minWidth:150},
										{title:"담당교수", 	field:"usernm", 		headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100},
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