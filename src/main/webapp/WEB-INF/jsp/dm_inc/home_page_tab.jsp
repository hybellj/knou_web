<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

	                <div class="page-menu">
                        <button class="btn_arrow"><i class="xi-angle-left"></i></button>
                        <ul class="page_tab">
                            <li class="select">
                                <div class="tabmenu">
                                    <a href="#0">프로필</a>
                                    <button type="button"><i class="xi-close"></i></button>
                                </div>
                            </li>
                            <li>
                                <div class="tabmenu">
                                    <a href="#0">메시지함</a>
                                    <button type="button"><i class="xi-close"></i></button>
                                </div>
                            </li>
                            <li>
                                <div class="tabmenu">
                                    <a href="#0">파일저장소</a>
                                    <button type="button"><i class="xi-close"></i></button>
                                </div>
                            </li>
                            <li>
                                <div class="tabmenu">
                                    <a href="#0">강의계획서</a>
                                    <button type="button"><i class="xi-close"></i></button>
                                </div>
                            </li>
                            <li>
                                <div class="tabmenu">
                                    <a href="#0">전체수업현황</a>
                                    <button type="button"><i class="xi-close"></i></button>
                                </div>
                            </li>
                            <li>
                                <div class="tabmenu">
                                    <a href="#0">학습진도관리</a>
                                    <button type="button"><i class="xi-close"></i></button>
                                </div>
                            </li>
                            <li>
                                <div class="tabmenu">
                                    <a href="#0">공지사항</a>
                                    <button type="button"><i class="xi-close"></i></button>
                                </div>
                            </li>
                            <li>
                                <div class="tabmenu">
                                    <a href="#0">성적관리</a>
                                    <button type="button"><i class="xi-close"></i></button>
                                </div>
                            </li>
                            <li>
                                <div class="tabmenu">
                                    <a href="#0">1:1상담</a>
                                    <button type="button"><i class="xi-close"></i></button>
                                </div>
                            </li>
                        </ul>
                        <div class="right-buttons">
                            <button class="btn_arrow2"><i class="xi-angle-right"></i></button>
                            <button class="btn_close"><i class="xi-close"></i></button>
                        </div>
                    </div>
                    <script>
                    document.addEventListener("DOMContentLoaded", function () {
                        const tabContainer = document.querySelector(".page_tab");
                        const leftBtn = document.querySelector(".btn_arrow");
                        const rightBtn = document.querySelector(".btn_arrow2");
                        const closeBtn = document.querySelector(".btn_close");  

                        // 탭 클릭 시 활성화
                        tabContainer.addEventListener("click", function (e) {
                            const tab = e.target.closest(".tabmenu");
                            if (e.target.closest("button")) return; // 닫기 버튼 클릭 시 무시
                            if (tab) {
                                document.querySelectorAll(".page_tab li").forEach(li => li.classList.remove("select"));
                                tab.closest("li").classList.add("select");
                            }
                        });

                        // 탭 닫기 (페이드아웃 포함)
                        tabContainer.addEventListener("click", function (e) {
                            const closeBtn = e.target.closest(".tabmenu button");
                            if (!closeBtn) return;

                            e.stopPropagation();
                            const li = closeBtn.closest("li");
                            const wasSelected = li.classList.contains("select");

                            li.classList.add("closing");

                            li.addEventListener("transitionend", function onTransitionEnd() {
                                li.removeEventListener("transitionend", onTransitionEnd);
                                li.remove();

                                const remainingTabs = document.querySelectorAll(".page_tab li");
                                if (remainingTabs.length > 0 && wasSelected) {
                                    remainingTabs[0].classList.add("select");
                                }

                                updateArrowState();
                            });
                        });

                        // 좌우 스크롤 버튼 클릭 (한 탭 단위)
                        leftBtn.addEventListener("click", () => scrollByTab(-1));
                        rightBtn.addEventListener("click", () => scrollByTab(1));

                        function scrollByTab(direction) {
                            const tabs = Array.from(tabContainer.querySelectorAll("li"));
                            const scrollLeft = tabContainer.scrollLeft;

                            if (direction > 0) {
                                // 오른쪽 이동
                                for (let tab of tabs) {
                                    if (tab.offsetLeft > scrollLeft + 1) {
                                        tabContainer.scrollTo({ left: tab.offsetLeft, behavior: "smooth" });
                                        break;
                                    }
                                }
                            } else {
                                // 왼쪽 이동
                                for (let i = tabs.length - 1; i >= 0; i--) {
                                    const tab = tabs[i];
                                    const tabRight = tab.offsetLeft + tab.offsetWidth;
                                    if (tabRight < scrollLeft - 1) {
                                        tabContainer.scrollTo({ left: tab.offsetLeft, behavior: "smooth" });
                                        break;
                                    }
                                }
                            }
                        }

                        // 버튼 활성/비활성 업데이트
                        function updateArrowState() {
                            const scrollLeft = tabContainer.scrollLeft;
                            const maxScrollLeft = tabContainer.scrollWidth - tabContainer.clientWidth;

                            leftBtn.classList.toggle("disabled", scrollLeft <= 0);
                            rightBtn.classList.toggle("disabled", scrollLeft >= maxScrollLeft - 1);
                        }

                        tabContainer.addEventListener("scroll", updateArrowState);
                        window.addEventListener("resize", updateArrowState);

                        updateArrowState();

                        // btn_close 클릭 시 page-menu 숨기기
                        closeBtn.addEventListener("click", function () {
                            const pageMenu = document.querySelector(".page-menu");
                            pageMenu.style.display = "none";  // 메뉴 숨기기
                        });
                    });
                    </script>
	