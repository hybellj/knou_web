
/**
 * 탭메뉴
 *
 *
 */
function UiTabMenu(pageTabId, pageFrameId) {
	let tabMenu = {
		pageTabs: $("#"+pageTabId),
        pageFrames: $("#"+pageFrameId),
		menuTabs: [],
		currentMenuId: "",
		scrollAmount: 160,

		// 탭메뉴 추가
		addTabMenu: function(menunm, menuUrl, upMenuId, menuId) {
			menuUrl += (menuUrl.indexOf("?") === -1 ? "?" : "&") + "pageType=iframe";
			let thisObj = this;

			//this.menuTabs.some(item => item.menuId === menuId)

        	if (this.menuTabs.length > 0 && this.menuTabs.some(item => item.menuId === menuId)) {
				if (this.currentMenuId !== "" && this.currentMenuId !== menuId) {
					$("#TAB_"+this.currentMenuId).removeClass("select");
					$("#FRAME_"+this.currentMenuId).hide();
				}

				$("#TAB_"+menuId).addClass("select");
				$("#FRAME_"+menuId).show();
				this.currentMenuId = menuId;

				return;
        	}

        	if (this.currentMenuId != "") {
        		$("#TAB_"+this.currentMenuId).removeClass("select");
				$("#FRAME_"+this.currentMenuId).hide();
        	}

        	let tab = $(`<li id="TAB_${menuId}" class="select">`
        		+ `<div class="tabmenu">`
        		+ `<a href="#0" class="tabname" menuId="${menuId}" title="${menunm}">${menunm}</a>`
        		+ `<button type="button" class="close" menuId="${menuId}"><i class="xi-close"></i></button>`
        		+ `</div>`
        		+ `</li>`);

        	this.pageTabs.append(tab);

        	let height = $(document.body).height() - 400;
        	let iframe = `<iframe id="FRAME_${menuId}" frameborder="0" scrolling="auto" src="${menuUrl}" style="border:0;width:100%;height:${height}px;"></iframe>`;
        	this.pageFrames.append(iframe);

        	let $frame = $("#FRAME_"+menuId);
			if ($frame.length) {
				$frame.on("load", function() {
					let timer = null;
					let frameBody = this.contentWindow.document.body;
					let updateHeight = () => {
						clearTimeout(timer);
						timer = setTimeout(() => {
							let newHeight = $(frameBody).outerHeight(true);
			                if (Math.abs($frame.height() - newHeight) > 5) {
			                    $frame.css("height", newHeight + "px");
			                }
			            }, 200);
					};

					updateHeight();

					let observer = new MutationObserver(updateHeight);
					observer.observe(frameBody, {childList: true, subtree: true, attributes: false});
				});

				/*
				$frame.on("load", function() {
			        let frameBody = this.contentWindow.document.body;
			        let timer = null;
			        let updateHeight = () => {
						console.log("---->"+(cnt++));
			            clearTimeout(timer);
			            timer = setTimeout(() => {
			                let newHeight = frameBody.scrollHeight;
							console.log(newHeight+" -----> "+(cnt++));
			                if (Math.abs($frame.height() - newHeight) > 5) {
			                    $frame.css("height", newHeight + "px");
			                }
			            }, 200);
			        };

			        let observer = new MutationObserver(updateHeight);
			        observer.observe(frameBody, { childList: true, subtree: true });
			    });
				*/
			}

			this.menuTabs.push({menuId:menuId, upMenuId:upMenuId});
			this.currentMenuId = menuId;

        	tab.find("button.close").on('click', function () {
				let tabMenuId = $(this).attr("menuId");
				thisObj.closeTabMenu(tabMenuId);
        	});

        	tab.find("a.tabname").on('click', function () {
				let tabMenuId = $(this).attr("menuId");
				thisObj.onTabMenu(tabMenuId);
        	});

			this.scrollLast();
			setTimeout(() => {
				this.scrollLast();
			},1000);
		},

		// 탭메뉴 닫기
		closeTabMenu: function(menuId) {
			this.menuTabs = this.menuTabs.filter(item => item.menuId !== menuId);

			if (this.menuTabs.length == 0) {
				this.closeAllMenu();
			}
			else {
				$("#TAB_"+menuId).remove();
				$("#FRAME_"+menuId).remove();

				if (this.currentMenuId === menuId) {
					let tabData = this.menuTabs.at(-1);
					let lastMenuId = tabData ? tabData.menuId : "";
					let lastUpMenuId = tabData ? tabData.upMenuId : "";

					$("#TAB_"+lastMenuId).addClass("select");
					$("#FRAME_"+lastMenuId).show();

					this.currentMenuId = lastMenuId;
					this.scrollLast();

					this.resetMenuStatus(lastMenuId);
				}
			}
		},

		// 탭메뉴 On
		onTabMenu: function(menuId) {
			if (this.currentMenuId != "") {
        		$("#TAB_"+this.currentMenuId).removeClass("select");
				$("#FRAME_"+this.currentMenuId).hide();
        	}

			$("#TAB_"+menuId).addClass("select");
			$("#FRAME_"+menuId).show();
			this.currentMenuId = menuId;

			this.resetMenuStatus(menuId);
		},

		// 모든메뉴 닫기
		closeAllMenu: function() {
			document.location.href = "/";
		},

		// 왼쪽으로 스크롤
		scrollLeft: function() {
			this.pageTabs.animate({
	            scrollLeft: this.pageTabs.scrollLeft() - this.scrollAmount
	        }, 200);
		},

		// 오른쪽으로 스크롤
		scrollRight: function() {
			this.pageTabs.animate({
	            scrollLeft: this.pageTabs.scrollLeft() + this.scrollAmount
	        }, 200);
		},

		// 마지막으로 스크롤
		scrollLast: function() {
			let fullWidth = this.pageTabs.prop('scrollWidth');

			this.pageTabs.animate({
	            scrollLeft: fullWidth
	        }, 200);
		},

		// 메뉴상태 재설정
		resetMenuStatus: function(menuId) {
			$("nav.gnb .gnb-item").removeClass("open");
			$("nav.gnb .gnb-item a").removeClass("current");
			$("nav.gnb .gnb-item ul").hide();

			let tabData = this.menuTabs.find(item => item.menuId === menuId);
			if (tabData) {
				let upMenuId = tabData.upMenuId;

				if (upMenuId === "ROOT") {
					$("#MENU_"+menuId).addClass("current");
				}
				else {
					$("#SUB_"+upMenuId).show();
					$("#SUBMENU_"+menuId).addClass("current");
				}
			}
		}
	};

	return tabMenu;
}