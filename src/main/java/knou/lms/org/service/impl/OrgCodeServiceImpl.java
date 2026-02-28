package knou.lms.org.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import knou.framework.common.CommConst;
import knou.framework.common.SessionInfo;
import knou.framework.util.DateTimeUtil;
import knou.lms.common.paging.PagingInfo;
import knou.lms.common.vo.ProcessResultListVO;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.org.dao.OrgCodeCtgrDAO;
import knou.lms.org.dao.OrgCodeDAO;
import knou.lms.org.dao.OrgCodeLangDAO;
import knou.lms.org.service.OrgCodeService;
import knou.lms.org.vo.OrgCodeCtgrVO;
import knou.lms.org.vo.OrgCodeLangVO;
import knou.lms.org.vo.OrgCodeVO;

@Service("orgCodeService")
public class OrgCodeServiceImpl implements OrgCodeService {

	/** orgCodeDAO */
	@Resource(name="orgCodeDAO")
	private OrgCodeDAO orgCodeDAO;
	
	/** orgCodeLangDAO */
	@Resource(name="orgCodeLangDAO")
	private OrgCodeLangDAO orgCodeLangDAO;
	
	/** orgCodeCtgrDAO */
    @Resource(name="orgCodeCtgrDAO")
    private OrgCodeCtgrDAO orgCodeCtgrDAO;
    
	private final HashMap<String, List<OrgCodeVO>> codeCache = new HashMap<String, List<OrgCodeVO>>();
	private String codeVerDate = "19000101000001";

	@Override
	public List<OrgCodeVO> selectOrgCodeList(CreCrsVO vo) throws Exception {
	    
		OrgCodeVO orgCodeVO = new OrgCodeVO();
        orgCodeVO.setOrgId("ORG0000001");
        orgCodeVO.setUseYn("Y");
        orgCodeVO.setUpCd("CRS_TYPE_CD");
        List<OrgCodeVO> crsTypeList = orgCodeDAO.selectOrgCodeList(orgCodeVO);
        
		return crsTypeList;
	}
	
	@Override
    public List<OrgCodeVO> selectOrgCodeList(OrgCodeVO vo) throws Exception {
	    
	    List<OrgCodeVO> orgCodeList = orgCodeDAO.selectOrgCodeList(vo);
	    
        return orgCodeList;
    }

	@Override
	public List<OrgCodeVO> selectOrgCodeList(String codeCtgrCd) throws Exception {
	    
		// 변경이 감지되면 캐쉬를 비운다.
		if(DateTimeUtil.getIntervalSecond(codeVerDate) > 360) {
			//-- 케시 검사한지 1시간이 지난 경우, 코드 검사 시간이 1시간이 지나지 않은 경우는 코드 버전을 체크 하지 않는다.
			//if(isCodeChanged()) {
			    //this.codeCache.clear();
				//this.codeVersion = orgCodeMapper.selectVersion();
				//log.debug("[ 코드 변경내용 감지.. 캐쉬를 초기화 합니다. ]");
			//}
			codeVerDate = DateTimeUtil.getCurrentString(); //-- 현재의 시간을 셋팅함.
		}

		// 메모리에 로드되어 있지 않으면 DB에서 로딩..
		if(!this.codeCache.containsKey(codeCtgrCd)) {
			//OrgCodeVO orgCodeVo = new OrgCodeVO();
			//orgCodeVo.setUpCdId(codeCtgrCd);
		    this.codeCache.put(codeCtgrCd, listCode(codeCtgrCd, true));
			//log.debug("캐쉬 적중 실패 DB에서 직접 CODE를 조회합니다. codeCtgrCd [" + codeCtgrCd + "]");
		} else {
			//log.debug("캐쉬 적중 성공 메모리에서 CODE를 불러옵니다. codeCtgrCd [" + codeCtgrCd + "]");
		}
		return this.codeCache.get(codeCtgrCd);		
	}
	
	@Override
	public List<OrgCodeVO> listCode(String codeCtgrCd, boolean use) throws Exception {
	    
		List<OrgCodeVO> codeList = listCodeByDB(codeCtgrCd);
		List<OrgCodeVO> returnList = new ArrayList<OrgCodeVO>();
		
		for(OrgCodeVO scvo : codeList) {
			if(use) {
				if("Y".equals(scvo.getUseYn())) {
					returnList.add(scvo);
				}
			} else {
				returnList.add(scvo);
			}
		}
		return returnList;
	}
	
	public List<OrgCodeVO> listCodeByDB(String upCd) throws Exception {
	    HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.getRequestAttributes()).getRequest();
	    String orgId = null;
	    
	    if(request != null) {
	        orgId = SessionInfo.getOrgId(request);
	    }
	    
		OrgCodeVO orgCodeVO = new OrgCodeVO();
		orgCodeVO.setUpCd(upCd);
	    orgCodeVO.setOrgId(orgId);

		List<OrgCodeVO> codeList = orgCodeDAO.selectOrgCodeList(orgCodeVO);
//		List<OrgCodeVO> returnList = new ArrayList<OrgCodeVO>();
		
		for(OrgCodeVO iOrgCodeVO : codeList) {
			OrgCodeLangVO orgCodeLangVO = new OrgCodeLangVO();
			orgCodeLangVO.setUpCd(iOrgCodeVO.getUpCd());
			orgCodeLangVO.setCd(iOrgCodeVO.getCd());
			List<OrgCodeLangVO> codeLangList = orgCodeLangDAO.list(orgCodeLangVO);
			iOrgCodeVO.setCodeLangList(codeLangList);
//			returnList.add(iOrgCodeVO);
		}
		
		return codeList;
	}
	
	/**
     * 코드 정보의 목록를 반환한다.
     * @param OrgCodeCtgrVO
     * @return ProcessResultListDTO<OrgCodeVO>
     * @throws Exception
     */
    @Override
    public ProcessResultListVO<OrgCodeVO> listCode(String orgId, String codeCtgrCd) throws Exception {
        return this.listCode(orgId, codeCtgrCd, true);
    }
    
    /**
     * 코드 정보의 목록를 반환한다.
     * @param codeCtgrCd
     * @return ProcessResultListDTO<OrgCodeVO>
     * @throws Exception 
     */
    @Override
    public ProcessResultListVO<OrgCodeVO> listCode(String orgId, String codeCtgrCd, boolean use) throws Exception {
        //List<OrgCodeVO> codeList = listCodeWithCache(codeCtgrCd);
        OrgCodeVO orgCodeVO = new OrgCodeVO();
        orgCodeVO.setOrgId(orgId);
        orgCodeVO.setUpCd(codeCtgrCd);
        
        List<OrgCodeVO> codeList = orgCodeDAO.list(orgCodeVO);
        
        ProcessResultListVO<OrgCodeVO> result = new ProcessResultListVO<OrgCodeVO>();
        List<OrgCodeVO> returnList = new ArrayList<OrgCodeVO>();
        for(OrgCodeVO ocvo : codeList) {
            if(use) {
                if("Y".equals(ocvo.getUseYn())) returnList.add(ocvo);
            } else {
                returnList.add(ocvo);
            }
        }
        
        result.setResult(1);
        result.setReturnList(returnList);
        
        return result;
    }
    @Override
    public ProcessResultListVO<OrgCodeVO> listCode(String orgId, String codeCtgrCd, String langCd, boolean use) throws Exception {
        
        // tb_org_code에 조회헤서 사용 여부를 확인한다. Y값인 경우에만 사용한다.
        OrgCodeVO orgCodeVO = new OrgCodeVO();
        orgCodeVO.setOrgId(orgId);
        orgCodeVO.setUpCd(codeCtgrCd);
        orgCodeVO.setLangCd(langCd);
        
        List<OrgCodeVO> orgCodeList = orgCodeDAO.list(orgCodeVO); // org table 조회

        ProcessResultListVO<OrgCodeVO> result = new ProcessResultListVO<OrgCodeVO>();
        List<OrgCodeVO> returnList = new ArrayList<OrgCodeVO>();
        
        for(OrgCodeVO vo : orgCodeList) {
            if(use) {
                // 사용값이 Y인지 확인한다. Y값이라면 org code lang 테이블을 조회한다.
                if("Y".equals(vo.getUseYn())) { 
                    OrgCodeLangVO orgCodeLangVO = new OrgCodeLangVO();
                    orgCodeLangVO.setOrgId(orgId);
                    orgCodeLangVO.setCd(vo.getCd());
                    orgCodeLangVO.setUpCd(codeCtgrCd);
                    orgCodeLangVO.setLangCd(langCd);
                    
                    vo.setCodeLangVO(checkOrgCodeLangData(orgCodeLangDAO.select(orgCodeLangVO), "en"));
                    returnList.add(vo);
                }
            } else {
                returnList.add(vo);
            }
        }
        
        result.setResult(1);
        result.setReturnList(returnList);
        return result;
    }
    
    /**
     * 코드의 정보를 조회한다.
     * @param cdCtgrCd
     * @param cdCd
     * @return OrgCodeVO
     */
    @Override
    public OrgCodeVO viewCode(String orgId, String codeCtgrCd, String codeCd) throws Exception {
        
        OrgCodeVO orgCodeVO = new OrgCodeVO();
        orgCodeVO.setOrgId(orgId);
        orgCodeVO.setUpCd(codeCtgrCd);
        orgCodeVO.setCd(codeCd);
        orgCodeVO = orgCodeDAO.select(orgCodeVO);

        OrgCodeLangVO orgCodeLangVO = new OrgCodeLangVO();
        orgCodeLangVO.setOrgId(orgId);
        orgCodeLangVO.setUpCd(codeCtgrCd);
        orgCodeLangVO.setCd(codeCd);
        List<OrgCodeLangVO> codeLangList = orgCodeLangDAO.list(orgCodeLangVO);
        
        if(codeLangList != null && !codeLangList.isEmpty() && codeLangList.size() > 0) {
            orgCodeVO.setCodeLangList(codeLangList);
        }

        return orgCodeVO;
    }

    /**
     *  코드 분류 전체 목록을 조회한다.
     * @param OrgCodeCtgrVO
     * @return ProcessResultListVO
     * @throws Exception
     */
    @Override
    public ProcessResultListVO<OrgCodeCtgrVO> listCtgr(OrgCodeCtgrVO vo) throws Exception {
        
        ProcessResultListVO<OrgCodeCtgrVO> resultList = new ProcessResultListVO<OrgCodeCtgrVO>(); 
        
        try {
            List<OrgCodeCtgrVO> codeCtgrList =  orgCodeCtgrDAO.list(vo);
            resultList.setResult(1);
            resultList.setReturnList(codeCtgrList);
        } catch (Exception e){
            e.printStackTrace();
            resultList.setResult(-1);
            resultList.setMessage(e.getMessage());
        }
        return resultList;
    }

    /**
     * 코드 분류 페이징 목록을 조회한다.
     * @param OrgCodeCtgrVO
     * @param pageIndex
     * @param listScale
     * @return ProcessResultListVO
     * @throws Exception
     */
    @Override
    public ProcessResultListVO<OrgCodeCtgrVO> listCtgrPageing(OrgCodeCtgrVO vo, int pageIndex, int listScale) throws Exception {
        return this.listCtgrPageing(vo, pageIndex, listScale, CommConst.LIST_PAGE_SCALE);
    }
    
    /**
     * 코드 분류 페이징 목록을 조회한다.
     * @param OrgCodeCtgrVO
     * @param pageIndex
     * @param listScale
     * @param pageScale
     * @return ProcessResultListVO
     * @throws Exception
     */
    @Override
    public ProcessResultListVO<OrgCodeCtgrVO> listCtgrPageing(OrgCodeCtgrVO vo, int pageIndex, int listScale, int pageScale) throws Exception {
        
        ProcessResultListVO<OrgCodeCtgrVO> resultList = new ProcessResultListVO<OrgCodeCtgrVO>(); 
        
        try {
            /** start of paging */
            PagingInfo paginationInfo = new PagingInfo();
            paginationInfo.setCurrentPageNo(pageIndex);
            paginationInfo.setRecordCountPerPage(listScale);
            paginationInfo.setPageSize(pageScale);
            
            vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
            vo.setLastIndex(paginationInfo.getLastRecordIndex());
            
            // 전체 목록 수
            int totalCount = orgCodeCtgrDAO.count(vo);
            paginationInfo.setTotalRecordCount(totalCount);
            
            List<OrgCodeCtgrVO> codeCtgrList =  orgCodeCtgrDAO.listPageing(vo);
            resultList.setResult(1);
            resultList.setReturnList(codeCtgrList);
            resultList.setPageInfo(paginationInfo);
            
        } catch (Exception e) {
            e.printStackTrace();
            resultList.setResult(-1);
            resultList.setMessage(e.getMessage());
        }
        return resultList;
    }
    
    /**
     * 코드 카테고리 수를 조회 한다.
     *
     * @param vo
     * @return int
     * @throws Exception 
     */
    @Override
    public int countCodeCtgr(OrgCodeCtgrVO vo) throws Exception {
        return orgCodeCtgrDAO.count(vo);
    }
    
    /**
     * 코드 분류 정보를 등록한다.
     * @param OrgCodeCtgrVO
     * @return String
     * @throws Exception
     */
    @Override
    public int addCtgr(OrgCodeCtgrVO vo) throws Exception {
        return orgCodeCtgrDAO.insert(vo);
    }
    
    /**
     * 코드 분류 상세 정보를 조회한다.
     * @param OrgCodeCtgrVO
     * @return OrgCodeCtgrVO
     * @throws Exception
     */
    @Override
    public OrgCodeCtgrVO viewCtgr(OrgCodeCtgrVO vo) throws Exception {
        return orgCodeCtgrDAO.select(vo);
    }
    
    /**
     * 코드 분류 정보를 수정한다.
     * @param OrgCodeCtgrVO
     * @return int
     * @throws Exception
     */
    @Override
    public int editCtgr(OrgCodeCtgrVO vo) throws Exception {
        return orgCodeCtgrDAO.update(vo);
    }
    
    /**
     * 코드 분류 정보를 삭제 한다.
     * @param OrgCodeCtgrVO
     * @return int
     * @throws Exception
     */
    @Override
    public int removeCtgr(String orgId, String codeCtgrCd) throws Exception {
        
        // 분류 하위의 모든 언어 정보를 삭제함.
        OrgCodeLangVO orgCodeLangVO = new OrgCodeLangVO();
        orgCodeLangVO.setOrgId(orgId);
        orgCodeLangVO.setUpCd(codeCtgrCd);
        orgCodeLangDAO.deleteAllByCtgr(orgCodeLangVO);
        
        // 분류 하위의 모든 코드 정보를 삭제함.
        OrgCodeVO orgCodeVO = new OrgCodeVO();
        orgCodeVO.setOrgId(orgId);
        orgCodeVO.setUpCd(codeCtgrCd);
        return orgCodeDAO.deleteAll(orgCodeVO);
        
//        OrgCodeCtgrVO orgCodeCtgrVO = new OrgCodeCtgrVO();
//        orgCodeCtgrVO.setOrgId(orgId);
//        orgCodeCtgrVO.setUpCdId(codeCtgrCd);
//        
//        return orgCodeCtgrDAO.delete(orgCodeCtgrVO);
    }
    
    /**
     * 코드 페이징 목록을 가져온다.
     */
    @Override
    public ProcessResultListVO<OrgCodeVO> listCodePageing(OrgCodeVO vo, int pageIndex) throws Exception {
        return this.listCodePageing(vo, pageIndex, CommConst.LIST_SCALE, CommConst.LIST_PAGE_SCALE);
    }
    @Override
    public ProcessResultListVO<OrgCodeVO> listCodePageing(OrgCodeVO vo, int pageIndex, int listScale) throws Exception {
        return this.listCodePageing(vo, pageIndex, listScale, CommConst.LIST_PAGE_SCALE);
    }
    @Override
    public ProcessResultListVO<OrgCodeVO> listCodePageing(OrgCodeVO vo, int pageIndex, int listScale, int pageScale) throws Exception {
        ProcessResultListVO<OrgCodeVO> resultList = new ProcessResultListVO<OrgCodeVO>(); 
        
        try {
            /** start of paging */
            PagingInfo paginationInfo = new PagingInfo();
            paginationInfo.setCurrentPageNo(pageIndex);
            paginationInfo.setRecordCountPerPage(listScale);
            paginationInfo.setPageSize(pageScale);
            
            vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
            vo.setLastIndex(paginationInfo.getLastRecordIndex());
            
            // 전체 목록 수
            int totalCount = orgCodeDAO.count(vo);
            paginationInfo.setTotalRecordCount(totalCount);
            
            List<OrgCodeVO> returnList =  orgCodeDAO.listPageing(vo);
            resultList.setResult(1);
            resultList.setReturnList(returnList);
            resultList.setPageInfo(paginationInfo);
            
        } catch (Exception e) {
            e.printStackTrace();
            resultList.setResult(-1);
            resultList.setMessage(e.getMessage());
        }
        return resultList;
    }

    /**
     * 코드 수를 조회 한다.
     *
     * @param vo
     * @return int
     * @throws Exception 
     */
    @Override
    public int countCode(OrgCodeVO vo) throws Exception {
        return orgCodeDAO.count(vo);
    }
    
    /**
     * 코드 정보를 등록한다.
     * @param OrgCodeVO
     * @return int
     * @throws Exception
     */
    @Override
    public int addCode(OrgCodeVO vo) throws Exception {
        String codeCtgr = "";
        if("Y".equals(vo.getAutoMakeYn())) {
            
            if(vo.getUpCd().equals("USER_DIV_CD")) {
                codeCtgr = "UDIV";
            } else if(vo.getUpCd().equals("AREA_CD")) {
                codeCtgr = "AREA";
            } else if(vo.getUpCd().equals("DEPT_CD")) {
                codeCtgr = "DEPT";
            } else if(vo.getUpCd().equals("JOB_CD")) {
                codeCtgr = "JOB";
            } else {
                codeCtgr = "CODE";
            }
            OrgCodeVO vo2 = new OrgCodeVO();
            vo2.setUpCd(codeCtgr);
            vo.setCd(orgCodeDAO.selectKey(vo2));
        }
        return orgCodeDAO.insert(vo);
    }
    
    /**
    * 특정 언어키 값에 해당하는 코드의 정보를 조회한다.
    * @param cdCtgrCd
    * @param cdCd
    * @param langCd
    * @return OrgCodeVO
    */
   @Override
   public OrgCodeLangVO viewCode(String orgId, String codeCtgrCd, String codeCd, String langCd) throws Exception {
       // 코드 정보 조회는 다음이 조건을 가진다.
       // 1. params로 넘어온 langCd값을 기준으로 조회
       // 2. 해당 값이 존재하지 않다면, langCd=en (영문) 값으로 조회
       // 3. 영문 값도 존재하지 않다면, langCd=ko (한글, default) 값으로 조회
       // 4. 한글 값으로도 존재하지 않다면, 공백값을 넘겨줄 것이며, error 로그를 쌓는다.
       OrgCodeLangVO orgCodeLangVO = new OrgCodeLangVO();
       orgCodeLangVO.setOrgId(orgId);
       orgCodeLangVO.setUpCd(codeCtgrCd);
       orgCodeLangVO.setCd(codeCd);
       orgCodeLangVO.setLangCd(langCd);
           
       return checkOrgCodeLangData(orgCodeLangDAO.select(orgCodeLangVO), "en");
   }
    
   /**
    * 코드 정보를 수정한다.
    * @param OrgCodeVO
    * @return int
    * @throws Exception
    */
   @Override
   public int editCode(OrgCodeVO vo) throws Exception {

       int result = orgCodeDAO.update(vo);
       List<OrgCodeLangVO> codeLangList = vo.getCodeLangList();

       for(OrgCodeLangVO oclvo : codeLangList) {
           try {
               orgCodeLangDAO.insert(oclvo);
           } catch(Exception e) {
               orgCodeLangDAO.update(oclvo);
           }
       }
       return result;
   }
  
   /**
    * 코드 정보를 삭제한다.
    * @param codeCtgrCd
    * @param codeCd
    * @return int
    * @throws Exception
    */
   @Override
   public int removeCode(String orgId, String codeCtgrCd, String codeCd) throws Exception {
       OrgCodeLangVO orgCodeLangVO = new OrgCodeLangVO();
       orgCodeLangVO.setOrgId(orgId);
       orgCodeLangVO.setUpCd(codeCtgrCd);
       orgCodeLangVO.setCd(codeCd);
       orgCodeLangDAO.deleteAll(orgCodeLangVO);
       
       OrgCodeVO orgCodeVO = new OrgCodeVO();
       orgCodeVO.setOrgId(orgId);
       orgCodeVO.setUpCd(codeCtgrCd);
       orgCodeVO.setCd(codeCd);
       int result = orgCodeDAO.delete(orgCodeVO);

       return result;
   }   
   
   // vo는 orgCode 정보를 가지고 있는 object다.
   // langCd에 해당하는 값이 없다면(null), 외국어의 기본값인 영어(en)값으로 다시 호출한다.
   // en에 해당하는 값도 없다면 system default 값인 한국어(ko)값으로 다시 호출한다.
   private OrgCodeLangVO checkOrgCodeLangData(OrgCodeLangVO vo, String nextLangCd) throws Exception {
       if(vo.getCdnm() == null) {
           vo.setLangCd(nextLangCd);
           
           if(orgCodeLangDAO.select(vo).getCdnm() == null) {
               vo.setLangCd(CommConst.LANG_DEFAULT);
               return orgCodeLangDAO.select(vo);
           } else {
               return vo;
           }
       } else {
           return vo;
       }
   }

   @Override
   public List<OrgCodeVO> list(CreCrsVO vo) throws Exception {
       
       OrgCodeVO orgCodeVO = new OrgCodeVO();
       orgCodeVO.setOrgId("ORG0000001");
       orgCodeVO.setUseYn("Y");
       orgCodeVO.setUpCd("CRS_TYPE_CD");
       
       List<OrgCodeVO> crsTypeList = orgCodeDAO.list(orgCodeVO);
       
       return crsTypeList;
   }
   
   @Override
   public List<OrgCodeVO> list(OrgCodeVO vo) throws Exception {
       
       List<OrgCodeVO> orgCodeList = orgCodeDAO.list(vo);
       
       return orgCodeList;
   }

   @Override
   public List<OrgCodeVO> list(String codeCtgrCd) throws Exception {
       
       // 변경이 감지되면 캐쉬를 비운다.
       if(DateTimeUtil.getIntervalSecond(codeVerDate) > 360) {
           //-- 케시 검사한지 1시간이 지난 경우, 코드 검사 시간이 1시간이 지나지 않은 경우는 코드 버전을 체크 하지 않는다.
           //if(isCodeChanged()) {
               //this.codeCache.clear();
               //this.codeVersion = orgCodeMapper.selectVersion();
               //log.debug("[ 코드 변경내용 감지.. 캐쉬를 초기화 합니다. ]");
           //}
           codeVerDate = DateTimeUtil.getCurrentString(); //-- 현재의 시간을 셋팅함.
       }

       // 메모리에 로드되어 있지 않으면 DB에서 로딩..
       if(!this.codeCache.containsKey(codeCtgrCd)) {
           //OrgCodeVO orgCodeVo = new OrgCodeVO();
           //orgCodeVo.setUpCdId(codeCtgrCd);
           this.codeCache.put(codeCtgrCd, listCode(codeCtgrCd, true));
           //log.debug("캐쉬 적중 실패 DB에서 직접 CODE를 조회합니다. codeCtgrCd [" + codeCtgrCd + "]");
       } else {
           //log.debug("캐쉬 적중 성공 메모리에서 CODE를 불러옵니다. codeCtgrCd [" + codeCtgrCd + "]");
       }
       return this.codeCache.get(codeCtgrCd);      
   }

    @Override
    public OrgCodeVO select(OrgCodeVO vo) throws Exception {
        OrgCodeVO orgCodeVO = new OrgCodeVO();
        orgCodeVO = orgCodeDAO.select(orgCodeVO);
    
        OrgCodeLangVO orgCodeLangVO = new OrgCodeLangVO();
        List<OrgCodeLangVO> codeLangList = orgCodeLangDAO.list(orgCodeLangVO);
        orgCodeVO.setCodeLangList(codeLangList);
    
        return orgCodeVO;
    }

    /**
     * 코드 정보의 목록를 반환한다.
     * @param codeCtgrCd
     * @return ProcessResultListDTO<OrgCodeVO>
     * @throws Exception 
     */
    public ProcessResultListVO<OrgCodeVO> listCodes(String codeCtgrCd, boolean use) throws Exception {
        List<OrgCodeVO> codeList = listCodeByDBs(codeCtgrCd).getReturnList();
        ProcessResultListVO<OrgCodeVO> result = new ProcessResultListVO<OrgCodeVO>();
        List<OrgCodeVO> returnList = new ArrayList<OrgCodeVO>();
        for(OrgCodeVO scvo : codeList) {
            if(use) {
                if("Y".equals(scvo.getUseYn())) {
                    returnList.add(scvo);
                }
            } else {
                returnList.add(scvo);
            }
        }
        result.setResult(1);
        result.setReturnList(returnList);
        return result;
    }
    
    /**
     * 코드 정보의 목록를 반환한다.
     * @param OrgCodeCtgrVO
     * @return ProcessResultListDTO<OrgCodeVO>
     * @throws Exception
     */
    @Override
    public ProcessResultListVO<OrgCodeVO> listCodes(String orgId, String codeCtgrCd) throws Exception {
        return this.listCodes(orgId, codeCtgrCd, true);
    }
    
    /**
     * 코드 정보의 목록를 반환한다.
     * @param codeCtgrCd
     * @return ProcessResultListDTO<OrgCodeVO>
     * @throws Exception 
     */
    @Override
    public ProcessResultListVO<OrgCodeVO> listCodes(String orgId, String codeCtgrCd, boolean use) throws Exception {
        
        // List<OrgCodeVO> codeList = listCodeWithCache(codeCtgrCd);
        OrgCodeVO orgCodeVO = new OrgCodeVO();
        orgCodeVO.setOrgId(orgId);
        orgCodeVO.setUpCd(codeCtgrCd);
        List<OrgCodeVO> codeList = orgCodeDAO.list(orgCodeVO);
        ProcessResultListVO<OrgCodeVO> result = new ProcessResultListVO<OrgCodeVO>();
        List<OrgCodeVO> returnList = new ArrayList<OrgCodeVO>();
        
        for(OrgCodeVO ocvo : codeList) {
            if(use) {
                if("Y".equals(ocvo.getUseYn())) returnList.add(ocvo);
            } else {
                returnList.add(ocvo);
            }
        }
        
        result.setResult(1);
        result.setReturnList(returnList);
        return result;
    }
    
    @Override
    public ProcessResultListVO<OrgCodeVO> listCodes(String orgId, String codeCtgrCd, String langCd, boolean use) throws Exception {
        
        // tb_org_code에 조회헤서 사용 여부를 확인한다. Y값인 경우에만 사용한다.
        OrgCodeVO orgCodeVO = new OrgCodeVO();
        orgCodeVO.setOrgId(orgId);
        orgCodeVO.setUpCd(codeCtgrCd);
        orgCodeVO.setLangCd(langCd);
        
        List<OrgCodeVO> orgCodeList = orgCodeDAO.list(orgCodeVO); // org table 조회

        ProcessResultListVO<OrgCodeVO> result = new ProcessResultListVO<OrgCodeVO>();
        List<OrgCodeVO> returnList = new ArrayList<OrgCodeVO>();
        
        for(OrgCodeVO vo : orgCodeList) {
            if(use) {
                // 사용값이 Y인지 확인한다. Y값이라면 org code lang 테이블을 조회한다.
                if("Y".equals(vo.getUseYn())) { 
                    OrgCodeLangVO orgCodeLangVO = new OrgCodeLangVO();
                    orgCodeLangVO.setOrgId(orgId);
                    orgCodeLangVO.setCd(vo.getCd());
                    orgCodeLangVO.setUpCd(codeCtgrCd);
                    orgCodeLangVO.setLangCd(langCd);
                    
                    vo.setCodeLangVO(checkOrgCodeLangData(orgCodeLangDAO.select(orgCodeLangVO), "en"));
                    returnList.add(vo);
                }
            } else {
                returnList.add(vo);
            }
        }
        
        result.setResult(1);
        result.setReturnList(returnList);
        return result;
    }
    
    public ProcessResultListVO<OrgCodeVO> listCodeByDBs(String codeCtgrCd) throws Exception {
        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
        String orgId = SessionInfo.getOrgId(request);
        
        OrgCodeVO scvo = new OrgCodeVO();
        scvo.setUpCd(codeCtgrCd);
        scvo.setOrgId(orgId);

        List<OrgCodeVO> codeList = orgCodeDAO.list(scvo);
        ProcessResultListVO<OrgCodeVO> result = new ProcessResultListVO<OrgCodeVO>();
        List<OrgCodeVO> returnList = new ArrayList<OrgCodeVO>();
        for(OrgCodeVO svo : codeList) {
            OrgCodeLangVO sclvo = new OrgCodeLangVO();
            sclvo.setOrgId(orgId);
            sclvo.setUpCd(svo.getUpCd());
            sclvo.setCd(svo.getCd());
            sclvo.setLangCd(svo.getLangCd());
            List<OrgCodeLangVO> codeLangList = orgCodeLangDAO.list(sclvo);
            svo.setCodeLangList(codeLangList);
            returnList.add(svo);
        }
        result.setResult(1);
        result.setReturnList(returnList);
        return result;
    }
    
    /**
     * 시스템 코드 리스트를 반환한다.
     *
     * @param codeCtgrCd
     * @return
     */
    @Override
    public synchronized List<OrgCodeVO> getOrgCodeList(String codeCtgrCd) throws Exception {
        
        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
        String langCd = SessionInfo.getLocaleKey(request);
        // 변경이 감지되면 캐쉬를 비운다.

        if(DateTimeUtil.getIntervalSecond(codeVerDate) > 360) {
            //-- 케시 검사한지 1시간이 지난 경우, 코드 검사 시간이 1시간이 지나지 않은 경우는 코드 버전을 체크 하지 않는다.
            //if(isCodeChanged()) {
                //this.codeCache.clear();
                //this.codeVersion = orgCodeMapper.selectVersion();
                //log.debug("[ 코드 변경내용 감지.. 캐쉬를 초기화 합니다. ]");
            //}
            codeVerDate = DateTimeUtil.getCurrentString(); //-- 현재의 시간을 셋팅함.
        }

        // 메모리에 로드되어 있지 않으면 DB에서 로딩..
        if(!this.codeCache.containsKey(codeCtgrCd)) {
            
            //OrgCodeVO orgCodeVo = new OrgCodeVO();
            //orgCodeVo.setUpCdId(codeCtgrCd);
            
            this.codeCache.put(codeCtgrCd, listCodes(codeCtgrCd, true).getReturnList());
            
            //log.debug("캐쉬 적중 실패 DB에서 직접 CODE를 조회합니다. codeCtgrCd [" + codeCtgrCd + "]");
        } else {
            //log.debug("캐쉬 적중 성공 메모리에서 CODE를 불러옵니다. codeCtgrCd [" + codeCtgrCd + "]");
        }
        
        List<OrgCodeVO> vo = this.codeCache.get(codeCtgrCd);
        for(OrgCodeVO codeVO : vo) {
            for(OrgCodeLangVO codeLangVO : codeVO.getCodeLangList()) {
                if(langCd.equals(codeLangVO.getLangCd())) codeVO.setCdnm(codeLangVO.getCdnm());
            }
        }
        return vo;
    }
   
}
