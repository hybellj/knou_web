package knou.lms.org.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import knou.framework.common.CommConst;
import knou.framework.common.IdPrefixType;
import knou.framework.common.PageInfo;
import knou.framework.common.ServiceBase;
import knou.framework.util.*;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.dashboard.vo.WidgetDTO;
import knou.lms.dashboard.vo.WidgetVO;
import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflVO;
import knou.lms.menu.dao.SysMenuDAO;
import knou.lms.menu.service.SysMenuService;
import knou.lms.menu.vo.MenuVO;
import knou.lms.org.service.OrgService;
import knou.lms.org.vo.OrgAisLinkVO;
import knou.lms.org.vo.OrgSettingVO;
import knou.lms.org.vo.OrgTemplateVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.lms.org.dao.OrgDAO;
import knou.lms.org.vo.OrgVO;
import knou.lms.subject.vo.SubjectVO;

@Service("orgService")
public class OrgServiceImpl extends ServiceBase implements OrgService {

    @Resource(name="orgDAO")
    private OrgDAO orgDAO;

    @Resource(name = "attachFileService")
    private AttachFileService attachFileService;

    @Resource(name = "sysMenuDAO")
    private SysMenuDAO sysMenuDAO;

    /**
     * 기관 목록 조회
     * @return
     */
    @Override
    public List<OrgVO> orgListSelect() {
        return orgDAO.orgListSelect();
    }

    /**
     * 기관(테넌시) - 기관 기본 정보 목록 페이징
     * @param vo
     * @return ProcessResultVO<OrgVO>
     */
    @Override
    public ProcessResultVO<EgovMap> orgListPaging(OrgVO vo) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        PageInfo pageInfo = new PageInfo(vo);
        resultVO.setPageInfo(pageInfo);

        // 목록 조회
        List<EgovMap> list = orgDAO.orgListPaging(vo);

        // 페이지 전체 건수 정보 설정
        pageInfo.setTotalRecord(list);

        resultVO.setReturnList(list);
        resultVO.setPageInfo(pageInfo);
        resultVO.setResult(1);

        return resultVO;
    }

    /**
     * 기관 상세정보 조회
     * @param orgId
     * @return
     */
    @Override
    public EgovMap orgSelect(String orgId){

        EgovMap resultVO = orgDAO.orgSelect(orgId);

        if (ValidationUtils.isNull(resultVO)) return null;

        OrgTemplateVO tmpltVO = orgDAO.orgTmpltSelect(orgId);
        List<AtflVO> fileList = new ArrayList<>();

        if (!ValidationUtils.isNull(tmpltVO)) {

            String logoFileId = tmpltVO.getLogoFileId();
            if (StringUtil.isNotNull(logoFileId)){
                AtflVO atflVO = new AtflVO();
                atflVO.setAtflId(logoFileId);
                atflVO = attachFileService.selectAtfl(atflVO);
                fileList.add(atflVO);
            }
        }
        resultVO.put("fileList", fileList);


        return resultVO;
    }

    /**
     * 과목의 기관 정보 조회
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public OrgVO selectSubjectOrg(SubjectVO vo) throws Exception {
        return orgDAO.selectSubjectOrg(vo);
    }

    /**
     * 기관 등록
     * @param vo
     * @return
     */
    @Override
    public void orgRegist(OrgVO vo) throws JsonProcessingException {

        String orgId = vo.getOrgId();
        String orgTmpltId = IdGenUtil.genNewId(IdPrefixType.ORTML);
        String logoFileId = IdGenUtil.genNewId(IdPrefixType.ATFL);
        String rgtrId = vo.getRgtrId();

        // 기관 정보 등록
        vo.setOrgId(orgId);
        vo.setOrgNcnm(vo.getOrgShrtnm());
        vo.setUseyn("Y");
        vo.setBscLangCd("ko");
        orgDAO.orgRegist(vo);

        // 로고 파일 등록
        String uploadPath = vo.getUploadPath();
        String uploadFiles = vo.getUploadFiles();
        if (StringUtil.isNotNull(uploadFiles)) {
            List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(uploadFiles, uploadPath);

            if (!uploadFileList.isEmpty()) {
                for (AtflVO atflVO : uploadFileList) {
                    atflVO.setAtflId(logoFileId);
                    atflVO.setRefId(orgTmpltId);
                    atflVO.setRgtrId(rgtrId);
                    atflVO.setAtflRepoId(CommConst.REPO_LOGO);
                }
                // 첨부파일 저장
                attachFileService.insertAtflList(uploadFileList);
            }
        }

        // 기관 default 템플릿 등록
        OrgTemplateVO tmpltVO = new OrgTemplateVO();
        tmpltVO.setOrgTmpltId(orgTmpltId);
        tmpltVO.setOrgId(orgId);
        tmpltVO.setLogoFileId(logoFileId);
        tmpltVO.setTmpltnm("default");
        tmpltVO.setLangCd("ko");
        tmpltVO.setDsgnColrTycd("DEFAULT");
        tmpltVO.setUseyn("Y");
        tmpltVO.setRgtrId(rgtrId);
        this.orgTmpltRegist(tmpltVO);


        // 기관 기초 데이터 등록 (위젯, 메뉴, LMS옵션, 학사연동)
        this.orgDfltInfoDataRegist(orgId, rgtrId);
    }

    /**
     * 기관 수정
     * @param vo
     */
    @Override
    public void orgModify(OrgVO vo) throws Exception {

        // 기관 수정
        orgDAO.orgModify(vo);

        // 기관 템플릿 조회
        OrgTemplateVO tmpltVO = orgDAO.orgTmpltSelect(vo.getOrgId());

        // 기관 로고 파일 수정
        String uploadFiles = vo.getUploadFiles();
        String uploadPath = vo.getUploadPath();

        List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(uploadFiles, uploadPath);

        if (!uploadFileList.isEmpty()) {
            for (AtflVO atflVO : uploadFileList) {
                atflVO.setRefId(tmpltVO.getOrgTmpltId());
                atflVO.setMdfrId(vo.getMdfrId());
                atflVO.setAtflRepoId(CommConst.REPO_LOGO);
            }
            // 첨부파일 저장
            attachFileService.insertAtflList(uploadFileList);
        }

        // 첨부파일 삭제
        attachFileService.deleteAtflByAtflIds(vo.getDelFileIds());
    }

    /**
     * 기관 삭제
     * @param orgId
     * @throws Exception
     */
    @Override
    public void orgDelete(String orgId) {

        // 기관 템플릿 삭제
        orgDAO.orgTmpltDelete(orgId);

        // 기관 대시보드 위젯 삭제
        orgDAO.orgWidgetStngDelete(orgId);

        // 기관 LMS 옵션 삭제
        orgDAO.orgOptnDelete(orgId);

        // 기관 학사연동 삭제
        orgDAO.aisLinkDeleteAll(orgId);

        // 기관 메뉴 삭제
        orgDAO.orgMenuDeleteAll(orgId);

        // 기관 삭제
        orgDAO.orgDelete(orgId);

    }

    /**
     * 기관 템플릿 목록 조회
     * @param vo
     * @return ProcessResultVO<EgovMap>
     */
    @Override
    public ProcessResultVO<EgovMap> orgTmpltListPaging(PageInfo pageInfo) {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        // 목록 조회
        List<EgovMap> list = orgDAO.orgTmpltListPaging(pageInfo);

        // 페이지 전체 건수 정보 설정

        resultVO.setReturnList(list);
        resultVO.setPageInfo(pageInfo);
        resultVO.setResultSuccess();

        return resultVO;
    }

    /**
     * 기관 템플릿 조회
     * @param orgId
     * @return
     */
    @Override
    public OrgTemplateVO orgTmpltSelect(String orgId) {
        return new OrgTemplateVO();
    }

    /**
     * 기관 템플릿 등록
     * @param vo
     * @return
     */
    @Override
    public void orgTmpltRegist(OrgTemplateVO vo) {
        orgDAO.orgTmpltRegist(vo);
    }

    /**
     * 기관 템플릿 수정
     * @param vo
     */
    @Override
    public void orgTmpltModify(OrgTemplateVO vo) {
        orgDAO.orgTmpltModify(vo);
    }

    /**
     * 기관 템플릿 삭제
     * @param orgId
     */
    @Override
    public void orgTmpltDelete(String orgId) throws Exception {

        // 기관 로고 파일 삭제
        OrgTemplateVO tmpltVO = orgDAO.orgTmpltSelect(orgId);
        String logoFileId = tmpltVO.getLogoFileId();
        AtflVO logoFileVO = new AtflVO();
        logoFileVO.setAtflId(logoFileId);
        attachFileService.deleteAtfl(logoFileVO);

        // 기관 템플릿 삭제
        orgDAO.orgTmpltDelete(orgId);
    }

    @Override
    public void orgDsgnColrStngModify(OrgTemplateVO vo) {
        orgDAO.orgDsgnColrStngModify(vo);
    }

    /**
     * 기관 대시보드 위젯 목록 조회
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<EgovMap> orgDashWgtListPaging(OrgVO vo) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        PageInfo pageInfo = new PageInfo(vo);
        resultVO.setPageInfo(pageInfo);

        // 목록 조회
        List<EgovMap> list = orgDAO.orgDashWgtListPaging(vo);

        // 페이지 전체 건수 정보 설정
        pageInfo.setTotalRecord(list);

        resultVO.setReturnList(list);
        resultVO.setPageInfo(pageInfo);
        resultVO.setResult(1);

        return resultVO;
    }

    /**
     * 기관 대시보드 위젯 설정 조회
     * @param orgId
     * @param widgetUserGbncd
     * @return
     */
    @Override
    public WidgetVO orgDashWgtStngSelect(String orgId, String widgetUserGbncd) throws JsonProcessingException {

        WidgetVO wgVO = orgDAO.orgDashWgtStngSelect(orgId, widgetUserGbncd);

        if (ValidationUtils.isNull(wgVO)) return null;

        ObjectMapper mapper = new ObjectMapper();
        String widgetStngCts = wgVO.getWidgetStngCts();
        wgVO.setWidgetStngList(mapper.readValue(widgetStngCts, new TypeReference<List<WidgetDTO>>() {}));

        return wgVO;
    }

    /**
     * 관리자 > 대시보드 위젯 등록
     * @param vo
     */
    @Override
    public void orgDashboardWidgetRegist(WidgetVO vo) {
        orgDAO.orgWidgetStngRegist(vo);
    }

    /**
     * 기관 대시보드 위젯 기본값 등록
     * @param vo
     */
    @Override
    public void orgWidgetStngRegist(WidgetVO vo) {
        orgDAO.orgWidgetStngRegist(vo);
    }

    /**
     * 기관 대시보드 위젯 기본값 수정
     * @param vo
     */
    @Override
    public void orgWidgetStngModify(WidgetVO vo) throws JsonProcessingException {

        this.orgWidgetStngModifyByUserGbncd(vo, CommConst.AUTHRT_GRPCD_PROF);
        this.orgWidgetStngModifyByUserGbncd(vo, CommConst.AUTHRT_GRPCD_STDNT);

    }

    /**
     * 메뉴 구분과 메뉴 권한에 따른 메뉴 계층 조회
     *
     * @param vo
     * @return
     */
    @Override
    public List<EgovMap> menuList(MenuVO vo) {

        return orgDAO.menuList(vo);
    }

    /**
     *  기관 메뉴 사용여부 변경
     * @param vo
     */
    @Override
    public void orgMenuUseynModify(MenuVO vo) {
        orgDAO.orgMenuUseynModify(vo);
    }

    /**
     * 기관 LMS 옵션 목록 조회
     *
     * @param orgId
     * @param stngCtgrcd
     * @return
     */
    @Override
    public Map<String, OrgSettingVO> orgOptnList(String orgId, String stngCtgrcd) {

        List<OrgSettingVO> stngList = orgDAO.orgLmsOptnList(orgId, stngCtgrcd);

        return stngList.stream().collect(Collectors.toMap(OrgSettingVO::getStngCd,vo -> vo));
    }

    /**
     * 기관 LMS 옵션 저장
     * @param vo
     */
    @Override
    public void orgOptnModify(OrgSettingVO vo) {

        String orgId = vo.getOrgId();
        String mdfrId = vo.getMdfrId();

        List<OrgSettingVO> orgStngList = vo.getStngList();

        for (OrgSettingVO stngVO : orgStngList) {
            stngVO.setOrgId(orgId);
            stngVO.setMdfrId(mdfrId);
        }

        orgDAO.orgOptnListModify(vo.getStngList());
    }

    /**
     * 유저구분별 위젯 설정 변경
     * @param vo
     * @param widgetUserGbncd
     */
    public void orgWidgetStngModifyByUserGbncd(WidgetVO vo, String widgetUserGbncd) throws JsonProcessingException {

        ObjectMapper mapper = new ObjectMapper();

        // 변경된 설정값: Json문자열 (고정 제외)
        String checkedWgtStngJson;
        if ("PROF".equals(widgetUserGbncd)){
            checkedWgtStngJson = vo.getProfWidgetListJson();
        }else {
            checkedWgtStngJson = vo.getStdWidgetListJson();
        }

        // 변경된 설정값: Json문자열 -> 객체
        List<WidgetDTO> checkedWgtList = mapper.readValue(checkedWgtStngJson, new TypeReference<>() {});
        List<WidgetDTO> updatedWgtList = new ArrayList<>();

        for (WidgetDTO widgetDTO : checkedWgtList) {
            updatedWgtList.add(this.getDefaultWgtDto(widgetDTO.getWidgetId()));
        }

        WidgetVO updatedWgtVO = new WidgetVO();
        updatedWgtVO.setWidgetStngCts(mapper.writeValueAsString(updatedWgtList));
        updatedWgtVO.setMdfrId(vo.getMdfrId());
        updatedWgtVO.setOrgId(vo.getOrgId());
        updatedWgtVO.setWidgetUserGbncd(widgetUserGbncd);

        orgDAO.orgWidgetStngModify(updatedWgtVO);
    }

    /**
     * 기관 디폴트 위젯 설정값(widgetStngCts) s세팅
     * @param userGbnCd
     * @return wgtStngJson
     */
    public String setDefaultWidget(String userGbnCd) throws JsonProcessingException {
        ObjectMapper mapper = new ObjectMapper();
        List<WidgetDTO> widgets;

        if ("PROF".equals(userGbnCd)) {
            // 교수용 위젯 목록
            widgets = List.of(
                    getDefaultWgtDto("wigt_prof_today"),
                    getDefaultWgtDto("wigt_prof_schedule"),
                    getDefaultWgtDto("wigt_prof_notice"),
                    getDefaultWgtDto("wigt_prof_qna"),
                    getDefaultWgtDto("wigt_prof_counsel"),
                    getDefaultWgtDto("wigt_prof_msg"),
                    getDefaultWgtDto("wigt_prof_subject")
            );
        }else {
            // 학생용 위젯 목록
            widgets = List.of(
                    getDefaultWgtDto("wigt_prof_today"),
                    getDefaultWgtDto("wigt_stu_schedule"),
                    getDefaultWgtDto("wigt_stu_contstdy"),
                    getDefaultWgtDto("wigt_stu_notice"),
                    getDefaultWgtDto("wigt_stu_subject"),
                    getDefaultWgtDto("wigt_stu_msg"),
                    getDefaultWgtDto("wigt_stu_qna"),
                    getDefaultWgtDto("wigt_stu_pds")
            );
        }

        return mapper.writeValueAsString(widgets);
    }

    /**
     * WidgetDTO 위젯아이디별 기본 설정 세팅된 WidgetDTO 가져오기
     * @param widgetId
     * @return WidgetDTO
     */
    private WidgetDTO getDefaultWgtDto(String widgetId) {
        WidgetDTO dto = null;

        switch (widgetId) {
            // 교수
            case "wigt_prof_today":     dto = new WidgetDTO(widgetId, "Today", "Y",       0, 0, 4, 4, 4, 4, 8, 8); break;
            case "wigt_prof_schedule":  dto = new WidgetDTO(widgetId, "이달의 학사일정", "Y",4, 0, 4, 4, 4, 4, 8, 8); break;
            case "wigt_prof_notice":    dto = new WidgetDTO(widgetId, "공지사항", "Y",      8, 0, 4, 4, 4, 4, 8, 8); break;
            case "wigt_prof_qna":       dto = new WidgetDTO(widgetId, "강의Q&A", "Y",      0, 8, 4, 4, 4, 4, 8, 8); break;
            case "wigt_prof_counsel":   dto = new WidgetDTO(widgetId, "1:1상담", "Y",      0, 4, 4, 4, 4, 4, 8, 8); break;
            case "wigt_prof_msg":       dto = new WidgetDTO(widgetId, "알림", "Y",         0, 12, 4, 4, 4, 4, 8, 8); break;
            case "wigt_prof_subject":   dto = new WidgetDTO(widgetId, "강의과목", "Y",      4, 4 , 8, 12, 8, 4, 12, 16); break;

            // 학생
            case "wigt_stu_today":      dto = new WidgetDTO(widgetId, "Today", "Y",        0, 0, 4, 4, 4, 4, 8, 8); break;
            case "wigt_stu_schedule":   dto = new WidgetDTO(widgetId, "이달의 학사일정", "Y", 4, 0, 4, 4, 4, 4, 8, 8); break;
            case "wigt_stu_notice":     dto = new WidgetDTO(widgetId, "공지사항", "Y",       8, 0, 4, 4, 4, 4, 8, 8); break;
            case "wigt_stu_contstdy":   dto = new WidgetDTO(widgetId, "강의 이어보기", "Y",   0, 4, 4, 4, 4, 4, 8, 8); break;
            case "wigt_stu_subject":    dto = new WidgetDTO(widgetId, "수강과목", "Y",       4, 4, 8, 12, 8, 4, 12, 16); break;
            case "wigt_stu_msg":        dto = new WidgetDTO(widgetId, "알림", "Y",          0, 12, 4, 4, 4, 4, 8, 8); break;
            case "wigt_stu_qna":        dto = new WidgetDTO(widgetId, "강의 Q&A", "Y",      0, 16, 4, 4, 4, 4, 8, 8); break;
            case "wigt_stu_pds":        dto = new WidgetDTO(widgetId, "강의 자료실", "Y",    0, 20, 4, 4, 4, 4, 8, 8); break;
        }

        return dto;
    }

    /**
     * 기관 기본 정보 데이터 등록
     * - 위젯, 메뉴, LMS옵션, 학사연동
     * @param orgId
     * @param rgtrId
     * @throws JsonProcessingException
     */
    private void orgDfltInfoDataRegist(String orgId, String rgtrId) {
        // 위젯
        List<WidgetVO> wgtList = orgDAO.defaultWgtList();
        for (WidgetVO widgetVO : wgtList) {
            widgetVO.setWidgetId(IdGenUtil.genNewId(IdPrefixType.WGET));
            widgetVO.setOrgId(orgId);
            widgetVO.setRgtrId(rgtrId);
        }
        orgDAO.orgWidgetStngListRegist(wgtList);

        // 메뉴
        MenuVO menuVO = new MenuVO();
        menuVO.setOrgId(orgId);
        sysMenuDAO.insertOrgDefaultMenu(menuVO);


        // LMS 옵션
        List<OrgSettingVO> stnglist = orgDAO.defaultLmsOptnList();
        for (OrgSettingVO stngVO : stnglist) {
            stngVO.setOrgStngId(IdGenUtil.genNewId(IdPrefixType.ORSET));
            stngVO.setOrgId(orgId);
            stngVO.setRgtrId(rgtrId);
        }
        orgDAO.orgOptnListRegist(stnglist);

        // 학사연동
        List<OrgAisLinkVO> linkList = orgDAO.defaultAisLinkList();
        for (OrgAisLinkVO linkVO : linkList) {
            linkVO.setAisLinkId(IdGenUtil.genNewId(IdPrefixType.DLAIS));
            linkVO.setOrgId(orgId);
            linkVO.setRgtrId(rgtrId);
        }
        orgDAO.aisLinkListRegist(linkList);
    }

    /**
     * 기관 학사정보연동 정보 단건 조회
     * @param orgId
     * @param aisLinkTycd
     * @return orgAisLinkVO
     */
    @Override
    public OrgAisLinkVO orgAisLinkInfoSelect(String orgId, String aisLinkTycd) {
        return orgDAO.orgAisLinkInfoSelect(orgId, aisLinkTycd);
    }

    /**
     * 기관 학사연동 정보 목록 조회
     * @param orgId
     * @return List<OrgAisLinkVO>
     */
    @Override
    public List<OrgAisLinkVO> orgAisLinkList(String orgId) {
        return orgDAO.orgAisLinkList(orgId);
    }

    /**
     * 기관 학사연동 정보 수정
     * @param vo
     */
    @Override
    public void orgAisLinkModify(OrgAisLinkVO vo) {
        orgDAO.aisLinkInfoModify(vo);
    }
}
