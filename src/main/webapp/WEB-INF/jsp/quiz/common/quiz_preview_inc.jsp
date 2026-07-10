<head>
   	<script type="text/javascript">
		$(document).ready(function() {
			UiComm.showLoading(false);

			// dialog창 height 길이
			const currentHeight =
				  parseFloat(window.parent.dialog[0].style.height) ||
				  parseFloat(getComputedStyle(window.parent.dialog[0]).height) ||
				  window.parent.dialog[0].getBoundingClientRect().height;

			// 팀퀴즈 or 학생퀴즈응시인 경우 0.65배율
			const ratio = "${vo.examGbncd}" == "QUIZ_TEAM" || ${not empty tkexamInfo} ? 0.65 : 0.8;
			$(".quiz-layout-wrapper")[0].style.maxHeight = (currentHeight * ratio) + "px";
			$(".quiz-layout-wrapper")[0].style.overflowY = 'auto';
		});

		// 연결형 문항 이벤트 추가
	    function linkQstnEvent(qstnId) {
	        var invalid 	= false;
	        var $containner = $("#linkContainer_" + qstnId);
	        var $answers 	= $containner.find(".slot");

	        $answers.sortable({
	            opacity: 0.7,
	            zIndex: 9999,
	            connectWith: ".matching_drag .slot, .account-list .slot",
	            containment: $containner,
	            helper: "clone",
	            cursor: "pointer",
	            create: function(event, ui) {
	                if ($(this).children().length > 0) {
	                    $(this).addClass("item-disabled");
	                }
	            },
	            over: function(event, ui) {
	                invalid = false;
	                if (this !== event.currentTarget) {
	                    if ($(event.target).hasClass("item-disabled")) {
	                        invalid = true;
	                    }
	                }
	            },
	            remove: function(event, ui) {
	                if (invalid != true) {
	                    $(this).removeClass("item-disabled");
	                }
	            },
	            receive: function(event, ui) {
	                if (invalid == true) {
	                    ui.sender.sortable("cancel");
	                }
	                $(this).addClass("item-disabled");
	                qstnAnswSht(ui.item, "LINK");
	            }
	        });
	    }

		// 문항답안
		function qstnAnswSht(obj, qstnRspnsTycd, gbn) {
			const raw = $("#qstnRspnsFrm input[name=rspns]").val();
			const rspns = raw ? JSON.parse(raw) : [];

			let qstnId = "";										// 문항아이디
			// 연결형
			if(qstnRspnsTycd == "LINK") {
				qstnId = $(obj).closest("div.matching_form").attr("id").split("_")[1];
			} else {
				qstnId = obj.name.split("_")[1];
			}
			let map = rspns.find(item => item.qstnId === qstnId);	// 동일문항찾기

			// 동일 문항 없을 시 추가
			if (!map) {
			    map = {qstnId: qstnId};
			    rspns.push(map);
			}

			let answ 		= "";		// 저장용
			let displayAnsw = "";		// 화면표시용
			let isAnsw 		= true;		// 제출 답안 번호 체크용

			// 단일선택형, 다중선택형, 단답형
			if(qstnRspnsTycd == "ONE_CHC" || qstnRspnsTycd == "MLT_CHC" || qstnRspnsTycd == "SHORT_TEXT") {
				let $answers = "";
				if(qstnRspnsTycd == "SHORT_TEXT") {
					$answers = $(obj).closest("div.shortAnswerList").find("input[name^=qstn]");
				} else {
					$answers = $(obj).closest("ol.q_cont_ans").find("input[name^=qstn]:checked");
				}

				$answers.each(function(idx) {
		            if (idx > 0) {
		            	answ 		+= "@#";
		            	displayAnsw += ",";
		            }
		            answ 		+= $(this).val();
		            displayAnsw += $(this).val();

		            if(qstnRspnsTycd == "SHORT_TEXT" && $(this).val().trim() == "") isAnsw = false;
		        });
				if(qstnRspnsTycd == "MLT_CHC" && $answers.length == 0) isAnsw = false;
			// OX선택형
			} else if(qstnRspnsTycd == "OX_CHC") {
				let $answers = $(obj).closest("div.ox_quiz").find("input[name^=qstn]:checked")[0];

				answ 		= $answers.value;
				displayAnsw = $($answers).siblings("label").find("i")[0].classList.contains("xi-radiobox-blank") ? "O" : "X";
			// 서술형
			} else if(qstnRspnsTycd == "LONG_TEXT") {
				let $answers = $(obj).closest("div.q_cont_ans").find("textarea[name^=qstn]")[0];

				answ 		= $answers.value;
				displayAnsw = $answers.value;

				if($answers.value == "") isAnsw = false;
			// 연결형
			} else if(qstnRspnsTycd == "LINK") {
				let $answers = $(obj).closest("div.matching_form").find("ol.account-list div[name^=link]");

				$answers.each(function(idx) {
		            if (idx > 0) {
		            	answ 		+= "@#";
		            	displayAnsw += "|";
		            }
		            if($(this).find("span")[0] != undefined) {
						let text = $(this).find("span")[0].textContent;
			            answ 		+= text;
			            displayAnsw += text;
		            } else {
		            	isAnsw = false;
		            }
		        });
			}

			map.answShtCts = answ;
			$("#qstnRspnsFrm input[name=rspns]").val(JSON.stringify(rspns));

			const li = $("#rspns_"+qstnId);
			// 제출 답안 텍스트노드 제거
			li.contents().filter(function() {
			    return this.nodeType === 3;
			}).remove();
			// 새 텍스트 추가
			li.append(displayAnsw);
			if(isAnsw) {
				$(li).addClass("active");
			} else {
				$(li).removeClass("active");
			}

			if(${not empty tkexamInfo}) {
				if(gbn != "SET") ssnlQstnTempSave(map);
				controllSubmitBtn();
			}
		}
	</script>
</head>

<div class="quiz-layout-wrapper">
	<!-- 문제영역 -->
	<div class="course_history bd0">
		<c:forEach var="item" items="${qstnList }" varStatus="varStatus">
			<div class="question_area pd0" data-qstnId="${item.qstnId }" data-rspnsTycd="${item.qstnRspnsTycd }" data-qstnSeqno="${item.qstnSeqno }" style="display:${vo.qstnDsplyGbncd eq 'WHOL' || item.qstnGbncd eq 'EXRCS_QSTN' || item.qstnGbncd eq 'SURPRISE_QUIZ' ? 'block' : 'none'}">
				<div class="question_con">
					<div class="q_top">
						<div class="flex-item width-100per">
	                        <p class="flex-none mr15">
	                        	<c:choose>
									<c:when test="${item.qstnCnddtSeqno eq '1'}">
										<b><spring:message code="quiz.label.qstn" /><!-- 문제 -->${item.qstnSeqno}</b>
									</c:when>
									<c:otherwise>
										<b><spring:message code="quiz.label.qstn" /><!-- 문제 -->${item.qstnSeqno}-${item.qstnCnddtSeqno}</b>
									</c:otherwise>
								</c:choose>
	                        </p>
	                        <div class="flex-1 tal">${item.qstnTtl }</div>
	                        <div class="margin-left-auto"><spring:message code="message.marks" /><!-- 배점 --> ${item.qstnScr }<spring:message code="message.score" /><!-- 점 --></div>
	                    </div>
					</div>
					<div class="q_cont">
						<c:choose>
							<c:when test="${fn:startsWith(fn:trim(item.qstnCts), '<div class=\"se-contents\"')}">
								<pre>${item.qstnCts }</pre>
							</c:when>
							<c:otherwise>
								<p>${item.qstnCts }</p>
							</c:otherwise>
						</c:choose>
						<c:if test="${item.qstnRspnsTycd eq 'ONE_CHC' || item.qstnRspnsTycd eq 'MLT_CHC' }">
							<ol class="q_cont_ans">
								<c:forEach var="vwitm" items="${qstnVwitmList }">
									<c:if test="${item.qstnId eq vwitm.qstnId }">
										<c:set var="chc_checked" value="" />
			                			<c:forEach var="answSht" items="${answShtList }">
			                				<c:if test="${vwitm.qstnId eq answSht.qstnId }">
				                				<c:set var="cts" value="${fn:split(answSht.answShtCts, '@#')}" />

												<c:forEach var="seqno" items="${cts}">
												    <c:if test="${seqno eq vwitm.qstnVwitmSeqno}">
												        <c:set var="chc_checked" value="checked" />
												    </c:if>
												</c:forEach>
			                				</c:if>
			                			</c:forEach>
										<li>
											<input type="${item.qstnRspnsTycd eq 'MLT_CHC' ? 'checkbox' : 'radio' }" name="qstn_${item.qstnId }" id="qstn_${item.qstnId }_${vwitm.qstnVwitmSeqno}" value="${vwitm.qstnVwitmSeqno}" onchange="qstnAnswSht(this, '${item.qstnRspnsTycd}')" ${chc_checked } />
											<label for="qstn_${item.qstnId }_${vwitm.qstnVwitmSeqno}"><span class="ansNum">${vwitm.qstnVwitmSeqno}</span>${vwitm.qstnVwitmCts}</label>
										</li>
									</c:if>
								</c:forEach>
							</ol>
						</c:if>
						<c:if test="${item.qstnRspnsTycd eq 'OX_CHC' }">
							<div class="q_cont_ans ox_quiz justify-content-center">
								<c:forEach var="vwitm" items="${qstnVwitmList }">
			                		<c:if test="${item.qstnId eq vwitm.qstnId }">
			                			<c:set var="ox_checked" value="" />
			                			<c:forEach var="answSht" items="${answShtList }">
			                				<c:if test="${vwitm.qstnId eq answSht.qstnId && vwitm.qstnVwitmSeqno eq answSht.answShtCts }">
			                					<c:set var="ox_checked" value="checked" />
			                				</c:if>
			                			</c:forEach>
			                			<div class="ox_item">
			                				<input type="radio" class="ox_input" name="qstn_${item.qstnId }" id="qstn_${item.qstnId }_${vwitm.qstnVwitmSeqno}" value="${vwitm.qstnVwitmSeqno }" onchange="qstnAnswSht(this, '${item.qstnRspnsTycd}')" ${ox_checked } />
			                				<label for="qstn_${item.qstnId }_${vwitm.qstnVwitmSeqno}" class="btn basic"><i class="${vwitm.qstnVwitmCts eq 'O' ? 'xi-radiobox-blank' : 'xi-close' } icon"></i></label>
			                			</div>
			                		</c:if>
			                	</c:forEach>
							</div>
						</c:if>
						<c:if test="${item.qstnRspnsTycd eq 'SHORT_TEXT' }">
							<div class="q_cont_ans shortAnswerList">
								<c:forEach var="vwitm" items="${qstnVwitmList }">
									<c:if test="${item.qstnId eq vwitm.qstnId }">
										<c:set var="short_cts" value="" />
										<c:forEach var="answSht" items="${answShtList }">
			                				<c:if test="${vwitm.qstnId eq answSht.qstnId }">
										        <c:set var="replaced" value="${fn:replace(answSht.answShtCts, '@#@#', '@#EMPTY@#')}"/>
										        <c:if test="${fn:startsWith(replaced, '@#')}">
											    	<c:set var="replaced" value="EMPTY${replaced}"/>
												</c:if>
										        <c:set var="cts" value="${fn:split(replaced, '@#')}" />
										        <c:if test="${cts[vwitm.qstnVwitmSeqno-1] ne 'EMPTY' }">
				                					<c:set var="short_cts" value="${cts[vwitm.qstnVwitmSeqno-1] }" />
										        </c:if>
			                				</c:if>
			                			</c:forEach>
										<label for="qstn_${item.qstnId }_${vwitm.qstnVwitmSeqno}">
											<input type="text" class="form-control" inputmask="byte" maxLen="4000" name="qstn_${item.qstnId }" id="qstn_${item.qstnId }_${vwitm.qstnVwitmSeqno}" value="${short_cts }" onchange="qstnAnswSht(this, '${item.qstnRspnsTycd}')" />
										</label>
									</c:if>
								</c:forEach>
							</div>
						</c:if>
						<c:if test="${item.qstnRspnsTycd eq 'LONG_TEXT' }">
							<c:set var="long_cts" value="" />
							<c:forEach var="answSht" items="${answShtList }">
				               	<c:if test="${item.qstnId eq answSht.qstnId }">
				               		<c:set var="long_cts" value="${answSht.answShtCts }" />
				               	</c:if>
				            </c:forEach>
							<div class="q_cont_ans">
								<textarea style="width:100%;height:100px" maxLenCheck="byte,4000,true,true" name="qstn_${item.qstnId }" onchange="qstnAnswSht(this, '${item.qstnRspnsTycd}')">${long_cts }</textarea>
							</div>
						</c:if>
						<c:if test="${item.qstnRspnsTycd eq 'LINK' }">
							<div class="q_cont_ans matching_form" id="linkContainer_${item.qstnId }">
								<ol class="matching_list account-list">
									<c:set var="alphabets" value="ABCDEFGHIJKLMNOPQRSTUVWXYZ" />
									<c:set var="isAnswSht" value="false" />
									<c:forEach var="vwitm" items="${qstnVwitmList }">
				       					<c:if test="${item.qstnId eq vwitm.qstnId }">
				       						<li class="matching_item">
				       							<div class="q_box">
				       								<label>
				       									<span class="index">${fn:substring(alphabets, vwitm.qstnVwitmSeqno-1, vwitm.qstnVwitmSeqno)}</span>
				       									<input type="text" readonly="true" value="${vwitm.qstnVwitmCts.split('[|]')[0]}" />
				       								</label>
				       							</div>
				       							<div class="a_box">
				       								<label>
				       									<div name="link_${item.qstnId }" class="slot w200 border-1" style="height: 36px;">
				       										<c:forEach var="answSht" items="${answShtList }">
								                				<c:if test="${vwitm.qstnId eq answSht.qstnId }">
								                					<c:set var="isAnswSht" value="true" />
								                					<c:set var="replaced" value="${fn:replace(answSht.answShtCts, '@#@#', '@#EMPTY@#')}"/>
								                					<c:if test="${fn:startsWith(replaced, '@#')}">
									                					<c:set var="replaced" value="EMPTY${replaced}"/>
																	</c:if>
								                					<c:set var="cts" value="${fn:split(replaced, '@#')}" />
								                					<c:forEach var="crans" items="${cts}" varStatus="linkStatus">
																	    <c:if test="${crans ne 'EMPTY' && vwitm.qstnVwitmSeqno eq linkStatus.count}">
																	    	<div class="width-100per">
												       							<i class="xi-arrows" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
												       							<span class="width-100per">${crans}</span>
												       						</div>
																	    </c:if>
																	</c:forEach>
								                				</c:if>
								                			</c:forEach>
				       									</div>
				       								</label>
				       							</div>
				       						</li>
				       					</c:if>
									</c:forEach>
								</ol>
								<ol class="matching_list matching_drag">
									<c:forEach var="vwitm" items="${qstnVwitmList }">
					       				<c:if test="${item.qstnId eq vwitm.qstnId }">
					       					<li class="matching_item">
					       						<div class="a_box">
					       							<label name="opposite" class="slot width-100per" style="height: 36px;">
					       								<c:choose>
					       									<c:when test="${isAnswSht }">
					       										<c:set var="isCts" value="true" />
							       								<c:forEach var="answSht" items="${answShtList }">
											                		<c:if test="${vwitm.qstnId eq answSht.qstnId }">
											                			<c:set var="cts" value="${fn:split(answSht.answShtCts, '@#')}" />
											                			<c:forEach var="crans" items="${cts}" varStatus="linkStatus">
																		    <c:if test="${not empty crans && vwitm.qstnVwitmCts.split('[|]')[1] eq crans}">
																		    	<c:set var="isCts" value="false" />
																		    </c:if>
																		</c:forEach>
											                		</c:if>
											                	</c:forEach>
											                	<c:if test="${isCts }">
											                		<div class="width-100per">
										       							<i class="xi-arrows" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
										       							<span class="width-100per">${vwitm.qstnVwitmCts.split('[|]')[1]}</span>
										       						</div>
											                	</c:if>
					       									</c:when>
					       									<c:otherwise>
									       						<div class="width-100per">
									       							<i class="xi-arrows" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
									       							<span class="width-100per">${vwitm.qstnVwitmCts.split('[|]')[1]}</span>
									       						</div>
					       									</c:otherwise>
					       								</c:choose>
					       							</label>
					       						</div>
					       					</li>
					       				</c:if>
				       				</c:forEach>
								</ol>
							</div>
							<script>
				                linkQstnEvent('${item.qstnId}');
				            </script>
						</c:if>
					</div>
				</div>
			</div>
		</c:forEach>
	</div>
	<!-- //문제영역 -->
	<!-- 제출답안 -->
	<div class="quiz_paper_wrap">
		<form id="qstnRspnsFrm" onsubmit="return false;">
			<input type="hidden" name="rspns" />
		</form>
        <div class="course_history">
            <div class="h_top">
                <b><spring:message code="quiz.label.answ.sht" /><!-- 제출 답안 --></b>
            </div>
            <div class="quiz_paper_list">
                <ol>
	                <c:forEach var="item" items="${qstnList }" varStatus="varStatus">
		                <li id="rspns_${item.qstnId }"><span>${item.qstnSeqno }</span></li>
	                </c:forEach>
                </ol>
            </div>
        </div>
    </div>
	<!-- //제출답안 -->
</div>