package knou.framework.util;

import java.util.Calendar;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import org.apache.log4j.Logger;

import knou.framework.common.CommConst;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;

/**
 * Redis Util
 * @author shil
 *
 */
public class RedisUtil {
	private static JedisPool pool = null;
	private static String connDate = "";
	protected static Logger log = Logger.getLogger(RedisUtil.class);
	
	static{
		borrow();
	}
	

	/**
	 * Get Value
	 * @param key
	 * @return
	 */
	public static String getValue(String key) {
		Jedis jedis = borrow();
		String value = null;
        try {
        	if (jedis != null) {
        		value = jedis.get(key);
        	}
        }
        catch (Exception e) { 
        	log.error("Exception!!!"+e.getMessage());
        }
        finally {
        	if (jedis != null) {
        		jedis.close();
        		revert(jedis);
        	}
        }
        return value;
	}
	
	
	/**
	 * Set Value
	 * @param key
	 * @param value
	 * @param expireTime(second)
	 */
	public static void setValue(String key, String value, int expireTime) {
		Jedis jedis = borrow();
		
        try {
        	if (jedis != null) {
	            jedis.set(key, value);
	
	            if (expireTime > 0) { 
	            	jedis.expire(key, expireTime);
	            }
        	}
        } 
        catch (Exception e) { 
        	log.error("Exception!!!"+e.getMessage());
        }
        finally {
        	if (jedis != null) {
        		jedis.close();
        		revert(jedis);
        	}
        }
	}
	
	
	/**
	 * Set Value
	 * @param key
	 * @param value
	 */
	public static void setValue(String key, String value) {
		setValue(key, value, 0);
	}
	

	/**
	 * Set List
	 * @param key
	 * @param list
	 */
	public static void setList(String key, List<String> list) {
		Jedis jedis = borrow();
		
        try {
        	if (jedis != null) {
	        	for (String value : list) {
	        		jedis.rpush(key, value);
	        	}
        	}
        } 
        catch (Exception e) { 
        	log.error("Exception!!!"+e.getMessage());
        }
        finally {
        	if (jedis != null) {
        		jedis.close();
        		revert(jedis);
        	}
        }
	}
	
	
	/**
	 * Get List
	 * @param key
	 * @param startIndex
	 * @param endIndex
	 * @return
	 */
	public static List<String> getList(String key, long startIndex, long endIndex) {
		Jedis jedis = borrow();
		List<String> list = null;
		
        try {
        	if (jedis != null && jedis.exists(key)) {
        		list = jedis.lrange(key, startIndex, endIndex);
        	}
        }
        catch (Exception e) { 
        	log.error("Exception!!!"+e.getMessage());
        }
        finally {
        	if (jedis != null) {
        		jedis.close();
        		revert(jedis);
        	}
        }
		
		return list;
	}
	
	
	/**
	 * Get List
	 * @param key
	 * @return
	 */
	public static List<String> getList(String key) {
		return getList(key, 0, -1);
	}
	
	
	/**
	 * Get List size
	 * @param key
	 * @return
	 */
	public static long getListSize(String key) {
		Jedis jedis = borrow();
		long length = 0;
		
        try {
        	if (jedis != null && jedis.exists(key)) {
        		length = jedis.llen(key);
        	}
        }
        catch (Exception e) { 
        	log.error("Exception!!!"+e.getMessage());
        }
        finally {
        	if (jedis != null) {
        		jedis.close();
        		revert(jedis);
        	}
        }
		
		return length;
	}
	
	/**
	 * Set Map list
	 * @param mapList
	 * @param expire
	 */
	public static void setMapList(Map<String, List<String>> mapList, long expire) {
		Jedis jedis = borrow();
		
        try {
        	if (jedis != null) {
        		for (String key : mapList.keySet()) {
        			jedis.del(key);
                	
                	for (String value : mapList.get(key)) {
    	        		jedis.rpush(key, value);
    	        	}
                	
                	jedis.expire(key, expire);
                }
        	}
        } 
        catch (Exception e) { 
        	log.error("Exception!!!"+e.getMessage());
        }
        finally {
        	if (jedis != null) {
        		jedis.close();
        		revert(jedis);
        	}
        }
	}
	
	
	/**
	 * Set Expire
	 * @param key
	 * @param seconds
	 */
	public static void expire(String key, long seconds) {
		Jedis jedis = borrow();
		
        try {
        	if (jedis != null) {
        		jedis.expire(key, seconds);
        	}
        }
        catch (Exception e) { 
        	log.error("Exception!!!"+e.getMessage());
        }
        finally {
        	if (jedis != null) {
        		jedis.close();
        		revert(jedis);
        	}
        }
	}
	
	
	/**
	 * Get keys
	 * @param pattern
	 * @return
	 */
	public static Set<String> keys(String pattern) {
		Jedis jedis = borrow();
		Set<String> keySet = null; 
		
        try {
        	if (jedis != null) {
        		keySet = jedis.keys(pattern);
        	}
        }
        catch (Exception e) { 
        	log.error("Exception!!!"+e.getMessage());
        }
        finally {
        	if (jedis != null) {
        		jedis.close();
        		revert(jedis);
        	}
        }
        
        return keySet;
	}
	
	
	/**
	 * Get exists
	 * @param key
	 * @return
	 */
	public static boolean exists(String key) {
		boolean exists = false;
		Jedis jedis = borrow();
		
        try {
        	if (jedis != null) {
        		exists = jedis.exists(key);
        	}
        }
        catch (Exception e) { 
        	log.error("Exception!!!"+e.getMessage());
        }
        finally {
        	if (jedis != null) {
        		jedis.close();
        		revert(jedis);
        	}
        }
        
        return exists;
	}
	
	
	/**
	 * expire 시간 설정(Timestamp)
	 * @param key
	 * @param timestamp
	 */
	public static void expireAt(String key, long timestamp) {
		Jedis jedis = borrow();
		
        try {
        	if (jedis != null) {
        		jedis.expireAt(key, timestamp);
        	}
        }
        catch (Exception e) { 
        	log.error("Exception!!!"+e.getMessage());
        }
        finally {
        	if (jedis != null) {
        		jedis.close();
        		revert(jedis);
        	}
        }
	}
	
	
	/**
	 * 오늘 마감시간으로 expire 설정
	 * @param key
	 */
	public static void expireEndDay(String key) {
		Calendar cal = Calendar.getInstance();
        cal.set(Calendar.HOUR_OF_DAY, 23);
        cal.set(Calendar.MINUTE, 59);
        cal.set(Calendar.SECOND, 59);
        
        expireAt(key, (cal.getTimeInMillis() / 1000));
	}
	
	
	/**
	 * 삭제
	 * @param key
	 */
	public static void del(String key) {
		Jedis jedis = borrow();

        try {
        	if (jedis != null) {
        		jedis.del(key);
        	}
        }
        catch (Exception e) { 
        	log.error("Exception!!!"+e.getMessage());
        }
        finally {
        	if (jedis != null) {
        		jedis.close();
        		revert(jedis);
        	}
        }
	}
	
	
	/**
	 * Redis 서버 접속
	 */
	private static void connServer() {
		try {
			String password = CommConst.REDIS_PASSWORD;
			if ("".equals(password)) password = null;
			
			pool = new JedisPool(new JedisPoolConfig(), CommConst.REDIS_HOST, Integer.parseInt(CommConst.REDIS_PORT), 
					3000, password, Integer.parseInt(CommConst.REDIS_DATABASE));
            connDate = getNowDate();
        } catch (Exception e) {
        	log.error("Exception!!!"+e.getMessage());
        }
	}
	
	
	/**
	 * 접속 pool  삭제
	 */
	private static void destroy() {
		if (pool == null) {
			pool.destroy();
		}
    }
	
 
	/**
	 * Connection Borrow
	 * @return
	 */
    private static Jedis borrow() {
    	Jedis jedis = null;
    	if (pool == null) {
    		connServer();
    	}
    	else {
    		String nowDate = getNowDate();
    		
    		if (!nowDate.equals(connDate)) {
    			destroy();
    			connServer();
    		}
    		try {
    			jedis = pool.getResource();
			} catch (Exception e) {
				destroy();
				pool = null;
				log.error("Exception!!!"+e.getMessage());
			}
    		
    	}
    	return jedis;
    }
    
 
    /**
     * Connection Revert
     * @param jedis
     */
    private static void revert(Jedis jedis) {
    	if (pool == null) {
    		pool.returnResource(jedis);
    	}
    }
    
    
    // now date
    private static String getNowDate() {
    	Calendar calendar = Calendar.getInstance(Locale.getDefault());
    	String date = Integer.toString(calendar.get(Calendar.YEAR)) 
    			+ Integer.toString(calendar.get(Calendar.MONTH))
    			+ Integer.toString(calendar.get(Calendar.DAY_OF_MONTH))
    			+ Integer.toString(calendar.get(Calendar.HOUR_OF_DAY));
    	
    	return date;
    }
}
