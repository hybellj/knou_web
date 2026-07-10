<%@ page import="knou.framework.common.ParamInfo" %>
<%@ page import="knou.framework.common.SubjectInfo" %>
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

    <script type="text/javascript">
    	$(document).ready(function(){
    		if(${not empty msg}) {
				window.parent.msgPop("${msg}");
			}

    		controllSubmitBtn();

    		if(${fn:length(srvypprList) > 1}) {
    			initSrvyppr();
			}
    	});

    	// 제출 버튼 표시
		function controllSubmitBtn() {
			let curSeqno 	= Number($("div.srvypprDiv:visible").attr("data-seqno"));
		    let srvypprCnt  = $("div.srvypprDiv").length;

		    $("#submitBtn").toggle(curSeqno == srvypprCnt);
		}

		function initSrvyppr() {
			showSrvyppr(1);
		}

		// 전체 설문지 개수 조회
		function getSrvypprCnt() {
			return $("div.srvypprDiv").length;
		}

		// 현재 설문지순번 조회
		function getCurSrvypprSeqno() {
			return Number($("div.srvypprDiv:visible").attr("data-seqno"));
		}

		// 해당 순번 설문지 표시 및 버튼 제어, 페이지 라벨 갱신
		function showSrvyppr(seqno) {
			let srvypprCnt = getSrvypprCnt();

			$("div.srvypprDiv").hide();
			$("div.srvypprDiv[data-seqno=" + seqno + "]").show();
			$(".listPage > label").text(seqno);

			$("#btnPrevSrvyppr").toggle(seqno !== 1);
			$("#btnNextSrvyppr").toggle(seqno !== srvypprCnt);
		}

		// 이전 설문지로 이동(점프페이지 제외)
		function goPrevSrvyppr() {
			let curSeqno = getCurSrvypprSeqno();

			if (curSeqno > 1) {
				let prevSeqno = Math.max(...$("div.srvypprDiv:not(.pass)").map(function() {
					return parseInt($(this).data("seqno"));
				}).get().filter(n => n < curSeqno));

				showSrvyppr(prevSeqno);
			}

			dialogHeightChange();
			controllSubmitBtn();
		}

		/**
		 * 분기문항에 따른 다음 설문지순번 계산
		 * @param curSrvyppr	현재 설문지 DOM
		 * @param curSeqno		현재 설문지 seqno
		 * @returns 다음 설문지순번, 마지막이면 "END"
		 */
		function calcNextSrvypprSeqno(curSrvyppr, curSeqno) {
			let nextSeqno = curSeqno + 1;

			curSrvyppr.find(".question_con[data-mvmn='Y']").each(function() {
				let minSeqno = 9999;

				$(this).find("input[name$=chc]:checked").each(function() {
					const mvmnPprId = $(this).attr("data-mvmnPpr");

					if (mvmnPprId === "NEXT") {
						nextSeqno = curSeqno + 1;
					} else if (mvmnPprId === "END") {
						nextSeqno = "END";
						return false; // each 중단
					} else {
						const seqno = Number($("div.srvypprDiv[data-id='" + mvmnPprId + "']").attr("data-seqno"));
						if (minSeqno > seqno) minSeqno = seqno;
					}
				});

				if (nextSeqno === "END") return false; // each 중단
				if (minSeqno !== 9999) nextSeqno = minSeqno;
			});

			return nextSeqno;
		}

		/**
		 * 건너뛴 구간에 pass 클래스 표시/해제
		 * @param curSeqno	현재 설문지순번
		 * @param nextSeqno	이동할 설문지순번
		 */
		function markPassedSrvyppr(curSeqno, nextSeqno) {
			const srvypprDiv = $("div.srvypprDiv");

			srvypprDiv.filter(function() {
				return parseInt($(this).data("seqno")) >= nextSeqno;
			}).removeClass("pass");

			srvypprDiv.filter(function() {
				const s = parseInt($(this).data("seqno"));
				return s > curSeqno && s < nextSeqno;
			}).addClass("pass");
		}

		// 다음 설문지로 이동(점프페이지 제외)
		function goNextSrvyppr() {
			if (!srvyRspnsCheck()) return;

			const curSrvyppr = $("div.srvypprDiv:visible");
			const curSeqno = Number(curSrvyppr.attr("data-seqno"));
			const srvypprCnt = getSrvypprCnt();

			let nextSeqno = calcNextSrvypprSeqno(curSrvyppr, curSeqno);

			if (nextSeqno === "END") return srvypprSbmsn();
			if (nextSeqno === 9999) nextSeqno = curSeqno + 1;

			markPassedSrvyppr(curSeqno, nextSeqno);

			if (curSeqno < srvypprCnt) {
				showSrvyppr(nextSeqno);
			}

			dialogHeightChange();
			controllSubmitBtn();
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

		// 설문지제출
		function srvypprSbmsn() {
			let isRspns = srvyRspnsCheck();

			if(isRspns) {
				const rspns = [];	// 답변 등록용

				$(".srvypprDiv:not(.pass)").find(".question_con").each(function(i, v) {
					let rspnsTycd = $(v).attr("data-rspnsTycd");	// 문항답변유형코드
					// 단일, 다중, OX선택형
					if(rspnsTycd == "ONE_CHC" || rspnsTycd == "MLT_CHC" || rspnsTycd == "OX_CHC") {
						$(v).find("input[name$=chc]:checked").each(function(ii, vv) {
							rspns.push({
								srvyQstnId	: $(v).attr("data-qstnId"),
								srvyVwitmId	: vv.value == "ETC" ? $(vv).attr("data-vwitmId") : vv.value,
								rspns		: vv.value == "ETC" ? $.trim($(v).find("input[name=rspns]").val()) : ""
							});
						});
					// 서술형
					} else if(rspnsTycd == "LONG_TEXT") {
						rspns.push({
							srvyQstnId	: $(v).attr("data-qstnId"),
							rspns		: $.trim($(v).find("textarea").val())
						});
					// 레벨형
					} else if(rspnsTycd == "LEVEL") {
						$(v).find("tbody tr").each(function(ii, vv) {
							$(vv).find("input[name$=lvl]:checked").each(function(iii, vvv) {
								rspns.push({
									srvyQstnId			: $(v).attr("data-qstnId"),
									srvyVwitmId			: $(vvv).attr("data-vwitmId"),
									srvyQstnVwitmLvlId	: vvv.value,
									rspns				: $.trim($(v).find("textarea").val())
								});
							});
						});
					}
				});

				const url = "/srvy/srvypprSbmsnAjax.do";

				$.ajax({
			        url 	  	: url,
			        async	  	: false,
			        type 	  	: "POST",
			        dataType 	: "json",
			        data 	  	: JSON.stringify({
						rspns 		: rspns,
						srvyPtcpId	: "${ptcpInfo.srvyPtcpId}",
						srvyId		: "${vo.srvyId}"
			        }),
			        contentType	: "application/json; charset=UTF-8",
			        success  	: function(data){
		                if(data.result > 0) {
		                	UiComm.showMessage("<spring:message code='srvy.alert.srvy.ptcp.complete' />", "success", 500)	/* 제출 완료되었습니다. */
		                	.then(function(result) {
		                		window.parent.location.reload();
			                    window.parent.closeDialog();
		                	});
		                } else {
		                	UiComm.showMessage(data.message, "error");
		                }
		            },
			    });
			}
		}
    </script>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<body class="modal-body">
		<%
            String sbjctnm = SubjectInfo.getSbjctnm(request, ParamInfo.getParamValue(request, "sbjctId"));
        %>
        <div class="board_top class">
            <h3 class="board-title"><%=sbjctnm%></h3>
            <div class="right-area">
                <div class="feedback-info">
                    <p class="desc">
                        <span><strong>${vo.deptnm }</strong></span>
                        <span><strong>${vo.userId }</strong></span>
                        <span><strong>${vo.usernm }</strong></span>
                    </p>
                </div>
            </div>
        </div>

        <div class="listTab flex align-items-center">
            <div class="listPage width-100per text-right"><label>1</label>/${fn:length(srvypprList) } <spring:message code="srvy.label.page" /><!-- 페이지 --></div>
        </div>

        <%@ include file="/WEB-INF/jsp/srvy/common/srvy_qstn_inc.jsp" %>

		<div class="modal_btns">
        	<c:if test="${fn:length(srvypprList) > 1}">
        		<a href="javascript:goPrevSrvyppr();" class="btn type2" id="btnPrevSrvyppr"><spring:message code="srvy.button.prev" /><!-- 이전 --></a>
        		<a href="javascript:goNextSrvyppr();" class="btn type2" id="btnNextSrvyppr"><spring:message code="srvy.button.next" /><!-- 다음 --></a>
        	</c:if>
        	<button type="button" class="btn type1" onclick="srvypprSbmsn();" id="submitBtn"><spring:message code="srvy.button.submit" /></button><!-- 제출 -->
        	<button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code="srvy.button.close" /></button><!-- 닫기 -->
        </div>

		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
