package knou.lms.user.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import knou.lms.common.vo.OrgAuthGrpVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.user.vo.UsrDeptCdVO;
import knou.lms.user.vo.UsrUserInfoChgHstyVO;
import knou.lms.user.vo.UsrUserInfoVO;

public interface UsrUserInfoService {
    
    /**
     * 사용자 정보를 가져온다. 로그인시에 사용
     * - 사용자 상태가 U인 사용자만 가져온다.
     * - 입력한 패스워드를 암호화 하여 리턴한다.
     * @param UsrUserInfoVO vo
     * @return  ProcessResultDTO
     */
    public abstract UsrUserInfoVO viewForLogin(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 사용자 정보를 가져온다. 로그인시에 사용
     * - 사용자 상태가 U인 사용자만 가져온다.
     * - 입력한 패스워드를 암호화 하여 리턴한다.
     * @param UsrUserInfoVO vo
     * @return  ProcessResultDTO
     */
    public abstract UsrUserInfoVO viewForLoginCheck(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 사용자 페이징 목록
     * @param  UsrUserInfoVO 
     * @return ProcessResultVO<UsrUserInfoVO>
     * @throws Exception
     */
    public ProcessResultVO<UsrUserInfoVO> listPaging(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 사용자 정보 조회
     * @param  UsrUserInfoVO 
     * @return UsrUserInfoVO
     * @throws Exception
     */
    public UsrUserInfoVO viewUser(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 사용자 엑셀업로드 할떄 등록가능한 권한 목록
     * @param  OrgAuthGrpVO 
     * @return List<OrgAuthGrpVO>
     * @throws Exception
     */
    public List<OrgAuthGrpVO> listExcelUploadAuthGrp(OrgAuthGrpVO vo) throws Exception;
    
    /**
     * 사용자 정보 엑셀 업로드
     * @param  UsrUserInfoVO 
     * @return void
     * @throws Exception
     */
    public void userExcelUpload(HttpServletRequest request, UsrUserInfoVO vo, List<Map<String, Object>> list) throws Exception;
    
    /**
     * 사용자 정보 등록
     * @param  UsrUserInfoVO 
     * @return ProcessResultVO<UsrUserInfoVO>
     * @throws Exception
     */
    public ProcessResultVO<UsrUserInfoVO> addUserInfo(UsrUserInfoVO vo, String userInfoChgDivCd) throws Exception;
    
    /**
     * 사용자 정보 수정
     * @param  UsrUserInfoVO 
     * @return ProcessResultVO<UsrUserInfoVO>
     * @throws Exception
     */
    public ProcessResultVO<UsrUserInfoVO> editUserInfo(UsrUserInfoVO vo, String userInfoChgDivCd, String connIp) throws Exception;
    
    /**
     * 사용자 정보 변경 이력 페이징
     * @param  UsrUserInfoChgHstyVO 
     * @return ProcessResultVO<UsrUserInfoChgHstyVO>
     * @throws Exception
     */
    public ProcessResultVO<UsrUserInfoChgHstyVO> userChgHstyListPageing(UsrUserInfoChgHstyVO vo) throws Exception;
    
    /**
     * 수정된 사용자 정보 컬럼을 반환
     * @param  UsrUserInfoChgHstyVO 
     * @return List<UsrUserInfoChgHstyVO>
     * @throws Exception
     */
    public List<UsrUserInfoChgHstyVO> setChgTargetCode(List<UsrUserInfoChgHstyVO> voList, String orgId) throws Exception;
    
    /**
     * 사용자의 이름과 이메일로 사용자 정보 검색
     * @param  UsrUserInfoVO 
     * @return UsrUserInfoVO
     * @throws Exception
     */
    public UsrUserInfoVO searchUserId(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 사용자 목록 검색 ( 학생 )
     * @param  UsrUserInfoVO 
     * @return ProcessResultVO<UsrUserInfoVO>
     * @throws Exception
     */
    public ProcessResultVO<UsrUserInfoVO> listSearchByStudent(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 사용자 목록 검색 ( 교직원 )
     * @param  UsrUserInfoVO 
     * @return ProcessResultVO<UsrUserInfoVO>
     * @throws Exception
     */
    public ProcessResultVO<UsrUserInfoVO> listSearchByProfessor(UsrUserInfoVO vo) throws Exception;

    /**
     * 사용자 환경설정 수정
     * @param vo
     * @throws Exception
     */
    public void updateUserConf(UsrUserInfoVO vo) throws Exception;
    
    // 학과관리 사용여부
	public int editUseYn(UsrDeptCdVO vo) throws Exception;
	
	/**
     * 관리자 권한변경
     * @param vo 
     * @return 
     * @throws Exception
     */
    public void saveAdminAuthGrp(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 재학생 중 대학생 or 학부생 조회
     * @param  UsrUserInfoVO 
     * @return ProcessResultVO<UsrUserInfoVO>
     * @throws Exception
     */
    public ProcessResultVO<UsrUserInfoVO> listStudentByUniCd(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 사용자 수신정보 조회
     * @param  UsrUserInfoVO 
     * @return UsrUserInfoVO
     * @throws Exception
     */
    public UsrUserInfoVO selectUserRecvInfo(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 사용자 수신정보 목록 조회
     * @param  UsrUserInfoVO 
     * @return List<UsrUserInfoVO>
     * @throws Exception
     */
    public List<UsrUserInfoVO> listUserRecvInfo(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 임시 사용자(학생) 등록
     * @param UsrUserInfoVO vo
     */
    public void setTmpUser(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 메뉴 구분별 사용자 목록
     * @param vo
     * @return List<UsrUserInfoVO>
     * @throws Exception
     */
    public List<UsrUserInfoVO> listUserByMenuType(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 메뉴 구분별 사용자 목록 페이징
     * @param vo
     * @return ProcessResultVO<UsrUserInfoVO>
     * @throws Exception
     */
    public ProcessResultVO<UsrUserInfoVO> listPagingUserByMenuType(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 한사대 사용자 목록 검색(운영자,교수)
     * @param  UsrUserInfoVO 
     * @return List<UsrUserInfoVO>
     * @throws Exception
     */
    public List<UsrUserInfoVO> listSearchByKnouUser(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 기관사용자 한사대 사용자 연결 조회
     * @param  UsrUserInfoVO 
     * @param  UsrUserInfoVO
     * @throws Exception
     */
    public UsrUserInfoVO selectUserOrgRltn(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 기관사용자 한사대 사용자 연결 저장
     * @param  UsrUserInfoVO 
     * @throws Exception
     */
    public void insertUserOrgRltn(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 기관사용자 한사대 사용자 연결 수정
     * @param  UsrUserInfoVO 
     * @throws Exception
     */
    public void updateUserOrgRltn(UsrUserInfoVO vo) throws Exception;
    
    /**
     * 기관사용자 한사대 사용자 연결 조회 (by 한사대계정)
     * @param  UsrUserInfoVO 
     * @return List<UsrUserInfoVO>
     * @throws Exception
     */
    public List<UsrUserInfoVO> selectUserOrgRltnByKnouUser(UsrUserInfoVO vo) throws Exception;
}
