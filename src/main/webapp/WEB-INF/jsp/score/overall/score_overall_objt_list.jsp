<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	
	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
	
	<% 
	String deviceType = SessionInfo.getDeviceType(request);
	pageContext.setAttribute("deviceType", deviceType);

	if("mobile".equals(deviceType)) {
		%>
		<style>
			.tBasic th, .tBasic td {
    			padding: 0.2em 0.1em !important;
			}
		</style>		
		<%
	} 
	%>
	
	<script type="text/javascript">
		$(function(){
			onObjtSearch();	
			
			//탭2-추가
			$("#btnObjtAdd").on("click", function() {
				var calendarCtgr = '00210203';
				var crsCreCd = '<c:out value="${creCrsVO.crsCreCd}" />';
				var uniCd = '<c:out value="${creCrsVO.uniCd}" />';
				var msg = '<spring:message code="score.alert.no.objt.proc.period" />'; // 성적재확인신청정정 기간이 아닙니다.
				
				if(uniCd == "G") {
					calendarCtgr = '00210205';
				}
				
				checkJobSch(calendarCtgr, crsCreCd, msg).done(function() {
					$("#modalScoreReCfmTchRegForm input[name=crsCreCd]").val(crsCreCd);
					$("#modalScoreReCfmTchRegForm").attr("target", "modalScoreReCfmTchRegIfm");
				    $("#modalScoreReCfmTchRegForm").attr("action", "/score/scoreOverall/scoreOverallScoreReCfmTchRegPopup.do");
				    $("#modalScoreReCfmTchRegForm").submit();
				    $("#modalScoreReCfmTchReg").modal('show');
				});
			});
			
			//탭2-엑셀다운로드
			$("#btnObjtExcel").on("click", function(){
				$("form[name=paperExcelForm]").remove();
				var url  = "/score/scoreOverall/selectScoreObjtTchExcelDown.do";
				var form = $("<form></form>");
				form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: '<c:out value="${crsCreCd}" />'}));
				form.attr("method", "POST");
				form.attr("name", "paperExcelForm");
				form.attr("action", url);
				form.appendTo("body");
				form.submit();
			});
			
			$("#chkObjtAll").on("change", function(){
				if($(this).is(":checked")){
					$("input[name=objtDataChk]").prop("checked", true);
				} else {
					$("input[name=objtDataChk]").prop("checked", false);
				}
			});
			
			$("#searchBtn").on("click", function() {
				onObjtSearch();
			});
			
			$("#searchValue").on("keydown", function(e) {
				if(e.keyCode == 13) {
					onObjtSearch();
				}
			});
			
		});
		
		//이의신청탭 조회
		function onObjtSearch(){
			var url = "/score/scoreOverall/selectScoreObjtList.do";
			var param = {
				  crsCreCd: '<c:out value="${crsCreCd}" />'
				, searchValue: $("#searchValue").val()
			};
			
			ajaxCall(url, param, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					
					var html = "";
					
					if(returnList.length > 0){
						$.each(returnList, function(i, o){
							html += "<tr>";
							
							if (DEVICE_TYPE == "pc") {
								html += "    <td class='tc'><div class='ui checkbox'><input type='checkbox' name='objtDataChk' tabindex='0' user_id='" + o.objtUserId + "' user_nm='" + o.objtUserNm + "' mobile='" + o.userMobileNo + "' email='" + o.userEmail + "'><label></label></div></td>";
				            	html += "    <td class='tc'>" + o.lineNo + "</td>";
				            	html += "    <td class='tc'>" + o.deptNm + "</td>";
				            	html += "    <td class='tc'>" + o.objtUserId + "</td>";
					            html += "    <td class='tc'>" + o.objtUserNm + "</td>";
							}
							else {
								html += "    <td class='tc'>" + o.objtUserNm + "<br>" + o.objtUserId + "</td>";
							}
				            
				            if (DEVICE_TYPE == "pc") {
				            	html += "    <td class='tc'>" + (o.hy || '-') + "</td>";
				            }
				            html += "    <td class='tc'>";
				            html += "        <a href=\"javascript:onObjtCtntPop('" + o.scoreObjtCd + "');\" class='ui basic small button'><spring:message code='crs.reason' /></a>";	// 사유
				            html += "    </td>";
				            
				            if (DEVICE_TYPE == "pc") {
					            html += "    <td class='tc'>" + o.prvScore + "</td>";
					            html += "    <td class='tc'>" + o.prvGrade + "</td>";
					            html += "    <td class='tc'>" + o.modScore + "</td>";
					            html += "    <td class='tc'>" + o.modGrade + "</td>";
					            html += "    <td class='tc'>";
				            	html += "        <a href=\"javascript:onObjtProcPop('" + o.objtUserId + "','" + o.scoreObjtCd + "');\" class='ui basic small button'><spring:message code='exam.label.process.process' /></a>"; // 처리하기
					            html += "    </td>";
					            html += "    <td class='tc'>" + o.procNm + "</td>";
				            }
				            else {
				            	html += "    <td class='tc'>" + o.prvScore + " / " + o.prvGrade + "</td>";
					            html += "    <td class='tc'>" + o.modScore + " / " + o.modGrade + "</td>";
					            html += "    <td class='tc'>";
				            	html += "        <a href=\"javascript:onObjtProcPop('" + o.objtUserId + "','" +  o.scoreObjtCd + "');\" class='ui basic small button'><spring:message code='exam.label.process.process' /></a>"; // 처리하기
				            	html += "        <br>" + o.procNm ;
					            html += "    </td>";
				            }

				            html += "</tr>";
						});
					} else {
						html += "<tr>";
						html += "    <td colspan='13'>";
						html += "<div class='flex-container min-height-300'>";
						html += "   <div class='no_content'><i class='icon-cont-none ico f170'></i><span><spring:message code='common.no.data.result' /></span></div>";// 조회된 데이타가 없습니다.
						html += "</div>";
						html += "</td>";
						html += "</tr>";
					}
		
					$("#objtTbody").empty().html(html);
					//$("#objtTable").footable();
				} else {
					alert(data.message);
				}
			}, function(xhr, status, error) {
				/* 실패하였습니다. */
				alert('<spring:message code="common.message.failed" />');
			}, true);
		}
		
		//사유보기 팝업
		function onObjtCtntPop( scoreObjtCd){
			$("#modalObjtCtntForm input[name=scoreObjtCd]").val(scoreObjtCd);
			$("#modalObjtCtntForm").attr("target", "modalObjtCtntIfm");
		    $("#modalObjtCtntForm").attr("action", "/score/scoreOverall/scoreOverallObjtCtntPopup.do");
		    $("#modalObjtCtntForm").submit();
		    $("#modalObjtCtnt").modal('show');
		}
		
		//처리하기 팝업
		function onObjtProcPop( objtUserId, scoreObjtCd ){
			var calendarCtgr = '00210203';
			var crsCreCd = '<c:out value="${creCrsVO.crsCreCd}" />';
			var uniCd = '<c:out value="${creCrsVO.uniCd}" />';
			var msg = '<spring:message code="score.alert.no.objt.proc.period" />'; // 성적재확인신청정정 기간이 아닙니다.
			
			if(uniCd == "G") {
				calendarCtgr = '00210205';
			}
			
			checkJobSch(calendarCtgr, crsCreCd, msg, true).done(function(jobSchEndYn) {
				if(${fn:contains(classUserType, 'tut')}) {
					/* 조교는 처리할  수 없습니다. */
					alert('<spring:message code="score.label.ect.eval.oper.msg13" />');
					return false;
				} else {
					if(jobSchEndYn == "Y") {
						$("#modalObjtProcForm").attr("action", "/score/scoreOverall/scoreOverallObjtViewPopup.do");
					} else {
						$("#modalObjtProcForm").attr("action", "/score/scoreOverall/scoreOverallObjtProcPopup.do");
					}
					
					$("#modalObjtProcForm input[name=objtUserId]").val(objtUserId);
					$("#modalObjtProcForm input[name=crsCreCd]").val(crsCreCd);
					$("#modalObjtProcForm input[name=scoreObjtCd]").val(scoreObjtCd);
					$("#modalObjtProcForm").attr("target", "modalObjtProcIfm");
				    $("#modalObjtProcForm").submit();
				    $("#modalObjtProc").modal('show');
				}
			});
		}
		
		// 업무일정 체크
		function checkJobSch(calendarCtgr, crsCreCd, msg, useJobSchEndViewPop) {
			var deferred = $.Deferred();
			
			var url = "/jobSchHome/viewSysJobSch.do";
			var data = {
				crsCreCd     	: crsCreCd,
				calendarCtgr 	: calendarCtgr,
				haksaYear	   	: '<c:out value="${creCrsVO.creYear}" />',
				haksaTerm		: '<c:out value="${creCrsVO.creTerm}" />',
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnVO = data.returnVO;
					if(returnVO != null) {
						var jobSchPeriodYn = returnVO.jobSchPeriodYn;
						var schStartDt = returnVO.schStartDt;
						var schEndDt = returnVO.schEndDt;
						var jobSchEndYn = returnVO.jobSchEndYn;
						var jobSchEndYn = returnVO.jobSchEndYn;
						
						if(jobSchPeriodYn == "Y") {
							deferred.resolve();
						} else if(useJobSchEndViewPop && jobSchEndYn == "Y") {
							deferred.resolve(jobSchEndYn);
						} else {
							if(schStartDt && schEndDt.length == 14 && schEndDt && schEndDt.length == 14) {
								//msg += '\n<spring:message code="common.period" /> : [' + getDateFmt(schStartDt) + ' ~ ' + getDateFmt(schEndDt) + ']'; // 기간
							}
							
							alert(msg);
							deferred.reject();
						}
					} else {
						alert('<spring:message code="sys.alert.already.job.sch" />'); // 등록된 일정이 없습니다.
						deferred.reject();
					}
	        	} else {
	        		alert(data.message);
	        		deferred.reject();
	        	}
			}, function(xhr, status, error) {
				alert("<spring:message code='exam.error.info' />"); // 정보 조회 중 에러가 발생하였습니다.
				deferred.reject();
			});
			
			return deferred.promise();
		}
		
		//메세지 보내기
		function sendMsg() {
			if($("#objtTable").find("input[name=objtDataChk]:checked").length == 0){
				/* 체크된 값이 없습니다. */
				alert('<spring:message code="score.label.ect.eval.oper.msg14" />');
				return;
			}
			
			var rcvUserInfoStr = "";
			var sendCnt = 0;
		
			$.each($("#objtTable").find("input[name=objtDataChk]:checked"), function() {
				sendCnt++;
				if (sendCnt > 1) rcvUserInfoStr += "|";
				rcvUserInfoStr += $(this).attr("user_id");
				rcvUserInfoStr += ";" + $(this).attr("user_nm");
				rcvUserInfoStr += ";" + $(this).attr("mobile");
				rcvUserInfoStr += ";" + $(this).attr("email");
			});
		
		    window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");
		
		    var form = document.alarmForm;
		    form.action = "<%=CommConst.SYSMSG_URL_SEND%>";
		    form.target = "msgWindow";
		    form[name='alarmType'].value = "S"; // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
		    form[name='rcvUserInfoStr'].value = rcvUserInfoStr; //보내는사람 정보
		    form.submit();
		}
		
		// 날짜 포멧 변환 (yyyy.mm.dd || yyyy.mm.dd hh:ii)
		function getDateFmt(dateStr) {
			var fmtStr = (dateStr || "");
			
			if(fmtStr.length == 14) {
				fmtStr = fmtStr.substring(0, 4) + '.' + fmtStr.substring(4, 6) + '.' + fmtStr.substring(6, 8) + ' ' + fmtStr.substring(8, 10) + ':' + fmtStr.substring(10, 12);
			} else if(fmtStr.length == 8) {
				fmtStr = fmtStr.substring(0, 4) + '.' + fmtStr.substring(4, 6) + '.' + fmtStr.substring(6, 8);
			}
			
			return fmtStr;
		}
	</script>
</head>
<body class="<%=SessionInfo.getThemeMode(request)%>">
	<input type="hidden" id="sCrsCreCd" name="sCrsCreCd" value="<c:out value="${sCrsCreCd}" />"/>
	<input type="hidden" id="sUserId" name="sUserId" value="<c:out value="${sUserId}" />"/>
	
    <div id="wrap" class="pusher">									
        <%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>
        
		<div id="container">											
            <%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>
            		
			<div class="content stu_section">							
            	<%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>
            	
				<div class="ui form">
					<div class="layout2">

                        <div id="info-item-box"> <!--  class="ui sticky" -->
                        	<script>
							$(document).ready(function () {
								// set location 종합성적 성적재확인
								setLocationBar("<spring:message code='common.label.score.view' />", "<spring:message code='common.label.score.reconfirm' />");
							});
							</script>
                        
                            <h2 class="page-title flex-item flex-wrap gap4 columngap16 mra">
                                <spring:message code="common.label.score.reconfirm" /><!-- 성적재확인 -->
                            </h2>
                            <div class="button-area">
                                <!-- <a href="#0" class="ui basic button">목록</a> -->
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col">

                                <%-- 
                                <div class="listTab">
                                    <ul class="">  
                                        <li onclick="moveTab(1)" class="<c:if test="${empty vo.tabCd or vo.tabCd eq 1}">select</c:if> mw120"><a href="javascript:;" ><spring:message code='score.label.university.score' /></a></li>
                                        <li onclick="moveTab(2)" class="<c:if test="${vo.tabCd eq 2}">select</c:if> mw120"><a href="javascript:;"><spring:message code="score.appeal.label" /></a></li>
                                    </ul>
                                </div> 
                                --%>
                               
                                <div class="option-content gap4 mt10 mb10">
                                    <div class="ui action input search-box">
                                        <input id="searchValue" type="text" placeholder="<spring:message code="user.message.search.input.userinfo.no.dept.nm" />" value="">
                                        <button class="ui icon button" type="button" id="searchBtn">
                                            <i class="search icon"></i>
                                        </button>
                                    </div>
                                    
                                    <div class="flex-left-auto">
                                    <c:if test="${deviceType == 'pc'}">
	                                    <button type="button" class="ui basic button" onclick="sendMsg();return false;" ><i class="paper plane outline icon"></i><spring:message code="common.button.message" /></button><!-- 메시지 -->
                                	</c:if>
                                    <c:if test="${scoreObjtYn eq '1' and !classUserType.contains('tut')}">
                                        <button type="button" class="ui orange button" id="btnObjtAdd"><spring:message code="exam.button.add" /></button><!-- 추가 -->
                                    </c:if>
                                        <button type="button" class="ui green button" id="btnObjtExcel"><spring:message code="forum.label.excel.download" /></button><!-- 엑셀다운로드 -->
                                    </div>
                                </div>
                                
                                <div class="scrollbox_x">
	                                <table class="tBasic type2" id="objtTable">        
	                                    <thead> 
	                                    	<c:choose>
	                                    		<c:when test="${deviceType eq 'pc'}">
			                                        <tr>
			                                            <th rowspan="2" class="num w30"><div class="ui checkbox"><input type="checkbox" tabindex="0" id='chkObjtAll'><label></label></div></th>
			                                            <th rowspan="2"><spring:message code="common.number.no"/></th><!-- No -->
			                                            <th colspan="4"><spring:message code="common.label.learner" /></th><!-- 학습자 -->
			                                            <th rowspan="2"><spring:message code="score.label.request.reason" /></th><!-- 신청사유 -->
			                                            <th colspan="2"><spring:message code="score.label.before.score" /></th><!-- 변경 전 성적 -->
			                                            <th colspan="2"><spring:message code="score.label.after.score" /></th><!-- 변경 후 성적 -->
			                                            <th rowspan="2"><spring:message code="common.label.score.reconfirm.yn.treat" /></th><!-- 성적재확인 신청처리 -->
			                                            <th rowspan="2"><spring:message code="score.label.process.status" /></th><!-- 처리상태 및 결과 -->
			                                        </tr>   
			                                        <tr>
			                                            <th><spring:message code="lesson.label.dept" /></th><!-- 학과 -->
			                                            <th><spring:message code="lesson.label.user.no" /></th><!-- 학번 -->
			                                            <th><spring:message code="user.title.userinfo.manage.user.nm" /></th><!-- 성명 -->
			                                            <th><spring:message code="asmnt.label.user.grade" /></th><!-- 학년 -->
			                                            <th><spring:message code="common.score" /></th><!-- 점수 -->
			                                            <th><spring:message code="exam.label.level" /></th><!-- 등급 -->
			                                            <th><spring:message code="common.score" /></th><!-- 점수 -->
			                                            <th><spring:message code="exam.label.level" /></th><!-- 등급 -->
			                                        </tr>	                                    		
	                                    		</c:when>
	                                    		<c:when test="${deviceType eq 'mobile'}">
	                                    			<tr>
														<th><spring:message code="user.title.userinfo.manage.user.nm" />/<spring:message code="lesson.label.user.no" /></th><!-- 성명/학번 -->
			                                            <th><spring:message code="score.label.request.reason" /></th><!-- 신청사유 -->
			                                            <th>변경전<br><spring:message code="common.score" />/<spring:message code="exam.label.level" /></th><!-- 점수 -->
			                                            <th>변경후<br><spring:message code="common.score" />/<spring:message code="exam.label.level" /></th><!-- 점수 -->
			                                            <th>처리/결과</th><!-- 성적재확인 신청처리 -->
	                                    			</tr>
	                                    		</c:when>
	                                    	</c:choose>
	                                    </thead>        
	                                    <tbody id="objtTbody">     
	                                    </tbody>   
	                                </table>
                                </div>
                    </div>
		        </div><!-- //ui form -->
            </div><!-- //content -->
        </div><!-- //container -->
    </div><!-- //pusher -->
    <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
    
    <!-- 사유보기 팝업 -->
    <form class="ui form" id="modalObjtCtntForm" name="modalObjtCtntForm" method="POST" action="">
    	<input type="hidden" name="scoreObjtCd"/>
	    <div class="modal fade" id="modalObjtCtnt" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="score.label.reason.view" />" aria-hidden="false">
	        <div class="modal-dialog modal-lg" role="document">
	            <div class="modal-content">
	                <div class="modal-header">
	                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="sys.button.close" />">
	                        <span aria-hidden="true">&times;</span>
	                    </button>
	                    <h4 class="modal-title"><spring:message code="score.label.reason.view" /><!-- 사유보기 --></h4>
	                </div>
	                <div class="modal-body">
	                    <iframe src="" id="modalObjtCtntIfm" name="modalObjtCtntIfm" width="100%" scrolling="no"></iframe>
	                </div>
	            </div>
	        </div>
	    </div>
    </form>
    <!-- 성적 재확인 신청하기 팝업 -->
    <form class="ui form" id="modalScoreReCfmTchRegForm" name="modalScoreReCfmTchRegForm" method="POST" action="">
	    <input type="hidden" name="crsCreCd"/>
	    <div class="modal fade" id="modalScoreReCfmTchReg" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="common.label.score.reconfirm.yn" />" aria-hidden="false">
	        <div class="modal-dialog modal-lg" role="document">
	            <div class="modal-content">
	                <div class="modal-header">
	                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="sys.button.close" />">
	                        <span aria-hidden="true">&times;</span>
	                    </button>
	                    <h4 class="modal-title"><spring:message code="common.label.score.reconfirm.yn" /><!-- 성적 재확인 신청 --></h4>
	                </div>
	                <div class="modal-body">
	                    <iframe src="" id="modalScoreReCfmTchRegIfm" name="modalScoreReCfmTchRegIfm" width="100%" scrolling="no"></iframe>
	                </div>
	            </div>
	        </div>
	    </div>
    </form>
    <!-- 성적변경 처리 팝업 -->
    <form class="ui form" id="modalObjtProcForm" name="modalObjtProcForm" method="POST" action="">
    	<input type="hidden" name="objtUserId"/>
    	<input type="hidden" name="crsCreCd"/>
			<input type="hidden" name="scoreObjtCd"/>
	    <div class="modal fade" id="modalObjtProc" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="score.label.change" />" aria-hidden="false">
	        <div class="modal-dialog modal-lg2" role="document">
	            <div class="modal-content">
	                <div class="modal-header">
	                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="sys.button.close" />">
	                        <span aria-hidden="true">&times;</span>
	                    </button>
	                    <h4 class="modal-title"><spring:message code="score.label.change" /><!-- 성적변경 처리 --></h4>
	                </div>
	                <div class="modal-body">
	                    <iframe src="" id="modalObjtProcIfm" name="modalObjtProcIfm" width="100%" scrolling="no"></iframe>
	                </div>
	            </div>
	        </div>
	    </div>
    </form>
    <script>
        $('iframe').iFrameResize();
        window.closeModal = function() {
            $('.modal').modal('hide');
        };
    </script>
</body>

</html>
