<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
   	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/editor_inc.jsp" %>
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
	<script type="text/javascript">
		var editor;
		$(document).ready(function() {
			editor = HtmlEditor("noticeCnts", "", "/sch");
			
			$("#popupNtcTrgtCd").closest("div").css("z-index", "1000");
		});
		
		// 저장
		function savePopNotice() {
			if(!$.trim($("#popupNtcTtl").val())) {
				alert("팝업제목 입력하세요.");
				$("#popupNtcTtl").focus();
				return;
			}
			
			var popupNtcSdttm = "";
			var popupNtcSdttmFmt	= $.trim($("#popupNtcSdttmFmt").val());
			var popupNtcSdttmFmtHH	= $.trim($("#popupNtcSdttmFmtHH").val());
			var popupNtcSdttmFmtMM	= $.trim($("#popupNtcSdttmFmtMM").val());
			
			var popupNtcEdttm = "";
			var popupNtcEdttmFmt	= $.trim($("#popupNtcEdttmFmt").val());
			var popupNtcEdttmFmtHH	= $.trim($("#popupNtcEdttmFmtHH").val());
			var popupNtcEdttmFmtMM	= $.trim($("#popupNtcEdttmFmtMM").val());
			
			if(!popupNtcSdttmFmt || !popupNtcSdttmFmtHH || !popupNtcSdttmFmtMM) {
				alert("팝업기간 시작일을 입력하세요.");
				
				if(!popupNtcSdttmFmt) {
					$("#popupNtcSdttmFmt").focus();
				}
				
				return;
			}
			
			popupNtcSdttm = popupNtcSdttmFmt + popupNtcSdttmFmtHH + popupNtcSdttmFmtMM + "00";
			popupNtcSdttm = popupNtcSdttm.replaceAll(".", "");
			
			$("#popupNtcSdttm").val(popupNtcSdttm);
			
			if(popupNtcSdttm.length != 14) {
				alert("팝업시작일이 올바르지 않습니다.");
				return;
			}
			
			if(!popupNtcEdttmFmt || !popupNtcEdttmFmtHH || !popupNtcEdttmFmtMM) {
				alert("팝업기간 종료일을 입력하세요.");
				
				if(!popupNtcEdttmFmt) {
					$("#popupNtcEdttmFmt").focus();
				}
				
				return;
			}
			
			popupNtcEdttm = popupNtcEdttmFmt + popupNtcEdttmFmtHH + popupNtcEdttmFmtMM + "59";
			popupNtcEdttm = popupNtcEdttm.replaceAll(".", "");
			
			if(popupNtcEdttm.length != 14) {
				alert("팝업종료일이 올바르지 않습니다.");
				return;
			}
			
			$("#popupNtcEdttm").val(popupNtcEdttm);
			
			if($("input[name='popupNtcTdstopUseyn']:checked").val() == "Y") {
				if(!$("#popupNtcTdstopDayCnt").val()) {
					alert("닫기 일수를 입력하세요.");
					return;
				}
				
				if($("#popupNtcTdstopDayCnt").val() == "0") {
					alert("닫기 일수를 1이상 입력하세요.");
					return;
				}
			} else {
				$("#popupNtcTdstopDayCnt").val("0");
			}
			
			if(editor.isEmpty()) {
				alert("내용을 입력하세요.");
				editor.execCommand('selectAll');
				editor.execCommand('deleteLeft');
				editor.execCommand('insertText', "");
				return;
			}
			
			// 로그인당 1번 오픈
			$("#snglSessUseyn").val($("#snglSessUseynCheck").is(":checked") ? "Y" : "N");
			// 법정교육 미수강생만 오픈
			$("#sttyeduAtndlcTrgtyn").val($("#sttyeduAtndlcTrgtynCheck").is(":checked") ? "Y" : "N");
			
			var popupNtcId = '<c:out value="${popupNoticeVO.popupNtcId}" />';
			var url;
			
			if(popupNtcId) {
				url = '/sch/schMgr/updatePopupNotice.do';
			} else {
				url = '/sch/schMgr/insertPopupNotice.do';
			}
			
			var data = $("#writeForm").serialize();
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					alert("저장되었습니다.");
					window.parent.closeModal();
					
					if(typeof window.parent.popupNoticeWriteCallBack === "function") {
						window.parent.popupNoticeWriteCallBack({
							popupNtcTycd: $("#popupNtcTycd").val()
						});
					}
	            } else {
	            	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		}
		
		// n일 닫기 사용여부 변경
		function changeNoMoreDayUseYn(value) {
			if(value == "Y") {
				$("#noMoreDayDiv").show();
				if(!$("#popupNtcTdstopDayCnt").val() || $("#popupNtcTdstopDayCnt").val() === "0") {
					$("#popupNtcTdstopDayCnt").val("1");
				}
			} else {
				$("#noMoreDayDiv").hide();
			}
		}
	</script>
</head>
<body class="modal-page">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>	
	<div id="wrap">
		<form name="writeForm" id="writeForm">
			<input type="hidden" name="popupNtcId" id="popupNtcId" value="${popupNoticeVO.popupNtcId}" />
			<input type="hidden" name="popupNtcTycd" id="popupNtcTycd" value="${vo.popupNtcTycd}" />
			<input type="hidden" name="popupNtcSdttm" id="popupNtcSdttm" value="${popupNoticeVO.popupNtcSdttm}" />
			<input type="hidden" name="popupNtcEdttm" id="popupNtcEdttm" value="${popupNoticeVO.popupNtcEdttm}" />
			<input type="hidden" name="sttyeduAtndlcTrgtyn" id="sttyeduAtndlcTrgtyn" value="${popupNoticeVO.sttyeduAtndlcTrgtyn}" />
			<input type="hidden" name="snglSessUseyn" id="snglSessUseyn" value="${popupNoticeVO.snglSessUseyn}" />
			<ul class='tbl-simple'>
				<li>
					<dl>
						<dt class="p_w15 req">
							팝업제목
						</dt>
						<dd class="pr50">
							<div class='ui fluid input'>
								<input type="text" name="popupNtcTtl" id="popupNtcTtl" maxlength="20" placeholder="팝업제목" value="${popupNoticeVO.popupNtcTtl}" />
							</div>
						</dd>
					</dl>
				</li>
				<li>
					<dl>
						<dt class="p_w15 req">
							팝업기간
						</dt>
						<dd class="pr50">
							<div class="inline fields flex">
			                    <div class="field flex ml10">
			                        <div class="ui calendar rangestart" id="rangestart" range="endCalendar,rangeend" dateval="${popupNoticeVO.popupNtcSdttm}">
			                            <div class="ui input left icon">
			                                <i class="calendar alternate outline icon"></i>
			                                <input type="text" id="popupNtcSdttmFmt" value="" placeholder="<spring:message code='common.start.date'/>" autocomplete="off" /> <!-- 시작일 -->
			                            </div>
			                        </div>
			                        <select class="ui dropdown list-num flex0 m-w70 ml5" id="popupNtcSdttmFmtHH" caltype="hour">
			                        	<option value=" "><spring:message code="date.hour"/></option>
			                        </select>
			                        <select class="ui dropdown list-num flex0 m-w70 ml5" id="popupNtcSdttmFmtMM" caltype="min">
										<option value=" "><spring:message code="date.minute"/></option>
									</select>
			                    </div>
			                    <div class="field flex ml30">
			                        <div class="ui calendar rangeend" id="rangeend" range="startCalendar,rangestart" dateval="${popupNoticeVO.popupNtcEdttm}">
			                            <div class="ui input left icon">
			                                <i class="calendar alternate outline icon"></i>
			                                <input type="text" id="popupNtcEdttmFmt" value="" placeholder="<spring:message code='common.enddate'/>" autocomplete="off" /> <!-- 종료일 -->
			                            </div>
			                        </div>
			                        <select class="ui dropdown list-num flex0 m-w70 ml5" id="popupNtcEdttmFmtHH" caltype="hour">
			                        	<option value=" "><spring:message code="date.hour"/></option>
			                        </select>
			                        <select class="ui dropdown list-num flex0 m-w70 ml5" id="popupNtcEdttmFmtMM" caltype="min">
										<option value=" "><spring:message code="date.minute"/></option>
									</select>
			                    </div>
			                </div>
						</dd>
					</dl>
				</li>
				<li>
					<dl>
						<dt class="p_w15">
							팝업대상
						</dt>
						<dd class="pr50">
							<c:choose>
								<c:when test="${vo.popupNtcTycd eq 'EVAL'}">
									<select class="ui dropdown  mr5" id="popupNtcTrgtCd" name="popupNtcTrgtCd">
										<c:forEach var="item" items="${popupNtcTrgtCdList}" varStatus="status">
											<option value="${item.codeCd}" <c:if test="${item.codeCd eq 'USR'}">selected="selected"</c:if>><c:out value="${item.codeNm}" /></option>
										</c:forEach>
									</select>
								</c:when>
								<c:otherwise>
									<c:set var="popTargetSelectedList" value="${fn:split(popupNoticeVO.popupNtcTrgtCd, ',')}" />
									<select class="ui dropdown  mr5" id="popupNtcTrgtCd" multiple="" name="popupNtcTrgtCd">
										<option value=""><spring:message code="common.all"/><!-- 전체 --></option>
				                   		<c:forEach var="item" items="${popupNtcTrgtCdList}" varStatus="status">
				                   			<c:set var="selected" value="" />
				                   			<c:forEach var="selectedItem" items="${popTargetSelectedList}" varStatus="status">
				                   				<c:if test="${item.codeCd eq selectedItem}"><c:set var="selected" value="selected" /></c:if>
				                   			</c:forEach>
											<option value="${item.codeCd}" ${selected}><c:out value="${item.codeNm}" /></option>
										</c:forEach>
				                   	</select>
								</c:otherwise>
							</c:choose>
						
						</dd>
					</dl>
				</li>
				<li>
					<dl>
						<dt class="p_w15">
							팝업 넓이
						</dt>
						<dd class="pr50">
							<div class="inline-flex-item">
								<div class='ui input'>
									<input type="text" name="popupWinWdthRatio" class="w50" id="popupWinWdthRatio" maxlength="2" placeholder="" value="${popupNoticeVO.popupWinWdthRatio}" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" />
								</div>
								<span class="ml5">%</span>
								<div class="ui info message p5 mt0 ml10">
								    기본 50%
								</div>
							</div>
						</dd>
					</dl>
				</li>
				<li>
					<dl>
						<dt class="p_w15">
							닫기 사용여부
						</dt>
						<dd class="pr50">
							<div class="fields inline-flex-item">
								<div class="field">
									<div class="ui radio checkbox">
										<input type="radio" id="popupNtcTdstopUseY" name="popupNtcTdstopUseyn" value="Y" onchange="changeNoMoreDayUseYn(this.value)" <c:if test="${empty popupNoticeVO or popupNoticeVO.popupNtcTdstopUseyn eq 'Y'}">checked</c:if> />
										<label for="popupNtcTdstopUseY"><spring:message code="message.yes" /><!-- 예 --></label>
									</div>
								</div>
								<div class="field ml10">
									<div class="ui radio checkbox">
										<input type="radio" id="popupNtcTdstopUseN" name="popupNtcTdstopUseyn" value="N" onchange="changeNoMoreDayUseYn(this.value)" <c:if test="${popupNoticeVO.popupNtcTdstopUseyn eq 'N'}">checked</c:if> />
										<label for="noMoreDayUseN"><spring:message code="message.no" /><!-- 아니오 --></label>
									</div>
								</div>
								<div class="field ml10" id="noMoreDayDiv" style="<c:if test="${popupNoticeVO.popupNtcTdstopUseyn eq 'N'}">display:none;</c:if>">
		                            <div class="inline-flex-item">
		                            	<div class='ui input w50'>
											<input type="text" id="popupNtcTdstopDayCnt" name="popupNtcTdstopDayCnt" maxlength="3" placeholder="" value="${empty popupNoticeVO.popupNtcTdstopDayCnt ? '1' : popupNoticeVO.popupNtcTdstopDayCnt}" style="height: 25px !important;" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"  />
										</div>
		                            </div>
		                        </div>
							</div>
						</dd>
					</dl>
				</li>
				<li>
					<dl>
						<dt class="p_w15">
							사용여부
						</dt>
						<dd class="pr50">
							<div class="fields flex">
								<div class="field">
									<div class="ui radio checkbox">
										<input type="radio" id="useYnY" name="useyn" value="Y" <c:if test="${empty popupNoticeVO or popupNoticeVO.useyn eq 'Y'}">checked</c:if> />
										<label for="useYnY"><spring:message code="message.yes" /><!-- 예 --></label>
									</div>
								</div>
								<div class="field ml10">
									<div class="ui radio checkbox">
										<input type="radio" id="useYnN" name="useyn" value="N" <c:if test="${popupNoticeVO.useyn eq 'N'}">checked</c:if> />
										<label for="useYnN"><spring:message code="message.no" /><!-- 아니오 --></label>
									</div>
								</div>
							</div>
						</dd>
					</dl>
				</li>
				<c:if test="${vo.popupNtcTycd ne 'EVAL'}">
				<li>
					<dl>
						<dt class="p_w15">
							기타
						</dt>
						<dd class="pr50">
							<div class="fields">
                                <div class="field">
                                    <div class="ui checkbox">
                                        <input type="checkbox" id="snglSessUseynCheck" <c:if test="${empty popupNoticeVO or popupNoticeVO.snglSessUseyn eq 'Y'}">checked</c:if>  />
                                        <label class="toggle_btn" for="snglSessUseynCheck">로그인당 1번 오픈</label>
                                    </div>
                                </div>
                                <div class="field mt5">
                                    <div class="ui checkbox">
                                        <input type="checkbox" id="sttyeduAtndlcTrgtynCheck" <c:if test="${popupNoticeVO.sttyeduAtndlcTrgtyn eq 'Y'}">checked</c:if>  />
                                        <label class="toggle_btn" for="sttyeduAtndlcTrgtynCheck">법정교육 미수강생만 오픈</label>
                                    </div>
                                </div>
                            </div>
						</dd>
					</dl>
				</li>
				</c:if>
				<li>
					<dl style="display:table;width:100%;">
						<dd style="height:400px;display:table-cell">
							<div style="height:100%;">
								<textarea name="noticeCnts" id="noticeCnts">${popupNoticeVO.noticeCnts}</textarea>
							</div>
						</dd>
					</dl>
				</li>
			</ul>
		</form>
		<div class="bottom-content mt50">
		 	<button class="ui blue button" onclick="savePopNotice()"><spring:message code="common.button.save" /></button><!-- 저장 -->
			<button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="common.button.close" /></button><!-- 닫기 -->
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>