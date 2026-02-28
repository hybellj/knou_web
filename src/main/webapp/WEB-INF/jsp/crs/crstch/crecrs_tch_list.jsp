<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/main_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
	
	<script type="text/javascript">
		$(document).ready(function () {
			crecrsTchList("PROFESSOR");
			crecrsTchList("ASSISTANT");
		});
		
		// 조교/교수 리스트
		function crecrsTchList(type) {
			var menuType = '<c:out value="${menuType}" />';
			
			var url  = "/crs/creCrsHome/creCrsTchList.do";
			var data = {
				"crsCreCd" 	: "${vo.crsCreCd}",
				"searchKey"	: type
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					var tchList = data.returnList || [];
					var html = "";
					var orgId = '<c:out value="${orgId}" />';
					
					if(tchList.length > 0) {
						tchList.forEach(function(v, i) {
							var formClass = i > 0 ? "mt15" : "";
							var ofceTelNo = v.ofceTelNo != null ? v.ofceTelNo : "-";
							var imgSrc = v.phtFile == null || type == "ASSISTANT" ? "/webdoc/img/icon-hycu-symbol-grey.svg" : v.phtFile;
							html += "<div class='ui form userInfoManage type2 "+formClass+"'>";
							html += "	<div class='userImg'>";
							html += "		<div class='image'>";
							html += "			<img src=\""+imgSrc+"\" alt='사용자 이미지'>";
							html += "		</div>";
							html += "	</div>";
							html += "	<ul class='tbl'>";
							html += "		<li>";
							html += "			<dl>";
							html += "				<dt><spring:message code='user.title.userinfo.manage.usernm' /></dt>";/* 이름 */
							html += "				<dd>"+v.userNm;
							if(type == "PROFESSOR") {
							var repYn = v.repYn == "Y" ? "checked" : "";
							html += "					<spring:message code='user.title.tch.professor' />";/* 교수 */
								if(menuType.indexOf("PROFESSOR") > -1) {
							html += "					<div class='ui toggle checkbox ml20'>";
							html += "						<input type='checkbox' tabindex='0' name='repYn' "+repYn+" onchange='editTchType(\""+v.userId+"\", this, \"toggle\");' " + (orgId == "ORG0000001" ? "disabled" : "") + ">";
							html += "						<label><spring:message code='user.title.userinfo.rep.tch' /></label>";/* 대표교수 */
							html += "					</div>";
								}
							}
							if(menuType.indexOf("STUDENT") > -1 && "true" == "<%=SessionInfo.isKnou(request)%>") {
							html += "					<a href='javascript:erpSendMessagePop(\"" + v.userId + "\")' title='<spring:message code='user.title.userinfo.email' />'><span class='hide'><spring:message code='user.title.userinfo.email' /></span><i class='icon-mail ico'></i></a>";
							}
							html += "				</dd>";
							html += "			</dl>";
							html += "		</li>";
							html += "		<li>";
							html += "			<dl>";
							html += "				<dt><spring:message code='user.title.userinfo.email' /></dt>";/* 이메일 */
							html += "				<dd>"+v.email+"</dd>";
							html += "			</dl>";
							html += "		</li>";
							html += "		<li>";
							html += "			<dl>";
							html += "				<dt><spring:message code='user.title.userinfo.phoneno' /></dt>";/* 전화번호 */
							if(type == "PROFESSOR") {
							//html += "				<dd>-</dd>"; // 노출안함 '-'으로 표시
							// 교수전화번호 표시함
							html += "				<dd>"+ formatPhoneNumber(ofceTelNo) +"</dd>"; // ###-####-#### 형식으로 표시
							} else{
							html += "				<dd>"+ formatPhoneNumber(ofceTelNo) +"</dd>"; // ###-####-#### 형식으로 표시
							}
							html += "			</dl>";
							html += "		</li>";
							if(menuType.indexOf("PROFESSOR") > -1) {
							html += "		<li>";
							html += "			<dl>";
							html += "				<dt><spring:message code='user.title.userinfo.tch.div' /></dt>";/* 운영자 구분 */
							html += "				<dd>";
							html += "					<select name='tchType' onchange='editTchType(\""+v.userId+"\", this, \"select\")' class='ui dropdown' " + (orgId == "ORG0000001" ? "disabled" : "") + ">";
															<c:forEach var="item" items="${tchTypeList}">
															if('${item.codeCd}' != 'MONITORING') {
																var tchType = v.tchType == "PROFESSOR" && v.repYn == "N" ? "ASSOCIATE" : v.tchType;
																var isSelected = "${item.codeCd}" == tchType ? 'selected' : '';
							html += `							<option value="${item.codeCd}" \${isSelected}>${item.codeNm}</option>`;
															}
															</c:forEach>
							html += "					</select>";
							html += "				</dd>";
							html += "			</dl>";
							html += "		</li>";
							html += "		<li class='mss-txt'>";
							html += "			<div class='ui error message'><spring:message code='user.title.userinfo.email.info' /></div>";/* ! 메일 주소는 공개 여부와 관계없이 공개됩니다. */
							html += "		</li>";
							} else {
							html += "		<li>";
							html += "			<dl>";
							html += "				<dt><spring:message code='user.title.userinfo.tch.div' /></dt>";/* 운영자 구분 */
							var tchTypeNm = "";
							<c:forEach var="item" items="${tchTypeList}">
								if("${item.codeCd}" == v.tchType) tchTypeNm = "${item.codeNm}";
							</c:forEach>
							html += "				<dd>"+tchTypeNm+"</dd>";
							html += "			</dl>";
							html += "		</li>";
							}
							html += "	</ul>";
							html += "</div>";
						});
					}
					if(type == "PROFESSOR") {
						$("#profDiv").empty().append(html);
					} else {
						$("#assiDiv").empty().append(html);
					}
					$(".dropdown").dropdown();
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
			});
		}
		
		// 운영자 구분 변경
		function editTchType(userId, obj, type) {
			var repYn   = "";
			var tchType = "";
			if(type == "toggle") {
				repYn   = obj.checked ? "Y" : "N";
				tchType = obj.checked ? "PROFESSOR" : "ASSOCIATE";
			} else {
				repYn   = obj.value == "PROFESSOR" ? "Y" : "N";
				tchType = obj.value;
			}
			
			var url  = "/crs/creCrsHome/updateCrecrsTch.do";
			var data = {
				"crsCreCd" 	: "${vo.crsCreCd}",
				"userId"	: userId,
				"tchType"	: tchType,
				"repYn"		: repYn
			};
			
			ajaxCall(url, data, function(data) {
				if (data.result > 0) {
					crecrsTchList("PROFESSOR");
					if(type == "select") {
						crecrsTchList("ASSISTANT");
					}
	            } else {
	             	alert(data.message);
	            }
			}, function(xhr, status, error) {
				alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
			});
		}
		
		<%--
		// 조교/교수 추가 팝업
		function addTchPop() {
			$("#tchPopForm input[name=userId]").val("");
			$("#tchPopForm").attr("target", "addTchPopIfm");
	        $("#tchPopForm").attr("action", "/crs/creCrsHome/addTchPop.do");
	        $("#tchPopForm").submit();
	        $('#addTchPop').modal('show');
		}
		
		// 조교/교수 정보 수정 팝업
		function editTchPop(userId) {
			$("#tchPopForm input[name=userId]").val(userId);
			$("#tchPopForm").attr("target", "editTchPopIfm");
	        $("#tchPopForm").attr("action", "/crs/creCrsHome/editTchPop.do");
	        $("#tchPopForm").submit();
	        $('#editTchPop').modal('show');
		}
		
		// 조교/교수 삭제
		function delTch(userId, tchType) {
			if(confirm("<spring:message code='user.message.userinfo.crecrs.del.confirm' />")) {/* 삭제하시겠습니까? */
				var url  = "/crs/creCrsHome/deleteCrecrsTch.do";
				var data = {
					"crsCreCd" 	: "${vo.crsCreCd}",
					"userId"	: userId
				};
				
				ajaxCall(url, data, function(data) {
					if (data.result > 0) {
						var type = tchType == "ASSISTANT" ? tchType : "PROFESSOR";
						crecrsTchList(type);
						alert("<spring:message code='user.message.userinfo.crecrs.del.success' />");/* 정상 삭제되었습니다. */
		            } else {
		             	alert(data.message);
		            }
				}, function(xhr, status, error) {
					alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
				});
			}
		}
		--%>
		
		// 쪽지보내기
		function erpSendMessagePop(userId) {
			$("#sendErpMessageForm input[name=userId]").val(userId);
			$("#sendErpMessageForm input[name=crsCreCd]").val("${vo.crsCreCd}");
			$("#sendErpMessageForm").attr("target", "sendErpMessageIfm");
	        $("#sendErpMessageForm").attr("action", "/erp/sendErpMessagePop.do");
	        $("#sendErpMessageForm").submit();
	        $("#sendErpMessagePop").modal('show');
		}
	</script>
</head>
<body class="<%=SessionInfo.getThemeMode(request)%>">
	<form id="tchPopForm" method="POST">
		<input type="hidden" name="crsCreCd" value="${vo.crsCreCd }" />
		<input type="hidden" name="userId" />
	</form>
    <div id="wrap" class="pusher">
        <!-- class_top 인클루드  -->
        <%@ include file="/WEB-INF/jsp/common/class_lnb.jsp" %>

        <div id="container">
            <%@ include file="/WEB-INF/jsp/common/class_header.jsp" %>
            <!-- 본문 content 부분 -->
            <div class="content">
            	<%@ include file="/WEB-INF/jsp/common/class_info.jsp" %>
        		<div class="ui form">
        			<div class="layout2">
        				<script>
						$(document).ready(function () {
							var locationStr = ${fn:contains(menuType, 'PROFESSOR')} ? "<spring:message code='user.title.list' />"/* 목록 */ : "";
							// set location
							setLocationBar('<spring:message code="user.title.tch.info" />', locationStr);
						});
						</script>
		                <div id="info-item-box">
		                    <h2 class="page-title flex-item flex-wrap gap4 columngap16">
		                    	<spring:message code="user.title.tch.info" /><!-- 교수/조교 정보 -->
		                    </h2>
		                    <div class="button-area">
		                    	<%-- <c:if test="${orgId ne 'ORG0000001'}">
		                        	<a href="javascript:addTchPop()" class="ui blue button" title="<spring:message code="user.title.tch.insert" />"><spring:message code="user.title.tch.insert" /></a><!-- 교수/조교 추가 -->
		                    	</c:if> --%>
		                    </div>
		                </div>
		                <div class="row">
		                	<div class="col">
		                		<h3 class="sec_head"><spring:message code="crs.label.rep.professor" /></h3><!-- 담당교수 -->
		                		<div id="profDiv"></div>
		                		<h3 class="sec_head mt30">
		                			<c:choose>
				            			<c:when test="${creCrsVO.crsCd eq 'CHY164'}">
				            				<spring:message code="crs.label.acad.coach" /><!-- 학업코치 -->
				            			</c:when>
				            			<c:otherwise>
				            				<spring:message code="crs.label.rep.assistant" /><!-- 담당조교 -->
				            			</c:otherwise>
				            		</c:choose>
		                			
	                			</h3>
		                		<div id="assiDiv"></div>
		                	</div>
		                </div>
        			</div>
        		</div>
            </div>
            <%@ include file="/WEB-INF/jsp/common/frontFooter.jsp" %>
        </div>
        <!-- //본문 content 부분 -->
    </div>
    
    <!-- 교수/조교 추가 팝업 --> 
	<div class="modal fade" id="addTchPop" tabindex="-1" role="dialog" aria-labelledby="교수/조교 추가 모달" aria-hidden="false">
	    <div class="modal-dialog modal-lg" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
	                    <span aria-hidden="true">&times;</span>
	                </button>
	                <h4 class="modal-title"><spring:message code="user.title.tch.insert" /></h4><!-- 교수/조교 추가 -->
	            </div>
	            <div class="modal-body">
	                <iframe src="" id="addTchPopIfm" name="addTchPopIfm" width="100%" scrolling="no" title="<spring:message code="user.title.tch.insert" />"></iframe>
	            </div>
	        </div>
	    </div>
	</div>
	<!-- 교수/조교 정보 간편 수정 팝업 --> 
	<div class="modal fade" id="editTchPop" tabindex="-1" role="dialog" aria-labelledby="교수/조교 정보 간편 수정 모달" aria-hidden="false">
	    <div class="modal-dialog modal-lg" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
	                    <span aria-hidden="true">&times;</span>
	                </button>
	                <h4 class="modal-title"><spring:message code="user.title.tch.info.simple.edit" /></h4><!-- 교수/조교 정보 간편 수정 -->
	            </div>
	            <div class="modal-body">
	                <iframe src="" id="editTchPopIfm" name="editTchPopIfm" width="100%" scrolling="no" title="<spring:message code="user.title.tch.info.simple.edit" />"></iframe>
	            </div>
	        </div>
	    </div>
	</div>
	
	<!-- 쪽지보내기 팝업 -->
	<form id="sendErpMessageForm" name="sendErpMessageForm" method="post">
		<input name="userId" type="hidden"/>
		<input name="crsCreCd"  type="hidden"/>
	</form>
	<div class="modal fade" id="sendErpMessagePop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="common.label.send.message" />" aria-hidden="false">
	    <div class="modal-dialog modal-md" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
	                    <span aria-hidden="true">&times;</span>
	                </button>
	                <h4 class="modal-title"><spring:message code="common.label.send.message" /></h4><!-- 쪽지 보내기 -->
	            </div>
	            <div class="modal-body">
	                <iframe src="" id="sendErpMessageIfm" name="sendErpMessageIfm" width="100%" scrolling="no" title="<spring:message code="common.label.send.message" />"></iframe>
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