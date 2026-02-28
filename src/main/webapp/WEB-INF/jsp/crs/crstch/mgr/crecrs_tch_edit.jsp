<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
	$(document).ready(function () {
		crecrsTchList("PROFESSOR");
		crecrsTchList("ASSISTANT");
	});
	
	// 조교/교수 리스트
	function crecrsTchList(type) {
		var url  = "/crs/creCrsHome/creCrsTchList.do";
		var data = {
			"crsCreCd" 	: "${vo.crsCreCd}",
			"searchKey"	: type
		};

		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				var tchList = data.returnList || [];
				var html = "";
				if(tchList.length > 0) {
					tchList.forEach(function(v, i) {
						
						var email  = v.email != null ? v.email : "";
						var ofceTelno = v.ofceTelno != null ? v.ofceTelno : "-";
						var imgSrc = v.phtFile == null ? "/webdoc/img/icon-hycu-symbol-grey.svg" : v.phtFile;
						
						html += "<div class='ui segment'>";
						html += "	<div class='fields'>";
						html += "		<div class='three wide field'>";
						html += "			<div class='ui segment w150 card' style='height:200px;'>";
						html += "				<img alt='<spring:message code="common.label.image" />' class='wmax pushable' src=\""+imgSrc+"\">";
						html += "			</div>";
						html += "		</div>";
						html += "		<div class='eleven wide field'>";
						html += "			<ul class='tbl-simple'>";
						html += "				<li>";
						html += "					<dl>";
						html += "						<dt><spring:message code='user.title.userinfo.manage.usernm' /></dt>";/* 이름 */
						html += "						<dd>";
						html += "							"+v.userNm;
						if(type == "PROFESSOR") {
						var repYn = v.repYn == "Y" ? "checked" : "";
						html += "							<spring:message code='user.title.tch.professor' /> ";/* 교수 */
						html += "							<div class='ui toggle checkbox ml20'>";
						html += "								<input type='checkbox' tabindex='0' name='repYn' "+repYn+" onchange='editTchType(\""+v.userId+"\", this, \"toggle\");'>";
						html += "								<label><spring:message code='user.title.userinfo.rep.tch' /></label>";/* 대표교수 */
						html += "							</div>";
						}
						html += "						</dd>";
						html += "					</dl>";
						html += "					<dl>";
						html += "						<dt><spring:message code='user.title.userinfo.email' /></dt>";/* 이메일 */
						html += "						<dd>"+email+"</dd>";
						html += "					</dl>";
						html += "					<dl>";
						html += "						<dt><spring:message code='user.title.userinfo.phoneno' /></dt>";/* 전화번호 */
						html += "						<dd>"+ofceTelno+"</dd>";
						html += "					</dl>";
						html += "					<dl>";
						html += "						<dt><spring:message code='user.title.userinfo.tch.div' /></dt>";/* 운영자 구분 */
						html += "						<dd>";
						html += "							<select name='tchType' onchange='editTchType(\""+v.userId+"\", this, \"select\")' class='ui dropdown'>";
																<c:forEach var="item" items="${tchTypeList}">
																if('${item.codeCd}' != 'MONITORING') {
																	var tchType = v.tchType == "PROFESSOR" && v.repYn == "N" ? "ASSOCIATE" : v.tchType;
																	var isSelected = "${item.codeCd}" == tchType ? 'selected' : '';
						html += `									<option value="${item.codeCd}" \${isSelected}>${item.codeNm}</option>`;
																}
																</c:forEach>
						html += "							</select>";
						html += "						</dd>";
						html += "					</dl>";
						html += "					<p class='fcRed mt15'><spring:message code='user.title.userinfo.email.info' /></p>";/* ! 메일 주소는 공개 여부와 관계없이 공개됩니다. */
						html += "				</li>";
						html += "			</ul>";
						html += "		</div>";
						html += "		<div class='two wide field'>";
						html += "			<div style='position:absolute;bottom:1em;right:1em;'>";
						html += "				<a href='javascript:editTchPop(\""+v.userId+"\")' class='ui blue button'><spring:message code='user.button.mod' /></a>";/* 수정 */
						html += "				<a href='javascript:delTch(\""+v.userId+"\", \""+v.tchType+"\")' class='ui blue button'><spring:message code='user.button.remove' /></a>";/* 삭제 */
						html += "			</div>";
						html += "		</div>";
						html += "	</div>";
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
		console.log(data)
		
		
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
	
	// 학사연동 페이지
    function termLinkMgrForm() {
    	var url  = "/crs/termMgr/selectUniTermByTermLink.do";
		var data = {
		};
		
		ajaxCall(url, data, function(data) {
			if (data.result > 0) {
				var returnVO = data.returnVO;
				if(returnVO != null) {
			    	$("#termLinkMgrForm input[name=termCd]").val(returnVO.termCd);
					$("#termLinkMgrForm").attr("target", "termLinkMgrPopIfm");
			        $("#termLinkMgrForm").attr("action", "/crs/termLinkMgr/termLinkPop.do");
			        $("#termLinkMgrForm").submit();
			        $('#termLinkMgrPop').modal('show');
				} else {
					alert("<spring:message code='crs.termlink.result.pop.msg' />");/* 학사연동 학기 정보가 없습니다. */
				}
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
		});
    }
</script>

<body>
	<form id="tchPopForm" method="POST">
		<input type="hidden" name="crsCreCd" value="${vo.crsCreCd }" />
		<input type="hidden" name="userId" />
	</form>
	<form name="termLinkMgrForm" id="termLinkMgrForm" method="POST">
	   	<input type="hidden" name="termCd" />
	   	<input type="hidden" name="searchMenu" value="POP" />
	</form>
    <div id="wrap" class="pusher">
        <!-- class_top 인클루드  -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>

        <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>

        <div id="container">
            <!-- 본문 content 부분 -->
            <div class="content">
            	<%-- <%@ include file="/WEB-INF/jsp/common/admin/admin_location.jsp" %> --%>
        		<div class="ui form">
        			<div class="layout2">
		                <div id="info-item-box">
		                	<h2 class="page-title flex-item flex-wrap gap4 columngap16">
                                <spring:message code="user.title.tch.info" /><!-- 교수/조교 정보 -->
                                <div class="ui breadcrumb small">
                                    <small class="section"><spring:message code="user.button.mod" /><!-- 수정 --></small>
                                </div>
                            </h2>
		                    <div class="button-area">
		                    	<a class="ui green button" href="${pageContext.request.contextPath }/crs/creCrsMgr/creCrsTchList.do"><spring:message code="user.title.list" /><!-- 목록 --></a>
		                    	<%-- <a class="ui orange button" href="javascript:termLinkMgrForm()"><spring:message code="crs.termlink.title" /><!-- 학사연동 --></a> --%>
		                    </div>
		                </div>
		                <div class="row">
		                	<div class="col">
		                		<div class="option-content mb20">
			                		<h3 class="sec_head"><spring:message code="crs.label.rep.professor" /></h3><!-- 담당교수 -->
			                		<a href="javascript:addTchPop()" class="ui blue button flex-left-auto"><spring:message code="user.title.tch.insert" /></a><!-- 교수/조교 추가 -->
		                		</div>
		                		<div id="profDiv">
		                		</div>
		                		<h3 class="sec_head mt30"><spring:message code="crs.label.rep.assistant" /></h3><!-- 담당조교 -->
		                		<div id="assiDiv">
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
    
    <!-- 교수/조교 추가 팝업 --> 
	<div class="modal fade" id="addTchPop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="user.title.tch.insert" />" aria-hidden="false">
	    <div class="modal-dialog modal-lg" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code='user.button.close' />">
	                    <span aria-hidden="true">&times;</span>
	                </button>
	                <h4 class="modal-title"><spring:message code="user.title.tch.insert" /></h4><!-- 교수/조교 추가 -->
	            </div>
	            <div class="modal-body">
	                <iframe src="" id="addTchPopIfm" name="addTchPopIfm" width="100%" scrolling="no"></iframe>
	            </div>
	        </div>
	    </div>
	</div>
	<!-- 교수/조교 정보 간편 수정 팝업 --> 
	<div class="modal fade" id="editTchPop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="user.title.tch.info.simple.edit" />" aria-hidden="false">
	    <div class="modal-dialog modal-lg" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code='user.button.close' />">
	                    <span aria-hidden="true">&times;</span>
	                </button>
	                <h4 class="modal-title"><spring:message code="user.title.tch.info.simple.edit" /></h4><!-- 교수/조교 정보 간편 수정 -->
	            </div>
	            <div class="modal-body">
	                <iframe src="" id="editTchPopIfm" name="editTchPopIfm" width="100%" scrolling="no"></iframe>
	            </div>
	        </div>
	    </div>
	</div>
	<!-- 학사연동 팝업 --> 
	<div class="modal fade" id="termLinkMgrPop" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="crs.termlink.title" />" aria-hidden="false">
	    <div class="modal-dialog modal-lg" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code='user.button.close' />"><!-- 닫기 -->
	                    <span aria-hidden="true">&times;</span>
	                </button>
	                <h4 class="modal-title"><spring:message code="crs.termlink.title" /></h4><!-- 학사연동 -->
	            </div>
	            <div class="modal-body">
	                <iframe src="" id="termLinkMgrPopIfm" name="termLinkMgrPopIfm" width="100%" scrolling="no"></iframe>
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