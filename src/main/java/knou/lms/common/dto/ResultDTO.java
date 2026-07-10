package knou.lms.common.dto;

import java.util.List;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

import knou.framework.common.PageInfo;
import knou.lms.common.AbstractResult;

/**
 * 처리결과 반환 클래스
 * @param <T>
 */
public class ResultDTO<T> extends AbstractResult {

    public final static int RESULT_SUCC =  1;		// 처리결과 성공
    public final static int RESULT_FAIL = -1;		// 처리결과 실패
    
    private T data; 								// 단건데이터
    private List<T> returnList;						// 처리결과 목록
    private PaginationInfo pageInfo;				// 페이지정보
    private boolean success;						// 성공여부
    private String encParams;						// 결과처리후 반환할 암호화 파라메터
    private	int 	successCount;						// 성공개수

    public ResultDTO() {
        super();
        this.success = false;
        super.setResult(RESULT_FAIL);
    }    
    
    public T getData() {
		return data;
	}

	public ResultDTO<T> setData(T data) {
		this.data = data;
		return this;
	}

	public ResultDTO<T> setReturnList(List<T> returnList) {
        this.returnList = returnList;
        return this;
    }
	
	public int 	getSuccessCount() {
		return this.successCount;
	}
    
    public ResultDTO<T> setSuccessCount(int successCount) {
    	this.successCount =  successCount;
    	if ( 1 <= successCount )
    		setResult(RESULT_SUCC);
    	else
    		setResult(RESULT_FAIL);
        return this;
    }
    
    public ResultDTO<T> returnMessage(String message) {
        super.setMessage(message);
        return this;
    }

	public ResultDTO(List<T> returnList) {
        super();
        this.returnList = returnList;
    }

    public ResultDTO(List<T> returnList, int result) {
        super();
        this.returnList = returnList;
        setResult(result);
    }

    public ResultDTO(PageInfo pageInfo2) {
    	this.pageInfo = pageInfo2;
	}

	public List<T> getReturnList() {
        return returnList;
    }

    public PaginationInfo getPageInfo() {
        return pageInfo;
    }
    public void setPageInfo(PaginationInfo pageInfo) {
        this.pageInfo = pageInfo;
    }

    /**
     * 성공 코드를 설정하고 자신을 반환한다.
     * @return
     */
    public ResultDTO<T> setResultSuccess() {
        super.setResult(RESULT_SUCC);
        return this;
    }
    /**
     * 성공 코드를 설정하고 자신을 반환한다.
     * @return
     */
    public ResultDTO<T> setResultSuccess(String message) {
        super.setResult(RESULT_SUCC);
        super.setMessage(message);
        return this;
    }

    /**
     * 실패 코드를 설정하고 자신을 반환한다.
     * @return
     */
    public ResultDTO<T> setResultFailed() {
        super.setResult(RESULT_FAIL);
        return this;
    }

    /**
     * 실패 코드와 메시지를 설정하고 자신을 반환한다.
     * @return
     */
    public ResultDTO<T> setResultFailed(String message) {
    	super.setResult(RESULT_FAIL);
    	super.setMessage(message);
    	return this;
    }

    public static int getResultSucc() {
        return RESULT_SUCC;
    }

    public static int getResultFail() {
        return RESULT_FAIL;
    }

	public boolean isSuccess() {
		return success;
	}

	public void setSuccess(boolean success) {
		this.success = success;
	}

	public String getEncParams() {
		return encParams;
	}

	public void setEncParams(String encParams) {
		this.encParams = encParams;
	}
}