package knou.lms.user.service;

import java.util.List;
import java.util.Map;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.user.vo.UsrDeptCdVO;

public interface UsrDeptCdService {

    /*****************************************************
     * 학과(부서) 정보 조회
     * @param UsrDeptCdVO
     * @return UsrDeptCdVO
     * @throws Exception
     ******************************************************/
    public UsrDeptCdVO select(UsrDeptCdVO vo) throws Exception;
    
    /*****************************************************
     * 학과(부서) 목록 조회
     * @param UsrDeptCdVO
     * @return List<UsrDeptCdVO>
     * @throws Exception
     ******************************************************/
    public List<UsrDeptCdVO> list(UsrDeptCdVO vo) throws Exception;
    
    /*****************************************************
     * 학과(부서) 목록
     * @param UsrDeptCdVO
     * @return List<UsrDeptCdVO>
     * @throws Exception
     ******************************************************/
    public List<UsrDeptCdVO> listDept(UsrDeptCdVO vo) throws Exception;
    
    public ProcessResultVO<UsrDeptCdVO> listPaging(UsrDeptCdVO vo) throws Exception;
    
    /*****************************************************
     * 학과(부서) 등록
     * @param UsrDeptCdVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insert(UsrDeptCdVO vo) throws Exception;
    
    /*****************************************************
     * 학과(부서) 수정
     * @param UsrDeptCdVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void update(UsrDeptCdVO vo) throws Exception;
    public int editUseYn(UsrDeptCdVO vo) throws Exception;
    
    /*****************************************************
     * 학과(부서) 삭제
     * @param UsrDeptCdVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void delete(UsrDeptCdVO vo) throws Exception;
    
    /*****************************************************
     * 학과관리 엑셀 업로드 정보를 등록 한다.
     * @param UsrDeptCdVO
     * @return void
     * @throws Exception
     ******************************************************/
    public abstract void addExcelManageDept(UsrDeptCdVO vo, List<Map<String, Object>> excelList) throws Exception;
    
    /*****************************************************
     * 학과(부서) 목록 조회 (학기별 수강생의 부서)
     * @param UsrDeptCdVO
     * @return List<UsrDeptCdVO>
     * @throws Exception
     ******************************************************/
    public List<UsrDeptCdVO> listDeptByStdHaksaTerm(UsrDeptCdVO vo) throws Exception;
}
