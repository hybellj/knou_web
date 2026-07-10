class popup_util {

    open(url, width = 480, height = 640, data = {}) {

        return new Promise((resolve, reject) => {

            const popupWidth = width;
            const popupHeight = height;

            const popupX = Math.round(window.screenX + (window.outerWidth / 2) - (popupWidth / 2));
            const popupY = Math.round(window.screenY + (window.outerHeight / 2) - (popupHeight / 2));

            const featureWindow =
                "width=" + popupWidth +
                ",height=" + popupHeight +
                ",left=" + popupX +
                ",top=" + popupY +
                ",location=no,menubar=no,toolbar=no";

            const popup = window.open(url, "_corschild", featureWindow);

            if (!popup) {
                reject({
					result 	: -999,
					type	: null,
					msg 	: "에러)팝업 권한이 없습니다.",
					token 	: null
                });
                return;
            }

            const messageHandler = (event) => {

                // 필요시 origin 체크
                // if (event.origin !== "https://example.com") return;

                resolve(event.data);
                window.removeEventListener("message", messageHandler);
            };

            window.addEventListener("message", messageHandler);

            // popup 로 데이터 전달
            setTimeout(() => {
                popup.postMessage(data, "*");
            },1500);

            // popup 닫힘 감지
            const closeCheck = setInterval(() => {
                if (popup.closed) {
                    clearInterval(closeCheck);
                    reject({
    					result 	: -1,
    					type	: null,
    					msg 	: "팝업이 닫혔습니다.",
    					token 	: null
                    });
                }
            }, 500);
        });

    }

}