<%@page import="knou.framework.util.SessionUtil"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<script type="text/javascript">
	var dialog;
	var EPARAM = '<c:out value="${encParams}" />';

	// dialog 닫기
	window.closeDialog = function() {
		dialog.close();
	};

	// 팝업 오류메세지 용
	function msgPop(msg) {
		closeDialog();
		UiComm.showMessage(msg, "info");
	}

	// 지정 클래스의 label로 감싸기
	function wrapLabel(text, cls) {
		return "<label class='" + cls + "'>" + text + "</label>";
	}

	// 설문화면이동
	function srvyViewMv(srvyId, type, upSrvyId) {
		let urlMap = {
			"PROFQSTN" 				: "/srvy/profSrvyQstnMngView.do",				// 교수 설문 문항 관리 화면
			"PROFEVL" 				: "/srvy/profSrvyEvlMngView.do",				// 교수 설문 평가 관리 화면
			"PROFREGIST" 			: "/srvy/profSrvyRegistView.do", 				// 교수 설문 등록 화면
			"PROFMODIFY" 			: "/srvy/profSrvyModifyView.do", 				// 교수 설문 수정 화면
			"PROFLIST"				: "/srvy/profSrvyListView.do",					// 교수 설문 목록 화면
			"STDVIEW"				: "/srvy/stdntSrvyInfoView.do",					// 학생 설문 정보 화면
			"STDLIST"				: "/srvy/stdntSrvyListView.do",					// 학생 설문 목록 화면
			"STDEVLVIEW"			: "/srvy/stdntLectSrvyLctrEvlInfoView.do",		// 학생 강의평가 정보 화면
			"STDEVLLIST"			: "/srvy/stdntLectSrvyLctrEvlListView.do",		// 학생 강의평가 목록 화면
			"ADMEVLREGIST"			: "/srvy/admSrvyLctrEvlRegistView.do",			// 관리자 설문 강의평가 등록 화면
			"ADMEVLMODIFY"			: "/srvy/admSrvyLctrEvlModifyView.do",			// 관리자 설문 강의평가 수정 화면
			"ADMEVLLIST"			: "/srvy/admSrvyLctrEvlListView.do",			// 관리자 설문 강의평가 목록 화면
			"ADMEVLVIEW"			: "/srvy/admSrvyLctrEvlInfoView.do",			// 관리자 설문 강의평가 정보 화면
			"ADMEVLQSTN"			: "/srvy/admSrvyLctrEvlQstnMngView.do",			// 관리자 설문 강의평가 문항관리 화면
			"ADMEVLRSLTLIST"		: "/srvy/admSrvyLtclEvlRsltListView.do",		// 관리자 설문 강의평가 결과목록 화면
			"ADMEVLRSLT"			: "/srvy/admSrvyLctrEvlRsltMngView.do",			// 관리자 설문 강의평가 결과관리 화면
			"ADMREGIST"				: "/srvy/admSrvyRegistView.do",					// 관리자 전체설문 등록 화면
			"ADMMODIFY"				: "/srvy/admSrvyModifyView.do",					// 관리자 전체설문 수정 화면
			"ADMLIST"				: "/srvy/admSrvyListView.do",					// 관리자 전체설문 목록 화면
			"ADMVIEW"				: "/srvy/admSrvyInfoView.do",					// 관리자 전체설문 정보 화면
			"ADMQSTN"				: "/srvy/admSrvyQstnMngView.do",				// 관리자 전체설문 문항관리 화면
			"ADMRSLTLIST"			: "/srvy/admSrvyRsltListView.do",				// 관리자 전체설문 결과목록 화면
			"ADMRSLT"				: "/srvy/admSrvyRsltMngView.do",				// 관리자 전체설문 결과관리 화면
			"ADMSBJCTEVLLIST"		: "/srvy/admSbjctSrvyLctrEvlListView.do",		// 관리자 과목 설문 강의평가 목록 화면
			"ADMSBJCTEVLVIEW"		: "/srvy/admSbjctSrvyLctrEvlInfoView.do",		// 관리자 과목 설문 강의평가 정보 화면
			"ADMSBJCTEVLRSLTLIST"	: "/srvy/admSbjctSrvyLtclEvlRsltListView.do",	// 관리자 과목 설문 강의평가 결과목록 화면
			"ADMSBJCTEVLRSLT"		: "/srvy/admSbjctSrvyLtclEvlRsltMngView.do"		// 관리자 과목 설문 강의평가 결과관리 화면
		};

		let extData = {
			srvyId 		: srvyId,
			upSrvyId	: upSrvyId
		};

		document.location.href = urlMap[type] + "?encParams=" + EPARAM + "&addParams=" + UiComm.makeEncParams(extData);
	}

	/**
	 * 팀그룹부설문목록조회
	 * @param teamGrpId 	- 팀그룹아이디
	 * @param srvyId 		- 설문아이디
	 */
	function teamGrpSubSrvyListSelect(teamGrpId, srvyId) {
		const url  = "/srvy/srvyTeamGrpSubAsmtListAjax.do";
		const data = {
			teamGrpId  	: teamGrpId,
			srvyId 		: srvyId
		};

		$.ajax({
	        url 	  	: url,
	        async	  	: false,
	        type 	  	: "POST",
	        dataType  	: "json",
	        data 	  	: JSON.stringify(data),
	        contentType	: "application/json; charset=UTF-8",
	        beforeSend	: () => UiComm.showLoading(true),
            success		: function (data) {
                if (data.result > 0) {
                	let returnList = data.returnList || [];
                	let html = "";

    			    if(returnList.length > 0) {
    			    	returnList.forEach(function(v, i) {
    			    		html += "<tr>";
    						html += "	<th rowspan='3' class='group-header'><label>" + v.teamnm + "</label></th>";
    						html += "	<th><label><spring:message code='srvy.label.team.group.member' /></label></th>";/* 팀그룹 구성원 */
    						html += "	<td>" + v.leadernm + " <spring:message code='msg.label.write.others' /> " + (v.teamMbrCnt - 1) + "<spring:message code='common.label.nm' /></td>";/* 외 *//* 명 */
    						html += "</tr>";
    						html += "<tr>";
    						html += "	<th><label><spring:message code='srvy.label.sub.title' /></label></th>";/* 부주제 */
    						html += "	<td>" + UiComm.escapeHtml(v.srvyTtl) + "</td>";
    						html += "</tr>";
    						html += "<tr>";
    						html += "	<th><label><spring:message code='common.label.contents' /></label></th>";/* 내용 */
    						html += "	<td><pre>" + v.srvyCts + "</pre></td>";
    						html += "</tr>";
    			    	});
    			    }

    			    $("#teamSubSrvyTbody").append(html);
                }
            },
            error		: () => UiComm.showMessage("<spring:message code='srvy.error.copy' />", "error"),	/* 가져오기 중 에러가 발생하였습니다. */
            complete	: () => UiComm.showLoading(false)
	    });
	}

	var srvyCommon = {
		// 결과차트출력
		statusChartSet: function(type, cntnDvcTycdList, srvyPtcpDvcStatusList, srvyPtcpCnt) {
			let cntMap 		= {};	// 구분용
			let ptctCnt 	= "";	// 설문참여자수
			let notPtcpCnt 	= "";	// 설문미참여자수
			if(cntnDvcTycdList == undefined) {
				<c:forEach var="list" items="${cntnDvcTycdList}">
					cntMap["dvc_${list.cd}"] = "${list.cdnm}";
				</c:forEach>
			} else {
				cntnDvcTycdList.forEach(function(v, i) {
					cntMap["dvc_"+v.cd] = v.cdnm;
				});
			}
			if(srvyPtcpDvcStatusList == undefined) {
				<c:forEach var="list" items="${srvyPtcpDvcStatusList }">
					cntMap["${list.cd}"] = "${list.srvyPtcpCnt}";
				</c:forEach>
			} else {
				srvyPtcpDvcStatusList.forEach(function(v, i) {
					cntMap[v.cd] = v.srvyPtcpCnt;
				});
			}
			if(srvyPtcpCnt == undefined) {
				ptctCnt 	= "${srvyPtcpCnt.ptcpCnt}";
				notPtcpCnt 	= "${srvyPtcpCnt.totalCnt - srvyPtcpCnt.ptcpCnt}";
			} else {
				ptctCnt 	= srvyPtcpCnt.ptcpCnt;
				notPtcpCnt 	= srvyPtcpCnt.totalCnt - srvyPtcpCnt.ptcpCnt;
			}

			var typeMap = {
				"status" : {
					"ctx"	 : "statPieChart",
					"text"   : "<spring:message code='srvy.label.ptcp.status' /> (%)",/* 참여현황 */
					"labels" : ["<spring:message code='common.respondent' />", "<spring:message code='common.not_respondent' />"],/* 응답자 *//* 미응답자 */
					"datas"  : [ptctCnt, notPtcpCnt]
				},
				"device" : {
					"ctx"	 : "devicePieChart",
					"text"   : "<spring:message code='common.connection.environment' /> (%)",/* 접속환경 */
					"labels" : [cntMap["dvc_PC"], cntMap["dvc_MBL"], cntMap["dvc_TBLT"], cntMap["dvc_STV"], cntMap["dvc_SWATCH"], cntMap["dvc_ETC"]],
					"datas"  : [cntMap["PC"], cntMap["MBL"], cntMap["TBLT"], cntMap["STV"], cntMap["SWATCH"], cntMap["ETC"]]
				}
			};
			var ctx = document.getElementById(typeMap[type]['ctx']);
			var colorArray = ['rgba(54, 162, 235, .8)', 'rgba(255, 99, 132, .8)', 'rgba(165, 103, 63, 1)', 'rgba(75, 192, 192, .8)', 'rgba(255, 205, 86, .8)', 'rgba(153, 102, 255, .8)'];

	        var myChart = new Chart(ctx, {
	            type: 'pie',
	            data: {
		            labels: typeMap[type]['labels'],
		            datasets: [{
		                data: typeMap[type]['datas'],
		                backgroundColor: colorArray,
		                borderWidth:1
		            }]
	            },
	            options: {
	            	responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { position: 'bottom' },
                        title: { display: true, text: typeMap[type]['text'], font: { size: 16 }, color: '#333' },
                        datalabels: {
                            color: '#fff',
                            font: { weight: 'bold', size: 14 },
                            formatter: (value, context) => {
                                const total = context.chart.data.datasets[0].data.reduce((a, b) => a + b, 0);
                                return (value / total * 100).toFixed(1) + '%';
                            }
                        }
                    }
	            },
	            plugins: [ChartDataLabels]
	        });
		}
	}

	var qstnOption = {
		/**
		 * 문제 말머리 HTML 추가
		 * @param {String}  parentId 	- 문제 추가용 최상위 div 아이디
		 * @param {String}  formId 		- 문제 추가용 form 아이디
		 * @param {String}  editorId 	- 문제 내용 에디터 아이디
		 */
		createQstnHeaderHTML: function(parentId, formId, editorId) {
			var html  = "<form id=\"" + formId + "\">";
				html += "	<input type='hidden' name='srvypprId' />";
				html += "	<input type='hidden' name='srvyQstnId' />";
				html += "	<input type='hidden' name='qstnSeqno' />";
				html += "	<input type='hidden' name='qstnGbncd' />";
	    		html += "	<div class='table-wrap qstnTypeDiv'>";
	    		html += "		<table class='table-type5'>";
	    		html += "			<colgroup>";
	    		html += "				<col class='width-15per' />";
	    		html += "				<col class='' />";
	    		html += "			</colgroup>";
	    		html += "			<tbody>";
	    		html += "				<tr class='titleTr notEmptyTr'>";
				html += "					<th><spring:message code='srvy.label.qstn' /></th>";	// 문항
				html += "					<td>";
				html += "						<div class='form-row gap-2'>";
				html += "							<input type='text' class='form-control width-80per' inputmask='byte' maxLen='200' name='qstnTtl' required='true'>";
				html += "							<select class='form-select width-20per' name='qstnRspnsTycd' onchange='qstnOption.qstnRspnsTycdChgChange(\"" + formId + "\")' required='true'>";
													<c:forEach var="code" items="${qstnRspnsTycdList }">
				html += "								<option value='${code.cd }'>${code.cdnm }</option>";
													</c:forEach>
				html += "							</select>";
				html += "						</div>";
				html += "						<small class='note2'><spring:message code='srvy.label.another.title' /></small>";/* ! 기본 설정된 제목 대신 다른 제목을 넣으시면 좀 더 쉽게 문제를 구분하실 수 있습니다. */
				html += "					</td>";
				html += "				</tr>";
				html += "				<tr class='notEmptyTr'>";
				html += "					<th><spring:message code='common.label.contents' /></th>";	// 내용
				html += "					<td>";
				html += "						<label class='width-100per'>";
				html += "							<textarea rows='4'";
				html += "				  					  class='form-control resize-none'";
				html += "				  					  name='qstnCts'";
				html += "				  					  id='" + editorId + "'";
				html += "				  					  required='true'>";
				html += "							</textarea>";
				html += "						</label>";
				html += "					</td>";
				html += "				</tr>";
	    		html += "			</tbody>";
	    		html += "		</table>";
	    		html += "	</div>"
	    		html += "</form>";
	    	$("#"+parentId+" .content").append(html);
	    	$("#"+formId+" select[name=qstnRspnsTycd]").chosen({disable_search: true});
		},
		/**
		 * 문제 버튼 HTML 추가
		 * @param {String}  parentId 	- 문제 추가용 최상위 div 아이디
		 * @param {String}  formId 		- 문제 추가용 form 아이디
		 */
		createQstnBtnHTML: function(parentId, formId) {
			var html  = "<div class='btns'>";
	    		html += "	<a href='javascript:qstnRegist(\"" + parentId + "\", \"" + formId + "\")' class='btn basic type1 addBtn'><spring:message code='srvy.button.save' /></a>";/* 저장 */
	    		html += "	<a href='javascript:qstnOption.qstnAddFrmRemove(\"" + parentId + "\")' class='btn basic type2'><spring:message code='srvy.button.cancel' /></a>";/* 취소 */
	    		html += "</div>";
	    	$("#"+parentId+" .content").append(html);
		},
		/**
		 * 보기항목 수 HTML 추가
		 * @param {String}  formId 		- 문제 추가용 form 아이디
		 * @param {String}  type 		- 문항답변유형코드
		 */
		createVwitmCntHTML: function(formId, type) {
			var html  = "<tr>";
	    		html += "	<th><spring:message code='srvy.label.vwitm.cnt' /></th>";/* 보기 개수 */
	    		html += "	<td>";
	    		html += "		<select class='form-select' name='vwitmCnt' onchange='qstnOption.createVwitmCntChgHTML(\"" + formId + "\", \"" + type + "\")' required='true'>";
	    						for(var idx = 2; idx <= 10; idx++) {
	    							var selected = (type == "ONE_CHC" || type == "MLT_CHC") && idx == 2 ? "selected" : "";
	    		html += "			<option value=\"" + idx + "\" " + selected + ">" + idx + "개</option>";
	    						}
	    		html += "		</select>";
	    		html += "	</td>";
	    		html += "</tr>";
	    	$("#"+formId+" .qstnTypeDiv > table > tbody").append(html);
	    	$("#"+formId+" .qstnTypeDiv select[name=vwitmCnt]").chosen({disable_search: true});
		},
		/**
		 * 단일, 다중선택형 문항 HTML 추가
		 * @param {String}  formId 		- 문제 추가용 form 아이디
		 */
		createChgQstnHTML: function(formId) {
			var html  = "<tr>";
	    		html += "	<th><spring:message code='srvy.label.vwitm.input' /></th>";/* 보기 입력 */
	    		html += "	<td class='qstnItemTd'></td>";
	    		html += "</tr>";
	    	$("#"+formId+" .qstnTypeDiv > table > tbody").append(html);
		},
		/**
		 * OX선택형 문항 HTML 추가
		 * @param {String}  formId 		- 문제 추가용 form 아이디
		 */
		createOxQstnHTML: function(formId) {
			var html  = "<tr>";
	    		html += "	<th><spring:message code='srvy.label.rspns.input' /></th>";/* 정답 입력 */
	    		html += "	<td>";
	    		html += "		<div class='ox_quiz justify-content-left'>";
				for(var idx = 1; idx <= 2; idx++) {
					var oxClass = idx == 1 ? "true" : "false";
					var iconClass = idx == 1 ? "xi-radiobox-blank" : "xi-close";
					html += "		<div class='ox_item'>";
					html += "			<input type='radio' class='ox_input' name='vwitmCts' id='"+formId+"_"+oxClass+"' value='" + (idx == 1 ? "O" : "X") + "' />";
					html += "			<label for='"+formId+"_"+oxClass+"' class='btn basic'>";
					html += "				<i class='" + iconClass + " icon'></i>";
					html += "			</label>";
					html += "			<label class='etcSelectDiv'>";
		 	   		html += "				<select class='form-select w150' name='mvmnSrvypprId'>";
		 	   		html += "					<option value='NEXT'><spring:message code='srvy.label.mvmn.next.page' /></option>";/* 다음 페이지로 이동 */
		 	   		html += "				</select>";
		 	   		html += "			</label>";
					html += "		</div>";
				}
	    		html += "		</div>";
	    		html += "	</td>";
	    		html += "</tr>";
	    	$("#"+formId+" .qstnTypeDiv > table > tbody").append(html);
	    	$("#"+formId+" .qstnTypeDiv select[name=mvmnSrvypprId]").chosen({disable_search: true});
	    	$("#"+formId+" .qstnTypeDiv .etcSelectDiv").hide();
	    	qstnOption.initSrvypprMvmn(formId, "N", "N");	// 다음설문지아이디 초기화
		},
		/**
		 * 레벨형 문항 HTML 추가
		 * @param {String}  formId 		- 문제 추가용 form 아이디
		 */
		createLevelQstnHTML: function(formId) {
			var html  = "<tr>";
				html += "	<th><spring:message code='srvy.label.evl.qstn' /></th>";/* 평가 문항 */
				html += "	<td>";
				html += "		<div class='rubrics_wrap'>";
				html += "			<div class='rub_write'>";
				html += "				<div class='eval_item'>";
				html += "					<div class='item'>";
				html += "						<label class='label_num'>1</label>";
				html += "						<input type='text' name='vwitmCts' class='form-control wide' required='true' />";
				html += "					</div>";
				html += "				</div>";
				html += "			</div>";
				html += "		</div>";
				html += "		<div class='board_top mt10'>";
				html += "			<div class='right-area'>";
				html += "				<button type='button' class='btn type1' onclick='qstnOption.createLevelQstnAddHTML(\""+formId+"\")'><spring:message code='srvy.button.add.qstn' /></button>";/* 문항 추가 */
				html += "			</div>";
				html += "		</div>";
				html += "	</td>";
				html += "</tr>";
				html += "<tr>";
				html += "	<th><spring:message code='srvy.label.evl.grade' /></th>";/* 평가 등급 */
				html += "	<td>";
				html += "		<div class='rubrics_wrap'>";
				html += "			<div class='sub-box rub_grade pd0 bd0 mt0'>";
				html += "				<div class='board_top'>";
				html += "					<div class='form-inline'>";
				html += "						<span class='custom-input'>";
				html += "							<input type='radio' name='vwitmLvl' id='fiveLvl' value='5' onchange='qstnOption.createLevelChgHTML(\""+formId+"\")' checked='' />";
				html += "							<label for='fiveLvl'>5<spring:message code='srvy.label.scale.score' /></label>";/* 점 척도 */
				html += "						</span>";
				html += "						<span class='custom-input'>";
				html += "							<input type='radio' name='vwitmLvl' id='threeLvl' value='3' onchange='qstnOption.createLevelChgHTML(\""+formId+"\")' />";
				html += "							<label for='threeLvl'>3<spring:message code='srvy.label.scale.score' /></label>";/* 점 척도 */
				html += "						</span>";
				html += "						<span class='custom-input'>";
				html += "							<input type='radio' name='vwitmLvl' id='freeLvl' value='10' onchange='qstnOption.createLevelChgHTML(\""+formId+"\")' />";
				html += "							<label for='freeLvl'><spring:message code='srvy.label.scale.free' /></label>";/* 자유척도 */
				html += "						</span>";
				html += "					</div>";
				html += "				</div>";
				html += "				<div class='grade_item'></div>";
				html += "			</div>";
				html += "		</div>";
				html += "		<div class='board_top mt10 gradeAddDiv'>";
				html += "			<div class='right-area'>";
				html += "				<button type='button' class='btn type1' onclick='qstnOption.createLevelGradeAddHTML(\""+formId+"\")'><spring:message code='srvy.button.add.grade' /></button>";/* 등급 추가 */
				html += "			</div>";
				html += "		</div>";
				html += "	</td>";
				html += "</tr>";
			$("#"+formId+" .qstnTypeDiv > table > tbody").append(html);
		},
		/**
		 * 평가 등급 변경 HTML 추가
		 * @param {String}  formId 		- 문제 추가용 form 아이디
		 */
		createLevelChgHTML: function(formId, itemList) {
			var cnt  = $("#"+formId+" input[name=vwitmLvl]:checked").val();
	    	var levelList = <spring:message code='srvy.scale.5' />;/* {"5":"매우 그렇다","4":"그렇다","3":"보통","2":"아니다","1":"매우 아니다"} */
	    	if(cnt == 3) {
	    		levelList = <spring:message code='srvy.scale.3' />;/* {"3":"그렇다","2":"보통","1":"아니다"} */
	    	}
	    	if(cnt == 10) {
				$("#"+formId+" .gradeAddDiv").show();
				$("#"+formId+" .qstnTypeDiv .rubrics_wrap .grade_item").empty();
				qstnOption.createLevelGradeAddHTML(formId, itemList);
				return;
	    	} else {
				$("#"+formId+" .gradeAddDiv").hide();
	    	}
	    	if(itemList != null) {
	    		levelList = itemList;
	    	}

	    	var html = "";
	    	Object.entries(levelList)
	    		.sort(([a], [b]) => b - a)
	    		.forEach(([key, value]) => {
		    		html += "<div class='item'>";
		    		html += "	<div class='input_btn'>";
		    		html += "		<input type='text' class='form-control sm' inputmask='numeric' name='lvlScr' value='"+key+"' required='true' />";
		    		html += "		<label><spring:message code='srvy.label.score.point' /></label>";/* 점 */
		    		html += "	</div>";
		    		html += "	<input type='text' class='form-control wide' name='lvlCts' value='"+value+"' required='true' />";
		    		html += "</div>";
	    	});
	    	$("#"+formId+" .grade_item").empty().append(html);
		},
	    /**
		 * 레벨형 문항 추가 HTML 추가
		 * @param {String}  formId 	- 문제 추가용 form 아이디
		 */
		 createLevelQstnAddHTML: function(formId) {
			var cnt = $(".rubrics_wrap .eval_item .item").length;

			var html  = "<div class='item'>";
				html += "	<label class='label_num'>" + (cnt + 1) + "</label>";
				html += "	<input type='text' name='vwitmCts' class='form-control wide' required='true' />";
				html += "	<button type='button' class='btn basic icon' onclick='qstnOption.levelQstnDelHTML(\""+formId+"\", this)'><i class='xi-close'></i></button>";
				html += "</div>";
			$("#"+formId+" .qstnTypeDiv .rubrics_wrap .eval_item .item").last().after(html);
		},
		/**
		 * 레벨형 문항 HTML 삭제
		 * @param formId 	- 문제 추가용 form 아이디
		 * @param btn 		- 삭제할 객체 버튼
		 */
		levelQstnDelHTML: function(formId, btn) {
			var $item = $(btn).closest('.item');
		    var cnt = $item.index();
		    $item.remove();
		    $("#"+formId+" .qstnTypeDiv .rubrics_wrap .eval_item .item").slice(cnt).each(function(index, el) {
		        $(el).find('.label_num').text(index + cnt + 1);
		    });
	    },
	    /**
		 * 레벨형 등급 추가 HTML 추가
		 * @param {String}  formId 		- 문제 추가용 form 아이디
		 * @param {String}  itemList 	- 등급목록
		 */
		createLevelGradeAddHTML: function(formId, itemList) {
			var cnt = $(".rubrics_wrap .grade_item .item").length;

			if(cnt == 10) {
				UiComm.showMessage("<spring:message code='srvy.alert.grade.10' />", "info");/* 등급은 10개까지 가능합니다. */
				return;
			}

			var html = "";
			if(itemList != null) {
				Object.entries(itemList)
	    		.sort(([a], [b]) => b - a)
	    		.forEach(([key, value]) => {
		    		html += "<div class='item'>";
		    		html += "	<div class='input_btn'>";
		    		html += "		<input type='text' class='form-control sm' inputmask='numeric' name='lvlScr' value='"+key+"' required='true' />";
		    		html += "		<label><spring:message code='srvy.label.score.point' /></label>";/* 점 */
		    		html += "	</div>";
		    		html += "	<input type='text' class='form-control wide' name='lvlCts' value='"+value+"' required='true' />";
		    		html += "</div>";
	    		});
			} else {
				html  = "<div class='item'>";
	    		html += "	<div class='input_btn'>";
	    		html += "		<input type='text' class='form-control sm' inputmask='numeric' name='lvlScr' required='true' />";
	    		html += "		<label><spring:message code='srvy.label.score.point' /></label>";/* 점 */
	    		html += "	</div>";
	    		html += "	<input type='text' class='form-control wide' name='lvlCts' required='true' />";
	    		html += "</div>";
			}

			$("#"+formId+" .qstnTypeDiv .rubrics_wrap .grade_item").append(html);
		},
	    /**
		 * 필수 선택 버튼 HTML 추가
		 * @param {String}  formId 	- 문제 추가용 form 아이디
		 */
	    createEsntlBtnHTML: function(formId) {
	    	var html  = "<tr>";
	    		html += "	<th><spring:message code='srvy.label.required.select' /></th>";/* 필수 선택 */
	    		html += "	<td class='t_left'>";
	    		html += "		<input type='checkbox' value='Y' name='esntlRspnsyn' id='"+formId+"esntlRspnsyn' class='switch yesno' />";
	    		html += "	</td>";
	    		html += "</tr>";
	    	$("#"+formId+" .qstnTypeDiv > table > tbody").append(html);
	    	UiSwitcher();
	    },
	    /**
		 * 분기 선택 버튼 HTML 추가
		 * @param {String}  formId 	- 문제 추가용 form 아이디
		 */
	    createMvmnBtnHTML: function(formId) {
	    	var html  = "<tr>";
	    		html += "	<th><spring:message code='srvy.label.ouarter.select' /></th>";/* 분기 선택 */
	    		html += "	<td class='t_left'>";
	    		html += "		<input type='checkbox' value='Y' name='srvyMvmnUseyn' class='switch yesno' id='"+formId+"srvyMvmnUseyn' onchange='qstnOption.mvmnSelectView(this, \"" + formId + "\")' />";
	    		html += "		<span class='fcRed'><spring:message code='srvy.label.ouarter.info' /></span>";/* ! 한 페이지에 하나의 문항만 분기 가능합니다. */
	    		html += "	</td>";
	    		html += "</tr>";
	    	$("#"+formId+" .qstnTypeDiv > table > tbody").append(html);
	    	UiSwitcher();
	    },
	    /**
		 * 기타 보기 버튼 HTML 추가
		 * @param {String}  formId 	- 문제 추가용 form 아이디
		 */
	    createEtcBtnHTML: function(formId) {
	    	var html  = "<tr>";
	    		html += "	<th><spring:message code='srvy.label.vwitm.etc' /></th>";/* 기타 보기 */
	    		html += "	<td class='t_left'>";
	    		html += "		<input type='checkbox' value='Y' name='etcInptUseyn' class='switch yesno' id='"+formId+"etcInptUseyn' onchange='qstnOption.etcVwitmChgHtml(this, \"" + formId + "\")' />";
	    		html += "	</td>";
	    		html += "</tr>";
	    	$("#"+formId+" .qstnTypeDiv > table > tbody").append(html);
	    	UiSwitcher();
	    },
	    /**
		* 문항 추가 폼 제거
		* @param {String}  id - 제거할 문항 폼 아이디
		*/
	 	qstnAddFrmRemove: function(id) {
			$("#"+id).remove();
	 	},
	 	/**
		* 문항 유효성 검사
		* @param {String}  formId 	- 문제 추가용 form 아이디
		*/
		isValidQstn: function(formId) {
			var qstnRspnsTycd = $("#"+formId+" select[name=qstnRspnsTycd]").val();	// 문항답변유형코드
			$("#"+formId).find("input[name=qstns]").remove();
			$("#"+formId).find("input[name=lvls]").remove();

			const qstns = [];	// 문항 등록용
			const lvls  = [];	// 레벨 등록용

			// 단일, 다중선택형
			if(qstnRspnsTycd == "ONE_CHC" || qstnRspnsTycd == "MLT_CHC") {
				var vwitmCnt = $("#"+formId+" select[name=vwitmCnt]").val();	// 보기항목수
				for(var i = 1; i <= vwitmCnt; i++) {
					qstns.push({
						vwitmSeqno: i,
						vwitmCts: $("#"+formId+"Vwitm_"+i).val(),
						mvmnSrvypprId: $("#"+formId+" input[name=srvyMvmnUseyn]").prop("checked") ? $("#"+formId+"Mvmn_"+i).val() : ""
					});
				}

				// 기타 보기 선택시
				if($("#"+formId+" input[name=etcInptUseyn]").prop("checked")) {
					qstns.push({
						vwitmSeqno: i,
						vwitmCts: "ETC",
						mvmnSrvypprId: $("#"+formId+" input[name=srvyMvmnUseyn]").prop("checked") ? $("#"+formId+" select[name=mvmnSrvypprId]").last().val() : ""
					});
				}

			// OX선택형
			} else if(qstnRspnsTycd == "OX_CHC") {
			    for(var i = 1; i <= 2; i++) {
			    	qstns.push({
			    		vwitmSeqno: i,
			    		vwitmCts: $("#"+formId).find("input[name=vwitmCts]").eq(i-1).val(),
			    		mvmnSrvypprId: $("#"+formId+" input[name=srvyMvmnUseyn]").prop("checked") ? $("#"+formId+" select[name=mvmnSrvypprId]:eq("+(i-1)+")").val() : ""
			    	});
			    }

			// 레벨형
			} else if(qstnRspnsTycd == "LEVEL") {
				var vwitmCnt = $("#"+formId+" input[name=vwitmCts]").size();	// 보기항목수
				for(var i = 1; i <= vwitmCnt; i++) {
					qstns.push({
						vwitmSeqno: i,
						vwitmCts: $("#"+formId+" input[name=vwitmCts]").eq(i-1).val()
					});
				}

				var vwitmLvl = $("#"+formId+" .grade_item .item").length;	// 평가등급
				for(var i = 1; i <= vwitmLvl; i++) {
					lvls.push({
						lvlSeqno: i,
						lvlScr: $("#"+formId+" input[name=lvlScr]").eq(i-1).val(),
						lvlCts: $("#"+formId+" input[name=lvlCts]").eq(i-1).val()
					});
				}

				$("#"+formId).append("<input type='hidden' name='lvls' />");
				$("#"+formId+" input[name=lvls]").val(JSON.stringify(lvls));
			}

			$("#"+formId).append("<input type='hidden' name='qstns' />");
			$("#"+formId+" input[name=qstns]").val(JSON.stringify(qstns));

			return true;
		},
		/**
		 * 문항답변유형코드 변경
		 * @param {String} formId 	- 문제 추가용 form 아이디
		 */
	    qstnRspnsTycdChgChange: function(formId) {
	    	$("#"+formId+" .qstnTypeDiv > table > tbody > tr").not(".notEmptyTr").empty();	// 문항보기항목 비우기

	        var type = $("#" + formId + " select[name=qstnRspnsTycd]").val();				// 문항답변유형코드
	        // 단일선택형, 다중선택형
	        if(type == "ONE_CHC" || type == "MLT_CHC") {
	        	qstnOption.createVwitmCntHTML(formId, type);								// 보기항목 수 HTML 추가
	        	qstnOption.createChgQstnHTML(formId);										// 단일, 다중선택형 문항 HTML 추가
	        	qstnOption.createVwitmCntChgHTML(formId, type);								// 보기항목 수 변경 HTML 추가
	        	qstnOption.createEtcBtnHTML(formId);										// 기타 보기 버튼 HTML 추가
	        	qstnOption.createMvmnBtnHTML(formId);										// 분기 선택 버튼 HTML 추가

	        // OX선택형
	        } else if(type == "OX_CHC") {
	        	qstnOption.createOxQstnHTML(formId);										// OX선택형 문항 HTML 추가
	        	qstnOption.createMvmnBtnHTML(formId);										// 분기 선택 버튼 HTML 추가

	        // 레벨형
	        } else if(type == "LEVEL") {
				qstnOption.createLevelQstnHTML(formId);										// 레벨형 문항 HTML 추가
				qstnOption.createLevelChgHTML(formId);										// 평가 등급 변경 HTML 추가
	        }

	        qstnOption.createEsntlBtnHTML(formId);											// 필수 선택 버튼 HTML 추가
	    },
	    /**
		 * 보기항목 수 변경 HTML 추가
		 * @param {String}  formId 		- 문제 추가용 form 아이디
		 * @param {String}  type 		- 문항답변유형코드 ( ONE_CHC : 단일선택형, MLT_CHC : 다중선택형 )
		 */
	    createVwitmCntChgHTML: function(formId, type) {
		    var vwitmCnt    = $("#"+formId+" .qstnTypeDiv select[name=vwitmCnt]").val();		// 보기 항목 개수 selectBox
		    var vwitmLiCnt  = $("#"+formId+" .qstnItemTd .checkbox_type:not(.etcQstn)").length;	// 기존 보기항목 수
		    var allVwitmCnt = $("#"+formId+" .qstnItemTd .checkbox_type").length; 				// 전체 보기항목 수

		    if(vwitmLiCnt < vwitmCnt) {
		 		for(var i = vwitmLiCnt; i < vwitmCnt; i++) {
		 			const inputType = type == "MLT_CHC" ? "checkbox" : "radio";
		 			var html  = "<div class='checkbox_type mb5 flex form-inline'>";
		 				html += "	<span class='custom-input w80' style='flex-shrink: 0;'>";
		 				html += "		<label for='"+formId+"Vwitm_"+(i+1)+"'><spring:message code='srvy.label.vwitm' /> "+(i+1)+"</label>";/* 보기 */
		 				html += "	</span>";
		 				html += "	<div class='form-inline flex-highlight flex gap-2'>";
		 				html += "		<input type='text' class='form-control width-50per' name='vwitmCts' id='"+formId+"Vwitm_"+(i+1)+"' required='true' />";
		 				html += "		<label class='etcSelectDiv'>";
			 	   		html += "			<select class='form-select' name='mvmnSrvypprId' id='"+formId+"Mvmn_"+(i+1)+"'>";
			 	   		html += "				<option value='NEXT'><spring:message code='srvy.label.mvmn.next.page' /></option>";/* 다음 페이지로 이동 */
			 	   		html += "			</select>";
			 	   		html += "		</label>";
		 				html += "	</div>";
		 				html += "</div>";

		 			if(allVwitmCnt > vwitmLiCnt) {
		 				$("#"+formId+" .qstnItemTd .checkbox_type:not(.etcQstn)").last().after(html);
		 			} else {
			 			$("#"+formId+" .qstnItemTd").append(html);
		 			}

			     	$("#"+formId+" .etcSelectDiv select[name=mvmnSrvypprId]").chosen({disable_search: true});
			     	if(!$("#"+formId+" .qstnTypeDiv input[name=srvyMvmnUseyn]").is(":checked")) {
						$("#"+formId+" .qstnTypeDiv .etcSelectDiv").hide();
					}
			     	qstnOption.initSrvypprMvmn(formId, "Y", "N");	// 다음설문지아이디 초기화
		 		}
		    } else if(vwitmLiCnt > vwitmCnt) {
		 		for(var i = vwitmLiCnt; i > vwitmCnt-1; i--) {
		 		 	$("#"+formId+" .qstnItemTd .checkbox_type:not(.etcQstn):eq("+i+")").remove();
		 		}
		    }
	    },
	    /**
		* 기타보기항목변경 HTML 추가
		* @param {String}  	formId 		- 문제 추가용 form 아이디
		* @param {obj}  	obj 		- 변경객체
		*/
		etcVwitmChgHtml: function(obj, formId) {
			if(obj.checked) {
				var html  = "<div class='checkbox_type etcQstn mb5 flex form-inline' id='"+formId+"_etc'>";
					html += "	<span class='custom-input w80' style='flex-shrink: 0;'>";
	 				html += "		<label>기타</label>";
	 				html += "	</span>";
	 				html += "	<div class='form-inline flex-highlight flex gap-2'>";
	 				html += "		<label class='etcSelectDiv'>";
		 	   		html += "			<select class='form-select w150' name='mvmnSrvypprId' id='"+formId+"Mvmn_etc'>";
		 	   		html += "				<option value='NEXT'><spring:message code='srvy.label.mvmn.next.page' /></option>";/* 다음 페이지로 이동 */
		 	   		html += "			</select>";
		 	   		html += "		</label>";
	 				html += "	</div>";
	 				html += "</div>";
				$("#"+formId+" .qstnItemTd").append(html);
				$("#"+formId+" select[name=mvmnSrvypprId]").chosen({disable_search: true});
				if(!$("#"+formId+" .qstnTypeDiv input[name=srvyMvmnUseyn]").is(":checked")) {
					$("#"+formId+" .qstnTypeDiv .etcSelectDiv").hide();
				}
				qstnOption.initSrvypprMvmn(formId, "Y", "Y");	// 다음설문지아이디 초기화
			} else {
				$("#"+formId+"_etc").remove();
			}
		},
		/**
		* 다음설문지아이디 초기화
		* @param {String}  	formId 		- 문제 추가용 form 아이디
		* @param {obj}  	lastyn 		- 마지막여부
		* @param {obj}  	etcyn 		- 기타여부
		*/
		initSrvypprMvmn: function(formId, lastyn, etcyn) {
			var html = "<option value='NEXT'><spring:message code='srvy.label.mvmn.next.page' /></option>";/* 다음 페이지로 이동 */
			let srvySeqno = $("#"+formId).closest(".srvypprDiv").attr("data-seqno");
			$(".srvypprDiv").filter(function () {
				return parseInt($(this).attr("data-seqno"), 10) > srvySeqno;
			}).each(function () {
				let seqno 	= $(this).attr("data-seqno");
				let id		= $(this).attr("data-id");
				html += "<option value='" + id + "'>" + seqno + "<spring:message code='srvy.label.mvmn.seqno.page' /></option>";/* 페이지로 이동 */
			});
			html += "<option value='END'><spring:message code='srvy.label.srvy.end' /></option>";/* 설문 종료 */

			if(lastyn == "Y") {
				if(etcyn == "Y") {
					$("#"+formId+" .etcQstn select[name=mvmnSrvypprId]").empty().append(html);
					$("#"+formId+" .etcQstn select[name=mvmnSrvypprId]").val('NEXT').trigger('chosen:updated');
				} else {
					$("#"+formId+" .qstnItemTd .checkbox_type:not(.etcQstn) select[name=mvmnSrvypprId]").last().empty().append(html);
					$("#"+formId+" .qstnItemTd .checkbox_type:not(.etcQstn) select[name=mvmnSrvypprId]").last().val('NEXT').trigger('chosen:updated');
				}
			} else {
				$("#"+formId+" .etcSelectDiv select[name=mvmnSrvypprId]").empty().append(html);
				$("#"+formId+" .etcSelectDiv select[name=mvmnSrvypprId]").val('NEXT').trigger('chosen:updated');
			}
		},
		/**
		* 분기선택보기
		* @param {String}  	formId 		- 문제 추가용 form 아이디
		* @param {obj}  	obj 		- 변경객체
		*/
		mvmnSelectView: function(obj, formId) {
			let srvyQstnId = $("#"+formId+" input[name=srvyQstnId]").val();
			if(obj.checked) {
				var isMvmn = false;

				$("#"+formId).closest(".srvypprDiv").find("div.sortQstnDiv:not([data-id='"+srvyQstnId+"'])").each(function(i) {
					if($(this).attr("data-mvmnyn") == "Y") {
						isMvmn = true;
					}
				});
				if(isMvmn) {
					UiSwitcherOff(obj.id);
					UiComm.showMessage("<spring:message code='srvy.label.ouarter.info' />", "info");/* 한 페이지에 하나의 문항만 분기 가능합니다. */
					return false;
				}
				$("#"+formId+" .qstnTypeDiv .etcSelectDiv").show();
			} else {
				$("#"+formId+" .qstnTypeDiv .etcSelectDiv").hide();
			}
		}
	};

	// 페이지 이동
	function submitForm(action, kvArr){
		$("form[name='tempForm']").remove();

		var form = $("<form></form>");
		form.attr("method", "POST");
		form.attr("name", "tempForm");
		form.attr("action", action);

		for(var i=0; i<kvArr.length; i++){
			form.append($('<input/>', {type: 'hidden', name: kvArr[i].key, value: kvArr[i].val}));
		}

		form.appendTo("body");
		form.submit();
	};

	var selectOption = {
		// 학기기수목록
		smstrChrt: function() {
			return new Promise((resolve, reject) => {
		        let url  = "/quiz/smstrChrtListAjax.do";
		        if("${userCtx.userTycd}" == "ADM") url = "/quiz/admSmstrChrtListAjax.do";
		        const data = {
		            orgId  : $("#orgId").val(),
		            dgrsYr : $("#dgrsYr").val()
		        };

		        ajaxCall(url, data, function(data) {
		            if (data.result > 0) {
		                let returnList = data.returnList || [];
		                let html = "<option value=''><spring:message code='srvy.label.select.smstr' /></option>";/* 학기기수 선택 */

		                if(returnList.length > 0) {
		                    returnList.forEach(function(v, i) {
		                        html += "<option value='" + v.smstrChrtId + "'>" + v.smstrChrtnm + "</option>";
		                    });
		                }

		                $("#smstrChrtId").empty().append(html);
		                $("#smstrChrtId").val('${vo.smstrChrtId}').trigger("chosen:updated");
		                resolve();
		            } else {
		                UiComm.showMessage(data.message, "error");
		                reject(data.message);
		            }
		        }, function(xhr, status, error) {
		            UiComm.showMessage("<spring:message code='srvy.error.list' />", "error");/* 리스트 조회 중 에러가 발생하였습니다. */
		            reject(error);
		        }, true);
		    });
		},
		// 과목목록
		sbjct: function() {
			return new Promise((resolve, reject) => {
		        let url  = "/lctr/plandoc/sbjctListAjax.do";
		        if("${userCtx.userTycd}" == "ADM") url = "/quiz/admSbjctListAjax.do";
		        const data = {
			        orgId 		: $("#orgId").val(),
					sbjctYr		: $("#dgrsYr").val(),
					smstrChrtId : $("#smstrChrtId").val()
		        };

		        ajaxCall(url, data, function(data) {
		            if (data.result > 0) {
		            	let returnList = data.returnList || [];
		        		let html = "<option value=''><spring:message code='srvy.label.select.sbjct' /></option>";/* 과목 선택 */

		        		if(returnList.length > 0) {
		        			returnList.forEach(function(v, i) {
								html += "<option value='" + v.sbjctId + "'>" + v.sbjctnm + "</option>";
		        			});
		        		}

		        		$("#sbjctId").empty().append(html);
		        		$("#sbjctId").val('').trigger("chosen:updated");
		                resolve();
		            } else {
		                UiComm.showMessage(data.message, "error");
		                reject(data.message);
		            }
		        }, function(xhr, status, error) {
		            UiComm.showMessage("<spring:message code='srvy.error.list' />", "error");/* 리스트 조회 중 에러가 발생하였습니다. */
		            reject(error);
		        }, true);
		    });
		}
	}

	var htmlOption = {
		/**
		 * 관리자설문참여현황 HTML 리턴
		 * @param map 설문결과목록
		 */
		createAdmSrvyPtcpStatusHTML: function(map) {
			const list = map.srvypprList.map(srvyppr => ({
				// 설문지
			    ...srvyppr,
			 	// 문항
			    qstn: map.srvyQstnList
			        .filter(qstn => qstn.srvypprId === srvyppr.srvypprId)
			        .map(qstn => ({
			            ...qstn,
			            // 문항보기항목
			            vwitm: map.srvyVwitmList
		                .filter(vwitm => vwitm.srvyQstnId === qstn.srvyQstnId)
		                .map(vwitm => ({
		                    ...vwitm,
		                    // 레벨형답안
		                    levelRspns: qstn.qstnRspnsTycd === "LEVEL"
		                        ? map.egovListMap.levelRspnsList.filter(rspns => rspns.srvyQstnId === qstn.srvyQstnId && rspns.srvyVwitmId === vwitm.srvyVwitmId) : []
		                })),
		                // 레벨
			            lvl: map.srvyQstnVwitmLvlList.filter(lvl => lvl.srvyQstnId === qstn.srvyQstnId),
			            // 서술형답안
			            textRspns: qstn.qstnRspnsTycd == "LONG_TEXT"
			            	? map.egovListMap.textRspnsList.filter(rspns => rspns.srvyQstnId === qstn.srvyQstnId) : [],
			            // 선택형답안
			            chcRspns: ["ONE_CHC", "MLT_CHC", "OX_CHC"].includes(qstn.qstnRspnsTycd)
			            	? map.egovListMap.chcRspnsList.filter(rspns => rspns.srvyQstnId === qstn.srvyQstnId) : []
			        }))
			}));

			let html  = "<div class='course_history'>";
				html += "	<div class='question_area'>";
				html += "		<div class='scoreChart_wrap'>";
				html += "			<div class='left_chart'>";
				html += "				<div class='chart-container' style='height: 250px; position: relative; width: 100%;'>";
				html += "					<canvas id='statPieChart'></canvas>";
				html += "				</div>";
				html += "			</div>";
				html += "			<div class='right_chart'>";
				html += "				<div class='chart-container' style='height: 250px; position: relative; width: 100%;'>";
				html += "					<canvas id='devicePieChart'></canvas>";
				html += "				</div>";
				html += "			</div>";
				html += "		</div>";
				html += "	</div>";
				html += "</div>";
				// 설문지
				list.forEach(function(ppr,i) {
					html += "<div class='course_history'>";
					html += "	<div class='h_top'>";
					html += "		<div class='h_left'>";
					html += "			<h4>"+ppr.srvySeqno+"/"+map.srvypprList.length+" "+UiComm.escapeHtml(ppr.srvyTtl)+"</h4>";
					html += "		</div>";
					html += "	</div>";
					// 문항
					ppr.qstn.forEach(function(qstn, ii) {
						html += "<div class='question_area'>";
						html += "	<div class='question_con'>";
						html += "		<div class='q_top'>";
						html += "			<div class='flex-item width-100per'>";
						html += "				<p class='flex-none mr15'><b><spring:message code='srvy.label.qstn' />"+ppr.srvySeqno+"-"+qstn.qstnSeqno+"</b></p>";/* 문항 */
						html += "				<div class='flex-1 tal'>"+UiComm.escapeHtml(qstn.qstnTtl)+"</div>";
						html += "			</div>";
						html += "		</div>";
						html += "		<div class='q_cont padding-top-5 padding-bottom-5'>";
						if(qstn.qstnCts.trimStart().startsWith('<div class="se-contents"')) {
							html += "		<pre>" + qstn.qstnCts + "</pre>";
						} else {
							html += "		<p>" + qstn.qstnCts + "</p>";
						}
						// 단일선택형, 다중선택형, OX선택형
						if(qstn.qstnRspnsTycd == "ONE_CHC" || qstn.qstnRspnsTycd == "MLT_CHC" || qstn.qstnRspnsTycd == "OX_CHC") {
							html += "		<div class='scoreChart_wrap align-items-center'>";
							html += "			<div class='left_chart'>";
							html += "				<ol class='list_rect'>";
							qstn.chcRspns.forEach(function(rspns, iii) {
								html += "				<li class='flex-item margin-bottom-3'>";
								html += "					<span class='"+map.colorList[rspns.vwitmSeqno-1].title+"'></span>";
								if(rspns.vwitmCts == "ETC" && rspns.etcInptyn == "Y") {
									html += "				<spring:message code='srvy.label.etc' />";/* 기타 */
								} else {
									html += 				UiComm.escapeHtml(rspns.vwitmCts)
								}
								html += "				</li>";
							});
							html += "				</ol>";
							html += "			</div>";
							html += "			<div class='right_chart'>";
							html += "				<div class='chart-container' style='height: 250px; position: relative;'>";
							html += "					<canvas id='doughnut"+ppr.srvySeqno+"_"+qstn.qstnSeqno+"'></canvas>";
							html += "				</div>";
							html += "			</div>";
							html += "		</div>";
						// 레벨형
						} else if(qstn.qstnRspnsTycd == "LEVEL") {
							html += "		<div class='table-wrap margin-3'>";
							html += "			<table class='table-type2'>";
							html += "				<colgroup>";
							html += "					<col style=''>";
							qstn.lvl.forEach(function(lvl, iii) {
								let wPer = map.srvyQstnVwitmLvlList.length == 3 ? "15" : "10";
								html += "				<col style='width:"+wPer+"%'>";
							});
							html += "				</colgroup>";
							html += "				<thead>";
							html += "					<tr>";
							html += "						<th class='text-left'><spring:message code='srvy.label.qstn' /></th>";/* 문항 */
							qstn.lvl.forEach(function(lvl, iii) {
								html += "					<th>"+lvl.lvlCts+"</th>";
							});
							html += "					</tr>";
							html += "				</thead>";
							html += "				<tbody>";
							qstn.vwitm.forEach(function(vwitm, iii) {
								html += "				<tr>";
								html += "					<td class='text-left'>"+vwitm.vwitmCts+"</td>";
								vwitm.levelRspns.forEach(function(rspns, iiii) {
									html += "				<td>"+rspns.ratio+"%</td>";
								});
								html += "				</tr>";
							});
							html += "				</tbody>";
							html += "			</table>";
							html += "		</div>";
						// 서술형
						} else if(qstn.qstnRspnsTycd == "LONG_TEXT") {
							if(qstn.textRspns.length > 0) {
								html += "	<table class='table-type2'>";
								html += "		<colgroup>";
								html += "			<col class='width-20per' />";
								html += "			<col class='' />";
								html += "		</colgroup>";
								html += "		<tbody>";
								qstn.textRspns.forEach(function(rspns, iii) {
										html += "	<tr>";
										html += "		<th>"+rspns.usernm+"</th>";
										html += "		<td class='t_left'>"+(rspns.rspns || "")+"</td>";
										html += "	</tr>";
								});
								html += "		</tbody>";
								html += "	</table>";
							}
						}
						html += "		</div>";
						html += "	</div>";
						html += "</div>";
					});
					html += "</div>";
				});
			return html;
		},
		/**
		 * 관리자설문지문항 HTML 리턴
		 * @param list 설문지문항목록
		 */
		createAdmSrvypprQstnHTML: function(list) {
	    	let html = "";
		    	list.forEach(function(v, i) {
					html += "<div class='course_history srvypprDiv' data-id='" + v.srvypprId + "' data-seqno='" + v.srvySeqno + "'>";
					html += "	<div class='h_top'>";
					html += "		<div class='h_left'>";
					html += "			<h4><i class='xi-arrows mr10' aria-label='위젯 이동' role='button' tabindex='0' aria-grabbed='false'></i><spring:message code='srvy.label.page' /> " + v.srvySeqno + ". " + UiComm.escapeHtml(v.srvyTtl) + "</h4>";/* 페이지 */
					html += "		</div>";
					html += "		<div class='h_right'>";
					html += "			<a href='javascript:qstnAddFrmView(\"" + v.srvypprId + "\")' class='btn basic small'><spring:message code='srvy.button.add.qstn' /></a>";/* 문항 추가 */
		        	html += "			<a href='javascript:popupOption.srvyppr(\"" + v.srvyId + "\", \"" + v.srvypprId + "\", \"MODIFY\", \"ADM\")' class='btn basic small'><spring:message code='srvy.button.modify.page' /></a>";/* 페이지 수정 */
		        	html += "			<a href='javascript:srvypprDelete(\"" + v.srvyId + "\", \"" + v.srvypprId + "\", \"" + v.srvySeqno + "\")' class='btn basic type2 small'><spring:message code='srvy.button.delete.page' /></a>";/* 페이지 삭제 */
					html += "		</div>";
					html += "	</div>";
					html += "	<div class='question_area srvyQstnDiv'>";
					if(v.qstn.length == 0) {
						html += "	<p class='text-center'><spring:message code='srvy.label.qstn.cmptnn.info' /></p>";/* 출제 문항이 없습니다. */
					} else {
						v.qstn.forEach(function(vv, ii) {
							html += "<div class='question_con sortQstnDiv' data-id='" + vv.srvyQstnId + "' data-seqno='" + vv.qstnSeqno + "' data-pprid='" + vv.srvypprId + "' data-mvmnyn='" + vv.srvyMvmnUseyn + "'>";
							html += "	<div class='q_top bd0'>";
							html += "		<div class='flex-item width-100per'>";
							html += "			<div class='q-info-group'>";
							html += "				<button type='button' class='btn basic mr10 arrows-v flex-none'><i class='xi-arrows-v icon'></i></button>";
							html += "				<p class='flex-none mr15'><b>" + v.srvySeqno + "-" + vv.qstnSeqno + "</b></p>";
							html += "			</div>";
							html += "			<div class='flex-1 tal q-content cursor-pointer' onclick='qstnModFrmView(\"" + v.srvypprId + "\", \"" + vv.srvyQstnId + "\")'>" + UiComm.escapeHtml(vv.qstnTtl) + "</div>";
							html += "			<div class='q-ctrl-group'>";
							html += "				<p class='flex-none ml15 mr15'>" + vv.qstnRspnsTynm + "</p>";
							html += "				<button type='button' onclick='qstnDelete(\"" + v.srvypprId + "\", \"" + vv.srvyQstnId + "\", \"" + vv.qstnSeqno + "\")' class='btn type2 small flex-none'><spring:message code='srvy.button.delete' /></button>";	// 삭제
							html += "			</div>";
							html += "		</div>";
							html += "	</div>";
							html += "</div>";
						});
					}
					html += "	</div>";
					html += "</div>";
		    	});
	    	return html;
		}
	}

	var popupOption = {
		/*
		 * 설문참여팝업
		 * @param srvyId		설문아이디
		 * @param upSrvyId		상위설문아이디
		 * @param srvyPtcpId	설문참여아이디
		 * @param sbjctId		과목아이디
		 * @param type			설문구분 (SRVY : 설문, LCTR : 강의평가, WHOL : 전체설문)
		 */
		srvyPtcp: function(srvyId, upSrvyId, srvyPtcpId, sbjctId, type) {
			if(type == "LCTR") closeDialog();
			const typeMap = {
				SRVY : {
					  url 		: "/srvy/srvyPtcpPopup.do"
					, title 	: "<spring:message code='srvy.label.srvyppr' />"/* 설문지 */
					, data		: "sbjctId="+sbjctId+"&srvyId="+srvyId+"&upSrvyId="+upSrvyId+"&srvyPtcpId="+srvyPtcpId
				},
				LCTR : {
					  url 		: "/srvy/srvyLctrEvlPtcpPopup.do"
					, title 	: "<spring:message code='srvy.common.lctr.evl' />"/* 강의평가 */
					, data		: "srvyId="+srvyId+"&upSrvyId="+upSrvyId
				},
				WHOL : {
					  url 		: "/srvy/wholSrvyPtcpPopup.do"
					, title		: "<spring:message code='srvy.label.srvyppr' />"/* 설문지 */
					, data		: "srvyId="+srvyId
				}
			};

			dialog = UiDialog("dialog1", {
				title		: typeMap[type]["title"],
				url			: typeMap[type]["url"]+"?"+typeMap[type]["data"],
				fullscreen	: true
			});
		},
		/*
		 * 설문결과팝업
		 * @param srvyId		설문아이디
		 * @param upSrvyId		상위설문아이디
		 * @param ptcpEdttm		참여종료일시
		 * @param sbjctId		과목아이디
		 * @param type			설문구분 (SRVY : 설문, LCTR : 강의평가, WHOL : 전체설문)
		 */
		srvyResult: function(srvyId, upSrvyId, ptcpEdttm, sbjctId, type) {
			const typeMap = {
				SRVY : {
					  url 		: "/srvy/srvyPtcpStatusPopup.do"
					, title 	: "<spring:message code='srvy.label.srvy.result' />"/* 설문 결과 */
					, message 	: "<spring:message code='srvy.alert.not.ptcp.srvyppr' />"/* 참여한 설문지가 없습니다. */
					, data		: "srvyId="+srvyId+"&sbjctId="+sbjctId
				},
				LCTR : {
					  url 		: "/srvy/srvyLctrEvlPtcpStatusPopup.do"
					, title 	: "<spring:message code='srvy.label.lctr.evl.result' />"/* 강의평가 결과 */
					, message 	: "<spring:message code='srvy.alert.not.ptcp.lect.evl' />"/* 참여한 강의평가가 없습니다. */
					, data		: "srvyId="+srvyId+"&upSrvyId="+upSrvyId
				},
				WHOL : {
					  url		: "/srvy/wholSrvyPtcpStatusPopup.do"
					, title		: "<spring:message code='srvy.label.srvy.result' />"/* 설문 결과 */
					, message	: "<spring:message code='srvy.alert.not.ptcp.srvyppr' />"/* 참여한 설문지가 없습니다. */
					, data		: "srvyId="+srvyId
				}
			};

			if(ptcpEdttm == "") {
				UiComm.showMessage(typeMap[type]["message"], "info");
				return;
			}

			dialog = UiDialog("dialog1", {
				title		: typeMap[type]["title"],
				url			: typeMap[type]["url"]+"?"+typeMap[type]["data"],
				fullscreen	: true
			});
		},
		/*
		 * 강의평가참여안내팝업
		 * @param srvyId	설문아이디
		 * @param upSrvyId	상위설문아이디
		 */
		lctrEvlPtcpInfo: function(srvyId, upSrvyId) {
			const data = "srvyId="+upSrvyId+"&subParam="+srvyId;
			dialog = UiDialog("dialog1", {
				title		: "<spring:message code='srvy.label.lctr.evl.notice' />",/* 강의평가 안내문 */
				width		: 800,
				height		: 500,
				url			: "/srvy/srvyLctrEvlPtcpInfoPopup.do?"+data,
				autoresize	: true
			});
		},
		/*
		 * 설문지팝업
		 * @param srvyId		설문아이디
		 * @param srvypprId		설문지아이디
		 * @param type			구분 (REGIST : 등록, MODIFY : 수정)
		 * @param auth			권한 (PROF : 교수, ADM : 관리자)
		 */
		srvyppr: function(srvyId, srvypprId, type, auth) {
			if(!canSrvyEdit("")) {
	    		return false;
	    	}

			const urlMap = {
				REGIST : {
					  PROF : "/srvy/profSrvypprRegistPopup.do"
					, ADM  : "/srvy/admSrvypprRegistPopup.do"
				},
				MODIFY : {
					  PROF : "/srvy/profSrvypprModifyPopup.do"
					, ADM  : "/srvy/admSrvypprModifyPopup.do"
				}
			};

			const typeMap = {
				REGIST : {
					  url 		: urlMap[type][auth]
					, title 	: "<spring:message code='srvy.button.add.page' />"/* 페이지 추가 */
					, data		: "srvyId="+srvyId
				},
				MODIFY : {
					  url 		: urlMap[type][auth]
					, title 	: "<spring:message code='srvy.button.modify.page' />"/* 페이지 수정 */
					, data		: "srvyId="+srvyId+"&srvypprId="+srvypprId
				}
			};

			dialog = UiDialog("dialog1", {
				title	: typeMap[type]["title"],
				width	: 800,
				height	: 500,
				url		: typeMap[type]["url"]+"?"+typeMap[type]["data"]
			});
		}
	}
</script>

<style>
	.ox_item .ox_input:checked + label .xi-radiobox-blank.icon {
	    color: #00A4D8;
	}
	.ox_item .ox_input:checked + label .xi-close.icon {
	    color: var(--red-400, #ff5252);
	}
</style>