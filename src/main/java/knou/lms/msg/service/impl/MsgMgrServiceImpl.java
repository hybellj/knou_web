package knou.lms.msg.service.impl;

import knou.framework.common.PageInfo;
import knou.framework.common.ServiceBase;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.msg.dao.MsgMgrDAO;
import knou.lms.msg.service.MsgMgrService;
import knou.lms.msg.vo.MsgMgrVO;
import knou.lms.org.service.OrgInfoService;
import knou.lms.org.vo.OrgInfoVO;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

@Service("msgMgrService")
public class MsgMgrServiceImpl extends ServiceBase implements MsgMgrService {

    @Resource(name = "msgMgrDAO")
    private MsgMgrDAO msgMgrDAO;

    @Resource(name = "orgInfoService")
    private OrgInfoService orgInfoService;

    /*****************************************************
     * 학사년도 목록 조회 (현재연도 ±10년, 최근연도 우선)
     * @param vo
     * @return List<MsgMgrVO>
     ******************************************************/
    @Override
    public List<MsgMgrVO> selectYrList(MsgMgrVO vo) {
        List<MsgMgrVO> result = new ArrayList<MsgMgrVO>();
        List<Integer> yearList = DateTimeUtil.getYearList(10, "mix");
        for (int i = yearList.size() - 1; i >= 0; i--) {
            MsgMgrVO yr = new MsgMgrVO();
            yr.setSbjctYr(String.valueOf(yearList.get(i)));
            result.add(yr);
        }
        return result;
    }

    /*****************************************************
     * 학기 목록 조회
     * @param vo
     * @return List<EgovMap>
     ******************************************************/
    @Override
    public List<EgovMap> selectSmstrList(MsgMgrVO vo) {
        return msgMgrDAO.selectSmstrList(vo);
    }

    /*****************************************************
     * 운영과목 목록 조회
     * @param vo
     * @return List<MsgMgrVO>
     ******************************************************/
    @Override
    public List<MsgMgrVO> selectSbjctList(MsgMgrVO vo) {
        return msgMgrDAO.selectSbjctList(vo);
    }

    /*****************************************************
     * 학생 수강과목 기준 학사년도 목록 조회
     * @param vo
     * @return List<MsgMgrVO>
     ******************************************************/
    @Override
    public List<MsgMgrVO> selectStdntYrList(MsgMgrVO vo) {
        return msgMgrDAO.selectStdntYrList(vo);
    }

    /*****************************************************
     * 학생 수강과목 기준 학기 목록 조회
     * @param vo
     * @return List<EgovMap>
     ******************************************************/
    @Override
    public List<EgovMap> selectStdntSmstrList(MsgMgrVO vo) {
        return msgMgrDAO.selectStdntSmstrList(vo);
    }

    /*****************************************************
     * 학생 수강과목 기준 운영과목 목록 조회
     * @param vo
     * @return List<MsgMgrVO>
     ******************************************************/
    @Override
    public List<MsgMgrVO> selectStdntSbjctList(MsgMgrVO vo) {
        return msgMgrDAO.selectStdntSbjctList(vo);
    }

    /*****************************************************
     * 기관 목록 조회 (권한 기반)
     * @param userId
     * @param isAdmin
     * @return List<OrgInfoVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<OrgInfoVO> selectActiveOrgListByAuth(String userId, boolean isAdmin) throws Exception {
        if (isAdmin) {
            return orgInfoService.listActiveOrg();
        }
        if (StringUtil.isNotNull(userId)) {
            return orgInfoService.listActiveOrgByUser(userId);
        }
        return new ArrayList<>();
    }

    /*****************************************************
     * 교수 담당과목 기준 기관 목록 조회
     * @param userId
     * @return List<OrgInfoVO>
     ******************************************************/
    @Override
    public List<OrgInfoVO> selectProfSbjctOrgList(String userId) {
        return msgMgrDAO.selectProfSbjctOrgList(userId);
    }

    /*****************************************************
     * 받는 사람 검색 목록 조회
     * @param vo
     * @return ProcessResultVO<MsgMgrVO>
     ******************************************************/
    @Override
    public ProcessResultVO<MsgMgrVO> selectRcvrSearchListPage(MsgMgrVO vo) throws Exception {
        ProcessResultVO<MsgMgrVO> resultVO = new ProcessResultVO<>();

        PageInfo pageInfo = new PageInfo(vo);
        List<MsgMgrVO> list = "Y".equals(vo.getAdminYn())
                ? msgMgrDAO.selectRcvrSearchAllList(vo)
                : msgMgrDAO.selectRcvrSearchList(vo);
        pageInfo.setTotalRecord(list);

        resultVO.setReturnList(list);
        resultVO.setPageInfo(pageInfo);

        return resultVO;
    }

    /*****************************************************
     * 엑셀 업로드 수신자 조회
     * @param excelInputStream
     * @param orgId
     * @return List<MsgMgrVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<MsgMgrVO> parseExcelAndSearchRcvr(InputStream excelInputStream, String orgId) throws Exception {
        Workbook workbook = WorkbookFactory.create(excelInputStream);
        Sheet sheet = workbook.getSheetAt(0);

        DataFormatter formatter = new DataFormatter();
        List<String> userIdList = new ArrayList<>();

        for (int i = 1; i <= sheet.getLastRowNum(); i++) {
            Row row = sheet.getRow(i);
            if (row == null) continue;
            String userId = formatter.formatCellValue(row.getCell(0)).trim();
            if (!userId.isEmpty()) {
                userIdList.add(userId);
            }
        }
        workbook.close();

        if (userIdList.isEmpty()) {
            return new ArrayList<>();
        }

        MsgMgrVO vo = new MsgMgrVO();
        vo.setUserIdList(userIdList);
        vo.setOrgId(orgId);
        return msgMgrDAO.selectRcvrByUserIds(vo);
    }

    /*****************************************************
     * userId 목록 기반 수신자 조회
     * @param vo
     * @return List<MsgMgrVO>
     ******************************************************/
    @Override
    public List<MsgMgrVO> selectRcvrByUserIds(MsgMgrVO vo) {
        return msgMgrDAO.selectRcvrByUserIds(vo);
    }

    /*****************************************************
     * 사용자 구분 목록 조회 (받는 사람 팝업 검색조건)
     * @return List<EgovMap>
     ******************************************************/
    @Override
    public List<EgovMap> selectUserTycdList() {
        return msgMgrDAO.selectUserTycdList();
    }

}
