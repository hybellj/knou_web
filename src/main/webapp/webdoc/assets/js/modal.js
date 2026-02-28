document.addEventListener("DOMContentLoaded", () => {
  let activeModal = null;
  let lastFocusedElement = null;

  // 모달 열기
  document.addEventListener("click", (e) => {
    const openBtn = e.target.closest("[data-modal-open]");
    if (!openBtn) return;

    const modalId = openBtn.dataset.modalOpen;
    const modal = document.getElementById(modalId);
    if (!modal) return;

    lastFocusedElement = openBtn;
    activeModal = modal;

    modal.classList.add("active");
    modal.setAttribute("aria-hidden", "false");

    document.body.style.overflow = "hidden";
    modal.querySelector(".modal-content").focus();
  });

  // 모달 닫기 (X 버튼, 배경)
  document.addEventListener("click", (e) => {
    if (!activeModal) return;

    if (
      e.target.classList.contains("modal-overlay") ||
      e.target.closest(".modal-close")
    ) {
      closeModal();
    }
  });

  // ESC 키
  document.addEventListener("keydown", (e) => {
    if (e.key === "Escape" && activeModal) {
      closeModal();
    }
  });

  function closeModal() {
    activeModal.classList.remove("active");
    activeModal.setAttribute("aria-hidden", "true");

    document.body.style.overflow = "";

    if (lastFocusedElement) {
      lastFocusedElement.focus();
    }

    activeModal = null;
  }
});
