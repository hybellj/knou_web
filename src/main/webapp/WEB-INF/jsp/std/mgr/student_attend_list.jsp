<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" >
<head>
	<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	
	<script type="text/javascript">
		var REFRESH_SEARCH_OBJ = {};
	
		$(document).ready(function(){
			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == "13") {
					userList(1);
				}
			});
			
			crsCreList();
		});
		
		// 과목 목록
		function crsCreList() {
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
			var deptCd = $("#deptCd").val() == "ALL" ? "" : $("#deptCd").val();
			var url  = "/crs/creCrsHome/creCrsList.do";
			var data = {
				  creYear	  	: $("#creYear").val()
				, creTerm	  	: $("#creTerm").val()
				, deptCd   	  	: deptCd
				, pagingYn   	: "N"
				, searchFrom	: "ALL"
				, crsTypeCd		: crsTypeCd
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
	        		var returnList = data.returnList || [];
	        		var html = "<option value='ALL'><spring:message code='common.subject' /></option>";/* 과목 */
	        		
	        		if(returnList.length > 0) {
	        			returnList.forEach(function(v, i) {
	        				html += "<option value='"+v.crsCreCd+"'>"+v.crsCreNm+"</option>";
	        			});
	        		}
	        		
	        		$("#crsCreCd").empty().html(html);
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
			}, true);
		}
		
		//과정유형 선택
		function selectContentCrsType(obj) {
			if($(obj).hasClass("basic")){
				$(obj).removeClass("basic").addClass("active");
			} else {
				$(obj).removeClass("active").addClass("basic");
			}
			crsCreList();
		}
		
		// 사용자 목록
		function userList(page, isRefresh) {
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
			var url  = "/std/stdMgr/listStudentRecord.do";
			var param = $.extend({
				  creYear	  	: $("#creYear").val()
				, creTerm	  	: $("#creTerm").val()
				, deptCd   	  	: $("#deptCd").val()
				, searchValue 	: $("#searchValue").val()
				, pageIndex   	: page
				, listScale   	: $("#listScale").val()
				, crsTypeCd		: crsTypeCd
				, crsCreCd		: $("#crsCreCd").val()
				, studyStatusCd : $("#studyStatusCd").val()
			}, isRefresh ? REFRESH_SEARCH_OBJ : {});
			
			$.ajax({
				url : url,
				data: param,
				type: "POST",
				beforeSend : function(){
					showLoading();
				},
				success : function(data, status, xr){
					if (data.result > 0) {
		        		var returnList = data.returnList || [];
		        		var html = "";
		        		
		        		if(returnList.length > 0) {
		        			returnList.forEach(function(v, i) {
		        				var prgrRatio	= v.crsTypeCd == "LEGAL" ? v.prgrRatio + "%" : "-";
		        				var complClass = '';
		        				var studyStatusNm = '-';
		        				
		        				if(v.studyStatusCd == "COMPLETE") {
		        					studyStatusNm = '<spring:message code="std.label.compl" />'; // 이수자
		        				} else if(v.studyStatusCd == "STUDY" || v.studyStatusCd == "NOSTUDY") {
		        					complClass = 'fcRed';
		        					studyStatusNm = '<spring:message code="std.label.non.compl" />'; // 미이수자
		        				}
		        				
		        				html += "<tr>";
		        				html += "	<td>";
		        				html += "		<div class='ui checkbox'>";
		        				html += "			<input type='checkbox' name='evalChk' id='evalChk"+i+"' onchange='checkStd(this)' user_id='"+v.userId+"' user_nm='"+v.userNm+"' mobile='"+v.mobileNo+"' email='"+v.email+"' crs_type_cd='" + v.crsTypeCd + "' study_status_cd='" + v.studyStatusCd + "' crs_cre_cd='" + v.crsCreCd + "' std_no='" + v.stdNo + "'>";
		        				html += "			<label class='toggle_btn' for='evalChk"+i+"'></label>";
		        				html += "		</div>";
		        				html += "	</td>";
		        				html += "	<td>" + v.lineNo + "</td>";
		        				html += "	<td>" + v.deptNm + "</td>";
		        				html += "	<td>" + v.userId + "</td>";
		        				html += "	<td>" + v.userNm + "</td>";
		        				html += "	<td>" + v.hy + "</td>";
		        				html += "	<td>" + formatPhoneNumber(v.mobileNo) + "</td>";
		        				html += "	<td>" + v.schregGbn + "</td>";
		        				html += "	<td>" + v.crsCreNm + " (" + v.declsNo + ")" + "</td>";
		        				html += "	<td>" + prgrRatio + "</td>";
		        				html += "	<td class='"+complClass+"'>" + studyStatusNm + "</td>";
		        				html += "	<td><button class='ui small basic button' onclick='attendPop(\""+v.userId+"\", \""+v.crsCreCd+"\")'><spring:message code='std.label.study_history' /></button></td>";/* 학습 기록 */
		        				html += "</tr>";
		        			});
		        		}
		        		
		        		$("#userTbody").empty().html(html);
		        		var params = {
		    				totalCount 	  	: data.pageInfo.totalRecordCount,
		    				listScale 	  	: data.pageInfo.recordCountPerPage,
		    				currentPageNo 	: data.pageInfo.currentPageNo,
		    				eventName 	  	: "userList"
		    			};
		    			
		    			gfn_renderPaging(params);
					    $("#userTable").footable();
					    
					    REFRESH_SEARCH_OBJ = param;
		            } else {
		             	alert(data.message);
		            }
					hideLoading();
				},
				error : function(xhr, status, error){
					hideLoading();
					alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
				},
				complete : function(){
					hideLoading();
				},
				timeout: 300000
			});
		}
		
		// 학습 기록 팝업
		function attendPop(userId, crsCreCd) {
			$("#attendForm input[name=userId]").val(userId);
			$("#attendForm input[name=crsCreCd]").val(crsCreCd);
			$("#attendForm input[name=creYear]").val($("#creYear").val());
			$("#attendForm input[name=creTerm]").val($("#creTerm").val());
			$("#attendForm").attr("target", "attendPopIfm");
	        $("#attendForm").attr("action", "/std/stdMgr/studentAttendListPop.do");
	        $("#attendForm").submit();
	        $('#attendPop').modal('show');
		}
		
		// 체크이벤트
		function checkStd(obj) {
			if(obj.value == "all") {
				$("input:checkbox[name=evalChk]").prop("checked", obj.checked);
			} else {
				$("#allChk").prop("checked", $("input[name=evalChk]").length == $("input[name=evalChk]:checked").length);
			}
		}
		
		// 쪽지 보내기
		function sendMsg() {
			var rcvUserInfoStr = "";
			var sendCnt = 0;
			var dupCheckObj = {};
			
			$.each($('#userTbody').find("input:checkbox[name=evalChk]:not(:disabled):checked"), function() {
				var userId = $(this).attr("user_id");
				
				if (dupCheckObj[userId])
					return true;
				dupCheckObj[userId] = true;
				
				sendCnt++;
				if (sendCnt > 1) rcvUserInfoStr += "|";
				rcvUserInfoStr += $(this).attr("user_id");
				rcvUserInfoStr += ";" + $(this).attr("user_nm"); 
				rcvUserInfoStr += ";" + $(this).attr("mobile");
				rcvUserInfoStr += ";" + $(this).attr("email"); 
			});
			
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
		
		function downExcel() {
			$("form[name=excelForm]").remove();
			
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
			
			var excelGrid = {
			    colModel:[
		            {label:'<spring:message code="common.number.no"/>', 				name:'lineNo', 			align:'right', 	width:'1000'},	
		            {label:'<spring:message code="common.dept_name" />', 				name:'deptNm', 			align:'left', 	width:'7000'}, // 학과
		            {label:'<spring:message code="common.label.student.number" />', 	name:'userId', 			align:'left', 	width:'3000'}, // 학번
		            {label:'<spring:message code="common.name" />', 					name:'userNm', 			align:'left', 	width:'5000'}, // 이름
		            {label:'<spring:message code="common.label.userdept.grade" />', 	name:'hy', 				align:'center', width:'2000'}, // 학년
		            {label:'<spring:message code="user.title.userinfo.phoneno" />', 	name:'mobileNo', 		align:'center', width:'5000'}, // 학년
		            {label:'<spring:message code="user.title.userinfo.user.stats" />', 	name:'schregGbn', 		align:'center', width:'3000'}, // 학적상태
		            {label:'<spring:message code="common.label.enroll.course" />', 		name:'crsCreNm', 		align:'left', 	width:'9000'}, // 수강과목
		            {label:'<spring:message code="common.label.decls.no" />', 			name:'declsNo', 		align:'center', width:'2500'}, // 분반
		            {label:'<spring:message code="crs.common.progress.rate" />', 		name:'prgrRatio', 		align:'right', 	width:'2500'}, // 진도율
		            {label:'<spring:message code="std.label.compl.status" />', 			name:'studyStatusCd', 	align:'center', width:'2500', codes: {COMPLETE: '<spring:message code="std.label.compl" />', NOSTUDY: '<spring:message code="std.label.non.compl" />', STUDY: '<spring:message code="std.label.non.compl" />'}}, // 이수여부
	            ]
			};
			
			var url  = "/std/stdMgr/downExcelStudentRecord.do";
			var form = $("<form></form>");
			form.attr("method", "POST");
			form.attr("name", "excelForm");
			form.attr("action", url);
			form.append($('<input/>', {type: 'hidden', name: 'creYear',			value: $("#creYear").val()}));
			form.append($('<input/>', {type: 'hidden', name: 'creTerm', 		value: $("#creTerm").val()}));
			form.append($('<input/>', {type: 'hidden', name: 'deptCd',			value: $("#deptCd").val()}));
			form.append($('<input/>', {type: 'hidden', name: 'searchValue',		value: $("#searchValue").val()}));
			form.append($('<input/>', {type: 'hidden', name: 'crsTypeCd', 		value: crsTypeCd}));
			form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', 		value: $("#crsCreCd").val()}));
			form.append($('<input/>', {type: 'hidden', name: 'studyStatusCd', 	value: $("#studyStatusCd").val()}));
			form.append($('<input/>', {type: 'hidden', name: 'pagingYn', 		value: "N"}));
			form.append($('<input/>', {type: 'hidden', name: 'excelGrid',   	value: JSON.stringify(excelGrid)}));
			form.appendTo("body");
			form.submit();
		}
		
		// 법정교육 학습상태 변경
		function saveLegalStatus() {
			if(!confirm('<spring:message code="common.save.msg" />')) return; // 저장하시겠습니까?
			
			var saveList = [];
			var isValid = true;
			
			var studyStatusCd = $("#studyStatusCdChange").val();
			
			if(!studyStatusCd) {
				alert('<spring:message code="common.alert.data.type.select" />'); // 분류를 선택하세요.
				return;
			}
			
			$.each($('#userTbody').find("input:checkbox[name=evalChk]:not(:disabled):checked"), function() {
				var userId = $(this).attr("user_id");
				var stdNo = $(this).attr("std_no");
				var crsTypeCd = $(this).attr("crs_type_cd");
				var crsCreCd = $(this).attr("crs_cre_cd");
				
				if(crsTypeCd != "LEGAL") {
					alert('<spring:message code="lesson.error.only.legal" />'); // 법정교육 수강생만 가능합니다.
					isValid = false;
					return false;
				}
				
				saveList.push({
					  userId: userId
					, stdNo: stdNo
					, crsCreCd: crsCreCd
					, studyStatusCd: studyStatusCd
				});
			});
			
			if(!isValid) return;
			
			if(saveList.length == 0) {
				alert('<spring:message code="common.student.choice" />'); // 수강생을 선택해주세요.
				return;
			}
			
			var url  = "/lesson/lessonMgr/saveLegalStudyStatus.do";
			var data = JSON.stringify(saveList);
			
			$.ajax({
				url: url,
				type: "POST",
				contentType: "application/json",
				data: data,
				dataType: "json",
				beforeSend : function() {
					showLoading();
				},
				success: function(data) {
					if(data.result === 1) {
						alert('<spring:message code="common.result.success" />'); // 성공적으로 작업을 완료하였습니다.
						userList(1, true);
					} else {
						alert(data.message);
					}
				},
				error: function(xhr, status, error) {
					alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
				},
				complete: function() {
					hideLoading();
				},
			});
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
				<div id="info-item-box">
					<h2 class="page-title flex-item">
						<spring:message code="exam.label.study" /><!-- 수업 -->
						<div class="ui breadcrumb small">
					        <small class="section"><spring:message code="std.label.learner_record" /><!-- 수강생별 학습기록 --></small>
					    </div>
					
					</h2>
				</div>
				<div class="ui divider mt0"></div>
				<div class="ui form">
					<!-- 검색조건 -->
					<div class="option-content">
		            	<div class="ui buttons">
		            		<%
                			if (SessionInfo.isKnou(request)) {
	                			%>
					        	<button class="ui blue button active crsTypeBtn" data-crs-type-cd="UNI" onclick="selectContentCrsType(this)"><spring:message code="crs.label.crs.uni" /><!-- 학기제 --></button>
					        	<%-- <button class="ui basic blue button crsTypeBtn" data-crs-type-cd="CO" onclick="selectContentCrsType(this)"><spring:message code="crs.label.crs.co" /><!-- 기수제 --></button> --%>
					        	<button class="ui basic blue button crsTypeBtn" data-crs-type-cd="LEGAL" onclick="selectContentCrsType(this)"><spring:message code="crs.label.crs.court" /><!-- 법정교육 --></button>
					        	<%
                			}
					        %>
			            </div>
		            </div>
					<div class="ui segment searchArea">
						<select class="ui dropdown mr5" id="creYear" onchange="crsCreList()">
							<c:forEach var="item" items="${yearList }">
								<option value="${item }" ${item eq termVO.haksaYear ? 'selected' : '' }>${item }</option>
							</c:forEach>
						</select>
						<select class="ui dropdown mr5" id="creTerm" onchange="crsCreList()">
							<c:forEach var="item" items="${termList }">
								<option value="${item.codeCd }" ${item.codeCd eq termVO.haksaTerm ? 'selected' : '' }>${item.codeNm }</option>
							</c:forEach>
						</select>
						<select class="ui dropdown mr5 w200" id="deptCd" onchange="crsCreList()">
							<option value="ALL"><spring:message code="common.dept_name" /><!-- 학과 --></option>
							<c:forEach var="item" items="${deptList }">
								<option value="${item.deptCd }">${item.deptNm }</option>
							</c:forEach>
						</select>
						<select class="ui dropdown mr5 w200" id="crsCreCd">
							<option value="ALL"><spring:message code="common.subject" /><!-- 과목 --></option>
						</select>
						<div class="ui input search-box mr5">
						    <input type="text" placeholder="학번/이름 검색" class="w250" id="searchValue" />
						</div>
						<select class="ui dropdown" id="studyStatusCd">
							<option value="ALL"><spring:message code="std.label.compl.status" /><!-- 이수여부 --></option>
							<option value="NOSTUDY"><spring:message code="std.label.non.compl" /><!-- 미이수 --></option>
							<option value="COMPLETE"><spring:message code="std.label.compl" /><!-- 이수 --></option>
						</select>
						<div class="button-area mt10 tc">
							<a href="javascript:void(0)" class="ui blue button w100" onclick="userList()"><spring:message code="exam.button.search" /><!-- 검색 --></a>
						</div>
					</div>
					<div class="option-content">
						<div class="button-area">
							<select class="ui dropdown" id="studyStatusCdChange">
								<option value=""><spring:message code="common.select" /><!-- 선택 --></option>
								<option value="NOSTUDY"><spring:message code="std.label.non.compl" /><!-- 미이수 --></option>
								<option value="COMPLETE"><spring:message code="std.label.compl" /><!-- 이수 --></option>
							</select>
							<a href="javascript:saveLegalStatus()" class="ui orange button"><spring:message code="common.button.save" /><!-- 저장 --></a>
							<uiex:msgSendBtn func="sendMsg()" styleClass="ui basic button"/><!-- 메시지 -->
							<a class="ui green button" href="javascript:downExcel()"><spring:message code="exam.button.excel.down" /><!-- 엑셀 다운로드 --></a>
							<select class="ui dropdown" id="listScale">
								<option value="10">10</option>
								<option value="20">20</option>
								<option value="50">50</option>
								<option value="100">100</option>
								<option value="1000">1000</option>
								<option value="2000">2000</option>
								<option value="5000">5000</option>
							</select>
						</div>
					</div>
					
					<!-- 수강생 목록 -->
					<table class="table type2" data-sorting="false" data-paging="false" data-empty="<spring:message code='user.common.empty' />" id="userTable"><!-- 등록된 내용이 없습니다. -->
						<thead>
							<tr>
								<th scope="col" class="w30">
									<div class="ui checkbox">
									    <input type="checkbox" name="allEvalChk" id="allChk" value="all" onchange="checkStd(this)">
									    <label class="toggle_btn" for="allChk"></label>
									</div>
								</th>
								<th scope="col" class="num">No</th>
								<th scope="col"><spring:message code="common.dept_name" /><!-- 학과 --></th>
								<th scope="col"><spring:message code="common.label.student.number" /><!-- 학번 --></th>
								<th scope="col"><spring:message code="common.name" /><!-- 이름 --></th>
								<th scope="col"><spring:message code="common.label.userdept.grade" /><!-- 학년 --></th>
								<th scope="col"><spring:message code="user.title.userinfo.phoneno" /><!-- 전화번호 --></th>
								<th scope="col"><spring:message code="user.title.userinfo.user.stats" /><!-- 학적상태 --></th>
								<th scope="col"><spring:message code="common.label.enroll.course" /><!-- 수강과목 -->(<spring:message code="common.label.decls.no" /><!-- 분반 -->)</th>
								<th scope="col"><spring:message code="crs.common.progress.rate" /><!-- 진도율 --></th>
								<th scope="col"><spring:message code="std.label.compl.status" /><!-- 이수여부 --></th>
								<th scope="col"><spring:message code="common.mgr" /><!-- 관리 --></th>
							</tr>
						</thead>
						<tbody id="userTbody"></tbody>
					</table>
					<div id="paging" class="paging mt10"></div>
					
				</div><!-- //ui form -->
			</div><!-- //content stu_section -->
			<%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
		</div><!-- //container -->
		
	</div><!-- //wrap -->
	
	<!-- 학습자 학습 기록 팝업 --> 
	<div class="modal fade" id="attendPop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="std.label.study_history" />" aria-hidden="false">
		<form id="attendForm" method="POST">
			<input type="hidden" name="userId" />
			<input type="hidden" name="crsCreCd" />
			<input type="hidden" name="creYear" />
			<input type="hidden" name="creTerm" />
		</form>
	    <div class="modal-dialog modal-extra-lg" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code='user.button.close' />"><!-- 닫기 -->
	                    <span aria-hidden="true">&times;</span>
	                </button>
	                <h4 class="modal-title"><spring:message code="std.label.study_history" /></h4><!-- 학습 기록 -->
	            </div>
	            <div class="modal-body">
	                <iframe src="" id="attendPopIfm" name="attendPopIfm" width="100%" scrolling="no"></iframe>
	            </div>
	        </div>
	    </div>
	</div>
	<script>
	    $('iframe').iFrameResize();
	    window.closeModal = function() {
	        $('.modal').modal('hide');
	    };
	</script>
</body>
</html>