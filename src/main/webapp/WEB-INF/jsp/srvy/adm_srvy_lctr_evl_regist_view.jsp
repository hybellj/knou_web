<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/srvy/common/srvy_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="admin"/>
		<jsp:param name="module" value="table,editor"/>
	</jsp:include>

	<script type="text/javascript">
		var editor;	// 에디터 목록 저장용

		$(document).ready(function () {
			// 학사년도
			$('#dgrsYr').on('change', function() {
				selectOption.smstrChrt()
			    .then(() => sbjctListSelect())
			    .catch(() => {});
		    });

			selectOption.smstrChrt()
		    .then(() => sbjctListSelect())
		    .catch(() => {});

			if(${not empty vo.srvyId}) {
				srvyWrtChc("${vo.srvyWrtTycd}");
			}
		});

		// 과목목록조회
		function sbjctListSelect() {
			const data = {
				orgId 		: $("#orgId").val(),
				dgrsYr		: $("#dgrsYr").val(),
				smstrChrtId	: $("#smstrChrtId").val(),
				srvyTycd	: $("input[name=srvyTycd]:checked").val(),
				srvyId		: "${vo.srvyId}"
			};

			$.ajax({
                url			: "/srvy/admSrvyLctrEvlNRegistSbjctListAjax.do",
                type		: "POST",
                contentType	: "application/json",
                data		: JSON.stringify(data),
                dataType	: "json",
                beforeSend	: () => UiComm.showLoading(true),
                success		: function (data) {
                    if (data.result > 0) {
                    	let returnList = data.returnList || [];
                    	let dataList = [];

    	        		if(returnList.length > 0) {
    	        			returnList.forEach(function(v, i) {
    	        				dataList.push({
    	        					orgnm: 		v.orgnm,
    	        					sbjctCd: 	v.sbjctCd,
    	        					sbjctnm: 	v.sbjctnm,
    	        					dvclasNo: 	v.dvclasNo,
    	        					profnm: 	v.profnm,
    	        					tutnm: 		v.tutnm,
    	        					sbjctId:	v.sbjctId
    	    					});
    	        			});
    	        		}

    	        		sbjctListTable.clearData();
    	        		sbjctListTable.replaceData(dataList);

    	        		const isSbjct = $("input[name=srvyTrgtGbncd]:checked").val() === "SBJCT";
    	        		// 헤더 체크박스
    	        		$("#list .tabulator-col input[type='checkbox']").prop("disabled", !isSbjct);
    	        		$("#list .tabulator-col .tabulator-col-content").css("pointer-events", isSbjct ? "" : "none");

    	        		// Row 체크박스
    	        		sbjctListTable.getRows().forEach(row => {
    	        		    let $checkbox = $(row.getElement()).find("input[type='checkbox']");
    	        		    $checkbox.prop("disabled", !isSbjct);
    	        		    $checkbox.closest(".tabulator-cell").css("pointer-events", isSbjct ? "" : "none");
    	        		});

    	        		if(isSbjct) {
    	        		    // 수정시 기존 설정과목 선택
    	        		    const targets = [<c:forEach items="${sbjctList}" var="s" varStatus="vs">"${s.sbjctId}"${!vs.last ? ',' : ''}</c:forEach>];
    	        		    sbjctListTable.getRows().forEach(row => {
    	        		        if(targets.includes(row.getData().sbjctId)) {
    	        		            row.select();
    	        		        }
    	        		    });
    	        		} else {
    	        		    sbjctListTable.selectRow();
    	        		}
                    } else {
                    	UiComm.showMessage(data.message, "error");
                    }
                },
                error		: () => UiComm.showMessage("<spring:message code='srvy.error.list' />", "error"),	/* 리스트 조회 중 에러가 발생하였습니다. */
                complete	: () => UiComm.showLoading(false)
            });
		}

		// 관리 구분 변경이벤트
		function srvyWrtChc(value) {
			$(".acadTr").toggle(value == "ACAD_LINK_SRVY");
		}

		// 강의평가 등록, 수정
	    function save() {
	    	let validator = UiValidator("srvyLctrEvlFrm");
			validator.then(function(result) {
				if (result) {
					if(sbjctListTable.getSelectedData("sbjctId").length == 0) {
						UiComm.showMessage("<spring:message code='srvy.alert.lctr.evl.regist.sbjct.select' />", "info");/* 강의평가를 등록할 과목을 선택해주세요. */
						return;
					}

					setValue();

					let url = "/srvy/admSrvyLctrEvlRegistAjax.do";
					if(${not empty vo.srvyId}) {
						url = "/srvy/admSrvyLctrEvlModifyAjax.do";
					}

					ajaxCall(url, $("#srvyLctrEvlFrm").serialize(), function (data) {
		                if (data.result > 0) {
		                	srvyViewMv(data.data.srvyId, "ADMEVLVIEW");	// 관리자 설문 강의평가 정보 화면
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
			$("#srvySdttm").val(UiComm.getDateTimeVal("dateSt", "timeSt") + "00");	// 강의평가 시작일시
			$("#srvyEdttm").val(UiComm.getDateTimeVal("dateEd", "timeEd") + "59");	// 강의평가 종료일시
			$("#sbjctIds").val(sbjctListTable.getSelectedData("sbjctId"));
	    }

	 	/**
		 * 이전강의평가가져오기팝업
		 * @param srvyId	설문아이디
		 * @param orgId		기관아이디
		 */
	 	function bfrSrvyLctrEvlCopyPopup() {
			let data = "orgId="+$("#orgId").val()+"&srvyId=${vo.srvyId}";
	 		dialog = UiDialog("dialog1", {
				title	: "<spring:message code='srvy.button.prev.lctr.evl.copy' />",/* 이전 강의평가 가져오기 */
				width	: 800,
				height	: 600,
				url		: "/srvy/admBfrSrvyLctrEvlCopyPopup.do?"+data
			});
	 	}

	 	/*
		 * 설문강의평가복사
		 * @param srvyId	설문아이디
		 */
	 	function srvyLctrEvlCopy(srvyId) {
	 		const url  = "/srvy/admSrvyLctrEvlSelectAjax.do";
	 		const data = {
				srvyId : srvyId
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					let srvy = data.data;

	        		$("#srvyTtl").val(srvy.srvyTtl);													// 강의평가 제목
	        		editor.openHTML($.trim(srvy.srvyCts) == "" ? " " : srvy.srvyCts);					// 강의평가 설명
	        		$("input[name=srvyTycd][value='" + srvy.srvyTycd + "']").trigger("click");			// 강의평가 구분
	        		$("input[name=srvyWrtTycd][value='" + srvy.srvyWrtTycd + "']").trigger("click");	// 관리 구분
	        		$("input[name=mrkOyn][value='" + srvy.mrkOyn + "']").trigger("click");				// 강의평가 후 성적조회
	        		$("input[name=rsltOpenTycd][value='" + srvy.rsltOpenTycd + "']").trigger("click");	// 강의평가 결과조회
	        		$("#searchValue").val(srvy.srvyId);													// 복사 강의평가 아이디
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
							<h3 class="board-title"><spring:message code="srvy.button.write" /><!-- 등록 --></h3>
							<div class="right-area">
								<button type="button" class="btn type2 big" onclick="bfrSrvyLctrEvlCopyPopup()"><spring:message code="srvy.button.prev.lctr.evl.copy" /><!-- 이전 강의평가 가져오기 --></button>
								<button type="button" class="btn type2 big" onclick="save()"><spring:message code="srvy.button.save" /><!-- 저장 --></button>
								<button type="button" class="btn type2 big" onclick="srvyViewMv('', 'ADMEVLLIST')"><spring:message code="srvy.button.list" /><!-- 목록 --></button>
							</div>
						</div>

						<!--table-type-->
						<form id="srvyLctrEvlFrm" onsubmit="return false;">
							<input type="hidden" name="srvyId"				value="${vo.srvyId }" />
							<input type="hidden" name="srvyGbncd" 			value="LCTR_SRVY" />
							<input type="hidden" name="dvclasRegyn"			value="N" />
							<input type="hidden" name="mrkRfltyn"			value="N" />
							<input type="hidden" name="byteamSubsrvyUseyn"	value="N" />
							<input type="hidden" name="srvySdttm"						id="srvySdttm" />
							<input type="hidden" name="srvyEdttm"						id="srvyEdttm" />
							<input type="hidden" name="sbjctIds"						id="sbjctIds" />
							<input type="hidden" name="searchValue"						id="searchValue" />
							<div class="table-wrap">
								<table class="table-type5">
									<colgroup>
										<col class="width-15per" />
										<col class="" />
									</colgroup>
									<tbody>
										<tr>
											<th><label for="orgId" class="req"><spring:message code="srvy.label.org" /></label></th>
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
												<select class="form-select wide" id="dgrsYr">
			                                    	<c:forEach var="year" items="${yearList }">
			                                    		<option value="${year }" ${(not empty vo.srvyId && vo.dgrsYr eq year) || year eq curYear ? 'selected' : '' }>${year }</option>
			                                    	</c:forEach>
			                                    </select>
												<select class="form-select wide" id="smstrChrtId" onchange="sbjctListSelect()" required="true">
	                                    		</select>
											</td>
										</tr>
										<tr>
											<th><label for="trgtWhol" class="req"><spring:message code="common.label.ctgr" /><!-- 분류 --></label></th>
											<td>
												<div class="form-inline">
													<span class="custom-input">
														<input type="radio" name="srvyTrgtGbncd" id="trgtWhol" value="WHOL" ${empty vo.srvyId || vo.srvyTrgtGbncd eq 'WHOL' ? 'checked' : '' } onchange="sbjctListSelect()">
														<label for="trgtWhol"><spring:message code="srvy.label.batch" /><!-- 일괄 --></label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="srvyTrgtGbncd" id="trgtSbjct" value="SBJCT" ${vo.srvyTrgtGbncd eq 'SBJCT' ? 'checked' : '' } onchange="sbjctListSelect()">
														<label for="trgtSbjct"><spring:message code="srvy.label.by.sbjct" /><!-- 과목별 --></label>
													</span>
												</div>
											</td>
										</tr>
										<tr>
											<th colspan="2"><label class="req"><spring:message code="srvy.label.select.sbjct" /><!-- 과목 선택 --></label></th>
										</tr>
									</tbody>
								</table>
								<div id="list"></div>
								<script>
									// 리스트 테이블
									let sbjctListTable = UiTable("list", {
										lang: "ko",
										selectRow: "checkbox",
										height: 250,
										columns: [
											{title:"<spring:message code='srvy.label.org' />", 				field:"orgnm",			headerHozAlign:"center", hozAlign:"center", width:150,	minWidth:150},/* 기관 */
											{title:"<spring:message code='common.label.crsauth.crscd' />", 	field:"sbjctCd",		headerHozAlign:"center", hozAlign:"center",	width:150,	minWidth:150},/* 과목코드 */
											{title:"<spring:message code='srvy.label.sbjct.nm' />", 		field:"sbjctnm", 		headerHozAlign:"center", hozAlign:"left", 	width:0, 	minWidth:280},/* 과목명 */
											{title:"<spring:message code='srvy.label.dvclas' />", 			field:"dvclasNo", 		headerHozAlign:"center", hozAlign:"center", width:50,	minWidth:50},/* 분반 */
											{title:"<spring:message code='common.charge.professor' />", 	field:"profnm", 		headerHozAlign:"center", hozAlign:"center", width:120,	minWidth:120},/* 담당교수 */
											{title:"<spring:message code='srvy.label.charge.tutor' />", 	field:"tutnm",	 		headerHozAlign:"center", hozAlign:"center", width:120,	minWidth:120}/* 담당튜터 */
										]
									});
								</script>
	                            <table class="table-type5">
									<colgroup>
										<col class="width-15per" />
										<col class="" />
									</colgroup>
									<tbody>
										<tr>
											<th><label for="srvyTtl" class="req"><spring:message code="srvy.label.lctr.evl.ttl" /><!-- 강의평가 제목 --></label></th>
											<td>
												<input class="form-control width-100per" type="text" id="srvyTtl" name="srvyTtl" value="${vo.srvyTtl }" required="true">
											</td>
										</tr>
										<tr>
									       	<th><label for="srvyCts" class="req"><spring:message code="srvy.label.lctr.evl.cts" /><!-- 강의평가 내용 --></label></th>
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
											<th><label for="srvyMidExam" class="req"><spring:message code="srvy.label.lctr.evl.type" /><!-- 강의평가 구분 --></label></th>
											<td>
												<div class="form-inline">
													<span class="custom-input">
														<input type="radio" name="srvyTycd" id="srvyMidExam" value="SRVY_MIDEXAM_AFTR_LCTR_EVL" ${empty vo.srvyId || fn:contains(vo.srvyTycd, 'MIDEXAM') ? 'checked' : '' } onchange="sbjctListSelect()">
														<label for="srvyMidExam"><spring:message code="srvy.label.mid.exam" /><!-- 중간고사 --></label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="srvyTycd" id="srvyLstExam" value="SRVY_LSTEXAM_AFTR_LCTR_EVL" ${fn:contains(vo.srvyTycd, 'LSTEXAM') ? 'checked' : '' } onchange="sbjctListSelect()">
														<label for="srvyLstExam"><spring:message code="srvy.label.lst.exam" /><!-- 기말고사 --></label>
													</span>
												</div>
											</td>
										</tr>
										<tr>
											<th><label for="dateSt" class="req"><spring:message code="srvy.label.lctr.evl.period" /><!-- 강의평가기간 --></label></th>
											<td>
												<input id="dateSt" type="text" name="dateSt" class="datepicker" timeId="timeSt" toDate="dateEd" value="${fn:substring(vo.srvySdttm,0,8)}" required="true">
												<input id="timeSt" type="text" name="timeSt" class="timepicker" dateId="dateSt" value="${fn:substring(vo.srvySdttm,8,12)}" required="true">
												<span class="txt-sort">~</span>
												<input id="dateEd" type="text" name="dateEd" class="datepicker" timeId="timeEd" fromDate="dateSt" value="${fn:substring(vo.srvyEdttm,0,8)}" required="true">
												<input id="timeEd" type="text" name="timeEd" class="timepicker" dateId="dateEd" value="${fn:substring(vo.srvyEdttm,8,12)}" required="true">
											</td>
										</tr>
										<tr>
											<th><label for="srvyAcad" class="req"><spring:message code="srvy.label.manage.type" /><!-- 관리구분 --></label></th>
											<td>
												<div class="form-inline">
													<span class="custom-input">
														<input type="radio" name="srvyWrtTycd" id="srvyAcad" value="ACAD_LINK_SRVY" ${empty vo.srvyId || vo.srvyWrtTycd eq 'ACAD_LINK_SRVY' ? 'checked' : '' } onchange="srvyWrtChc(this.value)">
														<label for="srvyAcad"><spring:message code="srvy.label.acad.sync" /><!-- 학사연동 --></label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="srvyWrtTycd" id="srvyLms" value="LMS_SRVY" ${vo.srvyWrtTycd eq 'LMS_SRVY' ? 'checked' : '' } onchange="srvyWrtChc(this.value)">
														<label for="srvyLms"><spring:message code="srvy.label.lms.manage" /><!-- LMS에서 관리 --></label>
													</span>
												</div>
											</td>
										</tr>
										<tr class="acadTr">
											<th><label><spring:message code="srvy.label.sync.url" /><!-- 연동 URL --></label></th>
											<td>
												<input class="form-control width-70per" type="text" id="tempUrl" readonly="true">
												<button type="button" class="btn type1 small"><spring:message code="srvy.button.preview" /><!-- 미리보기 --></button>
											</td>
										</tr>
										<tr>
											<th><label for="mrkY"><spring:message code="srvy.label.lctr.evl.score.view" /><!-- 강의평가 후 성적조회 --></label></th>
											<td>
												<div class="form-inline">
													<span class="custom-input">
														<input type="radio" name="mrkOyn" id="mrkY" value="Y" ${empty vo.srvyId || vo.mrkOyn eq 'Y' ? 'checked' : '' }>
														<label for="mrkY"><spring:message code="srvy.common.yes" /><!-- 예 --></label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="mrkOyn" id="mrkN" value="N" ${vo.mrkOyn eq 'N' ? 'checked' : '' }>
														<label for="mrkN"><spring:message code="srvy.common.no" /><!-- 아니오 --></label>
													</span>
												</div>
											</td>
										</tr>
										<tr>
											<th><label for="rsltOpen"><spring:message code="srvy.label.lctr.evl.view.result" /><!-- 강의평가 결과조회 --></label></th>
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