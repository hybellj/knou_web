<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
	<script type="text/javascript">
		var ACTIVE_TAB = "1";
		var IS_INIT_TAB2 = false;
	
		$(document).ready(function() {
			$("#searchValue1").on("keydown", function(e) {
			    if(e.keyCode == 13) {
			    	listPaging1(1);
		        } 
		    });
			
			$("#searchValue2").on("keydown", function(e) {
			    if(e.keyCode == 13) {
			    	listPaging2(1);
		        } 
		    });
			
			listPaging1(1);
		 	
			// 탭 초기화
			$('.tabmenu.menu .item').tab(); 
			ACTIVE_TAB = "1";
		});
		
		function listPaging1(pageIndex) {
			var url = "/sch/schMgr/listPopupNotice.do"
			var param = {
				  pageIndex		: pageIndex
				, listScale		: $("#listScale1").val()
				, searchValue 	: $("#searchValue1").val()
				, popupNtcSdttm	: ($("#popupNtcSdttm1").val() || "").replaceAll(".", "")
				, popupNtcEdttm	: ($("#popupNtcEdttm1").val() || "").replaceAll(".", "")
				, activePopYn	: $("#activePopYn1").is(":checked") ? "Y" : "N"
				, pagingYn		: "Y"
				, popupNtcTycd	: "EVAL"
			};
			
			ajaxCall(url, param, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					var html = '';
					
					returnList.forEach(function(v, i) {
						var popupNtcSdttmFmt = (v.popupNtcSdttm || "").length == 14 ? v.popupNtcSdttm.substring(0, 4) + '.' + v.popupNtcSdttm.substring(4, 6) + '.' + v.popupNtcSdttm.substring(6, 8) + ' ' + v.popupNtcSdttm.substring(8, 10) + ':' + v.popupNtcSdttm.substring(10, 12) : v.popupNtcSdttm;
						var popupNtcEdttmFmt = (v.popupNtcEdttm || "").length == 14 ? v.popupNtcEdttm.substring(0, 4) + '.' + v.popupNtcEdttm.substring(4, 6) + '.' + v.popupNtcEdttm.substring(6, 8) + ' ' + v.popupNtcEdttm.substring(8, 10) + ':' + v.popupNtcEdttm.substring(10, 12) : v.popupNtcEdttm;
						var popDttm = popupNtcSdttmFmt + " ~ " + popupNtcEdttmFmt;
						var regDttmFmt = (v.regDttm || "").length == 14 ? v.regDttm.substring(0, 4) + '.' + v.regDttm.substring(4, 6) + '.' + v.regDttm.substring(6, 8) + ' ' + v.regDttm.substring(8, 10) + ':' + v.regDttm.substring(10, 12) : v.regDttm;
					
						html += '<tr>';
						html += '	<td class="tc">' + v.lineNo + '</td>';
						html += '	<td>' + v.popupNtcTtl + '</td>';
						html += '	<td class="tc">' + popDttm + '</td>';
						html += '	<td>' + getPopTargetNm(v.popupNtcTrgtCd) + '</td>';
						html += '	<td class="tc">' + (v.popupNtcTdstopUseyn == "Y" ? (v.popupNtcTdstopDayCntcnt + "일") : "N") + '</td>';
						html += '	<td class="tc">';
						html += '		<div class="ui toggle checkbox">';
						html += '   	    <input type="checkbox" onchange="changeUseYn(\'' + v.popupNtcId + '\', this);" ' + (v.useyn == "Y" ? "checked" : "") + ' />';
						html += '  		</div>';
						html += '	</td>';
						html += '	<td class="tc">' + regDttmFmt + '</td>';
						html += '	<td class="tc">';
						html += '		<a href="javascript:void(0)" onclick="popupNoticePreview(\'' + v.popupNtcId + '\');" class="ui basic button small">미리보기</a>';
						html += '		<a href="javascript:void(0)" onclick="popupNoticeWriteModal(\'EVAL\', \'' + v.popupNtcId + '\');" class="ui basic button small">수정</a>';
						html += '		<a href="javascript:void(0)" onclick="deletePopupNotice(\'' + v.popupNtcId + '\')" class="ui basic button small">삭제</a>';
						html += '	</td>';
						html += '</tr>';
					});
					
					$("#list1").html(html);
	    			$("#table1").footable();
	    			$("#table1").find(".ui.checkbox").checkbox();
	    			
	    			var params = {
	   					totalCount : data.pageInfo.totalRecordCount,
	   					listScale : data.pageInfo.recordCountPerPage,
	   					currentPageNo : data.pageInfo.currentPageNo,
	   					eventName : "listPaging1",
	   					pagingDivId: "paging1",
	   				};

	   				gfn_renderPaging(params);
	        	} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		}
		
		function listPaging2(pageIndex) {
			var popupNtcTrgtCdList = $("#popupNtcTrgtCd2").val() || [];
				
			var url = "/sch/schMgr/listPopupNotice.do";
			var param = {
				  pageIndex		: pageIndex
				, listScale		: $("#listScale2").val()
				, searchValue 	: $("#searchValue2").val()
				, popupNtcSdttm	: ($("#popupNtcSdttm2").val() || "").replaceAll(".", "")
				, popupNtcEdttm	: ($("#popupNtcEdttm2").val() || "").replaceAll(".", "")
				, activePopYn	: $("#activePopYn2").is(":checked") ? "Y" : "N"
				, pagingYn		: "Y"
				, popupNtcTycd	: "ETC"
				, popupNtcTrgtCd   : popupNtcTrgtCdList.join(",")
			};
			
			ajaxCall(url, param, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					var html = '';
					
					returnList.forEach(function(v, i) {
						var popupNtcSdttmFmt = (v.popupNtcSdttm || "").length == 14 ? v.popupNtcSdttm.substring(0, 4) + '.' + v.popupNtcSdttm.substring(4, 6) + '.' + v.popupNtcSdttm.substring(6, 8) + ' ' + v.popupNtcSdttm.substring(8, 10) + ':' + v.popupNtcSdttm.substring(10, 12) : v.popupNtcSdttm;
						var popupNtcEdttmFmt = (v.popupNtcEdttm || "").length == 14 ? v.popupNtcEdttm.substring(0, 4) + '.' + v.popupNtcEdttm.substring(4, 6) + '.' + v.popupNtcEdttm.substring(6, 8) + ' ' + v.popupNtcEdttm.substring(8, 10) + ':' + v.popupNtcEdttm.substring(10, 12) : v.popupNtcEdttm;
						var popDttm = popupNtcSdttmFmt + " ~ " + popupNtcEdttmFmt;
						var regDttmFmt = (v.regDttm || "").length == 14 ? v.regDttm.substring(0, 4) + '.' + v.regDttm.substring(4, 6) + '.' + v.regDttm.substring(6, 8) + ' ' + v.regDttm.substring(8, 10) + ':' + v.regDttm.substring(10, 12) : v.regDttm;
						
						html += '<tr>';
						html += '	<td>' + v.lineNo + '</td>';
						html += '	<td>' + v.popupNtcTtl + '</td>';
						html += '	<td>' + popDttm + '</td>';
						html += '	<td>' + getPopTargetNm(v.popupNtcTrgtCd) + '</td>';
						html += '	<td class="tc">' + (v.popupNtcTdstopUseyn == "Y" ? (v.popupNtcTdstopDayCntcnt + "일") : "N") + '</td>';
						html += '	<td class="tc">';
						html += '		<div class="ui toggle checkbox">';
						html += '   	    <input type="checkbox" onchange="changeUseYn(\'' + v.popupNtcId + '\', this);" ' + (v.useyn == "Y" ? "checked" : "") + ' />';
						html += '  		</div>';
						html += '	</td>';
						html += '	<td class="tc">' + regDttmFmt + '</td>';
						html += '	<td class="tc">';
						html += '		<a href="javascript:void(0)" onclick="popupNoticePreview(\'' + v.popupNtcId + '\');" class="ui basic button small">미리보기</a>';
						html += '		<a href="javascript:void(0)" onclick="popupNoticeWriteModal(\'ETC\', \'' + v.popupNtcId + '\');" class="ui basic button small">수정</a>';
						html += '		<a href="javascript:void(0)" onclick="deletePopupNotice(\'' + v.popupNtcId + '\')" class="ui basic button small">삭제</a>';
						html += '	</td>';
						html += '</tr>';
					});
					
					$("#list2").html(html);
	    			$("#table2").footable();
	    			$("#table2").find(".ui.checkbox").checkbox();
	    			
	    			var params = {
	   					totalCount : data.pageInfo.totalRecordCount,
	   					listScale : data.pageInfo.recordCountPerPage,
	   					currentPageNo : data.pageInfo.currentPageNo,
	   					eventName : "listPaging2",
	   					pagingDivId: "paging2",
	   				};

	   				gfn_renderPaging(params);
	        	} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		}
		
		// 팝업 코드명 가져오기
		function getPopTargetNm(popupNtcTrgtCd) {
			var popTargetNmList = [];
			
			if(!popupNtcTrgtCd) {
				popTargetNmList.push("전체");
			} else {
				var popTargetList = popupNtcTrgtCd.split(",") || [];
				
				popTargetList.forEach(function(v, i) {
					if(v == "PFS") {
						popTargetNmList.push("교수");
					} else if(v == "TUT") {
						popTargetNmList.push("조교");
					} else if(v == "USR") {
						popTargetNmList.push("학생");
					}
				});
			}
			
			return popTargetNmList.join(",");
		}
		
		// 팝업 사용여부 변경
		function changeUseYn(popupNtcId, el) {
			var url = "/sch/schMgr/updateUseYnPopupNotice.do"
				var param = {
					  popupNtcId: popupNtcId
					, useyn: el.checked ? "Y" : "N"
				};
				
				ajaxCall(url, param, function(data) {
					if(data.result > 0) {
						
					} else {
		        		alert(data.message);
		        		el.checked = el.checked ? false : true;
		        	}
				}, function(xhr, status, error) {
					alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
				}, true);
		}
		
		// 팝업 삭제
		function deletePopupNotice(popupNtcId){
			if(!confirm('<spring:message code="common.delete.msg" />')) return; // 삭제하시겠습니까?
			
			var url = "/sch/schMgr/deletePopupNotice.do"
			var param = {
				popupNtcId: popupNtcId
			};
			
			ajaxCall(url, param, function(data) {
				if(data.result > 0) {
					alert('<spring:message code="common.alert.delete.success" />'); // 삭제 완료하였습니다.
	        		if(ACTIVE_TAB == "1") {
	        			listPaging1(1);
	        		} else if(ACTIVE_TAB == "2") {
	        			listPaging2(1);
	        		}
				} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		}
		
		// 탭 이동
		function changeTab(tab) {
			ACTIVE_TAB = tab;
			
			if(tab == "1") {
				
			} else if(tab == "2") {
				if(!IS_INIT_TAB2) {
					IS_INIT_TAB2 = true;
					listPaging2(1);
				}
			}
		}
		
		// 팝업관리 등록 모달
		function popupNoticeWriteModal(popupNtcTycd, popupNtcId) {
			if(popupNtcTycd == "EVAL") {
				$("#popupNtcTtl").text("강의평가 팝업");
			} else {
				$("#popupNtcTtl").text("기타 팝업");
			}
			
			$("#popupNoticeWriteForm input[name=popupNtcId]").val(popupNtcId);
			$("#popupNoticeWriteForm input[name=popupNtcTycd]").val(popupNtcTycd);
			$("#popupNoticeWriteForm").attr("target", "popupNoticeWriteIfm");
	        $("#popupNoticeWriteForm").attr("action", "/sch/schMgr/popupNoticeWritePop.do");
	        $("#popupNoticeWriteForm").submit();
	        $("#popupNoticeWriteModal").modal("show");
		}
		
		// 팝업관리 등록 모달 콜백
		function popupNoticeWriteCallBack(data) {
			var popupNtcTycd = data && data.popupNtcTycd;
			
			if(popupNtcTycd) {
				if(popupNtcTycd == "EVAL") {
					listPaging1(1);
				} else {
					listPaging2(1);
				}
			}
		}
		
		// 팝업관리 미리보기 모달
		function popupNoticePreview(popupNtcId) {
			var url = "/sch/schMgr/selectPopupNotice.do"
			var param = {
				popupNtcId: popupNtcId
			};
			
			ajaxCall(url, param, function(data) {
				if(data.result > 0) {
					var noticeTitle = data.returnVO && data.returnVO.popupNtcTtl || "미리보기";
					var xPercent = data.returnVO && data.returnVO.xPercent || "50";
					$("#popupNoticePreviewTitle").text(popupNtcTtl);
					$("#popupNoticePreviewDiv").css("width", xPercent + "%");
					
					$("#popupNoticePreviewForm input[name=popupNtcId]").val(popupNtcId);
					$("#popupNoticePreviewForm").attr("target", "popupNoticePreviewIfm");
			        $("#popupNoticePreviewForm").attr("action", "/sch/schMgr/popupNoticePreviewPop.do");
			        $("#popupNoticePreviewForm").submit();
			        $("#popupNoticePreviewModal").modal("show");
				} else {
	        		alert(data.message);
	        	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			}, true);
		}
	</script>
</head>
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
				<div id="info-item-box">
					<h2 class="page-title">팝업관리</h2>
					<div class="button-area">
					</div>
				</div>
				<div class="ui divider mt0"></div>
				<div class="ui form">
					<div class="option-content gap4">
						<div class="ui pointing secondary tabmenu menu">
							<a class="item pt0 active" data-tab="1" onclick="changeTab('1')">강의평가</a><!-- 강의평가 -->
							<a class="item pt0" data-tab="2" onclick="changeTab('2')">기타팝업</a><!-- 기타팝업 -->
						</div>
					</div>
					<div class="ui tab active" data-tab="1">
						<div class="ui segment searchArea">
				        	<div class="ui input">
								<input id="searchValue1" type="text" placeholder="제목" class="w250" />
								<div class="ui calendar ml5" id="rangestart1">
	                                <div class="ui input left icon">
	                                    <i class="calendar alternate outline icon"></i>
	                                    <input type="text" id="popupNtcSdttm1" placeholder="<spring:message code='common.start.date'/>" autocomplete="off" /><!-- 시작일 -->
	                                </div>
	                            </div>
	                            <div class="ui calendar ml5" id="rangeend2">
	                                <div class="ui input left icon">
	                                    <i class="calendar alternate outline icon"></i>
	                                    <input type="text" id="popupNtcEdttm1" placeholder="<spring:message code='common.enddate'/>" autocomplete="off" /><!-- 종료일 -->
	                                </div>
	                            </div>
							</div>
							<div class="ui checkbox ml10">
		                        <input type="checkbox" class="hidden" id="activePopYn1" onchange="listPaging1(1)" />
		                        <label for="">기간내 팝업 보기</label>
		                    </div>
				          	<div class="button-area mt10 tc">
								<a href="javascript:void(0)" class="ui blue button w100" onclick="listPaging1(1)"><spring:message code="common.button.search" /><!-- 검색 --></a>
							</div>
				      	</div>
				      	<div class="option-content gap4">
			      		 	<div class="button-area">
			      		 		<a href="javascript:popupNoticeWriteModal('EVAL')" class="btn btn-primary">강의평가 팝업 <spring:message code="button.write" /></a>
				            	<select class="ui dropdown list-num" id="listScale1" onchange="listPaging1(1)">
				                	<option value="10">10</option>
				                  	<option value="20">20</option>
				                  	<option value="50">50</option>
				                  	<option value="100">100</option>
				              	</select>
				          	</div>
				      	</div>
				      	<table class="tBasic" data-sorting="false" data-empty="<spring:message code='common.content.not_found' />" id="table1"><!-- 등록된 내용이 없습니다. -->
							<thead>
								<th scope="col" class="p_w5"><spring:message code="common.number.no"/></th>
								<th scope="col" class="p_w30">제목<!-- 제목 --></th><!-- 제목 -->
								<th scope="col" class="p_w20" data-breakpoints="xs">공지기간<!-- 공지기간 --></th>
								<th scope="col" class="p_w10" data-breakpoints="xs">공지대상<!-- 공지대상 --></th>
								<th scope="col" class="p_w5" data-breakpoints="xs">닫기 사용여부<!-- 닫기 사용여부 --></th>
								<th scope="col" class="p_w5" data-breakpoints="xs">사용여부<!-- 사용여부 --></th>
								<th scope="col" class="p_w10" data-breakpoints="xs">등록일<!-- 등록일 --></th>
								<th scope="col" class="p_w15" data-breakpoints="xs">관리<!-- 관리 --></th>
							</thead>
							<tbody id="list1">
							</tbody>
						</table>
						<div id="paging1" class="mt10 paging"></div>
			      	</div>
			      	<div class="ui tab" data-tab="2">
			      		<div class="ui segment searchArea">
				        	<div class="ui input">
								<input id="searchValue2" type="text" placeholder="제목" class="w250" />
								<div class="ui calendar ml5" id="rangestart2">
	                                <div class="ui input left icon">
	                                    <i class="calendar alternate outline icon"></i>
	                                    <input type="text" id="popupNtcSdttm2" placeholder="<spring:message code='common.start.date'/>" autocomplete="off" /><!-- 시작일 -->
	                                </div>
	                            </div>
	                            <div class="ui calendar ml5" id="rangeend2">
	                                <div class="ui input left icon">
	                                    <i class="calendar alternate outline icon"></i>
	                                    <input type="text" id="popupNtcEdttm2" placeholder="<spring:message code='common.enddate'/>" autocomplete="off" /><!-- 종료일 -->
	                                </div>
	                            </div>
							</div>
							<select class="ui dropdown  mr5" id="popupNtcTrgtCd2" multiple="">
								<option value="">공지대상</option>
		                   		<c:forEach var="item" items="${popupNtcTrgtCdList}" varStatus="status">
									<option value="${item.codeCd}"><c:out value="${item.codeNm}" /></option>
								</c:forEach>
		                   	</select>
		                   	<div class="ui checkbox ml10">
		                        <input type="checkbox" class="hidden" id="activePopYn2" onchange="listPaging2(1)" />
		                        <label for="">기간내 팝업 보기</label>
		                    </div>
				          	<div class="button-area mt10 tc">
								<a href="javascript:void(0)" class="ui blue button w100" onclick="listPaging2(1)"><spring:message code="common.button.search" /><!-- 검색 --></a>
							</div>
				      	</div>
				      	<div class="option-content gap4">
			      		 	<div class="button-area">
			      		 		<a href="javascript:popupNoticeWriteModal('ETC')" class="btn btn-primary">기타팝업 <spring:message code="button.write" /></a>
				            	<select class="ui dropdown list-num" id="listScale2" onchange="listPaging2(1)">
				                	<option value="10">10</option>
				                  	<option value="20">20</option>
				                  	<option value="50">50</option>
				                  	<option value="100">100</option>
				              	</select>
				          	</div>
				      	</div>
				      	<table class="tBasic" data-sorting="false" data-empty="<spring:message code='common.content.not_found' />" id="table2"><!-- 등록된 내용이 없습니다. -->
							<thead>
								<tr class="footable-header">
									<th scope="col" class="p_w5"><spring:message code="common.number.no"/></th>
									<th scope="col" class="p_w30">제목<!-- 제목 --></th><!-- 제목 -->
									<th scope="col" class="p_w20" data-breakpoints="xs">공지기간<!-- 공지기간 --></th>
									<th scope="col" class="p_w10" data-breakpoints="xs">공지대상<!-- 공지대상 --></th>
									<th scope="col" class="p_w5" data-breakpoints="xs">닫기 사용여부<!-- 닫기 사용여부 --></th>
									<th scope="col" class="p_w5" data-breakpoints="xs">사용여부<!-- 사용여부 --></th>
									<th scope="col" class="p_w10" data-breakpoints="xs">등록일<!-- 등록일 --></th>
									<th scope="col" class="p_w15" data-breakpoints="xs">관리<!-- 관리 --></th>
								</tr>
							</thead>
							<tbody id="list2">
							</tbody>
						</table>
						<div id="paging2" class="mt10 paging"></div>
			      	</div>
				</div>
            </div>
        </div>
        <!-- //본문 container 부분 -->
        <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
    </div>
	<!-- 팝업관리 등록 팝업 -->
    <form id="popupNoticeWriteForm" name="popupNoticeWriteForm">
    	<input type="hidden" name="popupNtcId" value="" />
    	<input type="hidden" name="popupNtcTycd" value="" />
	</form>
    <div class="modal fade in" id="popupNoticeWriteModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="common.modal.field" />" aria-hidden="false" style="display: none; padding-right: 17px;">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="team.common.close"/>">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title" id="popupNoticeTitle"></h4>
                </div>
                <div class="modal-body">
                    <iframe src="" width="100%" id="popupNoticeWriteIfm" name="popupNoticeWriteIfm"></iframe>
                </div>
            </div>
        </div>
    </div>
    <!-- 팝업관리 미리보기 팝업 -->
    <form id="popupNoticePreviewForm" name="popupNoticePreviewForm">
    	<input type="hidden" name="popupNtcId" value="" />
	</form>
    <div class="modal fade in" id="popupNoticePreviewModal" tabindex="-1" role="dialog" aria-labelledby="<spring:message code="common.modal.field" />" aria-hidden="false" style="display: none; padding-right: 17px;">
        <div class="modal-dialog modal-lg" role="document" id="popupNoticePreviewDiv" style="width: 50%;min-width:300px;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="<spring:message code="team.common.close"/>">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title" id="popupNoticePreviewTitle"></h4>
                </div>
                <div class="modal-body">
                    <iframe src="" width="100%" id="popupNoticePreviewIfm" name="popupNoticePreviewIfm"></iframe>
                </div>
            </div>
        </div>
    </div>
    <script>
        $('iframe').iFrameResize();
        window.closeModal = function() {
            $('.modal').modal('hide');
            $("#popupNoticeWriteIfm").attr("src", "");
            $("#popupNoticePreviewIfm").attr("src", "");
        };
    </script>
</body>
</html>