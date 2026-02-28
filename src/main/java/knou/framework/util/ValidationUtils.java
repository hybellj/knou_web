package knou.framework.util;

import java.util.List;
import java.util.Set;

public class ValidationUtils {

	private ValidationUtils() {}

	public static boolean isNull( Object obj) {
		if ( obj == null)
			return true;
		else
			return false;
	}

	public static boolean isNotNull( Object obj) {
		return !isNull(obj);
	}

	public static boolean isNull( List<?> list) {
		if ( list.isEmpty() || list == null)
			return true;
		return false;
	}

	public static boolean isNull( Set<?> set) {
		if ( set.isEmpty() || set == null)
			return true;
		return false;
	}

	public static boolean isNull( Object ...objs) {
		for (Object obj : objs) {
			if ( isNull(obj)) return true;
		}
		return false;
	}

	public static boolean isNotNull( Object ...objs) {
		return !isNull(objs);
	}

	public static boolean isEmpty(Object obj) {
		if(obj == null || "".equals(obj)) return true;
		else return false;
	}

	public static boolean isNotEmpty(Object obj) {
		if(obj != null && !"".equals(obj)) return true;
		else return false;
	}

	/**
	 * Integer값이 null이 아니고 0보다 클 경우 true.
	 * @return
	 */
	public static boolean isNotZeroNull(Integer value) {
		if(value != null && value > 0) return true;
		return false;
	}

	/**
	 * Integer값이 null이거나 0보다 작거나 같을 경우 true.
	 * @return
	 */
	public static boolean isZeroNull(Integer value) {
		return !isNotZeroNull(value);
	}

}
