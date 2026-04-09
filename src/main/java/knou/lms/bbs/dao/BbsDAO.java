package knou.lms.bbs.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.lms.bbs2.vo.Bbs2AtclVO;

@Mapper("bbsDAO")
public interface BbsDAO {

	public EgovMap bbsIdWithBbsAuthrtSelect(@Param("bbsId") String bbsId, @Param("userId") String userId) throws Exception ;

	public List<Bbs2AtclVO> atclSelect(String bbsId) throws Exception ;

}
