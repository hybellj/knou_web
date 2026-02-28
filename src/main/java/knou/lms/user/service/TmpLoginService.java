package knou.lms.user.service;

import java.util.List;

import org.egovframe.rte.fdl.cmmn.exception.EgovBizException;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.user.vo.TmpLoginVO;

public interface TmpLoginService {

    public List<TmpLoginVO> selectTmpLoginList() throws EgovBizException;

    public ProcessResultVO<TmpLoginVO> selectTmpLoginUserInfo(TmpLoginVO tmpLoginVO) throws EgovBizException;
    

}
