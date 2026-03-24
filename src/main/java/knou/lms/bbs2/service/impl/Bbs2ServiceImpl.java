package knou.lms.bbs2.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.bbs2.dao.Bbs2AtclDAO;
import knou.lms.bbs2.dto.BbsParam;
import knou.lms.bbs2.service.Bbs2Service;
import knou.lms.common.dto.BaseParam;

@Service("bbs2Service")
public class Bbs2ServiceImpl extends ServiceBase implements Bbs2Service {

	@Resource(name = "bbs2AtclDAO")
	
    private Bbs2AtclDAO bbs2AtclDAO;
	
	@Override
	public EgovMap bbsUnreadCntSelect(BaseParam param) throws Exception {
		return bbs2AtclDAO.bbsUnreadCntSelect(param);
	}	
	@Override
	public List<EgovMap> dashCrsNoticeList(BaseParam param) throws Exception {
		return bbs2AtclDAO.dashCrsNoticeList(param);
	}
	@Override
	public List<EgovMap> profDashAllNoticeList(BaseParam param) throws Exception {
		return bbs2AtclDAO.profDashAllNoticeList(param);
	}	
	@Override
	public List<EgovMap> profDashSubjectNoticeList(BaseParam param) throws Exception {
		return bbs2AtclDAO.profDashSubjectNoticeList(param);
	}	
	@Override
	public List<EgovMap> profDashLctrQnaList(BaseParam param) throws Exception {
		return bbs2AtclDAO.profDashLctrQnaList(param);
	}	
	@Override
	public List<EgovMap> profDashOneOnOneList(BaseParam param) throws Exception {
		return bbs2AtclDAO.profDashOneOnOneList(param);
	}
	
	@Override
	public List<EgovMap> stdntDashAllNoticeList(BaseParam param) throws Exception {
		return bbs2AtclDAO.stdntDashAllNoticeList(param);
	}
	@Override
	public List<EgovMap> stdntDashSubjectNoticeList(BaseParam param) throws Exception {
		return bbs2AtclDAO.stdntDashSubjectNoticeList(param);
	}
	@Override
	public List<EgovMap> stdntDashLctrQnaList(BaseParam param) throws Exception {
		return bbs2AtclDAO.stdntDashLctrQnaList(param);
	}
	@Override
	public List<EgovMap> stdntDashDatarmList(BaseParam param) throws Exception {
		return bbs2AtclDAO.stdntDashDatarmList(param);
	}
	
	@Override
	public List<EgovMap> subjectTopNoticeList(BaseParam param) throws Exception {
		return bbs2AtclDAO.subjectTopNoticeList(param);
	}
	@Override
	public List<EgovMap> subjectTopLctrQnaList(BaseParam param) throws Exception {
		return bbs2AtclDAO.subjectTopLctrQnaList(param);
	}
	
	@Override
	public List<EgovMap> profSubjectTopOneOnOneList(BaseParam param) throws Exception {
		return bbs2AtclDAO.profSubjectTopOneOnOneList(param);
	}
	
	@Override
	public List<EgovMap> stdntSubjectTopDatarmList(BaseParam param) throws Exception {
		return bbs2AtclDAO.stdntSubjectTopDatarmList(param);
	}
}