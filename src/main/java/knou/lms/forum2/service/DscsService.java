package knou.lms.forum2.service;

import java.util.List;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.vo.DscsListVO;
import knou.lms.forum2.vo.DscsTeamDscsVO;
import knou.lms.forum2.vo.DscsVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

public interface DscsService {
    List<DscsVO> selectDscsDvclasList(DscsVO vo) throws Exception;
    ProcessResultVO<DscsListVO> selectDscsList(DscsListVO vo) throws Exception;
    DscsVO selectDscs(DscsVO vo) throws Exception;
    ProcessResultVO<DscsVO> modifyDscsMrkOyn(DscsVO vo) throws Exception;
    void updateDscsMrkRfltrt(List<DscsVO> list) throws Exception;
    ProcessResultVO<DscsVO> saveDscs(DscsVO vo) throws Exception;
    ProcessResultVO<DscsVO> selectProfSbjctDscsList(DscsVO vo) throws Exception;
    ProcessResultVO<DscsVO> deleteDscs(DscsVO vo) throws Exception;
    ProcessResultVO<DscsVO> copyDscs(DscsVO vo) throws Exception;
    ProcessResultVO<DscsTeamDscsVO> modifyTeamDscsOyn(DscsTeamDscsVO vo) throws Exception;
    ProcessResultVO<DscsTeamDscsVO> selectDscsLrnGrpTeamList(DscsTeamDscsVO vo) throws Exception;
    void setScoreRatio(DscsVO forumVO) throws Exception;
    EgovMap viewScoreChart(DscsVO vo) throws Exception;
    List<EgovMap> selectProfSmstrChrtList(DscsVO vo) throws Exception;
    List<EgovMap> selectProfSmstrChrtSbjctList(DscsVO vo) throws Exception;
}
