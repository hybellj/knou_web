package knou.lms.sbjctinfo.service;

import java.util.List;

import knou.lms.sbjctinfo.vo.SbjctInfoAliasVO;
import knou.lms.sbjctinfo.vo.SbjctInfoQuizPreviewVO;
import knou.lms.sbjctinfo.vo.SbjctInfoSrtVO;
import knou.lms.sbjctinfo.vo.SbjctInfoVO;

/**
 * 과목정보/분반별칭관리 서비스
 */
public interface SbjctInfoService {

    /*****************************************************
     * 과목정보 조회
     * @param vo 과목정보 조회 조건
     * @return 과목정보
     *****************************************************/
    SbjctInfoVO selectSbjctInfo(SbjctInfoVO vo);

    /*****************************************************
     * 분반별칭 목록 조회
     * @param vo 분반별칭 조회 조건
     * @return 분반별칭 목록
     *****************************************************/
    List<SbjctInfoAliasVO> selectSbjctInfoAliasList(SbjctInfoAliasVO vo);

    /*****************************************************
     * 분반별칭 저장
     * @param vo 분반별칭 저장 정보
     *****************************************************/
    int saveSbjctInfoAlias(SbjctInfoAliasVO vo);

    /*****************************************************
     * 돌발퀴즈 미리보기 목록 조회
     * @param vo sbjctId 기준 조회 조건
     * @return 과목의 돌발퀴즈 목록
     *****************************************************/
    List<SbjctInfoQuizPreviewVO> selectQuizPreviewList(SbjctInfoQuizPreviewVO vo);

    /*****************************************************
     * 돌발퀴즈 미리보기 문항+보기 조회
     * @param vo quizId 기준 조회 조건
     * @return 해당 돌발퀴즈의 문항 및 보기 목록
     *****************************************************/
    List<SbjctInfoQuizPreviewVO> selectQuizPreviewDetail(SbjctInfoQuizPreviewVO vo);

    /**
     * 다국어 자막(스크립트) 목록 조회
     */
    List<SbjctInfoSrtVO> selectSrtList(SbjctInfoSrtVO vo);
}
