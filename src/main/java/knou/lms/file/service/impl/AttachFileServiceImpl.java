package knou.lms.file.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.file.dao.AttachFileDAO;
import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflVO;

@Service("attachFileService")
public class AttachFileServiceImpl  extends ServiceBase implements AttachFileService {

    @Resource(name = "attachFileDAO")
    private AttachFileDAO attachFileDAO;


	/*****************************************************
     * 첨부파일조회
     * @param AtflVO
     * @return AtflVO
     * @throws Exception
     ******************************************************/
    @Override
    public AtflVO selectAtfl(AtflVO vo) throws Exception {
    	return attachFileDAO.selectAtfl(vo);
    }

    /*****************************************************
     * 첨부파일목록조회 (by RefId)
     * @param AtflVO
     * @return List<AtflVO>
     * @throws Exception
     ******************************************************/
    public List<AtflVO> selectAtflListByRefId(AtflVO vo) throws Exception {
    	return attachFileDAO.selectAtflListByRefId(vo);
    }

}
