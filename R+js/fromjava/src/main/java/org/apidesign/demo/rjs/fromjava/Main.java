package org.apidesign.demo.rjs.fromjava;

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

        URL url = Main.class.getProtectionDomain().getCodeSource().getLocation();
        File local = new File(url.toURI());
        for (;;) {
            File sieveInRuby = new File(local, "sieve.R");
            if (sieveInRuby.exists()) {
                break;
            }
            local = local.getParentFile();
        }

        Source r = Source.fromFileName(new File(local, "sieve.R").getPath());
        Source js = Source.fromFileName(new File(local, "sieve.js").getPath());

        vm.eval(r);
        vm.eval(js);
    }
}
