package knou.framework.common;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

import java.lang.reflect.Method;
import java.util.List;

/**
 * 페이지 정보
 */
public class PageInfo extends PaginationInfo {
    private static Log log = LogFactory.getLog(PageInfo.class);

    /**
     * 페이지 정보 생성자
     *
     * @param voObj (VO 객체 전달)
     */
    public PageInfo(Object voObj) {
        super();

        try {
            if(voObj != null) {
                Method method = voObj.getClass().getMethod("getPageIndex");
                setCurrentPageNo((Integer) method.invoke(voObj));

                method = voObj.getClass().getMethod("getListScale");
                setRecordCountPerPage((Integer) method.invoke(voObj));

                method = voObj.getClass().getMethod("getPageScale");
                setPageSize((Integer) method.invoke(voObj));

                method = voObj.getClass().getMethod("setFirstIndex", int.class);
                method.invoke(voObj, (Integer) getFirstRecordIndex());

                method = voObj.getClass().getMethod("setLastIndex", int.class);
                method.invoke(voObj, (Integer) getLastRecordIndex());
            }
        } catch(Exception e) {
            log.error(e.getMessage());
        }
    }

    /**
     * 토탈 레코드 설정
     *
     * @param listObj (List<VO> 객체 전달)
     */
    public void setTotalRecord(Object listObj) {
        try {
            if(listObj != null && (listObj instanceof List)) {
                List<?> list = (List<?>) listObj;

                if(!list.isEmpty()) {
                    Object obj = list.get(0);

                    // EgovMap / Map 처리
                    if(obj instanceof java.util.Map) {
                        Object v = ((java.util.Map<?, ?>) obj).get("totalCnt");
                        if(v == null) v = ((java.util.Map<?, ?>) obj).get("TOTAL_CNT");

                        if(v instanceof Number) {
                            setTotalRecordCount(((Number) v).intValue());
                        } else if(v != null) {
                            setTotalRecordCount(Integer.parseInt(String.valueOf(v)));
                        }
                        return;
                    }

                    // VO 처리
                    Method method = obj.getClass().getMethod("getTotalCnt");
                    setTotalRecordCount((Integer) method.invoke(obj));
                }
            }
        } catch(Exception e) {
            log.error(e.getMessage());
        }
    }
}
