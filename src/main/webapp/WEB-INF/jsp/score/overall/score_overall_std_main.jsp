<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	<link rel="stylesheet" type="text/css" href="/webdoc/css/main_default.css?v=3" />
	<script type="text/javascript">
		$(function(){
			listCreCrs();
		});
		
		function listCreCrs(){
			var url  = "/score/scoreOverall/selectStdScoreObjtList.do";
			var data = {
				creYear		: $("#creYear").val(),
				creTerm		: $("#creTerm").val(),
				crsTypeCd	: "UNI",
			};
			
			$("#scoreObjtDiv").hide().empty();
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					var html = "";
					var returnList = data.returnList || [];
					
					checkLectEvalApi().done(function(isComplete) {
						if(!isComplete) {
							var evalHtml = '<i class="icon circle info"></i><spring:message code="score.label.lect.eval.oper.msg1" />'; // 강의평가 후 성적조회 가능합니다.
							evalHtml += '<a class="ui basic button small ml5 blinking-button" href="<c:out value="${lectEvalUrl}" />" target="_blank"><spring:message code="common.button.lect.eval" />'; // 강의평가
							
							$("#scoreObjtDiv").html(evalHtml).show();
							
							$("#scoreObjtDiv").html(evalHtml).show();
							
							setInterval(function() {
								$(".blinking-button").toggleClass("basic");
								$(".blinking-button").toggleClass("red");
							}, 1000);
						}
						
						returnList.forEach(function(v, i) {
							var totScore = v.totScore || '-';
							var scoreGrade = v.scoreGrade || '-';
							
							if(!isComplete) {
								totScore = '-';
								scoreGrade = '-';
							}
							
							html += '<tr>';
							html += '	<td class="tc">' + v.lineNo + '</td>';
							html += '	<td class="">' + v.crsCreNm + '</td>';
							html += '	<td class="tc">' + v.declsNo + '</td>';
							html += '	<td class="tc">' + v.compDvNm + '</td>';
							html += '	<td class="tc">' + v.tchUserNm + '</td>';
							html += '	<td class="tc">' + (v.credit * 1 || '-') + '</td>';
							html += '	<td class="tc">' + totScore + '</td>';
							html += '	<td class="tc">' + scoreGrade + '</td>';
							
							if(v.scoreStatus == "3" && v.scoreSearchYn == "Y" && isComplete) {
								if(!v.scoreObjtCd) {
									html += '	<td class="tc"><button type="button" class="ui blue small button" onclick="objtJoinPop(\'' + v.crsCreCd + '\', \'' + v.uniCd + '\')"><spring:message code="common.label.score.reconfirm.yn" /></button></td>'; // 성적재확인 신청
								} else {
									if(!v.procCd) {
										html += '<td class="tc"><a href="javascript:onObjtCtntPop(\'' + v.scoreObjtCd + '\')" class="ui basic small button"><spring:message code="score.button.submit.detail" /></a></td>'; // 신청내역
									} else {
										html += '<td class="tc"><a href="javascript:onObjtProcCfmPop(\'' + v.crsCreCd + '\', \'' + v.stdNo + '\');" class="ui basic small button"><spring:message code="score.answer.confirm" /></a></td>'; // 답변하기
									}
								}
							} else {
								html += '	<td class="tc">-</td>';
							}
							html += '</tr>';
						});
						
						$("#totCrsCnt").text(returnList.length);
						$("#creCrsTbody").empty().html(html);
						$("#creCrsTable").footable();
					});
		        } else {
		         	alert(data.message);
		        }
			}, function(xhr, status, error) {
				/* 에러가 발생했습니다! */
				alert("<spring:message code='fail.common.msg' />");
			});
		}
		
		// 강의평가
		function evalReschJoin() {
			var url = "/resh/evalLectReschCrypto.do";
			var data = {
				crsCreCd : $("#sCrsCreCd").val()
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnVO = data.returnVO;
					if(returnVO != null) {
						window.open(returnVO.goUrl, "_blank");
					}
				}
			}, function(xhr, status, error) {
				// 저장 중 오류가 발생하였습니다. 잠시 후 다시 시도해주세요. 
				alert("<spring:message code='score.alert.fail_save.message' />");
			});
		}
		
		// 답변확인
		function onObjtProcCfmPop(crsCreCd, stdNo) {
			$("#modalObjtProcCfmForm [name=crsCreCd]").val(crsCreCd);
			$("#modalObjtProcCfmForm [name=stdNo]").val(stdNo);
			$("#modalObjtProcCfmForm").attr("target", "modalObjtProcCfmIfm");
		    $("#modalObjtProcCfmForm").attr("action", "/score/scoreOverall/scoreOverallObjtProcCfmPopup.do");
		    $("#modalObjtProcCfmForm").submit();
		    $("#modalObjtProcCfm").modal('show');
		}
		
		// 신청하기
		function objtJoinPop(crsCreCd, uniCd) {
            checkJobSch(crsCreCd, uniCd).done(function() {
            	$("#modalScoreReCfmRegForm input[name=crsCreCd]").val(crsCreCd);
    			$("#modalScoreReCfmRegForm").attr("target", "modalScoreReCfmRegIfm");
    		    $("#modalScoreReCfmRegForm").attr("action", "/score/scoreOverall/scoreOverallScoreReCfmRegPopup.do");
    		    $("#modalScoreReCfmRegForm").submit();
    		    $("#modalScoreReCfmReg").modal('show');
            });
		}
		
		//수정하기
		function objtEditPop(crsCreCd, scoreObjtCd) {
			$("#modalScoreReCfmRegForm input[name=crsCreCd]").val(crsCreCd);
			$("#modalScoreReCfmRegForm input[name=scoreObjtCd]").val(scoreObjtCd);
			$("#modalScoreReCfmRegForm").attr("target", "modalScoreReCfmRegIfm");
		    $("#modalScoreReCfmRegForm").attr("action", "/score/scoreOverall/scoreOverallScoreReCfmModPopup.do");
		    $("#modalScoreReCfmRegForm").submit();
		    $("#modalScoreReCfmReg").modal('show');
		    $("#modalScoreReCfmRegForm input[name=scoreObjtCd]").val("");
		}
		// 성적재확인 신청 콜백
		function scoreReCfmModPopupCallBack() {
			listCreCrs();
		}
		
		// 강의평가 완료체크
		function checkLectEvalApi() {
			var deferred = $.Deferred();
			
			var lectEvalYn = '<c:out value="${lectEvalYn}" />';
			var userId = "<%=SessionInfo.getUserId(request)%>";
            var url = "<%=CommConst.ERP_API_LECT_EVAL_KEY%>" + userId + "/findLtApprUnRunLtCnt"; 
            
            var data = {};
   			
            if(lectEvalYn == "Y") {
            	$.ajax({
                    url : url
                    , type: "GET"
                    //, data : data
                    , beforeSend: function (xhr) {
                        xhr.setRequestHeader("Content-type","application/json");
                        xhr.setRequestHeader("ApiValue", "${langApiHeader}");
                    }                
                    , success: function (data) {
                    	var isComplete = true;
                    	
                    	if (data.code == "1") {
    						if (parseInt(data.result) > 0) {
    							isComplete = false;
    						}
    					}
                    	
                    	deferred.resolve(isComplete);
                    }
                    , error: function (jqXHR) 
                    { 
                        deferred.resolve(false);
                    }
                });
            } else {
            	deferred.resolve(true);
            }
            
            return deferred.promise();
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
				"haksaYear"	   : $("#creYear").val(),
				"haksaTerm"	   : $("#creTerm").val(),
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
		
		// lms 오픈일 이후 성적조회
		function checkLmsOpen(value) {
			$("[data-value='10']").show();
			$("[data-value='11']").show();
			
			if(value == "2023") {
				if($("#creTerm").val() == "10" || $("#creTerm").val() == "11") {
					$("#creTerm").dropdown("set value", "20");
					$("[data-value='10']").hide();
					$("[data-value='11']").hide();
				}
			}
		}
	</script>
</head>
<body class="<%=SessionInfo.getThemeMode(request)%>">
	<input type="hidden" id="sCrsCreCd" name="crsCreCd" />
    <div id="wrap" class="main">									
        <%@ include file="/WEB-INF/jsp/common/frontLnb.jsp" %>
        
		<div id="container">											
            <%@ include file="/WEB-INF/jsp/common/frontGnb.jsp" %>
            		
			<div class="content stu_section">							
				<div class="ui form">
					<div class="layout2">
						<div class="classInfo">
                			<div class="mra">
                				<h2 class="page-title"><spring:message code="score.label.university.score" /></h2><!-- 종합성적 -->
                			</div>
                		</div>

                        <div class="row">
                            <div class="col">
								<p class="f110"><spring:message code="score.label.lect.eval.oper.msg2" /><span class="fcBlue ml10">[ ※ <spring:message code="score.label.lect.eval.oper.msg5" /> ]</span></p><!-- 수강중인 과목의 종합성적을 조회합니다. -->
			            		<div class="mt15 mb15 tc bcYellow p10">
									<fmt:parseDate var="schStartDtFmt" pattern="yyyyMMddHHmmss" value="${sysJobSchVO.schStartDt }" />
									<fmt:formatDate var="schStartDt" pattern="yyyy.MM.dd HH:mm" value="${schStartDtFmt }" />
							    	<fmt:parseDate var="schEndDtFmt" pattern="yyyyMMddHHmmss" value="${sysJobSchVO.schEndDt }" />
									<fmt:formatDate var="schEndDt" pattern="yyyy.MM.dd HH:mm" value="${schEndDtFmt }" />
							    	<spring:message code="score.label.check.grades" /> : ${schStartDt } ~ <%-- ${schEndDt } --%><!-- 성적 조회기간 -->
							    </div>
							    
							    <h3 class="sec_head mb10"><spring:message code="score.label.service.lecture" /></h3><!-- 운영과목 -->
							    <div class="option-content mb20">
							    	<label for="creYear" class="hide"><spring:message code="exam.label.open.year" /></label>
								    <select class="ui dropdown" id="creYear" onchange="checkLmsOpen(this.value); listCreCrs()">
										<option value=""><spring:message code="std.label.year" /></option><!-- 년도 -->
										<c:forEach var="item" items="${yearList }">
											<c:if test="${item > 2022}">
											<option value="${item }" ${item eq termVO.haksaYear ? 'selected' : '' }>${item }</option>
											</c:if>
										</c:forEach>
									</select>
									<label for="creTerm" class="hide"><spring:message code="exam.label.open.term" /></label>
									<select class="ui dropdown" id="creTerm" onchange="listCreCrs()">
										<option value=""><spring:message code="crs.label.open.term" /></option><!-- 개설학기 -->
										<c:forEach var="list" items="${termList }">
											<option value="${list.codeCd }" ${list.codeCd eq termVO.haksaTerm ? 'selected' : '' }>${list.codeNm }</option>
											<%-- <option value="${list.codeCd }" ${list.codeCd eq '20' ? 'selected' : '' }>${list.codeNm }</option> --%>
										</c:forEach>
									</select>
									<div class="mla inline-flex-item">
										<div class="ui info message mr10" id='scoreObjtDiv' style="display: none;">
					                    </div>
										<p>[ <spring:message code="resh.label.tot" />  <span class="fcBlue" id="totCrsCnt">0</span><spring:message code="resh.label.cnt" /> ]</p><!-- 총건 -->
									</div>
							    </div>
							    <table class="table type2" id="creCrsTable" data-sorting="true" data-paging="false" data-empty="<spring:message code="filebox.common.empty" />">
							    	<caption class="hide"><spring:message code="score.label.university.score" /></caption>
							    	<thead>
							    		<tr>
							    			<th scope="col" class="tc"><spring:message code="common.number.no" /></th><!-- NO. -->
							    			<th scope="col" class="tc"><spring:message code="filemgr.label.crsauth.crsnm" /></th><!-- 과목명 -->
							    			<th scope="col" class="tc"><spring:message code="filemgr.label.crsauth.partclass" /></th><!-- 분반 -->
							    			<th scope="col" class="tc"><spring:message code="crs.label.compdv" /></th><!-- 이수구분 -->
							    			<th scope="col" class="tc"><spring:message code="crs.label.representative.professor" /></th><!-- 대표교수 -->
							    			<th scope="col" class="tc"><spring:message code="crs.label.credit" /></th><!-- 학점 -->
							    			<th scope="col" class="tc"><spring:message code="asmnt.label.total.point" /></th><!-- 총점 -->
							    			<th scope="col" class="tc"><spring:message code="crs.label.final.score" /></th><!-- 최종성적 -->
							    			<th scope="col" class="tc"><spring:message code="common.label.score.reconfirm.yn" /><!-- 성적재확인 신청 --></th>
							    		</tr>
							    	</thead>
							    	<tbody id="creCrsTbody"></tbody>
							    </table>
	                    	</div>
	                	</div>
                    </div>
		        </div><!-- //ui form -->
            </div><!-- //content -->
        </div><!-- //container -->
    </div><!-- //pusher -->
    <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
    
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