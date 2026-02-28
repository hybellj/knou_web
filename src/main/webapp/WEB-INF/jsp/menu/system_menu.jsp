<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
	$(function(){
		var selAuthGrpCd = $("#authGrpCd").val() == "" ? $("#authGrpCdDiv > a").filter(".active").attr("id") : $("#authGrpCd").val();

		var reg = /[`~!@#$%^&*()_|+\-=?;:'"<>\{\}\[\]\\\/ ]/gim;

		var resultData = selAuthGrpCd.replace(reg, "");
		onAuthMenuList(resultData);
	});

	function onChkAll(){
		if($("#chkAll").is(":checked")){
			$("[name=useYn]").prop("checked", true);
			$("[name=useYn]").val("Y");
		} else {
			$("[name=useYn]").prop("checked", false);
			$("[name=useYn]").val("N");
		}
	}

	function onAuthMenuList(authGrpCd){

		var url  = "/menu/menuMgr/sysMenuList.do";
		var data = {
			orgId : $("#orgId").val()
		  , authGrpCd : authGrpCd
		};

		$("#tbodyId").empty();

		ajaxCall(url, data, function(data) {
			var html = "";
			var menuNm = "";
			var useChecked = "";
			$.each(data, function(i, o){
				html += "<tr>";
	            html += "    <td>";

	            if(o.viewAuth == "Y"){
	            	useChecked = "checked";
	            } else {
	            	useChecked = "";
	            }
	            if(o.menuCd != 'ADM0000000001') {
					html += "	<div class='ui checkbox'><input type='checkbox' name='useYn' " + useChecked + " value='" + o.useYn + "' menuCd='" + o.menuCd +"' parMenuCd='" + o.parMenuCd +"' menuLvl='" + o.menuLvl +"'><label></label></div>";
	            }
	            html += "    </td>";
	            if(o.menuLvl == "2"){
	            	menuNm = "\u00A0" + "\u00A0" + "\u00A0" + "\u00A0" + "\u00A0" + "\u00A0" + "\u00A0" + "\u00A0" + "\u00A0" + "\u00A0" + o.menuNm;
	            } else if(o.menuLvl == "3"){
	            	menuNm = "\u00A0" + "\u00A0" + "\u00A0" + "\u00A0" + "\u00A0" + "\u00A0" + "\u00A0" + "\u00A0" + "\u00A0" + "\u00A0" +
	            			 "\u00A0" + "\u00A0" + "\u00A0" + "\u00A0" + "\u00A0" + "\u00A0" + "\u00A0" + "\u00A0" + "\u00A0" + "\u00A0" + o.menuNm;
	            } else {
	            	menuNm = o.menuNm;
	            }
	            html += "    <td class='tl'>" + menuNm + "</td>";
	            html += "</tr>";
			});

			$("#tbodyId").html(html);

			$(".table").footable();

			if(data.length == $("[name=useYn]:checked").length){
				$("#chkAll").prop("checked", true);
			}

			$("[name=useYn]").change(function(){
				if($(this).is(":checked")) {
					if($(this).attr("menuCd") == 'ADM0000000001') return;
						
					$("[name=useYn]").filter("[parMenuCd=" + $(this).attr("menuCd") + "]").prop("checked", true);
				
					if($(this).attr("parMenuCd") != "") {
						$("[menuCd=" + $(this).attr("parMenuCd") + "]").prop("checked", true);
					}
				} else {
					$("[name=useYn]").filter("[parMenuCd=" + $(this).attr("menuCd") + "]").prop("checked", false);

					/* 
					if($(this).attr("parMenuCd") != ""){
						$("[menuCd=" + $(this).attr("parMenuCd") + "]").prop("checked", false);
						$("[menuCd=" + $(this).attr("parMenuCd") + "]").val("N");
					} */
				}
			});
		}, function(xhr, status, error) {
			/* 에러가 발생했습니다! */
			alert('<spring:message code="fail.common.msg" />');
		});
	}

	function onSaveMenu() {
		var subList = [];
		
		$("[name=useYn]").each(function(i, o){
			subList.push({
				  menuCd: $(o).attr("menuCd")
				, viewAuth: ($(this).is(":checked") ? "Y" : "N")
			});
		});

		var url  = "/menu/menuMgr/updateSysMenuListUseYn.do";
		var data = {
			orgId 		: $("#orgId").val()
		  , authGrpCd 	: $("#authGrpCdDiv > .active").attr("id")
		  , subList 	: subList
		};
		console.log(subList)
		data = JSON.stringify(data);
		
		$.ajax({
			url: url,
			type: "POST",
			contentType: "application/json",
			data: data,
			dataType: "json",
			beforeSend : function() {
				showLoading();
			},
			success: function(data) {
				if(data.result > 0) {
					/* 저장되었습니다. */
					alert('<spring:message code="info.regok.msg" />');
					onAuthMenuList($("#authGrpCdDiv > .active").attr("id"));
	            } else {
	            	alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
	            }
	        	hideLoading();
			},
			error: function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			},
			complete: function() {
				hideLoading();
			},
		});
	}
</script>
<body>
	<div id="wrap" class="pusher">
        <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
        <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>
         <div id="container">
            <div class="content">
				
				<div class="ui form">
					<form name="orgMenuForm" id="orgMenuForm" onsubmit="return false" method="POST" action="/OrgMenuManage.do">
						<input type="hidden" name="cmd" id="cmd"/>
						<input type="hidden" name="menuType" id="menuType" value="${vo.menuType}"/>
						<input type="hidden" name="orgId" id="orgId" value="${vo.orgId}" />
						<input type="hidden" name="authGrpNm" id="authGrpNm"/>
						<input type="hidden" name="authGrpCd" id="authGrpCd" value="${vo.authGrpCd}"/>
						<input type="hidden" name="menuArray" id="menuArray"/>
						<input type="hidden" name="viewAuthArray" id="viewAuthArray"/>
						<input type="hidden" name="creAuthArray" id="creAuthArray"/>
					</form>
					<div id="info-item-box">
						<h2 class="page-title"><spring:message code="main.label.learning.activity" /> : <spring:message code="main.label.auth.menu" /></h2><!-- 학습활동 --><!-- 권한/메뉴 관리 -->
						<div class="button-area">
							<a href="javascript:onSaveMenu();" class="ui basic button"><spring:message code="socre.save.button" /></a>		<!-- 저장 -->
							<a href="javascript:;" class="ui gray button"><spring:message code="socre.cancel.button" /></a>	<!-- 취소 -->
						</div>
					</div>
					<div class="ui grid stretched row">
						<div class="sixteen wide tablet six wide computer column" id="authList">
							<div class="ui top attached message">
								<div class="header"><spring:message code="main.sysMenu.auth.grp.title" /></div>		<!-- 권한 그룹 관리 -->
							</div>
							<div class="ui bottom attached segment">
								<div class="option-content">
									<div class="ui basic vertical buttons btn-choice" id="authGrpCdDiv">
										<c:forEach var="item" items="${authGrpList}">
											<a href="javascript:onAuthMenuList('${item.authGrpCd}')"  id="${item.authGrpCd}" class="ui button menuType <c:if test="${fn:contains(vo.authGrpCd, item.authGrpCd)}">active</c:if>">${item.authGrpNm}</a>
										</c:forEach>
									</div>
								</div>
							</div>
						</div>
						<div class="sixteen wide tablet ten wide computer column" id="menuList">
							<div class="ui top attached message">
								<div class="header"><spring:message code="main.sysMenu.auth.menu.title" /></div><!-- 메뉴 권한 관리 -->
							</div>
							<div class="ui bottom attached segment">
								<table class="table c_table" data-paging="false" data-empty="<spring:message code="main.common.nodata.msg" />">
                                	<thead>
                                		<tr>
                                        	<th scope="col" class="wf5"><input type="checkbox" id="chkAll" onchange="javascript:onChkAll();"></th>
                                            <th scope="col"><spring:message code="resh.label.menu" /></th><!-- 메뉴 -->
                                        </tr>
                                    </thead>
                                    <tbody id="tbodyId">
                                    </tbody>
                                </table>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
</body>
</html>
