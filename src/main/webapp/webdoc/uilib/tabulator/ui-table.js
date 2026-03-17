/**
 * 테이블 생성 (Tabulator)
 *
 * <div id="tableId"></div>
 * <div id="tableId_cardForm" style="display:none">
 *    #[title]  // columns field 항목의 데이터가 적용됨.
 *   카드폼 내용...
 * </div>
 * 카드 폼(TABLEID_cardForm) 있는 경우만 카드모드 적용됨.
 *
 * let table = UiTable("tableId" {
 *        lang: "ko",				// 언어
 *        tableMode: "list",		// 테이블 모드(list, card), 기본값:list, (card 모드는 카드폼 있는 경우만 유효)
 *        height: 500,			// 테이블 높이, 미설정시 자동크기
 *        rowHeight: 40,			// Row 높이, 미설정시 기본값(40) 적용
 *        selectRow: "checkbox",	// Row 선택 설정(checkbox:체크박스 표시, 1:Row 1개만 선택, selectRowFunc 지정한 함수 호출), 기본값:false
 *        selectRowFunc: func,	// Row 선택시 호출 함수, selectRow:1 인경우
 *        sortFunc: func,			// 헤더 Sort 아이콘 클릭시 호출 함수, 미설정시 테이블 자체 정렬 (칼럼에 headerSort:true 지정시)
 *        initialSort: [{column:"field", dir:"asc"}], // Sort 초기값 (칼럼에 headerSort:true 지정시)
 *        placeholder: "message",	// 데이터가 없을때 메시지 표시, 미설정시 기본값(데이터가 없습니다.)
 *        pageInfo: info,			// 페이지 정보
 *        pageFunc: func,			// 페이지 선택시 호출 함수
 *        showTotRecord: true,	//
 *        showCurrentPage: true,
 *        columns: [....],		// 칼럼 정보,
 *        data: [{....}],			// 테이블 데이터, 초기 데이터가 있을 경우
 * });
 *
 * table.clearData();			// 테이블 내용 전체 지우기
 * table.replaceData(dataList);	// 테이블 내용 교체
 *
 * // Row 선택(selectableRows:'checkbox') 적용할 경우 선택된 값 가져오기, Array로 반환
 * let data = table.getSelectedData("key");
 *
 * // selectRowFunc 예시
 * function selectRowFunc(data) {
 *        let val = data["name"]; // "name" 키로 설정된 값
 * }
 *
 * // sortFunc 예시
 * function sortFunc(sortInfo) {
 *        sortInfo.field; // Sort 필드명
 *        sortInfo.dir;   // Sort Direction(asc/desc)
 * }
 *
 * // 테이블 모드 변경
 * table.changeMode(); 			// list,card 모드 토글
 * table.changeMode('card');	// card 모드
 * table.changeMode('list');	// list 모드
 *
 */
function UiTable(tableId, opts) {
    const GNB_CLASS = "gnb-menu";	// GNB 메뉴 클래스
    const GNB_FULL_WIDTH = 1280;			// GNB 메뉴 전체표시 웹브라우저 너비 기준
    const MOBILE_WIDTH = 768;			// 모바일모드 기준 너비
    const MODE_CARD = "card";
    const MODE_MOBILE = "mobile";
    const MODE_LIST = "list";
    const MODE_TEMP = "temp";

    let $table = $("#" + tableId);
    let $tableBox = $table.parent();

    let lang = (!opts.lang || opts.lang != "en") ? "ko" : opts.lang;
    UiTableComm.lang = lang;

    let height = !opts.height ? "auto" : opts.height;
    let rowHeight = !opts.rowHeight ? "" : opts.rowHeight;
    let sortFunc = !opts.sortFunc ? "" : opts.sortFunc;
    let initialSort = !opts.initialSort ? "" : opts.initialSort;
    let placeholder = !opts.placeholder ? UiTableUtil.getMsg("no_data") : opts.placeholder;
    let tableMode = !opts.tableMode ? MODE_LIST : opts.tableMode;
    let selectRow = !opts.selectRow ? false : opts.selectRow === "checkbox" ? "highlight" : (opts.selectRow === 1 || opts.selectRow === "1") ? 1 : false;
    let selectRowFunc = !opts.selectRowFunc ? "" : opts.selectRowFunc;
    let pageInfo = !opts.pageInfo ? null : opts.pageInfo;
    let pageFunc = !opts.pageFunc ? null : opts.pageFunc;
	let changeFunc = !opts.changeFunc ? null : opts.changeFunc;
    let showTotRecord = opts.showTotRecord == undefined ? true : opts.showTotRecord;
    let showCurrentPage = opts.showCurrentPage == undefined ? true : opts.showCurrentPage;
    let data = !opts.data ? null : opts.data;

    let mobileWidth = window.matchMedia("(max-width: " + MOBILE_WIDTH + "px)");
    let mode = tableMode === MODE_CARD ? tableMode : mobileWidth.matches ? MODE_MOBILE : MODE_LIST;
    let cardForm = $("#" + tableId + "_cardForm").html();
    let enableCard = cardForm ? true : false;
    let columnFormat = {};

    if (selectRow === "highlight") {
        opts.columns.unshift({
            formatter: "rowSelection", titleFormatter: "rowSelection",
            headerHozAlign: "center", hozAlign: "center", vertAlign: "middle", width: 40, minWidth: 40, resizable: false, headerSort: false,
            cellClick: (e, cell) => {
                cell.getRow().toggleSelect()
            }
        });
    }

    for (let col of opts.columns) {
        if (col.headerSort) {
            col.headerClick = (e, column) => {
                const isSortIconClick = e.target.closest(".tabulator-col-sorter, .tabulator-arrow, .tabulator-col-sorter-element");
                if (!isSortIconClick) {
                    return;
                }
                if (uiTable.sortFunc && typeof uiTable.sortFunc === "function") {
                    uiTable.sortFunc({field: column.getField(), dir: uiTable.toggleSortState(column.getField())});
                }
            }
        }

        if (col.formatter) {
            let format = col.formatter;

            if (format === "rowSelection") {
                continue;
            }

            columnFormat[col.field] = format;
            col.formatter = (cell) => {
                return UiTableUtil.getFormat(cell.getValue(), format);
            }
        }
    }

    // Tabulator 생성
    let uiTable = new Tabulator("#" + tableId, {
        data: data,
        height: height,
        layout: "fitColumns",
        columnResizeMode: "overflow",
        selectableRows: selectRow,
        headerSortClickElement: "icon",
        placeholder: placeholder,
        rowHeight: rowHeight,
        headerHeight: rowHeight,
        columnDefaults: {formatter: "html", vertAlign: "middle", headerSort: false},
        columns: opts.columns,
        sortMode: sortFunc ? "remote" : "local",
        initialSort: initialSort,
        pagination: true,
        paginationMode: "remote",
        paginationCounter: function () {
            return "";
        },
        rowFormatter: function (row) {
            if (enableCard) {
                if (uiTable.mode === MODE_MOBILE || uiTable.mode === MODE_CARD) {
                    uiTable.renderCard(row);
                } else {
                    uiTable.renderList(row);
                }
            }
        }
    });

    uiTable.tableId = tableId;
    uiTable.mobileWidth = mobileWidth;
    uiTable.mode = mode;
    uiTable.lang = "ko";
    uiTable.cardForm = cardForm;
    uiTable.enableCard = enableCard;
    uiTable.sortFunc = sortFunc;
    uiTable.pageFunc = pageFunc;
	uiTable.changeFunc = changeFunc;
    uiTable.isParentSet = false;
    uiTable.isRendered = false;
	uiTable.isPaging = false;
    uiTable.selectable = selectRow;
    uiTable.resizeTimer = null;
    uiTable.sortState = {};

    // Row 선택했을때 함수 호출, selectRow:1 인 경우
    if (selectRow === 1 && selectRowFunc && typeof selectRowFunc === "function") {
        uiTable.on("rowSelected", function (row) {
            selectRowFunc(row.getData());
        });
    }

    // 테이블 생성 완료 이벤트
    uiTable.on("tableBuilt", function () {
        if (enableCard) {
            let listBtnArea = $table.prev().find(".list-card-button");
            if (listBtnArea.length > 0) {
                // 리스트/카드 선택 버튼 생성
                let listCardBtn = $(`<button class='btn_list_type${tableMode === MODE_CARD ? " " + MODE_CARD : ""}' type='button' role='button' aria-label='List/Card' title='${UiTableUtil.getMsg("type_btn_title")}'>`
					+ `<i class='${"card" ? "icon-svg-list" : "icon-svg-grid"}' aria-hidden='true'></i></button>`);
                uiTable.listCardBtn = listCardBtn;
                listBtnArea.append(listCardBtn);
                listCardBtn.on('click', function () {
                    uiTable.changeMode();
                });
            }
        }
    });

    // 렌더링 완료 이벤트
    uiTable.on("renderComplete", function () {
        if (enableCard) {
            $table.addClass(this.mode);
            if (this.mode === MODE_MOBILE) {
                $table.removeClass(MODE_CARD);
                $table.removeClass(MODE_LIST);

                if (uiTable.listCardBtn) {
                    uiTable.listCardBtn.hide();
                }
            } else if (this.mode === MODE_CARD) {
                $table.removeClass(MODE_MOBILE);
                $table.removeClass(MODE_LIST);

                if (uiTable.listCardBtn) {
                    uiTable.listCardBtn.show();
                    uiTable.listCardBtn.addClass(MODE_CARD);
					uiTable.listCardBtn.find("i").addClass("icon-svg-list");
					uiTable.listCardBtn.find("i").removeClass("icon-svg-grid");
                }
            } else {
                $table.removeClass(MODE_MOBILE);
                $table.removeClass(MODE_CARD);

                if (uiTable.listCardBtn) {
                    uiTable.listCardBtn.show();
                    uiTable.listCardBtn.removeClass(MODE_CARD);
					uiTable.listCardBtn.find("i").removeClass("icon-svg-list");
					uiTable.listCardBtn.find("i").addClass("icon-svg-grid");
                }
            }
        }

        if (selectRow === "highlight") {
            $table.addClass(selectRow);
        }

        $table.removeClass(MODE_TEMP);
        if (!this.isParentSet) {
            this.setParentWidth(true);
        }

		if (!this.isPaging) {
			$table.addClass("nopage");
		}
		else {
			$table.removeClass("nopage");
		}

        this.isRendered = true;

        // Switch 적용
        UiSwitcher();
    });

    // 리스트 스타일 렌더링
    uiTable.renderList = function (row) {
        let $el = $(row.getElement());
        $el.find(".card-wrapper").remove();

        row.getCells().forEach(cell => {
            $(cell.getElement()).css("display", "");
        });

        $el.css("display", "");

        if (selectRow) {
            $el.addClass("tabulator-selectable");
        }

        if (rowHeight) {
            $el.find(".tabulator-cell").css("line-height", rowHeight + "px");
        }
    }

    // 카드 스타일 렌더링
    uiTable.renderCard = function (row) {
        let data = row.getData();
        let $el = $(row.getElement());

        $el.css("display", "block");
        $el.removeClass("tabulator-selectable");
        $el.removeClass("tabulator-row-even");

        row.getCells().forEach(cell => {
            $(cell.getElement()).css("display", "none");
        });

        let $card = $("<div/>", {class: "card-wrapper"});

        // 카드 폼 데이터 설정
        $card.html(uiTable.cardForm.replace(/#\[(\w+)\]/g, (match, field) => {
            let value = (data[field] ?? "").toString();

            // 포맷 적용
            if (columnFormat[field]) {
                value = UiTableUtil.getFormat(value, columnFormat[field]);
            }

            return value;
        }));

        $el.append($card);
        row.deselect();
    }

    // Sort 상태 변경
    uiTable.toggleSortState = function (field) {
        if (!this.sortState[field]) {
            this.sortState[field] = "asc";
        } else {
            this.sortState[field] = this.sortState[field] === "asc" ? "desc" : "asc";
        }
        return this.sortState[field];
    }

    // 선택된 데이터 반환
    uiTable.getSelectedData = function (field) {
        let data = [];

        for (let row of this.getSelectedRows()) {
            let rowData = row.getData();
            data.push(rowData[field]);
        }

        return data;
    }

    // 페이지 정보 표시
    uiTable.setPageInfo = function (pageInfo) {
        if (uiTable.isRendered) {
            uiTable.drawPageInfo(pageInfo);
        } else {
            const handler = () => {
                this.off("renderComplete", handler);
                setTimeout(() => {
                    uiTable.drawPageInfo(pageInfo);
                }, 100);
            };
            this.on("renderComplete", handler);
        }

		this.isPaging = true;
		$table.removeClass("nopage");
    }

    // 페이지 정보 출력
    uiTable.drawPageInfo = function (pageInfo) {
        let $counter = $table.find(".tabulator-footer .tabulator-footer-contents .tabulator-page-counter");
        let $paginator = $table.find(".tabulator-footer .tabulator-footer-contents .tabulator-paginator");
        let pageNo = pageInfo.currentPageNo;
        let prev = (pageNo > 1) ? pageNo - 1 : 1;
        let next = (pageNo < pageInfo.lastPageNo) ? pageNo + 1 : pageInfo.lastPageNo;
        let firstStatus = pageNo === 1 ? "disabled" : "";
        let prevStatus = pageNo === 1 ? "disabled" : "";
        let nextStatus = pageNo === pageInfo.lastPageNo ? "disabled" : "";
        let lastStatus = pageNo === pageInfo.lastPageNo ? "disabled" : "";
        let counterCnts = "";
        let pageCnts = "";

        if (showTotRecord) {
            counterCnts += `<span class='total_page'>${UiTableUtil.getMsg("tot_count", pageInfo.totalRecordCount)}</span>`;
        }

        if (showCurrentPage) {
            counterCnts += `<span class='${showTotRecord ? "current_page" : "current_page_info"}'>${UiTableUtil.getMsg("cur_page")}`;
            counterCnts += ` <strong>${pageNo}</strong>/${pageInfo.totalPageCount}</span>`;
        }

        pageCnts += `<button class='tabulator-page first' type='button' role='button' aria-label='First Page' title='${UiTableUtil.getMsg("first_page")}' data-page='1' ${firstStatus}><i class='icon-page-first'></i></button>`;
        pageCnts += `<button class='tabulator-page' type='button' role='button' aria-label='Prev Page' title='${UiTableUtil.getMsg("prev_page")}' data-page='${prev}' ${prevStatus}><i class='icon-page-prev'></i></button>`;
        pageCnts += `<span class='tabulator-pages'>`;

        for (let i = pageInfo.firstPageNoOnPageList; i <= pageInfo.lastPageNoOnPageList; i++) {
            pageCnts += `<button class='tabulator-page${i == pageNo ? " active" : ""}' type='button' role='button' aria-label='Page ${i}' title='${UiTableUtil.getMsg("page", i)}' data-page='${i}'>${i}</button>`;
        }

        pageCnts += `</span>`;
        pageCnts += `<button class='tabulator-page' type='button' role='button' aria-label='Next Page' title='${UiTableUtil.getMsg("next_page")}' data-page='${next}' ${nextStatus}><i class='icon-page-next'></i></button>`;
        pageCnts += `<button class='tabulator-page' type='button' role='button' aria-label='Last Page' title='${UiTableUtil.getMsg("last_page")}' data-page='${pageInfo.lastPageNo}' ${lastStatus}><i class='icon-page-last'></i></button>`;

        $counter.html(counterCnts);
        $paginator.html(pageCnts);
        $paginator.find("button").on('click', function () {
            if (uiTable.pageFunc && typeof uiTable.pageFunc === "function") {
                let page = parseInt($(this).attr("data-page"));
                if (pageNo !== page) {
                    uiTable.pageFunc(page);
                }
            }
        });
    }

    // 테이블 부모객체 너비 설정
    uiTable.setParentWidth = function (type) {
        if (type) {
            let tbWidth = $table.width();
            $tableBox.css({"width": tbWidth + "px", "max-width": tbWidth + "px"});
            this.isParentSet = true;
        } else {
            $tableBox.css({"width": "", "max-width": ""});
            this.isParentSet = false;
        }
    }

    // 테이블 모드 변경
    uiTable.changeMode = function (mode) {
        if (uiTable.mode === MODE_MOBILE || uiTable.mode === mode) {
            return;
        }

        uiTable.mode = mode ? mode : uiTable.mode === MODE_CARD ? MODE_LIST : MODE_CARD;
        uiTable.setParentWidth(false);
        $table.addClass(MODE_TEMP);
        uiTable.redraw(true);

		if (uiTable.changeFunc && typeof uiTable.changeFunc === "function") {
			uiTable.changeFunc(uiTable.mode);
		}
    }

    // 리사이즈/미디어쿼리 변화에 반응
    uiTable.applyMode = function () {
        if (uiTable.mode != MODE_CARD) {
            uiTable.mode = uiTable.mobileWidth.matches ? MODE_MOBILE : MODE_LIST;
            uiTable.redraw(true);

            if (uiTable.mode === MODE_LIST) {
                uiTable.setParentWidth(true);
            } else {
                uiTable.setParentWidth(false);
            }
        }
    }

    // 모드 변경 이벤트 리스너
    uiTable.mobileWidth.addEventListener("change", uiTable.applyMode);

    // 리사이즈 이벤트
    window.addEventListener("resize", () => {
        clearTimeout(uiTable.resizeTimer);
        uiTable.resizeTimer = setTimeout(() => {
            uiTable.setParentWidth(false);
            $table.addClass(MODE_TEMP);
            uiTable.redraw(true);

			if (uiTable.changeFunc && typeof uiTable.changeFunc === "function") {
				uiTable.changeFunc(uiTable.mode);
			}
        }, 300);
    });

    // GNB(메뉴)가 있을때 테이블 너비 처리
    const $gnb = $("." + GNB_CLASS);
    if ($gnb.length > 0) {
        const gnbChangeCallback = function (mutationsList) {
            for (let mutation of mutationsList) {
                if (mutation.type === 'attributes' && mutation.attributeName === 'class') {
                    const currentClassList = mutation.target.classList;
                    const oldClassValue = mutation.oldValue || "";
                    const wasOn = oldClassValue.split(' ').includes('expanded');
                    const isOn = currentClassList.contains('expanded');

                    if (window.innerWidth <= GNB_FULL_WIDTH) {
                        return;
                    } else if ((!wasOn && isOn) || (wasOn && !isOn)) {
                        clearTimeout(uiTable.resizeTimer);
                        uiTable.resizeTimer = setTimeout(() => {
                            uiTable.setParentWidth(false);
                            $table.addClass(MODE_TEMP);
                            uiTable.redraw(true);
                        }, 500);
                    }
                }
            }
        };

        const observer = new MutationObserver(gnbChangeCallback);
        observer.observe(document.querySelector('.' + GNB_CLASS), {
                attributes: true,
                attributeFilter: ['class'],
                attributeOldValue: true
            }
        );
    }

    return uiTable;
}


// 테이블 유틸리티
const UiTableUtil = {
    // 칼럼 포맷
    getFormat: function (value, format) {
        // Y/N -> O/X
        if (format === "ynToOx") {
            const v = String(value ?? "").trim().toUpperCase();
            return v === "Y" ? "O" : "X";
        }

        // 날짜 패턴 출력
        if (format === "date" || format === "time" || format === "datetime") {
            let pttn = null;

            if (value.length === 14) {
                pttn = /(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/;
            } else if (value.length === 8) {
                pttn = /(\d{4})(\d{2})(\d{2})/;
                format = "date";
            }

            if (pttn) {
                if (format === "datetime") {
                    value = value.replace(pttn, '$1-$2-$3 $4:$5:$6');
                } else if (format === "date") {
                    value = value.replace(pttn, '$1-$2-$3');
                } else if (format === "time") {
                    value = value.replace(pttn, '$4:$5:$6');
                }
            }
        }

        return value;
    },

    // 메시지
    getMsg: function (key, ...args) {
        let msg = UiTableComm.message[UiTableComm.lang][key];
        msg = msg.replace(/\{(\d+)\}/g, (match, index) => {
            if (index < args.length && args[index] !== undefined && args[index] !== null) {
                return args[index];
            }
            return match;
        });

        return msg;
    }
};


// 테이블 공통
const UiTableComm = {
    lang: "ko",
    message: {
        ko: {
            no_data: "데이터가 없습니다.",
            tot_count: "전체 <b>{0}</b>건",
            page: "{0} 페이지",
            cur_page: "현재 페이지",
            first_page: "처음 페이지",
            prev_page: "이전 페이지",
            next_page: "다음 페이지",
            last_page: "마지막 페이지",
            type_btn_title: "리스트형/카드형 선택",
            list_type: "리스트형",
            card_type: "카드형"
        },
        en: {
            no_data: "There is no data.",
            tot_count: "Total {0} records",
            page: "Page {0}",
            cur_page: "Current Page",
            first_page: "First Page",
            prev_page: "Prev Page",
            next_page: "Next Page",
            last_page: "Last Page",
            type_btn_title: "Select List/Card View",
            list_type: "List View",
            card_type: "Card View"
        },
        ja: {
            no_data: "データがありません。",
            tot_count: "合計{0}件",
            page: "{0} ページ",
            cur_page: "現在のページ",
            first_page: "最初のページ",
            prev_page: "前のページ",
            next_page: "次のページ",
            last_page: "最後のページ",
            type_btn_title: "リスト表示／カード表示の選択",
            list_type: "リスト形式",
            card_type: "カード形式"
        },
        zh: {
            no_data: "没有数据。",
            tot_count: "总计{0}条",
            page: "第{0}页",
            cur_page: "当前页",
            first_page: "第一页",
            prev_page: "上一页",
            next_page: "下一页",
            last_page: "最后一页",
            type_btn_title: "选择列表 / 卡片视图",
            list_type: "列表形式",
            card_type: "卡片形式"
        }
    }
};
