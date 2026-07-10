package knou.lms.crs.sbjct.service;

import java.util.List;

import knou.framework.context2.UserContext;
import knou.lms.common.dto.ResultDTO;
import knou.lms.crs.sbjct.vo.SbjctAdmVO;
import knou.lms.crs.sbjct.vo.SbjctAtndlcVO;
import knou.lms.crs.sbjct.vo.SbjctListVO;
import knou.lms.crs.sbjct.vo.SbjctSchdlVO;
import knou.lms.crs.sbjct.vo.SbjctVO;
import knou.lms.crs.sbjct.web.paging.SbjctOfringPageInfo;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

public interface SbjctService {

    // 과목 조회
    public List<SbjctVO> list(SbjctVO vo) ;

    // 과목개설목록조회(페이징)
    public ResultDTO<SbjctListVO> selectSbjctOfringList(SbjctOfringPageInfo pageInfo) ;

    // 과목개설목록 엑셀 다운로드
    public List<SbjctListVO> selectSbjctOfringListExcelDown(SbjctOfringPageInfo pageInfo) ;

    // 공개강좌개설 목록 조회(페이징)
    public ResultDTO<SbjctListVO> selectOpenLctrOfringList(SbjctOfringPageInfo pageInfo) ;

    // 공개강좌개설 목록 엑셀 다운로드
    public List<SbjctListVO> selectOpenLctrOfringListExcelDown(SbjctOfringPageInfo pageInfo) ;

    // 과목개설 상세 조회
    public SbjctVO selectSbjctOfring(SbjctVO vo) ;

    // 과목개설 접근 권한 체크용 조회
    public SbjctVO selectSbjctOfringAccess(SbjctVO vo) ;

    // 과목개설 주차 기간 설정 목록 조회
    public List<SbjctSchdlVO> selectSbjctOfringSchdlList(SbjctVO vo) ;

    // 과목개설 등록
    public ResultDTO<SbjctVO> insertSbjctOfring(SbjctVO vo) ;

    // 공개강좌개설 등록
    public ResultDTO<SbjctVO> insertOpenLctrOfring(SbjctVO vo) ;

    // 과목개설 수정
    public ResultDTO<SbjctVO> updateSbjctOfring(SbjctVO vo) ;

    // 공개강좌개설 수정
    public ResultDTO<SbjctVO> updateOpenLctrOfring(SbjctVO vo) ;

    // 과목개설 삭제(논리삭제)
    public ResultDTO<Integer> deleteSbjctOfring(SbjctVO vo) ;

    // 과목개설 목록에서 사용여부만 수정
    public ResultDTO<SbjctVO> updateSbjctOfringUseyn(SbjctVO vo) ;

    // 공개강좌개설 목록에서 사용여부만 수정
    public ResultDTO<SbjctVO> updateOpenLctrOfringUseyn(SbjctVO vo) ;

    // 과목개설 주차 기간 설정 저장
    public ResultDTO<SbjctSchdlVO> saveSbjctOfringSchdl(SbjctSchdlVO vo) ;

    // 과목개설 과목관리자 등록용 사용자 목록 조회
    public ResultDTO<SbjctAdmVO> admSbjctOfringAdmUserList(SbjctAdmVO vo) ;

    // 과목개설 과목관리자 목록 조회
    public List<SbjctAdmVO> admSbjctOfringAdmList(SbjctAdmVO vo) ;

    // 과목개설 과목관리자 저장
    public ResultDTO<SbjctAdmVO> admSbjctOfringAdmRegist(SbjctAdmVO vo) ;

    // 과목개설 수강생 등록용 사용자 목록 조회
    public ResultDTO<SbjctAtndlcVO> admSbjctOfringStdntUserList(SbjctAtndlcVO vo) ;

    // 과목개설 수강생 목록 조회
    public List<SbjctAtndlcVO> admSbjctOfringStdntList(SbjctAtndlcVO vo) ;

    // 과목개설 수강생 엑셀 업로드 학생 목록 조회
    public List<SbjctAtndlcVO> admSbjctOfringStdntExcelList(SbjctAtndlcVO vo) ;

    // 과목개설 수강생 엑셀 업로드 파일을 읽어 수강생 목록 조회 결과 반환
    public ResultDTO<SbjctAtndlcVO> admSbjctOfringStdntExcelUpload(SbjctAtndlcVO vo) ;

    // 과목개설 수강생 저장
    public ResultDTO<SbjctAtndlcVO> admSbjctOfringStdntRegist(SbjctAtndlcVO vo) ;

    public List<EgovMap> sbjctListByAuthrt(UserContext userCtx);
}
