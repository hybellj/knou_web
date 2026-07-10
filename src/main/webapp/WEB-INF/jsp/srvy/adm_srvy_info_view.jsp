<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/srvy/common/srvy_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="admin"/>
		<jsp:param name="module" value="table"/>
	</jsp:include>

	<script type="text/javascript">
		// 전체설문수정화면이동
		function srvyModifyView() {
			if("${vo.srvyPrgrsSts}" == "PRE_SRVY") {
				srvyViewMv('${vo.srvyId}', 'ADMMODIFY');	// 관리자 전체설문 수정 화면
			} else {
				UiComm.showMessage("<spring:message code='srvy.alert.already.start.all.srvy.modify' />", "info");/* 전체설문이 시작되어 수정이 불가능합니다. */
			}
		}

		/*
		 * 설문지미리보기팝업
		 * @param srvyId	설문아이디
		 * @param upSrvyId	상위설문아이디
		 */
		function srvypprPreviewPopup() {
			 dialog = UiDialog("dialog1", {
				title		: "<spring:message code='srvy.label.preview.all.srvy.srvyppr' />",/* 전체설문 설문지 미리보기 */
				url			: "/srvy/admSrvypprPreviewPopup.do?upSrvyId=${vo.srvyId}&srvyId=${vo.srvyId}&searchValue=WHOL",
				fullscreen	: true
			});
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

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="admin_sub">
                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">${uiex:getCurMenunm()}</h2>
                            <uiex:navibar type="admin"/>
                        </div>

                        <div class="board_top">
							<div class="right-area">
								<button type="button" class="btn type2 big" onclick="srvypprPreviewPopup()"><spring:message code="srvy.button.preview" /><!-- 미리보기 --></button>
								<button type="button" class="btn type2 big" onclick="srvyViewMv('${vo.srvyId}', 'ADMQSTN')"><spring:message code="srvy.button.qstn" /><!-- 문항관리 --></button>
								<button type="button" class="btn type2 big" onclick="srvyModifyView()"><spring:message code="srvy.button.modify" /><!-- 수정 --></button>
								<button type="button" class="btn type2 big" onclick="srvyViewMv('', 'ADMLIST')"><spring:message code="srvy.button.list" /><!-- 목록 --></button>
							</div>
						</div>

						<!--table-type-->
						<div class="table-wrap">
							<table class="table-type5">
								<colgroup>
									<col class="width-15per" />
									<col class="" />
								</colgroup>
								<tbody>
									<tr>
										<th><label class="req"><spring:message code="srvy.label.org" /><!-- 기관 --></label></th>
										<td>${vo.orgnm }</td>
									</tr>
									<tr>
										<th><label class="req"><spring:message code="srvy.label.smstr" /><!-- 학기 --></label></th>
										<td>${vo.smstrChrtnm }</td>
									</tr>
									<tr>
										<th><label for="trgtWhol" class="req"><spring:message code="common.object" /><!-- 대상 --></label></th>
										<td>
											<c:choose>
												<c:when test="${vo.srvyTrgtTycd eq 'ALL' }">
													<spring:message code="srvy.common.all" /><!-- 전체 -->
												</c:when>
												<c:otherwise>
													${vo.srvyTrgtTynm }
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
									<tr>
										<th><label for="srvyTtl" class="req"><spring:message code="srvy.label.all.srvy.ttl" /><!-- 전체설문 제목 --></label></th>
										<td>${vo.srvyTtl }</td>
									</tr>
									<tr>
								       	<th><label for="srvyCts" class="req"><spring:message code="srvy.label.all.srvy.cts" /><!-- 전체설문 설명 --></label></th>
								       	<td>${vo.srvyCts }</td>
									</tr>
									<tr>
										<th><label for="dateSt" class="req"><spring:message code="srvy.label.all.srvy.period" /><!-- 전체설문기간 --></label></th>
										<td><uiex:formatDate value="${vo.srvySdttm}" type="datetime2"/> ~ <uiex:formatDate value="${vo.srvyEdttm}" type="datetime2"/></td>
									</tr>
									<tr>
										<th><label for="rsltOpen"><spring:message code="srvy.label.view.result" /><!-- 결과조회 --></label></th>
										<td>
											<c:choose>
												<c:when test="${vo.rsltOpenTycd eq 'WHOL_OPEN' }">
													<spring:message code="srvy.common.yes" /><!-- 예 -->
												</c:when>
												<c:otherwise>
													<spring:message code="srvy.common.no" /><!-- 아니오 -->
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<!--//table-type-->
                    </div>
                </div>
            </div>
            <!-- //content -->
        </main>
        <!-- //admin-->
    </div>
</body>
</html>