<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	
	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
	
	<script type="text/javascript">
		$(function(){
			onObjtSearch();
		});
		
		// 이의신청탭 조회
		function onObjtSearch(){
			var url = "/score/scoreOverall/selectScoreObjtList.do";
			
			ajaxCall(url, {crsCreCd: '<c:out value="${crsCreCd}" />'}, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					
					var html = "";
					
					$.each(data.returnList, function(i, o) {
						html += '<tr>';
						html += '    <td class="tc">' + o.lineNo + '</td>';
						html += '    <td class="tc">' + o.crsCreNm + '</td>';
						html += '    <td class="tc">' + o.declsNo + '</td>';
						html += '    <td class="tc">' + o.objtDttmFmt + '</td>';
						html += '    <td class="tc">' + o.objtUserNm + '(' + o.objtUserId + ')' + '</td>';
						html += '    <td class="tc">' + (gfn_isNull(o.procNm) ? '-' : o.procNm) + '</td>';
						html += '    <td class="tc">' + (gfn_isNull(o.procDttmFmt) ? '-' : o.procDttmFmt) + '</td>';
						html += '    <td class="tc">';
						if (!o.procCd) {
						    html += '        <a href="javascript:onObjtCtntPop(\'' + o.scoreObjtCd + '\');" class="ui basic small button"><spring:message code="score.button.submit.detail" /></a>'; // 신청내역
						} else {
						    html += '        <a href="javascript:onObjtProcCfmPop(\'' + o.crsCreCd + '\', \'' + o.stdNo + '\');" class="ui basic small button"><spring:message code="score.answer.confirm" /></a>'; // 답변확인
						}
						html += '    </td>';
						html += '</tr>';
					});
					
					$("#objtTbody").empty().html(html);
					$("#objtTable").footable();
					
					if(returnList.length == 0) {
						//신청하기
						$("#btnReg").off("click").on("click", function(){
							var crsCreCd = '<c:out value="${creCrsVO.crsCreCd}" />';
							var uniCd = '<c:out value="${creCrsVO.uniCd}" />';
							
							
							checkJobSch(crsCreCd, uniCd).done(function() {
								$("#modalScoreReCfmRegForm input[name=crsCreCd]").val(crsCreCd);
								$("#modalScoreReCfmRegForm").attr("target", "modalScoreReCfmRegIfm");
							    $("#modalScoreReCfmRegForm").attr("action", "/score/scoreOverall/scoreOverallScoreReCfmRegPopup.do");
							    $("#modalScoreReCfmRegForm").submit();
							    $("#modalScoreReCfmReg").modal('show');
							});
						});
						$("#btnReg").show();
					} else {
						$("#btnReg").hide();
						$("#btnReg").off("click");
					}
				} else {
					alert(data.message);
				}
			}, function(xhr, status, error) {
				alert("<spring:message code='fail.common.msg' />"); // 에러가 발생했습니다!
			}, true);
		}
		
		// 답변확인
		function onObjtProcCfmPop( crsCreCd, stdNo ){
			$("#modalObjtProcCfmForm [name=crsCreCd]").val(crsCreCd);
			$("#modalObjtProcCfmForm [name=stdNo]").val(stdNo);
			$("#modalObjtProcCfmForm").attr("target", "modalObjtProcCfmIfm");
		    $("#modalObjtProcCfmForm").attr("action", "/score/scoreOverall/scoreOverallObjtProcCfmPopup.do");
		    $("#modalObjtProcCfmForm").submit();
		    $("#modalObjtProcCfm").modal('show');
		}
		
		// 수정하기
		function objtEditPop(scoreObjtCd) {
			$("#modalScoreReCfmRegForm input[name=crsCreCd]").val('<c:out value="${crsCreCd}" />');
			$("#modalScoreReCfmRegForm input[name=scoreObjtCd]").val(scoreObjtCd);
			$("#modalScoreReCfmRegForm").attr("target", "modalScoreReCfmRegIfm");
		    $("#modalScoreReCfmRegForm").attr("action", "/score/scoreOverall/scoreOverallScoreReCfmModPopup.do");
		    $("#modalScoreReCfmRegForm").submit();
		    $("#modalScoreReCfmReg").modal('show');
		    $("#modalScoreReCfmRegForm input[name=scoreObjtCd]").val("");
		}
		
		//사유보기 팝업
		function onObjtCtntPop( scoreObjtCd ){
			$("#modalObjtCtntForm input[name=scoreObjtCd]").val(scoreObjtCd);
			$("#modalObjtCtntForm").attr("target", "modalObjtCtntIfm");
		    $("#modalObjtCtntForm").attr("action", "/score/scoreOverall/scoreOverallObjtCtntPopup.do");
		    $("#modalObjtCtntForm").submit();
		    $("#modalObjtCtnt").modal('show');
		}
		
		//업무일정 체크
		function checkJobSch(crsCreCd, uniCd) {
			var deferred = $.Deferred();
			
			var calendarCtgr = "";
			
			// 성적재확인신청기간
			if(uniCd == "G") {
				calendarCtgr = "00210204"; // 대학원
			} else {
				calendarCtgr = "00210202"; // 학부
			}
			
			var url = "/jobSchHome/viewSysJobSch.do";
			var data = {
				"crsCreCd"     : crsCreCd,
				"calendarCtgr" : calendarCtgr,
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
						
						if(jobSchPeriodYn == "Y") {
							deferred.resolve();
						} else {
							var argu = '<spring:message code="score.label.objt" />'; // 성적재확인신청
							var msg = '<spring:message code="score.alert.no.job.sch.period" arguments="' + argu + '" />'; // 기간이 아닙니다.
							
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
		
		//날짜 포멧 변환 (yyyy.mm.dd || yyyy.mm.dd hh:ii)
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
    <div id="wrap" class="pusher">									
        <%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>
        
		<div id="container">											
            <%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>
            		
			<div class="content stu_section">							
            	<%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>
            	
				<div class="ui form">
					<div class="layout2">
                        <div id="info-item-box">
                        	<script>
							$(document).ready(function () {
								// set location
								setLocationBar("<spring:message code='score.label.university.score' />", "<spring:message code='common.label.score.reconfirm.yn' />");	// 종합성적 성적재확인신청
							});
							</script>
                            <h2 class="page-title flex-item flex-wrap gap4 columngap16 mra">
								<spring:message code="common.label.score.reconfirm.yn" /><!-- 성적재확인 신청 -->
                            </h2>
                            <div class="button-area">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col">
		            			<div class="option-content gap4 ">
                                    <div class="flex flex-wrap gap4">
                                    	<c:if test="${PROFESSOR_VIRTUAL_LOGIN_YN ne 'Y'}">
                                        <a class="ui basic small button" id="btnReg" style="display: none;"><spring:message code="exam.label.apply" /></a><!-- 신청하기 -->
                                    	</c:if>
                                    </div>
                                </div>

                                <div class="ui divider"></div>
                                <table id="objtTable" class="table" data-sorting="false" data-paging="false" data-empty="<spring:message code="common.content.not_found" />">
                                	<caption class="hide"><spring:message code="common.label.score.reconfirm.yn" /></caption>
									<thead>
										<tr>
											<th scope="col" data-breakpoints="xs" data-type="number" class="num tc"><spring:message code="common.number.no"/></th>
											<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="filemgr.label.crsauth.crsnm" /></th><!-- 과목명 -->
											<th scope="col" class="tc"><spring:message code="filemgr.label.crsauth.partclass" /></th><!-- 분반 -->
											<th scope="col" class="tc"><spring:message code="exam.label.applicate.dttm" /></th><!-- 신청일시 -->
											<th scope="col" class="tc"><spring:message code="exam.label.applicant" /></th><!-- 신청자 -->
											<th scope="col" class="tc"><spring:message code="score.label.process.status" /></th><!-- 처리상태 및 결과 -->
											<th scope="col" class="tc"><spring:message code="score.answer.date" /></th><!-- 답변일시 -->
											<th scope="col" class="tc"><spring:message code="button.ok" /></th><!-- 확인 -->
										</tr>
									</thead>
									<tbody id="objtTbody">
									</tbody>
								</table>
							</div>
						</div>
                    </div>
		        </div><!-- //ui form -->
            </div><!-- //content -->
            <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
        </div><!-- //container -->

    </div><!-- //pusher -->
    
    
    <!-- 성적 재확인 신청하기 팝업 -->
    <form class="ui form" id="modalScoreReCfmRegForm" name="modalScoreReCfmRegForm" method="POST" action="">
    	<input type="hidden" name="crsCreCd" />
    	<input type="hidden" name="scoreObjtCd" />
	    <div class="modal fade" id="modalScoreReCfmReg" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="common.label.score.reconfirm.yn" />" aria-hidden="false">
	        <div class="modal-dialog modal-lg" role="document">
	            <div class="modal-content">
	                <div class="modal-header">
	                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="sys.button.close" />">
	                        <span aria-hidden="true">&times;</span>
	                    </button>
	                    <h4 class="modal-title"><spring:message code="common.label.score.reconfirm.yn" /><!-- 성적재확인 신청 --></h4>
	                </div>
	                <div class="modal-body">
	                    <iframe src="" id="modalScoreReCfmRegIfm" name="modalScoreReCfmRegIfm" width="100%" scrolling="no" title="<spring:message code="common.label.score.reconfirm.yn" />"></iframe>
	                </div>
	            </div>
	        </div>
	    </div>
    </form>
    
    <!-- 답변확인 팝업 -->
    <form class="ui form" id="modalObjtProcCfmForm" name="modalObjtProcCfmForm" method="POST" action="">
    	<input type="hidden" name="crsCreCd"/>
    	<input type="hidden" name="stdNo"/>
	    <div class="modal fade" id="modalObjtProcCfm" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="score.answer.confirm" />" aria-hidden="false">
	        <div class="modal-dialog modal-lg" role="document">
	            <div class="modal-content">
	                <div class="modal-header">
	                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="sys.button.close" />">
	                        <span aria-hidden="true">&times;</span>
	                    </button>
	                    <h4 class="modal-title"><spring:message code="score.answer.confirm" /><!-- 답변확인 --></h4>
	                </div>
	                <div class="modal-body">
	                    <iframe src="" id="modalObjtProcCfmIfm" name="modalObjtProcCfmIfm" width="100%" scrolling="no" title="<spring:message code="score.answer.confirm" />"></iframe>
	                </div>
	            </div>
	        </div>
	    </div>
    </form>
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
	                    <iframe src="" id="modalObjtCtntIfm" name="modalObjtCtntIfm" width="100%" scrolling="no" title="<spring:message code="score.label.reason.view" />"></iframe>
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