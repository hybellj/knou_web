package knou.lms.forum2.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.framework.util.StringUtil;
import knou.lms.forum2.dao.DscsCmntDAO;
import knou.lms.forum2.service.DscsCmntService;
import knou.lms.forum2.vo.DscsCmntVO;

@Service("dscsCmntService")
public class DscsCmntServiceImpl extends ServiceBase implements DscsCmntService {

    @Resource(name="dscsCmntDAO")
    private DscsCmntDAO         dscsCmntDAO;

    // 토론 댓글 등록
    @Override
    public void insertCmnt(DscsCmntVO vo) throws Exception {
        // 내용길이 저장
        vo.setCmntCtsLen(StringUtil.getContentLenth(vo.getCmntCts()));
    	
    	dscsCmntDAO.insertCmnt(vo);
    }

    // 토론방 댓글 수정
    @Override
    public void updateCmnt(DscsCmntVO vo) throws Exception {
        // 내용길이 저장
        vo.setCmntCtsLen(StringUtil.getContentLenth(vo.getCmntCts()));
        
        dscsCmntDAO.updateCmnt(vo);
    }

    // 토론방 댓글 삭제
    @Override
    public void deleteCmnt(DscsCmntVO vo) throws Exception {
        dscsCmntDAO.deleteCmnt(vo);
    }

    // 토론방 댓글 숨김
    @Override
    public void hideCmnt(DscsCmntVO vo) throws Exception {
        dscsCmntDAO.hideCmnt(vo);
    }

    // 토론 댓글 조회
    @Override
    public DscsCmntVO selectCmnt(DscsCmntVO vo) throws Exception {
        return dscsCmntDAO.selectCmnt(vo);
    }

}
