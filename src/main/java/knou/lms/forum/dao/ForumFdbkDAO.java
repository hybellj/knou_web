package knou.lms.forum.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.forum.vo.ForumFdbkVO;

@Mapper("forumFdbkDAO")
public interface ForumFdbkDAO {

    /*****************************************************
     * TODO 토론 피드백 목록 조회
     * @param ForumFdbkVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> forumFdbkList(ForumFdbkVO vo) throws Exception;
    
    /*****************************************************
     * TODO 토론 피드백 등록
     * @param ForumFdbkVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertForumFdbk(ForumFdbkVO vo) throws Exception;
    
    /*****************************************************
     * TODO 토론 피드백 수정
     * @param ForumFdbkVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateForumFdbk(ForumFdbkVO vo) throws Exception;
    
    /*****************************************************
     * TODO 토론 피드백 삭제
     * @param ForumFdbkVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void deleteForumFdbk(ForumFdbkVO vo) throws Exception;

    // 일괄 피드백 등록
    public void insertForumAllFdbk(ForumFdbkVO vo) throws Exception;

    // 피드백 조회
    public List<ForumFdbkVO> selectFdbk(ForumFdbkVO vo) throws Exception;
    
    // 피드백 저장
    public void insertFdbk(ForumFdbkVO vo) throws Exception;
    
    // 피드백 수정
    public void updateFdbk(ForumFdbkVO vo) throws Exception;
    
    // 피드백 삭제
    public void deleteFdbk(ForumFdbkVO vo) throws Exception;

    // 피드백 갯수
    public int cntFdbk(ForumFdbkVO vo) throws Exception;

}
