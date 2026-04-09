package knou.lms.org.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.org.vo.OrgVO;

@Mapper("orgDAO")
public interface OrgDAO {

	public List<OrgVO> orgListSelect() throws Exception ;

}
