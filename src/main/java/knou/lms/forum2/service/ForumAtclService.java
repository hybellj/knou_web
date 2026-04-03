package knou.lms.forum2.service;

import java.util.List;


import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum.vo.ForumAtclVO;
import knou.lms.forum.vo.ForumMutVO;

public interface ForumAtclService {

    public int forumAtclCount(ForumAtclVO vo) throws Exception;
    public abstract ProcessResultVO<ForumAtclVO> listPageing(ForumAtclVO vo) throws Exception;
    public void insertAtcl(ForumAtclVO vo, String teamCd) throws Exception;
    public ForumAtclVO selectAtcl(ForumAtclVO vo) throws Exception;
    public void updateAtcl(ForumAtclVO vo) throws Exception;
    public void deleteAtcl(ForumAtclVO vo) throws Exception;
    public void hideAtcl(ForumAtclVO vo) throws Exception;
    public List<ForumAtclVO> forumAtclList(ForumAtclVO vo) throws Exception;
	public int myAtclCnt(ForumAtclVO vo) throws Exception;
    public List<ForumAtclVO> forumAtclExcalList(ForumAtclVO vo) throws Exception;

}
