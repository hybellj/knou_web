package knou.framework.util;

import java.io.File;
import java.io.IOException;

import org.jcodec.api.FrameGrab;
import org.jcodec.common.io.FileChannelWrapper;
import org.jcodec.common.io.NIOUtils;

import knou.framework.common.CommConst;

public class VideoUtil {

    // 동영상 길이 리턴 (초)
    public static int getVideoSecound(String path) throws Exception {
        double durationInSeconds = 0;
        FileChannelWrapper channel = null;
        
        try {
            String dataPath = CommConst.WEBDATA_PATH;
            
            if(!dataPath.equals("") && (dataPath.substring(dataPath.length()-1).equals("/") 
                || dataPath.substring(dataPath.length()-1).equals("\\") )) {

                dataPath = dataPath.substring(0, dataPath.length()-1);
            }
            
            path = path.replace("/\\/g", "/");
            if(!path.equals("") && !path.substring(0,1).equals("/")) {
                path = "/"+path;
            }
            if(!path.equals("") && !path.substring(path.length()-1).equals("/") ) {
                path += "/";
            }
            
            System.out.println("동영상 파일경로 \n" + path);
            
            File videoFile = new File(dataPath + path);
            channel = NIOUtils.readableChannel(videoFile);
            FrameGrab frameGrab = FrameGrab.createFrameGrab(channel);
            durationInSeconds = Math.floor(frameGrab.getVideoTrack().getMeta().getTotalDuration());
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("동영상 길이 체크 ERROR \n" + e);
            throw e;
        } finally {
            try {
                channel.close();
            } catch (IOException e) {
                
            }
        }
        
        return (int) durationInSeconds;
    }
}
