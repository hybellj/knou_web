<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
<script type="text/javascript">
	$(document).ready(function() {
		listAbsent();
	});
	
	// 결시 기준 리스트
	function listAbsent() {
		var url  = "/exam/examMgr/examAbsentRatioList.do";
		var data = {
			"absentGbn" : $("#absentGbn").val(),
			"examGbn"   : $("#examGbn").val()
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		var returnList = data.returnList || [];
        		var html = "";
        		
        		if(returnList.length > 0) {
        			returnList.forEach(function(v, i) {
        				var isChecked  = "";
        				var absentDesc = v.absentDesc != null ? v.absentDesc : "";
        				html += "<tr class='listTr'>";
        				html += "	<td class='p_w3 tc'>";
        				html += "		<div class='ui checkbox'>";
        				html += "			<input type='checkbox' name='evalChk' id='evalChk"+v.lineNo+"' data-absentGbn=\""+v.absentGbn+"\" data-examGbn=\""+v.examGbn+"\" data-orgId=\""+v.orgId+"\" data-absentCd='evalChk"+v.lineNo+"' onchange='checkAbsentToggle(this)'>";
        				html += "			<label class='toggle_btn' for='evalChk\""+v.lineNo+"\"'></label>";
        				html += "		</div>";
        				html += "	</td>";
        				html += "	<td class='p_w3 tc'>"+v.lineNo+"</td>";
        				html += "	<td class='p_w10 tc'>"+v.absentGbnNm+"</td>";
        				html += "	<td class='p_w15'>"+v.examGbnNm+"</td>";
        				html += "	<td class='p_w10 tc'>";
        				html += "		<div class='listDiv'>"+v.scorRatio+" %</div>";
        				html += "		<div class='editDiv'><input type='text' class='w80' name='scorRatio' value=\""+v.scorRatio+"\" maxlength='3' onKeyup=\"this.value=this.value.replace(/[^0-9]/g,'');\" /> %</div>";
        				html += "	</td>";
        				html += "	<td class='p_w20'>";
        				html += "		<div class='listDiv'>"+absentDesc+"</div>";
        				html += "		<div class='editDiv'><input type='text' name='absentDesc' value=\""+absentDesc+"\" /></div>";
        				html += "	</td>";
        				html += "	<td class='p_w5 tc'>";
        				html += "		<div class='listDiv'><a href='javascript:editAbsent(\""+(i+1)+"\", \"edit\")' class='ui small basic button'><spring:message code='exam.button.mod' /></a></div>";/* 수정 */
        				html += "		<div class='editDiv'><a href='javascript:editAbsent(\""+(i+1)+"\", \"cancle\")' class='ui small basic button'><spring:message code='exam.button.cancel' /></a></div>";/* 취소 */
        				html += "	</td>";
        				html += "</tr>";
        			});
        		}
        		
        		$("#examAbsentList").empty().html(html);
        		$(".editDiv").css("display", "none");
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
		});
	}
	
	// 결시 기준 추가
	function addAbsent() {
		var length = $(".addInput").length + 1;
		if(length > 1) {
			length = length == $(".addInput").eq(0).attr("id").substring(8) ? length+1 : length;
		}
		var html  = "<tr class='addTr'>";
			html += "	<td class='p_w3 tc'>";
			html += "		<div class='ui checkbox'>";
			html += "			<input type='checkbox' class='addInput' name='evalChk' id='addInput"+length+"' data-absentCd='addInput"+length+"' onchange='checkAbsentToggle(this)'>";
			html += "			<label class='toggle_btn' for='addInput"+length+"'></label>";
			html += "		</div>";
			html += "	</td>";
			html += "	<td class='p_w3 tc'>1</td>";
			html += "	<td class='p_w10 tc'>";
			html += "		<select class='ui dropdown selection' name='absentGbn'>";
			html += "			<option value=''><spring:message code='exam.label.absent.absent.gbn' /></option>";/* 결시 유형 */
			<c:forEach var="item" items="${scoreGbnList}">
			html += "			<option value='${item.codeCd}'>${item.codeNm}</option>";
			</c:forEach>
			html += "		</select>";
			html += "	</td>";
			html += "	<td class='p_w15'>";
			html += "		<select class='ui dropdown wmax' name='examGbn'>";
			html += "			<option value=''><spring:message code='exam.label.absent.exam.gbn' /></option>";/* 결시 시험 */
			<c:forEach var="item" items="${examGbnList}">
			html += "			<option value='${item.codeCd}'>${item.codeNm}</option>";
			</c:forEach>
			html += "		</select>";
			html += "	</td>";
			html += "	<td class='p_w10 tc'><input type='text' class='w80' name='scorRatio' maxlength='3' onKeyup=\"this.value=this.value.replace(/[^0-9]/g,'');\" /> %</td>";
			html += "	<td class='p_w20'><input type='text' name='absentDesc' /></td>";
			html += "	<td class='p_w5 tc'></td>";
			html += "</tr>";
		$("#examAbsentList").prepend(html);
		var selectCnt = $("select[name=absentGbn]").length;
		var absentGbns = [];
		var examGbns   = [];
		for(var i = 0; i < selectCnt; i++) {
			absentGbns[i] = $("select[name=absentGbn]").eq(i).val();
			examGbns[i]	  = $("select[name=examGbn]").eq(i).val();
		}
		$("#examAbsentList tr.listTr").not(".editTr").find(".editDiv").css("display", "none");
		$("#examAbsentList tr.editTr").find(".listDiv").css("display", "none");
		$("#examAbsentList .ui.dropdown").dropdown();
		for(var i = 0; i < selectCnt; i++) {
			$("select[name=absentGbn]").eq(i).val(absentGbns[i]).trigger("change");
			$("select[name=examGbn]").eq(i).val(examGbns[i]).trigger("change");
		}
		$("#examAbsentList tr").each(function(i, v) {
			$(v).find("td:nth-child(2)").text(i+1);
		});
		var absentCds = $("#absentCds").val().split(",");
		if(absentCds != "") {
			absentCds.forEach(function(v, i) {
				$("#"+v).prop("checked", true);
			});
		}
	}
	
	// 결시 기준 수정
	function editAbsent(idx, type) {
		idx = parseInt(idx) + $(".addTr").length;
		if(type == "edit") {
			$("#examAbsentList tr.listTr:nth-child("+idx+")").addClass("editTr");
			$("#examAbsentList tr.listTr:nth-child("+idx+") .listDiv").css("display", "none");
			$("#examAbsentList tr.listTr:nth-child("+idx+") .editDiv").css("display", "block");
		} else if(type == "cancle") {
			$("#examAbsentList tr.listTr:nth-child("+idx+")").removeClass("editTr");
			$("#examAbsentList tr.listTr:nth-child("+idx+") .listDiv").css("display", "block");
			$("#examAbsentList tr.listTr:nth-child("+idx+") .editDiv").css("display", "none");
		}
	}
	
	// 결시 기준 삭제
	function delAbsent() {
		var absentCds = $("#absentCds").val().split(",");
		if(absentCds != "") {
			absentCds.forEach(function(v, i) {
				if(!v.includes("addInput")) {
					var url  = "/exam/examMgr/delExamAbsentRatio.do";
					var data = {
						"orgId"		: $("#"+v).attr("data-orgId"),
						"absentGbn" : $("#"+v).attr("data-absentGbn"),
						"examGbn"   : $("#"+v).attr("data-examGbn")
					};
					
					ajaxCall(url, data, function(data) {
						if (data.result > 0) {
			            } else {
			             	alert(data.message);
			            }
					}, function(xhr, status, error) {
						alert("<spring:message code='exam.error.delete' />");/* 삭제 중 에러가 발생하였습니다. */
					});
				}
				$("#"+v).parents("tr").remove();
			});
		}
		$("#examAbsentList tr").each(function(i, v) {
			$(v).find("td:nth-child(2)").text(i+1);
		});
		$("#absentCds").val("");
	}
	
	// 결시 기준 저장
	function saveAbsent() {
		if(!duplicationCheck()) {
			return false;
		}
		var message = "";
		var isChecked = true;
		$("#examAbsentList tr").each(function(i, v) {
			if($(v).hasClass("editTr") || $(v).hasClass("addTr")) {
				var absentGbn  = $(v).hasClass("addTr") ? $(v).find("select[name=absentGbn]").val() : $(v).find("input[name=evalChk]").attr("data-absentGbn");
				var examGbn	   = $(v).hasClass("addTr") ? $(v).find("select[name=examGbn]").val() : $(v).find("input[name=evalChk]").attr("data-examGbn");
				var scorRatio  = $(v).find("input[name=scorRatio]").val();
				var absentDesc = $(v).find("input[name=absentDesc]").val();
				
				if(absentGbn == "") {
					message = "<spring:message code='exam.alert.select.absent.gbn' />";/* 결시유형구분을 선택하세요. */
					isChecked = false;
					return false;
				}
				if(examGbn == "") {
					message = "<spring:message code='exam.alert.select.exam.gbn' />";/* 결시시험구분을 선택하세요. */
					isChecked = false;
					return false;
				}
				if(scorRatio == "") {
					message = "<spring:message code='exam.alert.input.scor.ratio' />";/* 결시점수비율을 입력하세요. */
					isChecked = false;
					return false;
				}
				
				$("#addAbsentRatioForm").append("<input type='hidden' name='absentGbnList' 	value='"+ absentGbn +"' />");
				$("#addAbsentRatioForm").append("<input type='hidden' name='examGbnList' 	value='"+ examGbn +"' />");
				$("#addAbsentRatioForm").append("<input type='hidden' name='scorRatioList' 	value='"+ scorRatio +"' />");
				$("#addAbsentRatioForm").append("<input type='hidden' name='absentDescList' value='"+ absentDesc +"' />");
			}
		});
		
		if(isChecked) {
			showLoading();
			var url  = "/exam/examMgr/addExamAbsentRatio.do";
			
			$.ajax({
	            url 	 : url,
	            async	 : false,
	            type 	 : "POST",
	            dataType : "json",
	            data     : $("#addAbsentRatioForm").serialize(),
	        }).done(function(data) {
	        	hideLoading();
	        	if (data.result > 0) {
	        		listAbsent();
	            } else {
	             	alert(data.message);
	            }
	        }).fail(function() {
	        	hideLoading();
	        	alert("<spring:message code='exam.error.insert' />");/* 저장 중 에러가 발생하였습니다. */
	        });
		} else {
			alert(message);
			return false;
		}
	}
	
	// 중복 값 체크
	function duplicationCheck() {
		var dupChk = true;
		$("#examAbsentList tr").each(function(i, v) {
			if($(v).hasClass("addTr")) {
				var absentGbn = $(v).find("select[name=absentGbn]").val();
				var examGbn   = $(v).find("select[name=examGbn]").val();
				var orgId	  = "${orgId}";
				$("#examAbsentList tr").each(function(ii, vv) {
					if(i != ii) {
						var chkAbsentGbn = $(vv).hasClass("addTr") ? $(vv).find("select[name=absentGbn]").val() : $(vv).find("input[name=evalChk]").attr("data-absentGbn");
						var chkExamGbn   = $(vv).hasClass("addTr") ? $(vv).find("select[name=examGbn]").val() : $(vv).find("input[name=evalChk]").attr("data-examGbn");
						var chkOrgId     = $(vv).hasClass("addTr") ? "${orgId}" : $(vv).find("input[name=evalChk]").attr("data-orgId");
						if(chkAbsentGbn == absentGbn && chkExamGbn == examGbn && chkOrgId == orgId) {
							alert("<spring:message code='exam.error.absent.dup.row' arguments='"+(i+1)+","+(ii+1)+"' />");/* {0}행과 {1}행이 중복되었습니다. */
							dupChk = false;
							return false;
						}
					}
				});
				if(!dupChk) return false;
			}
		});
		return dupChk;
	}
	
	// 엑셀 다운로드
	function excelDown() {
		var excelGrid = {
		    colModel:[
		        {label:"<spring:message code='main.common.number.no' />", name:'lineNo', align:'center', width:'1000'},/* NO */
		        {label:"<spring:message code='exam.label.absent.exam.absent.gbn' />", name:'absentGbnNm', align:'center', width:'5000'},/* 결시유형구분 */
		        {label:"<spring:message code='exam.label.absent.exam.exam.gbn' />", name:'examGbnNm', align:'center', width:'10000'},/* 결시시험구분 */
		        {label:"<spring:message code='exam.label.absent.exam.scor.ratio' />", name:'scorRatio', align:'center', width:'3000'},/* 결시점수비율 */
		        {label:"<spring:message code='exam.label.absent.exam.absent.desc' />", name:'absentDesc', align:'left', width:'15000'},/* 결시반영내용 */
		    ]
		};
		
		var kvArr = [];
		kvArr.push({'key' : 'absentGbn', 'val' : $("#absentGbn").val()});
		kvArr.push({'key' : 'examGbn', 	 'val' : $("#examGbn").val()});
		kvArr.push({'key' : 'excelGrid', 'val' : JSON.stringify(excelGrid)});
		
		submitForm("/exam/examMgr/examStareExcelDown.do", "", "", kvArr);
	}
	
	// 전체 선택 / 해제
    function checkAllAbsentToggle(obj) {
        $("input:checkbox[name=evalChk]").prop("checked", $(obj).is(":checked"));

        $('input:checkbox[name=evalChk]').each(function (idx) {
            if ($(obj).is(":checked")) {
                addSelectedAbsentCds($(this).attr("data-absentCd"));
            } else {
                removeSelectedAbsentCds($(this).attr("data-absentCd"));
            }
        });
    }

    // 한건 선택 / 해제
    function checkAbsentToggle(obj) {
        if ($(obj).is(":checked")) {
            addSelectedAbsentCds($(obj).attr("data-absentCd"));
        } else {
            removeSelectedAbsentCds($(obj).attr("data-absentCd"));
        }
        var totChkCnt = $("input:checkbox[name=evalChk]").length;
        var chkCnt = $("input:checkbox[name=evalChk]:checked").length;
        if(totChkCnt == chkCnt) {
        	$("input:checkbox[name=allEvalChk]").prop("checked", true);
        } else {
        	$("input:checkbox[name=allEvalChk]").prop("checked", false);
        }
    }

    // 선택된 학습자 번호 추가
    function addSelectedAbsentCds(absentCd) {
        var selectedAbsentCds = $("#absentCds").val();
        if (selectedAbsentCds.indexOf(absentCd) == -1) {
            if (selectedAbsentCds.length > 0) {
            	selectedAbsentCds += ',';
            }
            selectedAbsentCds += absentCd;
            $("#absentCds").val(selectedAbsentCds);
        }
    }

    // 선택된 학습자 번호 제거
    function removeSelectedAbsentCds(absentCd) {
        var selectedAbsentCds = $("#absentCds").val();
        if (selectedAbsentCds.indexOf(absentCd) > -1) {
        	selectedAbsentCds = selectedAbsentCds.replace(absentCd, "");
        	selectedAbsentCds = selectedAbsentCds.replace(",,", ",");
        	selectedAbsentCds = selectedAbsentCds.replace(/^[,]*/g, '');
        	selectedAbsentCds = selectedAbsentCds.replace(/[,]*$/g, '');
            $("#absentCds").val(selectedAbsentCds);
        }
    }
</script>

<body>
    <div id="wrap" class="pusher">
        <!-- class_top 인클루드  -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>

        <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>

		<form id="addAbsentRatioForm" method="post">
		</form>
        <div id="container">
            <!-- 본문 content 부분 -->
            <div class="content">
            	<div id="info-item-box">
                	<h2 class="page-title flex-item">
					    <spring:message code="exam.label.study" /><!-- 수업 -->
					    <div class="ui breadcrumb small">
					        <small class="section"><spring:message code="exam.label.absent.basic.ratio.add" /><!-- 결시원 기준등록 --></small>
					    </div>
					</h2>
				</div>
				<div class="ui divider mt0"></div>
        		<div class="ui form">
       				<div class="option-content gap4">
       					<select class="ui dropdown w200 mr15" id="absentGbn" onchange="listAbsent()">
                    		<option value=""><spring:message code="exam.label.absent.exam.absent.gbn" /><!-- 결시유형구분 --></option>
                    		<option value="ALL"><spring:message code="exam.common.search.all" /><!-- 전체 --></option>
                    		<c:forEach var="item" items="${scoreGbnList }">
                    			<option value="${item.codeCd }">${item.codeNm }</option>
                    		</c:forEach>
                    	</select>
                    	<select class="ui dropdown w300" id="examGbn" onchange="listAbsent()">
                    		<option value=""><spring:message code="exam.label.absent.exam.exam.gbn" /><!-- 결시시험구분 --></option>
                    		<option value="ALL"><spring:message code="exam.common.search.all" /><!-- 전체 --></option>
                    		<c:forEach var="item" items="${examGbnList }">
                    			<option value="${item.codeCd }">${item.codeNm }</option>
                    		</c:forEach>
                    	</select>
       				</div>
       				<div class="option-content mb20">
       					<h3 class="sec_head"><spring:message code="exam.label.absent.score.ratio.list" /><!-- 결시원 성적비율내역 --></h3>
       					<div class="mla">
       						<a href="javascript:addAbsent()" class="ui orange button"><spring:message code="exam.button.add" /><!-- 추가 --></a>
       						<a href="javascript:delAbsent()" class="ui grey button"><spring:message code="exam.button.del" /><!-- 삭제 --></a>
       						<a href="javascript:saveAbsent()" class="ui blue button"><spring:message code="exam.button.save" /><!-- 저장 --></a>
       						<a href="javascript:excelDown()" class="ui green button"><spring:message code="exam.button.excel.down" /><!-- 엑셀 다운로드 --></a>
       					</div>
       				</div>
       				<table class="tBasic" data-empty="<spring:message code='exam.common.empty' />" id="examAbsentListTable"><!-- 등록된 내용이 없습니다. -->
       					<thead>
       						<tr>
       							<th class='p_w3 tc'>
       								<div class="ui checkbox">
										<input type="hidden" id="absentCds" name="absentCds">
						                <input type="checkbox" name="allEvalChk" id="allChk" value="all" onchange="checkAllAbsentToggle(this)">
						                <label class="toggle_btn" for="allChk"></label>
						            </div>
       							</th>
       							<th class='p_w3 tc'><spring:message code="main.common.number.no" /><!-- NO. --></th>
       							<th class='p_w10 tc'><spring:message code="exam.label.absent.exam.absent.gbn" /><!-- 결시유형구분 --></th>
       							<th class='p_w15 tc'><spring:message code="exam.label.absent.exam.exam.gbn" /><!-- 결시시험구분 --></th>
       							<th class='p_w10 tc'><spring:message code="exam.label.absent.exam.scor.ratio" /><!-- 결시점수비율 --></th>
       							<th class='p_w20 tc'><spring:message code="exam.label.absent.exam.absent.desc" /><!-- 결시반영내용 --></th>
       							<th class='p_w5 tc'><spring:message code="exam.label.manage" /><!-- 관리 --></th>
       						</tr>
       					</thead>
       					<tbody id="examAbsentList">
       					</tbody>
       				</table>
        		</div>
			</div>
        </div>
        <!-- //본문 content 부분 -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
    </div>
</body>
</html>