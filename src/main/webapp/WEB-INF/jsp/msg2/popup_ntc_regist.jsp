<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="admin"/>
        <jsp:param name="module" value="editor"/>
    </jsp:include>
    <style>
        .ui-datepicker, .ui-timepicker { z-index: 1100 !important; }
    </style>
</head>

<script type="text/javascript">
    let mode = '${mode}';
    let editor;

    $(document).ready(function() {
        /* 공지대상 - 전체 체크 연동 */
        $('#chkTrgtAll').on('change', function() {
            let checked = $(this).is(':checked');
            $('input[name=trgtCd]').prop('checked', false).prop('disabled', checked);
        });
        $('input[name=trgtCd]').on('change', function() {
            let anyChecked = $('input[name=trgtCd]:checked').length > 0;
            if (anyChecked) {
                $('#chkTrgtAll').prop('checked', false);
            }
        });

        <c:if test="${mode == 'modify' and not empty detailVO}">
        fn_setFormData();
        </c:if>
    });

    /* 수정 모드 데이터 세팅 */
    function fn_setFormData() {
        let trgtStr = '${detailVO.popupNtcTrgt}';
        if (trgtStr === 'ALL') {
            $('#chkTrgtAll').prop('checked', true).trigger('change');
        } else if (trgtStr) {
            let codes = trgtStr.split(',');
            codes.forEach(function(code) {
                $('input[name=trgtCd][value=' + code.trim() + ']').prop('checked', true);
            });
        }

        <c:if test="${not empty detailVO.popupNtcCts}">
        setTimeout(function() {
            if (editor) {
                editor.openHTML($('#hiddenCts').val());
            }
        }, 500);
        </c:if>
    }

    /* 필수값 검증 */
    function fn_validate() {
        if (!$('#popupNtcTtl').val().trim()) {
            alert('<spring:message code="msg.popupNtc.msg.ttlRequired"/>');
            $('#popupNtcTtl').focus();
            return false;
        }
        if (!$('#popupWinWdthsz').val() || !$('#popupWinHght').val()) {
            alert('<spring:message code="msg.popupNtc.msg.sizeRequired"/>');
            return false;
        }
        if (!$('#popupWinXcrd').val() || !$('#popupWinYcrd').val()) {
            alert('<spring:message code="msg.popupNtc.msg.pstnRequired"/>');
            return false;
        }
        if (!$('input[name=popupPnttimeGbncd]:checked').val()) {
            alert('<spring:message code="msg.popupNtc.msg.pnttimeRequired"/>');
            return false;
        }
        if (!$('#chkTrgtAll').is(':checked') && $('input[name=trgtCd]:checked').length === 0) {
            alert('<spring:message code="msg.popupNtc.msg.trgtRequired"/>');
            return false;
        }
        if (!$('#popupNtcSdttm').val() || !$('#popupNtcEdttm').val()) {
            alert('<spring:message code="msg.popupNtc.msg.periodRequired"/>');
            return false;
        }

        return true;
    }

    /* 공지대상 값 조합 */
    function fn_getTrgtValue() {
        if ($('#chkTrgtAll').is(':checked')) {
            return 'ALL';
        }
        let values = [];
        $('input[name=trgtCd]:checked').each(function() {
            values.push($(this).val());
        });
        return values.join(',');
    }

    /* 사용기간 값 조합 */
    function fn_getPeriodValue(dateId, timeId) {
        let dateVal = UiComm.getDateTimeVal(dateId, null);
        let timeVal = UiComm.getDateTimeVal(null, timeId);
        return dateVal + timeVal + '00';
    }

    /* 저장 */
    function fn_save() {
        if (!fn_validate()) return;

        let param = {
            popupNtcTtl: $('#popupNtcTtl').val(),
            popupWinWdthsz: $('#popupWinWdthsz').val(),
            popupWinHght: $('#popupWinHght').val(),
            popupWinXcrd: $('#popupWinXcrd').val(),
            popupWinYcrd: $('#popupWinYcrd').val(),
            popupPnttimeGbncd: $('input[name=popupPnttimeGbncd]:checked').val(),
            popupNtcTrgt: fn_getTrgtValue(),
            popupNtcSdttm: fn_getPeriodValue('popupNtcSdttm', 'sdttmTime'),
            popupNtcEdttm: fn_getPeriodValue('popupNtcEdttm', 'edttmTime'),
            popupNtcTdstopUseyn: $('input[name=popupNtcTdstopUseyn]:checked').val(),
            popupNtcCts: $('#popupNtcCts').val()
        };

        let url = '/popupNtcRegistAjax.do';
        let successMsg = '<spring:message code="msg.popupNtc.msg.saveSuccess"/>';

        if (mode === 'modify') {
            param.popupNtcId = '${detailVO.popupNtcId}';
            url = '/popupNtcModifyAjax.do';
            successMsg = '<spring:message code="msg.popupNtc.msg.modifySuccess"/>';
        }

        ajaxCall(url, param, function(res) {
            if (res.result > 0) {
                alert(successMsg);
                location.href = '/popupNtcList.do';
            } else {
                alert(res.message || '<spring:message code="fail.common.insert"/>');
            }
        }, function() {
            alert('<spring:message code="fail.common.insert"/>');
        }, true);
    }

    /* 목록으로 */
    function fn_goList() {
        location.href = '/popupNtcList.do';
    }
</script>

<body class="admin">
    <div id="wrap" class="main">
        <!-- common header -->
        <jsp:include page="/WEB-INF/jsp/common_new/admin_header.jsp"/>

        <!-- admin -->
        <main class="common">

            <!-- gnb -->
            <jsp:include page="/WEB-INF/jsp/common_new/admin_aside.jsp"/>

            <!-- content -->
            <div id="content" class="content-wrap common">
                <div class="admin_sub">

                    <div class="sub-content">
                        <!-- page info -->
                        <div class="page-info">
                            <h2 class="page-title"><spring:message code="msg.popupNtc.label.title"/></h2>
                        </div>

                        <div class="box">
                            <div class="board_top">
                                <h3 class="board-title">
                                    <c:choose>
                                        <c:when test="${mode == 'modify'}"><spring:message code="msg.popupNtc.label.modify"/></c:when>
                                        <c:otherwise><spring:message code="msg.popupNtc.label.regist"/></c:otherwise>
                                    </c:choose>
                                </h3>
                            </div>

                            <!-- form table -->
                            <form id="frmPopupNtc">
                            <div class="table-wrap">
                                <table class="table-type5">
                                    <colgroup>
                                        <col class="width-15per">
                                        <col>
                                    </colgroup>
                                    <tbody>
                                        <!-- 제목 -->
                                        <tr>
                                            <th><label for="popupNtcTtl" class="req"><spring:message code="msg.popupNtc.label.ttl"/></label></th>
                                            <td>
                                                <div class="form-row">
                                                    <input type="text" id="popupNtcTtl" name="popupNtcTtl" class="form-control width-100per" placeholder="<spring:message code="msg.popupNtc.label.ttl"/>" inputmask="length" maxLen="200" value="<c:out value='${detailVO.popupNtcTtl}'/>">
                                                </div>
                                            </td>
                                        </tr>
                                        <!-- 크기 -->
                                        <tr>
                                            <th><label class="req"><spring:message code="msg.popupNtc.label.size"/></label></th>
                                            <td>
                                                <div class="form-inline">
                                                    <spring:message code="msg.popupNtc.label.wdth"/>
                                                    <input type="text" id="popupWinWdthsz" name="popupWinWdthsz" class="form-control" style="width:100px" inputmask="numeric" maxVal="9999" value="${not empty detailVO ? detailVO.popupWinWdthsz : '300'}">
                                                    &nbsp;/&nbsp;
                                                    <spring:message code="msg.popupNtc.label.hght"/>
                                                    <input type="text" id="popupWinHght" name="popupWinHght" class="form-control" style="width:100px" inputmask="numeric" maxVal="9999" value="${not empty detailVO ? detailVO.popupWinHght : '500'}">
                                                </div>
                                            </td>
                                        </tr>
                                        <!-- 위치 -->
                                        <tr>
                                            <th><label class="req"><spring:message code="msg.popupNtc.label.pstn"/></label></th>
                                            <td>
                                                <div class="form-inline">
                                                    <spring:message code="msg.popupNtc.label.xcrd"/>
                                                    <input type="text" id="popupWinXcrd" name="popupWinXcrd" class="form-control" style="width:100px" inputmask="numeric" maxVal="9999" value="${not empty detailVO ? detailVO.popupWinXcrd : '100'}">
                                                    &nbsp;/&nbsp;
                                                    <spring:message code="msg.popupNtc.label.ycrd"/>
                                                    <input type="text" id="popupWinYcrd" name="popupWinYcrd" class="form-control" style="width:100px" inputmask="numeric" maxVal="9999" value="${not empty detailVO ? detailVO.popupWinYcrd : '100'}">
                                                </div>
                                            </td>
                                        </tr>
                                        <!-- 팝업시점 -->
                                        <tr>
                                            <th><label class="req"><spring:message code="msg.popupNtc.label.pnttime"/></label></th>
                                            <td>
                                                <div class="form-row">
                                                    <span class="custom-input">
                                                        <input type="radio" id="pnttimeBflgn" name="popupPnttimeGbncd" value="BFLGN" <c:if test="${empty detailVO or detailVO.popupPnttimeGbncd == 'BFLGN'}">checked</c:if>>
                                                        <label for="pnttimeBflgn"><spring:message code="msg.popupNtc.label.bflgn"/></label>
                                                    </span>
                                                    <span class="custom-input">
                                                        <input type="radio" id="pnttimeAflgn" name="popupPnttimeGbncd" value="AFLGN" <c:if test="${detailVO.popupPnttimeGbncd == 'AFLGN'}">checked</c:if>>
                                                        <label for="pnttimeAflgn"><spring:message code="msg.popupNtc.label.aflgn"/></label>
                                                    </span>
                                                </div>
                                            </td>
                                        </tr>
                                        <!-- 공지대상 -->
                                        <tr>
                                            <th><label class="req"><spring:message code="msg.popupNtc.label.trgt"/></label></th>
                                            <td>
                                                <div class="form-row">
                                                    <div class="checkbox_type">
                                                        <span class="custom-input">
                                                            <input type="checkbox" id="chkTrgtAll" value="ALL">
                                                            <label for="chkTrgtAll"><spring:message code="msg.popupNtc.label.trgtAll"/></label>
                                                        </span>
                                                        <span class="custom-input">
                                                            <input type="checkbox" name="trgtCd" id="chkTrgtProf" value="PROF">
                                                            <label for="chkTrgtProf"><spring:message code="msg.popupNtc.label.trgtProf"/></label>
                                                        </span>
                                                        <span class="custom-input">
                                                            <input type="checkbox" name="trgtCd" id="chkTrgtTutor" value="TUTOR">
                                                            <label for="chkTrgtTutor"><spring:message code="msg.popupNtc.label.trgtTutor"/></label>
                                                        </span>
                                                        <span class="custom-input">
                                                            <input type="checkbox" name="trgtCd" id="chkTrgtStdnt" value="STDNT">
                                                            <label for="chkTrgtStdnt"><spring:message code="msg.popupNtc.label.trgtStdnt"/></label>
                                                        </span>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <!-- 사용기간 -->
                                        <tr>
                                            <th><label class="req"><spring:message code="msg.popupNtc.label.period"/></label></th>
                                            <td>
                                                <div class="form-row">
                                                    <div class="date_area">
                                                        <input type="text" id="popupNtcSdttm" name="popupNtcSdttm" placeholder="시작일" class="datepicker" toDate="popupNtcEdttm" timeId="sdttmTime">
                                                        <input type="text" id="sdttmTime" name="sdttmTime" placeholder="시작시간" class="timepicker" dateId="popupNtcSdttm">
                                                        <span class="txt-sort">~</span>
                                                        <input type="text" id="popupNtcEdttm" name="popupNtcEdttm" placeholder="종료일" class="datepicker" fromDate="popupNtcSdttm" timeId="edttmTime">
                                                        <input type="text" id="edttmTime" name="edttmTime" placeholder="종료시간" class="timepicker" dateId="popupNtcEdttm">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <!-- 하루 동안 열지 않음 -->
                                        <tr>
                                            <th><label><spring:message code="msg.popupNtc.label.tdstop"/></label></th>
                                            <td>
                                                <div class="form-row">
                                                    <span class="custom-input">
                                                        <input type="radio" id="tdstopY" name="popupNtcTdstopUseyn" value="Y" <c:if test="${empty detailVO or detailVO.popupNtcTdstopUseyn == 'Y'}">checked</c:if>>
                                                        <label for="tdstopY"><spring:message code="msg.popupNtc.label.tdstopUse"/></label>
                                                    </span>
                                                    <span class="custom-input">
                                                        <input type="radio" id="tdstopN" name="popupNtcTdstopUseyn" value="N" <c:if test="${detailVO.popupNtcTdstopUseyn == 'N'}">checked</c:if>>
                                                        <label for="tdstopN"><spring:message code="msg.popupNtc.label.tdstopNotUse"/></label>
                                                    </span>
                                                </div>
                                            </td>
                                        </tr>
                                        <!-- 공지 내용 -->
                                        <tr>
                                            <th><label for="popupNtcCts" class="req"><spring:message code="msg.popupNtc.label.cts"/></label></th>
                                            <td>
                                                <div class="editor-box">
                                                    <textarea id="popupNtcCts" name="popupNtcCts"></textarea>
                                                    <script>
                                                        editor = UiEditor({
                                                            targetId: "popupNtcCts",
                                                            uploadPath: "/popupNtc",
                                                            height: "400px"
                                                        });
                                                    </script>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            </form>
                        </div>

                        <!-- hidden field for editor content -->
                        <c:if test="${mode == 'modify' and not empty detailVO}">
                        <textarea id="hiddenCts" style="display:none;"><c:out value="${detailVO.popupNtcCts}" escapeXml="false"/></textarea>
                        </c:if>

                        <div class="btns">
                            <button type="button" class="btn type1" onclick="fn_save();"><spring:message code="msg.popupNtc.label.save"/></button>
                            <button type="button" class="btn type2" onclick="fn_goList();"><spring:message code="msg.popupNtc.label.list"/></button>
                        </div>

                        <c:if test="${mode == 'modify' and not empty detailVO}">
                        <!-- 수정 모드: 사용기간 초기값 세팅 -->
                        <script>
                            $(document).ready(function() {
                                let sdttm = '${detailVO.popupNtcSdttm}';
                                let edttm = '${detailVO.popupNtcEdttm}';

                                if (sdttm && sdttm.length >= 12) {
                                    $('#popupNtcSdttm').val(sdttm.substring(0, 4) + sdttm.substring(4, 6) + sdttm.substring(6, 8));
                                    $('#sdttmTime').val(sdttm.substring(8, 10) + sdttm.substring(10, 12));
                                }
                                if (edttm && edttm.length >= 12) {
                                    $('#popupNtcEdttm').val(edttm.substring(0, 4) + edttm.substring(4, 6) + edttm.substring(6, 8));
                                    $('#edttmTime').val(edttm.substring(8, 10) + edttm.substring(10, 12));
                                }
                            });
                        </script>
                        </c:if>

                    </div>
                </div>
            </div>
            <!-- //content -->

        </main>
        <!-- //admin -->
    </div>
</body>
</html>
