package knou.lms.forum2.service.impl;

import java.util.List;

import javax.annotation.Resource;

import knou.lms.forum2.vo.DscsJoinUserVO;
import knou.framework.common.CommConst;
import knou.framework.common.IdPrefixType;
import knou.framework.util.FileUtil;
import knou.framework.util.IdGenUtil;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.common.paging.PagingInfo;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflVO;
import knou.lms.forum2.dao.DscsAtclDAO;
import knou.lms.forum2.dao.DscsCmntDAO;
import knou.lms.forum2.dao.DscsJoinUserDAO;
import knou.lms.forum2.service.DscsAtclService;
import knou.lms.forum2.vo.DscsAtclVO;
import knou.lms.forum2.vo.DscsCmntVO;
import knou.lms.forum2.vo.DscsMutVO;

@Service("dscsAtclService")
public class DscsAtclServiceImpl extends ServiceBase implements DscsAtclService {

    private static final Logger LOGGER = LoggerFactory.getLogger(DscsAtclServiceImpl.class);

    @Resource(name = "dscsAtclDAO")
    private DscsAtclDAO forumAtclDAO;

    @Resource(name = "dscsCmntDAO")
    private DscsCmntDAO forumCmntDAO;

    @Resource(name = "dscsJoinUserDAO")
    private DscsJoinUserDAO dscsJoinUserDAO;

    @Resource(name = "attachFileService")
    private AttachFileService attachFileService;

    // 토론 게시글 수 카운팅
    @Override
    public int forumAtclCount(DscsAtclVO vo) throws Exception {
        return forumAtclDAO.forumAtclCount(vo);
    }

    // 토론 게시글 페이징 목록 조회
    @Override
    public ProcessResultVO<DscsAtclVO> listPageing(DscsAtclVO vo) throws Exception {
        ProcessResultVO<DscsAtclVO> resultList = new ProcessResultVO<>();
        try {
            /** start of paging */
            PagingInfo paginationInfo = new PagingInfo();
            paginationInfo.setCurrentPageNo(vo.getPageIndex());
            paginationInfo.setRecordCountPerPage(vo.getListScale());
            paginationInfo.setPageSize(vo.getPageScale());

            vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
            vo.setLastIndex(paginationInfo.getLastRecordIndex());

            if (vo.getStdList() != null) {
                String[] stdArray = vo.getStdList().split(",");
                if (stdArray[0].equals("")) {
                    stdArray = null;
                }
                vo.setSqlForeach(stdArray);
            }
            int totalCount = forumAtclDAO.count(vo);
            paginationInfo.setTotalRecordCount(totalCount);

            List<DscsAtclVO> forumAtclList = forumAtclDAO.listPageing(vo);
            if (forumAtclList != null) {
                for (DscsAtclVO row : forumAtclList) {
                    AtflVO atflParam = new AtflVO();
                    atflParam.setAtflRepoId(CommConst.REPO_DSCS);
                    atflParam.setRefId(row.getAtclSn());
                    row.setFileList(attachFileService.selectAtflListByRefId(atflParam));
                    row.setViewAll(vo.isViewAll());
                    List<DscsCmntVO> cmntList = forumCmntDAO.cmntList(row);
                    row.setCmntList(cmntList);
                }
            }

            resultList.setResult(1);
            resultList.setReturnList(forumAtclList);
            resultList.setPageInfo(paginationInfo);
        } catch (Exception e) {
            resultList.setResult(-1);
            resultList.setMessage(e.getMessage());
        }
        return resultList;
    }

    // 토론 게시글 등록
    @Override
    public void insertAtcl(DscsAtclVO vo, String teamCd) throws Exception {
        // 내용길이 저장
        vo.setCtsLen(StringUtil.getContentLenth(vo.getCts()));

        forumAtclDAO.insertAtcl(vo);

        // 토론참여자 테이블 등록 (게시글 작성 시 단건)
        // DscsJoinUserVO.stdId = TB_LMS_DSCS_PTCP.USER_ID = 로그인 userId (listStdScore SQL: A.USER_ID AS stdId)
        DscsJoinUserVO joinVO = new DscsJoinUserVO();
        joinVO.setForumCd(vo.getForumCd());
        joinVO.setStdId(vo.getUserId());
        joinVO.setTeamCd(StringUtil.nvl(teamCd));
        joinVO.setRgtrId(vo.getRgtrId());
        joinVO.setMdfrId(vo.getMdfrId());
        joinVO.setDscsPtcpId(IdGenerator.getNewId(IdPrefixType.DSPTC.getCode()));
        try {
            dscsJoinUserDAO.ensureJoinUser(joinVO);
        } catch (org.springframework.dao.DataIntegrityViolationException e) {
            // UNIQUE 제약 위반 = 이미 존재 → 무시
            LOGGER.debug("[insertAtcl] ensureJoinUser skip - already exists: forumCd=" + vo.getForumCd() + ", userId=" + vo.getUserId());
        }

        // 파일 등록 (attachFileService)
        List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(vo.getUploadFiles(), vo.getUploadPath());
        for (AtflVO atflVO : uploadFileList) {
            atflVO.setAtflId(IdGenUtil.genNewId(IdPrefixType.ATFL));
            atflVO.setRefId(vo.getAtclSn());
            atflVO.setRgtrId(vo.getRgtrId());
            atflVO.setMdfrId(vo.getMdfrId());
            atflVO.setAtflRepoId(CommConst.REPO_DSCS);
        }
        if (!uploadFileList.isEmpty()) {
            attachFileService.insertAtflList(uploadFileList);
        }
    }

    // 토론 게시글 조회
    @Override
    public DscsAtclVO selectAtcl(DscsAtclVO vo) throws Exception {
        return forumAtclDAO.selectAtcl(vo);
    }

    // 토론 게시글 수정
    @Override
    public void updateAtcl(DscsAtclVO vo) throws Exception {
        // 내용길이 저장
        vo.setCtsLen(StringUtil.getContentLenth(vo.getCts()));

        forumAtclDAO.updateAtcl(vo);

	// TODO : 26.3.10(AS-IS Ref)
	/*
        // 이전 시험 가져오기 파일 복사
        prevCopyFileAdd(vo);
        
        // 파일 등록
        FileVO fileVO = addFile(vo);
        
        if(vo.getDelFileIds().length > 0) {
            for(String delFileId : vo.getDelFileIds()) {
                FileVO delFileVO = new FileVO();
                delFileVO.setRepoCd("FORUM");
                delFileVO.setFileBindDataSn(vo.getAtclSn());
                List<FileVO> fileList = sysFileService.list(delFileVO).getReturnList();

                for(FileVO fvo : fileList) {
                    if(delFileId.equals(fvo.getFileSaveNm().substring(0, fvo.getFileSaveNm().indexOf(".")))) {
                        sysFileService.removeFile(fvo.getFileSn());
                    }
                }
            }
        }
	*/
    }

    // 토론 게시글 삭제
    @Override
    public void deleteAtcl(DscsAtclVO vo) throws Exception {
        forumAtclDAO.deleteAtcl(vo);

	// TODO : 26.3.10(AS-IS Ref)
	/*
        // 파일 처리 로직 수정. 다중파일을 위한 List 처리
//      this.saveFiles(vo);
        
        DscsForumVO forumVO = new DscsForumVO();
        forumVO.setForumCd(vo.getForumCd());
        forumVO = forumDAO.selectForum(forumVO);
        if("R".equals(StringUtil.nvl(forumVO.getEvalCtgr()))) {
            DscsAtclVO forumAtclVO = forumAtclDAO.selectAtcl(vo);
            
            String rgtrId = forumAtclVO.getRgtrId();
            
            StdVO svo = new StdVO();
            svo.setUserId(rgtrId);
            svo.setCrsCreCd(forumVO.getCrsCreCd());
            svo = stdDAO.selectStd(svo);
            
            if(svo != null) {
                forumAtclVO = new DscsAtclVO();
                forumAtclVO.setCrsCreCd(svo.getCrsCreCd());
                forumAtclVO.setForumCd(vo.getForumCd());
                forumAtclVO.setUserId(rgtrId);
                int atclCnt = forumAtclDAO.myAtclCnt(forumAtclVO);
                
                if(atclCnt == 0) {
                    DscsJoinUserVO forumJoinUserVO = new DscsJoinUserVO();
                    forumJoinUserVO.setForumCd(vo.getForumCd());
                    forumJoinUserVO.setStdId(svo.getStdId());
                    forumJoinUserVO.setMdfrId(vo.getMdfrId());
                    dscsJoinUserDAO.updateJoinUserEvalN(forumJoinUserVO);
                }
            }
        }
	*/
    }

    // 토론 게시글 숨김
    @Override
    public void hideAtcl(DscsAtclVO vo) throws Exception {
        forumAtclDAO.hideAtcl(vo);
    }

    // 나의 상호평가 결과
  /*  @Override
    public DscsAtclVO selectMutResult(DscsAtclVO vo) throws Exception {
        return forumAtclDAO.selectMutResult(vo);
    }*/

    // 특정 수강생의 토론 게시글 조회
/*    @Override
    public List<DscsAtclVO> selectAtclUserList(DscsMutVO vo) throws Exception {
        return forumAtclDAO.selectAtclUserList(vo);
    }*/

    // 토론 게시글 조회
    @Override
    public List<DscsAtclVO> forumAtclList(DscsAtclVO vo) throws Exception {
        return forumAtclDAO.forumAtclList(vo);
    }

    // 본인의 토론글 등록 갯수
    @Override
    public int myAtclCnt(DscsAtclVO vo) throws Exception {
        return forumAtclDAO.myAtclCnt(vo);
    }

    // 토론 게시글 엑셀목록 조회
    @Override
    public List<DscsAtclVO> forumAtclExcalList(DscsAtclVO vo) throws Exception {
        return forumAtclDAO.forumAtclExcalList(vo);
    }

	// TODO : 26.3.10(AS-IS Ref)
	/*
    // // 이전 토론 가져오기 첨부파일 복사
    private void prevCopyFileAdd(DscsAtclVO vo) throws Exception {
        if(!"".equals(StringUtil.nvl(vo.getSearchTo())) && !"".equals(StringUtil.nvl(vo.getFileSns()))) {
            // 기존 파일 삭제
            FileVO delFileVO = new FileVO();
            delFileVO.setRepoCd(vo.getRepoCd());
            delFileVO.setFileBindDataSn(vo.getForumCd());
            List<FileVO> delFileList = sysFileService.list(delFileVO).getReturnList();
            for(FileVO dfvo : delFileList) {
                sysFileService.removeFile(dfvo);
            }
            
            // 이전 시험 파일 복사
            FileVO fileVO = new FileVO();
            fileVO.setRepoCd(vo.getRepoCd());
            fileVO.setFileBindDataSn(vo.getSearchTo());
            fileVO.setFileSnList(StringUtil.nvl(vo.getFileSns()).split(","));
            List<FileVO> fileList = sysFileService.list(fileVO).getReturnList();
            String fileSns = "";
            // 이전 파일 중 삭제 클릭 파일 제외
            for(FileVO list : fileList) {
                String fileId = list.getFileId();
                boolean isChk = true;
                for(String delFileId : vo.getDelFileIds()) {
                    if(fileId.equals(delFileId)) {
                        isChk = false;
                    }
                }
                if(isChk) {
                    fileSns += list.getFileSn() + ",";
                }
            }
            if(!"".equals(fileSns)) {
                fileVO.setFileSnList(fileSns.split(","));
            }
            fileList = sysFileService.list(fileVO).getReturnList();
            fileVO.setFileList(fileList);
            List<Map<String, String>> uploadFiles = new ArrayList<Map<String, String>>();
            for(FileVO fvo2 : fileList) {
                Map<String, String> map = new HashMap<String, String>();
                map.put("fileNm", fvo2.getFileNm());
                map.put("fileId", fvo2.getFileId());
                map.put("fileSize", fvo2.getFileSize().toString());
                uploadFiles.add(map);
            }
            JSONArray uploadFile = JSONArray.fromObject(uploadFiles);
            fileVO.setUploadFiles(uploadFile.toString());
            fileVO.setFilePath(vo.getUploadPath());
            fileVO.setRgtrId(vo.getRgtrId());
            fileVO.setFileBindDataSn(vo.getForumCd());
            sysFileService.copyFile(fileVO);
        }
    }
	*/
}
