package org.apidesign.demo.sieve;

import net.java.html.boot.BrowserBuilder;

public final class Main {
    private Main() {
    }

    public static void main(String... args) throws Exception {
        BrowserBuilder.newBrowser().
            loadPage("pages/index.html").
            loadClass(Main.class).
            invoke("onPageLoad", args).
            showAndWait();
        System.exit(0);
    }

    public static void onPageLoad(String... args) throws Exception {
        Integer repeat = null;
        if (args.length == 1) {
            repeat = Integer.parseInt(args[0]);
            if (repeat == 0) {
                repeat = null;
            }
        }
        DataModel.onPageLoad(repeat);
    }

}
