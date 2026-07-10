<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/srvy/common/srvy_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="dashboard"/>
		<jsp:param name="module" value="table"/>
	</jsp:include>

	<script type="text/javascript">
		$(document).ready(function () {
			refreshSrvyLctrEvlList();
		});

		// 설문강의평가목록갱신
		function refreshSrvyLctrEvlList() {
			selectOption.smstrChrt()
		    .then(() => selectOption.sbjct())
		    .then(() => srvyLctrEvlListSelect())
		    .catch(() => {});
		}

		/*
		 * 설문강의평가목록조회
		 * @param dgrsYr		학위연도
		 * @param smstrChrtId	학기기수아이디
		 * @param orgId			기관아이디
		 * @param sbjctId		과목아이디
		 */
		function srvyLctrEvlListSelect() {
			const url  = "/srvy/stdntMainSrvyLctrEvlListAjax.do";
			const data = {
				dgrsYr		: $("#dgrsYr").val(),
				smstrChrtId	: $("#smstrChrtId").val(),
				orgId		: $("#orgId").val(),
				sbjctId		: $("#sbjctId").val()
			};

			$.ajax({
                url			: url,
                type		: "POST",
                contentType	: "application/json",
                data		: JSON.stringify(data),
                dataType	: "json",
                beforeSend	: () => UiComm.showLoading(true),
                success		: function (data) {
                    if (data.result > 0) {
    	            	let dataList = createListHTML(data.returnList);	// 목록 HTML 생성

    	            	listTable.clearData();
    	        		listTable.replaceData(dataList);
                    } else {
                    	UiComm.showMessage(data.message, "error");
                    }
                },
                error		: () => UiComm.showMessage("<spring:message code='srvy.error.list' />", "error"),/* 리스트 조회 중 에러가 발생하였습니다. */
                complete	: () => UiComm.showLoading(false)
            });
		}

		// 목록 HTML 생성
		function createListHTML(list) {
			let dataList = [];

			if(list.length == 0) return dataList;

			list.forEach(function(v,i) {
				dataList.push({
					no: 			v.lineNo,
					sbjctYr: 		v.sbjctYr,
					sbjctSmstr: 	v.sbjctSmstr,
					orgnm: 			v.orgnm,
					sbjctnm: 		v.sbjctnm,
					dvclasNo: 		v.dvclasNo,
					crdts: 			v.crdts,
					profnm: 		v.profnm,
					tutnm: 			v.tutnm,
					assinm: 		v.assinm,
					midSrvy:		initBtn(v.midSrvyId, v.midUpSrvyId, v.midPtcpEdttm, v.midSrvyPrgrsSts, v.midRsltOpenTycd),
					lstSrvy:		initBtn(v.lstSrvyId, v.lstUpSrvyId, v.lstPtcpEdttm, v.lstSrvyPrgrsSts, v.lstRsltOpenTycd)
				});
			});

			return dataList;
		}

		// 버튼초기화
		function initBtn(srvyId, upSrvyId, ptcpEdttm, prgrsSts, rsltOpenTycd) {
			if (prgrsSts == "IN_PROGRESS") {
				return "<button type='button' class='btn basic small' onclick='popupOption.lctrEvlPtcpInfo(\"" + srvyId + "\", \"" + upSrvyId + "\")'><spring:message code='srvy.button.ptcp' /></button>";/* 참여하기 */
			} else if (prgrsSts == "DONE" && rsltOpenTycd == "WHOL_OPEN") {
				return "<button type='button' class='btn basic small' onclick='popupOption.srvyResult(\"" + srvyId + "\", \"" + upSrvyId + "\", \"" + (ptcpEdttm || "") + "\", \"\", \"LCTR\")'><spring:message code='srvy.button.result.view' /></button>";/* 결과보기 */
			}
			return "-";
		}
	</script>
</head>

<body class="home ${uiex:getTheme()} ${bodyClass}">
    <div id="wrap" class="main">
        <jsp:include page="/WEB-INF/jsp/common_new/home_header.jsp">
	        <jsp:param name="userId" value="${userCtx.userId}"/>
	    </jsp:include>

        <main class="common">

        	<!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_gnb_stu.jsp"/>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
				<div class="dashboard_sub">
					<div class="sub-content">
						<div class="page-info">
	                        <h2 class="page-title"><spring:message code="srvy.common.lctr.evl" /><!-- 강의평가 --></h2>
	                        <uiex:navibar type="main"/>
	                    </div>

	                    <div class="search-typeA">
	                    	<div class="item">
                                <span class="item_tit"><label for="smstrChrtId"><spring:message code="srvy.label.year.smstr" /><!-- 학사년도/학기 --></label></span>
                                <div class="itemList">
                                    <select class="form-select" id="dgrsYr" onchange="refreshSrvyLctrEvlList()">
                                    	<c:forEach var="year" items="${yearList }">
                                    		<option value="${year }" ${year eq curYear ? 'selected' : '' }>${year }</option>
                                    	</c:forEach>
                                    </select>
                                    <select class="form-select" id="smstrChrtId" onchange="srvyLctrEvlListSelect()">
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="orgId"><spring:message code="srvy.label.courses" /><!-- 수강과목 --></label></span>
                                <div class="itemList">
                                    <select class="form-select" id="orgId" onchange="refreshSrvyLctrEvlList()">
                                        <c:forEach var="org" items="${orgList }">
                                    		<option value="${org.orgId }" ${org.orgId eq userCtx.orgId ? 'selected' : '' }>${org.orgnm }</option>
                                    	</c:forEach>
                                    </select>
                                    <select class="form-select" id="sbjctId" onchange="srvyLctrEvlListSelect()">
                                    </select>
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="srvyLctrEvlListSelect()"><spring:message code="srvy.button.search" /><!-- 검색 --></button>
                            </div>
	                    </div>

	                    <div id="listDiv">
							<div class="board_top">
								<h3 class="board-title"><spring:message code="srvy.label.courses" /><!-- 수강과목 --></h3>
							</div>

							<div id="list"></div>

							<script>
								// 리스트 테이블
								let listTable = UiTable("list", {
									lang: "ko",
									columns: [
										{title:"No", 												field:"no",				headerHozAlign:"center", 	hozAlign:"center", 	width:40,		minWidth:40},
										{title:"<spring:message code='srvy.label.year' />", 		field:"sbjctYr",		headerHozAlign:"center", 	hozAlign:"center",	width:100,		minWidth:100},/* 년도 */
										{title:"<spring:message code='srvy.label.smstr' />", 		field:"sbjctSmstr",		headerHozAlign:"center", 	hozAlign:"center",	width:100,		minWidth:100},/* 학기 */
										{title:"<spring:message code='srvy.label.org' />", 			field:"orgnm", 			headerHozAlign:"center", 	hozAlign:"center",	width:100,		minWidth:100},/* 기관 */
										{title:"<spring:message code='srvy.label.sbjct.nm' />", 	field:"sbjctnm", 		headerHozAlign:"center", 	hozAlign:"left",	width:0,		minWidth:250},/* 과목명 */
										{title:"<spring:message code='srvy.label.dvclas' />", 		field:"dvclasNo", 		headerHozAlign:"center", 	hozAlign:"center",	width:100,		minWidth:100},/* 분반 */
										{title:"<spring:message code='srvy.label.credit' />", 		field:"crdts", 			headerHozAlign:"center", 	hozAlign:"center",	width:100,		minWidth:100},/* 학점 */
										{title:"<spring:message code='srvy.label.coprof' />", 		field:"profnm", 		headerHozAlign:"center", 	hozAlign:"center",	width:130,		minWidth:130},/* 공동교수 */
										{title:"<spring:message code='srvy.label.tut' />", 			field:"tutnm", 			headerHozAlign:"center", 	hozAlign:"center",	width:130,		minWidth:130},/* 튜터 */
										{title:"<spring:message code='srvy.label.assi' />", 		field:"assinm", 	 	headerHozAlign:"center", 	hozAlign:"center",	width:130,		minWidth:130},/* 조교 */
										{title:"<spring:message code='srvy.label.mid.lctr.evl' />", field:"midSrvy", 		headerHozAlign:"center", 	hozAlign:"center",	width:100,		minWidth:100},/* 중간 강의평가 */
										{title:"<spring:message code='srvy.label.lst.lctr.evl' />", field:"lstSrvy", 		headerHozAlign:"center", 	hozAlign:"center",	width:100,		minWidth:100}/* 기말 강의평가 */
									]
								});
							</script>
						</div>
					</div>
				</div>
            </div>
            <!-- //content -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_footer.jsp"/>
        </main>
    </div>
</body>
</html>