package knou.lms.mrk.service.impl;

import knou.lms.mrk.dao.MarkItemSettingDAO;
import knou.lms.mrk.service.MarkItemSettingService;
import knou.lms.mrk.vo.MarkItemSettingVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service("markItemSettingService")
public class MarkItemSettingServiceImpl implements MarkItemSettingService {

    @Resource(name="markItemSettingDAO")
    private MarkItemSettingDAO markItemSettingDAO;

    @Override
    public List<EgovMap> mrkItmStngList(MarkItemSettingVO vo) throws Exception {
        return markItemSettingDAO.mrkItmStngList(vo);
    }
}
