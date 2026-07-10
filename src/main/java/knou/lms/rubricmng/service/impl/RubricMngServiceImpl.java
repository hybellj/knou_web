package knou.lms.rubricmng.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.stereotype.Service;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.rubricmng.dao.RubricMngDAO;
import knou.lms.rubricmng.service.RubricMngService;
import knou.lms.rubricmng.vo.RubricMngVO;

@Service("rubricMngService")
public class RubricMngServiceImpl extends ServiceBase implements RubricMngService {

    @Resource(name = "rubricMngDAO")
    private RubricMngDAO rubricMngDAO;

    /*****************************************************
     * 기관 목록 조회
     * @param vo
     * @return List<RubricMngVO>
     ******************************************************/
    @Override
    public List<RubricMngVO> listOrg(RubricMngVO vo) {
        return rubricMngDAO.listOrg(vo);
    }

    /*****************************************************
     * 루브릭 등록
     * @param vo
     * @return RubricMngVO
     ******************************************************/
    @Override
    public RubricMngVO rubricRegist(RubricMngVO vo) {
        vo.setRubricTycd("ORG");
        vo.setRubricId(IdGenUtil.genNewId(IdPrefixType.RBRC));
        vo.setRgtrId(vo.getUserId());
        rubricMngDAO.rubricRegist(vo);

        saveRubricDetail(vo, false);
        return vo;
    }

    /*****************************************************
     * 루브릭 목록 조회
     * @param vo
     * @return ProcessResultVO<RubricMngVO>
     ******************************************************/
    @Override
    public ProcessResultVO<RubricMngVO> listRubricPaging(RubricMngVO vo) {
        ProcessResultVO<RubricMngVO> resultVO = new ProcessResultVO<RubricMngVO>();

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        int totCnt = rubricMngDAO.countRubric(vo);
        paginationInfo.setTotalRecordCount(totCnt);

        resultVO.setReturnList(rubricMngDAO.listRubricPaging(vo));
        resultVO.setPageInfo(paginationInfo);
        return resultVO;
    }

    /*****************************************************
     * 루브릭 기본정보 조회
     * @param vo
     * @return RubricMngVO
     ******************************************************/
    @Override
    public RubricMngVO selectRubricRegistInfo(RubricMngVO vo) {
        return rubricMngDAO.selectRubricRegistInfo(vo);
    }

    /*****************************************************
     * 등록 화면 기본정보 조회
     * @param vo
     * @return RubricMngVO
     ******************************************************/
    @Override
    public RubricMngVO selectRegisterInfo(RubricMngVO vo) {
        if (isBlank(vo.getOrgId())) {
            return new RubricMngVO();
        }
        RubricMngVO infoVO = rubricMngDAO.selectRegisterInfo(vo);
        return infoVO == null ? new RubricMngVO() : infoVO;
    }

    /*****************************************************
     * 루브릭 문항/평가등급 정보 조회
     * @param vo
     * @return List<EgovMap>
     ******************************************************/
    @Override
    public List<EgovMap> listRubricInfo(RubricMngVO vo) {
        return rubricMngDAO.listRubricInfo(vo);
    }

    /*****************************************************
     * 루브릭 수정
     * @param vo
     * @return RubricMngVO
     ******************************************************/
    @Override
    public RubricMngVO rubricModify(RubricMngVO vo) {
        validateTarget(vo);

        vo.setMdfrId(vo.getUserId());
        rubricMngDAO.rubricModify(vo);
        rubricMngDAO.rubricVwitmDelete(vo);
        rubricMngDAO.rubricQstnDelete(vo);

        saveRubricDetail(vo, true);
        return vo;
    }

    /*****************************************************
     * 루브릭 사용여부 수정
     * @param vo
     ******************************************************/
    @Override
    public void rubricUseynModify(RubricMngVO vo) {
        validateTarget(vo);
        vo.setMdfrId(vo.getUserId());
        rubricMngDAO.rubricUseynModify(vo);
    }

    /*****************************************************
     * 루브릭 삭제
     * @param vo
     ******************************************************/
    @Override
    public void rubricDelete(RubricMngVO vo) {
        validateTarget(vo);
        vo.setMdfrId(vo.getUserId());
        rubricMngDAO.rubricDelete(vo);
        rubricMngDAO.rubricVwitmDelete(vo);
        rubricMngDAO.rubricQstnDelete(vo);
    }

    /*****************************************************
     * 루브릭 문항/평가등급 저장
     * @param vo
     * @param modifyMode
     ******************************************************/
    private void saveRubricDetail(RubricMngVO vo, boolean modifyMode) {
        List<RubricMngVO> qstnList = vo.getRubricQstns();
        if (qstnList == null) {
            return;
        }

        for (RubricMngVO qstnVO : qstnList) {
            qstnVO.setRubricId(vo.getRubricId());
            qstnVO.setRubricQstnId(IdGenUtil.genNewId(IdPrefixType.RBQST));
            qstnVO.setRgtrId(vo.getUserId());
            if (modifyMode) {
                qstnVO.setMdfrId(vo.getUserId());
            }
            rubricMngDAO.rubricQstnRegist(qstnVO);

            String pntListStr = StringUtil.nvl(qstnVO.getRubricVwitmPntList());
            String ttlListStr = StringUtil.nvl(qstnVO.getRubricVwitmTtlList());
            if (pntListStr.length() == 0) {
                continue;
            }

            String[] pntArr = pntListStr.split(",");
            String[] ttlArr = ttlListStr.length() == 0 ? new String[0] : ttlListStr.split(",");
            for (int i = 0; i < pntArr.length; i++) {
                qstnVO.setRubricVwitmId(IdGenUtil.genNewId(IdPrefixType.RBVTM));
                qstnVO.setRubricVwitmPnt(Integer.parseInt(pntArr[i].trim()));
                qstnVO.setRubricVwitmTtl(i < ttlArr.length ? ttlArr[i].trim() : "");
                qstnVO.setRubricVwitmSeqno(i + 1);
                rubricMngDAO.rubricVwitmRegist(qstnVO);
            }
        }
    }

    /*****************************************************
     * 수정/삭제 대상 루브릭 존재 여부 확인
     * @param vo
     ******************************************************/
    private void validateTarget(RubricMngVO vo) {
        if (isBlank(vo.getRubricId())) {
            throw new IllegalArgumentException("대상 루브릭 정보를 찾을 수 없습니다.");
        }
        RubricMngVO targetVO = rubricMngDAO.selectRubricRegistInfo(vo);
        if (targetVO == null) {
            throw new IllegalArgumentException("대상 루브릭 정보를 찾을 수 없습니다.");
        }
    }

    /*****************************************************
     * 공백 여부 확인
     * @param value
     * @return boolean
     ******************************************************/
    private boolean isBlank(String value) {
        return StringUtil.nvl(value).trim().length() == 0;
    }
}
