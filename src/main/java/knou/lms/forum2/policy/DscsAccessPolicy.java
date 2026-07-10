package knou.lms.forum2.policy;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.util.StringUtil;
import knou.lms.forum2.dao.DscsAtclDAO;
import knou.lms.forum2.dao.DscsCmntDAO;
import knou.lms.forum2.service.DscsService;
import knou.lms.forum2.vo.DscsAtclVO;
import knou.lms.forum2.vo.DscsCmntVO;
import knou.lms.forum2.vo.DscsVO;
import knou.lms.team.service.TeamGrpMgrService;

/**
 * 토론 접근 가능 여부를 판단하는 service 계층 내부 정책 객체이다.
 */
@Service("dscsAccessPolicy")
public class DscsAccessPolicy {

    @Resource(name = "dscsService")
    private DscsService dscsService;

    @Resource(name = "dscsAtclDAO")
    private DscsAtclDAO dscsAtclDAO;

    @Resource(name = "dscsCmntDAO")
    private DscsCmntDAO dscsCmntDAO;

    @Resource(name = "teamGrpMgrService")
    private TeamGrpMgrService teamGrpMgrService;

    /**
     * 교수가 토론 설정을 수정할 수 있는지 확인한다.
     * @param dscsId
     * @return
     */
    public boolean canProfEditDscs(String dscsId) {
        return DscsPeriodPolicy.canProfEditDscs(selectRuleDscs(dscsId));
    }

    /**
     * 교수가 토론방에 게시글 또는 댓글을 등록/수정할 수 있는지 확인한다.
     * @param dscsId
     * @return
     */
    public boolean canProfWriteBbs(String dscsId) {
        return DscsPeriodPolicy.canProfWriteBbs(selectRuleDscs(dscsId));
    }

    /**
     * 교수가 게시글 기준으로 토론방에 등록/수정할 수 있는지 확인한다.
     * @param vo
     * @return
     */
    public boolean canProfWriteBbsByAtcl(DscsAtclVO vo) {
        return canProfWriteBbs(resolveDscsIdByAtcl(vo));
    }

    /**
     * 교수가 댓글 기준으로 토론방에 등록/수정할 수 있는지 확인한다.
     * @param vo
     * @return
     */
    public boolean canProfWriteBbsByCmnt(DscsCmntVO vo) {
        return canProfWriteBbs(resolveDscsIdByCmnt(vo));
    }

    /**
     * 교수가 게시글 기준으로 삭제/숨김 처리할 수 있는지 확인한다.
     * @param vo
     * @return
     */
    public boolean canProfDeleteOrHideBbsByAtcl(DscsAtclVO vo) {
        return DscsPeriodPolicy.canProfDeleteOrHideBbs(selectRuleDscs(resolveDscsIdByAtcl(vo)));
    }

    /**
     * 교수가 댓글 기준으로 삭제/숨김 처리할 수 있는지 확인한다.
     * @param vo
     * @return
     */
    public boolean canProfDeleteOrHideBbsByCmnt(DscsCmntVO vo) {
        return DscsPeriodPolicy.canProfDeleteOrHideBbs(selectRuleDscs(resolveDscsIdByCmnt(vo)));
    }

    /**
     * 학습자가 토론방에 진입하거나 작성할 수 있는지 확인한다.
     * @param dscsId
     * @return
     */
    public boolean canLearnerEnterOrWrite(String dscsId) {
        return DscsPeriodPolicy.canLearnerEnterOrWrite(selectRuleDscs(dscsId));
    }

    /**
     * 학습자가 참여현황 화면에 진입할 수 있는지 확인한다.
     * @param dscsId
     * @return
     */
    public boolean canLearnerViewPtcpStatus(String dscsId) {
        return DscsPeriodPolicy.canLearnerViewPtcpStatus(selectRuleDscs(dscsId));
    }

    /**
     * 학습자가 댓글 기준으로 토론방에 진입하거나 작성할 수 있는지 확인한다.
     * @param vo
     * @return
     */
    public boolean canLearnerEnterOrWriteByCmnt(DscsCmntVO vo) {
        return canLearnerEnterOrWrite(resolveDscsIdByCmnt(vo));
    }

    /**
     * 학습자가 팀 토론방에 작성할 수 있는지 확인한다.
     * @param dscsId
     * @param teamId
     * @param userId
     * @return
     */
    public boolean canLearnerWriteTeamDscs(String dscsId, String teamId, String userId) {
        if (StringUtil.isNull(dscsId)) {
            return false;
        }
        DscsVO loadedVO = selectDscs(dscsId);
        if (loadedVO == null) {
            return false;
        }
        if (!"TEAM".equals(StringUtil.nvl(loadedVO.getDscsUnitTycd()))) {
            return true;
        }

        // 팀 토론은 하위 토론의 teamId와 사용자의 팀 소속을 함께 확인한다.
        String childTeamId = StringUtil.nvl(loadedVO.getTeamId());
        if (StringUtil.isNull(loadedVO.getUpDscsId()) || StringUtil.isNull(childTeamId)) {
            return false;
        }
        return childTeamId.equals(StringUtil.nvl(teamId)) && teamGrpMgrService.isUserInTeam(childTeamId, userId);
    }

    /**
     * 학습자가 본인이 작성한 게시글인지 확인한다.
     * @param dscsId
     * @param dscsAtclId
     * @param userId
     * @return
     */
    public boolean isLearnerOwnAtcl(String dscsId, String dscsAtclId, String userId) {
        if (StringUtil.isNull(dscsAtclId) || StringUtil.isNull(userId)) {
            return false;
        }
        DscsAtclVO paramVO = new DscsAtclVO();
        paramVO.setDscsId(dscsId);
        paramVO.setDscsAtclId(dscsAtclId);
        DscsAtclVO atclVO = dscsAtclDAO.selectAtcl(paramVO);
        return atclVO != null && userId.equals(StringUtil.nvl(atclVO.getRgtrId()));
    }

    /**
     * 학습자가 본인이 작성한 댓글인지 확인한다.
     * @param dscsCmntId
     * @param userId
     * @return
     */
    public boolean isLearnerOwnCmnt(String dscsCmntId, String userId) {
        if (StringUtil.isNull(dscsCmntId) || StringUtil.isNull(userId)) {
            return false;
        }
        DscsCmntVO paramVO = new DscsCmntVO();
        paramVO.setDscsCmntId(dscsCmntId);
        DscsCmntVO cmntVO = dscsCmntDAO.selectCmnt(paramVO);
        return cmntVO != null && userId.equals(StringUtil.nvl(cmntVO.getRgtrId()));
    }

    /**
     * 게시글 정보에서 토론 ID를 조회한다.
     * @param vo
     * @return
     */
    public String resolveDscsIdByAtcl(DscsAtclVO vo) {
        if (vo != null && StringUtil.isNotNull(vo.getDscsId())) {
            return vo.getDscsId();
        }
        if (vo == null || StringUtil.isNull(vo.getDscsAtclId())) {
            return "";
        }
        DscsAtclVO paramVO = new DscsAtclVO();
        paramVO.setDscsAtclId(vo.getDscsAtclId());
        DscsAtclVO savedVO = dscsAtclDAO.selectAtcl(paramVO);
        return savedVO == null ? "" : StringUtil.nvl(savedVO.getDscsId());
    }

    /**
     * 댓글 정보에서 토론 ID를 조회한다.
     * @param vo
     * @return
     */
    public String resolveDscsIdByCmnt(DscsCmntVO vo) {
        if (vo != null && StringUtil.isNotNull(vo.getDscsId())) {
            return vo.getDscsId();
        }

        String dscsAtclId = "";
        if (vo != null && StringUtil.isNotNull(vo.getDscsAtclId())) {
            dscsAtclId = vo.getDscsAtclId();
        } else if (vo != null && StringUtil.isNotNull(vo.getDscsCmntId())) {
            DscsCmntVO paramVO = new DscsCmntVO();
            paramVO.setDscsCmntId(vo.getDscsCmntId());
            DscsCmntVO savedVO = dscsCmntDAO.selectCmnt(paramVO);
            dscsAtclId = savedVO == null ? "" : StringUtil.nvl(savedVO.getDscsAtclId());
        }
        if (StringUtil.isNull(dscsAtclId)) {
            return "";
        }

        // 댓글은 댓글 -> 게시글 -> 토론 순서로 토론 ID를 역조회한다.
        DscsAtclVO atclParamVO = new DscsAtclVO();
        atclParamVO.setDscsAtclId(dscsAtclId);
        DscsAtclVO atclVO = dscsAtclDAO.selectAtcl(atclParamVO);
        return atclVO == null ? "" : StringUtil.nvl(atclVO.getDscsId());
    }

    /**
     * 기간 판단에 사용할 토론 정보를 조회한다.
     * @param dscsId
     * @return
     */
    public DscsVO selectRuleDscs(String dscsId) {
        if (StringUtil.isNull(dscsId)) {
            return null;
        }
        DscsVO loadedVO = selectDscs(dscsId);
        if (loadedVO == null || StringUtil.isNull(loadedVO.getUpDscsId())) {
            return loadedVO;
        }

        // 팀 토론방은 하위 토론이 아닌 상위 토론의 참여기간으로 판단한다.
        DscsVO parentVO = selectDscs(loadedVO.getUpDscsId());
        return parentVO == null ? loadedVO : parentVO;
    }

    /**
     * 토론 정보를 조회한다.
     * @param dscsId
     * @return
     */
    private DscsVO selectDscs(String dscsId) {
        DscsVO paramVO = new DscsVO();
        paramVO.setDscsId(dscsId);
        return dscsService.selectDscs(paramVO);
    }
}
