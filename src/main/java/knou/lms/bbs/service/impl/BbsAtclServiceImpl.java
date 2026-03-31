package knou.lms.bbs.service.impl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import knou.framework.common.CommConst;
import knou.framework.common.IdPrefixType;
import knou.framework.common.PageInfo;
import knou.framework.common.ServiceBase;
import knou.framework.exception.ServiceProcessException;
import knou.framework.util.FileUtil;
import knou.framework.util.IdGenUtil;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.framework.vo.FileVO;
import knou.lms.bbs.dao.BbsAtclDAO;
import knou.lms.bbs.dao.BbsCmntDAO;
import knou.lms.bbs.dao.BbsInfoDAO;
import knou.lms.bbs.dao.BbsViewDAO;
import knou.lms.bbs.service.BbsAtclService;
import knou.lms.bbs.vo.BbsAtclVO;
import knou.lms.bbs.vo.BbsInfoVO;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.file.dao.AttachFileDAO;
import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflVO;
import knou.lms.log.recom.service.LogRecomService;
import knou.lms.log.recom.vo.LogRecomVO;
import knou.lms.user.dao.UsrUserInfoDAO;
import knou.lms.user.vo.UsrUserInfoVO;
import net.sf.json.JSONArray;

@Service("bbsAtclService")
public class BbsAtclServiceImpl extends ServiceBase implements BbsAtclService {

    private static final Logger LOGGER = LoggerFactory.getLogger(BbsAtclServiceImpl.class);

    @Resource(name="bbsInfoDAO")
    private BbsInfoDAO bbsInfoDAO;

    @Resource(name="bbsAtclDAO")
    private BbsAtclDAO bbsAtclDAO;

    @Resource(name="bbsCmntDAO")
    private BbsCmntDAO bbsCmntDAO;

    @Resource(name="logRecomService")
    private LogRecomService logRecomService;

    @Resource(name="bbsViewDAO")
    private BbsViewDAO bbsViewDAO;

    @Resource(name="sysFileService")
    private SysFileService sysFileService;

    @Resource(name="usrUserInfoDAO")
    private UsrUserInfoDAO usrUserInfoDAO;



    //@Resource(name="attachFileDAO")
    //private AttachFileDAO attachFileDAO;

    @Resource(name="attachFileService")
    private AttachFileService attachFileService;

    /*****************************************************
     * 게시글 목록 수
     * @param vo
     * @return int
     * @throws Exception
     ******************************************************/
    @Override
    public int countBbsAtcl(BbsAtclVO vo) throws Exception {
        return bbsAtclDAO.countBbsAtcl(vo);
    }

    /*****************************************************
     * 게시글 목록
     * @param vo
     * @return List<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<BbsAtclVO> listBbsAtcl(BbsAtclVO vo) throws Exception {
        return bbsAtclDAO.listBbsAtcl(vo);
    }

    /*****************************************************
     * 게시글 목록 페이징
     * @param vo
     * @return ProcessResultVO<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<BbsAtclVO> listBbsAtclPaging(BbsAtclVO vo) throws Exception {
        ProcessResultVO<BbsAtclVO> processResultVO = new ProcessResultVO<>();

        PaginationInfo paginationInfo = new PaginationInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getPageScale());

        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());

        int totCnt = bbsAtclDAO.countBbsAtcl(vo);

        paginationInfo.setTotalRecordCount(totCnt);

        List<BbsAtclVO> resultList = bbsAtclDAO.listBbsAtclPaging(vo);

        processResultVO.setReturnList(resultList);
        processResultVO.setPageInfo(paginationInfo);

        return processResultVO;
    }

    /*****************************************************
     * 게시글 정보 저장
     * @param vo
     * @throws Exception
     ******************************************************/
    @Override
    public void insertBbsAtcl(BbsAtclVO vo) throws Exception {
        String bbsId = vo.getBbsId();
        String atclOptnId = vo.getAtclOptnId();
        String rgtrId = vo.getRgtrId();

        // 비공개여부
        if(ValidationUtils.isEmpty(vo.getLockYn())) {
            vo.setLockYn("N");
        }

        // 등록예약
        if(!"Y".equals(StringUtil.nvl(vo.getRsrvUseYn()))) {
            vo.setRsrvDttm(null);
        }

        // 일대일 상담 여부
        if(!"SECRET".equals(StringUtil.nvl(bbsId))) {
            vo.setDscsnProfId(null);
        }

        if(ValidationUtils.isNotEmpty(vo.getUpAtclId()) && ("QNA".equals(bbsId) || "SECRET".equals(bbsId))) {
            vo.setCmntUseYn("Y"); // 댓글 사용
        }

        LOGGER.debug("bbsId     : " + vo.getBbsId());
        LOGGER.debug("atclId    : " + vo.getAtclId());

        if("NOTICE".equals(bbsId)) {
            LOGGER.debug("중요글           : " + vo.getImptYn());
            LOGGER.debug("고정글           : " + vo.getNoticeYn());
            LOGGER.debug("atclTitle : " + vo.getAtclTtl());
            LOGGER.debug("atclCts   : " + vo.getAtclCts());
            LOGGER.debug("댓글사용        : " + vo.getCmntUseYn());
            LOGGER.debug("분반List   : " + vo.getDeclsList());
            LOGGER.debug("비공개여부     : " + vo.getLockYn());
        } else if("QNA".equals(bbsId) || "SECRET".equals(bbsId)) {
            LOGGER.debug("상담교수        : " + vo.getDscsnProfId());
            LOGGER.debug("atclTitle : " + vo.getAtclTtl());
            LOGGER.debug("atclCts   : " + vo.getAtclCts());
            LOGGER.debug("댓글사용        : " + vo.getCmntUseYn());
            LOGGER.debug("비공개여부     : " + vo.getLockYn());
        } else if("PDS".equals(bbsId)) {
            LOGGER.debug("중요글           : " + vo.getImptYn());
            LOGGER.debug("고정글           : " + vo.getNoticeYn());
            LOGGER.debug("atclTitle : " + vo.getAtclTtl());
            LOGGER.debug("atclCts   : " + vo.getAtclCts());
            LOGGER.debug("댓글사용        : " + vo.getCmntUseYn());
            LOGGER.debug("좋아요사용     : " + vo.getGoodUseYn());
            LOGGER.debug("분반List   : " + vo.getDeclsList());
            LOGGER.debug("등록예약        : " + vo.getRsrvUseYn());
            LOGGER.debug("예약일시        : " + vo.getRsrvDttm());
            LOGGER.debug("비공개여부     : " + vo.getLockYn());
        }

        String uploadPath = vo.getUploadPath();
        String uploadFiles = vo.getUploadFiles();
        String copyFiles = vo.getCopyFiles();

        LOGGER.debug("파일 업로드 경로 : " + uploadPath);
        LOGGER.debug("파일 업로드        : " + uploadFiles);
        LOGGER.debug("파일함 복사        : " + copyFiles);

        List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(vo.getUploadFiles(), vo.getUploadPath());
        Map<String, List<AtflVO>> declsCopyFileListMap = new HashMap<>();

        UsrUserInfoVO usrUserInfoVO = new UsrUserInfoVO();
        usrUserInfoVO.setUserId(rgtrId);
        usrUserInfoVO = usrUserInfoDAO.select(usrUserInfoVO);

        try {
            // 전체공지 게시글일 경우 부서명 입력
            if(CommConst.BBS_ID_SYSTEM_NOTICE.equals(bbsId)) {
                String deptNm = usrUserInfoVO.getDeptNm();
                vo.setRgtrnm(deptNm);
            } else {
                vo.setRgtrnm(usrUserInfoVO.getUserNm());
            }

         // 저장
            //String newAtclId = IdGenerator.getNewId("ATCL");
            //vo.setAtclId(newAtclId);

            // 스크립트 태그 제거
            vo.setAtclTtl(StringUtil.removeScript(vo.getAtclTtl()));
            //vo.setAtclCts(StringUtil.removeScript(vo.getAtclCts()));

            // TODO 임시맵핑
            if(CommConst.BBS_ID_SYSTEM_NOTICE.equals(bbsId)) {
                if(ValidationUtils.isNotEmpty(vo.getUnivGbn())) {
                    if("1".equals(vo.getUnivGbn())) {
                        vo.setUniCd("C");
                    } else {
                        vo.setUniCd("G");
                    }
                } else {
                    vo.setUniCd("P");
                }
            }

            // 게시글 저장
			/* bbsAtclDAO.insertBbsAtcl(vo); */

            String atclId = vo.getAtclId();
            String newAtclId = "";

        	// 데이터가 없으면 신규 등록
        	if (atclId == null || atclId.trim().isEmpty()) {
        		newAtclId = IdGenUtil.genNewId(IdPrefixType.BBATC);
        		vo.setAtclId(newAtclId);
        	} else {
        		vo.setAtclId(atclId);
        	}

        	if (atclOptnId == null || atclOptnId.trim().isEmpty()) {
        		vo.setAtclOptnId(IdGenUtil.genNewId(IdPrefixType.BBOPT));
        	}

            // TB_LMS_BBS_ATCL
        	bbsAtclDAO.bbsAtclSbjctRegist(vo);

        	// TB_LMS_BBS_ATCL_OPTN
        	bbsAtclDAO.bbsAtclOptnRegist(vo);

            // 첨부파일
            if (uploadFileList.size() > 0) {
            	for (AtflVO atflVO : uploadFileList) {
            		atflVO.setAtflId(IdGenUtil.genNewId(IdPrefixType.ATFL));
            		atflVO.setRefId(newAtclId);
            		atflVO.setRgtrId(vo.getRgtrId());
            		atflVO.setMdfrId(vo.getMdfrId());
            		atflVO.setAtflRepoId(CommConst.REPO_BBS); // 첨부파일 저장소 아이디
            	}

            	// 첨부파일 저장
            	attachFileService.insertAtflList(uploadFileList);
            }

            /* TODO 분반 동시 등록 기능 추가해야함.....
            // 분반별 게시글 등록 (공지사항, 강의자료실)
            if("NOTICE".equals(bbsId) || "PDS".equals(bbsId)) {
                List<String> declsAtclIdList = new ArrayList<>();

                if(vo.getDeclsList() != null && vo.getDeclsList().size() > 0) {
                    for(String crsCreCd : vo.getDeclsList()) {
                        if(crsCreCd.equals(vo.getCrsCreCd())) {
                            continue;
                        }

                        LOGGER.debug("분반  강의실 코드 : " + crsCreCd);

                        BbsInfoVO bbsInfoVO = new BbsInfoVO();
                        bbsInfoVO.setOrgId(vo.getOrgId());
                        bbsInfoVO.setCrsCreCd(crsCreCd);
                        bbsInfoVO.setSysDefaultYn("Y");
                        bbsInfoVO.setSysUseYn("N");
                        bbsInfoVO.setBbsId(bbsId);
                        bbsInfoVO = bbsInfoDAO.selectBbsInfo(bbsInfoVO);

                        if(bbsInfoVO == null) {
                            throw new ServiceProcessException("분반 강의실 게시판 정보를 찾을 수 없어 저장에 실패하였습니다.");
                        }

                        // 저장
                        String atclId = IdGenerator.getNewId("ATCL");
                        vo.setCrsCreCd(crsCreCd);
                        vo.setBbsId(bbsInfoVO.getBbsId());
                        vo.setAtclId(atclId);
                        bbsAtclDAO.insertBbsAtcl(vo);

                        // 분반 ID 저장
                        declsAtclIdList.add(atclId);
                    }

                    // 분반 게시글 ID 정보 등록
                    if(declsAtclIdList.size() > 0) {
                        declsAtclIdList.add(newAtclId);
                        String[] sqlForeach = declsAtclIdList.toArray(new String[declsAtclIdList.size()]);
                        String declsAtclIds = String.join(",", sqlForeach);

                        BbsAtclVO bbsAtclVO = new BbsAtclVO();
                        bbsAtclVO.setDvclasRegAtclId(String.join(",", declsAtclIds));
                        bbsAtclVO.setSqlForeach(sqlForeach);
                        bbsAtclDAO.updateDeclsAtcl(bbsAtclVO);
                    }
                }
            }
            */
        } catch(Exception e) {
            LOGGER.debug("e: ", e);

            if(uploadFileList.size() > 0) {
                FileUtil.delUploadFileList(uploadFiles, uploadPath);
            }

            // 분반 복사된 파일 제거
            if(vo.getDeclsList() != null && vo.getDeclsList().size() > 0) {
                for(Map.Entry<String, List<AtflVO>> entry : declsCopyFileListMap.entrySet()) {
                    String path = entry.getKey();
                    List<AtflVO> declsCopyList = entry.getValue();

                    for(AtflVO fvo2 : declsCopyList) {
                        String fileSaveNm = fvo2.getFileSavnm();
                        FileUtil.deleteFile(fileSaveNm, path);
                    }
                }
            }

            throw e;
        }
    }



    /*****************************************************
     * 게시글 삭제
     * @param vo
     * @throws Exception
     ******************************************************/
    @Override
    public void deleteBbsAtcl(BbsAtclVO vo) throws Exception {
        bbsAtclDAO.updateBbsAtclDelYn(vo);
    }

    /*****************************************************
     * 게시글 답글 목록
     * @param vo
     * @return List<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<BbsAtclVO> listBbsAtclAnswer(BbsAtclVO vo) throws Exception {
        return bbsAtclDAO.listBbsAtclAnswer(vo);
    }

    /*****************************************************
     * 게시글 조회 이전 다음글 포함
     * @param vo
     * @return BbsAtclVO
     * @throws Exception
     ******************************************************/
    @Override
    public BbsAtclVO viewBbsAtcl(BbsAtclVO vo) throws Exception {
        BbsAtclVO bbsAtclVO = bbsAtclDAO.selectBbsAtcl(vo);

        if(bbsAtclVO != null) {
            BbsAtclVO prevNextAtclVO = bbsAtclDAO.selectPrevNextAtcl(vo);

            if(prevNextAtclVO != null) {
                bbsAtclVO.setBeforeAtclId(prevNextAtclVO.getBeforeAtclId());
                bbsAtclVO.setAfterAtclId(prevNextAtclVO.getAfterAtclId());
            }
            if(bbsAtclVO.getAtchFileCnt() > 0) {
                String atclId = bbsAtclVO.getAtclId();
                FileVO fileVO = new FileVO();
                fileVO.setRepoCd("BBS");
                fileVO.setFileBindDataSn(atclId);
                ProcessResultVO<FileVO> resultVO = (ProcessResultVO<FileVO>) sysFileService.list(fileVO);

                List<FileVO> fileList = resultVO.getReturnList();
                bbsAtclVO.setFileList(fileList);
            }
        }

        return bbsAtclVO;
    }

    /*****************************************************
     * 게시글 좋아요수 수정
     * @param vo
     * @return BbsAtclVO
     * @throws Exception
     ******************************************************/
    @Override
    public BbsAtclVO updateBbsAtclGoodCnt(BbsAtclVO vo) throws Exception {
        String atclId = vo.getAtclId();
        String rgtrId = vo.getRgtrId();
        int viewerGoodCnt;

        LogRecomVO logRecomVO = new LogRecomVO();
        logRecomVO.setRltnCd(atclId);
        logRecomVO.setRltnType("BBS");
        logRecomVO.setRltnCd(atclId);
        logRecomVO.setRgtrId(rgtrId);

        int countRecomRgtrId = logRecomService.countRecomRgtrId(logRecomVO);

        // 이미 추천했다면 추천 삭제
        if(countRecomRgtrId > 0) {
            logRecomService.delete(logRecomVO);
            viewerGoodCnt = 0;
        } else {
            logRecomVO.setRecomCd(IdGenerator.getNewId("RECOM"));
            logRecomService.insert(logRecomVO);
            viewerGoodCnt = 1;
        }

        // 전체 좋아요 수 조회
        int goodCnt = logRecomService.count(logRecomVO);

        // 게시글 좋아요 수 업데이트
        BbsAtclVO bbsAtclVO = new BbsAtclVO();
        bbsAtclVO.setAtclId(atclId);
        bbsAtclVO.setFvrtCnt(goodCnt);
        bbsAtclDAO.updateBbsAtclGoodCnt(bbsAtclVO);

        bbsAtclVO.setViewerGoodCnt(viewerGoodCnt);

        return bbsAtclVO;
    }

    /*****************************************************
     * 분반 게시글 정보 목록
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listDeclsBbsAtcl(BbsAtclVO vo) throws Exception {
        return bbsAtclDAO.listDeclsBbsAtcl(vo);
    }

    /*****************************************************
     * 강의실 게시글 복사
     * @param vo
     * @return
     * @throws Exception
     ******************************************************/
    public void copyAtclToNewCourse(BbsAtclVO vo) throws Exception {
        String orgId = vo.getOrgId();
        String crsCreCd = vo.getCrsCreCd();
        String copyAtclId = vo.getCopyAtclId();
        String bbsId = vo.getBbsId();
        String rgtrId = vo.getRgtrId();
        String lineNo = vo.getLineNo();

        if(ValidationUtils.isEmpty(orgId)
                || ValidationUtils.isEmpty(crsCreCd)
                || ValidationUtils.isEmpty(bbsId)
                || ValidationUtils.isEmpty(copyAtclId)
                || ValidationUtils.isEmpty(rgtrId)
                || ValidationUtils.isEmpty(lineNo)) {
            throw processException("system.fail.badrequest.nomethod"); // 잘못된 요청으로 오류가 발생하였습니다.
        }

        // 게시판 사용여부 체크
        BbsInfoVO bbsInfoVO = new BbsInfoVO();
        bbsInfoVO.setOrgId(orgId);
        bbsInfoVO.setCrsCreCd(crsCreCd);
        bbsInfoVO.setBbsId(bbsId);
        bbsInfoVO.setSysDefaultYn("Y");
        bbsInfoVO.setUseYn("Y");
        bbsInfoVO = bbsInfoDAO.selectBbsInfo(bbsInfoVO);

        if(bbsInfoVO != null) {

            BbsAtclVO copyAtclVO = new BbsAtclVO();
            copyAtclVO.setOrgId(orgId);
            copyAtclVO.setAtclId(copyAtclId);
            copyAtclVO = bbsAtclDAO.selectBbsAtcl(copyAtclVO);

            if(copyAtclVO == null) {
                // 게시글 정보를 찾을 수 없습니다.
                throw processException("bbs.error.not_exists_atcl");
            }

            // 게시글 복사
            String atclId = IdGenerator.getNewId("ATCL");

            BbsAtclVO bbsAtclVO = new BbsAtclVO();
            bbsAtclVO.setOrgId(orgId);
            bbsAtclVO.setCrsCreCd(crsCreCd);
            bbsAtclVO.setAtclId(atclId);
            bbsAtclVO.setBbsId(bbsId);
            bbsAtclVO.setCopyAtclId(copyAtclId);
            bbsAtclVO.setRgtrId(rgtrId);
            bbsAtclVO.setLineNo(lineNo);
            bbsAtclDAO.insertCopyAtcl(bbsAtclVO);

            if(copyAtclVO.getAtchFileCnt() > 0) {
                FileVO copyFileVO;
                copyFileVO = new FileVO();
                copyFileVO.setOrgId(orgId);
                copyFileVO.setRepoCd("BBS");
                copyFileVO.setFileBindDataSn(atclId);
                copyFileVO.setCopyFileBindDataSn(copyAtclId);
                copyFileVO.setRgtrId(rgtrId);

                sysFileService.copyFileInfoFromOrigin(copyFileVO);
            }
        }
    }

    /*****************************************************
     * 전체공지 최신글 목록
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> listRecentNotice(BbsAtclVO vo) throws Exception {
        List<EgovMap> list = null;

        try {
            list = bbsAtclDAO.listRecentNotice(vo);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
        }

        return list;
    }

    /*****************************************************
     * 강의실 홈 최신글 목록
     * @param vo
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listRecentBbsAtcl(BbsAtclVO vo) throws Exception {
        List<EgovMap> list = null;

        try {
            list = bbsAtclDAO.listRecentBbsAtcl(vo);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
        }

        return list;
    }

    /*****************************************************
     * QnA, 1:1상담 미답변수 정보
     * @param BbsAtclVO
     * @return EgovMap
     * @throws Exception
     ******************************************************/
    @Override
    public EgovMap selectNoAnswerAtclStatus(BbsAtclVO vo) throws Exception {
        EgovMap egovMap = null;

        try {
            egovMap = bbsAtclDAO.selectNoAnswerAtclStatus(vo);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
        }

        return egovMap;
    }



    /*
    TODO 새로 생성되거나 명칭 변경해서 작업하는 메쏘드는 여기 아래에......
    */


    /*****************************************************
     * 게시판게시글 목록
     * @param vo
     * @return ProcessResultVO<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<BbsAtclVO> selectBbsAtclList(BbsAtclVO vo) throws Exception {
        ProcessResultVO<BbsAtclVO> processResultVO = new ProcessResultVO<>();

        // 페이지 정보 설정
        PageInfo pageInfo = new PageInfo(vo);

        // 목록 조회
        List<BbsAtclVO> atclList;
        switch (vo.getBbsId()) {
	        case "QNA":
	            atclList = bbsAtclDAO.selectBbsLctrQnaList(vo);
	            break;

	        case "1ON1":
	            atclList = bbsAtclDAO.selectBbsDscsnList(vo);
	            break;

	        case "NTC":
	            atclList = bbsAtclDAO.selectBbsSbjctList(vo);
	            break;

	        default:
	            atclList = bbsAtclDAO.selectBbsAtclList(vo);
	            break;
	    }

        // 페이지 전체 건수정보 설정
       	pageInfo.setTotalRecord(atclList);

        processResultVO.setReturnList(atclList);
        processResultVO.setPageInfo(pageInfo);

        return processResultVO;
    }


    /*****************************************************
     * 게시판게시글 조회
     * @param bbsAtclVO
     * @return BbsAtclVO
     * @throws Exception
     ******************************************************/
    @Override
    public BbsAtclVO selectBbsAtcl(BbsAtclVO bbsAtclVO) throws Exception {
    	ProcessResultVO<BbsAtclVO> processResultVO = new ProcessResultVO<>();

    	// 게시글조회
        bbsAtclVO = bbsAtclDAO.selectBbsAtcl(bbsAtclVO);

        if(bbsAtclVO != null) {
        	// 이전글/다음글
            BbsAtclVO prevNextAtclVO = bbsAtclDAO.selecBbsAtclPrevNext(bbsAtclVO);
            if(prevNextAtclVO != null) {
                bbsAtclVO.setPrevAtclId(prevNextAtclVO.getPrevAtclId());
                bbsAtclVO.setPrevAtclTtl(prevNextAtclVO.getPrevAtclTtl());
                bbsAtclVO.setNextAtclId(prevNextAtclVO.getNextAtclId());
                bbsAtclVO.setNextAtclTtl(prevNextAtclVO.getNextAtclTtl());
            }

            // 첨부파일
            if(bbsAtclVO.getFileCnt() > 0) {
                AtflVO atflVO = new AtflVO();
                atflVO.setRefId(bbsAtclVO.getAtclId());

                List<AtflVO> fileList = attachFileService.selectAtflListByRefId(atflVO);
                bbsAtclVO.setFileList(fileList);
            }

            bbsAtclDAO.bbsAtclHitsModify(bbsAtclVO);
        }

        return bbsAtclVO;
    }


    /*****************************************************
     * 게시판게시글 수정
     * @param vo
     * @throws Exception
     ******************************************************/
    @Override
    public void updateBbsAtcl(BbsAtclVO vo) throws Exception {
        String bbsId = vo.getBbsId();

        // 비공개여부
        if(ValidationUtils.isEmpty(vo.getLockYn())) {
            vo.setLockYn("N");
        }

        // 등록예약
        if(!"Y".equals(StringUtil.nvl(vo.getRsrvUseYn()))) {
            vo.setRsrvDttm(null);
        }

        // 일대일 상담 여부
        if(!"SECRET".equals(StringUtil.nvl(bbsId))) {
            vo.setDscsnProfId(null);
        }

        LOGGER.debug("bbsId     : " + vo.getBbsId());
        LOGGER.debug("atclId    : " + vo.getAtclId());

        if("NOTICE".equals(bbsId)) {
            LOGGER.debug("중요글           : " + vo.getImptYn());
            LOGGER.debug("고정글           : " + vo.getNoticeYn());
            LOGGER.debug("atclTitle : " + vo.getAtclTtl());
            LOGGER.debug("atclCts   : " + vo.getAtclCts());
            LOGGER.debug("댓글사용        : " + vo.getCmntUseYn());
            LOGGER.debug("분반List   : " + vo.getDeclsList());
            LOGGER.debug("비공개여부     : " + vo.getLockYn());
        } else if("QNA".equals(bbsId) || "SECRET".equals(bbsId)) {
            LOGGER.debug("상담교수        : " + vo.getDscsnProfId());
            LOGGER.debug("atclTitle : " + vo.getAtclTtl());
            LOGGER.debug("atclCts   : " + vo.getAtclCts());
            LOGGER.debug("댓글사용        : " + vo.getCmntUseYn());
            LOGGER.debug("비공개여부     : " + vo.getLockYn());
        } else if("PDS".equals(bbsId)) {
            LOGGER.debug("중요글           : " + vo.getImptYn());
            LOGGER.debug("고정글           : " + vo.getNoticeYn());
            LOGGER.debug("atclTitle : " + vo.getAtclTtl());
            LOGGER.debug("atclCts   : " + vo.getAtclCts());
            LOGGER.debug("댓글사용        : " + vo.getCmntUseYn());
            LOGGER.debug("좋아요사용     : " + vo.getGoodUseYn());
            LOGGER.debug("분반List   : " + vo.getDeclsList());
            LOGGER.debug("등록예약        : " + vo.getRsrvUseYn());
            LOGGER.debug("예약일시        : " + vo.getRsrvDttm());
            LOGGER.debug("비공개여부     : " + vo.getLockYn());
        }

        String uploadFiles = vo.getUploadFiles();
        String uploadPath = vo.getUploadPath();

        List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(vo.getUploadFiles(), vo.getUploadPath());
        //List<FileVO> copyFileList = FileUtil.getUploadFileList(vo.getCopyFiles());

        try {
            // 스크립트 태그 제거
            vo.setAtclTtl(StringUtil.removeScript(vo.getAtclTtl()));
            // TODO -->> 내용은 저장할때 태그 제거하지 않고 내용 조회할때 태그제거하도록 변경해야함...
            //vo.setAtclCts(StringUtil.removeScript(vo.getAtclCts()));

            // 수정 - 게시글
            bbsAtclDAO.updateBbsAtcl(vo);
            // 수정 - 게시글 옵션
            bbsAtclDAO.bbsAtclOptnRegist(vo);

            // 첨부파일
            if (uploadFileList.size() > 0) {
            	for (AtflVO atflVO : uploadFileList) {
            		atflVO.setRefId(vo.getAtclId());
            		atflVO.setRgtrId(vo.getRgtrId());
            		atflVO.setMdfrId(vo.getMdfrId());
            		atflVO.setAtflRepoId(CommConst.REPO_BBS);
            	}

            	// 첨부파일 저장
            	attachFileService.insertAtflList(uploadFileList);
            }

            // 첨부파일 삭제
            attachFileService.deleteAtflByAtflIds(vo.getDelFileIds());

            /*
            // 분반 동시 업데이트
            String declsAtclIds = vo.getDvclasRegAtclId();

            if(ValidationUtils.isNotEmpty(declsAtclIds) && ("NOTICE".equals(bbsId) || "PDS".equals(bbsId))) {
                String[] declsAtclIdList = declsAtclIds.split(",");

                for(String declsAtclId : declsAtclIdList) {
                    if(!declsAtclId.equals(atclId)) {

                        // 1.수정
                        vo.setAtclId(declsAtclId);
                        bbsAtclDAO.updateBbsAtcl(vo);

                        // 파일 업로드
                        if(isFileChanged) {
                            // 2.분반 게시글 정보조회
                            BbsAtclVO bbsAtclVO = new BbsAtclVO();
                            bbsAtclVO.setOrgId(vo.getOrgId());
                            bbsAtclVO.setAtclId(declsAtclId);
                            bbsAtclVO = bbsAtclDAO.selectBbsAtcl(bbsAtclVO);

                            if(bbsAtclVO == null) {
                                continue;
                            }

                            // 3.원글의 파일정보
                            FileVO fileVO = new FileVO();
                            fileVO.setRepoCd("BBS");
                            fileVO.setFileBindDataSn(atclId);
                            List<FileVO> originFileList = (List<FileVO>) sysFileService.list(fileVO).getReturnList();
                            List<Map<String, String>> fileMapList = new ArrayList<>();
                            for(FileVO fvo2 : originFileList) {
                                Map<String, String> map = new HashMap<>();
                                map.put("fileNm", fvo2.getFileNm());
                                map.put("fileId", fvo2.getFileId());
                                map.put("fileSize", fvo2.getFileSize().toString());
                                map.put("fileSaveNm", fvo2.getFileSaveNm());
                                map.put("filePath", fvo2.getFilePath());
                                fileMapList.add(map);
                            }
                            JSONArray copyFileJsonArray = JSONArray.fromObject(fileMapList);
                            String declsCopyFiles = copyFileJsonArray.toString();

                            // 4.분반 게시글 파일정보 조회
                            fileVO = new FileVO();
                            fileVO.setRepoCd("BBS");
                            fileVO.setFileBindDataSn(declsAtclId);
                            List<FileVO> fileList = sysFileService.list(fileVO).getReturnList();

                            // 5.분반 게시글 기존 파일 제거
                            for(FileVO fvo : fileList) {
                                sysFileService.removeFile(fvo.getFileSn());
                            }

                            // 6.수정글의 파일 분반 게시글로 복사
                            fileVO = new FileVO();
                            fileVO.setCopyFiles(declsCopyFiles);
                            fileVO.setFilePath("/bbs/" + bbsAtclVO.getBbsId());
                            fileVO.setRepoCd("BBS");
                            fileVO.setRgtrId(vo.getRgtrId());
                            fileVO.setFileBindDataSn(declsAtclId);
                            fileVO = sysFileService.addFile(fileVO);
                        }
                    }

                }
            }
            */
        } catch(Exception e) {
            LOGGER.debug("e: ", e);

            if(uploadFileList.size() > 0) {
                FileUtil.delUploadFileList(uploadFiles, uploadPath);
            }

            throw e;
        }
    }

    /*****************************************************
     * 대시보드 카드 목록
     * @param bbsAtclVO
     * @return BbsAtclVO
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> listRecentBbsToday(BbsAtclVO vo) throws Exception {
        List<EgovMap> list = null;

        try {
            list = bbsAtclDAO.listRecentBbsToday(vo);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
        }

        return list;
    }

    @Override
    public List<EgovMap> listRecentBbsLctrQna(BbsAtclVO vo) throws Exception {
        List<EgovMap> list = null;

        try {
            list = bbsAtclDAO.listRecentBbsLctrQna(vo);
        } catch(Exception e) {
            LOGGER.debug("e: ", e);
        }

        return list;
    }

    /*****************************************************
     * 답변 저장
     * @param vo
     * @throws Exception
     ******************************************************/
    @Override
    public void bbsAtclRspnsRegist(BbsAtclVO vo) throws Exception {
    	int count = bbsAtclDAO.bbsAtclCnt(vo);

        if (count > 0) {
            // 데이터가 있으면 업데이트
        	bbsAtclDAO.bbsAtclRspnsModify(vo);
        } else {
            // 데이터가 없으면 신규 등록
        	vo.setAtclId(IdGenUtil.genNewId(IdPrefixType.BBATC));
        	bbsAtclDAO.bbsAtclRspnsRegist(vo);
        }
    }

    /*****************************************************
     * 메뉴 > 글로벌메뉴 > 과목공지 저장
     * @param vo
     * @throws Exception
     ******************************************************/
    @Override
    public void bbsAtclSbjctRegist(BbsAtclVO vo) throws Exception {

    	String atclId = vo.getAtclId();
    	String atclOptnId = vo.getAtclOptnId();


    	// 데이터가 없으면 신규 등록
    	if (atclId == null || atclId.trim().isEmpty()) {
    	    vo.setAtclId(IdGenUtil.genNewId(IdPrefixType.BBATC));
    	}

    	if (atclOptnId == null || atclOptnId.trim().isEmpty()) {
    		vo.setAtclOptnId(IdGenUtil.genNewId(IdPrefixType.BBOPT));
    	}

    	// TB_LMS_BBS_ATCL
    	bbsAtclDAO.bbsAtclSbjctRegist(vo);

    	// TB_LMS_BBS_ATCL_OPTN
    	bbsAtclDAO.bbsAtclOptnRegist(vo);

    	List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(vo.getUploadFiles(), vo.getUploadPath());
        Map<String, List<AtflVO>> declsCopyFileListMap = new HashMap<>();

    	// 첨부파일
        if (uploadFileList.size() > 0) {
        	for (AtflVO atflVO : uploadFileList) {
        		atflVO.setAtflId(IdGenUtil.genNewId(IdPrefixType.ATFL));
        		atflVO.setRefId(vo.getAtclId());
        		atflVO.setRgtrId(vo.getRgtrId());
        		atflVO.setMdfrId(vo.getMdfrId());
        		atflVO.setAtflRepoId(CommConst.REPO_BBS); // 첨부파일 저장소 아이디
        	}

        	// 첨부파일 저장
        	attachFileService.insertAtflList(uploadFileList);
        }
    }

    /*****************************************************
     * 메뉴 > 글로벌메뉴 > 과목공지 상세 불러오기 (단일 조회)
     * @param vo
     * @return ProcessResultVO<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<BbsAtclVO> selectBbsSbjctDtlView(BbsAtclVO vo) throws Exception {
        ProcessResultVO<BbsAtclVO> resultVO = new ProcessResultVO<>();

        try {
            // 1. 단일 데이터 조회 (Mapper의 selectOne 호출)
            // 파라미터로 넘어온 PK(예: atclSn 등)를 사용하여 1건만 가져옵니다.
            BbsAtclVO detailVO = bbsAtclDAO.selectBbsSbjctDtlView(vo);

            if (detailVO != null) {
                // 2. 조회된 단일 객체를 결과 VO에 세팅
                resultVO.setReturnVO(detailVO);
                resultVO.setResult(1); // 성공 코드
            } else {
                // 데이터가 없는 경우 처리
                resultVO.setResult(0);
                resultVO.setMessage("조회된 데이터가 없습니다.");
            }
        } catch (Exception e) {
            LOGGER.error("과목공지 상세 조회 실패: ", e);
            resultVO.setResult(-1);
            resultVO.setMessage("데이터를 불러오는 중 오류가 발생했습니다.");
            throw e; // 호출한 Controller로 에러 전파
        }

        return resultVO;
    }

    /*****************************************************
     * 게시판게시글 목록
     * @param vo
     * @return ProcessResultVO<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<BbsAtclVO> selectBbsAtclGrpNtcList(BbsAtclVO vo) throws Exception {
        ProcessResultVO<BbsAtclVO> processResultVO = new ProcessResultVO<>();

        // 페이지 정보 설정
        PageInfo pageInfo = new PageInfo(vo);

        // 목록 조회
        List<BbsAtclVO> atclList;

	    atclList = bbsAtclDAO.selectBbsAtclGrpNtcList(vo);

        // 페이지 전체 건수정보 설정
       	pageInfo.setTotalRecord(atclList);

        processResultVO.setReturnList(atclList);
        processResultVO.setPageInfo(pageInfo);

        return processResultVO;
    }

    @Override
    public ProcessResultVO<BbsAtclVO> selectBbsAtclGrpNtcPopView(BbsAtclVO vo) throws Exception {
        ProcessResultVO<BbsAtclVO> processResultVO = new ProcessResultVO<>();

        // 페이지 정보 설정
        PageInfo pageInfo = new PageInfo(vo);

        // 목록 조회
        List<BbsAtclVO> atclList;

	    atclList = bbsAtclDAO.selectBbsAtclGrpNtcList(vo);

        // 페이지 전체 건수정보 설정
       	pageInfo.setTotalRecord(atclList);

        processResultVO.setReturnList(atclList);
        processResultVO.setPageInfo(pageInfo);

        return processResultVO;
    }

    /*****************************************************
     * 게시판게시글 목록
     * @param vo
     * @return ProcessResultVO<BbsAtclVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<BbsAtclVO> selectBbsAtclRspnsList(BbsAtclVO vo) throws Exception {
        ProcessResultVO<BbsAtclVO> processResultVO = new ProcessResultVO<>();

        // 페이지 정보 설정
        PageInfo pageInfo = new PageInfo(vo);

        // 목록 조회
        List<BbsAtclVO> atclList = bbsAtclDAO.selectBbsAtclRspnsList(vo);

        // 페이지 전체 건수정보 설정
       	pageInfo.setTotalRecord(atclList);

        processResultVO.setReturnList(atclList);
        processResultVO.setPageInfo(pageInfo);

        return processResultVO;
    }
}