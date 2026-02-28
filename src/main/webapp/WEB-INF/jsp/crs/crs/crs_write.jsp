<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<%-- 에디터 --%>
<%@ include file="/WEB-INF/jsp/common/editor_inc.jsp" %>
<script type="text/javascript">
$(function(){
	
})
function crsNmCheck() {
	if($("#crsNm").val() == ""){
		/* 과목 명을 입력바랍니다. */
		alert('<spring:message code="crs.confirm.insert.course.name" />');
		return;
	}
	
	ajaxCall("/crs/crsMgr/selectCrsNmCheck.do", {crsNm : $("#crsNm").val()}, function(data){
		if (data == 0) {
			$("#chkDup").val("Y");
			/* 사용 가능한 과목 명입니다. */
			alert('<spring:message code="crs.pop.use.subject.name" />');
			return;
		} else {
			$("#chkDup").val("N");
			/* 중복된 과목 명입니다. */
			alert('<spring:message code="crs.lecture.info.duplicate.subject" />');
			$("#crsNm").val("");
			return;
		}
	}, function(){});
}
	
// 저장 확인
function onSaveValidate() {

	// 과목명 체크
 	if($("#crsNm").val() == ""){
 		/* 과목 명을 입력바랍니다. */
		alert('<spring:message code="crs.confirm.insert.course.name" />');
		return false;
 	}
 	
 	if($("#crsOperTypeCdVal option:selected").val() == "") {
 		/* 교육방법을 선택바랍니다. */
 		alert('<spring:message code="crs.confirm.select.lecture.method" />');
		return false;
 	}
 
 	/* 과목명 중복체크 */
 	var checkGubun = "${crsVo.gubun}";
 	if(checkGubun == "A") {
 		// 수정할때는 중복 체크 안한다
 		if($("#chkDup").val() == "N" || $("#chkDup").val() == "") {
 			/* 과정명 중복 체크가 완료되지 않았습니다. */
 			alert('<spring:message code="crs.confirm.check.duplicate.lecture.name" />');
			return false;
		}
 	}
 	return true;
}
  
// 저장
function onSave() {
	if(!onSaveValidate()){
		return;
	}
	
	// 에디터 내용
	var _content = editor.getPublishingHtml();
	// alert("저장내용...\n" + _content);
	// alert("textarea......\n" + $("#contentTextArea").val());
	// console.log($("#crsForm").serialize());
	
	ajaxCall("/crs/crsMgr/multiCrs.do", $("#crsForm").serialize(), function(data){
		if(data.result > 0){
			alert(data.message);
			location.href="/crs/crsMgr/crsListMain.do"
			return;
		} else {
			alert(data.message);
			return;
		}
	}, function(){});
}
        
</script>
<body>
    <div id="wrap" class="pusher">
    
        <!-- header -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
        <!-- //header -->

		<!-- lnb -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>
        <!-- //lnb -->
        
        <div id="container">
            <!-- 본문 content 부분 -->
            <div class="content">
	            <div class="ui form">
		            <div id="info-item-box">
                    	<h2 class="page-title"><spring:message code="forum.common.title" /> : <spring:message code="common.term.subject" /> > <spring:message code="button.write.subject" /></h2><!-- 학습활동 : 학기/과목 > 과목등록 -->
                    </div>
                       
                    <div class="ui bottom attached segment">
                    	<form id="crsForm">
                        <input type="hidden" id="crsCd" name="crsCd" value="${crsVo.crsCd}">
                        <ul class="tbl-simple st2">
                        	<li>
                                <dl>
                                    <dt><label><spring:message code="crs.label.crecrs.ctgr" /></label></dt><!-- 과목분류 -->
                                    <dd>
                                        <div class="fields">
                                        	<c:choose>
                                        		<c:when test="${crsVo.gubun eq 'E'}">
                                        			<c:forEach items="${orgList}" var="item" varStatus="i">
		                                            <div class="field">
		                                                <div class="ui radio checkbox">
		                                                    <input type="radio" id="chk${item.codeCd}" name="crsTypeCd" readonly="readonly" value="${item.codeCd}" tabindex="0" class="hidden" <c:choose><c:when test="${crsVo.crsTypeCd eq item.codeCd}">checked</c:when></c:choose>>
		                                                    <label for="chk${item.codeCd}">${item.codeNm}</label>
		                                                </div>
		                                            </div>
				                                    </c:forEach>	
                                        		</c:when>
                                        		<c:when test="${crsVo.gubun eq 'A'}">
                                        			<c:forEach items="${orgList}" var="item" varStatus="i">
		                                            <div class="field">
		                                                <div class="ui radio checkbox">
		                                                    <input type="radio" id="chk${item.codeCd}" name="crsTypeCd" value="${item.codeCd}" tabindex="0" class="hidden" <c:choose><c:when test="${i.first}">checked</c:when></c:choose>>
		                                                    <label for="chk${item.codeCd}">${item.codeNm}</label>
		                                                </div>
		                                            </div>
				                                    </c:forEach>	
                                        		</c:when>
                                        	</c:choose>
                                        </div>
                                    </dd>
                                </dl>
                            </li>
                            <li>
                                <dl>
                                    <dt><label for="teamLabel" class="req"><spring:message code="crs.crsnm" /></label></dt><!-- 과목명 -->
                                    <dd>
                                        <div class="ui action fluid input">
                                            <input type="text" id="crsNm" name="crsNm" placeholder="<spring:message code="crs.confirm.insert.course.name" />" value="${crsVo.crsNm}">
                                            <input type="hidden" name="crsNmOrigin" id="crsNmOrigin" value="${crsVo.crsNm}">
                                            <input type="hidden" name="chkDup" id="chkDup">
                                            <button class="ui black button" data-toggle="modal" data-target="#modal-team-target" onclick="crsNmCheck(); return false;"><spring:message code="user.title.userjoin.dub.confirm" /></button><!-- 중복확인 -->
                                        </div>
                                    </dd>
                                </dl>
                            </li>
                            <li>
                                <dl>
                                    <dt><label for="taskTypeLabel" class="req"><spring:message code="crs.label.lecture.method" /></label></dt>
                                    <dd>
                                        <select class="ui dropdown" id="crsOperTypeCd" name="crsOperTypeCd">
                                        	<option value=""><spring:message code="dashboard.cal_select" /></option><!-- 선택 -->
                                            <option value="ONLINE"
												<c:if test="${crsVo.crsOperTypeCd eq 'ONLINE'}">selected</c:if>><spring:message code="common.label.online" /></option><!-- 온라인 -->
											<option value="OFFLINE"
												<c:if test="${crsVo.crsOperTypeCd eq 'OFFLINE'}">selected</c:if>><spring:message code="common.label.offline" /></option><!-- 오프라인 -->
											<option value="MIX"
												<c:if test="${crsVo.crsOperTypeCd eq 'MIX'}">selected</c:if>><spring:message code="common.label.blend" /></option><!-- 혼합 -->
                                        </select>
                                    </dd>
                                </dl>
                            </li>
                            <li>
                                <dl>
                                    <dt><label><spring:message code="common.label.use.type.yn" /></label></dt><!-- 사용 여부 -->
                                    <dd>
                                        <div class="fields">
                                            <div class="field">
                                                <div class="ui radio checkbox">
                                                    <input type="radio" id="useY" name="useYn" value="Y" tabindex="0" class="hidden" <c:choose><c:when test="${crsVo.useYn eq 'Y'}">checked</c:when><c:otherwise>checked</c:otherwise></c:choose>>
                                                    <label for="useY"><spring:message code="forum.label.use.y" /></label><!-- 사용 -->
                                                </div>
                                            </div>
                                            <div class="field">
                                                <div class="ui radio checkbox">
                                                    <input type="radio" id="useN" name="useYn" value="N" tabindex="0" class="hidden" <c:choose><c:when test="${crsVo.useYn eq 'N'}">checked</c:when></c:choose>>
                                                    <label for="useN"><spring:message code="forum.label.use.n" /></label><!-- 미사용 -->
                                                </div>
                                            </div>
                                        </div>
                                    </dd>
                                </dl>
                            </li>
                            <li>
                                <dl class="row">
                                    <dt><label for="contentTextArea"><spring:message code="crs.title.subject.description" /></label></dt><!-- 과목 설명 -->
                                    <dd style="height:400px">
	            						<div style="height:100%">
                                    		<textarea name="crsDesc" id="crsDesc">${crsVo.crsDesc}</textarea>
                                    		<script>
	                                        // html 에디터 생성
	                                	  	var editor = HtmlEditor('crsDesc', THEME_MODE, '/crs');
	                                    	</script>
                                    	</div>
                                    </dd>
                                </dl>
                            </li>
                        </ul> 
                        </form>
						<!-- 하단 버튼 -->
		                <div class="button-area tr mt40">
		                    <a href="#0" class="ui blue button" onclick="onSave();">
								<c:choose>
									<c:when test="${crsVo.gubun eq 'E'}">
										<spring:message code="exam.button.mod" /><!-- 수정 -->
									</c:when>
									<c:otherwise>
										<spring:message code="exam.button.save" /><!-- 저장 -->
									</c:otherwise>
								</c:choose>
		                    </a>
		                    <a href="/crs/crsMgr/crsListMain.do" class="ui basic button fl"><spring:message code="exam.button.cancel" /></a><!-- 취소 -->
		                </div>
                	</div>
                </div><!-- //ui form -->
            </div><!-- //content -->
        </div><!-- //container -->
    
    	<!-- footer -->
    	<%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
    	
    </div><!-- //wrap -->
</body>
</html>