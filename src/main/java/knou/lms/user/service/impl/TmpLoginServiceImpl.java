package knou.lms.user.service.impl;


import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import org.egovframe.rte.fdl.cmmn.exception.EgovBizException;
import knou.framework.exception.AjaxProcessException;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.user.dao.TmpLoginDAO;
import knou.lms.user.service.TmpLoginService;
import knou.lms.user.vo.TmpLoginVO;

@Service("tmpLoginService")
public class TmpLoginServiceImpl implements TmpLoginService {
    
    @Resource(name="tmpLoginDAO")
    private TmpLoginDAO tmpLoginDAO;

    @Override
    public List<TmpLoginVO> selectTmpLoginList() throws EgovBizException {
        return tmpLoginDAO.selectTmpLoginList();
    }

    @Override
    public ProcessResultVO<TmpLoginVO> selectTmpLoginUserInfo(TmpLoginVO tmpLoginVO) throws EgovBizException {
        ProcessResultVO<TmpLoginVO> result = new ProcessResultVO<TmpLoginVO>();
        
        TmpLoginVO usrInfo = tmpLoginDAO.selectTmpLoginUserInfo(tmpLoginVO);
        
        if(null != usrInfo) {
            result.setReturnVO(usrInfo);
        } else {
            throw new AjaxProcessException("잘못된 유저정보입니다.");
        }
        
        
        
        return result;
    }


   

}

