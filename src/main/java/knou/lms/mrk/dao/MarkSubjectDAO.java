package knou.lms.mrk.dao;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("markSubjectDAO")
public interface MarkSubjectDAO {

    public List<EgovMap> stdMrkList(EgovMap searchMap)throws Exception;

    public int stdMrkListCntSelect(String sbjctId)throws Exception;
}
