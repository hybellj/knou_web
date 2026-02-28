<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
   	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
   	<script type="text/javascript" src="/webdoc/js/iframe.js"></script>
	<script type="text/javascript">
		var APPLI_EXAM_LIST = [];
	
		$(document).ready(function() {
			if(${uuivo.disablilityExamYn eq 'Y' }) {
				setExamTime("M");
			}
		});
		
		// 중간/기말 지원사항 폼 생성
		function setExamTime(examStareTypeCd) {
			if(examStareTypeCd == "M") {
				APPLI_EXAM_LIST = [];
			}
			
			var url  = "/exam/examCopy.do";
			var data = {
				"examStareTypeCd" : examStareTypeCd,
				"examCtgrCd"	  : "EXAM",
				"crsCreCd"		  : "${creCrsVO.crsCreCd}"
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					var map = {
						"M" : "<spring:message code='exam.label.mid.exam' />",/* 중간고사 */
						"L" : "<spring:message code='exam.label.end.exam' />"/* 기말고사 */
					};
	        		var examVO    = data.returnVO;
	        		var addTime   = examStareTypeCd == "M" ? "${examDsblReqVO.midAddTime}" : "${examDsblReqVO.endAddTime}";
	        		var lateYChk  = addTime > 0 && ${not empty examDsblReqVO} ? "checked" : "";
	        		var lateNChk  = addTime > 0 || ${empty examDsblReqVO} ? "" : "checked";
	        		var examStareTm = examVO == null ? 0 : examVO.examStareTm;
	        		var examTypeCd  = examVO == null ? "" : examVO.examTypeCd;
	        		var checked = {true : "checked", false : ""};
	        		var scoreRatio = examVO.scoreRatio || 0;
		        		
	        		if(examTypeCd == "EXAM" && scoreRatio > 0) {
	        			APPLI_EXAM_LIST.push(examStareTypeCd == "M" ? "<spring:message code='exam.label.mid' />" : "<spring:message code='exam.label.final' />"); // 중간, 기말
		        		
	        			var html  = "<h4 class='sec_head' id='"+examStareTypeCd+"Div'>"+map[examStareTypeCd]+"</h4>";
	        			html += "<ul class='sixteen wide field tbl dt-sm mb20'>";
	        			html += "	<li>";
	        			html += "		<dl>";
	        			html += "			<dt><spring:message code='exam.label.std.applicate.type' /></dt>";/* 학생신청 지원방식 */
	        			html += "			<dd><spring:message code='exam.label.time.late' /></dd>";/* 시간연장 */
	        			html += "			<dt><spring:message code='exam.label.exam.time' /></dt>";/* 시험시간 */
	        			html += "			<dd><input type='hidden' id='"+examStareTypeCd+"Time' value='"+addTime+"' />"+examStareTm+"<spring:message code='exam.label.stare.min' /></dd>";/* 분 */
	        			html += "		</dl>";
	        			html += "		<dl>";
	        			html += "			<dt><spring:message code='exam.label.exam.support.detail' /></dt>";/* 시험지원사항 */
	        			html += "			<dd>";
	        			html += "				<div class='option-content'>";
	        			html += "					<div class='ui fields'>";
	        			html += "						<div class='ui field'>";
	        			html += "							<div class='ui radio checkbox mr10'>";
	        			html += "								<input type='radio' name='"+examStareTypeCd+"TimeYn' value='Y' id='"+examStareTypeCd+"TimeY' "+lateYChk+" /> ";
	        			html += "								<label for='"+examStareTypeCd+"TimeY'><spring:message code='exam.label.time.late' /></label>";/* 시간연장 */
	        			html += "							</div>";
	        			html += "							<div class='ui radio checkbox'>";
	        			html += "								<input type='radio' name='"+examStareTypeCd+"TimeYn' value='N' id='"+examStareTypeCd+"TimeN' "+lateNChk+" /> ";
	        			html += "								<label for='"+examStareTypeCd+"TimeN'><spring:message code='exam.label.not.late.time' /></label>";/* 부여하지 않음 */
	        			html += "							</div>";
	        			html += "						</div>";
	        			html += "					</div>";
	        			html += "				</div>";
	        			html += "			</dd>";
	        			html += "		</dl>";
	        			html += "		<dl>";
	        			html += "			<dt><spring:message code='exam.label.late.time.change' /></dt>";/* 연장시간변경 */
	        			html += "			<dd>";
	        			html += "				<div class='option-content'>";
	        			html += "					<div class='ui fields'>";
	        			html += "						<div class='ui field'>";
	        			var disabilityCdNm = "${stdVO.disabilityCdNm}";
	        			var disabilityLv = "${stdVO.disabilityLv}";
	        			var stareTmMap = {
			        		"1" : {"time" : Math.round(examStareTm * 0.25), "persent" : "(25%)"},
			        		"2" : {"time" : Math.round(examStareTm * 0.5),  "persent" : "(50%)"},
			        		"3" : {"time" : Math.round(examStareTm * 0.7),  "persent" : "(70%)"},
			        		"4" : {"time" : examStareTm,					"persent" : "(100%)"}
			        	};
	        			if(${empty examDsblReqVO}) {
		        			if(disabilityCdNm == "시각장애") {
		        				if(disabilityLv == "01") {
		        					addTime = examStareTm;
		        				} else if(disabilityLv == "02") {
		        					addTime = Math.round(examStareTm * 0.7);
		        				} else if(disabilityLv == "03" || disabilityLv == "04") {
		        					addTime = Math.round(examStareTm * 0.5);
		        				} else {
		        					addTime = Math.round(examStareTm * 0.25);
		        				}
		        			} else {
		        				if(disabilityLv == "01" || disabilityLv == "02" || disabilityLv == "03" || disabilityLv == "07") {
		        					addTime = Math.round(examStareTm * 0.5);
		        				} else {
		        					addTime = Math.round(examStareTm * 0.25);
		        				}
		        			}
	        			}
			        	if(examStareTm > 0) {
				        	for(var i = 1; i <= 4; i++) {
			        	var tmValue = stareTmMap[i]["time"];
			        	var tmPersent = stareTmMap[i]["persent"];
			        	html += "							<div class='ui radio checkbox mr10'>";
			        	html += "								<input type='radio' name='"+examStareTypeCd+"AddTime' "+checked[tmValue == addTime]+" id='"+examStareTypeCd+"Time"+i+"' value='"+tmValue+"' /> ";
			        	html += "								<label for='"+examStareTypeCd+"Time"+i+"'>"+tmValue+"<spring:message code='exam.label.stare.min' />"+tmPersent+"</label>";/* 분 */
			        	html += "							</div>";
			        		}
			        	}
	        			html += "						</div>";
	        			html += "					</div>";
	        			html += "				</div>";
	        			html += "			</dd>";
	        			html += "		</dl>";
	        			html += "	</li>";
	        			html += "</ul>";
	        			$("#dsblReqDiv").append(html);
					}
	            } else {
	             	alert(data.message);
	            }
				if(examStareTypeCd == "M") setExamTime("L");
				
				$("#appliExam").text(APPLI_EXAM_LIST.join("/"));
			}, function(xhr, status, error) {
				alert("<spring:message code='exam.error.info' />");/* 정보 조회 중 에러가 발생하였습니다. */
			});
		}
		
		// 시간 변경
		function timeSet(id, time) {
			$("#"+id).text(time);
		}
		
		// 요청 승인, 반려
		function dsblReqRequest(dsblReqCd, type) {
			var confirm = "";
			if(type == "APPROVE") {
				confirm = window.confirm("<spring:message code='exam.confirm.approve' />");/* 요청 승인 하시겠습니까? */
			} else if(type == "COMPANION") {
				confirm = window.confirm("<spring:message code='exam.confirm.companion' />");/* 요청 반려 하시겠습니까? */
			}
			
			if(confirm) {
				var midAddTime = 0;
				var endAddTime = 0;
				if(type == "APPROVE") {
					if($("input[name=MTimeYn]:checked").val() == undefined && $("#MDiv").text() != "") {
						alert("<spring:message code='exam.label.mid.exam' /> <spring:message code='exam.alert.select.support' />");/* 중간고사 *//* 시험 지원사항을 선택하세요. */
						return false;
					} else {
						if($("input[name=MTimeYn]:checked").val() == "Y" && $("#MDiv").text() != "") {
							if($("input[name=MAddTime]:checked").val() == undefined) {
								alert("<spring:message code='exam.label.mid.exam' /> <spring:message code='exam.alert.select.late.time' />");/* 중간고사 *//* 연장시간을 선택하세요. */
								return false;
							} else {
								midAddTime = $("input[name=MAddTime]:checked").val();
							}
						} else {
							midAddTime = "0";
						}
					}
					if($("input[name=LTimeYn]:checked").val() == undefined && $("#LDiv").text() != "") {
						alert("<spring:message code='exam.label.end.exam' /> <spring:message code='exam.alert.select.support' />");/* 기말고사 *//* 시험 지원사항을 선택하세요. */
						return false;
					} else {
						if($("input[name=LTimeYn]:checked").val() == "Y" && $("#LDiv").text() != "") {
							if($("input[name=LAddTime]:checked").val() == undefined) {
								alert("<spring:message code='exam.label.end.exam' /> <spring:message code='exam.alert.select.late.time' />");/* 기말고사 *//* 연장시간을 선택하세요. */
								return false;
							} else {
								endAddTime = $("input[name=LAddTime]:checked").val();
							}
						} else {
							endAddTime = "0";
						}
					}
				}
				
				var url  = "/exam/insertExamDsblReq.do";
				var data = {
					"stdNo"		  : "${stdVO.stdNo}",
					"crsCreCd"	  : "${creCrsVO.crsCreCd}",
					"midApprStat" : type,
					"midAddTime"  : midAddTime,
					"endApprStat" : type,
					"endAddTime"  : endAddTime,
					"dsblReqCd"   : "${examDsblReqVO.dsblReqCd}"
				};
				
				ajaxCall(url, data, function(data) {
					if (data.result > 0) {
						if(type == "APPROVE") {
							alert("<spring:message code='exam.alert.approve' />");/* 승인이 완료되었습니다. */
						} else if(type == "COMPANION") {
							alert("<spring:message code='exam.alert.companion' />");/* 반려가 완료되었습니다. */
						}
						window.parent.listExamDsblReq();
						window.parent.closeModal();
		            } else {
		             	alert(data.message);
		            }
				}, function(xhr, status, error) {
					alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
				});
			}
		}
		
		// 신청이력 팝업
		function applicateHstyPop() {
			$("#dsblHstyForm").attr("target", "dsblHstyIfm");
	        $("#dsblHstyForm").attr("action", "/exam/examDsblReqHstyPop.do");
	        $("#dsblHstyForm").submit();
	        $('#dsblHstyPop').modal('show');
		}
	</script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<form id="dsblHstyForm" name="dsblHstyForm" action="" method="POST">
		<input type="hidden" name="crsCreCd"   value="DSBLREQ" />
		<input type="hidden" name="actnHstyCd" value="EXAM" />
		<input type="hidden" name="userId"     value="${stdVO.userId }" />
	</form>
    <div id="wrap">
       	<div class="option-content p10 mt10">
       		<h3 class="sec_head"><spring:message code="exam.label.support.list.detail" /><!-- 요청 내역 상세 --></h3>
       		<c:if test="${uuivo.disablilityExamYn eq 'Y' }">
        		<div class="mla">
        			<a href="javascript:dsblReqRequest('${examDsblReqVO.dsblReqCd }', 'APPROVE')" class="ui blue button"><spring:message code="exam.label.approve" /><!-- 승인 --></a>
        			<%-- <a href="javascript:dsblReqRequest('${examDsblReqVO.dsblReqCd }', 'COMPANION')" class="ui blue button"><spring:message code="exam.label.companion" /><!-- 반려 --></a> --%>
        		</div>
       		</c:if>
       	</div>
       	<ul class="sixteen wide field tbl dt-sm mt20">
       		<li>
       			<dl>
       				<dt><spring:message code="exam.label.department" /><!-- 소속 --><spring:message code="exam.label.dept" /><!-- 학과 --></dt>
       				<dd>${stdVO.deptNm }</dd>
       			</dl>
       			<dl>
       				<dt><spring:message code="exam.label.user.no" /><!-- 학번 --></dt>
       				<dd>${stdVO.userId }</dd>
       				<dt><spring:message code="exam.label.user.nm" /><!-- 이름 --></dt>
       				<dd>${stdVO.userNm }</dd>
       			</dl>
       			<dl>
       				<dt><spring:message code="exam.label.dsbl.req.type" /><!-- 장애종류 --></dt>
       				<dd>${stdVO.disabilityCdNm }</dd>
       				<dt><spring:message code="exam.label.dsbl.req.grade" /><!-- 장애 등급 --></dt>
       				<dd>${stdVO.disabilityLvNm }</dd>
       			</dl>
       			<dl>
       				<dt><spring:message code="user.title.select.disability.tangible" /><!-- 부장애유형 --></dt>
       				<dd>${stdVO.subDisabilityCdNm }</dd>
       				<dt><spring:message code="user.title.select.disability.class" /><!-- 부장애등급 --></dt>
       				<dd>${stdVO.subDisabilityLvNm }</dd>
       			</dl>
       			<dl>
       				<dt><spring:message code="crs.label.crs.cd" /><!-- 학수번호 --></dt>
       				<dd>${creCrsVO.crsCd }</dd>
       				<dt><spring:message code="crs.label.decls" /><!-- 분반 --></dt>
       				<dd>${creCrsVO.declsNo }</dd>
       			</dl>
       			<dl>
       				<dt><spring:message code="exam.label.subject.nm" /><!-- 교과명 --></dt>
       				<dd>${creCrsVO.crsCreNm }</dd>
       				<dt><button type="button" class="ui small basic button wmax" onclick="applicateHstyPop()"><spring:message code="exam.label.applicate.hsty" /><!-- 신청이력 --></button></dt>
       				<dd>
       					<c:if test="${not empty examDsblReqVO }">
        					<c:choose>
        						<c:when test="${uuivo.disablilityExamYn eq 'Y' }">
		        					<spring:message code="common.label.request" /><!-- 신청 -->
        						</c:when>
        						<c:otherwise>
        							<spring:message code="common.button.cancel" /><!-- 취소 -->
        						</c:otherwise>
        					</c:choose>
       					</c:if>
       					<fmt:parseDate var="dsblFmt" pattern="yyyyMMddHHmmss" value="${stdVO.dsblDttm }" />
						<fmt:formatDate var="dsblDttm" pattern="yyyy.MM.dd HH:mm" value="${dsblFmt }" />
       					${dsblDttm }
       				</dd>
       			</dl>
       			<dl>
       				<dt><spring:message code="exam.label.applicate" /><!-- 신청 --><spring:message code="exam.label.term" /><!-- 학기 --></dt>
       				<dd id="appliExam"><%-- <spring:message code="exam.label.mid.end.exam" /><!-- 중간/기말 --> --%></dd>
       			</dl>
       		</li>
       	</ul>
      	<div id="dsblReqDiv" class="mt30">
      	</div>
        	
	    <div class="bottom-content mt50 tc">
	        <button class="ui basic button" onclick="window.parent.closeModal();"><spring:message code="exam.button.close" /><!-- 닫기 --></button>
	    </div>
	</div>
	<div class="modal fade" id="dsblHstyPop" tabindex="-1" role="dialog" aria-labelledby="팝업" aria-hidden="false">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="exam.button.close" />"><!-- 닫기 -->
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title"><spring:message code="exam.label.applicate.hsty" /></h4>
                </div>
                <div class="modal-body">
                    <iframe src="" id="dsblHstyIfm" name="dsblHstyIfm" width="100%" height="100%" scrolling="no"></iframe>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
	    window.closeModal = function() {
		    $('.modal').modal('hide');
		};
		
		$('iframe').iFrameResize();
    </script>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>