<%@page import="knou.framework.common.SessionInfo"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
<script type="text/javascript">
	var USER_DEPT_LIST = [];
	var CRS_CRE_LIST   = [];
	$(document).ready(function() {
		// 부서정보
		<c:forEach var="item" items="${deptList}">
			USER_DEPT_LIST.push({
				  deptCd: '<c:out value="${item.deptCd}" />'
				, deptNm: '<c:out value="${item.deptNm}" />'
				, deptCdOdr: '<c:out value="${item.deptCdOdr}" />'
			});
		</c:forEach>
		
		// 부서명 정렬
		USER_DEPT_LIST.sort(function(a, b) {
			if(a.deptCdOdr < b.deptCdOdr) return -1;
			if(a.deptCdOdr > b.deptCdOdr) return 1;
			if(a.deptCdOdr == b.deptCdOdr) {
				if(a.deptNm < b.deptNm) return -1;
				if(a.deptNm > b.deptNm) return 1;
			}
			return 0;
		});
		
		$("#searchValue").on("keyup", function(e) {
			if(e.keyCode == 13) {
				listExamDsblReq();
			}
		});
		
		changeTerm();
	});
	
	// 학기 변경
	function changeTerm() {
		// 학기 과목정보 조회
		var url = "/crs/creCrsHome/listCrsCreDropdown.do";
		var data = {
			  creYear	: $("#creYear").val()
			, creTerm	: $("#creTerm").val()
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnList = data.returnList || [];
				
				this["CRS_CRE_LIST"] = returnList.sort(function(a, b) {
					if(a.crsCreNm < b.crsCreNm) return -1;
					if(a.crsCreNm > b.crsCreNm) return 1;
					if(a.crsCreNm == b.crsCreNm) {
						if(a.declsNo < b.declsNo) return -1;
						if(a.declsNo > b.declsNo) return 1;
					}
					return 0;
				});
				
				// 대학 구분 변경
				changeUnivGbn("ALL");
				
				$("#univGbn").on("change", function() {
					changeUnivGbn(this.value);
				});
        	} else {
        		alert(data.message);
        	}
		}, function(xhr, status, error) {
			alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
		}, true);
	}
	
	// 대학구분 변경
	function changeUnivGbn(univGbn) {
		var deptCdObj = {};
		
		this["CRS_CRE_LIST"].forEach(function(v, i) {
			if((univGbn == "ALL" || v.univGbn == univGbn) && v.deptCd) {
				deptCdObj[v.deptCd] = true;
			}
		});
		
		var html = '<option value="ALL"><spring:message code="user.title.userdept.select" /></option>'; // 학과 선택
		USER_DEPT_LIST.forEach(function(v, i) {
			if(deptCdObj[v.deptCd]) {
				html += '<option value="' + v.deptCd + '">' + v.deptNm + '</option>';
			}
		});
		
		// 부서 초기화
		$("#deptCd").html(html);
		$("#deptCd").dropdown("clear");
		$("#deptCd").on("change", function() {
			changeDeptCd(this.value);
		});
		
		// 학과 초기화
		$("#crsCreCd").empty();
		$("#crsCreCd").dropdown("clear");
		
		// 부서변경
		changeDeptCd("ALL");
	}
	
	// 학과 변경
	function changeDeptCd(deptCd) {
		var univGbn = ($("#univGbn").val() || "").replace("ALL", "");
		var deptCd = (deptCd || "").replace("ALL", "");
		
		var html = '<option value="ALL"><spring:message code="common.subject.select" /></option>'; // 과목 선택
		
		CRS_CRE_LIST.forEach(function(v, i) {
			if((!univGbn || v.univGbn == univGbn) && (!deptCd || v.deptCd == deptCd)) {
				var declsNo = v.declsNo;
				declsNo = '(' + declsNo + ')';
				
				html += '<option value="' + v.crsCreCd + '">' + v.crsCreNm + declsNo + '</option>';
			}
		});
		
		$("#crsCreCd").html(html);
		$("#crsCreCd").dropdown("clear");
	}
	
	// 지원 신청 정보 팝업
	function viewExamDsblReq(stdNo, crsCreCd, dsblReqCd) {
		var type = "${type}";
		
		if(type == "PROFESSOR") {
			var url = "/jobSchHome/viewSysJobSch.do";
			var data = {
				"crsCreCd"     : crsCreCd,
				"calendarCtgr" : "00190806", // 시험지원요청(교수)
				"termCd"	   : "${termVO.termCd}"
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnVO = data.returnVO;
					if(returnVO != null) {
						var jobSchPeriodYn = returnVO.jobSchPeriodYn;
						var jobSchExcPeriodYn = returnVO.jobSchExcPeriodYn;
						
						if(jobSchPeriodYn == "Y" || jobSchExcPeriodYn == "Y") {
							var kvArr = [];
							kvArr.push({'key' : 'stdNo', 	  'val' : stdNo});
							kvArr.push({'key' : 'dsblReqCd',  'val' : dsblReqCd});
							kvArr.push({'key' : 'crsCreCd',   'val' : crsCreCd});
							kvArr.push({'key' : 'searchMenu', 'val' : "${type}"});
							
							submitForm("/exam/examMgr/viewExamDsblReqPop.do", "examPopIfm", "dsblReq", kvArr);
						} else {
							/* 시험지원 승인은 승인기간 안에만 가능합니다. */
							alert("<spring:message code='exam.alert.dsbl.req.approve.not.datetime' />");
						}
					} else {
						/* 등록된 일정이 없습니다. */
						alert("<spring:message code='sys.alert.already.job.sch' />");
					}
	        	} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				/* 정보 조회 중 에러가 발생하였습니다. */
				alert("<spring:message code='exam.error.info' />");
			});
		} else {
			var kvArr = [];
			kvArr.push({'key' : 'stdNo', 	  'val' : stdNo});
			kvArr.push({'key' : 'dsblReqCd',  'val' : dsblReqCd});
			kvArr.push({'key' : 'crsCreCd',   'val' : crsCreCd});
			kvArr.push({'key' : 'searchMenu', 'val' : "${type}"});
			
			submitForm("/exam/examMgr/viewExamDsblReqPop.do", "examPopIfm", "dsblReq", kvArr);
		}
	}
	
	// 장애학생 시험지원 내역 리스트
	function listExamDsblReq() {
		var url  = "/exam/examMgr/examDsblReqList.do";
		var data = {
			"creYear"     	: $("#creYear").val(),
			"creTerm"     	: $("#creTerm").val(),
			"apprStat"		: ($("#apprStat").val() || "").replace("ALL", ""),
			"univGbn"		: ($("#univGbn").val() || "").replace("ALL", ""),
			"deptCd"		: ($("#deptCd").val() || "").replace("ALL", ""),
			"crsCreCd"   	: ($("#crsCreCd").val() || "").replace("ALL", ""),
			"searchValue"	: $("#searchValue").val(),
			"profUserId"	: $("#searchProfessor input[name=userId]").val(),
			"profUserNm"	: $("#searchProfessor input[name=userNm]").val(),
			"userId"		: $("#searchStudent input[name=userId]").val(),
			"userNm"		: $("#searchStudent input[name=userNm]").val()
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnList = data.returnList || [];
        		var html = "";
        		
       			returnList.forEach(function(v, i) {
       				var dsblReqCd = v.dsblReqCd != null ? v.dsblReqCd : "";
       				var disabilityCdNm = v.disabilityCdNm == null ? "-" : v.disabilityCdNm;
       				
       				var appliExamList = [];
       				var examReqList = [];
       				var addTimeList = [];
       				
       				if(v.disablilityExamYn == "Y") {
       					if(v.midExamYn == "Y") {
        					appliExamList.push("<spring:message code='exam.label.mid' />"); // 중간
        					examReqList.push("<spring:message code='exam.label.time.late' />"); //시간연장
        				}
       					
       					if(v.lastExamYn == "Y") {
        					appliExamList.push("<spring:message code='exam.label.final' />"); // 기말
        					examReqList.push("<spring:message code='exam.label.time.late' />"); //시간연장
        				}
       					
       					if(v.midApprStat || v.endApprStat) {
       						if(v.midExamYn == "Y") {
       							addTimeList.push("<spring:message code='exam.label.late' />("+v.midAddTime+"<spring:message code='exam.label.stare.min' />)"); // 연장 분
       						} 
       						
       						if(v.lastExamYn == "Y") {
       							addTimeList.push("<spring:message code='exam.label.late' />("+v.endAddTime+"<spring:message code='exam.label.stare.min' />)"); // 연장 분
       						}
       					}
       				}
       				
       				html += "<tr>";
       				html += "	<td class='tc p_w3'>";
       				html += "		<div class='ui checkbox'>";
       				html += "			<input type='checkbox' name='evalChk' id='evalChk"+v.lineNo+"' data-userId=\""+v.userId+"\" data-crs-cre-cd=\""+v.crsCreCd+"\" onchange='checkUserToggle(this)' user_id=\""+v.userId+"\" user_nm=\""+v.userNm+"\" mobile=\""+v.mobileNo+"\" email=\""+v.email+"\">";
       				html += "			<label class='toggle_btn' for='evalChk"+v.lineNo+"'></label>";
       				html += "		</div>";
       				html += "	</td>";
       				html += "	<td class='tc p_w3'>" + v.lineNo + "</td>";
       				html += "	<td class='p_w10'>" + v.deptNm + "</td>";
       				html += "	<td class='tc p_w10'>" + v.userId + "</td>";
       				html += "	<td class='tc p_w10 word_break_none'><p><a class='fcBlue' href='javascript:viewExamDsblReq(\"" + v.stdNo + "\", \"" + v.crsCreCd + "\", \"" + dsblReqCd + "\")'>"+v.userNm+"</a>";
       				html + 		userInfoIcon("<%=SessionInfo.isKnou(request)%>", "userInfoPop('"+v.userId+"')");
       				html += "	</p></td>";
       				html += "	<td class='p_w15'>" + v.crsCreNm + "</td>";
       				html += "	<td class='tc p_w3'>" + v.declsNo + "</td>";
       				html += "	<td class='tc p_w5'>" + (v.schregGbn || '-') + "</td>";
       				html += "	<td class='tc p_w10'>" + (v.profUserId || '-') + "</td>";
       				html += "	<td class='tc p_w10'>" + (v.profUserNm || '-') + "</td>";
       				html += "	<td class='tc p_w10'>" + (v.tutorUserId || '-') + "</td>";
       				html += "	<td class='tc p_w10'>" + (v.tutorUserNm || '-') + "</td>";
       				html += "	<td class='tc p_w5'>" + disabilityCdNm + "</td>";
       				html += "	<td class='tc p_w5'>" + v.disabilityLvNm + "</td>";
       				html += "	<td class='tc p_w5'>" + (appliExamList.join("/") || "-") + "</td>"; // 신청학기
       				html += "	<td class='tc p_w10'>" + (examReqList.join("/") || "-") + "</td>"; // 학생요청사항
       				html += "	<td class='tc p_w10'>" + (addTimeList.join("/") || "-") + "</td>"; // 요청결과
       				html += "</tr>";
       			});
        		
        		$("#examDsblReqCnt").text(returnList.length);
        		$("#examDsblReqList").empty().html(html);
        	} else {
        		alert(data.message);
        	}
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
		}, true);
	}
	
	// 엑셀 다운로드
	function excelDown() {
		var excelGrid = {
			colModel:[
			   {label:"<spring:message code='main.common.number.no' />", name:'lineNo', align:'right', width:'2000'},/* NO */
			   {label:"<spring:message code='exam.label.dept' />", name:'deptNm', align:'left', width:'5000'},/* 학과 */
			   {label:"<spring:message code='exam.label.user.no' />", name:'userId', align:'left', width:'5000'},/* 학번 */
			   {label:"<spring:message code='exam.label.user.nm' />", name:'userNm', align:'left', width:'5000'},/* 이름 */
			   {label:"<spring:message code='crs.label.crecrs.nm' />", name:'crsCreNm', align:'left', width:'10000'},/* 과목먕 */
			   {label:"<spring:message code='crs.label.decls' />", name:'declsNo', align:'center', width:'2000'},/* 분반 */
			   {label:"<spring:message code='exam.label.academic.status' />", name:'schregGbn', align:'left', width:'5000'},/* 학적상태 */
			   {label:"<spring:message code='exam.label.dsbl.req.type' />", name:'disabilityCdNm', align:'center', width:'5000'},/* 장애종류 */
			   {label:"<spring:message code='exam.label.dsbl.req.degree' />", name:'disabilityLvNm', align:'center', width:'5000'},/* 장애정도 */
			   {label:"<spring:message code='exam.label.process.status' />", name:'midApprStat', align:'center', width:'5000', codes:{APPROVE:"<spring:message code='exam.label.approve' />",COMPANION:"<spring:message code='exam.label.companion' />"}},/* 처리상태 *//* 승인 *//* 반려 */
			   {label:"<spring:message code='exam.label.late.time.mid.exam' />", name:'midAddTime', align:'center', width:'5000'},/* 연장시간(분) 중간고사 */
			   {label:"<spring:message code='exam.label.late.time.end.exam' />", name:'endAddTime', align:'center', width:'5000'},/* 연장시간(분) 기말고사 */
			]
		};
		
		var kvArr = [];
		kvArr.push({'key' : 'creYear', 		'val' : $("#creYear").val()});
		kvArr.push({'key' : 'creTerm', 		'val' : $("#creTerm").val()});
		kvArr.push({'key' : 'apprStat', 	'val' : ($("#apprStat").val() || "").replace("ALL", "")});
		kvArr.push({'key' : 'univGbn', 		'val' : ($("#univGbn").val() || "").replace("ALL", "")});
		kvArr.push({'key' : 'deptCd', 		'val' : ($("#deptCd").val() || "").replace("ALL", "")});
		kvArr.push({'key' : 'crsCreCd', 	'val' : ($("#crsCreCd").val() || "").replace("ALL", "")});
		kvArr.push({'key' : 'searchValue', 	'val' : $("#searchValue").val()});
		kvArr.push({'key' : 'profUserId', 	'val' : $("#searchProfessor input[name=userId]").val()});
		kvArr.push({'key' : 'profUserNm', 	'val' : $("#searchProfessor input[name=userNm]").val()});
		kvArr.push({'key' : 'userId', 		'val' : $("#searchStudent input[name=userId]").val()});
		kvArr.push({'key' : 'userNm', 		'val' : $("#searchStudent input[name=userNm]").val()});
		kvArr.push({'key' : 'excelGrid', 	'val' : JSON.stringify(excelGrid)});
		
		submitForm("/exam/examMgr/examDsblReqExcelDown.do", "", "", kvArr);
	}
	
	// 전체 선택 / 해제
    function checkAllUserToggle(obj) {
        $("input:checkbox[name=evalChk]").prop("checked", $(obj).is(":checked"));

        $('input:checkbox[name=evalChk]').each(function (idx) {
            if ($(obj).is(":checked")) {
                addSelectedUser($(this).attr("data-userId"));
            } else {
                removeSelectedUser($(this).attr("data-userId"));
            }
        });
    }

    // 한건 선택 / 해제
    function checkUserToggle(obj) {
        if ($(obj).is(":checked")) {
        	addSelectedUser($(obj).attr("data-userId"));
        } else {
        	removeSelectedUser($(obj).attr("data-userId"));
        }
        var totChkCnt = $("input:checkbox[name=evalChk]").length;
        var chkCnt = $("input:checkbox[name=evalChk]:checked").length;
        if(totChkCnt == chkCnt) {
        	$("input:checkbox[name=allEvalChk]").prop("checked", true);
        } else {
        	$("input:checkbox[name=allEvalChk]").prop("checked", false);
        }
    }

    // 선택된 학습자 번호 추가
    function addSelectedUser(userId) {
        var selectedUser = $("#userIds").val();
        if (selectedUser.indexOf(userId) == -1) {
            if (selectedUser.length > 0) {
            	selectedUser += ',';
            }
            selectedUser += userId;
            $("#userIds").val(selectedUser);
        }
    }

    // 선택된 학습자 번호 제거
    function removeSelectedUser(userId) {
        var selectedUser = $("#userIds").val();
        if (selectedUser.indexOf(userId) > -1) {
        	selectedUser = selectedUser.replace(userId, "");
        	selectedUser = selectedUser.replace(",,", ",");
        	selectedUser = selectedUser.replace(/^[,]*/g, '');
        	selectedUser = selectedUser.replace(/[,]*$/g, '');
            $("#userIds").val(selectedUser);
        }
    }
    
    // 교직원 검색
    function selectProfessorList() {
    	var kvArr = [];
		kvArr.push({'key' : 'userId', 	  'val' : ""});
		kvArr.push({'key' : 'userNm', 	  'val' : ""});
		kvArr.push({'key' : 'goUrl', 	  'val' : ""});
		kvArr.push({'key' : 'subParam',   'val' : "searchProfessor|examPopIfm|examPop"});
		kvArr.push({'key' : 'searchMenu', 'val' : ""});
		
		submitForm("/user/userMgr/professorSearchListPop.do", "examPopIfm", "profSearch", kvArr);
    }
    
 	// 학생 검색
	function selectStudentList() {
		var kvArr = [];
		kvArr.push({'key' : 'userId', 	  'val' : ""});
		kvArr.push({'key' : 'userNm', 	  'val' : ""});
		kvArr.push({'key' : 'goUrl', 	  'val' : ""});
		kvArr.push({'key' : 'subParam',   'val' : "searchStudent|examPopIfm|examPop"});
		kvArr.push({'key' : 'searchMenu', 'val' : ""});
		
		submitForm("/user/userMgr/studentSearchListPop.do", "examPopIfm", "stdSearch", kvArr);
	}
 	
	//사용자 정보 팝업
 	function userInfoPop(userId) {
 		event.stopPropagation();
 		var userInfoUrl = "${userInfoPopUrl}" + btoa(`{"stuno":"\${userId}"}`);
 		var options = 'top=100, left=150, width=1200, height=800';
 		window.open(userInfoUrl, "", options);
 	}
	
 	// 메세지 보내기
	function sendMsg() {
		var sendType = $("#sendType").val();
 		
		if(!sendType) {
 			alert("<spring:message code='exam.alert.empty.receive.target'/>"); // 수신대상을 선택하세요.
 			return;
 		}
		
		var isSelected = false;
		
		$.each($('#examDsblReqList').find("input:checkbox[name=evalChk]:not(:disabled):checked"), function() {
			isSelected = true;
			return false;
		});
		
		var dupCheckObj = {};
		
		if(sendType == "PROFESSOR" || sendType == "ASSISTANT") {
			var crsCreCdList = [];
 			
 			$.each($('#examDsblReqList').find("input:checkbox[name=evalChk]:not(:disabled):checked"), function() {
 				var crsCreCd = $(this).data("crsCreCd");
 				
 				if(!dupCheckObj[crsCreCd]) {
 					dupCheckObj[crsCreCd] = true;
 					crsCreCdList.push(crsCreCd);
 				}
 			});
 			
 			var url = "/crs/creCrsHome/creCrsTchList.do";
 	 		var param = {
 	 			  crsCreCds	: crsCreCdList.join(",")
 	 			, searchKey	: sendType
 	 		};
 	 		
 	 		ajaxCall(url, param, function(data) {
 				if(data.result > 0) {
 					var returnList = data.returnList || [];
 					var dupCheckObj2 = {};
 					var sendList = [];
 					
 					returnList.forEach(function(v, i) {
 						if(!dupCheckObj2[v.userId]) {
 							dupCheckObj2[v.userId] = true;
 							sendList.push({
 								 userId		: v.userId
 								,userNm		: v.userNm
 								,mobileNo	: v.mobileNo
 								,email		: v.email
 							});
 						}
 					});
 					
 					var rcvUserInfoStr = "";
 					var sendCnt = 0;
 					
 					sendList.forEach(function(v, i) {
 						sendCnt++;
 						if (sendCnt > 1) rcvUserInfoStr += "|";
 						rcvUserInfoStr += v.userId;
 						rcvUserInfoStr += ";" + v.userNm; 
 						rcvUserInfoStr += ";" + v.mobileNo;
 						rcvUserInfoStr += ";" + v.email; 
 					});
 					
 					if(sendCnt == 0) {
 						alert('<spring:message code="exam.error.tch.not.exist" />'); // 담당 교수자 정보가 존재하지 않습니다.
 						return;
 					}
 					
 			        window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");

 			        var form = document.alarmForm;
 			        form.action = "<%=CommConst.SYSMSG_URL_SEND%>";
 			        form.target = "msgWindow";
 			        form[name='alarmType'].value = "S"; // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
 			        form[name='rcvUserInfoStr'].value = rcvUserInfoStr; //보내는사람 정보
 			        form.submit();
 	        	} else {
 	        		alert('<spring:message code="exam.error.tch.not.exist" />'); // 담당 교수자 정보가 존재하지 않습니다.
 	        	}
 			}, function(xhr, status, error) {
 				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
 			}, true);
		} else {
			var rcvUserInfoStr = "";
			var sendCnt = 0;
			
			$.each($('#examDsblReqList').find("input:checkbox[name=evalChk]:not(:disabled):checked"), function() {
				var userId = $(this).attr("user_id");
 				
 				if(!dupCheckObj[userId]) {
 					dupCheckObj[userId] = true;
 					sendCnt++;
 					if (sendCnt > 1) rcvUserInfoStr += "|";
 					rcvUserInfoStr += $(this).attr("user_id");
 					rcvUserInfoStr += ";" + $(this).attr("user_nm"); 
 					rcvUserInfoStr += ";" + $(this).attr("mobile");
 					rcvUserInfoStr += ";" + $(this).attr("email"); 
 				}
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
		
	}
 	
	if(window.addEventListener) {
		window.addEventListener("message", receiveMessage, false);
	} else {
		if(window.attachEvent) {
			window.attachEvent("onmessage", receiveMessage);
		}
	}
	
	function receiveMessage(event) {
		var data = event.data;
		if(data.type == "close") {
			closeModal();
		} else if(data.type == "search") {
			$("#searchProfessor input[name=userId]").val(data.userId);
			$("#searchProfessor input[name=userNm]").val(data.userNm);
		}
	}
</script>

<body>
    <div id="wrap" class="pusher">
        <!-- class_top 인클루드  -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>

        <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>

        <div id="container">
            <!-- 본문 content 부분 -->
            <div class="content">
            	<div id="info-item-box">
                	<h2 class="page-title flex-item">
					    <spring:message code="exam.label.study" /><!-- 수업 -->
					    <div class="ui breadcrumb small">
					        <small class="section"><spring:message code="exam.label.dsbl.req" /><!-- 장애인 시험지원 --><c:if test="${type eq 'PROFESSOR' }">(<spring:message code="exam.label.tch" /><!-- 교수 -->)</c:if></small>
					    </div>
					</h2>
				</div>
				<div class="ui divider mt0"></div>
        		<div class="ui form">
        			<div class="option-content gap4">
	                   	<select class="ui dropdown mr5" id="creYear" onchange="changeTerm()">
							<c:forEach var="item" items="${yearList}" varStatus="status">
								<option value="${item}" <c:if test="${item eq termVO.haksaYear}">selected</c:if>>${item}</option>
							</c:forEach>
						</select>
						<select class="ui dropdown mr5" id="creTerm" onchange="changeTerm()">
							<c:forEach var="item" items="${termList }">
								<option value="${item.codeCd }" <c:if test="${item.codeCd eq termVO.haksaTerm}">selected</c:if>>${item.codeNm }</option>
							</c:forEach>
						</select>
	                   	<select class="ui dropdown" id="apprStat" onchange="listExamDsblReq()">
	                   		<option value=""><spring:message code="exam.label.process.yn" /><!-- 처리여부 --></option>
	                   		<option value="ALL" selected><spring:message code="common.all" /><!-- 전체 --></option>
	                   		<option value="WAIT"><spring:message code="exam.label.applicate.n" /><!-- 미신청자 --></option>
	                   		<option value="COMPL"><spring:message code="exam.label.applicate.y" /><!-- 신청자 --></option>
	                   	</select>
	                   	<select id="univGbn" class="ui dropdown mr5" onchange="changeUnivGbn()">
			               	<option value=""><spring:message code="common.label.uni.type" /></option><!-- 대학구분 -->
			               	<option value="ALL"><spring:message code="common.all" /></option><!-- 전체 -->
			               	<c:forEach var="item" items="${univGbnList}">
								<option value="${item.codeCd}" ${item.codeCd}><c:out value="${item.codeNm}" /></option>
							</c:forEach>
			            </select>
			            <select id="deptCd" class="ui dropdown w250" onchange="changeDeptCd()">
	                    	<option value=""><spring:message code="common.dept_name" /><!-- 학과 --> <spring:message code="common.select" /><!-- 선택 --></option>
	                    </select> 
	                    <select id="crsCreCd" class="ui dropdown mr5 w250">
			            	<option value=""><spring:message code="common.subject" /><!-- 과목 --> <spring:message code="common.select" /><!-- 선택 --></option>
			            </select>
					</div>
					<div class="ui segment searchArea">
	                   	<input type="text" id="searchValue" placeholder="<spring:message code="user.message.search.input.crscd.crsnm" />" class="w250" /><!-- 과목명/학수번호 입력 -->
	                   	<c:if test="${type eq 'ALL' }">
	                    	<div class="ui action input search-box" id="searchProfessor">
		                    	<input type="text" name="userId" placeholder="<spring:message code='exam.label.tch.no' />" class="w150 bcLgrey" autocomplete="off" /><!-- 사번 -->
		                    	<input type="text" name="userNm" placeholder="<spring:message code='exam.label.tch.nm' />" class="w150 bcLgrey" autocomplete="off" /><!-- 교수명 -->
							    <button class="ui icon button" onclick="selectProfessorList(1)"><i class="search icon"></i></button>
							</div>
	                   	</c:if>
	                   	<div class="ui action input search-box" id="searchStudent">
	                    	<input type="text" name="userId" placeholder="<spring:message code='exam.label.user.no' />" class="w150 bcLgrey" autocomplete="off" /><!-- 학번 -->
	                    	<input type="text" name="userNm" placeholder="<spring:message code='exam.label.user.nm' />" class="w150 bcLgrey" autocomplete="off" /><!-- 이름 -->
						    <button class="ui icon button" onclick="selectStudentList(1)"><i class="search icon"></i></button>
						</div>
						<div class="button-area mt10 tc">
							<a href="javascript:listExamDsblReq()" class="ui blue button w100"><spring:message code="exam.button.search" /><!-- 검색 --></a>
						</div>
					</div>
       				<div class="mt15 mb15 tc bcYellow p10">
		            	<fmt:parseDate var="schStartDtFmt" pattern="yyyyMMddHHmmss" value="${sysJobSchVO.schStartDt }" />
						<fmt:formatDate var="schStartDt" pattern="yyyy.MM.dd HH:mm" value="${schStartDtFmt }" />
				    	<fmt:parseDate var="schEndDtFmt" pattern="yyyyMMddHHmmss" value="${sysJobSchVO.schEndDt }" />
						<fmt:formatDate var="schEndDt" pattern="yyyy.MM.dd HH:mm" value="${schEndDtFmt }" />
				    	<spring:message code="exam.label.dsbl.req.approve.dttm" /> : ${schStartDt } ~ ${schEndDt }<!-- 장애 학생 시험지원 승인기간 -->
				    </div>
				    <div class="p20">
					    <p>* <spring:message code="exam.label.dsbl.req.msg1" /> <!-- 자세한 장애인 등급 판정기준은 보건복지부 > 장애인 정책 > 알림마당 -->
					    	<a class="fcBlue" href="http://www.mohw.go.kr/react/policy/index.jsp?PAR_MENU_ID=06&MENU_ID=06370111&PAGE=11&topTitle=%EC%9E%A5%EC%95%A0%EC%9D%B8%EB%93%B1%EB%A1%9D/%EC%9E%A5%EC%95%A0%EC%A0%95%EB%8F%84%20%EC%8B%AC%EC%82%AC%EC%A0%9C%EB%8F%84">[<spring:message code="exam.button.short.cut" />]</a><!-- 바로가기 -->
					    	<spring:message code="exam.label.dsbl.req.msg2" /></p><!-- 를 참조하세요. -->
					    <p>* <spring:message code="exam.label.dsbl.req.msg3" /></p><!-- 청각장애학생이 자막/스크립트가 없는 과목 수강 시 추가 제공이 가능합니다. 청각장애 학생 요청 시 콘텐츠 개발팀으로 문의해 주세요. -->
				    </div>
				    <div class="option-content mb20">
				    	<h3 class="sec_head"><spring:message code="exam.label.dsbl.req.applicate.hsty" /><!-- 장애인학생 시험지원 요청내역 --></h3>
				    	<span class="ml10">[ <spring:message code="exam.label.total.cnt" /><!-- 총 건수 --> : <label class="fcBlue" id="examDsblReqCnt"></label> ]</span>
				    	<div class="mla">
				    		<select class="ui dropdown" id="sendType">
       							<option value=""><spring:message code="exam.label.receive.target" /><!-- 수신대상 --></option>
						        <option value="STUDENT"><spring:message code="exam.label.student" /><!-- 학생 --></option>
						        <option value="PROFESSOR"><spring:message code="exam.label.manage.professor" /><!-- 담당교수 --></option>
						        <option value="ASSISTANT"><spring:message code="exam.label.manage.assistant" /><!-- 담당조교 --></option>
						    </select>
				    		<uiex:msgSendBtn func="sendMsg()" styleClass="ui basic button"/><!-- 메시지 -->
				    		<a href="javascript:excelDown()" class="ui green button"><spring:message code="exam.button.excel.down" /><!-- 엑셀 다운로드 --></a>
				    	</div>
				    </div>
				    <div class="footable_box type2 max-height-550">
					    <table class="tBasic" data-sorting="false" data-paging="false" data-empty="<spring:message code='exam.common.empty' />" id="examDsblReqTable"><!-- 등록된 내용이 없습니다. -->
						 	<thead class="sticky top0">
							 	<tr>
								 	<th class="tc p_w3">
								 		<div class="ui checkbox">
											<input type="hidden" id="userIds" name="userIds">
								            <input type="checkbox" name="allEvalChk" id="allChk" value="all" onchange="checkAllUserToggle(this)">
								            <label class="toggle_btn" for="allChk"></label>
								        </div>
								 	</th>
								 	<th class="tc p_w3"><spring:message code="common.number.no" /><!-- NO. --></th>
								 	<th class="tc p_w10"><spring:message code="exam.label.dept" /><!-- 학과 --></th>
								 	<th class="tc p_w10"><spring:message code="exam.label.user.no" /><!-- 학번 --></th>
								 	<th class="tc p_w10"><spring:message code="exam.label.user.nm" /><!-- 이름 --></th>
								 	<th class="tc p_w15"><spring:message code="crs.label.crecrs.nm" /><!-- 과목명 --></th>
								 	<th class="tc p_w3"><spring:message code="crs.label.decls" /><!-- 분반 --></th>
								 	<th class="tc p_w5"><spring:message code="exam.label.academic.status" /><!-- 학적상태 --></th>
								 	<th class="tc p_w10"><spring:message code="common.label.prof.no" /><!-- 교수사번 --></th>
								 	<th class="tc p_w10"><spring:message code="common.label.prof.nm" /><!-- 교수명 --></th>
								 	<th class="tc p_w10"><spring:message code="common.label.tutor.no" /><!-- 튜터사번 --></th>
								 	<th class="tc p_w10"><spring:message code="common.label.tutor.nm" /><!-- 튜터명 --></th>
								 	<th class="tc p_w5"><spring:message code="exam.label.dsbl.req.type" /><!-- 장애종류 --></th>
								 	<th class="tc p_w5"><spring:message code="exam.label.dsbl.req.degree" /><!-- 장애정도 --></th>
								 	<th class="tc p_w5"><spring:message code="exam.label.applicate.term" /><!-- 신청학기 --></th>
								 	<th class="tc p_w10"><spring:message code="exam.label.std.request" /><!-- 학생요청사항 --></th>
								 	<th class="tc p_w10"><spring:message code="exam.label.request.result" /><!-- 요청결과 --></th>
							 	</tr>
						 	</thead>
						 	<tbody id="examDsblReqList">
						 	</tbody>
					    </table>
				    </div>
        		</div>
			</div>
        </div>
        <!-- //본문 content 부분 -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
    </div>
</body>
</html>