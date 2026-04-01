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
		var dialog;
		const editors = {};	// 에디터 목록 저장용

		$(window).on('load', function() {
			if(${not empty vo.srvyId && vo.srvyGbn eq 'SRVY_TEAM' }) {
				// 부과제 조회
				$("input[name='byteamSubsrvyUseyns']").each(function(i, e) {
					var lrnGrpId = $("#lrnGrpId" + e.id.split("_")[1]).val().split(":")[0];	// 학습그룹아이디
					var lrnGrpnm = $("#lrnGrpnm" + e.id.split("_")[1]).val();				// 학습그룹명
					var dvclasNo = e.id.split("_")[1];										// 분반 순서
					var sbjctId = e.value.split(":")[1];									// 과목아이디

					selectTeam(lrnGrpId, lrnGrpnm, dvclasNo+":"+sbjctId);
				});
			}

			dvclasChcChange($("#allDeclas")[0]);

			// 설문 등록 분반 클릭 이벤트 해제
			const checkbox = document.querySelector('input[name="sbjctIds"].readonly');
			checkbox.addEventListener('click', (e) => {
				e.preventDefault();
			});
		});

	 	// 이전 설문 가져오기 팝업
		function bfrSrvyCopyPopup() {
			var data = "sbjctId=${sbjctId}";

			dialog = UiDialog("dialog1", {
				title: "이전설문 가져오기",
				width: 800,
				height: 450,
				url: "/srvy/profBfrSrvyCopyPopup.do?"+data,
				autoresize: true
			});
		}

	 	/**
		 * 설문복사
		 * @param {String}  srvyId 	- 설문아이디
		 * @returns {vo} 설문정보
		 */
	 	function srvyCopy(srvyId) {
	 		var url  = "/srvy/srvySelectAjax.do";
			var data = {
				"srvyId" : srvyId
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		var srvy = data.returnVO;

	        		// 설문명
	        		$("#srvyTtl").val(srvy.srvyTtl);
	        		// 설문 내용
	        		$("#srvyCts").val(srvy.srvyCts);
	        		$("#new_srvyCts .se-contents").html($.trim(srvy.srvyCts) == "" ? " " : srvy.srvyCts);
	        		// 성적반영
	        		var mrkRfltId = srvy.mrkRfltyn == "Y" ? "mrkRfltynY" : "mrkRfltynN";
	        		$("#"+mrkRfltId).trigger("click");
	        		// 평가방법
	        		var evlScrId = srvy.evlScrTycd == "SCR" ? "scrEvlTycd" : "ptcpEvlTycd";
	        		$("#"+evlScrId).trigger("click");
	        		// 설문결과 조회가능
	        		var rsltOpenId = srvy.rsltOpenTycd == "WHOL_OPEN" ? "rsltOpen" : "rsltClose";
	        		$("#"+rsltOpenId).trigger("click");
	        		dialog.close();
	            } else {
	            	UiComm.showMessage(data.message, "error");
	            }
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='exam.error.copy' />", "error");/* 가져오기 중 에러가 발생하였습니다. */
			});
	 	}

	    // 설문 등록, 수정
	    function save() {
	    	let validator = UiValidator("writeSrvyForm");
			validator.then(function(result) {
				if (result) {
					if(!isNull()) {
						return false;
					}

					setValue();
					UiComm.showLoading(true);

					var url = "/srvy/srvyRegistAjax.do";
					if(${not empty vo.srvyId}) {
						url = "/srvy/srvyModifyAjax.do";
					}
					$.ajax({
					    url 	 : url,
					    async	 : false,
					    type 	 : "POST",
					    dataType : "json",
					    data 	 : $("#writeSrvyForm").serialize(),
					}).done(function(data) {
						UiComm.showLoading(false);
						if (data.result > 0) {
							if(${empty vo.srvyId} || ${vo.srvyQstnsCmptnyn ne 'Y'}) {
								UiComm.showMessage("<spring:message code='resh.alert.already.resh.qstn.submit' />", "info")	/* 설문 문항관리에서 문항을 출제 해 주세요. */
								.then(function(result) {
									srvyViewMv("qstn", data.returnVO.srvyId);
								});
							} else {
								srvyViewMv("list", '');
							}
					    } else {
					     	UiComm.showMessage(data.message, "error");
					    }
					}).fail(function() {
						UiComm.showLoading(false);
						if(${empty vo.srvyId}) {
							UiComm.showMessage("<spring:message code='exam.error.insert' />", "error");	/* 저장 중 에러가 발생하였습니다. */
						} else {
							UiComm.showMessage("<spring:message code='exam.error.update' />", "error");	/* 수정 중 에러가 발생하였습니다. */
						}
					});
				}
			});
	    }

	    // 빈 값 체크
	    function isNull() {
			// 팀 설문 설정시
			if($("#srvyTeamynY").is(":checked")) {
				var isResult = true;
				var alertMsg = "";
				$("input[name=lrnGrpnm]:visible").each(function(i, e) {
					if(e.value == "") {
						isResult = false;
						alertMsg = "학습그룹을 지정하세요.";
						return false;
					}
				});

				// 팀 설문 학습그룹별 부 과제 설정시
				$("input[name='byteamSubsrvyUseyns']:checked").each(function(i, e) {
					if(!isResult) return false;
					$("#subInfoDiv"+e.id.split("_")[1]+" tr.subSrvyTr").each(function(index, element) {
						var ttl = $(element).find("input[name='subSrvyTtl']");
						if($.trim($(ttl).val()) == "") {
							isResult = false;
							alertMsg = "<spring:message code='exam.alert.input.title' />"	/* 제목을 입력하세요. */
							return false;
						}

						var teamId = ttl[0].id.split("_")[0];
						if(editors[teamId+'_editor'+index].isEmpty() || editors[teamId+'_editor'+index].getTextContent().trim() === "") {
							isResult = false;
							alertMsg = "<spring:message code='exam.alert.input.contents' />";	/* 내용을 입력하세요. */
				 			return false;
				 		}
					});
				});
				if(!isResult) {
					UiComm.showMessage(alertMsg, "warning");
					return false;
				}
			}

			return true;
	    }

	    // 값 채우기
	    function setValue() {
			// 설문 시작일시
			$("#srvySdttm").val(UiComm.getDateTimeVal("dateSt", "timeSt") + "00");

			// 설문 종료일시
			$("#srvyEdttm").val(UiComm.getDateTimeVal("dateEd", "timeEd") + "59");

			// 분반 체크 여부
			$("#dvclasRegyn").val($("input:checkbox[name=sbjctIds]:checked").length > 1 ? "Y" : "N");

			// 팀 설문 학습그룹별 부 과제 설정시
	    	if($("#srvyTeamynY").is(":checked")) {
				const subSrvys = [];
	    		$("input[name='byteamSubsrvyUseyns']:checked").each(function(i, e) {
	    			$("#subInfoDiv"+e.id.split("_")[1]+" tr.subSrvyTr").each(function(index, element) {
						var ttl = $(element).find("input[name='subSrvyTtl']");
						var teamId = ttl[0].id.split("_")[0];

						const map = {
							id: teamId,
							ttl: $.trim($(ttl).val()),
							cts: editors[teamId+'_editor'+index].getPublishingHtml()
						};
						subSrvys.push(map);
	    			});
	    		});
	    		$("#subSrvys").val(JSON.stringify(subSrvys));
	    	}
	    }

		/**
		 * 설문 화면 이동
		 * @param {String}  srvyId 	- 설문아이디
		 * @param {String}  sbjctId - 과목아이디
		 */
		function srvyViewMv(type, srvyId) {
			var urlMap = {
				"qstn" : "/srvy/profSrvyQstnMngView.do",	// 설문 문항 관리 화면
				"list" : "/srvy/profSrvyListView.do"		// 설문 목록 화면
			}
			var kvArr = [];
			kvArr.push({'key' : 'srvyId',   	'val' : srvyId});
			kvArr.push({'key' : 'sbjctId', 		'val' : "${sbjctId}"});

			submitForm(urlMap[type], kvArr);
		}

		/**
		 * 분반 선택 변경
		 * @param {obj}  obj - 선택한 분반 체크박스
		 */
		function dvclasChcChange(obj) {
			if(obj.value == "all") {
				$("input[name=sbjctIds]").not(".readonly").prop("checked", obj.checked);

				if(obj.checked) {
					$("div[id^='lrnGrpView']").css("display", "flex");
					$("input[name='byteamSubsrvyUseyns']:checked").each(function(i, e) {
						$("#setSrvyDiv"+e.id.split("_")[1]).show();
					});
				} else {
					var fixDvclas = $("input[name=sbjctIds]").filter(".readonly")[0].id.split("_")[1];
					$("div[id^='lrnGrpView']").not("#lrnGrpView"+fixDvclas).hide();
					$("div[id^='setSrvyDiv']").not("#setSrvyDiv"+fixDvclas).hide();
				}
			} else {
				$("#allDeclas").prop("checked", $("input[name=sbjctIds]").length == $("input[name=sbjctIds]:checked").length);

				if(obj.checked) {
					$("#lrnGrpView" + obj.id.split("_")[1]).css("display", "flex");
					$("#setSrvyDiv"+obj.id.split("_")[1]).show();
				} else {
					$("#lrnGrpView" + obj.id.split("_")[1]).hide();
					$("#setSrvyDiv"+obj.id.split("_")[1]).hide();
				}
			}
		}

		/**
		 * 팀 설문 여부 변경
		 * @param {String}  value - 팀 설문 여부
		 */
		function teamynChange(value) {
			if(value == "Y") {
				$("#teamSrvyDiv").show();
			} else {
				$("#teamSrvyDiv").hide();
			}
		}

		/**
		 * 학습그룹지정 팝업
		 * @param {Integer} i 		- 분반 순서
		 * @param {String}  sbjctId - 과목아이디
		 */
	    function teamGrpChcPopup(i, sbjctId) {
			dialog = UiDialog("dialog1", {
				title: "학습그룹지정",
				width: 600,
				height: 500,
				url: "/team/teamHome/teamCtgrSelectPop.do?sbjctId="+sbjctId+"&searchFrom="+i + ":" + sbjctId,
				autoresize: true
			});
		}

	    /**
		 * 학습그룹 선택
		 * @param {String}  lrnGrpId 	- 학습그룹아이디
		 * @param {String}  lrnGrpnm 	- 학습그룹명
		 * @param {String}  id 			- 분반 순서:과목개설아이디
		 * @returns {list} 팀 목록
		 */
	    function selectTeam(lrnGrpId, lrnGrpnm, id) {
	    	var idList = id.split(':');
	    	$("#lrnGrpId" + idList[0]).val(lrnGrpId + ":" + idList[1]);
	    	$("#lrnGrpnm" + idList[0]).val(lrnGrpnm);
	    	$("#setSrvyDiv" + idList[0]).show();

	    	var url  = "/srvy/srvyLrnGrpSubAsmtListAjax.do";
			var data = {
				lrnGrpId : 	lrnGrpId,
				srvyId   : 	$("#byteamSubsrvyUseyn_" + idList[0]).data("id")
			};

			$.ajax({
		        url 	  : url,
		        async	  : false,
		        type 	  : "POST",
		        dataType : "json",
		        data 	  : JSON.stringify(data),
		        contentType: "application/json; charset=UTF-8",
		    }).done(function(data) {
		   		UiComm.showLoading(false);
		    	if (data.result > 0) {
		    		var returnList = data.returnList || [];
					var html = "";

	        		if(returnList.length > 0) {
						html += "<table class='table-type5'>";
						html += "	<colgroup>";
						html += "		<col class='width-10per' />";
						html += "		<col class='' />";
						html += "		<col class='width-10per' />";
						html += "	</colgroup>";
						html += "	<tbody>";
						html += "		<tr>";
						html += "			<th>팀</th>";
						html += "			<th>부 과제</th>";
						html += "			<th>학습그룹 구성원</th>";
						html += "		</tr>";
	        			returnList.forEach(function(v, i) {
							html += "	<tr class='subSrvyTr'>";
							html += "		<th><label>" + v.teamnm + "</label></th>";
							html += "		<td>";
							html += "			<table class='table-type5'>";
							html += "				<colgroup>";
							html += "					<col class='width-10per' />";
							html += "					<col class='' />";
							html += "				</colgroup>";
							html += "				<tbody>";
							html += "					<tr>";
							html += "						<th><label for='" + v.teamId + "_SrvyTtl_" + i + "' class='req'>주제</label></th>";
							html += "						<td><input type='text' id='" + v.teamId + "_SrvyTtl_" + i + "' name='subSrvyTtl' value='" + (v.srvyTtl == null ? '' : v.srvyTtl) + "' inputmask='byte' maxLen='200' class='width-100per' /></td>";
							html += "					</tr>";
							html += "					<tr>";
							html += "						<th><label for='" + v.teamId + "_contentTextArea_" + i + "' class='req'>내용</label></th>";
							html += "						<td>";
							html += "							<div class='editor-box'>";
							html += "								<textarea name='" + v.teamId + "_contentTextArea_" + i + "' id='" + v.teamId + "_contentTextArea_" + i + "'>" + (v.srvyCts == null ? '' : v.srvyCts) + "</textarea>";
							html += "							</div>";
							html += "						</td>";
							html += "					</tr>";
							html += "				</tbody>";
							html += "			</table>";
							html += "		</td>";
							html += "		<th>" + v.leadernm + " 외 " + (v.teamMbrCnt - 1) + "</th>";
							html += "	</tr>";
	        			});
						html += "	</tbody>";
						html += "</table>";
	        		}

	        		$("#subInfoDiv" + idList[0]).empty().html(html);
	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
	        				// html 에디터 생성
							editors[v.teamId+'_editor'+i] = UiEditor({
																targetId: v.teamId+'_contentTextArea_'+i,
																uploadPath: "/srvy",
																height: "500px"
															});
	        			});
	        		}
		        } else {
		       		UiComm.showMessage(data.message, "error");
		        }
		    }).fail(function() {
			   	UiComm.showLoading(false);
			   	UiComm.showMessage("<spring:message code='exam.error.copy' />", "error");	/* 가져오기 중 에러가 발생하였습니다. */
		    });
	    }

	    /**
		 * 학습그룹 설정여부 변경
		 * @param {obj}  obj - 분반 학습그룹 과제 설정 체크박스
		 */
	    function byteamSubsrvyUseynChange(obj) {
	    	if(obj.checked) {
				$("#subInfoDiv" + obj.id.split("_")[1]).show();
			} else {
				$("#subInfoDiv" + obj.id.split("_")[1]).hide();
			}
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
				        <div class="page-info">
				        	<h2 class="page-title">
                                설문
                            </h2>
				        </div>
				        <spring:message code="exam.button.save" var="save" /><!-- 저장 -->
				        <spring:message code="exam.button.mod"  var="modify" /><!-- 수정 -->
				        <div class="board_top">
					        <div class="right-area">
					        	<a href="javascript:save()" class="btn type2">${empty vo.srvyId ? save : modify }</a>
					            <a href="javascript:bfrSrvyCopyPopup()" class="btn type2">이전설문 가져오기</a>
					            <a href="javascript:srvyViewMv('list', '')" class="btn type2"><spring:message code="exam.button.list" /></a><!-- 목록 -->
					        </div>
				        </div>
				        <!--table-type-->
				        <div class="table-wrap">
							<form name="writeSrvyForm" id="writeSrvyForm" method="POST" autocomplete="off">
						    	<input type="hidden" name="srvyId" 						value="${vo.srvyId }" />
						        <input type="hidden" name="sbjctId" 					value="${sbjctId }" />
						        <input type="hidden" name="srvyGrpId" 					value="${vo.srvyGrpId }" />
						        <input type="hidden" name="mrkRfltrt" 					value="0" />
						        <input type="hidden" name="upSrvyId" 					value="" />
						        <input type="hidden" name="srvyWrtTycd" 				value="LMS_SRVY" />
						        <input type="hidden" name="srvyGbncd" 					value="LCTR_SRVY" />
						        <input type="hidden" name="srvyTycd"					value="SRVY_GNRL_LCTR_EVL" />
						        <input type="hidden" name="srvyTrgtGbncd"				value="SBJCT" />
						        <input type="hidden" name="srvySdttm" 					value="${vo.srvySdttm }" 		id="srvySdttm" />
						        <input type="hidden" name="srvyEdttm" 					value="${vo.srvyEdttm }"  		id="srvyEdttm" />
						        <input type="hidden" name="dvclasRegyn" 				value="${vo.dvclasRegyn }"	   	id="dvclasRegyn" />
						        <input type="hidden" name="subSrvys" 					value=""	   					id="subSrvys" />
						        <table class="table-type5">
						        	<colgroup>
						        		<col class="width-20per" />
						        		<col class="" />
						        	</colgroup>
						        	<tbody>
						        		<tr>
						        			<th><label for="examTtl" class="req">설문명</label></th>
						        			<td>
						        				<input type="text" name="srvyTtl" id="srvyTtl" inputmask="byte" maxLen="200" class="width-100per" required="true" value="${vo.srvyTtl }">
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label for="contentTextArea" class="req">설문내용</label></th>
						        			<td>
												<div class="editor-box">
													<%-- HTML 에디터 --%>
													<uiex:htmlEditor
														id="srvyCts"
														name="srvyCts"
														uploadPath="${vo.uploadPath}"
														value="${vo.srvyCts}"
														height="500px"
														required="true"
													/>
												</div>
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label for="contLabel" class="req">분반 일괄 등록</label></th>
						        			<td>
						        				<div class="checkbox_type">
						        					<span class="custom-input">
														<input type="checkbox" name="allDeclasNo" value="all" id="allDeclas" onchange="dvclasChcChange(this)">
														<label for="allDeclas">전체</label>
													</span>
													<c:forEach var="list" items="${dvclasList }">
												        <c:set var="sbjctChk" value="N" />
												        <c:forEach var="item" items="${sbjctList }">
												        	<c:if test="${item.sbjctId eq list.sbjctId }">
												        		<c:set var="sbjctChk" value="Y" />
												        	</c:if>
												        </c:forEach>
												        <span class="custom-input">
															<input type="checkbox" ${list.sbjctId eq sbjctId || sbjctChk eq 'Y' ? 'class="readonly" checked' : '' } name="sbjctIds" id="declas_${list.dvclasNo }" value="${list.sbjctId }" onchange="dvclasChcChange(this)">
															<label for="declas_${list.dvclasNo }">${list.dvclasNo }반</label>
														</span>
											        </c:forEach>
						        				</div>
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label for="dateSt" class="req">설문기간</label></th>
						        			<td>
						        				<input id="dateSt" type="text" name="dateSt" class="datepicker" timeId="timeSt" toDate="dateEd" value="${fn:substring(vo.srvySdttm,0,8)}" required="true">
												<input id="timeSt" type="text" name="timeSt" class="timepicker" dateId="dateSt" value="${fn:substring(vo.srvySdttm,8,12)}" required="true">
												<span class="txt-sort">~</span>
												<input id="dateEd" type="text" name="dateEd" class="datepicker" timeId="timeEd" fromDate="dateSt" value="${fn:substring(vo.srvyEdttm,0,8)}" required="true">
												<input id="timeEd" type="text" name="timeEd" class="timepicker" dateId="dateEd" value="${fn:substring(vo.srvyEdttm,8,12)}" required="true">
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label class="req">성적반영</label></th>
						        			<td>
						        				<span class="custom-input">
													<input type="radio" name="mrkRfltyn" id="mrkRfltynY" value="Y" ${vo.mrkRfltyn eq 'Y' || empty vo.srvyId ? 'checked' : '' }>
													<label for="mrkRfltynY">예</label>
												</span>
												<span class="custom-input ml5">
													<input type="radio" name="mrkRfltyn" id="mrkRfltynN" value="N" ${vo.mrkRfltyn eq 'N' ? 'checked' : '' }>
													<label for="mrkRfltynN">아니오</label>
												</span>
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label class="req">성적공개</label></th>
						        			<td>
						        				<span class="custom-input">
													<input type="radio" name="mrkOyn" id="mrkOynY" value="Y" ${vo.mrkOyn eq 'Y' || empty vo.srvyId ? 'checked' : '' }>
													<label for="mrkOynY">예</label>
												</span>
												<span class="custom-input ml5">
													<input type="radio" name="mrkOyn" id="mrkOynN" value="N" ${vo.mrkOyn eq 'N' ? 'checked' : '' }>
													<label for="mrkOynN">아니오</label>
												</span>
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label>평가방법</label></th>
						        			<td>
						        				<span class="custom-input">
													<input type="radio" name="evlScrTycd" id="scrEvlTycd" value="SCR" ${vo.evlScrTycd eq 'SCR' || empty vo.srvyId ? 'checked' : '' }>
													<label for="scrEvlTycd">점수형</label>
												</span>
												<span class="custom-input ml5">
													<input type="radio" name="evlScrTycd" id="ptcpEvlTycd" value="PTCP_FULL_SCR" ${vo.evlScrTycd eq 'PTCP_FULL_SCR' ? 'checked' : '' }>
													<label for="ptcpEvlTycd">참여형</label>
												</span>
												<span class="fcBlue">
													( 설문 참여 : 100점, 미참여 : 0점 자동배점 )
												</span>
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label>설문결과 조회가능</label></th>
						        			<td>
						        				<span class="custom-input">
													<input type="radio" name="rsltOpenTycd" id="rsltOpen" value="WHOL_OPEN" ${vo.rsltOpenTycd eq 'WHOL_OPEN' || empty vo.srvyId ? 'checked' : '' }>
													<label for="rsltOpen">예</label>
												</span>
												<span class="custom-input ml5">
													<input type="radio" name="rsltOpenTycd" id="rsltClose" value="WHOL_CLOSE" ${vo.rsltOpenTycd eq 'WHOL_CLOSE' ? 'checked' : '' }>
													<label for="rsltClose">아니오</label>
												</span>
						        			</td>
						        		</tr>
										<tr>
						        			<th><label>팀설문</label></th>
						        			<td>
												<span class="custom-input ml5">
													<input type="radio" name="srvyTeamyn" id="srvyTeamynN" value="N" onchange="teamynChange(this.value)" ${empty vo.srvyId || vo.srvyGbn ne 'SRVY_TEAM' ? 'checked' : ''}>
													<label for="srvyTeamynN">아니오</label>
												</span>
						        				<span class="custom-input">
													<input type="radio" name="srvyTeamyn" id="srvyTeamynY" value="Y" onchange="teamynChange(this.value)" ${vo.srvyGbn eq 'SRVY_TEAM' ? 'checked' : ''}>
													<label for="srvyTeamynY">예</label>
												</span>
												<div id="teamSrvyDiv" ${empty vo.srvyId || vo.srvyGbn ne 'SRVY_TEAM' ? 'style="display:none"' : '' }>
										        	<c:forEach var="list" items="${dvclasList }" varStatus="i">
														<div class="form-row" id='lrnGrpView${list.dvclasNo}'>
															<div class="input_btn width-100per">
																<label>${list.dvclasNo }반</label>
																<input type='hidden' id='lrnGrpId${list.dvclasNo}' name='lrnGrpIds' value="${empty vo.srvyId ? '' : list.lrnGrpId}:${list.sbjctId}">
																<input class="form-control width-60per" type="text" name="lrnGrpnm" id="lrnGrpnm${list.dvclasNo}" placeholder="팀 분류를 선택해 주세요." value="${empty vo.srvyId ? '' : list.lrnGrpnm}" readonly="" autocomplete="off">
																<a class="btn type1 small" onclick="teamGrpChcPopup('${list.dvclasNo}','${list.sbjctId }')">학습그룹지정</a>
															</div>
														</div>
											        	<c:if test="${i.count eq 1 }">
											        		<div class="form-inline">
																<small class="note2">! 구성된 팀이 없는 경우 메뉴 “과목설정 > 학습그룹지정”에서 팀을 생성해 주세요</small>
															</div>
											        	</c:if>
											        	<div class="ui segment" id="setSrvyDiv${list.dvclasNo }" style="display:none;">
											        		<span class="custom-input">
															    <input type="checkbox" name="byteamSubsrvyUseyns" id="byteamSubsrvyUseyn_${list.dvclasNo }" data-Id="${not empty vo.srvyId && list.byteamSubsrvyUseyn eq 'Y' ? list.srvyId : '' }" value="Y:${list.sbjctId }" onchange="byteamSubsrvyUseynChange(this)" ${not empty vo.srvyId && list.byteamSubsrvyUseyn eq 'Y' ? 'checked' : '' }>
															    <label for="byteamSubsrvyUseyn_${list.dvclasNo }">학습그룹별 부 과제 설정</label>
															</span>
												        	<div id="subInfoDiv${list.dvclasNo }" ${not empty vo.srvyId && list.byteamSubsrvyUseyn eq 'Y' ? '' : 'style="display: none;"' }></div>
											        	</div>
										        	</c:forEach>
										        </div>
						        			</td>
						        		</tr>
						        	</tbody>
						        </table>
							</form>
				        </div>
				        <!--table-type-->
				    </div>
				</div>
        	</div>
            <!-- //content -->
        </main>
        <!-- //classroom-->
    </div>
</body>
</html>