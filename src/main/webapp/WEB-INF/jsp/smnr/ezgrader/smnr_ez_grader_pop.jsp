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
    	var EPARAM 	= '<c:out value="${encParams}" />';

    	$(document).ready(function() {
    		smnrAtndListSelect();
    	});

    	/**
		 * 세미나참석목록조회
		 */
    	function smnrAtndListSelect() {
    		const extData = {
    			smnrId     : "${vo.smnrId}",
    			searchSort : $("#ezgSearchSort").val(),
    			searchKey  : $("#ezgSearchKey").val()
    		};

    		const url   = "/smnr/ezgrader/profSmnrAtndListByEzGraderAjax.do";
    		const param = {
  				encParams	: EPARAM,
  				addParams	: UiComm.makeEncParams(extData)
  			};

    		ajaxCall(url, param, function(data) {
    			if (data.result > 0) {
    				let returnList = data.returnList || [];
    				let html = "";

    				if(returnList.length > 0) {
    					returnList.forEach(function(v, i) {
    						const activeUserIds = $(".stu_list_area li[name=ezgTargetUser].active")
    				        .map(function() { return $(this).attr("data-userid"); })
    				        .get();

    						let smnrId = v.subSmnrId != null ? v.subSmnrId : v.smnrId;
    						let atndMemo = v.atndMemo != null ? v.atndMemo : "";
    						if(v.tnum == 1) {
    							html += "<div class='stu_list'>";
    						}
    						if(v.smnrGbn == "SMNR_TEAM" && v.tnum == 1) {
    							let teamSelectClass = $(".stu_list_area p[name=ezgTargetTeam].active").attr("data-teamid") == v.teamId ? "active" : "";
    							html += "	<p class='temaTitle cursor-pointer "+teamSelectClass+"' onclick='selectTeam(this)' name='ezgTargetTeam' data-smnrid='"+smnrId+"' data-teamid='"+v.teamId+"'>"+v.teamnm+"</p>";
    						}
    						let selectClass = activeUserIds.includes(v.userId) ? "active" : "";
    						if(v.tnum == 1) {
    							html += "	<ul>";
    						}
    						html += "			<li class='"+selectClass+"' onclick='selectUser(this)' name='ezgTargetUser' data-smnrid='"+smnrId+"' data-memo='"+atndMemo+"' data-atndid='"+v.smnrAtndId+"' data-score='"+v.atndEvlScr+"' data-userid='"+v.userId+"' data-teamid='"+v.teamId+"'>";
    						html += "				<div class='icon_box'>";
    						if(v.atndyn == "Y") {
	    						html += "				<span><i class='xi-check icon'></i></span>";
    						}
    						html += "				</div>";
    						html += "				<span>"+v.deptnm+"</span>";
    						html += "				<p class='user'>"+v.usernm+"</p>";
    						html += "			</li>";
    						if((v.tnum == 1 && i > 0) || (v.smnrGbn == "SMNR" && i == returnList.length)) {
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
    			UiComm.showMessage("<spring:message code='resh.error.list' />", "error");	/* 설문 리스트 조회 중 에러가 발생하였습니다. */
    		}, true);
    	}

    	// 팀선택
    	function selectTeam(obj) {
    		$("#atndEvlScr").val("");
    		$("#atndMemo").val("");
    		$(".stu_list_area p[name=ezgTargetTeam]").removeClass("active");
            $(obj).addClass("active");
            $(".stu_list_area li[name=ezgTargetUser].active").removeClass("active");
            $(".stu_list_area li[name=ezgTargetUser][data-teamid='"+$(obj).attr("data-teamid")+"']").addClass("active");

            smnrAtndHstryListSelect($(obj).attr("data-smnrid"), "");
    	}

    	// 학습자선택
    	function selectUser(obj) {
    		$("#atndEvlScr").val($(obj).attr("data-score"));
    		$("#atndMemo").val($(obj).attr("data-memo"));
    		$(".stu_list_area li[name=ezgTargetUser]").removeClass("active");
            $(obj).addClass("active");
            $(".stu_list_area p[name=ezgTargetTeam].active").removeClass("active");
            $(".stu_list_area p[name=ezgTargetTeam][data-teamid='"+$(obj).attr("data-teamid")+"']").addClass("active");

            smnrAtndHstryListSelect($(obj).attr("data-smnrid"), $(obj).attr("data-userid"));
    	}

    	/**
		 * 세미나참석이력목록조회
		 * @param smnrId 	- 세미나아이디
		 * @param userId 	- 사용자아이디
		 */
    	function smnrAtndHstryListSelect(smnrId, userId) {
			const userList = [];	// 사용자 목록

		    $(".stu_list_area li[name=ezgTargetUser].active").each(function(i, v) {
				let user = {
					smnrId 		: $(v).attr("data-smnrid"),		// 세미나아이디
					userId		: $(v).attr("data-userid")		// 사용자아이디
				};
				userList.push(user);
		    });

			const url = "/smnr/ezgrader/profSmnrAtndHstryListByEzGraderAjax.do";
			const data = {
				list		: userList,
    		    searchSort	: $("#ezgSearchSort").val()
			};

    		$.ajax({
                url			: url,
                type		: "POST",
                contentType	: "application/json",
                data		: JSON.stringify(data),
                dataType	: "json",
                beforeSend: function () {
                	UiComm.showLoading(true);
                },
                success: function (data) {
                    if (data.result > 0) {
                    	let html = "";
    					if(data.data != null) {
    						let vo = data.data;
    						let egovMap = vo.egovListMap;
    						if(egovMap.trgtrList.length == 0) {
    							html += "<div class='msg-box'>";
    	            			html += "	<p class='txt'><spring:message code='common.content.not_found' /></p>";/* 등록된 내용이 없습니다. */
    	            			html += "</div>";
    						} else {
    							egovMap.trgtrList.forEach(function(atnd, i) {
									html += "<table class='table-type3 text-left margin-bottom-3'>";
									html += "	<colgroup>";
									html += "		<col class='width-25per' />";
									html += "		<col class='width-25per' />";
									html += "		<col class='width-25per' />";
									html += "		<col class='width-25per' />";
									html += "	</colgroup>";
									html += "	<tbody>";
									html += "		<tr>";
									html += "			<th colspan='4'>수강생 정보</th>";
									html += "		</tr>";
									html += "		<tr>";
									html += "			<th>학과</th>";
									html += "			<th>대표아이디</th>";
									html += "			<th>학번</th>";
									html += "			<th>이름</th>";
									html += "		</tr>";
									html += "		<tr>";
									html += "			<td>" + atnd.deptnm + "</td>";
									html += "			<td>" + atnd.userRprsId + "</td>";
									html += "			<td>" + atnd.userId + "</td>";
									html += "			<td>" + atnd.usernm + "</td>";
									html += "		</tr>";
									html += "		<tr>";
									html += "			<th colspan='4'>참여 정보</th>";
									html += "		</tr>";
									html += "		<tr>";
									html += "			<th>ZOOM 세미나 진행시간</th>";
									html += "			<th>참여일시</th>";
									html += "			<th>참여시간</th>";
									html += "			<th>참여상태</th>";
									html += "		</tr>";
									html += "		<tr>";
									// 참여시간
									let atndScnds = atnd.atndScnds;
									let hours     = Math.floor(atndScnds / 3600);
									let minutes   = Math.floor((atndScnds % 3600) / 60);
									let seconds   = atndScnds % 60;
									atndScnds  = (hours < 10 ? "0" + hours : hours) + ":";
									atndScnds += (minutes < 10 ? "0" + minutes : minutes) + ":";
									atndScnds += seconds < 10 ? "0" + seconds : seconds;

									// ZOOM 세미나 진행시간
									let zoomDuration = "-";
					        		if(${not empty vo.zoomPastMeetingVO}) {
										let duration = vo.zoomPastMeetingVO.duration;
					        			let hours    = Math.floor(duration / 3600);
										let minutes  = Math.floor((duration % 3600) / 60);
										let seconds  = duration % 60;
										zoomDuration  = (hours < 10 ? "0" + hours : hours) + ":";
										zoomDuration += (minutes < 10 ? "0" + minutes : minutes) + ":";
										zoomDuration += seconds < 10 ? "0" + seconds : seconds;
					        		}
									html += "			<td>" + zoomDuration + "</td>";
									html += "			<td>" + (atnd.atndSdttm != null ? UiComm.formatDate(atnd.atndSdttm, "datetime2") : "-" ) + "</td>";
									html += "			<td>" + atndScnds + "</td>";
									html += "			<td>" + (atnd.atndyn == "Y" ? "참석" : "미참석") + "</td>";
									html += "		</tr>";
									html += "	</tbody>";
									html += "</table>";
									if(atnd.hstryCnt > 0) {
										html += "<table class='table-type3 text-left margin-bottom-3'>";
										html += "	<colgroup>";
										html += "		<col class='w40' />";
										html += "		<col class='width-10per' />";
										html += "		<col class='width-10per' />";
										html += "		<col class='width-10per' />";
										html += "		<col class='width-20per' />";
										html += "		<col class='width-20per' />";
										html += "		<col class='width-10per' />";
										html += "		<col class='width-10per' />";
										html += "	</colgroup>";
										html += "	<tbody>";
										html += "		<tr>";
										html += "			<th colspan='8'>참여 로그</th>";
										html += "		</tr>";
										html += "		<tr>";
										html += "			<th>NO</th>";
										html += "			<th>대표아이디</th>";
										html += "			<th>학번</th>";
										html += "			<th>이름</th>";
										html += "			<th>참석 시작일시</th>";
										html += "			<th>참석 종료일시</th>";
										html += "			<th>참석시간</th>";
										html += "			<th>접속기기</th>";
										html += "		</tr>";
										egovMap.hstryList.forEach(function(hstry, j) {
											if(atnd.userId == hstry.atndeId) {
												html += "	<tr>";
												// 참여시간
												let atndScnds = hstry.atndScnds;
												let hours     = Math.floor(atndScnds / 3600);
												let minutes   = Math.floor((atndScnds % 3600) / 60);
												let seconds   = atndScnds % 60;
												atndScnds  = (hours < 10 ? "0" + hours : hours) + ":";
												atndScnds += (minutes < 10 ? "0" + minutes : minutes) + ":";
												atndScnds += seconds < 10 ? "0" + seconds : seconds;
												html += "		<td>" + hstry.lineNo + "</td>";
												html += "		<td>" + hstry.userRprsId + "</td>";
												html += "		<td>" + hstry.atndeId + "</td>";
												html += "		<td>" + hstry.usernm + "</td>";
												html += "		<td>" + UiComm.formatDate(hstry.atndSdttm, "datetime2") + "</td>";
												html += "		<td>" + UiComm.formatDate(hstry.atndEdttm, "datetime2") + "</td>";
												html += "		<td>" + atndScnds + "</td>";
												html += "		<td>" + hstry.cntnDvcTynm + "</td>";
												html += "	</tr>";
											}
										});
										html += "	</tbody>";
										html += "</table>";
									}
    							});
    						}
    					}
    					$("#atndDiv").empty().append(html);
                		$('.user-section, .info-section').css('height', $('#atndDiv').height());
                    } else {
                    	UiComm.showMessage(data.message, "error");
                    }
                },
                error: function (xhr, status, error) {
                	UiComm.showMessage("리스트 조회 중 에러가 발생하였습니다.", "error");
                },
                complete: function () {
                	UiComm.showLoading(false);
                },
            });
    	}

    	// 점수 저장
    	function submitScore() {
    		if($(".stu_list_area li[name=ezgTargetUser].active").length == 0){
    			UiComm.showMessage("<spring:message code='resh.alert.select.target' />", "warning");	/* 선택된 대상이 없습니다. */
    			return false;
    		}

    		let score = $("#atndEvlScr").val();

    		// 점수 입력
    		if(score == ""){
    			UiComm.showMessage("<spring:message code='resh.label.input.score' />", "warning");	/* 점수를 입력하세요. */
    			return false;
    		}

    		const scrList = [];	// 점수 목록

    		$(".stu_list_area li[name=ezgTargetUser].active").each(function(i, v) {
    			let scr = {
					smnrId 		: $(v).attr("data-smnrid"),		// 세미나아이디
					smnrAtndId 	: $(v).attr("data-atndid"),		// 세미나참석아이디
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
		                url			: "/smnr/profSmnrEvlScrBulkModifyAjax.do",
		                type		: "POST",
		                contentType	: "application/json",
		                data		: JSON.stringify(scrList),
		                dataType	: "json",
		                beforeSend: function () {
		                	UiComm.showLoading(true);
		                },
		                success: function (data) {
		                    if (data.result > 0) {
		                    	UiComm.showMessage("<spring:message code='exam.alert.batch.score' />", "success");/* 일괄 점수 등록이 완료되었습니다. */
		                    	$("#atndEvlScr").val("");
				        		smnrAtndListSelect();
		                    } else {
		                    	UiComm.showMessage(data.message, "error");
		                    }
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
    		if($(".stu_list_area li[name=ezgTargetUser].active").length == 0){
    			UiComm.showMessage("<spring:message code='resh.alert.select.target' />", "warning");	/* 선택된 대상이 없습니다. */
    			return false;
    		}

    		const userList = [];	// 사용자 목록

		    $(".stu_list_area li[name=ezgTargetUser].active").each(function(i, v) {
		    	let user = {
					smnrId 		: $(v).attr("data-smnrid"),		// 세미나아이디
					smnrAtndId	: $(v).attr("data-atndid"),		// 세미나참석아이디
					userId		: $(v).attr("data-userid"),		// 사용자아이디
					atndMemo	: $("#atndMemo").val()			// 참석메모
				};
				userList.push(user);
		    });

    		const url  = "/smnr/smnrAtndMemoBulkModifyAjax.do";

			$.ajax({
		        url 	  	: url,
		        async	  	: false,
		        type 	  	: "POST",
		        dataType  	: "json",
		        data 	  	: JSON.stringify(userList),
		        contentType	: "application/json; charset=UTF-8",
		    }).done(function(data) {
		    	if (data.result > 0) {
		    		UiComm.showMessage("<spring:message code='exam.alert.insert.memo' />", "success");	/* 메모 저장이 완료되었습니다. */
		    		smnrAtndListSelect();
		        } else {
		        	UiComm.showMessage(data.message, "error");
		        }
		    }).fail(function() {
		    	UiComm.showMessage("<spring:message code='exam.error.memo.insert' />", "error");	/* 메모 저장 중 에러가 발생하였습니다. */
		    });
    	}

    	// 피드백 등록
    	function submitFdbk() {
    		if($(".stu_list_area li[name=ezgTargetUser].active").length == 0){
    			UiComm.showMessage("<spring:message code='resh.alert.select.target' />", "warning");	/* 선택된 대상이 없습니다. */
    			return false;
    		}

    		let fdbkCts = $("#fdbkCts").val();

    		// 피드백 입력
    		if(fdbkCts == ""){
    			UiComm.showMessage("피드백을 입력하세요.", "warning");
    			return false;
    		}

    		const userList = [];	// 사용자 목록

		    $(".stu_list_area li[name=ezgTargetUser].active").each(function(i, v) {
				let user = {
					smnrId 		: $(v).attr("data-smnrid"),		// 세미나아이디
					userId		: $(v).attr("data-userid"),		// 사용자아이디
					fdbkCts		: fdbkCts						// 피드백내용
				};
				userList.push(user);
		    });

    		const url  = "/smnr/profSmnrFdbkBulkRegistAjax.do";

			$.ajax({
		        url 	  	: url,
		        async	  	: false,
		        type 	  	: "POST",
		        dataType  	: "json",
		        data 	  	: JSON.stringify(userList),
		        contentType	: "application/json; charset=UTF-8",
		    }).done(function(data) {
		    	if (data.result > 0) {
		    		UiComm.showMessage("피드백 등록이 완료되었습니다.", "success");
		    		smnrAtndListSelect();
		        } else {
		        	UiComm.showMessage(data.message, "error");
		        }
		    }).fail(function() {
		    	UiComm.showMessage("피드백 등록 중 에러가 발생하였습니다.", "error");
		    });
    	}

    	// 피드백팝업
    	function fdbkViewPopup() {
    		if($(".stu_list_area li[name=ezgTargetUser].active").length != 1){
    			UiComm.showMessage("<spring:message code='resh.alert.select.target' />", "warning");	/* 선택된 대상이 없습니다. */
    			return false;
    		}

    		let target = $(".stu_list_area li[name=ezgTargetUser].active");
    		let smnrId = target.attr("data-smnrid");	// 세미나아이디
    		let userId = target.attr("data-userid");	// 사용자아이디

    		const data = "smnrId="+smnrId+"&userId="+userId;
			dialog = UiDialog("dialog2", {
				title		: "피드백",
				width		: 800,
				height		: 350,
				url			: "/smnr/profSmnrFdbkPopup.do?" + data,
				autoresize	: true
			});
    	}
    </script>

	<body class="class ${uiex:getTheme()}">
        <div id="wrap" class="main">
        	<!-- EZ-Grader 마크업 템플릿 -->
		    <div class="modal_EzGarder_area" style="width: 100%; height: 100%; border-radius: 0;">
		        <h1 class="EzGarder_title">
		            EZ-Grader 쉽고 빠르게 평가
		            <button type="button" class="btn_close" onclick="window.parent.closeDialog();" aria-label="닫기"><i class="xi-close"></i></button>
		        </h1>
		        <div class="EzCarder_content">
		            <div class="left_list">
		                <div class="left_select_box mb10">
		                    <select class="form-select" id="ezgSearchSort" onChange="smnrAtndListSelect()">
		                        <option value="USER_ID"><spring:message code="forum_ezg.label.userid_order" /></option><!-- 학번순 -->
								<option value="USER_NM"><spring:message code="forum_ezg.label.nm_order" /></option><!-- 이름순 -->
								<option value="ATND_DT">참석일순</option>
		                    </select>
		                    <select class="form-select" id="ezgSearchKey" onchange="smnrAtndListSelect()">
		                        <option value="">전체</option>
								<option value="Y">참석</option>
								<option value="N">미참석</option>
		                    </select>
		                </div>
		                <div class="stu_list_area">
		                </div>
		            </div>

		            <div class="center_com width-100per" style="overflow-y: auto">
			            <div id="atndDiv"></div>
		            </div>

		            <div class="right_app">
						<div class="right_top_score">
	                        <label for="atndEvlScr"><input type="text" id="atndEvlScr" inputmask="numeric" maxVal="100" mask="999.99" placeholder="점수"></label>
	                        <button type="button" class="btn small type3" onclick="submitScore()">저장</button>
	                        <button type="button" class="btn small type2" onclick="$('#atndEvlScr').val('')">초기화</button>
	                    </div>
	                    <div class="right_memo">
	                    	<button class="btn basic width-100per" onclick="fdbkViewPopup()">피드백</button>
	                    	<div class="memoBox">
	                    		<label for="fdbkCts"><textarea id="fdbkCts"></textarea></label>
	                            <button type="button" class="btn small type3 width-100per" onclick="submitFdbk()">저장</button>
	                    	</div>
	                        <div class="memoBox">
	                            <label for="profMemo"><textarea id="profMemo"></textarea></label>
	                            <button type="button" class="btn small type3 width-100per" onclick="submitMemo()">저장</button>
	                        </div>
	                    </div>
		            </div>
		        </div>
		    </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
