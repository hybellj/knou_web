<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	
	<script type="text/javascript">
		var USER_DEPT_LIST = [];
		var CRS_CRE_LIST = [];
		var CNTS_GBN_OBJ = {
			  VIDEO			: "동영상"
			, VIDEO_LINK	: "LCDMS 동영상"
			, PDF			: "PDF"
			, FILE			: "파일"
			, LINK			: "링크"
			, TEXT			: "텍스트"
			, SOCIAL		: "소셜"
		};
	
		$(document).ready(function() {
			// 부서정보
			<c:forEach var="item" items="${deptCdList}">
			USER_DEPT_LIST.push({
					  deptCd: '<c:out value="${item.deptCd}" />'
					, deptNm: '<c:out value="${item.deptNm}" />'
					, deptCdOdr: '<c:out value="${item.deptCdOdr}" />'
				});
			</c:forEach>
			
			USER_DEPT_LIST = USER_DEPT_LIST.sort(function(a, b) {
				if(a.deptCdOdr < b.deptCdOdr) return -1;
				if(a.deptCdOdr > b.deptCdOdr) return 1;
				if(a.deptCdOdr == b.deptCdOdr) {
					if(a.deptNm < b.deptNm) return -1;
					if(a.deptNm > b.deptNm) return 1;
				}
				return 0;
			});
			
			$("#searchValue").on("keydown", function(e){
				if(e.keyCode == 13) {
					listPaging(1);
				}
			});
			
			changeTerm();
			listPaging(1);
		});
		
		// 목록
		function listPaging(pageIndex) {
			var crsTypeCdList = [];
			
			$.each($("[data-crs-type-cd]"), function() {
				if($(this).hasClass("active")) {
					crsTypeCdList.push($(this).data("crsTypeCd"));
				}
			});
			
			var url  = "/lesson/lessonMgr/listCntsUsage.do";
			var data = {
				  creYear		: $("#creYear").val()
				, creTerm		: $("#creTerm").val()
				, crsTypeCds	: crsTypeCdList.join(",")
				, univGbn		: ($("#univGbn").val() || "").replace("ALL", "")
				, deptCd		: ($("#deptCd").val() || "").replace("ALL", "")
				, crsCreCd		: ($("#crsCreCd").val() || "").replace("ALL", "")
				, searchValue	: $("#searchValue").val()
				, pageIndex		: pageIndex
				, listScale		: $("#listScale").val()
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					
					var html = '';
					returnList.forEach(function(v, i) {
						var userNm = "-";
						
						if(v.userId) {
							userNm = v.userNm + "(" + v.userId + ")";
						}
						
						var lbnTm = "-";
						
						if(v.userId) {
							lbnTm = v.lbnTm + '<spring:message code="lesson.label.min" />'; // 분
						}
						
						var cntsGbn = CNTS_GBN_OBJ[v.cntsGbn] ? CNTS_GBN_OBJ[v.cntsGbn] : v.cntsGbn;
						
						html += '<tr>';
						html += '	<td>' + v.lineNo + '</td>';
						html += '	<td>' + (v.deptNm || '-') + '</td>';
						html += '	<td>' + v.crsCd + '</td>';
						html += '	<td>' + userNm + '</td>';
						html += '	<td>' + v.crsCreNm +'(' + v.declsNo + '<spring:message code="crs.label.room" />)</td>';
						html += '	<td>' + v.lessonScheduleOrder + '<spring:message code="lesson.label.progress.week" /></td>'; // 주차
						html += '	<td>' + v.lessonTimeOrder + '<spring:message code="lesson.label.time" /></td>'; // 교시
						html += '	<td>' + cntsGbn + '</td>';
						html += '	<td>' + (v.lessonCntsNm || '-') + '</td>';
						html += '	<td>' + lbnTm + '</td>';
						html += '	<td>';
						if(v.ltNote && v.ltNoteOfferYn == "Y") {
						html += '		<a href="javascript:ltNoteDown(\'' + v.ltNote + '\', \'' + v.lessonScheduleOrder + '\')" class="ui basic small button ml5" type="button"><spring:message code="lesson.label.lt.note" /></a>'; // 강의노트
						}
						html += '	</td>';
						html += '</tr>';
					});
					
					$("#cntsUsageList").empty().html(html);
					$("#cntsUsageTable").footable();
					$("#totalCntText").text(data.pageInfo.totalRecordCount);
					
					var params = {
						totalCount 	  : data.pageInfo.totalRecordCount,
						listScale 	  : data.pageInfo.recordCountPerPage,
						currentPageNo : data.pageInfo.currentPageNo,
						eventName 	  : "listPaging"
					};
					gfn_renderPaging(params);
				} else {
					alert(data.message);
				}
			}, function(xhr, status, error) {
				alert("<spring:message code='fail.common.msg' />"); // 에러가 발생했습니다!
			}, true);
		}
		
		// 엑셀 다운로드
		function listExcel() {
			$("form[name=excelForm]").remove();
			
			var excelGrid = {
			      colModel:[
			          {label:'<spring:message code="main.common.number.no" />',   		name:'lineNo', 				align:'right',  width:'1000'} // NO.
			        , {label:'<spring:message code="common.label.mng.dept" />',  		name:'deptNm', 				align:'left',   width:'8000'} // 관장학과
			        , {label:'<spring:message code="lesson.label.crs.cd" />',   		name:'crsCd', 				align:'center', width:'2500'} // 학수번호
			        , {label:'<spring:message code="common.charge.professor" />',		name:'userNm', 				align:'left',	width:'5000'} // 담당교수
			        , {label:'<spring:message code="lesson.label.crs.cre.nm" />', 		name:'crsCreNm', 			align:'left',  	width:'8000'} // 과목명
			        , {label:'<spring:message code="common.label.decls.no" />', 		name:'declsNo', 			align:'center',  width:'2500'} // 분반
			        , {label:'<spring:message code="lesson.label.progress.week" />',	name:'lessonScheduleNm', 	align:'left',  	width:'3000'} // 주차
			        , {label:'<spring:message code="lesson.label.time" />',				name:'lessonTimeNm', 		align:'left',  	width:'3000'} // 교시
			        , {label:'<spring:message code="lesson.label.type" />',				name:'cntsGbn', 			align:'left',	width:'4000', codes: CNTS_GBN_OBJ} // 구분
			        , {label:'<spring:message code="lesson.label.cnts.nm" />',			name:'lessonCntsNm', 		align:'left',  	width:'8000'} // 콘텐츠명
			        , {label:'<spring:message code="common.label.time.standar" />',	 	name:'lbnTm', 				align:'right',	width:'2500'} // 기준시간
			    	, {label:'<spring:message code="lesson.label.lt.note" />',			name:'ltNote', 				align:'left',  	width:'20000'} // 강의노트
				]
			};
			
			var crsTypeCdList = [];
			
			$.each($("[data-crs-type-cd]"), function() {
				if($(this).hasClass("active")) {
					crsTypeCdList.push($(this).data("crsTypeCd"));
				}
			});
			
			var excelForm = $('<form></form>');
			excelForm.attr("name","excelForm");
			excelForm.attr("action","/lesson/lessonMgr/downExcelCntsUsage.do");
			excelForm.append($('<input/>', {type: 'hidden', name: 'creYear', 		value: $("#creYear").val()}));
			excelForm.append($('<input/>', {type: 'hidden', name: 'creTerm', 		value: $("#creTerm").val()}));
			excelForm.append($('<input/>', {type: 'hidden', name: 'crsTypeCds', 	value: crsTypeCdList.join(",")}));
			excelForm.append($('<input/>', {type: 'hidden', name: 'univGbn', 		value: ($("#univGbn").val() || "").replace("ALL", "")}));
			excelForm.append($('<input/>', {type: 'hidden', name: 'deptCd', 		value: ($("#deptCd").val() || "").replace("ALL", "")}));
			excelForm.append($('<input/>', {type: 'hidden', name: 'crsCreCd', 		value: ($("#crsCreCd").val() || "").replace("ALL", "")}));
			excelForm.append($('<input/>', {type: 'hidden', name: 'searchValue', 	value: $("#searchValue").val()}));
			excelForm.append($('<input/>', {type: 'hidden', name: 'excelGrid', 		value:JSON.stringify(excelGrid)}));
			excelForm.appendTo('body');
			excelForm.submit();	  
		}
		
		// 강의실 타입 변경
		function changeCrsTypeCd(el) {
			$(el).toggleClass("active");
			
			if($(el).hasClass("active")) {
				$(el).removeClass("basic");
			} else {
				$(el).removeClass("basic").addClass("basic");
			}
		}
		
		// 학기변경
		function changeTerm() {
			$("#univGbn").dropdown("clear");
			$("#deptCd").dropdown("clear");
			$("#crsCreCd").dropdown("clear");
			
			getCrsCreList();
		}
		
		// 과목 목록 조회
		function getCrsCreList() {
			var url = "/crs/creCrsHome/listCrsCreDropdown.do";
			var data = {
				  creYear	: $("#creYear").val()
				, creTerm	: $("#creTerm").val()
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					
					CRS_CRE_LIST = returnList.sort(function(a, b) {
						if(a.crsCreNm < b.crsCreNm) return -1;
						if(a.crsCreNm > b.crsCreNm) return 1;

						if(a.crsCreNm == b.crsCreNm) {
							if(a.declsNo < b.declsNo) return -1;
							if(a.declsNo > b.declsNo) return 1;
						}
						return 0;
					});
					
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
		
		// 대학 구분 변경
		function changeUnivGbn(univGbn) {
			var deptCdObj = {};
			
			CRS_CRE_LIST.forEach(function(v, i) {
				if((univGbn == "ALL" || v.univGbn == univGbn) && v.deptCd) {
					deptCdObj[v.deptCd] = true;
				}
			});
			
			var html = '';
			html += '<option value="ALL"><spring:message code="common.all" /></option>'; // 전체
			USER_DEPT_LIST.forEach(function(v, i) {
				if(deptCdObj[v.deptCd]) {
					html += '<option value="' + v.deptCd + '">' + v.deptNm + '</option>';
				}
			});
			
			// 부서 초기화
			$("#deptCd").html(html);
			$("#deptCd").dropdown("clear");
			
			changeDeptCd("ALL");
		}
		
		// 부서변경
		function changeDeptCd(deptCd) {
			var univGbn = ($("#univGbn").val() || "").replace("ALL", "");
			var deptCd = (deptCd || "").replace("ALL", "");
			
			var html = '';
			html += '<option value="ALL"><spring:message code="common.all" /></option>'; // 전체
			CRS_CRE_LIST.forEach(function(v, i) {
				if((!univGbn || v.univGbn == univGbn) && (!deptCd || v.deptCd == deptCd)) {
					var declsNo = v.declsNo;
					declsNo = '(' + declsNo + ')';
					
					html += '<option value="' + v.crsCreCd + '">' + v.crsCreNm + declsNo + '</option>';
				}
			});
			
			// 부서 초기화
			$("#crsCreCd").html(html);
			$("#crsCreCd").dropdown("clear");
		}
		
		// 강의노트 다운로드
		function ltNoteDown(ltNote, lessonScheduleOrder) {
			<%
	    	String agentS = request.getHeader("User-Agent") != null ? request.getHeader("User-Agent") : "";
	        String appIos = "N"; 
	        if (agentS.indexOf("hycuapp") > -1 && (agentS.indexOf("iPhone") > -1 || agentS.indexOf("iPad") > -1)) {
	        	appIos = "Y";
	        }
	    	%>
	    	
	    	var creNm = encodeURIComponent("${creCrsVO.crsCreNm}");
	    	var fileName = creNm+"_"+(lessonScheduleOrder.length < 2 ? "0"+lessonScheduleOrder : lessonScheduleOrder);
	    	var viewPath = "{\"path\":\""+ltNote+"\",\"fileName\":\""+fileName+"\",\"date\":\""+(new Date().getTime())+"\"}";
	    	var ltNoteUrl = "<%=CommConst.EXT_URL_LONOTE_VIEWER%>" + btoa(viewPath);
	    	
	    	var appIos = "<%=appIos%>";
	    	if (appIos == "Y") {
	    		document.location.href = ltNoteUrl;
	    	}
	    	else {
	    		window.open(ltNoteUrl, '_blank');
	    	}
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
			<div class="content">
				<!-- 타이틀 -->
				<div id="info-item-box">
					<h2 class="page-title flex-item">
						 <spring:message code="lesson.label.lesson.cnts.status" /><!-- 콘텐츠 현황 -->
					</h2>
				</div>
				<div class="ui divider mt0"></div>
				<div class="ui form">
					<!-- 검색영역 -->
					<div class="ui segment searchArea">
						<div class="ui buttons mb10">
				            <button class="ui blue button active" data-crs-type-cd="UNI" onclick="changeCrsTypeCd(this)"><spring:message code="common.button.uni" /><!-- 학기제 --></button>
				            <button class="ui basic blue button" data-crs-type-cd="LEGAL" onclick="changeCrsTypeCd(this)"><spring:message code="common.button.legal" /><!-- 법정교육 --></button>
				            <button class="ui basic blue button" data-crs-type-cd="OPEN" onclick="changeCrsTypeCd(this)"><spring:message code="common.button.open" /><!-- 공개강좌 --></button>
				        </div>
						<div class="fields">
							<div class="two wide field">
								<!-- 개설년도 -->
								<select class="ui fluid dropdown selection" id="creYear" onchange="changeTerm()">
									<c:forEach var="item" begin="2019" end="${termVO.haksaYear + 2}" step="1">
										<option value="${item}" ${item eq termVO.haksaYear ? 'selected' : ''}><c:out value="${item}" /></option>
									</c:forEach>
								</select>
							</div>
							<div class="two wide field">
								<!-- 개설학기 -->
								<select class="ui fluid dropdown selection" id="creTerm" onchange="changeTerm()">
									<c:forEach var="item" items="${haksaTermList}">
										<option value="${item.codeCd}" ${item.codeCd eq termVO.haksaTerm ? 'selected' : ''}><c:out value="${item.codeNm}" /></option>
									</c:forEach>
								</select>
							</div>
							<c:if test="${orgId eq 'ORG0000001'}">
								<div class="two wide field">
									<!-- 대학구분 -->
									<select class="ui fluid dropdown selection" id="univGbn">
										<option value=""><spring:message code="exam.label.org.type" /></option>
										<option value="ALL"><spring:message code="common.all" /><!-- 전체 --></option>
			                    		<c:forEach var="item" items="${univGbnList}">
											<option value="${item.codeCd}" ${item.codeCd}><c:out value="${item.codeNm}" /></option>
										</c:forEach>
									</select>
								</div>
							</c:if>
	                        <!-- 학과 선택 -->
							<div class="three wide field">
								<select class="ui fluid dropdown selection" id="deptCd" onchange="changeDeptCd(this.value)">
									<option value=""><spring:message code="user.title.userdept.select" /></option>
									<option value="ALL"><spring:message code="common.all" /><!-- 전체 --></option>
									<c:forEach var="item" items="${deptCdList}">
										<option value="${item.deptCd}">${item.deptNm}</option>
									</c:forEach>
								</select>
							</div>
							<!-- 과목 선택 -->
							<div class="four wide field">
								<select class="ui fluid dropdown selection" id="crsCreCd">
									<option value=""><spring:message code="common.subject.select" /></option>
								</select>
							</div>
							<div class="three wide field ">
	                            <label class="blind"></label>
	                            <div class="ui input">
	                                <input id="searchValue" type="text" placeholder="<spring:message code="lesson.label.crs.cre.nm" />/<spring:message code="lesson.label.crs.cd" />/<spring:message code='exam.label.tch.nm' />" /><!-- 과목명/학수번호/교수명 -->
	                            </div>
	                        </div>
						</div>
	                    <div class="button-area mt10 tc">
	                        <a href="javascript:void(0)" onclick="listPaging(1);" class="ui blue button w100"><spring:message code="common.button.search" /></a><!-- 검색 -->
	                    </div>
					</div>
					<!-- //검색영역 -->
					<div class="option-content gap4">
						<h3 class="graduSch"><spring:message code="lesson.label.lesson.cnts.status" /></h3><!-- 콘텐츠 현황 -->
						[&nbsp;<span class="fcBlue" id="totalCntText">0</span>&nbsp;<spring:message code="common.page.total_count" /><!-- 건 -->&nbsp;]
						<div class="mla">
							<a href="javascript:listExcel()" class="ui green button"><spring:message code="button.download.excel" /></a><!-- 엑셀다운로드 -->
							<select class="ui dropdown list-num" id="listScale">
								<option value="15">15</option>
								<option value="30">30</option>
								<option value="45">45</option>
								<option value="60">60</option>
								<option value="75">75</option>
								<option value="90">90</option>
								<option value="105">105</option>
							</select>
						</div>
					</div>
					<table class="table" data-sorting="false" data-paging="false" data-empty="<spring:message code='common.nodata.msg' />" id="cntsUsageTable"><!-- 등록된 내용이 없습니다. -->
						<thead>
							<tr>
								<th scope="col" class="num"><spring:message code="main.common.number.no" /></th><!-- NO. -->
								<th scope="col"><spring:message code="common.label.mng.dept" /></th><!-- 관장학과 -->
								<th scope="col"><spring:message code="lesson.label.crs.cd" /></th><!-- 학수번호 -->
								<th scope="col"><spring:message code="common.charge.professor" /></th><!-- 담당교수 -->
								<th scope="col"><spring:message code="lesson.label.crs.cre.nm" /></th><!-- 과목명 -->
								<th scope="col"><spring:message code="lesson.label.progress.week" /></th>	<!-- 주차 -->
								<th scope="col"><spring:message code="lesson.label.time" /></th><!-- 교시 -->
								<th scope="col"><spring:message code="lesson.label.type" /></th><!-- 구분 -->
								<th scope="col"><spring:message code="lesson.label.cnts.nm" /></th><!-- 콘텐츠명 -->
								<th scope="col"><spring:message code="common.label.time.standar" /></th><!-- 기준시간 -->
								<th scope="col"><spring:message code="lesson.label.lt.note" /></th><!-- 강의노트 -->
							</tr>
						</thead>
						<tbody id="cntsUsageList">
						</tbody>
					</table>
					<div id="paging" class="paging"></div>
				</div>
				<!-- //ui form -->
			</div>
			<!-- //본문 content 부분 -->
		</div>
		<!-- footer 영역 부분 -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
	</div>
</body>
</html>