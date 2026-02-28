<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<script type="text/javascript">
	$(document).ready(function() {
		listUserChgHsty(1);
		listUserCre(1);
	});
	
	// 사용자 정보 변경 이력 목록
	function listUserChgHsty(page) {
		var url  = "/user/userMgr/userInfoChgHstyListPaging.do";
		var data = {
			"userId"    : "${vo.userId}",
			"pageIndex" : page,
			"listScale" : 5
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
        		var returnList = data.returnList || [];
        		var html = "";
        		if(returnList.length > 0) {
        			returnList.forEach(function(v, i) {
        				var connIp    = v.connIp != null ? v.connIp : "";
        				var chgTarget = v.chgTarget != null ? v.chgTarget : "";
        				var regDttm   = v.regDttm.substring(0, 4) + "." + v.regDttm.substring(4, 6) + "." + v.regDttm.substring(6, 8) + " " + v.regDttm.substring(8, 10) + ":" + v.regDttm.substring(10, 12);
        				html += "<tr>";
        				html += "	<td>"+v.lineNo+"</td>";
        				html += "	<td>"+connIp+"</td>";
        				html += "	<td>"+v.regNm+"</td>";
        				html += "	<td>"+v.userInfoChgDivNm+"</td>";
        				html += "	<td>"+regDttm+"</td>";
        				html += "	<td>"+chgTarget+"</td>";
        				html += "</tr>";
        			});
        		}
        		
        		$("#userChgHstyList").empty().html(html);
		    	$("#userChgHstyTable").footable();
		    	var params = {
			    	totalCount 	  : data.pageInfo.totalRecordCount,
			    	listScale 	  : data.pageInfo.recordCountPerPage,
			    	currentPageNo : data.pageInfo.currentPageNo,
			    	eventName 	  : "listUserChgHsty"
			    };
			    
			    gfn_renderPaging(params);
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
		});
	}
	
	// 현재 학기 강의과목 목록
	function listUserCre(page) {
		var pagingYn = $("#listScale").val() == "200" ? "N" : "Y";
		var crsTypeCd = $("#crsTypeCd").val();
		if(crsTypeCd == "all") {
			crsTypeCd = "";
		}
		var url  = "/crs/creCrsMgr/userCrecrsListPaging.do";
		var data = {
			"pageIndex" : page,
			"listScale" : $("#listScale").val(),
			"crsTypeCd" : crsTypeCd,
			"userId"	: "${vo.userId}",
			"pagingYn"	: pagingYn
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				var returnList = data.returnList || [];
				createCreHtml(returnList, data);
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
		});
	}
	
	// 과정 유형 코드 선택
	function crsTypeCdTemp(obj) {
		var crsTypeCd = obj.value;
		var temp = "";
		var url  = "/crs/termMgr/changeTerm.do";
		var data = {};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				var returnList = data.returnList || [];
				$("div#termArea.ui.selection.dropdown div.menu").empty();
				$("div#termArea.ui.selection.dropdown > .text").empty().append("<spring:message code='user.message.search.select.term' />");/* 학기를 선택하세요. */
				
				if(returnList.length > 0) {
					returnList.forEach(function(v, i) {
						var termTypeNm = "<spring:message code='crs.label.termtype.open' />";/* 공개과목 */
						if(v.termType == "NORMAL")  termTypeNm = "<spring:message code='crs.label.termtype.normal' />";/* 정규 */
						if(v.termType == "BNORMAL") termTypeNm = "<spring:message code='crs.label.termtype.bnormal' />";/* 비정규 */
						temp += "<div class='item' name='termCd' onclick='creList2(\"\", \""+v.termCd+"\")'><label class='ui mini basic label mr5'>"+termTypeNm+"</label><span>"+v.termNm+"</span></div>";
					});
				}
				$("div#termArea.ui.selection.dropdown div.menu").append(temp);
				// 과정유형 학기제 선택시 학기 셀렉트 박스 출력
				$("div#termArea.ui.selection.dropdown").css("display", crsTypeCd == "UNI" ? "" : "none");
				creList2(crsTypeCd, null);
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
		});
	}
	
	// 과정 유형, 학기 선택
	function creList2(crsTypeCd, termCd){
		var pagingYn = $("#listScale").val() == "200" ? "N" : "Y";
		if(crsTypeCd == "all"){
			crsTypeCd = "";
		}
		var url  = "/crs/creCrsMgr/userCrecrsListPaging.do";
		var data = {
			"pageIndex" : 1,
			"listScale" : $("#listScale").val(),
			"crsTypeCd" : crsTypeCd,
			"termCd"	: termCd,
			"userId"	: "${vo.userId}",
			"pagingYn"	: pagingYn
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				var returnList = data.returnList || [];
				createCreHtml(returnList, data);
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
		});
	}
	
	// 과목 목록 리스트 생성
	function createCreHtml(list, data) {
		var html = "";
		if(list.length > 0) {
			list.forEach(function(v, i) {
				html += "<tr>";
				html += "	<td>"+v.lineNo+"</td>";
				html += "	<td>"+v.crsCreNm+"</td>";
				html += "	<td>"+v.declsNo+"<spring:message code='crs.label.room' /></td>";/* 반 */
				html += "	<td>"+v.crsCd+"</td>";
				html += "	<td>"+v.compDvNm+"</td>";
				html += "	<td>"+v.credit+"</td>";
				html += "	<td>"+v.lessonCnt+"</td>";
				html += "	<td>"+v.crsOperTypeNm+"</td>";
				html += "	<td>"+v.userNm+"</td>";
				html += "	<td>"+v.stdCnt+"</td>";
				html += "</tr>";
			});
		}
		
		$("#userCreList").empty().html(html);
		$("#userCreTable").footable();
		if($("#listScale").val() != "200") {
			$("#crePaging").show();
			var params = {
				totalCount 	  : data.pageInfo.totalRecordCount,
				listScale 	  : data.pageInfo.recordCountPerPage,
				currentPageNo : data.pageInfo.currentPageNo,
				pagingDivId   : "crePaging",
				eventName 	  : "listUserCre"
			};
			
			gfn_renderPaging(params);
		} else {
			$("#crePaging").hide();
		}
	}
	
	// 메세지 보내기
	function sendMsg() {
		var rcvUserInfoStr = "${vo.userId};${vo.userNm};${vo.mobileNo};${vo.email}";
		
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
    <div id="wrap" class="pusher">
        <!-- class_top 인클루드  -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>

        <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>

        <div id="container">
            <!-- 본문 content 부분 -->
            <div class="content">
            	<%--
            	<%@ include file="/WEB-INF/jsp/common/admin/admin_location.jsp" %>
            	--%>
        		<div class="ui form">
        			<div class="layout2">
		                <div id="info-item-box">
		                	<h2 class="page-title flex-item flex-wrap gap4 columngap16">
                                <spring:message code="user.title.userinfo.manage" /><!-- 사용자 관리 -->
                                <div class="ui breadcrumb small">
                                    <small class="section"><spring:message code="user.title.userinfo.detail.info" /><!-- 상세정보 --></small>
                                </div>
                            </h2>
		                    <div class="mla">
		                    	<uiex:msgSendBtn func="sendMsg()" styleClass="ui basic button"/><!-- 메시지 -->
		                    	<a href="<c:url value="/user/userMgr/Form/manageUser.do" />" class="ui green button"><spring:message code="common.button.list" /></a><!-- 목록 -->
		                    </div>
		                </div>
		        		<div class="row">
		        			<div class="col">
		        				<div class="ui card wmax">
		        					<div class="content">
		        						<p><spring:message code="user.title.userinfo" /></p><!-- 사용자 정보 -->
		        					</div>
		        					<div class="content">
		        						<div class="fields">
                                            <div class="four wide field flex-item-center mo-none">
                                            	<div class="initial-img lg bcLgrey">
                                            		<c:choose>
                                            			<c:when test="${empty vo.phtFile }">
                                            				<img src="/webdoc/img/icon-hycu-symbol-grey.svg">
                                            			</c:when>
                                            			<c:otherwise>
                                            				<img src="${vo.phtFile }">
                                            			</c:otherwise>
                                            		</c:choose>
		                                        </div>
                                            </div>
                                            <div class="twelve wide field">
                                                <div class="fields">
                                                    <div class="five wide field"><label><spring:message code="user.title.userinfo.titenancy" /></label></div><!-- 소속(테넌시) -->
                                                    <div class="eleven wide field">${vo.orgNm }</div>
                                                </div>
                                                <div class="fields">
                                                    <div class="five wide field"><label><spring:message code="user.title.userinfo.manage.userid" /></label></div><!-- 학번 -->
                                                    <div class="eleven wide field">${vo.userId }</div>
                                                </div>
                                                <div class="fields">
                                                    <div class="five wide field"><label><spring:message code="user.title.userinfo.user.div" /></label></div><!-- 사용자 구분 -->
                                                    <div class="eleven wide field">${vo.authGrpCd }</div>
                                                </div>
                                                <div class="fields">
                                                    <div class="five wide field"><label><spring:message code="user.title.userdept.dept" /></label></div><!-- 학과/부서 -->
                                                    <div class="eleven wide field">${vo.deptNm }</div>
                                                </div>
                                                <div class="fields">
                                                    <div class="five wide field"><label><spring:message code="user.title.userinfo.manage.usernm" /></label></div><!-- 이름 -->
                                                    <div class="eleven wide field">${vo.userNm }</div>
                                                </div>
                                                <div class="fields">
                                                    <div class="five wide field"><label><spring:message code="user.title.userinfo.manage.usernm.en" /></label></div><!-- 이름(영문) -->
                                                    <div class="eleven wide field">${vo.userNmEng }</div>
                                                </div>
                                                <div class="fields">
                                                    <div class="five wide field"><label><spring:message code="user.title.userinfo.mobileno" /></label></div><!-- 휴대폰 번호 -->
                                                    <div class="eleven wide field">${vo.mobileNo }</div>
                                                </div>
                                                <div class="fields">
                                                    <div class="five wide field"><label><spring:message code="user.title.userinfo.email" /></label></div><!-- 이메일 -->
                                                    <div class="eleven wide field">${vo.email }</div>
                                                </div>
                                                
                                                <%
                                                if (!SessionInfo.isKnou(request)) {
	                                                %>
	                                                <div class="fields">
	                                                    <div class="five wide field"><label><spring:message code="user.title.knou_rltn" /></label></div><!-- 한사대 계정 연결 -->
	                                                    <div class="eleven wide field">
	                                                    	<c:if test="${not empty vo.knouUserId}">${vo.knouUserNm} (${vo.knouUserId})</c:if>
	                                                    </div>
	                                                </div>
                                                	<%
                                                }
                                                %>
                                            </div>
                                        </div>
		        					</div>
		        				</div>
		        				<div class="ui card wmax">
		        					<div class="content">
		        						<p><spring:message code="user.title.userinfo.change.info.log" /></p><!-- 사용자 정보 변경 이력 -->
		        					</div>
		        					<div class="content">
		        						<table class="table" id="userChgHstyTable" data-sorting="true" data-paging="false" data-empty="<spring:message code='user.common.empty' />"><!-- 등록된 내용이 없습니다. -->
		        							<thead>
		        								<tr>
		        									<th><spring:message code="common.number.no" /></th><!-- NO. -->
		        									<th><spring:message code="user.title.manage.userinfo.conn.ip" /></th><!-- 접속 IP -->
		        									<th><spring:message code="user.title.manage.userinfo.edit.user" /></th><!-- 변경자 -->
		        									<th><spring:message code="user.title.userinfo.manage.userdiv" /></th><!-- 구분 -->
		        									<th data-breakpoints="xs sm md"><spring:message code="user.title.manage.userinfo.edit.dttm" /></th><!-- 변경일시 -->
		        									<th data-breakpoints="xs sm md"><spring:message code="user.title.manage.userinfo.edit.cnts" /></th><!-- 변경내역 -->
		        								</tr>
		        							</thead>
		        							<tbody id="userChgHstyList">
		        							</tbody>
		        						</table>
		        						<div id="paging" class="paging"></div>
		        					</div>
		        				</div>
		        				<div class="ui card wmax">
		        					<div class="content">
		        						<p><spring:message code="user.title.crs.present.term.study.course" /></p><!-- 현재 학기 강의과목 -->
		        					</div>
		        					<div class="content">
		        						<div class="option-content mb20">
		        							<select class="ui dropdown" id="crsTypeCd" onchange="crsTypeCdTemp(this)">
		        								<option value="all"><spring:message code="user.common.search.all" /></option><!-- 전체 -->
		        								<option value="UNI"><spring:message code="user.title.crs.uni" /></option><!-- 학기제 과목 -->
		        								<option value="CO"><spring:message code="user.title.crs.co" /></option><!-- 기수제 과목 -->
		        								<option value="OPEN"><spring:message code="user.title.crs.open" /></option><!-- 공개강좌 -->
		        								<option value="LEGAL"><spring:message code="user.title.crs.court" /></option><!-- 법정교육 -->
		        							</select>
		        							<div class="my-class">
										      	<div class="ui selection dropdown w300 ml5" id="termArea" style="display: none;">
										             <div class="default text"><spring:message code="user.message.search.select.term" /></div><!-- 학기를 선택하세요. -->
										             <i class="dropdown icon"></i>
										             <div class="menu"> </div>
										         </div>
									         </div>
		        							<div class="mla">
		        								<select class="ui dropdown list-num" id="listScale" onchange="listUserCre(1)">
		        									<option value="10">10</option>
		        									<option value="20">20</option>
		        									<option value="50">50</option>
		        									<option value="100">100</option>
		        									<option value="200">200</option>
		        								</select>
		        							</div>
		        						</div>
		        						<table class="table" id="userCreTable" data-sorting="true" data-paging="false" data-empty="<spring:message code='user.common.empty' />"><!-- 등록된 내용이 없습니다. -->
		        							<thead>
		        								<tr>
		        									<th><spring:message code="common.number.no" /></th><!-- NO. -->
		        									<th><spring:message code="crs.label.crecrs.nm" /></th><!-- 과목명 -->
		        									<th><spring:message code="crs.label.decls" /></th><!-- 분반 -->
		        									<th><spring:message code="crs.label.crs.cd" /></th><!-- 학수번호 -->
		        									<th data-breakpoints="xs sm"><spring:message code="crs.label.compdv" /></th><!-- 이수구분 -->
		        									<th data-breakpoints="xs sm"><spring:message code="crs.label.credit" /></th><!-- 학점 -->
		        									<th data-breakpoints="xs sm"><spring:message code="crs.label.lecture" /></th><!-- 강의 -->
		        									<th data-breakpoints="xs sm md"><spring:message code="crs.label.crsopertypecd" /></th><!-- 강의형태 -->
		        									<th data-breakpoints="xs sm md"><spring:message code="crs.label.rep.professor" /></th><!-- 담당교수 -->
		        									<th data-breakpoints="xs sm md"><spring:message code="crs.label.std.cnt" /></th><!-- 수강생수 -->
		        								</tr>
		        							</thead>
		        							<tbody id="userCreList">
		        							</tbody>
		        						</table>
		        						<div id="crePaging" class="paging"></div>
		        					</div>
		        				</div>
		        				<div class="option-content gap4 tc">
			                    	<a href="<c:url value="/user/userMgr/Form/manageUser.do" />" class="ui green button"><spring:message code="common.button.list" /></a><!-- 목록 -->
		        				</div>
		        			</div>
		        		</div>
        			</div>
        		</div>
			</div>
        </div>
        <!-- //본문 content 부분 -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
    </div>
</body>
</html>