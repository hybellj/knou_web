<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
		<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
			<jsp:param name="style" value="classroom"/>
		</jsp:include>
    </head>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<script type="text/javascript">
		// 연결형 문항 이벤트 추가
	    function linkQstnEvent() {
	        var invalid 	= false;
	        var $containner = $("#linkContainer");
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
	            }
	        });
	    }
	</script>

	<body class="modal-page">
        <div id="wrap">
        	<table class="table-type1 margin-bottom-5">
        		<colgroup>
        			<col class="width-20per" />
        			<col class="" />
        		</colgroup>
				<tbody>
					<tr>
						<th class="text-center"><spring:message code="common.label.ctgr" /></th><!-- 분류 -->
						<td>
							<c:if test="${not empty qbnkQstnVO.upCtgrnm }">
            					${qbnkQstnVO.upCtgrnm } >
            				</c:if>
            				${qbnkQstnVO.ctgrnm }
						</td>
					</tr>
					<tr>
						<th class="text-center"><spring:message code="common.charge.professor" /></th><!-- 담당교수 -->
						<td>${qbnkQstnVO.sbjctnm } > ${qbnkQstnVO.usernm } <spring:message code="common.professor" /></td><!-- 교수 -->
					</tr>
				</tbody>
        	</table>

			<div class="quiz-layout-wrapper">
				<div class="course_history bd0">
					<div class="question_area pd0">
						<div class="question_con">
							<div class="q_top">
								<div class="flex-item width-100per">
			                        <p class="flex-none mr15">
										<b><spring:message code="quiz.label.qstn" /><!-- 문제 -->${qbnkQstnVO.qstnSeqno}</b>
			                        </p>
			                        <div class="flex-1 tal">${qbnkQstnVO.qstnTtl }</div>
			                    </div>
							</div>
							<div class="q_cont">
								<c:choose>
									<c:when test="${fn:startsWith(fn:trim(qbnkQstnVO.qstnCts), '<div class=\"se-contents\"')}">
										<pre>${qbnkQstnVO.qstnCts }</pre>
									</c:when>
									<c:otherwise>
										<p>${qbnkQstnVO.qstnCts }</p>
									</c:otherwise>
								</c:choose>
								<!-- 단일, 다중선택형 -->
								<c:if test="${qbnkQstnVO.qstnRspnsTycd eq 'ONE_CHC' || qbnkQstnVO.qstnRspnsTycd eq 'MLT_CHC' }">
									<ol class="q_cont_ans">
										<c:forEach var="vwitm" items="${qbnkQstnVwitmList }">
											<li>
												<input type="${qbnkQstnVO.qstnRspnsTycd eq 'MLT_CHC' ? 'checkbox' : 'radio' }" name="vwitmSeqno" id="vwitmSeqno${vwitm.vwitmSeqno }" />
												<label for="vwitmSeqno${vwitm.vwitmSeqno }"><span class="ansNum">${vwitm.vwitmSeqno}</span>${vwitm.vwitmCts}</label>
											</li>
										</c:forEach>
									</ol>
								</c:if>
								<!-- OX선택형 -->
						        <c:if test="${qbnkQstnVO.qstnRspnsTycd eq 'OX_CHC' }">
							       	<div class="q_cont_ans ox_quiz justify-content-center">
										<c:forEach var="vwitm" items="${qbnkQstnVwitmList }">
						                	<div class="ox_item">
						                		<input type="radio" class="ox_input" name="qstn" id="ox_${fn:toLowerCase(vwitm.vwitmCts)}" />
						                		<label for="ox_${fn:toLowerCase(vwitm.vwitmCts)}" class="btn basic"><i class="${vwitm.vwitmCts eq 'O' ? 'xi-radiobox-blank' : 'xi-close' } icon"></i></label>
						                	</div>
					                	</c:forEach>
									</div>
						        </c:if>
						        <!-- 단답형 -->
						        <c:if test="${qbnkQstnVO.qstnRspnsTycd eq 'SHORT_TEXT' }">
							       	<div class="q_cont_ans shortAnswerList">
										<c:forEach var="vwitm" items="${qbnkQstnVwitmList }">
											<label for="qstn_${vwitm.vwitmSeqno}">
												<input type="text" class="form-control" inputmask="byte" maxLen="4000" name="qstn" id="qstn_${vwitm.vwitmSeqno}" />
											</label>
										</c:forEach>
									</div>
						        </c:if>
						        <!-- 서술형 -->
								<c:if test="${qbnkQstnVO.qstnRspnsTycd eq 'LONG_TEXT' }">
									<div class="q_cont_ans">
										<textarea style="width:100%;height:100px" maxLenCheck="byte,4000,true,true" name="qstn"></textarea>
									</div>
					            </c:if>
					            <!-- 연결형 -->
						        <c:if test="${qbnkQstnVO.qstnRspnsTycd eq 'LINK' }">
					                <div class="q_cont_ans matching_form" id="linkContainer">
										<ol class="matching_list account-list">
											<c:set var="alphabets" value="ABCDEFGHIJKLMNOPQRSTUVWXYZ" />
											<c:forEach var="vwitm" items="${qbnkQstnVwitmList }">
							       				<li class="matching_item">
							       					<div class="q_box">
							       						<label>
							       							<span class="index">${fn:substring(alphabets, vwitm.vwitmSeqno-1, vwitm.vwitmSeqno)}</span>
							       							<input type="text" readonly="true" value="${vwitm.vwitmCts.split('[|]')[0]}" />
							       						</label>
							       					</div>
							       					<div class="a_box">
							       						<label>
							       							<div name="link" class="slot w200 border-1" style="height: 36px;"></div>
							       						</label>
							       					</div>
							       				</li>
											</c:forEach>
										</ol>
										<ol class="matching_list matching_drag">
											<c:forEach var="vwitm" items="${qbnkQstnVwitmList }">
								       			<li class="matching_item">
								       				<div class="a_box">
								       					<label name="opposite" class="slot width-100per" style="height: 36px;">
								       						<div class="width-100per">
													   				<i class="xi-arrows" aria-label="위젯 이동" role="button" tabindex="0" aria-grabbed="false"></i>
													   				<span class="width-100per">${vwitm.vwitmCts.split('[|]')[1]}</span>
													   			</div>
								       					</label>
								       				</div>
								       			</li>
						       				</c:forEach>
										</ol>
									</div>
									<script>
						                linkQstnEvent();
						            </script>
						        </c:if>
							</div>
						</div>
					</div>
				</div>
			</div>

			<div class="modal_btns">
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="common.button.close" /></button><!-- 닫기 -->
			</div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
