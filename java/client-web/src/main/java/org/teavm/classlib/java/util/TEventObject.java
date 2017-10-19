package org.teavm.classlib.java.util;

public class TEventObject {
    private final Object src;

    public TEventObject(Object source) {
        this.src = source;
    }

    public Object getSource() {
        return src;
    }
}
