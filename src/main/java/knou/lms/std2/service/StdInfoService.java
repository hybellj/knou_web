package knou.lms.std2.service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.std2.vo.AtndlcVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

public interface StdInfoService {
    ProcessResultVO<EgovMap> stdInfoListPaging(AtndlcVO atndlcVO) throws Exception;

    List<EgovMap> profStdInfoExcelList(AtndlcVO vo) throws Exception;
}
