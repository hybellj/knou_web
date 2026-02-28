package knou.lms.seminar.api.common;

import java.util.Arrays;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

@Aspect
@Component
public class ZoomServiceAspect {

    private static final Logger LOGGER = LoggerFactory.getLogger("tc");

    @Around("execution(* knou.lms.seminar.api..impl.*Impl.*(..))")
    public Object printErrorLog(ProceedingJoinPoint pjp) throws Throwable {
        long start = System.currentTimeMillis();
        try {
            return pjp.proceed(pjp.getArgs());
        } catch (Exception ex) {
            long finish = System.currentTimeMillis();
            LOGGER.error("{} {}.{} args={} ({}ms)", ex.getClass().getSimpleName(),
                    pjp.getTarget().getClass().getSimpleName(), pjp.getSignature().getName(),
                    Arrays.toString(pjp.getArgs()), finish - start);
            throw ex;
        }
    }
    
}
