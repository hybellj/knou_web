package knou.lms.crs.crecrs.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.crs.crecrs.vo.CreCrsTchRltnVO;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.crs.crecrs.vo.HpIntchVO;
import knou.lms.subject.vo.SubjectVO;
import knou.lms.user.vo.UsrUserInfoVO;

@Mapper("crecrsDAO")
public interface CrecrsDAO {
    
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
     * @return List<CreCrsVO>
     * @throws Exception
     */
    public List<CreCrsVO> listPaging(CreCrsVO vo) throws Exception;
    
    /**
     * 강의실 드롭다운 목록
     * @param CreCrsVO
     * @return List<CreCrsVO>
     * @throws Exception
     */
    public List<CreCrsVO> listCrsCreDropdown(CreCrsVO vo) throws Exception;

    public int selectStdCreCrsListTotCnt(CreCrsVO vo) throws Exception;

    public List<CreCrsVO> selectStdCreCrsList(CreCrsVO vo) throws Exception;

    public List<CreCrsVO> listTchCrsCreByTerm(CreCrsVO vo) throws Exception;

    public CreCrsVO selectCreCrs(CreCrsVO vo) throws Exception;
    
    public CreCrsVO infoCreCrs(CreCrsVO vo) throws Exception;

    public List<CreCrsVO> listCreCrsDeclsNo(CreCrsVO vo) throws Exception;

    public List<CreCrsVO> listCrsCreByTerm(CreCrsVO vo) throws Exception;

    public CreCrsVO selectTchCreCrs(CreCrsVO vo) throws Exception;

    /**
     * 개설 과정 전체 목록을 조회한다 : 과정 단위에서 구성
     * @param CreCrsVO
     * @throws Exception
     */
    public List<CreCrsVO> creCrsTchJoinList(CreCrsVO vo) throws Exception;
    
    // public void update(CreCrsVO vo) throws Exception;
    
    /**
     * 학생 > 메인 > 마이페이지 리스트
     * @param CreCrsVO
     * @return List<CreCrsVO>
     * @throws Exception
     */
    public List<CreCrsVO> listMainMypageStd(CreCrsVO vo) throws Exception;

   /**
     * 메인 > 교수 > 마이페이지 리스트
     * @param CreCrsVO
     * @return List<CreCrsVO>
     * @throws Exception
     */
    public List<CreCrsVO> listMainMypageTch(CreCrsVO vo) throws Exception;
    
    /**
     * 교수 > 마이페이지 리스트
     * @param CreCrsVO
     * @return List<CreCrsVO>
     * @throws Exception
     */
    public List<CreCrsVO> creMypageTchList(CreCrsVO vo) throws Exception;
    
    /**
     * 학생 > 마이페이지 리스트
     * @param CreCrsVO
     * @return List<CreCrsVO>
     * @throws Exception
     */
    public List<CreCrsVO> creMypageStdList(CreCrsVO vo) throws Exception;
    
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
     * @return List<CreCrsTchRltnVO>
     * @throws Exception
     */
    public List<CreCrsTchRltnVO> listCrecrsTchByMenuType(CreCrsTchRltnVO vo) throws Exception;
    
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
     * @return List<CreCrsVO>
     * @throws Exception
     */
    public List<CreCrsVO> listCrecrsByUserDept(CreCrsVO vo) throws Exception;
    
    /**
     * 사용자 관리 > 사용자 상세 강의(수강) 과목 리스트
     * @param CreCrsVO
     * @return List<CreCrsVO>
     * @throws Exception
     */
    public List<CreCrsVO> listUserCreCrsPaging(CreCrsVO vo) throws Exception;
    
    /**
     * 교수/조교 관리 > 개설과목 리스트
     * @param CreCrsVO
     * @return List<CreCrsVO>
     * @throws Exception
     */
    public List<CreCrsVO> listCreCrs(CreCrsVO vo) throws Exception;
    
    /**
     * 교수/조교 정보 > 교수/조교 목록
     * @param CreCrsVO
     * @return List<CreCrsVO>
     * @throws Exception
     */
    public List<CreCrsVO> listTchStatus(CreCrsVO vo) throws Exception;
    
    /**
     * 강의실 상단 정보
     * @param CreCrsVO
     * @return CreCrsVO
     * @throws Exception
     */
    public CreCrsVO crsCreTopInfo(CreCrsVO vo) throws Exception;

    public List<CreCrsVO> selectListPage(CreCrsVO vo) throws Exception;

    public CreCrsVO selectCrsCre(CreCrsVO vo) throws Exception;

    public void insert(CreCrsVO vo) throws Exception;

    public void updateEvalInfo(CreCrsVO vo) throws Exception;

    public void insertCreCrsPltn(CreCrsVO vo) throws Exception;
    
    public List<CreCrsVO> listCreCrsDeclsNoByTch(CreCrsVO vo) throws Exception;

    /**
     * 분반 중복 체크.
     * @param CreCrsVO
     * @return CreCrsVO
     * @throws Exception
     */
    public CreCrsVO checkDeclsNo(CreCrsVO vo) throws Exception;
    
    public int checkDeclsCnt(CreCrsVO vo) throws Exception;
    
    public List<CreCrsVO> selectListCreTch(CreCrsVO vo) throws Exception;

    public CreCrsVO selectTch(CreCrsVO vo) throws Exception;

    public void insertTch(CreCrsVO vo) throws Exception;

    public void deleteTch(CreCrsVO vo) throws Exception;

    public List<UsrUserInfoVO> selectUsrTchList(UsrUserInfoVO vo) throws Exception;

    public void deleteCreCrsEval(CreCrsVO vo) throws Exception;

    public void deleteCreCrsRltn(CreCrsVO vo) throws Exception;

    public void deleteCreCrs(CreCrsVO vo) throws Exception;

    public List<CreCrsVO> coListPageing(CreCrsVO vo) throws Exception;

    public int updateUseYn(CreCrsVO vo) throws Exception;
    
    public List<EgovMap> listCrecrsTchEgov(CreCrsVO vo) throws Exception;
    
    public List<CreCrsVO> listCurrentTermCrecrsByTch(CreCrsVO vo) throws Exception;
    
    /**
     *  개설과목관리 > 등록된 운영자 정보 리스트
     * @param CreCrsVO
     * @return ProcessResultVO
     * @throws Exception
     */
    public List<CreCrsVO> listCreTch(CreCrsVO vo) throws Exception;
    
    /**
     * 개설 과목 전체 count(대학).
     * @param sysTypeCd 
     * @param CreCrsVO
     * @return int
     * @throws Exception
     */
    public int countUni(CreCrsVO vo) throws Exception;
    
    /**
     * 개설 과목 목록.
     * @param CreCrsVO
     * @return List
     * @throws Exception
     */
    public List<CreCrsVO> listPageing(CreCrsVO vo) throws Exception;
    
    /**
     * 개설 과목 한개  수정.
     * @param CreCrsVO
     * @return void
     * @throws Exception
     */
    public void update(CreCrsVO vo) throws Exception;
    
    /**
     * 개설 과목 릴레이션 테이블 등록.
     * @param CreCrsVO
     * @return void
     * @throws Exception
     */
    public void insertCreCrsRltn(CreCrsVO vo) throws Exception;
    
    /**
     * 개설과목관리 > 수강생 관리 > 수강생 추가 목록 count
     * @param CreCrsVO
     * @return void
     * @throws Exception
     */
    public int countCreUser(CreCrsVO vo) throws Exception;

    /**
     * 개설과목관리 > 수강생 관리 > 수강생 추가 목록 listPageing
     * @param CreCrsVO
     * @return void
     * @throws Exception
     */
    public List<CreCrsVO> creUserlistPageing(CreCrsVO vo) throws Exception;
    
    /**
     * 개설 과목 목록 (기수제)
     * @param CreCrsVO
     * @return List
     * @throws Exception
     */
    public List<CreCrsVO> coList(CreCrsVO vo) throws Exception;
    
    /**
     * 개설과목 관리 목록 수
     * @param CreCrsVO
     * @return List
     * @throws Exception
     */
    public int countManageCourse(CreCrsVO vo) throws Exception;
    
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
     * @return List
     * @throws Exception
     */
    public List<CreCrsVO> listPagingManageCourse(CreCrsVO vo) throws Exception;
    
    /**
     * 권한별 학기 개설과목 목록
     * @param CreCrsVO
     * @return List
     * @throws Exception
     */
    public List<CreCrsVO> listAuthCrsCreByTerm(CreCrsVO vo) throws Exception;
    
    /**
     * 학점교류과목 목록
     * @return List<HpIntchVO>
     * @throws Exception
     */
    public List<HpIntchVO> listHpIntch(HpIntchVO vo) throws Exception;
    
    /**
     * 이전과목 가져오기 항목 목록
     * @param CreCrsVO
     * @return EgovMap
     * @throws Exception
     */
    public EgovMap selectPrevCourseItem(CreCrsVO vo) throws Exception;
 
   /**
    * 선수강과목 이관상태 업데이트
    * @param CreCrsVO
    * @return 
    * @throws Exception
    */
   public void updateTmswPreTransState(CreCrsVO vo) throws Exception;
   
   /**
    * 과목 학기 수정(이관용)
    * @param CreCrsVO
    * @return 
    * @throws Exception
    */
   public void updateCreCrsTermForTrans(CreCrsVO vo) throws Exception;
   
   /**
    * 과목 학습활동 데이터 삭제(JLPT 과목 이관용)
    * @param CreCrsVO
    * @return 
    * @throws Exception
    */
   public void deleteCreCrsDataForTrans(CreCrsVO vo) throws Exception;
   
   /**
    * 운영중인 대학구분 목록 조회
    * @param CreCrsVO
    * @return List
    * @throws Exception
    */
   public List<EgovMap> listProfUnivGbn(CreCrsVO vo) throws Exception;
   
   /**
    * 수강중인 대학구분 목록 조회
    * @param CreCrsVO
    * @return List
    * @throws Exception
    */
   public List<EgovMap> listStdUnivGbn(CreCrsVO vo) throws Exception;
   
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
   public List<EgovMap> listSbjctOfring(SubjectVO sbjctOfrngVO) throws Exception;
}
