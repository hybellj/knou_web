package knou.lms.seminar.api.meetings;

public enum TimeZone {
    
    ASIA_SEOUL("Asia/Seoul");

    private String value;

    private TimeZone(String value) {
        this.value = value;
    }

    public String getValue() {
        return this.value;
    }

}
