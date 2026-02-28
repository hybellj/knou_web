package knou.lms.sys.service;

import knou.lms.common.vo.ProcessResultListVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.sys.vo.SysCodeVO;
import knou.lms.sys.vo.SysJobSchVO;

public interface SysCodeService {

    /**
     * 코드 정보의 목록를 반환한다.
     * @param SysCodeCtgrVO
     * @return ProcessResultVO<SysCodeVO>
     * @throws Exception
     */
    public abstract ProcessResultVO<SysCodeVO> listCode(String codeCtgrCd) throws Exception;
    
    /**
     * 코드 정보의 목록를 반환한다.
     * @param SysCodeCtgrVO
     * @return ProcessResultVO<SysCodeVO>
     * @throws Exception
     */
    public abstract ProcessResultVO<SysCodeVO> listCode(String codeCtgrCd, boolean use) throws Exception;
    
    /**
     * DB에서 코드를 읽어와 리턴한다.
     * @param codeCtgrCd
     * @return ProcessResultVO<SysCodeVO>
     */
    public abstract ProcessResultVO<SysCodeVO> listCodeByDB(String codeCtgrCd) throws Exception;

    // 업무구분  목록
    public ProcessResultListVO<SysCodeVO> jobSchCalendarCtgrNmList(String orgId) throws Exception;
}
