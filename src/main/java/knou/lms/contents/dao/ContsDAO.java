package knou.lms.contents.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.contents.web.paging.ContsPageInfo;
import knou.lms.contents.web.paging.ContsExrcsQstnPageInfo;
import knou.lms.contents.web.paging.ContsSddnQstnPageInfo;
import knou.lms.contents.vo.ContsSbjctListVO;
import knou.lms.contents.vo.LctrContsDvclasSelVO;
import knou.lms.contents.vo.LctrContsVO;
import knou.lms.contents.vo.LctrWknoContsVO;
import knou.lms.contents.vo.LctrWknoSchdlVO;

@Mapper("contsDAO")
public interface ContsDAO {

    // 관리자 콘텐츠 관리 과목 목록 조회
    List<ContsSbjctListVO> selectAdmLctrContsSbjctList(ContsPageInfo pageInfo);

    // 관리자 콘텐츠 관리 과목 목록 엑셀 다운로드
    List<ContsSbjctListVO> selectAdmLctrContsSbjctListExcelDown(ContsPageInfo pageInfo);

    // 선택 과목 강의주차와 주차별 학습자료 목록 조회
    List<LctrWknoContsVO> selectAdmLctrWknoContsList(LctrWknoContsVO vo);

    // 강의주차일정 상세 조회
    LctrWknoSchdlVO selectAdmLctrWknoSchdl(LctrWknoSchdlVO vo);

    // 강의주차일정 수정
    int updateAdmLctrWknoSchdl(LctrWknoSchdlVO vo);

    // 강의주차 공개여부 수정
    int updateAdmLctrWknoOyn(LctrWknoContsVO vo);

    // 강의주차 순차학습여부 수정
    int updateAdmLctrWknoSeqLrnyn(LctrWknoContsVO vo);

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

    // 관리자 학습목차 콘텐츠 분반 대상 강의 조회
    LctrContsVO selectAdmLctrContsTargetLctr(LctrContsVO vo);

    // 관리자 학습목차 콘텐츠 등록
    int insertAdmLctrConts(LctrContsVO vo);

    // 관리자 학습목차 콘텐츠 일괄 등록
    int insertAdmLctrContsBatch(List<LctrContsVO> list);

    // 관리자 학습목차 콘텐츠 수정
    int updateAdmLctrConts(LctrContsVO vo);

    // 관리자 학습목차 콘텐츠 등록 순번 보정
    int increaseAdmLctrContsSeqnoForInsert(LctrContsVO vo);

    // 관리자 학습목차 콘텐츠 상위 이동 순번 보정
    int increaseAdmLctrContsSeqnoForMoveUp(LctrContsVO vo);

    // 관리자 학습목차 콘텐츠 하위 이동 순번 보정
    int decreaseAdmLctrContsSeqnoForMoveDown(LctrContsVO vo);

    // 관리자 학습목차 콘텐츠 학습 이력 건수 조회
    int selectAdmLctrContsLearningHistoryCnt(LctrContsVO vo);

    // 관리자 학습목차 콘텐츠와 하위 콘텐츠 삭제
    int deleteAdmLctrContsTree(LctrContsVO vo);

    // 관리자 학습목차 돌발퀴즈 하위 콘텐츠 삭제
    int deleteAdmLctrContsSddnQstnChildren(LctrContsVO vo);

    // 관리자 학습목차 돌발퀴즈 선택 목록 조회
    List<EgovMap> selectAdmSddnQstnList(ContsSddnQstnPageInfo pageInfo);

    // 관리자 학습목차 연습문제 선택 목록 조회
    List<EgovMap> selectAdmExrcsQstnList(ContsExrcsQstnPageInfo pageInfo);
}
