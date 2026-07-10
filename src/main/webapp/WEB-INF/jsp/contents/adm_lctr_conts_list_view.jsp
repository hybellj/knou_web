<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin,classroom"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>

    <script type="text/javascript">
        var SEARCH_VALUE = '<c:out value="${contsPageInfo.searchValue}" />';
        var EPARAM = '<c:out value="${encParams}" />';
        var ORG_ID = '<c:out value="${orgId}" />';
        var FIXED_ORG_YN = '<c:out value="${fixedOrgYn}" />';
        var SMSTR_CHRT_ID = '<c:out value="${contsPageInfo.smstrChrtId}" />';
        var SBJCT_YR = '<c:out value="${contsPageInfo.sbjctYr}" />';
        var SBJCT_SMSTR = '<c:out value="${contsPageInfo.sbjctSmstr}" />';
        var SELECTED_SBJCT_ID = '';
        var YR_SMSTR_LIST = [];
        var WEEK_CONTENT_LIST = [];
        var WEEK_SORT_DIR = "ASC";
        var dialog = null;
        var SBJCT_YEAR_UNIT_TEXT = '<spring:message code="date.year"/>'; // 년
        var SBJCT_SMSTR_UNIT_TEXT = '<spring:message code="contents.label.semester.unit"/>'; // 학기
        var SBJCT_COHORT_UNIT_TEXT = '<spring:message code="contents.label.cohort.unit"/>'; // 기수

        $(document).ready(function() {
            $("#selectOrg").val(ORG_ID);
            if(FIXED_ORG_YN == "Y") {
                $("#selectOrg").prop("disabled", true);
            }
            $("#selectOrg").trigger("chosen:updated");

            reloadSearchOptions(function() {
                listPaging();
            });

            $("#searchValue").on("keydown", function(e) {
                if(e.keyCode == 13) {
                    listPaging();
                }
            });

            $("#selectOrg").on("change", function() {
                ORG_ID = $(this).val();
                SMSTR_CHRT_ID = "";
                SBJCT_YR = "";
                SBJCT_SMSTR = "";
                SELECTED_SBJCT_ID = "";
                clearWeekContentArea();
                reloadSearchOptions();
            });

            $("#selectYrSmstr").on("change", function() {
                setSelectedYrSmstrValues();
            });

            $("#weekFilter").on("change", function() {
                updateWeekToggleButtonText();
            });

            $("#weekCollapseBtn").on("click", function() {
                toggleWeekContents();
            });

            $("#weekSortAsc").on("click", function() {
                WEEK_SORT_DIR = "ASC";
                renderWeekContents(WEEK_CONTENT_LIST);
            });

            $("#weekSortDesc").on("click", function() {
                WEEK_SORT_DIR = "DESC";
                renderWeekContents(WEEK_CONTENT_LIST);
            });

            $(document).on("click", "#weekContentList .title-wrap > .title", function(e) {
                e.preventDefault();
                $(this).closest("li").toggleClass("active");
                updateWeekToggleButtonText();
            });
        });

        // 기관 변경 시 학사년도/학기 검색 옵션을 다시 구성한다.
        function reloadSearchOptions(callback) {
            $.when(fetchYrSmstrList()).always(function() {
                if($.isFunction(callback)) {
                    callback();
                }
            });
        }

        // 검색 조건에 맞는 과목 목록을 무페이징으로 조회한다.
        function listPaging() {
            SEARCH_VALUE = $("#searchValue").val();
            SELECTED_SBJCT_ID = "";
            WEEK_CONTENT_LIST = [];
            clearWeekContentArea();

            var yrSmstr = getSelectedYrSmstr();

            var param = {
                encParams: EPARAM,
                orgId: $("#selectOrg").val(),
                searchValue: SEARCH_VALUE,
                smstrChrtId: yrSmstr.smstrChrtId,
                sbjctYr: yrSmstr.sbjctYr,
                sbjctSmstr: yrSmstr.sbjctSmstr
            };

            UiComm.showLoading(true);
            ajaxCall("/contents/admConts/admLctrContsSbjctList.do", param, function(res) {
                if(res.encParams != null && res.encParams != "") {
                    EPARAM = res.encParams;
                }

                if(res.result > 0) {
                    var returnList = res.returnList || [];
                    updateSbjctTotalCount(returnList.length);
                    var dataList = createSbjctListData(returnList);
                    contsSbjctListTable.clearData();
                    contsSbjctListTable.replaceData(dataList);
                    SMSTR_CHRT_ID = yrSmstr.smstrChrtId;
                    SBJCT_YR = yrSmstr.sbjctYr;
                    SBJCT_SMSTR = yrSmstr.sbjctSmstr;
                } else {
                    updateSbjctTotalCount(0);
                    UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>", "error"); /* 에러가 발생했습니다! */
                }
            }, function() {
                updateSbjctTotalCount(0);
                UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error"); /* 에러가 발생했습니다! */
            });
        }

        // 현재 검색 조건으로 과목목록 엑셀 파일을 다운로드한다.
        function selectAdmLctrContsSbjctListExcelDown() {
            var yrSmstr = getSelectedYrSmstr();
            var excelGrid = {
                colModel: [
                    {label: "No.", name: "lineNo", align: "center", width: "3000"},
                    {label: "<spring:message code='contents.label.univ.org'/>", name: "orgnm", align: "left", width: "7000"}, /* 대학/기관 */
                    {label: "<spring:message code='contents.label.academic.year'/>", name: "sbjctYr", align: "center", width: "5000"}, /* 학사년도 */
                    {label: "<spring:message code='contents.label.semester'/>", name: "sbjctSmstr", align: "center", width: "5000"}, /* 학기 */
                    {label: "<spring:message code='contents.label.subject.code'/>", name: "sbjctCd", align: "center", width: "5000"}, /* 과목코드 */
                    {label: "<spring:message code='contents.label.subject.name'/>", name: "sbjctnm", align: "left", width: "10000"}, /* 과목명 */
                    {label: "<spring:message code='common.label.decls.no'/>", name: "dvclasNo", align: "center", width: "4000"} /* 분반 */
                ]
            };

            $("form[name=excelForm]").remove();
            var excelForm = $('<form name="excelForm" method="post"></form>');
            excelForm.attr("action", "/contents/admConts/admLctrContsSbjctListExcelDown.do");
            excelForm.append($('<input/>', {type: "hidden", name: "orgId", value: $("#selectOrg").val()}));
            excelForm.append($('<input/>', {type: "hidden", name: "searchValue", value: $("#searchValue").val()}));
            excelForm.append($('<input/>', {type: "hidden", name: "smstrChrtId", value: yrSmstr.smstrChrtId}));
            excelForm.append($('<input/>', {type: "hidden", name: "sbjctYr", value: yrSmstr.sbjctYr}));
            excelForm.append($('<input/>', {type: "hidden", name: "sbjctSmstr", value: yrSmstr.sbjctSmstr}));
            excelForm.append($('<input/>', {type: "hidden", name: "excelGrid", value: JSON.stringify(excelGrid)}));
            excelForm.appendTo("body");
            excelForm.submit();
        }

        // 무페이징 목록이므로 조회 결과 배열 길이를 총건수로 표시한다.
        function updateSbjctTotalCount(totalCount) {
            $("#sbjctTotalCount").html("[ <spring:message code='common.page.total.cnt'/> : <b>" + (totalCount || 0) + "</b><spring:message code='common.page.total_count'/> ]"); /* 총건수 / 건 */
        }

        // 서버 응답 과목 목록을 화면 표시용 행 데이터로 변환한다.
        function createSbjctListData(sbjctList) {
            var dataList = [];
            if(!sbjctList || sbjctList.length == 0) {
                return dataList;
            }

            sbjctList.forEach(function(v, index) {
                dataList.push({
                    no: index + 1,
                    orgnm: escapeHtml(v.orgnm),
                    sbjctYr: escapeHtml(formatSbjctYrNm(v)),
                    sbjctSmstr: escapeHtml(formatSbjctSmstrNm(v)),
                    sbjctCd: escapeHtml(v.sbjctCd),
                    sbjctnm: escapeHtml(v.sbjctnm),
                    dvclasNo: escapeHtml(v.dvclasNo),
                    sbjctId: escapeHtml(v.sbjctId)
                });
            });

            return dataList;
        }

        // 과목 학사년도에 단위 문구를 붙여 표시한다.
        function formatSbjctYrNm(sbjct) {
            var sbjctYr = String((sbjct && sbjct.sbjctYr) || "");
            if(!sbjctYr) {
                return "";
            }
            return sbjctYr + SBJCT_YEAR_UNIT_TEXT;
        }

        // 학기/기수 구분에 맞는 단위 문구를 붙여 과목 학기명을 표시한다.
        function formatSbjctSmstrNm(sbjct) {
            var sbjctSmstr = String((sbjct && sbjct.sbjctSmstr) || "");
            if(!sbjctSmstr) {
                return "";
            }
            var gbnCd = String((sbjct && sbjct.smstrChrtGbncd) || "SMSTR");
            return sbjctSmstr + (gbnCd == "SMSTR" ? SBJCT_SMSTR_UNIT_TEXT : SBJCT_COHORT_UNIT_TEXT);
        }

        // 선택 과목 정보를 보관하고 하단 강의목록을 다시 조회한다.
        function selectSbjct(sbjctId) {
            SELECTED_SBJCT_ID = sbjctId;
            $("#weekFilter").val("").trigger("chosen:updated");
            loadWeekContents();
        }

        // 선택한 과목의 강의주차별 학습자료 목록을 조회한다.
        function loadWeekContents() {
            if(!SELECTED_SBJCT_ID) {
                clearWeekContentArea();
                return;
            }

            UiComm.showLoading(true);
            ajaxCall("/contents/admConts/admLctrWknoContsList.do", {
                orgId: $("#selectOrg").val(),
                sbjctId: SELECTED_SBJCT_ID
            }, function(res) {
                if(res.result > 0) {
                    WEEK_CONTENT_LIST = res.returnList || [];
                    renderWeekFilterOptions(WEEK_CONTENT_LIST);
                    renderWeekContents(WEEK_CONTENT_LIST);
                } else {
                    UiComm.showMessage(res.message || "<spring:message code='fail.common.msg'/>", "error"); /* 에러가 발생했습니다! */
                }
            }, function() {
                UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error"); /* 에러가 발생했습니다! */
            });
        }

        // 강의주차 기준으로 학습자료를 묶어 하단 강의목록에 표시한다.
        function renderWeekContents(list) {
            var weekGroups = createWeekGroups(sortWeekList(list || []));
            if(weekGroups.length == 0) {
                $("#weekContentList").html('<ul class="accordion course_week"><li class="padding-4 text-center"><spring:message code="contents.msg.no.week"/></li></ul>'); /* 조회된 강의주차가 없습니다. */
                updateWeekToggleButtonText();
                return;
            }

            var html = '<ul class="accordion course_week">';
            weekGroups.forEach(function(group) {
                var stats = calculateWeekStats(group.contents);
                var seqCheckedAttr = group.seqLrnyn == "Y" ? ' checked="checked"' : '';
                var checkedAttr = group.oyn == "Y" ? ' checked="checked"' : '';
                html += '<li class="active" data-week-id="' + escapeHtml(group.weekId) + '">';
                html += '  <div class="title-wrap">';
                html += '    <a class="title" href="#0">';
                html += '      <i class="arrow xi-angle-down"></i>';
                html += '      <div>';
                html += '        <strong>[' + escapeHtml(group.lctrWkno || "-") + '<spring:message code="contents.label.week.suffix"/>]</strong> ' + escapeHtml(group.lctrWknonm || ""); /* 주차 */
                html += '        <span class="date">' + escapeHtml(formatWeekDateRange(group)) + '</span>';
                html += '      </div>';
                html += '    </a>';
                html += '    <div class="meta-action-bar">';
                html += '      <p class="desc">';
                html += '        <input type="checkbox" value="Y" class="switch" data-text="<spring:message code="contents.label.seq.learning"/>" data-week-id="' + escapeHtml(group.weekId) + '" onchange="modifyWeekSeqLrnyn(this)"' + seqCheckedAttr + '>'; /* 순차학습 */
                html += '        <input type="checkbox" value="Y" class="switch" data-text="<spring:message code="contents.label.week.open"/>" data-week-id="' + escapeHtml(group.weekId) + '" onchange="modifyWeekOyn(this)"' + checkedAttr + '>'; /* 오픈 */
                html += '        <span><spring:message code="contents.label.progress.video"/><strong>' + stats.videoCount + '</strong></span>'; /* 진도 영상 */
                html += '        <span><spring:message code="contents.label.learning.time"/><strong>' + escapeHtml(formatLearningTime(stats.videoMinutes)) + '</strong></span>'; /* 학습시간 */
                html += '        <span><spring:message code="contents.label.quiz"/><strong>' + stats.quizCount + '</strong></span>'; /* 연습문제 */
                html += '      </p>';
                html += '      <div class="btn_right">';
                html += '        <button type="button" class="btn s_type1" data-week-id="' + escapeHtml(group.weekId) + '" data-sbjct-id="' + escapeHtml(SELECTED_SBJCT_ID) + '" onclick="openWeekPreview(this)"><spring:message code="button.preview"/></button>'; /* 미리보기 */
                html += '        <button type="button" class="btn s_basic set" data-week-id="' + escapeHtml(group.weekId) + '" data-sbjct-id="' + escapeHtml(SELECTED_SBJCT_ID) + '" onclick="openWeekManage(this)"><spring:message code="contents.button.week.manage"/></button>'; /* 주차관리 */
                html += '      </div>';
                html += '    </div>';
                html += '  </div>';
                html += '  <div class="cont">';
                if(group.contents.length == 0) {
                    html += '<div class="nodata"><spring:message code="contents.msg.no.learning.material"/></div>'; /* 등록된 학습자료가 없습니다. */
                } else {
                    group.contents.forEach(function(item) {
                        html += buildContentItem(item);
                    });
                }
                html += buildLearningMaterialAddBox(group);
                html += '  </div>';
                html += '</li>';
            });
            html += '</ul>';
            $("#weekContentList").html(html);
            // 동적으로 생성한 주차 스위치를 공통 스위치 UI로 변환한다.
            UiSwitcher();
            updateWeekToggleButtonText();
        }

        // 학습자료 한 건을 강의목록 안의 콘텐츠 항목으로 표시한다.
        function buildContentItem(v) {
            var html = '';
            html += '<div class="lecture_box">';
            html += '  <div class="lecture_tit">';
            html += '    <p class="labels">';
            html += '      <label class="label s_basic width-5em">' + escapeHtml(contentTypeName(v.lctrContsTycd)) + '</label>';
            html += '    </p>';
            html += '    <strong>' + escapeHtml(v.lrnTocTtl || "-") + '</strong>';
            html += '  </div>';
            html += '  <div class="btn_right mr">';
            html += '    <button type="button" class="btn s_basic set"'
                    + ' data-conts-id="' + escapeHtml(v.lctrContsId || "") + '"'
                    + ' data-conts-type="' + escapeHtml(v.lctrContsTycd || "") + '"'
                    + ' data-week-id="' + escapeHtml(v.lctrWknoSchdlId || "") + '"'
                    + ' data-lctr-id="' + escapeHtml(v.lctrId || "") + '"'
                    + ' onclick="openLctrContsManagePop(this)"><spring:message code="contents.label.management"/></button>'; /* 관리 */
            html += '  </div>';
            html += '</div>';
            return html;
        }

        // 주차별 학습자료 추가 버튼 묶음을 표시한다.
        function buildLearningMaterialAddBox(group) {
            var items = [
                {icon: "icon-svg-play-circle", label: '<spring:message code="contents.label.video"/>', type: "VIDEO"}, /* 동영상 */
                {icon: "icon-svg-layout-alt", label: '<spring:message code="contents.label.pdf"/>'}, /* PDF */
                {icon: "icon-svg-paperclip", label: '<spring:message code="contents.label.file"/>'}, /* 파일 */
                {icon: "icon-svg-share", label: '<spring:message code="contents.label.social"/>', type: "SNS_URL"}, /* 소셜 */
                {icon: "icon-svg-link", label: '<spring:message code="contents.label.weblink"/>'}, /* 웹링크 */
                {icon: "icon-svg-type-square", label: '<spring:message code="contents.label.text"/>'}, /* 텍스트 */
                {icon: "icon-svg-exercise", label: '<spring:message code="contents.label.quiz"/>', type: "EXERC_QSTN"} /* 연습문제 */
            ];
            var html = '<div class="lecture_add_box flex">';
            html += '  <div class="box_item">';
            html += '    <div class="title"><spring:message code="contents.label.learning.material.add"/><i class="xi-plus-min"></i></div>'; /* 학습자료 추가 */
            html += '    <div class="item_btns">';
            items.forEach(function(item) {
                var onclick = createLctrContsAddOnclick(item.type, group);
                html += '<a href="#0" onclick="' + onclick + '; return false;">';
                html += '  <i class="' + item.icon + '" aria-hidden="true"></i>';
                html += '  <span>' + item.label + '</span>';
                html += '</a>';
            });
            html += '    </div>';
            html += '  </div>';
            html += '</div>';
            return html;
        }

        // 과목 선택 전 또는 검색 조건 변경 시 하단 강의목록을 초기화한다.
        function clearWeekContentArea() {
            WEEK_CONTENT_LIST = [];
            renderWeekFilterOptions([]);
            $("#weekCollapseBtn").text('<spring:message code="contents.label.week.collapse"/>'); /* 주차 접음 */
            $("#weekContentList").html('<ul class="accordion course_week"><li class="padding-4 text-center"><spring:message code="contents.msg.select.subject"/></li></ul>'); /* 과목의 콘텐츠 관리 클릭 후 이용 가능합니다. */
        }

        // 조회된 강의주차 목록을 주차 선택 옵션으로 구성한다.
        function renderWeekFilterOptions(list) {
            var weekGroups = createWeekGroups(list || []);
            var selectedWeekId = $("#weekFilter").val() || "";
            var selectedWeekExists = !selectedWeekId;
            var html = '<option value=""><spring:message code="contents.label.week.all"/></option>'; /* 전체 주차 */
            weekGroups.forEach(function(group) {
                if(selectedWeekId == group.weekId) {
                    selectedWeekExists = true;
                }
                html += '<option value="' + escapeHtml(group.weekId) + '">' + escapeHtml(group.lctrWkno || "-") + '<spring:message code="contents.label.week.suffix"/></option>'; /* 주차 */
            });
            $("#weekFilter").html(html);
            $("#weekFilter").val(selectedWeekExists ? selectedWeekId : "");
            $("#weekFilter").trigger("chosen:updated");
            updateWeekToggleButtonText();
        }

        // 정렬 방향에 맞게 강의주차 목록을 반환한다.
        function sortWeekList(list) {
            return (list || []).slice().sort(compareWeekContent);
        }

        // 주차/강의/콘텐츠 순서를 기준으로 정렬한다.
        function compareWeekContent(a, b) {
            var direction = WEEK_SORT_DIR == "DESC" ? -1 : 1;
            var weekCompare = compareNumber(a.lctrWknoSeqno, b.lctrWknoSeqno);
            if(weekCompare != 0) {
                return weekCompare * direction;
            }
            var lctrCompare = compareNumber(a.lctrSeqno, b.lctrSeqno);
            if(lctrCompare != 0) {
                return lctrCompare;
            }
            return compareNumber(a.contsSeqno, b.contsSeqno);
        }

        // 숫자형 정렬값을 비교한다.
        function compareNumber(a, b) {
            var numberA = Number(a || 0);
            var numberB = Number(b || 0);
            if(numberA == numberB) {
                return 0;
            }
            return numberA > numberB ? 1 : -1;
        }

        // 조회 결과를 강의주차 기준 그룹으로 변환한다.
        function createWeekGroups(list) {
            var weekGroups = [];
            var weekMap = {};
            (list || []).forEach(function(item) {
                var weekId = item.lctrWknoSchdlId || "";
                if(!weekMap[weekId]) {
                    weekMap[weekId] = {
                        weekId: weekId,
                        lctrWkno: item.lctrWkno,
                        lctrWknonm: item.lctrWknonm,
                        lctrWknoSeqno: item.lctrWknoSeqno,
                        lctrWknoSymd: item.lctrWknoSymd,
                        lctrWknoEymd: item.lctrWknoEymd,
                        lctrId: item.lctrId,
                        seqLrnyn: item.seqLrnyn,
                        oyn: item.oyn,
                        contents: []
                    };
                    weekGroups.push(weekMap[weekId]);
                }
                if(item.lctrContsId) {
                    weekMap[weekId].contents.push(item);
                }
            });
            return weekGroups;
        }

        // 주차별 영상 시간과 연습문제 수를 계산한다.
        function calculateWeekStats(contents) {
            var stats = {
                videoCount: 0,
                videoMinutes: 0,
                quizCount: 0
            };
            (contents || []).forEach(function(item) {
                if(isVideoContent(item)) {
                    stats.videoCount++;
                    stats.videoMinutes += getContentMinutes(item);
                }
                if(isQuizContent(item)) {
                    stats.quizCount++;
                }
            });
            return stats;
        }

        // 콘텐츠가 진도 영상인지 판별한다.
        function isVideoContent(item) {
            var contentType = String(item.lctrContsTycd || "").toUpperCase();
            return contentType == "VDO" || contentType == "VIDEO" || contentType == "VIDEO_LINK" || getContentMinutes(item) > 0;
        }

        // 콘텐츠가 연습문제인지 판별한다.
        function isQuizContent(item) {
            var contentType = String(item.lctrContsTycd || "").toUpperCase();
            return contentType == "QUIZ" || contentType == "QSTN" || contentType == "EXRCS" || contentType == "EXERC_QSTN" || !!item.exrcsQstnId || Number(item.sddnQstnCnt || 0) > 0;
        }

        // 콘텐츠 학습시간을 숫자 분 단위로 변환한다.
        function getContentMinutes(item) {
            var minutes = Number((item || {}).vdoMnts || 0);
            return isNaN(minutes) ? 0 : minutes;
        }

        // 선택한 주차 또는 전체 주차를 접거나 펼친다.
        function toggleWeekContents() {
            var $items = getWeekToggleTargets();
            if($items.length == 0) {
                return;
            }
            var shouldCollapse = $("#weekCollapseBtn").text() == '<spring:message code="contents.label.week.collapse"/>'; /* 주차 접음 */
            $items.toggleClass("active", !shouldCollapse);
            updateWeekToggleButtonText();
        }

        // 주차 선택값을 기준으로 접기/펼치기 대상 항목을 반환한다.
        function getWeekToggleTargets() {
            var selectedWeekId = $("#weekFilter").val();
            var $items = $("#weekContentList .course_week > li").has(".title-wrap");
            if(!selectedWeekId) {
                return $items;
            }
            return $items.filter(function() {
                return $(this).attr("data-week-id") == selectedWeekId;
            });
        }

        // 선택 대상의 펼침 상태에 맞춰 주차 버튼 문구를 갱신한다.
        function updateWeekToggleButtonText() {
            var $items = getWeekToggleTargets();
            if($items.length == 0) {
                $("#weekCollapseBtn").text('<spring:message code="contents.label.week.collapse"/>'); /* 주차 접음 */
                return;
            }
            var hasActive = $items.filter(".active").length > 0;
            $("#weekCollapseBtn").text(hasActive ? '<spring:message code="contents.label.week.collapse"/>' : '<spring:message code="contents.label.week.expand"/>'); /* 주차 접음 / 주차 펼침 */
        }

        // 주차 순차학습여부를 저장하고 요청 중에는 해당 스위치의 중복 변경을 막는다.
        function modifyWeekSeqLrnyn(el) {
            var $el = $(el);
            var isChecked = $el.is(":checked");
            var weekId = $el.attr("data-week-id");
            if(!weekId) {
                $el.prop("checked", !isChecked);
                UiComm.showMessage('<spring:message code="contents.msg.select.week"/>', "error"); /* 주차를 선택해 주세요. */
                return;
            }

            setWeekSwitchDisabled($el, true);
            ajaxCall("/contents/admConts/admLctrWknoSeqLrnynModify.do", {
                orgId: $("#selectOrg").val(),
                sbjctId: SELECTED_SBJCT_ID,
                lctrWknoSchdlId: weekId,
                seqLrnyn: isChecked ? "Y" : "N"
            }, function(data) {
                setWeekSwitchDisabled($el, false);
                if(data.result > 0) {
                    syncWeekSeqLrnyn(weekId, isChecked ? "Y" : "N");
                } else {
                    $el.prop("checked", !isChecked);
                    UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>", "error"); /* 에러가 발생했습니다! */
                }
            }, function() {
                setWeekSwitchDisabled($el, false);
                $el.prop("checked", !isChecked);
                UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error"); /* 에러가 발생했습니다! */
            });
        }

        // 주차 공개여부를 저장하고 요청 중에는 해당 스위치의 중복 변경을 막는다.
        function modifyWeekOyn(el) {
            var $el = $(el);
            var isChecked = $el.is(":checked");
            var weekId = $el.attr("data-week-id");
            if(!weekId) {
                $el.prop("checked", !isChecked);
                UiComm.showMessage('<spring:message code="contents.msg.select.week"/>', "error"); /* 주차를 선택해 주세요. */
                return;
            }

            setWeekSwitchDisabled($el, true);
            ajaxCall("/contents/admConts/admLctrWknoOynModify.do", {
                orgId: $("#selectOrg").val(),
                sbjctId: SELECTED_SBJCT_ID,
                lctrWknoSchdlId: weekId,
                oyn: isChecked ? "Y" : "N"
            }, function(data) {
                setWeekSwitchDisabled($el, false);
                if(data.result > 0) {
                    syncWeekOyn(weekId, isChecked ? "Y" : "N");
                } else {
                    $el.prop("checked", !isChecked);
                    UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>", "error"); /* 에러가 발생했습니다! */
                }
            }, function() {
                setWeekSwitchDisabled($el, false);
                $el.prop("checked", !isChecked);
                UiComm.showMessage("<spring:message code='fail.common.msg'/>", "error"); /* 에러가 발생했습니다! */
            });
        }

        // 주차 스위치의 입력 요소와 표시 요소 disabled 상태를 함께 변경한다.
        function setWeekSwitchDisabled($el, disabled) {
            $el.prop("disabled", disabled);
            $("#sw_" + $el.attr("id")).toggleClass("disabled", disabled);
        }

        // 저장된 주차 순차학습여부를 현재 목록 데이터에 반영한다.
        function syncWeekSeqLrnyn(weekId, seqLrnyn) {
            (WEEK_CONTENT_LIST || []).forEach(function(item) {
                if(item.lctrWknoSchdlId == weekId) {
                    item.seqLrnyn = seqLrnyn;
                }
            });
        }

        // 저장된 주차 공개여부를 현재 목록 데이터에 반영한다.
        function syncWeekOyn(weekId, oyn) {
            (WEEK_CONTENT_LIST || []).forEach(function(item) {
                if(item.lctrWknoSchdlId == weekId) {
                    item.oyn = oyn;
                }
            });
        }

        // 아직 구현하지 않은 학습자료 유형의 준비중 메시지를 표시한다.
        function showPrepareMessage() {
            UiComm.showMessage('<spring:message code="contents.msg.feature.prepare"/>', "info"); /* 준비 중입니다. */
        }

        // 학습자료 유형별 신규 등록 팝업 호출 스크립트를 반환한다.
        function createLctrContsAddOnclick(contsType, group) {
            if(contsType == "VIDEO") {
                return 'openLctrContsVideoRegistPop(\'' + escapeJs(group.weekId || "") + '\', \'' + escapeJs(group.lctrId || "") + '\', \'\', \'C\')';
            }
            if(contsType == "EXERC_QSTN") {
                return 'openLctrContsExrcsQstnRegistPop(\'' + escapeJs(group.weekId || "") + '\', \'' + escapeJs(group.lctrId || "") + '\', \'\', \'C\')';
            }
            if(contsType == "SNS_URL") {
                return 'openLctrContsSnsRegistPop(\'' + escapeJs(group.weekId || "") + '\', \'' + escapeJs(group.lctrId || "") + '\', \'\', \'C\', \'SNS_URL\')';
            }
            return 'showPrepareMessage()';
        }

        // 콘텐츠 유형별 수정 팝업을 분기한다.
        function openLctrContsManagePop(button) {
            var $button = $(button);
            var contsType = String($button.attr("data-conts-type") || "").toUpperCase();
            if(contsType == "VIDEO") {
                return openLctrContsVideoRegistPop($button.attr("data-week-id"), $button.attr("data-lctr-id"), $button.attr("data-conts-id"), "E");
            }
            if(contsType == "EXERC_QSTN") {
                return openLctrContsExrcsQstnRegistPop($button.attr("data-week-id"), $button.attr("data-lctr-id"), $button.attr("data-conts-id"), "E");
            }
            if(contsType == "SNS_URL" || contsType == "SNS_HTML") {
                return openLctrContsSnsRegistPop($button.attr("data-week-id"), $button.attr("data-lctr-id"), $button.attr("data-conts-id"), "E", contsType);
            }
            showPrepareMessage();
            return false;
        }

        // 동영상 학습자료 등록 팝업을 연다.
        function openLctrContsVideoRegistPop(weekId, lctrId, lctrContsId, mode) {
            if(!SELECTED_SBJCT_ID || !weekId || !lctrId) {
                UiComm.showMessage('<spring:message code="contents.msg.select.week"/>', "warning"); /* 주차를 선택해 주세요. */
                return false;
            }

            // mode는 화면 표시용이며 저장 분기는 콘텐츠 ID로 판단한다.
            var param = {
                orgId: $("#selectOrg").val(),
                sbjctId: SELECTED_SBJCT_ID,
                lctrWknoSchdlId: weekId,
                lctrId: lctrId,
                lctrContsTycd: "VIDEO",
                lctrContsId: lctrContsId || "",
                mode: mode || "C",
                encParams: EPARAM
            };
            dialog = UiDialog("dialog1", {
                title: "<spring:message code='contents.label.video'/>", /* 동영상 */
                width: 1200,
                height: 760,
                url: "/contents/admConts/admLctrContsVideoRegistPop.do?" + $.param(param),
                autoresize: true
            });
            return false;
        }

        // 연습문제 학습자료 등록/수정 팝업을 연다.
        function openLctrContsExrcsQstnRegistPop(weekId, lctrId, lctrContsId, mode) {
            if(!SELECTED_SBJCT_ID || !weekId || !lctrId) {
                UiComm.showMessage('<spring:message code="contents.msg.select.week"/>', "warning"); /* 주차를 선택해 주세요. */
                return false;
            }

            var param = {
                orgId: $("#selectOrg").val(),
                sbjctId: SELECTED_SBJCT_ID,
                lctrWknoSchdlId: weekId,
                lctrId: lctrId,
                lctrContsTycd: "EXERC_QSTN",
                lctrContsId: lctrContsId || "",
                mode: mode || "C",
                encParams: EPARAM
            };
            dialog = UiDialog("dialog1", {
                title: "<spring:message code='contents.label.quiz'/>", /* 연습문제 */
                width: 1200,
                height: 720,
                url: "/contents/admConts/admLctrContsExrcsQstnRegistPop.do?" + $.param(param),
                autoresize: true
            });
            return false;
        }

        // 소셜 학습자료 등록/수정 팝업을 연다.
        function openLctrContsSnsRegistPop(weekId, lctrId, lctrContsId, mode, contsType) {
            if(!SELECTED_SBJCT_ID || !weekId || !lctrId) {
                UiComm.showMessage('<spring:message code="contents.msg.select.week"/>', "warning"); /* 주차를 선택해 주세요. */
                return false;
            }

            var param = {
                orgId: $("#selectOrg").val(),
                sbjctId: SELECTED_SBJCT_ID,
                lctrWknoSchdlId: weekId,
                lctrId: lctrId,
                lctrContsTycd: contsType || "SNS_URL",
                lctrContsId: lctrContsId || "",
                mode: mode || "C",
                encParams: EPARAM
            };
            dialog = UiDialog("dialog1", {
                title: "<spring:message code='contents.label.social'/>", /* 소셜 */
                width: 1000,
                height: 720,
                url: "/contents/admConts/admLctrContsSnsRegistPop.do?" + $.param(param),
                autoresize: true
            });
            return false;
        }

        // 학습자료 저장 후 강의목록을 다시 조회한다.
        function afterLctrContsSave() {
            closeDialog();
            loadWeekContents();
        }

        // 강의 미리보기 팝업 연결 전 주차 버튼의 기본 동작을 처리한다.
        function openWeekPreview(button) {
            if(!validateWeekActionButton(button)) {
                return false;
            }
            showPrepareMessage();
            return false;
        }

        // 주차관리 팝업 연결 전 주차 버튼의 기본 동작을 처리한다.
        function openWeekManage(button) {
            if(!validateWeekActionButton(button)) {
                return false;
            }
            var $button = $(button);
            var param = {
                orgId: $("#selectOrg").val(),
                sbjctId: SELECTED_SBJCT_ID,
                lctrWknoSchdlId: $button.attr("data-week-id"),
                encParams: EPARAM
            };
            dialog = UiDialog("dialog1", {
                title: "<spring:message code='contents.button.week.manage'/>", /* 주차관리 */
                width: 1024,    // Uidialog 인에 table-type5 의 반응형 처리를 막기 위해 width 자릿수를 늘림.
                height: 240,
                url: "/contents/admConts/admLctrWknoSchdlMngPop.do?" + $.param(param),
                autoresize: true
            });
            return false;
        }

        // UiDialog 팝업을 닫는다.
        function closeDialog() {
            if(dialog) {
                dialog.close();
                dialog = null;
            }
        }

        // 주차관리 팝업 저장 후 강의주차 목록을 다시 조회한다.
        function afterLctrWknoSchdlSave() {
            closeDialog();
            loadWeekContents();
        }

        // 주차 단위 버튼에 필요한 과목과 주차 식별값을 확인한다.
        function validateWeekActionButton(button) {
            var $button = $(button);
            if(!SELECTED_SBJCT_ID || !$button.attr("data-week-id")) {
                UiComm.showMessage('<spring:message code="contents.msg.select.week"/>', "error"); /* 주차를 선택해 주세요. */
                return false;
            }
            return true;
        }

        // 기관 기준 학사년도/학기 검색 옵션을 조회한다.
        function fetchYrSmstrList() {
            return $.ajax({
                url: "/common/admYrSmstrSelect.do",
                data: {
                    orgId: $("#selectOrg").val()
                },
                success: function(res) {
                    YR_SMSTR_LIST = [];
                    if(res.result > 0) {
                        YR_SMSTR_LIST = res.returnList || [];
                    }
                    renderYrSmstrOptions();
                }
            });
        }

        function renderYrSmstrOptions() {
            var html = "";
            var selectedValue = "";

            YR_SMSTR_LIST.forEach(function(v) {
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
            if(!selectedValue && YR_SMSTR_LIST.length > 0) {
                selectedValue = YR_SMSTR_LIST[0].smstrChrtId || "";
            }
            $("#selectYrSmstr").val(selectedValue).trigger("chosen:updated");
            setSelectedYrSmstrValues();
        }

        // 선택된 학사년도/학기 값을 검색 파라미터 상태값으로 보관한다.
        function setSelectedYrSmstrValues() {
            var yrSmstr = getSelectedYrSmstr();
            SMSTR_CHRT_ID = yrSmstr.smstrChrtId;
            SBJCT_YR = yrSmstr.sbjctYr;
            SBJCT_SMSTR = yrSmstr.sbjctSmstr;
        }

        // 학사년도/학기 select의 선택값과 데이터 속성을 조회한다.
        function getSelectedYrSmstr() {
            var $option = $("#selectYrSmstr option:selected");
            return {
                smstrChrtId: $option.val() || "",
                sbjctYr: $option.attr("data-dgrs-yr") || "",
                sbjctSmstr: $option.attr("data-dgrs-smstr-chrt") || ""
            };
        }

        // 현재 학기로 표시된 항목인지 판별한다.
        function isCurrentYrSmstr(v) {
            return (v.nowSmstryn || v.nowSmstrYn || "") == "Y";
        }

        // 학사년도/학기 응답에서 연도 값을 읽는다.
        function getDgrsYr(v) {
            return v.yr || v.dgrsYr || "";
        }

        // 학사년도/학기 응답에서 학기 값을 읽는다.
        function getDgrsSmstrChrt(v) {
            return v.smstr || v.dgrsSmstrChrt || "";
        }

        // 학사년도/학기 응답에서 화면 표시명을 읽는다.
        function getYrSmstrName(v) {
            return v.yrSmstrnm || v.yrSmstrNm || "";
        }

        // YYYYMMDD 형식의 날짜를 화면 표시 형식으로 변환한다.
        function formatDate(value) {
            value = String(value || "");
            if(value.length != 8) {
                return value;
            }
            return value.substring(0, 4) + "." + value.substring(4, 6) + "." + value.substring(6, 8);
        }

        // 주차 시작일과 종료일을 표시 형식으로 변환한다.
        function formatWeekDateRange(group) {
            var startDate = formatDate(group.lctrWknoSymd);
            var endDate = formatDate(group.lctrWknoEymd);
            if(!startDate && !endDate) {
                return "";
            }
            return startDate + " ~ " + endDate;
        }

        // 분 단위 학습시간을 HH:MM:SS 형식으로 표시한다.
        function formatLearningTime(minutes) {
            var totalSeconds = Number(minutes || 0);
            var hours = Math.floor(totalSeconds / 3600);
            var mins = Math.floor((totalSeconds % 3600) / 60);
            var seconds = totalSeconds % 60;
            return pad2(hours) + ":" + pad2(mins) + ":" + pad2(seconds);
        }

        // 한 자리 숫자 앞에 0을 붙인다.
        function pad2(value) {
            value = Number(value || 0);
            return value < 10 ? "0" + value : String(value);
        }

        // 학습자료 유형 코드를 화면 표시명으로 변환한다.
        function contentTypeName(value) {
            var names = {
                VIDEO: '<spring:message code="contents.label.video"/>', /* 동영상 */
                PDF: '<spring:message code="contents.label.pdf"/>', /* PDF */
                ETC_FILE: '<spring:message code="contents.label.file"/>', /* 파일 */
                SNS_URL: '<spring:message code="contents.label.social"/>', /* 소셜URL */
                SNS_HTML: '<spring:message code="contents.label.social"/>', /* 소셜HTML */
                WEBLINK: '<spring:message code="contents.label.weblink"/>', /* 웹링크 */
                LTI: '<spring:message code="contents.label.lti"/>', /* LTI */
                TEXT: '<spring:message code="contents.label.text"/>', /* 텍스트 */
                SRT: '<spring:message code="contents.label.multilingual.subtitle"/>', /* 자막 */
                EXERC_QSTN: '<spring:message code="contents.label.quiz"/>', /* 연습문제 */
                SDDN_QSTN: '<spring:message code="contents.label.sudden.quiz"/>' /* 돌발퀴즈 */
            };
            return names[value] || value || "-";
        }

        // 동적 HTML 문자열에 사용자/DB 값을 넣기 전 HTML 특수문자를 치환한다.
        function escapeHtml(value) {
            return String(value || "")
                    .replace(/&/g, "&amp;")
                    .replace(/</g, "&lt;")
                    .replace(/>/g, "&gt;")
                    .replace(/"/g, "&quot;")
                    .replace(/'/g, "&#39;");
        }

        // 문자열을 인라인 JavaScript 인자로 사용할 수 있게 이스케이프한다.
        function escapeJs(value) {
            return String(value == null ? "" : value)
                    .replace(/\\/g, "\\\\")
                    .replace(/'/g, "\\'")
                    .replace(/\r/g, "")
                    .replace(/\n/g, " ");
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
                                <span class="item_tit"><label for="selectOrg"><spring:message code="contents.label.org"/> <%-- 기관 --%></label></span>
                                <div class="itemList">
                                    <select class="form-select w200 chosen" id="selectOrg" title="<spring:message code='contents.label.org.select'/>"><%-- 기관 선택 --%>
                                        <c:forEach var="org" items="${orgList}">
                                            <option value="${org.orgId}"><c:out value="${org.orgnm}" /></option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="selectYrSmstr"><spring:message code="contents.label.yr.smstr.chrt"/> <%-- 년도/학기(기수) --%></label></span>
                                <div class="itemList">
                                    <select class="form-select w200 chosen" id="selectYrSmstr" title="<spring:message code='contents.label.yr.smstr.select'/>"></select><%-- 연도/학기 선택 --%>
                                </div>
                            </div>
                            <div class="item">
                                <span class="item_tit"><label for="searchValue"><spring:message code="contents.label.search.word"/> <%-- 검색어 --%></label></span>
                                <div class="itemList">
                                    <input class="form-control" type="text" id="searchValue" value="${contsPageInfo.searchValue}" placeholder="<spring:message code='contents.placeholder.sbjct.search'/>"><%-- 과목명, 과목코드 검색 --%>
                                </div>
                            </div>
                            <div class="button-area">
                                <button type="button" class="btn search" onclick="listPaging();"><spring:message code="common.button.search"/> <%-- 검색 --%></button>
                            </div>
                        </div>

                        <%-- 과목 목록 영역 --%>
                        <div class="board_top">
                            <h3 class="board-title"><spring:message code="contents.label.list"/> <%-- 목록 --%><span class="total_txt fs-16px fw-normal ml5" id="sbjctTotalCount">[ <spring:message code="common.page.total.cnt"/> <%-- 총건수 --%> : <b>0</b><spring:message code="common.page.total_count"/> <%-- 건 --%> ]</span></h3>
                            <div class="right-area">
                                <button type="button" class="btn type2" onclick="selectAdmLctrContsSbjctListExcelDown();"><spring:message code="common.button.excel_down"/> <%-- 엑셀다운로드 --%></button>
                            </div>
                        </div>

                        <div id="contsSbjctList"></div>

                        <script>
                            var contsSbjctListTable = UiTable("contsSbjctList", {
                                lang: "ko",
                                initialSort: [{column:"no", dir:"asc"}],
                                selectRow: "1",
                                selectRowFunc: selectSontsSbjct,
                                height: 400,
                                columns: [
                                    {title:"No", field:"no", headerHozAlign:"center", hozAlign:"center", width:40, minWidth:40},
                                    {title:"<spring:message code='contents.label.univ.org'/>" /* 대학/기관 */, field:"orgnm", headerHozAlign:"center", hozAlign:"left", width:160, minWidth:120, 	headerSort:true},
                                    {title:"<spring:message code='contents.label.academic.year'/>" /* 학사년도 */, field:"sbjctYr", headerHozAlign:"center", hozAlign:"center", width:100, minWidth:90},
                                    {title:"<spring:message code='contents.label.semester'/>" /* 학기 */, field:"sbjctSmstr", headerHozAlign:"center", hozAlign:"center", width:80, minWidth:70},
                                    {title:"<spring:message code='contents.label.subject.code'/>" /* 과목코드 */, field:"sbjctCd", headerHozAlign:"center", hozAlign:"center", width:110, minWidth:90},
                                    {title:"<spring:message code='contents.label.subject.name'/>" /* 과목명 */, field:"sbjctnm", headerHozAlign:"center", hozAlign:"left", width:0, minWidth:180, 	headerSort:true},
                                    {title:"<spring:message code='common.label.decls.no'/>" /* 분반 */, field:"dvclasNo", headerHozAlign:"center", hozAlign:"center", width:80, minWidth:70},
                                ]
                            });

                            // Row 선택
                            function selectSontsSbjct(data) {
                                var sbjctId = data["sbjctId"];
                                var sbjctNm = data["sbjctNm"];
                                if (sbjctId !== undefined && sbjctId !== '') {
                                    selectSbjct(sbjctId, sbjctNm);
                                }
                            }
                        </script>

                        <div class="class_sub mt30">
                            <div class="segment pd0">
                                <div class="board_top">
                                    <i class="icon-svg-openbook"></i>
                                    <h3><spring:message code="contents.label.lecture.list"/> <%-- 강의목록 --%></h3>
                                </div>

                                <div class="board_top course">
                                    <button type="button" class="btn basic" id="weekCollapseBtn"><spring:message code="contents.label.week.collapse"/> <%-- 주차 접음 --%></button>
                                    <select class="form-select chosen" id="weekFilter" title="<spring:message code='contents.label.week.select'/>"><%-- 주차 선택 --%>
                                        <option value=""><spring:message code="contents.label.week.all"/> <%-- 전체 주차 --%></option>
                                    </select>
                                    <div class="right-area">
                                        <button type="button" class="btn basic icon" id="weekSortAsc" aria-label="주차 오름차순"><i class="xi-sort-asc"></i></button>
                                        <button type="button" class="btn basic icon" id="weekSortDesc" aria-label="주차 내림차순"><i class="xi-sort-desc"></i></button>
                                    </div>
                                </div>

                                <div class="course_list" id="weekContentList">
                                    <ul class="accordion course_week">
                                        <li class="padding-4 text-center"><spring:message code="contents.msg.select.subject"/> <%-- 과목의 콘텐츠 관리 클릭 후 이용 가능합니다. --%></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
    <%@ include file="/WEB-INF/jsp/common/admin/admin_footer.jsp" %>
</body>
</html>
