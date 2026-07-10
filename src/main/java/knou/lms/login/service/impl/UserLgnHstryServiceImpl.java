package knou.lms.login.service.impl;

import knou.lms.common.dto.ResultDTO;
import knou.framework.util.DateTimeUtil;
import knou.lms.login.dao.UserLgnHstryDAO;
import knou.lms.login.service.UserLgnHstryService;
import knou.lms.login.vo.UserLgnHstryPageInfoVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service("userLgnHstryService")
public class UserLgnHstryServiceImpl implements UserLgnHstryService {

    @Resource(name = "userLgnHstryDAO")
    private UserLgnHstryDAO userLgnHstryDAO;

    /**
     * 사용자 로그인 이력 목록을 페이징 조회한다.
     */
    @Override
    public ResultDTO<EgovMap> userLgnHstryList(UserLgnHstryPageInfoVO vo) throws Exception {
        vo.normalizeSearchParams();

        ResultDTO<EgovMap> resultDTO = new ResultDTO<EgovMap>(vo);
        resultDTO.getPageInfo().setTotalRecordCount(userLgnHstryDAO.countUserLgnHstry(vo));
        resultDTO.setReturnList(userLgnHstryDAO.listUserLgnHstryPaging(vo));
        return resultDTO;
    }

    /**
     * 사용자 로그인 이력 엑셀 목록을 조회하고 출력용 값을 보정한다.
     */
    @Override
    public List<EgovMap> userLgnHstryExcelList(UserLgnHstryPageInfoVO vo) throws Exception {
        vo.normalizeSearchParams();
        List<EgovMap> list = userLgnHstryDAO.listUserLgnHstry(vo);
        for (int i = 0; i < list.size(); i++) {
            EgovMap item = list.get(i);
            item.put("no", list.size() - i);
            item.put("lgnDttm", formatDttm(item.get("lgnDttm")));
            item.put("lgtDttm", formatDttm(item.get("lgtDttm")));
            item.put("brwsrnm", getBrowserName(item.get("lgnCntnBrwsr")));
            item.put("certMthdnm", toStringValue(item.get("certMthdnm")));
        }
        return list;
    }

    /**
     * 로그인 일시를 엑셀 표시 형식으로 변환한다.
     */
    private String formatDttm(Object value) {
        String dttm = toStringValue(value);
        if (dttm.isEmpty()) {
            return "";
        }
        return DateTimeUtil.getDateType(8, dttm);
    }

    /**
     * User-Agent 문자열에서 브라우저 정보를 가져온다.
     */
    private String getBrowserName(Object value) {
        String userAgent = toStringValue(value);
        if (userAgent.isEmpty()) {
            return "";
        }
        if (userAgent.contains("Edg/")) {
            return "Edge";
        }
        if (userAgent.contains("Chrome/")) {
            return "Chrome";
        }
        if (userAgent.contains("Firefox/")) {
            return "Firefox";
        }
        if (userAgent.contains("Safari/")) {
            return "Safari";
        }
        return userAgent;
    }

    /**
     * null 값을 빈 문자열로 변환한다.
     */
    private String toStringValue(Object value) {
        return value == null ? "" : String.valueOf(value);
    }
}
