package org.apidesign.demo.sieve.r;

import com.oracle.truffle.api.source.Source;
import com.oracle.truffle.api.vm.PolyglotEngine;
import java.io.File;
import java.net.URL;

public final class Main {
    private Main() {
    }

    public static void main(String[] args) throws Exception {
        System.err.println("Setting up PolyglotEngine");
        PolyglotEngine vm = PolyglotEngine.newBuilder().
            build();

        vm.eval(Source.fromText("", "warmup.R").withMimeType("text/x-r"));

        URL url = Main.class.getProtectionDomain().getCodeSource().getLocation();
        File local = new File(url.toURI());
        for (;;) {
            File sieveInR = new File(local, "sieve.R");
            if (sieveInR.exists()) {
                break;
            }
            local = local.getParentFile();
        }
        System.err.println("engine is ready");

        Source r = Source.fromFileName(new File(local, "sieve.R").getPath());

        vm.eval(r);
    }
}
