package knou.lms.forum.service.impl;

import java.util.Arrays;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.framework.util.IdGenerator;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum.dao.ForumEzGraderDAO;
import knou.lms.forum.service.ForumEzGraderService;
import knou.lms.forum.vo.ForumEzGraderQstnVO;
import knou.lms.forum.vo.ForumEzGraderRsltVO;
import knou.lms.forum.vo.ForumEzGraderTeamVO;
import knou.lms.forum.vo.ForumEzGraderVO;
import knou.lms.forum.vo.ForumJoinUserVO;

@Service("forumEzGraderService")
public class ForumEzGraderServiceImpl extends EgovAbstractServiceImpl implements ForumEzGraderService {

    @Resource(name = "forumEzGraderDAO")
    private ForumEzGraderDAO forumEzGraderDAO;

    // 토론 참여 대상 리스트 조회
    @Override
    public List<ForumJoinUserVO> listForumJoinUser(ForumJoinUserVO vo) throws Exception {
        return forumEzGraderDAO.listForumJoinUser(vo);
    }

    // 토론 참여 대상 TEAM 조회
    @Override
    public List<ForumEzGraderTeamVO> listForumJoinTeam(ForumJoinUserVO vo) throws Exception {
        List<ForumEzGraderTeamVO> memberList = forumEzGraderDAO.listForumJoinTeam(vo);
        if( memberList != null && !memberList.isEmpty() && memberList.size() > 0) {
            for(ForumEzGraderTeamVO teamVo : memberList) {
                String teamStdNos = "";
                if (teamVo.getTeamMembers() != null && !teamVo.getTeamMembers().isEmpty() && teamVo.getTeamMembers().size() > 0) {
                    int idx = 0;
                    for(ForumJoinUserVO joinUserVo : teamVo.getTeamMembers()) {
                        if (idx > 0 ) {
                            teamStdNos += ",";
                        }
                        teamStdNos += joinUserVo.getStdId();
                        idx++;
                    }
                }
                teamVo.setTeamStdNos(teamStdNos);
            }
        }

        return memberList;
    }

    // 평가 정보 조회
    @Override
    public EgovMap selectEzgEvalInfo(ForumEzGraderVO vo) throws Exception {
        return forumEzGraderDAO.selectEzgEvalInfo(vo);
    }

    // 평가 문항 목록(등급 포함) 조회
    @Override
    public List<ForumEzGraderQstnVO> listEzgEvalQstn(ForumEzGraderVO vo) throws Exception {
        return forumEzGraderDAO.listEzgEvalQstn(vo);
    }

    // 평가점수 저장 처리
    @Override
    public ProcessResultVO<DefaultVO> saveEvalScore(ForumEzGraderRsltVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVo = new ProcessResultVO<DefaultVO>();

        //1. 평가정보 조회
        ForumEzGraderVO forumEzGraderVO = new ForumEzGraderVO();
        forumEzGraderVO.setCrsCreCd(vo.getCrsCreCd());
        forumEzGraderVO.setForumCd(vo.getForumCd());
        EgovMap evalInfoMap = forumEzGraderDAO.selectEzgEvalInfo(forumEzGraderVO);
        vo.setEvalCd(evalInfoMap.get("evalCd").toString());
        vo.setEvalStatusCd("C");

        //2. 문항별 총점 계산
        if (vo.getEvalScores() != null && !"".equals(vo.getEvalScores())) {
            String[] arrEvalScore = vo.getEvalScores().split("@#");
            int evalTotal = 0;
            for(String score : arrEvalScore) {
                evalTotal += Integer.parseInt(score);
            }
            vo.setEvalTotal(evalTotal);
        }

        //3. 등록 처리 또는 수정 처리
        if (vo.getMutEvalCd() == null || "".equals(vo.getMutEvalCd())) {
            if (vo.getEvalTrgtUserId() == null || "".equals(vo.getEvalTrgtUserId())) { 
                // 팀원 전체에 성적 평가 처리
                forumEzGraderDAO.insertEvalRsltToAllTeamMember(vo);
            } else {
                // 개인 학습자에 성적 평가 처리
                String newMutEvalCd = IdGenerator.getNewId("MUT");
                vo.setMutEvalCd(newMutEvalCd);
                forumEzGraderDAO.insertEvalRslt(vo);
            }
        } else {
            forumEzGraderDAO.updateEvalRslt(vo);
        }

        //4. 과제 제출 유저(미제출자 포함)에 평가점수 부여
        if (vo.getRltnTeamCd() == null || "".equals(vo.getRltnTeamCd())) {
            String newForumSendCd = IdGenerator.getNewId("SEND");
            vo.setForumSendCd(newForumSendCd);
            vo.setEvalYn("Y");
            forumEzGraderDAO.updateJoinUserScore(vo);
        } else {
            forumEzGraderDAO.deleteTeamStdScore(vo);
            forumEzGraderDAO.insertStdScoreToAllTeamMember(vo);
        }

        //5. 리턴
        resultVo.setReturnVO(vo);
        resultVo.setResult(1);
        return resultVo;
    }

    // 평가 정보 조회
    @Override
    public ForumEzGraderRsltVO selectEzgEvalRslt(ForumEzGraderRsltVO vo) throws Exception {
        ForumEzGraderRsltVO resultVo = forumEzGraderDAO.selectEzgEvalRslt(vo);
        if (resultVo != null && resultVo.getQstnNos() != null && !"".equals(resultVo.getQstnNos())) {

            String[] arrQstnCd = resultVo.getQstnNos().split("@#");
            String[] arrEvalScore = resultVo.getEvalScores().split("@#");
            resultVo.setQstnCdList(Arrays.asList(arrQstnCd));
            resultVo.setEvalScoreList(Arrays.asList(arrEvalScore));
        }
        return resultVo;
    }

    // 평가점수 삭제 처리.(점수를 0으로 업데이트)
    @Override
    public ProcessResultVO<DefaultVO> deleteEvalScore(ForumEzGraderRsltVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVo = new ProcessResultVO<DefaultVO>();

        //1. 평가정보 조회
        ForumEzGraderVO forumEzGraderVO = new ForumEzGraderVO();
        forumEzGraderVO.setCrsCreCd(vo.getCrsCreCd());
        forumEzGraderVO.setForumCd(vo.getForumCd());
        EgovMap evalInfoMap = forumEzGraderDAO.selectEzgEvalInfo(forumEzGraderVO);
        vo.setEvalCd(evalInfoMap.get("evalCd").toString());

        //2. 문항별 배점 총 점수 조회
        ForumEzGraderQstnVO allotScoreVO = forumEzGraderDAO.selectSumAllotScore(vo);
        int allotScore = Integer.parseInt(allotScoreVO.getAllotScore());
        allotScore = allotScore==0?1:allotScore;
        vo.setEvalScore(allotScore);

        if (vo.getRltnTeamCd() == null || "".equals(vo.getRltnTeamCd())) {
            //2. 평가완료되었는지 조회
            vo.setEvalUserId(vo.getRgtrId());
            ForumEzGraderRsltVO rsltVo = forumEzGraderDAO.selectEzgEvalRslt(vo);
            if (rsltVo == null) {
                resultVo.setReturnVO(vo);
                resultVo.setResult(1);
                return resultVo;
            }

            //3. 과제 제출 유저의 평가점수를 0으로 업데이트. ㄷevalYn = N으로 업데이트
            vo.setEvalYn(rsltVo.getEvalYn());
            vo.setEvalScore((int)Math.round((rsltVo.getEvalTotal() * 1.0)/allotScore*100));
            vo.setForumSendCd("");
            forumEzGraderDAO.updateJoinUserScore(vo);
        } else {
            List<ForumEzGraderRsltVO> stdList = forumEzGraderDAO.listTeamMeberInitScore(vo);
            forumEzGraderDAO.deleteTeamStdScore(vo);
            for( ForumEzGraderRsltVO paramVO : stdList) {
                paramVO.setEvalCd(vo.getEvalCd());
                paramVO.setRgtrId(vo.getRgtrId());
                paramVO.setRltnTeamCd(vo.getRltnTeamCd());
                paramVO.setEvalScore(allotScore);

                forumEzGraderDAO.initStdScoreToAllTeamMember(paramVO);
            }

        }

        //4. 리턴
        resultVo.setReturnVO(vo);
        resultVo.setResult(1);
        return resultVo;
    }

    // 점수 저장 처리
    @Override
    public ProcessResultVO<DefaultVO> saveScore(ForumEzGraderRsltVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVo = new ProcessResultVO<DefaultVO>();

        if (vo.getRltnTeamCd() == null || "".equals(vo.getRltnTeamCd())) {
            String newForumSendCd = IdGenerator.getNewId("SEND");
            vo.setForumSendCd(newForumSendCd);
            vo.setEvalYn("Y");
            forumEzGraderDAO.updateJoinUserScore(vo);
        } else {
//            forumEzGraderDAO.deleteTeamStdScore(vo);
            forumEzGraderDAO.insertStdScoreToAllTeamMember(vo);
        }

        resultVo.setReturnVO(vo);
        resultVo.setResult(1);
        return resultVo;
    }

    // 점수 삭제 처리.(점수를 0으로 업데이트)
    @Override
    public ProcessResultVO<DefaultVO> deleteScore(ForumEzGraderRsltVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<DefaultVO> resultVo = new ProcessResultVO<DefaultVO>();
        if (vo.getRltnTeamCd() == null || "".equals(vo.getRltnTeamCd())) {
            // 평가완료되었는지 조회
            vo.setEvalUserId(vo.getRgtrId());
            ForumEzGraderRsltVO rsltVo = forumEzGraderDAO.selectEzgEvalRslt(vo);
            if (rsltVo == null) {
                resultVo.setReturnVO(vo);
                resultVo.setResult(1);
                return resultVo;
            }

            // 평가점수를 0으로 업데이트. evalYn = N으로 업데이트
            vo.setEvalYn("N");
            vo.setEvalScore(0);
            vo.setForumSendCd("");
            forumEzGraderDAO.updateJoinUserScore(vo);
        } else {
            List<ForumEzGraderRsltVO> stdList = forumEzGraderDAO.listTeamMeberInitScore(vo);
//            forumEzGraderDAO.deleteTeamStdScore(vo);
            for( ForumEzGraderRsltVO paramVO : stdList) {
                paramVO.setEvalCd(vo.getEvalCd());
                paramVO.setRgtrId(vo.getRgtrId());
                paramVO.setRltnTeamCd(vo.getRltnTeamCd());
                paramVO.setEvalScore(0);
                paramVO.setForumCd(vo.getForumCd());
                forumEzGraderDAO.initStdScoreToAllTeamMember(paramVO);
            }

        }

        resultVo.setReturnVO(vo);
        resultVo.setResult(1);
        return resultVo;
    }
}
