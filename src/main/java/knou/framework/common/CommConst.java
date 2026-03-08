package knou.framework.common;

import knou.framework.base.ConfigurationFactory;
import org.apache.commons.configuration2.Configuration;

import java.lang.reflect.Field;

/**
 * 공통 변수, 설정 Class
 *
 * @author shil
 */
public class CommConst {

    // framework.properties 로드
    public static final Configuration framework = ConfigurationFactory.getConfiguration(CommConst.FRAMEWORK);
    public static final Configuration webConfig = ConfigurationFactory.getConfiguration(CommConst.WEBCONTEXT);

    // 서버명
    public static final String SERVER_NAME = webConfig.getString("SERVER.NAME");

    // 서버모드
    public static final String SERVER_MODE = framework.getString("framework.system.server_mode");

    // 시스템 정보
    public static final String SYSTEM_TITLE = ""; //ConfInfo.value("site_info:site_name");
    public static final String SYSTEM_UI_THEME = ""; //ConfInfo.value("sys_env:ui_theme");

    // 한사대 기관 코드
    /* public static final String KNOU_ORG_ID = "ORG0000001"; */

    // 방송대 기관 코드
    public static final String KNOU_ORG_ID = "ORG0000001";

    public static final String LMSBASIC_ORG_ID = "LMSBASIC";

    // Characterset
    public static final String CHAR_SET = "UTF-8";

    // 화면 동작 모드(actionMode)
    public static final String MODE_CREATE = "create";  // 생성
    public static final String MODE_MODIFY = "modify";  // 수정
    public static final String MODE_VIEW = "view";      // 조회

    // 처리결과
    public static final String RESULT_SUCCESS = "success";  // 성공
    public static final String RESULT_FAIL = "fail";            // 실패

    // 세션저장 이름
    public static final String SSN_COMMON_RESULT = "COMMON_RESULT";
    public static final String SSN_COMMON_RESULT_MSG = "COMMON_RESULT_MSG";
    public static final String SSN_ALERT_MESSAGE = "ALERT_MESSAGE";

    // 데이터 경로
    public static final String WEBDATA_CONTEXT = framework.getString("framework.fileupload.context"); // webdata context
    public static final String WEBDATA_PATH = framework.getString("framework.fileupload.rootPath"); // webdata path

    // 날짜/시간 표시 패턴
    public static final String DATE_DATETIME_PATTERN = framework.getString("date.datetime_pattern");   // 날짜시간 패턴
    public static final String DATE_DATE_PATTERN = framework.getString("date.date_pattern");           // 날짜 패턴
    public static final String DATE_TIME_PATTERN = framework.getString("date.time_pattern");           // 시간 패턴

    // 권한
    public static final int AUTH_NONE = 0;  // 권한없음
    public static final int AUTH_READ = 1;  // 읽기
    public static final int AUTH_WRITE = 2; // 쓰기

    // 사용자구분
    public static final String USER_ADMIN = "admin";        // 관리자
    public static final String USER_STAFF = "staff";        // 스태프
    public static final String USER_GUEST = "guest";        // 게스트


    // 파일저장 디렉토리
    public static final String DIR_BOARD = "/board";        // 게시판
    public static final String DIR_TEMP = "/temp";      // 임시

    // 화면 사이즈
    public static final String SCREEN_WIDTH = "100%";       // 기본 화면 사이즈
    public static final String SCREEN_MIN_WIDTH = "1280px"; // 최소 화면 사이즈

    // 이동 페이지(Action)
    public static final String PAGE_HOME = "/main/mainHome.do";                 // 홈
    public static final String PAGE_LOGIN = "/user/userLoginForm.do";           // 로그인
    public static final String PAGE_LOGOUT = "/user/userLogout.do";             // 로그아웃
    public static final String PAGE_MOVE = "/common/movePage.do";               // 페이지 이동
    public static final String PAGE_FILE_UPLOAD = "/common/uploadFile.do";      // 파일 업로드
    public static final String PAGE_FILE_DOWNLOAD = "/common/downloadFile.do";  // 파일 다운로드
    public static final String PAGE_EDITOR_UPLOAD = "/common/editorUpload.do";  // 에디터 파일 업로드
    public static final String DEXT_FILE_UPLOAD = "/dext/uploadFileDext.up";    // 덱스트 파일 업로드
    public static final String DEXT_FILE_BULK_UPLOAD = "/dext/uploadBulkFileDexts.up"; // 덱스트 파일 대용량 업로드

    // 이동 페이지(jsp)
    public static final String PAGE_ERROR = "/common/error";                        // 에러 페이지
    public static final String PAGE_RESULT_POP = "/common/result_pop";          // 팝업창 결과 페이지

    // Framework의 Confguration에서 사용하는 변수 정의
    public static final int FRAMEWORK = 0;
    public static final int WEBCONTEXT = 1;

    // System Name
    public final static String SYSTEM_NAME = framework.getString("framework.name");

    // LMS Data path 환경
    public final static String LMS_DATA_CONTEXT = framework.getString("framework.context");
    public final static String LMS_IMAGE_SET = framework.getString("framework.imageset");
    public final static String LMS_TEMPLATE = framework.getString("framework.template");
    public final static String LMS_CONTEXT = framework.getString("framework.lmsdata.context");

    // langueag 관련 설정
    public final static String LANG_SUPPORT = framework.getString("framework.language.support");
    public final static String LANG_DEFAULT = framework.getString("framework.language.default");
    public final static String LANG_SITE = framework.getString("framework.language.site");
    public final static String LANG_MULTIUSE = framework.getString("framework.language.multiuse");

    // 메시지 사용 여부 관련 설정
    public final static String MSG_SMS = framework.getString("framework.message.sms");
    public final static String MSG_EMAIL = framework.getString("framework.message.email");
    public final static String MSG_NOTE = framework.getString("framework.message.note");

    // 메시지 표시 관련 설정
    public final static String MSG_SMS_ADDR = framework.getString("framework.message.sms.addr");
    public final static String MSG_SMS_NAME = framework.getString("framework.message.sms.name");
    public final static String MSG_EMAIL_ADDR = framework.getString("framework.message.email.addr");
    public final static String MSG_EMAIL_NAME = framework.getString("framework.message.email.name");

    // exception db log 관련 설정
    public final static String EXCEPTION_DBLOG_USE = framework.getString("framework.dblog.exception");

    // Ajax Message 출력 관련 설정
    public final static String AJAX_MESSAGE_USE = framework.getString("framework.ajax.message");

    // KISA key.dat 관련 설정
    public static final String KISAKEYFILE = framework.getString("kisa.keyfile.path");

    //* javascript와 연동될 동일한 환경값 설정 **//
    /**
     * 웹어플리케이션 컨텍스트 경로<br>{@code /uniedu}
     **/
    public final static String CONTEXT_ROOT = framework.getString("framework.context");

    /**
     * 웹어플리케이션 이미지 루트 경로<br>{@code /uniedu/img}
     **/
    public final static String CONTEXT_IMG_PATH = CONTEXT_ROOT + framework.getString("framework.path.imageroot");

    /**
     * 웹어플리케이션 프레임워크의 이미지 경로<br>{@code /uniedu/img/framework}
     **/
    public final static String FRAME_IMAGE_PATH = CONTEXT_ROOT + framework.getString("framework.path.image");

    /**
     * 웹어플리케이션 프레임워크의 버튼 이미지 경로<br>{@code /uniedu/img/framework/button/}
     **/
    public final static String IMAGE_PATH_BUTTON = FRAME_IMAGE_PATH + "/button/";

    /**
     * 웹어플리케이션 프레임워크의 아이콘 이미지 경로<br>{@code /uniedu/img/framework/icon/}
     **/
    public final static String IMAGE_PATH_ICON = FRAME_IMAGE_PATH + "/icon/";

    /**
     * 웹어플리케이션 도메인 설정
     **/
    public final static String PRODUCT_DOMAIN = framework.getString("framework.product.domain");

    public final static String ADMIN_DOMAIN = framework.getString("framework.url.admin");

    public final static String MGR_SITE_DOMAIN = framework.getString("framework.manage.site.org.domain");
    public final static String MGR_SITE_CD = framework.getString("framework.manage.site.org.code");

    /**
     * 서버 호스트 URL <br>{@code http://dev.edutrack.go.kr}
     **/
    public final static String HOST_URL = framework.getString("edutrack.url");

    /**
     * 서버 호스트 FileServer URL <br>{@code http://file.edutrack.go.kr}
     **/
    public final static String FILESERVER_URL = framework.getString("framework.fileserver.url");

    /**
     * 서버 호스트 URL <br>{@code http://dev.edutrack.go.kr}
     **/
    public final static String ADMIN_PORT = framework.getString("framework.product.admin.port");

    /**
     * 서버 호스트 URL <br>{@code http://www.edutrack.go.kr}
     **/
    public final static String PRODUCT_HOST_URL = framework.getString("edutrack.product");

    /**
     * 서브도메인 서비스 : domain, 가상디렉토리 서비스 : context <br>{@code subdomain}
     **/
    public final static String PRODUCT_SERVICE_TYPE = framework.getString("framework.product.service_type");


    /**
     * 서버 호스트 URL과 컨텍스트 URL을 합친 경로 <br>{@code http://dev.edutrack.go.kr/}
     **/
    public final static String HOST_CONTEXT_URL = HOST_URL + CONTEXT_ROOT;

    /**
     * 파일 보기 컨트롤러 경로 <br>{@code /file/view/}
     **/
    public final static String CONTEXT_FILE_VIEW = CONTEXT_ROOT + "/viewFile.do";

    /**
     * 파일 JSON 정보 조회 컨트롤러 경로 <br>{@code /file/jsonview/}
     **/
    public final static String CONTEXT_FILE_JSONVIEW = CONTEXT_ROOT + "/jsonViewFile.do";

    /**
     * 파일 썸네일 보기 경로 <br>{@code /file/thumb/}
     **/
    public final static String CONTEXT_FILE_THUMB = CONTEXT_ROOT + "/thumbFile.do";

    /**
     * 파일 다운로드 경로 <br>{@code /file/download/}
     **/
    public final static String CONTEXT_FILE_DOWNLOAD = CONTEXT_ROOT + "/common/downloadFile.do";//일단씀

    /**
     * 파일 업로드 경로 <br>{@code /file/ajaxupload/}
     **/
    public final static String CONTEXT_FILE_UPLOAD = CONTEXT_ROOT + "/ajaxUploadFile.do";

    /**
     * 파일 삭제 요청 경로 <br>{@code /file/delete/}
     **/
    public final static String CONTEXT_FILE_DELETE = CONTEXT_ROOT + "/deleteFile.do";

    /**
     * 파일 일괄삭제 요청 경로 <br>{@code /file/deletes/}
     **/
    public final static String CONTEXT_FILE_DELETES = CONTEXT_ROOT + "/deleteAllFile.do";

    /**
     * 플래쉬 라이브러리 요청 경로 <br>{@code /libs}
     **/
    public final static String CONTEXT_FLASH = CONTEXT_ROOT + "/libs";

    /**
     * 다음 에디터 HTML 요청 경로 <br>{@code /libs/daumeditor/daumeditor.jsp}
     **/
    public final static String EDITOR_URL = CONTEXT_ROOT + "/libs/daumeditor/daumeditor.jsp";
    /**
     * 다음 에디터 본문 정렬 기본 값 <br>{@code "C" - 가운데정렬}
     **/
    public final static String EDITOR_IMAGE_ALIGN = "C";      // center

    // 서버 OS 구분
    public final static String SERVER_TYPE = framework.getString("framework.system.server_type");
    public final static String SERVERTYPE_WINDOWS = "windows";
    public final static String SERVERTYPE_UNIX = "unix";

    // 시스템 기본 인코딩
    public static final String ENCODING_SYSTEM = framework.getString("framework.encoding.system");
    // 주소 Redirect Encoding
    public static final String ENCODING_REDIRECT = framework.getString("framework.encoding.redirect");
    // Message Encoding
    public static final String ENCODING_MESSAGE = framework.getString("framework.encoding.message");

    // 업로드 파일 저장 경로
    public static final String FILE_STORAGE_PATH = framework.getString("framework.filestorage.path"); //일단씀
    // 콘텐츠 파일 저장 경로
    public static final String CONTENTS_STORAGE_PATH = framework.getString("framework.contentstorage.path");

    // 파일 업로드 제한 용량
    public static final int MAX_POST_SIZE = framework.getInt("framework.fileupload.max_post_size");
    // 콘텐츠 업로드 제한 용량
    public static final int MAX_CONTENTS_POST_SIZE = framework.getInt("framework.fileupload.contents.max_post_size");

    // 페이지당 목록수, 페이지 네비게이션 표시수, 사진게시판 표시수
    public static final int LIST_SCALE = framework.getInt("framework.list.scale");
    public static final int LIST_PAGE_SCALE = framework.getInt("framework.list.page_scale");
    public static final int LIST_PHOTO_BOARD_SCALE = framework.getInt("framework.list.photo_scale");

    // 권한체크 여부
    // public static final String AUTH_CHECK_YN = config.getString("framework.auth.checkYn");

    // 로그인 관련 설정
    public static final String LOGIN_OK = "LOGIN";
    public static final String LOGIN_USERRPRSID = "USERRPRSID";
    public static final String LOGIN_USERID = "USERID";
    public static final String LOGIN_USERNAME = "USERNAME";
    public static final String LOGIN_USERTYPE = "USERTYPE";
    public static final String LOGIN_USERTYCD = "USERTYCD";
    public static final String LOGIN_AUTHRTCD = "AUTHRTCD";
    public static final String LOGIN_USERSTS = "USERSTS";                                                    //사용자 승인 여부
    public static final String LOGIN_ADMTYPE = "ADMTYPE";
    public static final String LOGIN_ADMYN = "ADMYN";
    public static final String LOGIN_MNGTYPE = "MNGTYPE";
    public static final String LOGIN_IP_ADDR = "USERIPADDR";
    public static final String LOGIN_CUR_TERM = "CUR_TERM";
    public static final String LOGIN_CUR_TERM_LIST = "CUR_TERM_LIST";
    public static final String LOGIN_ORGNM = "ORGNM";
    public static final String LOGIN_ORGID = "ORGID";
    public static final String LOGIN_ORGTYPECD = "ORGTYPECD";
    public static final String LOGIN_DISABLILITYYN = "DISABLILITYYN";
    public static final String LOGIN_DISABLILITYEXAMYN = "DISABLILITYEXAMYN";
    public static final String LOGIN_MOD_CHG_STACK = "MODCHGSTACK";    // 사용자 모드 전환
    public static final String LOGIN_GNB = "LOGINGNB";

    // ASP 관련 설정
    public static final String SAAS_ORGNM = "ORGNM";
    public static final String SAAS_ORGID = "ORGID";
    public static final String SAAS_ORGTYPECD = "ORGTYPECD";
    public static final String SAAS_LAYOUT_TPL = "LAYOUTTPL";
    public static final String SAAS_COLOR_TPL = "COLORTPL";
    public static final String SAAS_TOP_LOGO = "TOPLOGOSN";
    public static final String SAAS_SUB_LOGO1 = "SUBLOGO1SN";
    public static final String SAAS_SUB_LOGO1_URL = "SUBLOGO1URL";
    public static final String SAAS_SUB_LOGO2 = "SUBLOGO2SN";
    public static final String SAAS_SUB_LOGO2_URL = "SUBLOGO2URL";
    public static final String SAAS_ADM_LOGO = "ADMLOGOSN";
    public static final String SAAS_SUB_IMAGE = "SUBIMGSN";
    public static final String SAAS_SUB_TXTIMG = "SUBTXTIMGSN";
    public static final String SAAS_SUB_TEXT = "SUBTXTSTR";
    public static final String SAAS_LEC_IMAGE = "LECIMGSN";
    public static final String SAAS_LEC_TXTIMG = "LECTXTIMGSN";
    public static final String SAAS_LEC_IMGNM = "LECTXTIMGNM";
    public static final String SAAS_LEC_TEXT = "LECTXTSTR";
    public static final String SAAS_LEC_FILEURL = "LECCOLORSTR";
    public static final String SAAS_LEC_CONNURL = "LECCONNURL";
    public static final String SAAS_LEC_CONNTRGT = "LECCONNTRGT";
    public static final String SAAS_WWW_FOOTER = "WWWFOOTER";
    public static final String SAAS_ADM_FOOTER = "ADMFOOTER";
    public static final String SAAS_MBR_APLC_USE = "MBRAPLCUSE";
    public static final String SAAS_ITGRT_MBR_USE_YN = "ITGRTMBRUSEYN";
    public static final String CONTENTS_AUTH_CD = "CONTENTSAUTHCD";
    public static final String TPL_CD = "TPLCD";
    public static final String TPL_TYPE_CD = "TPLTYPECD";
    public static final String URI = "URI";

    // 과정 관련 설정.
    public static final String LOGIN_STUDENTNO = "STUDENTNO";
    public static final String LOGIN_CRSCRECD = "CRSCRECD";                                                   // 강의 아이디
    public static final String LOGIN_CRSCRENM = "CRSCRENM";                                                   // 강의 아이디
    public static final String LOGIN_CREYEAR = "CREYEAR";                                                    // 강의 아이디
    public static final String LOGIN_CRETERM = "CRETERM";                                                    // 강의 아이디
    public static final String LOGIN_CLASSUSERTYPE = "CLASSUSERTYPE";                                              // 강의실 권한 그룹
    public static final String LOGIN_CRSMTHD = "CRSMTHD";
    public static final String LOGIN_CRSTYPE = "CRSTYPE";
    public static final String LOGIN_CRSDURATION = "CRSDURATION";
    public static final String LOGIN_PROGESSTYPECD = "PROGESSTYPECD";
    public static final String LOGIN_CRSTYPECD = "CRSTYPECD";
    public static final String LOGIN_FILEBOXUSEAUTHYN = "FILEBOXUSEAUTHYN";
    public static final String LOGIN_AUDITYN = "AUDITYN";                                                    // 학습자 청강생 여부


    // 시스템의 언어키
    public static final String SYSTEM_LOCALEKEY = "LOCALEKEY";                                                  // 언어셋

    // 메뉴 관련 변수명 정의
    public static final String MENU_LOCATION = "LOCATION";                                                   // 현제 페이지
    public static final String CUR_MENU_NAME = "MENUNAME";                                                   // 메뉴 명
    public static final String CUR_MENU_CODE = "MENUCODE";                                                   // 메뉴 코드
    //    public static final String  CUR_MENU_TYPE           = "MENUTYPE";                                                   // 메뉴 유형
    public static final String CUR_AUTHRT_CD = "AUTHRTGRPCD";                                                   // 권한 코드
    public static final String CUR_MENU_TITLE = "MENUTITLE";                                                  // 메뉴 타이틀 이미지
    public static final String CUR_MENU_CHRG_DEPT = "MENUCHRGDEPT";                                               // 메뉴의 담당자 부서
    public static final String CUR_MENU_CHRG_NAME = "MENUCHRGNAME";                                               // 메뉴의 담당자 명
    public static final String CUR_MENU_CHRG_PHONE = "MENUCHRGPHONE";                                              // 메뉴의 담당자 면락처
    public static final String CUR_USER_HOME = "CUR_USER_HOME";                                              // 현재 사용자홈
    public static final String CUR_COR_HOME = "CUR_COR_HOME";                                               // 현재 과목홈
    public static final String ROT_MENU_CODE = "ROOTMENUCODE";                                               // 최상위 메뉴 코드
    public static final String ROT_MENU_GROUP = "ROOTMENUGROUP";                                              // 최상위 메뉴 그룹
    public static final String TEMP_CUR_MENU_CODE = "TEMPMENUCODE";                                               // 임시 메뉴 코드(관리자에서 미리보기시 사용)
    public static final String TEMP_CUR_MENU_NAME = "TEMPMENUNAME";                                               // 임시 메뉴 명(관리자에서 미리보기시 사용)
    public static final String TEMP_MENU_LOCATION = "TEMPLOCATION";                                               // 임시 페이지(관리자에서 미리보기시 사용)
    public static final String MAINTAIN_MENU_SESSION = "MAINTAINMENUSESSION";                                        // 메뉴 세션 유지 유무 (YES or NO)

    /**
     * 컴퓨터의 이름 정보를 시스템 설정에서 가져와서 반환한다.
     **/
    public static final String HOST_NAME = (SERVER_TYPE.equals(SERVERTYPE_UNIX))
            ? System.getenv("HOSTNAME")
            : System.getenv("COMPUTERNAME");

    public static final String FILE_BLOCKED_EXT = framework.getString("FILE.BLOCKED_EXT");

    /**
     * 파일함에 등록된 파일의 확장자별 분류코드 : 문서(DOC) :: FILE_BOX_TYPE_CD 코드 참고
     **/
    public static final String FILEBOX_EXT_TYPE_DOC = framework.getString("framework.filebox.ext_type.doc");
    /**
     * 파일함에 등록된 파일의 확장자별 분류코드 : 동영상(MOV) :: FILE_BOX_TYPE_CD 코드 참고
     **/
    public static final String FILEBOX_EXT_TYPE_MOV = framework.getString("framework.filebox.ext_type.mov");
    /**
     * 파일함에 등록된 파일의 확장자별 분류코드 : 이미지(IMG) :: FILE_BOX_TYPE_CD 코드 참고
     **/
    public static final String FILEBOX_EXT_TYPE_IMG = framework.getString("framework.filebox.ext_type.img");
    /**
     * pdf변환가능 확장자 : 이미지(IMG) :: SYS 코드 참고
     **/
    public static final String PDF_TRANS_AVAIL_EXT_TYPE = framework.getString("framework.pdfTransAvail.ext_type");

    /**
     * DB에 저장 항목의 구분자
     **/
    public static final String SEPERATER_DB = "|"; //일단 씀
    /**
     * 파라매터 항목의 구분자
     **/
    public static final String SEPERATER_PARAM = "!@!"; //일단 씀

    // User Agent Set parameter
    public static final String USER_DEVICE = "USER_DEVICE";        // Device Type
    public static final String USER_APP_TYPE = "APP_TYPE";           // Mobice App Type
    public static final String USER_OS = "USER_OS";            // 사용자 OS
    public static final String USER_BROWSER = "USER_BROWSER";       // 사용자 브라우져

    // Client(사용자) 장치 구분
    public static final String DEVICE_PC = "PC";
    public static final String DEVICE_MOBILE = "MOBILE";

    // Client OS 구분
    public static final String OS_TYPE_WINDOWS[] = framework.getStringArray("framework.mobile.os.windows");
    public static final String OS_TYPE_ANDROID[] = framework.getStringArray("framework.mobile.os.android");
    public static final String OS_TYPE_IOS[] = framework.getStringArray("framework.mobile.os.ios");
    public static final String OS_WINDOWS = "windows";
    public static final String OS_ANDROID = "android";
    public static final String OS_IOS = "ios";

    // Client Browser Type
    public static final String BROWSER_TYPE[] = framework.getStringArray("framework.browser_type");
    public static final String BROWSER_IE = "MSIE";
    public static final String BROWSER_FIREFOX = "Firefox";
    public static final String BROWSER_SAFARI = "Safari";
    public static final String BROWSER_OPERA = "Opera";
    public static final String BROWSER_CHROME = "Chrome";

    // Mobile App Type
    public static final String APP_TYPE[] = framework.getStringArray("framework.mobile.app_type");
    public static final String APP_ANDROID = "Android-App";    // Android App
    public static final String APP_IOS = "iOS-App";        // iOS(iPhone, iPod, iPad) App

    // Mobile Device 인식 문자열
    public static final String MOBILE_DEVICE[] = {"hycuapp", "Android", "iPhone", "iPod", "iPad", "iOS", "Windows CE", "Windows Mobile"};
    //public static final String MOBILE_DEVICE_TAB[]  = framework.getStringArray("framework.mobile.tablet_type");

    // Mobile Device 유형
    public static final String MOBILE_PHONE = "phone";
    public static final String MOBILE_TABLET = "tablet";

    //-- 미디어 서버 관련 설정
    public static final String WOWZA_USE = framework.getString("framework.wowza.use");
    public static final String WOWZA_URL_RTMP = framework.getString("framework.wowza.url.rtmp");
    public static final String WOWZA_URL_RTSP = framework.getString("framework.wowza.url.rtsp");
    public static final String WOWZA_URL_HTTP = framework.getString("framework.wowza.url.http");

    public static final String MEDIA_USE = framework.getString("framework.media.use");
    public static final String MEDIA_URL = framework.getString("framework.media.url");

    public static final String MEDIA_FILE_MP3 = ".mp3,.ogg,.fla";
    public static final String MEDIA_FILE_MP4 = ".mp4,.m4v,.flv";
    public static final String MEDIA_FILE_MMS = ".wmv,.wma";

    public static final String RSA_WEB_KEY = "_RSA_GKEDC_Key_7284"; // 개인키 session key
    public static final String RSA_INSTANCE = "RSA"; // rsa transformation 씀

    public static final String CONFIG_PATH = framework.getString("framework.edutrack.config.path");

    //DB 암복호화 키
    public static final String DB_ENCRYPTION_KEY = framework.getString("framework.edutrack.db.encryption.key");

    //AES 암복호화 키
    public static final String AES_ENCRYPTION_KEY = framework.getString("framework.edutrack.aes.encryption.key"); //일단씀
    public static final String EXAM_AES_ENCRYPTION_KEY = framework.getString("framework.edutrack.exam.aes.encryption.key"); // 시험용 암복호화 키

    // 빌드 타입
    public static final String BUILD_TYPE = framework.getString("framework.system.build_type");
    public final static String BUILDTYPE_DEV = "dev";
    public final static String BUILDTYPE_LOC = "loc";
    public final static String BUILDTYPE_PRD = "prd";

    // 전체공지 게시판 ID
    public final static String BBS_ID_SYSTEM_NOTICE = framework.getString("framework.bbs.id.system.notice");

    // 강의평가 설문 카테고리 코드
    public final static String LECT_EVAL_RESCH_CTGR_CD = framework.getString("framework.lect.eval.resch.ctgr.cd");

    // 만족도 조사 설문 카테고리 코드
    public final static String LEVEL_EVAL_RESCH_CTGR_CD = framework.getString("framework.level.eval.resch.ctgr.cd");

    // erp 사용자 정보 팝업 url
    public final static String USER_INFO_POP_URL = framework.getString("framework.user.info.pop.url");

    // erp 수업계획서 팝업 url
    public final static String LSNPLAN_POP_URL = framework.getString("framework.lsnplan.pop.url");
    public final static String LSNPLAN_POP_URL_STD = framework.getString("framework.lsnplan.pop.url_std");

    // erp 강의평가 팝업 url
    public final static String LECT_EVAL_POP_URL = framework.getString("framework.lect.eval.pop.url");

    // erp 강의평가  url (교수)
    public final static String LECT_EVAL_PROF_URL = framework.getString("framework.lect.eval.prof.url");

    // 외부URL
    public final static String EXT_URL_PORTAL = framework.getString("framework.exturl.portal");
    public final static String EXT_URL_EMAIL = framework.getString("framework.exturl.email");
    public final static String EXT_URL_DEPTCOMM = framework.getString("framework.exturl.deptcomm");
    public final static String EXT_URL_HAKSACALENDAR = framework.getString("framework.exturl.haksacalendar");
    public final static String EXT_URL_SCHOAPLY = framework.getString("framework.exturl.schoaply");
    public final static String EXT_URL_GRADJINDAN = framework.getString("framework.exturl.gradjindan");
    public final static String EXT_URL_GRADJINDAN2 = framework.getString("framework.exturl.gradjindan2");
    public final static String EXT_URL_STUINFO = framework.getString("framework.exturl.stuinfo");
    public final static String EXT_URL_REMOTE = framework.getString("framework.exturl.remote");
    public final static String EXT_URL_EDOC = framework.getString("framework.exturl.edoc");
    public final static String EXT_URL_LCDMS = framework.getString("framework.exturl.lcdms");
    public final static String EXT_URL_EMS = framework.getString("framework.exturl.ems");
    public final static String EXT_URL_GEMS = framework.getString("framework.exturl.gems");
    public final static String EXT_URL_ETS = framework.getString("framework.exturl.ets");
    public final static String EXT_URL_ETS_PREVIEW = framework.getString("framework.exturl.ets_preview");
    public final static String EXT_URL_LSNEVAL = framework.getString("framework.exturl.lsneval");
    public final static String EXT_URL_COST = framework.getString("framework.exturl.cost");
    public final static String EXT_URL_CARD = framework.getString("framework.exturl.card");
    public final static String EXT_URL_EXAMOATH = framework.getString("framework.exturl.examOauth");
    public final static String EXT_URL_EXAMOATH_CHECK = framework.getString("framework.exturl.examOatuh.check");
    public final static String EXT_URL_IDP_TIME_GET = framework.getString("framework.exturl.idp.time_get");
    public final static String EXT_URL_IDP_TIME_PUT = framework.getString("framework.exturl.idp.time_put");
    public final static String EXT_URL_LONOTE_VIEWER = framework.getString("framework.exturl.ltnote_viewer");

    // cms front에서 사용중인 상수
    public static final String CMS_RESPONSE_CONTEXT = framework.getString("framework.lxp.cms.response.context");

    // 통합메시지 호출 API URL
    public static final String SYSMSG_CHECK_YN = framework.getString("framework.sysmsg.check_yn");
    public static final String SYSMSG_URL_LIST = framework.getString("framework.sysmsg.url.list");
    public static final String SYSMSG_URL_SEND = framework.getString("framework.sysmsg.url.send");
    public static final String SYSMSG_URL_SEARCH = framework.getString("framework.sysmsg.url.search");
    public static final String SYSMSG_URL_COUNT = framework.getString("framework.sysmsg.url.count");
    public static final String SYSMSG_URL_INSERT = framework.getString("framework.sysmsg.url.insert");
    public static final String SYSMSG_URL_READ = framework.getString("framework.sysmsg.url.read");

    // zoom jwt api key
    public final static String ZOOM_JWT_API_KEY = framework.getString("framework.zoom.api.key");
    public final static String ZOOM_JWT_API_SECRET_KEY = framework.getString("framework.zoom.api.secret.key");

    // zoom oauth api
    public final static String ZOOM_OAUTH_USER_MANAGE_CLIENT_ID = framework.getString("framework.zoom.oauth.user.manage.client.id");
    public final static String ZOOM_OAUTH_USER_MANAGE_CLIENT_SECRET = framework.getString("framework.zoom.oauth.user.manage.client.secret");
    public final static String ZOOM_OAUTH_ACCOUNT_MANAGE_CLIENT_ID = framework.getString("framework.zoom.oauth.account.manage.client.id");
    public final static String ZOOM_OAUTH_ACCOUNT_MANAGE_CLIENT_SECRET = framework.getString("framework.zoom.oauth.account.manage.client.secret");
    public final static String ZOOM_OAUTH_REST_AUTHORIZATION_URL = framework.getString("framework.zoom.oauth.rest.authorization.url");
    public final static String ZOOM_OAUTH_REST_TOKEN_URL = framework.getString("framework.zoom.oauth.rest.token.url");
    public final static String ZOOM_OAUTH_REST_SCOPE = framework.getString("framework.zoom.oauth.rest.scope");
    public final static String ZOOM_OAUTH_REST_STATE = framework.getString("framework.zoom.oauth.rest.state");
    public final static String ZOOM_OAUTH_REST_REFRESH_TOKEN_EXPIRES_IN = framework.getString("framework.zoom.oauth.rest.refresh.token.expires.in");
    public final static Boolean ZOOM_OAUTH_REST_TOKEN_HEADER_AUTHORIZATION_ENABLE = framework.getBoolean("framework.zoom.oauth.rest.token.header.authorization.enable");

    // 사용자 접속상황 작업위치
    public static final String CONN_HOME = "HOME";
    public static final String CONN_COR_HOME = "COR_HOME";
    public static final String CONN_SBJCT_HOME = "SBJCT_HOME";
    public static final String CONN_BBS = "BBS";
    public static final String CONN_FORUM = "FORUM";
    public static final String CONN_ASMT = "ASMT";
    public static final String CONN_LESSON = "LESSON";
    public static final String CONN_EXAM = "EXAM";
    public static final String CONN_SEMINAR = "SEMINAR";
    public static final String CONN_RESH = "RESH";
    public static final String CONN_ETC = "ETC";
    public static final String CONN_QUIZ = "QUIZ";
    public static final String CONN_SCORE_OVERALL = "SCORE_OVERALL";

    // 사용자 접속체크 시간
    public static final int CONN_USER_CHECK_TIME = framework.getInt("framework.connuser.check.time");

    // 강의실 활동로그 코드 (TB_ORG_CODE 테이블의 ACTN_HSTY_CD)
    public static final String ACTN_HSTY_LECTURE_HOME = "LECTURE_HOME";
    public static final String ACTN_HSTY_NOTIFICATION = "NOTIFICATION";
    public static final String ACTN_HSTY_LESSON = "LESSON";
    public static final String ACTN_HSTY_ASSIGNMENT = "ASSIGNMENT";
    public static final String ACTN_HSTY_FORUM = "FORUM";
    public static final String ACTN_HSTY_QUIZ = "QUIZ";
    public static final String ACTN_HSTY_RESCH = "RESCH";
    public static final String ACTN_HSTY_SEMINAR = "SEMINAR";
    public static final String ACTN_HSTY_EXAM = "EXAM";
    public static final String ACTN_HSTY_COURSE_INFO = "COURSE_INFO";
    public static final String ACTN_HSTY_SCORE_OVERALL = "SCORE_OVERALL";
    public static final String ACTN_HSTY_QBANK = "QBANK";
    public static final String ACTN_HSTY_TEAM_MANAGE = "TEAM_MANAGE";
    public static final String ACTN_HSTY_PROF_INFO = "PROF_INFO";
    public static final String ACTN_HSTY_BBS_MANAGE = "BBS_MANAGE";
    public static final String ACTN_HSTY_COURSE_HOME = "COURSE_HOME";
    public static final String ACTN_HSTY_FORCE_ATTEND = "FORCE_ATTEND";

    // 다중접속(중복 로그인) 방지 환경설정
    public static final String MULTICONN_CHECK_YN = framework.getString("framework.multiconn.check_yn");

    // 학습창 중복방지 체크 여부
    public static final String MULTISTUDY_CHECK_YN = framework.getString("framework.multistudy.check_yn");

    // CDN 정보, 암호화키
    public static final String CDN_URL = framework.getString("framework.cdn.url");
    public static final String CDN_URL_NAS = framework.getString("framework.cdn.url_nas");
    public static final String CDN_SECRET_KEY = framework.getString("framework.cdn.secret.key");
    public static final String CDN_SECRET_IV = framework.getString("framework.cdn.secret.iv");
    public static final String CDN_NAS_YN = framework.getString("framework.cdn.nas_yn");

    // 학습자 로그인 인증방식 체크 여부
    public static final String LOGINGBN_CHECK_YN = framework.getString("framework.stu.logingbn.check_yn");

    // 구글 애널리틱스 사용 여부
    public static final String GOOGLE_ANALYTICS_USE_YN = framework.getString("framework.google.analytics.use_yn");

    // 피드백 메시지 발송 여부
    public static final String FEEDBACK_MESSAGE_SEND_YN = framework.getString("framework.feedback.message_send_yn");

    // 임시 사용자 (학생화면보기)
    public static final String TMP_USER_ID = "tmpuser";

    // SSO URL
    public static final String SSO_URL = framework.getString("framework.sso.front.domain");

    // ERP 연동 API
    public static final String ERP_API_URL = framework.getString("framework.erpapi.url");
    public static final String ERP_API_KEY = framework.getString("framework.erpapi.key");
    public static final String ERP_API_LECT_EVAL_KEY = framework.getString("framework.erpapi.lect.eval.url");

    // 시스템 점검중 안내페이지 표시여부
    public static final String WORK_PAGE_YN = framework.getString("framework.work_page_yn");

    // 대체과제 조회 여부
    public static final String EXAM_STARE_SEARCH_YN = framework.getString("framework.exam_stare_search_yn");

    // 유사도 점수보기 링크 (domain = [e_asmnt, e_forum, e_quiz], docId=[ASMNT_SEND_CD, ATCL_SN, STD_NO_EXAM_CD])
    public static final String KONAN_COPY_SCORE_URL = "https://mosalms.hycu.ac.kr/memechecker/score.html";

    // 유사도 비교 링크 (domain = [e_asmnt, e_forum, e_quiz], docId=[ASMNT_SEND_CD, ATCL_SN, STD_NO_EXAM_CD])
    public static final String KONAN_COPY_COMPARE_URL = "https://mosalms.hycu.ac.kr/memechecker/compare.html";

    // 업로드 금지 확장자
    public static final String[] UPLOAD_NO_EXTS = {"exe", "com", "bat", "cmd", "jsp", "msi", "html", "htm", "js", "scr", "asp", "aspx", "php", "php3", "php4", "ocx", "jar", "war", "py"};

    // Redis
    public static final String REDIS_USE_YN = framework.getString("framework.redis.use_yn");
    public static final String REDIS_HOST = framework.getString("framework.redis.host");
    public static final String REDIS_PORT = framework.getString("framework.redis.port");
    public static final String REDIS_DATABASE = framework.getString("framework.redis.database");
    public static final String REDIS_PASSWORD = framework.getString("framework.redis.password");
    public static final boolean REDIS_USE = "Y".equals(REDIS_USE_YN) ? true : false;

    // SynapDocumentViewer
    public static final String SYNAP_DOC_VIEWER_USE_YN = framework.getString("framework.synap.doc.viewer.use_yn");
    public static final String SYNAP_DOC_VIEWER_PATH = framework.getString("framework.synap.doc.viewer.path");
    public static final String SYNAP_DOC_VIEWER_EXE = framework.getString("framework.synap.doc.viewer.exe");

    // 문서변환 적용 포멧
    public static final String[] DOC_CONVERT_EXTS = {"ppt", "pptx", "doc", "docx", "hwp", "hwpx", "odt", "pdf", "xls", "xlsx"};
    public static final String DOC_CONVERT_FILE_NAME_PREFIX = "c_";
    public static final String DOC_CONVERT_DIR_PATH = "/synap";

    // 오브젝트 스토리지
    public static final String OBJECT_STORAGE_USE_YN = framework.getString("framework.object.storage.use_yn");
    public static final String OBJECT_STORAGE_END_POINT = framework.getString("framework.object.storage.end.point");
    public static final String OBJECT_STORAGE_REGION = framework.getString("framework.object.storage.region");
    public static final String OBJECT_STORAGE_ACCESS_KEY = framework.getString("framework.object.storage.accessKey");
    public static final String OBJECT_STORAGE_SECRET_KEY = framework.getString("framework.object.storage.secretKey");
    public static final String OBJECT_STORAGE_BUKET = framework.getString("framework.object.storage.buket");
    public static final String OBJECT_STORAGE_UPLOAD_PREFIX = framework.getString("framework.object.storage.upload.prefix");

    // 파일유형
    public static final String   FILE_TYPE_IMG			= "IMG";	// 이미지
    public static final String   FILE_TYPE_VIDEO		= "VDO";	// 비디오
    public static final String   FILE_TYPE_AUDIO		= "ADO";	// 오디오
    public static final String   FILE_TYPE_DOC			= "DOC";	// 문서
    public static final String   FILE_TYPE_TXT			= "TXT";	// 텍스트
    public static final String[] FILE_TYPE_IMG_EXT		= {"jpg", "jpeg", "gif", "png", "webp", "tif", "tiff", "bmp", "svg"};
    public static final String[] FILE_TYPE_VIDEO_EXT	= {"mp4", "avi", "wmv", "mov", "mkv", "webm"};
    public static final String[] FILE_TYPE_AUDIO_EXT	= {"mp3", "m4a", "ogg", "wav", "aiff"};
    public static final String[] FILE_TYPE_DOC_EXT		= {"doc", "docx", "xls", "xlsx", "ppt", "pptx", "hwp", "hwpx", "rtf", "pdf"};
    public static final String[] FILE_TYPE_TXT_EXT		= {"txt", "htm", "html", "css", "js", "xml", "csv", "log", "json"};

    // 파일저장소아이디
    public static final String   REPO_BBS				= "BBS";	// 게시판
    public static final String   REPO_DSCS				= "DSCS";	// 토론
    public static final String   REPO_ASMT				= "ASMT";	// 과제
    public static final String   REPO_EXAM				= "EXAM";	// 시험
    public static final String   REPO_SMNR				= "SMNR";	// 세미나
    public static final String   REPO_SRVY				= "SRVY";	// 설문
    public static final String   REPO_CONTS				= "CONTS";	// 강의콘텐츠
    public static final String   REPO_MSG				= "MSG";	// 메시지
    public static final String   REPO_USER				= "USER";	// 사용자


    // 사용자 접속상태 체크값
    public static final String[][] CONN_CHECK_LIST = {
    		{"/profDashboard.do", CONN_HOME},
            {"/stuDashboard.do", CONN_HOME},
            {"/dashboard2.do", CONN_HOME},
            {"/dashboard/widgetStngChange.do", CONN_HOME},
            {"/dashboard/widgetStngPopView.do", CONN_HOME},
            {"/dashboard/widgetStngSelect.do", CONN_HOME},
            {"/crsHomeProf.do", CONN_COR_HOME},
            {"/subject2MainView.do", CONN_COR_HOME},
            {"/crsProfLessonList.do", CONN_COR_HOME},
            {"/crsProfLesson.do", CONN_COR_HOME},
            {"/learnAlarmPop", CONN_COR_HOME},
            {"/crsHomeStd.do", CONN_COR_HOME},
            {"/crsStuLessonList.do", CONN_COR_HOME},
            {"/crsStuLesson.do", CONN_COR_HOME},
            {"/crsProfLessonView.do", CONN_LESSON},
            {"/crsStdLessonView.do", CONN_LESSON},
            {"/crsContentsLessonView.do", CONN_LESSON},
            {"/Form/examList.do", CONN_EXAM},
            {"/examDsblReqExcelDown.do", CONN_EXAM},
            {"/examAbsentExcelDown.do", CONN_EXAM},
            {"/examOathPop.do", CONN_EXAM},
            {"/examOathViewPop.do", CONN_EXAM},
            {"/viewOath.do", CONN_EXAM},
            {"/submitOath.do", CONN_EXAM},
            {"/Form/examStareJoinList.do", CONN_EXAM},
            {"/examStareExcelDown.do", CONN_EXAM},
            {"/Form/examWrite.do", CONN_EXAM},
            {"/writeExam.do", CONN_EXAM},
            {"/Form/examEdit.do", CONN_EXAM},
            {"/editExam.do", CONN_EXAM},
            {"/delExam.do", CONN_EXAM},
            {"/examCopyListPop.do", CONN_EXAM},
            {"/examWriteAsmntPop.do", CONN_EXAM},
            {"/exam/addAsmnt.do", CONN_EXAM},
            {"/exam/editAsmnt.do", CONN_EXAM},
            {"/examWriteForumPop.do", CONN_EXAM},
            {"/exam/addForum.do", CONN_EXAM},
            {"/exam/editForum.do", CONN_EXAM},
            {"/examWriteQuizPop.do", CONN_EXAM},
            {"/examInfoManage.do", CONN_EXAM},
            {"/examQstnManage.do", CONN_EXAM},
            {"/examRetakeManage.do", CONN_EXAM},
            {"/examScoreManage.do", CONN_EXAM},
            {"/examProfMemoPop.do", CONN_EXAM},
            {"/examScoreStatusPop.do", CONN_EXAM},
            {"/stuExamView.do", CONN_EXAM},
            {"/examDsblReqList.do", CONN_EXAM},
            {"/viewExamDsblReqPop.do", CONN_EXAM},
            {"/insertExamDsblReq.do", CONN_EXAM},
            {"/Form/stuExamDsblReqList.do", CONN_EXAM},
            {"/stuExamDsblReqApplicate.do", CONN_EXAM},
            {"/examAbsentList.do", CONN_EXAM},
            {"/examAbsentViewPop.do", CONN_EXAM},
            {"/Form/stuExamAbsentList.do", CONN_EXAM},
            {"/stuExamAbsentApplicatePop.do", CONN_EXAM},
            {"/examAbsentApplicate.do", CONN_EXAM},
            {"/stuExamAbsentApprViewPop.do", CONN_EXAM},
            {"/updateExamAbsent.do", CONN_EXAM},
            {"/updateAllCompanion.do", CONN_EXAM},
            {"/atclList.do", CONN_BBS},
            {"/Form/atclView.do", CONN_BBS},
            {"/Form/atclWrite.do", CONN_BBS},
            {"/Form/atclEdit.do", CONN_BBS},
            {"/addAtcl.do", CONN_BBS},
            {"/editAtcl.do", CONN_BBS},
            {"/bbsAtclSave.do", CONN_BBS}, //게시글저장 new
            {"/popup/viewerList.do", CONN_BBS},
            {"/popup/prevAtclList.do", CONN_BBS},
            {"/Form/infoList.do", CONN_BBS},
            {"/Form/infoWrite.do", CONN_BBS},
            {"/Form/infoEdit.do", CONN_BBS},
            {"/popup/qnaWrite.do", CONN_BBS},
            {"/asmt/profAsmtListView.do", CONN_ASMT},
            {"/asmt/profAsmtRegistView.do", CONN_ASMT},
            {"/asmt/profAsmtSelectView.do", CONN_ASMT},
            {"/asmt/profAsmtEvlView.do", CONN_ASMT},
            {"/asmt/profAsmtFdbkPopView.do", CONN_ASMT},
            {"/asmt/profPrevAsmtListPopView.do", CONN_ASMT},
            {"/asmt/profEzGraderView.do", CONN_ASMT},
            {"/asmt/profAsmtSbmsnHstryPopListView.do", CONN_ASMT},
            {"/asmt/profAsmtMrkExcelUploadPopView.do", CONN_ASMT},
            {"/asmt/profAsmtMrkBulkExcelRegist.do", CONN_ASMT},
            {"/asmt/stu/listView", CONN_ASMT},
            {"/asmt/stu/asmtInfoManage", CONN_ASMT},
            {"/asmt/stu/asmtScoreManage", CONN_ASMT},
            {"/asmt/stu/regAsmnt", CONN_ASMT},
            {"/asmt/stu/evalViewPop", CONN_ASMT},
            {"/asmt/stu/regEval", CONN_ASMT},
            {"/forum/ezgPop/ezgMainForm.do", CONN_FORUM},
            {"/forum/ezgPop/forum.do", CONN_FORUM},
            {"/forum/ezgPop/ezgJoinUserSearchView.do", CONN_FORUM},
            {"/forum/ezgPop/joinUserList.do", CONN_FORUM},
            {"/forum/ezgPop/ezgTotalScoreView.do", CONN_FORUM},
            {"/forum/ezgPop/ezgScoreView.do", CONN_FORUM},
            {"/forum/ezgPop/ezgEvalScoreView.do", CONN_FORUM},
            {"/forum/viewStdSumm.do", CONN_FORUM},
            {"/forum/saveScore.do", CONN_FORUM},
            {"/forum/deleteScore.do", CONN_FORUM},
            {"/forum/forumScoreEvalFeedBack.do", CONN_FORUM},
            {"/forumHome/Form/forumList.do", CONN_FORUM},
            {"/forumHome/forumList.do", CONN_FORUM},
            {"/forumHome/Form/forumView.do", CONN_FORUM},
            {"/forumHome/forumWritePop.do", CONN_FORUM},
            {"/forumHome/Form/addAtcl.do", CONN_FORUM},
            {"/forumHome/teamMemberList.do", CONN_FORUM},
            {"/forumHome/evalStar.do", CONN_FORUM},
            {"/forumHome/Form/forumAdd.do", CONN_FORUM},
            {"/forumHome/atclCount.do", CONN_FORUM},
            {"/forumHome/Form/editForumBbs.do", CONN_FORUM},
            {"/forumHome/Form/addCmnt.do", CONN_FORUM},
            {"/forumHome/Form/editAtcl.do", CONN_FORUM},
            {"/forumHome/Form/delAtcl.do", CONN_FORUM},
            {"/forumHome/Form/editCmnt.do", CONN_FORUM},
            {"/forumHome/Form/delCmnt.do", CONN_FORUM},
            {"/forumHome/forumStuViewList.do", CONN_FORUM},
            {"/forumHome/Form/recom.do", CONN_FORUM},
            {"/forumHome/atclList.do", CONN_FORUM},
            {"/forumLect/Form/forumList.do", CONN_FORUM},
            {"/forumLect/editScoreRatioAjax.do", CONN_FORUM},
            {"/forumLect/Form/infoManage.do", CONN_FORUM},
            {"/forumLect/Form/bbsManage.do", CONN_FORUM},
            {"/forumLect/Form/forumBbsViewList.do", CONN_FORUM},
            {"/forumLect/Form/addForumBbs.do", CONN_FORUM},
            {"/forumLect/Form/addAtcl.do", CONN_FORUM},
            {"/forumLect/Form/editForumBbs.do", CONN_FORUM},
            {"/forumLect/Form/editAtcl.do", CONN_FORUM},
            {"/forumLect/Form/addCmnt.do", CONN_FORUM},
            {"/forumLect/Form/scoreManage.do", CONN_FORUM},
            {"/forumLect/Form/addForumForm.do", CONN_FORUM},
            {"/forumLect/Form/addForum.do", CONN_FORUM},
            {"/forumLect/Form/forumCopyPop.do", CONN_FORUM},
            {"/forumLect/Form/editForumForm.do", CONN_FORUM},
            {"/forumLect/Form/editForum.do", CONN_FORUM},
            {"/forumLect/Form/delForum.do", CONN_FORUM},
            {"/forumLect/Form/delAtcl.do", CONN_FORUM},
            {"/forumLect/Form/editCmnt.do", CONN_FORUM},
            {"/forumLect/Form/delCmnt.do", CONN_FORUM},
            {"/forumLect/listTeamJson.do", CONN_FORUM},
            {"/forumLect/teamMemberList.do", CONN_FORUM},
            {"/forumLect/addStdScore.do", CONN_FORUM},
            {"/forumLect/viewScoreChart.do", CONN_FORUM},
            {"/forumLect/forumProfMemoPop.do", CONN_FORUM},
            {"/forumLect/editForumProfMemo.do", CONN_FORUM},
            {"/forumLect/forumFdbkPop.do", CONN_FORUM},
            {"/forumLect/addFdbkCts.do", CONN_FORUM},
            {"/forumLect/editFdbkCts.do", CONN_FORUM},
            {"/forumLect/delFdbkCts.do", CONN_FORUM},
            {"/forumLect/allAddFdbkCts.do", CONN_FORUM},
            {"/forumLect/uploadForumScoreExcel.do", CONN_FORUM},
            {"/forumLect/listScoreExcel.do", CONN_FORUM},
            {"/forumLect/forumScoreExcelDown.do", CONN_FORUM},
            {"/forumLect/evalForumBbsViewList.do", CONN_FORUM},
            {"/forumLect/forumScoreEvalFeedBack.do", CONN_FORUM},
            {"/listLessonTime.do", CONN_LESSON},
            {"/lessonStudyMemo.do", CONN_LESSON},
            {"/lessonStudyMemoList.do", CONN_LESSON},
            {"/viewLessonStudyMemo.do", CONN_LESSON},
            {"/lessonStudyMemoWritePop.do", CONN_LESSON},
            {"/writeLessonStudyMemo.do", CONN_LESSON},
            {"/editLessonStudyMemo.do", CONN_LESSON},
            {"/deleteLessonStudyMemo.do", CONN_LESSON},
            {"/lessonStudyMemoViewPop.do", CONN_LESSON},
            {"/stdy/saveStdyRecord.do", CONN_LESSON},
            {"/stdEnterStatusList.do", CONN_ETC},
            {"/lessonActnHstyList.do", CONN_ETC},
            {"/lessonActnHstyExcelDown.do", CONN_ETC},
            {"/selectLessonTime.do", CONN_ETC},
            {"/insertLessonTime.do", CONN_ETC},
            {"/updateLessonTime.do", CONN_ETC},
            {"/deleteLessonTime.do", CONN_ETC},
            {"/attendManagePop.do", CONN_ETC},
            {"/lessonStatusDetailPop.do", CONN_ETC},
            {"/selectLessonScheduleAll.do", CONN_ETC},
            {"/selectLessonStudyState.do", CONN_ETC},
            {"/saveForcedAttend.do", CONN_ETC},
            {"/saveForcedAttendBath.do", CONN_ETC},
            {"/cancelForcedAttend.do", CONN_ETC},
            {"/cancelForcedAttendBath.do", CONN_ETC},
            {"/lessonCntsWritePop.do", CONN_ETC},
            {"/insertLessonCnts.do", CONN_ETC},
            {"/updateLessonCnts.do", CONN_ETC},
            {"/deleteLessonCnts.do", CONN_ETC},
            {"/mutLect/listView", CONN_ETC},
            {"/mutLect/getMut", CONN_ETC},
            {"/mutLect/edtDelYn", CONN_ETC},
            {"/mutLect/writeView", CONN_ETC},
            {"/mutLect/regEvalQstn.do", CONN_ETC},
            {"/mutLect/mutEvalWritePop.do", CONN_ETC},
            {"/mutLect/listView", CONN_ETC},
            {"/mutLect/getMut", CONN_ETC},
            {"/mutLect/edtDelYn", CONN_ETC},
            {"/mutLect/writeView", CONN_ETC},
            {"/mutLect/regEvalQstn.do", CONN_ETC},
            {"/mutLect/mutEvalWritePop.do", CONN_ETC},
            {"/resh/Form/reshList.do", CONN_RESH},
            {"/resh/reshQstnPreviewPop.do", CONN_RESH},
            {"/resh/Form/writeResh.do", CONN_RESH},
            {"/resh/writeResh.do", CONN_RESH},
            {"/resh/Form/editResh.do", CONN_RESH},
            {"/resh/editResh.do", CONN_RESH},
            {"/resh/delResh.do", CONN_RESH},
            {"/resh/reshCopyListPop.do", CONN_RESH},
            {"/resh/reshInfoManage.do", CONN_RESH},
            {"/resh/reshQstnManage.do", CONN_RESH},
            {"/resh/uploadReshQstnExcel.do", CONN_RESH},
            {"/resh/reshResultManage.do", CONN_RESH},
            {"/resh/reshJoinUserAnswerExcelDown.do", CONN_RESH},
            {"/resh/reshResultExcelDown.do", CONN_RESH},
            {"/resh/reshQstnCopyPop.do", CONN_RESH},
            {"/resh/copyReshQstn.do", CONN_RESH},
            {"/resh/listReshQstn.do", CONN_RESH},
            {"/resh/listReshSimplePage.do", CONN_RESH},
            {"/resh/reshQstnWritePagePop.do", CONN_RESH},
            {"/resh/reshQstnEditPagePop.do", CONN_RESH},
            {"/resh/writeReshPage.do", CONN_RESH},
            {"/resh/editReshPage.do", CONN_RESH},
            {"/resh/Form/stuReshList.do", CONN_RESH},
            {"/resh/stuReshList.do", CONN_RESH},
            {"/resh/stuReshView.do", CONN_RESH},
            {"/resh/reshJoinPop.do", CONN_RESH},
            {"/resh/reshEditPop.do", CONN_RESH},
            {"/resh/reshJoin.do", CONN_RESH},
            {"/resh/reshResultPop.do", CONN_RESH},
            {"/resh/Form/homeReshList.do", CONN_RESH},
            {"/resh/homeReshResult.do", CONN_RESH},
            {"/resh/Form/lectEvalList.do", CONN_RESH},
            {"/resh/Form/lectEvalView.do", CONN_RESH},
            {"/resh/Form/levelEvalList.do", CONN_RESH},
            {"/resh/Form/levelEvalView.do", CONN_RESH},
            {"/resh/evalReshJoinPop.do", CONN_RESH},
            {"/resh/evalReshJoin.do", CONN_RESH},
            {"/scoreOverall/scoreOverallMain.do", CONN_SCORE_OVERALL},
            {"/seminarHome/Form/seminarList.do", CONN_SEMINAR},
            {"/seminarHome/viewSeminar.do", CONN_SEMINAR},
            {"/seminarHome/seminarList.do", CONN_SEMINAR},
            {"/seminarHome/Form/seminarWrite.do", CONN_SEMINAR},
            {"/seminarHome/writeSeminar.do", CONN_SEMINAR},
            {"/seminarHome/Form/seminarEdit.do", CONN_SEMINAR},
            {"/seminarHome/editSeminar.do", CONN_SEMINAR},
            {"/seminarHome/delSeminar.do", CONN_SEMINAR},
            {"/seminarHome/seminarCopyListPop.do", CONN_SEMINAR},
            {"/seminarHome/seminarAttendManage.do", CONN_SEMINAR},
            {"/seminarHome/seminarStdView.do", CONN_SEMINAR},
            {"/seminarHome/seminarStdAttendLog.do", CONN_SEMINAR},
            {"/seminarHome/seminarAttendStatPop.do", CONN_SEMINAR},
            {"/seminarHome/seminarAtndEdit.do", CONN_SEMINAR},
            {"/seminarHome/Form/stuSeminarList.do", CONN_SEMINAR},
            {"/seminarHome/stuSeminarView.do", CONN_SEMINAR},
            {"/seminarHome/stuSeminarSelfEmailPop.do", CONN_SEMINAR},
            {"/seminarHome/zoomHostStart.do", CONN_SEMINAR},
            {"/seminarHome/zoomJoinStart.do", CONN_SEMINAR},
            {"/seminarHome/recordViewPop.do", CONN_SEMINAR},
            {"/stdLect/stdLearningStatusPop.do", CONN_ETC},
            {"/stdLect/Form/studentList.do", CONN_ETC},
            {"/stdLect/downExcelStudentList.do", CONN_ETC},
            {"/stdLect/Form/attendList.do", CONN_ETC},
            {"/stdLect/Form/stuAttendList.do", CONN_ETC},
            {"/stdLect/downExcelStdAttendList.do", CONN_ETC},
            {"/stdLect/downExcelStdJoinStatus.do", CONN_ETC},
            {"/stdLect/studyStatusPop.do", CONN_ETC},
            {"/stdLect/noAttentListWeekPop.do", CONN_ETC},
            {"/stdLect/downExcelNoStudyWeek.do", CONN_ETC},
            {"/stdLect/studyStatusByWeekPop.do", CONN_ETC},
            {"/submitJoinHistoryPop.do", CONN_ETC},
            {"/attendByLessonScheduleExcelDown.do", CONN_ETC},
            {"/teamMgr/teamList.do", CONN_ETC},
            {"/teamMgr/teamWritePop.do", CONN_ETC},
            {"/teamMgr/teamWrite.do", CONN_ETC},
            {"/teamMgr/editTeamForm.do", CONN_ETC},
            {"/teamMgr/teamAdd.do", CONN_ETC},
            {"/teamMgr/teamEdit.do", CONN_ETC},
            {"/teamMgr/addAutoTeam.do", CONN_ETC},
            {"/teamMgr/listTeam.do", CONN_ETC},
            {"/teamMgr/removeTeam.do", CONN_ETC},
            {"/teamMgr/editTeam.do", CONN_ETC},
            {"/teamMgr/teamListDiv.do", CONN_ETC},
            {"/teamMgr/deleteTeamAll.do", CONN_ETC},
            {"/teamMgr/team_view.do", CONN_ETC},
            {"/teamMgr/addTeam.do", CONN_ETC},
            {"/teamMgr", CONN_ETC},
            {"/teamMgr", CONN_ETC}
    };


    private CommConst() {
        throw new IllegalStateException("CommConst class");
    }

    /**
     * 변수,설정값 가져오기 (JSP에서 참조용)
     *
     * @param name
     * @return value
     */
    public static Object get(String name) {
        try {
            Field field = CommConst.class.getDeclaredField(name);
            return field.get(null);

        } catch(Exception e) {
            return null;
        }
    }
}
