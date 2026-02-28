package knou.lms.bbs.web.util;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;

import javax.servlet.http.HttpServletRequest;

import knou.framework.common.SessionInfo;
import knou.framework.util.StringUtil;
import knou.lms.bbs.vo.BbsAtclVO;
import knou.lms.bbs.vo.BbsCmntVO;
import knou.lms.bbs.vo.BbsInfoVO;

public class BbsAuthUtil {
    
    // 강의실 게시판 정보 쓰기 권한
    public static String getLectBbsWriteAuth(HttpServletRequest request) {
        String lectBbsWriteAuth = "N";
        String prevCourseYn = SessionInfo.getPrevCourseYn(request);
        
        if(isProfessor(request)) {
            lectBbsWriteAuth = "Y";
        }
        
        // 이전과목이면 불가
        if("Y".equals(prevCourseYn)) {
            lectBbsWriteAuth = "N";
        }
        
        return lectBbsWriteAuth;
    }
    
    // 강의실 게시판 정보 수정 권한
    public static String getLectBbsEditAuth(HttpServletRequest request) {
        String lectBbsEditAuth = "N";
        String prevCourseYn = SessionInfo.getPrevCourseYn(request);
        
        if(isProfessor(request)) {
            lectBbsEditAuth = "Y";
        }
        
        // 이전과목이면 불가
        if("Y".equals(prevCourseYn)) {
            lectBbsEditAuth = "N";
        }
        
        return lectBbsEditAuth;
    }
    
    // 게시글 글쓰기 권한
    public static String getAtclWriteAuth(HttpServletRequest request, BbsInfoVO bbsInfoVO) {
        String atclWriteAuth = "N";
        String writeUseYn = bbsInfoVO.getWriteUseYn(); // 학생 글쓰기 권한
        String sysUseYn = bbsInfoVO.getSysUseYn();
        String bbsCd = bbsInfoVO.getBbsId();
        String professorVirtualLoginYn = SessionInfo.getProfessorVirtualLoginYn(request);
        
        // 시스템 게시판 (전체공지)
        if("Y".equals(sysUseYn)) {
            if(isAdmin(request)) {
                atclWriteAuth = "Y";
            } else {
                atclWriteAuth = "N";
            }
        } 
        // 강의실 게시판
        else {
            // 강의실 교수자
            if(!isStudent(request)) {
                atclWriteAuth = "Y";
                
                // 문의/상담 게시판 교수 글쓰기 불가능
                if("SECRET".equals(bbsCd) || "QNA".equals(bbsCd)) {
                    atclWriteAuth = "N";
                }
            } 
            // 강의실 학생
            else {
                atclWriteAuth = StringUtil.nvl(writeUseYn, "N"); // 'Y'로 설정된경우 학생 글쓰기 가능
                
                // 교수 학생화면보기 일경우 불가
                if("Y".equals(professorVirtualLoginYn)) {
                    atclWriteAuth = "N";
                }
            }
            
            if(!isBbsUsePeriod(request, bbsInfoVO.getHaksaYear(), bbsInfoVO.getHaksaTerm(), bbsInfoVO.getCrsCd())) {
                atclWriteAuth = "N";
            }
        }
        
        return atclWriteAuth;
    }
    
    // 게시글 답글쓰기 권한
    public static String getAnswerAtclWriteAuth(HttpServletRequest request, BbsInfoVO bbsInfoVO) {
        String answerAtclWriteAuth = "N";
        String userType = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        String ansrUseYn = bbsInfoVO.getAnsrUseYn();
        String sysUseYn = bbsInfoVO.getSysUseYn();
        String bbsCd = bbsInfoVO.getBbsId();
        
        // 게시판 답글쓰기 옵션 사용
        if("Y".equals(ansrUseYn)) {
            // 시스템 게시판
            if("Y".equals(sysUseYn)) {
                if(isAdmin(request)) {
                    answerAtclWriteAuth = "Y";
                }
            } 
            // 강의실 게시판
            else {
                if(isProfessor(request)) {
                    answerAtclWriteAuth = "Y";
                    
                    // 상담게시판은 교수만 답변가능
                    if("SECRET".equals(bbsCd) && userType.contains("TUT")) {
                        answerAtclWriteAuth = "N";
                    }
                }
                
                if(!isBbsUsePeriod(request, bbsInfoVO.getHaksaYear(), bbsInfoVO.getHaksaTerm(), bbsInfoVO.getCrsCd())) {
                    answerAtclWriteAuth = "N";
                }
            }
        }
        
        return answerAtclWriteAuth;
    }
    
    // 게시글 수정권한
    public static String getAtclEditAuth(HttpServletRequest request, BbsInfoVO bbsInfoVO, BbsAtclVO bbsAtclVO) {
        String atclEditAuth = "N";
        String userId = SessionInfo.getUserId(request);
        String rgtrId = bbsAtclVO.getRgtrId();
        String sysUseYn = bbsInfoVO.getSysUseYn();
        String bbsCd = bbsInfoVO.getBbsId();
        int answerAtclCnt = bbsAtclVO.getAnswerAtclCnt();
        
        // 시스템 게시판
        if("Y".equals(sysUseYn)) {
            if(isAdmin(request)) {
                // 본인의 게시글
                if(rgtrId.equals(StringUtil.nvl(userId))) {
                    atclEditAuth =  "Y";
                }
            }
        } 
        // 강의실 게시판
        else {
            // 강의실 교수자
            if(isProfessor(request)) {
                // 본인의 게시글
                if(rgtrId.equals(StringUtil.nvl(userId))) {
                    atclEditAuth =  "Y";
                }
                
                if("NOTICE".equals(bbsCd) || "PDS".equals(bbsCd) || "QNA".equals(bbsCd)  || "SECRET".equals(bbsCd)) {
                    atclEditAuth = "Y";
                }
                
                if(isAdmin(request)) {
                    atclEditAuth = "Y";
                }
            } 
            // 강의실 학생
            else {
                // 본인의 게시글
                if(rgtrId.equals(StringUtil.nvl(userId))) {
                    atclEditAuth =  "Y";
                }
                
                // 답변이 달린 게시글
                if(("QNA".equals(bbsCd) || "SECRET".equals(bbsCd)) && answerAtclCnt > 0) {
                    atclEditAuth = "N";
                }
            }
            
            if(!isBbsUsePeriod(request, bbsInfoVO.getHaksaYear(), bbsInfoVO.getHaksaTerm(), bbsInfoVO.getCrsCd())) {
                atclEditAuth = "N";
            }
        }
        
        return atclEditAuth;
    }
    
    // 게시글 삭제권한
    public static String getAtclDeleteAuth(HttpServletRequest request, BbsInfoVO bbsInfoVO, BbsAtclVO bbsAtclVO) {
        String atclDeleteAuth = "N";
        String userId = SessionInfo.getUserId(request);
        String sysUseYn = bbsInfoVO.getSysUseYn();
        String bbsCd = bbsInfoVO.getBbsId();
        String rgtrId = bbsAtclVO.getRgtrId();
        int answerAtclCnt = bbsAtclVO.getAnswerAtclCnt();
        
        // 시스템 게시판
        if("Y".equals(sysUseYn)) {
            if(isAdmin(request)) {
                // 본인의 게시글
                if(rgtrId.equals(StringUtil.nvl(userId))) {
                    atclDeleteAuth = "Y";
                }
            }
        } 
        // 강의실 게시판
        else {
            // 강의실 교수자
            if(isProfessor(request)) {
                // 본인의 게시글
                if(rgtrId.equals(StringUtil.nvl(userId))) {
                    atclDeleteAuth = "Y";
                }
                
                if("NOTICE".equals(bbsCd) || "PDS".equals(bbsCd) || "QNA".equals(bbsCd)  || "SECRET".equals(bbsCd)) {
                    atclDeleteAuth = "Y";
                }
                
                if(isAdmin(request)) {
                    atclDeleteAuth = "Y";
                }
            } 
            // 강의실 학생
            else {
                // 본인의 게시글
                if(rgtrId.equals(StringUtil.nvl(userId))) {
                    atclDeleteAuth = "Y";
                }
                
                // 답변이 달린 게시글
                if(("QNA".equals(bbsCd) || "SECRET".equals(bbsCd)) && answerAtclCnt > 0) {
                    atclDeleteAuth = "N";
                }
            }
            
            if(!isBbsUsePeriod(request, bbsInfoVO.getHaksaYear(), bbsInfoVO.getHaksaTerm(), bbsInfoVO.getCrsCd())) {
                atclDeleteAuth = "N";
            }
        }
        
        return atclDeleteAuth;
    }
    
    public static String getAtclViewAuth(HttpServletRequest request, BbsInfoVO bbsInfoVO, BbsAtclVO bbsAtclVO) {
        String atclViewAuth = "Y";
        String userId = SessionInfo.getUserId(request);
        String sysUseYn = bbsInfoVO.getSysUseYn();
        String useYn = StringUtil.nvl(bbsInfoVO.getUseYn());
        String stdViewYn = StringUtil.nvl(bbsInfoVO.getStdViewYn());
        String rsrvUseYn = bbsAtclVO.getRsrvUseYn();
        String rsrvDttmStartYn = StringUtil.nvl(bbsAtclVO.getRsrvDttmStartYn());
        String bbsCd = bbsInfoVO.getBbsId();
        boolean isTutor = BbsAuthUtil.isTutor(request);
        
        // 시스템 게시판
        if("Y".equals(sysUseYn)) {
            if(isAdmin(request)) {
                
            } else {
                // 비공개글 접근 체크
                if(!("N".equals(bbsAtclVO.getLockYn()) || userId.equals(bbsAtclVO.getRgtrId()))) {
                    atclViewAuth = "N";
                }
                
                // 예약등록글 접근 체크
                if("Y".equals(rsrvUseYn) && !"Y".equals(rsrvDttmStartYn)) {
                    atclViewAuth = "N";
                }
                
                // 사용여부 체크
                if(!"Y".equals(useYn)) {
                    atclViewAuth = "N";
                }
            }
        } 
        // 강의실 게시판
        else {
            // 강의실 교수자
            if(isProfessor(request)) {
                // 상담글 조교 확인 불가
                if("SECRET".equals(bbsCd) && isTutor) {
                    atclViewAuth = "N";
                }
            } 
            // 강의실 학생
            else {
                // 1:1 문의 접근 체크(학생일경우 자신의 글만 가능)
                if("SECRET".equals(bbsCd) && !userId.equals(bbsAtclVO.getRgtrId())) {
                    atclViewAuth = "N";
                }
                
                // 비공개글 접근 체크
                if(!("N".equals(bbsAtclVO.getLockYn()) || userId.equals(bbsAtclVO.getRgtrId()))) {
                    atclViewAuth = "N";
                }
                
                // 예약등록글 접근 체크
                if("Y".equals(rsrvUseYn) && !"Y".equals(rsrvDttmStartYn)) {
                    atclViewAuth = "N";
                }
                
                // 학생 보기 여부 체크
                if(!"Y".equals(stdViewYn)) {
                    atclViewAuth = "N";
                }
                
                // 사용여부 체크
                if(!"Y".equals(useYn)) {
                    atclViewAuth = "N";
                }
            }
        }
        
        return atclViewAuth;
    }
    
    // 게시글 댓글 쓰기권한
    public static String getCommentWriteAuth(HttpServletRequest request, BbsInfoVO bbsInfoVO, BbsAtclVO bbsAtclVO) {
        String commentWriteAuth = "N";
        String sysUseYn = bbsInfoVO.getSysUseYn();
        String professorVirtualLoginYn = SessionInfo.getProfessorVirtualLoginYn(request);
        
        boolean useCmnt = "Y".equals(bbsInfoVO.getCmntUseYn()) 
                && "Y".equals(bbsAtclVO.getCmntUseYn()) 
                && "N".equals(bbsAtclVO.getDelYn());
        
        if(useCmnt) {
            // 시스템 게시판
            if("Y".equals(sysUseYn)) {
                commentWriteAuth = "Y";
            } 
            // 강의실 게시판
            else {
                commentWriteAuth = "Y";
                
                // 교수 학생화면보기 일경우 불가
                if("Y".equals(professorVirtualLoginYn)) {
                    commentWriteAuth = "N";
                }
                
                if(!isBbsUsePeriod(request, bbsInfoVO.getHaksaYear(), bbsInfoVO.getHaksaTerm(), bbsInfoVO.getCrsCd())) {
                    commentWriteAuth = "N";
                }
            }
        }
        
        return commentWriteAuth;
    }
    
    // 게시글 댓글 수정권한
    public static String getCommentEditAuth(HttpServletRequest request, BbsInfoVO bbsInfoVO, BbsAtclVO bbsAtclVO, BbsCmntVO bbsCmntVO) {
        String commentEditAuth = "N";
        String userId = SessionInfo.getUserId(request);
        String sysUseYn = bbsInfoVO.getSysUseYn();
        String rgtrId = bbsCmntVO.getRgtrId();
        String professorVirtualLoginYn = SessionInfo.getProfessorVirtualLoginYn(request);
        
        boolean useCmnt = "Y".equals(bbsInfoVO.getCmntUseYn()) 
                && "Y".equals(bbsAtclVO.getCmntUseYn()) 
                && "N".equals(bbsAtclVO.getDelYn());
        
        if(useCmnt) {
            // 시스템 게시판
            if("Y".equals(sysUseYn)) {
                // 본인의 게시글
                if(userId.equals(rgtrId)) {
                    commentEditAuth = "Y";
                }
            } 
            // 강의실 게시판
            else {
                // 본인의 게시글
                if(userId.equals(rgtrId)) {
                    commentEditAuth = "Y";
                }
                
                // 교수 학생화면보기 일경우 불가
                if("Y".equals(professorVirtualLoginYn)) {
                    commentEditAuth = "N";
                }
                
                if(!isBbsUsePeriod(request, bbsInfoVO.getHaksaYear(), bbsInfoVO.getHaksaTerm(), bbsInfoVO.getCrsCd())) {
                    commentEditAuth = "N";
                }
            }
        }
        
        return commentEditAuth;
    }
    
    // 게시글 댓글 삭제권한
    public static String getCommentDeleteAuth(HttpServletRequest request, BbsInfoVO bbsInfoVO, BbsAtclVO bbsAtclVO, BbsCmntVO bbsCmntVO) {
        String commentDeleteAuth = "N";
        String userId = SessionInfo.getUserId(request);
        String sysUseYn = bbsInfoVO.getSysUseYn();
        String rgtrId = bbsCmntVO.getRgtrId();
        String professorVirtualLoginYn = SessionInfo.getProfessorVirtualLoginYn(request);
        
        boolean useCmnt = "Y".equals(bbsInfoVO.getCmntUseYn()) 
                && "Y".equals(bbsAtclVO.getCmntUseYn()) 
                && "N".equals(bbsAtclVO.getDelYn());
        
        if(useCmnt) {
            // 시스템 게시판
            if("Y".equals(sysUseYn)) {
                if(isAdmin(request)) {
                    commentDeleteAuth = "Y";
                } else {
                    // 본인의 게시글
                    if(userId.equals(rgtrId)) {
                        commentDeleteAuth = "Y";
                    }
                }
            } 
            // 강의실 게시판
            else {
                // 강의실 교수자
                if(isProfessor(request)) {
                    commentDeleteAuth = "Y";
                } 
                // 강의실 학생
                else {
                    // 본인의 게시글
                    if(userId.equals(rgtrId)) {
                        commentDeleteAuth = "Y";
                    }
                }
                
                // 교수 학생화면보기 일경우 불가
                if("Y".equals(professorVirtualLoginYn)) {
                    commentDeleteAuth = "N";
                }
                
                if(!isBbsUsePeriod(request, bbsInfoVO.getHaksaYear(), bbsInfoVO.getHaksaTerm(), bbsInfoVO.getCrsCd())) {
                    commentDeleteAuth = "N";
                }
            }
        }
        
        return commentDeleteAuth;
    }
    
    public static boolean isBbsUsePeriod(HttpServletRequest request, String haksaYear, String haksaTerm, String crsCd) {
    	return true;
    	
        /*
        if("".equals(StringUtil.nvl(haksaYear)) || "".equals(StringUtil.nvl(haksaTerm))) {
            return false;
        } else {
            boolean isKnou = SessionInfo.isKnou(request);
            
            LocalDate now = LocalDate.now();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
            LocalDate haksaDate = null;
            
            if(isKnou) {
                switch (haksaTerm) {
                    case "10":
                        haksaDate = LocalDate.parse(haksaYear + "-06-01", DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                        haksaDate = haksaDate.with(TemporalAdjusters.lastDayOfMonth());
                        break;
                    case "11":
                        haksaDate = LocalDate.parse(haksaYear + "-08-01", DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                        haksaDate = haksaDate.with(TemporalAdjusters.lastDayOfMonth());
                        break;
                    case "20":
                        haksaDate = LocalDate.parse(haksaYear + "-12-01", DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                        haksaDate = haksaDate.with(TemporalAdjusters.lastDayOfMonth());
                        break;
                    case "21":
                        haksaDate = LocalDate.parse(haksaYear + "-02-01", DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                        haksaDate = haksaDate.with(TemporalAdjusters.lastDayOfMonth()).plusYears(1);
                        break;
                    default:
                        haksaDate = LocalDate.parse("2099-02-01", DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                        haksaDate = haksaDate.with(TemporalAdjusters.lastDayOfMonth()).plusYears(1);
                }
            } else {
                switch (haksaTerm) {
                    case "10":
                        haksaDate = LocalDate.parse(haksaYear + "-12-31", DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                        haksaDate = haksaDate.with(TemporalAdjusters.lastDayOfMonth());
                        break;
                    case "11":
                        haksaDate = LocalDate.parse(haksaYear + "-12-31", DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                        haksaDate = haksaDate.with(TemporalAdjusters.lastDayOfMonth());
                        break;
                    case "20":
                        haksaYear = String.valueOf(Integer.parseInt(haksaYear)+1);
                        haksaDate = LocalDate.parse( haksaYear + "-12-31", DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                        haksaDate = haksaDate.with(TemporalAdjusters.lastDayOfMonth());
                        break;
                    case "21":
                        haksaDate = LocalDate.parse(haksaYear + "-12-31", DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                        haksaDate = haksaDate.with(TemporalAdjusters.lastDayOfMonth()).plusYears(1);
                        break;
                    default:
                        haksaDate = LocalDate.parse("2099-02-01", DateTimeFormatter.ofPattern("yyyy-MM-dd"));
                        haksaDate = haksaDate.with(TemporalAdjusters.lastDayOfMonth()).plusYears(1);
                }
            }
            
            if (now.format(formatter).compareTo(haksaDate.format(formatter)) <= 0) {
                return true;
            }
            
            return false;
        }
        */
    }
    
    public static boolean isAdmin(HttpServletRequest request) {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        
        boolean isAdmin = menuType.contains("ADM") ? true : false;
        
        return isAdmin;
    }
    
    public static boolean isProfessor(HttpServletRequest request) {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        
        boolean isProfessor = menuType.contains("PROF");
        
        return isProfessor;
    }
    
    public static boolean isTutor(HttpServletRequest request) {
        String userType = StringUtil.nvl(SessionInfo.getAuthrtCd(request));
        
        boolean isTutor = userType.contains("TUT");
        
        return isTutor;
    }
    
    public static boolean isStudent(HttpServletRequest request) {
        String menuType = StringUtil.nvl(SessionInfo.getAuthrtGrpcd(request));
        
        boolean isStudent = menuType.contains("USR");
        
        return isStudent;
    }
}