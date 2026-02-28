package knou.framework.util;

import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * 빈을 직접 다루고자 할 때 사용.<br>
 * org.apache.commons.beanutils.BeanUtils를 상속 받았다.
 */
public class CommonBeanUtils extends BeanUtils {
	protected final static Log log = LogFactory.getLog(CommonBeanUtils.class);
	
    /**
     * 빈의 값을 병합한다. src에서 dest로 값을 넣는다. 단 src에서 null인 항목은 제외시킨다.
     * @param dest
     * @param src
     */
    public static Map<String, String> compareBean(Object before, Object after) {
        Map<String, String> beforeMap = new HashMap<String, String>();
        Map<String, String> afterMap = new HashMap<String, String>();
        Map<String, String> compareMap = new HashMap<String, String>();
        
        try {
            beforeMap = describe(before);
            afterMap = describe(after);
            Set<String> keySet = beforeMap.keySet();
            
            for(int i=0; i<keySet.size(); i++) {
                String key = (String) keySet.toArray()[i];
                if(!(StringUtil.nvl(beforeMap.get(key),"").toString().equals(""))) {
                    if(!(StringUtil.nvl(beforeMap.get(key),"").equals(StringUtil.nvl(afterMap.get(key))))) {
                        compareMap.put(key, "V");
                    }
                }
            }
            
        } catch (IllegalAccessException ex) {
        	log.error(ex.getMessage());
        } catch (InvocationTargetException ex) {
        	log.error(ex.getMessage());
        } catch (NoSuchMethodException ex) {
        	log.error(ex.getMessage());
        } catch (IllegalArgumentException ex) {
        	log.error(ex.getMessage());
        }
        return compareMap;
    }
    
}
