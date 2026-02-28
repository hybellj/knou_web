<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
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

    <script type="text/javascript">
	    $(function() {
	    	onObjtTchList();
	    	
	    	$("#btnObjtTch").on("click", function(){
	    		onObjtTchSave();
	    	});
	    	
	    	$("#searchValue").on("keydown", function(e) {
				if(e.keyCode == 13) {
					onObjtTchList();
				}
			});
	    	
	    	changeCourse();
	    });
	    
	    // 과목변경
	    function changeCourse() {
	    	onObjtTchList();
	    }
	    
	    function onObjtTchList() {
	    	var url = "/score/scoreOverall/selectScoreObjtRegList.do";
	    	var data = {
	    		crsCreCd : $("#crsCreCd").val(),
	    		searchValue: $("#searchValue").val(),
	    	};
	    	
	    	ajaxCall(url, data, function(data) {
	    		if(data.result > 0) {
	    			var returnList = data.returnList || [];
	    			
	    			var html = "";
		    		var totCnt = returnList.length;
		    	
		    		$("#objtTchTotCnt").text(totCnt);
			        
		    		$.each(returnList, function(i, o){
		    			if(i == 0) {
		    				$("#crsCdText").text(o.crsCd);
		    				$("#declsNoText").text(o.declsNo);
		    				$("#compDvNmText").text(o.compDvNm);
		    			}
		    			
		    			html += "<tr>";
		    			html += "    <td>";
		    			html += '    	<div class="ui checkbox">';
		    			html += '    		<input type="checkbox" name="objtTchChk" data-objt-user-no="' + o.userId + '" />';
		    			html += '    	</div>';
		    			html += "	</td>";
		    			//html += "    <td data-sort-value='" + o.lineNo + "'>" + o.lineNo + "</td>";
		                html += "    <td data-sort-value='" + o.deptNm + "'>" + o.deptNm + "</td>";
		                html += "    <td data-sort-value='" + o.userId + "'>" + o.userId + "</td>";
		                html += "    <td data-sort-value='" + o.userNm + "'>" + o.userNm + "</td>";
		                html += "    <td data-sort-value='" + o.compDvNm + "'>" + o.compDvNm + "</td>";
		                html += "    <td data-sort-value='" + o.totScore + "'>" + o.totScore + "</td>";
		                html += "    <td data-sort-value='" + o.scoreGrade + "'>" + (o.scoreGrade || '-') + "</td>";
		                html += "</tr>";
		    		});
		    		
		    		$("#objtTchList").empty().html(html);
		    		$("#objtTchTable").footable({
						"breakpoints": {
					        "xs": 375,
					        "sm": 560,
					        "md": 768,
					        "lg": 1024,
					        "w_lg": 1200
				        }
					});
		    		
		    		$("#objtTchTable").find(".ui.checkbox").checkbox();
		    		
		    		$("input[name='objtTchChk'").on("change", function() {
		    			if(this.checked) {
		    				var _that = this;
		    				$.each($("input[name='objtTchChk'"), function() {
		    					if(_that != this) {
		    						this.checked = false;
		    					}
		            		});
		    			}
		    		});
	    		} else {
	    			alert(data.message);
	    		}
	    	}, function(xhr, status, error) {
	    		/* 목록 조회에 실패하였습니다. <br />다시 시도해주시기 바랍니다. */
	    		alert('<spring:message code="score.label.lect.eval.oper.msg3" />');
	    	});
	    }
	    
	    function onObjtTchSave() {
	    	if(!$("#crsCreCd").val()) {
	    		alert('<spring:message code="crs.common.selectbox.default" />'); // 강의실을 선택하세요.
	    		return;
	    	}
	    	
	    	var crsCreCd = $("#crsCreCd").val();
	    	var uniCd = $("#crsCreCd option:selected").data("uniCd");
	    	var calendarCtgr = "";
	    	
	    	if(uniCd == "G") {
	    		if(${fn:contains(menuType, 'PROFESSOR')}) {
					calendarCtgr = "00210205"; // 대학원
	    		} else {
					calendarCtgr = "00210204"; // 대학원
	    		}
			} else {
				if(${fn:contains(menuType, 'PROFESSOR')}) {
					calendarCtgr = "00210203"; // 학부
				} else {
					calendarCtgr = "00210202"; // 학부
				}
			}
	    	
			if(${fn:contains(authGrpCd, 'TUT')}) {
				/* 조교는 처리할  수 없습니다. */
				alert('<spring:message code="score.label.ect.eval.oper.msg13" />');
				return false;
			} else {
				if($("#objtTchTable").find('input[name=objtTchChk]:checked').length == 0){
		    		
		    		/* "수강생 목록을 선택하세요." */
		    		alert('<spring:message code="score.label.lect.eval.oper.msg4" />');
		    		return;
		    	}
		    	
		    	var userId;
		    	$.each($("#objtTchTable").find('input[name=objtTchChk]:checked'), function() {
		    		userId = $(this).data("objtUserId");
		    	});
		
				if(!userId) {
		    		/* "수강생 목록을 선택하세요." */
		    		alert('<spring:message code="score.label.lect.eval.oper.msg4" />');
		    		return;
		    	}
		    	
		    	var url = "/score/scoreOverall/insertStdScoreObjtTch.do";
				var data = {
					objtCtnt	: $("#objtTchCtnt").val(),
					objtUserId	: userId,
					crsCreCd	: $("#crsCreCd").val(),
				};
				 
				ajaxCall(url, data, function(data) {
					 if(data.result > 0) {
						// 성적 재확인 신청 성공 하였습니다.
						alert('<spring:message code="score.label.ect.eval.oper.msg7_1" />');
						 
						if(typeof window.parent.objtProcPopCallBack === "function") {
							window.parent.objtProcPopCallBack();
						} else {
							window.parent.onObjtSearch();
						}
						
						window.parent.closeModal();
					} else {
						alert(data.message);
					}
				}, function(xhr, status, error) {
					 // 성적 재확인 신청 실패하였습니다.
				 	 alert('<spring:message code="score.label.ect.eval.oper.msg7_2" />');
				}, true);
			}
	    }
	    
	    // 엑셀다운
	    function downExcel() {
	    	if(!$("#crsCreCd").val()) {
	    		alert('<spring:message code="crs.common.selectbox.default" />'); // 강의실을 선택하세요.
	    		return;
	    	}
	    	
	    	var excelGrid = {
    		    colModel:[
    		    	{label:'No', 											name:'lineNo', 		align:'left', 	width:'1000'}, // 학과
    		    	{label:'<spring:message code="common.dept_name"/>', 	name:'deptNm', 		align:'left', 	width:'7000'}, // 학과
    	            {label:'<spring:message code="forum.label.user.no" />', name:'userId', 		align:'left', 	width:'5000'}, // 학번
    	            {label:'<spring:message code="forum.label.user_nm" />', name:'userNm', 		align:'left', 	width:'5000'}, // 이름
    	            {label:'<spring:message code="std.label.comp_div" />', 	name:'compDvNm', 	align:'left', 	width:'5000'}, // 이수구분
    	            {label:'<spring:message code="asmnt.label.score" />', 	name:'totScore', 	align:'right', 	width:'2500'}, // 점수
    	            {label:'<spring:message code="asmnt.label.grade" />', 	name:'scoreGrade', 	align:'left', 	width:'5000'}, // 등급
                ]
    		};
	    	
    		var url  = "/score/scoreOverall/downExcelScoreObjtRegList.do";
    		var form = $("<form></form>");
    		form.attr("method", "POST");
    		form.attr("name", "excelForm");
    		form.attr("action", url);
    		
    		form.append($('<input/>', {type: 'hidden', name: 'crsCreCd',	value: $("#crsCreCd").val()}));
    		form.append($('<input/>', {type: 'hidden', name: 'searchValue', value: $("#searchValue").val()}));
    		form.append($('<input/>', {type: 'hidden', name: 'excelGrid',   value: JSON.stringify(excelGrid)}));
    		form.appendTo("body");
    		form.submit();
    		
    		$("form[name=excelForm]").remove();
	    }
    </script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	<input type="hidden" id="objtTchUserId">
	<div id="wrap">
        <div class="ui form">
            <ul class="tbl dt-sm">
                <li>
                    <dl>
                        <dt><spring:message code="contents.label.crscd" /></dt><!-- 학수번호 -->
                        <dd id="crsCdText">-</dd>
                        <dt><spring:message code="contents.label.decls" /></dt><!-- 분반 -->
                        <dd id="declsNoText">-</dd>
                    </dl>
                </li>
                <li>
                    <dl>
                        <dt><spring:message code="contents.label.crscrenm" /></dt><!-- 과목명 -->
                        <dd>
                        	<select class="ui dropdown mr5 fluid" id="crsCreCd" onchange="changeCourse()">
	                        	<option value=""><spring:message code="common.select" /><!-- 선택 --></option>
								<c:forEach var="item" items="${crsCreList}">
									<option value="${item.crsCreCd}" ${item.crsCreCd eq vo.crsCreCd ? 'selected' : ''} data-uni-cd="<c:out value="${item.uniCd}" />"><c:out value="${item.crsCreNm}" />(<c:out value="${item.declsNo}" />)</option>
								</c:forEach>
							</select>
                        </dd>
                        <dt><spring:message code="crs.label.compdv" /></dt><!-- 이수구분 -->
                        <dd id="compDvNmText">-</dd>
                    </dl>
                </li>
            </ul>

            <div class="option-content mt15 mb10 gap4">
                <div class="mra">
                    <b class="sec_head"><spring:message code="button.list.student" /></b><!-- 수강생 목록 -->
                    <small>[ <spring:message code="common.page.total" /><span id="objtTchTotCnt"></span><spring:message code="common.page.total_count" />  ]</small> <!-- 총 건 -->
       	            <div class="ui action input search-box ml10">
                         <input id="searchValue" type="text" placeholder="<spring:message code="user.message.search.input.userinfo.no.dept.nm" />" value=""><!-- 학과/학번/성명 입력 -->
                         <button class="ui icon button" type="button" onclick="onObjtTchList()">
                             <i class="search icon"></i>
                         </button>
                    </div>
                </div>
                <div class="button-area">
                    <a href="javascript:downExcel()" class="ui basic button"><spring:message code="user.title.download.excel" /></a><!-- 엑셀 다운로드 -->
                </div>
            </div>
            <div class="scrollbox max-height-350">
                <table id="objtTchTable" class="table select-list radiobox" data-sorting="true" data-paging="false" data-empty="<spring:message code="filebox.common.empty" />">
                    <thead>
                        <tr>
                        	<th scope="col" data-sortable="false" class="chk"></th>
                            <%-- <th scope="col" data-type="" class="num"><spring:message code="common.number.no"/></th><!-- No --> --%>
                            <th scope="col"><spring:message code="common.dept_name" /></th><!-- 학과 -->
                            <th scope="col" data-breakpoints="xs sm"><spring:message code="forum.label.user.no" /></th><!-- 학번 -->
                            <th scope="col"><spring:message code="forum.label.user_nm" /></th><!-- 이름 -->
                            <th scope="col" data-breakpoints="xs sm "><spring:message code="std.label.comp_div" /></th><!-- 이수구분 -->
                            <th scope="col" data-breakpoints="xs sm "><spring:message code="asmnt.label.score" /></th><!-- 점수 -->
                            <th scope="col" data-breakpoints="xs sm "><spring:message code="asmnt.label.grade" /></th><!-- 등급 -->
                        </tr>
                    </thead>
                    <tbody id="objtTchList">
                    </tbody>
                </table>
            </div>
            <div class="option-content">
                <b class="sec_head"><spring:message code="score.label.request.reason" /></b><!-- 신청사유 -->
            </div>  
            <textarea rows="5" placeholder="<spring:message code="score.label.ect.eval.oper.msg6" />" id="objtTchCtnt"></textarea><!-- 신청사유 입력하세요 -->
        </div>
	    <div class="bottom-content">
	        <button class="ui blue button" id="btnObjtTch"><spring:message code="seminar.button.write" /></button><!-- 저장 -->
	        <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="seminar.button.close" /></button><!-- 닫기 -->
	    </div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>