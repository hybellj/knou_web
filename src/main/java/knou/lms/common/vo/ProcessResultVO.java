package knou.lms.common.vo;

import java.util.List;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import knou.lms.common.AbstractResult;

/**
 * 처리결과 반환 클래스
 * @param <T>
 */
public class ProcessResultVO<T> extends AbstractResult {
    public final static int RESULT_SUCC = 1;		// 처리결과 성공
    public final static int RESULT_FAIL = -1;	// 처리결과 실패

    private List<T> returnList;						// 처리결과 목록
    private List<T> returnListSub;					// 처리결과 서브목록
    private Object returnVO;						// 처리결과 반환 VO
    private Object returnSubVO;						// 처리결과 반환 서브VO
    private PaginationInfo pageInfo;				// 페이지정보
    private boolean success;						// 성공여부
    private String eparam;							// 결과처리후 반환할 암호화 파라메터

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

	public String getEparam() {
		return eparam;
	}

	public void setEparam(String eparam) {
		this.eparam = eparam;
	}
}