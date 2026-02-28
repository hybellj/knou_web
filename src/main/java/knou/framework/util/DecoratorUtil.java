package knou.framework.util;

import java.util.Map;

public class DecoratorUtil {

    /*
     * 템플릿 변수 적용 및 메세지 프로퍼티 적용
     * source 를 argu 값으로 치환
     * 변수 포멧       : [$변수명]
     * */
    public static String replaceContens(String source, Map<String, Object> argu) {
        for(Map.Entry<String, Object> elem : argu.entrySet()) {
            source = StringUtil.ReplaceAll(source, "[$" + elem.getKey() + "]", (String)elem.getValue());
        }
        return source;
    }
    
}
