package knou.framework.util;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.NumberFormat;
import java.text.StringCharacterIterator;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import jregex.RETokenizer;

/**
 * String Utilities
 */
public class StringUtil {

    protected static Logger log = Logger.getLogger(StringUtil.class);

    /**
     * String.substring(int start, int end) 대체
     * NullPointException 방지
     */
    public static String substring(String src, int start, int end){
        if(src == null || "".equals(src) || start > src.length() || start > end || start < 0) return "";
        if(end > src.length()) end = src.length();

        return src.substring(start, end);
    }

    /**
     * 캐릭터셋 엔코딩
     * @param value
     * @param encoding
     * @return
     */
    public static String encodingCharset(String value, String encoding) {
        try {
            if(value != null) {
                String[] params = encoding.split("\\|");
                if(params.length < 2) {
                    return value;
                }
                String charSet1 = params[0];
                String charSet2 = params[1];

                if(!charSet1.equalsIgnoreCase(charSet2)) {
                    value = new String(value.getBytes(charSet1), charSet2);
                }
            }
        } catch(UnsupportedEncodingException e) {
            return value;
        }
        return value;
    }


    /**
     * 스트링 치환 함수
     * 주어진 문자열(buffer)에서 특정문자열('src')를 찾아 특정문자열('dst')로 치환
     */
    public static String ReplaceAll(String buffer, String src, String dst){
        if(buffer == null) return null;
        if(buffer.indexOf(src) < 0) return buffer;

        int bufLen = buffer.length();
        int srcLen = src.length();
        StringBuffer result = new StringBuffer();

        int i = 0;
        int j = 0;
        for(; i < bufLen; ){
            j = buffer.indexOf(src, j);
            if(j >= 0) {
                result.append(buffer.substring(i, j));
                result.append(dst);

                j += srcLen;
                i = j;
            }else break;
        }
        result.append(buffer.substring(i));
        return result.toString();
    }

    /**
     * 파라미터 스트링이 null or "" 이면 true, 아니면 false
     * @param param 검사 문자열
     * @return 검사결과
     */
    public static boolean isNull(String param){
        if(param == null || "".equals(param)) return true;
        else return false;
    }

    /**
     * 파라미터 스트링이 null 이 아니고, "" 이 아니면 true, 아니면 false
     * @param param 검사 문자열
     * @return 검사결과
     */
    public static boolean isNotNull(String param){
        if(param != null && !"".equals(param)) return true;
        else return false;
    }
    
    /**
     * 객체가 null 인지 체크
     * @param param
     * @return 검사결과
     */
    public static boolean isNull(Object param){
        if(param == null) return true;
        else return false;
    }

    /**
     * 객체가 null이 아닌지 체크
     * @param param
     * @return 검사결과
     */
    public static boolean isNotNull(Object param){
        if(param != null) return true;
        else return false;
    }
    
    /**
     * 문자열을 Form의 Input Text에 삽입할때 문자 변환
     * @param str
     * @return
     */
    public static String fn_html_text_convert(String str) {
        if(str == null || str.equals("")) {
            return  "";
        }
        else {
            char schr1 = '\'';
            char schr2 = '\"';
            char schr3 = '<';
            char schr4 = '>';
            StringBuffer sb = new StringBuffer(str);
            int idx_str = 0;
            int edx_str = 0;

            while(idx_str >= 0) {
                idx_str = str.indexOf(schr1, edx_str);
                if(idx_str < 0) {
                    break;
                }
                str = sb.replace(idx_str, idx_str+1, "&#39;").toString();
                edx_str = idx_str + 5;
            }

            sb = new StringBuffer(str);
            idx_str = 0;
            edx_str = 0;
            while(idx_str >= 0) {
                idx_str = str.indexOf(schr2, edx_str);
                if(idx_str < 0) {
                    break;
                }
                str = sb.replace(idx_str, idx_str+1, "&quot;").toString();
                edx_str = idx_str + 6;
            }

            sb = new StringBuffer(str);
            idx_str = 0;
            edx_str = 0;
            while(idx_str >= 0) {
                idx_str = str.indexOf(schr3, edx_str);
                if(idx_str < 0) {
                    break;
                }
                str = sb.replace(idx_str, idx_str+1, "&lt;").toString();
                edx_str = idx_str + 4;
            }
            sb = new StringBuffer(str);
            idx_str = 0;
            edx_str = 0;
            while(idx_str >= 0) {
                idx_str = str.indexOf(schr4, edx_str);
                if(idx_str < 0) {
                    break;
                }
                str = sb.replace(idx_str, idx_str+1, "&gt;").toString();
                edx_str = idx_str + 4;
            }
            return str;
        }
    }

    /**
     * 문자열을 Form의 Input Text에 삽입할때 문자 변환
     * @param str
     * @return
     */
    public static String fn_input_text(String str) {
        if(str == null || str.equals("")) {
            return  "";
        }
        else {
            char schr1 = '\'';
            char schr2 = '\"';
            StringBuffer sb = new StringBuffer(str);
            int idx_str = 0;
            int edx_str = 0;

            while(idx_str >= 0) {
                idx_str = str.indexOf(schr1, edx_str);
                if(idx_str < 0) {
                    break;
                }
                str = sb.replace(idx_str, idx_str+1, "&#39;").toString();
                edx_str = idx_str + 5;
            }

            sb = new StringBuffer(str);
            idx_str = 0;
            edx_str = 0;
            while(idx_str >= 0) {
                idx_str = str.indexOf(schr2, edx_str);
                if(idx_str < 0) {
                    break;
                }
                str = sb.replace(idx_str, idx_str+1, "&quot;").toString();
                edx_str = idx_str + 6;
            }
            return str;
        }
    }

    /**
     * null인 경우 ""를 return
     * @param value
     * @return
     */
    public static String nvl(String value) {
        return nvl(value, "");
    }

    /**
     * value가 null인 경우 defalult값을 return
     * @param value
     * @param defaultValue
     * @return
     */
    public static String nvl(String value, String defaultValue) {
        if(value == null || value.equals(""))
            return defaultValue;
        else
            return value;
    }

    /**
     * value가 null인 경우 defalult값을 return
     * @param value
     * @param defaultValue
     * @return
     */
    public static int nvl(String value, int defaultValue) {
        if(value == null || value.equals(""))
            return defaultValue;
        else
            return Integer.parseInt(value);
    }

    /**
     * null인 경우 ""를 return
     * @param value
     * @return
     */
    public static String nvl(Object value) {
        return nvl(value, "");
    }

    /**
     * value가 null인 경우 defalult값을 return
     * @param value
     * @param defaultValue
     * @return
     */
    public static String nvl(Object value, String defaultValue) {
        if(value == null) {
            return defaultValue;
        }
        else {
            if(value.toString().equals(""))
                return defaultValue;
            else
                return value.toString();
        }
    }

    /**
     * value가 null인 경우 defalult값을 return
     * @param value
     * @param defaultValue
     * @return
     */
    public static int nvl(Object value, int defaultValue) {
        if(value == null) {
            return defaultValue;
        }
        else {
            if(value.toString().equals(""))
                return defaultValue;
            else
                return Integer.parseInt(value.toString());
        }
    }

    /**
     * Number 타입인지를 체크 한다.
     * @param paramName
     * @return
     */
    public static boolean isNumber(String paramName) {
        paramName = nvl(paramName);
        try {
            Long.parseLong(paramName);
        } catch(Exception e) {
            return false;
        }
        return true;
    }

    /**
     * Double 타입인지를 체크 한다.
     * @param paramName
     * @return
     */
    public static boolean isDouble(String paramName) {
        paramName = nvl(paramName);
        try {
            Double.parseDouble(paramName);
        } catch(Exception e) {
            return false;
        }

        return true;
    }

    /**
     * 문자열을 HTML 포맷에 맞게 변형해준다.
     * @param src
     * @return
     */
    public static String getHtmlContents(String src) {
        src = ReplaceAll(src, "\n", "<br>");
        src = ReplaceAll(src, "&quot;", "\"");
        return src;
    }

    /**
     * 문자열을 구분자로 나누어 배열로 리턴
     * @param value
     * @param regex
     * @return
     */
    public static String[] getStringArray(String value, String regex) {
        String result[] = new String[0];

        if(value != null && !value.equals("")) {
            result = value.split("\\s*"+regex+"\\s*");
        }

        return result;
    }

    /**
     * 데이타를 구분자로 나누어 배열로 리턴
     * @param str
     * @param sepe_str
     * @return
     */
    public static String[] split(String str, String sepe_str) {
        int index = 0;
        String[] result = new String[search(str,sepe_str)+1];
        String strCheck = new String(str);

        while(strCheck.length() != 0) {
            int begin = strCheck.indexOf(sepe_str);
            if(begin == -1) {
                result[index] = strCheck;
                break;
            }
            else {
                int end = begin + sepe_str.length();
                if(true) {
                    result[index++] = strCheck.substring(0, begin);
                }
                strCheck = strCheck.substring(end);
                if(strCheck.length()==0 && true) {
                    result[index] = strCheck;
                    break;
                }
            }
        }
        return result;
    }

    /**
     * 문자열에서 특정 문자열의 위치를 돌려준다.
     * @param strTarget
     * @param strSearch
     * @return
     */
    public static int search(String strTarget, String strSearch) {
        int result = 0;
        String strCheck = new String(strTarget);

        for(int i = 0; i < strTarget.length();) {
            int loc = strCheck.indexOf(strSearch);
            if(loc == -1) {
                break;
            }
            else {
                result++;
                i = loc + strSearch.length();
                strCheck = strCheck.substring(i);
            }
        }
        return result;
    }

    /**
     * 인자값으로 받은 Integre 만큼  문자를 자른후 나머지 문자는 .. 으로 표시한다
     * @param str
     * @param maxLength
     * @return
     */
    public static String setMaxLength(String str, int maxLength) {
        if(str == null) {
            return    "";
        }
        if( str.length() <= maxLength ) return str;
        if( maxLength < 3 ) return str.substring(0, 2);

        StringBuffer returnString = new StringBuffer();
        str = str.trim();

        returnString.append(str.substring(0, maxLength-1)).append("..");

        return returnString.toString();
    }

    public static int getByte(final String value) {
        if(value == null || value.length() == 0) {
            return 0;
        }

        try {
            return value.getBytes("UTF-8").length;
        } catch(UnsupportedEncodingException ex) {
            throw new RuntimeException(ex);
        }
    }

    /**
     * 문자열을 특정 문자열 만큼 잘라주고 뒤에 "..."을 붙여준다.
     * @param str
     * @param cut
     * @return
     */
    public static String cropByte(String str, int cut) {
        if(str == null) {
            return    "";
        }
        if( str.length() <= cut ) return str;
        if( cut < 3 ) return str.substring(0, 2);

        StringCharacterIterator iter = new StringCharacterIterator(str);
        int check = 0;
        int type = Character.getType(iter.last());
        if(type == Character.OTHER_SYMBOL)
          cut --;
        else check++;

        if(check < 1){
            // 재검사
            iter.setText(str.substring(0,cut));
            type = Character.getType(iter.last());
            if(type == Character.OTHER_SYMBOL)
              cut += 2;
        }

        // 문자를 다시 잘라 리턴
        return str.substring(0,cut)+"...";
    }

    /**
     * 문자열 실제크기를 리턴한다.
     * @param s
     * @return
    */
    public static int realLength(String s) {
        return s.getBytes().length;
    }

    /**
     * 파일 확장자를 리턴한다.
     * @param szTemp
     * @return
    */
    public static String getExt(String szTemp) {
        if(szTemp == null) return "";

        String fname = "";
        if(szTemp.indexOf(".") != -1) {
            fname = szTemp.substring(szTemp.lastIndexOf("."));
            return fname;
        } else {
            return "";
        }
    }

    /**
     * 천단위 콤마 찍힌 숫자를 리턴한다.
     * @param str
     * @return
     */
    public static String getMoneyType(int str) {
        NumberFormat nf = NumberFormat.getNumberInstance();
        String r_str = nf.format(str);
        
        return r_str;
    }

    /**
     * 천단위 콤마 찍힌 숫자를 리턴한다.
     * @param str
     * @return
     */
    public static String getMoneyType(String str) {
        NumberFormat nf = NumberFormat.getNumberInstance();
        String r_str = nf.format(nvl(str, 0));
        
        return r_str;
    }

    /**
     * @param requestURI
     * @return
     */
    public static String getUrlFileName(String path) {
        return path.substring(path.lastIndexOf("/")+1, path.lastIndexOf("."));
    }

    /**
     * URL Encoding
     * @param url
     * @return
     */
    public static String getUrlEncode(String url) {
        if(url != null) {
            try {
                url = url.replaceAll(" ", "*20");
                url = URLEncoder.encode(url, "UTF-8");
            } catch(UnsupportedEncodingException e) {
                log.error("Exception!!!"+e.getMessage());
            }
            //url = url.replace('%','*');
        }
        return url;
    }

    /**
     * URL Decoding
     * @param url
     * @return
     */
    public static String getUrlDecode(String url) {
        if(url != null) {
            url = url.replace('*','%');
            try {
                url = URLDecoder.decode(url, "UTF-8");
            } catch(UnsupportedEncodingException e) {
                log.error("Exception!!!"+e.getMessage());
            }
        }
        return url;
    }

    /**
     * HTML 태그를 제거해준다.
     * @param str
     * @return
     */
    public static String removeTag(String str) {
        return str.replaceAll("(?:<!.*?(?:--.*?--s*)*.*?>)|(?:<(?:[^>'\"]*|\".*?\"|'.*?')+>)","");
    }

    /**
    * 기능 : 문자열의 왼쪽에 대체문자를 해당 index의 갯수만큼 채워 리턴한다.
    * param    String str      변경할 문자열
    * param    int index       반복횟수
    * param    String addStr   반복될문자열
    * @return  String  오른쪽에 반복되어 채워진 문자열
    */
    public static String fillLeft(String str, int index, String addStr) {
        int gap = 0;
        if((str!=null) && (addStr!=null) && (str.length()<=index)) {
            gap = index - str.length();

            for(int i=0 ; i<gap ; i++) {
                str = addStr + str;
            }
            return str;
        }
        else {
            return "";
        }
    }

    /**
     * 문자열에서 지정한 위치의 문자를 반환한다.
     * @param value
     * @param idx
     * @return
     */
    public static String getStringIndexValue(String value, int idx) {
        String result = "";

        if(value != null && value.length() >= idx) {
            result = value.substring(idx-1, idx);
        }
        return result;
    }

    /**
     * 브라우저 정보
     * @param request
     * @return
     */
    public static String getBrowserType(HttpServletRequest request) {
        String regBrowser = "";
        String userAgent = request.getHeader("user-agent");

        if(userAgent.indexOf("MSIE") > 0) {
            regBrowser = "IE";
        } else if(userAgent.indexOf("Chrome") > 0) {
            regBrowser = "Chrome";
        } else if(userAgent.indexOf("Safari") > 0) {
            regBrowser = "Safari";
        } else if(userAgent.indexOf("Firefox") > 0) {
            regBrowser = "Mozilla";
        }
        return regBrowser;
    }

    /**
     * 패턴제거용
     * <(no)?script[^>]*>.*?</(no)?script> --script 태그 제거용;
     * <style[^>]*>.*</style> --style 태그 제거용;
     * <(\"[^\"]*\"|\'[^\']*\'|[^\'\">])*> -- 태그 제거용;
     * \\s\\s+ -- 공백 제거용;
     * &[^;]+; -- entity ref 제거용;
     * @param rex
     * @param inp
     * @return
     */
    public static String removePattern(String rex, String inp) {

        StringBuffer sb = new StringBuffer();
        jregex.Pattern delimiters = new jregex.Pattern(rex);

        RETokenizer tok = delimiters.tokenizer(inp);
        while(tok.hasMore()) {
            sb.append(tok.nextToken());
        }
        return sb.toString();
    }
    
    /**
     *  script 태그 제거
     */
    public static String removeScript(String data) {
    	if (data != null) {
    		data = removePattern("<(no)?script[^>]*>.*?</(no)?script>", data);
    	}
    	return data;
    }

    /**
     * 검색어에서 SQL 관련 태그 제거
     */
    public static String getKeywordFilter(String keyword) {
        if(keyword == null || keyword.equals("")) {
            return keyword;
        }

        keyword = keyword.replaceAll("'", "");
        keyword = keyword.replaceAll("%", "");
        keyword = keyword.replaceAll("\"", "");
        keyword = keyword.replaceAll("=", "");
        keyword = keyword.replaceAll("<", "");
        keyword = keyword.replaceAll(">", "");
        keyword = keyword.replaceAll("#", "");
        keyword = keyword.replaceAll("\\(", "");
        keyword = keyword.replaceAll("\\)", "");
        keyword = keyword.replaceAll("\\*/", "");
        keyword = keyword.replaceAll("/\\*", "");
        keyword = keyword.replaceAll("\\+", "");
        keyword = keyword.replaceAll("\\;", "");

        return keyword;
    }

    /**
     * 경로 조작 및 자원 삽입 방지 문자열셋 변경
     * @param path
     * @return
     */
    public static String filePatternRemove(String path) {
        return path.replaceAll("[.][.][/]", "").replaceAll("&", "");
    }

    /**
     * URL에서 파라메터를 분리하여 Map으로 전달한다.
     * @param url
     * @return paramMap
     */
    public static Map<String, String> getUrlParamMap(String url) {
        Map<String, String> paramMap = new HashMap<>();

        if(url != null) {
            String[] params=url.split("&");
            if(params.length > 0) {
                for(int i = 0; i < params.length; i++) {
                    String param = params[i];
                    String[] vals = param.split("=");
                    if(vals.length > 1) {
                        paramMap.put(vals[0], vals[1]);
                    }
                }
            }
        }
        return paramMap;
    }

    /**
     * 파일 확장자에서 점을 제외하고 반환한다.
     * @param fileName
     * @return
     */
    public static String getExtNoneDot(String fileName) {
        if(fileName == null) return "";

        String fname = "";
        if(fileName.indexOf(".") != -1) {
            fname = fileName.substring(fileName.lastIndexOf(".")+1);
            return fname;
        } else {
            return "";
        }
    }

    /**
     * 첫문자를 대문자로 변환
     * @param string
     * @return
     */
    public static String upperCaseFirst(String src) {
         char[] arr = src.toCharArray();
         arr[0] = Character.toUpperCase(arr[0]);
         
         return new String(arr);
    }

    /**
     * 특정 문자열을 만들어 반환한다.
     * @param lenth
     * @return String
     */
    public static String generateKeyString(int length) {
        String retVal = "";
        char[] initRandomChar = {'1','2','3','4','5','6','7','8','9','0','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};

        int i=0;
        while(i < length) {
            retVal += initRandomChar[(int)(Math.random() * initRandomChar.length)];
            i++;
        }
        return retVal;
    }

    // 내용의 길이 반환(html  태그 제외)
    public static int getContentLenth(String str) {
        str = removeTag(str);
        return str.length();
    }

    // 전화번호 형식 반환
    public static String getPhoneNumber(String phoneNumber) {
        if(phoneNumber == null || phoneNumber.isEmpty()) {
            return "";
        }

        String cleanInput = phoneNumber.replaceAll("[^0-9]", "");
        String result = "";
        int length = cleanInput.length();

        if(length == 8) {
            result = cleanInput.replaceAll("(\\d{4})(\\d{4})", "$1-$2");
        } else if(cleanInput.startsWith("02") && (length == 9 || length == 10)) {
            result = cleanInput.replaceAll("(\\d{2})(\\d{3,4})(\\d{4})", "$1-$2-$3");
        } else if(!cleanInput.startsWith("02") && (length == 10 || length == 11)) {
            result = cleanInput.replaceAll("(\\d{3})(\\d{3,4})(\\d{4})", "$1-$2-$3");
        } else {
            result = phoneNumber;
        }
        return result;
    }

}
