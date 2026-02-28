package knou.lms.log.privateinfo.dao;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.log.privateinfo.vo.PrivateInfoInqVO;

@Mapper("privateInfoInqDAO")
public interface PrivateInfoInqDAO {

    /**
     * 개인정보 조회 이력 정보를 저장하고 결과를 반환한다.
     * @param  PrivateInfoInqVO
     * @return void
     * @throws Exception
     */
    public void insert(PrivateInfoInqVO vo) throws Exception;
    
}
