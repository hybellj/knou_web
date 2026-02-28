<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
$(function() {
	$(".tabmenu.menu .item").tab();
	
	$(".conCInputDiv").hide();
	$(".conGInputDiv").hide();
	
	tabSelected("${tabOrd}");
});

function tabSelected(tabMenu) {
	if(tabMenu === "C") {
		$('.tabmenu.menu .item').tab('change tab', 'tabcont1')
	} else if(tabMenu === "G") {
		$('.tabmenu.menu .item').tab('change tab', 'tabcont2')
	}
}

// 사용여부
function changeUseYn(obj) {
//	var result = confirm("<spring:message code='score.alert.useYn'/>"); // 사용여부를 수정하시겠습니까?
//	if(!result){return false;}

	var orgId = $(obj).data("orgid");
	var scorCd = $(obj).data("scorcd");
	var uniCd = $(obj).data("unicd");

	if($(obj).is(":checked")) {
		var useYn = "Y";
	} else {
		var useYn = "N";
	}
	
	var data = {
		"orgId" : orgId,
		"scorCd" : scorCd,
		"uniCd" : uniCd,
		"useYn" : useYn,
	}
	
	ajaxCall("/score/scoreConf/editConvertUseYn.do", data, function(data) {
		if(data.result > 0) {
			alert("<spring:message code='score.alert.message.open.yes' />");// 사용여부를 수정하였습니다.
		} else {
			alert(data.message);
		}
	}, function(xhr, status, error) {
		alert("<spring:message code='socre.common.error' />");// 오류가 발생했습니다!
	});
}

// 입력 폼 변환
function chgDisplay(type) {
	if(type === 1) {
		// 학부 취소버튼 클릭
		$("#chgCDisplayBtn").show();
		$("#chgCDisplayDiv").hide();
		$(".conCInputDiv").hide();
		$(".conCDisplayDiv").show();
	} else if(type === 2) {
		// 학부 관리버튼 클릭
		$("#chgCDisplayBtn").hide();
		$("#chgCDisplayDiv").show();
		$(".conCInputDiv").show();
		$(".conCDisplayDiv").hide();
	} else if(type === 3) {
		//대학원 취소버튼 클릭
		$("#chgGDisplayBtn").show();
		$("#chgGDisplayDiv").hide();
		$(".conGInputDiv").hide();
		$(".conGDisplayDiv").show();
	} else if(type === 4) {
		// 학부 관리버튼 클릭
		$("#chgGDisplayBtn").hide();
		$("#chgGDisplayDiv").show();
		$(".conGInputDiv").show();
		$(".conGDisplayDiv").hide();
	}
}

function save(type) {
	var scorCds = "";
	var avgScors = "";
	var baseScors = "";
	var startScors = "";
	var endScors = "";
	if(type === 'C') {
		$(".cClassData").each(function(i) {
			if(i > 0) {
				scorCds += "|";
				avgScors += "|";
				baseScors += "|";
				startScors += "|";
				endScors += "|";
			}
			scorCds += $("#cScorCd"+ i).data("scorcd");
			avgScors += $("#cAvgScor"+ i).val();
			baseScors += $("#cBaseScor"+ i).val();
			startScors += $("#cStartScor"+ i).val();
			endScors += $("#cEndScor"+ i).val();
		});
	} else if(type === 'G') {
		$(".gClassData").each(function(i) {
			if(i > 0) {
				scorCds += "|";
				avgScors += "|";
				baseScors += "|";
				startScors += "|";
				endScors += "|";
			}
			scorCds += $("#gScorCd"+ i).data("scorcd");
			avgScors += $("#gAvgScor"+ i).val();
			baseScors += $("#gBaseScor"+ i).val();
			startScors += $("#gStartScor"+ i).val();
			endScors += $("#gEndScor"+ i).val();
		});
	}

	var url  = "/score/scoreConf/editConvertClassAjax.do";
	var data = {
		"scorCds" : scorCds,
		"avgScors" : avgScors,
		"baseScors" : baseScors,
		"startScors" : startScors,
		"endScors" : endScors,
		"uniCd" : type
	};

	ajaxCall(url, data, function(data) {
		if (data.result > 0) {
			alert("<spring:message code='score.alert.success_save.message'/>"); // 정상적으로 저장되었습니다.
			
			location.href="/score/scoreConf/convertClassList.do?tabOrd="+type;
		} else {
			alert(data.message);
		}
	}, function(xhr, status, error) {
		alert("<spring:message code='forum.common.error'/>"); // 오류가 발생했습니다!
	});
}
</script>

<body>
<form class="ui form" id="convertListForm" name="convertListForm" method="POST">
<input type="hidden" id="scorCd" name="scorCd" value="">
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
							<small class="section"><spring:message code="score.exchange.grade.label"/><!-- 성적환산등급 --></small>
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
	                        <table class="table" data-sorting="false" data-paging="false" data-empty="<spring:message code='score.grade.table.empty.label'/>"><!-- 등록된 성적환산등급 정보가 없습니다. -->
	                            <thead>
	                                <tr>
	                                    <th scope="col" data-type="number" class="num"><spring:message code="common.number.no" /></th> <!-- No. -->
	                                    <th scope="col"><spring:message code="socre.grade.label"/></th><!-- 성적등급 -->
	                                    <th scope="col"><spring:message code="socre.grade.point.average.label"/></th><!-- 평점 -->
	                                    <th scope="col"><spring:message code="score.standard.label"/></th><!-- 기준점수 -->
	                                    <th scope="col"><spring:message code="score.start.label"/></th><!-- 시작점수 -->
	                                    <th scope="col" ><spring:message code="score.end.label"/></th><!-- 종료점수 -->
	                                    <th scope="col"><spring:message code="score.useyn.label"/></th><!-- 사용여부 -->
	                                </tr>
	                            </thead>
	                            <tbody>
	                                <c:if test="${not empty convertCClassList}">
	                                    <c:forEach items="${convertCClassList}" var="item" varStatus="status">
	                                        <tr class="cClassData">
	                                            <td><c:out value='${item.scorOdr}' /></td>
	                                            <td id="cScorCd${status.index}" data-scorcd="${item.scorCd}"><c:out value='${item.scorCd}' /></td>
	                                            <td>
	                                            	<div class="conCDisplayDiv">
	                                            		<c:out value='${item.avgScor}' />
	                                            	</div>
	                                            	<div class="conCInputDiv">
	                                            		<input type="text" class="w60 cAvgScor" id="cAvgScor${status.index}" value="${item.avgScor}" />
	                                            	</div>
	                                            </td>
	                                            <td>
	                                            	<div class="conCDisplayDiv">
	                                            		<c:out value='${item.baseScor}' />
	                                            	</div>
	                                            	<div class="conCInputDiv">
	                                            		<input type="text" class="w60 cBaseScor" id="cBaseScor${status.index}" value="${item.baseScor}" />
	                                            	</div>
	                                            </td>
	                                            <td>
	                                            	<div class="conCDisplayDiv">
	                                            		<c:out value='${item.startScor}' />
	                                            	</div>
	                                            	<div class="conCInputDiv">
	                                            		<input type="text" class="w60 cStartScor" id="cStartScor${status.index}" value="${item.startScor}" />
	                                            	</div>
	                                            </td>
	                                            <td>
	                                            	<div class="conCDisplayDiv">
	                                            		<c:out value='${item.endScor}' />
	                                            	</div>
	                                            	<div class="conCInputDiv">
	                                            		<input type="text" class="w60 cEndScor" id="cEndScor${status.index}" value="${item.endScor}" />
	                                            	</div>
	                                            </td>
	                                            <td>
	                                                <div class="ui toggle checkbox">
	                                                    <input type="checkbox" id="useYn_${item.scorCd}" data-orgid="${item.orgId}" data-scorcd="${item.scorCd}" data-unicd="${item.uniCd}" <c:if test="${item.useYn eq 'Y'}">checked</c:if> onchange="changeUseYn(this);">
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
	                        <table class="table" data-sorting="false" data-paging="false" data-empty="<spring:message code='score.grade.table.empty.label'/>"><!-- 등록된 성적환산등급 정보가 없습니다. -->
	                            <thead>
	                                <tr>
	                                    <th scope="col" data-type="number" class="num"><spring:message code="common.number.no" /></th> <!-- No. -->
	                                    <th scope="col"><spring:message code="socre.grade.label"/></th><!-- 성적등급 -->
	                                    <th scope="col"><spring:message code="socre.grade.point.average.label"/></th><!-- 평점 -->
	                                    <th scope="col"><spring:message code="score.standard.label"/></th><!-- 기준점수 -->
	                                    <th scope="col"><spring:message code="score.start.label"/></th><!-- 시작점수 -->
	                                    <th scope="col" ><spring:message code="score.end.label"/></th><!-- 종료점수 -->
	                                    <th scope="col"><spring:message code="score.useyn.label"/></th><!-- 사용여부 -->
	                                </tr>
	                            </thead>
	                            <tbody>
	                                <c:if test="${not empty convertGClassList}">
	                                    <c:forEach items="${convertGClassList }" var="item" varStatus="status">
	                                        <tr class="gClassData">
	                                            <td><c:out value='${item.scorOdr }' /></td>
	                                            <td id="gScorCd${status.index}" data-scorcd="${item.scorCd}"><c:out value='${item.scorCd}' /></td>
	                                            <td>
	                                            	<div class="conGDisplayDiv">
	                                            		<c:out value='${item.avgScor}' />
	                                            	</div>
	                                            	<div class="conGInputDiv">
	                                            		<input type="text" class="w60 gAvgScor" id="gAvgScor${status.index}" value="${item.avgScor}" />
	                                            	</div>
	                                            </td>
	                                            <td>
	                                            	<div class="conGDisplayDiv">
	                                            		<c:out value='${item.baseScor}' />
	                                            	</div>
	                                            	<div class="conGInputDiv">
	                                            		<input type="text" class="w60 conGInputDiv" id="gBaseScor${status.index}" value="${item.baseScor}" />
	                                            	</div>
	                                            </td>
	                                            <td>
	                                            	<div class="conGDisplayDiv">
	                                            		<c:out value='${item.startScor}' />
	                                            	</div>
	                                            	<div class="conGInputDiv">
	                                            		<input type="text" class="w60 conGInputDiv" id="gStartScor${status.index}" value="${item.startScor}" />
	                                            	</div>
	                                            </td>
	                                            <td>
	                                            	<div class="conGDisplayDiv">
	                                            		<c:out value='${item.endScor}' />
	                                            	</div>
	                                            	<div class="conGInputDiv">
	                                            		<input type="text" class="w60 conGInputDiv" id="gEndScor${status.index}" value="${item.endScor}" />
	                                            	</div>
	                                            </td>
	                                            <td>
	                                                <div class="ui toggle checkbox">
	                                                    <input type="checkbox" id="useYn_${item.scorCd}" data-orgid="${item.orgId}" data-scorcd="${item.scorCd}" data-unicd="${item.uniCd}" <c:if test="${item.useYn eq 'Y'}">checked</c:if> onchange="changeUseYn(this);">
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
