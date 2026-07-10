package knou.lms.login.service;

import knou.lms.common.dto.ResultDTO;
import knou.lms.login.vo.UserLgnHstryPageInfoVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

public interface UserLgnHstryService {

    ResultDTO<EgovMap> userLgnHstryList(UserLgnHstryPageInfoVO vo) throws Exception;

    List<EgovMap> userLgnHstryExcelList(UserLgnHstryPageInfoVO vo) throws Exception;
}
