<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/smnr/common/smnr_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="module" value="editor,fileuploader"/>
	</jsp:include>

	<script type="text/javascript">
		var dialog;
		const editors = {};	// 에디터 목록 저장용

		$(window).on('load', function() {
			if(${not empty vo.smnrId}) {
				$("input[name=smnrGbncd]:checked").trigger("change");

				if(${vo.smnrGbn eq 'SMNR_TEAM' }) {
					// 부과제 조회
					var lrnGrpId = $("input[name=lrnGrpIds]").val().split(":")[0];	// 학습그룹아이디
					var lrnGrpnm = $("input[name=lrnGrpnm]").val();					// 학습그룹명
					var sbjctId = $("input[name=lrnGrpIds]").val().split(":")[1];	// 과목아이디

					selectTeam(lrnGrpId, lrnGrpnm, "${subjectVO.dvclasNo}:"+sbjctId);
				}
			}

		});

		// 대기중온라인플랫폼사용자수조회
		function pendingUserCntCheck() {
			if($("input[name=smnrGbncd]:checked").val() == "ONLN_SMNR") {
				let url = "/smnr/pltfrm/pendingOnlnPltfrmUserCntSelectAjax.do";
				const subSmnrs = [];
				// 세미나 종료일시
				let sdttmStr = UiComm.getDateTimeVal("dateSt", "timeSt");
				let addMin = parseInt($("#smnrMntsHour").val())*60 + parseInt($("#smnrMntsMin").val());
				var d = new Date(sdttmStr.slice(0,4), sdttmStr.slice(4,6)-1, sdttmStr.slice(6,8), sdttmStr.slice(8,10), sdttmStr.slice(10,12));
				d.setMinutes(d.getMinutes() + addMin);
				var edttm = d.getFullYear() + ('0'+(d.getMonth()+1)).slice(-2) + ('0'+d.getDate()).slice(-2) + ('0'+d.getHours()).slice(-2) + ('0'+d.getMinutes()).slice(-2) + "59";

				const map = {
					gbn		: "ZOOM",
					sdttm 	: UiComm.getDateTimeVal("dateSt", "timeSt") + "00",
					edttm	: edttm
				};
				subSmnrs.push(map);

				$.ajax({
				    url 	 	: url,
				    async	 	: false,
				    type 	 	: "POST",
				    dataType 	: "json",
				    data 	 	: {subSmnrs : JSON.stringify(subSmnrs)},
				}).done(function(data) {
					if(data.result == 0) {
						saveConfirm();
					} else {
						UiComm.showMessage("해당 일자에 사용가능한 라이센스가 없습니다.", "info");
					}
				}).fail(function() {
					UiComm.showMessage("조회 중 에러가 발생했습니다.", "error");
				});
			} else {
				saveConfirm();
			}
		}

		// 저장 확인
	    function saveConfirm() {
	    	let validator = UiValidator("writeSmnrForm");
			validator.then(function(result) {
				if (result) {
					if(!isNull()) {
						return false;
					}

					let dx = dx5.get("fileUploader");
					// 첨부파일 있으면 업로드
		    		if (dx.availUpload()) {
		    			dx.startUpload();
		    		}
					// 첨부파일 없으면 저장 호출
		    		else {
		    			save();
		    		}
				}
			});
	    }

	 	// 파일 업로드 완료
	    function finishUpload() {
	    	let url = "/common/uploadFileCheck.do"; // 업로드된 파일 검증 URL
        	let dx = dx5.get("fileUploader");
        	let data = {
        		"uploadFiles" : dx.getUploadFiles(),
        		"uploadPath"  : dx.getUploadPath()
        	};

        	// 업로드된 파일 체크
        	ajaxCall(url, data, function(data) {
        		if(data.result > 0) {
        			$("#uploadFiles").val(dx.getUploadFiles());

        	    	save();
        		} else {
					UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
        		}
        	},
        	function(xhr, status, error) {
        		UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
        	});
	    }

	    // 세미나 등록, 수정
	    function save() {
	    	setValue();
			UiComm.showLoading(true);

			let dx = dx5.get("fileUploader");
    		$("#delFileIdStr").val(dx.getDelFileIdStr()); // 삭제파일 ID 설정

			var url = "/smnr/smnrRegistAjax.do";
			if(${not empty vo.smnrId}) {
				url = "/smnr/smnrModifyAjax.do";
			}
			$.ajax({
			    url 	 : url,
			    async	 : false,
			    type 	 : "POST",
			    dataType : "json",
			    data 	 : $("#writeSmnrForm").serialize(),
			}).done(function(data) {
				UiComm.showLoading(false);
				if (data.result > 0) {
					smnrViewMv();
			    } else {
			     	UiComm.showMessage(data.message, "error");
			    }
			}).fail(function() {
				UiComm.showLoading(false);
				if(${empty vo.smnrId}) {
					UiComm.showMessage("<spring:message code='exam.error.insert' />", "error");	/* 저장 중 에러가 발생하였습니다. */
				} else {
					UiComm.showMessage("<spring:message code='exam.error.update' />", "error");	/* 수정 중 에러가 발생하였습니다. */
				}
			});
	    }

	    // 빈 값 체크
	    function isNull() {
			// 온라인 방식
			if($("input[name=smnrGbncd]:checked").val() == "ONLN_SMNR") {
				if($("input[name=autoRcdyn]:checked").val() == undefined) {
					UiComm.showMessage("<spring:message code='seminar.alert.select.auto.record' />", "info");	/* 녹화 여부를 선택해주세요. */
					return false;
				}
			}

			var smnrHour = parseInt($("#smnrMntsHour").val())*60;
			var smnrMin  = parseInt($("#smnrMntsMin").val());
			var addMin = parseInt(smnrHour) + parseInt(smnrMin);
			if(addMin == 0) {
				UiComm.showMessage("진행시간은 최소 1분 이상이어야 합니다.", "info");
				return;
			}

			// 팀 세미나 설정시
			if($("#smnrTeamynY").is(":checked")) {
				var isResult = true;
				var alertMsg = "";
				$("input[name=lrnGrpnm]:visible").each(function(i, e) {
					if(e.value == "") {
						isResult = false;
						alertMsg = "학습그룹을 지정하세요.";
						return false;
					}
				});

				$("tr.subSmnrTr").each(function(index, element) {
					var ttl = $(element).find("input[name='subSmnrnm']");
					if($.trim($(ttl).val()) == "") {
						isResult = false;
						alertMsg = "<spring:message code='exam.alert.input.title' />"	/* 제목을 입력하세요. */
						return false;
					}

					var teamId = ttl[0].id.split("_")[0];
					if(editors[teamId+'_editor'+index].isEmpty() || editors[teamId+'_editor'+index].getTextContent().trim() === "") {
						isResult = false;
						alertMsg = "<spring:message code='exam.alert.input.contents' />";	/* 내용을 입력하세요. */
						return false;
					}
				});

				if(!isResult) {
					UiComm.showMessage(alertMsg, "warning");
					return false;
				}
			// 전체 세미나
			} else {
				if(UiComm.getDateTimeVal("dateSt", null) == "") {
					UiComm.showMessage("세미나 일시를 선택해주세요.", "info");
					return false;
				}
				if(UiComm.getDateTimeVal(null, "timeSt") == "") {
					UiComm.showMessage("세미나 시간을 선택해주세요.", "info");
					return false;
				}
			}

			return true;
	    }

	    // 값 채우기
	    function setValue() {
	    	// 팀 세미나
			if($("#smnrTeamynY").is(":checked")) {
				const subSmnrs = [];
		    	$("tr.subSmnrTr").each(function(index, element) {
					var ttl = $(element).find("input[name='subSmnrnm']");
					var teamId = ttl[0].id.split("_")[0];

					const map = {
						id		: teamId,
						ttl		: $.trim($(ttl).val()),
						cts		: editors[teamId+'_editor'+index].getPublishingHtml()
					};
					subSmnrs.push(map);
		    	});
	    		$("#subSmnrs").val(JSON.stringify(subSmnrs));
			}

			// 세미나 시작일시
			$("#smnrSdttm").val(UiComm.getDateTimeVal("dateSt", "timeSt") + "00");

			// 세미나 종료일시
			let sdttmStr = UiComm.getDateTimeVal("dateSt", "timeSt");
			let addMin = parseInt($("#smnrMntsHour").val())*60 + parseInt($("#smnrMntsMin").val());
			var d = new Date(sdttmStr.slice(0,4), sdttmStr.slice(4,6)-1, sdttmStr.slice(6,8), sdttmStr.slice(8,10), sdttmStr.slice(10,12));
			d.setMinutes(d.getMinutes() + addMin);
			var result = d.getFullYear() + ('0'+(d.getMonth()+1)).slice(-2) + ('0'+d.getDate()).slice(-2) + ('0'+d.getHours()).slice(-2) + ('0'+d.getMinutes()).slice(-2) + "59";
			$("#smnrEdttm").val(result);

			// 세미나시간
			$("#smnrMnts").val(addMin);
	    }

		/**
		 * 세미나 화면 이동
		 */
		function smnrViewMv() {
			var url = "/smnr/profSmnrListView.do";	// 세미나 목록 화면
			var kvArr = [];
			kvArr.push({'key' : 'sbjctId', 		'val' : "${vo.sbjctId}"});

			submitForm(url, kvArr);
		}

		/**
		 * 팀 세미나 여부 변경
		 * @param {String}  value - 팀 세미나 여부
		 */
		function smnrTeamChange(value) {
			if(value == "Y") {
				$("#teamSmnrDiv").show();
			} else {
				$("#teamSmnrDiv").hide();
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
				url: "/team/teamHome/teamCtgrSelectPop.do?sbjctId="+sbjctId+"&searchFrom="+i + ":" + sbjctId
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
			$("input[name=lrnGrpIds]").val(lrnGrpId + ":" + idList[1]);
			$("input[name=lrnGrpnm]").val(lrnGrpnm);
			$("#setSmnrDiv" + idList[0]).show();

			var url  = "/smnr/smnrLrnGrpSubSmnrListAjax.do";
			var data = {
				lrnGrpId  	: lrnGrpId,
				smnrId 		: $("input[name=smnrId]").val()
			};
			UiComm.showLoading(true);

			$.ajax({
		        url 	  : url,
		        async	  : false,
		        type 	  : "POST",
		        dataType  : "json",
		        data 	  : JSON.stringify(data),
		        contentType: "application/json; charset=UTF-8",
		    }).done(function(data) {
		    	UiComm.showLoading(false);
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
							html += "	<tr class='subSmnrTr'>";
							html += "		<th><label>" + v.teamnm + "</label></th>";
							html += "		<td>";
							html += "			<table class='table-type5'>";
							html += "				<colgroup>";
							html += "					<col class='width-20per' />";
							html += "					<col class='' />";
							html += "				</colgroup>";
							html += "				<tbody>";
							html += "					<tr>";
							html += "						<th><label for='" + v.teamId + "_Smnrnm_" + i + "'>주제</label></th>";
							html += "						<td><input type='text' id='" + v.teamId + "_Smnrnm_" + i + "' name='subSmnrnm' value='" + (v.smnrnm == null ? '' : v.smnrnm) + "' inputmask='byte' maxLen='200' class='width-100per' /></td>";
							html += "					</tr>";
							html += "					<tr>";
							html += "						<th><label for='" + v.teamId + "_contentTextArea_" + i + "'>내용</label></th>";
							html += "						<td>";
							html += "							<div class='editor-box'>";
							html += "								<textarea name='" + v.teamId + "_contentTextArea_" + i + "' id='" + v.teamId + "_contentTextArea_" + i + "'>" + (v.smnrCts == null ? '' : v.smnrCts) + "</textarea>";
							html += "							</div>";
							html += "						</td>";
							html += "					</tr>";
							html += "					<tr>";
							html += "						<th><label for='attchFile1'>첨부파일</label></th>";
							html += "						<td></td>";
			//				html += "							<div id='"+v.teamId+"_upload"+i+"-container' class='dext5-container' style='width:100%;height:180px'></div>";
			//				html += "							<div id='"+v.teamId+"_upload"+i+"-btn-area' class='dext5-btn-area'><button type='button' id='"+v.teamId+"_upload"+i+"_btn-add'><spring:message code='button.select.file'/></button>";
			//				html += "							<button type='button' id='"+v.teamId+"_upload"+i+"_btn-filebox'><spring:message code='button.from_filebox'/></button>";
			//				html += "							<button type='button' id='"+v.teamId+"_upload"+i+"_btn-delete'><spring:message code='button.delete'/></button></div>";
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
				   	UiInputmask();
				   	if(returnList.length > 0) {
				   		returnList.forEach(function(v, i) {
				   			// html 에디터 생성
							editors[v.teamId+'_editor'+i] = UiEditor({
																targetId: v.teamId+'_contentTextArea_'+i,
																uploadPath: "/smnr",
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

					$("#subInfoDiv" + idList[0]).show();
				} else {
					UiComm.showMessage(data.message, "error");
				}
		    }).fail(function() {
			   	UiComm.showLoading(false);
			   	UiComm.showMessage("<spring:message code='exam.error.copy' />", "error");	/* 가져오기 중 에러가 발생하였습니다. */
		    });
		}

		// 세미나방식변경이벤트
		function smnrGbnChange(value) {
			// 오프라인 세미나
			if("OFLN_SMNR" == value) {
				$(".onlineTr").hide();
			// 온라인 세미나
			} else {
				$(".onlineTr").css("display", "table-row");
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
                                세미나
                            </h2>
				        </div>
				        <spring:message code="exam.button.save" var="save" /><!-- 저장 -->
				        <spring:message code="exam.button.mod"  var="modify" /><!-- 수정 -->
				        <div class="board_top">
					        <div class="right-area">
					        	<a href="javascript:pendingUserCntCheck()" class="btn type2">${empty vo.smnrId ? save : modify }</a>
					            <a href="javascript:smnrViewMv()" class="btn type2"><spring:message code="exam.button.list" /></a><!-- 목록 -->
					        </div>
				        </div>
				        <!--table-type-->
				        <div class="table-wrap">
							<form name="writeSmnrForm" id="writeSmnrForm" method="POST" autocomplete="off" onsubmit="return false;">
						    	<input type="hidden" name="smnrId" 						value="${vo.smnrId }" />
						        <input type="hidden" name="sbjctId" 					value="${vo.sbjctId }" />
						        <input type="hidden" name="mrkRfltrt" 					value="${empty vo.smnrId ? 0 : vo.mrkRfltrt }" />
						        <input type="hidden" name="smnrTycd"					value="EDU_SMNR" />
						        <input type="hidden" name="smnrSdttm" 					value="${vo.smnrSdttm }" 		id="smnrSdttm" />
						        <input type="hidden" name="smnrEdttm" 					value="${vo.smnrEdttm }"  		id="smnrEdttm" />
						        <input type="hidden" name="smnrMnts" 					value="${vo.smnrMnts }"  		id="smnrMnts" />
						        <input type="hidden" name="subSmnrs" 					value=""	   					id="subSmnrs" />
						        <input type="hidden" name="uploadFiles"  				value=""						id="uploadFiles" />
								<input type="hidden" name="uploadPath"   				value="${vo.uploadPath}"		id="uploadPath"   />
								<input type="hidden" name="delFileIdStr" 				value=""						id="delFileIdStr" />
						        <table class="table-type5">
						        	<colgroup>
						        		<col class="width-20per" />
						        		<col class="" />
						        	</colgroup>
						        	<tbody>
						        		<tr>
						        			<th><label class="req">세미나 방식</label></th>
						        			<td>
						        				<span class="custom-input">
													<input type="radio" name="smnrGbncd" id="onlnGbn" value="ONLN_SMNR" onchange="smnrGbnChange(this.value)" ${vo.smnrGbncd eq 'ONLN_SMNR' || empty vo.smnrId ? 'checked' : '' }>
													<label for="onlnGbn">온라인</label>
												</span>
												<span class="custom-input ml5">
													<input type="radio" name="smnrGbncd" id="oflnGbn" value="OFLN_SMNR" onchange="smnrGbnChange(this.value)" ${vo.smnrGbncd eq 'OFLN_SMNR' ? 'checked' : '' }>
													<label for="oflnGbn">오프라인</label>
												</span>
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label for="smnrnm" class="req">세미나명</label></th>
						        			<td>
						        				<input type="text" name="smnrnm" id="smnrnm" inputmask="byte" maxLen="200" class="width-100per" required="true" value="${vo.smnrnm }">
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label for="contentTextArea" class="req">세미나내용</label></th>
						        			<td>
												<div class="editor-box">
													<%-- HTML 에디터 --%>
													<uiex:htmlEditor
														id="smnrCts"
														name="smnrCts"
														uploadPath="${vo.uploadPath}"
														value="${vo.smnrCts}"
														height="500px"
														required="true"
													/>
												</div>
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label for="dateSt" class="req">세미나 일시</label></th>
						        			<td>
						        				<input id="dateSt" type="text" name="dateSt" class="datepicker" timeId="timeSt" value="${fn:substring(vo.smnrSdttm,0,8)}">
												<input id="timeSt" type="text" name="timeSt" class="timepicker" dateId="dateSt" value="${fn:substring(vo.smnrSdttm,8,12)}">
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label for="" class="req">진행 시간</label></th>
						        			<td>
						        				<c:set var="timeHour" value="1" />
						        				<c:set var="timeMin" value="0" />
						        				<c:if test="${not empty vo.smnrId }">
						        					<c:set var="timeHour" value="${vo.smnrMnts / 60 }" />
						        					<c:set var="timeMin" value="${vo.smnrMnts % 60 }" />
						        				</c:if>
						        				<fmt:parseNumber var="fmtHour" value="${timeHour }" integerOnly="true" />
						        				<select class="form-select" id="smnrMntsHour">
				                                    <c:forEach var="hour" begin="0" end="5">
						        						<option value="0${hour }" ${hour eq fmtHour ? 'selected' : '' }>${hour }시간</option>
						        					</c:forEach>
				                                </select>
						        				<select class="form-select" id="smnrMntsMin">
				                                    <c:forEach var="min" begin="0" end="55" step="5">
						        						<option value="${min < 10 ? '0' : '' }${min }" ${min eq timeMin ? 'selected' : '' }>${min }분</option>
						        					</c:forEach>
				                                </select>
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label class="req">성적반영</label></th>
						        			<td>
						        				<span class="custom-input">
													<input type="radio" name="mrkRfltyn" id="mrkRfltynY" value="Y" ${vo.mrkRfltyn eq 'Y' || empty vo.smnrId ? 'checked' : '' }>
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
													<input type="radio" name="mrkOyn" id="mrkOynY" value="Y" ${vo.mrkOyn eq 'Y' || empty vo.smnrId ? 'checked' : '' }>
													<label for="mrkOynY">예</label>
												</span>
												<span class="custom-input ml5">
													<input type="radio" name="mrkOyn" id="mrkOynN" value="N" ${vo.mrkOyn eq 'N' ? 'checked' : '' }>
													<label for="mrkOynN">아니오</label>
												</span>
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label>평가방법</label></th>
						        			<td>
						        				<span class="custom-input">
													<input type="radio" name="evlScrTycd" id="scrEvlTycd" value="SCR" ${vo.evlScrTycd eq 'SCR' || empty vo.smnrId ? 'checked' : '' }>
													<label for="scrEvlTycd">점수형</label>
												</span>
												<span class="custom-input ml5">
													<input type="radio" name="evlScrTycd" id="ptcpEvlTycd" value="PTCP_FULL_SCR" ${vo.evlScrTycd eq 'PTCP_FULL_SCR' ? 'checked' : '' }>
													<label for="ptcpEvlTycd">참여형</label>
												</span>
												<span class="fcBlue">
													( 세미나 참여 : 100점, 미참여 : 0점 자동배점 )
												</span>
						        			</td>
						        		</tr>
						        		<tr>
											<th><label for="attchFile">첨부파일</label></th>
											<td>
												<uiex:dextuploader
													id="fileUploader"
													path="${vo.uploadPath}"
													limitCount="5"
													limitSize="100"
													oneLimitSize="100"
													listSize="3"
													fileList="${vo.fileList}"
													finishFunc="finishUpload()"
													allowedTypes="*"
												/>
											</td>
										</tr>
										<tr class="onlineTr">
						        			<th><label>팀 세미나</label></th>
						        			<td>
												<span class="custom-input ml5">
													<input type="radio" name="byteamSubsmnrUseyn" id="smnrTeamynN" value="N" onchange="smnrTeamChange(this.value)" ${empty vo.smnrId || vo.byteamSubsmnrUseyn eq 'N' ? 'checked' : ''}>
													<label for="smnrTeamynN">아니오</label>
												</span>
						        				<span class="custom-input">
													<input type="radio" name="byteamSubsmnrUseyn" id="smnrTeamynY" value="Y" onchange="smnrTeamChange(this.value)" ${vo.byteamSubsmnrUseyn eq 'Y' ? 'checked' : ''}>
													<label for="smnrTeamynY">예</label>
												</span>
												<div id="teamSmnrDiv" ${empty vo.smnrId || vo.smnrGbn ne 'SMNR_TEAM' ? 'style="display:none"' : '' }>
													<div class="form-row" id='lrnGrpView${subjectVO.dvclasNo}'>
														<div class="input_btn width-100per">
															<label>${subjectVO.dvclasNo }반</label>
															<input type='hidden' id='lrnGrpId${subjectVO.dvclasNo}' name='lrnGrpIds' value="${empty vo.smnrId ? '' : vo.lrnGrpId}:${subjectVO.sbjctId}">
															<input class="form-control width-60per" type="text" name="lrnGrpnm" id="lrnGrpnm${subjectVO.dvclasNo}" placeholder="팀 분류를 선택해 주세요." value="${empty vo.smnrId ? '' : vo.lrnGrpnm}" readonly="" autocomplete="off">
															<a class="btn type1 small" href="javascript:teamGrpChcPopup('${subjectVO.dvclasNo}','${subjectVO.sbjctId }')">학습그룹지정</a>
														</div>
													</div>
													<c:if test="${i.count eq 1 }">
														<div class="form-inline">
															<small class="note2">! 구성된 팀이 없는 경우 메뉴 “과목설정 > 학습그룹지정”에서 팀을 생성해 주세요</small>
														</div>
													</c:if>
													<div id="setSmnrDiv${subjectVO.dvclasNo }" style="display:none;">
														<div id="subInfoDiv${subjectVO.dvclasNo }" ${not empty vo.smnrId && vo.byteamSubsmnrUseyn eq 'Y' ? '' : 'style="display: none;"' }></div>
													</div>
										        </div>
						        			</td>
						        		</tr>
						        		<tr class="onlineTr">
						        			<th><label>ZOOM 회의 ID</label></th>
						        			<td>
						        				<input type="text" name="meetngrmId" inputmask="byte" maxLen="11" placeholder="자동 입력" readonly="readonly" value="${vo.meetngrmId }">
						        			</td>
						        		</tr>
						        		<tr class="onlineTr">
						        			<th><label>ZOOM 회의 녹화</label></th>
						        			<td>
						        				<span class="custom-input">
													<input type="radio" name="autoRcdyn" id="autoRcdynY" value="Y" ${vo.autoRcdyn eq 'Y' || empty vo.smnrId ? 'checked' : '' }>
													<label for="autoRcdynY">예</label>
												</span>
												<span class="custom-input ml5">
													<input type="radio" name="autoRcdyn" id="autoRcdynN" value="N" ${vo.autoRcdyn eq 'N' ? 'checked' : '' }>
													<label for="autoRcdynN">아니오</label>
												</span>
						        			</td>
						        		</tr>
						        	</tbody>
						        </table>
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