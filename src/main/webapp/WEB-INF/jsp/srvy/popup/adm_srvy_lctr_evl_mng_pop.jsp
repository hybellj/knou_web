<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
			<jsp:param name="style" value="admin"/>
			<jsp:param name="module" value="table"/>
		</jsp:include>
    </head>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<script type="text/javascript">
	</script>

	<body class="modal-body">
		<div class="msg-box basic fcBlue">
            <ul>
                <li><spring:message code="srvy.label.lctr.evl.info.1" /><!-- ! 강의평가 팝업관리 설정할 경우 --></li>
                <li><spring:message code="srvy.label.lctr.evl.info.2" /><!-- - 강의평가 기간 내에 강의평가에 참여하지 않은 학습자의 대시보드에 강의평가 설문 팝업을 띄웁니다. --></li>
                <li><spring:message code="srvy.label.lctr.evl.info.3" /><!-- - 강의평가 미참여시 설정 주차의 수강을 제한 합니다. --></li>
            </ul>
        </div>
        <div class="table-wrap">
            <table class="table-type2">
                <colgroup>
                    <col style="width:20%">
                    <col style="">
                </colgroup>
                <thead>
	                <tr>
	                    <th colspan="2" class="text-left"><spring:message code="srvy.label.lctr.evl.ttl" /><!-- 강의평가 제목 --> : <c:out value="${vo.srvyTtl }" /></th>
	                </tr>
	            </thead>
	            <tbody>
	                <tr>
	                    <th>
	                    	<c:choose>
	                    		<c:when test="${fn:contains(vo.srvyTycd, 'MIDEXAM') }">
	                    			<spring:message code="srvy.label.mid.exam" /><!-- 중간고사 -->
	                    		</c:when>
	                    		<c:otherwise>
	                    			<spring:message code="srvy.label.lst.exam" /><!-- 기말고사 -->
	                    		</c:otherwise>
	                    	</c:choose>
	                    	<spring:message code="srvy.common.lctr.evl" /><!-- 강의평가 -->
	                    </th>
	                    <td class="text-left">
	                    	<div class="margin-3">
		                    	<span class="custom-input">
									<input type="radio" name="lctrTycd" id="lctrN" value="N" checked>
									<label for="lctrN"><spring:message code="srvy.label.not.use" /><!-- 사용안함 --></label>
								</span>
	                    	</div>
	                    	<div class="margin-3">
		                    	<span class="custom-input">
									<input type="radio" name="lctrTycd" id="lctr1" value="1">
									<label for="lctr1">1<spring:message code="common.week" /><!-- 주차 --></label>
								</span>
		                    	<span class="custom-input">
									<input type="radio" name="lctrTycd" id="lctr2" value="2">
									<label for="lctr2">2<spring:message code="common.week" /><!-- 주차 --></label>
								</span>
		                    	<span class="custom-input">
									<input type="radio" name="lctrTycd" id="lctr3" value="3">
									<label for="lctr3">3<spring:message code="common.week" /><!-- 주차 --></label>
								</span>
		                    	<span class="custom-input">
									<input type="radio" name="lctrTycd" id="lctr4" value="4">
									<label for="lctr4">4<spring:message code="common.week" /><!-- 주차 --></label>
								</span>
		                    	<span class="custom-input">
									<input type="radio" name="lctrTycd" id="lctr5" value="5">
									<label for="lctr5">5<spring:message code="common.week" /><!-- 주차 --></label>
								</span>
		                    	<span class="custom-input">
									<input type="radio" name="lctrTycd" id="lctr6" value="6">
									<label for="lctr6">6<spring:message code="common.week" /><!-- 주차 --></label>
								</span>
		                    	<span class="custom-input">
									<input type="radio" name="lctrTycd" id="lctr7" value="7">
									<label for="lctr7">7<spring:message code="common.week" /><!-- 주차 --></label>
								</span>
	                    	</div>
	                    	<div class="margin-3">
		                    	<span class="custom-input">
									<input type="radio" name="lctrTycd" id="lctr9" value="9">
									<label for="lctr9">9<spring:message code="common.week" /><!-- 주차 --></label>
								</span>
		                    	<span class="custom-input">
									<input type="radio" name="lctrTycd" id="lctr10" value="10">
									<label for="lctr10">10<spring:message code="common.week" /><!-- 주차 --></label>
								</span>
		                    	<span class="custom-input">
									<input type="radio" name="lctrTycd" id="lctr11" value="11">
									<label for="lctr11">11<spring:message code="common.week" /><!-- 주차 --></label>
								</span>
		                    	<span class="custom-input">
									<input type="radio" name="lctrTycd" id="lctr12" value="12">
									<label for="lctr12">12<spring:message code="common.week" /><!-- 주차 --></label>
								</span>
		                    	<span class="custom-input">
									<input type="radio" name="lctrTycd" id="lctr13" value="13">
									<label for="lctr13">13<spring:message code="common.week" /><!-- 주차 --></label>
								</span>
		                    	<span class="custom-input">
									<input type="radio" name="lctrTycd" id="lctr14" value="14">
									<label for="lctr14">14<spring:message code="common.week" /><!-- 주차 --></label>
								</span>
		                    	<span class="custom-input">
									<input type="radio" name="lctrTycd" id="lctrScr" value="SCR">
									<label for="lctrScr"><spring:message code="common.check.grades" /><!-- 성적확인 --></label>
								</span>
	                    	</div>
	                    </td>
	                </tr>
                </tbody>
            </table>
        </div>

		<div class="modal_btns">
	    	<button class="btn type2"><spring:message code="srvy.button.save" /><!-- 저장 --></button>
	    	<button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="srvy.button.close" /></button><!-- 닫기 -->
		</div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>