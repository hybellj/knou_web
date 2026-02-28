<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/quiz/common/quiz_common_inc.jsp" %>

<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />

<script type="text/javascript">
	$(document).ready(function() {
		listExamUser(1);

		$("#searchValue").on("keyup", function(e) {
			if(e.keyCode == 13) {
				listExamUser(1);
			}
		});

		$('.toggle-icon').click(function() {
            $(this).toggleClass("ion-plus ion-minus");
        });

		$(".accordion").accordion();
	});

	function manageQuiz(tab) {
		var urlMap = {
			"1" : "/quiz/quizQstnManage.do",	// 퀴즈 문제 관리 페이지
			"2" : "/quiz/quizRetakeManage.do",	// 퀴즈 재응시 관리 페이지
			"3" : "/quiz/quizScoreManage.do",	// 퀴즈 평가 관리 페이지
			"4" : "/quiz/Form/editQuiz.do",		// 퀴즈 수정 페이지
			"9" : "/quiz/profQzListView.do"		// 목록
		};

		var kvArr = [];
		kvArr.push({'key' : 'examCd', 	'val' : "${vo.examCd}"});
		kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});

		submitForm(urlMap[tab], "", "", kvArr);
	}

 	// 퀴즈 평가 참여자 리스트 조회
	function listExamUser(page) {
		var univGbn = "${creCrsVO.univGbn}";
		var url  = "/quiz/quizStareUserList.do";
		var data = {
			"examCd" 	  : "${vo.examCd}",
			"pageIndex"   : page,
			"listScale"   : 1000,
			"searchKey"   : $("#searchKey").val(),
			"searchValue" : $("#searchValue").val(),
			"searchMenu"  : $("#searchMenu").val(),
			"pagingYn"	  : "N",
			"examTypeCd"  : "${vo.examTypeCd}"
		};

		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		var returnList = data.returnList || [];

				var html = "";
        		var stdNos = $("#stdNos").val().split(",");
        		returnList.forEach(function(v, i) {
        			var totGetScore = (v.totGetScore == null || v.evalYn != "Y") && v.stareYn == "N" ? '-' : v.totGetScore;
        			var evalYn = v.evalYn == "N" ? "<spring:message code='exam.common.no' />"/* 아니오 */ : "<spring:message code='exam.common.yes' />"/* 예 */;
        			var stareCnt    = v.stareCnt == null ? 0 : v.stareCnt;
        			var isChecked   = false;
        			if(stdNos != "") {
        				stdNos.forEach(function(vv, ii) {
        					if(vv == v.stdNo) {
        						isChecked = true;
        					}
        				});
        			}
        			var hstyTypeNm  = "<spring:message code='exam.label.no.stare' />"/* 미응시 */;
        			if(v.hstyTypeCd == "REEXAM") hstyTypeNm = "<spring:message code='exam.label.reexam.no.stare' />"/* 재응시미완료 */;
        			if(v.hstyTypeCd == "START" || v.hstyTypeCd == "RESTORE") hstyTypeNm = "<spring:message code='exam.label.complete.stare' />"/* 응시완료 */;
        			if(v.hstyTypeCd == "COMPLETE") {
        				hstyTypeNm = v.reExamYn == "Y" ? "<spring:message code='exam.label.reexam.complete.stare' />"/* 재응시완료 */ : "<spring:message code='exam.label.complete.stare' />"/* 응시완료 */;
        			}
        			html += `<tr data-stdNo="\${v.stdNo}">`;
        			html += `	<td class='tc'>`;
        			html += `		<div class='ui checkbox'>`;
        			html += `			<input type='checkbox' name='evalChk' id='evalChk\${i}' data-stdNo='\${v.stdNo}' onchange="checkStdNoToggle(this)" \${isChecked ? 'checked' : ''} user_id='\${v.userId}' user_nm='\${v.userNm}' mobile='\${v.mobileNo}' email='\${v.email}'>`;
        			html += `			<label class='toggle_btn' for='evalChk\${i}'></label>`;
        			html += `		</div>`;
        			html += `	</td>`;
        			html += `	<td name='lineNo'>\${v.lineNo}</td>`;
        			html += `	<td data-sort-value="\${v.deptNm}" class='word_break_none'>\${v.deptNm }</td>`;
        			html += `	<td data-sort-value="\${v.userId}" class='tc word_break_none'>\${v.userId }</td>`;
        			html += `	<td data-sort-value="\${v.hy}" class='tc'>\${v.hy }</td>`;
        			if(univGbn == "3" || univGbn == "4") {
						html += '<td class="tc word_break_none">' + (v.grscDegrCorsGbnNm || '-') + '</td>';
					}
        			html += `	<td data-sort-value="\${v.userNm}" class='tc word_break_none'>\${v.userNm }`;
        			html += 	userInfoIcon("<%=SessionInfo.isKnou(request)%>", "userInfoPop('"+v.userId+"')");
        			html += `	</td>`;
        			html += `	<td data-sort-value="\${v.entrYy}" class="tc">\${v.entrYy}</td>`;
        			html += `	<td data-sort-value="\${v.entrHy}" class="tc">\${v.entrHy}</td>`;
        			html += `	<td data-sort-value="\${v.entrGbnNm}" class="tc word_break_none">\${v.entrGbnNm}</td>`;
        			//html += `	<td data-sort-value="\${v.konanMaxCopyRate || '-1'}" class="tc">\${v.konanMaxCopyRate ? '<a class="fcBlue" href="${konanCopyScoreUrl}?domain=e_quiz&docId=' + (v.stdNo + v.examCd) + '" target="_blank">' + v.konanMaxCopyRate + '%' + '</a>' : '-'}</td>`;
        			html += `	<td data-sort-value="\${totGetScore}" class='tc word_break_none' onclick="stareInputForm('\${v.stdNo}')">`;
        			html += `		<p id="\${v.stdNo}_viewScore" style="display:inline-block;">\${totGetScore}<spring:message code="exam.label.score.point" /></p>`;/* 점 */
        			html += `		<input type="number" class="num" step="0.1" style="display:none" id="\${v.stdNo}_score" value="\${totGetScore }" />`;
        			html += `	</td>`;
        			html += `	<td data-sort-value="\${evalYn}" class='tc'>\${evalYn}</td>`;
        			html += `	<td data-sort-value="\${hstyTypeNm}" class='tc'>\${hstyTypeNm }</td>`;
        			html += `	<td data-sort-value="\${stareCnt}" class='tc'>\${stareCnt }<spring:message code="exam.label.times" /></td>`;
        			html += `	<td class='tc '>`;
        			html += `		<a href="javascript:quizQstnEvalPop('\${v.examCd }', '\${v.stdNo }')" class="ui mini basic button"><spring:message code="exam.label.paper" />​</a>`;/* 시험지 */
        			html += `		<a href="javascript:quizRecordViewPop('\${v.examCd }', '\${v.stdNo }')" class="ui mini basic button"><spring:message code="exam.button.stare.hsty" /></a>`;/* 응시기록 */
        			html += `		<a href="javascript:stdMemoForm('\${v.examCd}', '\${v.stdNo}')" class="ui mini basic button"><spring:message code="exam.label.memo" /></a>`;/* 메모 */
        			html += `		<a href="javascript:initQuizStare('\${v.examCd}', '\${v.stdNo}')" class="ui mini basic button"><spring:message code="exam.label.quiz" /><spring:message code="exam.button.init" />​</a>`;/* 퀴즈 *//* 초기화 */
        			html += `	</td>`;
        			html += `</tr>`;
        		});
        		$("#quizStareUserList").empty().append(html);
		    	$("#quizStareUserTable").footable({
   					on: {
   						"after.ft.sorting": function(e, ft, sorter){
   							$("#quizStareUserList tr").each(function(z, k){
   								$(k).find("td[name=lineNo]").html((z+1));
   							});
   						}
   					}
   				});

		    	$("#totalCntText").text(returnList.length);
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
		});
	}

	// 퀴즈 시험지 보기
	function quizQstnEvalPop(examCd, stdNo) {
		// 버튼 클릭 위치 표시용
		btnFocuesd(stdNo);

		var kvArr = [];
		kvArr.push({'key' : 'examCd', 	   'val' : examCd});
		kvArr.push({'key' : 'stdNo', 	   'val' : stdNo});
		kvArr.push({'key' : 'searchValue', 'val' : $("#searchValue").val()});
		kvArr.push({'key' : 'crsCreCd',    'val' : "${vo.crsCreCd}"});

		submitForm("/quiz/quizQstnEvalPop.do", "quizPopIfm", "qstnEval", kvArr);
	}

	// 응시 기록 보기
	function quizRecordViewPop(examCd, stdNo) {
		// 버튼 클릭 위치 표시용
		btnFocuesd(stdNo);

		var kvArr = [];
		kvArr.push({'key' : 'examCd', 	'val' : examCd});
		kvArr.push({'key' : 'stdNo', 	'val' : stdNo});
		kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});

		submitForm("/quiz/quizRecordViewPop.do", "quizPopIfm", "recordView", kvArr);
	}

	// 버튼 클릭 focused
	function btnFocuesd(stdNo) {
		$("#quizStareUserList > tr").removeClass("focused");
		$("#quizStareUserList > tr[data-stdNo='"+stdNo+"']").addClass("focused");
	}

	// 퀴즈 초기화
	function initQuizStare(examCd, stdNo) {
		var confirm = window.confirm("<spring:message code='exam.label.quiz' /> <spring:message code='exam.confirm.init' />");/* 퀴즈 *//* 초기화를 하시겠습니까? */

		if(confirm) {
			var url  = "/quiz/editInitQuizStare.do";
			var data = {
				"examCd" : examCd,
				"stdNo"  : stdNo
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		alert("<spring:message code='exam.label.quiz' /> <spring:message code='exam.alert.init' />");/* 퀴즈 *//* 초기화가 완료되었습니다. */
	        		listExamUser(1);
	            } else {
	             	alert(data.message);
	            }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='exam.error.init' />");/* 초기화 중 에러가 발생하였습니다. */
    		});
		}
	}

	// 점수 가감 아이콘 표시 확인
	function plusMinusIconControl(scoreType){
		if(scoreType == 'batch'){
			$(".link.icon.toggle-icon").hide();
		}else if(scoreType == 'addition'){
			$(".link.icon.toggle-icon").show();
		}
	}

	// 일괄 점수 저장
	function submitScore() {
		if($("input[name='scoreType']:checked").val() == undefined){
			alert("<spring:message code='exam.alert.select.score.type' />");/* 성적 처리 유형을 선택하세요. */
			return false;
		}
		if($("#scoreValue").val() == "" || $("#scoreValue").val() == undefined){
			alert("<spring:message code='exam.alert.input.score' />");/* 점수를 입력하세요. */
			return false;
		}

		if($("#scoreValue").val() > 100) {
			alert("<spring:message code='exam.alert.score.max.100' />");/* 점수는 100점 까지 입력 가능 합니다. */
			return false;
		}

		var stdNos = $("#stdNos").val();
		var score = $("#scoreValue").val();
		if($("input[name='scoreType']:checked").val() == "addition"){
			if(!$(".toggle-icon").attr("class").includes("ion-plus")){
				score = score * (-1);
			}
		}

		if(isNaN(score)) {
			alert("<spring:message code='exam.error.input.invalid' />"); // 잘못된 값이 입력되었습니다. 다시 입력해주세요.
			$("#scoreValue").val("");
			return;
		}

		var url  = "/quiz/updateExamStareScore.do";
		var data = {
			"examCd"        : "${vo.examCd}",
			"stdNos"        : stdNos,
			"totGetScore"   : score,
			"scoreType"     : $("input[name='scoreType']:checked").val(),
			"crsCreCd"		: "${vo.crsCreCd}",
		};

		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		alert("<spring:message code='exam.alert.batch.score' />");/* 일괄 점수 등록이 완료되었습니다. */
        		$("#stdNos").val("");
        		$("#scoreValue").val("");
        		listExamUser(1);
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.batch.score' />");/* 일괄 점수 등록 중 에러가 발생하였습니다. */
		});
	}

	// 메모 팝업
	function stdMemoForm(examCd, stdNo) {
		// 버튼 클릭 위치 표시용
		btnFocuesd(stdNo);

		var kvArr = [];
		kvArr.push({'key' : 'examCd', 	'val' : examCd});
		kvArr.push({'key' : 'stdNo', 	'val' : stdNo});
		kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});

		submitForm("/quiz/quizProfMemoPop.do", "quizPopIfm", "profMemo", kvArr);
	}

	// 엑셀 성적 등록
	function callScoreExcelUpload() {
		var kvArr = [];
		kvArr.push({'key' : 'examCd', 	'val' : "${vo.examCd}"});
		kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});

		submitForm("/quiz/quizScoreExcelUploadPop.do", "quizPopIfm", "scoreExcel", kvArr);
	}

	// 엑셀 다운로드
	function quizStatusExcelDown() {
		var univGbn = "${creCrsVO.univGbn}";
		var hstyTypeCdObj = {
			  SET: "<spring:message code='exam.label.no.stare' />" // 미응시
			, REEXAM: "<spring:message code='exam.label.reexam.no.stare' />" // 재응시미완료
			, START: "<spring:message code='exam.label.complete.stare' />" // 응시완료
			, RESTORE: "<spring:message code='exam.label.complete.stare' />" // 응시완료
			, COMPLETE: "<spring:message code='exam.label.complete.stare' />" // 응시완료
		};

		var excelGrid = { colModel: [] };

		excelGrid.colModel.push({label: 'No.', name: 'lineNo', align: 'center', width: '1000'}); // No.
		excelGrid.colModel.push({label: "<spring:message code='exam.label.dept' />", name: 'deptNm', align: 'left', width: '5000'}); // 학과
		excelGrid.colModel.push({label: "<spring:message code='exam.label.user.no' />", name: 'userId', align: 'left', width: '5000'}); // 학번
		excelGrid.colModel.push({label: "<spring:message code='exam.label.user.grade' />", name: 'hy', align: 'center', width: '1000'}); // 학년
		if(univGbn == "3" || univGbn == "4") {
			excelGrid.colModel.push({label: '<spring:message code="common.label.grsc.degr.cors.gbn" />', name: 'grscDegrCorsGbnNm', align: 'left', width: '4000'}); // 학위과정
		}
		excelGrid.colModel.push({label: "<spring:message code='exam.label.user.nm' />", name: 'userNm', align: 'right', width: '5000'}); // 이름
		excelGrid.colModel.push({label: "<spring:message code='exam.label.admission.year' />", name: 'entrYy', align: 'left', width: '5000'}); // 입학년도
		excelGrid.colModel.push({label: "<spring:message code='exam.label.admission.grade' />", name: 'entrHy', align: 'left', width: '5000'}); // 입학학년
		excelGrid.colModel.push({label: "<spring:message code='exam.label.admission.type' />", name: 'entrGbnNm', align: 'left', width: '5000'}); // 입학구분
		excelGrid.colModel.push({label: "<spring:message code='exam.label.eval.score' />", name: 'stareScore', align: 'right', width: '5000'}); // 평가점수
		excelGrid.colModel.push({label: "<spring:message code='exam.label.situation' />", name: 'hstyTypeCd', align: 'right', width: '5000', codes: hstyTypeCdObj}); // 상황
		excelGrid.colModel.push({label: "<spring:message code='exam.label.stare.count' />", name: 'stareCnt', align: 'right', width: '5000'}); // 응시횟수


		var kvArr = [];
		kvArr.push({'key' : 'examCd', 	   'val' : "${vo.examCd}"});
		kvArr.push({'key' : 'stdNos', 	   'val' : $("#stdNos").val()});
		kvArr.push({'key' : 'searchValue', 'val' : $("#searchValue").val()});
		kvArr.push({'key' : 'excelGrid',   'val' : JSON.stringify(excelGrid)});

		submitForm("/quiz/quizStatusExcelDown.do", "", "", kvArr);
	}

	// 시험지 일괄 엑셀 다운로드
	function allQuizPaperExcelDown() {
		var kvArr = [];
		kvArr.push({'key' : 'examCd', 'val' : "${vo.examCd}"});

		submitForm("/quiz/allQuizPaperExcelDown.do", "", "", kvArr);
	}

    // 전체 선택 / 해제
    function checkAllStdNoToggle(obj) {
        $("input:checkbox[name=evalChk]").prop("checked", $(obj).is(":checked"));

        $('input:checkbox[name=evalChk]').each(function (idx) {
            if ($(obj).is(":checked")) {
                addSelectedStdNos($(this).attr("data-stdNo"));
                $(this).closest("tr").addClass("on");
            } else {
                removeSelectedStdNos($(this).attr("data-stdNo"));
                $(this).closest("tr").removeClass("on");
            }
        });
    }

    // 한건 선택 / 해제
    function checkStdNoToggle(obj) {
        if ($(obj).is(":checked")) {
            addSelectedStdNos($(obj).attr("data-stdNo"));
            $(obj).closest("tr").addClass("on");
        } else {
            removeSelectedStdNos($(obj).attr("data-stdNo"));
            $(obj).closest("tr").removeClass("on");
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
    function addSelectedStdNos(stdNo) {
        var selectedStdNos = $("#stdNos").val();
        if (selectedStdNos.indexOf(stdNo) == -1) {
            if (selectedStdNos.length > 0) {
                selectedStdNos += ',';
            }
            selectedStdNos += stdNo;
            $("#stdNos").val(selectedStdNos);
        }
    }

    // 선택된 학습자 번호 제거
    function removeSelectedStdNos(stdNo) {
        var selectedStdNos = $("#stdNos").val();
        if (selectedStdNos.indexOf(stdNo) > -1) {
            selectedStdNos = selectedStdNos.replace(stdNo, "");
            selectedStdNos = selectedStdNos.replace(",,", ",");
            selectedStdNos = selectedStdNos.replace(/^[,]*/g, '');
            selectedStdNos = selectedStdNos.replace(/[,]*$/g, '');
            $("#stdNos").val(selectedStdNos);
        }
    }

	// 메세지 보내기
	function sendMsg() {
		var rcvUserInfoStr = "";
		var sendCnt = 0;

		$.each($('#quizStareUserList').find("input:checkbox[name=evalChk]:not(:disabled):checked"), function() {
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

	// 퀴즈 삭제
	function delQuiz() {
		if("${vo.examStartUserCnt}" > 0) {
			confirm = window.confirm(`<spring:message code="exam.label.quiz" /> <spring:message code="exam.confirm.exist.answer.user.y" />`);/* 퀴즈 *//* 응시한 학습자가 있습니다. 삭제 시 학습정보가 삭제됩니다.\r\n정말 삭제하시겠습니까? */
		} else {
			confirm = window.confirm("<spring:message code='exam.label.quiz' /> <spring:message code='exam.confirm.exist.answer.user.n' />");/* 퀴즈 *//* 응시한 학습자가 없습니다. 삭제 하시겠습니까? */
		}
		if(confirm) {
			var url  = "/quiz/delQuiz.do";
			var data = {
				  examCd 	: "${vo.examCd}"
				, crsCreCd	: "${vo.crsCreCd}"
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		alert("<spring:message code='exam.alert.delete' />");/* 정상 삭제 되었습니다. */
	        		manageQuiz(9);
	            } else {
	             	alert(data.message);
	            }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='exam.error.delete' />");/* 삭제 중 에러가 발생하였습니다. */
    		});
		}
	}

	// 응시현황 팝업
	function quizChartPop() {
		var kvArr = [];
		kvArr.push({'key' : 'examCd', 	  'val' : "${vo.examCd}"});
		kvArr.push({'key' : 'examTypeCd', 'val' : "${vo.examTypeCd}"});
		kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});

		submitForm("/quiz/quizScoreChartPop.do", "quizPopIfm", "starePop", kvArr);
	}

	// 평가점수 폼
	function stareInputForm(stdNo) {
		$("#"+stdNo+"_score").show();
		$("#"+stdNo+"_viewScore").hide();

		$("#"+stdNo+"_score").mouseout(function(e) {
			if(!($(e.target).val() == '' || $(e.target).val() == '-')) {
				var totGetScore = $(e.target).val();
				if(totGetScore > 100) {
					totGetScore = 100;
				}

				var url  = "/quiz/updateExamStareScore.do";
				var data = {
					"examCd"        : "${vo.examCd}",
					"stdNos"        : stdNo,
					"totGetScore"   : totGetScore,
					"scoreType"     : "batch",
					"crsCreCd"		: "${vo.crsCreCd}",
				};

				ajaxCall(url, data, function(data) {
					if (data.result > 0) {
						listExamUser(1);
		            } else {
		             	alert(data.message);
		            }
				}, function(xhr, status, error) {
					alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
				});
			}
		});
	}

	// 팝업 점수 저장
	function qstnScoreEdit() {
		listExamUser(1);
	}
</script>

<body class="<%=SessionInfo.getThemeMode(request)%>">
    <div id="wrap" class="pusher">

        <!-- class_top 인클루드  -->
        <%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>

        <div id="container">
            <%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>

            <!-- 본문 content 부분 -->
            <div class="content stu_section">
            	<%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>

        		<div class="ui form">
        			<div class="layout2">
						<script>
							$(document).ready(function () {
								// set location
								setLocationBar('<spring:message code="exam.label.quiz" />', '<spring:message code="exam.label.info.score.manage" />'); // 퀴즈 정보 및 평가
							});
						</script>

		                <div id="info-item-box">
		                	<h2 class="page-title flex-item flex-wrap gap4 columngap16">
                                <spring:message code="exam.label.quiz" /><!-- 퀴즈 -->
                            </h2>
                            <div class="button-area">
                            	<a href="javascript:manageQuiz(4)" class="ui blue button"><spring:message code="exam.button.mod" /></a><!-- 수정 -->
								<a href="javascript:delQuiz()" class="ui basic button"><spring:message code="exam.button.del" /></a><!-- 삭제 -->
								<a href="javascript:manageQuiz(9)" class="ui basic button"><spring:message code="exam.button.list" /></a><!-- 목록 -->
                            </div>
		                </div>
		                <div class="row">
		                	<div class="col">
		                		<div class="listTab">
			                        <ul>
			                            <li class="mw120"><a onclick="manageQuiz(1)"><spring:message code="eaxm.tab.qstn.manage" /></a></li><!-- 문제 관리 -->
			                            <c:if test="${vo.reExamYn eq 'Y'}">
				                            <li class="mw120"><a onclick="manageQuiz(2)"><spring:message code="exam.tab.reexam.manage" /></a></li><!-- 미응시 관리 -->
			                            </c:if>
			                            <li class="select mw120"><a onclick="manageQuiz(3)"><spring:message code="exam.label.info.score.manage" /></a></li><!-- 정보 및 평가 -->
			                        </ul>
			                    </div>
								<div class="ui styled fluid accordion week_lect_list card" style="border: none;">
									<div class="title">
										<div class="title_cont">
											<div class="left_cont">
												<div class="lectTit_box">
													<spring:message code="exam.common.yes" var="yes" /><!-- 예 -->
													<spring:message code="exam.common.no" var="no" /><!-- 아니오 -->
													<fmt:parseDate var="startDateFmt" pattern="yyyyMMddHHmmss" value="${vo.examStartDttm }" />
													<fmt:formatDate var="examStartDttm" pattern="yyyy.MM.dd HH:mm" value="${startDateFmt }" />
													<fmt:parseDate var="endDateFmt" pattern="yyyyMMddHHmmss" value="${vo.examEndDttm }" />
													<fmt:formatDate var="examEndDttm" pattern="yyyy.MM.dd HH:mm" value="${endDateFmt }" />
													<p class="lect_name">${fn:escapeXml(vo.examTitle) }</p>
													<span class="fcGrey">
														<small><spring:message code="exam.label.quiz" /><!-- 퀴즈 --> <spring:message code="exam.label.period" /><!-- 기간 --> : ${examStartDttm } ~ ${examEndDttm }</small> |
														<small><spring:message code="exam.label.score.aply.y" /><!-- 성적반영 --> : ${vo.scoreAplyYn eq 'Y' ? yes : no }</small> |
														<small><spring:message code="exam.label.score.open.y" /><!-- 성적공개 --> : ${vo.scoreOpenYn eq 'Y' ? yes : no }</small> |
														<small>
															<spring:message code="exam.label.qstn.status" /><!-- 문제출제상태 --> :
															<c:choose>
																<c:when test="${vo.examSubmitYn eq 'Y' or vo.examSubmitYn eq 'M'}">
																	<span><spring:message code="exam.label.qstn.submit.y" /><!-- 출제완료 --></span>
																</c:when>
																<c:otherwise>
																	<span class="fcRed"><spring:message code="exam.label.qstn.temp.save" /><!-- 임시저장 --></span>
																</c:otherwise>
															</c:choose>
														</small>
													</span>
												</div>
											</div>
										</div>
										<i class="dropdown icon ml20"></i>
									</div>
									<div class="content">
										<div class="ui segment">
											<ul class="tbl">
												<li>
                                                    <dl>
                                                        <dt>
                                                            <label for="lessonScheduleNm"><spring:message code='common.week'/><!-- 주차 --></label>
                                                        </dt>
                                                        <dd>
                                                        	${vo.lessonScheduleNm}
                                                        </dd>
                                                    </dl>
                                                </li>
												<li>
													<dl>
														<dt>
															<label for="subjectLabel"><spring:message code="exam.label.quiz" /><spring:message code="exam.label.cts" /></label><!-- 퀴즈 --><!-- 내용 -->
														</dt>
														<dd><pre>${vo.examCts }</pre></dd>
													</dl>
												</li>
												<li>
													<dl>
														<dt>
															<label><spring:message code="exam.label.quiz" /><!-- 퀴즈 --><spring:message code="exam.label.period" /><!-- 기간 --></label>
														</dt>
														<dd>${examStartDttm } ~ ${examEndDttm }</dd>
														<dt>
															<label><spring:message code="exam.label.view.qstn.type" /><!-- 문제표시방식 --></label>
														</dt>
														<dd>
															<c:choose>
																<c:when test="${vo.viewQstnTypeCd eq 'ALL' }">
																	<spring:message code="exam.label.all.view.qstn" /><!-- 전체문제 표시 -->
																</c:when>
																<c:otherwise>
																	<spring:message code="exam.label.each.view.qstn" /><!-- 페이지별로 1문제씩 표시 -->
																</c:otherwise>
															</c:choose>
														</dd>
													</dl>
												</li>
												<li>
													<dl>
														<dt>
															<label for="teamLabel"><spring:message code="exam.label.quiz" /><spring:message code="exam.label.time" /></label><!-- 퀴즈 --><!-- 시간 -->
														</dt>
														<dd>${vo.examStareTm }<spring:message code="exam.label.stare.min" /><!-- 분 --></dd>
														<dt>
															<label><spring:message code="exam.label.empl.random" /><!-- 보기 섞기 --></label>
														</dt>
														<dd>${vo.emplRandomYn eq 'Y' ? yes : no }</dd>
													</dl>
												</li>
												<li>
													<dl>
														<dt>
															<label for=""><spring:message code="exam.tab.reexam.manage" /></label><!-- 재응시 사용 -->
														</dt>
														<dd>
															<c:choose>
																<c:when test="${vo.reExamYn eq 'Y'}">
																	<spring:message code="exam.common.yes" /><!-- 예 -->
																</c:when>
																<c:otherwise>
																	<spring:message code="exam.common.no" /><!-- 아니오 -->
																</c:otherwise>
															</c:choose>
														</dd>
														<dt>
															<label><spring:message code="exam.label.grade.score" /><!-- 성적 --><spring:message code="exam.label.score.aply.rate" /><!-- 반영비율 --></label>
														</dt>
														<dd>${vo.scoreAplyYn eq 'Y' ? vo.examStareTypeCd eq 'M' or vo.examStareTypeCd eq 'L' ? '100' : vo.scoreRatio : '0' }%</dd>
													</dl>
												</li>
												<li>
													<dl>
														<dt>
															<label for="contLabel"><spring:message code="exam.label.file" /></label><!-- 첨부파일 -->
														</dt>
														<dd>
															<c:forEach var="list" items="${vo.fileList }">
																<button class="ui icon small button" id="file_${list.fileSn }" title="파일다운로드" onclick="fileDown(`${list.fileSn }`, `${list.repoCd }`)"><i class="ion-android-download"></i> </button>
																<script>
																	byteConvertor("${list.fileSize}", "${list.fileNm}", "${list.fileSn}");
																</script>
															</c:forEach>
														</dd>
													</dl>
												</li>
											</ul>
										</div>
									</div>
								</div>
								<div class="ui segment">
									<div class="option-content mb15">
										<div class="ui mla">
											<a href="javascript:callScoreExcelUpload()" class="ui basic small button"><spring:message code="exam.button.reg.excel.score" /></a><!-- 엑셀 성적등록 -->
											<a href="javascript:allQuizPaperExcelDown()" class="ui basic small button"><spring:message code="exam.button.batch.excel.down.paper" /></a><!-- 시험지 일괄 엑셀 다운로드 -->
											<uiex:msgSendBtn func="sendMsg()" styleClass="ui basic small button"/><!-- 메시지 -->
											<a href="javascript:manageQuiz(9)" class="ui basic small button"><spring:message code="exam.button.list" /></a><!-- 목록 -->
										</div>
									</div>
                                    <div class="option-content type2">
                                        <select class="ui dropdown" id="searchKey" onchange="listExamUser(1)">
									        <option value="ALL"><spring:message code="exam.common.search.all" /></option><!-- 전체 -->
									        <option value="COMPLETE"><spring:message code="exam.label.complete.stare" /></option><!-- 응시완료 -->
									        <option value="NONCOMPLETE"><spring:message code="exam.label.no.stare" /></option><!-- 미응시 -->
									        <option value="RECOMPLETE"><spring:message code="exam.label.reexam.complete.stare" /></option><!-- 재응시완료 -->
									        <option value="RENONCOMPLETE"><spring:message code="exam.label.reexam.no.stare" /></option><!-- 재응시미완료 -->
									    </select>
									    <select class="ui dropdown" id="searchMenu" onchange="listExamUser(1)">
									    	<option value="ALL"><spring:message code="exam.common.search.all" /></option><!-- 전체 -->
									    	<option value="Y"><spring:message code="exam.label.eval.y" /><!-- 평가 --></option>
									    	<option value="N"><spring:message code="exam.label.eval.n" /><!-- 미평가 --></option>
									    </select>
									    <div class="ui action input search-box">
									        <input type="text" placeholder="<spring:message code='exam.label.dept' />, <spring:message code='exam.label.user.no' />, <spring:message code='exam.label.user.nm' /> <spring:message code='exam.label.input' />" class="w250" id="searchValue"><!-- 학과 --><!-- 학번 --><!-- 이름 --><!-- 입력 -->
									        <button class="ui icon button" onclick="listExamUser(1)"><i class="search icon"></i></button>
									    </div>
                                    </div>
                                    <c:if test="${!fn:contains(authGrpCd, 'TUT') }">
	                                    <div class="ui segment score-wrap2 mt20">
	                                        <div class="flex">
	                                            <label for="fdbkValue" class="score-title"><spring:message code="common.label.batch.score.process" /><!-- 일괄 점수처리 --></label>
	                                            <div class="score-con">
	                                                <div class="fields">
	                                                    <div class="field flex-item">
	                                                        <div class="ui radio checkbox pl10 pr10" onclick="plusMinusIconControl('batch');">
											                    <input type="radio" name="scoreType" value="batch" tabindex="0" class="hidden" checked>
											                    <label for="scoreBatch"><spring:message code="exam.label.reg.scoring" /></label><!-- 점수 등록 -->
											                </div>
											                <div class="ui radio checkbox" onclick="plusMinusIconControl('addition');">
											                    <input type="radio" name="scoreType" value="addition" tabindex="0" class="hidden">
											                    <label for="scoreAddition"><spring:message code="exam.label.plus.minus.scoring" /></label><!-- 점수 가감 -->
											                </div>
	                                                    </div>
	                                                    <div class="field ml15">
	                                                        <spring:message code="exam.label.score" /> <!-- 점수 -->
													    	<div class="ui left icon input p_w60">
														   		<i class="ion-plus link icon toggle-icon" style="display:none;"></i>
														   		<input type="number" step="0.1" id="scoreValue" class="w100" />
													    	</div>
													    	 <spring:message code="exam.label.score.point" /><!-- 점 -->
	                                                    </div>
	                                                    <a href="javascript:submitScore()" class="ui blue button"><spring:message code="common.label.batch.score.save" /></a><!-- 일괄 점수저장 -->
	                                                </div>
	                                            </div>
	                                        </div>
	                                    </div>
                                    </c:if>
                                    <div class="option-content mb15 mt15">
								    	<a href="javascript:quizChartPop()" class="ui small blue button"><spring:message code="exam.label.stare.status" /><!-- 응시현황 --></a>
								    	<h4 class="ml5">(<spring:message code="common.page.total" /><!-- 총 -->&nbsp;:&nbsp;<span id="totalCntText">0</span><spring:message code="message.person" /><!-- 명 -->)</h4>
								    	<div class="mla">
								    		<a href="javascript:quizStatusExcelDown()" class="ui small blue button"><spring:message code="exam.button.excel.down" /></a><!-- 엑셀 다운로드 -->
								    	</div>
								    </div>
								    <table class="table type2" id="quizStareUserTable" data-sorting="true" data-paging="false" data-empty="<spring:message code='exam.common.empty' />"><!-- 등록된 내용이 없습니다. -->
										<thead>
											<tr>
												<th scope="col" class="tc" data-sortable="false">
													<div class="ui checkbox">
														<input type="hidden" id="stdNos" name="stdNos">
									                    <input type="checkbox" name="allEvalChk" id="allChk" value="all" onchange="checkAllStdNoToggle(this)">
									                    <label class="toggle_btn" for="allChk"></label>
									                </div>
												</th>
												<th scope="col" class="tc" data-sortable="false">No</th>
												<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="exam.label.dept" /></th><!-- 학과 -->
												<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="exam.label.user.no" /></th><!-- 학번 -->
												<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="exam.label.user.grade" /></th><!-- 학년 -->
												<c:if test="${creCrsVO.univGbn eq '3' or creCrsVO.univGbn eq '4'}">
													<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="common.label.grsc.degr.cors.gbn" /><!-- 학위과정 --></th>
												</c:if>
												<th scope="col" class="tc"><spring:message code="exam.label.user.nm" /></th><!-- 이름 -->
												<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="exam.label.admission.year" /><!-- 입학년도 --></th>
												<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="exam.label.admission.grade" /><!-- 입학학년 --></th>
												<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="exam.label.admission.type" /><!-- 입학구분 --></th>
												<%-- <th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message code="common.label.same.rate" /></th><!-- 유사율 --> --%>
												<th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message code="exam.label.eval.score" /></th><!-- 평가점수 -->
												<th scope="col" class="tc" data-breakpoints=""><spring:message code="exam.label.eval.yn" /></th><!-- 평가여부 -->
												<th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message code="exam.label.stare.situation" /></th><!-- 응시상태 -->
												<th scope="col" class="tc"><spring:message code="exam.label.stare.count" /></th><!-- 응시횟수 -->
												<th scope="col" class="tc" data-sortable="false" data-breakpoints="xs sm md"><spring:message code="exam.label.manage" /></th><!-- 관리 -->
											</tr>
										</thead>
										<tbody id="quizStareUserList">
										</tbody>
									</table>
                                </div>
                                <div class="option-content">
	                                <div class="mla">
		                            	<a href="javascript:manageQuiz(4)" class="ui blue button"><spring:message code="exam.button.mod" /></a><!-- 수정 -->
										<a href="javascript:delQuiz()" class="ui basic button"><spring:message code="exam.button.del" /></a><!-- 삭제 -->
										<a href="javascript:manageQuiz(9)" class="ui basic button"><spring:message code="exam.button.list" /></a><!-- 목록 -->
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