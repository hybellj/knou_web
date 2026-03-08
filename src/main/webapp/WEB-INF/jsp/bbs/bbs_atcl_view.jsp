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
		<jsp:param name="module" value="table"/>
	</jsp:include>

	<!-- 게시판 공통 -->
	<jsp:include page="/WEB-INF/jsp/bbs/common/bbs_common_inc.jsp"/>

	<script type="text/javascript">
		// 게시글 수정 이동
		function moveAtclEdit() {
			document.location.href = "/bbs/${templateUrl}/bbsAtclView.do?eparam=${eparam}&gubun=edit";
		}

        // 게시글 목록 이동
        function moveAtclList() {
            document.location.href = "/bbs/${templateUrl}/bbsAtclListView.do?eparam=${eparam}";
        }

        // 게시글 이동
        function moveActlView(atclId) {
			let extParam = UiComm.makeExtParam({"atclId":atclId});
        	document.location.href = "/bbs/${templateUrl}/bbsAtclView.do?eparam=${eparam}&extParam="+extParam;
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
                            <h2 class="page-title"><span>메시지함</span>PUSH</h2>
                            <div class="navi_bar">
                                <ul>
                                    <li><i class="xi-home-o" aria-hidden="true"></i><span class="sr-only">Home</span></li>
                                    <li>공지사항</li>
                                    <li><span class="current">전체공지</span></li>
                                </ul>
                            </div>
                        </div>

                        <div class="tstyle_view">
                            <div class="title_header">
                                <div class="title">${bbsAtclVO.atclTtl}</div>
                                <ul class="head">
                                    <li class="write"><strong>작성자</strong><span>${bbsAtclVO.rgtrnm}</span></li>
                                    <li class="date"><strong>작성일</strong><span><uiex:formatDate value="${bbsAtclVO.regDttm}" type="datetime"/></span></li>
                                    <li class="hit"><strong>조회수</strong><span>${bbsAtclVO.inqCnt}</span></li>
                                    <li class="hit"><strong>댓글</strong><span>${bbsAtclVO.cmntCnt}</span></li>
                                </ul>
                            </div>

                            <div class="tb_contents">
                                ${bbsAtclVO.atclCts}
                            </div>

							<%-- 첨부파일 --%>
							<c:if test="${not empty bbsAtclVO.fileList}">
								<div class="add_file_list">
	                            	<uiex:filedownload fileList="${bbsAtclVO.fileList}"/>
	                            </div>
							</c:if>

	                        <ul class="list_board">
	                        	<%-- 이전글 --%>
	                        	<c:if test="${not empty bbsAtclVO.prevAtclId}">
									<li class="prev">
										<span><spring:message code="bbs.label.prev_atcl" /></span>
										<a href="#0" onclick="moveActlView('${bbsAtclVO.prevAtclId}');return false;" title="${bbsAtclVO.prevAtclTtl}">${bbsAtclVO.prevAtclTtl}</a>
									</li>
								</c:if>
								<%-- 다음글 --%>
								<c:if test="${not empty bbsAtclVO.nextAtclId}">
									<li class="next">
										<span><spring:message code="bbs.label.next_atcl" /></span>
										<a href="#0" onclick="moveActlView('${bbsAtclVO.nextAtclId}');return false;" title="${bbsAtclVO.nextAtclTtl}">${bbsAtclVO.nextAtclTtl}</a>
									</li>
								</c:if>
	                        </ul>

                        </div>

                        <div class="btns">
                            <c:if test="${atclEditAuth eq 'Y'}">
		                        <a href="#0" onclick="moveAtclEdit();return false;" class="btn type1"><spring:message code="common.button.modify" /></a><!-- 수정 -->
							</c:if>

							<c:if test="${atclDeleteAuth eq 'Y'}">
		                        <a href="#0" onclick="removeAtcl();return false;" class="btn type2"><spring:message code="common.button.delete" /></a><!-- 삭제 -->
		                    </c:if>

	                    	<a href="#0" onclick="moveAtclList();return false;" class="btn type2"><spring:message code="common.button.list" /></a><!-- 목록 -->
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