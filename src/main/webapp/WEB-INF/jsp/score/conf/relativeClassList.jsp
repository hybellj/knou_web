<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
$(function() {
	$(".tabmenu.menu .item").tab();

	$(".relCInputDiv").hide();
	$(".relGInputDiv").hide();

	tabSelected("${tabOrd}");
});

function tabSelected(tabMenu) {
	if(tabMenu === "C") {
		$('.tabmenu.menu .item').tab('change tab', 'tabcont1')
	} else if(tabMenu === "G") {
		$('.tabmenu.menu .item').tab('change tab', 'tabcont2')
	}
}

function changeUseYn(obj) {
	var orgId = $(obj).data("orgid");
	var scorRelCd = $(obj).data("scorrelcd");
	var uniCd = $(obj).data("unicd");
	
	if($(obj).is(":checked")) {
		var useYn = "Y";
	} else {
		var useYn = "n";
	}
	
	var data = {
		"orgId" : orgId,
		"scorRelCd" : scorRelCd,
		"uniCd" : uniCd,
		"useYn" : useYn,
	}
	
	ajaxCall("/score/scoreConf/editRelativeUseYn.do", data, function(data) {
		if(data.result > 0) {
			alert("<spring:message code='score.alert.message.open.yes' />");// 사용여부를 수정하였습니다.
		} else {
			alert(data.message);
		}
	}, function(xhr, status, error) {
		alert("<spring:message code='socre.common.error' />");// 오류가 발생했습니다!
	});
}

//입력 폼 변환
function chgDisplay(type) {
	if(type === 1) {
		// 학부 취소버튼 클릭
		$("#chgCDisplayBtn").show();
		$("#chgCDisplayDiv").hide();
		$(".relCInputDiv").hide();
		$(".relCDisplayDiv").show();
	} else if(type === 2) {
		// 학부 관리버튼 클릭
		$("#chgCDisplayBtn").hide();
		$("#chgCDisplayDiv").show();
		$(".relCInputDiv").show();
		$(".relCDisplayDiv").hide();
	} else if(type === 3) {
		//대학원 취소버튼 클릭
		$("#chgGDisplayBtn").show();
		$("#chgGDisplayDiv").hide();
		$(".relGInputDiv").hide();
		$(".relGDisplayDiv").show();
	} else if(type === 4) {
		// 학부 관리버튼 클릭
		$("#chgGDisplayBtn").hide();
		$("#chgGDisplayDiv").show();
		$(".relGInputDiv").show();
		$(".relGDisplayDiv").hide();
	}
}

function save(type) {
	var scorRelCd = "";
	var endScorCd = "";
	var startRatio = "";
	var endRatio = "";
	if(type === 'C') {
		$(".cClassData").each(function(i) {
			if(i > 0) {
				scorRelCd += "|";
				endScorCd += "|";
				startRatio += "|";
				endRatio += "|";
			}
			scorRelCd += $("#cScorRelCd"+ i).data("scorrelcd");
			endScorCd += $("#cEndScorCd"+ i).val();
			startRatio += $("#cStartRatio"+ i).val();
			endRatio += $("#cEndRatio"+ i).val();
		});
	} else if(type === 'G') {
		$(".gClassData").each(function(i) {
			if(i > 0) {
				scorRelCd += "|";
				endScorCd += "|";
				startRatio += "|";
				endRatio += "|";
			}
			scorRelCd += $("#gScorRelCd"+ i).data("scorrelcd");
			endScorCd += $("#gEndScorCd"+ i).val();
			startRatio += $("#gStartRatio"+ i).val();
			endRatio += $("#gEndRatio"+ i).val();
		});
	}

	var url  = "/score/scoreConf/editRelativeClassAjax.do";
	var data = {
		"scorRelCds" : scorRelCd,
		"endScorCds" : endScorCd,
		"startRatios" : startRatio,
		"endRatios" : endRatio,
		"uniCd" : type
	};

	ajaxCall(url, data, function(data) {
		if (data.result > 0) {
			alert("<spring:message code='score.alert.success_save.message'/>"); // 정상적으로 저장되었습니다.
			
			location.href="/score/scoreConf/relativeClassList.do?tabOrd="+type;
		} else {
			alert(data.message);
		}
	}, function(xhr, status, error) {
		alert("<spring:message code='forum.common.error'/>"); // 오류가 발생했습니다!
	});
}
</script>

<body>
<<form class="ui form" id="relativeListForm" name="relativeListForm" method="POST">
	<input type="hidden" id="scorRelCd" name="scorRelCd" value="">
	<input type="hidden" id="scorOdr" name="scorOdr" value="">

    <div id="wrap" class="pusher">

        <!-- header -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
        <!-- //header -->

        <!-- lnb -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>
        <!-- //lnb -->

        <div id="container">

            <!-- 본문 content 부분 -->
            <div class="content">

				<!-- admin_location -->
				<div id="info-item-box" class="">
					<h2 class="page-title flex-item">
						<spring:message code="score.base.info.manager.label"/><!-- 성적기초정보관리 -->
						<div class="ui breadcrumb small">
							<small class="section"><spring:message code="score.relative.evaluation.label"/><!-- 상대평가비율 --></small>
						</div>
					</h2>
				</div>
				<!-- //admin_location -->

				<!-- ui form -->
				<div class="ui form">
					<!-- 콘텐츠 영역 -->
					<!-- 탭메뉴 -->
					<div class="ui pointing secondary tabmenu menu" style="<%=(!SessionInfo.isKnou(request) ? "display:none" : "")%>">
						<a class="item active" data-tab="tabcont1"><spring:message code='score.label.univ'/><!-- 학부 --></a>
						<a class="item" data-tab="tabcont2"><spring:message code='score.label.grad'/><!-- 대학원 --></a>
					</div>

					<!-- 탭 콘텐츠 -->
					<div class="ui tab active" data-tab="tabcont1">
						<div class="option-content gap4">
							<div class='sec_head bullet_dot'><spring:message code='score.exchange.grade.label'/><!-- 성적환산등급 --></div>
							<div class="button-area">
								<a href="javascript:void(0);" id="chgCDisplayBtn" class="ui orange button" onclick="chgDisplay(2);"><spring:message code="score.manage.label"/><!-- 관리 --></a>
								<div id="chgCDisplayDiv" style="display:none;">
								<a href="javascript:save('C');" class="ui blue button"><spring:message code='socre.save.button'/><!-- 저장 --></a>
								<a href="javascript:chgDisplay(1);" class="ui basic button"><spring:message code='socre.cancel.button'/><!-- 취소 --></a>
								</div>
							</div>
						</div>
							<table class="table" data-sorting="false" data-paging="false" data-empty="<spring:message code='score.rel.table.empty.label'/>"><!-- 등록된 상대평가비율 정보가 없습니다. -->
				            	<thead>
				                	<tr>
				                    	<th scope="col" data-type="number" class="num"><spring:message code="common.number.no" /></th> <!-- No. -->
				                    	<th scope="col"><spring:message code="socre.start.grade.label" /></th><!-- 시작등급 -->
				                        <th scope="col"><spring:message code="socre.end.grade.label" /></th><!-- 종료등급 -->
				                        <th scope="col"><spring:message code="score.start.percentage.label" />(%)</th><!-- 시작백분율 -->
				                        <th scope="col"><spring:message code="score.end.percentage.label" />(%)</th><!-- 종료백분율 -->
				                        <th scope="col"><spring:message code="score.useyn.label" /></th><!-- 사용여부 -->
				                    </tr>
				                </thead>
				                <tbody>
				                    <c:if test="${not empty relativeCClassList}">
				                        <c:forEach items="${relativeCClassList }" var="item" varStatus="status">
				                        	<tr class="cClassData">
				                            	<td><c:out value='${item.scorOdr}' /></td>
				                            	<td id="cScorRelCd${status.index}" data-scorrelcd="${item.scorRelCd}">
			                            			<c:out value='${item.startScorCd}' />
				                            	</td>
				                            	<td>
				                            		<div class="relCDisplayDiv">
				                            			<c:out value='${item.endScorCd}' />
				                            		</div>
				                            		<div class="relCInputDiv">
                                                        <select class="w70" name="cEndScorCd" id="cEndScorCd${status.index}" title="<spring:message code="socre.end.grade.label" />">
	                                                        <option value="A+" <c:if test="${item.endScorCd eq 'A+'}">selected</c:if>>A+</option>
	                                                        <option value="A" <c:if test="${item.endScorCd eq 'A'}">selected</c:if>>A</option>
	                                                        <option value="B+" <c:if test="${item.endScorCd eq 'B+'}">selected</c:if>>B+</option>
	                                                        <option value="B" <c:if test="${item.endScorCd eq 'B'}">selected</c:if>>B</option>
	                                                        <option value="C+" <c:if test="${item.endScorCd eq 'C+'}">selected</c:if>>C+</option>
	                                                        <option value="C" <c:if test="${item.endScorCd eq 'C'}">selected</c:if>>C</option>
	                                                        <option value="D+" <c:if test="${item.endScorCd eq 'D+'}">selected</c:if>>D+</option>
	                                                        <option value="D" <c:if test="${item.endScorCd eq 'D'}">selected</c:if>>D</option>
	                                                        <option value="F" <c:if test="${item.endScorCd eq 'F'}">selected</c:if>>F</option>
	                                                        <option value="P" <c:if test="${item.endScorCd eq 'P'}">selected</c:if>>P</option>
	                                                    </select>
				                            		</div>
				                            	</td>
				                            	<td>
				                            		<div class="relCDisplayDiv">
				                            			<c:out value='${item.startRatio}' />
				                            		</div>
				                            		<div class="relCInputDiv">
				                            			<input type="text" class="w60 cStartRatio" id="cStartRatio${status.index}" value="${item.startRatio}" />
				                            		</div>
				                            	</td>
				                            	<td>
				                            		<div class="relCDisplayDiv">
					                            		<c:out value='${item.endRatio}' />
					                            	</div>
				                            		<div class="relCInputDiv">
				                            			<input type="text" class="w60 cEndRatio" id="cEndRatio${status.index}" value="${item.endRatio}" />
				                            		</div>
				                            	</td>
				                            	<td>
													<div class="ui toggle checkbox">
														<input type="checkbox" id="useYn_${item.scorRelCd}" data-orgid="${item.orgId}" data-scorrelcd="${item.scorRelCd}" data-unicd="${item.uniCd}" <c:if test="${item.useYn eq 'Y'}">checked</c:if> onchange="changeUseYn(this);">
													</div> 
				                            	</td>
				                        	</tr>
				                        </c:forEach>
				                    </c:if>
				                </tbody>
				            </table>
					</div>
					<!-- //탭 콘텐츠 -->

					<!-- 탭 콘텐츠 -->
					<div class="ui tab" data-tab="tabcont2">
					<div class="option-content gap4">
						<div class='sec_head bullet_dot'><spring:message code='score.exchange.grade.label'/><!-- 성적환산등급 --></div>
						<div class="button-area">
							<a href="javascript:void(0);" id="chgGDisplayBtn" class="ui orange button" onclick="chgDisplay(4);"><spring:message code="score.manage.label"/><!-- 관리 --></a>
							<div id="chgGDisplayDiv" style="display:none;">
							<a href="javascript:save('G');" class="ui blue button"><spring:message code='socre.save.button'/><!-- 저장 --></a>
							<a href="javascript:chgDisplay(3);" class="ui basic button"><spring:message code='socre.cancel.button'/><!-- 취소 --></a>
							</div>
						</div>
					</div>
							<table class="table" data-sorting="false" data-paging="false" data-empty="<spring:message code='score.rel.table.empty.label'/>"><!-- 등록된 상대평가비율 정보가 없습니다. -->
				            	<thead>
				                	<tr>
				                    	<th scope="col" data-type="number" class="num"><spring:message code="common.number.no" /></th> <!-- No. -->
				                    	<th scope="col"><spring:message code="socre.start.grade.label" /></th><!-- 시작등급 -->
				                        <th scope="col"><spring:message code="socre.end.grade.label" /></th><!-- 종료등급 -->
				                        <th scope="col"><spring:message code="score.start.percentage.label" />(%)</th><!-- 시작백분율 -->
				                        <th scope="col"><spring:message code="score.end.percentage.label" />(%)</th><!-- 종료백분율 -->
				                        <th scope="col"><spring:message code="score.useyn.label" /></th><!-- 사용여부 -->
				                    </tr>
				                </thead>
				                <tbody>
				                    <c:if test="${not empty relativeGClassList}">
				                        <c:forEach items="${relativeGClassList }" var="item" varStatus="status">
				                        	<tr class="gClassData">
				                            	<td><c:out value='${item.scorOdr}' /></td>
				                            	<td id="gScorRelCd${status.index}" data-scorrelcd="${item.scorRelCd}">
			                            			<c:out value='${item.startScorCd}' />
				                            	</td>
				                            	<td>
				                            		<div class="relGDisplayDiv">
				                            			<c:out value='${item.endScorCd}' />
				                            		</div>
				                            		<div class="relGInputDiv">
                                                        <select class="w70" name="gEndScorCd" id="gEndScorCd${status.index}" title="<spring:message code="socre.end.grade.label" />">
	                                                        <option value="A+" <c:if test="${item.endScorCd eq 'A+'}">selected</c:if>>A+</option>
	                                                        <option value="A" <c:if test="${item.endScorCd eq 'A'}">selected</c:if>>A</option>
	                                                        <option value="B+" <c:if test="${item.endScorCd eq 'B+'}">selected</c:if>>B+</option>
	                                                        <option value="B" <c:if test="${item.endScorCd eq 'B'}">selected</c:if>>B</option>
	                                                        <option value="C+" <c:if test="${item.endScorCd eq 'C+'}">selected</c:if>>C+</option>
	                                                        <option value="C" <c:if test="${item.endScorCd eq 'C'}">selected</c:if>>C</option>
	                                                        <option value="D+" <c:if test="${item.endScorCd eq 'D+'}">selected</c:if>>D+</option>
	                                                        <option value="D" <c:if test="${item.endScorCd eq 'D'}">selected</c:if>>D</option>
	                                                        <option value="F" <c:if test="${item.endScorCd eq 'F'}">selected</c:if>>F</option>
	                                                        <option value="P" <c:if test="${item.endScorCd eq 'P'}">selected</c:if>>P</option>
	                                                    </select>
				                            		</div>
				                            	</td>
				                            	<td>
				                            		<div class="relGDisplayDiv">
				                            			<c:out value='${item.startRatio}' />
				                            		</div>
				                            		<div class="relGInputDiv">
				                            			<input type="text" class="w60 gStartRatio" id="gStartRatio${status.index}" value="${item.startRatio}" />
				                            		</div>
				                            	</td>
				                            	<td>
				                            		<div class="relGDisplayDiv">
					                            		<c:out value='${item.endRatio}' />
					                            	</div>
				                            		<div class="relGInputDiv">
				                            			<input type="text" class="w60 gEndRatio" id="gEndRatio${status.index}" value="${item.endRatio}" />
				                            		</div>
				                            	</td>
				                            	<td>
													<div class="ui toggle checkbox">
														<input type="checkbox" id="useYn_${item.scorRelCd}" data-orgid="${item.orgId}" data-scorrelcd="${item.scorRelCd}" data-unicd="${item.uniCd}" <c:if test="${item.useYn eq 'Y'}">checked</c:if> onchange="changeUseYn(this);">
									                </div> 
				                            	</td>
				                        	</tr>
				                        </c:forEach>
				                    </c:if>
				                </tbody>
				            </table>
					</div>
					<!-- //탭 콘텐츠 -->
					<!-- //콘텐츠 영역 -->
				</div>
				<!-- //ui form -->

            </div>
        </div>
        <!-- //본문 content 부분 -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
    </div>
</form>
</body>
</html>
