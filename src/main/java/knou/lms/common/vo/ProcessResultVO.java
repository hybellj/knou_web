package knou.lms.common.vo;

import java.util.List;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import knou.framework.common.PageInfo;
import knou.lms.common.AbstractResult;

/**
 * 처리결과 반환 클래스
 * @param <T>
 */
public class ProcessResultVO<T> extends AbstractResult {

	private static final Logger log = LoggerFactory.getLogger(ProcessResultVO.class);

    public final static int RESULT_SUCC =  1;		// 처리결과 성공
    public final static int RESULT_FAIL = -1;		// 처리결과 실패
    
    private T data; 								// 단건데이터
    private List<T> returnList;						// 처리결과 목록
    private List<T> returnListSub;					// 처리결과 서브목록
    private Object returnVO;						// 처리결과 반환 VO
    private Object returnSubVO;						// 처리결과 반환 서브VO
    private PaginationInfo pageInfo;				// 페이지정보
    private boolean success;						// 성공여부
    private String encParams;						// 결과처리후 반환할 암호화 파라메터

    public ProcessResultVO() {
        super();
        this.success = false;
        super.setResult(RESULT_FAIL);
    }    
    
    public T getData() {
		return data;
	}

	public void setData(T data) {
		this.data = data;
	}

	public ProcessResultVO<T> setReturnList(List<T> returnList) {
        this.returnList = returnList;
        return this;
    }
    
    public ProcessResultVO<T> setSuccessCount(int successCnt) {
    	if ( 1 <= successCnt )
    		setResult(RESULT_SUCC);
    	else
    		setResult(RESULT_FAIL);
        return this;
    }
    
    public ProcessResultVO<T> returnMessage(String message) {
        super.setMessage(message);
        return this;
    }

	public ProcessResultVO(List<T> returnList) {
        super();
        this.returnList = returnList;
    }

    public ProcessResultVO(List<T> returnList, int result) {
        super();
        this.returnList = returnList;
        setResult(result);
    }

    public ProcessResultVO(PageInfo pageInfo2) {
    	this.pageInfo = pageInfo2;
	}

	public List<T> getReturnList() {
        return returnList;
    }

    public List<T> getReturnListSub() {
        return returnListSub;
    }
    public void setReturnListSub(List<T> returnList) {
        this.returnListSub = returnList;
    }
    public PaginationInfo getPageInfo() {
        return pageInfo;
    }
    public void setPageInfo(PaginationInfo pageInfo) {
        this.pageInfo = pageInfo;
    }

    public Object getReturnVO() {
        return returnVO;
    }
    public ProcessResultVO<T> setReturnVO(Object returnVO) {
        this.returnVO = returnVO;
        return this;
    }

    public Object getReturnSubVO() {
        return returnSubVO;
    }

    public void setReturnSubVO(Object returnSubVO) {
        this.returnSubVO = returnSubVO;
    }
    /**
     * 성공 코드를 설정하고 자신을 반환한다.
     * @return
     */
    public ProcessResultVO<T> setResultSuccess() {
        super.setResult(RESULT_SUCC);
        return this;
    }
    /**
     * 성공 코드를 설정하고 자신을 반환한다.
     * @return
     */
    public ProcessResultVO<T> setResultSuccess(String message) {
        super.setResult(RESULT_SUCC);
        super.setMessage(message);
        return this;
    }

    /**
     * 실패 코드를 설정하고 자신을 반환한다.
     * @return
     */
    public ProcessResultVO<T> setResultFailed() {
        super.setResult(RESULT_FAIL);
        return this;
    }

    /**
     * 실패 코드와 메시지를 설정하고 자신을 반환한다.
     * @return
     */
    public ProcessResultVO<T> setResultFailed(String message) {
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