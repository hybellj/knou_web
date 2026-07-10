package knou.lms.common.service.impl;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import knou.framework.common.CommConst;
import knou.framework.context2.UserContext;
import knou.framework.util.DateTimeUtil;
import knou.lms.crs.sbjct.service.SbjctService;
import knou.lms.org.dao.OrgInfoDAO;
import knou.lms.org.vo.OrgInfoVO;
import knou.lms.user.service.UsrDeptCdService;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.common.PageInfo;
import knou.lms.common.dao.CommonDAO;
import knou.lms.common.service.CommonService;

@Service("commonService")
public class CommonServiceImpl  extends EgovAbstractServiceImpl implements CommonService  {

	@Resource(name="commonDAO")
	private CommonDAO commonDAO;

    @Resource(name="orgInfoDAO")
    private OrgInfoDAO orgInfoDAO;

    @Resource(name="usrDeptCdService")
    private UsrDeptCdService usrDeptCdService;

    @Resource(name = "sbjctService")
    private SbjctService sbjctServiceImpl;



    /**
     * filterOptions
     * - orglist        : 전체시스템관리자 -> 전체기관 / 나머지관리자 -> 본인담당기관
     * - smstrChrtlist  : 현재연도 기준 개설된 학사연도,학기/기수
     * @param userCtx
     * @return
     */
    @Override
    public EgovMap loadFilterOptions(UserContext userCtx) {
        EgovMap filterOptions = new EgovMap();

        // 전체시스템관리자 여부
        boolean isADM = CommConst.AUTHRT_CD_ADM.equals(userCtx.getAuthrtCd()); // "SYSADM"

        String orgId = isADM ? "" : userCtx.getOrgId();
        filterOptions.put("orgId", orgId);
        filterOptions.put("disabled", isADM ? "" : "disabled"); // 기관 옵션 disable 여부

        // 기관 목록
        List<OrgInfoVO> orgList = new ArrayList<>();
        OrgInfoVO orgInfoVO = new OrgInfoVO(orgId);

        if (userCtx.isAdmin() && isADM) {
            orgList = orgInfoDAO.list(orgInfoVO); // 전체기관
        }else {
            orgList.add(orgInfoDAO.select(orgInfoVO)); // 본인기관
        }
        filterOptions.put("orgList", orgList);

        // 학사연도/학기 목록
        String curYear = DateTimeUtil.getYear();
        PageInfo pageInfo = new PageInfo();
        pageInfo.setOrgId(orgId);
        pageInfo.setDgrsYr(curYear);

        List<EgovMap> yrSmstrList = this.yrSmstrOnlySelect(pageInfo);
        filterOptions.put("yrSmstrList", yrSmstrList);

        // todo: 제일 최근 연도/학기 레코드 선택되도록 해야하나.. 필요시 주석해제..
//        filterOptions.put("yrSmstr", smstrList.get(0));

        // 학과 목록
//        List<EgovMap> deptList = usrDeptCdService.deptListByAuthrt(userCtx);
//        filterOptions.put("deptList", deptList);

        // 과목 목록
        List<EgovMap> sbjctList = sbjctServiceImpl.sbjctListByAuthrt(userCtx);
        filterOptions.put("sbjctList", sbjctList);

        return filterOptions;
    }

    @Override
	public List<EgovMap> yrSmstrSelect(PageInfo pageInfo) {
		return commonDAO.yrSmstrSelect(pageInfo);
	}	
	
	@Override
	public List<EgovMap> yrSmstrOnlySelect(PageInfo pageInfo) {
		return commonDAO.yrSmstrOnlySelect(pageInfo);
	}
}