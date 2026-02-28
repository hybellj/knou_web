<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">

$(function(){
});

//과정유형 선택
function selectContentCrsType(obj) {
	if($(obj).hasClass("basic")){
		$(obj).removeClass("basic").addClass("active");
	} else {
		$(obj).removeClass("active").addClass("basic");
	}
	onSearch();
}

// 사용자 검색
function selectUserList() {
	$("#modalForm [name=subParam]").val("searchForm");
	$("#modalForm").attr("target", "modalIfm");
    $("#modalForm").attr("action", "/user/userMgr/studentSearchListPop.do");
    $("#modalForm").submit();
    $("#modalPop").modal('show');
}

function onSearchDtl(){
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

	var param = {
			crsTypeCd    : crsTypeCd
		  , curYear      : $("#curYear").val()
		  , curTerm	     : $("#curTerm").val()
		  , uniGbn       : $("#uniGbn").val()
		  , uniCd		 : $("#uniGbn").val() == "U" ? "C" : $("#uniGbn").val() 
		  , deptCd       : $("#deptCd").val()
		  , userId       : $("#searchUserId").val()
	}

	ajaxCall("/score/scoreOverall/selectOverallStdInfoAdmin.do", param, function(data) {

		$.each($("#stdInfo dd"), function(i){
			$("#stdInfo dd").eq(i).text("");
		});

		if(data.returnVO != null){
			std = data.returnVO;

			if(nullChk(std.PhtFile) == ""){
				$("#stdImg").prop("src",std.PhtFile);
			}else{
				$("#stdImg").prop("src","/webdoc/img/hycu-symbol.svg");
			}

			$("#stdInfo dd").eq(0).text(nullChk(std.userId));
			$("#stdInfo dd").eq(1).text(nullChk(std.uniCd) == "C" ? "<spring:message code='common.label.uni.c' />" : "<spring:message code='common.label.uni.g' />");/* 대학 *//* 대학원 */
			$("#stdInfo dd").eq(3).text(nullChk(std.userNm));
			$("#stdInfo dd").eq(5).text(nullChk(std.schregGbn));
			$("#stdInfo dd").eq(6).text(nullChk(std.userNmEng));
			$("#stdInfo dd").eq(8).text(nullChk(std.hy)+"<spring:message code='common.label.userdept.grade' />");/* 학년 */

			$("#stdInfo dd").eq(10).text(nullChk(std.deptNm));
			$("#stdInfo dd").eq(11).text(nullChk(std.entrYy));
			$("#stdInfo dd").eq(14).text(nullChk(std.entrGbnNm)+" "+nullChk(std.entrHy)+"<spring:message code='common.label.userdept.grade' />");/* 학년 */
			$("#stdInfo dd").eq(16).text(nullChk(std.readmiYy));
		}

		if(data.returnList != null){
			var html = "";
			$.each(data.returnList, function(i, o){
				html += "<tr>";
	            html += "    <td class='tc footable-first-visible' style='display: table-cell;'>" + o.lineNo + "</td>";
	            html += "    <td class='tc' style='display: table-cell;'>" + o.crsCd + "</td>";
	            html += "    <td class='tc' style='display: table-cell;'>" + o.declsNo + "</td>";
	            html += "    <td class='tc' style='display: table-cell;'>" + o.crsCreNm + "</td>";
	            html += "    <td class='tc' style='display: table-cell;'>" + o.compDvNm + "</td>";
	            html += "    <td class='tc' style='display: table-cell;'>" + o.credit + "</td>";
	            html += "    <td class='tc' style='display: table-cell;'>" + o.repUserNm + "</td>";
	            html += "    <td class='tc' style='display: table-cell;'>" + o.scoreGrade + "</td>";
	            html += "    <td class='tc' style='display: table-cell;'>" + o.mrks + "</td>";
	            html += "    <td class='tc' style='display: table-cell;'>" + o.totScore + "</td>";
	            html += "    <td class='tc' style='display: table-cell;'>" + o.creYear + "</td>";
	            html += "    <td class='tc' style='display: table-cell;'>" + o.creTerm + "</td>";
	            html += "    <td class='tc footable-last-visible' style='display: table-cell;'>" + o.repeatCrsCd + "</td>";
	            html += "</tr>";
			});
			$("#lTbody1").empty().html(html);
		}
		$("#crsCreCnt").text(data.returnList.length > 0 ? data.returnList.length : 0);

	}, function(xhr, status, error) {
		/* 에러가 발생했습니다! */
		alert('<spring:message code="fail.common.msg" />');
	}, true);
}

function nullChk(val){
	if(val != null && val != "" ){
		return val;
	}else{
		return "";
	}
}

// 엑셀 다운로드
function excelDown() {
	var excelGrid = {
		colModel:[
			{label:'<spring:message code="user.title.line.no"/>', 				name:'lineNo', 		align:'right', 	width:'2000'},	// 순번
			{label:'<spring:message code="score.label.crs.cd" />', 				name:'crsCd', 		align:'left', 	width:'5000'},	// 학수번호
			{label:'<spring:message code="common.label.decls.no" />', 			name:'declsNo', 	align:'left', 	width:'2000'},	// 분반
			{label:'<spring:message code="contents.label.crscrenm" />', 		name:'crsCreNm', 	align:'left', 	width:'7000'},	// 과목명
			{label:'<spring:message code="crs.label.compdv" />', 				name:'compDvNm', 	align:'left', 	width:'3000'},	// 이수구분
			{label:'<spring:message code="crs.label.credit" />', 				name:'credit', 		align:'left', 	width:'2000'},	// 학점
			{label:'<spring:message code="dashboard.prof" />', 					name:'repUserNm', 	align:'center', width:'4000'},	// 담당교수
			{label:'<spring:message code="exam.label.level" />', 				name:'scoreGrade', 	align:'center', width:'2000'},	// 등급
			{label:'<spring:message code="socre.grade.point.average.label" />', name:'mrks', 		align:'left',	width:'2000'},	// 평점
			{label:'<spring:message code="score.label.percent.score" />', 		name:'totScore', 	align:'left',	width:'4000'},	// 백분위 점수 
			{label:'<spring:message code="common.haksa.year" />', 				name:'creYear', 	align:'center', width:'3000'},	// 학년도
			{label:'<spring:message code="common.term" />', 					name:'creTerm', 	align:'left',	width:'3000'},	// 학기
			{label:'<spring:message code="crs.label.crs.cd" />', 				name:'repeatCrsCd', align:'center', width:'4000'},	// 학수번호
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
	
	$("form[name='excelForm']").remove();
	var excelForm = $('<form></form>');
	excelForm.attr("name","excelForm");
	excelForm.attr("action","/score/scoreOverall/beforeScoreExcelDown.do");
	excelForm.append($('<input/>', {type: 'hidden', name: 'curYear', 		value: $("#curYear").val()}));
	excelForm.append($('<input/>', {type: 'hidden', name: 'curTerm', 		value: $("#curTerm").val()}));
	excelForm.append($('<input/>', {type: 'hidden', name: 'uniCd', 			value: $("#uniGbn").val() == "U" ? "C" : $("#uniGbn").val() }));
	excelForm.append($('<input/>', {type: 'hidden', name: 'crsTypeCd', 		value: crsTypeCd}));
	excelForm.append($('<input/>', {type: 'hidden', name: 'deptCd', 		value: $("#deptCd").val()}));
	excelForm.append($('<input/>', {type: 'hidden', name: 'userId', 		value: $("#searchUserId").val()}));
	excelForm.append($('<input/>', {type: 'hidden', name: 'excelGrid', 		value:JSON.stringify(excelGrid)}));
	excelForm.appendTo('body');
	excelForm.submit();
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
	                    <h2 class="page-title">
	                    	<spring:message code="common.label.mut.eval.score" /> > <spring:message code="score.label.before.check" />
	                    </h2><!-- 성적평가관리 > 확정 전 성적조회 -->
	                </div>

	                <div class="ui segment searchArea">
	                	<form id="searchForm">

							<div class="fields">
								<div class="ui buttons">
					            	<button class="ui blue button active crsTypeBtn" data-crs-type-cd="UNI" onclick="selectContentCrsType(this)"><spring:message code="crs.label.crs.uni" /><!-- 학기제 --></button>
					            	<button class="ui basic blue button crsTypeBtn" data-crs-type-cd="CO" onclick="selectContentCrsType(this)"><spring:message code="crs.label.crs.co" /><!-- 기수제 --></button>
					            	<button class="ui basic blue button crsTypeBtn" data-crs-type-cd="LEGAL" onclick="selectContentCrsType(this)"><spring:message code="crs.label.crs.court" /><!-- 법정교육 --></button>
					            	<button class="ui basic blue button crsTypeBtn" data-crs-type-cd="OPEN" onclick="selectContentCrsType(this)"><spring:message code="crs.label.crs.open" /><!-- 공개강좌 --></button>
				                </div>
							</div>
							<div class="option-content">
								<select class="ui dropdown mr5" id="curYear" name="curYear" >
				                    <c:forEach var="yearList" items="${yearList}" varStatus="status">
								    	<option value="${yearList}" <c:if test="${yearList eq termVO.haksaYear}">selected</c:if>>${yearList}</option>
							        </c:forEach>
				                </select>
				                <select class="ui dropdown mr5" id="curTerm" name="curTerm" >
									<c:forEach var="termList" items="${termList}" varStatus="status">
								    	<option value="${termList.codeCd}" <c:if test="${termList.codeCd eq termVO.haksaTerm}">selected</c:if>>${termList.codeNm}</option>
							        </c:forEach>
				                </select>
				                <select class="ui dropdown mr20" id="uniGbn" name="uniGbn">
				                	<option value="all"><spring:message code="score.label.uni.cd" /></option><!-- 대학구분 -->
				                	<option value="U"><spring:message code="score.label.univ" /></option><!-- 학부 -->
				                	<option value="G"><spring:message code="score.label.grad" /></option><!-- 대학원 -->
				                </select>
				                <div class="flex align-items-center gap4 ml50">
				                	<span>학번/성명</span>
									<input type="text" id="searchUserId" name="userId" placeholder="<spring:message code='exam.label.user.no' />" readonly="readonly" class="mr5 w200 bcLGrey" /><!-- 학번 -->
								    <input type="text" id="searchUserNm" name="userNm" placeholder="<spring:message code='exam.label.user.nm' />" readonly="readonly" class="mr5 w200 bcLGrey" /><!-- 이름 -->
			                        <button type="button" class="ui icon button" onclick="selectUserList();"><i class="search icon"></i></button>
				                </div>
							</div>
							<div class="button-area mt10 tc">
								<!-- <button class="ui blue button" >검색</button> -->
								<button type="button" class="ui blue button w100" onclick="onSearchDtl();"><spring:message code="sys.button.search" /></button><!-- 검색 -->
							</div>
						</form>
					</div>
					<div class="ui segment">
						<h3 class="sec_head mb10"><spring:message code="std.label.student.basic.info" /><!-- 학생 기본 정보 --></h3>
						<div class="ui form userInfoManage type2">
                            <div class="userImg">
                                <div class="image">
                                    <img class="" src="/webdoc/img/hycu-symbol.svg" id ="stdImg" alt="<spring:message code="forum.common.user.img" />">
                                 </div>
                            </div>
                            <ul class="tbl dt-sm" id="stdInfo">
                                <li>
                                    <dl>
                                        <dt><spring:message code="team.popup.userId" /></dt>
                                        <dd></dd><!-- 학번 -->
                                        <dt><spring:message code="user.title.org.info" /></dt>
                                        <dd></dd><!-- 대학구분 -->
                                        <dt><spring:message code="user.title.userinfo.std.type" /> / <spring:message code="score.label.learner.detail" /></dt>
                                        <dd></dd><!-- 학생구분 / 세부 -->
                                    </dl>
                                </li>
                                <li>
                                    <dl>
                                        <dt><spring:message code="score.label.Korean" /></dt>
                                        <dd></dd><!-- 국문 -->
                                        <dt><spring:message code="score.label.alignment" /> / <spring:message code="bbs.label.uni.graduate" /></dt>
                                        <dd></dd><!-- 계열 / 대학원 -->
                                        <dt><spring:message code="user.title.userinfo.user.stats" /></dt>
                                        <dd></dd><!-- 학적상태 -->
                                    </dl>
                                </li>
                                <li>
                                    <dl>
                                        <dt><spring:message code="score.label.english" /></dt>
                                        <dd></dd><!-- 영문 -->
                                        <dt><spring:message code="bbs.label.uni.college" /> / <spring:message code="score.label.major" /></dt>
                                        <dd></dd><!-- 학부 / 전공 -->
                                        <dt><spring:message code="common.label.userdept.grade" /> / <spring:message code="score.label.term.completed" /></dt>
                                        <dd></dd><!-- 학년 / 이수학기수 -->
                                    </dl>
                                </li>
                                <li>
                                    <dl>
                                        <dt><spring:message code="user.title.userinfo.birth.day" /></dt>
                                        <dd></dd><!-- 생년월일 -->
                                        <dt><spring:message code="exam.label.dept" /> / <spring:message code="score.label.major" /></dt>
                                        <dd></dd><!-- 학과 / 전공 -->
                                        <dt><spring:message code="team.popup.admission.year" /> / <spring:message code="sys.label.haksa.term" /></dt>
                                        <dd></dd><!-- 입학년도 / 학기 -->
                                    </dl>
                                </li>
                                <li>
                                    <dl>
                                        <dt><spring:message code="user.title.userinfo.sex" /></dt>
                                        <dd></dd><!-- 성별 -->
                                        <dt><spring:message code="score.label.double.major" /></dt>
                                        <dd></dd><!-- 부복수전공 -->
                                        <dt><spring:message code="exam.label.admission.grade" /></dt>
                                        <dd></dd><!-- 입학학년 -->
                                    </dl>
                                </li>
                                <li>
                                    <dl>
                                        <dt><spring:message code="user.title.userinfo.nationalit" /></dt>
                                        <dd></dd><!-- 국적 -->
                                        <dt><spring:message code="std.label.readmi.year" />/<spring:message code="sys.label.haksa.term" /></dt>
                                        <dd></dd><!-- 재입학년도 / 학기 -->
                                        <dt><spring:message code="score.label.admission.date" /></dt>
                                        <dd></dd><!-- 입학일자 -->
                                    </dl>
                                </li>
                            </ul>
                        </div>
					</div>
					<div class="ui segment">
						<div class="option-content">
							<h3 class="sec_head"><spring:message code="score.label.before.confirm" /><!-- 확정 전 성적 --></h3>
							<p class="ml10">[ <spring:message code="common.page.total" /><!-- 총 --> <span class="fcBlue" id="crsCreCnt">0</span><spring:message code="common.page.total_count" /><!-- 건 --> ]</p>
							<button type="button" class="ui blue small button mla" onclick="excelDown()"><spring:message code="common.button.excel_down" /><!-- 엑셀 다운로드 --></button>
						</div>
						<table id="lTable1" class="table footable type2" data-sorting="false" data-paging="false" data-empty="<spring:message code='common.nodata.msg' />"><!-- 등록된 내용이 없습니다. -->
						   	<thead>
						   		<tr class="footable-header">
						   			<th class='tc' rowspan="2"><spring:message code="user.title.line.no" /></th><!-- 순번 -->
						   			<th class='tc' rowspan="2"><spring:message code="score.label.crs.cd" /></th><!-- 학수번호 -->
						   			<th class='tc' rowspan="2"><spring:message code="common.label.decls.no" /></th><!-- 분반 -->
						   			<th class='tc' rowspan="2"><spring:message code="contents.label.crscrenm" /></th><!-- 과목명 -->
						   			<th class='tc' rowspan="2"><spring:message code="crs.label.compdv" /></th><!-- 이수구분 -->
						   			<th class='tc' rowspan="2"><spring:message code="crs.label.credit" /></th><!-- 학점 -->
						   			<th class='tc' rowspan="2"><spring:message code="dashboard.prof" /></th><!-- 담당교수 -->
						   			<th class='tc' rowspan="2"><spring:message code="exam.label.level" /></th><!-- 등급 -->
						   			<th class='tc' rowspan="2"><spring:message code="socre.grade.point.average.label" /></th><!-- 평점 -->
						   			<th class='tc' rowspan="2"><spring:message code="score.label.percent.score" /></th><!-- 백분위 점수 -->
						   			<th class='tc' colspan="3"><spring:message code="crs.label.repeat" /></th><!-- 재수강 -->
						   		</tr>
						   		<tr class="footable-header">
						   			<th class='tc'><spring:message code="common.haksa.year" /></th><!-- 학년도 -->
						   			<th class='tc'><spring:message code="common.term" /></th><!-- 학기 -->
						   			<th class='tc'><spring:message code="crs.label.crs.cd" /></th><!-- 학수번호 -->
						   		</tr>
						   	</thead>
						   	<tbody id="lTbody1"></tbody>
					    </table>
					</div>
		   		</div>
			</div>
		<%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>

	    <form class="ui form" id="modalForm" name="modalForm" method="POST" action="">
	    	<input type="hidden" name="subParam"/>
		    <div class="modal fade" id="modalPop" tabindex="-1" role="dialog" aria-labelledby="모달영역" aria-hidden="false">
		        <div class="modal-dialog modal-lg" role="document">
		            <div class="modal-content">
		                <div class="modal-header">
		                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="sys.button.close" />">
		                        <span aria-hidden="true">&times;</span>
		                    </button>
		                    <h4 class="modal-title"><spring:message code="seminar.label.stu" /><spring:message code="sys.button.search" /><!-- 학생 검색 --></h4>
		                </div>
		                <div class="modal-body">
		                    <iframe src="" id="modalIfm" name="modalIfm" width="100%" scrolling="no"></iframe>
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
