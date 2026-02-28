package knou.framework.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.Reader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.simple.parser.JSONParser;

import net.sf.json.JSONArray;
import net.sf.json.JSONException;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;

public class JsonUtil {

	private static final Log log = LogFactory.getLog(JsonUtil.class);
	private static final String NO_CACHE = "no-cache";

	private JsonUtil() {
		throw new IllegalStateException("JsonUtil class");
	}
	
	/**
	 * Json String을 Object 형태로 변환 하여 돌려 준다.
	 * @param jsonString
	 * @return
	 */
	public static Map<String, Object> getJsonObject(String jsonString) {
		Map<String, Object> result = new HashMap<>();
		ObjectMapper mapper = new ObjectMapper();
        try {
            //convert JSON string to Map
        	result = mapper.readValue(jsonString, new TypeReference<HashMap<String, Object>>() {});
        } catch (Exception e) {
        	log.error(e.getMessage());
        }
		return result;
	}

	/**
	 * 일반 인스턴스를 Json 형태로 변경해서 반환한다.
	 * @param obj json으로 변경하고자 하는 인스턴스
	 * @return
	 */
	public static String getJsonString(Object obj) {
		return getJsonString(obj, null);
	}

	/**
	 * 일반 인스턴스를 Json 형태로 변경해서 반환한다.
	 * JsonConfig를 이용해서 출력하고자 하는 맴버를 필터링 할 수 있다.
	 * <pre>
	 * JsonConfig jsonConfig = new JsonConfig();
	 *   jsonConfig.setRootClass( BeanA.class );
	 *   jsonConfig.setJavaPropertyFilter( new PropertyFilter(){
	 *     public boolean apply( Object source, String name, Object value ) {
	 *       if( "bool".equals( name ) || "integer".equals( name ) ){
	 *         return true;
	 *       }
	 *       return false;
	 *     }
	 *   });
	 * </pre>
	 * @param obj json으로 변경하고자 하는 인스턴스
	 * @return
	 */
	public static String getJsonString(Object obj, JsonConfig jsonConfig) {
		String json = "";
		if (obj == null)
			return null;

		if (obj instanceof List<?>) {
			json = (jsonConfig != null) ? JSONArray.fromObject(obj, jsonConfig).toString() : JSONArray.fromObject(obj).toString();
		} else {
			json = (jsonConfig != null) ? JSONObject.fromObject(obj, jsonConfig).toString() : JSONObject.fromObject(obj).toString();
		}

		if(log.isDebugEnabled())
			log.debug("JSON String : " + obj + "->" + json);
		return json;
	}
	
	/**
	 * Response에서 writer를 구해서 문자열을 출력한다.
	 * @param response 응답 인스턴스
	 * @param string 브라우져로 보내고자 하는 문자열
	 */
	public static void responseWrite(HttpServletResponse response, String string) {

		 response.setHeader("Pragma", NO_CACHE);
		 response.setHeader("Expires", "0");
		 response.setHeader("Cache-Control", NO_CACHE);
		 response.setContentType("application/json;charset=utf-8");

		try {
			PrintWriter writer = response.getWriter();
			writer.print(string);
			writer.flush();
			writer.close();
		} catch (IOException e) {
			log.error(e.getMessage());
		}
	}

	/**
	 * Response에 인스턴스를 json으로 변경해서 출력. 메시지 처리를 하지 않는다.
	 * @param response 응답 인스턴스
	 * @param obj json으로 보내고자 하는 인스턴스
	 */
	public static String responseJson(HttpServletResponse response, Object obj) {
		responseWrite(response, getJsonString(obj));
		return null;
	}
	
	/**
	 * Response에 인스턴스를 json으로 변경해서 출력. 메시지 처리를 하지 않는다. <br>
	 * JsonConfig를 이용해서 전달 프로퍼티를 제어한다.
	 *
	 * @see JsonUtil#getJsonString(Object, JsonConfig)
	 *
	 * @param response 응답 인스턴스
	 * @param obj json으로 보내고자 하는 인스턴스
	 */
	public static String responseJson(HttpServletResponse response, Object obj, JsonConfig jsonConfig) {
		responseWrite(response, getJsonString(obj, jsonConfig));
		return null;
	}	
	
	@SuppressWarnings("unused")
	private static String jsonReadAll(Reader reader) throws IOException {
		StringBuilder sb = new StringBuilder();
		int cp;
		while ((cp = reader.read()) != -1) {
			sb.append((char) cp);
		}
		return sb.toString();
	}
	
	public static String readJsonFromUrl(String url) throws IOException, JSONException {
		StringBuilder result = new StringBuilder();
		
		URL clsUrl = new URL(url);
		HttpURLConnection clsConn = (HttpURLConnection)clsUrl.openConnection();
		clsConn.setRequestMethod("GET");
		clsConn.setRequestProperty("Cache-Control", NO_CACHE);
		clsConn.setRequestProperty("Content-Type", "application/json");
		clsConn.setRequestProperty("Accept", "application/json");
		clsConn.setDoInput(true);
		clsConn.connect();
		
		int httpResult = clsConn.getResponseCode(); 
		if(httpResult == HttpURLConnection.HTTP_OK){
			BufferedReader clsInput = new BufferedReader(new InputStreamReader(clsConn.getInputStream(), StandardCharsets.UTF_8));
			String inputLine;

			while((inputLine = clsInput.readLine()) != null) {
				result.append(inputLine);
			}

			clsInput.close();
		}
		
		return result.toString();
	}
	
	
	
	//JSON TO MAP
    public static Map<String, Object> jsonToMap(String  jsonStr) throws Exception {
        Map<String, Object> retMap = new HashMap<>();
        JSONParser parser = new JSONParser();
        Object obj = parser.parse(jsonStr);
        org.json.simple.JSONObject json= (org.json.simple.JSONObject) obj;

        if(json != null) {
            retMap = toMap(json);
        }
        return retMap;
    }
    
    //JSON TO MAP
    public static Map<String, Object> jsonToMap(org.json.simple.JSONObject json) throws Exception {
        Map<String, Object> retMap = new HashMap<>();

        if(json != null) {
            retMap = toMap(json);
        }
        return retMap;
    }

    @SuppressWarnings("rawtypes")
	public static Map<String, Object> toMap(org.json.simple.JSONObject object) throws Exception {
        Map<String, Object> map = new HashMap<>();
        
        
        for (Iterator keysItr = object.keySet().iterator(); keysItr.hasNext(); ) {
            String key = (String)  keysItr.next();
            Object value = object.get(key);

            if(value instanceof org.json.simple.JSONArray) {
                value = toList((org.json.simple.JSONArray) value);
            }

            else if(value instanceof org.json.simple.JSONObject) {
                value = toMap((org.json.simple.JSONObject) value);
            }
            map.put(key, value);
          }
 
        return map;
    }

    public static List<Object> toList(org.json.simple.JSONArray array) throws Exception {
        List<Object> list = new ArrayList<>();
        for(int i = 0; i < array.size(); i++) {
            Object value = array.get(i);
            if(value instanceof org.json.simple.JSONArray) {
                value = toList((org.json.simple.JSONArray) value);
            }

            else if(value instanceof org.json.simple.JSONObject) {
                value = toMap((org.json.simple.JSONObject) value);
            }
            list.add(value);
        }
        return list;
    }
    
    /**
     * Map을 json으로 변환한다.
     *
     * @param map Map<String, Object>.
     * @return JSONObject.
     */
    @SuppressWarnings("unchecked")
	public static org.json.simple.JSONObject getJsonStringFromMap( Map<String, Object> map )
    {
        org.json.simple.JSONObject jsonObject = new org.json.simple.JSONObject();
        for( Map.Entry<String, Object> entry : map.entrySet() ) {
            String key = entry.getKey();
            Object value = entry.getValue();
            jsonObject.put(key, value);
        }
        
        return jsonObject;
    }
    
    /**
     * List<Map>을 jsonArray로 변환한다.
     *
     * @param list List<Map<String, Object>>.
     * @return JSONArray.
     */
    @SuppressWarnings("unchecked")
	public static org.json.simple.JSONArray getJsonArrayFromList( List<Map<String, Object>> list )
    {
        org.json.simple.JSONArray jsonArray = new org.json.simple.JSONArray();
        for( Map<String, Object> map : list ) {
            jsonArray.add( getJsonStringFromMap( map ) );
        }
        
        return jsonArray;
    }
    
    /**
     * List<Map>을 jsonString으로 변환한다.
     *
     * @param list List<Map<String, Object>>.
     * @return String.
     */
    public static String getJsonStringFromList( List<Map<String, Object>> list )
    {
        org.json.simple.JSONArray jsonArray = getJsonArrayFromList( list );
        return jsonArray.toJSONString();
    }

}
