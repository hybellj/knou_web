<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	
	<script type="text/javascript">
		var USER_DEPT_LIST = [];
		var CRS_CRE_LIST   = [];
		var SORT_OBJ = {
			  crsCd: "ASC"
			, crsCreNm: "ASC"
			, profUserId: "ASC"
			, profUserNm: "ASC"
			, tutUserId: "ASC"
			, tutUserNm: "ASC"
			, deptNm: "ASC"
			, objtUserId: "ASC"
			, objtUserNm: "ASC"
			, hy: "ASC"
			, prvScore: "ASC"
			, prvGrade: "ASC"
			, modScore: "ASC"
			, modGrade: "ASC"
			, procNm: "ASC"
		}; // 테이블 sort
			
			
		$(function(){
			// 부서정보
			<c:forEach var="item" items="${deptList}">
				USER_DEPT_LIST.push({
					  deptCd: '<c:out value="${item.deptCd}" />'
					, deptNm: '<c:out value="${item.deptNm}" />'
				});
			</c:forEach>
			
			// 부서명 정렬
			USER_DEPT_LIST.sort(function(a, b) {
				if(a.deptNm < b.deptNm) return -1;
				if(a.deptNm > b.deptNm) return 1;
				return 0;
			});
			
			changeTerm();
			
			$("#searchValue").on("keyup", function(e) {
				if(e.keyCode == 13) {
					onObjtSearch(1);
				}
			});
		
			// 버튼-추가
			$("#btnObjtAdd").on("click", function(){
				if($("#selCrsCreCd").val() == "") {
					/* 개설과목이 없습니다. */
					alert('<spring:message code="score.label.ect.eval.oper.msg18" />');
					return false;
				}
				
				var uniCd = $("#selCrsCreCd option:selected").data("uniCd");
				
				checkJobSch($("#selCrsCreCd").val(), uniCd).done(function() {
					$("#modalScoreReCfmTchRegForm input[name=crsCreCd]").val($("#selCrsCreCd").val());
					$("#modalScoreReCfmTchRegForm").attr("target", "modalScoreReCfmTchRegIfm");
				    $("#modalScoreReCfmTchRegForm").attr("action", "/score/scoreOverall/scoreOverallScoreReCfmTchRegPopup.do");
				    $("#modalScoreReCfmTchRegForm").submit();
				    $("#modalScoreReCfmTchReg").modal('show');
				});
			});
		
			//버튼-엑셀다운로드
			$("#btnObjtExcel").on("click", function(){
				$("form[name=paperExcelForm]").remove();
				var url  = "/score/scoreOverall/selectScoreObjtExcelDownAdmin.do";
				var form = $("<form></form>");
				form.append($('<input/>', {type: 'hidden', name: 'crsTypeCd', value: 'UNI'}));
				form.append($('<input/>', {type: 'hidden', name: 'haksaYear', value: $("#creYear").val()}));
				form.append($('<input/>', {type: 'hidden', name: 'haksaTerm', value: $("#creTerm").val()}));
				form.append($('<input/>', {type: 'hidden', name: 'uniCd', value: ($("#uniCd").val() || "").replace("ALL", "")}));
				form.append($('<input/>', {type: 'hidden', name: 'deptCd', value: ($("#deptCd").val() || "").replace("ALL", "")}));
				form.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: ($("#crsCreCd").val() || "").replace("ALL", "")}));
				form.append($('<input/>', {type: 'hidden', name: 'searchValue', value: $("#searchValue").val()}));
				form.append($('<input/>', {type: 'hidden', name: 'procCd', value: ($("#procCd").val() || "").replace("ALL", "")}));
				form.attr("method", "POST");
				form.attr("name", "paperExcelForm");
				form.attr("action", url);
				form.appendTo("body");
				form.submit();
			});
			onObjtSearch();
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
					changeUniCd("ALL");
					
					$("#uniCd").on("change", function() {
						changeUniCd(this.value);
					});
		    	} else {
		    		alert(data.message);
		    	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		}
		
		// 대학구분 변경
		function changeUniCd(uniCd) {
			var deptCdObj = {};
			
			this["CRS_CRE_LIST"].forEach(function(v, i) {
				if((uniCd == "ALL" || v.uniCd == uniCd) && v.deptCd) {
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
			var uniCd = ($("#uniCd").val() || "").replace("ALL", "");
			var deptCd = (deptCd || "").replace("ALL", "");
			
			var html = '<option value="ALL"><spring:message code="common.subject.select" /></option>'; // 과목 선택
			var sHtml = "";
			
			$("#selCrsCreCd").empty();
			$("#selCrsCreCd").dropdown("clear");
			
			CRS_CRE_LIST.forEach(function(v, i) {
				if(v.crsTypeCd != "UNI") return;
				
				if((!uniCd || v.uniCd == uniCd) && (!deptCd || v.deptCd == deptCd)) {
					var declsNo = v.declsNo;
					declsNo = '(' + declsNo + ')';
					
					html += '<option value="' + v.crsCreCd + '">' + v.crsCreNm + declsNo + '</option>';
					sHtml += "<option value='" + v.crsCreCd + "'  data-uni-cd='" + v.uniCd + "'>" + v.crsCreNm + "</option>";
				}
			});
			
			$("#crsCreCd").html(html);
			$("#crsCreCd").dropdown("clear");
			$("#selCrsCreCd").html(sHtml);
			$("#selCrsCreCd").dropdown("set text", $("#selCrsCreCd > option:selected")[0] && $("#selCrsCreCd > option:selected")[0].innerText);
			onChangeTerm();
		}
		
		function onChangeTerm(){
			var param = {
				creYear    : $("#creYear").val()
			  , creTerm    : $("#creTerm").val()
			}
			
			ajaxCall("/score/scoreOverall/selectScoreObjtCtgrAdmin.do", param, function(data) {
				if(data.result > 0) {
					if(data.returnVO != null || data.returnSubVO != null) {
						var msg = "";
						
						if(data.returnVO) {
							msg = "<spring:message code='common.label.score.reconfirm.yn.processing' /> (<spring:message code='common.label.uni.college' />): " + getDateFmt(data.returnVO.schStartDt) + " ~ " + getDateFmt(data.returnVO.schEndDt) + "<br />";
						}
						
						if(data.returnSubVO) {
							msg += "<spring:message code='common.label.score.reconfirm.yn.processing' /> (<spring:message code='common.label.uni.graduate' />): " + getDateFmt(data.returnSubVO.schStartDt) + " ~ " + getDateFmt(data.returnSubVO.schEndDt);
						}
						
						$("#ctgrView").html(msg); // 성적재확인 신청처리기간
					} else {
						$("#ctgrView").html("<spring:message code='common.label.score.reconfirm.yn.processing' /> : -"); // 성적재확인 신청처리기간
					}
				} else {
					alert(data.message);
				}
			}, function(xhr, status, error) {
				/* 에러가 발생했습니다! */
				alert('<spring:message code="fail.common.msg" />');
			}, true);
		}
		
		function onObjtSearch(){
			var url = "/score/scoreOverall/selectScoreObjtListAdmin.do";
		
			var param = {
					crsTypeCd   : "UNI"
				  , haksaYear   : $("#creYear").val()
				  , haksaTerm   : $("#creTerm").val()
				  , uniCd	    : ($("#uniCd").val() || "").replace("ALL", "")
				  , deptCd      : ($("#deptCd").val() || "").replace("ALL", "")
				  , crsCreCd    : ($("#crsCreCd").val() || "").replace("ALL", "")
				  , searchValue	: $("#searchValue").val()
				  , procCd		: ($("#procCd").val() || "").replace("ALL", "")
			}
		
			ajaxCall(url, param, function(data) {
				if(data.result > 0) {
					var html = "";
					
					if(data.returnList.length > 0){
						$.each(data.returnList, function(i, o){
							html += "<tr>";
							html += "    <td class='tc'><div class='ui checkbox'><input type='checkbox' name='objtDataChk' tabindex='0' prof_user_id='" + o.profUserId + "' prof_user_nm='" + o.profUserNm + "' prof_mobile='" + o.profMobileNo + "' prof_email='" + o.profEmail + "' user_id='" + o.objtUserId + "' user_nm='" + o.objtUserNm + "' mobile='" + o.userMobileNo + "' email='" + o.userEmail + "'><label></label></div></td>";
							html += "    <td class='tc'>" + o.lineNo + "</td>";
							html += "    <td class='tc' data-col='crsCd'>" + o.crsCd + "</td>";
							html += "    <td class='tc' data-col='crsCreNm'>" + o.crsCreNm + "</td>";
							html += "    <td class='tc'>" + o.declsNo + "</td>";
							html += "    <td class='tc' data-col='profUserId'>" + o.profUserId + "</td>";
							html += "    <td class='tc' data-col='profUserNm'>" + o.profUserNm + "</td>";
							html += "    <td class='tc' data-col='tutUserId'>" + (o.tutUserId || '-') + "</td>";
							html += "    <td class='tc' data-col='tutUserNm'>" + (o.tutUserNm || '-') + "</td>";
				            html += "    <td class='tc' data-col='deptNm'>" + o.deptNm + "</td>";
				            html += "    <td class='tc' data-col='objtUserId'>" + o.objtUserId + "</td>";
				            html += "    <td class='tc' data-col='objtUserNm'>" + o.objtUserNm + "</td>";
				            html += "    <td class='tc' data-col='hy'>" + (o.hy || '-') + "</td>";
				            html += "    <td class='tc'>";
				            html += "        <a href=\"javascript:onObjtCtntPop('" + o.scoreObjtCd + "');\" class='ui basic small button'><spring:message code='score.label.reason' /></a>";	// 사유
				            html += "    </td>";
				            html += "    <td class='tc' data-col='prvScore'>" + o.prvScore + "</td>";
				            html += "    <td class='tc' data-col='prvGrade'>" + o.prvGrade + "</td>";
				            html += "    <td class='tc' data-col='modScore'>" + o.modScore + "</td>";
				            html += "    <td class='tc' data-col='modGrade'>" + o.modGrade + "</td>";
				            html += "    <td class='tc'>";
				            //if(gfn_isNull(o.procCd)){
				            	html += "        <a href=\"javascript:onObjtProcPop('" + o.objtUserId + "','" + o.crsCreCd + "','" + o.uniCd + "','" + o.scoreObjtCd + "');\" class='ui basic small button'><spring:message code='exam.label.process.process' /></a>";	// 처리하기
				            //} else {
				            //	html += "-";
				            //}
				            html += "    </td>";
				            html += "    <td class='tc' data-col='procNm'>" + o.procNm + "</td>";
				            html += "</tr>";
						});
					} else {
						html += "<tr>";
						html += "    <td colspan='20'>";
						html += "<div class='flex-container min-height-300'>";
						html += "   <div class='no_content'><i class='icon-cont-none ico f170'></i><span><spring:message code='common.no.data.result' /></span></div>";	// 조회된 데이타가 없습니다.
						html += "</div>";
						html += "</td>";
						html += "</tr>";
					}
			
					$("#crscreCnt").html(data.returnList.length);
					$("#objtTbody").empty().html(html);
					//$("#objtTable").footable();
					
					$("#chkObjtAll").prop("checked", false);
				} else {
					alert(data.message);
				}
			}, function(xhr, status, error) {
				// 실패하였습니다.
				alert('<spring:message code="common.message.failed" />');
			}, true);
		}
		
		//사유보기 팝업
		function onObjtCtntPop( scoreObjtCd ){
			$("#modalObjtCtntForm input[name=scoreObjtCd]").val(scoreObjtCd);
			$("#modalObjtCtntForm").attr("target", "modalObjtCtntIfm");
		    $("#modalObjtCtntForm").attr("action", "/score/scoreOverall/scoreOverallObjtCtntPopup.do");
		    $("#modalObjtCtntForm").submit();
		    $("#modalObjtCtnt").modal('show');
		}
		
		//처리하기 팝업
		function onObjtProcPop(objtUserId, crsCreCd, uniCd, scoreObjtCd){
			checkJobSch(crsCreCd, uniCd, true).done(function(jobSchEndYn) {
				if(jobSchEndYn == "Y") {
					$("#modalObjtProcForm").attr("action", "/score/scoreOverall/scoreOverallObjtViewPopup.do");
				} else {
					$("#modalObjtProcForm").attr("action", "/score/scoreOverall/scoreOverallObjtProcPopup.do");
				}
				
				$("#modalObjtProcForm input[name=objtUserId]").val(objtUserId);
				$("#modalObjtProcForm input[name=crsCreCd]").val(crsCreCd);
				$("#modalObjtProcForm input[name=scoreObjtCd]").val(scoreObjtCd);
				$("#modalObjtProcForm").attr("target", "modalObjtProcIfm");
			    $("#modalObjtProcForm").submit();
			    $("#modalObjtProc").modal('show');
			});
		}
		
		//메세지 보내기
		function sendMsg() {
			if($("#objtTbody").find("input[name=objtDataChk]:checked").length == 0){
				/* 체크된 값이 없습니다. */
				alert('<spring:message code="score.label.ect.eval.oper.msg14" />');
				return;
			}
			var rcvUserInfoStr = "";
			var sendCnt = 0;
			var dupCheckObj = {};
		
			$.each($("#objtTbody").find("input[name=objtDataChk]:checked"), function() {
				var userId = $(this).attr("user_id");
				
				if(dupCheckObj[userId])
					return true;
				dupCheckObj[userId] = true;
				
				sendCnt++;
				if (sendCnt > 1) rcvUserInfoStr += "|";
				rcvUserInfoStr += $(this).attr("user_id");
				rcvUserInfoStr += ";" + $(this).attr("user_nm");
				rcvUserInfoStr += ";" + $(this).attr("mobile");
				rcvUserInfoStr += ";" + $(this).attr("email");
			});
		
		    window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");
		
		    var form = document.alarmForm;
		    form.action = "<%=CommConst.SYSMSG_URL_SEND%>";
		    form.target = "msgWindow";
		    form[name='alarmType'].value = "S"; // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
		    form[name='rcvUserInfoStr'].value = rcvUserInfoStr; //보내는사람 정보
		    form.submit();
		}
		
		function sendMsgProf() {
			if($("#objtTbody").find("input[name=objtDataChk]:checked").length == 0){
				/* 체크된 값이 없습니다. */
				alert('<spring:message code="score.label.ect.eval.oper.msg14" />');
				return;
			}
			var rcvUserInfoStr = "";
			var sendCnt = 0;
			var dupCheckObj = {};
		
			$.each($("#objtTbody").find("input[name=objtDataChk]:checked"), function() {
				var profUserId = $(this).attr("prof_user_id");
				
				if (dupCheckObj[profUserId])
					return true;
				dupCheckObj[profUserId] = true;
				
				sendCnt++;
				if (sendCnt > 1) rcvUserInfoStr += "|";
				rcvUserInfoStr += $(this).attr("prof_user_id");
				rcvUserInfoStr += ";" + $(this).attr("prof_user_nm");
				rcvUserInfoStr += ";" + $(this).attr("prof_mobile");
				rcvUserInfoStr += ";" + $(this).attr("prof_email");
			});
		
		    window.open("about:blank", "msgWindow", "scrollbars=yes,width=1280,height=950,location=no,resizable=yes");
		
		    var form = document.alarmForm;
		    form.action = "<%=CommConst.SYSMSG_URL_SEND%>";
		    form.target = "msgWindow";
		    form[name='alarmType'].value = "S"; // 발송구분(SMS:S, PUSH:P, EMAIL:E, 쪽지:N)
		    form[name='rcvUserInfoStr'].value = rcvUserInfoStr; //보내는사람 정보
		    form.submit();
		}
		
		//업무일정 체크
		function checkJobSch(crsCreCd, uniCd, useJobSchEndViewPop) {
			var deferred = $.Deferred();
			
			var calendarCtgr = "";
			
			// 성적재확인신청기간
			if(uniCd == "G") {
				calendarCtgr = "00210205"; // 대학원
			} else {
				calendarCtgr = "00210203"; // 학부
			}
			
			var url = "/jobSchHome/viewSysJobSch.do";
			var data = {
				crsCreCd     	: crsCreCd,
				calendarCtgr 	: calendarCtgr,
				haksaYear	   	: $("#creYear").val(),
				haksaTerm		: $("#creTerm").val(),
			};
			
			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnVO = data.returnVO;
					if(returnVO != null) {
						var jobSchPeriodYn = returnVO.jobSchPeriodYn;
						var schStartDt = returnVO.schStartDt;
						var schEndDt = returnVO.schEndDt;
						var jobSchEndYn = returnVO.jobSchEndYn;
						
						if(jobSchPeriodYn == "Y") {
							deferred.resolve();
						} else if(useJobSchEndViewPop && jobSchEndYn == "Y") {
							deferred.resolve(jobSchEndYn);
						} else {
							var argu = '<spring:message code="score.label.objt" />'; // 성적재확인신청
							var msg = '<spring:message code="score.alert.no.job.sch.period" arguments="' + argu + '" />'; // 기간이 아닙니다.
							
							alert(msg);
							deferred.reject();
						}
					} else {
						alert('<spring:message code="sys.alert.already.job.sch" />'); // 등록된 일정이 없습니다.
						deferred.reject();
					}
		    	} else {
		    		alert(data.message);
		    		deferred.reject();
		    	}
			}, function(xhr, status, error) {
				alert("<spring:message code='exam.error.info' />"); // 정보 조회 중 에러가 발생하였습니다.
				deferred.reject();
			});
			
			return deferred.promise();
		}
		
		//날짜 포멧 변환 (yyyy.mm.dd || yyyy.mm.dd hh:ii)
		function getDateFmt(dateStr) {
			var fmtStr = (dateStr || "");
			
			if(fmtStr.length == 14) {
				fmtStr = fmtStr.substring(0, 4) + '.' + fmtStr.substring(4, 6) + '.' + fmtStr.substring(6, 8) + ' ' + fmtStr.substring(8, 10) + ':' + fmtStr.substring(10, 12);
			} else if(fmtStr.length == 8) {
				fmtStr = fmtStr.substring(0, 4) + '.' + fmtStr.substring(4, 6) + '.' + fmtStr.substring(6, 8);
			}
			
			return fmtStr;
		}
		
		function checkAll(checked) {
			$("#objtTable").find("input:checkbox[name=objtDataChk]:not(:disabled)").prop("checked", checked);
		}
		
		function sortTable(col) {
			$.each(Object.keys(SORT_OBJ), function(i, key) {
				var order = SORT_OBJ[key];
				if(key == col) {
					SORT_OBJ[key] = (order == "ASC" ? "DESC" : "ASC");
				} else {
					SORT_OBJ[key] = "ASC";
				}
			});
			
			var $row = $("#objtTbody").find('tr');
			
			$row.sort(function(a, b) {
				var aCol = $(a).find('[data-col="' + col + '"]')[0].innerText;
				var bCol = $(b).find('[data-col="' + col + '"]')[0].innerText;
				
				if(col == "prvGrade" || col == "modGrade") {
					aCol = convertSortGrade(aCol);
					bCol = convertSortGrade(bCol);
				}
				
				if(SORT_OBJ[col] == "ASC") {
					if(aCol > bCol) return 1;
					if(aCol < bCol) return -1;
				} else {
					if(aCol > bCol) return -1;
					if(aCol < bCol) return 1;
				}
				return 0;
			});
			
			showLoading();
			setTimeout(function() {
				$("#objtTbody").html('');
				$.each($row, function() {
					$("#objtTbody").append(this);
				});
				hideLoading();
			}, 0);
		}
		
		function convertSortGrade(val) {
			var rVal = 99;
			
			if(val == "A+") {
				rVal = 1;
			} else if(val == "A") {
				rVal = 2;
			} else if(val == "B+") {
				rVal = 3;
			} else if(val == "B") {
				rVal = 4;
			} else if(val == "C+") {
				rVal = 5;
			} else if(val == "C") {
				rVal = 6;
			} else if(val == "D+") {
				rVal = 7;
			} else if(val == "D") {
				rVal = 8;
			} else if(val == "P") {
				rVal = 9;
			} else if(val == "F") {
				rVal = 10;
			} else if(val == "-") {
				rVal = 11;
			}
			
			return rVal;
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
            	<div class="ui form">
	                <div id="info-item-box">
	                    <h2 class="page-title flex-item">
							<spring:message code="common.label.mut.eval.score" />
	                    	<div class="ui breadcrumb small">
						        <small class="section"><spring:message code="common.label.score.reconfirm.yn.treat" /></small>
						    </div>
	                    </h2><!-- 성적평가관리 --><!-- 성적재확인 신청처리 -->
	                    <div class="button-area"></div>
	                </div>
					<div class="ui divider mt0"></div>
					<div class="ui form">
						<div class="ui segment searchArea">
		                    <div class="option-content">
			                    <select class="ui dropdown mr5" id="creYear" onchange="changeTerm()">
									<c:forEach var="item" items="${yearList}" varStatus="status">
										<option value="${item}" <c:if test="${item eq termVO.haksaYear}">selected</c:if>>${item}</option>
										<%-- <option value="${item}" <c:if test="${item eq '2024'}">selected</c:if>>${item}</option> --%>
									</c:forEach>
								</select>
								<select class="ui dropdown mr5" id="creTerm" onchange="changeTerm()">
									<c:forEach var="item" items="${termList }">
										<option value="${item.codeCd }" <c:if test="${item.codeCd eq termVO.haksaYear}">selected</c:if>>${item.codeNm }</option>
										<%-- <option value="${item.codeCd }" <c:if test="${item.codeCd eq '20'}">selected</c:if>>${item.codeNm }</option> --%>
									</c:forEach>
								</select>
								<c:if test="${orgId eq 'ORG0000001'}">
									<select id="uniCd" class="ui dropdown mr5" onchange="changeUniCd()">
					                   	<option value=""><spring:message code="common.label.uni.type" /></option><!-- 대학구분 -->
					                   	<option value="ALL"><spring:message code="common.all" /></option><!-- 전체 -->
					                   	<option value="C"><spring:message code="common.label.uni.college" /><!-- 대학교 -->
					                   	<option value="G"><spring:message code="common.label.uni.graduate" /></option><!-- 대학원 -->
					                </select>
				                </c:if>
				                <select id="deptCd" class="ui dropdown mr5 w250" onchange="changeDeptCd()">
		                        	<option value=""><spring:message code="common.dept_name" /><!-- 학과 --> <spring:message code="common.select" /><!-- 선택 --></option>
		                        </select> 
		                        <select id="crsCreCd" class="ui dropdown mr5 w250" onchange="onObjtSearch()">
				                	<option value=""><spring:message code="common.subject" /><!-- 과목 --> <spring:message code="common.select" /><!-- 선택 --></option>
				                </select>
				                <div class="ui input search-box mr5">
			                        <input type="text" placeholder="<spring:message code="exam.label.input" />" name="searchValue" id="searchValue" >
			                    </div>
			                </div>
			                <div class="option-content">
			                	 <select id="procCd" class="ui dropdown mr5 w250" onchange="onObjtSearch()">
				                	<option value=""><spring:message code="score.label.process.status" /><!-- 처리상태 및 결과 --></option>
				                	<option value="ALL"><spring:message code="common.all" /></option><!-- 전체 -->
				                	<option value="0"><spring:message code="score.label.objt.proc0" /><!-- 신청 --></option>
				                	<option value="3"><spring:message code="score.label.objt.proc3" /><!-- 반려(가산점 미부여) --></option>
				                	<option value="2"><spring:message code="score.label.objt.proc2" /><!-- 확인(가산점 미부여) --></option>
				                	<option value="1"><spring:message code="score.label.objt.proc1" /><!-- 승인(가산점 부여) --></option>
				                </select>
			                </div>
		                    <div class="button-area mt10 tc">
		                    	<button class="ui green mla button" onclick="onObjtSearch();"><spring:message code="common.button.search" /><!-- 검색 --></button>
							</div>
						</div>
						
						<div class="mt15 mb15 tc bcYellow p10" id="ctgrView"></div>
						
				    	<div class="option-content mb10">
							<h3 class="graduSch">
								<spring:message code="score.label.answer.list" />[ 
									<spring:message code="common.page.total" />&nbsp;<span class="fcBlue" id="crscreCnt">0</span>&nbsp;<spring:message code="common.page.total_count" />&nbsp;]
							</h3><!-- 성적재확인 신청목록 총 건 -->	
							<div class="mla">
								<button class="ui basic button" onclick="sendMsgProf()"><i class="paper plane outline icon"></i><spring:message code="seminar.label.professor" /><spring:message code="team.common.send" /></button><!-- 교수보내기 -->
								<button class="ui basic button" onclick="sendMsg()"><i class="paper plane outline icon"></i><spring:message code="common.label.learner" /><spring:message code="team.common.send" /></button><!-- 학습자보내기 -->
								<select class="ui dropdown mr5 w200" id="selCrsCreCd" name="selCrsCreCd"></select>
		                    	<button class="ui orange button" id="btnObjtAdd"><spring:message code="button.plus" /></button><!-- 추가 -->
		                    	<button class="ui green button" id="btnObjtExcel"><spring:message code="contents.excel.download.button" /></button><!-- 엑셀다운로드 -->
		                    </div>
					    </div>
	                   	<table class="tBasic type2" data-sorting="true" data-paging="false" data-empty="<spring:message code="exam.common.empty" />" id="objtTable">
						   	<thead>
						   		<tr>
						   			<th rowspan="2" class="num">
						   				<div class="ui checkbox">
						                    <input type="checkbox" id="chkObjtAll" value="all" onchange="checkAll(this.checked)" />
						                    <label class="toggle_btn" for="chkObjtAll"></label>
						                </div>
						   			</th>
						   			<th rowspan="2"><spring:message code="common.number.no"/></th><!-- No -->
						   			<th rowspan="2" class="word_break_none"><spring:message code="common.crs.cd" /><a href="javascript:sortTable('crsCd')"><i class="fooicon fooicon-sort"></i></a></th><!-- 학수번호 -->
						   			<th rowspan="2" class="word_break_none"><spring:message code="common.subject" /><a href="javascript:sortTable('crsCreNm')"><i class="fooicon fooicon-sort"></i></a></th><!-- 과목 -->
						   			<th rowspan="2"><spring:message code="common.label.decls.no" /></th><!-- 분반 -->
						   			<th colspan="2"><spring:message code="common.label.prof.nm" /></th><!-- 교수명 -->
						   			<th colspan="2"><spring:message code="common.label.tutor.nm" /></th><!-- 튜터명 -->
						   			<th colspan="4"><spring:message code="common.label.learner" /></th><!-- 학습자 -->
						   			<th rowspan="2"><spring:message code="score.label.request.reason" /></th><!-- 신청사유 -->
						   			<th colspan="2"><spring:message code="score.label.before.score" /></th><!-- 변경 전 성적 -->
						   			<th colspan="2"><spring:message code="score.label.after.score" /></th><!-- 변경 후 성적 -->
						   			<th rowspan="2"><spring:message code="common.label.score.reconfirm.yn.treat" /></th><!-- 성적재확인 신청처리 -->
						   			<th rowspan="2"><spring:message code="score.label.process.status" /><a href="javascript:sortTable('procNm')"><i class="fooicon fooicon-sort"></i></a></th><!-- 처리상태 및 결과 -->
						   		</tr>
						   		<tr>
						   			<th class="word_break_none"><spring:message code="exam.label.tch.no" /><a href="javascript:sortTable('profUserId')"><i class="fooicon fooicon-sort"></i></a></th><!-- 사번 -->
						   			<th class="word_break_none"><spring:message code="exam.label.usernm" /><a href="javascript:sortTable('profUserNm')"><i class="fooicon fooicon-sort"></i></a></th><!-- 성명 -->
						   			<th class="word_break_none"><spring:message code="exam.label.tch.no" /><a href="javascript:sortTable('tutUserId')"><i class="fooicon fooicon-sort"></i></a></th><!-- 사번 -->
						   			<th class="word_break_none"><spring:message code="exam.label.usernm" /><a href="javascript:sortTable('tutUserNm')"><i class="fooicon fooicon-sort"></i></a></th><!-- 성명 -->
						   			<th class="word_break_none"><spring:message code="exam.label.dept" /><a href="javascript:sortTable('deptNm')"><i class="fooicon fooicon-sort"></i></a></th><!-- 학과 -->
						   			<th class="word_break_none"><spring:message code="exam.label.user.no" /><a href="javascript:sortTable('objtUserId')"><i class="fooicon fooicon-sort"></i></a></th><!-- 학번 -->
						   			<th class="word_break_none"><spring:message code="exam.label.usernm" /><a href="javascript:sortTable('objtUserNm')"><i class="fooicon fooicon-sort"></i></a></th><!-- 성명 -->
						   			<th class="word_break_none"><spring:message code="std.label.hy" /><a href="javascript:sortTable('hy')"><i class="fooicon fooicon-sort"></i></a></th><!-- 학년 -->
									<th class="word_break_none"><spring:message code="score.label.score" /><a href="javascript:sortTable('prvScore')"><i class="fooicon fooicon-sort"></i></a></th><!-- 점수 -->
									<th class="word_break_none"><spring:message code="asmnt.label.grade" /><a href="javascript:sortTable('prvGrade')"><i class="fooicon fooicon-sort"></i></a></th><!-- 등급 -->
									<th class="word_break_none"><spring:message code="score.label.score" /><a href="javascript:sortTable('modScore')"><i class="fooicon fooicon-sort"></i></a></th><!-- 점수 -->
									<th class="word_break_none"><spring:message code="asmnt.label.grade" /><a href="javascript:sortTable('modGrade')"><i class="fooicon fooicon-sort"></i></a></th><!-- 등급 -->
						   		</tr>
						   	</thead>
						   	<tbody id="objtTbody"></tbody>
					    </table>
					    
						<div class="ui bottom attached segment mt10">
							<div class="mt10">
							   	<b>▣ <spring:message code="score.alert.message.reconfirm1" /></b><!-- 성적재확인신청안내 -->
							   	<p><spring:message code="score.alert.message.reconfirm2" /></p><!-- 성적확인기간에 학생이 성적을 확인 후 재확인신청한 내역이 본 화면에 조회된다. -->
							   	<p><spring:message code="score.alert.message.reconfirm3" /></p><!-- 성적재확인신청 학생을 조회하고, 재확인신청사유를 확인하여 사유가 타당하면 성적을 정정하고 그렇지 않으면 반려처리 한다. -->
							</div>
							<div class="mt10">
							   	<b>1. <spring:message code="score.label.reason" /></b><!-- 사유 -->
								<p class="pl10">- <spring:message code="score.alert.message.reconfirm4" /></p><!-- 학생이 재확인신청사유를 조회한다. -->
							</div>
							<div class="mt10">
								<b>2. <spring:message code="score.label.chage" /></b><!-- 처리하기 -->
								<p class="pl10">- <spring:message code="score.alert.message.reconfirm5" /></p><!-- 재확인신청사유가 타당한 경우 성적을 변경하고 승인처리한다. 처리상태가 승인으로 나타난다. -->
								<p class="pl10">- <spring:message code="score.alert.message.reconfirm6" /></p><!-- 재확인신청사유가 부당한 경우는 반려사유를 입력 후 반려처리한다. 처리상태가 반려로 나타난다. -->
								<p class="pl10">- <spring:message code="score.alert.message.reconfirm7" /></p><!-- 성적변경처리 팝업화면이 나타나고, 재확인신청학생에 포커스가 자동으로 설정되어 변경이 필요하면 "가산점" 항목을 통해서 점수를 환산점수 및 성적등급을 변경한다. -->
							</div>
							<div class="mt10">
								<b>3. <spring:message code="score.label.total" /></b><!-- 추가,저장 -->
								<p class="pl10">- <spring:message code="score.alert.message.reconfirm8" /></p><!-- 재확인신청이 시스템으로 등록할 수 없는 경우에 불가피하게 담당교수가 직접 신청사유를 입력하여 등록하고, 재확인신청처리를 할 수 있다. -->
							</div>
						</div>
					</div>
		   		</div>
			</div>
			<%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>

			<!-- 사유보기 팝업 -->
		    <form class="ui form" id="modalObjtCtntForm" name="modalObjtCtntForm" method="POST" action="">
		    	<input type="hidden" name="scoreObjtCd"/>
			    <div class="modal fade" id="modalObjtCtnt" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="score.label.reason.view" />" aria-hidden="false">
			        <div class="modal-dialog modal-lg" role="document">
			            <div class="modal-content">
			                <div class="modal-header">
			                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="sys.button.close" />">
			                        <span aria-hidden="true">&times;</span>
			                    </button>
			                    <h4 class="modal-title"><spring:message code="score.label.reason.view" /><!-- 사유보기 --></h4>
			                </div>
			                <div class="modal-body">
			                    <iframe src="" id="modalObjtCtntIfm" name="modalObjtCtntIfm" width="100%" scrolling="no"></iframe>
			                </div>
			            </div>
			        </div>
			    </div>
		    </form>

		    <!-- 성적 재확인 신청하기 팝업 -->
		    <form class="ui form" id="modalScoreReCfmTchRegForm" name="modalScoreReCfmTchRegForm" method="POST" action="">
		    	<input type="hidden" name="crsCreCd"/>
			    <div class="modal fade" id="modalScoreReCfmTchReg" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="common.label.score.reconfirm.yn" />" aria-hidden="false">
			        <div class="modal-dialog modal-lg" role="document">
			            <div class="modal-content">
			                <div class="modal-header">
			                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="sys.button.close" />">
			                        <span aria-hidden="true">&times;</span>
			                    </button>
			                    <h4 class="modal-title"><spring:message code="common.label.score.reconfirm.yn" /><!-- 성적 재확인 신청 --></h4>
			                </div>
			                <div class="modal-body">
			                    <iframe src="" id="modalScoreReCfmTchRegIfm" name="modalScoreReCfmTchRegIfm" width="100%" scrolling="no"></iframe>
			                </div>
			            </div>
			        </div>
			    </div>
		    </form>

		    <!-- 성적변경 처리 팝업 -->
    		<form class="ui form" id="modalObjtProcForm" name="modalObjtProcForm" method="POST" action="">
		    	<input type="hidden" name="objtUserId"/>
		    	<input type="hidden" name="crsCreCd"/>
					<input type="hidden" name="scoreObjtCd"/>
			    <div class="modal fade" id="modalObjtProc" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="score.label.change" />" aria-hidden="false">
			        <div class="modal-dialog modal-lg" role="document">
			            <div class="modal-content">
			                <div class="modal-header">
			                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="sys.button.close" />">
			                        <span aria-hidden="true">&times;</span>
			                    </button>
			                    <h4 class="modal-title"><spring:message code="score.label.change" /><!-- 성적변경 처리 --></h4>
			                </div>
			                <div class="modal-body">
			                    <iframe src="" id="modalObjtProcIfm" name="modalObjtProcIfm" width="100%" scrolling="no"></iframe>
			                </div>
			            </div>
			        </div>
			    </div>
		    </form>
		    <script>
		        $('iframe').iFrameResize();
		        window.closeModal = function() {
		            $('.modal').modal('hide');
		        };
		    </script>
		</div>
	</div>
</body>
</html>