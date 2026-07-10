<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/srvy/common/srvy_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="module" value="table"/>
	</jsp:include>

	<script type="text/javascript">
		$(document).ready(function() {
			srvyPtcpListSelect();	// 설문참여목록조회

			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					srvyPtcpListSelect();
				}
			});

			// 일괄 성적처리 아이콘 변경
			$('#scr-toggle-icon').click(function() {
	            $(this).children("i").toggleClass("xi-plus xi-minus");
	        });

			$("#scoreBatch").trigger("click");
		});

		/*
		 * 설문참여목록조회
		 */
		function srvyPtcpListSelect() {
			const url  = "/srvy/profSrvyPtcpListAjax.do";
			const data = {
				srvyId 			: "${vo.srvyId}",
				ptcpyn 			: $("#ptcpyn").val(),
				srvyPtcpEvlyn	: $("#srvyPtcpEvlyn").val(),
				searchValue 	: $("#searchValue").val()
			};

			$.ajax({
		        url 	  	: url,
		        async	  	: false,
		        type 	  	: "POST",
		        dataType 	: "json",
		        data 	  	: JSON.stringify(data),
		        contentType	: "application/json; charset=UTF-8",
		        beforeSend	: () => UiComm.showLoading(true),
                success		: function (data) {
                    if (data.result > 0) {
                    	let dataList = createListHTML(data.returnList);	// 목록 HTML 생성

    		       		userListTable.clearData();
    		       		userListTable.replaceData(dataList);
                    } else {
                    	UiComm.showMessage(data.message, "error");
                    }
                },
                error		: () => UiComm.showMessage("<spring:message code='srvy.error.list' />", "error"),/* 리스트 조회 중 에러가 발생하였습니다. */
                complete	: () => UiComm.showLoading(false)
		    });
		}

		// 목록 HTML 생성
		function createListHTML(list) {
			let dataList = [];

			if(list.length == 0) return dataList;

			list.forEach(function(v,i) {
				// 참여상태
				let ptcpGbnnm = {
					"NOPTCP"	: wrapLabel("<spring:message code='srvy.label.not.ptcp' />", "fcRed")/* 미참여 */,
					"COMPLETED"	: "<spring:message code='srvy.label.ptcp.complete' />"/* 참여완료 */
				};
				// 역할
				let ldryn = {
					"Y"	: "<spring:message code='srvy.label.team.leader' />"/* 팀장 */,
					"N" : "<spring:message code='srvy.label.team.member' />"/* 팀원 */
				};
				// 관리
				let mng = "";
				if(v.ptcpEdttm != null) {
					mng += "<a href='javascript:srvypprEvlPopup(\"" + v.srvyId + "\", \"" + v.srvyPtcpId + "\", \"" + v.userId + "\")' class='btn basic small'><spring:message code='srvy.button.srvyppr.view' /></a>";/* 설문지 보기 */
				}
				mng += "<a href='javascript:memoPopup(\"" + v.srvyId + "\", \"" + v.srvyPtcpId + "\", \"" + v.userId + "\")' class='btn basic small'><spring:message code='srvy.button.memo' /></a>";/* 메모 */

				dataList.push({
					no: 				v.lineNo,
					deptnm: 			v.deptnm,
					stdntNo: 			v.stdntNo,
					usernm: 			v.usernm,
					ptcpEvlScr: 		v.srvyPtcpEvlyn == "Y" ? wrapLabel(v.ptcpEvlScr, "fcBlue") : "-",
					ptcpGbnnm: 			ptcpGbnnm[v.ptcpGbncd],
					ptcpEdttm: 			v.ptcpEdttm == null ? "-" : UiComm.formatDate(v.ptcpEdttm, "datetime2"),
					srvyPtcpEvlyn: 		v.srvyPtcpEvlyn == "N" ? wrapLabel(v.srvyPtcpEvlyn, "fcRed") : v.srvyPtcpEvlyn,
					mng: 				mng,
					ldryn:				ldryn[v.ldryn],
					teamnm:				v.teamnm,
					userId:				v.userId,
					srvyId:				v.srvyId,
					srvyPtcpId:			v.srvyPtcpId
				});
			});

			return dataList;
		}

		/*
		 * 설문지평가팝업
		 * @param upSrvyId 		상위설문아이디
		 * @param srvyId 		설문아이디
		 * @param srvyPtcpId	설문참여아이디
		 * @param userId 		사용자아이디
		 * @param srvyPtcpEvlyn 설문참여평가여부
		 * @param ptcpyn 		참여여부
		 * @param searchValue 	검색어(학과, 학번, 이름)
		 * @param searchKey 	EVL
		 */
		function srvypprEvlPopup(srvyId, srvyPtcpId, userId) {
			var data = "upSrvyId=${vo.srvyId}&srvyId="+srvyId+"&srvyPtcpId="+srvyPtcpId+"&userId="+userId+"&srvyPtcpEvlyn="+$("#srvyPtcpEvlyn").val()+"&ptcpyn=Y&searchValue="+$("#searchValue").val()+"&searchKey=EVL";

			dialog = UiDialog("dialog1", {
				title		: "<spring:message code='srvy.button.srvyppr.view' />"/* 설문지 보기 */,
				url			: "/srvy/profSrvypprEvlPopup.do?"+data,
				fullscreen	: true
			});
		}

		// 점수 가감 아이콘 표시 확인
		function plusMinusIconControl(scoreType){
			$("#scr-toggle-icon").toggle(scoreType === "addition");
		}

		/*
		 * 평가점수일괄수정
		 * @param srvyId 		설문아이디
		 * @param srvyPtcpId 	설문참여아이디
		 * @param userId 		사용자아이디
		 * @param scr 			점수
		 * @param scoreType 	점수유형
		 */
		function EvlScrBulkModify() {
			let validator = UiValidator("scoreForm");
			validator.then(function(result) {
				if (result) {
					if(userListTable.getSelectedData("userId").length == 0) {
						UiComm.showMessage("<spring:message code='srvy.alert.batch.score.select' />", "info");/* 일괄 성적처리할 학습자를 선택해주세요. */
						return;
					}

					let score = $("#scoreValue").val();
					if($("input[name='scoreType']:checked").val() == "addition"){
						if(!$("#scr-toggle-icon").children("i").attr("class").includes("xi-plus")){
							score = score * (-1);
						}
					}

					const scrList = [];	// 점수 목록

					for(var i = 0; i < userListTable.getSelectedData("userId").length; i++) {
						scrList.push({
							srvyId 			: userListTable.getSelectedData("srvyId")[i],		// 설문아이디
							srvyPtcpId 		: userListTable.getSelectedData("srvyPtcpId")[i],	// 설문참여아이디
							userId			: userListTable.getSelectedData("userId")[i],		// 사용자아이디
							scr				: score,											// 점수
							scoreType		: $("input[name='scoreType']:checked").val()		// 점수유형
						});
					}

					$.ajax({
		                url			: "/srvy/profSrvyEvlScrBulkModifyAjax.do",
		                type		: "POST",
		                contentType	: "application/json",
		                data		: JSON.stringify(scrList),
		                dataType	: "json",
		                beforeSend	: () => UiComm.showLoading(true),
		                success		: function (data) {
		                    if (data.result > 0) {
		                    	UiComm.showMessage("<spring:message code='srvy.alert.batch.score' />", "success");/* 일괄 점수 등록이 완료되었습니다. */
		                    	$("#scoreValue").val("");
				        		srvyPtcpListSelect();
		                    } else {
		                    	UiComm.showMessage(data.message, "error");
		                    }
		                },
		                error		: () => UiComm.showMessage("<spring:message code='srvy.error.batch.score' />", "error"),/* 일괄 점수 등록 중 에러가 발생하였습니다. */
		                complete	: () => UiComm.showLoading(false)
		            });
				}
			});
		}

		/*
		 * 메모팝업
		 * @param srvyId 		설문아이디
		 * @param srvyPtcpId	설문참여아이디
		 * @param userId 		사용자아이디
		 */
		function memoPopup(srvyId, srvyPtcpId, userId) {
			const data = "srvyId="+srvyId+"&srvyPtcpId="+srvyPtcpId+"&userId="+userId;

			dialog = UiDialog("dialog1", {
				title		: "<spring:message code='srvy.button.memo' />"/* 메모 */,
				width		: 600,
				height		: 350,
				url			: "/srvy/profSrvyMemoPopup.do?"+data,
				autoresize	: true
			});
		}

		/*
		 * 엑셀성적등록팝업
		 * @param srvyId 		설문아이디
		 */
		function excelScrRegistPopup() {
			dialog = UiDialog("dialog1", {
				title		: "<spring:message code='srvy.button.excel.upload.score' />"/* 엑셀 성적등록 */,
				width		: 600,
				height		: 500,
				url			: "/srvy/profSrvyExcelScrRegistPopup.do?srvyId=${vo.srvyId}",
				autoresize	: true
			});
		}

		/*
		 * 설문참여목록엑셀다운로드
		 * @param srvyId 			설문아이디
		 * @param ptcpyn 			참여여부
		 * @param srvyPtcpEvlyn 	설문참여평가여부
		 * @param searchValue 		검색어(학과, 학번, 이름)
		 * @param excelGrid
		 */
		function srvyPtcpListExcelDown() {
			let isSrvyTeam = "${vo.srvyGbn}" === "SRVY_TEAM";
			let ldrynObj = {
				  Y: "<spring:message code='srvy.label.team.leader' />"/* 팀장 */
				, N: "<spring:message code='srvy.label.team.member' />"/* 팀원 */
			};
			let ptcpGbncdObj = {
				  NOPTCP	: "<spring:message code='srvy.label.not.ptcp' />"/* 미참여 */
				, COMPLETED	: "<spring:message code='srvy.label.ptcp.complete' />"/* 참여완료 */
			};

			let excelGrid = { colModel: [] };

			excelGrid.colModel.push({label: 'No.', 													name: 'lineNo', 			align: 'center', 	width: '1000'});
			if(isSrvyTeam) {
				excelGrid.colModel.push({label: "<spring:message code='srvy.label.team.name' />", 	name: 'teamnm', 			align: 'left', 		width: '4000'});/* 팀명 */
			}
			excelGrid.colModel.push({label: "<spring:message code='srvy.label.dept' />", 			name: 'deptnm', 			align: 'left', 		width: '5000'});/* 학과 */
			excelGrid.colModel.push({label: "<spring:message code='srvy.label.user.no' />", 		name: 'stdntNo', 			align: 'center', 	width: '5000'});/* 학번 */
			excelGrid.colModel.push({label: "<spring:message code='srvy.label.user.nm' />", 		name: 'usernm', 			align: 'center', 	width: '5000'});/* 이름 */
			if(isSrvyTeam) {
				excelGrid.colModel.push({label: "<spring:message code='srvy.label.team.role' />", 	name: 'ldryn', 				align: 'center', 	width: '3000', 	codes: ldrynObj});/* 역할 */
			}
			excelGrid.colModel.push({label: "<spring:message code='srvy.label.evl.score' />", 		name: 'ptcpEvlScr', 		align: 'center', 	width: '3000'});/* 평가점수 */
			excelGrid.colModel.push({label: "<spring:message code='srvy.label.ptcp.status2' />", 	name: 'ptcpGbncd', 			align: 'center', 	width: '3000', 	codes: ptcpGbncdObj});/* 참여상태 */
			excelGrid.colModel.push({label: "<spring:message code='srvy.label.ptcp.dt' />", 		name: 'ptcpEdttm', 			align: 'center', 	width: '5000'});/* 참여일시 */
			excelGrid.colModel.push({label: "<spring:message code='srvy.label.evl.yn' />", 			name: 'srvyPtcpEvlyn', 		align: 'center', 	width: '3000'});/* 평가여부 */

			let kvArr = [];
			kvArr.push({'key' : 'srvyId', 	   		'val' : "${vo.srvyId}"});
			kvArr.push({'key' : 'ptcpyn', 			'val' : $("#ptcpyn").val()});
			kvArr.push({'key' : 'srvyPtcpEvlyn', 	'val' : $("#srvyPtcpEvlyn").val()});
			kvArr.push({'key' : 'searchValue', 		'val' : $("#searchValue").val()});
			kvArr.push({'key' : 'excelGrid',   		'val' : JSON.stringify(excelGrid)});

			submitForm("/srvy/profSrvyPtcpListExcelDown.do", kvArr);
		}

		/*
		 * 설문결과엑셀다운로드
		 * @param srvyId 		설문아이디
		 * @param sbjctId 		과목아이디
		 */
		function srvyPtcpStatusExcelDown() {
			let kvArr = [];
			kvArr.push({'key' : 'srvyId', 	'val' : "${vo.srvyId}"});
			kvArr.push({'key' : 'sbjctId', 	'val' : "${vo.sbjctId}"});

			submitForm("/srvy/profSrvyPtcpStatusExcelDown.do", kvArr);
		}

		/*
		 * 제출설문엑셀다운로드
		 * @param srvyId 		설문아이디
		 */
		function srvyRspnsExcelDown() {
	    	let kvArr = [];
			kvArr.push({'key' : 'srvyId', 	'val' : "${vo.srvyId}"});

			submitForm("/srvy/profSrvyRspnsStatusExcelDown.do", kvArr);
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

			if (userListTable.getSelectedData("userId").length == 0) {
				UiComm.showMessage("<spring:message code='common.alert.sysmsg.select_user'/>", "warning");	/* 메시지 발송 대상자를 선택하세요. */
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

		/*
		 * 설문삭제
		 * @param srvyId 		설문아이디
		 * @param sbjctId 		과목아이디
		 */
		function srvyDelete() {
			let confirm = "<spring:message code='srvy.confirm.delete.answer.user.n' />";/* 설문 응시한 학습자가 없습니다. 삭제 하시겠습니까? */
			if(${vo.ptcpUserCnt > 0}) {
				confirm = "<spring:message code='srvy.confirm.delete.answer.user.y' />";/* 설문 응시한 학습자가 있습니다. 삭제 시 학습정보가 삭제됩니다. 정말 삭제하시겠습니까? */
			}
			UiComm.showMessage(confirm, "confirm")
			.then(function(result) {
				if (result) {
					const extData = {
						srvyId 	: "${vo.srvyId}",
						delyn	: "Y"
					};

					const url   = "/srvy/srvyDeleteAjax.do";
					const param = {
						  encParams	: EPARAM
						, addParams	: UiComm.makeEncParams(extData)
					};

					ajaxCall(url, param, function(data) {
						if (data.result > 0) {
							UiComm.showMessage("<spring:message code='srvy.alert.delete' />", "success", 500)	/* 정상 삭제 되었습니다. */
							.then(function(result) {
								srvyViewMv("", "PROFLIST");
							});
			            } else {
			             	UiComm.showMessage(data.message, "error");
			            }
		    		}, function(xhr, status, error) {
		    			UiComm.showMessage("<spring:message code='srvy.error.delete' />", "error");/* 삭제 중 에러가 발생하였습니다. */
		    		}, true);
				}
			});
		}

		/*
		 * 참여현황팝업
		 * @param upSrvyId 		상위설문아이디
		 * @param srvyId 		설문아이디
		 * @param sbjctId 		과목아이디
		 */
		function ptcpChartPop() {
			const data = "upSrvyId=${vo.srvyId}&srvyId=${vo.subSrvyId}&sbjctId=${vo.sbjctId}";

			dialog = UiDialog("dialog1", {
				title		: "<spring:message code='srvy.label.ptcp.status' />",/* 참여현황 */
				url			: "/srvy/srvyPtcpStatusPopup.do?"+data,
				fullscreen	: true
			});
		}

		// 수강생 전체 버튼
		function resetListSelect() {
			$("#ptcpyn").val('').trigger('chosen:updated');
			$("#srvyPtcpEvlyn").val('').trigger("chosen:updated");
			$("#searchValue").val("");
			srvyPtcpListSelect();	// 설문참여목록조회
		}

		/*
		 * EZ-Grader 팝업
		 * @param srvyId 		설문아이디
		 */
		function ezGraderPopup() {
			dialog = UiDialog("dialog2", {
				url			: "/srvy/ezgrader/srvyEzGraderPopup.do?srvyId=${vo.srvyId}",
				titlebar	: false,
				fullscreen	: true
			});
		}
	</script>
</head>

<body class="class ${uiex:getTheme()}">
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
                                <spring:message code="srvy.common.srvy" /><!-- 설문 -->
                            </h2>
				        </div>

				        <div class="listTab">
					        <ul>
					            <li class="select"><a onclick="srvyViewMv('${vo.srvyId}', 'PROFEVL')"><spring:message code="srvy.tab.evl" /><!-- 설문정보 및 평가 --></a></li>
					            <li><a onclick="srvyViewMv('${vo.srvyId}', 'PROFQSTN')"><spring:message code="srvy.tab.qstn" /><!-- 문항관리 --></a></li>
					        </ul>
					    </div>

				        <div class="board_top">
				        	<h3 class="board-title"><spring:message code="srvy.tab.evl" /><!-- 설문정보 및 평가 --></h3>
					        <div class="right-area">
					        	<a href="javascript:srvyViewMv('${vo.srvyId}', 'PROFMODIFY')" class="btn type1 big"><spring:message code="srvy.button.modify" /></a><!-- 수정 -->
								<a href="javascript:srvyDelete()" class="btn type2 big"><spring:message code="srvy.button.delete" /></a><!-- 삭제 -->
								<a href="javascript:srvyViewMv('', 'PROFLIST')" class="btn type2 big"><spring:message code="srvy.button.list" /></a><!-- 목록 -->
					        </div>
				        </div>

					    <%--설문 정보--%>
	                    <jsp:include page="/WEB-INF/jsp/srvy/common/srvy_info_inc.jsp"/>
	                    <%--설문 정보--%>

						<div>
							<div class="board_top mb0">
	                            <h4 class="sub-title"><spring:message code="srvy.button.evl" /><!-- 설문평가 --></h4>
	                            <div class="right-area">
	                                <button type="button" class="btn type2" onclick="ezGraderPopup()">EZ-Grader</button>
	                                <button type="button" class="btn type2" onclick="excelScrRegistPopup()"><spring:message code="srvy.button.excel.upload.score" /><!-- 엑셀 성적등록 --></button>
	                                <button type="button" class="btn basic" onclick="sendMsg()"><spring:message code="srvy.button.message.send" /><!-- 메세지 보내기 --></button>
	                            </div>
	                        </div>

	                        <div class="board_top in_table">
	                            <select class="form-select" id="ptcpyn" onchange="srvyPtcpListSelect()">
	                                <option value=""><spring:message code="srvy.label.ptcp.yn" /><!-- 참여여부 --></option>
									<option value="all"><spring:message code="srvy.common.all" /><!-- 전체 --></option>
									<option value="N"><spring:message code="srvy.label.not.ptcp" /><!-- 미참여 --></option>
									<option value="Y"><spring:message code="srvy.label.ptcp.complete" /><!-- 참여완료 --></option>
	                            </select>
	                            <select class="form-select" id="srvyPtcpEvlyn" onchange="srvyPtcpListSelect()">
	                                <option value=""><spring:message code="srvy.label.evl.yn" /><!-- 평가여부 --></option>
									<option value="all"><spring:message code="srvy.common.all" /><!-- 전체 --></option>
									<option value="Y"><spring:message code="srvy.label.evl.y" /><!-- 평가 --></option>
									<option value="N"><spring:message code="srvy.label.evl.n" /><!-- 미평가 --></option>
	                            </select>
	                            <!-- search small -->
	                            <div class="search-typeC">
	                                <input class="form-control" type="text" id="searchValue" placeholder="<spring:message code="message.search.input.dept.user.user.nm" />"><!-- 학과/학번/성명 입력 -->
	                                <button type="button" class="btn basic icon search" aria-label="검색" onclick="srvyPtcpListSelect()"><i class="icon-svg-search"></i></button>
	                            </div>
	                            <button type="button" class="btn search" onclick="resetListSelect()"><spring:message code="srvy.button.all.learners" /><!-- 수강생 전체 --></button>
	                        </div>

	                        <div class="table-wrap">
								<table class="table-type5">
									<colgroup>
										<col class="width-15per" />
										<col class="" />
									</colgroup>
									<tbody>
	                                    <tr>
	                                        <th><label><spring:message code="srvy.label.batch.score.processing" /><!-- 일괄 성적처리 --></label></th>
	                                        <td>
	                                            <div class="form-inline">
	                                                <span class="custom-input">
	                                                    <input type="radio" name="scoreType" id="scoreBatch" onchange="plusMinusIconControl(this.value)" value="batch" required="true">
	                                                    <label for="scoreBatch"><spring:message code="srvy.label.reg.scoring" /><!-- 점수 등록 --></label>
	                                                </span>
	                                                <span class="custom-input ml5">
	                                                    <input type="radio" name="scoreType" id="scoreAddition" onchange="plusMinusIconControl(this.value)" value="addition" required="true">
	                                                    <label for="scoreAddition"><spring:message code="srvy.label.plus.minus.scoring" /><!-- 점수 가감 --></label>
	                                                </span>
	                                                <div class="custom-txt">
	                                                    <span class="tit"><spring:message code="srvy.label.score" /><!-- 점수 --> :</span>
	                                                    <button class='btn small basic icon' id="scr-toggle-icon"><i class='xi-plus'></i></button>
	                                                    <div class="input_btn">
	                                                        <input type="text" id="scoreValue" class="w100" inputmask="numeric" mask="999.99" maxVal="100" required="true" />
	                                                        <label for="scoreValue"><spring:message code="srvy.label.score.point" /><!-- 점 --></label>
	                                                    </div>
	                                                </div>
	                                                <button type="button" class="btn type1" onclick="EvlScrBulkModify()"><spring:message code="srvy.button.save" /><!-- 저장 --></button>
	                                            </div>
	                                        </td>
	                                    </tr>
	                                </tbody>
	                            </table>
	                        </div>

	                        <div class="board_top">
								<div class="right-area">
									<button type="button" class="btn basic" onclick="srvyRspnsExcelDown()"><spring:message code="srvy.button.excel.down.ptcp.srvy" /><!-- 제출설문 엑셀다운로드 --></button>
									<button type="button" class="btn basic" onclick="srvyPtcpStatusExcelDown()"><spring:message code="srvy.button.excel.down.srvy.result" /><!-- 설문결과 엑셀다운로드 --></button>
									<button type="button" class="btn basic" onclick="srvyPtcpListExcelDown()"><spring:message code="srvy.button.excel.down" /><!-- 엑셀 다운로드 --></button>
	                                <button type="button" class="btn type2" onclick="ptcpChartPop()"><spring:message code="srvy.button.ptcp.status.chart" /><!-- 참여현황 그래프 --></button>
								</div>
							</div>

							<div id="list"></div>

							<script>
								let userListTable = UiTable("list", {
									lang: "ko",
									selectRow: "checkbox",
									columns: [
										{title:"No", 																				field:"no",					headerHozAlign:"center", 	hozAlign:"center", 	width:40,	minWidth:40},
										("${vo.srvyGbn}" == "SRVY_TEAM" ? {title: "<spring:message code='srvy.label.team.name' />", field: "teamnm", 			headerHozAlign: "center", 	hozAlign: "center", width: 0, 	minWidth: 80} : null),/* 팀명 */
										{title:"<spring:message code='srvy.label.dept' />", 										field:"deptnm",				headerHozAlign:"center", 	hozAlign:"center",	width:0,	minWidth:100},/* 학과 */
										{title:"<spring:message code='srvy.label.user.no' />", 										field:"stdntNo", 			headerHozAlign:"center", 	hozAlign:"center", 	width:0,	minWidth:100},/* 학번 */
										{title:"<spring:message code='srvy.label.user.nm' />", 										field:"usernm", 			headerHozAlign:"center", 	hozAlign:"center", 	width:0,	minWidth:100},/* 이름 */
										("${vo.srvyGbn}" == "SRVY_TEAM" ? {title: "<spring:message code='srvy.label.team.role' />", field: "ldryn", 			headerHozAlign: "center", 	hozAlign: "center", width: 0, 	minWidth: 80} : null),/* 역할 */
										{title:"<spring:message code='srvy.label.evl.score' />", 									field:"ptcpEvlScr", 		headerHozAlign:"center", 	hozAlign:"center",	width:80,	minWidth:80},/* 평가점수 */
										{title:"<spring:message code='srvy.label.ptcp.status2' />", 								field:"ptcpGbnnm", 			headerHozAlign:"center", 	hozAlign:"center",	width:80,	minWidth:80},/* 참여상태 */
										{title:"<spring:message code='srvy.label.ptcp.dt' />", 										field:"ptcpEdttm", 			headerHozAlign:"center", 	hozAlign:"center",	width:150,	minWidth:150},/* 참여일시 */
										{title:"<spring:message code='srvy.label.evl.yn' />", 										field:"srvyPtcpEvlyn",		headerHozAlign:"center", 	hozAlign:"center",	width:80,	minWidth:80},/* 평가여부 */
										{title:"<spring:message code='srvy.label.manage' />", 										field:"mng", 				headerHozAlign:"center", 	hozAlign:"center",	width:0,	minWidth:200},/* 관리 */
									].filter(function(col) {return col !== null;})
								});
							</script>
						</div>
					</div>
				</div>
			</div>
			<!-- //content -->
        </main>
        <!-- //classroom-->
    </div>
</body>
</html>