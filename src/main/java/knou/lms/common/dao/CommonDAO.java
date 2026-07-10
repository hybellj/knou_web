package knou.lms.common.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import knou.framework.common.PageInfo;

@Mapper("commonDAO")
public interface CommonDAO {
	
	public List<EgovMap> yrSmstrSelect(PageInfo pageInfo);
	
	public List<EgovMap> yrSmstrOnlySelect(PageInfo pageInfo);
}