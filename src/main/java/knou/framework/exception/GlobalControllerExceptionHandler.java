package knou.framework.exception;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

@ControllerAdvice
public class GlobalControllerExceptionHandler {
    private static final Logger log = LoggerFactory.getLogger(GlobalControllerExceptionHandler.class);

    /**
     * Exception.class를 지정하면 모든 종류의 예외를 다 잡습니다.
     */
    @ExceptionHandler(Exception.class)
    public ModelAndView handleAllException(Exception ex) {
        // 1. 로그 남기기 (원하셨던 로그 출력!)
        log.error("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        log.error("Web Layer Global Exception 캐치: {}", ex.getClass().getName());
        log.error("에러 메시지: {}", ex.getMessage());
        log.error("상세 스택트레이스: ", ex);
        log.error("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

        // 2. 에러 페이지 보여주기
        ModelAndView mav = new ModelAndView();
        mav.addObject("exception", ex);
        mav.setViewName("common/error"); // /WEB-INF/jsp/common/error.jsp 등 경로에 맞게 설정
        return mav;
    }
}