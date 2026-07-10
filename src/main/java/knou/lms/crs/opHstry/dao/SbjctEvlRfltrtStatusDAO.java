package knou.lms.crs.opHstry.dao;

import knou.lms.crs.opHstry.vo.SbjctEvlRfltrtStatusVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("sbjctEvlRfltrtStatusDAO")
public interface SbjctEvlRfltrtStatusDAO {
    List<EgovMap> listSbjctEvlRfltrtStatus(SbjctEvlRfltrtStatusVO vo);
}