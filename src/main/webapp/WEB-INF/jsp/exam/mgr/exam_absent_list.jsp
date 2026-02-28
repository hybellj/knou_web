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
				listExamAbsent();
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
	
	// 결시원 목록 조회
	function listExamAbsent() {
		$("#viewAbsentDiv").empty();
		$("#examAbsentCds").val("");
		
		var url  = "/exam/examMgr/examAbsentList.do";
		var data = {
			"creYear"     		: $("#creYear").val(),
			"creTerm"     		: $("#creTerm").val(),
			"univGbn"			: ($("#univGbn").val() || "").replace("ALL", ""),
			"deptCd"			: ($("#deptCd").val() || "").replace("ALL", ""),
			"crsCreCd"			: ($("#crsCreCd").val() || "").replace("ALL", ""),
			"examStareTypeCd"   : $("#examStareTypeCd").val(),
			"apprStat"  		: $("#apprStat").val(),
			"searchValue" 		: $("#searchValue").val(),
			"userId"			: $("#searchUserId").val(),
			"userNm"			: $("#searchUserNm").val(),
			"tchNo"				: $("#searchProfessor input[name=userId]").val(),
			"tchNm"				: $("#searchProfessor input[name=userNm]").val()
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnList = data.returnList || [];
        		var html = "";
        		
        		if(returnList.length > 0) {
        			returnList.forEach(function(v, i) {
        				var regDttm = dateFormat("date", v.regDttm);
        				var modDttm = v.apprStat == "APPROVE" || v.apprStat == "COMPANION" ? dateFormat("date", v.modDttm) : '-';
        				var modNm   = v.apprStat == "APPROVE" || v.apprStat == "COMPANION" ? v.modNm : '-';
        				//var isChecked = $("#examAbsentCds").val().includes(v.examAbsentCd) ? 'checked' : '';
        				var approveYn = v.apprStat == "APPROVE" ? 'Y' : 'N';
        				var apprClass = "fcBlue"
        				
        				if(v.apprStat == "RAPPLICATE") {
        					apprClass = "fcOrange";
        				} else if(v.apprStat == "COMPANION") {
        					apprClass = "fcRed";
        				}
        				
        				html += `<tr>`;
        				html += `	<td class='tc p_w3'>`;
        				html += `		<div class='ui checkbox'>`;
        				html += `			<input type='checkbox' name='evalChk' id='evalChk\${v.lineNo}' data-apprStat='\${v.apprStat}' data-examAbsentCd='\${v.examAbsentCd}' data-crs-cre-cd='\${v.crsCreCd}' onchange="checkAbsentToggle(this)" user_id='\${v.userId}' user_nm='\${v.userNm}' mobile='\${v.mobileNo}' email='\${v.email}'>`;
        				html += `			<label class='toggle_btn' for='evalChk\${v.lineNo}'></label>`;
        				html += `		</div>`;
        				html += `	</td>`;
        				html += `	<td class='tc p_w3'>\${v.lineNo}</td>`;
        				html += `	<td class='p_w5'>\${v.deptNm}</td>`;
        				html += `	<td class='tc p_w10'>\${v.userId}</td>`;
        				html += `	<td class='tc p_w10 word_break_none'><p>\${v.userNm}`;
        				html += 	userInfoIcon("<%=SessionInfo.isKnou(request)%>", "userInfoPop('"+v.userId+"')");
        				html += `	</p></td>`;
        				html += `	<td class='p_w15'>\${v.crsCreNm}</td>`;
        				html += `	<td class='p_w15'>\${v.crsCd}</td>`;
        				html += `	<td class='tc p_w3'>\${v.declsNo}</td>`;
        				html += `	<td class='tc p_w10'>\${v.tchNm}</td>`;
        				html += `	<td class='tc p_w10'>\${v.tchNo}</td>`;
        				html += `	<td class='tc p_w10'>\${v.tutorNm}</td>`;
        				html += `	<td class='tc p_w10'>\${v.tutorNo}</td>`;
        				html += `	<td class="tc p_w5"><a href="javascript:viewExamAbsentPop('\${v.stdNo}', '\${v.crsCreCd}', '\${v.examAbsentCd}')" class="\${apprClass}">\${v.apprStatNm}</a></td>`;
        				html += `	<td class='tc p_w10 word_break_none'>\${regDttm}</td>`;
        				html += `	<td class='tc p_w10'>\${v.examStareTypeNm}</td>`;
        				html += `	<td class='tc p_w10'>\${approveYn}</td>`;
        				html += `	<td class='tc p_w10'>\${v.examSubsYn}</td>`;
        				html += `	<td class='tc p_w10'>\${v.examStareYn}</td>`;
        				html += `	<td class='tc p_w10 word_break_none'>\${modDttm}</td>`;
        				html += `	<td class='tc p_w10'>\${modNm}</td>`;
        				html += `</tr>`;
        			});
        		}
        		
        		$("#examAbsentCnt").text(returnList.length);
        		$("#examAbsentList").empty().html(html);
        		$("#examAbsentTable").footable();
        	} else {
        		alert(data.message);
        	}
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
		}, true);
	}
	
	// 결시원 정보 조회
	function viewExamAbsent() {
		var examAbsentCd = $("#examAbsentCds").val() || "";
		examAbsentCd = examAbsentCd.split(",").reverse()[0];
		
		if(examAbsentCd != "") {
			var url  = "/exam/examMgr/viewExamAbsent.do";
			var data = {
				"examAbsentCd" : examAbsentCd
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnVO = data.returnVO || "";
	        		var html = "";
	        		
	        		if(returnVO != null) {
	        			var examStartDttm = returnVO.examStartDttm && dateFormat("dt", returnVO.examStartDttm) || '-';
	        			var apprStatNm = "";
	        			if(returnVO.apprStat == "APPLICATE") {
	        				apprStatNm = "<spring:message code='exam.label.applicate' />";// 신청
	        			} else if(returnVO.apprStat == "RAPPLICATE") {
	        				apprStatNm = "<spring:message code='exam.label.rapplicate' />";// 재신청
	        			} else if(returnVO.apprStat == "APPROVE") {
	        				apprStatNm = "<spring:message code='exam.label.approve' />";// 승인
	        			} else if(returnVO.apprStat == "COMPANION") {
	        				apprStatNm = "<spring:message code='exam.label.companion' />";// 반려
	        			}
	        			var modDttm = dateFormat("date", returnVO.modDttm);
	        			modDttm = returnVO.apprStat == "APPROVE" || returnVO.apprStat == "COMPANION" ? modDttm : '-';
	        			var modNm = returnVO.apprStat == "APPROVE" || returnVO.apprStat == "COMPANION" ? returnVO.modNm : '-';
	        			html += "<h3 class='sec_head'><spring:message code='exam.label.applicate.list' /></h3>";// 신청내역
	        			html += "<table class='tBasic mt20'>";
	        			html += "	<colgroup>";
	        			html += "		<col width='15%'>";
	        			html += "		<col width='35%'>";
	        			html += "		<col width='15%'>";
	        			html += "		<col width='35%'>";
	        			html += "	</colgroup>";
	        			html += "	<tbody>";
	        			html += "		<tr>";
	        			html += "			<th class='tl'><spring:message code='crs.label.open.dept' /></th>";// 개설학과
	        			html += "			<td class='tl'>"+returnVO.crsDeptNm+"</td>";
	        			html += "			<th class='tl'><spring:message code='crs.label.crs.cd' /></th>";// 학수번호
	        			html += "			<td class='tl'>"+returnVO.crsCd+"</td>";
	        			html += "		</tr>";
	        			html += "		<tr>";
	        			html += "			<th class='tl'><spring:message code='exam.label.subject.nm' /></th>";// 교과명
	        			html += "			<td class='tl'>"+returnVO.crsCreNm+"</td>";
	        			html += "			<th class='tl'><spring:message code='crs.label.decls' /></th>";// 분반
	        			html += "			<td class='tl'>"+returnVO.declsNo+"<spring:message code='exam.label.decls' /></td>";// 반 
	        			html += "		</tr>";
	        			html += "		<tr>";
	        			html += "			<th class='tl'><spring:message code='exam.label.exam.stare.type' /></th>";// 시험구분
	        			html += "			<td class='tl'>"+returnVO.examStareTypeNm+"</td>";
	        			html += "			<th class='tl'><spring:message code='exam.label.exam.dttm' /></th>";// 시험일시
	        			html += "			<td class='tl'>"+examStartDttm+"</td>";
	        			html += "		</tr>";
	        			html += "		<tr>";
	        			html += "			<th class='tl'><spring:message code='exam.label.tch' /><spring:message code='exam.label.nm' /></th>";// 교수 // 명
	        			html += "			<td class='tl'>"+returnVO.tchNm+"</td>";
	        			html += "			<th class='tl'><spring:message code='exam.label.tutor' /><spring:message code='exam.label.nm' /></th>";// 튜터 // 명
	        			html += "			<td class='tl'>"+returnVO.tutorNm+"</td>";
	        			html += "		</tr>";
	        			html += "	</tbody>";
	        			html += "</table>";
	        			html += "<table class='tBasic mt20'>";
	        			html += "	<colgroup>";
	        			html += "		<col width='15%'>";
	        			html += "		<col width='35%'>";
	        			html += "		<col width='15%'>";
	        			html += "		<col width='35%'>";
	        			html += "	</colgroup>";
	        			html += "	<tbody>";
	        			html += "		<tr>";
	        			html += "			<th class='tl'><spring:message code='exam.label.user.no' /></th>";// 학번
	        			html += "			<td class='tl'>"+returnVO.userId+"</td>";
	        			html += "			<th class='tl'><spring:message code='exam.label.user.nm' /></th>";// 이름
	        			html += "			<td class='tl'>"+returnVO.userNm+"</td>";
	        			html += "		</tr>";
	        			html += "		<tr>";
	        			html += "			<th class='tl'><spring:message code='exam.label.dept' /></th>";// 학과
	        			html += "			<td class='tl'>"+returnVO.deptNm+"</td>";
	        			html += "			<th class='tl'><spring:message code='exam.label.mobile.no' /></th>";// 연락처
	        			html += "			<td class='tl'>"+returnVO.mobileNo+"</td>";
	        			html += "		</tr>";
	        			html += "		<tr>";
	        			html += "			<th class='tl'><spring:message code='exam.label.exam' /><spring:message code='exam.label.answer.yn' /></th>";// 시험 // 응시여부
	        			html += "			<td class='tl'>"+returnVO.examStareYn+"</td>";
	        			html += "			<th class='tl'><spring:message code='exam.label.evidence' /></th>";// 증빙자료
	        			html += "			<td class='tl'>";
	        			returnVO.fileList.forEach(function(v, i) {
	        			html += `				<a href="javascript:fileDown('\${v.fileSn }', '\${v.repoCd}')" id="file_\${v.fileSn }" class="wmax">\${v.fileNm }<i class="icon paperclip" style="position:absolute;right:0;"></i></a>`;
	        			});
						html += "			</td>";
	        			html += "		</tr>";
	        			html += "		<tr>";
	        			html += "			<th class='tl'><spring:message code='exam.label.absent.reason' /></th>";// 결시 사유
	        			html += "			<td class='tl' colspan='3'><pre>"+returnVO.absentCts+"</pre></td>";
	        			html += "		</tr>";
	        			html += "	</tbody>";
	        			html += "</table>";
	        			html += "<h3 class='sec_head mt30'><spring:message code='exam.label.approve.process' /></h3>";// 승인처리 
	        			html += "<table class='tBasic mt20'>";
	        			html += "	<colgroup>";
	        			html += "		<col width='15%'>";
	        			html += "		<col width='35%'>";
	        			html += "		<col width='15%'>";
	        			html += "		<col width='35%'>";
	        			html += "	</colgroup>";
	        			html += "	<tbody>";
	        			html += "		<tr>";
	        			html += "			<th class='tl'><spring:message code='exam.label.process.status' /></th>";// 처리상태
	        			html += "			<td class='tl'>";
	        			html += "				<div class='option-content'>";
	        			html += "					"+apprStatNm;
	        			html += "					<a class='ui basic button mla' href='javascript:applicateHstyPop(\""+returnVO.userId+"\")'><spring:message code='exam.label.applicate.hsty' /></a>";// 신청이력
	        			html += "				</div>";
	        			html += "			</td>";
	        			html += "			<th class='tl'><spring:message code='exam.label.process.dttm' /></th>";// 처리일시
	        			html += "			<td class='tl'>"+modDttm+"</td>";
	        			html += "		</tr>";
	        			html += "		<tr>";
	        			html += "			<th class='tl'><spring:message code='exam.label.process.manage' /></th>";// 처리담당자
	        			html += "			<td class='tl' colspan='3'>"+modNm+"</td>";
	        			html += "		</tr>";
	        			html += "		<tr>";
	        			html += "			<th class='tl req'><spring:message code='exam.label.approve.cts' /><spring:message code='exam.label.cts' /></th>";// 처리의견 // 내용
	        			if(returnVO.apprStat == "APPLICATE" || returnVO.apprStat == "RAPPLICATE") {
	        			html += "			<td class='tl' colspan='3'><textarea style='resize:none;' id='apprCts'></textarea></td>";
	        			} else {
	        			html += "			<td class='tl' colspan='3'><pre>"+returnVO.apprCts+"</pre></td>";
	        			}
	        			html += "		</tr>";
	        			html += "	</tbody>";
	        			html += "</table>";
	        		}
	        		
	        		$("#viewAbsentDiv").empty().html(html);
	        	} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				alert("<spring:message code='exam.error.info' />");// 정보 조회 중 에러가 발생하였습니다.
			});
		} else {
			$("#viewAbsentDiv").empty();
		}
	}
	
	// 결시원 정리
	function absentAllCompanion() {
		var creYear = $("#creYear").val();
		var creTerm = $("#creTerm").val();
		var creTermNm = $("#creTerm option[value="+$("#creTerm").val()+"]").text();
		var confirm = window.confirm(creYear+"<spring:message code='exam.label.year' /> "+creTermNm+"<spring:message code='exam.confirm.select.term.absent.clean' />");/* 년 *//* 학기의 결시원 정리를 진행 하시겠습니까? */
		
		if(confirm) {
			var apprCts = "<spring:message code='exam.label.batch.companion' />";/* 일괄 반려 */
			
			var url  = "/exam/updateAllCompanion.do";
			var data = {
				"creYear" : creYear,
				"creTerm" : creTerm,
				"apprCts" : apprCts
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					alert("<spring:message code='exam.alert.batch.companion' />");/* 일괄 반려 처리 완료되었습니다. */
					listExamAbsent();
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='exam.error.batch.companion' />");/* 일괄 반려 처리 중 에러가 발생하였습니다. */
			});
		}
	}
	
	// 결시원 승인 / 반려
	function absentRequest(type) {
		if($("input[name=evalChk]:checked").length == 0) {
			alert("<spring:message code='exam.alert.select.exam.absent' />");/* 요청을 처리 할 결시원을 선택하세요. */
			return false;
		}
		var isChecked = true;
		$("input[name=evalChk]:checked").each(function(i, v) {
			var apprStat = $(v).attr("data-apprStat");
			if(apprStat == "APPROVE" || apprStat == "COMPANION") {
				alert("<spring:message code='exam.alert.select.applicate' />");/* 신청, 재신청 내역만 선택해주세요. */
				isChecked = false;
				return false;
			}
		});
		
		if(isChecked) {
			var confirm = "";
			if(type == "APPROVE") {
				confirm = window.confirm("<spring:message code='exam.confirm.approve' />");/* 요청 승인 하시겠습니까? */
			} else if(type == "COMPANION") {
				confirm = window.confirm("<spring:message code='exam.confirm.companion' />");/* 요청 반려 하시겠습니까? */
			}
			
			if(confirm) {
				if($.trim($("#apprCts").val()) == "") {
		 			alert("<spring:message code='exam.alert.input.contents' />");/* 내용을 입력하세요. */
		 			$("#apprCts").focus();
		 			return false;
		 		}
				
				var url  = "/exam/examMgr/updateExamAbsent.do";
				var data = {
					"examAbsentCd" : $("#examAbsentCds").val(),
					"apprStat"     : type,
					"apprCts"	   : $("#apprCts").val()
				};
				
				ajaxCall(url, data, function(data) {
					if (data.result > 0) {
						if(type == "APPROVE") {
							alert("<spring:message code='exam.alert.approve' />");/* 승인이 완료되었습니다. */
						} else if(type == "COMPANION") {
							alert("<spring:message code='exam.alert.companion' />");/* 반려가 완료되었습니다. */
						}
						listExamAbsent();
						viewExamAbsent();
		            } else {
		             	alert(data.message);
		            }
				}, function(xhr, status, error) {
					alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
				});
			}
		}
	}
	
	// 결시원 추가 팝업
	function addAbsentPop() {
		$("#absentAddForm input[name=creYear]").val($("#creYear").val());
		$("#absentAddForm input[name=creTerm]").val($("#creTerm").val());
		
		var kvArr = [];
		kvArr.push({'key' : 'userId', 	  'val' : ""});
		kvArr.push({'key' : 'userNm', 	  'val' : ""});
		kvArr.push({'key' : 'creYear', 	  'val' : $("#creYear").val()});
		kvArr.push({'key' : 'creTerm', 	  'val' : $("#creTerm").val()});
		kvArr.push({'key' : 'goUrl', 	  'val' : "/exam/examMgr/addExamAbsentPop.do"});
		kvArr.push({'key' : 'subParam',   'val' : "tempForm|examPopIfm|examPop"});
		kvArr.push({'key' : 'searchMenu', 'val' : "popup"});
		
		submitForm("/exam/examMgr/addExamAbsentPop.do", "examPopIfm", "addAbsent", kvArr);
	}
	
	// 결시원 엑셀 다운로드
	function examAbsentExcelDown() {
		var excelGrid = {
			colModel:[
			    {label:"<spring:message code='exam.label.process.status' />", 	 		name:'apprStatNm', 		align:'center',   	width:'5000'},/* 처리상태 */
			    {label:"<spring:message code='exam.label.applicate.dt' />", 	 		name:'regDttm', 		align:'center',   	width:'5000'},/* 신청일 */
			    {label:"<spring:message code='exam.label.user.no' />",   				name:'userId',   	   	align:'center',    	width:'5000'},/* 학번 */
			    {label:"<spring:message code='exam.label.usernm' />",    				name:'userNm',        	align:'center',   	width:'5000'},/* 성명 */
			    {label:"<spring:message code='exam.label.exam.stare.type' />", 	 		name:'examStareTypeNm', align:'center',   	width:'5000'},/* 시험구분 */
			    {label:"<spring:message code='exam.label.crs.nm' />",  					name:'crsCreNm',   		align:'left',   	width:'10000'},/* 교과목명 */
			    {label:"<spring:message code='exam.label.crs.dept' />",    				name:'crsDeptNm',  	   	align:'left',    	width:'5000'},/* 관장학과 */
			    {label:"<spring:message code='crs.label.crs.cd' />",    				name:'crsCd',        	align:'left',  		width:'8000'},/* 학수번호 */
			    {label:"<spring:message code='crs.label.decls' />",  					name:'declsNo',    		align:'center',   	width:'5000'},/* 분반 */
			    {label:"<spring:message code='exam.label.replace.target.yn' />", 		name:'apprStat',		align:'center',   	width:'5000', codes:{APPROVE: "Y"}, defaultValue: "N"},/* 대체과제대상여부 */
			    {label:"<spring:message code='exam.label.replace.grant.yn' />", 		name:'examSubsYn',		align:'center',   	width:'5000'},/* 대체과제부여여부 */
			    {label:"<spring:message code='exam.label.real.time.exam.answer.yn' />", name:'examStareYn', 	align:'center',   	width:'5000'},/* 실시간시험응시여부 */
			    {label:"<spring:message code='exam.label.process.dttm' />", 	 		name:'modDttm', 		align:'center',   	width:'5000'},/* 처리일시 */
			    {label:"<spring:message code='exam.label.process.manage' />", 	 		name:'modNm', 			align:'center',   	width:'5000'},/* 처리담당자 */
			]
		};
		
		var kvArr = [];
		kvArr.push({'key' : 'creYear', 		   'val' : $("#creYear").val()});
		kvArr.push({'key' : 'creTerm', 	 	   'val' : $("#creTerm").val()});
		kvArr.push({'key' : 'univGbn', 	 	   'val' : $("#univGbn").val()});
		kvArr.push({'key' : 'deptCd', 	 	   'val' : $("#deptCd").val()});
		kvArr.push({'key' : 'examStareTypeCd', 'val' : $("#examStareTypeCd").val()});
		kvArr.push({'key' : 'apprStat', 	   'val' : $("#apprStat").val()});
		kvArr.push({'key' : 'userId', 	   	   'val' : $("#searchUserId").val()});
		kvArr.push({'key' : 'userNm', 	       'val' : $("#searchUserNm").val()});
		kvArr.push({'key' : 'searchValue', 	   'val' : $("#searchValue").val()});
		kvArr.push({'key' : 'excelGrid',   	   'val' : JSON.stringify(excelGrid)});
		
		submitForm("/exam/examMgr/examAbsentExcelDown.do", "", "", kvArr);
	}
	
	// 신청이력 팝업
	function applicateHstyPop(userId) {
		var kvArr = [];
		kvArr.push({'key' : 'userId', 'val' : userId});
		
		submitForm("/exam/examMgr/examAbsentApplyHstyPop.do", "examPopIfm", "absentApplHsty", kvArr);
	}
	
	// 전체 선택 / 해제
    function checkAllAbsentToggle(obj) {
        $("input:checkbox[name=evalChk]").prop("checked", $(obj).is(":checked"));

        $('input:checkbox[name=evalChk]').each(function (idx) {
            if ($(obj).is(":checked")) {
                addSelectedAbsent($(this).attr("data-examAbsentCd"));
            } else {
                removeSelectedAbsent($(this).attr("data-examAbsentCd"));
            }
        });
        
        viewExamAbsent();
    }

    // 한건 선택 / 해제
    function checkAbsentToggle(obj) {
        if ($(obj).is(":checked")) {
        	addSelectedAbsent($(obj).attr("data-examAbsentCd"));
        } else {
        	removeSelectedAbsent($(obj).attr("data-examAbsentCd"));
        }
        var totChkCnt = $("input:checkbox[name=evalChk]").length;
        var chkCnt = $("input:checkbox[name=evalChk]:checked").length;
        if(totChkCnt == chkCnt) {
        	$("input:checkbox[name=allEvalChk]").prop("checked", true);
        } else {
        	$("input:checkbox[name=allEvalChk]").prop("checked", false);
        }
        viewExamAbsent();
    }

    // 선택된 학습자 번호 추가
    function addSelectedAbsent(examAbsentCd) {
        var selectedAbsent = $("#examAbsentCds").val();
        if (selectedAbsent.indexOf(examAbsentCd) == -1) {
            if (selectedAbsent.length > 0) {
            	selectedAbsent += ',';
            }
            selectedAbsent += examAbsentCd;
            $("#examAbsentCds").val(selectedAbsent);
        }
    }

    // 선택된 학습자 번호 제거
    function removeSelectedAbsent(examAbsentCd) {
        var selectedAbsent = $("#examAbsentCds").val();
        if (selectedAbsent.indexOf(examAbsentCd) > -1) {
        	selectedAbsent = selectedAbsent.replace(examAbsentCd, "");
        	selectedAbsent = selectedAbsent.replace(",,", ",");
        	selectedAbsent = selectedAbsent.replace(/^[,]*/g, '');
        	selectedAbsent = selectedAbsent.replace(/[,]*$/g, '');
            $("#examAbsentCds").val(selectedAbsent);
        }
    }
    
 	// 사용자 검색
	function selectUserList() {
		var kvArr = [];
		kvArr.push({'key' : 'userId', 	  'val' : ""});
		kvArr.push({'key' : 'userNm', 	  'val' : ""});
		kvArr.push({'key' : 'goUrl', 	  'val' : ""});
		kvArr.push({'key' : 'subParam',   'val' : "searchUser|examPopIfm|examPop"});
		kvArr.push({'key' : 'searchMenu', 'val' : ""});
		
		submitForm("/user/userMgr/studentSearchListPop.do", "examPopIfm", "stdSearch", kvArr);
	}
 	
	//사용자 정보 팝업
 	function userInfoPop(userId) {
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
		
		$.each($('#examAbsentList').find("input:checkbox[name=evalChk]:not(:disabled):checked"), function() {
			isSelected = true;
			return false;
		});
		
		if(!isSelected) {
			/* 메시지 발송 대상자를 선택하세요. */
			alert("<fmt:message key='common.alert.sysmsg.select_user'/>");
			return;
		}
		
 		var dupCheckObj = {};
 		
 		if(sendType == "PROFESSOR" || sendType == "ASSISTANT") {
 			var crsCreCdList = [];
 			
 			$.each($('#examAbsentList').find("input:checkbox[name=evalChk]:not(:disabled):checked"), function() {
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
 			
 			$.each($('#examAbsentList').find("input:checkbox[name=evalChk]:not(:disabled):checked"), function() {
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
 				alert("<fmt:message key='common.alert.sysmsg.select_user'/>");
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
 	
	// 결시원 신청 내역 팝업
	function viewExamAbsentPop(stdNo, crsCreCd, examAbsentCd) {
		var kvArr = [];
		kvArr.push({'key' : 'stdNo',		'val' : stdNo});
		kvArr.push({'key' : 'crsCreCd', 	'val' : crsCreCd});
		kvArr.push({'key' : 'examAbsentCd', 'val' : examAbsentCd});
		
		submitForm("/exam/examAbsentViewPop.do", "examPopIfm", "absent", kvArr);
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
					        <small class="section">
					        	<c:choose>
					        		<c:when test="${type eq 'approve'}">
					        			<spring:message code="exam.label.absent.approve" /><!-- 결시원 승인-->
					        		</c:when>
					        		<c:otherwise>
					        			<spring:message code="exam.label.absent.reg" /><!-- 결시원등록-->
					        		</c:otherwise>
					        	</c:choose>
					        </small>
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
								<%-- <option value="${item.codeCd }" <c:if test="${item.codeCd eq '20'}">selected</c:if>>${item.codeNm }</option> --%>
								
							</c:forEach>
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
                    	<c:choose>
                    		<c:when test="${type eq 'add' }">
		                    	<select class="ui dropdown" id="examStareTypeCd" onchange="listExamAbsent()">
		                    		<option value=""><spring:message code="exam.label.exam.stare.type" /><!-- 시험구분 --></option>
		                    		<option value="ALL"><spring:message code="exam.common.search.all" /><!-- 전체 --></option>
		                    		<option value="M"><spring:message code="exam.label.mid.exam" /><!-- 중간고사 --></option>
		                    		<option value="L"><spring:message code="exam.label.end.exam" /><!-- 기말고사 --></option>
		                    	</select>
		                    	<select class="ui dropdown" id="apprStat" onchange="listExamAbsent()">
		                    		<option value=""><spring:message code="exam.label.approve.yn" /><!-- 승인여부 --></option>
		                    		<option value="ALL"><spring:message code="exam.common.search.all" /><!-- 전체 --></option>
		                    		<option value="APPLICATE"><spring:message code="exam.label.applicate" /><!-- 신청 --></option>
		                    		<option value="APPROVE"><spring:message code="exam.label.approve" /><!-- 승인 --></option>
		                    		<option value="COMPANION"><spring:message code="exam.label.companion" /><!-- 반려 --></option>
		                    	</select>
                    		</c:when>
                    		<c:otherwise>
                    			<div class="mla">
                    				<input type="text" readonly="readonly" value="${userId }" class="w150 bcLgrey" />
                    				<input type="text" readonly="readonly" value="${userNm }" class="w150 bcLgrey" />
                    			</div>
                    		</c:otherwise>
                    	</c:choose>
                    </div>
                    <div class="ui segment searchArea">
                    	<c:choose>
	                    	<c:when test="${type eq 'approve' }">
	                    		<select class="ui dropdown" id="examStareTypeCd" onchange="listExamAbsent()">
				                   	<option value=""><spring:message code="exam.label.exam.stare.type" /><!-- 시험구분 --></option>
				                   	<option value="ALL"><spring:message code="exam.common.search.all" /><!-- 전체 --></option>
				                   	<option value="M"><spring:message code="exam.label.mid.exam" /><!-- 중간고사 --></option>
				                   	<option value="L"><spring:message code="exam.label.end.exam" /><!-- 기말고사 --></option>
				                </select>
				                <select class="ui dropdown" id="apprStat" onchange="listExamAbsent()">
				                   	<option value=""><spring:message code="exam.label.approve.yn" /><!-- 승인여부 --></option>
				                   	<option value="ALL"><spring:message code="exam.common.search.all" /><!-- 전체 --></option>
				                   	<option value="APPLICATE"><spring:message code="exam.label.applicate" /><!-- 신청 --></option>
				                   	<option value="APPROVE"><spring:message code="exam.label.approve" /><!-- 승인 --></option>
				                   	<option value="COMPANION"><spring:message code="exam.label.companion" /><!-- 반려 --></option>
				                </select>
								<input type="text" placeholder="<spring:message code="user.message.search.input.crscd.crsnm" />" class="w200" id="searchValue"><!-- 과목명/학수번호 입력-->
								<div class="ui action input search-box" id="searchProfessor">
					                <input type="text" name="userId" placeholder="<spring:message code='exam.label.tch.no' />" class="w150 bcLgrey" autocomplete="off" /><!-- 사번 -->
					                <input type="text" name="userNm" placeholder="<spring:message code='exam.label.tch.nm' />" class="w150 bcLgrey" autocomplete="off" /><!-- 교수명 -->
								    <button class="ui icon button" onclick="selectProfessorList(1)"><i class="search icon"></i></button>
								</div>
								<div class="ui action input search-box" id="searchUser">
									<input type="text" id="searchUserId" name="userId" placeholder="<spring:message code='exam.label.user.no' />" class="w150 ml10 bcLgrey" autocomplete="off" /><!-- 학번 -->
							        <input type="text" id="searchUserNm" name="userNm" placeholder="<spring:message code='exam.label.user.nm' />" class="w100 bcLgrey" autocomplete="off" /><!-- 이름 -->
								    <button class="ui icon button" onclick="selectUserList()"><i class="search icon"></i></button>
								</div>
	                    	</c:when>
	                    	<c:otherwise>
								<input type="text" placeholder="<spring:message code="user.message.search.input.crscd.crsnm.userid.name" />" class="w400" id="searchValue"><!-- 과목명/학수번호/학번/이름 입력 -->
								<div class="ui action input search-box" id="searchProfessor">
					                <input type="text" name="userId" placeholder="<spring:message code='exam.label.tch.no' />" class="w150 bcLgrey" autocomplete="off" /><!-- 사번 -->
					                <input type="text" name="userNm" placeholder="<spring:message code='exam.label.tch.nm' />" class="w150 bcLgrey" autocomplete="off" /><!-- 교수명 -->
								    <button class="ui icon button" onclick="selectProfessorList(1)"><i class="search icon"></i></button>
								</div>
	                    	</c:otherwise>
                    	</c:choose>
						<div class="button-area mt10 tc">
					    	<button class="ui blue button w100" onclick="listExamAbsent()"><spring:message code="exam.button.search" /><!-- 검색 --></button>
						</div>
                    </div>
       				<div class="option-content gap4">
       					<h3 class="sec_head">
       						<c:choose>
				        		<c:when test="${type eq 'approve'}">
				        			<spring:message code="exam.label.exam.absent.status" /><!-- 결시원 현황 -->
				        		</c:when>
				        		<c:otherwise>
				        			<spring:message code="exam.label.absent.reg" /><!-- 결시원등록-->
				        		</c:otherwise>
				        	</c:choose>
   						</h3>
       					<span class="pl10">[ <spring:message code="exam.label.total.cnt" /><!-- 총 건수 --> : <label id="examAbsentCnt"></label> ]</span>
       					<div class="mla">
       						<select class="ui dropdown" id="sendType">
       							<option value=""><spring:message code="exam.label.receive.target" /><!-- 수신대상 --></option>
						        <option value="STUDENT"><spring:message code="exam.label.student" /><!-- 학생 --></option>
						        <option value="PROFESSOR"><spring:message code="exam.label.manage.professor" /><!-- 담당교수 --></option>
						        <option value="ASSISTANT"><spring:message code="exam.label.manage.assistant" /><!-- 담당조교 --></option>
						    </select>
       						<uiex:msgSendBtn func="sendMsg()" styleClass="ui basic button"/><!-- 메시지 -->
       						<a class="ui basic button" href="javascript:absentAllCompanion()" title="해당 학기 결시원 제출한 모든 학생 결시원 상태를 반려로 변경하는 기능"><spring:message code="exam.label.absent.clean" /><!-- 결시원 정리 --></a>
       						<a class="ui basic button" href="javascript:absentRequest('APPROVE')"><spring:message code="exam.label.approve" /><!-- 승인 --></a>
       						<a class="ui basic button" href="javascript:absentRequest('COMPANION')"><spring:message code="exam.label.companion" /><!-- 반려 --></a>
       						<c:if test="${type eq 'add' }">
        						<a class="ui orange button" href="javascript:addAbsentPop()"><spring:message code="exam.button.add" /><!-- 추가 --></a>
       						</c:if>
       						<a class="ui green button" href="javascript:examAbsentExcelDown()"><spring:message code="exam.button.excel.down" /><!-- 엑셀 다운로드 --></a>
       					</div>
       				</div>
       				<div class="footable_box type2 max-height-550">
		        		<table class="table type2" data-empty="<spring:message code='exam.common.empty' />" id="examAbsentTable" data-sorting="true"><!-- 등록된 내용이 없습니다. -->
		        			<thead class="sticky top0">
		        				<tr>
		        					<th class="tc p_w3">
		        						<div class="ui checkbox">
											<input type="hidden" id="examAbsentCds" name="examAbsentCds">
								            <input type="checkbox" name="allEvalChk" id="allChk" value="all" onchange="checkAllAbsentToggle(this)">
								            <label class="toggle_btn" for="allChk"></label>
								        </div>
		        					</th>
		        					<th class="tc p_w3"><spring:message code="main.common.number.no" /><!-- NO. --></th>
		        					<th class="tc p_w5"><spring:message code="exam.label.dept" /><!-- 학과 --></th>
		        					<th class="tc p_w10"><spring:message code="exam.label.user.no" /><!-- 학번 --></th>
		        					<th class="tc p_w10"><spring:message code="exam.label.user.nm" /><!-- 이름 --></th>
		        					<th class="tc p_w15"><spring:message code="crs.label.crecrs.nm" /><!-- 과목명 --></th>
		        					<th class="tc p_w15"><spring:message code="crs.label.crs.cd" /><!-- 학수번호 --></th>
		        					<th class="tc p_w3"><spring:message code="crs.label.decls" /><!-- 분반 --></th>
		        					<th class="tc p_w10"><spring:message code="common.label.prof.nm" /><!-- 교수명 --></th>
								 	<th class="tc p_w10"><spring:message code="common.label.prof.no" /><!-- 교수사번 --></th>
								 	<th class="tc p_w10"><spring:message code="common.label.tutor.nm" /><!-- 튜터명 --></th>
								 	<th class="tc p_w10"><spring:message code="common.label.tutor.no" /><!-- 튜터사번 --></th>
		        					<th class="tc p_w5"><spring:message code="exam.label.process.status" /><!-- 처리상태 --></th>
		        					<th class="tc p_w10"><spring:message code="exam.label.applicate.dttm" /><!-- 신청일시 --></th>
		        					<th class="tc p_w10"><spring:message code="exam.label.exam.stare.type" /><!-- 시험구분 --></th>
		        					<th class="tc p_w10"><spring:message code="exam.label.replace.target.yn" /><!-- 대체과제대상여부 --></th>
		        					<th class="tc p_w10"><spring:message code="exam.label.replace.grant.yn" /><!-- 대체과제부여여부 --></th>
		        					<th class="tc p_w10"><spring:message code="exam.label.real.time.exam.answer.yn" /><!-- 실시간시험응시여부 --></th>
		        					<th class="tc p_w10"><spring:message code="exam.label.process.dttm" /><!-- 처리일시 --></th>
		        					<th class="tc p_w10"><spring:message code="exam.label.process.manage" /><!-- 처리담당자 --></th>
		        				</tr>
		        			</thead>
		        			<tbody id="examAbsentList">
		        			</tbody>
		        		</table>
	        		</div>
	        		<div id="viewAbsentDiv" class="mt20">
	        		</div>
        		</div>
			</div>
        </div>
        <!-- //본문 content 부분 -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
    </div>
    <form id="absentAddForm" method="POST">
		<input type="hidden" name="userId" />
		<input type="hidden" name="userNm" />
		<input type="hidden" name="creYear" />
		<input type="hidden" name="creTerm" />
		<input type="hidden" name="goUrl" value="/exam/examMgr/addExamAbsentPop.do" />
		<input type="hidden" name="subParam" value="absentAddForm|examPopIfm|examPop" />
		<input type="hidden" name="searchMenu" value="popup" />
		<input type="hidden" name="searchType" value="MANAGER" />
	</form>
</body>
</html>