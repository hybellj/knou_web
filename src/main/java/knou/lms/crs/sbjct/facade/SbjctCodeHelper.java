package knou.lms.crs.sbjct.facade;

import knou.lms.cmmn.service.CmmnCdService;
import knou.lms.cmmn.vo.CmmnCdVO;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * 과목 도메인 화면과 엑셀에서 사용하는 공통코드 조회 및 필터링 기능을 제공한다.
 */
@Component("sbjctCodeHelper")
public class SbjctCodeHelper {

    private static final String OPEN_CRS_GBNCD = "OPEN_CRS";
    private static final String OPEN_LCTR_SYSTEM_SBJCT_TYCD = "OPEN_LCTR_SYSTEM";

    @Resource(name="cmmnCdService")
    private CmmnCdService cmmnCdService;

    /**
     * 기본 선택 항목을 제외한 공통코드 목록을 조회한다.
     * @param orgId
     * @param upCd
     * @return
     * @throws Exception
     */
    public List<CmmnCdVO> listCodeWithoutDefault(String orgId, String upCd) throws Exception {
        return removeDefaultCode(cmmnCdService.listCode(null, upCd).getReturnList());
    }

    /**
     * 일반 과목개설 화면에 필요한 공통코드를 조회하고 일반 과목개설 코드 정책을 적용한다.
     * @param orgId
     * @param upCd
     * @return
     * @throws Exception
     */
    public List<CmmnCdVO> listSbjctOfringCode(String orgId, String upCd) throws Exception {
        return excludeOpenLctrOnlyCode(upCd, listCodeWithoutDefault(orgId, upCd));
    }

    /**
     * 공개강좌개설 화면에 필요한 공통코드를 조회하고 공개강좌개설 코드 정책을 적용한다.
     * @param orgId
     * @param upCd
     * @return
     * @throws Exception
     */
    public List<CmmnCdVO> listOpenLctrOfringCode(String orgId, String upCd) throws Exception {
        List<CmmnCdVO> codeList = listCodeWithoutDefault(orgId, upCd);
        if("CRS_GBNCD".equals(upCd)) {
            return filterByCode(codeList, OPEN_CRS_GBNCD);
        }
        if("SBJCT_TYCD".equals(upCd)) {
            return filterByCode(codeList, OPEN_LCTR_SYSTEM_SBJCT_TYCD);
        }
        return codeList;
    }

    /**
     * 공통코드 목록에서 기본 선택 항목을 제거한다.
     * @param codeList
     * @return
     */
    private List<CmmnCdVO> removeDefaultCode(List<CmmnCdVO> codeList) {
        if(codeList == null || codeList.isEmpty()) {
            return Collections.emptyList();
        }

        List<CmmnCdVO> filteredList = new ArrayList<>();
        for(CmmnCdVO codeVO : codeList) {
            if(codeVO != null && (codeVO.getCdSeqno() == null || codeVO.getCdSeqno() != 0)) {
                filteredList.add(codeVO);
            }
        }
        return filteredList;
    }

    /**
     * 지정된 코드값과 일치하는 공통코드만 화면 선택 목록에 남긴다.
     * @param codeList
     * @param cd
     * @return
     */
    private List<CmmnCdVO> filterByCode(List<CmmnCdVO> codeList, String cd) {
        if(codeList == null || codeList.isEmpty()) {
            return Collections.emptyList();
        }

        List<CmmnCdVO> filteredList = new ArrayList<>();
        for(CmmnCdVO codeVO : codeList) {
            if(codeVO != null && cd.equals(codeVO.getCd())) {
                filteredList.add(codeVO);
            }
        }
        return filteredList;
    }

    /**
     * 일반 과목개설에서는 공개강좌 전용 과정/과목유형 코드가 노출되지 않도록 제외한다.
     * @param upCd
     * @param codeList
     * @return
     */
    private List<CmmnCdVO> excludeOpenLctrOnlyCode(String upCd, List<CmmnCdVO> codeList) {
        if(codeList == null || codeList.isEmpty()) {
            return Collections.emptyList();
        }

        List<CmmnCdVO> filteredList = new ArrayList<>();
        for(CmmnCdVO codeVO : codeList) {
            if(codeVO == null) {
                continue;
            }
            if("CRS_GBNCD".equals(upCd) && OPEN_CRS_GBNCD.equals(codeVO.getCd())) {
                continue;
            }
            if("SBJCT_TYCD".equals(upCd) && OPEN_LCTR_SYSTEM_SBJCT_TYCD.equals(codeVO.getCd())) {
                continue;
            }
            filteredList.add(codeVO);
        }
        return filteredList;
    }
}
