<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
	<head>
    	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
		<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
		<%@ include file="/WEB-INF/jsp/exam/common/exam_common_inc.jsp" %>
    	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
    </head>
    
    <div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	
	<script type="text/javascript">
		$(document).ready(function() {
			targetList();
			
			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					targetList();
				}
			});
		});
		
		// 대상자 목록
		function targetList() {
			var url  = "/exam/listInsTraget.do";
			var data = {
				"examCd"     : "${vo.examCd}",
				"crsCreCd"   : "${creCrsVO.crsCreCd}",
				"searchType" : "unsubmit"
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					var returnList = data.returnList || [];
					var html = "";
					
					if(returnList.length > 0 && "${vo.examEndDttm}" < "${today}") {
						returnList.forEach(function(v, i) {
							var absentNm = v.absentNm;
							if(v.absentNm == "APPROVE") absentNm = "<spring:message code='exam.label.approve' />";/* 승인 */
							if(v.absentNm == "APPLICATE") absentNm = "<spring:message code='exam.label.applicate' />";/* 신청 */
							if(v.absentNm == "RAPPLICATE") absentNm = "<spring:message code='exam.label.rapplicate' />";/* 재신청 */
							if(v.absentNm == "COMPANION") absentNm = "<spring:message code='exam.label.companion' />";/* 반려 */
							html += "<tr>";
							html += "	<td class='tc'>";
							html += "		<div class='ui checkbox'>";
							html += "			<input type='checkbox' name='evalChk' id='evalChk"+i+"' data-stdNo='"+v.stdNo+"' onchange='checkStdNoToggle(this)'>";
							html += "			<label class='toggle_btn' for='evalChk"+i+"'></label>";
							html += "		</div>";
							html += "		"+v.lineNo;
							html += "	</td>";
							html += "	<td>"+v.deptNm+"</td>";
							html += "	<td>"+v.userId+"</td>";
							html += "	<td>"+v.userNm+"</td>";
							html += "	<td>"+v.stareYn+"</td>";
							html += "	<td>"+v.absentYn+"</td>";
							html += "	<td>"+absentNm+"</td>";
							html += "</tr>";
						});
					}
					
					$("#targetList").empty().html(html);
					$("#targetTable").footable();
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='exam.error.score.open' />");/* 성적 공개 변경 중 에러가 발생하였습니다. */
			});
		}
		
		// 대상자 설정
		function insTargetSet() {
			if(!("${vo.examEndDttm}" < "${today}")) {
				alert("<spring:message code='exam.alert.not.stare.link' />");/* 시험결과 연동 전입니다. */
				return false;
			}
			
			if($("input[name=evalChk]:checked").length == 0) {
				alert("<spring:message code='exam.alert.select.std' />");/* 학습자를 선택하세요. */
				return false;
			}
			
			var stdNos = "";
			$("input[name=evalChk]:checked").each(function(i, v) {
				if(i > 0) stdNos += ",";
				stdNos += $(v).attr("data-stdNo");
			});
			
			var url  = "/exam/insTargetSet.do";
			var data = {
				"examCd" : "${vo.examCd}",
				"stdNos" : stdNos
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					alert("<spring:message code='exam.alert.setting' />");/* 설정이 완료되었습니다. */
					targetList();
					window.parent.insStdList();
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='exam.error.setting' />");/* 설정 중 에러가 발생하였습니다. */
			});
		}
		
		// 체크 이벤트
		function checkStdNoToggle(obj) {
			if(obj.value == "all") {
				$("input[name=evalChk]").prop("checked", obj.checked);
			} else {
				let totalCnt = $("input[name=evalChk]").length;
				let checkCnt = $("input[name=evalChk]:checked").length;
				$("#allChk").prop("checked", totalCnt == checkCnt);
			}
		}
	</script>

	<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
        <div id="wrap">
        	<div class="header2">
        		<h3>[ ${creCrsVO.creYear }<spring:message code="exam.label.year" /><!-- 년 --> ${creCrsVO.creTermNm } ${vo.examStareTypeNm } ]</h3>
        	</div>
        	<div class="option-content mt20 mb20">
        		<div class="ui action input search-box">
				    <input type="text" placeholder="<spring:message code='exam.label.dept' />, <spring:message code='exam.label.user.no' />, <spring:message code='exam.label.user.nm' /> <spring:message code='exam.label.input' />" class="w250" id="searchValue"><!-- 학과 --><!-- 학번 --><!-- 이름 --><!-- 입력 -->
				    <button class="ui icon button" onclick="targetList()"><i class="search icon"></i></button>
				</div>
				<div class="mla">
					<button type="button" class="ui orange button small" onclick="insTargetSet()"><spring:message code="exam.label.ins.target.set.ifm" /><!-- 대체평가 대상자 설정 --></button>
				</div>
        	</div>
        	<table class="table type2" id="targetTable" data-sorting="false" data-paging="false" data-empty="<spring:message code='exam.alert.not.stare.link' />"><!-- 시험결과 연동 전입니다. -->
        		<thead>
        			<tr>
        				<th scope="col" class="tc num">
							<div class="ui checkbox">
						        <input type="checkbox" name="allEvalChk" id="allChk" value="all" onchange="checkStdNoToggle(this)">
						        <label class="toggle_btn" for="allChk"></label>
						    </div>
							No
						</th>
						<th><spring:message code="exam.label.dept" /><!-- 학과 --></th>
				        <th><spring:message code="exam.label.user.no" /><!-- 학번 --></th>
				        <th><spring:message code="exam.label.user.nm" /><!-- 이름 --></th>
				        <th><spring:message code="exam.label.exam" /><!-- 시험 --><spring:message code="exam.label.yes.stare" /><!-- 응시 --></th>
				        <th><spring:message code="exam.label.absent" /><!-- 결시원 --><spring:message code="exam.label.submit.y" /><!-- 제출 --></th>
				        <th><spring:message code="exam.label.absent" /><!-- 결시원 --><spring:message code="exam.label.approve" /><!-- 승인 --></th>
        			</tr>
        		</thead>
        		<tbody id="targetList">
        		</tbody>
        	</table>
            
            <div class="bottom-content">
                <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="exam.button.close" /></button><!-- 닫기 -->
            </div>
        </div>
		<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
	</body>
</html>
