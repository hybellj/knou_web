package knou.lms.common.vo;

import java.util.List;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import knou.lms.common.AbstractResult;

public class ProcessResultVO<T> extends AbstractResult {

    private List<T> returnList;
    private List<T> returnListSub;
    
    private Object returnVO;
    private Object returnSubVO;
    
    private PaginationInfo pageInfo;

    public final static int RESULT_SUCC = 1;
    public final static int RESULT_FAIL = -1;
    
    private boolean success;
    
    public ProcessResultVO() {
        super();
    }
    
    public ProcessResultVO(List<T> returnList) {
        super();
        this.returnList = returnList;
    }

    public List<T> getReturnList() {
        return returnList;
    }
    public void setReturnList(List<T> returnList) {
        this.returnList = returnList;
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
    public void setReturnVO(Object returnVO) {
        this.returnVO = returnVO;
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
}