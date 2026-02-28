<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!DOCTYPE html>

<head>
		<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
</head>

<script type="text/javascript">
	var userList = new Map();
	
	$(document).ready(function() { 
		creStdListForm(1, "${creCrsVo.crsCreCd}");
		
		$("#searchValue").on("keyup",function(key){
	        if(key.keyCode==13) {
	        	creStdListForm(1, "${creCrsVo.crsCreCd}");
	        }
	    });
	});

	function stdAddSidebar(){
		$("#sidebarForm").load("/crs/creCrsMgr/crsStdApproveAddForm.do", {
			"crsCreCd" : "${creCrsVo.crsCreCd}"
		},function(){
			$("#wrap").addClass('dimmed');
			$("#sidebarForm").sidebar("show");
		});
	}

	//수강생 리스트
	function creStdListForm(page, crsCreCd, enrlStsVal){
        if(page == undefined) page = 1;
        if(enrlStsVal == undefined){
            enrlStsVal =  $("#enrlStsVal option:selected").val();
        }
        var startDttm = $("#enrlAplcDttmVal").val();
        var endDttm = $("#enrlCancelDttmVal").val();
        
        if(startDttm != ""){
            startDttm = startDttm.replaceAll(".", "");
            startDttm = startDttm+"235900"
        }
        if(endDttm != ""){
            endDttm = endDttm.replaceAll(".", "");
            endDttm = endDttm+"235900"
        }else if(startDttm != ""){
            endDttm = $("#enrlAplcDttm").val().replaceAll(".", "")+"235900";
            alert(endDttm);
        }
        /* 2페이지 누를때 */
        if(crsCreCd == undefined){
            crsCreCd = "${creCrsVo.crsCreCd}";
        }
	
	    var listScale = $("#listScale option:selected").val();
	
		$("#stdList").load("/crs/creCrsMgr/crsStdApproveList.do",
			{
				"crsCreCd"  : crsCreCd
				,"pageIndex"  : page
				,"searchValue" : $("#searchValue").val()
				,"listScale" : $("#listScale").val()
				,"enrlSts" : enrlStsVal
				,"enrlAplcDttm" : startDttm
				,"enrlCancelDttm" : endDttm
			}
			,function(){
			// userList 값 있는거 페이지 이동할때마다 체크해주기
			$("input[name='check']").each(function(idx){
				if(userList.size > 0){
					var stdNoVal = $(this).val();//stdNo
					var userIdVal = $("input[name="+stdNoVal+"]").val(); //userId
					if(userList.has(userIdVal)){
						$(this).prop('checked','checked');
					}else{
						$(this).removeAttr('checked'); 
					}
					
				}
			});
		});
	}

	function checkEventBind(obj){
		var childrenVal =$(obj).val();
		if($(obj).is(":checked") == true) {
			userList.set($("input:hidden[name="+childrenVal+"]").val());
		} else {
			userList.delete($("input:hidden[name="+childrenVal+"]").val());
		}
	}
	
	function allCheck(){
		 var userIdval= "";
			if(!$("#allCheck").is(":checked")){
				$("input[name='check']").each(function(){
						$(this).prop('checked','checked');
						userIdval = $(this).val();
						userList.set($("input:hidden[name="+userIdval+"]").val());
				})
			}else{
				$("input[name='check']").removeAttr('checked');
				//map 초기화
				userList.clear();
			}
	}
	
	function enrlStsVal(){
		var enrlsts = $("#enrlStsVal").val();
		creStdListForm(1, "${creCrsVo.crsCreCd}", enrlsts);
	}

	var stdNoList = "";
	function editstdEnrlSts(gubun, stdNo){
		//전체승인 눌렀을
		if("all" == gubun){
			if(!$("#allCheck").is(":checked")){
			    allCheck(); 
			}
		}
		if("refuse" == gubun){
			$("#enrlSts").val("N");
		}else if("delete" == gubun){
			$("#enrlSts").val("D");
		}else{
			$("#enrlSts").val("S");
		}
		
		$("input:checkbox[name='check']").each(function(idx){
			if($(this).is(":checked") == true) {
				if(stdNoList == ""){
					stdNoList += this.value;
				}else{
					stdNoList += ",";
					stdNoList += this.value;
				}
			}
		});
		$("#stdNo").val(stdNoList);
		
		//삭제시
		if("delete" == gubun && stdNo != ""){
			$("#stdNo").val(stdNo); 
		}
		
		var queryString = $("form[name=creCrsStdApproveForm]").serialize();
		$.ajax({
			type : "POST", 
			url : "/std/stdHome/editStdEnrlSts.do",
			data: queryString,
			dataType: "json",
			async : false,
			success : function(data){
				if(data.result > 0){
					if("refuse" == gubun){
						alert("<spring:message code='crs.learner.status.change.success'/>"); // 수강생 상태를 변경 하였습니다.
					}else{
						alert("<spring:message code='crs.learner.status.change.success'/>"); // 수강생 상태를 변경 하였습니다. 
					}
					creStdListForm(1, data.returnVO.crsCreCd);
				}else{
					alert("<spring:message code='crs.learner.status.change.fail'/>"); // 수강생 상태 변경 실패하였습니다.
				}
			},
			error : function(request, status, error){
			}
		});
	}

	 var userIdList = "";
	 function sendCreMsgToStd(scopeType){
	    	var crsCreCd = "${creCrsVo.crsCreCd}";
	    	var stdNoVal = "";
	    	var userIdVal = "";
	      $("#loading_page").show(); 
	        if (!scopeType || scopeType != 'ALL') {
	         callMsgModal(userList);
	        $("#loading_page").hide(); 
	        }else{
	        	//전체 보내기
	        	 $.ajax({
	 	            type : "POST",
	 	            async: false,
	 	            dataType : "json",
	 	            data : { 
	 	                    "crsCreCd" : crsCreCd
	 	                   },
	 	            url : "/std/stdHome/creStdList.do",
	 	            success : function(data){
	 	            	callMsgModalAll(data);
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
	        }
	    }

    /**
     * 전체 쪽지 보내기 팝업창 호출(exam_eval_form.jsp 참고)
     */
    function callMsgModalAll(data) {
		if(!data) {
	        return;
	    }

        var receiverUserIds = '';
	    $.each(data, function(idx, value) {
	        if(idx > 0) {
	            receiverUserIds += ','
	        }
	        receiverUserIds += value.userId;
	    });

        $("input:hidden[name=receiverUserIds]").val(receiverUserIds);
        $("#creCrsStdApproveForm").attr("target", "modalMsgSendIfm");
        $("#creCrsStdApproveForm").attr("action", "/msg/msgPop/msgWrite/popup.do");
        $("#creCrsStdApproveForm").submit();
        $('#modalSendMessage').modal('show');
    }

    /**
     * 쪽지 보내기 팝업창 호출(exam_eval_form.jsp 참고)
     */
    function callMsgModal(data) {
		 if (!data) {
	            return;
	        }
		 var receiverUserIds = '';
		 receiverUserIds = Array.from(userList.keys()).join(",");
	        
        $("input:hidden[name=receiverUserIds]").val(receiverUserIds);
        $("#creCrsStdApproveForm").attr("target", "modalMsgSendIfm");
        $("#creCrsStdApproveForm").attr("action", "/msg/msgPop/msgWrite/popup.do");
        $("#creCrsStdApproveForm").submit();
        $('#modalSendMessage').modal('show');
    }

    /**
     * sms 보내기
     */
    function sendCrsSmsToStd(scopeType){
    	
    	var crsCreCd = "${creCrsVo.crsCreCd}";
    	var stdNoVal = "";
    	var userIdVal = "";
      $("#loading_page").show(); 
        if (!scopeType || scopeType != 'ALL') {
        	callSmsModal(userList);
        $("#loading_page").hide(); 
        }else{
        	//전체 보내기
        	 $.ajax({
 	            type : "POST",
 	            async: false,
 	            dataType : "json",
 	            data : { 
 	                    "crsCreCd" : crsCreCd
 	                   },
 	            url : "/std/stdHome/creStdList.do",
 	            success : function(data){
 	            	callSmsModalAll(data);
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
        }
    }

    /**
     * 전체 sms 보내기 팝업창 호출(exam_eval_form.jsp 참고)
     */
    function callSmsModalAll(data) {
        if(!data) {
            return;
        }
        var receiverUserIds = '';
        $.each(data, function(idx, value) {
            if (idx > 0) {
                receiverUserIds += ','
            }
            receiverUserIds += value.userId;
        });

        $("input:hidden[name=receiverUserIds]").val(receiverUserIds);
        $("#creCrsStdApproveForm").attr("target", "modalSmsSendIfm");
        $("#creCrsStdApproveForm").attr("action", "/msg/msgPop/smsWrite/popup.do");
        $("#creCrsStdApproveForm").submit();
        $('#modalSendSms').modal('show');
    }

    /**
     * sms 보내기 팝업창 호출(exam_eval_form.jsp 참고)
     */
    function callSmsModal(data) {
        if (!data) {
            return;
        }

        var receiverUserIds = '';
        receiverUserIds = Array.from(userList.keys()).join(",");

        $("input:hidden[name=receiverUserIds]").val(receiverUserIds);
        $("#creCrsStdApproveForm").attr("target", "modalSmsSendIfm");
        $("#creCrsStdApproveForm").attr("action", "/msg/msgPop/smsWrite/popup.do");
        $("#creCrsStdApproveForm").submit();
        $('#modalSendSms').modal('show');
    }

    function userIdCheck(obj){
    	$("input:checkbox[name='check']").each(function(idx){
  			 if($(this).is(":checked") == true) {
  				 stdNoVal = this.value;
  				 userIdVal = $("input:hidden[name="+stdNoVal+"]").val();
  				 userList.set(userIdVal);
  			 }
  		});
    }
	
    //엑셀 다운로드
    function listExcel(){
    	var excelGrid = {
    	      colModel:[
    	               {label:'<spring:message code="common.number.no"/>',   name:'lineNo', align:'center', width:'1000'}, // No.
    	               {label:'<spring:message code="common.name"/>',   name:'userNm', align:'center',   width:'8000'}, // 이름
    	               {label:'<spring:message code="common.dept_name"/>',   name:'deptNm', align:'center',   width:'8000'}, // 학과
    	               {label:'<spring:message code="common.id"/>',   name:'userId', align:'center',   width:'8000'}, // 아이디
    	               {label:'<spring:message code="crs.lecture.request.day"/>',   name:'modDttm', align:'center',   width:'8000', formatter:'date', formatOptions:{srcformat:"yyyyMMddHHmmss", newformat:"yyyy.MM.dd"}}, // 수강 신청일
    	               {label:'<spring:message code="crs.lecture.request.status"/>',   name:'enrlSts', align:'center',   width:'2000', codes:{E:'<spring:message code="common.label.request"/>',S:'<spring:message code="button.confirm"/>',N:'<spring:message code="common.label.reject"/>',D:'<spring:message code="button.delete"/>'}}, // 수강 상태, 신청, 승인, 반려, 삭제
    	                ]
    		};
    	
    	 var excelForm = $('<form></form>');
    	 excelForm.attr("name","excelForm");
    	 excelForm.attr("action","/crs/creCrsMgr/creStdListExcel.do");
    	 excelForm.append($('<input/>', {type: 'hidden', name: 'crsCreCd', value: "${creCrsVo.crsCreCd}"}));
    	 excelForm.append($('<input/>', {type: 'hidden', name: 'searchValue', value: $("#searchValue").val() }));
    	 excelForm.append($('<input/>', {type: 'hidden', name: 'excelGrid', value:JSON.stringify(excelGrid)}));
    	 
    	 excelForm.appendTo('body');
    	 excelForm.submit();	  
    }

	/*수료 적용*/
	function certApply(){

	var stdNoList = "";
		
        $("input[name='check']").each(function(idx){
            if(this.checked){

                var stdNo = this.value;
                var cpltNo = $("input:hidden[name="+stdNo+"_cpltNo]").val();
                var cpltYn = $("input:hidden[name="+stdNo+"_cpltYn]").val();

                if(cpltYn != 'Y'){

                    if(stdNoList == ''){
                            
                        stdNoList += stdNo + "|" + cpltNo + "|" + "Y";
                            
                    }else{
                        stdNoList += ",";
                        stdNoList += stdNo + "|" + cpltNo + "|" + "Y";
                    }
                }
            }
        });

        if(stdNoList == ""){
            return false;
        }

	    $.getJSON("/crs/creCrsMgr/applyCert.do",
		{
			"crsCreCd" : "${creCrsVo.crsCreCd}",
			"stdNoList" : stdNoList,
		},// params
		function(data) {
				if(data.result > 0) {
					$("#note-box").removeClass("warning");
					$("#note-box p").text("수료처리 되었습니다.");
					$("#note-btn").trigger("click");
					creStdListForm(1, "${creCrsVo.crsCreCd}");
				} else {
					$("#note-box").prop("class","warning");
					$("#note-box p").text("수료처리에 실패하였습니다. 다시 시도 해주시기 바랍니다.");
					$("#note-btn").trigger("click");
					creStdListForm(1, "${creCrsVo.crsCreCd}");
			    }
			}
		); 
	}

	/*수료 취소*/
	function certCancel() {

	    var stdNoList = "";

		$("input[name='check']").each(function(idx){
			if(this.checked){
				
				var stdNo = this.value;
				var cpltYn = $("input:hidden[name="+stdNo+"_cpltYn]").val();
				
				if(cpltYn == 'Y'){
					
		    		if(stdNoList == ''){
		    			
		    			stdNoList += stdNo + "|" + "N";
		    			
		    		}else{
		    			stdNoList += ",";
		    			stdNoList += stdNo + "|" + "N";
		    		}
				}
			}
		});
		
		if(stdNoList == ""){
			return false;
		}
		
		$.getJSON("/crs/creCrsMgr/cancelCert.do",
			{
                "crsCreCd" : "${creCrsVo.crsCreCd}",
				"stdNoList" : stdNoList,
			},// params
			function(data) {
				if(data.result > 0){
					alert("수료취소 되었습니다.");
					creStdListForm(1, "${creCrsVo.crsCreCd}");
				}else{
					alert("수료취소에 실패하였습니다. 다시 시도 해주시기 바랍니다.");
					creStdListForm(1, "${creCrsVo.crsCreCd}");
				}
			}
		);
	}

	/**
	 * 메모 저장 팝업창 호출
	 */
	function openDenyContent(stdNo, obj) {
		var enrlDenyContent = $(obj).data("memo");
		
		$("input:hidden[name=enrlDenyContent]").val(enrlDenyContent);
		$("input:hidden[name=stdNo]").val(stdNo);
		$("#memoForm").attr("target", "modalMemoIfm");
		$("#memoForm").attr("action", "/crs/creCrsMgr/mgrDenyContent/popup.do");
		$("#memoForm").submit();
		$('#modalMemo').modal('show');
	    $('#modalMemo').modal('show');
	}
</script>

<form class="ui form" id="creCrsStdApproveForm" name="creCrsStdApproveForm" method="POST" action="">
<input type="hidden" id="crsCreCd" name="crsCreCd" value="${creCrsVo.crsCreCd}">
<input type="hidden" id="crsCd" name="crsCd" value="${creCrsVo.crsCd}">
<input type="hidden" id="enrlSts" name="enrlSts">
<input type="hidden" id="stdNo" name="stdNo"/>

<!-- 쪽지 -->
<input type="hidden" id="receiverUserIds" name="receiverUserIds"/>

</form>
<div id="info-item-box" class="ui admin">
    <h2 class="page-title"><spring:message code='common.label.learner.management'/></h2> <!-- 수강생 관리 -->
    <div class="button-area">
        <div class="ui floating labeled icon dropdown basic button">
            <i class="dropdown icon"></i>
            <span class="text"><spring:message code="button.note" /> <spring:message code="common.button.send" /></span> <!-- 쪽지 --> <!-- 보내기 -->
            <div class="menu">
                <div class="item" onClick="sendCreMsgToStd('ALL')">
                    <spring:message code="common.all" /> <!-- 전체 -->
                    <spring:message code="button.note" />   <!-- 쪽지 -->
                    <spring:message code="common.button.send" />  <!-- 보내기 -->
                </div>
                <div class="item" onClick="sendCreMsgToStd()">
                    <spring:message code="button.note" />  <!-- 쪽지 -->
                    <spring:message code="common.button.send" /> <!-- 보내기 -->
                </div>
            </div>
        </div>
        <c:if test="${MSG_SMS eq 'Y'}">
	        <div class="ui floating labeled icon dropdown basic button">
	            <i class="dropdown icon"></i>
	            <span class="text"><spring:message code="button.sms" /> <spring:message code="common.button.send" /></span> <!-- sms 보내기 --> 
	            <div class="menu">
	                <div class="item" onClick="sendCrsSmsToStd('ALL')">
	                	<spring:message code="common.all" /> <!-- 전체 -->
	                    <spring:message code="button.sms" />   <!-- sms -->
	                    <spring:message code="common.button.send" />  <!-- 보내기 -->
	                </div>
	                <div class="item" onClick="sendCrsSmsToStd()">
	                	<spring:message code="button.sms" />   <!-- sms -->
	                    <spring:message code="common.button.send" />  <!-- 보내기 -->
	                </div>
	            </div>
	        </div>
        </c:if>
        <a href="javascript:listExcel()" class="btn"><spring:message code='button.download.excel'/></a> <!-- 엑셀다운로드 -->
        <a href="javascript:callExcelUploadModal()" class="btn"><spring:message code="common.label.upload.for.file"/></a> <!-- 파일로 등록 -->
        <a href="javascript:editstdEnrlSts('all');" class="btn"><spring:message code='crs.access.all'/></a> <!-- 전체 승인 -->
        <a href="javascript:editstdEnrlSts('');" class="btn"><spring:message code='button.confirm'/></a> <!-- 승인 -->
        <a href="javascript:editstdEnrlSts('refuse');" class="btn"><spring:message code='common.label.reject'/></a> <!-- 반려 -->
        <a  class="btn btn-primary sidebar-button" href="javascript:stdAddSidebar();"><spring:message code='common.student.add'/></a> <!-- 수강생 추가 -->
        <a href="javascript:editstdEnrlSts('delete', '');" class="btn btn-primary sidebar-button"></a> <!-- 수강생 삭제 -->
        <a href="javascript:certApply();"class="positive ui button">수료</a>
		<a href="javascript:certCancel();"class="negative ui button">수료 취소</a>
        <a href="/crs/creCrsMgr/Form/creCrsCoListForm" class="btn"><spring:message code='button.list'/></a> <!-- 목록 -->
    </div>
</div>
<div class="ui form">
    <div class="option-content">
        <select class="ui dropdown mr5" id="enrlStsVal" onchange="enrlStsVal()">
			<option value=""><spring:message code='crs.lecture.request.status'/></option> <!-- 수강 상태 -->
			<c:forEach var="item" items="${enrlStsCdList}" varStatus="status">
				<option value="${item.codeCd}" <c:if test="${creCrsVo.enrlSts eq item.codeCd}">selected</c:if>>${item.codeNm}</option>
			</c:forEach>
        </select>
        <div class="ui action input search-box">
            <input type="text" placeholder="<spring:message code='button.search'/>" id="searchValue" name="searchValue" onkeypress="if( event.keyCode == 13 ){creStdListForm(1, '${creCrsVo.crsCreCd}');}"> <!-- 검색 -->
            <button type="button" class="ui icon button" onclick="creStdListForm(1, '${creCrsVo.crsCreCd}')"><i class="search icon"></i></button>
        </div>
        <div class="button-area">
            <div class="ui calendar" id="rangestart" style="display: inline-block;">
               <div class="ui input left icon">
                   <i class="calendar alternate outline icon"></i>
                   <input type="text" id="enrlAplcDttmVal" placeholder="<spring:message code='common.start.date'/>"> <!-- 시작일 -->
               </div>
           </div>
           <div class="ui calendar" id="rangeend" style="display: inline-block;">
               <div class="ui input left icon">
                   <i class="calendar alternate outline icon"></i>
                   <input type="text" id="enrlCancelDttmVal" placeholder="<spring:message code='common.enddate'/>"> <!-- 종료일 -->
               </div>
           </div>
           <a class="ui icon button" onclick="creStdListForm(1, '${creCrsVo.crsCreCd}')"><i class="search icon"></i></a>
          <script>
               $('#rangestart').calendar({
                   type: 'date',
                   endCalendar: $('#rangeend'),
                   formatter: {
                       date: function(date, settings) {
                           if (!date) return '';
                           var day = (date.getDate()) + '';
                           var month = settings.text.monthsShort[date.getMonth()];
                           if (month.length < 2) {
                               month = '0' + month;
                           }
                           if (day.length < 2) {
                          	 day = '0' + day;
                           }
                           var year = date.getFullYear();
                           return year + '.' + month + '.' + day;
                       }
                   }
               });
               $('#rangeend').calendar({
                   type: 'date',
                   startCalendar: $('#rangestart'),
                   formatter: {
                       date: function(date, settings) {
                           if (!date) return '';
                           var day = (date.getDate()) + '';
                           var month = settings.text.monthsShort[date.getMonth()];
                           if (month.length < 2) {
                               month = '0' + month;
                           }
                           if (day.length < 2) {
                          	 day = '0' + day;
                           }
                           var year = date.getFullYear();
                           return year + '.' + month + '.' + day;
                       }
                   }
               });
           </script>
           <select class="ui dropdown list-num" id="listScale" onchange="creStdListForm(1,'${creCrsVo.crsCreCd}');">
               <option value="10">10</option>
               <option value="20">20</option>
               <option value="50">50</option>
               <option value="100">100</option>
           </select>
       </div>
   </div>
   <ul class="tbl dt-sm mb20">
       <li>
           <dl>
               <dt><spring:message code="common.label.crsauth.crsnm" /></dt> <!-- 과목명 -->
               <dd>${creCrsVo.crsCreNm} </dd>
               <dt><spring:message code="common.subject" /><spring:message code='crs.common.creterm'/></dt> <!-- 기수 -->
               <dd>${creCrsVo.creTerm}<spring:message code="crs.label.class"/></dd> <!-- 기 -->
           </dl>
       </li>
       <li>
           <dl>
               <dt><spring:message code="crs.enrlAplcStartDttm"/></dt>
               <dd>
	               <fmt:parseDate var="dateString" value="${creCrsVo.enrlAplcStartDttm}" pattern="yyyyMMdd" />
		           <fmt:formatDate value="${dateString}" pattern="yyyy. MM. dd" /> ~
		           <fmt:parseDate var="dateString" value="${creCrsVo.enrlAplcEndDttm}" pattern="yyyyMMdd" />
		           <fmt:formatDate value="${dateString}" pattern="yyyy. MM. dd" />
               </dd>
               <dt><spring:message code='crs.label.enrl.term'/></dt> <!-- 교육기간 -->
               <dd>
               	   <fmt:parseDate var="dateString" value="${creCrsVo.enrlStartDttm}" pattern="yyyyMMdd" />
		           <fmt:formatDate value="${dateString}" pattern="yyyy. MM. dd" /> ~
		           <fmt:parseDate var="dateString" value="${creCrsVo.enrlEndDttm}" pattern="yyyyMMdd" />
		           <fmt:formatDate value="${dateString}" pattern="yyyy. MM. dd" />
		      </dd>
           </dl>
       </li>
   </ul>
   <div id="stdList"></div>
</div>

<!-- 쪽지보내기 popup -->
<div class="modal fade" id="modalSendMessage" tabindex="-1" role="dialog" aria-labelledby="모달영역" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content" >
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="button.close" />"> <!-- 닫기 -->
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title"><spring:message code="button.note" /> <spring:message code="common.button.send" /></h4> <!-- 쪽지 --> <!-- 보내기 -->
            </div>
            <div class="modal-body" >
                <iframe src="" width="100%" scrolling="no" id="modalMsgSendIfm" name="modalMsgSendIfm"></iframe>
            </div>

        </div>
    </div>
</div>
<!-- sms 보내기 popup -->
<div class="modal fade" id="modalSendSms" tabindex="-1" role="dialog" aria-labelledby="모달영역" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="button.close" />"> <!-- 닫기 -->
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title"><spring:message code="button.sms" /> <spring:message code="common.button.send" /></h4> <!-- SMS --> <!-- 보내기 -->
            </div>
            <div class="modal-body" >
                <iframe src="" width="100%" scrolling="no" id="modalSmsSendIfm" name="modalSmsSendIfm"></iframe>
            </div>

        </div>
    </div>
</div>
 <!-- 엑셀 수강생 등록 -->
<div class="modal fade" id="modalExcelUpload" tabindex="-1" role="dialog" aria-labelledby="모달영역" aria-hidden="true">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="button.close" />"> <!-- 닫기 -->
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title"><spring:message code='crs.excel.learner.regist'/></h4> <!-- 엑셀 수강생 등록 -->
			</div>
			<div class="modal-body">
				<iframe src="" width="100%" scrolling="no" id="modalExcelUploadIfm" name="modalExcelUploadIfm"></iframe>
			</div>
		</div>
	</div>
</div>
<!-- memo 보기 popup -->
	<form name="memoForm" id="memoForm" method="POST">
	    <input type="hidden" name="crsCreCd" value="${creCrsVo.crsCreCd}"/>
	    <input type="hidden" name="stdNo" value=""/>
	    <input type="hidden" name="enrlDenyContent" value=""/>
	</form>
	<div class="modal fade" id="modalMemo" tabindex="-1" role="dialog" aria-labelledby="모달영역" aria-hidden="true">
	    <div class="modal-dialog modal-lg" role="document">
	        <div class="modal-content">
	            <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal" aria-label="닫기">
	                    <span aria-hidden="true">&times;</span>
	                </button>
	                <h4 class="modal-title">반려 사유</h4>
	            </div>
	            <div class="modal-body" >
	                <iframe src="" width="100%" scrolling="no" id="modalMemoIfm" name="modalMemoIfm"></iframe>
	            </div>
	
	        </div>
	    </div>
	</div>
	
 <script type="text/javascript">
$('iframe').iFrameResize();	
window.closeModal = function() {
	$('.modal').modal('hide');
};
</script>