package knou.lms.mut.service.impl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import knou.framework.common.ServiceBase;
import knou.framework.common.SessionInfo;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.mut.dao.MutEvalCmntDAO;
import knou.lms.mut.dao.MutEvalDAO;
import knou.lms.mut.dao.MutEvalGradeDAO;
import knou.lms.mut.dao.MutEvalQstnDAO;
import knou.lms.mut.dao.MutEvalRltnDAO;
import knou.lms.mut.dao.MutEvalRsltDAO;
import knou.lms.mut.service.MutEvalService;
import knou.lms.mut.vo.MutEvalCmntVO;
import knou.lms.mut.vo.MutEvalGradeVO;
import knou.lms.mut.vo.MutEvalQstnVO;
import knou.lms.mut.vo.MutEvalRltnVO;
import knou.lms.mut.vo.MutEvalRsltVO;
import knou.lms.mut.vo.MutEvalVO;

@Service("mutEvalService")
public class MutEvalServiceImpl extends ServiceBase implements MutEvalService {

    @Resource(name="mutEvalDAO")
    private MutEvalDAO mutEvalDAO;

    @Resource(name="mutEvalQstnDAO")
    private MutEvalQstnDAO mutEvalQstnDAO;

    @Resource(name="mutEvalGradeDAO")
    private MutEvalGradeDAO mutEvalGradeDAO;

    @Resource(name="mutEvalRsltDAO")
    private MutEvalRsltDAO mutEvalRsltDAO;

    @Resource(name="mutEvalCmntDAO")
    private MutEvalCmntDAO mutEvalCmntDAO;

    @Resource(name="mutEvalRltnDAO")
    private MutEvalRltnDAO mutEvalRltnDAO;

    // 조회
    @Override
    public ProcessResultVO<MutEvalVO> selectMut(MutEvalVO vo) {
        ProcessResultVO<MutEvalVO> resultVO = new ProcessResultVO<MutEvalVO>();

        if("OBJECT".equals(vo.getSelectType())) {
            resultVO = selectObject(vo);
        }else if("LIST".equals(vo.getSelectType())) {
            resultVO = selectList(vo);
        }else if("PAGE".equals(vo.getSelectType())) {
            resultVO = selectListPaging(vo);
        }

        return resultVO;
    }

    // 단건 조회
    @Override
    public ProcessResultVO<MutEvalVO> selectObject(MutEvalVO vo) {
        ProcessResultVO<MutEvalVO> resultVO = new ProcessResultVO<MutEvalVO>();

        try {
            MutEvalVO mEVO = mutEvalDAO.selectObject(vo);

            List<MutEvalQstnVO> evalQstnList = mutEvalDAO.selectQstn(vo);

            for (MutEvalQstnVO mutEvalQstnVO : evalQstnList) {
                List<MutEvalGradeVO> evalGradeList = mutEvalDAO.selectGrade(mutEvalQstnVO);
                mutEvalQstnVO.setEvalGradeList(evalGradeList);
            }

            mEVO.setEvalQstnList(evalQstnList);

            resultVO.setReturnVO(mEVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }

        return resultVO;
    }

    // 다건 조회
    @Override
    public ProcessResultVO<MutEvalVO> selectList(MutEvalVO vo) {
        ProcessResultVO<MutEvalVO> resultVO = new ProcessResultVO<MutEvalVO>();

        try {
            resultVO.setReturnList(mutEvalDAO.selectList(vo));
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }

        return resultVO;
    }

    // 페이징 조회
    @Override
    public ProcessResultVO<MutEvalVO> selectListPaging(MutEvalVO vo) {
        ProcessResultVO<MutEvalVO> resultVO = new ProcessResultVO<MutEvalVO>();

        try {

            PaginationInfo paginationInfo = new PaginationInfo();
            paginationInfo.setCurrentPageNo(vo.getPageIndex());
            paginationInfo.setRecordCountPerPage(vo.getListScale());
            paginationInfo.setPageSize(vo.getListScale());

            vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
            vo.setLastIndex(paginationInfo.getLastRecordIndex());

            List<MutEvalVO> listPaging = mutEvalDAO.selectListPaging(vo);

            if(listPaging.size() > 0) {
                paginationInfo.setTotalRecordCount(listPaging.get(0).getTotalCnt());
            } else {
                paginationInfo.setTotalRecordCount(0);
            }

            resultVO.setReturnList(listPaging);
            resultVO.setPageInfo(paginationInfo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }

        return resultVO;
    }

    // 사용여부 수정
    @Override
    public ProcessResultVO<MutEvalVO> updateUseYn(MutEvalVO vo) {
        ProcessResultVO<MutEvalVO> resultVO = new ProcessResultVO<MutEvalVO>();

        try {
            mutEvalDAO.updateUseYn(vo);

            resultVO.setResult(1);
            resultVO.setMessage("수정하였습니다.");
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("수정하지 못하였습니다.");
        }

        return resultVO;
    }

    // 삭제
    @Override
    public ProcessResultVO<MutEvalVO> updateDelYn(MutEvalVO vo) {
        ProcessResultVO<MutEvalVO> resultVO = new ProcessResultVO<MutEvalVO>();

        try {
            mutEvalDAO.updateDelYn(vo);

            resultVO.setResult(1);
            resultVO.setMessage("수정하였습니다.");
        } catch (Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("수정하지 못하였습니다.");
        }

        return resultVO;
    }

    // 등록
    @Override
    public ProcessResultVO<MutEvalVO> regEvalQstn(HttpServletRequest request,MutEvalVO vo) throws Exception {
        ProcessResultVO<MutEvalVO> resultVO = new ProcessResultVO<MutEvalVO>();
        
        String userId = SessionInfo.getUserId(request);
        vo.setRgtrId(userId);
        vo.setMdfrId(userId);

        // 수정시 평가결과, 문항, 평가등급 기존 데이터 삭제
        if(!"".equals(StringUtil.nvl(vo.getEvalCd()))) {
            MutEvalRsltVO mutEvalRsltVO = new MutEvalRsltVO();
            mutEvalRsltVO.setEvalCd(vo.getEvalCd());
            mutEvalRsltVO.setEvalStatusCd("C");
            List<EgovMap> mutEvalRsltList = mutEvalRsltDAO.listMutEvalRslt(mutEvalRsltVO);
            // 기존 평가 결과 삭제
            if(mutEvalRsltList.size() > 0) {
                MutEvalCmntVO mutEvalCmntVO = new MutEvalCmntVO();
                mutEvalCmntVO.setEvalCd(vo.getEvalCd());
                mutEvalCmntDAO.delMutEvalCmnt(mutEvalCmntVO);
                mutEvalRsltDAO.delMutEvalRslt(mutEvalRsltVO);
            }

            // 평가등급 삭제
            MutEvalGradeVO mutEvalGradeVO = new MutEvalGradeVO();
            mutEvalGradeVO.setEvalCd(StringUtil.nvl(vo.getEvalCd()));
            mutEvalGradeDAO.deleteAllGrade(mutEvalGradeVO);

            // 문항 삭제
            MutEvalQstnVO mutEvalQstnVO = new MutEvalQstnVO();
            mutEvalQstnVO.setEvalCd(StringUtil.nvl(vo.getEvalCd()));
            mutEvalQstnDAO.deleteAllQstn(mutEvalQstnVO);
        }

        // 루브릭 기본 정보 등록
        if("".equals(StringUtil.nvl(vo.getEvalCd()))) {
            String newEvalCd = IdGenerator.getNewId("EVAL");
            vo.setEvalCd(newEvalCd);
        }

        mutEvalDAO.insertMutEval(vo);

        // 문항-평가등급 등록
        MutEvalQstnVO mutEvalQstnVO = new MutEvalQstnVO();
        mutEvalQstnVO.setEvalCd(StringUtil.nvl(vo.getEvalCd()));
        //mutEvalQstnVO.setEvalTypeCd(StringUtil.nvl(vo.getEvalTypeCd()));
        mutEvalQstnVO.setRgtrId(StringUtil.nvl(vo.getRgtrId()));
        mutEvalQstnVO.setMdfrId(StringUtil.nvl(vo.getMdfrId()));

        List<MutEvalQstnVO> mutEvalQstnList = vo.getEvalQstnList();
        if(mutEvalQstnList != null && mutEvalQstnList.size() > 0) {
            for(int i = 0; i < mutEvalQstnList.size(); i++) {
                String newQstnCd = IdGenerator.getNewId("QSTN");
                mutEvalQstnVO.setQstnCd(newQstnCd);
                mutEvalQstnVO.setEvalTypeCd(mutEvalQstnList.get(i).getEvalTypeCd());
                mutEvalQstnVO.setQstnCts(mutEvalQstnList.get(i).getQstnCts());
                mutEvalQstnVO.setQstnNo(mutEvalQstnList.get(i).getQstnNo());
                mutEvalQstnVO.setEvalScore(mutEvalQstnList.get(i).getEvalScore());
                mutEvalQstnDAO.insertMutEvalQstn(mutEvalQstnVO);

                List<MutEvalGradeVO> mutEvalGradeList = mutEvalQstnList.get(i).getEvalGradeList();
                if(mutEvalGradeList != null && mutEvalGradeList.size() > 0) {
                    for(int j = 0; j < mutEvalGradeList.size(); j++) {
                        MutEvalGradeVO mutEvalGradeVO = new MutEvalGradeVO();
                        mutEvalGradeVO.setGradeCd(IdGenerator.getNewId("GRADE"));
                        mutEvalGradeVO.setQstnCd(StringUtil.nvl(mutEvalQstnVO.getQstnCd()));
                        mutEvalGradeVO.setEvalCd(StringUtil.nvl(vo.getEvalCd()));
                        mutEvalGradeVO.setGradeTitle(mutEvalGradeList.get(j).getGradeTitle());
                        mutEvalGradeVO.setGradeScore(mutEvalGradeList.get(j).getGradeScore());
                        mutEvalGradeVO.setGradeCts(mutEvalGradeList.get(j).getGradeCts());
                        mutEvalGradeVO.setRgtrId(StringUtil.nvl(vo.getRgtrId()));
                        mutEvalGradeVO.setMdfrId(StringUtil.nvl(vo.getMdfrId()));
                        mutEvalGradeDAO.insertMutEvalGrade(mutEvalGradeVO);
                    }
                }
            }
        }
        resultVO.setReturnVO(vo);

        return resultVO;
    }

    // 루브릭 관리자 등록 + 본인 등록 조회
    @Override
    public List<MutEvalVO> selectRegList(MutEvalRltnVO vo) throws Exception {
        return mutEvalDAO.selectRegList(vo);
    }

    /*****************************************************
     * <p>
     * TODO 평가 정보 강의 연결 조회
     * </p>
     * 평가 정보 강의 연결 조회
     *
     * @param MutEvalRltnVO
     * @return List<MutEvalVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<MutEvalVO> listMutEvalByCrsCreCd(MutEvalRltnVO vo) throws Exception {
        return mutEvalDAO.listMutEvalByCrsCreCd(vo);
    }

    /*****************************************************
     * <p>
     * TODO 평가 정보 조회
     * </p>
     * 평가 정보 조회
     *
     * @param MutEvalVO
     * @return MutEvalVO
     * @throws Exception
     ******************************************************/
    @Override
    public MutEvalVO selectMutEval(MutEvalVO vo) throws Exception {
        return mutEvalDAO.selectMutEval(vo);
    }

}
