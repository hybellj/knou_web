<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ include file="/WEB-INF/jsp/common_new/common_inc.jsp" %>
<%@ include file="/WEB-INF/jsp/crs/common/crs_common_inc.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="/WEB-INF/jsp/common_new/common_head.jsp">
        <jsp:param name="style" value="classroom"/>
        <jsp:param name="module" value="table"/>
    </jsp:include>

    <style>
        .rubric_import_area .form-select,
        .rubric_import_area .chosen-container {
            width: 100% !important;
        }
    </style>

    <script type="text/javascript">
        var _qstnSeq = 0;
        var rubricId = '${vo.rubricId}';
        var userId = '${vo.userId}';
        var isModify = '${isModify}';
        var readOnlyYn = '${vo.readOnlyYn}';
        var orgId = '${orgId}';
        var rubricTycd = '${empty rubricTycd ? "PROF" : rubricTycd}';
        var originRubricId = '';


        var rubricInfoList = [
            <c:forEach var="info" items="${rubricInfoVO}" varStatus="st">
            {
                rubricQstnId: "<c:out value='${info.rubricQstnId}'/>",
                rubricQstnTtl: "<c:out value='${info.rubricQstnTtl}'/>",
                evlrt: "<c:out value='${info.evlrt}'/>",
                rubricEvlTycd: "<c:out value='${info.rubricEvlTycd}'/>",
                rubricVwitmId: "<c:out value='${info.rubricVwitmId}'/>",
                rubricVwitmTtl: "<c:out value='${info.rubricVwitmTtl}'/>",
                rubricVwitmPnt: "<c:out value='${info.rubricVwitmPnt}'/>",
                rubricVwitmSeqno: ${empty info.rubricVwitmSeqno ? 0 : info.rubricVwitmSeqno}
            }<c:if test="${!st.last}">, </c:if>
            </c:forEach>
        ];


        /** 루브릭 가져오기 목록을 다시 조회한다. */
        function rubricImportPop() {
            $("#rubricImportArea").show();
            loadRubricImportList();
        }

        /** 가져온 루브릭 데이터로 문항과 평가등급을 다시 구성한다. */
        function loadRubricImport(list) {
            document.getElementById('qstnArea').innerHTML = '';
            document.querySelectorAll('.sub-box.rub_grade').forEach(function (el) {
                el.remove();
            });
            _qstnSeq = 0;
            loadRubricInfoForModify(list);
        }

        /** 루브릭 가져오기 셀렉트 목록을 조회한다. */
        function loadRubricImportList() {
            $.ajax({
                url: "/crs/rubricImportList.do",
                type: "GET",
                dataType: "json",
                success: function (data) {
                    var $select = $("#importRubricId");
                    $select.empty().append("<option value=''>루브릭 선택</option>");
                    (data.returnList || []).forEach(function (item) {
                        var rubricTtl = item.rubricTycd === "ORG" ? "[기본] " + item.rubricTtl : item.rubricTtl;
                        $select.append(
                            $("<option/>")
                            .val(item.rubricId)
                            .text(rubricTtl)
                            .attr("data-user-id", item.userId)
                            .attr("data-rubric-ttl", item.rubricTtl)
                        );
                    });
                    $select.val("");
                    $select.trigger("chosen:updated");
                },
                error: function () {
                    UiComm.showMessage("<spring:message code='crs.error.list' />", "error");
                }
            });
        }


        /** 선택한 루브릭을 현재 팝업 편집 영역에 불러온다. */
        function importSelectedRubric() {
            var $selected = $("#importRubricId option:selected");
            var rubricId = $selected.val();
            if (!rubricId) {
                return;
            }
            originRubricId = rubricId;

            $.ajax({
                url: "/crs/rubricList.do",
                type: "GET",
                data: {
                    userId: $selected.attr("data-user-id"),
                    rubricId: rubricId
                },
                dataType: "json",
                success: function (data) {
                    var detailList = $.isArray(data) ? data : (data.returnList || []);
                    $("#rubricTtl").val($selected.attr("data-rubric-ttl"));
                    loadRubricImport(detailList);
                    $("#rubricImportArea").hide();
                    $("#importRubricId").val("").trigger("chosen:updated");
                },
                error: function () {
                    UiComm.showMessage("<spring:message code='crs.error.select.msg' />", "error");
                }
            });
        }


        /** 팝업을 닫고 이전 화면으로 돌아간다. */
        function rubricListViewMv() {
            window.parent.closeDialog();
        }


        /** 저장 전 필수 입력값을 검증한다. */
        function isNull() {
            var isResult = true;
            var alertMsg = '';

            Array.from(document.querySelectorAll('#qstnArea .item[data-qstn-num]')).every(function (item) {
                var n = parseInt(item.dataset.qstnNum, 10);
                var seqno = parseInt(item.querySelector('.label_num').textContent, 10);

                var ttlInput = document.getElementById('rubricQstnTtl' + n);
                var evlrtInput = document.getElementById('evlrt' + n);

                if (!ttlInput || ttlInput.value.trim() === '') {
                    isResult = false;
                    alertMsg = seqno + '<spring:message code='crs.input.qstn.title' />';
                    return false;
                }
                if (!evlrtInput || evlrtInput.value.trim() === '') {
                    isResult = false;
                    alertMsg = seqno + '<spring:message code='crs.input.qstn.score' />';
                    return false;
                }

                var subBox = document.querySelector('.sub-box.rub_grade[data-prnt="' + item.id + '"]');
                var checkedRd = subBox ? subBox.querySelector('input[type="radio"]:checked') : null;

                if (subBox && checkedRd) {
                    var evlKey = checkedRd.value.toLowerCase().replace('_', '-');
                    var activeEvlDiv = subBox.querySelector('[data-evl="' + evlKey + '"]');
                    if (activeEvlDiv) {
                        Array.from(activeEvlDiv.querySelectorAll('.item')).every(function (row, rowIdx) {
                            var inputs = row.querySelectorAll('input[type="text"]');
                            if (!inputs[0] || inputs[0].value.trim() === '') {
                                isResult = false;
                                alertMsg = seqno + '<spring:message code='crs.no.qstn' /> ' + (rowIdx + 1) + '<spring:message code='crs.input.vwitm.score' />';
                                return false;
                            }
                            if (!inputs[1] || inputs[1].value.trim() === '') {
                                isResult = false;
                                alertMsg = seqno + '<spring:message code='crs.no.qstn' /> ' + (rowIdx + 1) + '<spring:message code='crs.input.vwitm.content' />';
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


        /** 저장된 루브릭 정보를 호출 화면에 전달한다. */
        function applySavedRubric(savedRubricId, rubricTtl) {
            if (window.parent && typeof window.parent.applyRubric === 'function') {
                window.parent.applyRubric(savedRubricId, rubricTtl);
            }
        }

        /** 현재 편집 중인 루브릭을 저장한다. */
        function rubricSave() {
            var rubricTtl = document.getElementById('rubricTtl').value.trim();
            if (!rubricTtl) {
                UiComm.showMessage('<spring:message code='crs.input.rubric.title' />', 'warning');
                return;
            }

            var items = document.querySelectorAll('#qstnArea .item[data-qstn-num]');

            var totalEvlrt = 0;
            items.forEach(function (item) {
                var n = parseInt(item.dataset.qstnNum, 10);
                var evlrtInput = document.getElementById('evlrt' + n);
                totalEvlrt += evlrtInput ? (parseFloat(evlrtInput.value) || 0) : 0;
            });
            totalEvlrt = Math.round(totalEvlrt * 10) / 10;
            if (totalEvlrt !== 100) {
                UiComm.showMessage('<spring:message code='crs.evl.msg1' />\n(<spring:message code='crs.current' /> ' + totalEvlrt + '%).', 'warning');
                return;
            }

            if (!isNull()) return;

            var saveUrl = isModify === 'Y' ? '/crs/rubricModify.do' : '/crs/rubricRegist.do';
            var params = {
                rubricId: isModify === 'Y' ? rubricId : '',
                upRubricId: isModify !== 'Y' ? originRubricId : '',
                rubricTycd: rubricTycd,
                orgId: orgId,
                userId: userId,
                rubricTtl: rubricTtl,
                rubricQstnCnt: items.length
            };

            items.forEach(function (item, qi) {
                var n = parseInt(item.dataset.qstnNum, 10);
                var subBox = document.querySelector('.sub-box.rub_grade[data-prnt="' + item.id + '"]');
                var checkedRd = subBox ? subBox.querySelector('input[type="radio"]:checked') : null;
                var rubricEvlTycd = checkedRd ? checkedRd.value : '';

                params['rubricQstns[' + qi + '].rubricQstnTtl'] = (document.getElementById('rubricQstnTtl' + n) || {}).value || '';
                params['rubricQstns[' + qi + '].rubricQstnSeqno'] = qi + 1;
                params['rubricQstns[' + qi + '].evlrt'] = (document.getElementById('evlrt' + n) || {}).value || '';
                params['rubricQstns[' + qi + '].rubricEvlTycd'] = rubricEvlTycd;

                if (subBox && rubricEvlTycd) {
                    var evlKey = rubricEvlTycd.toLowerCase().replace('_', '-');
                    var activeEvlDiv = subBox.querySelector('[data-evl="' + evlKey + '"]');
                    if (activeEvlDiv) {
                        var pntList = [], ttlList = [];
                        activeEvlDiv.querySelectorAll('.item').forEach(function (row) {
                            var inputs = row.querySelectorAll('input[type="text"]');
                            pntList.push(inputs[0] ? inputs[0].value : '');
                            ttlList.push(inputs[1] ? inputs[1].value : '');
                        });
                        params['rubricQstns[' + qi + '].rubricVwitmPntList'] = pntList.join(',');
                        params['rubricQstns[' + qi + '].rubricVwitmTtlList'] = ttlList.join(',');
                    }
                }
            });

            UiComm.showLoading(true);
            $.ajax({
                url: saveUrl,
                type: 'POST',
                data: params,
                dataType: 'json',
                success: function (result) {
                    if (result.result > 0) {
                        UiComm.showMessage(result.message, 'success').then(function () {
                            var savedRubricId = result.returnVO && result.returnVO.rubricId ? result.returnVO.rubricId : rubricId;
                            applySavedRubric(savedRubricId, rubricTtl);
                            window.parent.closeDialog();
                        });
                    } else {
                        UiComm.showMessage(result.message, 'warning');
                    }
                },
                error: function () {
                    UiComm.showMessage(
                        isModify === 'Y'
                            ? "<spring:message code='crs.error.modify.msg' />"
                            : "<spring:message code='crs.error.regist.msg' />"
                        , 'error');
                },
                complete: function () {
                    UiComm.showLoading(false);
                }
            });
        }


        /** 루브릭 평가 문항을 추가한다. */
        function addRubricQstn(skipRecalc) {
            _qstnSeq++;
            var ns = String(_qstnSeq).padStart(2, '0');
            var qstnId = 'qstn' + ns;
            document.getElementById('qstnArea')
            .insertAdjacentHTML('beforeend', _itemHtml(qstnId, _qstnSeq));
            document.querySelector('.rubrics_wrap')
            .insertAdjacentHTML('beforeend', _subBoxHtml(qstnId, ns));
            showSubBox(qstnId);
            _reindexLabels();
            if (!skipRecalc) _recalcEvlrt();
        }


        /** 선택한 문항의 평가등급 영역만 표시한다. */
        function showSubBox(qstnId) {
            document.querySelectorAll('#qstnArea .item').forEach(function (el) {
                el.classList.remove('active');
            });
            var targetItem = document.getElementById(qstnId);
            if (targetItem) targetItem.classList.add('active');

            document.querySelectorAll('.sub-box.rub_grade').forEach(function (el) {
                el.style.display = 'none';
            });
            var subBox = document.querySelector('.sub-box.rub_grade[data-prnt="' + qstnId + '"]');
            if (!subBox) return;
            subBox.style.display = '';
            var checkedRd = subBox.querySelector('input[type="radio"]:checked');
            if (checkedRd) _showGradeItem(subBox, checkedRd.value);
        }


        /** 평가척도 변경에 맞춰 등급 입력 영역을 전환한다. */
        function _showGradeItem(subBox, radioValue) {
            var evlKey = radioValue.toLowerCase().replace('_', '-');
            subBox.querySelectorAll('.grade_item [data-evl]').forEach(function (el) {
                el.style.display = (el.dataset.evl === evlKey) ? '' : 'none';
            });
            var addGradeBtn = subBox.querySelector('.board_top .right-area');
            if (addGradeBtn) addGradeBtn.style.display = (evlKey === 'free-pnt') ? '' : 'none';
        }


        /** 문항 번호를 화면 순서에 맞게 다시 정렬한다. */
        function _reindexLabels() {
            document.querySelectorAll('#qstnArea .item').forEach(function (el, idx) {
                var lbl = el.querySelector('.label_num');
                if (lbl) lbl.textContent = idx + 1;
            });
        }


        /** 문항별 평가비율을 균등하게 다시 계산한다. */
        function _recalcEvlrt() {
            var items = Array.from(document.querySelectorAll('#qstnArea .item[data-qstn-num]'));
            var n = items.length;
            if (n === 0) return;
            var base = Math.floor(100 / n);
            var remainder = 100 - base * n;
            items.forEach(function (item, idx) {
                var input = document.getElementById('evlrt' + parseInt(item.dataset.qstnNum, 10));
                if (input) input.value = (idx === n - 1) ? base + remainder : base;
            });
        }


        /** 문항 입력 영역 HTML을 생성한다. */
        function _itemHtml(qstnId, n) {
            var readOnlyAttr = readOnlyYn === 'Y' ? ' readonly' : '';
            var closeBtn = readOnlyYn === 'Y' ? '' : '<button type="button" class="btn basic icon" data-close-set="' + qstnId + '"><i class="xi-close"></i></button>';

            return '<div class="item" id="' + qstnId + '" data-qstn-num="' + n + '">'
                + '<label class="label_num"></label>'
                + '<input class="form-control wide" type="text" id="rubricQstnTtl' + n + '" value="" placeholder="<spring:message code='crs.input.qstn.nm' />"' + readOnlyAttr + '>'
                + '<input class="form-control sm"   type="text" inputmask="numeric" maxVal="1000" id="evlrt' + n + '" value="" placeholder="<spring:message code='message.marks' />(%)"' + readOnlyAttr + '>'
                + closeBtn
                + '</div>';
        }


        /** 문항별 평가등급 영역 HTML을 생성한다. */
        function _subBoxHtml(qstnId, ns) {
            var rdName = 'rubric-evl-tycd-rd-' + ns;

            function _rd(id, val, lbl, chk) {
                return '<span class="custom-input ml5">'
                    + '<input type="radio" name="' + rdName + '" id="' + id + '" value="' + val + '"' + (chk ? ' checked' : '') + (readOnlyYn === 'Y' ? ' disabled' : '') + '>'
                    + '<label for="' + id + '">' + lbl + '</label></span>';
            }

            return '<div class="sub-box rub_grade" data-prnt="' + qstnId + '" data-vwitm="vwitm' + ns + '">'
                + '<div class="board_top"><h3 class="board-title"><spring:message code='common.label.eval.grade' /></h3>'
                + '<div class="form-inline">'
                + _rd('five-pnt-' + ns, 'FIVE_PNT', '<spring:message code='crs.5pnt' />', true)
                + _rd('three-pnt-' + ns, 'THREE_PNT', '<spring:message code='crs.3pnt' />', false)
                + _rd('free-pnt-' + ns, 'FREE_PNT', '<spring:message code='crs.free.pnt' />', false)
                + _rd('ox-evl-' + ns, 'OX_EVL', '<spring:message code='crs.ox.pnt' />', false)
                + '</div>'
                + '<div class="right-area" style="display:none"><button type="button" class="btn type2" onclick="addFreePntVwitm()"><spring:message code='common.label.add.grade' /></button></div>'
                + '</div>'
                + '<div class="grade_item" data-rd-set="' + qstnId + '">'
                + _gradeBlockHtml('five-pnt', [['5', '<spring:message code='crs.vwitm.ex1' />']
                        , ['4', '<spring:message code='crs.vwitm.ex2' />']
                        , ['3', '<spring:message code='crs.vwitm.ex3' />']
                        , ['2', '<spring:message code='crs.vwitm.ex4' />']
                        , ['1', '<spring:message code='crs.vwitm.ex5' />']]
                    , false)
                + _gradeBlockHtml('three-pnt', [['3', '<spring:message code='crs.vwitm.ex2' />']
                        , ['2', '<spring:message code='crs.vwitm.ex3' />']
                        , ['1', '<spring:message code='crs.vwitm.ex4' />']]
                    , true)
                + _gradeBlockHtml('free-pnt', [['3', '<spring:message code='crs.vwitm.ex2' />']
                        , ['2', '<spring:message code='crs.vwitm.ex3' />']
                        , ['1', '<spring:message code='crs.vwitm.ex4' />']]
                    , true)
                + _gradeBlockHtml('ox-evl', [['2', 'O', true], ['1', 'X', true]], true)
                + '</div>'
                + '</div>';
        }


        /** 자유척도 등급 항목을 추가한다. */
        function addFreePntVwitm() {
            if (readOnlyYn === 'Y') return;

            var activeItem = document.querySelector('#qstnArea .item.active');
            if (!activeItem) return;
            var subBox = document.querySelector('.sub-box.rub_grade[data-prnt="' + activeItem.id + '"]');
            if (!subBox) return;
            var freePntDiv = subBox.querySelector('[data-evl="free-pnt"]');
            if (!freePntDiv) return;
            if (freePntDiv.querySelectorAll('.item').length >= 10) {
                UiComm.showMessage("<spring:message code='crs.free.pnt.add.msg' />", "info");
                return;
            }
            freePntDiv.insertAdjacentHTML('beforeend',
                '<div class="item">'
                + '<div class="input_btn"><input class="form-control sm" type="text" value="" autocomplete="off"><label><spring:message code='crs.vwitm.pnt' /></label></div>'
                + '<input class="form-control wide" type="text" value="">'
                + '<button type="button" class="btn basic icon" data-del-grade><i class="xi-close"></i></button>'
                + '</div>');
        }


        /** 평가척도별 등급 항목 HTML을 생성한다. */
        function _gradeBlockHtml(evlKey, rows, hidden) {
            var html = '<div data-evl="' + evlKey + '"' + (hidden ? ' style="display:none"' : '') + '>';
            var readOnlyAttr = readOnlyYn === 'Y' ? ' readonly' : '';
            rows.forEach(function (r) {
                var delBtn = (evlKey === 'free-pnt' && readOnlyYn !== 'Y') ? '<button type="button" class="btn basic icon" data-del-grade><i class="xi-close"></i></button>' : '';
                html += '<div class="item">'
                    + '<div class="input_btn"><input class="form-control sm" type="text" value="' + r[0] + '" autocomplete="off"' + readOnlyAttr + '><label><spring:message code='crs.vwitm.pnt' /></label></div>'
                    + '<input class="form-control wide' + (r[2] ? ' disabled' : '') + '" type="text" value="' + r[1] + '"' + (r[2] || readOnlyYn === 'Y' ? ' readonly' : '') + '>'
                    + delBtn
                    + '</div>';
            });
            return html + '</div>';
        }


        document.addEventListener('click', function (e) {

            var delGradeBtn = e.target.closest('[data-del-grade]');
            if (delGradeBtn) {
                if (readOnlyYn === 'Y') return;

                e.stopPropagation();
                delGradeBtn.closest('.item').remove();
                return;
            }

            var closeBtn = e.target.closest('[data-close-set]');
            if (closeBtn) {
                if (readOnlyYn === 'Y') return;

                e.stopPropagation();
                var qstnId = closeBtn.dataset.closeSet;
                var item = document.getElementById(qstnId);
                var subBox = document.querySelector('.sub-box.rub_grade[data-prnt="' + qstnId + '"]');
                var wasActive = item && item.classList.contains('active');
                if (item) item.remove();
                if (subBox) subBox.remove();
                _reindexLabels();
                _recalcEvlrt();
                if (wasActive) {
                    var firstItem = document.querySelector('#qstnArea .item');
                    if (firstItem) showSubBox(firstItem.id);
                }
                return;
            }

            var qstnItem = e.target.closest('#qstnArea .item[data-qstn-num]');
            if (qstnItem) showSubBox(qstnItem.id);
        });


        document.addEventListener('change', function (e) {
            if (readOnlyYn === 'Y') return;

            if (e.target.type !== 'radio') return;
            var subBox = e.target.closest('.sub-box.rub_grade');
            if (subBox) _showGradeItem(subBox, e.target.value);
        });


        /** 조회된 루브릭 상세 데이터를 편집 화면에 채운다. */
        function loadRubricInfoForModify(list) {
            if (!list || list.length === 0) return;

            var qstnMap = {};
            var qstnOrder = [];
            list.forEach(function (row) {
                var qid = row.rubricQstnId;
                if (!qstnMap[qid]) {
                    qstnMap[qid] = {ttl: row.rubricQstnTtl, evlrt: row.evlrt, evlTycd: row.rubricEvlTycd, vwitms: []};
                    qstnOrder.push(qid);
                }
                qstnMap[qid].vwitms.push({ttl: row.rubricVwitmTtl, pnt: row.rubricVwitmPnt, seqno: Number(row.rubricVwitmSeqno)});
            });

            qstnOrder.forEach(function (qid) {
                var q = qstnMap[qid];
                q.vwitms.sort(function (a, b) {
                    return a.seqno - b.seqno;
                });

                addRubricQstn(true);
                var n = _qstnSeq;
                var domId = 'qstn' + String(n).padStart(2, '0');

                var ttlInput = document.getElementById('rubricQstnTtl' + n);
                var evlrtInput = document.getElementById('evlrt' + n);
                if (ttlInput) ttlInput.value = q.ttl;
                if (evlrtInput) evlrtInput.value = q.evlrt;

                var subBox = document.querySelector('.sub-box.rub_grade[data-prnt="' + domId + '"]');
                if (!subBox) return;
                var radioToCheck = subBox.querySelector('input[type="radio"][value="' + q.evlTycd + '"]');
                if (radioToCheck) {
                    radioToCheck.checked = true;
                    _showGradeItem(subBox, q.evlTycd);
                }

                var evlKey = q.evlTycd.toLowerCase().replace('_', '-');
                var activeEvlDiv = subBox.querySelector('[data-evl="' + evlKey + '"]');
                if (!activeEvlDiv) return;

                var existingRows = Array.from(activeEvlDiv.querySelectorAll('.item'));
                var fillCount = Math.min(q.vwitms.length, existingRows.length);

                for (var i = 0; i < fillCount; i++) {
                    var inputs = existingRows[i].querySelectorAll('input[type="text"]');
                    if (inputs[0]) inputs[0].value = q.vwitms[i].pnt;
                    if (inputs[1]) inputs[1].value = q.vwitms[i].ttl;
                }

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

        $(document).ready(function () {
            if (isModify === 'Y' || rubricInfoList.length > 0) {
                loadRubricInfoForModify(rubricInfoList);
            } else {
                addRubricQstn();
            }

            if (readOnlyYn === 'Y') {
                applyReadOnlyRubricPop();
            }
        });

        /** 조회 전용 팝업에서는 입력과 편집 버튼을 비활성화한다. */
        function applyReadOnlyRubricPop() {
            document.querySelectorAll('#rubricTtl, #qstnArea input').forEach(function (el) {
                if (el.type === 'radio' || el.type === 'checkbox') {
                    el.disabled = true;
                } else {
                    el.readOnly = true;
                }
            });

            document.querySelectorAll('[data-close-set], [data-del-grade]').forEach(function (el) {
                el.style.display = 'none';
            });
        }
    </script>
</head>

<body class="modal-body">
<c:if test="${vo.readOnlyYn ne 'Y'}">
    <div class="msg-box warning">
        <p class="txt">
            <i class="xi-error" aria-hidden="true"></i>
            <strong>평가 진행 혹은 완료된 후</strong>, 평가비중을 수정하면 이미 진행된 평가 내용은 모두 삭제되어 초기화됩니다.
        </p>
    </div>
</c:if>

<div class="board_top">
    <h3 class="board-title">루브릭 평가</h3>
    <div class="right-area">
        <c:if test="${vo.readOnlyYn ne 'Y'}">
            <button type="button" class="btn basic" onclick="rubricImportPop();">루브릭 가져오기</button>
            <button type="button" class="btn type2" onclick="rubricSave();">저장</button>
        </c:if>
    </div>
</div>


<div class="rubrics_wrap">
    <div id="rubricImportArea" class="board_top rubric_import_area" style="display:none;">
        <select class="form-select " id="importRubricId" onchange="importSelectedRubric();">
            <option value="">루브릭 선택</option>
        </select>
    </div>
    <div class="rub_write">
        <div class="top">
            <input class="form-control width-100per" type="text" name="name" id="rubricTtl"
                   value="${rubricDefaultInfoVO.rubricTtl}" placeholder="루브릭명을 입력하세요."
                   required="true" inputmask="byte" maxlen="150" autocomplete="off">
        </div>
        <div class="board_top margin-top-2">
            <h3 class="board-title">평가 항목</h3>
            <c:if test="${vo.readOnlyYn ne 'Y'}">
                <div class="right-area">
                    <button type="button" class="btn type2" onclick="addRubricQstn();">문항 추가</button>
                </div>
            </c:if>
        </div>
        <div class="eval_item" id="qstnArea"></div>
    </div>
</div>

<div class="modal_btns">

    <button type="button" class="btn basic" onclick="window.parent.closeDialog();">닫기</button>
</div>
</body>
</html>
