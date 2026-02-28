<%@ page import="knou.lms.common.web.CommonController"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
<script type="text/javascript">
	$(document).ready(function() {
		$(document).ready(function() {
			$("#searchValue").on("keydown", function(e) {
				if(e.keyCode == 13) {
					list();
				}
			});
			/* 
			$("#searchValueDisablility").on("keydown", function(e) {
				if(e.keyCode == 13) {
					listDisablility();
				}
			});
			 */
		});
		
		// 수강생 조회
		list();
		// 장애학생 현황 조회
		//listDisablility();
	});
	
	// 수강생 조회
	function list() {
		var searchValue = $("#searchValue").val();

		if(searchValue.length > 0) {
			// 숫자만 입력한경우 - 5자이상 입력
			var onlyNumberRegExp = /^[0-9]+$/;
			
			if(onlyNumberRegExp.test(searchValue) && searchValue.length < 5) {
				 /* 숫자는 5자리이상 입력하세요. */
				alert('<spring:message code="std.alert.enter.number5" />');
				return;
			} else if (searchValue.length < 2) {
				 /* 검색어를 2자리이상 입력하세요. */
				alert('<spring:message code="std.alert.enter.word2" />');
				return;
			}
		}

		var url = "/std/stdLect/listStudent.do";
		var data = {
			crsCreCd : '<c:out value="${crsCreCd}" />',
			searchValue : $("#searchValue").val(),
			searchKey : $("#searchKey").val().trim()
		};

		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				var returnList = data.returnList || [];
				var html = '';
				var univGbn = "${creCrsVO.univGbn}";

				returnList.forEach(function(v, i) {
					var lineNo = parseInt(v.lineNo);
					
					var riskGrade = "-";
					var riskSortOrder = "";
					
					if(v.riskGrade) {
						if(v.riskGrade == "매우위험") {
							riskSortOrder = "5";
							riskGrade = "5(매우위험)";
						} else if(v.riskGrade == "위험") {
							riskSortOrder = "4";
							riskGrade = "4(위험)";
						} else if(v.riskGrade == "관심") {
							riskSortOrder = "3";
							riskGrade = "3(관심)";
						} else if(v.riskGrade == "보통") {
							riskSortOrder = "2";
							riskGrade = "2(보통)";
						} else if(v.riskGrade == "안전") {
							riskSortOrder = "1";
							riskGrade = "1(안전)";
						}
					}
					
					var stdGbnText = '<spring:message code="std.label.student" />'; // 학생

					if (v.repeatYn == 'Y') {
						stdGbnText = '<spring:message code="std.label.repeat" />'; //재수강
					}
					
					if(v.auditYn == 'Y') {
						stdGbnText = '<spring:message code="std.label.auditor" />'; // 청강생
						
						if(v.gvupYn == 'Y') {
							stdGbnText = '<spring:message code="std.label.gvup.yn.c" />'; // 수강포기
							
							if(v.uniCd == "G") {
								stdGbnText = '<spring:message code="std.label.gvup.yn.g" />'; // 수강철회
							}
						}
					}

					html += '<tr>';
					html += '	<td class="tc">';
					html += '		<div class="ui checkbox">';
					html += '			<input type="checkbox" name="userIds" value="' + v.userId + '" user_nm="'+v.userNm+'" mobile="'+v.mobileNo+'" email="'+v.email+'" />';
					html += '		</div>';
					html += '	</td>';
					html += '	<td class="tc lineNo">' + lineNo + '</td>';
					html += '	<td class="word_break_none">' + (v.deptNm || '') + '</td>';
					html += '	<td class="tc">' + v.userId + '</td>';
					html += '	<td class="tc">' + v.hy + '</td>';
					if(univGbn == "3" || univGbn == "4") {
						html += '<td class="tc word_break_none">' + (v.grscDegrCorsGbnNm || '-') + '</td>';
					}
					html += '	<td class="tc word_break_none" style="white-space:nowrap">' + v.userNm;
					html += 		userInfoIcon("<%=SessionInfo.isKnou(request)%>", "userInfoPop('"+v.userId+"')");
					html += '   </td>';
					html += '	<td class="tc">' + v.entrYy + '</td>';
					html += '	<td class="tc">' + v.readmiYy + '</td>';
					html += '	<td class="tc">' + v.entrHy + '</td>';
					html += '	<td class="tc word_break_none">' + v.entrGbnNm + '</td>';
					html += '	<td class="tc word_break_none">' + stdGbnText + '</td>'; // 학생, 청강생, 수강포기, 수강철회
					html += '	<td class="tc">' + v.riskIndex + '</td>'; // 위험지수
					html += '	<td class="tc" data-sort-value="' + riskSortOrder + '">' + riskGrade + '</td>'; // 위험등급
					html += '	<td class="tc word_break_none">';
					if ("<%=SessionInfo.isVirtualLogin(request)%>" == "false" && "<%=SessionInfo.isAdminCrsInfo(request)%>" == "false" && (DEVICE_TYPE == "PC" || DEVICE_TYPE == "pc")) {
						// 학생 강의실로 이동
						html += '<a href="javascript:void(0)" onclick="goLearnerHome(\'' + v.userId + '\',)" class="ui basic button mini" title="<spring:message code="std.label.move_std_home"/>"><i class="ion-android-share"></i></a>';
					}
					html += '   <a href="javascript:void(0)" onclick="studyStatusModal(\'' + v.stdNo + '\')" class="ui blue button mini"><spring:message code="std.button.stu_status" /></a></td>'; // 학습현황
					html += '</tr>';
				});

				$("#studentList").empty().html(html);
				$("#studentListTable").footable();
				$("#studentListTable").find(".ui.checkbox").checkbox();

				$("#totalCntText").text(returnList.length);

				// 정렬후 No 재설정
				$('#studentListTable').on('after.ft.sorting', function(e) {
					var tbList = $('#studentListTable').find("td.lineNo");
			    	if (tbList.length > 0) {
			    		for (var i=0; i < tbList.length; i++) {
			    			$(tbList[i]).html(i+1);
			    		}
			    	}
				});
				
			} else {
				alert(data.message);
				$("#totalCntText").text("0");
			}
		}, function(xhr, status, error) {
			alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			$("#totalCntText").text("0");
		});
	}

	// 장애학생 현황 조회
	function listDisablility() {
		var url = "/std/stdLect/listStudent.do";
		var data = {
			crsCreCd : '<c:out value="${crsCreCd}" />',
			disablilityYn : "Y",
			searchValue : $("#searchValueDisablility").val()
		};

		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				var returnList = data.returnList || [];
				var html = '';
				var uniCd = '<c:out value="${creCrsVO.uniCd}" />';

				returnList.forEach(function(v, i) {
					//var lineNo = returnList.length - v.lineNo + 1;
					var lineNo = v.lineNo;

					var reqText = "-"; // 요청사항
					var reqResultText = "-"; // 요청결과

					if (v.dsblReqCd) {
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
						if (midApprStat == "req") {
							midReqText = (v.midAddTime == 0) ? " - " : reqTimeText; // 시간연장
							midReqResultText = (v.midAddTime == 0) ? " - " : reqWaitText; // 대기
						} else if (midApprStat == "approve") {
							midReqText = reqTimeText;
							reqTimeText; // 시간연장
							midReqResultText = '<spring:message code="std.label.extension" />' + "(" + v.midAddTime + '<spring:message code="std.label.minute" />' + ")"; // 연장, 분
						} else if (midApprStat == "reject") {
							midReqText = reqTimeText; // 시간연장
							midReqResultText = reqRejectText; // 반려
						}

						// 기말 요청결과
						if (endApprStat == "req") {
							endReqText = (v.endAddTime == 0) ? " - " : reqTimeText; // 시간연장
							endReqResultText = (v.endAddTime == 0) ? " - " : reqWaitText; // 대기
						} else if (endApprStat == "approve") {
							endReqText = reqTimeText; // 시간연장
							endReqResultText = '<spring:message code="std.label.extension" />' + "(" + v.endAddTime + '<spring:message code="std.label.minute" />' + ")"; // 연장, 분
						} else if (endApprStat == "reject") {
							endReqText = reqTimeText; // 시간연장
							endReqResultText = reqRejectText; // 반려
						}

						reqText = midReqText + "/" + endReqText;
						reqResultText = midReqResultText + "/" + endReqResultText;
					}
					
					var stdGbnText = '<spring:message code="std.label.student" />'; // 학생
					if(v.repeatYn == 'Y') {
						stdGbnText = '<spring:message code="std.label.repeat" />'; //재수강
					}
					
					if(v.auditYn == 'Y') {
						stdGbnText = '<spring:message code="std.label.auditor" />'; // 청강생

						if(v.gvupYn == 'Y') {
							stdGbnText = '<spring:message code="std.label.gvup.yn.c" />'; // 수강포기
							
							if(uniCd == "G") {
								stdGbnText = '<spring:message code="std.label.gvup.yn.g" />'; // 수강철회
							}
						}
					}

					html += '<tr>';
					html += '	<td class="tc">';
					html += '		<div class="ui checkbox">';
					html += '			<input type="checkbox" name="userIds" value="' + v.userId + '" user_nm="'+v.userNm+'" mobile="'+v.mobileNo+'" email="'+v.email+'" />';
					html += '		</div>';
					html += '	</td>';
					html += '	<td class="tc">' + lineNo + '</td>';
					html += '	<td>' + v.deptNm + '</td>';
					html += '	<td class="tc">' + v.userId + '</td>';
					html += '	<td class="tc">' + v.userNm;
					html += 		userInfoIcon("<%=SessionInfo.isKnou(request)%>", "userInfoPop('"+v.userId+"')");
					html += '	</td>';
					html += '	<td class="tc">' + stdGbnText + '</td>'; // 학생, 청강생, 수강포기, 수강철회
					html += '	<td class="tc">' + v.enrlStsNm + '</td>';
					html += '	<td class="tc">' + v.mobileNo + '</td>';
					html += '	<td>' + v.email + '</td>';
					html += '	<td class="tc">' + v.disabilityCdNm + '</td>';
					html += '	<td class="tc">' + v.disabilityLvNm + '</td>';
					html += '	<td>' + reqText + '</td>';
					html += '	<td>' + reqResultText + '</td>';
					html += '	<td class="tc"><a href="javascript:void(0)" onclick="studyStatusDisablilityModal(\'' + v.stdNo + '\')" class="ui blue button small"><spring:message code="std.button.stu_status" /></a></td>'; // 학습현황
					html += '</tr>';
				});

				$("#disablilityList").empty().html(html);
				$("#disablilityListTable").footable();
				$("#disablilityListTable").find(".ui.checkbox").checkbox();
			} else {
				alert(data.message);
			}
		}, function(xhr, status, error) {
			alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
		});
	}

	// 수강생 전체 선택
	function checkAll(checked) {
		$('#studentList').find("input:checkbox[name=userIds]:not(:disabled)").prop("checked", checked);
	}

	// 장애학생 전제 선택
	function checkAllDisablility(checked) {
		$('#disablilityList').find("input:checkbox[name=userIds]:not(:disabled)").prop("checked", checked);
	}

	// 수강생 엑셀 다운로드
	function downExcel() {
		var univGbn = '<c:out value="${creCrsVO.univGbn}" />';
		var excelGrid = { colModel: [] };
		
		excelGrid.colModel.push({label: '<spring:message code="main.common.number.no" />', name: 'lineNo', align: 'right', width: '1000'});
		excelGrid.colModel.push({label: '<spring:message code="std.label.dept" />', name: 'deptNm', align: 'left', width: '5000'}); // 학과
		excelGrid.colModel.push({label: '<spring:message code="std.label.user_id" />', name: 'userId', align: 'center', width: '5000'}); // 학번
		excelGrid.colModel.push({label: '<spring:message code="std.label.hy" />', name: 'hy', align: 'center', width: '2500'}); // 학년
		if(univGbn == "3" || univGbn == "4") {
			excelGrid.colModel.push({label: '<spring:message code="common.label.grsc.degr.cors.gbn" />', name: 'grscDegrCorsGbnNm', align: 'left', width: '4000'}); // 학위과정
		}
		excelGrid.colModel.push({label: '<spring:message code="std.label.name" />', name: 'userNm', align: 'left', width: '5000'}); // 이름
		excelGrid.colModel.push({label: '<spring:message code="std.label.enter.year" />', name: 'entrYy', align: 'center', width: '2500'}); // 입학년도
		excelGrid.colModel.push({label: '<spring:message code="std.label.readmi.year" />', name: 'readmiYy', align: 'center', width: '5000'}); // 재입학년도
		excelGrid.colModel.push({label: '<spring:message code="std.label.enter.gbn" />', name: 'entrGbnNm', align: 'left', width: '5000'}); // 입학구분
		excelGrid.colModel.push({label: '<spring:message code="std.label.type" />', name: 'auditNm', align: 'left', width: '5000'}); // 구분
		excelGrid.colModel.push({label: '<spring:message code="std.label.risk_index" />', name: 'riskIndex', align: 'right', width: '5000'}); // 위험지수
		excelGrid.colModel.push({label: '<spring:message code="std.label.risk_grade" />', name: 'riskGrade', align: 'left', width: '5000', codes: {'매우위험': '5(매우위험)', '위험': '4(위험)', '관심': '3(관심)', '보통': '2(보통)', '안전': '1(안전)'}, defaultValue: '-'}); // 위험등급


		var url = "/std/stdLect/downExcelStudentList.do";
		var form = $("<form></form>");
		form.attr("method", "POST");
		form.attr("name", "excelForm");
		form.attr("action", url);
		form.append($('<input/>', {
			type : 'hidden',
			name : 'crsCreCd',
			value : '<c:out value="${crsCreCd}" />'
		}));
		form.append($('<input/>', {
			type : 'hidden',
			name : 'searchValue',
			value : $("#searchValue").val()
		}));
		form.append($('<input/>', {
			type : 'hidden',
			name : 'searchKey',
			value : $("#searchKey").val().trim()
		}));
		form.append($('<input/>', {
			type : 'hidden',
			name : 'excelGrid',
			value : JSON.stringify(excelGrid)
		}));
		form.appendTo("body");
		form.submit();

		$("form[name=excelForm]").remove();
	}

	// 장애학생 엑셀 다운로드
	function downExcelDisablility() {
		var excelGrid = {
			colModel : [ {
				label : '<spring:message code="main.common.number.no" />',
				name : 'no',
				align : 'right',
				width : '1000'
			}, {
				label : '<spring:message code="std.label.dept" />',
				name : 'deptNm',
				align : 'left',
				width : '5000'
			}, // 학과
			{
				label : '<spring:message code="std.label.user_id" />',
				name : 'userId',
				align : 'center',
				width : '5000'
			}, // 학번
			{
				label : '<spring:message code="std.label.name" />',
				name : 'userNm',
				align : 'left',
				width : '5000'
			}, // 이름
			{
				label : '<spring:message code="std.label.type" />',
				name : 'auditNm',
				align : 'left',
				width : '5000'
			}, // 구분
			{
				label : '<spring:message code="std.label.learn_status" />',
				name : 'enrlStsNm',
				align : 'left',
				width : '5000'
			}, // 수강상태
			{
				label : '<spring:message code="std.label.mobile" />',
				name : 'mobileNo',
				align : 'center',
				width : '5000'
			}, // 휴대전화
			{
				label : '<spring:message code="std.label.email" />',
				name : 'email',
				align : 'left',
				width : '5000'
			}, // 이메일
			{
				label : '<spring:message code="std.label.dis_type" />',
				name : 'disabilityCdNm',
				align : 'left',
				width : '5000'
			}, // 장애종류
			{
				label : '<spring:message code="std.label.dis_level" />',
				name : 'disabilityLvNm',
				align : 'left',
				width : '5000'
			}, // 장애등급
			{
				label : '<spring:message code="std.label.req_info" />',
				name : 'reqStatus',
				align : 'center',
				width : '5000'
			}, // 요청사항
			{
				label : '<spring:message code="std.label.req_result" />',
				name : 'reqStatusResult',
				align : 'center',
				width : '5000'
			}, // 요청결과
			]
		};

		var url = "/std/stdLect/downExcelStudentList.do";
		var form = $("<form></form>");
		form.attr("method", "POST");
		form.attr("name", "excelForm");
		form.attr("action", url);
		form.append($('<input/>', {
			type : 'hidden',
			name : 'crsCreCd',
			value : '<c:out value="${crsCreCd}" />'
		}));
		form.append($('<input/>', {
			type : 'hidden',
			name : 'disablilityYn',
			value : 'Y'
		}));
		form.append($('<input/>', {
			type : 'hidden',
			name : 'searchValue',
			value : $("#searchValueDisablility").val()
		}));
		form.append($('<input/>', {
			type : 'hidden',
			name : 'excelGrid',
			value : JSON.stringify(excelGrid)
		}));
		form.appendTo("body");
		form.submit();

		$("form[name=excelForm]").remove();
	}

	// 수강생 학습현황 팝업
	function studyStatusModal(stdNo) {
		// 모달 iframe 초기화
		var frameId = "studyStatusModalIfm";
		var frameHtml = '<iframe src="" width="100%" id="' + frameId + '" name="' + frameId + '"></iframe>';
		var $frameParent = $("#" + frameId).parent();
		
		$("#" + frameId).remove();
		$frameParent.append(frameHtml);
		$("#" + frameId).iFrameResize();
		
		$("#studyStatusForm > input[name='stdNo']").val(stdNo);
		$("#studyStatusForm").attr("target", frameId);
		$("#studyStatusForm").attr("action", "/std/stdPop/studyStatusPop.do");
		$("#studyStatusForm").submit();
		$('#studyStatusModal').modal('show');

		$("#studyStatusForm > input[name='stdNo']").val("");
	}

	// 장애학생 학습현황 팝업
	/* 
	function studyStatusDisablilityModal(stdNo) {
		$("#studyStatusDisablilityForm > input[name='stdNo']").val(stdNo);
		$("#studyStatusDisablilityForm > input[name='disablilityYn']").val("Y");
		$("#studyStatusDisablilityForm").attr("target", "studyStatusModalIfm");
		$("#studyStatusDisablilityForm").attr("action", "/std/stdPop/studyStatusPop.do");
		$("#studyStatusDisablilityForm").submit();
		$('#studyStatusModal').modal('show');

		$("#studyStatusDisablilityForm > input[name='stdNo']").val("");
	}
	 */

	// 메세지 보내기
	function sendMsg(type) {
		var rcvUserInfoStr = "";
		var sendCnt = 0;

		if (type == 1) {
			$.each($('#studentList').find("input:checkbox[name=userIds]:not(:disabled):checked"), function() {
				sendCnt++;
				if (sendCnt > 1)
					rcvUserInfoStr += "|";
				rcvUserInfoStr += $(this).val();
				rcvUserInfoStr += ";" + $(this).attr("user_nm");
				rcvUserInfoStr += ";" + $(this).attr("mobile");
				rcvUserInfoStr += ";" + $(this).attr("email");
			});
		} else {
			$.each($('#disablilityList').find("input:checkbox[name=userIds]:not(:disabled):checked"), function() {
				sendCnt++;
				if (sendCnt > 1)
					rcvUserInfoStr += "|";
				rcvUserInfoStr += $(this).val();
				rcvUserInfoStr += ";" + $(this).attr("user_nm");
				rcvUserInfoStr += ";" + $(this).attr("mobile");
				rcvUserInfoStr += ";" + $(this).attr("email");
			});
		}

		if (sendCnt == 0) {
			/* 메시지 발송 대상자를 선택하세요. */
			alert("<spring:message code='common.alert.sysmsg.select_user'/>");
			return;
		}

		window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");

		var form = document.alarmForm;
		form.action = '<%=CommConst.SYSMSG_URL_SEND%>';
        form.target = "msgWindow";
        form[name='alarmType'].value = "S"; // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
        form[name='rcvUserInfoStr'].value = rcvUserInfoStr; //보내는사람 정보
        form.submit();
	}
	
	// 학생의 강의실로 이동
	function goLearnerHome(userId) {
		var stuSupportWin = window.open("", "stuSupportWin");
		$("#userMoveForm").attr("action","/user/userHome/loginUserByCourseStd.do");
		$("#userMoveForm > input[name='userId']").val(userId);
		$("#userMoveForm > input[name='userId']").val(userId);
		$("#userMoveForm > input[name='goUrl']").val("/dashboard/stuDashboard.do");
		$('#userMoveForm').submit();
		$("#virtualSupport").show();
		
		var closeUserTimer = setInterval(function() {
			if (stuSupportWin.closed) {
				$.ajax({
					url : "/dashboard/closeVirtualSession.do",
					type: "POST",
					success : function(data, status, xr){
						$("#virtualSupport").hide();
					},
					error : function(xhr, status, error){
						$("#virtualSupport").hide();
					},
					timeout:3000	
				});
				clearInterval(closeUserTimer);
			}
		}, 1000);
	}
</script>
<body class="<%=SessionInfo.getThemeMode(request)%>">
	<div id="wrap" class="pusher">
		<%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>
		
		<div id="container">
			 <!-- class_top 인클루드  -->
        	<%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>
			
			<!-- 본문 content 부분 -->
			<div class="content stu_section">
            	<%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>
		        
		        <div class="ui form">
		        	<div class="layout2">
		        		<!-- 타이틀 -->
						<div id="info-item-box">
							<script>
							$(document).ready(function(){
								// set location
								setLocationBar("<spring:message code='std.label.learner_info' />");
							});
							</script>
						
		                    <h2 class="page-title flex-item flex-wrap gap4 columngap16">
		                    	<spring:message code="std.label.learner_info" />
		                    </h2>
		                    <div class="button-area">
		                    </div>
		                </div>
		                
		                <!-- 영역1 -->
                        <div class="row">
                            <div class="col">
                            	<!-- 검색조건 -->
								<div class="option-content mb10">
									<select class="ui dropdown mr5" id="searchKey" onchange="list()">
										<option value=" "><spring:message code="common.all" /><!-- 전체 --></option>
										<option value="normal" selected><spring:message code="std.label.learner" /><!-- 수강생 --></option>
										<option value="repeatYn"><spring:message code="std.label.repeat" /><!-- 재수강 --></option>
										<option value="disablilityY"><spring:message code="std.label.dis_studend" /><!-- 장애학생 --></option>
										<option value="auditY"><spring:message code="std.label.auditor" /><!-- 청강생 --></option>
										<option value="gvupYnY">
											<c:choose>
												<c:when test="${creCrsVO.uniCd eq 'G'}">
													<spring:message code="std.label.gvup.yn.g" /><!-- 수강철회 -->
												</c:when>
												<c:otherwise>
													<spring:message code="std.label.gvup.yn.c" /><!-- 수강포기 -->
												</c:otherwise>
											</c:choose>
										</option>
							        </select>
									<div class="ui action input search-box">
										<input id="searchValue" type="text" placeholder="<spring:message code="std.common.placeholder" />" value="${param.searchValue}" />
										<button class="ui icon button" type="button" onclick="list()">
											<i class="search icon"></i>
										</button>
									</div>
									<h3 class="ml5">(<spring:message code="std.label.total_cnt" /><!-- 총 -->&nbsp;:&nbsp;<span id="totalCntText">0</span><spring:message code="message.person" /><!-- 명 -->)</h3>
									<div class="select_area">
										<uiex:msgSendBtn func="sendMsg(1)" styleClass="ui basic small button"/><!-- 메시지 -->
										<a href="javascript:void(0)" onclick="downExcel();return false;" class="ui basic small button"><spring:message code="common.button.excel_down" /><!-- 엑셀 다운로드 --></a>
									</div>
								</div>
                            	
                           		<table id="studentListTable" class="table type2" data-sorting="true" data-paging="false" data-empty="<spring:message code="common.content.not_found" />">
									<thead>
										<tr>
											<th scope="col" data-sortable="false" class="chk tc">
					                            <div class="ui checkbox">
					                                <input type="checkbox" onchange="checkAll(this.checked)" />
					                            </div>
					                        </th>
											<th scope="col" data-sortable="false" data-type="number" class="num tc"><spring:message code="common.number.no" /></th>
											<th scope="col" data-breakpoints="xs" class="tc"><spring:message code="std.label.dept" /><!-- 학과 --></th>
											<th scope="col" class="tc"><spring:message code="std.label.user_id" /><!-- 학번 --></th>
											<th scope="col" class="tc"><spring:message code="std.label.hy" /><!-- 학년 --></th>
											<c:if test="${creCrsVO.univGbn eq '3' or creCrsVO.univGbn eq '4'}">
											<th scope="col" class="tc"><spring:message code="common.label.grsc.degr.cors.gbn" /><!-- 학위과정 --></th>
											</c:if>
											<th scope="col" class="tc"><spring:message code="std.label.name" /><!-- 이름 --></th>
											<th scope="col" class="tc"><spring:message code="std.label.enter.year" /><!-- 입학년도 --></th>
											<th scope="col" class="tc"><spring:message code="std.label.readmi.year" /><!-- 재입학년도 --></th>
											<th scope="col" class="tc"><spring:message code="std.label.enter.hy" /><!-- 입학학년 --></th>
											<th scope="col" class="tc"><spring:message code="std.label.enter.gbn" /><!-- 입학구분 --></th>
											<th scope="col" data-sortable="false" data-breakpoints="xs" class="tc"><spring:message code="std.label.type" /><!-- 구분 --></th>
											<th scope="col" data-breakpoints="xs" class="tc"><spring:message code="std.label.risk_index" /><!-- 위험지수 --></th>
											<th scope="col" data-breakpoints="xs" class="tc"><spring:message code="std.label.risk_grade" /><!-- 위험등급 --></th>
											<th scope="col" data-sortable="false" data-breakpoints="xs sm" class="tc"><spring:message code="std.label.manage" /><!-- 관리 --></th>
										</tr>
									</thead>
									<tbody id="studentList">
									</tbody>
								</table>
								
								<div class="tr">
									<uiex:msgSendBtn func="sendMsg(1)" styleClass="ui basic small button"/><!-- 메시지 -->
									<a href="javascript:void(0)" onclick="downExcel();return false;" class="ui basic small button"><spring:message code="common.button.excel_down" /><!-- 엑셀 다운로드 --></a>
								</div>
                            </div><!-- //col -->
                        </div><!-- //row -->
                        
                        <!-- 영역2 -->
                        <div class="row" style="display: none;">
                            <div class="col">
                            	<h3 class="mb10">•&nbsp;<spring:message code="std.label.dis_studend_info" /><!-- 장애학생 현황 --></h3>
                            	
                            	<!-- 검색조건 -->
								<div class="option-content mb10">
									<div class="ui action input search-box">
										<input id="searchValueDisablility" type="text" placeholder="<spring:message code="std.common.placeholder" />" value="${param.searchValue}" />
										<button class="ui icon button" type="button" onclick="listDisablility()">
											<i class="search icon"></i>
										</button>
									</div>
									
									<div class="select_area">
										<uiex:msgSendBtn func="sendMsg(2)"/><!-- 메시지 -->
										<a href="javascript:void(0)" onclick="downExcelDisablility()" class="ui basic button"><spring:message code="common.button.excel_down" /><!-- 엑셀 다운로드 --></a>
									</div>
								</div>
                            
                            	<table id="disablilityListTable" class="table type2" data-sorting="true" data-paging="false" data-empty="<spring:message code="common.content.not_found" />">
									<thead>
										<tr>
											<th scope="col" data-sortable="false" class="chk tc">
					                            <div class="ui checkbox">
					                                <input type="checkbox" onchange="checkAllDisablility(this.checked)" />
					                            </div>
					                        </th>
											<th scope="col" data-sortable="false" data-type="number" class="num tc"><spring:message code="common.number.no" /></th>
											<th scope="col" data-breakpoints="xs sm" class="tc"><spring:message code="std.label.dept" /><!-- 학과 --></th>
											<th scope="col" class="tc"><spring:message code="std.label.user_id" /><!-- 학번 --></th>
											<th scope="col" class="tc"><spring:message code="std.label.name" /><!-- 이름 --></th>
											<th scope="col" data-sortable="false" data-breakpoints="xs sm" class="tc"><spring:message code="std.label.type" /><!-- 구분 --></th>
											<th scope="col" data-sortable="false" data-breakpoints="xs sm" class="tc"><spring:message code="std.label.learn_status" /><!-- 수강상태 --></th>
											<th scope="col" data-sortable="false" data-breakpoints="xs sm" class="tc"><spring:message code="std.label.mobile" /><!-- 휴대전화 --></th>
											<th scope="col" data-sortable="false" data-breakpoints="xs sm" class="tc"><spring:message code="std.label.email" /><!-- 이메일 --></th>
											<th scope="col" data-sortable="false" data-breakpoints="xs" class="tc"><spring:message code="std.label.dis_type" /><!-- 장애종류 --></th>
											<th scope="col" data-sortable="false" data-breakpoints="xs" class="tc"><spring:message code="std.label.dis_level" /><!-- 장애등급 --></th>
											<th scope="col" data-sortable="false" data-breakpoints="xs" class="tc"><spring:message code="std.label.req_info" /><!-- 요청사항 --></th>
											<th scope="col" data-sortable="false" data-breakpoints="xs" class="tc"><spring:message code="std.label.req_result" /><!-- 요청결과 --></th>
											<th scope="col" data-sortable="false" data-breakpoints="xs sm" class="tc"><spring:message code="std.label.manage" /><!-- 관리 --></th>
										</tr>
									</thead>
									<tbody id="disablilityList">
									</tbody>
								</table>
                            </div>
                        </div>
                        
		        	</div><!-- //layout2 -->
		        </div><!-- //ui form -->
			</div><!-- //content stu_section -->
			
			<%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
		</div><!-- //container -->
				
	</div><!-- //wrap -->
	
	<!-- 수강생 학습현황 팝업 --> 
	<form id="studyStatusForm" name="studyStatusForm">
		<input type="hidden" name="crsCreCd" value="<c:out value="${crsCreCd}" />" />
		<input type="hidden" name="stdNo" />
	</form>
	<form id="studyStatusDisablilityForm" name="studyStatusDisablilityForm">
		<input type="hidden" name="crsCreCd" value="<c:out value="${crsCreCd}" />" />
		<input type="hidden" name="stdNo" />
		<input type="hidden" name="disablilityYn" />
	</form>
    <div class="modal fade in" id="studyStatusModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="std.label.learner_status" />" aria-hidden="false" style="display: none; padding-right: 17px;">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="common.button.close" />">
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
    
   	<form id="userMoveForm" name="userMoveForm" method="post" target="stuSupportWin">
		<input type="hidden" name="userId" value=""/>
		<input type="hidden" name="userId" value=""/>
		<input type="hidden" name="modChgFromMenuCd" value="PRO0000000034"/>
		<input type="hidden" name="goUrl" value=""/>
	</form>
	
	<div id="virtualSupport" style='display:none;position:fixed;top:0;right:0;bottom:0;left:0;z-index:2000;outline:0;background-color:rgba(255,255,255,0.8)'>
		<div style="background:#fff;border:1px solid #000;text-align:center;margin-top:calc(50vh - 100px);margin-left:auto;margin-right:auto;width:500px;padding:40px;font-size:1.2em">
			<div>작업중...</div>
		</div>
	</div>
</body>