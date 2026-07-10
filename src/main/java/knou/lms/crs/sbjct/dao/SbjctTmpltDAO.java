package knou.lms.crs.sbjct.dao;

import java.util.List;

import knou.lms.crs.sbjct.vo.*;
import knou.lms.crs.sbjct.web.paging.SbjctTmpltPageInfo;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

@Mapper("sbjctTmpltDAO")
public interface SbjctTmpltDAO {

    // 과목목록조회(페이징)
    List<SbjctTmpltListVO> selectSbjctTmpltList(SbjctTmpltPageInfo pageInfo) ;

    // 과목목록 엑셀 다운로드
    List<SbjctTmpltListVO> selectSbjctTmpltListExcelDown(SbjctTmpltPageInfo pageInfo) ;

    // 과목개설 등록용 과목목록 조회
    List<SbjctTmpltListVO> selectSbjctTmpltOfringList(SbjctTmpltListVO sbjctTmpltListVO) ;

    // 과목사용여부 수정
    int updateSbjctTmpltUseyn(SbjctTmpltListVO sbjctTmpltListVO) ;

    // 과목삭제(논리삭제)
    int deleteSbjctTmplt(SbjctTmpltListVO sbjctTmpltListVO) ;

    // 과목명/과목코드 중복 체크
    int selectSbjctTmpltDupCnt(SbjctTmpltVO sbjctTmpltVO) ;

    // 과목 학기/기수 유효성 체크
    int selectSbjctTmpltSmstrChrtCnt(SbjctTmpltVO sbjctTmpltVO) ;

    // 과목 상세 조회
    SbjctTmpltVO selectSbjctTmplt(SbjctTmpltVO sbjctTmpltVO) ;

    // 과목 등록
    int insertSbjctTmplt(SbjctTmpltVO sbjctTmpltVO) ;

    // 과목 벌크 등록
    int insertSbjctTmpltList(List<SbjctTmpltVO> sbjctTmpltList) ;

    // 과목 수정
    int updateSbjctTmplt(SbjctTmpltVO sbjctTmpltVO) ;
}
