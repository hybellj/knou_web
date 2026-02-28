<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
	var USER_DEPT_LIST = [];
	var CRS_CRE_LIST   = [];

	$(function(){
		// 부서정보
		<c:forEach var="item" items="${usrDeptCdList}">
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
		
		changeTerm();
	});
	
	// 학기 변경
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
		$("#mngtDeptCd").html(html);
		$("#mngtDeptCd").dropdown("clear");
		$("#mngtDeptCd").on("change", function() {
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
	}
	
	// 교직원 검색
    function selectProfessorList() {
    	$("#modalForm [name=subParam]").val("searchForm");
    	$("#modalForm").attr("target", "modalIfm");
        $("#modalForm").attr("action", "/user/userMgr/professorSearchListPop.do");
        $("#modalForm").submit();
        $("#modalPop").modal('show');
    }
	
	// 과목 검색
	function creCrsList() {
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
		
		creCrsTable.clearData();
		
		var url  = "/grade/gradeMgr/gradeInputCreCrsList.do";
		var data = {
			"creYear" 	  	: $("#creYear").val(),
			"creTerm" 	  	: $("#creTerm").val(),
			"univGbn"	  	: ($("#univGbn").val() || "").replace("ALL", ""),
			"crsCreCd"	  	: ($("#crsCreCd").val() || "").replace("ALL", ""),
			"crsTypeCd"   	: crsTypeCd,
			"mngtDeptCd"  	: ($("#mngtDeptCd").val() || "").replace("ALL", ""),
			"userId"	  	: $("#searchProfessor input[name=userId]").val(),
			"searchValue" 	: $("#searchValue").val(),
			"searchKey"	    : $("#searchKey").val(),
			"calculationYn" : ($("#calculationYn").val() || "").replace("ALL", ""),
			"converstionYn" : ($("#converstionYn").val() || "").replace("ALL", "")
			/* "grantYn"		: ($("#grantYn").val() || "").replace("ALL", "") */
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				var returnList = data.returnList || [];
				var totCnt = returnList.length > 0 ? returnList.length : 0;
        		var dataList = [];
        		
        		if(returnList.length > 0) {
        			returnList.forEach(function(v, i) {
        				dataList.push({
        					univGbnNm: v.univGbnNm,
        					deptNm: v.deptNm,
        					crsCd: v.crsCd,
        					declsNo: v.declsNo,
        					crsCreNm: "<div class='flex-item wmax'><span>"+v.crsCreNm+"</span><button class='ui mla mini icon button' onclick='gradeStatusPop(\""+v.crsCreCd+"\")'><i class='search icon'></i></button></div>",
        					compDvNm: v.compDvNm,
        					credit: v.credit,
        					tchNm: v.tchNm,
        					tchNo: v.tchNo,
        					tchMobileNo: v.tchMobileNo,
        					stdCnt: v.stdCnt,
        					scoreStdCnt: v.scoreStdCnt,
        					scoreConvCnt: v.scoreConversionCnt,
        					gradeStdCnt: v.gradeStdCnt,
        					viewLog: "<button type='button' class='ui yellow mini button' onclick='gradeLogPop(\""+v.crsCreCd+"\")'>View Log</button>",
        					valEmail: v.tchEmail
        				});
        			});
        		}
        		
	        	$("#creCrsCnt").text(totCnt);
	        	creCrsTable.addData(dataList);
	        	creCrsTable.redraw();
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
		}, true);
	}
	
	// 체크박스 이벤트
	function checkCrs(obj) {
		if(obj.value == "all") {
			$("#creCrsTbody").find("input:checkbox[name=evalChk]").prop("checked", obj.checked);
		} else {
			$("#allChk").prop("checked", $("#creCrsTbody").find("input:checkbox[name=evalChk]").length == $("#creCrsTbody").find("input:checkbox[name=evalChk]:checked").length);
		}
	}
	
	// 엑셀 다운로드
	function excelDown() {
		var excelGrid = {
		    colModel:[
		        {label:'<spring:message code="main.common.number.no" />',			name:'lineNo',        	align:'center',	width:'1500'},	
		        {label:"<spring:message code='common.type' />",						name:'univGbnNm',   	align:'left',   width:'3000'},/* 구분 */
		        {label:"<spring:message code='common.phy.dept_name' />",			name:'deptNm',   	   	align:'left',   width:'8000'},/* 관장학과 */
		        {label:"<spring:message code='common.crs.cd' />",					name:'crsCd',   	   	align:'center', width:'5000'},/* 학수번호 */
		        {label:"<spring:message code='common.label.decls.no' />", 			name:'declsNo',        	align:'right',  width:'1500'},/* 분반 */
		        {label:"<spring:message code='crs.label.crecrs.nm' />", 			name:'crsCreNm',        align:'left',   width:'8000'},/* 과목명 */
		        {label:"<spring:message code='common.label.crsauth.comtype' />", 	name:'compDvNm',        align:'left',   width:'3000'},/* 이수구분 */
		        {label:"<spring:message code='common.label.credit' />",				name:'credit',      	align:'left',   width:'1500'},/* 학점 */
		        {label:"<spring:message code='common.charge.professor' />",			name:'tchNm',    		align:'left',   width:'3000'},/* 담당교수 */
		        {label:"<spring:message code='crs.label.no.enseignement' />", 		name:'tchNo',			align:'left',   width:'5000'},/* 교직원번호 */
		        {label:"<spring:message code='user.title.userinfo.mobileno' />",	name:'tchMobileNo', 	align:'left',   width:'5000'},/* 휴대폰번호 */
		        {label:"<spring:message code='crs.attend.person.nm' />",			name:'stdCnt', 	   		align:'right',  width:'5000'},/* 수강인원 */
		        {label:"<spring:message code='score.label.calculation.cnt' />",		name:'scoreStdCnt', 	align:'right',  width:'5000'},/* 성적산출인원 */
		        {label:"<spring:message code='score.label.exchange.cnt' />",		name:'scoreStdCnt', 	align:'right',  width:'5000'},/* 성적환산인원 */
		        {label:"<spring:message code='score.label.grading.cnt' />",			name:'gradeStdCnt', 	align:'right',  width:'5000'},/* 등급부여인원 */
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
		excelForm.attr("method", "POST");
		excelForm.attr("action","/grade/gradeMgr/gradeCreCrsStatusExcelDown.do");
		excelForm.append($('<input/>', {type: 'hidden', name: 'creYear', 		value: $("#creYear").val()}));
		excelForm.append($('<input/>', {type: 'hidden', name: 'creTerm', 		value: $("#creTerm").val()}));
		excelForm.append($('<input/>', {type: 'hidden', name: 'univGbn', 		value: $("#univGbn").val()}));
		excelForm.append($('<input/>', {type: 'hidden', name: 'crsTypeCd', 		value: crsTypeCd}));
		excelForm.append($('<input/>', {type: 'hidden', name: 'mngtDeptCd', 	value: $("#mngtDeptCd").val()}));
		excelForm.append($('<input/>', {type: 'hidden', name: 'userId', 		value: $("#searchProfessor input[name=userId]").val()}));
		excelForm.append($('<input/>', {type: 'hidden', name: 'searchValue', 	value: $("#searchValue").val()}));
		excelForm.append($('<input/>', {type: 'hidden', name: 'searchKey', 		value: $("#searchKey").val()}));
		excelForm.append($('<input/>', {type: 'hidden', name: 'excelGrid', 		value:JSON.stringify(excelGrid)}));
		excelForm.appendTo('body');
		excelForm.submit();
	}
	
	// 수강생 목록 / 성적처리 현황 팝업
	function gradeStatusPop(crsCreCd) {
		$("#gradeStatusForm [name=crsCreCd]").val(crsCreCd);
    	$("#gradeStatusForm").attr("target", "gradeStatusIfm");
        $("#gradeStatusForm").attr("action", "/grade/gradeMgr/gradeStatusPopup.do");
        $("#gradeStatusForm").submit();
        $("#gradeStatusPop").modal('show');
	}
	
	// viewlog
	function gradeLogPop(crsCreCd) {
		$("#gradeLogForm [name=crsCreCd]").val(crsCreCd);
    	$("#gradeLogForm").attr("target", "gradeLogIfm");
        $("#gradeLogForm").attr("action", "/grade/gradeMgr/gradeViewLogPopup.do");
        $("#gradeLogForm").submit();
        $("#gradeLogPop").modal('show');
	}
	
	if(window.addEventListener) {
		window.addEventListener("message", receiveMessage, false);
	} else {
		if(window.attachEvent) {
			window.attachEvent("onmessage", receiveMessage);
		}
	}
	
	function receiveMessage(event) {
		var data = event.data;
		if(data.type == "close") {
			closeModal();
		} else if(data.type == "prev" || data.type == "detail") {
			$("#"+data.form+" input[name='crsCreCd']").val(data.crsCreCd);
			$("#"+data.form+" input[name='stdNo']").val(data.stdNo);
			$("#"+data.form).attr("action", data.action);
			$("#"+data.form).submit();
		} else if(data.type == "search") {
			$("#searchProfessor input[name=userId]").val(data.userId);
			$("#searchProfessor input[name=userNm]").val(data.userNm);
		}
	}
	
	// 메세지 보내기
	function sendMsg() {
		var rcvUserInfoStr = "";
		var sendCnt = 0;
		var dupCheckObj = {};
		var rcvUserMap = {};
		
		var selectList = creCrsTable.getSelectedRows();
		if (selectList == null) {
			return;
		}
		
		for(var i=0; i<selectList.length; i++) {
			var data = selectList[i].getData();

			if (rcvUserMap[data.tchNo] != undefined) {
				continue;
			}
			
			rcvUserMap[data.tchNo] = true;
			sendCnt++;
			if (sendCnt > 1)
				rcvUserInfoStr += "|";
			
			rcvUserInfoStr += data.tchNo;
			rcvUserInfoStr += ";" + data.tchNm;
			rcvUserInfoStr += ";" + data.tchMobileNo;
			rcvUserInfoStr += ";" + data.valEmail;
		}

		if (sendCnt == 0) {
			/* 메시지 발송 대상자를 선택하세요. */
			alert("<spring:message code='common.alert.sysmsg.select_user'/>");
			return;
		}
		
        window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");

        var form = document.alarmForm;
        form.action = "<%=CommConst.SYSMSG_URL_SEND%>";
        form.target = "msgWindow";
        form[name='alarmType'].value = "S"; // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
        form[name='rcvUserInfoStr'].value = rcvUserInfoStr; //보내는사람 정보
        form.submit();
	}

	// ERP 테스트 데이터 전송
	function sendErp() {
		if (!confirm("<spring:message code='common.regist.msg'/>")) return; // 등록하시겠습니까?

		let url = "/score/scoreOverall/insertErpTestScoreList.do";
		let data = {
			creYear: $("#creYear").val()
			, creTerm: $("#creTerm").val()
		};

		showLoading();

		$.ajax({
			url: url,
			data: data,
			type: "POST",
			success: function (data, status, xr) {
				hideLoading();
				if (data.result > 0) {
					if (data.message) {
						var outMsg = "ERP 성적 메인 테이블 이관 알림:\n" + data.message;
						alert("<spring:message code='common.result.success'/>\n\n" + outMsg); // 성공적으로 작업을 완료하였습니다.
					} else {
						alert("<spring:message code='common.result.success'/>"); // 성공적으로 작업을 완료하였습니다.
					}
				} else {
					alert(data.message);
				}
			},
			error: function (xhr, status, error) {
				hideLoading();
				alert('<spring:message code="fail.common.msg" />\n\n' + error); // 에러가 발생했습니다!
			},
			timeout: 600000
		});
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
	                    <h2 class="page-title"><spring:message code="score.label.grade.manage" /><!-- 성적평가관리 --> > <spring:message code="score.label.grade.input.status" /><!-- 성적입력현황 --></h2>
	                </div>
	                <div class="ui segment">
		                <div class="option-content" style="<%=(!SessionInfo.isKnou(request) ? "display:none" : "")%>">
		                	<div class="ui buttons">
				            	<button class="ui blue button active crsTypeBtn" data-crs-type-cd="UNI" onclick="selectContentCrsType(this)"><spring:message code="crs.label.crs.uni" /><!-- 학기제 --></button>
				            	<%-- <button class="ui basic blue button crsTypeBtn" data-crs-type-cd="CO" onclick="selectContentCrsType(this)"><spring:message code="crs.label.crs.co" /><!-- 기수제 --></button>
				            	<button class="ui basic blue button crsTypeBtn" data-crs-type-cd="LEGAL" onclick="selectContentCrsType(this)"><spring:message code="crs.label.crs.legal" /><!-- 법정교육 --></button>
				            	<button class="ui basic blue button crsTypeBtn" data-crs-type-cd="OPEN" onclick="selectContentCrsType(this)"><spring:message code="crs.label.crs.open" /><!-- 공개강좌 --></button> --%>
			                </div>
		                </div>
		                <div class="option-content">
		                	<select class="ui dropdown mr5" id="creYear" onchange="changeTerm()">
		                		<c:forEach var="year" items="${yearList }">
		                			<option value="${year}" <c:if test="${year eq termVO.haksaYear}">selected</c:if>>${year}<spring:message code="date.year" /><!-- 년 --></option>
		                			<%-- <option value="${year}" <c:if test="${year eq '2024'}">selected</c:if>>${year}<spring:message code="date.year" /><!-- 년 --></option> --%>
		                		</c:forEach>
		                	</select>
		                	<select class="ui dropdown mr5" id="creTerm" onchange="changeTerm()">
		                		<c:forEach var="term" items="${termList }">
		                			<option value="${term.codeCd }" <c:if test="${term.codeCd eq termVO.haksaTerm }">selected</c:if>>${term.codeNm }</option>
		                			<%-- <option value="${term.codeCd }" <c:if test="${term.codeCd eq '20' }">selected</c:if>>${term.codeNm }</option> --%>
		                		</c:forEach>
		                	</select>
		                	<c:if test="${orgId eq 'ORG0000001' }">
			                	<select class="ui dropdown mr5" id="univGbn" onchange="changeUnivGbn()">
			                		<option value="ALL"><spring:message code="common.label.uni.type" /><!-- 대학구분 --></option>
			                		<c:forEach var="item" items="${univGbnList}">
										<option value="${item.codeCd}" ${item.codeCd}><c:out value="${item.codeNm}" /></option>
									</c:forEach>
			                	</select>
		                	</c:if>
		                	<select class="ui dropdown mr5" id="mngtDeptCd" onchange="changeDeptCd()">
		                		<option value=""><spring:message code="common.dept_name" /><!-- 학과 --></option>
		                		<option value="ALL"><spring:message code="common.dept_name" /><!-- 학과 --></option>
		                		<c:forEach var="dept" items="${usrDeptCdList }">
		                			<option value="${dept.deptCd }">${dept.deptNm }</option>
		                		</c:forEach>
		                	</select>
		                	<select id="crsCreCd" class="ui dropdown mr5 w250">
			                	<option value=""><spring:message code="common.subject" /><!-- 과목 --> <spring:message code="common.select" /><!-- 선택 --></option>
			                </select>
		                	<select class="ui dropdown mr5" id="calculationYn">
		                		<option value="ALL"><spring:message code="score.label.calculation.yn" /><!-- 산출여부 --></option>
		                		<option value="Y"><spring:message code="score.label.calculation.y" /><!-- 산출 --></option>
		                		<option value="N"><spring:message code="score.label.calculation.n" /><!-- 미산출 --></option>
		                	</select>
		                	<select class="ui dropdown mr5" id="converstionYn">
		                		<option value="ALL"><spring:message code="score.label.converstion.yn" /><!-- 환산여부 --></option>
		                		<option value="Y"><spring:message code="score.label.converstion.y" /><!-- 환산 --></option>
		                		<option value="N"><spring:message code="score.label.converstion.n" /><!-- 미환산 --></option>
		                	</select>
		                	<%-- <select class="ui dropdown mr5" id="grantYn">
		                		<option value="ALL"><spring:message code="score.label.grading" /><!-- 등급부여 --></option>
		                		<option value="Y"><spring:message code="score.label.partial.grant" /><!-- 일부부여 --></option>
		                		<option value="N"><spring:message code="score.label.not.grant" /><!-- 미부여 --></option>
		                	</select> --%>
		                </div>
		                <div class="option-content">
		                	<input type="text" class="ui input w250 mr5" placeholder="<spring:message code="crs.label.crecrs.nm" />/<spring:message code="common.crs.cd" />/<spring:message code="common.label.prof.nm" />" id="searchValue" /><!-- 과목명/학수번호/교수명 -->
		                	<input type="text" class="ui input w100 mr5" placeholder="<spring:message code="crs.label.declsno.insert" />" id="searchKey" />
		                	<div class="ui action input search-box" id="searchProfessor">
				                <input type="hidden" name="userId" placeholder="<spring:message code="exam.label.tch.no" />" >
				                <input type="text" name="userNm" placeholder="<spring:message code="common.charge.professor" />" class="w150 bcLgrey" readonly>
							    <button class="ui icon button" onclick="selectProfessorList(1)"><i class="search icon"></i></button>
							</div>
							<div class="mla">
								<button type="button" class="ui green button" onclick="creCrsList()"><spring:message code="common.button.search" /><!-- 검색 --></button>
							</div>
		                </div>
	                </div>
	                <div class="option-content">
	                	<h3 class="sec_head"><spring:message code="crs.label.open.crs" /><!-- 개설과목 --></h3>
	                	<p>[ <spring:message code="message.all" /><!-- 총 --> <span class="fcBlue" id="creCrsCnt"></span><spring:message code="message.count" /><!-- 건 --> ]</p>
	                	<div class="mla">
	                		<a href="javascript:sendErp()" class="ui orange button" style="<%=(!SessionInfo.isKnou(request) ? "display:none" : "")%>">ERP <spring:message code="exam.button.eval.send" /></a>
	                		<a href="javascript:sendMsg()" class="ui basic button"><i class="paper plane outline icon"></i><spring:message code="common.button.message" /></a><!-- 메시지 -->
	                		<a href="javascript:excelDown()" class="ui green button"><spring:message code="common.button.excel_down" /><!-- 엑셀 다운로드 --></a>
	                	</div>
	                </div>
	                
	                <div id="creCrsTable"></div>
	                <script>
	                var creCrsTable = new Tabulator("#creCrsTable", {
                    		maxHeight: "600px",
                    		minHeight: "100px",
                    		layout: "fitColumns",
                    		selectableRows: "highlight",
                    		headerSortClickElement: "icon",
                    		placeholder:"<spring:message code='common.content.not_found'/>",
                    		columns: [
                    			{formatter:"rowSelection", titleFormatter:"rowSelection", headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:50, cellClick:function(e,cell){cell.getRow().toggleSelect();}, headerSort:false}, // check
                    		    {title:"<spring:message code='common.number.no'/>", 			field:"lineNo", 		headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:50, 		formatter:"rownum",		headerSort:false},	// NO
                    		    {title:"<spring:message code='common.type'/>",					field:"univGbnNm", 		headerHozAlign:"center", hozAlign:"center",	vertAlign:"middle", width:80,		formatter:"plaintext", 	headerSort:false},	// 구분			                        		    
                    		    {title:"<spring:message code='common.phy.dept_name'/>", 		field:"deptNm", 		headerHozAlign:"center", hozAlign:"left",	vertAlign:"middle", minWidth:100,	formatter:"plaintext", 	headerSort:true, sorter:"string", sorterParams:{locale:"en"}}, // 관장학과
                    		    {title:"<spring:message code='contents.label.crscd'/>",			field:"crsCd", 			headerHozAlign:"center", hozAlign:"center",	vertAlign:"middle", width:100,		formatter:"plaintext", 	headerSort:true},	// 학수번호
                    		    {title:"<spring:message code='contents.label.decls'/>",			field:"declsNo", 		headerHozAlign:"center", hozAlign:"center",	vertAlign:"middle", width:50,		formatter:"plaintext", 	headerSort:false},	// 분반
                    		    {title:"<spring:message code='contents.label.crscrenm'/>",		field:"crsCreNm", 		headerHozAlign:"center", hozAlign:"left",   vertAlign:"middle", minWidth:200,	formatter:"html", 		headerSort:true, sorter:"string", sorterParams:{locale:"en"}}, // 과목명
                    		    {title:"<spring:message code='common.label.crsauth.comtype'/>",	field:"compDvNm", 		headerHozAlign:"center", hozAlign:"center",	vertAlign:"middle", width:80,		formatter:"plaintext", 	headerSort:false},	// 이수구분
                    		    {title:"<spring:message code='crs.label.credit'/>",				field:"credit", 		headerHozAlign:"center", hozAlign:"center",	vertAlign:"middle", width:50,		formatter:"plaintext", 	headerSort:false},	// 학점
                    		    {title:"<spring:message code='common.charge.professor'/>",		field:"tchNm",	 		headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", minWidth:80,	formatter:"plaintext",	headerSort:false},	// 담당교수
                    		    {title:"<spring:message code='crs.label.no.enseignement'/>", 	field:"tchNo",			headerHozAlign:"center", hozAlign:"center",	vertAlign:"middle", width:80, 		formatter:"plaintext", 	headerSort:false},	// 교직원번호
                    		    {title:"<spring:message code='user.title.userinfo.mobileno'/>",	field:"tchMobileNo",	headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:120,		formatter:"plaintext",	headerSort:false},	// 휴대폰번호
                    		    {title:"<spring:message code='crs.attend.person.nm'/>",			field:"stdCnt",			headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:70,		formatter:"plaintext",	headerSort:false},	// 수강인원
                    		    {title:"<spring:message code='score.label.calculation.cnt'/>",	field:"scoreStdCnt",	headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:100,		formatter:"plaintext",	headerSort:false},	// 성적산출인원
                    		    {title:"<spring:message code='score.label.exchange.cnt'/>",		field:"scoreConvCnt",	headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:100,		formatter:"plaintext",	headerSort:false},	// 성적환산인원
                    		    {title:"<spring:message code='score.label.grading.cnt'/>",		field:"gradeStdCnt",	headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:100,		formatter:"plaintext",	headerSort:false},	// 등급부여인원
                    		    {title:"View Log",												field:"viewLog",		headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:80,		formatter:"html",		headerSort:false},	// View log
                    		]
                   	});
                    </script>
				</div>
			</div>
			
		<%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>

		<!-- 교직원 검색 팝업 -->
	    <form class="ui form" id="modalForm" name="modalForm" method="POST" action="">
	    	<input type="hidden" name="subParam" value="searchProfessor|modalIfm|modalPop"/>
		    <div class="modal fade" id="modalPop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="user.title.userinfo.professor.search" />" aria-hidden="false">
		        <div class="modal-dialog modal-lg" role="document">
		            <div class="modal-content">
		                <div class="modal-header">
		                    <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
		                        <span aria-hidden="true">&times;</span>
		                    </button>
		                    <h4 class="modal-title"><spring:message code="user.title.userinfo.professor.search" /><!-- 교직원 검색 --></h4>
		                </div>
		                <div class="modal-body">
		                    <iframe src="" id="modalIfm" name="modalIfm" width="100%" scrolling="no"></iframe>
		                </div>
		            </div>
		        </div>
		    </div>
	    </form>
	    
	    <!-- 성적처리 현황 팝업 -->
	    <form class="ui form" id="gradeStatusForm" name="gradeLogForm" method="POST" action="">
	    	<input type="hidden" name="crsCreCd" />
	    	<input type="hidden" name="stdNo" />
		    <div class="modal fade" id="gradeStatusPop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="score.label.std.list.score.status" />" aria-hidden="false">
		        <div class="modal-dialog modal-lg" role="document">
		            <div class="modal-content">
		                <div class="modal-header">
		                    <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
		                        <span aria-hidden="true">&times;</span>
		                    </button>
		                    <h4 class="modal-title"><spring:message code="score.label.std.list.score.status" /><!-- 수강생 목록 및 성적처리 현황 --></h4>
		                </div>
		                <div class="modal-body">
		                    <iframe src="" id="gradeStatusIfm" name="gradeStatusIfm" width="100%" scrolling="no"></iframe>
		                </div>
		            </div>
		        </div>
		    </div>
	    </form>
	    
	    <!-- ViewLog 팝업 -->
	    <form class="ui form" id="gradeLogForm" name="gradeLogForm" method="POST" action="">
	    	<input type="hidden" name="crsCreCd" />
		    <div class="modal fade" id="gradeLogPop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="score.label.score.change.log" />" aria-hidden="false">
		        <div class="modal-dialog modal-lg" role="document">
		            <div class="modal-content">
		                <div class="modal-header">
		                    <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
		                        <span aria-hidden="true">&times;</span>
		                    </button>
		                    <h4 class="modal-title"><spring:message code="score.label.score.change.log" /><!-- 성적변경이력 --></h4>
		                </div>
		                <div class="modal-body">
		                    <iframe src="" id="gradeLogIfm" name="gradeLogIfm" width="100%" scrolling="no"></iframe>
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
