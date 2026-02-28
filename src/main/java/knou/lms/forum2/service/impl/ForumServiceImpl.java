package knou.lms.forum2.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.PageInfo;
import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.forum2.dao.Forum2DAO;
import knou.lms.forum2.service.ForumService;
import knou.lms.forum2.vo.Forum2ListVO;
import knou.lms.forum2.vo.Forum2VO;

@Service("forum2Service")
public class ForumServiceImpl extends ServiceBase implements ForumService {

    @Resource(name = "forum2DAO")
    private Forum2DAO forumDAO;

    /**
     * 토론목록조회
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<Forum2ListVO> selectForumList(Forum2ListVO vo) throws Exception {
        ProcessResultVO<Forum2ListVO> resultVO = new ProcessResultVO<>();

        PageInfo pageInfo = new PageInfo(vo);
        List<Forum2ListVO> list = forumDAO.selectForumList(vo);
        pageInfo.setTotalRecord(list);

        resultVO.setReturnList(list);
        resultVO.setPageInfo(pageInfo);
        resultVO.setResultSuccess();

        return resultVO;
    }

    /**
     * 토론단건상세조회
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<Forum2VO> selectForum(Forum2VO vo) throws Exception {
        ProcessResultVO<Forum2VO> resultVO = new ProcessResultVO<>();

        Forum2VO detailVO = forumDAO.selectForum(vo);
        resultVO.setReturnVO(detailVO);
        resultVO.setResultSuccess();

        return resultVO;
    }

    /**
     * 토론저장
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<Forum2VO> saveForum(Forum2VO vo) throws Exception {
        ProcessResultVO<Forum2VO> resultVO = new ProcessResultVO<>();

        if (StringUtil.isNull(vo.getOknokCfgyn())) {
            vo.setOknokCfgyn("N");
        }

        if (StringUtil.isNull(vo.getDscsId())) {
            vo.setDscsId(IdGenerator.getNewId("DSCS"));
            forumDAO.insertForum(vo);
        } else {
            forumDAO.updateForum(vo);
        }

        Forum2VO detailParam = new Forum2VO();
        detailParam.setDscsId(vo.getDscsId());
        Forum2VO detailVO = forumDAO.selectForum(detailParam);

        resultVO.setReturnVO(detailVO);
        resultVO.setResultSuccess();

        return resultVO;
    }

    /**
     * 토론삭제
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<Forum2VO> deleteForum(Forum2VO vo) throws Exception {
        ProcessResultVO<Forum2VO> resultVO = new ProcessResultVO<>();

        int affected = forumDAO.deleteForum(vo);
        if (affected > 0) {
            resultVO.setReturnVO(vo);
            resultVO.setResultSuccess();
        } else {
            resultVO.setResultFailed("delete target not found");
        }

        return resultVO;
    }

    /**
     * 토론복사
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ProcessResultVO<Forum2VO> copyForum(Forum2VO vo) throws Exception {
        ProcessResultVO<Forum2VO> resultVO = new ProcessResultVO<>();

        String newDscsId = IdGenerator.getNewId("DSCS");
        vo.setDscsId(newDscsId);

        /*TODO_copyForum파라미터매핑프로젝트표준확정필요*/
        forumDAO.copyForum(vo);

        Forum2VO detailParam = new Forum2VO();
        detailParam.setDscsId(newDscsId);
        Forum2VO detailVO = forumDAO.selectForum(detailParam);

        resultVO.setReturnVO(detailVO);
        resultVO.setResultSuccess();

        return resultVO;
    }
}
