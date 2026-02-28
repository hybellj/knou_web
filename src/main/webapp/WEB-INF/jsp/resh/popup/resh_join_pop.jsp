<%@page import="knou.framework.common.SessionInfo"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    </head>
    
    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	
	<script type="text/javascript">
		$(document).ready(function() {
			$(".reschPageDiv[data-pageOdr=1]").addClass("show");
			pageButtonChg();
		});
		
		// 페이지 이동 버튼 변경
		function pageButtonChg() {
			var pageLength = "${fn:length(listReschPage)}";
			var nowPage    = $(".show").attr("data-pageOdr");
			
			if(pageLength == 1) {
				$(".nextBtn").css("display", "none");
				$(".prevBtn").css("display", "none");
				$(".saveBtn").css("display", "inline-block");
			} else if(nowPage == pageLength) {
				$(".nextBtn").css("display", "none");
				$(".prevBtn").css("display", "inline-block");
				$(".saveBtn").css("display", "inline-block");
			} else if(nowPage == 1) {
				$(".nextBtn").css("display", "inline-block");
				$(".prevBtn").css("display", "none");
				$(".saveBtn").css("display", "none");
			} else if(nowPage != 1 && nowPage != pageLength) {
				$(".nextBtn").css("display", "inline-block");
				$(".prevBtn").css("display", "inline-block");
				$(".saveBtn").css("display", "none");
			}
		}
		
		// 이전 페이지로
		function goPrevPage() {
			var prevPage = parseInt($(".show").attr("data-pageOdr")) - 1;
			if($(".show").attr("data-prevPageOdr") != null && $(".show").attr("data-prevPageOdr") != undefined) {
				prevPage = $(".show").attr("data-prevPageOdr");
			}
			$(".reschPageDiv").removeClass("show");
			$(".reschPageDiv[data-pageOdr=" + prevPage + "]").addClass("show");
			pageButtonChg();
		}
		
		// 다음 페이지로
		function goNextPage() {
			var curPageObj   = $("div.reschPageDiv:visible");
			var curPageOdr   = curPageObj.attr("data-pageOdr");
			var jumpPageType = "NEXT";
			if(!validateChkMoveNextPage()) {
				return;
			}
			
			// 분기문항 검사
			if(curPageObj.find("div.reshQstn[data-jumpChoiceYn=Y]").length) {
				var jumpPage = curPageObj.find('div.reshQstn[data-jumpChoiceYn=Y]').find("input[name^=qstnItem]:checked").attr("data-jumpPage");
				if(jumpPage != null && jumpPage != undefined) {
					jumpPageType = jumpPage;
				}
			}
			
			// 특정 페이지 이동
			if(jumpPageType != "NEXT" && jumpPageType != "END") {
				$(".reschPageDiv").removeClass("show");
				$(".reschPageDiv[data-pageCd=" + jumpPageType + "]").addClass("show");
				$(".reschPageDiv.show").attr("data-prevPageOdr", curPageOdr);
				pageButtonChg();
			}
			
			// 다음 페이지 이동
			if(jumpPageType == "NEXT") {
				var nextPage = parseInt($(".show").attr("data-pageOdr")) + 1;
				$(".reschPageDiv").removeClass("show");
				$(".reschPageDiv[data-pageOdr=" + nextPage + "]").addClass("show");
				pageButtonChg();
			}
			
			// 설문 제출
			if(jumpPageType == "END") {
				saveResh();
			}
			
			return;
		}
		
		// 설문 제출
		function saveResh() {
			if(!validateChkMoveNextPage()) {
				return;
			}
			
			$("div.reschPageDiv").each(function(i) {
				$(this).find("div.reshQstn").each(function(ii) {
					var reschQstnTypeCd = $(this).attr("data-qstnTypeCd");
					
					if(reschQstnTypeCd == "SINGLE" || reschQstnTypeCd == "OX") {
						if($(this).find("input[name^=qstnItem]:checked").length > 0) {
							$("#reshJoinForm").append("<input type='hidden' name='reshQstnCdList' value='" + $(this).attr("data-qstnCd") + "' />");
	                        $("#reshJoinForm").append("<input type='hidden' name='etcOpinionList' value='" + $(this).find("input[name^=qstnEtc]").val() + "' />");
	                        $("#reshJoinForm").append("<input type='hidden' name='reshAnswerList' value='" + $(this).find("input[name^=qstnItem]:checked").val() + "' />");
						}
					}
					
					if(reschQstnTypeCd == "MULTI") {
						if($(this).find("input[name^=qstnItem]:checked").length > 0) {
							var answer = "";
							$(this).find("input[name^=qstnItem]:checked").each(function(iii) {
								if(iii > 0) {
									answer += ",";
								}
								answer += $(this).val();
							});
							$("#reshJoinForm").append("<input type='hidden' name='reshQstnCdList' value='" + $(this).attr("data-qstnCd") + "' />");
	                        $("#reshJoinForm").append("<input type='hidden' name='etcOpinionList' value='" + $(this).find("input[name^=qstnEtc]").val() + "' />");
	                        $("#reshJoinForm").append("<input type='hidden' name='reshAnswerList' value='" + answer + "' />");
						}
					}
					
					if(reschQstnTypeCd == "SCALE") {
						var answer = "";
						$(this).find("input[name^=qstnItem][value != '']").each(function(iii) {
							if(iii > 0) {
								answer += ",";
							}
							answer += $(this).val();
						});
						
						if(answer != "") {
							$("#reshJoinForm").append("<input type='hidden' name='reshQstnCdList' value='" + $(this).attr("data-qstnCd") + "' />");
	                        $("#reshJoinForm").append("<input type='hidden' name='etcOpinionList' value='' />");
	                        $("#reshJoinForm").append("<input type='hidden' name='reshAnswerList' value='" + answer + "' />");
						}
					}
					
					if(reschQstnTypeCd == "TEXT") {
						if ($.trim($(this).find("textarea[name^=qstnEtc]").val()) != '') {
							var qstnEtc = $(this).find("textarea[name^=qstnEtc]").val();
	                        $("#reshJoinForm").append("<input type='hidden' name='reshQstnCdList' value='" + $(this).attr("data-qstnCd") + "' />");
	                        $("#reshJoinForm").append("<input type='hidden' name='etcOpinionList' id='etcOpinion_"+ii+"' />");
	                        $("#reshJoinForm").append("<input type='hidden' name='reshAnswerList' value='' />");
	                        $("#etcOpinion_"+ii).val(qstnEtc);
	                    }
					}
				});
			});
			
			var reschTypeCd = "${vo.reschTypeCd}";
			var url;
			
			// 강의평가, 만족도평가
			if(reschTypeCd == "EVAL" || reschTypeCd == "LEVEL") {
				url = "/resh/evalReshJoin.do";
				$("#reshJoinForm").append("<input type='hidden' name='reschTypeCd' value='" + reschTypeCd + "' />");
			} else {
				url = "/resh/reshJoin.do";
			}
			
			var confirm = window.confirm("<spring:message code='resh.confirm.resh.join.complete' />");/* 설문 참여를 완료하였습니다. 제출하시겠습니까? */
			if(confirm) {
				showLoading();
				$.ajax({
		            url      : url,
		            type     : "post",
		            async    : false,
		            dataType : "json",
		            data     : $("#reshJoinForm").serialize(),
		        }).done(function(data) {
		        	hideLoading();
		        	if (data.result > 0) {
		        		if(typeof window.parent.saveReschCallback === "function") {
		        			window.parent.saveReschCallback({
		        				  reschCd: $("#reshJoinForm > input[name='reschCd']").val()
		        				, userId: $("#reshJoinForm > input[name='userId']").val()
		        				, stdNo: $("#reshJoinForm > input[name='stdNo']").val()
		        			});
		        		} else {
		        			if("${vo.searchKey}" == "list") {
			        			window.parent.listResh(1);
			        			window.parent.closeModal();
			        		} else if("${vo.searchKey}" == "view") {
			        			window.parent.closeModal();
			        			window.parent.document.location.reload();
			        		}
		        		}
		            } else {
		             	alert(data.message);
		            }
		        }).fail(function() {
		        	hideLoading();
		        	alert("<spring:message code='resh.error.join.save' />");/* 설문 참여 응답 저장중 에러가 발생하였습니다. */
		        });
			}
		}
		
		// 기타 항목 체크
		function etcOpinionChk(reschQstnCd) {
			var isEtc = true;
			$("input[name='qstnItem_"+reschQstnCd+"']:checked").each(function(i) {
				if(this.value == "ETC") {
					isEtc = false;
				}
			})
			$("input[name='qstnEtc_"+reschQstnCd+"']").attr("readonly", isEtc);
		}
		
		// 필수 항목 선택 유효성 검사
		function validateChkMoveNextPage() {
			var curPageObj = $("div.reschPageDiv.show");
	        var qstns      = curPageObj.find('div.reshQstn');
	        var isValid    = true;
	        
	        qstns.each(function(idx) {
	        	if($(this).attr("data-reqChoiceYn") == "Y") {
		        	var reschQstnTypeCd = $(this).attr("data-qstnTypeCd");
		        	
		        	if(reschQstnTypeCd == "SINGLE" || reschQstnTypeCd == "MULTI" || reschQstnTypeCd == "OX") {
		        		if ($(this).find("input[name^=qstnItem]:checked").length == 0) {
		        			alert($(this).attr("data-qstnOdr") + "<spring:message code='resh.alert.no.answer' />");/* 번 문항에 응답하지 않았습니다. */
		        			isValid = false;
		        			return false;
		        		}
		        	}
		        	
		        	if(reschQstnTypeCd == "SCALE") {
		        		if($(this).find("input[name^=qstnItem][value='']").length > 0) {
		        			alert($(this).attr("data-qstnOdr") + "<spring:message code='resh.alert.item.no.answer' />");/* 번 문항에 응답하지 않은 항목이 있습니다. */
		        			isValid = false;
		        			return false;
		        		}
		        	}
		        	
		        	if(reschQstnTypeCd == "TEXT") {
		        		if($.trim($(this).find("textarea[name^=qstnEtc]").val()) == '') {
		        			alert($(this).attr("data-qstnOdr") + "<spring:message code='resh.alert.no.answer' />");/* 번 문항에 응답하지 않았습니다. */
		        			isValid = false;
		        			return false;
		        		}
		        	}
	        	}
	        	
	        	if ($(this).find("input[name^=qstnItem][value=ETC]:checked").length > 0) {
	                if ( $.trim($(this).find("input[name^=qstnEtc]").val()) == '' ) {
	                	alert($(this).attr("data-qstnOdr") + "<spring:message code='resh.alert.input.etc' />");/* 번 문항 기타의견을 입력하세요. */
	                	isValid = false;
	                    return false;
	                }
	            }
	        })
	        
	        return isValid;
		}
		
		// 척도형 문항 체크
		function checkScale(obj) {
			$(obj).closest('tr').find("input:hidden[name^=qstnItem]").val($(obj).val());
		}
	</script>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
		<form name="reshJoinForm" id="reshJoinForm">
			<input type="hidden" name="reschCd" value="${vo.reschCd }" />
			<input type="hidden" name="userId"  value="${vo.userId }" />
			<input type="hidden" name="stdNo"   value="${vo.stdNo }" />
			<input type="hidden" name="crsCreCd"value="${crsCreCd}" />
		</form>
        <div id="wrap">
        	<c:forEach var="pageList" items="${listReschPage }">
	        	<div class="reschPageDiv" data-pageCd="${pageList.reschPageCd }" data-pageOdr="${pageList.reschPageOdr }" style="display:none;">
		            <h2 class="page-title tc">${pageList.reschPageOdr }. ${fn:escapeXml(pageList.reschPageTitle) }</h2>
		            <div class="ui small message bcWhite bcBlack">
		           		<pre>${pageList.reschPageArtl }</pre>
		            </div>
					<hr/>
		            <div class="ui form mt10 qstnList">
		            	<c:forEach var="qstnList" items="${pageList.reschQstnList }" varStatus="varStatus">
		            		<div class="ui card wmax reshQstn qstnDiv" data-reqChoiceYn="${qstnList.reqChoiceYn }" data-qstnTypeCd="${qstnList.reschQstnTypeCd }" data-jumpChoiceYn="${qstnList.jumpChoiceYn }" data-qstnCd="${qstnList.reschQstnCd }" data-qstnOdr="${qstnList.reschQstnOdr }">
			                    <div class="fields content header2">
			                        <div class="field wf100">
			                            <span>${pageList.reschPageOdr }-${qstnList.reschQstnOdr }</span>
			                        </div>
			                    </div>
			                    <div class="content">
			                    	<div class="bcWhite fcBlack p10"><pre>${qstnList.reschQstnCts }</pre></div>
			                    	<div class="ui divider"></div>
				                    <c:if test="${qstnList.reschQstnTypeCd eq 'SINGLE' }">
				                    	<ul class="tbl-simple">
				                    		<c:forEach var="qstnItem" items="${qstnList.reschQstnItemList }">
				                    			<!-- 설문 수정 - 문항의 답변 가져오기 -->
				                    			<c:set var="answerQstnItemCd" value="" />
				                    			<c:set var="textAnswer" value="" />
				                    			<c:forEach var="answerInfo" items="${answerList}">
				                    				<c:if test="${answerInfo.reschQstnCd eq qstnItem.reschQstnCd && (answerInfo.reschQstnItemCd eq qstnItem.reschQstnItemCd || (answerInfo.reschQstnItemCd eq 'ETC' && qstnItem.reschQstnItemTitle eq 'SINGLE_ETC_ITEM'))}">
				                    					<c:set var="answerQstnItemCd" value="${answerInfo.reschQstnItemCd}" />
				                    					<c:set var="textAnswer" value="${fn:escapeXml(answerInfo.reschQstnItemTitle)}" />
				                    				</c:if>
				                    			</c:forEach>
						                    	<li class="pt0">
						                    		<dl>
						                    			<dt ${qstnList.etcOpinionYn ne 'Y' || qstnItem.reschQstnItemTitle ne 'SINGLE_ETC_ITEM' ? 'class="p_w100"' : '' }>
										                    <div class="ui radio checkbox">
											                    <input type="radio" onchange="etcOpinionChk('${qstnItem.reschQstnCd }')" id="${qstnItem.reschQstnItemCd }" 
											                    	value="${qstnItem.reschQstnItemTitle eq 'SINGLE_ETC_ITEM' ? 'ETC' : qstnItem.reschQstnItemCd }" name="qstnItem_${qstnItem.reschQstnCd }" tabindex="0" class="hidden"
											                    	data-jumpPage="${qstnItem.jumpPage }" <c:if test="${qstnItem.reschQstnItemCd eq answerQstnItemCd || answerQstnItemCd eq 'ETC'}">checked</c:if> />
												                    <label for="${qstnItem.reschQstnItemCd }">
													                    <c:choose>
																		    <c:when test="${qstnItem.reschQstnItemTitle eq 'SINGLE_ETC_ITEM'}">
																		        <spring:message code="resh.label.etc" />
																		    </c:when>
																		    <c:otherwise>
																		        ${fn:escapeXml(qstnItem.reschQstnItemTitle)}
																		    </c:otherwise>
																		</c:choose>
																	</label>
											                </div>
						                    			</dt>
						                    			<dd>
						                    				<c:if test="${qstnList.etcOpinionYn eq 'Y' && qstnItem.reschQstnItemTitle eq 'SINGLE_ETC_ITEM' }">
						                    					<label for="ETC_${qstnItem.reschQstnItemCd }" class="hide">ETC</label>
							                    				<input type="text" name="qstnEtc_${qstnItem.reschQstnCd }" id="ETC_${qstnItem.reschQstnItemCd }" readonly="readonly" value="${textAnswer }" />
						                    				</c:if>
						                    			</dd>
						                    		</dl>
						                    	</li>
				                    		</c:forEach>
					                    </ul>
				                    </c:if>
				                    <c:if test="${qstnList.reschQstnTypeCd eq 'MULTI' }">
				                    	<ul class="tbl-simple">
				                    		<c:forEach var="qstnItem" items="${qstnList.reschQstnItemList }">
				                    			<!-- 설문 수정 - 문항의 답변 가져오기 -->
				                    			<c:set var="answerQstnItemCd" value="" />
				                    			<c:set var="textAnswer" value="" />
				                    			<c:forEach var="answerInfo" items="${answerList}">
				                    				<c:if test="${answerInfo.reschQstnCd eq qstnItem.reschQstnCd && (answerInfo.reschQstnItemCd eq qstnItem.reschQstnItemCd || (answerInfo.reschQstnItemCd eq 'ETC' && qstnItem.reschQstnItemTitle eq 'SINGLE_ETC_ITEM'))}">
				                    					<c:set var="answerQstnItemCd" value="${answerInfo.reschQstnItemCd}" />
				                    					<c:set var="textAnswer" value="${fn:escapeXml(answerInfo.reschQstnItemTitle)}" />
				                    				</c:if>
				                    			</c:forEach>
						                    	<li class="pt0">
						                    		<dl>
						                    			<dt ${qstnList.etcOpinionYn ne 'Y' || qstnItem.reschQstnItemTitle ne 'SINGLE_ETC_ITEM' ? 'class="p_w100"' : '' }>
										                    <div class="ui checkbox">
											                    <input type="checkbox" onchange="etcOpinionChk('${qstnItem.reschQstnCd }')" id="${qstnItem.reschQstnItemCd }" value="${qstnItem.reschQstnItemTitle eq 'SINGLE_ETC_ITEM' ? 'ETC' : qstnItem.reschQstnItemCd }" name="qstnItem_${qstnItem.reschQstnCd }" tabindex="0" class="hidden"
											                    	<c:if test="${qstnItem.reschQstnItemCd eq answerQstnItemCd || answerQstnItemCd eq 'ETC'}">checked</c:if> />
													                <label for="${qstnItem.reschQstnItemCd }">
																		<c:choose>
																		    <c:when test="${qstnItem.reschQstnItemTitle eq 'SINGLE_ETC_ITEM'}">
																		        <spring:message code="resh.label.etc" />
																		    </c:when>
																		    <c:otherwise>
																		        ${fn:escapeXml(qstnItem.reschQstnItemTitle)}
																		    </c:otherwise>
																		</c:choose>
													                </label>
											                </div>
						                    			</dt>
						                    			<dd>
						                    				<c:if test="${qstnList.etcOpinionYn eq 'Y' && qstnItem.reschQstnItemTitle eq 'SINGLE_ETC_ITEM' }">
						                    					<label for="ETC_${qstnItem.reschQstnItemCd }" class="hide">ETC</label>
							                    				<input type="text" name="qstnEtc_${qstnItem.reschQstnCd }" id="ETC_${qstnItem.reschQstnItemCd }" readonly="readonly" value="${textAnswer}" />
						                    				</c:if>
						                    			</dd>
						                    		</dl>
						                    	</li>
				                    		</c:forEach>
					                    </ul>
				                    </c:if>
				                    <c:if test="${qstnList.reschQstnTypeCd eq 'OX' }">
				                    	<c:forEach var="qstnItem" items="${qstnList.reschQstnItemList }">
				                    		<!-- 설문 수정 - 문항의 답변 가져오기 -->
			                    			<c:set var="answerReschQstnItemTitle" value="" />
			                    			<c:forEach var="answerInfo" items="${answerList}">
			                    				<c:if test="${answerInfo.reschQstnCd eq qstnItem.reschQstnCd and answerInfo.reschQstnItemCd eq qstnItem.reschQstnItemCd}">
			                    					<c:set var="answerReschQstnItemTitle" value="${qstnItem.reschQstnItemTitle}" />
			                    				</c:if>
			                    			</c:forEach>
				                    		<div class="mr15 w150 d-inline-block ui card">
				                    			<div class="checkImg">
						                    		<c:if test="${qstnItem.reschQstnItemTitle eq 'O' }">
						                    			<input id="${qstnItem.reschQstnItemCd }_true" name="qstnItem_${qstnItem.reschQstnCd }" type="radio" value="${qstnItem.reschQstnItemCd }" data-jumpPage="${qstnItem.jumpPage }"
						                    				<c:if test="${answerReschQstnItemTitle eq 'O'}">checked</c:if>
						                    			/>
								                		<label class="imgChk true" for="${qstnItem.reschQstnItemCd }_true"></label>
						                    		</c:if>
						                    		<c:if test="${qstnItem.reschQstnItemTitle eq 'X' }">
						                    			<input id="${qstnItem.reschQstnItemCd }_false" name="qstnItem_${qstnItem.reschQstnCd }" type="radio" value="${qstnItem.reschQstnItemCd }" data-jumpPage="${qstnItem.jumpPage }"
						                    				<c:if test="${answerReschQstnItemTitle eq 'X'}">checked</c:if>
						                    			/>
								                		<label class="imgChk false" for="${qstnItem.reschQstnItemCd }_false"></label>
						                    		</c:if>
					                    		</div>
					                    	</div>
				                    	</c:forEach>
				                    </c:if>
				                    <c:if test="${qstnList.reschQstnTypeCd eq 'TEXT' }">
				                    	<!-- 설문 수정 - 문항의 답변 가져오기 -->
				                    	<c:set var="textAnswer" value="" />
		                    			<c:forEach var="answerInfo" items="${answerList}">
		                    				<c:if test="${answerInfo.reschQstnCd eq qstnList.reschQstnCd}">
		                    					<c:set var="textAnswer" value="${fn:escapeXml(answerInfo.reschQstnItemTitle)}" />
		                    				</c:if>
		                    			</c:forEach>
		                    			<label for="qs_${varStatus.count}" class="hide">TEXT</label>
		                    			<textarea id="qs_${varStatus.count}" name="qstnEtc_${qstnList.reschQstnCd }">${textAnswer}</textarea>
				                    </c:if>
				                    <c:if test="${qstnList.reschQstnTypeCd eq 'SCALE' }">
				                    	<table class="table">
					                    	<thead>
					                    		<tr>
					                    			<th><span class="pl10"><spring:message code="resh.label.item" /></span></th><!-- 문항 -->
					                    			<c:forEach var="scaleQstnList" items="${qstnList.reschScaleList }">
					                    				<th class="tc">${scaleQstnList.scaleTitle }</th>
					                    			</c:forEach>
					                    		</tr>
					                    	</thead>
					                    	<tbody>
					                    		<c:forEach var="qstnItem" items="${qstnList.reschQstnItemList }" varStatus="idx" >
					                    			<!-- 설문 수정 - 문항의 답변 가져오기 -->
					                    			<c:set var="answerReschScaleCd" value="" />
					                    			<c:set var="answerReschScaleValue" value="" />
					                    			<c:forEach var="answerInfo" items="${answerList}">
					                    				<c:if test="${answerInfo.reschQstnCd eq qstnItem.reschQstnCd and answerInfo.reschQstnItemCd eq qstnItem.reschQstnItemCd}">
					                    					<c:set var="answerReschScaleCd" value="${answerInfo.reschScaleCd}" />
					                    					<c:set var="answerReschScaleValue" value="${answerInfo.reschQstnItemCd}|${answerInfo.reschScaleCd}" />
					                    				</c:if>
					                    			</c:forEach>
					                    			<tr>
					                    				<td class="tl">
					                    					${fn:escapeXml(qstnItem.reschQstnItemTitle) }
					                    					<input type="hidden" name="qstnItem_${qstnItem.reschQstnCd }" value="${answerReschScaleValue}" />
					                    				</td>
					                    				<c:forEach var="scaleQstnList" items="${qstnList.reschScaleList }">
					                    					<td class="tc">
					                    						<label for="qs_${varStatus.count}_${idx.count}" class="hide">answer</label>
					                    						<input id="qs_${varStatus.count}_${idx.count}" type="radio" onchange="checkScale(this)" name="chkScale_${qstnItem.reschQstnItemCd }" value="${qstnItem.reschQstnItemCd }|${scaleQstnList.reschScaleCd }" <c:if test="${scaleQstnList.reschScaleCd eq answerReschScaleCd}">checked</c:if> />
				                    						</td>
					                    				</c:forEach>
					                    			</tr>
					                    		</c:forEach>
					                    	</tbody>
					                    </table>
				                    </c:if>
			                    </div>
			                </div>
		            	</c:forEach>
		            </div>
	        	</div>
        	</c:forEach>
            
            <div class="bottom-content">
                <button class="ui blue button prevBtn" onclick="goPrevPage()"><spring:message code="resh.button.prev" /></button><!-- 이전 -->
                <button class="ui blue button nextBtn" onclick="goNextPage()"><spring:message code="resh.button.next" /></button><!-- 다음 -->
                <button class="ui blue button saveBtn" onclick="saveResh()"><spring:message code="resh.button.submit" /></button><!-- 제출하기 -->
                <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="resh.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
