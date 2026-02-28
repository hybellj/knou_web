package knou.lms.seminar.api.meetings;

public enum ApprovalType {
    
    AUTOMATICALLY_APPROVE(0),
    MANUALLY_APPROVE(1),
    NO_REGISTRATION_REQUIRED(2);
    
    private int type;
    
    private ApprovalType(int type) {
        this.type = type;
    }
    
    public int getType() {
        return this.type;
    }

}
