package knou.lms.file.vo;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class FileUtils {

	public static String join(List<String> list, String delimeter) {
		
		if (delimeter == null) throw new IllegalArgumentException("The delimeter must be set.");
		
		StringBuilder sb = new StringBuilder();
		
		if (list.size() > 0) {
			for (String s : list) {
				sb.append(s).append(delimeter); 
			}
			sb.deleteCharAt(sb.length() - delimeter.length());
		}
		return sb.toString();
	}
	
	public static String join(String[] array, String delimeter) {
		return join(Arrays.asList(array), delimeter);
	}
	
	public static <T> List<T> toList(T[] array) {
		List<T> list = new ArrayList<T>();
		for (T t : array) {
			list.add(t);
		}
		return list;
	}
}
