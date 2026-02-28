<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    </head>
    
    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	
	<script type="text/javascript">
		$(document).ready(function() {
			addTypeCheck();
			listQbankCtgr(1);
			
			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					listQbankCtgr(1);
				}
			});
		});
		
		// 분류코드 리스트 조회
		function listQbankCtgr(page) {
			var crsNo = $("#searchCrsNo").val() == "all" ? "${vo.crsCd}" : $("#searchCrsNo").val();
			var url  = "/quiz/qbankCtgrList.do";
			var data = {
				"pageIndex" 		 : page,
				"listScale" 		 : $("#listScale").val(),
				"searchValue" 		 : $("#searchValue").val(),
				"parExamQbankCtgrCd" : $("#searchParExamQbankCtgrCd").val(),
				"crsNo" 			 : crsNo
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		var html = ``;
	        		data.returnList.forEach(function(v, i) {
			        	html += `<tr \${v.parExamQbankCtgrCd == null ? `class="topCtgr"` : ``}>`;
			        	html += `	<td class="tc">\${v.lineNo}</td>`;
			        	html += `	<td>\${v.parExamCtgrNm}</td>`;
			        	html += `	<td>\${v.examCtgrNm}</td>`;
			        	html += `	<td class="tl">\${v.crsNm}</td>`;
			        	html += `	<td class="tc">\${v.userNm}</td>`;
			        	html += `	<td class="tc">`;
			        	if(v.userId == "${vo.userId}") {
			        	html += `		<a class="ui basic small button" href="javascript:editQbankCtgrForm('\${v.examQbankCtgrCd}')"><spring:message code="exam.button.mod" /></a>`;/* 수정 */
			        	html += `		<a class="ui basic small button" href="javascript:delQbankCtgrForm('\${v.examQbankCtgrCd}')"><spring:message code="exam.button.del" /></a>`;/* 삭제 */
			        	}
			        	html += `	</td>`;
			        	html += `</tr>`;
	        		});
	        		
	        		$("#qbankCtgrList").empty().html(html);
		    		$(".table").footable();
		    		var params = {
				    	totalCount 	  : data.pageInfo.totalRecordCount,
				    	listScale 	  : data.pageInfo.pageSize,
				    	currentPageNo : data.pageInfo.currentPageNo,
				    	eventName 	  : "listQbankCtgr"
				    };
				    
				    gfn_renderPaging(params);
			    	changeCtgrOdr();
	            } else {
	             	alert(data.message);
	            }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
    		});
		}
		
		// 분류 코드 등록
		function writeQbankCtgr() {
			$("#qbankCtgrWriteForm input[name=examCtgrLvl]").remove();
			$("#qbankCtgrWriteForm input[name=parExamQbankCtgrCd]").remove();
			if($.trim($("#examCtgrNm").val()) == "") {
				alert("<spring:message code='exam.alert.insert.categori.nm' />");/* 분류명을 입력하세요. */
				return false;
			}
			var type = $("input[name=addType]:checked").val();
			if(type == "UPPER") {
				$("#parExamQbankCtgrCd").val(" ").trigger("change");
				$("#qbankCtgrWriteForm").append("<input type='hidden' name='examCtgrLvl' value='1' />");
			} else {
				if($("#parExamQbankCtgrCd").val() == " ") {
					alert("<spring:message code='exam.alert.select.upper.categori' />");/* 상위 분류를 선택하세요. */
					return false;
				} else {
					$("#qbankCtgrWriteForm").append("<input type='hidden' name='parExamQbankCtgrCd' value='" + $("#parExamQbankCtgrCd").val() +"' />");
					var examCtgrLvl = parseInt($("#parExamQbankCtgrCd option:selected").attr("data-ctgrLvl")) + 1;
					$("#qbankCtgrWriteForm").append("<input type='hidden' name='examCtgrLvl' value='" + examCtgrLvl +"' />");
				}
			}
			
			showLoading();
			var url = "/quiz/writeQbankCtgr.do";
	    	
			$.ajax({
	            url 	 : url,
	            async	 : false,
	            type 	 : "POST",
	            dataType : "json",
	            data 	 : $("#qbankCtgrWriteForm").serialize(),
	        }).done(function(data) {
	        	hideLoading();
	        	if (data.result > 0) {
	        		location.reload();
	            } else {
	             	alert(data.message);
	            }
	        }).fail(function() {
	        	hideLoading();
	        	alert("<spring:message code='exam.error.insert' />");/* 저장 중 에러가 발생하였습니다. */
	        });
		}
		
		// 분류 코드 수정
		function editQbankCtgr(examQbankCtgrCd) {
			if($.trim($("#examCtgrNm").val()) == "") {
				alert("<spring:message code='exam.alert.insert.categori.nm' />");/* 분류명을 입력하세요. */
				return false;
			}
			
			showLoading();
			var url = "/quiz/editQbankCtgr.do";
	    	
			$.ajax({
	            url 	 : url,
	            async	 : false,
	            type 	 : "POST",
	            dataType : "json",
	            data 	 : $("#qbankCtgrWriteForm").serialize(),
	        }).done(function(data) {
	        	hideLoading();
	        	if (data.result > 0) {
	        		location.reload();
	            } else {
	             	alert(data.message);
	            }
	        }).fail(function() {
	        	hideLoading();
	        	alert("<spring:message code='exam.error.update' />");/* 수정 중 에러가 발생하였습니다. */
	        });
		}
		
		// 분류 코드 삭제
		function delQbankCtgrForm(examQbankCtgrCd) {
			var url  = "/quiz/selectQbankCtgrOdr.do";
			var data = {
				"examQbankCtgrCd" : examQbankCtgrCd,
				"userId"		  : "${vo.userId}"
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					if(data.returnVO.examCtgrOdr == 1) {
						var confirm = window.confirm("<spring:message code='exam.confirm.qbank.ctgr.delete' />");/* 분류코드를 삭제하시겠습니까? */
						if(confirm) {
							var url  = "/quiz/delQbankCtgr.do";
							var data = {
								"examQbankCtgrCd" : examQbankCtgrCd
							};
							
							ajaxCall(url, data, function(data) {
								if (data.result > 0) {
									location.reload();
					            } else {
					             	alert(data.message);
					            }
							}, function(xhr, status, error) {
								alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
							});
						}
					} else {
						alert("<spring:message code='exam.alert.sub.categori.first.delete' />");/* 하위 분류가 있습니다. 하위 분류 삭제 후 삭제해주세요. */
					}
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
			});
		}
		
		// 분류 순서 가져오기
		function changeCtgrOdr() {
			showLoading();
			var ctgrCd = $("#parExamQbankCtgrCd").val() == "" ? "-" : $("#parExamQbankCtgrCd").val();
			var url  = "/quiz/selectQbankCtgrOdr.do";
			var data = {
				"examQbankCtgrCd" : ctgrCd,
				"userId"		  : "${vo.userId}"
			};
			
			$.ajax({
	            url 	 : url,
	            async	 : false,
	            type 	 : "POST",
	            dataType : "json",
	            data 	 : data,
	        }).done(function(data) {
	        	hideLoading();
	        	if (data.result > 0) {
	        		if($("#parExamQbankCtgrCd").val() == " ") {
	        			var examCtgrOdr = $(".topCtgr").length + 1;
		        		$("#examCtgrOdr").val(examCtgrOdr);
	        		} else {
		        		$("#examCtgrOdr").val(data.returnVO.examCtgrOdr);
	        		}
	            } else {
	             	alert(data.message);
	            }
	        }).fail(function() {
	        	hideLoading();
	        	alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
	        });
		}
		
		// 엑셀 다운로드
		function qbankCtgrExcelDown() {
			$("form[name=excelForm]").remove();
			var excelGrid = {
				colModel:[
				        {label:'No.',													name:'lineNo',       	align:'center', width:'1000'},	
				        {label:"<spring:message code='exam.label.upper.categori' />",	name:'parExamCtgrNm',	align:'left',   width:'5000'},/* 상위분류 */
				        {label:"<spring:message code='exam.label.categori.odr' />",		name:'parExamCtgrLvl',	align:'left',	width:'5000'},/* 분류순서 */
				        {label:"<spring:message code='exam.label.sub.categori' />",		name:'examCtgrNm',    	align:'right',  width:'5000'},/* 하위분류 */
				        {label:"<spring:message code='exam.label.categori.odr' />",		name:'examCtgrOdr',   	align:'right',  width:'5000'},/* 분류순서 */
				        {label:"<spring:message code='crs.label.crecrs' />",  			name:'crsNm',    		align:'right',  width:'5000'},/* 과목 */
				        {label:"<spring:message code='exam.label.tch.rep' />",			name:'userNm', 			align:'right',  width:'5000'},/* 담당교수 */
						]
			};
			
			var url  = "/quiz/qbankCtgrExcelDown.do";
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "excelForm");
			form.attr("action", url);
			form.attr("target", "excelDownloadIfm");
			form.append($('<input/>', {type: 'hidden', name: 'excelGrid', 	 		value: JSON.stringify(excelGrid)}));
			form.append($('<input/>', {type: 'hidden', name: 'searchValue', 		value: $("#searchValue").val()}));
			form.append($('<input/>', {type: 'hidden', name: 'parExamQbankCtgrCd', 	value: $("#searchParExamQbankCtgrCd").val()}));
			form.append($('<input/>', {type: 'hidden', name: 'crsNo', 				value: $("#searchCrsNo").val()}));
			form.appendTo("body");
			form.submit();
		}
		
		// 분류코드 수정 정보
		function editQbankCtgrForm(examQbankCtgrCd) {
			var url  = "/quiz/viewExamQbankCtgrCd.do";
			var data = {
				"examQbankCtgrCd" : examQbankCtgrCd
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					var returnVO = data.returnVO;
					if(returnVO != null) {
						if(returnVO.parExamQbankCtgrCd != null) {
							$("#parExamQbankCtgrCd").val(returnVO.parExamQbankCtgrCd).trigger("change");
							$("#underType").prop("checked", true).trigger("change");
						} else {
							$("#parExamQbankCtgrCd").val(" ").trigger("change");
							$("#upperType").prop("checked", true).trigger("change");
						}
						$("#parExamQbankCtgrCd").parent().css("pointer-events", "none");
						$("#qbankCtgrWriteForm input[name=examQbankCtgrCd]").val(returnVO.examQbankCtgrCd);
						$("#qbankCtgrWriteForm input[name=examCtgrLvl]").val(returnVO.examCtgrLvl);
						$("#qbankCtgrWriteForm input[name=parExamQbankCtgrCd]").val(returnVO.parExamQbankCtgrCd);
						$("#examCtgrNm").val(returnVO.examCtgrNm);
						$("#examCtgrDesc").val(returnVO.examCtgrDesc);
						$("#examCtgrOdr").val(returnVO.examCtgrOdr);
						$("#ctgrBtn").text("<spring:message code='exam.button.mod' />");/* 수정 */
						$("#ctgrBtn").attr("href", "javascript:editQbankCtgr(\""+examQbankCtgrCd+"\")");
					}
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='exam.error.info' />");/* 정보 조회 중 에러가 발생하였습니다. */
			});
		}
		
		// 등록 구분 선택
		function addTypeCheck() {
			var type = $("input[name=addType]:checked").val();
			if(type == "UPPER") {
				$("#categoriLi").css("display", "none");
			} else {
				$("#categoriLi").css("display", "list-item");
			}
		}
	</script>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
        	<div class="option-content">
        		<form name="qbankCtgrWriteForm" id="qbankCtgrWriteForm" method="POST">
        			<input type="hidden" name="useYn" value="Y" />
        			<input type="hidden" name="examQbankCtgrCd" />
					<input type="hidden" name="examCtgrLvl" />
					<input type="hidden" name="parExamQbankCtgrCd" />
					<input type="hidden" name="examCtgrOdr" id="examCtgrOdr" value="${fn:length(ctgrList)+1 }" />
		            <ul class="tbl">
		            	<li>
		            		<dl>
		            			<dt class="tc">
		            				<label for="teamLabel" class="req"><spring:message code="exam.label.categori.add.type" /></label><!-- 등록 구분 -->
		            			</dt>
		            			<dd>
		            				<div class="ui radio checkbox mr10">
		            					<input type="radio" name="addType" id="upperType" value="UPPER" onchange="addTypeCheck()" class="hidden" checked />
		            					<label for="upperType"><spring:message code="exam.label.categori.upper.add" /><!-- 상위 분류 등록 --></label>
		            				</div>
		            				<div class="ui radio checkbox">
		            					<input type="radio" name="addType" id="underType" value="UNDER" onchange="addTypeCheck()" class="hidden" />
		            					<label for="underType"><spring:message code="exam.label.categori.under.add" /><!-- 하위 분류 등록 --></label>
		            				</div>
		            			</dd>
		            		</dl>
		            	</li>
						<li id="categoriLi">
							<dl>
								<dt class="tc">
									<label for="teamLabel"><spring:message code="exam.label.categori.type" /></label><!-- 분류구분 -->
								</dt>
								<dd>
									<select class="ui dropdown" id="parExamQbankCtgrCd" onchange="changeCtgrOdr()">
										<option value=" "><spring:message code="exam.label.upper.categori" /></option><!-- 상위분류 -->
										<c:forEach var="list" items="${ctgrList }">
											<option data-ctgrLvl="${list.examCtgrLvl }" value="${list.examQbankCtgrCd }">${list.parExamCtgrNm }</option>
										</c:forEach>
							        </select>
								</dd>
							</dl>
						</li>
						<li>
							<dl>
								<dt class="tc">
									<label class="req"><spring:message code="exam.label.crs.cd" /></label><!-- 학수 번호 -->
								</dt>
								<dd>
									<div class="ui input"><input type="text" name="crsNo" value="${crsVO.crsCd }" readonly="readonly" /></div>
									(${crsVO.crsNm })
								</dd>
								<dt class="tc">
									<label class="req"><spring:message code="exam.label.tch.cd" /></label><!-- 교수 번호 -->
								</dt>
								<dd>
									<div class="ui input"><input type="text" name="userId" value="${vo.userId }" readonly="readonly" /></div>
									(${vo.userNm } <spring:message code="exam.label.tch" /><!-- 교수 -->)
								</dd>
							</dl>
						</li>
						<li>
							<dl>
								<dt class="tc">
									<label for="teamLabel" class="req"><spring:message code="exam.label.categori.nm" /></label><!-- 분류명 -->
								</dt>
								<dd>
									<div class="ui input wmax">
										<input type="text" name="examCtgrNm" id="examCtgrNm" />
									</div>
								</dd>
							</dl>
						</li>
						<li>
							<dl>
								<dt class="tc">
									<label for="teamLabel"><spring:message code="exam.label.categori.desc" /></label><!-- 분류설명 -->
								</dt>
								<dd><textarea name="examCtgrDesc" id="examCtgrDesc"></textarea></dd>
							</dl>
						</li>
					</ul>
					<div class="button-area tc mt20">
						<a href="javascript:writeQbankCtgr()" id="ctgrBtn" class="ui blue button w150"><spring:message code="exam.button.save" /></a><!-- 저장 -->
					</div>
        		</form>
				
				<h3 class="sec_head"><spring:message code="exam.label.categori.list" /><!-- 분류 목록 --></h3>
				<div class="option-content ui segment">
                	<div class="button-area">
                		<select class="ui dropdown mr5" id="searchCrsNo" onchange="listQbankCtgr(1)">
			                <option value="all"><spring:message code="crs.label.crecrs" /></option><!-- 과목 -->
			                <c:forEach var="item" items="${crsList }">
			                	<option value="${item.crsCd }">${item.crsNm }</option>
			                </c:forEach>
			            </select>
		                <select class="ui dropdown mr5" id="searchParExamQbankCtgrCd" onchange="listQbankCtgr(1)">
			                <option value="all"><spring:message code="exam.label.upper.categori" /></option><!-- 상위분류 -->
			                <c:set var="chk" value="on" />
			                <c:forEach var="item" items="${ctgrList }">
			                	<option value="${item.examQbankCtgrCd }">${item.parExamCtgrNm }</option>
			                </c:forEach>
			            </select>
                	</div>
                    <div class="ui action input search-box">
                        <input type="text" id="searchValue" class="w200" placeholder="<spring:message code='exam.label.categori.nm' />/<spring:message code='crs.label.crecrs.nm' />/<spring:message code='exam.label.tch.rep' /> <spring:message code='exam.label.input' />"><!-- 분류명 --><!-- 과목명 --><!-- 담당교수 --><!-- 입력 -->
                        <button class="ui icon button" onclick="listQbankCtgr(1)"><i class="search icon"></i></button>
                    </div>
                </div>
                
                <div class="option-content mb10">
                	<div class="button-area flex-left-auto">
                		<a href="javascript:qbankCtgrExcelDown()" class="ui basic button"><spring:message code="exam.button.excel.down" /></a><!-- 엑셀 다운로드 -->
                		<select class="ui dropdown mr5 list-num" id="listScale" onchange="listQbankCtgr(1)">
			                <option value="10">10</option>
			                <option value="20">20</option>
			                <option value="50">50</option>
			                <option value="100">100</option>
			            </select>
                	</div>
                </div>
				
				<table class="table type2" data-sorting="false" data-paging="false" data-empty="<spring:message code='exam.common.empty' />"><!-- 등록된 내용이 없습니다. -->
					<thead>
						<tr>
							<th scope="col" class="num"><spring:message code="common.number.no" /></th><!-- NO. -->
							<th scope="col"><spring:message code="exam.label.upper.categori" /></th><!-- 상위분류 -->
							<th scope="col"><spring:message code="exam.label.sub.categori" /></th><!-- 하위분류 -->
							<th scope="col"><spring:message code="crs.label.crecrs" /></th><!-- 과목 -->
							<th scope="col"><spring:message code="exam.label.tch.rep" /></th><!-- 담당교수 -->
							<th scope="col"><spring:message code="exam.label.manage" /></th><!-- 관리 -->
						</tr>
					</thead>
					<tbody id="qbankCtgrList">
					</tbody>
				</table>
				<div id="paging" class="paging wmax"></div>
        	</div>
	        
            <div class="bottom-content">
                <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
	
	<!-- 엑셀 다운로드 -->
	<iframe  width="100%" scrolling="no" id="excelDownloadIfm" name="excelDownloadIfm" style="display: none;"></iframe>
</html>
