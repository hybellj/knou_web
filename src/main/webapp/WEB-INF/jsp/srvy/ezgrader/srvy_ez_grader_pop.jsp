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
    	var dialog;

    	$(document).ready(function() {
    		srvyPtcpListSelect();
    	});

    	/**
		 * 설문참여목록조회
		 * @param {String}  srvyId 		- 설문아이디
		 * @param {String}  sbjctId 	- 과목아이디
		 * @param {String}  searchSort 	- 정렬코드
		 * @param {String}  searchKey 	- 참여여부
		 * @returns {list} 설문참여목록
		 */
    	function srvyPtcpListSelect() {
    		var url  = "/srvy/ezgrader/profSrvyPtcpListByEzGraderAjax.do";
    		var data = {
    			"srvyId"     : "${vo.srvyId}",
    			"sbjctId"    : "${vo.sbjctId}",
    			"searchSort" : $("#ezgSearchSort").val(),
    			"searchKey"  : $("#ezgSearchKey").val()
    		};

    		ajaxCall(url, data, function(data) {
    			if (data.result > 0) {
    				var returnList = data.returnList || [];
    				var html = "";

    				if(returnList.length > 0) {
    					returnList.forEach(function(v, i) {
							var srvyId = v.subSrvyId != null ? v.subSrvyId : v.srvyId;
    						var profMemo = v.profMemo != null ? v.profMemo : "";
    						if(v.srvyGbn == "SRVY_TEAM" && v.tnum == 1) {
								var teamSelectClass = $("#userListDiv div[name=ezgTargetTeam].bcLblue").attr("data-teamid") == v.teamId ? "bcLblue" : "";
								html += "<div class='cursor-pointer margin-top-3 padding-2 border-1 "+teamSelectClass+"' onclick='selectTeam(this)' name='ezgTargetTeam' data-srvyid='"+srvyId+"' data-teamid='"+v.teamId+"'>";
								html += "	<p>"+v.teamnm+"</p>";
								html += "</div>";
    						}
    						var selectClass = $("#userListDiv div[name=ezgTargetUser].bcYellow").attr("data-userid") == v.userId ? "bcYellow" : "bcLgrey4";
    						html += "<div class='cursor-pointer margin-top-2 padding-2 text-right "+selectClass+"' onclick='selectUser(this)' name='ezgTargetUser' data-srvyid='"+srvyId+"' data-ptcpid='"+v.srvyPtcpId+"' data-memo='"+profMemo+"' data-score='"+v.ptcpEvlScr+"' data-userid='"+v.userId+"' data-teamid='"+v.teamId+"'>";
    						html += "	<p>"+v.deptnm+"</p>";
    						html += "	<p class='user'>"+v.usernm+" ("+v.userId+")</p>";
    						html += "</div>";
    					});
    				}

	        		$("#userListDiv").empty().html(html);
                } else {
                	UiComm.showMessage(data.message, "error");
                }
    		}, function(xhr, status, error) {
    			UiComm.showMessage("<spring:message code='resh.error.list' />", "error");	/* 설문 리스트 조회 중 에러가 발생하였습니다. */
    		});
    	}

    	// 팀 선택
    	function selectTeam(obj) {
    		$("#ptcpEvlScr").val("");
    		$("#memoDiv").hide();
    		$("#userListDiv div[name=ezgTargetTeam]").removeClass("bcLblue");
            $(obj).addClass("bcLblue");
            $("#userListDiv div[name=ezgTargetUser].bcYellow").removeClass("bcYellow").addClass("bcLgrey4");
            $("#userListDiv div[name=ezgTargetUser][data-teamid='"+$(obj).attr("data-teamid")+"']").removeClass("bcLgrey4").addClass("bcYellow");

            srvyRspnsListSelect($(obj).attr("data-srvyid"), "", "");
    	}

    	// 학습자 선택
    	function selectUser(obj) {
    		$("#ptcpEvlScr").val($(obj).attr("data-score"));
    		$("#profMemo").val($(obj).attr("data-memo"));
    		$("#memoDiv").show();
    		$("#userListDiv div[name=ezgTargetUser]").removeClass("bcYellow").addClass("bcLgrey4");
            $(obj).removeClass("bcLgrey4").addClass("bcYellow");
            $("#userListDiv div[name=ezgTargetTeam].bcLblue").removeClass("bcLblue");
            $("#userListDiv div[name=ezgTargetTeam][data-teamid='"+$(obj).attr("data-teamid")+"']").addClass("bcLblue");

            srvyRspnsListSelect($(obj).attr("data-srvyid"), $(obj).attr("data-userid"), $(obj).attr("data-ptcpid"));
    	}

    	/**
		 * 설문답변목록조회
		 * @param {String}  srvyId 		- 설문아이디
		 * @param {String}  userId 		- 사용자아이디
		 * @param {String}  srvyPtcpId 	- 설문참여아이디
		 * @returns {list} 설문답변목록
		 */
    	function srvyRspnsListSelect(srvyId, userId, srvyPtcpId) {
    		var url  = "/srvy/ezgrader/profSrvyRspnsListByEzGraderAjax.do";
    		var data = {
	    		"srvyId" 		: srvyId,
				"userId" 		: userId,
				"srvyPtcpId" 	: srvyPtcpId
    		};

    		ajaxCall(url, data, function(data) {
    			if (data.result > 0) {
					var html = "";
					if(data.returnVO != null) {
						var vo = data.returnVO;
						if(vo.srvypprList.length == 0) {
							html += "<div class='msg-box'>";
	            			html += "	<p class='txt'><spring:message code='common.content.not_found' /></p>";/* 등록된 내용이 없습니다. */
	            			html += "</div>";
						} else {
							vo.srvypprList.forEach(function(ppr, i) {
								html += "<div class='srvypprDiv' data-id='"+ppr.srvypprId+"' data-seqno='"+ppr.srvySeqno+"' " + (ppr.srvySeqno > 1 ? "style='display:none;'" : "") + ">";
								html += "	<div class='board_top'>";
								html += "		<p class='right-area'>" + ppr.srvySeqno + "/" + vo.srvypprList.length + " 페이지</p>";
								html += "	</div>";
								vo.srvyQstnList.forEach(function(qstn, j) {
									if(ppr.srvypprId == qstn.srvypprId) {
										html += "<div class='border-1 margin-top-3 cpn'>";
										html += "	<div class='board_top border-1 padding-3'>";
										html += "		<span>" + ppr.srvySeqno + "." + qstn.qstnSeqno + " " + qstn.qstnTtl + "</span>";
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
													html += "		<label for='"+qstn.srvyQstnId+"_chc_"+vwitm.vwitmSeqno+"'>" + (vwitm.vwitmCts == "ETC" ? "기타" : vwitm.vwitmCts) + "</label>";
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
											html += "				<th class='text-left'>문항</th>";
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
								html += "	<a href='javascript:goPrevSrvyppr();' class='btn type2' id='btnPrevSrvyppr'>이전</a>";
								html += "	<a href='javascript:goNextSrvyppr();' class='btn type2' id='btnNextSrvyppr'>다음</a>";
								html += "</div>";
							}
						}
					}
					$("#srvypprDiv").empty().append(html);
            		$('.user-section, .info-section').css('height', $('#srvypprDiv').height());
            		controllNextPrevBtn();
                } else {
                	UiComm.showMessage(data.message, "error");
                }
    		}, function(xhr, status, error) {
    			UiComm.showMessage("<spring:message code='resh.error.list' />", "error");	/* 설문 리스트 조회 중 에러가 발생하였습니다. */
    		});
    	}

		 /**
		 *  이전 다음 버튼 표시
		 */
		function controllNextPrevBtn() {
		    var curSeqno = Number($("div.srvypprDiv:visible").attr("data-seqno"));
		    var srvypprCnt = $("div.srvypprDiv").length;

		    $("div.srvypprDiv").hide();
		    $("div.srvypprDiv[data-seqno=1]").show();
		    $("#btnPrevSrvyppr").hide();
		    $("#btnNextSrvyppr").hide();
		    if (curSeqno > 1) {
		        $("#btnPrevSrvyppr").show();
		    }
		    if (curSeqno < srvypprCnt) {
		        $("#btnNextSrvyppr").show();
		    }
		}

		 /**
		 *  이전 버튼 클릭 시 앞 설문지로 이동
		 */
		function goPrevSrvyppr() {
		    var curSrvyppr   = $("div.srvypprDiv:visible");
		    var curSrvySeqno = Number(curSrvyppr.attr("data-seqno"));
		    if (curSrvySeqno > 1) {
		        $("#btnNextSrvyppr").show();
		        $("div.srvypprDiv").hide();
		        $("div.srvypprDiv[data-seqno=" + (curSrvySeqno - 1) + "]").show();
		        if (curSrvySeqno - 1 == 1) {
		            $("#btnPrevSrvyppr").hide();
		        }
		    }
		}

		/**
		 *  다음 버튼 클릭 시 뒤 설문지로 이동
		 */
		function goNextSrvyppr() {
		    var curSrvyppr   = $("div.srvypprDiv:visible");
		    var curSrvySeqno = Number(curSrvyppr.attr("data-seqno"));

		    var srvypprCnt = $("div.srvypprDiv").length;
		    if (curSrvySeqno < srvypprCnt) {
		        $("#btnPrevSrvyppr").show();
		        $("div.srvypprDiv").hide();
		        $("div.srvypprDiv[data-seqno=" + (curSrvySeqno + 1) + "]").show();
		        if (curSrvySeqno + 1 == srvypprCnt) {
		            $("#btnNextSrvyppr").hide();
		        }
		    }
		}

    	// 점수 저장
    	function submitScore() {
    		if($("#userListDiv div[name=ezgTargetUser].bcYellow").length < 1){
    			UiComm.showMessage("<spring:message code='resh.alert.select.target' />", "warning");	/* 선택된 대상이 없습니다. */
    			return false;
    		}

    		var score = $("#ptcpEvlScr").val();

    		// 점수 입력
    		if(score == ""){
    			UiComm.showMessage("<spring:message code='resh.label.input.score' />", "warning");	/* 점수를 입력하세요. */
    			return false;
    		}

    		var scrList = [];	// 점수 목록

    		$("#userListDiv div[name=ezgTargetUser].bcYellow").each(function(i, v) {
				var scr = {
					srvyId 		: $(v).attr("data-srvyid"),		// 설문아이디
					srvyPtcpId 	: $(v).attr("data-ptcpid"),		// 설문참여아이디
					userId		: $(v).attr("data-userid"),		// 사용자아이디
					scr			: score,						// 점수
					scoreType	: "batch"						// 점수유형
				};
				scrList.push(scr);
    		});

    		UiComm.showMessage("<spring:message code='resh.confirm.save.score' />", "confirm")	/* 점수를 저장하시겠습니까? */
    		.then(function(result) {
    			if (result) {
    				$.ajax({
		                url: "/srvy/profSrvyEvlScrBulkModifyAjax.do",
		                type: "POST",
		                contentType: "application/json",
		                data: JSON.stringify(scrList),
		                dataType: "json",
		                beforeSend: function () {
		                	UiComm.showLoading(true);
		                },
		                success: function (data) {
		                    if (data.result > 0) {
		                    	UiComm.showMessage("<spring:message code='exam.alert.batch.score' />", "success");/* 일괄 점수 등록이 완료되었습니다. */
		                    	$("#ptcpEvlScr").val("");
				        		srvyPtcpListSelect();
		                    } else {
		                    	UiComm.showMessage(data.message, "error");
		                    }
		                    UiComm.showLoading(false);
		                },
		                error: function (xhr, status, error) {
		                	UiComm.showMessage("<spring:message code='exam.error.batch.score' />", "error");/* 일괄 점수 등록 중 에러가 발생하였습니다. */
		                },
		                complete: function () {
		                	UiComm.showLoading(false);
		                },
		            });
    			}
    		});
    	}

    	// 메모 등록
    	function submitMemo() {
    		if($("#userListDiv div[name=ezgTargetUser].bcYellow").length != 1){
    			UiComm.showMessage("<spring:message code='resh.alert.select.target' />", "warning");	/* 선택된 대상이 없습니다. */
    			return false;
    		}

    		var target = $("#userListDiv div[name=ezgTargetUser].bcYellow");
    		var srvyId 		= target.attr("data-srvyid");	// 설문아이디
    		var srvyPtcpId 	= target.attr("data-ptcpid");	// 설문참여아이디
    		var userId 		= target.attr("data-userid");	// 사용자아이디

    		var url  = "/srvy/srvyProfMemoModifyAjax.do";
			var data = {
				"srvyId" 		: srvyId,
				"srvyPtcpId"  	: srvyPtcpId,
				"userId" 		: userId,
				"profMemo"		: $("#profMemo").val()
			};

			$.ajax({
		        url 	  : url,
		        async	  : false,
		        type 	  : "POST",
		        dataType  : "json",
		        data 	  : JSON.stringify(data),
		        contentType: "application/json; charset=UTF-8",
		    }).done(function(data) {
		    	if (data.result > 0) {
		    		UiComm.showMessage("<spring:message code='exam.alert.insert.memo' />", "success");	/* 메모 저장이 완료되었습니다. */
		    		srvyPtcpListSelect();
		        } else {
		        	UiComm.showMessage(data.message, "error");
		        }
		    }).fail(function() {
		    	UiComm.showMessage("<spring:message code='exam.error.memo.insert' />", "error");	/* 메모 저장 중 에러가 발생하였습니다. */
		    });
    	}
    </script>

	<body class="modal-page">
        <div id="wrap">
        	<div class="flex EG-layout">
        		<!-- 왼쪽 영역 -->
        		<div class="w250 padding-4 user-section">
        			<select class="form-select width-100per" id="ezgSearchSort" onchange="srvyPtcpListSelect()">
		                <option value="USER_ID"><spring:message code="forum_ezg.label.userid_order" /></option><!-- 학번순 -->
						<option value="USER_NM"><spring:message code="forum_ezg.label.nm_order" /></option><!-- 이름순 -->
						<option value="SUBMIT_DT"><spring:message code="forum_ezg.label.submit_order" /></option><!-- 제출자순 -->
		            </select>
		            <select class="form-select width-100per" id="ezgSearchKey" onchange="srvyPtcpListSelect()">
		                <option value="">전체</option>
						<option value="Y">참여</option>
						<option value="N">미참여</option>
		            </select>
		            <div class="margin-top-3" id="userListDiv"></div>
        		</div>
        		<!-- 왼쪽 영역 -->

        		<!-- 중앙 영역 -->
        		<div class="flex-1 border-1 border-top-1 border-bottom-1 padding-4">
        			<div class="scrollArea" id="srvypprDiv"></div>
        		</div>
        		<!-- 중앙 영역 -->

        		<!-- 오른쪽 영역 -->
        		<div class="width-25per info-section min-height-250px padding-4">
        			<div class="flex">
        				<input class="form-control flex-1" id="ptcpEvlScr" type="text" inputmask="numeric" maxVal="100" mask="999.99" style="min-width: 0;">
						<button type="button" onclick="submitScore()" class="btn type2">저장</button>
						<button type="button" onclick="$('#ptcpEvlScr').val('')" class="btn type2">초기화</button>
        			</div>
					<div class="board_top margin-top-3 bcLgrey4 padding-3" id="memoDiv">
						<textarea id="profMemo" style="width:100%;height:100px" maxLenCheck="byte,4000,true,true" placeholder="메모 입력"></textarea>
						<a href="javascript:submitMemo();" class="btn type1 right-area">저장</a>
					</div>
        		</div>
        		<!-- 오른쪽 영역 -->
        	</div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
