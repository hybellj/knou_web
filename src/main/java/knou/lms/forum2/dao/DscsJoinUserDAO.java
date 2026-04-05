package knou.lms.forum2.dao;

import knou.lms.forum2.vo.DscsJoinUserVO;
import knou.lms.forum2.vo.DscsMutVO;
import knou.lms.forum2.vo.DscsEzGraderTeamVO;
import knou.lms.forum2.vo.DscsVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("dscsJoinUserDAO")
public interface DscsJoinUserDAO {

    public EgovMap selectDscsScoreStatus(DscsJoinUserVO vo) throws Exception;
    public List<DscsJoinUserVO> listPaging(DscsJoinUserVO vo) throws Exception;
    public int insertStdScore(DscsJoinUserVO vo) throws Exception;
    public List<DscsJoinUserVO> listStdScore(DscsJoinUserVO vo) throws Exception;
    public DscsJoinUserVO selectDscsJoinUser(DscsJoinUserVO vo) throws Exception;
    public List<?> dscsJoinUserList(DscsJoinUserVO vo) throws Exception;
    public DscsJoinUserVO selectProfMemo(DscsJoinUserVO vo) throws Exception;
    public void editForumProfMemo(DscsJoinUserVO vo) throws Exception;
    public List<DscsJoinUserVO> listDscsJoinUser(DscsJoinUserVO vo) throws Exception;
    public List<DscsEzGraderTeamVO> listDscsJoinTeam(DscsJoinUserVO vo) throws Exception;
    public int getDscsJoinUser(DscsJoinUserVO vo) throws Exception;
    public int ensureJoinUser(DscsJoinUserVO vo) throws Exception;
    public DscsJoinUserVO getMemo(DscsVO vo) throws Exception;
    public int getSelectCtsLen(DscsJoinUserVO vo) throws Exception;
	public void chkStdNoInsert(DscsMutVO vo) throws Exception;
	public void insertJoinUser(DscsVO vo) throws Exception;
	public List<DscsJoinUserVO> selectStudentsNotInPtcp(DscsVO vo) throws Exception;
    public int insertDscsJoinUser(DscsJoinUserVO vo) throws Exception;
	public void participateScore(DscsJoinUserVO vo) throws Exception;
	public void updateStdTeam(DscsJoinUserVO vo) throws Exception;
    public void updateJoinUserEvalN(DscsJoinUserVO vo) throws Exception;
}
