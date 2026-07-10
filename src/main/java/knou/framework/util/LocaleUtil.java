package knou.framework.util;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import knou.framework.context2.UserContext;

public class LocaleUtil {
	private static Log log = LogFactory.getLog(LocaleUtil.class);

    /**
     * 기본 로케일을 리턴한다. 기본은 한글이다.
     */
    public static Locale getDefaultLocale() {
        return Locale.KOREAN;
    }

    /**
     *  HttpServletRequest 를 받아서 저장되어 있를 locale 값을 리턴한다. 없는 경우는 기본 로케일을 리턴한다.
     */
    public static Locale getLocale(HttpServletRequest request) {
        Locale locale = null;
        HttpSession session = request.getSession();
        locale = (Locale)session.getAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME);

        if (locale == null ) {
            locale = getDefaultLocale();
        }
        return locale;
    }

    /**
     * 로케일 설정
     * @param request
     * @param userCtx
     */
    public static void setLocale(HttpServletRequest request, UserContext userCtx) {
    	try {
        	if (userCtx != null) {
    	    	String userEnvStngCts = userCtx.getLoginUser().getUserEnvStngCts();
    	    	String langCd = null;

    			if ( userEnvStngCts != null && !"".equals(userEnvStngCts)) {
    				JSONParser parser = new JSONParser();
    				JSONObject jsonObject = (JSONObject) parser.parse(userEnvStngCts);

    				if (jsonObject.containsKey("langCd")) {
    					langCd = (String) jsonObject.get("langCd");
    				}
    			}

    			userCtx.setLangCd(langCd == null || "".equals(langCd) ? "ko" : langCd);

    	    	setLocale(request, langCd);
        	}
    	}
    	catch (Exception e) {
			log.error(e.getMessage());
		}
    }

    /**
     * 로케일 설정
     * @param request
     * @param locale
     */
    public static void setLocale(HttpServletRequest request, String locale) {
        Locale lo = null;
        HttpSession session = request.getSession();

        if (locale == null || locale.isEmpty()) {
            lo = Locale.KOREAN;
        } else if (locale.matches("en")) {
        	lo = Locale.ENGLISH;
        } else if (locale.matches("es")) {
        	lo = new Locale.Builder().setLanguage("es").setRegion("ES").build();
        } else if (locale.matches("ar")) {
        	lo = new Locale.Builder().setLanguage("ar").setRegion("AE").build();
        } else if (locale.matches("ru")) {
        	lo = new Locale.Builder().setLanguage("ru").setRegion("RU").build();
        }else if (locale.matches("fr")) {
        	lo = Locale.FRANCE;
        } else if (locale.matches("zh")) {
        	lo = Locale.CHINESE;
        } else if (locale.matches("ja")) {
        	lo = Locale.JAPANESE;
        } else {
        	lo = Locale.KOREAN;
        }
        session.setAttribute(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME, lo);
    }

    /**
     * 언어코드 가져오기
     * @param request
     * @return
     */
    public static String getLangCd(HttpServletRequest request) {
    	Locale locale = LocaleUtil.getLocale(request);
	    String langCd = locale.getLanguage();

	    if (langCd == null || "".equals(langCd)) {
	    	langCd = "ko";
	    }

	    return langCd;
    }
}
