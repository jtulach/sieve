package org.apidesign.demo.pythonrubyjs.fromjava;

import java.io.File;
import java.net.URISyntaxException;
import java.net.URL;
import org.graalvm.polyglot.Context;
import org.graalvm.polyglot.Source;

public final class Main {
    private static void execute(Integer repeat) throws Exception {
        // executing ruby currently requires all access flag to be set.
        Context vm = Context.newBuilder().allowAllAccess(true).build();

        if (repeat != null) {
            vm.eval("js", "count=" + repeat);
        }

        File scriptDir = findScriptDir();
        Source python = Source.newBuilder("python", new File(scriptDir, "sieve.py")).build();
        Source ruby = Source.newBuilder("ruby", new File(scriptDir, "sieve.rb")).build();
        Source js = Source.newBuilder("js", new File(scriptDir, "sieve.js")).build();

        vm.eval(python);
        vm.eval(ruby);
        vm.eval(js);
    }

    private Main() {
    }

    public static void main(String[] args) throws Exception {
        prologAndEpilog(true);
        System.err.println("Setting up PolyglotEngine");
        try {
            Integer count = null;
            if (args.length == 1) {
                count = Integer.parseInt(args[0]);
            }
            execute(count);
        } catch (Throwable err) {
            System.err.println("Initialization problem " + err.getClass().getName() + ": " + err.getMessage());
            System.err.println("Are you running on GraalVM?");
            System.err.println("Download from OTN: http://www.oracle.com/technetwork/oracle-labs/program-languages/overview/index.html");
            prologAndEpilog(false);
            System.exit(1);
        }
    }

    private static void prologAndEpilog(boolean prolog) {
        if (!prolog) {
            System.err.println("*********************************");
        }
        System.err.println();
        System.err.println();
        System.err.println();
        System.err.println();
        if (prolog) {
            System.err.println("*********************************");
        }
    }

    private static File findScriptDir() throws URISyntaxException {
        URL url = Main.class.getProtectionDomain().getCodeSource().getLocation();
        File local = new File(url.toURI());
        for (;;) {
            File sieveInRuby = new File(local, "sieve.rb");
            if (sieveInRuby.exists()) {
                break;
            }
            local = local.getParentFile();
        }
        return local;
    }
}
