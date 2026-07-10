<script type="text/javascript">
	$(document).ready(function() {
		dialogHeightChange();
	});

	// dialog height 수정
	function dialogHeightChange() {
		// dialog창 height 길이
		const currentHeight =
			  parseFloat(window.parent.dialog[0].style.height) ||
			  parseFloat(getComputedStyle(window.parent.dialog[0]).height) ||
			  window.parent.dialog[0].getBoundingClientRect().height;

		// 팀설문 or 학생퀴즈응시 or 인쇄 화면인 경우 0.65배율 || 평가인 경우 0.6배율
		const ratio = "${vo.srvyGbn}" == "SRVY_TEAM" || ${not empty ptcpInfo} || "${params.searchKey}" == "PRINT" ? 0.65 : "${params.searchKey}" == "EVL" ? 0.6 : 0.75;
		$(".srvypprDiv:visible")[0].style.maxHeight = (currentHeight * ratio) + "px";
		$(".srvypprDiv:visible")[0].style.overflowY = 'auto';
	}

	// 설문답변확인
	function srvyRspnsCheck() {
		let isRspns = true;
		$(".srvypprDiv:visible").find(".question_con").each(function(i, v) {
			let qstnSeqno	= $(v).attr("data-qstnSeqno");	// 문항순번
			let esntl 		= $(v).attr("data-esntl");		// 필수답변여부
			let rspnsTycd 	= $(v).attr("data-rspnsTycd");	// 문항답변유형코드
			if(esntl == "Y") {
				// 단일, 다중, OX선택형
				if(rspnsTycd == "ONE_CHC" || rspnsTycd == "MLT_CHC" || rspnsTycd == "OX_CHC") {
					if($(v).find("input[name$=chc]:checked").length == 0) {
						UiComm.showMessage(qstnSeqno + "<spring:message code='srvy.alert.no.answer' />", "info");	/* 번 문항에 응답하지 않았습니다. */
						isRspns = false;
						return false;
					} else {
						$(v).find("input[name$=chc]:checked").each(function(ii, vv) {
							if(vv.value == "ETC") {
								if($.trim($(v).find("input[name=rspns]").val()) == "") {
									UiComm.showMessage(qstnSeqno + "<spring:message code='srvy.alert.input.etc' />", "info");	/* 번 문항 기타의견을 입력하세요. */
									isRspns = false;
									return false;
								}
							}
						});
					}
				// 서술형
				} else if(rspnsTycd == "LONG_TEXT") {
					if($.trim($(v).find("textarea").val()) == "") {
						UiComm.showMessage(qstnSeqno + "<spring:message code='srvy.alert.no.answer' />", "info");	/* 번 문항에 응답하지 않았습니다. */
						isRspns = false;
						return false;
					}
				// 레벨형
				} else if(rspnsTycd == "LEVEL") {
					$(v).find("tbody tr").each(function(ii, vv) {
						if($(vv).find("input[name$=lvl]:checked").length == 0) {
							UiComm.showMessage(qstnSeqno + "<spring:message code='srvy.alert.item.no.answer' />", "info");	/* 번 문항에 응답하지 않은 항목이 있습니다. */
							isRspns = false;
							return false;
						}
					});
				}
			}
		});
		return isRspns;
	}
</script>

<c:forEach var="srvyppr" items="${srvypprList }">
	<div class="course_history bd0 srvypprDiv" data-id="${srvyppr.srvypprId }" data-seqno="${srvyppr.srvySeqno }" ${srvyppr.srvySeqno > 1 && params.searchKey ne 'PRINT' ? 'style="display: none;"' : '' }>
		<div class="question_area pd0">
			<c:forEach var="qstn" items="${srvyQstnList }">
				<c:if test="${srvyppr.srvypprId eq qstn.srvypprId }">
					<div class="question_con ${params.searchKey eq 'EVL' || params.searchKey eq 'PRINT' ? 'cpn' : '' }" data-qstnId="${qstn.srvyQstnId }" data-qstnSeqno="${qstn.qstnSeqno }" data-esntl="${qstn.esntlRspnsyn }" data-rspnsTycd="${qstn.qstnRspnsTycd }" data-mvmn="${qstn.srvyMvmnUseyn }">
						<div class="q_top">
							<div class="flex-item width-100per">
								<p class="flex-none mr15"><b>${srvyppr.srvySeqno }-${qstn.qstnSeqno }</b></p>
                                <div class="flex-1 tal">${fn:escapeXml(qstn.qstnTtl) }</div>
							</div>
						</div>
						<div class="ans_cont q_cont">
							<c:choose>
								<c:when test="${fn:startsWith(fn:trim(qstn.qstnCts), '<div class=\"se-contents\"')}">
									<pre>${qstn.qstnCts }</pre>
								</c:when>
								<c:otherwise>
									<p>${qstn.qstnCts }</p>
								</c:otherwise>
							</c:choose>
							<!-- 단일, 다중선택형 -->
							<c:if test="${qstn.qstnRspnsTycd eq 'ONE_CHC' || qstn.qstnRspnsTycd eq 'MLT_CHC' }">
								<ol class="ans_cont_survey_list">
									<c:forEach var="vwitm" items="${srvyVwitmList }">
										<c:if test="${qstn.srvyQstnId eq vwitm.srvyQstnId }">
											<c:set var="rspnsChc" value="" />
											<c:set var="rspns" value="" />
											<c:if test="${params.searchKey eq 'EVL' || params.searchKey eq 'PRINT' || not empty ptcpInfo }">
												<c:forEach var="rspnsList" items="${srvyRspnsList }">
													<c:if test="${rspnsList.srvyQstnId eq qstn.srvyQstnId && rspnsList.srvyVwitmId eq vwitm.srvyVwitmId }">
														<c:set var="rspnsChc" value="checked='true'" />
														<c:if test="${vwitm.vwitmCts eq 'ETC' }">
															<c:set var="rspns" value="${rspnsList.rspns }" />
														</c:if>
													</c:if>
												</c:forEach>
											</c:if>
											<li>
												<c:choose>
													<c:when test="${qstn.etcInptUseyn eq 'Y' && vwitm.vwitmCts eq 'ETC' }">
														<div>
			                                                <span class="custom-input">
			                                                    <input type="${qstn.qstnRspnsTycd eq 'MLT_CHC' ? 'checkbox' : 'radio' }" ${rspnsChc } name="${qstn.srvyQstnId }_chc" id="${qstn.srvyQstnId }_chc_${vwitm.vwitmSeqno}" value="${vwitm.vwitmCts }" data-vwitmId="${vwitm.srvyVwitmId }" onclick="etcInptCheck('${qstn.srvyQstnId }')" data-mvmnPpr="${vwitm.mvmnSrvypprId }" />
			                                                    <label for="${qstn.srvyQstnId }_chc_${vwitm.vwitmSeqno}"><spring:message code="srvy.label.etc" /><!-- 기타 --></label>
			                                                </span>
			                                                <span class="custon-input">
			                                                    <label for="${qstn.srvyQstnId }_etc">
			                                                        <input type="text" class="form-control width-50per" name="rspns" id="${qstn.srvyQstnId }_etc" value="${rspns }" inputmask="byte" maxLen="4000" readonly="true">
			                                                    </label>
			                                                </span>
			                                            </div>
													</c:when>
													<c:otherwise>
														<span class="custom-input">
			                                                <input type="${qstn.qstnRspnsTycd eq 'MLT_CHC' ? 'checkbox' : 'radio' }" ${rspnsChc } name="${qstn.srvyQstnId }_chc" id="${qstn.srvyQstnId }_chc_${vwitm.vwitmSeqno}" value="${vwitm.srvyVwitmId }" onclick="etcInptCheck('${qstn.srvyQstnId }')" data-mvmnPpr="${vwitm.mvmnSrvypprId }" />
			                                                <label for="${qstn.srvyQstnId }_chc_${vwitm.vwitmSeqno}">${vwitm.vwitmCts }</label>
			                                            </span>
													</c:otherwise>
												</c:choose>
											</li>
										</c:if>
									</c:forEach>
								</ol>
							</c:if>
							<!-- OX선택형 -->
							<c:if test="${qstn.qstnRspnsTycd eq 'OX_CHC' }">
								<div class="q_cont_ans ox_quiz justify-content-center">
									<c:forEach var="vwitm" items="${srvyVwitmList }">
										<c:if test="${qstn.srvyQstnId eq vwitm.srvyQstnId }">
											<c:set var="rspnsChc" value="" />
											<c:if test="${params.searchKey eq 'EVL' || params.searchKey eq 'PRINT' || not empty ptcpInfo }">
												<c:forEach var="rspnsList" items="${srvyRspnsList }">
													<c:if test="${rspnsList.srvyQstnId eq qstn.srvyQstnId && rspnsList.srvyVwitmId eq vwitm.srvyVwitmId }">
														<c:set var="rspnsChc" value="checked='true'" />
													</c:if>
												</c:forEach>
											</c:if>
											<div class="ox_item">
												<input type="radio" ${rspnsChc } name="${qstn.srvyQstnId }_chc" id="${qstn.srvyQstnId }_chc_${vwitm.vwitmSeqno}" class="ox_input" value="${vwitm.srvyVwitmId }" data-mvmnPpr="${vwitm.mvmnSrvypprId }">
                                                <label for="${qstn.srvyQstnId }_chc_${vwitm.vwitmSeqno}" class="btn basic">
                                                	<c:choose>
                                                		<c:when test="${vwitm.vwitmCts eq 'O' }">
                                                			<i class="xi-radiobox-blank icon"></i>
                                                		</c:when>
                                                		<c:otherwise>
                                                			<i class="xi-close icon"></i>
                                                		</c:otherwise>
                                                	</c:choose>
                                                </label>
											</div>
										</c:if>
									</c:forEach>
								</div>
							</c:if>
							<!-- 서술형 -->
							<c:if test="${qstn.qstnRspnsTycd eq 'LONG_TEXT' }">
								<c:set var="rspns" value="" />
								<c:if test="${params.searchKey eq 'EVL' || params.searchKey eq 'PRINT' || not empty ptcpInfo }">
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
								<div class="table-wrap">
					                <table class="table-type2">
					                    <colgroup>
					                        <col style="">
					                        <c:forEach var="lvl" items="${srvyQstnVwitmLvlList }">
					                        	<c:if test="${qstn.srvyQstnId eq lvl.srvyQstnId }">
						                        	<col style="width:7%">
					                        	</c:if>
					                        </c:forEach>
					                    </colgroup>
					                    <thead>
					                        <tr>
					                            <th class="text-left"><spring:message code="srvy.label.qstn" /><!-- 문항 --></th>
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
							                        	<td class="t_left">${vwitm.vwitmCts }</td>
							                        	<c:forEach var="lvl" items="${srvyQstnVwitmLvlList }">
							                        		<c:if test="${qstn.srvyQstnId eq lvl.srvyQstnId }">
							                        			<c:set var="rspnsChc" value="" />
																<c:if test="${params.searchKey eq 'EVL' || params.searchKey eq 'PRINT' || not empty ptcpInfo }">
																	<c:forEach var="rspnsList" items="${srvyRspnsList }">
																		<c:if test="${rspnsList.srvyQstnId eq qstn.srvyQstnId && rspnsList.srvyVwitmId eq vwitm.srvyVwitmId && rspnsList.srvyQstnVwitmLvlId eq lvl.srvyQstnVwitmLvlId }">
																			<c:set var="rspnsChc" value="checked='true'" />
																		</c:if>
																	</c:forEach>
																</c:if>
							                        			<td>
							                        				<span class="custom-input">
							                        					<input type="radio" ${rspnsChc } name="${vwitm.srvyVwitmId }_lvl" id="${vwitm.srvyVwitmId }_lvl_${lvl.lvlSeqno}" value="${lvl.srvyQstnVwitmLvlId }" data-vwitmId="${vwitm.srvyVwitmId }" />
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
					</div>
					<c:if test="${params.searchKey eq 'EVL' }">
						<div class="border-1 padding-3">
							<button class="btn basic small" onclick="viewStatus(this, '${qstn.srvyQstnId}', '${qstn.srvypprId }', '${qstn.qstnRspnsTycd }')"><spring:message code="srvy.button.view.result.status" /> <i class="xi-angle-down"></i></button><!-- 결과 통계 보기 -->
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
	</div>
</c:forEach>