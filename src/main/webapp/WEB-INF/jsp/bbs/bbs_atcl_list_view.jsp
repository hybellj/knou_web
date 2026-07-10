<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="${
			templateUrl eq 'bbsHome' ? 'dashboard'
			: templateUrl eq 'bbsLect' ? 'classroom'
			: templateUrl eq 'bbsMgr' ? 'admin' : ''}"/>
		<jsp:param name="module" value="table"/>
	</jsp:include>

	<!-- 게시판 공통 -->
	<jsp:include page="/WEB-INF/jsp/bbs/common/bbs_common_inc.jsp"/>

	<script type="text/javascript">
		var ORG_ID 			= '<c:out value="${bbsVO.orgId}" />';
		var BBS_ID 			= '<c:out value="${bbsVO.bbsId}" />';
		var BBS_TYCD		= '<c:out value="${bbsVO.bbsTycd}" />';
		var BBS_REF_TYCD	= '<c:out value="${bbsVO.bbsRefTycd}" />';
		var SEARCH_VALUE	= '<c:out value="${param.searchValue}" />';
		var PAGE_INDEX		= '<c:out value="${bbsVO.pageIndex}" />';
		var TAB 			= '<c:out value="${param.tab}" />';
		var TEMPLATE_URL 	= '<c:out value="${templateUrl}" />';
		var BBS_IDS;
		var LIST_SCALE		= '<c:out value="${bbsVO.listScale}" />';
		var EPARAM			= '<c:out value="${encParams}" />';
		var ATCL_LV 		= 1;

		$(document).ready(function() {
			$("#searchValue").on("keydown", function(e) {
				if(e.keyCode == 13) {
					listPaging(1);
				}
			});

			if(BBS_ID == "TEAM") {
				// 팀 게시판 ID ',' 구분자
				BBS_IDS = '<c:out value="${teamBbsIds}" />';
			} else if(!bbsCommon.isStudent() && BBS_ID == "ALARM") {
				BBS_IDS = '<c:out value="${alarmBbsIds}" />';
			} else {
				BBS_IDS = BBS_ID;
			}

			if(!PAGE_INDEX) {
				PAGE_INDEX = 1;
			}

			listPaging(PAGE_INDEX);


			// 검색 조건 변경 시에는 하위 드롭다운만 갱신하고, 목록 조회는 검색 버튼에서 수행
	        $("#srchYear").on("change", function () {
				console.log("y")
	            reloadYearFilters(false);
	        });

	        $("#srchTerm").on("change", function () {
	        	console.log("t")
	            loadSubjectOptions(false);
	        });

	        $("#srchOrg").on("change", function () {
	        	console.log("o")
	            loadSubjectOptions(false);
	        });
		});

		// 팀분류 Select 변경
		function changeTeamCtgr(teamCtgrCd) {
			$("#teamCd").empty();
			$("#teamCd").off("change");

			if(teamCtgrCd == "all") {
				$("#teamCd").dropdown("clear");
				BBS_IDS = '<c:out value="${teamBbsIds}" />';
				listPaging(1);
				return;
			}

			var url = "/bbs/bbsLect/listTeamBbsId.do";
			var data = {
				  crsCreCd: CRS_CRE_CD
				, teamCtgrCd: teamCtgrCd
			};

			ajaxCall(url, data, function(data) {
				if(data.result > 0) {
					var returnList = data.returnList || [];
					var html = '';
					var studentYn = bbsCommon.isStudent();
					var firstText = "";

					var teamCtgrBbsIdList = [];

					returnList.forEach(function(v, i) {
						if(v.bbsId) {
							teamCtgrBbsIdList.push(v.bbsId);
						}
	        		});

					returnList.forEach(function(v, i) {
						if(i == 0 && studentYn != "Y") {
							html += '<option value="all" data-bbs-id="' + teamCtgrBbsIdList.join(",") + '"><spring:message code="common.all" /></option>';
						}

						if(i == 0) {
							firstText = v.teamNm;
						}

	        			html += '<option value="' + v.teamCd + '" data-bbs-id="' + (v.bbsId || '') + '">' + v.teamNm + '</option>';
	        		});

					$("#teamCd").html(html);
	        		$("#teamCd").dropdown("clear");
	        		$("#teamCd").on("change", function() {
	        			listPaging(1);
	       			});

	        		if(studentYn == "Y") {
	        			$("#teamCd").dropdown("set text", firstText);
	        		}

	        		if(returnList.length == 0) {
	            		$("#atclListArea").empty().html(createEmptyListHtml());
	        			$("#atclList").footable();
	        		} else {
	        			BBS_IDS = teamCtgrBbsIdList.join(",");
	        			listPaging(1);
	        		}
	        	}
			}, function(xhr, status, error) {
				alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
			});
		}

		// 게시글 조회
		function listPaging(pageIndex) {
			var currentBbsTycd = '<c:out value="${param.bbsTycd}" />';
			if(!currentBbsTycd) {
				currentBbsTycd = BBS_TYCD; // 파라미터 없으면 기본값 사용
			}

			var orgId = $("#srchOrg").val();

			if(orgId == 'SYSTEM_DEFAULT') {
				bbsTycd = 'SYS_NTC';
			} else {
				bbsTycd = currentBbsTycd;
			}

			var extData = {
					orgId           : orgId
					, bbsId         : BBS_ID
					, bbsTycd       : bbsTycd
					, bbsRefTycd    : BBS_REF_TYCD
					, atclLv        : ATCL_LV
					, searchSdttm   : $("#searchSdttm").val()
					, searchEdttm   : $("#searchEdttm").val()
					, searchValue 	: $("#searchValue").val()
					, pageIndex		: pageIndex
					, listScale		: LIST_SCALE
			};

			var url = "/bbs/" + TEMPLATE_URL + "/bbsAtclListAjax.do";
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

		// 글쓰기
		function moveWriteAtcl() {
			document.location.href = "/bbs/" + TEMPLATE_URL + "/bbsAtclWrite.do?encParams="+EPARAM;
		}

		// 조회자 목록 모달
		function viewerListModal(crsCreCd, atclId) {
			$("#viewerListForm > input[name='crsCreCd']").val(crsCreCd);
			$("#viewerListForm > input[name='atclId']").val(atclId);
			$("#viewerListForm").attr("target", "viewerListModalIfm");
	        $("#viewerListForm").attr("action", "/bbs/bbsLect/popup/viewerList.do");
	        $("#viewerListForm").submit();
	        $('#viewerListModal').modal('show');

	        $("#viewerListForm > input[name='crsCreCd']").val("");
			$("#viewerListForm > input[name='atclId']").val("");
		}

		// 게시글 리스트 생성
		function createAtclListHTML(atclList, pageInfo) {
			let dataList = [];

			if(atclList.length == 0) {
				return dataList;
			}

			var bbsTycd = '<c:out value="${bbsVO.bbsTycd}" />';

			atclList.forEach(function(v, i) {
				var lineNo = pageInfo.totalRecordCount - v.lineNo + 1;
				var isLabelAtcl = v.optnCd == "FIX" || v.optnCd == "IMPT";
				var atclLabel = "";

				if(v.optnCd == "FIX") {
					atclLabel = '<spring:message code="bbs.label.fix" />'; // 고정
				} else if(v.optnCd == "IMPT") {
					atclLabel = '<spring:message code="bbs.label.impt" />'; // 중요
				}

				// 문의/상담 게시판 답변, 미답변 아이콘 추가
				var ansIcon = "";
				if(bbsTycd == "QNA" || bbsTycd == "1ON1") {
					if(v.answerYn == "Y") {
						ansIcon = '<small class="ml10 f080"><span style="background:#21BA45;color:#fff;padding:0 5px;"><spring:message code="bbs.label.answer" /></span></small>'; // 답변
					} else {
						ansIcon = '<small class="ml10 f080"><span style="background:#F2711C;color:#fff;padding:0 5px;"><spring:message code="bbs.label.no_answer" /></span></small>'; // 미답변
					}
				}

				var atclTtlText = v.atclTtl.replaceAll("<", "&lt").replaceAll(">", "&gt");
				var isNewIcon = (v.isNew == "Y" && v.answerYn != "Y" && v.viewYn != "Y")
				    ? ' <i class="xi-new icon" aria-hidden="true"></i>' : '';

				var atclTtl = '<a href="javascript:void(0);" onclick="viewAtcl(\'' + v.atclId + '\')" style="color:#1a6fba; text-decoration:none;">'
				    + atclTtlText + isNewIcon + ansIcon
				    + '</a>';

				let col0 = lineNo;
				let colLabel = "";
				if(isLabelAtcl) {
					colLabel = (v.optnCd == 'FIX')
						? '	<label class="label s_c01">' + atclLabel + '</label>'
						: '	<label class="label s_c02">' + atclLabel + '</label>';
					col0 = colLabel;
				}

				var systemDefaultNm = '<spring:message code="bbs.label.notice_atcl3" />';

				dataList.push({
					no: col0,
					orgnm: (v.orgId === 'SYSTEM_DEFAULT') ? systemDefaultNm : v.orgnm,
					sbjctnm: v.sbjctnm,
					dvclasNo: v.dvclasNo,
					atclTtl: atclTtl,
					isNew: (v.isNew == "Y" && v.answerYn != "Y" && v.viewYn != "Y") ? ' <i class="xi-new icon" aria-hidden="true"></i>' : '',
					ansIcon: ansIcon,
					regDttm: v.regDttm,
					rgtrnm: v.rgtrnm,
					attach: v.fileCnt > 0 ? '<i class="xi-paperclip"></i>' : '',
					inqCnt: v.inqCnt,
					cmntCnt: v.cmntCnt,
					valAtclId: v.atclId,
					label: colLabel
				});
			});

			return dataList;
		}

		// 게시글 보기
		function viewAtcl(atclId, rgtrId) {
			UiComm.showLoading(true);
			let extData = {
				atclId	     : atclId
				, bbsTycd    : BBS_TYCD
				, bbsRefTycd : BBS_REF_TYCD
			};

			document.location.href = "/bbs/" + TEMPLATE_URL + "/bbsAtclView.do?encParams="+EPARAM+"&addParams="+UiComm.makeEncParams(extData);
		}

		// list scale 변경
		function changeListScale(scale) {
			LIST_SCALE = scale;
			listPaging(1);
		}

        /* =====================================================
        연도 변경 시 기관/학기/학과/과목 필터 재구성
        ===================================================== */
	    function reloadYearFilters(triggerSearch) {
	        loadOrgOptions(function () {
	            loadTermOptions(function () {
	                loadSubjectOptions(triggerSearch);
	            });
	        });
	    }

	    function loadOrgOptions(callback) {
	        var currentValue = $("#srchOrg").val() || "";

	        ajaxCall("/bbs/" + TEMPLATE_URL + "/selectBbsOrgList.do", {
	                searchYr: $("#srchYear").val() || ""
	            },
	            function (data) {
	                var list = (data && data.returnList) ? data.returnList : [];
	                var $org = $("#srchOrg");

	                $org.empty();
	                $org.append('<option value=""><spring:message code="cls.label.org"/><%-- 기관 --%></option>');

	                list.forEach(function (item) {
	                    var value = item.orgId || "";
	                    var label = item.orgnm || "";

	                    if (!value || !label) {
	                        return;
	                    }

	                    $org.append(
	                        '<option value="' + UiComm.escapeHtml(String(value)) + '">'
	                        + UiComm.escapeHtml(String(label))
	                        + '</option>'
	                    );
	                });

	                if (currentValue && $org.find("option[value='" + currentValue + "']").length > 0) {
	                    $org.val(currentValue);
	                } else {
	                    $org.val("");
	                }

	                if (callback) {
	                    callback();
	                }
	            },
	            function () {
	                if (callback) {
	                    callback();
	                }
	            },
	            false
	        );
	    }

	    function loadTermOptions(callback) {
	        var currentValue = $("#srchTerm").val() || "";

	        ajaxCall("/bbs/" + TEMPLATE_URL + "/selectBbsTermList.do", {
	                searchYr: $("#srchYear").val() || ""
	            },
	            function (data) {
	                var list = (data && data.returnList) ? data.returnList : [];
	                var $term = $("#srchTerm");

	                $term.empty();
	                $term.append('<option value=""><spring:message code="cls.label.open.term"/><%-- 개설학기 --%></option>');

	                list.forEach(function (item) {
	                    var value = item.dgrsSmstrChrt || "";
	                    var label = item.smstrChrtnm || "";

	                    if (!value || !label) {
	                        return;
	                    }

	                    $term.append(
	                        '<option value="' + UiComm.escapeHtml(String(value)) + '">'
	                        + UiComm.escapeHtml(String(label))
	                        + '</option>'
	                    );
	                });

	                if (currentValue && $term.find("option[value='" + currentValue + "']").length > 0) {
	                    $term.val(currentValue);
	                } else {
	                    $term.val("");
	                }

	                if (callback) {
	                    callback();
	                }
	            },
	            function () {
	                if (callback) {
	                    callback();
	                }
	            },
	            false
	        );
	    }

	    function loadSubjectOptions(triggerSearch) {
	        var currentValue = $("#srchSbjt").val() || "";

	        ajaxCall("/bbs/" + TEMPLATE_URL + "/selectBbsSubjectList.do", {
	                searchYr: $("#srchYear").val() || "",
	                searchSmstrCd: $("#srchTerm").val() || "",
	                searchOrgId: $("#srchOrg").val() || ""
	            },
	            function (data) {
	                var list = (data && data.returnList) ? data.returnList : [];
	                var $sbj = $("#srchSbjt");

	                $sbj.empty();
	                $sbj.append('<option value=""><spring:message code="cls.label.operating.subject"/><%-- 운영과목 --%></option>');

	                list.forEach(function (item) {
	                    var value = item.sbjctId || "";
	                    var label = item.sbjctnm || "";

	                    if (item.dvclasNo) {
	                        label += " (" + item.dvclasNo + '<spring:message code="cls.label.decls.name"/><%-- 반 --%>' + ")";
	                    }
	                    if (item.crclmnNo) {
	                        label += " [" + item.crclmnNo + "]";
	                    }

	                    $sbj.append(
	                        '<option value="' + UiComm.escapeHtml(String(value)) + '">'
	                        + UiComm.escapeHtml(String(label))
	                        + '</option>'
	                    );
	                });

	                if (currentValue && $sbj.find("option[value='" + currentValue + "']").length > 0) {
	                    $sbj.val(currentValue);
	                } else {
	                    $sbj.val("");
	                }

	                $sbj.trigger("chosen:updated");

	                // 목록 재조회 요청이 있을 때만 호출
	                if (triggerSearch) {
	                    loadClsList(1);
	                }
	            },
	            function () {
	                if (triggerSearch) {
	                    loadClsList(1);
	                }
	            },
	            false
	        );
	    }
	</script>
</head>

<body class="home ${uiex:getTheme()} ${bodyClass}"><!-- 컬러선택시 클래스변경 -->
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/home_header.jsp"/>
        <!-- //common header -->

        <!-- dashboard -->
        <main class="common">

            <!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_gnb_prof.jsp"/>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="dashboard_sub">

                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">${bbsVO.bbsNm}</h2>
                            <uiex:navibar type="main"/> <%-- 네비게이션바 --%>
                        </div>

                        <!-- search typeA -->
                        <div class="search-typeA">
                        	<c:choose>
								<c:when test="${bbsVO.bbsTycd == 'NTC' && bbsVO.bbsRefTycd == 'ORG'}">
		                        	<div class="item">
		                        		<span class="item_tit"><label for="selectSdttm">조회기간</label></span>
			                        	<input type="text" id="searchSdttm" name="searchSdttm" class="datepicker" toDate="searchEdttm">
										<span class="txt-sort">~</span>
										<input type="text" id="searchEdttm" name="searchEdttm" class="datepicker" fromDate="searchSdttm">
									</div>
		                        	<div class="item">
		                        		<span class="item_tit"><label for="selectOrg">기관</label></span>
										<select class="form-select" id="srchOrg" name="searchOrgId">
	                                        <option value="ALL"><spring:message code="cls.label.org"/><%-- 기관 --%></option>
	                                        <option value="SYSTEM_DEFAULT">시스템 공지사항</option>
	                                        <c:forEach var="item" items="${orgList}">
	                                            <option value="${item.orgId}" <c:if test="${vo.searchOrgId == item.orgId}">selected</c:if>>
	                                                    ${item.orgnm}
	                                            </option>
	                                        </c:forEach>
	                                    </select>
								    </div>
								</c:when>
								<c:otherwise>
									<div class="item">
		                                <span class="item_tit">
		                                    <label for="srchYear">
		                                        <spring:message code="cls.label.academic.year"/><%-- 학사년도 --%>/<spring:message code="common.term"/><%--학기 --%>
		                                    </label>
		                                </span>
		                                <div class="itemList">
		                                    <c:set var="selectedYr" value="${bbsVO.searchYr}"/>

		                                    <select class="form-select" id="srchYear" name="searchYr">
		                                        <c:forEach var="item" items="${yearList}">
		                                            <option value="${item}" ${item eq selectedYr ? 'selected' : ''}>
		                                                    ${item}<spring:message code="date.year"/><%-- 년 --%>
		                                            </option>
		                                        </c:forEach>
		                                    </select>

		                                    <select class="form-select" id="srchTerm" name="searchSmstrCd">
		                                        <option value=""><spring:message code="cls.label.open.term"/><%-- 개설학기 --%></option>
		                                        <c:forEach var="item" items="${smstrChrtList}">
		                                            <option value="${item.dgrsSmstrChrt}" <c:if test="${vo.searchSmstrCd == item.dgrsSmstrChrt}">selected</c:if>>
		                                                    ${item.smstrChrtnm}
		                                            </option>
		                                        </c:forEach>
		                                    </select>
		                                </div>
		                            </div>

		                            <div class="item">
		                                <span class="item_tit">
		                                    <label for="srchSbjt"><spring:message code="cls.label.operating.subject"/><%-- 운영과목 --%></label>
		                                </span>
		                                <div class="itemList">
		                                    <select class="form-select" id="srchOrg" name="searchOrgId">
		                                        <option value=""><spring:message code="cls.label.org"/><%-- 기관 --%></option>
		                                        <c:forEach var="item" items="${orgList}">
		                                            <option value="${item.orgId}" <c:if test="${vo.searchOrgId == item.orgId}">selected</c:if>>
		                                                    ${item.orgnm}
		                                            </option>
		                                        </c:forEach>
		                                    </select>

		                                    <select class="form-select" id="srchSbjt" name="sbjctId">
		                                        <option value=""><spring:message code="cls.label.operating.subject"/><%-- 운영과목 --%></option>
		                                        <c:forEach var="item" items="${subjectList}">
		                                            <option value="${item.sbjctId}"
		                                                    <c:if test="${vo.sbjctId == item.sbjctId}">selected</c:if>>
		                                                    ${item.sbjctnm}
		                                                        <c:if test="${not empty item.dvclasNo}"> (${item.dvclasNo}<spring:message code="cls.label.decls.name"/><%-- 반 --%>)</c:if>
		                                                <c:if test="${not empty item.crclmnNo}"> [${item.crclmnNo}]</c:if>
		                                            </option>
		                                        </c:forEach>
		                                    </select>
		                                </div>
		                            </div>
							    </c:otherwise>
							</c:choose>
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
	                            <h3 class="board-title">${bbsVO.bbsNm}</h3>
	                            <div class="right-area">
	                                <c:if test="${(bbsVO.bbsTycd == 'NTC' && STUDENT_YN != 'Y' && bbsVO.bbsRefTycd != 'ORG') || (bbsVO.bbsTycd == 'QNA' && STUDENT_YN == 'Y')}">
									    <button type="button" class="btn type1" style="white-space: nowrap;" onclick="moveWriteAtcl()"><spring:message code="bbs.button.write" /></button><%-- 글쓰기 --%>
									</c:if>

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
							let tableColumns = [
							    {title:"No", field:"no", headerHozAlign:"center", hozAlign:"center", width:60, minWidth:60},
							];

							// 2. 조건부 컬럼 추가 (bbsTycd 'NTC' // BBS_REF_TYCD "SBJCT")
							if('${PROFESSOR_YN}' === 'Y') {
								if (BBS_TYCD === "QNA" || BBS_TYCD === "1ON1" || (BBS_TYCD === "NTC" && BBS_REF_TYCD === "SBJCT")) {
								    var cols = [
								        { title: "<spring:message code='bbs.label.org' />",   field: "orgnm",    headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 40 }
								    ];
								    cols.push(
								        { title: "<spring:message code='bbs.label.sbjct' />", field: "sbjctnm",  headerHozAlign: "center", hozAlign: "center", width: 140, minWidth: 40 },
								        { title: "<spring:message code='bbs.label.class' />", field: "dvclasNo", headerHozAlign: "center", hozAlign: "center", width: 60, minWidth: 40 }
								    );
								    tableColumns.push.apply(tableColumns, cols);
								} else if (BBS_TYCD === "NTC" && BBS_REF_TYCD === "ORG") {
								    // 기관공지: 기관명만
								    tableColumns.push(
								        { title: "<spring:message code='bbs.label.org' />", field: "orgnm", headerHozAlign: "center", hozAlign: "center", width: 140, minWidth: 40 }
								    );
								}
							} else if('${STUDENT_YN}' === 'Y'){
							    if (BBS_TYCD === "QNA" || BBS_TYCD === "1ON1" || BBS_TYCD === "DATARM" || (BBS_TYCD === "NTC" && BBS_REF_TYCD === "SBJCT")) {
							        var cols = [
							            { title: "<spring:message code='bbs.label.org' />",   field: "orgnm",    headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 40 }
							        ];
							        cols.push(
							            { title: "<spring:message code='bbs.label.sbjct' />", field: "sbjctnm",  headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 40 },
							            { title: "<spring:message code='bbs.label.class' />", field: "dvclasNo", headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 40 }
							        );
							        tableColumns.push.apply(tableColumns, cols);
							    } else {
							        tableColumns.push(
							            { title: "<spring:message code='bbs.label.org' />",   field: "orgnm",    headerHozAlign: "center", hozAlign: "center", width: 100, minWidth: 40 }
							        );
							    }
							}

							// 3. 나머지 공통 컬럼 추가
							tableColumns.push(
								{title:"<spring:message code='bbs.label.form_title'/>", field:"atclTtl",    headerHozAlign:"center", hozAlign:"left", minWidth:200, widthGrow:1, headerSort:true}, // 제목
								{title:"<spring:message code='bbs.label.reg_user'/>", 	field:"rgtrnm", 	headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100},	// 작성자
								{title:"<spring:message code='bbs.label.reg_date'/>", 	field:"regDttm", 	headerHozAlign:"center", hozAlign:"center", width:100, 	minWidth:100,	headerSort:true, formatter: "date"},	// 등록일자
								{title:"<spring:message code='bbs.label.view'/>", 		field:"inqCnt", 	headerHozAlign:"center", hozAlign:"center", width:60,	minWidth:60},	// 조회
								{title:"<spring:message code='bbs.label.comment'/>", 	field:"cmntCnt", 	headerHozAlign:"center", hozAlign:"center",	width:60,	minWidth:60},	// 댓글
								{title:"<spring:message code='bbs.label.attach'/>", 	field:"attach", 	headerHozAlign:"center", hozAlign:"center", width:60,	minWidth:60}	// 첨부
							);

							// 게시글 리스트 테이블
							let atclListTable = UiTable("atclList", {
								lang: "ko",
								pageFunc: listPaging,
								columns: tableColumns
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
            <!-- //content -->

            <!-- common footer -->
            <jsp:include page="/WEB-INF/jsp/common_new/home_footer.jsp"/>
            <!-- //common footer -->

        </main>
        <!-- //dashboard-->

    </div>

</body>
</html>
