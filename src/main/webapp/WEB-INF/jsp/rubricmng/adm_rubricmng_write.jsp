<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
		<jsp:param name="style" value="admin"/>
		<jsp:param name="module" value="table"/>
	</jsp:include>

	<script type="text/javascript">
        var CTX = '<%=request.getContextPath()%>';
        var MENU_ID = '<c:out value="${vo.menuId}" />';
        var _qstnSeq = 0;
        var dialog;

        var rubricId = '${vo.rubricId}';
        var isModify = '${isModify}';

        /* 수정 화면 문항/보기 정보 */
        var rubricInfoList = [
            <c:forEach var="info" items="${rubricInfoVO}" varStatus="st">
            {
                rubricQstnId:     "<c:out value='${info.rubricQstnId}'/>",
                rubricQstnTtl:    "<c:out value='${info.rubricQstnTtl}'/>",
                evlrt:            "<c:out value='${info.evlrt}'/>",
                rubricEvlTycd:    "<c:out value='${info.rubricEvlTycd}'/>",
                rubricVwitmId:    "<c:out value='${info.rubricVwitmId}'/>",
                rubricVwitmTtl:   "<c:out value='${info.rubricVwitmTtl}'/>",
                rubricVwitmPnt:   "<c:out value='${info.rubricVwitmPnt}'/>",
                rubricVwitmSeqno: ${empty info.rubricVwitmSeqno ? 0 : info.rubricVwitmSeqno}
            }<c:if test="${!st.last}">,</c:if>
            </c:forEach>
        ];

        /* 루브릭 가져오기 팝업 */
        function rubricImportPop() {
            var currentOrgId = $("#orgId").val();
            if (!currentOrgId) {
                UiComm.showMessage("<spring:message code='common.message.select.org' /><%--기관을 선택하세요.--%>", "warning");
                return;
            }
            var addParams = UiComm.makeEncParams({ orgId: currentOrgId });
            dialog = UiDialog("dialog1", {
                title: "<spring:message code='crs.import.rubric' /><%--루브릭 가져오기--%>",
                width: 600,
                height: 500,
                url: CTX + "/rubricmng/admRubricMngImportPopup.do?addParams=" + encodeURIComponent(addParams),
                autoresize: false
            });
        }

        /* 팝업 닫기 */
        function closeDialog() {
            if (dialog) { dialog.close(); }
        }

        /* 가져온 루브릭으로 문항/등급 재구성 */
        function loadRubricImport(list) {
            document.getElementById('qstnArea').innerHTML = '';
            document.getElementById('gradeArea').innerHTML = '';
            _qstnSeq = 0;
            loadRubricInfoForModify(list);
        }

        /* 목록으로 이동 */
        function rubricListViewMv () {
            UiComm.showMessage("<spring:message code='crs.move.list.view' /><%--목록으로 돌아가시겠습니까?--%>", "confirm")
                .then(function(result) {
                    if (result) {
                        var encParams = $("#encParams").val();
                        location.href = appendMenuId(CTX + "/rubricmng/admRubricMngList.do" + (encParams ? "?encParams=" + encodeURIComponent(encParams) : ""));
                    }
                });
        }

        function appendMenuId(url) {
            if (!MENU_ID) {
                return url;
            }
            return url + (url.indexOf("?") > -1 ? "&" : "?") + "menuId=" + encodeURIComponent(MENU_ID);
        }

        /* 필수 입력값 검증 */
        function isNull() {
            var isResult = true;
            var alertMsg = '';

            Array.from(document.querySelectorAll('#qstnArea .item[data-qstn-num]')).every(function(item) {
                var n     = parseInt(item.dataset.qstnNum, 10);
                var seqno = parseInt(item.querySelector('.label_num').textContent, 10);

                var ttlInput   = document.getElementById('rubricQstnTtl' + n);
                var evlrtInput = document.getElementById('evlrt' + n);

                if (!ttlInput || ttlInput.value.trim() === '') {
                    isResult = false;
                    alertMsg = seqno + "<spring:message code='crs.input.qstn.title' /><%--번 문항의 제목을 입력하세요.--%>";
                    return false;
                }
                if (!evlrtInput || evlrtInput.value.trim() === '') {
                    isResult = false;
                    alertMsg = seqno + "<spring:message code='crs.input.qstn.score' /><%--번 문항의 배점을 입력하세요.--%>";
                    return false;
                }

                var subBox    = document.querySelector('.sub-box.rub_grade[data-prnt="' + item.id + '"]');
                var checkedRd = subBox ? subBox.querySelector('input[type="radio"]:checked') : null;

                if (subBox && checkedRd) {
                    var evlKey       = checkedRd.value.toLowerCase().replace('_', '-');
                    var activeEvlDiv = subBox.querySelector('[data-evl="' + evlKey + '"]');
                    if (activeEvlDiv) {
                        Array.from(activeEvlDiv.querySelectorAll('.item')).every(function(row, rowIdx) {
                            var inputs = row.querySelectorAll('input[type="text"]');
                            if (!inputs[0] || inputs[0].value.trim() === '') {
                                isResult = false;
                                alertMsg = seqno + "<spring:message code='crs.no.qstn' /><%--번 문항--%> " + (rowIdx + 1) + "<spring:message code='crs.input.vwitm.score' /><%--번 보기의 점수를 입력하세요.--%>";
                                return false;
                            }
                            if (!inputs[1] || inputs[1].value.trim() === '') {
                                isResult = false;
                                alertMsg = seqno + "<spring:message code='crs.no.qstn' /><%--번 문항--%> " + (rowIdx + 1) + "<spring:message code='crs.input.vwitm.content' /><%--번 보기의 내용을 입력하세요.--%>";
                                return false;
                            }
                            return true;
                        });
                    }
                }
                return isResult;
            });

            if (!isResult) {
                UiComm.showMessage(alertMsg, 'warning');
                return false;
            }
            return true;
        }

        /* 저장 */
        function rubricSave() {
            var rubricTtl = document.getElementById('rubricTtl').value.trim();
            if (!rubricTtl) {
                UiComm.showMessage("<spring:message code='crs.input.rubric.title' /><%--루브릭 제목을 입력하세요.--%>", 'warning');
                return;
            }

            var items = document.querySelectorAll('#qstnArea .item[data-qstn-num]');

            // 문항 배점 합계는 100이어야 한다.
            var totalEvlrt = 0;
            items.forEach(function(item) {
                var n = parseInt(item.dataset.qstnNum, 10);
                var evlrtInput = document.getElementById('evlrt' + n);
                totalEvlrt += evlrtInput ? (parseFloat(evlrtInput.value) || 0) : 0;
            });
            totalEvlrt = Math.round(totalEvlrt * 10) / 10;
            if (totalEvlrt !== 100) {
                UiComm.showMessage("<spring:message code='crs.evl.msg1' /><%--배점의 합은 100% 여야 합니다.--%>\n(<spring:message code='crs.current' /><%--현재--%> " + totalEvlrt + '%).', 'warning');
                return;
            }

            if (!isNull()) return;

            var currentOrgId = $("#orgId").val();
            if (!currentOrgId) {
                UiComm.showMessage("<spring:message code='common.message.select.org' /><%--기관을 선택하세요.--%>", "warning");
                return;
            }

            var params = {
                rubricId:      rubricId,
                orgId:         currentOrgId,
                rubricTtl:     rubricTtl,
                rubricQstnCnt: items.length
            };

            items.forEach(function(item, qi) {
                var n         = parseInt(item.dataset.qstnNum, 10);
                var subBox    = document.querySelector('.sub-box.rub_grade[data-prnt="' + item.id + '"]');
                var checkedRd = subBox ? subBox.querySelector('input[type="radio"]:checked') : null;
                var rubricEvlTycd = checkedRd ? checkedRd.value : '';

                params['rubricQstns[' + qi + '].rubricQstnTtl']   = (document.getElementById('rubricQstnTtl' + n) || {}).value || '';
                params['rubricQstns[' + qi + '].rubricQstnSeqno'] = qi + 1;
                params['rubricQstns[' + qi + '].evlrt']            = (document.getElementById('evlrt' + n) || {}).value || '';
                params['rubricQstns[' + qi + '].rubricEvlTycd']    = rubricEvlTycd;

                if (subBox && rubricEvlTycd) {
                    var evlKey       = rubricEvlTycd.toLowerCase().replace('_', '-');
                    var activeEvlDiv = subBox.querySelector('[data-evl="' + evlKey + '"]');
                    if (activeEvlDiv) {
                        var pntList = [], ttlList = [];
                        activeEvlDiv.querySelectorAll('.item').forEach(function(row) {
                            var inputs = row.querySelectorAll('input[type="text"]');
                            pntList.push(inputs[0] ? inputs[0].value : '');
                            ttlList.push(inputs[1] ? inputs[1].value : '');
                        });
                        params['rubricQstns[' + qi + '].rubricVwitmPntList'] = pntList.join(',');
                        params['rubricQstns[' + qi + '].rubricVwitmTtlList'] = ttlList.join(',');
                    }
                }
            });

            ajaxCall(
                isModify === 'Y' ? CTX + '/rubricmng/admRubricMngModify.do' : CTX + '/rubricmng/admRubricMngRegist.do',
                params,
                function(result) {
                    if (result.result > 0) {
                        UiComm.showMessage(result.message, 'success').then(function() {
                            var encParams = $("#encParams").val();
                            location.href = appendMenuId(CTX + '/rubricmng/admRubricMngList.do' + (encParams ? '?encParams=' + encodeURIComponent(encParams) : ''));
                        });
                    } else {
                        UiComm.showMessage(result.message, 'warning');
                    }
                },
                function() {
                    UiComm.showMessage(
                        isModify === 'Y'
                            ? "<spring:message code='crs.error.modify.msg' /><%--수정 중 에러가 발생하였습니다.--%>"
                            : "<spring:message code='crs.error.regist.msg' /><%--저장 중 에러가 발생하였습니다.--%>"
                        , 'error');
                },
                true
            );
        }

        /* 문항 추가 */
        function addRubricQstn(skipRecalc) {
            _qstnSeq++;
            var ns     = String(_qstnSeq).padStart(2, '0');
            var qstnId = 'qstn' + ns;
            document.getElementById('qstnArea')
                .insertAdjacentHTML('beforeend', _itemHtml(qstnId, _qstnSeq));
            document.getElementById('gradeArea')
                .insertAdjacentHTML('beforeend', _subBoxHtml(qstnId, ns));
            showSubBox(qstnId);
            _reindexLabels();
            if (!skipRecalc) _recalcEvlrt();
        }

        /* 선택한 문항의 등급 설정 영역만 노출 */
        function showSubBox(qstnId) {
            document.querySelectorAll('#qstnArea .item').forEach(function(el) {
                el.classList.remove('active');
            });
            var targetItem = document.getElementById(qstnId);
            if (targetItem) targetItem.classList.add('active');

            document.querySelectorAll('.sub-box.rub_grade').forEach(function(el) {
                el.style.display = 'none';
            });
            var subBox = document.querySelector('.sub-box.rub_grade[data-prnt="' + qstnId + '"]');
            if (!subBox) return;
            subBox.style.display = '';
            var checkedRd = subBox.querySelector('input[type="radio"]:checked');
            if (checkedRd) _showGradeItem(subBox, checkedRd.value);
        }

        /* 선택한 평가척도만 노출하고 자유척도 추가 버튼 표시 제어 */
        function _showGradeItem(subBox, radioValue) {
            var evlKey = radioValue.toLowerCase().replace('_', '-');
            subBox.querySelectorAll('.grade_item [data-evl]').forEach(function(el) {
                el.style.display = (el.dataset.evl === evlKey) ? '' : 'none';
            });
            var addGradeBtn = subBox.querySelector('.board_top .right-area');
            if (addGradeBtn) addGradeBtn.style.display = (evlKey === 'free-pnt') ? '' : 'none';
        }

        /* 문항 번호 재정렬 */
        function _reindexLabels() {
            document.querySelectorAll('#qstnArea .item').forEach(function(el, idx) {
                var lbl = el.querySelector('.label_num');
                if (lbl) lbl.textContent = idx + 1;
            });
        }

        /* 문항 수에 맞춰 배점을 기본 1/n로 자동 분배 */
        function _recalcEvlrt() {
            var items = Array.from(document.querySelectorAll('#qstnArea .item[data-qstn-num]'));
            var n = items.length;
            if (n === 0) return;
            var base      = Math.floor(100 / n);
            var remainder = 100 - base * n;
            items.forEach(function(item, idx) {
                var input = document.getElementById('evlrt' + parseInt(item.dataset.qstnNum, 10));
                if (input) input.value = (idx === n - 1) ? base + remainder : base;
            });
        }

        /* 문항 영역 HTML */
        function _itemHtml(qstnId, n) {
            return '<tr class="item" id="' + qstnId + '" data-qstn-num="' + n + '">'
                + '<td class="seq-cell w50 t_center"><label class="label_num"></label></td>'
                + '<td class="title-cell"><input class="form-control width-100per" type="text" id="rubricQstnTtl' + n + '" value="" placeholder="<spring:message code='crs.rubric.mng.placeholder.qstn.title' /><%--문항명--%>"></td>'
                + '<td class="score-cell w120"><div class="score-box"><input class="form-control w80" type="text" inputmask="numeric" maxVal="1000" id="evlrt' + n + '" value="" placeholder="0"><span>%</span></div></td>'
                + '<td class="remove-cell t_center"><button type="button" class="btn basic icon" data-close-set="' + qstnId + '"><i class="xi-close"></i></button></td>'
                + '</tr>';
        }

        /* 문항별 평가등급 설정 영역 HTML */
        function _subBoxHtml(qstnId, ns) {
            var rdName = 'rubric-evl-tycd-rd-' + ns;
            function _rd(id, val, lbl, chk) {
                return '<span class="custom-input ml5">'
                    + '<input type="radio" name="' + rdName + '" id="' + id + '" value="' + val + '"' + (chk ? ' checked' : '') + '>'
                    + '<label for="' + id + '">' + lbl + '</label></span>';
            }
            return '<div class="sub-box rub_grade" data-prnt="' + qstnId + '" data-vwitm="vwitm' + ns + '">'
                +   '<div class="board_top grade-top mb10"><div class="grade-top-left"><h3 class="board-title"><spring:message code='common.label.eval.grade' /><%--평가 등급--%></h3>'
                +     '<div class="form-inline">'
                +       _rd('five-pnt-'  + ns, 'FIVE_PNT',  '<spring:message code='crs.5pnt' /><%--5점 척도--%>',  true)
                +       _rd('three-pnt-' + ns, 'THREE_PNT', '<spring:message code='crs.3pnt' /><%--3점 척도--%>',  false)
                +       _rd('free-pnt-'  + ns, 'FREE_PNT',  '<spring:message code='crs.free.pnt' /><%--자유척도--%>',  false)
                +       _rd('ox-evl-'    + ns, 'OX_EVL',    '<spring:message code='crs.ox.pnt' /><%--O/X평가--%>',   false)
                +     '</div></div>'
                +     '<div class="right-area" style="display:none"><button type="button" class="btn type2" onclick="addFreePntVwitm()"><spring:message code="crs.rubric.mng.button.add.grade" /><%--등급 추가--%></button></div>'
                +   '</div>'
                +   '<div class="grade_item" data-rd-set="' + qstnId + '">'
                +     _gradeBlockHtml('five-pnt',  [['5','<spring:message code="crs.vwitm.ex1" /><%--매우 잘 했어요--%>']
                                                    ,['4','<spring:message code="crs.vwitm.ex2" /><%--잘 했어요--%>']
                                                    ,['3','<spring:message code="crs.vwitm.ex3" /><%--보통이에요--%>']
                                                    ,['2','<spring:message code="crs.vwitm.ex4" /><%--노력하세요--%>']
                                                    ,['1','<spring:message code="crs.vwitm.ex5" /><%--더 노력하세요--%>']]
                                                    , false)
                +     _gradeBlockHtml('three-pnt', [['3','<spring:message code="crs.vwitm.ex2" /><%--잘 했어요--%>']
                                                    ,['2','<spring:message code="crs.vwitm.ex3" /><%--보통이에요--%>']
                                                    ,['1','<spring:message code="crs.vwitm.ex4" /><%--노력하세요--%>']]
                                                    , true)
                +     _gradeBlockHtml('free-pnt',  [['3','<spring:message code="crs.vwitm.ex2" /><%--잘 했어요--%>']
                                                    ,['2','<spring:message code="crs.vwitm.ex3" /><%--보통이에요--%>']
                                                    ,['1','<spring:message code="crs.vwitm.ex4" /><%--노력하세요--%>']]
                                                    , true)
                +     _gradeBlockHtml('ox-evl',    [['2','O',true],['1','X',true]], true)
                +   '</div>'
                + '</div>';
        }

        /* 자유척도 등급 추가(최대 10개) */
        function addFreePntVwitm() {
            var activeItem = document.querySelector('#qstnArea .item.active');
            if (!activeItem) return;
            var subBox = document.querySelector('.sub-box.rub_grade[data-prnt="' + activeItem.id + '"]');
            if (!subBox) return;
            var freePntDiv = subBox.querySelector('[data-evl="free-pnt"]');
            if (!freePntDiv) return;
            if (freePntDiv.querySelectorAll('.item').length >= 10) {
                UiComm.showMessage("<spring:message code='crs.free.pnt.add.msg' /><%--자유척도 등급은 최대 10개까지 추가 가능합니다.--%>", "info");
                return;
            }
            freePntDiv.insertAdjacentHTML('beforeend',
                '<div class="item">'
                + '<div class="input_btn"><input class="form-control w80" type="text" value="" autocomplete="off"><label><spring:message code="crs.rubric.mng.label.score" /><%--점수--%></label></div>'
                + '<input class="form-control wide flex-1" type="text" value="">'
                + '<button type="button" class="btn basic icon" data-del-grade><i class="xi-close"></i></button>'
                + '</div>');
        }

        /* 척도별 등급 행 HTML */
        function _gradeBlockHtml(evlKey, rows, hidden) {
            var html = '<div data-evl="' + evlKey + '"' + (hidden ? ' style="display:none"' : '') + '>';
            rows.forEach(function(r) {
                var delBtn = (evlKey === 'free-pnt') ? '<button type="button" class="btn basic icon" data-del-grade><i class="xi-close"></i></button>' : '';
                html += '<div class="item">'
                    + '<div class="input_btn"><input class="form-control w80" type="text" value="' + r[0] + '" autocomplete="off"><label><spring:message code="crs.rubric.mng.label.score" /><%--점수--%></label></div>'
                    + '<input class="form-control wide flex-1' + (r[2] ? ' disabled' : '') + '" type="text" value="' + r[1] + '"' + (r[2] ? ' readonly' : '') + '>'
                    + delBtn
                    + '</div>';
            });
            return html + '</div>';
        }

        /* 클릭 이벤트 위임 */
        document.addEventListener('click', function(e) {
            /* 자유척도 등급 삭제 */
            var delGradeBtn = e.target.closest('[data-del-grade]');
            if (delGradeBtn) {
                e.stopPropagation();
                delGradeBtn.closest('.item').remove();
                return;
            }
            /* 문항 삭제 */
            var closeBtn = e.target.closest('[data-close-set]');
            if (closeBtn) {
                e.stopPropagation();
                var qstnId = closeBtn.dataset.closeSet;
                var item   = document.getElementById(qstnId);
                var subBox = document.querySelector('.sub-box.rub_grade[data-prnt="' + qstnId + '"]');
                var wasActive = item && item.classList.contains('active');
                if (item)   item.remove();
                if (subBox) subBox.remove();
                _reindexLabels();
                _recalcEvlrt();
                if (wasActive) {
                    var firstItem = document.querySelector('#qstnArea .item');
                    if (firstItem) showSubBox(firstItem.id);
                }
                return;
            }
            /* 문항 선택 */
            var qstnItem = e.target.closest('#qstnArea .item[data-qstn-num]');
            if (qstnItem) showSubBox(qstnItem.id);
        });

        /* 평가척도 변경 */
        document.addEventListener('change', function(e) {
            if (e.target.type !== 'radio') return;
            var subBox = e.target.closest('.sub-box.rub_grade');
            if (subBox) _showGradeItem(subBox, e.target.value);
        });

        /* 수정 화면 초기 데이터 바인딩 */
        function loadRubricInfoForModify(list) {
            if (!list || list.length === 0) return;

            // 조회 결과를 문항 ID 기준으로 묶어서 재구성한다.
            var qstnMap   = {};
            var qstnOrder = [];
            list.forEach(function(row) {
                var qid = row.rubricQstnId;
                if (!qstnMap[qid]) {
                    qstnMap[qid] = { ttl: row.rubricQstnTtl, evlrt: row.evlrt, evlTycd: row.rubricEvlTycd, vwitms: [] };
                    qstnOrder.push(qid);
                }
                qstnMap[qid].vwitms.push({ ttl: row.rubricVwitmTtl, pnt: row.rubricVwitmPnt, seqno: Number(row.rubricVwitmSeqno) });
            });

            qstnOrder.forEach(function(qid) {
                var q = qstnMap[qid];
                q.vwitms.sort(function(a, b) { return a.seqno - b.seqno; });

                addRubricQstn(true); // 수정 화면은 기존 배점을 유지해야 하므로 자동 배점 계산을 건너뛴다.
                var n     = _qstnSeq;
                var domId = 'qstn' + String(n).padStart(2, '0');

                // 문항명, 배점 반영
                var ttlInput   = document.getElementById('rubricQstnTtl' + n);
                var evlrtInput = document.getElementById('evlrt' + n);
                if (ttlInput)   ttlInput.value   = q.ttl;
                if (evlrtInput) evlrtInput.value = q.evlrt;

                // 저장된 평가척도 선택
                var subBox = document.querySelector('.sub-box.rub_grade[data-prnt="' + domId + '"]');
                if (!subBox) return;
                var radioToCheck = subBox.querySelector('input[type="radio"][value="' + q.evlTycd + '"]');
                if (radioToCheck) {
                    radioToCheck.checked = true;
                    _showGradeItem(subBox, q.evlTycd);
                }

                // 기존 보기 항목 반영
                var evlKey       = q.evlTycd.toLowerCase().replace('_', '-');
                var activeEvlDiv = subBox.querySelector('[data-evl="' + evlKey + '"]');
                if (!activeEvlDiv) return;

                var existingRows = Array.from(activeEvlDiv.querySelectorAll('.item'));
                var fillCount    = Math.min(q.vwitms.length, existingRows.length);

                for (var i = 0; i < fillCount; i++) {
                    var inputs = existingRows[i].querySelectorAll('input[type="text"]');
                    if (inputs[0]) inputs[0].value = q.vwitms[i].pnt;
                    if (inputs[1]) inputs[1].value = q.vwitms[i].ttl;
                }

                // 자유척도는 기본 행보다 많은 항목이 있으면 추가 생성한다.
                for (var j = existingRows.length; j < q.vwitms.length; j++) {
                    addFreePntVwitm();
                    var newRows = activeEvlDiv.querySelectorAll('.item');
                    var lastRow = newRows[newRows.length - 1];
                    if (lastRow) {
                        var ins = lastRow.querySelectorAll('input[type="text"]');
                        if (ins[0]) ins[0].value = q.vwitms[j].pnt;
                        if (ins[1]) ins[1].value = q.vwitms[j].ttl;
                    }
                }
            });

            var firstItem = document.querySelector('#qstnArea .item');
            if (firstItem) showSubBox(firstItem.id);
        }

        $(document).ready(function() {
            if (isModify === 'Y') {
                loadRubricInfoForModify(rubricInfoList);
            } else {
                addRubricQstn();
            }
        });
	</script>
    <style>
        .rubricmng-page .rubric-qstn-table table {
            table-layout: fixed;
        }
        .rubricmng-page .rubric-qstn-table td {
            padding: 6px 8px;
            vertical-align: middle;
        }
        .rubricmng-page .rubric-qstn-table .item {
            cursor: pointer;
        }
        .rubricmng-page .rubric-qstn-table .item.active td {
            background: #f7f8fa;
        }
        .rubricmng-page .rubric-qstn-table .label_num {
            font-weight: 700;
            color: #222;
        }
        .rubricmng-page .rubric-qstn-table .score-box {
            display: flex;
            align-items: center;
            gap: 6px;
        }
        /* 관리자 화면에서 필요한 평가등급 스타일만 보정한다. */
        .rubricmng-page .rubrics_wrap .sub-box {
            margin-top: 0;
            padding: 14px 16px;
            border: 1px solid #d9e1ec;
            border-radius: 6px;
            background: #fff;
        }
        .rubricmng-page .rubrics_wrap .grade-top {
            align-items: center;
        }
        .rubricmng-page .rubrics_wrap .grade-top-left {
            display: flex;
            align-items: center;
            gap: 18px;
            flex-wrap: wrap;
        }
        .rubricmng-page .rubrics_wrap .grade-top .board-title {
            margin: 0;
            font-size: 15px;
            white-space: nowrap;
        }
        .rubricmng-page .rubrics_wrap .grade_item {
            display: flex;
            flex-direction: column;
            gap: .8rem;
            margin-top: 1.2rem;
        }
        .rubricmng-page .rubrics_wrap .grade_item .item {
            display: flex;
            align-items: center;
            gap: .8rem;
        }
        .rubricmng-page .rubrics_wrap .input_btn {
            display: flex;
            align-items: center;
            gap: 8px;
            flex: 0 0 auto;
        }
        .rubricmng-page .rubrics_wrap .input_btn label {
            white-space: nowrap;
        }
    </style>
</head>
<body class="admin ${bodyClass}">
    <div id="wrap" class="main rubricmng-page">
        <jsp:include page="/WEB-INF/jsp/common_new/admin_header.jsp"/>

        <main class="common">
            <jsp:include page="/WEB-INF/jsp/common_new/admin_aside.jsp"/>

            <div id="content" class="content-wrap common">
                <div class="admin_sub">
                    <div class="sub-content">
                        <div class="page-info">
                            <h2 class="page-title">${uiex:getCurMenunm()}</h2>
                            <uiex:navibar type="admin"/>
                        </div>

                        <input type="hidden" id="encParams" value="<c:out value='${encParams}'/>">

                        <div class="board_top">
                            <h3 class="board-title">
                                <c:if test="${isModify eq 'N' or empty isModify}">
                                    <spring:message code="crs.label.rubric"/><%--루브릭--%> <spring:message code="common.button.create"/><%--등록--%>
                                </c:if>
                                <c:if test="${isModify eq 'Y'}">
                                    <spring:message code="crs.label.rubric"/><%--루브릭--%> <spring:message code="common.button.modify"/><%--수정--%>
                                </c:if>
                            </h3>
                            <div class="right-area">
                                <c:if test="${isModify eq 'N' or empty isModify}">
                                    <button type="button" class="btn basic" onclick="rubricImportPop();"><spring:message code="crs.import.rubric"/><%--루브릭 가져오기--%></button>
                                </c:if>
                                <button type="button" class="btn type1" onclick="rubricSave();"><spring:message code="common.button.save"/><%--저장--%></button>
                                <button type="button" class="btn type2" onclick="rubricListViewMv();"><spring:message code="common.button.list"/><%--목록--%></button>
                            </div>
                        </div>

                        <div>
                            <div class="rubric-section mt20">
                                <div class="board_top mb10">
                                    <h4 class="board-title"><spring:message code="common.label.org"/><%--기관--%></h4>
                                </div>
                                <div class="table-wrap rubric-basic-table">
                                    <table class="table-type5">
                                        <colgroup>
                                            <col style="width:120px;">
                                            <col>
                                        </colgroup>
                                        <tbody>
                                        <tr>
                                            <th><label for="orgId" class="req"><spring:message code="common.label.org"/><%--기관--%></label></th>
                                            <td>
                                                <select id="orgId" class="form-select type-num w300" <c:if test="${isModify eq 'Y'}">disabled="disabled"</c:if>>
                                                    <c:if test="${allOrgYn eq 'Y' and (isModify eq 'N' or empty isModify)}">
                                                        <option value=""><spring:message code="common.button.choice"/><%--선택--%></option>
                                                    </c:if>
                                                    <c:forEach var="org" items="${orgInfoList}">
                                                        <option value="${org.orgId}" <c:if test="${org.orgId eq vo.orgId}">selected="selected"</c:if>><c:out value="${empty org.orgNm ? org.orgnm : org.orgNm}"/></option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                        </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <div class="rubric-section mt20">
                                <div class="board_top mb10">
                                    <h4 class="board-title"><spring:message code="crs.rubric.mng.section.qstn"/><%--루브릭 문항 등록--%></h4>
                                </div>
                                <div class="rubric-title-row mb8">
                                    <input class="form-control width-100per" type="text" name="name" id="rubricTtl"
                                           value="${vo.rubricTtl}" placeholder="<spring:message code='crs.rubric.mng.placeholder.rubric.title'/><%--루브릭 제목--%>"
                                           required="true" inputmask="byte" maxLen="150" autocomplete="off">
                                </div>
                                <div class="table-wrap rubric-qstn-table">
                                    <table class="table-type2">
                                        <colgroup>
                                            <col style="width:50px;">
                                            <col>
                                            <col style="width:120px;">
                                            <col style="width:56px;">
                                        </colgroup>
                                        <tbody id="qstnArea"></tbody>
                                    </table>
                                </div>
                                <div class="rubric-qstn-toolbar flex flex-justify-right mt8">
                                    <button type="button" class="btn type2" onclick="addRubricQstn();"><spring:message code="crs.rubric.mng.button.add.qstn"/><%--문항 추가--%></button>
                                </div>
                            </div>

                            <div class="rubric-section mt20">
                                <div class="board_top mb10">
                                    <h4 class="board-title"><spring:message code="crs.rubric.mng.section.grade"/><%--문항의 평가등급 설정--%></h4>
                                </div>
                                <div class="rubrics_wrap" id="gradeArea"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
