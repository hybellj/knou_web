<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
var cfgVal = "${cfgVO.cfgVal}";
$(document).ready(function() {
	if(cfgVal == "N"){
		$("#cfgValN").trigger("click");
	}else if(cfgVal == "Y"){
		$("#cfgValY").trigger("click");
		$("#connIpStr").css("display","");
		connIpList(1);
		connLogList(1);
	}
	
	$("#searchValue").on("keydown", function(e) {
		if(e.keyCode == 13) {
			connLogList(1);
		}
	});
});

function searchCheck(){
	if($("#searchValue").val().length > 100){
		    $("#note-box").prop("class", "warning");
			$("#note-box p").text(getCommonMessage("msg012",'<spring:message code="button.search" />','100',$("#searchValue").val().length)); //검색은 100자리를 넘을 수 없습니다. 현재 글자수({2})
			$("#note-btn").trigger("click");
			return false;
	}
	return true;
}

function connIpList(page){
	$("#connIpListDiv").load("/menu/menuMgr/listConnIp.do",
		{"pageIndex" : page,
			 "listScale" : $("#listScale").val()
		},			// params
		function (){
	    }
	);
}

function connLogList(page){
	if(!searchCheck()) {return false;}
	
	$("#connLogListDiv").load("/menu/menuMgr/listConnLog.do",
		{"pageIndex" : page,
			 "listScale" : $("#listScaleLog").val(),
			 "searchValue" : $("#searchValue").val()
		},			// params
		function (){
	    }
	);
}

function saveConnSetting() {
	$.getJSON("/menu/menuMgr/saveConnSetting.do",
	   {"cfgVal" : cfgVal
	   },			// params
	   function(data) {
			if(data.result > 0) {
				$("#note-box").removeClass("warning");
				$("#note-box p").text(data.message);
				$("#note-btn").trigger("click");

			} else {
				$("#note-box").prop("class","warning");
				$("#note-box p").text(data.message);
				$("#note-btn").trigger("click");
			}
		}
	);
}

function cfgValControl(val) {
	cfgVal = val;
	if(val == "Y") {
		connIpList(1);
		$("#connIpStr").css("display","");
	} else if(val == "N") {
		$("#connIpListDiv").html("");
		$("#connIpStr").css("display","none");
	}
}

function bandControl() {
	if($("#bandCheck").is(":checked")) {
		$("#ip5").removeAttr("disabled");
	} else {
		$("#ip5").attr("disabled","disabled");
	}
}

function addConnIp() {
	
	if($("#ip1").val() == "" || $("#ip2").val() == "" || $("#ip3").val() == "" || $("#ip4").val() == ""){
		$("#note-box").prop("class","warning");
		$("#note-box p").text('<spring:message code="main.connIp.val.ip" />');
		$("#note-btn").trigger("click");
		return false;
	}
	
	var connIp = "";
	connIp = $("#ip1").val()+"."+$("#ip2").val()+"."+$("#ip3").val()+"."+$("#ip4").val();
	
	var bandYn = "";
	if($("#bandCheck").is(":checked")) {
		bandYn = "Y";
	} else {
		bandYn = "N";
	}
	if(bandYn == "Y" && $("#ip5").val() == ""){
		$("#note-box").prop("class","warning");
		$("#note-box p").text('<spring:message code="main.connIp.val.band" />');
		$("#note-btn").trigger("click");
		return false;
	}
	$.getJSON("/menu/menuMgr/addConnIp.do",
		{"connIp" : connIp,
		"bandYn" : bandYn,
		"bandVal" : $("#ip5").val()
		},			// params
		function(data) {
			if(data.result > 0) {
				$("#note-box").removeClass("warning");
				$("#note-box p").text(data.message);
				$("#note-btn").trigger("click");
				connIpList(1);
			} else {
				$("#note-box").prop("class","warning");
				$("#note-box p").text(data.message);
				$("#note-btn").trigger("click");
			}
		}
	);
}

function removeConnIp(connIp){
	$.getJSON("/menu/menuMgr/removeConnIp.do",
	   {"connIp" : connIp
	   },			// params
	   function(data) {
			if(data.result > 0) {
				$("#note-box").removeClass("warning");
				$("#note-box p").text("'"+connIp+"' "+data.message);
				$("#note-btn").trigger("click");
				connIpList(1);
			} else {
				$("#note-box").prop("class","warning");
				$("#note-box p").text("'"+connIp+"' "+data.message);
				$("#note-btn").trigger("click");
			}
		}
	);
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
                <div class="content">

                    <!-- admin_location -->
                    <%-- <%@ include file="/WEB-INF/jsp/common/admin/admin_location.jsp" %> --%>
                    <!-- //admin_location -->

                    <!-- ui form -->
                    <div class="ui form">

						<div id="info-item-box">	
	                        <h2 class="page-title"><spring:message code="main.connIp.title"/></h2>	<!--관리자 IP 관리-->
	                        <div class="button-area">
	                            	<a href="javascript:saveConnSetting();" class="btn btn-primary"><spring:message code="button.add"/></a>	<!-- 저장 -->
	                            <a href="/menu/menuMgr/manageConnIp.do" class="btn btn-negative"><spring:message code="button.cancel"/></a>		<!-- 취소 -->
	                        </div>
	                    </div>
                    
                        <!-- 콘텐츠 영역 -->
						<div class="ui grid stretched row">
                            <div class="sixteen wide tablet eight wide computer column">
                                <div class="option-content">
                                    <div class="inline fields mb0">
                                        <label for="conectLabel"><spring:message code="main.connIp.conn.limit.set"/></label>		<!-- 접속제한 설정 -->
                                        <div class="ui basic buttons btn-choice mo-wmax">
                                            <a href="javascript:cfgValControl('N');" class="w150 ui button active" id="cfgValN"><spring:message code="main.connIp.conn.limit.none"/></a>	<!-- 접속 제한 없음 -->
                                            <a href="javascript:cfgValControl('Y');" class="w150 ui button" id="cfgValY"><spring:message code="main.connIp.conn.limit.ip"/></a>	<!-- IP 접속 제한 -->
                                        </div>
                                    </div>
                                    <div class="button-area">
                                        <span class="fcRed" id="connIpStr" style="display: none;"><spring:message code="main.connIp.conn.limit.ip.reg"/></span>	<!-- * 등록된 IP만 접속 가능합니다. -->
                                    </div>
                                </div>
                                
                                <div class="ui attached message">
                                    <div class="header"><spring:message code="main.connIp.conn.ip.list"/></div>	<!-- 접속 가능 IP 등록 -->
                                </div>
                                <div class="ui bottom attached segment">
									<div class=" fields">
                                        <label for="conectLabel"><spring:message code="main.connIp.conn.current.ip"/></label>	<!-- 현재 접속 IP -->
                                        <div class="field">${connIp }</div>
                                    </div>
                                    <div class=" fields flex-item">
										<div class="ui small input">
                                            <input type="text" id="ip1" class="w70" maxlength="3"><span>.</span>
                                        </div>
                                        <div class="ui small input">
                                            <input type="text" id="ip2" class="w70" maxlength="3"><span>.</span>
                                        </div>
                                        <div class="ui small input">
                                            <input type="text" id="ip3" class="w70" maxlength="3"><span>.</span>
                                        </div>
                                        <div class="ui small input">
											<input type="text" id="ip4" class="w70" maxlength="3"><span>~</span>
                                        </div>
                                        <div class="ui small input">
                                            <input type="text" id="ip5" class="w70" maxlength="3" disabled>
                                        </div>
                                        <a href="javascript:addConnIp();" class="ui blue small button mr10"><spring:message code="button.plus"/></a>	<!-- 추가 -->
                                        <div class="ui checkbox">
                                            <input type="checkbox" name="bandCheck" id="bandCheck" onchange="bandControl();"> 
                                            <label><spring:message code="main.connIp.band.set"/></label>	<!-- 대역 지정하기 -->
                                        </div>
                                        <select class="ui dropdown list-num mla" id="listScale" onchange="connIpList(1);">
                                            <option value="5">5</option>
                                            <option value="10">10</option>
                                            <option value="20">20</option>
                                            <option value="50">50</option>
                                            <option value="100">100</option>
                                        </select>
                                    </div>
                                    <div id="connIpListDiv"></div>
                                    <div class="ui inverted dimmer"></div>
                                    <script>
                                        $('.btn-choice .ui.button').click(function(){
                                            if($(this).is(":first-child")) {
                                                $('.dimmer').dimmer({closable: false})
                                                .dimmer('show');
                                            } else {
                                                $('.dimmer').dimmer({closable: false})
                                                .dimmer('hide');
                                            }
                                        });
                                    </script>
                                </div>
                            </div>
                            <div class="sixteen wide tablet eight wide computer column">
                                <div class="ui attached message">
                                    <div class="header"><spring:message code="main.connIp.conn.rec.list"/></div>		<!-- 접속 기록 조회 -->
                                </div>
                                <div class="ui bottom attached segment">
                                    <div class="option-content">
                                        <div class="ui action input search-box">
                                            <input type="text" placeholder='<spring:message code="button.search"/>' id="searchValue" />	<!-- 검색 -->
                                            <button class="ui icon button" type="button" onclick="connLogList(1);"><i class="search icon"></i></button>
                                        </div>
                                        <div class="button-area">
                                            <select class="ui dropdown list-num" id="listScaleLog" onchange="connLogList(1);">
                                                <option value="5">5</option>
                                                <option value="10">10</option>
                                                <option value="20">20</option>
                                                <option value="50">50</option>
                                                <option value="100">100</option>
                                            </select>
                                        </div>
                                    </div>
                                	<div id="connLogListDiv"></div>
                                </div>
                            </div>
                        </div>
                        <!-- //콘텐츠 영역 -->

                    </div>
                    <!-- //ui form -->

                </div>
                <!-- //본문 content 부분 -->
            </div>
            <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
        </div>
    </body>
</html>
