package knou.lms.forum2.service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.vo.DscsVO;

public interface DscsAccessService {

    /**
     * 교수자 토론 수정 화면 진입 가능 여부를 확인한다.
     */
    ProcessResultVO<DscsVO> validateProfessorEditAccess(String dscsId);

    /**
     * 학습자 토론방 진입 가능 여부를 확인한다.
     */
    ProcessResultVO<DscsVO> validateLearnerEnterAccess(String dscsId);

    /**
     * 학습자 참여현황 화면 진입 가능 여부를 확인한다.
     */
    ProcessResultVO<DscsVO> validateLearnerPtcpStatusAccess(String dscsId);
}
