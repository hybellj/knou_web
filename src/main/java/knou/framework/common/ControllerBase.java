package knou.framework.common;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springmodules.validation.commons.DefaultBeanValidator;

import knou.framework.util.CommonUtil;
import knou.framework.util.JsonUtil;
import knou.framework.util.SecureUtil;
import knou.framework.util.SessionUtil;
import knou.framework.util.StringUtil;

/**
 * Controller 공통
 */
public class ControllerBase {
	private static Log log = LogFactory.getLog(ControllerBase.class);

	private String 					encParams; 		// 암호화 파라메터
	private Map<String, Object>		encParamMap;	// 암호화 파라메터 Map
	private HttpServletRequest 		request;
	private HttpSession 			session;
	private ModelMap 				modelMap;
	private int 					pageAuth = 0;
	private Message 				message;

	private static final String MSG_FAIL_COMMON 			= "fail.common.msg";		// 공통 오류 메시지
	private static final String MSG_FAIL_AUTH 				= "system.fail.auth.msg";	// 공통 권한 오류 메시지
	private static final String MSG_COMMON_RESULT_FAIL 	= "common.result.fail";		// 공통 처리결과 실패 메시지
	private static final String MSG_COMMON_SYSTEM_NO_AUTH 	= "common.system.no_auth";	// 공통 권한오류 메시지

	// parameter
//	public static final String PRM_SEARCH_CND 				= "searchCnd";					// search condition
//	public static final String PRM_SEARCH_KWD 				= "searchKwd";					// search keyword
//	public static final String PRM_PAGE_INDEX 				= "pageIndex";					// page index
//	public static final String PRM_PAGE_LIST_SCALE 			= "listScale";					// page list scale
//	public static final String PRM_ORDER_KEY 				= "orderKey";					// order key
//	public static final String PRM_ORDER_TYPE 				= "orderType";					// order type
//	public static final String PRM_MENU 						= "menu";						// menu

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;


	/**
	 * 초기화
	 * @param request
	 * @param modelMap
	 * @param paramVO
	 */
	public void init(HttpServletRequest request, ModelMap modelMap, Object paramVO) {
		try {
			this.request 		= request;
			this.session 		= request.getSession();
			this.modelMap 		= modelMap;
			this.message 		= new Message(request);
			this.encParams 		= request.getParameter("encParams");
			this.encParamMap 	= new HashMap<>();
			String referer 		= request.getHeader("referer");
			String uri			= request.getRequestURI();
			String type 		= "";
			boolean isMain		= false;

			// 암호화 파라메터가 있는 경우 값을 VO에 세팅
			if (paramVO != null) {
				// 암호화 파라메터 VO에 설정
				if (this.encParams != null && !"".equals(this.encParams)) {
					Map<String, Object> paramMap = JsonUtil.jsonToMap(SecureUtil.decodeStr(this.encParams));
					setEncParamMapToVO(paramMap, paramVO, true);
				}

				// 추가 파라메터 VO에 설정
				String extParam = request.getParameter("extParam");
				if (extParam != null && !"".equals(extParam)) {
					Map<String, Object> paramMap = JsonUtil.jsonToMap(SecureUtil.decodeStr(extParam));
					setEncParamMapToVO(paramMap, paramVO, true);
				}
			}

			// URL이 대시보드 이면,
			if (uri.indexOf("Dashboard.do") > -1) {
				isMain = true;
				SessionUtil.setSessionValue(request, "PAGE_TYPE", "normal");
			}
			else {
				type = StringUtil.nvl((String)SessionUtil.getSessionValue(request, "PAGE_TYPE"));
			}

			// 메인 탭메뉴 페이지 이면 iframe 타입 지정
			if (referer.indexOf("/mainTabpage.do") > -1 && !isMain) {
				type = "iframe";
				SessionUtil.setSessionValue(request, "PAGE_TYPE", type);
				addEncParam("pageType", "iframe");
			}

			String bodyClass = "";
			if ("iframe".equals(type)) {
				bodyClass = "iframeBody";
			}

			//modelMap.addAttribute("pageType", type);
			//modelMap.addAttribute("bodyClass", bodyClass);

			modelMap.addAttribute("curUpMenuId", StringUtil.nvl(encParamMap.get("upMenuId")));
			modelMap.addAttribute("curMenuId", StringUtil.nvl(encParamMap.get("menuId")));
			modelMap.addAttribute("encParams", this.encParams);

			SessionUtil.setSessionValue(request, "PAGE_TYPE", type);
			SessionUtil.setSessionValue(request, "BODY_CLASS", bodyClass);

		} catch (Exception e) {
			log.error(e.getMessage());
		}
	}


	// 암호화 파라메터맵을 VO에 할당
	private void setEncParamMapToVO(Map<String, Object> paramMap, Object paramVO, boolean isInit) {
		try {
			if (paramMap != null && paramMap.size() > 0) {
				for (String key : paramMap.keySet()) {
					Map<String, Method> methodMap = CommonUtil.getMethod(paramVO.getClass(), key);
					Method setMethod = methodMap.get("set");

					if (setMethod == null) {
						continue;
					}

					String type = setMethod.getParameterTypes()[0].getSimpleName().toLowerCase();
					Object value = paramMap.get(key);

					if ("string".equals(type)) {
						setMethod.invoke(paramVO, value.toString());
					}
					else if (("integer".equals(type) || "int".equals(type))) {
						setMethod.invoke(paramVO, Integer.parseInt(value.toString()));
					}
					else if ("double".equals(type)) {
						setMethod.invoke(paramVO, Double.parseDouble(value.toString()));
					}
					else if ("long".equals(type)) {
						setMethod.invoke(paramVO, Long.parseLong(value.toString()));
					}
					else if ("boolean".equals(type)) {
						setMethod.invoke(paramVO, (value instanceof Boolean) ? (Boolean)value : Boolean.parseBoolean(value == null ? "false" : value.toString()));
					}
					else {
						setMethod.invoke(paramVO, value);
					}

					if (isInit) {
						addEncParam(key, value);
					}
				}
			}
		} catch (Exception e) {
			log.error(e.getMessage());
		}
	}


	/**
	 * 암호화 파라메터 값을 VO에 할당
	 * @param paramVO
	 */
	public void setEparamToVO(Object paramVO) {
		setEncParamMapToVO(this.encParamMap, paramVO, false);
	}


	/**
	 * 처리 결과 설정
	 * @param result
	 * @param resultMsg
	 */
	public void setResult(String result, String resultMsg) {
		SessionUtil.setSessionValue(request, CommConst.SSN_COMMON_RESULT, result);
		SessionUtil.setSessionValue(request, CommConst.SSN_COMMON_RESULT_MSG, resultMsg);
	}


	/**
	 * 처리 결과 [성공] 설정
	 * @param msg
	 */
	public void setResultSuccess(String msg) {
		List<String> msgs = new ArrayList<>();
		msgs.add(msg);

		setResultSuccess(msgs);
	}


	/**
	 * 처리 결과 [성공] 설정 (메시지 목록)
	 * @param msgs
	 */
	public void setResultSuccess(List<String> msgs) {
		StringBuffer msgBuf = new StringBuffer();

		String msgClass = "success-list";
		String icon = "<span class='fa fa-circle-o'></span>";

		if (msgs.size() < 2) {
			msgClass += " noicon";
			icon = "";
		}

		for (int i = 0; i < msgs.size(); i++) {
			msgBuf.append("<div class='"+msgClass+"'>"+icon+msgs.get(i)+"</div>");
		}

		SessionUtil.setSessionValue(request, CommConst.SSN_COMMON_RESULT, CommConst.RESULT_SUCCESS);
		SessionUtil.setSessionValue(request, CommConst.SSN_COMMON_RESULT_MSG, msgBuf.toString());
	}


	/**
	 * 처리결과 [실패] 설정
	 * @param msg
	 */
	public void setResultFail(String msg) {
		List<String> msgs = new ArrayList<>();
		msgs.add(msg);

		setResultFail(msgs);
	}


	/**
	 * 처리결과 [실패] 설정 (메시지 목록)
	 * @param msgs
	 */
	public void setResultFail(List<String> msgs) {
		StringBuffer msgBuf = new StringBuffer();

		String msgClass = "fail-list";
		String icon = "<span class='fa fa-check'></span>";

		if (msgs.size() < 2) {
			msgClass += " noicon";
			icon = "";
		}

		for (int i = 0; i < msgs.size(); i++) {
			msgBuf.append("<div class='"+msgClass+"'>"+icon+msgs.get(i)+"</div>");
		}

		SessionUtil.setSessionValue(request, CommConst.SSN_COMMON_RESULT, CommConst.RESULT_FAIL);
		SessionUtil.setSessionValue(request, CommConst.SSN_COMMON_RESULT_MSG, msgBuf.toString());
	}


	/**
	 * 처리결과 [실패] 설정
	 */
	public void setResultFail() {
		setResultFail(getMessage(MSG_COMMON_RESULT_FAIL));
	}


	/**
	 * 메시지 가져오기
	 * @param key
	 * @param args
	 * @return message
	 */
	public String getMessage(String key, Object...args) {
		return message.getMessage(key, args);
	}


	/**
	 * 공통 실패 메시지
	 * @return message
	 */
	public String getCommonFailMessage() {
		return message.getMessage(MSG_FAIL_COMMON);
	}


	/**
	 * 공통 권한 오류 메시지
	 * @return message
	 */
	public String getCommonNoAuthMessage() {
		return message.getMessage(MSG_FAIL_AUTH);
	}


	/**
	 * 페이지 권한 체크 (로그인, 메뉴권한)
	 * @param auth
	 * @return result
	 */
	public boolean checkPageAuth(int auth) {
		boolean result = true;

		if (StringUtil.isNull(SessionInfo.getUserId(request)) || pageAuth < auth) {
			modelMap.addAttribute("errorMsg", getMessage(MSG_COMMON_SYSTEM_NO_AUTH));
			result = false;
		}

		return result;
	}


	/**
	 * 페이지 권한 체크 (로그인, 메뉴권한)
	 * @return result
	 */
	public boolean checkPageAuth() {
		return checkPageAuth(CommConst.AUTH_READ);
	}


	/**
	 * 작성 권한 가져오기
	 * @param userId
	 * @param adminAuth
	 * @return auth
	 */
	public int getUserAuth(String userId, boolean adminAuth) {
		int auth = 0;

		if (SessionInfo.getUserId(request).equals(userId)
				|| (adminAuth && SessionInfo.getUserType(request).equals(CommConst.USER_ADMIN))) {
			auth = CommConst.AUTH_WRITE;
		}

		return auth;
	}


	/**
	 * 입력폼 데이터 검증
	 * @param object
	 * @param bindingResult
	 * @param msgs
	 */
	public void validateForm(Object object, BindingResult bindingResult, List<String> msgs) {
	    beanValidator.validate(object, bindingResult);

		if(bindingResult.hasErrors()) {
	    	List<ObjectError> objectErrors = bindingResult.getAllErrors();
	    	for (ObjectError error : objectErrors) {
				msgs.add(getMessage(error.getDefaultMessage(), error.getArguments()));
			}
	    }
	}

    /**
     * 작업결과 메시지 토큰 설정
     * @param msg
     */
    public void setAlertMessage(String msg) {
        session.getServletContext().setAttribute(CommConst.SSN_ALERT_MESSAGE, msg);
    }

    /**
     * 관리자 체크
     * @return boolean
     */
    public boolean checkAdmin() {
        boolean isAuth = false;
        String userType = StringUtil.nvl(SessionInfo.getUserType(request));

        if(userType.contains("SUP") || userType.contains("ADM")
                || userType.contains("MNG") || userType.contains("CMG")
                || userType.contains("DGN") || userType.contains("DEV")) {
            isAuth = true;
        }
        return isAuth;
    }

    /**
     * 교수 체크
     * @param request
     * @return
     */
    public boolean checkProf() {
        boolean isAuth = false;
        String userType = StringUtil.nvl(SessionInfo.getUserType(request));

        if(userType.contains("PFS") || userType.contains("TUT")) {
            isAuth = true;
        }
        return isAuth;
    }

    /**
     * 세션 가져오기
     * @return session
     */
    public HttpSession getSession() {
    	return session;
    }

    /**
     * 암호화 파라메터 가져오기
     * @return
     */
    public String getEncParams() {
		return this.encParams;
	}

    /**
     * 암호화 파라메터 값 추가
     * @param name
     * @param value
     */
	public void addEncParam(String name, Object value) {
		if (encParamMap == null) {
			encParamMap = new HashMap<>();
		}

		encParamMap.put(name, value);
		encParams = SecureUtil.encodeStr(JsonUtil.getJsonStringFromMap(encParamMap).toString());
		modelMap.addAttribute("encParams", encParams);
	}

	/**
	 * 암호화 파라메터 값 삭제
	 * @param name
	 */
	public void delEncParam(String name) {
		if (encParamMap != null && encParamMap.containsKey(name)) {
			encParamMap.remove(name);

			if (!encParamMap.isEmpty()) {
				encParams = SecureUtil.encodeStr(JsonUtil.getJsonStringFromMap(encParamMap).toString());
			}
			else {
				encParams = "";
			}
			modelMap.addAttribute("encParams", encParams);
		}
	}

	/**
	 * 암호화 파라메터 초기화
	 */
	public void resetEncParam() {
		encParamMap = new HashMap<>();
		encParams = "";
		modelMap.addAttribute("encParams", encParams);
	}

	/**
	 * 암호화 파라메터에서 페이지정보, 검색정보 삭제
	 */
	public void delEncParamPageSearch() {
		delEncParam("pageIndex");
		delEncParam("searchKey");
		delEncParam("searchValue");
		delEncParam("sortKey");
	}
}
