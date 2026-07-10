package knou.lms.login.dao;

import knou.lms.login.vo.UserLgnHstryPageInfoVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("userLgnHstryDAO")
public interface UserLgnHstryDAO {

    int countUserLgnHstry(UserLgnHstryPageInfoVO vo);

    List<EgovMap> listUserLgnHstryPaging(UserLgnHstryPageInfoVO vo);

    List<EgovMap> listUserLgnHstry(UserLgnHstryPageInfoVO vo);
}
