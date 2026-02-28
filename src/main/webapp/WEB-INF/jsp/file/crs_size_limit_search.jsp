<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
    <%-- 페이지 초기화 --%>
    $(document).ready(function() {
    	
    	if("${empty vo.crsTypeCd}"){
    		$("#creYear").parent().hide();
            getTermList();
    	}
    	
        listDefaultCrsSizeLimitSlide();
        listCrsSizeLimit(1);
    });

    <%-- 전체 --%>
    function changeCrsTypeCd(obj){
   	var crsTypeCd =  obj.value;
   	if("UNI" == crsTypeCd){
   		$("#searchType").parent().show();
   		$("#searchCreTerm").parent().show();
   		$("#searchValue").show();
   		$("#creYear").parent().hide();
   		getTermList();
   	} else {
   		$("#searchType").parent().hide();
   		$("#searchCreTerm").parent().hide();
   		$("#searchValue").show();
   		$("#creYear").parent().show();
   	}
   		listCrsSizeLimit(1);
   } 
    
    <%--  검색 처리 --%>
    function keyDownSearch() {
        if(window.event.keyCode == 13) {
        	listCrsSizeLimit(1);
        }
    }

    <%--  슬라이드 호출 --%>
    function listDefaultCrsSizeLimitSlide(limitTypeCd) {
        $('#sidebarForm').load(
            "/file/fileMgr/defaultCrsSizeLimitList.do"
            , {   "limitTypeCd" : limitTypeCd }
            , function () {}
        );
    } 

    <%--  리스트 호출 --%>
    function listCrsSizeLimit(page) {
    	var crsTypeCd = $("#crsTypeCd").val();
    	if(crsTypeCd !="UNI"){
    		$("#searchType").val('');
    	}
    	
        $('#crsSizeLimitListBlcok').load(
            "/file/fileMgr/crsSizeLimitList.do"
            , {   "searchType" : $("#searchType").val()
                , "searchCreTerm" : $("#searchCreTerm").val()
                , "searchValue" : $("#searchValue").val()
                , "crsTypeCd" : $("#crsTypeCd").val()
                , "creYear" : $("#creYear").val()
                , "listScale" : $("#listScale").val()
                , "pageIndex" : page
              }
            , function () {}
        );
    } 

    <%--  학기 검색조건 불러오기 --%>
    function getTermList() {
        if ($("#searchType").val() == '') {
            return;
        }

        $("#loading_page").show();
        $('#searchCreTerm').children('option:not(:first)').remove();
        $('#searchCreTerm').dropdown('set selected', ['ALL_SEARCH']);

        $.ajax({
            type : "POST",
            async: false,
            dataType : "json",
            data : {"searchType" : $("#searchType").val()},
            url : "/file/fileMgr/search/term.do",
            success : function(data){
                if(data.result >= 0) {
                    $.each(data.returnList, function(key, value) {
                        $('#searchCreTerm').append($("<option></option>").attr("value", value.termCd).text(value.termNm)); 
                    });
                } else {
                    $("#note-box").prop("class", "warning");
                    $("#note-box p").text(data.message);
                    $("#note-btn").trigger("click");
                }
            },
            beforeSend: function() {
            },
            complete:function(status){
                $("#loading_page").hide();
            },
            error: function(xhr,  Status, error) {
                $("#loading_page").hide();
            }
        });
        listCrsSizeLimit(1);
    }

    <%--  초기설정 슬라이드 호출 --%>
    function dipslaySlideBar() {
        $('#sidebarForm').sidebar('show');
    }
</script>

<div id="wrap" class="pusher">
    
	<!-- header -->
    <%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp" %>
    <!-- //header -->

    <!-- lnb -->
    <%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp" %>
    <!-- //lnb -->
        
    <div id="container">
        
        <div class="content">
                
        	<!-- admin_location -->
            <%-- <%@ include file="/WEB-INF/jsp/common/admin/admin_location.jsp" %> --%>
            <!-- //admin_location -->

			<div id="info-item-box">
            	<h2 class="page-title"><spring:message code="filemgr.label.crsauth.title" /></h2> <%-- 과목별 용량관리 --%>
				<%-- <div class="button-area">
					<a href="javascript:dipslaySlideBar();" id="btnDefaultSetting" class="btn sidebar-button"><spring:message code="filemgr.button.default.set" /></a> 초기설정
				</div> --%>
            </div>
            <div class="ui form">
                	<div class="option-content">
	                	<select class="ui dropdown mr5" id="crsTypeCd" name="crsTypeCd" onchange="changeCrsTypeCd(this)">
						         <option value="UNI" <c:if test="${empty vo.crsTypeCd}">selected</c:if>><spring:message code="common.label.semester.sys" /></option>	<%-- 학기제 --%>
						         <option value="CO"><spring:message code="common.label.fundamental.sys" /></option>	<%-- 비교과 --%>
						         <option value="OPEN"><spring:message code="common.label.open.crs" /></option>	<%-- 공개 강좌 --%>
					    </select>

						<select class="ui dropdown mr5" id="searchType" name="searchType" onChange="getTermList()">
	                            <c:forEach items="${crsOperCdList }" var="item" varStatus="status">
	                                <option value="${item.codeCd }"><c:out value='${item.codeNm}' /></option>
	                            </c:forEach>
						</select>
						
                        <select class="ui dropdown mr5" id="searchCreTerm" name="searchCreTerm" onchange="listCrsSizeLimit(1)">
                                <option value="ALL_SEARCH"><spring:message code="common.all" /></option> <%-- 전체 --%>
						</select>	

						<%-- 비교과, 공개강좌 --%>
				        <select name="creYear" id="creYear" onchange="listCrsSizeLimit(1)" class="ui compact dropdown mr5 ">
							<c:forEach items="${yearList}" var="year">
								<option value="${year}" <c:if test="${year eq curYear}"> selected="selected"</c:if>>${year}</option>
							</c:forEach>
						</select>  
                            
						<div class="ui action input search-box">
                                <input type="text" id="searchValue" name="searchValue" maxlength="50" onKeyDown="keyDownSearch()" placeholder="<spring:message code="button.search" />"> <%-- 검색 --%>
                                <button type="button" class="ui icon button" id="btnCrsSizeLimitSearch" onClick="listCrsSizeLimit(1)"><i class="search icon"></i></button>
                        </div>
                        
                        <div class="button-area">
                            <select class="ui dropdown list-num" id="listScale" name="listScale" onChange="listCrsSizeLimit(1)">
                                <option value="10">10</option>
                                <option value="20">20</option>
                                <option value="50">50</option>
                                <option value="100">100</option>
                            </select>
                        </div>
                    </div>
                    <div id="crsSizeLimitListBlcok"></div>
            </div>
        </div>
 		<!-- //본문 container 부분 -->
        <include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
	</div>
 </div>
</body>
</html>
