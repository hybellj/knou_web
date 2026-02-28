<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
$(document).ready(function(){
	var tabOrder = 1;
	fnTab(tabOrder);
});

// 과정유형 선택
function selectContentCrsType(obj) {

	if($(obj).hasClass("basic")) {
		$(obj).removeClass("basic").addClass("active");
	} else {
		$(obj).removeClass("active").addClass("basic");
	}
	listOperate(tabOrder);
}

/* 강의알리미리스트 */
function listOperate(tabOrder) {
	var url = "";

	if (tabOrder == '1') {
		url = "/menu/menuMgr/lessonOperateList.do";
	} else if (tabOrder == '2') {
		url = "/menu/menuMgr/lessonAsmntNoSubmitList.do";
	} else if (tabOrder == '3') {
		url = "/menu/menuMgr/lessonScoreUnratedList.do";
	} else if (tabOrder == '5') {
		url = "/menu/menuMgr/lessonLoginChiefList.do";
	}

	// 학기제, 기수제, 법정교육, 공개강좌
	var crsTypeCdList = [];
	if (tabOrder != '5') {
	
		$.each($("[data-crs-type-cd]"), function(){
			var crsTypeCd = $(this).data("crsTypeCd");
			
			if($(this).hasClass("active")) {
				crsTypeCdList.push(crsTypeCd);
			}
		});
	}	
	
	var paramData = {
		"termCd"			: $("#termCd").val()
		, "uniCd"			: $("#uniCd").val()
		, "deptCd"			: ($("#deptCd").val() || "").replace("all", "")
		, "progressCd"	: $("#progressCd").val()
		, "searchValue"	: $("#searchValue").val()
	};

	if (tabOrder != '5') {

		if(crsTypeCdList.length > 0) {
			paramData.crsTypeCds = crsTypeCdList.join(",");
		}
	}
	
	if(tabOrder == '1') {
		$("#contentId").show();
		$("#operateList").load(
				url
				, paramData
				, function(){}
		);
	} else if(tabOrder == '2') {
		$("#contentId").show();
		$("#asmntList").load(
				url
				, paramData
				, function(){}
		);
	} else if(tabOrder == '3') {
		$("#contentId").show();
		$("#scoreList").load(
				url
				, paramData
				, function(){}
		);
	} else if(tabOrder == '5') {
		$("#contentId").hide();
		$("#loginList").load(
				url
				, paramData
				, function(){}
		);
	}
}

/* 과제 미제출리스트 */
function listAsmnt(page) {

	var url = "/menu/menuMgr/lessonAsmntNoSubmitList.do";

	var paramData = {
		"pageIndex" 		: page
		, "listScale"  		: $("#listScale").val()
		, "creYear"			: $("#creYear").val()
		, "creTerm"			: $("#creTerm").val()
		, "termCd"			: $("#termCd").val()
		, "deptCd"			: ($("#deptCd").val() || "").replace("all", "")
		, "searchValue"	: $("#searchValue").val()
		, "uniCd"			: $("#uniCd").val()
		, "progressCd"	: $("#progressCd").val()
	};

	$("#asmntList").load(
		url, paramData, function(){}
	);
}

/* 성적미평가리스트 */
function listScore(page) {
	var url = "/menu/menuMgr/lessonScoreUnratedList.do";

	var paramData = {
		"pageIndex" 		: page
		, "listScale"  		: $("#listScale").val()
		, "creYear"			: $("#creYear").val()
		, "creTerm"			: $("#creTerm").val()
		, "termCd"			: $("#termCd").val()
		, "deptCd"			: ($("#deptCd").val() || "").replace("all", "")
		, "searchValue"	: $("#searchValue").val()
		, "uniCd"			: $("#uniCd").val()
		, "progressCd"	: $("#progressCd").val()
	};

	$("#scoreList").load(
		url, paramData, function(){}
	);
}

/* 교수/조교 로그인리스트 */
function listLogin(page) {

	var url = "/menu/menuMgr/lessonLoginChiefList.do";
	
	var paramData = {
			"pageIndex" 		: page
			, "listScale"  		: $("#listScale").val()
			, "creYear"			: $("#creYear").val()
			, "creTerm"			: $("#creTerm").val()
			, "termCd"			: $("#termCd").val()
			, "deptCd"			: ($("#deptCd").val() || "").replace("all", "")
			, "searchValue"	: $("#searchValue").val()
			, "uniCd"			: $("#uniCd").val()
			, "progressCd"	: $("#progressCd").val()
	};

	$("#loginList").load(
		url, paramData, function(){}
	);
}

function viewUser(userId) {

	var url = "/menu/menuMgr/lessonLoginLecturelist.do";
	
	var paramData = {
			"userId" 		: userId
			, "termCd"			: $("#termCd").val()
			, "deptCd"			: ($("#deptCd").val() || "").replace("all", "")
			, "searchValue"	: $("#searchValue").val()
	};
	
	$("#lessonLectureList").load(
			url, paramData, function(){}
	);

	asmntList(userId);			// 과제
	quizList(userId);				// 퀴즈
	forumList(userId);				// 토론
	researchList(userId);		// 설문
}

function asmntList(userId) {

	var url = "/menu/menuMgr/lessonLoginAsmntlist.do";
	
	var paramData = {
			"userId" 		: userId
			, "termCd"			: $("#termCd").val()
			, "deptCd"			: ($("#deptCd").val() || "").replace("all", "")
			, "searchValue"	: $("#searchValue").val()
	};
	
	$("#lessonAsmntList").load(
			url, paramData, function(){}
	);
}

function quizList(userId) {

	var url = "/menu/menuMgr/lessonLoginQuizlist.do";
	
	var paramData = {
			"userId" 		: userId
			, "termCd"			: $("#termCd").val()
			, "deptCd"			: ($("#deptCd").val() || "").replace("all", "")
			, "searchValue"	: $("#searchValue").val()
	};
	
	$("#lessonQuizList").load(
			url, paramData, function(){}
	);
}

function forumList(userId) {

	var url = "/menu/menuMgr/lessonLoginForumlist.do";
	
	var paramData = {
			"userId" 		: userId
			, "termCd"			: $("#termCd").val()
			, "deptCd"			: ($("#deptCd").val() || "").replace("all", "")
			, "searchValue"	: $("#searchValue").val()
	};
	
	$("#lessonForumList").load(
			url, paramData, function(){}
	);
}

function researchList(userId) {

	var url = "/menu/menuMgr/lessonLoginResearchlist.do";
	
	var paramData = {
			"userId" 		: userId
			, "termCd"			: $("#termCd").val()
			, "deptCd"			: ($("#deptCd").val() || "").replace("all", "")
			, "searchValue"	: $("#searchValue").val()
	};
	
	$("#lessonResearchList").load(
			url, paramData, function(){}
	);
}

fnTab = function (val) {
	tabOrder = val;
	listOperate(val);
};

/**
 * 개설과목 카운트 표시
 */
function displayCount(cnt) {
    $("#count").text("<spring:message code='common.page.total' /> : " + cnt + "<spring:message code='common.page.total_count' />");//총//건
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
            <div class="content" >

                <!-- admin_location -->
                <%-- <%@ include file="/WEB-INF/jsp/common/admin/admin_location.jsp" %> --%>
                <!-- //admin_location -->

                <div class="ui form">

                    <div id="info-item-box">
                        <h2 class="page-title flex-item">
	                        <spring:message code="lesson.label.classroom.operations.means" /><!-- 수업운영도구 -->
	                        <div class="ui breadcrumb small">
	                            <%--
	                            <small class="section"><spring:message code="lesson.label.classroom.operations" /></small><!-- 수업운영 -->
	                            <i class="right chevron icon divider"></i>
	                            --%>
	                            <small class="section"><spring:message code="lesson.label.classroom.operations" /></small><!-- 수업운영 -->
	                            <i class="divider">:</i>
	                            <small class="active section"><spring:message code="lesson.label.notification" /></small><!-- 강의알리미 -->
	                        </div>
	                    </h2>
	                    <!-- 
	                    <div class="button-area">
	                    </div> 
	                    -->
		            </div>

					<div class="ui pointing secondary tabmenu menu">
                        <a class="item pt0 active" data-tab="tabcont1" onclick="fnTab(1);"><spring:message code="team.write.info.title" /></a><!-- 수업운영 -->
                        <a class="item pt0" data-tab="tabcont2" onclick="fnTab(2);"><spring:message code="common.asmnt.unsubmission.number.subject" /></a><!-- 과제 미제출 과목 -->
                        <a class="item pt0" data-tab="tabcont3" onclick="fnTab(3);"><spring:message code="common.grade.unsubmission.number.subject" /></a><!-- 성적 미평가 과목 -->
                        <a class="item pt0" data-tab="tabcont5" onclick="fnTab(5);"><spring:message code="common.login.progress" /></a><!-- 로그인 경과 -->
                    </div>

                    <div class="ui segment">
						<div class="option-content mt20">
				            <div id="contentId" class="ui buttons">
				            	<button class="ui blue button active" data-crs-type-cd="UNI" onclick="selectContentCrsType(this)"><spring:message code="common.button.uni" /><!-- 학기제 --></button>
				                <button class="ui basic blue button" data-crs-type-cd="CO" onclick="selectContentCrsType(this)"><spring:message code="common.button.co" /><!-- 기수제 --></button>
				                <button class="ui basic blue button" data-crs-type-cd="LEGAL" onclick="selectContentCrsType(this)"><spring:message code="common.button.legal" /><!-- 법정교육 --></button>
				                <button class="ui basic blue button" data-crs-type-cd="OPEN" onclick="selectContentCrsType(this)"><spring:message code="common.button.open" /><!-- 공개강좌 --></button>
				        	</div>
				        </div>

						<!-- 검색영역 -->
		                <div id="con01" class="ui segment">
		                    <div class="fields">

		                        <div class="three wide field ">
		                            <!-- 개설년도+개설학기 -->
		                            <select class="ui fluid dropdown" id="termCd" name="termCd" >
		                                <c:forEach var="item2" items="${creTermList}" varStatus="status">
		                                    <option value="${item2.termCd}" <c:if test="${vo.termCd eq item2.termCd}">selected</c:if>>${item2.termNm}</option>
		                                </c:forEach>
		                            </select> 
		                        </div>

		                        <div class="three wide field ">
		                            <!-- 대학구분 -->
                                    <select  id="uniCd" class="ui dropdown" >
                                      <option value=""><spring:message code="exam.label.org.type" /></option><!-- 대학구분 -->
                                      <option value="C"><spring:message code="common.knou.label.uni.c" /></option><!-- 한양사이버대학교 -->
                                      <option value="G"><spring:message code="common.knou.label.uni.g" /></option><!-- 한양사이버대학원 -->
                                   </select>		                            
		                        </div>

		                        <div class="two wide field ">
		                            <!-- 학과 선택 -->
		                            <select class="ui fluid dropdown" id="deptCd" name="deptCd">
		                                <option value="all"><spring:message code="user.title.userdept.select" /></option>
		                                <c:forEach var="item" items="${deptCdList}">
		                                    <option value="${item.deptCd}">${item.deptNm}</option>
		                                </c:forEach>
		                            </select> 
		                        </div>
		
<!-- 		                        <div class="one wide field "> -->
<!-- 		                            일 경과 -->
<!-- 		                            <select class="ui fluid dropdown" id="progressCd" name="progressCd"> -->
<%-- 		                                <option value=""><spring:message code="common.label.progress.day" /></option><!-- 일 경과 --> --%>
<!-- 		                                <option value="3">3 일</option> -->
<!-- 		                                <option value="7" selected>7 일</option> -->
<!-- 		                                <option value="10">10 일</option> -->
<!-- 		                                <option value="30">30 일</option> -->
<!-- 		                            </select> -->
<!-- 		                        </div> -->

		                        <div class="three wide field ">
		                            <label class="blind"></label>
		                            <div class="ui input">
		                                <input id="searchValue" type="text" placeholder="<spring:message code="user.message.search.input.crs.cd.tch.nm" />" e="${param.searchValue}" /><!-- 학수번호/과목명/교수명 입력 -->
		                            </div>
		                        </div>
		                    </div>

		                    <div class="button-area mt10 tc">
		                        <a href="javascript:void(0)" onclick="listOperate(tabOrder)" class="ui blue button w100"><spring:message code="common.button.search" /></a><!-- 검색 -->
		                    </div>
		                </div>
				        <!-- // 검색영역 -->

                        <div class="ui tab active" data-tab="tabcont1">
                    		<!-- 강의알리미 탭 콘텐츠 -->
                            <div id="operateList" class="footable_box type2 mb20 max-height-400"></div>
                        </div>

                        <div class="ui tab" data-tab="tabcont2">
							<!-- 과제 미제출 과목 탭 콘텐츠 -->
                            <div id="asmntList"></div>
                        </div>

                        <div class="ui tab" data-tab="tabcont3">
							<!-- 성적 미평가 과목 탭 콘텐츠 -->
                            <div id="scoreList"></div>
                        </div>

                        <!-- 탭 콘텐츠 -->
                        <!-- <div class="ui tab " data-tab="tabcont4">data-tab=시스템 오류 로그</div> -->
                        <!-- //탭 콘텐츠 -->

                        <div class="ui tab" data-tab="tabcont5">
							<!-- 로그인 경과 탭 콘텐츠 -->
                       		<div id="loginList"></div>
                        </div>

                        <script> 
                            //초기화 방법 1__일반적인 형식
                            $('.tabmenu.menu .item').tab(); 

                            //초기화 방법 2__탭을 선택해 초기화 할 경우
                            //$('.tabmenu.menu .item').tab('change tab', 'tabcont2'); 
                        </script>
                    </div>

                </div>
            </div>
        </div>
        <!-- //본문 content 부분 -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
    </div>
</body>
</html>