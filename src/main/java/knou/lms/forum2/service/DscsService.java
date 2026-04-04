package knou.lms.forum2.service;

import java.util.List;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.vo.DscsListVO;
import knou.lms.forum2.vo.DscsTeamDscsVO;
import knou.lms.forum2.vo.DscsVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

public interface DscsService {
    List<DscsVO> selectForumDvclasList(DscsVO vo) throws Exception;
    ProcessResultVO<DscsListVO> selectForumList(DscsListVO vo) throws Exception;
    DscsVO selectForum(DscsVO vo) throws Exception;
    ProcessResultVO<DscsVO> modifyForumMrkOyn(DscsVO vo) throws Exception;
    void updateForumMrkRfltrt(List<DscsVO> list) throws Exception;
    ProcessResultVO<DscsVO> saveForum(DscsVO vo) throws Exception;
    ProcessResultVO<DscsVO> selectProfSbjctForumList(DscsVO vo) throws Exception;
    ProcessResultVO<DscsVO> deleteForum(DscsVO vo) throws Exception;
    ProcessResultVO<DscsVO> copyForum(DscsVO vo) throws Exception;
    ProcessResultVO<DscsTeamDscsVO> modifyTeamDscsOyn(DscsTeamDscsVO vo) throws Exception;
    ProcessResultVO<DscsTeamDscsVO> selectForumLrnGrpTeamList(DscsTeamDscsVO vo) throws Exception;
    void setScoreRatio(DscsVO forumVO) throws Exception;
    EgovMap viewScoreChart(DscsVO vo) throws Exception;
    List<EgovMap> selectProfSmstrChrtList(DscsVO vo) throws Exception;
    List<EgovMap> selectProfSmstrChrtSbjctList(DscsVO vo) throws Exception;
}
