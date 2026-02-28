<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
    <%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

    <link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2"/>
    <script type="text/javascript" src="/webdoc/js/iframe.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#searchValue").on("keydown", function (e) {
                if (e.keyCode == 13) {
                    asmntStuSelectPop();
                }
            });
        });

        // 과제 학생 선택 팝업
        function asmntStuSelectPop() {
            $("#asmntStuSelectForm > input[name='crsCreCd']").val('<c:out value="${aVo.crsCreCd}" />');
            $("#asmntStuSelectForm > input[name='asmtId']").val('<c:out value="${aVo.asmtId}" />');
            $("#asmntStuSelectForm > input[name='searchValue']").val($("#searchValue").val());
            $("#asmntStuSelectForm").attr("target", "asmntStuSelectIfm");
            $("#asmntStuSelectForm").attr("action", "/asmt/profAsmntStdntChcPopView.do");
            $("#asmntStuSelectForm").submit();
            $('#asmntStuSelectPop').modal('show');

            $("#viewContainer").css("height", "500px");

        }

        function asmntStuSelectPopCallback(returnData) {
            var url = "";
            if ("${vo.teamAsmtStngyn}" == 'Y') {
                url = "/asmt/profAsmtTeamPtcpntSelect.do";
            } else {
                url = "/asmt/profAsmtSbmsnPtcpntSelect.do";
            }

            var data = {
                selectType: "OBJECT"
                , crsCreCd: "${aVo.crsCreCd}"
                , asmtId: "${aVo.asmtId}"
                , stdNo: returnData.stdNo
            };

            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    var returnVO = data.returnVO;

                    if (returnVO.konanMaxCopyRate) {
                        var url = "https://mosalms.hycu.ac.kr/scr.html?domain=e_asmnt&docId=" + returnVO.asmtSbmsnId;
                        $("#mosaIframe").attr("src", url);
                        $("#mosaIframe").show();
                        $("#contNone").hide();
                    } else {
                        $("#mosaIframe").hide();
                        $("#contNone").show();
                    }

                    if (returnVO.userId) {
                        $("#searchUserText").html(returnVO.userNm + "(" + returnVO.userId + ")");
                    } else {
                        $("#searchUserText").html("");
                    }

                    $("#searchValue").val("");
                } else {
                    alert(data.message);
                    $("#mosaIframe").hide();
                    $("#contNone").show();
                }

                $('iframe').iFrameResize();
            }, function (xhr, status, error) {
                alert("<spring:message code='fail.common.msg' />"); // 에러가 발생했습니다!
                $("#mosaIframe").hide();
                $("#contNone").show();
            }, true);
        };
    </script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
<div id="loading_page">
    <p><i class="notched circle loading icon"></i></p>
</div>
<div id="wrap">
    <div class="ui form">
        <div class="option-content mt10 mb10">
            <div class="ui action input search-box">
                <input id="searchValue" type="text" placeholder="이름/학번" value="" class="w250"/>
                <button class="ui icon button" type="button" onclick="asmntStuSelectPop()">
                    <i class="search icon"></i>
                </button>
            </div>
            <span id="searchUserText"></span>
            <div class="flex-left-auto">
                <a href="https://lms.hycu.ac.kr/content/mosa/답안유사율 비교 방법_매뉴얼.pdf" target="_blank"
                   class="ui basic button"><spring:message code="scr.button.manual.down" /><!-- 매뉴얼 다운로드 --></a>
            </div>
        </div>
        <div id="viewContainer">
            <iframe src="" style="height: 500px; width: 100%; display: none;" id="mosaIframe"></iframe>
            <div class="ui message" id="contNone">
                <h4><!-- <i class="icon circle info fcBlue opacity7 mr5"></i> -->[답안유사율 비교 방법]</h4>
                <p>∙ 검사하고자 하는 학생의 이름 또는 학번을 입력 후 돋보기 버튼 클릭</p>
                <p>∙ 또는 돋보기 버튼 클릭 후 검사하고자 하는 학생 선택</p>
            </div>
        </div>
    </div>
    <div class="bottom-content">
        <button class="ui black cancel button" onclick="window.parent.closeModal();">
            <spring:message code="common.button.close" /><!-- 닫기 --></button>
    </div>
</div>
<!-- 과제 학생 선택 팝업 -->
<form id="asmntStuSelectForm" name="asmntStuSelectForm" method="post">
    <input type="hidden" name="crsCreCd"/>
    <input type="hidden" name="asmtId"/>
    <input type="hidden" name="searchValue"/>
</form>
<div class="modal fade" id="asmntStuSelectPop" tabindex="-1" role="dialog" aria-labelledby="학생목록" aria-hidden="false">
    <div class="modal-dialog modal-lg" role="document" style="margin: 40px auto;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"
                        aria-label="<spring:message code="sys.button.close" />">
                    <span aria-hidden="true">&times;</span>
                </button>
                <!-- <h4 class="modal-title">학생목록</h4> -->
            </div>
            <div class="modal-body">
                <iframe src="" id="asmntStuSelectIfm" name="asmntStuSelectIfm" width="100%" height="1500px"
                        scrolling="no" title="평가기준"></iframe>
            </div>
        </div>
    </div>
</div>
<script>
    $('iframe').iFrameResize();
    window.closeModal = function () {
        $("#asmntStuSelectIfm").attr("src", "");
        $('.modal').modal('hide');
        $("#viewContainer").css("height", "unset");
        $('iframe').iFrameResize();
    };
</script>
<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>