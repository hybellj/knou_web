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
	</script>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
        	<c:forEach var="pageList" items="${listReschPage }">
	        	<div class="ui form mt10">
		            <h2 class="page-title tc">${pageList.reschPageOdr }. ${fn:escapeXml(pageList.reschPageTitle) }</h2>
		            <div class="ui small message bcWhite fcBlack">
			            <pre>${pageList.reschPageArtl }</pre>
		            </div>
					<hr/>
		            <div class="ui form mt10 qstnList">
		            	<c:forEach var="qstnList" items="${pageList.reschQstnList }">
		            		<div class="ui card wmax qstnDiv">
			                    <div class="fields content header2">
			                        <div class="field wf100">
			                            <span>${qstnList.reschPageOdr }-${qstnList.reschQstnOdr }.</span> ${fn:escapeXml(qstnList.reschQstnTitle) }
			                        </div>
			                    </div>
			                    <div class="content">
			                    	<div class="bcWhite fcBlack p10"><pre>${qstnList.reschQstnCts }</pre></div>
			                    	<div class="ui divider"></div>
				                    <c:if test="${qstnList.reschQstnTypeCd eq 'SINGLE' || qstnList.reschQstnTypeCd eq 'MULTI' }">
				                    	<ul class="tbl-simple">
				                    		<c:forEach var="qstnItem" items="${qstnList.reschQstnItemList }">
				                    			<li class="pt0">
						                    		<dl>
						                    			<dt ${qstnList.etcOpinionYn ne 'Y' || qstnItem.reschQstnItemTitle ne 'SINGLE_ETC_ITEM' ? 'class="p_w100"' : '' }>
										                    <div class="ui ${qstnList.reschQstnTypeCd eq 'SINGLE' ? 'radio' : '' } checkbox">
										                        <input type="${qstnList.reschQstnTypeCd eq 'SINGLE' ? 'radio' : 'checkbox' }" onchange="etcOpinionChk('${qstnItem.reschQstnCd }')" value="${qstnItem.reschQstnItemTitle eq 'SINGLE_ETC_ITEM' ? 'ETC' : qstnItem.reschQstnItemCd }"
										                        	   id="${qstnItem.reschQstnItemCd }" name="qstnItem_${qstnList.reschQstnCd }" tabindex="0" class="hidden">
										                        <label for="${qstnItem.reschQstnItemCd }">
																	<c:choose>
																	    <c:when test="${qstnItem.reschQstnItemTitle eq 'SINGLE_ETC_ITEM'}">
																	    	<c:choose>
																	    		<c:when test="${isKnou eq 'true'}">
																	    			<spring:message code="resh.label.etc" />
																	    		</c:when>
																	    		<c:otherwise>
																	    			ETC
																	    		</c:otherwise>
																	    	</c:choose>
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
							                    				<input type="text" name="qstnEtc_${qstnItem.reschQstnCd }" id="ETC_${qstnItem.reschQstnItemCd }" readonly="readonly" />
						                    				</c:if>
						                    			</dd>
						                    		</dl>
						                    	</li>
				                    		</c:forEach>
					                    </ul>
				                    </c:if>
				                    <c:if test="${qstnList.reschQstnTypeCd eq 'OX' }">
				                    	<div class="mr15 w150 d-inline-block ui card">
						                    <div class="checkImg">
								                <input id="qstnOX_true_${qstnList.reschQstnCd }" name="qstnOX_${qstnList.reschQstnCd }" type="radio" value="O">
								                <label class="imgChk true" for="qstnOX_true_${qstnList.reschQstnCd }"></label>
								            </div>
					                    </div>
					                    <div class="w150 d-inline-block ui card">
						                    <div class="checkImg">
								                <input id="qstnOX_false_${qstnList.reschQstnCd }" name="qstnOX_${qstnList.reschQstnCd }" type="radio" value="X">
								                <label class="imgChk false" for="qstnOX_false_${qstnList.reschQstnCd }"></label>
								            </div>
					                    </div>
				                    </c:if>
				                    <c:if test="${qstnList.reschQstnTypeCd eq 'SCALE' }">
				                    	<table class="table">
					                    	<thead>
					                    		<tr>
					                    			<th><span class="pl10"><spring:message code="resh.label.item" /></span></th><!-- 문항 -->
					                    			<c:forEach var="scaleItem" items="${qstnList.reschScaleList }">
					                    				<th class="tc">${fn:escapeXml(scaleItem.scaleTitle) }</th>
					                    			</c:forEach>
					                    		</tr>
					                    	</thead>
					                    	<tbody>
					                    		<c:forEach var="qstnItem" items="${qstnList.reschQstnItemList }">
					                    			<tr>
						                    			<td class="tl">${fn:escapeXml(qstnItem.reschQstnItemTitle) }</td>
						                    			<c:forEach var="scaleItem" items="${qstnList.reschScaleList }">
							                    			<td class="tc"><input type="radio" id="${scaleItem.reschScaleCd }" name="qstnScale_${qstnItem.reschQstnItemCd }" value="${scaleItem.scaleScore }" /></td>
						                    			</c:forEach>
						                    		</tr>
					                    		</c:forEach>
					                    	</tbody>
					                    </table>
				                    </c:if>
				                    <c:if test="${qstnList.reschQstnTypeCd eq 'TEXT' }">
				                    	<textarea name="qstnItem"></textarea>
				                    </c:if>
			                    </div>
			                </div>
		            	</c:forEach>
		            </div>
	        	</div>
        	</c:forEach>

            <div class="bottom-content">
                <button class="ui black cancel button" onclick="window.parent.closeDialog();"><spring:message code="resh.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
