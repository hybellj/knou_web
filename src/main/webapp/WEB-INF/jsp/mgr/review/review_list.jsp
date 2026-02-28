<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!DOCTYPE html>
<%@ include file="/WEB-INF/jsp/common/admin/admin_common_no_jquery.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
var arrCal = [];
$(document).ready(function(){
	// 달력을 전역 변수로 관리
    // (화면 로딩 시 모든 달력의 인스턴스를 생성하면 화면 로딩 속도가 현저히 느려져서 화면 로딩시에는 맨위 두개의 달력만
    // 생성 해놓고 각 달력을 클릭하면 그 다음 달력의 인스턴스를 생성하여 속도를 올리고자 함이다.)
    var reviewLength =  ${fn:length(resultList)};
    
    for(var i = 0; i < reviewLength; i++) {
        if(i == 0) {
            createCalendar($('#cStartdt' + (i+1)), $('#cStartdt' + (i+1)), $("#cEnddt" + (i+1)), 'START');
            createCalendar($("#cEnddt" + (i+1)), $('#cEnddt' + (i+1)), $("#cEnddt" + (i+1)), 'END');
        }

        var calObj = new Object();
        calObj.startCal = $("#cStartdt" + (i+1));
        calObj.endCal = $("#cEnddt" + (i+1));
        if(i == 0) {
            calObj.isCal = true;
        } else {
            calObj.isCal = false;
        }
        arrCal.push(calObj);
    }

	if(typeof displayReviewTotoCnt == 'function') {
    	displayReviewTotoCnt('${pageInfo.totalRecordCount}');
    }
});

function callCalendar(calIndex) {

	var selCal = arrCal[calIndex];
    if(!selCal.isCal) {
        createCalendar(selCal.startCal, selCal.startCal, selCal.endCal, 'START');
        createCalendar(selCal.endCal, selCal.startCal, selCal.endCal, 'END');
        selCal.isCal = true;
        arrCal[calIndex] = selCal;
    }

    if(calIndex + 1 < arrCal.length) {
        var nextCal = arrCal[calIndex + 1];
        if(!nextCal.isCal) {
            createCalendar(nextCal.startCal, nextCal.startCal, nextCal.endCal, 'START');
            createCalendar(nextCal.endCal, nextCal.startCal, nextCal.endCal, 'END');
            nextCal.isCal = true;
            arrCal[calIndex + 1] = nextCal;
        }
    }
};

// 달력 생성
function createCalendar(calObj, startCalObj, endCalObj, startOrEndFlag) {
    var startCal;
    var endCal;
    if (startOrEndFlag == 'START') {
        endCal = $(endCalObj);
    } else if (startOrEndFlag == 'END') {
        startCal = $(startCalObj);
        endCal = $(endCalObj);
    }

    $(calObj).calendar({
        type: 'date',
        startCalendar: startCal,
        endCalendar: endCal,
         formatter: {
            date: function(date, settings) {
                if (!date) return '';
                var day  = (date.getDate()) + '';
                var month = settings.text.monthsShort[date.getMonth()];
                if (month.length < 2) {
                    month = '0' + month;
                }
               if (day.length < 2) {
                   day = '0' + day;
                }
                var year = date.getFullYear();
                return year + '.' + month + '.' + day;
            }
        } 
    });
};

/* 복습기간 저장 */
function reviewOneUpload(lsnOdr, crsCreCd) {
	// debugger;
	var url  = "/menu/menuMgr/updateReview.do";
    var reviewStatus = "";
    var reviewStartDttm = "";
    var reviewEndDttm = "";

    reviewStatus = $("input[name=reviewStatus"+lsnOdr + "]:checked").val();
    reviewStartDttm = $("#reviewStartDttm"+lsnOdr).val();
    reviewEndDttm = $("#reviewEndDttm"+lsnOdr).val();

	var data = {
		"crsCreCd" : crsCreCd
        , "reviewStatus" : reviewStatus
        , "reviewStartDttm" : reviewStartDttm
        , "reviewEndDttm" : reviewEndDttm
	};

	$.getJSON(url, data, function(data) {
		if (data.result > 0) {

    		// listReview();
    		location.reload();
        } else {
        	alert("<spring:message code='common.message.failed' />");	// 실패하였습니다.
        }
	}, function(xhr, status, error) {
			alert("<spring:message code='common.message.failed' />");	// 실패하였습니다.
	});
};

function getCheck(lsnOdr, lsnStr) {
	
	var radioVal = $("input[name=reviewStatus"+lsnOdr + "]:checked").val();
	
	if (lsnStr == 2) {

		$("#reviewStartDttm"+lsnOdr).attr("disabled", false);
    	$("#reviewEndDttm"+lsnOdr).attr("disabled", false);

	} else if (radioVal == 2) {

    	$("#reviewStartDttm"+lsnOdr).attr("disabled", false);
        $("#reviewEndDttm"+lsnOdr).attr("disabled", false);
	} else {
		
		if(lsnStr == radioVal) {			

			// 기존에 기간설정 항목에 체크된 값(DATA) 과 복습기간설정에서 
			// 체크한 값을 비교해서 같은 경우는 달력에서 날짜 선택이 가능!
			$("#reviewStartDttm"+lsnOdr).attr("disabled", false);  
	    	$("#reviewEndDttm"+lsnOdr).attr("disabled", false); 


		} else {
			$("#reviewStartDttm"+lsnOdr).attr("disabled", true);  
	    	$("#reviewEndDttm"+lsnOdr).attr("disabled", true);  

		}
	}
	// debugger;
	// var radioVal = $("input[name=reviewStatus"+lsnOdr + "]:checked").val();
	// alert(radioVal);
};
</script>
<body>
<form class="ui form" id=reviewForm name="reviewForm" method="POST" >
<input type="hidden" id="reviewStatus" name="reviewStatus" >
<input type="hidden" id="reviewStartDttm" name="reviewStartDttm" >
<input type="hidden" id="reviewEndDttm" name="reviewEndDttm" >
<input type="hidden" id="lsnOdr" name="lsnOdr" >
<input type="hidden" id="onlineCnt" name="onlineCnt" >
	<table class="table ftable mt15" data-sorting="false" data-paging="false" data-empty="<spring:message code="common.nodata.msg"/>">
    	<thead>
        	<tr>
            	<th scope="col" data-type="number" class="num "><spring:message code="common.number.no" /></th><!-- NO. -->
                <th scope="col" data-breakpoints="xs"><spring:message code="review.label.crscre.dept" /></th><!-- 개설학과 -->
                <th scope="col"><spring:message code="review.label.crscd" /></th><!-- 학수번호 -->
                <th scope="col" data-breakpoints="xs sm md"><spring:message code="review.label.crscrenm" /> (<spring:message code="review.label.decls" />)</th><!-- 과목명 --><!-- 분반 -->
                <th scope="col" data-breakpoints="xs sm md" class="p_w30"><spring:message code="review.period.setting" /></th><!-- 복습기간설정 -->
                <th scope="col" data-sortable="false" data-breakpoints="xs"><spring:message code="button.manage"/></th><!-- 관리 -->
            </tr>
        </thead>
        <tbody>
        	<c:choose>
				<c:when test="${not empty resultList}">
					<c:forEach items="${resultList}" var="result" varStatus="status">
					<c:set var="order" value="${status.count}" />
						<tr>
				           	<td>${result.lineNo}</td>
				            <td>${result.deptNm} 학과</td>
				            <td>${result.crsCd}</td>
				            <td>${result.crsCreNm} (${result.declsNo} 반)</td>
				            <td>
					        	<div class="fields flex-item mb0">
									<div class="field">
					                	<div class="ui radio checkbox checked" onclick="getCheck('${status.count}', '0')">
					                    	<input type="radio"  id="reviewStatus${order}" name="reviewStatus${order}" value="0" <c:if test="${result.reviewStatus == '0'}">checked</c:if> />
					                        <label for="reviewStatus${order}"><spring:message code='period.label.change.no' /></label><!-- 불가 -->
		                                </div>
					                </div>
					                <div class="field">
										<div class="ui radio checkbox checked" onclick="getCheck('${status.count}', '1')">
					                    	<input type="radio"  id="reviewStatus${order}" name="reviewStatus${order}" value="1" <c:if test="${result.reviewStatus == '1'}">checked</c:if>/>
					                        <label for="reviewStatus${order}"><spring:message code='period.label.change.yes' /></label><!-- 영구 -->
		                                </div>
					                </div>
									<div class="field">
					                	<div class="ui radio checkbox checked" onclick="getCheck('${status.count}', '2')">
					                        <input type="radio" id="reviewStatus${order}" name="reviewStatus${order}" value="2" <c:if test="${result.reviewStatus == '2'}">checked</c:if>/>
					                    	<label for="reviewStatus${order}"><spring:message code='period.label.change.tot' /></label><!-- 기간설정 -->     
		                                </div>
					                </div>
									<div class="field">
										<div class="ui calendar rangestart w150 mr5" id="cStartdt${status.count}" onclick="callCalendar(${status.index})">
											<div class="ui input left icon">
				                                <i class="calendar alternate outline icon"></i>
				                                <fmt:parseDate var="startDateString" value="${result.reviewStartDttm}" pattern="yyyyMMdd" />
				                                <fmt:formatDate var="startDate" value="${startDateString}" pattern="yyyy.MM.dd" />
				                            <c:choose>
				                    			<c:when test="${empty result.reviewStartDttm}">
				                    				<input id="reviewStartDttm${status.count}" name="reviewStartDttm${status.count}" type="text" value="${startDate}" placeholder="<spring:message code='review.lecture.StartDttm'/>" autocomplete="off" disabled> <!-- 시작일 -->
				                    			</c:when>
				                    			<c:otherwise>
				                    				<input id="reviewStartDttm${status.count}" name="reviewStartDttm${status.count}" type="text" value="${startDate}" placeholder="<spring:message code='review.lecture.StartDttm'/>" autocomplete="off"> <!-- 시작일 -->
				                    			</c:otherwise>
				                    		</c:choose>
											</div>
										</div>
									</div>
									<span class="time-sort">~</span>
									<div class="field">
										<div class="ui calendar rangeend w150 mr5" id="cEnddt${status.count}" onclick="callCalendar(${status.index})">
											<div class="ui input left icon">
				                                <i class="calendar alternate outline icon"></i>
				                                <fmt:parseDate var="endDateString" value="${result.reviewEndDttm}" pattern="yyyyMMdd" />
				                                <fmt:formatDate var="endDate" value="${endDateString}" pattern="yyyy.MM.dd" />
				                            <c:choose>
				                    			<c:when test="${empty result.reviewStartDttm}">
				                    				<input  id="reviewEndDttm${status.count}" name="reviewEndDttm${status.count}" type="text" value="${endDate}" placeholder="<spring:message code='review.lecture.EndDttm'/>" autocomplete="off" disabled> <!-- 종료일 -->
				                    			</c:when>
				                    			<c:otherwise>
				                    				<input  id="reviewEndDttm${status.count}" name="reviewEndDttm${status.count}" type="text" value="${endDate}" placeholder="<spring:message code='review.lecture.EndDttm'/>" autocomplete="off"> <!-- 종료일 -->
				                    			</c:otherwise>
				                    		</c:choose>
				                                
				                            </div>
				                        </div>
									</div>
					            </div>
				            </td>
							<td>
				                <a href="javascript:void(0)" onclick="reviewOneUpload('${status.count}', '${result.crsCreCd}')" class="ui button"><spring:message code="common.button.modify" /></a><!-- 수정 -->
				            </td>
				        </tr>
	        		</c:forEach>
				</c:when>
				<c:otherwise>
				</c:otherwise>
			</c:choose>
        </tbody>
    </table>
    <tagutil:paging pageInfo="${pageInfo}" funcName="listReview"/>
</form>                      
</body>