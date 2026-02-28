package knou.lms.api.web;

import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import knou.framework.common.CommConst;
import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.util.*;
import knou.lms.api.service.ApiService;
import knou.lms.api.vo.*;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.crecrs.vo.CreCrsVO;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.dashboard.vo.MainCreCrsVO;
import knou.lms.erp.service.ErpService;
import knou.lms.erp.vo.ErpLcdmsPageVO;
import knou.lms.lesson.vo.LessonCntsVO;
import knou.lms.lesson.vo.LessonPageVO;
import knou.lms.org.service.OrgCodeService;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.annotation.Resource;
import javax.crypto.Cipher;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.security.KeyFactory;
import java.security.PrivateKey;
import java.security.spec.PKCS8EncodedKeySpec;
import java.text.SimpleDateFormat;
import java.util.*;

/***************************************************
 * <pre>
 * 업무 그룹 명 : API
 * 서부 업무 명 : API
 * 설        명 : API 컨트롤러
 * 작   성   자 : mediopia
 * 작   성   일 : 2023. 4. 17
 * Copyright ⓒ MediopiaTec All Right Reserved
 * </pre>
 ***************************************************/

@Controller
@RequestMapping(value = "/api")
public class ApiController extends ControllerBase {

    @Resource(name="orgCodeService")
    private OrgCodeService orgCodeService;

    @Resource(name = "termService")
    private TermService termService;

    @Resource(name="apiService")
    private ApiService apiService;

    @Resource(name="erpService")
    private ErpService erpService;

    // 토큰 복호화 개인키
    private String MSG_PRIKEY = "308204bf020100300d06092a864886f70d0101010500048204a9308204a502010002820101008645e3710c2b2594aabedc69266c19457b6ed8d91ab5241319cc75dcc44eaa941428f7bba0f0dfd11df0cdae8b2646bfdea48102791933d192ef45f115857d250ffc4728a7a8fd0f96b8948fbbf3b0fb679615574c8d761bce9a21ac0ae71424f853ec7948ed2993e63f80d94b1aea7b7f38f610e54ebcd68757e92db784eb67114e14ea86cda996b169f094968461e0e44e562994092250e26de30458945fb6d39f285e78e9fcac67fc5d35177df513aa8f8ce344a20cc79083d67c9558e16e5f86296a46608ee7d2f2d4146579348737567908dc351de531b9ca1d88334f1b6c1b8257485575fec48cfae5adee2dc4b7f7db6ae959e20d92aa08f3d1b6692702030100010282010002c38b83f731282be03bdf839693e10d4a1625068b033183e7230b460910697874d5c70ba8ab6c9ffc52c9990f2a31889f87995438b3e91a2641209a6ecbf9a07aacc1b6378545f83d2cfd79dbef8f340d94cc49a8bcbcb2a3d50e5e61371276145a7de29d3aac816bdae0c71841ac93f03176f7301127d7ee9f43a07a479524d943af0da88d43e647fbdf11f9a957afa4e02169579e40155369ece6d4615ef3cd7599fe552a083cfbcabf15d891212671ddb37b70f8dc85778dba389672a3ec746d1fa974d1d5ca93bf2b4d9e0623f270a53c6c4f5e65117f629332146e5c4a8561aeb343a0c8c1352a0cd41eda994b52fccc4044613edae08739e30ff799b102818100d5a8f31582554b0556844393fa208984d8875ec7a1d965c2b22d1fc370b3205684f6dbb23c6ddd0d796befbe255a37f0dee3e8646a82bf6b75b78c447019f79bad4be2efd6d556293fabf733e468c5edf268fda31e1a503f88c81ae2ab077ef562e73f23218cf9707a1bbeab38a80afb03efc9b43d3c665786a67fcda4f20a6f02818100a0e19bca15f18c024a5bb3dcfc29e6371fbef107ccb07517ad74216d11975d231f8489696840a62a37ad4bc34caa26597242d2c5bd68d6e17fb806fb1a3220d69d6ed32d7cc5bea4daadb571feed85123aee6af93bc9e0d595f40a932d8cd69f8d0e4afe92f1677e2cfaa157eec7b887fd427920412d611eba3409c2319348c902818100d1b21489bab5fd804aae5b28e3a78570a5970eb5bdaa814e39d341c66e58cfd73a7e9196f7ea17b73ec169b5e4310c905221ba96bb56818a752964f852519a0be76480614627717de068e5a0bf7ef92b94ebe86b6c8304d9a66446c6ca76fbead85bff427a8e42ce5a79da836f82b5ec30abe9fa04d3bfda0d646230b1bf7fef028181008f49a13991e5baaf678ed9595ef5ea66fa4d53db80814128bf82092b5d5994c86d8fdbdb17d14cad993d2d975a36c9452d313b0c873053023080b526fc23dd7f8864668dc2ed5468fba36f51829e05c140df8c4342ef00e2fa558afd9eba2b859b5a398d174f0ec0204b715c21fd9beaf2b43bb1709b7c3ea3d52943de67b19102818100bc6585f4d53cc22af119e164b75f501c1b3452a3a150d8402cac5e095e21d90c2837813bfc8141cb1b2eb2e761f732dc49679ee3dcced5c8ec9338b7be9b92938e7d39b65dd23f3026a6ae76a681dc8db74cf9d79b6ce6a6707b846ca62d84b72caeb41d8a7499bc6d36dadda62c6a946d0296233304a64102fde09a867688d5";
    private String API_ORG_ID = "ORG0000001";
    
    public static byte[] hexToByteArray(String hex) {

        if(hex == null || hex.length() % 2 != 0) { 
            return new byte[] {}; 
        }

        byte[] bytes = new byte[hex.length() / 2];
        for(int i = 0; i < hex.length(); i += 2) {
            byte value = (byte) Integer.parseInt(hex.substring(i, i + 2), 16);
            bytes[(int) Math.floor(i / 2)] = value;
        }
        return bytes;
    }

    /**
     * 콘텐츠 ZIP 파일 업로드 폼
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/zipContentUploadForm.do")
    public String zipContentUploadForm(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        try {

            String params = StringUtil.nvl(request.getParameter("params"));
            params = decryptToken(params);

            Map<String, Object> paramMap = JsonUtil.getJsonObject(params);
            String p_curri_code = StringUtil.nvl((String) paramMap.get("p_curri_code"));
            String p_week = StringUtil.nvl((String) paramMap.get("p_week"), "01");
            String p_seq = StringUtil.nvl((String) paramMap.get("p_seq"), "0");
            String userId = StringUtil.nvl((String) paramMap.get("UserId"));
            String tokDate = StringUtil.nvl((String) paramMap.get("date"));
            String type = StringUtil.nvl((String) paramMap.get("type"), "upload");

            Date curDate = new Date();
            Date tokenDate = (new SimpleDateFormat("yyyyMMddHHmmss")).parse(tokDate);

            // 토큰 생성시간 체크 (5분)
            if((curDate.getTime() - tokenDate.getTime()) > 300000) {
                model.addAttribute("basePath", "");
            }
            else {

                if(!"".equals(p_curri_code) && !"".equals(p_week) && !"".equals(userId)) {
                    String basePath = "/" + p_curri_code.substring(0,2) + "/" + p_curri_code + "/contents/" + (p_week.length() < 2 ? "0"+p_week : p_week) + "/";
                    String uploadPath = basePath;

                    if(!"0".equals(p_seq)) {
                        if(p_seq.length() < 2) p_seq = "0"+p_seq;
                        uploadPath += p_seq + "/";
                    }
        
                    model.addAttribute("basePath", basePath);
                    model.addAttribute("uploadPath", uploadPath);
                    model.addAttribute("p_seq", p_seq);
                    model.addAttribute("userId", new String(Base64.getEncoder().encode(userId.getBytes())));
                    model.addAttribute("type", type);
                }
                else {
                    model.addAttribute("basePath", "");
                }
            }
        }
        catch(Exception e) {
            model.addAttribute("basePath", "");
        }
        return "api/zipfile_upload_form";
    }

    /**
     * 콘텐츠 ZIP 파일 업로드
     * @param multiRequest
     * @param request
     * @param response
     * @param modelMap
     * @return
     */
    @RequestMapping(value="/zipContentUpload.do")
    public void zipContentUpload(MultipartHttpServletRequest multiRequest, HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) {

        String uploadPath = "";
        try {

            String userId = StringUtil.nvl(request.getParameter("pId"));
            String path = StringUtil.nvl(request.getParameter("path"));
            String dataPath = CommConst.WEBDATA_PATH;

            userId = new String(Base64.getDecoder().decode(userId));

            if(!dataPath.equals("") && (dataPath.substring(dataPath.length()-1).equals("/") 
                || dataPath.substring(dataPath.length()-1).equals("\\") )) {

                dataPath = dataPath.substring(0, dataPath.length()-1);
            }

            path = path.replace("/\\/g", "/");
            if(!path.equals("") && !path.substring(0,1).equals("/")) {
                path = "/"+path;
            }

            if(!path.equals("") && !path.substring(path.length()-1).equals("/")) {
                path += "/";
            }

            uploadPath   = dataPath + "/hycuso" + path;
            final Map<String, MultipartFile> fileMap = multiRequest.getFileMap();
            long uploadSize = 0;
            String fileNm = "";

            if(!fileMap.isEmpty()) {
                File upPath = new File(uploadPath);

                if(upPath.exists()) {
                	// 기존폴더 삭제하지 않는것으로 변경
                    //FileUtil.delDirectory(uploadPath);
                }

                Object[] keys = fileMap.keySet().toArray();
                MultipartFile multiFile = fileMap.get(keys[0]);
                fileNm = multiFile.getOriginalFilename();
                uploadSize = multiFile.getSize();

                FileUtil.setDirectory(uploadPath);
                File saveFile = new File(uploadPath, fileNm);
                multiFile.transferTo(saveFile);

                ZipUtil zipUtil = new ZipUtil();
                zipUtil.unzip(saveFile);
                
                // 압축푼 후 파일 삭제
                saveFile.delete();
            }

            String params[] = path.substring(1).split("/");
            String week = Integer.parseInt(params[params.length-2])+"";
            String pageSeq = Integer.parseInt(params[params.length-1])+"";

            ZipcontentUploadVO uploadVO = new ZipcontentUploadVO();
            uploadVO.setZipcontentLogSn(IdGenerator.getNewId("ZPUP"));
            uploadVO.setRgtrId(userId);
            uploadVO.setCurriCode(params[1]);
            uploadVO.setWeek(week);
            uploadVO.setPageSeq(pageSeq);
            uploadVO.setUploadSize(uploadSize);
            uploadVO.setUploadPath(path);
            uploadVO.setUploadFileNm(fileNm);

            // 로그기록
            apiService.insertZipcontUploadLog(uploadVO);
        }
        catch(Exception e) {
            //FileUtil.delDirectory(uploadPath);
            e.printStackTrace();
        }
    }

    /**
     * 콘텐츠 ZIP 파일 업로드 처리결과 체크
     * @param multiRequest
     * @param request
     * @param response
     * @param modelMap
     * @return
     */
    @RequestMapping(value="/zipContentUploadCheck.do")
    @ResponseBody
    public String zipContentUploadCheck(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) {

        Map<String, Object> result = new HashMap<>();

        try {
            String dataPath = CommConst.WEBDATA_PATH;

            if(!dataPath.equals("") && (dataPath.substring(dataPath.length()-1).equals("/") || dataPath.substring(dataPath.length()-1).equals("\\") )) {
                dataPath = dataPath.substring(0, dataPath.length()-1);
            }
            String uploadPath =  dataPath + "/hycuso" + StringUtil.nvl((String)request.getParameter("uploadPath"));

            File chkFile = new File(uploadPath);
            if(chkFile.exists()) {
                result.put("result", "1");
            }
            else {
                result.put("result", "-1");
            }
        }
        catch(Exception e) {
            result.put("result", "-1");
        }
        return JsonUtil.responseJson(response, result);
    }
    
    /**
     * 콘텐츠 ZIP 파일 다운로드 체크
     * @param request
     * @param response
     * @param modelMap
     * @return
     */
    @RequestMapping(value="/zipContentDownloadCheck.do")
    @ResponseBody
    public String zipContentDownloadCheck(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) {

        Map<String, Object> result = new HashMap<>();

        try {
            String dataPath = CommConst.WEBDATA_PATH;

            if(!dataPath.equals("") && (dataPath.substring(dataPath.length()-1).equals("/") || dataPath.substring(dataPath.length()-1).equals("\\") )) {
                dataPath = dataPath.substring(0, dataPath.length()-1);
            }
            String downloadPath =  dataPath + "/hycuso" + StringUtil.nvl((String)request.getParameter("downloadPath"));

            File chkFile = new File(downloadPath);
            if(chkFile.exists() && chkFile.isDirectory()) {
                result.put("result", "1");
            }
            else {
                result.put("result", "-1");
            }
        }
        catch(Exception e) {
            result.put("result", "-1");
        }
        return JsonUtil.responseJson(response, result);
    }
    
    /**
     * 콘텐츠 ZIP 파일 다운로드
     * @param request
     * @param response
     * @param modelMap
     * @return
     */
    @RequestMapping(value="/zipContentDownload.do")
    @ResponseBody
    public void zipContentDownload(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) {

        Map<String, Object> result = new HashMap<>();
        ServletOutputStream binaryOut = null;
        
        try {
            String dataPath = CommConst.WEBDATA_PATH;
            String downloadPath = StringUtil.nvl((String)request.getParameter("downloadPath"));
            String name = downloadPath.replace("/", "_");
            if ("_".equals(name.substring(0,1))) {
            	name = name.substring(1);
            }
            if ("_".equals(name.substring(name.length()-1))) {
            	name = name.substring(0,name.length()-1);
            }
            name += ".zip";
            
            if(!dataPath.equals("") && (dataPath.substring(dataPath.length()-1).equals("/") || dataPath.substring(dataPath.length()-1).equals("\\") )) {
                dataPath = dataPath.substring(0, dataPath.length()-1);
            }
            downloadPath =  dataPath + "/hycuso" + downloadPath;
            
            File file = new File(downloadPath);
            
            if (file.exists() && file.isDirectory()) {
            	File files[] = file.listFiles();
            	String fname = null;
            	for (int i=0; i<files.length; i++) {
            		fname = files[i].getName();
            		if (files[i].isFile() &&  fname.length() > 4 && ".zip".equals(fname.substring(fname.length()-4))) {
            			files[i].delete();
            		}
            	}
            	
	            response.setHeader("Content-Type", "application/octet-stream");
	            response.setHeader("Content-Transfer-Coding", "binary");
	            response.setHeader("Pragma", "no-cache;");
	            response.setHeader("Expires", "-1;");
	            response.setHeader("Content-Disposition", "attachment; filename=\""+ java.net.URLEncoder.encode(name, "UTF-8").replaceAll("\\+", "%20") + "\";charset=\"UTF-8\"");
	            
	            binaryOut = response.getOutputStream();
	            ZipUtil zipUtil = new ZipUtil();
	            zipUtil.zip(file, binaryOut);
	            
	            binaryOut.flush();
	            binaryOut.close();
            }            
        }
        catch(Exception e) {
            result.put("result", "-1");
        }
        finally {
        	if (binaryOut != null) {
        		try {
					binaryOut.flush();
					binaryOut.close();
				} catch (IOException e) {
					System.out.println("오류...............");
				}
        	}
        }
    }
    
        
    /**
     * *************************************************** 
     * 토큰값 복호화
     * @param securedValue
     * @return
     * @throws Exception
     *****************************************************
     */
    @SuppressWarnings("unused")
    private String decryptToken(String securedValue) throws Exception {

        String decryptedValue = "";

        try {
            String pkey = MSG_PRIKEY;
            byte[] keyBytes1 = new byte[pkey.length() / 2];
            
            byte[] keyBytes = new byte[MSG_PRIKEY.length() / 2];
            for(int i = 0; i < MSG_PRIKEY.length(); i += 2) {
                keyBytes[(int) Math.floor(i / 2)] = (byte)Integer.parseInt(MSG_PRIKEY.substring(i, i + 2), 16);
            }

            PKCS8EncodedKeySpec keySpec = new PKCS8EncodedKeySpec(keyBytes);
            PrivateKey privateKey = (KeyFactory.getInstance("RSA")).generatePrivate(keySpec);
            
            Cipher cipher = Cipher.getInstance("RSA");
            cipher.init(Cipher.DECRYPT_MODE, privateKey);

            byte[] valBytes = new byte[securedValue.length() / 2];
            for(int i = 0; i < securedValue.length(); i += 2) {
                byte value = (byte)Integer.parseInt(securedValue.substring(i, i + 2), 16);
                valBytes[(int) Math.floor(i / 2)] = value;
            }
            decryptedValue = new String(cipher.doFinal(valBytes), "utf-8");
        }
        catch(Exception e) {
            e.printStackTrace();
        }
        return decryptedValue;
    }

    /**
     * 학생들이 강의알림 건수
     * 1. 강의공지 읽지않은 건수 : NOTICE
     * 2. Q&A 읽지 않은 건수 : QNA
     * 3. 1:1 상담 읽지않은 건수 : SECRET
     * 4. 과제 미제출 건수
     * 5. 토론 미제출 건수
     * 6. 퀴즈 미제출 건수
     * 7. 설문 미제출 건수
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/countStuLessonAlarm.do")
    public String countStuLessonAlarm(ApiCountInfoVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String resultStr = "";
        ProcessResultVO<ApiCountInfoVO> resultVo = new ProcessResultVO<ApiCountInfoVO>();

        try {

            String token = StringUtil.nvl(vo.getToken());
            boolean validToken = true;

            // 토큰 유효성 체크
            if("".equals(token)) {
                validToken = false;
                resultVo.setResult(-4);
                resultVo.setMessage("토큰이 없습니다. 생성 후에 실행해 주세요.");
            }
            else {
                String decToken[] = decryptToken(token).split(",");
                String tokUserId = decToken.length > 2 ? decToken[1] : decToken[0];
                String tokDate = decToken.length > 2 ? decToken[2] : decToken[1];

                Date curDate = new Date();
                Date tokenDate = (new SimpleDateFormat("yyyyMMddHHmmss")).parse(tokDate);

                if(!StringUtil.nvl(vo.getUserId()).equals(tokUserId)) {
                    // userId 체크
                    validToken = false;
                    resultVo.setResult(-3);
                    resultVo.setMessage("사용자번호가 틀립니다. 다시 확인하시기 바랍니다.");
                }
                else if((curDate.getTime() - tokenDate.getTime()) > 300000) {
                    // 토큰 생성시간 체크(5분) 
                    validToken = false;
                    resultVo.setResult(-2);
                    resultVo.setMessage("토큰이 만료 되었습니다. 다시 생성 하시기 바랍니다.");
                }
            }

            if(!validToken) {
                return JsonUtil.responseJson(response, resultVo);
            }
            vo.setOrgId(API_ORG_ID);
            resultVo = apiService.selectStuCountInfo(vo);
        }
        catch(Exception e) {
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVo.setReturnVO(vo);
        }
        resultStr = JsonUtil.responseJson(response, resultVo);

        return resultStr;
    }

    /**
     * 교수들 강의 알림 건수
     * 1. 담당과목의 Q&A 미답변 건수
     * 2. 담당과목의 1:1 상담 미답변 건수
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/countProfLessonAlarm.do")
    public String countProfLessonAlarm(ApiCountInfoVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String resultStr = "";
        ProcessResultVO<ApiCountInfoVO> resultVo = new ProcessResultVO<ApiCountInfoVO>();

        try {
            String token = StringUtil.nvl(vo.getToken());
            boolean validToken = true; 

            // 토큰 유효성 체크
            if("".equals(token)) {
                validToken = false;
                resultVo.setResult(-4);
                resultVo.setMessage("토큰이 없습니다. 생성 후에 실행해 주세요.");
            }
            else {
                String decToken[] = decryptToken(token).split(",");
                String tokUserId = decToken.length > 2 ? decToken[1] : decToken[0];
                String tokDate = decToken.length > 2 ? decToken[2] : decToken[1];

                Date curDate = new Date();
                Date tokenDate = (new SimpleDateFormat("yyyyMMddHHmmss")).parse(tokDate);

                // userId 체크
                if(!StringUtil.nvl(vo.getUserId()).equals(tokUserId)) {
                    validToken = false;
                    resultVo.setResult(-3);
                    resultVo.setMessage("사용자번호가 틀립니다. 다시 확인하시기 바랍니다.");
                }
                // 토큰 생성시간 체크(5분) 
                else if((curDate.getTime() - tokenDate.getTime()) > 300000) {
                    validToken = false;
                    resultVo.setResult(-2);
                    resultVo.setMessage("토큰이 만료 되었습니다.. 다시 생성 하시기 바랍니다.");
                }
            }

            if(!validToken) {
                return JsonUtil.responseJson(response, resultVo);
            }
            vo.setOrgId(API_ORG_ID);
            resultVo = apiService.selectProfCountInfo(vo);
        }
        catch(Exception e) {
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVo.setReturnVO(vo);
        }
        resultStr = JsonUtil.responseJson(response, resultVo);

        return resultStr;
    }

    /**
     * 신청받은 결시원 개수
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/countProfExamAbsentRequest.do")
    public String countProfExamAbsentRequest(ApiCountInfoVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String resultStr = "";
        ProcessResultVO<ApiCountInfoVO> resultVo = new ProcessResultVO<ApiCountInfoVO>();

        try {

            String token = StringUtil.nvl(vo.getToken());
            boolean validToken = true; 

            // 토큰 유효성 체크
            if("".equals(token)) {
                validToken = false;
                resultVo.setResult(-4);
                resultVo.setMessage("토큰이 없습니다. 생성 후에 실행해 주세요.");
            }
            else {
                String decToken[] = decryptToken(token).split(",");
                String tokUserId = decToken.length > 2 ? decToken[1] : decToken[0];
                String tokDate = decToken.length > 2 ? decToken[2] : decToken[1];

                Date curDate = new Date();
                Date tokenDate = (new SimpleDateFormat("yyyyMMddHHmmss")).parse(tokDate);

                // userId 체크
                if(!StringUtil.nvl(vo.getUserId()).equals(tokUserId)) {
                    validToken = false;
                    resultVo.setResult(-3);
                    resultVo.setMessage("사용자번호가 틀립니다. 다시 확인하시기 바랍니다.");
                }
                // 토큰 생성시간 체크(5분) 
                else if((curDate.getTime() - tokenDate.getTime()) > 300000) {
                    validToken = false;
                    resultVo.setResult(-2);
                    resultVo.setMessage("토큰이 만료 되었습니다.. 다시 생성 하시기 바랍니다.");
                }
            }

            if(!validToken) {
                return JsonUtil.responseJson(response, resultVo);
            }
            vo.setOrgId(API_ORG_ID);
            resultVo = apiService.selectProfExamAbsentRequestCountInfo(vo);

        }
        catch(Exception e) {
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVo.setReturnVO(vo);
        }
        resultStr = JsonUtil.responseJson(response, resultVo);

        return resultStr;
    }

    /**
     * 신청받은 성적재확인 개수
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/countProfScoreObjtRequest.do")
    public String countProfScoreObjtRequest(ApiCountInfoVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String resultStr = "";
        ProcessResultVO<ApiCountInfoVO> resultVo = new ProcessResultVO<ApiCountInfoVO>();

        try {

            String token = StringUtil.nvl(vo.getToken());
            boolean validToken = true; 

            // 토큰 유효성 체크
            if("".equals(token)) {
                validToken = false;
                resultVo.setResult(-4);
                resultVo.setMessage("토큰이 없습니다. 생성 후에 실행해 주세요.");
            }
            else {
                String decToken[] = decryptToken(token).split(",");
                String tokUserId = decToken.length > 2 ? decToken[1] : decToken[0];
                String tokDate = decToken.length > 2 ? decToken[2] : decToken[1];

                Date curDate = new Date();
                Date tokenDate = (new SimpleDateFormat("yyyyMMddHHmmss")).parse(tokDate);

                // userId 체크
                if(!StringUtil.nvl(vo.getUserId()).equals(tokUserId)) {
                    validToken = false;
                    resultVo.setResult(-3);
                    resultVo.setMessage("사용자번호가 틀립니다. 다시 확인하시기 바랍니다.");
                }
                // 토큰 생성시간 체크(5분) 
                else if((curDate.getTime() - tokenDate.getTime()) > 300000) {
                    validToken = false;
                    resultVo.setResult(-2);
                    resultVo.setMessage("토큰이 만료 되었습니다.. 다시 생성 하시기 바랍니다.");
                }
            }

            if(!validToken) {
                return JsonUtil.responseJson(response, resultVo);
            }
            vo.setOrgId(API_ORG_ID);
            resultVo = apiService.selectProfScoreObjtRequestCountInfo(vo);

        }
        catch(Exception e) {
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVo.setReturnVO(vo);
        }

        resultStr = JsonUtil.responseJson(response, resultVo);

        return resultStr;
    }

    /**
     * 장애인 지원신청 건수
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/countDisabledPersonRequest.do")
    public String countDisabledPersonRequest(ApiCountInfoVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String resultStr = "";
        ProcessResultVO<ApiCountInfoVO> resultVo = new ProcessResultVO<ApiCountInfoVO>();

        try {

            String token = StringUtil.nvl(vo.getToken());
            boolean validToken = true; 

            // 토큰 유효성 체크
            if("".equals(token)) {
                validToken = false;
                resultVo.setResult(-4);
                resultVo.setMessage("토큰이 없습니다. 생성 후에 실행해 주세요.");
            }
            else {
                String decToken[] = decryptToken(token).split(",");
                String tokUserId = decToken.length > 2 ? decToken[1] : decToken[0];
                String tokDate = decToken.length > 2 ? decToken[2] : decToken[1];

                Date curDate = new Date();
                Date tokenDate = (new SimpleDateFormat("yyyyMMddHHmmss")).parse(tokDate);

                // userId 체크
                if(!StringUtil.nvl(vo.getUserId()).equals(tokUserId)) {
                    validToken = false;
                    resultVo.setResult(-3);
                    resultVo.setMessage("사용자번호가 틀립니다. 다시 확인하시기 바랍니다.");
                }
                // 토큰 생성시간 체크(5분) 
                else if((curDate.getTime() - tokenDate.getTime()) > 300000) {
                    validToken = false;
                    resultVo.setResult(-2);
                    resultVo.setMessage("토큰이 만료 되었습니다.. 다시 생성 하시기 바랍니다.");
                }
            }

            if(!validToken) {
                return JsonUtil.responseJson(response, resultVo);
            }
            vo.setOrgId(API_ORG_ID);
            resultVo = apiService.selectDisabledPersonRequestCountInfo(vo);

        }
        catch(Exception e) {
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVo.setReturnVO(vo);
        }
        resultStr = JsonUtil.responseJson(response, resultVo);

        return resultStr;
    }

    /**
     * 강의실 전체 공지사항 내역
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/wholeNoticeLessionList.do")
    public String wholeNoticeLessionList(ApiListInfoVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String resultStr = "";
        ProcessResultVO<ApiListInfoVO> resultVo = new ProcessResultVO<ApiListInfoVO>();

        try {

            String token = StringUtil.nvl(vo.getToken());
            boolean validToken = true; 

            // 토큰 유효성 체크
            if("".equals(token)) {
                validToken = false;
                resultVo.setResult(-4);
                resultVo.setMessage("토큰이 없습니다. 생성 후에 실행해 주세요.");
            }
            else {
                String decToken[] = decryptToken(token).split(",");
                String tokUserId = decToken.length > 2 ? decToken[1] : decToken[0];
                String tokDate = decToken.length > 2 ? decToken[2] : decToken[1];

                Date curDate = new Date();
                Date tokenDate = (new SimpleDateFormat("yyyyMMddHHmmss")).parse(tokDate);

                // userId 체크
                if(!StringUtil.nvl(vo.getUserId()).equals(tokUserId)) {
                    validToken = false;
                    resultVo.setResult(-3);
                    resultVo.setMessage("사용자번호가 틀립니다. 다시 확인하시기 바랍니다.");
                }
                // 토큰 생성시간 체크(5분) 
                else if((curDate.getTime() - tokenDate.getTime()) > 300000) {
                    validToken = false;
                    resultVo.setResult(-2);
                    resultVo.setMessage("토큰이 만료 되었습니다.. 다시 생성 하시기 바랍니다.");
                }
            }

            if(!validToken) {
                return JsonUtil.responseJson(response, resultVo);
            }

            // 접속 URL
            vo.setDomainUrl(CommConst.PRODUCT_DOMAIN);

            // 전체 공지사항 게시판ID
            vo.setBbsId("BBS_210512T1934377924186");

            resultVo = apiService.selectAllNoticeList(vo);
        }
        catch(Exception e) {
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVo.setReturnVO(vo);
        }
        resultStr = JsonUtil.responseJson(response, resultVo);

        return resultStr;
    }

    /**
     * 학생 과목 공지사항 내역
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/selectStuLessonNoticeList.do")
    public String selectStuLessonNoticeList(ApiListInfoVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String resultStr = "";
        ProcessResultVO<ApiListInfoVO> resultVo = new ProcessResultVO<ApiListInfoVO>();

        try {

            String token = StringUtil.nvl(vo.getToken());
            boolean validToken = true; 

            // 토큰 유효성 체크
            if("".equals(token)) {
                validToken = false;
                resultVo.setResult(-4);
                resultVo.setMessage("토큰이 없습니다. 생성 후에 실행해 주세요.");
            }
            else {
                String decToken[] = decryptToken(token).split(",");
                String tokUserId = decToken.length > 2 ? decToken[1] : decToken[0];
                String tokDate = decToken.length > 2 ? decToken[2] : decToken[1];

                Date curDate = new Date();
                Date tokenDate = (new SimpleDateFormat("yyyyMMddHHmmss")).parse(tokDate);

                // userId 체크
                if(!StringUtil.nvl(vo.getUserId()).equals(tokUserId)) {
                    validToken = false;
                    resultVo.setResult(-3);
                    resultVo.setMessage("사용자번호가 틀립니다. 다시 확인하시기 바랍니다.");
                }
                // 토큰 생성시간 체크(5분) 
                else if((curDate.getTime() - tokenDate.getTime()) > 300000) {
                    validToken = false;
                    resultVo.setResult(-2);
                    resultVo.setMessage("토큰이 만료 되었습니다.. 다시 생성 하시기 바랍니다.");
                }
            }

            if(!validToken) {
                return JsonUtil.responseJson(response, resultVo);
            }
            vo.setOrgId(API_ORG_ID);
            resultVo = apiService.selectStuLessonNoticeList(vo);
        }
        catch(Exception e) {
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVo.setReturnVO(vo);
        }
        resultStr = JsonUtil.responseJson(response, resultVo);

        return resultStr;
    }

    /**
     * 학생 과목 QNA 내역
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/selectStuLessonQnaList.do")
    public String selectStuLessonQnaList(ApiListInfoVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String resultStr = "";
        ProcessResultVO<ApiListInfoVO> resultVo = new ProcessResultVO<ApiListInfoVO>();

        try {

            String token = StringUtil.nvl(vo.getToken());
            boolean validToken = true; 

            // 토큰 유효성 체크
            if("".equals(token)) {
                validToken = false;
                resultVo.setResult(-4);
                resultVo.setMessage("토큰이 없습니다. 생성 후에 실행해 주세요.");
            }
            else {
                String decToken[] = decryptToken(token).split(",");
                String tokUserId = decToken.length > 2 ? decToken[1] : decToken[0];
                String tokDate = decToken.length > 2 ? decToken[2] : decToken[1];

                Date curDate = new Date();
                Date tokenDate = (new SimpleDateFormat("yyyyMMddHHmmss")).parse(tokDate);

                // userId 체크
                if(!StringUtil.nvl(vo.getUserId()).equals(tokUserId)) {
                    validToken = false;
                    resultVo.setResult(-3);
                    resultVo.setMessage("사용자번호가 틀립니다. 다시 확인하시기 바랍니다.");
                }
                // 토큰 생성시간 체크(5분) 
                else if((curDate.getTime() - tokenDate.getTime()) > 300000) {
                    validToken = false;
                    resultVo.setResult(-2);
                    resultVo.setMessage("토큰이 만료 되었습니다.. 다시 생성 하시기 바랍니다.");
                }
            }

            if(!validToken) {
                return JsonUtil.responseJson(response, resultVo);
            }
            vo.setOrgId(API_ORG_ID);
            resultVo = apiService.selectStuLessonQnaList(vo);
        }
        catch(Exception e) {
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVo.setReturnVO(vo);
        }
        resultStr = JsonUtil.responseJson(response, resultVo);

        return resultStr;
    }

    /**
     * 교수 과목 공지사항 내역
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/selectProfLessonNoticeList.do")
    public String selectProfLessonNoticeList(ApiListInfoVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String resultStr = "";
        ProcessResultVO<ApiListInfoVO> resultVo = new ProcessResultVO<ApiListInfoVO>();

        try {

            String token = StringUtil.nvl(vo.getToken());
            boolean validToken = true; 

            // 토큰 유효성 체크
            if("".equals(token)) {
                validToken = false;
                resultVo.setResult(-4);
                resultVo.setMessage("토큰이 없습니다. 생성 후에 실행해 주세요.");
            }
            else {
                String decToken[] = decryptToken(token).split(",");
                String tokUserId = decToken.length > 2 ? decToken[1] : decToken[0];
                String tokDate = decToken.length > 2 ? decToken[2] : decToken[1];

                Date curDate = new Date();
                Date tokenDate = (new SimpleDateFormat("yyyyMMddHHmmss")).parse(tokDate);

                // userId 체크
                if(!StringUtil.nvl(vo.getUserId()).equals(tokUserId)) {
                    validToken = false;
                    resultVo.setResult(-3);
                    resultVo.setMessage("사용자번호가 틀립니다. 다시 확인하시기 바랍니다.");
                }
                // 토큰 생성시간 체크(5분) 
                else if((curDate.getTime() - tokenDate.getTime()) > 300000) {
                    validToken = false;
                    resultVo.setResult(-2);
                    resultVo.setMessage("토큰이 만료 되었습니다.. 다시 생성 하시기 바랍니다.");
                }
            }

            if(!validToken) {
                return JsonUtil.responseJson(response, resultVo);
            }
            vo.setOrgId(API_ORG_ID);
            resultVo = apiService.selectProfLessonNoticeList(vo);
        }
        catch(Exception e) {
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVo.setReturnVO(vo);
        }
        resultStr = JsonUtil.responseJson(response, resultVo);

        return resultStr;
    }

    /**
     * 조교, 교수 과목 QNA 내역
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/selectProfLessonQnaList.do")
    public String selectProfLessonQnaList(ApiListInfoVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String resultStr = "";
        ProcessResultVO<ApiListInfoVO> resultVo = new ProcessResultVO<ApiListInfoVO>();

        try {

            String token = StringUtil.nvl(vo.getToken());
            boolean validToken = true; 

            // 토큰 유효성 체크
            if("".equals(token)) {
                validToken = false;
                resultVo.setResult(-4);
                resultVo.setMessage("토큰이 없습니다. 생성 후에 실행해 주세요.");
            }
            else {
                String decToken[] = decryptToken(token).split(",");
                String tokUserId = decToken.length > 2 ? decToken[1] : decToken[0];
                String tokDate = decToken.length > 2 ? decToken[2] : decToken[1];

                Date curDate = new Date();
                Date tokenDate = (new SimpleDateFormat("yyyyMMddHHmmss")).parse(tokDate);

                // userId 체크
                if(!StringUtil.nvl(vo.getUserId()).equals(tokUserId)) {
                    validToken = false;
                    resultVo.setResult(-3);
                    resultVo.setMessage("사용자번호가 틀립니다. 다시 확인하시기 바랍니다.");
                }
                // 토큰 생성시간 체크(5분) 
                else if((curDate.getTime() - tokenDate.getTime()) > 300000) {
                    validToken = false;
                    resultVo.setResult(-2);
                    resultVo.setMessage("토큰이 만료 되었습니다.. 다시 생성 하시기 바랍니다.");
                }
            }

            if(!validToken) {
                return JsonUtil.responseJson(response, resultVo);
            }
            vo.setOrgId(API_ORG_ID);
            resultVo = apiService.selectProfLessonQnaList(vo);
        }
        catch(Exception e) {
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVo.setReturnVO(vo);
        }
        resultStr = JsonUtil.responseJson(response, resultVo);

        return resultStr;
    }

    /**
     * 직원 과목 QNA 내역
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/selectStaffLessonQnaList.do")
    public String selectStaffLessonQnaList(ApiListInfoVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String resultStr = "";
        ProcessResultVO<ApiListInfoVO> resultVo = new ProcessResultVO<ApiListInfoVO>();

        try {

            String token = StringUtil.nvl(vo.getToken());
            boolean validToken = true; 

            // 토큰 유효성 체크
            if("".equals(token)) {
                validToken = false;
                resultVo.setResult(-4);
                resultVo.setMessage("토큰이 없습니다. 생성 후에 실행해 주세요.");
            }
            else {
                String decToken[] = decryptToken(token).split(",");
                String tokUserId = decToken.length > 2 ? decToken[1] : decToken[0];
                String tokDate = decToken.length > 2 ? decToken[2] : decToken[1];

                Date curDate = new Date();
                Date tokenDate = (new SimpleDateFormat("yyyyMMddHHmmss")).parse(tokDate);

                // userId 체크
                if(!StringUtil.nvl(vo.getUserId()).equals(tokUserId)) {
                    validToken = false;
                    resultVo.setResult(-3);
                    resultVo.setMessage("사용자번호가 틀립니다. 다시 확인하시기 바랍니다.");
                }
                // 토큰 생성시간 체크(5분) 
                else if((curDate.getTime() - tokenDate.getTime()) > 300000) {
                    validToken = false;
                    resultVo.setResult(-2);
                    resultVo.setMessage("토큰이 만료 되었습니다.. 다시 생성 하시기 바랍니다.");
                }
            }

            if(!validToken) {
                return JsonUtil.responseJson(response, resultVo);
            }
            vo.setOrgId(API_ORG_ID);
            resultVo = apiService.selectStaffLessonQnaList(vo);
        }
        catch(Exception e) {
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVo.setReturnVO(vo);
        }
        resultStr = JsonUtil.responseJson(response, resultVo);

        return resultStr;
    }

    /**
     * 실시간 세미나 내역
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/selectRealSeminarList.do")
    public String selectRealSeminarList(ApiListInfoVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String resultStr = "";
        ProcessResultVO<ApiListInfoVO> resultVo = new ProcessResultVO<ApiListInfoVO>();

        try {

            String token = StringUtil.nvl(vo.getToken());
            boolean validToken = true; 

            // 토큰 유효성 체크
            if("".equals(token)) {
                validToken = false;
                resultVo.setResult(-4);
                resultVo.setMessage("토큰이 없습니다. 생성 후에 실행해 주세요.");
            }
            else {
                String decToken[] = decryptToken(token).split(",");
                String tokUserId = decToken.length > 2 ? decToken[1] : decToken[0];
                String tokDate = decToken.length > 2 ? decToken[2] : decToken[1];

                Date curDate = new Date();
                Date tokenDate = (new SimpleDateFormat("yyyyMMddHHmmss")).parse(tokDate);

                // userId 체크
                if(!StringUtil.nvl(vo.getUserId()).equals(tokUserId)) {
                    validToken = false;
                    resultVo.setResult(-3);
                    resultVo.setMessage("사용자번호가 틀립니다. 다시 확인하시기 바랍니다.");
                }
                // 토큰 생성시간 체크(5분) 
                else if((curDate.getTime() - tokenDate.getTime()) > 300000) {
                    validToken = false;
                    resultVo.setResult(-2);
                    resultVo.setMessage("토큰이 만료 되었습니다.. 다시 생성 하시기 바랍니다.");
                }
            }

            if(!validToken) {
                return JsonUtil.responseJson(response, resultVo);
            }
            vo.setOrgId(API_ORG_ID);
            resultVo = apiService.selectRealSeminarList(vo);
        }
        catch(Exception e) {
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVo.setReturnVO(vo);
        }
        resultStr = JsonUtil.responseJson(response, resultVo);

        return resultStr;
    }

    /**
     * 학생 학습 진도율 조회
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/selectStdProgressRatio.do")
    public String selectStdProgressRatio(ApiListInfoVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String resultStr = "";
        ProcessResultVO<ApiListInfoVO> resultVo = new ProcessResultVO<ApiListInfoVO>();

        try {

            String token = StringUtil.nvl(vo.getToken());
            boolean validToken = true; 

            // 토큰 유효성 체크
            if("".equals(token)) {
                validToken = false;
                resultVo.setResult(-4);
                resultVo.setMessage("토큰이 없습니다. 생성 후에 실행해 주세요.");
            }
            else {
                String decToken[] = decryptToken(token).split(",");
                String tokUserId = decToken.length > 2 ? decToken[1] : decToken[0];
                String tokDate = decToken.length > 2 ? decToken[2] : decToken[1];

                Date curDate = new Date();
                Date tokenDate = (new SimpleDateFormat("yyyyMMddHHmmss")).parse(tokDate);

                // userId 체크
                if(!StringUtil.nvl(vo.getUserId()).equals(tokUserId)) {
                    validToken = false;
                    resultVo.setResult(-3);
                    resultVo.setMessage("사용자번호가 틀립니다. 다시 확인하시기 바랍니다.");
                }
                // 토큰 생성시간 체크(5분) 
                else if((curDate.getTime() - tokenDate.getTime()) > 300000) {
                    validToken = false;
                    resultVo.setResult(-2);
                    resultVo.setMessage("토큰이 만료 되었습니다.. 다시 생성 하시기 바랍니다.");
                }
            }validToken = true;
            if(!validToken) {
                return JsonUtil.responseJson(response, resultVo);
            }
            vo.setOrgId(API_ORG_ID);
            resultVo = apiService.selectStdProgressRatio(vo);
        }
        catch(Exception e) {
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVo.setReturnVO(vo);
        }
        resultStr = JsonUtil.responseJson(response, resultVo);

        return resultStr;
    }
    
    /**
     * 교수 과목별 진도율 조회
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/selectProfSubjectProgressRatio.do")
    public String selectProfSubjectProgressRatio(ApiListInfoVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String resultStr = "";
        ProcessResultVO<ApiListInfoVO> resultVo = new ProcessResultVO<ApiListInfoVO>();

        try {

            String token = StringUtil.nvl(vo.getToken());
            boolean validToken = true; 

            // 토큰 유효성 체크
            if("".equals(token)) {
                validToken = false;
                resultVo.setResult(-4);
                resultVo.setMessage("토큰이 없습니다. 생성 후에 실행해 주세요.");
            }
            else {
                String decToken[] = decryptToken(token).split(",");
                String tokUserId = decToken.length > 2 ? decToken[1] : decToken[0];
                String tokDate = decToken.length > 2 ? decToken[2] : decToken[1];

                Date curDate = new Date();
                Date tokenDate = (new SimpleDateFormat("yyyyMMddHHmmss")).parse(tokDate);

                // userId 체크
                if(!StringUtil.nvl(vo.getUserId()).equals(tokUserId)) {
                    validToken = false;
                    resultVo.setResult(-3);
                    resultVo.setMessage("사용자번호가 틀립니다. 다시 확인하시기 바랍니다.");
                }
                // 토큰 생성시간 체크(5분) 
                else if((curDate.getTime() - tokenDate.getTime()) > 300000) {
                    validToken = false;
                    resultVo.setResult(-2);
                    resultVo.setMessage("토큰이 만료 되었습니다.. 다시 생성 하시기 바랍니다.");
                }
            }

            if(!validToken) {
                return JsonUtil.responseJson(response, resultVo);
            }
            vo.setOrgId(API_ORG_ID);
            resultVo = apiService.selectProfSubjectProgressRatio(vo);
        }
        catch(Exception e) {
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVo.setReturnVO(vo);
        }
        resultStr = JsonUtil.responseJson(response, resultVo);

        return resultStr;
    }

    /**
     * 교수 학습 진도율 조회
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/selectProfProgressRatio.do")
    public String selectProfProgressRatio(ApiListInfoVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String resultStr = "";
        ProcessResultVO<ApiListInfoVO> resultVo = new ProcessResultVO<ApiListInfoVO>();

        try {

            String token = StringUtil.nvl(vo.getToken());
            boolean validToken = true; 

            // 토큰 유효성 체크
            if("".equals(token)) {
                validToken = false;
                resultVo.setResult(-4);
                resultVo.setMessage("토큰이 없습니다. 생성 후에 실행해 주세요.");
            }
            else {
                String decToken[] = decryptToken(token).split(",");
                String tokUserId = decToken.length > 2 ? decToken[1] : decToken[0];
                String tokDate = decToken.length > 2 ? decToken[2] : decToken[1];

                Date curDate = new Date();
                Date tokenDate = (new SimpleDateFormat("yyyyMMddHHmmss")).parse(tokDate);

                // userId 체크
                if(!StringUtil.nvl(vo.getUserId()).equals(tokUserId)) {
                    validToken = false;
                    resultVo.setResult(-3);
                    resultVo.setMessage("사용자번호가 틀립니다. 다시 확인하시기 바랍니다.");
                }
                // 토큰 생성시간 체크(5분) 
                else if((curDate.getTime() - tokenDate.getTime()) > 300000) {
                    validToken = false;
                    resultVo.setResult(-2);
                    resultVo.setMessage("토큰이 만료 되었습니다.. 다시 생성 하시기 바랍니다.");
                }
            }

            if(!validToken) {
                return JsonUtil.responseJson(response, resultVo);
            }

            vo.setOrgId(API_ORG_ID);
            resultVo = apiService.selectProfProgressRatio(vo);

        }
        catch(Exception e) {
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVo.setReturnVO(vo);
        }
        resultStr = JsonUtil.responseJson(response, resultVo);

        return resultStr;
    }
    
    /**
     * 학과별 주차별 출석현황 (교수, 학과장)
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/selectDepartPerWeekAttend.do")
    public String selectDepartPerWeekAttend(ApiListInfoVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String resultStr = "";
        ProcessResultVO<ApiListInfoVO> resultVo = new ProcessResultVO<ApiListInfoVO>();

        try {

            String token = StringUtil.nvl(vo.getToken());
            boolean validToken = true; 

            // 토큰 유효성 체크
            if("".equals(token)) {
                validToken = false;
                resultVo.setResult(-4);
                resultVo.setMessage("토큰이 없습니다. 생성 후에 실행해 주세요.");
            }
            else {
                String decToken[] = decryptToken(token).split(",");
                String tokUserId = decToken.length > 2 ? decToken[1] : decToken[0];
                String tokDate = decToken.length > 2 ? decToken[2] : decToken[1];

                Date curDate = new Date();
                Date tokenDate = (new SimpleDateFormat("yyyyMMddHHmmss")).parse(tokDate);

                // userId 체크
                if(!StringUtil.nvl(vo.getUserId()).equals(tokUserId)) {
                    validToken = false;
                    resultVo.setResult(-3);
                    resultVo.setMessage("사용자번호가 틀립니다. 다시 확인하시기 바랍니다.");
                }
                // 토큰 생성시간 체크(5분) 
                else if((curDate.getTime() - tokenDate.getTime()) > 300000) {
                    validToken = false;
                    resultVo.setResult(-2);
                    resultVo.setMessage("토큰이 만료 되었습니다.. 다시 생성 하시기 바랍니다.");
                }
            }

            if(!validToken) {
                return JsonUtil.responseJson(response, resultVo);
            }

            vo.setOrgId(API_ORG_ID);
            vo.setLastYear(String.valueOf(Integer.parseInt(vo.getYear())-1));
            resultVo = apiService.selectDepartPerWeekAttend(vo);
        }
        catch(Exception e) {
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVo.setReturnVO(vo);
        }
        resultStr = JsonUtil.responseJson(response, resultVo);

        return resultStr;
    }

    /**
     * 전체 주차별 출석현황
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/selectTotalPerWeekAttend.do")
    public String selectTotalPerWeekAttend(ApiListInfoVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String resultStr = "";
        ProcessResultVO<ApiListInfoVO> resultVo = new ProcessResultVO<ApiListInfoVO>();

        try {
            vo.setOrgId(StringUtil.nvl(SessionInfo.getOrgId(request)));

            String token = StringUtil.nvl(vo.getToken());
            boolean validToken = true; 

            // 토큰 유효성 체크
            if("".equals(token)) {
                validToken = false;
                resultVo.setResult(-4);
                resultVo.setMessage("토큰이 없습니다. 생성 후에 실행해 주세요.");
            }
            else {
                String decToken[] = decryptToken(token).split(",");
                String tokUserId = decToken.length > 2 ? decToken[1] : decToken[0];
                String tokDate = decToken.length > 2 ? decToken[2] : decToken[1];

                Date curDate = new Date();
                Date tokenDate = (new SimpleDateFormat("yyyyMMddHHmmss")).parse(tokDate);

                // userId 체크
                if(!StringUtil.nvl(vo.getUserId()).equals(tokUserId)) {
                    validToken = false;
                    resultVo.setResult(-3);
                    resultVo.setMessage("사용자번호가 틀립니다. 다시 확인하시기 바랍니다.");
                }
                // 토큰 생성시간 체크(5분) 
                else if((curDate.getTime() - tokenDate.getTime()) > 300000) {
                    validToken = false;
                    resultVo.setResult(-2);
                    resultVo.setMessage("토큰이 만료 되었습니다.. 다시 생성 하시기 바랍니다.");
                }
            }

            if(!validToken) {
            	return JsonUtil.responseJson(response, resultVo);
            }
            vo.setOrgId(API_ORG_ID);
            vo.setLastYear(String.valueOf(Integer.parseInt(vo.getYear())-1));
            resultVo = apiService.selectTotalPerWeekAttend(vo);
        }
        catch(Exception e) {
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVo.setReturnVO(vo);
        }
        resultStr = JsonUtil.responseJson(response, resultVo);

        return resultStr;
    }

    /**
     * 주차별 학습현황
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/selectPerWeekAttend.do")
    public String selectPerWeekAttend(ApiListInfoVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String resultStr = "";
        ProcessResultVO<ApiListInfoVO> resultVo = new ProcessResultVO<ApiListInfoVO>();

        try {
            String token = StringUtil.nvl(vo.getToken());
            boolean validToken = true; 

            // 토큰 유효성 체크
            if("".equals(token)) {
                validToken = false;
                resultVo.setResult(-4);
                resultVo.setMessage("토큰이 없습니다. 생성 후에 실행해 주세요.");
            }
            else {
                String decToken[] = decryptToken(token).split(",");
                String tokUserId = decToken.length > 2 ? decToken[1] : decToken[0];
                String tokDate = decToken.length > 2 ? decToken[2] : decToken[1];

                Date curDate = new Date();
                Date tokenDate = (new SimpleDateFormat("yyyyMMddHHmmss")).parse(tokDate);

                // userId 체크
                if(!StringUtil.nvl(vo.getUserId()).equals(tokUserId)) {
                    validToken = false;
                    resultVo.setResult(-3);
                    resultVo.setMessage("사용자번호가 틀립니다. 다시 확인하시기 바랍니다.");
                }
                // 토큰 생성시간 체크(5분) 
                else if((curDate.getTime() - tokenDate.getTime()) > 300000) {
                    validToken = false;
                    resultVo.setResult(-2);
                    resultVo.setMessage("토큰이 만료 되었습니다.. 다시 생성 하시기 바랍니다.");
                }
            }

            if(!validToken) {
            	return JsonUtil.responseJson(response, resultVo);
            }
            vo.setOrgId(API_ORG_ID);
            vo.setLastYear(String.valueOf(Integer.parseInt(vo.getYear())-1));
            resultVo = apiService.selectPerWeekAttend(vo);
        }
        catch(Exception e) {
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVo.setReturnVO(vo);
        }
        resultStr = JsonUtil.responseJson(response, resultVo);

        return resultStr;
    }
    
    /**
     * 과목별 출석현황 (교수, 학과장)
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/selectSubjectPerWeekAttend.do")
    public String selectSubjectPerWeekAttend(ApiListInfoVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String resultStr = "";
        ProcessResultVO<ApiListInfoVO> resultVo = new ProcessResultVO<ApiListInfoVO>();

        try {

            String token = StringUtil.nvl(vo.getToken());
            boolean validToken = true; 

            // 토큰 유효성 체크
            if("".equals(token)) {
                validToken = false;
                resultVo.setResult(-4);
                resultVo.setMessage("토큰이 없습니다. 생성 후에 실행해 주세요.");
            }
            else {
                String decToken[] = decryptToken(token).split(",");
                String tokUserId = decToken.length > 2 ? decToken[1] : decToken[0];
                String tokDate = decToken.length > 2 ? decToken[2] : decToken[1];

                Date curDate = new Date();
                Date tokenDate = (new SimpleDateFormat("yyyyMMddHHmmss")).parse(tokDate);

                // userId 체크
                if(!StringUtil.nvl(vo.getUserId()).equals(tokUserId)) {
                    validToken = false;
                    resultVo.setResult(-3);
                    resultVo.setMessage("사용자번호가 틀립니다. 다시 확인하시기 바랍니다.");
                }
                // 토큰 생성시간 체크(5분) 
                else if((curDate.getTime() - tokenDate.getTime()) > 300000) {
                    validToken = false;
                    resultVo.setResult(-2);
                    resultVo.setMessage("토큰이 만료 되었습니다.. 다시 생성 하시기 바랍니다.");
                }
            }

            if(!validToken) {
            	return JsonUtil.responseJson(response, resultVo);
            }
            
            vo.setOrgId(API_ORG_ID);
            vo.setLastYear(String.valueOf(Integer.parseInt(vo.getYear())-1));

            resultVo = apiService.selectSubjectPerWeekAttend(vo);
        }
        catch(Exception e) {
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVo.setReturnVO(vo);
        }
        resultStr = JsonUtil.responseJson(response, resultVo);

        return resultStr;
    }

    /**
     * 학생 과목 목록 조회
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/selectStuCrsCreNmList.do")
    public String selectStuCrsCreNmList(ApiListInfoVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String resultStr = "";
        ProcessResultVO<ApiListInfoVO> resultVo = new ProcessResultVO<ApiListInfoVO>();

        try {

            String token = StringUtil.nvl(vo.getToken());
            boolean validToken = true; 

            // 토큰 유효성 체크
            if("".equals(token)) {
                validToken = false;
                resultVo.setResult(-4);
                resultVo.setMessage("토큰이 없습니다. 생성 후에 실행해 주세요.");
            }
            else {
                String decToken[] = decryptToken(token).split(",");
                String tokUserId = decToken.length > 2 ? decToken[1] : decToken[0];
                String tokDate = decToken.length > 2 ? decToken[2] : decToken[1];

                Date curDate = new Date();
                Date tokenDate = (new SimpleDateFormat("yyyyMMddHHmmss")).parse(tokDate);

                // userId 체크
                if(!StringUtil.nvl(vo.getUserId()).equals(tokUserId)) {
                    validToken = false;
                    resultVo.setResult(-3);
                    resultVo.setMessage("사용자번호가 틀립니다. 다시 확인하시기 바랍니다.");
                }
                // 토큰 생성시간 체크(5분) 
                else if((curDate.getTime() - tokenDate.getTime()) > 300000) {
                    validToken = false;
                    resultVo.setResult(-2);
                    resultVo.setMessage("토큰이 만료 되었습니다.. 다시 생성 하시기 바랍니다.");
                }
            }

            if(!validToken) {
                return JsonUtil.responseJson(response, resultVo);
            }
            
            vo.setOrgId(API_ORG_ID);
            resultVo = apiService.selectStuCrsCreNmList(vo);
        }
        catch(Exception e) {
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVo.setReturnVO(vo);
        }
        resultStr = JsonUtil.responseJson(response, resultVo);

        return resultStr;
    }

    /**
     * 전체 학생 진도율 입력
     * @param vo
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    /*
    @RequestMapping(value="/insertStdProgressRatio.do")
    public String insertStdProgressRatio(ApiListInfoVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String resultStr = "";
        ProcessResultVO<ApiListInfoVO> resultVo = new ProcessResultVO<ApiListInfoVO>();

        try {
            vo.setOrgId(API_ORG_ID);
            apiService.insertStdProgressRatio();
        }
        catch(Exception e) {
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVo.setReturnVO(vo);
            throw e;
        }
        resultStr = JsonUtil.responseJson(response, resultVo);

        return resultStr;
    }
    */

    /**
     * 전체 학생 출석율 입력
     * @param vo
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    /*
    @RequestMapping(value="/insertStdAttendRatio.do")
    public String insertStdAttendRatio(ApiListInfoVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String resultStr = "";
        ProcessResultVO<ApiListInfoVO> resultVo = new ProcessResultVO<ApiListInfoVO>();

        try {
            vo.setOrgId(API_ORG_ID);
            apiService.insertStdAttendRatio();
        }
        catch(Exception e) {
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVo.setReturnVO(vo);
            throw e;
        }
        resultStr = JsonUtil.responseJson(response, resultVo);

        return resultStr;
    }
    */

    /**
     * 콘텐츠 미리보기
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/previewCnts.do")
    public String previewCnts(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        LessonCntsVO lessonCntsVO = new LessonCntsVO();

        try {
            String params = StringUtil.nvl(request.getParameter("params"));
            params = decryptToken(params);

            Map<String, Object> paramMap = JsonUtil.getJsonObject(params);
            String year = StringUtil.nvl((String) paramMap.get("year"));
            String semester = StringUtil.nvl((String) paramMap.get("semester"));
            String courseCode = StringUtil.nvl((String) paramMap.get("courseCode"));
            String week = StringUtil.nvl((String) paramMap.get("week"), "1");
            String tokDate = StringUtil.nvl((String) paramMap.get("date"));

            boolean validToken = true;
            // 토큰 생성시간 체크 (5분) -- 토큰생성시간 체크 하지 않도록 수정
            /*
            Date curDate = new Date();
            Date tokenDate = (new SimpleDateFormat("yyyyMMddHHmmss")).parse(tokDate);
            if((curDate.getTime() - tokenDate.getTime()) > 300000) {
            	validToken = false;
            }
            */
            
            if(!validToken) {
                model.addAttribute("result", "-1");
            }
            else {

                String lessonCntsId = "LC_" + year + semester + courseCode + "01" + (week.length() < 2 ? "0"+week : week) + "01";
                lessonCntsVO.setLessonCntsId(lessonCntsId);

                Calendar cal = Calendar.getInstance();
                cal.setTime(new Date());
                cal.add(Calendar.HOUR, 6);
                String limitTime = (new SimpleDateFormat("yyyyMMddHHmmss")).format(cal.getTime());
                String cdnParam = "?&r=17&ip=127.0.0.1&limitTime="+limitTime+"&userId=000000&checkIP=false";

                // 콘텐츠정보 조회
                lessonCntsVO = apiService.selectPreviewCnts(lessonCntsVO);

                if(lessonCntsVO != null) {
                    LessonPageVO lessonPageVO = new LessonPageVO();
                    lessonPageVO.setLessonCntsId(lessonCntsId);

                    // 페이지목록 조회
                    List<LessonPageVO> pageList = apiService.listPreviewLessonPage(lessonPageVO);

                    if(pageList != null && pageList.size() > 0) {
                        String pageInfo = "<page_list>\n";

                        for(LessonPageVO pageVO : pageList) {
                            String type = "html";
                            boolean on = false;
                            String sessionLoc = "0";
                            int studySessionTm = 0;
                            int studyCnt = 0;
                            int prgrRatio = 0;

                            if("MP4".equalsIgnoreCase(pageVO.getUploadGbn())) {
                                type = "video/mp4";
                            }

                            String hdUrl = pageVO.getUrl();
                            String sdUrl = "";
                            String srcUri = "";
                            String script = "";
                            String caption = "";
                            String chapter = "";
                            String extData = "";

                            int idx = hdUrl.indexOf("/courseware/");
                            if(idx > -1) {
                                hdUrl = hdUrl.substring(idx+12);
                                srcUri = hdUrl.substring(0, hdUrl.lastIndexOf("/")+1);
                                extData = new String((Base64.getEncoder()).encode((CommConst.CDN_URL+","+srcUri+","+CommConst.CDN_SECRET_IV+","+CommConst.CDN_SECRET_KEY+","+cdnParam).getBytes()));

                                if(hdUrl.indexOf("_hd.mp4") > 0) {
                                    sdUrl = hdUrl.replace("_hd.mp4", "_sd.mp4");
                                }

                                script = srcUri + "media_script_list.xml";
                                caption = srcUri + "caption_list.xml";
                                chapter = srcUri + "chapter.xml";

                                try {
                                    hdUrl = CommConst.CDN_URL + SecureUtil.encodeAesCbc((hdUrl+cdnParam), CommConst.CDN_SECRET_IV, CommConst.CDN_SECRET_KEY);
                                    script = CommConst.CDN_URL + SecureUtil.encodeAesCbc((script+cdnParam), CommConst.CDN_SECRET_IV, CommConst.CDN_SECRET_KEY);
                                    caption = CommConst.CDN_URL + SecureUtil.encodeAesCbc((caption+cdnParam), CommConst.CDN_SECRET_IV, CommConst.CDN_SECRET_KEY);
                                    chapter = CommConst.CDN_URL + SecureUtil.encodeAesCbc((chapter+cdnParam), CommConst.CDN_SECRET_IV, CommConst.CDN_SECRET_KEY);

                                    if(!"".equals(sdUrl)) {
                                        sdUrl = CommConst.CDN_URL + SecureUtil.encodeAesCbc((sdUrl+cdnParam), CommConst.CDN_SECRET_IV, CommConst.CDN_SECRET_KEY);
                                    }
                                }
                                catch(Exception e) { }
                            }

                            if(idx == -1) {
                                idx = hdUrl.indexOf("/lecture/");
                                if(idx == 0) {
                                    hdUrl = CommConst.WEBDATA_CONTEXT + hdUrl;
                                }
                            }

                            pageInfo += "<page>\n";
                            pageInfo += "<page_cnt>"+pageVO.getPageCnt()+"</page_cnt>\n";
                            pageInfo += "<page_title>"+pageVO.getPageNm()+"</page_title>\n";
                            pageInfo += "<page_source>"+hdUrl+"</page_source>\n";

                            if(!"".equals(sdUrl)) {
                                pageInfo += "<page_source_sd>"+sdUrl+"</page_source_sd>\n";
                            }
                            if(!"".equals(script)) {
                                pageInfo += "<script_xml>"+script+"</script_xml>\n";
                            }
                            if(!"".equals(caption)) {
                                pageInfo += "<track_xml>"+caption+"</track_xml>\n";
                            }
                            if(!"".equals(chapter)) {
                                pageInfo += "<chapter_xml>"+chapter+"</chapter_xml>\n";
                            }

                            pageInfo += "<page_type>"+type+"</page_type>\n";
                            pageInfo += "<study_tm>"+studySessionTm+"</study_tm>\n";
                            pageInfo += "<prgr_ratio>"+prgrRatio+"</prgr_ratio>\n";
                            pageInfo += "<session_loc>"+sessionLoc+"</session_loc>\n";
                            pageInfo += "<study_cnt>"+studyCnt+"</study_cnt>\n";
                            pageInfo += "<on>"+on+"</on>\n";
                            pageInfo += "<videotm>"+pageVO.getVideoTm()+"</videotm>\n";
                            pageInfo += "<attend>"+pageVO.getAtndYn()+"</attend>\n";
                            pageInfo += "<openyn>"+pageVO.getOpenYn()+"</openyn>\n";
                            pageInfo += "<extdata>"+extData+"</extdata>\n";
                            pageInfo += "</page>\n";
                        }
    
                        pageInfo += "</page_list>";
                        lessonCntsVO.setPageInfo(pageInfo);
                    }
                }
                model.addAttribute("result", "1");
            }
        }
        catch(Exception e) {
            e.printStackTrace();
        }
        model.addAttribute("lessonCnts", lessonCntsVO);

        return "api/preview_cnts";
    }

    /**
     * LCDMS 콘텐츠 미리보기
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/previewLcdmsCnts.do")
    public String previewLcdmsCnts(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        CntsPreviewVO cntsPreviewVO = new CntsPreviewVO();

        try {
            String params = StringUtil.nvl(request.getParameter("params"));
            params = decryptToken(params);

            Map<String, Object> paramMap = JsonUtil.getJsonObject(params);
            String year = StringUtil.nvl((String) paramMap.get("year"));
            String semester = StringUtil.nvl((String) paramMap.get("semester"));
            String courseCode = StringUtil.nvl((String) paramMap.get("courseCode"));
            String contCd = StringUtil.nvl((String) paramMap.get("contCd"));
            String week = StringUtil.nvl((String) paramMap.get("week"), "1");
            String tokDate = StringUtil.nvl((String) paramMap.get("date"));

            boolean validToken = true;
            // 토큰 생성시간 체크 (5분) -- 토큰생성시간 체크 하지 않도록 수정
            /*
            Date curDate = new Date();
            Date tokenDate = (new SimpleDateFormat("yyyyMMddHHmmss")).parse(tokDate);
            if((curDate.getTime() - tokenDate.getTime()) > 300000) {
            	validToken = false;
            }
            */
            
            //System.out.println("params = "+params);
            
            if(!validToken) {
                model.addAttribute("result", "-1");
            }
            else {
                Calendar cal = Calendar.getInstance();
                cal.setTime(new Date());
                cal.add(Calendar.HOUR, 6);
                String limitTime = (new SimpleDateFormat("yyyyMMddHHmmss")).format(cal.getTime());
                String cdnParam = "?&r=17&ip=127.0.0.1&limitTime="+limitTime+"&userId=000000&checkIP=false";

                cntsPreviewVO.setYear(year);
                cntsPreviewVO.setSemester(semester);
                cntsPreviewVO.setScCd(courseCode);
                cntsPreviewVO.setContCd(contCd);
                cntsPreviewVO.setWeek(Integer.parseInt(week));
                
                // 콘텐츠정보 조회
                cntsPreviewVO = apiService.selectLcdmsCntsPreview(cntsPreviewVO);
                
                //System.out.println("콘텐츠 정보 조회....."+cntsPreviewVO.getScNm());

                if(cntsPreviewVO != null) {
                    PagePreviewVO lessonPageVO = new PagePreviewVO();
                    lessonPageVO.setYear(year);
                    lessonPageVO.setSemester(semester);
                    lessonPageVO.setScCd(courseCode);
                    lessonPageVO.setContCd(contCd);
                    lessonPageVO.setWeek(Integer.parseInt(week));

                    // 페이지목록 조회
                    List<PagePreviewVO> pageList = apiService.listLcdmsPagePreview(lessonPageVO);

                    if(pageList != null && pageList.size() > 0) {
                        String pageInfo = "<page_list>\n";

                        for(PagePreviewVO pageVO : pageList) {
                            String type = "html";
                            boolean on = false;
                            String sessionLoc = "0";
                            int studySessionTm = 0;
                            int studyCnt = 0;
                            int prgrRatio = 0;

                            if("MP4".equalsIgnoreCase(pageVO.getUploadGbn())) {
                                type = "video/mp4";
                            }

                            String hdUrl = pageVO.getUrl();
                            String sdUrl = "";
                            String srcUri = "";
                            String script = "";
                            String caption = "";
                            String chapter = "";
                            String extData = "";
                            int videoTm = 0;

                            int idx = hdUrl.indexOf("/courseware/");
                            if(idx > -1) {
                                hdUrl = hdUrl.substring(idx+12);
                                srcUri = hdUrl.substring(0, hdUrl.lastIndexOf("/")+1);
                                extData = new String((Base64.getEncoder()).encode((CommConst.CDN_URL+","+srcUri+","+CommConst.CDN_SECRET_IV+","+CommConst.CDN_SECRET_KEY+","+cdnParam).getBytes()));

                                if(hdUrl.indexOf("_hd.mp4") > 0) {
                                    sdUrl = hdUrl.replace("_hd.mp4", "_sd.mp4");
                                }

                                script = srcUri + "media_script_list.xml";
                                caption = srcUri + "caption_list.xml";
                                chapter = srcUri + "chapter.xml";

                                try {
                                    hdUrl = CommConst.CDN_URL + SecureUtil.encodeAesCbc((hdUrl+cdnParam), CommConst.CDN_SECRET_IV, CommConst.CDN_SECRET_KEY);
                                    script = CommConst.CDN_URL + SecureUtil.encodeAesCbc((script+cdnParam), CommConst.CDN_SECRET_IV, CommConst.CDN_SECRET_KEY);
                                    caption = CommConst.CDN_URL + SecureUtil.encodeAesCbc((caption+cdnParam), CommConst.CDN_SECRET_IV, CommConst.CDN_SECRET_KEY);
                                    chapter = CommConst.CDN_URL + SecureUtil.encodeAesCbc((chapter+cdnParam), CommConst.CDN_SECRET_IV, CommConst.CDN_SECRET_KEY);

                                    if(!"".equals(sdUrl)) {
                                        sdUrl = CommConst.CDN_URL + SecureUtil.encodeAesCbc((sdUrl+cdnParam), CommConst.CDN_SECRET_IV, CommConst.CDN_SECRET_KEY);
                                    }
                                }
                                catch(Exception e) { }
                            }

                            if(idx == -1) {
                                idx = hdUrl.indexOf("/lecture/");
                                if(idx == 0) {
                                    hdUrl = CommConst.WEBDATA_CONTEXT + hdUrl;
                                }
                            }

                            if(!"".equals(StringUtil.nvl(pageVO.getLbnTm()))) {
                                String[] tm = pageVO.getLbnTm().split(":");
                                
                                if(tm.length > 1) {
                                    videoTm = "".equals(tm[0]) ? 0 : Integer.parseInt(tm[0]) * 60;
                                    videoTm += "".equals(tm[1]) ? 0 : Integer.parseInt(tm[1]);
                                }
                                else {
                                    videoTm = Integer.parseInt(tm[0]);
                                }
                            }

                            pageInfo += "<page>\n";
                            pageInfo += "<page_cnt>"+pageVO.getPageCnt()+"</page_cnt>\n";
                            pageInfo += "<page_title>"+pageVO.getPageNm()+"</page_title>\n";
                            pageInfo += "<page_source>"+hdUrl+"</page_source>\n";

                            if(!"".equals(sdUrl)) {
                                pageInfo += "<page_source_sd>"+sdUrl+"</page_source_sd>\n";
                            }
                            if(!"".equals(script)) {
                                pageInfo += "<script_xml>"+script+"</script_xml>\n";
                            }
                            if(!"".equals(caption)) {
                                pageInfo += "<track_xml>"+caption+"</track_xml>\n";
                            }
                            if(!"".equals(chapter)) {
                                pageInfo += "<chapter_xml>"+chapter+"</chapter_xml>\n";
                            }

                            pageInfo += "<page_type>"+type+"</page_type>\n";
                            pageInfo += "<study_tm>"+studySessionTm+"</study_tm>\n";
                            pageInfo += "<prgr_ratio>"+prgrRatio+"</prgr_ratio>\n";
                            pageInfo += "<session_loc>"+sessionLoc+"</session_loc>\n";
                            pageInfo += "<study_cnt>"+studyCnt+"</study_cnt>\n";
                            pageInfo += "<on>"+on+"</on>\n";
                            pageInfo += "<videotm>"+videoTm+"</videotm>\n";
                            pageInfo += "<attend>"+pageVO.getLmsAttendYn()+"</attend>\n";
                            pageInfo += "<openyn>"+pageVO.getLmsOpenYn()+"</openyn>\n";
                            pageInfo += "<extdata>"+extData+"</extdata>\n";
                            pageInfo += "</page>\n";
                        }
    
                        pageInfo += "</page_list>";
                        cntsPreviewVO.setPageInfo(pageInfo);
                    }
                }
                model.addAttribute("result", "1");
            }
        }
        catch(Exception e) {
            e.printStackTrace();
        }
        model.addAttribute("lessonCnts", cntsPreviewVO);

        return "api/preview_lcdms_cnts";
    }

    /**
     * 학생별 학습현황 폼
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/learningStatusForm.do")
    public String learningStatusForm(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String url = "api/learning_status_form";;
        String userId = StringUtil.nvl(SessionInfo.getUserId(request));
        String params = StringUtil.nvl(request.getParameter("params"));

        HttpSession ss = request.getSession();
        String ssoUserId = StringUtil.nvl((String)ss.getAttribute("SSO_ID"));

        if(!"".equals(params)) {
            ss.setAttribute("LEARNING_STATUS_PARAMS", params);
        }

        if("".equals(userId) && "".equals(ssoUserId)) {
            // 사용자 정보가 없으면 SSO 로그인 이동
            String serverName = request.getServerName();
            url = "redirect:/sso/CreateRequest.jsp?RelayState=https://"+serverName+"/api/learningStatusForm.do";
        }
        else {

            if("".equals(userId) && !"".equals(ssoUserId)) {
                userId = ssoUserId;
                SessionInfo.setUserId(request, userId);
            }

            if("".equals(params)) {
                params = StringUtil.nvl((String)ss.getAttribute("LEARNING_STATUS_PARAMS"));
            }

            params = decryptToken(params);

            Map<String, Object> paramMap = JsonUtil.getJsonObject(params);
            String year = StringUtil.nvl((String) paramMap.get("year"));
            String semester = StringUtil.nvl((String) paramMap.get("semester"));
            String courseCode = StringUtil.nvl((String) paramMap.get("courseCode"));
            String section = StringUtil.nvl((String) paramMap.get("section"));
            String stuNo = StringUtil.nvl((String) paramMap.get("userId"));
            String tokDate = StringUtil.nvl((String) paramMap.get("date"));
            String orgId = CommConst.KNOU_ORG_ID;

            Date curDate = new Date();
            Date tokenDate = (new SimpleDateFormat("yyyyMMddHHmmss")).parse(tokDate);

            // 토큰 생성시간 체크 (5분)
            if((curDate.getTime() - tokenDate.getTime()) > 300000) {
                model.addAttribute("result", "-1");
                model.addAttribute("corsList", null);
            }
            else {
                List<MainCreCrsVO> corsList = new ArrayList<>();

                if("".equals(courseCode)) {
                    TermVO termVO = new TermVO();
                    termVO.setOrgId(orgId);
                    termVO.setHaksaYear(year);
                    termVO.setHaksaTerm(semester);
                    termVO.setUserId(stuNo);

                    corsList = apiService.listLearningStatus(termVO);
                }
                else {
                    String crsCreCd = year + semester + courseCode + (section.length() < 2 ? "0"+section : section);

                    CreCrsVO creCrsVO = new CreCrsVO();
                    creCrsVO.setCrsCreCd(crsCreCd);
                    creCrsVO.setUserId(stuNo);

                    corsList = apiService.listLearningStatusOne(creCrsVO);
                }
                model.addAttribute("corsList", corsList);
                model.addAttribute("result", "1");
            }
        }
        return url;
    }

    /**
     * API 요청 폼_테스트용 함수
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/apiRequestForm.do")
    public String apiRequestForm(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        return "api/api_request_form";
    }

    /**
     * 암호화값 생성 반환
     * @param request
     * @param response
     * @param modelMap
     * @return
     */
    @RequestMapping(value="/getSecureEncode.do")
    @ResponseBody
    public String getSecureEncode(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) {

        Map<String, Object> result = new HashMap<>();

        try {

            Map<String,String> paramsMap = new HashMap<String,String>();
            Enumeration<String> names = request.getParameterNames();

            while(names.hasMoreElements()) {
                String key = (String) names.nextElement();
                paramsMap.put(key, request.getParameter(key));
            }

            paramsMap.put("date", (new SimpleDateFormat("yyyyMMddHHmmss")).format(new Date()));

            String paramsStr = (new JSONObject(paramsMap)).toJSONString();
            String value = SecureUtil.getRSAEncript(paramsStr);

            result.put("value", value);
            result.put("result", "1");
        }
        catch(Exception e) {
            result.put("result", "-1");
        }
        return JsonUtil.responseJson(response, result);
    }

    /**
     * 통합메시지 전달용 토큰 반환
     * @param request
     * @param response
     * @param modelMap
     * @return
     */
    @RequestMapping(value="/getMesageToken.do")
    @ResponseBody
    public String getMesageToken(HttpServletRequest request, HttpServletResponse response, ModelMap modelMap) {

        Map<String, Object> result = new HashMap<>();

        try {
            String paramsStr = SessionInfo.getUserId(request) + "," + (new SimpleDateFormat("yyyyMMddHHmmss")).format(new Date());
            String value = SecureUtil.getRSAEncript(paramsStr);

            result.put("value", value);
            result.put("result", "1");
        }
        catch(Exception e) {
            result.put("result", "-1");
        }
        return JsonUtil.responseJson(response, result);
    }
    
    /**
     * 콘텐츠 동영상 보기(학과 소개용 미리보기 콘텐츠)
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/viewContent.do")
    public String viewContent(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String params = StringUtil.nvl(request.getParameter("params"));
        String referer = StringUtil.nvl(request.getHeader("referer"));        

        boolean isPass = false;
        if(!"".equals(params) && referer.contains("hycu.ac.kr")) {
            isPass = true;
        }
        // 1주차
//        else {
//            String prms[] = params.split("_");
//            if (prms.length > 1 && (prms[1].equals("01") || prms[1].equals("1"))) {
//                isPass = true;
//            }
//        }
        
        if(isPass) {
            String prms[] = params.split("_");

            if(prms.length >= 3) {
                String contCd = prms[0].toUpperCase();
                String weekStr = prms[1];
                String pageCnt = prms[2];

                if(weekStr.indexOf("0") == 0) {
                    weekStr = weekStr.substring(1);
                }
                if(pageCnt.indexOf("0") == 0) {
                    pageCnt = pageCnt.substring(1);
                }

                ErpLcdmsPageVO pageVO = new ErpLcdmsPageVO();
                pageVO.setContCd(contCd);
                pageVO.setWeek(Integer.parseInt(weekStr));
                pageVO.setPageCnt(pageCnt);

                 pageVO = erpService.selectContentsPreviewInfo(pageVO);

                if(pageVO != null) {
                    String hdUrl = pageVO.getUrl();
                    String sdUrl = "";
                    String srcUri = "";
                    String script = "";
                    String caption = "";
                    String chapter = "";
                    String extData = "";
                    int videoTm = 0;
                    int idx = hdUrl.indexOf("/courseware/");

                    Calendar cal = Calendar.getInstance();
                    cal.setTime(new Date());
                    cal.add(Calendar.HOUR, 6);
                    String limitTime = (new SimpleDateFormat("yyyyMMddHHmmss")).format(cal.getTime());
                    String cdnParam = "?&r=17&ip=127.0.0.1&limitTime="+limitTime+"&userId=000000&checkIP=false";

                    if(idx > -1) {
                        hdUrl = hdUrl.substring(idx+12);
                        srcUri = hdUrl.substring(0, hdUrl.lastIndexOf("/")+1);
                        extData = new String((Base64.getEncoder()).encode((CommConst.CDN_URL+","+srcUri+","+CommConst.CDN_SECRET_IV+","+CommConst.CDN_SECRET_KEY+","+cdnParam).getBytes()));

                        if(!"".equals(StringUtil.nvl(pageVO.getLbnTm()))) {
                            String[] tm = pageVO.getLbnTm().split(":");
                            
                            if(tm.length > 1) {
                                videoTm = "".equals(tm[0]) ? 0 : Integer.parseInt(tm[0]) * 60;
                                videoTm += "".equals(tm[1]) ? 0 : Integer.parseInt(tm[1]);
                            }
                            else {
                                videoTm = Integer.parseInt(tm[0]);
                            }
                        }

                        if(hdUrl.indexOf("_hd.mp4") > 0) {
                            sdUrl = hdUrl.replace("_hd.mp4", "_sd.mp4");
                        }

                        script = srcUri + "media_script_list.xml";
                        caption = srcUri + "caption_list.xml";
                        chapter = srcUri + "chapter.xml";

                        try {
                            hdUrl = CommConst.CDN_URL + SecureUtil.encodeAesCbc((hdUrl+cdnParam), CommConst.CDN_SECRET_IV, CommConst.CDN_SECRET_KEY);
                            script = CommConst.CDN_URL + SecureUtil.encodeAesCbc((script+cdnParam), CommConst.CDN_SECRET_IV, CommConst.CDN_SECRET_KEY);
                            caption = CommConst.CDN_URL + SecureUtil.encodeAesCbc((caption+cdnParam), CommConst.CDN_SECRET_IV, CommConst.CDN_SECRET_KEY);
                            chapter = CommConst.CDN_URL + SecureUtil.encodeAesCbc((chapter+cdnParam), CommConst.CDN_SECRET_IV, CommConst.CDN_SECRET_KEY);

                            if(!"".equals(sdUrl)) {
                                sdUrl = CommConst.CDN_URL + SecureUtil.encodeAesCbc((sdUrl+cdnParam), CommConst.CDN_SECRET_IV, CommConst.CDN_SECRET_KEY);
                            }

                        } catch(Exception e) { }
                    }

                    if(idx == -1) {
                        idx = hdUrl.indexOf("/lecture/");
                        if(idx == 0) {
                            hdUrl = CommConst.WEBDATA_CONTEXT + hdUrl;
                        }
                    }

                    String pageInfo = "<page_list>\n";
                    pageInfo += "<page>\n";
                    pageInfo += "<page_cnt>1</page_cnt>\n";
                    pageInfo += "<page_title>"+pageVO.getPageNm()+"</page_title>\n";
                    pageInfo += "<page_source>"+hdUrl+"</page_source>\n";

                    if(!"".equals(sdUrl)) {
                        pageInfo += "<page_source_sd>"+sdUrl+"</page_source_sd>\n";
                    }
                    if(!"".equals(script)) {
                        pageInfo += "<script_xml>"+script+"</script_xml>\n";
                    }
                    if(!"".equals(caption)) {
                        pageInfo += "<track_xml>"+caption+"</track_xml>\n";
                    }
                    if(!"".equals(chapter)) {
                        pageInfo += "<chapter_xml>"+chapter+"</chapter_xml>\n";
                    }

                    pageInfo += "<page_type>video/mp4</page_type>\n";
                    pageInfo += "<study_tm>0</study_tm>\n";
                    pageInfo += "<prgr_ratio>0</prgr_ratio>\n";
                    pageInfo += "<session_loc>0</session_loc>\n";
                    pageInfo += "<study_cnt>1</study_cnt>\n";
                    pageInfo += "<on>false</on>\n";
                    pageInfo += "<videotm>"+videoTm+"</videotm>\n";
                    pageInfo += "<extdata>"+extData+"</extdata>\n";
                    pageInfo += "</page>\n";
                    pageInfo += "</page_list>";
                    
                    model.addAttribute("result", "true");
                    model.addAttribute("pageInfo", pageInfo);
                }
            }
        }
        else {
            model.addAttribute("result", "false");
        }
        return "api/view_content";
    }

    /**
     * 주차별 수강현황(목록)
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/selectWeekList.do")
    public String selectWeekList(ApiListInfoVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String resultStr = "";
        ProcessResultVO<ApiListInfoVO> resultVo = new ProcessResultVO<ApiListInfoVO>();

        try {

            // 현재 페이지 번호 pageIndex
            String pageIndex = StringUtil.nvl(request.getParameter("pageIndex"));
            if("0".equals(pageIndex)) {
                pageIndex = "1";
            }
            vo.setPageIndex(Integer.parseInt(pageIndex));

            // 한 페이지당 게시되는 게시물 건 수 listScale
            String listScale = StringUtil.nvl(request.getParameter("listScale"));
            vo.setListScale(Integer.parseInt(listScale));

            // 입력 날짜 구하기
            String todayDttm = StringUtil.nvl(request.getParameter("todayDttm"));
            vo.setTodayDttm(todayDttm);

            // 제외주차
            String ltOmitWeek = StringUtil.nvl(request.getParameter("ltOmitWeek"));
            vo.setLtOmitWeek(ltOmitWeek);

            // 주차
            String ltWeek = StringUtil.nvl(request.getParameter("ltWeek"));
            vo.setLtWeek(ltWeek);

            String redisKey = "StatStdyWeeksum:"+ltWeek;
            if (CommConst.REDIS_USE && RedisUtil.exists(redisKey)) {
            	long listSize = RedisUtil.getListSize(redisKey);
            	
            	PaginationInfo paginationInfo = new PaginationInfo();
                paginationInfo.setCurrentPageNo(vo.getPageIndex());
                paginationInfo.setRecordCountPerPage(vo.getListScale());
                paginationInfo.setPageSize(vo.getPageScale());
                paginationInfo.setTotalRecordCount(Long.valueOf(listSize).intValue());

                vo.setFirstIndex(paginationInfo.getFirstRecordIndex());
                vo.setLastIndex(paginationInfo.getLastRecordIndex());
            	
            	long startIdx = 0;
            	long endIdx = -1;
            	
            	if (vo.getPageIndex() > 1) {
            		startIdx = vo.getPageIndex() * vo.getListScale();
            	}
            	
            	if (vo.getListScale() > 0) {
            		endIdx = startIdx + vo.getListScale() - 1;
            	}
            	
                List<String> dataList = RedisUtil.getList(redisKey, startIdx, endIdx);

                resultVo.setResult(1);
                resultVo.setPageInfo(paginationInfo);
                resultVo.setReturnVO(vo);
                String jsonStr = JsonUtil.getJsonString(resultVo);
                
                Map<String,Object> jobj = JsonUtil.getJsonObject(jsonStr);
                jobj.put("returnList", dataList);
                
                resultStr = JsonUtil.responseJson(response, jobj);
            }
            else {
            	resultVo = apiService.selectWeekList(vo);
            	resultStr = JsonUtil.responseJson(response, resultVo);
            }
        }
        catch(Exception e) {
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVo.setReturnVO(vo);
        }

        return resultStr;
    }

    /**
     * 학습활동 과제목록
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/selectTotalAsmntList.do")
    public String selectTotalAsmntList(ApiListInfoVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String resultStr = "";
        ProcessResultVO<ApiListInfoVO> resultVo = new ProcessResultVO<ApiListInfoVO>();

        try {

            // 현재 페이지 번호 pageIndex
            String pageIndex = StringUtil.nvl(request.getParameter("pageIndex"));
            if("0".equals(pageIndex)) {
                pageIndex = "1";
            }
            vo.setPageIndex(Integer.parseInt(pageIndex));

            // 한 페이지당 게시되는 게시물 건 수 listScale
            String listScale = StringUtil.nvl(request.getParameter("listScale"));
            vo.setListScale(Integer.parseInt(listScale));

            // 입력 날짜 구하기
            String todayDttm = StringUtil.nvl(request.getParameter("todayDttm"));
            vo.setTodayDttm(todayDttm);

            vo.setOrgId(API_ORG_ID);
            resultVo = apiService.selectTotalAsmntList(vo);

        }
        catch(Exception e) {
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVo.setReturnVO(vo);
        }
        resultStr = JsonUtil.responseJson(response, resultVo);

        return resultStr;
    }

    /**
     * 학습활동 토론목록
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/selectTotalForumList.do")
    public String selectTotalForumList(ApiListInfoVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String resultStr = "";
        ProcessResultVO<ApiListInfoVO> resultVo = new ProcessResultVO<ApiListInfoVO>();

        try {

            // 현재 페이지 번호 pageIndex
            String pageIndex = StringUtil.nvl(request.getParameter("pageIndex"));
            if("0".equals(pageIndex)) {
                pageIndex = "1";
            }
            vo.setPageIndex(Integer.parseInt(pageIndex));

            // 한 페이지당 게시되는 게시물 건 수 listScale
            String listScale = StringUtil.nvl(request.getParameter("listScale"));
            vo.setListScale(Integer.parseInt(listScale));

            // 입력 날짜 구하기
            String todayDttm = StringUtil.nvl(request.getParameter("todayDttm"));
            vo.setTodayDttm(todayDttm);

            vo.setOrgId(API_ORG_ID);
            resultVo = apiService.selectTotalForumList(vo);

        }
        catch(Exception e) {
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVo.setReturnVO(vo);
        }
        resultStr = JsonUtil.responseJson(response, resultVo);

        return resultStr;
    }

    /**
     * 학습활동 퀴즈목록
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/selectTotalQuizList.do")
    public String selectTotalQuizList(ApiListInfoVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String resultStr = "";
        ProcessResultVO<ApiListInfoVO> resultVo = new ProcessResultVO<ApiListInfoVO>();

        try {

            // 현재 페이지 번호 pageIndex
            String pageIndex = StringUtil.nvl(request.getParameter("pageIndex"));
            if("0".equals(pageIndex)) {
                pageIndex = "1";
            }
            vo.setPageIndex(Integer.parseInt(pageIndex));

            // 한 페이지당 게시되는 게시물 건 수 listScale
            String listScale = StringUtil.nvl(request.getParameter("listScale"));
            vo.setListScale(Integer.parseInt(listScale));

            // 입력 날짜 구하기
            String todayDttm = StringUtil.nvl(request.getParameter("todayDttm"));
            vo.setTodayDttm(todayDttm);

            vo.setOrgId(API_ORG_ID);
            resultVo = apiService.selectTotalQuizList(vo);
        }
        catch(Exception e) {
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVo.setReturnVO(vo);
        }
        resultStr = JsonUtil.responseJson(response, resultVo);

        return resultStr;
    }

    /**
     * 학습활동 설문목록
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/selectTotalReschList.do")
    public String selectTotalReschList(ApiListInfoVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String resultStr = "";
        ProcessResultVO<ApiListInfoVO> resultVo = new ProcessResultVO<ApiListInfoVO>();

        try {

            // 현재 페이지 번호 pageIndex
            String pageIndex = StringUtil.nvl(request.getParameter("pageIndex"));
            if("0".equals(pageIndex)) {
                pageIndex = "1";
            }            
            vo.setPageIndex(Integer.parseInt(pageIndex));

            // 한 페이지당 게시되는 게시물 건 수 listScale
            String listScale = StringUtil.nvl(request.getParameter("listScale"));
            vo.setListScale(Integer.parseInt(listScale));

            // 입력 날짜 구하기
            String todayDttm = StringUtil.nvl(request.getParameter("todayDttm"));
            vo.setTodayDttm(todayDttm);

            vo.setOrgId(API_ORG_ID);
            resultVo = apiService.selectTotalReschList(vo);
        }
        catch(Exception e) {
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVo.setReturnVO(vo);
        }
        resultStr = JsonUtil.responseJson(response, resultVo);

        return resultStr;
    }

    /**
     * 학습활동 세미나목록
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/selectTotalSeminarList.do")
    public String selectTotalSeminarList(ApiListInfoVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String resultStr = "";
        ProcessResultVO<ApiListInfoVO> resultVo = new ProcessResultVO<ApiListInfoVO>();

        try {

            // 현재 페이지 번호 pageIndex
            String pageIndex = StringUtil.nvl(request.getParameter("pageIndex"));
            if("0".equals(pageIndex)) {
                pageIndex = "1";
            }
            vo.setPageIndex(Integer.parseInt(pageIndex));

            // 한 페이지당 게시되는 게시물 건 수 listScale
            String listScale = StringUtil.nvl(request.getParameter("listScale"));
            vo.setListScale(Integer.parseInt(listScale));

            // 입력 날짜 구하기
            String todayDttm = StringUtil.nvl(request.getParameter("todayDttm"));
            vo.setTodayDttm(todayDttm);

            vo.setOrgId(API_ORG_ID);
            resultVo = apiService.selectTotalSeminarList(vo);
        }
        catch(Exception e) {
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVo.setReturnVO(vo);
        }
        resultStr = JsonUtil.responseJson(response, resultVo);

        return resultStr;
    }

    /**
     * 학습진도 목록
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/selectLearnProgressList.do")
    public String selectLearnProgressList(ApiListInfoVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String resultStr = "";
        ProcessResultVO<ApiListInfoVO> resultVo = new ProcessResultVO<ApiListInfoVO>();

        try {

            // 현재 페이지 번호 pageIndex
            String pageIndex = StringUtil.nvl(request.getParameter("pageIndex"));
            if("0".equals(pageIndex)) {
                pageIndex = "1";
            }
            vo.setPageIndex(Integer.parseInt(pageIndex));

            // 한 페이지당 게시되는 게시물 건 수 listScale
            String listScale = StringUtil.nvl(request.getParameter("listScale"));
            vo.setListScale(Integer.parseInt(listScale));

            // 입력 날짜 구하기
            String todayDttm = StringUtil.nvl(request.getParameter("todayDttm"));
            vo.setTodayDttm(todayDttm);

            resultVo = apiService.selectLearnProgressList(vo);

        }
        catch(Exception e) {
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVo.setReturnVO(vo);
        }
        resultStr = JsonUtil.responseJson(response, resultVo);

        return resultStr;
    }

    /**
     * 학습활동이력  과제목록
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/selectAcademyAsmntList.do")
    public String selectAcademyAsmntList(ApiListInfoVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String resultStr = "";
        ProcessResultVO<ApiListInfoVO> resultVo = new ProcessResultVO<ApiListInfoVO>();

        try {

            // 현재 페이지 번호 pageIndex
            String pageIndex = StringUtil.nvl(request.getParameter("pageIndex"));
            if("0".equals(pageIndex)) {
                pageIndex = "1";
            }
            vo.setPageIndex(Integer.parseInt(pageIndex));

            // 한 페이지당 게시되는 게시물 건 수 listScale
            String listScale = StringUtil.nvl(request.getParameter("listScale"));
            vo.setListScale(Integer.parseInt(listScale));

            // 입력 날짜 구하기
            String todayDttm = StringUtil.nvl(request.getParameter("todayDttm"));
            vo.setTodayDttm(todayDttm);

            vo.setOrgId(API_ORG_ID);
            resultVo = apiService.selectAcademyAsmntList(vo);

        }
        catch(Exception e) {
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVo.setReturnVO(vo);
        }
        resultStr = JsonUtil.responseJson(response, resultVo);

        return resultStr;
    }

    /**
     * 학습활동이력  토론목록
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/selectAcademyForumList.do")
    public String selectAcademyForumList(ApiListInfoVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String resultStr = "";
        ProcessResultVO<ApiListInfoVO> resultVo = new ProcessResultVO<ApiListInfoVO>();

        try {

            // 현재 페이지 번호 pageIndex
            String pageIndex = StringUtil.nvl(request.getParameter("pageIndex"));
            if("0".equals(pageIndex)) {
                pageIndex = "1";
            }
            vo.setPageIndex(Integer.parseInt(pageIndex));

            // 한 페이지당 게시되는 게시물 건 수 listScale
            String listScale = StringUtil.nvl(request.getParameter("listScale"));
            vo.setListScale(Integer.parseInt(listScale));

            // 입력 날짜 구하기
            String todayDttm = StringUtil.nvl(request.getParameter("todayDttm"));
            vo.setTodayDttm(todayDttm);

            vo.setOrgId(API_ORG_ID);
            resultVo = apiService.selectAcademyForumList(vo);

        }
        catch(Exception e) {
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVo.setReturnVO(vo);
        }
        resultStr = JsonUtil.responseJson(response, resultVo);

        return resultStr;
    }

    /**
     * 학습활동이력  퀴즈목록
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/selectAcademyQuizList.do")
    public String selectAcademyQuizList(ApiListInfoVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String resultStr = "";
        ProcessResultVO<ApiListInfoVO> resultVo = new ProcessResultVO<ApiListInfoVO>();

        try {

            // 현재 페이지 번호 pageIndex
            String pageIndex = StringUtil.nvl(request.getParameter("pageIndex"));
            if("0".equals(pageIndex)) {
                pageIndex = "1";
            }
            vo.setPageIndex(Integer.parseInt(pageIndex));

            // 한 페이지당 게시되는 게시물 건 수 listScale
            String listScale = StringUtil.nvl(request.getParameter("listScale"));
            vo.setListScale(Integer.parseInt(listScale));

            // 입력 날짜 구하기
            String todayDttm = StringUtil.nvl(request.getParameter("todayDttm"));
            vo.setTodayDttm(todayDttm);

            vo.setOrgId(API_ORG_ID);
            resultVo = apiService.selectAcademyQuizList(vo);
        }
        catch(Exception e) {
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVo.setReturnVO(vo);
        }
        resultStr = JsonUtil.responseJson(response, resultVo);

        return resultStr;
    }

    /**
     * 학습활동이력  설문목록
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/selectAcademyReschList.do")
    public String selectAcademyReschList(ApiListInfoVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String resultStr = "";
        ProcessResultVO<ApiListInfoVO> resultVo = new ProcessResultVO<ApiListInfoVO>();

        try {

            // 현재 페이지 번호 pageIndex
            String pageIndex = StringUtil.nvl(request.getParameter("pageIndex"));
            if("0".equals(pageIndex)) {
                pageIndex = "1";
            }            
            vo.setPageIndex(Integer.parseInt(pageIndex));

            // 한 페이지당 게시되는 게시물 건 수 listScale
            String listScale = StringUtil.nvl(request.getParameter("listScale"));
            vo.setListScale(Integer.parseInt(listScale));

            // 입력 날짜 구하기
            String todayDttm = StringUtil.nvl(request.getParameter("todayDttm"));
            vo.setTodayDttm(todayDttm);

            vo.setOrgId(API_ORG_ID);
            resultVo = apiService.selectAcademyReschList(vo);
        }
        catch(Exception e) {
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVo.setReturnVO(vo);
        }
        resultStr = JsonUtil.responseJson(response, resultVo);

        return resultStr;
    }

    /**
     * 학습활동이력  세미나목록
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/selectAcademySeminarList.do")
    public String selectAcademySeminarList(ApiListInfoVO vo, HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {

        String resultStr = "";
        ProcessResultVO<ApiListInfoVO> resultVo = new ProcessResultVO<ApiListInfoVO>();

        try {

            // 현재 페이지 번호 pageIndex
            String pageIndex = StringUtil.nvl(request.getParameter("pageIndex"));
            if("0".equals(pageIndex)) {
                pageIndex = "1";
            }
            vo.setPageIndex(Integer.parseInt(pageIndex));

            // 한 페이지당 게시되는 게시물 건 수 listScale
            String listScale = StringUtil.nvl(request.getParameter("listScale"));
            vo.setListScale(Integer.parseInt(listScale));

            // 입력 날짜 구하기
            String todayDttm = StringUtil.nvl(request.getParameter("todayDttm"));
            vo.setTodayDttm(todayDttm);

            vo.setOrgId(API_ORG_ID);
            resultVo = apiService.selectAcademySeminarList(vo);
        }
        catch(Exception e) {
            resultVo.setResult(-1);
            resultVo.setMessage(e.getMessage().split(":")[1].replaceAll(" ", ""));
            resultVo.setReturnVO(vo);
        }
        resultStr = JsonUtil.responseJson(response, resultVo);

        return resultStr;
    }

    
    /**
     * test
     * @param request
     * @param response
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/apiTest.do")
    public String apiTest(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception {
    	return "api/api_test";
    }
}
