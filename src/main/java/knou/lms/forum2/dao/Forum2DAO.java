package knou.lms.forum2.dao;

import java.util.List;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.vo.Forum2TeamDscsVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.forum2.vo.Forum2ListVO;
import knou.lms.forum2.vo.Forum2VO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

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

    public Forum2VO select(Forum2VO vo) throws Exception;
    int copyForum(Forum2VO vo);
    int updateChildForumDelYn(Forum2VO vo);
    int updateChildForumDtls(Forum2TeamDscsVO vo);

    List<Forum2TeamDscsVO> selectTeamDscsList(String dscsId);
    List<Forum2TeamDscsVO> selectForumLrnGrpTeamList(Forum2TeamDscsVO vo);
    int updateTeamDscsOyn(Forum2TeamDscsVO vo);

    public List<Forum2VO> getScoreRatio(Forum2VO vo) throws Exception;

    public void setScoreRatio(Forum2VO vo) throws Exception;
    public EgovMap selectScoreChart(Forum2VO vo) throws Exception;

    List<EgovMap> selectProfSmstrChrtList(Forum2VO vo);
    List<EgovMap> selectProfSmstrChrtSbjctList(Forum2VO vo);
    public List<Forum2VO> selectProfSbjctForumList(Forum2VO vo) throws Exception;
}
