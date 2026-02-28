<%@page import="knou.framework.common.SessionInfo"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
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
    </head>
    
    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	
	<script type="text/javascript">
		function createSortable() {
	        var invalid 	= false;
	        var $answers 	= $("div.slot[name=match], div.slot[name=opposite]");
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

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
            <ul class="tbl dt-sm">
            	<li>
            		<dl>
            			<dt><spring:message code="exam.label.categori" /></dt><!-- 분류 -->
            			<dd>
            				${vo.parExamCtgrNm}
            				<c:if test="${not empty vo.parExamQbankCtgrCd}">
	            				 > ${vo.examCtgrNm }
            				</c:if>
            			</dd>
            		</dl>
            	</li>
            	<li>
            		<dl>
            			<dt><spring:message code="exam.label.rep" /></dt><!-- 담당 -->
            			<dd>${vo.crsNm } > ${vo.userNm } <spring:message code="exam.label.tch" /></dd><!-- 교수 -->
            		</dl>
            	</li>
            </ul>
            <div class="ui form qstnList mt10">
            	<div class="ui card wmax">
		            <div class="fields content header2">
		                <div class="field wf100 ">
		                    <span><spring:message code="exam.label.qstn" /><!-- 문제 -->.</span> ${vo.title }
		                </div>
		            </div>
		            <div class="content">
		                <div class="mb20">${vo.qstnCts}</div>
		                
		                <div class="ui divider"></div>                        
		                    
		                <c:if test="${vo.qstnTypeCd eq 'CHOICE' || vo.qstnTypeCd eq 'MULTICHOICE' }">
							<c:forEach var="emplItem" step="1" begin="1" end="${vo.emplCnt}">
								<c:set var="qstnNo" value="${vo.qstnNo}"/>
								<c:set var="empl" value="empl${emplItem }" />
								<div class="field" id="emplLi_${qstnNo}_${emplItem}">
									<div class="ui checkbox">
										<input type="${vo.qstnTypeCd eq 'MULTICHOICE' ? 'checkbox' : 'radio'}" name="rgtAnsr_CHOICE_${qstnNo}" id="rgtAnsr_${qstnNo}_${emplItem}">
										<label class="question ${vo.qstnTypeCd eq 'MULTICHOICE' ? 'multi' : '' } empl" data-value="${emplItem }">${vo[empl]}</label>
									</div>
								</div>
							</c:forEach>
	                    </c:if>
	                    <c:if test="${vo.qstnTypeCd eq 'SHORT' }">
			                <div class="equal width fields">
			                	<c:set var="ansrCnt" value="5" />
			                	<c:forEach var="idx" begin="1" end="5" step="1">
			                		<c:set var="rgtAnsr" value="rgtAnsr${idx }" />
			                		<c:if test="${fn:length(vo[rgtAnsr]) ne 0 }"><c:set var="ansrCnt" value="${idx }" /></c:if>
			                	</c:forEach>
					            <c:forEach var="idx" begin="1" end="${ansrCnt}" step="1">
					                <div class="field">
					                    <input type="text" name="short" maxlength="40" placeholder="${idx}<spring:message code='exam.label.answer.no' />"><!-- 번 답 -->
					                </div>
					            </c:forEach>
			                </div>
	                    </c:if>
	                    <c:if test="${vo.qstnTypeCd eq 'DESCRIBE' }">
						    <textarea rows="3" name="desc" maxlength="500"></textarea>
	                    </c:if>
	                    <c:if test="${vo.qstnTypeCd eq 'OX' }">
		                    <div class="checkImg">
		                        <input id="oxChk_true" type="radio" name="oxChk" value="1">
		                        <label class="imgChk true" for="oxChk_true"></label>
		                        <input id="oxChk_false" type="radio" name="oxChk" value="2">
		                        <label class="imgChk false" for="oxChk_false"></label>
		                    </div>
	                    </c:if>
	                    <c:if test="${vo.qstnTypeCd eq 'MATCH' }">
						    <div class="line-sortable-box">
		                        <div class="account-list">
		                    		<c:forEach var="emplItem" begin="1" end="${vo.emplCnt}" varStatus="idx">
		                    			<c:set var="empl" value="empl${emplItem }" />
						                <div class="line-box num0${emplItem }">
			                                <div class="question"><span><c:out value='${vo[empl]}' /></span></div>
				                            <div class="slot" name="match"></div>
			                            </div>
		                    		</c:forEach>
		                        </div>
		                        <div class="inventory-list w200">
						            <c:forEach items="${fn:split(vo.rgtAnsr1,',')}" var="opposite" varStatus="idx">
						                <div class="slot" name="opposite"><span><i class="ion-arrow-move"></i><c:out value='${opposite}' /></span></div>
						            </c:forEach>
		                        </div>
		                    </div>
		                    <script>
		                        createSortable('${item.examQstnSn}');
		                    </script>
	                    </c:if>
		            </div>
		        </div>
            </div>
            
            <div class="bottom-content">
                <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
