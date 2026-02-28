package knou.lms.seminar.api.common.util;

import java.util.List;

import knou.lms.seminar.api.common.vo.CustomKeyVO;

public class CustomKeyUtil {
    
    // CustomKey리스트에 특정 CustomKey가 있는지 확인한다.
    public static boolean hasCustomKey(List<CustomKeyVO> customKeyList, String key, String value) {
        if(customKeyList == null) {
            return false;
        }

        CustomKeyVO customKey = customKeyList.stream().filter(e -> e.getKey().equals(key))
                .findFirst().orElse(null);

        if(customKey == null || !customKey.getValue().equals(value)) {
            return false;
        }

        return true;
    }

}
