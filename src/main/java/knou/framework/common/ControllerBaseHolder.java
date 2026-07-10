package knou.framework.common;

import org.springframework.ui.ModelMap;

public class ControllerBaseHolder {

    private static final ThreadLocal<ModelMap> modelHolder = new ThreadLocal<>();

    public static void setModelMap(ModelMap model) {
        modelHolder.set(model);
    }

    public static ModelMap getModelMap() {
        return modelHolder.get();
    }

    public static void clear() {
        modelHolder.remove();
    }
}