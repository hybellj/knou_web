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
		function createSortable() {
	        var invalid 	= false;
	        var $answers 	= $("div.slot[name=link], div.slot[name=opposite]");
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

	<body class="modal-page">
        <div id="wrap">
        	<table class="table-type1 margin-bottom-5">
        		<colgroup>
        			<col class="width-20per" />
        			<col class="" />
        		</colgroup>
				<tbody>
					<tr>
						<th class="text-center"><spring:message code="exam.label.categori" /></th><!-- 분류 -->
						<td>
							<c:if test="${not empty qbnkQstnVO.upCtgrnm }">
            					${qbnkQstnVO.upCtgrnm } >
            				</c:if>
            				${qbnkQstnVO.ctgrnm }
						</td>
					</tr>
					<tr>
						<th class="text-center"><spring:message code="exam.label.rep" /></th><!-- 담당 -->
						<td>${qbnkQstnVO.sbjctnm } > ${qbnkQstnVO.usernm } <spring:message code="exam.label.tch" /></td><!-- 교수 -->
					</tr>
				</tbody>
        	</table>

        	<div class="border-1 margin-bottom-3 qstnList">
        		<div class="board_top border-1 padding-3">
        			<span>${qbnkQstnVO.qstnSeqno }. ${qbnkQstnVO.qstnTtl }</span>
        		</div>
        		<div class="padding-3 margin-top-0">
        			<div class="margin-bottom-5">${qbnkQstnVO.qstnCts }</div>

					<!-- 서술형 -->
					<c:if test="${qbnkQstnVO.qstnRspnsTycd eq 'LONG_TEXT' }">
						<textarea style="width:100%;height:70px" maxLenCheck="byte,4000,true,true"></textarea>
		            </c:if>

			        <!-- 단일, 다중선택형 -->
			        <c:if test="${qbnkQstnVO.qstnRspnsTycd eq 'ONE_CHC' || qbnkQstnVO.qstnRspnsTycd eq 'MLT_CHC' }">
				       	<c:forEach var="item" items="${qbnkQstnVwitmList }">
						    <div class="margin-bottom-3">
						    	<span class="custom-input">
									<input type="${qbnkQstnVO.qstnRspnsTycd eq 'ONE_CHC' ? 'radio' : 'checkbox' }" name="vwitmSeqno" id="vwitmSeqno${item.vwitmSeqno }">
									<label for="vwitmSeqno${item.vwitmSeqno }">${item.vwitmSeqno}. ${item.vwitmCts }</label>
								</span>
						    </div>
				       	</c:forEach>
			        </c:if>
			        <!-- 단답형 -->
			        <c:if test="${qbnkQstnVO.qstnRspnsTycd eq 'SHORT_TEXT' }">
				       	<c:forEach var="item" items="${qbnkQstnVwitmList }">
					    	<input type="text" class="width-100per" name="vwitmCts" inputmask="byte" maxLen="4000" placeholder="${item.vwitmSeqno }번 답">
				       	</c:forEach>
			        </c:if>
			        <!-- OX선택형 -->
			        <c:if test="${qbnkQstnVO.qstnRspnsTycd eq 'OX_CHC' }">
				       	<c:forEach var="item" items="${qbnkQstnVwitmList }">
					    	<span class="custom-input">
								<input type="radio" name="vwitmSeqno" id="vwitmSeqno${item.vwitmSeqno }">
								<label for="vwitmSeqno${item.vwitmSeqno }">${item.vwitmCts }</label>
							</span>
				       	</c:forEach>
			        </c:if>
			        <!-- 연결형 -->
			        <c:if test="${qbnkQstnVO.qstnRspnsTycd eq 'LINK' }">
				       	<div class="line-sortable-box flex">
							<div class="account-list width-50per">
								<c:forEach var="item" items="${qbnkQstnVwitmList }">
									<div class="line-box border-1 margin-bottom-3 padding-3 flex">
										<div class="question width-30per"><span><c:out value="${item.vwitmCts.split('[|]')[0]}" /></span></div>
										<div class="slot margin-left-auto border-1 text-center width-100per" style="height:30px;" name="link"></div>
									</div>
								</c:forEach>
			                </div>
			                <div class="inventory-list w200 margin-left-auto">
			                	<c:forEach var="item" items="${qbnkQstnVwitmList }">
				                	<div class="slot border-1 text-center width-100per margin-bottom-3" style="height:30px;" name="opposite">
				                		<span><i class="xi-arrows"></i><c:out value="${item.vwitmCts.split('[|]')[1]}" /></span>
				                	</div>
			                	</c:forEach>
			                </div>
						 </div>
		                <script>
		                    createSortable('${item.qstnId}');
		                </script>
			        </c:if>
        		</div>
        	</div>

			<div class="btns">
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
			</div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
