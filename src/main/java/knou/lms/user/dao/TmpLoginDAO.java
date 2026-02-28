package knou.lms.user.dao;


import java.util.List;

import org.egovframe.rte.fdl.cmmn.exception.EgovBizException;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.user.vo.TmpLoginVO;

@Mapper("tmpLoginDAO")
public interface TmpLoginDAO {

    public List<TmpLoginVO> selectTmpLoginList() throws EgovBizException;

    public TmpLoginVO selectTmpLoginUserInfo(TmpLoginVO tmpLoginVO) throws EgovBizException;

}
