<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ include file="/WEB-INF/jsp/common/admin/admin_common_no_jquery.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
	$(document).ready(function() {
		$('.select-list.radiobox td.refresh').bind('click', function() {
		    let upCd = $(this).data("codeUpcdCd");
		    let upCdnm = $(this).data("codeUpcdNm");
		    // 확실히 row선택이 바뀌면 실행
		    if(upCd == $("input[name='upCd']:checked").val()) {
		    	// 현재 선택된 row의 코드값 저장
		    	$("#currentUpCd").val(upCd);
		    	$("#currentUpCdnm").val(upCdnm);
		    	// 코드값 조회 실행		    	
		    	cmmnCdListPaging(1);
		    }
        });
		
		// 테이블 2개사용할떄 위 쪽 테이블 '등록된 내용이 없습니다.' 안나와서 처리
        if($("#cmmnCdUpCdListCount").val() == 0) {
            $("#cmmnCdUpCdListBody").empty();
            setTimeout(function() {
                $("#cmmnCdUpCdListBody").html('<tr class="footable-empty"><td colspan="5">' + '<spring:message code="common.nodata.msg"/>' + '</td></tr>');
            }, 200);
        }
	});
</script>
<input type="hidden" id="currentUpCd" value="" />
<input type="hidden" id="currentUpCdnm" value="" />
<input type="hidden" value="${pageInfo.totalRecordCount}" id="cmmnCdUpCdListCount" />
<table class="table select-list radiobox" data-sorting="false" data-paging="false">
    <thead>
        <tr>
            <th scope="col" data-sortable="false" class="menuType">
                <div class="ui-mark">
                    <i class="ion-android-done"></i>
                </div>
            </th>
            <th scope="col" data-type="number" class="num"><spring:message code="common.number.no"/></th><!-- NO. -->
            <th scope="col"><spring:message code="main.code.ctgr.cd"/></th><!-- 카테고리 코드 -->
            <th scope="col"><spring:message code="main.code.ctgr.nm"/></th><!-- 카테고리명 -->
            <th scope="col" data-sortable="false" data-breakpoints="xs"><spring:message code="common.mgr"/></th><!-- 관리 -->
        </tr>
    </thead>
    <tbody id="cmmnCdUpCdListBody">
        <c:forEach var="row" items="${cmmnCdUpCdList}" varStatus="status">
            <tr>
             <td class="refresh" data-code-upcd-cd="${row.cd}" data-code-upcd-nm="${row.cdnm}">
                <div class="ui-mark">
                    <input type="radio" name="upCd" value="${row.cd}"  title="${row.cdnm}" />
                    <label><i class="ion-android-done"></i></label>
                </div>
             </td>
             <td>${pageInfo.rowNum(status.index)}</td>
             <td>${row.cd}</td>
             <td>${row.cdnm}</td>
             <td>
                 <div class="ui basic small buttons">
                     <a href="javascript:editUpCdForm('${row.cmmnCdId}', ${pageInfo.currentPageNo})" class="ui button"><spring:message code="button.edit"/></a><!-- 수정 -->
                     <a href="javascript:removeUpCdForm('${row.cmmnCdId}', '${row.cd}', '${row.cdnm}')" class="ui button"><spring:message code="button.delete"/></a><!-- 삭제 -->
                 </div>
             </td>
         </tr>
        </c:forEach>
    </tbody>
</table>
<tagutil:paging pageInfo="${pageInfo}" funcName="upCdListPaging" /> 
