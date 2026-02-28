package knou.framework.util;

import java.lang.reflect.Field;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class MapToVoUtil {
	private static final Logger LOGGER = LoggerFactory.getLogger(MapToVoUtil.class);

	/**
	 * 필드에 값을 설정할 때 타입 변환을 지원하는 유틸 메서드입니다.
	 * <p>
	 * - 기본적으로 필드 타입에 따라 Number 타입 값을 적절히 변환하여 설정합니다.
	 * - float, int, long 타입 필드에 BigDecimal, Integer, Long 등 다양한 Number 구현체가 올 경우 안전하게 변환합니다.
	 * - 그 외 타입은 value를 그대로 설정합니다.
	 * - value가 null일 경우 필드 설정을 수행하지 않습니다.
	 * <p>
	 * 예외 발생 시 콘솔에 메시지를 출력하며 예외를 던지지 않고 처리합니다.
	 *
	 * @param target 값을 설정할 객체 인스턴스
	 * @param field  값을 설정할 필드 (접근 가능하도록 setAccessible(true) 호출됨)
	 * @param value  설정할 값 (null 가능)
	 */
	public static void setFieldValueWithConversion(Object target, Field field, Object value) {
        try {
            if (value == null) return;

            Class<?> type = field.getType();
            field.setAccessible(true);

            if (type == float.class || type == Float.class) {
                if (value instanceof Number) {
                    field.set(target, ((Number) value).floatValue());
                }
            } else if (type == int.class || type == Integer.class) {
                if (value instanceof Number) {
                    field.set(target, ((Number) value).intValue());
                }
            } else if (type == long.class || type == Long.class) {
                if (value instanceof Number) {
                    field.set(target, ((Number) value).longValue());
                }
            } else {
                field.set(target, value);
            }

        } catch (Exception e) {
        	LOGGER.debug("필드 [" + field.getName() + "] 변환 오류: " + e.getMessage());
        }
    }

}
