package knou.lms.file.vo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import knou.lms.file.vo.FileUtils;

public class FileDownRepository {

	private static int incrementableKey = 0;
	private static final Map<String, FileDownEntityVO> repository = new HashMap<String, FileDownEntityVO>();

	public static synchronized String addFileEntity(FileDownEntityVO entity) {

		String key = String.format("F%1$05d", ++incrementableKey);
		repository.put(key, entity);
		entity.setKey(key);

		return key;
	}

	public static FileDownEntityVO getFileEntity(String key) {

		if(repository.containsKey(key)) {
			return repository.get(key);
		} else {
			return null;
		}
	}

	public static List<FileDownEntityVO> getFileEntities() {

		Set<String> keys = repository.keySet();

		return getFileEntities(FileUtils.toList(keys.toArray(new String[keys.size()])));
	}

	public static List<FileDownEntityVO> getFileEntities(List<String> keys) {

		List<FileDownEntityVO> list = new ArrayList<FileDownEntityVO>();
		Iterator<String> iterator = keys.iterator();
		FileDownEntityVO temp = null;

		while(iterator.hasNext()) {
			temp = getFileEntity(iterator.next());

			if(temp != null) {
				list.add(temp);
			}
		}
		return list;
	}

	public static synchronized void clear() {
		repository.clear();
		incrementableKey = 0;
	}
}
