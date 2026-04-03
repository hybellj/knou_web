package knou.lms.forum2.service;

import java.util.List;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.vo.Forum2ListVO;
import knou.lms.forum2.vo.Forum2TeamDscsVO;
import knou.lms.forum2.vo.Forum2VO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

public interface ForumService {
    List<Forum2VO> selectForumDvclasList(Forum2VO vo) throws Exception;
    ProcessResultVO<Forum2ListVO> selectForumList(Forum2ListVO vo) throws Exception;
    Forum2VO selectForum(Forum2VO vo) throws Exception;
    ProcessResultVO<Forum2VO> modifyForumMrkOyn(Forum2VO vo) throws Exception;
    void updateForumMrkRfltrt(List<Forum2VO> list) throws Exception;
    ProcessResultVO<Forum2VO> saveForum(Forum2VO vo) throws Exception;
    ProcessResultVO<Forum2VO> selectProfSbjctForumList(Forum2VO vo) throws Exception;
    ProcessResultVO<Forum2VO> deleteForum(Forum2VO vo) throws Exception;
    ProcessResultVO<Forum2VO> copyForum(Forum2VO vo) throws Exception;
    ProcessResultVO<Forum2TeamDscsVO> modifyTeamDscsOyn(Forum2TeamDscsVO vo) throws Exception;
    ProcessResultVO<Forum2TeamDscsVO> selectForumLrnGrpTeamList(Forum2TeamDscsVO vo) throws Exception;
    void setScoreRatio(Forum2VO forumVO) throws Exception;
    EgovMap viewScoreChart(Forum2VO vo) throws Exception;
    List<EgovMap> selectProfSmstrChrtList(Forum2VO vo) throws Exception;
    List<EgovMap> selectProfSmstrChrtSbjctList(Forum2VO vo) throws Exception;
}
