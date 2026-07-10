<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>

	<script type="text/javascript">
        let EPARAM = '<c:out value="${encParams}" />';
        const orgId = '<c:out value="${vo.orgId}" />';

		// 목록 이동
		function moveToList() {
			let form = $("<form></form>");
			form.attr("method", "GET");
			form.attr("name", "moveForm");
			form.attr("action", "/org/orgMgr/admOrgListView.do");
			form.appendTo("body");
			form.submit();
		}

		// 수정 이동
		function moveToEdit() {
			/*let form = $("<form></form>");
			form.attr("method", "GET");
			form.attr("name", "moveForm");
			form.attr("action", "/org/orgMgr/admOrgModifyView.do?orgId="+orgId+"&encParams="+EPARAM);
			form.appendTo("body");
			form.submit();*/
            document.location.href = "/org/orgMgr/admOrgModifyView.do?orgId="+orgId+"&encParams="+EPARAM;
		}
	</script>
</head>
<body class="admin">
    <div id="wrap" class="main">
        <!-- common header -->
        <%@ include file="/WEB-INF/jsp/common_new/admin_header.jsp" %>
        <!-- //common header -->

        <!-- admin -->
        <main class="common">

            <!-- gnb -->
            <%@ include file="/WEB-INF/jsp/common_new/admin_aside.jsp" %>
            <!-- //gnb -->

        	<!-- 본문 content 부분 -->
            <div id="content" class="content-wrap common">
                <div class="admin_sub_top">
                    <div class="date_info">
                        <i class="icon-svg-calendar" aria-hidden="true"></i><span class="sr-only">Home</span><spring:message code="common.label.org.mgr" /><%--기본 정보 관리--%>
                    </div>
                </div>
                <div class="admin_sub">
                    <div class="sub-content">

                        <div class="box">
                            <div class="board_top">
                                <h3 class="board-title"><spring:message code="button.view.detail"/> </h3><%--상세보기--%>
                            </div>
                            <!--table-view-->
                            <div class="table_list">
                                <ul class="list">
                                    <li class="head"><label><spring:message code='common.label.org.id'/><%--기관 ID--%> </label></li>
                                    <li>${vo.orgId}</li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label><spring:message code='common.label.org.name.full'/><%--기관 Full Name--%></label></li>
                                    <li>${vo.orgnm}</li>

                                </ul>
                                <ul class="list">
                                    <li class="head"><label><spring:message code='common.label.org.name.short'/><%--기관 Short Name--%></label></li>
                                    <li>${vo.orgShrtnm}</li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label><spring:message code='common.label.org.type'/><%--기관 유형--%></label></li>
                                    <li>${vo.orgTycdnm}</li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label><spring:message code="common.label.org.url.homepage"/> <%--홈페이지 URL--%></label></li>
                                    <li>${vo.hmpgUrl}</li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label><spring:message code='common.label.org.chrgr.nm'/><%--담당자명--%></label></li>
                                    <li>${vo.chrgrnm}</li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label><spring:message code='common.label.org.chrgr.nm'/> <spring:message code='common.label.contact.info'/><%--담당자 연락처--%></label></li>
                                    <li>${vo.chrgrCntct}</li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label><spring:message code='common.label.org.chrgr.nm'/> <spring:message code='common.email'/><%--담당자 이메일--%></label></li>
                                    <li>${vo.chrgrEml}</li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label><spring:message code="common.label.contact.office"/> <%--사무실 전화번호--%></label></li>
                                    <li>${vo.ofcTelno}</li>
                                </ul>
                                <ul class="list">
                                    <li class="head">
                                        <label>
                                            <spring:message code="common.label.org.logo.pc" /><%--기관 로고 PC--%>
                                            <br/><spring:message code="common.label.org.logo.size" /><%--(로고 이미지: 294 * 41) --%>
                                        </label>
                                    </li>
                                    <li>
<%--                                        <mg src="<%=request.getContextPath()%>/webdoc/assets/img/logo.svg" aria-hidden="true" alt="한국방송통신대학교">--%>
                                        <c:if test="${not empty vo.fileList}">
                                            <div class="add_file_list">
                                                <uiex:filedownload fileList="${vo.fileList}"/>
                                            </div>
                                        </c:if>
                                    </li>
                                </ul>
  <%--                              <ul class="list">
                                    <li class="head"><label><spring:message code="common.label.org.logo.pc" />&lt;%&ndash;기관 로고 Mobile&ndash;%&gt;</label></li>
                                    <li>&lt;%&ndash;<img src="<%=request.getContextPath()%>/webdoc/assets/img/logo_mobile.png" aria-hidden="true" alt="한국방송통신대학교">&ndash;%&gt;</li>
                                </ul>--%>
                            </div>
                        </div>

                        <div class="box">
                            <div class="board_top">
                                <h3 class="board-title"><spring:message code="common.label.content.footer" /><%--하단 문구--%></h3>
                            </div>
                            <!--table-view-->
                            <div class="table_list">
                                <ul class="list">
                                    <li class="head"><label><spring:message code="common.label.post.no" /><%--우편번호--%></label></li>
                                    <li>${vo.zipCd}</li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label><spring:message code="common.label.address" /><%--주소--%></label></li>
                                    <li>
                                        ${vo.addr1}<br>
                                        ${vo.addr2}
                                    </li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label><spring:message code="common.lable.contact.main" /><%--대표전화--%></label></li>
                                    <li>${vo.rprsTelno}</li>
                                </ul>
                                <ul class="list">
                                    <li class="head"><label><spring:message code="common.copyright" /><%--CopyRight--%></label></li>
                                    <li>${vo.cprghtCts}</li>
                                </ul>
                            </div>
                        </div>

                        <div class="btns">
                            <button type="button" class="btn type1" onclick="moveToEdit()">수정</button>
                            <button type="button" class="btn type2" onclick="moveToList()">목록</button>
                        </div>


                    </div>

                </div>
                <!-- //ui form -->
            </div>
            <!-- //본문 content 부분 -->
        </main>
    </div>
</body>
</html>