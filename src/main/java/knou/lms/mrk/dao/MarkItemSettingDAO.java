package knou.lms.mrk.dao;

import knou.lms.mrk.vo.MarkItemSettingVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("markItemSettingDAO")
public interface MarkItemSettingDAO {
    List<EgovMap> mrkItmStngList(MarkItemSettingVO vo) throws Exception;

    int mrkItmStngForProfModify(MarkItemSettingVO vo) throws Exception;

}
