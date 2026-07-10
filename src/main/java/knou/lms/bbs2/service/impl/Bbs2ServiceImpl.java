package knou.lms.bbs2.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.bbs2.dao.Bbs2AtclDAO;
import knou.lms.bbs2.service.Bbs2Service;
import knou.lms.common.dto.CommonDTO;
import knou.lms.common.dto.SubjectDTO;

@Service("bbs2Service")
public class Bbs2ServiceImpl extends ServiceBase implements Bbs2Service {

	@Resource(name = "bbs2AtclDAO")

    private Bbs2AtclDAO bbs2AtclDAO;

	@Override
	public EgovMap bbsUnreadCntSelect(SubjectDTO sbjctDto) {
		return bbs2AtclDAO.bbsUnreadCntSelect(sbjctDto);
	}
	@Override
	public List<EgovMap> dashCrsNoticeList(CommonDTO cmmnDto) {
		return bbs2AtclDAO.dashCrsNoticeList(cmmnDto);
	}
	@Override
	public List<EgovMap> profDashAllNoticeList(CommonDTO cmmnDto) {
		return bbs2AtclDAO.profDashAllNoticeList(cmmnDto);
	}
	@Override
	public List<EgovMap> profDashSubjectNoticeList(SubjectDTO sbjctDto) {
		return bbs2AtclDAO.profDashSubjectNoticeList(sbjctDto);
	}
	@Override
	public List<EgovMap> profDashLctrQnaList(CommonDTO cmmnDto) {
		return bbs2AtclDAO.profDashLctrQnaList(cmmnDto);
	}
	@Override
	public List<EgovMap> profDashOneOnOneList(CommonDTO cmmnDto) {
		return bbs2AtclDAO.profDashOneOnOneList(cmmnDto);
	}
    @Override
    public List<EgovMap> admDashSysNoticeList(int limitTop) {
        return bbs2AtclDAO.admDashSysNoticeList(limitTop);
    }
    @Override
    public List<EgovMap> admDashAllNoticeList(int limitTop) {
        return bbs2AtclDAO.admDashAllNoticeList(limitTop);
    }
    @Override
	public List<EgovMap> stdntDashAllNoticeList(CommonDTO cmmnDto) {
		return bbs2AtclDAO.stdntDashAllNoticeList(cmmnDto);
	}
	@Override
	public List<EgovMap> stdntDashSubjectNoticeList(CommonDTO cmmnDto) {
		return bbs2AtclDAO.stdntDashSubjectNoticeList(cmmnDto);
	}
	@Override
	public List<EgovMap> stdntDashLctrQnaList(CommonDTO cmmnDto) {
		return bbs2AtclDAO.stdntDashLctrQnaList(cmmnDto);
	}
	@Override
	public List<EgovMap> stdntDashDatarmList(CommonDTO cmmnDto) {
		return bbs2AtclDAO.stdntDashDatarmList(cmmnDto);
	}

	@Override
	public List<EgovMap> subjectTopNoticeList(CommonDTO cmmnDto) {
		return bbs2AtclDAO.subjectTopNoticeList(cmmnDto);
	}
	@Override
	public List<EgovMap> subjectTopLctrQnaList(CommonDTO cmmnDto) {
		return bbs2AtclDAO.subjectTopLctrQnaList(cmmnDto);
	}

	@Override
	public List<EgovMap> profSubjectTopOneOnOneList(CommonDTO cmmnDto) {
		return bbs2AtclDAO.profSubjectTopOneOnOneList(cmmnDto);
	}

	@Override
	public List<EgovMap> stdntSubjectTopDatarmList(CommonDTO cmmnDto) {
		return bbs2AtclDAO.stdntSubjectTopDatarmList(cmmnDto);
	}
	@Override
	public EgovMap profBbsUnreadCntSelect(SubjectDTO sbjctDto) {
		return bbs2AtclDAO.profBbsUnreadCntSelect(sbjctDto);
	}
}