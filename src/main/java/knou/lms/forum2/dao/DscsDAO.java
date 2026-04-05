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
    List<DscsVO> selectDscsDvclasList(DscsVO vo);
    List<DscsListVO> selectDscsList(DscsListVO vo);
    DscsVO selectDscs(DscsVO vo);
    int insertDscsGrp(DscsVO vo);
    int insertDscs(DscsVO vo);
    int updateDscs(DscsVO vo);
    int updateDscsMrkOyn(DscsVO vo);
    void updateDscsMrkRfltrt(List<DscsVO> list);
    int deleteDscs(DscsVO vo);
    public DscsVO select(DscsVO vo) throws Exception;
    int copyDscs(DscsVO vo);
    int updateChildDscsDelYn(DscsVO vo);
    int updateChildDscsDtls(DscsTeamDscsVO vo);
    List<DscsTeamDscsVO> selectTeamDscsList(String dscsId);
    List<DscsTeamDscsVO> selectDscsLrnGrpTeamList(DscsTeamDscsVO vo);
    int updateTeamDscsOyn(DscsTeamDscsVO vo);
    public List<DscsVO> getScoreRatio(DscsVO vo) throws Exception;
    public void setScoreRatio(DscsVO vo) throws Exception;
    public EgovMap selectScoreChart(DscsVO vo) throws Exception;
    List<EgovMap> selectProfSmstrChrtList(DscsVO vo);
    List<EgovMap> selectProfSmstrChrtSbjctList(DscsVO vo);
    public List<DscsVO> selectProfSbjctDscsList(DscsVO vo) throws Exception;
}
