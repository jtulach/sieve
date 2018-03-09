package org.apidesign.demo.trufflejs;

import java.io.File;
import java.io.FileReader;
import java.net.URISyntaxException;
import java.net.URL;
import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;

final class Main {
    public static void main(String... args) throws Exception {
        File script = findSieveJs();

        ScriptEngineManager sem = new ScriptEngineManager();
        ScriptEngine engine = sem.getEngineByName("Graal.js");
        if (engine == null) {
            engine = sem.getEngineByMimeType("text/javascript");
        }
        System.err.printf("Using engine %s to run %s%n", engine.getFactory().getEngineName(), script);

        if (args.length == 1) {
            int repeat = Integer.parseInt(args[0]);
            engine.eval("this.count = " + repeat);
        }
        
        try (FileReader reader = new FileReader(script)) {
            engine.eval(reader);
        }
    }

    private static File findSieveJs() throws URISyntaxException {
        URL where = Main.class.getProtectionDomain().getCodeSource().getLocation();
        File script = new File(where.toURI());
        for (;;) {
            File test = new File(script, "sieve.js");
            if (test.exists()) {
                script = test;
                break;
            }
            script = script.getParentFile();
        }
        return script;
    }
}
