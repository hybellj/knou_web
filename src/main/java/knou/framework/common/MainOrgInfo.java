package knou.framework.common;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import knou.lms.org.service.OrgInfoService;
import knou.lms.org.vo.OrgInfoVO;

/**
 * 메인 기관정보
 * @author shil
 *
 */
public class MainOrgInfo {

	private static List<OrgInfoVO> ORG_LIST = null;
	private static Map<String, OrgInfoVO> ORG_MAP = null;
	
	/**
	 * 기관 목록
	 * @param request
	 * @return
	 * @throws Exception
	 */
	public static List<OrgInfoVO> getMainOrgList(HttpServletRequest request) throws Exception {
		List<OrgInfoVO> orgList = null;
		if (ORG_LIST == null) {
			ApplicationContext applicationContext = WebApplicationContextUtils.getWebApplicationContext(request.getSession().getServletContext());
			OrgInfoService orgInfoService = (OrgInfoService)applicationContext.getBean("orgInfoService");
			orgList = orgInfoService.listActiveOrg();
			ORG_LIST = orgList;
			if (orgList != null && orgList.size() > 0) {
				ORG_MAP = new HashMap<>();
				for (OrgInfoVO orgInfoVO : orgList) {
					ORG_MAP.put(orgInfoVO.getOrgId(), orgInfoVO);
				}
				
			}
		}
		else {
			orgList = ORG_LIST;
		}
		
		if (orgList == null) {
			orgList = new ArrayList<OrgInfoVO>();
		}
		
		return orgList;
	}

	/**
	 * 주소에서 기관 도메인명 반환
	 * @param request
	 * @return
	 */
	public static String getOrgDomain(HttpServletRequest request) {
		String orgDomain = "";
		
		try {
			String uri = request.getRequestURI();
			if (uri.indexOf("/", uri.length()-1) > -1) {
        		uri = uri.substring(0,uri.length()-1);
        	}
			List<OrgInfoVO> orgList = getMainOrgList((HttpServletRequest)request);
			String orgId = "";
			for (OrgInfoVO orgInfoVO : orgList) {
				orgId = "/"+orgInfoVO.getDmnnm();
				if (orgId.equalsIgnoreCase(uri)) {
					orgDomain = orgInfoVO.getDmnnm();
					continue;
				}
			}
			
		} catch (Exception e) {
		}
		
		return orgDomain;
	}
	
	/**
	 * orgId값으로 도메인명 반환
	 * @param request
	 * @param orgId
	 * @return
	 */
	public static String getOrgDomain(HttpServletRequest request, String orgId) {
		String orgDomain = "";
		
		try {
			if (ORG_MAP == null) {
				getMainOrgList(request);
			}
			
			if (ORG_MAP != null && ORG_MAP.containsKey(orgId)) {
				orgDomain = ((OrgInfoVO)ORG_MAP.get(orgId)).getDmnnm();
			}
			
		} catch (Exception e) {
		}
		
		return orgDomain;
	}
	
	/**
	 * 기관 언어 반환
	 * @param request
	 * @param orgId
	 * @return
	 */
	public static String getOrgLang(HttpServletRequest request, String orgId) {
		String lang = "ko";
		
		try {
			if (ORG_MAP == null) {
				getMainOrgList(request);
			}
			
			if (ORG_MAP != null && ORG_MAP.containsKey(orgId)) {
				lang = ((OrgInfoVO)ORG_MAP.get(orgId)).getBscLangCd();
			}
			
		} catch (Exception e) {
		}
		
		return lang;
	}
	
	/**
	 * 기관 언어 반환
	 * @param request
	 * @param orgId
	 * @return
	 */
	public static String getOrgLang(String orgId) {
		String lang = "ko";
		
		try {
			if (ORG_MAP != null && ORG_MAP.containsKey(orgId)) {
				lang = ((OrgInfoVO)ORG_MAP.get(orgId)).getBscLangCd();
			}
			
		} catch (Exception e) {
		}
		
		return lang;
	}
}
