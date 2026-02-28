<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	<script type="text/javascript">
		$(document).ready(function(){
			$("#searchValue").on("keyup", function(e){
				if(e.keyCode == 13) {
					listPaging(1);
				}
			});
			
			listPaging(1);
		});
		
		// 목록 조회
		function listPaging(pageIndex) {
			var url  = "/user/userMgr/listUserByMenuType.do";
			var data = {
				  authGrpCd		: ($("#authGrpCd").val() || "").replace("ALL", "")
				, pageIndex   	: pageIndex
				, listScale   	: $("#listScale").val()
				, searchValue 	: $("#searchValue").val()
				, menuType		: "ADMIN"
				, pagingYn		: "Y"
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		var returnList = data.returnList || [];
	        		var html = '';
	        		
	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
	            			html += '<tr>';
	            			html += '	<td>';
	            			html += '		<div class="ui checkbox">';
	            			html += '			<input type="checkbox" id="userId_' + i + '" name="userIds" data-user-no="' + v.userId + '" data-user-nm="' + v.userNm + '" data-mobile-no="' + v.mobileNo + '" data-email="' + v.email + '">';
	            			html += '			<label class="toggle_btn" for="userId_' + i + '"></label>';
	            			html += '		</div>';
	            			html += '	</td>';
	            			html += '	<td class="tr">' + v.lineNo + '</td>';
	            			html += '	<td class="">' + (v.adminAuthGrpNm || '-') + '</td>';
	            			html += '	<td class="">' + (v.wwwAuthGrpNm || '-') + '</td>';
	            			html += '	<td class="">' + (v.deptNm || '-') + '</td>';
	            			html += '	<td class="">' + v.userId + '</td>';
	            			html += '	<td class="word_break_none">';
	            			html += '		<a class="fcBlue" href="javascript:viewAdmin(\'' + v.userId + '\')">' + v.userNm + '</a>';
	            			if(v.orgId == "ORG0000001") {
	            				// 한사대 erp 내정보
	            				html += '		<a href="javascript:userInfoPop(\'' + v.userId + '\')" class=""><i class="ico icon-info"></i></a>';
	            			} else {
	            				html += '		<a href="javascript:userMgrProfilePop(\'' + v.userId + '\')" class=""><i class="ico icon-info"></i></a>';
	            			}
	            			html += '	</td>';
	            			html += '	<td class="tc word_break_none">' + (v.mobileNo ? formatPhoneNumber(v.mobileNo) : '-') + '</td>';
	            			html += '	<td class="">' + (v.email || '') + '</td>';
	            			html += '	<td>';
            				html += '		<a href="javascript:userAuthChg(\'' + v.userId + '\')" class="ui small basic button"><spring:message code="user.title.userinfo.auth.grp.chg" /></a>'; // 권한 그룹 변경            				
	            			if(v.mstYn == "Y") {
	            			html += '		<a href="javascript:crecrsMonitoringSetting(\'' + v.userId + '\')" class="ui small basic button"><label class="fcBlue cur_point"><spring:message code="user.title.userinfo.monitoring.crecrs.pop" /></label></a>'; // 모니터링 과목설정
	            			}
	            			html += '	</td>';
	            			html += '</tr>';
	        			});
	        		}
	        		
	        		$("#adminList").empty().html(html);
	        		$("#adminTable").footable();
	        		
			    	var params = {
				    	  totalCount	: data.pageInfo.totalRecordCount
				    	, listScale		: data.pageInfo.recordCountPerPage
				    	, currentPageNo : data.pageInfo.currentPageNo
				    	, eventName		: "listPaging"
				    };
				    
				    gfn_renderPaging(params);
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
			}, true);
		}
		
		// 전체선택
		function checkAll(checked) {
			$("#adminTable").find("input:checkbox[name=userIds]:not(:disabled)").prop("checked", checked);
		}
		
		// 엑셀 다운로드
	    function excelDown() {
	    	var excelGrid = {
				colModel:[
					{label:'<spring:message code="common.number.no"/>', 					name:'lineNo', 			align:'right', 	width:'1000'},	// NO
					{label:'<spring:message code="user.title.userinfo.tch.div" />', 		name:'adminAuthGrpNm', 	align:'left', 	width:'5000'},	// 운영자 구분
					{label:'<spring:message code="user.title.userinfo.user.div" />', 		name:'wwwAuthGrpNm', 	align:'left', 	width:'5000'},	// 사용자 구분
					{label:'<spring:message code="user.title.userdept.dept" />', 			name:'deptNm', 			align:'left', 	width:'7000'},	// 학과/부서
					{label:'<spring:message code="admin.title.admininfo.admin.no" />', 		name:'userId', 			align:'left', 	width:'5000'},	// 사번
					{label:'<spring:message code="user.title.userinfo.manage.usernm" />', 	name:'userNm', 			align:'left', 	width:'5000'},	// 이름
					{label:'<spring:message code="user.title.userinfo.phoneno" />', 		name:'mobileNo', 		align:'center', width:'5000'},	// 전화번호
					{label:'<spring:message code="user.title.userinfo.email" />', 			name:'email', 			align:'left',	width:'9000'},	// 이메일
				]
	  		};

	    	$("form[name='excelForm']").remove();
			var excelForm = $('<form></form>');
			excelForm.attr("name","excelForm");
			excelForm.attr("action","/user/userMgr/adminExcelDownload.do");
			excelForm.append($('<input/>', {type: 'hidden', name: 'searchValue', 	value: $("#searchValue").val()}));
			excelForm.append($('<input/>', {type: 'hidden', name: 'authGrpCd', 		value: $("#authGrpCd").val()}));
			excelForm.append($('<input/>', {type: 'hidden', name: 'menuType', 		value: "ADMIN"}));
			excelForm.append($('<input/>', {type: 'hidden', name: 'excelGrid', 		value:JSON.stringify(excelGrid)}));
			excelForm.appendTo('body');
			excelForm.submit();
	    }
		
		 // 사용자 상세 정보
	    function viewAdmin(userId) {
		    var url  = "/user/userMgr/Form/viewAdmin.do";
		    var form = $("<form></form>");
		    form.attr("method", "POST");
		    form.attr("name", "viewForm");
		    form.attr("action", url);
		    form.append($('<input/>', {type: 'hidden', name: 'userId', value: userId}));
		    form.appendTo("body");
		    form.submit();
	    }
		 
		// 권한 그룹 변경
	    function userAuthChg(userId) {
	    	$("#userAuthChgForm > input[name='userIds']").val(userId);
			$("#userAuthChgForm").attr("target", "authChgPopIfm");
	        $("#userAuthChgForm").attr("action", "/user/userMgr/userAuthChgPop.do");
	        $("#userAuthChgForm").submit();
	        $('#authChgPop').modal('show');
	    }
		
	 	// 권한 그룹 변경 콜백
		function authGrpChangeCallBack() {
			if($("#paging > a.current").length == 1) {
				$("#paging > a.current").trigger("click");
			}
		}
	 	
		// 내정보 관리 팝업
	    function userMgrProfilePop(userId) {
	    	$("#userMgrProfileForm > input[name='userId']").val(userId);
			$("#userMgrProfileForm").attr("target", "userMgrProfilePopIfm");
			$("#userMgrProfileForm").attr("action", "/user/userMgr/userMgrProfilePop.do");
			$("#userMgrProfileForm").submit();
			$('#userMgrProfilePop').modal('show');
			
			$("#userMgrProfileForm > input[name='userId']").val("");
	    }
		
	 	// 메세지 보내기
		function sendMsg() {
			var rcvUserInfoStr = "";
			var sendCnt = 0;
			
			$.each($('#adminList').find("input:checkbox[name=userIds]:not(:disabled):checked"), function() {
				sendCnt++;
				if (sendCnt > 1) rcvUserInfoStr += "|";
				rcvUserInfoStr += $(this).data("userId");
				rcvUserInfoStr += ";" + $(this).data("userNm"); 
				rcvUserInfoStr += ";" + $(this).data("mobileNo");
				rcvUserInfoStr += ";" + $(this).data("email"); 
			});
			
			if (sendCnt == 0) {
				/* 메시지 발송 대상자를 선택하세요. */
				alert("<spring:message code='common.alert.sysmsg.select_user'/>");
				return;
			}
			
	        window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");

	        var form = document.alarmForm;
	        form.action = "<%=CommConst.SYSMSG_URL_SEND%>";
	        form.target = "msgWindow";
	        form[name='alarmType'].value = "S"; // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
	        form[name='rcvUserInfoStr'].value = rcvUserInfoStr; //보내는사람 정보
	        form.submit();
		}
	</script>
</head>
<body>
	<div id="wrap" class="pusher">
        <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
        <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>
        
        <div id="container">
        	<!-- 본문 content 부분 -->
            <div class="content">
            	<div id="info-item-box">
		        	<h2 class="page-title flex-item flex-wrap gap4 columngap16">
                    	<spring:message code="user.title.userinfo.tch" /><!-- 운영자 관리 -->
                    	<div class="ui breadcrumb small">
                        	<small class="section"><spring:message code="user.title.list" /><!-- 목록 --></small>
                       	</div>
                    </h2>
					<div class="button-area">
		            	<uiex:msgSendBtn func="sendMsg()" styleClass="ui basic button"/><!-- 메시지 -->
		                <a href="javascript:excelDown()" class="ui green button"><spring:message code="user.title.download.excel" /></a><!-- 엑셀 다운로드 -->
		                <a href="<c:url value="/user/userMgr/Form/registAdmin.do" />" class="ui orange button"><spring:message code="admin.title.admininfo.write" /></a><!-- 운영자 등록 -->
		            </div>
		        </div>
		        <div class="ui divider mt0"></div>
		        <div class="ui form">
		        	<div class="option-content gap4">
		        		<select class="ui dropdown w200" id="authGrpCd" onchange="listPaging(1)">
        					<option value=""><spring:message code="user.title.userinfo.admin.type" /></option><!-- 관리자 구분 -->
        					<option value="ALL"><spring:message code="common.all" /></option><!-- 전체 -->
        					<c:forEach var="row" items="${userTypeList}">
        						<c:if test="${row.codeOptn eq 'ADMIN'}">
        							<option value="${row.codeCd}">${row.codeNm}</option>
        						</c:if>
        					</c:forEach>
        				</select>
		        		<div class="ui action input search-box">
						    <input type="text" placeholder="<spring:message code='user.title.userinfo.dept.name' />/<spring:message code='admin.title.admininfo.admin.no' />/<spring:message code='user.title.userinfo.manage.usernm' />" class="w250" id="searchValue"><!-- 부서명/사번/이름 -->
						    <button class="ui icon button" onclick="listPaging(1)"><i class="search icon"></i></button>
						</div>
		        		<div class="mla">
							<select class="ui dropdown mr5 list-num" id="listScale" onchange="listPaging(1)">
						        <option value="10">10</option>
						        <option value="20">20</option>
						        <option value="50">50</option>
						        <option value="100">100</option>
						        <option value="1000">1000</option>
						    </select>
						</div>
		        	</div>
		        	<div class="ui segment">
		        		<table class="table type2" data-sorting="false" data-paging="false" data-empty="<spring:message code='user.common.empty' />" id="adminTable"><!-- 등록된 내용이 없습니다. -->
		        			<thead>
	       						<tr>
	       							<th class="">
	       								<div class="ui checkbox">
								            <input type="checkbox" name="allEvalChk" id="allChk" value="all" onchange="checkAll(this.checked)">
								            <label class="toggle_btn" for="allChk"></label>
								        </div>
	       							</th>
	       							<th class=""><spring:message code="common.number.no"/></th><!-- NO -->
	       							<th class=""><spring:message code="user.title.userinfo.tch.div" /></th><!-- 운영자 구분 -->
	       							<th class=""><spring:message code="user.title.userinfo.user.div" /></th><!-- 사용자 구분 -->
	       							<th class=""><spring:message code="user.title.userdept.dept" /></th><!-- 학과/부서 -->
	       							<th class=""><spring:message code="admin.title.admininfo.admin.no" /></th><!-- 사번 -->
	       							<th class=""><spring:message code="user.title.userinfo.manage.usernm" /></th><!-- 이름 -->
	       							<th class=""><spring:message code="user.title.userinfo.phoneno" /></th><!-- 전화번호 -->
	       							<th class=""><spring:message code="user.title.userinfo.email" /></th><!-- 이메일 -->
	       							<th class="" data-sortable="false"><spring:message code="user.title.manage" /></th><!-- 관리 -->
	       						</tr>
			        		</thead>
		        			<tbody id="adminList">
			        		</tbody>
		        		</table>
		        		<div id="paging" class="paging mt10"></div>
		        	</div>
		        </div>
            </div>
        </div>
        
		<!-- //본문 content 부분 -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
	</div>
	
	<!-- 권한 그룹 변경 팝업 -->
	<form id="userAuthChgForm" method="POST">
		<input type="hidden" id="userIds" name="userIds">
	</form>
	<div class="modal fade" id="authChgPop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="user.title.userinfo.auth.grp.chg" />" aria-hidden="false">
	    <div class="modal-dialog modal-lg" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code='user.button.close' />"><!-- 닫기 -->
	                    <span aria-hidden="true">&times;</span>
	                </button>
	                <h4 class="modal-title"><spring:message code="user.title.userinfo.auth.grp.chg" /></h4><!-- 권한 그룹 변경 -->
	            </div>
	            <div class="modal-body">
	                <iframe src="" id="authChgPopIfm" name="authChgPopIfm" width="100%" scrolling="no"></iframe>
	            </div>
	        </div>
	    </div>
	</div>
	
	<!-- 내정보 관리 팝업 -->
	<form id="userMgrProfileForm" name="userMgrProfileForm" method="post">
		<input type="hidden" name="userId" />
	</form>
    <div class="modal fade" id="userMgrProfilePop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="common.my.information" /><spring:message code="common.mgr" />" aria-hidden="false">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="common.button.close" />"><!-- 닫기 -->
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title"><spring:message code="common.my.information" /><spring:message code="common.mgr" /></h4>
                </div>
                <div class="modal-body">
                    <iframe src="" id="userMgrProfilePopIfm" name="userMgrProfilePopIfm" width="100%" scrolling="no" title="userMgrProfilePopIfm"></iframe>
                </div>
            </div>
        </div>
    </div>
	<script>
	    $('iframe').iFrameResize();
	    window.closeModal = function() {
	        $('.modal').modal('hide');
	    };
	</script>
</body>
</html>