package knou.lms.seminar.api.common.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.Date;

public class DateUtils {
    
    /**
     * 지정된 날짜를 지정된 포맷형식으로 변환한다.
     * @param date
     * @param format
     * @return
     */
    public static String dateToString(Date date,
                                      String format) {

        SimpleDateFormat sf = new SimpleDateFormat(format);
        return sf.format(date);
    }

    /**
     * 현재 날짜를 지정된 포맷형식으로 변환한다.
     * @param format
     * @return
     */
    public static String dateToString(String format) {

        return dateToString(new Date(), format);
    }
    
    /**
     * 문자열을 날짜로 변환한다
     * @param format
     * @param date
     * @return
     * @throws ParseException
     */
    public static Date stringToDate(String format, String date) throws ParseException {
        
        //SimpleDateFormat sf = new SimpleDateFormat(format);
        //return sf.parse(date);
        
        String oldstring = date;
        return new SimpleDateFormat(format).parse(oldstring);
        
    }
    
    public static java.sql.Date transformDate(String date)
    {
        SimpleDateFormat beforeFormat = new SimpleDateFormat("yyyyMMddHHmm");
        
        // Date로 변경하기 위해서는 날짜 형식을 yyyy-mm-dd로 변경해야 한다.
        SimpleDateFormat afterFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        
        java.util.Date tempDate = null;
        
        try {
            // 현재 yyyymmdd로된 날짜 형식으로 java.util.Date객체를 만든다.
            tempDate = beforeFormat.parse(date);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        
        // java.util.Date를 yyyy-mm-dd 형식으로 변경하여 String로 반환한다.
        String transDate = afterFormat.format(tempDate);
        
        // 반환된 String 값을 Date로 변경한다.
        java.sql.Date d = java.sql.Date.valueOf(transDate);
        
        return d;
    }
    
    /**
     * yyyyMMddHHmmss포멧의 날짜를 yyyy-MM-ddTHH:mm:ss포멧으로 변환한다.
     * 
     * @param String "yyyyMMddHHmmss"
     * @return String "yyyy-MM-ddTHH:mm:ss"
     */
    public static String convertToIsoLocalDateTime(String date) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
        LocalDateTime localDateTimeBefore = LocalDateTime.parse(date, formatter);

        return localDateTimeBefore.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME);
    }
    
    /**
     * Date 타입을 yyyy-MM-ddTHH:mm:ss포멧의 String 타입으로 변환한다.
     * 
     * @param Date
     * @return String "yyyy-MM-ddTHH:mm:ss"
     */
    public static String convertToIsoLocalDateTime(Date date) {
        return date.toInstant().atZone(ZoneId.of("Asia/Seoul"))
                .toLocalDateTime().truncatedTo(ChronoUnit.SECONDS).format(DateTimeFormatter.ISO_LOCAL_DATE_TIME);
    }

    public static LocalDateTime convertGmtToLocalDateTime(String gmt) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss'Z'");
        return LocalDateTime.parse(gmt, formatter);
    }

    /**
     * GMT포멧(yyyy-MM-ddTHH:mm:ssZ)의 시작, 종료일 사이의 시간차를 반환한다.
     * 
     * @param startDate 시작날짜
     * @param endDate 종료날짜
     * @param unit ChronoUnit.DAYS/HOURS/MINUTES/SECONDS
     * @return 초
     */
    public static Long getDurationFromGmt(String startDate, String endDate, ChronoUnit unit) {
        return unit.between(convertGmtToLocalDateTime(startDate), convertGmtToLocalDateTime(endDate));
    }

    /**
     * 현재 시간에서 이전 날짜를 반환한다.
     * 오늘날짜는 days = 0
     * 
     * @param days
     * @return "yyyy-MM-dd"
     */
    public static String getBeforeDayFromToday(Long days) {
        return LocalDateTime.now().minusDays(days).format(DateTimeFormatter.ISO_LOCAL_DATE);
    }

}
