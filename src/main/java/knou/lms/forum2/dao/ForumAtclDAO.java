package knou.lms.forum2.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.forum.vo.ForumAtclVO;
import knou.lms.forum.vo.ForumMutVO;
import knou.lms.forum.vo.ForumVO;

@Mapper("forum2AtclDAO")
public interface ForumAtclDAO {

    public int forumAtclCount(ForumAtclVO vo) throws Exception;
    public int count(ForumAtclVO vo) throws Exception;
    public List<ForumAtclVO> listPageing(ForumAtclVO vo) throws Exception;
    public void insertAtcl(ForumAtclVO vo) throws Exception;
    public ForumAtclVO selectAtcl(ForumAtclVO vo) throws Exception;
    public void updateAtcl(ForumAtclVO vo) throws Exception;
    public void deleteAtcl(ForumAtclVO vo) throws Exception;
//    public ForumAtclVO selectMutResult(ForumAtclVO vo) throws Exception;
/*
    public List<ForumAtclVO> selectAtclUserList(ForumMutVO vo) throws Exception;*/
    public List<ForumAtclVO> forumAtclList(ForumAtclVO vo) throws Exception;
	public int myAtclCnt(ForumAtclVO vo) throws Exception;
    public List<ForumAtclVO> forumAtclExcalList(ForumAtclVO vo) throws Exception;

}
