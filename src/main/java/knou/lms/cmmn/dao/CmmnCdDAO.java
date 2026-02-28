package knou.lms.cmmn.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.cmmn.vo.CmmnCdVO;

@Mapper("cmmnCdDAO")
public interface CmmnCdDAO {

	public List<CmmnCdVO> selectCmmnCdList(CmmnCdVO cmmnCdVO) throws Exception;

	public CmmnCdVO select(CmmnCdVO vo) throws Exception;

    /**
     * 코드 분류 하위의 코드 정보 전체를 상세 정보를 삭제한다.  
     * @param  MsgMgrVO
     * @return int
     * @throws Exception
     */
    public int deleteAll(CmmnCdVO vo) throws Exception;
    
    /**
     * 코드 정보의 검색된 수를 카운트 한다. 
     * @param  MsgMgrVO 
     * @return int
     * @throws Exception
     */
    public int count(CmmnCdVO vo) throws Exception;
    
    /**
     * 코드 정보의 전체 목록을 조회한다. 
     * @param  MsgMgrVO 
     * @return List
     * @throws Exception
     */
    public List<CmmnCdVO> listPageing(CmmnCdVO vo) throws Exception;
    
    public String selectKey(CmmnCdVO vo) throws Exception;

    /**
     * 코드 정보의 상세 정보를 등록한다.  
     * @param  MsgMgrVO
     * @return int
     * @throws Exception
     */
    public int insert(CmmnCdVO vo) throws Exception;
    
    /**
     * 코드 정보의 상세 정보를 수정한다. 
     * @param  MsgMgrVO
     * @return int
     * @throws Exception
     */
    public int update(CmmnCdVO vo) throws Exception;

    /**
     * 코드 정보의 상세 정보를 삭제한다.  
     * @param  MsgMgrVO
     * @return int
     * @throws Exception
     */
    public int delete(CmmnCdVO vo) throws Exception;
    
    public List<CmmnCdVO> list(CmmnCdVO cmmnCdVO) throws Exception;
}
