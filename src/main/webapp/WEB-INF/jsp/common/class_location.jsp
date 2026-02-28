<%@page import="knou.framework.common.SessionInfo"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="spring" 		uri="http://www.springframework.org/tags"%>

<div class="location-wrap">
    <!-- 페이지 정보 -->
    <div class="ui menu">
    	<% 
    	if("Y".equals(SessionInfo.getProfessorVirtualLoginYn(request))) { 
    		%>
    		<a href="javascript:void(0)" class="home r_btn"><img src="/webdoc/img/location_home.gif" alt="<spring:message code="button.go.home" />"></a><!-- 홈으로 -->
			<% 
		}
    	if(!"Y".equals(SessionInfo.getProfessorVirtualLoginYn(request))) { 
    		if (SessionInfo.isAdminCrsInfo(request)) {
	    		%>
	    		<a href="javascript:void(0)" class="home r_btn" title="Home"><img src="/webdoc/img/location_home.gif" alt="<spring:message code="button.go.home" />"></a><!-- 홈으로 -->
				<% 
    		}
    		else {
    			%>
	    		<a href="<%=SessionInfo.getCurUserHome(request)%>" class="home r_btn" title="Home"><img src="/webdoc/img/location_home.gif" alt="<spring:message code="button.go.home" />"></a><!-- 홈으로 -->
				<% 
    		}
		} 
		%>
        <div class="pageTit_wrap">                
            <ul id="locationBar" class="page_locat">
            	<li>
            		<a href="<%=SessionInfo.getCurUserHome(request)%>" title="Home"><spring:message code="bbs.label.bbs_lect_home" /></a>
            	</li> 
                <li <% if(!"Y".equals(SessionInfo.getProfessorVirtualLoginYn(request))) { %> title="<spring:message code="common.log.classroom.home" />"  onclick="location.href='<%=SessionInfo.getCurCorHome(request)%>?crsCreCd=<%=SessionInfo.getCurCrsCreCd(request)%>'" style="cursor: pointer;"<% } %>>
               		<spring:message code="common.log.classroom.home" /><!-- 과목홈 -->
             	</li>
            </ul>
        </div>
    </div>
    <!-- //페이지 정보 -->

    <!-- 학기/강의실 선택하기 -->
    <div class="option-content" style="<%=("mobile".equals(SessionInfo.getDeviceType(request)) ? "display:none" : "")%>">
		<% if(!"Y".equals(SessionInfo.getProfessorVirtualLoginYn(request))) { %>
		<label for="courseTerm" class="hide">courseTerm</label>
		<select id="courseTerm" class="ui dropdown">
		</select>
		<label for="courseSel" class="hide">courseSel</label>
		<select id="courseSel" class="ui dropdown my-class">
		</select>
		<% } %>
    </div>
     <!-- //학기/강의실 선택하기 -->
</div>

<script type="text/javascript">
	var termCd = "<%=SessionInfo.getCurTerm(request)%>";		
	var crsCreCd = "<%=SessionInfo.getCurCrsCreCd(request)%>";
	
	// Location 값 설정
	function setLocationBar(loc1, loc2, loc3) {
		var locationBar = $("#locationBar");
		if (loc1 != null && loc1 != "") {
			locationBar.append("<li>"+loc1+"</li>");
		}
		if (loc2 != null && loc2 != "") {
			locationBar.append("<li>"+loc2+"</li>");
		}
		if (loc3 != null && loc3 != "") {
			locationBar.append("<li>"+loc3+"</li>");
		}
	}
	
	function changeTerm() {
		termCd = $("#courseTerm option:selected").val();
		viewCorsList();
	}
	
	function changeCors() {
		var crsCreCd = $("#courseSel option:selected").val();
		document.location.href = "/crs/crsHome.do?crsCreCd="+crsCreCd;
	}
	
	// 학기목록 조회
	function viewTermList() {
		var url = "/crs/listClassroomTerm.do";
		var data = {
			  crsCreCd: crsCreCd
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var selVal = "";
				var returnList = data.returnList || [];
				var html = '';
        		html += '<option value=""><spring:message code="sys.label.select.haksa.term" /></option>';	// 학기선택
        		
				returnList.forEach(function(v, i) {
					var selected = "";
					if (v.termCd == termCd) {
						selected="selected";
						selVal = v.termNm;
					}
        			html += '<option value="' + v.termCd + '" '+selected+'>' + v.termNm + '</option>';
        		});
				
				$("#courseTerm").html(html);
				$("#courseTerm").dropdown();
				$("#courseTerm").parent().children(".text").html(selVal);
				$("#courseTerm").on("change", function() {
					changeTerm();
       			});
        	}
		}, function(xhr, status, error) {
			console.log('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
		});
	}
	
	// 학기 과목목록 조회
	function viewCorsList() {
		var url = "/crs/listClassroomCors.do";
		var data = {
			 termCd: termCd
		};
		
		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
				var selVal = "";
				var returnList = data.returnList || [];
				var html = '';
        		html += '<option value="" selected><spring:message code="bbs.label.bbs_lect_goto" /></option>';	// 강의실 바로가기
        		
				returnList.forEach(function(v, i) {
					if(v.crsTypeCd == "UNI") {
						var selected = "";
						if (v.crsCreCd == crsCreCd) {
							selected="selected";
							selVal = v.crsCreNm;
						}
						
						var uniPrefix = "";
						
						if(v.univGbn == "2") {
							uniPrefix = '[<spring:message code="crs.label.special"/>]'; // 특수
						}
						if(v.univGbn == "3") {
							uniPrefix = '[<spring:message code="crs.label.general"/>]'; // 일반
						}
						if(v.univGbn == "4") {
							uniPrefix = '[<spring:message code="crs.label.busi"/>]'; // 전문
						}
	        			html += '<option value="' + v.crsCreCd + '" '+selected+'>' + uniPrefix + v.crsCreNm + ' ('+v.declsNo+')</option>';
					}
        		});

				$("#courseSel").html(html);
				$("#courseSel").dropdown();
				$("#courseSel").parent().children(".text").html("<spring:message code='bbs.label.bbs_lect_goto' />");	// 강의실 바로가기
				$("#courseSel").on("change", function() {
					changeCors();
       			});
        	}
		}, function(xhr, status, error) {
			console.log('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
		});
	}
	
	viewTermList();
	viewCorsList();
</script>