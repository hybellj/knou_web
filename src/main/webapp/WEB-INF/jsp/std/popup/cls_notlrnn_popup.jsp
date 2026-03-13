<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="dashboard"/>
    </jsp:include>
    <style>
        .popup-wrap {
            padding: 20px;
            background: #fff;
        }
        .popup-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 12px;
        }
        .popup-header .pop-title {
            font-size: 16px;
            font-weight: bold;
        }
        .popup-header .btn-area {
            display: flex;
            gap: 6px;
        }
        .popup-table-wrap {
            overflow-x: auto;
        }
        .popup-footer {
            text-align: center;
            margin-top: 20px;
        }
        .badge-num {
            display: inline-block;
            background: #e0e0e0;
            border-radius: 3px;
            padding: 0 6px;
            font-size: 12px;
            margin-left: 6px;
            vertical-align: middle;
        }
    </style>
</head>
<body>
<div class="popup-wrap">

    <!-- 팝업 헤더 -->
    <div class="popup-header">
        <h3 class="pop-title">
            <span id="popSubTitle">${wkNo}주차 미학습자</span>
            <span class="badge-num" id="popTotalCnt">0</span>명
        </h3>
        <div class="btn-area">
            <button type="button" class="btn basic" id="btnSendMsg"><spring:message code="button.msg.send"/></button><%-- 보내기 --%>
            <button type="button" class="btn basic" id="btnExcelDown"><spring:message code="button.download.excel"/></button><%-- 엑셀 다운로드 --%>
        </div>
    </div>

    <!-- 미학습자 목록 테이블 -->
    <!-- 화면정의서 슬라이드5: 컬럼 No/학과/학번/이름/입학년도/학년 -->
    <div class="popup-table-wrap">
        <table class="table-type2">
            <colgroup>
                <col style="width:8%">
                <col style="width:18%">
                <col style="width:18%">
                <col style="width:12%">
                <col style="width:12%">
                <col style="width:10%">
            </colgroup>
            <thead>
            <tr>
                <th>No</th>
                <th>학과</th>
                <th>학번</th>
                <th>이름</th>
                <th>입학년도</th>
                <th>학년</th>
            </tr>
            </thead>
            <tbody id="notLrnnBody">
            <tr>
                <td colspan="6" class="t_center">조회 중...</td>
            </tr>
            </tbody>
        </table>
    </div>

    <!-- 닫기 버튼 -->
    <div class="popup-footer">
        <button type="button" class="btn type2" id="btnClose"><spring:message code="button.close"/></button><%-- 닫기 --%>
    </div>

</div>

<script type="text/javascript">
    var CTX      = "<%=request.getContextPath()%>";
    var sbjctId  = "${sbjctId}";
    var dvclasNo = "${dvclasNo}";
    var wkNo     = parseInt("${wkNo}", 10) || 0;

    /* 현재 조회된 userId 목록 (보내기용) */
    var currentUserIds = [];

    $(function () {
        $("#popSubTitle").text(wkNo + "주차 미학습자");

        loadNotLrnnList();

        /* 닫기 */
        $("#btnClose").on("click", function () {
            if (window.parent && typeof window.parent.UiDialog === "function") {
                try { window.parent.UiDialog.close("notLrnnPop"); } catch (e) {}
            } else {
                window.close();
            }
        });

        /* 보내기 - 화면정의서 슬라이드5: ② 보내기 버튼 → 메시지보내기 레이어 팝업 */
        $("#btnSendMsg").on("click", function () {
            if (!currentUserIds || currentUserIds.length === 0) {
                alert("현재 조회된 미학습자가 없습니다.");
                return;
            }
            /* TODO: 실제 메시지 보내기 레이어 팝업 연결 */
            alert(wkNo + "주차 미학습자 " + currentUserIds.length + "명에게 메시지 발송 예정\n(보내기 기능 연결 예정)");
        });

        /* 엑셀 다운로드 */
        $("#btnExcelDown").on("click", function () {
            downloadExcel();
        });
    });

    /* ===================================
       미학습자 목록 조회
       =================================== */
    function loadNotLrnnList() {
        $.ajax({
            url:      CTX + "/cls/selectClsNoStudyWeek.do",
            type:     "GET",
            dataType: "json",
            data: {
                sbjctId:  sbjctId,
                dvclasNo: dvclasNo,
                wkNo:     wkNo
            },
            success: function (res) {
                var $body = $("#notLrnnBody").empty();

                if (!res || res.result !== 1 || !res.returnList || res.returnList.length === 0) {
                    currentUserIds = [];
                    $("#popTotalCnt").text("0");
                    $body.append('<tr><td colspan="6" class="t_center">미학습자가 없습니다.</td></tr>');
                    return;
                }

                var list = res.returnList;
                currentUserIds = list.map(function (x) { return x.userId; }).filter(Boolean);
                $("#popTotalCnt").text(list.length);

                list.forEach(function (item, idx) {
                    $body.append(
                        '<tr>'
                        + '<td class="t_center">' + (idx + 1) + '</td>'
                        + '<td class="t_center">' + escHtml(item.deptnm  || '') + '</td>'
                        + '<td class="t_center">' + escHtml(item.stdntNo || '') + '</td>'
                        + '<td class="t_center">' + escHtml(item.usernm  || '') + '</td>'
                        + '<td class="t_center">' + escHtml(item.entyR   || '-') + '</td>'
                        + '<td class="t_center">' + escHtml(item.scyr    || '-') + '</td>'
                        + '</tr>'
                    );
                });
            },
            error: function () {
                $("#notLrnnBody").html('<tr><td colspan="6" class="t_center"><spring:message code="fail.common.msg"/></td></tr>'); // 조회 중 오류가 발생했습니다.
            }
        });
    }

    /* ===================================
       엑셀 다운로드
       ★ 수정: 전용 endpoint 사용 (wkNo 파라미터로 미학습자만 추출)
          기존: /cls/selectClsStdntListExcelDown.do (전체 수강생용)
          수정: /cls/selectClsStdntListExcelDown.do + wkNo 전달
                → Controller에서 vo.getWkNo() > 0 이면 미학습자 목록으로 분기
       =================================== */
    function downloadExcel() {
        var excelGrid = {
            colModel: [
                {label:'No',       name:'lineNo',  align:'center', width:'3000'},
                {label:'학과',     name:'deptnm',  align:'center', width:'7000'},
                {label:'학번',     name:'stdntNo', align:'center', width:'7000'},
                {label:'이름',     name:'usernm',  align:'center', width:'6000'},
                {label:'입학년도', name:'entyR',   align:'center', width:'5000'},
                {label:'학년',     name:'scyr',    align:'center', width:'3000'}
            ]
        };

        $("form[name=notLrnnExcelForm]").remove();
        var $form = $('<form name="notLrnnExcelForm" method="post"></form>');

        /* ★ 수정: wkNo를 함께 전달 → Controller 분기(wkNo > 0)로 미학습자 목록 추출 */
        $form.attr("action", CTX + "/cls/selectClsStdntListExcelDown.do");
        $form.append($('<input/>', {type:'hidden', name:'sbjctId',   value: sbjctId}));
        $form.append($('<input/>', {type:'hidden', name:'dvclasNo',  value: dvclasNo}));
        $form.append($('<input/>', {type:'hidden', name:'wkNo',      value: wkNo}));
        $form.append($('<input/>', {type:'hidden', name:'excelGrid', value: JSON.stringify(excelGrid)}));
        $form.appendTo("body").submit();
    }

    /* HTML 이스케이프 */
    function escHtml(v) {
        return String(v)
            .replace(/&/g,  "&amp;")
            .replace(/</g,  "&lt;")
            .replace(/>/g,  "&gt;")
            .replace(/"/g,  "&quot;");
    }
</script>
</body>
</html>
