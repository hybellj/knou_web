<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="knou.framework.util.StringUtil"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	
	<script type="text/javascript">
		$(document).ready(function() {
		
		});

		// 목록 이동
		function moveList() {
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "moveForm");
			form.attr("action", "/org/orgMgr/Form/orgManageList.do");
			form.appendTo("body");
			form.submit();
		}
		
		// 수정 이동
		function moveEdit() {
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "moveForm");
			form.attr("action", "/org/orgMgr/Form/orgInfoEdit.do");
			form.appendTo("body");
			form.submit();
		}
	</script>
</head>
<body>
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
            	<div id="info-item-box">
	            	<c:choose>
	               		<c:when test="${menu eq 'orgInfo'}">
	               			<h2 class="page-title flex-item">
		                    	<spring:message code="common.label.org.info" /><!-- 소속(테넌시) 정보 -->
		                   	</h2>
		                   	<c:if test="${userType.contains('SUP') or userType.contains('ADM')}">
		                    <div class="button-area">
								<a href="javascript:moveEdit()" class="ui orange button"><spring:message code='common.button.modify' /><!-- 수정 --></a>
		                    </div>
		                    </c:if>
	               		</c:when>
	               		<c:otherwise>
	        				<h2 class="page-title flex-item">
		                    	<spring:message code="common.label.org.mgr" /><!-- 소속(테넌시) 관리 -->
		                    	<div class="ui breadcrumb small">
							        <small class="section"><spring:message code='common.button.detailinfo' /><!-- 상세정보 --></small>
							    </div>
		                   	</h2>
		                    <div class="button-area">
								<a href="javascript:moveList()" class="ui basic button"><spring:message code='common.button.list' /><!-- 목록 --></a>
		                    </div>
	               		</c:otherwise>
	               	</c:choose>
                </div>
                <div class="ui divider mt0"></div>
            	<div class="ui form">
					
					<!-- 카드 -->
                    <div class="ui stackable  column grid mt10 mb10">
                        <div class="sixteen wide column flex flex-column">
                            <div class="ui attached message">
                                <div class="header"><spring:message code="common.label.org.info" /><!-- 소속(테넌시) 정보 --></div>
                            </div>
                            <div class="ui bottom attached segment flex1">
                                
                                <div class="fields">
                                    <div class="four wide field">
                                        <div class="initial-img2 flex-column">
                                            <img src="<c:out value="${empty orgInfoVO.fileList[0].fileView ? '/webdoc/img/icon-hycu-symbol-grey.svg' : orgInfoVO.fileList[0].fileView}" />" alt="사용자 이미지">
                                            <!-- <small class="ui info message p5 f070"><i class="info icon"></i>사이즈 80 x 40</small> -->
                                        </div>                                            
                                    </div>
                                    <ul class="twelve wide field">
                                        <li class="fields">
                                            <div class="five wide field"><label><spring:message code="common.label.org.cd" /><!-- 소속코드 --></label></div>
                                            <div class="eleven wide field"><c:out value="${orgInfoVO.orgId}" /></div>
                                        </li>
                                        <li class="fields">
                                            <div class="five wide field"><label><spring:message code="common.label.org" /><!-- 소속 --></label></div>
                                            <div class="eleven wide field"><c:out value="${orgInfoVO.orgNm}" /></div>
                                        </li>
                                        <li class="fields">
                                            <div class="five wide field"><label>접속경로</label></div>
                                            <div class="eleven wide field">
                                            	<c:if test="${orgInfoVO.orgId eq 'ORG0000001'}">
                                            		https://lms.hycu.ac.kr
                                            	</c:if>
                                            	<c:if test="${orgInfoVO.orgId ne 'ORG0000001'}">
                                            		https://lms.hycu.ac.kr/<c:out value="${orgInfoVO.domainNm}"/>
                                            	</c:if>
                                            </div>
                                        </li>
                                        <%-- <li class="fields">
                                            <div class="five wide field"><label><spring:message code="common.label.org" /><!-- 소속 --> Short name</label></div>
                                            <div class="eleven wide field"><c:out value="${orgInfoVO.orgSnm}" /></div>
                                        </li> --%>
                                        <%-- <li class="fields">
                                            <div class="five wide field"><label><spring:message code="common.label.location" /><!-- 소재지 --></label></div>
                                            <div class="eleven wide field">
                                            	<c:if test="${not empty orgInfoVO.orgPost}">
                                            		(<c:out value="${orgInfoVO.orgPost}" />)
                                            	</c:if>
                                            	<c:out value="${orgInfoVO.orgAddr}" />
                                            </div>
                                        </li>
                                        <li class="fields">
                                            <div class="five wide field"><label><spring:message code="common.label.org.support.team" /><!-- 고객지원팀 --></label></div>
                                            <div class="eleven wide field"><c:out value="${orgInfoVO.rprstPhoneNo}" /></div>
                                        </li>
                                        <li class="fields">
                                            <div class="five wide field"><label><spring:message code="common.fax" /><!-- 팩스 --></label></div>
                                            <div class="eleven wide field"><c:out value="${orgInfoVO.rprstFaxNo}" /></div>
                                        </li>
                                        <li class="fields">
                                            <div class="five wide field"><label><spring:message code="common.label.biz.no" /><!-- 사업자등록번호 --></label></div>
                                            <div class="eleven wide field"><c:out value="${orgInfoVO.orgBizNo}" /></div>
                                        </li> --%>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- //카드 -->
					
					<div class="option-content gap4">
	   					<h3 class="sec_head"><spring:message code="common.label.adm.info" /><!-- 전체운영자 정보 --></h3>
	   					<div class="mla">
	   					</div>
	   				</div>
					<table class="tBasic" data-sorting="true" data-paging="false" data-empty="<spring:message code='common.content.not_found' />" id="admTable">
						<thead class="sticky top0">
							<tr>
								<th scope="col">NO</th>
					    		<th scope="col"><spring:message code="common.id" /><!-- 아이디 --></th>
					    		<th scope="col"><spring:message code="user.title.userinfo.manage.usernm" /><!-- 이름 --></th>
					    		<th scope="col"><spring:message code="user.title.userinfo.email" /><!-- 이메일 --></th>
								<th scope="col"><spring:message code="common.label.contact.info" /><!-- 연락처 --></th>
								<th scope="col"><spring:message code="user.title.userinfo.mobileno" /><!-- 휴대폰번호 --></th>
							</tr>
						</thead>
						<tbody id="admList">
						<c:forEach var="row" items="${listOrgAdmUser}" varStatus="status">
							<tr>
								<td class="tr"><c:out value="${status.index + 1}" /></td>
								<td class=""><c:out value="${row.userId}" /></td>
								<td class=""><c:out value="${row.userNm}" /></td>
								<td class=""><c:out value="${row.email}" /></td>
								<td class="tc"><c:out value="${StringUtil.getPhoneNumber(row.ofceTelno)}" /></td>
								<td class="tc"><c:out value="${StringUtil.getPhoneNumber(row.mobileNo)}" /></td>
							</tr>
						</c:forEach>
						</tbody>
					</table>
					<div class="none tc pt10" id="notFoundTr" style="display: none;">
                        <span><spring:message code='common.content.not_found' /></span>
                        <div class="ui divider"></div>
                    </div>
                </div>
                <!-- //ui form -->
            </div>
            <!-- //본문 content 부분 -->
        </div>
    	<!-- footer 영역 부분 -->
    	<%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
    </div>
</body>
</html>