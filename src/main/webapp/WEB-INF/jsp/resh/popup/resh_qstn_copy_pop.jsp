<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
		<%@ include file="/WEB-INF/jsp/resh/common/resh_common_inc.jsp" %>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    </head>
    
    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	
	<script type="text/javascript">
		$(document).ready(function() {
			$("#copyReshTable").css("display", "none");
		});
	
		// 선택 가져오기
		function selectReshCopy(type) {
			if(type == 1) {
				var reschCd = $("select[name=copyResh]").val();
				if(reschCd != "") {
					var url  = "/resh/listReshSimplePage.do";
					var data = {
						"reschCd" : reschCd
					};
					
					ajaxCall(url, data, function(data) {
						if (data.result > 0) {
			        		$("#copyReshPage option").remove();
			        		if(data.returnList.length > 0) {
								$("select[name=copyResh]").parent().css("pointer-events", "none");
			        			$("#copyReshPage").append(`<option value=''><spring:message code="resh.label.sel.copy.resh.page" /></option>`);/* 복사할 페이지 선택 */
			        			data.returnList.forEach(function(v, i) {
			        				$("#copyReshPage").append(`<option value='\${v.reschPageCd}'>\${v.reschPageTitle}</option>`);
			        			});
			        		}
			            } else {
			             	alert(data.message);
			            }
		    		}, function(xhr, status, error) {
		    			alert("<spring:message code='resh.error.list' />");/* 설문 리스트 조회 중 에러가 발생하였습니다. */
		    		});
					
					$("#reshCopyListDiv").css("display", "block");
					$(".selectBtn").css("display", "inline-block");
					$(".allBtn").css("display", "none");
				} else {
					alert("<spring:message code='resh.alert.copy.resh' />");/* 문항을 복사할 설문을 선택해 주세요. */
				}
			} else if(type == 2) {
				$("select[name=copyResh]").parent().css("pointer-events", "auto");
				$("select[name=copyResh]").dropdown("clear");
				$("#copyReshPage").dropdown("clear");
        		$("#copyReshPage").trigger("change");
				$("#copyReshPage option").remove();
				$("#copyReshQstnList").empty();
				$("#reshCopyListDiv").css("display", "none");
				$(".selectBtn").css("display", "none");
				$(".allBtn").css("display", "inline-block");
			}
		}
		
		// 복사 설문 페이지 선택
		function selectReshPage(obj) {
			if($("select[name=copyReshPage]").val() != "") {
				var reschPageCd = $("select[name=copyReshPage]").val();
				var url  = "/resh/listReshQstn.do";
				var data = {
					"reschPageCd" : reschPageCd
				};
				
				ajaxCall(url, data, function(data) {
					if (data.result > 0) {
		        		var html = ``;
		        		if(data.returnList.length > 0) {
		        			data.returnList.forEach(function(v, i) {
		        				html += `<tr>`;
		        				html += `	<td>`;
		        				html += `		<div class="ui checkbox">`;
		        				html += `			<input type="checkbox" tabindex="0" id="CHK_\${v.reschQstnCd}" name="chk" value="\${v.reschQstnCd}" class="hidden chk" onchange="reschCheck(this)">`;
		        				html += `			<label for="CHK_\${v.reschQstnCd}"></label>`;
		        				html += `		</div>`;
		        				html += `	</td>`;
		        				html += `	<td class="tl">\${v.reschPageOdr}-\${v.reschQstnOdr} \${v.reschQstnTitle}</td>`;
		        				html += `	<td class="tl">\${v.reschQstnCts}</td>`;
		        				html += `</tr>`;
		        			});
		        		}
		        		$("#copyReshQstnList").empty().append(html);
		        		$("#copyReshTable").footable();
		            } else {
		             	alert(data.message);
		            }
	    		}, function(xhr, status, error) {
	    			alert("<spring:message code='resh.error.list' />");/* 설문 리스트 조회 중 에러가 발생하였습니다. */
	    		});
			} else {
				$("#copyReshTable").css("display", "none");
			}
		}
		
		// 가져오기
		function reschQstnCopy(type) {
			var confirm = "";
			if(type == "all") {
				if($("select[name=copyResh]").val() == "") {
					alert("<spring:message code='resh.alert.copy.resh' />");/* 문항을 복사할 설문을 선택해 주세요. */
					return false;
				}
				confirm = window.confirm("<spring:message code='resh.alert.entire.copy' />");/* 전체 가져오기 할 경우 이미 등록되어 있는 페이지 및 문항등이 모두 삭제한 후 가져오기를 합니다. 가져오시겠습니까? */
			}
			if(type == "part" || confirm) {
				var reschCd 	 = "";
				var url 		 = "/resh/copyReshQstn.do";
				var data 		 = "";
				var chkLen 		 = "";
				var copyQstnCnt  = "";
				var reschQstnCds = "";
				if(type == "all") {
					data = {
						"copyReschCd"  : $("select[name=copyResh]").val(),
						"reschCd" 	   : "${vo.reschCd}",
						"entireCopyYn" : "Y"
					};
				} else if(type == "part") {
					chkLen = $(".chk:checked").length;
					if(chkLen == 0) {
						alert("<spring:message code='resh.alert.copy.resh.qstn' />");/* 복사할 문항을 선택해 주세요. */
						return false;
					} else {
						copyQstnCnt = $(".chk:checked").length;
						reschQstnCds = "";
						$(".chk:checked").each(function(i) {
							if(i > 0) {
								reschQstnCds += ",";
							}
							reschQstnCds += this.value;
						});
						
						data = {
							"copyReschQstnCds"  : reschQstnCds,
							"reschCd" 	   		: "${vo.reschCd}",
							"entireCopyYn" 		: "N"
						};
					}
				}
				ajaxCall(url, data, function(data) {
					if (data.result > 0) {
		        		window.parent.listReshPageQstn();
		        		window.parent.closeModal();
		        	} else {
		             	alert(data.message);
		            }
	    		}, function(xhr, status, error) {
	    			alert("<spring:message code='resh.error.qstn.copy' />");/* 설문 문항 가져오기  중 에러가 발생하였습니다. */
	    		});
			}
		}
		
		// 체크 이벤트
		function reschCheck(obj) {
			if(obj.value == "all") {
				$("input[name=chk]").prop("checked", obj.checked);
				if(obj.checked) {
					$("input[name=chk]").closest("tr").addClass("on");
				} else {
					$("input[name=chk]").closest("tr").removeClass("on");
				}
			} else {
				if(obj.checked) {
					$(obj).closest("tr").addClass("on");
				} else {
					$(obj).closest("tr").removeClass("on");
				}
				$("input[name=allCheck]").prop("checked", $("input[name=chk]").length == $("input[name=chk]:checked").length);
			}
		}
	</script>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
        	<div class="option-content">
	            <ul class="tbl-simple">
					<li>
						<dl>
							<dt class="tc">
								<label for="teamLabel"><spring:message code="resh.label.resh.paper" /></label><!-- 설문지 -->
							</dt>
							<dd>
								<select class="ui dropdown wmax" name="copyResh">
									<c:choose>
										<c:when test="${not empty reshList }">
											<option value=""><spring:message code="resh.label.tpl.sel" /></option><!-- 설문 선택 -->
								            <c:forEach var="list" items="${reshList }">
								            	<option value="${list.reschCd }">${list.reschTitle }</option>
								            </c:forEach>
										</c:when>
										<c:otherwise>
											<option value=""><spring:message code="resh.label.sel.copy.resh.none" /></option><!-- 복사할 설문이 없습니다. -->
										</c:otherwise>
									</c:choose>
						        </select>
							</dd>
						</dl>
						<div class="ui info message f080 mt15">
							<i class="info circle icon"></i>
							<spring:message code="resh.alert.select.copy.resh.btn" /><!-- 설문지 선택 후 선택 가져오기 버튼을 눌러주세요. -->
						</div>
					</li>
				</ul>
        	</div>
	        <div class="ui form mt20" style="min-height:100px;">
	        	<div id="reshCopyListDiv" style="display:none;">
		        	<ul class="tbl-simple mb20">
						<li>
							<dl>
								<dt class="tc">
									<label for="teamLabel"><spring:message code="resh.label.page" /></label><!-- 페이지 -->
								</dt>
								<dd>
									<select class="ui dropdown wmax" name="copyReshPage" id="copyReshPage" onchange="selectReshPage()">
										<option value=""><spring:message code="resh.label.sel.copy.resh.page" /></option><!-- 복사할 페이지 선택 -->
							        </select>
								</dd>
							</dl>
						</li>
					</ul>
		        	<table class="table type2" data-sorting="false" data-paging="false" data-empty="<spring:message code='resh.common.empty' />" id="copyReshTable"><!-- 등록된 내용이 없습니다. -->
		        		<colgroup>
		        			<col width="5%">
		        			<col width="30%">
		        			<col width="*">
		        		</colgroup>
		        		<thead>
		        			<tr>
		        				<th scope="col" class="tr">
		        					<div class="ui checkbox">
										<input type="checkbox" name="allCheck" id="copyQstnAllChk" value="all" tabindex="0" class="hidden" onchange="reschCheck(this)">
										<label for="copyQstnAllChk"></label>
									</div>
		        				</th>
		        				<th scope="col"><spring:message code="resh.label.qstn" /></th><!-- 문제 -->
		        				<th scope="col"><spring:message code="resh.label.qstn.item" /></th><!-- 보기 -->
		        			</tr>
		        		</thead>
		        		<tbody id="copyReshQstnList">
		        		</tbody>
		        	</table>
	        	</div>
	        	
	        </div>
            <div class="bottom-content mt50">
                <button class="ui blue button selectBtn" onclick="selectReshCopy(2)" style="display:none;"><spring:message code="resh.button.prev" /></button><!-- 이전 -->
                <button class="ui blue button selectBtn" style="display:none;" onclick="reschQstnCopy('part')"><spring:message code="resh.button.retrieve" /></button><!-- 가져오기 -->
                <button class="ui blue button allBtn" onclick="selectReshCopy(1)"><spring:message code="resh.button.select" /> <spring:message code="resh.button.retrieve" /></button><!-- 선택 --><!-- 가져오기 -->
                <button class="ui blue button allBtn" onclick="reschQstnCopy('all')"><spring:message code="resh.common.search.all" /> <spring:message code="resh.button.retrieve" /></button><!-- 전체 --><!-- 가져오기 -->
                <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="resh.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
