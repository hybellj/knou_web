package knou.lms.org.service;

import java.util.List;

import knou.lms.org.vo.OrgVO;

public interface OrgService {

	public List<OrgVO> orgListSelect() throws Exception;
}