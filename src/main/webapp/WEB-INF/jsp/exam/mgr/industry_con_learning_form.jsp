<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
 
 <!DOCTYPE html>
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
 
<script type="text/javascript">
$(document).ready(function(){
	//$('#crsCreCd').dropdown();
	fnLessonProgSearch();
 });

//학기 조회
fnHaksaTermSearch = function() {
	$("#haksaTerm option").remove();
	$("#crsCreCd option").remove();
	
	var data = { 
			haksaYear : $("#haksaYear").val() 
		};

    $.ajax({
        url : "/exam/examMgr/searchHaksaTerm.do"
        , type : "POST"
        , data : data
        , success:function(data) { 
        	  console.log(data);
        	  var option = "";
              if(data.returnList.length > 0){
            	  for (var i = 0; i < data.returnList.length; i++) {
                      option = "<option value='"+ data.returnList[i].haksaTermCd +"'>" + data.returnList[i].haksaTermNm +"</option>"
                      $("#haksaTerm").append(option);             		  
                  }
              }
              
              //$("#haksaTerm").dropdown('refresh');
              $("#haksaTerm").dropdown('clear');
              //$("#crsCreCd").dropdown('refresh');
              $("#crsCreCd").dropdown('clear');      
              if ($("#haksaYear").val() == $("#curYear").val()) {
            	  $("#haksaTerm").val($("#curTerm").val()).attr("selected", "selected");
              } else {
            	  $("#haksaTerm option:eq(0)").attr("selected", "selected");
              }
              //$("#crsCreCd option:eq(0)").attr("selected", "selected");
              fnCrsCreSearch();
          }
        , error: function (jqXHR) { 
        	  alert(jqXHR.responseText); 
          }
    });	
};

//과목 조회
fnCrsCreSearch = function() {
    if ($("#haksaTerm").val() == null || $("#haksaTerm").val() == '') {
        return;
    }
		
    $("#crsCreCd").empty();
	  
    var data = { 
    		haksaYear : $("#haksaYear").val() 
    		, haksaTerm : $("#haksaTerm").val()
    	};
    
    $.ajax({
        url : "/exam/examMgr/searchCreCrsNm.do"
        , type : "POST"
        , data : data
        , success:function(data) {
              console.log(data);
              if(data.returnList.length > 0){
                  $.each(data.returnList, function(i, o){
                      var option = "<option value='"+ o.crsCreCd +"'>" + o.crsCreNm +"</option>"
                      $("#crsCreCd").append(option);                     
                  });
              }
              fnLessonProgSearch();
          }
        , error: function (jqXHR) { 
              alert(jqXHR.responseText); 
          }
    });
};

//산업체 위탁생 학습 진행현황검색
fnLessonProgSearch = function() {
	//if ($("#haksaYear").val() == null || $("#haksaYear").val() == '') {
	//	return;
	//}
    //if ($("#haksaTerm").val() == null || $("#haksaTerm").val() == '') {
    //    return;
    //}
    //if ($("#crsCreCd").val() == null || $("#crsCreCd").val() == '') {
    //    return;
    //}    

    showLoading();
    
    var data = { 
            haksaYear : $("#haksaYear").val() 
            , haksaTerm : $("#haksaTerm").val()
            , crsCreCd : $("#crsCreCd").val()
        };
    
    $("#industryConLearningList").load(
    		"/exam/examMgr/industryConLearningList.do" 
    		, data
    		, function (){
    			hideLoading();
    		}
    );   

};


<%-- 엑셀 다운로드 --%>
function fnExcelDownLoad(){
	var excelGrid = {
	      colModel:[
	               {label:'<spring:message code="common.number.no"/>',   name:'lineNo', align:'center', width:'1000'},                                                          <%-- No. --%>
	               {label:'<spring:message code="exam.label.user.no"/>',   name:'userId', align:'center',   width:'3000'},                                                      <%-- 학번 --%>
	               {label:'<spring:message code="exam.label.usernm"/>',   name:'userNm', align:'left',   width:'3000'},                                                         <%-- 성명 --%>
	               {label:'<spring:message code="exam.label.tch.no"/>',   name:'userId', align:'left',   width:'3000'},                                                         <%-- 사번 --%>
	               {label:'<spring:message code="exam.label.haksu.no"/>',   name:'crsCd', align:'left',   width:'3000'},                                                        <%-- 학수번호 --%>
	               {label:'<spring:message code="exam.label.crs.nm"/>',   name:'crsCreNm', align:'left',   width:'3000'},                                                       <%-- 교과목명 --%>
	               {label:'<spring:message code="exam.label.lesson.one"/> ${lessonSchedule.oneWeekEndDt}' ,   name:'oneWeekResult', align:'left', width:'4000'},                <%-- 1차시 --%>                         
	               {label:'<spring:message code="exam.label.lesson.two"/> ${lessonSchedule.twoWeekEndDt}',   name:'twoWeekResult', align:'left', width:'4000'},                 <%-- 2차시 --%>               
	               {label:'<spring:message code="exam.label.lesson.three"/> ${lessonSchedule.threeWeekEndDt}',   name:'threeWeekResult', align:'left', width:'4000'},           <%-- 3차시 --%>           
	               {label:'<spring:message code="exam.label.lesson.four"/> ${lessonSchedule.fourWeekEndDt}',   name:'fourWeekResult', align:'left', width:'4000'},              <%-- 4차시 --%>         
	               {label:'<spring:message code="exam.label.lesson.five"/> ${lessonSchedule.fiveWeekEndDt}',   name:'fiveWeekResult', align:'left', width:'4000'},              <%-- 5차시 --%>             
	               {label:'<spring:message code="exam.label.lesson.six"/> ${lessonSchedule.sixWeekEndDt}',   name:'sixWeekResult', align:'left', width:'4000'},                 <%-- 6차시 --%>    
	               {label:'<spring:message code="exam.label.lesson.seven"/> ${lessonSchedule.sevenWeekEndDt}',   name:'sevenWeekResult', align:'left', width:'4000'},           <%-- 7차시--%>               
	               {label:'<spring:message code="exam.label.lesson.eight"/> ${lessonSchedule.eightWeekEndDt}',   name:'eightWeekResult', align:'left', width:'4000'},           <%-- 8차시 --%>           
	               {label:'<spring:message code="exam.label.lesson.nine"/> ${lessonSchedule.nineWeekEndDt}',   name:'nineWeekResult', align:'left', width:'4000'},              <%-- 9차시 --%>         
	               {label:'<spring:message code="exam.label.lesson.ten"/> ${lessonSchedule.tenWeekEndDt}',   name:'tenWeekResult', align:'left', width:'4000'},                 <%-- 10차시 --%>             
	               {label:'<spring:message code="exam.label.lesson.eleven"/> ${lessonSchedule.elevenWeekEndDt}',   name:'elevenWeekResult', align:'left', width:'4000'},        <%-- 11차시 --%>    
	               {label:'<spring:message code="exam.label.lesson.twelve"/> ${lessonSchedule.twelveWeekEndDt}',   name:'twelveWeekResult', align:'left', width:'4000'},        <%-- 12차시--%>               
	               {label:'<spring:message code="exam.label.lesson.thirteen"/> ${lessonSchedule.thirteenWeekEndDt}',   name:'thirteenWeekResult', align:'left', width:'4000'},  <%-- 13차시 --%>           
	               {label:'<spring:message code="exam.label.lesson.fourteen"/> ${lessonSchedule.fourteenWeekEndDt}',   name:'fourteenWeekResult', align:'left', width:'4000'},  <%-- 14차시 --%>         
	               {label:'<spring:message code="exam.label.lesson.fifteen"/> ${lessonSchedule.fifteenWeekEndDt}',   name:'fifteenWeekResult', align:'left', width:'4000'},     <%-- 15차시 --%>             
	               {label:'<spring:message code="exam.label.login.total.cnt"/>', name:'loginCnt', align:'center', width:'5000' },                                               <%-- 로그인횟수 (총횟수) --%>
	               {label:'<spring:message code="exam.label.credit"/>',   name:'credit', align:'center',   width:'3000'},                                                       <%--학점--%>
	               {label:'<spring:message code="exam.label.mean.rating"/>', name:'meanRating', align:'center',  width:'3000'},                                                 <%-- 평균평점 --%>
	               {label:'<spring:message code="exam.label.percentage.score"/>', name:'totScore', align:'center',  width:'3000'},                                              <%-- 백분율 점수 --%>
	               {label:'<spring:message code="exam.label.grade"/>', name:'scoreGrade', align:'center',  width:'3000'}                                                        <%-- 등급 --%>
	               ]
		};
	
	 var haksaYear = $("#haksaYear option:selected").val();
	 var haksaTerm = $("#haksaTerm option:selected").val();
	 var crsCreCd = $("#crsCreCd option:selected").val();
	 
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

	<div id="wrap" class="pusher">
	
	    <!-- class_top 인클루드  -->
		<!-- header -->
		<%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
	    <!-- //header -->
	
		<!-- lnb -->
	    <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>
	    <!-- //lnb -->
	
		<div id="container">
	
			<!-- 본문 content 부분 -->
	        <div class="content">
	
				<!-- admin_location -->
                <div id="info-item-box" class="">
                    <h2 class="page-title flex-item"><spring:message code="exam.label.study"/><!-- 수업 -->
                        <div class="ui breadcrumb small">
                            <small class="section"><spring:message code="exam.label.industry.progress"/><!-- 산업체위탁생학습진행현황 --></small>
                        </div>
                    </h2>
                </div>
	            <!-- //admin_location -->

                <div class="ui divider mt0"></div>
                
				<div class="ui form">
                    
                    <input type="hidden" name="curYear" id="curYear" value="${curYear}"/>
                    <input type="hidden" name="curTerm" id="curTerm" value="${curTerm}"/>
   
	                <!-- 검색영역1 -->
	                <div class="ui segment searchArea">                            
	                    <div class="fields">
	                        <div class="two wide field ">  <!-- one ~ sixteen -->
	                            <select class="ui flui ddropdown" id="haksaYear" name="haksaYear" onchange="fnHaksaTermSearch();">
                                    <c:choose>
                                        <c:when test="${ empty haksaYearList}"></c:when>
                                        <c:otherwise>
                                            <c:forEach var="year" items="${haksaYearList}" varStatus="status">
		                                        <option value="${year.haksaYear}" <c:if test="${year.haksaYear == curYear}">selected</c:if>>${year.haksaYear}년</option>
		                                    </c:forEach>
                                         </c:otherwise>
                                    </c:choose>
	                            </select> 
	                        </div>                           
	
	                        <div class="three wide field ">
	                            <select class="ui fluid dropdown" id="haksaTerm" name="haksaTerm" onchange="fnCrsCreSearch();">
                                    <c:choose>
                                        <c:when test="${ empty haksaTermList}"></c:when>
                                        <c:otherwise>
                                            <c:forEach var="term" items="${haksaTermList}" varStatus="status">
                                                <option value="${term.haksaTermCd}" <c:if test="${term.haksaTermCd == curTerm}">selected</c:if>>${term.haksaTermNm}</option>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>	                                
	                            </select> 
	                        </div>
	
                            <div class="three wide field ">
                                <select class="ui fluid dropdown" id="crsCreCd" name="crsCreCd" onchange="fnLessonProgSearch();">
                                    <c:choose>
                                        <c:when test="${ empty creCrsList}"></c:when>
                                        <c:otherwise>
                                            <c:forEach var="subjct" items="${creCrsList}" varStatus="status">
                                                <option value="${subjct.crsCreCd}">${subjct.crsCreNm}</option>
                                            </c:forEach>  
                                        </c:otherwise>
                                    </c:choose> 
                                </select> 
                            </div>
                            
	                    </div>
	
                        <div class="button-area mt10 tc">
                            <a href="#" class="ui blue button w100" onclick="fnLessonProgSearch();"><spring:message code="exam.button.search"/><!-- 검색 --></a>
                        </div>
	                        
	                </div>
	                <!-- //검색영역1 --> 

                    <div class="option-content gap4 mt10 mb10">   
                        <div class="flex gap4 mra">
                            <div class="sec_head"><spring:message code="exam.label.industry.progress"/><!-- 산업체위탁생 학습진행현황 --></div>
                            <div class="fcGrey" id="totalCnt">[ 총건수 : 0 ]</div>
                        </div>
                        <div class="">
                            <a class="ui basic small button" onclick="fnExcelDownLoad()"><i class="download icon"></i><spring:message code="exam.button.excel.down"/><!-- 엑셀 다운로드 --></a>
                        </div>
                    </div>                        				

				    <div id="industryConLearningList" class="footable_box type2 mb20 max-height-400"></div>
				</div>
			</div>
		</div>
		<!-- //본문 content 부분 -->
		<%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
	</div>
	
</body>