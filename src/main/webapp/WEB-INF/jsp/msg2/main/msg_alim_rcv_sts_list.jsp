<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!DOCTYPE html>
<%-- <%@ include file="/WEB-INF/jsp/common/admin/admin_common_no_jquery.jsp" %> --%>
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
	$(document).ready(function() {
		setTimeout(function() {
			$('.ui .toggle.checkbox').checkbox({
	            onChecked : function() {
	                if(this.name == "useyn") {
	                	fn_useyn($(this).attr("id"), "Y");
	                }
	            },
	            onUnchecked : function() {
	                if(this.name == "useyn") {
	                	fn_useyn($(this).attr("id"), "N");
	                }
	            }
	        });	
		}, 500);
		
		// 테이블 2개 사용할떄 '등록된 내용이 없습니다.' 제대로 안나와서 처리
		/* if($("#cmmnCdListCount").val() == 0) {
            $("#cmmnCdListBody").empty();
            setTimeout(function() {
            	$("#cmmnCdListBody").html('<tr class="footable-empty"><td colspan="8">' + '<spring:message code="common.nodata.msg"/>' + '</td></tr>');
			}, 0);
        } */
	});
	
	// 사용여부가 페이지 사용여부야?...흠?
	// 페이지 사용여부 설정 
    function fn_useyn(id, value) {
        var splitVal = id.split('|');
        var cmmnCdId = splitVal[1];
//         var cd = splitVal[2];
        
        $.ajax({
            url : "/menu/menuMgr/editCode.do",
            type : "post",
            data: {
            	cmmnCdId: cmmnCdId,
//             	cd: cd,
            	useyn: value
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
        	
        		<div id="info-item-box">
		        	<h2 class="page-title flex-item flex-wrap gap4 columngap16">
                    	<spring:message code="msg.title.msg.alimRcvSts" /><!-- 운영자 관리 -->
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
				<input type="hidden" value="${pageInfo.totalRecordCount}" id="cmmnCdListCount" />
				<table class="table" data-sorting="false" data-paging="false" data-empty="<spring:message code="common.nodata.msg"/>">
				    <thead id="cmmnCdListHead">
				        <tr>
				            <th scope="col" data-type="number" class="num"><spring:message code="common.number.no"/></th><!-- NO. -->
				            <th scope="col"><spring:message code="main.code.ctgr"/></th><!-- 카테고리 -->
				            <th scope="col"><spring:message code="main.code.code"/></th><!-- 코드 -->
				            <th scope="col"><spring:message code="main.code.nm"/></th><!-- 코드명 -->
				            <th scope="col" data-breakpoints="xs sm"><spring:message code="main.code.desc"/></th><!-- 코드설명 -->
				            <th scope="col" data-breakpoints="xs sm"><spring:message code="main.code.odr"/></th><!-- 표시순서 -->
				            <th scope="col" data-sortable="false" data-breakpoints="xs"><spring:message code="common.use.yn"/></th><!-- 사용여부 -->
				            <th scope="col" data-sortable="false" data-breakpoints="xs" style="width: 150px"><spring:message code="common.mgr"/></th><!-- 관리 -->
				        </tr>
				    </thead>
				    <tbody id="cmmnCdListBody">
				        <c:forEach var="row" items="${cmmnCdList}" varStatus="status">
				            <tr>
					            <td>${pageInfo.rowNum(status.index)}</td>
					            <td>${row.upCdnm}</td>
					            <td>${row.cd}</td>
					            <td>${row.cdnm}</td>
					            <td>${row.cdExpln}</td>
					            <td>${row.cdSeq}</td>
					            <td>
					                <div class="ui toggle checkbox">
					                    <input type="checkbox" name="useyn" id="useyn|${row.cmmnCdId}" <c:if test="${row.useyn eq 'Y'}">checked</c:if>  />
					                </div>
					            </td>
					            <td>
					                <div class="ui basic small buttons">
					                    <a href="javascript:editCodeForm('${row.cmmnCdId}', '${row.cd}', ${pageInfo.currentPageNo})" class="ui button"><spring:message code="button.edit"/></a><!-- 수정 -->
					                    <a href="javascript:removeCodeForm('${row.cmmnCdId}', '${row.cd}', '${row.cdnm}')" class="ui button"><spring:message code="button.delete"/></a><!-- 삭제 -->
					                </div>
					            </td>
					        </tr>
				        </c:forEach>
				    </tbody>
				</table>
	<%-- <tagutil:paging pageInfo="${pageInfo}" funcName="cmmnCdListPaging" /> --%> <!-- 페이징처리 임시 주석 -->
			</div>
		</div>
	</div>
</body>