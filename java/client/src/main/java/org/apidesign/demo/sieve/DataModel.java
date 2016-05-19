package org.apidesign.demo.sieve;

import java.util.Timer;
import java.util.TimerTask;
import net.java.html.json.Model;
import net.java.html.json.Property;
import org.apidesign.demo.sieve.eratosthenes.Primes;

@Model(className = "Data", targetId="", properties = {
    @Property(name = "messages", type = String.class, array = true)
})
final class DataModel {
    private static Data ui;
    /**
     * Called when the page is ready.
     */
    static void onPageLoad() throws Exception {
        ui = new Data();
        ui.applyBindings();
        final Timer t = new Timer("Compute primes");
        class Schedule extends TimerTask {
            @Override
            public void run() {
                ui.getMessages().clear();
                Primes p = new Primes() {
                    @Override
                    protected void log(String msg) {
                        ui.getMessages().add(msg);
                    }
                };
                long took = p.compute();
                ui.getMessages().add("Computing hundred thousand primes took " + took + " ms");
                t.schedule(new Schedule(), 1000);
            }
        }
        t.schedule(new Schedule(), 1000);
    }
}
