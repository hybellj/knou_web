package knou.lms.log.haksa.dao;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import knou.lms.log.haksa.vo.AisLinkLogVO;

@Mapper("aisLinkLogDAO")
public interface AisLinkLogDAO {

    public String selectAisLinkId(AisLinkLogVO vo);

    public int insertAisLinkLog(AisLinkLogVO vo);
}
