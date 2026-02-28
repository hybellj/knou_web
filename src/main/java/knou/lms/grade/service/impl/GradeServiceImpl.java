package knou.lms.grade.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.dao.CrecrsDAO;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.grade.dao.GradeDAO;
import knou.lms.grade.service.GradeService;
import knou.lms.grade.vo.GradeStdScoreItemVO;
import knou.lms.grade.vo.GradeVO;
import knou.lms.log.sysjobsch.dao.LogSysJobSchExcDAO;
import knou.lms.log.sysjobsch.vo.LogSysJobSchExcVO;
import knou.lms.score.dao.ScoreDAO;
import knou.lms.sys.dao.SysJobSchDAO;
import knou.lms.sys.dao.SysJobSchExcDAO;
import knou.lms.sys.vo.SysJobSchExcVO;
import knou.lms.sys.vo.SysJobSchVO;

@Service("gradeService")
public class GradeServiceImpl extends EgovAbstractServiceImpl implements GradeService {
    @Autowired
    private GradeDAO gradeDAO;

    @Autowired
    private ScoreDAO scoreDAO;
    
    @Autowired
    private SysJobSchDAO sysJobSchDAO;
    
    @Autowired
    private SysJobSchExcDAO sysJobSchExcDAO;
    
    @Autowired
    private LogSysJobSchExcDAO logSysJobSchExcDAO;

    @Resource(name="crecrsDAO")
    private CrecrsDAO crecrsDAO;

    @Override
    public ProcessResultVO<GradeVO> selectTermList(GradeVO vo) throws Exception {

        ProcessResultVO<GradeVO> resultVO = new ProcessResultVO<GradeVO>();
        try {
            List<GradeVO> resultList = gradeDAO.selectTermList(vo);

            resultVO.setReturnList(resultList);
            resultVO.setResult(1);
        } catch(Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }

        return resultVO;
    }


    @Override
    public ProcessResultVO<GradeVO> selectDeptList(GradeVO vo) throws Exception {

        ProcessResultVO<GradeVO> resultVO = new ProcessResultVO<GradeVO>();
        try {
            List<GradeVO> resultList = gradeDAO.selectDeptList(vo);

            resultVO.setReturnList(resultList);
            resultVO.setResult(1);
        } catch(Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }

        return resultVO;
    }

    @Override
    public ProcessResultVO<GradeVO> selectEvlList(GradeVO vo) throws Exception {

        ProcessResultVO<GradeVO> resultVO = new ProcessResultVO<GradeVO>();
        String [] crsTypeCds;
        try {

            if(StringUtils.isNotEmpty(vo.getCrsTypeCd())) {
                crsTypeCds = vo.getCrsTypeCd().split(",");

                vo.setCrsTypeCds(crsTypeCds);
            }

            List<GradeVO> resultList = gradeDAO.selectEvlList(vo);

            resultVO.setReturnList(resultList);
            resultVO.setResult(1);
        } catch(Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }
        return resultVO;
    }

    @Override
    public ProcessResultVO<GradeVO> multiEvlList(GradeVO vo) throws Exception {

        ProcessResultVO<GradeVO> resultVO = new ProcessResultVO<GradeVO>();
        try {
            gradeDAO.multiEvlList(vo);

            resultVO.setResult(1);
        } catch(Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }
        return resultVO;
    }

    @Override
    public List<GradeVO> selectEvlExcelList(GradeVO vo) throws Exception {
        String [] crsTypeCds;

        if(StringUtils.isNotEmpty(vo.getCrsTypeCd())) {
            crsTypeCds = vo.getCrsTypeCd().split(",");

            vo.setCrsTypeCds(crsTypeCds);
        }

        return gradeDAO.selectEvlList(vo);
    }

    @Override
    public ProcessResultVO<GradeVO> selectEvlStandardList(GradeVO vo) throws Exception {
        ProcessResultVO<GradeVO> resultVO = new ProcessResultVO<GradeVO>();
        String [] crsTypeCds;
        try {

            if(StringUtils.isNotEmpty(vo.getCrsTypeCd())) {
                crsTypeCds = vo.getCrsTypeCd().split(",");

                vo.setCrsTypeCds(crsTypeCds);
            }

            List<GradeVO> resultList = gradeDAO.selectEvlStandardList(vo);

            resultVO.setReturnList(resultList);
            resultVO.setResult(1);
        } catch(Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }

        return resultVO;
    }

    @Override
    public ProcessResultVO<GradeVO> selectStdScoreItemConfInfo(GradeVO vo) throws Exception {
        ProcessResultVO<GradeVO> resultVO = new ProcessResultVO<GradeVO>();
        try {

            GradeVO resultVo = gradeDAO.selectStdScoreItemConfInfo(vo);

            resultVO.setReturnVO(resultVo);
            resultVO.setResult(1);
        } catch(Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }
        return resultVO;
    }

    @Override
    public ProcessResultVO<GradeStdScoreItemVO> selectEvlReg(GradeVO vo) throws Exception {

        ProcessResultVO<GradeStdScoreItemVO> resultVO = new ProcessResultVO<GradeStdScoreItemVO>();
        int totCnt = 0;
        String crsTypeCd = "";
        List<GradeStdScoreItemVO> resultList = null;

        try {
            crsTypeCd = gradeDAO.selectCrsTypeCdToCrsCreCd(vo);

            vo.setCrsTypeCd(crsTypeCd);

            totCnt = gradeDAO.selectScoreItemConfCnt(vo);

            if(totCnt > 0) {
                resultList = gradeDAO.selectStdScoreItemConfList(vo);
                resultVO.setResult(1);
            } else {
                resultList = gradeDAO.selectStdOrgScoreItemConfInitList(vo);
                resultVO.setResult(0);
            }

            resultVO.setReturnList(resultList);
        } catch(Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }

        return resultVO;
    }

    @Override
    public ProcessResultVO<GradeStdScoreItemVO> multiEvlPopReg(GradeVO vo) throws Exception {

        ProcessResultVO<GradeStdScoreItemVO> resultVO = new ProcessResultVO<GradeStdScoreItemVO>();
        GradeStdScoreItemVO paramVo = null;
        String crsTypeCd = "";

        try {
            crsTypeCd = gradeDAO.selectCrsTypeCdToCrsCreCd(vo);

            for(int i=0; i < vo.getScoreList().size(); i++) {
                paramVo = new GradeStdScoreItemVO();

                paramVo.setCrsCreCd( vo.getCrsCreCd() );
                paramVo.setScoreItemOrder(vo.getScoreList().get(i).getScoreItemOrder());
                paramVo.setScoreRatio(vo.getScoreList().get(i).getScoreRatio());
                paramVo.setRgtrId( vo.getUserId() );
                paramVo.setMdfrId( vo.getUserId() );
                paramVo.setOrgId( vo.getOrgId() );
                paramVo.setCrsTypeCd(crsTypeCd);

                if("A".equals(vo.getGubun())) {
                    gradeDAO.insertStdScoreItemConf(paramVo);
                } else if("E".equals(vo.getGubun())) {
                    paramVo.setScoreItemId( vo.getScoreList().get(i).getScoreItemId() );
                    gradeDAO.multiStdScoreItemConf(paramVo);
                }
            }
            resultVO.setResult(1);
        } catch(Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }
        return resultVO;
    }

    @Override
    public ProcessResultVO<GradeVO> selectCreCrsList(GradeVO vo) throws Exception {

        ProcessResultVO<GradeVO> resultVO = new ProcessResultVO<GradeVO>();
        try {
            List<GradeVO> resultList = gradeDAO.selectCreCrsList(vo);

            resultVO.setReturnList(resultList);
            resultVO.setResult(1);
        } catch(Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }
        return resultVO;
    }

    @Override
    public List<GradeVO> listCreCrsGradeStatus(GradeVO vo) throws Exception {
        return gradeDAO.listCreCrsGradeStatus(vo);
    }

    @Override
    public List<GradeVO> listStdGradeStatus(GradeVO vo) throws Exception {
        
        return gradeDAO.listStdGradeStatus(vo);
    }
    
    @Override
    public ProcessResultVO<EgovMap> selectEvlStandardListByEgov(GradeVO vo) throws Exception {
        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<EgovMap>();
        String [] crsTypeCds;
        try {

            if(StringUtils.isNotEmpty(vo.getCrsTypeCd())) {
                crsTypeCds = vo.getCrsTypeCd().split(",");

                vo.setCrsTypeCds(crsTypeCds);
            }

            List<EgovMap> resultList = gradeDAO.selectEvlStandardListByEgov(vo);

            resultVO.setReturnList(resultList);
            resultVO.setResult(1);
        } catch(Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }

        return resultVO;
    }


    @Override
    public ProcessResultVO<EgovMap> listGradeInputExc(GradeVO vo) throws Exception {
        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());
        
        String [] crsTypeCds;

        if(StringUtils.isNotEmpty(vo.getCrsTypeCd())) {
            crsTypeCds = vo.getCrsTypeCd().split(",");

            vo.setCrsTypeCds(crsTypeCds);
        }

        List<EgovMap> resultList = gradeDAO.listGradeInputExc(vo);

        if(resultList.size() > 0) {
            paginationInfo.setTotalRecordCount(Integer.parseInt(StringUtil.nvl(resultList.get(0).get("totalCnt"), "0")));
        } else {
            paginationInfo.setTotalRecordCount(0);
        }

        ProcessResultVO<EgovMap> resultVO = new ProcessResultVO<>();

        resultVO.setReturnList(resultList);
        resultVO.setPageInfo(paginationInfo);
        resultVO.setResult(1);

        return resultVO;
    }


    @Override
    public void saveGradeInputExc(GradeVO vo) throws Exception {
        String jobSchSnC;
        String jobSchSnG;
        
        // 학부 일정
        SysJobSchVO sysJobSchVO = new SysJobSchVO();
        sysJobSchVO.setHaksaYear(vo.getCreYear());
        sysJobSchVO.setHaksaTerm(vo.getCreTerm());
        sysJobSchVO.setCalendarCtgr("00210206");
        sysJobSchVO.setOrgId(vo.getOrgId());
        sysJobSchVO = sysJobSchDAO.select(sysJobSchVO);
        
        if(sysJobSchVO == null) {
            throw processException("score.alert.empty.job.sch.score.input"); // 성적입력기간 일정이 없습니다.
        }
        
        jobSchSnC = sysJobSchVO.getSysjobSchdlId();
        
        // 대학원 일정
        sysJobSchVO = new SysJobSchVO();
        sysJobSchVO.setHaksaYear(vo.getCreYear());
        sysJobSchVO.setHaksaTerm(vo.getCreTerm());
        sysJobSchVO.setCalendarCtgr("00210207");
        sysJobSchVO.setOrgId(vo.getOrgId());
        sysJobSchVO = sysJobSchDAO.select(sysJobSchVO);
        
        if(sysJobSchVO == null) {
            throw processException("score.alert.empty.job.sch.score.input"); // 성적입력기간 일정이 없습니다.
        }
        
        jobSchSnG = sysJobSchVO.getSysjobSchdlId();
        
        for(int i = 0; i < vo.getCrsCreCdList().size(); i++) {
            String crsCreCd   = vo.getCrsCreCdList().get(i);
            String schStartDt = vo.getSchStartDtList().get(i);
            String schEndDt   = vo.getSchEndDtList().get(i);
            String jobSchSn;
            
            CreCrsVO creCrsVO = new CreCrsVO();
            creCrsVO.setCrsCreCd(crsCreCd);
            creCrsVO = crecrsDAO.select(creCrsVO);
            
            String uniCd = creCrsVO.getUniCd();
            
            if("G".equals(uniCd)) {
                jobSchSn = jobSchSnG;
            } else {
                jobSchSn = jobSchSnC;
            }
            
            SysJobSchExcVO sjevo = new SysJobSchExcVO();
            sjevo.setSysjobSchdlExcpId(IdGenerator.getNewId("EXC"));
            sjevo.setSysjobSchdlId(jobSchSn);
            sjevo.setCrsCreCd(crsCreCd);
            sjevo.setSysjobSchdlSymd(schStartDt);
            sjevo.setSysjobSchdlEymd(schEndDt);
            sjevo.setSysjobSchdlExcpProcRsnCn(vo.getExcCmntList().get(i));
            sjevo.setRgtrId(vo.getRgtrId());
            sjevo.setMdfrId(vo.getMdfrId());
            sysJobSchExcDAO.insert(sjevo);
            
            String schStartDtStr = schStartDt.substring(0, 4) + "." + schStartDt.substring(4, 6) + "." + schStartDt.substring(6, 8) + " " + schStartDt.substring(8, 10) + ":" + schStartDt.substring(10, 12);
            String schEndDtStr   = schEndDt.substring(0, 4) + "." + schEndDt.substring(4, 6) + "." + schEndDt.substring(6, 8) + " " + schEndDt.substring(8, 10) + ":" + schEndDt.substring(10, 12);
            
            LogSysJobSchExcVO logVO = new LogSysJobSchExcVO();
            logVO.setExcLogSn(IdGenerator.getNewId("LOG"));
            logVO.setCrsCreCd(crsCreCd);
            logVO.setExcLogCts("등록 : " + schStartDtStr + " ~ " + schEndDtStr);
            logVO.setRgtrId(vo.getRgtrId());
            logSysJobSchExcDAO.insert(logVO);
        }
    }
}