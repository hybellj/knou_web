<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/common/editor_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/resh/common/resh_common_inc.jsp" %>

<script type="text/javascript">
	$(document).ready(function () {
		$("#joinTrgt").parent().css("z-index", "1001");
	});
	
	// 목록
	function viewReshList() {
		var kvArr = [];
		
		submitForm("/resh/reshMgr/Form/homeReshList.do", "", "", kvArr);
	}
	
	// 설문 등록, 수정
	function save() {
		if(!nullCheck()) {
			return false;
		}
		setValue();
		
		var url = "";
		if(${empty vo.reschCd }) {
			url = "/resh/reshMgr/writeHomeResh.do";
		} else {
			url = "/resh/reshMgr/editHomeResh.do";
		}
		
		$("#writeReshForm").attr("action", url);
		$("#writeReshForm").submit();
	}
	
	// 빈 값 체크
	function nullCheck() {
		<spring:message code='resh.label.resh' var='resh'/> // 설문
		
		if($.trim($("#reschTitle").val()) == "") {
 			alert("<spring:message code='resh.alert.title' />");/* 설문 명을 입력하세요. */
 			return false;
 		}
 		if(editor.isEmpty() || editor.getTextContent().trim() === "") {
 			alert("<spring:message code='resh.alert.cts' />");/* 설문 내용을 입력하세요. */
 			return false;
 		}
 		if($("#joinTrgt").val() == null) {
 			alert("<spring:message code='resh.alert.select.join.trgt' />");/* 참여 대상을 선택하세요 */
 			return false;
 		}
 		if($("#reschStartFmt").val() == "") {
			alert("<spring:message code='common.alert.input.eval_start_date' arguments='${resh}'/>");/* [설문] 시작일을 입력하세요. */
			return false;
		}
		if($("#reschStartHH").val() == " ") {
			alert("<spring:message code='common.alert.input.eval_start_hour' arguments='${resh}'/>");/* [설문] 시작시간을 입력하세요. */
			return false;
		}
		if($("#reschStartMM").val() == " ") {
			alert("<spring:message code='common.alert.input.eval_start_min' arguments='${resh}'/>");/* [설문] 시작분을 입력하세요. */
			return false;
		}
		if($("#reschEndFmt").val() == "") {
			alert("<spring:message code='common.alert.input.eval_end_date' arguments='${resh}'/>");/* [설문] 종료일을 입력하세요. */
			return false;
		}
		if($("#reschEndHH").val() == " ") {
			alert("<spring:message code='common.alert.input.eval_end_hour' arguments='${resh}'/>");/* [설문] 종료시간을 입력하세요. */
			return false;
		}
		if($("#reschEndMM").val() == " ") {
			alert("<spring:message code='common.alert.input.eval_end_min' arguments='${resh}'/>");/* [설문] 종료분을 입력하세요. */
			return false;
		}
 		if ( ($("#reschStartFmt").val()+$("#reschStartHH").val()+$("#reschStartMM").val()) >
			($("#reschEndFmt").val()+$("#reschEndHH").val()+$("#reschEndMM").val()) ) {
			alert("<spring:message code='common.alert.input.eval_start_end_date' arguments='${resh}'/>"); // 종료일시를 시작일시 이후로 입력하세요.
			return false;
		}
		
		return true;
	}
	
	// 값 채우기
	function setValue() {
		// 설문 시작 일시
		if ($("#reschStartFmt").val() != null && $("#reschStartFmt").val() != "") {
			$("input[name='reschStartDttm']").val($("#reschStartFmt").val().replaceAll(".","") + "" + $("#reschStartHH option:selected").val() + "" + $("#reschStartMM option:selected").val() + "00");
		}
		
		// 설문 종료 일시
		if ($("#reschEndFmt").val() != null && $("#reschEndFmt").val() != "") {
			$("input[name='reschEndDttm']").val($("#reschEndFmt").val().replaceAll(".","") + "" + $("#reschEndHH option:selected").val() + "" + $("#reschEndMM option:selected").val() + "00");
		}
	}
	
	// 이전 설문 가져오기 팝업
	function reshCopyList() {
		var kvArr = [];
		
		submitForm("/resh/reshMgr/homeReshCopyListPop.do", "reshPopIfm", "copyHomeResh", kvArr);
	}
	
	// 이전 설문 가져오기
 	function copyResh(reschCd) {
 		var url  = "/resh/reshCopy.do";
		var data = {
			"reschCd" : reschCd
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		var reshVO = data.returnVO;
        		// 설문 복사 여부
        		$("input[name='itemCopyYn']").val("Y");
        		// 복사할 설문 번호
        		$("input[name='itemCopyReschCd']").val(reshVO.reschCd);
        		// 설문명
        		$("#reschTitle").val(reshVO.reschTitle);
        		// 설문 내용
        		$("button.se-clickable[name=new]").trigger("click");
        		editor.insertHTML($.trim(reshVO.reschCts) == "" ? " " : reshVO.reschCts);
        		// 설문 시작 일시
        		$("#reschStartFmt").val(dateFormat("date", reshVO.reschStartDttm));
        		// 설문 종료 일시
        		$("#reschEndFmt").val(dateFormat("date", reshVO.reschEndDttm));
        		// 설문결과 조회 가능 여부
        		if(reshVO.rsltTypeCd == "ALL" || reshVO.rsltTypeCd == "JOIN") {
        			$("#rsltTypeCdY").trigger("click");
        		} else {
        			$("#rsltTypeCdN").trigger("click");
        		}
        		$('.modal').modal('hide');
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='resh.error.copy' />");/* 설문 가져오기 중 에러가 발생하였습니다. */
		});
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
	        	<%-- <%@ include file="/WEB-INF/jsp/common/admin/admin_location.jsp" %> --%>
	            <div class="ui form">
	            	<div class="layout2">
		                <div id="info-item-box">
		                	<h2 class="page-title flex-item flex-wrap gap4 columngap16">
                                <spring:message code="resh.label.resh.home" /><!-- 전체설문 -->
                                <div class="ui breadcrumb small">
                                	<small class="section">
	                                	<c:choose>
				                    		<c:when test="${empty vo.reschCd }">
				                    			<spring:message code='resh.button.write' /><!-- 등록 -->
				                    		</c:when>
				                    		<c:otherwise>
				                    			<spring:message code='resh.button.modify' /><!-- 수정 -->
				                    		</c:otherwise>
				                    	</c:choose>
                                	</small>
                                </div>
                            </h2>
		                    <div class="button-area">
		                    	<a href="javascript:save()" class="ui blue button">
		                    		<c:choose>
		                    			<c:when test="${empty vo.reschCd }">
		                    				<spring:message code="resh.button.save" /><!-- 저장 -->
		                    			</c:when>
		                    			<c:otherwise>
		                    				<spring:message code="resh.button.modify" /><!-- 수정 -->
		                    			</c:otherwise>
		                    		</c:choose>
		                    	</a>
		                        <a href="javascript:reshCopyList()" class="ui blue button"><spring:message code="resh.label.prev.resh.copy" /></a><!-- 이전 설문 가져오기 -->
		                        <a href="javascript:viewReshList()" class="ui blue button"><spring:message code="resh.button.list" /></a><!-- 목록 -->
		                    </div>
		                </div>
		                <div class="row">
		                	<div class="col">
				                <div class="ui form" id="reshWriteDiv">
				                	<form name="writeReshForm" id="writeReshForm" method="POST">
				                		<input type="hidden" name="reschCd" 		value="${vo.reschCd }" />
				                		<input type="hidden" name="reschTplYn" 		value="N" />
				                		<input type="hidden" name="reschTypeCd" 	value="HOME" />
				                		<input type="hidden" name="scoreViewYn"		value="N" />
				                		<input type="hidden" name="reschStartDttm" 	value="${vo.reschStartDttm }" />
				                		<input type="hidden" name="reschEndDttm" 	value="${vo.reschEndDttm }" />
				                		<input type="hidden" name="itemCopyYn" 		value="${vo.itemCopyYn }" />
				                		<input type="hidden" name="itemCopyReschCd" value="${vo.itemCopyReschCd }" />
										<div class="ui form">
											<div class="ui segment">
										        <ul class="tbl border-top-grey">
										            <li>
										                <dl>
										                    <dt><label for="reschTitle" class="req"><spring:message code="resh.label.resh.home.title" /></label></dt><!-- 전체설문명 -->
										                    <dd>
										                        <div class="ui fluid input">
										                            <input type="text" name="reschTitle" id="reschTitle" value="${fn:escapeXml(vo.reschTitle) }">
										                        </div>
										                    </dd>
										                </dl>
										            </li>
										            <li>
										                <dl>
										                    <dt><label for="reschCts" class="req"><spring:message code="resh.label.resh.home.cts" /></label></dt><!-- 전체설문 내용 -->
										                    <dd style="height:400px">
	            												<div style="height:100%">
										                    		<textarea name="reschCts" id="reschCts">${vo.reschCts }</textarea>
										                    		<script>
											                           // html 에디터 생성
											                   	  		var editor = HtmlEditor('reschCts', THEME_MODE, '/resh/${vo.reschCd }');
											                       	</script>
										                    	</div>
															</dd>
										                </dl>
										            </li>
										            <li>
										            	<dl>
										            		<dt><label for="joinTrgt" class="req"><spring:message code="resh.label.resh.home.join.trgt" /><!-- 참여대상 --></label></dt>
										            		<dd>
										            			<select class="ui dropdown wmax" multiple="" id="joinTrgt" name="joinTrgt">
					                                                <option value=""><spring:message code="resh.alert.select.join.trgt" /><!-- 참여 대상을 선택하세요 --></option>
					                                                <c:forEach var="item" items="${userTypeList }">
						                                                <option value="${item.codeCd }"
						                                                	<c:forEach var="trgt" items="${vo.joinTrgt }">
						                                                		${item.codeCd eq trgt ? 'selected' : '' }
						                                                	</c:forEach>
						                                                >${item.codeNm }</option>
					                                                </c:forEach>
					                                            </select>
										            		</dd>
										            	</dl>
										            </li>
										            <li>
										                <dl>
										                    <dt><label for="reschStartFmt" class="req"><spring:message code="resh.label.resh.home.period" /></label></dt><!-- 전체설문 기간 -->
										                    <dd>
										                    	<div class="fields gap4">
		                                            				<div class="field flex" style="z-index:1000">
																		<!-- 시작일시 -->
								                                        <uiex:ui-calendar dateId="reschStartFmt" hourId="reschStartHH" minId="reschStartMM" 
								                                        	rangeType="start" rangeTarget="reschEndFmt" value="${vo.reschStartDttm}"/>
																	</div>
																	<div class="field p0 flex-item desktop-elem">~</div>
						                                            <div class="field flex">
						                                           	   <!-- 종료일시 -->
						                                               <uiex:ui-calendar dateId="reschEndFmt" hourId="reschEndHH" minId="reschEndMM" 
						                                               		rangeType="end" rangeTarget="reschStartFmt" value="${vo.reschEndDttm}"/>
						                                            </div>
						                                        </div>
										                    </dd>
										                </dl>
										            </li>
										        </ul>
										    </div>
										</div>
										<div class="ui form">
											<div class="ui segment">
												<ul class="tbl border-top-grey">
										            <li>
										                <dl>
										                    <dt><label for="subjectLabel"><spring:message code="resh.label.added.option" /></label></dt><!-- 옵션 -->
										                    <dd></dd>
										                </dl>
										                <dl>
										                	<dt><spring:message code="resh.label.resh.home.rslt.open.yn" /></dt><!-- 전체설문결과 조회 가능 -->
										                	<dd>
										                		<div class="fields">
										                            <div class="field">
										                                <div class="ui radio checkbox">
										                                    <input type="radio" id="rsltTypeCdN" name="rsltTypeCd" value="CLOSE" tabindex="0" class="hidden" ${vo.rsltTypeCd eq 'CLOSE' || empty vo.reschCd ? 'checked' : '' }>
										                                    <label for="rsltTypeCdN"><spring:message code="resh.common.no" /></label><!-- 아니오 -->
										                                </div>
										                            </div>
										                            <div class="field">
										                                <div class="ui radio checkbox">
										                                    <input type="radio" id="rsltTypeCdY" name="rsltTypeCd" value="ALL" tabindex="0" class="hidden" ${vo.rsltTypeCd eq 'ALL' || vo.rsltTypeCd eq 'JOIN' ? 'checked' : '' }>
										                                    <label for="rsltTypeCdY"><spring:message code="resh.common.yes" /></label><!-- 예 -->
										                                </div>
										                            </div>
										                        </div>
										                	</dd>
										                </dl>
										            </li>
										        </ul>
											</div>
										</div>
									</form>
				                </div>
		                	</div>
		                </div>
	            	</div>
	            </div>
	        </div>
	    </div>
	    <!-- //본문 content 부분 -->
	    <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
	</div>
</body>

</html>