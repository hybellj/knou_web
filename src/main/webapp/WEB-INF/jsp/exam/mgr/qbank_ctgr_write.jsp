<%@page import="knou.framework.common.SessionInfo"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
<script type="text/javascript">
	$(document).ready(function() {
		parCtgrList();
		listQbankCtgr(1)
		
		$("#searchValue").on("keyup", function(e) {
			if(e.keyCode == 13) {
				listQbankCtgr(1);
			}
		});
	});
	
	// 문제은행, 등록 탭 선택
	function manageQbank(type) {
		if(type == "0") {
			var kvArr = [];
			
			submitForm("/exam/examMgr/Form/qbankList.do", "", "", kvArr);
		} else if(type == "1") {
			location.reload();
		}
	}
	
	// 상위 분류코드 목록
	function parCtgrList() {
		var url  = "/quiz/listExamQbankCtgrCd.do";
		var data = {
			"crsNo"  	 : "${vo.crsNo}",
			"userId" 	 : "${vo.userId}",
			"searchType" : "UPPER"
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		var returnList = data.returnList || [];
        		var html = "<option value=''><spring:message code='exam.label.upper.categori' /></option>";/* 상위분류 */
        		
        		if(returnList.length > 0) {
        			returnList.forEach(function(v, i) {
	        			html += `<option data-ctgrLvl="\${v.examCtgrLvl}" value="\${v.examQbankCtgrCd}">\${v.parExamCtgrNm}</option>`;
	        		});
        		}
        		
        		$("#parExamQbankCtgrCd").empty().append(html);
        		$("#parExamQbankCtgrCd").dropdown("clear");
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
		if($("#parExamQbankCtgrCd").val() == "") {
			$("#qbankCtgrWriteForm").append("<input type='hidden' name='examCtgrLvl' value='1' />");
		} else {
			$("#qbankCtgrWriteForm").append("<input type='hidden' name='parExamQbankCtgrCd' value='" + $("#parExamQbankCtgrCd").val() +"' />");
			var examCtgrLvl = parseInt($("#parExamQbankCtgrCd option:selected").attr("data-ctgrLvl")) + 1;
			$("#qbankCtgrWriteForm").append("<input type='hidden' name='examCtgrLvl' value='" + examCtgrLvl +"' />");
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
	function delQbankCtgrForm(examQbankCtgrCd, userId) {
		var url  = "/quiz/selectQbankCtgrOdr.do";
		var data = {
			"examQbankCtgrCd" : examQbankCtgrCd,
			"userId"		  : userId
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
		var url  = "/quiz/selectQbankCtgrOdr.do";
		var data = {
			"examQbankCtgrCd" : $("#parExamQbankCtgrCd").val(),
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
        		if($("#parExamQbankCtgrCd").val() == "") {
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
	
	// 분류코드 리스트 조회
	function listQbankCtgr(page) {
		var url  = "/quiz/qbankCtgrList.do";
		var data = {
			"pageIndex" 		 : page,
			"listScale" 		 : $("#listScale").val(),
			"searchValue" 		 : $("#searchValue").val(),
			"parExamQbankCtgrCd" : $("#searchParExamQbankCtgrCd").val(),
			"examQbankCtgrCd" 	 : $("#searchExamQbankCtgrCd").val(),
			"crsNo" 			 : "${vo.crsNo}"
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		var html = ``;
        		data.returnList.forEach(function(v, i) {
		        	html += `<tr \${v.parExamQbankCtgrCd == null ? `class="topCtgr"` : ``}>`;
		        	html += `	<td class="tc">\${v.lineNo}</td>`;
		        	html += `	<td>\${v.parExamCtgrNm}</td>`;
		        	html += `	<td>\${v.examCtgrNm}</td>`;
		        	html += `	<td>\${v.crsNm}</td>`;
		        	html += `	<td class="tc">\${v.userNm}</td>`;
		        	html += `	<td class="tc">`;
		        	html += `		<a class="ui basic small button" href="javascript:editQbankCtgrForm('\${v.examQbankCtgrCd}')"><spring:message code="exam.button.mod" /></a>`;/* 수정 */
		        	html += `		<a class="ui basic small button" href="javascript:delQbankCtgrForm('\${v.examQbankCtgrCd}', '\${v.userId}')"><spring:message code="exam.button.del" /></a>`;/* 삭제 */
		        	html += `	</td>`;
		        	html += `</tr>`;
        		});
        		
        		$("#qbankCtgrList").empty().html(html);
	    		$("#qbankCtgrTable").footable();
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
					} else {
						$("#parExamQbankCtgrCd").dropdown("clear");
					}
					$("#parExamQbankCtgrCd").parent().css("pointer-events", "none");
					$("#qbankCtgrWriteForm input[name=examQbankCtgrCd]").val(returnVO.examQbankCtgrCd);
					$("#qbankCtgrWriteForm input[name=examCtgrLvl]").val(returnVO.examCtgrLvl);
					$("#qbankCtgrWriteForm input[name=parExamQbankCtgrCd]").val(returnVO.parExamQbankCtgrCd);
					$("#examCtgrNm").val(returnVO.examCtgrNm);
					$("#examCtgrDesc").val(returnVO.examCtgrDesc);
					$("#examCtgrOdr").val(returnVO.examCtgrOdr);
					$("#ctgrBtn").text("<spring:message code='exam.button.mod' />");/* 수정 */
					$("#ctgrBtn").attr("onclick", "editQbankCtgr(\""+examQbankCtgrCd+"\")");
				}
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.info' />");/* 정보 조회 중 에러가 발생하였습니다. */
		});
	}
	
	// 엑셀 다운로드
	function excelDown() {
		var excelGrid = {
			colModel:[
			   {label:"<spring:message code='main.common.number.no' />", name:'lineNo', align:'center', width:'1000'},/* NO */
			   {label:"<spring:message code='exam.label.upper.categori' />", name:'parExamCtgrNm', align:'left', width:'5000'},/* 상위분류 */
			   {label:"<spring:message code='exam.label.sub.categori' />", name:'examCtgrNm', align:'right', width:'5000'},/* 하위분류 */
			   {label:"<spring:message code='crs.label.crecrs' />", name:'crsNm', align:'right', width:'5000'},/* 과목 */
			   {label:"<spring:message code='exam.label.tch.rep' />", name:'userNm', align:'right', width:'5000'},/* 담당교수 */
			]
		};
		
		var kvArr = [];
		kvArr.push({'key' : 'excelGrid', 		  'val' : JSON.stringify(excelGrid)});
		kvArr.push({'key' : 'searchValue', 		  'val' : $("#searchValue").val()});
		kvArr.push({'key' : 'parExamQbankCtgrCd', 'val' : $("#searchParExamQbankCtgrCd").val()});
		kvArr.push({'key' : 'examQbankCtgrCd', 	  'val' : $("#searchExamQbankCtgrCd").val()});
		kvArr.push({'key' : 'crsNo', 			  'val' : "${vo.crsNo}"});
		
		submitForm("/quiz/qbankCtgrExcelDown.do", "", "", kvArr);
	}
	
	// 하위 분류 목록 가져오기
    function chgCtgrCd(obj) {
    	var url  = "/quiz/listExamQbankCtgrCd.do";
		var data = {
			"parExamQbankCtgrCd" : $(obj).val(),
			"searchType"		 : "UNDER"
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		var returnList = data.returnList || [];
        		var html = "<option value='all'><spring:message code='exam.label.sub.categori' /></option>";/* 하위분류 */
        		
        		if(returnList.length > 0 && $(obj).val() != "all") {
        			returnList.forEach(function(v, i) {
	        			html += `<option value="\${v.examQbankCtgrCd}">\${v.examCtgrNm}</option>`;
	        		});
        		}
        		
        		$("#searchExamQbankCtgrCd").empty().append(html);
        		$("#searchExamQbankCtgrCd").dropdown("clear");
        		$("#searchExamQbankCtgrCd option[value='all']").prop("selected", true).trigger("change");
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='exam.error.list' />");/* 리스트 조회 중 에러가 발생하였습니다. */
		});
    }
</script>

<body>
    <div id="wrap" class="pusher">
        <!-- class_top 인클루드  -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>

        <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>

        <div id="container">
            <!-- 본문 content 부분 -->
            <div class="content">
            	<%-- <%@ include file="/WEB-INF/jsp/common/admin/admin_location.jsp" %> --%>
        		<div class="ui form">
        			<div class="layout2">
		                <div id="info-item-box">
		                	<h2 class="page-title flex-item flex-wrap gap4 columngap16">
                                <spring:message code="exam.label.class.management.tool" /><!-- 수업운영도구 -->
                                <div class="ui breadcrumb small">
                                    <small class="section"><spring:message code="exam.label.qbank" /><!-- 문제은행 --></small>
                                </div>
                            </h2>
		                </div>
		        		<div class="row">
		        			<div class="col">
		        				<div class="listTab">
					                <ul>
					                    <li class="mw120 mla"><a onclick="manageQbank(0)"><spring:message code="exam.label.qbank" /><!-- 문제은행 --></a></li>
					                    <li class="select mw120"><a onclick="manageQbank(1)"><spring:message code="exam.label.categori.code" /><!-- 분류코드 --> <spring:message code="exam.button.reg" /><!-- 등록 --></a></li>
					                </ul>
					            </div>
					            <h3 class="sec_head mt20 mb20"> <spring:message code="exam.label.categori.code" /><spring:message code="exam.button.reg" /></h3><!-- 분류코드 등록-->
					            <form name="qbankCtgrWriteForm" id="qbankCtgrWriteForm" method="POST">
					            	<input type="hidden" name="useYn" value="Y" />
					            	<input type="hidden" name="examQbankCtgrCd" />
					            	<input type="hidden" name="examCtgrLvl" />
					            	<input type="hidden" name="parExamQbankCtgrCd" />
					            	<input type="hidden" name="examCtgrOdr" id="examCtgrOdr" class="w100 tc" value="1" readonly/>
									<div class="ui styled fluid week_lect_list" style="border:none;">
										<div class="content">
											<div class="ui segment">
												<ul class="tbl">
													<li>
														<dl>
															<dt class="p_w10">
																<label for="parExamQbankCtgrCd" class="req"><spring:message code="exam.label.upper.categori" /></label><!-- 상위분류 -->
															</dt>
															<dd class="pl20">
																<select class="ui dropdown" id="parExamQbankCtgrCd" onchange="changeCtgrOdr()">
																	<option value=""><spring:message code="exam.label.upper.categori" /></option><!-- 상위분류 -->
																</select>
																<span class="fcRed">! <spring:message code="exam.label.select.upper.categori" /></span><!-- 상위분류 선택 시 선택한 상위분류의 하위 분류로 등록됩니다. -->
															</dd>
														</dl>
													</li>
													<li>
														<dl>
															<dt class="p_w10">
																<label class="req"><spring:message code="exam.label.crs.cd" /></label><!-- 학수 번호 -->
															</dt>
															<dd class="pl20">
																<input type="text" name="crsNo" class="p_w60" value="${vo.crsNo }" readonly />
																<span class="wauto pl5">( ${vo.crsNm } <spring:message code="crs.label.crecrs" /> )</span><!-- 과목 -->
															</dd>
															<dt class="p_w10">
																<label class="req"><spring:message code="exam.label.tch.cd" /></label><!-- 교수 번호 -->
															</dt>
															<dd class="pl20">
																<input type="text" name="userId" class="p_w60" value="${vo.userId }" readonly />
																<span class="wauto pl5">( ${vo.userNm } <spring:message code="exam.label.tch" /> )</span><!-- 교수 -->
															</dd>
														</dl>
													</li>
													<li>
														<dl>
															<dt class="p_w10">
																<label for="examCtgrNm" class="req"><spring:message code="exam.label.categori.nm" /></label><!-- 분류명 -->
															</dt>
															<dd class="pl20">
																<input type="text" name="examCtgrNm" id="examCtgrNm" />
															</dd>
														</dl>
													</li>
													<li>
														<dl>
															<dt class="p_w10">
																<label for="examCtgrDesc"><spring:message code="exam.label.categori.desc" /></label><!-- 분류설명 -->
															</dt>
															<dd class="pl20">
																<textarea name="examCtgrDesc" id="examCtgrDesc" style="resize:none;"></textarea>
															</dd>
														</dl>
													</li>
												</ul>
											</div>
										</div>
									</div>
					            </form>
								<div class="tc mt20">
									<button onclick="writeQbankCtgr()" id="ctgrBtn" class="ui blue button w100"><spring:message code="exam.button.save" /></button><!-- 저장 -->
								</div>
		        			</div>
		        		</div>
		        		<div class="row mt20">
		        			<div class="col">
		        				<div class="ui styled fluid week_lect_list card">
									<div class="content">
										<select class="ui dropdown" id="searchParExamQbankCtgrCd" onchange="chgCtgrCd(this)">
											<option value="all"><spring:message code="exam.label.upper.categori" /></option><!-- 상위분류 -->
											<c:forEach var="item" items="${ctgrList }">
							                	<option value="${item.examQbankCtgrCd }">${item.parExamCtgrNm }</option>
							                </c:forEach>
										</select>
										<select class="ui dropdown" id="searchExamQbankCtgrCd" onchange="listQbankCtgr(1)">
											<option value="all"><spring:message code="exam.label.sub.categori" /><!-- 하위분류 --></option>
										</select>
										<div class="ui action input search-box">
					                        <input type="text" class="w300" id="searchValue" placeholder="<spring:message code="exam.alert.input.label.categorinm.tchnm.title.input" />"><!-- 분류명/ 담당교수/제목 입력 -->
					                        <button class="ui icon button" onclick="listQbankCtgr(1)"><i class="search icon"></i></button>
					                    </div>
									</div>
								</div>
								<div class="option-content mb20">
									<div class="mla">
										<a href="javascript:excelDown()" class="ui basic button"><spring:message code="exam.button.excel.down" /></a><!-- 엑셀 다운로드 -->
										<select class="ui dropdown list-num" id="listScale">
											<option value="10">10</option>
											<option value="20">20</option>
											<option value="50">50</option>
											<option value="100">100</option>
										</select>
									</div>
								</div>
								<table class="table" data-sorting="false" data-paging="false" id="qbankCtgrTable" data-empty="<spring:message code='exam.common.empty' />"><!-- 등록된 내용이 없습니다. -->
									<thead>
										<tr>
											<th class="tc"><spring:message code="main.common.number.no" /><!-- NO --></th>
											<th class="tc" data-breakpoints="xs sm md"><spring:message code="exam.label.upper.categori" /><!-- 상위분류 --></th>
											<th class="tc" data-breakpoints="xs"><spring:message code="exam.label.sub.categori" /><!-- 하위분류 --></th>
											<th class="tc"><spring:message code="crs.label.crecrs" /><!-- 과목 --></th>
											<th class="tc" data-breakpoints="xs sm"><spring:message code="exam.label.tch.rep" /><!-- 담당교수 --></th>
											<th class="tc"><spring:message code="exam.label.manage" /><!-- 관리 --></th>
										</tr>
									</thead>
									<tbody id="qbankCtgrList">
									</tbody>
								</table>
								<div id="paging" class="paging"></div>
		        			</div>
		        		</div>
        			</div>
        		</div>
			</div>
        </div>
        <!-- //본문 content 부분 -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
    </div>
</body>
</html>