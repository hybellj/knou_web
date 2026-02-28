<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<script type="text/javascript">
	$(document).ready(function(){
		//listUser(1);
		
		$("#searchValue").on("keyup", function(e){
			if(e.keyCode == 13) {
				listUser(1);
			}
		});
		
		$("#authGrpCd, #authGrpCd2").on("change", function() {
			searchAuthGrp(1, this.value);
		});
	});
	
	// 권한 검색
	function searchAuthGrp(page, authGrpCd) {
		$("#authGrpCd").off("change");
		$("#authGrpCd2").off("change");
		
		authGrpCd = (authGrpCd || "").replace("ALL", "");
		
		setTimeout(function() {
			if(authGrpCd) {
				if($("#authGrpCd > option[value='" + authGrpCd + "']").length && ($("#authGrpCd2").val() || "").replace("ALL", "")) {
					$("#authGrpCd2").dropdown("set value", "ALL");
				} else if($("#authGrpCd2 > option[value='" + authGrpCd + "']").length && ($("#authGrpCd").val() || "").replace("ALL", "")) {
					$("#authGrpCd").dropdown("set value", "ALL");
				}
			}
			
			$("#authGrpCd, #authGrpCd2").on("change", function() {
				searchAuthGrp(1, this.value);
			});
			
			listUser(1);
		}, 0);
	}
	
	// 사용자 목록
	function listUser(page) {
		var url  = "/user/userMgr/listUserByMenuType.do";
		var data = {
			  authGrpCd		: ($("#authGrpCd").val() || "").replace("ALL", "") || ($("#authGrpCd2").val() || "").replace("ALL", "")
			, schregGbnCd	: ($("#schregGbnCd").val() || "").replace("ALL", "")
			, pageIndex   	: page
			, listScale   	: $("#listScale").val()
			, searchValue 	: $("#searchValue").val()
			, pagingYn		: "Y"
		};
		
		userListTable.clearData();
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		var returnList = data.returnList || [];
        		var html = "";
        		var userIds = $("#userIds").val().split(",");
        		var dataList = [];
        		
        		if(returnList.length > 0) {
        			returnList.forEach(function(v, i) {
        				var authGrpCd = v.authGrpCd || "";
        				var deptCd    = v.deptCd != null ? v.deptCd : "";
        				var checked   = "";
            			if(userIds != "") {
            				userIds.forEach(function(vv, ii) {
            					if(vv == v.userId) {
            						checked = "checked";
            					}
            				});
            			}
            			var isStudent = authGrpCd.indexOf("USR") > -1;
            			var isAssistant = authGrpCd.indexOf("TUT") > -1;
            	
            			var vUserNm = '<a class="fcBlue" href="javascript:viewUser(\'' + v.userId + '\')">' + v.userNm + '</a>';
            			if(v.orgId == "<%=CommConst.KNOU_ORG_ID%>") {
            				// 한사대 erp 내정보
            				vUserNm += '<a href="javascript:userInfoPop(\'' + v.userId + '\')" class=""><i class="ico icon-info"></i></a>';
            			} else {
            				vUserNm += '<a href="javascript:userMgrProfilePop(\'' + v.userId + '\')" class=""><i class="ico icon-info"></i></a>';
            			}
            			
            			var vManage = '<a href="javascript:loginByAdmin(\'' + v.userId + '\', \'' + v.userId + '\')" class="ui small2 basic button"><spring:message code="user.button.login" /></a>'; // 로그인
            			vManage += '<a href="/user/userMgr/Form/editUser.do?userId=' + v.userId + '" class="ui small2 basic button"><spring:message code="user.button.mod" /></a>'; // 수정
            			vManage += '<a href="javascript:withdrawalUser(\'' + v.userId + '\', \'' + v.userId + '\')" class="ui small2 basic button"><spring:message code="user.title.userinfo.stats.d" /></a>';/* 탈퇴 */
            			if(!isStudent && !isAssistant) {
            				vManage += '<a href="javascript:userAuthChg(\'' + v.userId + '\')" class="ui small2 basic button"><spring:message code="user.title.userinfo.auth.grp.chg" /></a>'; // 권한 그룹 변경            				
            			}
            			if(v.mstYn == "Y" || isAssistant) {
            				vManage += '<a href="javascript:crecrsMonitoringSetting(\'' + v.userId + '\', \'' + v.authGrpCd + '\')" class="ui small2 basic button"><label class="fcBlue cur_point"><spring:message code="user.title.userinfo.monitoring.crecrs.pop" /></label></a>'; // 모니터링 과목설정
            			}
            			
            			dataList.push({
            				lineNo: v.lineNo,
            				adminAuthGrpNm: v.adminAuthGrpNm,
            				wwwAuthGrpNm: v.wwwAuthGrpNm,
            				deptNm: v.deptNm,
            				userId: v.userId,
            				userNm: vUserNm,
            				hy: (v.hy || '-'),
            				schregGbn: (v.schregGbn || '-'),
            				knouUserLink: (v.knouUserId != null ? v.knouUserNm+" ("+v.knouUserId+")" : "-"),
            				manage: vManage,
            				valUserNm: v.userNm,
            				valMobileNo: v.mobileNo,
            				valEmail: v.email
            			});
        			});
        		}
        		
        		userListTable.addData(dataList);
        		userListTable.redraw();
				
		    	var params = {
			    	totalCount 	  	: data.pageInfo.totalRecordCount,
			    	listScale 	  	: data.pageInfo.recordCountPerPage,
			    	currentPageNo 	: data.pageInfo.currentPageNo,
			    	eventName 	  	: "listUser"
			    };
			    
			    gfn_renderPaging(params);
			    
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
		}, true);
	}
	
	// 모니터링 과목 설정
	function crecrsMonitoringSetting(userId, authGrpCd) {
		$("#monitoringForm input[name=userId]").val(userId);
		$("#monitoringForm input[name=authGrpCd]").val(authGrpCd);
		$("#monitoringForm").attr("target", "monitoringPopIfm");
        $("#monitoringForm").attr("action", "/user/userMgr/crecrsMonitoringSettingPop.do");
        $("#monitoringForm").submit();
        $('#monitoringPop').modal('show');
	}
	
	// 전체 선택 / 해제
    function checkAllUserIdToggle(obj) {
        $("input:checkbox[name=evalChk]").prop("checked", $(obj).is(":checked"));

        $('input:checkbox[name=evalChk]').each(function (idx){
            if ($(obj).is(":checked")) {
                addSelectedUserIds($(this).attr("data-userId"));
            } else {
                removeSelectedUserIds($(this).attr("data-userId"));
            }
        });
    }

    // 한건 선택 / 해제
    function checkUserIdToggle(obj) {
        if ($(obj).is(":checked")) {
            addSelectedUserIds($(obj).attr("data-userId"));
        } else {
            removeSelectedUserIds($(obj).attr("data-userId"));
        }
        var totChkCnt = $("input:checkbox[name=evalChk]").length;
        var chkCnt = $("input:checkbox[name=evalChk]:checked").length;
        if(totChkCnt == chkCnt) {
        	$("input:checkbox[name=allEvalChk]").prop("checked", true);
        } else {
        	$("input:checkbox[name=allEvalChk]").prop("checked", false);
        }
    }

    // 선택된 학습자 번호 추가
    function addSelectedUserIds(userId) {
        var selectedUserIds = $("#userIds").val();
        if (selectedUserIds.indexOf(userId) == -1) {
            if (selectedUserIds.length > 0) {
            	selectedUserIds += ',';
            }
            selectedUserIds += userId;
            $("#userIds").val(selectedUserIds);
        }
    }

    // 선택된 학습자 번호 제거
    function removeSelectedUserIds(userId) {
        var selectedUserIds = $("#userIds").val();
        if (selectedUserIds.indexOf(userId) > -1) {
        	selectedUserIds = selectedUserIds.replace(userId, "");
        	selectedUserIds = selectedUserIds.replace(",,", ",");
        	selectedUserIds = selectedUserIds.replace(/^[,]*/g, '');
        	selectedUserIds = selectedUserIds.replace(/[,]*$/g, '');
            $("#userIds").val(selectedUserIds);
        }
    }
    
    // 권한 그룹 변경
    function userAuthChg(userId) {
    	$("#userAuthChgForm > input[name='userIds']").val(userId);
		$("#userAuthChgForm").attr("target", "authChgPopIfm");
        $("#userAuthChgForm").attr("action", "/user/userMgr/userAuthChgPop.do");
        $("#userAuthChgForm").submit();
        $('#authChgPop').modal('show');
    }
    
 	// 권한 그룹 변경 콜백
	function authGrpChangeCallBack() {
		if($("#paging > a.current").length == 1) {
			$("#paging > a.current").trigger("click");
		}
	}
   
    // 엑셀 다운로드
    function userExcelDown() {
    	var excelGrid = {
			colModel:[
				{label:'<spring:message code="common.number.no"/>', 					name:'lineNo', 			align:'right', 	width:'1000'},	// NO
				{label:'<spring:message code="user.title.userinfo.tch.div" />', 		name:'adminAuthGrpNm', 	align:'left', 	width:'5000'},	// 운영자 구분
				{label:'<spring:message code="user.title.userinfo.user.div" />', 		name:'wwwAuthGrpNm', 	align:'left', 	width:'5000'},	// 사용자 구분
				{label:'<spring:message code="user.title.userdept.dept" />', 			name:'deptNm', 			align:'left', 	width:'7000'},	// 학과/부서
				{label:'<spring:message code="user.title.userinfo.user.no" />', 		name:'userId', 			align:'left', 	width:'5000'},	// 학번/사번
				{label:'<spring:message code="user.title.userinfo.manage.usernm" />', 	name:'userNm', 			align:'left', 	width:'5000'},	// 이름
				{label:'<spring:message code="user.title.userinfo.grade" />', 			name:'hy', 				align:'center', width:'2000',},	// 학년
				{label:'<spring:message code="user.title.userinfo.phoneno" />', 		name:'mobileNo', 		align:'center', width:'5000'},	// 전화번호
				{label:'<spring:message code="user.title.userinfo.email" />', 			name:'email', 			align:'left',	width:'9000'},	// 이메일
				{label:'<spring:message code="user.title.userinfo.user.stats" />', 		name:'schregGbn', 		align:'center', width:'2500'},	// 학적상태
			]
  		};

    	$("form[name='excelForm']").remove();
		var excelForm = $('<form></form>');
		excelForm.attr("name","excelForm");
		excelForm.attr("action","/user/userMgr/userExcelDownload.do");
		excelForm.append($('<input/>', {type: 'hidden', name: 'searchValue', 	value: $("#searchValue").val()}));
		excelForm.append($('<input/>', {type: 'hidden', name: 'authGrpCd', 		value: $("#authGrpCd").val()}));
		excelForm.append($('<input/>', {type: 'hidden', name: 'schregGbnCd', 	value: $("#schregGbnCd").val()}));
		excelForm.append($('<input/>', {type: 'hidden', name: 'excelGrid', 		value:JSON.stringify(excelGrid)}));
		excelForm.appendTo('body');
		excelForm.submit();
    }
    
    // 엑셀 업로드
    function userExcelUpload() {
    	$("#excelUploadForm").attr("target", "userExcelUploadPopIfm");
        $("#excelUploadForm").attr("action", "/user/userMgr/userExcelUploadPop.do");
        $("#excelUploadForm").submit();
        $('#userExcelUploadPop').modal('show');
    }
    
    // 사용자 상세 정보
    function viewUser(userId) {
	    var url  = "/user/userMgr/Form/viewUser.do";
	    var form = $("<form></form>");
	    form.attr("method", "POST");
	    form.attr("name", "viewForm");
	    form.attr("action", url);
	    form.append($('<input/>', {type: 'hidden', name: 'userId', value: userId}));
	    form.appendTo("body");
	    form.submit();
    }
    
    // 비밀번호 초기화
    function initializePwd(userId, email, userId) {
    	if(window.confirm(`<spring:message code="user.message.login.reset.pass.confirm" arguments="\${userId}" />`)) {/* "{0}" 사용자의 비밀번호를 초기화 하시겠습니까? */
    		
    		var url  = "/user/userHome/resetPass.do";
    		var data = {
    			"userId" : userId,
    			"email"	 : email
    		};
    		
    		ajaxCall(url, data, function(data) {
    			if (data.result > 0) {
    				var returnVO = data.returnVO;
    				if(returnVO != null) {
    					var url  = "<%=CommConst.SYSMSG_URL_INSERT%>";
    					var rcvEmailArray = new Array();
    					var rcvEmailVO = null;
    	                rcvEmailVO = new Object();
    	                rcvEmailVO.rcvNo = returnVO.userId;                // 수신자 개인번호1
    	                rcvEmailVO.rcvNm = returnVO.userNm;                // 수신자 이름1
    	                rcvEmailVO.rcvEmailAddr = returnVO.rcvEmailAddr;   // 수신자 이메일 주소1

    	                rcvEmailArray.push(rcvEmailVO);
    	                var rcvJsonData = JSON.stringify(rcvEmailArray).replace(/\"/gi, "\\\"");
    					
    		    		var data = {
    		    			"alarmType" 		: returnVO.alarmType,
    		    			"userId"			: returnVO.userId,
    		    			"userNm"			: returnVO.userNm,
    		    			"sysCd"				: returnVO.sysCd,
    		    			"orgId"				: returnVO.orgId,
    		    			"bussGbn"			: returnVO.bussGbn,
    		    			"sendRcvGbn"		: returnVO.sendRcvGbn,
    		    			"subject"			: returnVO.subject,
    		    			"ctnt"				: returnVO.ctnt,
    		    			"sendDttm"			: "",
    		    			"sndrPersNo"		: returnVO.sndrPersNo,
    		    			"sndrDeptCd"		: returnVO.sndrDeptCd,
    		    			"sndrNm"			: returnVO.sndrNm,
    		    			"sndrEmailAddr"		: returnVO.sndrEmailAddr,
    		    			"logDesc"			: returnVO.logDesc,
    		    			"rcvJsonData"		: rcvJsonData
    		    		};
    		    		
    		    		ajaxCall(url, data, function(data) {
    		    			if (data.result > 0) {
    		    				alert(`<spring:message code="user.message.login.reset.pass.success" arguments="\${email}" />`);/* {0}로 임시비밀번호를 발송했습니다. */
    		    			} else {
    		                 	alert(data.message);
    		                }
    		    		}, function(xhr, status, error) {
    		    			alert("<spring:message code='user.message.login.reset.pass.failed' />");/* 이메일 전송과정에 문제가 발생했습니다. */
    		    		});
    				}
                } else {
                 	alert(data.message);
                }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='user.message.login.reset.pass.failed' />");/* 이메일 전송과정에 문제가 발생했습니다. */
    		});
    	}
    }

    // 사용자 로그인
    function loginByAdmin(userId, userId) {
    	var agent = navigator.userAgent.toLowerCase();
        if(agent.indexOf("hycuapp") > -1) {
        	$("#userMoveForm").attr("action","/user/userHome/loginUserByAdmin.do");
        	$("#userMoveForm").attr("target","_self");
    		$("#userMoveForm > input[name='userId']").val(userId);
    		$("#userMoveForm > input[name='userId']").val(userId);
    		$('#userMoveForm').submit();
        }
        else {
	    	var userSupportWin = window.open("", "userSupportWin");
			$("#userMoveForm").attr("action","/user/userHome/loginUserByAdmin.do");
			$("#userMoveForm > input[name='userId']").val(userId);
			$("#userMoveForm > input[name='userId']").val(userId);
			$('#userMoveForm').submit();
			$("#virtualSupport").show();
			
			var closeUserTimer = setInterval(function() {
				if (userSupportWin.closed) {
					$.ajax({
						url : "/dashboard/closeVirtualSession.do",
						type: "POST",
						success : function(data, status, xr){
							$("#virtualSupport").hide();
						},
						error : function(xhr, status, error){
							$("#virtualSupport").hide();
						},
						timeout:3000	
					});
					clearInterval(closeUserTimer);
				}
			}, 1000);
        }
    }
    
    // 사용자 탈퇴
    function withdrawalUser(userId, userId) {
    	if(window.confirm(`<spring:message code="user.message.userinfo.drop.confirm" arguments="\${userId}" />`)) {/* "{0}" 사용자를 정말 탈퇴처리 하시겠습니까? */
    		var url  = "/user/userMgr/withdrawalUser.do";
    		var data = {
    			"userId" : userId
    		};
    		
    		ajaxCall(url, data, function(data) {
    			if (data.result > 0) {
            		alert("<spring:message code='user.message.userinfo.drop.success' />");/* 탈퇴처리 성공하였습니다. */
            		listUser(1);
                } else {
                 	alert(data.message);
                }
    		}, function(xhr, status, error) {
    			alert("<spring:message code='user.message.userinfo.drop.failed' />");/* 탈퇴처리 실패하였습니다. */
    		});
    	}
    }
    
	// 내정보 관리 팝업
    function userMgrProfilePop(userId) {
    	$("#userMgrProfileForm > input[name='userId']").val(userId);
		$("#userMgrProfileForm").attr("target", "userMgrProfilePopIfm");
		$("#userMgrProfileForm").attr("action", "/user/userMgr/userMgrProfilePop.do");
		$("#userMgrProfileForm").submit();
		$('#userMgrProfilePop').modal('show');
		
		$("#userMgrProfileForm > input[name='userId']").val("");
    }
 	
	// 메세지 보내기
	function sendMsg() {
		var selectList = userListTable.getSelectedRows();
		var rcvUserInfoStr = "";
		var sendCnt = 0;
		var userMap = {};
		
		for(var i=0; i<selectList.length; i++) {
			var data = selectList[i].getData();
			if (data.userId == null) {
				continue;
			} 
				
			sendCnt++;
			if (sendCnt > 1) {
				rcvUserInfoStr += "|";
			}
			
			rcvUserInfoStr += data.userId;
			rcvUserInfoStr += ";" + data.valUserNm;
			rcvUserInfoStr += ";" + data.valMobileNo;
			rcvUserInfoStr += ";" + data.valEmail;
		}

		console.log(rcvUserInfoStr);
		
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
</script>
</head>

<body>
	<form id="monitoringForm" method="POST">
		<input type="hidden" name="userId" />
		<input type="hidden" name="authGrpCd" />
		<input type="hidden" name="deptCd" />
	</form>
	<form id="userAuthChgForm" method="POST">
		<input type="hidden" id="userIds" name="userIds">
	</form>
	<form id="excelUploadForm" method="POST">
	</form>
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
		        	<h2 class="page-title flex-item flex-wrap gap4 columngap16">
                    	<spring:message code="user.title.userinfo.manage" /><!-- 사용자 관리 -->
                    	<div class="ui breadcrumb small">
                        	<small class="section"><spring:message code="user.title.list" /><!-- 목록 --></small>
                       	</div>
                    </h2>
					<div class="button-area">
		            	<uiex:msgSendBtn func="sendMsg()" styleClass="ui basic button"/><!-- 메시지 -->
		                <a href="javascript:userExcelDown()" class="ui green button"><spring:message code="user.title.download.excel" /></a><!-- 엑셀 다운로드 -->
		                <a href="javascript:userExcelUpload()" class="ui green button"><spring:message code="user.title.upload.excel" /></a><!-- 파일로 등록 -->
		                <a href="/user/userMgr/Form/addUser.do" class="ui orange button"><spring:message code="user.title.userinfo.write" /></a><!-- 사용자 등록 -->
		            </div>
		        </div>
  				<div class="ui divider mt0"></div>
        		<div class="ui form">
        			<div class="option-content gap4">
        				<select class="ui dropdown w200" id="authGrpCd">
        					<option value=""><spring:message code="user.title.userinfo.admin.type" /></option><!-- 관리자 구분 -->
        					<option value="ALL"><spring:message code="common.all" /></option><!-- 전체 -->
        					<c:forEach var="row" items="${userTypeList}">
        						<c:if test="${row.codeOptn eq 'ADMIN'}">
        							<option value="${row.codeCd}">${row.codeNm}</option>
        						</c:if>
        					</c:forEach>
        				</select>
        				<select class="ui dropdown" id="authGrpCd2">
        					<option value=""><spring:message code="user.title.userinfo.user.div" /></option><!-- 사용자 구분 -->
        					<option value="ALL"><spring:message code="common.all" /></option><!-- 전체 -->
        					<c:forEach var="row" items="${userTypeList}">
        						<c:if test="${row.codeOptn ne 'ADMIN'}">
        							<option value="${row.codeCd}">${row.codeNm}</option>
        						</c:if>
        					</c:forEach>
        				</select>
        				<select class="ui dropdown" id="schregGbnCd" onchange="listUser(1)">
        					<option value=""><spring:message code="user.title.userinfo.user.stats" /></option><!-- 학적상태 -->
        					<option value="ALL"><spring:message code="common.all" /></option><!-- 전체 -->
        					<c:forEach var="row" items="${schregGbnCdList}">
        						<option value="${row.codeCd}">${row.codeNm }</option>
        					</c:forEach>
        				</select>
        				<div class="ui action input search-box">
						    <input type="text" placeholder="<spring:message code='user.message.search.input.userinfo.no.dept.nm' />" class="w250" id="searchValue"><!-- 학번/학과명/이름 입력 -->
						    <button class="ui icon button" onclick="listUser(1)"><i class="search icon"></i></button>
						</div>
						<div class="mla">
							<select class="ui dropdown mr5 list-num" id="listScale" onchange="listUser(1)">
						        <option value="10">10</option>
						        <option value="20">20</option>
						        <option value="50">50</option>
						        <option value="100">100</option>
						    </select>
						</div>
		            </div>
		            <div class="ui segment">
			        	<div id="userListTable" ></div>
			        	<script>
			        	var visibleGbn = <%=(SessionInfo.isKnou(request) == true ? "false" : "true")%>;
                        var userListTable = new Tabulator("#userListTable", {
                        		maxHeight: "600px",
                        		minHeight: "100px",
                        		layout: "fitColumns",
                        		selectableRows: "highlight",
                        		headerSortClickElement: "icon",
                        		placeholder:"<spring:message code='common.content.not_found'/>",
                        		columns: [
                        			{formatter:"rowSelection", titleFormatter:"rowSelection", headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:50, headerSort:false, cellClick:function(e,cell){cell.getRow().toggleSelect()}},
                        		    {title:"<spring:message code='common.number.no'/>", field:"lineNo", width:60, headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", headerSort:false},
                        		    {title:"<spring:message code='user.title.userinfo.tch.div'/>", field:"adminAuthGrpNm", headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:100, headerSort:false}, // 운영자구분			                        		    
                        		    {title:"<spring:message code='user.title.userinfo.user.div'/>", field:"wwwAuthGrpNm", headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:80, headerSort:false}, // 사용자 구분
                        		    {title:"<spring:message code='user.title.userdept.dept'/>", field:"deptNm", headerHozAlign:"center", hozAlign:"left", vertAlign:"middle", minWidth:100, headerSort:false}, // 학과/부서
                        		    {title:"<spring:message code='user.title.userinfo.user.no'/>", field:"userId", headerHozAlign:"center", vertAlign:"middle", minWidth:100, headerSort:false}, // 학번/사번
                        		    {title:"<spring:message code='user.title.userinfo.manage.usernm'/>", field:"userNm", headerHozAlign:"center", hozAlign:"left", vertAlign:"middle", minWidth:100, formatter:"html", headerSort:false}, // 이름
                        		    {title:"<spring:message code='user.title.userinfo.grade'/>", field:"hy", headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:60, headerSort:false}, // 학년
                        		    {title:"<spring:message code='user.title.userinfo.user.stats'/>", field:"schregGbn", headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", width:70, headerSort:false}, // 학적상태
                        		    {title:"방송대 계정 연결", field:"knouUserLink", headerHozAlign:"center", hozAlign:"center", vertAlign:"middle", minWidth:120, headerSort:false, visible:visibleGbn}, // 방송대계정연결
                        		    {title:"<spring:message code='user.title.manage'/>", field:"manage", headerHozAlign:"center", hozAlign:"left", vertAlign:"middle", width:330, formatter:"html", headerSort:false}, // 관리
                        		]
                       	});
                       </script>
			        	
			        	<div id="paging" class="paging mt10"></div>
		        	</div>
        		</div>
			</div>
        </div>
        <!-- //본문 content 부분 -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
    </div>

    <!-- 모니터링 과목설정 팝업 --> 
	<div class="modal fade" id="monitoringPop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="user.title.userinfo.monitoring.crecrs.pop" />" aria-hidden="false">
	    <div class="modal-dialog modal-lg" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code='user.button.close' />"><!-- 닫기 -->
	                    <span aria-hidden="true">&times;</span>
	                </button>
	                <h4 class="modal-title"><spring:message code="user.title.userinfo.monitoring.crecrs.pop" /></h4><!-- 모니터링 과목설정 -->
	            </div>
	            <div class="modal-body">
	                <iframe src="" id="monitoringPopIfm" name="monitoringPopIfm" width="100%" scrolling="no"></iframe>
	            </div>
	        </div>
	    </div>
	</div>

	<!-- 권한 그룹 변경 팝업 --> 
	<div class="modal fade" id="authChgPop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="user.title.userinfo.auth.grp.chg" />" aria-hidden="false">
	    <div class="modal-dialog modal-lg" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code='user.button.close' />"><!-- 닫기 -->
	                    <span aria-hidden="true">&times;</span>
	                </button>
	                <h4 class="modal-title"><spring:message code="user.title.userinfo.auth.grp.chg" /></h4><!-- 권한 그룹 변경 -->
	            </div>
	            <div class="modal-body">
	                <iframe src="" id="authChgPopIfm" name="authChgPopIfm" width="100%" scrolling="no"></iframe>
	            </div>
	        </div>
	    </div>
	</div>
	
	<!-- 엑셀 업로드 팝업 --> 
	<div class="modal fade" id="userExcelUploadPop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="user.title.userinfo.upload.excel.pop" />" aria-hidden="false">
	    <div class="modal-dialog modal-lg" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code='user.button.close' />"><!-- 닫기 -->
	                    <span aria-hidden="true">&times;</span>
	                </button>
	                <h4 class="modal-title"><spring:message code="user.title.userinfo.upload.excel.pop" /></h4><!-- 엑셀 업로드 -->
	            </div>
	            <div class="modal-body">
	                <iframe src="" id="userExcelUploadPopIfm" name="userExcelUploadPopIfm" width="100%" scrolling="no"></iframe>
	            </div>
	        </div>
	    </div>
	</div>
	
	<!-- 내정보 관리 팝업 -->
	<form id="userMgrProfileForm" name="userMgrProfileForm" method="post">
		<input type="hidden" name="userId" />
	</form>
    <div class="modal fade" id="userMgrProfilePop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="common.my.information" /><spring:message code="common.mgr" />" aria-hidden="false">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="common.button.close" />"><!-- 닫기 -->
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title"><spring:message code="common.my.information" /><spring:message code="common.mgr" /></h4>
                </div>
                <div class="modal-body">
                    <iframe src="" id="userMgrProfilePopIfm" name="userMgrProfilePopIfm" width="100%" scrolling="no" title="userMgrProfilePopIfm"></iframe>
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
	
   	<form id="userMoveForm" name="userMoveForm" method="post" target="userSupportWin">
		<input type="hidden" name="userId" value=""/>
		<input type="hidden" name="userId" value=""/>
		<input type="hidden" name="modChgFromMenuCd" value="ADM0000000001"/>
		<input type="hidden" name="goUrl" value=""/>
	</form>
</body>
</html>