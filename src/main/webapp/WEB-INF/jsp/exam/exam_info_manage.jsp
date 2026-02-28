<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>

<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />

<script type="text/javascript">
	$(document).ready(function() {
		if(${not empty vo.insRefCd} && "${vo.insDelYn}" == "N") {
			insInfoView();
			insUserList();
		}
	});
	
	// 기타, 대체 과제 정보 폼
	function insInfoView() {
		var url  = "/exam/selectExamInsInfo.do";
		var data = {
			"insRefCd" : "${vo.insRefCd}",
			"crsCreCd" : "${vo.crsCreCd}"
		};
		
		ajaxCall(url, data, function(data) {
			console.log(data);
			if (data.result > 0) {
				var returnVO = data.returnVO;
				var html = "";
				if(returnVO != null) {
					var dtTitle = "";
					var ddValue = "";
					//html += "<li>";
					//html += "	<dl>";
					//html += "		<dt>["+returnVO.typeNm+"] "+returnVO.title+"<a href='javascript:insEditForm(\""+returnVO.code+"\", \""+returnVO.typeCd+"\")' class='ui blue small button fr'><spring:message code='exam.button.mod' /></a></dt>";/* 수정 */
					//html += "	</dl>";
					//html += "</li>";
					html += "<li>";
					html += "	<dl>";
					html += "		<dt><spring:message code='exam.label.cts' /></dt>";/* 내용 */
					html += "		<dd><pre>"+returnVO.cts+"</pre></dd>";
					html += "	</dl>";
					html += "</li>";
					html += "<li>";
					html += "	<dl>";
					html += "		<dt><spring:message code='exam.label.period' /></dt>";/* 기간 */
					html += "		<dd>"+dateFormat("date", returnVO.startDttm)+" ~ "+dateFormat("date", returnVO.endDttm)+"</dd>";
					dtTitle = returnVO.typeCd == "EXAM" ? "<spring:message code='exam.label.qstn.random' />"/* 문제 섞기 */ : "<spring:message code='exam.label.ext.submit' />"/* 지각제출 */;
					ddValue = returnVO.typeCd == "EXAM" ? returnVO.qstnSetTypeNm : returnVO.extNm;
					if(returnVO.typeCd != "EXAM" && ddValue == "예" && returnVO.extDttm != null) ddValue += " | " + dateFormat("date", returnVO.extDttm);
					html += "		<dt>"+dtTitle+"</dt>";
					html += "		<dd>"+ddValue+"</dd>";
					html += "	</dl>";
					html += "</li>";
					html += "<li>";
					html += "	<dl>";
					dtTitle = returnVO.typeCd == "EXAM" ? "<spring:message code='exam.label.quiz' /><spring:message code='exam.label.time' />"/* 퀴즈 *//* 시간 */ : "<spring:message code='exam.label.eval.ctgr' />"/* 평가방법 */;
					ddValue = returnVO.typeCd == "EXAM" ? returnVO.examStareTm + "<spring:message code='exam.label.min.time' />"/* 분 */ : returnVO.evalCtgrNm;
					html += "		<dt>"+dtTitle+"</dt>";
					html += "		<dd>"+ddValue+"</dd>";
					dtTitle = returnVO.typeCd == "EXAM" ? "<spring:message code='exam.label.empl.random' />"/* 보기 섞기 */ : returnVO.typeCd == "ASMNT" ? "<spring:message code='asmnt.label.practice.asmnt' />"/* 실기과제 */ : "<spring:message code='exam.label.target.absent' />"/* 대상/결시원 */;
					ddValue = returnVO.typeCd == "EXAM" ? returnVO.emplRandomNm : returnVO.typeCd == "ASMNT" ? returnVO.prtcNm : "${vo.examTypeCd}" == "EXAM" ? returnVO.subsCnt : returnVO.totalCnt;
					ddValue = returnVO.typeCd == "FORUM" ? ddValue += "<spring:message code='exam.label.nm' />"/* 명 */ : ddValue;
					html += "		<dt>"+dtTitle+"</dt>";
					html += "		<dd>";
					html += "			"+ddValue;
					if(returnVO.typeCd == "FORUM" && "${vo.examTypeCd}" == "EXAM") {
					html += "			<a href='javascript:viewAbsent()' class='ui basic small button fr'><spring:message code='exam.label.absent' /></a>"/* 결시원 */;
					}
					html += "		</dd>";
					html += "	</dl>";
					html += "</li>";
					if(returnVO.typeCd == "ASMNT") {
					html += "<li>";
					html += "	<dl>";
					html += "		<dt><spring:message code='asmnt.label.asmnt.send.type' /></dt>";/* 제출형식 */
					html += "		<dd>"+returnVO.sendTypeNm+"</dd>";
					html += "		<dt><spring:message code='exam.label.target.absent' /></dt>";/* 대상/결시원 */
					html += "		<dd>";
					if("${vo.examTypeCd}" == "EXAM") {
					html += "			"+returnVO.subsCnt+"<spring:message code='exam.label.nm' /> <a href='javascript:viewAbsent()' class='ui basic small button fr'><spring:message code='exam.label.absent' /></a>";/* 명 *//* 결시원 */
					} else {
					html += "			"+returnVO.totalCnt+"<spring:message code='exam.label.nm' />";/* 명 */
					}
					html += "		</dd>";
					html += "	</dl>";
					html += "</li>";
					}
					html += "<li>";
					html += "	<dl>";
					html += "		<dt><spring:message code='exam.label.file' /></dt>";/* 첨부파일 */
					html += "		<dd>";
					returnVO.fileList.forEach(function(v, i) {
					html += "			<button class='ui icon small button' id='file_"+v.fileSn+"' title='파일다운로드' onclick='fileDown(\""+v.fileSn+"\", \""+v.repoCd+"\")'><i class='ion-android-download'></i> </button>";
					});
					html += "		</dd>";
					dtTitle = returnVO.typeCd == "EXAM" ? "<spring:message code='exam.label.target.absent' />"/* 대상/결시원 */ : "";
					ddValue = returnVO.typeCd == "EXAM" ? "${vo.examTypeCd}" == "EXAM" ? returnVO.subsCnt : returnVO.totalCnt : "";
					ddValue = returnVO.typeCd == "EXAM" ? ddValue += "<spring:message code='exam.label.nm' />"/* 명 */ : ddValue;
					html += "		<dt>"+dtTitle+"</dt>";
					html += "		<dd>";
					html += "			"+ddValue;
					if(returnVO.typeCd == "EXAM" && "${vo.examTypeCd}" == "EXAM") {
					html += "			<a href='javascript:viewAbsent()' class='ui basic small button fr'><spring:message code='exam.label.absent' /></a>";/* 결시원 */
					}
					html += "		</dd>";
					html += "	</dl>";
					html += "</li>";
					html += "<li>";
					html += "	<dl>";
					ddValue = "${vo.examTypeCd}" == "EXAM" ? returnVO.subsCnt : returnVO.totalCnt;
					html += "		<dt><spring:message code='exam.label.submission.status' /></dt>";/* 제출현황 */
					html += "		<dd>"+returnVO.joinCnt+"/"+ddValue+"</dd>";
					html += "		<dt><spring:message code='exam.label.eval.status' /></dt>";/* 평가현황 */
					html += "		<dd>"+returnVO.evalCnt+"/"+returnVO.joinCnt+" <a href='javascript:viewInsScoreForm(\""+returnVO.typeCd+"\")' class='ui basic small button fr'><spring:message code='exam.button.eval' /></a></dd>";/* 평가하기 */
					html += "	</dl>";
					html += "</li>";
				}
				$("#examInfoUl").append(html);
				returnVO.fileList.forEach(function(v, i) {
					byteConvertor(v.fileSize, v.fileNm, v.fileSn);
				});
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.info' />");/* 정보 조회 중 에러가 발생하였습니다. */
		});
	}
	
	// 기타, 대체 과제 미참여자 목록
	function insUserList() {
		var url  = "/exam/listExamInsUser.do";
		var data = {
			"examCd" 	 : "${vo.examCd}",
			"insRefCd"   : "${vo.insRefCd}",
			"crsCreCd"   : "${vo.crsCreCd}",
			"searchType" : "${vo.insRefCd}".split("_")[0],
			"examTypeCd" : "${vo.examTypeCd}"
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				var returnList = data.returnList || [];
				var html = "";
				
				if(returnList.length > 0) {
					var typeCd = returnList[0].typeCd;
					var quizNoperson = '<spring:message code="std.label.quiz" /><spring:message code="exam.label.re.exam.user" />';	// 퀴즈 미응시자
					var asmntNosubmit = '<spring:message code="std.label.asmnt" /><spring:message code="common.label.nosubmit_filter" />'; // 과제 미제출자
					var forumNoabsentee = '<spring:message code="std.label.forum" /><spring:message code="common.label.noabsentee_filter" />'; // 토론 미참시자

					// var typeNm = typeCd == "EXAM" ? "퀴즈 미응시자" : typeCd == "ASMNT" ? "과제 미제출자" : "토론 미참시자";
					var typeNm = typeCd == "EXAM" ? quizNoperson : typeCd == "ASMNT" ? asmntNosubmit : forumNoabsentee;
					
					html += "<div class='option-content mt20'>";
					html += "	<h3 class='sec_head'>"+typeNm+"</h3>";
					html += "	<div class='mla'>";
					html += '       <uiex:msgSendBtn func="sendMsg()" styleClass="ui basic small button"/>';
					html += "	</div>";
					html += "	<table class='table type2' id='userListTable' data-sorting='false' data-paging='false' data-empty='"+"<spring:message code='exam.common.empty' />"+"'>";/* 등록된 내용이 없습니다. */
					html += "		<thead>";
					html += "			<tr>";
					html += "				<th scope='col' class='tc num'>";
					html += "					<div class='ui checkbox'>";
					html += "						<input type='checkbox' name='allEvalChk' id='allChk' value='all' onchange='checkToggle(this)'>";
					html += "						<label class='toggle_btn' for='allChk'></label>";
					html += "					</div>";
					html += "				</th>";
					html += "				<th scope='col' class='tc num'><spring:message code='main.common.number.no' /></th>";/* NO */
					html += "				<th scope='col' class='tc' data-breakpoints='xs'><spring:message code='exam.label.dept' /></th>";/* 학과 */
					html += "				<th scope='col' class='tc'><spring:message code='exam.label.user.no' /></th>";/* 학번 */
					html += "				<th scope='col' class='tc' data-breakpoints='xs'><spring:message code='exam.label.user.grade' /></th>";/* 학년 */
					html += "				<th scope='col' class='tc'><spring:message code='exam.label.user.nm' /></th>";/* 이름 */
					html += "				<th scope='col' class='tc' data-breakpoints='xs'><spring:message code='exam.label.admission.year' /></th>";/* 입학년도 */
					html += "				<th scope='col' class='tc' data-breakpoints='xs'><spring:message code='exam.label.admission.grade' /></th>";/* 입학학년 */
					html += "				<th scope='col' class='tc' data-breakpoints='xs'><spring:message code='exam.label.admission.type' /></th>";/* 입학구분 */
					html += "			</tr>";
					html += "		</thead>";
					html += "		<tbody id='examUserList'>";
					returnList.forEach(function(v, i) {
					html += "			<tr>";
					html += "				<td class='tc'>";
					html += "					<div class='ui checkbox'>";
					html += "						<input type='checkbox' name='evalChk' id='evalChk"+i+"' data-stdNo=\""+v.stdNo+"\" onchange='checkToggle(this)' user_id=\""+v.userId+"\" user_nm=\""+v.userNm+"\" mobile=\""+v.mobileNo+"\" email=\""+v.email+"\">";
					html += "						<label class='toggle_btn' for='evalChk"+i+"'></label>";
					html += "					</div>";
					html += "				</td>";
					html += "				<td class='tc'>"+v.lineNo+"</td>";
					html += "				<td>"+v.deptNm+"</td>";
					html += "				<td>"+v.userId+"</td>";
					html += "				<td class='tc'>"+v.hy+"</td>";
					html += "				<td>"+v.userNm;
					html += 					userInfoIcon("<%=SessionInfo.isKnou(request)%>", "userInfoPop('"+v.userId+"')");
					html += "				</td>";
					html += "				<td class='tc'>"+v.entrYy+"</td>";
					html += "				<td class='tc'>"+v.entrHy+"</td>";
					html += "				<td class='tc'>"+v.entrGbnNm+"</td>";
					html += "			</tr>";
					});
					html += "		</tbody>";
					html += "	</table>";
					html += "</div>";
				}
				$("#examInfoDiv").append(html);
				$("#userListTable").footable();
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
		});
	}
	
	// 과제, 토론, 퀴즈 평가하기 화면 이동
	function viewInsScoreForm(insTypeCd) {
		var typeMap = {
			"EXAM"  : {"url" : "/quiz/quizScoreManage.do",	"code" : "examCd"},
			"ASMNT" : {"url" : "/asmtprofAsmtEvlView.do", "code" : "asmntCd"},
			"FORUM" : {"url" : "/forum/forumLect/Form/scoreManage.do", "code" : "forumCd"}
		};
		
		var kvArr = [];
		kvArr.push({'key' : typeMap[insTypeCd]["code"], 'val' : "${vo.insRefCd}"});
		kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});
		
		submitForm(typeMap[insTypeCd]["url"], "", "", kvArr);
	}
	
	// 결시원 화면 이동
	function viewAbsent() {
		var kvArr = [];
		kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});
		kvArr.push({'key' : 'examType', 'val' : "ABSENT"});
		
		submitForm("/exam/Form/examList.do", "", "", kvArr);
	}
	
	// 기타, 대체 과제 수정 폼
	function insEditForm(insRefCd, insTypeCd) {
		var insMap = {
			"EXAM"  : {"url" : "/quiz/Form/editQuiz.do", "code" : "examCd"},
			"ASMNT" : {"url" : "/asmtprofAsmtRegistView.do", "code" : "asmntCd"},
			"FORUM" : {"url" : "/forum/forumLect/Form/editForumForm.do", "code" : "forumCd"}
		};
		
		var kvArr = [];
		kvArr.push({'key' : insMap[insTypeCd]["code"], 'val' : "${vo.insRefCd}"});
		kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});
		
		submitForm(insMap[insTypeCd]["url"], "", "", kvArr);
	}
	
	function manageExam(tab) {
		var urlMap = {
			"0" : "/exam/Form/examEdit.do",	// 시험 수정 페이지
			"1" : "/exam/Form/examList.do"	// 목록
		};
		
		var kvArr = [];
		kvArr.push({'key' : 'examCd', 'val' : "${vo.examCd}"});
		kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});
		kvArr.push({'key' : 'examType', 'val' : "${examType}"});
		
		submitForm(urlMap[tab], "", "", kvArr);
	}
	
	// 시험 삭제
	function delExam() {
		var confirm = "";
		if(${vo.examJoinUserCnt > 0}) {
			/* 응시한 학습자가 있습니다. 삭제 시 학습정보가 삭제됩니다. 정말 삭제하시겠습니까? */
			confirm = window.confirm("<spring:message code='exam.confirm.exist.answer.user.y' />");
		} else {
			/* 응시한 학습자가 없습니다. 삭제 하시겠습니까? */
			confirm = window.confirm("<spring:message code='exam.confirm.exist.answer.user.n' />");
		}
		if(confirm) {
			var url  = "/exam/delExam.do";
			var data = {
				"examCd" : "${vo.examCd}"
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					/* 정상 삭제 되었습니다. */
	        		alert("<spring:message code='exam.alert.delete' />");
	        		manageExam(1);
	            } else {
	             	alert(data.message);
	            }
    		}, function(xhr, status, error) {
    			/* 삭제 중 에러가 발생하였습니다. */
    			alert("<spring:message code='exam.error.delete' />");
    		});
		}
	}
	
	// 서약서 제출 목록
	function viewPledgeList() {
		examCommon.initModal("examOathList");
		var kvArr = [];
		kvArr.push({'key' : 'examCd', 'val' : "${vo.examCd}"});
		kvArr.push({'key' : 'oathCd', 'val' : ""});
		kvArr.push({'key' : 'stdNo', 'val' : ""});
		kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});
		kvArr.push({'key' : 'searchKey', 'val' : "VIEW"});

		submitForm("/exam/examOathPop.do", "examPopIfm", "examOathList", kvArr);
        $('#examPop').modal('show');
	}
	
	// 실시간 시험 맛보기
  	function etsExamTaste() {
		var url  = "/exam/examStareEncrypto.do";
		var data = {
			"examCd" : "${vo.examCd}"
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnVO = data.returnVO;
				window.open(returnVO.goUrl);
        	} else {
        		alert(data.message);
        	}
		}, function(xhr, status, error) {
			/* 에러가 발생했습니다! */
			alert("<spring:message code='fail.common.msg' />");
		});
  	}
	
 	// 응시현황
	function examStareJoinList() {
		var kvArr = [];
		kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});
		kvArr.push({'key' : 'examCd',   'val' : "${vo.examCd}"});
		kvArr.push({'key' : 'examType', 'val' : "${examType}"});
		
		submitForm("/exam/Form/examStareJoinList.do", "", "", kvArr);
	}
 	
 	// 학습자 선택
 	function checkToggle(obj) {
 		if(obj.value == "all") {
 			$("input[name=evalChk]").prop("checked", $(obj).is(":checked"));
 			if(obj.checked) {
 				$("input[name=evalChk]").closest("tr").addClass("on");
 			} else {
 				$("input[name=evalChk]").closest("tr").removeClass("on");
 			}
 		} else {
 			var totalCnt = $("input[name=evalChk]").length;
 			var checkCnt = $("input[name=evalChk]:checked").length;
 			$("#allChk").prop("checked", totalCnt == checkCnt);
 			if(obj.checked) {
 				$(obj).closest("tr").addClass("on");
 			} else {
 				$(obj).closest("tr").removeClass("on");
 			}
 		}
 	}
 	
 	// 메세지 보내기
	function sendMsg() {
		var rcvUserInfoStr = "";
		var sendCnt = 0;
		
		$.each($('#examUserList').find("input:checkbox[name=evalChk]:not(:disabled):checked"), function() {
			sendCnt++;
			if (sendCnt > 1) rcvUserInfoStr += "|";
			rcvUserInfoStr += $(this).attr("user_id");
			rcvUserInfoStr += ";" + $(this).attr("user_nm"); 
			rcvUserInfoStr += ";" + $(this).attr("mobile");
			rcvUserInfoStr += ";" + $(this).attr("email"); 
		});
		
		if (sendCnt == 0) {
			/* 메시지 발송 대상자를 선택하세요. */
			alert("<spring:message code='common.alert.sysmsg.select_user'/>");
			return;
		}
		
        window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");

        var form = document.alarmForm;
        form.action = "<%=CommConst.SYSMSG_URL_SEND%>";
        form.target = "msgWindow";
        form[name='alarmType'].value = "S"; // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
        form[name='rcvUserInfoStr'].value = rcvUserInfoStr; //보내는사람 정보
        form.submit();
	}
 	
	//사용자 정보 팝업
 	function userInfoPop(userId) {
 		var userInfoUrl = "${userInfoPopUrl}" + btoa(`{"stuno":"\${userId}"}`);
 		var options = 'top=100, left=150, width=1200, height=800';
 		window.open(userInfoUrl, "", options);
 	}
</script>

<body class="<%=SessionInfo.getThemeMode(request)%>">
    <div id="wrap" class="pusher">
        <!-- class_top 인클루드  -->
        <%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>

        <div id="container">
            <%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>
            
            <!-- 본문 content 부분 -->
            <div class="content">
            	<%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>
            	
        		<div class="ui form">
        			<div class="layout2">
        				<c:set var="examTypeStr"><spring:message code="exam.label.mid.end.exam" /><!-- 중간/기말 --></c:set>
        				<c:if test="${examType eq 'ADMISSION' }"><c:set var="examTypeStr"><spring:message code="exam.label.always.exam" /><!-- 수시평가 --></c:set></c:if>
						<script>
							$(document).ready(function () {
								// set location  정보 및 관리
								setLocationBar('${examTypeStr}', '<spring:message code="exam.label.info.manage" />');
							});
						</script>
        			
		            	<div id="info-item-box">
		            		<h2 class="page-title flex-item flex-wrap gap4 columngap16">${examTypeStr }</h2>
                            <div class="button-area">
                            	<a href="javascript:manageExam(0)" class="ui blue button"><spring:message code="exam.button.mod" /></a><!-- 수정 -->
								<a href="javascript:manageExam(1)" class="ui blue button"><spring:message code="exam.button.list" /></a><!-- 목록 -->
								<a href="javascript:delExam()" class="ui blue button"><spring:message code="exam.button.del" /></a><!-- 삭제 -->
                            </div>
		                </div>
		                <div class="row">
		                	<div class="col">
		                		<div class="ui segment" id="examInfoDiv">
			                		<div class="option-content header2">
			                			<fmt:parseDate var="startDateFmt" pattern="yyyyMMddHHmmss" value="${vo.examStartDttm }" />
										<fmt:formatDate var="examStartDttm" pattern="yyyy.MM.dd HH:mm (E요일)" value="${startDateFmt }" />
			                			<h3 class="sec_head wmax">[${vo.examTypeNm }] ${vo.examTitle }</h3>
			                			<small><spring:message code="exam.label.exam.dttm" /><!-- 시험일시 --> : ${vo.examTypeCd eq 'EXAM' ? examStartDttm : '-' }</small> |
			                			<small><spring:message code="exam.label.exam.time" /><!-- 시험시간 --> : ${vo.examTypeCd eq 'EXAM' ? vo.examStareTm+='Min' : '-' }</small> |
			                			<small><spring:message code="exam.label.score.open.y" /><!-- 성적공개 --> : ${vo.examTypeCd eq 'EXAM' ? vo.scoreOpenYn eq 'Y' ? yes : no : '-' }</small> |
			                			<small><spring:message code="exam.label.paper.open" /><!-- 시험지 공개 --> : ${vo.examTypeCd eq 'EXAM' ? vo.gradeViewYn eq 'Y' ? yes : no : '-' }</small>
			                			<c:if test="${(vo.examStareTypeCd eq 'M' || vo.examStareTypeCd eq 'L') && vo.examTypeCd eq 'EXAM' }">
				                			<div class="mla">
				                				<%-- 
				                				<a href="javascript:viewPledgeList()" class="ui basic small button"><spring:message code="exam.label.oath" /><!-- 서약서 --></a> 
				                				--%>
				                				<a href="javascript:etsExamTaste()" class="ui basic small button"><spring:message code="exam.label.exam.taste" /><!-- 시험 맛보기 --></a>
				                			</div>
			                			</c:if>
			                		</div>
			                		<ul class="tbl" id="examInfoUl">
			                			<li>
			                				<dl>
			                					<dt><spring:message code="exam.label.exam.stare.type" /><!-- 시험구분 --></dt>
			                					<dd>${vo.examStareTypeNm }</dd>
			                					<dt><spring:message code="exam.label.exam.type" /><!-- 시험유형 --></dt>
			                					<dd>
			                						${vo.examTypeNm }
			                						<c:choose>
			                							<c:when test="${vo.examTypeCd eq 'EXAM' && not empty vo.insRefCd}">
			                								| <spring:message code="common.label.alternate.assessment" /> ${vo.insRefTypeNm }
			                							</c:when>
			                							<c:otherwise>
			                								
			                							</c:otherwise>
			                						</c:choose>
			                					</dd>
			                				</dl>
			                			</li>
			                			<li>
			                				<dl>
			                					<dt><spring:message code="exam.label.stare.status" /><!-- 응시현황 --></dt>
			                					<dd>
			                						<c:choose>
			                							<c:when test="${vo.examTypeCd eq 'EXAM' }">
			                								${vo.examJoinUserCnt }/${vo.examTotalUserCnt }
			                							</c:when>
			                							<c:otherwise>
			                								-
			                							</c:otherwise>
			                						</c:choose>
				                					<c:if test="${vo.examStareTypeCd eq 'A' }">
					                					<a href="javascript:examStareJoinList()" class="ui basic small button fr"><spring:message code="exam.label.stare.status" /><!-- 응시현황 --></a>
				                					</c:if>
			                					</dd>
			                					<dt></dt>
			                					<dd></dd>
			                				</dl>
			                			</li>
			                		</ul>
		                		</div>
		                		<div class="option-content">
		                			<div class="mla">
		                            	<a href="javascript:manageExam(0)" class="ui blue button"><spring:message code="exam.button.mod" /></a><!-- 수정 -->
										<a href="javascript:manageExam(1)" class="ui blue button"><spring:message code="exam.button.list" /></a><!-- 목록 -->
										<a href="javascript:delExam()" class="ui blue button"><spring:message code="exam.button.del" /></a><!-- 삭제 -->
		                            </div>
		                		</div>
		                	</div>
		                </div>
        			</div>
        		</div>
			</div>
			<%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
        </div>
        <!-- //본문 content 부분 -->
    </div>
</body>
</html>