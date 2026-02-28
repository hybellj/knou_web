package knou.framework.util;

import java.util.Enumeration;

import javax.servlet.http.HttpServletRequest;

import knou.framework.common.CommConst;


public class HttpRequestUtil {

	private HttpRequestUtil() {}	// 기본 생성자 차단

	/**
	 * 전체 URI 문자열에서 호스트 URL까지만 추출한다.(http://aaa.bbb.ccom)
	 * @param url
	 * @return
	 */
	public static String getServerURL(String url) {
		return url.substring(0, url.indexOf("/", url.indexOf("/")+2));
	}

	/**
	 * Request의 요청 URL에서 호스트 URL까지만 추출한다.(http://aaa.bbb.ccom)
	 * @param url
	 * @return
	 */
	public static String getServerURL(HttpServletRequest request) {
		return getServerURL(request.getRequestURL().toString());
	}

	/**
	 * Request의 요청을 URLBuilder로 변환해서 반환한다.<br>
	 * Context 경로를 제거한다.
	 * @param request
	 * @return
	 */
	public static URLBuilder requestToUrlBuilder(HttpServletRequest request) {

		Enumeration<String> keys = request.getParameterNames();
		URLBuilder urlBuilder = new URLBuilder(request.getRequestURI().replaceAll(CommConst.CONTEXT_ROOT, ""));

		while(keys.hasMoreElements()) {
			String key = keys.nextElement();
			urlBuilder.addParameter(key, request.getParameter(key));
		}
		return urlBuilder;
	}

	/**
	 * Request의 파라매터를 추출해서 URLBuilder에 추가한다.
	 * @param request 파라매터가 담긴 request
	 * @param urlBuilder 파라매터를 추가할 UrlBuilder
	 */
	public static void requestParamToUrlBuilder(HttpServletRequest request, URLBuilder urlBuilder) {
		Enumeration<String> keys = request.getParameterNames();
		
		while(keys.hasMoreElements()) {
			String key = keys.nextElement();
			urlBuilder.addParameter(key, request.getParameter(key));
		}
	}

	/**
	 * Web server가 세팅되어 있으면 getRemoteAddr로 실제 사용자 IP 얻을수 없는 경우가 있음.
	 * 해당 경우 Web server에서 헤더에 실제 사용자의 ip를 넘겨줌. 
	 * Web server 설정마다 다름.
	 */
    public static String getIpAddr(HttpServletRequest request) {
    	
    	String ip = request.getHeader("CLIENT-IP");
    	if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {  
            ip = request.getHeader("X-Forwarded-For");  
        }
        if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {  
            ip = request.getHeader("Proxy-Client-IP");  
        }  
        if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {  
            ip = request.getHeader("WL-Proxy-Client-IP");  
        }  
        if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {  
            ip = request.getHeader("HTTP_CLIENT_IP");  
        }  
        if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {  
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");  
        }  
        if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {  
            ip = request.getRemoteAddr();  
        }
		return StringUtil.nvl(ip);
    }
    
    /**
     * 학습로그 저장시 브라우저 
     * @param userAgent
     * @return
     */
    public static String getStudyBrowserCd(HttpServletRequest request) {
        
    	String userAgent = request.getHeader("User-Agent").toUpperCase();
    	if(userAgent.indexOf("TRIDENT") > -1) { return "IE";
    	} else if(userAgent.indexOf("CHROME") > -1) { return "CHROME";
    	} else if(userAgent.indexOf("EDGE") > -1) { return "EDGE";
        } else if(userAgent.indexOf("WHALE") > -1) { return "WHALE";
        } else if(userAgent.indexOf("OPERA") > -1 || userAgent.indexOf("OPR") > -1) { return "OPERA";
        } else if(userAgent.indexOf("FIREFOX") > -1) { return "FIREFOX";
        } else if(userAgent.indexOf("SAFARI") > -1) { return "SAFARI";
        } else { return "unkown"; }
    }
    
    public static String getStudyDeviceCd(HttpServletRequest request) {

    	String userAgent = request.getHeader("User-Agent").toUpperCase();
    	if(userAgent.indexOf("MOBILE") > -1) {
          if(userAgent.indexOf("PHONE") > -1) { return "PHONE";
          } else { return "TABLET"; }
    	} else { return"PC"; }
    }
    
    public static String getStudyClientEnv(HttpServletRequest request) {

    	String userAgent = request.getHeader("User-Agent").toUpperCase();
    	if(userAgent.indexOf("WINDOWS") > -1) { return "WINDOWS";
         } else if(userAgent.indexOf("MAC") > -1) { return "MAC";
         } else if(userAgent.indexOf("X11") > -1) { return "UNIX";
         } else if(userAgent.indexOf("LINUX") > -1) { return "LINUX";
         } else if(userAgent.indexOf("ANDROID") > -1) { return "ANDROID";
         } else if(userAgent.indexOf("IPHONE") > -1) { return "IPHONE";
         } else if(userAgent.indexOf("IPAD") > -1) { return "IPAD";
         } else if(userAgent.indexOf("IOS") > -1) { return "IOS";
         } else { return "unkown"; }
    }

}
