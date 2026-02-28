package knou.lms.user.service.impl;

import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.framework.exception.ServiceProcessException;
import knou.framework.util.StringUtil;
import knou.lms.common.paging.PagingInfo;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.user.dao.UsrDeptCdDAO;
import knou.lms.user.service.UsrDeptCdService;
import knou.lms.user.vo.UsrDeptCdVO;

@Service("usrDeptCdService")
public class UsrDeptCdServiceImpl extends ServiceBase implements UsrDeptCdService {

    @Resource(name="usrDeptCdDAO")
    private UsrDeptCdDAO usrDeptCdDAO;

    /*****************************************************
     * <p>
     * 학과(부서) 정보 조회
     * </p>
     * 학과(부서) 정보 조회
     *
     * @param UsrDeptCdVO
     * @return UsrDeptCdVO
     * @throws Exception
     ******************************************************/
    @Override
    public UsrDeptCdVO select(UsrDeptCdVO vo) throws Exception {
        return usrDeptCdDAO.select(vo);
    }

    /*****************************************************
     * <p>
     * 학과(부서) 목록 조회
     * </p>
     * 학과(부서) 목록 조회
     *
     * @param UsrDeptCdVO
     * @return List<UsrDeptCdVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<UsrDeptCdVO> list(UsrDeptCdVO vo) throws Exception {
        return usrDeptCdDAO.list(vo);
    }

    /*****************************************************
     * <p>
     * 학과(부서) 등록
     * </p>
     * 학과(부서) 등록
     *
     * @param UsrDeptCdVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void insert(UsrDeptCdVO vo) throws Exception {
        usrDeptCdDAO.insert(vo);
    }

    /*****************************************************
     * <p>
     * 학과(부서) 수정
     * </p>
     * 학과(부서) 수정
     *
     * @param UsrDeptCdVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void update(UsrDeptCdVO vo) throws Exception {
        usrDeptCdDAO.update(vo);
    }

    /*****************************************************
     * <p>
     * 학과(부서) 삭제
     * </p>
     * 학과(부서) 삭제
     *
     * @param UsrDeptCdVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void delete(UsrDeptCdVO vo) throws Exception {
        usrDeptCdDAO.delete(vo);
    }

    /*****************************************************
     * <p>
     * 학과관리 엑셀 업로드 정보를 등록 한다.
     * </p>
     * 학과관리 엑셀 업로드 정보를 등록 한다.
     *
     * @param UsrDeptCdVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void addExcelManageDept(UsrDeptCdVO vo, List<Map<String, Object>> excelList) throws Exception {
        int line = 4;  // 샘플 엑셀파일 row 시작위치
        String errPrefix;
        
        UsrDeptCdVO usrDeptCdVO;    
        String deptCd;              // 부서 코드           - 필수입력, 중복체크
        String parDeptCd;           // 상위 부서 코드    - 필수입력, 유효한 코드인지 확인
        String deptNm;              // 부서명               - 필수입력
        String deptNmEn;            // 부서명 영문
        
        // 상위코드값 체크를 위해 조회
        UsrDeptCdVO uDeptCdVO = new UsrDeptCdVO();
        uDeptCdVO.setOrgId(vo.getOrgId());
        
        List<UsrDeptCdVO> deptList = usrDeptCdDAO.list(vo);  // 존재하는 코드인지 체크
        
        // 전체 코드 (이전 코드값 + 추가될 코드값들)
        Set<String> deptCdSet = new HashSet<>();
        // 중복 코드 체크
        Set<String> deptCdDupChkSet = new HashSet<>();
        
        // 이전 코드값
        for(UsrDeptCdVO usrDeptInfo : deptList) {
            deptCdSet.add(usrDeptInfo.getDeptId());
            deptCdDupChkSet.add(usrDeptInfo.getDeptId());
        }
        // 추가될 코드값
        for(Map<String, Object> usrDeptMap : excelList) {
            deptCd = (String) usrDeptMap.get("A");
            deptCdSet.add(deptCd);
        }
        
        for(Map<String, Object> usrDeptMap : excelList) {
            errPrefix = line + "번 행의";
            
            usrDeptCdVO = new UsrDeptCdVO();
            usrDeptCdVO.setOrgId(vo.getOrgId());
            usrDeptCdVO.setMdfrId(vo.getRgtrId());
            usrDeptCdVO.setRgtrId(vo.getRgtrId());
            
            deptCd      = (String) usrDeptMap.get("A");
            parDeptCd   = (String) usrDeptMap.get("B");
            deptNm      = (String) usrDeptMap.get("C");
            deptNmEn    = (String) usrDeptMap.get("D");
            
            // 공백 체크
            if("".equals(StringUtil.nvl(deptCd)) || "".equals(StringUtil.nvl(parDeptCd)) || "".equals(StringUtil.nvl(deptNm))) {
                String requiredMsg = "(은)는 필수입력항목입니다.";
                String errMsg = "";
                
                // 학과코드
                if("".equals(StringUtil.nvl(deptCd))) {
                    errMsg = "학과 코드" + requiredMsg;
                } 
                // 상위 학과 코드
                else if ("".equals(StringUtil.nvl(parDeptCd))) {
                    errMsg = "상위 학과 코드" + requiredMsg;
                } 
                // 학과명
                else if ("".equals(StringUtil.nvl(deptNm))) {
                    errMsg = "학과명" + requiredMsg;
                }
                
                throw new ServiceProcessException(errPrefix + errMsg);
            }
            
            // 유효한 상위코드 체크 (ROOT는 체크 제외)
            if(!"ROOT".equals(parDeptCd) && !deptCdSet.contains(parDeptCd)) {
                // [parDeptCd] 유효한 상위코드가 아닙니다.
                throw new ServiceProcessException(errPrefix + "[" + parDeptCd + "] (은)는 유효한 상위코드가 아닙니다.");
            }
            
            usrDeptCdVO.setDeptId(deptCd);
            usrDeptCdVO.setUpDeptId(parDeptCd);
            usrDeptCdVO.setDeptnm(deptNm);
            usrDeptCdVO.setDeptEnnm(deptNmEn);
            
            // 중복 일경우 덮어쓰기
            if(deptCdDupChkSet.contains(deptCd)) {
                usrDeptCdVO.setSearchValue(deptCd); // 맵퍼에서 searchValue 값을 넣고 있음
                usrDeptCdDAO.update(usrDeptCdVO);
            } else {
                usrDeptCdDAO.insert(usrDeptCdVO);
                
                // 중복 체크를 위한 코드 값 추가
                deptCdDupChkSet.add(deptCd);
            }
            line++;
        }
    }

    @Override
    public ProcessResultVO<UsrDeptCdVO> listPaging(UsrDeptCdVO vo) throws Exception {
        ProcessResultVO<UsrDeptCdVO> resultList = new ProcessResultVO<>(); 
        try {
            /** start of paging */
            PagingInfo paginationInfo = new PagingInfo();
            paginationInfo.setCurrentPageNo(vo.getPageIndex());
            paginationInfo.setRecordCountPerPage(vo.getListScale());
            paginationInfo.setPageSize(vo.getPageScale());
            
            vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
            vo.setLastIndex(paginationInfo.getLastRecordIndex());
            
            // 전체 목록 수
            int totalCount = usrDeptCdDAO.count(vo);
            paginationInfo.setTotalRecordCount(totalCount);
            
            List<UsrDeptCdVO> deptInfoList =  usrDeptCdDAO.listPageing(vo);
            resultList.setResult(1);
            resultList.setReturnList(deptInfoList);
            resultList.setPageInfo(paginationInfo);
            
        } catch (Exception e) {
            e.printStackTrace();
            resultList.setResult(-1);
            resultList.setMessage(e.getMessage());
        }
        return resultList;
    }

    @Override
    public List<UsrDeptCdVO> listDept(UsrDeptCdVO vo) throws Exception {
        return usrDeptCdDAO.list(vo);
    }
    
    @Override
    public int editUseYn(UsrDeptCdVO vo) throws Exception {
        return usrDeptCdDAO.updateUseYn(vo);
    }
    
    /*****************************************************
     * 학과(부서) 목록 조회 (학기별 수강생의 부서)
     * @param UsrDeptCdVO
     * @return List<UsrDeptCdVO>
     * @throws Exception
     ******************************************************/
    public List<UsrDeptCdVO> listDeptByStdHaksaTerm(UsrDeptCdVO vo) throws Exception {
        return usrDeptCdDAO.listDeptByStdHaksaTerm(vo);
    }
}
