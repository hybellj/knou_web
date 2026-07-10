package knou.lms.crs.rubric.service.impl;

import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.*;
import knou.lms.asmt2.service.AsmtService;
import knou.lms.asmt2.vo.AsmtVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.rubric.dao.RubricDAO;
import knou.lms.crs.rubric.vo.RubricVO;
import knou.lms.crs.rubric.service.RubricService;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.*;

@Service("rubricService")
public class RubricServiceImpl extends ServiceBase implements RubricService {

    private static final Logger LOGGER = LoggerFactory.getLogger(RubricServiceImpl.class);

    @Resource(name="rubricDAO")
    private RubricDAO rubricDAO;

    @Resource(name="asmt2Service")
    private AsmtService asmtService;

    /*****************************************************
     * 루브릭 등록
     * @param vo
     * @return vo
     ******************************************************/
    public RubricVO rubricRegist(RubricVO vo) {
        if(StringUtil.nvl(vo.getRubricTycd()).isEmpty()) {
            vo.setRubricTycd("PROF");
        }
        // 1. 루브릭 등록
        vo.setRubricId(IdGenUtil.genNewId(IdPrefixType.RBRC));
        vo.setRgtrId(vo.getUserId());
        rubricDAO.rubricRegist(vo);

        // 2. 문항 등록
        List<RubricVO> qstnList = vo.getRubricQstns();
        if(qstnList != null) {
            for(RubricVO qstn : qstnList) {
                qstn.setRubricId(vo.getRubricId());
                qstn.setRubricQstnId(IdGenUtil.genNewId(IdPrefixType.RBQST));
                qstn.setRgtrId(vo.getUserId());
                rubricDAO.rubricQstnRegist(qstn);

                // 3. 보기항목 등록 (콤마 구분 문자열 split)
                String pntListStr = StringUtil.nvl(qstn.getRubricVwitmPntList());
                String ttlListStr = StringUtil.nvl(qstn.getRubricVwitmTtlList());
                if(!pntListStr.isEmpty()) {
                    String[] pntArr = pntListStr.split(",");
                    String[] ttlArr = ttlListStr.isEmpty() ? new String[0] : ttlListStr.split(",");
                    for(int i = 0; i < pntArr.length; i++) {
                        qstn.setRubricVwitmId(IdGenUtil.genNewId(IdPrefixType.RBVTM));
                        qstn.setRubricVwitmPnt(Integer.parseInt(pntArr[i].trim()));
                        qstn.setRubricVwitmTtl(i < ttlArr.length ? ttlArr[i].trim() : "");
                        qstn.setRubricVwitmSeqno(i + 1);
                        rubricDAO.rubricVwitmRegist(qstn);
                    }
                }
            }
        }
        return vo;
    }

    /*****************************************************
     * 루브릭 목록 페이징
     * @param vo
     * @return ProcessResultVO<RubricVO>
     ******************************************************/
    @Override
    public ProcessResultVO<RubricVO> listRubricPaging(RubricVO vo) {
        ProcessResultVO<RubricVO> processResultVO = new ProcessResultVO<>();

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        int totCnt = rubricDAO.countRubric(vo);

        paginationInfo.setTotalRecordCount(totCnt);

        List<RubricVO> resultList = rubricDAO.listRubricPaging(vo);

        processResultVO.setReturnList(resultList);
        processResultVO.setPageInfo(paginationInfo);

        return processResultVO;
    }

    /*****************************************************
     * 루브릭 가져오기 목록 (루브릭 관리자 등록 + 본인 등록 조회)
     * @param vo
     * @return List<RubricVO>
     ******************************************************/
    @Override
    public List<RubricVO> importRubricList(RubricVO vo) {

        return rubricDAO.importRubricList(vo);
    }

    /*****************************************************
     * 루브릭 등록정보 조회
     * @param vo
     * @return RubricVO
     ******************************************************/
    public RubricVO selectRubricRegistInfo(RubricVO vo) {
        return rubricDAO.selectRubricRegistInfo(vo);
    }

    /*****************************************************
     * 등록자 정보 조회
     * @param vo
     * @return RubricVO
     ******************************************************/
    public RubricVO selectRegisterInfo(RubricVO vo) {
        return rubricDAO.selectRegisterInfo(vo);
    }

    /*****************************************************
     * 루브릭 목록 조회
     * @param vo
     * @return List<EgovMap>
     ******************************************************/
    public List<EgovMap> listRubricInfo(RubricVO vo) {
        return rubricDAO.listRubricInfo(vo);
    }

    /*****************************************************
     * 루브릭 수정
     * @param vo
     * @return vo
     ******************************************************/
    public RubricVO rubricModify(RubricVO vo) {
        // 1. 루브릭 수정
        vo.setMdfrId(vo.getUserId());
        rubricDAO.rubricModify(vo);

        // 2. 루브릭 수정 후 기존 데이터 삭제
        rubricDAO.rubricVwitmDelete(vo);
        rubricDAO.rubricQstnDelete(vo);

        // 2. 문항 등록
        List<RubricVO> qstnList = vo.getRubricQstns();
        if(qstnList != null) {
            for(RubricVO qstn : qstnList) {
                qstn.setRubricId(vo.getRubricId());
                qstn.setRubricQstnId(IdGenUtil.genNewId(IdPrefixType.RBQST));
                qstn.setRgtrId(vo.getUserId());
                qstn.setMdfrId(vo.getUserId());
                rubricDAO.rubricQstnRegist(qstn);

                // 3. 보기항목 등록 (콤마 구분 문자열 split)
                String pntListStr = StringUtil.nvl(qstn.getRubricVwitmPntList());
                String ttlListStr = StringUtil.nvl(qstn.getRubricVwitmTtlList());
                if(!pntListStr.isEmpty()) {
                    String[] pntArr = pntListStr.split(",");
                    String[] ttlArr = ttlListStr.isEmpty() ? new String[0] : ttlListStr.split(",");
                    for(int i = 0; i < pntArr.length; i++) {
                        qstn.setRubricVwitmId(IdGenUtil.genNewId(IdPrefixType.RBVTM));
                        qstn.setRubricVwitmPnt(Integer.parseInt(pntArr[i].trim()));
                        qstn.setRubricVwitmTtl(i < ttlArr.length ? ttlArr[i].trim() : "");
                        qstn.setRubricVwitmSeqno(i + 1);
                        rubricDAO.rubricVwitmRegist(qstn);
                    }
                }
            }
        }

        // 루브릭 문항/등급이 바뀌면 기존 평가점수의 기준이 달라지므로 연결 과제의 최종 점수를 초기화한다.
        try {
            AsmtVO asmtVO = new AsmtVO();
            asmtVO.setRubricId(vo.getRubricId());
            asmtVO.setMdfrId(vo.getUserId());
            asmtService.resetAsmtEvlScrByRubricModify(asmtVO);
        } catch(Exception e) {
            throw new RuntimeException("루브릭을 사용하는 과제 평가점수 초기화에 실패했습니다.", e);
        }

        return vo;
    }

    /*****************************************************
     * 루브릭 사용여부 수정
     * @param vo
     ******************************************************/
    public void rubricUseynModify(RubricVO vo) {
        vo.setMdfrId(vo.getUserId());
        rubricDAO.rubricUseynModify(vo);
    }

    /*****************************************************
     * 루브릭 삭제
     * @param vo
     ******************************************************/
    public void rubricDelete(RubricVO vo) {
        vo.setMdfrId(vo.getUserId());
        // 1. 루브릭 삭제 (논리삭제)
        rubricDAO.rubricDelete(vo);
        // 2. 루브릭 보기항목 삭제
        rubricDAO.rubricVwitmDelete(vo);
        // 3. 루브릭 문항 삭제
        rubricDAO.rubricQstnDelete(vo);
    }
}
