package knou.lms.org.dao;

import java.util.List;

import knou.framework.common.PageInfo;
import knou.lms.dashboard.vo.WidgetVO;
import knou.lms.menu.vo.MenuVO;
import knou.lms.org.vo.*;
import org.apache.ibatis.annotations.Param;
import org.apache.xmlbeans.impl.xb.xsdschema.Public;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.subject.vo.SubjectVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

@Mapper("orgDAO")
public interface OrgDAO {

	public List<OrgVO> orgListSelect() ;

    public List<EgovMap> orgListPaging(OrgVO vo);

    public EgovMap orgSelect(String orgId);

	public OrgVO selectSubjectOrg(SubjectVO vo) throws Exception;

    public void orgRegist(OrgVO vo);

    public void orgModify(OrgVO vo);

    public void orgDelete(String orgId);

//    public List<EgovMap> orgTmpltListPaging(OrgTemplateVO vo);
    public List<EgovMap> orgTmpltListPaging(PageInfo pageInfo);

    public OrgTemplateVO orgTmpltSelect(String orgId);

    public void orgTmpltRegist(OrgTemplateVO vo);

    public void orgTmpltModify(OrgTemplateVO vo);

    public void orgTmpltDelete(String orgId);

    public void orgDsgnColrStngModify(OrgTemplateVO vo);

    public List<EgovMap> orgDashWgtListPaging(OrgVO vo);

    public WidgetVO orgDashWgtStngSelect(@Param("orgId")String orgId, @Param("widgetUserGbncd")String widgetUserGbncd);

    public void orgWidgetStngRegist(WidgetVO vo);

    public void orgWidgetStngListRegist(List<WidgetVO> list);

    public void orgWidgetStngModify(WidgetVO vo);

    public void orgWidgetStngDelete(String orgId);

    public List<EgovMap> menuList(MenuVO vo);

    public void orgMenuUseynModify(MenuVO vo);

    public void orgMenuDeleteAll(String orgId);

    public List<OrgSettingVO> orgLmsOptnList(@Param("orgId")String orgId, @Param("stngCtgrCd")String stngCtgrCd);

    public void orgOptnRegist(OrgSettingVO vo);

    public void orgOptnListRegist(List<OrgSettingVO> list);

    public void orgOptnModify(OrgSettingVO vo);

    public void orgOptnListModify(List<OrgSettingVO> list);

    public void orgOptnDelete(String orgId);

    public OrgAisLinkVO orgAisLinkInfoSelect(@Param("orgId")String orgId, @Param("aisLinkTycd")String aisLinkTycd);

    public List<OrgAisLinkVO> orgAisLinkList(String orgId);

    public void aisLinkListRegist(List<OrgAisLinkVO> list);

    public void aisLinkInfoModify(OrgAisLinkVO vo);

    public void aisLinkDeleteAll(String orgId);

    public List<WidgetVO> defaultWgtList();

    public List<OrgSettingVO> defaultLmsOptnList();

    public List<OrgAisLinkVO> defaultAisLinkList();

}