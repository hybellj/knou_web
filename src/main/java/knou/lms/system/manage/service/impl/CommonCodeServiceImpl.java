package knou.lms.system.manage.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import knou.framework.common.PageInfo;
import knou.framework.exception.MediopiaDefineException;
import knou.lms.common.dto.ResultDTO;
import knou.lms.system.manage.dao.CommonCodeDAO;
import knou.lms.system.manage.service.CommonCodeService;
import knou.lms.system.manage.vo.CommonCodeVO;

//	asis는 sysCmmnCdService 였다.

@Service("commonCodeService")
public class CommonCodeServiceImpl extends EgovAbstractServiceImpl implements CommonCodeService {

    private static final Logger LOGGER = LoggerFactory.getLogger(CommonCodeServiceImpl.class);

    @Resource(name="commonCodeDAO")
    private CommonCodeDAO commonCodeDAO;

    /*****************************************************
     * 관리자상위공통코드등록
     * @param 	vo
     * @return 	int
     ******************************************************/
    @Override
    public int admUpCmmnCdRegist(CommonCodeVO vo) {
        return commonCodeDAO.admUpCmmnCdRegist(vo);
    }
    
    /*****************************************************
     * 관리자상위공통코드수정
     * @param 	vo
     * @return 	int
     ******************************************************/
    @Override
    public int admUpCmmnCdModify(CommonCodeVO vo) {
    	
    	// 상위 수정 시도
        int result = commonCodeDAO.admUpCmmnCdModify(vo);
        
        // 상위 수정이 성공(1건 이상)했다면 하위도 수정
        if (result > 0 ) {
            commonCodeDAO.admCmmnCdModify(vo); 
        }
        
        return result; 
    }

    /*****************************************************
     * 관리자상위공통코드삭제
     * @param 	vo
     * @return 	int
     ******************************************************/
    @Override
    public int admUpCmmnCdDelete(CommonCodeVO vo) {
    	
    	// 1. 하위 코드 개수 조회
        int totCnt = commonCodeDAO.admCmmnCdCntChild(vo);
        
        // 삭제 처리 건수를 담을 변수
        int resultCnt = 0;
        
        // 삭제 전 상위 코드의 하위 코드가 사용중이면 삭제가 불가능함
        if (totCnt == 0) {
            // [수정] 하위 상세 코드를 먼저 일괄 삭제 (메서드명 확인 필요)
            commonCodeDAO.admCmmnCdDelete(vo); 
            
            // 상위 공통 코드를 최종 삭제하고 결과 건수(1)를 받음
            resultCnt = commonCodeDAO.admUpCmmnCdDelete(vo);
            
        } else {
            // 커스텀 예외 발생 (이 예외가 터지면 컨트롤러나 공통 에러 핸들러로 전달됨)
            throw new MediopiaDefineException("사용중인 하위 코드가 존재하여 삭제할 수 없습니다.");
        }
        
        // 2. [수정] 최종 삭제 성공 건수(resultCnt)를 반환하여 컴파일 에러 해결
        return resultCnt;
    }

    /*****************************************************
     * 관리자상위공통코드목록페이징
     * @param 	vo
     * @return 	List<EgovMap>
     ******************************************************/
    @Override
    public ResultDTO<EgovMap> admUpCmmnCdListPaging(PageInfo pageInfo) {
    	
    	pageInfo.setUpCdSelect(true);
    	
    	ResultDTO<EgovMap> resultVO = new ResultDTO<>();
		
		resultVO.getPageInfo().setTotalRecordCount(commonCodeDAO.admUpCmmnCdCnt(pageInfo));	//	관리자상위공통코드수조회 
		
        resultVO.setReturnList( commonCodeDAO.admUpCmmnCdListPaging(pageInfo)); 	//	관리자상위공통코드목록페이징
        
        return resultVO;
    }
    
    /*
     * 공통코드조회
     */
    @Override
    public ResultDTO<EgovMap> childCdList(String upCd)  {        
        return new ResultDTO<EgovMap>().setReturnList(commonCodeDAO.childCdList(upCd) );
    }    

    /*****************************************************
     * 관리자공통코드등록
     * @param 	vo
     * @return 	int
     ******************************************************/
    @Override
    public int admCmmnCdRegist(CommonCodeVO vo){
        return commonCodeDAO.admCmmnCdRegist(vo);
    }

    /*****************************************************
     * 관리자공통코드목록조회페이징
     * @param 	vo
     * @return 	List<EgovMap>
     ******************************************************/
    @Override
    public ResultDTO<EgovMap> admCmmnCdListPaging(PageInfo pageInfo) {
    	
    	pageInfo.setUpCdSelect(false);
    	pageInfo.setUpCdDelete(false);
    	
        ResultDTO<EgovMap> resultDto = new ResultDTO<EgovMap>();
		
		resultDto.getPageInfo().setTotalRecordCount(commonCodeDAO.admCmmnCdCnt(pageInfo));	//	관리자공통코드수조회 
		
        resultDto.setReturnList( commonCodeDAO.admCmmnCdListPaging(pageInfo)); 	//	관리자상위코드목록페이징
        
        return resultDto;
    }

    /*****************************************************
     * 관리자공통코드목록조회
     * @param 	vo
     * @return 	List<EgovMap>
     ******************************************************/
    @Override
    public List<EgovMap> admCmmnCdList(PageInfo pageInfo) {
        return commonCodeDAO.admCmmnCdList(pageInfo);
    }
    
    /*****************************************************
     * 관리자공통코드목록조회
     * @param 	vo
     * @return 	List<EgovMap>
     ******************************************************/
    @Override
    public List<EgovMap> admCmmnCdListASIS(CommonCodeVO vo) {
        return commonCodeDAO.admCmmnCdListASIS(vo);
    }

    /*****************************************************
     * 관리자공통코드수정
     * @param 	vo
     * @return 	int
     ******************************************************/
    @Override
    public int admCmmnCdModify(CommonCodeVO vo){
        return commonCodeDAO.admCmmnCdModify(vo);
    }

    /*****************************************************
     *	관리자공통코드삭제
     * @param 	vo
     * @return 	int
     ******************************************************/
    @Override
    public int admCmmnCdDelete(CommonCodeVO vo){
        return commonCodeDAO.admCmmnCdDelete(vo);
    }    
    
    // 관리자접속허용아이피목록조회페이징
    @Override
	public ResultDTO<EgovMap> admCntnPermitIpListPaging(PageInfo pageInfo) {
    	
    	ResultDTO<EgovMap> resultDto = new ResultDTO<EgovMap>( pageInfo );
		
    	resultDto.getPageInfo().setTotalRecordCount( commonCodeDAO.admCntnPermitIpCnt( (PageInfo) pageInfo) );
		
    	resultDto.setReturnList( commonCodeDAO.admCntnPermitIpListPaging( (PageInfo) pageInfo ) );  

        return resultDto;
	}

    /*****************************************************
     * 시스템 공통코드 전체 목록 조회
     * @return 	List<CommonCodeVO>
     ******************************************************/
    @Override
    public List<CommonCodeVO> selectSysCmmnCdAll(){
    	return commonCodeDAO.selectSysCmmnCdAll();
    }
}