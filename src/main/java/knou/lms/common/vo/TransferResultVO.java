package knou.lms.common.vo;

import org.springframework.http.HttpStatus;

public class TransferResultVO
{

    private HttpStatus statusCd;         // http 통신 상태 코드
    private String resultCd;         // 업무 처리 결과 코드
    private String resultMsg;        // 업무 처리 결과 메시지
    private String resultJsonString; // 업무 처리 결과 응답 json string

    /** @return statusCd 값을 반환한다. */
    public HttpStatus getStatusCd()
    {
        return statusCd;
    }

    /**
     * @param statusCd
     *            을 statusCd 에 저장한다.
     */
    public void setStatusCd(HttpStatus statusCd)
    {
        this.statusCd = statusCd;
    }

    /** @return resultCd 값을 반환한다. */
    public String getResultCd()
    {
        return resultCd;
    }

    /**
     * @param resultCd
     *            을 resultCd 에 저장한다.
     */
    public void setResultCd(String resultCd)
    {
        this.resultCd = resultCd;
    }

    /** @return resultMsg 값을 반환한다. */
    public String getResultMsg()
    {
        return resultMsg;
    }

    /**
     * @param resultMsg
     *            을 resultMsg 에 저장한다.
     */
    public void setResultMsg(String resultMsg)
    {
        this.resultMsg = resultMsg;
    }

    /** @return resultJsonString 값을 반환한다. */
    public String getResultJsonString()
    {
        return resultJsonString;
    }

    /**
     * @param resultJsonString
     *            을 resultJsonString 에 저장한다.
     */
    public void setResultJsonString(String resultJsonString)
    {
        this.resultJsonString = resultJsonString;
    }

}
