package knou.lms.user.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.user.vo.UsrDeptCdVO;

@Mapper("usrDeptCdDAO")
public interface UsrDeptCdDAO {

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
    public int updateUseYn(UsrDeptCdVO vo) throws Exception;
    
    /*****************************************************
     * 학과(부서) 삭제
     * @param UsrDeptCdVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void delete(UsrDeptCdVO vo) throws Exception;
    
    public int count(UsrDeptCdVO vo) throws Exception;
    
    public List<UsrDeptCdVO> listPageing(UsrDeptCdVO vo) throws Exception;
    
    /*****************************************************
     * 학과(부서) 목록 조회 (학기별 수강생의 부서)
     * @param UsrDeptCdVO
     * @return List<UsrDeptCdVO>
     * @throws Exception
     ******************************************************/
    public List<UsrDeptCdVO> listDeptByStdHaksaTerm(UsrDeptCdVO vo) throws Exception;

}
