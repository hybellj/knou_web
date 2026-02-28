package knou.lms.seminar.api.users;

public enum Language {
    
    KOREAN("ko-KO");
    
    private String value;

    private Language(String value) {
        this.value = value;
    }

    public String getValue() {
        return this.value;
    }

}
