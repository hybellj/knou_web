<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
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
			if(${fn:length(srvypprList) > 1}) {
				controllNextPrevBtn();
			}
		});

		/**
		 *  이전 다음 버튼 표시
		 */
		function controllNextPrevBtn() {
		    var curSeqno = Number($("div.srvypprDiv:visible").attr("data-seqno"));
		    var srvypprCnt   = $("div.srvypprDiv").length;

		    $("div.srvypprDiv").hide();
		    $("div.srvypprDiv[data-seqno=1]").show();
		    $("#btnPrevSrvyppr").hide();
		    $("#btnNextSrvyppr").hide();
		    if (curSeqno > 1) {
		        $("#btnPrevSrvyppr").show();
		    }
		    if (curSeqno < srvypprCnt) {
		        $("#btnNextSrvyppr").show();
		    }
		}

		/**
		 *  이전 버튼 클릭 시 앞 설문지로 이동
		 */
		function goPrevSrvyppr() {
		    var curSrvyppr   = $("div.srvypprDiv:visible");
		    var curSrvySeqno = Number(curSrvyppr.attr("data-seqno"));
		    if (curSrvySeqno > 1) {
		        $("#btnNextSrvyppr").show();
		        $("div.srvypprDiv").hide();
		        $("div.srvypprDiv[data-seqno=" + (curSrvySeqno - 1) + "]").show();
		        if (curSrvySeqno - 1 == 1) {
		            $("#btnPrevSrvyppr").hide();
		        }
		    }
		}

		/**
		 *  다음 버튼 클릭 시 뒤 설문지로 이동
		 */
		function goNextSrvyppr() {
		    var curSrvyppr   = $("div.srvypprDiv:visible");
		    var curSrvySeqno = Number(curSrvyppr.attr("data-seqno"));

		    var srvypprCnt = $("div.srvypprDiv").length;
		    if (curSrvySeqno < srvypprCnt) {
		        $("#btnPrevSrvyppr").show();
		        $("div.srvypprDiv").hide();
		        $("div.srvypprDiv[data-seqno=" + (curSrvySeqno + 1) + "]").show();
		        if (curSrvySeqno + 1 == srvypprCnt) {
		            $("#btnNextSrvyppr").hide();
		        }
		    }
		}

		// 기타 항목 체크
		function etcInptCheck(srvyQstnId) {
			var isEtc = true;
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
			var data = "upSrvyId=${vo.srvyId}&srvyId="+srvyId;

			window.parent.$(".ui-dialog:visible iframe").last().attr("src", "/srvy/profSrvypprPreviewPopup.do?"+data);
		}
	</script>

	<body class="modal-page">
        <div id="wrap">
        	<c:if test="${vo.srvyGbn eq 'SRVY_TEAM' }">
				<div class="top-content">
					<c:forEach var="item" items="${srvyTeamList }">
						<button class="btn ${item.srvyId eq vo.subSrvyId ? 'type1' : 'type2' }" name="teamButton" value="${item.srvyId }" onclick="srvyTeamSelect('${item.srvyId }')">${item.teamnm }</button>
					</c:forEach>
				</div>
			</c:if>

			<%@ include file="/WEB-INF/jsp/srvy/common/srvy_qstn_inc.jsp" %>

			<div class="btns">
            	<c:if test="${fn:length(srvypprList) > 1}">
            		<a href="javascript:goPrevSrvyppr();" class="btn type2" id="btnPrevSrvyppr">이전</a>
            		<a href="javascript:goNextSrvyppr();" class="btn type2" id="btnNextSrvyppr">다음</a>
            	</c:if>
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="resh.button.close" /></button><!-- 닫기 -->
             </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
