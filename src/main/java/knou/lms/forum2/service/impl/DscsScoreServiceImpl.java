package knou.lms.forum2.service.impl;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import knou.framework.common.CommConst;
import knou.framework.common.ServiceBase;
import knou.framework.context2.UserContext;
import knou.framework.exception.MediopiaDefineException;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.FileUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.DefaultVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflVO;
import knou.lms.forum2.service.DscsJoinUserService;
import knou.lms.forum2.service.DscsScoreService;
import knou.lms.forum2.service.DscsService;
import knou.lms.forum2.vo.DscsJoinUserVO;
import knou.lms.forum2.vo.DscsVO;

/**
 * 교수자 점수관리와 점수 엑셀 처리 업무를 담당하는 서비스 구현체.
 */
@Service("dscsScoreService")
public class DscsScoreServiceImpl extends ServiceBase implements DscsScoreService {

    private static final Logger LOGGER = LoggerFactory.getLogger(DscsScoreServiceImpl.class);

    @Resource(name = "dscsJoinUserService")
    private DscsJoinUserService dscsJoinUserService;

    @Resource(name = "dscsService")
    private DscsService dscsService;

    @Resource(name = "attachFileService")
    private AttachFileService attachFileService;

    /**
     * 점수관리 화면 진입 시 누락된 토론 참여자 기준 데이터를 보정한다.
     * @param dscsVO
     * @param userId
     */
    @Override
    public void ensureScoreManageJoinUsers(DscsVO dscsVO, String userId) {
        // 점수관리 화면은 참여자 점수 데이터를 기준으로 동작하므로 진입 시 누락 데이터를 보정한다.
        DscsVO paramVO = new DscsVO();
        paramVO.setRgtrId(userId);
        paramVO.setSbjctId(dscsVO.getSbjctId());
        paramVO.setDscsId(dscsVO.getDscsId());
        dscsJoinUserService.prepareJoinUsersForScoring(paramVO);
    }

    /**
     * 교수자 성적관리 참여자 목록을 조회한다.
     */
    @Override
    public ProcessResultVO<DscsJoinUserVO> listScoreJoinUsers(DscsJoinUserVO vo) {
        ProcessResultVO<DscsJoinUserVO> resultVO = dscsJoinUserService.listPaging(vo);
        resultVO.setResult(1);
        return resultVO;
    }

    /**
     * 교수자 성적관리 점수를 저장한다.
     */
    @Override
    public ProcessResultVO<DefaultVO> updateScore(DscsJoinUserVO vo, String userId) {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        dscsJoinUserService.updateDscsJoinUserScore(vo);
        resultVO.setResult(1);

        return resultVO;
    }

    /**
     * 교수자 성적관리 글길이 점수를 반영한다.
     */
    @Override
    public ProcessResultVO<DefaultVO> updateLenScore(DscsJoinUserVO vo, String userId) {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        dscsJoinUserService.updateDscsJoinUserLenScore(vo);
        resultVO.setResult(1);

        return resultVO;
    }

    /**
     * 성적분포 차트 값을 조회한다.
     */
    @Override
    public ProcessResultVO<HashMap<String, Object>> scoreSummaryChart(DscsVO vo) {
        ProcessResultVO<HashMap<String, Object>> resultVO = new ProcessResultVO<HashMap<String, Object>>();

        EgovMap scoreMap = dscsService.viewScoreChart(vo);
        HashMap<String, Object> returnMap = new HashMap<String, Object>();
        returnMap.put("minScore", getScoreSummaryValue(scoreMap, "minScore", "minscore", "MINSCORE", "MIN_SCORE"));
        returnMap.put("maxScore", getScoreSummaryValue(scoreMap, "maxScore", "maxscore", "MAXSCORE", "MAX_SCORE"));
        returnMap.put("avgScore", getScoreSummaryValue(scoreMap, "avgScore", "avgscore", "AVGSCORE", "AVG_SCORE"));

        resultVO.setReturnVO(returnMap);
        resultVO.setResult(1);

        return resultVO;
    }

    private Object getScoreSummaryValue(EgovMap scoreMap, String... keys) {
        if (scoreMap == null) {
            return 0;
        }

        for (String key : keys) {
            Object value = scoreMap.get(key);
            if (value != null) {
                return value;
            }
        }

        return 0;
    }

    /**
     * 토론 참여자의 최소/최대/평균 점수를 계산해 화면 표시용 Map으로 반환한다.
     * @param dscsId
     * @return
     */
    @Override
    public Map<String, Integer> calculateScoreSummary(String dscsId) {
        // 화면과 차트에서 사용하는 단순 표시값이므로 별도 VO 대신 Map으로 반환한다.
        DscsJoinUserVO dscsJoinUserVO = new DscsJoinUserVO();
        dscsJoinUserVO.setDscsId(dscsId);

        List<?> dscsJoinUserList = dscsJoinUserService.dscsJoinUserList(dscsJoinUserVO);
        int minScore = 0;
        int maxScore = 0;
        int totalScore = 0;
        int score = 0;
        int avgScore = 0;

        if (dscsJoinUserList.size() > 0) {
            for (int i = 0; i < dscsJoinUserList.size(); i++) {
                EgovMap egovMap = (EgovMap) dscsJoinUserList.get(i);
                BigDecimal tmpScore = (BigDecimal) egovMap.get("scr");
                long befScore = tmpScore.longValue();
                score = Long.valueOf(befScore).intValue();

                if (i == 0) {
                    minScore = score;
                    maxScore = score;
                } else {
                    if (minScore > score) {
                        minScore = score;
                    }
                    if (maxScore < score) {
                        maxScore = score;
                    }
                }
                totalScore = totalScore + score;
            }
            avgScore = totalScore / dscsJoinUserList.size();
        }

        Map<String, Integer> summary = new HashMap<String, Integer>();
        summary.put("minScore", minScore);
        summary.put("maxScore", maxScore);
        summary.put("avgScore", avgScore);
        return summary;
    }

    /**
     * 참여점수를 반영한다.
     */
    @Override
    public ProcessResultVO<DefaultVO> participateScore(DscsJoinUserVO vo, String userId) {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        vo.setSearchKey("JOIN");
        dscsJoinUserService.participateScore(vo);
        vo.setSearchKey("NOTJOIN");
        dscsJoinUserService.participateScore(vo);
        resultVO.setResult(1);

        return resultVO;
    }

    /**
     * 점수 비율을 반영한다.
     */
    @Override
    public ProcessResultVO<DefaultVO> setScoreRatio(DscsJoinUserVO vo, String userId) {
        ProcessResultVO<DefaultVO> resultVO = new ProcessResultVO<DefaultVO>();

        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        vo.setUserId(userId);
        dscsJoinUserService.setScoreRatio(vo);
        resultVO.setResult(1);

        return resultVO;
    }

    /**
     * 업로드된 점수 엑셀 파일을 첨부로 등록한 뒤 참여자 점수에 반영한다.
     * @param dscsJoinUserVO
     * @param userCtx
     * @return
     */
    @Override
    public ProcessResultVO<DscsJoinUserVO> uploadScoreExcel(DscsJoinUserVO dscsJoinUserVO, UserContext userCtx) {
        // 업로드 파일은 첨부 테이블에 등록한 뒤 ExcelUtilPoi로 읽어 점수 반영 서비스에 전달한다.
        String uploadFiles = dscsJoinUserVO.getUploadFiles();
        String uploadPath = dscsJoinUserVO.getUploadPath();

        String userId = StringUtil.nvl(userCtx.getUserId());
        dscsJoinUserVO.setRgtrId(userId);
        dscsJoinUserVO.setMdfrId(userId);

        String dscsUnitTycd = StringUtil.nvl(dscsJoinUserVO.getDscsUnitTycd());

        ProcessResultVO<DscsJoinUserVO> resultVO = new ProcessResultVO<DscsJoinUserVO>();
        try {
            List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(uploadFiles, uploadPath);
            if (uploadFileList.size() > 0) {
                for (AtflVO atflVO : uploadFileList) {
                    atflVO.setRefId(dscsJoinUserVO.getDscsId());
                    atflVO.setRgtrId(dscsJoinUserVO.getRgtrId());
                    atflVO.setMdfrId(dscsJoinUserVO.getMdfrId());
                    atflVO.setAtflRepoId(CommConst.REPO_DSCS);
                }
                attachFileService.insertAtflList(uploadFileList);
            }

            AtflVO atflVO = uploadFileList.get(0);

            HashMap<String, Object> excelMap = new HashMap<String, Object>();
            excelMap.put("startRaw", 4);
            excelMap.put("excelGrid", dscsJoinUserVO.getExcelGrid());
            excelMap.put("atflVO", atflVO);
            excelMap.put("searchKey", "excelUpload");

            ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
            List<?> list = excelUtilPoi.simpleReadGrid(excelMap);

            dscsJoinUserService.updateExampleExcelScore(dscsJoinUserVO, list, dscsUnitTycd);
            resultVO.setResult(1);
        } catch (MediopiaDefineException e) {
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        } catch (Exception e) {
            LOGGER.debug("e: ", e);
            resultVO.setResult(-1);
        } finally {
            if (ValidationUtils.isNotEmpty(uploadFiles) && ValidationUtils.isNotEmpty(uploadPath)) {
                try {
                    FileUtil.delUploadFileList(uploadFiles, uploadPath);
                } catch (Exception e) {
                    LOGGER.debug("delete uploaded score excel failed: ", e);
                }
            }
        }
        return resultVO;
    }
}
