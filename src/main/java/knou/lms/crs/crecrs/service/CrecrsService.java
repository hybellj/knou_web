package knou.lms.crs.crecrs.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.vo.CreCrsTchRltnVO;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.std.vo.StdVO;
import knou.lms.subject2.vo.SubjectVO;
import knou.lms.user.vo.UsrUserInfoVO;

public interface CrecrsService {
    
    /**
     * 강의실 교수 세션설정
     * @param request
     * @param crsCreCd
     * @return 
     * @throws Exception
     */
    public void setCreCrsProfSession(HttpServletRequest request, CreCrsVO creCrsVO) throws Exception;
    
    /**
     * 강의실 학생 세션설정
     * @param request
     * @param crsCreCd
     * @return 
     * @throws Exception
     */
    public void setCreCrsStuSession(HttpServletRequest request, CreCrsVO creCrsVO, StdVO stdVO) throws Exception;
    
    /**
     * 강의실 정보
     * @param CreCrsVO
     * @return CreCrsVO
     * @throws Exception
     */
    public CreCrsVO select(CreCrsVO vo) throws Exception;
    
    /**
     * 강의실 수
     * @param CreCrsVO
     * @return int
     * @throws Exception
     */
    public int count(CreCrsVO vo) throws Exception;
    
    /**
     * 강의실 목록
     * @return List<CreCrsVO>
     * @throws Exception
     */
    public List<CreCrsVO> list(CreCrsVO vo) throws Exception;
    
    /**
     * 강의실 목록 페이징
     * @param CreCrsVO
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     */
    public ProcessResultVO<CreCrsVO> listPaging(CreCrsVO vo) throws Exception;
    
    /**
     * 강의실 드롭다운 목록
     * @param CreCrsVO
     * @return List<CreCrsVO>
     * @throws Exception
     */
    public List<CreCrsVO> listCrsCreDropdown(CreCrsVO vo) throws Exception;

    public ProcessResultVO<CreCrsVO> selectStdCreCrsList(CreCrsVO vo) throws Exception;

    public List<CreCrsVO> listTchCrsCreByTerm(CreCrsVO vo) throws Exception;

    public CreCrsVO selectCreCrs(CreCrsVO vo) throws Exception;
    public CreCrsVO infoCreCrs(CreCrsVO vo) throws Exception;

    public List<CreCrsVO> listCreCrsDeclsNo(CreCrsVO vo) throws Exception;

    public List<CreCrsVO> listCrsCreByTerm(CreCrsVO vo) throws Exception;

    public CreCrsVO selectTchCreCrs(CreCrsVO vo) throws Exception;

    /**
     * 개설 과정 전체 목록을 조회한다 : 과정 단위에서 구성
     * @param CreCrsForumRltnVO
     * @throws Exception
     */
    public List<CreCrsVO> creCrsTchJoinList(CreCrsVO vo) throws Exception;
    
    /**
     * 메인 > 학생 > 마이페이지 리스트
     * 
     * @param CreCrsVO
     * @return List<CreCrsVO>
     * @throws Exception
     */
    public List<CreCrsVO> listMainMypageStd(CreCrsVO vo) throws Exception;

    /**
     * 과목 > 조교/교수 정보 조회
     * @param CreCrsTchRltnVO
     * @return CreCrsTchRltnVO
     * @throws Exception
     */
    public CreCrsTchRltnVO selectCrecrsTch(CreCrsTchRltnVO vo) throws Exception;
    
    /**
     * 과목 > 조교/교수 목록
     * @param CreCrsVO
     * @return List<CreCrsTchRltnVO>
     * @throws Exception
     */
    public List<CreCrsTchRltnVO> listCrecrsTch(CreCrsVO vo) throws Exception;
    
    /**
     * 과목과 동일 학과 교수 목록 페이징
     * @param CreCrsTchRltnVO
     * @return ProcessResultVO<CreCrsTchRltnVO>
     * @throws Exception
     */
    public ProcessResultVO<CreCrsTchRltnVO> listCrecrsTchByMenuType(CreCrsTchRltnVO vo) throws Exception;
    
    /**
     * 과목 > 조교/교수 등록
     * @param CreCrsTchRltnVO
     * @return void
     * @throws Exception
     */
    public void insertCrecrsTch(CreCrsTchRltnVO vo) throws Exception;
    
    /**
     * 과목 > 조교/교수 수정
     * @param CreCrsTchRltnVO
     * @return void
     * @throws Exception
     */
    public void updateCrecrsTch(CreCrsTchRltnVO vo) throws Exception;
    
    /**
     * 과목 > 조교/교수 삭제
     * @param CreCrsTchRltnVO
     * @return void
     * @throws Exception
     */
    public void deleteCrecrsTch(CreCrsTchRltnVO vo) throws Exception;
    
    /**
     * 사용자와 동일 학과 과목 목록 페이징
     * @param CreCrsVO
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     */
    public ProcessResultVO<CreCrsVO> listCrecrsByUserDept(CreCrsVO vo) throws Exception;
    
    /**
     * 사용자 관리 > 사용자 상세 강의(수강) 과목 리스트
     * @param CreCrsVO
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     */
    public ProcessResultVO<CreCrsVO> listUserCreCrsPaging(CreCrsVO vo) throws Exception;
    
    /**
     * 교수/조교 관리 > 개설과목 리스트
     * @param CreCrsVO
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     */
    public ProcessResultVO<CreCrsVO> listCreCrs(CreCrsVO vo) throws Exception;
    
    /**
     * 교수/조교 정보 > 교수/조교 목록
     * @param CreCrsVO
     * @return List<CreCrsVO>
     * @throws Exception
     */
    public ProcessResultVO<CreCrsVO> listTchStatus(CreCrsVO vo) throws Exception;
    
    /**
     * 강의실 상단 정보
     * @param CreCrsVO
     * @return CreCrsVO
     * @throws Exception
     */
    public CreCrsVO crsCreTopInfo(CreCrsVO vo) throws Exception;
    
    /**
     * 메인 > 교수 > 마이페이지 리스트
     * 
     * @param CreCrsVO
     * @return List<CreCrsVO>
     * @throws Exception
     */
    public List<CreCrsVO> listMainMypageTch(CreCrsVO vo) throws Exception;

    public ProcessResultVO<CreCrsVO> selectListPage(CreCrsVO termVO) throws Exception;

    public CreCrsVO selectCrsCre(CreCrsVO vo) throws Exception;

    public ProcessResultVO<DefaultVO> crsCreAdd(CreCrsVO vo) throws Exception;
    
    public List<CreCrsVO> listCreCrsDeclsNoByTch(CreCrsVO vo) throws Exception;
    
    /***************************************************** 
     * 분반 중복 체크
     * 
     * @param CreCrsVO
     * @return CreCrsVO
     * @throws Exception
     ******************************************************/ 
    public CreCrsVO checkDeclsNo(CreCrsVO vo) throws Exception;
    
    public int checkDeclsCnt(CreCrsVO vo) throws Exception;
    
    public List<CreCrsVO> selectListCreTch(CreCrsVO vo) throws Exception;

    public CreCrsVO selectTch(CreCrsVO vo) throws Exception;

    /**
     * 개설과목관리 > 운영자 등록
     * @param CreCrsVO
     * @return void
     * @throws Exception
     */
    public void addTch(CreCrsVO vo) throws Exception;

    public ProcessResultVO<UsrUserInfoVO> selectUsrTchList(UsrUserInfoVO vo) throws Exception;

    public ProcessResultVO<CreCrsVO> selectCreTchList(CreCrsVO vo) throws Exception;

    public ProcessResultVO<DefaultVO> addCreStd(CreCrsVO vo) throws Exception;
    
    /**
     * 개설과목관리 > 릴레이션 테이블에 수강생 수정(머지문)
     * @param CreCrsVO
     * @return void
     * @throws Exception
     */
    // public void mergeEditStd(CreCrsVO vo) throws Exception;

    public void deleteCreCrs(CreCrsVO vo) throws Exception;
    
    public CreCrsVO creOpenList(CreCrsVO vo) throws Exception;
    
    public ProcessResultVO<CreCrsVO> coListPageing(CreCrsVO vo) throws Exception;

    public int editUseYn(CreCrsVO vo) throws Exception;

    public void deletecrsCreCo(CreCrsVO vo) throws Exception;
    
    public List<EgovMap> listCrecrsTchEgov(CreCrsVO vo) throws Exception;
    
    /**
     * 개설과목관리 > 등록된 운영자 정보 리스트
     * @param CreCrsVO
     * @return void
     * @throws Exception
     */
    public List<CreCrsVO> listCreTch(CreCrsVO vo) throws Exception;
    
    /**
     * 개설 과목 한개 조회 .
     * @param CreCrsVO
     * @return CreCrsVO
     * @throws Exception
     */
    public CreCrsVO viewCrsCre(CreCrsVO vo) throws Exception;
    
    
    /**
     * 개설 과목 한개 수정 .
     * @param CreCrsVO
     * @return void
     * @throws Exception
     */
    public void update(CreCrsVO vo) throws Exception;
    
    /**
     * 개설 과목 한개 등록 .
     * @param CreCrsVO
     * @return void
     * @throws Exception
     */
    public void add(CreCrsVO vo) throws Exception;
    
    public ProcessResultVO<CreCrsVO> creUserlistPageing(CreCrsVO vo) throws Exception;
    
    /**
     * 개설과목관리 > 릴레이션 테이블에 수강생 수정
     * @param CreCrsVO
     * @return void
     * @throws Exception
     */
    public void editStd(CreCrsVO vo) throws Exception;
    
    public void mergeEditStd(CreCrsVO vo) throws Exception;
    
    public void addStdexcelUpload(CreCrsVO vo, List<Map<String, Object>> list) throws Exception;
    
    /**
     * 개설 과목 목록 (기수제).
     * @param CreCrsVO
     * @return List
     * @throws Exception
     */
    public List<CreCrsVO> coList(CreCrsVO vo) throws Exception;
    
    /**
     * 개설과목 관리 목록
     * @param CreCrsVO
     * @return List
     * @throws Exception
     */
    public List<CreCrsVO> listManageCourse(CreCrsVO vo) throws Exception;
    
    /**
     * 개설과목 관리 목록 페이징
     * @param CreCrsVO
     * @return ProcessResultVO<CreCrsVO>
     * @throws Exception
     */
    public ProcessResultVO<CreCrsVO> listPagingManageCourse(CreCrsVO vo) throws Exception;
    
    /**
     * 개설 과목 한개 등록 (기수제).
     * @param CreCrsVO
     * @return void
     * @throws Exception
     */
    public void addCoCreCrs(CreCrsVO vo) throws Exception;
    
    /**
     * 학기/과목 > 법정 교육 개설 관리 > 법정교육 등록
     * @param CreCrsVO
     * @return void
     * @throws Exception
     */
    public CreCrsVO insertCreCrsLegal(CreCrsVO vo) throws Exception;
    
    /**
     * 학기/과목 > 법정 교육 개설 관리 > 법정교육 수정
     * @param CreCrsVO
     * @return void
     * @throws Exception
     */
    public CreCrsVO updateCreCrsLegal(CreCrsVO vo) throws Exception;
    
    /**
     * 학기/과목 > 공개 강좌 개설 관리 > 공개강좌 등록
     * @param CreCrsVO
     * @return void
     * @throws Exception
     */
    public CreCrsVO insertCreCrsOpen(CreCrsVO vo) throws Exception;
    
    /**
     * 학기/과목 > 공개 강좌 개설 관리 > 공개강좌 수정
     * @param CreCrsVO
     * @return void
     * @throws Exception
     */
    public CreCrsVO updateCreCrsOpen(CreCrsVO vo) throws Exception;
    
    public List<CreCrsVO> listAuthCrsCreByTerm(CreCrsVO vo) throws Exception;

    /**
     * 관리/설정 > 이전과목 가져오기
     * @param CreCrsVO
     * @return Map<String, Object>
     * @throws Exception
     */
    public Map<String, Object> copyPrevCourse(CreCrsVO vo, String copyCrsCreCd) throws Exception;
    
    /**
     * 이전학기 과목여부 체크
     * @param CreCrsVO
     * @return String
     * @throws Exception
     */
    public String checkPrevCourseYn(String crsCreCd) throws Exception;
    
    /**
     * 선수강과목 이전학기 자료 이관
     * @param CreCrsVO
     * @return int
     * @throws Exception
     */
    public int transPrevTermCorsData(CreCrsVO vo) throws Exception;
    
    /**
     * JLPT과목 학기 이관
     * @param CreCrsVO
     * @return int
     * @throws Exception
     */
    public int transJlptCorsData(CreCrsVO vo) throws Exception;
    
    /**
     * 사용자 학기별 대학구분 조회 
     * @param CreCrsVO
     * @return List
     * @throws Exception
     */
    public List<EgovMap> listUserUnivGbn(HttpServletRequest request, CreCrsVO vo) throws Exception;
    
    /**
     * 수강중인 학번 수 조회
     * @param CreCrsVO
     * @return int
     * @throws Exception
     */
    public int countStdUserId(CreCrsVO vo) throws Exception;
    
    /**
     * 개설 과목 조회 (학위연도, 기관, 학기기수, 학과 기준)
     * @param SubjectVO
     * @return List<SubjectVO>
     * @throws Exception
     */
    public List<EgovMap> listSbjctOfrng (SubjectVO sbjctOfrngVO)throws Exception;
}