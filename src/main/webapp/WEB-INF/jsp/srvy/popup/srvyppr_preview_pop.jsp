<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/srvy/common/srvy_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
			<jsp:param name="style" value="classroom"/>
			<jsp:param name="module" value="table"/>
		</jsp:include>
    </head>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<script type="text/javascript">
		$(document).ready(function() {
			UiComm.showLoading(false);
			if(${fn:length(srvypprList) > 1}) {
				initSrvyppr();
			}
		});

		function initSrvyppr() {
			showSrvyppr(1);
		}

		// 해당 순번 설문지 표시 및 버튼 제어
		function showSrvyppr(seqno) {
			let srvypprCnt = $("div.srvypprDiv").length;

			$("div.srvypprDiv").hide();
			$("div.srvypprDiv[data-seqno=" + seqno + "]").show();
			$(".listPage > label").text(seqno);

			$("#btnPrevSrvyppr").toggle(seqno > 1);
			$("#btnNextSrvyppr").toggle(seqno < srvypprCnt);
		}

		// 이전 설문지로 이동
		function goPrevSrvyppr() {
			let curSeqno = Number($("div.srvypprDiv:visible").attr("data-seqno"));
			if (curSeqno > 1) {
				showSrvyppr(curSeqno - 1);
				dialogHeightChange();
			}
		}

		// 다음 설문지로 이동
		function goNextSrvyppr() {
			let curSeqno = Number($("div.srvypprDiv:visible").attr("data-seqno"));
			let srvypprCnt = $("div.srvypprDiv").length;
			if (curSeqno < srvypprCnt) {
				showSrvyppr(curSeqno + 1);
				dialogHeightChange();
			}
		}

		// 기타 항목 체크
		function etcInptCheck(srvyQstnId) {
			let isEtc = true;
			$("input[name='"+srvyQstnId+"_chc']:checked").each(function(i) {
				if(this.value == "ETC") {
					isEtc = false;
				}
			});

			$("input[id='"+srvyQstnId+"_etc']").attr("readonly", isEtc);
		}

		/**
		* 설문 팀 선택
		* @param {String}  srvyId - 선택 팀에 대한 설문아이디
		*/
		function srvyTeamSelect(srvyId) {
			UiComm.showLoading(true);
			const data = "upSrvyId=${vo.srvyId}&srvyId="+srvyId+"&searchValue=GNRL";

			window.parent.$(".ui-dialog:visible iframe").last().attr("src", "/srvy/profSrvypprPreviewPopup.do?"+data);
		}
	</script>

	<body class="modal-page">
        <div id="wrap">
        	<div class="listTab flex align-items-center">
	        	<c:if test="${vo.srvyGbn eq 'SRVY_TEAM' }">
                    <ul>
                    	<c:forEach var="item" items="${srvyTeamList }">
                    		<li class="${item.srvyId eq vo.subSrvyId ? 'select' : '' }"><a name="teamButton" value="${item.srvyId }" onclick="srvyTeamSelect('${item.srvyId }')">${item.teamnm }</a></li>
                    	</c:forEach>
                    </ul>
				</c:if>
                <div class="listPage width-100per text-right"><label>1</label>/${fn:length(srvypprList) } <spring:message code="srvy.label.page" /><!-- 페이지 --></div>
            </div>

			<%@ include file="/WEB-INF/jsp/srvy/common/srvy_qstn_inc.jsp" %>

			<div class="modal_btns">
            	<c:if test="${fn:length(srvypprList) > 1}">
            		<a href="javascript:goPrevSrvyppr();" class="btn type2" id="btnPrevSrvyppr"><spring:message code="srvy.button.prev" /><!-- 이전 --></a>
            		<a href="javascript:goNextSrvyppr();" class="btn type2" id="btnNextSrvyppr"><spring:message code="srvy.button.next" /><!-- 다음 --></a>
            	</c:if>
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="srvy.button.close" /></button><!-- 닫기 -->
        	</div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
