<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="ko" style="position: fixed; width: 100%;">
<head>
    <%@ include file="/WEB-INF/jsp/common/modal_common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/common_inc.jsp" %>
    <link rel="stylesheet" type="text/css" href="/webdoc/css/class_default.css?v=2"/>
    <link rel="stylesheet" type="text/css" href="/webdoc/css/xeicon.min.css"/>
</head>

<div id="loading_page">
    <p><i class="notched circle loading icon"></i></p>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        listCmnt();
    });

    // 댓글 목록
    function listCmnt() {
        var url = "/asmt/profAsmtCmntList.do";
        var data = {
            "stdNo": "${gVo.stdNo}",
            "asmtId": "${gVo.asmtId}"
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                var returnList = data.returnList || [];
                var html = "";

                if (returnList.length > 0) {
                    returnList.forEach(function (v, i) {
                        var lvlClass = v.cmntLvl > 1 ? "co_inner" : "";
                        html += "<ul class='" + lvlClass + "'>";
                        html += "	<li class='user imgBox'>";
                        var userImg = v.phtFile != null ? v.phtFile : "/webdoc/img/icon-hycu-symbol-grey.svg";
                        html += "		<div class='initial-img md circle'><img src='" + userImg + "' alt=''></div>";
                        html += "	</li>";
                        html += "	<li>";
                        html += "		<ul>";
                        html += "			<li class='flex-item'>";
                        var modDttm = v.modDttm.substring(0, 4) + "." + v.modDttm.substring(4, 6) + "." + v.modDttm.substring(6, 8) + " " + v.modDttm.substring(8, 10) + ":" + v.modDttm.substring(10, 12);
                        html += "				<em class='mra'>" + v.regNm + " <code>" + modDttm + " | <em class='fcBlue'>글자수 : " + v.cmntLen + "자</em></code></em>";
                        html += "				<button type='button' class='toggle_btn' onclick='btnAddCmnt(\"" + i + "\", \"" + v.asmntCmntId + "\")'>댓글</button>";
                        if (v.delYn != "Y" && "${userId }" == v.rgtrId) {
                            html += "				<ul class='ui icon top right pointing dropdown' tabindex='0'>";
                            html += "					<i class='xi-ellipsis-v p5'></i>";
                            html += "					<div class='menu' tabindex='-1'>";
                            html += "						<button type='button' class='item' onClick='editBtnClick(\"" + i + "\", \"" + v.asmntCmntId + "\")'>수정</button>";
                            html += "						<button type='button' class='item' onClick='delCmnt(\"" + v.asmntCmntId + "\")'>삭제</button>";
                            html += "					</div>";
                            html += "				</ul>";
                        }
                        html += "			</li>";
                        html += "			<li id='cmntText" + i + "'>";
                        if ("${menuType}" == "PROFESSOR") {
                            if (v.cmntLvl > 1) {
                                html += "				<em class='mra'>@" + v.parRegNm + "</em>";
                            }
                            html += "				" + v.asmntCmntCts;
                            if (v.delYn == "Y") {
                                html += " 				<span class='ui red label p4 f080'><spring:message code='forum.label.sapn.del.content'/></span>"; // 삭제됨
                            }
                        } else {
                            if (v.delYn == "Y") {
                                html += "				<span class='ui red label'><spring:message code='forum.label.del.forum.cmnt' /></span>";/* 삭제된 댓글 입니다. */
                            } else {
                                if (v.cmntLvl > 1) {
                                    html += "				<em class='mra'>@" + v.parRegNm + "</em>";
                                }
                                html += "				" + v.asmntCmntCts;
                            }
                        }
                        html += "			</li>";
                        html += "			<li class='toggle_box' id='toggle_cmnt" + i + "'>";
                        html += "				<ul class='comment-write'>";
                        html += "					<li>";
                        html += "						<textarea rows='3' class='wmax' id='asmntCmntCts" + i + "' placeholder='댓글을 입력하세요.'></textarea>";
                        html += "					</li>";
                        html += "					<li>";
                        html += "						<a href='javascript:addCmnt()' id='addBtn" + i + "' class='ui basic grey small button'>등록</a>";
                        html += "					</li>";
                        html += "				</ul>";
                        html += "			</li>";
                        html += "		</ul>";
                        html += "	</li>";
                        html += "</ul>";
                    });
                } else {
                    html += "	<div class='flex-container m-hAuto'>";
                    html += "		<div class='no_content'>";
                    html += "			<i class='icon-cont-none ico f170'></i>";
                    html += "			<span><spring:message code='asmnt.message.empty' /></span>"; // 등록된 내용이 없습니다.
                    html += "		</div>";
                    html += "	</div>";
                }
                $("#cmntDiv").empty().html(html);
                $(".dropdown").dropdown();
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            alert("<spring:message code='asmnt.alert.error' />");/* 오류가 발생했습니다! */
        });
    }

    // 댓글 저장
    function saveCmnt(idx, asmntCmntId) {
        var asmntCmntCts = $("#asmntCmntCts" + idx).val();
        if ($.trim(asmntCmntCts) == "") {
            alert("댓글을 입력하세요.");
            return false;
        }

        var url = "/asmt/profAsmtCmntRegist.do";
        var data = {
            "crsCreCd": "${cVo.crsCreCd}",
            "stdNo": "${gVo.stdNo}",
            "asmtId": "${gVo.asmtId}",
            "asmntCmntCts": asmntCmntCts,
            "upAsmntCmntId": asmntCmntId
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                alert("댓글 등록이 완료되었습니다.");
                $("#asmntCmntCts" + idx).val("");
                listCmnt();
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            alert("<spring:message code='asmnt.alert.error' />");/* 오류가 발생했습니다! */
        });
    }

    // 댓글 수정
    function editCmnt(idx, asmntCmntId) {
        var asmntCmntCts = $("#asmntCmntCts" + idx).val();
        if ($.trim(asmntCmntCts) == "") {
            alert("댓글을 입력하세요.");
            return false;
        }

        var url = "/asmt/profAsmtCmntModify.do";
        var data = {
            "crsCreCd": "${cVo.crsCreCd}",
            "stdNo": "${gVo.stdNo}",
            "asmtId": "${gVo.asmtId}",
            "asmntCmntCts": asmntCmntCts,
            "asmntCmntId": asmntCmntId
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                alert("댓글 수정이 완료되었습니다.");
                $("#asmntCmntCts" + idx).val("");
                listCmnt();
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            alert("<spring:message code='asmnt.alert.error' />");/* 오류가 발생했습니다! */
        });
    }

    // 하위 댓글 등록 폼
    function btnAddCmnt(idx, asmntCmntId) {
        if ($("#toggle_cmnt" + idx).hasClass("on")) {
            $("#toggle_cmnt" + idx).removeClass("on").addClass("off");
        } else {
            $("#toggle_cmnt" + idx).removeClass("off").addClass("on");
            $("#asmntCmntCts" + idx).val("");
            $("#addBtn" + idx).attr("href", "javascript:saveCmnt(\"" + idx + "\", \"" + asmntCmntId + "\")");
        }
    }

    // 하위 댓글 수정 폼
    function editBtnClick(idx, asmntCmntId) {
        if (!$("#toggle_cmnt" + idx).hasClass("on")) {
            $("#toggle_cmnt" + idx).removeClass("off").addClass("on");
        }
        $("#asmntCmntCts" + idx).val($("#cmntText" + idx).text());
        $("#addBtn" + idx).attr("href", "javascript:editCmnt(\"" + idx + "\", \"" + asmntCmntId + "\")");
    }

    // 댓글 삭제
    function delCmnt(asmntCmntId) {
        var url = "/asmt/profAsmtCmntModify.do";
        var data = {
            "crsCreCd": "${cVo.crsCreCd}",
            "stdNo": "${gVo.stdNo}",
            "asmtId": "${gVo.asmtId}",
            "asmntCmntId": asmntCmntId,
            "delYn": "Y"
        };

        ajaxCall(url, data, function (data) {
            if (data.result > 0) {
                alert("댓글 삭제가 완료되었습니다.");
                listCmnt();
            } else {
                alert(data.message);
            }
        }, function (xhr, status, error) {
            alert("<spring:message code='asmnt.alert.error' />");/* 오류가 발생했습니다! */
        });
    }
</script>

<body class="modal-page <%=SessionInfo.getThemeMode(request)%>">
<div id="wrap">
    <div class="option-content">
        <h2 class="page-title">${cVo.crsCreNm } (${cVo.declsNo }<spring:message code="asmnt.label.decls.name"/>)</h2>
        <!-- 반 -->
        <div class="mla fcBlue">
            <ul class="list_verticalline  ">
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

    <textarea rows="3" cols="5" id="asmntCmntCts"></textarea>
    <div class="bottom-content">
        <button class="ui blue button" onclick="saveCmnt('', '')"><spring:message code="asmnt.button.save"/></button>
        <!-- 저장 -->
    </div>

    <div class="ui segment">
        <div class='article p10 commentlist' id="cmntDiv" style="display:block;">
        </div>
    </div>

    <div class="bottom-content mt70">
        <button class="ui black cancel button" onclick="window.parent.closeModal();"><spring:message
                code="asmnt.button.close"/></button><!-- 닫기 -->
    </div>
</div>
<script type="text/javascript" src="/webdoc/js/iframe-content.js"></script>
</body>
</html>