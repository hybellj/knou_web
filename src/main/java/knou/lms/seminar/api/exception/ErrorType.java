package knou.lms.seminar.api.exception;

public enum ErrorType {

    NO_ERROR("0", "-", false),
    
    ILLEGAL_SITE("-100", "부적합한 사이트", false),
    
    // VC 사용자 에러
    ILLEGAL_USER("-101", "부적합한 사용자", false),
    LOGIN_FAIL("-102", "로그인 실패한 사용자", false),
    REQUIRED_API_AUTHORIZATION("-103", "비디오 협업 서비스의 인증이 필요한 사용자", false),
    SUSPENDING_USER("-104", "일시정지 상태인 사용자", false),
    REQUIRED_PASSWORD_RESET("-105", "비밀번호 초기화가 필요한 사용자", false),
    MEETING_UNREGISTERED_USER("-106", "화상강의에 등록되지 않은 사용자", false),
    USER_IDT_VERIFIED("-107", "활성화 되지 않고 보류중인 사용자", false),
    UNLICENSED_USERS("-108", "라이선스가 없는 사용자", false),
    
    // 예외
    EXCEPTION("-400", "예외 발생", true),

    // 토큰 인증(모든 시스템에서 사용)
    INVALID_TOKEN("-500", "인증할 수 없는 토큰", false),
    EXPIRED_TOKEN("-501", "사용 만료된 토큰", false),
    
    // Webhook 처리에서 발생한 에러
    WEBHOOK_PARTICIPANT_EMPTY("-600", "Webhook 출석정보 없음", true),
    WEBHOOK_PARTICIPANT_INSERT("-601", "Webhook 출석정보 등록 실패", true),
    WEBHOOK_RECORDING_INSERT("-602", "Webhook 다시보기정보 등록 실패", true),
    
    // 비디오 협업 서비스의 응답 에러
    API_RESPONSE_ERROR("-700", "호출 API에서 에러 응답", false),
    API_NOT_EXIST_USER("-701", "비디오 협업 서비스에 등록되지 않은 사용자", false);

    private String errCode;
    private String errMsg;
    private boolean isExceptionLog;

    private ErrorType(String errCode, String errMsg, boolean isExceptionLog) {
        this.isExceptionLog = isExceptionLog;
        this.errCode = errCode;
        this.errMsg = errMsg;
    }

    public String getErrCode() {
        return errCode;
    }

    public String getErrMsg() {
        return errMsg;
    }

    public boolean isEnabledExceptionLog() {
        return isExceptionLog;
    }

    public static ErrorType valueOfErrCode(String errCode) {
        for (ErrorType value : values()) {
            if (value.errCode.equals(errCode)) {
                return value;
            }
        }
        throw new IllegalArgumentException("No enum constant " + errCode + " error code.");
    }
    
}
