<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/srvy/common/srvy_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="module" value="editor,fileuploader"/>
	</jsp:include>

	<script type="text/javascript">
		const editors = {};	// 에디터 목록 저장용

		$(window).on('load', function() {
			// 팀설문수정시
			if(${not empty vo.srvyId && vo.srvyGbn eq 'SRVY_TEAM' }) {
				$("input[name='byteamSubsrvyUseyns']").each(function(i, e) {
					let sbjctId 	= e.value.split(":")[1];							// 과목아이디
					let teamGrpId 	= $("#teamGrpId" + sbjctId).val().split(":")[0];	// 팀그룹아이디
					let teamGrpnm 	= $("#teamGrpnm" + sbjctId).val();					// 팀그룹명

					// 팀선택
					selectTeam(teamGrpId, teamGrpnm, e.value);
				});
			}

			// 분반선택변경
			dvclasChcChange($("#allDeclas")[0]);

			// 설문등록 분반 클릭이벤트 해제
			const checkbox = document.querySelector('input[name="sbjctIds"].readonly');
			checkbox.addEventListener('click', (e) => e.preventDefault());
		});

	 	/*
		 * 이전설문가져오기팝업
		 * @param sbjctId	과목아이디
		 */
		function bfrSrvyCopyPopup() {
			dialog = UiDialog("dialog1", {
				title	: "<spring:message code='srvy.label.prev.srvy.copy' />",/* 이전설문 가져오기 */
				width	: 800,
				height	: 600,
				url		: "/srvy/profBfrSrvyCopyPopup.do?encParams="+$("#encParams").val()
			});
		}

	 	/**
		 * 설문복사
		 * @param srvyId - 설문아이디
		 */
	 	function srvyCopy(srvyId) {
	 		const url  = "/srvy/srvySelectAjax.do";
	 		const data = {
				srvyId : srvyId
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					let srvy = data.data;

	        		$("#srvyTtl").val(srvy.srvyTtl);													// 설문명
	        		editors['editor'].openHTML($.trim(srvy.srvyCts) == "" ? " " : srvy.srvyCts);		// 설문 내용
	        		$("input[name=mrkRfltyn][value='" + srvy.mrkRfltyn + "']").trigger("click");		// 성적 반영 여부
	        		$("input[name=evlScrTycd][value='" + srvy.evlScrTycd + "']").trigger("click");		// 평가방법
	        		$("input[name=rsltOpenTycd][value='" + srvy.rsltOpenTycd + "']").trigger("click");	// 설문결과 조회가능
	        		$("#searchValue").val(srvy.srvyId);													// 복사 설문 아이디
	        		dialog.close();
	            } else {
	            	UiComm.showMessage(data.message, "error");
	            }
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='srvy.error.copy' />", "error");/* 가져오기 중 에러가 발생하였습니다. */
			}, true);
	 	}

	    // 설문 등록, 수정
	    function save() {
	    	let validator = UiValidator("writeSrvyForm");
			validator.then(function(result) {
				if (result) {
					setValue();

					let url = "/srvy/srvyRegistAjax.do";
					if(${not empty vo.srvyId}) {
						url = "/srvy/srvyModifyAjax.do";
					}

					ajaxCall(url, $("#writeSrvyForm").serialize(), function (data) {
		                if (data.result > 0) {
							// 등록 or 문항출제미완료시
		                	if(${empty vo.srvyId} || ${vo.srvyQstnsCmptnyn ne 'Y'}) {
								UiComm.showMessage("<spring:message code='srvy.alert.already.srvy.qstn.submit' />", "info")	/* 설문 문항관리에서 문항을 출제 해 주세요. */
								.then(function(result) {
									srvyViewMv(data.data.srvyId, "PROFQSTN");	// 교수 설문 문항 관리 화면
								});
							} else {
								srvyViewMv("", "PROFLIST");	// 교수 설문 목록 화면
							}
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
			$("#srvySdttm").val(UiComm.getDateTimeVal("dateSt", "timeSt") + "00");						// 설문 시작일시
			$("#srvyEdttm").val(UiComm.getDateTimeVal("dateEd", "timeEd") + "59");						// 설문 종료일시
			$("#dvclasRegyn").val($("input:checkbox[name=sbjctIds]:checked").length > 1 ? "Y" : "N");	// 분반 체크 여부

			// 팀설문시
	    	if($("#srvyTeamynY").is(":checked")) {
				const subSrvys = [];
				// 팀그룹별설문설정시
	    		$("input[name='byteamSubsrvyUseyns']:checked").each(function(i, e) {
	    			$("#subInfoDiv"+e.id.split("_")[1]+" tr.subSrvyTr").each(function(index, element) {
						let ttl 	= $(element).find("input[name='subSrvyTtl']");
						let teamId  = ttl[0].id.split("_")[0];
						subSrvys.push({
							id	: teamId,									// 팀아이디
							ttl	: $.trim($(ttl).val()),						// 부주제
							cts	: $("#"+teamId+'_subSrvyCts_'+index).val()	// 부내용
						});
	    			});
	    		});
	    		$("#subSrvys").val(JSON.stringify(subSrvys));
	    	}
	    }

		/*
		 * 분반선택변경
		 * @param obj	선택한 분반 체크박스
		 */
		function dvclasChcChange(obj) {
			if(obj.value == "all") {
				$("input[name=sbjctIds]").not(".readonly").prop("checked", obj.checked);

				if(obj.checked) {
					$("div[id^='teamGrpView']").css("display", "flex");
					$("input[name='byteamSubsrvyUseyns']:checked").each(function(i, e) {
						$("#setSrvyDiv" + e.value).show();
					});
				} else {
					let fixSbjct = $("input[name=sbjctIds]").filter(".readonly")[0].value;
					$("div[id^='teamGrpView']").not("#teamGrpView"+fixSbjct).hide();
					$("div[id^='setSrvyDiv']").not("#setSrvyDiv"+fixSbjct).hide();
				}
			} else {
				$("#allDeclas").prop("checked", $("input[name=sbjctIds]").length == $("input[name=sbjctIds]:checked").length);
				$("#setSrvyDiv" + obj.value).toggle(obj.checked);

				if(obj.checked) {
					$("#teamGrpView" + obj.value).css("display", "flex");
				} else {
					$("#teamGrpView" + obj.value).hide();
				}
			}

			// 팀그룹 필수변경
			document.querySelectorAll('#teamSrvyDiv input[name=teamGrpnm]').forEach(input => {
				if($("#srvyTeamynY").is(":checked")) {
					input.setAttribute("required", $(input).is(':visible') ? "true" : "false");
				} else {
					input.setAttribute("required", "false");
				}
			});
		}

		/*
		 * 팀설문여부변경
		 * @param value		팀 설문 여부
		 */
		function teamynChange(value) {
			$("#teamSrvyDiv").toggle(value == "Y");

			// 팀그룹 필수변경
			document.querySelectorAll('#teamSrvyDiv input[name=teamGrpnm]').forEach(input => {
				if($("#srvyTeamynY").is(":checked")) {
					input.setAttribute("required", $(input).is(':visible') ? "true" : "false");
				} else {
					input.setAttribute("required", "false");
				}
			});
		}

		/*
		 * 팀그룹지정팝업
		 * @param i 		분반 순서
		 * @param sbjctId	과목아이디
		 */
	    function teamGrpChcPopup(i, sbjctId) {
			dialog = UiDialog("dialog1", {
				title	: "<spring:message code='srvy.button.assign.teams' />",/* 팀그룹지정 */
				width	: 600,
				height	: 500,
				url		: "/team/teamHome/teamCtgrSelectPop.do?sbjctId="+sbjctId+"&searchFrom="+i + ":" + sbjctId
			});
		}

	    /*
		 * 팀선택
		 * @param teamGrpId		팀그룹아이디
		 * @param teamGrpnm		팀그룹명
		 * @param id 			분반 순서:과목아이디
		 */
	    function selectTeam(teamGrpId, teamGrpnm, id) {
	    	let idList = id.split(':');
	    	$("#teamGrpId" + idList[1]).val(teamGrpId + ":" + idList[1]);
	    	$("#teamGrpnm" + idList[1]).val(teamGrpnm);
	    	$("#setSrvyDiv" + idList[1]).show();

	    	const url  = "/srvy/srvyTeamGrpSubAsmtListAjax.do";
	    	const data = {
				teamGrpId 	: teamGrpId,
				srvyId   	: $("#byteamSubsrvyUseyn_" + idList[1]).data("id")
			};

			$.ajax({
		        url 	  	: url,
		        async	  	: false,
		        type 	  	: "POST",
		        dataType 	: "json",
		        data 	  	: JSON.stringify(data),
		        contentType	: "application/json; charset=UTF-8",
		        beforeSend	: () => UiComm.showLoading(true),
                success		: function (data) {
                    if (data.result > 0) {
                    	let returnList = data.returnList || [];
    					let html = "";

    	        		if(returnList.length > 0) {
    						html += "<table class='table-type5 in_table'>";
    						html += "	<colgroup>";
    						html += "		<col class='width-5per' />";
    						html += "		<col class='width-15per' />";
    						html += "		<col class='' />";
    						html += "	</colgroup>";
    						html += "	<tbody>";
    	        			returnList.forEach(function(v, i) {
    							html += "	<tr class='subSrvyTr'>";
    							html += "		<th rowspan='2' class='group-header'><label>" + v.teamnm + "</label></th>";
    							html += "		<th><label for='" + v.teamId + "_srvyTtl_" + i + "' class='req'><spring:message code='srvy.label.sub.title' /></label></th>";/* 부주제 */
    							html += "		<td>";
    							html += "			<div class='form-row'>";
    							html += "				<input type='text' id='" + v.teamId + "_srvyTtl_" + i + "' name='subSrvyTtl' value='" + (v.srvyTtl == null ? '' : v.srvyTtl) + "' inputmask='byte' maxLen='200' class='form-control width-100per' />";
    							html += "			</div>";
    							html += "		</td>"
    							html += "	</tr>";
    							html += "	<tr>";
    							html += "		<th><label for='" + v.teamId + "_subSrvyCts_" + i + "' class='req'><spring:message code='common.label.contents' /></label></th>";/* 내용 */
    							html += "		<td>";
    							html += "			<label class='width-100per'>";
    							html += "				<textarea rows='4'";
    							html += "						  class='form-control resize-none'";
    							html += "						  name='" + v.teamId + "_subSrvyCts_" + i + "'";
    							html += "						  id='" + v.teamId + "_subSrvyCts_" + i + "'>";
    							html += 					(v.srvyCts == null ? '' : v.srvyCts);
    							html += "				</textarea>";
    							html += "			</label>";
    							html += "		</td>";
    							html += "	</tr>";
    	        			});
    						html += "	</tbody>";
    						html += "</table>";
    	        		}

    	        		$("#subInfoDiv" + idList[1]).empty().html(html);
    	        		UiInputmask();
    	        		if(returnList.length > 0) {
    	        			returnList.forEach(function(v, i) {
    	        				// html 에디터 생성
    	        				const editorId = v.teamId + "_subSrvyCts_" + i;
    							editors[editorId] = UiEditor({
    													targetId	: editorId,
    													uploadPath	: "${vo.uploadPath}",
    													height		: "250px"
    												});
    	        			});
    	        		}
                    } else {
                    	UiComm.showMessage(data.message, "error");
                    }
                },
                error		: () => UiComm.showMessage("<spring:message code='srvy.error.copy' />", "error"),	/* 가져오기 중 에러가 발생하였습니다. */
                complete	: () => UiComm.showLoading(false)
		    });
	    }

	    /*
		 * 팀그룹 설정여부 변경
		 * @param obj - 분반 팀그룹 과제 설정 체크박스
		 */
	    function byteamSubsrvyUseynChange(obj) {
	    	$("#subInfoDiv" + obj.id.split("_")[1]).toggle(obj.checked);
	    	// 부주제, 내용 필수변경
	    	document.querySelectorAll('#subInfoDiv'+obj.id.split("_")[1]+' input[name=subSrvyTtl], #subInfoDiv'+obj.id.split("_")[1]+' textarea').forEach(input => {
				input.setAttribute("required", obj.checked ? "true" : "false");
			});
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
				        <div class="page-info">
				        	<h2 class="page-title">
                                <spring:message code="srvy.common.srvy" /><!-- 설문 -->
                            </h2>
				        </div>
				        <!--table-type-->
				        <spring:message code="srvy.common.yes" var="yes" /><!-- 예 -->
				        <spring:message code="srvy.common.no"  var="no" /><!-- 아니오 -->
				        <div class="table-wrap">
							<form name="writeSrvyForm" id="writeSrvyForm" method="POST" autocomplete="off" onsubmit="return false;">
								<input type="hidden" name="encParams"    				value="<c:out value='${encParams}' />"	id="encParams" />
						    	<input type="hidden" name="srvyId" 						value="${vo.srvyId }" />
						        <input type="hidden" name="srvyGrpId" 					value="${vo.srvyGrpId }" />
						        <input type="hidden" name="mrkRfltrt" 					value="0" />
						        <input type="hidden" name="upSrvyId" 					value="" />
						        <input type="hidden" name="srvyWrtTycd" 				value="LMS_SRVY" />
						        <input type="hidden" name="srvyGbncd" 					value="LCTR_SRVY" />
						        <input type="hidden" name="srvyTycd"					value="SRVY_GNRL" />
						        <input type="hidden" name="srvyTrgtGbncd"				value="SBJCT" />
						        <input type="hidden" name="srvySdttm" 					value="${vo.srvySdttm }" 				id="srvySdttm" />
						        <input type="hidden" name="srvyEdttm" 					value="${vo.srvyEdttm }"  				id="srvyEdttm" />
						        <input type="hidden" name="dvclasRegyn" 				value="${vo.dvclasRegyn }"	   			id="dvclasRegyn" />
						        <input type="hidden" name="subSrvys" 					value=""	   							id="subSrvys" />
						        <input type="hidden" name="searchValue"															id="searchValue" />
						        <table class="table-type5">
						        	<colgroup>
						        		<col class="width-15per" />
						        		<col class="" />
						        	</colgroup>
						        	<tbody>
						        		<tr>
						        			<th><label for="srvyTtl" class="req"><spring:message code="srvy.label.title" /><!-- 설문명 --></label></th>
						        			<td>
						        				<input type="text" name="srvyTtl" id="srvyTtl" inputmask="byte" maxLen="200" class="width-100per" required="true" value="${vo.srvyTtl }">
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label for="srvyCts" class="req"><spring:message code="srvy.label.cts" /><!-- 설문내용 --></label></th>
						        			<td>
												<div class="editor-box">
													<%-- HTML 에디터 --%>
													<textarea id="srvyCts" name="srvyCts" required="true"><c:out value="${vo.srvyCts}"/></textarea>
                                                    <script>
                                                        // HTML 에디터
                                                        editors['editor'] = UiEditor({
                                                            targetId: "srvyCts",
                                                            uploadPath: "${vo.uploadPath}",
                                                            height: "300px"
                                                        });
                                                    </script>
												</div>
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label for="contLabel" class="req"><spring:message code="srvy.label.dvclas.batch.regist" /><!-- 분반 일괄 등록 --></label></th>
						        			<td>
						        				<div class="checkbox_type">
						        					<span class="custom-input">
														<input type="checkbox" name="allDeclasNo" value="all" id="allDeclas" onchange="dvclasChcChange(this)">
														<label for="allDeclas"><spring:message code="srvy.common.all" /><!-- 전체 --></label>
													</span>
													<c:forEach var="list" items="${dvclasList }">
												        <c:set var="sbjctChk" value="N" />
												        <c:forEach var="item" items="${sbjctList }">
												        	<c:if test="${item.sbjctId eq list.sbjctId }">
												        		<c:set var="sbjctChk" value="Y" />
												        	</c:if>
												        </c:forEach>
												        <span class="custom-input">
															<input type="checkbox" ${list.sbjctId eq uiex:getParamValue('sbjctId') || sbjctChk eq 'Y' ? 'class="readonly" checked' : '' } name="sbjctIds" id="declas_${list.sbjctId }" value="${list.sbjctId }" onchange="dvclasChcChange(this)">
															<label for="declas_${list.sbjctId }">${list.dvclasNo }<spring:message code="srvy.label.decls" /><!-- 반 --></label>
														</span>
											        </c:forEach>
						        				</div>
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label for="contLabel" class="req"><spring:message code="srvy.label.set.lctr.wkno" /><!-- 강의목록 주차 설정 --></label></th>
						        			<td>
						        				<select class="form-select" name="lctrWknoSchdlId" required="true">
			                                		<option value=""><spring:message code="common.label.lesson.schedule" /><!-- 주차 --></option>
				                                    <c:forEach var="item" items="${lctrWknoList }">
										            	<option value="${item.lctrWknoSchdlId }" ${item.lctrWknoSchdlId eq vo.lctrWknoSchdlId || item.curLctrWkno eq 'Y' ? 'selected' : '' }>${item.lctrWknonm }</option>
										            </c:forEach>
				                                </select>
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label for="dateSt" class="req"><spring:message code="srvy.label.period" /><!-- 설문기간 --></label></th>
						        			<td>
						        				<input id="dateSt" type="text" name="dateSt" class="datepicker" timeId="timeSt" toDate="dateEd" value="${fn:substring(vo.srvySdttm,0,8)}" required="true">
												<input id="timeSt" type="text" name="timeSt" class="timepicker" dateId="dateSt" value="${fn:substring(vo.srvySdttm,8,12)}" required="true">
												<span class="txt-sort">~</span>
												<input id="dateEd" type="text" name="dateEd" class="datepicker" timeId="timeEd" fromDate="dateSt" value="${fn:substring(vo.srvyEdttm,0,8)}" required="true">
												<input id="timeEd" type="text" name="timeEd" class="timepicker" dateId="dateEd" value="${fn:substring(vo.srvyEdttm,8,12)}" required="true">
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label class="req"><spring:message code="srvy.label.score.aply.yn" /><!-- 성적반영 --></label></th>
						        			<td>
						        				<span class="custom-input">
													<input type="radio" name="mrkRfltyn" id="mrkRfltynY" value="Y" ${vo.mrkRfltyn eq 'Y' || empty vo.srvyId ? 'checked' : '' }>
													<label for="mrkRfltynY">${yes }</label>
												</span>
												<span class="custom-input ml5">
													<input type="radio" name="mrkRfltyn" id="mrkRfltynN" value="N" ${vo.mrkRfltyn eq 'N' ? 'checked' : '' }>
													<label for="mrkRfltynN">${no }</label>
												</span>
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label class="req"><spring:message code="srvy.label.score.open.yn" /><!-- 성적공개 --></label></th>
						        			<td>
						        				<span class="custom-input">
													<input type="radio" name="mrkOyn" id="mrkOynY" value="Y" ${vo.mrkOyn eq 'Y' || empty vo.srvyId ? 'checked' : '' }>
													<label for="mrkOynY">${yes }</label>
												</span>
												<span class="custom-input ml5">
													<input type="radio" name="mrkOyn" id="mrkOynN" value="N" ${vo.mrkOyn eq 'N' ? 'checked' : '' }>
													<label for="mrkOynN">${no }</label>
												</span>
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label><spring:message code="srvy.label.evl.method" /><!-- 평가방법 --></label></th>
						        			<td>
						        				<span class="custom-input">
													<input type="radio" name="evlScrTycd" id="scrEvlTycd" value="SCR" ${vo.evlScrTycd eq 'SCR' || empty vo.srvyId ? 'checked' : '' }>
													<label for="scrEvlTycd"><spring:message code="srvy.label.evl.ctgr.score" /><!-- 점수형 --></label>
												</span>
												<span class="custom-input ml5">
													<input type="radio" name="evlScrTycd" id="ptcpEvlTycd" value="PTCP_FULL_SCR" ${vo.evlScrTycd eq 'PTCP_FULL_SCR' ? 'checked' : '' }>
													<label for="ptcpEvlTycd"><spring:message code="srvy.label.evl.ctgr.ptcp" /><!-- 참여형 --></label>
												</span>
												<span class="fcBlue">
													( <spring:message code="srvy.label.evl.ctgr.info" /><!-- 설문 참여 : 100점, 미참여 : 0점 자동배점 --> )
												</span>
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label><spring:message code="srvy.label.view.result.yn" /><!-- 설문결과 조회가능 --></label></th>
						        			<td>
						        				<span class="custom-input">
													<input type="radio" name="rsltOpenTycd" id="rsltOpen" value="WHOL_OPEN" ${vo.rsltOpenTycd eq 'WHOL_OPEN' || empty vo.srvyId ? 'checked' : '' }>
													<label for="rsltOpen">${yes }</label>
												</span>
												<span class="custom-input ml5">
													<input type="radio" name="rsltOpenTycd" id="rsltClose" value="WHOL_CLOSE" ${vo.rsltOpenTycd eq 'WHOL_CLOSE' ? 'checked' : '' }>
													<label for="rsltClose">${no }</label>
												</span>
						        			</td>
						        		</tr>
										<tr>
						        			<th><label><spring:message code="srvy.label.team.srvy" /><!-- 팀 설문 --></label></th>
						        			<td>
						        				<div class="form-inline">
													<span class="custom-input">
														<input type="radio" name="srvyTeamyn" id="srvyTeamynN" value="N" onchange="teamynChange(this.value)" ${empty vo.srvyId || vo.srvyGbn ne 'SRVY_TEAM' ? 'checked' : ''}>
														<label for="srvyTeamynN">${no }</label>
													</span>
							        				<span class="custom-input ml5">
														<input type="radio" name="srvyTeamyn" id="srvyTeamynY" value="Y" onchange="teamynChange(this.value)" ${vo.srvyGbn eq 'SRVY_TEAM' ? 'checked' : ''}>
														<label for="srvyTeamynY">${yes }</label>
													</span>
						        				</div>
												<div id="teamSrvyDiv" class="team_item" ${empty vo.srvyId || vo.srvyGbn ne 'SRVY_TEAM' ? 'style="display:none"' : '' }>
										        	<c:forEach var="list" items="${dvclasList }" varStatus="i">
														<div class="item" id='teamGrpView${list.sbjctId}'>
															<label class="label_num">${list.dvclasNo }<spring:message code="srvy.label.decls" /><!-- 반 --></label>
															<input type='hidden' id='teamGrpId${list.sbjctId}' name='teamGrpIds' value="${empty vo.srvyId ? '' : list.teamGrpId}:${list.sbjctId}">
															<input class="form-control wide" type="text" name="teamGrpnm" id="teamGrpnm${list.sbjctId}" placeholder="<spring:message code='srvy.placeholder.select.team.group' />" value="${empty vo.srvyId ? '' : list.teamGrpnm}" readonly="true" autocomplete="off"><!-- 팀그룹을 선택해 주세요. -->
															<button type="button" class="btn basic" onclick="teamGrpChcPopup('${list.dvclasNo}','${list.sbjctId }')"><spring:message code="srvy.button.assign.teams" /><!-- 팀그룹지정 --></a>
														</div>
											        	<c:if test="${i.count eq 1 }">
															<small class="note2"><spring:message code="srvy.label.select.team.group.info" /><!-- ! 구성된 팀이 없는 경우 메뉴 “과목설정 > 팀그룹지정”에서 팀을 생성해 주세요 --></small>
											        	</c:if>
											        	<div class="item_setting" id="setSrvyDiv${list.sbjctId }" style="display:none;">
		                                                    <div class="checkbox_type">
		                                                        <span class="custom-input">
		                                                            <input type="checkbox" id="byteamSubsrvyUseyn_${list.sbjctId }" name="byteamSubsrvyUseyns" data-Id="${not empty vo.srvyId && list.byteamSubsrvyUseyn eq 'Y' ? list.srvyId : '' }" value="${list.dvclasNo}:${list.sbjctId }" onchange="byteamSubsrvyUseynChange(this)" ${not empty vo.srvyId && list.byteamSubsrvyUseyn eq 'Y' ? 'checked' : '' }>
		                                                            <label for="byteamSubsrvyUseyn_${list.sbjctId }"><spring:message code="srvy.label.team.group.set.srvy" /><!-- 팀그룹별 설문 설정 --></label>
		                                                        </span>
		                                                    </div>
		                                                </div>
		                                                <div id="subInfoDiv${list.sbjctId }" class="table-wrap mb30" ${not empty vo.srvyId && list.byteamSubsrvyUseyn eq 'Y' ? '' : 'style="display: none;"' }></div>
										        	</c:forEach>
										        </div>
						        			</td>
						        		</tr>
						        	</tbody>
						        </table>
							</form>
				        </div>
				        <!--table-type-->
				        <spring:message code="common.button.save" var="save" /><!-- 저장 -->
				        <spring:message code="common.button.modify"  var="modify" /><!-- 수정 -->
				        <div class="btns">
					        <a href="javascript:save()" class="btn type1">${empty vo.srvyId ? save : modify }</a>
					        <a href="javascript:bfrSrvyCopyPopup()" class="btn type2"><spring:message code="srvy.button.prev.srvy.copy" /><!-- 이전 설문 가져오기 --></a>
					        <a href="javascript:srvyViewMv('', 'PROFLIST')" class="btn type2"><spring:message code="srvy.button.list" /></a><!-- 목록 -->
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