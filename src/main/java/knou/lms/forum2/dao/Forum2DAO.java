package knou.lms.forum2.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.forum2.vo.Forum2ListVO;
import knou.lms.forum2.vo.Forum2VO;

@Mapper("forum2DAO")
public interface Forum2DAO {
    List<Forum2VO> selectForumDvclasList(Forum2VO vo);
    List<Forum2ListVO> selectForumList(Forum2ListVO vo);
    Forum2VO selectForum(Forum2VO vo);
    int insertForumGrp(Forum2VO vo);
    int insertForum(Forum2VO vo);
    int updateForum(Forum2VO vo);
    int updateForumMrkOyn(Forum2VO vo);
    void updateForumMrkRfltrt(List<Forum2VO> list);
    int deleteForum(Forum2VO vo);
    int copyForum(Forum2VO vo);
}
