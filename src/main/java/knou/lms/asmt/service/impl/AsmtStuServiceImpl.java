package knou.lms.asmt.service.impl;

import knou.framework.util.StringUtil;
import knou.framework.vo.FileVO;
import knou.lms.asmt.dao.*;
import knou.lms.asmt.service.AsmtStuService;
import knou.lms.asmt.vo.AsmtVO;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.log.lesson.service.LogLessonActnHstyService;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service("asmtStuService")
public class AsmtStuServiceImpl extends EgovAbstractServiceImpl implements AsmtStuService {

    /**
     * service
     */
    @Autowired
    private SysFileService sysFileService;

    @Resource(name="asmtDAO")
    private AsmtDAO asmtDAO;

    @Resource(name="asmtStuDAO")
    private AsmtStuDAO asmtStuDAO;

    @Resource(name="asmtStuIndiDAO")
    private AsmtStuIndiDAO asmtStuIndiDAO;

    @Resource(name="asmtStuTeamDAO")
    private AsmtStuTeamDAO asmtStuTeamDAO;

    @Resource(name="asmtCmntDAO")
    private AsmtCmntDAO asmtCmntDAO;

    @Resource(name="logLessonActnHstyService")
    private LogLessonActnHstyService logLessonActnHstyService;

    // 과제 조회
    @Override
    public ProcessResultVO<AsmtVO> selectAsmnt(AsmtVO vo) {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        if("OBJECT".equals(vo.getSelectType())) {
            resultVO = selectObject(vo);
        } else if("LIST".equals(vo.getSelectType())) {
            resultVO = selectList(vo);
        } else if("PAGE".equals(vo.getSelectType())) {
            resultVO = selectListPaging(vo);
        }
        return resultVO;
    }

    // 단건 조회
    @Override
    public ProcessResultVO<AsmtVO> selectObject(AsmtVO vo) {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {
            AsmtVO rVo = asmtStuDAO.selectObject(vo);

            FileVO fileVO = new FileVO();
            fileVO.setRepoCd("ASMNT");
            fileVO.setFileBindDataSn(rVo.getAsmtId());

            rVo.setFileList(sysFileService.list(fileVO).getReturnList());
            resultVO.setReturnVO(rVo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }
        return resultVO;
    }

    // 다건 조회
    @Override
    public ProcessResultVO<AsmtVO> selectList(AsmtVO vo) {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {
            resultVO.setReturnList(asmtStuDAO.selectList(vo));
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }
        return resultVO;
    }

    // 페이징 조회
    @Override
    public ProcessResultVO<AsmtVO> selectListPaging(AsmtVO vo) {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {

            PaginationInfo paginationInfo = new PaginationInfo();
            paginationInfo.setCurrentPageNo(vo.getPageIndex());
            paginationInfo.setRecordCountPerPage(vo.getListScale());
            paginationInfo.setPageSize(vo.getListScale());

            vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
            vo.setLastIndex(paginationInfo.getLastRecordIndex());

            List<AsmtVO> listPaging = asmtStuDAO.selectListPaging(vo);

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

    // 과제 등록
    @Override
    public void insertAsmnt(AsmtVO vo) throws Exception {
        String crsCreCd = vo.getCrsCreCd();
        String asmntCd = vo.getAsmtId();
        String sbmsnStscd = "SUBMIT";

        // 제출기한 검증
        AsmtVO asmtVO = new AsmtVO();
        asmtVO.setCrsCreCd(crsCreCd);
        asmtVO.setAsmtId(asmntCd);
        asmtVO = asmtStuDAO.selectObject(vo);

        String sendPeriodYn = asmtVO.getSbmsnPrdyn(); // 제출기한여부

        if(!"Y".equals(StringUtil.nvl(sendPeriodYn))) {
            String extSendAcptYn = asmtVO.getExtdSbmsnPrmyn(); // 지각제출 허용여부
            String extPeriodYn = asmtVO.getExtdSbmsnPrdyn(); // 지각제출 기한여부

            String resendYn = asmtVO.getResbmsnyn(); // 재제출 대상자여부
            String resendPeriodYn = asmtVO.getResbmsnPrdyn(); // 재재출 기간여부

            /* 지각제출 기한 종료 후 재재출 기간이 설정됨 */

            if("Y".equals(StringUtil.nvl(extSendAcptYn)) && "Y".equals(StringUtil.nvl(extPeriodYn))) {
                // 지각제출
                sbmsnStscd = "LATE";
            } else if("Y".equals(StringUtil.nvl(resendYn)) && "Y".equals(StringUtil.nvl(resendPeriodYn))) {
                // 재체출
                sbmsnStscd = "RE";
            } else {
                throw processException("asmnt.alert.not.send.date"); // 과제 제출기간이 아닙니다.
            }
        }

        vo.setSbmsnStscd(sbmsnStscd);

        if("Y".equals(vo.getTeamAsmtStngyn())) {

            List<AsmtVO> tList = asmtStuTeamDAO.selectTeamList(vo);

            for(int i = 0; i < tList.size(); i++) {
                vo.setAsmtSbmsnId(tList.get(i).getAsmtSbmsnId());
                vo.setUserId(tList.get(i).getUserId());
                vo.setUserId(tList.get(i).getUserId());

                if(!"".equals(StringUtil.nvl(tList.get(i).getFileIds()))) {
                    String[] delFileIds = tList.get(i).getFileIds().split(",");
                    vo.setDelFileIds(delFileIds);
                }

                this.insertFileInfo(vo, vo.getAsmtSbmsnId(), i == tList.size() - 1 ? "Y" : "N");

                asmtStuIndiDAO.updateTarget(vo);
                asmtStuIndiDAO.updateTargetFile(vo);

//                vo.setHstyCd(IdGenerator.getNewId("HYST"));
                asmtStuIndiDAO.insertTargetHsty(vo);
            }

        } else {
            this.insertFileInfo(vo, vo.getAsmtSbmsnId(), "Y");

            asmtStuIndiDAO.updateTarget(vo);
            asmtStuIndiDAO.updateTargetFile(vo);

//            vo.setHstyCd(IdGenerator.getNewId("HYST"));
            asmtStuIndiDAO.insertTargetHsty(vo);
        }
    }

    // (개인)참여자 조회
    @Override
    public ProcessResultVO<AsmtVO> selectJoinIndi(AsmtVO vo) {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {

            if("OBJECT".equals(vo.getSelectType())) {
                AsmtVO rVo = asmtStuIndiDAO.selectObject(vo);

                FileVO fileVO = new FileVO();
                fileVO.setRepoCd("ASMNT");
                fileVO.setFileBindDataSn(rVo.getAsmtSbmsnId());

                rVo.setFileList(sysFileService.list(fileVO).getReturnList());
                resultVO.setReturnVO(rVo);
            } else if("LIST".equals(vo.getSelectType())) {
                resultVO.setReturnList(asmtStuIndiDAO.selectList(vo));
            } else if("PAGE".equals(vo.getSelectType())) {
                PaginationInfo paginationInfo = new PaginationInfo();
                paginationInfo.setCurrentPageNo(vo.getPageIndex());
                paginationInfo.setRecordCountPerPage(vo.getListScale());
                paginationInfo.setPageSize(vo.getListScale());

                vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
                vo.setLastIndex(paginationInfo.getLastRecordIndex());

                List<AsmtVO> listPaging = asmtStuIndiDAO.selectListPaging(vo);

                if(listPaging.size() > 0) {
                    paginationInfo.setTotalRecordCount(listPaging.get(0).getTotalCnt());
                } else {
                    paginationInfo.setTotalRecordCount(0);
                }

                resultVO.setReturnList(listPaging);
                resultVO.setPageInfo(paginationInfo);
            }
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }
        return resultVO;
    }

    // 상호평가 조회
    @Override
    public ProcessResultVO<AsmtVO> selectEval(AsmtVO vo) {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {
            resultVO.setReturnVO(asmtStuIndiDAO.selectEval(vo));
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }
        return resultVO;
    }

    // 상호평가 등록
    @Override
    public ProcessResultVO<AsmtVO> insertEval(AsmtVO vo) {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {
            AsmtVO gVo = asmtStuIndiDAO.selectEval(vo);
            if(gVo != null) {
                asmtStuIndiDAO.updateEval(vo);
            } else {
                asmtStuIndiDAO.insertEval(vo);
            }
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }
        return resultVO;
    }

    // 우수과제 조회
    @Override
    public ProcessResultVO<AsmtVO> selectBest(AsmtVO vo) {
        ProcessResultVO<AsmtVO> resultVO = new ProcessResultVO<AsmtVO>();

        try {
            resultVO.setReturnList(asmtStuIndiDAO.selectBest(vo));
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }
        return resultVO;
    }

    public FileVO insertFileInfo(AsmtVO vo, String nSn, String delYn) throws Exception {

        FileVO fVo = new FileVO();
        fVo.setOrgId(vo.getOrgId());
        fVo.setUserId(vo.getUserId());
        fVo.setRepoCd("ASMNT");
        fVo.setFilePath(vo.getUploadPath());
        fVo.setFileBindDataSn(nSn);
        fVo.setUploadFiles(vo.getUploadFiles());
        fVo.setDelFileIds(vo.getDelFileIds());
        fVo.setOrginDelYn(delYn);

        sysFileService.insertFileInfo(fVo);

        return fVo;
    }

}
