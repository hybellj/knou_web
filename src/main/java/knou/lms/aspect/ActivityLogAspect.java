package knou.lms.aspect;

import javax.servlet.http.HttpServletRequest;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;
import org.springframework.ui.ModelMap;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import knou.framework.common.ControllerBaseHolder;
import knou.framework.common.IdPrefixType;
import knou.framework.context2.UserContext;
import knou.framework.util.IdGenUtil;
import knou.lms.log2.user.service.LogUserActvService;
import knou.lms.log2.user.vo.LogUserActvVO;
import knou.lms.user.vo.UserVO;

@Aspect
@Component
public class ActivityLogAspect {

    private final LogUserActvService logService;

    public ActivityLogAspect(LogUserActvService logService) {
        this.logService = logService;
    }

    @Around("execution(* knou..controller..*(..))")
    public Object log(ProceedingJoinPoint pjp) throws Throwable {

        HttpServletRequest request =
            ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();

        // 🔥 ModelMap 추출
        ModelMap model = null;
        for (Object arg : pjp.getArgs()) {
            if (arg instanceof ModelMap) {
                model = (ModelMap) arg;
                break;
            }
        }

        if (model != null) {
            ControllerBaseHolder.setModelMap(model);
        }

        // 사용자 정보
        UserContext userCtx = (UserContext) request.getAttribute("USER_CONTEXT");
        UserVO user = new UserVO("GUEST", "UNKNOWN"); // TB_LMS_USER 테이블에 GUEST 아이디 있어야함 FK
        if (userCtx != null && userCtx.getLoginUser() != null) {
        	user = userCtx.getLoginUser();
        }

        // 시작시간
        Object startObj = request.getAttribute("START_TIME");
        long start = (startObj != null) ? (long) startObj : System.currentTimeMillis();

        boolean success = true;
        Exception error = null;

        try {
            return pjp.proceed();

        } catch (Exception e) {
            success = false;
            error = e;
            throw e;

        } finally {
            try {
                long end = System.currentTimeMillis();
                
                String traceId = (String) request.getAttribute("TRACE_ID");

                LogUserActvVO logVO = LogUserActvVO.createLogVO(
                    IdGenUtil.genNewId(IdPrefixType.LOACT),
                    user,
                    request,
                    start,
                    end,
                    success,
                    error
                );
                
                logVO.setTraceId(traceId);

                //logService.userActvLogInsert(logVO); // async

            } catch (Exception logEx) {
                // 로그 실패는 무시 (중요)
                logEx.printStackTrace();
            } finally {
                // 🔥 ThreadLocal 반드시 제거
                ControllerBaseHolder.clear();
            }
        }
    }
}