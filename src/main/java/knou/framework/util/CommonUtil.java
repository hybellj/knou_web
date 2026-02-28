package knou.framework.util;

import java.io.FileInputStream;
import java.io.InputStream;
import java.lang.reflect.Method;
import java.util.HashMap;

import javax.activation.MimetypesFileTypeMap;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.BeanUtils;
import org.springframework.context.i18n.LocaleContextHolder;

/**
 * 공통 유틸리티
 */
public class CommonUtil {
	// MIME type map
	private static MimetypesFileTypeMap MIME_TYPES_MAP = null;
	
	/**
	 * Get IP Address
	 * @param request
	 * @return IP Address
	 */
	public static String getIpAddress(HttpServletRequest request) {
		String ip = request.getHeader("X-FORWARDED-FOR"); 
        	
        // proxy
        if (ip == null || ip.length() == 0) {
            ip = request.getHeader("Proxy-Client-IP");
        }

        // weblogic
        if (ip == null || ip.length() == 0) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }

        if (ip == null || ip.length() == 0) {
            ip = request.getRemoteAddr() ;
        }
		
        String[] ips = ip.split(",");
        if (ips.length > 1) {
            ip = ips[0];
        }
        
        //Inet4Address.getLocalHost().getHostAddress()
        
		return ip;
	}
	
	
	/**
	 * 객체 프로퍼티 복사
	 * @param source
	 * @param target
	 */
	public static void copyProperties(Object source, Object target) {
		BeanUtils.copyProperties(source, target);
	}
	
	
	/**
	 * 브라우져 타입 가져오기
	 * @param request
	 * @return browser
	 */
	public static String getBrowser(HttpServletRequest request) {
		String header = request.getHeader("User-Agent").toLowerCase();
		String browser = "etc";
		
		if (header.indexOf("hycuapp") > -1) {
            browser = "hycuapp";
        }
		if (header.indexOf("msie") > -1) {
			browser = "msie";
		} 
		else if (header.indexOf("edg") > -1) {
			browser = "edge";
		}
		else if (header.indexOf("trident") > -1) {
			browser = "trident";
		} 
		else if (header.indexOf("chrome") > -1) {
			browser = "chrome";
		} 
		else if (header.indexOf("opera") > -1) {
			browser = "opera";
		} 
		else if (header.indexOf("safari") > -1) {
			browser = "safari";
		}
		else if (header.indexOf("firefox") > -1) {
            browser = "firefox";
        }

		return browser;
	}
	
	
	/**
	 * MIME type 가져오기
	 * @param fileName
	 * @return mimeType
	 */
	public static String getMimeType(String fileName) {
		String mimeType = "";
		
		if (MIME_TYPES_MAP == null) {
			try {
				String currDir = CommonUtil.class.getResource(".").getPath();
				currDir = currDir.substring(0, currDir.indexOf("WEB-INF"));
			
				InputStream imageStream = new FileInputStream(currDir+"/META-INF/mime.types");
				MIME_TYPES_MAP = new MimetypesFileTypeMap(imageStream);
			} 
			catch (Exception e) {
				MIME_TYPES_MAP = new MimetypesFileTypeMap();
			}
		}
		
		mimeType = MIME_TYPES_MAP.getContentType(fileName);
		
		String ext = FileUtil.getFileExtention(fileName);
		if ("hwp".equals(ext)) mimeType = "application/x-hwp";
		else if ("pdf".equals(ext)) mimeType = "application/pdf";
		else if ("doc".equals(ext) || "docx".equals(ext)) mimeType = "application/msword";
		else if ("xls".equals(ext) || "xlsx".equals(ext)) mimeType = "application/ms-excel";
		else if ("ppt".equals(ext) || "pptx".equals(ext)) mimeType = "application/ms-powerpoint";
		else if ("zip".equals(ext)) mimeType = "application/zip";
		else if ("jpg".equals(ext) || "jpeg".equals(ext)) mimeType = "image/jpg";
		else if ("txt".equals(ext)) mimeType = "textplain";
		
		return mimeType;
	}
	
	
	/**
	 * 클래스에서 지정한 변수의 Get/Set 메쏘드 가져오기 
	 * @param clazz
	 * @param name
	 * @return HashMap<String, Method>
	 */
	public static HashMap<String, Method> getMethod(Class<?> clazz, String name) {
		HashMap<String, Method> methodMap = new HashMap<>();
		String mthName = name.substring(0,1).toUpperCase()+name.substring(1);
		
		Method[] methods = clazz.getMethods();
		for (Method method : methods) {
			String methodName = method.getName();
			if (method.getName().equals("get"+mthName) || method.getName().equals("is"+mthName)) {
				methodMap.put("get", method);
			}
			else if (methodName.equals("set"+mthName)) {
				methodMap.put("set", method);
			}
			
			if (methodMap.size() == 2) {
				break;
			}
		}
		
		return methodMap;
	}
	
	
	/**
	 * 언어 가져오기
	 * @return language
	 */
	public static String getLanguage() {
		String language = LocaleContextHolder.getLocale().toString();
		
		if (language.equals("ko_KR")) {
			language = "ko";
		}
		else if (language.equals("en_US")) {
			language = "en";
		}
		else if (language.equals("ja_JP")) {
			language = "ja";
		}
		
		return language;
	}
	
	
	/**
     * 사용자 OS 가져오기
     * @param request
     * @return os
     */
	public static String getClientOS(HttpServletRequest request) {
	    String userAgent = request.getHeader("User-Agent");
	    String os = "";            
	    userAgent = userAgent.toLowerCase();
	    
	    if (userAgent.indexOf("windows nt 10.0") > -1) {
	        os = "Windows10";
	    }else if (userAgent.indexOf("windows nt 6.1") > -1) {
	        os = "Windows7";
	    }else if (userAgent.indexOf("windows nt 6.2") > -1 || userAgent.indexOf("windows nt 6.3") > -1 ) {
	        os = "Windows8";
	    }else if (userAgent.indexOf("windows nt 6.0") > -1) {
	        os = "WindowsVista";
	    }else if (userAgent.indexOf("windows nt 5.1") > -1) {
	        os = "WindowsXP";
	    }else if (userAgent.indexOf("windows nt 5.0") > -1) {
	        os = "Windows2000";
	    }else if (userAgent.indexOf("windows nt 4.0") > -1) {
	        os = "WindowsNT";
	    }else if (userAgent.indexOf("windows 98") > -1) {
	        os = "Windows98";
	    }else if (userAgent.indexOf("windows 95") > -1) {
	        os = "Windows95";
	    }else if (userAgent.indexOf("iphone") > -1) {
	        os = "iPhone";
	    }else if (userAgent.indexOf("ipad") > -1) {
	        os = "iPad";
	    }else if (userAgent.indexOf("android") > -1) {
	        os = "android";
	    }else if (userAgent.indexOf("mac") > -1) {
	        os = "mac";
	    }else if (userAgent.indexOf("linux") > -1) {
	        os = "Linux";
	    }else{
	        os = "Other";
	    }
	    return os;
	}
	
	/**
	 * 디바이스 구분 가져오기
	 * @param request
	 * @return
	 */
	public static String getDeviceType(HttpServletRequest request) {
	    String userAgent = request.getHeader("User-Agent").toLowerCase();
	    String deviceType = "PC";
	    
	    if(userAgent.indexOf("hycuapp") > -1 || userAgent.indexOf("android") > -1 
	            || userAgent.indexOf("iphone") > -1 || userAgent.indexOf("ipad") > -1 || userAgent.indexOf("ipod") > -1) {
	        deviceType = "mobile";
	    }
	    
	    return deviceType;
    }
}
