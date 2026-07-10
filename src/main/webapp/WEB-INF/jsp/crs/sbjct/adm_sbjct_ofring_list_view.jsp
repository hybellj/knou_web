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
        var SEARCH_VALUE	= '<c:out value="${sbjctListVO.searchValue}" />';
        var PAGE_INDEX		= '<c:out value="${sbjctListVO.pageIndex}" />';
        var LIST_SCALE		= '<c:out value="${sbjctListVO.listScale}" />';
        var EPARAM			= '<c:out value="${encParams}" />';
        var ORG_ID          = '<c:out value="${orgId}" />';
        var FIXED_ORG_YN    = '<c:out value="${fixedOrgYn}" />';
        var SMSTR_CHRT_ID   = '<c:out value="${sbjctListVO.smstrChrtId}" />';
        var SBJCT_YR        = '<c:out value="${sbjctListVO.sbjctYr}" />';
        var SBJCT_SMSTR     = '<c:out value="${sbjctListVO.sbjctSmstr}" />';
        var CRS_GBNCD       = '<c:out value="${sbjctListVO.crsGbncd}" />';
        var SBJCT_TYCD      = '<c:out value="${sbjctListVO.sbjctTycd}" />';
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
                CRS_GBNCD = "";
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
                fetchCodeList('CRS_GBNCD', '#selectCrsGbncd', CRS_GBNCD),
                fetchCodeList('SBJCT_TYCD', '#selectSbjctTycd', SBJCT_TYCD)
            ).always(function() {
                if($.isFunction(callback)) {
                    callback();
                }
            });
        }

        // 검색조건과 페이지 정보로 과목개설 목록을 조회한다.
        function listPaging(pageIndex) {
            SEARCH_VALUE = $("#searchValue").val();
            PAGE_INDEX = pageIndex || PAGE_INDEX || 1;

            var yrSmstr = getSelectedYrSmstr();

            var param = {
                encParams       : EPARAM
                , currentPageNo      : PAGE_INDEX
                , recordCountPerPage : LIST_SCALE
                , pageSize           : 10
                , orgId              : $("#selectOrg").val()
                , searchValue        : $("#searchValue").val()
                , smstrChrtId        : yrSmstr.smstrChrtId
                , sbjctYr            : yrSmstr.sbjctYr
                , sbjctSmstr         : yrSmstr.sbjctSmstr
                , crsGbncd           : $("#selectCrsGbncd").val()
                , sbjctTycd          : $("#selectSbjctTycd").val()
            };

            var url  = "/crs/sbjctOfring/admSbjctOfringList.do";
			UiComm.showLoading(true);
            ajaxCall(url, param, function(res) {
                if (res.encParams != null && res.encParams != '') {
                    EPARAM = res.encParams;
                }

                if (res.result > 0) {
                    let returnList = res.returnList || [];

                    // 조회 결과를 테이블 표시용 데이터로 변환한다.
                    let dataList = createSbjctOfringListHTML(returnList, res.pageInfo);
                    sbjctOfringListTable.clearData();
                    sbjctOfringListTable.replaceData(dataList);
                    sbjctOfringListTable.setPageInfo(res.pageInfo);
                    SMSTR_CHRT_ID = param.smstrChrtId;
                    SBJCT_YR = param.sbjctYr;
                    SBJCT_SMSTR = param.sbjctSmstr;
                    CRS_GBNCD = param.crsGbncd;
                    SBJCT_TYCD = param.sbjctTycd;
                } else {
                    UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>","error"); // 에러가 발생했습니다!
                }
            }, function(xhr, status, error) {
                UiComm.showMessage("<spring:message code='fail.common.msg'/>","error"); // 에러가 발생했습니다!
            });
        }

        // 서버 응답 과목개설 목록을 UiTable 데이터 형식으로 변환한다.
		function createSbjctOfringListHTML(sbjctOfringList, pageInfo) {
            let dataList = [];

			if(sbjctOfringList.length == 0) {
				return dataList;
			}

            sbjctOfringList.forEach(function(v, i) {
                var lineNo = pageInfo.totalRecordCount - v.lineNo + 1;
                var useynHtml = '<input type="checkbox" value="Y" class="switch small" onchange="modifyUseyn(this, \'' + v.sbjctId + '\', this.checked)"';
                if(v.useyn == 'Y') {
                    useynHtml += ' checked="checked">';
                } else {
                    useynHtml += '>';
                }
                var mngHtml = "";
                mngHtml += "<div style='display:flex;align-items:center;justify-content:center;gap:0 3px'>";
                if(v.atndlcCertStscd == "APPROVE") {
                    mngHtml += '<button type="button" class="btn basic small" onclick="viewSbjctOfringAtndlc(\'' + v.sbjctId + '\')"><spring:message code="common.label.students"/></button>'; // 수강생
                    mngHtml += '<button type="button" class="btn basic small" onclick="viewSbjctOfringAdm(\'' + v.sbjctId + '\')"><spring:message code="crs.button.manager"/></button>'; // 관리자
                    mngHtml += '<button type="button" class="btn basic small" onclick="viewSbjctOfringWeekSetup(\'' + v.sbjctId + '\')"><spring:message code="crs.button.week.setting"/></button>'; // 주차설정
                }
                mngHtml += '<button type="button" class="btn basic small" onclick="viewSbjctOfringDetail(\'' + v.sbjctId + '\')"><spring:message code="button.view.detail"/></button>'; // 상세보기
                mngHtml += '<button type="button" class="btn basic small" onclick="viewSbjctOfringModify(\'' + v.sbjctId + '\')"><spring:message code="sys.button.modify"/></button>'; // 수정
                mngHtml += '<button type="button" class="btn basic small" onclick="deleteSbjctOfring(\'' + v.sbjctId + '\')"><spring:message code="sys.button.delete"/></button>'; // 삭제
                if($.trim(v.profId || '') != '') {
                    mngHtml += '<button type="button" class="btn basic small" onclick="fetchPrevSmstrSbjctOfring(\'' + v.sbjctId + '\')"><spring:message code="crs.button.prev.semester.fetch"/></button>'; // 이전학기 가져오기
                }
                mngHtml += "&nbsp;</div>";

                var sbjctnmText = escapeHtml(v.sbjctnm || "-");
                var sbjctnmHtml = '<a href="javascript:openSbjctOfringBasicInfoPop(\'' + v.sbjctId + '\')" title="' + sbjctnmText + '" class="header header-icon link">';
                sbjctnmHtml += sbjctnmText;
                sbjctnmHtml += '</a>';

                dataList.push({
                    no: lineNo,
                    orgnm: v.orgnm,
                    crsGbncdnm: v.crsGbncdnm,
                    sbjctTycdnm: v.sbjctTycdnm,
                    lctrGbncdnm: v.lctrGbncdnm,
                    sbjctCd: v.sbjctCd,
                    profId: v.profId,
                    sbjctnm: sbjctnmHtml,
                    dvclasNo: v.dvclasNo,
                    crdts: v.crdts,
                    cmcrsGbncdnm: v.cmcrsGbncdnm,
                    evlGbncdnm: v.evlGbncdnm,
                    profUsernm: v.profUsernm,
                    tutUsernm: v.tutUsernm,
                    atndlcCnt: v.atndlcCnt,
                    auditCnt: v.auditCnt,
                    atndlcCertStscd: v.atndlcCertStscd,
                    useyn: useynHtml,
                    mng: mngHtml,
                    regDttm: v.regDttm
                });
            });

            return dataList;
        }

        // 현재 검색 조건으로 과목개설 목록 엑셀 파일을 다운로드한다.
        function selectSbjctOfringListExcelDown() {
            var excelGrid = {
                colModel: [
                    {label:'No.', name:'lineNo', align:'center', width:'3000'},
                    {label:"<spring:message code='common.label.org'/>", name:'orgnm', align:'left', width:'7000'}, // 기관
                    {label:"<spring:message code='crs.label.course.division'/>", name:'crsGbncdnm', align:'center', width:'5000'}, // 과정구분
                    {label:"<spring:message code='crs.label.subject.type'/>", name:'sbjctTycdnm', align:'center', width:'5000'}, // 과목분류
                    {label:"<spring:message code='crs.label.crsopertypecd'/>", name:'lctrGbncdnm', align:'center', width:'5000'}, // 강의형태
                    {label:"<spring:message code='crs.label.subject.code'/>", name:'sbjctCd', align:'center', width:'5000'}, // 과목코드
                    {label:"<spring:message code='crs.label.subject.name'/>", name:'sbjctnm', align:'left', width:'10000'}, // 과목명
                    {label:"<spring:message code='common.label.decls.no'/>", name:'dvclasNo', align:'center', width:'3000'}, // 분반
                    {label:"<spring:message code='crs.label.credit'/>", name:'crdts', align:'center', width:'3000'}, // 학점
                    {label:"<spring:message code='crs.label.compdv'/>", name:'cmcrsGbncdnm', align:'center', width:'5000'}, // 이수구분
                    {label:"<spring:message code='crs.label.eval.method'/>", name:'evlGbncdnm', align:'center', width:'5000'}, // 평가방법
                    {label:"<spring:message code='common.charge.professor'/>", name:'profUsernm', align:'center', width:'5000'}, // 담당교수
                    {label:"<spring:message code='crs.label.charge.tutor'/>", name:'tutUsernm', align:'center', width:'5000'}, // 담당튜터
                    {label:"<spring:message code='common.label.students'/>", name:'atndlcCnt', align:'right', width:'4000'}, // 수강생
                    {label:"<spring:message code='crs.label.audit.student'/>", name:'auditCnt', align:'right', width:'4000'}, // 청강생
                    {label:"<spring:message code='main.common.use.yn'/>", name:'useyn', align:'center', width:'4000'} // 사용여부
                ]
            };

            $("form[name=excelForm]").remove();
            var excelForm = $('<form name="excelForm" method="post" ></form>');

            excelForm.attr("action", "/crs/sbjctOfring/admSbjctOfringListExcelDown.do");
            excelForm.append($('<input/>', {type: 'hidden', name: 'orgId', value: $("#selectOrg").val()}));
            excelForm.append($('<input/>', {type: 'hidden', name: 'searchValue', value: $("#searchValue").val()}));
            var yrSmstr = getSelectedYrSmstr();
            excelForm.append($('<input/>', {type: 'hidden', name: 'smstrChrtId', value: yrSmstr.smstrChrtId}));
            excelForm.append($('<input/>', {type: 'hidden', name: 'sbjctYr', value: yrSmstr.sbjctYr}));
            excelForm.append($('<input/>', {type: 'hidden', name: 'sbjctSmstr', value: yrSmstr.sbjctSmstr}));
            excelForm.append($('<input/>', {type: 'hidden', name: 'crsGbncd', value: $("#selectCrsGbncd").val()}));
            excelForm.append($('<input/>', {type: 'hidden', name: 'sbjctTycd', value: $("#selectSbjctTycd").val()}));
            excelForm.append($('<input/>', {type: 'hidden', name: 'excelGrid', value: JSON.stringify(excelGrid)}));
            excelForm.appendTo('body');
            excelForm.submit();
        }

        // 과목개설 등록 화면으로 이동한다.
        function viewSbjctOfringRegist() {
            location.href = '/crs/sbjctOfring/admSbjctOfringRegistView.do?encParams=' + EPARAM;
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

        // 과목개설 기본정보 팝업을 연다.
        function openSbjctOfringBasicInfoPop(sbjctId) {
            dialog = UiDialog("dialog1", {
                title: "<spring:message code='crs.sbjct.ofring.detail' />", /*과목개설 상세보기*/
                width: 1000,
                height: 620,
                url: "/crs/sbjctOfring/admSbjctOfringBasicInfoPop.do?sbjctId=" + encodeURIComponent(sbjctId || "") + "&encParams=" + EPARAM,
                autoresize: true
            });
        }

        // 과목개설 목록의 사용여부를 수정한다.
        function modifyUseyn(el, sbjctId) {
            var $el = $(el);
            var isChecked = $el.is(":checked");

            $el.prop("disabled", true);
            ajaxCall("/crs/sbjctOfring/admSbjctOfringUseynModify.do", {
                sbjctId: sbjctId,
                useyn: isChecked ? "Y" : "N"
            }, function(res) {
                $el.prop("disabled", false);
                if(res.result <= 0) {
                    $el.prop("checked", !isChecked);
                    UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>", "error"); // 오류가 발생했습니다!
                }
            }, function() {
                $el.prop("disabled", false);
                $el.prop("checked", !isChecked);
                UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error"); // 오류가 발생했습니다!
            });
        }

        // UiDialog 팝업을 닫는다.
        function closeDialog() {
            if(dialog) {
                dialog.close();
                dialog = null;
            }
        }

        // 과목개설 수강생 관리 화면으로 이동한다.
        function viewSbjctOfringAtndlc(sbjctId) {
            location.href = '/crs/sbjctOfring/admSbjctOfringStdntRegistView.do?sbjctId=' + encodeURIComponent(sbjctId || '') + '&encParams=' + EPARAM;
        }

        // 과목개설 관리자 관리 화면으로 이동한다.
        function viewSbjctOfringAdm(sbjctId) {
            location.href = '/crs/sbjctOfring/admSbjctOfringAdmRegistView.do?sbjctId=' + encodeURIComponent(sbjctId || '') + '&encParams=' + EPARAM;
        }

        // 과목개설 주차설정 화면으로 이동한다.
        function viewSbjctOfringWeekSetup(sbjctId) {
            location.href = '/crs/sbjctOfring/admSbjctOfringSchdlRegistView.do?sbjctId=' + encodeURIComponent(sbjctId || '') + '&encParams=' + EPARAM;
        }

        // 과목개설 상세보기 화면으로 이동한다.
        function viewSbjctOfringDetail(sbjctId) {
            location.href = '/crs/sbjctOfring/admSbjctOfringDetailView.do?sbjctId=' + encodeURIComponent(sbjctId || '') + '&encParams=' + EPARAM;
        }

        // 과목개설 수정 화면으로 이동한다.
        function viewSbjctOfringModify(sbjctId) {
            location.href = '/crs/sbjctOfring/admSbjctOfringRegistView.do?sbjctId=' + encodeURIComponent(sbjctId || '') + '&encParams=' + EPARAM;
        }

        // 과목개설을 삭제한다.
        function deleteSbjctOfring(sbjctId) {
            UiComm.showMessage("<spring:message code='crs.confirm.delete' />", "confirm") /* 정말 삭제하시겠습니까? */
                .then(function(result) {
                    if (result) {
                        $.ajax({
                            url: "/crs/sbjctOfring/admSbjctOfringDelete.do",
                            type: "POST",
                            data: {sbjctId: sbjctId},
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

        // 이전학기 과목개설 정보를 가져온다.
        function fetchPrevSmstrSbjctOfring(sbjctId) {
            dialog = UiDialog("dialog1", {
                title: "<spring:message code='crs.button.prev.semester.fetch' />", /*이전학기 가져오기*/
                width: 1000,
                height: 620,
                url: "/crs/creCrsMgr/admLoadBeforeSmstrView.do?sbjctId=" + encodeURIComponent(sbjctId || "") + "&encParams=" + EPARAM,
                autoresize: true
            });
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

        // 선택된 기관의 공통코드 목록을 조회한다.
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

        function fetchCodeList(upCd, targetSelector, selectedValue) {
            return $.ajax({
                url: "/crs/sbjctOfring/admOfringCmmnCdList.do",
                data: {
                    orgId: $("#selectOrg").val(),
                    upCd: upCd
                },
                success: function(res) {
                    var html = '<option value=""><spring:message code="crs.label.all" /></option>'; // 전체
                    if(res.result > 0) {
                        var returnList = res.returnList || [];
                        returnList.forEach(function(v, i) {
                            html += '<option value="' + v.cd + '">' + v.cdnm + '</option>';
                        });
                    }

                    $(targetSelector).empty();
                    $(targetSelector).html(html);
                    $(targetSelector).val(selectedValue || "");
                    $(targetSelector).trigger("chosen:updated");
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
                                <span class="item_tit"><label for="selectCrsGbncd"><spring:message code="crs.label.course.division"/><%--과정구분--%></label></span>
                                <div class="itemList">
                                    <select class="form-select w200 chosen" id="selectCrsGbncd">
                                        <option value=""><spring:message code="crs.label.all" /></option><%--전체--%>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="selectSbjctTycd"><spring:message code="crs.label.subject.type" /><%--과목분류--%></label></span>
                                <div class="itemList">
                                    <select class="form-select w200 chosen" id="selectSbjctTycd">
                                        <option value=""><spring:message code="crs.label.all" /></option><%--전체--%>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="searchValue"><spring:message code="common.search.keyword"/><%--검색어--%></label></span>
                                <div class="itemList">
                                    <input class="form-control" type="text" name="" id="searchValue" value="${sbjctListVO.searchValue}" placeholder="<spring:message code='crs.placeholder.subject.name.search'/><%--과목명 검색--%>">
                                </div>
                            </div>

                            <div class="button-area">
                                <button type="button" class="btn search" onclick="listPaging(1);"><spring:message code='button.search'/></button><%--검색--%>
                            </div>
                        </div>

                        <div id="sbjctOfringListArea">
                            <div class="board_top">
                                <h3 class="board-title"><spring:message code='forum.label.list' /></h3><%--목록--%>
                                <div class="right-area">
                                    <button type="button" class="btn type2" onclick="selectSbjctOfringListExcelDown();"><spring:message code="crs.button.excel.down"/><%--엑셀 다운로드--%></button>
                                    <button type="button" class="btn type2" onclick="viewSbjctOfringRegist();"><spring:message code="button.write" /><%--등록--%></button>
                                    <%-- 목록 스케일 선택 --%>
                                    <uiex:listScale func="changeListScale" value="${sbjctListVO.listScale}" />
                                </div>
                            </div>

                            <%-- 과목개설 리스트 --%>
                            <div id="sbjctOfringList"></div>

                            <script>
							<%-- 리스트 테이블 --%>
							let sbjctOfringListTable = UiTable("sbjctOfringList", {
								lang: "ko",
								initialSort: [{column:"regDttm", dir:"desc"}],
								pageFunc: listPaging,
								columns: [
									{title:"No", field:"no", headerHozAlign:"center", hozAlign:"center", width:40, minWidth:40}, // No
									{title:"<spring:message code='common.label.org'/>", field:"orgnm", headerHozAlign:"center", hozAlign:"left", width:160, minWidth:160, headerSort:true}, // 기관
									{title:"<spring:message code='crs.label.course.division'/>", field:"crsGbncdnm", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100, headerSort:true}, // 과정구분
									{title:"<spring:message code='crs.label.subject.type'/>", field:"sbjctTycdnm", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100, headerSort:true}, // 과목분류
									{title:"<spring:message code='crs.label.crsopertypecd'/>", field:"lctrGbncdnm", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100, headerSort:true}, // 강의형태
									{title:"<spring:message code='crs.label.subject.code'/>", field:"sbjctCd", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100}, // 과목코드
									{title:"<spring:message code='crs.label.subject.name'/>", field:"sbjctnm", headerHozAlign:"center", hozAlign:"left", width:0, minWidth:200, headerSort:true, frozen:true}, // 과목명
									{title:"<spring:message code='common.label.decls.no'/>", field:"dvclasNo", headerHozAlign:"center", hozAlign:"center", width:40, minWidth:40}, // 분반
									{title:"<spring:message code='crs.label.credit'/>", field:"crdts", headerHozAlign:"center", hozAlign:"center", width:40, minWidth:40}, // 학점
									{title:"<spring:message code='crs.label.compdv'/>", field:"cmcrsGbncdnm", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100}, // 이수구분
									{title:"<spring:message code='crs.label.eval.method'/>", field:"evlGbncdnm", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100}, // 평가방법
									{title:"<spring:message code='common.charge.professor'/>", field:"profUsernm", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100, headerSort:true}, // 담당교수
									{title:"<spring:message code='crs.label.charge.tutor'/>", field:"tutUsernm", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:100, headerSort:true}, // 담당튜터
									{title:"<spring:message code='common.label.students'/>", field:"atndlcCnt", headerHozAlign:"center", hozAlign:"right", width:60, minWidth:60}, // 수강생
									{title:"<spring:message code='crs.label.audit.student'/>", field:"auditCnt", headerHozAlign:"center", hozAlign:"right", width:60, minWidth:60}, // 청강생
									{title:"<spring:message code='main.common.use.yn'/>", field:"useyn", headerHozAlign:"center", hozAlign:"center", width:80, minWidth:80}, // 사용여부
									{title:"<spring:message code='common.mgr'/>", field:"mng", headerHozAlign:"center", hozAlign:"left", width:540, minWidth:540} // 관리
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
</body>
</html>
