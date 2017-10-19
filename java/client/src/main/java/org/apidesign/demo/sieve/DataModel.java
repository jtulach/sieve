package org.apidesign.demo.sieve;

import java.util.ArrayList;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;
import net.java.html.charts.Chart;
import net.java.html.charts.Color;
import net.java.html.charts.Config;
import net.java.html.charts.Values;
import net.java.html.json.Function;
import net.java.html.json.Model;
import net.java.html.json.ModelOperation;
import net.java.html.json.Property;
import org.apidesign.demo.sieve.eratosthenes.Primes;

@Model(className = "Data", targetId="", instance = true, properties = {
    @Property(name = "message", type = String.class),
    @Property(name = "startOrStop", type = String.class),
    @Property(name = "running", type = boolean.class)
})
final class DataModel {
    private static Data ui;

    private final Timer timer = new Timer("Compute primes");
    private List<Values> data;

    @ModelOperation
    void initialize(Data model) {
        Chart<Values, Config> chart = Chart.createLine(new Values.Set("a label", Color.valueOf("white"), Color.valueOf("black")));
        data = chart.getData();
        data.add(new Values("0", 0));
        chart.applyTo("chart");
        model.setStartOrStop("Start");
        model.applyBindings();
    }

    @Function
    void startStop(final Data model) {
        if (model.isRunning()) {
            model.setStartOrStop("Start");
            model.setRunning(false);
        } else {
            model.setStartOrStop("Stop");
            model.setRunning(true);
            final List<Integer> results = new ArrayList<>();
            class Schedule extends TimerTask {
                @Override
                public void run() {
                    Primes p = new Primes() {
                        @Override
                        protected void log(String msg) {
                        }
                    };
                    long start = System.currentTimeMillis();
                    int value = p.compute();
                    int took = (int) (System.currentTimeMillis() - start);
                    model.setMessage("Computing hundred thousand primes took " + took + " ms, last prime is " + value);
                    results.add(took);
                    if (model.isRunning()) {
                        timer.schedule(new Schedule(), 1000);
                    } else {
                        model.addMeasurements(results);
                    }
                }
            }
            timer.schedule(new Schedule(), 1);
        }
    }

    @ModelOperation
    void addMeasurements(Data model, List<Integer> times) {
        for (Integer time : times) {
            data.add(new Values("#" + data.size(), time));
        }
    }

    /**
     * Called when the page is ready.
     */
    static void onPageLoad() throws Exception {
        ui = new Data();
        ui.initialize();
    }
}
