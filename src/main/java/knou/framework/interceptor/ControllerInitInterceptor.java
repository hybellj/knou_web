package knou.framework.interceptor;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.MDC;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Component;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;

import knou.framework.common.CommConst;
import knou.framework.common.IdPrefixType;
import knou.framework.common.MenuInfo;
import knou.framework.common.ParamInfo;
import knou.framework.context2.UserContext;
import knou.framework.util.IdGenUtil;
import knou.lms.log2.user.service.LogUserActvService;
import knou.lms.log2.user.vo.LogTutActvVO;
import knou.lms.log2.user.vo.LogUserActvVO;
import knou.lms.user.vo.UserVO;

/**
 * Controller 초기화 인터셉터
 */
@Component
public class ControllerInitInterceptor implements HandlerInterceptor {

    @Autowired
    private LogUserActvService logUserActvService; // 로그 저장을 담당하는 서비스

    //@Autowired
    //private SemesterService semesterService;

    private static final String TRACE_ID = "TRACE_ID";

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        if(handler instanceof HandlerMethod) {
            HandlerMethod hm = (HandlerMethod) handler;
            Object controller = hm.getBean();

            if(controller instanceof String) {
                ApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(request.getServletContext());
                controller = ctx.getBean((String) controller);
            }

            request.setAttribute("CURRENT_CONTROLLER", controller);
        }

        return true;
    }

    @Override
    public void afterCompletion(HttpServletRequest request,
                                HttpServletResponse response,
                                Object handler,
                                Exception ex)  throws Exception{

        if(handler instanceof HandlerMethod) {

            /********************************************************** start */
            // TRACE_ID 생성
            String traceId = java.util.UUID.randomUUID().toString();
            request.setAttribute(TRACE_ID, traceId);
            MDC.put("TRACE_ID", traceId);

            // 사용자의 요청 로그를 저장
            String url = request.getRequestURI().toLowerCase();
            UserVO user = null;
            Object contextObj = request.getSession().getAttribute("USER_CONTEXT");

            if(contextObj instanceof UserContext) {
                UserContext userCtx = (UserContext) contextObj;
                user = userCtx.getLoginUser();

                if(null != user) { // 로그인 완료한 사용자

                    // 3. 정적 팩토리 메서드를 사용하여 로그 객체 생성 (Null 방어 완료)
                    LogUserActvVO logUserActvVO = LogUserActvVO.createLogVOOrigin(IdGenUtil.genNewId(IdPrefixType.LOACT), user, request);
                    logUserActvVO.setTraceId(traceId);
                    logUserActvVO.setSbjctId(ParamInfo.getParamValue(request, "sbjctId"));

                    if(userCtx.getLoginUser() != null) {
                        logUserActvVO.setOrgId(userCtx.getLoginUser().getOrgId());
                        logUserActvVO.setDeptId(userCtx.getLoginUser().getDeptId());
                        logUserActvVO.setUserRprsId(userCtx.getLoginUser().getUserRprsId());
                    }

                    // 4. DB 저장 (비동기 처리를 권장) // 이런저런 패턴으로 수정 가능하다.
                    /*
                    if((logUserActvVO.getSmstrChrtId() == null || "".equals(logUserActvVO.getSmstrChrtId()))
                            && logUserActvVO.getOrgId() != null && !"".equals(logUserActvVO.getOrgId())) {
                        SmstrChrtVO smstrChrtVO = new SmstrChrtVO();
                        smstrChrtVO.setOrgId(logUserActvVO.getOrgId());
                        SmstrChrtVO currentSemester = semesterService.selectCurrentSemester(smstrChrtVO);
                        if(currentSemester != null) {
                            logUserActvVO.setSmstrChrtId(currentSemester.getSmstrChrtId());
                            SessionInfo.setCurTerm(request, currentSemester.getSmstrChrtId());
                        }
                    }
                    */

                    String menuId	= ParamInfo.getParamValue(request, "menuId");

                    if (url.contains("dashboard.do")) {
                    	menuId = "dashboard";
                    	logUserActvVO.setNaviPosnm("대시보드");
                    }
                    else if (url.contains("/subject.do")) {
                    	menuId = "subject";
                    	logUserActvVO.setNaviPosnm("강의실");
                    }

                	if (menuId != null && !"".equals(menuId)) {
	                    // 활동로그 네비게이션 위치 가져오기
	                    List<String> menuNmList = MenuInfo.getMenuNaviInfo(request);

	                    if (menuNmList != null && !menuNmList.isEmpty()) {
	                    	String naviPosnm = "";

	                    	for (String menuNm : menuNmList) {
	                    		if (!"".equals(naviPosnm)) {
	                    			naviPosnm += " > ";
	                    		}
	                    		naviPosnm += menuNm;
	                    	}

	                    	logUserActvVO.setNaviPosnm(naviPosnm);
	                    }

                    	// 활동 로그기록
	                    logUserActvService.userActvLogInsert(logUserActvVO);

	                    // 튜터 활동 기록
	                    if(null != user && CommConst.AUTHRT_CD_TUT.equals(user.getAuthrtCd()))
	                        logUserActvService.tutorActvLogInsert(LogTutActvVO.createLogVO(logUserActvVO));
                	}
                }

            }

            /********************************************************** end*/
        }

        MDC.remove("TRACE_ID");
    }
}
