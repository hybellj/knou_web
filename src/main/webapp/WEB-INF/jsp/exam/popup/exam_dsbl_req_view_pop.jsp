<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
   	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
   	<%@ include file="/WEB-INF/jsp/common/editor_inc.jsp" %>
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
	
	<script type="text/javascript">
		$(document).ready(function() {
			if(${uuivo.disablilityExamYn eq 'Y' }) {
				setExamTime("M");
			}
		});
		
		// 중간/기말 지원사항 폼 생성
		function setExamTime(examStareTypeCd) {
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
	        		var examVO = data.returnVO;
	        		var examStareTm = examVO == null || examVO.examStareTm == null || examVO.examTypeCd != "EXAM" ? 0 : examVO.examStareTm;
	        		var addTime = examStareTypeCd == "M" ? "${vo.midAddTime}" : "${vo.endAddTime}";
	        		addTime = addTime == "" ? 0 : addTime;
	        		var checked = {true : "checked", false : ""};
	        		var examTypeCd = examVO == null ? "" : examVO.examTypeCd;
	        		var scoreRatio = examVO.scoreRatio || 0;
	        		
	        		if(examTypeCd == "EXAM" && scoreRatio > 0) {
	        		var html  = "<h4 class='sec_head' id='"+examStareTypeCd+"Div'>"+map[examStareTypeCd]+"</h4>";
	        			html += "<ul class='sixteen wide field tbl dt-sm mb20'>";
	        			html += "	<li>";
	        			html += "		<dl>";
	        			html += "			<dt><spring:message code='exam.label.std.applicate.type' /></dt>";/* 학생신청 지원방식 */
	        			html += "			<dd><spring:message code='exam.label.time.late' /></dd>";/* 시간연장 */
	        			html += "			<dt><spring:message code='exam.label.exam.time' /></dt>";/* 시험시간 */
	        			html += "			<dd>"+examStareTm+"<spring:message code='exam.label.stare.min' /></dd>";/* 분 */
	        			html += "		</dl>";
	        			html += "		<dl>";
	        			html += "			<dt><spring:message code='exam.label.exam.support.detail' /></dt>";/* 시험지원사항 */
	        			html += "			<dd>";
	        			html += "				<div class='option-content'>";
	        			html += "					<div class='ui fields'>";
	        			html += "						<div class='ui field'>";
	        			html += "							<div class='ui radio checkbox mr10'>";
	        			html += "								<input type='radio' name='"+examStareTypeCd+"TimeYn' value='Y' id='"+examStareTypeCd+"TimeY' "+checked[addTime > 0]+" /> ";
	        			html += "								<label for='"+examStareTypeCd+"TimeY'><spring:message code='exam.label.time.late' /></label>";/* 시간연장 */
	        			html += "							</div>";
	        			html += "							<div class='ui radio checkbox'>";
	        			html += "								<input type='radio' name='"+examStareTypeCd+"TimeYn' value='N' id='"+examStareTypeCd+"TimeN' "+checked[addTime == 0]+" /> ";
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
	        			var examStareTm = examVO == null || examVO.examTypeCd != "EXAM" ? 0 : examVO.examStareTm;
	        			html += "				<input type='hidden' id='"+examStareTypeCd+"StareTm' value='"+examStareTm+"' />";
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
	        			if(${empty vo}) {
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
			}, function(xhr, status, error) {
				alert("<spring:message code='exam.error.info' />");/* 정보 조회 중 에러가 발생하였습니다. */
			});
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
				midAddTime = midAddTime == undefined ? 0 : midAddTime;
				endAddTime = endAddTime == undefined ? 0 : endAddTime;
				
				var url  = "/exam/insertExamDsblReq.do";
				var data = {
					"stdNo"		  : "${stdVO.stdNo}",
					"crsCreCd"	  : "${creCrsVO.crsCreCd}",
					"dsblReqCd"	  : "${vo.dsblReqCd}",
					"midApprStat" : type,
					"midAddTime"  : midAddTime,
					"endApprStat" : type,
					"endAddTime"  : endAddTime
				};
				
				ajaxCall(url, data, function(data) {
					if (data.result > 0) {
						if(type == "APPROVE") {
							alert("<spring:message code='exam.alert.approve' />");/* 승인이 완료되었습니다. */
						} else if(type == "COMPANION") {
							alert("<spring:message code='exam.alert.companion' />");/* 반려가 완료되었습니다. */
						}
						window.parent.listExamDsblReq(1);
						window.parent.closeModal();
		            } else {
		             	alert(data.message);
		            }
				}, function(xhr, status, error) {
					alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
				});
			}
		}
		
		// 취소요청 승인
		function dsblReqCancel() {
			var confirm = window.confirm("<spring:message code='exam.confirm.approve' />");/* 요청 승인 하시겠습니까? */
			if(confirm) {
				var url  = "/exam/stuExamDsblReqCancel.do";
				var data = {
					"userId" : "${uuivo.userId}",
					"disabilityCancelGbn" : "APPROVE"
				};
				
				ajaxCall(url, data, function(data) {
					if(data.result > 0) {
						alert("<spring:message code='exam.alert.approve' />");/* 승인이 완료되었습니다. */
						window.parent.listExamDsblReq(1);
						window.parent.closeModal();
		        	} else {
		        		alert(data.message);
		        	}
				}, function(xhr, status, error) {
					alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
				});
			}
		}
	</script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
        
	<div id="wrap">
       	<div class="option-content">
       		<h3 class="sec_head"><spring:message code="exam.label.support.list.detail" /></h3><!-- 요청 내역 상세 -->
       		<div class="mla">
      				<c:if test="${uuivo.disablilityExamYn eq 'Y' }">
        			<a href="javascript:dsblReqRequest('${vo.dsblReqCd }', 'APPROVE')" class="ui blue button"><spring:message code="exam.label.approve" /></a><!-- 승인 -->
        			<%-- <a href="javascript:dsblReqRequest('${vo.dsblReqCd }', 'COMPANION')" class="ui blue button"><spring:message code="exam.label.companion" /></a><!-- 반려 --> --%>
      				</c:if>
      				<c:if test="${uuivo.disabilityCancelGbn eq 'APPLICATE' }">
      					<a href="javascript:dsblReqCancel()" class="ui blue button"><spring:message code="exam.button.dsbl.cancel" /><!-- 취소요청 승인 --></a>
      				</c:if>
       		</div>
       	</div>
       	<ul class="sixteen wide field tbl dt-sm mt20">
       		<li>
       			<dl>
       				<dt><spring:message code="exam.label.user.dept" /><!-- 소속학과 --></dt>
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
       				<dt><spring:message code="exam.label.applicate.dttm" /><!-- 신청일시 --></dt>
       				<%-- <fmt:parseDate var="disabilityFmt" pattern="yyyyMMddHHmmss" value="${uuivo.disabilityDttm }" />
					<fmt:formatDate var="disabilityDttm" pattern="yyyy.MM.dd HH:mm" value="${disabilityFmt }" /> --%>
       				<dd>
       					<c:if test="${not empty vo }">
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
       		</li>
       	</ul>
       	<div id="dsblReqDiv" class="mt30">
       		<div class="ui small message">
	            <i class="info circle icon"></i>
	            <!-- 장애등급에 맞춰 연장시간이 기본으로 설정되어 있습니다. 교과목/학생의 특성에 따라 조정이 필요한 경우 조정하여 저장하세요. -->
	            <spring:message code="user.message.userinfo.select.disability.obstacle" />
	        </div>
       	</div>
	    <div class="bottom-content mt50">
	        <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
	    </div>
    </div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>