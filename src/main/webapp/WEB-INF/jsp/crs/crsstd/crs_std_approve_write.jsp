<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	 <script type="text/javascript" src="/webdoc/js/common_admin.js"></script>
</head>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

 <script type="text/javascript">

	 $(document).ready(function() { 
		 lnerListForm(1, "${vo.gubun}");
	 });
	 
	  function lnerListForm(page, gubun){
		 var searchValue =  $("#searchValue2").val();
	 	$("#userList").load("/crs/creCrsMgr/crsUserList.do", 
			 {
				 "searchValue" :  searchValue
				 // ,"searchAuthGrp" : "LEARNER"
				 ,"searchAuthGrp" : "USR"
				 ,"crsCreCd" : "${vo.crsCreCd}"
				 ,"gubun" : "approve"
			 }
			,function (){
		 });
	 }   
	 
	  
	  function addStd(crsCreCd){
		  var userIdList = "";
		  $("input:checkbox[name='checkStd']").each(function(idx){
				 if($(this).is(":checked") == true) {
					 if(userIdList == ""){
						 userIdList += this.value;
					 }else{
						 userIdList += ",";
						 userIdList += this.value;
					 }
				 }
			 });
			$("#userId").val(userIdList);
			
		  $("#creStdApproveForm").attr("action","/crs/creCrsMgr/creStdApproveAdd");
		  $("#creStdApproveForm").submit(); 
	  }

	  function fnCloseStd(crsCreCd){
	      $("#sidebarForm").sidebar("hide");
	  }
	   
	  function move(crsCreCd){
		  $("#creStdApproveForm").attr("action","/crs/creCrsMgr/Form/crsStdApproveForm");
		  $("#creStdApproveForm").submit(); 
	  }
	  
 </script>
<form class="ui form" id="creStdApproveForm" name="creStdApproveForm" method="POST" action="">
<input type="hidden" id="crsCreCd" name="crsCreCd" value="${vo.crsCreCd}">
<input type="hidden" id="userId" name="userId"/> 
<input type="hidden" id="enrlSts" name="enrlSts" value="S">
<input type="hidden" id="enrlStartDttm" name="enrlStartDttm" value="${vo.enrlStartDttm}"> <!-- 수강 시작 일시 -->
<input type="hidden" id="enrlEndDttm" name="enrlEndDttm" value="${vo.enrlEndDttm}"> <!-- 수강 종료 일시 -->
<input type="hidden" id="enrlAplcDttm" name="enrlAplcDttm" value="${vo.enrlAplcStartDttm}"> <!-- 수강 신청 시작일시 -->
<input type="hidden" id="enrlCancelDttm" name="enrlCancelDttm" value="${vo.enrlAplcEndDttm}"> <!-- 수강 신청 종료 시작일시 -->
<input type="hidden" id="userIdStr" name="userIdStr" value="${userIdStr}">
<input type="hidden" id="gubun" name="gubun" value="approve">
</form>
    <button class="close"><spring:message code="button.close"/></button> <!-- 닫기 -->
    <div class="scrollbox">
        <div class="ui form">
            <h2 class="page-title pb20"><spring:message code="common.student.add"/></h2> <!-- 수강생 추가 -->
            <!-- <div class="field ui segment">
                <h4 class="ui header">참여자 직접 입력</h4>
                <div class="field">
                    <div class="part-list pb0">
                        <div class="label-roundType">
                            <div class="emt"><span>김태영(stu1)</span><small>taeyoung@vcamp.co.kr</small></div> 
                            <button onclick=""><i class="ion-close-round"></i></button>
                        </div>
                        <div class="label-roundType">
                            <div class="emt"><span>김주영(stu2)</span><small>goldmoon@vcamp.co.kr</small></div>
                            <button onclick=""><i class="ion-close-round"></i></button>
                        </div>
                        <div class="label-roundType">
                            <div class="emt"><span>박상현(stu3)</span><small>eod5@vcamp.co.kr</small></div>
                            <button onclick=""><i class="ion-close-round"></i></button>
                        </div>
                    </div>
                </div>
                <div class="field mb0">
                    <div class="ui transparent left icon input">
                        <i class="search icon"></i>
                        <input type="text" placeholder="참여자를 입력하세요">
                    </div>
                </div>
            </div> -->
            <div class="field">
                <div class="ui action input search-box">
                    <input type="text" placeholder="<spring:message code='crs.label.placeholder.search.keyword'/>" id="searchValue2" name="searchValue2" onkeypress="if( event.keyCode == 13 ){lnerListForm(1);}"> <!-- 검색할 키워드를 입력하세요. (예 : 이름, 아이디) -->
                    <a class="ui icon button" onclick="lnerListForm(1)"><i class="search icon"></i></a>
                </div>
            </div>
            <div id="userList"></div>
            <div class="bottom-content">
                <a class="ui blue button" onclick="addStd('${vo.crsCreCd}')"><spring:message code="button.add"/></a> <!-- 저장 -->
                <a class="ui button" href="javascript:fnCloseStd();"><spring:message code="button.cancel"/></a><!-- 취소 -->
                <%-- <a class="ui button" href="javascript:move('${vo.crsCreCd}');"><spring:message code="button.cancel"/></a> --%> <!-- 취소 -->
            </div>
        </div>
    </div>
</html>