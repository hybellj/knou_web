<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    </head>
    
    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	
	<script type="text/javascript" src="/webdoc/js/iframe.js"></script>
	<script type="text/javascript">
		var USER_DEPT_LIST;
		var CRS_CRE_LIST;
	
		$(document).ready(function() {
			// 실시간 시험 재시험 등록현황 목록
			getReExamConfigStatusList();
			
			// 부서 목록 조회	
			getUserDeptList();
			
			// 과목 목록 조회
			getCrsCreList();
		});
		
		// 실시간 시험 재시험 등록현황 목록
		function getReExamConfigStatusList() {
			var deferred = $.Deferred();
			
			var url = "/exam/examMgr/reExamConfigStatusList.do";
			var param = {
				  haksaYear			: $("#haksaYear").val()
				, haksaTerm			: $("#haksaTerm").val()
			};
			
			ajaxCall(url, param, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					var pageInfo = data.pageInfo;
					var html = '';
					
					returnList.forEach(function(v, i) {
						var reExamStartDttmFmt = (v.reExamStartDttm || "").length == 14 ? v.reExamStartDttm.substring(0, 4) + '.' + v.reExamStartDttm.substring(4, 6) + '.' + v.reExamStartDttm.substring(6, 8) + ' ' + v.reExamStartDttm.substring(8, 10) + ':' + v.reExamStartDttm.substring(10, 12) : (v.reExamStartDttm || "");
						
						var uniNm = "-";
						
						if(v.uniCd == "C") {
							uniNm = '<spring:message code="common.label.uni.college" />'; // 대학교
						} else if(v.uniCd == "G") {
							uniNm = '<spring:message code="common.label.uni.graduate" />'; // 대학원
						}
						
						var examStareTypeNm = "-";
						
						if(v.examStareTypeCd == "M") {
							examStareTypeNm = '<spring:message code="exam.label.mid.exam" />'; // 중간고사
						} else if(v.examStareTypeCd == "L") {
							examStareTypeNm = '<spring:message code="exam.label.end.exam" />'; // 기말고사
						}
						
						html += '<tr>';
						html += '	<td>' + (i + 1) + '</td>';
						html += '	<td>' + uniNm + '</td>';
						html += '	<td>' + examStareTypeNm + '</td>';
						html += '	<td>' + reExamStartDttmFmt + '</td>';
						html += '	<td>' + (v.reExamStareTm || '0') + '<spring:message code="exam.label.min.time" /></td>'; // 분 
						html += '	<td>' + (v.dsblAddTm || '0') + '<spring:message code="exam.label.min.time" /></td>'; // 분 
						html += '	<td>' + v.deptNm + '</td>';
						html += '	<td>' + v.crsCd + '</td>';
						html += '	<td>' + v.crsCreNm + '</td>';
						html += '	<td>' + v.declsNo + '</td>';
						html += '	<td>' + (v.userNm || '') + '</td>';
						html += '	<td><a class="fcBlue" href="javascript:reExamConfigDetailPop(\'' + v.crsCreCd + '\', \'' + v.examCd + '\')">' + v.reExamStdCnt + '<spring:message code="exam.label.nm" /></a></td>'; // 명
						html += '	<td>';
						html += '		<a href="javascript:updateReExamStareForm(\'' + v.examStareTypeCd + '\', \'' + v.uniCd + '\', \'' + v.deptCd + '\', \'' + v.crsCreCd + '\')" class="ui basic small button"><spring:message code="common.button.modify" /></a>'; // 수정
						html += '		<a href="javascript:deleteReExamStare(\'' + v.crsCreCd + '\', \'' + v.examStareTypeCd + '\')" class="ui basic small button"><spring:message code="common.button.delete" /></a>'; // 삭제
						html += '	</td>';
						html += '</tr>';
					});
					
					$("#reExamConfigStatusList").html(html);
					$("#reExamConfigStatusTable").footable();
	        	} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		}
		
		// 미응시자 목록
		function reExamStdList() {
			if(!$("#uniCd").val()) {
				var arguments = '<spring:message code="exam.label.org.type" />'; // 대학구분
				alert('<spring:message code="exam.alert.select" arguments="' + arguments + '" />'); // {0}을 선택하세요.
				return;
			}
			
			if(!$("#deptCd").val()) {
				var arguments = '<spring:message code="exam.label.dept" />'; // 학과
				alert('<spring:message code="exam.alert.select" arguments="' + arguments + '" />'); // {0}을 선택하세요.
				return;
			}
			
			if(!$("#crsCreCd").val()) {
				var arguments = '<spring:message code="common.subject" />'; // 과목
				alert('<spring:message code="exam.alert.select" arguments="' + arguments + '" />'); // {0}을 선택하세요.
				return;
			}
			
			var examStareTypeCd = $("input[name='examStareTypeCd']:checked").val();
			
			var url = "/exam/examMgr/reExamStdList.do";
			var param = {
				  haksaYear		: $("#haksaYear").val()
				, haksaTerm		: $("#haksaTerm").val()
			 	, uniCd				: $("#uniCd").val()
				, deptCd			: $("#deptCd").val()
				, crsCreCd			: $("#crsCreCd").val()
				, apprStat			: $("#apprStat").val().trim()
				, examStareTypeCd	: examStareTypeCd
			};
			
			ajaxCall(url, param, function(data) {
				if(data.result > 0) {
					var examVO = data.returnVO;
					
					// 재시험 등록되어 있는 경우 form정보 세팅
					if(examVO && examVO.reExamYn == "Y") {
						var reExamStartDttm = examVO.reExamStartDttm;
						var ymd = reExamStartDttm.substring(0, 4) + "." + reExamStartDttm.substring(4, 6) + "." + reExamStartDttm.substring(6, 8);
						var hh = reExamStartDttm.substring(8, 10);
						var mm = reExamStartDttm.substring(10, 12);
						
						$("#reExamStartDttmYMD").val(ymd);
						$("#reExamStartDttmHH").dropdown("set value", hh);
						$("#reExamStartDttmMM").dropdown("set value", mm);
						
						$("#reExamStareTm").val("" + examVO.reExamStareTm);
						$("#dsblAddTm").val("" + examVO.dsblAddTm);
					}
					
					var returnList = data.returnList || [];
					var pageInfo = data.pageInfo;
					
					returnList = returnList.sort(function(a, b) {
						if(a.deptNm < b.deptNm) return -1;
						if(a.deptNm > b.deptNm) return 1;
						if(a.deptNm == b.deptNm) {
							if(a.userNm < b.userNm) return -1;
							if(a.userNm > b.userNm) return 1;
						}
						return 0;
					});
					
					var html = '';
					
					returnList.forEach(function(v, i) {
						var uniNm = "-";
						
						if(v.uniCd == "C") {
							uniNm = '<spring:message code="common.label.uni.college" />'; // 대학교
						} else if(v.uniCd == "G") {
							uniNm = '<spring:message code="common.label.uni.graduate" />'; // 대학원
						}
						
						var examStareTypeNm = "-";
						
						if(v.examStareTypeCd == "M") {
							examStareTypeNm = '<spring:message code="exam.label.mid.exam" />'; // 중간고사
						} else if(v.examStareTypeCd == "L") {
							examStareTypeNm = '<spring:message code="exam.label.end.exam" />'; // 기말고사
						}
						
						html += '<tr>';
						html += '	<td>';
						html += '		<div class="ui checkbox">';
						html += '			<input type="checkbox" name="stdNos" value="' + v.stdNo + '" data-exam-cd="' + v.examCd + '" data-crs-cre-cd="' + v.crsCreCd + '" data-user-no="' + v.userId + '" data-user-nm="' + v.userNm + '" data-email="' + v.email + '" data-mobile-no="' + v.mobileNo + '" ' + (v.reExamYn == "Y" ? 'checked' : '') + ' />';
						html += '		</div>';
						html += '	</td>';
						html += '	<td>' + (i + 1) + '</td>';
						html += '	<td>' + uniNm + '</td>';
						html += '	<td>' + examStareTypeNm + '</td>';
						html += '	<td>' + v.deptNm + '</td>';
						html += '	<td>' + v.userId + '</td>';
						html += '	<td>' + v.userNm + '</td>';
						html += '	<td>' + v.crsCd + '</td>';
						html += '	<td>' + v.declsNo + '</td>';
						html += '	<td>' + v.crsCreNm + '</td>';
						html += '	<td>' + v.tchNm + '</td>';
						html += '</tr>';
					});
					
					$("#reExamStdList").html(html);
					$("#reExamStdTable").footable();
					$("#reExamStdTable").find(".ui.checkbox").checkbox();
		    			
					$("#totalCntText").text(returnList.length);
	        	} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		}
		
		// 전체 선택
		function checkAll(checked) {
			$('#reExamStdList').find("input:checkbox[name=stdNos]:not(:disabled)").prop("checked", checked);
		}
		
		// 부서 목록 조회
		function getUserDeptList() {
			var url = "/user/userMgr/deptList.do";
			var data = {
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					
					USER_DEPT_LIST = returnList.sort(function(a, b) {
						if(a.deptNm < b.deptNm) return -1;
						if(a.deptNm > b.deptNm) return 1;
						return 0;
					});
	        	} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			});
		}
		
		// 과목 목록 조회
		function getCrsCreList() {
			var url = "/crs/creCrsMgr/listCrsCre.do";
			var data = {
				  creYear	: $("#haksaYear").val()
				, creTerm	: $("#haksaTerm").val()
				, uniCd 	: ""
				, useYn		: "Y"
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					
					CRS_CRE_LIST = returnList.sort(function(a, b) {
						if(a.crsCreNm < b.crsCreNm) return -1;
						if(a.crsCreNm > b.crsCreNm) return 1;
						if(a.crsCreNm == b.crsCreNm) {
							if(a.declsNo < b.declsNo) return -1;
							if(a.declsNo > b.declsNo) return 1;
						}
						return 0;
					});
	        	} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			});
		}
		
		// 대학 구분 변경
		function changeUniCd(uniCd) {
			var uniCd = uniCd;
			var deptCdObj = {};
			
			CRS_CRE_LIST.forEach(function(v, i) {
				if(v.uniCd == uniCd && v.deptCd) {
					deptCdObj[v.deptCd] = true;
				}
			});
			
			var html = '';
			USER_DEPT_LIST.forEach(function(v, i) {
				if(deptCdObj[v.deptCd]) {
					html += '<option value="' + v.deptCd + '">' + v.deptNm + '</option>';
				}
			});
			
			// 부서 초기화
			$("#deptCd").off("change");
			$("#deptCd").html(html);
			$("#deptCd").dropdown("clear");
			$("#deptCd").on("change", function() {
				changeDeptCd(this.value);
			});
			
			// 학과 초기화
			$("#crsCreCd").empty();
			$("#crsCreCd").dropdown("clear");
		}
		
		// 학과 변경
		function changeDeptCd(deptCd) {
			var uniCd = $("#uniCd").val();
			var html = '<option value=" "><spring:message code="common.all" /></option>'; // 전체
			
			CRS_CRE_LIST.forEach(function(v, i) {
				if(v.uniCd == uniCd && v.deptCd == deptCd) {
					var declsNo = v.declsNo;
					declsNo = '(' + declsNo + ')';
					
					html += '<option value="' + v.crsCreCd + '">' + v.crsCreNm + declsNo + '</option>';
				}
			});
			
			$("#crsCreCd").html(html);
			$("#crsCreCd").dropdown("clear");
		}
		
		// 미응시자 재시험 등록
		function saveReExamStare() {
			var examCd;
			var crsCreCd;
			var stdNoList = [];
			
			$.each($('#reExamStdList').find("input:checkbox[name=stdNos]:not(:disabled):checked"), function() {
				examCd = $(this).data("examCd");
				crsCreCd = $(this).data("crsCreCd");
				
				stdNoList.push(this.value);
			});
			
			if(stdNoList.length == 0) {
				alert('<spring:message code="exam.error.reexam.select.std" />'); // 재응시 설정할 학습자를 선택해주세요.
				return;
			}
			
			var reExamStartDttmYMD = $("#reExamStartDttmYMD").val();
			var reExamStartDttmHH = $("#reExamStartDttmHH").val();
			var reExamStartDttmMM = $("#reExamStartDttmMM").val();
			
			if(!reExamStartDttmYMD) {
				var arguments = '<spring:message code="exam.label.re.exam.dttm" />'; // 재시험 일시
				alert('<spring:message code="common.alert.input.eval_date" arguments="' + arguments + '" />'); // 날짜를 입력하세요.
				return;
			}
			
			if(!reExamStartDttmYMD) {
				var arguments = '<spring:message code="exam.label.re.exam.dttm" />'; // 재시험 일시
				alert('<spring:message code="common.alert.input.eval_hour" arguments="' + arguments + '" />'); // 시간을 입력하세요.
				return;
			}
						
			if(!reExamStartDttmYMD) {
				var arguments = '<spring:message code="exam.label.re.exam.dttm" />'; // 재시험 일시
				alert('<spring:message code="common.alert.input.eval_min" arguments="' + arguments + '" />'); // 분을 입력하세요.
				return;
			}
			
			var rsrvDttm = reExamStartDttmYMD.replaceAll('.','-')+ ' ' + reExamStartDttmHH + ":" + reExamStartDttmMM;
			rsrvDttm = replaceDateToDttm(rsrvDttm);
			
			if(!$("#reExamStareTm").val()) {
				var arguments = '<spring:message code="exam.label.exam.time" />'; // 시험기간
				alert('<spring:message code="exam.alert.input" arguments="' + arguments + '" />'); // 을(를) 입력하세요.
				$("#reExamStareTm").focus();
				return;
			}
			
			var url = "/exam/examMgr/setReExamStare.do";
			var data = {
				  searchKey			: 'insert'
				, crsCreCd			: crsCreCd
				, examCd			: examCd
				, examStareTypeCd 	: $("input[name='examStareTypeCd']:checked").val()
				, stdNos			: stdNoList.join(",")
				, reExamStartDttm	: rsrvDttm
				, reExamStareTm		: 1 * $("#reExamStareTm").val()
				, dsblAddTm			: 1 * ($("#dsblAddTm").val() || 0)
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					alert('<spring:message code="exam.alert.reexam" />'); // 재응시 설정이 완료되었습니다.
					
					// 실시간 시험 재시험 등록현황 목록
					getReExamConfigStatusList();
	        	} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				alert('<spring:message code="exam.error.reexam" />'); // 재응시 설정 중 에러가 발생하였습니다.
			}, true);
		}
		
		// 미응시자 재시험 폼 세팅
		function updateReExamStareForm(examStareTypeCd, uniCd, deptCd, crsCreCd) {
			$("input:radio[name='examStareTypeCd']:radio[value='" + examStareTypeCd + "']").prop('checked', true);
			$("#apprStat").dropdown("clear");
			
			$("#uniCd").dropdown("set value", uniCd);
			
			setTimeout(function() {
				$("#deptCd").dropdown("set value", deptCd);
				
				setTimeout(function() {
					$("#crsCreCd").dropdown("set value", crsCreCd);
					
					setTimeout(function() {
						reExamStdList();
					}, 0);
				}, 0);
			}, 0);
		}
		
		// 미응시자 재시험 삭제
		function deleteReExamStare(crsCreCd, examStareTypeCd) {
			var arguments = '<spring:message code="exam.label.re.exam" />'; // 학과
			if(!confirm('<spring:message code="common.confirm.remove" arguments="' + arguments + '" />')) return; // 을(를) 삭제하시겠습니까?
			
			var url = "/exam/examMgr/setReExamStare.do";
			var data = {
				  searchKey				: 'delete'
				, crsCreCd					: crsCreCd
				, examStareTypeCd	: examStareTypeCd
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					alert('<spring:message code="success.common.delete" />'); // 정상적으로 삭제되었습니다.
					
					// 실시간 시험 재시험 등록현황 목록
					getReExamConfigStatusList();
					
					// 미응시자 재시험 등록 입력 폼 초기화
					resetWriteForm();
					
					// 미응시자 목록 초기화
					resetReExamStdList()
	        	} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		}
		
		// 미응시자 재시험 등록 입력 폼 초기화
		function resetWriteForm() {
			$("#reExamStartDttmYMD").val("");
			$("#reExamStartDttmHH").dropdown("clear");
			$("#reExamStartDttmMM").dropdown("clear");
			$("#reExamStareTm").val("");
			$("#dsblAddTm").val("");
		}
		
		// 미응시자 목록 초기화
		function resetReExamStdList() {
			$("#crsCreCd").dropdown("clear");
			$("#deptCd").dropdown("clear");
			$("#uniCd").dropdown("clear");
			$("#apprStat").dropdown("clear");
			
			$("#reExamStdList").html('');
			$("#reExamStdTable").footable();
    			
			$("#totalCntText").text("0");
		}
		
		// 시험구분 변경
		function changeExamStareTypeCd() {
			// 미응시자 재시험 등록 입력 폼 초기화
			resetWriteForm()
			// 미응시자 목록 초기화
			resetReExamStdList();
		}
		
		// 보내기
	   	function sendMsg() {
			var rcvUserInfoStr = "";
			var sendCnt = 0;
			
			$.each($('#reExamStdList').find("input:checkbox[name=stdNos]:not(:disabled):checked"), function() {
				var userId = $(this).data("userId");
				var userNm = $(this).data("userNm");
				var mobileNo = $(this).data("mobileNo");
				var email = $(this).data("email");
				
				sendCnt++;
				
				if (sendCnt > 1)
					rcvUserInfoStr += "|";
				rcvUserInfoStr += userId;
				rcvUserInfoStr += ";" + userNm;
				rcvUserInfoStr += ";" + mobileNo;
				rcvUserInfoStr += ";" + email;
			});
			
			if(sendCnt == 0) {
				alert('<spring:message code="std.alert.no_select_user" />'); // 선택된 사용자가 없습니다.
	 			return;
			}
			
			var form = window.parent.alarmForm;
			form.action = '<%=CommConst.SYSMSG_URL_SEND%>';
	        form.target = "msgWindow";
	        form[name='alarmType'].value = "S"; // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
	        form[name='rcvUserInfoStr'].value = rcvUserInfoStr; //보내는사람 정보
	        form.onsubmit = window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");
	        form.submit();
	   	}
		
		// 재시험 등록관리 상세 팝업
		function reExamConfigDetailPop(crsCreCd, examCd) {
	   		$("#reExamConfigDetailForm > input[name='haksaYear']").val('<c:out value="${haksaYear}" />');
	   		$("#reExamConfigDetailForm > input[name='haksaTerm']").val('<c:out value="${haksaTerm}" />');
	   		$("#reExamConfigDetailForm > input[name='crsCreCd']").val(crsCreCd);
	   		$("#reExamConfigDetailForm > input[name='examCd']").val(examCd);
	   		
			$("#reExamConfigDetailForm").attr("target", "reExamConfigDetailIfm");
	        $("#reExamConfigDetailForm").attr("action", "/exam/examMgr/reExamConfigDetailPop.do");
	        $("#reExamConfigDetailForm").submit();
	        $("#reExamConfigDetailModal").modal('show');
		}
		
		function replaceDateToDttm(date) {
			var dt = new Date(date);
			var tmpYear = dt.getFullYear().toString();
			var tmpMonth = this.pad(dt.getMonth() + 1, 2);
			var tmpDay = this.pad(dt.getDate(), 2);
			var tmpHourr = this.pad(dt.getHours(), 2);
			var tmpMin = this.pad(dt.getMinutes(), 2);
			var tmpSec = this.pad(dt.getSeconds(), 2);
			var nowDay = tmpYear + tmpMonth + tmpDay + tmpHourr + tmpMin + tmpSec;
			return nowDay;
		}
	</script>
	
	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
        	<div class="option-content">
        		<h3 class="sec_head"><spring:message code='exam.label.re.exam.regist.status' /><!-- 재시험 등록 현황 --></h3>
        		<div class="mla">
        			<select class="ui dropdown" id="haksaYear">
                   		<option value=""><spring:message code="common.haksa.year" /><!-- 학년도 --></option>
						<option value="<c:out value="${haksaYear}" />" selected="selected"><c:out value="${haksaYear}" /></option>
                   	</select>
                   	<select class="ui dropdown" id="haksaTerm">
                   		<option value=""><spring:message code="exam.label.term" /><!-- 학기 --></option>
						<option value="<c:out value="${haksaTerm}" />" selected="selected"><c:out value="${haksaTermNm}" /></option>
                   	</select>
        		</div>
        	</div>
        	<div style="max-height: 300px; overflow: auto;">
	        	<table class="table type2" data-empty="<spring:message code='exam.common.empty' />" id="reExamConfigStatusTable"><!-- 등록된 내용이 없습니다. -->
	            	<thead>
	       				<tr>
	       					<th class=""><spring:message code="main.common.number.no" /><!-- NO. --></th>
	       					<th class="w70" data-breakpoints=""><spring:message code="exam.label.org.type" /><!-- 대학구분 --></th>
	       					<th class="w70" data-breakpoints=""><spring:message code="exam.label.exam.stare.type" /><!-- 시험구분 --></th>
	       					<th class="" data-breakpoints=""><spring:message code="exam.label.re.exam.dttm" /><!-- 재시험 일시 --></th>
	       					<th class="w60" data-breakpoints=""><spring:message code="exam.label.exam" /><br /><spring:message code="exam.label.time" /></th><!-- 시험 시간 -->
	       					<th class="w70" data-breakpoints=""><spring:message code="exam.label.dsbl" /><!-- 장애인 --><br /><spring:message code="exam.label.exam.req" /><!-- 시험지원 --></th>
	       					<th class="" data-breakpoints=""><spring:message code="exam.label.crs.dept" /><!-- 관장학과 --></th>
	       					<th class="" data-breakpoints=""><spring:message code="crs.label.crs.cd" /><!-- 학수번호 --></th>
	       					<th class="" data-breakpoints=""><spring:message code='crs.label.crecrs.nm' /><!-- 과목명 --></th>
	       					<th class="w50" data-breakpoints=""><spring:message code='crs.label.decls' /><!-- 분반 --></th>
	       					<th class="w70" data-breakpoints=""><spring:message code='exam.label.tch.rep' /><!-- 담당교수 --></th>
	       					<th class="w60" data-breakpoints=""><spring:message code='exam.label.re.exam' /><!-- 재시험 --><br /><spring:message code='exam.label.target.user' /><!-- 대상자 --></th>
	       					<th class="" data-breakpoints=""><spring:message code='common.mgr' /><!-- 관리 --></th>
	       				</tr>
	       			</thead>
	       			<tbody id="reExamConfigStatusList">
	       			</tbody>
	            </table>
            </div>
            <div class="option-content">
        		<h3 class="sec_head"><spring:message code='exam.label.re.exam.user.regist' /><!-- 미응시자 재시험 등록 --></h3>
        		<div class="mla">
        			<uiex:msgSendBtn func="sendMsg()" styleClass="ui basic small button"/><!-- 메시지 -->
        		</div>
        	</div>
            
            <div class="ui segment">
	            <ul class="tbl border-top-grey">
	                <li>
	                    <dl>
	                        <dt><label class="req"><spring:message code='exam.label.stare.year' /><!-- 응시년도 -->/<spring:message code='exam.label.term' /><!-- 학기 --></label></dt>
	                        <dd>
	                            <span class="fcBlue"><c:out value="${haksaYear}" /><spring:message code='exam.label.year' /><!-- 년 --> <c:out value="${haksaTermNm}" /></span>
	                        </dd>
	                    </dl>
	                </li>
	                <li>
	                    <dl>
	                        <dt><label class="req"><spring:message code='exam.label.exam.stare.type' /><!-- 시험구분 --></label></dt>
	                        <dd>
	                            <div class="fields">
	                                <div class="field">
	                                    <div class="ui radio checkbox checked">
	                                        <input type="radio" name="examStareTypeCd" onchange="changeExamStareTypeCd()" tabindex="0" class="hidden" value="M" checked />
	                                        <label for="scoreAplyY"><spring:message code='exam.label.mid.exam' /><!-- 중간고사 --></label>
	                                    </div>
	                                </div>
	                                <div class="field">
	                                    <div class="ui radio checkbox">
	                                        <input type="radio" name="examStareTypeCd" onchange="changeExamStareTypeCd()" tabindex="0" class="hidden" value="L" />
	                                        <label for="scoreAplyN"><spring:message code='exam.label.end.exam' /><!-- 기말고사 --></label>
	                                    </div>
	                                </div>                                                        
	                            </div>
	                        </dd>
	                    </dl>
	                </li>
	                <li>
	                    <dl>
	                        <dt><label class="req"><spring:message code='exam.label.re.exam.dttm' /><!-- 재시험 일시 --></label></dt>
	                        <dd>
	                            <div class="fields gap4">
	                                <div class="field flex">
                                        <div class="ui calendar w150 mr5" id="rsrvDttmCal" dateval="">
                                            <div class="ui input left icon">
                                                <i class="calendar alternate outline icon"></i>
                                                <input type="text" id="reExamStartDttmYMD" placeholder="<spring:message code='exam.label.start.dttm' />" autocomplete="off" readonly="readonly" />
                                            </div>
                                        </div>                                                                
                                        <select class='ui dropdown list-num flex0 mr5' id='reExamStartDttmHH' caltype='hour'>
                                        	<option value=' '><spring:message code='date.hour'/></option>
                                        </select>
                                        <select class='ui dropdown list-num flex0 mr5' id='reExamStartDttmMM' caltype='min'>
                                        	<option value=' '><spring:message code='date.minute'/></option>
                                        </select>
                                    </div>
	                            </div>
	                            <script>
	                            	initCalendar();
	                            </script>
	                        </dd>
	                    </dl>
	                </li>
	                <li>
	                    <dl>
	                        <dt><label class="req"><spring:message code='exam.label.exam.time'/></label></dt><!-- 시험시간 -->
	                        <dd>
	                            <div class="ui input">
                                    <input type="text" id="reExamStareTm" class="w50" maxlength="3" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" autocomplete="off" /><span class="flex-item-center ml5"><spring:message code='exam.label.min.time'/></span><!-- 분 -->
                                </div>
	                        </dd>
	                    </dl>
	                </li>
	                <li>
	                    <dl>
	                        <dt><label><spring:message code='exam.label.dsbl.req'/></label></dt><!-- 장애인 시험지원 -->
	                        <dd>
	                            <div class="ui input">
                                    <input type="text" id="dsblAddTm" class="w50" maxlength="3" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" autocomplete="off" /><span class="flex-item-center ml5"><spring:message code='exam.label.add.min'/><!-- 분 추가 --></span>
                                </div>
	                        </dd>
	                    </dl>
	                </li>
	            </ul>
	            
	            <div class="option-content mt10 mb10">
	        		<h3 class="sec_head"><spring:message code="exam.label.re.exam.user" /><!-- 미응시자 --></h3>
	        		<span class="pl10">[ <spring:message code="exam.label.total.cnt" /><!-- 총 건수 --> : <label id="totalCntText">0</label> ]</span>
	        		<div class="mla">
	        			<select class="ui dropdown" id="uniCd" onchange="changeUniCd(this.value)">
                    		<option value=""><spring:message code="exam.label.org.type" /><!-- 대학구분 --></option>
                    		<option value="C"><spring:message code="common.label.uni.college" /><!-- 대학교 --></option>
                    		<option value="G"><spring:message code="common.label.uni.graduate" /><!-- 대학원 --></option>
                    	</select>
	                   	<select class="ui dropdown w200" id="deptCd">
	                   		<option value=""><spring:message code="exam.label.crs.dept" /><!-- 관장학과 --></option>
	                   	</select>
	                   	<select class="ui dropdown w200" id="crsCreCd">
                    		<option value=""><spring:message code="common.subject" /><!-- 과목 --></option>
                    	</select>
                    	<select class="ui dropdown" id="apprStat">
                    		<option value=""><spring:message code="exam.label.exam.absent.submit.status" /><!-- 결시원 제출상태 --></option>
                    		<option value=" "><spring:message code="common.all" /><!-- 전체 --></option>
                    		<option value="APPROVE"><spring:message code="common.submission" /><!-- 제출 -->(<spring:message code="common.label.approve" />)<!-- 승인 --></option>
                    		<option value="COMPANION"><spring:message code="common.submission" /><!-- 제출 -->(<spring:message code="common.label.reject" />)<!-- 반려 --></option>
                    		<option value="APPLICATE"><spring:message code="common.submission" /><!-- 제출 -->(<spring:message code="common.label.request" />)<!-- 신청 --></option>
                    		<option value="NOAPPLICATE"><spring:message code="common.not.submission" /><!-- 미제출 --></option>
                    	</select>
						<a href="javascript:void(0)" class="ui blue button" onclick="reExamStdList()"><spring:message code="exam.button.search" /><!-- 검색 --></a>
	        		</div>
	        	</div>
	        	
	        	<div style="max-height: 260px; overflow: auto;">
		        	<table class="table type2" data-empty="<spring:message code='exam.common.empty' />" id="reExamStdTable"><!-- 등록된 내용이 없습니다. -->
		            	<thead>
		       				<tr>
		       					<th scope="col" data-sortable="false" class="chk tc">
		                            <div class="ui checkbox">
		                                <input type="checkbox" onchange="checkAll(this.checked)" />
		                            </div>
		                        </th>
		       					<th class=""><spring:message code="main.common.number.no" /><!-- NO. --></th>
		       					<th class="" data-breakpoints="xs sm"><spring:message code="exam.label.org.type" /><!-- 대학구분 --></th>
		       					<th class="" data-breakpoints="xs sm"><spring:message code="exam.label.exam.stare.type" /><!-- 시험구분 --></th>
		       					<th class="" data-breakpoints="xs sm"><spring:message code="exam.label.user.dept" /><!-- 소속학과 --></th>
		       					<th class="" data-breakpoints="xs sm"><spring:message code="exam.label.user.no" /><!-- 학번 --></th>
		       					<th class="" data-breakpoints="xs sm"><spring:message code="exam.label.user.nm" /><!-- 이름 --></th>
		       					<th class="" data-breakpoints="xs sm"><spring:message code="crs.label.crs.cd" /><!-- 학수번호 --></th>
		       					<th class="" data-breakpoints="xs sm"><spring:message code="crs.label.decls" /><!-- 분반 --></th>
		       					<th class="" data-breakpoints="xs sm"><spring:message code="crs.label.crecrs.nm" /><!-- 과목명 --></th>
		       					<th class="" data-breakpoints="xs sm"><spring:message code="exam.label.tch.rep" /><!-- 담당교수 --></th>
		       				</tr>
		       			</thead>
		       			<tbody id="reExamStdList">
		       			</tbody>
		            </table>
	            </div>
	        </div>
        	<div class="bottom-content">
        		<button type="button" class="ui blue button" onclick="saveReExamStare()"><spring:message code="exam.button.save" /><!-- 저장 --></button>
                <button type="button" class="ui basic button" onclick="window.parent.closeModal();"><spring:message code="exam.button.close" /><!-- 닫기 --></button>
            </div>
        </div>
        <!-- 재시험 등록관리 팝업 --> 
		<form id="reExamConfigDetailForm" name="reExamConfigDetailForm" method="post">
			<input type="hidden" name="haksaYear" value="" />
			<input type="hidden" name="haksaTerm" value="" />
			<input type="hidden" name="crsCreCd" value="" />
			<input type="hidden" name="examCd" value="" />
		</form>
		<div class="modal fade in" id="reExamConfigDetailModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code='exam.label.re.exam.config.pop' />" aria-hidden="false" style="display: none; padding-right: 17px;">
		    <div class="modal-dialog modal-lg" role="document">
		        <div class="modal-content">
		            <div class="modal-header">
		                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="sys.button.close" />">
		                    <span aria-hidden="true">&times;</span>
		                </button>
		                <h4 class="modal-title"><spring:message code='exam.label.re.exam.config.pop' /><!-- 재시험 등록관리 --></h4>
		            </div>
		            <div class="modal-body">
		                <iframe src="" width="100%" id="reExamConfigDetailIfm" name="reExamConfigDetailIfm"></iframe>
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
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
