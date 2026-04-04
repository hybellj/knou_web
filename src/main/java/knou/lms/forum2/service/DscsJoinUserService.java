package knou.lms.forum2.service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.vo.DscsJoinUserVO;
import knou.lms.forum2.vo.DscsMutVO;
import knou.lms.forum2.vo.DscsForumVO;
import knou.lms.forum2.vo.DscsEzGraderTeamVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

public interface DscsJoinUserService {

    public EgovMap selectForumScoreStatus(DscsJoinUserVO vo) throws Exception;
    public List<DscsJoinUserVO> list(DscsJoinUserVO vo) throws Exception;
    public ProcessResultVO<DscsJoinUserVO> listPaging(DscsJoinUserVO vo, String byteamDscsUseyn) throws Exception;
    public void updateForumJoinUserScore(DscsJoinUserVO vo) throws Exception;
    public DscsJoinUserVO selectForumJoinUser(DscsJoinUserVO vo) throws Exception;
    public List<?> forumJoinUserList(DscsJoinUserVO vo) throws Exception;
    public void addStdScore(DscsJoinUserVO vo) throws Exception;
    public DscsJoinUserVO selectProfMemo(DscsJoinUserVO vo) throws Exception;
    public void editForumProfMemo(DscsJoinUserVO vo) throws Exception;
    public ProcessResultVO<DscsJoinUserVO> listPageing(DscsJoinUserVO vo) throws Exception;
    public void updateExampleExcelScore(DscsJoinUserVO vo, List<?> stdNoList, String forumCtgrCd) throws Exception;
    public List<DscsJoinUserVO> listForumJoinUser(DscsJoinUserVO vo) throws Exception;
    public List<DscsEzGraderTeamVO> listForumJoinTeam(DscsJoinUserVO vo) throws Exception;
    public DscsJoinUserVO getMemo(DscsForumVO vo) throws Exception;
    public void updateForumJoinUserLenScore(DscsJoinUserVO vo) throws Exception;
	public void chkStdNoInsert(DscsMutVO vo) throws Exception;
	public void insertJoinUser(DscsForumVO vo) throws Exception;
	public void participateScore(DscsJoinUserVO vo) throws Exception;
	public void setScoreRatio(DscsJoinUserVO vo) throws Exception;

}
