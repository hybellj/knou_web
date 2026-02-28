package knou.lms.crs.crsCtgr.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crsCtgr.dao.CrsCtgrDAO;
import knou.lms.crs.crsCtgr.service.CrsCtgrService;
import knou.lms.crs.crsCtgr.vo.CreTmCtgrVO;
import knou.lms.crs.crsCtgr.vo.CrsCtgrVO;

@Service("crsCtgrService")
public class CrsCtgrServiceImpl
	extends EgovAbstractServiceImpl implements CrsCtgrService {
	
	/** dao */
    @Resource(name="crsCtgrDAO")
    private CrsCtgrDAO	crsCtgrDAO;
    
    /**
     * 과목 분류 list 조회 .
     * @param CrsCtgrVO
     * @return ProcessResultVO
     * @throws Exception
     */
    @Override
    public List<CrsCtgrVO> listCrsCtgrTree(CrsCtgrVO vo) throws Exception {
        ProcessResultVO<CrsCtgrVO> resultList = new ProcessResultVO<CrsCtgrVO>();
        List<CrsCtgrVO> ctgrList = crsCtgrDAO.listCrsCtgr(vo);
        
        //최상단용 VO 만들기
        CrsCtgrVO crsctgrVO = new CrsCtgrVO();
        
        //트리형태로 목록을 구성
        for (CrsCtgrVO parent : ctgrList) {
            if(StringUtil.isNull(parent.getParCrsCtgrCd())) {
                crsctgrVO.addSubCtgr(parent);
            }
            for (CrsCtgrVO child : ctgrList) {
                if(parent.getCrsCtgrCd().equals(child.getParCrsCtgrCd())) {
                    parent.addSubCtgr(child);
                }
            }
        }
        /*resultList.setReturnList(crsctgrVO.getSubList());*/
        return crsctgrVO.getSubList();
    }

	/**
	 * 교과별 분류 순서를 매칭
	 * @param CrsCtgrVO
	 * @return List<CrsCtgrVO>
	 * @throws Exception
	 */
	@Override
	public List<CrsCtgrVO> ctgrTree(CrsCtgrVO vo) throws Exception {
		List<CrsCtgrVO> defaultList = crsCtgrDAO.ctgrTree(vo);
		return defaultList;
	}

	/**
     * 과목 분류 list 조회 .
     * @param CrsCtgrVO
     * @return ProcessResultVO
     * @throws Exception
     */
    @Override
    public List<CrsCtgrVO> listCrsCtgr(CrsCtgrVO vo) throws Exception {
        ProcessResultVO<CrsCtgrVO> resultList = new ProcessResultVO<CrsCtgrVO>();
        List<CrsCtgrVO> ctgrList = crsCtgrDAO.listCrsCtgr(vo);
        
        //this.parCrsCtgrCd(vo);
        return ctgrList;
    }
    
    /**
     * 과목 분류 부모값 조회
     * @param CrsCtgrVO
     * @return ProcessResultVO
     * @throws Exception
     */
    public CrsCtgrVO parCrsCtgrCd(CrsCtgrVO vo) throws Exception {
        CrsCtgrVO crsCtgrVo = new CrsCtgrVO();
        CrsCtgrVO crsCtgrVo2 = new CrsCtgrVO();
        CrsCtgrVO crsCtgrVo3 = new CrsCtgrVO();
        
        crsCtgrVo = crsCtgrDAO.selectParCrsCtgrCd(vo);
        if(crsCtgrVo.getParCrsCtgrCd() != null) {
            //분류 레벨 3
            if(crsCtgrVo.getCrsCtgrLvl().equals(3)) {
                vo.setParCrsCtgrCdLvl3(crsCtgrVo.getCrsCtgrCd());
                vo.setParCrsCtgrNmLvl3(crsCtgrVo.getCrsCtgrNm());
                vo.setParCrsCtgrCdLvl2(crsCtgrVo.getParCrsCtgrCd());
                vo.setParCrsCtgrNmLvl2(crsCtgrVo.getParCrsCtgrNm());
                
                crsCtgrVo2.setCrsCtgrCd(crsCtgrVo.getParCrsCtgrCd());
                crsCtgrVo2 = crsCtgrDAO.selectParCrsCtgrCd(crsCtgrVo2);
                if(crsCtgrVo2.getCrsCtgrLvl().equals(2)) {
                    vo.setParCrsCtgrCdLvl1(crsCtgrVo2.getParCrsCtgrCd());
                    vo.setParCrsCtgrNmLvl1(crsCtgrVo2.getParCrsCtgrNm());
                    vo.setParCrsCtgrNmLvl2(crsCtgrVo.getCrsCtgrNm());
                }
            }
            //분류 레벨 2
            if(crsCtgrVo.getCrsCtgrLvl().equals(2)) {
                vo.setParCrsCtgrCdLvl2(crsCtgrVo.getCrsCtgrCd());
                vo.setParCrsCtgrNmLvl2(crsCtgrVo.getCrsCtgrNm());
                vo.setParCrsCtgrCdLvl1(crsCtgrVo.getParCrsCtgrCd());
                vo.setParCrsCtgrNmLvl1(crsCtgrVo.getParCrsCtgrNm());
                
            }
            if(crsCtgrVo.getCrsCtgrLvl().equals(1)) {
                vo.setCrsCtgrCd(crsCtgrVo.getCrsCtgrCd());
                vo.setParCrsCtgrCdLvl1(crsCtgrVo.getCrsCtgrCd());
                vo.setParCrsCtgrNmLvl1(crsCtgrVo.getCrsCtgrNm());
            }
        }
        
        //최상의 값 일 때
        if(crsCtgrVo.getCrsCtgrLvl().equals(1)) {
            vo.setCrsCtgrCd(crsCtgrVo.getCrsCtgrCd());
            vo.setParCrsCtgrCdLvl1(crsCtgrVo.getCrsCtgrCd());
            vo.setParCrsCtgrNmLvl1(crsCtgrVo.getCrsCtgrNm());
        }
        
        return vo;
    }
    
    /**
     * 과목 분류 부모값 조회
     * @param CrsCtgrVO
     * @return ProcessResultVO
     * @throws Exception
     */
    public CreTmCtgrVO parCreTmCtgrCd(CreTmCtgrVO vo) throws Exception {
        CreTmCtgrVO crsCtgrVo = new CreTmCtgrVO();
        CreTmCtgrVO crsCtgrVo2 = new CreTmCtgrVO();
        
        crsCtgrVo = crsCtgrDAO.selectParCreTmCtgrCd(vo);
        /*if(crsCtgrVo.getParCreTmCtgrCd() != null) {
            //레벨 1의 자기 자신 세팅
            vo.setParCreTmCtgrCdLvl1(crsCtgrVo.getCreTmCtgrCd());
        }*/
        if(crsCtgrVo.getParCreTmCtgrCd() != null) {
            //분류 레벨 3이 있을 경우
            if(crsCtgrVo.getCreTmCtgrLvl().equals(3)) {
                vo.setParCreTmCtgrCdLvl3(crsCtgrVo.getCreTmCtgrCd());
                vo.setParCreTmCtgrNmLvl3(crsCtgrVo.getCreTmCtgrNm());
                vo.setParCreTmCtgrCdLvl2(crsCtgrVo.getParCreTmCtgrCd());
                vo.setParCreTmCtgrNmLvl2(crsCtgrVo.getParCreTmCtgrNm());
                
                crsCtgrVo2.setCreTmCtgrCd(crsCtgrVo.getParCreTmCtgrCd());
                crsCtgrVo2 = crsCtgrDAO.selectParCreTmCtgrCd(crsCtgrVo2);
                if(crsCtgrVo2.getCreTmCtgrLvl().equals(2)) {
                    vo.setParCreTmCtgrCdLvl1(crsCtgrVo2.getParCreTmCtgrCd());
                    vo.setParCreTmCtgrNmLvl1(crsCtgrVo2.getParCreTmCtgrNm());
                    vo.setParCreTmCtgrNmLvl2(crsCtgrVo.getCreTmCtgrNm());
                }
            }
            
            //분류 레벨 2
            if(crsCtgrVo.getCreTmCtgrLvl().equals(2)) {
                vo.setParCreTmCtgrCdLvl2(crsCtgrVo.getCreTmCtgrCd());
                vo.setParCreTmCtgrNmLvl2(crsCtgrVo.getCreTmCtgrNm());
                vo.setParCreTmCtgrCdLvl1(crsCtgrVo.getParCreTmCtgrCd());
                vo.setParCreTmCtgrNmLvl1(crsCtgrVo.getParCreTmCtgrNm());
                
            }
            
            if(crsCtgrVo.getCreTmCtgrLvl().equals(1)) {
                vo.setCreTmCtgrCd(crsCtgrVo.getCreTmCtgrCd());
                vo.setParCreTmCtgrCdLvl1(crsCtgrVo.getCreTmCtgrCd());
                vo.setParCreTmCtgrNmLvl1(crsCtgrVo.getCreTmCtgrNm());
            }
        }
        
        //최상의 값 일 때
        if(crsCtgrVo.getCreTmCtgrLvl().equals(1)) {
            vo.setCreTmCtgrCd(crsCtgrVo.getCreTmCtgrCd());
            vo.setParCreTmCtgrCdLvl1(crsCtgrVo.getCreTmCtgrCd());
            vo.setParCreTmCtgrNmLvl1(crsCtgrVo.getCreTmCtgrNm());
        }
        
        return vo;
    }

    /**
     * 테마 list 조회 .
     * @param CreTmCtgrVO
     * @return ProcessResultVO
     * @throws Exception
     */
    @Override
    public List<CreTmCtgrVO> listCreTmCtgr(CreTmCtgrVO vo) throws Exception {
        List<CreTmCtgrVO> tmCtgrList = crsCtgrDAO.listCreTmCtgr(vo);
        return tmCtgrList;
    }
    
    /**
     * 테마 list 조회 .
     * @param CreTmCtgrVO
     * @return List<CreTmCtgrVO>
     * @throws Exception
     */
    @Override
    public List<CreTmCtgrVO> listCreTmCtgrTree(CreTmCtgrVO vo) throws Exception {
        List<CreTmCtgrVO> tmCtgrList = crsCtgrDAO.listCreTmCtgr(vo);
        
        //최상단용 VO 만들기
        CreTmCtgrVO cretmctgrVO = new CreTmCtgrVO();
        
        //트리형태로 목록을 구성
        for (CreTmCtgrVO parent : tmCtgrList) {
            if(StringUtil.isNull(parent.getParCreTmCtgrCd())) {
                cretmctgrVO.addSubCtgr(parent);
            }
            for (CreTmCtgrVO child : tmCtgrList) {
                if(parent.getCreTmCtgrCd().equals(child.getParCreTmCtgrCd())) {
                    parent.addSubCtgr(child);
                }
            }
        }
        
        return cretmctgrVO.getSubList();
    }
	
}