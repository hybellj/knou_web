<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
    <%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    <%@ include file="/WEB-INF/jsp/asmt/common/asmt_common_inc.jsp" %>
    <script type="text/javascript" src="/webdoc/js/iframe.js"></script>
    <link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2"/>

    <script type="text/javascript">
        $(document).ready(function () {
            getPrevAsmntFiles();
        });

        function getPrevAsmntFiles() {
            var url = "/asmt/profPrevAsmtSbmsnFileSelect.do";
            var data = {
                "asmtId": "${vo.asmtId}",
                "stdNo": "${vo.stdNo}"
            };

            ajaxCall(url, data, function (data) {
                var html = "";

                html += "<table class='table type2' data-sorting='true' data-paging='false' data-empty='<spring:message code="asmnt.message.empty"/>'>";
                html += "	<thead>";
                html += "   	<tr>";
                html += "       	<th scope='col'><spring:message code='asmnt.label.asmnt.title'/></th>";
                html += "       	<th scope='col'><spring:message code='asmnt.label.submit.dt'/></th>";
                html += "       	<th scope='col'><spring:message code='asmnt.label.send.file'/></th>";
                html += "       	<th scope='col'><spring:message code='asmnt.label.scr'/></th>";
                html += "       	<th scope='col' data-sortable='false'><spring:message code='asmnt.label.scr.change'/></th>";
                html += "		</tr>";
                html += "	</thead>";
                html += "	<tbody>";

                if (data.result > 0) {
                    $.each(data.returnList, function (i, o) {
                        if (o.sbmsnStscd != 'NO') {
                            var scr = o.scr != null && o.scr != "" ? o.scr : "-";
                            var title = o.asmtTtl != null ? o.asmtTtl : "-";
                            var dt = o.fileRegDttm != null ? dateFormat(o.fileRegDttm) : "-";

                            html += "<tr>";
                            html += "	<td>" + title + "</td>";
                            html += "	<td>" + dt + "</td>";
                            html += "	<td>";
                            if (o.sendType == "T") {
                                html += "<a href='javascript:asmntsbmsnCtsPop(\"" + o.asmtSbmsnId + "\")' class='ui button small'>내용보기</a>";
                            } else {
                                for (var j = 0; j < o.fileList.length; j++) {
                                    html += "<div class='flex-item gap4'>" + o.fileList[j].fileNm
                                    html += "	<button class='ui icon button p4' title='<spring:message code="asmnt.label.attachFile.download"/>' onclick=\"fileDown('" + o.fileList[j].fileSn + "', '" + o.fileList[j].repoCd + "')\">";
                                    html += "	<i class='ion-android-download'></i>";
                                    html += "	</button>";
                                    html += "</div>";
                                }
                            }
                            html += "	</td>";
                            html += "	<td>" + scr + "</td>";
                            html += "	<td>";
                            html += "		<div class='ui input'>";
                            html += "	    	<input type='number' id='eScore" + i + "' class='w70' value='" + o.scr + "' onkeyup=\"this.value=this.value.replace(/[^0-9]/g,'');\">";
                            html += "	    </div>";
                            html += "	    <a href=\"javascript:submitScore('" + i + "','" + o.asmtId + "','" + o.stdNo + "');\" class='ui blue small button ml5'><spring:message code='user.button.save' />​</a>";
                            html += "	</td>";
                            html += "</tr>";
                        }
                    });
                } else {
                    alert(data.message);
                }

                html += "	</tbody>";
                html += "</table>";

                $("#prevAsmntFiles").empty().append(html);
                $(".table").footable();
            }, function (xhr, status, error) {
                /* 에러가 발생했습니다! */
                alert("<spring:message code='fail.common.msg' />");
            }, true);
        }

        // 점수 저장
        function submitScore(no, asmtId, stdNo) {
            // 점수 입력
            if ($("#eScore" + no).val() == "" || $("#eScore" + no).val() == undefined) {

                /* 점수를 숫자로 입력하세요. */
                alert("<spring:message code='common.pop.insert.scr.only.number' />");
                return false;
            }

            if ($("#eScore" + no).val() > 100) {
                /* 점수는 100점 까지 입력 가능 합니다. */
                alert("<spring:message code='common.pop.max.scr.hundred' />");
                return false;
            }

            // 과제 유형에 따라 URL 분기(개인, 팀)
            var url = "/asmt/profAsmtMrkModify.do";
            var data = {
                "asmtId": asmtId,
                "stdNo": stdNo,
                "scr": $("#eScore" + no).val(),
                "scoreType": 'batch'
            };

            if (confirm("<spring:message code='common.save.msg'/>")) {
                ajaxCall(url, data, function (data) {
                    if (data.result > 0) {
                        /* 점수 등록이 완료되었습니다. */
                        alert("<spring:message code='exam.alert.scr.finish' />");
                        location.reload();
                    } else {
                        alert(data.message);
                    }
                }, function (xhr, status, error) {
                    /* 에러가 발생했습니다! */
                    alert("<spring:message code='fail.common.msg' />");
                }, true);
            }
        }

        // 제출내용 팝업
        function asmntsbmsnCtsPop(asmtSbmsnId) {
            $("#asmntsbmsnCtsForm input[name='crsCreCd']").val("${vo.crsCreCd}");
            $("#asmntsbmsnCtsForm input[name='asmtSbmsnId']").val(asmtSbmsnId);
            $("#asmntsbmsnCtsForm").attr("target", "asmntsbmsnCtsIfm");
            $("#asmntsbmsnCtsForm").attr("action", "/asmt/profAsmtSbmsnCtsPopSelectView.do");
            $("#asmntsbmsnCtsForm").submit();
            $("#asmntsbmsnCtsPop").modal("show");
        }
    </script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
<div id="loading_page">
    <p><i class="notched circle loading icon"></i></p>
</div>
<div id="wrap">
    <div style="min-height: 350px">
        <div class="option-content">
            <h2 class="page-title">${cVo.crsCreNm } (${cVo.declsNo }<spring:message
                    code="asmnt.label.decls.name"/>)</h2><!-- 반 -->
            <div class="mla fcBlue">
                <ul class="list_verticalline">
                    <li>${gVo.deptNm }</li>
                    <li>${gVo.userNm }( ${gVo.userId } )</li>
                    <c:if test="${gVo.scr ne '' && gVo.scr ne NULL}">
                        <li>
                            ${gVo.scr}<spring:message code="asmnt.label.point" /><!-- 점 -->
                        </li>
                    </c:if>
                </ul>
            </div>
        </div>
        <div id="prevAsmntFiles"></div>
    </div>
    <div class="bottom-content mt70">
        <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message
                code="asmnt.button.close"/></button><!-- 닫기 -->
    </div>
</div>
<form id="asmntsbmsnCtsForm" name="asmntsbmsnCtsForm">
    <input type="hidden" name="crsCreCd"/>
    <input type="hidden" name="asmtSbmsnId"/>
</form>
<div class="modal fade" id="asmntsbmsnCtsPop" tabindex="-1" role="dialog" aria-labelledby="audio" data-backdrop="static"
     data-keyboard="false" aria-hidden="false" style="display: none;">
    <div class="modal-dialog modal-lg" role="document" style="margin: 20px auto;">
        <div class="modal-content">
            <div class="modal-header p20">
                <button type="button" class="close" data-dismiss="modal"
                        aria-label="<spring:message code='team.common.close'/>"><!-- 닫기 -->
                    <span aria-hidden="true">&times;</span>
                </button>
                <%-- <h4 class="modal-title"><spring:message code="asmt.label.send.content" /><!-- 제출내용 --></h4> --%>
            </div>
            <div class="modal-body p10">
                <iframe src="" width="100%" id="asmntsbmsnCtsIfm" name="asmntsbmsnCtsIfm"></iframe>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
<script>
    $('iframe').iFrameResize();
    window.closeModal = function () {
        $('.modal').modal('hide');

        $("#asmntsbmsnCtsIfm").attr("src", "");
    };
</script>
</body>
</html>