<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/forum/common/forum_common_inc.jsp" %>

<script src="/webdoc/player/plyr.js" crossorigin="anonymous"></script>
<script src="/webdoc/player/player.js" crossorigin="anonymous"></script>
<script src="/webdoc/audio-recorder/audio-recorder.js"></script>

<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
<link rel="stylesheet" href="/webdoc/player/plyr.css" />
<link rel="stylesheet" href="/webdoc/audio-recorder/audio-recorder.css" />

<script type="text/javascript">
var joinStatusY = 0;
var joinStatusN = 0;

var stdList = new Map();
var userList = new Map();

var audioRecord = null;
$(document).ready(function() {
	audioRecord = UiAudioRecorder("audioRecord");
	audioRecord.formName = "recordForm";
	audioRecord.dataName = "audioData";
	audioRecord.fileName = "audioFile";
	audioRecord.lang	 = "ko";
	audioRecord.init();

	audioRecord.recorderBox.css({"top":"0px", "left":"0px"});
	audioRecord.setRecorder();

	$("#audioRecord").height($(".recorder-box").height()+22);

	$(".audio-header").remove();
	$(".audio-btm .btm-btn").remove();

	audioRecord.recorderBox.show();

	listForumUser();
	
	$("#searchValue").on("keyup", function(e) {
		if(e.keyCode == 13) {
			listForumUser(1);
		}
	});

	// scoreChartSet();
	
	if("${forumVo.forumCtgrCd}" == "TEAM") {
		// loadSelectDiv();
	}

	$('.toggle-icon').click(function() {
        $(this).toggleClass("ion-plus ion-minus");
    });
	
	$(".accordion").accordion();
	$(".audioDiv").hide();
	$("#audioChk").on("change", function() {
		if(this.checked) {
			$(".audioDiv").show();
		} else {
			$(".audioDiv").hide();
		}
	});
});

function forumView(tab) {
	var urlMap = {
		"0" : "/forum/forumLect/Form/infoManage.do",		// 토론정보
		"1" : "/forum/forumLect/Form/bbsManage.do",		// 토론방
		"2" : "/forum/forumLect/Form/scoreManage.do",	// 토론평가
		"3" : "/forum/forumLect/Form/mutEvalResult.do",	// 상호평가
	};

	var url  = urlMap[tab];
	var form = $("<form></form>");
	form.attr("method", "POST");
	form.attr("name", "manageForm");
	form.attr("action", url);
	form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: '<c:out value="${forumVo.crsCreCd}" />'}));
	form.append($('<input/>', {type: 'hidden', name: 'forumCd',  value: '<c:out value="${forumVo.forumCd}" />'}));
	form.appendTo("body");
	form.submit();
}

// 참여자 리스트 조회
function listForumUser(page) {
	var univGbn = "${creCrsVO.univGbn}";
	var url  = "/forum/forumLect/forumJoinUserList.do";

	var data = {
		"forumCd" 	  : "${forumVo.forumCd}",
		"crsCreCd"	  : "${forumVo.crsCreCd}",
		"teamCd"	  : $("#teamCd").val(),
		"forumCtgrCd" : "${forumVo.forumCtgrCd}",
		"pageIndex"   : page,
		"listScale"   : $("#listScale").val(),
		"searchKey"   : $("#searchKey").val(),
		"searchValue" : $("#searchValue").val(),
		"searchLeng"  : $("#searchLeng").val(),
		"searchSort"  : $("#searchSort").val()
	};

	ajaxCall(url, data, function(data) {
		if (data.result > 0) {
			var returnList = data.returnList || [];
			var html = "";
			var stdNos = $("#stdNos").val().split(",");
			var joinStatusY = 0;
			var joinStatusN = 0;
			
			returnList.forEach(function(v, i) {
				var stareScore = v.stareScore == null ? 0 : v.stareScore;
				var totGetScore = v.totGetScore == null ? 0 : v.totGetScore;
				var stareCnt   = v.stareCnt == null ? 0 : v.stareCnt;
				var isChecked = false;
				if(stdNos != "") {
					stdNos.forEach(function(vv, ii) {
						if(vv == v.stdNo) {
							isChecked = true;
						}
					});
				}

				html += "<tr>";
//				html += "<tr class='on'>";
				html += "	<td class='tc '>";
				html += "		<div class='ui checkbox'>";
				html += "			<input type=\"checkbox\" id=\"check"+ i +"\" name=\"check\" data-stdNo=\""+ v.stdNo +"\" onchange=\"checkStdNoToggle(this)\" user_id='"+v.userId+"' user_nm='"+v.userNm+"' mobile='"+v.mobileNo+"' email='"+v.email+"'>";
				html += "			<label class=\"toggle_btn\" for=\"check"+ i +"\"></label>";
				html += "		</div>";
				html += "	</td>";
				html += "	<td class='tc wf5' name='lineNo'>"+ v.lineNo +"</td>";
				html += "	<td data-sort-value='"+v.deptNm+"' class='word_break_none'>"+ v.deptNm +"</td>";
				html += "	<td class='tc wf10 word_break_none' data-sort-value='"+v.userId+"'>"+ v.userId +"</td>";
				html += "	<td class='tc wf10' data-sort-value='"+v.hy+"'>"+ v.hy +"</td>";
				if(univGbn == "3" || univGbn == "4") {
					html += '<td class="tc word_break_none">' + (v.grscDegrCorsGbnNm || '-') + '</td>';
				}
				html += "	<td class='tc word_break_none' data-sort-value='"+v.userNm+"'>"+ v.userNm;
				html +=     userInfoIcon("<%=SessionInfo.isKnou(request)%>", "userInfoPop('" + v.userId + "')");
				html += "   </td>";
				html += "	<td class='tc' data-sort-value='"+v.entrYy+"'>"+ v.entrYy +"</td>";
				html += "	<td class='tc' data-sort-value='"+v.entrHy+"'>"+ v.entrHy +"</td>";
				html += "	<td class='tc word_break_none' data-sort-value='"+v.entrGbnNm+"'>"+ v.entrGbnNm +"</td>";
				html += "	<td class='tr wf15 word_break_none' data-sort-value='"+v.score+"'>";
				html += "		<div class=\"d-inline-block\" id=\"scoreDisplayDiv"+ i +"\" onClick=\"chgScoreRatio("+ i +");\">";
				if(v.scoreNull === "-") {
					html += "		- <spring:message code='forum.label.point' />"; // 점
				} else {
					html += "		"+ v.score +" <spring:message code='forum.label.point' />"; // 점
				}
				html += "		</div>";
				html += "		<div class=\"ui right labeled small input\" id=\"scoreInputDiv"+ i +"\" name=\"scoreInputDiv\" style=\"display:none;\">";
				html += "			<input type=\"number\" min=\"0\" id=\"score"+ i +"\" name=\"score\" data-stdno=\""+ v.stdNo +"\" class=\"w40 tr\" maxlength=\"3\" value=\""+ v.score +"\" maxlength=\"3\" onkeyup=\"this.value=this.value.replace(/[^0-9]/g,'');\" onblur=\"setScoreRatio("+ i +", '"+ v.score +"')\" onfocus=\"this.select()\">";
				html += "			<input type=\"hidden\" name=\"score\" value=\""+ v.score +"\">";
				html += "			<div class=\"ui basic label\"><spring:message code='forum.label.point' /></div>"; // 점
				html += "		</div>";
				// html += `		<i class="xi-pen-o \${v.profMemo == null || v.profMemo == '' ? '' : 'on'} f120" onclick="stdMemoForm('\${v.stdNo}')" style="cursor:pointer" title="<spring:message code='forum.label.memo'/>"></i>`; // 메모
				html += `		<i class="xi-comment-o \${v.fdbkCts == null || v.fdbkCts == '' ? '' : 'on'}" onclick="fdbkList('\${v.stdNo}', this)" style="cursor:pointer" title="<spring:message code='forum.label.feedback'/>"></i>`; // 피드백
				html += "	</td>";
				if(v.joinStatus == "미참여") {
					joinStatusN++;
					html += "	<td class='tc word_break_none' data-sort-value='"+v.joinStatus+"'><span class='fcRed'>"+ v.joinStatus +"</span></td>";
				} else {
					joinStatusY++;
					html += "	<td class='tc word_break_none' data-sort-value='"+v.joinStatus+"'>"+ v.joinStatus +"</td>";
				}
				html += "	<td class='tc word_break_none' data-sort-value='"+v.actlCnt+"'>"+ v.actlCnt +" / "+ v.cmntCnt +"</td>";
				html += "	<td class='tc word_break_none'>";
				html += "		<a href=\"javascript:ezGraderPop('"+ v.stdNo +"')\" class=\"ui basic mini button\"> <spring:message code='forum.label.forum.joinCnt' /></a>"; // 참여글
				html += "		<a href=\"javascript:stdMemoForm('"+ v.stdNo +"', this)\" class=\"ui basic mini button\"> <spring:message code='forum.label.memo' /></a>"; // 메모
				html += "	</td>";
				html += "</tr>";
			});
			$("#forumStareUserList").empty().append(html);
			
			$(".table").footable({
				on: {
	   				"after.ft.sorting": function(e, ft, sorter){
	   					$("#forumStareUserList tr").each(function(z, k){
	   						$(k).find("td[name=lineNo]").html((z+1));
	   					});
	   				}
	   			}
	   		});
			var params = {
				totalCount 	  : data.pageInfo.totalRecordCount,
				listScale 	  : data.pageInfo.recordCountPerPage,
				currentPageNo : data.pageInfo.currentPageNo,
				eventName 	  : "listExamUser"
			};
			
			gfn_renderPaging(params);
			$("input[name='check']").each(function(){
				if(stdList.size > 0){
					if(stdList.has($(this).val().split('|')[0])){
						$(this).prop('checked','checked');
					}else{
						$(this).removeAttr('checked');
					}
				}
			});
			
			if("${forumVo.prosConsForumCfg}" == 'N') {
				// forumChartSet(joinStatusY, joinStatusN);
			}
			
			$("#totalCntText").text(returnList.length);
		} else {
			alert(data.message);
		}
	}, function(xhr, status, error) {
		alert("<spring:message code='forum.common.error' />");/* 오류가 발생했습니다! */
	}, true);
}

//목록
function viewForumList() {
	var url  = "/forum/forumLect/Form/forumList.do";
	var form = $("<form></form>");
	form.attr("method", "POST");
	form.attr("name", "listForm");
	form.attr("action", url);
	form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: "${forumVo.crsCreCd}"}));
	form.appendTo("body");
	form.submit();
}

// 팀토론 일때 검색 조건 추가
function loadSelectDiv() {
	var url = "/forum/forumLect/teamSelectList.do";
	var data = {
		"crsCreCd" : "${forumVo.crsCreCd}",
		"teamCtgrCd" : "${forumVo.teamCtgrCd}",
	};
	
	ajaxCall(url, data, function(data) {
		var html = "";
		if(data.result > 0) {
			html += "<select class=\"ui compact dropdown mr10\" name=\"teamCd\"  id=\"teamCd\" onchange=\"listForumUser()\">";
			html += "	<option value=\"all\"><spring:message code='resh.common.search.all' /></option>";	// 전체
			data.returnList.forEach(function(v, i) {
				html += "	<option value=\""+ v.teamCd +"\">"+ v.teamNm +"</option>";
			});
			html += "</select>";
			
			$("#selectDiv").empty().append(html);
		} else {
			alert(data.message);
		}
	}, function(xhr, status, error) {
		alert("<spring:message code='forum.common.error' />");/* 오류가 발생했습니다! */
	}, true);
}

// 성적처리 방식에 따른 아이콘 유무
function plusMinusIconControl(scoreType) {
	if(scoreType == 'batch') {
		$(".ion-plus.link.icon.toggle-icon").hide();
	} else if(scoreType == 'addition') {
		$(".ion-plus.link.icon.toggle-icon").show();
	}
}

// 성적 저장
function submitScore() {
	// 성적처리방식
	if($("input[name='scoreType']:checked").val() == undefined){
		alert("<spring:message code='forum.alert.select.score.save.type' />");/* 성적 처리 유형을 선택하세요. */
		return false;
	}

	// 점수 입력
	if($("#scoreValue").val() == "" || $("#scoreValue").val() == undefined){
		alert("<spring:message code='forum.alert.input.score' />");/* 점수를 입력하세요. */
		return false;
	}

	if($("#scoreValue").val() > 100 ){
		alert("<spring:message code='forum.alert.score.max_100' />");/* 점수는 100점 까지 입력 가능 합니다. */
		return false;
	}

	// 학습자 선택
	if($("input[name=check]:checked").length == 0) {
		alert("<spring:message code='forum.alert.select.std' />");/* 학습자를 선택해 주세요. */
		return false;
	}


	var stdNos = $("#stdNos").val();
	var score = $("#scoreValue").val();
	if($("input[name='scoreType']:checked").val() == "addition") {
		if(!$(".toggle-icon").attr("class").includes("ion-plus")){
			score = score * (-1);
		}
	}

	var url = "/forum/forumLect/updateForumJoinUserScore.do";
	// var url = "/forum/forumLect/addStdScore.do";

	var data = {
		"forumCd" : "${forumVo.forumCd}",
		"crsCreCd" : "${forumVo.crsCreCd}",
		"teamCtgrCd" : "${forumVo.teamCtgrCd}",
		"stdNos" : stdNos,
		"score" : score,
		"scoreType" : $("input[name='scoreType']:checked").val()
	};

	ajaxCall(url, data, function(data) {
		if(data.result > 0) {
			alert("<spring:message code='forum.alert.batch.score' />"); // 일괄 점수 등록이 완료되었습니다.
			$("#stdNos").val("");
			$("#scoreValue").val("");
			listForumUser(1);
			// scoreChartSet();
		} else {
			alert(data.message);
		}
	}, function(xhr, status, error) {
		alert("<spring:message code='forum.common.error' />"); // 오류가 발생했습니다!
	}, true);
}

//전체 선택 / 해제
function checkAllStdNoToggle(obj) {
	$("input:checkbox[name=check]").prop("checked", $(obj).is(":checked"));

	$('input:checkbox[name=check]').each(function (idx) {
		if ($(obj).is(":checked")) {
			addSelectedStdNos($(this).attr("data-stdNo"));
			$(this).parents().addClass("on");
		} else {
			removeSelectedStdNos($(this).attr("data-stdNo"));
			$(this).parents().removeClass("on");
		}
	});
}

// 한건 선택 / 해제
function checkStdNoToggle(obj) {
	if ($(obj).is(":checked")) {
		addSelectedStdNos($(obj).attr("data-stdNo"));
		$(obj).parents().addClass("on");
	} else {
		removeSelectedStdNos($(obj).attr("data-stdNo"));
		$(obj).parents().removeClass("on");
	}
	var totChkCnt = $("input:checkbox[name=check]").length;
	var chkCnt = $("input:checkbox[name=check]:checked").length;
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
        selectedStdNos = selectedStdNos.replace(/^[,]*/g, ''); // 특정 문자열로 시작
        selectedStdNos = selectedStdNos.replace(/[,]*$/g, ''); // 특정 문자열로 끝남
        $("#stdNos").val(selectedStdNos);
    }
}

// 토론 참여 현황 차트
function forumChartSet(joinStatusY, joinStatusN) {
	var ctx = document.getElementById("pieChart");
	var myChart = new Chart(ctx, {
		type: 'pie',
		data: {
			labels: ["<spring:message code='forum.label.join'/>", "<spring:message code='forum.label.not.join'/>"], // 참여, 미참여
			datasets: [{
				backgroundColor: [
					'#36a2eb',
					'#ff6384',
					'#ff9f40'
				],
				borderWidth:1,
				data: [joinStatusY, joinStatusN]
			}]
		},

		options: {
			pieceLabel: {
				render: function (args) {
					return args.percentage + '%';
				},
				//precision: 2,
				fontColor : '#fff'
			},
			title: {
				display: true,
				text: "<spring:message code='forum.label.partici.statistic'/> (%)", // 토론 참여 현황
				fontSize: 14,
				fontColor: "#666",
			},

			legend: {
				display: true,
				position: 'bottom',
				labels: {
					boxWidth: 12,
					generateLabels: function(chart) {
						var data = chart.data;
						if (data.labels.length && data.datasets.length) {
							return data.labels.map(function(label, i) {
								var meta = chart.getDatasetMeta(0);
								var ds = data.datasets[0];
								var arc = meta.data[i];
								var custom = arc && arc.custom || {};
								var getValueAtIndexOrDefault = Chart.helpers.getValueAtIndexOrDefault;
								var arcOpts = chart.options.elements.arc;
								var fill = custom.backgroundColor ? custom.backgroundColor : getValueAtIndexOrDefault(ds.backgroundColor, i, arcOpts.backgroundColor);
								var stroke = custom.borderColor ? custom.borderColor : getValueAtIndexOrDefault(ds.borderColor, i, arcOpts.borderColor);
								var bw = custom.borderWidth ? custom.borderWidth : getValueAtIndexOrDefault(ds.borderWidth, i, arcOpts.borderWidth);
								
								// We get the value of the current label
								var value = chart.config.data.datasets[arc._datasetIndex].data[arc._index];
								
								return {
									// Instead of `text: label,`
									// We add the value to the string
									text: label + " : " + value + "<spring:message code='forum.label.person'/>", // 명
									fillStyle: fill,
									strokeStyle: stroke,
									lineWidth: bw,
									hidden: isNaN(ds.data[i]) || meta.data[i].hidden,
									index: i
								};
							});
						} else {
							return [];
						}
					}
				}
			}
		}
	});
}

/*
// 성적 통계 차트
function scoreChartSet() {
	var minScore = 0;
	var maxScore = 0;
	var avgScore = 0;
	if("${forumVo.forumCtgrCd}" == "TEAM") {
		$.ajax({
			type: "post",
			// url: "/team/teamHome/viewScoreChart.do",
			url: "/forum/forumLect/viewScoreChart.do",
			async: false,
			dataType: "json",
			data: {
				// "teamCtgrCd" : $("#teamCtgrCd").val(),
				"forumCd" : $("#forumCd").val(),
			},
			error: function(data) {
				alert("<spring:message code='forum.alert.team.count.select_fail'/>"); // 팀 수를 조회하는 데에 실패하였습니다. 다시 시도해주시기 바랍니다.
				return false;
			},
			success: function(data) {
				if(data == null) {
					minScore = 0;
					maxScore = 0;
					avgScore = 0;
				} else {
					minScore = data.minScore;
					maxScore = data.maxScore;
					avgScore = data.avgScore;
				}
			}
		});
	} else {
		minScore = "${minScore}";
		maxScore = "${maxScore}";
		avgScore = "${avgScore}";
	}

	var ctx = document.getElementById("barChart");
	var myChart = new Chart(ctx, {
	    type: 'bar',
	    data: {
	        labels: ["<spring:message code='forum.label.avg.score'/>", "<spring:message code='forum.label.max.score'/>", "<spring:message code='forum.label.min.score'/>"], // 평균점수, 최고점수, 최저점수  
	        datasets: [{
	            data: [avgScore, maxScore ,minScore],
	            backgroundColor: [
	                'rgba(75, 192, 192, .6)',
	                'rgba(54, 162, 235, .6)',
	                'rgba(255, 99, 132, .6)'
	            ],
	            borderWidth: 1
	        }]
	    },
	    options: {
	        events: false,
	        showTooltips: false,
	        title: {
	        display: true,
	        text: '<spring:message code='forum.label.score.chart.status'/>', // 성적 분포 현황
	        fontSize: 14,
	        fontColor: "#666",
	        },
	        animation: {
	        duration: 1000,
	        onComplete: function () {
	            // render the value of the chart above the bar
	            var ctx = this.chart.ctx;
	            ctx.font = Chart.helpers.fontString(Chart.defaults.global.defaultFontSize, 'normal', Chart.defaults.global.defaultFontFamily);
	            ctx.fillStyle = this.chart.config.options.defaultFontColor;
	            ctx.textAlign = 'center';
	            ctx.textBaseline = 'bottom';
	            this.data.datasets.forEach(function (dataset) {
	                for (var i = 0; i < dataset.data.length; i++) {
	                    var model = dataset._meta[Object.keys(dataset._meta)[0]].data[i]._model;
	                    ctx.fillStyle = '#fff'; // label color
	                    ctx.fillText(dataset.data[i], model.x, model.y + 20);
	                }
	            });
	        }},
	        scales: {
	            yAxes: [{
	                ticks: {
	                    min: 0,
	                    max: 100,
	                    stepSize: 20,
	                    callback: function(value){return value+ "<spring:message code='forum.label.point'/>"} // 점
	                },
	                scaleLabel: {
	                    display: true
	                }
	            }],
	            xAxes: [{
	                barPercentage: 0.6
	            }]
	        },
	        legend: {
	            display: false
	        }
	    }
	});
}
*/

// 메모 팝업
function stdMemoForm(stdNo, obj) {
	// 선택된 피드백의 아이콘 색상 초기화 및 변경
	if($(".ui.basic.small.button").parents("tr").hasClass("focused")) {
		$(".ui.basic.small.button").parents("tr").removeClass("focused");
	}
	$("[data-stdNo='"+ stdNo +"']").parents("tr").addClass("focused");

	var forumCd = "${forumVo.forumCd}";
	forumCommon.initModal("profMemo");
	$("form[name='forumCreCrsStdForm'] input[name='forumCd']").val(forumCd);
	$("form[name='forumCreCrsStdForm'] input[name='stdNo']").val(stdNo);
	$("#forumCreCrsStdForm").attr("target", "forumPopIfm");
	$("#forumCreCrsStdForm").attr("action", "/forum/forumLect/forumProfMemoPop.do");
	$("#forumCreCrsStdForm").submit();
	$("#forumPop").modal("show");
}

// 피드백 작성 팝업
function fdbkList(stdNo, obj) {
	// 선택된 피드백의 아이콘 색상 초기화 및 변경
	if($(".xi-comment-o").parents().hasClass("focused")) {
		$(".xi-comment-o").parents().removeClass("focused");
	}
	$(obj).parents().addClass("focused");

	var forumCd = "${forumVo.forumCd}";
	forumCommon.initModal("feedback");
	$("form[name='forumCreCrsStdForm'] input[name='forumCd']").val(forumCd);
	$("form[name='forumCreCrsStdForm'] input[name='stdNo']").val(stdNo);
	$("#forumCreCrsStdForm").attr("target", "forumPopIfm");
	$("#forumCreCrsStdForm").attr("action", "/forum/forumLect/forumFdbkPop.do");
	$("#forumCreCrsStdForm").submit();
	$("#forumPop").modal("show");
}

// 일괄 피드백 팝업
function allFeedback() {
	forumCommon.initModal("allFeedback");
	var forumCd = $("#forumCd").val();
	$("form[name='forumCreCrsStdForm'] input[name='forumCd']").val(forumCd);
	$("#forumCreCrsStdForm").attr("target", "forumPopIfm");
	$("#forumCreCrsStdForm").attr("action", "/forum/forumLect/allForumFdbkPop.do");
	$("#forumCreCrsStdForm").submit();
	$("#forumPop").modal("show");
}

// 엑셀 성적 등록
function callScoreExcelUpload() {
	forumCommon.initModal("scoreExcel");
	$("#forumCreCrsStdForm").attr("target", "forumPopIfm");
	$("#forumCreCrsStdForm").attr("action", "/forum/forumLect/forumScoreExcelUploadPop.do");
	$("#forumCreCrsStdForm").submit();
	$('#forumPop').modal('show');
}

// 엑셀 다운로드
function forumExcelDown() {
	var excelGrid = {
		colModel:[
			{label:'<spring:message code="main.common.number.no" />', name:'lineNo', align:'center', width:'1000'}, // NO.
			{label:'<spring:message code="asmnt.label.dept.nm"/>', name:'deptNm', align:'left', width:'5000'}, // 학과
			{label:'<spring:message code="asmnt.label.user_id"/>', name:'userId', align:'left', width:'5000'}, // 학번
			{label:'<spring:message code="asmnt.label.user_nm"/>', name:'userNm', align:'left', width:'5000'}, // 이름
			{label:'<spring:message code="asmnt.label.eval.score"/>', name:'score', align:'right', width:'5000'}, // 평가점수
			{label:'<spring:message code="asmnt.label.status"/>', name:'joinStatus', align:'center', width:'5000'}, // 상태
			{label:'<spring:message code="forum.label.forum.joinCnt" />', name:'actlCnt', align:'right', width:'5000'},	 // 참여글
			{label:'<spring:message code="forum.label.forum.commCnt" />', name:'cmntCnt', align:'right', width:'5000'}, // 댓글수
		]
	};

	var excelForm = $('<form></form>');
	excelForm.attr("name","excelForm");
	excelForm.attr("action","/forum/forumLect/listScoreExcel.do");
	excelForm.append($('<input/>', {type: 'hidden', name: 'forumCd', value:"${forumVo.forumCd}" }));
	excelForm.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value:"${forumVo.crsCreCd}" }));
	excelForm.append($('<input/>', {type: 'hidden', name: 'excelGrid', value:JSON.stringify(excelGrid)}));

	excelForm.appendTo('body');
	excelForm.submit();

//	$("#loading_page").show();
//	// 0.5 초마다 fileDownloadToken 라는 쿠키가 있는지 체크합니다.
//	// 해당 쿠키가 있으면 spin을 끄고 fileDownloadToken 쿠키를 지운 후 Interval 을 종료 합니다.
//	FILEDOWNLOAD_INTERVAL = setInterval(function() {
//		if (get_cookie("fileDownloadToken") != null) { 
//			clearInterval(FILEDOWNLOAD_INTERVAL);
//			$("#loading_page").hide();
//			delete_cookie("fileDownloadToken");
//		}
//	}, 500);
}

// EZ-Grader 팝업 화면
function ezGraderPop(stdNo) {
	$('#ezGraderForm input[name="stdNo"]').val(stdNo);
	$("#ezGraderForm").attr("target", "ezGraderPopIfm");
	$("#ezGraderForm").attr("action", "/forum/ezgPop/ezgMainForm.do");
	$("#ezGraderForm").submit();
	$('#ezGraderPop').modal('show');
}

// EZ-Grader 팝업 닫기버튼
function onCloseEzGraderPop(){
	$('.modal').modal('hide');
	listForumUser(1);
}

// 피드백 Validation
function valFdbk(){
	var fileUploader = dx5.get("fileUploader");
	
	// 피드백 입력
	if($("#fdbkValue").val() == "" || $("#fdbkValue").val() == undefined){
		alert("<spring:message code='forum.alert.feedback.input'/>"); // 피드백을 입력하시기 바랍니다.
		return false;
	}

	// 학습자 선택
	if($("input[name=check]:checked").length == 0) {
		// 학습자를 선택해주시기 바립니다.
		alert("<spring:message code='forum.alert.user.select'/>");
		return false;
	}
	
	// 피드백을 저장하시겠습니까?
	if(confirm("<spring:message code='forum.alert.feedback.confirm'/>")) {
		if (fileUploader.getFileCount() > 0) {
			$('#fdbkFileUp').css("visibility", "visible");
			fileUploader.startUpload();
		}else{
			submitFdbk();
		}
	}
}

// 피드백 파일첨부 팝업 열기
function fdbkFilePopOpen() {
	var fileUploader = dx5.get("fileUploader");
	var w = $("#fdbkFileBox").outerWidth();
	var h = $("#fdbkFileBox").outerHeight();
	var bw = $("#fdbkFileUp").find("button.fCloseBtn").outerWidth();
	
	$("#fdbkFileUp").css({"visibility":"visible","width":w+"px"});
	$("#fdbkFileUp .fileUpBox").css({"width":(w-bw-2)+"px"});
	$("#fileUploader-container").css("height",h+"px");
	$("#fdbkFileUp").find("button").css("height",h+"px");
	fileUploader.setUIStyle({itemHeight:h});
}

// 피드백 파일첨부 팝업 닫기
function fdbkFilePopClose() {
	var fileUploader = dx5.get("fileUploader");
	
	if(fileUploader.getTotalItemCount() > 0){
		var html = "";
		var items = fileUploader.getItems();

		html += "<i class='paperclip icon f080'></i>";
		html += items[0].name;
		html += "<button type='button' class='del ml10' style='border:1px solid #aaa;width:16px;height:16px' title='Delete' onclick=\"fdbkFileReset();\"></button>";

		$("#fdbkFileView").html(html);
	}
	else {
		$("#fdbkFileView").empty();
	}
	
	$('#fdbkFileUp').css("visibility", "hidden");
}

// 피드백 음성녹음 팝업 열기
function fdbkAudioPopOpen() {
	$('#fdbkAudioPop').modal('show');
}

// 피드백 음성녹음 팝업 닫기
function fdbkAudioPopClose() {
	fdbkFileToggle();
	$('#fdbkAudioPop').modal('hide');
}

function fdbkFileToggle(){
	var fileUploader = dx5.get("fileUploader");
	
	if(fileUploader.getTotalItemCount() > 0){
		var html = "";
		var items = fileUploader.getItems();

		html += "<i class='paperclip icon f080'></i>";
		html += items[0].name;
		html += "<button type='button' class='del ml10' style='border:1px solid #aaa;width:16px;height:16px' title='Delete' onclick='fdbkFileReset();'></button>";

		$("#fdbkFileView").html(html);
	}
	
	if(audioRecord.audioData != ''){
		var html = "<i class='paperclip icon f080'></i>";
		html += "음성녹음파일 REC";
		$("#fdbkAudioView").html(html);
	} else {
		$("#fdbkAudioView").html("");
	}
}

function fdbkFileReset(){
	var fileUploader = dx5.get("fileUploader");
	fileUploader.removeAll();
	$("#fdbkFileView").empty();
}

// 피드백 파일업로드
function finishUpload(){
	var fileUploader = dx5.get("fileUploader");
	var url = "/file/fileHome/saveFileInfo.do";
	var data = {
		"uploadFiles" : fileUploader.getUploadFiles(),
		"copyFiles"   : fileUploader.getCopyFiles(),
		"uploadPath"  : fileUploader.getUploadPath()
	};
	
	ajaxCall(url, data, function(data) {
		if(data.result > 0) {
			$('#fdbkFileUp').css("visibility", "hidden");
			submitFdbk();
		} else {
			alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
		}
	}, function(xhr, status, error) {
		alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	});
}

// 피드백 저장
function submitFdbk() {
	var fileUploader = dx5.get("fileUploader");
	var stdNos = $("#stdNos").val();

	var url = "/forum/forumLect/Form/regFdbk.do";
	var data = {
		"crsCreCd"	  : "${forumVo.crsCreCd}",
		"forumCd"     : "${forumVo.forumCd}",
		"stdNo"  	  : stdNos,
		"fdbkCts"     : $("#fdbkValue").val(),
		"uploadFiles" : fileUploader.getUploadFiles(),
		"uploadPath"  : fileUploader.getUploadPath(),
		"audioData"   : audioRecord.audioData,
		"audioFile"   : audioRecord.audioFile
	};

	ajaxCall(url, data, function(data) {
		if (data.result > 0) {
			$("#fdbkFileUp").css("visibility", "hidden");
    		fileUploader.removeAll();
    		$("#fdbkFileView").empty();
    		$("#fdbkValue").val("");
    		
			// 피드백 등록에 성공하였습니다.
			alert("<spring:message code='forum.alert.reg_success.feedback'/>");
			listForumUser(1);
    		
		} else {
			// 피드백 등록에 실패하였습니다. 다시 시도해주시기 바랍니다.
			alert("<spring:message code='forum.alert.reg_fail.feedback'/>");
		}
	}, function(xhr, status, error) {
		alert("<spring:message code='forum.common.error' />");/* 오류가 발생했습니다! */
	}, true);
}

// 메세지 보내기
function sendMsg() {
	var rcvUserInfoStr = "";
	var sendCnt = 0;
	
	$.each($('#forumStareUserList').find("input:checkbox[name=check]:not(:disabled):checked"), function() {
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

// 점수 클릭시 점수 입력 창으로 변경
function chgScoreRatio(i) {
	$("#scoreDisplayDiv"+i).hide();
	$("#scoreDisplayDiv"+i).removeClass("d-inline-block");
	$("#scoreInputDiv"+i).show();
	$("#scoreInputDiv"+i+" > input").focus();
}

// 마우스 아웃시 실행
function setScoreRatio(i, cScore) {
	var score = $("#score"+i).val();
//	var stdNo = $("#score"+i).attr("data-stdno");
	var stdNo = $("#score"+i).data("stdno");

	if(score === "" || score === undefined) {
		alert("<spring:message code='forum.alert.input.score' />");/* 점수를 입력하세요. */
		return false;
	}
	
	if(score > 100) {
		alert("<spring:message code='forum.alert.score.max_100' />");/* 점수는 100점 까지 입력 가능 합니다. */
		$("#score"+i).val(cScore);
		return false;
	}
	
	$("#scoreDisplayDiv"+i).show();
	$("#scoreDisplayDiv"+i).addClass("d-inline-block");
	$("#scoreInputDiv"+i).hide();
	
	if(cScore !== score) {
		var url = "/forum/forumLect/setScoreRatio.do";
		
		var data = {
			"forumCd" : "${forumVo.forumCd}",
			"crsCreCd" : "${forumVo.crsCreCd}",
			"teamCtgrCd" : "${forumVo.teamCtgrCd}",
			"stdNo" : stdNo,
			"score" : score,
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				alert("<spring:message code='forum.alert.mut.setScore' />"); // 평가점수가 정상적으로 수정되었습니다.
				listForumUser(1);
				// scoreChartSet();
			} else {
				alert(data.message);
			}
		}, function(xhr, status, error) {
			alert("<spring:message code='forum.common.error' />"); // 오류가 발생했습니다!
		}, true);
	}
}

// 목록
function viewForumList() {
	var url  = "/forum/forumLect/Form/forumList.do";
	var form = $("<form></form>");
	form.attr("method", "POST");
	form.attr("name", "listForm");
	form.attr("action", url);
	form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: "${forumVo.crsCreCd}"}));
	form.appendTo("body");
	form.submit();
}

// 토론 수정
function editForum(forumCd,forumStartDttm) {
		/*
			var date = new Date();
			var year = date.getFullYear();
			var month = ("0" + (1 + date.getMonth())).slice(-2);
			var day = ("0" + date.getDate()).slice(-2);
			var hours = ("0" + date.getHours()).slice(-2);
			var minutes = ("0" + date.getMinutes()).slice(-2);
			var seconds = ("0" + date.getSeconds()).slice(-2);
		
			var today = year + month + day + hours + minutes + seconds;
		
			//토론 시작했으면 수정 X
			if(forumStartDttm <= today ){
				alert("<spring:message code='forum.alert.ontask.not.modify'/>"); // 진행중인 토론은 수정이 불가능합니다.
				return false;
			}else{
		*/
		var url  = "/forum/forumLect/Form/editForumForm.do";
		var form = $("<form></form>");
		form.attr("method", "POST");
		form.attr("name", "editForm");
		form.attr("action", url);
		form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: '<c:out value="${forumVo.crsCreCd}" />'}));
		form.append($('<input/>', {type: 'hidden', name: 'forumCd',   value: '<c:out value="${forumVo.forumCd}" />'}));
		form.appendTo("body");
		form.submit();
		/*
			}
		*/
}

// 토론삭제
function delForum(forumCd) {
	var result = confirm("<spring:message code='forum.alert.confirm.delete'/>"); // 정말 토론을 삭제 하시겠습니까?

	if(!result){return false;}

	var form = $("<form></form>");
	form.attr("method", "POST");
	form.attr("name", "forumForm");
	form.attr("action", "/forum/forumLect/Form/delForum.do");
	form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: '<c:out value="${forumVo.crsCreCd}" />'}));
	form.append($('<input/>', {type: 'hidden', name: 'forumCd', value: forumCd}));
	form.appendTo("body");
	form.submit();
}

// 팀 구성원 보기
function teamMemberView(teamCtgrCd) {
	$("#teamCtgrCd").val(teamCtgrCd);
	$("#teamMemberForm").attr("target", "teamMemberIfm");
	$("#teamMemberForm").attr("action", "/forum/forumLect/teamMemberList.do");
	$("#teamMemberForm").submit();
	$('#teamMemberPop').modal('show');
}

// 토론현황보기
function forumChartView() {
	forumCommon.initModal("chartView");
	$("#forumChartViewForm").attr("target", "forumPopIfm");
	$("#forumChartViewForm").attr("action", "/forum/forumLect/forumChartViewPop.do");
	$("#forumChartViewForm").submit();
	$('#forumPop').modal('show');
}
</script>

<body class="<%=SessionInfo.getThemeMode(request)%>">
<form id="teamMemberForm" name="teamMemberForm" action="" method="POST">
<input type="hidden" name="teamCtgrCd" id="teamCtgrCd">
</form>
<form name="forumCreCrsStdForm" id="forumCreCrsStdForm" method="POST">
	<input type="hidden" name="forumCd" value="${forumVo.forumCd }">
	<input type="hidden" name="forumCtgrCd" value="${forumVo.forumCtgrCd}">
	<input type="hidden" name="teamCtgrCd" value="${forumVo.teamCtgrCd}">
	<input type="hidden" name="stdNo" value="">
	<input type="hidden" name="crsCreCd" value="${forumVo.crsCreCd}">
</form>
<form id="ezGraderForm" name="ezGraderForm" method="POST">
	<input type="hidden" name="crsCreCd" value="${forumVo.crsCreCd }" >
	<input type="hidden" name="forumCd" value="${forumVo.forumCd }" >
	<input type="hidden" name="forumCtgrCd" value="${forumVo.forumCtgrCd}" >
	<input type="hidden" name="evalCritUseYn" value="${forumVo.evalCritUseYn}" >
	<input type="hidden" name="evalCtgr" value="${forumVo.evalCtgr}" >
	<input type="hidden" name="stdNo" value="">
</form>
<form name="forumChartViewForm" id="forumChartViewForm" method="POST">
	<input type="hidden" name="forumCd" value="${forumVo.forumCd }">
	<input type="hidden" name="forumCtgrCd" value="${forumVo.forumCtgrCd}">
	<input type="hidden" name="teamCtgrCd" value="${forumVo.teamCtgrCd}">
	<input type="hidden" name="stdNo" value="">
	<input type="hidden" name="crsCreCd" value="${forumVo.crsCreCd}">
</form>
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
                    
                        <div id="info-item-box"> <!--  class="ui sticky" -->
                        	<script>
								// set location
								setLocationBar("<spring:message code='forum.label.forum'/>", "<spring:message code='forum.label.forum.info.score'/>");
							</script>
							
                            <h2 class="page-title flex-item flex-wrap gap4 columngap16">
                               <spring:message code='forum.label.forum'/><!-- 토론 -->
                                <%-- 
                                <div class="ui breadcrumb small">
                                    <small class="section"><spring:message code='forum.label.forum.info.score'/><!-- 토론정보 및 평가 --></small>
                                </div>
                                --%>
                            </h2>
                            <div class="button-area">
                            <div class="button-area">
								<a href="javascript:void(0)" class="ui blue button" onclick="editForum('${forumVo.forumCd}','${forumVo.forumStartDttm}')"><spring:message code='forum.button.mod'/><!-- 수정 --></a>
								<a href="javascript:void(0)" class="ui basic button" onclick="delForum('${forumVo.forumCd}');"><spring:message code='forum.button.del'/><!-- 삭제 --></a>
								<a href="javascript:void(0)" class="ui basic button" onclick="viewForumList()"><spring:message code='forum.label.list'/><!-- 목록 --></a>
                            </div>
                            </div>
                        </div>
                    
                        <div class="row">
                            <div class="col">

                                <div class="listTab">
                                    <ul class="">  
										<%-- <li class="mw120"><a href="javascript:void(0)" onclick="forumView(0)"><spring:message code='forum.label.forum.info'/><!-- 토론정보 --></a></li> --%>
										<li class="mw120"><a  href="javascript:void(0)" onclick="forumView(1)"><spring:message code='forum.label.forum.bbs'/><!-- 토론방 --></a></li>
										<li class="select mw120"><a href="javascript:void(0)" onclick="forumView(2)"><spring:message code='forum.label.forum.info.score'/><!-- 토론정보 및 평가 --></a></li>
                                    	<c:if test="${forumVo.mutEvalYn eq 'Y'}">
                                    	<li class="mw120"><a href="javascript:void(0)" onclick="forumView(3)"><spring:message code='forum.label.mut.eval' /><!-- 상호평가 --></a></li>
                                    	</c:if>
                                    </ul>
                                </div>

								<div class="ui segment">
									<%@ include file="/WEB-INF/jsp/forum/common/forum_info_inc.jsp" %>
								</div>

<%--
				<div class="ui form" style="height:auto;">
					<div class="fields" style="height:100%;">
						<div class="field p_w50">
							<div class="ui segment" style="height:100%;">
								<div class="ui segment">
									<ul class="num-chk d-inline-block">
										<li><a class="${forumVo.scoreAplyYn eq 'Y' ? 'bcGreen' : 'bcLgrey' }"></a></li>
									</ul>
									<label><spring:message code="forum.label.scoreAplyYn" /><!-- 성적 반영 --> : 
									<c:choose>
										<c:when test="${forumVo.scoreAplyYn eq 'Y'}">
											<spring:message code='forum.common.yes'/><!-- 예 -->
										</c:when>
										<c:otherwise>
											<spring:message code='forum.common.no'/><!-- 아니오 -->
										</c:otherwise>
									</c:choose>
									</label>
									<p class="ml15"><spring:message code="forum.label.score.ratio" /> : ${empty forumVo.scoreRatio ? 0 : forumVo.scoreRatio }%</p><!-- 성적 반영비율 -->
								</div>
								<div class="ui segment">
									<ul class="num-chk d-inline-block">
										<li><a class="${forumVo.scoreOpenYn eq 'Y' ? 'bcGreen' : 'bcLgrey' }"></a></li>
									</ul>
									<label><spring:message code='forum.label.scoreOpen' /></label><!-- 성적 공개 --> :
									<c:choose>
										<c:when test="${forumVo.scoreOpenYn eq 'Y'}">
											<spring:message code='forum.common.yes'/><!-- 예 -->
										</c:when>
										<c:otherwise>
											<spring:message code='forum.common.no'/><!-- 아니오 -->
										</c:otherwise>
									</c:choose>
								</div>
							</div>
						</div>
						<div class="field p_w50">
							<div class="ui segment" style="height:100%;">
								 <p><spring:message code="forum.label.forum.status" /> <!-- 토론 현황 -->
								<div class="ui stackable equal width grid">
									<c:if test="${forumVo.prosConsForumCfg eq 'Y'}">
									<div class="column">
										<canvas id="pieChart" height="250"></canvas>
<script>
var ctx = document.getElementById("pieChart");
var myChart = new Chart(ctx, {
    type: 'pie',
    data: {
    labels: ["<spring:message code='forum.label.pros'/>", "<spring:message code='forum.label.cons'/>"], // 찬성, 반대
    datasets: [{
        backgroundColor: [
            '#36a2eb',
            '#ff6384',
            '#ff9f40'
        ],
        borderWidth:1,
        data: ["${forumVo.forumAtclPorsCnt}", "${forumVo.forumAtclConsCnt}"]
    }]
    },

    options: {
        pieceLabel: {
        render: function (args) {
            return args.percentage + '%';
        },
        //precision: 2,
        fontColor : '#fff'
        },
        title: {
        display: true,
        text: "<spring:message code='forum.label.pros.cons.status'/> (%)", // 찬반 현황
        fontSize: 14,
        fontColor: "#666",
        },

        legend: {
            display: true,
            position: 'bottom',
            labels: {
                boxWidth: 12,
                generateLabels: function(chart) {
                    var data = chart.data;
                    if (data.labels.length && data.datasets.length) {
                        return data.labels.map(function(label, i) {
                            var meta = chart.getDatasetMeta(0);
                            var ds = data.datasets[0];
                            var arc = meta.data[i];
                            var custom = arc && arc.custom || {};
                            var getValueAtIndexOrDefault = Chart.helpers.getValueAtIndexOrDefault;
                            var arcOpts = chart.options.elements.arc;
                            var fill = custom.backgroundColor ? custom.backgroundColor : getValueAtIndexOrDefault(ds.backgroundColor, i, arcOpts.backgroundColor);
                            var stroke = custom.borderColor ? custom.borderColor : getValueAtIndexOrDefault(ds.borderColor, i, arcOpts.borderColor);
                            var bw = custom.borderWidth ? custom.borderWidth : getValueAtIndexOrDefault(ds.borderWidth, i, arcOpts.borderWidth);

                            // We get the value of the current label
                            var value = chart.config.data.datasets[arc._datasetIndex].data[arc._index];

                            return {
                                // Instead of `text: label,`
                                // We add the value to the string
                                text: label + " : " + value + "<spring:message code='forum.label.person'/>", // 명
                                fillStyle: fill,
                                strokeStyle: stroke,
                                lineWidth: bw,
                                hidden: isNaN(ds.data[i]) || meta.data[i].hidden,
                                index: i
                            };
                        });
                    } else {
                        return [];
                    }
                }
            }
        }
    }
});
</script>
									</div>
									</c:if>
									<c:if test="${forumVo.prosConsForumCfg eq 'N'}">
									<div class="column">
										<canvas id="pieChart" height="250"></canvas>
									</div>
									</c:if>
									<div class="column">
										<canvas id="barChart" height="250"></canvas>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
--%>

				<div class="ui segment">
					<div class="option-content mb15">
						
					</div>
					<div class="option-content">
						<select class="ui compact dropdown mr10" id="searchKey" onchange="listForumUser(1)">
							<option value="all"><spring:message code='forum.common.search.all'/><!-- 전체 --></option>
							<option value="joinY"><spring:message code='forum.label.join'/><!-- 참여 --></option>
							<option value="after"><spring:message code='forum.label.after.join'/><!-- 지각참여 --></option>
							<option value="joinN"><spring:message code='forum.label.not.join'/><!-- 미참여 --></option>
							<c:if test="${forumVo.forumCtgrCd eq 'TEAM'}">
								<option value="leader"><spring:message code='forum.label.team.leader'/><!-- 팀장 --></option>
								<option value="member"><spring:message code='forum.label.team.member'/><!-- 팀원 --></option>
							</c:if>
						</select>
						<select class="ui compact dropdown mr10" id="searchSort" onchange="listForumUser(1)">
							<option value="all"><spring:message code='forum.common.search.all'/><!-- 전체 --></option>
							<option value="evalY"><spring:message code='forum.label.eval'/><!-- 평가 --></option>
							<option value="evalN"><spring:message code='forum.label.not.eval'/><!-- 미평가 --></option>
						</select>
					    <div class="ui action input search-box">
					        <input type="text" placeholder="<spring:message code='forum.label.dept.nm' />, <spring:message code='forum.label.user.no' />, <spring:message code='forum.label.user_nm' /> <spring:message code='forum.label.input' />" class="w250" id="searchValue"><!-- 학과, 학번, 이름 입력 -->
					        <button class="ui icon button" onclick="listForumUser(1)"><i class="search icon"></i></button>
					    </div>
					    	<%-- <c:if test="${!fn:contains(authGrpCd, 'TUT') }"> --%>
								<a href="javascript:ezGraderPop()" class="ui basic small button mla">EZ-Grader</a>
					    	<%-- </c:if> --%>
							<%-- <a href="javascript:allFeedback()" class="ui button"><spring:message code="forum.button.all.feedback" /></a><!-- 일괄 피드백 --> --%>
							<a href="javascript:callScoreExcelUpload()" class="ui basic small button"><spring:message code="forum.button.reg.excel.score" /></a><!-- 엑셀 성적등록 -->
						
						<uiex:msgSendBtn func="sendMsg()" styleClass="ui basic small button"/><!-- 메시지 -->
						<a href="javascript:void(0)" class="ui basic small button" onclick="viewForumList()"><spring:message code='forum.label.list'/><!-- 목록 --></a>
					</div>
				<c:if test="${!fn:contains(authGrpCd, 'TUT') }">	
				    <div class="ui segment">
				    	<div class="ui form">
					    	<div class="fields">
					    		<div class="field">
					    			<div class="fields">
						    			<div class="field">
						    				<spring:message code="common.label.batch.score.process" /><!-- 일괄 점수처리 -->
						    				<div class="ui radio checkbox pl10 pr10" onclick="plusMinusIconControl('batch');">
				                                <input type="radio" name="scoreType" value="batch" tabindex="0" class="hidden" checked>
				                                <label for="scoreBatch"><spring:message code="forum.label.reg.scoring" /></label><!-- 점수 등록 -->
				                            </div>
				                            <div class="ui radio checkbox" onclick="plusMinusIconControl('addition');">
				                                <input type="radio" name="scoreType" value="addition" tabindex="0" class="hidden">
				                                <label for="scoreAddition"><spring:message code="forum.label.plus.minus.scoring" /></label><!-- 점수 가감 -->
				                            </div>
						    			</div>
						    			<div class="field ml15">
						    				<spring:message code="forum.label.score" /> <!-- 점수 -->
						    				<div class="ui left icon input p_w60">
							    				<i class="ion-plus link icon toggle-icon" style="display:none;"></i>
							    				<input type="text" id="scoreValue" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" class="w100" maxlength="3" />
						    				</div>
						    				 <spring:message code="forum.label.point" /><!-- 점 -->
						    			</div>
						    			<div class="field">
						                    <a href="javascript:void(0)" class="ui blue button" onclick="submitScore()"><spring:message code="common.label.batch.score.save" /></a><!-- 일괄 점수저장 -->
						    			</div>
						    		</div>
						    	</div>
								<!-- 글자수로 점수 주기 -->
								<div class="btnModalForm">
									<button type="button" class="ui basic button flex-item gap4"><spring:message code='forum.button.length.score'/><!-- 글자수로 점수 주기 --><i class="icon dropdown"></i></button>
									<div class="modalform" style="z-index:2000">
										<div class="flex flex-column gap8 transition hidden">
											<div class="ui right labeled input w200">
												<input type="text" name="ctsLen" id="ctsLen" placeholder="<spring:message code='forum.alert.len.input'/>" class="flex1" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');"><!-- 글자수 입력 -->
												<div class="ui basic label"><spring:message code='forum.label.lt'/><!-- 이상 --></div>
											</div>
											<div class="ui checkbox">
												<input type="checkbox" name="chkCmnt" id="chkCmnt" value="Y" tabindex="0" class="hidden">
												<label><spring:message code='forum.label.comment.include'/><!-- 댓글포함 --></label>
											</div>
											<div class="ui right labeled input w200">
																<input type="text" name="lenScore" id="lenScore"
																	placeholder="<spring:message code='forum.label.score'/>"
																	class="flex1"
																	onKeyup="this.value=this.value.replace(/[^0-9]/g,'');">
																<!-- 점수 -->
												<div class="ui basic label"><spring:message code='forum.label.point'/><!-- 점 --></div>
											</div>
											<button type="button" class="ui blue button active" onclick="lenScore();"><spring:message code='forum.button.all.score'/><!-- 일괄 점수 주기 --></button>
										</div>
									</div>
								</div>
								<script>
								$('.btnModalForm').accordion({
									selector: {
										title   : '.button',
										trigger : '.button',
										content : '.modalform'
									}
								});
								
								function lenScore() {
									var chkCmnt = "N";
									// 글자수 입력
									if($("#ctsLen").val() == "" || $("#ctsLen").val() == undefined){
										alert("<spring:message code='forum.alert.input.ctsLen' />"); // 글자수를 입력하세요.
										return false;
									}
									
									if($("#ctsLen").val() < 1 ){
										alert("<spring:message code='forum.alert.sts.len.min_1' />");/* 글자수는 1자 이상 입력 가능 합니다. */
										return false;
									}
								
									// 점수 입력
									if($("#lenScore").val() == "" || $("#lenScore").val() == undefined){
										alert("<spring:message code='forum.alert.input.score' />"); // 점수를 입력하세요.
										return false;
									}
								
									if($("#lenScore").val() > 100 ){
										alert("<spring:message code='forum.alert.score.max_100' />");/* 점수는 100점 까지 입력 가능 합니다. */
										return false;
									}
								
									// 학습자 선택
									if($("input[name=check]:checked").length == 0) {
										alert("<spring:message code='forum.alert.select.std' />");/* 학습자를 선택해 주세요. */
										return false;
									}
									
									if($("input[name=chkCmnt]:checked").val() == "Y") {
										chkCmnt = "Y";
									}
									
									var stdNos = $("#stdNos").val();
									var url = "/forum/forumLect/updateForumJoinUserLenScore.do";
									
									var data = {
										"forumCd" : "${forumVo.forumCd}",
										"crsCreCd" : "${forumVo.crsCreCd}",
										"teamCtgrCd" : "${forumVo.teamCtgrCd}",
										"stdNos" : stdNos,
										"score" : $("#lenScore").val(),
										"ctsLen" : $("#ctsLen").val(),
										"chkCmnt" : chkCmnt
									};
									
									ajaxCall(url, data, function(data) {
										if(data.result > 0) {
											alert("<spring:message code='forum.alert.length.score.success' />"); // 글자수로 점수 주기를 성공하였습니다.
											$("#stdNos").val("");
											listForumUser(1);
											// scoreChartSet();
											//글자수로 점수 주기 폼 초기화
											$("#ctsLen").val("");
											$("input:checkbox[id='chkCmnt']").prop("checked", false);
											$("#lenScore").val("");
											$(".modalform").removeClass('active');
										} else {
											alert("<spring:message code='forum.alert.length.score.fail' />"); // 글자수로 점수 주기가 실패하였습니다!! 다시 시도해주시기 바랍니다.
										}
									}, function(xhr, status, error) {
										alert("<spring:message code='forum.common.error' />"); // 오류가 발생했습니다!
									}, true);
								}
								</script>
								<!-- 글자수로 점수 주기 -->
								<!-- 참여형 일괄평가 -->
								<c:if test="${forumVo.evalCtgr == 'R'}">
								<div>
									<div class="field">
										<a href="javascript:void(0)" class="ui blue button" onclick="partiScore()"><spring:message code="forum.label.evalctgr.participate.all" /></a><!-- 참여형 일괄평가 -->
									</div>
								</div>
								<script>
								function partiScore() {
									if(window.confirm(`<spring:message code="forum.confirm.parti.score" />`)) {/* 기존 점수는 초기화되고\r\n토론 참여글 등록 수강생은 100점,\r\n미등록 수강생과 댓글만 작성한 수강생은 0점 처리됩니다.\r\n처리하시겠습니까? */
										var url = "/forum/forumLect/participateScore.do";
										
										var data = {
											"forumCd" : "${forumVo.forumCd}",
											"crsCreCd" : "${forumVo.crsCreCd}",
										};
										
										ajaxCall(url, data, function(data) {
											if(data.result > 0) {
												alert("<spring:message code='forum.alert.evalctgr.participate.all' />"); // 참여형 일괄평가가 완료되었습니다.
												listForumUser(1);
												// scoreChartSet();
											} else {
												alert(data.message);
											}
										}, function(xhr, status, error) {
											alert("<spring:message code='forum.common.error' />"); // 오류가 발생했습니다!
										}, true);
									}
								}
								</script>
								</c:if>
								<!-- 참여형 일괄평가 -->
							</div>
						</div>
					</div>
				</c:if>
					
					<div class="ui segment">
						<div class="ui form">
							<div class="mt10 flex">
								<label for="fdbkValue" class="mt5 mr10"><spring:message code='forum.label.feedback'/><!-- 피드백 --> : </label>
								<div class="ui checkbox" style="position:absolute;bottom:50px;">
		                           	<input type="checkbox" id="audioChk" /><label for="audioChk" class="d-inline-block">음성<br>녹음</label>
		                        </div>
								<div class="flex1">
									<div class="field ui fluid input">
										<input type="text" id="fdbkValue" maxlength="3000" placeholder="<spring:message code='forum.label.feedback.input'/>"><!-- 피드백 입력 -->
									</div>
							
									<div class="ui box">
										<div class="fields mr0">
											<div class="field">
												<button class="ui basic icon button" onclick="fdbkFilePopOpen();">
													<i class="save icon"></i> <spring:message code='forum.label.fdbk.file.attach'/><!-- 파일첨부 -->
												</button>
											</div>
											<div id="fdbkFileBox" class="field ui segment flex1 flex-item p4" style="position:relative;z-index:100">
												<div class="flex align-items-center" id="fdbkFileView"></div>
												<div id="fdbkFileUp" style="position:absolute;top:0;left:0;visibility:hidden;">
                                                    <div class="flex1 fileUpBox" style="display:inline-block;">
                                                    	<uiex:dextuploader
															id="fileUploader"
															path="${path}"
															limitCount="1"
															limitSize="1024"
															oneLimitSize="1024"
															listSize="1"
															finishFunc="finishUpload()"
															allowedTypes="*"
															bigSize="false"
															useFileBox="true"
															uiMode="simple"
														/>
													</div>
													<div class="flex1" style="display:inline-block;vertical-align:top">
														<button onclick="fdbkFilePopClose()" class="ui grey small button fCloseBtn" style="margin-left:-4px;"><span aria-hidden="true">&times;</span></button>
													</div>
												</div>
											</div>
										</div>
							
										<div class="fields mr0 audioDiv">
											<div class="field">
												<button class="ui basic icon button" onclick="fdbkAudioPopOpen();">
													<i class="microphone icon"></i> <spring:message code='forum.label.fdbk.audio.attach'/><!-- 음성녹음 -->
												</button>
											</div>
											<div class="field ui segment flex1 flex-item p4">
												<div class="flex align-items-center gap8" id="fdbkAudioView"></div>
											</div>
										</div>
									</div>
									<div class="fields mt10 ml0 mr0 tr">
										<a href="javascript:valFdbk()" class="ui blue button fCloseBtn"><spring:message code='common.label.batch.feedback.save'/><!-- 일괄 피드백 저장 --></a>
									</div>
							
								</div>
							</div>

							<!-- 피드백 끝 -->
				    	</div>
				    </div>
                    <div class="option-content mb10">
                        <div class="button-area flex flex1 ml0">
                            <%-- <div class="sec_head mra"><spring:message code="forum.label.submit.status" /><!-- 토론현황 --></div> --%>
                            <a href="javascript:forumChartView()" class="ui blue button"><spring:message code="forum.label.submit.status" /></a><!-- 토론현황 -->
                            <h4 class="ml5">(<spring:message code="common.page.total" /><!-- 총 -->&nbsp;:&nbsp;<span id="totalCntText">0</span><spring:message code="message.person" /><!-- 명 -->)</h4>
                            <a href="javascript:forumExcelDown()" class="ui blue button mla"><spring:message code="forum.label.excel.download" /></a><!-- 엑셀다운로드 -->
                        </div>
                    </div>
				    <table class="table type2" data-sorting="true" data-paging="false" data-empty="<spring:message code='forum.common.search.no.std' />"><!-- 조건에 맞는 수강생이 없습니다. -->
						<thead>
							<tr>
								<th scope="col" class="tc wf5" data-sortable="false">
									<div class="ui checkbox allCheck">
										<input type="hidden" id="stdNos" name="stdNos">
										<input type="checkbox" id="allCheck" name="allEvalChk" onchange="checkAllStdNoToggle(this)">
										<label class="toggle_btn" for="allCheck"></label>
									</div>
								</th>
								<th scope="col" class="tc wf5 num" data-sortable="false" data-type="number">No</th>
								<th scope="col" class="tc wf10" data-breakpoints="xs"><spring:message code="forum.label.dept.nm" /><!-- 학과 --></th>
								<th scope="col" class="tc"><spring:message code="forum.label.user.no" /><!-- 학번 --></th>
								<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="forum.label.user.grade" /><!-- 학년 --></th>
								<c:if test="${creCrsVO.univGbn eq '3' or creCrsVO.univGbn eq '4'}">
									<th scope="col" class="tc" data-breakpoints="xs"><spring:message code="common.label.grsc.degr.cors.gbn" /><!-- 학위과정 --></th>
								</c:if>
								<th scope="col" class="tc"><spring:message code="forum.label.user_nm" /><!-- 이름 --></th>
								<th scope="col" class="tc" data-breakpoints="xs sm"><spring:message code="forum.label.user.entr.yy" /><!-- 입학년도 --></th>
								<th scope="col" class="tc" data-breakpoints="xs sm"><spring:message code="forum.label.user.entr.hy" /><!-- 입학학년 --></th>
								<th scope="col" class="tc" data-breakpoints="xs sm"><spring:message code="forum.label.user.entr.gbn" /><!-- 입학구분 --></th>
								<th scope="col" class="tc wf15" data-breakpoints="xs sm md"><spring:message code="forum.label.eval.score" /><!-- 평가점수 --></th>
								<th scope="col" class="tc" data-breakpoints="xs sm md"><spring:message code="forum.label.status" /><!-- 상태 --></th>
								<th scope="col" class="tc"><spring:message code="forum.label.forum.joinCnt" />/<spring:message code="forum.label.forum.commCnt" /><!-- 참여글/댓글수 --></th>
								<th scope="col" class="tc" data-sortable="false" data-breakpoints="xs sm md"><spring:message code="forum.label.manage" /><!-- 관리 --></th>
							</tr>
						</thead>
						<tbody id="forumStareUserList">
						</tbody>
					</table>
					<!-- <div id="paging" class="paging"></div> -->
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
    
    
	<!-- 피드백 음성녹음 모달 팝업-->
	<div class="modal fade" id="fdbkAudioPop" tabindex="-1" role="dialog" aria-labelledby="audio-modal" aria-hidden="false">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code='forum.button.close'/>"><!-- 닫기 -->
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title"><spring:message code='forum.label.feedback'/> <spring:message code='forum.label.fdbk.audio.attach'/><!-- 피드백 음성녹음 --></h4>
				</div>
				<div class="modal-body">
					<div class="modal-page">
						<div id="wrap">
							<div class="ui form" style="height:50px">
								<div id="audioRecord"></div>
							</div>
							<div class="bottom-content">
								<a class="ui basic button toggle_btn flex-left-auto" onclick="fdbkAudioPopClose();"><spring:message code='forum.button.attaching'/><!-- 첨부하기 --></a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- 피드백 음성녹음 모달 팝업-->
    <!-- ez grader modal pop -->
    <div class="modal fade id" id="ezGraderPop" tabindex="-1" role="dialog" aria-labelledby="ezGrader" aria-hidden="false">
        <div class="modal-dialog full" role="document">
            <div class="modal-content">
                <div class="modal-body">
                    <iframe src="" id="ezGraderPopIfm" name="ezGraderPopIfm" width="100%" scrolling="no"></iframe>
                </div>
            </div>
        </div>
    </div>
    <!-- ez grader modal pop -->
<!-- 팀 구성원 보기 모달 -->
<div class="modal fade" id="teamMemberPop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code='forum.label.team.member.view'/>" aria-hidden="true"><!-- 팀 구성원 보기 -->
	<div class="modal-dialog modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code='forum.button.close'/>"><!-- 닫기 -->
					<span aria-hidden="true">&times;</span>
				</button>
				<h4 class="modal-title"><spring:message code='forum.label.team.member.view'/><!-- 팀 구성원 보기 --></h4>
			</div>
			<div class="modal-body">
				<iframe src="" id="teamMemberIfm" name="teamMemberIfm" width="100%" scrolling="no"></iframe>
			</div>
		</div>
	</div>
</div>
<!-- 팀 구성원 보기 모달 -->

<script>
$('iframe').iFrameResize();
window.closeModal = function() {
	$('.modal').modal('hide');
};
</script>
</body>
</html>
