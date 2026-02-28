package knou.lms.common.web;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.security.NoSuchAlgorithmException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.ModelAndView;

import knou.framework.common.CommConst;
import knou.framework.util.CryptoUtil;
import knou.framework.vo.FileVO;
import knou.lms.common.service.SysFileService;

/**
 * 파일에 대한 접근을 담당하는 컨트롤러.
 * 
 * @author SungKook
 */
@Controller
@SessionAttributes("file")
public class FileController
{

    private static final int FILE_NOT_FOUND_IN_PERSIST = -1;

    private static final String FILE_MIMETYPE_VIEW = "fileMimetypeView";

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private SysFileService service;

    /**
     * SysFileVO의 ID를 받아서 Mime타입 view로 전달.
     * 
     * @param fileSn
     *            SysFileVO.fileSn
     * @return 마임타입뷰
     * @throws GeneralSecurityException
     * @throws UnsupportedEncodingException
     * @throws NoSuchAlgorithmException
     * @throws NumberFormatException
     */
    //@RequestMapping("/file/view/{encFileSn}")
    @RequestMapping("/viewFile.do")
    public ModelAndView viewFile(@RequestParam("encFileSn") String encFileSn) throws NumberFormatException, NoSuchAlgorithmException,
            UnsupportedEncodingException, GeneralSecurityException
    {
        String fileSn = CryptoUtil.decryptAes256(encFileSn);
        return sysFileVOToModelAndView(fileSn, FILE_MIMETYPE_VIEW);
    }

    /**
     * SysFileVO의 ID를 받아서 Mime타입 view로 전달. 조회수 증가 없음.
     * 
     * @param fileSn
     *            SysFileVO.fileSn
     * @return 마임타입뷰
     * @throws GeneralSecurityException
     * @throws UnsupportedEncodingException
     * @throws NoSuchAlgorithmException
     * @throws NumberFormatException
     */
    @RequestMapping("/file/view2/{encFileSn}")
    public ModelAndView view2(@PathVariable String encFileSn) throws NumberFormatException, NoSuchAlgorithmException,
            UnsupportedEncodingException, GeneralSecurityException
    {
        String fileSn = CryptoUtil.decryptAes256(encFileSn);
        return sysFileVOToModelAndView(fileSn, FILE_MIMETYPE_VIEW, false);
    }

    /**
     * SysFileVO객체를 구해서 FileDownload,와 FileMimeview에 맞게 ModelAndView를 만들어서 반환.
     */
    private ModelAndView sysFileVOToModelAndView(String fileSn, String viewName)
    {
        return this.sysFileVOToModelAndView(fileSn, viewName, true);
    }

    private ModelAndView sysFileVOToModelAndView(String fileSn, String viewName, boolean isIncrementHits)
    {
        ModelAndView mav = new ModelAndView();
        FileVO sysFileVO = searchSysFileVO(fileSn, isIncrementHits); // download와 view는 조회수를 증가시킨다.

        if (sysFileVO != null)
        {
            String filePath = CommConst.WEBDATA_PATH;
            /* 2016-12-16 arothy */
            if ("contents".equals(sysFileVO.getFileType()))
            {
                filePath = CommConst.CONTENTS_STORAGE_PATH;
            }
            filePath += sysFileVO.getSaveFilePath();
            File file = new File(filePath);
            mav.addObject("downloadFile", file);
            mav.addObject("fileName", sysFileVO.getFileNm());
            mav.addObject("mime-type", sysFileVO.getMimeType());
        }

        mav.setViewName(viewName);
        return mav;
    }

    @SuppressWarnings("serial")
    private FileVO searchSysFileVO(String fileSn, boolean isIncrementHits)
    {

        FileVO fileVO = new FileVO();
        fileVO.setFileSn(fileSn);
        try
        {
            fileVO = service.getFile(fileVO, isIncrementHits);
        }
        catch (Exception e)
        {
            return new FileVO() {
                {
                    setFileSn("-1");
                    setFilePath("/common");
                    setFileSaveNm("noimage.jpg");
                    setMimeType("image/jpeg");
                }
            };
        }
        return fileVO;
    }
}
