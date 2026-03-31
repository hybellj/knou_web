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

});


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
	          ul.style.height = "0px";
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


// 메뉴 이동
function moveMenu(obj, menuUrl, upMenuId, menuId, menunm, linkTargetTycd){
	if (menuUrl === '') {
		return;
	}

	let $moveForm = $("#moveForm");
	if ($moveForm.length === 0) {
		let form = `<form id="moveForm" method="post">
				<input name="encParams" type="hidden" value="">
				<input name="addParams" type="hidden" value="">
				<input name="menunm"    type="hidden" value="">
				<input name="menuUrl"   type="hidden" value="">
				<input name="upMenuId"  type="hidden" value="">
				<input name="menuId"    type="hidden" value="">
			</form>`;
		$("body").append(form);
	}

	if (obj !== null && menunm === "") {
		if (!menunm) {
			menunm = $(obj).children("span").html();
		}
	}

	$("#moveForm input[name=addParams]").val(UiComm.makeEncParams({upMenuId:upMenuId,menuId:menuId}));
	$("#moveForm input[name=menunm]").val(menunm);
	$("#moveForm input[name=menuUrl]").val(menuUrl);
	$("#moveForm input[name=upMenuId]").val(upMenuId);
	$("#moveForm input[name=menuId]").val(menuId);

	// Tab에 표시
	if (linkTargetTycd == "tab") {
		if (typeof TAB_MENU == 'undefined') {
			let url = "/dashboard/mainTabpage.do"
			$("#moveForm").attr("action", url);
			$("#moveForm").submit();
		}
		else {
			menuUrl += (menuUrl.indexOf("?") === -1 ? "?" : "&") + "encParams=" + $("#moveForm input[name=encParams]").val();
			menuUrl += "&addParams=" + $("#moveForm input[name=addParams]").val();
			TAB_MENU.addTabMenu(menunm, menuUrl, upMenuId, menuId);
		}
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
		$("#moveForm").attr("action", menuUrl);
		$("#moveForm").submit();
	}
}
