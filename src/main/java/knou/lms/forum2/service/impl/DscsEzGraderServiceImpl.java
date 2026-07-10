package knou.lms.forum2.service.impl;

import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.dao.DscsEzGraderDAO;
import knou.lms.forum2.dao.DscsDAO;
import knou.lms.forum2.service.DscsEzGraderService;
import knou.lms.forum2.service.DscsJoinUserService;
import knou.lms.forum2.vo.DscsEzGraderRsltVO;
import knou.lms.forum2.vo.DscsJoinUserVO;
import knou.lms.forum2.vo.DscsEzGraderTeamVO;
import knou.lms.forum2.vo.DscsTeamDscsVO;
import knou.lms.forum2.vo.DscsVO;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

@Service("dscsEzGraderService")
public class DscsEzGraderServiceImpl extends EgovAbstractServiceImpl implements DscsEzGraderService {

    @Resource(name = "dscsEzGraderDAO")
    private DscsEzGraderDAO dscsEzGraderDAO;

    @Resource(name = "dscsDAO")
    private DscsDAO dscsDAO;

    @Resource(name = "dscsJoinUserService")
    private DscsJoinUserService dscsJoinUserService;

    /**
     * 토론 참여자 목록을 조회한다.
     * @param vo
     * @return
     */
    @Override
    public List<DscsJoinUserVO> listDscsJoinUser(DscsJoinUserVO vo) {
        return dscsEzGraderDAO.listDscsJoinUser(vo);
    }

    /**
     * 팀별 토론 참여자 목록을 조회한다.
     * @param vo
     * @return
     */
    @Override
    public List<DscsEzGraderTeamVO> listDscsJoinTeam(DscsJoinUserVO vo) {
        List<DscsEzGraderTeamVO> memberList;
        List<DscsTeamDscsVO> childList = dscsDAO.selectTeamDscsList(vo.getDscsId());

        if (childList != null && !childList.isEmpty()) {
            // 팀별부토론: 부모 dscsId로 자식 토론 목록 조회 후 자식 DSCS_ID별로 팀원 조회
            memberList = new ArrayList<>();
            for (DscsTeamDscsVO child : childList) {
                DscsJoinUserVO childVo = new DscsJoinUserVO();
                childVo.setDscsId(child.getDscsId());
                childVo.setSbjctId(vo.getSbjctId());
                childVo.setSearchKey(vo.getSearchKey());
                childVo.setSearchSort(vo.getSearchSort());
                List<DscsEzGraderTeamVO> partial = dscsEzGraderDAO.listDscsJoinTeam(childVo);
                if (partial != null) memberList.addAll(partial);
            }
        } else {
            memberList = dscsEzGraderDAO.listDscsJoinTeam(vo);
        }

        filterTeamMembersBySearchKey(memberList, vo.getSearchKey());

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

    /**
     * 팀별 참여자 목록에서 참여/미참여 검색 조건에 맞는 학습자만 남긴다.
     * @param memberList
     * @param searchKey
     */
    private void filterTeamMembersBySearchKey(List<DscsEzGraderTeamVO> memberList, String searchKey) {
        if (memberList == null || memberList.isEmpty()) {
            return;
        }
        if (!"JOIN".equals(searchKey) && !"NOTJOIN".equals(searchKey)) {
            return;
        }

        for (DscsEzGraderTeamVO teamVo : memberList) {
            List<DscsJoinUserVO> teamMembers = teamVo.getTeamMembers();
            List<DscsJoinUserVO> filteredMembers = new ArrayList<DscsJoinUserVO>();

            if (teamMembers != null && !teamMembers.isEmpty()) {
                for (DscsJoinUserVO joinUserVo : teamMembers) {
                    if (searchKey.equals(joinUserVo.getJoinStatus())) {
                        filteredMembers.add(joinUserVo);
                    }
                }
            }

            teamVo.setTeamMembers(filteredMembers);
        }
    }

    /**
     * 점수를 저장한다.
     * @param vo
     * @param request
     * @return
     */
    @Override
    public ProcessResultVO<DefaultVO> saveScore(DscsEzGraderRsltVO vo, HttpServletRequest request) {
        ProcessResultVO<DefaultVO> resultVo = new ProcessResultVO<DefaultVO>();

        if (!setScoreTargetStdIds(vo, resultVo)) {
            return resultVo;
        }
        ensureScoreJoinUser(vo);

        if (vo.getTeamId() == null || "".equals(vo.getTeamId())) {
            vo.setEvlyn("Y");
            dscsEzGraderDAO.updateJoinUserScore(vo);
        } else {
            vo.setEvlyn("Y");
            dscsEzGraderDAO.insertStdScoreToAllTeamMember(vo);
        }

        resultVo.setReturnVO(vo);
        resultVo.setResult(1);
        return resultVo;
    }

    /**
     * 점수 삭제 처리 (점수를 0으로 초기화)
     * @param vo
     * @param request
     * @return
     */
    @Override
    public ProcessResultVO<DefaultVO> deleteScore(DscsEzGraderRsltVO vo, HttpServletRequest request) {
        ProcessResultVO<DefaultVO> resultVo = new ProcessResultVO<DefaultVO>();

        if (!setScoreTargetStdIds(vo, resultVo)) {
            return resultVo;
        }

        if (vo.getTeamId() == null || "".equals(vo.getTeamId())) {
            // 평가완료되었는지 조회
            DscsEzGraderRsltVO rsltVo = dscsEzGraderDAO.selectEzgEvalRslt(vo);
            if (rsltVo == null) {
                resultVo.setReturnVO(vo);
                resultVo.setResult(1);
                return resultVo;
            }

            // 평가점수를 0으로 업데이트. 평가여부를 N으로 업데이트
            vo.setEvlyn("N");
            vo.setScr(0.0);
            dscsEzGraderDAO.updateJoinUserScore(vo);
        } else {
            // 팀: 팀원 전체 점수 0으로 초기화
            vo.setEvlyn("N");
            vo.setScr(0.0);
            dscsEzGraderDAO.initStdScoreToAllTeamMember(vo);
        }

        resultVo.setReturnVO(vo);
        resultVo.setResult(1);
        return resultVo;
    }

    /**
     * 점수 저장/초기화 대상자를 화면에서 전달한 stdIds 기준으로 확정한다.
     * @param vo
     * @param resultVo
     * @return
     */
    private boolean setScoreTargetStdIds(DscsEzGraderRsltVO vo, ProcessResultVO<DefaultVO> resultVo) {
        List<String> targetStdIds = getScoreTargetStdIds(vo);
        if (targetStdIds.isEmpty()) {
            resultVo.setReturnVO(vo);
            resultVo.setResult(0);
            resultVo.setMessage("학습자를 선택해 주세요.");
            return false;
        }

        vo.setSqlForeach(targetStdIds.toArray(new String[targetStdIds.size()]));
        if (vo.getStdId() == null || "".equals(vo.getStdId())) {
            vo.setStdId(targetStdIds.get(0));
        }
        return true;
    }

    /**
     * 점수 저장 대상자의 토론 참여자 row를 준비한다.
     * @param vo
     */
    private void ensureScoreJoinUser(DscsEzGraderRsltVO vo) {
        if (vo.getDscsId() == null || "".equals(vo.getDscsId())
                || vo.getSbjctId() == null || "".equals(vo.getSbjctId())) {
            return;
        }

        DscsVO dscsVO = new DscsVO();
        dscsVO.setDscsId(vo.getDscsId());
        dscsVO.setSbjctId(vo.getSbjctId());
        dscsVO.setStdId(vo.getStdId());
        dscsVO.setStdList(vo.getStdIds());
        dscsVO.setRgtrId(vo.getRgtrId());
        dscsJoinUserService.prepareJoinUsersForScoring(dscsVO);
    }

    /**
     * stdIds를 우선 사용하고, 없으면 기존 단건 stdId를 대상자로 사용한다.
     * @param vo
     * @return
     */
    private List<String> getScoreTargetStdIds(DscsEzGraderRsltVO vo) {
        Set<String> targetStdIds = new LinkedHashSet<String>();
        addScoreTargetStdIds(targetStdIds, vo.getStdIds());
        if (targetStdIds.isEmpty()) {
            addScoreTargetStdIds(targetStdIds, vo.getStdId());
        }
        return new ArrayList<String>(targetStdIds);
    }

    /**
     * 콤마로 전달된 학습자 ID를 중복 없이 대상 Set에 추가한다.
     * @param targetStdIds
     * @param stdIds
     */
    private void addScoreTargetStdIds(Set<String> targetStdIds, String stdIds) {
        if (stdIds == null || "".equals(stdIds.trim())) {
            return;
        }

        String[] stdArr = stdIds.split(",");
        for (String stdId : stdArr) {
            if (stdId != null && !"".equals(stdId.trim())) {
                targetStdIds.add(stdId.trim());
            }
        }
    }
}
