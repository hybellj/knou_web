<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="uiex" uri="http://uiextension/tags" %>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/forum2/common/forum_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="module" value="table,editor,fileuploader"/>
	</jsp:include>

	<script type="text/javascript">
		var joinStatusY = 0;
		var joinStatusN = 0;

		var stdList = new Map();
		var userList = new Map();

		var audioRecord = null;

		var dialog;

		$(document).ready(function() {
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

			$('#scr-toggle-icon').click(function() {
				$(this).children("i").toggleClass("xi-plus xi-minus");
			});

			$(".accordion").accordion({
				header: "> .title",
				collapsible: true,
				active: false,
				heightStyle: "content",
				activate: function( event, ui ) {
					// 섹션이 열릴 때 title에 active 클래스를 넣고 싶다면
					if(ui.newHeader.length > 0) {
						ui.newHeader.addClass("active");
					}
					// 섹션이 닫힐 때 active 클래스를 제거
					if(ui.oldHeader.length > 0) {
						ui.oldHeader.removeClass("active");
					}
				}
			});
		});

		function forumView(tab) {
			var urlMap = {
				"0" : "/forum/forumLect/Form/infoManage.do",		// 토론정보
				"1" : "/forum2/forumLect/Form/bbsManage.do",		// 토론방
				"2" : "/forum2/forumLect/Form/scoreManage.do",	// 토론평가
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
			var url  = "/forum2/forumLect/forumJoinUserList.do";

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
					var dataList = createUserListHTML(returnList);	// 수강생 리스트 HTML 생성
					userListTable.clearData();
					userListTable.replaceData(dataList);
					userListTable.setPageInfo(data.pageInfo);
				} else {
					alert(data.message);
				}
			}, function(xhr, status, error) {
				alert("<spring:message code='forum.common.error' />");/* 오류가 발생했습니다! */
			}, true);
		}

		// 수강생 리스트 HTML 생성
		function createUserListHTML(userList) {
			let dataList = [];

			if(userList.length == 0) {
				return dataList;
			}

			userList.forEach(function(v,i) {
				var scoreHtml = "";
				scoreHtml += "		<div class=\"d-inline-block\" id=\"scoreDisplayDiv"+ i +"\" onClick=\"chgScoreRatio("+ i +");\">";
				if(v.scoreNull === "-") {
					scoreHtml += "		- "; // 점
				} else {
					scoreHtml += "		"+ v.score +" <spring:message code='forum.label.point' />"; // 점
				}
				scoreHtml += "		</div>";
				scoreHtml += "		<div id=\"scoreInputDiv"+ i +"\" name=\"scoreInputDiv\" style=\"display:none;\">";
				scoreHtml += "			<input type=\"number\" min=\"0\" id=\"score"+ i +"\" name=\"score\" data-stdid=\""+ v.userId +"\" class=\"w50 board-title\" maxlength=\"3\" value=\""+ v.score +"\" maxlength=\"3\" onkeyup=\"this.value=this.value.replace(/[^0-9]/g,'');\" onblur=\"setScoreRatio("+ i +", '"+ v.score +"')\" onfocus=\"this.select()\">";
				scoreHtml += "			<input type=\"hidden\" name=\"score\" value=\""+ v.score +"\">";
				scoreHtml += "		</div>";
				<%--scoreHtml += "		<div class=\"ui basic label\"><spring:message code='forum.label.point' /></div>"; // 점--%>

				var fdkHtml = "<i class=\"xi-comment-o \${v.fdbkCts == null || v.fdbkCts == '' ? '' : 'on'}\" onclick=\"fdbkList('" + v.userId + "', this)\" style=\"cursor:pointer\" title=\"<spring:message code='forum.label.feedback'/>\"></i>"; // 피드백
				var joinStatusHtml = "";
				if(v.joinStatus == "미참여") {
					joinStatusHtml += "<span class='fcRed'>"+ v.joinStatus +"</span>";
				} else {
					joinStatusHtml += v.joinStatus;
				}

				var mngHtml = "";
				mngHtml += "		<a href=\"javascript:ezGraderPop('"+ v.userId +"')\" class=\"btn basic small\"> <spring:message code='forum.label.forum.joinCnt.view' /></a>"; // 참여글보기
				mngHtml += "		<a href=\"javascript:stdMemoForm('"+ v.userId +"', this)\" class=\"btn basic small\"> <spring:message code='forum.label.memo' /></a>"; // 메모

				dataList.push({
					no: 				v.lineNo,
					deptnm: 			v.deptNm,
					userRprsId: 		v.userRprsId,
					stdntNo: 			v.stdntNo,
					usernm: 			v.userNm,
					totScr:				scoreHtml,
					fdk:				fdkHtml,
					joinStatus:			joinStatusHtml,
					joinDtdm:			v.joinDtdm,
					evlyn: 				v.evalYn,
					mng: 				mngHtml,
					// 팀관련:항목
					teamnm:				v.teamNm,
					ldryn:				v.memberRole,
					userId:				v.userId
				});

			});

			return dataList;
		}

		// 수강생 전체 버튼
		function searchAll() {
			$("#searchKey").val('all').trigger('chosen:updated');
			$("#searchSort").val('all').trigger("chosen:updated");
			$("#searchValue").val("");
			listForumUser(1);
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
				$("#scr-toggle-icon").hide();
			} else if(scoreType == 'addition') {
				$("#scr-toggle-icon").show();
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
			if(userListTable.getSelectedData("userId").length == 0) {
				alert("<spring:message code='forum.alert.select.std' />");/* 학습자를 선택해 주세요. */
				return false;
			}

			var stdIds = "";
			for(var i = 0; i < userListTable.getSelectedData("userId").length; i++) {
				if (i > 0) {
					stdIds += ',';
				}
				stdIds += userListTable.getSelectedData("userId")[i];
			}

			var score = $("#scoreValue").val();
			if($("input[name='scoreType']:checked").val() == "addition") {
				if(!$("#scr-toggle-icon").children("i").attr("class").includes("ion-plus")){
					score = score * (-1);
				}
			}

			var url = "/forum2/forumLect/updateForumJoinUserScore.do";
			// var url = "/forum2/forumLect/addStdScore.do";

			var data = {
				"forumCd" : "${forumVo.forumCd}",
				"crsCreCd" : "${forumVo.crsCreCd}",
				"teamCtgrCd" : "${forumVo.teamCtgrCd}",
				"stdIds" : stdIds,
				"score" : score,
				"scoreType" : $("input[name='scoreType']:checked").val()
			};

			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					alert("<spring:message code='forum.alert.batch.score' />"); // 일괄 점수 등록이 완료되었습니다.
					$("#stdIds").val("");
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
				url: "/forum2/forumLect/viewScoreChart.do",
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
		function stdMemoForm(stdId, obj) {
			// 선택된 피드백의 아이콘 색상 초기화 및 변경
			/*if($(".ui.basic.small.button").parents("tr").hasClass("focused")) {
				$(".ui.basic.small.button").parents("tr").removeClass("focused");
			}
			$("[data-stdNo='"+ stdNo +"']").parents("tr").addClass("focused");

			var forumCd = "${forumVo.forumCd}";
			forumCommon.initModal("profMemo");
			$("form[name='forumCreCrsStdForm'] input[name='forumCd']").val(forumCd);
			$("form[name='forumCreCrsStdForm'] input[name='stdNo']").val(stdNo);
			$("#forumCreCrsStdForm").attr("target", "forumPopIfm");
			$("#forumCreCrsStdForm").attr("action", "/forum2/forumLect/forumProfMemoPop.do");
			$("#forumCreCrsStdForm").submit();
			$("#forumPop").modal("show");*/

			var forumCd = "${forumVo.forumCd}";
			$("form[name='forumCreCrsStdForm'] input[name='forumCd']").val(forumCd);
			$("form[name='forumCreCrsStdForm'] input[name='stdId']").val(stdId);

			var queryString = $("#forumCreCrsStdForm").serialize();
			dialog = UiDialog("dialog1", {
				title: "메모",
				width: 600,
				height: 350,
				url: "/forum2/forumLect/forumProfMemoPop.do?" + queryString,
				autoresize: true
			});
		}

		// 피드백 작성 팝업
		function fdbkList(stdId, obj) {
			// 선택된 피드백의 아이콘 색상 초기화 및 변경
			if($(".xi-comment-o").parents().hasClass("focused")) {
				$(".xi-comment-o").parents().removeClass("focused");
			}
			$(obj).parents().addClass("focused");

			/*var forumCd = "${forumVo.forumCd}";
			forumCommon.initModal("feedback");
			$("form[name='forumCreCrsStdForm'] input[name='forumCd']").val(forumCd);
			$("form[name='forumCreCrsStdForm'] input[name='stdId']").val(stdId);
			$("#forumCreCrsStdForm").attr("target", "forumPopIfm");
			$("#forumCreCrsStdForm").attr("action", "/forum2/forumLect/forumFdbkPop.do");
			$("#forumCreCrsStdForm").submit();
			$("#forumPop").modal("show");*/

			var forumCd = "${forumVo.forumCd}";
			$("form[name='forumCreCrsStdForm'] input[name='forumCd']").val(forumCd);
			$("form[name='forumCreCrsStdForm'] input[name='stdId']").val(stdId);

			var queryString = $("#forumCreCrsStdForm").serialize();
			dialog = UiDialog("dialog1", {
				title: "피드백",
				width: 600,
				height: 350,
				url: "/forum2/forumLect/forumFdbkPop.do?" + queryString,
				autoresize: true
			});
		}

		// 일괄 피드백 팝업
		function allFeedback() {
			forumCommon.initModal("allFeedback");
			var forumCd = $("#forumCd").val();
			$("form[name='forumCreCrsStdForm'] input[name='forumCd']").val(forumCd);
			$("#forumCreCrsStdForm").attr("target", "forumPopIfm");
			$("#forumCreCrsStdForm").attr("action", "/forum2/forumLect/allForumFdbkPop.do");
			$("#forumCreCrsStdForm").submit();
			$("#forumPop").modal("show");
		}

		// 엑셀 성적 등록
		function callScoreExcelUpload() {
			/*forumCommon.initModal("scoreExcel");
			$("#forumCreCrsStdForm").attr("target", "forumPopIfm");
			$("#forumCreCrsStdForm").attr("action", "/forum2/forumLect/forumScoreExcelUploadPop.do");
			$("#forumCreCrsStdForm").submit();
			$('#forumPop').modal('show');*/
			var queryString = $("#forumCreCrsStdForm").serialize();
			dialog = UiDialog("dialog1", {
				// title: "엑셀 성적 등록",
				width: 600,
				height: 350,
				url: "/forum2/forumLect/forumScoreExcelUploadPop.do?" + queryString,
				autoresize: true
			});
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
			excelForm.attr("action","/forum2/forumLect/listScoreExcel.do");
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
		function ezGraderPop(stdId) {
			$('#ezGraderForm input[name="stdId"]').val(stdId);
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
            if(userListTable.getSelectedData("userId").length == 0) {
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
		/*function fdbkFilePopOpen() {
			var fileUploader = dx5.get("fileUploader");
			var w = $("#fdbkFileBox").outerWidth();
			var h = $("#fdbkFileBox").outerHeight();
			var bw = $("#fdbkFileUp").find("button.fCloseBtn").outerWidth();

			$("#fdbkFileUp").css({"visibility":"visible","width":w+"px"});
			$("#fdbkFileUp .fileUpBox").css({"width":(w-bw-2)+"px"});
			$("#fileUploader-container").css("height",h+"px");
			$("#fdbkFileUp").find("button").css("height",h+"px");
			fileUploader.setUIStyle({itemHeight:h});
		}*/

		// 피드백 파일첨부 팝업 닫기
		/*function fdbkFilePopClose() {
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
		}*/

		// 피드백 음성녹음 팝업 열기
/*		function fdbkAudioPopOpen() {
			$('#fdbkAudioPop').modal('show');
		}*/

		// 피드백 음성녹음 팝업 닫기
	/*	function fdbkAudioPopClose() {
			fdbkFileToggle();
			$('#fdbkAudioPop').modal('hide');
		}*/

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
			var stdIds = "";
			for(var i = 0; i < userListTable.getSelectedData("userId").length; i++) {
				if (i > 0) {
					stdIds += ',';
				}
				stdIds += userListTable.getSelectedData("userId")[i];
			}

			var url = "/forum2/forumLect/Form/regFdbk.do";
			var data = {
				"crsCreCd"	  : "${forumVo.crsCreCd}",
				"forumCd"     : "${forumVo.forumCd}",
				"stdId"  	  : stdIds,
				"fdbkCts"     : $("#fdbkValue").val(),
				"uploadFiles" : fileUploader.getUploadFiles(),
				"uploadPath"  : fileUploader.getUploadPath(),
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
			var stdId = $("#score"+i).data("stdid");

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
				var url = "/forum2/forumLect/setScoreRatio.do";

				var data = {
					"forumCd" : "${forumVo.forumCd}",
					"crsCreCd" : "${forumVo.crsCreCd}",
					"teamCtgrCd" : "${forumVo.teamCtgrCd}",
					"stdId" : stdId,
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
			/*var url  = "/forum2/forumLect/Form/forumList.do";
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "listForm");
			form.attr("action", url);
			form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: "${forumVo.crsCreCd}"}));
			form.appendTo("body");
			form.submit();*/
			location.href = "/forum2/forumLect/profForumListView.do?sbjctId=" + "${forumVo.crsCreCd}";
		}

		// 토론 수정
		function editForum(forumCd,forumStartDttm) {
			location.href = '<c:url value="/forum2/forumLect/profForumEditView.do" />?dscsId=' + encodeURIComponent(forumCd);
		}

		// 토론삭제
		function delForum(forumCd) {
			/*var result = confirm("<spring:message code='forum.alert.confirm.delete'/>"); // 정말 토론을 삭제 하시겠습니까?

		if(!result){return false;}

		var form = $("<form></form>");
		form.attr("method", "POST");
		form.attr("name", "forumForm");
		form.attr("action", "/forum2/forumLect/Form/delForum.do");
		form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: '<c:out value="${forumVo.crsCreCd}" />'}));
		form.append($('<input/>', {type: 'hidden', name: 'forumCd', value: forumCd}));
		form.appendTo("body");
		form.submit();*/
		}

		// 팀 구성원 보기
		function teamMemberView(teamCtgrCd) {
			$("#teamCtgrCd").val(teamCtgrCd);
			$("#teamMemberForm").attr("target", "teamMemberIfm");
			$("#teamMemberForm").attr("action", "/forum2/forumLect/teamMemberList.do");
			$("#teamMemberForm").submit();
			$('#teamMemberPop').modal('show');
		}

		// 토론현황보기
		function forumChartView() {
			/*forumCommon.initModal("chartView");
			$("#forumChartViewForm").attr("target", "forumPopIfm");
			$("#forumChartViewForm").attr("action", "/forum2/forumLect/forumChartViewPop.do");
			$("#forumChartViewForm").submit();
			$('#forumPop').modal('show');*/

			var queryString = $("#forumChartViewForm").serialize();
			dialog = UiDialog("dialog1", {
				title: "토론현황 그래프",
				width: 600,
				height: 500,
				url: "/forum2/forumLect/forumChartViewPop.do?" + queryString,
				autoresize: true
			});
		}
	</script>
</head>
<body class="class colorA">
	<form id="teamMemberForm" name="teamMemberForm" action="" method="POST">
		<input type="hidden" name="teamCtgrCd" id="teamCtgrCd">
	</form>
	<form name="forumCreCrsStdForm" id="forumCreCrsStdForm" method="POST">
		<input type="hidden" name="forumCd" value="${forumVo.forumCd }">
		<input type="hidden" name="forumCtgrCd" value="${forumVo.forumCtgrCd}">
		<input type="hidden" name="teamCtgrCd" value="${forumVo.teamCtgrCd}">
		<input type="hidden" name="stdId" value="">
		<input type="hidden" name="crsCreCd" value="${forumVo.crsCreCd}">
	</form>
	<form id="ezGraderForm" name="ezGraderForm" method="POST">
		<input type="hidden" name="crsCreCd" value="${forumVo.crsCreCd }" >
		<input type="hidden" name="forumCd" value="${forumVo.forumCd }" >
		<input type="hidden" name="forumCtgrCd" value="${forumVo.forumCtgrCd}" >
		<input type="hidden" name="evalCritUseYn" value="${forumVo.evalCritUseYn}" >
		<input type="hidden" name="evalCtgr" value="${forumVo.evalCtgr}" >
		<input type="hidden" name="stdId" value="">
	</form>
	<form name="forumChartViewForm" id="forumChartViewForm" method="POST">
		<input type="hidden" name="forumCd" value="${forumVo.forumCd }">
		<input type="hidden" name="forumCtgrCd" value="${forumVo.forumCtgrCd}">
		<input type="hidden" name="teamCtgrCd" value="${forumVo.teamCtgrCd}">
		<input type="hidden" name="stdId" value="">
		<input type="hidden" name="crsCreCd" value="${forumVo.crsCreCd}">
	</form>
	<div id="wrap" class="main">
		<!-- common header -->
		<jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>
		<!-- //common header -->

		<!-- classroom -->
		<main class="common">
			<!-- gnb -->
			<jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp"/>
			<!-- //gnb -->

			<!-- content -->
			<div id="content" class="content-wrap common">
				<div class="class_sub_top">
					<div class="navi_bar">
						<ul>
							<li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
							<li>강의실</li>
							<li><span class="current">내강의실</span></li>
						</ul>
					</div>
					<div class="btn-wrap">
						<div class="first">
							<select class="form-select">
								<option value="2025년 2학기">2025년 2학기</option>
								<option value="2025년 1학기">2025년 1학기</option>
							</select>
							<select class="form-select wide">
								<option value="">강의실 바로가기</option>
								<option value="2025년 2학기">2025년 2학기</option>
								<option value="2025년 1학기">2025년 1학기</option>
							</select>
						</div>
						<div class="sec">
							<button type="button" class="btn type1"><i class="xi-book-o"></i>교수 매뉴얼</button>
							<button type="button" class="btn type1"><i class="xi-info-o"></i>학습안내정보</button>
						</div>
					</div>
				</div>
				<div class="class_sub">
					<div class="sub-content">
						<div class="page-info">
							<h2 class="page-title">
								<spring:message code="forum.label.forum" /><!-- 토론 -->
							</h2>
						</div>

						<div class="board_top">
							<div class="right-area">
								<a href="javascript:void(0)" class="btn type2" onclick="editForum('${forumVo.forumCd}','${forumVo.forumStartDttm}')"><spring:message code='forum.button.mod'/><!-- 수정 --></a>
								<a href="javascript:void(0)" class="btn type2" onclick="delForum('${forumVo.forumCd}');"><spring:message code='forum.button.del'/><!-- 삭제 --></a>
								<a href="javascript:void(0)" class="btn type2" onclick="viewForumList()"><spring:message code='forum.label.list'/><!-- 목록 --></a>
							</div>
						</div>

						<div class="listTab">
							<ul>
								<li class="mw120 select"><a href="javascript:void(0)" onclick="forumView(2)"><spring:message code='forum.label.forum.info.score'/><!-- 토론정보 및 평가 --></a></li>
								<li class="mw120"><a  href="javascript:void(0)" onclick="forumView(1)"><spring:message code='forum.label.forum.bbs'/><!-- 토론방 --></a></li>
							</ul>
						</div>

						<!-- 토론정보 시작 -->
						<jsp:include page="/WEB-INF/jsp/forum2/common/forum_info_inc.jsp" />
						<!-- 토론정보 끝 -->

						<div class="board_top margin-top-4 padding-2 bcLgrey4">
							<h4>토론평가</h4>
							<div class="right-area">
								<%-- <c:if test="${!fn:contains(authGrpCd, 'TUT') }"> --%>
								<a href="javascript:ezGraderPop()" class="btn basic small">EZ-Grader</a>
								<%-- </c:if> --%>
								<%-- <a href="javascript:allFeedback()" class="ui button"><spring:message code="forum.button.all.feedback" /></a><!-- 일괄 피드백 --> --%>
								<a href="javascript:callScoreExcelUpload()" class="btn basic small"><spring:message code="forum.button.reg.excel.score" /></a><!-- 엑셀 성적등록 -->

								<%--<uiex:msgSendBtn func="sendMsg()" styleClass="ui basic small button"/><!-- 메시지 -->--%>
								<a href="javascript:sendMsg()" class="btn basic small">보내기</a>
							</div>
						</div>

						<!-- 토론평가 검색:시작 -->
						<div class="search-typeA margin-bottom-4">
							<div class="text-center">
								<select class="ui compact dropdown mr10" id="searchKey" onchange="listForumUser(1)">
									<option value="all"><spring:message code='forum.common.search.all'/><!-- 전체 --></option>
									<option value="joinY"><spring:message code='forum.label.join'/><!-- 참여 --></option>
									<%--<option value="after"><spring:message code='forum.label.after.join'/><!-- 지각참여 --></option>--%>
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
								<input type="text" placeholder="<spring:message code='forum.label.dept.nm' />, <spring:message code='forum.label.user.no' />, <spring:message code='forum.label.user_nm' /> <spring:message code='forum.label.input' />" class="w250" id="searchValue"><!-- 학과, 학번, 이름 입력 -->
								<button type="button" class="btn type1" onclick="listForumUser(1)"><spring:message code='common.button.search'/><!--검색--></button>
								<button type="button" class="btn type1" onclick="searchAll()"><spring:message code='forum.button.std.all.search'/><!--수강생 전체--></button>
							</div>
						</div>
						<!-- 토론평가 검색:끝 -->

						<!-- 토론평가 점수처리 영역:시작 -->
						<table class="table-type1 fs-14px">
							<colgroup>
								<col class="width-20per" />
								<col class="" />
							</colgroup>
							<tbody>
								<c:if test="${!fn:contains(authGrpCd, 'TUT') }">
								<tr>
									<th><spring:message code="common.label.batch.score.process" /><!-- 일괄 점수처리 --></th>
									<td>
										<div class="text-left">
											<span class="custom-input">
												<input type="radio" name="scoreType" id="scoreBatch" onchange="plusMinusIconControl(this.value)" value="batch" checked />
												<label for="scoreBatch"><spring:message code="forum.label.reg.scoring" /><!-- 점수 등록 --></label>
											</span>
											<span class="custom-input">
												<input type="radio" name="scoreType" id="scoreAddition" onchange="plusMinusIconControl(this.value)" value="addition" />
												<label for="scoreAddition"><spring:message code="forum.label.plus.minus.scoring" /><!-- 점수 가감 --></label>
											</span>
											<spring:message code="forum.label.score" /><!-- 점수 -->
											<button class='btn small basic icon' id="scr-toggle-icon"><i class='xi-plus'></i></button>
											<input type="text" id="scoreValue" class="w100" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" maxlength="3" />
											<spring:message code="forum.label.point" /><!-- 점 -->
											<a href="javascript:submitScore()" class="btn type7"><spring:message code="common.label.batch.score.save" /><!-- 일괄 점수저장 --></a>
										</div>
									</td>
								</tr>
								<tr>
									<th><spring:message code='forum.button.length.score'/><!-- 글자수로 점수 주기 --></th>
									<td>
										<div class="text-left">
											<div class="form-inline">
												<input type="text" name="ctsLen" id="ctsLen" placeholder="<spring:message code='forum.alert.len.input'/>" class="w100" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');"><!-- 글자수 입력 -->
												<spring:message code='forum.label.lt'/><!-- 이상 -->
												<div class="custom-input ml10">
													<input type="checkbox" name="chkCmnt" id="chkCmnt" value="Y">
													<label for="chkCmnt"><spring:message code='forum.label.comment.include'/><!-- 댓글포함 --></label>
												</div>
												<input type="text" name="lenScore" id="lenScore" placeholder="<spring:message code='forum.label.score'/>" class="w100" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');"><!-- 점수 -->
												<spring:message code='forum.label.point'/><!-- 점 -->
												<a href="javascript:lenScore()" class="btn type7 ml10"><spring:message code='forum.button.all.score'/><!-- 일괄 점수 주기 --></a>
											</div>
										</div>
										<script>
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
												if(userListTable.getSelectedData("userId").length == 0) {
													alert("<spring:message code='forum.alert.select.std' />");/* 학습자를 선택해 주세요. */
													return false;
												}
												if($("input[name=chkCmnt]:checked").val() == "Y") {
													chkCmnt = "Y";
												}
												var stdIds = "";
												for(var i = 0; i < userListTable.getSelectedData("userId").length; i++) {
													if (i > 0) {
														stdIds += ',';
													}
													stdIds += userListTable.getSelectedData("userId")[i];
												}

												var url = "/forum2/forumLect/updateForumJoinUserLenScore.do";
												var data = {
													"forumCd" : "${forumVo.forumCd}",
													"crsCreCd" : "${forumVo.crsCreCd}",
													"teamCtgrCd" : "${forumVo.teamCtgrCd}",
													"stdIds" : stdIds,
													"score" : $("#lenScore").val(),
													"ctsLen" : $("#ctsLen").val(),
													"chkCmnt" : chkCmnt
												};

												ajaxCall(url, data, function(data) {
													if(data.result > 0) {
														alert("<spring:message code='forum.alert.length.score.success' />"); // 글자수로 점수 주기를 성공하였습니다.
														$("#stdIds").val("");
														listForumUser(1);
														// scoreChartSet();
														$("#ctsLen").val("");
														$("input:checkbox[id='chkCmnt']").prop("checked", false);
														$("#lenScore").val("");
													} else {
														alert("<spring:message code='forum.alert.length.score.fail' />"); // 글자수로 점수 주기가 실패하였습니다!! 다시 시도해주시기 바랍니다.
													}
												}, function(xhr, status, error) {
													alert("<spring:message code='forum.common.error' />"); // 오류가 발생했습니다!
												}, true);
											}
										</script>
									</td>
								</tr>
								<c:if test="${forumVo.evalCtgr == 'PTCP_FULL_SCR'}">
								<tr>
									<th><spring:message code="forum.label.evalctgr.participate.all" /><!-- 참여형 일괄평가 --></th>
									<td>
										<div class="text-left">
											<a href="javascript:partiScore()" class="btn type7"><spring:message code="forum.label.evalctgr.participate.all" /><!-- 참여형 일괄평가 --></a>
										</div>
										<script>
											function partiScore() {
												if(window.confirm(`<spring:message code="forum.confirm.parti.score" />`)) {/* 기존 점수는 초기화되고\r\n토론 참여글 등록 수강생은 100점,\r\n미등록 수강생과 댓글만 작성한 수강생은 0점 처리됩니다.\r\n처리하시겠습니까? */
													var url = "/forum2/forumLect/participateScore.do";
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
									</td>
								</tr>
								</c:if>
								</c:if>
								<tr>
									<th><spring:message code='forum.label.feedback'/><!-- 피드백 --></th>
									<td>
										<div class="text-left">
											<div>
												<div>
													<div class="form-row">
														<input class="form-control width-80per" type="text" id="fdbkValue" maxlength="3000" placeholder="<spring:message code='forum.label.feedback.input'/>"><!-- 피드백 입력 -->
														<a href="javascript:valFdbk()" class="btn type7 ml10"><spring:message code='common.label.batch.feedback.save'/><!-- 일괄 피드백 저장 --></a>
													</div>
													<div id="uploaderBox" class="mt10 width-80per">
														<!-- TODO : 피드백 File Uplaod -->
														<uiex:dextuploader
																id="fileUploader"
																path="${path}"
																limitCount="1"
																limitSize="100"
																oneLimitSize="100"
																listSize="1"
																fileList=""
																finishFunc="finishUpload()"
																allowedTypes="*"
														/>
													</div>
												</div>
											</div>
										</div>
									</td>
								</tr>
							</tbody>
						</table>
						<!-- 토론평가 점수처리 영역:끝 -->

						<!-- 검색결과 영역-버튼들:시작 -->
						<div class="board_top margin-top-4">
							<div class="right-area">
								<%-- <div class="sec_head mra"><spring:message code="forum.label.submit.status" /><!-- 토론현황 --></div> --%>
								<a href="javascript:forumChartView()" class="btn type1"><spring:message code="forum.label.submit.status" /></a><!-- 토론현황 -->
								<a href="javascript:forumExcelDown()" class="btn type1"><spring:message code="forum.label.excel.download" /></a><!-- 엑셀다운로드 -->
							</div>
						</div>
						<!-- 검색결과 영역-버튼들:끝 -->

						<!-- 검색결과 영역:시작 -->
						<div id="forumStareUserList"></div>
						<script>
							let userListTable = UiTable("forumStareUserList", {
								lang: "ko",
								selectRow: "checkbox",
								columns: [
									{title:"No", 		field:"no",					headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},
									("${forumVo.forumCtgrCd}" == "TEAM" ? {title: "팀명", field: "teamnm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 80} : null),
									{title:"학과", 		field:"deptnm",				headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:100},
									{title:"대표아이디", 	field:"userRprsId", 		headerHozAlign:"center", hozAlign:"center", width:0, 	minWidth:100},
									{title:"학번", 		field:"stdntNo",			headerHozAlign:"center", hozAlign:"center", width:0,	minWidth:100},
									{title:"이름", 		field:"usernm", 			headerHozAlign:"center", hozAlign:"center", width:0,	minWidth:100},
									("${forumVo.forumCtgrCd}" == "TEAM" ? {title: "역할", field: "ldryn", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 80} : null),
									{title:"평가점수", 	field:"totScr", 			headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},
									{title:"피드백", 	field:"fdk", 				headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},
									{title:"참여상태", 	field:"joinStatus", 		headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},
									{title:"참여일시", 	field:"joinDtdm", 			headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},
									{title:"평가여부", 	field:"evlyn", 				headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},
									{title:"관리", 		field:"mng", 				headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:300},
								].filter(function(col) {return col !== null;})
							});
						</script>
						<!-- 검색결과 영역:끝 -->
					</div>
				</div>
			</div>
		</main>
		<!-- classroom-->
	</div>

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
</body>
</html>
