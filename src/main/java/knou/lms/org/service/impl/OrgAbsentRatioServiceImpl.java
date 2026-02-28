package knou.lms.org.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.org.dao.OrgAbsentRatioDAO;
import knou.lms.org.service.OrgAbsentRatioService;
import knou.lms.org.vo.OrgAbsentRatioVO;

@Service("orgAbsentRatioService")
public class OrgAbsentRatioServiceImpl extends ServiceBase implements OrgAbsentRatioService {

    @Resource(name="orgAbsentRatioDAO")
    private OrgAbsentRatioDAO orgAbsentRatioDAO;

    /*****************************************************
     * <p>
     * TODO 결시원 성적비율 리스트 조회
     * </p>
     * 결시원 성적비율 리스트 조회
     *
     * @param OrgAbsentRatioVO
     * @return ProcessResultVO<OrgAbsentRatioVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<OrgAbsentRatioVO> list(OrgAbsentRatioVO vo) throws Exception {
        ProcessResultVO<OrgAbsentRatioVO> resultVO = new ProcessResultVO<OrgAbsentRatioVO>();
        List<OrgAbsentRatioVO> absentRatioList = orgAbsentRatioDAO.list(vo);
        resultVO.setReturnList(absentRatioList);
        return resultVO;
    }
    
    /*****************************************************
     * <p>
     * TODO 결시원 성적비율 정보 조회
     * </p>
     * 결시원 성적비율 정보 조회
     *
     * @param OrgAbsentRatioVO
     * @return OrgAbsentRatioVO
     * @throws Exception
     ******************************************************/
    @Override
    public OrgAbsentRatioVO select(OrgAbsentRatioVO vo) throws Exception {
        return orgAbsentRatioDAO.select(vo);
    }

    /*****************************************************
     * <p>
     * TODO 결시원 성적비율 등록
     * </p>
     * 결시원 성적비율 등록
     *
     * @param ProcessResultVO<OrgAbsentRatioVO>
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void insert(OrgAbsentRatioVO vo) throws Exception {
        for(int i = 0; i < vo.getAbsentGbnList().size(); i++) {
            OrgAbsentRatioVO ratioVO = new OrgAbsentRatioVO();
            ratioVO.setOrgId(vo.getOrgId());
            ratioVO.setAbsentGbn(vo.getAbsentGbnList().get(i));
            ratioVO.setExamGbn(vo.getExamGbnList().get(i));
            ratioVO.setScorRatio(vo.getScorRatioList().get(i));
            ratioVO.setAbsentDesc(vo.getAbsentDescList().get(i));
            ratioVO.setRgtrId(vo.getUserId());
            ratioVO.setMdfrId(vo.getUserId());
            orgAbsentRatioDAO.insert(ratioVO);
        }
    }

    /*****************************************************
     * <p>
     * TODO 결시원 성적비율 삭제
     * </p>
     * 결시원 성적비율 삭제
     *
     * @param OrgAbsentRatioVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void delete(OrgAbsentRatioVO vo) throws Exception {
        orgAbsentRatioDAO.delete(vo);
    }

}
