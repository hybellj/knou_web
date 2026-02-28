<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
    	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
    	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    	<link rel="stylesheet" type="text/css" href="/webdoc/file-uploader/file-uploader.css" />
    	<script type="text/javascript" src="/webdoc/js/jquery.form.min.js"></script>
	    <script type="text/javascript" src="/webdoc/file-uploader/lang/file-uploader-ko.js"></script>
	    <script type="text/javascript" src="/webdoc/file-uploader/file-uploader.js"></script>
	    <script type="text/javascript" src="/webdoc/js/iframe.js"></script>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    </head>
    <script type="text/javascript">
    $(function(){
    });
    
    // 파일 바이트 계산
	function byteConvertor(bytes, fileNm, fileId) {
		bytes = parseInt(bytes);
		var s = ['bytes', 'KB', 'MB', 'GB', 'TB', 'PB'];
		var e = Math.floor(Math.log(bytes)/Math.log(1024));
		if(e == "-Infinity") {
			$("#"+fileId).append(fileNm + " 0 "+s[0]);
		} else {
			$("#"+fileId).append(fileNm + " " + (bytes/Math.pow(1024, Math.floor(e))).toFixed(2)+" "+s[e]);
		}
	}
    
	// 파일 다운로드
	function fileDown(fileSn, repoCd) {
		var url  = "/common/fileInfoView.do";
		var data = {
			"fileSn" : fileSn,
			"repoCd" : repoCd
		};
		
		ajaxCall(url, data, function(data) {
			if ( $("iframe[name='tempIfm']").length == 0 ) {
				var iHtml = '<iframe name="tempIfm" style="visibility: none; display: none;"></iframe>';
				$("body").append(iHtml);
			}

			var kvArr = [];
			kvArr.push({'key' : 'path', 'val' : path});

			submitForm("/common/downloadFile.do", "tempIfm", kvArr);
		}, function(xhr, status, error) {
			alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
		});
	}
	
	// 페이지 이동
	function submitForm(action, target, kvArr){
		$("form[name='tempForm']").remove();

		var form = $("<form></form>");
		form.attr("method", "POST");
		form.attr("name", "tempForm");
		form.attr("action", action);
		form.attr("target", target);

		for(var i=0; i<kvArr.length; i++){
			form.append($('<input/>', {type: 'hidden', name: kvArr[i].key, value: kvArr[i].val}));
		}

		form.appendTo("body");
		form.submit();
	};
    </script>
    
    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
        	<div class="option-content mb10 gap4">
                 <div class="mra">
                     <b class="sec_head"><spring:message code="score.label.ect.eval.oper" /></b><!-- 성적 재확인신청 -->
                 </div>
	         </div>
	         <div class="ui form">
	             <ul class="tbl dt-sm">
	                 <li>
	                     <dl>
	                         <dt><spring:message code="crs.label.crs.cd" /></dt><!-- 학수번호 -->
	                         <dd>${resultVo.crsCreCd}</dd>
	                         <dt><spring:message code="review.label.decls" /></dt><!-- 분반 -->
	                         <dd>${resultVo.declsNo}</dd>
	                     </dl>
	                 </li>
	                 <li>
	                     <dl>
	                         <dt><spring:message code="review.label.crscrenm" /></dt><!-- 과목명 -->
	                         <dd>${resultVo.crsCreNm}</dd>
	                         <dt><spring:message code="crs.label.compdv" /></dt><!-- 이수구분 -->
	                         <dd>${resultVo.compDvNm}</dd>
	                     </dl>
	                 </li>
	                 <li>
	                     <dl>
	                         <dt><spring:message code="score.label.request.reason" /></dt><!-- 신청사유 -->
	                         <dd>
	                             ${resultVo.objtCtnt}
	                         </dd>
	                     </dl>
	                 </li>
	                 <li>
	                     <dl>
	                         <dt><spring:message code="score.label.reference.add" /></dt><!-- 자료첨부 -->
	                         <dd>
	                             <div class="upload">
	                                 <ul class="mt0">
	                                 	<c:forEach items="${resultVo.fileList }" var="item" varStatus="status">
	                                     <li>
	                                     	<button class="ui icon small button" id="file_${item.fileSn }" title="<spring:message code="asmnt.label.attachFile.download" />" onclick="fileDown('${item.fileSn}', '${item.repoCd }')">
												<i class="ion-android-download"></i>
											</button>
											<script>
												byteConvertor("${item.fileSize}", "${item.fileNm}", "file_${item.fileSn}");
											</script>
	                                         <!-- 
	                                         <p>15120851_ml15120851.jpg<small>185.83 KB</small></p>
	                                         <span>삭제</span> 
	                                         -->
	                                     </li>
	                                     </c:forEach>
	                                 </ul>
	                             </div>                                
	                         </dd>
	                     </dl>
	                 </li>
	             </ul>
	             <div class="option-content mt15 mb10">
	                 <div class="mra">
	                     <label class="ui green label small pl10 pr10">A</label>
	                     <b class="sec_head"><spring:message code="score.label.resulte" /></b> <!-- 처리결과 -->
	                 </div>
	                 <div>
	                     	<spring:message code="common.charge.professor" /> : ${resultVo.procUserNm} | <spring:message code="lesson.label.reg.dt" /> : ${resultVo.procDttmFmt}<!-- 담당교수 | 등록일 -->
	                 </div>
	             </div>  
	             <div class="">
	                 <div class="ui attached message">
	                     <div class="flex gap16">
	                     	${resultVo.procNm}
	                     </div>
	                 </div>
	                 <div class="ui bottom attached segment">
	                 	${resultVo.procCtnt}
	                 </div>
	             </div>
	         </div>
	         <div class="scrollbox_x">
	             <table class="tBasic mt20 tc">
	                 <thead>
	                     <tr>
	                         <th colspan="2"><spring:message code="score.label.before.score" /></th><!-- 변경 전 성적 -->
	                         <th colspan="2"><spring:message code="score.label.after.score" /></th><!-- 변경 후 성적 -->
	                     </tr>
	                     <tr>
	                         <th><spring:message code="resh.label.point" /></th><!-- 점수 -->
	                         <th><spring:message code="score.label.grade" /></th><!-- 등급 -->
	                         <th><spring:message code="resh.label.point" /></th><!-- 점수 -->
	                         <th><spring:message code="score.label.grade" /></th><!-- 등급 -->
	                     </tr>
	                 </thead>
	                 <tbody>
	                     <tr>
	                         <td>${resultVo.prvScore}</td>
	                         <td>${resultVo.prvGrade}</td>
	                         <td>${resultVo.modScore}</td>
	                         <td>${resultVo.modGrade}</td>
	                     </tr>                            
	                 </tbody>
	             </table>
	         </div>
	        
	         <div class="bottom-content">
	             <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="sys.button.close" /></button><!-- 닫기 -->
	         </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
