package knou.lms.std2.dao;


import knou.lms.std2.vo.AtndlcVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("stdInfoDAO")
public interface StdInfoDAO {
    List<EgovMap> stdInfoListPaging(AtndlcVO atndlcVO) throws Exception;

    List<EgovMap> stdInfoExcelList(AtndlcVO vo) throws Exception;
}
