package knou.lms.forum.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.framework.common.ServiceBase;
import knou.framework.util.DateTimeUtil;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.framework.vo.FileVO;
import knou.lms.common.paging.PagingInfo;
import knou.lms.common.service.SysFileService;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.exam.service.ExamService;
import knou.lms.forum.dao.ForumCreCrsRltnDAO;
import knou.lms.forum.dao.ForumDAO;
import knou.lms.forum.service.ForumService;
import knou.lms.forum.vo.ForumCreCrsRltnVO;
import knou.lms.forum.vo.ForumVO;
import knou.lms.lesson.dao.LessonScheduleDAO;
import knou.lms.lesson.vo.LessonScheduleVO;
import knou.lms.mut.dao.MutEvalRltnDAO;
import knou.lms.mut.vo.MutEvalRltnVO;
import net.sf.json.JSONArray;

@Service("forumService")
public class ForumServiceImpl extends ServiceBase implements ForumService {

    @Resource(name = "forumDAO")
    private ForumDAO forumDAO;

    @Resource(name = "forumCreCrsRltnDAO")
    private ForumCreCrsRltnDAO forumCreCrsRltnDAO;
    
    @Resource(name = "mutEvalRltnDAO")
    private MutEvalRltnDAO mutEvalRltnDAO;
    
    @Autowired
    private SysFileService sysFileService;
    
    @Autowired
    private ExamService examService;
    
    @Resource(name="lessonScheduleDAO")
    private LessonScheduleDAO lessonScheduleDAO;

    // 토론 개수 조회
    @Override
    public int count(ForumVO vo) throws Exception {
        return forumDAO.count(vo);
    }

    // 토론 목록 조회
    @Override
    public ProcessResultVO<ForumVO> list(ForumVO vo) throws Exception {
        
        /** start of paging */
        PagingInfo paginationInfo = new PagingInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());
        
        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());
        
        List<ForumVO> forumList = forumDAO.list(vo);
        if(forumList.size() > 0) {
            paginationInfo.setTotalRecordCount(forumList.get(0).getTotalCnt());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }
        
        ProcessResultVO<ForumVO> returnVO = new ProcessResultVO<>();
        
        returnVO.setReturnList(forumList);
        returnVO.setPageInfo(paginationInfo);
        
        return returnVO;
    }

    // 토론정보 조회
    @Override
    public ForumVO selectForum(ForumVO vo) throws Exception {
        vo = forumDAO.selectForum(vo);
        if(vo != null) {
            FileVO fileVO = new FileVO();
            fileVO.setRepoCd("FORUM");
            fileVO.setFileBindDataSn(vo.getForumCd());
            List<FileVO> fileList = sysFileService.list(fileVO).getReturnList();
            vo.setFileList(fileList);
        }
        return vo;
    }

    // 토론정보 수정
    @Override
    public void updateForum(ForumVO vo) throws Exception {
        String crsCreCd = StringUtil.nvl(vo.getCrsCreCd());
        
        // 토론시작일시
        if(vo.getForumStartDttm() == null || vo.getForumStartDttm().equals("") || vo.getForumStartDttm().equals(":")) {
        }else {
            Date forumStartDttm = DateTimeUtil.stringToDate("yyyy-MM-dd HH:mm", vo.getForumStartDttm());
            vo.setForumStartDttm(DateTimeUtil.dateToString(forumStartDttm, "yyyyMMddHHmmss"));
        }
        // 토론종료일시
        if(vo.getForumEndDttm() == null || vo.getForumEndDttm().equals("") || vo.getForumEndDttm().equals(":")) {
        }else {
            Date forumEndDttm = DateTimeUtil.stringToDate("yyyy-MM-dd HH:mm:ss", vo.getForumEndDttm());
            vo.setForumEndDttm(DateTimeUtil.dateToString(forumEndDttm, "yyyyMMddHHmmss"));
        }
        // 성적공개일시
        if(vo.getScoreOpenDttm() == null || vo.getScoreOpenDttm().equals("") || vo.getScoreOpenDttm().equals(":")) {
        }else {
            Date scoreOpenDttm = DateTimeUtil.stringToDate("yyyy-MM-dd HH:mm", vo.getScoreOpenDttm());
            vo.setScoreOpenDttm(DateTimeUtil.dateToString(scoreOpenDttm, "yyyyMMddHHmmss"));
        }
        // 토론연장시작일시
        if(vo.getExtStartDttm() == null || vo.getExtStartDttm().equals("") || vo.getExtStartDttm().equals(":")) {
        }else {
        	Date extStartDttm = DateTimeUtil.stringToDate("yyyy-MM-dd HH:mm", vo.getExtStartDttm());
        	vo.setExtStartDttm(DateTimeUtil.dateToString(extStartDttm, "yyyyMMddHHmmss"));
        }
        // 토론연장종료일시
        if(vo.getExtEndDttm() == null || vo.getExtEndDttm().equals("") || vo.getExtEndDttm().equals(":")) {
        }else {
        	Date extEndDttm = DateTimeUtil.stringToDate("yyyy-MM-dd HH:mm:ss", vo.getExtEndDttm());
        	vo.setExtEndDttm(DateTimeUtil.dateToString(extEndDttm, "yyyyMMddHHmmss"));
        }
        
        if(!"Y".equals(StringUtil.nvl(vo.getPeriodAfterWriteYn()))) {
            vo.setExtEndDttm("");
        }
        
        // 상호평가
        if(!"Y".equals(StringUtil.nvl(vo.getMutEvalYn()))) {
            vo.setEvalStartDttm("");
            vo.setEvalEndDttm("");
        } else {
            Date evalStartDttm = DateTimeUtil.stringToDate("yyyy-MM-dd HH:mm", vo.getEvalStartDttm());
            vo.setEvalStartDttm(DateTimeUtil.dateToString(evalStartDttm, "yyyyMMddHHmmss"));
            
            Date evalEndDttm = DateTimeUtil.stringToDate("yyyy-MM-dd HH:mm:ss", vo.getEvalEndDttm());
            vo.setEvalEndDttm(DateTimeUtil.dateToString(evalEndDttm, "yyyyMMddHHmmss"));
        }
        
        //업데이트
        forumDAO.updateForum(vo);
        
        /*
        // 평가방식 - 루브릭
        if("R".equals(StringUtil.nvl(vo.getEvalCtgr()))) {
            // 루브릭 코드가 변경되었을 때 처리
            if(!vo.getOrgEvalCd().equals(vo.getEvalCd())) {
                MutEvalRltnVO mutEvalRltnVO = new MutEvalRltnVO();
                mutEvalRltnVO.setEvalDivCd("PROFESSOR_EVAL");
                mutEvalRltnVO.setRltnCd(StringUtil.nvl(vo.getForumCd()));
                mutEvalRltnVO.setCrsCreCd(StringUtil.nvl(vo.getCrsCreCd()));
                mutEvalRltnVO.setEvalCd(StringUtil.nvl(vo.getEvalCd()));
                mutEvalRltnDAO.insertMutEvalRltn(mutEvalRltnVO);
            }
        }
        */
        
        /*
        ForumCreCrsRltnVO creCrsForumRltnVO = new ForumCreCrsRltnVO();
        creCrsForumRltnVO.setForumCd(vo.getForumCd());
        creCrsForumRltnVO = forumCreCrsRltnDAO.selectGrpCd(creCrsForumRltnVO);
        
        creCrsForumRltnVO.setGrpCd(creCrsForumRltnVO.getGrpCd());
        */
        
        // 이전 시험 가져오기 파일 복사
        prevCopyFileAdd(vo);
        // 파일 등록
        FileVO fileVO = addFile(vo);
        
        if(vo.getDelFileIds().length > 0) {
            for(String delFileId : vo.getDelFileIds()) {
                FileVO delFileVO = new FileVO();
                delFileVO.setRepoCd("FORUM");
                delFileVO.setFileBindDataSn(vo.getForumCd());
                List<FileVO> fileList = sysFileService.list(delFileVO).getReturnList();
                for(FileVO fvo : fileList) {
                    if(delFileId.equals(fvo.getFileSaveNm().substring(0, fvo.getFileSaveNm().indexOf(".")))) {
                        sysFileService.removeFile(fvo.getFileSn());
                    }
                }
            }
        }
        
        if(ValidationUtils.isNotEmpty(vo.getTeamCtgrCd())) {
            ForumVO beforeTeamRltn = new ForumVO();
            beforeTeamRltn = forumDAO.selectTeamRltn(vo);
            if(ValidationUtils.isEmpty(beforeTeamRltn)) {
                //forumDAO.insertTeamRltn(vo);
                vo.setNewTeamCtgrCd(IdGenerator.getNewId("TEAMC"));
                forumDAO.insertTeamCopyPrcs(vo);
                forumDAO.updatePrcsStatusCd(vo);
            } else {
                if(ValidationUtils.isNotEmpty(beforeTeamRltn) && (!beforeTeamRltn.getTeamCtgrCd().equals(vo.getTeamCtgrCd()))) {
                    forumDAO.deleteTeamRltn(beforeTeamRltn);
                    vo.setNewTeamCtgrCd(IdGenerator.getNewId("TEAMC"));
                    forumDAO.insertTeamCopyPrcs(vo);
                    forumDAO.updatePrcsStatusCd(vo);
                }
            }
        }
       
        // 성적반영여부(SCORE_APLY_YN)가 Y인 경우에 성적반영 비율 100% 기준으로 1/N 자동 계산하여 성적반영비율 필더(SCORE_RATIO)에 저장
        ForumVO forumScoreRatioVO = new ForumVO();
        forumScoreRatioVO.setCrsCreCd(crsCreCd);
        this.setScoreRatio(forumScoreRatioVO);
    }

    // 토론정보 등록
    @Override
    public void insertForum(ForumVO vo, HttpServletRequest request) throws Exception {
        //토론시작일시
        if(vo.getForumStartDttm() == null || vo.getForumStartDttm().equals("") ) {
        }else {
            Date forumStartDttm = DateTimeUtil.stringToDate("yyyy-MM-dd HH:mm", vo.getForumStartDttm());
            vo.setForumStartDttm(DateTimeUtil.dateToString(forumStartDttm, "yyyyMMddHHmmss"));
        }
        //토론종료일시
        if(vo.getForumEndDttm() == null || vo.getForumEndDttm().equals("")) {
        }else {
            Date forumEndDttm = DateTimeUtil.stringToDate("yyyy-MM-dd HH:mm:ss", vo.getForumEndDttm());
            vo.setForumEndDttm(DateTimeUtil.dateToString(forumEndDttm, "yyyyMMddHHmmss"));
        }
        
        if(!"Y".equals(StringUtil.nvl(vo.getPeriodAfterWriteYn()))) {
            vo.setExtEndDttm(null);
        } else {
            Date extEndDttm = DateTimeUtil.stringToDate("yyyy-MM-dd HH:mm:ss", vo.getExtEndDttm());
            vo.setExtEndDttm(DateTimeUtil.dateToString(extEndDttm, "yyyyMMddHHmmss"));
        }
        
        if(!"Y".equals(StringUtil.nvl(vo.getMutEvalYn()))) {
            vo.setEvalStartDttm(null);
            vo.setEvalEndDttm(null);
        } else {
            Date evalStartDttm = DateTimeUtil.stringToDate("yyyy-MM-dd HH:mm", vo.getEvalStartDttm());
            vo.setEvalStartDttm(DateTimeUtil.dateToString(evalStartDttm, "yyyyMMddHHmmss"));
            
            Date evalEndDttm = DateTimeUtil.stringToDate("yyyy-MM-dd HH:mm:ss", vo.getEvalEndDttm());
            vo.setEvalEndDttm(DateTimeUtil.dateToString(evalEndDttm, "yyyyMMddHHmmss"));
        }
        
        ForumCreCrsRltnVO creCrsForumRltnVO = new ForumCreCrsRltnVO();
        creCrsForumRltnVO.setGrpCd(IdGenerator.getNewId("GRP"));
        
        // 이전 시험 가져오기 파일 복사
        prevCopyFileAdd(vo);
        // 파일 등록
        FileVO fileVO = addFile(vo);

        // 분반 등록
        String path = vo.getUploadPath();
        if("Y".equals(StringUtil.nvl(vo.getDeclsRegYn()))) {
            Map<String, String> declsLessonScheduleIdMap = new HashMap<>();
            
            // 주차 선택한경우
            if(!"DEFAULT".equals(StringUtil.nvl(vo.getLessonScheduleId()))) {
                LessonScheduleVO lessonScheduleVO = new LessonScheduleVO();
                lessonScheduleVO.setLessonScheduleId(vo.getLessonScheduleId());
                lessonScheduleVO.setSqlForeach(vo.getCrsCreCds().toArray(new String[vo.getCrsCreCds().size()]));
                List<LessonScheduleVO> declsLessonScheduleList = lessonScheduleDAO.listDeclsLessonSchedule(lessonScheduleVO);
                
                for(LessonScheduleVO lessonScheduleVO2: declsLessonScheduleList) {
                    declsLessonScheduleIdMap.put(lessonScheduleVO2.getCrsCreCd(), lessonScheduleVO2.getLessonScheduleId());
                }
            }
            
        	int index = 0;
            String[] teamCtgrCdArray = vo.getTeamCtgrCd().split(",");

            for(String declsCrsCreCd : vo.getCrsCreCds()) {
                if(!"".equals(declsCrsCreCd)) {
                    // 토론코드
                    vo.setForumCd(IdGenerator.getNewId("FORUM"));
                    // 토론코드로 UploadPath 새로 세팅
                    vo.setUploadPath(path + vo.getForumCd());
                    // 분반코드
                    vo.setCrsCreCd(declsCrsCreCd);
                    
                    if("Y".equals(StringUtil.nvl(vo.getTeamForumCfgYn()))) {
                        vo.setForumCtgrCd("TEAM");
                        vo.setTeamForumCfgYn("Y");
                        vo.setTeamCtgrCd(teamCtgrCdArray[index]);
                    } else {
                        vo.setForumCtgrCd("NORMAL");
                        vo.setTeamForumCfgYn("N");
                        vo.setTeamCtgrCd(null);
                    }
                    
                    if(declsLessonScheduleIdMap.containsKey(declsCrsCreCd)) {
                        vo.setLessonScheduleId(declsLessonScheduleIdMap.get(declsCrsCreCd));
                    } else {
                        vo.setLessonScheduleId(null);
                    }
                    
                    // 토론테이블 insert
                    forumDAO.insertForum(vo);
                    
                    /*
                     * 루브릭 평가가 없어짐으로 인한  주석 처리
                    // 평가방식 - 루브릭
                    if("R".equals(StringUtil.nvl(vo.getEvalCtgr()))) {
                        MutEvalRltnVO mutEvalRltnVO = new MutEvalRltnVO();
                        mutEvalRltnVO.setEvalDivCd("PROFESSOR_EVAL");
                        mutEvalRltnVO.setRltnCd(StringUtil.nvl(vo.getForumCd()));
                        mutEvalRltnVO.setCrsCreCd(StringUtil.nvl(vo.getCrsCreCd()));
                        mutEvalRltnVO.setEvalCd(StringUtil.nvl(vo.getEvalCd()));
                        mutEvalRltnDAO.insertMutEvalRltn(mutEvalRltnVO);
                    }
                    */
                    // 이전 시험 가져오기 파일 복사
                    prevCopyFileAdd(vo);
                    // 첨부파일 복사
                    copyFile(vo, fileVO);
                    
                    //개설강좌코드,분반번호
                    creCrsForumRltnVO.setCrsCreCd(declsCrsCreCd);
                    //토론코드
                    creCrsForumRltnVO.setForumCd(vo.getForumCd());
                    //개설과정 토론 연결 테이블 insert
                    forumCreCrsRltnDAO.insertCreCrsForumRltn(creCrsForumRltnVO);
                    
                    if(!"".equals(StringUtil.nvl(request.getParameter("evalCd")))) {
                        MutEvalRltnVO mutEvalRltnVO = new MutEvalRltnVO();
                        mutEvalRltnVO.setEvalDivCd("PROFESSOR_EVAL");
                        mutEvalRltnVO.setCrsCreCd(declsCrsCreCd);
                        mutEvalRltnVO.setRltnCd(vo.getForumCd());
                        MutEvalRltnVO selectEvalRltnVO = mutEvalRltnDAO.selectMutEvalRltn(mutEvalRltnVO);
                        if(selectEvalRltnVO != null) {
                            mutEvalRltnDAO.delMutEvalRltn(selectEvalRltnVO);
                        }
                        mutEvalRltnVO.setEvalCd(request.getParameter("evalCd"));
                        mutEvalRltnDAO.insertMutEvalRltn(mutEvalRltnVO);
                    }
                    
                    // 성적반영여부(SCORE_APLY_YN)가 Y인 경우에 성적반영 비율 100% 기준으로 1/N 자동 계산하여 성적반영비율 필더(SCORE_RATIO)에 저장
                    ForumVO forumScoreRatioVO = new ForumVO();
                    forumScoreRatioVO.setCrsCreCd(declsCrsCreCd);
                    this.setScoreRatio(forumScoreRatioVO);
                }
                index++;
            }
            // 올린 파일 삭제
        }
    }
    
    // 토론정보 복사
    @Override
    public void copyForum(ForumVO vo) throws Exception {
        String orgId = vo.getOrgId();
        String crsCreCd = vo.getCrsCreCd();
        String copyForumCd = vo.getCopyForumCd();
        String rgtrId = vo.getRgtrId();
        String lineNo = vo.getLineNo();
        
        if(ValidationUtils.isEmpty(orgId) 
            || ValidationUtils.isEmpty(crsCreCd) 
            || ValidationUtils.isEmpty(copyForumCd) 
            || ValidationUtils.isEmpty(rgtrId)
            || ValidationUtils.isEmpty(lineNo)) {
            throw processException("system.fail.badrequest.nomethod"); // 잘못된 요청으로 오류가 발생하였습니다.
        }
        
        // 토론 복사
        String forumCd = IdGenerator.getNewId("FORUM");
        
        ForumVO copyForumVO = new ForumVO();
        copyForumVO.setCopyForumCd(copyForumCd);
        copyForumVO.setForumCd(forumCd);
        copyForumVO.setCrsCreCd(crsCreCd);
        copyForumVO.setRgtrId(rgtrId);
        copyForumVO.setLineNo(lineNo);
        
        forumDAO.copyForum(copyForumVO);
        
        // 개설과정 토론 연결 테이블 insert
        ForumCreCrsRltnVO creCrsForumRltnVO = new ForumCreCrsRltnVO();
        creCrsForumRltnVO.setGrpCd(IdGenerator.getNewId("GRP"));
        creCrsForumRltnVO.setCrsCreCd(crsCreCd);
        creCrsForumRltnVO.setForumCd(forumCd);
        forumCreCrsRltnDAO.insertCreCrsForumRltn(creCrsForumRltnVO);
        
        // 복사대상 토론 조회
        ForumVO newForumVO = new ForumVO();
        newForumVO.setForumCd(forumCd);
        newForumVO = forumDAO.select(newForumVO);
        
        FileVO copyFileVO;
        copyFileVO = new FileVO();
        copyFileVO.setOrgId(orgId);
        copyFileVO.setRepoCd("FORUM");
        copyFileVO.setFileBindDataSn(forumCd);
        copyFileVO.setCopyFileBindDataSn(copyForumCd);
        copyFileVO.setRgtrId(rgtrId);
        
        sysFileService.copyFileInfoFromOrigin(copyFileVO);
    }

    // 내 강의에 등록된 토론 목록 조회
    @Override
    public ProcessResultVO<ForumVO> listMyCreCrsForum(ForumVO vo) throws Exception {
        
        /** start of paging */
        PagingInfo paginationInfo = new PagingInfo();
        paginationInfo.setCurrentPageNo(vo.getPageIndex());
        paginationInfo.setRecordCountPerPage(vo.getListScale());
        paginationInfo.setPageSize(vo.getListScale());
        
        vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
        vo.setLastIndex(paginationInfo.getLastRecordIndex());
        
        List<ForumVO> forumList = forumDAO.listMyCreCrsForum(vo);
        
        if(forumList.size() > 0) {
            paginationInfo.setTotalRecordCount(forumList.get(0).getTotalCnt());
        } else {
            paginationInfo.setTotalRecordCount(0);
        }
        
        ProcessResultVO<ForumVO> resultVO = new ProcessResultVO<>();
        
        resultVO.setReturnList(forumList);
        resultVO.setPageInfo(paginationInfo);
        
        return resultVO;
    }

    // 토론 정보 조회
    @Override
    public ForumVO select(ForumVO vo) throws Exception {
        vo = forumDAO.select(vo);
        if(vo != null) {
            FileVO fileVO = new FileVO();
            fileVO.setRepoCd("FORUM");
            fileVO.setFileBindDataSn(vo.getForumCd());
            List<FileVO> fileList = sysFileService.list(fileVO).getReturnList();
            vo.setFileList(fileList);
        }
        return vo;
    }

    // 토론 삭제
    @Override
    public void deleteForum(ForumVO vo) throws Exception { 
     // 대체 과제 여부 조회 및 삭제
        examService.examInsDelete(vo.getForumCd());
        forumDAO.deleteForum(vo);
        // sysFileService.removeFile(vo, new ForumFileHandler());
    }

    // 개설과정토론 연결 삭제
    @Override
    public void deleteForumCreCrsRltn(ForumVO vo) throws Exception {
        forumDAO.deleteForumCreCrsRltn(vo);
    }

    // 시험 토론 등록, 수정
    @Override
    public ProcessResultVO<ForumVO> examForumManage(ForumVO vo, HttpServletRequest request) throws Exception {
        ProcessResultVO<ForumVO> resultVO = new ProcessResultVO<ForumVO>();
        
        // 상호평가
        if(!"Y".equals(StringUtil.nvl(vo.getMutEvalYn()))) {
            vo.setEvalStartDttm("");
            vo.setEvalEndDttm("");
        } else {
            Date evalStartDttm = DateTimeUtil.stringToDate("yyyy-MM-dd HH:mm", vo.getEvalStartDttm());
            vo.setEvalStartDttm(DateTimeUtil.dateToString(evalStartDttm, "yyyyMMddHHmmss"));
            
            Date evalEndDttm = DateTimeUtil.stringToDate("yyyy-MM-dd HH:mm:ss", vo.getEvalEndDttm());
            vo.setEvalEndDttm(DateTimeUtil.dateToString(evalEndDttm, "yyyyMMddHHmmss"));
        }
        
        // 등록
        if("insert".equals(StringUtil.nvl(vo.getSearchMenu()))) {
            vo.setForumCd(IdGenerator.getNewId("FORUM"));
            forumDAO.insertForum(vo);
            
            prevCopyFileAdd(vo);
            addFile(vo);
            
            ForumCreCrsRltnVO creCrsForumRltnVO = new ForumCreCrsRltnVO();
            creCrsForumRltnVO.setGrpCd(IdGenerator.getNewId("GRP"));
            creCrsForumRltnVO.setCrsCreCd(vo.getCrsCreCd());
            creCrsForumRltnVO.setForumCd(vo.getForumCd());
            forumCreCrsRltnDAO.insertCreCrsForumRltn(creCrsForumRltnVO);
        // 수정
        } else if("update".equals(StringUtil.nvl(vo.getSearchMenu()))) {
            forumDAO.updateForum(vo);
            if(vo.getDelFileIds().length > 0) {
                for(String delFileId : vo.getDelFileIds()) {
                    FileVO fileVO = new FileVO();
                    fileVO.setRepoCd("FORUM");
                    fileVO.setFileBindDataSn(vo.getForumCd());
                    List<FileVO> fileList = sysFileService.list(fileVO).getReturnList();
                    for(FileVO fvo : fileList) {
                        if(delFileId.equals(fvo.getFileSaveNm().substring(0, fvo.getFileSaveNm().indexOf(".")))) {
                            sysFileService.removeFile(fvo.getFileSn());
                        }
                    }
                }
            }
            prevCopyFileAdd(vo);
            addFile(vo);
        // 삭제
        } else if("delete".equals(StringUtil.nvl(vo.getSearchMenu()))) {
            // 대체 과제 여부 조회 및 삭제
            examService.examInsDelete(vo.getForumCd());
            forumDAO.deleteForumCreCrsRltn(vo);
            forumDAO.deleteForum(vo);
            
            FileVO fileVO = new FileVO();
            fileVO.setRepoCd("FORUM");
            fileVO.setFileBindDataSn(vo.getForumCd());
            List<FileVO> fileList = sysFileService.list(fileVO).getReturnList();
            for(FileVO fvo : fileList) {
                sysFileService.removeFile(fvo.getFileSn());
            }
        }
        
        if("insert".equals(StringUtil.nvl(vo.getSearchMenu())) || "update".equals(StringUtil.nvl(vo.getSearchMenu()))) {
            if(!"".equals(StringUtil.nvl(request.getParameter("evalCd")))) {
                MutEvalRltnVO mutEvalRltnVO = new MutEvalRltnVO();
                mutEvalRltnVO.setEvalDivCd("PROFESSOR_EVAL");
                mutEvalRltnVO.setCrsCreCd(vo.getCrsCreCd());
                mutEvalRltnVO.setRltnCd(vo.getForumCd());
                MutEvalRltnVO selectEvalRltnVO = mutEvalRltnDAO.selectMutEvalRltn(mutEvalRltnVO);
                if(selectEvalRltnVO != null) {
                    mutEvalRltnDAO.delMutEvalRltn(selectEvalRltnVO);
                }
                mutEvalRltnVO.setEvalCd(request.getParameter("evalCd"));
                mutEvalRltnDAO.insertMutEvalRltn(mutEvalRltnVO);
            }
        }
        
        resultVO.setReturnVO(vo);

        return resultVO;
    }
    
    // 첨부파일 등록
    private FileVO addFile(ForumVO vo) throws Exception {
        FileVO fileVO = new FileVO();
        if(!"".equals(StringUtil.nvl(vo.getUploadFiles()))) {
            fileVO.setUploadFiles(StringUtil.nvl(vo.getUploadFiles()));
            fileVO.setFilePath(vo.getUploadPath());
            fileVO.setRepoCd(vo.getRepoCd());
            fileVO.setRgtrId(vo.getRgtrId());
            fileVO.setFileBindDataSn(vo.getForumCd());
            fileVO = sysFileService.addFile(fileVO);
        }
        return fileVO;
    }

    // 첨부파일 복사
    private void copyFile(ForumVO vo, FileVO fileVO) throws Exception {
        if(!"".equals(StringUtil.nvl(vo.getUploadFiles()))) {
            FileVO fvo = new FileVO();
            fvo.setUploadFiles(StringUtil.nvl(vo.getUploadFiles()));
            fvo.setCopyFiles(StringUtil.nvl(vo.getCopyFiles()));
            fvo.setFilePath(vo.getUploadPath());
            fvo.setRepoCd(vo.getRepoCd());
            fvo.setRgtrId(vo.getRgtrId());
            fvo.setFileBindDataSn(vo.getForumCd());
            fvo.setFileList(fileVO.getFileList());
            sysFileService.copyFile(fvo);
        }
    }
    
    // 이전 토론 가져오기 첨부파일 복사
    private void prevCopyFileAdd(ForumVO vo) throws Exception {
        if(!"".equals(StringUtil.nvl(vo.getSearchTo())) && !"".equals(StringUtil.nvl(vo.getFileSns()))) {
            // 기존 파일 삭제
        	/*
            FileVO delFileVO = new FileVO();
            delFileVO.setRepoCd(vo.getRepoCd());
            delFileVO.setFileBindDataSn(vo.getForumCd());
            List<FileVO> delFileList = sysFileService.list(delFileVO).getReturnList();
            for(FileVO dfvo : delFileList) {
                //sysFileService.removeFile(dfvo);
            }
            */
        	
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

    // 토론 참여자 테이블에 수강생 등록
    @Override
    public void insertForumJoinUser(ForumVO vo) throws Exception {
        forumDAO.insertForumJoinUser(vo);
    }

    // 성적분포현황 BarChart
    @Override
    public EgovMap viewScoreChart(ForumVO vo) throws Exception {
        EgovMap scoreMap = forumDAO.selectScoreChart(vo);
        return scoreMap;
    }

    // 토론정보 조회
    @Override
    public ProcessResultVO<ForumVO> viewForum(ForumVO vo) throws Exception {
        ProcessResultVO<ForumVO> resultList = new ProcessResultVO<ForumVO>(); 
        try {
            resultList.setReturnVO(forumDAO.viewForum(vo));
            resultList.setResult(1);
//            resultList.setReturnList(resultList);
        } catch (Exception e) {
            resultList.setResult(-1);
            resultList.setMessage(e.getMessage());
        }
        return resultList;
    }

    // 성적반영비율 초기화
	@Override
	public void setScoreRatio(ForumVO vo) throws Exception {
        List<ForumVO> scoreAplyList = forumDAO.getScoreRatio(vo);
            
        if( scoreAplyList != null && !scoreAplyList.isEmpty() && scoreAplyList.size() > 0) {
            int scoreAplyCnt = scoreAplyList.size();
            int share = 100 / scoreAplyCnt;
            int rest = 100 % scoreAplyCnt;
            int cnt = 0;
            Integer scoreRatio = 0;
            for(ForumVO forumVO : scoreAplyList) {
                if(cnt == 0) {
                    scoreRatio = share + rest;
                } else {
                    scoreRatio = share;
                }
                vo.setScoreRatio(scoreRatio);
                vo.setForumCd(forumVO.getForumCd());
                forumDAO.setScoreRatio(vo);
                cnt++;
            }
        }
	}

	@Override
	public String selectStdNo(ForumVO vo) throws Exception {
		return forumDAO.selectStdNo(vo);
	}

}
