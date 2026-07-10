package knou.lms.sbjctinfo.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.lms.sbjctinfo.dao.SbjctInfoDAO;
import knou.lms.sbjctinfo.service.SbjctInfoService;
import knou.lms.sbjctinfo.vo.SbjctInfoAliasVO;
import knou.lms.sbjctinfo.vo.SbjctInfoQuizPreviewVO;
import knou.lms.sbjctinfo.vo.SbjctInfoSrtVO;
import knou.lms.sbjctinfo.vo.SbjctInfoVO;

/**
 * 과목정보/분반별칭관리 서비스 구현체
 */
@Service("sbjctInfoService")
public class SbjctInfoServiceImpl implements SbjctInfoService {

    @Resource(name = "sbjctInfoDAO")
    private SbjctInfoDAO sbjctInfoDAO;

    /**
     * 과목정보 조회
     */
    @Override
    public SbjctInfoVO selectSbjctInfo(SbjctInfoVO vo) {
        return sbjctInfoDAO.selectSbjctInfo(vo);
    }

    /**
     * 분반별칭 목록 조회
     */
    @Override
    public List<SbjctInfoAliasVO> selectSbjctInfoAliasList(SbjctInfoAliasVO vo) {
        return sbjctInfoDAO.selectSbjctInfoAliasList(vo);
    }

    /**
     * 분반별칭 저장
     */
    @Override
    public int saveSbjctInfoAlias(SbjctInfoAliasVO vo) {
        return sbjctInfoDAO.updateSbjctInfoAlias(vo);
    }

    /**
     * 돌발퀴즈 미리보기 목록 조회
     */
    @Override
    public List<SbjctInfoQuizPreviewVO> selectQuizPreviewList(SbjctInfoQuizPreviewVO vo) {
        return sbjctInfoDAO.selectQuizPreviewList(vo);
    }

    /**
     * 돌발퀴즈 미리보기 상세 조회
     */
    @Override
    public List<SbjctInfoQuizPreviewVO> selectQuizPreviewDetail(SbjctInfoQuizPreviewVO vo) {
        return sbjctInfoDAO.selectQuizPreviewDetail(vo);
    }

    /**
     * 다국어 자막(스크립트) 목록 조회
     */
    @Override
    public List<SbjctInfoSrtVO> selectSrtList(SbjctInfoSrtVO vo) {
        return sbjctInfoDAO.selectSrtList(vo);
    }
}
