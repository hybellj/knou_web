<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/srvy/common/srvy_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="classroom"/>
		<jsp:param name="module" value="table"/>
	</jsp:include>

	<script type="text/javascript">
		$(document).ready(function () {
			// 강의평가대기 or 진행중일시
			if("${vo.srvyPrgrsSts }" != "DONE") {
				srvyLctrEvlPtcpHstryListSelect();	// 설문강의평가참여이력목록조회
			}
		});

		// 설문강의평가참여이력목록조회
		function srvyLctrEvlPtcpHstryListSelect() {
			const url   = "/srvy/srvyPtcpHstryListAjax.do";
			const data = {
				srvyId : "${vo.srvyId}"
			};

			ajaxCall(url, data, function (data) {
	            if (data.result > 0) {
	            	let dataList = createListHTML(data.returnList);	// 목록 HTML 생성

	            	listTable.clearData();
	        		listTable.replaceData(dataList);

	        		$("#ptcpDiv > .msg-box").toggle(data.returnList.length == 0);
	        		$("#ptcpDiv > #list").toggle(data.returnList.length > 0);
	            } else {
	                UiComm.showMessage(data.message, "error");
	            }
	        }, function (xhr, status, error) {
	        	UiComm.showMessage("<spring:message code='srvy.error.list' />", "error");/* 리스트 조회 중 에러가 발생하였습니다. */
	        }, true);
		}

		// 목록 HTML 생성
		function createListHTML(list) {
			let dataList = [];

			if(list.length == 0) return dataList;

			list.forEach(function(v,i) {
				dataList.push({
					no: 		v.lineNo,
					hstryGbnnm:	v.hstryGbnnm,
					ptcpSdttm: 	UiComm.formatDate(v.ptcpSdttm, "datetime"),
					ptcpEdttm: 	v.ptcpEdttm != null ? UiComm.formatDate(v.ptcpEdttm, "datetime") : "-"
				});
			});

			return dataList;
		}
	</script>
</head>

<body class="class ${uiex:getTheme()}">
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>
        <!-- //common header -->

        <!-- classroom -->
        <main class="common">

        	<!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_stu.jsp"/>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
				<!-- class_sub_top -->
				<jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>
				<!-- //class_sub_top -->

		        <div class="class_sub">
					<!-- class_info -->
					<jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>
					<!-- //class_info -->

		        	<div class="sub-content">
				        <div class="page-info">
				        	<h2 class="page-title">
                                <spring:message code="srvy.common.lctr.evl" /><!-- 강의평가 -->
                            </h2>
				        </div>

				        <div class="listTab">
					        <ul>
					            <li class="select"><a onclick="srvyViewMv('${vo.srvyId}', 'STDEVLVIEW', '${vo.upSrvyId }')"><spring:message code="srvy.tab.lctr.evl.ptcp" /><!-- 강의평가정보 및 참여 --></a></li>
					        </ul>
					    </div>

					    <div class="board_top">
				        	<h3 class="board-title"><spring:message code="srvy.tab.lctr.evl.ptcp" /><!-- 강의평가정보 및 참여 --></h3>
					        <div class="right-area">
								<a href="javascript:srvyViewMv('', 'STDEVLLIST')" class="btn type2 big"><spring:message code="srvy.button.list" /></a><!-- 목록 -->
					        </div>
				        </div>

				        <%--설문 정보--%>
	                    <jsp:include page="/WEB-INF/jsp/srvy/common/srvy_info_inc.jsp"/>
	                    <%--설문 정보--%>

                        <div class="board_top">
                            <h4 class="sub-title"><spring:message code="srvy.label.lctr.evl.ptcp" /><!-- 강의평가 참여 --></h4>
                        </div>

                        <div id="ptcpDiv">
                        	<c:choose>
                        		<c:when test="${vo.srvyPrgrsSts ne 'DONE' }">
		                        	<div class="msg-box">
										<p class="txt"><strong><spring:message code="srvy.label.notice" /><!-- 안내 --> : </strong><spring:message code="srvy.label.lctr.evl.not.ptcp.info" /><!-- 강의평가 참여 전입니다. 강의평가 참여하시기 바랍니다. --></p>
									</div>
		                        	<div id="list"></div>
			                        <script>
										// 리스트 테이블
										let listTable = UiTable("list", {
											lang: "ko",
											columns: [
												{title:"<spring:message code='common.no' />", 					field:"no",				headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},/* 번호 */
												{title:"<spring:message code='srvy.label.type' />", 			field:"hstryGbnnm",		headerHozAlign:"center", hozAlign:"center", width:0,	minWidth:200},/* 구분 */
												{title:"<spring:message code='srvy.label.lctr.evl.start' />", 	field:"ptcpSdttm",		headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:200},/* 강의평가 시작 */
												{title:"<spring:message code='srvy.label.lctr.evl.end' />", 	field:"ptcpEdttm",		headerHozAlign:"center", hozAlign:"center",	width:0,	minWidth:200},/* 강의평가 종료 */
											]
										});
									</script>
                        		</c:when>
                        		<c:otherwise>
                        			<table class="table-type5">
	                                    <colgroup>
	                                    	<col class="width-20per" />
	                                    	<col class="" />
	                                    </colgroup>
	                                    <tbody>
	                                    	<tr>
		                                   		<th><spring:message code="srvy.label.ptcp.dttm" /><!-- 참여 일시 --></th>
		                                   		<td><uiex:formatDate value="${vo.ptcpSdttm}" type="datetime2"/></td>
	                                    	</tr>
	                                    	<tr>
	                                    		<th><spring:message code="srvy.label.lctr.evl.result" /><!-- 강의평가 결과 --></th>
	                                    		<td>
	                                    			<button type="button" class="btn type1 small" onclick="popupOption.srvyResult('${vo.srvyId}', '${vo.upSrvyId}', '${vo.ptcpEdttm }', '', 'LCTR')"><spring:message code="srvy.button.lctr.evl.result" /><!-- 강의평가 결과 --></button>
	                                    		</td>
	                                    	</tr>
	                                    </tbody>
	                            	</table>
                        		</c:otherwise>
                        	</c:choose>
                        </div>

                        <c:if test="${vo.srvyPrgrsSts eq 'IN_PROGRESS' }">
	                        <div class="btns">
	                            <button type="button" class="btn type1" onclick="popupOption.lctrEvlPtcpInfo('${vo.srvyId}', '${vo.upSrvyId}')">
	                            	<c:choose>
	                            		<c:when test="${not empty vo.ptcpSdttm }">
	                            			<spring:message code="srvy.button.edit" /><!-- 수정하기 -->
	                            		</c:when>
	                            		<c:otherwise>
	                            			<spring:message code="srvy.button.ptcp" /><!-- 참여하기 -->
	                            		</c:otherwise>
	                            	</c:choose>
	                            </button>
	                        </div>
                        </c:if>
		        	</div>
		        </div>
            </div>
            <!-- //content -->
        </main>
        <!-- //classroom-->
    </div>
</body>
</html>