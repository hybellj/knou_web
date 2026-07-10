package knou.framework.exception;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.TextStyle;
import java.util.Date;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import knou.framework.common.IdPrefixType;
import knou.framework.util.CommonUtil;
import knou.framework.util.IdGenUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.exception.service.SystemExceptionService;
import knou.lms.exception.vo.SystemExceptionVO;
import knou.lms.user.vo.UserVO;

@ControllerAdvice
public class GlobalControllerExceptionHandler {
	
    private static final Logger log = LoggerFactory.getLogger(GlobalControllerExceptionHandler.class);
    
    @Resource(name="systemExceptionService")
    private SystemExceptionService systemExceptionService;

    
    @ExceptionHandler(SessionTimeoutException.class)
    public Object handleSessionTimeout(
            SessionTimeoutException ex,
            HttpServletRequest request) {

        log.info("SessionTimeoutException 발생", ex);

        // AJAX 요청
        if (isAjax(request)) {

            ProcessResultVO<Object> result =  new ProcessResultVO<>();
            result.setResult(CommonUtil.FAIL);
            result.setMessage("세션이 만료되었습니다. 다시 로그인해주세요.");
            return ResponseEntity.status(401).body(result);

        // 일반 submit 요청
        } else {

            return new ModelAndView("redirect:/login.do");
        }
    }
    
    private boolean isAjax(HttpServletRequest request) {
    	String accept = request.getHeader("accept");

        return "XMLHttpRequest".equals(request.getHeader("X-Requested-With")) 
        		|| (accept != null && accept.contains("application/json"));
    }
    
    /**
     * DB 연결 오류 전용
     */
    @ExceptionHandler({org.springframework.jdbc.CannotGetJdbcConnectionException.class,
        org.springframework.transaction.CannotCreateTransactionException.class,
        java.sql.SQLRecoverableException.class})
    public String handleDatabaseException(Exception e, Model model) {
        return "/common/dbConnectError";
    }
    
    /**
     * @Valid 또는 @Validated 검증 실패 시 발생하는 예외를 전역 캐치
     */
    @ExceptionHandler({MethodArgumentNotValidException.class, org.springframework.validation.BindException.class})
    @ResponseBody
    public ProcessResultVO<Object> handleValidationException(Exception e) {
        
        BindingResult bindingResult = null;
        
        if (e instanceof MethodArgumentNotValidException) {
            bindingResult = ((MethodArgumentNotValidException) e).getBindingResult();
        } else if (e instanceof org.springframework.validation.BindException) {
            bindingResult = ((org.springframework.validation.BindException) e).getBindingResult();
        }

        // 첫 번째 에러 메시지 추출
        String errorMsg = "입력값이 올바르지 않습니다.";
        if (bindingResult != null && bindingResult.hasErrors()) {
            FieldError fieldError = bindingResult.getFieldError();
            if (fieldError != null) {
                errorMsg = fieldError.getDefaultMessage();
            }
        }

        // 컨트롤러가 쓰던 포맷과 동일한 포맷으로 에러 반환
        ProcessResultVO<Object> failResult = new ProcessResultVO<>();
        failResult.setResult(ProcessResultVO.RESULT_FAIL);
        failResult.setMessage(errorMsg);
        
        return failResult;
    }

    /**
     * 공통 예외 처리 + DB 저장
     */
    @ExceptionHandler(Exception.class)
    @ResponseBody
    public Object handleAllException(Exception ex, HttpServletRequest request) {
        // 1. 로그는 전체 StackTrace 남김
        log.error("#####GlobalControllerExceptionHandler.handleAllException - start", ex);
        
        try {          	
        	
            SystemExceptionVO vo = new SystemExceptionVO();
            
            LocalDateTime now = LocalDateTime.now();

            //ID
            vo.setSysErrId(IdGenUtil.genNewId(IdPrefixType.SYERR));
            
            vo.setTraceId((String)request.getAttribute("TRACE_ID"));

            //사용자
            String userId = "GUEST";
            HttpSession session = request.getSession(false);

            if (session != null) {
                UserVO user = (UserVO) session.getAttribute("loginUser");
                if (user != null) {
                    userId = user.getUserId();
                }
            }

            vo.setUserId(userId);
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);

            //URL
            String url = request.getRequestURI();
            if (request.getQueryString() != null) {
                url += "?" + request.getQueryString();
            }
            vo.setSysErrReqUrl(url);

            //핵심: Root Cause 메시지만 저장
            String msg = CommonUtil.getRootMessage(ex);

            if (msg == null || msg.isEmpty()) {
                msg = ex.getMessage();
            }

            if (msg != null && msg.length() > 1000) {
                msg = msg.substring(0, 1000);
            }

            vo.setSysErrMsg(msg);

            //에러 타입
            vo.setSysErrTycd("ERROR");

            //시간
            vo.setSysErrDt(new Date());

            vo.setSysErrHourOfDay(String.format("%02d", now.getHour()));

            vo.setSysErrDayOfWeek(
                now.getDayOfWeek().getDisplayName(TextStyle.FULL, Locale.KOREAN)
            );

            String nowStr = now.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));

            vo.setRegDttm(nowStr);
            vo.setModDttm(nowStr);
            
            vo.setCntnIp(CommonUtil.getIpAddress(request));

            //DB 저장
            systemExceptionService.systemExceptionInsert(vo);
            
            log.error("#####GlobalControllerExceptionHandler > Exception 로그 DB 저장 완료");

        } catch (Exception e) {
            log.error("#####GlobalControllerExceptionHandler > Exception 로그 DB 저장 실패", e);
        }
        
        log.error("#####GlobalControllerExceptionHandler submit error, ajax error 판별 전 >");
        
        // ajax 에러 페이지
    	if ( isAjax(request) ) {     		
    		log.error("#####GlobalControllerExceptionHandler > Ajax Exception - 호출한 모듈에서 오류 처리");
    	    ProcessResultVO<Object> result = new ProcessResultVO<>();
    	    result.setResult(CommonUtil.FAIL);
    	    result.setMessage("처리 중 오류가 발생했습니다.");
    	    return result;
    	
    	// 일반 에러 페이지
    	} else {
    		
    		// 수정 포인트: 세션 또는 로그인 유저가 없는지 체크
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("loginUser") == null) {
                log.error("#####GlobalControllerExceptionHandler > 세션 또는 유저 정보 없음 -> 로그인 페이지로 이동");
                return new ModelAndView("redirect:/login.do");
            }
    		
    		//String prevUrl = (String) request.getSession().getAttribute("ERROR_PREVIOUS_URL"); // submit exception 발생시 이전페이지로 이동
    		//if (prevUrl != null) {
    		//	log.error(" 일반 Submit Exception ERROR_PREVIOUS_URL 페이지로 이동>>>>>>>>>>>" + prevUrl);
    		//    return new ModelAndView("redirect:" + prevUrl);
    		//} else {
	    		log.error("#####GlobalControllerExceptionHandler > 일반 Submit Exception common/error.jsp로 이동");
		        ModelAndView mav = new ModelAndView("common/error");
		        mav.addObject("exception", ex);
		        return mav;
    		//}
    	}
    }
    
    
    /**
     * Exception 인터페이스로 잡지 못하는 java.lang.Error 계열(컴파일 오류, OOM 등) 전역 캐치
     * 시스템 크래시성 오류 시 에러 화면 대신 로그인 페이지로 안전하게 리다이렉트 처리
     */
    @ExceptionHandler(Throwable.class)
    public Object handleThrowable(Throwable th, HttpServletRequest request) {
        
        // 1. 에러 로그 출력 (실제 발생한 에러 원인 추적용)
        log.error("##### GlobalControllerExceptionHandler.handleThrowable 발생 - 최상위 에러 감지 #####");
        log.error("에러 메시지: " + th.getMessage(), th);
        
        // 2. AJAX 요청 판별
        if (isAjax(request)) {
            log.error("##### Ajax Throwable Exception -> 401 및 에러 메시지 반환");
            ProcessResultVO<Object> result = new ProcessResultVO<>();
            result.setResult(CommonUtil.FAIL);
            result.setMessage("시스템에 오류가 발생했습니다. 다시 로그인해주세요.");
            return ResponseEntity.status(401).body(result);
            
        // 3. 일반 submit 요청일 경우 로그인 페이지로 강제 이동
        } else {
            log.error("##### 일반 Submit Throwable Exception -> /login.do 로 강제 리다이렉트");
            return new ModelAndView("redirect:/login.do");
        }
    }
    
}