package knou.lms.smnr.pltfrm.zoom.api.common;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class ZoomDateUtils {

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
     * yyyy-MM-dd'T'HH:mm:ss'Z'포멧의 날짜를 yyyyMMddHHmmss포멧으로 변환한다.
     *
     * @param String "yyyy-MM-dd'T'HH:mm:ss'Z'"
     * @return String "yyyyMMddHHmmss"
     */
    public static String convertToKstLocalDateTime(String date) {
    	if (date == null || date.isEmpty()) {
            return null;
        }

        // Z 없으면 추가
        if (!date.endsWith("Z")) {
            date += "Z";
        }

        // UTC 파싱
        DateTimeFormatter zoomFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss'Z'");
        LocalDateTime utcTime = LocalDateTime.parse(date, zoomFormatter);

        // KST 변환 (+9시간)
        LocalDateTime kstTime = utcTime.plusHours(9);

        // DB 저장용 포맷으로 변환
        DateTimeFormatter dbFormatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
        return kstTime.format(dbFormatter);
    }

    /**
     * yyyy-MM-dd'T'HH:mm:ss'Z'포멧의 날짜와 회의시간(분)을 합산하여 종료날짜를 yyyyMMddHHmmss포멧으로 변환한다.
     *
     * @param date     "yyyy-MM-dd'T'HH:mm:ss'Z'"
     * @param duration 회의시간 (분)
     * @return String "yyyyMMddHHmmss"
     */
    public static String convertToKstEndDateTime(String date, int duration) {
        if (date == null || date.isEmpty()) {
            return null;
        }

        // Z 없으면 추가
        if (!date.endsWith("Z")) {
            date += "Z";
        }

        // UTC 파싱
        DateTimeFormatter zoomFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss'Z'");
        LocalDateTime utcTime = LocalDateTime.parse(date, zoomFormatter);

        // KST 변환 (+9시간) + 회의시간 (분) 합산
        LocalDateTime kstEndTime = utcTime.plusHours(9).plusMinutes(duration);

        // DB 저장용 포맷으로 변환
        DateTimeFormatter dbFormatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
        return kstEndTime.format(dbFormatter);
    }

}
