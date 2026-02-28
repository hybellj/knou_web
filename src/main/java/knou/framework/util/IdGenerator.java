package knou.framework.util;
import java.util.Calendar;
import java.util.UUID;

public class IdGenerator {
	private static final char[] DIGITS = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
			'0','1','2','3','4','5','6','7','8','9'};
	
	public IdGenerator() {
		super();
	}

	/**
	 * 새로운 ID 생성
	 * @param moduleName (모듈명, 5자 이내)
	 * @return
	 */
	public synchronized static String getNewId(String moduleName) {
		if (moduleName == null || "".equals(moduleName)) {
			moduleName = "ID";
		}
		else if (moduleName.length() > 5) {
			moduleName = moduleName.substring(0, 5);
		}
		
		StringBuffer idBuf = new StringBuffer();
		Calendar calendar = Calendar.getInstance();
        
        String[] tms = (String.format("%02d", calendar.get(Calendar.MINUTE))
        		+ String.format("%02d", calendar.get(Calendar.SECOND))
        		+ String.format("%03d", calendar.get(Calendar.MILLISECOND))).split("");
        
		idBuf.append(moduleName.toUpperCase()+"_");
		idBuf.append(DIGITS[calendar.get(Calendar.YEAR) % 25]);
		idBuf.append(DIGITS[calendar.get(Calendar.MONTH)+1]);
		idBuf.append(DIGITS[calendar.get(Calendar.DAY_OF_MONTH)]);
		idBuf.append(DIGITS[calendar.get(Calendar.HOUR_OF_DAY)]);
		
		for (String tm : tms) {
			idBuf.append(DIGITS[Integer.parseInt(tm)]);
		}
		
		idBuf.append(UUID.randomUUID().toString().replace("-", "").substring(0, 8));

		return idBuf.toString();
	}

}
