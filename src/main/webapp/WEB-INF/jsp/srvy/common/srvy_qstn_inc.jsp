<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.js"></script>
<script type="text/javascript" src="/webdoc/js/chart.min.js"></script>
<script type="text/javascript" src="/webdoc/js/Chart.PieceLabel.min.js"></script>
<c:forEach var="srvyppr" items="${srvypprList }">
	<div class="srvypprDiv" data-id="${srvyppr.srvypprId }" data-seqno="${srvyppr.srvySeqno }" ${srvyppr.srvySeqno > 1 && params.searchKey ne 'PRINT' ? 'style="display: none;"' : '' }>
		<c:forEach var="qstn" items="${srvyQstnList }">
			<c:if test="${srvyppr.srvypprId eq qstn.srvypprId }">
				<div class="border-1 margin-top-3 ${params.searchKey eq 'EVL' || params.searchKey eq 'PRINT' ? 'cpn' : '' }">
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
								<c:set var="rspnsChc" value="" />
								<c:set var="rspns" value="" />
								<c:if test="${params.searchKey eq 'EVL' || params.searchKey eq 'PRINT' }">
									<c:forEach var="rspnsList" items="${srvyRspnsList }">
										<c:if test="${rspnsList.srvyQstnId eq qstn.srvyQstnId && rspnsList.srvyVwitmId eq vwitm.srvyVwitmId }">
											<c:set var="rspnsChc" value="checked='true'" />
											<c:if test="${vwitm.vwitmCts eq 'ETC' }">
												<c:set var="rspns" value="${rspnsList.rspns }" />
											</c:if>
										</c:if>
									</c:forEach>
								</c:if>
								<div class="padding-3 flex-item">
									<span class="custom-input">
										<input type="${qstn.qstnRspnsTycd eq 'MLT_CHC' ? 'checkbox' : 'radio' }" ${rspnsChc } value="${vwitm.vwitmCts }" name="${qstn.srvyQstnId }_chc" id="${qstn.srvyQstnId }_chc_${vwitm.vwitmSeqno}" onclick="etcInptCheck('${qstn.srvyQstnId }')" />
										<label for="${qstn.srvyQstnId }_chc_${vwitm.vwitmSeqno}">${vwitm.vwitmCts eq 'ETC' ? '기타' : vwitm.vwitmCts }</label>
									</span>
									<c:if test="${qstn.etcInptUseyn eq 'Y' && vwitm.vwitmCts eq 'ETC' }">
										<input type="text" class="width-85per" name="rspns" value="${rspns }" id="${qstn.srvyQstnId }_etc" inputmask="byte" maxLen="4000" readonly="true">
									</c:if>
								</div>
							</c:if>
						</c:forEach>
					</c:if>
					<!-- OX선택형 -->
					<c:if test="${qstn.qstnRspnsTycd eq 'OX_CHC' }">
						<c:forEach var="vwitm" items="${srvyVwitmList }">
							<c:if test="${qstn.srvyQstnId eq vwitm.srvyQstnId }">
								<c:set var="rspnsChc" value="" />
								<c:if test="${params.searchKey eq 'EVL' || params.searchKey eq 'PRINT' }">
									<c:forEach var="rspnsList" items="${srvyRspnsList }">
										<c:if test="${rspnsList.srvyQstnId eq qstn.srvyQstnId && rspnsList.srvyVwitmId eq vwitm.srvyVwitmId }">
											<c:set var="rspnsChc" value="checked='true'" />
										</c:if>
									</c:forEach>
								</c:if>
								<div class="padding-3">
									<span class="custom-input">
										<input type="radio" ${rspnsChc } name="${qstn.srvyQstnId }_chc" id="${qstn.srvyQstnId }_chc_${vwitm.vwitmSeqno}" />
										<label for="${qstn.srvyQstnId }_chc_${vwitm.vwitmSeqno}">${vwitm.vwitmCts }</label>
									</span>
								</div>
							</c:if>
						</c:forEach>
					</c:if>
					<!-- 서술형 -->
					<c:if test="${qstn.qstnRspnsTycd eq 'LONG_TEXT' }">
						<c:set var="rspns" value="" />
						<c:if test="${params.searchKey eq 'EVL' || params.searchKey eq 'PRINT' }">
							<c:forEach var="rspnsList" items="${srvyRspnsList }">
								<c:if test="${rspnsList.srvyQstnId eq qstn.srvyQstnId }">
									<c:set var="rspns" value="${rspnsList.rspns }" />
								</c:if>
							</c:forEach>
						</c:if>
						<textarea style='width:100%;height:70px;' maxLenCheck='byte,4000,true,true'>${rspns }</textarea>
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
					                        			<c:set var="rspnsChc" value="" />
														<c:if test="${params.searchKey eq 'EVL' || params.searchKey eq 'PRINT' }">
															<c:forEach var="rspnsList" items="${srvyRspnsList }">
																<c:if test="${rspnsList.srvyQstnId eq qstn.srvyQstnId && rspnsList.srvyVwitmId eq vwitm.srvyVwitmId && rspnsList.srvyQstnVwitmLvlId eq lvl.srvyQstnVwitmLvlId }">
																	<c:set var="rspnsChc" value="checked='true'" />
																</c:if>
															</c:forEach>
														</c:if>
					                        			<td>
					                        				<span class="custom-input onlychk">
					                        					<input type="radio" ${rspnsChc } name="${vwitm.srvyVwitmId }_lvl" id="${vwitm.srvyVwitmId }_lvl_${lvl.lvlSeqno}" value="${lvl.srvyQstnVwitmLvlId }" />
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
				<c:if test="${params.searchKey eq 'EVL' }">
					<div class="border-1 padding-3">
						<button class="btn basic small" onclick="viewStatus(this, '${qstn.srvyQstnId}', '${qstn.srvypprId }', '${qstn.qstnRspnsTycd }')"><spring:message code="exam.label.view.result.status" /> <i class="xi-angle-down"></i></button><!-- 결과 통계 보기 -->
				        <div class="resultStatus" style="display:none;">
				        	<div class="column">
				                 <canvas id="${qstn.srvyQstnId }_barChart" height="130"></canvas>
				             </div>
				             <div class="column">
				                 <canvas id="${qstn.srvyQstnId }_pieChart" height="130"></canvas>
				             </div>
				        </div>
					</div>
				</c:if>
			</c:if>
		</c:forEach>
	</div>
</c:forEach>