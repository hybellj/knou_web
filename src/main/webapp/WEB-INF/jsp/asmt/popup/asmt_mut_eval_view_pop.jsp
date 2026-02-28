<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
    <%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>

    <link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2"/>
    <script type="text/javascript">
        $(document).ready(function () {
            forumMutList();
        });

        function forumMutList() {
            var url = '/asmtProfAsmtMutEvlList.do';
            var data = {
                asmtSbmsnId: "${vo.asmtSbmsnId}"
                , stdNo: "${vo.stdNo}"
                , crsCreCd: "${vo.crsCreCd}"
            };

            ajaxCall(url, data, function (data) {
                if (data.result > 0) {
                    var returnList = data.returnList || [];
                    var html = '';

                    if (returnList.length > 0) {
                        returnList.sort(function (a, b) {
                            if (a.regDttm > b.regDttm) return 1;
                            if (a.regDttm < b.regDttm) return -1;

                            return 0;
                        });

                        returnList.forEach(function (v, i) {
                            var regDttmFmt = (v.regDttm || "").length == 14 ? v.regDttm.substring(0, 4) + '.' + v.regDttm.substring(4, 6) + '.' + v.regDttm.substring(6, 8) + ' (' + v.regDttm.substring(8, 10) + ':' + v.regDttm.substring(10, 12) + ')' : v.regDttm;
                            ;
                            var scr = v.scr;

                            html += '<ul>';
                            html += '	<li class="imgBox flex-item">';
                            html += '		<div class="initial-img sm c-4">';
                            if (v.phtFile) {
                                html += '		<img src="' + v.phtFile + '" alt="Image">';
                            } else {
                                html += v.regNm;
                            }
                            html += '		</div>';
                            html += '	</li>';
                            html += '	<li>';
                            html += '		<ul>';
                            html += '			<li class="flex-item">';
                            html += '				<em class="mra">' + v.regNm + '<code>' + regDttmFmt + '</code></em>';
                            html += '				<div class="ui tiny star rating gap4" data-rating="0" data-max-rating="5">';
                            for (var j = 0; j < 5; j++) {
                                if (scr-- > 0) {
                                    html += '			<i class="star icon fcYellow"></i>';
                                } else {
                                    html += '			<i class="star outline icon"></i>';
                                }
                            }

                            html += '				</div>';
                            html += '			</li>';
                            html += '			<li style="word-break: break-word; white-space: pre-line;">';
                            html += v.scoreCmnt;
                            html += '			</li>';
                            html += '		</ul>';
                            html += '	</li>';
                            html += '</ul>';
                        });
                    } else {
                        html += "<div class='flex-container m-hAuto'>";
                        html += "    <div class='no_content'>";
                        html += "        <i class='icon-cont-none ico f170'></i>";
                        html += "        <span><spring:message code='team.common.empty' /></span>"; // 등록된 내용이 없습니다.
                        html += "    </div>";
                        html += "</div>";
                    }

                    $("#commentViewArea").html(html);
                } else {
                    alert(data.message);
                }
            }, function (xhr, status, error) {
                alert('<spring:message code="fail.common.msg" />'); // 에러가 발생했습니다!
            });
        }
    </script>
</head>
<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
<div id="loading_page">
    <p><i class="notched circle loading icon"></i></p>
</div>
<div id="wrap">
    <div class="ui form">
        <div class="article p5 commentlist ui segment" id="commentViewArea"
             style="display: block; max-height: 500px; overflow: auto;">
            <!--
            <ul>
                <li class="imgBox">
                    <div class="initial-img sm c-4">
                        <img src="" alt="Image" />
                    </div>
                </li>
                <li>
                    <ul>
                        <li class="flex-item">
                            <em class="mra">학생
                                <code>
                                    2023.11.23 (14:38)
                                </code>
                            </em>
                            <div class="ui tiny star rating gap4" data-rating="0" data-max-rating="5">
                                <i class="star icon fcYellow"></i>
                                <i class="star icon fcYellow"></i>
                                <i class="star icon fcYellow"></i>
                                <i class="star icon fcYellow"></i>
                                <i class="star outline icon"></i>
                            </div>
                        </li>
                        <li style="word-break: break-word">
                            고생하셨어요.
                        </li>
                    </ul>
                </li>
            </ul>
             -->
        </div>
    </div>
    <div class="bottom-content tr">
        <button type="button" class="ui black cancel button" onclick="window.parent.closeModal();">
            <spring:message code="common.button.close" /><!-- 닫기 --></button>
    </div>
</div>
<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>