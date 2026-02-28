package knou.framework.util;

import java.io.File;
import java.lang.ProcessBuilder.Redirect; // jdk 1.7 이상
import java.util.Timer;
import java.util.TimerTask;

import knou.framework.common.CommConst;

public class ConvertToHtml {
    
    private final String SN3HCV_HOME = CommConst.SYNAP_DOC_VIEWER_PATH;
    private final String SN3HCV = SN3HCV_HOME + CommConst.SYNAP_DOC_VIEWER_EXE;
    private final String TEMPLATE = SN3HCV_HOME + "template";
    private final String MODULES = SN3HCV_HOME + "modules";
    /*
    * 변환 호출
    * inputFile : 변환 대상 파일의 절대 경로
    * outputPath : 변환된 HTML 파일 저장 경로
    * resultName : 생성할 HTML 파일명 (ex; sample => sample.htm 파일 생성됨)
    * return : 0 (변환 성공), 0 이외의 값 (변환 실패)
    */
    public int convertToHtml(String inputFile, String outputPath, String resultName) {

        // 기존 변환 결과 존재 여부 확인
        File htmlFile = new File(outputPath + "/" + resultName + ".xml");
        File htmlDir = new File(outputPath + "/" + resultName + ".files");

        // 기존 변환 결과가 존재하지 않을 경우 변환 실행
        if (!htmlFile.exists() || !htmlDir.isDirectory()) {
            String[] cmd = {SN3HCV, "-t", TEMPLATE, "-mod_path", MODULES, 
                inputFile, outputPath, resultName};
            try {
                Timer t = new Timer();
                // JDK 1.7 이상
                ProcessBuilder builder = new ProcessBuilder(cmd);
                builder.redirectOutput(Redirect.INHERIT);
                builder.redirectError(Redirect.INHERIT);
                Process proc = builder.start();

                // JDK 1.6 이하
                /*
                Process proc = Runtime.getRuntime().exec(cmd);
                proc.getErrorStream().close();
                proc.getInputStream().close();
                proc.getOutputStream().close();
                */

                TimerTask killer = new TimeoutProcessKiller(proc);
                t.schedule(killer, 200000); // 200초 (변환이 200초 안에 완료되지 않으면 프로세스 종료)

                int exitValue = proc.waitFor();
                killer.cancel();
    
                return exitValue;
            } catch (Exception e) {
                e.printStackTrace();
                return -1;
            }
        }
        else {
            return 0;   // 기존 변환 결과가 존재함. 정상 변환으로 처리
        }
    }
    
}