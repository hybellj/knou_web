package knou.framework.exception;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

@ControllerAdvice
public class GlobalControllerExceptionHandler {
	
    private static final Logger log = LoggerFactory.getLogger(GlobalControllerExceptionHandler.class);

    /**
     * [CASE 1] 세션 타임아웃 처리
     * ArgumentResolver에서 던진 SessionTimeoutException을 여기서 낚아챕니다.
     */
    @ExceptionHandler(SessionTimeoutException.class)
    public String handleSessionTimeout(SessionTimeoutException ex, HttpServletRequest request) {
        // 1. 로그 출력 (지저분한 줄긋기 없이 딱 핵심만 출력)
        log.error("[SessionTimeout] IP: {} | Message: {}", request.getRemoteAddr(), ex.getMessage());

        // 2. 로그인 페이지로 리다이렉트 (문자열 리턴 시 "redirect:" 접두어 사용)
        return "redirect:/login.do"; 
    }

    /**
     * [CASE 2] 그 외 모든 일반 예외 처리
     */
    @ExceptionHandler(Exception.class)
    public ModelAndView handleAllException(Exception ex) {
        // 1. 로그 남기기
        log.error("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        log.error("System Error Catch: {}", ex.getMessage());
        // 필요 시에만 스택트레이스 출력: log.error("Detail: ", ex);
        log.error("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

        // 2. 에러 페이지 보여주기
        ModelAndView mav = new ModelAndView();
        mav.addObject("exception", ex);
        mav.setViewName("common/error");
        return mav;
    }
}