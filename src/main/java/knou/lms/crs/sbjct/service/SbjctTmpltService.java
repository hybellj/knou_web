package knou.lms.crs.sbjct.service;

import knou.lms.common.dto.ResultDTO;
import knou.lms.crs.sbjct.vo.*;
import knou.lms.crs.sbjct.web.paging.SbjctTmpltPageInfo;

import java.util.List;

public interface SbjctTmpltService {

    // 과목목록조회(페이징)
    ResultDTO<SbjctTmpltListVO> selectSbjctTmpltList(SbjctTmpltPageInfo pageInfo);

    // 과목목록 엑셀 다운로드
    List<SbjctTmpltListVO> selectSbjctTmpltListExcelDown(SbjctTmpltPageInfo pageInfo) ;

    // 과목개설 등록용 과목목록 조회
    ResultDTO<SbjctTmpltListVO> selectSbjctTmpltOfringList(SbjctTmpltListVO sbjctTmpltListVO) ;

    // 과목사용여부 수정
    ResultDTO<SbjctTmpltListVO> updateSbjctTmpltUseyn(SbjctTmpltListVO updateVo) ;

    // 과목삭제(논리삭제)
    ResultDTO<Integer> deleteSbjctTmplt(SbjctTmpltListVO deleteVo) ;

    // 과목명/과목코드 중복 체크
    ResultDTO<SbjctTmpltVO> checkSbjctTmpltDup(SbjctTmpltVO sbjctTmpltVO) ;

    // 과목 상세 조회
    SbjctTmpltVO selectSbjctTmplt(SbjctTmpltVO sbjctTmpltVO) ;

    // 과목 등록
    ResultDTO<SbjctTmpltVO> insertSbjctTmplt(SbjctTmpltVO sbjctTmpltVO) ;

    // 과목 엑셀 업로드 파일을 읽어 일괄 등록
    ResultDTO<SbjctTmpltVO> uploadSbjctTmpltExcel(SbjctTmpltVO sbjctTmpltVO) ;

    // 과목 수정
    ResultDTO<SbjctTmpltVO> updateSbjctTmplt(SbjctTmpltVO sbjctTmpltVO) ;
}
