<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	<script type="text/javascript">
		$(document).ready(function() {
			listUserChgHsty(1);
		});
		
		// 사용자 정보 변경 이력 목록
		function listUserChgHsty(pageIndex) {
			var url  = "/user/userMgr/userInfoChgHstyListPaging.do";
			var data = {
				  userId    : '<c:out value="${userInfoVO.userId}" />'
				, pageIndex : pageIndex
				, listScale : 5
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		var returnList = data.returnList || [];
	        		var html = "";
	        		
	       			returnList.forEach(function(v, i) {
	       				var regDttm   = (v.regDttm || "").length == 14 ? v.regDttm.substring(0, 4) + "." + v.regDttm.substring(4, 6) + "." + v.regDttm.substring(6, 8) + " " + v.regDttm.substring(8, 10) + ":" + v.regDttm.substring(10, 12) : v.regDttm;
	       				
	       				html += '<tr>';
	       				html += '	<td>' + v.lineNo + '</td>';
	       				html += '	<td>' + (v.connIp || '') + '</td>';
	       				html += '	<td>' + v.regNm + '</td>';
	       				html += '	<td>' + v.userInfoChgDivNm + '</td>';
	       				html += '	<td>' + regDttm + '</td>';
	       				html += '	<td>' + (v.chgTarget || '') + '</td>';
	       				html += '</tr>';
	       			});
	        		
	        		$("#userChgHstyList").empty().html(html);
			    	$("#userChgHstyTable").footable();
			    	var params = {
				    	totalCount 	  : data.pageInfo.totalRecordCount,
				    	listScale 	  : data.pageInfo.recordCountPerPage,
				    	currentPageNo : data.pageInfo.currentPageNo,
				    	eventName 	  : "listUserChgHsty"
				    };
				    
				    gfn_renderPaging(params);
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='fail.common.msg' />"); // 에러가 발생했습니다!
			});
		}
		
		// 메세지 보내기
		function sendMsg() {
			var userId = '<c:out value="${userInfoVO.userId}" />';
			var userNm = '<c:out value="${userInfoVO.userNm}" />';
			var mobileNo = '<c:out value="${userInfoVO.mobileNo}" />';
			var email = '<c:out value="${userInfoVO.email}" />';
			
			var rcvUserInfoStr = userId + ";" + userNm + ";" + mobileNo + ";" + email;
			
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
            
        		<div class="ui form">
        			<div class="layout2">
		                <div id="info-item-box">
		                	<h2 class="page-title flex-item flex-wrap gap4 columngap16">
                                <spring:message code="user.title.userinfo.tch" /><!-- 운영자 관리 -->
                                <div class="ui breadcrumb small">
                                    <small class="section"><spring:message code="user.title.userinfo.detail.info" /><!-- 상세정보 --></small>
                                </div>
                            </h2>
		                    <div class="mla">
		                    	<uiex:msgSendBtn func="sendMsg()" styleClass="ui basic button"/><!-- 메시지 -->
		                    	<a href="<c:url value="/user/userMgr/manageAdmin.do" />" class="ui green button"><spring:message code="common.button.list" /></a><!-- 목록 -->
		                    </div>
		                </div>
		        		<div class="row">
		        			<div class="col">
		        				<div class="ui card wmax">
		        					<div class="content">
		        						<p><spring:message code="user.title.userinfo" /></p><!-- 사용자 정보 -->
		        					</div>
		        					<div class="content">
		        						<div class="fields">
                                            <div class="four wide field flex-item-center mo-none">
                                            	<div class="initial-img lg bcLgrey">
                                            		<c:choose>
                                            			<c:when test="${empty userInfoVO.phtFile}">
                                            				<img src="/webdoc/img/icon-hycu-symbol-grey.svg">
                                            			</c:when>
                                            			<c:otherwise>
                                            				<img src="${userInfoVO.phtFile}">
                                            			</c:otherwise>
                                            		</c:choose>
		                                        </div>
                                            </div>
                                            <div class="twelve wide field">
                                                <div class="fields">
                                                    <div class="five wide field"><label><spring:message code="user.title.userinfo.titenancy" /></label></div><!-- 소속(테넌시) -->
                                                    <div class="eleven wide field"><c:out value="${userInfoVO.orgNm}" /></div>
                                                </div>
                                                <div class="fields">
                                                    <div class="five wide field"><label><spring:message code="user.title.userinfo.manage.userid" /></label></div><!-- 학번 -->
                                                    <div class="eleven wide field"><c:out value="${userInfoVO.userId}" /></div>
                                                </div>
                                                <div class="fields">
                                                    <div class="five wide field"><label><spring:message code="user.title.userinfo.user.div" /></label></div><!-- 사용자 구분 -->
                                                    <div class="eleven wide field"><c:out value="${userInfoVO.authGrpCd}" /></div>
                                                </div>
                                                <div class="fields">
                                                    <div class="five wide field"><label><spring:message code="user.title.userdept.dept" /></label></div><!-- 학과/부서 -->
                                                    <div class="eleven wide field"><c:out value="${userInfoVO.deptNm}" /></div>
                                                </div>
                                                <div class="fields">
                                                    <div class="five wide field"><label><spring:message code="user.title.userinfo.manage.usernm" /></label></div><!-- 이름 -->
                                                    <div class="eleven wide field"><c:out value="${userInfoVO.userNm}" /></div>
                                                </div>
                                                <div class="fields">
                                                    <div class="five wide field"><label><spring:message code="user.title.userinfo.manage.usernm.en" /></label></div><!-- 이름(영문) -->
                                                    <div class="eleven wide field"><c:out value="${userInfoVO.userNmEng}" /></div>
                                                </div>
                                                <div class="fields">
                                                    <div class="five wide field"><label><spring:message code="user.title.userinfo.mobileno" /></label></div><!-- 휴대폰 번호 -->
                                                    <div class="eleven wide field"><c:out value="${userInfoVO.mobileNo}" /></div>
                                                </div>
                                                <div class="fields">
                                                    <div class="five wide field"><label><spring:message code="user.title.userinfo.email" /></label></div><!-- 이메일 -->
                                                    <div class="eleven wide field"><c:out value="${userInfoVO.email}" /></div>
                                                </div>
                                            </div>
                                        </div>
		        					</div>
		        				</div>
		        				<div class="ui card wmax">
		        					<div class="content">
		        						<p><spring:message code="user.title.userinfo.change.info.log" /></p><!-- 사용자 정보 변경 이력 -->
		        					</div>
		        					<div class="content">
		        						<table class="table" id="userChgHstyTable" data-sorting="true" data-paging="false" data-empty="<spring:message code='user.common.empty' />"><!-- 등록된 내용이 없습니다. -->
		        							<thead>
		        								<tr>
		        									<th><spring:message code="common.number.no" /></th><!-- NO. -->
		        									<th><spring:message code="user.title.manage.userinfo.conn.ip" /></th><!-- 접속 IP -->
		        									<th><spring:message code="user.title.manage.userinfo.edit.user" /></th><!-- 변경자 -->
		        									<th><spring:message code="user.title.userinfo.manage.userdiv" /></th><!-- 구분 -->
		        									<th data-breakpoints="xs sm md"><spring:message code="user.title.manage.userinfo.edit.dttm" /></th><!-- 변경일시 -->
		        									<th data-breakpoints="xs sm md"><spring:message code="user.title.manage.userinfo.edit.cnts" /></th><!-- 변경내역 -->
		        								</tr>
		        							</thead>
		        							<tbody id="userChgHstyList">
		        							</tbody>
		        						</table>
		        						<div id="paging" class="paging"></div>
		        					</div>
		        				</div>
		        				<div class="option-content gap4 tc">
			                    	<a href="<c:url value="/user/userMgr/manageAdmin.do" />" class="ui green button"><spring:message code="common.button.list" /></a><!-- 목록 -->
		        				</div>
		        			</div>
		        		</div>
        			</div>
        		</div>
			</div>
        </div>
        <!-- //본문 content 부분 -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
    </div>
</body>
</html>