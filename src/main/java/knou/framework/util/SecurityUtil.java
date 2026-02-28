package knou.framework.util;

import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.web.context.support.WebApplicationContextUtils;

import knou.framework.common.CommConst;
import knou.framework.common.SessionInfo;
import knou.framework.exception.AccessDeniedException;
import knou.framework.exception.SessionBrokenException;
import knou.lms.common.service.OrgCfgService;
import knou.lms.common.service.OrgMenuService;
import knou.lms.common.vo.OrgAuthGrpMenuVO;
import knou.lms.common.vo.OrgAuthGrpVO;
import knou.lms.common.vo.OrgCfgVO;
import knou.lms.common.vo.OrgMenuVO;
import knou.lms.common.vo.OrgOrgInfoVO;
import knou.lms.connip.service.OrgConnIpService;
import knou.lms.connip.vo.OrgConnIpVO;
import knou.lms.menu.service.SysMenuMemService;
import knou.lms.menu.service.SysMenuService;
import knou.lms.menu.vo.SysAuthGrpVO;
import knou.lms.menu.vo.SysMenuVO;
import knou.lms.org.service.OrgCodeMemService;
import knou.lms.org.vo.OrgCodeLangVO;
import knou.lms.org.vo.OrgCodeVO;


public class SecurityUtil {
    
	// private static Log log = LogFactory.getLog(SecurityUtil.class);
	
	private SecurityUtil() {
		//-- 생성자
	}
	
	/**
     * 내부 변수 [캐쉬 저장소]
     * key : cfgCtgrCd.cfgCd
     */
    private static final Hashtable<String, Object> cache = new Hashtable<String, Object>();
    private static final Hashtable<String, Object> authCache = new Hashtable<String, Object>();
    private static final Hashtable<String, Object> orgCache = new Hashtable<String, Object>();
    private static final Hashtable<String, Object> cfgCache = new Hashtable<String, Object>();

    /**
     * 캐쉬저장소의 유효성을 판단하는 버젼값
     */
    private static int version = -1;
    private static int compareVersion = -2;
    private static int orgVersion = -1;
    private static int orgCompareVersion = -2;
    private static int cfgVersion = -1;
    private static int cfgCompareVersion = -2;
    private static int authVersion = -1;
    private static int authCompareVersion = -2;

	public static void authorizationCheckRunner(HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			SecurityUtil.authorizationCheck(request, response);
		} catch (Exception ex) {
			throw ex;
		}
	}

	public static void authorizationCheck(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String Action = request.getRequestURI(); // /adm/user/userinfo 형태로 들어온다.
		SessionInfo.setRequestURI(request, Action);
		String mcd = request.getParameter("mcd"); 
		String referer = (String)request.getHeader("Referer");
		
		String userType = "";
		// 추가 2015.11.09 Jamfam 메뉴코드를 가지고 넘어오는 요청은 메뉴코드의 권한으로 체크
		String menuCode = (ValidationUtils.isNotEmpty(mcd)) ? mcd : "";
		// String menuCode = (ValidationUtils.isNotEmpty(mcd)) ? mcd : SessionInfo.getMenuCode(request);
		// String menuCode = SessionInfo.getMenuCode(request);
		String orgId = SessionInfo.getOrgId(request);
		String remoteIp = HttpRequestUtil.getIpAddr(request);
		
		// 기관정보 조회 및 세션 등록
		OrgOrgInfoVO orgOrgInfoVO = null;
		
		// 접속 IP 관련 처리
		SysMenuService sysMenuService = WebApplicationContextUtils
				.getWebApplicationContext(request.getSession().getServletContext())
				.getBean(SysMenuService.class);
		
		SysMenuMemService sysMenuMemService = WebApplicationContextUtils
				.getWebApplicationContext(request.getSession().getServletContext())
				.getBean(SysMenuMemService.class);
		
		OrgMenuService orgMenuService = WebApplicationContextUtils
				.getWebApplicationContext(request.getSession().getServletContext())
				.getBean(OrgMenuService.class);
		 
		// 기관 코드 정보가 있어야 하는  페이지 인지 확인
		String siteAuthCd = "";

		if(Action.matches(".*Home.*")) {
			siteAuthCd = "HOME";
			userType = SessionInfo.getAuthrtCd(request);
		}else if(Action.matches(".*Lect/.*") || Action.matches(".*Open/.*")) {
			
			if( ValidationUtils.isEmpty(SessionInfo.getUserId(request)) ) {
				throw new AccessDeniedException("common.message.security.badrequest");
			}
			
			if(SessionInfo.getMngType(request).toUpperCase().indexOf("MANAGE") > -1) {
	            SessionInfo.setClassUserType(request, "CLASS_PROFESSOR");
			} else {
				OrgAuthGrpMenuVO crsCreMenuAuth = 
						orgMenuService.getCrsCreAuth(orgId, request.getParameter("crsCreCd"), SessionInfo.getUserId(request));
							
				siteAuthCd = crsCreMenuAuth.getAuthrtGrpcd();
				//추가,변경 시 sysMenuMemService.decideMenuWithSession 도 같이 변경해야함.
				 if(!ValidationUtils.isEmpty(crsCreMenuAuth.getClassOwnerType()) ) {
					 String classOwnerType 	= StringUtil.nvl(crsCreMenuAuth.getClassOwnerType());
					 SessionInfo.setClassUserType(request, String.format("CLASS_%s", classOwnerType.toUpperCase()));
				 } else if (!ValidationUtils.isEmpty(crsCreMenuAuth.getClassLearnerType())) {
					 String classLearnerType = StringUtil.nvl(crsCreMenuAuth.getClassLearnerType());
					 SessionInfo.setClassUserType(request, String.format("CLASS_%s", classLearnerType.toUpperCase()));
				 } else {
					SessionInfo.setClassUserType(request, "");
					throw new AccessDeniedException("common.message.security.badrequest");
				}
			}
			
			if(Action.matches(".*topModule")) {
				userType = SessionInfo.getAuthrtCd(request);
			}else {
				userType = SessionInfo.getClassUserType(request);
			}	
	        
		}else if(Action.matches(".*Mgr.*")) {
		    siteAuthCd = "MANAGE";
		    userType = SessionInfo.getMngType(request);
		}else if(Action.matches(".*Adm.*")) {
			siteAuthCd = "ADM";
			userType = SessionInfo.getAdmType(request);
		}else {
			
			siteAuthCd = StringUtil.nvl(request.getParameter("siteAuthCd"),"HOME");
			userType = SessionInfo.getAuthrtCd(request);
		}
			
		if(isSimilarAction(Action,referer) ==false 
				&& SessionInfo.getMaintainMenuSession(request).equals("YES")==false && StringUtil.nvl(menuCode).equals("")) {
			// 이전에 세션에 등록된 메뉴 삭제 
			// 메인페이지 등 메뉴코드가 없는 페이지로 인한 오류를 방지하기 위한 처리 로직
			sysMenuMemService.clearMenuSession(request);
		} else {
			SessionInfo.setMaintainMenuSession(request, "NO"); 
		}
		
		// 변환 서버에서 응답이 오는 return url 요청이면 패스
		if(!request.getRequestURI().equals(CommConst.CMS_RESPONSE_CONTEXT)) {

			/* change lang localeKey
			 * 현재 다국어 코드 적용은 SpringFrameWork의 sessionLocaleResolver를 이용한다. 따라서 url 뒤에 parameter(lang)에 언어 코드 값을 넣으면 적용이 된다.
			 * 다만, LMS7 프로젝트는 현재 context가 아닌 다른 context에게도 정보를 요청해오고 있기 때문에, 이에 대한 localeKey값을 전부 통일해주어야 한다.
			 * default 값은 ko이며, 초기 접속시 모든 값이 ko로 셋팅되어 있다.
			 * 이후, 새로운 parameter(lang)값이 들어오면, SessionInfo에 저장된 localeKey값과 SessionLocaleResolver값을 변경한다.
			 * 이후, ajax 요청에 의한 다른 context 정보 조회시에, userbroker값을 먼저 확인한 후, SessionLocaleResolver의 값을 변경해준다.
			 */
			if(request.getParameter("lang") != null && request.getParameter("lang") != SessionInfo.getSysLocalkey(request)) {
			    SessionInfo.setSysLocalkey(request, request.getParameter("lang"));
			    LocaleUtil.setLocale(request, request.getParameter("lang"));
			    //System.out.println("change localeKey : " + request.getParameter("lang"));
			}
			
			if(SessionInfo.getSysLocalkey(request) != LocaleUtil.getLocale(request).toString()) {
			    LocaleUtil.setLocale(request, SessionInfo.getSysLocalkey(request));
			}

			//-- 사이트 관리자 접속시 로컬 접속이 아니면 IP를 검사하여 권한 체크를 한다.
			OrgConnIpService orgConnIpService = WebApplicationContextUtils
					.getWebApplicationContext(request.getSession().getServletContext())
					.getBean(OrgConnIpService.class);

			OrgCfgVO ocvo = new OrgCfgVO();
			ocvo.setCfgCtgrCd("CONN_IP");
			ocvo.setCfgCd("MANAGE");
			ocvo.setOrgId(orgId);
			//String connIpManage = orgCfgService.getValue(ocvo);
			String connIpManage = getValue(ocvo,request);
			if("Y".equals(StringUtil.nvl(connIpManage,""))) {
				if(Action.indexOf("Mgr") > 0 && !"127.0.0.1".equals(remoteIp) && !"0:0:0:0:0:0:0:1".equals(remoteIp)) {
					OrgConnIpVO ocivo = new OrgConnIpVO();
					ocivo.setOrgId(SessionInfo.getOrgId(request));
					ocivo.setRemoteIp(HttpRequestUtil.getIpAddr(request));
					if(orgConnIpService.orgConnIpAuth(ocivo) == false) {
						throw new AccessDeniedException("common.message.security.badrequest");
					}
				}
			}
			
			//-- 로그인 하지 않은 경우 게스트로 취급.
			if("".equals(userType))  userType = "GUEST";

			String viewAuth = "Y";
			String creAuth = "Y";
			//.do java 모듈일 경우만 권한 검사함.
			OrgCodeMemService orgCodeMemService = WebApplicationContextUtils
                    .getWebApplicationContext(request.getSession().getServletContext())
                    .getBean(OrgCodeMemService.class);

		    if(siteAuthCd.equals("ADM")== false) {
		        //-- 홈페이지인 경우 기관의 권한을 체크한다.
		        OrgMenuVO orgMenuVO = new OrgMenuVO();
		        orgMenuVO.setOrgId(orgId);
		        orgMenuVO.setMenuCd(menuCode);
		        orgMenuVO.setAuthrtCd(userType);
		        orgMenuVO.setAuthrtGrpcd(siteAuthCd);
		        
		        if(Action.matches(".*/Form/.*")) {	            
		            // 언어 목록 조회
		            //List<OrgCodeVO> langList = orgCodeMemService.getOrgCodeList("LANG_CD",orgId);
		            List<OrgCodeVO> langList = getOrgCodeList("LANG_CD",orgId,request);
		            String LOCALEKEY = SessionInfo.getLocaleKey(request);
		            
		            for(OrgCodeVO codeVO : langList) {
		                for(OrgCodeLangVO codeLangVO : codeVO.getCodeLangList()) {
		                    if(LOCALEKEY.equals(codeLangVO.getLangCd())) codeVO.setCdnm(codeLangVO.getCdnm());
		                }
		            }
		            
		            request.setAttribute("langList", langList);
		        }
		        
		        if(!isAnonmousAuthorize(Action) && StringUtil.nvl(menuCode).equals("")==false) {
		            try {
		                OrgMenuVO omvo = new OrgMenuVO();
		                omvo.setOrgId(orgId);
		                omvo.setMenuCd(menuCode);
		                omvo.setAuthrtCd(SessionInfo.getAuthrtCd(request)+"|"+SessionInfo.getClassUserType(request)+"|"+SessionInfo.getMngType(request));
		                //-- 메뉴 타입 조회
		                try {
                            omvo = orgMenuService.viewAuthorizeByMenu(omvo);
                        } catch(Exception e) {
                            omvo = null;
                        }
		                if(omvo != null) {
		                    orgMenuVO = omvo;
		                }
		            } catch (EmptyResultDataAccessException ex) {
		                throw new AccessDeniedException("common.message.security.badrequest");
		            }
		            
		            viewAuth = orgMenuVO.getViewAuth();
		            creAuth = orgMenuVO.getCreAuth();
		        }
		        
		        
		    } else {
		        //-- 권한 설정 검색
		        SysMenuVO sysMenuVO = new SysMenuVO();
		        sysMenuVO.setAuthrtCd(userType);
		        sysMenuVO.setMenuCd(menuCode);
		        sysMenuVO.setAuthrtGrpcd(siteAuthCd);
		        //-- 메뉴 타입 조회
		        
		        if(Action.matches(".*/Form/.*")) {
    		        //메뉴타입별 권한조회
    		        SysAuthGrpVO sagvo = new SysAuthGrpVO();
    		        sagvo.setAuthrtGrpcd(siteAuthCd);
    		        sagvo.setUseYn("Y");
    		        List<SysAuthGrpVO> authGrpList = sysMenuService.listAuthGrp(sagvo).getReturnList();
    		        String[] userTypeArray = userType.split("\\|");
    		        //권한 여러개일때 권한 우선순위로 정함
    		        if(userTypeArray.length > 2) {
    		            for(SysAuthGrpVO sysAuthGrpVO : authGrpList) {
    		                if(userType.contains(sysAuthGrpVO.getAuthrtGrpcd())) {
    		                    userType = sysAuthGrpVO.getAuthrtGrpcd();
    		                    break;
    		                }
    		            }
    		        }
    		        
    		        // 권한별 메뉴별 조회
    		        //메뉴조회
    		        List<SysMenuVO> sysMenuList = new ArrayList<SysMenuVO>();
    		        if(siteAuthCd.equals("MANAGE")== true) {
    		            sysMenuList = listAuthGrpMenuWithCache("MANAGE",userType,request);
    		        }else if(siteAuthCd.equals("ADM")== true) {
    		            sysMenuList = listAuthGrpMenuWithCache("ADM",userType,request);
    		        }else {
    		            sysMenuList = listAuthGrpMenuWithCache("HOME",userType,request);
    		        }
    		        
    		        request.setAttribute("sysMenuList",sysMenuList);
    		        
    		        
    		        // 언어 목록 조회
    		        List<OrgCodeVO> langList = orgCodeMemService.getOrgCodeList("LANG_CD",orgId);
    		        String LOCALEKEY = SessionInfo.getLocaleKey(request);
    		        
    		        for(OrgCodeVO codeVO : langList) {
    		            for(OrgCodeLangVO codeLangVO : codeVO.getCodeLangList()) {
    		                if(LOCALEKEY.equals(codeLangVO.getLangCd())) codeVO.setCdnm(codeLangVO.getCdnm());
    		            }
    		        }
    		        
    		        request.setAttribute("langList", langList);
		        }
		        
		        if(!isAnonmousAuthorize(Action) && StringUtil.nvl(menuCode).equals("")==false) {
		            sysMenuVO = sysMenuService.viewMenuByAuth(sysMenuVO);
		            if(ValidationUtils.isEmpty(sysMenuVO)) {
		                
		                //관리자에서 미리보기로 인해 현재 메뉴코들를 잃어벼렸을때 저장해둔 임시 메뉴코드가 있으면 다시 넣어준다.
		                String tempMenuCode = SessionInfo.getTempMenuCode(request);
		                String tempMenuName = SessionInfo.getTempMenuName(request);
		                String tempLocation = SessionInfo.getTempMenuLocation(request);
		                if(tempMenuCode != null){
		                    sysMenuVO = new SysMenuVO();
		                    sysMenuVO.setMenuCd(tempMenuCode);
		                    sysMenuVO.setAuthrtCd(userType);
		                    
		                    SessionInfo.setMenuCode(request, tempMenuCode);
		                    SessionInfo.setMenuName(request, tempMenuName);
		                    SessionInfo.setMenuLocation(request, tempLocation);
		                    
		                    SessionInfo.removeSession(request, CommConst.TEMP_CUR_MENU_CODE);
		                    SessionInfo.removeSession(request, CommConst.TEMP_CUR_MENU_NAME);
		                    SessionInfo.removeSession(request, CommConst.TEMP_MENU_LOCATION);
		                }
		                sysMenuVO = sysMenuService.viewMenuByAuth(sysMenuVO);
		                
		                if(ValidationUtils.isEmpty(sysMenuVO)) {
		                    throw new AccessDeniedException("common.message.security.badrequest");
		                }
		            }
		            
		            viewAuth = sysMenuVO.getViewAuth();
		            creAuth = sysMenuVO.getCreAuth();   
		        }
		        
		    }
			
			//로그인 여부로 권한 체크
			if("".equals(SessionInfo.getUserId(request))){
			    //-- 로그인이 안되어 잇는 경우
			    if(isViewAuthorize(Action) && !"Y".equals(viewAuth) ) {
                    throw new SessionBrokenException("system.fail.session.expire");
                } else if( isCreateAuthorize(Action) && !"Y".equals(creAuth)){
                    throw new SessionBrokenException("system.fail.session.expire");
                } else {
                    // 권한 모델이 없는 경우...
                    if(!isAnonmousAuthorize(Action)) {
                        throw new SessionBrokenException("system.fail.login.msg");
                    }
                }
			}else {
			  //-- 로그인이 되어 있는 경우
                if( isCreateAuthorize(Action) && !"Y".equals(creAuth)) {
                    throw new AccessDeniedException("system.fail.auth.msg");
                } else if( isViewAuthorize(Action) && !"Y".equals(viewAuth)){
                    throw new AccessDeniedException("system.fail.auth.msg");
                } else {
                    // 권한 모델이 없는 경우...
                }
			}
		}
	}
	/**
	 * 로그인 체크 없이 사용할 수 있는 페이지 인지 판단 함. 
	 * @param action
	 * @return boolean
	 */
	private static boolean isAnonmousAuthorize(String Action) {
		return Action.matches(".*/mainHome/Form/main.*")
	        || Action.matches(".*/mainHome/main.*")        
		    || Action.matches(".*/user/userHome/Form/idpwFindForm.*")   
		    || Action.matches(".*/user/userHome/Form/idFindResult.*")   
		    || Action.matches(".*/user/userHome/Form/pwFindResult.*")
		    || Action.matches(".*/user/userHome/findPass.*")
		    || Action.matches(".*/user/userHome/otp.*")
            || Action.matches(".*/user/userPop/otp.*")
			|| Action.matches(".*/goMenuPage.*")
			|| Action.matches(".*/*login.*") 
			|| Action.matches(".*/*logout.*") 
			|| Action.matches(".*/*join.*") 
			|| Action.matches(".*/*changeLang.*")
			|| Action.matches(".*/*apiCallback.*")
			|| Action.matches(".*/cms/Cms.*")
			|| Action.matches(".*/bbs/bbsHome.*")
			|| Action.matches(".*/sse/.*") //SSE 모듈 관련 
			|| Action.matches(".*/api/.*") // 로그인 필요없이 호출 필요한 패턴
			|| Action.matches(".*/commonutil/.*")
			|| Action.matches(".*/DocZoomCheck/.*")
			|| Action.matches(".*/DocZoomSsoCheck/.*")
			;
	}
	
	/**
	 * 보기 권한을 체크 해야 하는 페이지 인지 판단함.
	 * 쓰기 권한을 체크해야 하는 페이지는 보기 권한을 체크해야 하는 페이지로 판단.
	 * @param action
	 * @return
	 */
	private static boolean isViewAuthorize(String Action) {
		return !isCreateAuthorize(Action);
	}

	/**
	 * 쓰기 권한을 체크해야 하는 페이지 인지 판단 함.
	 * @param action
	 * @return
	 */
	private static boolean isCreateAuthorize(String Action) {
		
		return Action.matches(".*/*add.*")
			|| Action.matches(".*/*edit.*")
			|| Action.matches(".*/*delete.*") 
			|| Action.matches(".*/*remove.*")  
			|| Action.matches(".*/*sort.*")  
			|| Action.matches(".*/*write.*");
	}
	
	/**
	 * 이전 호출된 기능(url)과 같은 기능(유형)인지  판단 함.
	 * @param action
	 * @return
	 */
	private static boolean isSimilarAction(String Action, String referer) {
		String[] refererArr = StringUtil.split(StringUtil.nvl(referer),"/");
		String matchesValue = "";
		if(refererArr != null && refererArr.length > 4) {
			matchesValue = ".*/"+refererArr[3]+"/"+refererArr[4]+".*";
		} 
		return Action.matches(matchesValue);
		
		
	}
	
	/**
     * 버젼값을 비교한다.
     * @return true:변경됨, false:변경되지 않음
     */
    
    private static boolean isCacheChanged() throws Exception {
        return (version != compareVersion) ? true : false;
    }

    /**
     * 버전값이 변경되었음을 저장한다.
     */
    
    public static void setCacheChanged() throws Exception {
        int beforeVersion = version;
        cache.clear();
        compareVersion = beforeVersion+1;
    }
    
    /**
     * 버젼값을 비교한다.
     * @return true:변경됨, false:변경되지 않음
     */
    
    private static boolean isAuthCacheChanged() throws Exception {
    	return (authVersion != authCompareVersion) ? true : false;
    }
    
    /**
     * 버전값이 변경되었음을 저장한다.
     */
    
    public static void setAuthCacheChanged() throws Exception {
    	int beforeVersion = authVersion;
    	authCache.clear();
    	authCompareVersion = beforeVersion+1;
    }
    
    /**
     * 버젼값을 비교한다.
     * @return true:변경됨, false:변경되지 않음
     */
    
    private static boolean isOrgCacheChanged() throws Exception {
    	return (orgVersion != orgCompareVersion) ? true : false;
    }
    
    /**
     * 버전값이 변경되었음을 저장한다.
     */
    
    public static void setOrgCacheChanged() throws Exception {
    	int beforeVersion = orgVersion;
    	orgCache.clear();
    	orgCompareVersion = beforeVersion+1;
    }
    
    /**
     * 버젼값을 비교한다.
     * @return true:변경됨, false:변경되지 않음
     */
    
    private static boolean isCfgCacheChanged() throws Exception {
    	return (cfgVersion != cfgCompareVersion) ? true : false;
    }
    
    /**
     * 버전값이 변경되었음을 저장한다.
     */
    public static void setCfgCacheChanged() throws Exception {
    	int beforeVersion = cfgVersion;
    	cfgCache.clear();
    	cfgCompareVersion = beforeVersion+1;
    }
    
    /**
     * 메뉴타입에 따른 권한 리스트 가져온다.
     * @param OrgAuthGrpVO
     * @return List<OrgAuthGrpVO>
     * @throws Exception
     */
    @SuppressWarnings("unchecked")
    public static List<OrgAuthGrpVO> listAuthGrp(OrgAuthGrpVO oagvo,HttpServletRequest request) throws Exception {
        OrgMenuService orgMenuService = WebApplicationContextUtils
                .getWebApplicationContext(request.getSession().getServletContext())
                .getBean(OrgMenuService.class);
        
        String menuKey = oagvo.getAuthrtGrpcd()+"."+oagvo.getOrgId();

        if(isAuthCacheChanged()) {
            authCache.clear();
            authVersion += 1;
            authCompareVersion = authVersion;
        }
        
        if(!authCache.containsKey(menuKey)) {
            authCache.put(menuKey, orgMenuService.listAuthGrp(oagvo).getReturnList()); //캐시가 없는 경우 DB값을 가져옴.
        } else {
            //-- 캐시가 있는 경우 아무것도 안해도됨.
        }

        return (List<OrgAuthGrpVO>)authCache.get(menuKey);
    }
    
    /**
     * 기관의 권한 메뉴 조회
     * 하위 메뉴를 포함한 최상위 메뉴 VO를 반환함.
     * @param orgId : 기관 코드 (필수)
     * @param menuType : 메뉴 유형 (필수)
     * @param authGrpCd : 권한 (필수)
     * @return OrgMenuVO
     */
    public static OrgMenuVO listAuthGrpTreeMenu(String orgId,String menuType, String authGrpCd,HttpServletRequest request) throws Exception {
        SysMenuMemService sysMenuMemService = WebApplicationContextUtils
                .getWebApplicationContext(request.getSession().getServletContext())
                .getBean(SysMenuMemService.class);
        
        String menuKey = orgId+"."+menuType+"."+authGrpCd;
        OrgMenuVO rootMenu = null;

        if(isCacheChanged()) {
            cache.clear();
            version += 1;
            compareVersion = version;
        }

        if(!cache.containsKey(menuKey)) {
            cache.put(menuKey, sysMenuMemService.getOrgMenuList(orgId,menuType, authGrpCd)); //캐시가 없는 경우 DB값을 가져옴.
        } else {
            //-- 캐시가 있는 경우 아무것도 안해도됨.
        }
        rootMenu = (OrgMenuVO) cache.get(menuKey);
        return rootMenu;
    }
    
    /**
     * 캐쉬에서 해당 메뉴를 검색해서 반환한다.
     * DB에서 메뉴의 변경여부를 확인하고 변경되었을 경우 캐쉬를 비우는 역활도 이곳에서 한다.
     * @param menuType      메뉴 유형 (HOME, ADMIN, LEC)
     * @param authGrpCd     권한그룹코드
     * @param menuCd
     * @return List<SysMenuVO>
     */
    @SuppressWarnings("unchecked")
    private static List<SysMenuVO> listAuthGrpMenuWithCache(String menuType, String authGrpCd, HttpServletRequest request) throws Exception {
        SysMenuMemService sysMenuMemService = WebApplicationContextUtils
                .getWebApplicationContext(request.getSession().getServletContext())
                .getBean(SysMenuMemService.class);
        
        String menuKey = authGrpCd + "." + menuType;

        /*
         * 메뉴를 Hashtable에서 조회해 오는 기능입니다.
         * 캐시가 있을 경우 어떤 동작도 하지 않기 때문에 세션에 의한정보 노출에 
         * 해당하지 않습니다. 
         */
        // 변경이 감지되면 캐쉬를 비우고 메뉴 버젼값을 동기화한다.
        if(isCacheChanged()) {
            cache.clear();
            version += 1;
            compareVersion = version;
        }

        // 메모리에 로드되어 있지 않으면 DB에서 로딩..
        if(!cache.containsKey(menuKey)) {
            if("ADM".equals(menuType)) {
                cache.put(menuKey, sysMenuMemService.getAdmMenuList(authGrpCd));
            }else if("MANAGE".equals(menuType)) {
                cache.put(menuKey, sysMenuMemService.getMngMenuList(authGrpCd));
            }else if("LECT".equals(menuType)) {
                cache.put(menuKey, sysMenuMemService.getLecMenuList(authGrpCd));
            }else if("HOME".equals(menuType)) {
                cache.put(menuKey, sysMenuMemService.getHomeMenuList(authGrpCd));
            }
        } else {
          //-- 캐시가 있는 경우 아무것도 안해도됨.
        }

        // 캐쉬에서 루트메뉴 읽기
        return (List<SysMenuVO>)cache.get(menuKey);
    }
    
    /**
     * 기관코드 리스트를 반환한다.
     *
     * @param codeCtgrCd
     * @return
     */
    @SuppressWarnings("unchecked")
    public static List<OrgCodeVO> getOrgCodeList(String codeCtgrCd, String orgId,HttpServletRequest request) throws Exception {
        OrgCodeMemService orgCodeMemService = WebApplicationContextUtils
                .getWebApplicationContext(request.getSession().getServletContext())
                .getBean(OrgCodeMemService.class);
        
        String langCd = SessionInfo.getLocaleKey(request);
        String menuKey = codeCtgrCd+"."+orgId+"."+langCd;

        if(isOrgCacheChanged()) {
            orgCache.clear();
            orgVersion += 1;
            orgCompareVersion = orgVersion;
        }
        
        if(!orgCache.containsKey(menuKey)) {
            orgCache.put(menuKey, orgCodeMemService.getOrgCodeList(codeCtgrCd,orgId)); //캐시가 없는 경우 DB값을 가져옴.
        } else {
            //-- 캐시가 있는 경우 아무것도 안해도됨.
        }

        return (List<OrgCodeVO>)orgCache.get(menuKey);
    }
    
    /**
     * 설정 정보 상세 정보를 조회한다.
     * @param cfgCtgrCd
     * @param cfgCd
     * @return OrgCfgCtgrVO
     * @throws Exception
     */
    public static String getValue(OrgCfgVO vo, HttpServletRequest request) throws Exception {
        OrgCfgService orgCfgService = WebApplicationContextUtils
                .getWebApplicationContext(request.getSession().getServletContext())
                .getBean(OrgCfgService.class);
        
        String menuKey = vo.getCfgCtgrCd()+"."+vo.getCfgCd();

        if(isCfgCacheChanged()) {
            cfgCache.clear();
            cfgVersion += 1;
            cfgCompareVersion = cfgVersion;
        }
        
        if(!cfgCache.containsKey(menuKey)) {
            cfgCache.put(menuKey, orgCfgService.getValue(vo)); //캐시가 없는 경우 DB값을 가져옴.
        } else {
            //-- 캐시가 있는 경우 아무것도 안해도됨.
        }

        return (String)cfgCache.get(menuKey);
    }
	
    /***************************************************** 
     *로그인 패스워드 암호화 적용 (고객사 암호화 알고리즘 변경시 수정)
     * @param strValue
     * @return
     ******************************************************/ 
    public static String loginPwdEncrypt(String strValue) {
        
        // return KISASeed.seed256HashEncryption(strValue);
        return CryptoUtil.encryptSha(strValue);
    }
    
    public static Hashtable<String, Object> getAuthCache() {
    	return authCache;
    }
}