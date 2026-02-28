<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
$(function(){
	// 최초 조회
	onSearch(1);

	// 엔터키
	$("#searchValue").on("keyup", function(e) {
		if(e.keyCode == 13) {
			onSearch(1);
		}
	});

	$("[name=crsTypeCd]").on("change", function(){
		onSearch(1);
	});
});

//리스트 조회
function onSearch(page) {
	var url  = "/crs/crsMgr/selectCrsList.do";
	var crsTypeCd = "";
	var listScale = $("#listScale option:selected").val();
	var searchValue = $('#searchValue').val();

	if($("[name=crsTypeCd]:checked").length == 0){
		alert("과정유형코드를 선택하세요.");
		return;
	}

	$("[name=crsTypeCd]:checked").each(function(i, o){
		crsTypeCd += $(this).val() + ",";
	})

	crsTypeCd = crsTypeCd.substring(0, crsTypeCd.length-1);

	var param = {
		   pageIndex : page
		 , crsTypeCd:crsTypeCd
		 , listScale:listScale
		 , searchValue:searchValue
	};

	ajaxCall(url, param, function(data) {
		var html = "";
		if(data.returnList.length > 0){


			$.each(data.returnList, function(i, o){
				var useYn = o.useYn == 'Y' ? "checked" : "";

				html += "<tr>";
					html += "<td>" + o.lineNo + "</td>";
					html += "<td>" + o.crsTypeNm + "</td>";
					html += "<td>" + o.crsOperTypeNm + "</td>";
					html += "<td>" + o.crsNm + "</td>";
					html += "<td>" + o.crsCd + "</td>";
					html += "<td>";
					html += "	<div class='ui toggle checkbox'>";
					html += "	    <input type='checkbox' name='useYn' value='" + o.crsCd + "' " + useYn + ">";
					html += "	</div>";
					html += "</td>";
					html += "<td>";
					html += "	<div class='manage_buttons'>";
					html += "		<a href=\"javascript:edit('" + o.crsCd + "', '" + o.crsCtgrCd + "')\" class='ui blue button'>수정</a>";
					html += "		<a href=\"javascript:deleteCrsConfirm('" + o.crsCd + "', '" + o.creCrsCnt + "')\" class='ui blue button'>삭제</a>";
					html += "	</div>";
					html += "</td>";
				html += "</tr>";
			});

			$("#tbodyId").empty().html(html);

			$(".table").footable();
			$('.ui.checkbox').checkbox();

			$('input:checkbox[name="useYn"]').change(function(){
    			updateUseYn($(this).val(), $(this).is(":checked"));
    		});

			var params = {
    				totalCount : data.pageInfo.totalRecordCount,
    				listScale : data.pageInfo.recordCountPerPage,
    				currentPageNo : data.pageInfo.currentPageNo,
    				eventName : "onSearch"
    			};

    		gfn_renderPaging(params);
		} else {
			html += "<tr>";
			html += "<td colspan='7'>조회된 데이터가 없습니다.</td>";
			html += "</tr>";
		}
	}, function(xhr, status, error) {
		alert("에러가 발생했습니다!");
	});
}

//사용여부
function updateUseYn(crsCd, useYn){
	var data = {
			crsCd : crsCd
			,useYn : useYn == true ? 'Y' : 'N'
	 	};

	ajaxCall("/crs/crsMgr/updateUseYn.do", data, function(data){
		if(data.result > 0){
			alert(data.message);
		}
	}, function(){});
}

//엑셀다운로드
function selectCrsListExcelDown() {
	var excelGrid = {
		colModel:[
		    {label:'No.',   name:'lineNo',     	align:'center', width:'3000'},
		    {label:"과목분류",	name:'crsTypeNm', 		align:'center', width:'7000'},
		    {label:"구분",  name:'crsOperTypeNm',  	align:'center',	width:'7000'},
		    {label:"과목명",	name:'crsNm',   	align:'center',	width:'10000'},
		    {label:"과목 코드",   	name:'crsCd',		align:'center',	width:'7000'},
		    {label:"사용 여부",	name:'useYn',	align:'center',	width:'5000'}
		]
	};

	var crsTypeCd = "";

	$("[name=crsTypeCd]:checked").each(function(i, o){
		crsTypeCd += $(this).val() + ",";
	})

	crsTypeCd = crsTypeCd.substring(0, crsTypeCd.length-1);

    $("form[name=excelForm]").remove();
    var excelForm = $('<form name="excelForm" method="post" ></form>');
    excelForm.attr("action", "/crs/crsMgr/selectCrsListExcelDown.do");
    excelForm.append($('<input/>', {type: 'hidden', name: 'searchValue', 	value: $("#searchValue").val()}));
    excelForm.append($('<input/>', {type: 'hidden', name: 'crsTypeCd', 	value: crsTypeCd}));
    excelForm.append($('<input/>', {type: 'hidden', name: 'excelGrid', 	value:JSON.stringify(excelGrid)}));
    excelForm.appendTo('body');
    excelForm.submit();
}

/**
 * 과정 관리 폼
 */
function edit(crsCd, crsCtgrCd) {
	$("#crsListForm").attr("action","/crs/crsMgr/crsWrites.do");
   	$("#crsCd").val(crsCd);
   	$("#crsCtgrCd").val(crsCtgrCd);
   	$("#crsListForm").submit();
}


/* 과목 삭제 Confirm */
function deleteCrsConfirm(crsCd, creCrsCnt) {
	//하위 데이터 체크
	if(creCrsCnt > 0) {
		alert("개설된 과정이 있습니다. 과목을 삭제 할 수 없습니다.");
		return;
	}else{
		if(confirm("과목을 삭제하려고 합니다. 삭제 하시겠습니까?")){
			deleteCrs(crsCd);
		}

		return;
	}
}

/**
 * 과정  삭제
 */
function deleteCrs(crsCd){
	ajaxCall("/crs/crsMgr/deleteCrs.do", {crsCd : crsCd}, function(data){
		if(data.result > 0){
			onSearch(1);
		}else{
			alert("과목 삭제 실패하였습니다.");
			return;
		}
	}, function(){
        // 요청에 대해 정상적인 응답을 받지 못하였습니다. 관리자에게 문의 하십시오.
        alert('<spring:message code="errors.json" />');
	});
}


</script>

<body>
	<form class="ui form" id="crsListForm" name="crsListForm" method="POST" action="">
		<input type="hidden" id="crsCd" name="crsCd" >
		<input type="hidden" id="crsCtgrCd" name="crsCtgrCd">
	</form>
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
				<div class="ui form">
					<div id="info-item-box">
	                    <h2 class="page-title">학습활동 : 학기/과목 > 과목관리</h2>
	                    <div class="button-area">
	                      	<a href="javascript:selectCrsListExcelDown();" class="ui basic button">엑셀다운로드</a>
                            <a href="/crs/crsMgr/crsWrites.do" class="ui gray button">과목등록</a>
	                    </div>
	                </div>
	                <div class="ui segment bcLgrey9">
	                    <div class="fields">
	                    	<c:forEach items="${orgList}" var="item" varStatus="i">
	                    		<div class="field">
	                             <div class="ui checkbox">
	                             	<c:choose>
	                              	<c:when test="${i.first}">
	                              		<input type="checkbox" id="chk${item.codeCd}" name="crsTypeCd" checked="checked" value="${item.codeCd}">
	                              	</c:when>
	                              	<c:otherwise>
	                              		<input type="checkbox" id="chk${item.codeCd}" name="crsTypeCd" value="${item.codeCd}">
	                              	</c:otherwise>
	                             	</c:choose>
	                                 <label class="toggle_btn" for="chk${item.codeCd}">${item.codeNm}</label>
	                             </div>
	                         </div>
	                    	</c:forEach>
	                    </div>
                	</div>

			  		<div class="option-content mb10">
			  			
			            <div class="ui action input search-box mr5">
			                <input type="text" id="searchValue" placeholder="과목명 입력">
			                <button class="ui icon button" onclick="onSearch(1);"><i class="search icon"></i></button>
			            </div>
			
						<select class="ui dropdown mr5 selection" id="listScale" onchange="onSearch(this.value);">
			            	<option value="10">10</option>
			                <option value="20">20</option>
			                <option value="50">50</option>
			                <option value="100">100</option>
			                <option value="0">전체</option>
			            </select>
		            </div>

              		<table class="table" data-sorting="true" data-paging="false" data-empty="등록된 내용이 없습니다.">
						<thead>
							<tr>
								<th scope="col" class="num tc">NO</th>
					    		<th scope="col">과목분류</th>
					    		<th scope="col">구분</th>
					    		<th scope="col">과목명</th>
					    		<th scope="col">과목 코드</th>
					    		<th scope="col">사용 여부</th>
								<th scope="col">관리</th>
							</tr>
						</thead>
						<tbody id="tbodyId">
						</tbody>
					</table>
					<div id="paging" class="paging"></div>
	            </div>
            </div>
        </div>
        <!-- //본문 content 부분 -->
    </div>
    <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
</body>
</html>

