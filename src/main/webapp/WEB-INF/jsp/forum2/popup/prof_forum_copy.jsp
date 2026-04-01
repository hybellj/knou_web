<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
			<jsp:param name="style" value="classroom"/>
			<jsp:param name="module" value="table"/>
		</jsp:include>
    </head>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>

	<script type="text/javascript">
		$(document).ready(function() {
			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					forumListSelect();
				}
			});
		});

		/**
		 * 이전 토론 목록 조회
		 */
    	function forumListSelect() {
    		var url  = "/forum2/forumLect/Form/forumCopyList.do";
    		var data = {
    			"smstrChrtId" : $("#smstrChrtId").val(),
    			"sbjctId"     : ($("#sbjctId").val() || "").replace("ALL", ""),
    			"searchValue" : $("#searchValue").val(),
				"userId"		: "${forum2VO.userId}",
    			"pageIndex"   : 1,
    			"listScale"   : 100
    		};

    		UiComm.showLoading(true);
			$.ajax({
		        url 	   : url,
		        async	   : false,
		        type 	   : "POST",
		        dataType   : "json",
		        data 	   : JSON.stringify(data),
		        contentType: "application/json; charset=UTF-8",
		    }).done(function(data) {
		    	UiComm.showLoading(false);
	        	if (data.result > 0) {
	        		var returnList = data.returnList || [];
	        		var dataList = [];

	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v) {
							var selectBtn = "<a href='javascript:window.parent.copyForum(\"" + v.dscsId + "\")' class='btn basic small'><spring:message code='forum.button.selection'/>​</a>";

	        				dataList.push({
	    						no:          v.lineNo,
	    						sbjctnm:     v.sbjctnm,
	    						dvclasNo:    v.dvclasNo + "<spring:message code='forum.label.decls.name'/>", /* 반 */
	    						dscsUnitTycd: v.dscsUnitTycd,
	    						dscsTtl:     v.dscsTtl,
	    						selectBtn:   selectBtn
	    					});
	        			});
	        		}

	        		forumListTable.clearData();
	        		forumListTable.replaceData(dataList);
	            } else {
	            	UiComm.showMessage(data.message, "error");
	            }
		    }).fail(function() {
		    	UiComm.showLoading(false);
	        	UiComm.showMessage("<spring:message code='forum.common.error' />", "error");/*오류가 발생했습니다!*/
		    });
    	}

		/**
		 * 학기기수 변경 - 과목 목록 세팅
		 */
		function changeSmstrChrt(smstrChrtId) {
			var url  = "/forum2/forumLect/Form/smstrChrtSbjctListAjax.do";
			var data = {
				"smstrChrtId" : smstrChrtId,
				"sbjctId"     : "${forum2VO.sbjctId}"
			};

			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
			    	var returnList = data.returnList || [];
			    	var html = "<option value=''><spring:message code='forum.label.subject.select' /></option>";

			    	if(returnList.length > 0) {
			    		returnList.forEach(function(v) {
						html += "<option value='" + v.sbjctid + "'>" + v.sbjctnm + " " + v.dvclasno + "반</option>";
			    		});
			    	}

			    	$("#sbjctId").empty().append(html);
					$("#sbjctId").val('').trigger("chosen:updated");
				} else {
					alert(data.message);
				}
		   	}, function(xhr, status, error) {
		   		alert("<spring:message code='forum.common.error' />");
		   	});
		}
	</script>

	<body class="modal-page">
        <div id="wrap">
        	<%--<div class="msg-box info">
                <p class="txt"><i class="xi-error" aria-hidden="true"></i><spring:message code='forum.label.select.copy'/><!-- 선택 시 토론 정보가 복사됩니다. --></p>
            </div>--%>
            <div class="board_top">
                <select class="form-select" id="smstrChrtId" onchange="changeSmstrChrt(this.value)">
                    <option value=""><spring:message code="bbs.label.select_term" /></option><!-- 학년도 학기 선택 -->
            		<c:forEach items="${smstrChrtList}" var="row" varStatus="status">
						<option value="<c:out value='${row.smstrchrtid}' />"><c:out value="${row.smstrchrtnm}" /></option>
					</c:forEach>
                </select>
                <select class="form-select" id="sbjctId" onchange="forumListSelect()">
                    <option value=""><spring:message code='forum.label.subject.select'/><!-- 과목 선택 --></option>
                </select>
                <input class="form-control wide" type="text" id="searchValue" placeholder="<spring:message code='forum.button.forumNm.input'/>"><!-- 토론명 입력 -->
                <button type="button" class="btn basic icon search" aria-label="검색" onclick="forumListSelect()"><i class="icon-svg-search"></i></button>
            </div>

            <div id="list"></div>

            <script>
				// 리스트 테이블
				let forumListTable = UiTable("list", {
					lang: "ko",
					height: 400,
					columns: [
						{title:"No",       field:"no",          headerHozAlign:"center", hozAlign:"center", width:40,  minWidth:40},
						{title:"과목명",    field:"sbjctnm",     headerHozAlign:"center", hozAlign:"center", width:0,   minWidth:100},
						{title:"분반",      field:"dvclasNo",    headerHozAlign:"center", hozAlign:"center", width:80,  minWidth:80},
						{title:"토론 구분",  field:"dscsUnitTycd", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100},
						{title:"토론명",     field:"dscsTtl",     headerHozAlign:"center", hozAlign:"left",   width:0,   minWidth:250},
						{title:"선택",      field:"selectBtn",   headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100}
					]
				});
			</script>

			<div class="btns">
                <button class="btn type2" onclick="window.parent.closeDialog();"><spring:message code='forum.button.close'/><!-- 닫기 --></button>
			</div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
