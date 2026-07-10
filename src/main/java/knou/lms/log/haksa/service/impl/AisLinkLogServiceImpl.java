package knou.lms.log.haksa.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.IdPrefixType;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.lms.log.haksa.dao.AisLinkLogDAO;
import knou.lms.log.haksa.service.AisLinkLogService;
import knou.lms.log.haksa.vo.AisLinkLogVO;

@Service("aisLinkLogService")
public class AisLinkLogServiceImpl implements AisLinkLogService {

    private static final int RSLT_CTS_MAX_LEN = 4000;

    @Resource(name = "aisLinkLogDAO")
    private AisLinkLogDAO aisLinkLogDAO;

    /*****************************************************
     * 학사정보시스템연동 로그 적재 (TB_LMS_LOG_AIS_LINK)
     * - 기관/연동유형코드로 AIS_LINK_ID 조회, LODLA PK 생성, 성공/실패 공통 처리
     * @param vo
     ******************************************************/
    @Override
    public void writeAisLinkLog(AisLinkLogVO vo) {
        vo.setLogAisLinkId(IdGenerator.getNewId(IdPrefixType.LODLA.getCode()));
        vo.setAisLinkId(aisLinkLogDAO.selectAisLinkId(vo));
        vo.setRsltCd(vo.isSuccess() ? "OK" : "FAIL");
        vo.setAisLinkScsyn(vo.isSuccess() ? "Y" : "N");
        vo.setAisLinkRsltCts(truncateRsltCts(vo.getAisLinkRsltCts()));

        aisLinkLogDAO.insertAisLinkLog(vo);
    }

    /*****************************************************
     * 연동결과내용 길이 제한 (AIS_LINK_RSLT_CTS VARCHAR2(4000))
     * @param rsltCts
     * @return 4000자 이내 문자열
     ******************************************************/
    private String truncateRsltCts(String rsltCts) {
        String s = StringUtil.nvl(rsltCts);
        return s.length() > RSLT_CTS_MAX_LEN ? s.substring(0, RSLT_CTS_MAX_LEN) : s;
    }
}
