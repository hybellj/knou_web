<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
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
			// 첨부파일 개수 초기값 복원(수정 모드)
			if(MODE == 'U') {
				$("#atflMaxCnt").val('<c:out value="${bbsVO.atflMaxCnt}" />');
			}
		});

		// 게시판 저장
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
	</script>
</head>

<body class="class ${uiex:getTheme()} "><!-- 컬러선택시 클래스변경 -->
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
				<!-- class_sub_top -->
				<jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>
				<!-- //class_sub_top -->

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
									<input type="hidden" name="encParams" id="encParams" value="${encParams}" />
									<input type="hidden" name="userId"    id="userId"    value="${bbsVO.userId}" />
									<input type="hidden" name="bbsId"     id="bbsId"     value="${bbsVO.bbsId}" />
									<input type="hidden" name="gubun"     id="gubun"     value="${bbsVO.gubun}" />

								<table class="table-type5">
									<colgroup>
										<col class="width-15per" />
										<col class="" />
									</colgroup>
									<tbody>
										<tr>
											<th><label for="bbsnm" class="req">게시판명</label></th>
											<td>
												<div class="form-row">
													<input type="text" id="bbsnm" name="bbsnm" autocomplete="off" required="true" class="form-control width-100per" inputmask="byte" maxLen="200" value="${bbsVO.bbsNm}" />
												</div>
											</td>
										</tr>
										<tr>
	                                        <th><label for="bbsTycdA">게시판 종류</label></th>
	                                        <td>
	                                            <div class="form-inline">
	                                                <span class="custom-input"><input type="radio" name="bbsTycd" id="bbsTycdA" value="FREE" ${empty bbsVO.bbsTycd or bbsVO.bbsTycd eq 'FREE' ? 'checked' : '' }><label for="bbsTycdA">자유게시판</label></span>
	                                                <span class="custom-input ml5"><input type="radio" name="bbsTycd" id="bbsTycdB" value="ALBUM" ${bbsVO.bbsTycd eq 'ALBUM' ? 'checked' : '' }><label for="bbsTycdB">이미지게시판</label></span>
	                                            </div>
	                                        </td>
	                                    </tr>
	                                    <tr>
	                                        <th><label for="optnCdA">게시판 유형</label></th>
	                                        <td>
	                                            <div class="checkbox_type">
	                                                <span class="custom-input"><input type="checkbox" name="optnCd" id="optnCdA" value="NTC" ${bbsVO.optnCdNtc eq 'Y' ? 'checked' : ''}><label for="optnCdA">공지</label></span>
	                                                <span class="custom-input"><input type="checkbox" name="optnCd" id="optnCdB" value="RSPNS" ${bbsVO.optnCdRspns eq 'Y' ? 'checked' : ''}><label for="optnCdB">답변</label></span>
	                                            </div>
	                                        </td>
	                                    </tr>
	                                    <tr>
	                                        <th><label for="atflUseynY">첨부파일 사용</label></th>
	                                        <td>
	                                            <div class="form-inline">
	                                                <span class="custom-input"><input type="radio" name="atflUseyn" id="atflUseynY" value="Y" ${empty bbsVO.atflUseyn or bbsVO.atflUseyn eq 'Y' ? 'checked' : '' }><label for="atflUseynY">예</label></span>
	                                                <span class="custom-input ml5"><input type="radio" name="atflUseyn" id="atflUseynN" value="N" ${bbsVO.atflUseyn eq 'N' ? 'checked' : '' }><label for="atflUseynN">아니오</label></span>
	                                            </div>
	                                        </td>
	                                    </tr>
	                                    <tr>
											<th><label for="atflMaxCnt" class="req">첨부파일 개수</label></th>
											<td>
												<div class="form-row">
													<select class="form-select" id="atflMaxCnt" name="atflMaxCnt">
		                                            	<option value="0">0개</option>
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
	                                        <th><label for="bbsWriteUseynY">글쓰기 사용여부</label></th>
	                                        <td>
	                                            <div class="form-inline">
	                                                <span class="custom-input"><input type="radio" name="bbsWriteUseyn" id="bbsWriteUseynY" value="Y" ${empty bbsVO.bbsWriteUseyn or bbsVO.bbsWriteUseyn eq 'Y' ? 'checked' : '' }><label for="bbsWriteUseynY">예</label></span>
	                                                <span class="custom-input ml5"><input type="radio" name="bbsWriteUseyn" id="bbsWriteUseynN" value="N" ${bbsVO.bbsWriteUseyn eq 'N' ? 'checked' : '' }><label for="bbsWriteUseynN">아니오</label></span>
	                                            </div>
	                                        </td>
	                                    </tr>
	                                    <tr>
	                                        <th><label for="useynY">게시판 사용여부</label></th>
	                                        <td>
	                                            <div class="form-inline">
	                                                <span class="custom-input"><input type="radio" name="useyn" id="useynY" value="Y" ${empty bbsVO.useyn or bbsVO.useyn eq 'Y' ? 'checked' : '' }><label for="useynY">예</label></span>
	                                                <span class="custom-input ml5"><input type="radio" name="useyn" id="useynN" value="N" ${bbsVO.useyn eq 'N' ? 'checked' : '' }><label for="useynN">아니오</label></span>
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
