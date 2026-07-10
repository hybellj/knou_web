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
		$(document).ready(function () {
			sbjctListSelect();
		});

		// 과목목록조회
		function sbjctListSelect() {
			const url = "/srvy/admSrvyLctrEvlRegistSbjctListAjax.do";
			const data = {
				srvyId 	: "${vo.srvyId}"
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
                	let returnList = data.returnList || [];
                	let dataList = [];

	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
	        				dataList.push({
	        					orgnm: 		v.orgnm,
	        					sbjctCd: 	v.sbjctCd,
	        					sbjctnm: 	v.sbjctnm,
	        					dvclasNo: 	v.dvclasNo,
	        					profnm: 	v.profnm,
	        					tutnm: 		v.tutnm,
	        					sbjctId:	v.sbjctId
	    					});
	        			});
	        		}

	        		sbjctListTable.clearData();
	        		sbjctListTable.replaceData(dataList);
                } else {
                	UiComm.showMessage(data.message, "error");
                }
    		}, function(xhr, status, error) {
    			UiComm.showMessage("<spring:message code='srvy.error.list' />", "error");	/* 리스트 조회 중 에러가 발생하였습니다. */
    		}, true);
		}

		// 강의평가수정화면이동
		function srvyModifyView() {
			if("${vo.srvyPrgrsSts}" == "PRE_SRVY") {
				srvyViewMv('${vo.srvyId}', 'ADMEVLMODIFY');	// 관리자 설문 강의평가 수정 화면
			} else {
				UiComm.showMessage("<spring:message code='srvy.alert.already.start.lctr.evl.modify' />", "info");/* 강의평가가 시작되어 수정이 불가능합니다. */
			}
		}

		/*
		 * 설문지미리보기팝업
		 * @param srvyId	설문아이디
		 * @param upSrvyId	상위설문아이디
		 */
		function srvypprPreviewPopup(srvyId) {
			 dialog = UiDialog("dialog1", {
				title		: "<spring:message code='srvy.label.preview.lctr.evl.srvyppr' />",/* 강의평가 설문지 미리보기 */
				url			: "/srvy/admSrvypprPreviewPopup.do?upSrvyId=${vo.srvyId}&srvyId=${vo.srvyId}&searchValue=LCTR",
				fullscreen	: true
			});
		}

		/*
		 * 강의평가관리팝업
		 * @param srvyId	설문아이디
		 */
		function lctrEvlMngPopup() {
			dialog = UiDialog("dialog1", {
				title		: "<spring:message code='srvy.button.lctr.evl.popup' />",/* 강의평가 팝업관리 */
				width		: 900,
				height		: 500,
				url			: "/srvy/admSrvyLctrEvlMngPopup.do?srvyId=${vo.srvyId}",
				autoresize	: true
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
							<h3 class="board-title"><spring:message code="srvy.label.view.detail" /><!-- 상세보기 --></h3>
							<div class="right-area">
								<button type="button" class="btn type2 big" onclick="lctrEvlMngPopup()"><spring:message code="srvy.button.lctr.evl.popup" /><!-- 강의평가 팝업관리 --></button>
								<button type="button" class="btn type2 big" onclick="srvypprPreviewPopup()"><spring:message code="srvy.button.preview" /><!-- 미리보기 --></button>
								<button type="button" class="btn type2 big" onclick="srvyViewMv('${vo.srvyId}', 'ADMEVLQSTN')"><spring:message code="srvy.button.qstn" /><!-- 문항관리 --></button>
								<button type="button" class="btn type2 big" onclick="srvyViewMv('${vo.srvyId}', 'ADMEVLRSLT')"><spring:message code="srvy.button.evl.result" /><!-- 평가결과 --></button>
								<button type="button" class="btn type2 big" onclick="srvyModifyView()"><spring:message code="srvy.button.modify" /><!-- 수정 --></button>
								<button type="button" class="btn type2 big" onclick="srvyViewMv('', 'ADMEVLLIST')"><spring:message code="srvy.button.list" /><!-- 목록 --></button>
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
										<th><label for="trgtWhol" class="req"><spring:message code="common.label.ctgr" /><!-- 분류 --></label></th>
										<td>${vo.srvyTrgtGbnnm }</td>
									</tr>
									<tr>
										<th colspan="2"><label class="req"><spring:message code="srvy.label.select.sbjct" /><!-- 과목 선택 --></label></th>
									</tr>
								</tbody>
							</table>
							<div id="list"></div>
							<script>
								// 리스트 테이블
								let sbjctListTable = UiTable("list", {
									lang: "ko",
									height: 250,
									columns: [
										{title:"<spring:message code='srvy.label.org' />", 				field:"orgnm",			headerHozAlign:"center", hozAlign:"center", width:150,	minWidth:150},/* 기관 */
										{title:"<spring:message code='common.label.crsauth.crscd' />", 	field:"sbjctCd",		headerHozAlign:"center", hozAlign:"center",	width:150,	minWidth:150},/* 과목코드 */
										{title:"<spring:message code='srvy.label.sbjct.nm' />", 		field:"sbjctnm", 		headerHozAlign:"center", hozAlign:"left", 	width:0, 	minWidth:280},/* 과목명 */
										{title:"<spring:message code='srvy.label.dvclas' />", 			field:"dvclasNo", 		headerHozAlign:"center", hozAlign:"center", width:50,	minWidth:50},/* 분반 */
										{title:"<spring:message code='common.charge.professor' />", 	field:"profnm", 		headerHozAlign:"center", hozAlign:"center", width:120,	minWidth:120},/* 담당교수 */
										{title:"<spring:message code='srvy.label.charge.tutor' />", 	field:"tutnm",	 		headerHozAlign:"center", hozAlign:"center", width:120,	minWidth:120}/* 담당튜터 */
									]
								});
							</script>
		                    <table class="table-type5">
								<colgroup>
									<col class="width-15per" />
									<col class="" />
								</colgroup>
								<tbody>
									<tr>
										<th><label for="srvyTtl" class="req"><spring:message code="srvy.label.lctr.evl.ttl" /><!-- 강의평가 제목 --></label></th>
										<td>${vo.srvyTtl }</td>
									</tr>
									<tr>
								       	<th><label for="srvyCts" class="req"><spring:message code="srvy.label.lctr.evl.cts" /><!-- 강의평가 내용 --></label></th>
								       	<td>${vo.srvyCts }</td>
									</tr>
									<tr>
										<th><label for="srvyMidExam" class="req"><spring:message code="srvy.label.lctr.evl.type" /><!-- 강의평가 구분 --></label></th>
										<td>
											<c:choose>
												<c:when test="${fn:contains(vo.srvyTycd, 'MIDEXAM') }">
													<spring:message code="srvy.label.mid.exam" /><!-- 중간고사 -->
												</c:when>
												<c:otherwise>
													<spring:message code="srvy.label.lst.exam" /><!-- 기말고사 -->
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
									<tr>
										<th><label for="dateSt" class="req"><spring:message code="srvy.label.lctr.evl.period" /><!-- 강의평가기간 --></label></th>
										<td><uiex:formatDate value="${vo.srvySdttm}" type="datetime2"/> ~ <uiex:formatDate value="${vo.srvyEdttm}" type="datetime2"/></td>
									</tr>
									<tr>
										<th><label for="srvyAcad" class="req"><spring:message code="srvy.label.manage.type" /><!-- 관리구분 --></label></th>
										<td>${vo.srvyWrtTynm }</td>
									</tr>
									<c:if test="${vo.srvyWrtTycd eq 'ACAD_LINK_SRVY' }">
										<tr>
											<th><label><spring:message code="srvy.label.sync.url" /><!-- 연동 URL --></label></th>
											<td>url</td>
										</tr>
									</c:if>
									<spring:message code="srvy.common.yes" var="yes" /><!-- 예 -->
									<spring:message code="srvy.common.no" var="no" /><!-- 아니오 -->
									<tr>
										<th><label for="mrkY"><spring:message code="srvy.label.lctr.evl.score.view" /><!-- 강의평가 후 성적조회 --></label></th>
										<td>${vo.mrkOyn eq 'Y' ? yes : no }</td>
									</tr>
									<tr>
										<th><label for="rsltOpen"><spring:message code="srvy.label.lctr.evl.view.result" /><!-- 강의평가 결과조회 --></label></th>
										<td>${vo.rsltOpenTycd eq 'WHOL_OPEN' ? yes : no }</td>
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