package knou.lms.sys.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.sys.vo.SysCodeVO;
import knou.lms.sys.vo.SysJobSchVO;

@Mapper("sysCodeDAO")
public interface SysCodeDAO {
    
    /**
     * 코드 정보의 전체 목록을 조회한다. 
     * @param  SysCodeVO 
     * @return List
     * @throws Exception
     */
    @SuppressWarnings("unchecked")
    public List<SysCodeVO> list(SysCodeVO vo) throws Exception;

    // 업무구분  목록
    public List<SysCodeVO> jobSchCalendarCtgrNmList(String orgId) throws Exception;

}
