<%@ taglib prefix="c"      		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" 		uri="http://www.springframework.org/tags"%>
<head>
   	<style type="text/css">
   		.ui.checkbox label.question.multi:before {
   			border-radius: 0;
   		}
   		.ui.checkbox label.question.multi:after {
   			border-radius: 0;
   		}
   		.ui.checkbox input:checked ~ label.question.multi:after {
   			border-radius: 0;
   		}
   		.dark .line-sortable-box .inventory-list .slot.item-disabled {
   			background: none;
   		}
   		.dark .line-sortable-box .inventory-list .slot {
   			background: none;
   		}
   		.dark .line-sortable-box .inventory-list {
   			background: none;
   		}
   		.dark .line-sortable-box .inventory-list .slot span {
   			background: none;
   		}
   	</style>
   	<script type="text/javascript">
		$(document).ready(function() {
		});

		// 선긋기 sortable 셍성
	    function createSortable(examQtsnNo) {
	        var invalid 	= false;
	        var $answers 	= $("div.slot[name=link" + examQtsnNo + "], div.slot[name=opposite" + examQtsnNo + "]");
	        var $containner = $answers.closest("div.line-sortable-box");
	        $answers.sortable({
	            placeholder: "",
	            opacity: 0.7,
	            zIndex: 9999,
	            connectWith: ".inventory-list .slot, .account-list .slot",
	            containment: $containner,
	            cursor: "pointer",
	            create: function(event, ui) {
	                if (!$(this).is(':empty')) {
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
</head>
<div class="ui form qstnList mt10">
	<c:forEach var="item" items="${qstnList }" varStatus="listStatus">
		<div class="ui card wmax qstnDiv question-box" id="qstnDiv_${item.qstnId }" data-qstnSeqno="${item.qstnSeqno}">
			<div class="fields content header2">
				<div class="field wf100">
					<c:choose>
						<c:when test="${item.qstnCnddtSeqno eq '1'}">
							<span><spring:message code="exam.label.qstn" /><!-- 문제 --> ${item.qstnSeqno}</span>
						</c:when>
						<c:otherwise>
							<span><spring:message code="exam.label.qstn" /><!-- 문제 --> ${item.qstnSeqno}-${item.qstnCnddtSeqno}</span>
						</c:otherwise>
					</c:choose>
					<c:if test="${item.qstnRspnsTycd eq 'LINK' }">(<spring:message code="exam.label.qstn.match.info" /><!-- 오른쪽의 정답을 끌어서 빈 칸에 넣으세요. -->)</c:if>
				</div>
			</div>
			<div class="content">
				<div class="mb20">${item.qstnCts}</div>
				<c:if test="${item.qstnRspnsTycd eq 'ONE_CHC' || item.qstnRspnsTycd eq 'MLT_CHC' }">
					<div class="ui divider"></div>
					<c:forEach var="vwitm" items="${qstnVwitmList }">
						<c:if test="${item.qstnId eq vwitm.qstnId }">
							<div class="field" id="vwitmLi_${item.qstnSeqno}_${vwitm.qstnVwitmSeqno}">
								<div class="ui checkbox">
									<input type="${item.qstnRspnsTycd eq 'MLT_CHC' ? 'checkbox' : 'radio'}" name="rgtAnsr_CHOICE_${item.qstnSeqno}_${item.qstnCnddtSeqno}" id="rgtAnsr_${item.qstnSeqno}_${vwitm.qstnVwitmSeqno}" ${vwitm.cransYn eq 'Y' ? 'checked' : '' }>
									<label class="question ${item.qstnRspnsTycd eq 'MLT_CHC' ? 'multi' : '' } empl" data-value="${vwitm.qstnVwitmSeqno }">${vwitm.qstnVwitmCts}</label>
								</div>
							</div>
						</c:if>
					</c:forEach>
				</c:if>
       			<c:if test="${item.qstnRspnsTycd eq 'LONG_TEXT' }">
        			<textarea rows="3" name="desc${item.qstnId}" maxlength="500"></textarea>
       			</c:if>
				<c:if test="${item.qstnRspnsTycd eq 'LINK' }">
					<div class="line-sortable-box">
						<div class="account-list">
							<c:forEach var="vwitm" items="${qstnVwitmList }">
								<c:if test="${item.qstnId eq vwitm.qstnId }">
									<div class="line-box num0${vwitm.qstnVwitmSeqno }">
										<div class="question"><span><c:out value="${vwitm.qstnVwitmCts.split('[|]')[0]}" /></span></div>
										<div class="slot" name="link${item.qstnId }"></div>
									</div>
								</c:if>
							</c:forEach>
                        </div>
                        <div class="inventory-list w200">
                        	<c:forEach var="vwitm" items="${qstnVwitmList }">
                        		<c:if test="${item.qstnId eq vwitm.qstnId }">
	                        		<div class="slot" name="opposite${item.qstnId}"><span><i class="ion-arrow-move"></i><c:out value="${vwitm.qstnVwitmCts.split('[|]')[1]}" /></span></div>
                        		</c:if>
                        	</c:forEach>
                        </div>
					</div>
                    <script>
                        createSortable('${item.qstnId}');
                    </script>
 				</c:if>
       			<c:if test="${item.qstnRspnsTycd eq 'OX_CHC' }">
                    <div class="checkImg">
                    	<c:forEach var="vwitm" items="${qstnVwitmList }">
                    		<c:if test="${item.qstnId eq vwitm.qstnId }">
	                    		<c:set var="oxClass" value="${vwitm.qstnVwitmCts eq 'O' ? 'true' : 'false' }" />
	                    		<input id="oxChk${item.qstnId }_${oxClass}" type="radio" name="oxChk${item.qstnId }" value="${vwitm.qstnVwitmCts }" ${vwitm.cransYn eq 'Y' ? 'checked' : '' } />
	                    		<label class="imgChk ${oxClass }" for="oxChk${item.qstnId }_${oxClass}"></label>
                    		</c:if>
                    	</c:forEach>
                    </div>
       			</c:if>
				<c:if test="${item.qstnRspnsTycd eq 'SHORT_TEXT' }">
					<div class="equal width fields">
						<c:forEach var="vwitm" items="${qstnVwitmList }">
							<c:if test="${item.qstnId eq vwitm.qstnId }">
								<div class="field">
									<input type="text" name="short${item.qstnId }" value="${vwitm.qstnVwitmCts }" maxlength="40" placeholder="${vwitm.qstnVwitmSeqno }<spring:message code='exam.label.answer.no' />" /><!-- 번 답 -->
								</div>
							</c:if>
						</c:forEach>
					</div>
				</c:if>
			</div>
		</div>
	</c:forEach>
</div>