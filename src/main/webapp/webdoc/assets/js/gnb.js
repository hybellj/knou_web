/********** gnb asideMenu **********/
$(function () {

	if (document.querySelector("#gnb")) {

		const $gnb = $("#gnb");
		let lastOpenMenus = []; // 메뉴 접기 전에 열린 메뉴 저장용

		// 초기 확장 상태 설정
		if (window.innerWidth >= 1280)
			$gnb.addClass("expanded");
		else
			$gnb.removeClass("expanded");

		// JS 준비 완료 후 표시 (깜빡임 방지)
		$gnb.css("visibility", "visible");

		/********** 메뉴 접기 버튼 **********/
		$(".ctrl-gnb").on("click", function (e) {
			e.stopPropagation();

			const isExpanded = $gnb.hasClass("expanded");

			if (isExpanded) {
				// 접기 전 열린 메뉴 기억
				lastOpenMenus = [];
				$(".gnb .gnb-item.open").each(function () {
					const index = $(".gnb .gnb-item").index(this);
					lastOpenMenus.push(index);
				});

				// 메뉴 닫기
				$(".gnb .gnb-item").removeClass("open").children("ul").slideUp(300);
				$gnb.removeClass("expanded");
			} else {
				// 다시 열릴 때, 저장된 메뉴 복원
				$gnb.addClass("expanded");
				lastOpenMenus.forEach(idx => {
					const $item = $(".gnb .gnb-item").eq(idx);
					$item.addClass("open");
					$item.children("ul").stop(true, true).slideDown(300);
				});
			}
		});

		/********** GNB 클릭 시 확장 **********/
		$gnb.on("click", function (e) {
			if (!$(this).hasClass("expanded")) {
				e.preventDefault();
				e.stopPropagation();
				$(this).addClass("expanded");
			}
		});

		/********** 반응형 처리 **********/
		window.addEventListener("resize", resize());
		function resize() {
			let timer;
			return function () {
				clearTimeout(timer);
				timer = setTimeout(() => {
					if (window.innerWidth >= 1280) {
						$gnb.addClass("expanded");
					} else {
						// 창 크기가 1280px 미만일 때 열린 하위 메뉴 닫기
						$gnb.removeClass("expanded");
						$(".gnb .gnb-item").removeClass("open").children("ul").slideUp(300);
						lastOpenMenus = []; // 저장된 열린 상태도 초기화
					}
				}, 200);
			};
		}
	}

	/********** 모든 하위메뉴 슬라이드 토글 + current 처리 **********/
	$(".gnb .gnb-item > a").on("click", function (e) {
		const $parent = $(this).parent();
		const $submenu = $parent.children("ul");

		// current 처리
		$(".gnb a").removeClass("current");
		$(this).addClass("current");

		if ($submenu.length > 0) {
			e.preventDefault();

			// 다른 열린 메뉴 닫기
			$(".gnb .gnb-item").not($parent).removeClass("open").children("ul").slideUp(300);

			// 현재 메뉴 열기/닫기
			$parent.toggleClass("open");
			$submenu.stop(true, true).slideToggle(300);

			// 서브메뉴 보이도록 스크롤
			$scrollarea = $parent.parent().parent();
			if ($scrollarea.hasClass("scrollarea")) {
				setTimeout(function(){
					if (($parent.position().top + $parent.height())  > $scrollarea.height()) {
						$scrollarea.animate({ scrollTop: $scrollarea.scrollTop() + $submenu.height() }, 200);
					}
				},400);
			}
		} else {
			// 하위 메뉴 없는 메뉴 클릭 시 모든 하위 메뉴 닫기
			$(".gnb .gnb-item").removeClass("open").children("ul").slideUp(300);
		}
	});

	/********** 하위 메뉴 클릭 시 current 처리 **********/
	$(".gnb .gnb-item ul li a").on("click", function () {
		$(".gnb a").removeClass("current");
		$(this).addClass("current");
		$(this).closest(".gnb-item").addClass("open");
	});



    /********** 대시보드 접속현황 **********/
	document.querySelectorAll(".sec_item_tit > .btn").forEach(c => {
		c.addEventListener("click", e => {
			e.preventDefault();
			c.classList.toggle("expanded");

			let next = c.nextElementSibling;
			if (next) {
				let btnClose = next.querySelector(".btn-close");
				if (btnClose) {
					btnClose.addEventListener("click", e => c.classList.toggle("expanded"), { once: true });
				}
			}
		});
	});





	/********** gnb asideMenu - classroom **********/
	if (document.querySelector("#gnb_class")) {

		const $gnb = $("#gnb_class");
		let lastOpenMenus = []; // 메뉴 접기 전에 열린 메뉴 저장용

		// 초기 확장 상태 설정
		if (window.innerWidth >= 1280)
			$gnb.addClass("expanded");
		else
			$gnb.removeClass("expanded");

		// JS 준비 완료 후 표시 (깜빡임 방지)
		$gnb.css("visibility", "visible");


		/********** 메뉴 접기 버튼 **********/
		$(".ctrl-gnb").on("click", function (e) {
			e.stopPropagation();

			const isExpanded = $gnb.hasClass("expanded");

			if (isExpanded) {
				// 접기 전 열린 메뉴 기억
				lastOpenMenus = [];
				$(".gnb_class .gnb-item.open").each(function () {
					const index = $(".gnb_class .gnb-item").index(this);
					lastOpenMenus.push(index);
				});

				// 메뉴 닫기
				$(".gnb_class .gnb-item").removeClass("open").children("ul").slideUp(300);
				$gnb.removeClass("expanded");
			} else {
				// 다시 열릴 때, 저장된 메뉴 복원
				$gnb.addClass("expanded");
				lastOpenMenus.forEach(idx => {
					const $item = $(".gnb_class .gnb-item").eq(idx);
					$item.addClass("open");
					$item.children("ul").stop(true, true).slideDown(300);
				});
			}
		});

		/********** GNB 클릭 시 확장 **********/
		$gnb.on("click", function (e) {
			if (!$(this).hasClass("expanded")) {
				e.preventDefault();
				e.stopPropagation();
				$(this).addClass("expanded");
			}
		});

		/********** 반응형 처리 **********/
		window.addEventListener("resize", resize());
		function resize() {
			let timer;
			return function () {
				clearTimeout(timer);
				timer = setTimeout(() => {
					if (window.innerWidth >= 1280) {
						$gnb.addClass("expanded");
					} else {
						// 창 크기가 1280px 미만일 때 열린 하위 메뉴 닫기
						$gnb.removeClass("expanded");
						$(".gnb_class .gnb-item").removeClass("open").children("ul").slideUp(300);
						lastOpenMenus = []; // 저장된 열린 상태도 초기화
					}
				}, 200);
			};
		}
	}

	/********** 모든 하위메뉴 슬라이드 토글 + current 처리 **********/
	$(".gnb_class .gnb-item > a").on("click", function (e) {
		const $parent = $(this).parent();
		const $submenu = $parent.children("ul");

		// current 처리
		$(".gnb_class a").removeClass("current");
		$(this).addClass("current");

		if ($submenu.length > 0) {
			e.preventDefault();

			// 다른 열린 메뉴 닫기
			$(".gnb_class .gnb-item").not($parent).removeClass("open").children("ul").slideUp(300);

			// 현재 메뉴 열기/닫기
			$parent.toggleClass("open");
			$submenu.stop(true, true).slideToggle(300);

			// 서브메뉴 보이도록 스크롤
			$scrollarea = $parent.parent().parent();
			if ($scrollarea.hasClass("scrollarea")) {
				setTimeout(function(){
					if (($parent.position().top + $parent.height())  > $scrollarea.height()) {
						$scrollarea.animate({ scrollTop: $scrollarea.scrollTop() + $submenu.height() }, 200);
					}
				},400);
			}

		} else {
			// 하위 메뉴 없는 메뉴 클릭 시 모든 하위 메뉴 닫기
			$(".gnb_class .gnb-item").removeClass("open").children("ul").slideUp(300);
		}
	});

	/********** 하위 메뉴 클릭 시 current 처리 **********/
	$(".gnb_class .gnb-item ul li a").on("click", function () {
		$(".gnb_class a").removeClass("current");
		$(this).addClass("current");
		$(this).closest(".gnb-item").addClass("open");
	});




	/********** 접속현황 레이어 **********/
	document.querySelectorAll(".item.user > .item_tit > .btn").forEach(b => {
		b.addEventListener("click", e => {
			e.preventDefault();
			b.classList.toggle("expanded");

			let next = b.nextElementSibling;
			if (next) {
				let btnClose = next.querySelector(".btn-close");
				if (btnClose) {
					btnClose.addEventListener("click", e => b.classList.toggle("expanded"), { once: true });
				}
			}
		});
	});


	/********** accordion **********/
	document.querySelectorAll('.accordion .title-wrap .title').forEach(title => {
		title.addEventListener('click', e => {
			e.preventDefault();  // 기본 동작 방지

			const li = title.closest('li');  // 클릭한 .title의 부모 <li> 찾기
			const content = li.querySelector('.cont');  // 해당 .cont 요소 찾기

			// <li>에 'active' 클래스를 토글하여 아코디언 항목 열기/닫기
			li.classList.toggle('active');

			// 아코디언 내용의 높이를 부드럽게 열기/닫기
			if (li.classList.contains('active')) {
				content.style.height = content.scrollHeight + 'px';  // 컨텐츠의 실제 높이로 설정
			} else {
				content.style.height = 0;  // 닫을 때 높이를 0으로 설정
			}
		});
	});



	/********** dropdown 주차관리 **********/
	const toggleButtons = document.querySelectorAll('.settingBtn');
		toggleButtons.forEach(btn => {
		btn.addEventListener('click', (e) => {
			e.stopPropagation();

			const dropdown = btn.closest('.dropdown');
			const menu = dropdown.querySelector('.optionWrap');

			// 다른 메뉴 닫기
			document.querySelectorAll('.optionWrap.show').forEach(openMenu => {
			if (openMenu !== menu) {
				openMenu.classList.remove('show');
			}
			});

			// 현재 메뉴 토글
			menu.classList.toggle('show');
		});
		});

		// 외부 클릭 시 닫기
		document.addEventListener('click', () => {
		document.querySelectorAll('.optionWrap.show').forEach(menu => {
			menu.classList.remove('show');
		});
	});


	/********** tab-btn **********/
	$('.tab_btn a').on('click', function(e) {
		e.preventDefault();

		const $tabBtn = $(this).closest('.tab_btn');

		// 현재 탭 그룹에서만 current 처리
		$tabBtn.find('a').removeClass('current');
		$(this).addClass('current');

		// 연결된 콘텐츠 처리
		let target = $(this).attr('href');

		// 현재 탭 그룹과 연결된 콘텐츠만 제어 (선택)
		$(target).siblings('.tab-content').hide();
		$(target).show();
	});


	if( document.querySelector('.tab-type1') ){
		document.querySelectorAll(".tab-type1").forEach( tab => {

			tab.addEventListener("click", e => {
				e.preventDefault();
				e.stopImmediatePropagation();

				let a = e.target.closest("a");
				if( !a ) return;

				let cc = null;
				if( a.hash.indexOf("#") > -1 ) cc = document.querySelector(a.hash);

				e.currentTarget.querySelectorAll("a").forEach( elem => {
					elem.classList.remove("current");

					if( elem.hash.indexOf("#") > -1 ){
						document.querySelector(elem.hash) ? document.querySelector(elem.hash).style.display = "none" : '';
					}
				} );
				a.classList.add("current");
				cc ? cc.style.display = "block" : '';
			});
		});
	}

	if( document.querySelector('.tab-type2') ){
		document.querySelectorAll(".tab-type1").forEach( tab => {

			tab.addEventListener("click", e => {
				e.preventDefault();
				e.stopImmediatePropagation();

				let a = e.target.closest("a");
				if( !a ) return;

				let cc = null;
				if( a.hash.indexOf("#") > -1 ) cc = document.querySelector(a.hash);

				e.currentTarget.querySelectorAll("a").forEach( elem => {
					elem.classList.remove("current");

					if( elem.hash.indexOf("#") > -1 ){
						document.querySelector(elem.hash) ? document.querySelector(elem.hash).style.display = "none" : '';
					}
				} );
				a.classList.add("current");
				cc ? cc.style.display = "block" : '';
			});
		});
	}

	/********** 테마 설정 (라디오 버튼) + 다크모드 우선 **********/
	(function () {
		const themeClasses = ["colorA", "colorB", "colorC", "colorD", "colorE"];
		// 라디오 id → 테마 클래스 매핑 (value 속성이 없으므로 id로 판별)
		const idMap = {
			"wcolor":  "",        // 기본 (클래스 없음)
			"wcolorA": "colorA",  // 블루
			"wcolorB": "colorB",  // 민트
			"wcolorC": "colorC",  // 오렌지
			"wcolorD": "colorD",  // 레드
			"wcolorE": "colorE"   // 퍼플
		};

		// 현재 선택된 테마 보관 (다크모드와 무관). 초기값은 body 기존 클래스에서 추출
		let selectedTheme = "";
		themeClasses.forEach(function (c) {
			if (document.body.classList.contains(c)) selectedTheme = c;
		});

		// 실제 적용할 테마 = 다크모드면 "" (다크모드 우선), 아니면 selectedTheme
		function applyTheme() {
			const $body = $("body");
			const applied = $body.hasClass("darkmode") ? "" : selectedTheme;

			// 중복 방지: 테마 클래스 모두 제거 후(gnbon 등 다른 클래스는 보존) 하나만 적용
			$body.removeClass(themeClasses.join(" "));
			if (applied) $body.addClass(applied);

			// 열려있는 모달 iframe body에도 동기화
			$("iframe").each(function () {
				try {
					const iframeBody = $(this.contentDocument || this.contentWindow.document).find("body");
					if (iframeBody.length) {
						iframeBody.removeClass(themeClasses.join(" "));
						if (applied) iframeBody.addClass(applied);
					}
				} catch (err) { /* cross-origin iframe 무시 */ }
			});
		}

		// 컬러 라디오 변경(클릭) 시
		$(document).on("change", ".widget_set_group .custom-input input[type='radio']", function () {
			selectedTheme = idMap[this.id] || "";
			applyTheme();
		});

		// 외부에서 다크모드 토글(body.darkmode 변경) 시 → 컬러 제거/복원
		if (window.MutationObserver) {
			let darkWas = document.body.classList.contains("darkmode");
			new MutationObserver(function () {
				const darkNow = document.body.classList.contains("darkmode");
				if (darkNow !== darkWas) {
					darkWas = darkNow;
					applyTheme();
				}
			}).observe(document.body, { attributes: true, attributeFilter: ["class"] });
		}

		// 초기 상태 반영 (다크모드면 컬러 제거)
		applyTheme();
	})();

	// 관리자 메뉴 이벤트 처리
	procAdminMenuEvent();
});


/*
document.addEventListener("DOMContentLoaded", () => {

  // LNB 함수
  function slideDown(ul) {
    ul.classList.add("open");
    ul.style.height = ul.scrollHeight + "px";

    ul.addEventListener("transitionend", function handler() {
      ul.style.height = "auto";
      ul.removeEventListener("transitionend", handler);
    });
  }

  function slideUp(ul) {
    ul.style.height = ul.scrollHeight + "px";
    requestAnimationFrame(() => {
      ul.style.height = "0px";
      ul.classList.remove("open");
    });
  }

  function closeMenu(li) {
    const ul = li.querySelector(":scope > ul");
    const icon = li.querySelector(":scope > a i");

    if (ul && ul.classList.contains("open")) slideUp(ul);
    li.classList.remove("on");
    if (icon) icon.style.transform = "rotate(0deg)";
  }

  function openMenu(li) {
    const ul = li.querySelector(":scope > ul");
    const icon = li.querySelector(":scope > a i");

    if (ul && !ul.classList.contains("open")) slideDown(ul);
    li.classList.add("on");
    if (icon) icon.style.transform = "rotate(90deg)";
  }

  // 같은 레벨의 다른 메뉴 닫기
  function closeSiblings(li) {
    const siblings = [...li.parentElement.children]
      .filter(s => s !== li && s.classList.contains("has-sub"));

    siblings.forEach(closeMenu);
  }

  // 토글 + 레벨별 하나만 열기
  function toggleMenu(li) {
    const isOpen = li.classList.contains("on");

    if (isOpen) {
      closeMenu(li);
    } else {
      closeSiblings(li);
      openMenu(li);
    }
  }

  document.querySelectorAll(".navList li.has-sub").forEach(li => {
    const link = li.querySelector(":scope > a");
    const sub = li.querySelector(":scope > ul");

    if (sub && !link.querySelector("i")) {
      const icon = document.createElement("i");
      icon.className = "icon-svg-arrow";
      link.appendChild(icon);
    }
  });

  // 메뉴 클릭 이벤트
  document.querySelectorAll(".navList li.has-sub > a").forEach(a => {
    a.addEventListener("click", e => {
      e.preventDefault();

      const li = a.parentElement;
      toggleMenu(li);
    });
  });

  // 하위 메뉴 active 처리
  document.querySelectorAll(".navList li ul li > a").forEach(a => {
    a.addEventListener("click", e => {
      e.stopPropagation();

      const ul = a.closest("ul");
      ul.querySelectorAll("li").forEach(li => li.classList.remove("active"));

      a.parentElement.classList.add("active");
    });
  });

});
*/
/*
// 메뉴 접기 / 펼치기 기능
document.addEventListener("DOMContentLoaded", () => {

	const menu = document.querySelector("aside.menu");
	const toggleBtn = document.querySelector(".ctrl-lnb");

	if (menu && toggleBtn) {
	  toggleBtn.addEventListener("click", () => {
	    const isCollapsed = menu.classList.toggle("collapsed");

	    if (isCollapsed) {
	      document.querySelectorAll(".navList li.has-sub").forEach(li => {
	        li.classList.remove("on");
	        const ul = li.querySelector(":scope > ul");
	        if (ul) {
	          ul.classList.remove("open");
	          //ul.style.height = "0px";
	        }
	      });
		  menu.classList.remove("expanded");
	    }
		else {
			menu.classList.add("expanded");
		}
	  });
	}

});
*/

// 관리자 메뉴 이벤트 처리
function procAdminMenuEvent() {
    const asideMenu = $("aside.menu");
    const toggleBtn = asideMenu.find("button.ctrl-lnb");
    const navList = $(".navList");

    // [1] 메뉴 접기 / 펼치기 기능 (기존 유지)
    if (asideMenu.length > 0 && toggleBtn.length > 0 && toggleBtn.attr("init") != "true") {
        toggleBtn.on("click", function(){
            if (asideMenu.hasClass("collapsed")) {
                asideMenu.removeClass("collapsed");
            } else {
                asideMenu.addClass("collapsed");
            }
        });
        toggleBtn.attr("init", "true");
    }

    if (navList.length > 0) {
        // [2] 서브메뉴가 있는 항목(li.has-sub)에 화살표 아이콘 중복 방지 추가
        navList.find("li.has-sub").each(function (index, menu) {
            const link = $(menu).children("a");
            const sub = $(menu).children("ul");
            if (link.length > 0 && sub.length > 0 && link.find(".icon-svg-arrow").length === 0) {
                link.append("<i class='icon-svg-arrow'></i>");
            }
        });

        // [3] 대메뉴/중메뉴(li.has-sub > a) 클릭 시 단순 아코디언 토글 기능
        navList.find("li.has-sub > a").off("click").on("click", function(e) {
            // 진짜 이동 링크(adminMoveMenu)가 걸려있는 경우는 무시
            if ($(this).attr("onclick") && $(this).attr("onclick").indexOf("adminMoveMenu") > -1) {
                return;
            }

            let par = $(this).parent(); // 클릭한 a의 부모 li
            let sub = $(this).next("ul"); // 하위 ul (sub 또는 sub_depth)

            if (sub.length > 0) {
                if (sub.hasClass("open")) {
                    sub.removeClass("open");
                    par.removeClass("on active");
                    $(this).find(".icon-svg-arrow").css('transform', 'rotate(0deg)');
                } else {
                    sub.addClass("open");
                    par.addClass("on active");
                    $(this).find(".icon-svg-arrow").css('transform', 'rotate(90deg)');
                }
            }

            // 형제 노드들 닫기 처리
            par.siblings().removeClass("on active");
            par.siblings().find(".on").removeClass("on");
            par.siblings().find(".active").removeClass("active");
            par.siblings().find(".open").removeClass("open");
            par.siblings().find("i").css('transform', 'rotate(0deg)');

            if ($(window).scrollTop() > 100) {
                this.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
        });

        // [4] ★ 핵심: 최하위 sub1, sub2, sub3 진짜 이동 메뉴 클릭 시 전체 트리 활성화 ★
        navList.find("a[onclick*='adminMoveMenu']").off("click").on("click", function() {
            // 1. 좌측 메뉴 전체에서 활성화 클래스 리셋
            navList.find("li").removeClass("on active");
            navList.find("a").removeClass("on active");
            navList.find("ul.sub, ul.sub_depth").removeClass("open");
            navList.find(".icon-svg-arrow").css('transform', 'rotate(0deg)');

            // 2. 현재 선택한 메뉴 활성화
            $(this).addClass("on active");
            $(this).closest("li").addClass("on active");

            // 3. 상위 부모 역추적하며 모든 sub1, sub2, sub3 라인 다 열기
            // 현재 메뉴의 조상들 중 li.has-sub와 하위 메뉴목록 ul을 전부 찾아 처리합니다.
            let parentsLi = $(this).parents("li.has-sub");
            let parentsUl = $(this).parents("ul.sub, ul.sub_depth");

            // 부모 li, ul들에 활성화 클래스 추가
            parentsLi.addClass("on active");
            parentsUl.addClass("open");

            // 활성화된 부모들의 화살표 아이콘 돌려놓기
            parentsLi.children("a").find(".icon-svg-arrow").css('transform', 'rotate(90deg)');
        });
    }
}

// 관리자 메뉴 이벤트 처리
/*function procAdminMenuEvent() {
	const asideMenu = $("aside.menu");
	const toggleBtn = asideMenu.find("button.ctrl-lnb");
	const navList = $(".navList");

	// 메뉴 접기 / 펼치기 기능
	if (asideMenu.length > 0 && toggleBtn.length > 0 && toggleBtn.attr("init") != "true") {
		toggleBtn.on("click", function(){
			if (asideMenu.hasClass("collapsed")) {
				asideMenu.removeClass("collapsed");
			}
			else {
				asideMenu.addClass("collapsed");
			}
		});

		toggleBtn.attr("init", "true");
	}


	if (navList.length > 0) {
		// 서브메뉴 아이콘 표시
		const nav = navList.find("li.has-sub");
		nav.each(function (index, menu) {
			const link = $(menu).children("a");
			const sub = $(menu).children("ul");

			if (link.length > 0 && sub.length > 0) {
				link.append("<i class='icon-svg-arrow'></i>");
			}
		});

		// 서브메뉴 펼치기
		navList.find("li.has-sub > a").on("click", function() {
			let par = $(this).parent();
			par.addClass("on active");

			let sub = $(this).next("ul");
			if (sub.length > 0) {
				if (sub.hasClass("open")) {
					sub.removeClass("open");
					par.removeClass("on active");
					$(this).find(".icon-svg-arrow").css('transform', 'rotate(0deg)');
				}
				else {
					sub.addClass("open");
					$(this).find(".icon-svg-arrow").css('transform', 'rotate(90deg)');
				}
			}

			par.siblings().removeClass("on");
			par.siblings().removeClass("active");
			par.siblings().find(".on").removeClass("on");
			par.siblings().find(".active").removeClass("active");
			par.siblings().find(".open").removeClass("open");
			par.siblings().find("i").css('transform', 'rotate(0deg)');

			if ($(window).scrollTop() > 100) {
				this.scrollIntoView({ behavior: 'smooth', block: 'center' });
			}
		});
	}
}*/

// 메뉴 이동
function moveMenu(obj, menuUrl, upMenuId, menuId, menunm, linkTargetTycd, extraParam) {
    console.log("assets/js/gnb.js>>>>>>>>>>>>>>>>> moveMenu");
    //alert("assets/js/gnb.js>>>>>>>>>>>>>>>>> moveMenu");
    if (menuUrl === null || menuUrl === 'null' || menuUrl === '') {
        return;
    }

    //alert('1');

    let $moveForm = $("#moveForm");
    if ($moveForm.length === 0) {
        let form = `
            <form id="moveForm" method="post">
                <input name="encParams" type="hidden" value="">
                <input name="addParams" type="hidden" value="">
                <input name="menunm"    type="hidden" value="">
                <input name="menuUrl"   type="hidden" value="">
                <input name="upMenuId"  type="hidden" value="">
                <input name="menuId"    type="hidden" value="">
            </form>
        `;
        $("body").append(form);
        $moveForm = $("#moveForm");
    }

    //alert('2');

    if (obj !== null && menunm === "") {
        if (!menunm) {
            menunm = $(obj).children("span").html();
        }
    }
    //alert('3');

    // 기본 파라미터
    let addParamObj = {
        upMenuId : upMenuId,
        menuId : menuId,
        menuTarget : linkTargetTycd
    };

    //alert('4');

    //alert('gnb.js>extraParam=' + extraParam);

    // 추가 파라미터 병합
    if (extraParam) {
        $.extend(addParamObj, extraParam);
    }
    //alert('5');

    //$("#moveForm input[name=addParams]").val(
    //    UiComm.makeEncParams(addParamObj)
    //);

	// menuUrl에 encParams값이 있는 경우
	let tmpUrl = new URL(menuUrl, 'http://localhost');
	let encParams = tmpUrl.searchParams.get('encParams');

    let encVal = UiComm.makeEncParams(addParamObj);
	$("#moveForm input[name=encParams]").val(encParams === null ? encVal : encParams); // encParams에도 세팅
	$("#moveForm input[name=addParams]").val(encVal);

    $("#moveForm input[name=menunm]").val(menunm);
    $("#moveForm input[name=menuUrl]").val(menuUrl);
    $("#moveForm input[name=upMenuId]").val(upMenuId);
    $("#moveForm input[name=menuId]").val(menuId);

    // Tab에 표시
    // [수정] 탭으로 이동할 때의 로직 변경
	if (linkTargetTycd == "tab") {

		//alert('6');

	    if (typeof TAB_MENU == 'undefined') {

			console.log('탭이 한개도 없어 새로 생성합니다.');

	        // 1. 탭 메뉴가 없어서 대시보드로 폼 submit할 때
	        $("#moveForm input[name=addParams]").val(UiComm.makeEncParams(addParamObj));
	        $("#moveForm input[name=menunm]").val(menunm);
	        $("#moveForm input[name=menuUrl]").val(menuUrl);
	        $("#moveForm input[name=upMenuId]").val(upMenuId);
	        $("#moveForm input[name=menuId]").val(menuId);

	        let url = "/dashboard/mainTabpage.do";
	        $("#moveForm").attr("action", url);
	        $("#moveForm").submit();

	    } else {
			
			//alert('8');
	        // 1. 목록 이동을 위한 깨끗한 파라미터 생성 (메뉴 정보 등)
	        let encParamVal = UiComm.makeEncParams(addParamObj);
	        let separator = (menuUrl.indexOf("?") === -1) ? "?" : "&";
	        let finalMenuUrl = menuUrl + separator + "addParams=" + encodeURIComponent(encParamVal);

	        // 2. [확장] 어떤 형태의 탭 구조든 iframe을 무조건 찾아내는 4단계 탐색
	        let $existingFrame = $();

	        // ① iframe 자체의 ID나 Name이 menuId인 경우
	        $existingFrame = $("iframe#" + menuId + ", iframe[name='" + menuId + "']");

	        // ② 탭 감싸는 div 하위에 iframe이 있는 경우
	        if ($existingFrame.length === 0) {
	            $existingFrame = $("#" + menuId).find("iframe");
	        }

	        // ③ 프레임워크 관례상 접두사(tab_, frame_)가 붙은 경우 패턴 매칭
	        if ($existingFrame.length === 0) {
	            $existingFrame = $("iframe[id*='" + menuId + "'], iframe[name*='" + menuId + "']");
	        }

	        // ④ pageFrames(부모컨테이너) 내부에서 해당 menuId 속성을 가진 요소 추적
	        if ($existingFrame.length === 0) {
	            $existingFrame = $("#pageFrames").find("[id*='" + menuId + "']").find("iframe");
	        }
	        
	        // [디버깅 코드 추가]
			console.log("현재 클릭한 menuId:", menuId);
			console.log("찾은 iframe 개수:", $existingFrame.length);
			
	        // 3. 기존 탭이 발견되었다면 주소를 강제 변경
	        if ($existingFrame.length > 0 && $existingFrame.attr("src")) {
				
				if ($existingFrame.attr("src") != finalMenuUrl) {
			        $existingFrame.attr("src", finalMenuUrl);
			    }
				
	            console.log('기존 탭을 찾았습니다! 탭을 활성화합니다.');
	            
	            //console.log(menuId);
				//console.log($existingFrame.attr("id"));
				//console.log($existingFrame.attr("name"));
	            
	            for (let key in TAB_MENU) { // TAB_MENU의 key들을 찾기 위해 로그룰 출력합니다.
				    console.log(key);
				}
				
				TAB_MENU.onTabMenu(menuId);
				
				//TAB_MENU.scrollToMenu(menuId);
	            
	        } else {
				
		        // 4. 기존 탭이 아예 없는 최초 오픈 상태라면 정상적으로 탭 추가 호출
		        console.log('기존 탭이 없어 새로 생성합니다.');
		        TAB_MENU.addTabMenu(menunm, finalMenuUrl, upMenuId, menuId);
	        }
	    }
	}
    // 새창
    else if (linkTargetTycd == "window") {

		//alert('9');

        window.open("about:blank", "win_" + menuId);
        $("#moveForm").attr("action", menuUrl);
        $("#moveForm").attr("target", "win_" + menuId);
        $("#moveForm").submit();
    }

    // 외부 사이트
    else if (linkTargetTycd == "other") {
		//alert('10');
        window.open(menuUrl, "_blank");
    }
    // self
    else {
		//alert('글로벌메뉴 클릭 여기');
        $("#moveForm").attr("action", menuUrl);
        $("#moveForm").removeAttr("target");
        $("#moveForm").submit();
    }
}

// 강의실 메뉴 이동
function lectMoveMenu(obj, menuUrl, upMenuId, menuId, menunm, linkTargetTycd, extraParam) {
    console.log("assets/js/gnb.js>>>>>>>>>>>>>>>>> moveMenu");
    if (menuUrl === null || menuUrl === 'null' || menuUrl === '') {
        return;
    }

    let $moveForm = $("#moveForm");
    if ($moveForm.length === 0) {
        let form = `
            <form id="moveForm" method="post">
                <input name="encParams" type="hidden" value="">
                <input name="addParams" type="hidden" value="">
                <input name="menunm"    type="hidden" value="">
                <input name="menuUrl"   type="hidden" value="">
                <input name="upMenuId"  type="hidden" value="">
                <input name="menuId"    type="hidden" value="">
            </form>
        `;
        $("body").append(form);
        $moveForm = $("#moveForm");
    }
    if (obj !== null && menunm === "") {
        if (!menunm) {
            menunm = $(obj).children("span").html();
        }
    }

    // 기본 파라미터
    let addParamObj = {
        upMenuId : upMenuId,
        menuId : menuId,
        menuTarget : linkTargetTycd
    };

    // 추가 파라미터 병합
    if (extraParam) {
        $.extend(addParamObj, extraParam);
    }

    $("#moveForm input[name=addParams]").val(
        UiComm.makeEncParams(addParamObj)
    );

    $("#moveForm input[name=menunm]").val(menunm);
    $("#moveForm input[name=menuUrl]").val(menuUrl);
    $("#moveForm input[name=upMenuId]").val(upMenuId);
    $("#moveForm input[name=menuId]").val(menuId);

    // Tab에 표시
    if (linkTargetTycd == "tab") {
        if (typeof TAB_MENU == 'undefined') {
            let url = "/dashboard/mainTabpage.do";
            $("#moveForm").attr("action", url);
            $("#moveForm").submit();

        } else {
            menuUrl += (menuUrl.indexOf("?") === -1 ? "?" : "&") + "encParams=" + $("#moveForm input[name=encParams]").val();

            menuUrl += "&addParams=" + $("#moveForm input[name=addParams]").val();

            TAB_MENU.addTabMenu(menunm, menuUrl, upMenuId, menuId);
        }
    }

    // 새창
    else if (linkTargetTycd == "window") {
        window.open("about:blank", "win_" + menuId);
        $("#moveForm").attr("action", menuUrl);
        $("#moveForm").attr("target", "win_" + menuId);
        $("#moveForm").submit();
    }

    // 외부 사이트
    else if (linkTargetTycd == "other") {
        window.open(menuUrl, "_blank");
    }
    // self
    else {

        $("#moveForm").attr("action", menuUrl);
        $("#moveForm").removeAttr("target");
        $("#moveForm").submit();
    }
}

function adminMoveMenu(obj, url, myTopMenuId, menuId, menunm, linkTargetTycd) {
    // 1. 기존 동적 폼이 있다면 제거
    $('#dynamicMenuForm').remove();

    // 2. 가상의 Form 생성 (POST 방식)
    let $form = $('<form>', {
        id: 'dynamicMenuForm',
        action: url,
        method: 'post'
    });

    // 3. MenuVO 필드명과 일치하는 hidden input 생성 및 데이터 추가
    $form.append($('<input>', { type: 'hidden', name: 'menuId', value: menuId }));
    $form.append($('<input>', { type: 'hidden', name: 'myTopMenuId', value: myTopMenuId }));
    $form.append($('<input>', { type: 'hidden', name: 'menunm', value: menunm }));
    $form.append($('<input>', { type: 'hidden', name: 'linkTargetTycd', value: linkTargetTycd }));
    // 필요하다면 menuGbncd 등 고정값도 추가 가능
    $form.append($('<input>', { type: 'hidden', name: 'menuGbncd', value: 'ADM' }));

    // 4. body에 붙여서 전송(submit)
    $('body').append($form);
    $form.submit();
}

// 관리자 메뉴 이동
/*function adminMoveMenu(obj, menuUrl, myTopMenuId, menuId, menunm, linkTargetTycd){
	console.log("assets/js/gnb.js>>>>>>>>>>>>>>>>> adminMoveMenu");
	var upMenuId;
	if (menuUrl === null || myTopMenuId === 'null' || menuId === '') {
		console.log('menuUrl=' + menuUrl + ', myTopMenuId=' + myTopMenuId +', menuId=' + menuId);
		return;
	}
	alert('menuUrl=' + menuUrl + ', myTopMenuId=' + myTopMenuId +', menuId=' + menuId);

	let $moveForm = $("#moveForm");
	if ($moveForm.length === 0) {
		let form = `<form id="moveForm" 	method="post">
				<input name="encParams" 	type="hidden" value="">
				<input name="addParams" 	type="hidden" value="">
				<input name="menunm"    	type="hidden" value="">
				<input name="menuUrl"   	type="hidden" value="">
				<input name="upMenuId"  	type="hidden" value="">
				<input name="myTopMenuId"  	type="hidden" value="">
				<input name="menuId"    	type="hidden" value="">
			</form>`;
		$("body").append(form);
	}

	if (obj !== null && menunm === "") {
		if (!menunm) {
			menunm = $(obj).children("span").text();
		}
	}


	$("#moveForm input[name=addParams]").val(UiComm.makeEncParams({myTopMenuId: myTopMenuId, upMenuId:upMenuId, menuId:menuId, menuTarget:linkTargetTycd}));
	$("#moveForm input[name=menunm]").val(menunm);
	$("#moveForm input[name=menuUrl]").val(menuUrl);
	$("#moveForm input[name=upMenuId]").val(upMenuId);
	$("#moveForm input[name=myTopMenuId]").val(myTopMenuId);
	$("#moveForm input[name=menuId]").val(menuId);

	// Tab에 표시
	if (linkTargetTycd == "tab") {
		// TODO 관리자 Tab 메뉴 구현시 적용
	}
	// 새창에 호출
	else if (linkTargetTycd == "window") {
		window.open("about:blank", "win_"+menuId);
		$("#moveForm").attr("action", menuUrl);
		$("#moveForm").attr("target", "win_"+menuId);
		$("#moveForm").submit();
	}
	// 타 사이트 호출
	else if (linkTargetTycd == "other") {
		window.open(menuUrl, '_blank');
	}
	// self 표시
	else {
		//$moveForm.attr("method", "post");
		//$moveForm.attr("action", menuUrl);
		//$moveForm.removeAttr("target");
		//$moveForm.submit();
		$("#moveForm").attr("action", menuUrl);
		$("#moveForm").submit();
	}
}*/

// 메뉴 스크롤
function scrollGnbMenu(upMenuId, menuId) {
	console.log("gnb.js>>>>>>>>>>>>>>>>> scrollGnbMenu");
	if (upMenuId != "" && menuId != "") {
		let item = null;

		if ("ROOT" == upMenuId) {
			item = document.getElementById('MENU_'+menuId);
		}
		else {
			item = document.getElementById('SUB_'+upMenuId);
		}

		if (item != null) {
			item.scrollIntoView({ behavior: 'smooth', block: 'center' });
		}
	}
}
