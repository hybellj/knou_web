package knou.lms.crs.sbjct.dao;

import java.util.List;

import knou.framework.common.PageInfo;
import knou.lms.crs.sbjct.vo.SbjctListVO;
import knou.lms.crs.sbjct.vo.SbjctAdmVO;
import knou.lms.crs.sbjct.vo.SbjctAtndlcVO;
import knou.lms.crs.sbjct.vo.SbjctSchdlVO;
import knou.lms.crs.sbjct.vo.SbjctVO;
import knou.lms.crs.sbjct.web.paging.SbjctOfringPageInfo;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

@Mapper("sbjctDAO")
public interface SbjctDAO {

    // 과목 조회
    public List<SbjctVO> list(SbjctVO vo) ;

    // 과목개설목록조회(페이징)
    public List<SbjctListVO> selectSbjctOfringList(SbjctOfringPageInfo pageInfo) ;

    // 과목개설목록 엑셀 다운로드
    public List<SbjctListVO> selectSbjctOfringListExcelDown(SbjctOfringPageInfo pageInfo) ;

    // 공개강좌개설 목록 조회(페이징)
    public List<SbjctListVO> selectOpenLctrOfringList(SbjctOfringPageInfo pageInfo) ;

    // 공개강좌개설 목록 엑셀 다운로드
    public List<SbjctListVO> selectOpenLctrOfringListExcelDown(SbjctOfringPageInfo pageInfo) ;

    // 과목개설 상세 조회
    public SbjctVO selectSbjctOfring(SbjctVO vo) ;

    // 과목개설 접근 권한 체크용 조회
    public SbjctVO selectSbjctOfringAccess(SbjctVO vo) ;

    // 과목개설 주차 기간 설정 목록 조회
    public List<SbjctSchdlVO> selectSbjctOfringSchdlList(SbjctVO vo) ;

    // 과목개설 등록
    public int insertSbjctOfring(SbjctVO vo) ;

    // 과목개설 수정
    public int updateSbjctOfring(SbjctVO vo) ;

    // 과목개설 삭제(논리삭제)
    public int deleteSbjctOfring(SbjctVO vo) ;

    // 과목개설 목록에서 사용여부만 수정
    public int updateSbjctOfringUseyn(SbjctVO vo) ;

    // 공개강좌개설 목록에서 사용여부만 수정
    public int updateOpenLctrOfringUseyn(SbjctVO vo) ;

    // 과목개설 주차 기간 설정 목록 벌크 등록
    public int insertSbjctOfringSchdlList(SbjctSchdlVO vo) ;

    // 과목개설 주차 기간 설정 목록 삭제
    public int deleteSbjctOfringSchdlList(SbjctSchdlVO vo) ;

    // 과목개설 과목관리자 등록용 사용자 목록 조회
    public List<SbjctAdmVO> admSbjctOfringAdmUserList(SbjctAdmVO vo) ;

    // 과목개설 과목관리자 목록 조회
    public List<SbjctAdmVO> admSbjctOfringAdmList(SbjctAdmVO vo) ;

    // 과목개설 과목관리자 목록 삭제
    public int deleteSbjctOfringAdmList(SbjctAdmVO vo) ;

    // 과목개설 과목관리자 벌크 등록
    public int insertSbjctOfringAdmList(SbjctAdmVO vo) ;

    // 과목개설 대표 교수아이디 수정
    public int updateSbjctOfringProfId(SbjctAdmVO vo) ;

    // 과목개설 수강생 등록용 사용자 목록 조회
    public List<SbjctAtndlcVO> admSbjctOfringStdntUserList(SbjctAtndlcVO vo) ;

    // 과목개설 수강생 목록 조회
    public List<SbjctAtndlcVO> admSbjctOfringStdntList(SbjctAtndlcVO vo) ;

    // 과목개설 수강생 엑셀 업로드 학생 목록 조회
    public List<SbjctAtndlcVO> admSbjctOfringStdntExcelList(SbjctAtndlcVO vo) ;

    // 과목개설 수강생 목록 삭제
    public int deleteSbjctOfringStdntList(SbjctAtndlcVO vo) ;

    // 과목개설 수강생 목록 벌크 등록
    public int insertSbjctOfringStdntList(SbjctAtndlcVO vo) ;

    // 과목 목록 조회
    public List<EgovMap> admSbjctList(PageInfo pageInfo);

    // 과목 목록 조회
    public List<EgovMap> profSbjctList(PageInfo pageInfo);

    // 과목 목록 조회
    public List<EgovMap> stdntSbjctList(PageInfo pageInfo);
}
