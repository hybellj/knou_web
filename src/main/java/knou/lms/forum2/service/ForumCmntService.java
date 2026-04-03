package knou.lms.forum2.service;

import java.util.List;

import knou.lms.forum.vo.ForumCmntVO;

public interface ForumCmntService {

    public void insertCmnt(ForumCmntVO vo) throws Exception;
    public void updateCmnt(ForumCmntVO vo) throws Exception;
    public void deleteCmnt(ForumCmntVO vo) throws Exception;
    public void hideCmnt(ForumCmntVO vo) throws Exception;
    public ForumCmntVO forumCmntSelect(ForumCmntVO vo) throws Exception;

}
