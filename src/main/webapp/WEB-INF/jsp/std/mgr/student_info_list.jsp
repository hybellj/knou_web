<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!DOCTYPE html>
<html lang="ko" >
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
	var checkedObjStudent = {}; 	// 수강생 체크박스 체크정보
	var checkedObjDisablility = {}; // 장애학생 체크박스 체크정보
	
	var SEARCH_VALUE_STUDENT;		// 수강생 검색어
	var SEARCH_VALUE_DISABLILITY;	// 장애학생 검색어
	
	var USER_DEPT_LIST = [];
	var CRS_CRE_LIST   = [];

	$(document).ready(function(){
		// 부서정보
		<c:forEach var="item" items="${deptList}">
			USER_DEPT_LIST.push({
				  deptCd: '<c:out value="${item.deptCd}" />'
				, deptNm: '<c:out value="${item.deptNm}" />'
				, deptCdOdr: '<c:out value="${item.deptCdOdr}" />'
			});
		</c:forEach>
		
		$("#searchValue").on("keydown", function(e) {
			if(e.keyCode == 13) {
				listCrsCre(1);
			}
		});

		$("#searchValueStudent").on("keydown", function(e) {
			if(e.keyCode == 13) {
				listPagingStudent(1);
			}
		});
				
		$("#searchValueDisablility").on("keydown", function(e) {
			if(e.keyCode == 13) {
				listPagingDisablility(1);
			}
		});
				
		USER_DEPT_LIST.sort(function(a, b) {
			if(a.deptCdOdr < b.deptCdOdr) return -1;
			if(a.deptCdOdr > b.deptCdOdr) return 1;
			if(a.deptCdOdr == b.deptCdOdr) {
				if(a.deptNm < b.deptNm) return -1;
				if(a.deptNm > b.deptNm) return 1;
			}
			return 0;
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

	// 과정유형 선택
	function selectCrsType(obj) {
		if($(obj).hasClass("basic")){
			$(obj).removeClass("basic").addClass("active");
		}else{
			$(obj).removeClass("active").addClass("basic");
		}
		// listCrsCre(1);
	}
	
	// 강의실 목록 조회
	function listCrsCre() {
		// 수강생 현황 초기화
		clearStudentList();
		// 장애학생 현황 초기화
		clearDisablilityList();
		// 개설과목 총 건수 초기화
		$('#crsCreTotalCntText').text("0");
		
		crsCreListTable.clearData();
		
		var crsTypeCdList = [];
		var url  = "/std/stdMgr/listCrsCre.do";
		var data = {
			  creYear		: $("#creYear").val()
			, creTerm		: $("#creTerm").val()
			, crsCreCd		: ($("#crsCreCd").val() || "").replace("ALL", "")
			, univGbn		: ($("#univGbn").val() || "").replace("ALL", "")
			, deptCd		: ($("#deptCd").val() || "").replace("ALL", "")
			, searchValue	: $("#searchValue").val()
		};

		if(crsTypeCdList.length > 0) {
			data.crsTypeCds = crsTypeCdList.join(",");
		}
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				var returnList = data.returnList || [];
				var pageInfo = data.pageInfo;
				var dataList = [];
				
				if (returnList.length > 0) {
					returnList.forEach(function(v, i) {
						var checked = (i == 0 ? "checked" : "");
						
						dataList.push({
	        				deptNm: (v.deptNm || '-'),
	        				crsCd: v.crsCd,
	        				crsCreNm: v.crsCreNm,
	        				declsNo: v.declsNo,
	        				compDvNm: v.compDvNm,
	        				credit: (Math.floor(v.credit) || '-'),
	        				repUserNm: (v.repUserNm || '-'),
	        				repUserId: v.repUserId,
	        				valCrsCreCd: v.crsCreCd,
	        				valCrsCreNm: v.crsCreNm
	        			});
					});

					crsCreListTable.addData(dataList);
					crsCreListTable.redraw();
				
					// 총 건수
					$('#crsCreTotalCntText').text(returnList.length);

					$("#noneCrsCreList").hide();
				} else {
					$("#crsCreList").empty();
					$("#noneCrsCreList").show();
				}
				// 수강생 조회
				listPagingStudent(1);
				// 장애학생 현황 조회
				listPagingDisablility(1);
			} else {
				alert(data.message);
				$('#crsCreTotalCntText').text("0");
			}
		}, function(xhr, status, error) {
			alert("<spring:message code='fail.common.msg' />");
			$('#crsCreTotalCntText').text("0");
		},true);
	}
	
	// 개설과목 체크박스 선택
	function checkCrsCre() {
		if($('#crsCreList').find("input:checkbox[name=crsCreCds]:not(:disabled):checked").length > 0) {
			// 수강생 조회
			listPagingStudent(1);
			// 장애학생 현황 조회
			listPagingDisablility(1);
		} else {
			// 수강생 현황 초기화
			clearStudentList();
			// 장애학생 현황 초기화
			clearDisablilityList();
		}
	}
	
	// 수강생 조회
	function listPagingStudent(pageIndex) {
		var crsCreCd = "";
		var selData = crsCreListTable.getSelectedData();
		if (selData != null && selData.length > 0) {
			crsCreCd = selData[0].valCrsCreCd;
		}
		
		if(crsCreCd == "") {
			return;
		}
		
		SEARCH_VALUE_STUDENT = $("#searchValueStudent").val();
		
		var url = "/std/stdMgr/listStudent.do";
		var data = {
			  crsCreCd		: crsCreCd
			, pageIndex		: pageIndex
			, listScale   	: $("#listScaleStudent").val()
			, searchValue 	: $("#searchValueStudent").val()
			, orgId			: $("#orgId").val()
		};

		$.getJSON(url, data, function(data) {
			if(data.result > 0) {
				var returnList = data.returnList || [];
				var pageInfo = data.pageInfo;
				var dataList = [];
				
				returnList.forEach(function(v, i) {
					// var lineNo = pageInfo.totalRecordCount - v.lineNo + 1;
					var checked = checkedObjStudent[v.userId] ? "checked" : "";
					
					dataList.push({						
						lineNo:v.lineNo, deptNm:(v.deptNm || '-'), userId:v.userId, 
						userNm:v.userNm + userInfoIcon("<%=SessionInfo.isKnou(request)%>","userInfoPop('"+v.userId+"')"),
						userType:(v.auditYn == 'Y' ? '<spring:message code="std.label.auditor" />' : '<spring:message code="std.label.student" />'),
						risk:"-", getScore:"-",
						manage:"<a href='javascript:void(0)' onclick=\"studyStatusModal(\'" + v.crsCreCd + "\', \'" + v.stdNo + "\')\" class='ui blue button mini'><spring:message code='std.button.stu_status'/></a>",
						valUserNm: v.userNm, 
						valMobileNo: v.mobileNo, 
						valEmail:v.email
					});
				});
				
				studentListTable.clearData();
				studentListTable.addData(dataList);
				studentListTable.redraw();

				var params = {
					totalCount 		: data.pageInfo.totalRecordCount,
					listScale 		: data.pageInfo.recordCountPerPage,
					currentPageNo 	: data.pageInfo.currentPageNo,
					eventName 		: "listPagingStudent",
					pagingDivId   	: "pagingStudent"
				};

				gfn_renderPaging(params);
			} else {
				alert(data.message);
			}
		}, function(xhr, status, error) {
			alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
		});
	}
	
	// 장애학생 현황 조회
	function listPagingDisablility(pageIndex) {
		var crsCreCd = "";
		var selData = crsCreListTable.getSelectedData();
		if (selData != null && selData.length > 0) {
			crsCreCd = selData[0].valCrsCreCd;
		}
		
		if(!crsCreCd) {
			return;
		}
		
		SEARCH_VALUE_DISABLILITY = $("#searchValueDisablility").val();
		
		var url = "/std/stdMgr/listDisablilityStudent.do";
		var data = {
			  crsCreCd			: crsCreCd
			, disablilityYn		: "Y"
			, pageIndex		: pageIndex
			, listScale			: $("#listScaleDisablility").val()
			, searchValue	: $("#searchValueDisablility").val()
			, orgId				: $("#orgId").val()
		};
		
		$.getJSON(url, data, function(data) {
			if(data.result > 0) {
				var returnList = data.returnList || [];
				var pageInfo = data.pageInfo;
				var dataList = [];

				returnList.forEach(function(v, i) {
					// var lineNo = pageInfo.totalRecordCount - v.lineNo + 1;
					var checked = checkedObjDisablility[v.userId] ? "checked" : "";

					var reqText = "-"; 			// 요청사항
					var reqResultText = "-"; 	// 요청결과

					if(v.dsblReqCd) {
						var midApprStat = (v.midApprStat).toLowerCase();
						var endApprStat = (v.endApprStat).toLowerCase();
						
						var midReqText = "";
						var endReqText = "";
						var midReqResultText = "";
						var endReqResultText = "";

						var reqTimeText = '<spring:message code="std.label.req_time" />'; // 시간연장
						var reqWaitText = '<spring:message code="std.label.req_wait" />'; // 대기
						var reqRejectText = '<spring:message code="std.label.req_reject" />'; // 반려

						// 중간 요청결과
						if(midApprStat == "req") {
							midReqText = (v.midAddTime == 0) ? " - " : reqTimeText; // 시간연장
							midReqResultText = (v.midAddTime == 0) ? " - " : reqWaitText; // 대기
						} else if(midApprStat == "approve") {
							midReqText = reqTimeText; reqTimeText; // 시간연장
							midReqResultText = '<spring:message code="std.label.extension" />' + "(" + v.midAddTime + '<spring:message code="std.label.minute" />' + ")"; // 연장, 분
						} else if (midApprStat == "reject") {
							midReqText = reqTimeText; // 시간연장
							midReqResultText = reqRejectText; // 반려
						}

						// 기말 요청결과
						if(endApprStat == "req") {
							endReqText = (v.endAddTime == 0) ? " - " : reqTimeText; // 시간연장
							endReqResultText = (v.endAddTime == 0) ? " - " : reqWaitText; // 대기
						} else if(endApprStat == "approve") {
							endReqText = reqTimeText; // 시간연장
							endReqResultText = '<spring:message code="std.label.extension" />' + "(" + v.endAddTime + '<spring:message code="std.label.minute" />' + ")"; // 연장, 분
						} else if (endApprStat == "reject") {
							endReqText = reqTimeText; // 시간연장
							endReqResultText = reqRejectText; // 반려
						}

						reqText = midReqText + "/" + endReqText;
						reqResultText = midReqResultText + "/" + endReqResultText;
					}

					dataList.push({						
						lineNo:v.lineNo, deptNm:(v.deptNm || '-'), userId:v.userId, 
						userNm:v.userNm + userInfoIcon("<%=SessionInfo.isKnou(request)%>","userInfoPop('"+v.userId+"')"),
						userType:(v.auditYn == 'Y' ? '<spring:message code="std.label.auditor" />' : '<spring:message code="std.label.student" />'),
						enrlStsNm:v.enrlStsNm, mobileNo:v.mobileNo, email:v.email, disabilityCdNm:v.disabilityCdNm, disabilityLvNm:v.disabilityLvNm, reqText:reqText, reqResultText:reqResultText,
						manage:"<a href='javascript:void(0)' onclick=\"studyStatusModal(\'" + v.crsCreCd + "\', \'" + v.stdNo + "\')\" class='ui blue button mini'><spring:message code='std.button.stu_status'/></a>",
						valUserNm: v.userNm, 
						valMobileNo: v.mobileNo, 
						valEmail:v.email
					});
				});

				disablilityListTable.clearData();
				disablilityListTable.addData(dataList);
				disablilityListTable.redraw();

				var params = {
					totalCount		: pageInfo.totalRecordCount,
					listScale		: pageInfo.recordCountPerPage,
					currentPageNo	: pageInfo.currentPageNo,
					eventName		: "listPagingDisablility",
					pagingDivId		: "pagingDisablility"
				};
			
				gfn_renderPaging(params);
			} else {
				alert(data.message);
			}
		}, function(xhr, status, error) {
			alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
		});
	}

	// 수강생 체크박스 선택
	function checkUser(userId, checked) {
		if(checked) {
			checkedObjStudent[userId] = true;
		} else {
			delete checkedObjStudent[userId];
		}
	}

	// 장애학생 체크박스 선택
	function checkUserDisablility(userId, checked) {
		if(checked) {
			checkedObjDisablility[userId] = true;
		} else {
			delete checkedObjDisablility[userId];
		}
	}

	// 수강생 전체 선택
	function checkAll(checked) {
		$.each($('#studentList').find("input:checkbox[name=userIds]:not(:disabled)"), function() {
			this.checked = checked;
			checkUser(this.value, checked);
		});
	}

	// 장애학생 전제 선택
	function checkAllDisablility(checked) {
		$.each($('#disablilityList').find("input:checkbox[name=userIds]:not(:disabled)"), function() {
			this.checked = checked;
			checkUserDisablility(this.value, checked);
		});
	}

	// 수강생 엑셀 다운로드
	function downExcel() {
		/* var crsCreCd = "";
		$.each($('#crsCreList').find("input:checkbox[name=crsCreCds]:not(:disabled)"), function(i, v) {
			if(this.checked) {
				if(crsCreCd != "") crsCreCd += ",";
				crsCreCd += this.value;
			}
		});
		
		if(!crsCreCd) {
			alert('<spring:message code="std.alert.no_select_crscre" />'); // 선택된 과목이 없습니다.
			return;
		} */
		
		var selData = crsCreListTable.getSelectedData();
		if (!selData || selData.length === 0) {
	        alert('<spring:message code="std.alert.no_select_crscre" />'); // 선택된 과목이 없습니다.
	        return;
	    }
		
		// 선택된 과목 코드들을 콤마로 이어붙임
	    var crsCreCd = selData.map(row => row.valCrsCreCd).join(",");
		
		var excelGrid = {
			colModel:[
				{label:'<spring:message code="common.number.no" />', 		name:'lineNo',  	align:'right', 		width:'1000'}, // NO.	
				{label:'<spring:message code="std.label.dept" />',    		name:'deptNm',  	align:'left',   	width:'5000'}, // 학과
				{label:'<spring:message code="std.label.user_id" />', 		name:'userId',  	align:'center',		width:'5000'}, // 학번
				{label:'<spring:message code="std.label.name" />',    		name:'userNm',  	align:'left',   	width:'5000'}, // 이름
				{label:'<spring:message code="std.label.type" />',  		name:'auditNm', 	align:'left',   	width:'5000'}, // 구분
				{label:'<spring:message code="std.label.risk_learn" />', 	name:'todo',		align:'right',  	width:'5000'}, // 학업중단 위험지수 미정
				{label:'<spring:message code="std.label.get_score" />',		name:'todoo',		align:'right',  	width:'5000'}, // 이수학점 미정
			]
		};
		
		var url  = "/std/stdMgr/downExcelStudentList.do";
		var form = $("<form></form>");
		form.attr("method", "POST");
		form.attr("name", "excelForm");
		form.attr("action", url);
		form.append($('<input/>', {type: 'hidden', name: 'orgId',    		value: $("#orgId").val()}));
		form.append($('<input/>', {type: 'hidden', name: 'crsCreCd',    	value: crsCreCd}));
		form.append($('<input/>', {type: 'hidden', name: 'searchValue', 	value: SEARCH_VALUE_STUDENT}));
		form.append($('<input/>', {type: 'hidden', name: 'excelGrid',   	value: JSON.stringify(excelGrid)}));
		form.appendTo("body");
		form.submit();
		
		$("form[name=excelForm]").remove();
	}

	// 장애학생 엑셀 다운로드
	function downExcelDisablility() {
		/* var crsCreCd = "";
		$.each($('#crsCreList').find("input:checkbox[name=crsCreCds]:not(:disabled)"), function(i, v) {
			if(this.checked) {
				if(crsCreCd != "") crsCreCd += ",";
				crsCreCd += this.value;
			}
		});
		
		if(!crsCreCd) {
			alert('<spring:message code="std.alert.no_select_crscre" />'); // 선택된 과목이 없습니다.
			return;
		} */
		
		var selData = crsCreListTable.getSelectedData();
		if (!selData || selData.length === 0) {
	        alert('<spring:message code="std.alert.no_select_crscre" />'); // 선택된 과목이 없습니다.
	        return;
	    }
		
		// 선택된 과목 코드들을 콤마로 이어붙임
	    var crsCreCd = selData.map(row => row.valCrsCreCd).join(",");

		var excelGrid = {
			colModel:[
				{label:'<spring:message code="common.number.no" />',  	name:'no',     				align:'right', 	width:'1000'},	// NO.
				{label:'<spring:message code="std.label.dept" />',    			name:'deptNm',     		align:'left',    	width:'5000'}, // 학과
				{label:'<spring:message code="std.label.user_id" />',   		name:'userId',     			align:'center',	width:'5000'}, // 학번
				{label:'<spring:message code="std.label.name" />',    			name:'userNm',     		align:'left',   	width:'5000'}, // 이름
				{label:'<spring:message code="std.label.type" />',  				name:'auditNm',   			align:'left',   	width:'5000'}, // 구분
				{label:'<spring:message code="std.label.learn_status" />', 	name:'enrlStsNm',			align:'left',   	width:'5000'}, // 수강상태
				{label:'<spring:message code="std.label.mobile" />', 			name:'mobileNo',			align:'center',	width:'5000'}, // 휴대전화
				{label:'<spring:message code="std.label.email" />', 				name:'email',					align:'left',   	width:'5000'}, // 이메일
				{label:'<spring:message code="std.label.dis_type" />', 		name:'disabilityCdNm',	align:'left',   	width:'5000'}, // 장애종류
				{label:'<spring:message code="std.label.dis_level" />', 		name:'disabilityLvNm',	align:'left',   	width:'5000'}, // 장애등급
				{label:'<spring:message code="std.label.req_info" />', 			name:'reqStatus',			align:'center',	width:'5000'}, // 요청사항
				{label:'<spring:message code="std.label.req_result" />', 		name:'reqStatusResult',	align:'center',	width:'5000'}, // 요청결과
			]
		};
		
		var url  = "/std/stdMgr/downExcelStudentList.do";
		var form = $("<form></form>");
		form.attr("method", "POST");
		form.attr("name", "excelForm");
		form.attr("action", url);
		form.append($('<input/>', {type: 'hidden', name: 'orgId',    		value: $("#orgId").val()}));
		form.append($('<input/>', {type: 'hidden', name: 'crsCreCd',    	value: crsCreCd}));
		form.append($('<input/>', {type: 'hidden', name: 'disablilityYn',   value: 'Y'}));
		form.append($('<input/>', {type: 'hidden', name: 'searchValue', 	value: SEARCH_VALUE_DISABLILITY}));
		form.append($('<input/>', {type: 'hidden', name: 'excelGrid',   	value: JSON.stringify(excelGrid)}));
		form.appendTo("body");
		form.submit();
		
		$("form[name=excelForm]").remove();
	}

	// 수강생 학습현황 팝업
	function studyStatusModal(crsCreCd, stdNo) {
		$("#studyStatusForm > input[name='orgId']").val($("#orgId").val());
		$("#studyStatusForm > input[name='crsCreCd']").val(crsCreCd);
		$("#studyStatusForm > input[name='stdNo']").val(stdNo);
		$("#studyStatusForm").attr("target", "studyStatusModalIfm");
		$("#studyStatusForm").attr("action", "/std/stdPop/studyStatusPop.do");
		$("#studyStatusForm").submit();
		$('#studyStatusModal').modal('show');

		$("#studyStatusForm > input[name='orgId']").val("");
		$("#studyStatusForm > input[name='crsCreCd']").val("");
		$("#studyStatusForm > input[name='stdNo']").val("");
	}

	// 장애학생 학습현황 팝업
	function studyStatusDisablilityModal(crsCreCd, stdNo) {
		$("#studyStatusDisablilityForm > input[name='orgId']").val($("#orgId").val());
		$("#studyStatusDisablilityForm > input[name='crsCreCd']").val(crsCreCd);
		$("#studyStatusDisablilityForm > input[name='stdNo']").val(stdNo);
		$("#studyStatusDisablilityForm > input[name='disablilityYn']").val("Y");
		$("#studyStatusDisablilityForm").attr("target", "studyStatusModalIfm");
		$("#studyStatusDisablilityForm").attr("action", "/std/stdPop/studyStatusPop.do");
		$("#studyStatusDisablilityForm").submit();
		$('#studyStatusModal').modal('show');

		$("#studyStatusDisablilityForm > input[name='orgId']").val("");
		$("#studyStatusDisablilityForm > input[name='crsCreCd']").val("");
		$("#studyStatusDisablilityForm > input[name='stdNo']").val("");
	}

	// 수강생 현황 초기화
	function clearStudentList() {
		// 체크박스 선택 정보 초기화
		checkedObjStudent = {};
		// 검색조건 초기화
		$("#searchValueStudent").val("");
		SEARCH_VALUE_STUDENT = "";
		// 리스트 초기화
		studentListTable.clearData();
	}

	// 장애학생 현황 초기화
	function clearDisablilityList() {
		// 체크박스 선택 정보 초기화
		checkedObjDisablility = {};
		// 검색조건 초기화
		$("#searchValueDisablility").val("");
		SEARCH_VALUE_DISABLILITY = "";
		// 리스트 초기화
		disablilityListTable.clearData();
	}

	// 수강생 메세지 보내기
	function sendMsg(type) {
		var selectList = [];		
		var rcvUserInfoStr = "";
		var sendCnt = 0;
		
		if (type == 1) {
			selectList = studentListTable.getSelectedRows();
		}
		else if (type == 2) {
			selectList = disablilityListTable.getSelectedRows();
		}
		
		
		if(selectList.length == 0) {
			alert('<spring:message code="std.alert.no_select_list" />'); // 선택된 목록이 없습니다.
			return;
		}
		
		for(var i=0; i<selectList.length; i++) {
			sendCnt++;
			if (sendCnt > 1)
				rcvUserInfoStr += "|";
			
			var data = selectList[i].getData();
			rcvUserInfoStr += data.userId;
			rcvUserInfoStr += ";" + data.valUserNm;
			rcvUserInfoStr += ";" + data.valMobileNo;
			rcvUserInfoStr += ";" + data.valEmail;
		}
		
		window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");

		var form = document.alarmForm;
		form.action = '<%=CommConst.SYSMSG_URL_SEND%>';
        form.target = "msgWindow";
        form[name='alarmType'].value = "S"; // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
        form[name='rcvUserInfoStr'].value = rcvUserInfoStr; //보내는사람 정보
        form.submit();
	}

	// 장애학생 메세지 보내기
	function sendMsgDisablility() {
		var checkedList = Object.keys(checkedObjDisablility);
		
		if(checkedList.length == 0) {
			alert('<spring:message code="std.alert.no_select_list" />'); // 선택된 목록이 없습니다.
			return;
		}
		alert(checkedList);
	}

</script>

<body>
	<div id="wrap" class="pusher">

		<!-- header -->
		<%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
		<!-- //header -->

		<!-- lnb -->
		<%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>
		<!-- //lnb -->

		<div id="container">

			<!-- 본문 content 부분 -->
			<div class="content stu_section">

				<!-- admin_location -->
				<%-- <%@ include file="/WEB-INF/jsp/common/admin/admin_location.jsp" %> --%>
				<!-- //admin_location -->

				<div class="ui form">

					<!-- 타이틀 -->
					<div id="info-item-box">
						<h2 class="page-title">
							<spring:message code="std.label.learner_info" /><span>
						</h2>
						<div class="button-area"></div>
					</div>

					<div class="ui segment searchArea">
					
						<div class="ui buttons mb10">
							<%
							if (SessionInfo.isKnou(request)) {
								%>
								<button class="ui blue button active" data-crs-type-cd="UNI" 		onclick="selectCrsType(this)"><spring:message code="common.button.uni" /></button><!-- 학기제 -->
								<%-- <button class="ui basic blue button"  data-crs-type-cd="CO" 		onclick="selectCrsType(this)"><spring:message code="common.button.co" /></button><!-- 기수제 --> --%>
								<button class="ui basic blue button"  data-crs-type-cd="LEGAL" onclick="selectCrsType(this)"><spring:message code="common.button.legal" /></button><!-- 법정교육 -->
								<%-- <button class="ui basic blue button"  data-crs-type-cd="OPEN" 	onclick="selectCrsType(this)"><spring:message code="common.button.open" /></button><!-- 공개강좌 --> --%>
								<%
							}
							%>
						</div>

						<!-- 검색조건 -->
						<div class="option-content mb20">

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
							<c:if test="${orgId eq 'ORG0000001'}">
							<select id="univGbn" class="ui dropdown mr5" onchange="changeUnivGbn()">
			                   	<option value=""><spring:message code="common.label.uni.type" /></option><!-- 대학구분 -->
			                   	<option value="ALL"><spring:message code="common.all" /></option><!-- 전체 -->
			                   	<c:forEach var="item" items="${univGbnList}">
									<option value="${item.codeCd}" ${item.codeCd}><c:out value="${item.codeNm}" /></option>
								</c:forEach>
			                </select>
			                </c:if>
			                <select id="deptCd" class="ui dropdown w250" onchange="changeDeptCd()">
	                        	<option value=""><spring:message code="common.dept_name" /><!-- 학과 --> <spring:message code="common.select" /><!-- 선택 --></option>
	                        </select> 
	                        <select id="crsCreCd" class="ui dropdown mr5 w250">
			                	<option value=""><spring:message code="common.subject" /><!-- 과목 --> <spring:message code="common.select" /><!-- 선택 --></option>
			                </select>

							<div class="ui input search-box">
								<input id="searchValue" type="text" placeholder="<spring:message code="std.common.placeholder2" />" value="${param.searchValue}" />
							</div>
							<button type="button" class="ui green button mla" onclick="listCrsCre()"><spring:message code="common.button.search" /><!-- 검색 --></button>
						</div>

						<div class="option-content mb10">
							<h3 class="graduSch"><spring:message code="std.label.crscre_status" /></h3><!-- 개설과목 현황 -->
							<div class="flex-left-auto">[&nbsp;<spring:message code="common.page.total" /><!-- 총 -->&nbsp;<span class="fcBlue" id="crsCreTotalCntText">0</span>&nbsp;<spring:message code="common.page.total_count" /><!-- 건 -->&nbsp;]</div>
						</div>

						<div id="crsCreListTable"></div>
	   					<script>
                        var crsCreListTable = new Tabulator("#crsCreListTable", {
                        		maxHeight: "400px",
                        		minHeight: "100px",
                        		layout: "fitColumns",
                        		selectableRows: 1,
                        		headerSortClickElement: "icon",
                        		placeholder:"<spring:message code='common.content.not_found'/>",
                        		columns: [
                        		    {title:"<spring:message code='common.number.no'/>", 		field:"lineNo", 	headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:60, 		formatter:"rownum", 	headerSort:false},
                        		    {title:"<spring:message code='common.dept_name'/>", 		field:"deptNm", 	headerHozAlign:"center", hozAlign:"left",   vertAlign:"middle", minWidth:150, 	formatter:"plaintext", 	headerSort:true, sorter:"string", sorterParams:{locale:"en"}}, // 학과			                        		    
                        		    {title:"<spring:message code='lesson.label.crs.cd'/>", 		field:"crsCd", 		headerHozAlign:"center", hozAlign:"left",   vertAlign:"middle", minWidth:100,	formatter:"plaintext", 	headerSort:true}, // 학수번호
                        		    {title:"<spring:message code='lesson.label.crs.cre.nm'/>",	field:"crsCreNm", 	headerHozAlign:"center", hozAlign:"left",   vertAlign:"middle", minWidth:100, 	formatter:"plaintext", 	headerSort:true, sorter:"string", sorterParams:{locale:"en"}}, // 과목명
                        		    {title:"<spring:message code='std.label.decls'/>",			field:"declsNo", 	headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:80, 		formatter:"plaintext", 	headerSort:false}, // 분반
                        		    {title:"<spring:message code='std.label.comp_div'/>",		field:"compDvNm", 	headerHozAlign:"center", hozAlign:"left",   vertAlign:"middle", minWidth:80, 	formatter:"plaintext", 	headerSort:false}, // 이수구분
                        		    {title:"<spring:message code='std.label.credit'/>",			field:"credit", 	headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:80, 		formatter:"plaintext", 	headerSort:false}, // 학점
                        		    {title:"<spring:message code='std.label.rep_prof'/>", 		field:"repUserNm",	headerHozAlign:"center", hozAlign:"left",   vertAlign:"middle", minWidth:100, 	formatter:"plaintext", 	headerSort:true}, // 교수
                        		    {title:"<spring:message code='std.label.rep_prof_no'/>", 	field:"repUserId", 	headerHozAlign:"center", hozAlign:"left",   vertAlign:"middle", minWidth:100, 	formatter:"plaintext",	headerSort:false}, // 교수번호
                        		]
                       	});
                        
                        crsCreListTable.on("rowSelected", function(row){
                            var data = row.getData();
                            
                         	// 수강생 조회
                			listPagingStudent(1);
                			// 장애학생 현황 조회
                			listPagingDisablility(1);
                        });
                        </script>
					</div>

					<div class="mb10">
						<div class="ui bottom attached segment">
						
							<!-- 영역2 -->
							<div class="option gap4 mt10 mb10">
								<h3 class="graduSch mb10"><spring:message code="std.label.learner_status2" /><!-- 수강생 현황 --></h3>
								<!-- 검색조건 -->
								<div class="option-content mb10">
									<div class="ui action input search-box">
										<input id="searchValueStudent" type="text" placeholder="<spring:message code="std.common.placeholder" />" value="${param.searchValue}" />
										<button class="ui icon button" type="button" onclick="listPagingStudent(1)">
											<i class="search icon"></i>
										</button>
									</div>&nbsp;&nbsp;
									<div class="select_area mla">
										<uiex:msgSendBtn func="sendMsg(1)" styleClass="ui basic button"/><!-- 메시지 -->
										<a href="javascript:void(0)" onclick="downExcel()" class="ui basic button"><spring:message code="common.button.excel_down" /><!-- 엑셀 다운로드 --></a>
										<select class="ui dropdown list-num" id="listScaleStudent" onchange="listPagingStudent(1)">
											<option value="10">10</option>
											<option value="20">20</option>
											<option value="50">50</option>
											<option value="100">100</option>
											</select>
									</div>
								</div>
								
								<div id="studentListTable" ></div>
								<script>
			                        // 수강생 목록 테이블
			                        var studentListTable = new Tabulator("#studentListTable", {
			                        		maxHeight: "500px",
			                        		minHeight: "100px",
			                        		layout: "fitColumns",
			                        		selectableRows: "highlight",
			                        		headerSortClickElement: "icon",
			                        		placeholder:"<spring:message code='common.content.not_found'/>",
			                        		columns: [
			                        			{formatter:"rowSelection", titleFormatter:"rowSelection", headerHozAlign:"center", hozAlign:"center", width:50, headerSort:false, cellClick:function(e,cell){cell.getRow().toggleSelect();}}, // check
			                        		    {title:"<spring:message code='common.number.no'/>", 	field:"lineNo",		headerHozAlign:"center", hozAlign:"center",	width:60, 		formatter:"plaintext",	headerSort:false}, // No
			                        		    {title:"<spring:message code='std.label.dept'/>", 		field:"deptNm",		headerHozAlign:"center", hozAlign:"left",	minWidth:150,	formatter:"plaintext",	headerSort:false}, // 학과
			                        		    {title:"<spring:message code='std.label.user_id'/>", 	field:"userId",		headerHozAlign:"center", hozAlign:"left",	minWidth:100,	formatter:"plaintext",	headerSort:false}, // 학번
			                        		    {title:"<spring:message code='std.label.name'/>",		field:"userNm",		headerHozAlign:"center", hozAlign:"left",	minWidth:120,	formatter:"html", 		headerSort:false}, // 이름
			                        		    {title:"<spring:message code='std.label.type'/>",		field:"userType",	headerHozAlign:"center", hozAlign:"center",	width:100,		formatter:"plaintext",	headerSort:false}, // 구분
			                        		    {title:"<spring:message code='std.label.risk_learn'/>",	field:"risk",		headerHozAlign:"center", hozAlign:"center",	width:150,		formatter:"plaintext",	headerSort:false}, // 학업중단위험지수
			                        		    {title:"<spring:message code='std.label.get_score'/>",	field:"getScore",	headerHozAlign:"center", hozAlign:"center",	width:100,		formatter:"plaintext",	headerSort:false}, // 이수학점
			                        		    {title:"<spring:message code='std.label.manage'/>",		field:"manage",		headerHozAlign:"center", hozAlign:"center",	width:100,		formatter:"html", 		headerSort:false}  // 관리			                        		    
			                        		]
		                        	});
		                        </script>
								<div id="pagingStudent" class="paging mt10"></div>
							</div>
						
						</div>
					</div>

					<div class="mb10">
						<div class="ui bottom attached segment">
							
							<!-- 영역3 -->
							<div class="option gap4 mt10 mb10">
								<h3 class="graduSch mb10"><spring:message code="std.label.dis_studend_info" /><!-- 장애학생 현황 --></h3>
								<!-- 검색조건 -->
								<div class="option-content mb10">
									<div class="ui action input search-box">
										<input id="searchValueDisablility" type="text" placeholder="<spring:message code="std.common.placeholder" />" value="${param.searchValue}" />
										<button class="ui icon button" type="button" onclick="listPagingDisablility(1)">
											<i class="search icon"></i>
										</button>
									</div>&nbsp;&nbsp;
									<div class="select_area mla">
										<uiex:msgSendBtn func="sendMsg(2)" styleClass="ui basic button"/><!-- 메시지 -->
										<a href="javascript:void(0)" onclick="downExcelDisablility()" class="ui basic button"><spring:message code="common.button.excel_down" /><!-- 엑셀 다운로드 --></a>
										<select class="ui dropdown list-num" id="listScaleDisablility" onchange="listPagingDisablility(1)">
											<option value="10">10</option>
											<option value="20">20</option>
											<option value="50">50</option>
											<option value="100">100</option>
										</select>
									</div>
								</div>
								<div id="disablilityListTable"></div>
								<script>
			                        // 장애학생 목록 테이블
			                        var disablilityListTable = new Tabulator("#disablilityListTable", {
			                        		maxHeight: "500px",
			                        		minHeight: "100px",
			                        		layout: "fitColumns",
			                        		selectableRows: "highlight",
			                        		headerSortClickElement: "icon",
			                        		placeholder:"<spring:message code='common.content.not_found'/>",
			                        		columns: [
			                        			{formatter:"rowSelection", titleFormatter:"rowSelection", headerHozAlign:"center", hozAlign:"center", width:50, headerSort:false, cellClick:function(e,cell){cell.getRow().toggleSelect();}}, // check
			                        			{title:"<spring:message code='common.number.no'/>", 		field:"lineNo",			headerHozAlign:"center", hozAlign:"center",	width:60, 		formatter:"plaintext",	headerSort:false}, // No
			                        		    {title:"<spring:message code='std.label.dept'/>",			field:"deptNm",			headerHozAlign:"center", hozAlign:"left",	minWidth:180,	formatter:"plaintext",	headerSort:false}, // 학과
			                        		    {title:"<spring:message code='std.label.user_id'/>",		field:"userId",			headerHozAlign:"center", hozAlign:"left",	minWidth:100,	formatter:"plaintext",	headerSort:false}, // 학번
			                        		    {title:"<spring:message code='std.label.name'/>",			field:"userNm",			headerHozAlign:"center", hozAlign:"left",	minWidth:120,	formatter:"html", 		headerSort:false}, // 이름
			                        		    {title:"<spring:message code='std.label.type'/>",			field:"userType",		headerHozAlign:"center", hozAlign:"center",	width:70,		formatter:"plaintext",	headerSort:false}, // 구분
			                        		    {title:"<spring:message code='std.label.learn_status'/>",	field:"enrlStsNm",		headerHozAlign:"center", hozAlign:"center", width:80,		formatter:"plaintext",	headerSort:false}, // 수강상태
			                        		    {title:"<spring:message code='std.label.mobile'/>",			field:"mobileNo",		headerHozAlign:"center", hozAlign:"left",	width:100,		formatter:"plaintext",	headerSort:false}, // 휴대전화
			                        		    {title:"<spring:message code='std.label.email'/>",			field:"email",			headerHozAlign:"center", hozAlign:"left",	width:180,		formatter:"plaintext",	headerSort:false}, // 이메일
			                        		    {title:"<spring:message code='std.label.dis_type'/>",		field:"disabilityCdNm",	headerHozAlign:"center", hozAlign:"center",	width:80,		formatter:"plaintext",	headerSort:false}, // 장애종류
			                        		    {title:"<spring:message code='std.label.dis_level'/>",		field:"disabilityLvNm",	headerHozAlign:"center", hozAlign:"center",	width:80,		formatter:"plaintext",	headerSort:false}, // 장애등급			                        		    
			                        		    {title:"<spring:message code='std.label.req_info'/>",		field:"reqText",		headerHozAlign:"center", hozAlign:"left",	minWidth:120,	formatter:"plaintext",	headerSort:false}, // 요청사항
			                        		    {title:"<spring:message code='std.label.req_result'/>",		field:"reqResultText",	headerHozAlign:"center", hozAlign:"center",	minWidth:150,	formatter:"plaintext",	headerSort:false}, // 요청결과			                        		    
			                        		    {title:"<spring:message code='std.label.manage'/>",			field:"manage",			headerHozAlign:"center", hozAlign:"center",	width:70,		formatter:"html", 		headerSort:false}  // 관리			                        		    
			                        		]
		                        	});
		                        </script>
								<div id="pagingDisablility" class="paging mt10"></div>
							</div>
						
						</div>
					</div>
					
				</div><!-- //ui form -->
			</div><!-- //content stu_section -->
			<%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
		</div><!-- //container -->
		
	</div><!-- //wrap -->
	
	<!-- 수강생 학습현황 팝업 --> 
	<form id="studyStatusForm" name="studyStatusForm">
		<input type="hidden" name="orgId" />
		<input type="hidden" name="crsCreCd" />
		<input type="hidden" name="stdNo" />
	</form>
	<form id="studyStatusDisablilityForm" name="studyStatusDisablilityForm">
		<input type="hidden" name="orgId" />
		<input type="hidden" name="crsCreCd" />
		<input type="hidden" name="stdNo" />
		<input type="hidden" name="disablilityYn" />
	</form>

    <div class="modal fade in" id="studyStatusModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="std.label.learner_status" />" aria-hidden="false" style="display: none; padding-right: 17px;">
        <div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
			    <div class="modal-header">
			        <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="exam.button.close" />">
						<span aria-hidden="true">&times;</span>
			        </button>
			        <h4 class="modal-title"><spring:message code="std.label.learner_status" /><!-- 수강생 학습현황 --></h4>
			    </div>
			    <div class="modal-body">
			        <iframe src="" width="100%" id="studyStatusModalIfm" name="studyStatusModalIfm"></iframe>
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