<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
<!-- 게시판 공통 -->
<%@ include file="/WEB-INF/jsp/bbs/common/bbs_common_inc.jsp" %>
<script type="text/javascript">
	$(document).ready(function() {
		
	});
	
	// 저장
	function save() {
		var bbsNm = $("#bbsNm").val();
		var bbsCd = $("#bbsCd").val();
		
		if(!$("#bbsNm").val()) {
			alert('<spring:message code="bbs.alert.empty_bbs_name" />'); // 게시판 명은 필수 항목입니다. 다시 확인 바랍니다.
			$("#bbsNm").focus();
			return;
		}
		
		if(!$("#bbsCd").val()) {
			alert('<spring:message code="bbs.alert.empty_bbs_code" />'); // 게시판 코드는 필수 항목입니다. 다시 확인 바랍니다.
			$("#bbsCd").focus();
			return;
		}
		
		// 공지
		$("#infoWriteForm > input[name='notiUseYn']").val($("#notiUse").is(":checked") ? "Y" : "N");
		// 답글
		$("#infoWriteForm > input[name='ansrUseYn']").val($("#ansrUse").is(":checked") ? "Y" : "N");
		// 첨부파일 사용여부
		$("#infoWriteForm > input[name='atchUseYn']").val($("input[name='atchUse']:checked").val() == "Y" ? "Y" : "N");
		// 글쓰기 사용여부
		$("#infoWriteForm > input[name='writeUseYn']").val($("input[name='writeUse']:checked").val() == "Y" ? "Y" : "N");
		// 사용여부
		//$("#infoWriteForm > input[name='useYn']").val($("input[name='use']:checked").val() == "Y" ? "Y" : "N");
		
		var bbsId = '<c:out value="${bbsInfoVO.bbsId}" />';
		var url;
		
		if(bbsId) {
			url = '/bbs/bbsMgr/editInfo.do';
		} else {
			url = '/bbs/bbsMgr/addInfo.do';
		}
		
		var data = $("#infoWriteForm").serialize();
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				moveList();
            } else {
            	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
		});
	}
	
	// 기본언어 변경
	function changeDfltLangCd(langCd) {
		var selectedDfltLangCd = $("#selectedDfltLangCd").val() || "ko";
		
		if(selectedDfltLangCd == langCd) return;
		
		var url = "/bbs/bbsHome/bbsInfoLang.do";
		var data = {
			  bbsId: '<c:out value="${vo.bbsId}" />'
			, langCd: langCd
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var returnVO = data.returnVO;
	        	
	        	if(returnVO) {
	        		$("#bbsNm").val(returnVO.bbsNm);
	        	}
			} else {
				alert(data.message);
				$("#dfltLangCd").dropdown("set value", selectedDfltLangCd);
			}
		}, function(xhr, status, error) {
			alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			$("#dfltLangCd").dropdown("set value", selectedDfltLangCd);
		});
	}
	
	// 목록이동
	function moveList() {
		var url = "/bbs/bbsMgr/Form/infoList.do";
		var form = $("<form></form>");
		form.attr("method", "POST");
		form.attr("name", "bbsForm");
		form.attr("action", url);
		form.appendTo("body");
		form.submit();
	}
</script>
<body>
	<div id="wrap" class="pusher">
		<!-- class_top 인클루드  -->
		<%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp"%>
		
		<div id="container">
			<%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp"%>
			
			<div class="content stu_section">
			
				<!-- admin_location -->
                <%-- <%@ include file="/WEB-INF/jsp/common/admin/admin_location.jsp" %> --%>
                <!-- //admin_location -->
		        
		        <div class="ui form">
                	<div class="layout2">

                        <div id="info-item-box">
                            <h2 class="page-title flex-item flex-wrap gap4 columngap16">
                                <spring:message code="bbs.label.bbs_manage" /><!-- 게시판 관리 -->
                                <div class="ui breadcrumb small">
                                    <small class="section"><spring:message code="bbs.label.list" /><!-- 목록 --></small>
                                    <i class="right chevron icon divider"></i>
									<c:choose>
			                			<c:when test="${empty bbsInfoVO.bbsId}">
			                				<small class="section"><spring:message code="bbs.label.bbs_add" /><!-- 게시판 추가 --></small>
			                			</c:when>
			                			<c:otherwise>
			                				<small class="section"><spring:message code="bbs.label.bbs_edit" /><!-- 게시판 수정 --></small>
			                			</c:otherwise>
									</c:choose>
                                </div>
                            </h2>
                            <div class="button-area">
								<c:choose>
									<c:when test="${not empty bbsInfoVO}">
				                   		<a href="javascript:void(0)" onclick="save()" class="ui blue button"><spring:message code="common.button.modify" /></a><!-- 수정 -->
				                   	</c:when>
				                   	<c:otherwise>
				  						<a href="javascript:void(0)" onclick="save()" class="ui blue button"><spring:message code="common.button.save" /></a><!-- 저장 -->
									</c:otherwise>
								</c:choose>
		                        <a href="javascript:void(0)" class="ui basic button" onclick="moveList()"><spring:message code="common.button.list" /></a><!-- 목록 -->
                            </div>
                        </div>
                	
                		<!-- 영역1 -->
                        <div class="row">
                            <div class="col">
                            
	                            <form id="infoWriteForm" name="infoWriteForm">
				                	<input type="hidden" name="crsCreCd" 	value="<c:out value="${vo.crsCreCd}" />" />
				                	<input type="hidden" name="bbsId" 		value="<c:out value="${bbsInfoVO.bbsId}" />" />
				                	<input type="hidden" name="notiUseYn" 	value="<c:out value="${bbsInfoVO.notiUseYn}" />" />
				                	<input type="hidden" name="ansrUseYn" 	value="<c:out value="${bbsInfoVO.ansrUseYn}" />" />
				                	<input type="hidden" name="atchUseYn" 	value="<c:out value="${bbsInfoVO.atchUseYn}" />" />
				                	<input type="hidden" name="writeUseYn" 	value="<c:out value="${bbsInfoVO.writeUseYn}" />" />
				                	<input type="hidden" name="useYn" 		value="<c:out value="${empty bbsInfoVO.useYn ? 'Y' : bbsInfoVO.useYn}" />" />
				                	
					                <div class="ui segment">
					                	<ul class="tbl border-top-grey">
					                		<li>
					                			<dl>
													<dt>
														<label for="subjectLabel" class="req"><spring:message code="bbs.label.form_bbs_name" /><!-- 게시판 명 --></label>
													</dt>
													<dd>
														<div class="ui fluid input">
															<input type="text" id="bbsNm" name="bbsNm" autocomplete="off" value="<c:out value="${bbsInfoVO.bbsNm}" />" maxlength="100" />
														</div>
													</dd>
												</dl>
					                		</li>
					                		<li>
					                			<dl>
													<dt>
														<label class="req"><spring:message code="bbs.label.form_bbs_code" /><!-- 게시판 코드 --></label>
													</dt>
													<dd>
														<select class="ui dropdown" id="bbsCd" name="bbsCd">
											            	<option value=""><spring:message code="bbs.label.select_bbs_code" /><!-- 게시판 코드 선택 --></option>
									            	<c:forEach items="${bbsCdList}" var="row">
									            		<c:if test="${row.codeCd ne 'TEAM'}">
										            		<option value="<c:out value="${row.codeCd}" />" <c:if test="${bbsInfoVO.bbsCd eq row.codeCd}">selected</c:if>><c:out value="${row.codeNm}" /></option>
									            		</c:if>
									            	</c:forEach>
											        	</select>
													</dd>
												</dl>
					                		</li>
					                		<li>
					                			<dl>
													<dt>
														<label class="req"><spring:message code="bbs.label.form_bbs_type" /><!-- 게시판 유형 --></label>
													</dt>
													<dd>
														<div class="fields">
														<c:forEach items="${bbsTypeCdList}" var="row" varStatus="status">
															<div class="field">
																<div class="ui radio checkbox">
																	<c:choose>
														            	<c:when test="${(empty bbsInfoVO and status.index eq 0) or bbsInfoVO.bbsTypeCd eq row.codeCd}">
														            		<c:set var="bbsTypeCdSelected" value="checked" />
														            	</c:when>
														            	<c:otherwise>
														            		<c:set var="bbsTypeCdSelected" value="" />
														            	</c:otherwise>
														            </c:choose>
																	<c:set var="bbsTypeCdId" value="bbsTypeCd_${status.index}" />
																	<input type="radio" id="<c:out value="${bbsTypeCdId}" />" name="bbsTypeCd" value="<c:out value="${row.codeCd}" />" <c:out value="${bbsTypeCdSelected}" />  />
																	<label for="<c:out value="${bbsTypeCdId}" />"><c:out value="${row.codeNm}" /></label>
																</div>
															</div>
														</c:forEach>
														</div>
													</dd>
												</dl>
					                		</li>
					                		<li>
					                			<dl>
													<dt>
														<label><spring:message code="bbs.label.form_bbs_type" /><!-- 게시판 유형 --></label>
													</dt>
													<dd>
														<div class="fields">
															<div class="field">
																<div class="ui checkbox">
																	<input type="checkbox" id="notiUse" class="hidden" <c:if test="${bbsInfoVO.notiUseYn eq 'Y'}">checked</c:if> />
																	<label class="toggle_btn" for="notiUse"><spring:message code="bbs.label.notice" /><!-- 공지 --></label>
																</div>
															</div>
															<div class="field">
																<div class="ui checkbox">
																	<input type="checkbox" id="ansrUse" class="hidden" <c:if test="${bbsInfoVO.ansrUseYn eq 'Y'}">checked</c:if> />
																	<label class="toggle_btn" for="ansrUse"><spring:message code="bbs.label.answer_atcl" /><!-- 답글 --></label>
																</div>
															</div>
														</div>
													</dd>
												</dl>
					                		</li>
					                		<li>
					                			<dl>
													<dt>
														<label><spring:message code="bbs.label.form_attach_file_use" /><!-- 첨부파일 사용 --></label>
													</dt>
													<dd>
														<div class="fields">
															<div class="field">
																<div class="ui radio checkbox">
																	<input type="radio" id="atchUseY" name="atchUse" value="Y" <c:if test="${empty bbsInfoVO or bbsInfoVO.atchUseYn eq 'Y'}">checked</c:if> />
																	<label for="atchUseY"><spring:message code="bbs.label.yes" /><!-- 예 --></label>
																</div>
															</div>
															<div class="field">
																<div class="ui radio checkbox">
																	<input type="radio" id="atchUseN" name="atchUse" value="N" <c:if test="${bbsInfoVO.atchUseYn eq 'N'}">checked</c:if> />
																	<label for="atchUseN"><spring:message code="bbs.label.no" /><!-- 아니오 --></label>
																</div>
															</div>
														</div>
													</dd>
												</dl>
					                		</li>
					                		<li>
					                			<dl>
													<dt>
														<label><spring:message code="bbs.label.form_attach_file_cnt" /><!-- 첨부파일 가능 수 --></label>
													</dt>
													<dd>
														<select class="ui dropdown" id="atchFileCnt" name="atchFileCnt">
											            	<option value=""><spring:message code="bbs.label.select_atch_file_cnt" /><!-- 첨부파일 수 선택 --></option>
											            <c:forEach begin="1" end="5" var="i" varStatus="status">
											            <c:choose>
											            	<c:when test="${(empty bbsInfoVO and i eq 1) or (bbsInfoVO.atchFileCnt eq 0 and i eq 1) or bbsInfoVO.atchFileCnt eq i}">
											            		<c:set var="atchFileCntSelected" value="selected" />
											            	</c:when>
											            	<c:otherwise>
											            		<c:set var="atchFileCntSelected" value="" />
											            	</c:otherwise>
											            </c:choose>
											            	<option value="<c:out value="${i}" />" <c:out value="${atchFileCntSelected}" />>${i}</option>
											            </c:forEach>
											        	</select>
													</dd>
												</dl>
					                		</li>
					                		<li>
					                			<dl>
													<dt>
														<label><spring:message code="bbs.label.form_attach_file_limit" /><!-- 첨부파일 용량제한 --></label>
													</dt>
													<dd>
														<div class="ui right labeled input w100">
														<c:set var="atchFileSizeLimit" value="30" />
															<input type="text" placeholder="30" name="atchFileSizeLimit" autocomplete="off" value="<c:out value="${empty bbsInfoVO.atchFileSizeLimit ? 30 : bbsInfoVO.atchFileSizeLimit}" />" class="w70 tr" maxlength="4" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" />
															<div class="ui basic label">MB</div>
														</div>
														 <div class="ui negative message">
					                                        <p><i class="info icon"></i><spring:message code="bbs.label.atcl_file_limit_guide" /><!-- 원활한 사이트 이용을 위해 가급적 30MB 이하로 설정해 주세요. --></p>
					                                    </div>
													</dd>
												</dl>
					                		</li>
					                		<li>
					                			<dl>
													<dt>
														<label><spring:message code="bbs.label.form_default_lang" /><!-- 게시판 기본 언어 --></label>
													</dt>
													<dd>
														<select class="ui dropdown" id="dfltLangCd" name="dfltLangCd" onchange="<c:if test="${not empty bbsInfoVO}">changeDfltLangCd(this.value)</c:if>">
											            	<option value=""><spring:message code="bbs.label.select_lang" /><!-- 언어 선택 --></option>
										            	<c:forEach items="${langCdList}" var="row" varStatus="status">
										            	<c:choose>
										            		<c:when test="${(empty bbsInfoVO and status.index eq 0) or bbsInfoVO.dfltLangCd eq row.codeCd}">
										            			<c:set var="dfltLangCdSelected" value="selected" />
										            		</c:when>
										            		<c:otherwise>
										            			<c:set var="dfltLangCdSelected" value="" />
										            		</c:otherwise>
										            	</c:choose>
										            		<option value="<c:out value="${row.codeCd}" />" <c:out value="${dfltLangCdSelected}" />><c:out value="${row.codeNm}" /></option>
										            	</c:forEach>
											        	</select>
											        	<input type="hidden" id="selectedDfltLangCd" value="<c:out value="${bbsInfoVO.dfltLangCd}" />" />
													</dd>
												</dl>
					                		</li>
					                		<li>
					                			<dl>
													<dt>
														<label><spring:message code="bbs.label.form_write_use_yn" /><!-- 글쓰기 사용 여부 --></label>
													</dt>
													<dd>
														<div class="fields">
															<div class="field">
																<div class="ui radio checkbox">
																	<input type="radio" id="writeUseY" name="writeUse" value="Y" <c:if test="${empty bbsInfoVO or bbsInfoVO.writeUseYn eq 'Y'}">checked</c:if> />
																	<label for="writeUseY"><spring:message code="bbs.label.yes" /><!-- 예 --></label>
																</div>
															</div>
															<div class="field">
																<div class="ui radio checkbox">
																	<input type="radio" id="writeUseN" name="writeUse" value="N" <c:if test="${bbsInfoVO.writeUseYn eq 'N'}">checked</c:if> />
																	<label for="writeUseN"><spring:message code="bbs.label.no" /><!-- 아니오 --></label>
																</div>
															</div>
														</div>
													</dd>
												</dl>
					                		</li>
					                		<%-- 
					                		<li>
					                			<dl>
													<dt>
														<label><spring:message code="bbs.label.form_use_yn" /><!-- 사용 여부 --></label>
													</dt>
													<dd>
														<div class="fields">
															<div class="field">
																<div class="ui radio checkbox">
																	<input type="radio" id="useY" name="use" value="Y" <c:if test="${empty bbsInfoVO or bbsInfoVO.useYn eq 'Y'}">checked</c:if> />
																	<label for="useY"><spring:message code="bbs.label.yes" /><!-- 예 --></label>
																</div>
															</div>
															<div class="field">
																<div class="ui radio checkbox">
																	<input type="radio" id="useN" name="use" value="N" <c:if test="${bbsInfoVO.useYn eq 'N'}">checked</c:if> />
																	<label for="useN"><spring:message code="bbs.label.no" /><!-- 아니오 --></label>
																</div>
															</div>
														</div>
													</dd>
												</dl>
					                		</li>
					                		 --%>
					                	</ul>
					                </div>
				                </form>
                            
                            </div><!-- //col -->
	                 	</div><!-- //row -->
                	
                	</div><!-- //layout2 -->
	        	</div><!-- //ui form -->
			</div><!-- //content stu_section -->
		</div><!-- //container -->
		
		<%@ include file="/WEB-INF/jsp/common/frontFooter.jsp"%>
		
	</div><!-- //wrap -->
</body>
</html>