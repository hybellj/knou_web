package knou.lms.forum2.service.impl;

import javax.annotation.Resource;

import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Service;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.dao.DscsCmntDAO;
import knou.lms.forum2.policy.DscsAccessPolicy;
import knou.lms.forum2.policy.DscsPeriodPolicy;
import knou.lms.forum2.service.DscsCmntService;
import knou.lms.forum2.vo.DscsCmntVO;

@Service("dscsCmntService")
public class DscsCmntServiceImpl extends ServiceBase implements DscsCmntService {

    @Resource(name = "dscsCmntDAO")
    private DscsCmntDAO dscsCmntDAO;

    @Resource(name = "dscsAccessPolicy")
    private DscsAccessPolicy dscsAccessPolicy;

    @Resource(name = "messageSource")
    private MessageSource messageSource;

    /**
     * 교수자 토론 댓글을 등록한다.
     * @param vo
     * @param userId
     * @return
     */
    @Override
    public ProcessResultVO<DefaultVO> profCmntRegist(DscsCmntVO vo, String userId) {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        // URL 우회 방지를 위해 service 계층에서 댓글 작성 가능 기간을 최종 검증한다.
        if (!dscsAccessPolicy.canProfWriteBbsByCmnt(vo)) {
            return fail(DscsPeriodPolicy.MSG_KEY_NOT_PERIOD);
        }
        vo.setDscsCmntId(IdGenerator.getNewId(IdPrefixType.DSCMT.getCode()));
        vo.setDscsId(StringUtil.nvl(vo.getDscsId()));
        vo.setRspnsReqyn(StringUtil.nvl(vo.getRspnsReqyn(), "N"));
        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        vo.setCmntCtsLen(StringUtil.getContentLenth(vo.getCmntCts()));
        dscsCmntDAO.insertCmnt(vo);
        resultVO.setResult(1);

        return resultVO;
    }

    /**
     * 교수자 토론 댓글을 수정한다.
     * @param vo
     * @param userId
     * @return
     */
    @Override
    public ProcessResultVO<DefaultVO> profCmntModify(DscsCmntVO vo, String userId) {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        // 댓글 ID만 넘어온 요청도 service 계층에서 실제 토론 기간을 검증한다.
        if (!dscsAccessPolicy.canProfWriteBbsByCmnt(vo)) {
            return fail(DscsPeriodPolicy.MSG_KEY_NOT_PERIOD);
        }
        vo.setMdfrId(userId);
        vo.setCmntCtsLen(StringUtil.getContentLenth(vo.getCmntCts()));
        dscsCmntDAO.updateCmnt(vo);
        resultVO.setResult(1);

        return resultVO;
    }

    /**
     * 교수자 토론 댓글을 삭제한다.
     * @param vo
     * @param userId
     * @return
     */
    @Override
    public ProcessResultVO<DefaultVO> profCmntDelete(DscsCmntVO vo, String userId) {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        // 삭제는 종료 후에도 허용되므로 삭제/숨김 전용 정책으로 검증한다.
        if (!dscsAccessPolicy.canProfDeleteOrHideBbsByCmnt(vo)) {
            return fail(DscsPeriodPolicy.MSG_KEY_NOT_PERIOD);
        }
        vo.setMdfrId(userId);
        dscsCmntDAO.deleteCmnt(vo);
        resultVO.setResult(1);

        return resultVO;
    }

    /**
     * 교수자 토론 댓글을 숨김 처리한다.
     * @param vo
     * @param userId
     * @return
     */
    @Override
    public ProcessResultVO<DefaultVO> profCmntHide(DscsCmntVO vo, String userId) {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        // 숨김은 종료 후에도 허용되므로 삭제/숨김 전용 정책으로 검증한다.
        if (!dscsAccessPolicy.canProfDeleteOrHideBbsByCmnt(vo)) {
            return fail(DscsPeriodPolicy.MSG_KEY_NOT_PERIOD);
        }
        vo.setMdfrId(userId);
        dscsCmntDAO.hideCmnt(vo);
        resultVO.setResult(1);

        return resultVO;
    }

    /**
     * 학습자 토론 댓글을 등록한다.
     * @param vo
     * @param teamId
     * @param userId
     * @return
     */
    @Override
    public ProcessResultVO<DefaultVO> stdntCmntRegist(DscsCmntVO vo, String teamId, String userId) {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        String requestedDscsId = StringUtil.nvl(vo.getDscsId());
        String requestedTeamId = StringUtil.nvl(teamId);
        // URL 우회 방지를 위해 기간과 팀 소속을 service 계층에서 검증한다.
        if (!dscsAccessPolicy.canLearnerEnterOrWrite(requestedDscsId)) {
            return fail(DscsPeriodPolicy.MSG_KEY_NOT_PERIOD);
        }
        if (!dscsAccessPolicy.canLearnerWriteTeamDscs(requestedDscsId, requestedTeamId, userId)) {
            resultVO.setResult(-1);
            return resultVO;
        }

        vo.setDscsCmntId(IdGenerator.getNewId(IdPrefixType.DSCMT.getCode()));
        vo.setDscsId(requestedDscsId);
        vo.setRspnsReqyn(StringUtil.nvl(vo.getRspnsReqyn(), "N"));
        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        vo.setCmntCtsLen(StringUtil.getContentLenth(vo.getCmntCts()));
        dscsCmntDAO.insertCmnt(vo);
        resultVO.setResult(1);

        return resultVO;
    }

    /**
     * 학습자 토론 댓글을 수정한다.
     * @param vo
     * @param userId
     * @return
     */
    @Override
    public ProcessResultVO<DefaultVO> stdntCmntModify(DscsCmntVO vo, String userId) {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        String requestedCmntId = StringUtil.nvl(vo.getDscsCmntId());
        // URL 우회 방지를 위해 기간과 댓글 소유자를 service 계층에서 검증한다.
        if (!dscsAccessPolicy.canLearnerEnterOrWriteByCmnt(vo)) {
            return fail(DscsPeriodPolicy.MSG_KEY_NOT_PERIOD);
        }
        if (!dscsAccessPolicy.isLearnerOwnCmnt(requestedCmntId, userId)) {
            resultVO.setResult(-1);
            return resultVO;
        }

        vo.setDscsCmntId(requestedCmntId);
        vo.setMdfrId(userId);
        vo.setCmntCtsLen(StringUtil.getContentLenth(vo.getCmntCts()));
        dscsCmntDAO.updateCmnt(vo);
        resultVO.setResult(1);

        return resultVO;
    }

    /**
     * 학습자 토론 댓글을 삭제한다.
     * @param vo
     * @param userId
     * @return
     */
    @Override
    public ProcessResultVO<DefaultVO> stdntCmntDelete(DscsCmntVO vo, String userId) {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        String requestedCmntId = StringUtil.nvl(vo.getDscsCmntId());
        // URL 우회 방지를 위해 기간과 댓글 소유자를 service 계층에서 검증한다.
        if (!dscsAccessPolicy.canLearnerEnterOrWriteByCmnt(vo)) {
            return fail(DscsPeriodPolicy.MSG_KEY_NOT_PERIOD);
        }
        if (!dscsAccessPolicy.isLearnerOwnCmnt(requestedCmntId, userId)) {
            resultVO.setResult(-1);
            return resultVO;
        }

        vo.setDscsCmntId(requestedCmntId);
        vo.setMdfrId(userId);
        dscsCmntDAO.deleteCmnt(vo);
        resultVO.setResult(1);

        return resultVO;
    }

    /**
     * 기간 제한 위반 실패 응답을 생성한다.
     * @param message
     * @return
     */
    private ProcessResultVO<DefaultVO> fail(String message) {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();
        resultVO.setResultFailed(getMessage(message));
        return resultVO;
    }

    /**
     * 메시지 코드를 현재 locale의 문구로 변환한다.
     * @param messageKey
     * @return
     */
    private String getMessage(String messageKey) {
        return messageSource.getMessage(messageKey, null, messageKey, LocaleContextHolder.getLocale());
    }

}
