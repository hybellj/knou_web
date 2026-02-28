package knou.framework.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;


/**
 *  현재 시각 또는 'YYYYMMDD24HHMISS' 형태의 문자열을 이용하여
 *  'YYYY/MM/DD 24HH:MI:SS' 형태의 문자열 변환
 */
public class DateTimeUtil {

	private static final String DATE_GUBUN = "-";
	private static final String TIME_GUBUN = ":";

    /**
     * 현재 시각을 Date()로 반환
     * @return
     */
    public static Date getCurrentDate() {

        return new Date();
    }

    /**
     * 현재 시각을 Calendar()로 반환
     * @return
     */
    public static Calendar getCurrentCalendar() {
        Calendar calendar = Calendar.getInstance();
        calendar.setTimeZone(TimeZone.getTimeZone("GMT+09:00"));
        calendar.setTime(getCurrentDate());
        
        return calendar;
    }

    /**
     * 현재 시각을 String으로 반환
     * @return
     */
    public static String getCurrentString() {
        return getCurrentString("yyyyMMddHHmmss");
    }
    
    /**
     * 현재 시각을 Milli 단위 String으로 반환
     * @return
     */
    public static String getCurrentMillisecond() {
        return getCurrentString("yyyyMMddHHmmssSSS");
    }

    public static String getCurrentString(String datePattern) {
        SimpleDateFormat formatter = new SimpleDateFormat(datePattern);

        return formatter.format(getCurrentDate());
    }
    
    /**
     * 지정된 날짜를 지정된 포맷형식으로 변환한다.
     * @param date
     * @param format
     * @return
     */
    public static String dateToString(Date date, String format) {
        SimpleDateFormat sf = new SimpleDateFormat(format);

        return sf.format(date);
    }

    /**
     * 문자열을 날짜로 변환한다
     * @param format
     * @param date
     * @return
     * @throws ParseException
     */
    public static Date stringToDate(String format, String date) throws ParseException {

        String oldstring = date;
        if(format.indexOf("-") > -1) {
            oldstring = oldstring.replace(".", "-");
        } else if(format.indexOf(".") > -1) {
            oldstring = oldstring.replace("-", ".");
        }
        return new SimpleDateFormat(format).parse(oldstring);
    }
    
    /**
     * 현재 시간을 돌려준다. - YYYYMMDDHHMMSS
     */
    public static String getDateTime() {
        return getCurrentString();
    }
    
    /**
     * 현재 시간 반환 - HHMMSS
     * @param request
     * @return
     */
    public static String getTime() {
        return getCurrentString().substring(8,14);
    }
    
    public static String getDate() {
        Calendar cal = Calendar.getInstance();
        StringBuffer buf = new StringBuffer();
        buf.append(Integer.toString(cal.get(1)));
        String month = Integer.toString(cal.get(2) + 1);
        if(month.length() == 1) {
            month = "0" + month;
        }
        String day = Integer.toString(cal.get(5));
        if(day.length() == 1) {
            day = "0" + day;
        }
        buf.append(month);
        buf.append(day);
        
        return buf.toString();
    }
    
    /**
     * 현재 날짜 반환 - YYYYMMDD
     * @param request
     * @return
     */
    public static String getDates() {
        return getCurrentString().substring(0,8);
    }
    
    /**
     * 년도 반환
     * @return
     */
    public static String getYear() {
        return getCurrentString().substring(0,4);
    }

    /**
     * 월 반환
     * @return
     */
    public static String getMonth() {
        return getCurrentString().substring(4,6);
    }

    /**
     * 일 반환
     * @return
     */
    public static String getDay() {
        return getCurrentString().substring(6,8);
    }
    
    /**
     * 시 반환
     * @return
     */
    public static String getHours() {
        return getCurrentString().substring(8,10);
    }

    /**
     * 분 반환
     * @return
     */
    public static String getMinutes() {
        return getCurrentString().substring(10,12);
    }

    /**
     * 초 반환
     * @return
     */
    public static String getSeconds() {
        return getCurrentString().substring(12,14);
    }
    
    /**
     * 현재 년월일을 돌려준다. - YYYY.MM.DD
     * TYPE 1 : YYYY.MM.DD
     * TYPE 2 : YY.MM.DD
     * TYPE 3 : MM.DD
     * TYPE 4 : YYYY.MM
     * TYPE 5 : YYYY
     */
    public static String getDateText(int type, String szdate) {
        return getDateText(type, szdate,DATE_GUBUN);
    }
    public static String getDateText(int type, String szdate,String delimeter) {

        if(szdate != null && szdate.length() != 8) {
            return "";
        }

        if(szdate != null && szdate.length() == 8) {
            String year = szdate.substring(0, 4);
            String month = szdate.substring(4, 6);
            String day = szdate.substring(6, 8);

            switch(type) {
                case 1:
                    return  year + delimeter + month + delimeter + day;
                case 2:
                    return  year.substring(2, 4) + delimeter + month + delimeter + day;
                case 3:
                    return month + delimeter + day;
                case 4:
                    return  year + delimeter + month;
                case 5:
                    return year;
                default:
                	return  year + delimeter + month + delimeter + day;
           }
        }
        return "";
    }
    
    /**
     * 특정형태의 날자 타입을 돌려준다.
     * TYPE 0 : YYYY.MM.DD HH:MI:SS
     * TYPE 1 : YYYY.MM.DD
     * TYPE 2 : YY.MM.DD
     * TYPE 3 : MM.DD
     * TYPE 4 : YYYY.MM
     * TYPE 5 : YYYY
     * TYPE 6 : MM.DD HH:MI
     * TYPE 7 : HH:MI
     * TYPE 8 : YYYY.MM.DD HH:MI
     * @param type
     * @param dateTime
     * @return
     */
    public static String getDateType(int type, String date) {
        return getDateType(type, date, DATE_GUBUN);
    }
    public static String getDateType(int type, String date, String delimeter) {
        
        if(date == null) {
            return "";
        }

        if(date.length() == 12) date += "01";
        else if(date.length() == 10) date += "0101";
        else if(date.length() == 8) date += "010101";
        else if(date.length() == 6) date += "01010101";
        else if(date.length() == 4) date += "0101010101";

        // 시험관리에서 일시까지 보여줌
        switch(type) {
            case 0:
                return getDateText(1,StringUtil.substring(date, 0, 8), delimeter) + " " + getTimeText(1,StringUtil.substring(date, 8, 14));
            case 1:
                return getDateText(1,StringUtil.substring(date, 0, 8), delimeter);
            case 2:
                return getDateText(2,StringUtil.substring(date, 0, 8), delimeter);
            case 3:
                return getDateText(3,StringUtil.substring(date, 0, 8), delimeter);
            case 4:
                return getDateText(4,StringUtil.substring(date, 0, 8), delimeter);
            case 5:
                return getDateText(5,StringUtil.substring(date, 0, 8), delimeter);
            case 6:
                return getDateText(3,StringUtil.substring(date, 0, 8), delimeter) + " " + getTimeText(2,StringUtil.substring(date, 8, 14));
            case 7:
                return getTimeText(2,StringUtil.substring(date, 8, 14));
            case 8:
                return getDateText(1,StringUtil.substring(date, 0, 8), delimeter) + " " + getTimeText(2,StringUtil.substring(date, 8, 14));
            case  9:
                return getDateText(2,StringUtil.substring(date, 0, 8), delimeter) + " " + getTimeText(3,StringUtil.substring(date, 8, 14));
            case 10:
                return getDateText(1,StringUtil.substring(date, 0, 8), delimeter) + " (" + getTimeText(1,StringUtil.substring(date, 8, 14)) + ")";
            case 11:
                return getDateText(1,StringUtil.substring(date, 0, 8), delimeter) + " (" + getTimeText(2,StringUtil.substring(date, 8, 14)) + ")";
            case 12:
                return getDateText(2,StringUtil.substring(date, 0, 8), delimeter) + " (" + getTimeText(1,StringUtil.substring(date, 8, 14)) + ")";
            case 13:
                return getDateText(2,StringUtil.substring(date, 0, 8), delimeter) + " (" + getTimeText(2,StringUtil.substring(date, 8, 14)) + ")";
            default:
            	return getDateText(1,StringUtil.substring(date, 0, 8), delimeter) + " " + getTimeText(1,StringUtil.substring(date, 8, 14));
        }
    }

    /**
     * 현재 시간을 돌려준다. - HH:MI:SS
     */
    public static String getTimeText(int type, String szTime) {
        
        if(szTime != null && szTime.length() != 6) {
            return "";
        }
        
        if(szTime != null && szTime.length() == 6) {
            String hour = StringUtil.substring(szTime,0, 2);
            String minute = StringUtil.substring(szTime, 2, 4);
            String second = StringUtil.substring(szTime,4, 6);

            switch(type) {
                case 1:
                    return hour + TIME_GUBUN + minute + TIME_GUBUN + second;
                case 2:
                    return  hour + TIME_GUBUN + minute;
                case 3:
                    return  hour;
                default:
                	return hour + TIME_GUBUN + minute + TIME_GUBUN + second;
            }
        }
        return "";
    }

    /**
     * YYYYMMDD 형태의 텍스트를 Date로 변환
     * @param strDate
     * @return
     */
    public static Date convStrToDate(String strDate) {
        
        return convStrToCalendar(strDate).getTime();
    }

    /**
     * YYYYMMDD 형태의 텍스트를 Calendar로 변환
     * @param strDate
     * @return
     */
    public static Calendar convStrToCalendar(String strDate) {
        
        Calendar cal = Calendar.getInstance();

        int year = Integer.parseInt(strDate.substring(0,4));
        int month = Integer.parseInt(strDate.substring(4,6));
        int date = Integer.parseInt(strDate.substring(6,8));
        cal.setTimeZone(TimeZone.getTimeZone("GMT+09:00"));
        cal.set(year, month - 1, date);
        
        return cal;
    }
    
    /**
     * YYYYMMDD 형태의 텟스트를 받아서 현재시간의 3일 이내 시간인지 비교 결과를 반환.
     * @param regDttm 생성일 문자열
     * @param beforeDay 몇일 이내인지 비교하고자 하는 숫자
     * @return
     */
    public static boolean isNewer(String regDttm, int beforeDay) {

        try {
            Calendar now = Calendar.getInstance();
                //getCurrentCalendar();
            Calendar cal = DateTimeUtil.convStrToCalendar(regDttm);

            // 현재 시간에서 3일을 감소시킨다.
            now.add(Calendar.DATE, -beforeDay);

            // 비교시간이 3일전 시간보다 크면 true
            if(now.getTimeInMillis() < cal.getTimeInMillis()) return true;

            return false;
        } catch (Exception ex) {
            return false;
        }
    }    
    
    /**
     * 현재 시간부터 3일 이내의 시간인지 비교 결과를 반환
     * @param regDttm
     * @return
     */
    public static boolean isNewer(String regDttm) {
        return isNewer(regDttm, 3);
    }
    
    /**
     * 몇일 후의 날짜를 가져온다.
     * @param afterDay 몇일 이후인지 ...
     * @return
     */
    public static String afterDate(int afterDay) {
        if(afterDay <= 0 ) {
            afterDay = 30;
        }
        try {
            Calendar now = getCurrentCalendar();

            // 현재 시간에서 날짜를 증가 시킨다.
            now.add(Calendar.DATE, afterDay);

            SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
            String retVal = formatter.format(now.getTime());
            return retVal;

        } catch (Exception ex) {
            return null;
        }
    }
    
    /**
     * YYYYMMDDHHmmss 형태의 텟스트를 받아서 현재시간과의 간격을 초로 반환한다.
     * @param compareDttm 생성일 문자열
     * @return long
     */
    public static long getIntervalSecond(String compareDttm) {
        try {
            SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
            Date beginDate = formatter.parse(compareDttm);
            Date endDate = formatter.parse(getCurrentString());
         
            long diff = endDate.getTime() - beginDate.getTime();
            long diffSec = diff / 1000;         

            return diffSec;
        } catch (Exception ex) {
            return 0;
        }
    }

    /**
     * 날짜형태의 String의 날짜 포맷 및 TimeZone을 변경해 주는 메서드
     *
     * @param  strSource    바꿀 날짜 String
     * @param  srcformat    기존의 날짜 형태
     * @param  newformat    원하는 날짜 형태
     * @param  strTimeZone  변경할 TimeZone(""이면 변경 안함)
     * @return              소스 String의 날짜 포맷을 변경한 String
     */
    public static String convertDateFormat(String strSource, String srcformat, String newformat, String strTimeZone) {
        SimpleDateFormat simpledateformat = null;
        Date date = null;

        if(StringUtil.nvl(strSource).trim().equals("")) {
            return "";
        }
        if(StringUtil.nvl(srcformat).trim().equals(""))
            srcformat = "yyyyMMddHHmmss"; // default값
        if(StringUtil.nvl(newformat).trim().equals(""))
            newformat = "yyyy.MM.dd HH:mm:ss"; // default값

        try {
            simpledateformat = new SimpleDateFormat(srcformat, Locale.getDefault());
            date = simpledateformat.parse(strSource);

            if(!StringUtil.nvl(strTimeZone).trim().equals("")) {
                simpledateformat.setTimeZone(TimeZone.getTimeZone(strTimeZone));
            }
            simpledateformat = new SimpleDateFormat(newformat, Locale.getDefault());
        } catch (ParseException exception) {
            throw new RuntimeException(exception);
        }
        
        return simpledateformat.format(date);
    }
    
	// 현재 년도 기준 과거년도 가져오기
	public static List<Integer> getYearList(int range, String symbol) {
	    List<Integer> rList = new ArrayList<Integer>();
	    
	    String curYear = getCurrentDateText().substring(0, 4);
	    
	    int curYearInt = Integer.parseInt(curYear);
	    
	    int year1 = 0;
	    
	    if(symbol.equals("m") || symbol.equals("p")) {
	        for(int i = 0; i <= range; i++) {
	            if(symbol.equals("m")) {
	                rList.add(curYearInt-i);
	            } else if(symbol.equals("p")) {
	                rList.add(curYearInt+i);
	            }
	        }
	    } else {
	        year1 = curYearInt - range;
	        
	        for(int i = year1; i <= curYearInt; i++) {
	            rList.add(i);
            }
	        
	        for(int i = curYearInt+1; i <= curYearInt+range; i++) {
	            rList.add(i);
	        }
	    }
	    return rList;
	}
    public static String getCurrentDateText() {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	        
        return dateFormat.format(getCurrentDate());
    }

	/**
	 * 날짜 비교
	 * @param date1
	 * @param date2
	 * @return int ()
	 */
	public static int compareDate(Date date1, Date date2) {
	    Calendar calendar1 = Calendar.getInstance();
	    calendar1.setTime(date1);

	    Calendar calendar2 = Calendar.getInstance();
	    calendar2.setTime(date2);
	    
	    return calendar1.compareTo(calendar2);
	}

}
