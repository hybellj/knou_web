<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">

<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="module" value="table,editor,fileuploader"/>
		<jsp:param name="style" value="${
			templateUrl eq 'bbsHome' ? 'dashboard'
			: templateUrl eq 'bbsLect' ? 'classroom'
			: templateUrl eq 'bbsMgr' ? 'admin' : ''}"/>
	</jsp:include>

	<!-- 게시판 공통 -->
	<jsp:include page="/WEB-INF/jsp/bbs/common/bbs_common_inc.jsp"/>

	<style>
		.editor-box { position: relative; z-index: 1; }
	</style>

	<script type="text/javascript">
		var BBS_ID 		 = '<c:out value="${bbsAtclVO.bbsId}" />';
		var ATCL_ID      = '<c:out value="${bbsAtclVO.atclId}" />';
		var TEMPLATE_URL = '<c:out value="${templateUrl}" />';
		var MODE         = '<c:out value="${bbsAtclVO.gubun == 'edit' ? 'U' : 'C'}" />';

		var PAGE_INDEX   = 1;
		var LIST_SCALE   = '<c:out value="${bbsVO.listScale}" />';
		var EPARAM       = '<c:out value="${encParams}" />';

		var dialog;

		$(document).ready(function() {
			if(MODE == 'U') {
				bbsAtclModifyForm();
			}

			// 그룹공지 사용 여부 토글 (radio: grpNtcUseyn)
			$('input[name="grpNtcUseyn"]').on('change', function() {
				toggleGrpNtcList();
			});
			toggleGrpNtcList(); // 초기 상태 적용

			// 옵션 아코디언 클릭 시 그룹공지(수강생) 영역 토글
		    $(".options_wrap .accordion .title").on("click", function(e) {
		        e.preventDefault();

		        var $grp = $("#bbsAtclGrpNtc");
		        var willShow = ($grp.css("display") === "none");

		        $grp.toggle();
		        $(this).closest("li").toggleClass("on", willShow); // 아코디언 열림 표시(화살표 등)

		        // 처음 펼칠 때 목록 조회
		        if (willShow) {
		            listPaging(1);
		        }
		    });

			getBbsAtclGrpNtcList(1);
		});

		// 그룹공지 영역 표시/숨김
		function toggleGrpNtcList() {
			var val = $('input[name="grpNtcUseyn"]:checked').val();
			if (val === 'Y') {
				$('#grpNtcListArea').show();
			} else {
				$('#grpNtcListArea').hide();
			}
		}

		// 수강생 추가 팝업
		function openModal() {
			dialog = UiDialog("dialog1", {
				title: "<spring:message code='bbs.label.add_stdnt' />",
				width: 1000,
				height: 800,
				url: "/bbs/${templateUrl}/bbsAtclGrpNtcPopView.do?encParams=${encParams}",
				autoresize: false
			});
		}

		// 모달 닫기
		function closeModal() {
			if (dialog && typeof dialog.close === "function") {
				dialog.close();
			}
		}

		/**
		 * 그룹공지 수강생 테이블 행 HTML 생성 (서버조회/모달추가 공통)
		 */
		 function buildGrpNtcRow(v) {
		    return ''
		        + '<tr data-user-id="' + (v.userId || '') + '">'
		        +   '<td class="rowNo"></td>'
		        +   '<td>' + UiComm.escapeHtml(v.userRprsId || '') + '</td>'
		        +   '<td>' + UiComm.escapeHtml(v.userId    || '') + '</td>'
		        +   '<td>' + UiComm.escapeHtml(v.usernm     || '') + '</td>'
		        +   '<td><button type="button" class="btn type2" onclick="removeGrpNtcStudent(this)"><spring:message code="common.button.delete"/></button></td>'
		        + '</tr>';
		}

		// 모달(iframe)에서 호출: 선택 수강생을 테이블에 추가
		function addGrpNtcStudents(students) {
			var $tbody = $("#bbsAtclGrpNtcList");

			students.forEach(function(s, idx) {
			    $("#grpNtcHiddenArea").append(
			        '<input type="hidden" name="userList[' + idx + '].userId" value="' + (s.userId || '') + '">'
			    );
			});

			refreshGrpNtcRowNo();
			closeModal();
		}

		// 행 삭제
		function removeGrpNtcStudent(btn) {
			$(btn).closest("tr").remove();
			refreshGrpNtcRowNo();
		}

		// 번호 + 총건수 재계산
		function refreshGrpNtcRowNo() {
			var $rows = $("#bbsAtclGrpNtcList tr");
			$rows.each(function(i) { $(this).find(".rowNo").text(i + 1); });
			$("#totStdCnt").text($rows.length);
		}

		// 행에서 userId 수집
		function collectGrpNtcStudents() {
		    var list = [];
		    $("#bbsAtclGrpNtcList tr").each(function() {
		        list.push({
		              userId : $(this).data("user-id")
		        });
		    });
		    return list;
		}

		/**
		 * 그룹공지 기존 대상 수강생 조회 (수정 모드 등)
		 */
		 function getBbsAtclGrpNtcList(pageIndex) {
			    PAGE_INDEX = pageIndex;

			    const url = "/bbs/" + TEMPLATE_URL + "/bbsAtclGrpNtcList.do";
			    var extData = { pageIndex: pageIndex, listScale: LIST_SCALE, bbsId: BBS_ID, atclId: ATCL_ID };
			    var data = { encParams: EPARAM, addParams: UiComm.makeEncParams(extData) };

			    ajaxCall(url, data, function (data) {
			        if (data.encParams != null && data.encParams != '') { EPARAM = data.encParams; }

			        if (data.result > 0) {
			            var $tbody = $("#bbsAtclGrpNtcList").empty();
			            var list = data.returnList || [];

			            list.forEach(function (o) {
			                $tbody.append(buildGrpNtcRow(o));
			            });
			            refreshGrpNtcRowNo();

			            // 대상 수강생이 있으면 그룹공지 '예' 자동 선택 + 그리드 표시
			            if (list.length > 0) {
			                $("#grpNtcUseynY").prop("checked", true);
			                toggleGrpNtcList();
			            }
			        } else {
			            UiComm.showMessage(data.message, "error");
			        }
			    }, function () {
			        UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");
			    }, true);
			}

		// 저장 버튼
		function saveConfirm() {
			UiValidator("atclWriteForm").then(function(result) {
				if (result) {
					let dx = dx5.get("fileUploader");
					if (dx.availUpload()) {
						dx.startUpload();
					} else {
						atclSave();
					}
				}
			});
		}

		// 파일 업로드 완료
		function finishUpload(uploaderId) {
			let url = "/common/uploadFileCheck.do";
			let dx = dx5.get("fileUploader");
			let data = { "uploadFiles": dx.getUploadFiles(), "uploadPath": dx.getUploadPath() };

			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					$("#uploadFiles").val(dx.getUploadFiles());
					atclSave();
				} else {
					UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");
				}
			}, function() {
				UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");
			});
		}

		// 게시글 저장
		function atclSave() {
			$("#optnSdttm").val(makeDateTimeStr("optnStartDate", "optnStartTime"));
			$("#optnEdttm").val(makeDateTimeStr("optnEndDate", "optnEndTime"));
			$("#rsrvSdttm").val(makeDateTimeStr("rsrvStartDate", "rsrvStartTime"));
			$("#rsrvEdttm").val(makeDateTimeStr("rsrvEndDate", "rsrvEndTime"));
			$("#autoAlimSdttm").val(makeDateTimeStr("autoAlimStartDate", "autoAlimStartTime"));
			$("#autoAlimEdttm").val(makeDateTimeStr("autoAlimEndDate", "autoAlimEndTime"));

			var dx = dx5.get("fileUploader");
			$("#delFileIdStr").val(dx.getDelFileIdStr());

			// 그룹공지 대상 수강생: 저장 직전 인덱스 부여한 hidden 재생성
			$("#grpNtcHiddenArea").empty();
			if ($('input[name="grpNtcUseyn"]:checked').val() === 'Y') {
				var students = collectGrpNtcStudents();
				students.forEach(function(s, idx) {
					$("#grpNtcHiddenArea").append(
							'<input type="hidden" name="userList[' + idx + '].userId" value="' + (s.userId || '') + '">'
				    );
				});
			}

			var url = "/bbs/" + TEMPLATE_URL +"/bbsAtclSave.do";
			var returnUrl = "/bbs/" + TEMPLATE_URL +"/bbsAtclListView.do?encParams=${encParams}";
			var data = $("#atclWriteForm").serialize();

			bbsCommon.regist(url, returnUrl, data);
		}

		// 날짜+시간 14자리 문자열
		function makeDateTimeStr(dateId, timeId) {
			var dateVal = $("#" + dateId).val() || "";
			var timeVal = $("#" + timeId).val() || "";
			if (dateVal !== "") {
				return (dateVal + timeVal).replace(/[^0-9]/g, "") + "00";
			}
			return "";
		}

		// 목록화면 이동
		function moveListPage() {
			document.location.href = "/bbs/${templateUrl}/bbsAtclListView.do?encParams=${encParams}";
		}

		function bbsAtclModifyForm() {
			var url  = "/bbs/" + TEMPLATE_URL + "/bbsAtclDtlView.do";
			var data = { bbsId : BBS_ID, atclId : ATCL_ID };

			ajaxCall(url, data, function(data) {
				if(data.result > 0 && data.returnVO) {
					var vo = data.returnVO;

					if(vo.optnCd === 'IMPT')      { $("#optnCdI").prop("checked", true); }
					else if(vo.optnCd === 'FIX')  { $("#optnCdF").prop("checked", true); }
					else                          { $("#optnCdN").prop("checked", true); }

					setSplitDateTime(vo.optnSdttm, 'optnStartDate', 'optnStartTime');
					setSplitDateTime(vo.optnEdttm, 'optnEndDate', 'optnEndTime');

					$("#atclTtl").val(vo.atclTtl);
					editor.openHTML(vo.atclCts);

					if(vo.fileList && vo.fileList.length > 0) {
						setTimeout(function(){
							var dx = dx5.get("fileUploader");
							dx.addCopyFiles(vo.fileList);
						}, 500);
					}

					var i = vo.dvclasNo;
					$("#dvclasNo"+i).prop("checked", true);

					if(vo.cmntPrmyn === "Y") { $("#cmntPrmyn").prop("checked", true); }

					if(vo.rsrvyn === "Y") {
						$("#rsrvyn").prop("checked", true);
						$("#sw_rsrvyn").attr("aria-checked", "true").addClass("ui-switcher-on");
					}
					setSplitDateTime(vo.rsrvSdttm, 'rsrvStartDate', 'rsrvStartTime');
					setSplitDateTime(vo.rsrvEdttm, 'rsrvEndDate', 'rsrvEndTime');

					if(vo.oyn === "Y") {
						$("#oyn").prop("checked", true);
						$("#sw_oyn").attr("aria-checked", "true").trigger("change");
					} else {
						$("#oyn").prop("checked", false);
						$("#sw_oyn").attr("aria-checked", "false").trigger("change");
					}

					if(vo.ntcGbncd === "Y") { $("#ntcGbncdY").prop("checked", true); }
					else                    { $("#ntcGbncdN").prop("checked", true); }

					if(vo.autoAlimyn === "Y") {
						$("#autoAlimyn").prop("checked", true);
						$("#sw_autoAlimyn").attr("aria-checked", "true").trigger("change");
					}
					setSplitDateTime(vo.autoAlimSdttm, 'autoAlimStartDate', 'autoAlimStartTime');
					setSplitDateTime(vo.autoAlimEdttm, 'autoAlimEndDate', 'autoAlimEndTime');

					// 그룹 공지사항 사용 여부
					if (vo.grpNtcUseyn === "Y") {
					    $("#grpNtcUseynY").prop("checked", true);
					} else {
					    $("#grpNtcUseynN").prop("checked", true);
					}
					toggleGrpNtcList();
				}
			});
		}

		function setSplitDateTime(fullStr, dateInputId, timeInputId) {
			if (!fullStr || fullStr.length !== 14) return;
			if (dateInputId) document.getElementById(dateInputId).value = fullStr.substring(0, 8);
			if (timeInputId) document.getElementById(timeInputId).value = fullStr.substring(8, 14);
		}
	</script>
</head>

<body class="class ${uiex:getTheme()} ">
	<div id="wrap" class="main">
		<jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>

		<main class="common">
			<jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp"/>

			<div id="content" class="content-wrap common">
				<jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>

				<div class="class_sub">
					<jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>

					<div class="sub-content">
						<div class="table-wrap">
							<form id="atclWriteForm" name="atclWriteForm" onsubmit="return false;">
								<input type="hidden" name="orgId"         id="orgId"   value="${bbsVO.orgId}" />
								<input type="hidden" name="bbsTycd"       id="bbsTycd"    value="NTC" />
								<input type="hidden" name="encParams"     id="encParams"    value="${encParams}" />
								<input type="hidden" name="gubun"         id="gubun"        value="${bbsAtclVO.gubun}" />
								<input type="hidden" name="uploadFiles"   id="uploadFiles"  value="" />
								<input type="hidden" name="uploadPath"    id="uploadPath"   value="${bbsVO.uploadPath}" />
								<input type="hidden" name="atclId"        id="atclId"       value="${bbsAtclVO.atclId}"/>
								<input type="hidden" name="atclOptnId"    id="atclOptnId"   value="${bbsAtclVO.atclOptnId}">
								<input type="hidden" name="sbjctId"       id="sbjctId"      value="${bbsAtclVO.sbjctId}">
								<input type="hidden" name="optnUseyn"     id="optnUseyn"    value="Y">
								<input type="hidden" name="delFileIdStr"  id="delFileIdStr" value="" />
								<input type="hidden" name="optnSdttm"     id="optnSdttm" />
								<input type="hidden" name="optnEdttm"     id="optnEdttm" />
								<input type="hidden" name="rsrvSdttm"     id="rsrvSdttm" />
								<input type="hidden" name="rsrvEdttm"     id="rsrvEdttm" />
								<input type="hidden" name="autoAlimSdttm" id="autoAlimSdttm" />
								<input type="hidden" name="autoAlimEdttm" id="autoAlimEdttm" />

								<!-- 그룹공지 대상 수강생 hidden(저장 직전 동적 생성) -->
								<span id="grpNtcHiddenArea"></span>

							<table class="table-type5">
								<colgroup>
									<col class="width-15per" />
									<col class="" />
								</colgroup>
								<tbody>
									<%-- <c:if test="${(bbsAtclVO.bbsTycd == 'NTC' && bbsAtclVO.bbsRefTycd == 'SBJCT') || bbsAtclVO.bbsTycd == 'DATARM'}">
										<tr>
											<th><label for="orgId" class="req">운영과목</label></th>
											<td>
												<div class="form-inline">
													<select class="form-select" id="srchOrg" name="searchOrgId">
				                                        <option value=""><spring:message code="cls.label.org"/>기관</option>
				                                        <c:forEach var="item" items="${orgList}">
				                                            <option value="${item.orgId}" <c:if test="${bbsAtclVO.orgId == item.orgId}">selected</c:if>>
				                                                    ${item.orgnm}
				                                            </option>
				                                        </c:forEach>
				                                    </select>

													<select class="form-select" id="srchSbjt" name="sbjctId">
				                                        <option value=""><spring:message code="cls.label.operating.subject"/>운영과목</option>
				                                        <c:forEach var="item" items="${subjectList}">
				                                            <option value="${item.sbjctId}"
				                                                    <c:if test="${bbsAtclVO.sbjctId == item.sbjctId}">selected</c:if>>
				                                                    ${item.sbjctnm}
				                                                        <c:if test="${not empty item.dvclasNo}"> (${item.dvclasNo}<spring:message code="cls.label.decls.name"/>반)</c:if>
				                                                <c:if test="${not empty item.crclmnNo}"> [${item.crclmnNo}]</c:if>
				                                            </option>
				                                        </c:forEach>
				                                    </select>
												</div>
											</td>
										</tr>
									</c:if> --%>
									<c:if test="${bbsAtclVO.bbsTycd == 'NTC'}">
										<tr>
											<th><label for="optnCdN"><spring:message code="bbs.label.form_main_option"/></label></th>
											<td>
												<div class="form-inline">
													<span class="custom-input"><input type="radio" name="optnCd" id="optnCdN" value="NOT_APPLY" checked><label for="optnCdN"><spring:message code="bbs.label.na"/></label></span>
													<span class="custom-input ml5"><input type="radio" name="optnCd" id="optnCdI" value="IMPT"><label for="optnCdI"><spring:message code="bbs.label.impt"/></label></span>
													<span class="custom-input ml5"><input type="radio" name="optnCd" id="optnCdF" value="FIX"><label for="optnCdF"><spring:message code="bbs.label.fix"/></label></span>
													<input type="text" placeholder="시작일" id="optnStartDate" name="optnStartDate" class="datepicker">
													<input type="text" placeholder="시작시간" id="optnStartTime" name="optnStartTime" class="timepicker">
													<span class="txt-sort">~</span>
													<input type="text" placeholder="종료일" id="optnEndDate" name="optnEndDate" class="datepicker">
													<input type="text" placeholder="종료시간" id="optnEndTime" name="optnEndTime" class="timepicker">
												</div>
											</td>
										</tr>
									</c:if>
									<c:if test="${bbsAtclVO.bbsTycd == 'TEAM'}">
										<tr>
											<th><label for="teamGrpId" class="req">학습그룹 > 팀</label></th>
											<td>
												<div class="form-inline">
													<select class="form-select" id="teamGrpId" name="teamGrpId" required="true">
														<option value=""><spring:message code="bbs.label.lrn_grp" /></option>
														<c:forEach var="list" items="${filterOptions.teamGrpList}">
															<option value="${list.teamGrpId}">${list.teamGrpnm}</option>
														</c:forEach>
													</select>
													<select class="form-select" id="teamId" name="teamId" required="true">
														<option value=""><spring:message code="bbs.label.team" /></option>
														<c:forEach var="list" items="${filterOptions.teamList}">
															<option value="${list.teamId}">${list.teamnm}</option>
														</c:forEach>
													</select>
												</div>
											</td>
										</tr>
									</c:if>
									<tr>
										<th><label for="atclTtl" class="req"><spring:message code="bbs.label.form_title" /></label></th>
										<td>
											<div class="form-row">
												<input type="text" id="atclTtl" name="atclTtl" autocomplete="off" required="true" class="form-control width-100per" inputmask="byte" maxLen="200" value="${bbsAtclVO.atclTtl}" />
											</div>
										</td>
									</tr>
									<tr>
										<th><label for="atclCts" class="req"><spring:message code="bbs.label.form_cts" /></label></th>
										<td data-th="입력">
											<div class="editor-box">
												<label for="atclCts" class="hide">Content</label>
												<textarea id="atclCts" name="atclCts" required="true"><c:out value="${bbsAtclVO.atclCts}"/></textarea>
												<script>
													let editor = UiEditor({
														targetId: "atclCts",
														uploadPath: "${bbsVO.uploadPath}",
														height: "500px"
													});
												</script>
											</div>
										</td>
									</tr>
									<c:if test="${bbsAtclVO.bbsTycd == 'NTC'}">
										<tr>
											<th><label><spring:message code="bbs.label.form_decls"/></label></th>
											<td>
												<div class="checkbox_type">
													<span class="custom-input"><input type="checkbox" name="dvclasNo" id="dvclasNoA" value="Y" required="true"><label for="dvclasNoA">전체</label></span>
													<c:forEach var="i" begin="1" end="4">
														<span class="custom-input"><input type="checkbox" name="dvclasNo" id="dvclasNo${i}" value="${i}" required="true"><label for="dvclasNo${i}">${i}반</label></span>
													</c:forEach>
												</div>
											</td>
										</tr>
									</c:if>
									<tr>
										<th><label for="fileUploader"><spring:message code="bbs.label.form_attach_file" /></label></th>
										<td>
											<uiex:dextuploader
												id="fileUploader"
												path="${bbsVO.uploadPath}"
												limitCount="5"
												limitSize="100"
												oneLimitSize="100"
												listSize="3"
												fileList="${bbsAtclVO.fileList}"
												finishFunc="finishUpload"
												allowedTypes="*"
											/>
										</td>
									</tr>
									<tr>
										<th><label><spring:message code="bbs.label.form_sub_option"/></label></th>
										<td><div class="checkbox_type"><span class="custom-input"><input type="checkbox" name="cmntPrmyn" id="cmntPrmyn" value="Y" checked><label for="cmntPrmyn">댓글 사용</label></span></div></td>
									</tr>
									<c:if test="${bbsAtclVO.bbsTycd == 'NTC'}">
										<tr>
											<th><label><spring:message code="bbs.label.form_write_resv"/></label></th>
											<td>
												<div class="date_area">
													<input type="checkbox" id="rsrvyn" name="rsrvyn" class="switch yesno" value="Y">
													<input type="text" id="rsrvStartDate" name="rsrvStartDate" class="datepicker">
													<input type="text" id="rsrvStartTime" name="rsrvStartTime" class="timepicker">
													<span class="txt-sort">~</span>
													<input type="text" id="rsrvEndDate" name="rsrvEndDate" class="datepicker">
													<input type="text" id="rsrvEndTime" name="rsrvEndTime" class="timepicker">
												</div>
											</td>
										</tr>
									</c:if>
									<c:if test="${bbsAtclVO.bbsTycd != 'QNA' && bbsAtclVO.bbsTycd != 'TEAM'}">
										<tr>
											<th><label><spring:message code="bbs.label.form_public_yn"/></label></th>
											<td><div class="form-row"><input type="checkbox" id="oyn" name="oyn" class="switch yesno" value="Y" checked></div></td>
										</tr>
									</c:if>
									<c:if test="${bbsAtclVO.bbsTycd == 'NTC'}">
										<tr>
											<th><label>공지사항 구분</label></th>
											<td>
												<div class="form-inline">
													<span class="custom-input"><input type="radio" name="ntcGbncd" id="ntcGbncdY" value="Y" checked><label for="ntcGbncdY">일반 공지</label></span>
													<span class="custom-input ml5"><input type="radio" name="ntcGbncd" id="ntcGbncdN" value="N"><label for="ntcGbncdN">긴급 공지</label></span>
												</div>
											</td>
										</tr>
										<tr>
											<th><label><spring:message code="bbs.label.form_auto_alim"/></label></th>
											<td>
												<div class="date_area">
													<input type="checkbox" id="autoAlimyn" name="autoAlimyn" class="switch yesno" value="Y">
													<input type="text" id="autoAlimStartDate" name="autoAlimStartDate" class="datepicker">
													<input type="text" id="autoAlimStartTime" name="autoAlimStartTime" class="timepicker">
													<span class="txt-sort">~</span>
													<input type="text" id="autoAlimEndDate" name="autoAlimEndDate" class="datepicker">
													<input type="text" id="autoAlimEndTime" name="autoAlimEndTime" class="timepicker">
												</div>
											</td>
										</tr>
									</c:if>
								</tbody>
							</table>

							<div class="options_wrap">
								<ul class="accordion">
									<li class="">
										<div class="title-wrap">
											<a class="title" href="#">
												<div class="lecture_tit">
													<strong><spring:message code='asmt.label.option'/></strong>
												</div>
												<i class="arrow xi-angle-down"></i>
											</a>
										</div>
										<div class="cont">
											<div class="table-wrap">
												<table class="table-type5">
													<colgroup>
														<col class="width-15per"/>
														<col/>
													</colgroup>
													<tbody>
													<tr>
														<th><label>그룹 공지사항</label></th>
														<td>
															<div class="form-inline">
																<span class="custom-input">
																	<input type="radio" name="grpNtcUseyn" id="grpNtcUseynN" value="N" ${bbsAtclVO.grpNtcUseyn eq 'N' ? 'checked' : '' }>
																	<label for="grpNtcUseynN"><spring:message code='asmt.common.no'/></label>
																</span>
																<span class="custom-input ml5">
																	<input type="radio" name="grpNtcUseyn" id="grpNtcUseynY" value="Y" ${bbsAtclVO.grpNtcUseyn eq 'Y' ? 'checked' : '' }>
																	<label for="grpNtcUseynY"><spring:message code='asmt.common.yes'/></label>
																</span>
															</div>

															<div id="grpNtcListArea" class="individualAssignment_list_area swapListsItem">
																<div class="board_top in_table">
																	<div class="board_top margin-top-4">
																		<span>수강생 [ <spring:message code="user.title.total.count" /> : <span class="fcBlue" id="totStdCnt">0</span>]</span>
																		<div class="right-area">
																			<button type="button" class="btn type1" onclick="openModal()">수강생 추가</button>
																		</div>
																	</div>
																</div>

																<div class="table-height-scroll">
																	<table class="table-type2">
																		<colgroup>
																			<col style="width:8%">
																			<col style="width:16%">
																			<col style="width:22%">
																			<col style="width:22%">
																			<col style="width:20%">
																			<col style="width:12%">
																		</colgroup>
																		<thead>
																		<tr>
																			<th><spring:message code='common.number.no'/></th>
																			<th><spring:message code='user.title.userinfo.manage.userrprsid'/></th>
																			<th>학번</th>
																			<th><spring:message code='user.title.userinfo.manage.usernm'/></th>
																			<th><spring:message code='sys.label.manage'/></th>
																		</tr>
																		</thead>
																		<tbody id="bbsAtclGrpNtcList"></tbody>
																	</table>
																</div>
															</div>
														</td>
													</tr>
													</tbody>
												</table>
											</div>
										</div>
									</li>
								</ul>
							</div>
							</form>
						</div>

						<div class="btns">
							<button type="button" class="btn type1" onclick="saveConfirm()"><spring:message code="common.button.save" /></button>
							<button type="button" class="btn type2" onclick="moveListPage()"><spring:message code="common.button.cancel" /></button>
						</div>
					</div>
				</div>
			</div>
		</main>
	</div>
</body>
</html>