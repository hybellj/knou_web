package knou.framework.tlds;

import javax.servlet.jsp.tagext.TagSupport;

public class CommonTag extends TagSupport {

	/**
     * NULL값확인
     * @param	value
     * @param	defaultValue
     * @return
     */
	public static String defaultIfEmpty(Object value, String defaultValue) {
        if (value == null) return defaultValue;
        if (value instanceof String && ((String) value).trim().isEmpty()) {
            return defaultValue;
        }
        return value.toString();
    }
	
	/**
     * 날짜 포맷 변환
     * @param value YYYYMMDD or YYYYMMDDHH24MISS
     * @param sep   구분자 ("-", ".", "/")
     * @return 포맷된 날짜
     */
    public static String dateFormat(String value, String sep) {
        if (value == null || value.length() < 8) {
            return "";
        }
        try {
            String yyyy = value.substring(0, 4);
            String mm   = value.substring(4, 6);
            String dd   = value.substring(6, 8);

            return yyyy + sep + mm + sep + dd;
        } catch (Exception e) {
            return value;
        }
    }
}