<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/forum2/common/dscs_common_inc.jsp" %>
<c:set var="authrtCdProf" value="<%=CommConst.AUTHRT_CD_PROF%>" />
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="module" value="table,editor,fileuploader,chart"/>
	</jsp:include>

	<script type="text/javascript">
		var EPARAM		= '<c:out value="${encParams}" />';
		var joinStatusY = 0;
		var joinStatusN = 0;
		var isTeamForum = "${dscsVO.dscsUnitTycd}" === "TEAM";

		var stdList = new Map();
		var userList = new Map();
		var dialog;

		$(document).ready(function() {
			listForumUser();

			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					listForumUser(1);
				}
			});

			$('#scr-toggle-icon').click(function() {
				$(this).children("i").toggleClass("xi-plus xi-minus");
			});

		});

		function resetScoreToggleIcon() {
			$("#scr-toggle-icon").children("i").removeClass("xi-minus").addClass("xi-plus");
		}

		function dscsViewTab(tab) {
			const param = "?dscsId=" + encodeURIComponent('<c:out value="${dscsVO.dscsId}" />') + "&encParams=" + EPARAM;
			if (tab == "0") {
				location.href = '<c:url value="/forum2/forumLect/profDscsEditView.do" />' + param;
				return;
			}

			var urlMap = {
				"1" : "/forum2/forumLect/Form/bbsManage.do",
				"2" : "/forum2/forumLect/Form/scoreManage.do"
			};

			var url  = urlMap[tab];
			if (!url) {
				return;
			}

			location.href = url + param;
		}

		// 참여자 리스트 조회
		function listForumUser(page) {
			var url  = "/forum2/forumLect/dscsJoinUserList.do";
			var searchTeamId = isTeamForum ? $("#searchTeamId").val() : "${dscsVO.teamId}";

			var data = {
				"dscsId" 	  : "${dscsVO.dscsId}",
				"sbjctId"	  : "${dscsVO.sbjctId}",
				"teamId"	  : searchTeamId,
				"dscsUnitTycd"      : "${dscsVO.dscsUnitTycd}",
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
					UiComm.showMessage(data.message, "error");
				}
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='forum.common.error' />", "error");/* 오류가 발생했습니다! */
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
				if(v.scrNull === "-") {
					scoreHtml += "		- "; // 점
				} else {
					scoreHtml += "<a href='#0' class='link'>"+ v.scr +"</a>";
				}
				scoreHtml += "		</div>";
				scoreHtml += "		<div id=\"scoreInputDiv"+ i +"\" name=\"scoreInputDiv\" style=\"display:none;\">";
				scoreHtml += "			<input type=\"number\" min=\"0\" id=\"score"+ i +"\" name=\"score\" data-stdid=\""+ v.userId +"\" data-dscsid=\""+ (v.dscsId || "") +"\" data-teamid=\""+ (v.teamId || "") +"\" class=\"w80 board-title\" maxlength=\"3\" value=\""+ v.scr +"\" maxlength=\"3\" onkeyup=\"this.value=this.value.replace(/[^0-9]/g,'');\" onblur=\"setScoreRatio("+ i +", '"+ v.scr +"')\" onfocus=\"this.select()\">";
				scoreHtml += "			<input type=\"hidden\" name=\"score\" value=\""+ v.scr +"\">";
				scoreHtml += "		</div>";
				<%--scoreHtml += "		<div class=\"ui basic label\"><spring:message code='forum.label.point' /></div>"; // 점--%>

				var fdkHtml = "<i class=\"xi-comment-o icon \${v.dscsFdbkCts == null || v.dscsFdbkCts == '' ? '' : 'on'}\" onclick=\"fdbkList('"+ v.dscsId +"', '"+ v.userId +"', '"+ (v.teamId || "") +"', this)\" style=\"cursor:pointer\" title=\"<spring:message code='forum.label.feedback'/>\"></i>"; // 피드백
				var oknokHtml = "-";
				if(v.oknokGbnCd === "OK") {
					oknokHtml = "<span class='fcPro'><spring:message code='forum.label.oknok.ok' /></span>";        // 찬성
				} else if(v.oknokGbnCd === "NOTOK") {
					oknokHtml = "<span class='fcCon'><spring:message code='forum.label.oknok.notok' /></span>";     // 반대
				}
				var joinStatusHtml = "";
				var joinDtdmHtml = "";
				if(v.joinStatus == "미참여") {
					joinStatusHtml += "<span class='fcNot'>"+ v.joinStatus +"</span>";
					joinDtdmHtml = "-";
				} else {
					joinStatusHtml += v.joinStatus;
					joinDtdmHtml = DscsDate.format(v.regDttm);
				}

				var mngHtml = "";
				// 팀토론 개별 행의 dscsId는 자식토론ID이므로 EZ-Grader 팝업은 부모토론ID 기준으로 전체 팀 목록을 조회한다.
				mngHtml += "		<button onclick=\"javascript:ezGraderPop('${dscsVO.dscsId}', '"+ v.userId +"')\" class=\"btn basic small\"><spring:message code='forum.label.forum.joinCnt.view' /></button>"; // 참여글보기
				mngHtml += "		<button onclick=\"javascript:stdMemoForm('"+ v.dscsId +"', '"+ v.userId +"', this)\" class=\"btn basic small\"><spring:message code='forum.label.memo' /></button>"; // 메모

				dataList.push({
					no: 				v.lineNo,
					deptnm: 			v.deptnm,
					userId:				v.userId,
					stdntNo: 			v.stdntNo,
					usernm: 			v.userNm,
					totScr:				scoreHtml,
					fdk:				fdkHtml,
					oknokGbn:			oknokHtml,
					joinStatus:			joinStatusHtml,
					joinDtdm:			joinDtdmHtml,
					evlyn: 				v.evlyn,
					mng: 				mngHtml,
					// 팀관련:항목
					teamnm:				v.teamnm,
					teamId:				v.teamId,
					ldryn:				v.memberRole,
					dscsId:			v.dscsId		// BYTEAM='Y'이면 자식 DSCS_ID
				});

			});

			return dataList;
		}

		// 수강생 전체 버튼
		function searchAll() {
			$("#searchKey").val('all').trigger('chosen:updated');
			$("#searchSort").val('all').trigger("chosen:updated");
			$("#searchTeamId").val('').trigger("chosen:updated");
			$("#searchValue").val("");
			listForumUser(1);
		}

		// 성적처리 방식에 따른 아이콘 유무
		function plusMinusIconControl(scoreType) {
			if(scoreType == 'batch') {
				$("#scr-toggle-icon").hide();
			} else if(scoreType == 'addition') {
				resetScoreToggleIcon();
				$("#scr-toggle-icon").show();
			}
		}

		// BYTEAM='Y' 전용: 선택 학생을 자식토론 dscsId 기준으로 그룹핑
		var _pendingFdbkGroups = null;
		function getForumCdGroups() {
			var groups = {};
			var uids = userListTable.getSelectedData("userId");
			var fcds = userListTable.getSelectedData("dscsId");
			var tids = userListTable.getSelectedData("teamId");
			for (var i = 0; i < uids.length; i++) {
				var fcd = fcds[i] || "${dscsVO.dscsId}";
				if (!groups[fcd]) {
					groups[fcd] = {
						stdIds: [],
						teamId: tids[i] || ""
					};
				}
				groups[fcd].stdIds.push(uids[i]);
			}
			return groups;
		}

		// 선택 학습자를 토론ID|팀ID|학습자ID목록 형식으로 묶어 백엔드 배치 처리 대상으로 전달한다.
		function getSelectedPtcpTargets() {
			var groups = {};
			var uids = userListTable.getSelectedData("userId");
			var fcds = userListTable.getSelectedData("dscsId");
			var tids = userListTable.getSelectedData("teamId");
			for (var i = 0; i < uids.length; i++) {
				var fcd = fcds[i] || "${dscsVO.dscsId}";
				var tid = tids[i] || "";
				var key = fcd + "|" + tid;
				if (!groups[key]) {
					groups[key] = {
						dscsId: fcd,
						teamId: tid,
						stdIds: []
					};
				}
				groups[key].stdIds.push(uids[i]);
			}
			return Object.keys(groups).map(function(key) {
				var group = groups[key];
				return group.dscsId + "|" + group.teamId + "|" + group.stdIds.join(",");
			}).join(";");
		}

		// 성적 저장
		function submitScore() {
			// 성적처리방식
			if($("input[name='scoreType']:checked").val() == undefined){
				UiComm.showMessage("<spring:message code='forum.alert.select.score.save.type' />", "info");/* 성적 처리 유형을 선택하세요. */
				return false;
			}

			// 점수 입력
			if($("#scoreValue").val() == "" || $("#scoreValue").val() == undefined){
				UiComm.showMessage("<spring:message code='forum.alert.input.score' />", "info");/* 점수를 입력하세요. */
				return false;
			}

			if($("#scoreValue").val() > 100 ){
				UiComm.showMessage("<spring:message code='forum.alert.score.max_100' />", "info");/* 점수는 100점 까지 입력 가능 합니다. */
				return false;
			}

			// 학습자 선택
			if(userListTable.getSelectedData("userId").length == 0) {
				UiComm.showMessage("<spring:message code='forum.alert.select.std' />", "info");/* 학습자를 선택해 주세요. */
				return false;
			}

			var score = $("#scoreValue").val();
			if($("input[name='scoreType']:checked").val() == "addition") {
				if($("#scr-toggle-icon").children("i").attr("class").includes("xi-minus")){
					score = score * (-1);
				}
			}

			var url = "/forum2/forumLect/updateDscsJoinUserScore.do";
			// 팀토론은 선택된 행의 자식토론ID를 포함해 한 번의 배치 요청으로 처리한다.
			var data = {
				"sbjctId" : "${dscsVO.sbjctId}",
				"ptcpTargets" : getSelectedPtcpTargets(),
				"scr" : score,
				"scoreType" : $("input[name='scoreType']:checked").val()
			};

			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					UiComm.showMessage("<spring:message code='forum.alert.batch.score' />", "success"); // 일괄 점수 등록이 완료되었습니다.
					$("#stdIds").val("");
					$("#scoreValue").val("");
					resetScoreToggleIcon();
					listForumUser(1);
				} else {
					UiComm.showMessage(data.message, "error");
				}
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='forum.common.error' />", "error"); // 오류가 발생했습니다!
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

		// 메모 팝업
		function stdMemoForm(dscsId, stdId, obj) {
			$("form[name='dscsCreCrsStdForm'] input[name='dscsId']").val(dscsId);
			$("form[name='dscsCreCrsStdForm'] input[name='stdId']").val(stdId);

			var queryString = $("#dscsCreCrsStdForm").serialize();
			dialog = UiDialog("dialog1", {
				title: "<spring:message code='forum.label.memo' />",/*메모*/
				width: 800,
				height: 400,
				url: "/forum2/forumLect/dscsProfMemoPop.do?" + queryString + "&encParams=" + EPARAM,
				// autoresize: true
			});
		}

		// 피드백 작성 팝업
		function fdbkList(dscsId, stdId, teamId, obj) {
			// 선택된 피드백의 아이콘 색상 초기화 및 변경
			if($(".xi-comment-o").parents().hasClass("focused")) {
				$(".xi-comment-o").parents().removeClass("focused");
			}
			$(obj).parents().addClass("focused");

			$("form[name='dscsCreCrsStdForm'] input[name='dscsId']").val(dscsId);
			$("form[name='dscsCreCrsStdForm'] input[name='stdId']").val(stdId);
			$("form[name='dscsCreCrsStdForm'] input[name='teamId']").val(teamId || "");

			var queryString = $("#dscsCreCrsStdForm").serialize();
			dialog = UiDialog("dialog1", {
				title: "<spring:message code='forum.label.feedback'/>",/*피드백*/
				width: 800,
				height: 600,
				url: "/forum2/forumLect/dscsFdbkPop.do?" + queryString + "&encParams=" + EPARAM,
				modal: true
			});
		}

		// 엑셀 성적 등록
		function callScoreExcelUpload() {
			var queryString = $("#dscsCreCrsStdForm").serialize();
			dialog = UiDialog("dialog1", {
				title: "<spring:message code="forum.button.reg.excel.score" />", /*엑셀 성적등록*/
				width: 600,
				height: 400,
				url: "/forum2/forumLect/forumScoreExcelUploadPop.do?" + queryString,
				autoresize: true
			});
		}

		// 엑셀 다운로드
		function dscsExcelDown() {
			var excelGrid = {
				colModel:[
					{label:'<spring:message code="main.common.number.no" />', name:'lineNo', align:'center', width:'1000'}, // NO.
					{label:'<spring:message code="forum.label.dept.nm"/>', name:'deptnm', align:'left', width:'5000'}, // 학과
					{label:'<spring:message code="forum.label.user_id"/>', name:'userId', align:'left', width:'5000'}, // 아이디
					{label:'<spring:message code="forum.label.user.no"/>', name:'stdntNo', align:'left', width:'5000'}, // 학번
					{label:'<spring:message code="forum.label.user_nm"/>', name:'userNm', align:'left', width:'5000'}, // 이름
					{label:'<spring:message code="forum.label.eval.score"/>', name:'scr', align:'right', width:'5000'}, // 평가점수
					{label:'<spring:message code="forum.label.join.status"/>', name:'joinStatus', align:'center', width:'5000'}, // 상태
					{label:'<spring:message code="forum.label.forum.joinCnt" />', name:'actlCnt', align:'right', width:'5000'},	 // 참여글
					{label:'<spring:message code="forum.label.forum.commCnt" />', name:'cmntCnt', align:'right', width:'5000'}, // 댓글수
				]
			};

			var excelForm = $('<form></form>');
			excelForm.attr("name","excelForm");
			excelForm.attr("action","/forum2/forumLect/listScoreExcel.do");
			excelForm.append($('<input/>', {type: 'hidden', name: 'dscsId', value:"${dscsVO.dscsId}" }));
			excelForm.append($('<input/>', {type: 'hidden', name: 'sbjctId', value:"${dscsVO.sbjctId}" }));
			excelForm.append($('<input/>', {type: 'hidden', name: 'excelGrid', value:JSON.stringify(excelGrid)}));

			excelForm.appendTo('body');
			excelForm.submit();
		}

		// EZ-Grader 팝업 화면
		function ezGraderPop(dscsId, stdId) {
			/*$('#ezGraderForm input[name="dscsId"]').val(dscsId);
			$('#ezGraderForm input[name="stdId"]').val(stdId);
			$("#ezGraderForm").attr("target", "ezGraderPopIfm");
			$("#ezGraderForm").attr("action", "/forum2/ezgPop/ezgMainForm.do");
			$("#ezGraderForm").submit();
			$('#ezGraderPop').modal('show');*/

			$("form[name='ezGraderForm'] input[name='dscsId']").val(dscsId);
			$("form[name='ezGraderForm'] input[name='stdId']").val(stdId);

			const width = window.innerWidth;
			const height = window.innerHeight;

			var queryString = $("#ezGraderForm").serialize();
			dialog = UiDialog("dialog1", {
				url: "/forum2/ezgPop/ezgMainForm.do?" + queryString + "&encParams=" + EPARAM,
				titlebar: false,
				fullscreen: true,
				modal: true,
			});
		}

		// EZ-Grader 팝업 닫기버튼
		function onCloseEzGraderPop(){
			// $('.modal').modal('hide');
			dialog.close();
			listForumUser(1);
		}

		// 피드백 Validation
		function valFdbk(){
			var fileUploader = dx5.get("fileUploader");

			// 피드백 입력
			if($("#fdbkValue").val() == "" || $("#fdbkValue").val() == undefined){
				UiComm.showMessage("<spring:message code='forum.alert.feedback.input'/>", "info"); // 피드백을 입력하시기 바랍니다.
				return false;
			}

			// 학습자 선택
            if(userListTable.getSelectedData("userId").length == 0) {
				// 학습자를 선택해주시기 바립니다.
				UiComm.showMessage("<spring:message code='forum.alert.user.select'/>", "info");
				return false;
			}

			// 피드백을 저장하시겠습니까?
			if (isTeamForum) {
				_pendingFdbkGroups = getForumCdGroups(); // BYTEAM='Y': confirm 전에 그룹 저장
			}
			UiComm.showMessage("<spring:message code='forum.alert.feedback.confirm'/>", "confirm")
				.then(function(result) {
					if (result) {
						if (fileUploader.availUpload()) {
							fileUploader.startUpload();
						}else{
							submitFdbk();
						}
					} else {
						_pendingFdbkGroups = null; // confirm 취소 시 초기화
					}
				});
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
		}

		function fdbkFileReset(){
			var fileUploader = dx5.get("fileUploader");
			fileUploader.removeAll();
			$("#fdbkFileView").empty();
		}

		// 피드백 파일업로드
		function finishUpload(){
			var fileUploader = dx5.get("fileUploader");
			var url = "/common/uploadFileCheck.do";
			var data = {
				"uploadFiles" : fileUploader.getUploadFiles(),
				"uploadPath"  : fileUploader.getUploadPath()
			};

			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					$('#fdbkFileUp').css("visibility", "hidden");
					submitFdbk();
				} else {
					UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
				}
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
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

			// BYTEAM='Y': 팀(자식토론)별 그룹핑 후 각각 호출
			if (isTeamForum && _pendingFdbkGroups) {
				var groups = _pendingFdbkGroups;
				_pendingFdbkGroups = null;
				var keys = Object.keys(groups);
				keys.forEach(function(fcd, idx) {
					// 파일 업로드 완료 후 자식토론별로 기존 피드백 등록 흐름을 호출하므로 stdId comma 파라미터를 유지한다.
					var data = {
						"sbjctId"    : "${dscsVO.sbjctId}",
						"dscsId"     : fcd,
						"stdId"      : groups[fcd].stdIds.join(","),
						"teamId"     : groups[fcd].teamId,
						"dscsFdbkCts" : $("#fdbkValue").val(),
						"uploadFiles" : fileUploader.getUploadFiles(),
						"uploadPath"  : fileUploader.getUploadPath()
					};
					ajaxCall(url, data, function(data) {
						if (idx === keys.length - 1) {
							if (data.result > 0) {
								$("#fdbkFileUp").css("visibility", "hidden");
								fileUploader.removeAll(); $("#fdbkFileView").empty(); $("#fdbkValue").val("");
								UiComm.showMessage("<spring:message code='forum.alert.reg_success.feedback'/>", "success");
								listForumUser(1);
							} else { UiComm.showMessage("<spring:message code='forum.alert.reg_fail.feedback'/>", "error"); }
						}
					}, function(xhr, status, error) {
						UiComm.showMessage("<spring:message code='forum.common.error' />", "error");
					}, true);
				});
				return;
			}

			// BYTEAM='N': 기존 로직
			// 점수관리 화면은 파일 업로드와 기존 피드백 등록 API 호환을 위해 stdId comma 파라미터를 유지한다.
			var data = {
				"sbjctId"	  : "${dscsVO.sbjctId}",
				"dscsId"     : "${dscsVO.dscsId}",
				"stdId"  	  : stdIds,
				"dscsFdbkCts" : $("#fdbkValue").val(),
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
					UiComm.showMessage("<spring:message code='forum.alert.reg_success.feedback'/>", "success");
					listForumUser(1);

				} else {
					// 피드백 등록에 실패하였습니다. 다시 시도해주시기 바랍니다.
					UiComm.showMessage("<spring:message code='forum.alert.reg_fail.feedback'/>", "error");
				}
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='forum.common.error' />", "error");/* 오류가 발생했습니다! */
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
				UiComm.showMessage("<spring:message code='common.alert.sysmsg.select_user'/>", "info");
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
			var dscsId = $("#score"+i).data("dscsid") || "${dscsVO.dscsId}";
			var teamId = $("#score"+i).data("teamid") || "";

			if(score === "" || score === undefined) {
				UiComm.showMessage("<spring:message code='forum.alert.input.score' />", "info");/* 점수를 입력하세요. */
				return false;
			}

			if(score > 100) {
				UiComm.showMessage("<spring:message code='forum.alert.score.max_100' />", "info");/* 점수는 100점 까지 입력 가능 합니다. */
				$("#score"+i).val(cScore);
				return false;
			}

			$("#scoreDisplayDiv"+i).show();
			$("#scoreDisplayDiv"+i).addClass("d-inline-block");
			$("#scoreInputDiv"+i).hide();

			if(cScore !== score) {
				var url = "/forum2/forumLect/setScoreRatio.do";

				var data = {
					"dscsId" : dscsId,
					"sbjctId" : "${dscsVO.sbjctId}",
					"teamId" : teamId,
					"stdId" : stdId,
					"scr" : score,
				};

				ajaxCall(url, data, function(data) {
					if(data.result > 0) {
						UiComm.showMessage("<spring:message code='forum.alert.mut.setScore' />", "success"); // 평가점수가 정상적으로 수정되었습니다.
						listForumUser(1);
					} else {
						UiComm.showMessage(data.message, "error");
					}
				}, function(xhr, status, error) {
					UiComm.showMessage("<spring:message code='forum.common.error' />", "error"); // 오류가 발생했습니다!
				}, true);
			}
		}

		// 목록
		function viewDscsList() {
			location.href = "/forum2/forumLect/profForumListView.do?" + "encParams=" + EPARAM;
		}

		// 토론 수정
		function editDscs(dscsId, forumStartDttm) {
			const param = "?dscsId=" + encodeURIComponent(dscsId) + "&encParams=" + EPARAM;
			location.href = '<c:url value="/forum2/forumLect/profDscsEditView.do" />' + param;
		}

		// 토론삭제
		function deleteDscs(dscsId) {
			UiComm.showMessage("<spring:message code='forum.alert.confirm.delete' />", "confirm")
				.then(function(result) {
					if (!result) {
						return;
					}

					$.ajax({
						url: "/forum2/forumLect/profDscsDelete.do",
						type: "POST",
						contentType: "application/json",
						data: JSON.stringify({dscsId:dscsId}),
						dataType: "json",
						beforeSend: function () {
							UiComm.showLoading(true);
						}
					}).done(function(data) {
						UiComm.showLoading(false);
						if (data.result > 0) {
							UiComm.showMessage("<spring:message code='success.common.delete' />", "success")	/* 정상적으로 삭제되었습니다. */
								.then(function() {
									const param = "?encParams=" + EPARAM;
									location.href = '<c:url value="/forum2/forumLect/profForumListView.do" />' + param;
								});
						} else {
							UiComm.showMessage(data.message || "<spring:message code='forum.common.error' />", "error");	/*오류가 발생했습니다!*/
						}
					}).fail(function() {
						UiComm.showLoading(false);
						UiComm.showMessage("<spring:message code='forum.common.error' />", "error");
					});
				});
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
		function dscsChartView() {
			var queryString = $("#dscsChartViewForm").serialize();
			dialog = UiDialog("dialog1", {
				title: "<spring:message code='forum.label.submit.status.graph' />",/*토론현황 그래프*/
				width: 860,
				height: 520,
				url: "/forum2/forumLect/forumChartViewPop.do?" + queryString,
				autoresize: false
			});
		}
	</script>
</head>
<body class="class ${uiex:getTheme()}">
	<form id="teamMemberForm" name="teamMemberForm" action="" method="POST">
		<input type="hidden" name="teamCtgrCd" id="teamCtgrCd">
	</form>
	<form name="dscsCreCrsStdForm" id="dscsCreCrsStdForm" method="POST">
		<input type="hidden" name="dscsId" value="${dscsVO.dscsId }">
		<input type="hidden" name="dscsUnitTycd" value="${dscsVO.dscsUnitTycd}">
		<input type="hidden" name="stdId" value="">
		<input type="hidden" name="teamId" value="">
		<input type="hidden" name="sbjctId" value="${dscsVO.sbjctId}">
	</form>
	<form id="ezGraderForm" name="ezGraderForm" method="POST">
		<input type="hidden" name="sbjctId" value="${dscsVO.sbjctId }" >
		<input type="hidden" name="dscsId" value="${dscsVO.dscsId }" >
		<input type="hidden" name="dscsUnitTycd" value="${dscsVO.dscsUnitTycd}" >
		<input type="hidden" name="evlScrTycd" value="${dscsVO.evlScrTycd}" >
		<input type="hidden" name="stdId" value="">
	</form>
	<form name="dscsChartViewForm" id="dscsChartViewForm" method="POST">
		<input type="hidden" name="dscsId" value="${dscsVO.dscsId }">
		<input type="hidden" name="dscsUnitTycd" value="${dscsVO.dscsUnitTycd}">
		<input type="hidden" name="teamId" value="${dscsVO.teamId}">
		<input type="hidden" name="stdId" value="">
		<input type="hidden" name="sbjctId" value="${dscsVO.sbjctId}">
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
				<!-- class_sub_top -->
				<jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>
				<!-- //class_sub_top -->

				<div class="class_sub">
                    <!-- class_info -->
					<jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>
                    <!-- //class_info -->

					<div class="sub-content">
						<div class="page-info">
							<h2 class="page-title">
								<spring:message code="forum.label.forum" /><!-- 토론 -->
							</h2>
						</div>

						<div class="listTab">
							<ul>
								<li class="mw120 select"><a href="javascript:void(0)" onclick="dscsViewTab(2)"><spring:message code='forum.label.forum.info.score'/><!-- 토론정보 및 평가 --></a></li>
								<li class="mw120"><a  href="javascript:void(0)" onclick="dscsViewTab(1)"><spring:message code='forum.label.forum.bbs'/><!-- 토론방 --></a></li>
							</ul>
						</div>

						<div class="board_top">
							<h3 class="board-title"><spring:message code='forum.label.forum.info.score'/><!-- 토론정보 및 평가 --></h3>
							<div class="right-area">
								<a href="javascript:void(0)" class="btn type1 big" onclick="editDscs('${dscsVO.dscsId}','${dscsVO.dscsSdttm}')"><spring:message code='forum.button.mod'/><!-- 수정 --></a>
								<a href="javascript:void(0)" class="btn type2 big" onclick="deleteDscs('${dscsVO.dscsId}');"><spring:message code='forum.button.del'/><!-- 삭제 --></a>
								<a href="javascript:void(0)" class="btn type2 big" onclick="viewDscsList()"><spring:message code='forum.label.list'/><!-- 목록 --></a>
							</div>
						</div>

						<!-- 토론정보 시작 -->
						<jsp:include page="/WEB-INF/jsp/forum2/common/dscs_info_inc.jsp" />
						<!-- 토론정보 끝 -->

						<div class="board_top mb0">
							<h4 class="sub-title">토론평가</h4>
							<div class="right-area">
								<a href="javascript:ezGraderPop('${dscsVO.dscsId}')" class="btn type2">EZ-Grader</a>
								<%-- <a href="javascript:allFeedback()" class="ui button"><spring:message code="forum.button.all.feedback" /></a><!-- 일괄 피드백 --> --%>
								<a href="javascript:callScoreExcelUpload()" class="btn type2"><spring:message code="forum.button.reg.excel.score" /></a><!-- 엑셀 성적등록 -->

								<%--<uiex:msgSendBtn func="sendMsg()" styleClass="ui basic small button"/><!-- 메시지 -->--%>
								<a href="javascript:sendMsg()" class="btn basic"><spring:message code="common.button.message.send" /><%--메시지 보내기--%></a>
							</div>
						</div>

						<!-- 토론평가 검색:시작 -->
						<div class="board_top in_table">
							<select class="form-select" id="searchKey" onchange="listForumUser(1)">
								<option value="all"><spring:message code='forum.common.search.all'/><!-- 전체 --></option>
								<option value="joinY"><spring:message code='forum.label.join'/><!-- 참여 --></option>
								<%--<option value="after"><spring:message code='forum.label.after.join'/><!-- 지각참여 --></option>--%>
								<option value="joinN"><spring:message code='forum.label.not.join'/><!-- 미참여 --></option>
								<c:if test="${dscsVO.dscsUnitTycd eq 'TEAM'}">
									<option value="leader"><spring:message code='forum.label.team.leader'/><!-- 팀장 --></option>
									<option value="member"><spring:message code='forum.label.team.member'/><!-- 팀원 --></option>
								</c:if>
							</select>
							<select class="form-select" id="searchSort" onchange="listForumUser(1)">
								<option value="all"><spring:message code='forum.common.search.all'/><!-- 전체 --></option>
								<option value="evalY"><spring:message code='forum.label.eval'/><!-- 평가 --></option>
								<option value="evalN"><spring:message code='forum.label.not.eval'/><!-- 미평가 --></option>
							</select>
							<c:if test="${dscsVO.dscsUnitTycd eq 'TEAM'}">
								<select class="form-select" id="searchTeamId" onchange="listForumUser(1)">
									<option value=""><spring:message code="forum.label.team.select" /></option><%--팀 선택--%>
									<c:forEach var="team" items="${teamList}">
										<option value="${team.teamId}"><c:out value="${team.teamnm}" /></option>
									</c:forEach>
								</select>
							</c:if>
							<div class="search-typeC">
								<input class="form-control" id="searchValue" type="text" placeholder="<spring:message code='forum.label.dept.nm' />, <spring:message code='forum.label.user.no' />, <spring:message code='forum.label.user_nm' /> <spring:message code='forum.label.input' />" ><!-- 학과, 학번, 이름 입력 -->
								<button type="button" class="btn basic icon search" onclick="listForumUser(1)"><i class="icon-svg-search"></i></button>
							</div>
							<button type="button" class="btn search" onclick="searchAll()"><spring:message code='forum.button.std.all.search'/><!--수강생 전체--></button>
						</div>
						<!-- 토론평가 검색:끝 -->

						<!-- 토론평가 점수처리 영역:시작 -->
						<div class="table-wrap">
							<table class="table-type5">
							<colgroup>
								<col class="width-15per" />
								<col class="" />
							</colgroup>
							<tbody>
								<c:if test="${authrtCd eq authrtCdProf}">
								<tr>
									<th><spring:message code="common.label.batch.score.process" /><!-- 일괄 점수처리 --></th>
									<td>
										<div class="form-inline">
											<span class="custom-input">
												<input type="radio" name="scoreType" id="scoreBatch" onchange="plusMinusIconControl(this.value)" value="batch" checked />
												<label for="scoreBatch"><spring:message code="forum.label.reg.scoring" /><!-- 점수 등록 --></label>
											</span>
											<span class="custom-input ml5">
												<input type="radio" name="scoreType" id="scoreAddition" onchange="plusMinusIconControl(this.value)" value="addition" />
												<label for="scoreAddition"><spring:message code="forum.label.plus.minus.scoring" /><!-- 점수 가감 --></label>
											</span>
											<div class="custom-txt">
												<span class="tit"><spring:message code="forum.label.score" /><!-- 점수 -->:</span>
												<button type="button" class='btn small basic icon' id="scr-toggle-icon"><i class='xi-plus'></i></button>
												<div class="input_btn">
													<input type="text" id="scoreValue" class="form-control w60" inputmask="numeric" mask="999.9" maxVal="100"/>
													<label for="scoreValue"><spring:message code="forum.label.point" /><!-- 점 --></label>
												</div>
											</div>
											<button type="button" class="btn type1" onclick="javascript:submitScore()"><spring:message code="common.button.save" /><!-- 저장 --></button>
										</div>
									</td>
								</tr>
								<tr>
									<th><spring:message code='forum.button.length.score'/><!-- 글자수로 점수 주기 --></th>
									<td>
										<div class="form-inline">
											<div class="input_btn">
												<input type="text" name="ctsLen" id="ctsLen" placeholder="<spring:message code='forum.alert.len.input'/>" class="w100" inputmask="numeric" mask="99999"><!-- 글자수 입력 -->
												<label for="ctsLen"><spring:message code='forum.label.lt'/><!-- 이상 --></label>
											</div>
											<span class="custom-input">
												<input type="checkbox" name="chkCmnt" id="chkCmnt" value="Y">
												<label for="chkCmnt"><spring:message code='forum.label.comment.include'/><!-- 댓글포함 --></label>
											</span>
											<div class="custom-txt">
												<div class="input_btn">
													<input type="text" name="lenScore" id="lenScore" placeholder="<spring:message code='forum.label.score'/>" class="form-control w60" inputmask="numeric" mask="999.9" maxVal="100"><!-- 점수 -->
													<label for="lenScore"><spring:message code='forum.label.point'/><!-- 점 --></label>
												</div>
											</div>
											<button type="button" class="btn type1" onclick="javascript:lenScore()"><spring:message code='common.button.save'/><!-- 일괄 점수 주기 --></button>
										</div>
										<script>
											function lenScore() {
												var chkCmnt = "N";
												// 글자수 입력
												if($("#ctsLen").val() == "" || $("#ctsLen").val() == undefined){
													UiComm.showMessage("<spring:message code='forum.alert.input.ctsLen' />", "info"); // 글자수를 입력하세요.
													return false;
												}
												if($("#ctsLen").val() < 1 ){
													UiComm.showMessage("<spring:message code='forum.alert.sts.len.min_1' />", "info");/* 글자수는 1자 이상 입력 가능 합니다. */
													return false;
												}
												// 점수 입력
												if($("#lenScore").val() == "" || $("#lenScore").val() == undefined){
													UiComm.showMessage("<spring:message code='forum.alert.input.score' />", "info"); // 점수를 입력하세요.
													return false;
												}
												if($("#lenScore").val() > 100 ){
													UiComm.showMessage("<spring:message code='forum.alert.score.max_100' />", "info");/* 점수는 100점 까지 입력 가능 합니다. */
													return false;
												}
												// 학습자 선택
												if(userListTable.getSelectedData("userId").length == 0) {
													UiComm.showMessage("<spring:message code='forum.alert.select.std' />", "info");/* 학습자를 선택해 주세요. */
													return false;
												}
												if($("input[name=chkCmnt]:checked").val() == "Y") {
													chkCmnt = "Y";
												}
												var url = "/forum2/forumLect/updateDscsJoinUserLenScore.do";
												// 팀토론은 선택된 행의 자식토론ID를 포함해 글자수 조건 대상만 한 번에 처리한다.
												var data = {
													"sbjctId" : "${dscsVO.sbjctId}",
													"ptcpTargets" : getSelectedPtcpTargets(),
													"scr" : $("#lenScore").val(),
													"ctsLen" : $("#ctsLen").val(),
													"chkCmnt" : chkCmnt
												};
												ajaxCall(url, data, function(data) {
													if(data.result > 0) {
														UiComm.showMessage("<spring:message code='forum.alert.length.score.success' />", "success"); // 글자수로 점수 주기를 성공하였습니다.
														$("#stdIds").val("");
														listForumUser(1);
														$("#ctsLen").val("");
														$("input:checkbox[id='chkCmnt']").prop("checked", false);
														$("#lenScore").val("");
													} else {
														UiComm.showMessage("<spring:message code='forum.alert.length.score.fail' />", "error"); // 글자수로 점수 주기가 실패하였습니다!! 다시 시도해주시기 바랍니다.
													}
												}, function(xhr, status, error) {
													UiComm.showMessage("<spring:message code='forum.common.error' />", "error"); // 오류가 발생했습니다!
												}, true);
											}
										</script>
									</td>
								</tr>
								<c:if test="${dscsVO.evlScrTycd == 'PTCP_FULL_SCR'}">
								<tr>
									<th><spring:message code="forum.label.evalctgr.participate.all" /><!-- 참여형 일괄평가 --></th>
									<td>
										<button type="button" class="btn type1" onclick="javascript:partiScore()" class="btn type7"><spring:message code="forum.label.evalctgr.participate.all" /><!-- 참여형 일괄평가 --></button>
										<script>
											function partiScore() {
												UiComm.showMessage(`<spring:message code="forum.confirm.parti.score" />`, "confirm")
													.then(function(result) {
														if (result) {/* 기존 점수는 초기화되고\r\n토론 참여글 등록 수강생은 100점,\r\n미등록 수강생과 댓글만 작성한 수강생은 0점 처리됩니다.\r\n처리하시겠습니까? */
															var url = "/forum2/forumLect/participateScore.do";
															// 부모 토론ID 기준으로 참여형 일괄평가를 배치 처리한다.
															var data = {
																"sbjctId" : "${dscsVO.sbjctId}",
																"dscsId" : "${dscsVO.dscsId}"
															};
															ajaxCall(url, data, function(data) {
																if(data.result > 0) {
																	UiComm.showMessage("<spring:message code='forum.alert.evalctgr.participate.all' />", "success"); // 참여형 일괄평가가 완료되었습니다.
																	listForumUser(1);
																} else {
																	UiComm.showMessage(data.message, "error");
																}
															}, function(xhr, status, error) {
																UiComm.showMessage("<spring:message code='forum.common.error' />", "error"); // 오류가 발생했습니다!
															}, true);
														}
													});
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
													<textarea id="fdbkValue" class="form-control width-100per"
															  rows="2" maxLenCheck="byte,4000,true,false"
															  placeholder="<spring:message code='forum.label.feedback.input'/>"><%--피드백 입력--%></textarea>
													<div id="uploaderBox" class="mt10 width-100per">
														<!-- 피드백 File Uplaod -->
														<uiex:dextuploader
																id="fileUploader"
																path="${dscsVO.uploadPath}"
																limitCount="3"
																limitSize="100"
																oneLimitSize="100"
																listSize="2"
																fileList=""
																finishFunc="finishUpload()"
																allowedTypes="*"
														/>
													</div>
													<button type="button" class="btn type1 mt10" onclick="javascript:valFdbk()"><spring:message code='common.button.save'/><!-- 저장 --></button>
												</div>
											</div>
										</div>
									</td>
								</tr>
							</tbody>
						</table>
						</div>
						<!-- 토론평가 점수처리 영역:끝 -->

						<!-- 검색결과 영역-버튼들:시작 -->
						<div class="board_top margin-top-4">
							<div class="right-area">
								<%-- <div class="sec_head mra"><spring:message code="forum.label.submit.status" /><!-- 토론현황 --></div> --%>
								<a href="javascript:dscsExcelDown()" class="btn basic"><spring:message code="forum.label.excel.download" /></a><!-- 엑셀로 다운로드 -->
								<a href="javascript:dscsChartView()" class="btn type1"><spring:message code="forum.label.submit.status.graph" /></a><!-- 토론현황 그래프-->
							</div>
						</div>
						<!-- 검색결과 영역-버튼들:끝 -->

						<!-- 검색결과 영역:시작 -->
						<div>
							<div id="forumStareUserList"></div>
							<script>
								/* 주의 : 화면 로딩 후 오른쪽 영역 줄어드는 현상 때문에 위치를 html 바깥, document ready 바깥으로 이동함. */
								let userListTable = UiTable("forumStareUserList", {
									lang: "ko",
									selectRow: "checkbox",
									columns: [
										{title:"No", 																 	field:"no",					headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},
										("${dscsVO.dscsUnitTycd}" === "TEAM" ? {title: "<spring:message code='forum.label.team.name'/>"/*팀명*/, 	field: "teamnm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 80} : null),
										{title:"<spring:message code='forum.label.dept.nm'/>"/*학과*/, 					field:"deptnm",				headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:100},
										{title:"<spring:message code='forum.label.user_id'/>"/*아이디*/, 					field:"userId", 			headerHozAlign:"center", hozAlign:"center", width:0, 	minWidth:120},
										{title:"<spring:message code='forum.label.user.no'/>"/*학번*/, 					field:"stdntNo",			headerHozAlign:"center", hozAlign:"center", width:0,	minWidth:100},
										{title:"<spring:message code='forum.label.user_nm'/>"/*이름*/, 								field:"usernm", 			headerHozAlign:"center", hozAlign:"center", width:0,	minWidth:100},
										("${dscsVO.dscsUnitTycd}" === "TEAM" ? {title: "<spring:message code='forum.label.role'/>"/*역할*/, field: "ldryn", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 80} : null),
										{title:"<spring:message code='forum.label.eval.score'/>"/*평가점수*/, 			field:"totScr", 			headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},
										{title:"<spring:message code='forum.label.feedback'/>"/*피드백*/, 				field:"fdk", 				headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},
										("${dscsVO.dscsUnitTycd}" !== "TEAM" && "${dscsVO.oknokStngyn}" == "Y" ? {title:"<spring:message code='forum.label.prosCons.short'/>"/*찬반*/, field:"oknokGbn", headerHozAlign:"center", hozAlign:"center", width:60, minWidth:60} : null),
										{title:"<spring:message code='forum.label.join.status'/>"/*참여상태*/, 			field:"joinStatus", 		headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},
										{title:"<spring:message code='forum.label.join.dt'/>"/*참여일시*/, 				field:"joinDtdm", 			headerHozAlign:"center", hozAlign:"center",	width:140,	minWidth:140},
										{title:"<spring:message code='forum.label.eval.yn'/>"/*평가여부*/, 				field:"evlyn", 				headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},
										{title:"<spring:message code='common.mgr'/>"/*관리*/, 							field:"mng", 				headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:150},
									].filter(function(col) {return col !== null;})
								});
							</script>
						</div>
						<!-- 검색결과 영역:끝 -->
					</div>
				</div>
			</div>
		</main>
		<!-- classroom-->
	</div>

	<!-- ez grader modal pop -->
	<%--<div class="modal fade id" id="ezGraderPop" tabindex="-1" role="dialog" aria-labelledby="ezGrader" aria-hidden="false">
		<div class="modal-dialog full" role="document">
			<div class="modal-content">
				<div class="modal-body">
					<iframe src="" id="ezGraderPopIfm" name="ezGraderPopIfm" width="100%" scrolling="no"></iframe>
				</div>
			</div>
		</div>
	</div>--%>
	<!-- ez grader modal pop -->
</body>
</html>
