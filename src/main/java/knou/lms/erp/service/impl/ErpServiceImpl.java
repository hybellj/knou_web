package knou.lms.erp.service.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.framework.common.SessionInfo;
import knou.framework.exception.ServiceProcessException;
import knou.framework.util.CommonUtil;
import knou.framework.util.IdGenerator;
import knou.framework.util.LocaleUtil;
import knou.framework.util.StringUtil;
import knou.framework.util.ValidationUtils;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.erp.daoErp.ErpDAO;
import knou.lms.erp.service.ErpService;
import knou.lms.erp.vo.AlarmMainVO;
import knou.lms.erp.vo.AlarmSmsLogVO;
import knou.lms.erp.vo.AlarmSmsVO;
import knou.lms.erp.vo.ErpBsns110VO;
import knou.lms.erp.vo.ErpBsns111VO;
import knou.lms.erp.vo.ErpEnrollmentVO;
import knou.lms.erp.vo.ErpLcdmsCntsVO;
import knou.lms.erp.vo.ErpLcdmsPageVO;
import knou.lms.erp.vo.ErpMessageMsgVO;
import knou.lms.erp.vo.ErpMessagePushVO;
import knou.lms.erp.vo.ErpScoreTestVO;
import knou.lms.user.vo.UsrUserInfoVO;

@Service("erpService")
public class ErpServiceImpl extends ServiceBase implements ErpService {
    private static final Logger LOGGER = LoggerFactory.getLogger(ErpServiceImpl.class);
    
    @Resource(name = "erpDAO")
    private ErpDAO erpDAO;
    
    @Resource(name="messageSource")
    private MessageSource messageSource;
    
    /**
     * 과목 수강 정보 조회
     * @param vo
     * @return
     * @throws Exception
     */
    @Override
    public ErpEnrollmentVO selectCourseEnrollment(ErpEnrollmentVO vo) throws Exception {
        return erpDAO.selectCourseEnrollment(vo);
    }
    
    /**
     * 사용자의 과목 수강 목록 조회
     * @param vo
     * @return List<ErpEnrollmentVO>
     * @throws Exception
     */
    @Override
    public List<ErpEnrollmentVO> listUserEnrollment(ErpEnrollmentVO vo) throws Exception {
        return erpDAO.listUserEnrollment(vo);
    }
    
    /**
     * 쪽지 사용자 발송
     * @param request
     * @param vo
     * @param logDesc
     * @throws Exception
     */
    public void insertUserMessageMsg(HttpServletRequest request, ErpMessageMsgVO vo, String logDesc) throws Exception {
        // 한사대만 가능
        if(SessionInfo.isKnou(request)) {
            vo.setBussGbn("LMS");
            vo.setLogDesc(logDesc);
            this.insertMessageMsg(request, vo);
        }
    }
    
    /**
     * 쪽지 시스템 발송
     * @param request
     * @param vo
     * @param logDesc
     * @throws Exception
     */
    public void insertSysMessageMsg(HttpServletRequest request, ErpMessageMsgVO vo, String logDesc) throws Exception {
        // 한사대만 가능
        if(SessionInfo.isKnou(request)) {
            vo.setBussGbn("LMS_SYS");
            vo.setLogDesc(logDesc);
            this.insertMessageMsg(request, vo);
        }
    }
    
    /**
     * 쪽지 발송
     * 단건필수 (userId, userNm, ctnt)
     * 다건필수 (usrUserInfoList, ctnt)
     * 선택 (crsCreCd)
     * @param messageList
     * @throws Exception
     */
    private void insertMessageMsg(HttpServletRequest request, ErpMessageMsgVO vo) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        
        String crsCreCd = vo.getCrsCreCd();
        String ctnt = vo.getCtnt();
        String bussGbn = StringUtil.nvl(vo.getBussGbn(), "LMS");
        String logDesc = StringUtil.nvl(vo.getLogDesc(), "LMS 쪽지 발송");
        List<UsrUserInfoVO> usrUserInfoList = vo.getUsrUserInfoList(); // 수신자 목록
        
        if(ValidationUtils.isEmpty(ctnt)) {
            // 내용을 입력하세요.
            throw new ServiceProcessException(messageSource.getMessage("common.empty.msg", null, locale));
        }
        
        String sndrPersNo = SessionInfo.getUserId(request).length() > 11 ? SessionInfo.getUserId(request).substring(0,11) : SessionInfo.getUserId(request);
        String msgNo = IdGenerator.getNewId("MSG");
        int msgSeq = 1;
        
        List<ErpMessageMsgVO> messageList = new ArrayList<>();
        ErpMessageMsgVO msgVO = new ErpMessageMsgVO();
        msgVO.setMsgLogNo(IdGenerator.getNewId("MGLOG"));
        msgVO.setMsgSeq(msgNo + String.format("%05d", msgSeq));
        msgVO.setUserId(SessionInfo.getUserId(request));
        msgVO.setUserNm(SessionInfo.getUserNm(request));
        msgVO.setSysCd("LMS");
        msgVO.setOrgId("KNOU");
        msgVO.setBussGbn(bussGbn);
        msgVO.setSendRcvGbn("S");
        msgVO.setCtnt(ctnt);
        msgVO.setSndrDeptCd(SessionInfo.getUserDeptId(request));
        msgVO.setSndrPersNo(sndrPersNo);
        msgVO.setSndrNm(SessionInfo.getUserNm(request));
        msgVO.setReadYn("N");
        msgVO.setRgtrId(SessionInfo.getUserId(request));
        msgVO.setRegIp(CommonUtil.getIpAddress(request));
        msgVO.setMsgNo(msgNo);
        msgVO.setRcvNum(1);
        msgVO.setLogDesc(logDesc);
        msgVO.setCourseCd(crsCreCd);
        messageList.add(msgVO);
        
        if(usrUserInfoList != null && usrUserInfoList.size() > 0) {
            /* 목록 발송 */
            int rcvNum = 0;
            
            Set<String> dupCheckSet = new HashSet<>();
            
            for(UsrUserInfoVO userResvInfoVO : usrUserInfoList) {
                String recvUserId = userResvInfoVO.getUserId();
                String recvUserNm = userResvInfoVO.getUserNm();
                
                // 수신자 정보가 있는경우만 발송
                if(ValidationUtils.isNotEmpty(recvUserId) && ValidationUtils.isNotEmpty(recvUserNm)) {
                    // 중복체크
                    if(dupCheckSet.contains(recvUserId)) {
                        continue;
                    } else {
                        dupCheckSet.add(recvUserId);
                    }
                    
                    rcvNum++;
                    msgSeq++;
                    
                    msgVO = new ErpMessageMsgVO();
                    msgVO.setMsgNo(msgNo);
                    msgVO.setMsgSeq(msgNo + String.format("%05d", msgSeq));
                    msgVO.setUserId(recvUserId);
                    msgVO.setUserNm(recvUserNm);
                    msgVO.setSysCd("LMS");
                    msgVO.setOrgId("KNOU");
                    msgVO.setBussGbn(bussGbn);
                    msgVO.setSendRcvGbn("R");
                    msgVO.setCtnt(ctnt);
                    msgVO.setSndrDeptCd(SessionInfo.getUserDeptId(request));
                    msgVO.setSndrPersNo(sndrPersNo);
                    msgVO.setSndrNm(SessionInfo.getUserNm(request));
                    msgVO.setReadYn("N");
                    msgVO.setRgtrId(SessionInfo.getUserId(request));
                    msgVO.setRegIp(CommonUtil.getIpAddress(request));
                    msgVO.setCourseCd(crsCreCd);
                    messageList.add(msgVO);
                }
            }
            
            // 수신자 정보가 있는경우만 발송
            if(rcvNum > 0) {
                messageList.get(0).setRcvNum(rcvNum);
                
                this.insertMessageMsgList(messageList);
            }
        } else {
            String recvUserId = vo.getUserId();
            String recvUserNm = vo.getUserNm();
            
            if(ValidationUtils.isEmpty(recvUserId) || ValidationUtils.isEmpty(recvUserNm)) {
                // 잘못된 요청으로 오류가 발생하였습니다.
                throw new ServiceProcessException(messageSource.getMessage("system.fail.badrequest.nomethod", null, locale));
            }
            
            msgSeq++;
            
            msgVO = new ErpMessageMsgVO();
            msgVO.setMsgNo(msgNo);
            msgVO.setMsgSeq(msgNo + String.format("%05d", msgSeq));
            msgVO.setUserId(recvUserId);
            msgVO.setUserNm(recvUserNm);
            msgVO.setSysCd("LMS");
            msgVO.setOrgId("KNOU");
            msgVO.setBussGbn(bussGbn);
            msgVO.setSendRcvGbn("R");
            msgVO.setCtnt(ctnt);
            msgVO.setSndrDeptCd(SessionInfo.getUserDeptId(request));
            msgVO.setSndrPersNo(sndrPersNo);
            msgVO.setSndrNm(SessionInfo.getUserNm(request));
            msgVO.setReadYn("N");
            msgVO.setRgtrId(SessionInfo.getUserId(request));
            msgVO.setRegIp(CommonUtil.getIpAddress(request));
            msgVO.setCourseCd(crsCreCd);
            messageList.add(msgVO);
            
            this.insertMessageMsgList(messageList);
        }
    }
    
    /**
     * 쪽지목록 발송
     * @param messageList
     * @throws Exception
     */
    private void insertMessageMsgList(List<ErpMessageMsgVO> messageList) throws Exception {
        // 쪽지 목록 저장
        erpDAO.insertMessageMsgList(messageList);
        
        // 쪽지 발송 로그 저장
        erpDAO.insertMessageMsgLog(messageList.get(0));
    }
    
    /**
     * PUSH 시스템 발송
     * @param request
     * @param vo
     * @param logDesc
     * @throws Exception
     */
    public void insertSysMessagePush(HttpServletRequest request, ErpMessagePushVO vo, String logDesc) throws Exception {
        // 한사대만 가능
        if(SessionInfo.isKnou(request)) {
            vo.setBussGbn("LMS_SYS");
            vo.setLogDesc(logDesc);
            this.insertMessagePush(request, vo);
        }
    }
    
    /**
     * PUSH 발송
     * 단건필수 (userId, userNm, rcvPhoneNo , subject, ctnt)
     * 다건필수 (usrUserInfoList, subject, ctnt)
     * 선택 (crsCreCd, sendDttm)
     * sendDttm 없는경우 [시간 00:00 ~ 09:00 는 09:00 예약발송], 나머지 즉시발송
     * @param request
     * @param vo
     * @throws Exception
     */
    private void insertMessagePush(HttpServletRequest request, ErpMessagePushVO vo) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        
        String crsCreCd = vo.getCrsCreCd();
        List<UsrUserInfoVO> usrUserInfoList = vo.getUsrUserInfoList(); // 수신자 목록
        String subject = vo.getSubject();
        String ctnt = vo.getCtnt();
        String sndrPhoneNo = StringUtil.nvl(vo.getSndrPhoneNo(), "02-2290-0114");
        String sendDttm = vo.getSendDttm();
        String bussGbn = StringUtil.nvl(vo.getBussGbn(), "LMS");
        String logDesc = StringUtil.nvl(vo.getLogDesc(), "LMS PUSH 발송");
        
        if(ValidationUtils.isEmpty(subject)) {
            // 제목을 입력하세요.
            throw new ServiceProcessException(messageSource.getMessage("common.pop.input.title", null, locale));
        }
        
        if(ValidationUtils.isEmpty(ctnt)) {
            // 내용을 입력하세요.
            throw new ServiceProcessException(messageSource.getMessage("common.empty.msg", null, locale));
        }
        
        if(ValidationUtils.isEmpty(sendDttm)) {
            Calendar calendar = Calendar.getInstance();
            Date currentDate = calendar.getTime();

            // 시간을 09:00으로 설정합니다.
            calendar.set(Calendar.HOUR_OF_DAY, 9);
            calendar.set(Calendar.MINUTE, 0);
            calendar.set(Calendar.SECOND, 0);

            // 현재 시간이 09:00 이전이면 시간을 09:00으로 설정합니다.
            if (currentDate.before(calendar.getTime())) {
                // 날짜를 yyyyMMddHHmmss 형식으로 포맷합니다.
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                sendDttm = dateFormat.format(calendar.getTime());
            }
        } else {
            SimpleDateFormat inputFormat = new SimpleDateFormat("yyyyMMddHHmmss");
            SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            Date date = inputFormat.parse(sendDttm);
            sendDttm = outputFormat.format(date);
        }
        
        String sndrPersNo = SessionInfo.getUserId(request).length() > 11 ? SessionInfo.getUserId(request).substring(0,11) : SessionInfo.getUserId(request);
        String pushNo = IdGenerator.getNewId("PUSH");
        int msgSeq = 1;

        List<ErpMessagePushVO> pushList = new ArrayList<>();
        
        // 발신자
        ErpMessagePushVO pushVO = new ErpMessagePushVO();
        pushVO.setPushNo(pushNo);
        pushVO.setPushSeq(pushNo + String.format("%05d", msgSeq));
        pushVO.setUserId(SessionInfo.getUserId(request));
        pushVO.setUserNm(SessionInfo.getUserNm(request));
        pushVO.setSysCd("LMS");
        pushVO.setOrgId("KNOU");
        pushVO.setBussGbn(bussGbn);
        pushVO.setSendRcvGbn("S");
        pushVO.setSubject(subject);
        pushVO.setCtnt(ctnt);
        pushVO.setSendDttm(sendDttm);
        pushVO.setSndrPersNo(sndrPersNo);
        pushVO.setSndrDeptCd(SessionInfo.getUserDeptId(request));
        pushVO.setSndrNm(SessionInfo.getUserNm(request));
        pushVO.setSndrPhoneNo(sndrPhoneNo);
        pushVO.setRcvPhoneNo("");
        pushVO.setCourseCd(crsCreCd);
        pushVO.setRgtrId(SessionInfo.getUserId(request));
        pushVO.setRegIp(CommonUtil.getIpAddress(request));
        pushVO.setMdfrId(SessionInfo.getUserId(request));
        pushVO.setModIp(CommonUtil.getIpAddress(request));
        
        pushVO.setPushLogNo(IdGenerator.getNewId("PHLOG"));
        pushVO.setLogGbn("S");
        pushVO.setRcvNum(1);
        pushVO.setLogDesc(logDesc);
        pushList.add(pushVO);
        
        if(usrUserInfoList != null && usrUserInfoList.size() > 0) {
            /* 목록 발송 */
            int rcvNum = 0;
            
            Set<String> dupCheckSet = new HashSet<>();
            
            for(UsrUserInfoVO userResvInfoVO : usrUserInfoList) {
                String recvUserId = userResvInfoVO.getUserId();
                String recvUserNm = userResvInfoVO.getUserNm();
                String recvMobileNo = userResvInfoVO.getMobileNo();
                
                // 수신자 정보가 있는경우만 발송
                if(ValidationUtils.isNotEmpty(recvUserId) && ValidationUtils.isNotEmpty(recvUserNm) && ValidationUtils.isNotEmpty(recvMobileNo)) {
                    // 중복체크
                    if(dupCheckSet.contains(recvUserId)) {
                        continue;
                    } else {
                        dupCheckSet.add(recvUserId);
                    }
                    
                    rcvNum++;
                    msgSeq++;
                    
                    pushVO = new ErpMessagePushVO();
                    pushVO.setPushNo(pushNo);
                    pushVO.setPushSeq(pushNo + String.format("%05d", msgSeq));
                    pushVO.setUserId(recvUserId);
                    pushVO.setUserNm(recvUserNm);
                    pushVO.setSysCd("LMS");
                    pushVO.setOrgId("KNOU");
                    pushVO.setBussGbn(bussGbn);
                    pushVO.setSendRcvGbn("R");
                    pushVO.setSubject(subject);
                    pushVO.setCtnt(ctnt);
                    pushVO.setSendDttm(sendDttm);
                    pushVO.setSndrPersNo(sndrPersNo);
                    pushVO.setSndrDeptCd(SessionInfo.getUserDeptId(request));
                    pushVO.setSndrNm(SessionInfo.getUserNm(request));
                    pushVO.setSndrPhoneNo(sndrPhoneNo);
                    pushVO.setRcvPhoneNo(recvMobileNo);
                    pushVO.setCourseCd(crsCreCd);
                    pushVO.setRgtrId(SessionInfo.getUserId(request));
                    pushVO.setRegIp(CommonUtil.getIpAddress(request));
                    pushVO.setMdfrId(SessionInfo.getUserId(request));
                    pushVO.setModIp(CommonUtil.getIpAddress(request));
                    
                    pushList.add(pushVO);
                }
            }
            
            // 수신자 정보가 있는경우만 발송
            if(rcvNum > 0) {
                pushList.get(0).setRcvNum(rcvNum);
                
                this.insertMessagePushList(pushList);
            }
        } else {
            /* 단건 발송 */
            String recvUserId = vo.getUserId();
            String recvUserNm = vo.getUserNm();
            String recvMobileNo = vo.getRcvPhoneNo();
            
            if(ValidationUtils.isEmpty(recvUserId) || ValidationUtils.isEmpty(recvUserNm)) {
                // 잘못된 요청으로 오류가 발생하였습니다.
                throw new ServiceProcessException(messageSource.getMessage("system.fail.badrequest.nomethod", null, locale));
            }
            
            // 수신자 전화번호가 있는경우만 발송
            if(ValidationUtils.isNotEmpty(recvMobileNo)) {
                // 수신자
                msgSeq++;
                
                pushVO = new ErpMessagePushVO();
                pushVO.setPushNo(pushNo);
                pushVO.setPushSeq(pushNo + String.format("%05d", msgSeq));
                pushVO.setUserId(recvUserId);
                pushVO.setUserNm(recvUserNm);
                pushVO.setSysCd("LMS");
                pushVO.setOrgId("KNOU");
                pushVO.setBussGbn(bussGbn);
                pushVO.setSendRcvGbn("R");
                pushVO.setSubject(subject);
                pushVO.setCtnt(ctnt);
                pushVO.setSendDttm(sendDttm);
                pushVO.setSndrPersNo(sndrPersNo);
                pushVO.setSndrDeptCd(SessionInfo.getUserDeptId(request));
                pushVO.setSndrNm(SessionInfo.getUserNm(request));
                pushVO.setSndrPhoneNo(sndrPhoneNo);
                pushVO.setRcvPhoneNo(recvMobileNo);
                pushVO.setCourseCd(crsCreCd);
                pushVO.setRgtrId(SessionInfo.getUserId(request));
                pushVO.setRegIp(CommonUtil.getIpAddress(request));
                pushVO.setMdfrId(SessionInfo.getUserId(request));
                pushVO.setModIp(CommonUtil.getIpAddress(request));
                
                pushList.add(pushVO);
                
                this.insertMessagePushList(pushList);
            }
        }
    }
    
    /**
     * PUSH 목록 발송
     * @param messageList
     * @throws Exception
     */
    private void insertMessagePushList(List<ErpMessagePushVO> messageList) throws Exception {
        int batchSize = 500;
        
        // PUSH 목록 저장
        for(int i = 0; i < messageList.size(); i += batchSize) {
            int endIndex = Math.min(i + batchSize, messageList.size());
            List<ErpMessagePushVO> sublist = messageList.subList(i, endIndex);
            
            erpDAO.insertMessagePushList(sublist);
        }
        
        List<ErpBsns111VO> bsns111List = new ArrayList<>();
        for(ErpMessagePushVO erpMessagePushVO : messageList) {
            if("S".equals(erpMessagePushVO.getSendRcvGbn())) {
                // PUSH 발송 로그 저장
                erpDAO.insertMessagePushLog(erpMessagePushVO);
                
                ErpBsns110VO bsns110VO = new ErpBsns110VO();
                bsns110VO.setSendNo(erpMessagePushVO.getPushNo());              //발송번호
                bsns110VO.setSendDttm(erpMessagePushVO.getSendDttm());          //발송일시
                bsns110VO.setBussGbn(erpMessagePushVO.getBussGbn());            //업무구분
                bsns110VO.setPushCategGbn("1");                                 //PUSH카테고리구분 (1: 학교알림(필수), 2: 학교알림(선택), 3: 시스템알림, 4: 학사알림)
                bsns110VO.setSndrPersNo(erpMessagePushVO.getSndrPersNo());      //발송자개인번호
                bsns110VO.setSndrDeptCd(erpMessagePushVO.getSndrDeptCd());      //발송자부서코드
                bsns110VO.setSndrNm(erpMessagePushVO.getSndrNm());              //발송자명
                bsns110VO.setSndrHandpNo(erpMessagePushVO.getSndrPhoneNo());    //발송자전화번호
                bsns110VO.setSubject(erpMessagePushVO.getSubject());            //제목
                bsns110VO.setPushCtnt(erpMessagePushVO.getCtnt());              //PUSH내용
                bsns110VO.setSmsCtnt("");                                       //SMS내용
                bsns110VO.setSendGbn("1");                                      //발송구분
                bsns110VO.setSendYn("0");                                       //발송여부
                bsns110VO.setAttachNo("");                                      //첨부파일번호
                bsns110VO.setUserDataVal1("");                                  //사용자데이터값1
                bsns110VO.setUserDataVal2("");                                  //사용자데이터값2
                bsns110VO.setUserDataVal3("");                                  //사용자데이터값3
                bsns110VO.setInptId(erpMessagePushVO.getRgtrId());               //입력ID
                bsns110VO.setInptIp(erpMessagePushVO.getRegIp());               //입력IP
                bsns110VO.setInptMenuId("LMS");                                 //입력메뉴ID
                bsns110VO.setModId(erpMessagePushVO.getRgtrId());                //수정ID
                bsns110VO.setModIp(erpMessagePushVO.getRegIp());                //수정IP
                bsns110VO.setModMenuId("LMS");                                  //수정메뉴ID
                
                // 학사 연계 SMS, PUSH 보내는 정보 저장
                erpDAO.insertBsns110(bsns110VO);
            } else {
                ErpBsns111VO bsns111VO = new ErpBsns111VO();
                bsns111VO.setSendNo(erpMessagePushVO.getPushNo());              //발송번호 
                bsns111VO.setSendSeq(erpMessagePushVO.getPushSeq());            //발송순번 
                bsns111VO.setRecprPersNo(erpMessagePushVO.getUserId());         //수신자개인번호 
                bsns111VO.setRecprNm(erpMessagePushVO.getUserNm());             //수신자명 
                bsns111VO.setRecprHandpNo(erpMessagePushVO.getRcvPhoneNo());    //수신자휴대전화번호 
                bsns111VO.setSendDttm(erpMessagePushVO.getSendDttm());          //발송일시 
                bsns111VO.setSmsSendRsltCtnt("00");                             //sms발송결과내용 
                bsns111VO.setPushSendRsltCtnt("00");                            //push발송결과내용
                bsns111VO.setSmsCtnt("");                                       //sms내용 
                bsns111VO.setPushCtnt(erpMessagePushVO.getCtnt());              //push내용 
                bsns111VO.setInptId(erpMessagePushVO.getRgtrId());               //입력id
                bsns111VO.setInptIp(erpMessagePushVO.getRegIp());               //입력ip
                bsns111VO.setInptMenuId("LMS");                                 //입력메뉴id 
                bsns111VO.setModId(erpMessagePushVO.getRgtrId());                //수정id 
                bsns111VO.setModIp(erpMessagePushVO.getRegIp());                //수정ip 
                bsns111VO.setModMenuId("LMS");                                  //수정메뉴id 
                bsns111VO.setCfmYn("0");                                        //확인여부
                
                bsns111List.add(bsns111VO);
            }
        }
        
        // 학사 연계 SMS, PUSH 받는 정보 저장
        for(int i = 0; i < bsns111List.size(); i += batchSize) {
            int endIndex = Math.min(i + batchSize, bsns111List.size());
            List<ErpBsns111VO> sublist = bsns111List.subList(i, endIndex);
            
            erpDAO.insertBsns111List(sublist);
        }
    }
    
    /**
     * 콘텐츠 정보 조회
     * @param ErpLcdmsPageVO
     * @throws Exception
     */
    public ErpLcdmsPageVO selectContentsInfo(ErpLcdmsPageVO vo) throws Exception {
        return erpDAO.selectContentsInfo(vo);
    }
    
    /**
     * 미리보기 콘텐츠 정보 조회
     * @param ErpLcdmsPageVO
     * @throws Exception
     */
    public ErpLcdmsPageVO selectContentsPreviewInfo(ErpLcdmsPageVO vo) throws Exception {
        return erpDAO.selectContentsPreviewInfo(vo);
    }
    
    /**
     * SMS 발송
     * @param List<ErpMessageSmsVO>
     * @throws Exception
     */
    /*
    public void insertMessageSms(List<ErpMessageSmsVO> list) throws Exception {
        String smsNo = "";
        String smsSeq = "";
        int seq = 1;
        String smsLogNo = "";
        
        for (ErpMessageSmsVO erpMessageSmsVO : list) {
            
            if ("S".equals(erpMessageSmsVO.getSendRcvGbn()))
                smsNo = IdGenerator.getNewId("SMS");
            
            smsSeq = String.format("%06d", seq);
            smsSeq = smsNo + smsSeq;
            
            erpMessageSmsVO.setSmsNo(smsNo);
            erpMessageSmsVO.setSmsSeq(smsSeq);

            if (seq == 1) {
                // 수신자가 한명이어도 쿼리 두번실행 첫번째는 로그인한 사용자 정보
                erpDAO.insertMessageSms(erpMessageSmsVO); //SMS 테이블 입력
                
            } else {
                
                // 두번째 부터 받는 사용자 정보
                // System.out.println(" alarmSmsVO.getRcvNo() :: "+alarmSmsVO.getRcvNo());
                // System.out.println(" alarmSmsVO.getRcvPhoneNo() :: "+alarmSmsVO.getRcvPhoneNo());
                
                // 발송자 전화번호를 수신자의 학번으로 조회해서 별도의 테이블을 조회해서 입력
                erpMessageSmsVO.setRcvNo(erpMessageSmsVO.getRcvNo());
                
                erpDAO.insertMessageSmsTwo(erpMessageSmsVO); //SMS 테이블 입력
            }
            
            ErpMessageSmsLogVO erpMessageSmsLogVO = new ErpMessageSmsLogVO();
            

            if ("S".equals(erpMessageSmsVO.getSendRcvGbn())) {
                
                smsLogNo = IdGenerator.getNewId("SMLOG");
                erpMessageSmsLogVO.setSmsLogNo(smsLogNo);                               //SMS로그번호
                erpMessageSmsLogVO.setSmsNo(smsNo);                                     //SMS번호
                erpMessageSmsLogVO.setLogGbn("S");                                      //로그구분
                erpMessageSmsLogVO.setUserId(erpMessageSmsVO.getUserId());              //사용자번호
                erpMessageSmsLogVO.setUserNm(erpMessageSmsVO.getUserNm());              //사용자이름
                erpMessageSmsLogVO.setSysCd(erpMessageSmsVO.getSysCd());                //시스템코드
                erpMessageSmsLogVO.setOrgId(erpMessageSmsVO.getOrgId());                //기관코드
                erpMessageSmsLogVO.setBussGbn(erpMessageSmsVO.getBussGbn());            //업무구분
                erpMessageSmsLogVO.setSubject(erpMessageSmsVO.getSubject());            //제목
                erpMessageSmsLogVO.setCtnt(erpMessageSmsVO.getCtnt());                  //내용
                erpMessageSmsLogVO.setSendDttm(erpMessageSmsVO.getSendDttm());          //발송일시
                erpMessageSmsLogVO.setSndrPersNo(erpMessageSmsVO.getSndrPersNo());      //발송자개인번호
                erpMessageSmsLogVO.setSndrDeptCd(erpMessageSmsVO.getSndrDeptCd());      //발송자부서코드
                erpMessageSmsLogVO.setSndrNm(erpMessageSmsVO.getSndrNm());              //발송자명
                erpMessageSmsLogVO.setSndrPhoneNo(erpMessageSmsVO.getSndrPhoneNo());    //발송자전화번호
                erpMessageSmsLogVO.setRcvNum((list.size()-1));         //대상자수
                erpMessageSmsLogVO.setLogDesc(erpMessageSmsVO.getLogDesc());            //로그설명
                erpMessageSmsLogVO.setRgtrId(erpMessageSmsVO.getRgtrId());                //등록자번호
                erpMessageSmsLogVO.setRegIp(erpMessageSmsVO.getRegIp());                //등록IP
                
                erpDAO.insertMessageSmsLog(erpMessageSmsLogVO);             //SMS 이력 테이블 입력
            
                ErpBsns110VO bsns110VO = new ErpBsns110VO();
                bsns110VO.setSendNo(smsNo);                                 //발송번호
                bsns110VO.setSendDttm(erpMessageSmsVO.getSendDttm());       //발송일시
                bsns110VO.setBussGbn(erpMessageSmsVO.getBussGbn());         //업무구분
                bsns110VO.setPushCategGbn("");                              //PUSH카테고리구분
                bsns110VO.setSndrPersNo(erpMessageSmsVO.getSndrPersNo());   //발송자개인번호
                bsns110VO.setSndrDeptCd(erpMessageSmsVO.getSndrDeptCd());   //발송자부서코드
                bsns110VO.setSndrNm(erpMessageSmsVO.getSndrNm());           //발송자명
                bsns110VO.setSndrHandpNo(erpMessageSmsVO.getSndrPhoneNo()); //발송자전화번호
                bsns110VO.setSubject(erpMessageSmsVO.getSubject());         //제목
                bsns110VO.setPushCtnt("");                                  //PUSH내용
                bsns110VO.setSmsCtnt(erpMessageSmsVO.getCtnt());            //SMS내용
                bsns110VO.setSendGbn("2");                                  //발송구분
                bsns110VO.setSendYn("0");                                   //발송여부
                bsns110VO.setAttachNo("");                                  //첨부파일번호
                bsns110VO.setUserDataVal1("");                              //사용자데이터값1
                bsns110VO.setUserDataVal2("");                              //사용자데이터값2
                bsns110VO.setUserDataVal3("");                              //사용자데이터값3
                bsns110VO.setInptId(erpMessageSmsVO.getRgtrId());            //입력ID
                bsns110VO.setInptIp(erpMessageSmsVO.getRegIp());            //입력IP
                bsns110VO.setInptMenuId("SMSSEND");                         //입력메뉴ID
                bsns110VO.setModId(erpMessageSmsVO.getRgtrId());             //수정ID
                bsns110VO.setModIp(erpMessageSmsVO.getRegIp());             //수정IP
                bsns110VO.setModMenuId("SMSSEND");                          //수정메뉴ID
                
                erpDAO.insertBsns110(bsns110VO);                //학사 연동 SMS PUSH 보내는 정보 DB
            } else {
                
                ErpBsns111VO bsns111VO = new ErpBsns111VO();
                bsns111VO.setSendNo(smsNo);                                 //발송번호 
                bsns111VO.setSendSeq(smsSeq);                               //발송순번 
                bsns111VO.setRecprPersNo(erpMessageSmsVO.getUserId());      //수신자개인번호 
                bsns111VO.setRecprNm(erpMessageSmsVO.getUserNm());          //수신자명 
                bsns111VO.setRecprHandpNo(erpMessageSmsVO.getRcvPhoneNo()); //수신자휴대전화번호 
                bsns111VO.setSendDttm(erpMessageSmsVO.getSendDttm());       //발송일시 
                bsns111VO.setSmsSendRsltCtnt("00");                         //sms발송결과내용 
                bsns111VO.setPushSendRsltCtnt("00");                        //push발송결과내용
                bsns111VO.setSmsCtnt(erpMessageSmsVO.getCtnt());            //sms내용 
                bsns111VO.setPushCtnt("");                                  //push내용 
                bsns111VO.setInptId(erpMessageSmsVO.getRgtrId());            //입력id
                bsns111VO.setInptIp(erpMessageSmsVO.getRegIp());            //입력ip
                bsns111VO.setInptMenuId("SMSSEND");                         //입력메뉴id 
                bsns111VO.setModId(erpMessageSmsVO.getRgtrId());             //수정id 
                bsns111VO.setModIp(erpMessageSmsVO.getRegIp());             //수정ip 
                bsns111VO.setModMenuId("SMSSEND");                          //수정메뉴id 
                bsns111VO.setCfmYn("0");                                    //확인여부
                
                erpDAO.insertBsns111(bsns111VO);             //학사 연동 SMS PUSH 받는 정보 DB
            }
            seq++;
        }
    }
    */
    
    /**
     * 테스트 성적 저장
     * @param List<ErpScoreTestVO>
     * @throws Exception
     */
    @Override
    public void insertTestScore(ErpScoreTestVO vo, List<ErpScoreTestVO> list) throws Exception {
        erpDAO.deleteTestScore(vo);
        
        int batchSize = 500;
        for (int i = 0; i < list.size(); i += batchSize) {
            int endIndex = Math.min(i + batchSize, list.size());
            List<ErpScoreTestVO> sublist = list.subList(i, endIndex);
            
            erpDAO.insertTestScore(sublist);
        }
    }
    
    /**
     * ERP 성적 메인 테이블로 이관하는 프로시저
     * @param Map<String, Object>
     * @throws Exception
     */
    @Override
    public void callSpScorLmsMrksGet(Map<String, Object> map) throws Exception {
        erpDAO.callSpScorLmsMrksGet(map);
    }
    
    /**
     * LCDMS 년도 목록 조회
     * @return List<ErpLcdmsCntsVO>
     * @throws Exception
     */
    public List<ErpLcdmsCntsVO> listLcdmsYear() throws Exception {
        return erpDAO.listLcdmsYear();
    }
    
    /**
     * LCDMS 콘텐츠 목록 조회
     * @param ErpLcdmsCntsVO
     * @return List<ErpLcdmsCntsVO>
     * @throws Exception
     */
    public List<ErpLcdmsCntsVO> listLcdmsCnts(ErpLcdmsCntsVO vo) throws Exception {
    	return erpDAO.listLcdmsCnts(vo);
    }
    
    /**
     * LCDMS 콘텐츠 조회
     * @param ErpLcdmsCntsVO
     * @return ErpLcdmsCntsVO
     * @throws Exception
     */
    @Override
    public ErpLcdmsCntsVO selectLcdmsCnts(ErpLcdmsCntsVO vo) throws Exception {
        return erpDAO.selectLcdmsCnts(vo);
    }
    
    /**
     * LCDMS 콘텐츠 페이지 목록 조회
     * @param ErpLcdmsPageVO
     * @return List<ErpLcdmsPageVO>
     * @throws Exception
     */
    public List<ErpLcdmsPageVO> listLcdmsPage(ErpLcdmsPageVO vo) throws Exception {
    	return erpDAO.listLcdmsPage(vo);
    }
    
    /**
     * Erp SMS 보내기
     * @param request
     * @param vo
     * @throws Exception
     */
    public ProcessResultVO<AlarmMainVO> directSendMsg(HttpServletRequest request, AlarmMainVO vo) throws Exception {
    	ProcessResultVO<AlarmMainVO> resultVO = new ProcessResultVO<>();
    	String rcvUserInfoStr = vo.getRcvUserInfoStr();
    	String[] rcvs = rcvUserInfoStr.split("\\|");
		List<AlarmSmsVO> rcvList = new ArrayList<AlarmSmsVO>();
		List<ErpBsns111VO> bsnsList = new ArrayList<ErpBsns111VO>();
		String[] rcv = null;
        String smsSeq = "";
		int count = 0;
		int seq = 1;

    	String userId = SessionInfo.getUserId(request);
   	 	String smsNo = IdGenerator.getNewId("SMS");
   	 	smsSeq = smsNo + String.format("%06d", seq);
    	
        AlarmSmsVO sndSmsVo = new AlarmSmsVO();
        sndSmsVo.setSmsNo(smsNo);
        sndSmsVo.setSmsSeq(smsSeq);
        sndSmsVo.setUserId(vo.getUserId());                       //사용자번호
        sndSmsVo.setUserNm(vo.getUserNm());                       //사용자이름
        sndSmsVo.setSysCd(vo.getSysCd());                         //시스템 코드
        sndSmsVo.setOrgId(vo.getOrgId());                         //기관 코드
        sndSmsVo.setBussGbn(vo.getBussGbn());                     //업무구분
        sndSmsVo.setSendRcvGbn("S");                              //수신 발신 구분
        sndSmsVo.setSubject(vo.getSubject());                     //제목
        sndSmsVo.setCtnt(vo.getCtnt());                           //내용
        sndSmsVo.setSendDttm(vo.getSendDttm());                   //발송일시
        sndSmsVo.setSndrPersNo(userId);               			//발송자 개인번호
        sndSmsVo.setSndrDeptCd(SessionInfo.getUserDeptId(request)); //발송자 부서코드
        sndSmsVo.setSndrNm(SessionInfo.getUserNm(request));       //발송자명
        sndSmsVo.setSndrPhoneNo(vo.getSndrPhoneNo());             //발송자 전화번호
        sndSmsVo.setRcvPhoneNo("");                               //수신자 전화번호
        sndSmsVo.setRgtrId(userId);                        		//등록자번호
        sndSmsVo.setRegIp(CommonUtil.getIpAddress(request));      //등록자IP
        sndSmsVo.setModIp(CommonUtil.getIpAddress(request));      //등록자IP
        sndSmsVo.setLogDesc(vo.getLogDesc());                     //로그설명
        sndSmsVo.setCourseCd(vo.getCourseCd());                   //과목코드
        sndSmsVo.setStaffGbn("");
        
        // 발송자 
        rcvList.add(sndSmsVo);
        
        // 수신자 본인
        seq++;
        smsSeq = smsNo + String.format("%06d", seq);
        sndSmsVo = new AlarmSmsVO();
        sndSmsVo.setSmsNo(smsNo);
        sndSmsVo.setSmsSeq(smsSeq);
        sndSmsVo.setUserId(vo.getUserId());                       //사용자번호
        sndSmsVo.setUserNm(vo.getUserNm());                       //사용자이름
        sndSmsVo.setSysCd(vo.getSysCd());                         //시스템 코드
        sndSmsVo.setOrgId(vo.getOrgId());                         //기관 코드
        sndSmsVo.setBussGbn(vo.getBussGbn());                     //업무구분
        sndSmsVo.setSendRcvGbn("R");                              //수신 발신 구분
        sndSmsVo.setSubject(vo.getSubject());                     //제목
        sndSmsVo.setCtnt(vo.getCtnt());                           //내용
        sndSmsVo.setSendDttm(vo.getSendDttm());                   //발송일시
        sndSmsVo.setSndrPersNo(userId);               			//발송자 개인번호
        sndSmsVo.setSndrDeptCd(SessionInfo.getUserDeptId(request)); //발송자 부서코드
        sndSmsVo.setSndrNm(SessionInfo.getUserNm(request));       //발송자명
        sndSmsVo.setSndrPhoneNo(vo.getSndrPhoneNo());             //발송자 전화번호
        sndSmsVo.setRcvPhoneNo(vo.getSndrPhoneNo());              //수신자 전화번호
        sndSmsVo.setRgtrId(userId);                        		//등록자번호
        sndSmsVo.setRegIp(CommonUtil.getIpAddress(request));      //등록자IP
        sndSmsVo.setModIp(CommonUtil.getIpAddress(request));      //등록자IP
        sndSmsVo.setLogDesc(vo.getLogDesc());                     //로그설명
        sndSmsVo.setCourseCd(vo.getCourseCd());                   //과목코드
        sndSmsVo.setStaffGbn("");
        rcvList.add(sndSmsVo);
        
        ErpBsns110VO bsns110VO = new ErpBsns110VO();
        bsns110VO.setSendNo(smsNo);
        bsns110VO.setSendDttm(vo.getSendDttm());
        bsns110VO.setBussGbn(vo.getBussGbn());
        bsns110VO.setPushCategGbn(null);
        bsns110VO.setSndrPersNo(userId);
        bsns110VO.setSndrDeptCd(SessionInfo.getUserDeptId(request));
        bsns110VO.setSndrNm(SessionInfo.getUserNm(request));
        bsns110VO.setSndrHandpNo(vo.getSndrPhoneNo());
        bsns110VO.setSubject(vo.getSubject());
        bsns110VO.setSmsCtnt(vo.getCtnt());
        bsns110VO.setPushCtnt(null);
        bsns110VO.setSendGbn("2");
        bsns110VO.setSendYn("0");
        bsns110VO.setInptId(sndSmsVo.getRgtrId());
        bsns110VO.setInptIp(sndSmsVo.getRegIp());
        bsns110VO.setInptMenuId("LMS");
        bsns110VO.setModId(sndSmsVo.getRgtrId());
        bsns110VO.setModIp(sndSmsVo.getRegIp());
        bsns110VO.setModMenuId("LMS");
        
        erpDAO.insertAcademicSmsPushSend(bsns110VO);

    	for (int i=0; i<rcvs.length; i++) {
             rcv = rcvs[i].split(";");
             if (rcv.length >= 3 && !"".equals(StringUtil.nvl(rcv[2]))) {
            	 count++;
            	 seq++;
                 smsSeq = smsNo + String.format("%06d", seq);
                 
                 AlarmSmsVO rcvSmsVo = new AlarmSmsVO();
                 rcvSmsVo.setUserId(rcv[0]);             //사용자번호
                 rcvSmsVo.setUserNm(rcv[1]);             //사용자이름
                 rcvSmsVo.setSendRcvGbn("R");            //수신 발신 구분
                 rcvSmsVo.setRcvPhoneNo(rcv[2]);    //수신자 전화번호
                 rcvSmsVo.setSmsNo(smsNo);
                 rcvSmsVo.setSmsSeq(smsSeq);
                 rcvSmsVo.setSysCd(sndSmsVo.getSysCd());                 //시스템 코드
                 rcvSmsVo.setOrgId(sndSmsVo.getOrgId());                 //기관 코드
                 rcvSmsVo.setBussGbn(sndSmsVo.getBussGbn());             //업무구분
                 rcvSmsVo.setSubject(sndSmsVo.getSubject());             //제목
                 rcvSmsVo.setCtnt(sndSmsVo.getCtnt());                   //내용
                 rcvSmsVo.setSendDttm(sndSmsVo.getSendDttm());           //발송일시
                 rcvSmsVo.setSndrPersNo(sndSmsVo.getSndrPersNo());       //발송자 개인번호 
                 rcvSmsVo.setSndrDeptCd(sndSmsVo.getSndrDeptCd());       //발송자 부서코드
                 rcvSmsVo.setSndrPhoneNo(sndSmsVo.getSndrPhoneNo());     //발송자 전화번호
                 rcvSmsVo.setSndrNm(sndSmsVo.getSndrNm());               //발송자명
                 rcvSmsVo.setRgtrId(sndSmsVo.getRgtrId());                 //등록자 번호 
                 rcvSmsVo.setRegIp(sndSmsVo.getRegIp());                 //등록 IP
                 rcvSmsVo.setMdfrId(sndSmsVo.getRgtrId());                 //수정자 번호
                 rcvSmsVo.setModIp(sndSmsVo.getModIp());                 //수정자 IP
                 rcvSmsVo.setCourseCd(sndSmsVo.getCourseCd());           //LMS과목코드
                 rcvList.add(rcvSmsVo);
                                  
                 ErpBsns111VO bsns111VO = new ErpBsns111VO();
                 bsns111VO.setSendNo(smsNo);                             //발송번호 
                 bsns111VO.setSendSeq(smsSeq);                           //발송순번 
                 bsns111VO.setRecprPersNo(rcv[0]);         //수신자개인번호 
                 bsns111VO.setRecprNm(rcv[1]);             //수신자명 
                 bsns111VO.setRecprHandpNo(rcv[2]);    //수신자휴대전화번호 
                 bsns111VO.setSendDttm(sndSmsVo.getSendDttm());          //발송일시 
                 bsns111VO.setSmsSendRsltCtnt("00");                     //sms발송결과내용 
                 bsns111VO.setPushSendRsltCtnt("00");                    //push발송결과내용
                 bsns111VO.setSmsCtnt(sndSmsVo.getCtnt());               //sms내용 
                 bsns111VO.setPushCtnt("");                              //push내용 
                 bsns111VO.setInptId(sndSmsVo.getRgtrId());               //입력id
                 bsns111VO.setInptIp(sndSmsVo.getRegIp());               //입력ip
                 bsns111VO.setInptMenuId("LMS");                        //입력메뉴id 
                 bsns111VO.setModId(sndSmsVo.getRgtrId());                //수정id 
                 bsns111VO.setModIp(sndSmsVo.getRegIp());                //수정ip 
                 bsns111VO.setModMenuId("LMS");                         //수정메뉴id 
                 bsns111VO.setCfmYn("0");                                //확인여부
                 bsnsList.add(bsns111VO);
             }
             
             if (count >= 50) {
            	 erpDAO.insertSmsList(rcvList);
            	 erpDAO.insertAcademicSmsPushReceive(bsnsList);
            	 
            	 rcvList.clear();
            	 bsnsList.clear();
             }
    	}
    	
    	if (rcvList.size() > 0) {
    		erpDAO.insertSmsList(rcvList);
    		erpDAO.insertAcademicSmsPushReceive(bsnsList);
    		
    		rcvList.clear();
       	 	bsnsList.clear();
    	}
    	
        AlarmSmsLogVO alarmSmsLogVO = new AlarmSmsLogVO();
        alarmSmsLogVO.setSmsLogNo(IdGenerator.getNewId("SMLOG"));   //SMS로그번호
        alarmSmsLogVO.setSmsNo(smsNo);                              //SMS번호
        alarmSmsLogVO.setLogGbn("S");                               //로그구분
        alarmSmsLogVO.setUserId(sndSmsVo.getUserId());              //사용자번호
        alarmSmsLogVO.setUserNm(sndSmsVo.getUserNm());              //사용자이름
        alarmSmsLogVO.setSysCd(sndSmsVo.getSysCd());                //시스템코드
        alarmSmsLogVO.setOrgId(sndSmsVo.getOrgId());                //기관코드
        alarmSmsLogVO.setBussGbn(sndSmsVo.getBussGbn());            //업무구분
        alarmSmsLogVO.setSubject(sndSmsVo.getSubject());            //제목
        alarmSmsLogVO.setCtnt(sndSmsVo.getCtnt());                  //내용
        alarmSmsLogVO.setSendDttm(sndSmsVo.getSendDttm());          //발송일시
        alarmSmsLogVO.setSndrPersNo(sndSmsVo.getSndrPersNo());      //발송자개인번호
        alarmSmsLogVO.setSndrDeptCd(sndSmsVo.getSndrDeptCd());      //발송자부서코드
        alarmSmsLogVO.setSndrNm(sndSmsVo.getSndrNm());              //발송자명
        alarmSmsLogVO.setSndrPhoneNo(sndSmsVo.getSndrPhoneNo());    //발송자전화번호
        alarmSmsLogVO.setRcvNum((rcvs.length));             //대상자수
        alarmSmsLogVO.setLogDesc(sndSmsVo.getLogDesc());            //로그설명
        alarmSmsLogVO.setRgtrId(sndSmsVo.getRgtrId());                //등록자번호
        alarmSmsLogVO.setRegIp(sndSmsVo.getRegIp());                //등록IP
        
        erpDAO.insertAlarmSmsLog(alarmSmsLogVO);               //SMS 이력 테이블 입력
    	
    	return resultVO;
    }
}
