package knou.lms.forum.dao;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.forum.vo.ForumCreCrsRltnVO;

@Mapper("forumCreCrsRltnDAO")
public interface ForumCreCrsRltnDAO {

    // 개설과정 그룹코드 조회
    public ForumCreCrsRltnVO selectGrpCd(ForumCreCrsRltnVO vo) throws Exception;

    // 개설과정 토론 연결 등록
    public void insertCreCrsForumRltn(ForumCreCrsRltnVO vo) throws Exception;

}
