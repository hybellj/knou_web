<head>
   	<script type="text/javascript">
		$(document).ready(function() {
		});

		// 연결형 문항 이벤트 추가
	    function linkQstnEvent(qstnId) {
	        var invalid 	= false;
	        var $containner = $("#linkContainer_" + qstnId);
	        var $answers 	= $containner.find(".slot");

	        $answers.sortable({
	            placeholder: "",
	            opacity: 0.7,
	            zIndex: 9999,
	            connectWith: ".inventory-list .slot, .account-list .slot",
	            containment: $containner,
	            helper: "clone",
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
<div class="qstnList">
	<c:forEach var="item" items="${qstnList }" varStatus="varStatus">
		<div class="board_top border-1 padding-3 margin-bottom-0">
			<c:choose>
				<c:when test="${item.qstnCnddtSeqno eq '1'}">
					<span><spring:message code="exam.label.qstn" /><!-- 문제 --> ${item.qstnSeqno}</span>
				</c:when>
				<c:otherwise>
					<span><spring:message code="exam.label.qstn" /><!-- 문제 --> ${item.qstnSeqno}-${item.qstnCnddtSeqno}</span>
				</c:otherwise>
			</c:choose>
		</div>
		<div class="padding-3 margin-top-0 border-1 margin-bottom-3">
			<div class="margin-bottom-5">${item.qstnCts }</div>
			<c:if test="${item.qstnRspnsTycd eq 'ONE_CHC' || item.qstnRspnsTycd eq 'MLT_CHC' }">
				<c:forEach var="vwitm" items="${qstnVwitmList }">
					<c:if test="${item.qstnId eq vwitm.qstnId }">
						<div class="margin-bottom-3">
							<span class="custom-input">
								<input type="${item.qstnRspnsTycd eq 'MLT_CHC' ? 'checkbox' : 'radio' }" name="qstn_${item.qstnId }" id="qstn_${item.qstnId }_${vwitm.qstnVwitmSeqno}" />
								<label for="qstn_${item.qstnId }_${vwitm.qstnVwitmSeqno}">${vwitm.qstnVwitmCts}</label>
							</span>
						</div>
					</c:if>
				</c:forEach>
			</c:if>
			<c:if test="${item.qstnRspnsTycd eq 'OX_CHC' }">
                <div class="checkImg">
                	<c:forEach var="vwitm" items="${qstnVwitmList }">
                		<c:if test="${item.qstnId eq vwitm.qstnId }">
                			<span class="custom-input">
                				<input type="radio" name="qstn_${item.qstnId }" id="qstn_${item.qstnId }_${vwitm.qstnVwitmSeqno}" />
                				<label for="qstn_${item.qstnId }_${vwitm.qstnVwitmSeqno}">${vwitm.qstnVwitmCts }</label>
                			</span>
                		</c:if>
                	</c:forEach>
                </div>
       		</c:if>
       		<c:if test="${item.qstnRspnsTycd eq 'SHORT_TEXT' }">
       			<div class="flex gap-2 margin-bottom-2">
       				<c:forEach var="vwitm" items="${qstnVwitmList }">
						<c:if test="${item.qstnId eq vwitm.qstnId }">
							<input type="text" class="width-15per" inputmask="byte" maxLen="4000" name="qstn_${item.qstnId }" value="" />
						</c:if>
					</c:forEach>
       			</div>
			</c:if>
			<c:if test="${item.qstnRspnsTycd eq 'LONG_TEXT' }">
				<textarea style="width:100%;height:100px" maxLenCheck="byte,4000,true,true" name="qstn_${item.qstnId }"></textarea>
	       	</c:if>
	       	<c:if test="${item.qstnRspnsTycd eq 'LINK' }">
	       		<div class="line-sortable-box flex" id="linkContainer_${item.qstnId }">
	       			<div class="account-list width-50per">
	       				<c:forEach var="vwitm" items="${qstnVwitmList }">
	       					<c:if test="${item.qstnId eq vwitm.qstnId }">
		       					<div class="line-box border-1 margin-bottom-3 padding-3 flex">
		       						<div class="question width-30per"><span><c:out value="${vwitm.qstnVwitmCts.split('[|]')[0]}" /></span></div>
		       						<div class="slot margin-left-auto border-1 text-center width-100per" style="height:30px;" name="link_${item.qstnId }"></div>
		       					</div>
	       					</c:if>
						</c:forEach>
	       			</div>
	       			<div class="inventory-list w200 margin-left-auto">
	       				<c:forEach var="vwitm" items="${qstnVwitmList }">
	                		<c:if test="${item.qstnId eq vwitm.qstnId }">
	                			<div class="slot border-1 text-center width-100per margin-bottom-3" style="height:30px;" name="opposite">
	                				<span><i class="xw-arrows"></i><c:out value="${vwitm.qstnVwitmCts.split('[|]')[1]}" /></span>
	                			</div>
	                		</c:if>
	                	</c:forEach>
	       			</div>
	       		</div>
	            <script>
	                linkQstnEvent('${item.qstnId}');
	            </script>
	 		</c:if>
		</div>
	</c:forEach>
</div>