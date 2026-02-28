<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/quiz/common/quiz_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="module" value="editor"/>
		<jsp:param name="module" value="fileuploader"/>
	</jsp:include>

	<script type="text/javascript">
		var dialog;
		const editors = {};	// 에디터 목록 저장용

		$(window).on('load', function() {
			// 부과제 조회
			$("input[name='lrnGrpSubasmtStngyns']:checked").each(function(i, e) {
				var lrnGrpId = $("#lrnGrpId" + e.id.split("_")[1]).val().split(":")[0];	// 학습그룹아이디
				var lrnGrpnm = $("#lrnGrpnm" + e.id.split("_")[1]).val();				// 학습그룹명
				var dvclasNo = e.id.split("_")[1];										// 분반 순서
				var sbjctId = e.value.split(":")[1];									// 과목아이디

				selectTeam(lrnGrpId, lrnGrpnm, dvclasNo+":"+sbjctId);
			});

			dvclasChcChange($("#allDeclas")[0]);
		});

	 	// 이전 퀴즈 가져오기 팝업
		function bfrQuizCopyPopup() {
			dialog = UiDialog("dialog1", {
				title: "이전퀴즈 가져오기",
				width: 800,
				height: 450,
				url: "/quiz/profBfrQuizCopyPopup.do",
				autoresize: true
			});
		}

	 	/**
		 * 퀴즈 복사
		 * @param {String}  examBscId 	- 시험기본아이디
		 * @returns {vo} 퀴즈 정보
		 */
	 	function quizCopy(examBscId) {
	 		var url  = "/quiz/quizSelectAjax.do";
			var data = {
				"examBscId" : examBscId
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		var quiz = data.returnVO;
	        		$("#searchTo").val(quiz.examBscId);

	        		/* var fileUploader = dx5.get("fileUploader");
	        		fileUploader.clearItems(); */

	        		// 가져온 파일 리스트
	        		/* if (quiz.fileList != null && quiz.fileList.length > 0) {
	        			var oldFiles = [];
	        			var fileSns = new Set();

	        			quiz.fileList.forEach(function(v, i) {
	        				oldFiles.push({vindex:v.fileId, name:v.fileNm, size:v.fileSize, saveNm:v.fileSaveNm});
				        	fileSns.add(v.fileSn);
		        		});

	        			fileUploader.addOldFileList(oldFiles);
	        			fileUploader.showResetBtn();
		        		$("#fileSns").val(Array.from(fileSns));
	        		} */

	        		$("#uploadPath").val("/quiz/${vo.examBscId}");

	        		// 퀴즈명
	        		$("#examTtl").val(quiz.examTtl);
	        		// 퀴즈 내용
	        		$("button.se-clickable[name=new]").trigger("click");
	        		editors['editor'].insertHTML($.trim(quiz.examCts) == "" ? " " : quiz.examCts);
	        		// 퀴즈 시간
	        		$("#examMnts").val(quiz.examDtlVO.examMnts);
	        		// 성적 반영 여부
	        		var mrkRfltId = quiz.mrkRfltyn == "Y" ? "mrkRfltynY" : "mrkRfltynN";
	        		$("#"+mrkRfltId).trigger("click");
	        		// 문제 표시 방식
	        		var qstnDsplyId = quiz.qstnDsplyGbncd == "WHOL" ? "wholViewQstn" : "eachViewQstn";
	        		$("#"+qstnDsplyId).trigger("click");
	        		// 문제 섞기
	        		$("#qstnRndmynChk").prop("checked", quiz.qstnRndmyn == "Y");
	        		// 보기 섞기
	        		$("#qstnVwitmRndmynChk").prop("checked", quiz.qstnVwitmRndmyn == "Y");
	        		// 문항후보사용여부
	        		$("#qstnCnddtUseynChk").prop("checked", quiz.qstnCnddtUseyn == "Y");
	        		dialog.close();
	            } else {
	            	UiComm.showMessage(data.message, "error");
	            }
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='exam.error.copy' />", "error");/* 가져오기 중 에러가 발생하였습니다. */
			});
	 	}

	 	// 저장 확인
	    function saveConfirm() {
	 		/* var fileUploader = dx5.get("fileUploader");
	    	// 파일이 있으면 업로드 시작
	 		if (fileUploader.getFileCount() > 0) {
				fileUploader.startUpload();
			}
			else {
				// 저장 호출
				save();
			} */

	    	save();
	    }

	 	// 파일 업로드 완료
	    function finishUpload() {
	    	var fileUploader = dx5.get("fileUploader");
	    	var url = "/file/fileHome/saveFileInfo.do";
	    	var data = {
	    		"uploadFiles" : fileUploader.getUploadFiles(),
	    		"copyFiles"   : fileUploader.getCopyFiles(),
	    		"uploadPath"  : fileUploader.getUploadPath()
	    	};

	    	ajaxCall(url, data, function(data) {
	    		if(data.result > 0) {
	    			save();
	    		} else {
	    			UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");	// 업로드를 실패하였습니다.
	    		}
	    	}, function(xhr, status, error) {
	    		UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");	// 업로드를 실패하였습니다.
	    	});
	    }

	    // 퀴즈 등록, 수정
	    function save() {
	    	let validator = UiValidator("writeQuizForm");
			validator.then(function(result) {
				if (result) {
					if(!isNull()) {
						return false;
					}

					setValue();
					UiComm.showLoading(true);

					/* var fileUploader = dx5.get("fileUploader");
					$("#uploadFiles").val(fileUploader.getUploadFiles());
					$("#copyFiles").val(fileUploader.getCopyFiles());
					$("#delFileIdStr").val(fileUploader.getDelFileIdStr()); */
					$("#uploadPath").val("/quiz/${vo.examBscId}");

					var url = "/quiz/quizRegistAjax.do";
					if(${not empty vo.examBscId}) {
						url = "/quiz/quizModifyAjax.do";
					}
					$.ajax({
					    url 	 : url,
					    async	 : false,
					    type 	 : "POST",
					    dataType : "json",
					    data 	 : $("#writeQuizForm").serialize(),
					}).done(function(data) {
						UiComm.showLoading(false);
						if (data.result > 0) {
							if(${empty vo.examBscId} || ${vo.examQstnsCmptnyn ne 'Y'}) {
								UiComm.showMessage("<spring:message code='exam.alert.already.quiz.qstn.submit' />", "info")	/* 퀴즈 문제관리에서 문제를 출제 해 주세요. */
								.then(function(result) {
									// 메시지 닫은후 실행
									quizViewMv("qstn", data.returnVO.examBscId);
								});
							} else {
								quizViewMv("list", '');
							}
					    } else {
					     	alert(data.message);
					    }
					}).fail(function() {
						UiComm.showLoading(false);
						if(${empty vo.examBscId}) {
							UiComm.showMessage("<spring:message code='exam.error.insert' />", "error");	/* 저장 중 에러가 발생하였습니다. */
						} else {
							UiComm.showMessage("<spring:message code='exam.error.update' />", "error");	/* 수정 중 에러가 발생하였습니다. */
						}
					});
				}
			});
	    }

	    // 빈 값 체크
	    function isNull() {
			// 재응시 사용시
			if($("#reexamynY").is(":checked")) {
				if($("#redateSt").val() == "") {
					UiComm.showMessage("<spring:message code='exam.alert.input.reexam.start.dttm' />", "warning");	/* 재응시 시작일자를 입력하세요. */
					return false;
				}
				if($("#retimeSt").val() == " ") {
					UiComm.showMessage("<spring:message code='exam.alert.input.reexam.start.dttm.hour' />", "warning");	/* 재응시 시작시간을 입력하세요. */
					return false;
				}
				if($("#redateEd").val() == "") {
					UiComm.showMessage("<spring:message code='exam.alert.input.reexam.end.dttm' />", "warning");	/* 재응시 종료일자를 입력하세요. */
					return false;
				}
				if($("#retimeEd").val() == " ") {
					UiComm.showMessage("<spring:message code='exam.alert.input.reexam.end.dttm.hour' />", "warning");	/* 재응시 종료시간을 입력하세요. */
					return false;
				}
				if($("#reexamMrkRfltrt").val() == "") {
					UiComm.showMessage("<spring:message code='exam.alert.input.reexam.aply.ratio' />", "warning");	/* 재응시 적용률을 입력하세요. */
				return false;
				}
			}

			// 팀 퀴즈 학습그룹별 부 과제 설정시
			if($("#quizTeamynY").is(":checked")) {
				$("input[name='lrnGrpSubasmtStngyns']:checked").each(function(i, e) {
					$("#subInfoDiv"+e.id.split("_")[1]+" tr.subQuizTr").each(function(index, element) {
					var ttl = $(element).find("input[name='subExamTtl']");
					if($.trim($(ttl).val()) == "") {
						UiComm.showMessage("<spring:message code='exam.alert.input.title' />", "warning");	/* 제목을 입력하세요. */
						return false;
					}

					var teamId = ttl[0].id.split("_")[0];
					if(editors[teamId+'_editor'+index].isEmpty() || editors[teamId+'_editor'+index].getTextContent().trim() === "") {
						UiComm.showMessage("<spring:message code='exam.alert.input.contents' />", "warning");	/* 내용을 입력하세요. */
			 			return false;
			 		}
					});
				});
			}

			return true;
	    }

	    // 값 채우기
	    function setValue() {
	    	// 퀴즈 내용
	    	var examContents = editors['editor'].getPublishingHtml();
			$("#examCts").val(examContents);

			// 퀴즈 시작일시
			$("#examPsblSdttm").val(UiComm.getDateTimeVal("dateSt", "timeSt") + "00");

			// 퀴즈 종료일시
			$("#examPsblEdttm").val(UiComm.getDateTimeVal("dateEd", "timeEd") + "59");

			// 문제 섞기
			$("#qstnRndmyn").val($("#qstnRndmynChk").is(":checked") ? "Y" : "N");

			// 보기 섞기
			$("#qstnVwitmRndmyn").val($("#qstnVwitmRndmynChk").is(":checked") ? "Y" : "N");

			// 문항후보사용여부
			$("#qstnCnddtUseyn").val($("#qstnCnddtUseynChk").is(":checked") ? "Y" : "N");

			// 분반 체크 여부
			$("#dvclasRegyn").val($("input:checkbox[name=sbjctIds]:checked").length > 1 ? "Y" : "N");

			// 재응시 여부
			if($("#reexamynY").is(":checked")) {
				// 재응시 시작일시
				$("#reexamPsblSdttm").val(UiComm.getDateTimeVal("redateSt", "retimeSt") + "00");

				// 재응시 종료일시
				$("#reexamPsblEdttm").val(UiComm.getDateTimeVal("redateEd", "retimeEd") + "59");
			}

			// 퀴즈구분코드
			$("#examGbncd").val($("#quizTeamynY").is(":checked") ? "QUIZ_TEAM" : "QUIZ");

			// 팀 퀴즈 학습그룹별 부 과제 설정시
	    	if($("#quizTeamynY").is(":checked")) {
				const dtlInfos = [];
	    		$("input[name='lrnGrpSubasmtStngyns']:checked").each(function(i, e) {
	    			$("#subInfoDiv"+e.id.split("_")[1]+" tr.subQuizTr").each(function(index, element) {
						var ttl = $(element).find("input[name='subExamTtl']");
						var teamId = ttl[0].id.split("_")[0];

						const map = {
							id: teamId,
							ttl: $.trim($(ttl).val()),
							cts: editors[teamId+'_editor'+index].getPublishingHtml()
						};
						dtlInfos.push(map);
	    			});
	    		});
	    		$("#dtlInfos").val(JSON.stringify(dtlInfos));
	    	}
	    }

		/**
		 * 퀴즈 화면 이동
		 * @param {String}  examBscId 	- 시험기본아이디
		 * @param {String}  sbjctId 	- 과목아이디
		 */
		function quizViewMv(type, examBscId) {
			var urlMap = {
				"qstn" : "/quiz/profQuizQstnMngView.do",	// 퀴즈 문항 관리 화면
				"list" : "/quiz/profQuizListView.do"		// 퀴즈 목록 화면
			}
			var kvArr = [];
			kvArr.push({'key' : 'examBscId',   	'val' : examBscId});
			kvArr.push({'key' : 'sbjctId', 		'val' : "${sbjctId}"});

			submitForm(urlMap[type], "", "", kvArr);
		}

		/**
		 * 분반 선택 변경
		 * @param {obj}  obj - 선택한 분반 체크박스
		 */
		function dvclasChcChange(obj) {
			if(obj.value == "all") {
				$("input[name=sbjctIds]").not(".readonly").prop("checked", obj.checked);

				if(obj.checked) {
					$("div[id^='lrnGrpView']").css("display", "flex");
					$("input[name='lrnGrpSubasmtStngyns']:checked").each(function(i, e) {
						$("#setQuizDiv"+e.id.split("_")[1]).show();
					});
				} else {
					var fixDvclas = $("input[name=sbjctIds]").filter(".readonly")[0].id.split("_")[1];
					$("div[id^='lrnGrpView']").not("#lrnGrpView"+fixDvclas).hide();
					$("div[id^='setQuizDiv']").not("#setQuizDiv"+fixDvclas).hide();
				}
			} else {
				$("#allDeclas").prop("checked", $("input[name=sbjctIds]").length == $("input[name=sbjctIds]:checked").length);

				if(obj.checked) {
					$("#lrnGrpView" + obj.id.split("_")[1]).css("display", "flex");
					$("#setQuizDiv"+obj.id.split("_")[1]).show();
				} else {
					$("#lrnGrpView" + obj.id.split("_")[1]).hide();
					$("#setQuizDiv"+obj.id.split("_")[1]).hide();
				}
			}
		}

		/**
		 * 팀 퀴즈 여부 변경
		 * @param {String}  value - 팀 퀴즈 여부
		 */
		function teamynChange(value) {
			if(value == "Y") {
				$("#teamQuizDiv").show();
			} else {
				$("#teamQuizDiv").hide();
			}
		}

		/**
		 * 학습그룹지정 팝업
		 * @param {Integer} i 		- 분반 순서
		 * @param {String}  sbjctId - 과목아이디
		 */
	    function teamGrpChcPopup(i, sbjctId) {
			dialog = UiDialog("dialog1", {
				title: "학습그룹지정",
				width: 600,
				height: 500,
				url: "/team/teamHome/teamCtgrSelectPop.do?sbjctId="+sbjctId+"&searchFrom="+i + ":" + sbjctId,
				autoresize: true
			});
		}

	    /**
		 * 학습그룹 선택
		 * @param {String}  lrnGrpId 	- 학습그룹아이디
		 * @param {String}  lrnGrpnm 	- 학습그룹명
		 * @param {String}  id 			- 분반 순서:과목개설아이디
		 * @returns {list} 팀 목록
		 */
	    function selectTeam(lrnGrpId, lrnGrpnm, id) {
	    	var idList = id.split(':');
	    	$("#lrnGrpId" + idList[0]).val(lrnGrpId + ":" + idList[1]);
	    	$("#lrnGrpnm" + idList[0]).val(lrnGrpnm);
	    	$("#setQuizDiv" + idList[0]).show();

	    	var url  = "/quiz/quizLrnGrpSubAsmtListAjax.do";
			var data = {
				lrnGrpId  : lrnGrpId,
				examBscId : $("#lrnGrpSubasmtStngyn_" + idList[0]).data("bscid")
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					var returnList = data.returnList || [];
					var html = "";

	        		if(returnList.length > 0) {
						html += "<table class='table-type5'>";
						html += "	<colgroup>";
						html += "		<col class='width-10per' />";
						html += "		<col class='' />";
						html += "		<col class='width-10per' />";
						html += "	</colgroup>";
						html += "	<tbody>";
						html += "		<tr>";
						html += "			<th>팀</th>";
						html += "			<th>부 과제</th>";
						html += "			<th>학습그룹 구성원</th>";
						html += "		</tr>";
	        			returnList.forEach(function(v, i) {
							html += "	<tr class='subQuizTr'>";
							html += "		<th><label>" + v.teamnm + "</label></th>";
							html += "		<td>";
							html += "			<table class='table-type5'>";
							html += "				<colgroup>";
							html += "					<col class='width-10per' />";
							html += "					<col class='' />";
							html += "				</colgroup>";
							html += "				<tbody>";
							html += "					<tr>";
							html += "						<th><label for='" + v.teamId + "_dtlExamTtl_" + i + "' class='req'>주제</label></th>";
							html += "						<td><input type='text' id='" + v.teamId + "_dtlExamTtl_" + i + "' name='subExamTtl' value='" + (v.examTtl == null ? '' : v.examTtl) + "' inputmask='byte' maxLen='200' class='width-100per' /></td>";
							html += "					</tr>";
							html += "					<tr>";
							html += "						<th><label for='" + v.teamId + "_contentTextArea_" + i + "' class='req'>내용</label></th>";
							html += "						<td>";
							html += "							<div class='editor-box'>";
							html += "								<textarea name='" + v.teamId + "_contentTextArea_" + i + "' id='" + v.teamId + "_contentTextArea_" + i + "'>" + (v.examCts == null ? '' : v.examCts) + "</textarea>";
							html += "							</div>";
							html += "						</td>";
							html += "					</tr>";
							html += "					<tr>";
							html += "						<th><label for='attchFile1'>첨부파일</label></th>";
							html += "						<td></td>";
//							html += "							<div id='"+v.teamId+"_upload"+i+"-container' class='dext5-container' style='width:100%;height:180px'></div>";
//							html += "							<div id='"+v.teamId+"_upload"+i+"-btn-area' class='dext5-btn-area'><button type='button' id='"+v.teamId+"_upload"+i+"_btn-add'><spring:message code='button.select.file'/></button>";
//							html += "							<button type='button' id='"+v.teamId+"_upload"+i+"_btn-filebox'><spring:message code='button.from_filebox'/></button>";
//							html += "							<button type='button' id='"+v.teamId+"_upload"+i+"_btn-delete'><spring:message code='button.delete'/></button></div>";
							html += "					</tr>";
							html += "					</tr>";
							html += "				</tbody>";
							html += "			</table>";
							html += "		</td>";
							html += "		<th>" + v.leadernm + " 외 " + (v.teamMbrCnt - 1) + "</th>";
							html += "	</tr>";
	        			});
						html += "	</tbody>";
						html += "</table>";
	        		}

	        		$("#subInfoDiv" + idList[0]).empty().html(html);
	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
	        				// html 에디터 생성
							editors[v.teamId+'_editor'+i] = UiEditor({
																targetId: v.teamId+'_contentTextArea_'+i,
																uploadPath: "/quiz",
																height: "500px"
															});

	        				// 첨부파일
							<%-- DextUploader({
								id:v.teamId+"_upload"+i,
								parentId:v.teamId+"_upload"+i+"-container",
								btnFile:v.teamId+"_upload"+i+"_btn-add",
								btnDelete:v.teamId+"_upload"+i+"_btn-delete",
								lang:"<%=LocaleUtil.getLocale(request)%>",
								uploadMode:"ORAF",
								fileCount:5,
								maxTotalSize:1024,
								maxFileSize:1024,
								extensionFilter:"*",
								finishFunc:"finishUpload()",
								uploadUrl:"<%=CommConst.PRODUCT_DOMAIN + CommConst.DEXT_FILE_UPLOAD%>",
								path:"/quiz",
								useFileBox:true
							}); --%>
	        			});
	        		}
	            } else {
	            	UiComm.showMessage(data.message, "error");
	            }
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='exam.error.copy' />", "error");	/* 가져오기 중 에러가 발생하였습니다. */
			});
	    }

	    /**
		 * 학습그룹 설정여부 변경
		 * @param {obj}  obj - 분반 학습그룹 과제 설정 체크박스
		 */
	    function lrnGrpSubasmtStngynChange(obj) {
	    	if(obj.checked) {
				$("#subInfoDiv" + obj.id.split("_")[1]).show();
			} else {
				$("#subInfoDiv" + obj.id.split("_")[1]).hide();
			}
	    }

		/**
		 * 재응시 사용여부 변경
		 * @param {String}  value - 재응시 사용여부
		 */
		function reexamynChange(value) {
			if(value == "Y") {
				$("#reexamDiv").show();
			} else {
				$("#reexamDiv").hide();
			}
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
                                <spring:message code="exam.label.quiz" /><!-- 퀴즈 -->
                            </h2>
				        </div>
				        <spring:message code="exam.button.save" var="save" /><!-- 저장 -->
				        <spring:message code="exam.button.mod"  var="modify" /><!-- 수정 -->
				        <div class="board_top">
					        <div class="right-area">
					        	<a href="javascript:saveConfirm()" class="btn type2">${empty vo.examBscId ? save : modify }</a>
					            <a href="javascript:bfrQuizCopyPopup()" class="btn type2"><spring:message code="exam.label.prev" /> <spring:message code="exam.label.quiz" /> <spring:message code="exam.label.copy" /></a><!-- 이전 --><!-- 퀴즈 --><!-- 가져오기 -->
					            <a href="javascript:quizViewMv('list', '')" class="btn type2"><spring:message code="exam.button.list" /></a><!-- 목록 -->
					        </div>
				        </div>
				        <!--table-type-->
				        <div class="table-wrap">
							<form name="writeQuizForm" id="writeQuizForm" method="POST" autocomplete="off">
						    	<input type="hidden" name="examBscId" 					value="${vo.examBscId }" />
						        <input type="hidden" name="sbjctId" 					value="${sbjctId }" />
						        <input type="hidden" name="examGrpId" 					value="${vo.examGrpId }" />
						        <input type="hidden" name="examDtlVO.examDtlId" 		value="${vo.examDtlVO.examDtlId }" />
						        <input type="hidden" name="mrkRfltrt" 					value="0" />
						        <input type="hidden" name="examDtlVO.cnsdrAddMnts" 		value="0" />
						        <input type="hidden" name="maxTkexamCnt" 				value="99" />
						        <input type="hidden" name="avgMrkOyn" 					value="N" />
						        <input type="hidden" name="examTycd"					value="QUIZ" />
						        <input type="hidden" name="examDtlVO.examtmLmtyn"		value="Y" />
						        <input type="hidden" name="examGbncd"					value=""									id="examGbncd" />
						        <input type="hidden" name="examDtlVO.examPsblSdttm" 	value="${vo.examDtlVO.examPsblSdttm }" 		id="examPsblSdttm" />
						        <input type="hidden" name="examDtlVO.examPsblEdttm" 	value="${vo.examDtlVO.examPsblEdttm }"  	id="examPsblEdttm" />
						        <input type="hidden" name="qstnRndmyn" 					value="${vo.qstnRndmyn }"   				id="qstnRndmyn" />
						        <input type="hidden" name="qstnVwitmRndmyn" 			value="${vo.qstnVwitmRndmyn }"   			id="qstnVwitmRndmyn" />
						        <input type="hidden" name="qstnCnddtUseyn" 				value="${vo.qstnCnddtUseyn }"   			id="qstnCnddtUseyn" />
						        <input type="hidden" name="examDtlVO.reexamPsblSdttm" 	value="${vo.examDtlVO.reexamPsblSdttm }" 	id="reexamPsblSdttm" />
						        <input type="hidden" name="examDtlVO.reexamPsblEdttm" 	value="${vo.examDtlVO.reexamPsblEdttm }"   	id="reexamPsblEdttm" />
						        <input type="hidden" name="dvclasRegyn" 				value="${vo.dvclasRegyn }"	   				id="dvclasRegyn" />
						        <input type="hidden" name="imdtAnswShtInqyn"			value=""					   				id="imdtAnswShtInqyn" />
						        <input type="hidden" name="examCts" 					value=""					   				id="examCts"/>
						        <input type="hidden" name="uploadFiles"					value=""					   				id="uploadFiles" />
						        <input type="hidden" name="copyFiles"					value=""					   				id="copyFiles" />
						        <input type="hidden" name="delFileIdStr"				value=""					   				id="delFileIdStr" />
						        <input type="hidden" name="uploadPath"					value=""					   				id="uploadPath" />
						        <input type="hidden" name="searchTo"					value=""					   				id="searchTo" />
						        <input type="hidden" name="fileSns"						value=""					   				id="fileSns" />
						        <input type="hidden" name="dtlInfos"					value=""					   				id="dtlInfos" />
						        <table class="table-type5">
						        	<colgroup>
						        		<col class="width-20per" />
						        		<col class="" />
						        	</colgroup>
						        	<tbody>
						        		<tr>
						        			<th><label for="examTtl" class="req">퀴즈명</label></th>
						        			<td>
						        				<input type="text" name="examTtl" id="examTtl" inputmask="byte" maxLen="200" class="width-100per" required="true" value="${vo.examTtl }">
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label for="contentTextArea" class="req">퀴즈 내용</label></th>
						        			<td>
						        				<div class="editor-box">
													<textarea id="contentTextArea" name="contentTextArea" required="true"><c:out value="${vo.examCts}" /></textarea>
													<script>
														// HTML 에디터
														editors['editor'] = UiEditor({
																				targetId: "contentTextArea",
																				uploadPath: "/quiz",
																				height: "400px"
																			});
													</script>
												</div>
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label for="contLabel" class="req">분반 일괄 등록</label></th>
						        			<td>
						        				<div class="checkbox_type">
						        					<span class="custom-input">
														<input type="checkbox" name="allDeclasNo" value="all" id="allDeclas" onchange="dvclasChcChange(this)">
														<label for="allDeclas">전체</label>
													</span>
													<c:forEach var="list" items="${dvclasList }">
												        <c:set var="sbjctChk" value="N" />
												        <c:forEach var="item" items="${sbjctList }">
												        	<c:if test="${item.sbjctId eq list.sbjctId }">
												        		<c:set var="sbjctChk" value="Y" />
												        	</c:if>
												        </c:forEach>
												        <span class="custom-input">
															<input type="checkbox" ${list.sbjctId eq sbjctId || sbjctChk eq 'Y' ? 'class="readonly" checked readonly' : '' } name="sbjctIds" id="declas_${list.dvclasNo }" value="${list.sbjctId }" onchange="dvclasChcChange(this)">
															<label for="declas_${list.dvclasNo }">${list.dvclasNo }반</label>
														</span>
											        </c:forEach>
						        				</div>
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label for="dateSt" class="req">응시기간</label></th>
						        			<td>
						        				<input id="dateSt" type="text" name="dateSt" class="datepicker" timeId="timeSt" toDate="dateEd" value="${fn:substring(vo.examDtlVO.examPsblSdttm,0,8)}" required="true">
												<input id="timeSt" type="text" name="timeSt" class="timepicker" dateId="dateSt" value="${fn:substring(vo.examDtlVO.examPsblSdttm,8,12)}" required="true">
												<span class="txt-sort">~</span>
												<input id="dateEd" type="text" name="dateEd" class="datepicker" timeId="timeEd" fromDate="dateSt" value="${fn:substring(vo.examDtlVO.examPsblEdttm,0,8)}" required="true">
												<input id="timeEd" type="text" name="timeEd" class="timepicker" dateId="dateEd" value="${fn:substring(vo.examDtlVO.examPsblEdttm,8,12)}" required="true">
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label for="examStareTm" class="req">퀴즈시간</label></th>
						        			<td>
						        				<div class="form-row">
													<div class="input_btn">
														<input class="form-control md" name="examDtlVO.examMnts" id="examMnts" type="text" inputmask="numeric" value="${vo.examDtlVO.examMnts }" required="true"><label>분</label>
														<div class="form-inline">
															<small class="note2">! 퀴즈 시험지의 시간 표시는 남은 시간이 표시됩니다.</small>
														</div>
													</div>
												</div>
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label class="req">성적반영</label></th>
						        			<td>
						        				<span class="custom-input">
													<input type="radio" name="mrkRfltyn" id="mrkRfltynY" value="Y" ${vo.mrkRfltyn eq 'Y' || empty vo.examBscId ? 'checked' : '' }>
													<label for="mrkRfltynY">예</label>
												</span>
												<span class="custom-input ml5">
													<input type="radio" name="mrkRfltyn" id="mrkRfltynN" value="N" ${vo.mrkRfltyn eq 'N' ? 'checked' : '' }>
													<label for="mrkRfltynN">아니오</label>
												</span>
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label class="req">성적공개</label></th>
						        			<td>
						        				<span class="custom-input">
													<input type="radio" name="mrkOyn" id="mrkOynY" value="Y" ${vo.mrkOyn eq 'Y' || empty vo.examBscId ? 'checked' : '' }>
													<label for="mrkOynY">예</label>
												</span>
												<span class="custom-input ml5">
													<input type="radio" name="mrkOyn" id="mrkOynN" value="N" ${vo.mrkOyn eq 'N' ? 'checked' : '' }>
													<label for="mrkOynN">아니오</label>
												</span>
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label class="req">문제표시방식</label></th>
						        			<td>
						        				<span class="custom-input">
													<input type="radio" name="qstnDsplyGbncd" id="wholViewQstn" value="WHOL" ${vo.qstnDsplyGbncd eq 'WHOL' || empty vo.examBscId ? 'checked' : '' }>
													<label for="wholViewQstn">전체문제 표시</label>
												</span>
												<span class="custom-input ml5">
													<input type="radio" name="qstnDsplyGbncd" id="eachViewQstn" value="EACH" ${vo.qstnDsplyGbncd eq 'EACH' ? 'checked' : '' }>
													<label for="eachViewQstn">페이지별로 1문제씩 표시</label>
												</span>
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label for="teamLabel">문제 섞기</label></th>
						        			<td>
						        				<input type="checkbox" name="qstnRndmynChk" id="qstnRndmynChk" class="switch" ${vo.qstnRndmyn eq 'Y' ? 'checked' : '' }>
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label for="teamLabel">보기 섞기</label></th>
						        			<td>
						        				<input type="checkbox" name="qstnVwitmRndmynChk" id="qstnVwitmRndmynChk" class="switch" ${vo.qstnVwitmRndmyn eq 'Y' ? 'checked' : '' }>
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label for="teamLabel">문항후보사용여부</label></th>
						        			<td>
						        				<input type="checkbox" name="qstnCnddtUseynChk" id="qstnCnddtUseynChk" class="switch" ${vo.qstnCnddtUseyn eq 'Y' ? 'checked' : '' }>
						        			</td>
						        		</tr>
						        		<tr>
											<th><label for="attchFile">첨부파일</label></th>
											<td>
												<%-- <c:set var="path" value="" />
										        <c:choose>
										        	<c:when test="${empty vo.examBscId }">
										        	<c:set var="path" value="/quiz" />
										        	</c:when>
										        	<c:otherwise>
										        	<c:set var="path" value="/quiz/${vo.examBscId }" />
										        	</c:otherwise>
										        </c:choose>
										        <uiex:dextuploader
													id="fileUploader"
													path="${path}"
													limitCount="5"
													limitSize="1024"
													oneLimitSize="1024"
													listSize="3"
													fileList="${fileList}"
													finishFunc="finishUpload()"
													useFileBox="true"
													allowedTypes="*"
													bigSize="false"
												/> --%>
											</td>
										</tr>
										<tr>
						        			<th><label>팀퀴즈</label></th>
						        			<td>
						        				<span class="custom-input">
													<input type="radio" name="quizTeamyn" id="quizTeamynY" value="Y" onchange="teamynChange(this.value)" ${vo.examGbncd eq 'QUIZ_TEAM' ? 'checked' : ''}>
													<label for="quizTeamynY">예</label>
												</span>
												<span class="custom-input ml5">
													<input type="radio" name="quizTeamyn" id="quizTeamynN" value="N" onchange="teamynChange(this.value)" ${empty vo.examBscId || vo.examGbncd ne 'QUIZ_TEAM' ? 'checked' : ''}>
													<label for="quizTeamynN">아니오</label>
												</span>
												<div id="teamQuizDiv" ${empty vo.examBscId || vo.examGbncd ne 'QUIZ_TEAM' ? 'style="display:none"' : '' }>
										        	<c:forEach var="list" items="${dvclasList }" varStatus="i">
														<div class="form-row" id='lrnGrpView${list.dvclasNo}'>
															<div class="input_btn width-100per">
																<label>${list.dvclasNo }반</label>
																<input type='hidden' id='lrnGrpId${list.dvclasNo}' name='lrnGrpIds' value="${empty vo.examBscId ? '' : list.lrnGrpId}:${list.sbjctId}">
																<input class="form-control width-60per" type="text" name="name" id="lrnGrpnm${list.dvclasNo}" placeholder="팀 분류를 선택해 주세요." value="${empty vo.examBscId ? '' : list.lrnGrpnm}" readonly="" autocomplete="off">
																<a class="btn type1 small" onclick="teamGrpChcPopup('${list.dvclasNo}','${list.sbjctId }')">학습그룹지정</a>
															</div>
														</div>
											        	<c:if test="${i.count eq 1 }">
											        		<div class="form-inline">
																<small class="note2">! 구성된 팀이 없는 경우 메뉴 “과목설정 > 학습그룹지정”에서 팀을 생성해 주세요</small>
															</div>
											        	</c:if>
											        	<div class="ui segment" id="setQuizDiv${list.dvclasNo }" style="display:none;">
											        		<span class="custom-input">
															    <input type="checkbox" name="lrnGrpSubasmtStngyns" id="lrnGrpSubasmtStngyn_${list.dvclasNo }" data-bscId="${not empty vo.examBscId && list.lrnGrpSubasmtStngyn eq 'Y' ? list.examBscId : '' }" value="Y:${list.sbjctId }" onchange="lrnGrpSubasmtStngynChange(this)" ${not empty vo.examBscId && list.lrnGrpSubasmtStngyn eq 'Y' ? 'checked' : '' }>
															    <label for="lrnGrpSubasmtStngyn_${list.dvclasNo }">학습그룹별 부 과제 설정</label>
															</span>
												        	<div id="subInfoDiv${list.dvclasNo }" ${not empty vo.examBscId && list.lrnGrpSubasmtStngyn eq 'Y' ? '' : 'style="display: none;"' }></div>
											        	</div>
										        	</c:forEach>
										        </div>
						        			</td>
						        		</tr>
						        	</tbody>
						        </table>
						        <div class="course_list">
						        	<ul class="accordion course_week">
						        		<li>
						        			<div class="title-wrap">
		                                        <a class="title" href="#">
		                                            <span>옵션</span>
		                                        </a>
		                                        <div class="btn_right">
		                                            <i class="arrow xi-angle-down"></i>
		                                        </div>
		                                    </div>

		                                    <div class="cont">
												<table class="table-type5">
										        	<colgroup>
										        		<col class="width-15per" />
										        		<col class="" />
										        	</colgroup>
										        	<tbody>
										        		<tr>
										        			<th><label>재응시 사용</label></th>
										        			<td>
										        				<div class="form-inline">
																	<span class="custom-input">
																		<input type="radio" name="examDtlVO.reexamyn" id="reexamynY" value="Y" onchange="reexamynChange(this.value)" ${vo.examDtlVO.reexamyn eq 'Y' ? 'checked' : ''}>
																		<label for="reexamynY">예</label>
																	</span>
																	<span class="custom-input ml5">
																		<input type="radio" name="examDtlVO.reexamyn" id="reexamynN" value="N" onchange="reexamynChange(this.value)" ${empty vo.examBscId || vo.examDtlVO.reexamyn eq 'N' ? 'checked' : ''}>
																		<label for="reexamynN">아니오</label>
																	</span>
																</div>
																<div id="reexamDiv" style="<c:if test="${empty vo.examBscId || vo.examDtlVO.reexamyn ne 'Y'}">display: none;</c:if>">
																	<table class="table-type5">
															        	<colgroup>
															        		<col class="width-20per" />
															        		<col class="" />
															        	</colgroup>
															        	<tbody>
															        		<tr>
															        			<th><label>재응시 기간</label></th>
															        			<td>
															        				<input id="redateSt" type="text" name="redateSt" class="datepicker" timeId="retimeSt" toDate="redateEd" value="${fn:substring(vo.examDtlVO.reexamPsblSdttm,0,8)}">
																					<input id="retimeSt" type="text" name="retimeSt" class="timepicker" dateId="redateSt" value="${fn:substring(vo.examDtlVO.reexamPsblSdttm,8,12)}">
																					<span class="txt-sort">~</span>
																					<input id="redateEd" type="text" name="redateEd" class="datepicker" timeId="retimeEd" fromDate="redateSt" value="${fn:substring(vo.examDtlVO.reexamPsblEdttm,0,8)}">
																					<input id="retimeEd" type="text" name="retimeEd" class="timepicker" dateId="redateEd" value="${fn:substring(vo.examDtlVO.reexamPsblEdttm,8,12)}">
															        			</td>
															        		</tr>
															        		<tr>
															        			<th><label>재응시 적용률</label></th>
															        			<td>
															        				<div class="form-row">
																						<div class="input_btn">
																							<input class="form-control md" name="examDtlVO.reexamMrkRfltrt" id="reexamMrkRfltrt" type="text" inputmask="numeric" maxVal="100" value="${vo.examDtlVO.reexamMrkRfltrt }" autocomplete="off"><label>%</label>
																						</div>
																					</div>
															        			</td>
															        		</tr>
															        	</tbody>
															        </table>
														        </div>
										        			</td>
										        		</tr>
										        	</tbody>
										        </table>
		                                    </div>
						        		</li>
						        	</ul>
						        </div>
							</form>
				        </div>
				        <!--table-type-->
				    </div>
				</div>
        	</div>
            <!-- //content -->
        </main>
        <!-- //classroom-->
    </div>
</body>
</html>