<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%; height: 100%; overflow:auto">
<head>
	<%@ include file="/WEB-INF/jsp/common/admin/modal_admin_common.jsp" %> 
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp"%>
</head>

<script type="text/javascript">
	$(document).ready(function() {

		//권한 그룹 선택시 권한별 메뉴 리스트 조회
		$('.select-list.radiobox td.refresh').bind('click', function() {
			// setAuthGrpCd();
			// menuList();
			// location.reload();
		});
		
		//권한 그룹 사용 여부 수정
		$('.ui.toggle.checkbox').checkbox({
			onChange : function() {
				if($(this).prop("checked")){$(this).val("Y");}else{$(this).val("N");};
            	var splitVal = $(this).attr("name").split('_')[1];
            	editAuthGrpUseYn(splitVal);
            }
        });
	});
	
	/**
	 * 서브밋 처리
	 */
	function process(cmd, authGrpCd) {

		$("#menuForm_"+authGrpCd+" input[name='authGrpNm']").val($("#authGrpNm_"+authGrpCd).val());
		$("#menuForm_"+authGrpCd+" input[name='authGrpCd']").val($("#authGrpCd_"+authGrpCd).val());
		$("#menuForm_"+authGrpCd+" input[name='useYn']").val($("#useYn_"+authGrpCd).val());
		$("#menuForm_"+authGrpCd).attr("action","/menu/menuMgr/"+cmd);
		
		$.getJSON("/menu/menuMgr/"+cmd+".do",$("#menuForm_"+authGrpCd).serialize()
			, function(data) {
            	alert(data.message);
	            if (data.result > 0) {
	            	// authList();
	            	// menuList();
	            	location.reload();
	            }
        	}
		);
	}

	/**
	 * 처리 결과 표시 콜백
	 */
	function processCallback(resultVO) {

		if(resultVO.result >= 0) {
			// 정상 처리
			parent.listAuthGroup();
			parent.modalBoxClose();
		} else {
			// 비정상 처리
		}
	}

	/**
	 * 권한 그룹 추가 폼
	 */
	function addAuthGroupForm() {
		if($("#menuForm_New").size() > 0){
			alert('<spring:message code="main.sysMenu.alert.dup.addRow" />');	/* 이미 추가 등록로우가 생성되었습니다. */
			return false;
		}
		var cnt = $("#authGrpList tr").size();
		var tr = "";
		tr += "<tr class=\"New_addForm\">"
		+"<td class=\"refresh\">"
		+"<form name=\"menuForm\" id=\"menuForm_New\" method=\"POST\" onsubmit=\"return false\">"
		+"<input type=\"hidden\" name=\"menuType\" value=\""+$(".menuType.active").attr("id")+"\"/>"
		+"<input type=\"hidden\" name=\"authGrpOdr\" value=\""+cnt+"\"/>"
		+"<input type=\"hidden\" name=\"authGrpNm\" value=\"\"/>"
		+"<input type=\"hidden\" name=\"authGrpCd\" value=\"\"/>"
		+"<input type=\"hidden\" name=\"useYn\" value=\"\"/>"
		+"</form>"
		+"<div class=\"ui-mark\">"
		+"<input type=\"radio\" name=\"authGrpCd\" value=\"\" title=\"\" />"
		+"<label><i class=\"ion-android-done\"></i></label>"
		+"</div>"
		+"</td>"
		+"<td>"
		+"<div class=\"ui small input w100\">"
		+"<input type=\"text\" name=\"authGrpNm_New\" id=\"authGrpNm_New\" maxlength=\"50\" value=\"\"/>"
		+"</div>"
		+"</td>"
		+"<td>"
		+"<div class=\"ui small input w100\">"
		+"<input type=\"text\" name=\"authGrpCd_New\" id=\"authGrpCd_New\" maxlength=\"50\" value=\"\"/>"
		+"</div>"
		+"</td>"
		+"<td>"
		+"<div class=\"ui toggle checkbox\">"
		+"<input type=\"hidden\" name=\"useYn_New\" id=\"useYn_New\" maxlength=\"50\" value=\"Y\" />"
		+"</div>"
		+"</td>"
		+"<td>"
		+"<div class=\"ui basic small buttons\">"
		+"<a href=\"javascript:addAuthGroup('New');\" class=\"ui button\"><spring:message code='button.create'/></a>"
		+"<a href=\"javascript:addCancelForm('New');\" class=\"ui button\"><spring:message code='button.cancel'/></a>"
		+"</div>"
		+"</td>"
		+"</tr>";
		$("#authGrpList").append(tr);
		$(".table").footable();
		$(".ui.checkbox").checkbox();
	}
	
	/**
	 * 권한 그룹 추가 폼 취소
	 */
	function addCancelForm(authGrpCd) {
		$("."+authGrpCd+"_addForm").remove();
	}
	
	/**
	 * 권한 그룹 수정 폼
	 */
	function authGroupEdit(authGrpCd) {
		$("."+authGrpCd+"_editForm").show();
		$("."+authGrpCd+"_viewForm").hide();
	}
	
	/**
	 * 권한 그룹 수정 폼 취소
	 */
	function editCancelFrom(authGrpCd) {
		$("."+authGrpCd+"_editForm").hide();
		$("."+authGrpCd+"_viewForm").show();
	}
	
	/**
	 * 권한 그룹 수정
	 */
	function editAuthGroup(authGrpCd) {
		process("editAuthGrp",authGrpCd);	// cmd
	}
	
	/**
	 * 권한 그룹 사용 수정
	 */
	function editAuthGrpUseYn(authGrpCd) {
		process("editAuthGrpUseYn",authGrpCd);	// cmd
	}
	
	/**
	 * 권한 그룹 추가
	 */
	function addAuthGroup(authGrpCd) {
		process("addAuthGrp",authGrpCd);	// cmd
	}
	
	/**
	 * 권한 그룹 삭제
	 */
	function delAuthGroup(authGrpCd) {
		/* 권한 그룹을 삭제하려고 합니다.\n\n삭제 하시겠습니까? */
		if(confirm('<spring:message code="main.sysMenu.alert.auth.grp.del.msg" />'+'\n\n'+'<spring:message code="main.sysMenu.alert.del.msg" />')) {	
			process("removeAuthGrp",authGrpCd);	// cmd
		} else {
			return;
		}
	}
</script>

<body class="modal-page">
	<div id="wrap" style="overflow: auto;height: 100vh;">
		<div class="option-content mb30">
			<div class="button-area mo-wmax">
				<a href="#0" onclick="javascript:addAuthGroupForm();" class="ui basic button"><spring:message code="button.write.authgrp"/></a>	<!-- 권한 그룹 추가 -->
			</div>
		</div>
		<table class="table select-list radiobox" data-sorting="true" data-paging="false" data-empty="<spring:message code="common.nodata.msg" />">	<!-- 등록된 내용이 없습니다. -->
			<thead>
				<tr>
					<th scope="col" data-sortable="false" class="menuType">
						<div class="ui-mark">
							<i class="ion-android-done"></i>
						</div>
					</th>
					<th scope="col"><spring:message code="common.label.auth.grpnm"/></th>	<!-- 권한 그룹명 -->
					<th scope="col"><spring:message code="common.label.auth.grpcd"/></th>	<!-- 권한 그룹 코드 -->
					<th scope="col" data-breakpoints="xs"><spring:message code="common.use"/></th>		<!-- 사용 -->
					<th scope="col" data-breakpoints="xs" data-sortable="false"><spring:message code="common.mgr"/></th>	<!-- 관리 -->
				</tr>
			</thead>
			<tbody id="authGrpList">
				<c:forEach var="item" items="${authGrpList}">
					<c:set var="authGrpNm" value="${item.authGrpNm}"/>
					<c:forEach var="lang" items="${item.authGrpLangList}">
						<c:if test="${lang.langCd eq LOCALEKEY}">
							<c:set var="authGrpNm" value="${lang.authGrpNm}"/>
						</c:if>
					</c:forEach>
					<tr>
						<td class="refresh">
							<form name="menuForm" id="menuForm_${item.authGrpCd}" method="POST" onsubmit="return false">
								<input type="hidden" name="menuType" value="${item.menuType}"/>
								<input type="hidden" name="authGrpOdr" value="${item.authGrpOdr}" />
								<input type="hidden" name="authGrpNm" value="${authGrpNm}"/>
								<input type="hidden" name="authGrpCd" value="${item.authGrpCd}"/>
								<input type="hidden" name="useYn" value="${item.useYn}"/>
							</form>
							<div class="ui-mark">
								<input type="radio" name="authGrpCd" value="${item.authGrpCd}" />
									<%-- <c:if test="${item.authGrpCd eq vo.authGrpCd}">checked</c:if> title="${authGrpNm}" /> --%>
								<label><i class="ion-android-done"></i></label>
							</div>
						</td>
						<td>
							<div class="ui small input w100">
								<span class="${item.authGrpCd}_editForm" style="display: none;">
									<input type="text" name="authGrpNm_${item.authGrpCd}" id="authGrpNm_${item.authGrpCd}" maxlength="50" value="${authGrpNm}"/>
								</span>
								<span class="${item.authGrpCd}_viewForm">
									${authGrpNm}
								</span>
							</div>
						</td>
						<td>
							<div class="ui small input w100">
								<span class="${item.authGrpCd}_editForm" style="display: none;">
									<input type="text" name="authGrpCd_${item.authGrpCd}" id="authGrpCd_${item.authGrpCd}" maxlength="50" value="${item.authGrpCd}"/>
								</span>
								<span class="${item.authGrpCd}_viewForm">
									${item.authGrpCd}
								</span>
							</div>
						</td>
						<td>
							<div class="ui toggle checkbox">
								<input type="checkbox" name="useYn_${item.authGrpCd}" id="useYn_${item.authGrpCd}" value="${item.useYn}"  style="border:0" <c:if test="${item.useYn eq 'Y'}">checked</c:if>/>
							</div>
						</td>
						<td>
							<div class="ui basic small buttons">
								<span class="${item.authGrpCd}_editForm" style="display: none;">
									<a href="javascript:editAuthGroup('${item.authGrpCd}');" class="ui button"><spring:message code="button.write"/></a>		<!-- 등록 -->
									<a href="javascript:editCancelFrom('${item.authGrpCd}')" class="ui button"><spring:message code="button.cancel"/></a>	<!-- 취소 -->
								</span>
								<span class="${item.authGrpCd}_viewForm">
									<a href="javascript:authGroupEdit('${item.authGrpCd}');" class="ui button"><spring:message code="button.edit"/></a>			<!-- 수정 -->
									<a href="javascript:delAuthGroup('${item.authGrpCd}')" class="ui button"><spring:message code="button.delete"/></a>		<!-- 삭제 -->
								</span>
							</div>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>