<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>

<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
			<jsp:param name="style" value="${
				templateUrl eq 'bbsHome' ? 'dashboard'
				: templateUrl eq 'bbsLect' ? 'classroom'
				: templateUrl eq 'bbsMgr' ? 'classroom' : ''}"/>
			<jsp:param name="module" value="table"/>
	</jsp:include>

	<jsp:include page="/WEB-INF/jsp/bbs/common/bbs_common_inc.jsp"/>

	<script type="text/javascript">
		var ORG_ID 		    = '<c:out value="${bbsVO.orgId}" />';
		var SBJCT_ID 		= '<c:out value="${bbsVO.sbjctId}" />';
		var SEARCH_VALUE	= '<c:out value="${param.searchValue}" />';
		var PAGE_INDEX		= '<c:out value="${bbsVO.pageIndex}" />';
		var TAB 			= '<c:out value="${param.tab}" />';
		var TEMPLATE_URL 	= '<c:out value="${templateUrl}" />';
		var BBS_IDS;

		// 사용값
		var LIST_SCALE		= '<c:out value="${bbsVO.listScale}" />';
		var EPARAM			= '<c:out value="${encParams}" />';

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
			PAGE_INDEX = pageIndex;
			SEARCH_VALUE = $("#searchValue").val();

			var extData = {
					orgId           : ORG_ID
					, sbjctId       : SBJCT_ID
					, pageIndex		: pageIndex
					, listScale		: LIST_SCALE
					, searchValue 	: SEARCH_VALUE
			};

			var url = "/bbs/" + TEMPLATE_URL + "/bbsMngList.do";
			var param = {
				  encParams		: EPARAM
				, addParams		: UiComm.makeEncParams(extData)
			};

			UiComm.showLoading(true);

			ajaxCall(url, param, function(data) {
				if (data.encParams != null && data.encParams != '') {
					EPARAM = data.encParams;
				}

				if (data.result > 0) {
	        		let returnList = data.returnList || [];

	        		// 테이블 데이터 설정
	        		let dataList = createAtclListHTML(returnList, data.pageInfo);
	        		atclListTable.clearData();
	        		atclListTable.replaceData(dataList);
	        		atclListTable.setPageInfo(data.pageInfo);
	            } else {
	            	UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error"); // 에러 메세지
	            }
			}, function(xhr, status, error) {
				UiComm.showMessage("<spring:message code='fail.common.msg'/>","error"); // 에러가 발생했습니다!
			}, true);
		}

		// 게시판 추가
		function moveWriteAtcl() {
			let extData = {
				gubun   : 'add'
				, sbjctId : SBJCT_ID
			};
			document.location.href = "/bbs/" + TEMPLATE_URL + "/bbsMngAdd.do?addParams="+UiComm.makeEncParams(extData);
		}

		// 게시판 보기(수정)
		function viewAtcl(orgId, bbsId, bbsTycd) {
			let extData = {
				gubun     : 'edit'
				, bbsId	  : bbsId
				, bbsTycd : bbsTycd
			};

			document.location.href = "/bbs/" + TEMPLATE_URL + "/bbsMngView.do?encParams="+EPARAM+"&addParams="+UiComm.makeEncParams(extData);
		}

		// 게시판으로 이동
		function moveAtclBbs(bbsId, bbsTycd, bbsAddyn) {
			let extData = {
				bbsAddyn  : 'Y'
				, orgId   : ORG_ID
				, sbjctId : SBJCT_ID
				, bbsTycd : bbsTycd
			};

			if(bbsAddyn == 'Y') {
				document.location.href = "/bbs/" + TEMPLATE_URL + "/bbsAtclListView.do?bbsId="+bbsId+"&encParams="+EPARAM+"&addParams="+UiComm.makeEncParams(extData);
			} else {
				document.location.href = "/bbs/" + TEMPLATE_URL + "/bbsAtclListView.do?bbsTycd="+bbsTycd+"&encParams="+EPARAM+"&addParams="+UiComm.makeEncParams(extData);
			}
		}

		// 게시글 리스트 생성
		function createAtclListHTML(atclList, pageInfo) {
			let dataList = [];

			if(atclList.length == 0) {
				return dataList;
			}

			atclList.forEach(function(v, i) {
				var useynHtml = "";

				if(v.bbsAddyn == 'Y') {
					useynHtml = '<input type="checkbox" value="Y" class="switch small" onchange="modifyBbsUseyn(this, \'' + v.bbsId + '\', \'' + v.bbsAddyn + '\', \'' + v.bbsTycd + '\', \'' + v.sbjctId + '\')"';
		            useynHtml += (v.useyn === 'Y') ? ' checked="checked">' : '>';
				} else {
					useynHtml = '<span>Y</span>';
				}

	         	// 게시판 제목
	            var bbsNm = v.bbsNm.replaceAll("<", "&lt").replaceAll(">", "&gt");
		        var title = "";
	            if(v.bbsAddyn == 'Y') {
	            	var linkUrl = 'javascript:viewAtcl(\'' + v.orgId + '\', \'' + v.bbsId + '\', \'' + v.bbsTycd + '\')';
		            title = '<a href="' + linkUrl + '" title="' + bbsNm + '" class="header header-icon link">' + bbsNm + '</a>';
	            } else {
	            	title = bbsNm;
	            }

				var mngHtml = "<a href=\"javascript:moveAtclBbs('" + v.bbsId + "', '" + v.bbsTycd + "', '" + v.bbsAddyn + "')\" class=\"btn basic small\"><spring:message code='bbs.button.move_bbs'/></a>";

				dataList.push({
					no: v.lineNo,
					bbsNm: title,
					bbsGbn: v.bbsAddyn == 'Y' ? "추가" : "고정",
					bbsOptnNm: v.bbsOptnNm,
					atflMaxCnt: v.atflMaxCnt,
					atflMaxsz: v.atflMaxsz + "MB",
					atclCnt: v.atclCnt,
					useyn: useynHtml,
					regDttm: v.regDttm,
					mng: mngHtml
				});
			});

			return dataList;
		}

		// 게시판 사용여부 수정
        function modifyBbsUseyn(el, bbsId, bbsAddyn, bbsTycd, sbjctId) {
            var $el = $(el);
            var isChecked = $el.is(":checked");

            // 고정 게시판은 사용여부 수정 대상 아님
            if(bbsAddyn != 'Y') {
            	return;
            }

            $el.prop("disabled", true);
            var param = {
                bbsId: bbsId
                , bbsTycd : bbsTycd
                , sbjctId : sbjctId
                , useyn : isChecked ? 'Y' : 'N'
            };

            var url = "/bbs/" + TEMPLATE_URL + "/bbsUseynModify.do";
            ajaxCall(url, param, function (data) {
                $el.prop("disabled", false);
                if (data.result <= 0) {
                    $el.prop("checked", !isChecked); // 실패 시 원복
                    UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error"); // 에러 메세지
                }
            }, function(xhr, status, error) {
                $el.prop("disabled", false);
                $el.prop("checked", !isChecked); // 실패 시 원복
                UiComm.showMessage("<spring:message code='fail.common.msg'/>","error"); // 에러 메세지
            });
        }

		// list scale 변경
		function changeListScale(scale) {
			LIST_SCALE = scale;
			listPaging(1);
		}
	</script>
</head>

<body class="class ${uiex:getTheme()} "><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">

        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>
        <!-- //common header -->

        <!-- classroom -->
        <main class="common">
			<!-- gnb -->
			<jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp"/>
			<!-- //gnb -->

			<!-- content -->
			<div id="content" class="content-wrap common">
				<!-- class_sub_top -->
				<jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>
				<!-- //class_sub_top -->

				<!-- class_sub -->
				<div class="class_sub">
					<!-- class_info -->
					<jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>
					<!-- //class_info -->

					<div class="dashboard_sub">

	                    <div class="sub-content">
	                        <div class="page-info">
	                            <h4 class="sub-title">게시판 관리</h4>
	                        </div>

	                        <!-- search typeA -->
	                        <div class="search-typeA">

	                            <div class="item">
	                                <span class="item_tit"><label for="searchValue"><spring:message code='common.search.keyword'/></label></span><%-- 검색어 --%>

	                                <div class="itemList">
	                                    <input class="form-control wide" type="text" name="" id="searchValue" value="${param.searchValue}" placeholder="<spring:message code='bbs.common.placeholder'/>"><%-- 작성자/제목/키워드 --%>
	                                </div>
	                            </div>
	                            <div class="button-area">
	                                <button type="button" class="btn search" onclick="listPaging(1)"><spring:message code='button.search'/></button><%-- 검색 --%>
	                            </div>
	                        </div>

							<div id="atclListArea">
								<div class="board_top">
		                            <h3 class="board-title">게시판 관리</h3>
		                            <div class="right-area">
		                                <button type="button" class="btn type1" style="white-space: nowrap;" onclick="moveWriteAtcl()"><spring:message code="bbs.label.bbs_add" /></button><%-- 게시판 추가 --%>

										<%-- 리스트/카드 선택 버튼 --%>
										<span class="list-card-button"></span>

										<%-- 목록 스케일 선택 --%>
										<uiex:listScale func="changeListScale" value="${bbsVO.listScale}" />
		                            </div>
		                        </div>

								<%-- 게시글 리스트 --%>
								<div id="atclList"></div>

								<%-- 게시글 리스트 카드 폼 --%>
								<div id="atclList_cardForm" style="display:none">
									<div class="card-header">
										#[label]
										<div class="card-title">
											#[atclTtl]
										</div>
									</div>

									<div class="card-body">
										<div class="desc">
											<p><label class="label-title"><spring:message code='bbs.label.reg_date'/></label><strong>#[regDttm]</strong></p>
											<p><label class="label-title"><spring:message code='bbs.label.reg_user'/></label><strong>#[rgtrnm]</strong></p>
										</div>
										<div class="etc">
											<p><label class="label-title"><spring:message code='bbs.label.attach'/></label><strong>#[attach]</strong></p>
											<p><label class="label-title"><spring:message code='bbs.label.view'/></label><strong>#[inqCnt]</strong></p>
											<p><label class="label-title"><spring:message code='bbs.label.comment'/></label><strong>#[cmntCnt]</strong></p>
										</div>
									</div>
								</div>

								<script>
								// 게시판 관리 리스트 테이블
								let atclListTable = UiTable("atclList", {
									lang: "ko",
									pageFunc: listPaging,
									columns: [
										{title:"No", 											field:"no",			    headerHozAlign:"center", hozAlign:"center", width:60,	minWidth:60},	// No
										{title:"<spring:message code='bbs.label.bbs_name'/>",   field:"bbsNm",	        headerHozAlign:"center", hozAlign:"left",	minWidth:100,	widthGrow:1,	headerSort:true},	// 게시판명
										{title:"<spring:message code='bbs.label.type'/>",       field:"bbsGbn",	        headerHozAlign:"center", hozAlign:"center",	width:120,	minWidth:60, 	headerSort:true},	// 구분
										{title:"<spring:message code='bbs.label.option'/>",     field:"bbsOptnNm",	    headerHozAlign:"center", hozAlign:"center",	width:120,	minWidth:60, 	headerSort:true},	// 옵션
										{title:"<spring:message code='bbs.label.file_num'/>",   field:"atflMaxCnt",	    headerHozAlign:"center", hozAlign:"center",	width:120,	minWidth:60, 	headerSort:true},	// 파일수
										{title:"<spring:message code='bbs.label.size_limit'/>", field:"atflMaxsz",	    headerHozAlign:"center", hozAlign:"center",	width:120,	minWidth:60, 	headerSort:true},	// 용량제한
										{title:"<spring:message code='bbs.label.atcl_cnt'/>",   field:"atclCnt",	    headerHozAlign:"center", hozAlign:"center",	width:120,	minWidth:60, 	headerSort:true},	// 게시글수
										{title:"<spring:message code='bbs.label.use_yn'/>",     field:"useyn",	    	headerHozAlign:"center", hozAlign:"center",	width:120,	minWidth:60},	// 사용여부
										{title:"<spring:message code='bbs.label.reg_date'/>", 	field:"regDttm", 	    headerHozAlign:"center", hozAlign:"center", width:120, 	minWidth:100,	headerSort:true,	formatter:"date"},	// 등록일자
										{title:"<spring:message code='bbs.label.manage'/>", 	field:"mng", 	        headerHozAlign:"center", hozAlign:"center", width:120,	minWidth:100}	// 관리
									]
								});

								function checkSelect() {
									// 선택된값 array로 가져온다.
									let data = atclListTable.getSelectedData("valAtclId"); // "valAtclId" 키로 설정된 값
									alert(data);
								}

								function checkRowSelect(data) {
									let value = data["valAtclId"]; // "valAtclId" 키로 설정된 값
									alert(value);
								}
								</script>
							</div>
	                    </div>
                	</div>
				</div>
				<!-- //class_sub -->

			</div>
			<!-- //content -->
        </main>
        <!-- //main-->
    </div>
    <!-- //div main -->
</body>
</html>
