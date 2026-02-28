package knou.lms.seminar.api.exception;

public class VirtualCampusApiException extends RuntimeException {

    private static final long serialVersionUID = -1624329258316427382L;
    protected ErrorType errorType = ErrorType.EXCEPTION;
    protected String orgId;
    protected String userId;
    protected Object errorArg;
    protected String errMessage;
    protected Object responseValue;

    public VirtualCampusApiException(String message) {
        super(message);
    }

    public VirtualCampusApiException(ErrorType errorType) {
        super(errorType.getErrMsg());
        this.errorType = errorType;
    }

    public VirtualCampusApiException(ErrorType errorType, Throwable cause) {
        super(cause);
        this.errorType = errorType;
    }

    public VirtualCampusApiException(ErrorType errorType, String orgId,
            String userId, Object errorArg, Throwable cause) {
        super(cause);
        this.errorType = errorType;
        this.orgId = orgId;
        this.userId = userId;
        this.errorArg = errorArg;
    }

    public VirtualCampusApiException(ErrorType errorType, String orgId,
            String userId, Throwable cause) {
        super(cause);
        this.errorType = errorType;
        this.orgId = orgId;
        this.userId = userId;
    }

    public String getErrCode() {
        return this.errorType.getErrCode();
    }

    public String getOrgId() {
        return orgId;
    }

    public String getUserId() {
        return userId;
    }

    public Object getErrorArg() {
        return errorArg;
    }

    public String getResponseErrorMsg() {
        if (this.errMessage != null) {
            return this.errMessage;
        }
        return this.errorType.getErrMsg();
    }

    public boolean isEnabledExceptionLog() {
        return this.errorType.isEnabledExceptionLog();
    }

    public Object getResponseValue() {
        return responseValue;
    }

    public void setResponseValue(Object responseValue) {
        this.responseValue = responseValue;
    }

}
