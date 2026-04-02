<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">

<style>
    /* 에디터 박스보다 위에 오도록 설정 */
    .editor-box {
        position: relative;
        z-index: 1; /* 에디터는 낮게 */
    }
</style>

<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="module" value="editor,fileuploader"/>
		<jsp:param name="style" value="${
			templateUrl eq 'bbsHome' ? 'dashboard'
			: templateUrl eq 'bbsLect' ? 'classroom'
			: templateUrl eq 'bbsMgr' ? 'admin' : ''}"/>
	</jsp:include>

	<!-- 게시판 공통 -->
	<jsp:include page="/WEB-INF/jsp/bbs/common/bbs_common_inc.jsp"/>

	<script type="text/javascript">
		var BBS_ID 		 = '<c:out value="${bbsVO.bbsId}" />';
		var TEMPLATE_URL = '<c:out value="${templateUrl}" />';
		var MODE         = '<c:out value="${bbsVO.gubun == 'edit' ? 'U' : 'C'}" />';

		$(document).ready(function() {
			if(MODE == 'U') {
                bbsAtclModifyForm();
            }
		});

    	// 게시글 저장
    	function atclSave() {
    		var url = "/bbs/" + TEMPLATE_URL + "/bbsMngInfoRegist.do";
    		var returnUrl = "/bbs/" + TEMPLATE_URL + "/bbsMngListView.do?encParams=${encParams}";
    		var data = $("#atclWriteForm").serialize();

    		bbsCommon.regist(url, returnUrl, data);
    	}

    	// 목록화면 이동
    	function moveListPage() {
    		document.location.href = "/bbs/" + TEMPLATE_URL + "/bbsMngListView.do?encParams=${encParams}";
    	}

    	function bbsAtclModifyForm() {
            var url  = "/bbs/" + TEMPLATE_URL + "/bbsAtclDtlView.do";
            var data = { bbsId : BBS_ID, atclId : ATCL_ID };

            ajaxCall(url, data, function(data) {
                if(data.result > 0 && data.returnVO) {
                    var vo = data.returnVO;

                    // 주요 옵션
                    if(vo.optnCd === 'IMPT') {
						$("#optnCdI").prop("checked", true);
					} else if(vo.optnCd === 'FIX') {
						$("#optnCdF").prop("checked", true);
					} else {
						$("#optnCdN").prop("checked", true);
					}

					// 주요 옵션 일자
                    setSplitDateTime(vo.optnSdttm, 'optnStartDate', 'optnStartTime');
                    setSplitDateTime(vo.optnEdttm, 'optnEndDate', 'optnEndTime');

                    // 제목
                    $("#atclTtl").val(vo.atclTtl);

                    // 내용
                    editor.openHTML(vo.atclCts);

                    if(vo.fileList && vo.fileList.length > 0) {
                        setTimeout(function(){
                            var dx = dx5.get("fileUploader");
                            dx.addCopyFiles(vo.fileList);
                        }, 500);
                    }

					// 분반 일괄등록
					var i = vo.dvclasNo;
					$("#dvclasNo"+i).prop("checked", true);

					// 부가옵션 - 댓글 사용
                    if(vo.cmntPrmyn === "Y") {
						$("#cmntPrmyn").prop("checked", true);
                    }

					// 등록 예약
                    if(vo.rsrvyn === "Y") {
					    $("#rsrvyn").prop("checked", true);
					    $("#sw_rsrvyn").attr("aria-checked", "true").addClass("ui-switcher-on");
					}

					// 등록 예약 일자
                    setSplitDateTime(vo.rsrvSdttm, 'rsrvStartDate', 'rsrvStartTime');
                    setSplitDateTime(vo.rsrvEdttm, 'rsrvEndDate', 'rsrvEndTime');

                    // 공개여부
                    if(vo.oyn === "Y") {
						$("#oyn").prop("checked", true);
						$("#sw_oyn").attr("aria-checked", "true").trigger("change");
					}

                    // 공지사항 구분
                    if(vo.ntcGbncd === "Y") {
						$("#ntcGbncdY").prop("checked", true);
                    } else {
                    	$("#ntcGbncdN").prop("checked", true);
                    }

                    // 자동 알림 예약 등록
                    if(vo.autoAlimyn === "Y") {
						$("#autoAlimyn").prop("checked", true);
						$("#sw_autoAlimyn").attr("aria-checked", "true").trigger("change");
					}

                    // 자동 알림 예약 등록 일자
                    setSplitDateTime(vo.autoAlimSdttm, 'autoAlimStartDate', 'autoAlimStartTime');
                    setSplitDateTime(vo.autoAlimEdttm, 'autoAlimEndDate', 'autoAlimEndTime');
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

<body class="class colorA "  style=""><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>
        <!-- //common header -->

        <!-- dashboard -->
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
								<option value="2026년 1학기">2026년 1학기</option>
								<option value="2026년 2학기">2026년 2학기</option>
							</select>
							<select class="form-select wide">
								<option value="">강의실 바로가기</option>
								<option value="2026년 1학기">2026년 1학기</option>
								<option value="2026년 2학기">2026년 2학기</option>
							</select>
						</div>
						<div class="sec">
							<button type="button" class="btn type1"><i class="xi-book-o"></i>교수 매뉴얼</button>
							<button type="button" class="btn type1"><i class="xi-info-o"></i>학습안내정보</button>
						</div>
					</div>
				</div>

				<div class="class_sub">

                <div class="dashboard_sub">

                    <div class="sub-content">
                        <div class="page-info">
                            <h4 class="sub-title">게시판 추가</h4>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>공통</li>
                                    <li><span class="current">레이아웃</span></li>
                                </ul>
                            </div>
                        </div>

                        <!--table-type-->
						<div class="table-wrap">
							<form id="atclWriteForm" name="atclWriteForm" onsubmit="return false;">
								<input type="hidden" name="encParams"    id="encParams"    value="${encParams}" />
								<input type="hidden" name="userId"       id="userId"       value="${bbsVO.userId}" />

							<table class="table-type5">
								<colgroup>
									<col class="width-15per" />
									<col class="" />
								</colgroup>
								<tbody>
									<tr>
										<th><label for="bbsnm" class="req">게시판명</label><%-- 제목 --%></th>
										<td>
											<div class="form-row">
												<input type="text" id="bbsnm" name="bbsnm" autocomplete="off" required="true" class="form-control width-100per" inputmask="byte" maxLen="200" value="${bbsVO.bbsNm}" />
											</div>
										</td>
									</tr>
									<tr>
                                        <th><label>게시판 종류</label></th>
                                        <td>
                                            <div class="form-inline">
                                                <span class="custom-input"><input type="radio" name="bbsTycd" id="bbsTycdA" value="FREE" checked><label for="bbsTycdA">자유게시판</label></span>
                                                <span class="custom-input ml5"><input type="radio" name="bbsTycd" id="bbsTycdB" value="ALBUM"><label for="bbsTycdB">이미지게시판</label></span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label>게시판 유형</label></th>
                                        <td>
                                            <div class="checkbox_type">
                                                <span class="custom-input"><input type="checkbox" name="optnCd" id="optnCdA" value="NTC" required="true"><label for="optnCdA">공지</label></span>
                                                <span class="custom-input"><input type="checkbox" name="optnCd" id="optnCdB" value="RSPNS" required="true"><label for="optnCdB">답변</label></span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label>첨부파일 사용</label></th>
                                        <td>
                                            <div class="form-inline">
                                                <span class="custom-input"><input type="radio" name="atflUseyn" id="atflUseynY" value="Y" checked><label for="atflUseynY">예</label></span>
                                                <span class="custom-input ml5"><input type="radio" name="atflUseyn" id="atflUseynN" value="N"><label for="atflUseynN">아니오</label></span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
										<th><label for="atflCnt" class="req">첨부파일 개수</label></th>
										<td>
											<div class="form-row">
												<select class="form-select" id="atflCnt">
	                                            	<option value="">0개</option>
        											<option value="1">1개</option>
        											<option value="2">2개</option>
        											<option value="3">3개</option>
        											<option value="4">4개</option>
        											<option value="5">5개</option>
	                                            </select>
											</div>
										</td>
									</tr>
                                    <tr>
										<th><label for="atflMaxsz" class="req">첨부파일 용량</label></th>
										<td>
											<div class="form-row">
												<input type="text" id="atflMaxsz" name="atflMaxsz" autocomplete="off" required="true" class="form-control width-100per" inputmask="byte" maxLen="200" value="${bbsVO.atflMaxsz}" />
											</div>
										</td>
									</tr>
									<tr>
                                        <th><label>글쓰기 사용여부</label></th>
                                        <td>
                                            <div class="form-inline">
                                                <span class="custom-input"><input type="radio" name="writeUseyn" id="writeUseynY" value="Y" checked><label for="writeUseynY">예</label></span>
                                                <span class="custom-input ml5"><input type="radio" name="writeUseyn" id="writeUseynN" value="N"><label for="writeUseynN">아니오</label></span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label>게시판 사용여부</label></th>
                                        <td>
                                            <div class="form-inline">
                                                <span class="custom-input"><input type="radio" name="bbsUseyn" id="bbsUseynY" value="Y" checked><label for="bbsUseynY">예</label></span>
                                                <span class="custom-input ml5"><input type="radio" name="bbsUseyn" id="bbsUseynN" value="N"><label for="bbsUseynN">아니오</label></span>
                                            </div>
                                        </td>
                                    </tr>
								</tbody>
							</table>
							</form>
						</div>

						<div class="btns">
                            <button type="button" class="btn type1" onclick="atclSave()"><spring:message code="common.button.save" /></button><%-- 저장 --%>
                            <button type="button" class="btn type2" onclick="moveListPage()"><spring:message code="common.button.cancel" /></button><%-- 취소 --%>
                        </div>
                    </div>

                </div>
                </div>
            </div>
            <!-- //content -->
        </main>
        <!-- //dashboard-->

    </div>


</body>
</html>