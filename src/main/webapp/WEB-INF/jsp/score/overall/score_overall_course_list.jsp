<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	<link rel="stylesheet" type="text/css" href="/webdoc/css/main_default.css?v=3" />
	<script type="text/javascript">
		$(document).ready(function() {
			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					onObjtSearch();
				}
			});
			
			// 사용자 체크박스 선택
			$("#chkObjtAll").on("change", function(){
				if($(this).is(":checked")){
					$("input[name=objtDataChk]").prop("checked", true);
				} else {
					$("input[name=objtDataChk]").prop("checked", false);
				}
			});
			
			//탭2-추가
			$("#btnObjtAdd").on("click", function() {
				var calendarCtgr = '00210203';
				var crsCreCd = '<c:out value="${creCrsVO.crsCreCd}" />';
				var msg = '<spring:message code="score.alert.no.objt.proc.period" />'; // 성적재확인신청정정 기간이 아닙니다.
				//var uniCd = '<c:out value="${creCrsVO.uniCd}" />';
				//
				//if(uniCd == "G") {
				//	calendarCtgr = '00210205';
				//}
				
				checkJobSch(calendarCtgr, crsCreCd, msg).done(function() {
					$("#modalScoreReCfmTchRegForm input[name=haksaYear]").val($("#creYear").val());
					$("#modalScoreReCfmTchRegForm input[name=haksaTerm]").val($("#creTerm").val());
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
				form.append($('<input/>', {type: 'hidden', name: 'creYear', value: $("#creYear").val()}));
				form.append($('<input/>', {type: 'hidden', name: 'creTerm', value: $("#creTerm").val()}));
				form.append($('<input/>', {type: 'hidden', name: 'searchValue', value: $("#searchValue").val()}));
				form.attr("method", "POST");
				form.attr("name", "paperExcelForm");
				form.attr("action", url);
				form.appendTo("body");
				form.submit();
			});
			
			onObjtSearch();
		});
		
		// 학습자 목록
		function onObjtSearch() {
			var url  = "/score/scoreOverall/selectScoreObjtTchList.do";
			var data = {
				  creYear : $("#creYear").val()
				, creTerm : $("#creTerm").val()
				, searchValue : $("#searchValue").val()
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					var returnList = data.returnList || [];
					var html = '';
				
					returnList.forEach(function(v, i) {
						var procNm = "";
						
						if(!v.procCd) {
							procNm = '<spring:message code="score.label.objt.proc0" />'; // 신청
						} else if(v.procCd == "1") {
							procNm = '<spring:message code="score.label.objt.proc1" />'; // 승인(가산점 부여)
						} else if(v.procCd == "2") {
							procNm = '<spring:message code="score.label.objt.proc2" />'; // 확인(가산점 미부여)
						} else if(v.procCd == "3") {
							procNm = '<spring:message code="score.label.objt.proc3" />'; // 반려(가산점 미부여)
						}
						
						html += '<tr>';
						html += '    <td class="tc"><div class="ui checkbox"><input type="checkbox" name="objtDataChk" tabindex="0" user_id="' + v.objtUserId + '" user_nm="' + v.objtUserNm + '" mobile="' + v.userMobileNo + '" email="' + v.userEmail + '"><label></label></div></td>';
						html += '    <td class="p5 tc">' + v.lineNo + '</td>';
						html += '    <td class="word_break_none p5">' + v.crsCreNm + '(' + v.declsNo + ')</td>';
						html += '    <td class="word_break_none p5">' + v.deptNm + '</td>';
						html += '    <td class="word_break_none p5">' + v.objtUserId + '</td>';
						html += '    <td class="word_break_none p5">';
						html += 		v.objtUserNm;
						html += 		userInfoIcon("<%=SessionInfo.isKnou(request)%>", "userInfoPop('"+v.objtUserId+"')");
						html += '    </td>';
						html += '    <td class="p5 tc">' + (v.hy || '-') + '</td>';
						/* html += '    <td class="word_break_none tc">';
						html += '        <a href="javascript:onObjtCtntPop(\'' + v.scoreObjtCd + '\');" class="ui basic small button"><spring:message code="crs.reason" /></a>'; // 사유
						html += '    </td>'; */
						html += '    <td class="p5 tc">' + v.prvScore + '</td>';
						html += '    <td class="p5 tc">' + v.prvGrade + '</td>';
						html += '    <td class="p5 tc">' + v.modScore + '</td>';
						html += '    <td class="p5 tc">' + v.modGrade + '</td>';
						html += '    <td class="word_break_none tc">';
						html += '	 <a href="javascript:onObjtProcPop(\'' + v.crsCreCd + '\', \'' + v.objtUserId + '\', \'' + v.uniCd + '\', \'' + v.scoreObjtCd + '\');" class="ui basic small button"><spring:message code="exam.label.process.process" /></a>'; // 처리하기
						html += '    </td>';
						html += '    <td class="tc">' + procNm + '</td>';
						html += '</tr>';
					});
					
					$("#objtTbody").empty().html(html);
					
					if(returnList.length > 0) {
						$("#noResult").hide();
					} else {
						$("#noResult").show();
					}
					
					$("#totalCnt").text(returnList.length);
					
					$("#chkObjtAll").prop("checked", false);
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				/* 에러가 발생했습니다! */
				alert("<spring:message code='fail.common.msg' />");
			}, true);
		}
		
		//사유보기 팝업
		function onObjtCtntPop( scoreObjtCd ){
			$("#modalObjtCtntForm input[name=scoreObjtCd]").val(scoreObjtCd);
			$("#modalObjtCtntForm").attr("target", "modalObjtCtntIfm");
		    $("#modalObjtCtntForm").attr("action", "/score/scoreOverall/scoreOverallObjtCtntPopup.do");
		    $("#modalObjtCtntForm").submit();
		    $("#modalObjtCtnt").modal('show');
		}
	
		//처리하기 팝업
		function onObjtProcPop(crsCreCd, objtUserId, uniCd, scoreObjtCd) {
			var calendarCtgr;
			var msg = '<spring:message code="score.alert.no.objt.proc.period" />'; // 성적재확인신청정정 기간이 아닙니다.
			
			if(uniCd == "G") {
				calendarCtgr = "00210205"; // 대학원
			} else {
				calendarCtgr = "00210203"; // 학부
			}
			
			checkJobSch(calendarCtgr, crsCreCd, msg, true).done(function(jobSchEndYn) {
				if(${fn:contains(authGrpCd, 'TUT')}) {
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
		
		// 처리하기 팝업 콜백
		function objtProcPopCallBack() {
			onObjtSearch();
		}
		
		// 업무일정 체크
		function checkJobSch(calendarCtgr, crsCreCd, msg, useJobSchEndViewPop) {
			var deferred = $.Deferred();
			
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
						var jobSchEndYn = returnVO.jobSchEndYn;
						
						if(jobSchPeriodYn == "Y") {
							deferred.resolve();
						} else if(useJobSchEndViewPop && jobSchEndYn == "Y") {
							deferred.resolve(jobSchEndYn);
						} else {
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
			if($("#objtTbody").find("input[name=objtDataChk]:checked").length == 0){
				// 체크된 값이 없습니다.
				alert('<spring:message code="score.label.ect.eval.oper.msg14" />');
				return;
			}
			var rcvUserInfoStr = "";
			var sendCnt = 0;
			var dupCheckObj = {};
	
			$.each($("#objtTbody").find("input[name=objtDataChk]:checked"), function() {
				var userId = $(this).attr("user_id");
				
				if(dupCheckObj[userId])
					return true;
				dupCheckObj[userId] = true;
				
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
    <div id="wrap" class="main">
        <%@ include file="/WEB-INF/jsp/common/frontLnb.jsp" %>

		<div id="container">
			<%@ include file="/WEB-INF/jsp/common/frontGnb.jsp" %>
			
	        <!-- 본문 content 부분 -->
	        <div class="content">
	        	<div class="ui form">
	        		<div class="layout2">
	        			<div class="classInfo">
                			<div class="mra">
                				<h2 class="page-title"><spring:message code="common.label.score.reconfirm.yn.treat" /></h2><!-- 성적재확인 신청처리 -->
                			</div>
                		</div>
			            <div class="row">
			            	<div class="col">
			            		<p class="f110"><spring:message code="score.label.ect.eval.oper.msg16" /></p><!-- 운영중인 과목의 성적 재확인 신청을 관리합니다. -->
			            		<div class="mt15 mb15 tc bcLYellow p10 ui message">
			            			<ul>
			            				<li>
											<spring:message code="common.label.score.reconfirm.yn.processing" />
			            				</li>
			            				<li>
			            					<fmt:parseDate var="schStartDtFmt" pattern="yyyyMMddHHmmss" value="${sysJobSchVO.schStartDt }" />
											<fmt:formatDate var="schStartDt" pattern="yyyy.MM.dd HH:mm" value="${schStartDtFmt }" />
									    	<fmt:parseDate var="schEndDtFmt" pattern="yyyyMMddHHmmss" value="${sysJobSchVO.schEndDt }" />
											<fmt:formatDate var="schEndDt" pattern="yyyy.MM.dd HH:mm" value="${schEndDtFmt }" />
			            					<spring:message code="common.label.uni.college" /><!-- 학부 -->&nbsp;:&nbsp;${schStartDt } ~ ${schEndDt}
			            				</li>
			            				<li>
			            					<fmt:parseDate var="schStartDtFmt" pattern="yyyyMMddHHmmss" value="${sysJobSchVOGraduate.schStartDt }" />
											<fmt:formatDate var="schStartDt" pattern="yyyy.MM.dd HH:mm" value="${schStartDtFmt }" />
									    	<fmt:parseDate var="schEndDtFmt" pattern="yyyyMMddHHmmss" value="${sysJobSchVOGraduate.schEndDt }" />
											<fmt:formatDate var="schEndDt" pattern="yyyy.MM.dd HH:mm" value="${schEndDtFmt }" />
											<spring:message code="common.label.uni.graduate" /><!-- 대학원 -->&nbsp;:&nbsp;${schStartDt } ~ ${schEndDt}
			            				</li>
			            			</ul>
							    </div>
								<div class="option-content gab4">
							    	<h3 class="sec_head mb10"><spring:message code="score.label.objt.list" /></h3><!-- 성적재확인신청목록 -->
							    	<div class="mla">
				                    	<button class="ui basic button" onclick="sendMsg()"><i class="paper plane outline icon"></i><spring:message code="common.button.message" /></button><!-- 메시지 -->
															<c:if test="${!fn:contains(authGrpCd, 'TUT')}">
																<button type="button" class="ui orange button" id="btnObjtAdd"><spring:message code="button.plus" /></button><!-- 추가 -->
															</c:if>
				                    	<button class="ui green button" id="btnObjtExcel"><spring:message code="contents.excel.download.button" /></button><!-- 엑셀다운로드 -->
							    	</div>
							    </div>
							    <div class="option-content gab4">
								    <select class="ui dropdown" id="creYear" onchange="onObjtSearch()">
										<option value=""><spring:message code="std.label.year" /></option>
										<c:forEach var="item" items="${yearList }">
											<option value="${item }" ${item eq termVO.haksaYear ? 'selected' : '' }>${item }</option>
										</c:forEach>
									</select>
									<select class="ui dropdown" id="creTerm" onchange="onObjtSearch()">
										<option value=""><spring:message code="crs.label.open.term" /></option><!-- 개설학기 -->
										<c:forEach var="list" items="${termList }">
											<option value="${list.codeCd }" ${list.codeCd eq termVO.haksaTerm ? 'selected' : '' }>${list.codeNm }</option>
											<%-- <option value="${list.codeCd }" ${list.codeCd eq '20' ? 'selected' : '' }>${list.codeNm }</option> --%>
										</c:forEach>
									</select>
									<div class="ui action input search-box mr5">
				                        <input type="text" id="searchValue" placeholder="<spring:message code="user.message.search.input.userinfo.no.dept.nm" />"><!-- 학과/학번/성명 입력 -->
				                        <button class="ui icon button" onclick="onObjtSearch()"><i class="search icon"></i></button>
				                    </div>
									<div class="mla">
										<p>[ <spring:message code="exam.label.total" /><span class="fcBlue" id="totalCnt">0</span><spring:message code="exam.label.cnt" /> ]</p><!-- 총 건 -->
									</div>
							    </div>
							    <div class="ui segment p5 mt7 mb5">
								    <table class="tBasic type2">
	                                    <thead>         
	                                        <tr>
	                                            <th rowspan="2" class="num w30 p5"><div class="ui checkbox"><input type="checkbox" tabindex="0" id='chkObjtAll'><label></label></div></th>
	                                            <th rowspan="2" class="num w30 p5"><spring:message code="common.number.no"/></th><!-- No -->
	                                            <th rowspan="2"><spring:message code="crs.crsnm"/></th><!-- 과목명 -->
	                                            <th colspan="4"><spring:message code="common.label.learner" /></th><!-- 학습자 -->
	                                            <%-- <th rowspan="2" class="p5"><spring:message code="score.label.request.reason" /></th><!-- 신청사유 --> --%>
	                                            <th colspan="2" class="word-break-keep-all"><spring:message code="score.label.before.score" /></th><!-- 변경 전 성적 -->
	                                            <th colspan="2" class="word-break-keep-all"><spring:message code="score.label.after.score" /></th><!-- 변경 후 성적 -->
	                                            <th rowspan="2" class="word-break-keep-all p5"><spring:message code="common.label.score.reconfirm.yn.treat" /></th><!-- 성적재확인 신청처리 -->
	                                            <th rowspan="2" class="word-break-keep-all p5"><spring:message code="score.label.process.status" /></th><!-- 처리상태 및 결과 -->
	                                        </tr>   
	                                        <tr>
	                                            <th><spring:message code="lesson.label.dept" /></th><!-- 학과 -->
	                                            <th><spring:message code="lesson.label.user.no" /></th><!-- 학번 -->
	                                            <th><spring:message code="user.title.userinfo.manage.user.nm" /></th><!-- 성명 -->
	                                            <th class="num w40 p5"><spring:message code="asmnt.label.user.grade" /></th><!-- 학년 -->
	                                            <th class="num p5"><spring:message code="common.score" /></th><!-- 점수 -->
	                                            <th class="num p5"><spring:message code="exam.label.level" /></th><!-- 등급 -->
	                                            <th class="num p5"><spring:message code="common.score" /></th><!-- 점수 -->
	                                            <th class="num p5"><spring:message code="exam.label.level" /></th><!-- 등급 -->
	                                        </tr>    
	                                    </thead>
	                                    <tbody id="objtTbody">
	                                    </tbody>   
	                                </table>
	                                <div class="none tc pt10" id="noResult" style="display: none;">
				                        <span><spring:message code='common.nodata.msg'/></span><!-- 등록된 내용이 없습니다. -->
				                    </div>
								</div>
								<div class="ui message pt5 mt5">
	                                <div class="mt10">
									   	<b>▣ <spring:message code="score.alert.message.reconfirm1" /></b><!-- 성적재확인신청안내 -->
									   	<p><spring:message code="score.alert.message.reconfirm2" /></p><!-- 성적확인기간에 학생이 성적을 확인 후 재확인신청한 내역이 본 화면에 조회된다. -->
									   	<p><spring:message code="score.alert.message.reconfirm3" /></p><!-- 성적재확인신청 학생을 조회하고, 재확인신청사유를 확인하여 사유가 타당하면 성적을 정정하고 그렇지 않으면 반려처리 한다. -->
									</div>
									<div class="mt10">
									   	<b>1. <spring:message code="score.label.reason" /></b><!-- 사유 -->
										<p class="pl10">- <spring:message code="score.alert.message.reconfirm4" /></p><!-- 학생이 재확인신청사유를 조회한다. -->
									</div>
									<div class="mt10">
										<b>2. <spring:message code="score.label.chage" /></b><!-- 처리하기 -->
										<p class="pl10">- <spring:message code="score.alert.message.reconfirm5" /></p><!-- 재확인신청사유가 타당한 경우 성적을 변경하고 승인처리한다. 처리상태가 승인으로 나타난다. -->
										<p class="pl10">- <spring:message code="score.alert.message.reconfirm6" /></p><!-- 재확인신청사유가 부당한 경우는 반려사유를 입력 후 반려처리한다. 처리상태가 반려로 나타난다. -->
										<p class="pl10">- <spring:message code="score.alert.message.reconfirm7" /></p><!-- 성적변경처리 팝업화면이 나타나고, 재확인신청학생에 포커스가 자동으로 설정되어 변경이 필요하면 "가산점" 항목을 통해서 점수를 환산점수 및 성적등급을 변경한다. -->
									</div>
									<div class="mt10">
										<b>3. <spring:message code="score.label.total" /></b><!-- 추가,저장 -->
										<p class="pl10">- <spring:message code="score.alert.message.reconfirm8" /></p><!-- 재확인신청이 시스템으로 등록할 수 없는 경우에 불가피하게 담당교수가 직접 신청사유를 입력하여 등록하고, 재확인신청처리를 할 수 있다. -->
									</div>
								</div>
			            	</div>
			            </div>
	        		</div>
	        	</div>
	        </div>
	        <!-- //본문 content 부분 -->
	        <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
	        
	        <!-- 사유보기 팝업 -->
		    <form class="ui form" id="modalObjtCtntForm" name="modalObjtCtntForm" method="POST" action="">
		    	<input type="hidden" name="scoreObjtCd"/>
			    <div class="modal fade" id="modalObjtCtnt" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="score.label.reason.view" />" aria-hidden="false">
			        <div class="modal-dialog modal-lg" role="document">
			            <div class="modal-content">
			                <div class="modal-header">
			                    <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
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
		    	<input type="hidden" name="haksaYear"/>
		    	<input type="hidden" name="haksaTerm"/>
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
		</div>
    </div>
</body>
</html>