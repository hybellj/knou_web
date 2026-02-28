package knou.lms.seminar.api.common;

import org.asynchttpclient.AsyncCompletionHandler;
import org.asynchttpclient.Response;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ZoomAsyncHandler extends AsyncCompletionHandler<Response> {
    
    private static final Logger LOGGER = LoggerFactory.getLogger("api");
    private String className;
    private String methodName;
    
    public ZoomAsyncHandler(String className, String methodName) {
        this.className = className;
        this.methodName = methodName;
    }

    @Override
    public void onThrowable(Throwable t) {
        LOGGER.error("API Async HTTP Request Error In {}.{}", this.className, this.methodName, t);
    }

    @Override
    public Response onCompleted(Response response) throws Exception {
        LOGGER.debug("API Async HTTP Request Completed : " + response.getStatusCode());
        return response;
    }

}
