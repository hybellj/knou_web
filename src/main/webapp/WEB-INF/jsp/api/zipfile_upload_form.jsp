<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="width: 100%;">
<head>
	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp"%>
	
   	<script type="text/javascript">
	   	$(document).ready(function() {
	   		$("#pageNoUp").val("${p_seq}").prop("selected", true);
	   		$("#pageNoDown").val("${p_seq}").prop("selected", true);
	   		
	   		$("#uploadPath").focusout(function() {
	   			var dx = dx5.get("upload1");
				dx.setUploadPath($("#uploadPath").val());
				
				var exFileForm = $("form[formtype=upfile]");
				if (exFileForm.length > 0) {
					var act = exFileForm.attr("action");
					var url = act.substr(act.indexOf("&path=")+6);
					url = url.substr(0, url.indexOf("&fileId="));
					act = act.replace(url, $("#uploadPath").val());
					exFileForm.attr("action", act);
				}
	   		});
	   		
	   		hideLoading();
		});
	   	
		var pathEditChk = false;
		var uploadPathOri = "";
	   	
	   	function saveConfirm() {
	   		var dx = dx5.get("upload1");
	   		var page = $("#pageNoUp option:selected").val();
	   		
	   		if (page == "0") {
	   			alert("페이지를 선택하세요.");
	   			return;
	   		}
	   		
	   		// 파일이 있으면 업로드 시작
     		if (dx.availUpload()) {
     			$("#regBtn").attr("disabled", "disabled");
     			$("#pageNoUp").attr("disabled", "disabled");
     			$("#uploadPath").attr("disabled", "disabled");
     			$("#checkPathEdit").attr("disabled", "disabled");
     			
				dx.startUpload();
			}
			else {
				alert("ZIP파일을 선택하세요.");
			}
	   	}
	   	
		// 파일 업로드 완료
	    function finishUpload() {
	    	document.domain="hycu.ac.kr";
	    	
	    	var uploadResult = {}; 
	    	uploadResult.page = parseInt($("#pageNoUp").val());
	    	uploadResult.path = $("#uploadPath").val();
	    	uploadResult.etc = "";
	    	
	    	$.ajax({
    			url : "/api/zipContentUploadCheck.do",
    			data: {uploadPath : $("#uploadPath").val()},
    			type: "POST",
    			dataType : "json",
    			success : function(data, status, xr){
    				if (data.result == "1") {
    					alert("업로드가 완료되었습니다.");
    				}
    				else {
    					alert("업로드를 실패하였습니다.");
    				}
    				
    				uploadResult.out_num = data.result;
    				opener.postMessage({message:"zipfileUpload", result:uploadResult}, "*");
    			},
    			error : function(xhr, status, error){
    				alert("에러가 발생하였습니다.");
    				uploadResult.out_num = "-1";
    				opener.postMessage({message:"zipfileUpload", result:uploadResult}, "*");
    			}
    		});
	    }

		// 페이지 변경
		function changePage(type) {
			var dx = dx5.get("upload1");
			var basePath = "${basePath}";
			var page = null;
			
			if (type == "up") {
				page = $("#pageNoUp option:selected").val();
			}
			else {
				page = $("#pageNoDown option:selected").val();
			}
			
			if (page == "0") {
				page = "";
			}
			else { 
				page = (page.length < 2 ? "0"+page : page) + "/";
			}
			
			if (type == "up") {
				var uploadPath = "${basePath}" + page;
				$("#uploadPath").val(uploadPath);
				dx.setUploadPath(uploadPath);
				uploadPathOri = uploadPath;
	
				var exFileForm = $("form[formtype=upfile]");
				if (exFileForm.length > 0) {
					var act = exFileForm.attr("action");
					var url = act.substr(act.indexOf("&path=")+6);
					url = url.substr(0, url.indexOf("&fileId="));
					act = act.replace(url, uploadPath);
					exFileForm.attr("action", act);
				}
			}
			else {
				var downloadPath = "${basePath}" + page;
				$("#downloadPath").val(downloadPath);
			}
		}
		
		// 경로 수정
		function changePathEdit(type){
			var chk = $("#checkPathEdit").is(":checked");

			if (pathEditChk == true) {
				$("#uploadPath").prop("readonly", true);
				$("#uploadPath").val(uploadPathOri);
				
				pathEditChk = false;
			}
			else {
				$("#uploadPath").prop("readonly", false);
				uploadPathOri = $("#uploadPath").val();
				pathEditChk = true;
			}
		}
		
		// 탭 변경
		function moveTab(type) {
			if (type == "up") {
				$("#uploadTab").show();
				$("#downloadTab").hide();
			}
			else {
				$("#uploadTab").hide();
				$("#downloadTab").show();
			}
		}
		
		// 다운로드
		function downloadConfirm() {
			document.domain="hycu.ac.kr";
	    	
	    	$.ajax({
    			url : "/api/zipContentDownloadCheck.do",
    			data: {downloadPath : $("#downloadPath").val()},
    			type: "POST",
    			dataType : "json",
    			success : function(data, status, xr){
    				if (data.result == "-1") {
    					alert("파일을 다운로드 할 수 없습니다.\n지정된 경로가 없습니다.");
    				}
    				else {
    					var form = $("<form></form>");
    					form.attr("method", "POST");
    					form.attr("name", "zipDownForm");
    					form.attr("action", "/api/zipContentDownload.do");
    					form.append($('<input/>', {type : 'hidden', name : 'downloadPath', 	value : $("#downloadPath").val()}));
    					form.appendTo("body");
    					form.submit();

    					$("form[name=zipDownForm]").remove();
    				}
    			},
    			error : function(xhr, status, error){
    				alert("에러가 발생하였습니다.");
    				uploadResult.out_num = "-1";
    				opener.postMessage({message:"zipfileUpload", result:uploadResult}, "*");
    			}
    		});
		}
		
   	</script>
   	
   	<style>
		@media (max-width: 1024px) {
		    .listTab {
		        font-size: 16px;
		    }
		}
		@media (max-width: 1280px) {
		    .listTab1 {
		        box-shadow: none;
		        font-size: 17px;
		    }
		}
		
		.listTab {
		    position: relative;
		    box-shadow: inset 0px -1px 0px 0px var(--dark1-alpha50);
		    font-size: 18px;
		}
   	</style>
</head>
<body class="p20" style="overflow:auto; ">
	<form id="zipUploadForm" name="zipUploadForm" method="post" action="/api/zipContentUpload.do" enctype="multipart/form-data">
	
	<div id="wrap">
		<div class="p10 fcWhite bcBlue f120 tc mb10">
			콘텐츠 ZIP파일 업로드/다운로드
		</div>

		<div class="listTab mb10" style="padding-bottom:2px">
			<ul>			
				<li class="mw120 <c:if test="${type eq 'upload'}">select</c:if>" onclick="moveTab('up')">
					<a href="javascript:void(0)">
			       		콘텐츠 업로드
					</a>
				</li>			
				<li class="mw120 <c:if test="${type eq 'download'}">select</c:if>" onclick="moveTab('down')">
					<a href="javascript:void(0)">
			       		콘텐츠 다운로드
					</a>
				</li>			
			</ul>
		</div>

		<c:if test="${basePath != ''}">
			<div id="uploadTab" style="display:<c:if test="${type eq 'download'}">none</c:if>">
		        <div class="ui info message">
		        	<div>
		        		ZIP파일을 업로드합니다.
		        	</div>
		        	<div class="mt5">
		        		<span class="fcGrey">
							<small>
								[파일선택]을 클릭하여 올리고자 하는 파일을 선택하세요.<br>
		            			업로드는 폴더를 압축한 zip파일만 가능합니다.(파일 압축 zip 업로드 불가)<br>
		            			zip에 포함된 파일명이 한글일 경우 압축이 제대로 풀리지 않을 수 있음.
		           			</small>
						</span>
		        	</div>
		        </div>
		        
		        <div class="ui segment">
					<ul class="tbl">
						<li>
							<dl>
								<dt>
									<label>업로드 페이지</label>
								</dt>
								<dd>
									<div class="ui fluid input">
										<select id="pageNoUp" onchange="changePage('up')">
											<option value="0">:: 페이지 선택 ::</option>
											<option value="01">1</option>
											<option value="02">2</option>
											<option value="03">3</option>
											<option value="04">4</option>
											<option value="05">5</option>
											<option value="06">6</option>
											<option value="07">7</option>
											<option value="08">8</option>
											<option value="09">9</option>
											<option value="10">10</option>
											<option value="11">11</option>
											<option value="12">12</option>
											<option value="13">13</option>
											<option value="14">14</option>
											<option value="15">15</option>
										</select>
									</div>
								</dd>
							</dl>
						</li>
						<li>
							<dl>
								<dt>
									<label>업로드 경로</label>
								</dt>
								<dd>
									<div class="fields">
		                                <div class="field">
		                                    <div class="ui checkbox" onclick="changePathEdit()">
		                                    	<input id="checkPathEdit" type="checkbox">
		                                    	<label for="checkPathEdit">수정</label>
		                                    </div>
		                                </div>
		                                <div class="field mt10">
		                                	<div class="ui fluid input">
		                                		<input type="text" id="uploadPath" name="uploadPath" value="${uploadPath}" readonly="readonly">
		                                	</div>
		                                	
		                                	<div class="mt10">
		                                		<div class="fcGrey">
		                                		* 기본값을 수정시 해당 경로가 존재하는지 확인 후 업로드해주세요.
		                                		</div>
		                                	</div>
		                                </div>
		                            </div>
								</dd>
							</dl>
						</li>
					</ul>
		
					<div id="uploaderBox" class="mt10">
						<uiex:dextuploader
							id="upload1"
							url="/dext/zipContentUploadDext.up?pId=${userId}"
							path="/${uploadPath}"
							limitCount="1"
							limitSize="2048"
							oneLimitSize="2048"
							listSize="1"
							finishFunc="finishUpload()"
							allowedTypes="zip"
							bigSize="false"
							type="ZIP"
						/>
					</div>
				</div>
				
				<div class="bottom-content">
					<button id="regBtn" class="ui blue button" type="button" onclick="saveConfirm();">등록</button>
				</div>
			</div>
			
			
			<div id="downloadTab" style="display:<c:if test="${type eq 'upload'}">none</c:if>">
		        <div class="ui info message">
		        	<div>
		        		콘텐츠를 다운로드합니다.
		        	</div>
		        	<div class="mt5">
		        		<span class="fcGrey">
							<small>
								선택한 경로에 있는 콘텐츠 파일을 ZIP으로 다운로드합니다.
		           			</small>
						</span>
		        	</div>
		        </div>
		        
		        <div class="ui segment">
					<ul class="tbl">
						<li>
							<dl>
								<dt>
									<label>다운로드 페이지</label>
								</dt>
								<dd>
									<div class="ui fluid input">
										<select id="pageNoDown" onchange="changePage('down')">
											<option value="0">:: 페이지 선택 ::</option>
											<option value="01">1</option>
											<option value="02">2</option>
											<option value="03">3</option>
											<option value="04">4</option>
											<option value="05">5</option>
											<option value="06">6</option>
											<option value="07">7</option>
											<option value="08">8</option>
											<option value="09">9</option>
											<option value="10">10</option>
											<option value="11">11</option>
											<option value="12">12</option>
											<option value="13">13</option>
											<option value="14">14</option>
											<option value="15">15</option>
										</select>
									</div>
								</dd>
							</dl>
						</li>
						<li>
							<dl>
								<dt>
									<label>다운로드 경로</label>
								</dt>
								<dd>
									<div class="fields">
		                                <div class="field mt10">
		                                	<div class="ui fluid input">
		                                		<input type="text" id="downloadPath" name="downloadPath" value="${uploadPath}" readonly="readonly">
		                                	</div>
		                                </div>
		                            </div>
								</dd>
							</dl>
						</li>
					</ul>
				</div>
				
				<div class="bottom-content">
					<button id="downloadBtn" class="ui blue button" type="button" onclick="downloadConfirm();">다운로드</button>
				</div>
			</div>
		</c:if>
		
		<c:if test="${basePath == ''}">
			<div class="ui error message">
				비 정상적인 접근입니다.
			</div>
		</c:if>
	</div>
	
	</form>
</body>
</html>