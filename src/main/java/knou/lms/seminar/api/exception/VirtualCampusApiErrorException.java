package knou.lms.seminar.api.exception;

public class VirtualCampusApiErrorException extends VirtualCampusApiException {

    private static final long serialVersionUID = -3557755512128279889L;
    public VirtualCampusApiErrorException(ErrorType errorType, String orgId, String userId, Object errorArg) {
        super(errorType.getErrMsg());
        super.errorType = errorType;
        super.orgId = orgId;
        super.userId = userId;
        super.errorArg = errorArg;
    }

    public VirtualCampusApiErrorException(ErrorType errorType, String extraErrMessage, String orgId, String userId, Object errorArg) {
        super(errorType.getErrMsg() + " " + extraErrMessage);
        super.errorType = errorType;
        super.errMessage = super.getMessage();
        super.orgId = orgId;
        super.userId = userId;
        super.errorArg = errorArg;
    }

}
