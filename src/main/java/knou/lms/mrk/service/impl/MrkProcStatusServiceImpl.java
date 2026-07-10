package knou.lms.mrk.service.impl;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.lms.common.dto.ResultDTO;
import knou.lms.common.dto.SubjectDTO;
import knou.lms.mrk.dao.MrkProcStatusDAO;
import knou.lms.mrk.service.MrkProcStatusService;
import knou.lms.mrk.vo.MrkProcStatusVO;
import knou.lms.subject.dao.SubjectDAO;
import knou.lms.subject.vo.SubjectVO;

@Service("mrkProcStatusService")
public class MrkProcStatusServiceImpl implements MrkProcStatusService {

    @Resource(name="mrkProcStatusDAO")
    private MrkProcStatusDAO mrkProcStatusDAO;

    @Resource(name="subjectDAO")
    private SubjectDAO subjectDAO;

    /**
     * 성적처리현황 목록을 조회한다.
     */
    @Override
    public ResultDTO<EgovMap> mrkProcStatusList(MrkProcStatusVO vo) throws Exception {
        vo.normalizeStatusParams();
        return new ResultDTO<EgovMap>().setReturnList(mrkProcStatusDAO.listMrkProcStatus(vo));
    }

    /**
     * 성적처리현황 엑셀 다운로드 목록을 조회한다.
     */
    @Override
    public List<EgovMap> mrkProcStatusExcelList(MrkProcStatusVO vo) throws Exception {
        vo.normalizeStatusParams();

        List<EgovMap> list = mrkProcStatusDAO.listMrkProcStatus(vo);
        for(int i = 0; i < list.size(); i++) {
            EgovMap item = list.get(i);
            item.put("no", list.size() - i);
            item.put("mrkProcStatusNm", getStatusName(toStringValue(item.get("mrkProcStatusCd"))));
        }
        return list;
    }

    /**
     * 성적처리이력 일괄 등록
     * @param sbjctId
     * @param list
     */
    @Override
    public void mrkProcStsBatchInsert(String sbjctId, List<MrkProcStatusVO> list) {

        // 성적처리이력용 기본정보 조회
        SubjectVO sbjctVO = new SubjectVO();
        sbjctVO.setSbjctId(sbjctId);
        sbjctVO = subjectDAO.subjectSelect(new SubjectDTO(sbjctId));

        String orgId     = sbjctVO.getOrgId();
        String deptId    = sbjctVO.getDeptId();
        String dgrsYr    = sbjctVO.getSbjctYr();
        String dgrsSmstr = sbjctVO.getSbjctSmstr();

        // 기본정보 세팅
        for (MrkProcStatusVO vo : list) {
            vo.setOrgId(orgId);
            vo.setDeptId(deptId);
            vo.setSbjctId(sbjctId);
            vo.setDgrsYr(dgrsYr);
            vo.setDgrsSmstrChrt(dgrsSmstr);
        }

        mrkProcStatusDAO.mrkProcStsBatchInsert(list);
    }

    /**
     * 성적처리 로그 목록을 페이징 조회한다.
     */
    @Override
    public ResultDTO<EgovMap> mrkProcHstryList(MrkProcStatusVO vo) throws Exception {
        ResultDTO<EgovMap> resultDTO = new ResultDTO<EgovMap>(vo);
        resultDTO.getPageInfo().setTotalRecordCount(mrkProcStatusDAO.countMrkProcHstry(vo));
        resultDTO.setReturnList(toStudentRows(mrkProcStatusDAO.listMrkProcHstryPaging(vo)));
        return resultDTO;
    }

    /**
     * 성적처리 로그 엑셀 다운로드 목록을 조회한다.
     */
    @Override
    public List<EgovMap> mrkProcHstryExcelList(MrkProcStatusVO vo) throws Exception {
        List<EgovMap> hstryList = mrkProcStatusDAO.listMrkProcHstry(vo);
        return toStudentRows(hstryList);
    }

    /**
     * 이력유형별 변경 전/후 점수 행을 학생과 처리일시 기준으로 묶는다.
     */
    private List<EgovMap> toStudentRows(List<EgovMap> hstryList) {
        Map<String, EgovMap> rowMap = new LinkedHashMap<>();

        for(EgovMap item : hstryList) {
            String rowKey = toStringValue(item.get("userId")) + "|" + toStringValue(item.get("regDttm"));
            if(!rowMap.containsKey(rowKey)) {
                EgovMap row = new EgovMap();
                row.put("lineNo", item.get("lineNo"));
                row.put("deptId", item.get("deptId"));
                row.put("deptnm", item.get("deptnm"));
                row.put("userId", item.get("userId"));
                row.put("userRprsId", item.get("userRprsId"));
                row.put("stdntNo", item.get("stdntNo"));
                row.put("usernm", item.get("usernm"));
                row.put("regDttm", item.get("regDttm"));
                row.put("rgtrId", item.get("rgtrId"));
                row.put("rgtrnm", item.get("rgtrnm"));
                rowMap.put(rowKey, row);
            }

            String tycd = toStringValue(item.get("mrkProcHstryTycd"));
            if(!"".equals(tycd)) {
                EgovMap row = rowMap.get(rowKey);
                row.put("scrBfr" + tycd, item.get("scrBfr"));
                row.put("scrAft" + tycd, item.get("scrAft"));
            }
        }

        return new ArrayList<>(rowMap.values());
    }

    /**
     * 성적처리상태 코드를 화면 표시명으로 변환한다.
     */
    private String getStatusName(String statusCd) {
        // SQL에서 계산한 MRK_PROC_STATUS_CD를 엑셀 표시명으로 변환한다.
        if("BEFORE".equals(statusCd)) {
            return "산출전";
        }
        if("ING".equals(statusCd)) {
            return "산출중";
        }
        if("FINAL".equals(statusCd)) {
            return "최종확정";
        }
        if("CANCEL".equals(statusCd)) {
            return "평가취소";
        }
        return "";
    }

    /**
     * null 값을 빈 문자열로 변환한다.
     */
    private String toStringValue(Object value) {
        return value == null ? "" : String.valueOf(value);
    }
}
