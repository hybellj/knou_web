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
		const editors = {};					// 에디터 목록 저장용
		let subSmnrUploaderIds = [];        // 팀별 업로더 ID 목록 (순서 보장)
        let subSmnrUploadResults = {};      // { uploaderId : { uploadFiles, uploadPath, delFileIdStr, copyFiles } }

		$(window).on('load', function() {
			if(${not empty vo.smnrId}) {
				$("input[name=smnrGbncd]:checked").trigger("change");

				// 팀세미나수정시
				if(${vo.smnrGbn eq 'SMNR_TEAM' }) {
					let teamGrpId	= $("input[name=teamGrpIds]").val().split(":")[0];	// 팀그룹아이디
					let teamGrpnm 	= $("input[name=teamGrpnm]").val();					// 팀그룹명
					let sbjctId 	= $("input[name=teamGrpIds]").val().split(":")[1];	// 과목아이디

					// 팀선택
					selectTeam(teamGrpId, teamGrpnm, "${subjectVO.dvclasNo}:"+sbjctId);
				}
			}

		});

		// 대기중온라인플랫폼사용자수조회
		function pendingUserCntCheck() {
			if($("input[name=smnrGbncd]:checked").val() == "ONLN_SMNR") {
				const subSmnrs = [];
				// 세미나 종료일시
				let sdttmStr = UiComm.getDateTimeVal("dateSt", "timeSt");
				let addMin = parseInt($("#smnrMntsHour").val())*60 + parseInt($("#smnrMntsMin").val());
				let d = new Date(sdttmStr.slice(0,4), sdttmStr.slice(4,6)-1, sdttmStr.slice(6,8), sdttmStr.slice(8,10), sdttmStr.slice(10,12));
				d.setMinutes(d.getMinutes() + addMin);
				let edttm = d.getFullYear() + ('0'+(d.getMonth()+1)).slice(-2) + ('0'+d.getDate()).slice(-2) + ('0'+d.getHours()).slice(-2) + ('0'+d.getMinutes()).slice(-2) + "59";

				subSmnrs.push({
					gbn		: "ZOOM",
					sdttm 	: UiComm.getDateTimeVal("dateSt", "timeSt") + "00",
					edttm	: edttm
				});
				const url = "/smnr/pltfrm/pendingOnlnPltfrmUserCntSelectAjax.do";

				$.ajax({
				    url 	 	: url,
				    async	 	: false,
				    type 	 	: "POST",
				    dataType 	: "json",
				    data 	 	: {subSmnrs : JSON.stringify(subSmnrs)},
				    beforeSend	: () => UiComm.showLoading(true),
	                success		: function (data) {
	                    if (data.result == 0) {
	                    	saveConfirm();
	                    } else {
	                    	UiComm.showMessage("해당 일자에 사용가능한 라이센스가 없습니다.", "info");
	                    }
	                },
	                error		: () => UiComm.showMessage("조회 중 에러가 발생했습니다.", "error"),
	                complete	: () => UiComm.showLoading(false)
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
		    		if (dx.availUpload()) {
		    			dx.startUpload();
		    		} else {
		    			continueSubSmnrUploadChain(0);
		    		}
				}
			});
	    }

	 	// 파일 업로드 완료
	    function finishUpload() {
	    	let url = "/common/uploadFileCheck.do"; // 업로드된 파일 검증 URL
        	let dx = dx5.get("fileUploader");
        	let data = {
        		uploadFiles : dx.getUploadFiles(),
        		uploadPath  : dx.getUploadPath()
        	};

        	// 업로드된 파일 체크
        	ajaxCall(url, data, function(data) {
        		if(data.result > 0) {
        			$("#uploadFiles").val(dx.getUploadFiles());

        			continueSubSmnrUploadChain(0);
        		} else {
					UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
        		}
        	},
        	function(xhr, status, error) {
        		UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
        	});
	    }

	 	// 팀그룹부과제업로드처리
	    function continueSubSmnrUploadChain(uploadIdx) {
            if (uploadIdx >= subSmnrUploaderIds.length) {
                save();
                return;
            }

            const uploaderId = subSmnrUploaderIds[uploadIdx];
            const dx = dx5.get(uploaderId);

            if (!dx) {
                subSmnrUploadResults[uploaderId] = {
                    uploadFiles: "",
                    uploadPath: "",
                    delFileIdStr: ""
                };
                continueSubSmnrUploadChain(uploadIdx + 1);
                return;
            }

            if (dx.availUpload()) {
                dx.startUpload();
            } else {
                subSmnrUploadResults[uploaderId] = {
                    uploadFiles: "",
                    uploadPath: dx.getUploadPath(),
                    delFileIdStr: dx.getDelFileIdStr ? dx.getDelFileIdStr() : ""
                };
                continueSubSmnrUploadChain(uploadIdx + 1);
            }
        }

	 	// 팀그룹부과제업로드완료
	    function onSubSmnrUploadComplete(uploaderId) {

            const uploadIdx = subSmnrUploaderIds.indexOf(uploaderId);
            const dx = dx5.get(uploaderId);

            const url = "/common/uploadFileCheck.do";
            const data = {
                uploadFiles: dx.getUploadFiles(),
                uploadPath: dx.getUploadPath()
            };

            ajaxCall(url, data, function (resp) {
                if (resp.result > 0) {
                    subSmnrUploadResults[uploaderId] = {
                        uploadFiles: dx.getUploadFiles(),
                        uploadPath: dx.getUploadPath(),
                        delFileIdStr: dx.getDelFileIdStr ? dx.getDelFileIdStr() : ""
                    };

                    continueSubSmnrUploadChain(uploadIdx + 1);
                } else {
                    UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");
                }
            }, function () {
                UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");
            }, true);
        }

	    // 세미나 등록, 수정
	    function save() {
	    	setValue();

			let dx = dx5.get("fileUploader");
    		$("#delFileIdStr").val(dx.getDelFileIdStr()); // 삭제파일 ID 설정

			let url = "/smnr/smnrRegistAjax.do";
			if(${not empty vo.smnrId}) {
				url = "/smnr/smnrModifyAjax.do";
			}

			ajaxCall(url, $("#writeSmnrForm").serialize(), function (data) {
                if (data.result > 0) {
                	smnrViewMv("", "LIST");
                } else {
                    UiComm.showMessage(data.message, "error");
                }
            }, function () {
            	if(${empty vo.smnrId}) {
					UiComm.showMessage("<spring:message code='exam.error.insert' />", "error");	/* 저장 중 에러가 발생하였습니다. */
				} else {
					UiComm.showMessage("<spring:message code='exam.error.update' />", "error");	/* 수정 중 에러가 발생하였습니다. */
				}
            }, true);
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

			let smnrHour = parseInt($("#smnrMntsHour").val())*60;
			let smnrMin  = parseInt($("#smnrMntsMin").val());
			let addMin = parseInt(smnrHour) + parseInt(smnrMin);
			if(addMin == 0) {
				UiComm.showMessage("진행시간은 최소 1분 이상이어야 합니다.", "info");
				return;
			}

			return true;
	    }

	    // 값 채우기
	    function setValue() {
	    	// 팀세미나시
			if($("#smnrTeamynY").is(":checked")) {
				const subSmnrs = [];
		    	$("tr.subSmnrTr").each(function(index, element) {
		    		let ttl = $(element).find("input[name='subSmnrnm']");				// 부주제
		    		let teamId = ttl[0].id.split("_")[0];								// 팀아이디
		    		let uploaderId = "subSmnrFileUploader_" + teamId + "_" + index;		// 업로더아이디
		    		let uploadResult = subSmnrUploadResults[uploaderId] || {};			// 업로더상세값

		    		subSmnrs.push({
						id		: teamId,
						ttl		: $.trim($(ttl).val()),
						cts		: $("#"+teamId+'_subSmnrCts_'+index).val(),
						uploadFiles: uploadResult.uploadFiles || "",
						uploadPath: uploadResult.uploadPath || "${vo.uploadPath}",
						delFileIdStr: uploadResult.delFileIdStr || ""
					});
		    	});
	    		$("#subSmnrs").val(JSON.stringify(subSmnrs));
			}

			$("#smnrSdttm").val(UiComm.getDateTimeVal("dateSt", "timeSt") + "00");	// 세미나 시작일시

			// 세미나 종료일시
			let sdttmStr = UiComm.getDateTimeVal("dateSt", "timeSt");
			let addMin = parseInt($("#smnrMntsHour").val())*60 + parseInt($("#smnrMntsMin").val());
			var d = new Date(sdttmStr.slice(0,4), sdttmStr.slice(4,6)-1, sdttmStr.slice(6,8), sdttmStr.slice(8,10), sdttmStr.slice(10,12));
			d.setMinutes(d.getMinutes() + addMin);
			var result = d.getFullYear() + ('0'+(d.getMonth()+1)).slice(-2) + ('0'+d.getDate()).slice(-2) + ('0'+d.getHours()).slice(-2) + ('0'+d.getMinutes()).slice(-2) + "59";
			$("#smnrEdttm").val(result);

			$("#smnrMnts").val(addMin);	// 세미나시간
	    }

		/**
		 * 팀 세미나 여부 변경
		 * @param value - 팀 세미나 여부
		 */
		function smnrTeamChange(value) {
			$("#teamSmnrDiv").toggle(value == "Y");

			// 팀그룹 필수변경
			document.querySelectorAll('#teamSmnrDiv input[name=teamGrpnm]').forEach(input => {
				if($("#smnrTeamynY").is(":checked")) {
					input.setAttribute("required", $(input).is(':visible') ? "true" : "false");
				} else {
					input.setAttribute("required", "false");
				}
			});

			// 부주제, 내용 필수변경
	    	document.querySelectorAll('#teamSmnrDiv input[name=subSmnrnm], #teamSmnrDiv textarea').forEach(input => {
				input.setAttribute("required", value == "Y" ? "true" : "false");
			});
		}

		/**
		 * 팀그룹지정 팝업
		 * @param i 		- 분반 순서
		 * @param sbjctId 	- 과목아이디
		 */
	    function teamGrpChcPopup(i, sbjctId) {
			dialog = UiDialog("dialog1", {
				title	: "팀그룹지정",
				width	: 600,
				height	: 500,
				url		: "/team/teamHome/teamCtgrSelectPop.do?sbjctId="+sbjctId+"&searchFrom="+i + ":" + sbjctId
			});
		}

	    /**
		 * 팀선택
		 * @param teamGrpId 	- 팀그룹아이디
		 * @param teamGrpnm 	- 팀그룹명
		 * @param id 			- 분반 순서:과목개설아이디
		 */
		 function selectTeam(teamGrpId, teamGrpnm, id) {
			let idList = id.split(':');
			$("input[name=teamGrpIds]").val(teamGrpId + ":" + idList[1]);
			$("input[name=teamGrpnm]").val(teamGrpnm);

			const url  = "/smnr/smnrTeamGrpSubSmnrListAjax.do";
			const data = {
				teamGrpId  	: teamGrpId,
				smnrId 		: $("input[name=smnrId]").val()
			};

			$.ajax({
		        url 	  	: url,
		        async	  	: false,
		        type 	  	: "POST",
		        dataType  	: "json",
		        data 	  	: JSON.stringify(data),
		        contentType	: "application/json; charset=UTF-8",
		        beforeSend	: () => UiComm.showLoading(true),
                success		: function (data) {
                    if (data.result > 0) {
                    	let returnList = data.returnList || [];
    					let html = "";

    				   	if(returnList.length > 0) {
    				   		html += "<table class='table-type5 in_table'>";
    						html += "	<colgroup>";
    						html += "		<col class='width-5per' />";
    						html += "		<col class='width-15per' />";
    						html += "		<col class='' />";
    						html += "	</colgroup>";
    						html += "	<tbody>";
    	        			returnList.forEach(function(v, i) {
    							html += "	<tr class='subSmnrTr'>";
    							html += "		<th rowspan='3' class='group-header'><label>" + v.teamnm + "</label></th>";
    							html += "		<th><label for='" + v.teamId + "_Smnrnm_" + i + "' class='req'>부주제</label></th>";
    							html += "		<td>";
    							html += "			<div class='form-row'>";
    							html += "				<input type='text' id='" + v.teamId + "_Smnrnm_" + i + "' name='subSmnrnm' value='" + (v.smnrnm == null ? '' : v.smnrnm) + "' inputmask='byte' maxLen='200' class='form-control width-100per' />";
    							html += "			</div>";
    							html += "		</td>"
    							html += "	</tr>";
    							html += "	<tr>";
    							html += "		<th><label for='" + v.teamId + "_subSmnrCts_" + i + "' class='req'>내용</label></th>";
    							html += "		<td>";
    							html += "			<label class='width-100per'>";
    							html += "				<textarea rows='4'";
    							html += "						  class='form-control resize-none'";
    							html += "						  name='" + v.teamId + "_subSmnrCts_" + i + "'";
    							html += "						  id='" + v.teamId + "_subSmnrCts_" + i + "'>";
    							html += 					(v.smnrCts == null ? '' : v.smnrCts);
    							html += "				</textarea>";
    							html += "			</label>";
    							html += "		</td>";
    							html += "	</tr>";
    							html += "	<tr>";
    							html += "		<th><label>첨부파일</label></th>";
    							html += "		<td>";
    							html += "			<div id='subSmnrUploaderWrap_" + v.teamId + "_" + i + "'></div>";
    							html += "		</td>";
    							html += "	</tr>";
    	        			});
    						html += "	</tbody>";
    						html += "</table>";
    				   	}

    				   	$("#subInfoDiv" + idList[0]).empty().html(html);
    				   	/*
                         * 재조회 시 중복 방지
                         */
                        subQuizUploaderIds = [];
                        subQuizUploadResults = {};

    				   	if(returnList.length > 0) {
    				   		returnList.forEach(function(v, i) {
    				   			// html 에디터 생성
    				   			const editorId = v.teamId + "_subSmnrCts_" + i;
    							editors[editorId] = UiEditor({
    													targetId: editorId,
    													uploadPath: "${vo.uploadPath}",
    													height: "250px"
    												});

    					   		// 첨부파일
    							const uploaderId 	= "subSmnrFileUploader_" + v.teamId + "_" + i;
    				            const wrapId 		= "subSmnrUploaderWrap_" + v.teamId + "_" + i;

    				            UiFileUploader({
    				                id: uploaderId,
    				                targetId: wrapId,
    				                path: "${vo.uploadPath}",
    				                limitCount: 5,
    				                limitSize: 1024,
    				                oneLimitSize: 1024,
    				                listSize: 3,
    				                fileList: "",
    				                finishFunc: onSubSmnrUploadComplete,
    				                allowedTypes: "*"
    				            });

    				            subSmnrUploaderIds.push(uploaderId);
    				   		});
    				   	}

    					$("#subInfoDiv" + idList[0]).show();
    					// 부주제, 내용 필수변경
    			    	document.querySelectorAll('#teamSmnrDiv input[name=subSmnrnm], #teamSmnrDiv textarea').forEach(input => {
    						input.setAttribute("required", "true");
    					});
                    } else {
                    	UiComm.showMessage(data.message, "error");
                    }
                },
                error		: () => UiComm.showMessage("<spring:message code='exam.error.copy' />", "error"),	/* 가져오기 중 에러가 발생하였습니다. */
                complete	: () => UiComm.showLoading(false)
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
                                세미나
                            </h2>
				        </div>
				        <spring:message code="exam.button.save" var="save" /><!-- 저장 -->
				        <spring:message code="exam.button.mod"  var="modify" /><!-- 수정 -->
				        <div class="board_top">
					        <div class="right-area">
					        	<a href="javascript:pendingUserCntCheck()" class="btn type2">${empty vo.smnrId ? save : modify }</a>
					            <a href="javascript:smnrViewMv('', 'LIST')" class="btn type2"><spring:message code="exam.button.list" /></a><!-- 목록 -->
					        </div>
				        </div>
				        <!--table-type-->
				        <div class="table-wrap">
							<form name="writeSmnrForm" id="writeSmnrForm" method="POST" autocomplete="off" onsubmit="return false;">
								<input type="hidden" name="encParams"    				value="<c:out value='${encParams}' />"	id="encParams" />
						    	<input type="hidden" name="smnrId" 						value="${vo.smnrId }" />
						        <input type="hidden" name="mrkRfltrt" 					value="${empty vo.smnrId ? 0 : vo.mrkRfltrt }" />
						        <input type="hidden" name="smnrTycd"					value="EDU_SMNR" />
						        <input type="hidden" name="smnrSdttm" 					value="${vo.smnrSdttm }" 				id="smnrSdttm" />
						        <input type="hidden" name="smnrEdttm" 					value="${vo.smnrEdttm }"  				id="smnrEdttm" />
						        <input type="hidden" name="smnrMnts" 					value="${vo.smnrMnts }"  				id="smnrMnts" />
						        <input type="hidden" name="subSmnrs" 					value=""	   							id="subSmnrs" />
						        <input type="hidden" name="uploadFiles"  				value=""								id="uploadFiles" />
								<input type="hidden" name="uploadPath"   				value="${vo.uploadPath}"				id="uploadPath"   />
								<input type="hidden" name="delFileIdStr" 				value=""								id="delFileIdStr" />
						        <table class="table-type5">
						        	<colgroup>
						        		<col class="width-15per" />
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
						        			<th><label for="smnrCts" class="req">세미나내용</label></th>
						        			<td>
												<div class="editor-box">
													<%-- HTML 에디터 --%>
													<textarea id="smnrCts" name="smnrCts" required="true"><c:out value="${vo.smnrCts}"/></textarea>
                                                    <script>
                                                        // HTML 에디터
                                                        editors['editor'] = UiEditor({
                                                            targetId: "smnrCts",
                                                            uploadPath: "${vo.uploadPath}",
                                                            height: "300px"
                                                        });
                                                    </script>
												</div>
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label for="contLabel" class="req">강의목록 주차 설정</label></th>
						        			<td>
						        				<select class="form-select" name="lctrWknoSchdlId" required="true">
			                                		<option value="">주차</option>
				                                    <c:forEach var="item" items="${lctrWknoList }">
										            	<option value="${item.lctrWknoSchdlId }" ${item.lctrWknoSchdlId eq vo.lctrWknoSchdlId || item.curLctrWkno eq 'Y' ? 'selected' : '' }>${item.lctrWknonm }</option>
										            </c:forEach>
				                                </select>
						        			</td>
						        		</tr>
						        		<tr>
						        			<th><label for="dateSt" class="req">세미나 일시</label></th>
						        			<td>
						        				<input id="dateSt" type="text" name="dateSt" class="datepicker" timeId="timeSt" value="${fn:substring(vo.smnrSdttm,0,8)}" required="true">
												<input id="timeSt" type="text" name="timeSt" class="timepicker" dateId="dateSt" value="${fn:substring(vo.smnrSdttm,8,12)}" required="true">
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
						        				<div class="form-inline">
							        				<span class="custom-input">
														<input type="radio" name="byteamSubsmnrUseyn" id="smnrTeamynY" value="Y" onchange="smnrTeamChange(this.value)" ${vo.byteamSubsmnrUseyn eq 'Y' ? 'checked' : ''}>
														<label for="smnrTeamynY">예</label>
													</span>
													<span class="custom-input ml5">
														<input type="radio" name="byteamSubsmnrUseyn" id="smnrTeamynN" value="N" onchange="smnrTeamChange(this.value)" ${empty vo.smnrId || vo.byteamSubsmnrUseyn eq 'N' ? 'checked' : ''}>
														<label for="smnrTeamynN">아니오</label>
													</span>
						        				</div>

						        				<div id="teamSmnrDiv" class="team_item" ${empty vo.smnrId || vo.smnrGbn ne 'SMNR_TEAM' ? 'style="display:none"' : '' }>
										        	<div class="item" id="teamGrpView${subjectVO.dvclasNo}">
		                                                <label class="label_num">${subjectVO.dvclasNo }반</label>
		                                                <input type='hidden' id='teamGrpId${subjectVO.dvclasNo}' name='teamGrpIds' value="${empty vo.smnrId ? '' : vo.teamGrpId}:${subjectVO.sbjctId}">
		                                                <input class="form-control wide" type="text" name="teamGrpnm" id="teamGrpnm${subjectVO.dvclasNo}" placeholder="팀그룹을 선택해 주세요." value="${empty vo.smnrId ? '' : vo.teamGrpnm}" readonly="true" autocomplete="off">
														<button type="button" class="btn basic" onclick="teamGrpChcPopup('${subjectVO.dvclasNo}','${subjectVO.sbjctId }')">팀그룹지정</a>
		                                            </div>
													<small class="note2">! 구성된 팀이 없는 경우 메뉴 “과목설정 > 팀그룹지정”에서 팀을 생성해 주세요</small>
		                                            <div id="subInfoDiv${subjectVO.dvclasNo }" class="table-wrap mb30" ${not empty vo.smnrId && vo.byteamSubsmnrUseyn eq 'Y' ? '' : 'style="display: none;"' }></div>
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