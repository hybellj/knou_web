<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
	<%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
	<%@ include file="/WEB-INF/jsp/common/common_inc.jsp"%>
   	<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
   	<style type="text/css">
	/* 게시판 부제목 */
	.sub-title {
		width: 0;
		white-space: nowrap;
	}
	
	/* 모바일 게시글 제목 부가정보 */
	.sub-title-mobile {
		display: none;
	}
	
	@media all and (max-width:767px) {
		.sub-title {
			display: none !important;
		}
		
		.sub-title-mobile {
			display: flex !important;
		}
	}
	
	@media all and (min-width:768px) {
		.sub-title {
			display: table-cell !important;
		}
		
		.sub-title-mobile {
			display: none !important;
		}
		
		.ui.selection.dropdown .menu {
		    max-height: 13rem;
		}
	}
</style>
<script type="text/javascript">
	var templateUrl;

	$(document).ready(function() {
		$("#searchValue").on("keydown", function(e) {
			if(e.keyCode == 13) {
				listPaging(1);
			}
		});
		
		var crsCreCd = '<c:out value="${vo.crsCreCd}" />';
		var bbsId = '<c:out value="${vo.bbsId}" />';
		
		setEmptyList();
		
		if(crsCreCd) {
			templateUrl = "bbsLect";
			changeTerm($("#termCd").val());
		} else {
			templateUrl = "bbsHome";
			listPaging(1);
		}
	});
	
	function listPaging(pageIndex) {
		if(templateUrl == "bbsLect") {
			var crsCreCd = $("#searchCrsCreCd").val();
			
			if(!crsCreCd) {
				alert('<spring:message code="bbs.alert.no_select_course" />'); // 강의실을 선택하세요.
				return;
			}
		} else {
			var bbsId = '<c:out value="${vo.bbsId}" />';
			$("#searchBbsId").val(bbsId);
		}
		
		var url = "/bbs/" + templateUrl +  "/listAtcl.do";
		var data = {
			  crsCreCd		: $("#searchCrsCreCd").val()
			, bbsId			: $("#searchBbsId").val()
			, pageIndex		: pageIndex
			, listScale		: $("#listScale").val()
			, searchValue 	: $("#searchValue").val()
		};
		
		$.ajax({
            url : url,
            type : "get",
            data: data,
        }).done(function(data) {
        	if (data.result > 0) {
        		var returnList = data.returnList || [];
        		var pageInfo = data.pageInfo;
        		
        		var html = createAtclListHTML(returnList, pageInfo);
        		
        		$("#atclListArea").empty().html(html);
    			$("#atclList").footable();
    			
    			var params = {
   					totalCount : data.pageInfo.totalRecordCount,
   					listScale : data.pageInfo.recordCountPerPage,
   					currentPageNo : data.pageInfo.currentPageNo,
   					eventName : "listPaging"
   				};

   				gfn_renderPaging(params);
            } else {
            	setEmptyList();
            }
        }).fail(function() {
        	setEmptyList();
        });
	}

	// 학기 변경 - 강의실 세팅
	function changeTerm(termCd) {
		setEmptyList();
		$("#searchCrsCreCd").val("");
		$("#searchBbsId").val("");
		
		var url = "/crs/creCrsHome/listRepUserCrsCreByTerm.do";
		var data = {
			  termCd: termCd
			, repUserId: '<c:out value="${repUserId}" />'
		};
		
		$.ajax({
            url : url,
            type : "get",
            data: data,
        }).done(function(data) {
        	if (data.result > 0) {
        		var returnList = data.returnList || [];
        		var html = '';
        		
           		returnList.forEach(function(v, i) {
           			html += '<option value="' + v.crsCreCd + '" >' + v.crsCreNm + ' (' + v.declsNo + ')</option>';
           		});
        		
        		$("#crsCreCd").empty().html(html);
           		$("#crsCreCd").dropdown("clear");
            } else {
             	alert(data.message);
             	setEmptyList();
            }
        }).fail(function() {
        	alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
        	setEmptyList();
        }, true);
	}
	
	// 강의실 변경 - 게시글 목록 세팅
	function changeCrsCreCd(crsCreCd) {
		if(!crsCreCd) return;
		
		$("#searchCrsCreCd").val(crsCreCd);
		$("#searchBbsId").val("");
		
		var url = "/bbs/bbsHome/bbsInfo.do";
		var data = {
			  crsCreCd: crsCreCd
			, bbsCd: '<c:out value="${vo.bbsCd}" />'
			, sysUseYn: "N"
			, sysDefaultYn: "Y"
		};
		
		$("#atclList").empty();
		
		$.ajax({
            url : url,
            type : "get",
            data: data,
        }).done(function(data) {
        	if (data.result > 0) {
        		var returnVO = data.returnVO || {};
				var bbsId = returnVO.bbsId;
				
				if(bbsId) {
					$("#searchBbsId").val(bbsId);
					
					listPaging(1);
				} else {
					setEmptyList();
				}
            } else {
             	alert(data.message);
             	setEmptyList();
            }
        }).fail(function() {
        	alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
        	setEmptyList()
        });
	}
	
	function setEmptyList() {
		$("#searchCrsCreCd").val("");
		$("#searchBbsId").val("");
		$("#atclListArea").empty().html(createEmptyHTML());
	}
	
	// 빈 내용 생성
	function createEmptyHTML() {
		var html = '';
		
		html += '<div class="flex-container">';
		html += '	<div class="cont-none">';
		html += '		<span><spring:message code="common.content.not_found" /></span>';
		html += '	</div>';
		html += '</div>';
		
		return html;
	}
	
	// 게시글 리스트 생성
	function createAtclListHTML(atclList, pageInfo) {
		if(atclList.length == 0) {
			return createEmptyHTML();
		} else {
			var html = '';
			
			atclList.forEach(function(v, i) {
				var lineNo = pageInfo.totalRecordCount - v.lineNo + 1;
				var regDttmFmt = (v.regDttm || "").length == 14 ? v.regDttm.substring(0, 4) + '.' + v.regDttm.substring(4, 6) + '.' + v.regDttm.substring(6, 8) : v.regDttm;
				var isLabelAtcl = v.noticeYn == "Y" || v.imptYn == "Y" || ((v.bbsCd == "QNA" || v.bbsCd == "SECRET") && v.answerYn == "N");
				var atclLabel = "";
				var atclLabelColor = "";
				
				if(v.bbsCd == "QNA") {
					atclLabel = "Q";
					atclLabelColor = "purple";
				} else if (v.bbsCd == "SECRET") {
					atclLabel = "1:1";
					atclLabelColor = "deepblue2";
				} else {
					if(v.noticeYn == "Y") {
						if(v.bbsCd == "PDS") {
							atclLabel = '<spring:message code="bbs.label.fix" />'; // 고정
							atclLabelColor = "brown";
						} else {
							atclLabel = '<spring:message code="bbs.label.notice" />'; // 공지
							atclLabelColor = "orange";
						}
					} else if(v.imptYn == "Y") {
						atclLabel = '<spring:message code="bbs.label.impt" />'; // 중요
						atclLabelColor = "red";
					}
				}
				
				html += '<tr>';
				html += '	<td class="tl">';
			if(isLabelAtcl) {
				html += '		<label class="ui label w50 small mr10 tc ' + atclLabelColor + '">' + atclLabel + '</label>';
			} else {
				html += '		<label class="w50 mr10 tc d-inline-block">' + lineNo + '</label>';
			}
				html += '		<a class="dip_cont" href="javascript:void(0)" onclick="selectAtcl(\'' + v.atclId + '\')">';
				html += '			<span class="fcBlue mr5">[' + v.bbsNm + ']</span>';
				html += 			v.atclTitle + (v.isNew == "Y" ? '<i class="text-new"><spring:message code="bbs.label.new_atcl" /></i>' : ''); // 새글
				html += '		</a>';
				html += '		<div class="sub-title-mobile flex mt5">';
				html += '			<ul class="list_verticalline opacity7 mra">';
				html += '				<li>' + regDttmFmt + '</li>';
				html += '				<li>' + v.regNm + '</li>';
				html += '			</ul>';
				html += '			<div>';
			if(v.atchUseYn == 'Y' && v.atchFileCnt > 0) {
				html += '				<small class="mr5"><i class="icon save outline"></i></small>';
			}
				html += '				<a href="javascript:void(0)" class="ui blue button small pt5 pb5" onclick="selectAtcl(\'' + v.atclId + '\')"><spring:message code="common.button.choice" /></a>'; // 선택
				html += '			</div>';
				html += '		</div>';
				html += '	</td>';
				html += '	<td class="sub-title tl">';
				html += '		<ul class="list_verticalline opacity7 mra">';
				html += '			<li>' + regDttmFmt + '</li>';
				html += '			<li>' + v.regNm + '</li>';
				html += '		</ul>';
				html += '	</td>';
			if(v.atchUseYn == 'Y' && v.atchFileCnt > 0) {
				html += '	<td class="sub-title tr"><i class="icon save outline f110"></i></td>';
			} else {
				html += '	<td class="sub-title tr"></td>';
			}
				html += '	<td class="sub-title p0">';
				html += '		<a href="javascript:void(0)" class="ui blue button small" onclick="selectAtcl(\'' + v.atclId + '\')"><spring:message code="common.button.choice" /></a>'; // 선택
				html += '	</td>';
				html += '</tr>';
			});
			
			var htmlData = '';
			htmlData += '	<table class="table type2" id="atclList">';
			htmlData += '		<caption>Content table</caption>';
			htmlData += '		<thead style="display:none">';
			htmlData += '			<tr>';
			htmlData += '				<th></th>';
			htmlData += '				<th></th>';
			htmlData += '				<th></th>';
			htmlData += '				<th></th>';
			htmlData += '			</tr>';
			htmlData += '		</thead>';
			htmlData += '		<tbody>';
			htmlData += 			html;
			htmlData += '		</tbody>';
			htmlData += '	</table>';
			htmlData += '	<div id="paging" class="paging"></div>';
			
			return htmlData;
		}
	}
	
	// 게시글 선택
	function selectAtcl(atclId) {
		if(typeof parent.prevAtclListModalCallback === "function") {
			parent.prevAtclListModalCallback(atclId);
		}
		parent.closeModal();
	}
</script>
</head>
<input type="hidden" id="searchCrsCreCd" 	value="" />
<input type="hidden" id="searchBbsId"		value="" />
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
	<div id="loading_page">
	    <p><i class="notched circle loading icon"></i></p>
	</div>
	
	<div id="wrap">
		<div class="option-content mb10">
			<div class="wmax tc fcRed">
				<spring:message code="bbs.label.prev_pop_guide1" />
			<c:choose>
				<c:when test="${vo.bbsCd eq 'NOTICE'}">
					<spring:message code="bbs.label.class_notice" /><!-- 강의공지 --><spring:message code="bbs.label.prev_pop_guide2" /><!-- 선택 시 가 복사 됩니다. -->
				</c:when>
				<c:when test="${vo.bbsCd eq 'PDS'}">
					<spring:message code="bbs.label.class_pds" /><!-- 강의자료 --><spring:message code="bbs.label.prev_pop_guide2" /><!-- 선택 시 가 복사 됩니다. -->
				</c:when>
				<c:otherwise>
					<spring:message code="bbs.label.system_notice" /><!-- 전체공지 --><spring:message code="bbs.label.prev_pop_guide2" /><!-- 선택 시 가 복사 됩니다. -->
				</c:otherwise>
			</c:choose>
			</div>
		</div>
		<!-- 검색조건 -->
		<div class="option-content mb10">
		<c:if test="${not empty vo.crsCreCd}">
			<!-- 학기선택 -->
			<select id="termCd" class="ui dropdown mr10 w200" onchange="changeTerm(this.value)">
	            <option value=""><spring:message code="bbs.label.select_term" /></option><!-- 학년도 학기 선택 -->
	        <c:forEach items="${termList}" var="row" varStatus="status">
	        	<option value="<c:out value="${row.termCd}" />" <c:if test="${status.index eq 0}">selected</c:if> ><c:out value="${row.termNm}" /></option>
	        </c:forEach>
	        </select>
	        <!-- 과목선택 -->
			<select id="crsCreCd" class="ui dropdown mr10 w250" onchange="changeCrsCreCd(this.value)">
	            <option value=""><spring:message code="bbs.label.select_class" /></option><!-- 과목 선택 -->
	        </select>
		</c:if>
			<!-- 검색 -->
			<div class="ui action input search-box">
				<input id="searchValue" type="text" placeholder="<spring:message code="bbs.common.placeholder" />" /><!-- 작성자/제목/키워드 -->
				<button class="ui icon button" type="button" onclick="listPaging(1)">
					<i class="search icon"></i>
				</button>
			</div>
			<div class="select_area">
				<select id="listScale" class="ui dropdown list-num" onchange="listPaging(1)">
		            <option value="10">10</option>
		            <option value="20">20</option>
		            <option value="50">50</option>
		            <option value="100">100</option>
		        </select>
			</div>
		</div>
		<!-- 검색조건 -->
	
		<div class="ui segment">
			<div class="body-content" id="atclListArea" style="min-height: 250px;">
				<table class="table type2">
					<caption>Content table</caption>
					<thead style="display:none;">
						<tr>
							<th></th>
							<th></th>
							<th></th>
							<th></th>
						</tr>
					</thead>
					<tbody>
						<!-- 
						<tr>
							<td class="tl">
								<label class="ui orange label w50 small mr10 tc">고정</label>
								<p class="dip_cont">
									<span class="fcBlue mr5">[강의공지]</span>사이트 이용약관 변경1
								</p>
								<div class="sub-title-mobile flex mt5">
									<small class="post-info flex_1">
										<em>2022.07.29</em>
										<em>홍교수</em>													
									</small>
									<div>
										<small class="mr5"><i class="icon save outline"></i></small>
										<a href="javascript:void(0)" class="ui blue button small pt5 pb5">선택</a>
									</div>
								</div>
							</td>
							<td class="sub-title tl">
								<div class="post-info">
									<em>2022.07.29</em>
									<em>홍교수</em>
								</div>
							</td>
							<td class="sub-title tr"><i class="icon save outline f110"></i></td>
							<td class="sub-title">
								<a href="javascript:void(0)" class="ui blue button small">선택</a>
							</td>
						</tr>
						<tr>
							<td class="tl">
								<label class="w50 mr10 tc d-inline-block">90</label>
								<span class="dip_cont">
									<span class="fcBlue mr5">[강의공지]</span>[2022.하계] 하계계절학기 폐강과목 없음(모든 교과목 개설 확정)
								</span>
								<div class="sub-title-mobile flex mt5">
									<small class="post-info flex_1">
										<em>2022.07.29</em>
										<em>홍교수</em>													
									</small>
									<div>
										<small class="mr5"><i class="icon save outline"></i></small>
										<a href="javascript:void(0)" class="ui blue button small pt5 pb5">선택</a>
									</div>
								</div>
							</td>
							<td class="sub-title tl">
								<div class="post-info">
									<em>2022.07.29</em>
									<em>홍교수</em>
								</div>
							</td>
							<td class="sub-title tr"><i class="icon save outline f110"></i></td>
							<td class="sub-title">
								<a href="javascript:void(0)" class="ui blue button small">선택</a>
							</td>
						</tr>
						 -->
					</tbody>
				</table>
			</div>
		</div>
		<div class="bottom-content">
			<button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message code="common.button.close" /><!-- 닫기 --></button>
		</div>
	</div>
	<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>