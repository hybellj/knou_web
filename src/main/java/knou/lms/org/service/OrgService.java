package knou.lms.org.service;

import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.core.JsonProcessingException;
import knou.framework.common.PageInfo;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.dashboard.vo.WidgetVO;
import knou.lms.menu.vo.MenuVO;
import knou.lms.org.vo.OrgAisLinkVO;
import knou.lms.org.vo.OrgSettingVO;
import knou.lms.org.vo.OrgTemplateVO;
import knou.lms.org.vo.OrgVO;
import knou.lms.subject.vo.SubjectVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

public interface OrgService {

	public List<OrgVO> orgListSelect();

    public ProcessResultVO<EgovMap> orgListPaging(OrgVO vo) throws Exception;

    public EgovMap orgSelect(String orgId);

	public OrgVO selectSubjectOrg(SubjectVO vo) throws Exception;

    public void orgRegist(OrgVO vo) throws JsonProcessingException;

    public void orgModify(OrgVO vo) throws Exception;

    public void orgDelete(String orgId);

    public void orgTmpltRegist(OrgTemplateVO vo);

    public ProcessResultVO<EgovMap> orgTmpltListPaging(PageInfo pageInfo) throws Exception;

    public OrgTemplateVO orgTmpltSelect(String orgId);

    public void orgTmpltModify(OrgTemplateVO vo);

    public void orgTmpltDelete(String orgId) throws Exception;

    public void orgDsgnColrStngModify(OrgTemplateVO vo);

    public ProcessResultVO<EgovMap> orgDashWgtListPaging(OrgVO vo) throws Exception;

    public WidgetVO orgDashWgtStngSelect(String orgId, String widgetUserGbncd) throws JsonProcessingException;

    public void orgDashboardWidgetRegist(WidgetVO vo);

    public void orgWidgetStngRegist(WidgetVO vo);

    public void orgWidgetStngModify(WidgetVO vo) throws JsonProcessingException;

    public List<EgovMap> menuList(MenuVO vo);

    public void orgMenuUseynModify(MenuVO vo);

    public Map<String, OrgSettingVO> orgOptnList(String orgId, String stngCtgrcd);

    public void orgOptnModify(OrgSettingVO vo);

    public OrgAisLinkVO orgAisLinkInfoSelect(String orgId, String aisLinkTycd);

    public List<OrgAisLinkVO> orgAisLinkList(String orgId);

    public void orgAisLinkModify(OrgAisLinkVO vo);

}