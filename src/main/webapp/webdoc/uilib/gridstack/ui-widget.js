/**
 * 위젯 생성
 *
 * // 위젯 초기화
 * let widget = UiWidget({
 *        targetId:   "target",	// 위젯을 생성할 대상 객체 ID
 *        changeFunc: func		// 위젯을 변경할때 실행할 함수
 * });
 *
 * // 위젯 생성
 * widget.addWidget(id, title, opts, content);
 * 	 id:		// 위젯 ID
 * 	 title:		// 타이틀
 *   opts:		// 옵션
 *   content:	// 내용
 *
 * // 위젯 내용 추가 (위젯 생성후 내용을 넣거나 변경할 경우)
 * widget.addContent(id, content);
 *   id:		// 위젯 ID
 *   content:	// 내용
 *
 * // 위젯 내용 URL 로드
 * widget.loadUrl(id, url);
 *   id:		// 위젯 ID
 *   url:		// URL
 */
function UiWidget(opts) {
	let targetId = opts.targetId;
	if (targetId === undefined || $("#"+targetId).length === 0) {
		console.log("UiWidget: targetId is not defined.");
		return { addWidget: function() {}, addContent: function() {} };
	}

	$("#"+targetId).addClass("grid-stack");

	let isChanageOn = true;

	// 기본 칼럼 옵션 (화면 너비별 칼럼수 지정)
	let colOpts = {breakpoints: [
		{ w: 1200, c: 12 },
		{ w: 950,  c: 8  },
		{ w: 600,  c: 4  },
		{ w: 0,    c: 1  }
	]};

	// GridStack 초기화
	let widget = GridStack.init({
		handle: '.m_handle',
		column: 12,
		cellHeight: 67,
		float: false,
		resizable: { handles: 'se' },
		columnOpts: colOpts,
		selector: "#"+targetId
	});

	// 위젯 변경 이벤트
	widget.on('change', function(event, items) {
		widget.compact();

		for (let i=0; i<items.length; i++) {
			let item = items[i];
			if (item.w !== undefined && item.w !== item.posW) item.posW = item.w;
			if (item.h !== undefined && item.h !== item.posH) item.posH = item.h;
		}

		if (opts.changeFunc !== undefined && typeof opts.changeFunc === "function" && isChangeOn) {
			let allItems = widget.save();

			for (let i=0; i<allItems.length; i++) {
				let item = allItems[i];
				if (item.w === undefined) item.w = item.posW;
				if (item.h === undefined) item.h = item.posH;
				if (item.minW === undefined) item.minW = 4;
				if (item.minH === undefined) item.minH = 4;
				if (item.maxW === undefined) item.maxW = 12;
				if (item.maxH === undefined) item.maxH = 12;
			}

			opts.changeFunc(allItems);
		}
	});

	let widgetObj = {
		widget: widget,

		// 새 위젯 생성
		addWidget: function(id, title, opts, content) {
			isChangeOn = false;

			// 위젯 기본 내용
			let widgetContent = `<div id="${id}" class="box">`
				+ `<div id="${id}_title" class="box_title">`
				+ `<i class="xi-arrows m_handle" aria-label="Widget move" role="button" tabindex="0" aria-grabbed="false"></i>`
				+ `<h3 class="h3 title">${title}</h3>`
				+ `</div>`
				+ `<div id="${id}_content" class="box-content">`
				+ `</div>`
				+ `<div id="${id}_loading" class="loading-layer"><i class="xi-spinner-5 xi-spin"></i></div>`
				+ `</div>`;

			let el = document.createElement("div");
		 	el.innerHTML = widgetContent;

			opts["widgetId"] = id;
			opts["widgetNm"] = title;
			opts["posW"] = opts.w;
			opts["posH"] = opts.h;
		 	widget.makeWidget(el, opts);

			if (content) {
				this.addContent(id, content);
				$("#"+id+"_loading").hide();
			}

			setTimeout(function() {
				isChangeOn = true;
			}, 1000);
		},

		// 위젯 내용 추가
		addContent: function(id, content) {
			$("#"+id+"_content").html(content);
		},

		// 위젯 내용 로드 (url)
		loadUrl: function(id, url) {
			let obj = this;
			obj.showLoading(id, true);

			let contentBox = $("#"+id+"_content");
			$("#"+id+"_content").load(url, function() {
				obj.showLoading(id, false);
			});
		},

		// 위젯 타이틀 서브 내용 추가
		addSubTitle: function(id, content) {
			if (content != "") {
				$("#"+id+"_title").append(content);
			}
		},

		// 위젯 타이틀 텍스트 내용
		addInTitle: function(id, content) {
			if (content != "") {
				$("#"+id+"_title").children(".title").append(content);
			}
		},

		// 모두 삭제
		removeAll: function() {
			widget.removeAll();
		},

		// 로딩 표시
		showLoading: function(id, type) {
			let $loading = $("#"+id+"_loading");
			if (type) {
				let $boxContent = $("#"+id+"_content");
				let pos = $boxContent.position();
				let w = $boxContent.width();
				let h = $boxContent.height();
				$loading.css({"display":"flex", "top":pos.top+"px", "left":pos.left+"px", "width":w+"px", "height":h+"px"});
			}
			else {
				$loading.hide();
			}
		}
	};

	return widgetObj;
}