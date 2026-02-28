<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
$(document).ready(function() {
	$("#searchValue").on("keyup", function(e) {
		if(e.keyCode == 13) {
			getList(1);
		}
	});

	getList();
});

//리스트 가져오기
function getList(page) {
	var url  = "/mut/mutHome/getMut.do";
	var data = {
			"pageIndex"   : page,
			"listScale"   : $("#listScale").val(),
			"searchValue" : $("#searchValue").val(),
			"selectType" : "PAGE"
		};


	ajaxCall(url, data, function(data) {
		if (data.result > 0) {
    		var returnList = data.returnList || [];
    		var html = "";

    		if(returnList.length > 0) {
    			returnList.forEach(function(o, i) {

    				var useYn = o.useYn == 'Y' ? "checked" : "";

    				html += "<tr>";
    				html += "	<td>" + o.lineNo + "</td>";
    				html += "	<td>" + o.evalTitle + "</td>";
    				html += "	<td>" + o.evalCnt + "</td>";
    				html += "	<td>" + o.regDttm + "</td>";
    				html += "	<td>" + o.regNm + "</td>";
    				html += "	<td>";
    				html += "		<div class='ui toggle checkbox'>";
    				html += "   	    <input type='checkbox' name='useToggle' value='" + o.evalCd + "' " + useYn + ">";
    				html += "  		</div>";
    				html += "	</td>";
    				html += "	<td>";
    				html += "		<a href=\"javascript:editMut('" + o.evalCd + "')\" class='ui blue button'>수정</a>";
    				html += "		<a href=\"javascript:deleteMut('" + o.evalCd + "')\" class='ui blue button'>삭제</a>";
    				html += "	</td>";
    				html += "</tr>";

    			});
    		}

    		$("#mutList").empty().html(html);
	    	$(".table").footable();
	    	$('.ui.checkbox').checkbox();

    		$('input:checkbox[name="useToggle"]').change(function(){
    			updateUseYn($(this).val(), $(this).is(":checked"));
    		});

	    	var params = {
					totalCount 	  : data.pageInfo.totalRecordCount,
					listScale 	  : data.pageInfo.recordCountPerPage,
					currentPageNo : data.pageInfo.currentPageNo,
					eventName 	  : "getList"
				};

				gfn_renderPaging(params);
        } else {
         	alert(data.message);
        }
	}, function(xhr, status, error) {
		/* 에러가 발생했습니다! */
		alert('<spring:message code="fail.common.msg" />');
	});
}

//사용여부
function updateUseYn(evalCd, useYn){

	var data = {
		 	"evalCd" : evalCd
			,"useYn" : useYn == true ? 'Y' : 'N'
	 	};

	ajaxCall("/mut/mutHome/edtUseYn.do", data, function(data){
		if(data.result > 0){
			alert(data.message);
		}
	}, function(){});
};

//삭제
function deleteMut(evalCd) {
	/* 삭제 하시겠습니까? */
	if(window.confirm("<spring:message code='seminar.confirm.delete' />")) {
		var url  = "/mut/mutHome/edtDelYn.do";
		var data = {
			"evalCd" : evalCd
			,"delYn" : 'Y'
		};

		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				/* 정상적으로 삭제되었습니다. */
        		alert("<spring:message code='success.common.delete'/>");
        		location.reload(true);
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
            /* 삭제 중 오류가 발생하였습니다. 잠시 후 다시 진행해 주세요. */
            alert("<spring:message code='seminar.error.delete' />");
		});
	}
}

//수정
function editMut(evalCd) {
	var url  = "/mut/mutHome/writeView.do";
	var form = $("<form></form>");
	form.attr("method", "POST");
	form.attr("name", "evalForm");
	form.attr("action", url);

	form.append($('<input/>', {type: 'hidden', name: 'evalCd', value: evalCd}));
	form.appendTo("body");
	form.submit();
}

</script>
<body>
    <div id="wrap" class="pusher">
        <!-- class_top 인클루드  -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>

        <div id="container">
            <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp"%>
            <!-- 본문 content 부분 -->
            <div class="content stu_section">

	            <div class="ui form">
			        <div class="layout2">

                        <div class="row">
                            <div class="col">
                                <div id="info-item-box">
		                            <h2 class="page-title"><spring:message code="asmnt.label.rubric.list" /></h2><!-- 루브릭 목록-->
		                            <div class="button-area">
		                                <a href="/mut/mutHome/writeView.do" class="ui basic button"><spring:message code="asmnt.label.rubric.reg" /></a><!-- 루브릭 등록 -->
		                            </div>
		                        </div>

                                <div class="option-content mb10">
                                    <select class="ui dropdown mr5" id="listScale" >
                                        <option value="10">10</option>
                                    </select>
                                    <select class="ui dropdown mr5" id="termCd" onchange="copyCreCrsList()">
					                	<option value="" hidden><spring:message code="sys.label.select.haksa.year" /></option><!-- 년도선택 -->
					                </select>
					                <select class="ui dropdown mr5" id="termCd" onchange="copyCreCrsList()">
					                	<option value="" hidden><spring:message code="sys.label.select.haksa.term" /></option><!-- 학기선택 -->
					                </select>

                                    <div class="ui action input search-box mr5">
                                        <input type="text" id="searchValue" placeholder="<spring:message code="asmnt.label.search.keyword" />">
                                        <button class="ui icon button" onclick="getList();"><i class="search icon"></i></button>
                                    </div>
                                </div>

					            <table class="table" data-sorting="true" data-paging="false" data-empty="<spring:message code="common.content.not_found" />">
					            	<colgroup>
					            		<col width="7%">
					            		<col width="10%">
					            		<col width="*">
					            		<col width="10%">
					            	</colgroup>
									<thead>
										<tr>
											<th scope="col" class="num tc">NO</th>
											<th scope="col"><spring:message code="asmnt.label.rubric.title" /></th><!-- 루브릭 제목 -->
											<th scope="col"><spring:message code="resh.label.item.cnt" /></th><!-- 문항수 -->
											<th scope="col"><spring:message code="team.table.field.regDttm" /></th><!-- 등록일 -->
											<th scope="col"><spring:message code="common.registrant" /></th><!-- 등록자 -->
											<th scope="col"><spring:message code="common.use.yn" /></th><!-- 사용여부 -->
											<th scope="col"><spring:message code="exam.label.manage" /></th><!-- 관리 -->
										</tr>
									</thead>
									<tbody id="mutList"></tbody>
								</table>
								<div id="paging" class="paging"></div>
                            </div>
                        </div>

			        </div><!-- //layout2 -->
	            </div><!-- //ui form -->
            </div><!-- //content stu_section -->
        </div><!-- //container -->

	    <!-- </div> footer 위에 있는 div 태그 삭제... -->
	    <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>

    </div><!-- //wrap -->

</body>
</html>
