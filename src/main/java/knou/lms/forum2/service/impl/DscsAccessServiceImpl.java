package knou.lms.forum2.service.impl;

import java.util.Locale;

import javax.annotation.Resource;

import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.policy.DscsAccessPolicy;
import knou.lms.forum2.policy.DscsPeriodPolicy;
import knou.lms.forum2.service.DscsAccessService;
import knou.lms.forum2.vo.DscsVO;

/**
 * Controller에서 사용하는 토론 접근 검증 service이다.
 */
@Service("dscsAccessService")
public class DscsAccessServiceImpl implements DscsAccessService {

    @Resource(name = "dscsAccessPolicy")
    private DscsAccessPolicy dscsAccessPolicy;

    @Resource(name = "messageSource")
    private MessageSource messageSource;

    /**
     * 교수자 토론 수정 화면 진입 가능 여부를 확인한다.
     */
    @Override
    public ProcessResultVO<DscsVO> validateProfessorEditAccess(String dscsId) {
        ProcessResultVO<DscsVO> resultVO = new ProcessResultVO<DscsVO>();
        if (!dscsAccessPolicy.canProfEditDscs(dscsId)) {
            return resultVO.setResultFailed(getMessage(DscsPeriodPolicy.MSG_KEY_BEFORE_ONLY));
        }
        return resultVO.setResultSuccess();
    }

    /**
     * 학습자 토론방 진입 가능 여부를 확인한다.
     */
    @Override
    public ProcessResultVO<DscsVO> validateLearnerEnterAccess(String dscsId) {
        ProcessResultVO<DscsVO> resultVO = new ProcessResultVO<DscsVO>();
        if (!dscsAccessPolicy.canLearnerEnterOrWrite(dscsId)) {
            return resultVO.setResultFailed(getMessage(DscsPeriodPolicy.MSG_KEY_NOT_PERIOD));
        }
        return resultVO.setResultSuccess();
    }

    /**
     * 학습자 참여현황 화면 진입 가능 여부를 확인한다.
     */
    @Override
    public ProcessResultVO<DscsVO> validateLearnerPtcpStatusAccess(String dscsId) {
        ProcessResultVO<DscsVO> resultVO = new ProcessResultVO<DscsVO>();
        if (!dscsAccessPolicy.canLearnerViewPtcpStatus(dscsId)) {
            return resultVO.setResultFailed(getMessage(DscsPeriodPolicy.MSG_KEY_NOT_PERIOD));
        }
        return resultVO.setResultSuccess();
    }

    private String getMessage(String messageKey) {
        Locale locale = LocaleContextHolder.getLocale();
        return messageSource.getMessage(messageKey, null, messageKey, locale);
    }
}
