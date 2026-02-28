package knou.lms.seminar.api.users;

public enum Verified {
    
    ACCOUNT_NOT_VERIFIED(0),
    ACCOUNT_VERIFIED(1);

    private int value;

    private Verified(int value) {
        this.value = value;
    }

    public int getValue() {
        return value;
    }

}
