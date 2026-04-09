package knou.lms.forum2.service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.vo.DscsJoinUserVO;
import knou.lms.forum2.vo.DscsMutVO;
import knou.lms.forum2.vo.DscsEzGraderTeamVO;
import knou.lms.forum2.vo.DscsVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

public interface DscsJoinUserService {

    public EgovMap selectDscsScoreStatus(DscsJoinUserVO vo) throws Exception;
    public List<DscsJoinUserVO> list(DscsJoinUserVO vo) throws Exception;
    public ProcessResultVO<DscsJoinUserVO> listPaging(DscsJoinUserVO vo, String byteamDscsUseyn) throws Exception;
    public void updateDscsJoinUserScore(DscsJoinUserVO vo) throws Exception;
    public DscsJoinUserVO selectDscsJoinUser(DscsJoinUserVO vo) throws Exception;
    public List<?> dscsJoinUserList(DscsJoinUserVO vo) throws Exception;
    public void addStdScore(DscsJoinUserVO vo) throws Exception;
    public DscsJoinUserVO selectProfMemo(DscsJoinUserVO vo) throws Exception;
    public void editDscsProfMemo(DscsJoinUserVO vo) throws Exception;
    public ProcessResultVO<DscsJoinUserVO> listPageing(DscsJoinUserVO vo) throws Exception;
    public void updateExampleExcelScore(DscsJoinUserVO vo, List<?> stdNoList, String dscsUnitTycd) throws Exception;
    public List<DscsJoinUserVO> listDscsJoinUser(DscsJoinUserVO vo) throws Exception;
    public List<DscsEzGraderTeamVO> listDscsJoinTeam(DscsJoinUserVO vo) throws Exception;
    public DscsJoinUserVO getMemo(DscsVO vo) throws Exception;
    public void updateDscsJoinUserLenScore(DscsJoinUserVO vo) throws Exception;
	public void chkStdNoInsert(DscsMutVO vo) throws Exception;
	public void insertJoinUser(DscsVO vo) throws Exception;
	public void participateScore(DscsJoinUserVO vo) throws Exception;
	public void setScoreRatio(DscsJoinUserVO vo) throws Exception;
}
