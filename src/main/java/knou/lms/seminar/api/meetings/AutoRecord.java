package knou.lms.seminar.api.meetings;

public enum AutoRecord {
    
    LOCAL("local"),
    CLOUD("cloud"),
    NONE("none");

    private String value;

    private AutoRecord(String value) {
        this.value = value;
    }

    public String getValue() {
        return this.value;
    }

}
