<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/srvy/common/srvy_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="admin"/>
		<jsp:param name="module" value="editor"/>
	</jsp:include>

	<script type="text/javascript">
		var editor;	// 에디터 목록 저장용

		$(document).ready(function () {
			selectOption.smstrChrt();
		});

		// 전체설문 등록, 수정
	    function save() {
	    	let validator = UiValidator("srvyFrm");
			validator.then(function(result) {
				if (result) {
					setValue();

					let url = "/srvy/admSrvyRegistAjax.do";
					if(${not empty vo.srvyId}) {
						url = "/srvy/admSrvyModifyAjax.do";
					}

					ajaxCall(url, $("#srvyFrm").serialize(), function (data) {
		                if (data.result > 0) {
		                	srvyViewMv(data.data.srvyId, "ADMVIEW");	// 관리자 전체설문 정보 화면
		                } else {
		                    UiComm.showMessage(data.message, "error");
		                }
		            }, function () {
		            	if(${empty vo.srvyId}) {
							UiComm.showMessage("<spring:message code='srvy.error.insert' />", "error");	/* 저장 중 에러가 발생하였습니다. */
						} else {
							UiComm.showMessage("<spring:message code='srvy.error.update' />", "error");	/* 수정 중 에러가 발생하였습니다. */
						}
		            }, true);
				}
			});
	    }

	 	// 값 채우기
	    function setValue() {
			$("#srvySdttm").val(UiComm.getDateTimeVal("dateSt", "timeSt") + "00");	// 전체설문 시작일시
			$("#srvyEdttm").val(UiComm.getDateTimeVal("dateEd", "timeEd") + "59");	// 전체설문 종료일시
	    }

	 	// 이전 전체설문 가져오기 팝업
	 	function bfrSrvyCopyPopup() {
			let data = "orgId="+$("#orgId").val()+"&srvyId=${vo.srvyId}";
	 		dialog = UiDialog("dialog1", {
				title	: "<spring:message code='srvy.button.prev.all.srvy.copy' />",/* 이전 전체설문 가져오기 */
				width	: 800,
				height	: 600,
				url		: "/srvy/admBfrSrvyCopyPopup.do?"+data
			});
	 	}

	 	/*
		 * 전체설문복사
		 * @param srvyId - 설문아이디
		 */
	 	function srvyCopy(srvyId) {
	 		const url  = "/srvy/admSrvySelectAjax.do";
	 		const data = {
				srvyId : srvyId
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					let srvy = data.data;

	        		$("#srvyTtl").val(srvy.srvyTtl);													// 전체설문 제목
	        		editor.openHTML($.trim(srvy.srvyCts) == "" ? " " : srvy.srvyCts);					// 전체설문 설명
	        		$("input[name=srvyTrgtTycd][value='" + srvy.srvyTrgtTycd + "']").trigger("click");	// 전체설문 대상
	        		$("input[name=rsltOpenTycd][value='" + srvy.rsltOpenTycd + "']").trigger("click");	// 결과조회
	        		$("#searchValue").val(srvy.srvyId);													// 복사 전체설문 아이디
	        		dialog.close();
	            } else {
	            	UiComm.showMessage(data.message, "error");
	            }
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='srvy.error.copy' />", "error");/* 가져오기 중 에러가 발생하였습니다. */
			}, true);
	 	}
	</script>
</head>

<body class="admin">
    <div id="wrap" class="main">
        <!-- common header -->
        <%@ include file="/WEB-INF/jsp/common_new/admin_header.jsp" %>
        <!-- //common header -->

        <!-- admin -->
        <main class="common">

            <!-- gnb -->
            <%@ include file="/WEB-INF/jsp/common_new/admin_aside.jsp" %>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="admin_sub">
                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">${uiex:getCurMenunm()}</h2>
                            <uiex:navibar type="admin"/>
                        </div>

                        <div class="board_top">
							<h3 class="board-title"><spring:message code="srvy.button.write" /></h3>
							<div class="right-area">
								<button type="button" class="btn type2 big" onclick="bfrSrvyCopyPopup()"><spring:message code="srvy.button.prev.all.srvy.copy" /><!-- 이전 전체설문 가져오기 --></button>
								<button type="button" class="btn type2 big" onclick="save()"><spring:message code="srvy.button.save" /><!-- 저장 --></button>
								<button type="button" class="btn type2 big" onclick="srvyViewMv('', 'ADMLIST')"><spring:message code="srvy.button.list" /><!-- 목록 --></button>
							</div>
						</div>

						<!--table-type-->
						<form id="srvyFrm" onsubmit="return false;">
							<input type="hidden" name="srvyId"	value="${vo.srvyId }" />
							<input type="hidden" name="srvyGbncd" 			value="HOMEPAGE_SRVY" />
							<input type="hidden" name="srvyTycd" 			value="SRVY_WHOL" />
							<input type="hidden" name="srvyWrtTycd" 		value="LMS_SRVY" />
							<input type="hidden" name="dvclasRegyn"			value="N" />
							<input type="hidden" name="mrkRfltyn"			value="N" />
							<input type="hidden" name="mrkOyn"				value="N" />
							<input type="hidden" name="byteamSubsrvyUseyn"	value="N" />
							<input type="hidden" name="srvySdttm"						id="srvySdttm" />
							<input type="hidden" name="srvyEdttm"						id="srvyEdttm" />
							<input type="hidden" name="searchValue"						id="searchValue" />
							<div class="table-wrap">
								<table class="table-type5">
									<colgroup>
										<col class="width-15per" />
										<col class="" />
									</colgroup>
									<tbody>
										<tr>
											<th><label for="orgId" class="req"><spring:message code="srvy.label.org" /><!-- 기관 --></label></th>
											<td>
												<select class="form-select wide" id="orgId" disabled="true">
			                                        <c:forEach var="org" items="${orgList }">
			                                    		<option value="${org.orgId }" ${org.orgId eq (not empty vo.srvyId ? vo.orgId : userCtx.orgId) ? 'selected' : '' }>${org.orgnm }</option>
			                                    	</c:forEach>
			                                    </select>
											</td>
										</tr>
										<tr>
											<th><label for="smstrChrtId" class="req"><spring:message code="srvy.label.year.smstr" /><!-- 학사년도/학기 --></label></th>
											<td>
												<select class="form-select wide" id="dgrsYr" onchange="selectOption.smstrChrt()">
			                                    	<c:forEach var="year" items="${yearList }">
			                                    		<option value="${year }" ${(not empty vo.srvyId && vo.dgrsYr eq year) || year eq curYear ? 'selected' : '' }>${year }</option>
			                                    	</c:forEach>
			                                    </select>
												<select class="form-select wide" id="smstrChrtId" name="smstrChrtId" required="true">
	                                    		</select>
											</td>
										</tr>
										<tr>
											<th><label for="trgtAll" class="req"><spring:message code="common.object" /><!-- 대상 --></label></th>
											<td>
												<div class="form-inline">
													<span class="custom-input">
														<input type="radio" name="srvyTrgtTycd" id="trgtAll" value="ALL" ${empty vo.srvyId || vo.srvyTrgtTycd eq 'ALL' ? 'checked' : '' }>
														<label for="trgtAll"><spring:message code="srvy.common.all" /><!-- 전체 --></label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="srvyTrgtTycd" id="trgtStdnt" value="STDNT" ${vo.srvyTrgtTycd eq 'STDNT' ? 'checked' : '' }>
														<label for="trgtStdnt"><spring:message code="common.label.students" /><!-- 수강생 --></label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="srvyTrgtTycd" id="trgtProf" value="PROF" ${vo.srvyTrgtTycd eq 'PROF' ? 'checked' : '' }>
														<label for="trgtProf"><spring:message code="common.professor" /><!-- 교수 --></label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="srvyTrgtTycd" id="trgtTut" value="TUT" ${vo.srvyTrgtTycd eq 'TUT' ? 'checked' : '' }>
														<label for="trgtTut"><spring:message code="common.label.tutor" /><!-- 튜터 --></label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="srvyTrgtTycd" id="trgtAssi" value="ASSI" ${vo.srvyTrgtTycd eq 'ASSI' ? 'checked' : '' }>
														<label for="trgtAssi"><spring:message code="common.teaching.assistant" /><!-- 조교 --></label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="srvyTrgtTycd" id="trgtAdm" value="ADM" ${vo.srvyTrgtTycd eq 'ADM' ? 'checked' : '' }>
														<label for="trgtAdm"><spring:message code="common.label.admin" /><!-- 관리자 --></label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="srvyTrgtTycd" id="trgtExtrnlLctrr" value="EXTRNL_LCTRR" ${vo.srvyTrgtTycd eq 'EXTRNL_LCTRR' ? 'checked' : '' }>
														<label for="trgtExtrnlLctrr"><spring:message code="srvy.label.external.lecturer" /><!-- 외부강사 --></label>
													</span>
												</div>
											</td>
										</tr>
										<tr>
											<th><label for="srvyTtl" class="req"><spring:message code="srvy.label.all.srvy.ttl" /><!-- 전체설문 제목 --></label></th>
											<td>
												<input class="form-control width-100per" type="text" id="srvyTtl" name="srvyTtl" value="${vo.srvyTtl }" required="true">
											</td>
										</tr>
										<tr>
									       	<th><label for="srvyCts" class="req"><spring:message code="srvy.label.all.srvy.cts" /><!-- 전체설문 설명 --></label></th>
									       	<td>
												<div class="editor-box">
													<%-- HTML 에디터 --%>
													<textarea id="srvyCts" name="srvyCts" required="true"><c:out value="${vo.srvyCts}"/></textarea>
						                            <script>
						                                // HTML 에디터
						                                editor = UiEditor({
						                                    targetId: "srvyCts",
						                                    uploadPath: "${vo.uploadPath}",
						                                    height: "300px"
						                                });
						                            </script>
												</div>
									       	</td>
										</tr>
										<tr>
											<th><label for="dateSt" class="req"><spring:message code="srvy.label.all.srvy.period" /><!-- 전체설문기간 --></label></th>
											<td>
												<input id="dateSt" type="text" name="dateSt" class="datepicker" timeId="timeSt" toDate="dateEd" value="${fn:substring(vo.srvySdttm,0,8)}" required="true">
												<input id="timeSt" type="text" name="timeSt" class="timepicker" dateId="dateSt" value="${fn:substring(vo.srvySdttm,8,12)}" required="true">
												<span class="txt-sort">~</span>
												<input id="dateEd" type="text" name="dateEd" class="datepicker" timeId="timeEd" fromDate="dateSt" value="${fn:substring(vo.srvyEdttm,0,8)}" required="true">
												<input id="timeEd" type="text" name="timeEd" class="timepicker" dateId="dateEd" value="${fn:substring(vo.srvyEdttm,8,12)}" required="true">
											</td>
										</tr>
										<tr>
											<th><label for="rsltOpen"><spring:message code="srvy.label.view.result" /><!-- 결과조회 --></label></th>
											<td>
												<div class="form-inline">
													<span class="custom-input">
														<input type="radio" name="rsltOpenTycd" id="rsltOpen" value="WHOL_OPEN" ${empty vo.srvyId || vo.rsltOpenTycd eq 'WHOL_OPEN' ? 'checked' : '' }>
														<label for="rsltOpen"><spring:message code="srvy.common.yes" /><!-- 예 --></label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="rsltOpenTycd" id="rsltClose" value="WHOL_CLOSE" ${vo.rsltOpenTycd eq 'WHOL_CLOSE' ? 'checked' : '' }>
														<label for="rsltClose"><spring:message code="srvy.common.no" /><!-- 아니오 --></label>
													</span>
												</div>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</form>
						<!--//table-type-->
                    </div>
                </div>
            </div>
            <!-- //content -->
        </main>
        <!-- //admin-->
    </div>
</body>
</html>