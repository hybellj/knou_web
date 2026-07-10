package knou.framework.common;

import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Enumeration;
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

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import knou.framework.util.JsonUtil;
import knou.framework.util.SecureUtil;
import knou.framework.util.SessionUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;

/**
 * Controller 공통
 */
public class ControllerBase {
	private static Log log = LogFactory.getLog(ControllerBase.class);

	private String 					encParams; 		// 암호화 파라메터
	private Map<String, Object>		encParamsMap;	// 암호화 파라메터 Map
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
	public void init(HttpServletRequest request, ModelMap modelMap, Object paramVO) throws Exception {
		log.info("#####ControllerBase > ControllerBase.init 진입");
		try {
			
			printRequestParameters(request);
			
			this.request 		= request;
			this.session 		= request.getSession();
			this.modelMap 		= modelMap;
			this.message 		= new Message(request);
			this.encParams 		= request.getParameter("encParams");
			this.encParamsMap 	= new HashMap<>();
			String referer 		= request.getHeader("referer");
			String uri			= request.getRequestURI();
			String type 		= "";
			boolean isMain		= false;

			log.info("#####ControllerBase > ControllerBase uri=" + uri);
			//log.info("session id = " + this.session.getId());
			//log.info("session interval = " + this.session.getMaxInactiveInterval());

			// 암호화 파라메터가 있는 경우 값을 VO에 세팅
			if (paramVO != null) {
				// 암호화 파라메터 VO에 설정
				if (this.encParams != null && !"".equals(this.encParams)) {
					log.info("전달받은 encParams=" + SecureUtil.decodeStr(this.encParams));
					Map<String, Object> paramMap = JsonUtil.jsonToMap(SecureUtil.decodeStr(this.encParams));
					setEncParamMapToVO(paramMap, paramVO, true);
				}

				// 추가 파라메터 VO에 설정 ---- 삭제예정
				String extParam = request.getParameter("extParam");
				log.info("전달받은 extParam=" + SecureUtil.decodeStr(extParam));
				if (extParam != null && !"".equals(extParam)) {
					Map<String, Object> paramMap = JsonUtil.jsonToMap(SecureUtil.decodeStr(extParam));
					setEncParamMapToVO(paramMap, paramVO, true);
				}

				// 추가 파라메터 VO에 설정
				String addParams = request.getParameter("addParams");
				log.info("전달받은 addParams=" + SecureUtil.decodeStr(addParams));
				if (addParams != null && !"".equals(addParams)) {
					Map<String, Object> paramMap = JsonUtil.jsonToMap(SecureUtil.decodeStr(addParams));
					setEncParamMapToVO(paramMap, paramVO, true);
				}
			}
			
			log.info("[변수들 병합한 encParams]" + this.encParamsMap);

			// URL이 대시보드 이면,
			if (uri.indexOf("Dashboard.do") > -1) {
				isMain = true;
				SessionUtil.setSessionValue(request, "PAGE_TYPE", "normal");
			}
			else {
				type = StringUtil.nvl((String)SessionUtil.getSessionValue(request, "PAGE_TYPE"));
			}

			// 메인 탭메뉴 페이지 이면 iframe 타입 지정
			if ( referer != null && referer.indexOf("/mainTabpage.do") > -1 && !isMain) {
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

			// encParams 변수 이름 오타로 인한 버그
			// ----------------------------------------------------
            // [기존 코드 위치] 여기에 아래 로직을 추가하여 encParams를 보완합니다.
			// -- 게시판소스에서 encParam을 사용한 곳이 많아서 추가함 -- by jinkoon 20260703
			// 대시보드에서 게시글 클릭시 조회화면 이동으로 위하여 추가합니다 start
            // ----------------------------------------------------
            //String reqBbsId = request.getParameter("bbsId");
            //String reqBbsTycd = request.getParameter("bbsTycd");
            //String reqAtclId = request.getParameter("atclId");

            // 강의실 과목ID 세션 유지
			/*
			 * String reqSbjctId = request.getParameter("sbjctId"); if
			 * (ValidationUtils.isNotEmpty(reqSbjctId)) { // URL 에 sbjctId 가 있으면 세션 갱신
			 * request.getSession().setAttribute("CUR_SBJCT_ID", reqSbjctId); } else { //
			 * 없으면 세션값을 modelMap 에 넣어 JSP/이후 로직에서 쓰게 함 Object curSbjctId =
			 * request.getSession().getAttribute("CUR_SBJCT_ID"); if (curSbjctId != null) {
			 * modelMap.addAttribute("sbjctId", curSbjctId); } }
			 */

            // URL에 일반 텍스트 파라미터로 bbsId나 bbsTycd가 돌아다니고 있다면
            //if (ValidationUtils.isNotEmpty(reqBbsId)) {
            //    this.addEncParam("bbsId", reqBbsId);
            //}
            //if (ValidationUtils.isNotEmpty(reqBbsTycd)) {
            //    this.addEncParam("bbsTycd", reqBbsTycd);
            //}
            //if (ValidationUtils.isNotEmpty(reqAtclId)) {
            //    this.addEncParam("atclId", reqAtclId);
            //}
            // 대시보드에서 게시글 클릭시 조회화면 이동으로 위하여 추가합니다 end

			modelMap.addAttribute("curUpMenuId", StringUtil.nvl(encParamsMap.get("upMenuId")));
			modelMap.addAttribute("curMenuId", StringUtil.nvl(encParamsMap.get("menuId")));
			modelMap.addAttribute("encParams", this.encParams);

			SessionUtil.setSessionValue(request, "PAGE_TYPE", type);
			SessionUtil.setSessionValue(request, "BODY_CLASS", bodyClass);

			log.debug("#####ControllerBase > ControllerBase.init end");

		} catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
			throw e;
		}
	}

	private void setEncParamMapToVO(Map<String, Object> paramMap, Object paramVO, boolean isInit) throws Exception {

	    if (paramMap != null && paramMap.size() > 0) {

	        for (String key : paramMap.keySet()) {

	            log.info("#####ControllerBase.setEncParamMapToVO >  key = " + key);

	            // ---------------- [수정 및 보완 구간] ----------------
	            Method setMethod = null;
	            String setterName = "set" + key.substring(0, 1).toUpperCase() + key.substring(1);
	            Class<?> currentClass = paramVO.getClass();

	            // 부모 클래스(Object 직전까지)를 전부 뒤져서 Setter 메소드를 찾습니다.
	            while (currentClass != null && currentClass != Object.class) {
	                try {
	                    // 해당 key의 타입을 알 수 없으므로, 메소드 이름으로만 검색
	                    Method[] methods = currentClass.getDeclaredMethods();
	                    for (Method method : methods) {
	                        if (method.getName().equals(setterName) && method.getParameterTypes().length == 1) {
	                            setMethod = method;
	                            break;
	                        }
	                    }
	                    if (setMethod != null) break;
	                } catch (Exception e) {
	                    // 메소드가 없으면 다음 루프로 진행
	                }
	                log.info(currentClass.getCanonicalName()); // 부모 클래스 이동전 처리된 클래스 이름 출력
	                
	                currentClass = currentClass.getSuperclass(); // 부모 클래스로 이동
	            }

	            // 메소드를 끝내 못 찾았다면 건너뜀
	            if (setMethod == null) {
	                log.warn("##### 세터 메소드를 찾을 수 없습니다: " + setterName);
	                continue;
	            }
	            // --------------------------------------------------

	            String type = setMethod.getParameterTypes()[0].getSimpleName().toLowerCase();
	            Object value = paramMap.get(key);

	            if (value == null || "".equals(value.toString().trim())) {
	                if ("pageIndex".equals(key)) value = 1;
	                else if ("listScale".equals(key)) value = 10;
	            }

	            if (null == value)
	                continue;

	            // 값 주입 실행
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
	            else if ("bigdecimal".equals(type)) {
	                setMethod.invoke(paramVO, value == null ? null : new BigDecimal(value.toString()));
	            }
	            else {
	                setMethod.invoke(paramVO, value);
	            }
	            
	            if (isInit) {
	                addEncParam(key, value);
	            }
	        }
	    }
	}


	/**
	 * 암호화 파라메터 값을 VO에 할당
	 * @param paramVO
	 */
	public void setEncParamsToVO(Object paramVO) throws Exception  {
		setEncParamMapToVO(this.encParamsMap, paramVO, false);
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
				|| (adminAuth && SessionInfo.getAuthrtGrpcd(request).equals(CommConst.AUTHRT_GRPCD_ADM))) {
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
        if( CommConst.AUTHRT_GRPCD_PROF.equals(userType) )
            isAuth = true;
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
     * 암호화 파라미터들 가져오기
     * @return
     */
    public String getEncParams() {
		return this.encParams;
	}

    /*
     * 암호화 파라미터 값 가져오기
     */
    public String getEncParam(String pName) throws Exception {
    	String value = "";
    	try {
	    	ObjectMapper mapper = new ObjectMapper();
	    	JsonNode root = mapper.readTree(SecureUtil.decodeStr(encParams));
	    	if ( null != this.encParams ) {
	    		value = root.get(pName).asText();
	    	}
    	} catch ( Exception e ) {
    		e.printStackTrace();
    	}
    	return value;
    }

    /**
     * 암호화 파라메터 값 추가
     * @param name
     * @param value
     */
	public void addEncParam(String name, Object value) throws Exception {
		if (this.encParamsMap == null) {
			//log.info(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>안돼안돼안돼>>>>>>>>>>>>>>>>>>>>>> encParamsMap is null........................");
			this.encParamsMap = new HashMap<>();
		}		
		//log.info(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>encParamsMap에 " + name + " 변수, " + value + " 값이 put 되었습니다.");
		this.encParamsMap.put(name, value);
		encParams = SecureUtil.encodeStr(JsonUtil.getJsonStringFromMap(this.encParamsMap).toString());
		modelMap.addAttribute("encParams", encParams);
	}

	/**
	 * 암호화 파라메터 값 삭제
	 * @param name
	 */
	public void delEncParam(String name) throws Exception {
		if (this.encParamsMap != null && encParamsMap.containsKey(name)) {
			this.encParamsMap.remove(name);

			if (!this.encParamsMap.isEmpty()) {
				this.encParams = SecureUtil.encodeStr(JsonUtil.getJsonStringFromMap(encParamsMap).toString());
			}
			else {
				this.encParams = "";
			}
			modelMap.addAttribute("encParams", encParams);
		}
	}

	/**
	 * 암호화 파라메터 초기화
	 */
	public void resetEncParam() {
		encParamsMap = new HashMap<>();
		encParams = "";
		modelMap.addAttribute("encParams", encParams);
	}

	/**
	 * 암호화 파라메터에서 페이지정보, 검색정보 삭제
	 */
	public void delEncParamPageSearch() throws Exception {
		delEncParam("pageIndex");
		delEncParam("searchKey");
		delEncParam("searchValue");
		delEncParam("sortKey");
	}	
	
	public static void printRequestParameters(HttpServletRequest request) {

		log.info("========== Request Parameters ==========");
        Enumeration<String> names = request.getParameterNames();

        while (names.hasMoreElements()) {
            String name = names.nextElement();
            String[] values = request.getParameterValues(name);

            if (values == null) {
            	log.info(name + " = null");
            } else if (values.length == 1) {
            	log.info(name + " = " + values[0]);
            } else {
            	log.info(name + " = ");
                for (int i = 0; i < values.length; i++) {
                	log.info(values[i]);
                    if (i < values.length - 1) {
                    	log.info(", ");
                    }
                }
                log.info("\n");
            }
        }

        log.info("========================================");
    }
}