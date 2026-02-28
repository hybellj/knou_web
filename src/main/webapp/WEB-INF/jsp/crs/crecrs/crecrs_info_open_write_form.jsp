<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/editor_inc.jsp" %>
	<script type="text/javascript">
		$(document).ready(function() {
			$('#rangestart2').calendar({
				type: 'date',
				endCalendar: $('#rangeend2'),
				formatter: {
					date: function(date, settings) {
						if (!date) return '';
						var day  = (date.getDate()) + '';
						var month = settings.text.monthsShort[date.getMonth()];
						if (month.length < 2) {
							 month = '0' + month;
						}
						if(day.length < 2) {
							day = '0' + day;
						}
						var year = date.getFullYear();
						return year + '.' + month + '.' + day;
						}
				}
			});
			$('#rangeend2').calendar({
				type: 'date',
				startCalendar: $('#rangestart2'),
				formatter: {
					date: function(date, settings) {
						if (!date) return '';
						var day  = (date.getDate()) + '';
						var month = settings.text.monthsShort[date.getMonth()];
						if (month.length < 2) {
							 month = '0' + month;
						}
						if (day.length < 2) {
							day = '0' + day;
						}
						var year = date.getFullYear();
						return year + '.' + month + '.' + day;
					}
				}
			});
			
		});
	
		// 상단 운영자 등록 이동 버튼
		function moveCreTch(crsCreCd) {
			if(!crsCreCd){
				alertl('<spring:message code="crs.confirm.insert.lecture.info"/>'); // 개설 과목 정보를  등록 바랍니다.
			} else{
				var form = $("<form></form>");
				form.attr("method", "POST");
				form.attr("name", "moveForm");
				form.attr("action", "/crs/creCrsMgr/Form/crsTchForm.do");
				form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: crsCreCd}));
				form.append($('<input/>', {type: 'hidden', name: "crsTypeCd", value: "OPEN"}));
				form.appendTo("body");
				form.submit();
			}
		}
	
		// 상단 수강생 등록 이동 버튼
		function moveStd(crsCreCd) {
			if(!crsCreCd) {
				alert('<spring:message code="crs.confirm.insert.lecture.info"/>'); // 개설 과목 정보를  등록 바랍니다.
			} else{
				var form = $("<form></form>");
				form.attr("method", "POST");
				form.attr("name", "moveForm");
				form.attr("action", "/crs/creCrsMgr/Form/crsStdForm.do");
				form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: crsCreCd}));
				form.append($('<input/>', {type: 'hidden', name: "crsTypeCd", value: "OPEN"}));
				form.appendTo("body");
				form.submit();
			}
		}
		
		// 저장
		function add(gubun) {
			if(!$("#termCd").val()) {
				alert('<spring:message code="crs.course.term.select"/>'); // 개설학기 설정 바랍니다.
				return;
			}
			
			if(!$("#crsCreNm").val().trim()) {
				alert('<spring:message code="crs.confirm.course.name.setting"/>'); // 개설 과목명 설정 바랍니다.
				return;
			}

			if(isEmpty($("#enrlStartDttm").val() && $("#enrlEndDttm").val())) {
				alert('<spring:message code="crs.confirm.insert.lecture.period"/>'); // 강의 기간을 입력해주세요.
				return;
			}
			
			var crsCreCd = '<c:out value="${creCrsVO.crsCreCd}" />';
			
			var crsCd = $("#crsCd").val();
			var crsCdVal = $("#crsCdVal").val();
			if(crsCdVal == "") {
				return;
			}
			
			var url = "";
			
			if(crsCreCd) {
				url = "/crs/creCrsMgr/updateCreCrsOpen.do";
			} else {
				url = "/crs/creCrsMgr/insertCreCrsOpen.do";
			}
			
			var data = $("#creCrsOpenWriteForm").serialize();
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var crsCreCd = data.returnVO.crsCreCd;
					var path = "/lecture/" + crsCreCd;
					var dx = dx5.get("upload1");
					$("#crsCreCd").val(crsCreCd);
					
					if(gubun != "NEXT") {
						alert('<spring:message code="crs.open.course.regist.success"/>'); // 공개 강좌 과정 등록하였습니다.
					}
					
                    dx.setUploadPath(path);
					
					// 파일이 있으면 업로드 시작
    				if (dx.availUpload()) {
    					dx.startUpload();
    				}
    				// 삭제파일, 이전파일 있는 경우
    				else if (dx.getDelFileIds().length > 0 && dx.getTotalVirtualFileCount() > 0) {
    					saveLessonPage();
    				}
					else {
						moveCreTch(crsCreCd);
					}
				} else {
					alert(data.message);
				}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		}
		
		// 파일 업로드 완료
	    function finishUpload() {
	    	var dx = dx5.get("upload1");
	    	var url = "/file/fileHome/saveFileInfo.do";
	    	var data = {
    			"uploadFiles" : dx.getUploadFiles(),
              	"copyFiles"   : dx.getCopyFiles(),
              	"uploadPath"  : dx.getUploadPath()
	    	};
	    	
	    	ajaxCall(url, data, function(data) {
	    		if(data.result > 0) {
	    			saveLessonPage();
	    		} else {
	    			alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    		}
	    	}, function(xhr, status, error) {
	    		alert("<spring:message code='success.common.file.transfer.fail'/>"); // 업로드를 실패하였습니다.
	    	});
	    }
		
	 	// 강의 페이지 저장
	    function saveLessonPage() {
			hideLoading();
	    	
			var dx = dx5.get("upload1");
			$("#creCrsOpenWriteForm > input[name='uploadPath']").val(dx.getUploadPath());
			$("#creCrsOpenWriteForm > input[name='uploadFiles']").val(dx.getUploadFiles());
			$("#creCrsOpenWriteForm > input[name='delFileIdStr']").val(dx.getDelFileIdStr());
			
	    	var url = "/lesson/lessonHome/saveLessonPage.do";
			var data = $("#creCrsOpenWriteForm").serialize();
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					moveCreTch($("#crsCreCd").val());
				} else {
					alert('<spring:message code="lesson.error.save.cnts.file" />' + "\n" + data.message);
					moveEditForm($("#crsCreCd").val());
				}
			}, function(xhr, status, error) {
				alert('<spring:message code="lesson.error.save.cnts.file" />'); // 첨부파일 등록중 오류가 발생하였습니다.
				moveEditForm($("#crsCreCd").val());
			}, true);
	    }
	 	
	 // 수정 이동
		function moveEditForm(crsCreCd) {
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "moveForm");
			form.attr("action", "/crs/creCrsMgr/Form/creCrsLegalWriteForm.do");
			form.append($('<input/>', {type: 'hidden', name: "crsCreCd", value: crsCreCd}));
			form.append($('<input/>', {type: 'hidden', name: "crsTypeCd", value: "OPEN"}));
			form.appendTo("body");
			form.submit();
		}
	</script>
<body>
	<div id="wrap" class="pusher">
	    <!-- class_top 인클루드  -->
		<%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
	    <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>
		<div id="container">
			<!-- 본문 content 부분 -->
	        <div class="content">
	        	<div id="info-item-box">
					<h2 class="page-title flex-item">
					    <spring:message code="common.term.subject"/><!-- 학기/과목 -->
					    <div class="ui breadcrumb small">
					        <small class="section"><spring:message code="crs.open.course.manage" /><!-- 공개강좌 개설관리 --></small>
					    </div>
					</h2>
				    <div class="button-area">
				    	<a href="javascript:add('NEXT')" class="btn"><spring:message code="button.next"/></a><!-- 다음 --> 
						<a href="#0" class="btn btn-primary" onclick="add();"><spring:message code="button.add"/></a><!-- 저장 -->
						<a href="/crs/creCrsMgr/Form/creCrsOpenListForm.do" class="btn btn-negative"><spring:message code="button.cancel"/></a><!-- 취소 -->
				    </div>
				</div>
	        	<div class="ui divider mt0"></div>
				<div class="ui form">
					<ol class="cd-multi-steps text-bottom count">
						<li class="current"><span><spring:message code="crs.lecture.info.regist"/></span></li><!-- 과목 정보 등록 -->
						<li><a href="javascript:moveCreTch('${creCrsVO.crsCreCd}')"><span><spring:message code="crs.label.reg.operator"/></span></a></li><!-- 운영자 등록 -->
						<li><a href="javascript:moveStd('${creCrsVO.crsCreCd}');"><span><spring:message code="crs.label.learner.regist"/></span></a></li><!-- 수강생 등록 -->
					</ol>
					<form class="ui form" id="creCrsOpenWriteForm" name="creCrsOpenWriteForm" method="POST">
						<input type="hidden" id="crsCreCd" 			name="crsCreCd" 		value="${creCrsVO.crsCreCd}" />
						<input type="hidden" id="crsTypeCd" 		name="crsTypeCd" 		value="OPEN" />
					
						<input type="hidden" id="uploadPath" 		name="uploadPath" 		value="" />
						<input type="hidden" id="uploadFiles" 		name="uploadFiles" 		value="" />
						<input type="hidden" id="delFileIds" 		name="delFileIds" 		value="" />
						<input type="hidden" id="delFileIdStr" 		name="delFileIdStr" 	value="" />
						
						<div class="ui grid stretched row">
							<div class="sixteen wide tablet eight wide computer column">
								<div class="ui segment">
									<ul class="tbl-simple">
										<li>
											<dl>
												<dt><label for="semesterLabel" class="req"><spring:message code="common.term"/></label></dt><!-- 학기 -->
												<dd>
													<c:choose>
														<c:when test="${empty creCrsVO.termCd}">
															<select class="ui fluid selection dropdown w300" id="termCd" name="termCd">
																<option value=""><spring:message code="common.alert.select.term"/></option><!-- 학기를 선택하세요 -->
																<c:forEach var="item" items="${termList}" varStatus="status">
																	<option value="${item.termCd}" <c:if test="${item.curTermYn eq 'Y'}">selected</c:if>>${item.termNm}</option>
																</c:forEach>
															</select>
														</c:when>
														<c:otherwise>
															<select class="ui fluid selection dropdown w300" id="termCd" name="termCd">
																<c:forEach var="item" items="${termList}" varStatus="status">
																	<c:if test="${creCrsVO.termCd eq item.termCd}">
																		<option value="${item.termCd}">${item.termNm}</option>
																	</c:if>
																</c:forEach>
															</select>
														</c:otherwise>
													</c:choose>
												</dd>
											</dl>
										</li>
										<li>
											<dl>
												<dt><label for="subjectLabel_ko" class="req"><spring:message code="common.label.crsauth.crsnm"/><spring:message code="crs.common.lang.ko"/></label></dt><!-- 개설 과목명 --> <!-- (KO) -->
												<dd>
													<div class="ui fluid input">
														<input type="text"  id="crsCreNm" name="crsCreNm" value="${creCrsVO.crsCreNm}" autocomplete="off">
													</div>
												</dd>
											</dl>
										</li>
										<li>
											<dl>
												<dt><label for="subjectLabel_en"><spring:message code="common.label.crsauth.crsnm"/><spring:message code="crs.common.lang.en"/></label></dt><!-- 개설 과목명 --> <!-- (EN) -->
												<dd>
													<div class="ui fluid input">
														<input type="text"  id="crsCreNmEng" name="crsCreNmEng" value="${creCrsVO.crsCreNmEng}" autocomplete="off">
													</div>
												</dd>
											</dl>
										</li>
										<li>
											<div class="field">
												<label for="subjectExpLabel"><spring:message code="common.label.lecture.desc"/></label><!--  강의 설명 -->
												<dd style="height:300px">
													<div style="height:100%">
														<textarea name="crsCreDesc" id="crsCreDesc">${creCrsVO.crsCreDesc}</textarea>
														<script>
															// html 에디터 생성
															var editor = HtmlEditor('crsCreDesc', THEME_MODE, '/crs');
														</script>
													</div>
												</dd>
											</div>
										</li>
										<li>
											<div class="field">
												<label for="subjectExpLabel"><spring:message code="common.attachments"/></label><!-- 첨부파일 -->
												<dd>
													<uiex:dextuploader
														id="upload1"
														path="${uploadPath}"
														limitCount="10"
														limitSize="10240"
														oneLimitSize="2048"
														listSize="5"
														fileList="${fileList}"
														finishFunc="finishUpload()"
														allowedTypes="mp4"
														bigSize="true"
													/>
												</dd>
											</div>
										</li>
									</ul>
								</div>
							</div><!-- 첫번째 sixteen wide tablet eight wide computer column 끝. -->
							<div class="sixteen wide tablet eight wide computer column">
								<div class="ui segment">
									<ul class="tbl-simple">
										<li>
											<dl>
												<dt>
													<label for="useLabel"><spring:message code="common.label.use.type.yn"/></label><!-- 사용 여부 -->
												</dt>
												<dd>
													<div class="inline fields mb0">
														<div class="field">
															<div class="ui radio checkbox">
																<input type="radio" name="useYn" value="Y" <c:choose><c:when test="${creCrsVO.useYn eq 'Y'}">checked</c:when><c:otherwise>checked</c:otherwise></c:choose>>
																<label><spring:message code="common.use"/></label><!-- 사용 -->
															</div>
														</div>
														<div class="field">
															<div class="ui radio checkbox">
																<input type="radio" name="useYn" value="N" <c:if test="${creCrsVO.useYn eq 'N'}">checked</c:if>> 
																<label><spring:message code="common.not_use"/></label><!-- 미사용 -->
															</div>
														</div>
													</div>
												</dd>
											</dl>
										</li>
										<li>
											<dl>
												<dt>
													<label for="enrollModifyLabel" class="req"><spring:message code="common.label.lecture.period"/></label><!-- 강의 기간 -->
												</dt>
												<dd>
													<div class="inline fields mb0">
														<div class="field">
															<div class="ui calendar" id="rangestart2">
																<div class="ui input left icon">
																	<i class="calendar alternate outline icon"></i>
																	<input type="text" id="enrlStartDttm" name="enrlStartDttm" value="${creCrsVO.enrlStartDttm}" placeholder="<spring:message code='common.start.date'/>" autocomplete="off" /><!-- 시작일 -->
																</div>
															</div>
														</div>
														<div class="field">
															<div class="ui calendar" id="rangeend2">
																<div class="ui input left icon">
																	<i class="calendar alternate outline icon"></i>
																	<input type="text" id="enrlEndDttm" name="enrlEndDttm" value="${creCrsVO.enrlEndDttm}" placeholder="<spring:message code='common.enddate'/>" autocomplete="off" /><!-- 종료일 -->
																</div>
															</div>
														</div>
													</div>
												</dd>
											</dl>
										</li>
									</ul>
								</div>
							</div><!-- 두번째 sixteen wide tablet eight wide computer column 끝. -->
						</div>
					</form>
				</div>
				<!-- //ui form -->
			</div>
			<!-- //본문 content 부분 -->
		</div>
		<!-- footer 영역 부분 -->
		<%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
	</div>
</body>
</html>