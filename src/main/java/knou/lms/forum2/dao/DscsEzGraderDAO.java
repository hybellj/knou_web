package knou.lms.forum2.dao;

import knou.lms.forum2.vo.DscsEzGraderRsltVO;
import knou.lms.forum2.vo.DscsJoinUserVO;
import knou.lms.forum2.vo.DscsEzGraderTeamVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import java.util.List;

@Mapper("dscsEzGraderDAO")
public interface DscsEzGraderDAO {

    public List<DscsJoinUserVO> listDscsJoinUser(DscsJoinUserVO vo) throws Exception;
    public List<DscsEzGraderTeamVO> listDscsJoinTeam(DscsJoinUserVO vo) throws Exception;
    public void updateJoinUserScore(DscsEzGraderRsltVO vo) throws Exception;
    public void deleteTeamStdScore(DscsEzGraderRsltVO vo) throws Exception;
    public void insertStdScoreToAllTeamMember(DscsEzGraderRsltVO vo) throws Exception;
    public DscsEzGraderRsltVO selectEzgEvalRslt(DscsEzGraderRsltVO vo) throws Exception;
    public void initStdScoreToAllTeamMember(DscsEzGraderRsltVO vo) throws Exception;
}
