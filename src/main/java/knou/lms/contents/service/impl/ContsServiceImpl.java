package knou.lms.contents.service.impl;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import knou.framework.common.CommConst;
import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.FileUtil;
import knou.framework.util.IdGenUtil;
import knou.framework.util.StringUtil;
import knou.lms.common.dto.ResultDTO;
import knou.lms.contents.dao.ContsDAO;
import knou.lms.contents.service.ContsService;
import knou.lms.contents.web.paging.ContsExrcsQstnPageInfo;
import knou.lms.contents.web.paging.ContsPageInfo;
import knou.lms.contents.web.paging.ContsSddnQstnPageInfo;
import knou.lms.contents.vo.ContsSbjctListVO;
import knou.lms.contents.vo.LctrContsDvclasSelVO;
import knou.lms.contents.vo.LctrContsVO;
import knou.lms.contents.vo.LctrWknoContsVO;
import knou.lms.contents.vo.LctrWknoSchdlVO;
import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflVO;

@Service("contsService")
public class ContsServiceImpl extends ServiceBase implements ContsService {

    private static final String CONTS_TYPE_VIDEO = "VIDEO";
    private static final String CONTS_TYPE_EXERC_QSTN = "EXERC_QSTN";
    private static final String CONTS_TYPE_SDDN_QSTN = "SDDN_QSTN";
    private static final String CONTS_TYPE_SRT = "SRT";
    private static final String CONTS_TYPE_SNS_URL = "SNS_URL";
    private static final String CONTS_TYPE_SNS_HTML = "SNS_HTML";
    private static final String VDO_QLTY_GBNCD_SD = "SD";
    private static final String VDO_QLTY_GBNCD_HD = "HD";
    private static final Pattern SNS_IFRAME_PATTERN = Pattern.compile("(?is)<iframe\\b([^>]*)>\\s*</iframe\\s*>");
    private static final Pattern SNS_IFRAME_ATTR_PATTERN = Pattern.compile("([A-Za-z_:][A-Za-z0-9_:.:-]*)(?:\\s*=\\s*(\"([^\"]*)\"|'([^']*)'|([^\\s\"'`=<>]+)))?");
    private static final Set<String> SNS_ALLOWED_URL_HOSTS = Set.of(
            "youtube.com", "www.youtube.com", "m.youtube.com", "youtu.be", "www.youtu.be",
            "youtube-nocookie.com", "www.youtube-nocookie.com",
            "vimeo.com", "www.vimeo.com", "player.vimeo.com",
            "ted.com", "www.ted.com", "embed.ted.com"
    );
    private static final Set<String> SNS_IFRAME_ALLOWED_ATTRS = Set.of(
            "src", "title", "width", "height", "allow", "allowfullscreen", "frameborder",
            "referrerpolicy", "loading", "scrolling", "webkitallowfullscreen", "mozallowfullscreen"
    );
    private static final List<String> SNS_IFRAME_ATTR_ORDER = List.of(
            "width", "height", "src", "title", "frameborder", "allow", "referrerpolicy",
            "loading", "scrolling", "allowfullscreen", "webkitallowfullscreen", "mozallowfullscreen"
    );
    private static final Set<String> SNS_IFRAME_BOOLEAN_ATTRS = Set.of(
            "allowfullscreen", "webkitallowfullscreen", "mozallowfullscreen"
    );
    private static final Set<String> SNS_ALLOWED_REFERRER_POLICIES = Set.of(
            "no-referrer", "no-referrer-when-downgrade", "origin", "origin-when-cross-origin",
            "same-origin", "strict-origin", "strict-origin-when-cross-origin", "unsafe-url"
    );

    @Resource(name = "contsDAO")
    private ContsDAO contsDAO;

    @Resource(name = "attachFileService")
    private AttachFileService attachFileService;

    @Resource(name = "messageSource")
    private MessageSource messageSource;

    /**
     * 무페이징 과목 목록을 조회하고 조회 결과를 반환한다.
     * @param pageInfo
     * @return
     */
    @Override
    public ResultDTO<ContsSbjctListVO> selectAdmLctrContsSbjctList(ContsPageInfo pageInfo) {
        List<ContsSbjctListVO> list = contsDAO.selectAdmLctrContsSbjctList(pageInfo);
        ResultDTO<ContsSbjctListVO> resultDTO = new ResultDTO<ContsSbjctListVO>();
        resultDTO.setReturnList(list);
        return resultDTO.setResultSuccess();
    }

    /**
     * 무페이징 과목 목록을 엑셀 다운로드용으로 조회한다.
     * @param pageInfo
     * @return
     */
    @Override
    public List<ContsSbjctListVO> selectAdmLctrContsSbjctListExcelDown(ContsPageInfo pageInfo) {
        return contsDAO.selectAdmLctrContsSbjctListExcelDown(pageInfo);
    }

    /**
     * 선택 과목의 강의주차 일정과 학습자료를 화면 렌더링 순서대로 반환한다.
     * @param vo
     * @return
     */
    @Override
    public ResultDTO<LctrWknoContsVO> selectAdmLctrWknoContsList(LctrWknoContsVO vo) {
        ResultDTO<LctrWknoContsVO> resultDTO = new ResultDTO<LctrWknoContsVO>();
        resultDTO.setReturnList(contsDAO.selectAdmLctrWknoContsList(vo));
        return resultDTO.setResultSuccess();
    }

    /**
     * 선택한 강의주차일정 수정 대상 정보를 조회한다.
     * @param vo
     * @return
     */
    @Override
    public LctrWknoSchdlVO selectAdmLctrWknoSchdl(LctrWknoSchdlVO vo) {
        return contsDAO.selectAdmLctrWknoSchdl(vo);
    }

    /**
     * 강의주차일정을 수정하고 처리 결과를 반환한다.
     * @param vo
     * @return
     */
    @Override
    public ResultDTO<LctrWknoSchdlVO> updateAdmLctrWknoSchdl(LctrWknoSchdlVO vo) {
        ResultDTO<LctrWknoSchdlVO> resultDTO = new ResultDTO<LctrWknoSchdlVO>();
        ResultDTO<LctrWknoSchdlVO> validationResult = validateLctrWknoSchdl(vo);
        if(validationResult.getResult() < 0) {
            return validationResult;
        }

        int affected = contsDAO.updateAdmLctrWknoSchdl(vo);
        if(affected > 0) {
            return resultDTO.setData(vo).setResultSuccess(getMessage("success.common.update"));/*정상적으로 수정되었습니다.*/
        }
        return resultDTO.setResultFailed(getMessage("fail.common.update"));/*수정이 실패하였습니다.*/
    }

    /**
     * 강의주차일정 수정 요청의 필수값과 날짜 범위를 확인한다.
     * @param vo
     * @return
     */
    private ResultDTO<LctrWknoSchdlVO> validateLctrWknoSchdl(LctrWknoSchdlVO vo) {
        ResultDTO<LctrWknoSchdlVO> resultDTO = new ResultDTO<LctrWknoSchdlVO>();
        if(StringUtil.isNull(vo.getLctrWknoSchdlId()) || StringUtil.isNull(vo.getSbjctId())) {
            return resultDTO.setResultFailed(getMessage("contents.msg.select.week"));/*주차를 선택해 주세요.*/
        }
        if(StringUtil.isNull(vo.getLctrWknonm())) {
            return resultDTO.setResultFailed(getMessage("contents.msg.input.week.name"));/*주차명을 입력해 주세요.*/
        }

        vo.setLctrWknoSymd(normalizeYmd(vo.getLctrWknoSymd()));
        vo.setLctrWknoEymd(normalizeYmd(vo.getLctrWknoEymd()));
        vo.setWknoAtndcRcgSymd(normalizeYmd(vo.getWknoAtndcRcgSymd()));
        vo.setWknoAtndcRcgEymd(normalizeYmd(vo.getWknoAtndcRcgEymd()));

        if(!isYmd(vo.getLctrWknoSymd()) || !isYmd(vo.getLctrWknoEymd())) {
            return resultDTO.setResultFailed(getMessage("contents.msg.input.week.period"));/*주차 기간을 입력해 주세요.*/
        }
        if(vo.getLctrWknoSymd().compareTo(vo.getLctrWknoEymd()) > 0) {
            return resultDTO.setResultFailed(getMessage("contents.msg.invalid.week.period"));/*주차 시작일은 종료일보다 클 수 없습니다.*/
        }
        if(!isYmd(vo.getWknoAtndcRcgSymd()) || !isYmd(vo.getWknoAtndcRcgEymd())) {
            return resultDTO.setResultFailed(getMessage("contents.msg.input.week.attendance.period"));/*출석인정기간을 입력해 주세요.*/
        }
        if(vo.getWknoAtndcRcgSymd().compareTo(vo.getWknoAtndcRcgEymd()) > 0) {
            return resultDTO.setResultFailed(getMessage("contents.msg.invalid.week.attendance.period"));/*출석인정 시작일은 종료일보다 클 수 없습니다.*/
        }

        return resultDTO.setResultSuccess();
    }

    /**
     * 화면 날짜값에서 숫자만 남겨 yyyyMMdd 비교값으로 변환한다.
     * @param value
     * @return
     */
    private String normalizeYmd(String value) {
        return StringUtil.nvl(value).replaceAll("[^0-9]", "");
    }

    /**
     * 날짜값이 yyyyMMdd 형식인지 확인한다.
     * @param value
     * @return
     */
    private boolean isYmd(String value) {
        return value != null && value.matches("[0-9]{8}");
    }

    /**
     * 현재 요청 언어에 맞는 메시지를 반환한다.
     * @param messageKey
     * @return
     */
    private String getMessage(String messageKey) {
        return messageSource.getMessage(messageKey, null, messageKey, LocaleContextHolder.getLocale());
    }

    /**
     * 강의주차 공개여부를 수정하고 처리 결과를 반환한다.
     * @param vo
     * @return
     */
    @Override
    public ResultDTO<LctrWknoContsVO> updateAdmLctrWknoOyn(LctrWknoContsVO vo) {
        ResultDTO<LctrWknoContsVO> resultDTO = new ResultDTO<LctrWknoContsVO>();
        String oyn = StringUtil.nvl(vo.getOyn()).toUpperCase();
        if(!isYn(oyn)) {
            return resultDTO.setResultFailed(getMessage("fail.common.update"));/*수정이 실패하였습니다.*/
        }

        vo.setOyn(oyn);
        int affected = contsDAO.updateAdmLctrWknoOyn(vo);
        if(affected > 0) {
            return resultDTO.setData(vo).setResultSuccess();
        }
        return resultDTO.setResultFailed(getMessage("fail.common.update"));/*수정이 실패하였습니다.*/
    }

    /**
     * 강의주차 순차학습여부를 수정하고 처리 결과를 반환한다.
     * @param vo
     * @return
     */
    @Override
    public ResultDTO<LctrWknoContsVO> updateAdmLctrWknoSeqLrnyn(LctrWknoContsVO vo) {
        ResultDTO<LctrWknoContsVO> resultDTO = new ResultDTO<LctrWknoContsVO>();
        String seqLrnyn = StringUtil.nvl(vo.getSeqLrnyn()).toUpperCase();
        if(!isYn(seqLrnyn)) {
            return resultDTO.setResultFailed(getMessage("fail.common.update"));/*수정이 실패하였습니다.*/
        }

        vo.setSeqLrnyn(seqLrnyn);
        int affected = contsDAO.updateAdmLctrWknoSeqLrnyn(vo);
        if(affected > 0) {
            return resultDTO.setData(vo).setResultSuccess();
        }
        return resultDTO.setResultFailed(getMessage("fail.common.update"));/*수정이 실패하였습니다.*/
    }

    /**
     * 관리자 학습목차 콘텐츠 상세 조회
     * @param vo
     * @return
     */
    @Override
    public LctrContsVO selectAdmLctrConts(LctrContsVO vo) {
        return contsDAO.selectAdmLctrConts(vo);
    }

    /**
     * 동영상 팝업 업로드 경로 구성을 위한 과목 정보를 조회한다.
     * @param vo
     * @return
     */
    @Override
    public LctrContsVO selectAdmLctrContsUploadContext(LctrContsVO vo) {
        return contsDAO.selectAdmLctrContsUploadContext(vo);
    }

    /**
     * 학습목차 콘텐츠의 하위 콘텐츠 목록을 조회한다.
     * @param vo
     * @return
     */
    @Override
    public List<LctrContsVO> selectAdmLctrContsChildren(LctrContsVO vo) {
        return contsDAO.selectAdmLctrContsChildren(vo);
    }

    /**
     * 관리자 학습목차 주차 콘텐츠 목록을 조회한다.
     * @param vo
     * @return
     */
    @Override
    public List<LctrContsVO> selectAdmLctrContsWeekList(LctrContsVO vo) {
        return contsDAO.selectAdmLctrContsWeekList(vo);
    }

    /**
     * 관리자 학습목차 콘텐츠 분반 목록을 조회한다.
     * @param vo
     * @return
     */
    @Override
    public List<LctrContsDvclasSelVO> selectAdmLctrContsDvclasList(LctrContsVO vo) {
        return contsDAO.selectAdmLctrContsDvclasList(vo);
    }

    /**
     * 관리자 학습목차 콘텐츠 분반 대상 주차 보유 목록을 조회한다.
     * @param vo
     * @return
     */
    @Override
    public List<LctrContsDvclasSelVO> selectAdmLctrContsDvclasTargetList(LctrContsVO vo) {
        return contsDAO.selectAdmLctrContsDvclasTargetList(vo);
    }

    /**
     * 관리자 학습목차 콘텐츠를 등록하거나 수정한다.
     * @param vo
     * @return
     */
    @Override
    public ResultDTO<LctrContsVO> saveAdmLctrConts(LctrContsVO vo) {
        // 동영상은 화질별 파일, 자막, 돌발퀴즈 하위 콘텐츠를 함께 저장한다.
        if(CONTS_TYPE_VIDEO.equals(StringUtil.nvl(vo.getLctrContsTycd()).toUpperCase())) {
            return saveAdmLctrContsVideo(vo);
        }
        if(CONTS_TYPE_EXERC_QSTN.equals(StringUtil.nvl(vo.getLctrContsTycd()).toUpperCase())) {
            return saveAdmLctrContsExrcsQstn(vo);
        }

        // 콘텐츠 ID가 없으면 신규 등록, 있으면 기존 콘텐츠를 수정한다.
        if(StringUtil.isNull(vo.getLctrContsId())) {
            return insertAdmLctrConts(vo);
        }
        return updateAdmLctrConts(vo);
    }

    /**
     * 관리자 학습목차 콘텐츠를 등록한다.
     * @param vo
     * @return
     */
    @Override
    @Transactional
    public ResultDTO<LctrContsVO> insertAdmLctrConts(LctrContsVO vo) {
        ResultDTO<LctrContsVO> resultDTO = validateLctrConts(vo);
        if(resultDTO.getResult() < 0) {
            return resultDTO;
        }

        prepareInsertLctrConts(vo);
        adjustLctrContsSeqnoForInsert(vo);
        int affected = contsDAO.insertAdmLctrConts(vo);
        if(affected > 0) {
            return new ResultDTO<LctrContsVO>().setData(vo).setResultSuccess(getMessage("success.common.insert"));/*정상적으로 등록되었습니다.*/
        }
        return new ResultDTO<LctrContsVO>().setResultFailed(getMessage("fail.common.insert"));/*생성이 실패하였습니다.*/
    }

    /**
     * 관리자 학습목차 콘텐츠 수정
     * @param vo
     * @return
     */
    @Override
    @Transactional
    public ResultDTO<LctrContsVO> updateAdmLctrConts(LctrContsVO vo) {
        ResultDTO<LctrContsVO> resultDTO = validateLctrConts(vo);
        if(resultDTO.getResult() < 0) {
            return resultDTO;
        }
        if(StringUtil.isNull(vo.getLctrContsId())) {
            return resultDTO.setResultFailed(getMessage("fail.common.update"));/*수정이 실패하였습니다.*/
        }

        prepareSaveLctrConts(vo);
        adjustLctrContsSeqnoForUpdate(vo);
        int affected = contsDAO.updateAdmLctrConts(vo);
        if(affected > 0) {
            return new ResultDTO<LctrContsVO>().setData(vo).setResultSuccess(getMessage("success.common.update"));/*정상적으로 수정되었습니다.*/
        }
        return new ResultDTO<LctrContsVO>().setResultFailed(getMessage("fail.common.update"));/*수정이 실패하였습니다.*/
    }

    /**
     * 동영상 콘텐츠와 화질별 파일, 자막, 돌발퀴즈 하위 콘텐츠를 저장한다.
     * @param vo
     * @return
     */
    @Override
    @Transactional
    public ResultDTO<LctrContsVO> saveAdmLctrContsVideo(LctrContsVO vo) {
        vo.setLctrContsTycd(CONTS_TYPE_VIDEO);
        ResultDTO<LctrContsVO> resultDTO = validateLctrConts(vo);
        if(resultDTO.getResult() < 0) {
            return resultDTO;
        }

        boolean insertMode = StringUtil.isNull(vo.getLctrContsId());
        int affected;
        if(insertMode) {
            prepareInsertLctrConts(vo);
            adjustLctrContsSeqnoForInsert(vo);
            affected = contsDAO.insertAdmLctrConts(vo);
        } else {
            prepareSaveLctrConts(vo);
            adjustLctrContsSeqnoForUpdate(vo);
            affected = contsDAO.updateAdmLctrConts(vo);
        }

        if(affected < 1) {
            if(insertMode) {
                return resultDTO.setResultFailed(getMessage("fail.common.insert"));/*생성이 실패하였습니다.*/
            }
            return resultDTO.setResultFailed(getMessage("fail.common.update"));/*수정이 실패하였습니다.*/
        }

        saveVideoFileChild(vo, vo.getSdVideoContsId(), vo.getSdVideoUploadFiles(), vo.getSdVideoUploadPath(), vo.getSdVideoDelFileIdStr(), "저화질", VDO_QLTY_GBNCD_SD);
        saveVideoFileChild(vo, vo.getHdVideoContsId(), vo.getHdVideoUploadFiles(), vo.getHdVideoUploadPath(), vo.getHdVideoDelFileIdStr(), "고화질", VDO_QLTY_GBNCD_HD);
        saveSrtChildren(vo);
        saveSddnQstnChildren(vo);

        if(insertMode) {
            return resultDTO.setData(vo).setResultSuccess(getMessage("success.common.insert"));/*정상적으로 등록되었습니다.*/
        }
        return resultDTO.setData(vo).setResultSuccess(getMessage("success.common.update"));/*정상적으로 수정되었습니다.*/
    }

    /**
     * 관리자 학습목차 연습문제 콘텐츠를 등록하거나 수정한다.
     * @param vo
     * @return
     */
    @Override
    @Transactional
    public ResultDTO<LctrContsVO> saveAdmLctrContsExrcsQstn(LctrContsVO vo) {
        vo.setLctrContsTycd(CONTS_TYPE_EXERC_QSTN);
        if(StringUtil.isNull(vo.getContsnm())) {
            vo.setContsnm("-");
        }

        ResultDTO<LctrContsVO> resultDTO = validateExrcsQstnConts(vo);
        if(resultDTO.getResult() < 0) {
            return resultDTO;
        }

        boolean insertMode = StringUtil.isNull(vo.getLctrContsId());
        if(insertMode) {
            List<LctrContsVO> insertList = buildExrcsQstnInsertList(vo, resultDTO);
            if(resultDTO.getResult() < 0) {
                return resultDTO;
            }
            if(insertList.isEmpty()) {
                return resultDTO.setResultFailed(getMessage("fail.common.insert"));/*생성이 실패하였습니다.*/
            }

            for(LctrContsVO insertVO : insertList) {
                adjustLctrContsSeqnoForInsert(insertVO);
            }
            int affected = contsDAO.insertAdmLctrContsBatch(insertList);
            if(affected > 0) {
                return resultDTO.setData(vo).setResultSuccess(getMessage("success.common.insert"));/*정상적으로 등록되었습니다.*/
            }
            return resultDTO.setResultFailed(getMessage("fail.common.insert"));/*생성이 실패하였습니다.*/
        }

        prepareSaveLctrConts(vo);
        adjustLctrContsSeqnoForUpdate(vo);
        int affected = contsDAO.updateAdmLctrConts(vo);
        if(affected > 0) {
            return resultDTO.setData(vo).setResultSuccess(getMessage("success.common.update"));/*정상적으로 수정되었습니다.*/
        }
        return resultDTO.setResultFailed(getMessage("fail.common.update"));/*수정이 실패하였습니다.*/
    }

    /**
     * 연습문제 콘텐츠 등록 대상 분반별 저장 목록을 구성한다.
     * @param vo
     * @param resultDTO
     * @return
     */
    private List<LctrContsVO> buildExrcsQstnInsertList(LctrContsVO vo, ResultDTO<LctrContsVO> resultDTO) {
        Map<String, LctrContsVO> targetMap = new LinkedHashMap<String, LctrContsVO>();
        LctrContsVO baseParam = new LctrContsVO();
        baseParam.setOrgId(vo.getOrgId());
        baseParam.setSbjctId(vo.getSbjctId());
        baseParam.setLctrWkno(vo.getLctrWkno());
        LctrContsVO baseLctr = contsDAO.selectAdmLctrContsTargetLctr(baseParam);
        if(baseLctr == null || StringUtil.isNull(baseLctr.getLctrId())) {
            resultDTO.setResultFailed(getMessage("contents.msg.no.target.week"));/*?좏깮??遺꾨컲???숈씪??二쇱감/媛뺤쓽 ?뺣낫媛 ?놁뒿?덈떎.*/
            return new ArrayList<LctrContsVO>();
        }
        targetMap.put(vo.getSbjctId(), createExrcsQstnInsertVO(vo, baseLctr.getLctrId(), vo.getSbjctId(), baseLctr.getLctrWknoSchdlId()));

        List<LctrContsDvclasSelVO> dvclasSelList = vo.getDvclasSelList();
        if(dvclasSelList != null) {
            for(LctrContsDvclasSelVO dvclasSelVO : dvclasSelList) {
                if(dvclasSelVO == null || !"Y".equalsIgnoreCase(dvclasSelVO.getCheckedYn())) {
                    continue;
                }
                String targetSbjctId = StringUtil.nvl(dvclasSelVO.getSbjctId()).trim();
                if(StringUtil.isNull(targetSbjctId) || targetMap.containsKey(targetSbjctId)) {
                    continue;
                }

                // 선택 분반은 현재 주차 번호와 같은 대상 강의를 찾아 새 콘텐츠로 복제한다.
                LctrContsVO targetParam = new LctrContsVO();
                targetParam.setOrgId(vo.getOrgId());
                targetParam.setSbjctId(targetSbjctId);
                targetParam.setLctrWkno(vo.getLctrWkno());
                LctrContsVO targetLctr = contsDAO.selectAdmLctrContsTargetLctr(targetParam);
                if(targetLctr == null || StringUtil.isNull(targetLctr.getLctrId())) {
                    resultDTO.setResultFailed(getMessage("contents.msg.no.target.week"));/*선택한 분반에 동일한 주차/강의 정보가 없습니다.*/
                    return new ArrayList<LctrContsVO>();
                }
                targetMap.put(targetSbjctId, createExrcsQstnInsertVO(vo, targetLctr.getLctrId(), targetSbjctId, targetLctr.getLctrWknoSchdlId()));
            }
        }

        return new ArrayList<LctrContsVO>(targetMap.values());
    }

    /**
     * 연습문제 콘텐츠 저장값을 대상 강의 기준으로 복사한다.
     * @param source
     * @param lctrId
     * @param sbjctId
     * @param lctrWknoSchdlId
     * @return
     */
    private LctrContsVO createExrcsQstnInsertVO(LctrContsVO source, String lctrId, String sbjctId, String lctrWknoSchdlId) {
        LctrContsVO target = new LctrContsVO();
        target.setOrgId(source.getOrgId());
        target.setSbjctId(sbjctId);
        target.setLctrWknoSchdlId(lctrWknoSchdlId);
        target.setLctrId(lctrId);
        target.setContsSeqno(source.getContsSeqno());
        target.setContsnm(source.getContsnm());
        target.setLctrContsTycd(CONTS_TYPE_EXERC_QSTN);
        target.setAtndcRfltyn(source.getAtndcRfltyn());
        target.setOyn(source.getOyn());
        target.setExrcsQstnId(source.getExrcsQstnId());
        target.setRgtrId(source.getRgtrId());
        target.setMdfrId(source.getMdfrId());
        target.setLangCd(source.getLangCd());
        target.setLrnTocTtl(source.getLrnTocTtl());
        target.setAdmRegContsyn("Y");
        prepareInsertLctrConts(target);
        return target;
    }

    /**
     * 관리자 학습목차 콘텐츠와 하위 콘텐츠를 삭제한다.
     * @param vo
     * @return
     */
    @Override
    public ResultDTO<LctrContsVO> deleteAdmLctrContsTree(LctrContsVO vo) {
        ResultDTO<LctrContsVO> resultDTO = new ResultDTO<LctrContsVO>();
        if(StringUtil.isNull(vo.getLctrContsId())) {
            return resultDTO.setResultFailed(getMessage("fail.common.delete"));/*삭제가 실패하였습니다.*/
        }

        int affected = contsDAO.deleteAdmLctrContsTree(vo);
        if(affected > 0) {
            return resultDTO.setData(vo).setResultSuccess(getMessage("success.common.delete"));/*정상적으로 삭제되었습니다.*/
        }
        return resultDTO.setResultFailed(getMessage("fail.common.delete"));/*삭제가 실패하였습니다.*/
    }

    /**
     * 관리자 학습목차 콘텐츠의 학습 이력 존재 여부를 조회한다.
     * @param vo
     * @return
     */
    @Override
    public ResultDTO<Boolean> existsAdmLctrContsLearningHistory(LctrContsVO vo) {
        ResultDTO<Boolean> resultDTO = new ResultDTO<Boolean>();
        if(StringUtil.isNull(vo.getLctrContsId())) {
            return resultDTO.setData(false).setResultFailed(getMessage("fail.common.select"));/*조회에 실패하였습니다.*/
        }

        // 부모 콘텐츠와 하위 콘텐츠 중 하나라도 학습 이력이 있으면 강한 삭제 확인 문구를 표시한다.
        boolean exists = contsDAO.selectAdmLctrContsLearningHistoryCnt(vo) > 0;
        return resultDTO.setData(exists).setResultSuccess();
    }

    /**
     * 관리자 학습목차 돌발퀴즈 선택 목록을 조회한다.
     * @param pageInfo
     * @return
     */
    @Override
    public ResultDTO<EgovMap> selectAdmSddnQstnList(ContsSddnQstnPageInfo pageInfo) {
        List<EgovMap> list = contsDAO.selectAdmSddnQstnList(pageInfo);
        if(!list.isEmpty() && list.get(0).get("totalCnt") != null) {
            pageInfo.setTotalRecordCount(Integer.parseInt(String.valueOf(list.get(0).get("totalCnt"))));
        } else {
            pageInfo.setTotalRecordCount(0);
        }

        ResultDTO<EgovMap> resultDTO = new ResultDTO<EgovMap>();
        resultDTO.setReturnList(list);
        resultDTO.setPageInfo(pageInfo);
        return resultDTO.setResultSuccess();
    }

    /**
     * 관리자 학습목차 연습문제 선택 목록을 조회한다.
     * @param pageInfo
     * @return
     */
    @Override
    public ResultDTO<EgovMap> selectAdmExrcsQstnList(ContsExrcsQstnPageInfo pageInfo) {
        List<EgovMap> list = contsDAO.selectAdmExrcsQstnList(pageInfo);
        if(!list.isEmpty() && list.get(0).get("totalCnt") != null) {
            pageInfo.setTotalRecordCount(Integer.parseInt(String.valueOf(list.get(0).get("totalCnt"))));
        } else {
            pageInfo.setTotalRecordCount(0);
        }

        ResultDTO<EgovMap> resultDTO = new ResultDTO<EgovMap>();
        resultDTO.setReturnList(list);
        resultDTO.setPageInfo(pageInfo);
        return resultDTO.setResultSuccess();
    }

    private ResultDTO<LctrContsVO> validateLctrConts(LctrContsVO vo) {
        ResultDTO<LctrContsVO> resultDTO = new ResultDTO<LctrContsVO>();
        if(StringUtil.isNull(vo.getLctrId()) || StringUtil.isNull(vo.getLctrContsTycd()) || StringUtil.isNull(vo.getContsnm())) {
            return resultDTO.setResultFailed(getMessage("fail.common.update"));/*수정이 실패하였습니다.*/
        }
        String contsType = StringUtil.nvl(vo.getLctrContsTycd()).toUpperCase(Locale.ROOT);
        if(CONTS_TYPE_SNS_URL.equals(contsType) || CONTS_TYPE_SNS_HTML.equals(contsType)) {
            vo.setLctrContsTycd(contsType);
            return validateSnsConts(vo, contsType);
        }
        return resultDTO.setResultSuccess();
    }

    /**
     * 소셜 콘텐츠는 신뢰 가능한 미디어 URL 또는 iframe 공유 코드만 저장한다.
     * @param vo
     * @param contsType
     * @return
     */
    private ResultDTO<LctrContsVO> validateSnsConts(LctrContsVO vo, String contsType) {
        ResultDTO<LctrContsVO> resultDTO = new ResultDTO<LctrContsVO>();
        if(CONTS_TYPE_SNS_URL.equals(contsType)) {
            String contsUrl = StringUtil.nvl(vo.getContsUrl()).trim();
            if(StringUtil.isNull(contsUrl)) {
                return resultDTO.setResultFailed(getMessage("contents.msg.input.social.url"));/*소셜 URL 주소를 입력해 주세요.*/
            }
            if(!isAllowedSnsUrl(contsUrl)) {
                return resultDTO.setResultFailed(getMessage("contents.msg.invalid.social.url"));/*허용되지 않는 소셜 URL입니다.*/
            }
            vo.setContsUrl(contsUrl);
            vo.setHtmlSrc(null);
            return resultDTO.setResultSuccess();
        }

        String htmlSrc = StringUtil.nvl(vo.getHtmlSrc()).trim();
        if(StringUtil.isNull(htmlSrc)) {
            return resultDTO.setResultFailed(getMessage("contents.msg.input.social.html"));/*공유 소스코드를 입력해 주세요.*/
        }

        String sanitizedHtml = sanitizeSnsIframeHtml(htmlSrc);
        if(StringUtil.isNull(sanitizedHtml)) {
            return resultDTO.setResultFailed(getMessage("contents.msg.invalid.social.html"));/*허용되지 않는 소셜 공유 코드입니다.*/
        }
        vo.setHtmlSrc(sanitizedHtml);
        vo.setContsUrl("");
        return resultDTO.setResultSuccess();
    }

    private String sanitizeSnsIframeHtml(String htmlSrc) {
        String source = StringUtil.nvl(htmlSrc).trim();
        Matcher iframeMatcher = SNS_IFRAME_PATTERN.matcher(source);
        StringBuilder sanitized = new StringBuilder();
        int cursor = 0;
        int iframeCount = 0;

        while(iframeMatcher.find()) {
            if(!isBlankHtmlFragment(source.substring(cursor, iframeMatcher.start()))) {
                return null;
            }

            String sanitizedIframe = sanitizeSnsIframe(iframeMatcher.group(1));
            if(StringUtil.isNull(sanitizedIframe)) {
                return null;
            }
            sanitized.append(sanitizedIframe);
            cursor = iframeMatcher.end();
            iframeCount++;
        }

        if(iframeCount < 1 || !isBlankHtmlFragment(source.substring(cursor))) {
            return null;
        }
        return sanitized.toString();
    }

    private String sanitizeSnsIframe(String attrText) {
        Map<String, String> attrs = new LinkedHashMap<String, String>();
        Matcher attrMatcher = SNS_IFRAME_ATTR_PATTERN.matcher(StringUtil.nvl(attrText));
        int cursor = 0;

        while(attrMatcher.find()) {
            if(!isBlankHtmlFragment(attrText.substring(cursor, attrMatcher.start()))) {
                return null;
            }

            String attrName = StringUtil.nvl(attrMatcher.group(1)).toLowerCase(Locale.ROOT);
            String attrValue = firstNonNull(attrMatcher.group(3), attrMatcher.group(4), attrMatcher.group(5));
            attrValue = unescapeHtmlAttribute(attrValue);
            if(!isAllowedSnsIframeAttribute(attrName, attrValue)) {
                return null;
            }

            attrs.put(attrName, normalizeSnsIframeAttribute(attrName, attrValue));
            cursor = attrMatcher.end();
        }

        if(!isBlankHtmlFragment(attrText.substring(cursor)) || StringUtil.isNull(attrs.get("src"))) {
            return null;
        }

        StringBuilder iframe = new StringBuilder("<iframe");
        for(String attrName : SNS_IFRAME_ATTR_ORDER) {
            if(attrs.containsKey(attrName)) {
                iframe.append(" ").append(attrName).append("=\"").append(escapeHtmlAttribute(attrs.get(attrName))).append("\"");
            }
        }
        iframe.append("></iframe>");
        return iframe.toString();
    }

    private boolean isAllowedSnsIframeAttribute(String attrName, String attrValue) {
        if(StringUtil.isNull(attrName) || attrName.startsWith("on") || !SNS_IFRAME_ALLOWED_ATTRS.contains(attrName)) {
            return false;
        }
        if(SNS_IFRAME_BOOLEAN_ATTRS.contains(attrName)) {
            return StringUtil.isNull(attrValue) || attrName.equalsIgnoreCase(attrValue);
        }
        if(attrValue == null || containsHtmlDelimiter(attrValue)) {
            return false;
        }
        if("src".equals(attrName)) {
            return isAllowedSnsIframeSrc(attrValue);
        }
        if("width".equals(attrName) || "height".equals(attrName)) {
            return attrValue.matches("[0-9]{1,5}|[0-9]{1,3}%");
        }
        if("frameborder".equals(attrName)) {
            return "0".equals(attrValue) || "1".equals(attrValue);
        }
        if("referrerpolicy".equals(attrName)) {
            return SNS_ALLOWED_REFERRER_POLICIES.contains(attrValue.toLowerCase(Locale.ROOT));
        }
        if("loading".equals(attrName)) {
            String loading = attrValue.toLowerCase(Locale.ROOT);
            return "lazy".equals(loading) || "eager".equals(loading);
        }
        if("scrolling".equals(attrName)) {
            String scrolling = attrValue.toLowerCase(Locale.ROOT);
            return "yes".equals(scrolling) || "no".equals(scrolling) || "auto".equals(scrolling);
        }
        return true;
    }

    private String normalizeSnsIframeAttribute(String attrName, String attrValue) {
        if(SNS_IFRAME_BOOLEAN_ATTRS.contains(attrName)) {
            return attrName;
        }
        return StringUtil.nvl(attrValue).trim();
    }

    private boolean isAllowedSnsUrl(String url) {
        ParsedUrl parsedUrl = parseSnsUrl(url);
        return parsedUrl != null && SNS_ALLOWED_URL_HOSTS.contains(parsedUrl.host);
    }

    private boolean isAllowedSnsIframeSrc(String url) {
        ParsedUrl parsedUrl = parseSnsUrl(url);
        if(parsedUrl == null) {
            return false;
        }

        if("www.youtube.com".equals(parsedUrl.host) || "youtube.com".equals(parsedUrl.host)
                || "www.youtube-nocookie.com".equals(parsedUrl.host) || "youtube-nocookie.com".equals(parsedUrl.host)) {
            return parsedUrl.path.startsWith("/embed/");
        }
        if("player.vimeo.com".equals(parsedUrl.host)) {
            return parsedUrl.path.startsWith("/video/");
        }
        if("embed.ted.com".equals(parsedUrl.host)) {
            return parsedUrl.path.startsWith("/talks/");
        }
        return false;
    }

    private ParsedUrl parseSnsUrl(String url) {
        try {
            URI uri = new URI(StringUtil.nvl(url).trim());
            String scheme = StringUtil.nvl(uri.getScheme()).toLowerCase(Locale.ROOT);
            String host = uri.getHost();
            if((!"http".equals(scheme) && !"https".equals(scheme)) || StringUtil.isNull(host)
                    || uri.getUserInfo() != null || uri.getPort() > -1) {
                return null;
            }
            return new ParsedUrl(host.toLowerCase(Locale.ROOT), StringUtil.nvl(uri.getPath()));
        } catch(URISyntaxException e) {
            return null;
        }
    }

    private boolean isBlankHtmlFragment(String value) {
        return StringUtil.nvl(value).trim().isEmpty();
    }

    private boolean containsHtmlDelimiter(String value) {
        return value.indexOf('<') > -1 || value.indexOf('>') > -1;
    }

    private String firstNonNull(String... values) {
        for(String value : values) {
            if(value != null) {
                return value;
            }
        }
        return null;
    }

    private String escapeHtmlAttribute(String value) {
        return StringUtil.nvl(value)
                .replace("&", "&amp;")
                .replace("\"", "&quot;")
                .replace("<", "&lt;")
                .replace(">", "&gt;");
    }

    private String unescapeHtmlAttribute(String value) {
        if(value == null) {
            return null;
        }
        return value.replace("&quot;", "\"")
                .replace("&#34;", "\"")
                .replace("&#39;", "'")
                .replace("&apos;", "'")
                .replace("&lt;", "<")
                .replace("&gt;", ">")
                .replace("&amp;", "&");
    }

    private static class ParsedUrl {
        private final String host;
        private final String path;

        private ParsedUrl(String host, String path) {
            this.host = host;
            this.path = path;
        }
    }

    /**
     * 연습문제 콘텐츠 저장 요청의 필수값을 확인한다.
     * @param vo
     * @return
     */
    private ResultDTO<LctrContsVO> validateExrcsQstnConts(LctrContsVO vo) {
        ResultDTO<LctrContsVO> resultDTO = validateLctrConts(vo);
        if(resultDTO.getResult() < 0) {
            return resultDTO;
        }
        if(StringUtil.isNull(vo.getLrnTocTtl())) {
            return resultDTO.setResultFailed(getMessage("common.pop.input.title"));/*제목을 입력하세요.*/
        }
        if(StringUtil.isNull(vo.getExrcsQstnId())) {
            return resultDTO.setResultFailed(getMessage("contents.msg.select.exercise.question"));/*연습문제를 선택해 주세요.*/
        }
        return resultDTO.setResultSuccess();
    }

    private void prepareInsertLctrConts(LctrContsVO vo) {
        if(StringUtil.isNull(vo.getLctrContsId())) {
            vo.setLctrContsId(IdGenUtil.genNewId(IdPrefixType.SBCON));
        }
        prepareSaveLctrConts(vo);
    }

    /**
     * 신규 최상위 콘텐츠가 들어갈 위치 이후의 순번을 한 칸씩 뒤로 민다.
     * @param vo
     */
    private void adjustLctrContsSeqnoForInsert(LctrContsVO vo) {
        if(!isParentAdminContent(vo)) {
            return;
        }
        contsDAO.increaseAdmLctrContsSeqnoForInsert(vo);
    }

    /**
     * 기존 최상위 콘텐츠의 순번 변경 방향에 따라 사이 순번을 보정한다.
     * @param vo
     */
    private void adjustLctrContsSeqnoForUpdate(LctrContsVO vo) {
        if(StringUtil.isNull(vo.getLctrContsId())) {
            return;
        }

        LctrContsVO existing = contsDAO.selectAdmLctrConts(vo);
        if(existing == null || !StringUtil.isNull(existing.getUpLctrContsId())) {
            return;
        }

        vo.setLctrId(existing.getLctrId());
        vo.setLctrWknoSchdlId(existing.getLctrWknoSchdlId());
        vo.setSbjctId(existing.getSbjctId());
        vo.setPrevContsSeqno(existing.getContsSeqno());
        if(vo.getContsSeqno() == null || vo.getPrevContsSeqno() == null || vo.getContsSeqno().equals(vo.getPrevContsSeqno())) {
            return;
        }

        if(vo.getContsSeqno() < vo.getPrevContsSeqno()) {
            contsDAO.increaseAdmLctrContsSeqnoForMoveUp(vo);
        } else {
            contsDAO.decreaseAdmLctrContsSeqnoForMoveDown(vo);
        }
    }

    /**
     * 순번 자동 보정은 관리자 최상위 콘텐츠에만 적용한다.
     * @param vo
     * @return
     */
    private boolean isParentAdminContent(LctrContsVO vo) {
        return vo != null
                && !StringUtil.isNull(vo.getLctrId())
                && !StringUtil.isNull(vo.getLctrWknoSchdlId())
                && StringUtil.isNull(vo.getUpLctrContsId())
                && !"N".equalsIgnoreCase(vo.getAdmRegContsyn());
    }

    /**
     * 상위-하위 콘텐츠 적재 규칙에 맞게 저장 기본값을 구성한다.
     * @param vo
     */
    private void prepareSaveLctrConts(LctrContsVO vo) {
        boolean childContent = !StringUtil.isNull(vo.getUpLctrContsId());
        if(childContent) {
            vo.setContsSeqno(1);
            vo.setAtndcRfltyn("N");
        } else if(StringUtil.isNull(vo.getAtndcRfltyn())) {
            vo.setAtndcRfltyn("Y");
        }

        if(vo.getContsSeqno() == null || vo.getContsSeqno() < 1) {
            vo.setContsSeqno(1);
        }
        if(StringUtil.isNull(vo.getOyn())) {
            vo.setOyn("Y");
        }
        vo.setAdmRegContsyn("Y");
        if(StringUtil.isNull(vo.getDelyn())) {
            vo.setDelyn("N");
        }
    }

    /**
     * 여부 값이 Y 또는 N인지 확인한다.
     * @param value
     * @return
     */
    private boolean isYn(String value) {
        return "Y".equals(value) || "N".equals(value);
    }

    /**
     * 화질별 동영상 또는 자막 파일 하위 콘텐츠를 저장한다.
     * @param parent
     * @param childContsId
     * @param uploadFiles
     * @param uploadPath
     * @param delFileIdStr
     * @param contsnmSuffix
     * @param vdoQltyGbncd
     */
    private void saveVideoFileChild(LctrContsVO parent, String childContsId, String uploadFiles,
                                    String uploadPath, String delFileIdStr, String contsnmSuffix, String vdoQltyGbncd) {
        deleteFileIds(delFileIdStr);

        boolean hasUpload = !StringUtil.isNull(uploadFiles);
        boolean hasChild = !StringUtil.isNull(childContsId);
        if(!hasUpload) {
            if(hasChild && !StringUtil.isNull(delFileIdStr)) {
                deleteContentChild(parent, childContsId);
            }
            return;
        }

        if(hasChild) {
            deleteFilesByRefId(childContsId);
        } else {
            childContsId = IdGenUtil.genNewId(IdPrefixType.SBCON);
        }

        String childUploadPath = StringUtil.nvl(uploadPath, parent.getUploadPath());
        AtflVO savedFile = insertUploadedFiles(uploadFiles, childUploadPath, childContsId, CONTS_TYPE_VIDEO, parent);
        if(savedFile == null) {
            return;
        }

        LctrContsVO child = createFileChildContent(parent, childContsId, CONTS_TYPE_VIDEO, contsnmSuffix, savedFile, childUploadPath);
        child.setVdoQltyGbncd(vdoQltyGbncd);
        if(hasChild) {
            contsDAO.updateAdmLctrConts(child);
        } else {
            contsDAO.insertAdmLctrConts(child);
        }
    }

    /**
     * 돌발퀴즈 선택 row를 하위 콘텐츠로 다시 구성한다.
     * @param parent
     */
    private void saveSddnQstnChildren(LctrContsVO parent) {
        contsDAO.deleteAdmLctrContsSddnQstnChildren(parent);

        List<LctrContsVO> insertList = new ArrayList<LctrContsVO>();
        for(LctrContsVO requestChild : parent.getChildContsList()) {
            if(requestChild == null || StringUtil.isNull(requestChild.getSddnQstnId())) {
                continue;
            }
            LctrContsVO child = createBaseChildContent(parent, IdGenUtil.genNewId(IdPrefixType.SBCON), CONTS_TYPE_SDDN_QSTN);
            child.setContsnm(StringUtil.nvl(requestChild.getContsnm(), "돌발퀴즈"));
            child.setSddnQstnId(requestChild.getSddnQstnId());
            child.setSddnQstnPlySec(requestChild.getSddnQstnPlySec());
            insertList.add(child);
        }

        if(!insertList.isEmpty()) {
            contsDAO.insertAdmLctrContsBatch(insertList);
        }
    }

    /**
     * 다국어 자막 row를 하위 콘텐츠와 첨부파일로 저장한다.
     * @param parent
     */
    private void saveSrtChildren(LctrContsVO parent) {
        Map<String, LctrContsVO> existingSrtMap = selectExistingSrtChildMap(parent);
        Set<String> requestIdSet = new HashSet<String>();
        List<LctrContsVO> requestList = parent.getSrtContsList() == null ? new ArrayList<LctrContsVO>() : parent.getSrtContsList();

        for(LctrContsVO requestChild : requestList) {
            if(requestChild != null && !StringUtil.isNull(requestChild.getLctrContsId())) {
                requestIdSet.add(requestChild.getLctrContsId());
            }
        }

        for(String existingId : existingSrtMap.keySet()) {
            if(!requestIdSet.contains(existingId)) {
                deleteFilesByRefId(existingId);
                deleteContentChild(parent, existingId);
            }
        }

        for(LctrContsVO requestChild : requestList) {
            saveSrtChild(parent, requestChild, existingSrtMap);
        }
    }

    /**
     * 저장된 자막 하위 콘텐츠를 식별자 기준으로 조회한다.
     * @param parent
     * @return
     */
    private Map<String, LctrContsVO> selectExistingSrtChildMap(LctrContsVO parent) {
        Map<String, LctrContsVO> srtMap = new LinkedHashMap<String, LctrContsVO>();
        List<LctrContsVO> childList = contsDAO.selectAdmLctrContsChildren(parent);
        for(LctrContsVO child : childList) {
            if(CONTS_TYPE_SRT.equals(child.getLctrContsTycd())) {
                srtMap.put(child.getLctrContsId(), child);
            }
        }
        return srtMap;
    }

    /**
     * 자막 row 하나를 등록, 수정 또는 삭제 처리한다.
     * @param parent
     * @param requestChild
     * @param existingSrtMap
     */
    private void saveSrtChild(LctrContsVO parent, LctrContsVO requestChild, Map<String, LctrContsVO> existingSrtMap) {
        if(requestChild == null) {
            return;
        }

        String childContsId = requestChild.getLctrContsId();
        boolean hasChild = !StringUtil.isNull(childContsId);
        boolean hasUpload = !StringUtil.isNull(requestChild.getSrtUploadFiles());
        boolean hasDeleteFile = !StringUtil.isNull(requestChild.getSrtDelFileIdStr());
        if(!hasChild && !hasUpload) {
            return;
        }

        deleteFileIds(requestChild.getSrtDelFileIdStr());
        if(!hasUpload) {
            if(hasChild && hasDeleteFile) {
                deleteContentChild(parent, childContsId);
                return;
            }
            updateSrtChildLanguage(parent, requestChild, existingSrtMap.get(childContsId));
            return;
        }

        if(hasChild) {
            deleteFilesByRefId(childContsId);
        } else {
            childContsId = IdGenUtil.genNewId(IdPrefixType.SBCON);
        }

        String childUploadPath = StringUtil.nvl(requestChild.getSrtUploadPath(), parent.getUploadPath());
        AtflVO savedFile = insertUploadedFiles(requestChild.getSrtUploadFiles(), childUploadPath, childContsId, CONTS_TYPE_SRT, parent);
        if(savedFile == null) {
            return;
        }

        LctrContsVO child = createFileChildContent(parent, childContsId, CONTS_TYPE_SRT, "자막", savedFile, childUploadPath);
        child.setLangCd(StringUtil.nvl(requestChild.getLangCd(), parent.getLangCd()));
        if(hasChild) {
            contsDAO.updateAdmLctrConts(child);
        } else {
            contsDAO.insertAdmLctrConts(child);
        }
    }

    /**
     * 파일 변경이 없는 자막 row의 언어코드만 반영한다.
     * @param parent
     * @param requestChild
     * @param existingChild
     */
    private void updateSrtChildLanguage(LctrContsVO parent, LctrContsVO requestChild, LctrContsVO existingChild) {
        if(existingChild == null) {
            return;
        }
        existingChild.setOrgId(parent.getOrgId());
        existingChild.setMdfrId(parent.getMdfrId());
        existingChild.setLangCd(StringUtil.nvl(requestChild.getLangCd(), existingChild.getLangCd()));
        contsDAO.updateAdmLctrConts(existingChild);
    }

    /**
     * 파일형 하위 콘텐츠 VO를 생성한다.
     * @param parent
     * @param childContsId
     * @param contsType
     * @param contsnmSuffix
     * @param savedFile
     * @param uploadPath
     * @return
     */
    private LctrContsVO createFileChildContent(LctrContsVO parent, String childContsId, String contsType,
                                               String contsnmSuffix, AtflVO savedFile, String uploadPath) {
        LctrContsVO child = createBaseChildContent(parent, childContsId, contsType);
        child.setContsFileId(savedFile.getAtflId());
        child.setContsnm(parent.getContsnm() + " " + contsnmSuffix);
        child.setContsPath(uploadPath);
        child.setContsFileExt(savedFile.getFileExt());
        if(CONTS_TYPE_SRT.equals(contsType)) {
            child.setLangCd(parent.getLangCd());
        }
        return child;
    }

    /**
     * 하위 콘텐츠 공통 저장값을 생성한다.
     * @param parent
     * @param childContsId
     * @param contsType
     * @return
     */
    private LctrContsVO createBaseChildContent(LctrContsVO parent, String childContsId, String contsType) {
        LctrContsVO child = new LctrContsVO();
        child.setOrgId(parent.getOrgId());
        child.setLctrContsId(childContsId);
        child.setLctrId(parent.getLctrId());
        child.setUpLctrContsId(parent.getLctrContsId());
        child.setLctrContsTycd(contsType);
        child.setContsSeqno(1);
        child.setAtndcRfltyn("N");
        child.setOyn("Y");
        child.setRgtrId(parent.getRgtrId());
        child.setMdfrId(parent.getMdfrId());
        child.setLangCd(parent.getLangCd());
        child.setAdmRegContsyn("Y");
        child.setDelyn("N");
        prepareSaveLctrConts(child);
        return child;
    }

    /**
     * DEXT 업로드 결과를 첨부파일 메타데이터로 저장한다.
     * @param uploadFiles
     * @param uploadPath
     * @param refId
     * @param contsType
     * @param parent
     * @return
     */
    private AtflVO insertUploadedFiles(String uploadFiles, String uploadPath, String refId, String contsType, LctrContsVO parent) {
        List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(uploadFiles, uploadPath);
        if(uploadFileList == null || uploadFileList.isEmpty()) {
            return null;
        }

        for(AtflVO atflVO : uploadFileList) {
            atflVO.setRefId(refId);
            atflVO.setEtcInfo1(contsType);
            atflVO.setRgtrId(parent.getRgtrId());
            atflVO.setMdfrId(parent.getMdfrId());
            atflVO.setAtflRepoId(CommConst.REPO_CONTS);
        }
        attachFileService.insertAtflList(uploadFileList);
        return uploadFileList.get(0);
    }

    /**
     * 삭제 요청된 첨부파일 메타데이터를 삭제한다.
     * @param delFileIdStr
     */
    private void deleteFileIds(String delFileIdStr) {
        if(StringUtil.isNull(delFileIdStr)) {
            return;
        }
        try {
            attachFileService.deleteAtflByAtflIds(delFileIdStr.split(","));
        } catch(Exception e) {
            throw new IllegalStateException("Failed to delete content files.", e);
        }
    }

    /**
     * 하위 콘텐츠 참조아이디에 연결된 파일 메타데이터를 삭제한다.
     * @param refId
     */
    private void deleteFilesByRefId(String refId) {
        AtflVO param = new AtflVO();
        param.setRefId(refId);
        List<AtflVO> fileList = attachFileService.selectAtflListByRefId(param);
        if(fileList == null || fileList.isEmpty()) {
            return;
        }

        List<String> atflIds = new ArrayList<String>();
        for(AtflVO atflVO : fileList) {
            if(!StringUtil.isNull(atflVO.getAtflId())) {
                atflIds.add(atflVO.getAtflId());
            }
        }
        if(!atflIds.isEmpty()) {
            try {
                attachFileService.deleteAtflByAtflIds(atflIds.toArray(new String[0]));
            } catch(Exception e) {
                throw new IllegalStateException("Failed to delete content files.", e);
            }
        }
    }

    /**
     * 파일이 모두 제거된 하위 콘텐츠를 삭제 처리한다.
     * @param parent
     * @param childContsId
     */
    private void deleteContentChild(LctrContsVO parent, String childContsId) {
        LctrContsVO deleteParam = new LctrContsVO();
        deleteParam.setOrgId(parent.getOrgId());
        deleteParam.setLctrContsId(childContsId);
        deleteParam.setMdfrId(parent.getMdfrId());
        contsDAO.deleteAdmLctrContsTree(deleteParam);
    }

}
