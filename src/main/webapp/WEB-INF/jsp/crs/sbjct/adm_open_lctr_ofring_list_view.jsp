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
        var SEARCH_VALUE = '<c:out value="${sbjctListVO.searchValue}" />';
        var PAGE_INDEX = '<c:out value="${sbjctListVO.pageIndex}" />';
        var LIST_SCALE = '<c:out value="${sbjctListVO.listScale}" />';
        var EPARAM = '<c:out value="${encParams}" />';
        var ORG_ID = '<c:out value="${orgId}" />';
        var FIXED_ORG_YN = '<c:out value="${fixedOrgYn}" />';
        var SMSTR_CHRT_ID = '<c:out value="${sbjctListVO.smstrChrtId}" />';
        var SBJCT_YR = '<c:out value="${sbjctListVO.sbjctYr}" />';
        var SBJCT_SMSTR = '<c:out value="${sbjctListVO.sbjctSmstr}" />';
        var OPEN_CRS_GBNCD = "OPEN_CRS";
        var OPEN_LCTR_SYSTEM_SBJCT_TYCD = "OPEN_LCTR_SYSTEM";
        var CRS_GBNCD = '<c:out value="${sbjctListVO.crsGbncd}" />' || OPEN_CRS_GBNCD;
        var SBJCT_TYCD = '<c:out value="${sbjctListVO.sbjctTycd}" />' || OPEN_LCTR_SYSTEM_SBJCT_TYCD;
        var DGRS_YR_CHRT_LIST = [];
        var dialog;

        $(document).ready(function() {
            $("#selectOrg").val(ORG_ID);
            if(FIXED_ORG_YN == "Y") {
                $("#selectOrg").prop("disabled", true);
            }
            $("#selectOrg").trigger("chosen:updated");
            $("#selectCrsGbncd").val(CRS_GBNCD || OPEN_CRS_GBNCD).prop("disabled", true);
            $("#selectSbjctTycd").val(SBJCT_TYCD || OPEN_LCTR_SYSTEM_SBJCT_TYCD).prop("disabled", true);
            $("#selectCrsGbncd, #selectSbjctTycd").trigger("chosen:updated");

            fetchDgrsYrChrtList(function() {
                listPaging(PAGE_INDEX || 1);
            });

            $("#searchValue").on("keydown", function(e) {
                if(e.keyCode == 13) {
                    listPaging(1);
                }
            });

            $("#selectOrg").on("change", function() {
                ORG_ID = $(this).val();
                SMSTR_CHRT_ID = "";
                SBJCT_YR = "";
                SBJCT_SMSTR = "";
                fetchDgrsYrChrtList();
            });

            $("#selectYrSmstr").on("change", function() {
                setSelectedYrSmstrValues();
            });
        });

        // 페이지당 목록 건수를 변경한다.
        function changeListScale(scale) {
            LIST_SCALE = scale;
        }

        // 공개강좌개설 목록을 현재 검색조건 기준으로 조회한다.
        function listPaging(pageIndex) {
            PAGE_INDEX = pageIndex || PAGE_INDEX || 1;
            var yrSmstr = getSelectedYrSmstr();

            var param = {
                encParams: EPARAM,
                currentPageNo: PAGE_INDEX,
                recordCountPerPage: LIST_SCALE,
                pageSize: 10,
                orgId: $("#selectOrg").val(),
                searchValue: $("#searchValue").val(),
                smstrChrtId: yrSmstr.smstrChrtId,
                sbjctYr: yrSmstr.sbjctYr,
                sbjctSmstr: yrSmstr.sbjctSmstr,
                crsGbncd: OPEN_CRS_GBNCD,
                sbjctTycd: OPEN_LCTR_SYSTEM_SBJCT_TYCD
            };

            ajaxCall("/crs/openLctrOfring/admOpenLctrOfringList.do", param, function(res) {
                if(res.encParams) {
                    EPARAM = res.encParams;
                }
                if(res.result > 0) {
                    openLctrOfringListTable.clearData();
                    openLctrOfringListTable.replaceData(createOpenLctrOfringListHTML(res.returnList || [], res.pageInfo));
                    openLctrOfringListTable.setPageInfo(res.pageInfo);
                    SMSTR_CHRT_ID = param.smstrChrtId;
                    SBJCT_YR = param.sbjctYr;
                    SBJCT_SMSTR = param.sbjctSmstr;
                    CRS_GBNCD = param.crsGbncd;
                    SBJCT_TYCD = param.sbjctTycd;
                } else {
                    UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/><%--에러가 발생했습니다!--%>", "error");
                }
            }, function() {
                UiComm.showMessage("<spring:message code='fail.common.msg'/><%--에러가 발생했습니다!--%>", "error");
            });
        }

        // 서버에서 받은 공개강좌 목록을 UiTable 표시 데이터로 변환한다.
        function createOpenLctrOfringListHTML(list, pageInfo) {
            var dataList = [];
            list.forEach(function(v) {
                var lineNo = pageInfo.totalRecordCount - v.lineNo + 1;
                var sbjctnmText = escapeHtml(v.sbjctnm || "-");
                var sbjctnmHtml = '<a href="javascript:openOpenLctrOfringBasicInfoPop(\'' + v.sbjctId + '\')" title="' + sbjctnmText + '" class="header header-icon link">' + sbjctnmText + '</a>';
                var previewHtml = v.lessonCntsUrl ? '<button type="button" class="btn basic small" onclick="openPreview(\'' + escapeJs(v.lessonCntsUrl) + '\')">강의 미리보기</button>' : "";
                var useynHtml = '<input type="checkbox" value="Y" class="switch small" onchange="modifyUseyn(this, \'' + v.sbjctId + '\', this.checked)"';
                if(v.useyn == "Y") {
                    useynHtml += ' checked="checked">';
                } else {
                    useynHtml += '>';
                }
                var mngHtml = '<div style="display:flex;align-items:center;justify-content:center;gap:0 3px">';
                mngHtml += previewHtml;
                mngHtml += '<button type="button" class="btn basic small" onclick="viewOpenLctrOfringDetail(\'' + v.sbjctId + '\')"><spring:message code="button.view.detail"/><%--상세보기--%></button>';
                mngHtml += '<button type="button" class="btn basic small" onclick="viewOpenLctrOfringModify(\'' + v.sbjctId + '\')"><spring:message code="sys.button.modify"/><%--수정--%></button>';
                mngHtml += '<button type="button" class="btn basic small" onclick="viewOpenLctrOfringAdm(\'' + v.sbjctId + '\')"><spring:message code="crs.button.manager"/><%--관리자--%></button>';
                mngHtml += '<button type="button" class="btn basic small" onclick="deleteOpenLctrOfring(\'' + v.sbjctId + '\')"><spring:message code="sys.button.delete"/><%--삭제--%></button>';
                mngHtml += "&nbsp;</div>"

                dataList.push({
                    no: lineNo,
                    orgnm: v.orgnm,
                    crsGbncdnm: v.crsGbncdnm,
                    sbjctTycdnm: v.sbjctTycdnm,
                    lctrGbncdnm: v.lctrGbncdnm,
                    sbjctCd: v.sbjctCd,
                    sbjctnm: sbjctnmHtml,
                    profUsernm: v.profUsernm,
                    period: formatPeriod(v.sbjctLctrSdttm, v.sbjctLctrEdttm),
                    useyn: useynHtml,
                    mng: mngHtml,
                    regDttm: v.regDttm
                });
            });
            return dataList;
        }

        // 현재 검색조건과 동일한 공개강좌 목록을 엑셀로 다운로드한다.
        function selectOpenLctrOfringListExcelDown() {
            var excelGrid = {
                colModel: [
                    {label:'No.', name:'lineNo', align:'center', width:'3000'},
                    {label:"<spring:message code='common.label.org'/><%--기관--%>", name:'orgnm', align:'left', width:'7000'},
                    {label:"<spring:message code='crs.label.course.division'/><%--과정구분--%>", name:'crsGbncdnm', align:'center', width:'5000'},
                    {label:"<spring:message code='crs.label.subject.type'/><%--과목분류--%>", name:'sbjctTycdnm', align:'center', width:'5000'},
                    {label:"<spring:message code='crs.label.crsopertypecd'/><%--강의형태--%>", name:'lctrGbncdnm', align:'center', width:'5000'},
                    {label:"<spring:message code='crs.label.subject.code'/><%--과목코드--%>", name:'sbjctCd', align:'center', width:'5000'},
                    {label:"<spring:message code='crs.label.subject.name'/><%--과목명--%>", name:'sbjctnm', align:'left', width:'10000'},
                    {label:"<spring:message code='common.charge.professor'/><%--담당교수--%>", name:'profUsernm', align:'center', width:'5000'},
                    {label:"<spring:message code='common.label.lecture.period'/><%--강의 기간--%>", name:'period', align:'center', width:'7000'},
                    {label:"<spring:message code='main.common.use.yn'/><%--사용여부--%>", name:'useyn', align:'center', width:'4000'}
                ]
            };
            var excelForm = $('<form name="excelForm" method="post"></form>');
            excelForm.attr("action", "/crs/openLctrOfring/admOpenLctrOfringListExcelDown.do");
            excelForm.append($('<input/>', {type:'hidden', name:'orgId', value:$("#selectOrg").val()}));
            var yrSmstr = getSelectedYrSmstr();
            excelForm.append($('<input/>', {type:'hidden', name:'smstrChrtId', value:yrSmstr.smstrChrtId}));
            excelForm.append($('<input/>', {type:'hidden', name:'sbjctYr', value:yrSmstr.sbjctYr}));
            excelForm.append($('<input/>', {type:'hidden', name:'sbjctSmstr', value:yrSmstr.sbjctSmstr}));
            excelForm.append($('<input/>', {type:'hidden', name:'crsGbncd', value:OPEN_CRS_GBNCD}));
            excelForm.append($('<input/>', {type:'hidden', name:'sbjctTycd', value:OPEN_LCTR_SYSTEM_SBJCT_TYCD}));
            excelForm.append($('<input/>', {type:'hidden', name:'searchValue', value:$("#searchValue").val()}));
            excelForm.append($('<input/>', {type:'hidden', name:'excelGrid', value:JSON.stringify(excelGrid)}));
            excelForm.appendTo("body");
            excelForm.submit();
            excelForm.remove();
        }

        // 공개강좌개설 신규 등록 화면으로 이동한다.
        function viewOpenLctrOfringRegist() {
            location.href = '/crs/openLctrOfring/admOpenLctrOfringRegistView.do?encParams=' + EPARAM;
        }

        // 공개강좌개설 상세 화면으로 이동한다.
        function viewOpenLctrOfringDetail(sbjctId) {
            location.href = '/crs/openLctrOfring/admOpenLctrOfringDetailView.do?sbjctId=' + encodeURIComponent(sbjctId || '') + '&encParams=' + EPARAM;
        }

        // 공개강좌개설 수정 화면으로 이동한다.
        function viewOpenLctrOfringModify(sbjctId) {
            location.href = '/crs/openLctrOfring/admOpenLctrOfringRegistView.do?sbjctId=' + encodeURIComponent(sbjctId || '') + '&encParams=' + EPARAM;
        }

        // 공개강좌 관리자 등록 화면으로 이동한다.
        function viewOpenLctrOfringAdm(sbjctId) {
            location.href = '/crs/openLctrOfring/admOpenLctrOfringAdmRegistView.do?sbjctId=' + encodeURIComponent(sbjctId || '') + '&encParams=' + EPARAM;
        }

        // 과목명 클릭 시 공개강좌 기본정보 팝업을 연다.
        function openOpenLctrOfringBasicInfoPop(sbjctId) {
            dialog = UiDialog("dialog1", {
                title: "<spring:message code='crs.open.lctr.ofring.detail' />", /*공개강좌개설 상세보기*/
                width: 1000,
                height: 620,
                url: "/crs/openLctrOfring/admOpenLctrOfringBasicInfoPop.do?sbjctId=" + encodeURIComponent(sbjctId || "") + "&encParams=" + EPARAM,
                autoresize: true
            });
        }

        // UiDialog 팝업을 닫는다.
        function closeDialog() {
            if(dialog) {
                dialog.close();
                dialog = null;
            }
        }

        // 공개강좌개설 목록의 사용여부를 수정한다.
        function modifyUseyn(el, sbjctId) {
            var $el = $(el);
            var isChecked = $el.is(":checked");

            $el.prop("disabled", true);
            ajaxCall("/crs/openLctrOfring/admOpenLctrOfringUseynModify.do", {
                sbjctId: sbjctId,
                useyn: isChecked ? "Y" : "N"
            }, function(res) {
                $el.prop("disabled", false);
                if(res.result <= 0) {
                    $el.prop("checked", !isChecked);
                    UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/><%--에러가 발생했습니다!--%>", "error");
                }
            }, function() {
                $el.prop("disabled", false);
                $el.prop("checked", !isChecked);
                UiComm.showMessage("<spring:message code='fail.common.msg'/><%--에러가 발생했습니다!--%>", "error");
            });
        }

        // 공개강좌개설 정보를 삭제 처리한다.
        function deleteOpenLctrOfring(sbjctId) {
            UiComm.showMessage("<spring:message code='crs.confirm.delete' />", "confirm") /* 정말 삭제하시겠습니까? */
                .then(function(result) {
                    if (result) {
                        $.ajax({
                            url: "/crs/openLctrOfring/admOpenLctrOfringDelete.do",
                            type: "POST",
                            data: {sbjctId: sbjctId},
                            dataType: "json",
                            beforeSend: function () {
                                UiComm.showLoading(true);
                            }
                        }).done(function(res) {
                            UiComm.showLoading(false);
                            if (res.result > 0) {
                                UiComm.showMessage("<spring:message code='success.common.save'/>", "success"); // 정상적으로 저장되었습니다.
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

        // 공개강좌 콘텐츠 미리보기 URL을 새 창으로 연다.
        function openPreview(url) {
            window.open(url, "_blank");
        }

        // 선택 기관의 연도/학기 차수 목록을 조회한다.
        function fetchDgrsYrChrtList(callback) {
            $.ajax({
                url: "/common/admYrSmstrSelect.do",
                data: {orgId: $("#selectOrg").val()},
                success: function(res) {
                    DGRS_YR_CHRT_LIST = res.result > 0 ? (res.returnList || []) : [];
                    renderYrSmstrOptions();
                    if($.isFunction(callback)) {
                        callback();
                    }
                },
                error: function() {
                    DGRS_YR_CHRT_LIST = [];
                    renderYrSmstrOptions();
                }
            });
        }

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

        function formatDttm(value) {
            value = String(value || "").replace(/[^0-9]/g, "");
            if(value.length < 8) {
                return "-";
            }
            return value.substring(0,4) + "." + value.substring(4,6) + "." + value.substring(6,8);
        }

        // 강의기간 시작/종료값이 모두 없으면 영구로 표시한다.
        function formatPeriod(start, end) {
            if(!String(start || "").replace(/[^0-9]/g, "") && !String(end || "").replace(/[^0-9]/g, "")) {
                return "영구";
            }
            return formatDttm(start) + " ~ " + formatDttm(end);
        }

        // 동적 HTML 출력값을 이스케이프한다.
        function escapeHtml(value) {
            return String(value || "").replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;").replace(/'/g, "&#39;");
        }

        // onclick 문자열에 들어갈 URL 값의 따옴표/역슬래시를 이스케이프한다.
        function escapeJs(value) {
            return String(value || "").replace(/\\/g, "\\\\").replace(/'/g, "\\'");
        }
    </script>
</head>
<body class="admin">
<div id="wrap" class="main">
    <%@ include file="/WEB-INF/jsp/common_new/admin_header.jsp" %>
    <main class="common">
        <%@ include file="/WEB-INF/jsp/common_new/admin_aside.jsp" %>
        <div id="content" class="content-wrap common">
            <div class="admin_sub">
                <div class="sub-content">
                    <div class="page-info">
                        <h2 class="page-title">${uiex:getCurMenunm()}</h2>
                        <uiex:navibar type="admin"/>
                    </div>

                    <div class="search-typeA">
                        <div class="item">
                            <span class="item_tit"><label for="selectOrg"><spring:message code="common.label.org"/><%--기관--%></label></span>
                            <div class="itemList">
                                <select class="form-select w200 chosen" id="selectOrg">
                                    <c:forEach var="org" items="${orgList}">
                                        <option value="${org.orgId}"><c:out value="${org.orgnm}" /></option>
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
                            <span class="item_tit"><label for="selectCrsGbncd"><spring:message code="crs.label.course.division"/><%--과정구분--%></label></span>
                            <div class="itemList">
                                <select class="form-select w200 chosen" id="selectCrsGbncd">
                                    <c:forEach var="code" items="${crsGbncdList}">
                                        <option value="<c:out value='${code.cd}' />"><c:out value="${code.cdnm}" /></option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit"><label for="selectSbjctTycd"><spring:message code="crs.label.subject.type"/><%--과목분류--%></label></span>
                            <div class="itemList">
                                <select class="form-select w200 chosen" id="selectSbjctTycd" disabled="disabled">
                                    <c:forEach var="code" items="${sbjctTycdList}">
                                        <option value="<c:out value='${code.cd}' />"><c:out value="${code.cdnm}" /></option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="item">
                            <span class="item_tit"><label for="searchValue"><spring:message code="common.search.keyword"/><%--검색어--%></label></span>
                            <div class="itemList">
                                <input class="form-control" type="text" id="searchValue" value="${sbjctListVO.searchValue}" placeholder="<spring:message code='crs.placeholder.subject.name.search'/><%--과목명 검색--%>">
                            </div>
                        </div>
                        <div class="button-area">
                            <button type="button" class="btn search" onclick="listPaging(1);"><spring:message code='button.search'/><%--검색--%></button>
                        </div>
                    </div>

                    <div class="board_top">
                        <h3 class="board-title"><spring:message code='forum.label.list' /><%--목록--%></h3>
                        <div class="right-area">
                            <button type="button" class="btn type2" onclick="selectOpenLctrOfringListExcelDown();"><spring:message code="crs.button.excel.down"/><%--엑셀 다운로드--%></button>
                            <button type="button" class="btn type2" onclick="viewOpenLctrOfringRegist();"><spring:message code="button.write" /><%--등록--%></button>
                            <uiex:listScale func="changeListScale" value="${sbjctListVO.listScale}" />
                        </div>
                    </div>

                    <div id="openLctrOfringList"></div>
                    <script>
                        let openLctrOfringListTable = UiTable("openLctrOfringList", {
                            lang: "ko",
                            initialSort: [{column:"regDttm", dir:"desc"}],
                            pageFunc: listPaging,
                            columns: [
                                {title:"No", field:"no", headerHozAlign:"center", hozAlign:"center", width:50},
                                {title:"<spring:message code='common.label.org'/><%--기관--%>", field:"orgnm", headerHozAlign:"center", hozAlign:"left", width:140, 	headerSort:true},
                                {title:"<spring:message code='crs.label.course.division'/><%--과정구분--%>", field:"crsGbncdnm", headerHozAlign:"center", hozAlign:"center", width:110},
                                {title:"<spring:message code='crs.label.subject.type'/><%--과목분류--%>", field:"sbjctTycdnm", headerHozAlign:"center", hozAlign:"center", width:110},
                                {title:"<spring:message code='crs.label.crsopertypecd'/><%--강의형태--%>", field:"lctrGbncdnm", headerHozAlign:"center", hozAlign:"center", width:100, 	headerSort:true},
                                {title:"<spring:message code='crs.label.subject.code'/><%--과목코드--%>", field:"sbjctCd", headerHozAlign:"center", hozAlign:"center", width:110, 	headerSort:true},
                                {title:"<spring:message code='crs.label.subject.name'/><%--과목명--%>", field:"sbjctnm", headerHozAlign:"center", hozAlign:"left", minWidth:240, 	headerSort:true},
                                {title:"<spring:message code='common.charge.professor'/><%--담당교수--%>", field:"profUsernm", headerHozAlign:"center", hozAlign:"center", width:110, 	headerSort:true},
                                {title:"<spring:message code='common.label.lecture.period'/><%--강의 기간--%>", field:"period", headerHozAlign:"center", hozAlign:"center", width:180, 	headerSort:true},
                                {title:"<spring:message code='main.common.use.yn'/><%--사용여부--%>", field:"useyn", headerHozAlign:"center", hozAlign:"center", width:80},
                                {title:"<spring:message code='common.mgr'/><%--관리--%>", field:"mng", headerHozAlign:"center", hozAlign:"center", width:430}
                            ]
                        });
                    </script>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>
