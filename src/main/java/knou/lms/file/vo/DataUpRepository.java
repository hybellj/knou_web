package knou.lms.file.vo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class DataUpRepository {

    private static int incrementableKey = 0;
    private static final Map<String, DataUpEntityVO> repository = new HashMap<String, DataUpEntityVO>();

    public static synchronized String addDataEntity(DataUpEntityVO entity) {

        String key = String.format("D%1$05d", ++incrementableKey);
        entity.setKey(key);
        repository.put(key, entity);

        return key;
    }
    
    public static DataUpEntityVO getDataEntity(String key) {

        if(repository.containsKey(key)) {
            return repository.get(key);
        } else {
            return null;
        }
    }
    
    public static List<DataUpEntityVO> getDataEntities() {
        
        List<DataUpEntityVO> list = new ArrayList<DataUpEntityVO>();
        Set<String> keys = repository.keySet();
        Iterator<String> iterator = keys.iterator();

        while(iterator.hasNext()) {
            list.add(repository.get(iterator.next()));
        }
        return list;
    }
    
    public static synchronized void clear() {
        repository.clear();
        incrementableKey = 0;
    }

}
