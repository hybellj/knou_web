package knou.lms.forum2.service.impl;

import knou.framework.util.IdGenerator;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.dao.DscsEzGraderDAO;
import knou.lms.forum2.dao.DscsDAO;
import knou.lms.forum2.service.DscsEzGraderService;
import knou.lms.forum2.vo.DscsEzGraderRsltVO;
import knou.lms.forum2.vo.DscsJoinUserVO;
import knou.lms.forum2.vo.DscsEzGraderTeamVO;
import knou.lms.forum2.vo.DscsTeamDscsVO;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

@Service("dscsEzGraderService")
public class DscsEzGraderServiceImpl extends EgovAbstractServiceImpl implements DscsEzGraderService {

    @Resource(name = "dscsEzGraderDAO")
    private DscsEzGraderDAO dscsEzGraderDAO;

    @Resource(name = "dscsDAO")
    private DscsDAO dscsDAO;

    // 토론 참여 대상 리스트 조회
    @Override
    public List<DscsJoinUserVO> listDscsJoinUser(DscsJoinUserVO vo) throws Exception {
        return dscsEzGraderDAO.listDscsJoinUser(vo);
    }

    // 토론 참여 대상 TEAM 조회
    @Override
    public List<DscsEzGraderTeamVO> listDscsJoinTeam(DscsJoinUserVO vo, String byteamDscsUseyn) throws Exception {
        List<DscsEzGraderTeamVO> memberList;

        if ("Y".equals(byteamDscsUseyn)) {
            // 팀별부토론: 부모 dscsId로 자식 토론 목록 조회 후 자식 DSCS_ID별로 팀원 조회
            List<DscsTeamDscsVO> childList = dscsDAO.selectTeamDscsList(vo.getDscsId());
            memberList = new ArrayList<>();
            if (childList != null) {
                for (DscsTeamDscsVO child : childList) {
                    DscsJoinUserVO childVo = new DscsJoinUserVO();
                    childVo.setDscsId(child.getDscsId());
                    childVo.setSbjctId(vo.getSbjctId());
                    childVo.setSearchKey(vo.getSearchKey());
                    childVo.setSearchSort(vo.getSearchSort());
                    List<DscsEzGraderTeamVO> partial = dscsEzGraderDAO.listDscsJoinTeam(childVo);
                    if (partial != null) memberList.addAll(partial);
                }
            }
        } else {
            memberList = dscsEzGraderDAO.listDscsJoinTeam(vo);
        }

        if (memberList != null && !memberList.isEmpty()) {
            for (DscsEzGraderTeamVO teamVo : memberList) {
                String teamStdIds = "";
                if (teamVo.getTeamMembers() != null && !teamVo.getTeamMembers().isEmpty()) {
                    int idx = 0;
                    for (DscsJoinUserVO joinUserVo : teamVo.getTeamMembers()) {
                        if (idx > 0) {
                            teamStdIds += ",";
                        }
                        teamStdIds += joinUserVo.getStdId();
                        idx++;
                    }
                }
                teamVo.setTeamStdIds(teamStdIds);
            }
        }
        return memberList;
    }

    // 평가점수 저장 처리 (TB_LMS_DSCS_PTCP 직접 저장)
    @Override
    public ProcessResultVO<DefaultVO> saveEvalScore(DscsEzGraderRsltVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVo = new ProcessResultVO<DefaultVO>();

        // 문항별 점수 합산 (evalScores가 @# 구분자로 전달된 경우)
        if (vo.getEvalScores() != null && !"".equals(vo.getEvalScores())) {
            String[] arrEvalScore = vo.getEvalScores().split("@#");
            int evalTotal = 0;
            for (String score : arrEvalScore) {
                evalTotal += Integer.parseInt(score);
            }
            vo.setEvalTotal(evalTotal);
            vo.setEvalScore(evalTotal);
        }

        // 점수 저장
        if (vo.getRltnTeamCd() == null || "".equals(vo.getRltnTeamCd())) {
            // 개인: TB_LMS_DSCS_PTCP MERGE
            String newDscsSendCd = IdGenerator.getNewId("SEND");
            vo.setDscsSendCd(newDscsSendCd);
            vo.setEvalYn("Y");
            dscsEzGraderDAO.updateJoinUserScore(vo);
        } else {
            // 팀: 팀원 전체에 동일 점수 부여
            dscsEzGraderDAO.deleteTeamStdScore(vo);
            dscsEzGraderDAO.insertStdScoreToAllTeamMember(vo);
        }

        resultVo.setReturnVO(vo);
        resultVo.setResult(1);
        return resultVo;
    }

    // 평가 결과 조회 (TB_LMS_DSCS_PTCP)
    @Override
    public DscsEzGraderRsltVO selectEzgEvalRslt(DscsEzGraderRsltVO vo) throws Exception {
        return dscsEzGraderDAO.selectEzgEvalRslt(vo);
    }

    // 평가점수 삭제 처리 (점수를 0으로 초기화)
    @Override
    public ProcessResultVO<DefaultVO> deleteEvalScore(DscsEzGraderRsltVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVo = new ProcessResultVO<DefaultVO>();

        if (vo.getRltnTeamCd() == null || "".equals(vo.getRltnTeamCd())) {
            // 개인: 점수 0, evalYn=N으로 초기화
            vo.setEvalYn("N");
            vo.setEvalScore(0);
            vo.setDscsSendCd("");
            dscsEzGraderDAO.updateJoinUserScore(vo);
        } else {
            // 팀: 팀원 전체 점수 0으로 초기화
            vo.setEvalScore(0);
            dscsEzGraderDAO.initStdScoreToAllTeamMember(vo);
        }

        resultVo.setReturnVO(vo);
        resultVo.setResult(1);
        return resultVo;
    }

    // 점수 저장 처리
    @Override
    public ProcessResultVO<DefaultVO> saveScore(DscsEzGraderRsltVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVo = new ProcessResultVO<DefaultVO>();

        if (vo.getRltnTeamCd() == null || "".equals(vo.getRltnTeamCd())) {
            String newDscsSendCd = IdGenerator.getNewId("SEND");
            vo.setDscsSendCd(newDscsSendCd);
            vo.setEvalYn("Y");
            dscsEzGraderDAO.updateJoinUserScore(vo);
        } else {
//            dscsEzGraderDAO.deleteTeamStdScore(vo);
            dscsEzGraderDAO.insertStdScoreToAllTeamMember(vo);
        }

        resultVo.setReturnVO(vo);
        resultVo.setResult(1);
        return resultVo;
    }

    // 점수 삭제 처리 (점수를 0으로 초기화)
    @Override
    public ProcessResultVO<DefaultVO> deleteScore(DscsEzGraderRsltVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVo = new ProcessResultVO<DefaultVO>();

        if (vo.getRltnTeamCd() == null || "".equals(vo.getRltnTeamCd())) {
            // 평가완료되었는지 조회
            vo.setEvalUserId(vo.getRgtrId());
            DscsEzGraderRsltVO rsltVo = dscsEzGraderDAO.selectEzgEvalRslt(vo);
            if (rsltVo == null) {
                resultVo.setReturnVO(vo);
                resultVo.setResult(1);
                return resultVo;
            }

            // 평가점수를 0으로 업데이트. evalYn = N으로 업데이트
            vo.setEvalYn("N");
            vo.setEvalScore(0);
            vo.setDscsSendCd("");
            dscsEzGraderDAO.updateJoinUserScore(vo);
        } else {
            // 팀: 팀원 전체 점수 0으로 초기화
            vo.setEvalScore(0);
            dscsEzGraderDAO.initStdScoreToAllTeamMember(vo);
        }

        resultVo.setReturnVO(vo);
        resultVo.setResult(1);
        return resultVo;
    }
}
