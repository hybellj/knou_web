package knou.lms.file.service.impl;

import java.io.File;
import java.util.List;

import javax.annotation.Resource;

import org.hsqldb.lib.StringUtil;
import org.springframework.stereotype.Service;

import com.twelvemonkeys.io.FileUtil;

import knou.framework.common.CommConst;
import knou.framework.common.ServiceBase;
import knou.lms.file.dao.AttachFileDAO;
import knou.lms.file.service.AttachFileService;
import knou.lms.file.vo.AtflRepoVO;
import knou.lms.file.vo.AtflVO;

/**
 * 첨부파일 서비스
 */
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
    @Override
    public List<AtflVO> selectAtflListByRefId(AtflVO vo) throws Exception {
    	return attachFileDAO.selectAtflListByRefId(vo);
    }

    /*****************************************************
     * 첨부파일 목록 저장
     * @param List<AtflVO>
     *****************************************************/
    public void insertAtflList(List<AtflVO> fileList) throws Exception {
    	attachFileDAO.insertAtflList(fileList);
    }

	/*****************************************************
     * 첨부파일 삭제 (by AtflIds)
     * @param String[]
     ******************************************************/
    @Override
    public void deleteAtflByAtflIds(String[] atflIds) throws Exception {
    	if(atflIds != null && atflIds.length > 0) {
    		for (String atflId : atflIds) {
    			AtflVO atflVO = new AtflVO();
    			atflVO.setAtflId(atflId);

    			// 파일정보 조회
    			atflVO = attachFileDAO.selectAtfl(atflVO);

    			// 첨부파일 삭제
    			deleteAtfl(atflVO);
    		}
    	}
    }

	/*****************************************************
     * 첨부파일 삭제
     * @param AtflVO
     ******************************************************/
    @Override
    public void deleteAtfl(AtflVO vo) throws Exception {
    	if (vo != null) {
	        // 파일정보 삭제
	        attachFileDAO.deleteAtfl(vo);

	        // 물리파일 삭제(참조파일이 없고, 복사한 원본이 아닌 경우만 삭제)
	        if (vo.getRefAtflCnt() == 0 && StringUtil.isEmpty(vo.getSrcAtflId())) {
	        	String filePath = CommConst.WEBDATA_PATH + vo.getFilePath();
	        	filePath += filePath.endsWith("/") ? vo.getFileSavnm() : "/" + vo.getFileSavnm();

	            File file = new File(filePath);

	            if (file.exists()) {
	            	FileUtil.delete(file);
	            }
	        }
    	}
    }


    /*****************************************************
     * 첨부파일저장소목록조회
     * @return List<AtflRepoVO>
     * @throws Exception
     ******************************************************/
    public List<AtflRepoVO> selectAtflRepoList() throws Exception {
    	return attachFileDAO.selectAtflRepoList();
    }


}
