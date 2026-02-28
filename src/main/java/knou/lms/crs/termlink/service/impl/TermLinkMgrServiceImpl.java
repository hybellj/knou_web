package knou.lms.crs.termlink.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.crs.termlink.dao.TermLinkMgrDAO;
import knou.lms.crs.termlink.service.TermLinkMgrService;
import knou.lms.crs.termlink.vo.TermLinkMgrVO;

@Service("termLinkMgrService")
public class TermLinkMgrServiceImpl extends ServiceBase implements TermLinkMgrService {

    @Resource(name="termLinkMgrDAO")
    private TermLinkMgrDAO termLinkMgrDAO;

    /*****************************************************
     * <p>
     * TODO 학사연동 관리 조회
     * </p>
     * 학사연동 관리 조회
     *
     * @param TermLinkMgrVO
     * @return TermLinkMgrVO
     * @throws Exception
     ******************************************************/
    @Override
    public TermLinkMgrVO select(TermLinkMgrVO vo) throws Exception {
        vo = termLinkMgrDAO.select(vo);
        if(!ValidationUtils.isEmpty(vo.getLastLinkDttm())) {
            vo.setLastLinkDttm(DateTimeUtil.getDateType(13, vo.getLastLinkDttm(), "."));
        }
        return vo;
    }

    /*****************************************************
     * <p>
     * TODO 학사연동 관리 수정
     * </p>
     * 학사연동 관리 수정
     *
     * @param TermLinkMgrVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void update(TermLinkMgrVO vo) throws Exception {
        termLinkMgrDAO.update(vo);
    }
    
}
