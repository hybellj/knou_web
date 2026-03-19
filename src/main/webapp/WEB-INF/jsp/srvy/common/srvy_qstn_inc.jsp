<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<c:forEach var="srvyppr" items="${srvypprList }">
	<div class="srvypprDiv" data-id="${srvyppr.srvypprId }" data-seqno="${srvyppr.srvySeqno }" ${srvyppr.srvySeqno > 1 ? 'style="display: none;"' : '' }>
		<c:forEach var="qstn" items="${srvyQstnList }">
			<c:if test="${srvyppr.srvypprId eq qstn.srvypprId }">
				<div class="border-1 margin-top-3">
					<div class="board_top border-1 padding-3">
						<span>${srvyppr.srvySeqno }. ${qstn.qstnSeqno } ${qstn.qstnTtl }</span>
					</div>
					<div class="padding-3 margin-top-0">
						<div class="margin-bottom-5">${qstn.qstnCts }</div>
					</div>
					<!-- 단일, 다중선택형 -->
					<c:if test="${qstn.qstnRspnsTycd eq 'ONE_CHC' || qstn.qstnRspnsTycd eq 'MLT_CHC' }">
						<c:forEach var="vwitm" items="${srvyVwitmList }">
							<c:if test="${qstn.srvyQstnId eq vwitm.srvyQstnId }">
								<div class="padding-3 flex-item">
									<span class="custom-input">
										<input type="${qstn.qstnRspnsTycd eq 'MLT_CHC' ? 'checkbox' : 'radio' }" value="${vwitm.vwitmCts }" name="${qstn.srvyQstnId }_chc" id="${qstn.srvyQstnId }_chc_${vwitm.vwitmSeqno}" onclick="etcInptCheck('${qstn.srvyQstnId }')" />
										<label for="${qstn.srvyQstnId }_chc_${vwitm.vwitmSeqno}">${vwitm.vwitmCts eq 'ETC' ? '기타' : vwitm.vwitmCts }</label>
									</span>
									<c:if test="${qstn.etcInptUseyn eq 'Y' && vwitm.vwitmCts eq 'ETC' }">
										<input type="text" class="width-85per" name="rspns" id="${qstn.srvyQstnId }_etc" inputmask="byte" maxLen="4000" readonly="true">
									</c:if>
								</div>
							</c:if>
						</c:forEach>
					</c:if>
					<!-- OX선택형 -->
					<c:if test="${qstn.qstnRspnsTycd eq 'OX_CHC' }">
						<c:forEach var="vwitm" items="${srvyVwitmList }">
							<c:if test="${qstn.srvyQstnId eq vwitm.srvyQstnId }">
								<div class="padding-3">
									<span class="custom-input">
										<input type="radio" name="${qstn.srvyQstnId }_chc" id="${qstn.srvyQstnId }_chc_${vwitm.vwitmSeqno}" />
										<label for="${qstn.srvyQstnId }_chc_${vwitm.vwitmSeqno}">${vwitm.vwitmCts }</label>
									</span>
								</div>
							</c:if>
						</c:forEach>
					</c:if>
					<!-- 서술형 -->
					<c:if test="${qstn.qstnRspnsTycd eq 'LONG_TEXT' }">
						<textarea style='width:100%;height:70px;' maxLenCheck='byte,4000,true,true'></textarea>
					</c:if>
					<!-- 레벨형 -->
					<c:if test="${qstn.qstnRspnsTycd eq 'LEVEL' }">
						<div class="table-wrap margin-3">
			                <table class="table-type2">
			                    <colgroup>
			                        <col style="">
			                        <c:forEach var="lvl" items="${srvyQstnVwitmLvlList }">
			                        	<c:if test="${qstn.srvyQstnId eq lvl.srvyQstnId }">
				                        	<c:set var="wPer" value="${fn:length(srvyQstnVwitmLvlList) eq 3 ? '15' : '10' }" />
				                        	<col style="width:${wPer}%">
			                        	</c:if>
			                        </c:forEach>
			                    </colgroup>
			                    <thead>
			                        <tr>
			                            <th class="text-left">문항</th>
			                            <c:forEach var="lvl" items="${srvyQstnVwitmLvlList }">
			                            	<c:if test="${qstn.srvyQstnId eq lvl.srvyQstnId }">
					                            <th>${lvl.lvlCts }</th>
			                            	</c:if>
			                            </c:forEach>
			                        </tr>
			                    </thead>
			                    <tbody>
			                    	<c:forEach var="vwitm" items="${srvyVwitmList }">
										<c:if test="${qstn.srvyQstnId eq vwitm.srvyQstnId }">
					                        <tr>
					                        	<td class="text-left">${vwitm.vwitmCts }</td>
					                        	<c:forEach var="lvl" items="${srvyQstnVwitmLvlList }">
					                        		<c:if test="${qstn.srvyQstnId eq lvl.srvyQstnId }">
					                        			<td>
					                        				<span class="custom-input onlychk">
					                        					<input type="radio" name="${vwitm.srvyVwitmId }_lvl" id="${vwitm.srvyVwitmId }_lvl_${lvl.lvlSeqno}" value="${lvl.srvyQstnVwitmLvlId }" />
																<label for="${vwitm.srvyVwitmId }_lvl_${lvl.lvlSeqno}"></label>
					                        				</span>
					                        			</td>
					                        		</c:if>
					                        	</c:forEach>
					                        </tr>
										</c:if>
									</c:forEach>
			                    </tbody>
			                </table>
			            </div>
					</c:if>
				</div>
			</c:if>
		</c:forEach>
	</div>
</c:forEach>

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