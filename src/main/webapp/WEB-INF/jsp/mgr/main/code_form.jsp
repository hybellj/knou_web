<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<!DOCTYPE html>
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<script type="text/javascript">
	$(document).ready(function() {
		$("#searchValueUpCd").on("keydown", function(e) {
            if(e.keyCode == 13) {
            	upCdListPaging(1);
            }
        });
		
		$("#searchValueCode").on("keydown", function(e) {
            if(e.keyCode == 13) {
            	cmmnCdListPaging(1);
            }
        });
		
		upCdListPaging(1);
	});
	
	
	// 코드 카테고리 리스트 조회
	function upCdListPaging(pageIndex, isRoot = false) {
		
		clearUpCdForm(); // 코드 카테고리 입력창 초기화
		
		$("#upCdList").load(
			"/menu/menuMgr/cmmnCdUpCdList.do",
			{ "listScale"   : $("#listUpcdScale").val(),
              "pageIndex"   : pageIndex,
              "searchValue" : $("#searchValueUpCd").val(),
              "isRoot"		: isRoot
			},
			function(response, status, xhr){
				if($("input[name='upCd']").length == 0) {
					clearEditCodeForm();
					
					clearCurrentUpCd(); // 현재 선택된 카테고리코드 값 초기화
			        $("#viewUpCd").val(" ");      // 코드리스트 카테고리코드 Select 초기화
					
					$("#cmmnCdList").load("/menu/menuMgr/cmmnCdList.do",
			            { "listScale" : $("#codeScale").val(),
			              "pageIndex" : 1,
			              "upCd": "",
			            },
			            function(response, status, xhr) {
			            }
			        );
					return;
				}

				$("input[name='upCd']").eq(0).trigger("click");
			}
		);
	}
	
	// 코드 카테고리 등록
	function addUpCd() {
		if(!validateUpCd()) return;
		
		var upCd = $("#upCd").val();
		var upCdnm = $("#upCdnm").val();
		
		$.getJSON("/menu/menuMgr/addUpCd.do",
            {"cd"   : upCd,
			 "cdnm"   : upCdnm,
			 "cdExpln" : upCdnm,
			 "useyn"   : "Y",
            },
            function(data) {
                if(data.result > 0) {
                	//$("#note-box").prop("class", "info");
                    //$("#note-box p").text(data.message);
                    //$("#note-btn").trigger("click");
                    //
                    // 추가된 코드 값 Select에 저장
                    $("#viewUpCd").append("<option value=" + upCd + ">" + upCdnm + "</option>");
                    
                	clearUpCdForm();   // 코드 카테고리 입력창 초기화
                    upCdListPaging(1);     // 첫 페이지 이동
                } else {
                    $("#note-box").prop("class", "warning");
                    $("#note-box p").text(data.message);
                    $("#note-btn").trigger("click");
                }
                alert(data.message);
            }
        );
	}
	
	// 코드 카테고리 정보 조회
	function editUpCdForm(cmmnCdId, pageIndex) {
		clearUpCdForm();  // 코드 카테고리 입력창 초기화
        
		$.getJSON("/menu/menuMgr/editUpCdForm.do",
		    {"cmmnCdId" : cmmnCdId
            },
            function(data) {
                if(data.result > 0) {
                	$("#upCd").val(data.cd);
                	$("#upCdnm").val(data.cdnm);
                	
                    $("#upCdCheckBtn").attr("onclick", "editUpCd('" + data.cmmnCdId + "','" + pageIndex + "')");
                
                    $("#upCd").prop("disabled", true);
                } else {
                    $("#note-box").prop("class", "warning");
                    $("#note-box p").text(data.message);
                    $("#note-btn").trigger("click");
                }
            }
        );
	}

	// 코드 카테고리 정보 수정
    function editUpCd(cmmnCdId, pageIndex) {
    	if(!validateUpCd()) return;
    	
        $.getJSON("/menu/menuMgr/editUpCd.do",
            {"cmmnCdId" : cmmnCdId,
             "cdnm" : $("#upCdnm").val(),
            },
            function(data) {
                if(data.result > 0) {
                    $("#note-box").prop("class", "info");
                    $("#note-box p").text(data.message);
                    $("#note-btn").trigger("click");
                    
                    clearUpCdForm();        // 코드 카테고리 입력창 초기화
                    upCdListPaging(pageIndex);  // 변경사항 조회
                } else {
                    $("#note-box").prop("class","warning");
                    $("#note-box p").text(data.message);
                    $("#note-btn").trigger("click");
                }
            }
        );
    }
	
	// 코드 카테고리 정보 삭제 알림
	function removeUpCdForm(cmmnCdId, upCd, upCdnm) {
		// 해당 id 값을 가진 태그가 없어 주석처리함.
		// $("#alert-box").prop("class","warning");
        // $("#alert-box p").text("'" + upCdnm + ' <spring:message code="main.code.ctgr.cd" />' + '<spring:message code="main.code.message.confirm.delete" />');  // 카테고리 코드을(를) 정말 삭제 하시겠습니까?
        // $("#alertOk").attr("href","javascript:removeUpCd('" + upCd + "')");
        // $("#alertNo").attr("href","javascript:$('#alert-box').removeClass('on');");
        // $("#alert-btn").trigger("click");
        
        if (!confirm("'" + upCdnm + "'" +' <spring:message code="main.code.ctgr.cd" />' + '<spring:message code="main.code.message.confirm.delete" />')) {
			return;
		}
        removeUpCd(cmmnCdId, upCd);
	}
	
	// 코드 카테고리 정보 삭제
	function removeUpCd(cmmnCdId, upCd) {
		$.getJSON("/menu/menuMgr/removeUpCd.do",
            {"cd" : upCd,
			"cmmnCdId" : cmmnCdId
            },
            function(data) {
                if(data.result > 0) {
                	$("#note-box").prop("class", "info");
                    $("#note-box p").text(data.message);
                    $("#note-btn").trigger("click");
                    
                    clearUpCdForm();    // 코드 카테고리 입력창 초기화
                    upCdListPaging(1);      // 첫 페이지 이동
                } else {
                    $("#note-box").prop("class", "warning");
                    $("#note-box p").text(data.message);
                    $("#note-btn").trigger("click");
                }
            }
        );
	}
	
	// 코드 카테고리 정보 초기화
    function clearUpCdForm() {
        $("#upCd").val("");
        $("#upCdnm").val("");
        
        $("#upCd").prop("disabled", false);
        
        $("#upCdCheckBtn").attr("onclick", "addUpCd()");
        
        clearCurrentUpCd(); // 현재 선택된 카테고리코드 값 초기화
        $("#viewUpCd").val(" ");      // 코드리스트 카테고리코드 Select 초기화
    }
	
	// 코드 카테고리 input 유효성 검사
	function validateUpCd() {
		var isValid = true;
		var errMsg;
		
		if($("#upCd").val() == "") {
			isValid = false;
			errMsg = '<spring:message code="main.code.ctgr.cd" />' + '<spring:message code="common.required.msg" />';    // 카테고리 코드 (은)는 필수입력항목입니다.
		}
		
	    if(isValid && $("#upCdnm").val() == "") {
	    	isValid = false;
	    	errMsg = '<spring:message code="main.code.ctgr.nm" />' + '<spring:message code="common.required.msg" />';    // 카테고리명 (은)는 필수입력항목입니다.
        }
	    
	    if(!isValid) {
	    	$("#note-box").prop("class", "warning");
            $("#note-box p").text(errMsg);
            $("#note-btn").trigger("click");
	    }
	    
	    return isValid;
	}
	
	// 코드 리스트 조회
    function cmmnCdListPaging(pageIndex) {
        var upCd = $("#currentUpCd").val();
        var upCdnm = $("#currentUpCdnm").val();
        if(!upCd) return;
        clearEditCodeForm();  // 코드 입력창 초기화
        
		if ($("#viewUpCd option[value='" + upCd + "']").length === 0) {
			// 없으면 새 옵션 추가(select에 isRoot인 값만 들어가있음. 그래서 추가)
			$("#viewUpCd").append(
				$("<option>", { value: upCd, text: upCdnm })
			);
		}

        $("#viewUpCd").val(upCd);
        
        console.log("옵션들=", $("#viewUpCd option").map(function(){return $(this).val();}).get());
        
        $("#cmmnCdList").load(
            "/menu/menuMgr/cmmnCdList.do",
            { "listScale" : $("#codeScale").val(),
              "pageIndex" : pageIndex,
              "upCd": upCd,
              "searchValue": $("#searchValueCode").val(),
            },
            function(response, status, xhr) {
            }
        );
    }
	
	// 코드 등록
	function addCode() {
		if($("#currentUpCd").val() == "") return;
	    if(!validateCode()) return;
	    
        $.getJSON("/menu/menuMgr/addCode.do",
            {"upCd"   : $("#viewUpCd").val(),
             "cd"       : $("#cd").val(),
             "cdnm"       : $("#cdnm").val(),
             "cdExpln"     : $("#cdExpln").val(),
             "useyn"        : $("#useyn")[0].checked ? "Y" : "N",
            },
            function(data) {
                if(data.result > 0) {
                    $("#note-box").prop("class", "info");
                    $("#note-box p").text(data.message);
                    $("#note-btn").trigger("click");
                    
                    cmmnCdListPaging(1);     // 첫 페이지 이동
                } else {
                    $("#note-box").prop("class", "warning");
                    $("#note-box p").text(data.message);
                    $("#note-btn").trigger("click");
                }
            }
        );
	}
	
	// 코드수정 정보 조회
	function editCodeForm(cmmnCdId, cd, pageIndex) {
		clearEditCodeForm();  // 코드 입력창 초기화
        
        $.getJSON("/menu/menuMgr/editCodeForm.do",
            {
        	/* "upCd"  : upCd, */
        	 "cmmnCdId"      : cmmnCdId,
            },
            function(data) {
                if(data.result > 0) {
                    $("#cd").val(data.cd);
                    $("#cdnm").val(data.cdnm);
                    $("#cdExpln").val(data.cdExpln);
                    $("#cdSeq").val(data.cdSeq);
                    
                    if(data.useyn == "Y") {
                    	$("#useyn").prop("checked", true);
                    } else {
                    	$("#useyn").prop("checked", false);
                    }
                    
                    $("#cdCheckBtn").attr("onclick", "editCode('" + data.cmmnCdId + "','" + data.cd + "','" + pageIndex + "')");
                
                    $("#cd").prop("disabled", true);
                    $("#cdSeq").prop("disabled", false);
                    
                    $.each($("input[name='useyn']"), function() {
                    	if(this.id == "useyn" + "|" + cmmnCdId) {
                    		$(this).prop("disabled", true);
                    	}
                    });
                    
                } else {
                    $("#note-box").prop("class", "warning");
                    $("#note-box p").text(data.message);
                    $("#note-btn").trigger("click");
                    
                    $("#cd").prop("disabled", false);
                }
            }
        );
	}

	// 코드정보 수정
	function editCode(cmmnCdId, cd, pageIndex) {
		if($("#currentUpCd").val() == "") return;
		
		if(!validateCode()) return;
		
		$.getJSON("/menu/menuMgr/editCode.do",
            {
			/* "upCd"   : upCd, */
             "cmmnCdId" : cmmnCdId,
             "cd"		: cd,
             "cdnm"     : $("#cdnm").val(),
             "cdExpln"  : $("#cdExpln").val(),
             "cdSeq"    : $("#cdSeq").val(),
             "useyn"    : $("#useyn")[0].checked ? "Y" : "N",
            },
            function(data) {
                if(data.result > 0) {
                    $("#note-box").prop("class", "info");
                    $("#note-box p").text(data.message);
                    $("#note-btn").trigger("click");
                    
                    cmmnCdListPaging(pageIndex);  // 변경사항 조회
                } else {
                    $("#note-box").prop("class", "warning");
                    $("#note-box p").text(data.message);
                    $("#note-btn").trigger("click");
                }
            }
        );
	}
	
	// 코드정보 삭제 알림
    function removeCodeForm(cmmnCdId, cd, cdnm) {
        // 해당 id 값을 가진 태그가 없어 주석처리함.
    	// $("#alert-box").prop("class","warning");
        // $("#alert-box p").text("'" + codeNm + ' <spring:message code="main.code.code" />' + '<spring:message code="main.code.message.confirm.delete" />');   // 코드을(를) 정말 삭제 하시겠습니까?
        // $("#alertOk").attr("href","javascript:removeCode('" + upCd + "','" + codeCd + "')");
        // $("#alertNo").attr("href","javascript:$('#alert-box').removeClass('on');");
        // $("#alert-btn").trigger("click");
        
    	 if (!confirm("'" + cdnm + "'" +' <spring:message code="main.code.code" />' + '<spring:message code="main.code.message.confirm.delete" />')) {
 			return;
 		}
    	 removeCode(cmmnCdId, cd);
    }
	
	// 코드삭제
	function removeCode(cmmnCdId, cd) {
		$.getJSON("/menu/menuMgr/removeCode.do",
            {"cmmnCdId"   : cmmnCdId,
			 "cd"       : cd
            },
            function(data) {
                if(data.result > 0) {
                    $("#note-box").prop("class", "info");
                    $("#note-box p").text(data.message);
                    $("#note-btn").trigger("click");
                    
                    clearEditCodeForm();    // 코드 입력창 초기화
                    cmmnCdListPaging(1);      // 첫 페이지 이동
                } else {
                    $("#note-box").prop("class", "warning");
                    $("#note-box p").text(data.message);
                    $("#note-btn").trigger("click");
                }
            }
        );
	}
	
	// 코드수정 정보 초기화
    function clearEditCodeForm() {
        $("#cd").val("");
        $("#cdnm").val("");
        $("#cdExpln").val("");
        $("#cdSeq").val("");
        $("#useyn").prop("checked", true);
        $("#cd").prop("disabled", false);
        $("#cdSeq").prop("disabled", true);
        $("#cdCheckBtn").attr("onclick", "addCode()");
        
        $.each($("input[name='useyn']"), function() {
            $(this).prop("disabled", false);
        });
    }
	
    // 코드 input 유효성 검사
	function validateCode() {
		var isValid = true;
        var errMsg;
        
        if($("#cd").val() == "") {
            isValid = false;
            errMsg = '<spring:message code="main.code.code" />' + '<spring:message code="common.required.msg" />';  // 코드 (은)는 필수입력항목입니다.
        }
        
        if(isValid && $("#cdnm").val() == "") {
            isValid = false;
            errMsg = '<spring:message code="main.code.nm" />' + '<spring:message code="common.required.msg" />';    // 코드명 (은)는 필수입력항목입니다.
        }
        
        if(isValid && $("#cdExpln").val() == "") {
            isValid = false;
            errMsg = '<spring:message code="main.code.desc" />' + '<spring:message code="common.required.msg" />';  // 코드설명 (은)는 필수입력항목입니다.
        }
        
        if(isValid && $("#cdSeq").val() != "" && !$.isNumeric($("#cdSeq").val())) {
            isValid = false;
            errMsg = '<spring:message code="main.code.odr" />' + '<spring:message code="main.code.message.valid.int" />';    // 표시수순서은(는) 순자만 입력하세요.
        }
        
        if(!isValid) {
            $("#note-box").prop("class", "warning");
            $("#note-box p").text(errMsg);
            $("#note-btn").trigger("click");
        }
        
        return isValid;
	}
    
	function clearCurrentUpCd() {
		$("#currentUpCd").val("");     // 코드 값 초기화
		$("#currentUpCdnm").val("");   // 코드명 초기화
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
			                
			    <div id="info-item-box">
			        <h2 class="page-title"><spring:message code="main.code.title"/></h2><!-- 코드 관리 -->
			    </div>
			    
			    <div class="ui form">
			        <div class="ui top attached message">
			            <div class="header"><spring:message code="main.code.ctgr.list"/></div><!-- 카테고리 목록 -->
			        </div>
			        
			        <div class="ui bottom attached segment">
			            <div class="option-content">
			                <div class="ui action input search-box">
			                    <input type="text" placeholder="<spring:message code="button.search"/>" id="searchValueUpCd" maxlength="100" />
			                    <button type="button" class="ui icon button" onclick="upCdListPaging(1);" ><i class="search icon"></i></button>
			                </div>
			                <div class="button-area">
			                    <select class="ui dropdown list-num" id="listUpcdScale" onchange="upCdListPaging(1);">
			                        <option value="5">5</option>
			                        <option value="10">10</option>
			                        <option value="20">20</option>
			                        <option value="50">50</option>
			                        <option value="100">100</option>
			                    </select>
			                </div>
			            </div>
			            <div class="ui divider"></div>
			            <div class="ui stackable grid pb20">
			                <div class="six wide computer column">
			                    <div class="field">
			                        <label><spring:message code="main.code.ctgr.cd"/></label><!-- 카테고리 코드 -->
			                        <div class="ui input">
			                            <input type="text" id="upCd" autocomplete="off" />
			                        </div>
			                    </div>
			                </div>
			                <div class="ten wide computer column">
			                    <div class="field">
			                        <label><spring:message code="main.code.ctgr.nm"/></label><!-- 카테고리명 -->
			                        <div class="ui input mr10" style="width: calc(100% - 100px)">
			                            <input type="text" id="upCdnm" autocomplete="off" />
			                        </div>
			                        <div class="img-button">
			                            <button id="upCdCheckBtn" class="icon_check"  onclick="addUpCd()"></button>
			                            <button class="icon_cancel" onclick="clearUpCdForm()"></button>
			                        </div>
			                    </div>
			                </div>
			            </div>
			            <div id="upCdList"></div>
			        </div>
			        
			        <div class="ui top attached message">
			            <div class="header"><spring:message code="main.code.list"/></div><!-- 코드 목록 -->
			        </div>
			        <div class="ui bottom attached segment">
			            <div class="option-content">
			            	<!-- 변경된 구조에서는 안 쓰는 게 좋아보임. 상위에서 검색하는 것으로 변경할 필요가 있음  -->
			                <div class="ui action input search-box">
			                    <input type="text" placeholder="<spring:message code="button.search"/>" id="searchValueCode" maxlength="100" />
			                    <button type="button" class="ui icon button" onclick="cmmnCdListPaging(1);"><i class="search icon"></i></button>
			                </div>
			                <div class="button-area">
			                    <select class="ui dropdown list-num" id="codeScale" onchange="cmmnCdListPaging(1);">
			                        <option value="10">10</option>
			                        <option value="20">20</option>
			                        <option value="50">50</option>
			                        <option value="100">100</option>
			                    </select>
			                </div>
			            </div>
			            <div class="ui divider"></div>
			            <div class="ui stackable grid pb20">
			                <div class="three wide computer column">
			                    <div class="field">
			                        <label><spring:message code="main.code.ctgr"/></label><!-- 카테고리 -->
			                        <select class="ui dropdown" id="viewUpCd" title="<spring:message code="main.page.pageCdNm" />" disabled="disabled">
			                            <option value=" "></option>
						                <c:forEach var="item" items="${cmmnCdUpCdList}" varStatus="status">
						                    <option value="${item.cd}">${item.cdnm}</option> 
						                </c:forEach>
					               </select>
			                    </div>
			                </div>
			                <div class="two wide computer column">
			                    <div class="field">
			                        <label><spring:message code="main.code.code"/></label><!-- 코드 -->
			                        <div class="ui input">
			                            <input type="text" id="cd" autocomplete="off" />
			                        </div>
			                    </div>
			                </div>
			                <div class="three wide computer column">
			                    <div class="field">
			                        <label><spring:message code="main.code.nm"/></label><!-- 코드명 -->
			                        <div class="ui input">
			                            <input type="text" id="cdnm" autocomplete="off" />
			                        </div>
			                    </div>
			                </div>
			                <div class="three wide computer column">
			                    <div class="field">
			                        <label><spring:message code="main.code.desc"/></label><!-- 코드설명 -->
			                        <div class="ui input">
			                            <input type="text" id="cdExpln" autocomplete="off" />
			                        </div>
			                    </div>
			                </div>
			                <div class="two wide computer column">
			                    <div class="field">
			                        <label><spring:message code="main.code.odr"/></label><!-- 표시순서 -->
			                        <div class="ui input">
			                            <input type="text" id="cdSeq" autocomplete="off" />
			                        </div>
			                    </div>
			                </div>
			                <div class="three wide computer column">
			                    <div class="field">
			                        <label><spring:message code="common.use.yn"/></label><!-- 사용여부 -->
			                        <div class="ui toggle checkbox">
			                            <input type="checkbox" id="useyn" name="useyn" checked="checked" />
			                        </div>
			                        <div class="img-button">
			                            <button id="cdCheckBtn" class="icon_check" onclick="addCode()"></button>
			                            <button class="icon_cancel" onclick="clearEditCodeForm()"></button>
			                        </div>
			                    </div>
			                </div>
			            </div>
			            <div id="cmmnCdList"></div>
			        </div>
			    </div>
			</div>
			<!-- //본문 content 부분 -->

		</div>
		<%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
	</div>
</body>