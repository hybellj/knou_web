<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<head>
	<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	
	<script type="text/javascript">
		var USER_DEPT_LIST = [];
		var CRS_CRE_LIST   = [];
		$(function(){
			// 부서정보
			<c:forEach var="item" items="${deptList}">
				USER_DEPT_LIST.push({
					  deptCd: '<c:out value="${item.deptCd}" />'
					, deptNm: '<c:out value="${item.deptNm}" />'
					, deptCdOdr: '<c:out value="${item.deptCdOdr}" />'
				});
			</c:forEach>
			
			// 부서명 정렬
			USER_DEPT_LIST.sort(function(a, b) {
				if(a.deptCdOdr < b.deptCdOdr) return -1;
				if(a.deptCdOdr > b.deptCdOdr) return 1;
				if(a.deptCdOdr == b.deptCdOdr) {
					if(a.deptNm < b.deptNm) return -1;
					if(a.deptNm > b.deptNm) return 1;
				}
				return 0;
			});
			
			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					onSearch(1);
				}
			});
		
			$("#declsNo").on("keyup", function(e) {
				if(e.keyCode == 13) {
					onSearch(1);
				}
			});
			//onSearch();
			changeTerm();
		});
		
		//학기 변경
		function changeTerm() {
			// 학기 과목정보 조회
			var url = "/crs/creCrsHome/listCrsCreDropdown.do";
			var data = {
				  creYear	: $("#creYear").val()
				, creTerm	: $("#creTerm").val()
				, crsTypeCd : "UNI"
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					
					this["CRS_CRE_LIST"] = returnList.filter(function(v) {
						if((v.crsCd || "").indexOf("JLPT") > -1) {
							return false;
						}
						return true;
					}).sort(function(a, b) {
						if(a.crsCreNm < b.crsCreNm) return -1;
						if(a.crsCreNm > b.crsCreNm) return 1;
						if(a.crsCreNm == b.crsCreNm) {
							if(a.declsNo < b.declsNo) return -1;
							if(a.declsNo > b.declsNo) return 1;
						}
						return 0;
					});
					
					// 대학 구분 변경
					changeUnivGbn("ALL");
					
					$("#univGbn").on("change", function() {
						changeUnivGbn(this.value);
					});
		    	} else {
		    		alert(data.message);
		    	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		}
		
		// 대학구분 변경
		function changeUnivGbn(univGbn) {
			var deptCdObj = {};
			
			this["CRS_CRE_LIST"].forEach(function(v, i) {
				if((univGbn == "ALL" || v.univGbn == univGbn) && v.deptCd) {
					deptCdObj[v.deptCd] = true;
				}
			});
			
			var html = '<option value="ALL"><spring:message code="user.title.userdept.select" /></option>'; // 학과 선택
			USER_DEPT_LIST.forEach(function(v, i) {
				if(deptCdObj[v.deptCd]) {
					html += '<option value="' + v.deptCd + '">' + v.deptNm + '</option>';
				}
			});
			
			// 부서 초기화
			$("#deptCd").html(html);
			$("#deptCd").dropdown("clear");
			$("#deptCd").on("change", function() {
				changeDeptCd(this.value);
			});
			
			// 학과 초기화
			$("#crsCreCd").empty();
			$("#crsCreCd").dropdown("clear");
			
			// 부서변경
			changeDeptCd("ALL");
		}
		
		// 학과 변경
		function changeDeptCd(deptCd) {
			var univGbn = ($("#univGbn").val() || "").replace("ALL", "");
			var deptCd = (deptCd || "").replace("ALL", "");
			
			var html = '<option value="ALL"><spring:message code="common.subject.select" /></option>'; // 과목 선택
			
			CRS_CRE_LIST.forEach(function(v, i) {
				if((!univGbn || v.univGbn == univGbn) && (!deptCd || v.deptCd == deptCd)) {
					var declsNo = v.declsNo;
					declsNo = '(' + declsNo + ')';
					
					html += '<option value="' + v.crsCreCd + '">' + v.crsCreNm + declsNo + '</option>';
				}
			});
			
			$("#crsCreCd").html(html);
			$("#crsCreCd").dropdown("clear");
		}
		
		//과정유형 선택
		function selectContentCrsType(obj) {
			if($(obj).hasClass("basic")){
				$(obj).removeClass("basic").addClass("active");
			} else {
				$(obj).removeClass("active").addClass("basic");
			}
			
			onSearch();
		}
		
		function onSearch(){
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
					crsTypeCd   : crsTypeCd
				  , curYear      : $("#creYear").val()
				  , curTerm	     : $("#creTerm").val()
				  , univGbn      : ($("#univGbn").val() || "").replace("ALL", "")
				  , crsCreCd     : ($("#crsCreCd").val() || "").replace("ALL", "")
				  , deptCd       : ($("#deptCd").val() || "").replace("ALL", "")
				  , mrksGrdGvGbn : $("#mrksGrdGvGbn").val()
				  , searchValue  : $("#searchValue").val()
				  , declsNo      : $("#declsNo").val()
				  , searchText	 : ($("#searchText").val() || "").replace("all", "")
			}
		
			ajaxCall("/grade/gradeMgr/selectEvlList.do", param, function(data) {
				var html = "";
				if(data.returnList != null){
					$.each(data.returnList, function(i, o){
						html += "<tr>";
						html += "	<td>" + o.lineNo + "</td>";
			    		html += "	<td>" + (o.univGbnNm || '') + "</td>";
			    		html += "	<td>" + o.deptNm + "</td>";
			    		html += "	<td>";
			    		html += 		o.crsCd;
			    		html += "		<input type='hidden' name='list[" + i + "].crsCreCd' value='" + o.crsCreCd + "' />";
			    		html += "	</td>";
			    		html += "	<td>" + o.declsNo + "</td>";
			    		html += "	<td>" + o.crsCreNm + "</td>";
						html += "	<td>" + o.credit + "</td>";
						html += "	<td>" + (o.tchNm == null ? "-" : o.tchNm) + "</td>";
						html += "	<td>" + (o.tchNo == null ? "-" : o.tchNo) + "</td>";
						html += "	<td>";
						html += "		<select onchange='changeScoreEvalGbn(\"" + o.crsCreCd + "\", this.value)'>";
						html += "			<option value='RELATIVE' " + (o.scoreEvalGbn == "RELATIVE" ? "selected" : "") + "><spring:message code='crs.relative.evaluation'/></option>"; // 상대평가
						html += "			<option value='ABSOLUTE' " + (o.scoreEvalGbn == "ABSOLUTE" || o.scoreEvalGbn == "PF" ? "selected" : "") + "><spring:message code='crs.absolute.evaluation'/></option>"; // 절대평가
						html += "		</select>";
						html += "	</td>";
						html += "	<td>";
						html += "		<select id='scoreEvalGbn" + o.crsCreCd + "' name='list[" + i + "].scoreEvalGbn'>";
						if(o.scoreEvalGbn == "RELATIVE") {
							html += "<option value='RELATIVE' selected><spring:message code='score.label.grade'/></option>"; // 등급
						} else {
							html += "<option value='ABSOLUTE' " + (o.scoreEvalGbn == "ABSOLUTE" ? "selected" : "") + "><spring:message code='score.label.grade'/></option>"; // 등급
							html += "<option value='PF' " + (o.scoreEvalGbn == "PF" ? "selected" : "") + ">P/F</option>";
						}
						html += "		</select>";
						html += "	</td>";
						html += "	<td>" + (o.enrlNop == null ? "-" : o.enrlNop) + "</td>";
						html += "</tr>";
					});
				}
		
				$("#tbodyId").empty().html(html);
				$(".table").footable();
		
			}, function(xhr, status, error) {
				alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
			}, true);
		}
		
		function changeScoreEvalGbn(crsCreCd, value) {
			$("#scoreEvalGbn" + crsCreCd).empty();
			
			var html = '';
			
			if(value == "RELATIVE") {
				html += '<option value="RELATIVE"><spring:message code="score.label.grade"/></option>'; // 등급
			} else {
				html += '<option value="ABSOLUTE"><spring:message code="score.label.grade"/></option>'; // 등급
				html += '<option value="PF">P/F</option>';
			}
			
			$("#scoreEvalGbn" + crsCreCd).html(html);
		}
		
		function onSave() {
			// 저장하시겠습니까?
			if(confirm("<spring:message code='common.save.msg' />")){
				ajaxCall("/grade/gradeMgr/multiEvlList.do", $("#listForm").serialize(), function(data) {
					alert("<spring:message code='forum.alert.success'/>"); /* 저장되었습니다. */
					onSearch();
				}, function(xhr, status, error) {
					alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
				});
			}
		}
		
		// 엑셀다운로드
		function selectEvlListExcelDown() {
			var excelGrid = {
				colModel:[
				    {label:'<spring:message code="main.common.number.no"/>', name:'lineNo', align:'center', width:'3000'}, /* NO */
				    {label:'<spring:message code="user.title.userinfo.manage.userdiv" />', name:'univGbnNm', align:'center', width:'7000'}, /* 구분 */
				    {label:'<spring:message code="contents.label.crscre.dept" />', name:'deptNm', align:'center', width:'7000'}, /* 개설학과 */
				    {label:'<spring:message code="contents.label.crscd" />', name:'crsCd', align:'center', width:'10000'}, /* 학수번호 */
				    {label:'<spring:message code="crs.label.decls" />', name:'declsNo', align:'center', width:'7000'}, /* 분반 */
				    {label:'<spring:message code="crs.label.crecrs.nm" />', name:'crsCreNm', align:'center', width:'7000'}, /* 과목명 */
				    {label:'<spring:message code="crs.label.compdv" />', name:'compDvNm', align:'center', width:'7000'}, /* 이수구분 */
				    {label:'<spring:message code="crs.label.credit" />', name:'credit', align:'center', width:'7000'}, /* 학점 */
				    {label:'<spring:message code="crs.label.rep.professor" />', name:'tchNm', align:'center', width:'7000'}, /* 담당교수 */
				    {label:'<spring:message code="crs.label.no.enseignement" />', name:'tchNo', align:'center', width:'5000'}, /* 교직원번호 */
				    {label:'<spring:message code="score.label.score.grade.type" />', name:'scoreEvalGbn', align:'center', width:'5000', codes:{RELATIVE: "<spring:message code='crs.relative.evaluation'/>", ABSOLUTE: "<spring:message code='crs.absolute.evaluation'/>", PF: "<spring:message code='crs.absolute.evaluation'/>"}}, /* 성적부여방법 */
				    {label:'<spring:message code="forum.label.score.eval.type" />', name:'scoreEvalGbn', align:'center', width:'5000', codes:{RELATIVE: "<spring:message code='score.label.grade'/>", ABSOLUTE: "<spring:message code='score.label.grade'/>", PF: "P/F"}}, /* 성적평가구분 */
				    {label:'<spring:message code="crs.attend.person"/>', name:'enrlNop', align:'center', width:'5000'} /* 수강인원(명) */
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
		
		    $("form[name=excelForm]").remove();
		    var excelForm = $('<form name="excelForm" method="post" ></form>');
		    excelForm.attr("action", "/grade/gradeMgr/selectEvlExcelDown.do");
		    excelForm.append($('<input/>', {type: 'hidden', name: 'crsTypeCd', 		value: crsTypeCd}));
		    excelForm.append($('<input/>', {type: 'hidden', name: 'curYear', 		value: $("#creYear").val()}));
		    excelForm.append($('<input/>', {type: 'hidden', name: 'curTerm', 		value: $("#creTerm").val()}));
		    excelForm.append($('<input/>', {type: 'hidden', name: 'univGbn', 		value: ($("#univGbn").val() || "").replace("ALL", "")}));
		    excelForm.append($('<input/>', {type: 'hidden', name: 'deptCd', 		value: ($("#deptCd").val() || "").replace("ALL", "")}));
		    excelForm.append($('<input/>', {type: 'hidden', name: 'crsCreCd', 		value: ($("#crsCreCd").val() || "").replace("ALL", "")}));
		    excelForm.append($('<input/>', {type: 'hidden', name: 'mrksGrdGvGbn', 	value: $("#mrksGrdGvGbn").val()}));
		    excelForm.append($('<input/>', {type: 'hidden', name: 'searchValue', 	value: $("#searchValue").val()}));
		    excelForm.append($('<input/>', {type: 'hidden', name: 'declsNo', 		value: $("#declsNo").val()}));
		    excelForm.append($('<input/>', {type: 'hidden', name: 'searchText', 	value: ($("#searchText").val() || "").replace("all", "")}));
		    excelForm.append($('<input/>', {type: 'hidden', name: 'excelGrid', 		value:JSON.stringify(excelGrid)}));
		    excelForm.appendTo('body');
		    excelForm.submit();
		}
	</script>
</head>
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
                <div id="info-item-box">
                    <h2 class="page-title flex-item">
                    	<spring:message code="common.label.mut.eval.score" />
                    	<div class="ui breadcrumb small">
					        <small class="section"><spring:message code="common.score.evaluation" /> <spring:message code="common.score.type.search" /></small>
					    </div>
                    </h2> <!-- 성적평가관리 성적평가 구분조회 -->
                    <div class="button-area">
                      	<a href="javascript:onSave();" class="ui gray button"><spring:message code="exam.button.save" /></a><!-- 저장 -->
		                <a href="javascript:selectEvlListExcelDown();" class="ui basic button"><spring:message code="forum.label.excel.download" /></a><!-- 엑셀다운로드 -->
                    </div>
                </div>
				<div class="ui divider mt0"></div>
				<div class="ui form">
	                <div class="option-content" style="<%=(!SessionInfo.isKnou(request) ? "display:none" : "")%>">
		            	<div class="ui buttons">
				        	<button class="ui blue button active crsTypeBtn" data-crs-type-cd="UNI" onclick="selectContentCrsType(this)"><spring:message code="crs.label.crs.uni" /><!-- 학기제 --></button>
				        	<%-- <button class="ui basic blue button crsTypeBtn" data-crs-type-cd="CO" onclick="selectContentCrsType(this)"><spring:message code="crs.label.crs.co" /><!-- 기수제 --></button>
				        	<button class="ui basic blue button crsTypeBtn" data-crs-type-cd="LEGAL" onclick="selectContentCrsType(this)"><spring:message code="crs.label.crs.court" /><!-- 법정교육 --></button> --%>
			            </div>
		            </div>
	                <div class="ui segment searchArea">
	                    <select class="ui dropdown" id="creYear" onchange="changeTerm()">
							<c:forEach var="item" items="${yearList}" varStatus="status">
								<option value="${item}" <c:if test="${item eq termVO.haksaYear}">selected</c:if>>${item}</option>
							</c:forEach>
						</select>
						<select class="ui dropdown" id="creTerm" onchange="changeTerm()">
							<c:forEach var="item" items="${termList }">
								<option value="${item.codeCd }" <c:if test="${item.codeCd eq termVO.haksaTerm}">selected</c:if>>${item.codeNm }</option>
							</c:forEach>
						</select>
						<c:if test="${orgId eq 'ORG0000001'}">
							<select id="univGbn" class="ui dropdown mr5" onchange="changeUnivGbn()">
					           	<option value=""><spring:message code="common.label.uni.type" /></option><!-- 대학구분 -->
					           	<option value="ALL"><spring:message code="common.all" /></option><!-- 전체 -->
					           	<c:forEach var="item" items="${univGbnList}">
									<option value="${item.codeCd}" ${item.codeCd}><c:out value="${item.codeNm}" /></option>
								</c:forEach>
					        </select>
				        </c:if>
				        <select id="deptCd" class="ui dropdown w250" onchange="changeDeptCd()">
		                	<option value=""><spring:message code="common.dept_name" /><!-- 학과 --> <spring:message code="common.select" /><!-- 선택 --></option>
		                </select> 
		                <select id="crsCreCd" class="ui dropdown w250">
				        	<option value=""><spring:message code="common.subject" /><!-- 과목 --> <spring:message code="common.select" /><!-- 선택 --></option>
				        </select>
				        <select class="ui dropdown w200" id="mrksGrdGvGbn">
	                    	<option value="all"><spring:message code="score.label.score.grade.type" /></option><!-- 성적부여방법 -->
	                    	<option value="RELATIVE"><spring:message code="crs.relative.evaluation"/></option><!-- 상대평가 -->
	                    	<option value="ABSOLUTE"><spring:message code="crs.absolute.evaluation"/></option><!-- 절대평가 -->
	                    </select>
	                    <select class="ui dropdown w200" id="searchText">
	                    	<option value="all"><spring:message code="forum.label.score.eval.type" /></option><!-- 성적평가구분 -->
	                    	<option value="GRADE"><spring:message code="score.label.grade"/></option><!-- 등급 -->
	                    	<option value="PF">P/F</option>
	                    </select>
	                    <div class="ui input search-box">
	                        <input type="text" class="w200" placeholder="<spring:message code="crs.label.crecrs.nm" />/<spring:message code="common.crs.cd" />/<spring:message code="common.label.prof.nm" />" name="searchValue" id="searchValue" ><!-- 과목명/학수번호/교수명 -->
	                        <input type="text" class="w200" placeholder="<spring:message code='crs.label.declsno.insert'/>" name="declsNo" id="declsNo" ><!-- 분반입력 -->
	                    </div>
	                    <div class="button-area mt10 tc">
	                    	<button type="button" class="ui blue button w100" onclick="onSearch();"><spring:message code="common.button.search" /><!-- 검색 --></button>
						</div>
	                    <!--
	                    <select class="ui dropdown mr5 selection" id="listScale" onchange="onChangeListScale();">
	                        <option value="10">10</option>
	                        <option value="20">20</option>
	                        <option value="50">50</option>
	                        <option value="100">100</option>
                       	</select>
                       	-->
	                </div>

	                <form:form id="listForm" commandName="GradeVO">
                   	<table class="table" data-sorting="true" data-paging="false" data-empty="<spring:message code="common.content.not_found" />">
						<thead>
							<tr>
								<th scope="col" class="num tc"><spring:message code="main.common.number.no"/></th><!-- NO. -->
					    		<th scope="col"><spring:message code="user.title.userinfo.manage.userdiv" /></th><!-- 구분 -->
					    		<th scope="col"><spring:message code="contents.label.crscre.dept" /></th><!-- 개설학과 -->
					    		<th scope="col"><spring:message code="contents.label.crscd" /></th><!-- 학수번호 -->
					    		<th scope="col"><spring:message code="crs.label.decls" /></th><!-- 분반 -->
					    		<th scope="col"><spring:message code="crs.label.crecrs.nm" /></th><!-- 과목명 -->
								<th scope="col"><spring:message code="crs.label.credit" /></th><!-- 학점 -->
								<th scope="col"><spring:message code="crs.label.rep.professor" /></th><!-- 담당교수 -->
								<th scope="col"><spring:message code="crs.label.no.enseignement" /></th><!-- 교직원번호 -->
								<th scope="col"><spring:message code="score.label.score.grade.type" /></th><!-- 성적부여방법 -->
								<th scope="col"><spring:message code="forum.label.score.eval.type" /></th><!-- 성적평가구분 -->
								<th scope="col"><spring:message code="crs.attend.person"/></th><!--   수강인원(명) -->
							</tr>
						</thead>
						<tbody id="tbodyId">
						</tbody>
					</table>
					</form:form>
		   		</div>
			</div>
		<%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
		</div>
	</div>
</body>
