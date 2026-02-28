<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/editor_inc.jsp" %>

	<script type="text/javascript">
		var isKnou = "${isKnou}";
		$(document).ready(function(){
			$('input[type="text"]').keydown(function(){
				if (event.keyCode === 13) {
				    event.preventDefault();
				}
			});
			
			initCalDiv4();
			
			$("#writeTab").find('a').eq(0).trigger("click");
			
			var crsCreCd = '${creCrsVo.crsCreCd}';
			
			if(crsCreCd) {
				getCrsLesson();
			} else {
				if(isKnou == 'true') {
					setSearchBox();
				}
			}
		});
		
		function changeTerm(obj) {
			var termCd = obj.value;
			var temp = "";
		
			setSearchBox();
		}
		
		function getCrsLesson() {
			var url = '/lesson/lessonHome/listLessonSchedule.do';
			var data = {
				crsCreCd: '${creCrsVo.crsCreCd}'
			}
		
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					var html = '';
					
					if(returnList.length > 0) {
						var disabled = "";
						if('${creCrsVo.erpLessonYn}' == 'Y') {
							disabled = 'disabled';
						} else {
							disabled = $("input[name='erpLessonYn'][value='Y']").prop("checked") ? "disabled" : "";
						}
						
						html += '<ul class="tbl">';
						returnList.forEach(function(v, i) {
							var title = v.lessonScheduleOrder + '<spring:message code="common.week"/>'; // 주차
							
							if(v.wekClsfGbn == "04") {
								title = title + ' <span class="">(<spring:message code="exam.label.mid"/>)</span>'; // 중간
							} else if(v.wekClsfGbn == "05") {
								title = title + ' <span  class="">(<spring:message code="exam.label.final"/>)</span>'; // 기말
							}
							
							html += '<li data-lesson-schedule-id="' + v.lessonScheduleId + '">';
							html += '	<dl>';
							html += '		<dt class="req" style="width:160px;">' + title + '</dt>';
							html += '		<dd>';
							html += '			<div class="inline fields mb0">';
							html += '				<div class="field">';
							html += '					<div class="ui calendar" id="lessonStartCal' + i + '">';
							html += '						<div class="ui input left icon">';
							html += '							<i class="calendar alternate outline icon"></i>';
							//html += '							<input type="text" class="w200" id="lessonStartDt_' + v.lessonScheduleId + '" value="' + dtFormat(v.lessonStartDt) + '" placeholder="<spring:message code="common.start.date"/>" autocomplete="off" ' + disabled + ' />';
							html += '							<input type="text" class="w200" id="lessonStartDt_' + v.lessonScheduleId + '" value="' + dtFormat(v.lessonStartDt) + '" placeholder="<spring:message code="common.start.date"/>" autocomplete="off" disabled />';
							html += '						</div>';
							html += '					</div>';
							html += '				</div>';
							html += '				<div class="field">';
							html += '					<div class="ui calendar" id="lessonEndCal' + i + '">';
							html += '						<div class="ui input left icon">';
							html += '							<i class="calendar alternate outline icon"></i>';
							//html += '							<input type="text" class="w200" id="lessonEndDt_' + v.lessonScheduleId + '" value="' + dtFormat(v.lessonEndDt) + '" placeholder="<spring:message code="common.start.date"/>" autocomplete="off" ' + disabled + ' />';
							html += '							<input type="text" class="w200" id="lessonEndDt_' + v.lessonScheduleId + '" value="' + dtFormat(v.lessonEndDt) + '" placeholder="<spring:message code="common.start.date"/>" autocomplete="off" disabled />';
							html += '						</div>';
							html += '					</div>';
							html += '				</div>';
							if(!disabled) {
								html += '			<div class="inline fields mb0">';
								html += '				<div class="field">';
								html += '					<a class="ui button small basic" href="javascript:lessonScheduleWriteModal(\'' + v.lessonScheduleId + '\')"><spring:message code="common.button.modify"/></a>'; // 수정
								html += '				</div>';
								html += '			</div>';
							}
							html += '			</div>';
							html += '		</dd>';
							html += '	</dl>';
							html += '	<dl>';
							html += '		<dt class="pt0" style="width:160px;"><spring:message code="lesson.label.lt.dttm"/></dt>'; // 출석인정 기간
							html += '		<dd class="pt0">';
							html += '			<div class="inline fields mb0">';
							html += '				<div class="field">';
							html += '					<div class="ui calendar" id="ltDetmFrDCal' + i + '">';
							html += '						<div class="ui input left icon">';
							html += '							<i class="calendar alternate outline icon"></i>';
							html += '							<input type="text" class="w200" id="ltDetmFrDt_' + v.lessonScheduleId + '" value="' + dtFormat(v.ltDetmFrDt) + '" placeholder="<spring:message code="common.start.date"/>" autocomplete="off" ' + disabled + ' />';
							html += '						</div>';
							html += '					</div>';
							html += '				</div>';
							html += '				<div class="field">';
							html += '					<div class="ui calendar" id="ltDetmToDtCal' + i + '">';
							html += '						<div class="ui input left icon">';
							html += '							<i class="calendar alternate outline icon"></i>';
							html += '							<input type="text" class="w200" id="ltDetmToDt_' + v.lessonScheduleId + '" value="' + dtFormat(v.ltDetmToDt) + '" placeholder="<spring:message code="common.start.date"/>" autocomplete="off" ' + disabled + ' />';
							html += '						</div>';
							html += '					</div>';
							html += '				</div>';
							/*
							if(!disabled) {
								html += '			<div class="inline fields mb0">';
								html += '				<div class="field">';
								html += '					<a class="ui button small basic" href="javascript:deleteLessonSchedule(\'' + v.lessonScheduleId + '\')"><spring:message code="common.button.delete"/></a>'; // 삭제
								html += '				</div>';
								html += '			</div>';
							}
							*/
							html += '			</div>';
							html += '		</dd>';
							html += '	</dl>';
							html += '</li>';
						});
						html += '</ul>';
						
						$("#lessonScheduleList").html(html);
						$("#lessonScheduleList").find(".ui.checkbox").checkbox();
						
						setTimeout(function() {
							returnList.forEach(function(v, i) {
								createCalendar($("#lessonStartCal" + i), $("#lessonStartCal" + i), $("#lessonEndCal" + i), 'START');
								createCalendar($("#lessonEndCal" + i), $("#lessonStartCal" + i), $("#lessonEndCal" + i), 'END');
								createCalendar($("#ltDetmFrDCal" + i), $("#ltDetmFrDCal" + i), $("#ltDetmToDtCal" + i), 'START');
								createCalendar($("#ltDetmToDtCal" + i), $("#ltDetmFrDCal" + i), $("#ltDetmToDtCal" + i), 'END');
							});
						}, 0);
					} else {
						html += '<div class="flex-container">';
		                html += '   <div class="cont-none">';
		                html += '       <span></span>';
		                html += '   </div>';
		                html += '</div>';
		                
		                $("#lessonScheduleList").html(html);
					}
					
					/*
					$("#lessonScheduleAddBtn").off("click");
					
					if(disabled) {
						$("#lessonScheduleAddBtn").hide();
					} else {
						$("#lessonScheduleAddBtn").show();
						
						$("#lessonScheduleAddBtn").on("click", function() {
							lessonScheduleWriteModal();
						});
					}
					*/
				}
			}, function(xhr, status, error) {
			}, true);
		}
		
		// 달력 생성
		function createCalendar(calObj, startCalObj, endCalObj, startOrEndFlag) {
			var startCal;
			var endCal;
			if(startOrEndFlag == 'START') {
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
						if(month.length < 2) {
							month = '0' + month;
						}
						if(day.length < 2) {
							day = '0' + day;
						}
						var year = date.getFullYear();
						
						return year + '.' + month + '.' + day;
					}
				},
			});
		}
		
		function setSearchBox() {
			$('#crsCdSearch').search('destroy');
		
			$('#crsCdSearch').search({
				type		  : 'category',
				minCharacters : 2,
				apiSettings   : {
					onResponse: function(result) {
						var response = {
							results : {}
						};
			
						$.each(result.returnList, function(index, item) {
							var
							crsTypeNm   = item.crsTypeNm || 'Unknown',
							maxResults = 15	;
			
							if(index >= maxResults) {
								return false;
							}
			
							if(response.results[crsTypeNm] === undefined) {
								response.results[crsTypeNm] = {
									name	: crsTypeNm,
									results : []
								};
							}
			
							var crsOperTypeCdNm = "";
							if(item.crsOperTypeCd === "ONLINE") {
								crsOperTypeCdNm = "온라인";
							} else if(item.crsOperTypeCd === "OFFLINE") {
								crsOperTypeCdNm = "오프라인";
							} else if(item.crsOperTypeCd === "MIX") {
								crsOperTypeCdNm = "혼합";
							}
			
							var description = "교육 방법 : "+ crsOperTypeCdNm + "<br> 과목 설명 : " + item.crsDesc;
			
							response.results[crsTypeNm].results.push({
								title	   			: item.crsNm,
								description 	: description,
								url		   			: "javascript:setCrsCd('"+item.crsCd+"');"
							});
						});
						
						return response;
					},
					url: '/crs/creCrsMgr/searchCrsList.do?searchValue={query}&crsTypeCd=UNI'
				}
			});
		}
		
		function setCrsCd(crsCd) {
			$("#crsCd").val(crsCd);
		}
		
		// 분반중복체크
		function checkDeclsNo() {
			var url = '/crs/creCrsHome/checkDeclsCnt.do';
			var data = {
				  termCd	: $("#termCd").val()
				, crsCd		: $("#crsCd").val()
				, declsNo 	: $("#declsNo").val()
				, searchKey	: "UNI"	
			}
		
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnVO = data.returnVO || {};
					
					if(returnVO.declsCnt > 0) {
						alert('<spring:message code="crs.alert.term.select.crecrs.double" />'); // 선택한 학기와 과목에 이미 개설된 분반이 있습니다.
					}
				}
			}, function(xhr, status, error) {
			}, true);
		}
		
		function add(gubun) {
			var orgId = '${orgId}';
			var haksaDataYn = '${creCrsVo.haksaDataYn}';
			
			/* 기본정보 시작 */
			if(!$("#termCd").val()) {
				alert('<spring:message code="crs.course.year.select"/>'); // 개설 년도 설정 바랍니다.
				return;
			}
			
			if(!$("#crsCd").val()) {
				if("${isKnou}" == "true") {
					alert('<spring:message code="crs.confirm.course.setting"/>'); // 과목 설정 바랍니다.
				} else {
					alert('<spring:message code="crs.confirm.input.crs.cd"/>'); // 학수번호를 입력하세요.
				}
				return;
			}
			
			if(!$.trim($("#crsCreNm").val())) {
				alert('<spring:message code="crs.confirm.course.name.setting"/>'); // 개설 과목명 설정 바랍니다.
				return;
			}
		
			if(!$.trim($("#declsNo").val())) {
				alert('<spring:message code="crs.confirm.insert.common.declsno"/>'); // 분반 입력 바랍니다.
				$("#note-btn").trigger("click");
				$("#declsNo").focus();
				return;
			}
			
			if(!$("#deptCd").val()) {
				alert('<spring:message code="crs.confirm.select.common.deptnm"/>'); // 개설 학과 선택 바랍니다.
				return;
			}
			/* 기본정보 끝 */
		
			/* 평가방법 시작 */
			<%--
			var fixeda = $("#fixedA").val(); 
			if(!isNaN(fixeda)) {
				fixeda = 0;
			}
			var pfixeda = parseInt(fixeda, 0);
			var fixedb = $("#fixedB").val(); var pfixedb = parseInt(fixedb, 0);
			var fixedc = $("#fixedC").val(); var pfixedc = parseInt(fixedc, 0);
			var fixedd = $("#fixedD").val(); var pfixedd = parseInt(fixedd, 0);
			var fixedf = $("#fixedF").val(); var pfixedf = parseInt(fixedf, 0);
			var ratioa1 = $("#ratioA1").val(); var pratioa1 = parseInt(ratioa1, 0);
			var ratioa2 = $("#ratioA2").val(); var pratioa2 = parseInt(ratioa2, 0);
			var ratiob = $("#ratioB").val(); var patiob = parseInt(ratiob, 0);
			var passscore = $("#passScore").val(); var pScore = parseInt(passscore, 0);
			
			if($("input[name='scoreEvalType']:checked").val() == "RELATIVE" || $("input[name='scoreEvalType']:checked").val() == "ABSOLUTE"){
				if(scoregradetype == "FIXED"){
					if(pfixeda < 0 &&  pfixedb < 0  && pfixedc < 0  && pfixedd < 0  && pfixedf < 0) {
						$("#note-box").removeClass("warning");
						$("#note-box").prop("class","warning");
						$("#note-box").html("성적등급의 비율은 0보다 커야 합니다.");
						$("#note-btn").trigger("click");
						$("#fixedA").focus();
						return;
					}
					ratioa1 = 0; ratioa2 = 0; ratiob = 0; passscore = 0;
				}
				if(scoregradetype == "RATIO"){
					if(pratioa1 < 0 &&  pratioa2 < 0  && patiob < 0) {
						$("#note-box").removeClass("warning");
						$("#note-box").prop("class","warning");
						$("#note-box").html("성적등급 입력바랍니다.");
						$("#note-btn").trigger("click");
						$("#ratioA1").focus();
						return;
					}
					fixeda = 0; fixedb = 0; fixedc = 0; fixedd = 0; fixedf = 0;
				}
			}
			--%>
			/* 평가방법 끝*/
			
			/* 강의 설정 시작 */
			if(!$("#scoreEvalType").val()){
				alert("평가방법 설정 바랍니다");
				return;
			}
			
			
			if($("#scoreEvalType").val() == "PF" && orgId != 'ORG0000001'){
				if(!$("#passScore").val()) {
					alert("평가방법의 통과점수를 설정 바랍니다");
					return;
				}
			}
			/*강의 설정 끝*/
			/* 
			// 수강신청 시작
			var pnopLimitYn = $("input[name='nopLimitYn']:checked").val();
			var penrlNop = $("#enrlNop").val();
			if(pnopLimitYn == 'N'){
				penrlNop = 0;
			}
			// 수강신청 끝 
			 */
			/* 
			// 강의기간 시작
			if(haksaDataYn != "Y") {
				//var enrlAplcStartDttm = $("#enrlAplcStartDttmText").val();
				//var enrlAplcEndDttm = $("#enrlAplcEndDttmText").val();
				var enrlAplcStartDttm = $("#enrlStartDttmText").val();
				var enrlAplcEndDttm = $("#enrlEndDttmText").val();
				var enrlStartDttm = $("#enrlStartDttmText").val(); 
				var enrlEndDttm = $("#enrlEndDttmText").val();
				var scoreHandlStartDttm = $("#scoreHandlStartDttmText").val(); 
				var scoreHandlEndDttm = $("#scoreHandlEndDttmText").val();
				
				//if(!enrlAplcStartDttm || !enrlAplcEndDttm) {
				//	alert("강의기간 탭의 수강 신청 기간 확인바랍니다");
				//	return;
				//}
				
				
				if(!enrlStartDttm || !enrlEndDttm) {
					alert("강의기간 탭의 강의 기간 확인바랍니다.");
		
					return;
				}
				
				if(!scoreHandlStartDttm || !scoreHandlEndDttm) {
					alert("강의기간 탭의 성적 처리 기간 확인바랍니다");
					return;
				}
				
				$("#enrlAplcStartDttm").val(enrlAplcStartDttm.replaceAll(".", "") + "000000");
				$("#enrlAplcEndDttm").val(enrlAplcEndDttm.replaceAll(".", "") + "235959");
				$("#enrlStartDttm").val(enrlStartDttm.replaceAll(".", "") + "000000");
				$("#enrlEndDttm").val(enrlEndDttm.replaceAll(".", "") + "235959");
				$("#scoreHandlStartDttm").val(scoreHandlStartDttm.replaceAll(".", "") + "000000");
				$("#scoreHandlEndDttm").val(scoreHandlEndDttm.replaceAll(".", "") + "235959");
			}
			// 강의기간 끝
			 */
			
			var url = '/crs/creCrsMgr/crsCreAdd.do';
			var dataArray = $("form[name=creCrsWriteForm]").serializeArray();
			
			var data = {};
			$.each(dataArray, function() {
				data[this.name] = this.value;
			});
			
			if(data.erpLessonYn != "Y") {
				var isValidScheduleDt = true;
				var isValidLtDetmDt = true;
				$.each($('[data-lesson-schedule-id]'), function() {
					var lessonScheduleId = $(this).data("lessonScheduleId");
					var lessonStartDt = $("#lessonStartDt_" + lessonScheduleId).val();
					var lessonEndDt = $("#lessonEndDt_" + lessonScheduleId).val();
					var ltDetmFrDt = $("#ltDetmFrDt_" + lessonScheduleId).val();
					var ltDetmToDt = $("#ltDetmToDt_" + lessonScheduleId).val();
					
					if(!data.lessonScheduleList) {
						data.lessonScheduleList = [];
					}
					
					if(!lessonStartDt || !lessonEndDt) {
						isValidScheduleDt = false;
						return false;
					}
					
					if((!ltDetmFrDt && ltDetmToDt) || (ltDetmFrDt && !ltDetmToDt)) {
						isValidLtDetmDt = false;
						return false;
					}
					
					data.lessonScheduleList.push({
						  lessonScheduleId: lessonScheduleId
						//, lessonStartDt: lessonStartDt.replaceAll(".", "")
						//, lessonEndDt: lessonEndDt.replaceAll(".", "")
						, ltDetmFrDt: ltDetmFrDt.replaceAll(".", "")
						, ltDetmToDt: ltDetmToDt.replaceAll(".", "")
					});
				});
				
				if(!isValidScheduleDt) {
					alert("주차의 날짜는 필수값 입니다.");
					return;
				}
				
				if(!isValidLtDetmDt) {
					alert("출석인정기간을 입력한 경우 시작일, 종료일을 입력하세요.");
					return;
				}
			}
			
			data = JSON.stringify(data);
			
			$.ajax({
				url: url,
				type: "POST",
				contentType: "application/json",
				data: data,
				dataType: "json",
				beforeSend : function() {
					showLoading();
				},
				success: function(data) {
					if(data.result > 0) {
		        		alert("과목 정보 등록 성공하였습니다");
		        		
		        		if(gubun == "NEXT") {
							moveTch(data.returnVO.crsCreCd, data.returnVO.crsCd);
						} else {
							//location.reload();
							document.location.href = "/crs/creCrsMgr/Form/creCrsListForm.do";
						}
		            } else {
		            	alert(data.message);
		            }
		        	hideLoading();
				},
				error: function(xhr, status, error) {
					console.log(error);
					alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
				},
				complete: function() {
					hideLoading();
				},
			});
		}
		
		function moveTch(crsCreCd, crsCd) {
			if(!crsCreCd) {
				alert('<spring:message code="crs.confirm.insert.lecture.info"/>'); // 개설 과목 정보를  등록 바랍니다.
				return;
			} else {
				$("#creCrsWriteForm").attr("action","/crs/creCrsMgr/Form/crsTchForm.do");
				$("#crsCreCd").val(crsCreCd);
				$("#crsCd").val(crsCd);
				$("#crsTypeCd").val("UNI");
				$('#creCrsWriteForm').submit();
			}
		}
		
		function moveStd(crsCreCd) {
			if(!crsCreCd) {
				alertl('<spring:message code="crs.confirm.insert.lecture.info"/>'); // 개설 과목 정보를  등록 바랍니다.
				return;
			} else {
				$("#creCrsWriteForm").attr("action","/crs/creCrsMgr/Form/crsStdForm.do");
				$("#crsCreCd").val(crsCreCd);
				$("#crsTypeCd").val("UNI");
				$('#creCrsWriteForm').submit();
			}
		}
		
		function changeScoreEvalType(scoreEvalType) {
			if(scoreEvalType == "PF") {
				$("#scoreEvalTypeSection").show();	
			} else {
				$("#scoreEvalTypeSection").hide();
			}
		}
		
		function showEnrollLimit(val) {
			if(val == 'Y') {
				$("#enrollLimit").show();
			} else {
				$("#enrollLimit").hide();
			}
		}
		
		function initCalDiv4() {
			var calList = [
				  {start: "#rangestart",  end: "#rangeend", startVal: '${creCrsVo.enrlAplcStartDttm}', endVal: '${creCrsVo.enrlAplcEndDttm}'}
				, {start: "#rangestart2", end: "#rangeend2", startVal: '${creCrsVo.enrlStartDttm}', endVal: '${creCrsVo.enrlEndDttm}'}
				, {start: "#rangestart3", end: "#rangeend3", startVal: '${creCrsVo.scoreHandlStartDttm}', endVal: '${creCrsVo.scoreHandlEndDttm}'}
			];
			
			calList.forEach(function(calInfo, i) {
				// 달력 시작
				$(calInfo.start).calendar({
	                type: 'date',
	                endCalendar: $(calInfo.end),
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
				// 달력 종료
	            $(calInfo.end).calendar({
	                type: 'date',
	                startCalendar: $(calInfo.start),
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
				
	            $(calInfo.start).find('input').val(dtFormat(calInfo.startVal));
	            $(calInfo.end).find('input').val(dtFormat(calInfo.endVal));
			});
		}
		
		// 8자리 달력 포멧 세팅
		function dtFormat(dttm) {
			dttm = dttm || "";
			
			if(dttm.length == 8 || dttm.length == 14) {
				dttm = dttm.substring(0, 4) + "." + dttm.substring(4, 6) + "." + dttm.substring(6, 8);
			}
			
			return dttm
		}
		
		// 주차추가 모달
		function lessonScheduleWriteModal(lessonScheduleId) {
			if($("input[name='erpLessonYn'][value='Y']").prop("checked")) {
				// ERP 주차 연동 미사용 강의실만 가능합니다.
				alert('<spring:message code="lesson.error.impossible.erp.lesson.y" />');
				return;
			}
			
			$("#lessonScheduleWriteForm > input[name='crsCreCd']").val('${creCrsVo.crsCreCd}');
			$("#lessonScheduleWriteForm > input[name='lessonScheduleId']").val(lessonScheduleId);
			$("#lessonScheduleWriteForm").attr("target", "lessonScheduleWriteIfm");
	        $("#lessonScheduleWriteForm").attr("action", "/lesson/lessonHome/lessonScheduleWritePop.do");
	        $("#lessonScheduleWriteForm").submit();
	        $('#lessonScheduleWriteModal').modal('show');
		}
		
		// 주차추가 모달 콜백
		function lessonScheduleWritePopCallback() {
			alert('<spring:message code="common.result.success" />'); // 성공적으로 작업을 완료하였습니다.
			getCrsLesson();
		}
		
		// 주차 삭제
		function deleteLessonSchedule(lessonScheduleId) {
			// 삭제하시겠습니까?
			if(!confirm('<spring:message code="common.delete.msg" />')) return;
			
			var url = '/lesson/lessonHome/deleteLessonSchedule.do';
			var data = {
				  crsCreCd: '${creCrsVo.crsCreCd}'
				, lessonScheduleId: lessonScheduleId
			};
		
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					alert('<spring:message code="common.result.success" />'); // 성공적으로 작업을 완료하였습니다.
					getCrsLesson();
				} else {
					alert(data.message);
				}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		}
	</script>
</head>
<body>
<form class="ui form" id="creCrsWriteForm" name="creCrsWriteForm" method="POST" action="" >
	<input type="hidden" id="crsCreCd" 		name="crsCreCd" 	value="${creCrsVo.crsCreCd}"/>
	<input type="hidden" id="crsTypeCd" 	name="crsTypeCd" 	value="UNI"/>
	<input type="hidden" id="haksaDataYn" 	name="haksaDataYn" 	value="${creCrsVo.haksaDataYn}"/>
	
	<div id="wrap" class="pusher">
	    <!-- class_top 인클루드  -->
	    <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
	    <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>
	    <div id="container">
	        <!-- 본문 content 부분 -->
	        <div class="content">
	        	<div id="info-item-box">
					<h2 class="page-title flex-item">
					    <spring:message code="common.term.subject"/><!-- 학기/과목 -->
					    <div class="ui breadcrumb small">
					        <small class="section"><spring:message code="crs.title.subject.setup.management" /><!-- 학기제 과목 개설 관리 --></small>
					    </div>
					</h2>
				    <div class="button-area">
				    	<a href="javascript:add('NEXT')" class="btn"><spring:message code="button.next"/></a><!-- 다음 -->
						<a href="javascript:add()" class="btn btn-primary"><spring:message code="button.add"/></a><!-- 저장 -->
						<a href="/crs/creCrsMgr/Form/creCrsListForm.do" class="btn btn-negative"><spring:message code="button.cancel"/></a><!-- 취소 -->
				    </div>
				</div>
				<div class="ui divider mt0"></div>
				<div class="ui form" >
					<ol class="cd-multi-steps text-bottom count">
						<li class="current"><span><spring:message code="crs.label.lecture.info.regist"/></span></li><!-- 개설 과목 정보 등록 -->
						<li><a href="javascript:moveTch('${creCrsVo.crsCreCd}', '${creCrsVo.crsCd}');"><span><spring:message code="crs.label.reg.operator"/></span></a></li><!-- 운영자 등록 -->
						<li><a href="javascript:moveStd('${creCrsVo.crsCreCd}');"><span><spring:message code="crs.label.learner.regist"/></span></a></li><!-- 수강생 등록 -->
					</ol>
					<div class="ui grid stretched row" >
						<div class="sixteen wide tablet eight wide computer column">
							<div class="ui segment">
								<ul class="tbl-simple">
									<li>
										<dl>
											<dt><label for="semesterLabel" class="req"><spring:message code="common.term"/></label></dt> <%-- 학기 --%>
											<dd>
												<select class="ui fluid search selection dropdown w300 " id="termCd" name="termCd" onchange="changeTerm(this);">
													<c:if test="${empty creCrsVo}">
														<option value=""><spring:message code="common.alert.select.term"/></option> <%-- 학기를 선택하세요 --%>
													</c:if>
													<c:forEach var="item" items="${creTermList}"  varStatus="status">
														<c:set var="termCdVal" value="item.termCd"/>
														<option value="${item.termCd}" <c:if test="${termCdVal eq item.termCd}">selected</c:if>>${item.termNm}</option>
													</c:forEach>
												</select>
											</dd>
										</dl>
									</li>
									<c:if test="${isKnou eq true}">
									<li> 
										<dl>
											<dt><label for="subjectLabel" class="req"><spring:message code="common.subject"/></label></dt> <!-- 과목 -->
											<dd>
												<div class="ui search category <c:if test="${not empty creCrsVo.crsCreCd}"> disabled fluid input</c:if>" id="crsCdSearch">
													<input class="prompt" name="crsCdSearch" type="text" value="${creCrsVo.crsNm}" placeholder="과목 검색 후, 과목 정보를 선택해주세요." autocomplete="off" 
														<c:if test="${not empty creCrsVo.crsCreCd}">disabled="disabled"</c:if> >
														<div class="results"></div>
												</div>
												<input type="hidden" id="crsCd" name="crsCd"  value="${creCrsVo.crsCd}"/>
												<script>
													$("input[name=crsCdSearch]").focusout(function(){
														if( $("#crsCd").val() === ''){
															$(this).text(''); $(this).val('');
														}
													});
												</script>
											</dd>
										</dl>
									</li>
									</c:if>
									<li>
										<dl>
											<dt><label for="subjectLabel_ko" class="req"><spring:message code="common.label.crsauth.crsnm"/> <spring:message code="crs.common.lang.ko"/></label></dt> <%-- 과목명 --> <!-- (KO) --%>
											<dd>
												<div class="ui fluid input">
													<input type="text" id="crsCreNm" name="crsCreNm" value="${creCrsVo.crsCreNm}" autocomplete="off">
												</div>
											</dd>
										</dl>
									</li>
									<li>
										<dl>
											<dt><label for="subjectLabel_en"><spring:message code="common.label.crsauth.crsnm"/> <spring:message code="crs.common.lang.en"/></label></dt> <%-- 과목명 --> <!-- (EN) --%>
											<dd>
												<div class="ui fluid input">
													<input type="text"  id="crsCreNmEng" name="crsCreNmEng" value="${creCrsVo.crsCreNmEng}" autocomplete="off">
												</div>
											</dd>
										</dl>
									</li>
									<li>
										<dl>
											<dt><label for="partLabel" class="req"><spring:message code="common.label.decls.no"/></label></dt> <%-- 분반 --%>
											<dd>
												<div class="ui input w200">
													<input type="text" id="declsNo" name="declsNo" value="${creCrsVo.declsNo}" 
													oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
													onChange="checkDeclsNo()" maxlength="2" placeholder="<spring:message code="crs.alert.insert.declsno.only.number"/>" autocomplete="off" /><%-- 분반은 숫자로 입력하세요. --%>
												</div>
											</dd>
										</dl>
									</li>
									<c:if test="${isKnou ne true}">
									<li>
										<dl>
											<dt><label for="crsLabel" class="req"><spring:message code="crs.label.crs.cd"/><!-- 학수번호 --></label></dt>
											<dd>
												<div class="ui input w200">
													<input type="text" id="crsCd" name="crsCd" value="${creCrsVo.crsCd}" 
														placeholder="<spring:message code="crs.label.crs.cd"/>" 
														autocomplete="off" 
														onChange="checkDeclsNo()"
														<c:if test="${not empty creCrsVo.crsCreCd}">readonly</c:if> />
												</div>
											</dd>
										</dl>
									</li>
									</c:if>
									<li>
										<div class="field">
											<label for="subjectExpLabel"><spring:message code="crs.lecture.explain"/></label> <%-- 과목설명 --%>
											<dd style="height:300px">
												<div style="height:100%">
													<textarea name="crsCreDesc" id="crsCreDesc">${creCrsVo.crsCreDesc}</textarea>
													<script>
														// html 에디터 생성
														var editor = HtmlEditor('crsCreDesc', THEME_MODE, '/crs');
													</script>
												</div>
											</dd>
										</div>
									</li>
									<li id="deptForm">
										<dl>
											<dt>
												<label for="openLabel" class="req"><spring:message code="crs.common.deptnm"/></label> <%-- 개설학과 --%>
											</dt>
											<dd>
												<select class="ui fluid search selection dropdown w300" id="deptCd" name="deptCd">
													<option value=""><spring:message code="crs.confirm.search.department"/></option> <%-- 학과를 검색하세요. --%>
													<c:forEach items="${deptCdList}" var="deptItem">
														<option <c:if test="${deptItem.deptCd eq creCrsVo.deptCd}">selected</c:if> value="${deptItem.deptCd}">${deptItem.deptNm}</option>
													</c:forEach>
												</select>
											</dd>
										</dl>
									</li>
									<li>
										<dl>
											<dt><label for="lcdmsLinkYn">LCDMS 연동여부</label></dt> <%-- LCDMS 연동여부 --%>
											<dd>
												<div class="inline fields mb0">
													<div class="field">
														<div class="ui radio checkbox">
															<input type="radio" name="lcdmsLinkYn" onchange="" value="Y" <c:choose><c:when test="${creCrsVo.lcdmsLinkYn eq 'Y'}">checked</c:when><c:otherwise>checked</c:otherwise></c:choose> <c:if test="${isKnou eq false}">readonly</c:if>>
															<label><spring:message code="common.use"/></label> <%-- 사용 --%>
														</div>
													</div>
													<div class="field">
														<div class="ui radio checkbox">
															<input type="radio" name="lcdmsLinkYn" onchange="" value="N" <c:if test="${creCrsVo.lcdmsLinkYn eq 'N'}">checked</c:if> <c:if test="${isKnou eq false}">readonly</c:if>> 
															<label><spring:message code="common.not_use"/></label> <%-- 미사용 --%>
														</div>
													</div>
												</div>
											</dd>
										</dl>
									</li>
									<c:if test="${not empty creCrsVo}">
									<li>
										<dl>
											<dt><label for="erpLessonYn">ERP 주차 연동 여부<!-- ERP 주차 연동 여부 --></label></dt>
											<dd>
												<div class="inline fields mb0">
													<div class="field">
														<div class="ui radio checkbox">
															<input type="radio" name="erpLessonYn" onchange="getCrsLesson();" value="Y" <c:choose><c:when test="${creCrsVo.erpLessonYn eq 'Y'}">checked</c:when><c:otherwise>checked</c:otherwise></c:choose> <c:if test="${isKnou eq false}">readonly</c:if>>
															<label><spring:message code="common.use"/><!-- 사용 --></label>
														</div>
													</div>
													<div class="field">
														<div class="ui radio checkbox">
															<input type="radio" name="erpLessonYn" onchange="getCrsLesson();" value="N" <c:if test="${creCrsVo.erpLessonYn ne 'Y'}">checked</c:if> <c:if test="${isKnou eq false}">readonly</c:if>> 
															<label><spring:message code="common.not_use"/><!-- 미사용 --></label>
														</div>
													</div>
												</div>
											</dd>
										</dl>
									</li>
									</c:if>
									<li>
										<dl>
											<dt><label for="useLabel"><spring:message code="common.label.use.type.yn"/></label></dt> <%-- 사용 여부 --%>
											<dd>
												<div class="inline fields mb0">
													<div class="field">
														<div class="ui radio checkbox">
															<input type="radio" name="useYn" value="Y" <c:choose><c:when test="${creCrsVo.useYn eq 'Y'}">checked</c:when><c:otherwise>checked</c:otherwise></c:choose>>
															<label><spring:message code="common.use"/></label> <%-- 사용 --%>
														</div>
													</div>
													<div class="field">
														<div class="ui radio checkbox">
															<input type="radio" name="useYn" value="N" <c:if test="${creCrsVo.useYn eq 'N'}">checked</c:if>> 
															<label><spring:message code="common.not_use"/></label> <%-- 미사용 --%>
														</div>
													</div>
												</div>
											</dd>
										</dl>
									</li>
								</ul>
							</div>
						</div>
						<div class="sixteen wide tablet eight wide computer column pl0">
							<div class="ui segment">
								<div class="global_tab tab-view mt0 mb10" id="writeTab">
									<c:if test="${not empty creCrsVo}">
									<a href="#loadDiv1">주차 설정</a>
									</c:if>
									<a href="#loadDiv2"><spring:message code="crs.lecture.settings"/></a> <!-- 강의 설정 -->
	      							<c:if test="${creCrsVo.haksaDataYn ne 'Y1'}">
	      							<a href="#loadDiv3" style="display:none"><spring:message code="crs.lecture.register"/></a> <!-- 수강 신청 -->
									<a href="#loadDiv4" style="display:none"><spring:message code="common.label.lecture.period"/></a> <!-- 강의 기간 -->
									</c:if>
								</div>
								<c:if test="${not empty creCrsVo}">
								<div class="tab_content_view" id="loadDiv1">
									<%-- 
									<c:if test="${creCrsVo.erpLessonYn eq 'N'}">
									<div class="option-content mb10">
										<div class="mla">
											<a href="javascript:void(0)" class="ui button small basic" id="lessonScheduleAddBtn"><spring:message code="lesson.label.schedule.add"/></a>
										</div>
									</div>
									</c:if>
									 --%>
									<div id="lessonScheduleList"></div>
								</div>
								</c:if>
								<div class="tab_content_view" id="loadDiv2">
									<input type="radio" name="midAttendChkUseYn"  class="hidden" value="N" style="display: none;" checked />
									<ul class="tbl">
										<li id="certSection1">
									        <dl>
									            <dt class="req"><spring:message code="crs.title.evaluation.method"/></dt> <!-- 평가 방법 -->
									            <dd>
									                <div class="inline fields mb0">
									                    <div class="field">
									                        <div class="ui checkbox">
											                 	<select class="ui dropdown" id="scoreEvalType" name="scoreEvalType" onchange="changeScoreEvalType(this.value)">
											                 		<option value=""  ><spring:message code="common.select"/></option>
																	<option value="RELATIVE" <c:if test="${creCrsVo.scoreEvalType eq 'RELATIVE'}">selected</c:if>><spring:message code="score.label.relative"/><!-- 상대평가 --></option>
																	<option value="ABSOLUTE" <c:if test="${creCrsVo.scoreEvalType eq 'ABSOLUTE'}">selected</c:if>><spring:message code="score.label.absolute"/><!-- 절대평가 --> (<spring:message code="score.label.grade"/>)</option>
																	<option value="PF" <c:if test="${creCrsVo.scoreEvalType eq 'PF'}">selected</c:if>><spring:message code="score.label.absolute"/> (P/F)</option>
												                </select>
											                 </div>
									                    </div>
									                    <c:if test="${isKnou ne true}">
									                    <div class="field" id="scoreEvalTypeSection" style="<c:if test="${creCrsVo.scoreEvalType ne 'PF'}">display:none; </c:if>">
									                        <div class="ui input">
									                            <input type="text" maxlength="3" class="w100" id="passScore" name="passScore" value="${creCrsVo.passScore}" onkeyup="isChkNumber(this)" />
									                        </div>
									                        <span><spring:message code="message.score"/></span> <!-- 점 -->
									                    </div>
									                    </c:if>
									                </div>
									            </dd>
									        </dl>
									    </li>
									    <li>
									        <dl>
									            <dt class="req"><spring:message code="crs.study.form"/></dt> <!-- 강의 형식 -->
									            <dd>
									                <select class="ui dropdown" id="progressTypeCd" name="progressTypeCd">
									                   <option value="WEEK" selected ><spring:message code="crs.title.week"/> </option> <!-- 주별 --> 
									                   <%-- <option value="TOPIC" <c:if test="${creCrsVo.progressTypeCd eq 'TOPIC'}">selected</c:if>><spring:message code="common.label.topic"/></option> <!-- 토픽 --> --%> 
									                </select>
									            </dd>
									        </dl>
									    </li>
									</ul>
								</div>
								<%-- 
								<c:if test="${creCrsVo.haksaDataYn ne 'Y'}">
      							<div class="tab_content_view" id="loadDiv3" >
      								<ul class="tbl">
									    <li>
									        <dl>
									            <dt><label for="appliMethodLabel"><spring:message code="crs.request.method"/></label></dt> <!-- 신청 방법 -->
									            <dd>
									                <div class="inline fields mb0">
									                    <div class="field">
									                        <div class="ui radio checkbox">
									                            <input type="radio" name="enrlAplcMthd" class="hidden" value="ADMIN" <c:choose><c:when test="${creCrsVo.enrlAplcMthd eq 'ADMIN'}">checked</c:when><c:otherwise>checked</c:otherwise></c:choose>>
									                            <label><spring:message code="crs.manager.regist"/></label> <!-- 관리자가 등록 -->
									                        </div>
									                    </div>
									                    <div class="field">
									                        <div class="ui radio checkbox">
									                            <input type="radio" name="enrlAplcMthd" class="hidden" value="USER" <c:if test="${creCrsVo.enrlAplcMthd eq 'USER'}">checked</c:if>>
									                            <label><spring:message code="crs.request.learner"/></label> <!-- 학습자 신청 -->
									                        </div>
									                    </div>
									                </div>
									            </dd>
									        </dl>
									    </li>
									    <li>
									        <dl>
									            <dt><label for="certifiedLabel"><spring:message code="crs.certification.status"/></label></dt> <!-- 인증 상태 -->
									            <dd>
									                <div class="inline fields mb0">
									                    <div class="field">
									                        <div class="ui radio checkbox">
									                            <input type="radio" name="enrlCertStatus"  class="hidden" value="NORMAL" <c:choose><c:when test="${creCrsVo.enrlCertStatus eq 'NORMAL'}">checked</c:when><c:otherwise>checked</c:otherwise></c:choose>>
									                            <label><spring:message code="button.confirm"/></label> <!-- 승인 -->
									                        </div>
									                    </div>
									                    <div class="field">
									                        <div class="ui radio checkbox">
									                            <input type="radio" name="enrlCertStatus" class="hidden" value="REGIST" <c:if test="${creCrsVo.enrlCertStatus eq 'REGIST'}">checked</c:if>>
									                            <label><spring:message code="common.label.ready"/></label> <!-- 대기 -->
									                        </div>
									                    </div>
									                </div>
									            </dd>
									        </dl>
									    </li>
									    <li>
									        <dl>
									            <dt><label for="maxUserLabel"><spring:message code="crs.lecture.person.limit"/></label></dt> <!-- 수강인원 제한 -->
									            <dd>
									                <div class="inline fields mb0">
									                    <div class="field">
									                        <div class="ui radio checkbox">
									                            <input type="radio" name="nopLimitYn" class="hidden" value="Y" <c:if test="${creCrsVo.nopLimitYn eq 'Y'}">checked</c:if> onchange="showEnrollLimit(this.value)">
									                            <label><spring:message code="message.yes"/></label> <!-- 예 -->
									                        </div>
									                    </div>
									                    <div class="field">
									                        <div class="ui radio checkbox">
									                            <input type="radio" name="nopLimitYn" class="hidden" value="N" <c:choose><c:when test="${creCrsVo.nopLimitYn eq 'N'}">checked</c:when><c:otherwise>checked</c:otherwise></c:choose>  onchange="showEnrollLimit(this.value)">
									                            <label><spring:message code="message.no"/></label> <!-- 아니오 -->
									                        </div>
									                    </div>
									                </div>
									            </dd>
									        </dl>
									    </li>
									    <li id="enrollLimit" style="<c:if test="${creCrsVo.nopLimitYn ne 'Y'}">display:none; </c:if>">
									        <dl>
									            <dt><label for="limitUserLabel" class="req"><spring:message code="common.limited.number"/></label></dt> <!-- 제한인원 -->
									            <dd>
									                <div class="inline fields mb0">
									                    <div class="field">
									                        <div class="ui input">
									                            <input type="text" maxlength="3" id="enrlNop" name="enrlNop" class="w100" value="${creCrsVo.enrlNop}">
									                        </div>
									                        <span><spring:message code="message.person"/></span> <!-- 명 -->
									                    </div>
									                </div>
									            </dd>
									        </dl>
									    </li>
									</ul>
      							</div>
      							</c:if>
      							<c:if test="${creCrsVo.haksaDataYn ne 'Y'}">
      							<input type="hidden" id="enrlAplcStartDttm" 	name="enrlAplcStartDttm" 	value="${creCrsVo.enrlAplcStartDttm}" />
								<input type="hidden" id="enrlAplcEndDttm" 		name="enrlAplcEndDttm" 		value="${creCrsVo.enrlAplcEndDttm}" />
								<input type="hidden" id="enrlStartDttm" 		name="enrlStartDttm" 		value="${creCrsVo.enrlStartDttm}" />
								<input type="hidden" id="enrlEndDttm" 			name="enrlEndDttm" 			value="${creCrsVo.enrlEndDttm}" />
								<input type="hidden" id="scoreHandlStartDttm" 	name="scoreHandlStartDttm" 	value="${creCrsVo.scoreHandlStartDttm}" />
								<input type="hidden" id="scoreHandlEndDttm" 	name="scoreHandlEndDttm" 	value="${creCrsVo.scoreHandlEndDttm}" />
								<div class="tab_content_view" id="loadDiv4" >
									<ul class="tbl">
									    <li>
									        <dl>
									            <dt><label for="enrollLabel" class="req"><spring:message code="crs.lecture.request.period"/></label></dt> <!-- 수강 신청 기간 -->
									            <dd>
									                <div class="inline fields mb0">
									                    <div class="field">
									                        <div class="ui calendar_" id="rangestart">
									                            <div class="ui input left icon">
									                                <i class="calendar alternate outline icon"></i>
									                                <input type="text" id="enrlAplcStartDttmText" value="" placeholder="<spring:message code='common.start.date'/>" autocomplete="off"> <!-- 시작일 -->
									                            </div>
									                        </div>
									                    </div>
									                    <div class="field">
									                        <div class="ui calendar_" id="rangeend">
									                            <div class="ui input left icon">
									                                <i class="calendar alternate outline icon"></i>
									                                <input type="text" id="enrlAplcEndDttmText" value="" placeholder="<spring:message code='common.enddate'/>" autocomplete="off"> <!-- 종료일 -->
									                            </div>
									                        </div>
									                    </div>
									                </div>
									            </dd>
									        </dl>
									    </li>
									    <li>
									        <dl>
									            <dt><label for="enrollModifyLabel" class="req"><spring:message code="common.label.lecture.period"/></label></dt> <!-- 강의 기간 -->
									            <dd>
									                <div class="inline fields mb0">
									                    <div class="field">
									                        <div class="ui calendar_" id="rangestart2">
									                            <div class="ui input left icon">
									                                <i class="calendar alternate outline icon"></i>
									                                <input type="text" id="enrlStartDttmText" value="" placeholder="<spring:message code='common.start.date'/>" autocomplete="off"> <!-- 시작일 -->
									                            </div>
									                        </div>
									                    </div>
									                    <div class="field">
									                        <div class="ui calendar_" id="rangeend2">
									                            <div class="ui input left icon">
									                                <i class="calendar alternate outline icon"></i>
									                                <input type="text" id="enrlEndDttmText" value="" placeholder="<spring:message code='common.enddate'/>" autocomplete="off"> <!-- 종료일 -->
									                            </div>
									                        </div>
									                    </div>
									                </div>
									            </dd>
									        </dl>
									    </li>
									    <li>
									        <dl>
									            <dt><label for="learningLabel" class="req"><spring:message code="crs.score.process.period"/></label></dt> <!-- 성적 처리 기간 -->
									            <dd>
									                <div class="inline fields mb0">
									                    <div class="field">
									                        <div class="ui calendar_" id="rangestart3">
									                            <div class="ui input left icon">
									                                <i class="calendar alternate outline icon"></i>
									                                <input type="text" id="scoreHandlStartDttmText" value="" placeholder="<spring:message code='common.start.date'/>" autocomplete="off"> <!-- 시작일 -->
									                            </div>
									                        </div>
									                    </div>
									                    <div class="field">
									                        <div class="ui calendar_" id="rangeend3">
									                            <div class="ui input left icon">
									                                <i class="calendar alternate outline icon"></i>
									                                <input type="text" id="scoreHandlEndDttmText" value="" placeholder="<spring:message code='common.enddate'/>" autocomplete="off"> <!-- 종료일 -->
									                            </div>
									                        </div>
									                    </div>
									                </div>
									            </dd>
									        </dl>
									    </li>
									</ul>
								</div>
      							</c:if>
      							 --%>
							</div>
						</div>
					</div>
				</div>
				<!-- //ui form -->
	        </div>
	        <!-- //본문 content 부분 -->
	    </div>
	    <!-- footer 영역 부분 -->
	    <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
	</div>
</form>
<!-- 교시추가 팝업 --> 
<form id="lessonScheduleWriteForm" name="lessonScheduleWriteForm" method="post">
	<input type="hidden" name="crsCreCd" value="" />
	<input type="hidden" name="lessonScheduleId" value="" />
</form>
<div class="modal fade in" id="lessonScheduleWriteModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="lesson.label.schedule.manage" />" aria-hidden="false" style="display: none; padding-right: 17px;">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="resh.button.close" />">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title"><spring:message code="lesson.label.schedule.manage" /><!-- 주차 관리 --></h4>
            </div>
            <div class="modal-body">
                <iframe src="" width="100%" id="lessonScheduleWriteIfm" name="lessonScheduleWriteIfm" title="<spring:message code="lesson.label.schedule.manage" />"></iframe>
            </div>
        </div>
    </div>
</div>
<script>
    $('iframe').iFrameResize();
    window.closeModal = function() {
        $('.modal').modal('hide');
    };
</script>
</body>
</html>