package knou.lms.forum.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.forum.dao.ForumMutDAO;
import knou.lms.forum.service.ForumMutService;
import knou.lms.forum.vo.ForumMutVO;

@Service("forumMutService")
public class ForumMutServiceImpl extends ServiceBase implements ForumMutService {

    @Resource(name="forumMutDAO")
    private ForumMutDAO         forumMutDAO;

    // 나의 상호평가 결과
    @Override
    public ForumMutVO selectMutResult(ForumMutVO vo) throws Exception {
        return forumMutDAO.selectMutResult(vo);
    }

    // 상호평가 등록
    @Override
    public void forumMutInsert(ForumMutVO vo) throws Exception {
        forumMutDAO.forumMutInsert(vo);
    }

    // 상호평가 수정
    @Override
    public void forumMutUpdate(ForumMutVO vo) throws Exception {
        forumMutDAO.forumMutUpdate(vo);
    }

    // 상호평가 조회
    @Override
    public ForumMutVO selectMut(ForumMutVO vo) throws Exception {
        return forumMutDAO.selectMut(vo);
    }
    
    // 상호평가 목록 조회
    @Override
    public List<ForumMutVO> selectForumMutResultList(ForumMutVO vo) throws Exception {
        return forumMutDAO.selectForumMutResultList(vo);
    }

}
