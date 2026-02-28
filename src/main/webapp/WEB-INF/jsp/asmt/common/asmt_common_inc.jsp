<%@ page import="knou.framework.util.SessionUtil" %>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/3.1.2/rollups/aes.js"></script>
<script type="text/javascript">
    // 모달 닫기
    window.closeModal = function () {
        $('.modal').modal('hide');
    };

    // 모달 생성
    function initModal(id, option) {
        $("#" + id + "Modal").remove();

        option = option || {};

        var modalClass = option.modalClass || "modal-lg";

        var typeMap = {
            "Ap01": "<spring:message code='crs.label.eval_criteria_reg'/>",/* 평가기준 등록 */
            "Ap02": "<spring:message code='asmnt.button.asmnt.prev'/>",/* 이전 과제 가져오기 */
            "Ap03": "<spring:message code='asmnt.button.all.submit.list'/>",/* 전체제출과제보기 */
            "Ap04": "<spring:message code='asmnt.label.mut.eval'/>",/* 상호평가 */
            "Ap05": "<spring:message code='bbs.label.select_team_ctgr'/>",/* 팀 분류 선택 */
            "Ap06": "<spring:message code='asmnt.label.team.config.view'/>",/*팀구성원 보기*/
            "Ap07": "<spring:message code='asmnt.label.memo'/>",/* 메모 */
            "Ap08": "<spring:message code='asmnt.button.reg.excel.score'/>",/* 엑셀 성적등록 */
            "Ap09": "<spring:message code='asmnt.button.feedback.write'/>", /* 피드백 작성하기 */
            "Ap10": "<spring:message code='forum.label.feedback'/>", /* 피드백 */
            "Ap11": "<spring:message code='asmnt.label.submitted.work'/><spring:message code='asmnt.label.history'/>", /* 제출과제 이력 */
            "Ap12": "<spring:message code='common.label.resubmit'/><spring:message code='common.mgr'/>", /* 재제출 관리 */
            "Ap13": "<spring:message code='common.label.excellent.asmnt'/>", /* 우수과제 */
            "Ap14": "<spring:message code='asmnt.button.cmnt' />",/* 댓글 */
            "Ap15": "<spring:message code='exam.label.ins.target.set.ifm' />",/* 대체평가 대상자 설정 */
            "Ap16": "<spring:message code='crs.label.eval.criteria' />",/* 평가기준 */
            "Ap17": "<spring:message code='common.label.asmnt' /><spring:message code='common.submission' />",/* 과제제출 */
            "Ap18": "<spring:message code='common.button.copy.rate.compare' />",/* 답안유사율 비교 */
            "Ap19": "<spring:message code='common.label.eval.user.list' />",/* 평가자 목록 */
            "Ap20": "<spring:message code='asmnt.label.submitted.work' />",/* 제출과제 */
        };

        var html = "<div class='modal fade' id='" + id + "Modal' tabindex='-1' role='dialog' aria-labelledby='" + typeMap[id] + "' aria-hidden='false'>";
        html += "	<div class='modal-dialog " + modalClass + "' role='document'>";
        html += "		<div class='modal-content'>";
        html += "			<div class='modal-header'>";
        html += "				<button type='button' class='close' data-dismiss='modal' aria-label=\"<spring:message code='asmnt.button.close'/>\">";
        html += "					<span aria-hidden='true'>&times;</span>";
        html += "				</button>";
        html += "				<h4 class='modal-title'>" + typeMap[id] + "</h4>";
        html += "			</div>";
        html += "			<div class='modal-body'>";
        html += "				<iframe src= '' name='" + id + "ModalIfm' width='100%' scrolling='no'></iframe>";
        html += "			</div>";
        html += "		</div>";
        html += "	</div>";
        html += "</div>";

        $("#wrap").append(html);

        $('iframe').iFrameResize();
        $('#' + id + "Modal").modal('show');
    }

    // 페이지 이동
    function submitForm(action, target, kvArr) {
        $("form[name='tempForm']").remove();

        var form = $("<form></form>");
        form.attr("method", "POST");
        form.attr("name", "tempForm");
        form.attr("action", action);
        form.attr("target", target);

        for (var i = 0; i < kvArr.length; i++) {
            form.append($('<input/>', {type: 'hidden', name: kvArr[i].key, value: kvArr[i].val}));
        }

        form.appendTo("body");
        form.submit();
    };

    // 파일 다운로드
    function fileDown(fileSn, repoCd) {
        var url = "/common/fileInfoView.do";
        var data = {
            "fileSn": fileSn,
            "repoCd": repoCd
        };

        ajaxCall(url, data, function (data) {
            $("#downloadForm").remove();
            // download용 iframe이 없으면 만든다.
            if ($("#downloadIfm").length == 0) {
                $("body").append("<iframe id='downloadIfm' name='downloadIfm' style='visibility: hidden; display: none;'></iframe>");
            }

            var form = $("<form></form>");
            form.attr("method", "POST");
            form.attr("name", "downloadForm");
            form.attr("id", "downloadForm");
            form.attr("target", "downloadIfm");
            form.attr("action", data);
            form.appendTo("body");
            form.submit();
        }, function (xhr, status, error) {
            alert("<spring:message code='fail.common.msg' />");/* 에러가 발생했습니다! */
        });
    }

    // 파일 바이트 계산
    function byteConvertor(bytes, fileNm, fileId) {
        // fileSize가 null 인경우 감춤
        if (bytes == '0') {
            $("#" + fileId).append(fileNm);
            return;
        }

        bytes = parseInt(bytes);
        var s = ['bytes', 'KB', 'MB', 'GB', 'TB', 'PB'];
        var e = Math.floor(Math.log(bytes) / Math.log(1024));
        if (e == "-Infinity") {
            $("#" + fileId).append(fileNm + " 0 " + s[0]);
        } else {
            var val = (bytes / Math.pow(1024, Math.floor(e)));
            if (bytes > 1000) {
                val = val.toFixed(2);
            }

            $("#" + fileId).append(fileNm + " (" + val + " " + s[e] + ")");
        }
    }

    // 파일 바이트 계산2
    function sizeToByte(bytes) {
        if (bytes == '0') {
            return;
        }

        bytes = parseInt(bytes);
        var s = ['bytes', 'KB', 'MB', 'GB', 'TB', 'PB'];
        var e = Math.floor(Math.log(bytes) / Math.log(1024));
        if (e == "-Infinity") {
            return "0 " + s[0];
        } else {
            return (bytes / Math.pow(1024, Math.floor(e))).toFixed(2) + " " + s[e];
        }
    }

    // 날짜 형식 변경(YYYY.MM.DD HH24:MI)
    function dateFormat(dt) {
        return dt.substring(0, 4) + '.' + dt.substring(4, 6) + '.' + dt.substring(6, 8) + ' ' + dt.substring(8, 10) + ':' + dt.substring(10, 12);
    }

    // 날짜 가져오기
    function getDate(dt) {
        var mDt = null;
        if (dt != null && dt != "") {
            mDt = dt.slice(0, 4) + '-' + dt.slice(4, 6) + '-' + dt.slice(6, 8);
            mDt += ' ' + dt.slice(8, 10) + ':' + dt.slice(10, 12) + ':' + dt.slice(12, 14);
        }
        return new Date(mDt);
    }

    // 달력 값 매핑
    function setDataCalendar(dt, ymd, hh, mm) {
        if (dt != null) {
            $("#" + ymd).val(dt.substring(0, 4) + '.' + dt.substring(4, 6) + '.' + dt.substring(6, 8));
            $("#" + hh).dropdown('set selected', dt.substring(8, 10));
            $("#" + mm).dropdown('set selected', dt.substring(10, 12));
        } else {
            $("#" + ymd).val(null);
            $("#" + hh).dropdown('set selected', ' ');
            $("#" + mm).dropdown('set selected', ' ');
        }
    }

    // 달력 비교
    function calendarComparison(msg, dt1, hh1, mm1, dt2, hh2, mm2) {
        if (dt1 == null || dt1 == '') {
            alert("<spring:message code='common.alert.input.eval_start_date' arguments='"+msg+"'/>");
            return true;
        } else if (hh1 == ' ') {
            alert("<spring:message code='common.alert.input.eval_start_hour' arguments='"+msg+"'/>");
            return true;
        } else if (mm1 == ' ') {
            alert("<spring:message code='common.alert.input.eval_start_min' arguments='"+msg+"'/>");
            return true;
        } else if (dt2 == null || dt2 == '') {
            alert("<spring:message code='common.alert.input.eval_end_date' arguments='"+msg+"'/>");
            return true;
        } else if (hh2 == ' ') {
            alert("<spring:message code='common.alert.input.eval_end_hour' arguments='"+msg+"'/>");
            return true;
        } else if (mm2 == ' ') {
            alert("<spring:message code='common.alert.input.eval_end_min' arguments='"+msg+"'/>");
            return true;
        } else if (new Date(dt1 + ' ' + hh1 + ':' + mm1) > new Date(dt2 + ' ' + hh2 + ':' + mm2)) {
            alert("<spring:message code='common.alert.input.eval_start_end_date' arguments='"+msg+"'/>");
            return true;
        }

        return false;
    }

    // 달력 체크
    function calendarCheck(msg, dt, hh, mm) {
        if (dt == null || dt == '') {
            alert(msg + "<spring:message code='asmnt.alert.input.eval.date' />");	/* 일을 입력하세요.*/
            return true;
        } else if (hh == ' ') {
            alert(msg + "<spring:message code='asmnt.alert.input.eval.hour' />");	/* 시간을 입력하세요.*/
            return true;
        } else if (mm == ' ') {
            alert(msg + "<spring:message code='asmnt.alert.input.eval.min' />");	/* 분을 입력하세요.*/
            return true;
        }
        return false;
    }

    // 달력값 복사
    function copyCalendarValue(fromYmd, fromHh, fromMm, toYmd, toHh, toMm) {
        $("#" + toYmd).val($("#" + fromYmd).val());
        $("#" + toHh).dropdown('set selected', $("#" + fromHh).val());
        $("#" + toMm).dropdown('set selected', $("#" + fromMm).val());
    }


    // 이름 마스킹
    function maskingName(name) {
        if (name.length <= 2) {
            return name.replace(name.substring(1, 2), "*");
        }

        return (name[0] + "*".repeat(name.substring(1, name.length - 1).length) + name[name.length - 1]);
    }

    // 학번 마스킹
    function maskingNo(no) {
        return no.substring(0, 5) + "*".repeat(no.substring(5, no.length - 2).length) + no.slice(-2);
    }
</script>