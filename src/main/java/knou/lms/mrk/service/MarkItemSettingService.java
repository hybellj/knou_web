package knou.lms.mrk.service;

import knou.lms.mrk.vo.MarkItemSettingVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

public interface MarkItemSettingService {
    List<EgovMap> mrkItmStngList(MarkItemSettingVO vo) throws Exception;
}
