<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
    <%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/editor_inc.jsp" %>
    <link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2"/>
</head>

<div id="loading_page">
    <p><i class="notched circle loading icon"></i></p>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        if (${not empty vo.acadSchSn}) {
            initSchForm("${vo.calendarCtgr}");
        } else {
            if (${menuType eq 'PROFESSOR'}) {
                initSchForm('course');
            } else {
                initSchForm('personal');
            }
        }
        creCrsList();
    });

    // 일정 등록 폼 생성
    function initSchForm(type) {
        $("#writeAcadSchForm input[name=calendarCtgr]").val(type);
        var infoTitle = type == "course" ? "<spring:message code='dashboard.cal_course' />" : "<spring:message code='dashboard.cal_private' />";/* 과목 *//* 개인 */
        var gubun = ${not empty vo.acadSchSn} ? "<spring:message code='common.button.modify' />" : "<spring:message code='common.button.create' />";/* 수정 *//* 등록 */
        var html = "<h3 class='graduSch mb20'>" + infoTitle + " <spring:message code='dashboard.cal_schedule' /> " + gubun + "</h3>";/* 일정 */
        $("#schDiv").empty().append(html);
        if (type == "course") {
            courseSchForm();
        }
        commonSchForm();
    }

    // 공통 폼
    function commonSchForm() {
        var html = "<ul class='tbl-simple'>";
        html += "	<li>";
        html += "		<dl>";
        html += "			<dt class='p_w10'>";
        html += "				<label for='acadSchNm' class='req'><spring:message code='dashboard.cal_title' /></label>";/* 제 목 */
        html += "			</dt>";
        html += "			<dd class='pr50'>";
        html += "				<div class='ui fluid input'>";
        html += "					<input type='text' name='acadSchNm' id='acadSchNm' maxlength='20' placeholder=\"" + "<spring:message code='dashboard.cal_input_20' />" + "\" value='${vo.acadSchNm}' />";/* 20자 이내 입력 */
        html += "				</div>";
        html += "			</dd>";
        html += "		</dl>";
        html += "	</li>";
        html += "	<li>";
        html += "		<dl>";
        html += "			<dt class='p_w10'>";
        html += "				<label for='schStartFmt' class='req'><spring:message code='dashboard.cal_date' /></label>";/* 날 짜 */
        html += "			</dt>";
        html += "			<dd>";
        html += "				<div class='fields gap4'>";
        html += "					<div class='field flex' style='z-index:1000'>";
        html += "						<div class='ui calendar rangestart w150 mr5' id='rangestart' range='endCalendar,rangeend' dateval='${vo.schStartDt}'>";
        html += "							<div class='ui input left icon'>";
        html += "								<i class='calendar alternate outline icon'></i>";
        html += "								<input type='text' id='schStartFmt' name='schStartFmt' placeholder=\"" + "<spring:message code='dashboard.cal_start_date' />" + "\" value=''>";/* 시작 일시 */
        html += "							</div>";
        html += "						</div>";
        html += "                       <select class='ui dropdown list-num flex0 mr5 m-w70' id='schStartFmtHH' caltype='hour'>";
        html += "                           <option value=' '><spring:message code='date.hour'/></option>";
        html += "                       </select>";
        html += "                       <select class='ui dropdown list-num flex0 mr5 m-w70' id='schStartFmtMM' caltype='min'>";
        html += "                           <option value=' '><spring:message code='date.minute'/></option>";
        html += "                       </select>";
        html += "					</div>";
        html += "                   <div class='field p0 flex-item desktop-elem'>~</div>";
        html += "					<div class='field flex' style='z-index:1000'>";
        html += "						<div class='ui calendar rangeend w150 mr5' id='rangeend' range='startCalendar,rangestart' dateval='${vo.schEndDt}'>";
        html += "							<div class='ui input left icon'>";
        html += "								<i class='calendar alternate outline icon'></i>";
        html += "								<input type='text' id='schEndFmt' name='schEndFmt' placeholder=\"" + "<spring:message code='dashboard.cal_end_date' />" + "\" value=''>";/* 종료 일시 */
        html += "							</div>";
        html += "						</div>";
        html += "                       <select class='ui dropdown list-num flex0 mr5 m-w70' id='schEndFmtHH' caltype='hour'>";
        html += "                           <option value=' '><spring:message code='date.hour'/></option>";
        html += "                       </select>";
        html += "                       <select class='ui dropdown list-num flex0 mr5 m-w70' id='schEndFmtMM' caltype='min'>";
        html += "                           <option value=' '><spring:message code='date.minute'/></option>";
        html += "                       </select>";
        html += "					</div>";
        html += "				</div>";
        html += "			</dd>";
        html += "		</dl>";
        html += "	</li>";
        html += "	<li>";
        html += "		<dl>";
        html += "			<dt>";
        html += "				<label for='schCnts'><spring:message code='dashboard.cal_content' /></label>";/* 설 명 */
        html += "			</dt>";
        html += "			<dd></dd>";
        html += "		</dl>";
        html += "	</li>";
        html += "	<dl style='display:table;width:100%;'><dd style='height:400px;display:table-cell'>";
        html += "		<div style='height:100%;'>";
        html += `			<textarea name='schCnts' id='schCnts'>${vo.schCnts}</textarea>`;
        html += "		</div>";
        html += '	</dd></dl>';
        html += "</ul>";
        $("#schDiv").append(html);

        // 날짜/시간/분 선택 calendar 초기화
        initCalendar();
        $('.ui.dropdown').dropdown();

        var editor = HtmlEditor('schCnts', THEME_MODE, '/sch');
    }

    // 과목 일정 폼
    function courseSchForm() {
        var radioMap = new Map([
            ["all", "<spring:message code='dashboard.cal_type_all' />"],/* 해당없음 */
            ["lesson", "<spring:message code='dashboard.lesson' />"],/* 강의 */
            ["asmt", "<spring:message code='dashboard.cor.asmnt' />"],/* 과제 */
            ["forum", "<spring:message code='dashboard.cor.forum' />"],/* 토론 */
            ["exam", "<spring:message code='dashboard.cor.exam' />"],/* 시험 */
            ["quiz", "<spring:message code='dashboard.cor.quiz' />"],/* 퀴즈 */
            ["resch", "<spring:message code='dashboard.cor.resch' />"],/* 설문 */
            ["seminar", "<spring:message code='dashboard.seminar' />"]/* 세미나 */
        ])

        var html = "<ul class='tbl-simple pb10'>";
        html += "	<li>";
        html += "		<dl>";
        html += "			<dt class='p_w10'>";
        html += "				<label for='orgId' class='req'><spring:message code='dashboard.cal_input_course' /></label>";/* 과 목 */
        html += "			</dt>";
        html += "			<dd class='pr50'>";
        html += "				<select class='ui dropdown w200' name='orgId' id='orgId' onchange='creCrsList()'>";
        html += "					<option value=''><spring:message code='dashboard.cal_select' /></option>";/* 선택 */
        <c:forEach var="item" items="${orgInfoList}">
        html += "					<option value='${item.orgId}' ${vo.orgId eq item.orgId ? 'selected' : ''}>${item.orgNm}</option>";
        </c:forEach>
        html += "				</select>";
        html += "				<select class='ui dropdown w300' id='crsCreCd'>";
        html += "					<option value=''><spring:message code='dashboard.cal_select_course' /></option>";/* 과목 선택 */
        html += "				</select>";
        html += "			</dd>";
        html += "		</dl>";
        html += "	</li>";
        html += "	<li>";
        html += "		<dl>";
        html += "			<dt class='p_w10'>";
        html += "			 <label for='type_all' class='req'><spring:message code='dashboard.cal_type' /></label>";/* 구 분 */
        html += "			</dt>";
        html += "			<dd class='pr50'>";
        html += "				<div class='fields'>";
        radioMap.forEach((val, key, map) => {
            var isChecked = key == "${vo.schCntsType}" ? "checked" : "";
            html += "					<div class='ui radio checkbox pr10'>";
            html += "						<input type='radio' name='schCntsType' id='type_" + key + "' value=" + key + " tabindex='0' class='hidden' " + isChecked + ">";
            html += "						<label for='type_" + key + "'>" + val + "</label>";
            html += "					</div>";
        });
        html += "				</div>";
        html += "			</dd>";
        html += "		</dl>";
        html += "	</li>";
        html += "</ul>";
        $("#schDiv").append(html);
        $(".ui.dropdown").dropdown();
    }

    // 일정 등록
    function writeAcadSch() {
        if (!nullCheck()) {
            return false;
        }
        setValue();

        var url = "/dashboard/writeSch.do";

        $.ajax({
            url: url,
            async: false,
            type: "POST",
            dataType: "json",
            data: $("#writeAcadSchForm").serialize(),
        }).done(function (data) {
            if (data.result > 0) {
                alert("<spring:message code='dashboard.alert.cal_insert' />");/* 일정 등록이 완료되었습니다. */
                window.parent.listCalendar();
                window.parent.closeModal();
            } else {
                alert(data.message);
            }
        }).fail(function () {
            alert("<spring:message code='dashboard.error,cal_insert' />");/* 일정 삭제 중 에러가 발생하였습니다. */
        });
    }

    // 일정 수정
    function editAcadSch() {
        if (!nullCheck()) {
            return false;
        }
        setValue();

        var url = "/dashboard/editSch.do";

        $.ajax({
            url: url,
            async: false,
            type: "POST",
            dataType: "json",
            data: $("#writeAcadSchForm").serialize(),
        }).done(function (data) {
            if (data.result > 0) {
                alert("<spring:message code='dashboard.alert.cal_update' />");/* 일정 수정이 완료되었습니다. */
                window.parent.listCalendar();
                window.parent.closeModal();
            } else {
                alert(data.message);
            }
        }).fail(function () {
            alert("<spring:message code='dashboard.error.cal_update' />");/* 일정 수정 중 에러가 발생하였습니다. */
        });
    }

    // 빈 값 체크
    function nullCheck() {
        <spring:message code='dashboard.cal_schedule' var='schedule'/> // 일정

        if ($("#writeAcadSchForm input[name=calendarCtgr]").val() == "course") {
            if ($("#orgId").val() == "") {
                alert("<spring:message code='dashboard.alert.cal_orgid' />");/* 대학 구분을 선택하세요. */

                return false;
            }
            if ($("#crsCreCd").val() == "") {
                alert("<spring:message code='dashboard.alert.cal_course' />");/* 과목을 선택하세요. */
                return false;
            }
            if ($("input:radio[name=schCntsType]:checked").val() == undefined) {
                alert("<spring:message code='dashboard.alert.cal_type' />");/* 일정 구분을 선택하세요. */
                return false;
            }
        }
        if ($.trim($("#acadSchNm").val()) == "") {
            alert("<spring:message code='dashboard.alert.cal_title' />");/* 일정명을 입력하세요. */
            $("#acadSchNm").focus();
            return false;
        }
        if ($("#schStartFmt").val() == "") {
            alert("<spring:message code='common.alert.input.eval_start_date' arguments='${schedule}'/>");/* [일정] 시작일을 입력하세요. */
            $("#schStartFmt").focus();
            return false;
        }
        if ($("#schStartFmtHH").val() == " ") {
            alert("<spring:message code='common.alert.input.eval_start_hour' arguments='${schedule}'/>");/* [일정] 시작시간을 입력하세요. */
            $("#schStartFmtHH").parent().focus();
            return false;
        }
        if ($("#schStartFmtMM").val() == " ") {
            alert("<spring:message code='common.alert.input.eval_start_min' arguments='${schedule}'/>");/* [일정] 시작분을 입력하세요. */
            $("#schStartFmtMM").parent().focus();
            return false;
        }
        if ($("#schEndFmt").val() != "") {
            if ($("#schEndFmtHH").val() == " ") {
                alert("<spring:message code='common.alert.input.eval_end_hour' arguments='${schedule}' />");
                $("#schEndFmtHH").parent().focus();
                return false;
            }
            if ($("#schEndFmtMM").val() == " ") {
                alert("<spring:message code='common.alert.input.eval_end_min' arguments='${schedule}' />");
                $("#schEndFmtMM").parent().focus();
                return false;
            }
        }
        return true;
    }

    // 값 적용
    function setValue() {
        if ($("#writeAcadSchForm input[name=calendarCtgr]").val() == "course") {
            $("#writeAcadSchForm input[name=calendarRefCd]").val($("#crsCreCd").val());
        } else {
            $("#writeAcadSchForm input[name=calendarRefCd]").val("${userId}");
        }
        if ($("#schStartFmt").val() != null && $("#schStartFmt").val() != "") {
            $("#writeAcadSchForm input[name=schStartDt]").val($("#schStartFmt").val().replaceAll(".", "") + "" + pad($("#schStartFmtHH option:selected").val(), 2) + "" + pad($("#schStartFmtMM option:selected").val(), 2) + "00");
        }
        if ($("#schEndFmt").val() != null && $("#schEndFmt").val() != "") {
            $("#writeAcadSchForm input[name=schEndDt]").val($("#schEndFmt").val().replaceAll(".", "") + "" + pad($("#schEndFmtHH option:selected").val(), 2) + "" + pad($("#schEndFmtMM option:selected").val(), 2) + "00");
        } else {
            $("#writeAcadSchForm input[name=schEndDt]").val($("#writeAcadSchForm input[name=schStartDt]").val().substring(0, 8) + "235500");
        }
    }

    // 과목 목록 조회
    function creCrsList() {
        var url = "/dashboard/listUserCreCrs.do";
        var data = {
            "termCd": "${termVO.termCd}",
            "searchMenu": "PROFESSOR",
            "orgId": $("#orgId").val(),
            "pagingYn": "N"
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var returnList = data.returnList || [];
                var html = "<option value=''><spring:message code='dashboard.cal_select_course' /></option>";/* 과목 선택 */
                if (returnList.length > 0) {
                    returnList.forEach(function (v, i) {
                        html += "<option value=\"" + v.crsCreCd + "\">" + v.crsCreNm + "</option>";
                    });
                }
                $("#crsCreCd").empty().html(html);
                $("#crsCreCd").dropdown("clear");
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
        });
    }

    // 날짜 자리수 채우기
    function pad(number, length) {
        var str = number.toString();
        while (str.length < length) {
            str = '0' + str;
        }
        return str;
    }
</script>

<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
<div id="wrap">
    <div class="tc mb20">
        <c:if test="${menuType eq 'PROFESSOR' }">
            <button class="ui blue button" onclick="initSchForm('course')"><spring:message code="dashboard.cal_course"/>
                <spring:message code="dashboard.cal_schedule"/></button>
            <!-- 과목 --><!-- 일정 -->
        </c:if>
        <button class="ui blue button" onclick="initSchForm('personal')"><spring:message code="dashboard.cal_private"/>
            <spring:message code="dashboard.cal_schedule"/></button><!-- 개인 --><!-- 일정 -->
    </div>
    <form id="writeAcadSchForm" method="POST">
        <input type="hidden" name="acadSchSn" value="${vo.acadSchSn }"/>
        <input type="hidden" name="calendarCtgr"/>
        <input type="hidden" name="calendarRefCd"/>
        <input type="hidden" name="schStartDt"/>
        <input type="hidden" name="schEndDt"/>
        <div id="schDiv" class="ui form">
        </div>
    </form>

    <div class="bottom-content mt50">
        <c:choose>
            <c:when test="${not empty vo.acadSchSn }">
                <button class="ui blue button" onclick="editAcadSch()"><spring:message
                        code="common.button.modify"/></button>
                <!-- 수정 -->
            </c:when>
            <c:otherwise>
                <button class="ui blue button" onclick="writeAcadSch()"><spring:message
                        code="common.button.save"/></button>
                <!-- 저장 -->
            </c:otherwise>
        </c:choose>
        <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message
                code="user.button.close"/></button><!-- 닫기 -->
    </div>
</div>
<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>
