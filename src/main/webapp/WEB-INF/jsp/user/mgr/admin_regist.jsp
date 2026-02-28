<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#searchValue").on("keyup", function(e){
				if(e.keyCode == 13) {
					listPaging(1);
				}
			});
			
			$("#authGrpCd, #authGrpCd2").on("change", function() {
				searchAuthGrp(1, this.value);
			});
			
			listPaging(1);
		});
		
		// 권한 검색
		function searchAuthGrp(page, authGrpCd) {
			$("#authGrpCd").off("change");
			$("#authGrpCd2").off("change");
			
			authGrpCd = (authGrpCd || "").replace("ALL", "");
			
			setTimeout(function() {
				if(authGrpCd) {
					if($("#authGrpCd > option[value='" + authGrpCd + "']").length && ($("#authGrpCd2").val() || "").replace("ALL", "")) {
						$("#authGrpCd2").dropdown("set value", "ALL");
					} else if($("#authGrpCd2 > option[value='" + authGrpCd + "']").length && ($("#authGrpCd").val() || "").replace("ALL", "")) {
						$("#authGrpCd").dropdown("set value", "ALL");
					}
				}
				
				$("#authGrpCd, #authGrpCd2").on("change", function() {
					searchAuthGrp(1, this.value);
				});
				
				listPaging(1);
			}, 0);
		}
		
		// 목록 조회
		function listPaging(pageIndex) {
			var url  = "/user/userMgr/listPagingUser.do";
			var data = {
				  authGrpCd		: ($("#authGrpCd").val() || "").replace("ALL", "") || ($("#authGrpCd2").val() || "").replace("ALL", "")
				, deptCd		: ($("#deptCd").val() || "").replace("ALL", "")
			    , pageIndex   	: pageIndex
				, listScale   	: $("#listScale").val()
				, searchValue 	: $("#searchValue").val()
				, menuTypes		: "ADMIN,PROFESSOR"
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		var returnList = data.returnList || [];
	        		var html = '';
	        		
        			returnList.forEach(function(v, i) {
            			html += '<tr>';
            			html += '	<td class="tr">' + v.lineNo + '</td>';
            			html += '	<td class="">' + (v.adminAuthGrpNm || '-') + '</td>';
            			html += '	<td class="">' + (v.wwwAuthGrpNm || '-') + '</td>';
            			html += '	<td class="">' + (v.deptNm || '-') + '</td>';
            			html += '	<td class="">' + v.userId + '</td>';
            			html += '	<td class="word_break_none">';
            			html += '		<a class="fcBlue" href="javascript:userAuthChg(\'' + v.userId + '\')">' + v.userNm + '</a>';
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
	        		
	        		$("#userList").empty().html(html);
	        		$("#userTable").footable();
	        		
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
	</script>
</head>
<body>
    <div id="wrap" class="pusher">
        <!-- class_top 인클루드  -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>

        <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>

        <div id="container">
            <!-- 본문 content 부분 -->
            <div class="content">
            	<div id="info-item-box">
                	<h2 class="page-title flex-item flex-wrap gap4 columngap16">
                        <spring:message code="user.title.userinfo.tch" /><!-- 운영자 관리 -->
                        <div class="ui breadcrumb small">
                            <small class="section"><spring:message code="user.button.reg" /><!-- 등록 --></small>
                        </div>
					</h2>
                    <div class="button-area">
                    	<a class="ui basic button w100" href="<c:url value="/user/userMgr/manageAdmin.do" />"><spring:message code="common.button.list" /></a><!-- 목록 -->
                    </div>
                </div>
                <div class="ui divider mt0"></div>
        		<div class="ui form">
       				<div class="option-content gap4">
        				<select class="ui dropdown w200" id="authGrpCd">
        					<option value=""><spring:message code="user.title.userinfo.admin.type" /></option><!-- 관리자 구분 -->
        					<option value="ALL"><spring:message code="common.all" /></option><!-- 전체 -->
        					<c:forEach var="row" items="${userTypeList}">
        						<c:if test="${row.codeOptn eq 'ADMIN'}">
        							<option value="${row.codeCd}">${row.codeNm}</option>
        						</c:if>
        					</c:forEach>
        				</select>
        				<select class="ui dropdown" id="authGrpCd2">
        					<option value=""><spring:message code="user.title.userinfo.user.div" /></option><!-- 사용자 구분 -->
        					<option value="ALL"><spring:message code="common.all" /></option><!-- 전체 -->
        					<c:forEach var="row" items="${userTypeList}">
        						<c:if test="${row.codeOptn ne 'ADMIN'}">
        							<option value="${row.codeCd}">${row.codeNm}</option>
        						</c:if>
        					</c:forEach>
        				</select>
        				<select class="ui dropdown" id="deptCd" onchange="listPaging(1)">
                            <option value=""><spring:message code="user.title.userdept.select" /></option>
                            <option value="ALL"><spring:message code="common.all" /></option><!-- 전체 -->
                            <c:forEach var="item" items="${deptCdList}">
                                <option value="${item.deptCd}">${item.deptNm}</option>
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
						    </select>
						</div>
		            </div>
		            <div class="ui segment">
			            <table class="tBasic" data-sorting="false" data-paging="false" data-empty="<spring:message code='user.common.empty' />" id="userTable"><!-- 등록된 내용이 없습니다. -->
	       					<thead>
	       						<tr>
	       							<th class=""><spring:message code="common.number.no"/></th><!-- NO -->
	       							<th class=""><spring:message code="user.title.userinfo.tch.div" /></th><!-- 운영자 구분 -->
	       							<th class=""><spring:message code="user.title.userinfo.user.div" /></th><!-- 사용자 구분 -->
	       							<th class=""><spring:message code="user.title.userdept.dept" /></th><!-- 학과/부서 -->
	       							<th class=""><spring:message code="user.title.userinfo.user.no" /></th><!-- 학번/사번 -->
	       							<th class=""><spring:message code="user.title.userinfo.manage.usernm" /></th><!-- 이름 -->
	       							<th class=""><spring:message code="user.title.userinfo.phoneno" /></th><!-- 전화번호 -->
	       							<th class=""><spring:message code="user.title.userinfo.email" /></th><!-- 이메일 -->
	       						</tr>
			        		</thead>
			        		<tbody id="userList">
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
	<script>
	    $('iframe').iFrameResize();
	    window.closeModal = function() {
	        $('.modal').modal('hide');
	    };
	</script>
</body>
</html>