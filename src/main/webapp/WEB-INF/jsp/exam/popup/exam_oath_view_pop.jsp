<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    </head>
    
    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	
	<script type="text/javascript">
		// 서약서 제출
		function submitOath() {
			var oathAllLen = $("input[name=oathChk]").length;
			var oathChkLen = $("input[name=oathChk]:checked").length;
			if(oathAllLen == oathChkLen) {
				var url  = "/exam/submitOath.do";
	    		var data = $("#examOathSubmitForm").serialize();
	    		
	    		ajaxCall(url, data, function(data) {
	    			if (data.result > 0) {
	    				alert("<spring:message code='exam.alert.oath.submit' />");/* 서약서 제출이 완료되었습니다. */
	    				window.parent.closeModal();
	                } else {
	                 	alert(data.message);
	                }
	    		}, function(xhr, status, error) {
	    			alert("<spring:message code='exam.error.oath.submit' />");/* 서약서 제출 중 에러가 발생하였습니다. */
	    		});
			} else {
				alert("<spring:message code='exam.error.oath.type.checked' />");/* 부정행위 해당 유형을 모두 확인해주세요. */
				return false;
			}
		}
	</script>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
		<form name="examOathSubmitForm" id="examOathSubmitForm">
			<input type="hidden" name="termCd"    value="${termVO.termCd }" />
			<input type="hidden" name="haksaYear" value="${termVO.haksaYear }" />
			<input type="hidden" name="haksaTerm" value="${termVO.haksaTerm }" />
			<input type="hidden" name="userId" 	  value="${stdVO.userId }" />
			<input type="hidden" name="midOath"   value="Y" />
			<input type="hidden" name="endOath"   value="Y" />
		</form>
        <div id="wrap">
        	<div class="info-item-box modal-txt">
        		<div class="page-title">
        			[ ${termVO.haksaYear }<spring:message code="exam.label.year" /><!-- 년 -->
        			<c:forEach var="code" items="${termList }">
        				<c:if test="${termVO.haksaTerm eq code.codeCd }">${code.codeNm }</c:if>
        			</c:forEach>
        			<spring:message code="exam.label.real.time.exam" /><!-- 실시간시험 --> <spring:message code="exam.label.oath" /><!-- 서약서 --> ]
        		</div>
	        	<c:if test="${vo.searchKey ne 'VIEW' }">
			        <div class="mla fcBlue">
			        	${stdVO.deptNm } ${stdVO.userId } ${stdVO.userNm }
			        </div>
	        	</c:if>
        	</div>
        	<div class="ui form">
		        <div class="ui segment">
		            <p class="bullet_design1">
		            	<spring:message code="exam.label.oath.warning.title.msg1" /><!-- 실시간 시험에서 아래 사항을 부정행위로 간주하여, 부정행위를 한 학생은 -->
		                <span class="fcRed"><spring:message code="exam.label.oath.warning.title.msg2" /></span><!-- 성적평가 규정 제9조(성적정정 및 취소)에 따라, 성적이 취소될 수 있으며, 학생상벌 규정에 따라 엄격한 처벌 -->
		                <spring:message code="exam.label.oath.warning.title.msg3" /><!-- 을 받을 수 있습니다. -->
		            </p>
		            <p class="bullet_design1 mt4">
		                <spring:message code="exam.label.oath.warning.title.msg4" /><!-- 아래 내용을 확인 후 동의해 주시기 바랍니다. -->
		            </p>
		        </div>
		        <div class="ui error message">
		            <i class="icon circle info"></i><spring:message code="exam.label.oath.warning.title.msg5" /><!-- 부정행위는 학습 기회를 스스로 포기하는 것과 같습니다. KNOU 한사인의 양심 및 자긍심을 지킵시다. -->
		        </div>
		    </div>
		    <div class="ui form mt30 qstnList">
		        <div class="ui card wmax">
		            <div class="fields content header2">
		                <div class="field wf100 ">
		                    <span class="f110"><spring:message code="exam.label.oath.warning.msg1" /></span><!-- 부정행위 해당 유형 -->
		                </div>
		            </div>
		            <div class="content">
		                <div class="field">
		                    <div class="ui checkbox">
		                        <input type="checkbox" name="oathChk" id="aoth1" tabindex="0" class="hidden" ${vo.searchKey eq 'VIEW' ? 'checked' : ''}>
		                        <label class="question empl" for="aoth1"><spring:message code="exam.label.oath.warning.msg2" /><!-- 시험도중 단축키를 사용하거나 메신저 등 타 응용프로그램을 이용하는 행위 --></label>
		                    </div>
		                </div>                
		                <div class="field">
		                    <div class="ui checkbox">
		                        <input type="checkbox" name="oathChk" id="aoth2" tabindex="0" class="hidden" ${vo.searchKey eq 'VIEW' ? 'checked' : ''}>
		                        <label class="question empl" for="aoth2"><spring:message code="exam.label.oath.warning.msg3" /><!-- 키보드를 조작하거나 기타 프로그램을 실행시키는 행위 --></label>
		                    </div>
		                </div>
		                <div class="field">
		                    <div class="ui checkbox checked">
		                        <input type="checkbox" name="oathChk" id="aoth3" tabindex="0" class="hidden" ${vo.searchKey eq 'VIEW' ? 'checked' : ''}>
		                        <label class="question empl" for="aoth3"><spring:message code="exam.label.oath.warning.msg4" /><!-- 이중 로그인(아이디 공유)을 하는 행위 --></label>
		                    </div>
		                </div>
		                <div class="field">
		                    <div class="ui checkbox">
		                        <input type="checkbox" name="oathChk" id="aoth4" tabindex="0" class="hidden" ${vo.searchKey eq 'VIEW' ? 'checked' : ''}>
		                        <label class="question empl" for="aoth4"><spring:message code="exam.label.oath.warning.msg5" /><!-- 학번(ID,PASSWORD)를 임대 증여해서 대리로 시험을 응시한 행위 --></label>
		                    </div>
		                </div>                
		                <div class="field">
		                    <div class="ui checkbox checked">
		                        <input type="checkbox" name="oathChk" id="aoth5" tabindex="0" class="hidden" ${vo.searchKey eq 'VIEW' ? 'checked' : ''}>
		                        <label class="question empl" for="aoth5"><spring:message code="exam.label.oath.warning.msg6" /><!-- 동일 장소에서 동일과목, 동일 시간대에 2인	이상이 시험을 응시한 행위 --></label>
		                    </div>
		                </div>
		                <div class="field">
		                    <div class="ui checkbox checked">
		                        <input type="checkbox" name="oathChk" id="aoth6" tabindex="0" class="hidden" ${vo.searchKey eq 'VIEW' ? 'checked' : ''}>
		                        <label class="question empl" for="aoth6"><spring:message code="exam.label.oath.warning.msg7" /><!-- 시험시간을 준수하지 않고, 시간 외 입장을 요청하는 행위 --></label>
		                    </div>
		                </div>
		                <div class="field">
		                    <div class="ui checkbox checked">
		                        <input type="checkbox" name="oathChk" id="aoth7" tabindex="0" class="hidden" ${vo.searchKey eq 'VIEW' ? 'checked' : ''}>
		                        <label class="question empl" for="aoth7"><spring:message code="exam.label.oath.warning.msg8" /><!-- 시험평가에 고의로 응시하지 않고 결시원 증명을 위조하는 행위 --></label>
		                    </div>
		                </div>
		                <div class="field">
		                    <div class="ui checkbox checked">
		                        <input type="checkbox" name="oathChk" id="aoth8" tabindex="0" class="hidden" ${vo.searchKey eq 'VIEW' ? 'checked' : ''}>
		                        <label class="question empl" for="aoth8"><spring:message code="exam.label.oath.warning.msg9" /><!-- 기타 부정행위로 판단되는 행위 --></label>
		                    </div>
		                </div>
		            </div>
		        </div>
		        <div class="tc mt20 ">
		            <span class="line-txt">
		                <strong class="f110"><spring:message code="exam.label.oath.warning.msg10" /><!-- 한양사이버대학교 학생 -->
		                <span class="fcBlue">${stdVO.userNm }</span>
		                	<spring:message code="exam.label.oath.warning.msg11" /><!-- 은(는) 위의 사항에 준수하여 정정당당하게 시험에 임할 것이며, -->
		                </strong>
		            </span> 
		            <span class="line-txt">
		                <strong class="f110">
		                	<spring:message code="exam.label.oath.warning.msg12" /><!-- 위반 시에는 성적이 (취소)될 수 있으며, 학생 상벌 규정에 따라 엄정한(처벌)을 받을 수 있음을 명확히 알고 있음을 확인 합니다. -->
		                </strong>
		            </span>
		        </div>
		    </div>
            
            <div class="bottom-content mt50">
            	<c:choose>
            		<c:when test="${vo.searchKey eq 'VIEW' }">
		                <button class="ui blue button" onclick="history.back();"><spring:message code="exam.button.prev.view" /></button><!-- 이전화면으로 -->
            		</c:when>
            		<c:otherwise>
		                <button class="ui blue button" onclick="submitOath();"><spring:message code="exam.button.qstn.submit.answer" /></button><!-- 제출하기 -->
            		</c:otherwise>
            	</c:choose>
                <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
