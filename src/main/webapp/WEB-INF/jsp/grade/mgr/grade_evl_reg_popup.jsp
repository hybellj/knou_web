<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
    	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
    	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    	<link rel="stylesheet" type="text/css" href="/webdoc/file-uploader/file-uploader.css" />
    	<script type="text/javascript" src="/webdoc/js/jquery.form.min.js"></script>
	    <script type="text/javascript" src="/webdoc/file-uploader/lang/file-uploader-ko.js"></script>
	    <script type="text/javascript" src="/webdoc/file-uploader/file-uploader.js"></script>
	    <script type="text/javascript" src="/webdoc/js/iframe.js"></script>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    </head>
    <script type="text/javascript">
    $(document).ready(function() {
    	onPopSearch();
    });

    function onPopSearch(){
    	ajaxCall("/grade/gradeMgr/selectEvlReg.do", {crsCreCd : $("#crsCreCd").val()}, function(data) {
    		var html = "";
    		var scoreRatioSum = 0;

    		$.each(data.returnList, function(i, o){
				scoreRatioSum += parseInt(o.scoreRatio);
				html += "<tr>";
    			html += "<td>" + o.scoreItemOrder + "</td>";
        		html += "<td>" + o.scoreItemNm+ "</td>";
        		html += "<td>";
        		html += "<input type='text' id='scoreList" + i + "' name='scoreList[" + i + "].scoreRatio' value='" + o.scoreRatio + "' onkeyup='isChkNumber(this)'/>";
        		html += "<input type='hidden' name='scoreList[" + i + "].scoreItemId' value='" + (gfn_isNull(o.scoreItemId) ? '' : o.scoreItemId) + "' />";
        		html += "<input type='hidden' name='scoreList[" + i + "].scoreItemOrder' value='" + (gfn_isNull(o.scoreItemOrder) ? '' : o.scoreItemOrder) + "' />";
        		html += "<input type='hidden' name='scoreList[" + i + "].crsCreCd' value='" + (gfn_isNull(o.crsCreCd) ? $("#crsCreCd").val() : o.crsCreCd) + "' />";
	    		html += "</td>";
    			html += "</tr>";
			});

    		if(data.result == "1"){
    			$("#gubun").val("E");
    		} else if(data.result == "0"){
    			$("#gubun").val("A");
    		}

    		$("#tbodyPopId").empty().html(html);
    		$("#popTable").footable();

    		$("[name^=scoreList]").on("focus", function(){
    			onInputFocus(this);
    		});

    		$("[name^=scoreList]").on("blur", function(){
    			onScoreCal(this);
    		});

    		$("#perSum").empty().html(scoreRatioSum);
    	}, function(xhr, status, error) {
    		/* 에러가 발생했습니다! */
    		alert("<spring:message code='fail.common.msg' />");
    	});
    }

    // 저장
    function saveConfirm() {
    	if($("#perSum").text() == 100){
    		// 저장하시겠습니까?
    		if(confirm("<spring:message code='common.save.msg'/>")) {
        		ajaxCall("/grade/gradeMgr/multiEvlPopReg.do", $("#listForm").serialize(), function(data) {
        			onPopSearch();
        			/* 저장되었습니다. */
        			alert("<spring:message code='forum.alert.success'/>");
        		}, function(xhr, status, error) {
        			/* 에러가 발생했습니다! */
        			alert("<spring:message code='fail.common.msg' />");
        		});
        	}
    	} else {
    			/* 비율합계는 100이여야 합니다. */
    		alert('<spring:message code="msg.common.ratio.sum" />');
    	}
    }

    var old_val = "";
    function onInputFocus( obj ){
    	old_val = $(obj).val();
    }

    function onScoreCal( obj ) {
    	var calSum = calTableSum();

    	if(calTableSum() > 100) {
    		/* "비율합계는 100을 넘을 수 없습니다. */
    		alert('<spring:message code="msg.common.ratio.sum.not.over" />');
    		$("#" + obj.id).val(old_val);
    		
    	} else if($("#" + obj.id).val() == null || $("#" + obj.id).val() == "") {
    		/* "빈값은 입력할 수 없습니다. */
    		alert('<spring:message code="msg.common.ratio.blank.not.over" />');
    		$("#" + obj.id).val(old_val);
    		
    	} else {
    		$("#perSum").empty().html(calSum);
    	}
    }

    function calTableSum(){
    	var calSum = 0 ;
    	$("#tbodyPopId > tr").each(function(){
    		calSum += parseInt($(this).eq(0).find("td > input").eq(0).val());
    	});
    	return calSum;
    }

    function closeModal(){
    	window.parent.closeModal();
    	window.parent.onSearchDtl();
    }
    </script>

    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<body class="modal-page">
        <div id="wrap">
            <div class="ui form">
            	<div class="ui segment">
            		<form:form id="listForm" commandName="GradeVO">
            		<input type="hidden" id="crsCreCd" name="crsCreCd" value="${vo.crsCreCd}"/>
            		<input type="hidden" id="gubun" name="gubun" />
            		<table id="popTable" class="table" data-sorting="false" data-paging="false" data-empty="<spring:message code="common.content.not_found" />">
                   		<colgroup>
	            		<col width="10%">
	            		<col width="50%">
	            		<col width="40%">
	            		</colgroup>
						<thead>
							<tr>
								<th scope="col"><spring:message code="main.common.number.no"/></th>	<!-- NO. -->
								<th scope="col"><spring:message code="crs.label.eval.criteria" /></th><!-- 평가기준 -->
					    		<th scope="col"><spring:message code="crs.evaluation.rate" /></th><!-- 평가비율 -->
							</tr>
						</thead>
						<tbody id="tbodyPopId">
						</tbody>
					</table>
					</form:form>
					<div class="mt10">
			            <div class="fields">
			                <div class="four wide field">
			                    <div class="ui right labeled input">
			                        <div class="ui basic label"><spring:message code="crs.evaluation.sum.ratio" />: <span id="perSum">0</span>%</div><!-- 비율합계 -->
			                    </div>
			                </div>
		 	           </div>
					</div>
            	</div>
            </div>

            <div class="bottom-content">
                <button type="button" class="ui blue button" onclick="javascript:saveConfirm();"><spring:message code="team.common.save"/></button><!-- 저장 -->
                <button type="button" class="ui black cancel button" onclick="closeModal();"><spring:message code="team.common.close"/></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
