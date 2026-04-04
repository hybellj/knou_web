package knou.lms.forum2.dao;

import java.util.List;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.vo.DscsTeamDscsVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.forum2.vo.DscsListVO;
import knou.lms.forum2.vo.DscsVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

@Mapper("dscsDAO")
public interface DscsDAO {
    List<DscsVO> selectForumDvclasList(DscsVO vo);
    List<DscsListVO> selectForumList(DscsListVO vo);
    DscsVO selectForum(DscsVO vo);
    int insertForumGrp(DscsVO vo);
    int insertForum(DscsVO vo);
    int updateForum(DscsVO vo);
    int updateForumMrkOyn(DscsVO vo);
    void updateForumMrkRfltrt(List<DscsVO> list);
    int deleteForum(DscsVO vo);
    public DscsVO select(DscsVO vo) throws Exception;
    int copyForum(DscsVO vo);
    int updateChildForumDelYn(DscsVO vo);
    int updateChildForumDtls(DscsTeamDscsVO vo);
    List<DscsTeamDscsVO> selectTeamDscsList(String dscsId);
    List<DscsTeamDscsVO> selectForumLrnGrpTeamList(DscsTeamDscsVO vo);
    int updateTeamDscsOyn(DscsTeamDscsVO vo);
    public List<DscsVO> getScoreRatio(DscsVO vo) throws Exception;
    public void setScoreRatio(DscsVO vo) throws Exception;
    public EgovMap selectScoreChart(DscsVO vo) throws Exception;
    List<EgovMap> selectProfSmstrChrtList(DscsVO vo);
    List<EgovMap> selectProfSmstrChrtSbjctList(DscsVO vo);
    public List<DscsVO> selectProfSbjctForumList(DscsVO vo) throws Exception;
}
