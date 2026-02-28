package knou.lms.file.web;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

public class DEXTUploadX5Request {

    private List<String> DEXTUploadX5_ControlId;
    /*
     * DEXTUploadX5_ControlId
     * dx5.create 메소드를 사용하여 만들어지는 컴포넌트의 DOM 아이디를 가리킨다.
     * 업로드되는 파일의 어느 컴포넌트에 속하는지 알아보기 위한 용도로 사용된다.
     * 
     */

    private List<String> DEXTUploadX5_UniqueId;
    /*
     * DEXTUploadX5_UniqueId
     * 항목의 고유 아이디를 나타낸다.
     * 컴포넌트에 등록된 파일 또는 폴더는 고유 아이디를 자동으로 부여 받는다.
     * 고유 아이디는 하나의 컴포넌트 내에서만 고유성을 갖는다. 
     * 여러 클라이언트 혹은 여러 컴포넌트에서 받은 고유 아이디는 서로 중복이 될 수 있다.
     * 멀티 모듈과 IE 모듈은 고유 아이디가 생성되는 형식이 다르다. 그러므로 고유 아이디는 항목을 구분하는 용도로만 사용해야 한다.
     * 
     */
    
    private List<String> DEXTUploadX5_Folder;
    /*
     * DEXTUploadX5_Folder
     * 폴더(디렉터리) 경로 문자열이다.
     * IE 모듈에서 폴더 다이얼로그를 사용하거나, 폴더를 드래그앤드롭해서 등록된 항목들은 모두 폴더 정보를 가지고 있다.
     * 업로드할 대상이 파일인 경우, 그 파일의 부모 폴더 경로를 나타낸다.
     * 폴더 경로는 사용자 컴퓨터의 루트 위치에서 시작하는 것이 아니라, 선택된 루트 폴더부터 하위 폴더 경로만 나타낸다.
     * 
     */

    private List<String> DEXTUploadX5_EXIFData;
    /*
     * DEXTUploadX5_EXIFData
     * 항목이 갖는 EXIF 데이터이다.
     * 항목이 EXIF 데이터를 갖는 이미지 파일인 경우 setExtractingEXIF 함수를 사용하여 자동으로 추출되도록 설정되었다면, 
     * "이름=값" 형식으로 데이터를 구분자 문자열로 결합하여 서버로 전달된다.
     * EXIF 데이터가 없다면 빈 값이며, 값이 있다면 "이름1[구분자]값1[구분자]이름2[구분자]값2[구분자]이름3[구분자]값3[구분자]" 형식으로 전달된다.
     * 서버에서는 [구분자] 문자열을 가지고 분할을 해야 한다.
     * 
     */
    
    private List<String> DEXTUploadX5_MetaData;
    /*
     * DEXTUploadX5_MetaData
     * 항목이 갖는 메타 데이터이다.
     * 컴포넌트에서 setMetaDataById, setMetaDataByIndex 함수를 사용하여 등록한 "이름=값" 형식의 데이터를 구분자 문자열로 결합하여 서버로 전달된다.
     * 메타 데이터가 없다면 빈 값이며, 값이 있다면 "이름1[구분자]값1[구분자]이름2[구분자]값2[구분자]이름3[구분자]값3[구분자]" 형식으로 전달된다.
     * 서버에서는 [구분자] 문자열을 가지고 분할을 해야 한다.
     * 
     */
    
    private List<MultipartFile> DEXTUploadX5_FileData;
    /*
     * DEXTUploadX5_FileData
     * 바이너리 파일 데이터이다.
     * 업로드하는 대상이 파일이 아닌 폴더라면 0바이트 데이터(빈 파일이므로 파일 이름이 없다.)가 올라간다.
     */

    public DEXTUploadX5Request() {
    }

    public List<String> getDEXTUploadX5_ControlId() {
        return DEXTUploadX5_ControlId;
    }
    public void setDEXTUploadX5_ControlId(List<String> dEXTUploadX5_ControlId) {
        DEXTUploadX5_ControlId = dEXTUploadX5_ControlId;
    }

    public List<String> getDEXTUploadX5_UniqueId() {
        return DEXTUploadX5_UniqueId;
    }
    public void setDEXTUploadX5_UniqueId(List<String> dEXTUploadX5_UniqueId) {
        DEXTUploadX5_UniqueId = dEXTUploadX5_UniqueId;
    }

    public List<String> getDEXTUploadX5_Folder() {
        return DEXTUploadX5_Folder;
    }
    public void setDEXTUploadX5_Folder(List<String> dEXTUploadX5_Folder) {
        DEXTUploadX5_Folder = dEXTUploadX5_Folder;
    }

    public List<String> getDEXTUploadX5_EXIFData() {
        return DEXTUploadX5_EXIFData;
    }
    public void setDEXTUploadX5_EXIFData(List<String> dEXTUploadX5_EXIFData) {
        DEXTUploadX5_EXIFData = dEXTUploadX5_EXIFData;
    }

    public List<String> getDEXTUploadX5_MetaData() {
        return DEXTUploadX5_MetaData;
    }
    public void setDEXTUploadX5_MetaData(List<String> dEXTUploadX5_MetaData) {
        DEXTUploadX5_MetaData = dEXTUploadX5_MetaData;
    }

    public List<MultipartFile> getDEXTUploadX5_FileData() {
        return DEXTUploadX5_FileData;
    }
    public void setDEXTUploadX5_FileData(List<MultipartFile> dEXTUploadX5_FileData) {
        DEXTUploadX5_FileData = dEXTUploadX5_FileData;
    }
    
}
