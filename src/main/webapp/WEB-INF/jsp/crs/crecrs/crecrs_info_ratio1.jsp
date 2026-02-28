<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<script type="text/javascript" src="/webdoc/js/common_admin.js"></script>
</head>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
  
<script type="text/javascript">
  $(document).ready(function() { 
	  fn_rateType($('input[name="scoreEvalType"]:checked').val());
	  fn_gradeType('${courseVO.scoreGradeType}');
 });
  
 function fn_rateType(rateType){
	if(rateType=='PF'){
		$("#pfSection").show();	
		$("#npfSection1").hide();
		$("#npfSection2").hide();
	}else{
		$("#npfSection1").show();
		$("#npfSection2").show();
		
		var radioVal = $("input[name='scoreGradeType']:checked").val();
		
		if(radioVal=='FIXED'){
			$("#npfSection2-1").show();
			$("#npfSection2-2").hide();
		}
		if(radioVal=='RATIO'){
			$("#npfSection2-1").hide();
			$("#npfSection2-2").show();
		}
		$("#pfSection").hide();	
	}
}
 
function fn_gradeType(gradeType){
	if(gradeType=='FIXED'){
		$("#npfSection2-1").show();
		$("#npfSection2-2").hide();
	}
	if(gradeType=='RATIO'){
		$("#npfSection2-1").hide();
		$("#npfSection2-2").show();
	}
}
</script>

 <ul class="tbl">
     <li>
         <dl>
             <dt><label for="scoreRateLabel"><spring:message code="crs.title.evaluation.method"/></label></dt> <!-- 평가 방법 -->
             <dd>
                 <div class="inline fields mb0">
                     <div class="field">
                         <div class="ui radio checkbox">
                             <input type="radio" name="scoreEvalType" onchange="fn_rateType('RELATIVE')" class="hidden"  value="RELATIVE" <c:choose><c:when test="${creCrsVo.scoreEvalType eq 'RELATIVE'}">checked</c:when><c:otherwise>checked</c:otherwise></c:choose>>
                             <label><spring:message code="crs.relative.evaluation"/></label> <!-- 상대평가 -->
                         </div>
                     </div>
                     <div class="field">
                         <div class="ui radio checkbox">
                             <input type="radio" name="scoreEvalType" onchange="fn_rateType('ABSOLUTE')" class="hidden"  value="ABSOLUTE" <c:if test="${creCrsVo.scoreEvalType eq 'ABSOLUTE'}">checked</c:if>>
                             <label><spring:message code="crs.absolute.evaluation"/></label> <!-- 절대평가 -->
                         </div>
                     </div>
                     <div class="field">
                         <div class="ui radio checkbox">
                             <input type="radio" name="scoreEvalType" onchange="fn_rateType('PF')" class="hidden"  value="PF" <c:if test="${creCrsVo.scoreEvalType eq 'PF'}">checked</c:if>>
                             <label><spring:message code="crs.title.pass.fail"/></label> <!-- P/F -->
                         </div>
                     </div> 
                 </div>
             </dd>
         </dl>
     </li>
     <li id="npfSection1">
         <dl>
             <dt><label for="rateLabel"><spring:message code="crs.contigent.valuation.method"/></label></dt> <!-- 비율부여방법 -->
             <dd>
                 <div class="inline fields mb0">
                     <div class="field">
                         <div class="ui radio checkbox">
                            <input type="radio" name="scoreGradeType" onchange="fn_gradeType('FIXED')" class="hidden" <c:choose><c:when test="${creCrsVo.scoreGradeType eq 'FIXED'}">checked</c:when><c:otherwise>checked</c:otherwise></c:choose> value="FIXED"> 
                             <label><spring:message code="common.fixed"/></label> <!-- 고정 -->
                         </div>
                     </div>
                     <div class="field">
                         <div class="ui radio checkbox">
                            <input type="radio" name="scoreGradeType" onchange="fn_gradeType('RATIO')"  class="hidden" <c:if test="${creCrsVo.scoreGradeType eq 'RATIO'}">checked</c:if> value="RATIO"> 
                             <label><spring:message code="crs.title.distribution"/></label> <!-- 분포 -->
                         </div>
                     </div>
                 </div>
             </dd>
         </dl>
     </li>
     <li id="npfSection2">
         <dl>
             <dt><label for="scoreGradeLabel" class="req"><spring:message code="crs.socre.grade"/></label></dt> <!-- 성적등급 -->
             <dd>
                 <div class="inline fields" id="npfSection2-1">
                     <div class="field">
                         <div class="ui left labeled input">
                             <label class="ui basic label">A</label>
                             <input type="text" name="fixedA" id="fixedA" class="w60" maxlength="3" placeholder="%" value="${creCrsVo.fixedA}" onkeyup="chkIsNan(this)">
                         </div>
                     </div>
                     <div class="field">
                         <div class="ui left labeled input">
                             <label class="ui basic label">B</label>
                             <input type="text" name="fixedB" id="fixedB" class="w60" maxlength="3" placeholder="%" value="${creCrsVo.fixedB}">
                         </div>
                     </div>
                     <div class="field">
                         <div class="ui left labeled input">
                             <label class="ui basic label">C</label>
                             <input type="text" name="fixedC" id="fixedC" class="w60" maxlength="3" placeholder="%" value="${creCrsVo.fixedC}">
                         </div>
                     </div>
                     <div class="field">
                         <div class="ui left labeled input">
                             <label class="ui basic label">D</label>
                             <input type="text" name="fixedD" id="fixedD" class="w60" maxlength="3" placeholder="%" value="${creCrsVo.fixedD}">
                         </div>
                     </div>
                     <div class="field">
                         <div class="ui left labeled input">
                             <label class="ui basic label">F</label>
                             <input type="text" name="fixedF" id="fixedF" class="w60" maxlength="3" placeholder="%" value="${creCrsVo.fixedF}">
                         </div>
                     </div>
                 </div>
                 <div class="inline fields mb0" id="npfSection2-2">
                     <div class="field">
                         <div class="ui left labeled input">
                             <label class="ui basic label">A</label>
                             <input type="text" name="ratioA1" id="ratioA1" class="w60" maxlength="3" placeholder="%" value="${creCrsVo.ratioA1}">
                         </div>
                     </div>
                     <span class="time-sort">~</span>
                     <div class="field">
                         <div class="ui left labeled input">
                             <label class="ui basic label">B</label>
                             <input type="text" name="ratioA2" id="ratioA2" class="w60" maxlength="3" placeholder="%" value="${creCrsVo.ratioA2}">
                         </div>
                     </div>
                     <div class="field">
                         <div class="ui left labeled input">
                             <label class="ui basic label">A+B</label>
                             <input type="text" name="ratioB" id="ratioB" class="w60" maxlength="3" placeholder="%" value="${creCrsVo.ratioB}">
                         </div>
                         <span><spring:message code="crs.title.within"/></span> <!-- 이내 -->
                     </div>
                 </div>
             </dd>
         </dl>
     </li>
     <li id="pfSection">
         <dl>
             <dt><label for="passLabel" class="req"><spring:message code="crs.common.pass.point"/></label></dt> <!-- 통과점수 -->
             <dd>
                 <div class="inline fields mb0">
                     <div class="field">
                         <div class="ui input">
                             <input type="text" id="passScore" name="passScore" class="w100" maxlength="3" value="${creCrsVo.passScore}">
                         </div>
                         <span><spring:message code="message.score"/></span> <!-- 점 -->
                     </div>
                 </div>
             </dd>
         </dl>
     </li>
 </ul>
</html>