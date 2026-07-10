<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/forum2/common/dscs_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
        <jsp:param name="module" value="table,editor,fileuploader"/>
    </jsp:include>
    <title>교수자 토론 등록/수정</title>
    <script type="text/javascript">
    var EPARAM			= '<c:out value="${encParams}" />';

    var dialog;
    const editors = {};	// 에디터 목록 저장용
    var teamUploaderIds   = [];  // 팀 업로더 ID 목록 (순서 보장)
    var teamUploadResults = {};  // { uploaderId: {uploadFiles, uploadPath} }

    $(document).ready(function() {
        // 부주제 조회
        /*
            var teamGrpId = $("#teamGrpId" + e.id.split("_")[1]).val().split(":")[0];	// 팀그룹아이디
            var teamGrpnm = $("#teamGrpnm" + e.id.split("_")[1]).val();				// 팀그룹명
            var dvclasNo = e.id.split("_")[1];										// 분반 순서
            var sbjctId = e.value.split(":")[1];									// 과목아이디

            // Initial edit mode uses dscsVO.teamDscsList rendered by the server.
        });
        */

        bindEvents();
        initSwitchYnFields();
        toggleTeamArea();
        initForumTeamList();
        initCheckedDvclas();
    });

    // 체크된 분반 초기화
    function initCheckedDvclas() {
        $("input[name='sbjctIds']:checked").each(function() {
            dvclasChcChange(this);
        });
    }

    // 버튼 binding
    function bindEvents() {
        $("input[name='dscsUnitTycd']").on('change', function () {
            toggleTeamArea();
        });

        $('#btnSave').on('click', function () {
            saveDscs();
        });

        $('#btnCopy').on('click', function () {
            forumCopy();
        });

        $('#btnGoList').on('click', function () {
            goList();
        });

        $('#oatclInqyn, #oknokRgtrOyn, #oknokrtOyn, #mltOpnnRegyn, #oknokModyn').on('change', function () {
            syncSwitchHiddenById(this.id);
        });
    }

    // 목록 이동
    function goList() {
        location.href = '<c:url value="/forum2/forumLect/profForumListView.do" />?' + "encParams=" + EPARAM;
    }

    function syncSwitchHiddenById(switchId) {
        var $switch = $('#' + switchId);
        var $hidden = $('#' + switchId + 'Hidden');
        if ($hidden.length === 0) {
            return;
        }
        $hidden.val($switch.is(':checked') ? 'Y' : 'N');
    }

    function syncAllSwitchHidden() {
        var switchIds = ['oatclInqyn', 'oknokRgtrOyn', 'oknokrtOyn', 'mltOpnnRegyn', 'oknokModyn'];
        for (var i = 0; i < switchIds.length; i++) {
            syncSwitchHiddenById(switchIds[i]);
        }
    }

    function setSwitcherValue(switchId, value) {
        var yn = (value === 'Y') ? 'Y' : 'N';
        if (yn === 'Y') {
            UiSwitcherOn(switchId);
        } else {
            UiSwitcherOff(switchId);
        }
        syncSwitchHiddenById(switchId);
    }

    // Switch 버튼들 값 설정
    function initSwitchYnFields() {
        syncAllSwitchHidden();
    }

    // 저장전 date + time 합침.
    function syncDiscussionDateTimeFields() {
        var dscsSdttm = UiComm.getDateTimeVal("dateSt", "timeSt");
        var dscsEdttm = UiComm.getDateTimeVal("dateEd", "timeEd");
        $('#dscsSdttm').val(dscsSdttm);
        $('#dscsEdttm').val(dscsEdttm);
    }

    function toggleTeamArea() {
        var dscsUnitTycd = $("input[name='dscsUnitTycd']:checked").val();
        if (dscsUnitTycd === 'Y') {
            $('#teamArea').show();
        } else {
            $('#teamArea').hide();
            // 수정 모드('E')가 아닐 때만 초기화하도록 조건 추가
            if ('${mode}' !== 'E') {
                $('#dscsGrpId').val('');
                $('#teamGrpId').val('');
                $('#dvclasNo').val('');
            }
            teamUploaderIds = [];
            teamUploadResults = {};
        }
    }

    /**
     * 분반 선택 변경
     * @param {obj}  obj - 선택한 분반 체크박스
     */
    function dvclasChcChange(obj) {
        if(obj.value == "all") {
            $("input[name=sbjctIds]").not(".readonly").prop("checked", obj.checked);

            if(obj.checked) {
                $("div[id^='teamForumBlock']").show();
                $("div[id^='teamGrpView']").css("display", "flex");
                $("input[name='teamGrpSubForumSettingyns']:checked").each(function(i, e) {
                    $("#setForumDiv"+e.id.split("_")[1]).show();
                });
            } else {
                var fixDvclas = $("input[name=sbjctIds]").filter(".readonly")[0].id.split("_")[1];
                $("div[id^='teamForumBlock']").not("#teamForumBlock"+fixDvclas).hide();
                $("div[id^='teamGrpView']").not("#teamGrpView"+fixDvclas).hide();
                $("div[id^='setForumDiv']").not("#setForumDiv"+fixDvclas).hide();
            }
        } else {
            if ($(obj).hasClass('readonly')) {
                obj.checked = true;
                $("#teamForumBlock" + obj.id.split("_")[1]).show();
                $("#teamGrpView" + obj.id.split("_")[1]).css("display", "flex");
                $("#setForumDiv"+obj.id.split("_")[1]).show();
                return;
            }
            $("#allDeclas").prop("checked", $("input[name=sbjctIds]").length == $("input[name=sbjctIds]:checked").length);

            if(obj.checked) {
                $("#teamForumBlock" + obj.id.split("_")[1]).show();
                $("#teamGrpView" + obj.id.split("_")[1]).css("display", "flex");
                $("#setForumDiv"+obj.id.split("_")[1]).show();
            } else {
                $("#teamForumBlock" + obj.id.split("_")[1]).hide();
                $("#teamGrpView" + obj.id.split("_")[1]).hide();
                $("#setForumDiv"+obj.id.split("_")[1]).hide();
            }
        }
    }

    /**
     * 팀 퀴즈 여부 변경
     * @param {String}  value - 팀 퀴즈 여부
     */
    function teamynChange(value) {
        if(value == "Y") {
            $("#teamForumDiv").show();
            $("input[name='oknokStngyn'][value='N']").prop('checked', true);
        } else {
            $("#teamForumDiv").hide();
        }
    }

    function oknokStngynChange(value) {
        if(value == "Y") {
            $("input[name='dscsUnitTycd'][value='N']").prop('checked', true);
            teamynChange('N');
        }
        toggleProsConsOptionArea(value);
    }

    function toggleProsConsOptionArea(value) {
        if (value === 'Y') {
            $('#oknok_option_area').show();
        } else {
            $('#oknok_option_area').hide();
        }
    }

    /**
     * 팀그룹지정 팝업
     * @param {Integer} i 		- 분반 순서
     * @param {String}  sbjctId - 과목아이디
     */
    function teamCtgrSelectPop(i, sbjctId) {
        dialog = UiDialog("dialog1", {
            title: "<spring:message code='forum.button.lrngrp.assign'/>", // 학습그룹지정
            width: 600,
            height: 500,
            url: "/team/teamHome/teamCtgrSelectPop.do?sbjctId="+sbjctId+"&searchFrom="+i + ":" + sbjctId,
            autoresize: false
        });
    }

    /**
     * 팀그룹 선택
     * @param {String}  teamGrpId 	- 팀그룹아이디
     * @param {String}  teamGrpnm 	- 팀그룹명
     * @param {String}  id 			- 분반 순서:과목개설아이디
     * @returns {list} 팀 목록
     */
    function selectTeam(teamGrpId, teamGrpnm, id) {
        var idList = id.split(':');
        $("#teamGrpId" + idList[0]).val(teamGrpId + ":" + idList[1]);
        $("#teamGrpnm" + idList[0]).val(teamGrpnm);
        $("#setForumDiv" + idList[0]).show();

        loadForumTeamList(teamGrpId, idList[0]);
    }

    /** 팀그룹 팀 목록 조회 후 subInfoDiv 에 렌더링 */
    function loadForumTeamList(teamGrpId, dvclasNo) {
        var url  = '<c:url value="/forum2/forumLect/profDscsTeamGrpTeamListAjax.do" />';
        var data = {
            teamGrpId : teamGrpId,
            upDscsId : '${dscsVO.dscsId}',
            byteamDscsUseyn : $('#teamGrpSubForumSettingyn_' + dvclasNo).is(':checked') ? 'Y' : 'N'
        };
        ajaxCall(url, data, function(resp) {
            if (resp.result > 0) {
                var returnList = resp.returnList || [];
                var html = buildForumTeamListHtml(returnList);
                $("#subInfoDiv" + dvclasNo).empty().html(html);
                teamUploaderIds = teamUploaderIds.filter(function(uid) {
                    return uid.indexOf('teamFileUploader_') !== 0;
                });
                teamUploadResults = {};
                if (returnList.length > 0) {
                    returnList.forEach(function(v, i) {
                        editors[v.teamId + '_editor' + i] = UiEditor({
                            targetId  : v.teamId + '_contentTextArea_' + i,
                            uploadPath: "${dscsVO.uploadPath}",
                            height    : "250px"
                        });
                        // TODO : 26.4.2 (팀별 파일 업로더)
                        createTeamFileUploader(v.teamId, i, "${dscsVO.uploadPath}", v.fileList);
                    });
                }
            } else {
                UiComm.showMessage(resp.message, "error");
            }
        });
    }

    /** 팀 목록 HTML 생성 (appendTeamForumDetailParams 호환 구조) */
    function buildForumTeamListHtml(list) {
        if (!list || list.length === 0) {
            return '<p class="p_gray"></p>'; // 팀 정보가 없는 경우.
        }
        var html = "<div class='table-wrap mb30'>";
        html += "    <table class='table-type5 in_table'>";
        html += "        <colgroup>";
        html += "            <col class='width-5per' />";
        html += "            <col class='width-15per' />";
        html += "            <col />";
        html += "        </colgroup>";
        list.forEach(function(v, i) {
            html += "        <tbody class='subForumTr team-subforum-item' data-team-id='" + escHtml(v.teamId || '') + "' data-team-nm='" + escHtml(v.teamnm || '') + "' data-dscs-id='" + escHtml(v.dscsId || '') + "' data-team-row-index='" + i + "'>";
            html += "            <tr>";
            html += "                <th rowspan='4' class='group-header'><label class='teamNm' data-role='team-name'>" + escHtml(v.teamnm || ('<spring:message code='forum.label.team'/> ' + (i + 1))) + "</label></th>";
            html += "                <th><label><spring:message code='forum.label.lrngrp.mebers'/></label></th>"; // 학습그룹 구성원
            html += "                <td>" + escHtml(v.leaderNm || '-') + " <spring:message code='forum.label.person.and'/> " + Math.max(0, (v.teamMbrCnt || 1) - 1) + "</td>";
            html += "            </tr>";
            html += "            <tr>";
            html += "                <th><label for='" + v.teamId + "_dtlSubjTtl_" + i + "'><spring:message code='forum.label.team.ttl'/></label></th>"; // 부주제
            html += "                <td><div class='form-row'><input class='form-control width-100per' type='text' id='" + v.teamId + "_dtlSubjTtl_" + i + "' name='teamTtl' value='" + escHtml(v.dscsTtl || '') + "' inputmask='byte' maxLen='200' data-role='team-title' placeholder='<spring:message code='forum.label.topic.input'/>' /></div></td>"; // 주제 입력
            html += "            </tr>";
            html += "            <tr>";
            html += "                <th><label for='" + v.teamId + "_contentTextArea_" + i + "'><spring:message code='common.label.contents'/></label></th>"; // 내용
            html += "                <td><div class='editor-box'><textarea name='" + v.teamId + "_contentTextArea_" + i + "' id='" + v.teamId + "_contentTextArea_" + i + "' data-role='team-contents'>" + escHtml(v.dscsCts || '') + "</textarea></div></td>";
            html += "            </tr>";
            html += "            <tr>";
            html += "                <th><label><spring:message code='forum.label.attachFile'/></label></th>"; // 첨부파일
            html += "                <td><div id='teamUploaderWrap_" + v.teamId + "_" + i + "'></div></td>";
            html += "            </tr>";
            html += "        </tbody>";
        });
        html += "    </table>";
        html += "</div>";
        return html;
    }

    /** 팀별 파일 업로더 동적 생성 */
    function createTeamFileUploader(teamId, idx, uploadPath, fileList) {
        var uid  = 'teamFileUploader_' + teamId + '_' + idx;    // 파일 업로드 개별 ID
        var wrap = 'teamUploaderWrap_' + teamId + '_' + idx;    // 파일 업로드 박스가 보여질 위치

        // 파일업로더 생성
        UiFileUploader({
            id: uid,
            targetId: wrap,
            path: uploadPath,
            limitCount: 1,
            limitSize: 100,
            oneLimitSize: 100,
            listSize: 1,
            fileList: fileList,
            finishFunc: onTeamUploadComplete,
            allowedTypes: "*",
            uiMode: "simple"
        });

        // 팀 업로드 정보에 uid 추가
        if (teamUploaderIds.indexOf(uid) === -1) {
            teamUploaderIds.push(uid);
        }
    }

    function escHtml(str) {
        return (str || '').replace(/&/g, '&amp;').replace(/</g, '&lt;')
                          .replace(/>/g, '&gt;').replace(/"/g, '&quot;');
    }

    function initTeamForumRows($container, resetUploadState) {
        if (!$container || $container.length === 0) {
            return;
        }
        if (resetUploadState) {
            teamUploaderIds = teamUploaderIds.filter(function(uid) {
                return uid.indexOf('teamFileUploader_') !== 0;
            });
            teamUploadResults = {};
        }
        $container.find('.team-subforum-item').each(function(rowIdx) {
            var $row = $(this);
            var teamId = $.trim($row.attr('data-team-id') || '');
            var idx = $row.attr('data-team-row-index');
            if (idx === undefined || idx === null || idx === '') {
                idx = rowIdx;
                $row.attr('data-team-row-index', idx);
            }
            if (!teamId) {
                return;
            }
            var fileList = [];
            $row.find('.team-file-data').each(function() {
                fileList.push({
                    fileId: $(this).attr('data-file-id') || '',
                    fileNm: $(this).attr('data-file-nm') || '',
                    fileSize: $(this).attr('data-file-size') || 0
                });
            });
            var targetId = teamId + '_contentTextArea_' + idx;
            if ($('#' + targetId).length > 0 && !editors[teamId + '_editor' + idx]) {
                editors[teamId + '_editor' + idx] = UiEditor({
                    targetId  : targetId,
                    uploadPath: "${dscsVO.uploadPath}",
                    height    : "250px"
                });
            }
            if ($('#teamUploaderWrap_' + teamId + '_' + idx).length > 0) {
                createTeamFileUploader(teamId, idx, "${dscsVO.uploadPath}", fileList);
            }
        });
    }

    /** 수정모드 진입 시 이미 지정된 팀그룹의 팀 목록 초기 로드 */
    function initForumTeamList() {
        if ('${mode}' !== 'E') return;
        $("div[id^='subInfoDiv']").each(function() {
            initTeamForumRows($(this), false);
        });
    }

    /**
     * 팀그룹 설정여부 변경
     * @param {obj}  obj - 분반 팀그룹 과제 설정 체크박스
     */
    function teamGrpSubForumSettingynChange(obj) {
        if(obj.checked) {
            $("#subInfoDiv" + obj.id.split("_")[1]).show();
            var dvclasNo = obj.id.split("_")[1];
            var teamGrpId = (($("#teamGrpId" + dvclasNo).val() || '').split(':')[0] || '');
            if (teamGrpId && $("#subInfoDiv" + dvclasNo).find('.team-subforum-item').length === 0) {
                loadForumTeamList(teamGrpId, dvclasNo);
            }
        } else {
            $("#subInfoDiv" + obj.id.split("_")[1]).hide();
            teamUploaderIds = [];
            teamUploadResults = {};
        }
    }

    function resetTeamForumDetailParams() {
        $('#forumWriteForm input.__teamForumDtlParam').remove();
    }

    function resetTeamGrpInfoParams() {
        $('#forumWriteForm input.__teamGrpInfoParam').remove();
    }

    function resetDvclasSelParams() {
        $('#forumWriteForm input.__dvclasSelParam').remove();
    }

    function appendDvclasSelParam(index, fieldName, value) {
        $('<input>', {
            type: 'hidden',
            name: 'dvclasSelList[' + index + '].' + fieldName,
            value: value || '',
            'class': '__dvclasSelParam'
        }).appendTo('#forumWriteForm');
    }

    function appendDvclasSelParams() {
        resetDvclasSelParams();

        var index = 0;
        $("input[name='sbjctIds']").each(function() {
            var id = this.id || '';
            var dvclasNo = id.indexOf('declas_') === 0 ? id.substring(7) : '';
            var sbjctId = this.value || '';
            var checkedYn = $(this).is(':checked') ? 'Y' : 'N';
            var readonlyYn = ($(this).hasClass('readonly') || $(this).prop('readonly')) ? 'Y' : 'N';

            if (!dvclasNo || !sbjctId) {
                return;
            }

            appendDvclasSelParam(index, 'dvclasNo', dvclasNo);
            appendDvclasSelParam(index, 'sbjctId', sbjctId);
            appendDvclasSelParam(index, 'checkedYn', checkedYn);
            appendDvclasSelParam(index, 'readonlyYn', readonlyYn);
            index++;
        });
    }

    function appendTeamGrpInfoParam(index, fieldName, value) {
        $('<input>', {
            type: 'hidden',
            name: 'teamGrpInfoList[' + index + '].' + fieldName,
            value: value || '',
            'class': '__teamGrpInfoParam'
        }).appendTo('#forumWriteForm');
    }

    function appendTeamGrpInfoParams() {
        resetTeamGrpInfoParams();

        var index = 0;
        $("div[id^='teamGrpView']").each(function() {
            var dvclasNo = (this.id || '').replace('teamGrpView', '');
            if (!dvclasNo) {
                return;
            }

            var teamGrpRaw = $('#teamGrpId' + dvclasNo).val() || '';
            var teamGrpnm = $.trim($('#teamGrpnm' + dvclasNo).val() || '');
            if (!teamGrpRaw) {
                return;
            }

            var tokens = teamGrpRaw.split(':');
            var teamGrpId = tokens[0] || '';
            var sbjctId = tokens.length > 1 ? (tokens[1] || '') : '';
            if (!teamGrpId) {
                return;
            }

            appendTeamGrpInfoParam(index, 'dvclasNo', dvclasNo);
            appendTeamGrpInfoParam(index, 'sbjctId', sbjctId);
            appendTeamGrpInfoParam(index, 'teamGrpId', teamGrpId);
            appendTeamGrpInfoParam(index, 'teamGrpnm', teamGrpnm);
            appendTeamGrpInfoParam(index, 'byteamDscsUseyn', $('#teamGrpSubForumSettingyn_' + dvclasNo).is(':checked') ? 'Y' : 'N');
            index++;
        });
    }

    function appendTeamForumDetailParam(index, fieldName, value) {
        $('<input>', {
            type: 'hidden',
            name: 'teamDscsDtlList[' + index + '].' + fieldName,
            value: value || '',
            'class': '__teamForumDtlParam'
        }).appendTo('#forumWriteForm');
    }

    function pickFieldValue($scope, selectors) {
        for (var i = 0; i < selectors.length; i++) {
            var $el = $scope.find(selectors[i]).first();
            if ($el.length > 0) {
                return $.trim($el.val() || $el.text() || '');
            }
        }
        return '';
    }

    function appendTeamForumDetailParams() {
        resetTeamForumDetailParams();

        if (!$("input[name='dscsUnitTycd']:checked").length || $("input[name='dscsUnitTycd']:checked").val() !== 'Y') {
            return;
        }

        var index = 0;
        $("div[id^='teamGrpView']").each(function() {
            var dvclasNo = (this.id || '').replace('teamGrpView', '');
            if (!dvclasNo) {
                return;
            }

            var teamGrpRaw = $('#teamGrpId' + dvclasNo).val() || '';
            if (!teamGrpRaw) {
                return;
            }
            var teamGrpTokens = teamGrpRaw.split(':');
            var teamGrpId = teamGrpTokens[0] || '';
            var sbjctId = teamGrpTokens.length > 1 ? (teamGrpTokens[1] || '') : '';

            var $subInfoDiv = $('#subInfoDiv' + dvclasNo);
            if ($subInfoDiv.length === 0 || $subInfoDiv.children().length === 0) {
                return;
            }

            var $teamRows = $subInfoDiv.find('[data-team-id], tr.subForumTr, .team-subforum-item');
            if ($teamRows.length === 0) {
                $teamRows = $subInfoDiv.children();
            }

            $teamRows.each(function(rowIdx) {
                var $row = $(this);
                var teamId = $.trim($row.attr('data-team-id') || pickFieldValue($row, [
                    "input[name='teamId']",
                    "input[name='teamid']",
                    "input[name='team_id']"
                ]));
                var teamNm = $.trim($row.attr('data-team-nm') || pickFieldValue($row, [
                    "input[name='teamNm']",
                    "input[name='teamnm']",
                    "input[name='team_name']",
                    "[data-role='team-name']",
                    ".teamNm",
                    ".teamnm"
                ]));
                var teamTtl = pickFieldValue($row, [
                    "input[name='teamTtl']",
                    "input[name='teamSubject']",
                    "input[name='subForumTtl']",
                    "input[name='subExamTtl']",
                    "[data-role='team-title']"
                ]);
                var teamCts = pickFieldValue($row, [
                    "textarea[name='teamCts']",
                    "textarea[name='teamDiscussion']",
                    "textarea[name='subForumCts']",
                    "textarea[id*='contentTextArea']",
                    "[data-role='team-contents']"
                ]);
                // 팀ID/팀명은 필수로 보고, 둘 다 비어있으면 빈 row로 간주한다.
                if (!teamId && !teamNm) {
                    return;
                }

                appendTeamForumDetailParam(index, 'dvclasNo', dvclasNo);
                appendTeamForumDetailParam(index, 'sbjctId', sbjctId);
                appendTeamForumDetailParam(index, 'teamGrpId', teamGrpId);
                appendTeamForumDetailParam(index, 'teamId', teamId);
                appendTeamForumDetailParam(index, 'teamNm', teamNm);
                appendTeamForumDetailParam(index, 'dscsTtl', teamTtl);
                appendTeamForumDetailParam(index, 'dscsCts', teamCts);

                // 팀 업로더 결과 수집 (rowIdx = each 내부 0-based 카운터)
                var uid          = 'teamFileUploader_' + teamId + '_' + rowIdx;
                var uploadResult = teamUploadResults[uid] || {};
                appendTeamForumDetailParam(index, 'teamUploadFiles', uploadResult.uploadFiles || '');
                appendTeamForumDetailParam(index, 'teamUploadPath',  uploadResult.uploadPath  || '${dscsVO.uploadPath}');
                var teamDx = dx5.get(uid);
                appendTeamForumDetailParam(index, 'delFileIdStr', teamDx ? teamDx.getDelFileIdStr() : '');

                // 자식 토론 ID (수정 모드에서 분기 파일 저장)
                var childDscsId = $.trim($row.attr('data-dscs-id') || '');
                appendTeamForumDetailParam(index, 'dscsId', childDscsId);
                index++;
            });
        });
    }

    /** STEP 1: 메인 업로더(fileUploader) 처리 시작 */
    function startUploadChain() {
        if (!$("input[name='dscsUnitTycd']:checked").length || $("input[name='dscsUnitTycd']:checked").val() !== 'Y') {
            teamUploaderIds = [];
            teamUploadResults = {};
        }
        var dx = dx5.get("fileUploader");
        if (dx && dx.availUpload()) {
            dx.startUpload(); // 완료 → finishUpload() 콜백
        } else {
            if (dx) { $("#delFileIdStr").val(dx.getDelFileIdStr()); }
            continueUploadChain(0);
        }
    }

    /** STEP 2: 메인 업로더 완료 콜백 (기존 finishUpload 대체) */
    function finishUpload() {
        var dx = dx5.get("fileUploader");
        ajaxCall("/common/uploadFileCheck.do",
            { uploadFiles: dx.getUploadFiles(), uploadPath: dx.getUploadPath() },
            function(data) {
                if (data.result > 0) {
                    $("#uploadFiles").val(dx.getUploadFiles());
                    // 팀 업로더 순차 처리
                    continueUploadChain(0);
                } else {
                    UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
                }
            },
            function() {
                UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
            }
        );
    }

    /** STEP 3: 팀 업로더 순차 처리 */
    function continueUploadChain(teamIdx) {
        if (teamIdx >= teamUploaderIds.length) {
            appendTeamForumDetailParams(); // 업로드 결과 포함하여 수집
            doSaveForum(); // 최종 토론 정보 저장
            return;
        }

        var uid = teamUploaderIds[teamIdx];
        var dx  = dx5.get(uid);

        if (!dx) {
            teamUploadResults[uid] = { uploadFiles: '', uploadPath: '' };
            continueUploadChain(teamIdx + 1);
            return;
        }

        if (dx.availUpload()) {
            dx.startUpload();
        } else {
            teamUploadResults[uid] = { uploadFiles: '', uploadPath: dx.getUploadPath() };
            continueUploadChain(teamIdx + 1);
        }
    }

    /** STEP 4: 팀 업로더 개별 완료 콜백 */
    function onTeamUploadComplete(uid) {
        // teamIdx는 teamUploaderIds.indexOf(uid)로 역산.
        var teamIdx = teamUploaderIds.indexOf(uid);
        var dx = dx5.get(uid);
        ajaxCall("/common/uploadFileCheck.do",
            { uploadFiles: dx.getUploadFiles(), uploadPath: dx.getUploadPath() },
            function(data) {
                if (data.result > 0) {
                    teamUploadResults[uid] = {
                        uploadFiles: dx.getUploadFiles(),
                        uploadPath : dx.getUploadPath()
                    };
                    continueUploadChain(teamIdx + 1);
                } else {
                    UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
                }
            },
            function() {
                UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error"); // 업로드를 실패하였습니다.
            }
        );
    }

    // 토론등록/저장
    function saveDscs() {
        let validator = UiValidator("forumWriteForm");
        validator.then(function(result) {
            if (result) {
                syncAllSwitchHidden();
                syncDiscussionDateTimeFields();
                appendDvclasSelParams();
                appendTeamGrpInfoParams();
                // appendTeamForumDetailParams()는 모든 업로드 완료 후 체인 끝에서 호출
                startUploadChain();
            }
        });
    }

    // 실제 저장 AJAX 호출
    function doSaveForum() {
        var registUrl = '<c:url value="/forum2/forumLect/profDscsRegist.do" />';
        var modifyUrl = '<c:url value="/forum2/forumLect/profDscsModify.do" />';
        var isModifyMode = '${mode}' === 'E';
        var url = isModifyMode ? modifyUrl : registUrl;
        var param = $('#forumWriteForm').serialize();

        $.ajax({
            url 	 : url,
            async	 : false,
            type 	 : "POST",
            data 	 : param,
            beforeSend: function () {
                UiComm.showLoading(true);
            }
        }).done(function(data) {
            UiComm.showLoading(false);
            if (data.result > 0) {
                UiComm.showMessage("<spring:message code='success.common.save' />"/*정상적으로 저장되었습니다.*/, "success")
                .then(function(result) {
                    goList();
                });
            } else {
                UiComm.showMessage(data.message || "<spring:message code='fail.common.msg'/>","error"); // 에러가 발생했습니다!
            }
        }).fail(function() {
            UiComm.showLoading(false);
            UiComm.showMessage("<spring:message code='fail.common.msg'/>","error"); // 에러가 발생했습니다!
        });
    }

    // 이전 토론 가져오기
    function forumCopy() {
        /*
        $("#forumCopyForm > input[name='sbjctId']").val("${dscsVO.sbjctId}");
        $("#forumCopyForm").attr("target", "forumCopyIfm");
        $("#forumCopyForm").attr("action", "/forum/forumLect/Form/forumCopyPop.do");
        $("#forumCopyForm").submit();
        $('#forumCopyPop').modal('show');
        */
        dialog = UiDialog("dialog1", {
            title: "<spring:message code='forum.button.copy'/>", // 이전 토론 가져오기
            width: 800,
            height: 500,
            url: "/forum2/forumLect/Form/forumCopyPop.do?sbjctId=" + '${dscsVO.sbjctId}',
            autoresize: false
        });
    }

    // 이전 토론 가져오기 팝업에서 선택 시 호출 (window.parent.copyDscs)
    function copyDscs(dscsId) {
        UiComm.showLoading(true);
        $.ajax({
            url     : "/forum2/forumLect/Form/dscsCopy.do",
            async   : false,
            type    : "POST",
            dataType: "json",
            data    : { "dscsId": dscsId }
        }).done(function(resp) {
            UiComm.showLoading(false);
            if (resp.result > 0) {
                var v = resp.returnVO;
                if (!v) { UiComm.showMessage("<spring:message code='forum.alert.data.empty'/>", "error"); return; } //선택할 데이터가 없습니다.

                // 토론 제목
                $('#dscsTtl').val(v.dscsTtl || '');

                // 토론 내용 (HTML 에디터)
                editor.openHTML(v.dscsCts);

                // 참여기간: dscsSdttm/dscsEdttm = yyyyMMddHHmmss
                var sdttm = v.dscsSdttm || '';
                var edttm = v.dscsEdttm || '';
                $('#dateSt').val(sdttm.substring(0, 8));
                $('#timeSt').val(sdttm.substring(8, 12));
                $('#dateEd').val(edttm.substring(0, 8));
                $('#timeEd').val(edttm.substring(8, 12));
                $('#dscsSdttm').val(sdttm);
                $('#dscsEdttm').val(edttm);

                // 성적반영
                $("input[name='mrkRfltyn'][value='" + (v.mrkRfltyn || 'Y') + "']").prop('checked', true);

                // 성적공개
                $("input[name='mrkOyn'][value='" + (v.mrkOyn || 'Y') + "']").prop('checked', true);

                // 평가방법
                $("input[name='evlScrTycd'][value='" + (v.evlScrTycd || 'SCR') + "']").prop('checked', true);

                // TODO : 첨부파일 설정(복사하기는 추후 공통 기능에서 가이드 필요)
                /*if (v.fileList.length > 0) {
                    var fileUploader = dx5.get("fileUploader");
                    fileUploader.clearItems();

                    var oldFiles = [];

                    v.fileList.forEach(function(v, i) {
                        oldFiles.push({vindex:v.fileId, name:v.fileNm, size:v.fileSize, saveNm:v.fileSaveNm});
                    });

                    fileUploader.addOldFileList(oldFiles);
                }*/

                // 팀 영역 초기화 (selectTeam 이전 상태로 리셋)
                teamUploaderIds = [];
                teamUploadResults = {};
                $("div[id^='teamGrpView']").each(function() {
                    var dvclasNo = this.id.replace('teamGrpView', '');
                    $('#teamGrpId'  + dvclasNo).val('');
                    $('#teamGrpnm'  + dvclasNo).val('');
                    $('#subInfoDiv' + dvclasNo).empty();
                    $('#teamGrpSubForumSettingyn_' + dvclasNo).prop('checked', false);
                    $('#teamForumBlock' + dvclasNo).hide();
                    $('#teamGrpView'  + dvclasNo).hide();
                    $('#setForumDiv' + dvclasNo).hide();
                });
                initCheckedDvclas();

                // 팀 토론 여부
                $("input[name='dscsUnitTycd'][value='N']").prop('checked', true);
                teamynChange('N');


                // 참여글 보기 옵션 (checkbox + hidden)
                var oatclInqyn = v.oatclInqyn || 'N';
                $('#oatclInqyn').prop('checked', oatclInqyn === 'Y');
                $('#oatclInqynHidden').val(oatclInqyn);

                // 댓글 답변 요청
                $("input[name='cmntRspnsReqyn'][value='" + (v.cmntRspnsReqyn || 'Y') + "']").prop('checked', true);

                // 찬반 토론 설정
                var oknokStngyn = v.oknokStngyn || 'N';
                $("input[name='oknokStngyn'][value='" + oknokStngyn + "']").prop('checked', true);
                toggleProsConsOptionArea(oknokStngyn);

                // 찬반 비율 공개
                var oknokrtOyn = v.oknokrtOyn || 'N';
                setSwitcherValue('oknokrtOyn', oknokrtOyn);

                // 작성자 공개
                var oknokRgtrOyn = v.oknokRgtrOyn || 'N';
                setSwitcherValue('oknokRgtrOyn', oknokRgtrOyn);

                // 의견 글 복수 등록
                var mltOpnnRegyn = v.mltOpnnRegyn || 'N';
                setSwitcherValue('mltOpnnRegyn', mltOpnnRegyn);

                // 찬반 의견 변경가능
                var oknokModyn = v.oknokModyn || 'N';
                setSwitcherValue('oknokModyn', oknokModyn);

                closeDialog();
            } else {
                UiComm.showMessage(resp.message || "<spring:message code='forum.common.error'/>", "error"); // 오류가 발생했습니다!
            }
        }).fail(function() {
            UiComm.showLoading(false);
            UiComm.showMessage("<spring:message code='forum.common.error'/>", "error"); // 오류가 발생했습니다!
        });
    }

    // 팝업 dialog 닫기 (window.parent.closeDialog()로 호출됨)
    function closeDialog() {
        if (dialog) {
            dialog.close();
        }
    }

    </script>
</head>
<body class="class ${uiex:getTheme()}">
<div id="wrap" class="main">
    <!-- common header -->
    <jsp:include page="/WEB-INF/jsp/common_new/class_header.jsp"/>
    <!-- //common header -->

    <!-- classroom -->
    <main class="common">

        <!-- gnb -->
        <jsp:include page="/WEB-INF/jsp/common_new/class_gnb_prof.jsp"/>
        <!-- //gnb -->

        <!-- content -->
        <div id="content" class="content-wrap common">
            <!-- class_sub_top -->
            <jsp:include page="/WEB-INF/jsp/common_new/class_sub_top.jsp"/>
            <!-- //class_sub_top -->

            <div class="class_sub">
                <!-- class_info -->
                <jsp:include page="/WEB-INF/jsp/common_new/class_info.jsp"/>
                <!-- //class_info -->

                <div class="sub-content">
                    <div class="page-info">
                        <h2 class="page-title"><spring:message code='forum.label.forum' /></h2><%--토론--%>
                    </div>

                    <div class="board_top">
                        <c:choose>
                        <c:when test="${mode eq 'E'}">
                                <h4 class="sub-title"><spring:message code="forum.button.mod"/></h4><%--수정--%>
                            </c:when>
                            <c:otherwise>
                                <h4 class="sub-title"><spring:message code="forum.button.reg"/></h4><%--등록--%>
                            </c:otherwise>
                        </c:choose>
                        <div class="right-area">
                        <c:choose>
                            <c:when test="${mode eq 'E'}">
                                <button type="button" class="btn type2" id="btnSave"><spring:message code="forum.button.save"/><!-- 저장 --></a>
                            </c:when>
                            <c:otherwise>
                                <button type="button" class="btn type2" id="btnSave"><spring:message code="forum.button.save"/><!-- 저장 --></a>
                                <button type="button" class="btn type2" id="btnCopy"><spring:message code="forum.button.copy"/><!-- 이전 토론 가져오기 --></button>
                            </c:otherwise>
                        </c:choose>
                            <button type="button" class="btn type2" id="btnGoList"><spring:message code="forum.label.list"/><!-- 목록 --></button>
                        </div>
                    </div>

                    <div class="table-wrap">
                        <form id="forumWriteForm" onsubmit="return false;" autocomplete="off">
                            <div id="teamArea">
                                <c:choose>
                                    <c:when test="${mode eq 'E'}">
                                        <c:set var="path" value="/forum/${dscsVO.dscsId }" />
                                        <input type="hidden" id="dscsId" name="dscsId" value="${dscsVO.dscsId}" />
                                        <input type="hidden" id="dscsGrpId" name="dscsGrpId" value="${dscsVO.dscsGrpId}"/>
                                        <input type="hidden" id="teamGrpId" name="teamGrpId" value="${dscsVO.teamGrpId}"/>
                                        <input type="hidden" id="dvclasNo" name="dvclasNo" value="${dscsVO.dvclasNo}"/>
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="path" value="/forum" />
                                        <input type="hidden" id="dscsId" name="dscsId" value="" />
                                    </c:otherwise>
                                </c:choose>
                                <input type="hidden" name="uploadFiles"  id="uploadFiles"  value="" />
                                <input type="hidden" name="uploadPath"   id="uploadPath"   value="${dscsVO.uploadPath}" />
                                <input type="hidden" name="delFileIdStr" id="delFileIdStr" value="" />
                            </div>
                            <table class="table-type5" style="margin-top:12px;">
                                <colgroup>
                                    <col class="width-20per"/>
                                    <col/>
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th><label for="dscsTtl" class="req"><spring:message code="forum.label.forum.ttl"/></label></th><%--토론제목--%>
                                        <td>
                                            <div class="form-row">
                                                <input class="form-control width-100per" type="text" name="dscsTtl" id="dscsTtl" value='${dscsVO.dscsTtl}' placeholder="<spring:message code='lesson.label.title.input'/>" required="true"><%--제목 입력--%>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="dscsCts" class="req"><spring:message code="forum.label.forum.artl"/></label></th><%--토론내용--%>
                                        <td data-th="<spring:message code='forum.label.input'/>">
                                            <li>
                                                <dl>
                                                    <dd>
                                                        <div class="editor-box">
                                                            <%-- HTML 에디터 --%>
                                                            <textarea id="dscsCts" name="dscsCts" required="true"><c:out value="${dscsVO.dscsCts}"/></textarea>
                                                            <script>
                                                                // HTML 에디터
                                                                let editor = UiEditor({
                                                                    targetId: "dscsCts",
                                                                    uploadPath: "${dscsVO.uploadPath}",
                                                                    height: "300px"
                                                                });
                                                            </script>
                                                        </div>
                                                    </dd>
                                                </dl>
                                            </li>
                                        </td>
                                    </tr>
                                    <c:if test="${empty dscsVO.dscsId}">
                                    <tr>
                                        <th><label for="contLabel" class="req"><spring:message code="forum.label.dvclas.same.reg"/></label></th><%--분반같이 등록--%>
                                        <td>
                                            <div class="checkbox_type">
                                                <span class="custom-input">
                                                    <input type="checkbox" name="allDeclasNo" value="all" id="allDeclas" onchange="dvclasChcChange(this)">
                                                    <label for="allDeclas"><spring:message code="forum.label.all"/></label><%--전체--%>
                                                </span>
                                                <c:forEach var="list" items="${dvclasList }">
                                                    <span class="custom-input">
                                                        <input type="checkbox" ${list.sbjctId eq dscsVO.sbjctId ? 'class="readonly" checked readonly' : '' } name="sbjctIds" id="declas_${list.dvclasNo }" value="${list.sbjctId }" onchange="dvclasChcChange(this)">
                                                        <label for="declas_${list.dvclasNo }">${list.dvclasNo }<spring:message code="crs.label.dvclas.suffix"/></label><%--반--%>
                                                    </span>
                                                </c:forEach>
                                            </div>
                                        </td>
                                    </tr>
                                    </c:if>

                                    <tr>
                                        <th><label for="dscsSdttm" class="req"><spring:message code="forum.label.forum.date"/></label></th><%--참여기간--%>
                                        <!-- 저장시 : 참여기간 일정 날짜 + 시간 조합 -->
                                        <input type="hidden" id="dscsSdttm" name="dscsSdttm" placeholder="yyyyMMddHHmmss" class="width-40per" value="<c:out value='${dscsVO.dscsSdttm}'/>"/>
                                        <input type="hidden" id="dscsEdttm" name="dscsEdttm" placeholder="yyyyMMddHHmmss" class="width-40per" value="<c:out value='${dscsVO.dscsEdttm}'/>"/>

                                        <td>
                                            <div class="date_area">
                                                <input id="dateSt" type="text" name="dateSt" class="datepicker" timeId="timeSt" toDate="dateEd" value="${fn:substring(dscsVO.dscsSdttm,0,8)}" required="true">
                                                <input id="timeSt" type="text" name="timeSt" class="timepicker" dateId="dateSt" value="${fn:substring(dscsVO.dscsSdttm,8,12)}" required="true">
                                                <span class="txt-sort">~</span>
                                                <input id="dateEd" type="text" name="dateEd" class="datepicker" timeId="timeEd" fromDate="dateSt" value="${fn:substring(dscsVO.dscsEdttm,0,8)}" required="true">
                                                <input id="timeEd" type="text" name="timeEd" class="timepicker" dateId="dateEd" value="${fn:substring(dscsVO.dscsEdttm,8,12)}" required="true">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label class="req"><spring:message code="forum.label.scoreAply"/></label></th><%--성적반영--%>
                                        <td>
                                            <span class="custom-input">
                                                <input type="radio" name="mrkRfltyn" id="mrkRfltynY" value="Y" ${dscsVO.mrkRfltyn eq 'Y' || empty dscsVO.dscsId ? 'checked' : '' }>
                                                <label for="mrkRfltynY"><spring:message code="forum.common.yes"/></label><%--예--%>
                                            </span>
                                            <span class="custom-input ml5">
                                                <input type="radio" name="mrkRfltyn" id="mrkRfltynN" value="N" ${dscsVO.mrkRfltyn eq 'N' ? 'checked' : '' }>
                                                <label for="mrkRfltynN"><spring:message code="forum.common.no"/></label><%--아니오--%>
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label class="req"><spring:message code="forum.label.score.open"/></label></th><%--성적공개--%>
                                        <td>
                                            <span class="custom-input">
                                                <input type="radio" name="mrkOyn" id="mrkOynY" value="Y" ${dscsVO.mrkOyn eq 'Y' || empty dscsVO.mrkOyn ? 'checked' : '' }>
                                                <label for="mrkOynY"><spring:message code="forum.common.yes"/></label><%--예--%>
                                            </span>
                                            <span class="custom-input ml5">
                                                <input type="radio" name="mrkOyn" id="mrkOynN" value="N" ${dscsVO.mrkOyn eq 'N' ? 'checked' : '' }>
                                                <label for="mrkOynN"><spring:message code="forum.common.no"/></label><%--아니오--%>
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label class="req"><spring:message code="forum.label.evalCtgr"/></label></th><%--평가방법--%>
                                        <td>
                                            <span class="custom-input">
                                                <input type="radio" name="evlScrTycd" id="evlScrTycd1" value="SCR" ${dscsVO.evlScrTycd eq 'SCR' || empty dscsVO.evlScrTycd ? 'checked' : '' }>
                                                <label for="evlScrTycd1"><spring:message code='forum.label.evalctgr.score'/><%--점수형--%></label>
                                            </span>
                                            <span class="custom-input ml5">
                                                <input type="radio" name="evlScrTycd" id="evlScrTycd2" value="PTCP_FULL_SCR" ${dscsVO.evlScrTycd eq 'PTCP_FULL_SCR' ? 'checked' : '' }>
                                                <label for="evlScrTycd2"><spring:message code='forum.label.evalctgr.participate'/><%--참여형--%><span class="fcBlue"><spring:message code='forum.label.evalctgr.participate.desc'/></span><!-- ( 토론 참여 : 100점, 미참여 : 0점 자동배점 ) --></label>
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label for="attchFile"><spring:message code="forum.label.attachFile"/></label></th><%--파일첨부--%>
                                        <td>
                                            <uiex:dextuploader
                                                    id="fileUploader"
                                                    path="${dscsVO.uploadPath}"
                                                    limitCount="5"
                                                    limitSize="100"
                                                    oneLimitSize="100"
                                                    listSize="3"
                                                    fileList="${dscsVO.fileList}"
                                                    finishFunc="finishUpload()"
                                                    allowedTypes="*"
                                            />
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><label><spring:message code="forum.label.teamForumYn"/></label></th><%--팀 토론--%>
                                        <td>
                                            <span class="custom-input ml5">
                                                <input type="radio" name="dscsUnitTycd" id="dscsUnitTycdN" value="N" onchange="teamynChange(this.value)" ${empty dscsVO.dscsUnitTycd || dscsVO.dscsUnitTycd ne 'TEAM' ? 'checked' : ''}>
                                                <label for="dscsUnitTycdN"><spring:message code="forum.common.no"/></label><%--아니오--%>
                                            </span>
                                            <span class="custom-input">
                                                <input type="radio" name="dscsUnitTycd" id="dscsUnitTycdY" value="Y" onchange="teamynChange(this.value)" ${dscsVO.dscsUnitTycd eq 'TEAM' ? 'checked' : ''}>
                                                <label for="dscsUnitTycdY"><spring:message code="forum.common.yes"/></label><%--예--%>
                                            </span>
                                            <div id="teamForumDiv" class="team_item_wrap" ${empty dscsVO.dscsId || dscsVO.dscsUnitTycd ne 'TEAM' ? 'style="display:none"' : '' }>
                                                <c:forEach var="list" items="${dvclasList }" varStatus="i">
                                                    <div class="team_item" id="teamForumBlock${list.dvclasNo}" ${not empty dscsVO.dscsId && list.dvclasNo eq dscsVO.dvclasNo ? '' : 'style="display:none;"'}>
                                                        <div class="form-row" id='teamGrpView${list.dvclasNo}'>
                                                            <div class="item team_item_selector width-100per">
                                                                <label class="label_num">${list.dvclasNo }<spring:message code="crs.label.dvclas.suffix"/></label><%--반--%>
                                                                <input type='hidden' id='teamGrpId${list.dvclasNo}' name='teamGrpIds' value="${empty dscsVO.dscsId ? '' : (list.dvclasNo eq dscsVO.dvclasNo ? dscsVO.teamGrpId : list.teamGrpId)}:${list.sbjctId}">
                                                                <input class="form-control wide" type="text" name="name" id="teamGrpnm${list.dvclasNo}" placeholder="<spring:message code='forum.label.selected'/>" value="${empty dscsVO.dscsId ? '' : (list.dvclasNo eq dscsVO.dvclasNo ? dscsVO.dscsGrpnm : '')}" readonly="" autocomplete="off"><%--팀 분류를 선택해 주세요.--%>
                                                                <a class="btn basic" onclick="teamCtgrSelectPop('${list.dvclasNo}','${list.sbjctId }')"><spring:message code="forum.button.lrngrp.assign"/></a><%--학습그룹지정--%>
                                                            </div>
                                                        </div>
                                                        <c:if test="${i.count eq 1 }">
                                                        <div class="team_item_note">
                                                            <small class="note2"><spring:message code="forum.label.lrngrp.no.team.warning"/></small><%--! 구성된 팀이 없는 경우 메뉴 “과목설정 > 학습그룹지정”에서 팀을 생성해 주세요--%>
                                                        </div>
                                                        </c:if>
                                                        <div class="item_setting" id="setForumDiv${list.dvclasNo}" ${not empty dscsVO.dscsId && list.dvclasNo eq dscsVO.dvclasNo && not empty dscsVO.teamGrpId ? '' : 'style="display:none;"'}>
                                                            <div class="checkbox_type">
                                                                <span class="custom-input">
                                                                    <input type="checkbox" name="teamGrpSubForumSettingyns" id="teamGrpSubForumSettingyn_${list.dvclasNo}" value="Y:${list.sbjctId}" onchange="teamGrpSubForumSettingynChange(this)" ${not empty dscsVO.dscsId && list.dvclasNo eq dscsVO.dvclasNo && dscsVO.byteamDscsUseyn eq 'Y' ? 'checked' : ''}>
                                                                    <label for="teamGrpSubForumSettingyn_${list.dvclasNo}"><spring:message code="forum.label.lrngrp.dscs.setting"/></label><%--학습그룹별 토론 설정--%>
                                                                </span>
                                                            </div>
                                                            <div id="subInfoDiv${list.dvclasNo}" ${not empty dscsVO.dscsId && list.dvclasNo eq dscsVO.dvclasNo && dscsVO.byteamDscsUseyn eq 'Y' ? '' : 'style="display: none;"'}>
                                                                <c:if test="${not empty dscsVO.dscsId and list.dvclasNo eq dscsVO.dvclasNo and not empty dscsVO.teamDscsList}">
                                                                    <div class="table-wrap mb30">
                                                                        <table class="table-type5 in_table">
                                                                            <colgroup>
                                                                                <col class="width-5per" />
                                                                                <col class="width-15per" />
                                                                                <col />
                                                                            </colgroup>
                                                                            <c:forEach var="team" items="${dscsVO.teamDscsList}" varStatus="teamStatus">
                                                                                <tbody class="subForumTr team-subforum-item" data-team-id="<c:out value='${team.teamId}'/>" data-team-nm="<c:out value='${team.teamnm}'/>" data-dscs-id="<c:out value='${team.dscsId}'/>" data-team-row-index="${teamStatus.index}">
                                                                                    <tr>
                                                                                        <th rowspan="4" class="group-header"><label class="teamNm" data-role="team-name"><c:out value="${team.teamnm}"/></label></th>
                                                                                        <th><label><spring:message code="forum.label.lrngrp.mebers"/></label></th><%--학습그룹 구성원--%>
                                                                                        <td><c:out value="${empty team.leaderNm ? '-' : team.leaderNm}"/> <spring:message code="forum.label.person.and"/><%--외--%> <c:out value="${team.teamMbrCnt gt 0 ? team.teamMbrCnt - 1 : 0}"/></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <th><label for="<c:out value='${team.teamId}'/>_dtlSubjTtl_${teamStatus.index}"><spring:message code="forum.label.team.ttl"/></label></th><%--부주제--%>
                                                                                        <td><div class="form-row"><input class="form-control width-100per" type="text" id="<c:out value='${team.teamId}'/>_dtlSubjTtl_${teamStatus.index}" name="teamTtl" value="<c:out value='${team.dscsTtl}'/>" inputmask="byte" maxLen="200" data-role="team-title" /></div></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <th><label for="<c:out value='${team.teamId}'/>_contentTextArea_${teamStatus.index}"><spring:message code="common.label.contents"/></label></th><%--내용--%>
                                                                                        <td><div class="editor-box"><textarea name="<c:out value='${team.teamId}'/>_contentTextArea_${teamStatus.index}" id="<c:out value='${team.teamId}'/>_contentTextArea_${teamStatus.index}" data-role="team-contents"><c:out value="${team.dscsCts}"/></textarea></div></td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <th><label><spring:message code="forum.label.attachFile"/></label></th><%--첨부파일--%>
                                                                                        <td>
                                                                                            <c:forEach var="teamFile" items="${team.fileList}">
                                                                                                <input type="hidden" class="team-file-data" data-file-id="<c:out value='${teamFile.atflId}'/>" data-file-nm="<c:out value='${teamFile.filenm}'/>" data-file-size="<c:out value='${teamFile.fileSize}'/>"/>
                                                                                            </c:forEach>
                                                                                            <div id="teamUploaderWrap_<c:out value='${team.teamId}'/>_${teamStatus.index}"></div>
                                                                                        </td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </c:forEach>
                                                                        </table>
                                                                    </div>
                                                                </c:if>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <div class="options_wrap">
                                <ul class="accordion">
                                    <li>
                                        <div class="title-wrap">
                                            <a class="title" href="#">
                                                <span><spring:message code="forum.label.option"/></span><%--옵션--%>
                                            </a>
                                            <div class="btn_right">
                                                <i class="arrow xi-angle-down"></i>
                                            </div>
                                        </div>

                                        <div class="cont">
                                            <div class="table-wrap">
                                                <table class="table-type5" >
                                                    <colgroup>
                                                        <col class="width-20per"/>
                                                        <col/>
                                                    </colgroup>
                                                    <tbody>
                                                        <tr>
                                                            <th><label for="contLabel"><spring:message code="forum.label.otherViewYn"/></label></th><!-- 참여글 보기 옵션 -->
                                                            <td>
                                                                <span class="custom-input">
                                                                    <input type="hidden" name="oatclInqyn" id="oatclInqynHidden" value="<c:out value='${empty dscsVO.oatclInqyn ? \"N\" : dscsVO.oatclInqyn}'/>"/>
                                                                    <input type="checkbox" id="oatclInqyn" ${dscsVO.oatclInqyn eq 'Y' ? 'checked' : '' }>
                                                                    <label for="oatclInqyn"><spring:message code="forum.label.otherView.after.my.atcl"/></label><%--본인의 토론글 등록 후 다른 참여글 보기 가능--%>
                                                                </span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <!-- 댓글 답변 요청 -->
                                                            <th><label for="contLabel"><spring:message code="forum.label.aplyAsnYn"/></label></th><%--댓글 답변 요청--%>
                                                            <td>
                                                                <span class="custom-input">
                                                                    <input type="radio" name="cmntRspnsReqyn" id="cmntRspnsReqynN" value="N" ${dscsVO.cmntRspnsReqyn eq 'N' ? 'checked' : '' }>
                                                                    <label for="cmntRspnsReqynN"><spring:message code='forum.common.no' /></label><%--아니오--%>
                                                                </span>
                                                                <span class="custom-input ml5">
                                                                    <input type="radio" name="cmntRspnsReqyn" id="cmntRspnsReqynY" value="Y" ${dscsVO.cmntRspnsReqyn eq 'Y' || empty dscsVO.cmntRspnsReqyn ? 'checked' : '' }>
                                                                    <label for="cmntRspnsReqynY"><spring:message code='forum.common.yes' /></label><%--예--%>
                                                                </span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <!-- 찬반 토론으로 설정 -->
                                                            <th><label><spring:message code="forum.label.prosCons"/></label></th><%--찬반 토론으로 설정--%>
                                                            <td>
                                                                <div class="form-inline mb10">
                                                                    <span class="custom-input">
                                                                        <input type="radio" name="oknokStngyn" id="oknokStngynN" value="N" onchange="oknokStngynChange(this.value)" ${dscsVO.oknokStngyn eq 'N' || empty dscsVO.oknokStngyn ? 'checked' : '' }>
                                                                        <label for="oknokStngynN"><spring:message code='forum.common.no' /></label><%--아니오--%>
                                                                        </span>
                                                                    <span class="custom-input ml5">
                                                                        <input type="radio" name="oknokStngyn" id="oknokStngynY" value="Y" onchange="oknokStngynChange(this.value)" ${dscsVO.oknokStngyn eq 'Y'  ? 'checked' : '' }>
                                                                        <label for="oknokStngynY"><spring:message code='forum.common.yes' /></label><%--예--%>
                                                                    </span>
                                                                </div>

                                                                <!-- 찬반 옵션 -->
                                                                <div id="oknok_option_area" class="form-row option_list" ${dscsVO.oknokStngyn eq 'Y' ? '' : 'style="display:none;"'}>
                                                                    <!-- 1) 찬반 비율 공개 -->
                                                                    <div class="form-inline">
                                                                            <label for="oknokrtOyn"><spring:message code='forum.label.prosConsRate'/></label><!-- 찬반 비율 공개 -->
                                                                            <input type="hidden" name="oknokrtOyn" id="oknokrtOynHidden"
                                                                                   value="<c:out value='${empty dscsVO.oknokrtOyn ? \"N\" : dscsVO.oknokrtOyn}'/>"/>
                                                                            <input type="checkbox" class="switch small" id="oknokrtOyn"
                                                                                   <c:if test="${dscsVO.oknokrtOyn eq 'Y'}">checked</c:if> />
                                                                    </div>

                                                                    <!-- 2) 작성자 공개 -->
                                                                    <div class="form-inline">
                                                                            <label for="oknokRgtrOyn"><spring:message code="forum.label.regOpen"/></label><%--작성자 공개--%>
                                                                            <input type="hidden" name="oknokRgtrOyn" id="oknokRgtrOynHidden"
                                                                                   value="<c:out value='${empty dscsVO.oknokRgtrOyn ? \"N\" : dscsVO.oknokRgtrOyn}'/>"/>
                                                                            <input type="checkbox" class="switch small" id="oknokRgtrOyn"
                                                                                   <c:if test="${dscsVO.oknokRgtrOyn eq 'Y'}">checked</c:if> />
                                                                    </div>

                                                                    <!-- 3) 의견 글 복수 등록 -->
                                                                    <div class="form-inline">
                                                                            <label for="mltOpnnRegyn"><spring:message code="forum.label.multiAtcl"/></label><%--의견 글 복수 등록--%>
                                                                            <input type="hidden" name="mltOpnnRegyn" id="mltOpnnRegynHidden"
                                                                                   value="<c:out value='${empty dscsVO.mltOpnnRegyn ? \"N\" : dscsVO.mltOpnnRegyn}'/>"/>
                                                                            <input type="checkbox" class="switch small" id="mltOpnnRegyn"
                                                                                   <c:if test="${dscsVO.mltOpnnRegyn eq 'Y'}">checked</c:if> />
                                                                    </div>

                                                                    <!-- 4) 찬반 의견 변경가능 (기존 oknokModyn 사용) -->
                                                                    <div class="form-inline">
                                                                            <label for="oknokModyn"><spring:message code="forum.label.prosConsMod"/></label><%--찬반 의견 변경가능--%>
                                                                            <input type="hidden" name="oknokModyn" id="oknokModynHidden" value="<c:out value='${empty dscsVO.oknokModyn ? \"N\" : dscsVO.oknokModyn}'/>"/>
                                                                            <input type="checkbox" class="switch small" id="oknokModyn"
                                                                                   <c:if test="${dscsVO.oknokModyn eq 'Y'}">checked</c:if> />
                                                                    </div>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </li>
                                </ul>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>
