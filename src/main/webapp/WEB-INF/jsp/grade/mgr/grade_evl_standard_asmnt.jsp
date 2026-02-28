<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/jsp/common/admin/admin_common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/asmt/common/asmt_common_inc.jsp" %>

<script type="text/javascript">
    $(function () {
        // 최초 조회
        onAsmntSearch(1);

        // 엔터키
        $("#searchValue1").on("keyup", function (e) {
            if (e.keyCode == 13) {
                onAsmntSearch(1);
            }
        });
    });

    //목록크기 변경
    function onChangeListScale() {
        onChangeView(4); // 성적반영 OFF
        onAsmntSearch(1);
    }

    // 성적 반영비율 수정 및 저장
    function onChangeScoreRatio(key) {
        switch (key) {
            case 1:
                onAsmntSearch(1, 'EDIT');
                break;
            case 2:
                onChangeView(2);
                onAsmntSearch(1, 'EDIT');
                break;// 리스트형 호출
            case 3:
                onChangeView(4);
                break;
        }
    }

    //리스트 조회
    function onAsmntSearch(page, type) {
        if (type == "EDIT") {
            $('#listScale').attr("onchange", "");
            $("#listScale").dropdown('set selected', '<spring:message code="crs.label.all" />');	// 전체
            $('#listScale').attr("onchange", "onChangeListScale();");
        }

        if ($("#listScale").val() == 0) selectType = "LIST";

        var url = "/asmt/profAsmtList.do";
        var data = {
            crsCreCd: "${vo.crsCreCd2}",
            pageIndex: page,
            listScale: $("#listScale").val(),
            searchValue: $("#searchValue1").val(),
            pagingYn: type == "CARD" ? "N" : "Y"
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {

                var html = "";

                // 화면 생성
                var dataList = data.returnList || [];
                var html = "";

                $.each(data.returnList, function (i, o) {
                    var sendStartDttm = gfn_isNull(o.sendStartDttm) ? "" : dateFormat(o.sendStartDttm);
                    var sendEndDttm = gfn_isNull(o.sendEndDttm) ? "" : dateFormat(o.sendEndDttm);
                    var extSendDttm = gfn_isNull(o.extSendDttm) ? "-" : dateFormat(o.extSendDttm);
                    var scoreRatio = gfn_isNull(o.scoreRatio) ? "0" : o.scoreRatio;
                    var scoreOpen = o.scoreOpenYn == 'Y' ? "checked" : "";

                    html += "<tr>";
                    html += "	<td >" + o.lineNo + "</td>";
                    html += "	<td >" + o.asmntCtgrNm + "</td>";
                    html += "	<td><a href=\"javascript:viewAsmnt('" + o.asmntCd + "', 0)\" class='fcBlue'> " + o.asmntTitle + "</a></td>";
                    html += "	<td >" + sendStartDttm + " ~ " + sendEndDttm + "</td>";
                    html += "	<td >";

                    if (o.scoreAplyYn == 'N') {
                        html += "-"
                    } else if (o.indYn == 'Y') {
                        html += "		<div>" + scoreRatio + " %</div>";
                    } else {
                        html += "		<div name='scoreViewDiv'>" + scoreRatio + " %</div>";
                        html += "		<div name='scoreEditDiv' class='ui right labeled input'>";
                        html += "	    	<input type='hidden' name='asmntArray' value='" + o.asmntCd + "'>";
                        html += "	    	<input type='number' class='w50' name='scoreRatioArray' value='" + scoreRatio + "'>";
                        html += "	    	<div class='ui basic label'>%</div>";
                        html += "	    </div>";
                    }

                    html += "	</td>";
                    html += "	<td >" + o.submitCnt + " / " + o.targetCnt + "</td>";

                    if (o.scoreAplyYn == 'N') {
                        html += "	<td >-</td>";
                    } else {
                        html += "	<td ><a href=\"javascript:viewAsmnt('" + o.asmntCd + "', 1)\" class='fcBlue'>" + o.evalCnt + " / " + o.submitCnt + "</a></td>";
                    }

                    html += "	<td >" + extSendDttm + "</td>";
                    html += "	<td >";

                    if (o.scoreAplyYn == 'N') {
                        html += "-"
                    } else {
                        html += "		<div class='ui toggle checkbox'>";
                        html += "   	    <input type='checkbox' name='scoreOpenArray' value='" + o.asmntCd + "' " + scoreOpen + ">";
                        html += "  		</div>";
                    }

                    html += "	</td>";
                    html += "</tr>";

                });
                html += "</tbody>";

                $("#asmntTbodyId").empty().html(html);

                $('div[name="scoreEditDiv"]').hide();
                $(".table").footable();

                $("#listDiv tbody tr").each(function (i) {
                    $("#listDiv tbody tr:eq(" + i + ") td:eq(2)").css("text-align", "left");
                });

                if (selectType == "LIST") {
                    if (type == "EDIT") onChangeView(3);
                } else {
                    var params = {
                        totalCount: data.pageInfo.totalRecordCount,
                        listScale: data.pageInfo.pageSize,
                        currentPageNo: data.pageInfo.currentPageNo,
                        eventName: "onAsmntSearch"
                    };

                    gfn_renderPaging(params);
                }

                // 공통
                $('.ui.checkbox').checkbox();

                $('input:checkbox[name="scoreOpenArray"]').change(function () {
                    updateScoreOpen($(this).val(), $(this).is(":checked"));
                });

            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            /* 에러가 발생했습니다! */
            alert('<spring:message code="fail.common.msg" />');
        });
    }

    //성적공개 수정
    function updateScoreOpen(asmntCd, scoreOpenYn) {
        var data = {
            "asmntCd": asmntCd
            , "scoreOpenYn": scoreOpenYn == true ? 'Y' : 'N'
        };

        ajaxCall("/asmtprofAsmtMrkOpenYnModify.do", data, function (data) {
            if (data.result > 0) {
                alert(data.message);
            }
        }, function () {
        });
    };


    function onChangeView(key) {
        switch (key) {
            case 1:
                // 카드 VIEW
                $("#listScale").parent().hide();
                break;

            case 2:
                // 리스트 VIEW
                $("#listScale").parent().show();
                break;

            case 3:
                // 성적반영 수정 VIEW
                $('div .mla.mr5 a:eq(0)').hide();
                $('div .mla.mr5 a:eq(1)').show(); // 저장
                $('div .mla.mr5 a:eq(2)').show(); // 취소

                $('div[name="scoreViewDiv"]').hide();
                $('div[name="scoreEditDiv"]').show();

                $('input[name="scoreRatioArray"]').on("input", function () {
                    $(this).val(Number($(this).val()));

                    var sum = 0;

                    $('input[name="scoreRatioArray"]').each(function () {
                        sum = Number(sum) + Number($(this).val());
                    });

                    if (sum > 100) {
                        $(this).val(Number($(this).val()) + (100 - sum));
                    } else if ($(this).val() > 100) {
                        $(this).val(100);
                    }
                });

                break;

            case 4:
                // 성적반영 일반 VIEW
                $('div .mla.mr5 a:eq(0)').show();
                $('div .mla.mr5 a:eq(1)').hide(); // 저장
                $('div .mla.mr5 a:eq(2)').hide(); // 취소

                $('div[name="scoreEditDiv"]').hide();
                $('div[name="scoreViewDiv"]').show();

                $('input[name="scoreRatioArray"]').off("input");

                break;
        }
    }

    // HTML 생성
    function createHTML(data) {
        var html = "";

        html += "		<table class='table' data-sorting='true' data-paging='false' data-empty='<spring:message code='exam.common.empty' />'>";
        html += "			<thead>";
        html += "				<tr>";
        html += "				<th scope='col'><spring:message code='common.number.no' /></th>";
        html += "	          	<th scope='col'><spring:message code='exam.label.stare.type' /></th>";
        html += "           		<th scope='col'><spring:message code='crs.label.asmnt_name' /></th>";
        html += "           		<th scope='col'><spring:message code='asmnt.label.send.date' /></th>";
        html += "           		<th scope='col'><spring:message code='resh.label.score.ratio' /></th>";
        html += "           		<th scope='col'><spring:message code='exam.label.submission.status' /></th>";
        html += "           		<th scope='col'><spring:message code='exam.label.eval.status' /></th>";
        html += "           		<th scope='col'><spring:message code='exam.label.late.submit.end.dttm' /></th>";
        html += "           		<th scope='col'><spring:message code='forum.label.score.open' /></th>";
        html += "				</tr>";
        html += "			</thead>";
        html += "			<tbody>";

        $.each(data, function (i, o) {
            var sendStartDttm = dateFormat(o.sendStartDttm);
            var sendEndDttm = dateFormat(o.sendEndDttm);
            var extSendDttm = o.extSendDttm != null && o.extSendDttm != "" ? dateFormat(o.extSendDttm) : "-";
            var scoreRatio = o.scoreRatio != null && o.scoreRatio != "" ? +o.scoreRatio : "0";
            var scoreOpen = o.scoreOpenYn == 'Y' ? "checked" : "";

            html += "<tr>";
            html += "	<td >" + o.lineNo + "</td>";
            html += "	<td >" + o.asmntCtgrNm + "</td>";
            html += "	<td>" + o.asmntTitle + "</td>";
            html += "	<td >" + sendStartDttm + " ~ " + sendEndDttm + "</td>";
            html += "	<td >";

            if (o.scoreAplyYn == 'N') {
                html += "-"
            } else if (o.indYn == 'Y') {
                html += "		<div>" + scoreRatio + " %</div>";
            } else {
                html += "		<div name='scoreViewDiv'>" + scoreRatio + " %</div>";
                html += "		<div name='scoreEditDiv' class='ui right labeled input'>";
                html += "	    	<input type='hidden' name='asmntArray' value='" + o.asmntCd + "'>";
                html += "	    	<input type='number' class='w50' name='scoreRatioArray' value='" + scoreRatio + "'>";
                html += "	    	<div class='ui basic label'>%</div>";
                html += "	    </div>";
            }

            html += "	</td>";
            html += "	<td >" + o.submitCnt + " / " + o.targetCnt + "</td>";

            if (o.scoreAplyYn == 'N') {
                html += "	<td >-</td>";
            } else {
                html += "	<td >" + o.evalCnt + " / " + o.submitCnt + "</td>";
            }

            html += "	<td >" + extSendDttm + "</td>";
            html += "	<td >";

            if (o.scoreAplyYn == 'N') {
                html += "-"
            } else {
                html += "		<div class='ui toggle checkbox'>";
                html += "   	    <input type='checkbox' name='scoreOpenArray' value='" + o.asmntCd + "' " + scoreOpen + ">";
                html += "  		</div>";
            }

            html += "	</td>";
            html += "</tr>";

        });

        html += "			</tbody>";
        html += "		</table>";
        html += "	<div id='paging' class='paging'></div>";

        return html;
    }

    //NULL HTML 생성
    function creatNullHTML() {
        var html = "";

        html += "<table class='table' data-empty='<spring:message code='exam.common.empty' />>";
        html += "	<thead>";
        html += "		<tr>";
        html += "           <th scope='col'><spring:message code='common.number.no' /></th>";
        html += "           <th scope='col'><spring:message code='exam.label.stare.type' /></th>";
        html += "           <th scope='col'><spring:message code='crs.label.asmnt_name' /></th>";
        html += "           <th scope='col'><spring:message code='asmnt.label.send.date' /></th>";
        html += "           <th scope='col'><spring:message code='resh.label.score.ratio' /></th>";
        html += "           <th scope='col'><spring:message code='exam.label.submission.status' /></th>";
        html += "           <th scope='col'><spring:message code='exam.label.eval.status' /></th>";
        html += "           <th scope='col'><spring:message code='exam.label.late.submit.end.dttm' /></th>";
        html += "           <th scope='col'><spring:message code='forum.label.score.open' /></th>";
        html += "		</tr>";
        html += "	</thead>";
        html += "	<tbody>";
        html += "	</tbody>";
        html += "</table>";

        return html;
    }

    // 성적 반영비율 저장
    function saveScoreRatio() {

        var sum = 0;
        $('input[name="scoreRatioArray"]').each(function () {
            sum = Number(sum) + Number($(this).val());
        });

        if (sum != 100) {
            /* 성적반영 비율 합이 100%이여야 합니다. */
            alert('<spring:message code="asmnt.message.score.ratio" />');
            return false;
        } else {

            var data = $('#asmntForm').serialize();

            ajaxCall("/asmtprofMrkRfltRtModify.do", data, function (data) {
                if (data.result > 0) {
                    alert(data.message);
                    onChangeView(4); // 성적반영 OFF
                    onAsmntSearch(1);
                }
            }, function () {
            });
        }
    }
</script>

<body>
<div class="option-content mb10">
    <div class="ui action input search-box mr5">
        <input type="text" id="searchValue1"
               placeholder="<spring:message code="crs.label.asmnt_name" /><spring:message code="exam.label.input" />">
        <button class="ui icon button" onclick="onAsmntSearch(1);"><i class="search icon"></i></button>
    </div>

    <div class="mla mr5">
        <a href="javascript:onChangeScoreRatio(1);" class="ui blue button"><spring:message
                code="asmnt.button.score.ratio.chnage"/></a><!-- 성적반영비율 조정 -->
        <a href="javascript:saveScoreRatio();" class="ui basic button" style="display:none;"><spring:message
                code="asmnt.button.score.ratio.save"/></a><!-- 성적반영비율 저장 -->
        <a href="javascript:onChangeScoreRatio(3);" class="ui gray button" style="display:none;"><spring:message
                code="button.cancel"/></a><!-- 취소 -->
    </div>

    <select class="ui dropdown list-num selection" id="listScale" onchange="onChangeListScale();">
        <option value="10">10</option>
        <option value="20">20</option>
        <option value="50">50</option>
        <option value="100">100</option>
    </select>
</div>
<form id="asmntForm" method="POST">
    <div id="listDiv" class="sixteen wide column">
        <table class='table' data-sorting='true' data-paging='false'
               data-empty='<spring:message code='exam.common.empty' />'>
            <thead>
            <tr>
                <th scope='col'><spring:message code="common.number.no"/></th><!-- NO. -->
                <th scope='col'><spring:message code="exam.label.stare.type"/></th><!-- 구분 -->
                <th scope='col'><spring:message code="crs.label.asmnt_name"/></th><!-- 과제명 -->
                <th scope='col'><spring:message code="asmnt.label.send.date"/></th><!-- 제출기간 -->
                <th scope='col'><spring:message code="resh.label.score.ratio"/></th><!-- 성적반영비율 -->
                <th scope='col'><spring:message code="exam.label.submission.status"/></th><!-- 제출현황 -->
                <th scope='col'><spring:message code="exam.label.eval.status"/></th><!-- 평가현황 -->
                <th scope='col'><spring:message code="exam.label.late.submit.end.dttm"/></th><!-- 지각제출마감일 -->
                <th scope='col'><spring:message code="forum.label.score.open"/></th><!-- 성적공개 -->
            </tr>
            </thead>
            <tbody id="asmntTbodyId">
            </tbody>
        </table>
        <div id='paging' class='paging'></div>
    </div>
</form>
<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>