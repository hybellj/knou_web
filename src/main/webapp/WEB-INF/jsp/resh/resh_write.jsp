<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/common/editor_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/resh/common/resh_common_inc.jsp" %>
<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />

<script type="text/javascript">
	$(document).ready(function () {
		extJoinChg();
	});
    
 	// 이전 설문 가져오기 팝업
	function reshCopyList() {
 		var kvArr = [];
		kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});
		
		submitForm("/resh/reshCopyListPop.do", "reshPopIfm", "copyResh", kvArr);
	}
 	
 	// 이전 설문 가져오기
 	function copyResh(reschCd) {
 		var url  = "/resh/reshCopy.do";
		var data = {
			"reschCd" : reschCd
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		var reshVO = data.returnVO;
        		// 설문 복사 여부
        		$("input[name='itemCopyYn']").val("Y");
        		// 복사할 설문 번호
        		$("input[name='itemCopyReschCd']").val(reshVO.reschCd);
        		// 설문명
        		$("#reschTitle").val(reshVO.reschTitle);
        		// 설문 내용
        		$("button.se-clickable[name=new]").trigger("click");
        		editor.insertHTML($.trim(reshVO.reschCts) == "" ? " " : reshVO.reschCts);
        		// 성적 조회 가능 여부
        		var scoreViewId = reshVO.scoreViewYn == "Y" && (reshVO.rsltTypeCd == "ALL" || reshVO.rsltTypeCd == "JOIN") ? "scoreViewY" : "scoreViewN";
        		$("#"+scoreViewId).trigger("click");
        		// 설문결과 조회 가능 여부
        		var rsltTypeId = reshVO.rsltTypeCd == "ALL" || reshVO.rsltTypeCd == "JOIN" ? "rsltTypeCdY" : "rsltTypeCdN";
        		$("#"+rsltTypeId).trigger("click");
        		$('.modal').modal('hide');
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='resh.error.copy' />");/* 설문 가져오기 중 에러가 발생하였습니다. */
		});
 	}
 	
 	// 설문 등록, 수정
 	function save() {
 		if(!nullCheck()) {
 			return false;
 		}
 		setValue();
 		
 		var url = "";
 		if(${empty vo.reschCd }) {
 			url = "/resh/writeResh.do";
 		} else {
 			url = "/resh/editResh.do";
 		}
 		
 		$.ajax({
            url 	 : url,
            async	 : false,
            type 	 : "POST",
            dataType : "json",
            data 	 : $("#writeReshForm").serialize(),
        }).done(function(data) {
        	hideLoading();
        	if (data.result > 0) {
        		// 설문 등록 or 문항 출제 미완료시
        		if(${empty vo.reschCd} || ${vo.reschSubmitYn ne 'Y'}) {
        			alert("<spring:message code='resh.alert.already.resh.qstn.submit' />");/* 설문 문항관리에서 문항을 출제 해 주세요. */
        			reshPageView("qstn", data.returnVO.reschCd); 
        		} else {
        			reshPageView("list", "");
        		}
            } else {
             	alert(data.message);
            }
        }).fail(function() {
        	hideLoading();
        	if(${empty vo.reschCd}) {
	        	alert("<spring:message code='resh.error.insert' />");/* 설문 등록 중 에러가 발생하였습니다. */
        	} else {
	        	alert("<spring:message code='resh.error.update' />");/* 설문 수정 중 에러가 발생하였습니다. */
        	}
        });
 	}
 	
 	// 빈 값 체크
 	function nullCheck() {
 		<spring:message code='resh.label.resh' var='resh'/> // 설문
 		
 		if($.trim($("#reschTitle").val()) == "") {
 			alert("<spring:message code='resh.alert.title' />");/* 설문 명을 입력하세요. */
 			return false;
 		}
 		if(editor.isEmpty() || editor.getTextContent().trim() === "") {
 			alert("<spring:message code='resh.alert.cts' />");/* 설문 내용을 입력하세요. */
 			return false;
 		}
 		if($("#reschStartFmt").val() == "") {
			alert("<spring:message code='common.alert.input.eval_start_date' arguments='${resh}'/>");/* [설문] 시작일을 입력하세요. */
			return false;
		}
		if($("#reschStartHH").val() == " ") {
			alert("<spring:message code='common.alert.input.eval_start_hour' arguments='${resh}'/>");/* [설문] 시작시간을 입력하세요. */
			return false;
		}
		if($("#reschStartMM").val() == " ") {
			alert("<spring:message code='common.alert.input.eval_start_min' arguments='${resh}'/>");/* [설문] 시작분을 입력하세요. */
			return false;
		}
		if($("#reschEndFmt").val() == "") {
			alert("<spring:message code='common.alert.input.eval_end_date' arguments='${resh}'/>");/* [설문] 종료일을 입력하세요. */
			return false;
		}
		if($("#reschEndHH").val() == " ") {
			alert("<spring:message code='common.alert.input.eval_end_hour' arguments='${resh}'/>");/* [설문] 종료시간을 입력하세요. */
			return false;
		}
		if($("#reschEndMM").val() == " ") {
			alert("<spring:message code='common.alert.input.eval_end_min' arguments='${resh}'/>");/* [설문] 종료분을 입력하세요. */
			return false;
		}
 		if ( ($("#reschStartFmt").val()+$("#reschStartHH").val()+$("#reschStartMM").val()) >
			($("#reschEndFmt").val()+$("#reschEndHH").val()+$("#reschEndMM").val()) ) {
			alert("<spring:message code='common.alert.input.eval_start_end_date' arguments='${resh}'/>"); // 종료일시를 시작일시 이후로 입력하세요.
			return false;
		}
 		if($("input[name=extJoinYn]:checked").val() == "Y") {
 			if($("#extEndFmt").val() == "") {
 				alert("<spring:message code='resh.alert.ext.end.dt' />");/* 지각 제출 마감일을 입력하세요. */
 				return false;
 			}
 			if($("#extEndHH").val() == " ") {
 				alert("<spring:message code='resh.alert.ext.end.hh' />");/* 지각 제출 마감 시간을 입력하세요. */
 				return false;
 			}
 			if($("#extEndMM").val() == " ") {
 				alert("<spring:message code='resh.alert.ext.end.mm' />");/* 지각 제출 마감 분을 입력하세요. */
 				return false;
 			}
 			
 			var reschEndDttmheck = (($("#reschEndFmt").val() || "") + ($("#reschEndHH").val() || "") + ($("#reschEndMM").val() || "")).replaceAll(".", "");
 			var extEndDttmCheck = (($("#extEndFmt").val() || "") + ($("#extEndHH").val() || "") + ($("#extEndMM").val() || "")).replaceAll(".", "");
 			
 			if(reschEndDttmheck.length == 12 && extEndDttmCheck.length == 12) {
 				if(reschEndDttmheck >= extEndDttmCheck) {
 					alert("<spring:message code='resh.alert.invalid.ext.end.dttm' />"); // 지각제출 종료일은 설문 종료일보다 크게 입력하세요.
 					return false;
 				}
 			}
  		}
 		
 		return true;
 	}
 	
 	// 값 채우기
 	function setValue(){
 		// 설문 내용
		var reshContents = editor.getPublishingHtml();
		$("input[name='reschCts']").val(reshContents);
		
		// 설문 시작 일시
		if($("#reschStartFmt").val() != null && $("#reschStartFmt").val() != "") {
			$("input[name='reschStartDttm']").val($("#reschStartFmt").val().replaceAll(".","") + "" + pad($("#reschStartHH option:selected").val(),2) + "" + pad($("#reschStartMM option:selected").val(),2) + "00");
		}
		
		// 설문 종료 일시
		if($("#reschEndFmt").val() != null && $("#reschEndFmt").val() != "") {
			$("input[name='reschEndDttm']").val(setDateEndDttm($("#reschEndFmt").val().replaceAll(".","") + "" + pad($("#reschEndHH option:selected").val(),2) + "" + pad($("#reschEndMM option:selected").val(),2), ""));
		}
		
		// 설문 지각 제출 일시
		if($("#extEndFmt").val() != null && $("#extEndFmt").val() != "") {
			$("input[name='extEndDttm']").val(setDateEndDttm($("#extEndFmt").val().replaceAll(".","") + "" + pad($("#extEndHH option:selected").val(),2) + "" + pad($("#extEndMM option:selected").val(),2), ""));
		}
	}
	
	// 공개 강의에 연결된 설문중에서 성적조회 설정된 설문은 하나만 있는지 검사
	function validateScoreViewCount() {
		if($("input[name=scoreViewYn]:checked").val() == "N") {
			return false;
		}
		
		if(${scoreViewReshCnt > 0}) {
			alert("<spring:message code='resh.error.nomore.score.result' />");/* 이미 다른 설문에 성적 조회 연동 설정을 하여 더이상 추가로 설정할 수 없습니다. */
			$("#scoreViewN").trigger("click");
			return false;
		}
	}
	
	// 설문 페이지 이동
	function reshPageView(type, reschCd) {
		var urlMap = {
			"qstn" : "/resh/reshQstnManage.do",	/* 문항관리 */
			"list" : "/resh/Form/reshList.do"	/* 목록 */
		}
		var kvArr = [];
		kvArr.push({'key' : 'reschCd',  'val' : reschCd});
		kvArr.push({'key' : 'crsCreCd', 'val' : "${vo.crsCreCd}"});
		
		submitForm(urlMap[type], "", "", kvArr);
	}
	
	// 지각 제출 여부 변경
	function extJoinChg() {
		var joinYn = $("input[name=extJoinYn]:checked").val();
		if(joinYn == "Y") {
			$("#extJoinDiv").show();
		} else {
			$("#extJoinDiv").hide();
		}
	}
	
	// 분반 체크박스 이벤트
	function checkDecls(obj) {
		if(obj.value == "all") {
			$("input[name=crsCreCds]").not(".readonly").prop("checked", obj.checked);
		} else {
			$("#allDecls").prop("checked", $("input[name=crsCreCds]").length == $("input[name=crsCreCds]:checked").length);
		}
	}
</script>

<body class="<%=SessionInfo.getThemeMode(request)%>">
    <div id="wrap" class="pusher">
        <!-- class_top 인클루드  -->
        <%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>

        <div id="container">
            <%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>
            <!-- 본문 content 부분 -->
            <div class="content stu_section">
            	<%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>
                <div class="ui form">
                	<div class="layout2">
                		<spring:message code="resh.button.save"   var="save" /><!-- 저장 -->
                		<spring:message code="resh.button.modify" var="modify" /><!-- 수정 -->
                		<c:set var="reschInfo"><spring:message code="resh.label.resh" /> ${empty vo.reschCd ? save : modify }</c:set>
                		<script>
						$(document).ready(function () {
							// set location
							setLocationBar('<spring:message code="resh.label.resh" />', '${reschInfo}');
						});
						</script>
		                <div id="info-item-box">
		                	<h2 class="page-title flex-item flex-wrap gap4 columngap16">
                                <spring:message code="resh.label.resh" /><!-- 설문 -->
                            </h2>
		                    <div class="button-area">
		                    	<a href="javascript:save()" class="ui blue button">${save }</a>
		                        <a href="javascript:reshCopyList()" class="ui blue button"><spring:message code="resh.label.prev.resh.copy" /></a><!-- 이전 설문 가져오기 -->
		                        <a href="javascript:reshPageView('list', '')" class="ui blue button"><spring:message code="resh.button.list" /></a><!-- 목록 -->
		                    </div>
		                </div>
		                <div class="row">
		                	<div class="col">
				                <div class="ui form" id="reshWriteDiv">
				                	<form name="writeReshForm" id="writeReshForm" method="POST" autocomplete="off">
				                		<input type="hidden" name="crsCreCd" 		value="${vo.crsCreCd }" />
				                		<input type="hidden" name="reschCd" 		value="${vo.reschCd }" />
				                		<input type="hidden" name="reschTplYn" 		value="N" />
				                		<input type="hidden" name="reschTypeCd" 	value="LECT" />
				                		<input type="hidden" name="reschStartDttm" 	value="${vo.reschStartDttm }" />
				                		<input type="hidden" name="reschEndDttm" 	value="${vo.reschEndDttm }" />
				                		<input type="hidden" name="itemCopyYn" 		value="${vo.itemCopyYn }" />
				                		<input type="hidden" name="itemCopyReschCd" value="${vo.itemCopyReschCd }" />
				                		<input type="hidden" name="reschCts" 		value="" />
				                		<input type="hidden" name="extEndDttm"		value="${vo.extEndDttm }" />
										<div class="ui segment">
										    <ul class="tbl border-top-grey">
										        <li>
										            <dl>
										                <dt><label for="reschTitle" class="req"><spring:message code="resh.label.title" /></label></dt><!-- 설문명 -->
										                <dd>
										                    <div class="ui fluid input">
										                        <input type="text" name="reschTitle" id="reschTitle" value="${fn:escapeXml(vo.reschTitle) }">
										                    </div>
										                </dd>
										            </dl>
										        </li>
										        <li>
										            <dl>
										                <dt><label for="contentTextArea" class="req"><spring:message code="resh.label.cts" /></label></dt><!-- 설문내용 -->
										                <dd style="height:400px">
                    										<div style="height:100%">
										                		<textarea name="contentTextArea" id="contentTextArea">${vo.reschCts }</textarea>
										                		<script>
											                       // html 에디터 생성
											               	  		var editor = HtmlEditor('contentTextArea', THEME_MODE, '/resh/${vo.reschCd }');
											                   	</script>
										                	</div>
														</dd>
										            </dl>
										        </li>
										        <c:if test="${empty vo.reschCd }">
											        <li>
											            <dl>
											                <dt><label for="teamLabel"><spring:message code="resh.label.decls.modi.y" /></label></dt><!-- 분반 일괄 등록 -->
											                <dd>
											                	<div class="fields">
												                    <div class="field">
												                        <div class="ui checkbox">
												                            <input type="checkbox" name="allDeclsNo" value="all" id="allDecls" onchange="checkDecls(this)">
												                            <label class="toggle_btn" for="allDecls"><spring:message code="resh.common.search.all" /></label><!-- 전체 -->
												                        </div>
												                    </div>
											                		<c:forEach var="list" items="${declsList }">
											                			<c:set var="crsCreChk" value="N" />
											                			<c:forEach var="item" items="${creCrsList }">
											                				<c:if test="${item.creCrsCd eq list.crsCreCd }">
											                    				<c:set var="crsCreChk" value="Y" />
											                				</c:if>
											                			</c:forEach>
												                       <div class="field">
												                           <div class="ui checkbox">
												                               <input type="checkbox" ${list.crsCreCd eq vo.crsCreCd || crsCreChk eq 'Y' ? 'class="readonly"' : '' } name="crsCreCds" id="decls${list.declsNo }" value="${list.crsCreCd }" ${list.crsCreCd eq vo.crsCreCd || crsCreChk eq 'Y' ? 'checked readonly' : '' } onchange="checkDecls(this)">
												                               <label class="toggle_btn" for="decls${list.declsNo }">${list.declsNo }<spring:message code="resh.label.decls" /></label><!-- 반 -->
												                           </div>
												                       </div>
											                		</c:forEach>
												                </div>
											                </dd>
											            </dl>
											        </li>
										        </c:if>
										        <li>
										            <dl>
										                <dt><label for="reschStartFmt" class="req"><spring:message code="resh.label.period" /></label></dt><!-- 설문기간 -->
										                <dd>
										                	<div class="fields gap4">
                                            					<div class="field flex">
					                                               <!-- 시작일시 -->
					                                               <uiex:ui-calendar dateId="reschStartFmt" hourId="reschStartHH" minId="reschStartMM" 
					                                               		rangeType="start" rangeTarget="reschEndFmt" value="${vo.reschStartDttm}"/>
					                                            </div>
					                                            <div class="field p0 flex-item desktop-elem">~</div>
					                                            <div class="field flex">
					                                           	   <!-- 종료일시 -->
					                                               <uiex:ui-calendar dateId="reschEndFmt" hourId="reschEndHH" minId="reschEndMM" 
					                                               		rangeType="end" rangeTarget="reschStartFmt" value="${vo.reschEndDttm}"/>
					                                            </div>
						                                    </div>
										                </dd>
										            </dl>
										        </li>
										        <li>
										        	<dl>
										        		<dt><label for="scoreAplyY"><spring:message code='resh.label.score.aply' /><!-- 성적 반영 --></label></dt>
										        		<dd>
										        			<div class="fields">
										                        <div class="field">
										                            <div class="ui radio checkbox">
										                                <input type="radio" id="scoreAplyY" name="scoreAplyYn" value="Y" tabindex="0" class="hidden" ${vo.scoreAplyYn eq 'Y' || empty vo.reschCd || empty vo.scoreAplyYn ? 'checked' : '' }>
										                                <label for="scoreAplyY"><spring:message code="resh.common.yes" /></label><!-- 예 -->
										                            </div>
										                        </div>
										                        <div class="field">
										                            <div class="ui radio checkbox">
										                                <input type="radio" id="scoreAplyN" name="scoreAplyYn" value="N" tabindex="0" class="hidden" ${vo.scoreAplyYn eq 'N' ? 'checked' : '' }>
										                                <label for="scoreAplyN"><spring:message code="resh.common.no" /></label><!-- 아니오 -->
										                            </div>
										                        </div>
										                    </div>
										        		</dd>
										        	</dl>
										        </li>
										        <li>
										        	<dl>
										        		<dt><label for="scoreOpenY"><spring:message code="resh.label.score.open" /><!-- 성적 공개 --></label></dt>
										        		<dd>
										        			<div class="fields">
										                        <div class="field">
										                            <div class="ui radio checkbox">
										                                <input type="radio" id="scoreOpenY" name="scoreOpenYn" value="Y" tabindex="0" class="hidden" ${vo.scoreOpenYn eq 'Y' ? 'checked' : '' }>
										                                <label for="scoreOpenY"><spring:message code="resh.common.yes" /></label><!-- 예 -->
										                            </div>
										                        </div>
										                        <div class="field">
										                            <div class="ui radio checkbox">
										                                <input type="radio" id="scoreOpenN" name="scoreOpenYn" value="N" tabindex="0" class="hidden" ${vo.scoreOpenYn eq 'N' || empty vo.reschCd || empty vo.scoreOpenYn ? 'checked' : '' }>
										                                <label for="scoreOpenN"><spring:message code="resh.common.no" /></label><!-- 아니오 -->
										                            </div>
										                        </div>
										                    </div>
										        		</dd>
										        	</dl>
										        </li>
										        <li>
										        	<dl>
										        		<dt><label for="extJoinY"><spring:message code="resh.label.ext.join" /></label></dt><!-- 지각 제출 -->
										        		<dd>
										        			<div class="fields">
										                        <div class="field">
										                            <div class="ui radio checkbox">
										                                <input type="radio" id="extJoinY" name="extJoinYn" value="Y" tabindex="0" onchange="extJoinChg()" class="hidden" ${vo.extJoinYn eq 'Y' ? 'checked' : '' }>
										                                <label for="extJoinY"><spring:message code="resh.common.yes" /></label><!-- 예 -->
										                            </div>
										                        </div>
										                        <div class="field">
										                            <div class="ui radio checkbox">
										                                <input type="radio" id="extJoinN" name="extJoinYn" value="N" tabindex="0" onchange="extJoinChg()" class="hidden" ${vo.extJoinYn eq 'N' || empty vo.reschCd || empty vo.extJoinYn ? 'checked' : '' }>
										                                <label for="extJoinN"><spring:message code="resh.common.no" /></label><!-- 아니오 -->
										                            </div>
										                        </div>
										                    </div>
										                    <div class="ui segment bcLgrey9" id="extJoinDiv">
					                                            <div class="fields align-items-center">
					                                            	<div class="inline field">
					                                                    <label for="dateLabel"><spring:message code="resh.label.ext.end.dttm" /><!-- 제출 마감일 --></label>
					                                            	</div>
					                                                <div class="field fields gap4">
					                                                    <div class="field flex">
				                                           					<uiex:ui-calendar dateId="extEndFmt" hourId="extEndHH" minId="extEndMM" rangeType="end" value="${vo.extEndDttm}"/>
					                                                    </div>
					                                                </div>
					                                            </div>
					                                        </div>
										        		</dd>
										        	</dl>
										        </li>
										        <li>
										        	<dl>
										        		<dt><label for="evalP"><spring:message code="resh.label.eval.ctgr" /></label></dt><!-- 평가 방법 -->
										        		<dd>
										        			<div class="fields">
										                        <div class="field">
										                            <div class="ui radio checkbox">
										                                <input type="radio" id="evalP" name="evalCtgr" value="P" tabindex="0" class="hidden" ${vo.evalCtgr eq 'P' ? 'checked' : '' }>
										                                <label for="evalP"><spring:message code="resh.label.eval.ctgr.score" /></label><!-- 점수형 -->
										                            </div>
										                        </div>
										                        <div class="field">
										                            <div class="ui radio checkbox">
										                                <input type="radio" id="evalJ" name="evalCtgr" value="J" tabindex="0" class="hidden" ${vo.evalCtgr eq 'J' || empty vo.reschCd ? 'checked' : '' }>
										                                <label for="evalJ"><spring:message code="resh.label.eval.ctgr.join" /></label><!-- 참여형 -->
										                            </div>
										                            <span class="fcRed">( <spring:message code="resh.label.eval.ctgr.info" /><!-- ! 설문 참여 100점, 미참여 0점 자동 배점 --> )</span>
										                        </div>
										                    </div>
										                    <div class="ui small message">
													            <i class="info circle icon"></i>
													            <spring:message code="resh.label.eval.ctgr.info" /><!-- 점수형 : 평가자가 0점~100점 사이 점수를 매김, 참여형 : 참여 100점 / 불참 0점 -->
													        </div>
										        		</dd>
										        	</dl>
										        </li>
										    </ul> 
										</div>
										<div class="ui styled fluid accordion week_lect_list">
		                                    <div class="title">
		                                        <div class="title_cont">
		                                            <div class="left_cont">
		                                                <div class="lectTit_box">
		                                                    <p class="lect_name"><spring:message code="resh.label.added.features" /><!-- 추가기능 --></p>
		                                                </div>
		                                            </div>
		                                        </div>
		                                        <i class="dropdown icon ml20"></i>
		                                    </div>
		                                    <div class="content p0">
												<div class="ui segment">
													<div class="ui form">
														<ul class="tbl border-top-grey">
												            <li>
												                <dl>
												                	<dt><spring:message code="resh.label.score.view.modi.y" /></dt><!-- 설문 참여 후 성적조회 가능 -->
												                	<dd>
												                        <div class="fields">
												                            <div class="field">
												                                <div class="ui radio checkbox">
												                                    <input type="radio" id="scoreViewY" name="scoreViewYn" value="Y" onchange="validateScoreViewCount()" tabindex="0" class="hidden" ${vo.scoreViewYn eq 'Y' ? 'checked' : '' }>
												                                    <label for="scoreViewY"><spring:message code="resh.common.yes" /></label><!-- 예 -->
												                                </div>
												                            </div>
												                            <div class="field">
												                                <div class="ui radio checkbox">
												                                    <input type="radio" id="scoreViewN" name="scoreViewYn" value="N" onchange="validateScoreViewCount()" tabindex="0" class="hidden" ${vo.scoreViewYn eq 'N' || empty vo.reschCd ? 'checked' : '' }>
												                                    <label for="scoreViewN"><spring:message code="resh.common.no" /></label><!-- 아니오 -->
												                                </div>
												                            </div>
												                        </div>
												                        <div class="ui small message">
																            <i class="info circle icon"></i>
																            <spring:message code="resh.label.score.view.info" /><!-- 설문 참여 후 종합성적 확인 가능의 의미 -->
																        </div>
												                    </dd>
												                </dl>
												                <dl>
												                	<dt><spring:message code="resh.label.allow.modi.y" /></dt><!-- 설문결과 조회 가능 -->
												                	<dd>
												                		<div class="fields">
												                            <div class="field">
												                                <div class="ui radio checkbox">
												                                    <input type="radio" id="rsltTypeCdY" name="rsltTypeCd" value="ALL" tabindex="0" class="hidden" ${vo.rsltTypeCd eq 'ALL' || vo.rsltTypeCd eq 'JOIN' ? 'checked' : '' }>
												                                    <label for="rsltTypeCdY"><spring:message code="resh.common.yes" /></label><!-- 예 -->
												                                </div>
												                            </div>
												                            <div class="field">
												                                <div class="ui radio checkbox">
												                                    <input type="radio" id="rsltTypeCdN" name="rsltTypeCd" value="CLOSE" tabindex="0" class="hidden" ${vo.rsltTypeCd eq 'CLOSE' || empty vo.reschCd ? 'checked' : '' }>
												                                    <label for="rsltTypeCdN"><spring:message code="resh.common.no" /></label><!-- 아니오 -->
												                                </div>
												                            </div>
												                        </div>
												                	</dd>
												                </dl>
												            </li>
												        </ul>
													</div>
												</div>
		                                    </div>
		                                </div>
									</form>
				                </div>
				                <div class="option-content mt20">
					                <div class="mla">
				                    	<a href="javascript:save()" class="ui blue button">${save }</a>
				                        <a href="javascript:reshCopyList()" class="ui blue button"><spring:message code="resh.label.prev.resh.copy" /></a><!-- 이전 설문 가져오기 -->
				                        <a href="javascript:reshPageView('list', '')" class="ui blue button"><spring:message code="resh.button.list" /></a><!-- 목록 -->
				                    </div>
				                </div>
		                	</div>
		                </div>
                	</div>
                </div>
            </div>
            <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
        </div>
        <!-- //본문 content 부분 -->
    </div>
</body>
</html>