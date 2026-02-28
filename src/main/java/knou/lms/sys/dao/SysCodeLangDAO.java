package knou.lms.sys.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.sys.vo.SysCodeLangVO;

@Mapper("sysCodeLangDAO")
public interface SysCodeLangDAO {

    /**
     * 코드 언어의 전체 목록을 조회한다. 
     * @param  SysCodeLangVO 
     * @return List
     * @throws Exception
     */
    @SuppressWarnings("unchecked")
    public List<SysCodeLangVO> list(SysCodeLangVO vo) throws Exception;
    
}
