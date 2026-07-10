package knou.lms.contents.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.dto.ResultDTO;
import knou.lms.contents.web.paging.ContsPageInfo;
import knou.lms.contents.web.paging.ContsExrcsQstnPageInfo;
import knou.lms.contents.web.paging.ContsSddnQstnPageInfo;
import knou.lms.contents.vo.ContsSbjctListVO;
import knou.lms.contents.vo.LctrContsDvclasSelVO;
import knou.lms.contents.vo.LctrContsVO;
import knou.lms.contents.vo.LctrWknoContsVO;
import knou.lms.contents.vo.LctrWknoSchdlVO;

public interface ContsService {

    // 관리자 콘텐츠 관리 과목 목록 조회
    ResultDTO<ContsSbjctListVO> selectAdmLctrContsSbjctList(ContsPageInfo pageInfo);

    // 관리자 콘텐츠 관리 과목 목록 엑셀 다운로드
    List<ContsSbjctListVO> selectAdmLctrContsSbjctListExcelDown(ContsPageInfo pageInfo);

    // 선택 과목 강의주차와 주차별 학습자료 목록 조회
    ResultDTO<LctrWknoContsVO> selectAdmLctrWknoContsList(LctrWknoContsVO vo);

    // 강의주차일정 상세 조회
    LctrWknoSchdlVO selectAdmLctrWknoSchdl(LctrWknoSchdlVO vo);

    // 강의주차일정 수정
    ResultDTO<LctrWknoSchdlVO> updateAdmLctrWknoSchdl(LctrWknoSchdlVO vo);

    // 강의주차 공개여부 수정
    ResultDTO<LctrWknoContsVO> updateAdmLctrWknoOyn(LctrWknoContsVO vo);

    // 강의주차 순차학습여부 수정
    ResultDTO<LctrWknoContsVO> updateAdmLctrWknoSeqLrnyn(LctrWknoContsVO vo);

    // 관리자 학습목차 콘텐츠 상세 조회
    LctrContsVO selectAdmLctrConts(LctrContsVO vo);

    // 관리자 학습목차 콘텐츠 업로드 컨텍스트 조회
    LctrContsVO selectAdmLctrContsUploadContext(LctrContsVO vo);

    // 관리자 학습목차 하위 콘텐츠 목록 조회
    List<LctrContsVO> selectAdmLctrContsChildren(LctrContsVO vo);

    // 관리자 학습목차 주차 콘텐츠 목록 조회
    List<LctrContsVO> selectAdmLctrContsWeekList(LctrContsVO vo);

    // 관리자 학습목차 콘텐츠 분반 목록 조회
    List<LctrContsDvclasSelVO> selectAdmLctrContsDvclasList(LctrContsVO vo);

    // 관리자 학습목차 콘텐츠 분반 대상 주차 보유 목록 조회
    List<LctrContsDvclasSelVO> selectAdmLctrContsDvclasTargetList(LctrContsVO vo);

    // 관리자 학습목차 콘텐츠 저장
    ResultDTO<LctrContsVO> saveAdmLctrConts(LctrContsVO vo);

    // 관리자 학습목차 콘텐츠 등록
    ResultDTO<LctrContsVO> insertAdmLctrConts(LctrContsVO vo);

    // 관리자 학습목차 콘텐츠 수정
    ResultDTO<LctrContsVO> updateAdmLctrConts(LctrContsVO vo);

    // 관리자 학습목차 동영상 콘텐츠 저장
    ResultDTO<LctrContsVO> saveAdmLctrContsVideo(LctrContsVO vo);

    // 관리자 학습목차 연습문제 콘텐츠 저장
    ResultDTO<LctrContsVO> saveAdmLctrContsExrcsQstn(LctrContsVO vo);

    // 관리자 학습목차 콘텐츠 학습 이력 존재 여부 조회
    ResultDTO<Boolean> existsAdmLctrContsLearningHistory(LctrContsVO vo);

    // 관리자 학습목차 콘텐츠와 하위 콘텐츠 삭제
    ResultDTO<LctrContsVO> deleteAdmLctrContsTree(LctrContsVO vo);

    // 관리자 학습목차 돌발퀴즈 선택 목록 조회
    ResultDTO<EgovMap> selectAdmSddnQstnList(ContsSddnQstnPageInfo pageInfo);

    // 관리자 학습목차 연습문제 선택 목록 조회
    ResultDTO<EgovMap> selectAdmExrcsQstnList(ContsExrcsQstnPageInfo pageInfo);
}
