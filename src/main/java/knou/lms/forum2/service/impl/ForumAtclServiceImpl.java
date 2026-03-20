package knou.lms.forum2.service.impl;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.framework.util.StringUtil;
import knou.framework.vo.FileVO;
import knou.lms.common.paging.PagingInfo;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.dao.ForumAtclDAO;
import knou.lms.forum2.dao.ForumCmntDAO;
import knou.lms.forum2.service.ForumAtclService;
import knou.lms.forum.vo.ForumAtclVO;
import knou.lms.forum.vo.ForumCmntVO;
import knou.lms.forum.vo.ForumMutVO;

@Service("forum2AtclService")
public class ForumAtclServiceImpl extends ServiceBase implements ForumAtclService {

    @Resource(name = "forum2AtclDAO")
    private ForumAtclDAO forumAtclDAO;

    @Resource(name = "forum2CmntDAO")
    private ForumCmntDAO forumCmntDAO;

    @Autowired
    private SysFileService sysFileService;

    // 토론 게시글 수 카운팅
    @Override
    public int forumAtclCount(ForumAtclVO vo) throws Exception {
        return forumAtclDAO.forumAtclCount(vo);
    }

    // 토론 게시글 페이징 목록 조회
    @Override
    public ProcessResultVO<ForumAtclVO> listPageing(ForumAtclVO vo) throws Exception {
        ProcessResultVO<ForumAtclVO> resultList = new ProcessResultVO<>();
        try {
            /** start of paging */
            PagingInfo paginationInfo = new PagingInfo();
            paginationInfo.setCurrentPageNo(vo.getPageIndex());
            paginationInfo.setRecordCountPerPage(vo.getListScale());
            paginationInfo.setPageSize(vo.getPageScale());

            vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
            vo.setLastIndex(paginationInfo.getLastRecordIndex());

	// TODO : 26.3.10(AS-IS Ref)
/*
            String[] stdArray = vo.getStdList().split(",");
            if (stdArray[0].equals("")) {
                stdArray = null;
            }
            vo.setSqlForeach(stdArray);
*/
            int totalCount = forumAtclDAO.count(vo);
            paginationInfo.setTotalRecordCount(totalCount);

            List<ForumAtclVO> forumAtclList = forumAtclDAO.listPageing(vo);
            if (forumAtclList != null) {
                for (ForumAtclVO row : forumAtclList) {
                    FileVO fileVO = new FileVO();
                    fileVO.setRepoCd("FORUM");
                    fileVO.setFileBindDataSn(row.getAtclSn());
                    // TODO : 26.3.11 : 게시글 첨부파일 참조 구조 변경됨.
//                    row.setFileList(sysFileService.list(fileVO).getReturnList());
                    row.setFileList(new ArrayList<>());
                    List<ForumCmntVO> cmntList = forumCmntDAO.cmntList(row);
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
    public void insertAtcl(ForumAtclVO vo) throws Exception {
        // 내용길이 저장
        vo.setCtsLen(StringUtil.getContentLenth(vo.getCts()));
        
        forumAtclDAO.insertAtcl(vo);

        addFile(vo);

	// TODO : 26.3.10(AS-IS Ref)
        /*
        // 토론참여자 테이블 등록
        StdVO svo = new StdVO();
        svo.setUserId(vo.getUserId());
        svo.setCrsCreCd(vo.getCrsCreCd());
        svo = stdDAO.selectStd(svo);
        if (svo != null) {
	        ForumVO fvo = new ForumVO();
	        fvo.setRgtrId(vo.getRgtrId());
	        fvo.setCrsCreCd(vo.getCrsCreCd());
	        fvo.setStdId(svo.getStdId());
	        fvo.setForumCd(vo.getForumCd());
	        ForumVO forumVO = new ForumVO();
	        forumVO.setForumCd(vo.getForumCd());
	        forumVO = forumDAO.selectForum(forumVO);
	        if("R".equals(StringUtil.nvl(forumVO.getEvalCtgr()))) {
	            fvo.setSearchKey("INSERT");
	        }
	        forumJoinUserDAO.insertJoinUser(fvo);
        }
        
        // 이전 시험 가져오기 파일 복사
        prevCopyFileAdd(vo);
        // 파일 등록
        FileVO fileVO = addFile(vo);
	*/

    }

    // 토론 게시글 조회
    @Override
    public ForumAtclVO selectAtcl(ForumAtclVO vo) throws Exception {
        return forumAtclDAO.selectAtcl(vo);
    }

    // 토론 게시글 수정
    @Override
    public void updateAtcl(ForumAtclVO vo) throws Exception {
        // 내용길이 저장
        vo.setCtsLen(StringUtil.getContentLenth(vo.getCts()));

        forumAtclDAO.updateAtcl(vo);
        addFile(vo);

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
    public void deleteAtcl(ForumAtclVO vo) throws Exception {
        forumAtclDAO.deleteAtcl(vo);

	// TODO : 26.3.10(AS-IS Ref)
	/*
        // 파일 처리 로직 수정. 다중파일을 위한 List 처리
//      this.saveFiles(vo);
        
        ForumVO forumVO = new ForumVO();
        forumVO.setForumCd(vo.getForumCd());
        forumVO = forumDAO.selectForum(forumVO);
        if("R".equals(StringUtil.nvl(forumVO.getEvalCtgr()))) {
            ForumAtclVO forumAtclVO = forumAtclDAO.selectAtcl(vo);
            
            String rgtrId = forumAtclVO.getRgtrId();
            
            StdVO svo = new StdVO();
            svo.setUserId(rgtrId);
            svo.setCrsCreCd(forumVO.getCrsCreCd());
            svo = stdDAO.selectStd(svo);
            
            if(svo != null) {
                forumAtclVO = new ForumAtclVO();
                forumAtclVO.setCrsCreCd(svo.getCrsCreCd());
                forumAtclVO.setForumCd(vo.getForumCd());
                forumAtclVO.setUserId(rgtrId);
                int atclCnt = forumAtclDAO.myAtclCnt(forumAtclVO);
                
                if(atclCnt == 0) {
                    ForumJoinUserVO forumJoinUserVO = new ForumJoinUserVO();
                    forumJoinUserVO.setForumCd(vo.getForumCd());
                    forumJoinUserVO.setStdId(svo.getStdId());
                    forumJoinUserVO.setMdfrId(vo.getMdfrId());
                    forumJoinUserDAO.updateJoinUserEvalN(forumJoinUserVO);
                }
            }
        }
	*/
    }

    // 나의 상호평가 결과
  /*  @Override
    public ForumAtclVO selectMutResult(ForumAtclVO vo) throws Exception {
        return forumAtclDAO.selectMutResult(vo);
    }*/

    // 특정 수강생의 토론 게시글 조회
/*    @Override
    public List<ForumAtclVO> selectAtclUserList(ForumMutVO vo) throws Exception {
        return forumAtclDAO.selectAtclUserList(vo);
    }*/

    // 토론 게시글 조회
    @Override
    public List<ForumAtclVO> forumAtclList(ForumAtclVO vo) throws Exception {
        return forumAtclDAO.forumAtclList(vo);
    }

    // 본인의 토론글 등록 갯수
    @Override
    public int myAtclCnt(ForumAtclVO vo) throws Exception {
        return forumAtclDAO.myAtclCnt(vo);
    }

    // 토론 게시글 엑셀목록 조회
    @Override
    public List<ForumAtclVO> forumAtclExcalList(ForumAtclVO vo) throws Exception {
        return forumAtclDAO.forumAtclExcalList(vo);
    }

    // 첨부파일 등록
    private void addFile(ForumAtclVO vo) throws Exception {
        if ("".equals(StringUtil.nvl(vo.getUploadFiles()))) {
            return;
        }
        FileVO fileVO = new FileVO();
        fileVO.setUploadFiles(StringUtil.nvl(vo.getUploadFiles()));
        fileVO.setFilePath(vo.getUploadPath());
        fileVO.setRepoCd(vo.getRepoCd());
        fileVO.setRgtrId(vo.getRgtrId());
        fileVO.setFileBindDataSn(vo.getAtclSn());
        sysFileService.addFile(fileVO);
    }
	// TODO : 26.3.10(AS-IS Ref)
	/*
    // // 이전 토론 가져오기 첨부파일 복사
    private void prevCopyFileAdd(ForumAtclVO vo) throws Exception {
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
