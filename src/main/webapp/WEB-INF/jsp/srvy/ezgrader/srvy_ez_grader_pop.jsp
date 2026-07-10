<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
			<jsp:param name="style" value="classroom"/>
			<jsp:param name="module" value="table"/>
		</jsp:include>
    </head>

    <script type="text/javascript">
    	$(document).ready(function() {
    		srvyPtcpListSelect();
    	});

    	/**
		 * 설문참여목록조회
		 */
    	function srvyPtcpListSelect() {
    		const url  = "/srvy/ezgrader/profSrvyPtcpListByEzGraderAjax.do";
    		const data = {
    			srvyId     : "${vo.srvyId}",
    			sbjctId    : "${vo.sbjctId}",
    			searchSort : $("#ezgSearchSort").val(),
    			searchKey  : $("#ezgSearchKey").val()
    		};

    		ajaxCall(url, data, function(data) {
    			if (data.result > 0) {
    				let returnList = data.returnList || [];
    				let html = "";

    				if(returnList.length > 0) {
    					returnList.forEach(function(v, i) {
    						const activeUserIds = $(".stu_list_area div[name=ezgTargetUser].active")
    				        .map(function() { return $(this).attr("data-userid"); })
    				        .get();

    						let srvyId = v.subSrvyId != null ? v.subSrvyId : v.srvyId;
    						let profMemo = v.profMemo != null ? v.profMemo : "";
    						if(v.tnum == 1) {
    							html += "<div class='stu_list'>";
    						}
    						if(v.srvyGbn == "SRVY_TEAM" && v.tnum == 1) {
								var teamSelectClass = $(".stu_list_area div[name=ezgTargetTeam].active").attr("data-teamid") == v.teamId ? "active" : "";
								html += "	<p class='temaTitle cursor-pointer "+teamSelectClass+"' onclick='selectTeam(this)' name='ezgTargetTeam' data-srvyid='"+srvyId+"' data-teamid='"+v.teamId+"'>"+v.teamnm+"</p>";
    						}
    						let selectClass = activeUserIds.includes(v.userId) ? "active" : "";
    						if(v.tnum == 1) {
    							html += "	<ul>";
    						}
    						html += "			<li class='"+selectClass+"' onclick='selectUser(this)' name='ezgTargetUser' data-srvyid='"+srvyId+"' data-ptcpid='"+v.srvyPtcpId+"' data-memo='"+profMemo+"' data-score='"+v.ptcpEvlScr+"' data-userid='"+v.userId+"' data-teamid='"+v.teamId+"'>";
    						html += "				<div class='icon_box'>";
    						if(v.ptcpyn == "Y") {
	    						html += "				<span><i class='xi-check icon'></i></span>";
    						}
    						html += "				</div>";
    						html += "				<span>"+v.deptnm+"</span>";
    						html += "				<p class='user'>"+v.usernm+"</p>";
    						html += "			</li>";
    						if((v.tnum == 1 && i > 0) || (v.srvyGbn == "SRVY" && i == returnList.length)) {
	    						html += "	</ul>";
	    						html += "</div>";
    						}
    					});
    				}

	        		$(".stu_list_area").empty().html(html);
                } else {
                	UiComm.showMessage(data.message, "error");
                }
    		}, function(xhr, status, error) {
    			UiComm.showMessage("<spring:message code='srvy.error.list' />", "error");	/* 리스트 조회 중 에러가 발생하였습니다. */
    		}, true);
    	}

    	/**
    	 * 참여평가 점수/메모 입력값 세팅
    	 * @param score
    	 * @param memo
    	 */
    	function setEvlScrMemo(score, memo) {
    		$("#ptcpEvlScr").val(score);
    		$("#profMemo").val(memo);
    	}

    	/**
    	 * 팀/학습자 목록의 active 클래스 동기화
    	 * @param teamId		활성화할 teamid
    	 * @param activeUserEl	활성화할 학습자 엘리먼트 (없으면 teamId로 매칭되는 요소들 전체 활성화)
    	 */
    	function syncTeamUserActive(teamId, activeUserEl) {
    		$(".stu_list_area p[name=ezgTargetTeam]").removeClass("active");
    		$(".stu_list_area p[name=ezgTargetTeam][data-teamid='" + teamId + "']").addClass("active");

    		$(".stu_list_area li[name=ezgTargetUser]").removeClass("active");
    		if (activeUserEl) {
    			activeUserEl.addClass("active");
    		} else {
    			$(".stu_list_area li[name=ezgTargetUser][data-teamid='" + teamId + "']").addClass("active");
    		}
    	}

    	// 팀선택
    	function selectTeam(obj) {
    		setEvlScrMemo("", "");
    		syncTeamUserActive($(obj).attr("data-teamid"), null);
    		srvyRspnsListSelect($(obj).attr("data-srvyid"), "", "");
    	}

    	// 학습자선택
    	function selectUser(obj) {
    		setEvlScrMemo($(obj).attr("data-score"), $(obj).attr("data-memo"));
    		syncTeamUserActive($(obj).attr("data-teamid"), $(obj));
    		srvyRspnsListSelect($(obj).attr("data-srvyid"), $(obj).attr("data-userid"), $(obj).attr("data-ptcpid"));
    	}

    	/**
		 * 설문답변목록조회
		 * @param srvyId 		- 설문아이디
		 * @param userId 		- 사용자아이디
		 * @param srvyPtcpId 	- 설문참여아이디
		 */
    	function srvyRspnsListSelect(srvyId, userId, srvyPtcpId) {
    		const url  = "/srvy/ezgrader/profSrvyRspnsListByEzGraderAjax.do";
    		const data = {
	    		srvyId 		: srvyId,
				userId 		: userId,
				srvyPtcpId 	: srvyPtcpId
    		};

    		ajaxCall(url, data, function(data) {
    			if (data.result > 0) {
					let html = "";
					if(data.data != null) {
						let vo = data.data;
						if(vo.srvypprList.length == 0) {
							html += "<div class='msg-box'>";
	            			html += "	<p class='txt'><spring:message code='common.content.not_found' /></p>";/* 등록된 내용이 없습니다. */
	            			html += "</div>";
						} else {
							vo.srvypprList.forEach(function(ppr, i) {
								html += "<div class='srvypprDiv' data-id='"+ppr.srvypprId+"' data-seqno='"+ppr.srvySeqno+"' " + (ppr.srvySeqno > 1 ? "style='display:none;'" : "") + ">";
								html += "	<div class='board_top'>";
								html += "		<p class='right-area'>" + ppr.srvySeqno + "/" + vo.srvypprList.length + " <spring:message code='srvy.label.page' /></p>";/* 페이지 */
								html += "	</div>";
								vo.srvyQstnList.forEach(function(qstn, j) {
									if(ppr.srvypprId == qstn.srvypprId) {
										html += "<div class='border-1 margin-top-3 cpn'>";
										html += "	<div class='board_top border-1 padding-3'>";
										html += "		<span>" + ppr.srvySeqno + "." + qstn.qstnSeqno + " " + UiComm.escapeHtml(qstn.qstnTtl) + "</span>";
										html += "	</div>";
										html += "	<div class='padding-3 margin-top-0'>";
										html += "		<div class='margin-bottom-5'>" + qstn.qstnCts + "</div>";
										html += "	</div>";
										// 단일, 다중선택형
										if(qstn.qstnRspnsTycd == "ONE_CHC" || qstn.qstnRspnsTycd == "MLT_CHC") {
											vo.srvyVwitmList.forEach(function(vwitm, k) {
												if(qstn.srvyQstnId == vwitm.srvyQstnId) {
													let rspnsChc = "";
													let rspns = "";
													vo.srvyRspnsList.forEach(function(rs, n) {
														if(rs.srvyQstnId == qstn.srvyQstnId && rs.srvyVwitmId == vwitm.srvyVwitmId) {
															rspnsChc = "checked='true'";
															if(vwitm.vwitmCts == "ETC") rspns = rs.rspns;
														}
													});
													html += "<div class='padding-3 flex-item'>";
													html += "	<span class='custom-input'>";
													html += "		<input type='"+(qstn.qstnRspnsTycd == "MLT_CHC" ? "checkbox" : "radio")+"' " + rspnsChc + " name='"+qstn.srvyQstnId+"_chc' id='"+qstn.srvyQstnId+"_chc_"+vwitm.vwitmSeqno+"' />";
													html += "		<label for='"+qstn.srvyQstnId+"_chc_"+vwitm.vwitmSeqno+"'>" + (vwitm.vwitmCts == "ETC" ? "<spring:message code='srvy.label.etc' />"/* 기타 */ : vwitm.vwitmCts) + "</label>";
													html += "	</span>";
													if(qstn.etcInptUseyn == "Y" && vwitm.vwitmCts == "ETC") {
														html += "<input type='text' class='width-80per' name='rspns' value='"+rspns+"' readonly='true' />";
													}
													html += "</div>";
												}
											});
										// OX선택형
										} else if(qstn.qstnRspnsTycd == "OX_CHC") {
											vo.srvyVwitmList.forEach(function(vwitm, k) {
												if(qstn.srvyQstnId == vwitm.srvyQstnId) {
													let rspnsChc = "";
													vo.srvyRspnsList.forEach(function(rs, n) {
														if(rs.srvyQstnId == qstn.srvyQstnId && rs.srvyVwitmId == vwitm.srvyVwitmId) {
															rspnsChc = "checked='true'";
														}
													});
													html += "<div class='padding-3'>";
													html += "	<span class='custom-input'>";
													html += "		<input type='radio' " + rspnsChc + " name='"+qstn.srvyQstnId+"_chc' id='"+qstn.srvyQstnId+"_chc_"+vwitm.vwitmSeqno+"' />";
													html += "		<label for='"+qstn.srvyQstnId+"_chc_"+vwitm.vwitmSeqno+"'>" + vwitm.vwitmCts + "</label>";
													html += "	</span>";
													html += "</div>";
												}
											});
										// 서술형
										} else if(qstn.qstnRspnsTycd == "LONG_TEXT") {
											let rspns = "";
											vo.srvyRspnsList.forEach(function(rs, n) {
												if(rs.srvyQstnId == qstn.srvyQstnId) {
													rspns = rs.rspns;
												}
											});
											html += "<textarea style='width:100%;height:70px;'>" + rspns + "</textarea>";
										// 레벨형
										} else if(qstn.qstnRspnsTycd == "LEVEL") {
											html += "<div class='table-wrap margin-3'>";
											html += "	<table class='table-type2'>";
											html += "		<colgroup>";
											html += "			<col style=''>";
											vo.srvyQstnVwitmLvlList.forEach(function(lvl, l) {
												if(qstn.srvyQstnId == lvl.srvyQstnId) {
													var wPer = vo.srvyQstnVwitmLvlList.length == 3 ? "15" : "10";
													html += "	<col style='width:"+wPer+"%'>";
												}
											});
											html += "		</colgroup>";
											html += "		<thead>";
											html += "			<tr>";
											html += "				<th class='text-left'><spring:message code='srvy.label.qstn' /></th>";/* 문항 */
											vo.srvyQstnVwitmLvlList.forEach(function(lvl, l) {
												if(qstn.srvyQstnId == lvl.srvyQstnId) {
													html += "		<th>" + lvl.lvlCts + "</th>";
												}
											});
											html += "			</tr>";
											html += "		</thead>";
											html += "		<tbody>";
											vo.srvyVwitmList.forEach(function(vwitm, k) {
												if(qstn.srvyQstnId == vwitm.srvyQstnId) {
													html += "	<tr>";
													html += "		<td class='text-left'>" + vwitm.vwitmCts + "</td>";
													vo.srvyQstnVwitmLvlList.forEach(function(lvl, l) {
														if(qstn.srvyQstnId == lvl.srvyQstnId) {
															let rspnsChc = "";
															vo.srvyRspnsList.forEach(function(rs, n) {
																if(rs.srvyQstnId == qstn.srvyQstnId && rs.srvyVwitmId == vwitm.srvyVwitmId && rs.srvyQstnVwitmLvlId == lvl.srvyQstnVwitmLvlId) {
																	rspnsChc = "checked='true'";
																}
															});
															html += "<td>";
															html += "	<span class='custom-input onlychk'>";
															html += "		<input type='radio' " + rspnsChc + " name='"+vwitm.srvyVwitmId+"_lvl' id='"+vwitm.srvyVwitmId+"_lvl_"+lvl.lvlSeqno+"' />";
															html += "		<label for='"+vwitm.srvyVwitmId+"_lvl_"+lvl.lvlSeqno+"'></label>";
															html += "	</span>";
															html += "</td>";
														}
													});
													html += "	</tr>";
												}
											});
											html += "		</tbody>";
											html += "	</table>";
											html += "</div>";
										}
										html += "</div>";
									}
								});
								html += "</div>";
							});
							if(vo.srvypprList.length > 1) {
								html += "<div class='btns'>";
								html += "	<a href='javascript:goPrevSrvyppr();' class='btn type2' id='btnPrevSrvyppr'><spring:message code='srvy.button.prev' /></a>";/* 이전 */
								html += "	<a href='javascript:goNextSrvyppr();' class='btn type2' id='btnNextSrvyppr'><spring:message code='srvy.button.next' /></a>";/* 다음 */
								html += "</div>";
							}
						}
					}
					$("#srvypprDiv").empty().append(html);
					initSrvyppr();
                } else {
                	UiComm.showMessage(data.message, "error");
                }
    		}, function(xhr, status, error) {
    			UiComm.showMessage("<spring:message code='srvy.error.list' />", "error");	/* 리스트 조회 중 에러가 발생하였습니다. */
    		}, true);
    	}

    	function initSrvyppr() {
    		showSrvyppr(1);
    	}

    	// 해당 순번 설문지 표시 및 버튼 제어
    	function showSrvyppr(seqno) {
    		let srvypprCnt = $("div.srvypprDiv").length;

    		$("div.srvypprDiv").hide();
    		$("div.srvypprDiv[data-seqno=" + seqno + "]").show();

    		$("#btnPrevSrvyppr").toggle(seqno > 1);
    		$("#btnNextSrvyppr").toggle(seqno < srvypprCnt);
    	}

    	// 이전 설문지로 이동
    	function goPrevSrvyppr() {
    		let curSeqno = Number($("div.srvypprDiv:visible").attr("data-seqno"));

    		if (curSeqno > 1) {
    			showSrvyppr(curSeqno - 1);
    		}
    	}

    	// 다음 설문지로 이동
    	function goNextSrvyppr() {
    		let curSeqno = Number($("div.srvypprDiv:visible").attr("data-seqno"));
    		let srvypprCnt = $("div.srvypprDiv").length;

    		if (curSeqno < srvypprCnt) {
    			showSrvyppr(curSeqno + 1);
    		}
    	}

    	// 점수 저장
    	function submitScore() {
    		if($(".stu_list_area li[name=ezgTargetUser].active").length < 1){
    			UiComm.showMessage("<spring:message code='srvy.alert.select.target' />", "warning");	/* 선택된 대상이 없습니다. */
    			return false;
    		}

    		let score = $("#ptcpEvlScr").val();

    		// 점수 입력
    		if(score == ""){
    			UiComm.showMessage("<spring:message code='srvy.alert.input.score' />", "warning");	/* 점수를 입력하세요. */
    			return false;
    		}

    		const scrList = [];	// 점수 목록

    		$(".stu_list_area li[name=ezgTargetUser].active").each(function(i, v) {
    			scrList.push({
					srvyId 		: $(v).attr("data-srvyid"),		// 설문아이디
					srvyPtcpId 	: $(v).attr("data-ptcpid"),		// 설문참여아이디
					userId		: $(v).attr("data-userid"),		// 사용자아이디
					scr			: score,						// 점수
					scoreType	: "batch"						// 점수유형
				});
    		});

    		UiComm.showMessage("<spring:message code='srvy.confirm.save.score' />", "confirm")	/* 점수를 저장하시겠습니까? */
    		.then(function(result) {
    			if (result) {
    				$.ajax({
		                url			: "/srvy/profSrvyEvlScrBulkModifyAjax.do",
		                type		: "POST",
		                contentType	: "application/json",
		                data		: JSON.stringify(scrList),
		                dataType	: "json",
		                beforeSend	: () => UiComm.showLoading(true),
		                success		: function (data) {
		                    if (data.result > 0) {
		                    	UiComm.showMessage("<spring:message code='srvy.alert.batch.score' />", "success");/* 일괄 점수 등록이 완료되었습니다. */
		                    	$("#ptcpEvlScr").val("");
				        		srvyPtcpListSelect();
		                    } else {
		                    	UiComm.showMessage(data.message, "error");
		                    }
		                },
		                error		: () => UiComm.showMessage("<spring:message code='srvy.error.batch.score' />", "error"),/* 일괄 점수 등록 중 에러가 발생하였습니다. */
		                complete	: () => UiComm.showLoading(false)
		            });
    			}
    		});
    	}

    	// 메모 등록
    	function submitMemo() {
    		if($(".stu_list_area li[name=ezgTargetUser].active").length == 0){
    			UiComm.showMessage("<spring:message code='srvy.alert.select.target' />", "warning");	/* 선택된 대상이 없습니다. */
    			return false;
    		}

    		const userList = [];	// 사용자 목록

    		$(".stu_list_area li[name=ezgTargetUser].active").each(function(i, v) {
    			userList.push({
					srvyId 		: $(v).attr("data-srvyid"),		// 설문아이디
					srvyPtcpId	: $(v).attr("data-ptcpid"),		// 설문참여아이디
					userId		: $(v).attr("data-userid"),		// 사용자아이디
					profMemo	: $("#profMemo").val()			// 교수메모
				});
		    });

    		const url  = "/srvy/srvyProfMemoBulkModifyAjax.do";

			$.ajax({
		        url 	  	: url,
		        async	  	: false,
		        type 	  	: "POST",
		        dataType  	: "json",
		        data 	  	: JSON.stringify(userList),
		        contentType	: "application/json; charset=UTF-8",
		    }).done(function(data) {
		    	if (data.result > 0) {
		    		UiComm.showMessage("<spring:message code='srvy.alert.insert.memo' />", "success");	/* 메모 저장이 완료되었습니다. */
		    		srvyPtcpListSelect();
		        } else {
		        	UiComm.showMessage(data.message, "error");
		        }
		    }).fail(function() {
		    	UiComm.showMessage("<spring:message code='srvy.error.memo.insert' />", "error");	/* 메모 저장 중 에러가 발생하였습니다. */
		    }, true);
    	}
    </script>

	<body class="class ${uiex:getTheme()}">
        <div id="wrap" class="main">
        	<!-- EZ-Grader 마크업 템플릿 -->
		    <div class="modal_EzGarder_area" style="width: 100%; height: 100%; border-radius: 0;">
		        <h1 class="EzGarder_title">
		            <spring:message code="srvy.label.ezgrader.title" /><!-- EZ-Grader 쉽고 빠르게 평가 -->
		            <button type="button" class="btn_close" onclick="window.parent.closeDialog();" aria-label="닫기"><i class="xi-close"></i></button>
		        </h1>
		        <div class="EzCarder_content">
		            <div class="left_list">
		                <div class="left_select_box mb10">
		                    <select class="form-select" id="ezgSearchSort" onChange="srvyPtcpListSelect()">
		                        <option value="USER_ID"><spring:message code="forum_ezg.label.userid_order" /></option><!-- 학번순 -->
								<option value="USER_NM"><spring:message code="forum_ezg.label.nm_order" /></option><!-- 이름순 -->
								<option value="SUBMIT_DT"><spring:message code="forum_ezg.label.submit_order" /></option><!-- 제출자순 -->
		                    </select>
		                    <select class="form-select" id="ezgSearchKey" onchange="srvyPtcpListSelect()">
		                        <option value=""><spring:message code="srvy.common.all" /><!-- 전체 --></option>
								<option value="Y"><spring:message code="srvy.label.ptcp" /></option>
								<option value="N"><spring:message code="srvy.label.not.ptcp" /><!-- 미참여 --></option>
		                    </select>
		                </div>
		                <div class="stu_list_area">
		                </div>
		            </div>

		            <div class="center_com width-100per" style="overflow-y: auto">
			            <div id="srvypprDiv"></div>
		            </div>

		            <div class="right_app">
						<div class="right_top_score">
	                        <label for="ptcpEvlScr"><input type="text" id="ptcpEvlScr" inputmask="numeric" maxVal="100" mask="999.99" placeholder="점수"></label>
	                        <button type="button" class="btn small type3" onclick="submitScore()"><spring:message code="srvy.button.save" /><!-- 저장 --></button>
	                        <button type="button" class="btn small type2" onclick="$('#ptcpEvlScr').val('')"><spring:message code="srvy.button.reset" /><!-- 초기화 --></button>
	                    </div>
	                    <div class="right_memo">
	                        <div class="memoBox">
	                            <label for="profMemo"><textarea id="profMemo"></textarea></label>
	                            <button type="button" class="btn small type3 width-100per" onclick="submitMemo()"><spring:message code="srvy.button.save" /><!-- 저장 --></button>
	                        </div>
	                    </div>
		            </div>
		        </div>
		    </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
