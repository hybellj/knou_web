<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
 
<!DOCTYPE html>
<%@ include file="/WEB-INF/jsp/common/admin/admin_common_no_div.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
$(document).ready(function(){
});

</script>

<table class="tBasic mt10 f080" style="min-width:1540px">
    <thead class="sticky top0">
        <tr>
            <th rowspan=2 class="p_w3 tc">No</th>
            <th rowspan=2 class="tc"><spring:message code='exam.label.user.no'/></th> <!-- 학번 -->
            <th rowspan=2 class="tc"><spring:message code='exam.label.usernm'/></th> <!-- 성명 -->
            <th rowspan=2 class="tc"><spring:message code='exam.label.tch.no'/></th> <!-- 사번 -->
            <th rowspan=2 class="tc"><spring:message code='exam.label.haksu.no'/></th> <!-- 학수번호 -->
            <th rowspan=2 class="tc"><spring:message code='exam.label.crs.nm'/></th> <!-- 교과목명 -->
            <th colspan=15 class="tc"><spring:message code='exam.label.lesson.progress'/></th> <!-- 학습진도율(출석여부)  * 매주 금요일 차시 오픈 ~ 2주 이내 수강 시 출석 인정-->
            <th rowspan=2 class="p_w5 tc"><spring:message code='exam.label.login.total.cnt'/></th> <!-- 로그인횟수 (총횟수)-->
            <th rowspan=2 class="tc"><spring:message code='exam.label.credit'/></th> <!-- 학점-->
            <th rowspan=2 class="tc"><spring:message code='exam.label.mean.rating'/></th> <!-- 평균평점 -->
            <th rowspan=2 class="tc"><spring:message code='exam.label.percentage.score'/></th> <!-- 백분율 점수 -->
            <th rowspan=2 class="tc"><spring:message code='exam.label.grade'/></th> <!-- 등급-->
        </tr>
        <tr>
            <th class=""><spring:message code='exam.label.lesson.one'/><br><small class="f070 ls1">${lessonSchedule.oneWeekEndDt}</small> </th> <!-- 1차시 -->
            <th class=""><spring:message code='exam.label.lesson.two'/><br><small class="f070 ls1">${lessonSchedule.twoWeekEndDt }</small> </th> <!-- 2차시 -->
            <th class=""><spring:message code='exam.label.lesson.three'/><br><small class="f070 ls1">${lessonSchedule.threeWeekEndDt}</small> </th> <!-- 3차시 -->
            <th class=""><spring:message code='exam.label.lesson.four'/><br><small class="f070 ls1">${lessonSchedule.fourWeekEndDt}</small> </th> <!-- 4차시 -->
            <th class=""><spring:message code='exam.label.lesson.five'/><br><small class="f070 ls1">${lessonSchedule.fiveWeekEndDt}</small> </th> <!-- 5차시 -->
            <th class=""><spring:message code='exam.label.lesson.six'/><br><small class="f070 ls1">${lessonSchedule.sixWeekEndDt}</small> </th> <!-- 6차시 -->
            <th class=""><spring:message code='exam.label.lesson.seven'/><br><small class="f070 ls1">${lessonSchedule.sevenWeekEndDt}</small> </th> <!-- 7차시 -->
            <th class=""><spring:message code='exam.label.lesson.eight'/><br><small class="f070 ls1">${lessonSchedule.eightWeekEndDt}</small> </th> <!-- 8차시 -->
            <th class=""><spring:message code='exam.label.lesson.nine'/><br><small class="f070 ls1">${lessonSchedule.nineWeekEndDt}</small> </th> <!-- 9차시 -->
            <th class=""><spring:message code='exam.label.lesson.ten'/><br><small class="f070 ls1">${lessonSchedule.tenWeekEndDt}</small> </th> <!-- 10차시 -->
            <th class=""><spring:message code='exam.label.lesson.eleven'/><br><small class="f070 ls1">${lessonSchedule.elevenWeekEndDt}</small> </th> <!-- 11차시 -->
            <th class=""><spring:message code='exam.label.lesson.twelve'/><br><small class="f070 ls1">${lessonSchedule.twelveWeekEndDt}</small> </th> <!-- 12차시 -->
            <th class=""><spring:message code='exam.label.lesson.thirteen'/><br><small class="f070 ls1">${lessonSchedule.thirteenWeekEndDt}</small> </th> <!-- 13차시 -->
            <th class=""><spring:message code='exam.label.lesson.fourteen'/><br><small class="f070 ls1">${lessonSchedule.fourteenWeekEndDt}</small> </th> <!-- 14차시 -->
            <th class=""><spring:message code='exam.label.lesson.fifteen'/><br><small class="f070 ls1">${lessonSchedule.fifteenWeekEndDt}</small> </th> <!-- 15차시 -->         
        </tr>        
    </thead>
    <tbody> <!--max-height-300, 350, 400, 450, 500, 550  -->
        <c:choose>
            <c:when test="${ empty industryList}">
                <td colspan="26">
                    <div class="none tc pt10">
                        <span><spring:message code='common.nodata.msg'/></span>
                    </div>
                </td>             
            </c:when>
            <c:otherwise>
                <c:forEach var="industry" items="${industryList}" varStatus="status">
                    <tr>
                        <td class="tc">${status.count}</td>
                        <td class="">${industry.userId}</td>
                        <td class="">${industry.userNm}</td>
                        <td class="">${industry.userId}</td>
                        <td class="">${industry.crsCd}</td>
                        <td class="">${industry.crsCreNm}</td>
                        <td class="">${industry.oneWeekResult}</td>
                        <td class="">${industry.twoWeekResult}</td>
                        <td class="">${industry.threeWeekResult}</td>
                        <td class="">${industry.fourWeekResult}</td>
                        <td class="">${industry.fiveWeekResult}</td>
                        <td class="">${industry.sixWeekResult}</td>
                        <td class="">${industry.sevenWeekResult}</td>
                        <td class="">${industry.eightWeekResult}</td>
                        <td class="">${industry.nineWeekResult}</td>
                        <td class="">${industry.tenWeekResult}</td>
                        <td class="">${industry.elevenWeekResult}</td>
                        <td class="">${industry.twelveWeekResult}</td>
                        <td class="">${industry.thirteenWeekResult}</td>
                        <td class="">${industry.fourteenWeekResult}</td>
                        <td class="">${industry.fifteenWeekResult}</td>
                        <td class="">${industry.loginCnt}</td>
                        <td class="">${industry.credit}</td>
                        <td class="">${industry.meanRating}</td>
                        <td class="">${industry.totScore}</td>
                        <td class="">${industry.scoreGrade}</td>
                    </tr> 
                </c:forEach>
            </c:otherwise>
        </c:choose>     
    </tbody>
</table> 
                        

