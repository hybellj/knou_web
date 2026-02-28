<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	
	<script type="text/javascript">
		$(document).ready(function() {
			// 엔터키
			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					listPaging(1);
				}
			});
			
			listPaging(1);
		});
		
		//리스트 조회
		function listPaging(pageIndex) {
			var url  = "/org/orgMgr/listPagingOrgManage.do";
		
			var param = {
				   pageIndex 	: pageIndex
				 , listScale	: $("#listScale").val()
				 , searchValue	: $('#searchValue').val()
			};
		
			ajaxCall(url, param, function(data) {
				if (data.result > 0) {
					var returnList = data.returnList || [];
					
					var html = '';
					returnList.forEach(function(v, i) {
						html += '<tr>';
						html += '	<td>' + v.lineNo + '</td>';
						html += '	<td>' + v.orgId + '</td>';
						html += '	<td><a class="fcBlue" href="javascript:orgInfoDetail(\'' + v.orgId + '\')">' + v.orgNm+ '</a></td>';
						html += '   <td>https://lms.knou.ac.kr' + (v.orgId != "ORG0000001" ? "/"+v.domainNm : "") + '</td>';
						//html += '	<td>' + (v.rprstPhoneNo ? formatPhoneNumber(v.rprstPhoneNo) : '-') + '</td>';
						//html += '	<td>' + (v.orgBizNo || '-') + '</td>';
						html += '	<td>' + (v.admCnt || '0') + '</td>';
						html += '	<td>';
						html += '		<div class="manage_buttons">';
						if ("ORG0000001" != v.orgId) {
							html += '			<a href="javascript:moveEdit(\'' + v.orgId + '\')" class="ui blue button">수정</a>';
							html += '			<a href="javascript:deleteOrgInfo(\'' + v.orgId + '\')" class="ui blue button">삭제</a>';
						}
						html += '		</div>';
						html += '	</td>';
						html += '</tr>';
					});
		
					$("#orgList").empty().html(html);
					$("#orgTable").footable();
					
					$("#totalCntText").text(returnList.length);
					
					var params = {
	    				totalCount : data.pageInfo.totalRecordCount,
	    				listScale : data.pageInfo.recordCountPerPage,
	    				currentPageNo : data.pageInfo.currentPageNo,
	    				eventName : "listPaging"
		    		};
		
		    		gfn_renderPaging(params);
				} else {
					alert(data.message);
				}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			});
		}
		
		// 기관정보 상세
		function orgInfoDetail(orgId) {
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "moveForm");
			form.attr("action", "/org/orgMgr/Form/orgManageDetail.do");
			form.append($('<input/>', {type: 'hidden', name: "orgId", value: orgId}));
			form.appendTo("body");
			form.submit();
		}
		
		// 기관정보 등록
		function moveWrite() {
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "moveForm");
			form.attr("action", "/org/orgMgr/Form/orgManageWrite.do");
			form.appendTo("body");
			form.submit();
		}
		
		// 기관정보 수정
		function moveEdit(orgId) {
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "moveForm");
			form.attr("action", "/org/orgMgr/Form/orgManageEdit.do");
			form.append($('<input/>', {type: 'hidden', name: "orgId", value: orgId}));
			form.appendTo("body");
			form.submit();
		}
		
		// 기관 삭제
		function deleteOrgInfo(orgId) {
			if(!confirm('<spring:message code="common.delete.msg" />')) return;
			
			var url = "/org/orgMgr/updateUseN.do";
			var param = {
				orgId : orgId
			};
			
			ajaxCall(url, param, function(data) {
				if(data.result > 0) {
					alert('<spring:message code="success.common.delete" />'); // 정상적으로 삭제되었습니다.
					
					listPaging(1);
				} else {
					alert(data.message);
				}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			});
		}
		
		// 엑셀 다운로드
		function downExcel() {
			var excelGrid = {
		        colModel:[
		     	     {label:'NO', name:'lineNo', align:'right', width:'2500'}
		     	   , {label:'<spring:message code="common.label.org.cd" />', 			name:'orgId', 			align:'center', width:'5000'} // 소속코드
		     	   , {label:'<spring:message code="common.label.org.nm" />', 			name:'orgNm', 			align:'left',  	width:'5000'} // 소속명
		     	   , {label:'<spring:message code="common.label.org.support.no" />', 	name:'rprstPhoneNo', 	align:'center',	width:'5000'} // 고객지원
		           , {label:'<spring:message code="common.label.biz.no" />', 			name:'orgBizNo', 		align:'center',	width:'5000'} // 사업자등록번호
		     	   , {label:'<spring:message code="common.label.adm" />', 				name:'admCnt', 			align:'right',	width:'5000'} // 전체운영자
		       ]
			};
			
			var excelForm = $('<form></form>');
			excelForm.attr("name","excelForm");
			excelForm.attr("action","/org/orgMgr/orgManageExcelDown.do");
			excelForm.append($('<input/>', {type: 'hidden', name: 'searchValue', value:$("#searchValue").val() }));
			excelForm.append($('<input/>', {type: 'hidden', name: 'excelGrid', value:JSON.stringify(excelGrid)}));
			excelForm.appendTo('body');
			excelForm.submit();
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
            <div class="content" >
            	<div id="info-item-box">
                    <h2 class="page-title flex-item">
                    	<spring:message code="common.label.org.lmsopt" /><!-- 소속(테넌시) 관리 -->
                    	<div class="ui breadcrumb small">
					        <small class="section"><spring:message code='common.button.list' /><!-- 목록 --></small>
					    </div>
                   	</h2>
                   	<c:if test="${userType.contains('SUP') or userType.contains('DEV')}">
                    <div class="button-area">
						<a href="javascript:moveWrite()" class="ui orange button"><spring:message code='common.button.create' /><!-- 등록 --></a>
                    </div>
                    </c:if>
                </div>
                <div class="ui divider mt0"></div>
            	<div class="ui form">
            		<div class="ui segment searchArea">
            			<div class="ui action input search-box mr5">
                            <input type="text" id="searchValue" placeholder="<spring:message code='common.button.search' />" />
                            <button class="ui icon button" onclick="listPaging(1)"><i class="search icon"></i></button>
                        </div>
                       	<div class="button-area mt10 tc">
							<a href="javascript:void(0)" class="ui blue button w100" onclick="listPaging(1)"><spring:message code="exam.button.search" /><!-- 검색 --></a>
						</div>
            		</div>
            		<div class="option-content gap4">
	   					<h3 class="sec_head"><spring:message code="common.label.org.lmsopt" /><!-- 소속(테넌시) 관리 --></h3>
	   					<span class="pl10">[ <spring:message code="common.page.total.cnt" /><!-- 총 건수 --> : <label id="totalCntText">0</label> ]</span>
	   					<div class="mla">
	   						<a href="javascript:downExcel();" class="ui green button"><spring:message code="common.button.excel_down" /><!-- 엑셀 다운로드 --></a>
	   						<select class="ui dropdown selection" id="listScale" onchange="listPaging(1)">
		                        <option value="10">10</option>
		                        <option value="20">20</option>
		                        <option value="50">50</option>
		                        <option value="100">100</option>
	                       	</select>
	   					</div>
	   				</div>
                   	<table class="table" data-sorting="true" data-paging="false" data-empty="<spring:message code='common.content.not_found' />" id="orgTable">
						<thead>
							<tr>
								<th scope="col">NO</th>
					    		<th scope="col"><spring:message code="common.label.org.cd" /><!-- 소속코드 --></th>
					    		<th scope="col"><spring:message code="common.label.org.nm" /><!-- 소속명 --></th>
					    		<th scope="col">접속경로</th>
					    		<%-- <th scope="col"><spring:message code="common.label.biz.no" /> --%><!-- 사업자등록번호 --></th>
								<th scope="col"><spring:message code="common.label.adm" /><!-- 전체운영자 --></th>
								<c:if test="${userType.contains('SUP') or userType.contains('DEV')}">
								<th scope="col"><spring:message code="common.mgr" /><!-- 관리 --></th>
								</c:if>
							</tr>
						</thead>
						<tbody id="orgList">
						</tbody>
					</table>
					<div id="paging" class="paging"></div>
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