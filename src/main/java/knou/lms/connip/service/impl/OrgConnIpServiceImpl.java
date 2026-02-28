package knou.lms.connip.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.CommConst;
import knou.lms.connip.dao.OrgConnIpDAO;
import knou.lms.connip.service.OrgConnIpService;
import knou.lms.connip.vo.OrgConnIpVO;
import knou.lms.common.paging.PagingInfo;
import knou.lms.common.vo.ProcessResultListVO;
import knou.framework.util.StringUtil;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;


/**
 *  <b>기관 - 접속 IP 관리</b> 영역  Service 클래스
 *  @author
 */
@Service("orgConnIpService")
public class OrgConnIpServiceImpl 
	extends EgovAbstractServiceImpl implements OrgConnIpService {

    @Resource(name="orgConnIpDAO")
    private OrgConnIpDAO 	orgConnIpDAO;

	@Override
	public ProcessResultListVO<OrgConnIpVO> list(OrgConnIpVO vo) throws Exception {
		ProcessResultListVO<OrgConnIpVO> resultList = new ProcessResultListVO<OrgConnIpVO>(); 
		try {
			List<OrgConnIpVO> connIpList =  orgConnIpDAO.list(vo);
			resultList.setResult(1);
			resultList.setReturnList(connIpList);
		} catch (Exception e){
			e.printStackTrace();
			resultList.setResult(-1);
			resultList.setMessage(e.getMessage());
		}
		return resultList;
	}
	
	@Override
	public ProcessResultListVO<OrgConnIpVO> listPageing(OrgConnIpVO vo, 
			int pageIndex, int listScale, int pageScale) throws Exception {

		ProcessResultListVO<OrgConnIpVO> resultList = new ProcessResultListVO<OrgConnIpVO>(); 
		try {
			/** start of paging */
			PagingInfo paginationInfo = new PagingInfo();
			paginationInfo.setCurrentPageNo(pageIndex);
			paginationInfo.setRecordCountPerPage(listScale);
			paginationInfo.setPageSize(pageScale);
			
			vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
			vo.setLastIndex(paginationInfo.getLastRecordIndex());
			
			// 전체 목록 수
			int totalCount = orgConnIpDAO.count(vo);
			paginationInfo.setTotalRecordCount(totalCount);
			
			List<OrgConnIpVO> connIpList =  orgConnIpDAO.listPageing(vo);
			resultList.setResult(1);
			resultList.setReturnList(connIpList);
			resultList.setPageInfo(paginationInfo);
			
		} catch (Exception e) {
			e.printStackTrace();
			resultList.setResult(-1);
			resultList.setMessage(e.getMessage());
		}
		return resultList;
	}
	
	@Override
	public ProcessResultListVO<OrgConnIpVO> listPageing(OrgConnIpVO vo, 
			int pageIndex, int listScale) throws Exception {
	    
		return this.listPageing(vo, pageIndex, listScale, CommConst.LIST_PAGE_SCALE);
	}
	
	@Override
	public ProcessResultListVO<OrgConnIpVO> listPageing(OrgConnIpVO vo, 
			int pageIndex) throws Exception {
		return this.listPageing(vo, pageIndex, CommConst.LIST_SCALE, CommConst.LIST_PAGE_SCALE);
	}	
	
	@Override
	public OrgConnIpVO view(OrgConnIpVO vo) throws Exception {
		return orgConnIpDAO.select(vo);
	}
	
	@Override
	public void add(OrgConnIpVO vo) throws Exception {
		orgConnIpDAO.insert(vo);
	}	
	
	@Override
	public void remove(OrgConnIpVO vo) throws Exception {
		orgConnIpDAO.delete(vo);
	}

    /**
	 *  접속IP 권한 체크  
	 * @param OrgConnIpVO
	 * @return boolean
	 * @throws Exception
	 */
	@Override
	public boolean orgConnIpAuth(OrgConnIpVO vo) throws Exception {

		int equalCnt = 0;
		boolean result = true;
		String[] remoteIpArr = StringUtil.split(vo.getRemoteIp(), ".");
		String remoteIpA = "";
		String remoteIpBase = "";
		if(remoteIpArr.length > 3) {
			remoteIpA = remoteIpArr[0]+"."+remoteIpArr[1]+"."+remoteIpArr[2]+".*";
			remoteIpBase = remoteIpArr[0]+"."+remoteIpArr[1]+"."+remoteIpArr[2];
		}
		List<OrgConnIpVO> orgConnIpList = orgConnIpDAO.list(vo);
		
		for(OrgConnIpVO socivo : orgConnIpList) {
			String[] connIpArr = StringUtil.split(socivo.getConnIp(),".");
			String connIpBase = connIpArr[0]+"."+connIpArr[1]+"."+connIpArr[2];
			if("Y".equals(StringUtil.nvl(socivo.getBandYn(),""))) {
				if( remoteIpA.equals(socivo.getConnIp()) || 
						(remoteIpBase.equals(connIpBase) && 
								(Integer.parseInt(connIpArr[3]) <= Integer.parseInt(remoteIpArr[3]) && Integer.parseInt(remoteIpArr[3]) <= Integer.parseInt(socivo.getBandVal()))
						)
				  ) equalCnt++;
			} else {
				if(vo.getRemoteIp().equals(socivo.getConnIp())) equalCnt++;
			}
		}
		
		if(orgConnIpList.size() > 0) {
			if(equalCnt <= 0) {
				result = false;
			}
		}
		return result;
	}
}
