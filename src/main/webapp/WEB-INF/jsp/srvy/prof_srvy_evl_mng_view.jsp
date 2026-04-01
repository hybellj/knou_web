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
		var dialog;

		$(document).ready(function() {
			srvyPtcpListSelect();

			// 학습그룹부과제설정시 설문 부 과제 목록 조회
			if("${vo.byteamSubsrvyUseyn}" == "Y") {
				srvySubAsmtListSelect();
			}

			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					srvyPtcpListSelect();
				}
			});

			// 일괄 성적처리 아이콘 변경
			$('#scr-toggle-icon').click(function() {
	            $(this).children("i").toggleClass("xi-plus xi-minus");
	        });

			$(".accordion").accordion();
			const title = document.querySelector('.accordion .title');

			document.querySelector('.accordion .title').addEventListener('click', () => {
			  	const content = title.nextElementSibling;
			  	content.classList.toggle('hide');
			});

			$("#scoreBatch").trigger("click");
		});

		/**
		 * 설문화면이동
		 * @param {String}  srvyId 		- 설문아이디
		 * @param {String}  sbjctId 	- 과목아이디
		 */
		function srvyViewMv(tab) {
			var urlMap = {
				"1" : "/srvy/profSrvyQstnMngView.do",		// 설문 문항 관리 화면
				"2" : "/srvy/profSrvyEvlMngView.do",		// 설문 평가 관리 화면
				"4" : "/srvy/profSrvyModifyView.do",		// 설문 수정 화면
				"9" : "/srvy/profSrvyListView.do"			// 설문 목록 화면
			};

			var kvArr = [];
			kvArr.push({'key' : 'srvyId',   	'val' : "${vo.srvyId}"});
			kvArr.push({'key' : 'sbjctId', 		'val' : "${vo.sbjctId}"});

			submitForm(urlMap[tab], kvArr);
		}

		/**
		* 설문참여목록조회
		* @param {String}  srvyId 			- 설문아이디
		* @param {String}  ptcpyn 			- 참여여부
		* @param {String}  srvyPtcpEvlyn	- 설문참여평가여부
		* @param {String}  searchValue 		- 검색어(학과, 학번, 이름)
		* @returns {list} 설문참여목록
		*/
		function srvyPtcpListSelect() {
			UiComm.showLoading(true);
			var url  = "/srvy/profSrvyPtcpListAjax.do";
			var data = {
				"srvyId" 		: "${vo.srvyId}",
				"ptcpyn" 		: $("#ptcpyn").val(),
				"srvyPtcpEvlyn" : $("#srvyPtcpEvlyn").val(),
				"searchValue" 	: $("#searchValue").val()
			};

			$.ajax({
		        url 	  : url,
		        async	  : false,
		        type 	  : "POST",
		        dataType : "json",
		        data 	  : JSON.stringify(data),
		        contentType: "application/json; charset=UTF-8",
		    }).done(function(data) {
		   		UiComm.showLoading(false);
		    	if (data.result > 0) {
		    		var returnList = data.returnList || [];
		       		var dataList = createUserListHTML(returnList);	// 수강생 리스트 HTML 생성

		       		userListTable.clearData();
		       		userListTable.replaceData(dataList);
		        } else {
		       		UiComm.showMessage(data.message, "error");
		        }
		    }).fail(function() {
			   	UiComm.showLoading(false);
			   	UiComm.showMessage("<spring:message code='exam.error.list' />", "error");/* 리스트 조회 중 에러가 발생하였습니다. */
		    });
		}

		// 수강생 리스트 HTML 생성
		function createUserListHTML(userList) {
			let dataList = [];

			if(userList.length == 0) {
				return dataList;
			} else {
				userList.forEach(function(v,i) {
					var ptcpGbnnm = "";
					var ptcpEvlScr = v.ptcpEvlScr;
					var ptcpDttm = v.ptcpDttm;
					if(v.ptcpDttm == null) {
						ptcpEvlScr = v.srvyPtcpEvlyn == "Y" ? v.ptcpEvlScr : "-";
						ptcpDttm = "-";
					} else {
						ptcpDttm = UiComm.formatDate(v.ptcpDttm, "datetime2");
					}
					if(v.ptcpGbncd == "NOPTCP") {
						ptcpGbnnm = "미참여";
					} else if(v.ptcpGbncd == "COMPLETED") {
						ptcpGbnnm = "참여완료";
					}
					var ldryn = v.ldryn == "Y" ? "팀장" : "팀원";
					var mng = "";
					if(v.ptcpDttm != null) {
						mng += "<a href='javascript:srvypprEvlPopup(\"" + v.srvyId + "\", \"" + v.srvyPtcpId + "\", \"" + v.userId + "\")' class='btn basic small'>설문지보기</a>";
					}
					mng += "<a href='javascript:memoPopup(\"" + v.srvyId + "\", \"" + v.srvyPtcpId + "\", \"" + v.userId + "\")' class='btn basic small'>메모</a>";

					dataList.push({
						no: 				v.lineNo,
						deptnm: 			v.deptnm,
						userRprsId: 		v.userRprsId,
						stdntNo: 			v.stdntNo,
						usernm: 			v.usernm,
						ptcpEvlScr: 		ptcpEvlScr,
						ptcpGbnnm: 			ptcpGbnnm,
						ptcpDttm: 			ptcpDttm,
						srvyPtcpEvlyn: 		v.srvyPtcpEvlyn,
						mng: 				mng,
						ldryn:				ldryn,
						teamnm:				v.teamnm,
						userId:				v.userId,
						srvyId:				v.srvyId,
						srvyPtcpId:			v.srvyPtcpId
					});
				});
			}

			return dataList;
		}

		/**
		 * 설문지평가팝업
		 * @param {String}  srvyId 			- 설문아이디
		 * @param {String}  srvyPtcpId 		- 설문참여아이디
		 * @param {String}  userId 			- 사용자아이디
		 * @param {String}  srvyPtcpEvlyn 	- 평가여부
		 * @param {String}  ptcpyn 			- 참여여부
		 * @param {String}  searchValue 	- 검색어(학과, 학번, 이름)
		 * @param {String}  searchKey 		- EVL
		 */
		function srvypprEvlPopup(srvyId, srvyPtcpId, userId) {
			var data = "upSrvyId=${vo.srvyId}&srvyId="+srvyId+"&srvyPtcpId="+srvyPtcpId+"&userId="+userId+"&srvyPtcpEvlyn="+$("#srvyPtcpEvlyn").val()+"&ptcpyn=Y&searchValue="+$("#searchValue").val()+"&searchKey=EVL";

			dialog = UiDialog("dialog1", {
				title: "설문지보기",
				width: 600,
				height: 500,
				url: "/srvy/profSrvypprEvlPopup.do?"+data,
				autoresize: true
			});
		}

		// 점수 가감 아이콘 표시 확인
		function plusMinusIconControl(scoreType){
			if(scoreType == 'batch'){
				$("#scr-toggle-icon").hide();
			}else if(scoreType == 'addition'){
				$("#scr-toggle-icon").show();
			}
		}

		/**
		* 평가점수일괄수정
		* @param {String}  srvyId 		- 설문아이디
		* @param {String}  srvyPtcpId 	- 설문참여아이디
		* @param {String}  userId 		- 사용자아이디
		*/
		function EvlScrBulkModify() {
			let validator = UiValidator("scoreForm");
			validator.then(function(result) {
				if (result) {
					if(userListTable.getSelectedData("userId").length == 0) {
						UiComm.showMessage("일괄 성적처리할 학습자를 선택해주세요.", "info");
						return;
					}

					var score = $("#scoreValue").val();
					if($("input[name='scoreType']:checked").val() == "addition"){
						if(!$("#scr-toggle-icon").children("i").attr("class").includes("xi-plus")){
							score = score * (-1);
						}
					}

					var scrList = [];	// 점수 목록

					for(var i = 0; i < userListTable.getSelectedData("userId").length; i++) {
						var scr = {
							srvyId 			: userListTable.getSelectedData("srvyId")[i],		// 설문아이디
							srvyPtcpId 		: userListTable.getSelectedData("srvyPtcpId")[i],	// 설문참여아이디
							userId			: userListTable.getSelectedData("userId")[i],		// 사용자아이디
							scr				: score,											// 점수
							scoreType		: $("input[name='scoreType']:checked").val()		// 점수유형
						};
						scrList.push(scr);
					}

					$.ajax({
		                url: "/srvy/profSrvyEvlScrBulkModifyAjax.do",
		                type: "POST",
		                contentType: "application/json",
		                data: JSON.stringify(scrList),
		                dataType: "json",
		                beforeSend: function () {
		                	UiComm.showLoading(true);
		                },
		                success: function (data) {
		                    if (data.result > 0) {
		                    	UiComm.showMessage("<spring:message code='exam.alert.batch.score' />", "success");/* 일괄 점수 등록이 완료되었습니다. */
		                    	$("#scoreValue").val("");
				        		srvyPtcpListSelect();
		                    } else {
		                    	UiComm.showMessage(data.message, "error");
		                    }
		                    UiComm.showLoading(false);
		                },
		                error: function (xhr, status, error) {
		                	UiComm.showMessage("<spring:message code='exam.error.batch.score' />", "error");/* 일괄 점수 등록 중 에러가 발생하였습니다. */
		                },
		                complete: function () {
		                	UiComm.showLoading(false);
		                },
		            });
				}
			});
		}

		/**
		 * 메모팝업
		 * @param {String}  srvyId 		- 설문아이디
		 * @param {String}  srvyPtcpId 	- 설문참여아이디
		 * @param {String}  userId 		- 사용자아이디
		 */
		function memoPopup(srvyId, srvyPtcpId, userId) {
			var data = "srvyId="+srvyId+"&srvyPtcpId="+srvyPtcpId+"&userId="+userId;

			dialog = UiDialog("dialog1", {
				title: "메모",
				width: 600,
				height: 350,
				url: "/srvy/profSrvyMemoPopup.do?"+data
			});
		}

		/**
		 * 엑셀성적등록팝업
		 * @param {String}  srvyId 		- 설문아이디
		 * @param {String}  sbjctId 	- 과목아이디
		 */
		function excelScrRegistPopup() {
			var data = "srvyId=${vo.srvyId}&sbjctId=${vo.sbjctId}";

			dialog = UiDialog("dialog1", {
				title: "엑셀 성적등록",
				width: 600,
				height: 500,
				url: "/srvy/profSrvyExcelScrRegistPopup.do?"+data,
				autoresize: true
			});
		}

		/**
		 * 설문참여목록엑셀다운로드
		 * @param {String}  srvyId 			설문아이디
	     * @param {String}  ptcpyn 			참여여부
	     * @param {String}  srvyPtcpEvlyn 	평가여부
	     * @param {String}  searchValue 	검색어 ( 학과, 학번, 성명 )
	     * @param {String}  excelGrid 		엑셀그리드
		 */
		function srvyPtcpListExcelDown() {
			var srvyGbn = "${vo.srvyGbn}";
			var ldrynObj = {
				Y: "팀장", N: "팀원"
			};
			var ptcpGbncdObj = {
				  NOPTCP: "미참여"
				, COMPLETED: "참여완료"
			};

			var excelGrid = { colModel: [] };

			excelGrid.colModel.push({label: 'No.', 		name: 'lineNo', 			align: 'center', 	width: '1000'});
			if(srvyGbn == "SRVY_TEAM") {
				excelGrid.colModel.push({label: '팀명', 	name: 'teamnm', 			align: 'left', 		width: '4000'});
			}
			excelGrid.colModel.push({label: "학과", 		name: 'deptnm', 			align: 'left', 		width: '5000'});
			excelGrid.colModel.push({label: "대표아이디", 	name: 'userRprsId', 		align: 'left', 		width: '5000'});
			excelGrid.colModel.push({label: "학번", 		name: 'stdntNo', 			align: 'center', 	width: '5000'});
			excelGrid.colModel.push({label: "이름", 		name: 'usernm', 			align: 'center', 	width: '5000'});
			if(srvyGbn == "SRVY_TEAM") {
				excelGrid.colModel.push({label: "역할", 	name: 'ldryn', 				align: 'center', 	width: '3000', 	codes: ldrynObj});
			}
			excelGrid.colModel.push({label: "평가점수", 	name: 'ptcpEvlScr', 		align: 'center', 	width: '3000'});
			excelGrid.colModel.push({label: "참여상태", 	name: 'ptcpGbncd', 			align: 'center', 	width: '3000', 	codes: ptcpGbncdObj});
			excelGrid.colModel.push({label: "참여일시", 	name: 'ptcpDttm', 			align: 'center', 	width: '5000'});
			excelGrid.colModel.push({label: "평가여부", 	name: 'srvyPtcpEvlyn', 		align: 'center', 	width: '3000'});

			var kvArr = [];
			kvArr.push({'key' : 'srvyId', 	   		'val' : "${vo.srvyId}"});
			kvArr.push({'key' : 'ptcpyn', 			'val' : $("#ptcpyn").val()});
			kvArr.push({'key' : 'srvyPtcpEvlyn', 	'val' : $("#srvyPtcpEvlyn").val()});
			kvArr.push({'key' : 'searchValue', 		'val' : $("#searchValue").val()});
			kvArr.push({'key' : 'excelGrid',   		'val' : JSON.stringify(excelGrid)});

			submitForm("/srvy/profSrvyPtcpListExcelDown.do", kvArr);
		}

		/**
		 * 설문결과엑셀다운로드
		 * @param {String}  srvyId 		설문아이디
	     * @param {String}  sbjctId 	과목아이디
		 */
		function srvyPtcpStatusExcelDown() {
			var kvArr = [];
			kvArr.push({'key' : 'srvyId', 	'val' : "${vo.srvyId}"});
			kvArr.push({'key' : 'sbjctId', 	'val' : "${vo.sbjctId}"});

			submitForm("/srvy/profSrvyPtcpStatusExcelDown.do", kvArr);
		}

		/**
		 * 제출설문엑셀다운로드
		 * @param {String}  srvyId 		설문아이디
	     * @param {String}  sbjctId 	과목아이디
		 */
		function srvyRspnsExcelDown() {
			var kvArr = [];
			kvArr.push({'key' : 'srvyId', 	'val' : "${vo.srvyId}"});
			kvArr.push({'key' : 'sbjctId', 	'val' : "${vo.sbjctId}"});

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

		/**
		 * 설문삭제
		 * @param {String}  srvyId 		- 설문아이디
		 * @param {String}  sbjctId 	- 과목아이디
		 * @param {String}  delyn 		- 삭제여부
		 */
		function srvyDelete() {
			var confirm = "";
			if(${vo.ptcpUserCnt > 0}) {
				confirm = "설문 응시한 학습자가 있습니다. 삭제 시 학습정보가 삭제됩니다. 정말 삭제하시겠습니까?";
			} else {
				confirm = "<spring:message code='resh.confirm.exist.answer.user.n' />";/* 설문 응시한 학습자가 없습니다. 삭제 하시겠습니까? */
			}
			UiComm.showMessage(confirm, "confirm")
			.then(function(result) {
				if (result) {
					var url  = "/srvy/srvyDeleteAjax.do";
					var data = {
						  "srvyId" 	: "${vo.srvyId}"
						, "sbjctId"	: "${vo.sbjctId}"
						, "delyn"	: "Y"
					};

					ajaxCall(url, data, function(data) {
						if (data.result > 0) {
							UiComm.showMessage("<spring:message code='exam.alert.delete' />", "success", 500)	/* 정상 삭제 되었습니다. */
							.then(function(result) {
								srvyViewMv(9);
							});
			            } else {
			             	UiComm.showMessage(data.message, "error");
			            }
		    		}, function(xhr, status, error) {
		    			UiComm.showMessage("<spring:message code='exam.error.delete' />", "error");/* 삭제 중 에러가 발생하였습니다. */
		    		}, true);
				}
			});
		}

		/**
		 * 참여현황팝업
		 * @param {String}  upSrvyId 	- 상위설문아이디
		 * @param {String}  srvyId 		- 설문아이디
		 * @param {String}  sbjctId 	- 과목아이디
		 */
		function ptcpChartPop() {
			var data = "upSrvyId=${vo.srvyId}&srvyId=${vo.subSrvyId}&sbjctId=${vo.sbjctId}";

			dialog = UiDialog("dialog1", {
				title: "참여현황",
				width: 800,
				height: 500,
				url: "/srvy/profSrvyPtcpStatusPopup.do?"+data,
				autoresize: true
			});
		}

		// 팝업 점수 저장
		function qstnScoreEdit() {
			srvyPtcpListSelect();
		}

		/**
		 * 설문 부 과제 목록 조회
		 * @param {String}  lrnGrpId 	- 학습그룹아이디
		 * @param {String}  srvyId 		- 설문아이디
		 * @returns {list} 부 과제 목록
		 */
		function srvySubAsmtListSelect() {
			var url  = "/srvy/srvyLrnGrpSubAsmtListAjax.do";
			var data = {
				lrnGrpId  	: "${vo.lrnGrpId}",
				srvyId 		: "${vo.srvyId}"
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					var returnList = data.returnList || [];
					var html = "";

				    if(returnList.length > 0) {
				    	returnList.forEach(function(v, i) {
							html += "<tr>";
							html += "	<th>" + v.teamnm + "</th>";
							html += "	<td>";
							html += "		<table class='table-type2'>";
							html += "			<colgroup>";
							html += "				<col class='width-10per' />";
							html += "				<col class='' />";
							html += "			</colgroup>";
							html += "			<tbody>";
							html += "				<tr>";
							html += "					<th>주제</th>";
							html += "					<td class='t_left'>" + UiComm.escapeHtml(v.srvyTtl) + "</td>";
							html += "				</tr>";
							html += "				<tr>";
							html += "					<th>내용</th>";
							html += "					<td class='t_left'><pre>" + v.srvyCts + "</pre></td>";
							html += "				</tr>";
							html += "			</tbody>";
							html += "		</table>";
							html += "	</td>";
							html += "	<td>" + v.leadernm + " 외 " + (v.teamMbrCnt - 1) + "</td>";
							html += "</tr>";
				    	});
				    }

				    $("#srvySubAsmtTbody").append(html);
				}
			}, true);
		}

		// 수강생 전체 버튼
		function resetListSelect() {
			$("#ptcpyn").val('').trigger('chosen:updated');
			$("#srvyPtcpEvlyn").val('').trigger("chosen:updated");
			$("#searchValue").val("");
			srvyPtcpListSelect();
		}

		// EZ-Grader 팝업
		function ezGraderPopup() {
			var data = "srvyId=${vo.srvyId}&sbjctId=${vo.sbjctId}";

			dialog = UiDialog("dialog1", {
				title: "EZ-Grader",
				width: 1000,
				height: 600,
				url: "/srvy/ezgrader/srvyEzGraderPopup.do?"+data,
				autoresize: true
			});
		}
	</script>
</head>

<body class="class colorA">
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
                                <spring:message code="resh.label.resh" /><!-- 설문 -->
                            </h2>
				        </div>
				        <div class="board_top">
					        <div class="right-area">
					        	<a href="javascript:srvyViewMv(4)" class="btn type2"><spring:message code="exam.button.mod" /></a><!-- 수정 -->
								<a href="javascript:srvyDelete()" class="btn type2"><spring:message code="exam.button.del" /></a><!-- 삭제 -->
								<a href="javascript:srvyViewMv(9)" class="btn type2"><spring:message code="exam.button.list" /></a><!-- 목록 -->
					        </div>
				        </div>

				        <div class="listTab">
					        <ul>
					            <li class="select mw120"><a onclick="srvyViewMv(2)">설문정보 및 평가</a></li>
					            <li class="mw120"><a onclick="srvyViewMv(1)">문항관리</a></li>
					        </ul>
					    </div>

					    <div class="accordion">
							<div class="title flex">
								<div class="title_cont">
									<div class="left_cont">
										<div class="lectTit_box">
											<spring:message code="exam.common.yes" var="yes" /><!-- 예 -->
											<spring:message code="exam.common.no" var="no" /><!-- 아니오 -->
											<p class="lect_name">${fn:escapeXml(vo.srvyTtl) }</p>
											<span class="fcGrey">
												<small>설문 기간 : <uiex:formatDate type="datetime" value="${vo.srvySdttm }"/> ~ <uiex:formatDate type="datetime" value="${vo.srvyEdttm }"/></small> |
												<small><spring:message code="exam.label.score.aply.y" /><!-- 성적반영 --> : ${vo.mrkRfltyn eq 'Y' ? yes : no }</small> |
												<small><spring:message code="exam.label.score.open.y" /><!-- 성적공개 --> : ${vo.mrkOyn eq 'Y' ? yes : no }</small>
											</span>
										</div>
									</div>
								</div>
								<i class="dropdown icon ml20"></i>
							</div>
							<div class="content" style="padding:0;">
								<!--table-type-->
				        		<div class="table-wrap">
				        			<table class="table-type2">
				        				<colgroup>
				        					<col class="width-20per" />
				        					<col class="" />
				        				</colgroup>
				        				<tbody>
				        					<tr>
				        						<th><label>설문내용</label></th>
				        						<td class="t_left" colspan="3"><pre>${vo.srvyCts }</pre></td>
				        					</tr>
				        					<tr>
				        						<th><label>응시기간</label></th>
				        						<td class="t_left" colspan="3"><uiex:formatDate type="datetime" value="${vo.srvySdttm }"/> ~ <uiex:formatDate type="datetime" value="${vo.srvyEdttm }"/></td>
				        					</tr>
				        					<tr>
				        						<th><label>성적반영</label></th>
				        						<td class="t_left">${vo.mrkRfltyn eq 'Y' ? yes : no }</td>
				        						<th><label>성적 반영비율</label></th>
				        						<td class="t_left">${vo.mrkRfltyn eq 'Y' ? vo.mrkRfltrt : '0' }%</td>
				        					</tr>
				        					<tr>
				        						<th><label>성적공개</label></th>
				        						<td class="t_left" colspan="3">${vo.mrkOyn eq 'Y' ? yes : no }</td>
				        					</tr>
				        					<tr>
				        						<th><label>평가방법</label></th>
				        						<td class="t_left" colspan="3">
				        							<c:choose>
														<c:when test="${vo.evlScrTycd eq 'SCR' }">
															점수형
														</c:when>
														<c:otherwise>
															참여형 <span class="fcBlue">( 설문 참여 : 100점, 미참여 : 0점 자동배점 )</span>
														</c:otherwise>
													</c:choose>
				        						</td>
				        					</tr>
				        					<tr>
				        						<th><label>설문결과 조회가능</label></th>
				        						<td class="t_left" colspan="3">${vo.rsltOpenTycd eq 'WHOL_OPEN' ? yes : no }</td>
				        					</tr>
				        					<tr>
				        						<th><label>팀 설문</label></th>
				        						<td class="t_left" colspan="3">
				        							<c:choose>
														<c:when test="${vo.examGbn eq 'SRVY_TEAM' }">

															<p>학습그룹 : ${vo.lrnGrpnm }</p>
															<p>학습그룹별 부 과제 설정 : ${vo.byteamSubsrvyUseyn eq 'Y' ? '사용' : '미사용' }</p>
															<c:if test="${vo.byteamSubsrvyUseyn eq 'Y' }">
																<table class="table-type2">
											        				<colgroup>
											        					<col class="width-10per" />
											        					<col class="" />
											        					<col class="width-20per" />
											        				</colgroup>
											        				<tbody id="srvySubAsmtTbody">
											        					<tr>
											        						<th><label>팀</label></th>
											        						<th><label>부주제</label></th>
											        						<th><label>학습그룹 구성원</label></th>
											        					</tr>
											        				</tbody>
											        			</table>
															</c:if>
														</c:when>
														<c:otherwise>${no }</c:otherwise>
													</c:choose>
				        						</td>
				        					</tr>
				        				</tbody>
				        			</table>
				        		</div>
							</div>
						</div>

						<div class="board_top margin-top-4 padding-2 bcLgrey4">
							<h4>설문평가</h4>
							<div class="right-area">
								<a href="javascript:ezGraderPopup()" class="btn basic small">EZ-Grader</a>
								<a href="javascript:excelScrRegistPopup()" class="btn basic small"><spring:message code="exam.button.reg.excel.score" /></a><!-- 엑셀 성적등록 -->
								<a href="javascript:sendMsg()" class="btn basic small">보내기</a>
							</div>
						</div>
						<div class="search-typeA margin-bottom-4">
                            <div class="text-center">
                                <select class="form-select" id="ptcpyn" onchange="srvyPtcpListSelect()">
                                    <option value="">참여여부</option>
									<option value="all"><spring:message code="exam.common.search.all" /><!-- 전체 --></option>
									<option value="N">미참여</option>
									<option value="Y">참여완료</option>
                                </select>
                                <select class="form-select" id="srvyPtcpEvlyn" onchange="srvyPtcpListSelect()">
                                    <option value="">평가여부</option>
									<option value="all"><spring:message code="exam.common.search.all" /><!-- 전체 --></option>
									<option value="Y">평가</option>
									<option value="N">미평가</option>
                                </select>
                                <input class="form-control" type="text" id="searchValue" value="" placeholder="<spring:message code="message.search.input.dept.user.user.nm" />"><!-- 학과/학번/성명 입력 -->
	                            <button type="button" class="btn type1" onclick="srvyPtcpListSelect()">검색</button>
	                            <button type="button" class="btn type1" onclick="resetListSelect()">수강생 전체</button>
                            </div>
                        </div>
                        <div></div>
                        <table class="table-type5 border-1">
                        	<colgroup>
                        		<col class="width-20per" />
                        		<col class="" />
                        	</colgroup>
                        	<tbody>
                        		<tr>
                        			<th class="bcLgrey">일괄 성적처리</th>
                        			<td>
                        				<form id="scoreForm" onsubmit="return false;">
	                        				<div class="form-inline">
												<span class="custom-input">
													<input type="radio" name="scoreType" id="scoreBatch" onchange="plusMinusIconControl(this.value)" value="batch" required="true" />
													<label for="scoreBatch">점수 등록</label>
												</span>
												<span class="custom-input">
													<input type="radio" name="scoreType" id="scoreAddition" onchange="plusMinusIconControl(this.value)" value="addition" required="true" />
													<label for="scoreAddition">점수 가감</label>
												</span>
												점수
												<button class='btn small basic icon' id="scr-toggle-icon"><i class='xi-plus'></i></button>
												<input type="text" id="scoreValue" class="w100" inputmask="numeric" mask="999.99" maxVal="100" required="true" />
												점
												<a href="javascript:EvlScrBulkModify()" class="btn type7">저장</a>
	                        				</div>
                        				</form>
                        			</td>
                        		</tr>
                        	</tbody>
                        </table>
                        <div class="board_top margin-top-4">
							<div class="right-area">
								<a href="javascript:srvyRspnsExcelDown()" class="btn type1">제출설문 엑셀다운로드</a>
								<a href="javascript:srvyPtcpStatusExcelDown()" class="btn type1">설문결과 엑셀다운로드</a>
								<a href="javascript:srvyPtcpListExcelDown()" class="btn type1">엑셀 다운로드</a>
								<a href="javascript:ptcpChartPop()" class="btn type1">참여현황 그래프</a>
							</div>
						</div>

						<div id="list"></div>

						<script>
							let userListTable = UiTable("list", {
								lang: "ko",
								selectRow: "checkbox",
								columns: [
									{title:"No", 		field:"no",					headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},
									("${vo.srvyGbn}" == "SRVY_TEAM" ? {title: "팀명", field: "teamnm", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 80} : null),
									{title:"학과", 		field:"deptnm",				headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:100},
									{title:"대표아이디", 	field:"userRprsId", 		headerHozAlign:"center", hozAlign:"center", width:0, 	minWidth:100},
									{title:"학번", 		field:"stdntNo", 			headerHozAlign:"center", hozAlign:"center", width:0,	minWidth:100},
									{title:"이름", 		field:"usernm", 			headerHozAlign:"center", hozAlign:"center", width:0,	minWidth:100},
									("${vo.srvyGbn}" == "SRVY_TEAM" ? {title: "역할", field: "ldryn", headerHozAlign: "center", hozAlign: "center", width: 0, minWidth: 80} : null),
									{title:"평가점수", 	field:"ptcpEvlScr", 		headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},
									{title:"참여상태", 	field:"ptcpGbnnm", 			headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},
									{title:"참여일시", 	field:"ptcpDttm", 			headerHozAlign:"center", hozAlign:"center",	width:150,	minWidth:150},
									{title:"평가여부", 	field:"srvyPtcpEvlyn",		headerHozAlign:"center", hozAlign:"center",	width:80,	minWidth:80},
									{title:"관리", 		field:"mng", 				headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:200},
								].filter(function(col) {return col !== null;})
							});
						</script>
					</div>
				</div>
			</div>
			<!-- //content -->
        </main>
        <!-- //classroom-->
    </div>
</body>
</html>