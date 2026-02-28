package knou.lms.forum.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.framework.common.ServiceBase;
import knou.framework.util.StringUtil;
import knou.framework.vo.FileVO;
import knou.lms.common.paging.PagingInfo;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum.dao.ForumAtclDAO;
import knou.lms.forum.dao.ForumCmntDAO;
import knou.lms.forum.dao.ForumDAO;
import knou.lms.forum.dao.ForumJoinUserDAO;
import knou.lms.forum.service.ForumAtclService;
import knou.lms.forum.vo.ForumAtclVO;
import knou.lms.forum.vo.ForumCmntVO;
import knou.lms.forum.vo.ForumJoinUserVO;
import knou.lms.forum.vo.ForumMutVO;
import knou.lms.forum.vo.ForumVO;
import knou.lms.std.dao.StdDAO;
import knou.lms.std.vo.StdVO;
import net.sf.json.JSONArray;

@Service("forumAtclService")
public class ForumAtclServiceImpl extends ServiceBase implements ForumAtclService {

    @Resource(name="forumAtclDAO")
    private ForumAtclDAO         forumAtclDAO;
    
    @Resource(name="forumCmntDAO")
    private ForumCmntDAO         forumCmntDAO;
    
    @Resource(name="forumJoinUserDAO")
    private ForumJoinUserDAO     forumJoinUserDAO;
    
    @Resource(name="stdDAO")
    private StdDAO               stdDAO;
    
    @Resource(name="forumDAO")
    private ForumDAO             forumDAO;
    
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
            
            String[] stdArray = vo.getStdList().split(",");
            if (stdArray[0].equals("")) {
                stdArray = null;
            }
            vo.setSqlForeach(stdArray);
                            
            // 전체 목록 수
            int totalCount = forumAtclDAO.count(vo);
            paginationInfo.setTotalRecordCount(totalCount);
            
            List<ForumAtclVO> forumAtclList =  forumAtclDAO.listPageing(vo);
            if(forumAtclList != null) {
                for(ForumAtclVO vo1 : forumAtclList) {
                    FileVO fileVO = new FileVO();
                    fileVO.setRepoCd("FORUM");
                    fileVO.setFileBindDataSn(vo1.getAtclSn());
                    List<FileVO> fileList = sysFileService.list(fileVO).getReturnList();
                    vo1.setFileList(fileList);
                    
                    List<ForumCmntVO> cmntList = forumCmntDAO.cmntList(vo1);
                    vo1.setCmntList(cmntList);
                }
            }
            resultList.setResult(1);
            resultList.setReturnList(forumAtclList);
            resultList.setPageInfo(paginationInfo);
            
        } catch (Exception e) {
            e.printStackTrace();
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
    }

    // 토론 게시글 조회
    @Override
    public ForumAtclVO selectAtcl(ForumAtclVO vo) throws Exception {
        vo = forumAtclDAO.selectAtcl(vo);
        
        return vo;
    }

    // 토론 게시글 수정
    @Override
    public void updateAtcl(ForumAtclVO vo) throws Exception {
        // 내용길이 저장
        vo.setCtsLen(StringUtil.getContentLenth(vo.getCts()));

        forumAtclDAO.updateAtcl(vo);

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
    }

    // 토론 게시글 삭제
    @Override
    public void deleteAtcl(ForumAtclVO vo) throws Exception {
        forumAtclDAO.deleteAtcl(vo);
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
    }

    // 나의 상호평가 결과
    @Override
    public ForumAtclVO selectMutResult(ForumAtclVO vo) throws Exception {
        return forumAtclDAO.selectMutResult(vo);
    }

    // 특정 수강생의 토론 게시글 조회
    @Override
    public List<ForumAtclVO> selectAtclUserList(ForumMutVO vo) throws Exception {
        return forumAtclDAO.selectAtclUserList(vo);
    }
    
    // 첨부파일 등록
    private FileVO addFile(ForumAtclVO vo) throws Exception {
        FileVO fileVO = new FileVO();
        if(!"".equals(StringUtil.nvl(vo.getUploadFiles()))) {
            fileVO.setUploadFiles(StringUtil.nvl(vo.getUploadFiles()));
            fileVO.setFilePath(vo.getUploadPath());
            fileVO.setRepoCd(vo.getRepoCd());
            fileVO.setRgtrId(vo.getRgtrId());
            fileVO.setFileBindDataSn(vo.getAtclSn());
            fileVO = sysFileService.addFile(fileVO);
        }
        return fileVO;
    }
    
    // 이전 토론 가져오기 첨부파일 복사
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
    public List<EgovMap> forumAtclExcalList(ForumAtclVO vo) throws Exception {
	    return forumAtclDAO.forumAtclExcalList(vo);
    }

}