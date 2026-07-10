<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="admin"/>
		<jsp:param name="module" value="table"/>
	</jsp:include>

    <script type="text/javascript">
        var SEARCH_VALUE	= '<c:out value="${sbjctTmpltListVO.searchValue}" />';
        var PAGE_INDEX		= '<c:out value="${sbjctTmpltListVO.pageIndex}" />';
        var LIST_SCALE		= '<c:out value="${sbjctTmpltListVO.listScale}" />';
        var EPARAM			= '<c:out value="${encParams}" />';
        var ORG_ID          = '<c:out value="${orgId}" />';
        var FIXED_ORG_YN    = '<c:out value="${fixedOrgYn}" />';
        var SMSTR_CHRT_ID   = '<c:out value="${sbjctTmpltListVO.smstrChrtId}" />';
        var SBJCT_YR        = '<c:out value="${sbjctTmpltListVO.sbjctYr}" />';
        var SBJCT_SMSTR     = '<c:out value="${sbjctTmpltListVO.sbjctSmstr}" />';
        var SBJCT_TYCD      = '<c:out value="${sbjctTmpltListVO.sbjctTycd}" />';
        var DGRS_YR_CHRT_LIST = [];
        var dialog;
        var YEAR_SELECT_TEXT = '<spring:message code="std.label.year"/> <spring:message code="sys.button.select"/>'; // 년도 선택
        var TERM_SELECT_TEXT = '<spring:message code="common.term.cohort"/> <spring:message code="sys.button.select"/>'; // 학기/기수 선택

        $(document).ready(function() {
            $("#selectOrg").val(ORG_ID);
            if(FIXED_ORG_YN == "Y") {
                $("#selectOrg").prop("disabled", true);
            }
            $("#selectOrg").trigger("chosen:updated");

            reloadSearchOptions(function() {
                listPaging(PAGE_INDEX);
            });

            // 검색어 입력 후 Enter 키로 목록을 조회한다.
            $("#searchValue").on("keydown", function(e) {
                if(e.keyCode == 13) {
                    listPaging(1);
                }
            });

            $("#selectOrg").on("change", function(){
                ORG_ID = $(this).val();
                SMSTR_CHRT_ID = "";
                SBJCT_YR = "";
                SBJCT_SMSTR = "";
                SBJCT_TYCD = "";
                reloadSearchOptions();
            });

            $("#selectYrSmstr").on("change", function(){
                setSelectedYrSmstrValues();
            });

            if(!PAGE_INDEX) {
                PAGE_INDEX = 1;
            }

            if(!LIST_SCALE) {
                LIST_SCALE = 10;
            }
        });

		// 목록 표시 건수를 변경하고 다음 검색 시 반영한다.
		function changeListScale(scale) {
			LIST_SCALE = scale;
		}

        // 검색 옵션 조회가 모두 끝난 뒤 목록 조회 콜백을 실행한다.
        function reloadSearchOptions(callback) {
            $.when(
                fetchDgrsYrChrtList(),
                fetchSbjctTmpltTypeCdList('/crs/sbjctTmplt/admSbjctTycdList.do')
            ).always(function() {
                if($.isFunction(callback)) {
                    callback();
                }
            });
        }

        // 검색조건과 페이지 정보로 과목 목록을 조회합니다.
        function listPaging(pageIndex) {
            SEARCH_VALUE = $("#searchValue").val();
            PAGE_INDEX = pageIndex || PAGE_INDEX || 1;

            var searchValue = $('#searchValue').val();
            var sbjctTycd = $("#selectSbjctTmpltTyCd").val();
            if(sbjctTycd == "all") {
                sbjctTycd = "";
            }
            var yrSmstr = getSelectedYrSmstr();
            var sbjctYr = yrSmstr.sbjctYr;
            var sbjctSmstr = yrSmstr.sbjctSmstr;
            var orgId = $("#selectOrg").val();

            var param = {
                encParams       : EPARAM
                , currentPageNo      : PAGE_INDEX
                , recordCountPerPage : LIST_SCALE
                , pageSize           : 10
                , orgId              : orgId
                , searchValue        : searchValue
                , smstrChrtId        : yrSmstr.smstrChrtId
                , sbjctYr            : sbjctYr
                , sbjctSmstr         : sbjctSmstr
                , sbjctTycd          : sbjctTycd
            };

            var url  = "/crs/sbjctTmplt/admSbjctTmpltList.do";
			UiComm.showLoading(true);
            ajaxCall(url, param, function(res) {
                if (res.encParams != null && res.encParams != '') {
                    EPARAM = res.encParams;
                }

                if (res.result > 0) {
                    let returnList = res.returnList || [];

                    // 조회 결과를 테이블 표시용 데이터로 변환한다.
                    let dataList = createSbjctTmpltListHTML(returnList, res.pageInfo);
                    sbjctTmpltListTable.clearData();
                    sbjctTmpltListTable.replaceData(dataList);
                    sbjctTmpltListTable.setPageInfo(res.pageInfo);
                    SMSTR_CHRT_ID = yrSmstr.smstrChrtId;
                    SBJCT_YR = sbjctYr;
                    SBJCT_SMSTR = sbjctSmstr;
                    SBJCT_TYCD = sbjctTycd;
                } else {
                    UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>","error"); // 에러가 발생했습니다!
                }
            }, function(xhr, status, error) {
                UiComm.showMessage("<spring:message code='fail.common.msg'/>","error"); // 에러가 발생했습니다!
            });
        }

        // 서버 응답 과목 목록을 UiTable 데이터 형식으로 변환한다.
		function createSbjctTmpltListHTML(sbjctTmpltList, pageInfo) {
            let dataList = [];

			if(sbjctTmpltList.length == 0) {
				return dataList;
			} else {
				sbjctTmpltList.forEach(function(v, i) {
					var lineNo = pageInfo.totalRecordCount - v.lineNo + 1;

					let col0 = "";
					col0 = lineNo;

					let useynHtml = '<input type="checkbox" value="Y" class="switch small" onchange="modifyUseyn(this, \'' + v.sbjctTmpltId + '\', this.checked)"';
					if(v.useyn == 'Y') {
						useynHtml += '	checked="checked">';
					} else {
					    useynHtml += '>';
					}

					let mngHtml = "";
					mngHtml += "<div style='display:flex;align-items:center;justify-content:center;gap:0 3px'>";
					mngHtml += '<button type="button" class="btn basic small" onclick="viewSbjctTmpltModify(\'' + v.sbjctTmpltId + '\')">';
					mngHtml += '<spring:message code="sys.button.modify"/></button>'; // 수정
					mngHtml += '<button type="button" class="btn basic small" onclick="deleteSbjctTmplt(\'' + v.sbjctTmpltId + '\')"><spring:message code="sys.button.delete" /></button>'; // 삭제
					mngHtml += "&nbsp;</div>";

					dataList.push({
						no: col0,
						orgnm: v.orgnm,
						sbjctSmstr: v.sbjctSmstr,
						sbjctTycdnm : v.sbjctTycdnm,
						sbjctCd: v.sbjctCd,
                        lctrGbncdnm: v.lctrGbncdnm,
						sbjctnm: v.sbjctnm,
						useyn: useynHtml,
						mng : mngHtml,
						regDttm: v.regDttm
					});
				});

				return dataList;
			}

        }

        // 과목 수정 화면으로 이동한다.
        function viewSbjctTmpltModify(sbjctTmpltId) {
            location.href = '/crs/sbjctTmplt/admSbjctTmpltRegistView.do?encParams=' + EPARAM + '&sbjctTmpltId=' + encodeURIComponent(sbjctTmpltId);
        }

        // 과목 사용여부를 수정한다.
        function modifyUseyn(el, sbjctTmpltId){
            var $el = $(el);
            var isChecked = $el.is(":checked");

            $el.prop("disabled", true);
            var param = {
                sbjctTmpltId    : sbjctTmpltId
                , useyn         : isChecked ? 'Y' : 'N'
            };

            var url  = "/crs/sbjctTmplt/admSbjctTmpltUseynModify.do";
            ajaxCall(url, param, function(res) {
                $el.prop("disabled", false);
                if (res.result <= 0) {
                    $el.prop("checked", !isChecked);
                    UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>","error"); // 에러가 발생했습니다!
                }
            }, function(xhr, status, error) {
                $el.prop("disabled", false);
                $el.prop("checked", !isChecked);
                var res = xhr.responseJSON || {};
                UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>","error"); // 에러가 발생했습니다!
            });

        }

        // 과목을 삭제 처리한다.
        function deleteSbjctTmplt(sbjctTmpltId) {
            UiComm.showMessage("<spring:message code='crs.confirm.delete' />", "confirm") /* 정말 삭제하시겠습니까? */
                .then(function(result) {
                    if (result) {
                        $.ajax({
                            url: "/crs/sbjctTmplt/admSbjctTmpltDelete.do",
                            type: "POST",
                            contentType: "application/json",
                            data: JSON.stringify({sbjctTmpltId: sbjctTmpltId}),
                            dataType: "json",
                            beforeSend: function () {
                                UiComm.showLoading(true);
                            }
                        }).done(function(res) {
                            UiComm.showLoading(false);
                            if (res.result > 0) {
                                UiComm.showMessage("<spring:message code='success.common.save' />", "success"); // 정상적으로 저장되었습니다.
                                listPaging(PAGE_INDEX);
                            } else {
                                UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>", "error"); // 에러가 발생했습니다!
                            }
                        }).fail(function(xhr, status, error) {
                            UiComm.showLoading(false);
                            UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error"); // 에러가 발생했습니다!
                        });
                    }
                });
        }

        // 현재 검색 조건으로 과목 목록 엑셀 파일을 다운로드한다.
        function selectSbjctTmpltListExcelDown() {
            var excelGrid = {
                colModel:[
                    {label:'No.', name:'lineNo', align:'center', width:'3000'},
                    {label:"<spring:message code='common.label.org'/>", name:'orgnm', align:'left', width:'7000'}, // 기관
                    {label:"<spring:message code='crs.label.crecrs.ctgr'/>", name:'sbjctTycdnm', align:'center', width:'7000'}, // 과목분류
                    {label:"<spring:message code='crs.label.crsopertypecd'/>", name:'lctrGbncdnm', align:'center', width:'7000'}, // 강의형태
                    {label:"<spring:message code='common.label.crsauth.crscd'/>", name:'sbjctCd', align:'center', width:'5000'}, // 과목코드
                    {label:"<spring:message code='crs.label.crecrs.nm'/>", name:'sbjctnm', align:'left', width:'10000'}, // 과목명
                    {label:"<spring:message code='main.common.use.yn'/>", name:'useyn', align:'center', width:'5000'} // 사용여부
                ]
            };

            $("form[name=excelForm]").remove();
            var excelForm = $('<form name="excelForm" method="post" ></form>');
            var excelSbjctTycd = $("#selectSbjctTmpltTyCd").val();
            if(excelSbjctTycd == "all") {
                excelSbjctTycd = "";
            }

            excelForm.attr("action", "/crs/sbjctTmplt/admSbjctTmpltListExcelDown.do");
            excelForm.append($('<input/>', {type: 'hidden', name: 'orgId', value: $("#selectOrg").val()}));
            excelForm.append($('<input/>', {type: 'hidden', name: 'searchValue', value: $("#searchValue").val()}));
            var yrSmstr = getSelectedYrSmstr();
            excelForm.append($('<input/>', {type: 'hidden', name: 'smstrChrtId', value: yrSmstr.smstrChrtId}));
            excelForm.append($('<input/>', {type: 'hidden', name: 'sbjctYr', value: yrSmstr.sbjctYr}));
            excelForm.append($('<input/>', {type: 'hidden', name: 'sbjctSmstr', value: yrSmstr.sbjctSmstr}));
            excelForm.append($('<input/>', {type: 'hidden', name: 'sbjctTycd', value: excelSbjctTycd}));
            excelForm.append($('<input/>', {type: 'hidden', name: 'excelGrid', value: JSON.stringify(excelGrid)}));
            excelForm.appendTo('body');
            excelForm.submit();
        }

        // 과목 엑셀 등록 팝업에서 사용할 기준 파라미터를 조회하고 필수값을 검증한다.
        function getSbjctTmpltExcelUploadParams() {
            var orgId = $("#selectOrg").val();
            var yrSmstr = getSelectedYrSmstr();
            var sbjctYr = yrSmstr.sbjctYr;
            var sbjctSmstr = yrSmstr.sbjctSmstr;
            var smstrChrtId = yrSmstr.smstrChrtId;

            if(!orgId) {
                UiComm.showMessage("<spring:message code='crs.sbjct.alert.select.org'/>", "warning"); // 기관을 선택해 주세요.
                return null;
            }
            if(!sbjctYr) {
                UiComm.showMessage("<spring:message code='crs.sbjct.alert.select.year'/>", "warning"); // 년도를 선택해 주세요.
                return null;
            }
            if(!sbjctSmstr || !smstrChrtId) {
                UiComm.showMessage("<spring:message code='crs.sbjct.alert.select.term'/>", "warning"); // 학기/기수를 선택해 주세요.
                return null;
            }

            // UiDialog GET 호출에 사용할 현재 검색 조건을 반환한다.
            return {
                orgId: orgId,
                smstrChrtId: smstrChrtId,
                sbjctYr: sbjctYr,
                sbjctSmstr: sbjctSmstr
            };
        }

        // 과목 엑셀 등록 팝업을 UiDialog 방식으로 호출한다.
        function openSbjctTmpltExcelUpload() {
            var params = getSbjctTmpltExcelUploadParams();
            if(!params) {
                return;
            }

            dialog = UiDialog("dialog1", {
                title: "<spring:message code='crs.button.excel.reg' />", /*엑셀로 등록*/
                width: 600,
                height: 400,
                url: "/crs/sbjctTmplt/admSbjctTmpltExcelUploadPop.do?" + $.param(params),
                autoresize: true
            });
        }

        // 과목 엑셀 등록 성공 후 현재 페이지 목록을 다시 조회한다.
        function sbjctTmpltExcelUploadCallback() {
            listPaging(PAGE_INDEX);
        }

        // 과목 엑셀 등록 UiDialog 팝업을 닫는다.
        function closeDialog() {
            if(dialog) {
                dialog.close();
            }
        }

        // 선택된 기관의 학기/기수 목록을 조회한다.
        function fetchDgrsYrChrtList() {
            return $.ajax({
                url: '/common/admYrSmstrSelect.do',
                data: {
                    orgId: $("#selectOrg").val()
                },
                success: function(res) {
                    DGRS_YR_CHRT_LIST = [];
                    if(res.result > 0) {
                        DGRS_YR_CHRT_LIST = res.returnList || [];
                    }

                    renderYrSmstrOptions();
                },
                error: function(xhr) {
                    console.log(xhr);
                }
            });
        }

        // 조회된 학기/기수 목록에서 년도 선택 옵션을 구성한다.
        function renderDgrsYrOptions() {
            var yearHtml = buildDefaultOption(YEAR_SELECT_TEXT);
            var yearMap = {};
            var selectedYear = '';
            var restoredYear = SBJCT_YR;

            DGRS_YR_CHRT_LIST.forEach(function(v) {
                if(!yearMap[v.dgrsYr]) {
                    yearMap[v.dgrsYr] = true;
                    if(!selectedYear) {
                        selectedYear = v.dgrsYr;
                    }
                    yearHtml += '<option value="' + v.dgrsYr + '">';
                    yearHtml += v.dgrsYr + '<spring:message code="date.year"/>'; // 년
                    yearHtml += '</option>';
                }
            });

            if(restoredYear && yearMap[restoredYear]) {
                selectedYear = restoredYear;
            }

            $("#selectDgrsYr").html(yearHtml);
            $("#selectDgrsYr").val(selectedYear);
            $("#selectDgrsYr").trigger("chosen:updated");

            renderDgrsSmstrChrtOptions(selectedYear);
        }

        // 선택된 년도에 해당하는 학기/기수 선택 옵션을 구성한다.
        function renderDgrsSmstrChrtOptions(dgrsYr) {
            var semesterHtml = buildDefaultOption(TERM_SELECT_TEXT);
            var semesterMap = {};
            var selectedSemester = '';
            var restoredSemester = SBJCT_SMSTR;

            DGRS_YR_CHRT_LIST.forEach(function(v) {
                if(v.dgrsYr == dgrsYr) {
                    semesterMap[v.dgrsSmstrChrt] = true;
                    if(!selectedSemester) {
                        selectedSemester = v.dgrsSmstrChrt;
                    }
                    semesterHtml += '<option value="' + v.dgrsSmstrChrt + '" smstrChrtId="' + v.smstrChrtId + '">';
                    semesterHtml += v.dgrsSmstrChrt + '<spring:message code="common.term"/>';/*학기*/
                    semesterHtml += '</option>';
                }
            });

            if(restoredSemester && semesterMap[restoredSemester]) {
                selectedSemester = restoredSemester;
            }

            $("#selectDgrsSmstrChrt").html(semesterHtml);
            $("#selectDgrsSmstrChrt").val(selectedSemester);
            $("#selectDgrsSmstrChrt").trigger("chosen:updated");
        }

        // 선택 박스의 기본 안내 옵션을 생성한다.
        function buildDefaultOption(text) {
            return '<option value="">' + text + '</option>';
        }

        // 선택된 기관의 과목분류 코드 목록을 조회한다.
        // 조회된 년도/학기(기수) 목록을 단일 선택 박스로 구성한다.
        function renderYrSmstrOptions() {
            var html = "";
            var selectedValue = "";

            DGRS_YR_CHRT_LIST.forEach(function(v) {
                var smstrChrtId = v.smstrChrtId || "";
                if(!selectedValue && isCurrentYrSmstr(v)) {
                    selectedValue = smstrChrtId;
                }
                if(SMSTR_CHRT_ID && SMSTR_CHRT_ID == smstrChrtId) {
                    selectedValue = smstrChrtId;
                } else if(!SMSTR_CHRT_ID && SBJCT_YR && SBJCT_SMSTR && SBJCT_YR == getDgrsYr(v) && SBJCT_SMSTR == getDgrsSmstrChrt(v)) {
                    selectedValue = smstrChrtId;
                }
                html += '<option value="' + escapeHtml(smstrChrtId) + '"';
                html += ' data-dgrs-yr="' + escapeHtml(getDgrsYr(v)) + '"';
                html += ' data-dgrs-smstr-chrt="' + escapeHtml(getDgrsSmstrChrt(v)) + '">';
                html += escapeHtml(getYrSmstrName(v));
                html += '</option>';
            });

            $("#selectYrSmstr").html(html);
            if(!selectedValue && DGRS_YR_CHRT_LIST.length > 0) {
                selectedValue = DGRS_YR_CHRT_LIST[0].smstrChrtId || "";
            }
            $("#selectYrSmstr").val(selectedValue).trigger("chosen:updated");
            setSelectedYrSmstrValues();
        }

        // 선택한 년도/학기(기수)의 조회 조건을 현재값으로 보관한다.
        function setSelectedYrSmstrValues() {
            var yrSmstr = getSelectedYrSmstr();
            SMSTR_CHRT_ID = yrSmstr.smstrChrtId;
            SBJCT_YR = yrSmstr.sbjctYr;
            SBJCT_SMSTR = yrSmstr.sbjctSmstr;
        }

        // 년도/학기(기수) 선택 박스에서 서버 조회 조건을 추출한다.
        function getSelectedYrSmstr() {
            var $option = $("#selectYrSmstr option:selected");
            return {
                smstrChrtId: $option.val() || "",
                sbjctYr: $option.attr("data-dgrs-yr") || "",
                sbjctSmstr: $option.attr("data-dgrs-smstr-chrt") || ""
            };
        }

        // 공통 학기 조회 결과에서 현재 학기 여부를 확인한다.
        function isCurrentYrSmstr(v) {
            return (v.nowSmstryn || v.nowSmstrYn || "") == "Y";
        }

        // 공통 학기 조회 결과에서 년도 값을 반환한다.
        function getDgrsYr(v) {
            return v.yr || v.dgrsYr || "";
        }

        // 공통 학기 조회 결과에서 학기/기수 값을 반환한다.
        function getDgrsSmstrChrt(v) {
            return v.smstr || v.dgrsSmstrChrt || "";
        }

        // 공통 학기 조회 결과에서 목록 표시명을 반환한다.
        function getYrSmstrName(v) {
            return v.yrSmstrnm || v.yrSmstrNm || "";
        }

        // HTML 특수문자를 이스케이프한다.
        function escapeHtml(value) {
            return String(value || "")
                .replace(/&/g, "&amp;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;")
                .replace(/"/g, "&quot;")
                .replace(/'/g, "&#39;");
        }

        function fetchSbjctTmpltTypeCdList(url) {
            return $.ajax({
                url: url,
                data: {
                    orgId: $("#selectOrg").val()
                },
                success: function(res) {
                    if(res.result > 0) {
                        var returnList = res.returnList || [];
                        var html = '';

                        html += '<option value=""><spring:message code="crs.label.all" /></option>'; // 전체
                        returnList.forEach(function(v, i) {
                            html += '<option value="' + v.cd + '">' + v.cdnm + '</option>';
                        });

                        $("#selectSbjctTmpltTyCd").empty();
                        $("#selectSbjctTmpltTyCd").html(html);
                        $("#selectSbjctTmpltTyCd").val(SBJCT_TYCD || "");
                        $("#selectSbjctTmpltTyCd").trigger("chosen:updated");
                    }
                },
                error: function(xhr) {
                    console.log(xhr);
                }
            });


        }

    </script>
</head>
<body class="admin">
    <div id="wrap" class="main">
        <!-- common header -->
        <%@ include file="/WEB-INF/jsp/common_new/admin_header.jsp" %>
        <!-- //common header -->

         <!-- admin -->
        <main class="common">

            <!-- gnb -->
            <%@ include file="/WEB-INF/jsp/common_new/admin_aside.jsp" %>
            <!-- //gnb -->

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="admin_sub">

                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">${uiex:getCurMenunm()}</h2> <%-- 현재 메뉴명 --%>
                            <uiex:navibar type="admin"/><%-- 네비게이션바 --%>
                        </div>

                        <!-- search typeA -->
                        <div class="search-typeA">
                            <div class="item">
                                <span class="item_tit"><label for="selectOrg"><spring:message code="common.label.org"/><%--기관--%></label></span>
                                <div class="itemList">
                                    <select class="form-select w200 chosen" id="selectOrg" title="<spring:message code='common.label.org'/> <spring:message code='sys.button.select'/>"><%--기관 선택--%>
                                        <c:forEach var="org" items="${orgList}">
                                            <option value="${org.orgId}">
                                                <c:out value="${org.orgnm}" />
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                             <div class="item">
                                <span class="item_tit"><label for="selectYrSmstr"><spring:message code="crs.label.year.term.cohort"/><%--년도/학기(기수)--%></label></span>
                                <div class="itemList">
                                    <select class="form-select w200 chosen" id="selectYrSmstr" title="<spring:message code='crs.label.year.term.cohort'/><%--년도/학기(기수)--%> <spring:message code='sys.button.select'/><%--선택--%>"></select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="selectSbjctTmpltTyCd"><spring:message code="crs.label.subject.type" /><%--과목분류--%></label></span>
                                <div class="itemList">
                                    <select class="form-select w200 chosen" id="selectSbjctTmpltTyCd">
                                        <option value="all"><spring:message code="crs.label.all"/><%--전체--%></option>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="searchValue"><spring:message code="common.search.keyword"/><%--검색어--%></label></span>
                                <div class="itemList">
                                    <input class="form-control" type="text" name="" id="searchValue" value="${sbjctTmpltListVO.searchValue}" placeholder="<spring:message code='crs.placeholder.subject.name.search'/><%--과목명 검색--%>">
                                </div>
                            </div>


                            <div class="button-area">
                                <button type="button" class="btn search" onclick="listPaging(1);"><spring:message code='button.search'/></button><%--검색--%>
                            </div>
                        </div>

                        <div id="sbjctTmpltListArea">
                            <div class="board_top">
                                <h3 class="board-title"><spring:message code='forum.label.list' /></h3><%--목록--%>
                                <div class="right-area">
                                    <button type="button" class="btn type2" onclick="selectSbjctTmpltListExcelDown();"><spring:message code="crs.button.excel.down"/><%--엑셀 다운로드--%></button>
                                    <button type="button" class="btn type2" onclick="openSbjctTmpltExcelUpload();"><spring:message code="crs.button.excel.reg"/><%--엑셀로 등록--%></button>
                                    <button type="button" class="btn type1"><spring:message code="crs.button.academic.system.fetch"/><%--학사연동 가져오기--%></button>
                                    <button type="button" class="btn type2" onClick="location.href='/crs/sbjctTmplt/admSbjctTmpltRegistView.do?encParams=' + EPARAM"><spring:message code="button.write" /><%--등록--%></button>

                                    <%-- 목록 스케일 선택 --%>
                                    <uiex:listScale func="changeListScale" value="${sbjctTmpltListVO.listScale}" />
                                </div>
                            </div>

                            <%-- 과목 등록 리스트 --%>
                            <div id="sbjctTmpltList"></div>

                            <script>
							<%-- 리스트 테이블 --%>
							let sbjctTmpltListTable = UiTable("sbjctTmpltList", {
								lang: "ko",
								initialSort: [{column:"regDttm", dir:"desc"}],
								pageFunc: listPaging,
								columns: [
									{title:"No", 											    field:"no",			headerHozAlign:"center", hozAlign:"center", width:40,	minWidth:40},	// No
									{title:"<spring:message code='common.label.org'/>",         field:"orgnm",	headerHozAlign:"center", hozAlign:"left",	width:200,	minWidth:200, 	headerSort:true},	// 기관
									{title:"<spring:message code='crs.label.subject.type'/>", 	field:"sbjctTycdnm", 	headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100,	headerSort:true},	// 과목분류
									{title:"<spring:message code='crs.label.crsopertypecd'/>", 	field:"lctrGbncdnm", 	headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100,	headerSort:true},	// 강의형태
									{title:"<spring:message code='common.label.crsauth.crscd'/>", 		field:"sbjctCd", 	headerHozAlign:"center", hozAlign:"center", width:100,	minWidth:100},	// 과목코드
									{title:"<spring:message code='crs.label.crecrs.nm'/>", 	    field:"sbjctnm", 	headerHozAlign:"center", hozAlign:"left",	width:0,	minWidth:100,	headerSort:true},	// 과목명
									{title:"<spring:message code='main.common.use.yn'/>", 	    field:"useyn", 	headerHozAlign:"center", hozAlign:"center",	width:100,	minWidth:100},	// 사용여부
									{title:"<spring:message code='common.mgr'/>", 	            field:"mng", 	headerHozAlign:"center", hozAlign:"center",	width:140,	minWidth:140},	// 관리

								]
							});

							</script>


                            </div>
                        </div>
                        <!--//table-type-->
                    </div>
                    <!-- //sub-content -->

                </div>
            </div>
            <!-- //content -->

        </main>
        <!-- //admin-->
    </div>
    <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
</body>
</html>

