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

		// 탭 버튼 current 처리
		$('.tab_btn a').removeClass('current');
		$(this).addClass('current');

		// 연결된 콘텐츠 표시
		let target = $(this).attr('href');
		$('.tab-content').hide();
		$(target).show();
	});



	
	/********** summernote 임시 **********/
	let ss = document.createElement("script");
	ss.src ="/webdoc/dm_assets/summernote/lang/summernote-ko-KR.js";
	ss.type= "text/javascript";
	document.body.appendChild(ss);

	setTimeout(function(){
		$('#summernote').summernote({
			lang: 'ko-KR',
			placeholder: '입력하세요', 
			height: 300,
			fontNames: ['맑은 고딕','궁서','굴림체','굴림','돋움체','바탕체','Arial', 'Arial Black', 'Comic Sans MS', 'Courier New', 'Verdana','Tahoma','Times New Roamn'],
			toolbar: [
				['fontname', ['fontname']],
				['fontsize', ['fontsize']],
				['style', ['bold', 'italic', 'underline','strikethrough', 'clear']],
				['color', ['forecolor','backcolor']],
				['table', ['table']],
				['para', ['ul', 'ol', 'paragraph']],
				['height', ['height']],
				['insert',['picture','link','video']],
				['view', ['codeview','fullscreen']]
			]
			
		});
	}, 400);
	


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




/********** toggleCheckbox **********/
const toggleCheckbox = document.getElementById('myToggle');
const statusText = document.getElementById('status-text');
updateStatus(toggleCheckbox.checked);
toggleCheckbox.addEventListener('change', function() {
    const isChecked = this.checked;
    
    updateStatus(isChecked);

});






