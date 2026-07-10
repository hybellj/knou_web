<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
		/* 에디터 박스보다 위에 오도록 설정 */
		.editor-box { position: relative; z-index: 1; }
	</style>

	<script type="text/javascript">
		var ATCL_ID 		= '<c:out value="${bbsAtclVO.atclId}" />';
		var BBS_TYCD 		= '<c:out value="${bbsAtclVO.bbsTycd}" />';
		var BBS_ID 			= '<c:out value="${bbsVO.bbsId}" />';
		var TEMPLATE_URL 	= '<c:out value="${templateUrl}" />';
		var EPARAM			= '<c:out value="${encParams}" />';
		var LIST_SCALE		= '<c:out value="${bbsVO.listScale}" />';
		var PAGE_INDEX		= 1;

		// 수정화면 여부 (atclId가 있으면 수정)
		var IS_EDIT_MODE	= (ATCL_ID != null && ATCL_ID != '');

		// 서버에서 내려온 합쳐진 일시값 (yyyy-MM-dd HH:mm:ss 형식 가정)
		var OPTN_SDTTM      = '<c:out value="${bbsAtclVO.optnSdttm}" />';
		var OPTN_EDTTM      = '<c:out value="${bbsAtclVO.optnEdttm}" />';
		var RSRV_SDTTM      = '<c:out value="${bbsAtclVO.rsrvSdttm}" />';
		var RSRV_EDTTM      = '<c:out value="${bbsAtclVO.rsrvEdttm}" />';
		var AUTO_ALIM_SDTTM = '<c:out value="${bbsAtclVO.autoAlimSdttm}" />';
		var AUTO_ALIM_EDTTM = '<c:out value="${bbsAtclVO.autoAlimEdttm}" />';

		$(document).ready(function() {
			$('input[name="grpNtcGbncd"]').on('change', function() {
		        toggleGrpNtcList();
		    });

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

		    $("#srchOrg").on("change", function () {
	            loadSubjectOptions(false);
	        });

		    // ===== 수정화면 초기값 세팅 =====
		    if (IS_EDIT_MODE) {
		    	// chosen() 플러그인 초기화가 이 스크립트보다 나중에 실행될 수 있으므로,
		    	// 현재 실행 큐가 끝난 뒤(다음 틱)로 미뤄서 chosen 초기화 완료 후 동작하도록 함
		    	setTimeout(function() {
		    		initEditModeValues();
		    	}, 0);
		    }
		});

		// "yyyy-MM-dd HH:mm:ss" 형태의 문자열을 { date: "yyyy-MM-dd", time: "HH:mm" }로 분리
		// 서버에서 내려오는 실제 포맷이 다르면 이 함수만 수정하면 됨
		function splitDttm(dttmStr) {
			if (!dttmStr) {
				return { date: "", time: "" };
			}
			var parts = dttmStr.trim().split(" ");
			var datePart = parts[0] || "";
			var timePart = parts[1] ? parts[1].substring(0, 5) : ""; // HH:mm까지만
			return { date: datePart, time: timePart };
		}

		// 수정화면 진입 시, 저장된 값들을 화면 컨트롤에 반영
		function initEditModeValues() {
			// 기관(srchOrg) - 서버가 selected 처리한 원본 select 값을 그대로 유지하되,
			// chosen 플러그인 UI가 이를 반영하도록 값 재설정 + 강제 갱신 트리거
			var savedOrgId = '<c:out value="${bbsAtclVO.orgId}" />';
			if (savedOrgId) {
				$("#srchOrg").val(savedOrgId);
			}
			$("#srchOrg").trigger("chosen:updated");

			// 운영과목(과목) select는 기관 선택에 종속된 ajax 결과이므로,
			// 저장된 sbjctId를 유지한 채로 과목 옵션을 다시 채움 (loadSubjectOptions 내부에서 chosen:updated 처리됨)
			var savedSbjctId = '<c:out value="${bbsAtclVO.sbjctId}" />';
			if (savedSbjctId) {
				loadSubjectOptions(false);
			}

			// 주요옵션 기간 (optnSdttm/optnEdttm → 개별 date/time input에 분리 세팅)
			var optnStart = splitDttm(OPTN_SDTTM);
			var optnEnd   = splitDttm(OPTN_EDTTM);
			$("#optnStartDate").val(optnStart.date);
			$("#optnStartTime").val(optnStart.time);
			$("#optnEndDate").val(optnEnd.date);
			$("#optnEndTime").val(optnEnd.time);

			// 등록예약 기간 (rsrvSdttm/rsrvEdttm)
			var rsrvStart = splitDttm(RSRV_SDTTM);
			var rsrvEnd   = splitDttm(RSRV_EDTTM);
			$("#rsrvStartDate").val(rsrvStart.date);
			$("#rsrvStartTime").val(rsrvStart.time);
			$("#rsrvEndDate").val(rsrvEnd.date);
			$("#rsrvEndTime").val(rsrvEnd.time);

			// 자동알림 기간 (autoAlimSdttm/autoAlimEdttm)
			var autoAlimStart = splitDttm(AUTO_ALIM_SDTTM);
			var autoAlimEnd   = splitDttm(AUTO_ALIM_EDTTM);
			$("#autoAlimStartDate").val(autoAlimStart.date);
			$("#autoAlimStartTime").val(autoAlimStart.time);
			$("#autoAlimEndDate").val(autoAlimEnd.date);
			$("#autoAlimEndTime").val(autoAlimEnd.time);

			// 그룹공지(수강생 대상) 라디오 및 영역 초기화
			var grpNtcGbncd = '<c:out value="${bbsAtclVO.grpNtcGbncd}" />';
			if (grpNtcGbncd) {
				$('input[name="grpNtcGbncd"][value="' + grpNtcGbncd + '"]').prop('checked', true);
				toggleGrpNtcList();
			}
		}

		function loadSubjectOptions(triggerSearch) {
	        var currentValue = $("#srchSbjt").val() || '<c:out value="${bbsAtclVO.sbjctId}" />';

	        ajaxCall("/bbs/" + TEMPLATE_URL + "/selectBbsSubjectList.do", {
	                searchYr: $("#srchYear").val() || "",
	                searchSmstrCd: $("#srchTerm").val() || "",
	                searchOrgId: $("#srchOrg").val() || ""
	            },
	            function (data) {
	                var list = (data && data.returnList) ? data.returnList : [];
	                var $sbj = $("#srchSbjt");

	                $sbj.empty();
	                $sbj.append('<option value=""><spring:message code="cls.label.operating.subject"/><%-- 운영과목 --%></option>');

	                list.forEach(function (item) {
	                    var value = item.sbjctId || "";
	                    var label = item.sbjctnm || "";

	                    if (item.dvclasNo) {
	                        label += " (" + item.dvclasNo + '<spring:message code="cls.label.decls.name"/><%-- 반 --%>' + ")";
	                    }
	                    if (item.crclmnNo) {
	                        label += " [" + item.crclmnNo + "]";
	                    }

	                    $sbj.append(
	                        '<option value="' + UiComm.escapeHtml(String(value)) + '">'
	                        + UiComm.escapeHtml(String(label))
	                        + '</option>'
	                    );
	                });

	                if (currentValue && $sbj.find("option[value='" + currentValue + "']").length > 0) {
	                    $sbj.val(currentValue);
	                } else {
	                    $sbj.val("");
	                }

	                $sbj.trigger("chosen:updated");

	                // 목록 재조회 요청이 있을 때만 호출
	                if (triggerSearch) {
	                    loadClsList(1);
	                }
	            },
	            function () {
	                if (triggerSearch) {
	                    loadClsList(1);
	                }
	            },
	            false
	        );
	    }

		// 그룹공지 영역 토글
		function toggleGrpNtcList() {
            var selectedValue = $('input[name="grpNtcGbncd"]:checked').val();
            if (selectedValue === 'Y') {
				$('#bbsAtclGrpNtc').show();
			} else {
				$('#bbsAtclGrpNtc').hide();
			}
        }

		// 수강생 추가 팝업
		function openModal() {
			var param = $("#addStdntViewForm").serialize();
			dialog = UiDialog("dialog1", {
				title: "<spring:message code='bbs.label.add_stdnt' />",
				width: 1000,
				height: 800,
				url: "/bbs/${templateUrl}/bbsAtclGrpNtcPopView.do?" + param,
				autoresize: false
			});
		}

    	// 저장 버튼 (입력검증 후 업로드 또는 저장)
    	function saveConfirm() {
    		UiValidator("atclWriteForm")
    		.then(function(result) {
				if (!result) return;

				let dx = dx5.get("fileUploader");
				// 첨부파일 있으면 업로드, 없으면 바로 저장
				if (dx.availUpload()) {
					dx.startUpload();
				} else {
					atclSave();
				}
			});
    	}

    	// 파일 업로드 완료 콜백
        function finishUpload(uploaderId) {
        	let url = "/common/uploadFileCheck.do"; // 업로드된 파일 검증 URL
        	let dx = dx5.get(uploaderId);
        	let data = {
        		"uploadFiles" : dx.getUploadFiles(),
        		"uploadPath"  : dx.getUploadPath()
        	};

        	// 업로드된 파일 체크
        	ajaxCall(url, data, function(data) {
        		if(data.result > 0) {
        			$("#uploadFiles").val(dx.getUploadFiles());
        	    	// 게시글 저장 호출
        	    	atclSave();
        		} else {
					UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
        		}
        	},
        	function(xhr, status, error) {
        		UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
        	});
        }

    	// 게시글 저장
    	function atclSave() {
    		var dx = dx5.get("fileUploader");
    		$("#delFileIdStr").val(dx.getDelFileIdStr()); // 삭제파일 ID 설정

    		var url = "/bbs/${templateUrl}/bbsAtclSave.do";
    		var returnUrl = "/bbs/${templateUrl}/bbsAtclListView.do?encParams=${encParams}";
    		var data = $("#atclWriteForm").serialize();

    		bbsCommon.regist(url, returnUrl, data);
    	}

    	// 목록화면 이동
    	function moveListPage() {
    		document.location.href = "/bbs/${templateUrl}/bbsAtclListView.do?encParams=${encParams}";
    	}

    	/**
         * =========================================================
         * 그룹 공지사항 수강생 목록 조회
         * =========================================================
         */
        function getBbsAtclGrpNtcList(pageIndex) {
            PAGE_INDEX = pageIndex;

            const url = "/bbs/" + TEMPLATE_URL + "/bbsAtclGrpNtcList.do";
            var extData = { pageIndex: pageIndex, listScale: LIST_SCALE, bbsId: BBS_ID, atclId: ATCL_ID };
            var data = { encParams: EPARAM, addParams: UiComm.makeEncParams(extData) };

            ajaxCall(url, data, function (data) {
                if (data.encParams != null && data.encParams != '') {
                    EPARAM = data.encParams;
                }

                if (data.result > 0) {

                    let html = "";
                    data.returnList.forEach(function (o, i) {
                        html += "<tr>";
                        html += "    <td>" + (i + 1) + "</td>";
                        html += "    <td class='tgList'>" + UiComm.escapeHtml(o.stdntNo || "") + "</td>";
                        html += "    <td class='tgList'>" + UiComm.escapeHtml(o.usernm || "") + "</td>";
                        html += "    <td class='tgList'>" + UiComm.escapeHtml(o.usernm || "") + "</td>";
                        html += "    <td class='tgList'>" + UiComm.escapeHtml(o.usernm || "") + "</td>";
                        html += "</tr>";

                        //$("#indvAsmtList input[value='" + o.userId + "']").closest("tr").remove();
                    });

                    //$("#indvAsmtList tr").each(function (i) {
                    //    $("#indvAsmtList tr:eq(" + i + ") td:eq(1)").text(i + 1);
                    //});

                    $("#bbsAtclGrpNtcList").empty().append(html);
                } else {
                    UiComm.showMessage(data.message, "error");
                }
            }, function () {
                UiComm.showMessage("<spring:message code='fail.common.msg' />", "error");
            }, true);
        }
	</script>
</head>

<body class="home ${uiex:getTheme()} ${bodyClass}"><!-- 컬러선택시 클래스변경 -->
	<form name="addStdntViewForm" id="addStdntViewForm" method="POST">
		<input type="hidden" name="sbjctId" value="${bbsAtclVO.sbjctId}">
	</form>

    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/home_header.jsp"/>
        <!-- //common header -->

        <!-- dashboard -->
        <main class="common">

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="dashboard_sub">

                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">${bbsVO.bbsNm}</h2>
                            <uiex:navibar type="main"/> <%-- 네비게이션바 --%>
                        </div>

                        <!--table-type-->
						<div class="table-wrap">
							<form id="atclWriteForm" name="atclWriteForm" onsubmit="return false;">
								<input type="hidden" name="encParams"     id="encParams"    value="${encParams}" />
								<input type="hidden" name="gubun"         id="gubun"        value="${bbsAtclVO.gubun}" />
								<input type="hidden" name="atclId"        id="atclId"       value="${bbsAtclVO.atclId}"/>
								<input type="hidden" name="atclOptnId"    id="atclOptnId"   value="${bbsAtclVO.atclOptnId}">
								<input type="hidden" name="optnUseyn"     id="optnUseyn"    value="Y">
								<input type="hidden" name="delFileIdStr"  id="delFileIdStr" value="" />
								<input type="hidden" name="uploadFiles"   id="uploadFiles"  value="" />
								<input type="hidden" name="uploadPath"    id="uploadPath"   value="${bbsVO.uploadPath}" />

								<input type="hidden" name="optnSdttm"     id="optnSdttm" />
							    <input type="hidden" name="optnEdttm"     id="optnEdttm" />
							    <input type="hidden" name="rsrvSdttm"     id="rsrvSdttm" />
							    <input type="hidden" name="rsrvEdttm"     id="rsrvEdttm" />
							    <input type="hidden" name="autoAlimSdttm" id="autoAlimSdttm" />
							    <input type="hidden" name="autoAlimEdttm" id="autoAlimEdttm" />

								<table class="table-type5">
									<colgroup>
										<col class="width-15per" />
										<col class="" />
									</colgroup>
									<tbody>
										<c:if test="${bbsVO.bbsTycd == 'QNA' || bbsVO.bbsTycd == 'NTC' && bbsVO.bbsRefTycd == 'SBJCT'}">
											<tr>
		                                        <th><label for="univ_label" class="req">운영과목</label></th>
		                                        <td>
		                                            <div class="form-inline">
		                                                <!-- DEBUG: orgId=[<c:out value="${bbsAtclVO.orgId}" />] sbjctId=[<c:out value="${bbsAtclVO.sbjctId}" />] -->
		                                                <select class="form-select" id="srchOrg" name="searchOrgId">
					                                        <option value=""><spring:message code="cls.label.org"/><%-- 기관 --%></option>
					                                        <c:forEach var="item" items="${orgList}">
					                                            <option value="${item.orgId}" <c:if test="${bbsAtclVO.orgId == item.orgId}">selected</c:if>>
					                                                    ${item.orgnm}
					                                            </option>
					                                        </c:forEach>
					                                    </select>

														<select class="form-select" id="srchSbjt" name="sbjctId">
					                                        <option value=""><spring:message code="cls.label.operating.subject"/><%-- 운영과목 --%></option>
					                                        <c:forEach var="item" items="${subjectList}">
					                                            <option value="${item.sbjctId}"
					                                                    <c:if test="${bbsAtclVO.sbjctId == item.sbjctId}">selected</c:if>>
					                                                    ${item.sbjctnm}
					                                                        <c:if test="${not empty item.dvclasNo}"> (${item.dvclasNo}<spring:message code="cls.label.decls.name"/><%-- 반 --%>)</c:if>
					                                                <c:if test="${not empty item.crclmnNo}"> [${item.crclmnNo}]</c:if>
					                                            </option>
					                                        </c:forEach>
					                                    </select>
		                                            </div>
		                                        </td>
		                                    </tr>
										</c:if>
										<c:if test="${bbsVO.bbsTycd == 'NTC' && bbsVO.bbsRefTycd == 'SBJCT'}">
		                                    <tr>
		                                        <th><label for="haksa_label" class="req"><spring:message code="bbs.label.form_main_option"/></label></th>
		                                        <td>
		                                            <div class="form-inline">
		                                                <span class="custom-input"><input type="radio" name="optnCd" id="optnCdN" value="NOT_APPLY" <c:if test="${empty bbsAtclVO.optnCd || bbsAtclVO.optnCd == 'NOT_APPLY'}">checked</c:if>><label for="optnCdN"><spring:message code="bbs.label.na"/></label></span>
		                                                <span class="custom-input ml5"><input type="radio" name="optnCd" id="optnCdI" value="IMPT" <c:if test="${bbsAtclVO.optnCd == 'IMPT'}">checked</c:if>><label for="optnCdI"><spring:message code="bbs.label.impt"/></label></span>
		                                                <span class="custom-input ml5"><input type="radio" name="optnCd" id="optnCdF" value="FIX" <c:if test="${bbsAtclVO.optnCd == 'FIX'}">checked</c:if>><label for="optnCdF"><spring:message code="bbs.label.fix"/></label></span>
		                                                <%-- 날짜/시간은 optnSdttm, optnEdttm(합쳐진 datetime)에서 JS로 분리되어 세팅됨 (initEditModeValues 참고) --%>
		                                                <input type="text" placeholder="시작일" id="optnStartDate" name="optnStartDate" class="datepicker">
		                                                <input type="text" placeholder="시작시간" id="optnStartTime" name="optnStartTime" class="timepicker">
		                                                <span class="txt-sort">~</span>
		                                                <input type="text" placeholder="종료일" id="optnEndDate" name="optnEndDate" class="datepicker">
		                                                <input type="text" placeholder="종료시간" id="optnEndTime" name="optnEndTime" class="timepicker">
		                                            </div>
		                                        </td>
		                                    </tr>
										</c:if>
										<tr>
											<th><label for="atclTtl" class="req"><spring:message code="bbs.label.form_title" /></label><%-- 제목 --%></th>
											<td>
												<div class="form-row">
													<input type="text" id="atclTtl" name="atclTtl" autocomplete="off" required="true" class="form-control width-100per" inputmask="byte" maxLen="200" value="${bbsAtclVO.atclTtl}" />
												</div>
											</td>
										</tr>
										<tr>
											<td data-th="입력" colspan="2">
												<div class="editor-box">
													<label for="atclCts" class="hide">Content</label>
													<textarea id="atclCts" name="atclCts" required="true"><c:out value="${bbsAtclVO.atclCts}"/></textarea>
													<script>
														// HTML 에디터
														let editor = UiEditor({
															targetId: "atclCts",
															uploadPath: "${bbsVO.uploadPath}",
															height: "500px"
														});
													</script>
												</div>
											</td>
										</tr>
										<c:if test="${bbsVO.bbsTycd == 'NTC' && bbsVO.bbsRefTycd == 'SBJCT'}">
											<tr>
	                                            <th><label class="req"><spring:message code="bbs.label.form_decls"/></label></th>
	                                            <td>
	                                                <div class="checkbox_type">
	                                                    <c:set var="dvclasNoList" value=",${bbsAtclVO.dvclasNo},"/>
	                                                    <span class="custom-input"><input type="checkbox" name="dvclasNo" id="dvclasNoA" value="Y" required="true" <c:if test="${fn:contains(dvclasNoList, ',Y,')}">checked</c:if>><label for="dvclasNoA">전체</label></span>
	                                                    <c:forEach var="i" begin="1" end="4">
															<c:set var="dvclasNoToken" value=",${i},"/>
	                                                        <span class="custom-input"><input type="checkbox" name="dvclasNo" id="dvclasNo${i}" value="${i}" required="true" <c:if test="${fn:contains(dvclasNoList, dvclasNoToken)}">checked</c:if>><label for="dvclasNo${i}">${i}반</label></span>
	                                                    </c:forEach>
	                                                </div>
	                                            </td>
	                                        </tr>
                                        </c:if>
										<tr>
											<th><label for="attchFile"><spring:message code="bbs.label.form_attach_file" /></label></th>
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
													uiMode="normal"
												/>
											</td>
										</tr>
										<c:if test="${bbsVO.bbsTycd == 'NTC' && bbsVO.bbsRefTycd == 'SBJCT'}">
											<tr>
	                                            <th><label><spring:message code="bbs.label.form_sub_option"/></label></th>
	                                            <td><div class="checkbox_type"><span class="custom-input"><input type="checkbox" name="cmntPrmyn" id="cmntPrmyn" value="Y" <c:if test="${empty bbsAtclVO.cmntPrmyn || bbsAtclVO.cmntPrmyn == 'Y'}">checked</c:if>><label for="cmntPrmyn">댓글 사용</label></span></div></td>
	                                        </tr>
	                                        <tr>
	                                            <th><label><spring:message code="bbs.label.form_write_resv"/></label></th>
	                                            <td>
	                                                <div class="date_area">
	                                                    <input type="checkbox" id="rsrvyn" name="rsrvyn" class="switch yesno" value="Y" <c:if test="${bbsAtclVO.rsrvyn == 'Y'}">checked</c:if>>
	                                                    <input type="text" placeholder="시작일" id="rsrvStartDate" name="rsrvStartDate" class="datepicker">
	                                                    <input type="text" placeholder="시작시간" id="rsrvStartTime" name="rsrvStartTime" class="timepicker">
	                                                    <span class="txt-sort">~</span>
	                                                    <input type="text" placeholder="종료일" id="rsrvEndDate" name="rsrvEndDate" class="datepicker">
	                                                    <input type="text" placeholder="종료시간" id="rsrvEndTime" name="rsrvEndTime" class="timepicker">
	                                                </div>
	                                            </td>
	                                        </tr>
	                                        <tr>
	                                            <th><label><spring:message code="bbs.label.form_public_yn"/></label></th>
	                                            <td><div class="form-row"><input type="checkbox" id="oyn" name="oyn" class="switch yesno" value="Y" <c:if test="${empty bbsAtclVO.oyn || bbsAtclVO.oyn == 'Y'}">checked</c:if>></div></td>
	                                        </tr>
	                                        <tr>
	                                            <th><label>공지사항 구분</label></th>
	                                            <td>
	                                                <div class="form-inline">
	                                                    <span class="custom-input"><input type="radio" name="ntcGbncd" id="ntcGbncdY" value="Y" <c:if test="${empty bbsAtclVO.ntcGbncd || bbsAtclVO.ntcGbncd == 'Y'}">checked</c:if>><label for="ntcGbncdY">일반 공지</label></span>
	                                                    <span class="custom-input ml5"><input type="radio" name="ntcGbncd" id="ntcGbncdN" value="N" <c:if test="${bbsAtclVO.ntcGbncd == 'N'}">checked</c:if>><label for="ntcGbncdN">긴급 공지</label></span>
	                                                </div>
	                                            </td>
	                                        </tr>
	                                        <tr>
	                                            <th><label><spring:message code="bbs.label.form_auto_alim"/></label></th>
	                                            <td>
	                                                <div class="date_area">
	                                                    <input type="checkbox" id="autoAlimyn" name="autoAlimyn" class="switch yesno" value="Y" <c:if test="${bbsAtclVO.autoAlimyn == 'Y'}">checked</c:if>>
	                                                    <input type="text" placeholder="시작일" id="autoAlimStartDate" name="autoAlimStartDate" class="datepicker">
	                                                    <input type="text" placeholder="시작시간" id="autoAlimStartTime" name="autoAlimStartTime" class="timepicker">
	                                                    <span class="txt-sort">~</span>
	                                                    <input type="text" placeholder="종료일" id="autoAlimEndDate" name="autoAlimEndDate" class="datepicker">
	                                                    <input type="text" placeholder="종료시간" id="autoAlimEndTime" name="autoAlimEndTime" class="timepicker">
	                                                </div>
	                                            </td>
	                                        </tr>
                                        </c:if>
									</tbody>
								</table>
							</form>
						</div>
						<div class="btns">
                            <button type="button" class="btn type1" onclick="saveConfirm()"><spring:message code="common.button.save" /></button><%-- 저장 --%>
                            <button type="button" class="btn type2" onclick="moveListPage()"><spring:message code="common.button.cancel" /></button><%-- 취소 --%>
                        </div>
                    </div>
                </div>
            </div>
            <!-- //content -->

            <!-- common footer -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_footer.jsp"/>
            <!-- //common footer -->
        </main>
        <!-- //dashboard-->
    </div>
</body>
</html>
