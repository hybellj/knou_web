package knou.lms.crs.crs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import knou.framework.common.CommConst;
import knou.framework.util.IdGenerator;
import knou.framework.util.StringUtil;
import knou.lms.common.paging.PagingInfo;
import knou.lms.common.vo.ProcessResultListVO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.crs.crs.dao.CrsDAO;
import knou.lms.crs.crs.service.CrsService;
import knou.lms.crs.crs.vo.CrsInfoCntsVO;
import knou.lms.crs.crs.vo.CrsVO;
import knou.lms.org.dao.OrgCodeDAO;
import knou.lms.org.vo.OrgCodeVO;

@Service("crsService")
public class CrsServiceImpl extends EgovAbstractServiceImpl implements CrsService {

    @Resource(name="crsDAO")
    private CrsDAO crsDAO;
    
    /** orgCodeDAO */
    @Resource(name="orgCodeDAO")
    private OrgCodeDAO orgCodeDAO;


    @Override
    public ProcessResultVO<CrsVO> selectCrsList(CrsVO vo) throws Exception {
        ProcessResultVO<CrsVO> resultVO = new ProcessResultVO<CrsVO>();
        
        try {

            PaginationInfo paginationInfo = new PaginationInfo();
            paginationInfo.setCurrentPageNo(vo.getPageIndex());
            paginationInfo.setRecordCountPerPage(vo.getListScale());
            paginationInfo.setPageSize(vo.getListScale());

            vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
            vo.setLastIndex(paginationInfo.getLastRecordIndex());

            String[] crsTypeCds = vo.getCrsTypeCd().split(",");
            vo.setCrsTypeCdes(crsTypeCds);

            List<CrsVO> listPaging = crsDAO.selectCrsList(vo);

            if(listPaging.size() > 0) {
                paginationInfo.setTotalRecordCount(listPaging.get(0).getTotalCnt());
            } else {
                paginationInfo.setTotalRecordCount(0);
            }

            resultVO.setReturnList(listPaging);
            resultVO.setPageInfo(paginationInfo);
            resultVO.setResult(1);
        } catch(Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage("에러가 발생하였습니다.");
        }

        return resultVO;
    }

    @Override
    public ProcessResultVO<CrsVO> updateUseYn(CrsVO vo) throws Exception {
        ProcessResultVO<CrsVO> resultVO = new ProcessResultVO<CrsVO>();

        try {
            crsDAO.updateUseYn(vo);

            resultVO.setResult(1);
            resultVO.setMessage("수정하였습니다.");
        } catch (Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage("수정하지 못하였습니다.");
        }
        return resultVO;
    }

    @Override
    public List<EgovMap> selectCrsListExcelDown(CrsVO vo) throws Exception {
        String[] crsTypeCds = vo.getCrsTypeCd().split(",");
        
        vo.setCrsTypeCdes(crsTypeCds);
        return crsDAO.selectCrsListExcelDown(vo);
    }

    @Override
    public ProcessResultVO<CrsVO> deleteCrs(CrsVO vo) throws Exception {
        ProcessResultVO<CrsVO> resultVO = new ProcessResultVO<CrsVO>();
        try {
            crsDAO.deleteCrs(vo);

            resultVO.setResult(1);
            resultVO.setMessage("삭제하였습니다.");
        } catch (Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage("삭제하지 못하였습니다.");
        }
        return resultVO;
    }

    @Override
    public int selectCrsNmCheck(CrsVO vo) throws Exception {
        return crsDAO.selectCrsNmCheck(vo);
    }

    @Override
    public ProcessResultVO<CrsVO> multiCrs(CrsVO vo) throws Exception {
        ProcessResultVO<CrsVO> resultVO = new ProcessResultVO<CrsVO>();
        
        if(vo.getCrsCd() == null || vo.getCrsCd().equals("")) {
            vo.setCrsCd(IdGenerator.getNewId("CRS"));
        }

        try {
            /*
            if("A".equals(vo.getGubun())) {
                crsDAO.insertCrs(vo);
            } else {
                crsDAO.updateCrs(vo);
            }
            */
            crsDAO.multiCrs(vo);

            resultVO.setResult(1);
            resultVO.setMessage("과목 등록하였습니다.");
        } catch (Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage("과목 등록 실패하였습니다.");
        }

        return resultVO;
    }
    
    // LMS 다른 메뉴들에서 호출해서 사용하는 메서드
    @Override
    public CrsVO selectCrs(CrsVO vo) throws Exception {
        return crsDAO.selectCrs(vo);
    }

    @Override
    public List<CrsVO> selectCrsByCrsCreCd(CreCrsVO vo) throws Exception {
        return crsDAO.selectCrsByCrsCreCd(vo);
    }
    
    @Override
    public List<CrsVO> selectCrsByUserId(CreCrsVO vo) throws Exception {
        return crsDAO.selectCrsByUserId(vo);
    }
    
    @Override
    public List<OrgCodeVO> selectOrgCodeList(CreCrsVO vo) throws Exception {
        OrgCodeVO orgCodeVO = new OrgCodeVO();
        orgCodeVO.setOrgId(vo.getOrgId());
        orgCodeVO.setUseYn("Y");
        orgCodeVO.setUpCd("CRS_TYPE_CD");
        List<OrgCodeVO> crsTypeList = orgCodeDAO.selectOrgCodeList(orgCodeVO);
        
        return crsTypeList;
    }
    
    @Override
    public CrsVO selectCrsInfo(CrsVO vo) throws Exception {
        return crsDAO.selectCrsInfo(vo);
    }

    @Override
    public CrsVO selectCrsView(CrsVO vo) throws Exception {
        CrsVO returnVO = new CrsVO();
        try {
            returnVO = crsDAO.selectCrsView(vo);
        } catch(Exception e) {
            e.printStackTrace();
        }
        return returnVO;
    }
    
    @Override
    public ProcessResultVO<CrsVO> selectList(CrsVO vo) throws Exception {
        ProcessResultVO<CrsVO> resultList = new ProcessResultVO<CrsVO>(); 
        try {
            List<CrsVO> crsList =  crsDAO.selectList(vo);
            resultList.setResult(1);
            resultList.setReturnList(crsList);
        } catch(Exception e) {
            e.printStackTrace();
            resultList.setResult(-1);
            resultList.setMessage(e.getMessage());
        }
        return resultList;
    }
    
    /**
     * 
     * @param 
     * @param pageIndex
     * @param listScale
     * @param pageScale
     * @return ProcessResultListVO
     * @throws Exception
     */
    @Override
    public ProcessResultListVO<CrsVO> crsListPageing(CrsVO vo, int pageIndex, int listScale, int pageScale) throws Exception {
        
        ProcessResultListVO<CrsVO> resultList = new ProcessResultListVO<CrsVO>(); 
        
        try {
            
            /** start of paging */
            PagingInfo paginationInfo = new PagingInfo();
            paginationInfo.setCurrentPageNo(pageIndex);
            paginationInfo.setRecordCountPerPage(listScale);
            paginationInfo.setPageSize(pageScale);
            
            vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
            vo.setLastIndex(paginationInfo.getLastRecordIndex());
            
            List<CrsVO> crsInfoList =  crsDAO.crsListPageing(vo);
            if( crsInfoList != null) {
                
                // 전체 목록 수
                if(crsInfoList.size() > 0) {
                     paginationInfo.setTotalRecordCount(crsInfoList.get(0).getTotalCnt());
                } else {
                     paginationInfo.setTotalRecordCount(0);
                }
            }
            
            resultList.setResult(1);
            resultList.setReturnList(crsInfoList);
            resultList.setPageInfo(paginationInfo);
            
        } catch (Exception e) {
            e.printStackTrace();
            resultList.setResult(-1);
            resultList.setMessage(e.getMessage());
        }
        return resultList;
    }
    @Override
    public ProcessResultListVO<CrsVO> crsListPageing(CrsVO vo, int pageIndex, int listScale) throws Exception {
        return this.crsListPageing(vo, pageIndex, listScale, CommConst.LIST_PAGE_SCALE);
    }
    @Override
    public ProcessResultListVO<CrsVO> crsListPageing(CrsVO vo, int pageIndex) throws Exception {
        return this.crsListPageing(vo, pageIndex, CommConst.LIST_SCALE, CommConst.LIST_PAGE_SCALE);
    }   
    
    /**
     * 기관 정보 목록을 조회한다.
     * @param CrsVO
     * @return List
     * @throws Exception
     */
    @Override
    public List<CrsVO> list(CrsVO vo) throws Exception {
        return crsDAO.list(vo);
    }

    /**
     *  과목 정보 view 조회
     * @param CrsVO
     * @return ProcessResultVO
     * @throws Exception
     */
    @Override
    public ProcessResultVO<CrsVO> viewCrs(CrsVO vo) throws Exception {
        ProcessResultVO<CrsVO> resultVo = new ProcessResultVO<CrsVO>();
        
        try {
            CrsVO returnVO = crsDAO.selectCrs(vo);
            resultVo.setResult(1);
            resultVo.setReturnVO(returnVO);
        } catch(Exception e) {
            e.printStackTrace();
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage());
        }
        return resultVo;
    }

    /**
     *  과목 목록 > 사용여부 토글
     * @param CrsVO
     * @return ProcessResultVO
     * @throws Exception
     */
    @Override
    public int editUseYn(CrsVO vo) throws Exception {
        return crsDAO.editUseYn(vo);
    }
    
    /**
     *  과목 등록
     * @param CrsVO
     * @return ProcessResultVO
     * @throws Exception
     */
    @Override
    public void add(CrsVO vo) throws Exception {
        crsDAO.insert(vo);
        
        // 미리보기
        /*
        String[] urlList = StringUtil.split(vo.getCntsUrl(), ",");
        if(urlList[0] != null) {
            for(int i = 0; i < urlList.length; i++) {
                vo.setCrsInfoCntsCd(IdGenerator.getNewId("INFO"));
                String[] url = StringUtil.split(urlList[i], "|");
                //url 세팅
                vo.setCntsUrl(url[0]);
                
                //소개영상인지 미리보기 영상인지 세팅
                if(url[1].indexOf("I") > -1) {
                    vo.setCrsInfoCntsDivCd("CRS_INTRO");
                }
                if(url[1].indexOf("P") > -1) {
                    vo.setCrsInfoCntsDivCd("CNTS_PREVIEW");
                }
                
                //순서 세팅
                vo.setCntsOrder(i+1);
                
                vo.setCntsFileLocCd(url[4]);
                
                crsDAO.mergeCrsInfoCnts(vo);
            }
        }
        */
    }
    
    /**
     *  과목 수정
     * @param CrsVO
     * @return 
     * @throws Exception
     */
    @Override
    public void edit(CrsVO vo) throws Exception {
        crsDAO.update(vo);
        
        /*
        if(vo.getCntsUrl() != null){
            //미리보기  삭제
            String[] urlList = StringUtil.split(vo.getCntsUrl(), ",");
            if(urlList[0] != null) {
                String[] delInfoCdArray = new String[urlList.length] ;
                for(int i = 0; i < urlList.length; i++) {
                    String[] urlDel = StringUtil.split(urlList[i], "|");
                    delInfoCdArray[i] = urlDel[3];
                }
                vo.setSqlForeach(delInfoCdArray);
            
                crsDAO.deleteCrsInfoCnts(vo);
            
                for(int i = 0; i < urlList.length; i++) {
                    String[] url = StringUtil.split(urlList[i], "|");
                    if(delInfoCdArray[i].equals("N")) {
                        vo.setCrsInfoCntsCd(IdGenerator.getNewId("INFO"));
                    }else {
                        vo.setCrsInfoCntsCd(delInfoCdArray[i]);
                    }
                    
                    //url 세팅
                    vo.setCntsUrl(url[0]);
                    
                    //소개영상인지 미리보기 영상인지 세팅
                    if(url[1].indexOf("I") > -1) {
                        vo.setCrsInfoCntsDivCd("CRS_INTRO");
                    }
                    if(url[1].indexOf("P") > -1) {
                        vo.setCrsInfoCntsDivCd("CNTS_PREVIEW");
                    }
                    
                    //순서 세팅
                    vo.setCntsOrder(i+1);
                    
                    vo.setCntsFileLocCd(url[4]);
                    
                    crsDAO.mergeCrsInfoCnts(vo);
                    
                }
            }
        }
        */
    }
    
    /**
     *  과목 삭제
     * @param CrsVO
     * @return void
     * @throws Exception
     */
    @Override
    public void remove(CrsVO vo) throws Exception{
        crsDAO.delete(vo);
    }
    
    /**
     * 비교과 상세보기 > 강의 미리보기
     * @param CreCrsVO
     * @return List<CreCrsVO>
     * @throws Exception
     */
    @Override
    public List<CrsInfoCntsVO> listCrsPreview(CrsInfoCntsVO vo) throws Exception {
        List<CrsInfoCntsVO> previewList =  crsDAO.listCrsPreview(vo);
        
        return previewList;
    }
    
    /**
     * 외부기관의 과정번호 생성
     * @param CreCrsVO
     * @return String
     * @throws Exception
     */
    @Override
    public String selectNewCrsCd(CrsVO vo) throws Exception {
    	return crsDAO.selectNewCrsCd(vo);
    }
}
