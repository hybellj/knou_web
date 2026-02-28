package knou.lms.file.vo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class DataDownRepository {

	private static int incrementableKey = 0;
	private static final Map<String, DataDownEntityVO> repository = new HashMap<String, DataDownEntityVO>();

	public static synchronized String addDataEntity(DataDownEntityVO entity) {

		String key = String.format("D%1$05d", ++incrementableKey);
		repository.put(key, entity);
		entity.setKey(key);
		return key;
	}

	public static DataDownEntityVO getDataEntity(String key) {

		if(repository.containsKey(key)) {
			return repository.get(key);
		} else {
			return null;
		}
	}

	public static List<DataDownEntityVO> getDataEntities() {

		Set<String> keys = repository.keySet();
		return getDataEntities(FileUtils.toList(keys.toArray(new String[keys.size()])));
	}

	public static List<DataDownEntityVO> getDataEntities(List<String> keys) {

		List<DataDownEntityVO> list = new ArrayList<DataDownEntityVO>();
		Iterator<String> iterator = keys.iterator();
		DataDownEntityVO temp = null;

		while(iterator.hasNext()) {
			temp = getDataEntity(iterator.next());

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
