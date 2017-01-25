package org.apidesign.demo.rubyjs.fromjava;

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
            File sieveInRuby = new File(local, "sieve.rb");
            if (sieveInRuby.exists()) {
                break;
            }
            local = local.getParentFile();
        }

        Source ruby = Source.newBuilder(new File(local, "sieve.rb")).build();
        Source js = Source.newBuilder(new File(local, "sieve.js")).build();

        vm.eval(ruby);
        vm.eval(js);
    }
}
