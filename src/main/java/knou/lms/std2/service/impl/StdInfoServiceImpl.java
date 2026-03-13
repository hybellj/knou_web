package knou.lms.std2.service.impl;

import knou.framework.common.PageInfo;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.std2.dao.StdInfoDAO;
import knou.lms.std2.service.StdInfoService;
import knou.lms.std2.vo.AtndlcVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

@Service("stdInfoService")
public class StdInfoServiceImpl implements StdInfoService {

    @Resource(name="stdInfoDAO")
    private StdInfoDAO stdInfoDAO;

    @Override
    public ProcessResultVO<EgovMap> stdInfoListPaging(AtndlcVO atndlcVO) throws Exception {
        ProcessResultVO<EgovMap> processResultVO = new ProcessResultVO<>();
        // 페이지 정보 설정
        PageInfo pageInfo = new PageInfo(atndlcVO);

        List<EgovMap> stdInfoList = stdInfoDAO.stdInfoListPaging(atndlcVO);

        // 페이지 전체 건수정보 설정
        pageInfo.setTotalRecord(stdInfoList);

        processResultVO.setReturnList(stdInfoList);
        processResultVO.setPageInfo(pageInfo);

        return processResultVO;
    }

    /**
     * 교수 수강생 엑셀 목록
     *
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public List<EgovMap> profStdInfoExcelList(AtndlcVO vo) throws Exception {

        List<EgovMap> stdInfoExcelList = stdInfoDAO.stdInfoExcelList(vo);
        for(int i = 0; i < stdInfoExcelList.size(); i++) {
            EgovMap item = stdInfoExcelList.get(i);
            item.put("stdGbnnm", getStdGbnNm(item));
        }
        return stdInfoExcelList;

    }

    /**
     * 학생구분 명칭 변경
     * 청강생, 수강생, 장애학생
     *
     * @param item
     * @return
     */
    private String getStdGbnNm(EgovMap item) {
        List<String> labels = new ArrayList<String>();

        labels.add("Y".equals(StringUtil.nvl(item.get("audityn"))) ? "청강생" : "수강생");

        if("Y".equals(StringUtil.nvl(item.get("dsblyn")))) {
            labels.add("장애학생");
        }

        return String.join("/", labels);
    }

}
