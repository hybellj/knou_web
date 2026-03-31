<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

<link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2" />
<!-- 게시판 공통 -->
<%@ include file="/WEB-INF/jsp/bbs/common/bbs_common_inc.jsp" %>
<script type="text/javascript">

	$(document).ready(function() {
		$("#searchValue").on("keydown", function(e) {
			if(e.keyCode == 13) {
				listPaging(1);
			}
		});

		listPaging(1);
	});

	// 게시글 조회
	function listPaging(pageIndex) {
		var url = "/bbs/bbsMgr/bbsMngListView2.do";
		var data = {
			  pageIndex		: pageIndex
			, listScale		: $("#listScale").val()
			, searchValue 	: $("#searchValue").val()
		};

		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
        		var returnList = data.returnList || [];
        		var pageInfo = data.pageInfo;

        		var html = createInfoListHTML(returnList, pageInfo);

        		$("#infoListArea").empty().html(html);
    			$("#infoList").footable();
    			$("#infoList").find(".ui.checkbox").checkbox();

    			var params = {
   					totalCount : data.pageInfo.totalRecordCount,
   					listScale : data.pageInfo.recordCountPerPage,
   					currentPageNo : data.pageInfo.currentPageNo,
   					eventName : "listPaging"
   				};

   				gfn_renderPaging(params);
            } else {
             	alert(data.message);
            }
		}, function(xhr, status, error) {
			alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
		});
	}

	function createInfoListHTML(infoList, pageInfo) {
		var html = '';
		var infoListHtml = '';

		infoList.forEach(function(v, i) {
			var lineNo = pageInfo.totalRecordCount - v.lineNo + 1;
			var regDttmFmt = (v.regDttm || "").length == 14 ? v.regDttm.substring(0, 4) + '.' + v.regDttm.substring(4, 6) + '.' + v.regDttm.substring(6, 8) : v.regDttm;
			var useYnChecked = v.useYn == "Y" ? "checked" : "";
			var useYnDisabled = v.sysDefaultYn == "Y" ? "disabled" : "";
			var bbsOption = [];

			if(v.notiUseYn == 'Y') bbsOption.push('<spring:message code="bbs.label.notice" />'); 	// 공지
			if(v.ansrUseYn == 'Y') bbsOption.push('<spring:message code="bbs.label.answer_atcl" />'); 	// 답글
			if(v.atchUseYn == 'Y') bbsOption.push('<spring:message code="bbs.label.atch_file" />'); // 첨부파일

			var queryInfo = {};

			queryInfo.bbsId = v.bbsId;

			var queryStr = new URLSearchParams(queryInfo).toString();
			var linkUrl = "/bbs/bbsMgr/atclList.do";

			infoListHtml += '<tr>';
			infoListHtml += '	<td class="tc">' + lineNo + '</td>';
			infoListHtml += '	<td><a href="javascript:void(0)" class="fcBlue" onclick="moveEditInfo(\'' + v.bbsId + '\')">' + v.bbsNm + '</a></td>';
			infoListHtml += '	<td class="tc">' + v.bbsTypeNm + '</td>';
			infoListHtml += '	<td class="tc">' + bbsOption.join(", ") + '</td>';
			infoListHtml += '	<td class="tc">' + (v.atchFileCnt || 0) + '</td>';
			infoListHtml += '	<td class="tc">' + (v.atchFileSizeLimit || 0) + 'MB</td>';
			infoListHtml += '	<td class="tc">' + v.atclCnt + '</td>';
			infoListHtml += '	<td class="tc">';
			infoListHtml += '		<div class="ui toggle checkbox">';
			infoListHtml += '			<input type="checkbox" class="hidden" ' + useYnChecked + ' ' + useYnDisabled;
		if(v.sysDefaultYn != "Y") {
			infoListHtml += '				onchange="changeUseYn(\'' + v.bbsId + '\', this)"';
		}
			infoListHtml += '			>';
			infoListHtml += '			<label></label>';
			infoListHtml += '		</div>';
			infoListHtml += '	</td>';
			infoListHtml += '	<td class="tc">' + regDttmFmt + '</td>';
			infoListHtml += '	<td class="tc">';
			infoListHtml += '		<a href="javascript:void(0)" onclick="viewBbs(\'' + linkUrl +  '\', \'' + queryStr + '\')" class="ui basic button small">';
			infoListHtml += '			<spring:message code="bbs.label.view_bbs" />'; // 게시판보기
			infoListHtml += '		</a>';
			infoListHtml += '	</td>';
			infoListHtml += '</tr>';
		});

		html += '<table class="table type2" id="infoList">';
		html += '   <caption>Content table</caption>';
		html += '	<thead>';
		html += '		<tr>';
		html += '			<th class="tc"><spring:message code="common.number.no" /></th>';								// NO
		html += '			<th class="tc"><spring:message code="bbs.label.bbs_name" /></th>'; 								// 게시판명
		html += '			<th data-breakpoints="xs" class="tc"><spring:message code="bbs.label.type" /></th>'; 		// 구분
		html += '			<th data-breakpoints="xs" class="tc"><spring:message code="bbs.label.option" /></th>'; 	// 옵션
		html += '			<th data-breakpoints="xs" class="tc"><spring:message code="bbs.label.file_num" /></th>'; 	// 파일수
		html += '			<th data-breakpoints="xs" class="tc"><spring:message code="bbs.label.size_limit" /></th>'; // 용량제한
		html += '			<th data-breakpoints="xs" class="tc"><spring:message code="bbs.label.atcl_cnt" /></th>'; 	// 게시글수
		html += '			<th data-breakpoints="xs" class="tc"><spring:message code="bbs.label.use_yn" /></th>'; 	// 사용여부
		html += '			<th data-breakpoints="xs" class="tc"><spring:message code="bbs.label.reg_date" /></th>'; 	// 등록일자
		html += '			<th data-breakpoints="xs sm" class="tc"><spring:message code="bbs.label.manage" /></th>'; 	// 관리
		html += '		</tr>';
		html += '	</thead>';
		html += '	<tbody>';
		html += 		infoListHtml;
		html += '	</tbody>';
		html += '</table>';
		html += '<div id="paging" class="paging"></div>';

		return html;
	}

	// 사용여부 변경
	function changeUseYn(bbsId, el) {
		var url = "/bbs/bbsMgr/editUseYn.do";
		var data = {
			  bbsId: bbsId
			, useYn: el.checked ? "Y" : "N"
		};

		ajaxCall(url, data, function(data) {
			if(data.result > 0) {
        	} else {
        		alert(data.message);
        		el.checked = el.checked ? false : true;
        	}
		}, function(xhr, status, error) {
			alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
        	el.checked = el.checked ? false : true;
		});
	}

	// 쓰기 페이지 이동
	function moveWriteInfo() {
		var url = "/bbs/bbsMgr/Form/infoWrite.do";
		var form = $("<form></form>");
		form.attr("method", "POST");
		form.attr("name", "bbsForm");
		form.attr("action", url);
		form.appendTo("body");
		form.submit();
	}

	// 수정 페이지 이동
	function moveEditInfo(bbsId) {
		var url = "/bbs/bbsMgr/Form/infoEdit.do";
		var form = $("<form></form>");
		form.attr("method", "POST");
		form.attr("name", "bbsForm");
		form.attr("action", url);
		form.append($('<input/>', {type: 'hidden', name: 'bbsId', 	 value: bbsId}));
		form.appendTo("body");
		form.submit();
	}

	// 게시판 보기
	function viewBbs(url, queryStr) {
		var params = new URLSearchParams(queryStr);
		var form = $("<form></form>");
		form.attr("method", "POST");
		form.attr("name", "bbsForm");
		form.attr("target", "_blank");
		form.attr("action", url);

		params.forEach(function(value, key) {
			form.append($('<input/>', {type: 'hidden', name: key, value: value}));
		})

		form.appendTo("body");
		form.submit();
	}
</script>
<body>
	<div id="wrap" class="pusher">
		<!-- class_top 인클루드  -->
		<%@ include file="/WEB-INF/jsp/common/admin/admin_header.jsp"%>

		<div id="container">
			<%@ include file="/WEB-INF/jsp/common/admin/admin_lnb.jsp"%>

			<div class="content stu_section">

				<!-- admin_location -->
                <%-- <%@ include file="/WEB-INF/jsp/common/admin/admin_location.jsp" %> --%>
                <!-- //admin_location -->

		        <div class="ui form">
                	<div class="layout2">

                	    <div id="info-item-box">
                            <h2 class="page-title flex-item flex-wrap gap4 columngap16">
                                <spring:message code="bbs.label.bbs_manage" /><!-- 게시판 관리 -->
                                <div class="ui breadcrumb small">
                                    <small class="section"><spring:message code="bbs.label.list" /><!-- 목록 --></small>
                                </div>
                            </h2>
                            <div class="button-area">
                                <a href="javascript:void(0)" onclick="moveWriteInfo()" class="ui basic button"><spring:message code="bbs.button.write_bbs" /><!-- 게시판 추가 --></a>
                            </div>
                        </div>


		                <!-- 영역1 -->
                        <div class="row">
                            <div class="col">
                            	<!-- 검색조건 -->
								<div class="option-content mb10">
									<!-- 검색 -->
									<div class="ui action input search-box">
										<input id="searchValue" type="text" placeholder="<spring:message code="common.search.keyword" />" /><!-- 검색어 -->
										<button class="ui icon button" type="button" onclick="listPaging(1)">
											<i class="search icon"></i>
										</button>
									</div>

									<div class="select_area">
										<select class="ui dropdown list-num" id="listScale" onchange="listPaging(1)">
								            <option value="10">10</option>
								            <option value="20">20</option>
								            <option value="50">50</option>
								            <option value="100">100</option>
								        </select>
									</div>
								</div>

								<!-- 게시글 리스트 -->
								<div id="infoListArea">
								</div>

                            </div><!-- //col -->
                   		</div><!-- //row -->

                	</div><!-- //layout2 -->
	        	</div><!-- //ui form -->
			</div><!-- //content stu_section -->
		</div><!-- //container -->

		<%@ include file="/WEB-INF/jsp/common/frontFooter.jsp"%>

	</div><!-- //wrap -->

</body>
</html>