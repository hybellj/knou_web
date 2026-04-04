package knou.lms.forum2.service;

import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.vo.DscsEzGraderRsltVO;
import knou.lms.forum2.vo.DscsJoinUserVO;
import knou.lms.forum2.vo.DscsEzGraderTeamVO;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

public interface DscsEzGraderService {

    public abstract List<DscsJoinUserVO> listForumJoinUser(DscsJoinUserVO vo) throws Exception;
    public abstract List<DscsEzGraderTeamVO> listForumJoinTeam(DscsJoinUserVO vo, String byteamDscsUseyn) throws Exception;
    public abstract ProcessResultVO<DefaultVO> saveEvalScore(DscsEzGraderRsltVO vo, HttpServletRequest request) throws Exception;
    public abstract DscsEzGraderRsltVO selectEzgEvalRslt(DscsEzGraderRsltVO vo) throws Exception;
    public abstract ProcessResultVO<DefaultVO> deleteEvalScore(DscsEzGraderRsltVO vo, HttpServletRequest request) throws Exception;
    public abstract ProcessResultVO<DefaultVO> saveScore(DscsEzGraderRsltVO vo, HttpServletRequest request) throws Exception;
    public abstract ProcessResultVO<DefaultVO> deleteScore(DscsEzGraderRsltVO vo, HttpServletRequest request) throws Exception;

}
