package knou.lms.sbjctinfo.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.sbjctinfo.vo.SbjctInfoAliasVO;
import knou.lms.sbjctinfo.vo.SbjctInfoQuizPreviewVO;
import knou.lms.sbjctinfo.vo.SbjctInfoSrtVO;
import knou.lms.sbjctinfo.vo.SbjctInfoVO;

@Mapper("sbjctInfoDAO")
public interface SbjctInfoDAO {

    // 과목정보 조회
    SbjctInfoVO selectSbjctInfo(SbjctInfoVO vo);

    // 분반별칭 목록 조회
    List<SbjctInfoAliasVO> selectSbjctInfoAliasList(SbjctInfoAliasVO vo);

    // 분반별칭 수정
    int updateSbjctInfoAlias(SbjctInfoAliasVO vo);

    // 돌발퀴즈 미리보기 목록 조회
    List<SbjctInfoQuizPreviewVO> selectQuizPreviewList(SbjctInfoQuizPreviewVO vo);

    // 돌발퀴즈 미리보기 문항+보기 조회
    List<SbjctInfoQuizPreviewVO> selectQuizPreviewDetail(SbjctInfoQuizPreviewVO vo);

    // 다국어 자막(스크립트) 목록 조회
    List<SbjctInfoSrtVO> selectSrtList(SbjctInfoSrtVO vo);
}
