<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<link rel="stylesheet" type="text/css" href="/webdoc/css/xeicon.css" />
<link rel="stylesheet" type="text/css" href="/webdoc/css/xeicon.min.css" />

<script type="text/javascript">
	$(function(){
		$("#searchValue").on("keyup", function(e) {
			if(e.keyCode == 13) {
				crsCreList(1);
			}
		});
	});
	
	//과정유형 선택
	function selectContentCrsType(obj) {
		if($(obj).hasClass("basic")){
			$(obj).removeClass("basic").addClass("active");
		} else {
			$(obj).removeClass("active").addClass("basic");
		}
	}
	
	// 과목 목록
	function crsCreList(pageIndex) {
		var crsTypeCd = "";
		$(".crsTypeBtn").each(function(i, v) {
			if($(v).hasClass("active")) {
				if(crsTypeCd == "") {
					crsTypeCd = $(v).attr("data-crs-type-cd");
				} else {
					crsTypeCd += "," + $(v).attr("data-crs-type-cd");
				}
			}
		});
		var searchKey = $("#excCreCrs").is(":checked") ? "Y" : "N";
		
		var url  = "/grade/gradeMgr/gradeInputExcCrsCreList.do";
		var data = {
			"creYear" 	  : $("#creYear").val(),
			"creTerm" 	  : $("#creTerm").val(),
			"univGbn"	  : $("#univGbn").val(),
			"crsTypeCd"   : crsTypeCd,
			"mngtDeptCd"  : $("#mngtDeptCd").val(),
			"searchValue" : $("#searchValue").val(),
			"searchKey"	  : searchKey,
			"listScale"	  : $("#listScale").val(),
			"pageIndex"	  : pageIndex,
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				var returnList = data.returnList || [];
        		var html = "";
        		
        		if(returnList.length > 0) {
        			returnList.forEach(function(v, i) {
        				html += "<tr>";
        				html += "	<td>";
        				html += "		<div class='ui checkbox'>";
        				html += "			<input type='checkbox' name='crsCreChk' id='chk"+i+"' onchange='checkCrsCre(this)' data-crscrenm='" + v.crsCreNm + "' value='" + v.crsCreCd + "' data-excSn='" + v.jobExcSn + "'>";
        				html += "			<label class='toggle_btn' for='chk"+i+"'></label>";
        				html += "		</div>";
        				html += "	</td>";
        				html += "	<td>" + v.lineNo + "</td>";
        				html += "	<td>" + (v.univGbnNm || '') + "</td>";
        				html += "	<td>" + v.deptNm + "</td>";
        				html += "	<td>" + v.crsCd + "</td>";
        				html += "	<td>" + v.declsNo + "</td>";
        				html += "	<td>" + v.crsCreNm + "</td>";
        				html += "	<td>" + v.tchNm + "</td>";
        				html += "	<td>" + v.tchNo + "</td>";
        				if(v.jobExcSn != null) {
        				var schStartDt = v.schStartDt.substring(0,4) + "." + v.schStartDt.substring(4,6) + "." + v.schStartDt.substring(6,8) + " " + v.schStartDt.substring(8,10) + ":" + v.schStartDt.substring(10,12);
        				var schEndDt   = v.schEndDt.substring(0,4) + "." + v.schEndDt.substring(4,6) + "." + v.schEndDt.substring(6,8) + " " + v.schEndDt.substring(8,10) + ":" + v.schEndDt.substring(10,12);
        				var modDttm	   = v.modDttm.substring(0,4) + "." + v.modDttm.substring(4,6) + "." + v.modDttm.substring(6,8) + " " + v.modDttm.substring(8,10) + ":" + v.modDttm.substring(10,12);
        				html += "	<td class='fcBlue'>" + schStartDt + "</td>";
        				html += "	<td class='fcBlue'>" + schEndDt + "</td>";
        				html += "	<td class='fcBlue'>" + v.excCmnt + "</td>";
        				html += "	<td class='fcBlue'>" + modDttm + "</td>";
        				} else {
        				html += "	<td>";
        				html += "		<div class='ui calendar' id='rangestart"+i+"'>";
        				html += "			<div class='ui input left icon'>";
        				html += "				<i class='calendar alternate outline icon'></i>";
        				html += "				<input type='text' id='schStartDt"+i+"' name='schStartDt' placeholder='시작일' autocomplete='off'/>";
        				html += "			</div>";
        				html += "		</div>";
        				html += "	</td>";
        				html += "	<td>";
        				html += "		<div class='ui calendar' id='rangeend"+i+"'>";
        				html += "			<div class='ui input left icon'>";
        				html += "				<i class='calendar alternate outline icon'></i>";
        				html += "				<input type='text' id='schEndDt"+i+"' name='schEndDt' placeholder='종료일' autocomplete='off'/>";
        				html += "			</div>";
        				html += "		</div>";
        				html += "	</td>";
        				html += "	<td><input type='text' name='excCmnt' /></td>";
        				html += "	<td>-</td>";
        				}
        				html += "</tr>";
        			});
        		}
        		
        		$("#crsCreTbody").empty().html(html);
        		var params = {
    				totalCount 	  	: data.pageInfo.totalRecordCount,
    				listScale 	  	: data.pageInfo.pageSize,
    				currentPageNo 	: data.pageInfo.currentPageNo,
    				eventName 	  	: "crsCreList"
    			};
    			
    			gfn_renderPaging(params);
        		$("#crsCreTable").footable();
        		$("#crsCreCnt").text(returnList.length > 0 ? returnList[0].totalCnt : 0);
        		
        		returnList.forEach(function(v, i) {
        			if(v.jobExcSn == null) {
	        			$('#rangestart'+i).calendar({
	        				type: 'datetime',
	        				ampm: false,
	        				endCalendar: $('#rangeend'+i),
	        				formatter: {
	        					date: function (date, settings) {
	        					if (!date) return '';
	        					var day = (date.getDate()) + '';
	        						if (day.length < 2) {
	        							day = '0' + day;
	        						}
	        					var month= (date.getMonth() + 1) + '';
	        						if (month.length < 2) {
	        							month = '0' + month;
	        						}
	        					var year = date.getFullYear();
	        					return year + '-' + month + '-' + day;
	        					}
	        				}
	        			});
	        			$('#rangeend'+i).calendar({
	        				type: 'datetime',
	        				ampm: false,
	        				startCalendar: $('#rangestart'+i),
	        				formatter: {
	        					date: function (date, settings) {
	        					if (!date) return '';
	        					var day = (date.getDate()) + '';
	        					if (day.length < 2) {
	        						day = '0' + day;
	        					}
	        					var month = (date.getMonth() + 1) + '';
	        					if (month.length < 2) {
	        						month = '0' + month;
	        					}
	        					var year = date.getFullYear();
	        					return year + '-' + month + '-' + day;
	        					}
	        				}
	        			});
        			}
        		});
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
		}, true);
	}
	
	// 체크박스 이벤트
	function checkCrsCre(obj) {
		if(obj.value == "all") {
			$("input[name=crsCreChk]").prop("checked", obj.checked);
		} else {
			$("#allChk").prop("checked", $("input[name=crsCreChk]").length == $("input[name=crsCreChk]:checked").length);
		}
	}
	
	// 저장
	function excSave() {
		var isSubmit = true;
		$("#saveForm").empty();
		$("#saveForm").append("<input type='hidden' name='creYear' value='"+ $("#creYear").val() +"' />");
		$("#saveForm").append("<input type='hidden' name='creTerm' value='"+ $("#creTerm").val() +"' />");
		if($("input[name=crsCreChk]:checked").length == 0) {
			alert("예외처리할 과목을 선택해주세요.");
			return false;
		}
		$("#crsCreTbody > tr").each(function(i, v) {
			if($(v).find("input[name=crsCreChk]").is(":checked")) {
				var crsCreNm = $(v).find("input[name=crsCreChk]").attr("data-crscrenm");
				if($(v).find("input[name=schStartDt]").val() == "") {
					alert(crsCreNm+" 과목 예외 시작일시를 입력하세요.");
					isSubmit = false;
					$(v).find("input[name=schStartDt]").focus();
					return false;
				}
 				if($(v).find("input[name=schEndDt]").val() == "") {
 					alert(crsCreNm+" 과목 예외 종료일시를 입력하세요.");
 					isSubmit = false;
 					$(v).find("input[name=schEndDt]").focus();
					return false;
 				}
				if($.trim($(v).find("input[name=excCmnt]").val()) == "") {
					alert(crsCreNm+" 과목 예외처리사유를 입력하세요.");
					isSubmit = false;
					$(v).find("input[name=excCmnt]").focus();
					return false;
				}
				
				var schStartDt = $(v).find("input[name=schStartDt]").val().replaceAll("-","").replaceAll(":","");
				if(schStartDt.split(" ")[1].length == 3) {
					schStartDt = schStartDt.split(" ")[0] + "0" + schStartDt.split(" ")[1] + "00";
				} else {
					schStartDt = schStartDt.replaceAll(" ", "") + "00";
				}
				var schEndDt = $(v).find("input[name=schEndDt]").val().replaceAll("-","").replaceAll(":","");
				if(schEndDt.split(" ")[1].length == 3) {
					schEndDt = schEndDt.split(" ")[0] + "0" + schEndDt.split(" ")[1] + "59";
				} else {
					schEndDt = schEndDt.replaceAll(" ", "") + "59";
				}
				
				$("#saveForm").append("<input type='hidden' name='crsCreCdList'   value='"+ $(v).find("input[name=crsCreChk]").val() +"' />");
				$("#saveForm").append("<input type='hidden' name='schStartDtList' value='"+ schStartDt +"' />");
				$("#saveForm").append("<input type='hidden' name='schEndDtList'   value='"+ schEndDt +"' />");
				$("#saveForm").append("<input type='hidden' name='excCmntList'    value='"+ $(v).find("input[name=excCmnt]").val() +"' />");
			}
		});
		
		if(isSubmit) {
			var url  = "/grade/gradeMgr/saveGradeInputExc.do";
			
			ajaxCall(url, $("#saveForm").serialize(), function(data) {
				if (data.result > 0) {
	        		alert("<spring:message code='score.alert.save.exc.period' />");/* 예외기간 저장이 완료되었습니다. */
	        		crsCreList(1);
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
			});
		}
	}
	
	// 삭제
	function excDel() {
		var excSnStr = "";
		$("#crsCreTbody > tr input[name=crsCreChk]:checked").each(function(i, v) {
			if($(v).attr("data-excSn") != "undefined") {
				if(excSnStr != "") excSnStr += ",";
				excSnStr += $(v).attr("data-excSn") + "|" + $(v).val();
			}
		});
		
		var url  = "/jobSchMgr/deleteSysJobSchExc.do";
		var data = {
			excSnStr : excSnStr
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		alert("<spring:message code='score.alert.delete.exc.period' />");/* 예외기간 삭제가 완료되었습니다. */
        		crsCreList(1);
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
		});
	}
	
	// 엑셀 다운로드
	function excelDown() {
		var excelGrid = {
			colModel:[
				{label:'<spring:message code="common.number.no"/>', 				name:'lineNo', 		align:'right', 	width:'1000'},	// NO
				{label:'<spring:message code="common.type" />', 					name:'univGbnNm', 	align:'left', 	width:'5000'},	// 구분
				{label:'<spring:message code="common.phy.dept_name" />', 			name:'deptNm', 		align:'left', 	width:'5000'},	// 관상학과
				{label:'<spring:message code="common.crs.cd" />', 					name:'crsCd', 		align:'left', 	width:'7000'},	// 학수번호
				{label:'<spring:message code="common.label.decls.no" />', 			name:'declsNo', 	align:'left', 	width:'5000'},	// 분반
				{label:'<spring:message code="crs.label.crecrs.nm" />', 			name:'crsCreCd', 	align:'left', 	width:'5000'},	// 과목명
				{label:'<spring:message code="common.charge.professor" />', 		name:'tchNm', 		align:'center', width:'2000'},	// 담당교수
				{label:'<spring:message code="common.label.prof.no" />', 			name:'tchNo', 		align:'center', width:'5000'},	// 교수사번
				{label:'<spring:message code="common.date.start.dt" />', 			name:'schStartDt', 	align:'left',	width:'9000'},	// 시작일시
				{label:'<spring:message code="common.date.end.dt" />', 				name:'schEndDt', 	align:'center', width:'2500'},	// 종료일시
				{label:'<spring:message code="score.label.reason.exception" />', 	name:'excCmnt', 	align:'left',	width:'9000'},	// 예외처리사유
				{label:'<spring:message code="score.label.process.date" />', 		name:'modDttm', 	align:'center', width:'2500'},	// 처리일시
			]
		};
		
		var crsTypeCd = "";
		$(".crsTypeBtn").each(function(i, v) {
			if($(v).hasClass("active")) {
				if(crsTypeCd == "") {
					crsTypeCd = $(v).attr("data-crs-type-cd");
				} else {
					crsTypeCd += "," + $(v).attr("data-crs-type-cd");
				}
			}
		});
		var searchKey = $("#excCreCrs").is(":checked") ? "Y" : "N";
	
		$("form[name='excelForm']").remove();
		var excelForm = $('<form></form>');
		excelForm.attr("name","excelForm");
		excelForm.attr("action","/grade/gradeMgr/gradeInputExcCrsCreListExcelDown.do");
		excelForm.append($('<input/>', {type: 'hidden', name: 'creYear', 		value: $("#creYear").val()}));
		excelForm.append($('<input/>', {type: 'hidden', name: 'creTerm', 		value: $("#creTerm").val()}));
		excelForm.append($('<input/>', {type: 'hidden', name: 'univGbn', 		value: $("#univGbn").val()}));
		excelForm.append($('<input/>', {type: 'hidden', name: 'crsTypeCd', 		value: crsTypeCd}));
		excelForm.append($('<input/>', {type: 'hidden', name: 'mngtDeptCd', 	value: $("#mngtDeptCd").val()}));
		excelForm.append($('<input/>', {type: 'hidden', name: 'searchValue', 	value: $("#searchValue").val()}));
		excelForm.append($('<input/>', {type: 'hidden', name: 'searchKey', 		value: searchKey}));
		excelForm.append($('<input/>', {type: 'hidden', name: 'excelGrid', 		value:JSON.stringify(excelGrid)}));
		excelForm.appendTo('body');
		excelForm.submit();
	}
	
	// 예외처리로그 팝업
	function excLogPop() {
		$("#modalExcLogForm input[name=creYear]").val($("#creYear").val());
		$("#modalExcLogForm input[name=creTerm]").val($("#creTerm").val());
		$("#modalExcLogForm input[name=univGbn]").val($("#univGbn").val());
		$("#modalExcLogForm input[name=mngtDeptCd]").val($("#mngtDeptCd").val());
		$("#modalExcLogForm input[name=searchValue]").val($("#searchValue").val());
		$("#modalExcLogForm").attr("target", "modalExcLogIfm");
        $("#modalExcLogForm").attr("action", "/grade/gradeMgr/gradeInputExcLogPopup.do");
        $("#modalExcLogForm").submit();
        $('#modalExcLog').modal('show');
	}
</script>
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
				<div class="ui form">
					<div id="info-item-box">
	                    <h2 class="page-title"><spring:message code="score.label.grade.manage" /><!-- 성적평가관리 --> > <spring:message code="score.label.grade.input.date.exc" /><!-- 성적입력기간 예외처리 --></h2>
	                </div>
	                <div class="ui segment">
		                <div class="option-content" style="<%=(!SessionInfo.isKnou(request) ? "display:none" : "")%>">
		                	<div class="ui buttons">
				            	<button class="ui blue button active crsTypeBtn" data-crs-type-cd="UNI" onclick="selectContentCrsType(this)"><spring:message code="crs.label.crs.uni" /><!-- 학기제 --></button>
				            	<%-- <button class="ui basic blue button crsTypeBtn" data-crs-type-cd="CO" onclick="selectContentCrsType(this)"><spring:message code="crs.label.crs.co" /><!-- 기수제 --></button>
				            	<button class="ui basic blue button crsTypeBtn" data-crs-type-cd="LEGAL" onclick="selectContentCrsType(this)"><spring:message code="crs.label.crs.court" /><!-- 법정교육 --></button>
				            	<button class="ui basic blue button crsTypeBtn" data-crs-type-cd="OPEN" onclick="selectContentCrsType(this)"><spring:message code="crs.label.crs.open" /><!-- 공개강좌 --></button> --%>
			                </div>
		                </div>
		                <div class="option-content">
		                	<select class="ui dropdown mr5" id="creYear" onchange="crsCreList(1)">
		                		<c:forEach var="year" items="${yearList }">
		                			<option value="${year}" <c:if test="${year eq termVO.haksaYear}">selected</c:if>>${year}<spring:message code="date.year" /><!-- 년 --></option>
		                		</c:forEach>
		                	</select>
		                	<select class="ui dropdown mr5" id="creTerm" onchange="crsCreList(1)">
		                		<c:forEach var="term" items="${termList }">
		                			<option value="${term.codeCd }" <c:if test="${term.codeCd eq termVO.haksaTerm }">selected</c:if>>${term.codeNm }</option>
		                		</c:forEach>
		                	</select>
		                	<c:if test="${orgId eq 'ORG0000001' }">
			                	<select class="ui dropdown mr5" id="univGbn" onchange="crsCreList(1)">
			                		<option value="ALL"><spring:message code="common.label.uni.type" /><!-- 대학구분 --></option>
			                		<c:forEach var="item" items="${univGbnList}">
										<option value="${item.codeCd}" ${item.codeCd}><c:out value="${item.codeNm}" /></option>
									</c:forEach>
			                	</select>
		                	</c:if>
		                	<select class="ui dropdown mr5" id="mngtDeptCd" onchange="crsCreList(1)">
		                		<option value="ALL"><spring:message code="common.dept_name" /><!-- 학과 --></option>
		                		<c:forEach var="dept" items="${usrDeptCdList }">
		                			<option value="${dept.deptCd }">${dept.deptNm }</option>
		                		</c:forEach>
		                	</select>
		                	<input type="text" class="ui input w400 mr5" placeholder="과목명/학수번호/교수명/교수사번 입력" id="searchValue" />
		                	<div class="mla">
		                		<select class="ui dropdown" id="listScale" onchange="crsCreList(1)">
		                			<option value="10">10</option>
		                			<option value="20">20</option>
		                			<option value="50">50</option>
		                		</select>
		                	</div>
		                </div>
		                <div class="option-content">
		                	<div class="ui checkbox">
			                	<input type="checkbox" id="excCreCrs" onchange="crsCreList(1)" />
			                	<label for="excCreCrs"><spring:message code="score.label.exc.cre.crs" /><!-- 기간예외처리과목 --></label>
		                	</div>
		                	<div class="mla">
								<button type="button" class="ui green button" onclick="crsCreList(1)"><spring:message code="common.button.search" /><!-- 검색 --></button>
							</div>
		                </div>
	                </div>
	                
	                <div class="option-content">
		                <h3 class="sec_head mr20"><spring:message code="crs.label.open.crs" /><!-- 개설과목 --> <spring:message code="score.label.grade.input.date.exc" /><!-- 성적입력기간 예외처리 --></h3>
		                <p>[ <spring:message code="common.page.total" /><!-- 총 --> <span class="fcBlue" id="crsCreCnt">0</span><spring:message code="common.page.total_count" /><!-- 건 --> ]</p>
		                <div class="mla">
		                	<button type="button" class="ui small basic button" onclick="excLogPop()"><spring:message code="score.label.exc.log" /><!-- 예외처리로그 --></button>
		                	<button type="button" class="ui small grey button" onclick="excDel()"><spring:message code="common.button.delete" /><!-- 삭제 --></button>
		                	<button type="button" class="ui small green button" onclick="excSave()"><spring:message code="common.button.save" /><!-- 저장 --></button>
		                	<button type="button" class="ui small green button" onclick="excelDown()"><spring:message code="common.button.excel_down" /><!-- 엑셀 다운로드 --></button>
		                </div>
	                </div>
	                
		           <table class="table type2" data-sorting="false" data-paging="false" data-empty="<spring:message code='common.content.not_found' />" id="crsCreTable"><!-- 등록된 내용이 없습니다. -->
			           	<thead class="footable-header">
			           		<tr>
			           			<th class="w30">
			           				<div class="ui checkbox">
									    <input type="checkbox" id="allChk" value="all" onchange="checkCrsCre(this)">
									    <label class="toggle_btn" for="allChk"></label>
									</div>
			           			</th>
			           			<th class="num">No</th>
			           			<th><spring:message code="common.type" /><!-- 구분 --></th>
			           			<th><spring:message code="common.phy.dept_name" /><!-- 관장학과 --></th>
			           			<th><spring:message code="common.crs.cd" /><!-- 학수번호 --></th>
			           			<th><spring:message code="common.label.decls.no" /><!-- 분반 --></th>
			           			<th><spring:message code="crs.label.crecrs.nm" /><!-- 과목명 --></th>
			           			<th><spring:message code="common.charge.professor" /><!-- 담당교수 --></th>
			           			<th><spring:message code="common.label.prof.no" /><!-- 교수사번 --></th>
			           			<th><spring:message code="common.date.start.dt" /><!-- 시작일시 --></th>
			           			<th><spring:message code="common.date.end.dt" /><!-- 종료일시 --></th>
			           			<th><spring:message code="score.label.reason.exception" /><!-- 예외처리사유 --></th>
			           			<th><spring:message code="score.label.process.date" /><!-- 처리일시 --></th>
			           		</tr>
			           	</thead>
			           	<tbody id="crsCreTbody"></tbody>
		           </table>
		           <div id="paging" class="paging mt20"></div>
		           
		           <form id="saveForm" method="POST">
		           </form>
	                
				</div>
			</div>
			
		<%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
	    
	    <!-- 성적입력기간 예외처리 로그 팝업 -->
	    <form class="ui form" id="modalExcLogForm" name="modalExcLogForm" method="POST" action="">
	    	<input type="hidden" name="creYear"/>
	    	<input type="hidden" name="creTerm" />
	    	<input type="hidden" name="univGbn" />
	    	<input type="hidden" name="mngtDeptCd" />
	    	<input type="hidden" name="searchValue" />
		    <div class="modal fade" id="modalExcLog" tabindex="-1" role="dialog" aria-labelledby="<spring:message code='score.label.grade.input.date.exc.log' />" aria-hidden="false">
		        <div class="modal-dialog modal-lg" role="document">
		            <div class="modal-content">
		                <div class="modal-header">
		                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="sys.button.close" />">
		                        <span aria-hidden="true">&times;</span>
		                    </button>
		                    <h4 class="modal-title"><spring:message code="score.label.grade.input.date.exc.log" /><!-- 성적입력기간 예외처리 로그 --></h4>
		                </div>
		                <div class="modal-body">
		                    <iframe src="" id="modalExcLogIfm" name="modalExcLogIfm" width="100%" scrolling="no"></iframe>
		                </div>
		            </div>
		        </div>
		    </div>
	    </form>
 		<script>
 			$('iframe').iFrameResize();
			window.closeModal = function(){
	            $('.modal').modal('hide');
	        };
	    </script>

		</div>
	</div>

</body>

</html>

