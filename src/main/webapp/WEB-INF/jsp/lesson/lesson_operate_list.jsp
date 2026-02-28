<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common_no_jquery.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
$(document).ready(function(){
	/*
	if(typeof displayCount == 'function') {
		displayCount('${pageInfo.totalRecordCount}');
	}
	*/
});

function viewLessonPlan(crsCreCd) {
	var url = "/logLesson/saveLessonActnHsty.do";
	var data = {
		  actnHstyCd	: "LECTURE_HOME"
		, actnHstyCts	: "<spring:message code='common.label.class.plan' /> <spring:message code='common.label.connect' />"// 수업계획서 접속
	};
	
	ajaxCall(url, data, function(data) {
		if(data.result > 0) {
			var url = "/lesson/lessonNone/lessonPlanPopUrl.do";
			var data = {
				crsCreCd : crsCreCd
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var goUrl = data.returnVO.goUrl;
					window.open(goUrl, "lessonPLan", "scrollbars=yes,width=900,height=950,location=no,resizable=yes");
				} else {
					alert(data.message);
				}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			});
			var goUrl = "<%=SessionInfo.getLessonPlanUrl(request)%>";
			console.log(goUrl);
			return false;
			window.open(goUrl, "lessonPLan", "scrollbars=yes,width=900,height=950,location=no,resizable=yes");
		} else {
			alert(data.message);
		}
	}, function(xhr, status, error) {
		alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
	});
} 

//엑셀 업로드
function fnExcelDownLoad(){
    var excelGrid = {
          colModel:[
                   {label:'<spring:message code="common.number.no"/>',          name:'lineNo', align:'center', width:'1000'},                                               <%-- No. --%>
                   {label:'<spring:message code="review.label.crscre.dept"/>',  name:'deptNm', align:'center',   width:'3000'},                                             <%-- 개설학과 --%>
                   {label:'<spring:message code="review.label.crscd"/>',        name:'crsCd', align:'left',   width:'3000'},                                                <%-- 학수번호 --%>
                   {label:'<spring:message code="review.label.crscrenm"/> (<spring:message code="review.label.decls"/>)',   name:'crsCreNm', align:'left',   width:'4000'}, <%-- 과목명 (분반) --%>
                   {label:'<spring:message code="user.title.tch.professor"/>',  name:'majorUserNm', align:'left',   width:'3000'},                                          <%-- 교수명 --%>
                   {label:'<spring:message code="user.title.tch.tutor" />',     name:'minorUserNm', align:'left',   width:'3000'},                                          <%-- 조교명 --%>
                   {label:'<spring:message code="std.label.learner"/>',         name:'stdCnt', align:'right', width:'4000'},                                                <%-- 수강생 --%>               
                   {label:'<spring:message code="dashboard.course_qna"/>',      name:'qnaInfo', align:'right', width:'4000'},                                               <%-- 강의Q&A--%>           
                   {label:'<spring:message code="asmnt.label.marks.grade"/>',   name:'asmntInfo', align:'right', width:'4000'},                                             <%-- 과제채점 --%>         
                   {label:'<spring:message code="quiz.label.marks.grade"/>',    name:'quizInfo', align:'right', width:'4000'},                                              <%-- 퀴즈채점 --%>             
                   {label:'<spring:message code="forum.label.marks.grade"/>',   name:'forumInfo', align:'right', width:'4000'},                                             <%-- 토론채점 --%>    
                   {label:'<spring:message code="crs.label.mid_exam" /><spring:message code="exam.label.dttm"/>',   name:'middleInfo', align:'left', width:'4000'},         <%-- 중간고사 --%>               
                   {label:'<spring:message code="crs.label.final_exam" /><spring:message code="exam.label.dttm"/>',   name:'lastInfo', align:'left', width:'4000'}          <%-- 기말고사 --%>           
                   ]
        };
    
     var haksaYear = $("#termCd option:selected").val();
     var haksaTerm = $("#uniCd option:selected").val();
     var crsCreCd = $("#crsCreCd option:selected").val();
     
     var crsTypeCdList = [];
     if (tabOrder != '5') {
     
         $.each($("[data-crs-type-cd]"), function(){
             var crsTypeCd = $(this).data("crsTypeCd");
             
             if($(this).hasClass("active")) {
                 crsTypeCdList.push(crsTypeCd);
             }
         });
     }   
     
     var paramData = {
         "termCd"            : $("#termCd").val()
         , "uniCd"           : $("#uniCd").val()
         , "deptCd"          : ($("#deptCd").val() || "").replace("all", "")
         , "progressCd"  : $("#progressCd").val()
         , "searchValue" : $("#searchValue").val()
     };

     if (tabOrder != '5') {

         if(crsTypeCdList.length > 0) {
             paramData.crsTypeCds = crsTypeCdList.join(",");
         }
     }

     var excelForm = $('<form></form>');
     excelForm.attr("name","excelForm");
     excelForm.attr("action","/exam/examMgr/industryConLearningExcel.do");
     excelForm.append($('<input/>', {type: 'hidden', name: 'haksaYear', value: haksaYear}));
     excelForm.append($('<input/>', {type: 'hidden', name: 'haksaTerm', value: haksaTerm}));
     excelForm.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: crsCreCd}));
     excelForm.append($('<input/>', {type: 'hidden', name: 'excelGrid', value: JSON.stringify(excelGrid)}));
     excelForm.appendTo('body');
     excelForm.submit();      
}
</script>

<body>

    <div class="option-content gap4 mt10 mb10">   
        <div class="flex gap4 mra">
            <div class="sec_head"><spring:message code="crs.label.open.crs" /></div><!-- 개설과목 -->
            <!--
            <div class="fcGrey">[ &nbsp;<span id="count">0</span>&nbsp; ]</div>
             <div class="fcRed">[ +7 ]</div> 
             -->
        </div>
        <div class="">
            <a class="ui basic small button"><i class="paper plane outline icon"></i><spring:message code="common.button.message" /></a><!-- 메시지 -->
            <a class="ui basic small button" onclick="fnExcelDownLoad();"><i class="download icon"></i><spring:message code="exam.button.excel.down" /></a><!-- 엑셀 다운로드 -->
        </div>
    </div>
    <table class="tBasic mt10 f080" style="min-width:1540px">
        <thead class="sticky top0">
            <tr>
                <th scope="col" data-type="number" class="num "><spring:message code="common.number.no" /></th><!-- NO. -->
                <%-- <th scope="col" data-breakpoints="xs"><spring:message code="bbs.label.type" /></th> --%><!-- 구분 -->
                <th scope="col" data-breakpoints="xs"><spring:message code="review.label.crscre.dept" /></th><!-- 개설학과 -->
                <th scope="col" data-breakpoints="xs sm md"><spring:message code="review.label.crscd" /></th><!-- 학수번호 -->
                <th scope="col" data-breakpoints="xs sm md"><spring:message code="review.label.crscrenm" /> (<spring:message code="review.label.decls" />)</th><!-- 과목명 (분반) -->
                <th scope="col" data-breakpoints="xs sm md"><spring:message code="user.title.tch.professor" /></th><!-- 교수 -->
                <th scope="col" data-breakpoints="xs sm md"><spring:message code="user.title.tch.tutor" /></th><!-- 조교 -->
                <th scope="col" data-breakpoints="xs sm md"><spring:message code="common.label.class.plan" /></th><!-- 수업계획서 -->
                <th scope="col" data-breakpoints="xs sm md"><spring:message code="std.label.learner" /></th><!-- 수강생 -->
                <th scope="col" data-breakpoints="xs sm md"><spring:message code="dashboard.course_qna" /></th><!-- 강의Q&A -->
                <!-- <th scope="col" data-breakpoints="xs sm md"><spring:message code="dashboard.councel" /></th> 1:1상담 -->
                <th scope="col" data-breakpoints="xs sm md"><spring:message code="asmnt.label.marks.grade"/></th><!-- 과제채점 -->
                <th scope="col" data-breakpoints="xs sm md"><spring:message code="quiz.label.marks.grade"/></th><!-- 퀴즈채점 -->
                <th scope="col" data-breakpoints="xs sm md"><spring:message code="forum.label.marks.grade"/></th><!-- 토론채점 -->
                <!--<th scope="col" data-breakpoints="xs sm md"><spring:message code="replace.asmnt.label.marks"/></th> 대체과제 -->
                <th scope="col" data-breakpoints="xs sm md"><spring:message code="crs.label.mid_exam" /><br /><spring:message code="exam.label.dttm" /></th><!-- 중간고사 --><!-- 일자 -->
                <th scope="col" data-breakpoints="xs sm md"><spring:message code="crs.label.final_exam" /><br /><spring:message code="exam.label.dttm" /></th><!-- 기말고사 --><!-- 일자 -->
            </tr>
        </thead>
        <tbody>
			<c:choose>
				<c:when test="${not empty resultList}">
					<c:forEach items="${resultList}" var="result" varStatus="status">
			            <tr>
			                <td class="tc">${result.lineNo}</td>
			                <%-- <td>${result.orgNm}</td> --%>
			                <td>${result.deptNm}</td>
			                <td>${result.crsCd}</td>
			                <td>${result.crsCreNm}</td>
			                <td class="tc">${result.majorUserNm}</td>
			                <td class="tc">${result.minorUserNm}</td>
			                <td class="tc"><a href="#0" onclick="viewLessonPlan('${result.crsCreCd}');return false;" class="ui small blue button" title="수업계획서"><spring:message code="common.label.class.plan" /></a></td>
			                <td class="tr">${result.stdCnt} <spring:message code="message.person" /></td><!-- 명 -->
			                <td class="tr">${result.qnaAnsCnt}/${result.qnaCnt}</td>
			                <%-- <td>${result.secretAnsCnt}/${result.secretNoAnsCnt}/${result.secretCnt}</td> --%>
			                <td class="tr">${result.asmntEvalCnt}/${result.asmntSubmitCnt}</td>
			                <td class="tr">${result.quizEvalCnt}/${result.quizSubmitCnt}</td>
			                <td class="tr">${result.forumEvalCnt}/${result.forumSubmitCnt}</td>
			                <%-- <td>${result.altaskAsmntSubmtCnt}/${result.altaskForumAnsCnt}/${result.altaskExamAnsCnt}/${result.altaskCnt}</td> --%>
			                <td>
								<c:choose>
							    	<c:when test="${empty result.middleStartDttm}">
							        	<p>-</p>
							        </c:when>
							        <c:otherwise>
							            <p>${result.middleStartDttm} ${result.middleExamStareTm} <spring:message code="date.minute" /></p><!-- 분 -->
							        	<p>${result.middleScoreOpenNm}	${result.middleGradeViewNm}</p>
							        </c:otherwise>
							    </c:choose>
			                </td>
			                <td>
								<c:choose>
							    	<c:when test="${empty result.lastStartDttm}">
							        	<p>-</p>
							        </c:when>
							        <c:otherwise>
							            <p>${result.lastStartDttm} ${result.lastExamStareTm} <spring:message code="date.minute" /></p><!-- 분 -->
							        	<p>${result.lastScoreOpenNm}	${result.lastGradeViewNm}</p>
							        </c:otherwise>
							    </c:choose>
			                </td>
			            </tr>
					</c:forEach>
				</c:when>
				<c:otherwise>
	                <td colspan="26">
	                    <div class="none tc pt10">
	                        <span><spring:message code='common.nodata.msg'/></span><!-- 등록된 내용이 없습니다. -->
	                    </div>
	                </td>  				
				</c:otherwise>
			</c:choose>
        </tbody>
    </table>
    <!-- //테이블 -->
</body>
</html>