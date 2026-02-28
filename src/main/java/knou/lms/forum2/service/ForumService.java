package knou.lms.forum2.service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.vo.Forum2ListVO;
import knou.lms.forum2.vo.Forum2VO;

public interface ForumService {
    ProcessResultVO<Forum2ListVO> selectForumList(Forum2ListVO vo) throws Exception;
    ProcessResultVO<Forum2VO> selectForum(Forum2VO vo) throws Exception;
    ProcessResultVO<Forum2VO> saveForum(Forum2VO vo) throws Exception;
    ProcessResultVO<Forum2VO> deleteForum(Forum2VO vo) throws Exception;
    ProcessResultVO<Forum2VO> copyForum(Forum2VO vo) throws Exception;
}
