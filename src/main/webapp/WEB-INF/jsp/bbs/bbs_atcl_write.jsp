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
        // 게시글 목록 이동
        function moveAtclList() {
            document.location.href = "/bbs/${templateUrl}/bbsAtclListView.do?eparam=${eparam}";
        }

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
        function finishUpload() {
        	let url = "/common/uploadFileCheck.do";
        	let dx = dx5.get("fileUploader");
        	let data = {
        		"uploadFiles" : dx.getUploadFiles(),
        		"uploadPath"  : dx.getUploadPath()
        	};

        	// 업로드된 파일 체크
        	ajaxCall(url, data, function(data) {
        		if(data.result > 0) {
        			$("#uploadFiles").val(dx.getUploadFiles());
        	    	$("#uploadPath").val(dx.getUploadPath());

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
    		let url = "/bbs/${templateUrl}/bbsAtclSave.do";
    		let returnUrl = "/bbs/${templateUrl}/bbsAtclListView.do?eparam=${eparam}";
    		let data = $("#atclWriteForm").serialize();

    		ajaxCall(url, data, function(data) {
            	if(data.result > 0) {
					UiComm.showMessage(data.message, "success")
					.then(function(result) {
						document.location.href = returnUrl;
					});
                } else {
                	UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error"); // 에러 메세지
                }
    		},
    		function(xhr, status, error) {
    			UiComm.showMessage("<spring:message code='fail.common.msg'/>","error"); // 에러가 발생했습니다!
    		}, true);
    	}


    	// 글쓰기 취소
    	function cancelWrite() {
    		document.location.href = "/bbs/${templateUrl}/bbsAtclListView.do?eparam=${eparam}";
    	}

	</script>
</head>

<body class="home colorA "  style=""><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/home_header.jsp"/>
        <!-- //common header -->

        <!-- dashboard -->
        <main class="common">

            <!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_gnb_prof.jsp"/>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="dashboard_sub">

                    <!-- page_tab -->
                    <jsp:include page="/WEB-INF/jsp/common_new/home_page_tab.jsp"/>
                    <!-- //page_tab -->

                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">${bbsVO.bbsNm}</h2>
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
							<form id="atclWriteForm" name="atclWriteForm">
								<input type="hidden" name="eparam"       id="eparam"      value="${eparam}" />
								<input type="hidden" name="uploadFiles"  id="uploadFiles" value="" />
								<input type="hidden" name="uploadPath"   id="uploadPath"  value="" />
								<input type="hidden" name="delFileIdStr" value=""/>

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
																	uploadPath: "/bbs/${bbsVO.bbsId}",
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
										<th><label for="attchFile">첨부파일</label></th>
										<td>
											<uiex:dextuploader
												id="fileUploader"
												path="/bbs/${bbsVO.bbsId}"
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
                            <button type="button" class="btn type2" onclick="cancelWrite()"><spring:message code="common.button.cancel" /></button><%-- 취소 --%>
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