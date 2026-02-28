<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    </head>
    
    <script type="text/javascript">
    	$(document).ready(function() {
    		listReshUser();
    		
    		// 설문 이전, 다음 버튼 이벤트 (E : 이전, D : 다음)
    		$(document).on("keyup", function(e) {
    			if(!(document.activeElement.tagName === "INPUT" || document.activeElement.tagName === "TEXTAREA")) {
    				if($("#rubric_card > a[name=ezgTargetUser].card.active-toggle-btn.select").length > 0) {
    		    		if(e.keyCode == 68) {
    		    			btnNext();
    		    		} else if(e.keyCode == 69) {
    		    			btnPrev();
    		    		}
    				}
    			}
    		});
    	});
    	
    	// 학습자 목록
    	function listReshUser() {
    		var url  = "/resh/ezg/listReshUser.do";
    		var data = {
    			"reschCd"    : "${vo.reschCd}",
    			"searchSort" : $("#ezgSearchSort").val(),
    			"searchKey"  : $("#ezgSearchKey").val()
    		};
    		
    		ajaxCall(url, data, function(data) {
    			if (data.result > 0) {
    				var returnList = data.returnList || [];
    				var html = "";
    				
    				if(returnList.length > 0) {
    					returnList.forEach(function(v, i) {
    						var profMemo = v.profMemo != undefined ? v.profMemo : "";
    						var regDttm = v.regDttm != undefined ? v.regDttm.substring(0,4)+"."+v.regDttm.substring(4,6)+"."+v.regDttm.substring(6,8)+" "+v.regDttm.substring(8,10)+":"+v.regDttm.substring(10,12) : "";
    						var selectClass = $(".card.active-toggle-btn.select").attr("data-userid") == v.userId ? "select" : "";
	    					html += "<a href='javascript:;' onclick='selectUser(this)' name='ezgTargetUser' data-dttm='"+regDttm+"' data-memo='"+profMemo+"' data-score='"+v.score+"' data-userid='"+v.userId+"' data-usernm='"+v.userNm+"' data-stdno='"+v.stdNo+"' data-deptnm='"+v.deptNm+"' class='card active-toggle-btn "+selectClass+"'>";
		        			html += "	<div class='content stu_card'>";
		        			html += "		<div class='icon_box'></div>";
		        			html += "		<div class='text_box'>";
		        			html += "			<div class='meta'>"+v.deptNm+"</div>";
		        			html += "			<div class='user'><span>"+v.userNm+" ("+v.userId+")</span></div>";
		        			html += "		</div>";
		        			html += "	</div>";
		        			html += "</a>";
    					});
    				}
    				
	        		$("#rubric_card").empty().html(html);
                } else {
                 	alert(data.message);
                }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='resh.error.list' />");/* 설문 리스트 조회 중 에러가 발생하였습니다. */
    		});
    	}
    	
    	// 학습자 선택
    	function selectUser(obj) {
    		$("#noSelectUserBlock").hide();
    		$("#totalScore").val($(obj).attr("data-score"));
    		$("#profMemo").val($(obj).attr("data-memo"));
    		$("#userInfoDiv .fields.eleven.field").eq(0).text($(obj).attr("data-usernm"));
    		$("#userInfoDiv .fields.eleven.field").eq(1).text($(obj).attr("data-deptnm"));
    		$("#userInfoDiv .fields.eleven.field").eq(2).text($(obj).attr("data-dttm"));
    		$("#userInfoDiv").show();
    		$('.active-toggle-btn').removeClass("select");
            $(obj).addClass("select");
            
            listReshQstn($(obj).attr("data-userid"), $(obj).attr("data-stdno"));
    	}
    	
    	// 설문지 목록
    	function listReshQstn(userId, stdNo) {
    		var url  = "/resh/ezg/listReshAnswer.do";
    		var data = {
	    		"reschCd" 	: "${vo.reschCd}",
				"searchKey" : "list",
				"userId" 	: userId,
				"stdNo" 	: stdNo
    		};
    		
    		ajaxCall(url, data, function(data) {
    			if (data.result > 0) {
            		var html = "";
            		if(data.returnVO.answerList.length == 0) {
            			html += "<div class='flex-container'>";
            			html += "	<div class='cont-none'>";
            			html += "		<span><spring:message code='common.content.not_found' /></span>";/* 등록된 내용이 없습니다. */
            			html += "	</div>";
            			html += "</div>";
            		} else {
	            		data.returnList.forEach(function(v, i) {
	            			html += "<div class='reschPageDiv' style='pointer-events:none;'>";
	            			html += "	<h2 class='page-title tc'>"+v.reschPageOdr+". "+v.reschPageTitle+"</h2>";
	            			html += "	<pre>"+v.reschPageArtl+"</pre>";
	            			html += "	<hr/>";
	            			html += "	<div class='ui form mt10 qstnList'>";
	            			v.reschQstnList.forEach(function(vv, ii) {
	            			html += "		<div class='ui card wmax reshQstn qstnDiv'>";
	            			html += "			<div class='fields content header2'>";
	            			html += "				<div class='field wf100'>";
	            			html += "					<span>"+v.reschPageOdr+"-"+vv.reschQstnOdr+"</span>";
	            			html += "				</div>";
	            			html += "			</div>";
	            			html += "			<div class='content'>";
	            			html += "				<pre>"+vv.reschQstnCts+"</pre>";
	            			html += "				<div class='ui divider'></div>";
	            								if(vv.reschQstnTypeCd == "SINGLE" || vv.reschQstnTypeCd == "MULTI") {
	            			html += "				<ul class='tbl-simple'>";
	            				vv.reschQstnItemList.forEach(function(vvv, iii) {
	            					var answerQstnItemCd = "";
	            					var textAnswer       = "";
	            					data.returnVO.answerList.forEach(function(vvvv, iiii) {
	            						if(vvvv.reschQstnCd == vvv.reschQstnCd && (vvvv.reschQstnItemCd == vvv.reschQstnItemCd || (vvvv.reschQstnItemCd == "ETC" && vvv.reschQstnItemTitle == "SINGLE_ETC_ITEM"))) {
	            							answerQstnItemCd = vvvv.reschQstnItemCd;
	            							textAnswer = vvvv.reschQstnItemTitle;
	            						}
	            					});
	            					var etc = '<spring:message code="resh.label.etc" />';
	            					var dtClass   = vvv.reschQstnItemTitle != "SINGLE_ETC_ITEM" ? "p_w100" : "";
	            					var labelText = vvv.reschQstnItemTitle == "SINGLE_ETC_ITEM" ? etc : vvv.reschQstnItemTitle;
	            					var itemValue = vvv.reschQstnItemTitle == "SINGLE_ETC_ITEM" ? "ETC" : vvv.reschQstnItemCd;
	            					var isChecked = vvv.reschQstnItemCd == answerQstnItemCd || answerQstnItemCd == "ETC" ? "checked" : "";
	            					var divClass  = vv.reschQstnTypeCd == "SINGLE" ? "radio" : "";
	            					var inputType = vv.reschQstnTypeCd == "SINGLE" ? "radio" : "checkbox";
	            			html += "					<li class='pt0'>";
	            			html += "						<dl>";
	            			html += "							<dt class='"+dtClass+"'>";
	            			html += "								<div class='ui "+divClass+" checkbox'>";
	            			html += "									<input type='"+inputType+"' id='"+vvv.reschQstnItemCd+"' value='"+itemValue+"' name='qstnItem_"+vvv.reschQstnCd+"' tabindex='0' class='hidden' "+isChecked+" />";
	            			html += "									<label for='"+vvv.reschQstnItemCd+"'>"+labelText+"</label>";
	            			html += "								</div>";
	            			html += "							</dt>";
	            			html += "							<dd>";
	            												if(vv.etcOpinionYn == "Y" && vvv.reschQstnItemTitle == "SINGLE_ETC_ITEM") {
	            			html += "								<input type='text' name='qstnEtc_"+vvv.reschQstnCd+"' id='ETC_"+vvv.reschQstnItemCd+"' readonly='readonly' value='"+textAnswer+"' />";
	            												}
	            			html += "							</dd>";
	            			html += "						</dl>";
	            			html += "					</li>";
	            				});
	            			html += "				</ul>";
	            								}
	            								if(vv.reschQstnTypeCd == "OX") {
	            				vv.reschQstnItemList.forEach(function(vvv, iii) {
	            					var answerReschQstnItemTitle = "";
	            					data.returnVO.answerList.forEach(function(vvvv, iiii) {
	            						if(vvvv.reschQstnCd == vvv.reschQstnCd && vvvv.reschQstnItemCd == vvv.reschQstnItemCd) {
	            							answerReschQstnItemTitle = vvv.reschQstnItemTitle;
	            						}
	            					});
	            			html += "				<div class='mr15 w150 d-inline-block ui card'>";
	            			html += "					<div class='checkImg'>";
	            										if(vvv.reschQstnItemTitle == "O") {
	            											var isChecked = answerReschQstnItemTitle == "O" ? "checked" : "";
	            			html += "						<input id='"+vvv.reschQstnItemCd+"_true' name='qstnItem_"+vvv.reschQstnCd+"' type='radio' value='"+vvv.reschQstnItemCd+"' "+isChecked+" />";
	            			html += "						<label class='imgChk true' for='"+vvv.reschQstnItemCd+"_true'></label>";
	            										} else if(vvv.reschQstnItemTitle == "X") {
	            											var isChecked = answerReschQstnItemTitle == "X" ? "checked" : "";
	            			html += "						<input id='"+vvv.reschQstnItemCd+"_false' name='qstnItem_"+vvv.reschQstnCd+"' type='radio' value='"+vvv.reschQstnItemCd+"' "+isChecked+" />";
	            			html += "						<label class='imgChk false' for='"+vvv.reschQstnItemCd+"_false'></label>";
	            										}
	            			html += "					</div>";
	            			html += "				</div>";
	            				});
	            								}
	            								if(vv.reschQstnTypeCd == "TEXT") {
	            									var textAnswer = "";
	            									data.returnVO.answerList.forEach(function(vvv, iii) {
	            										if(vvv.reschQstnCd == vv.reschQstnCd) {
	            											textAnswer = vvv.reschQstnItemTitle;
	            										}
	            									});
	            			html += "				<input type='text' name='qstnEtc_"+vv.reschQstnCd+"' value='"+textAnswer+"'  />";
	            								}
	            								if(vv.reschQstnTypeCd == "SCALE") {
	            			html += "				<table class='table'>";
	            			html += "					<thead>";
	            			html += "						<tr>";
	            			html += "							<th><span class='pl10'><spring:message code='resh.label.item' /></span></th>";/* 문항 */
	            				vv.reschScaleList.forEach(function(vvv, iii) {
	            			html += "							<th class='tc'>"+vvv.scaleTitle+"</th>";
	            				});
	            			html += "						</tr>";
	            			html += "					</thead>";
	            			html += "					<tbody>";
	            				vv.reschQstnItemList.forEach(function(vvv, iii) {
	            					var answerReschScaleCd = "";
	            					var answerReschScaleValue = "";
	            					data.returnVO.answerList.forEach(function(vvvv, iiii ){
	            						if(vvvv.reschQstnCd == vvv.reschQstnCd && vvvv.reschQstnItemCd == vvv.reschQstnItemCd) {
	            							answerReschScaleCd = vvvv.reschScaleCd;
	            							answerReschScaleValue = vvvv.reschQstnItemCd+"|"+vvvv.reschScaleCd;
	            						}
	            					});
	            			html += "						<tr>";
	            			html += "							<td class='tl'>";
	            			html += "								"+vvv.reschQstnItemTitle;
	            			html += "								<input type='hidden' name='qstnItem_"+vvv.reschQstnCd+"' value='"+answerReschScaleValue+"' />";
	            			html += "							</td>";
	            					vv.reschScaleList.forEach(function(vvvv, iiii) {
	            						var isChecked = vvvv.reschScaleCd == answerReschScaleCd ? "checked" : "";
	            			html += "							<td class='tc'>";
	            			html += "								<input type='radio' name='chkScale_"+vvv.reschQstnItemCd+"' value='"+vvv.reschQstnItemCd+"|"+vvvv.reschScaleCd+"' "+isChecked+" />";
	            			html += "							</td>";
	            					});
	            			html += "						</tr>";
	            				});
	            			html += "					</tbody>";
	            			html += "				</table>";
	            								}
	            			html += "			</div>";
	            			html += "		</div>";
	            			});
	            			html += "	</div>";
	            			html += "</div>";
	            		});
            		}
            		$("#reshPaperBlock").empty().append(html);
            		$(".table").footable();
            		$('.stu-list-box, .info-section').css('height', $('.chat-viewer').height());
                } else {
                 	alert(data.message);
                }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='resh.error.list' />");/* 설문 리스트 조회 중 에러가 발생하였습니다. */
    		});
    	}
    	
    	// 이전 버튼
    	function btnPrev() {
    		var stdNo = $("a[name=ezgTargetUser].select").last().prev().data("stdno");
    		var teamCd = $("a[name=ezgTargetUser].select").first().prev().data("teamcd");
    		if(stdNo === undefined) {
    			var stdNo = $("a[name=ezgTargetUser].select").last().prev().prev().data("stdno");
    		}
    		$("a[data-stdNo="+ stdNo+"]").click();
    		stdNo = "";
    	};

    	// 다음 버튼
    	function btnNext() {
    		var stdNo = $("a[name=ezgTargetUser].select").last().next().data("stdno");
    		var teamCd = $("a[name=ezgTargetUser].select").last().next().data("teamcd");
    		if(stdNo === undefined) {
    			var stdNo = $("a[name=ezgTargetUser].select").last().next().next().data("stdno");
    		}
    		$("a[data-stdNo="+ stdNo+"]").click();
    		stdNo = "";
    	};
    	
    	// 점수 저장
    	function submitScore() {

    		if($('.active-toggle-btn.select').length < 1){
    			alert("<spring:message code='resh.alert.select.target' />");/* 선택된 대상이 없습니다. */
    			return false;
    		}

    		var score = $("#totalScore").val();

    		// 점수 입력
    		if(score == "" || score == undefined){
    			alert("<spring:message code='resh.label.input.score' />");/* 점수를 입력하세요. */
    			return false;
    		}

    		if(score > 100 ){
    			alert("<spring:message code='resh.alert.score.max.100' />");/* 점수는 100점 까지 입력 가능 합니다. */
    			return false;
    		}

    		var userId = $(".card.active-toggle-btn.select").attr("data-userid");

     		var url = "/resh/updateReshScore.do";
    		var data = {
    			"reschCd"     : "${vo.reschCd}",
    			"crsCreCd"     : "${vo.crsCreCd}",
    			"userIds"  	  : userId,
    			"score"       : score,
    			"scoreType"	  : "batch"
    		};

    		if(confirm("<spring:message code='resh.confirm.save.score' />")){/* 점수를 저장하시겠습니까? */
    			ajaxCall(url, data, function(data) {
    				if (data.result > 0) {
    					alert("<spring:message code='resh.alert.save.score' />");/* 점수 저장이 완료되었습니다. */
    					listReshUser();
    	            } else {
    	             	alert(data.message);
    	            }
    			}, function(xhr, status, error) {
    				alert("<spring:message code='resh.error.save.score' />");/* 점수 저장 중 에러가 발생하였습니다. */
    			});
    		}
    	}
    	
    	// 메모 등록
    	function submitMemo() {
    		if($('.active-toggle-btn.select').length < 1){
    			alert("<spring:message code='resh.alert.select.target' />");/* 선택된 대상이 없습니다. */
    			return false;
    		}
    		
    		var userId = $(".card.active-toggle-btn.select").attr("data-userid");
    		var url  = "/resh/editReshProfMemo.do";
			var data = {
				"reschCd"  	: "${vo.reschCd}",
				"userId" 	: userId,
				"crsCreCd" 	: "${vo.crsCreCd}",
				"profMemo"	: $("#profMemo").val()
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					alert("<spring:message code='resh.alert.insert.memo' />");/* 메모 저장이 완료되었습니다. */
					listReshUser();
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='resh.error.memo.insert' />");/* 메모 저장 중 에러가 발생하였습니다. */
			});
    	}
    </script>

	<body class="modal-page EG-grader <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap" class="pusher <%=SessionInfo.getThemeMode(request)%>">
            <div class="header-title EG-type">
				<div class="center-text"><span>${vo.reschTitle }</span></div>
				<div class="flex-section">
					<div class="group-right">
						<a href="javascript:window.parent.window.parent.closeModal();" class="ui button"><spring:message code="resh.button.exit" /></a><!-- 나가기 -->
					</div>
				</div>
			</div>
            <div id="context">
				<div class="ui form">
					<div class="EG-layout">
						<!-- 왼쪽 영역 -->
						<div class="stu-list-box">
							<div class="flex-item gap4 mb10">
								<select class="ui fluid dropdown" id="ezgSearchSort" onChange="listReshUser()">
									<option value=""><spring:message code="forum_ezg.label.sel_order" /></option><!-- 정렬 선택 -->
									<option value="USER_ID"><spring:message code="forum_ezg.label.userid_order" /></option><!-- 학번순 -->
									<option value="USER_NM"><spring:message code="forum_ezg.label.nm_order" /></option><!-- 이름순 -->
									<option value="SUBMIT_DT"><spring:message code="forum_ezg.label.submit_order" /></option><!-- 제출자순 -->
								</select>
								<select class="ui fluid dropdown" id="ezgSearchKey" onChange="listReshUser()">
									<option value="SEL_ALL"><spring:message code="forum_ezg.label.sel_filter" /></option><!-- 필터 선택 -->
									<option value="JOIN"><spring:message code="forum_ezg.label.submit_filter" /></option><!-- 제출자 -->
									<option value="NOTJOIN"><spring:message code="forum_ezg.label.nosubmit_filter" /></option><!-- 미제출자 -->
									<option value="AFTER"><spring:message code="forum.label.period.after" /></option><!-- 지각제출 -->
								</select>
							</div>
							<div class="ui cards" id="rubric_card"></div>
						</div>
						<!-- 왼쪽 영역 -->
	
						<!-- 중앙 영역 -->
						<div class="chat-viewer" >
							<div class="scrollArea" id="reshPaperBlock" ></div>
						</div>
						<!-- 중앙 영역 -->
	
						<!-- 오른쪽 영역 -->
						<div class="info-section">
                        	<div class="scrollArea">
                        		<div class="element" id="noSelectUserBlock">
									<div class="ui small error message">
										<i class="info circle icon"></i>
										<spring:message code="forum_ezg.label.noselect_user" /><!-- 평가 대상자를 선택하시기 바랍니다. -->
									</div>
								</div>
                        	    <!-- 점수 화면 -->
		                        <div class="flex">
		                        	<div class="ui input flex1">
		                        		<input type="text" maxlength="3" placeholder="<spring:message code='resh.label.input.score' />" id="totalScore" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');"><!-- 점수를 입력하세요. -->
		                        	</div >
		                        	<a href="javascript:submitScore();" class="ui blue button m0"><spring:message code="resh.button.save" /><!-- 저장 --></a>
		                        </div>
								<div class="ui bottom attached segment mt10" id="userInfoDiv" style="display:none;">
									<div class="field-list mo-100">
				                        <div class="mb10 flex-item btn_list">
											<button type="button" class="ui basic small button boxShadowNone mra" onclick="btnPrev();"><i class="angle left icon"></i> <spring:message code="resh.button.prev" /><!-- 이전 --></button>
											<button type="button" class="ui basic small button boxShadowNone mla" onclick="btnNext();"><spring:message code="resh.button.next" /><!-- 다음 --> <i class="angle right icon"></i></button>
										</div>
										<div class="fields">
											<div class="ui attached message">
												<div class="fields eleven field"></div>
												<div class="fields eleven field"></div>
												<div class="fields eleven field"></div>
											</div>
										</div>
									</div>
								</div>

								<div id="projFeedbackBlock" class="mt10">
									<textarea id="profMemo" style="height: 200px; max-height: unset;" placeholder="<spring:message code='resh.label.input.memo' />"></textarea><!-- 메모를 입력하세요. -->
									<div class="flex-item mt4">
										<a href="javascript:submitMemo();" class="ui blue button mla"><spring:message code="resh.button.write" /><!-- 등록 --></a>
		    						</div>
								</div>
                        	</div>
                        </div>
						<!-- 오른쪽 영역 -->
					</div>
				</div>
			</div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
