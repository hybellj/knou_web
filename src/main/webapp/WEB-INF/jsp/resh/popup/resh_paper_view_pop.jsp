<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    </head>
    
    <script type="text/javascript">
    	$(document).ready(function(){
    	});
    </script>
    
    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
        	<c:forEach var="pageList" items="${listReschPage }">
	        	<div class="reschPageDiv" data-pageCd="${pageList.reschPageCd }" data-pageOdr="${pageList.reschPageOdr }" style="pointer-events:none;">
		            <h2 class="page-title tc">${pageList.reschPageOdr }. ${fn:escapeXml(pageList.reschPageTitle) }</h2>
		            <div class="ui small message bcWhite fcBlack">
		            	<pre>${pageList.reschPageArtl }</pre>
		            </div>
					<hr/>
		            <div class="ui form mt10 qstnList">
		            	<c:forEach var="qstnList" items="${pageList.reschQstnList }">
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
											                    <input type="checkbox" onchange="etcOpinionChk('${qstnItem.reschQstnCd }')" id="${qstnItem.reschQstnItemCd }" value="${qstnItem.reschQstnItemTitle eq 'SINGLE_ETC_ITEM' ? 'ETC' : fn:escapeXml(qstnItem.reschQstnItemCd) }" name="qstnItem_${qstnItem.reschQstnCd }" tabindex="0" class="hidden"
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
		                    			<pre class="ui segment" id="qstnEtc_${qstnList.reschQstnCd }">${textAnswer }</pre>
				                    </c:if>
				                    <c:if test="${qstnList.reschQstnTypeCd eq 'SCALE' }">
				                    	<table class="table">
					                    	<thead>
					                    		<tr>
					                    			<th><span class="pl10"><spring:message code="resh.label.item" /></span></th><!-- 문항 -->
					                    			<c:forEach var="scaleQstnList" items="${qstnList.reschScaleList }">
					                    				<th class="tc">${fn:escapeXml(scaleQstnList.scaleTitle) }</th>
					                    			</c:forEach>
					                    		</tr>
					                    	</thead>
					                    	<tbody>
					                    		<c:forEach var="qstnItem" items="${qstnList.reschQstnItemList }">
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
					                    						<input type="radio" onchange="checkScale(this)" name="chkScale_${qstnItem.reschQstnItemCd }" value="${qstnItem.reschQstnItemCd }|${scaleQstnList.reschScaleCd }" <c:if test="${scaleQstnList.reschScaleCd eq answerReschScaleCd}">checked</c:if> />
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
                <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="resh.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
