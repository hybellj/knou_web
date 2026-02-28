package knou.lms.forum.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.framework.util.StringUtil;
import knou.lms.forum.dao.ForumCmntDAO;
import knou.lms.forum.service.ForumCmntService;
import knou.lms.forum.vo.ForumCmntVO;

@Service("forumCmntService")
public class ForumCmntServiceImpl extends ServiceBase implements ForumCmntService {

    @Resource(name="forumCmntDAO")
    private ForumCmntDAO         forumCmntDAO;

    // 토론 댓글 등록
    @Override
    public void insertCmnt(ForumCmntVO vo) throws Exception {
        // 내용길이 저장
        vo.setCmntCtsLen(StringUtil.getContentLenth(vo.getCmntCts()));
    	
    	forumCmntDAO.insertCmnt(vo);
    }

    // 토론방 댓글 수정
    @Override
    public void updateCmnt(ForumCmntVO vo) throws Exception {
        // 내용길이 저장
        vo.setCmntCtsLen(StringUtil.getContentLenth(vo.getCmntCts()));
        
        forumCmntDAO.updateCmnt(vo);
    }

    // 토론방 댓글 삭제
    @Override
    public void deleteCmnt(ForumCmntVO vo) throws Exception {
        forumCmntDAO.deleteCmnt(vo);
    }
    
    // 토론 댓글 조회
    @Override
    public ForumCmntVO forumCmntSelect(ForumCmntVO vo) throws Exception {
        return forumCmntDAO.forumCmntSelect(vo);
    }

}
