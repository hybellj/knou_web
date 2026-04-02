package knou.lms.forum2.service.impl;

import knou.framework.common.CommConst;
import knou.framework.common.IdPrefixType;
import knou.framework.common.ServiceBase;
import knou.framework.util.FileUtil;
import knou.framework.util.IdGenUtil;
import knou.framework.util.IdGenerator;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflVO;
import knou.lms.forum2.dao.ForumFdbkDAO;
import knou.lms.forum2.dao.ForumJoinUserDAO;
import knou.lms.forum2.service.ForumFdbkService;
import knou.lms.forum.vo.ForumFdbkVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service("forum2FdbkService")
public class ForumFdbkServiceImpl extends ServiceBase implements ForumFdbkService {

    @Resource(name="forum2FdbkDAO")
    private ForumFdbkDAO forumFdbkDAO;

    @Resource(name="forum2JoinUserDAO")
    private ForumJoinUserDAO forumJoinUserDAO;

    @Resource(name="attachFileService")
    private AttachFileService attachFileService;

    /*****************************************************
     * <p>
     * TODO 토론 피드백 목록 조회
     * </p>
     * 토론 피드백 목록 조회
     *
     * @param ForumFdbkVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    @Override
    public List<EgovMap> forumFdbkList(ForumFdbkVO vo) throws Exception {
        return forumFdbkDAO.forumFdbkList(vo);
    }

    /*****************************************************
     * <p>
     * TODO 토론 피드백 등록
     * </p>
     * 토론 피드백 등록 (파일 없는 메모 경로)
     *
     * @param ForumFdbkVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void insertForumFdbk(ForumFdbkVO vo) throws Exception {
        forumFdbkDAO.insertForumFdbk(vo);
    }

    /*****************************************************
     * <p>
     * TODO 토론 피드백 수정
     * </p>
     * 토론 피드백 수정
     *
     * @param ForumFdbkVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void updateForumFdbk(ForumFdbkVO vo) throws Exception {
        forumFdbkDAO.updateForumFdbk(vo);
    }

    /*****************************************************
     * <p>
     * TODO 토론 피드백 삭제
     * </p>
     * 토론 피드백 삭제
     *
     * @param ForumFdbkVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void deleteForumFdbk(ForumFdbkVO vo) throws Exception {
        forumFdbkDAO.deleteForumFdbk(vo);
    }

    // 일괄 피드백 등록
    @Override
    public void insertForumAllFdbk(ForumFdbkVO vo) throws Exception {
        forumFdbkDAO.insertForumAllFdbk(vo);
    }

    // 피드백 저장
    @Override
    public ProcessResultVO<ForumFdbkVO> insertFdbk(ForumFdbkVO vo) throws Exception {
        ProcessResultVO<ForumFdbkVO> resultVO = new ProcessResultVO<ForumFdbkVO>();

        try {
            String[] stdArr = vo.getStdId().split(",");

            if(stdArr.length > 0) {
                for(int i = 0; i < stdArr.length; i++) {
                    vo.setStdId(stdArr[i]);
                    vo.setForumFdbkCd(IdGenerator.getNewId(IdPrefixType.DSFDK.getCode()));

                    /*
                    // 토론 참여자(tb_lms_forum_join_user) 테이블에 등록
                    ForumJoinUserVO forumJoinUserVO = new ForumJoinUserVO();
                    forumJoinUserVO.setScore(null);
                    forumJoinUserVO.setForumCd(vo.getForumCd());
                    forumJoinUserVO.setTeamCd(vo.getTeamCd());
                    forumJoinUserVO.setStdId(stdArr[i]);
                    forumJoinUserVO.setRgtrId(vo.getUserId());
                    forumJoinUserVO.setMdfrId(vo.getUserId());
                    forumJoinUserDAO.insertStdScore(forumJoinUserVO);
                    */

                    // 토론 피드백(tb_lms_forum_fdbk) 테이블에 등록
                    forumFdbkDAO.insertFdbk(vo);

                    // 파일 저장
                    List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(vo.getUploadFiles(), vo.getUploadPath());
                    for (AtflVO atflVO : uploadFileList) {
                        atflVO.setAtflId(IdGenUtil.genNewId(IdPrefixType.ATFL));
                        atflVO.setRefId(vo.getForumFdbkCd());
                        atflVO.setRgtrId(vo.getUserId());
                        atflVO.setMdfrId(vo.getUserId());
                        atflVO.setAtflRepoId(CommConst.REPO_DSCS);
                    }
                    if (!uploadFileList.isEmpty()) {
                        attachFileService.insertAtflList(uploadFileList);
                    }
                }
            }
            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
            throw e;
        }
        return resultVO;
    }

    // 피드백 조회
    @Override
    public List<ForumFdbkVO> selectFdbk(ForumFdbkVO vo) throws Exception {
        List<ForumFdbkVO> forumFdbkList = forumFdbkDAO.selectFdbk(vo);

        if(forumFdbkList != null) {
            for(ForumFdbkVO vo1 : forumFdbkList) {
                AtflVO atflParam = new AtflVO();
                atflParam.setAtflRepoId(CommConst.REPO_DSCS);
                atflParam.setRefId(vo1.getForumFdbkCd());
                List<AtflVO> fileList = attachFileService.selectAtflListByRefId(atflParam);
                vo1.setFileList(fileList);
            }
        }

        return forumFdbkList;
    }

    // 피드백 수정
    @Override
    public ProcessResultVO<ForumFdbkVO> updateFdbk(ForumFdbkVO vo) throws Exception {
        ProcessResultVO<ForumFdbkVO> resultVO = new ProcessResultVO<ForumFdbkVO>();

        try {
            forumFdbkDAO.updateFdbk(vo);

            // 파일 저장
            List<AtflVO> uploadFileList = FileUtil.getUploadAtflList(vo.getUploadFiles(), vo.getUploadPath());
            for (AtflVO atflVO : uploadFileList) {
                atflVO.setAtflId(IdGenUtil.genNewId(IdPrefixType.ATFL));
                atflVO.setRefId(vo.getForumFdbkCd());
                atflVO.setRgtrId(vo.getUserId());
                atflVO.setMdfrId(vo.getUserId());
                atflVO.setAtflRepoId(CommConst.REPO_DSCS);
            }
            if (!uploadFileList.isEmpty()) {
                attachFileService.insertAtflList(uploadFileList);
            }

            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
            throw e;
        }
        return resultVO;
    }

    // 피드백 삭제
    @Override
    public ProcessResultVO<ForumFdbkVO> deleteFdbk(ForumFdbkVO vo) throws Exception {
        ProcessResultVO<ForumFdbkVO> resultVO = new ProcessResultVO<ForumFdbkVO>();

        try {
            forumFdbkDAO.deleteFdbk(vo);

            resultVO.setResult(1);
        } catch (Exception e) {
            resultVO.setResult(-1);
            throw e;
        }

        return resultVO;
    }

    // 피드백 갯수
    @Override
    public int cntFdbk(ForumFdbkVO vo) throws Exception {
        return forumFdbkDAO.cntFdbk(vo);
    }

}
