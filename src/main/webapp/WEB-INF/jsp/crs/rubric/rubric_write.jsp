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

	<script type="text/javascript">
        var _qstnSeq = 0;
        var dialog;

        var rubricId = '${vo.rubricId}';
        var userId   = '${vo.userId}';
        var isModify = '${isModify}';
        var orgId    = '${orgId}';

        /* 수정모드 데이터 (List<EgovMap>) */
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

        /* 루브릭 가져오기 팝업 열기 */
        function rubricImportPop(userId) {
            dialog = UiDialog("dialog1", {
                title: "<spring:message code='crs.import.rubric' />",  /* 루브릭 가져오기 */
                width: 600,
                height: 500,
                url: "/crs/rubricImportPopup.do?userId="+userId,
                autoresize: false
            });
        }

        /* 팝업 닫기 */
        function closeDialog() {
            if (dialog) { dialog.close(); }
        }

        /* 가져온 루브릭 데이터로 문항 세팅 (팝업에서 호출) */
        function loadRubricImport(list) {
            document.getElementById('qstnArea').innerHTML = '';
            document.querySelectorAll('.sub-box.rub_grade').forEach(function(el) { el.remove(); });
            _qstnSeq = 0;
            loadRubricInfoForModify(list);
        }

        /* 목록으로 돌아가기 */
        function rubricListViewMv () {
            UiComm.showMessage("<spring:message code='crs.move.list.view' />", "confirm")   /* 목록으로 돌아가시겠습니까? */
                .then(function(result) {
                    if (result) {
                        rubricViewMv("list");
                    }
                });
        }

        /* 필수값 빈값 검증 */
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
                    alertMsg = seqno + '<spring:message code='crs.input.qstn.title' />';  /* 번 문항의 제목을 입력하세요. */
                    return false;
                }
                if (!evlrtInput || evlrtInput.value.trim() === '') {
                    isResult = false;
                    alertMsg = seqno + '<spring:message code='crs.input.qstn.score' />';  /* 번 문항의 배점을 입력하세요. */
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
                                alertMsg = seqno + '<spring:message code='crs.no.qstn' /> ' + (rowIdx + 1) + '<spring:message code='crs.input.vwitm.score' />';   /* 번 문항 */ /* 번 보기의 점수를 입력하세요. */
                                return false;
                            }
                            if (!inputs[1] || inputs[1].value.trim() === '') {
                                isResult = false;
                                alertMsg = seqno + '<spring:message code='crs.no.qstn' /> ' + (rowIdx + 1) + '<spring:message code='crs.input.vwitm.content' />';  /* 번 문항 */ /* 번 보기의 내용을 입력하세요. */
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

        /* 루브릭 저장 */
        function rubricSave() {
            var rubricTtl = document.getElementById('rubricTtl').value.trim();
            if (!rubricTtl) {
                UiComm.showMessage('<spring:message code='crs.input.rubric.title' />', 'warning');  /* 루브릭 제목을 입력하세요. */
                return;
            }

            var items = document.querySelectorAll('#qstnArea .item[data-qstn-num]');

            // 배점 합산 검증
            var totalEvlrt = 0;
            items.forEach(function(item) {
                var n = parseInt(item.dataset.qstnNum, 10);
                var evlrtInput = document.getElementById('evlrt' + n);
                totalEvlrt += evlrtInput ? (parseFloat(evlrtInput.value) || 0) : 0;
            });
            totalEvlrt = Math.round(totalEvlrt * 10) / 10;
            if (totalEvlrt !== 100) {
                UiComm.showMessage('<spring:message code='crs.evl.msg1' />\n(<spring:message code='crs.current' /> ' + totalEvlrt + '%).', 'warning');  /* 배점의 합은 100% 여야 합니다. */ /* 현재 */
                return;
            }

            if (!isNull()) return;

            var params = {
                rubricId:      rubricId,
                orgId:         orgId,
                userId:        userId,
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

            console.log('[rubricSave] params:', params);

            UiComm.showLoading(true);
            $.ajax({
                url:      isModify === 'Y' ? '/crs/rubricModify.do' : '/crs/rubricRegist.do',
                type:     'POST',
                data:     params,
                dataType: 'json',
                success: function(result) {
                    if (result.result > 0) {
                        UiComm.showMessage(result.message, 'success').then(function() {
                            rubricViewMv("list");
                        });
                    } else {
                        UiComm.showMessage(result.message, 'warning');
                    }
                },
                error: function() {
                    UiComm.showMessage(
                        isModify === 'Y'
                            ? "<spring:message code='crs.error.modify.msg' />"  /* 수정 중 에러가 발생하였습니다. */
                            : "<spring:message code='crs.error.regist.msg' />"  /* 저장 중 에러가 발생하였습니다. */
                        , 'error');
                },
                complete: function() {
                    UiComm.showLoading(false);
                }
            });
        }

        /* 문항 추가 */
        function addRubricQstn(skipRecalc) {
            _qstnSeq++;
            var ns     = String(_qstnSeq).padStart(2, '0');
            var qstnId = 'qstn' + ns;
            document.getElementById('qstnArea')
                .insertAdjacentHTML('beforeend', _itemHtml(qstnId, _qstnSeq));
            document.querySelector('.rubrics_wrap')
                .insertAdjacentHTML('beforeend', _subBoxHtml(qstnId, ns));
            showSubBox(qstnId);
            _reindexLabels();
            if (!skipRecalc) _recalcEvlrt();
        }

        /* 활성 문항 전환 — 해당 sub-box 표시, 나머지 숨김 */
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

        /* grade_item 내 선택된 척도만 표시 + 등급 추가 버튼 표시 제어 */
        function _showGradeItem(subBox, radioValue) {
            var evlKey = radioValue.toLowerCase().replace('_', '-');
            subBox.querySelectorAll('.grade_item [data-evl]').forEach(function(el) {
                el.style.display = (el.dataset.evl === evlKey) ? '' : 'none';
            });
            var addGradeBtn = subBox.querySelector('.board_top .right-area');
            if (addGradeBtn) addGradeBtn.style.display = (evlKey === 'free-pnt') ? '' : 'none';
        }

        /* qstnArea 내 label 번호 재정렬 */
        function _reindexLabels() {
            document.querySelectorAll('#qstnArea .item').forEach(function(el, idx) {
                var lbl = el.querySelector('.label_num');
                if (lbl) lbl.textContent = idx + 1;
            });
        }

        /* 배점 자동 균등 분배 (마지막 문항에 나머지 올림) */
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

        /* 문항 item HTML */
        function _itemHtml(qstnId, n) {
            return '<div class="item" id="' + qstnId + '" data-qstn-num="' + n + '">'
                + '<label class="label_num"></label>'
                + '<input class="form-control wide" type="text" id="rubricQstnTtl' + n + '" value="" placeholder="<spring:message code='crs.input.qstn.nm' />">' /* 문항을 입력하세요 */
                + '<input class="form-control sm"   type="text" inputmask="numeric" maxVal="1000" id="evlrt' + n + '" value="" placeholder="<spring:message code='message.marks' />(%)" >'
                + '<button type="button" class="btn basic icon" data-close-set="' + qstnId + '"><i class="xi-close"></i></button>'
                + '</div>';
        }

        /* sub-box HTML (radio 그룹 + grade_item) */
        function _subBoxHtml(qstnId, ns) {
            var rdName = 'rubric-evl-tycd-rd-' + ns;
            function _rd(id, val, lbl, chk) {
                return '<span class="custom-input ml5">'
                    + '<input type="radio" name="' + rdName + '" id="' + id + '" value="' + val + '"' + (chk ? ' checked' : '') + '>'
                    + '<label for="' + id + '">' + lbl + '</label></span>';
            }
            return '<div class="sub-box rub_grade" data-prnt="' + qstnId + '" data-vwitm="vwitm' + ns + '">'
                +   '<div class="board_top"><h3 class="board-title"><spring:message code='common.label.eval.grade' /></h3>' /* 평가 등급 */
                +     '<div class="form-inline">'
                +       _rd('five-pnt-'  + ns, 'FIVE_PNT',  '<spring:message code='crs.5pnt' />',  true)        /* 5점 척도 */
                +       _rd('three-pnt-' + ns, 'THREE_PNT', '<spring:message code='crs.3pnt' />',  false)       /* 3점 척도 */
                +       _rd('free-pnt-'  + ns, 'FREE_PNT',  '<spring:message code='crs.free.pnt' />',  false)   /* 자유척도 */
                +       _rd('ox-evl-'    + ns, 'OX_EVL',    '<spring:message code='crs.ox.pnt' />',   false)    /* O/X평가 */
                +     '</div>'
                +     '<div class="right-area" style="display:none"><button type="button" class="btn type2" onclick="addFreePntVwitm()"><spring:message code='common.label.add.grade' /></button></div>'   /* 등급 추가 */
                +   '</div>'
                +   '<div class="grade_item" data-rd-set="' + qstnId + '">'
                +     _gradeBlockHtml('five-pnt',  [['5','<spring:message code='crs.vwitm.ex1' />']     /* 매우 잘 했어요 */
                                                    ,['4','<spring:message code='crs.vwitm.ex2' />']    /* 잘 했어요 */
                                                    ,['3','<spring:message code='crs.vwitm.ex3' />']    /* 보통이에요 */
                                                    ,['2','<spring:message code='crs.vwitm.ex4' />']    /* 노력하세요 */
                                                    ,['1','<spring:message code='crs.vwitm.ex5' />']]   /* 더 노력하세요 */
                                                    , false)
                +     _gradeBlockHtml('three-pnt', [['3','<spring:message code='crs.vwitm.ex2' />']     /* 잘 했어요 */
                                                    ,['2','<spring:message code='crs.vwitm.ex3' />']    /* 보통이에요 */
                                                    ,['1','<spring:message code='crs.vwitm.ex4' />']]   /* 노력하세요 */
                                                    , true)
                +     _gradeBlockHtml('free-pnt',  [['3','<spring:message code='crs.vwitm.ex2' />']     /* 잘 했어요 */
                                                    ,['2','<spring:message code='crs.vwitm.ex3' />']    /* 보통이에요 */
                                                    ,['1','<spring:message code='crs.vwitm.ex4' />']]   /* 노력하세요 */
                                                    , true)
                +     _gradeBlockHtml('ox-evl',    [['2','O',true],['1','X',true]], true)
                +   '</div>'
                + '</div>';
        }

        /* 자유척도 등급 추가 (최대 10개) */
        function addFreePntVwitm() {
            var activeItem = document.querySelector('#qstnArea .item.active');
            if (!activeItem) return;
            var subBox = document.querySelector('.sub-box.rub_grade[data-prnt="' + activeItem.id + '"]');
            if (!subBox) return;
            var freePntDiv = subBox.querySelector('[data-evl="free-pnt"]');
            if (!freePntDiv) return;
            if (freePntDiv.querySelectorAll('.item').length >= 10) {
                UiComm.showMessage("<spring:message code='crs.free.pnt.add.msg' />", "info"); /* 자유척도 등급은 최대 10개까지 추가 가능합니다. */
                return;
            }
            freePntDiv.insertAdjacentHTML('beforeend',
                '<div class="item">'
                + '<div class="input_btn"><input class="form-control sm" type="text" value="" autocomplete="off"><label><spring:message code='crs.vwitm.pnt' /></label></div>'  /* 점 */
                + '<input class="form-control wide" type="text" value="">'
                + '<button type="button" class="btn basic icon" data-del-grade><i class="xi-close"></i></button>'
                + '</div>');
        }

        /* data-evl 블록 HTML */
        function _gradeBlockHtml(evlKey, rows, hidden) {
            var html = '<div data-evl="' + evlKey + '"' + (hidden ? ' style="display:none"' : '') + '>';
            rows.forEach(function(r) {
                var delBtn = (evlKey === 'free-pnt') ? '<button type="button" class="btn basic icon" data-del-grade><i class="xi-close"></i></button>' : '';
                html += '<div class="item">'
                    + '<div class="input_btn"><input class="form-control sm" type="text" value="' + r[0] + '" autocomplete="off"><label><spring:message code='crs.vwitm.pnt' /></label></div>'  /* 점 */
                    + '<input class="form-control wide' + (r[2] ? ' disabled' : '') + '" type="text" value="' + r[1] + '"' + (r[2] ? ' readonly' : '') + '>'
                    + delBtn
                    + '</div>';
            });
            return html + '</div>';
        }

        /* 이벤트 위임 — click */
        document.addEventListener('click', function(e) {
            /* 자유척도 등급 항목 삭제 버튼 */
            var delGradeBtn = e.target.closest('[data-del-grade]');
            if (delGradeBtn) {
                e.stopPropagation();
                delGradeBtn.closest('.item').remove();
                return;
            }
            /* 닫기 버튼 */
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
            /* 문항 클릭 */
            var qstnItem = e.target.closest('#qstnArea .item[data-qstn-num]');
            if (qstnItem) showSubBox(qstnItem.id);
        });

        /* 이벤트 위임 — radio 변경 */
        document.addEventListener('change', function(e) {
            if (e.target.type !== 'radio') return;
            var subBox = e.target.closest('.sub-box.rub_grade');
            if (subBox) _showGradeItem(subBox, e.target.value);
        });

        /* 수정모드 데이터 렌더링 */
        function loadRubricInfoForModify(list) {
            if (!list || list.length === 0) return;

            // flat 데이터를 rubricQstnId 기준으로 그룹화 (순서 유지)
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

                addRubricQstn(true); // item + sub-box 생성 및 활성화 (배점 자동계산 skip)
                var n     = _qstnSeq;
                var domId = 'qstn' + String(n).padStart(2, '0');

                // 문항 제목, 배점
                var ttlInput   = document.getElementById('rubricQstnTtl' + n);
                var evlrtInput = document.getElementById('evlrt' + n);
                if (ttlInput)   ttlInput.value   = q.ttl;
                if (evlrtInput) evlrtInput.value = q.evlrt;

                // radio 선택 및 grade_item 전환
                var subBox = document.querySelector('.sub-box.rub_grade[data-prnt="' + domId + '"]');
                if (!subBox) return;
                var radioToCheck = subBox.querySelector('input[type="radio"][value="' + q.evlTycd + '"]');
                if (radioToCheck) {
                    radioToCheck.checked = true;
                    _showGradeItem(subBox, q.evlTycd);
                }

                // 보기항목 값 채우기
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

                // 자유척도 기본 3개 초과 시 추가 행 생성 후 값 세팅
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
</head>

<body class="class ${uiex:getTheme()} "><!-- 컬러선택시 클래스변경 -->
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
                    <!-- 강의실 상단 -->
                    <div class="segment class-area">
                        <div class="info-left">
                            <div class="class_info">
                                <h2>데이터베이스의 이해와 활용 1반</h2>
                                <div class="classSection">
                                    <div class="cls_btn">
                                        <a href="#0" class="btn">강의계획서</a>
                                        <a href="#0" class="btn">학습진도관리</a>
                                        <a href="#0" class="btn">평가기준</a>
                                    </div>
                                </div>
                            </div>
                            <div class="info-cnt">
                                <div class="info_iconSet">
                                    <a href="#0" class="info"><span>공지</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>Q&A</span><div class="num_txt point">17</div></a>
                                    <a href="#0" class="info"><span>1:1</span><div class="num_txt point">3</div></a>
                                    <a href="#0" class="info"><span>과제</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>토론</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>세미나</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>퀴즈</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>설문</span><div class="num_txt">2</div></a>
                                    <a href="#0" class="info"><span>시험</span><div class="num_txt">2</div></a>
                                </div>
                                <div class="info-set">
                                    <div class="info">
                                        <p class="point"><span class="tit">중간고사:</span><span>2025.04.26 16:00</span></p>
                                        <p class="desc"><span class="tit">시간:</span><span>40분</span></p>
                                    </div>
                                    <div class="info">
                                        <p class="point"><span class="tit">기말고사:</span><span>2025.07.26 16:00</span></p>
                                        <p class="desc"><span class="tit">시간:</span><span>40분</span></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="info-right">
                            <div class="flex">
                                <div class="item week">
                                    <div class="item_icon"><i class="icon-svg-calendar-check-02" aria-hidden="true"></i></div>
                                    <div class="item_tit">2025.04.14 ~ 04.20</div>
                                    <div class="item_info"><span class="big">7</span><span class="small">주차</span></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- //강의실 상단 -->

                    <div class="sub-content">
                        <!-- 상단 영역 -->
                        <div class="board_top">
                            <i class="icon-svg-openbook"></i>
                            <c:if test="${isModify eq 'N' or empty isModify}">
                                <h3 class="board-title"><spring:message code='crs.label.rubric' /> <spring:message code='common.button.create' /></h3><!-- 루브릭 --> <!-- 등록 -->
                            </c:if>
                            <c:if test="${isModify eq 'Y'}">
                                <h3 class="board-title"><spring:message code='crs.label.rubric' /> <spring:message code='common.button.modify' /></h3><!-- 루브릭 --> <!-- 수정 -->
                            </c:if>
                            <div class="right-area">
                            <c:if test="${isModify eq 'N' or empty isModify}">
                                <button type="button" class="btn type2" onclick = "rubricImportPop(userId)"><spring:message code='crs.import.rubric' /></button><!-- 루브릭 가져오기 -->
                            </c:if>
                                <button type="button" class="btn type2" onclick = "rubricSave()"><spring:message code='common.button.save' /></button><!-- 저장 -->
                                <button type="button" class="btn basic" onclick = "rubricListViewMv()"><spring:message code='common.button.list' /></button><!-- 목록 -->
                            </div>
                        </div>
                        <table class = "table-type2">
                            <colgroup>
                                <col class="width-10per" />
                                <col class="" />
                            </colgroup>
                            <tbody>
                                <!-- 기관 -->
                                <tr>
                                    <th><label><spring:message code='common.label.org' /></label></th><!-- 기관 -->
                                    <td class="t_left" colspan="3"><pre>${rubricDefaultInfoVO.orgnm}</pre></td>
                                </tr>
                                <!-- 교수 -->
                                <tr>
                                    <th><label><spring:message code='common.professor' /></label></th><!-- 교수 -->
                                    <td class="t_left" colspan="3"><pre>${rubricDefaultInfoVO.usernm}</pre></td>
                                </tr>
                            </tbody>
                        </table>
                        <!-- 등록 영역 -->
                        <div class="rubrics_wrap">
                            <div class="rub_write">
                                <div class="board_top margin-top-4">
                                    <input class="form-control width-60per" type="text" name="name" id="rubricTtl"
                                           value="${rubricDefaultInfoVO.rubricTtl}" placeholder="<spring:message code='crs.input.rubric.nm' />"
                                           required="true" inputmask="byte" maxlen="150" autocomplete="off"><!-- 루브릭명을 입력하세요. -->
                                    <div class="right-area">
                                        <button type="button" class="btn type2" onclick = "addRubricQstn()"><spring:message code='common.label.add.qstn' /></button><!-- 문항 추가 -->
                                    </div>
                                </div>
                                <div class="eval_item" id="qstnArea"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- //content -->
        </main>
        <!-- //classroom-->
    </div>
</body>
</html>
