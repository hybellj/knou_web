<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
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
		var ATCL_ID 		= '<c:out value="${bbsAtclVO.atclId}" />';

    	// 저장 버튼
    	function saveConfirm() {
			// 입력필드 검증
    		UiValidator("atclWriteForm")
    		.then(function(result) {
				if (result) {
					let dx = dx5.get("fileUploader");
					// 첨부파일 있으면 업로드
		    		if (dx.availUpload()) {
		    			dx.startUpload();
		    		}
					// 첨부파일 없으면 저장 호출
		    		else {
		    			atclSave();
		    		}
				}
			});
    	}

    	// 파일 업로드 완료
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

	</script>
</head>

<body class="home colorA ${bodyClass}"  style=""><!-- 컬러선택시 클래스변경 -->
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
								<input type="hidden" name="encParams"    id="encParams"   value="${encParams}" />
								<input type="hidden" name="gubun"        id="gubun"       value="${bbsAtclVO.gubun}" />
								<input type="hidden" name="uploadFiles"  id="uploadFiles" value="" />
								<input type="hidden" name="uploadPath"   id="uploadPath"  value="${bbsVO.uploadPath}" />
								<input type="hidden" name="atclId"       id="atclId" value="${bbsAtclVO.atclId}"/>
								<input type="hidden" name="delFileIdStr" id="delFileIdStr"  value="" />

							<table class="table-type5">
								<colgroup>
									<col class="width-15per" />
									<col class="" />
								</colgroup>
								<tbody>
									<tr>
										<th><label for="atclTitle" class="req"><spring:message code="bbs.label.form_title" /></label><%-- 제목 --%></th>
										<td>
											<div class="form-row">
												<input type="text" id="atclTtl" name="atclTtl" autocomplete="off" required="true" class="form-control width-100per" inputmask="byte" maxLen="200" value="${bbsAtclVO.atclTtl}" />
											</div>
										</td>
									</tr>
									<tr>
										<td data-th="입력" colspan="2">
											<li>
												<dl>
													<dd>
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
													</dd>
												</dl>
											</li>

										</section>
										<!--//섹션 에디터-->
										</td>
									</tr>
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
												finishFunc="finishUpload()"
												allowedTypes="*"
											/>
										</td>
									</tr>
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