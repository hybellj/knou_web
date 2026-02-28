package knou.lms.file.vo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class FileUpRepository {

	private static int incrementableKey = 0;
	private static final Map<String, FileUpEntityVO> repository = new HashMap<String, FileUpEntityVO>();
	
	public static synchronized String addFileEntity(FileUpEntityVO entity) {		
		String key = String.format("F%1$05d", ++incrementableKey);
		entity.setKey(key);
		repository.put(key, entity);		
		return key;
	}
	
	public static FileUpEntityVO getFileEntity(String key) {		
		if (repository.containsKey(key))
			return repository.get(key);
		else
			return null;
	}
	
	public static List<FileUpEntityVO> getFileEntities() {		
		List<FileUpEntityVO> list = new ArrayList<FileUpEntityVO>();
		Set<String> keys = repository.keySet();
		Iterator<String> iterator = keys.iterator();
		while (iterator.hasNext()) {
			list.add(repository.get(iterator.next()));
		}
		return list;		
	}
	
	public static synchronized void clear() {		
		repository.clear();
		incrementableKey = 0;
	}
}
