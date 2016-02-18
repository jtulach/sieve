package org.apidesign.demo.sieve.eratosthenes;

import static org.testng.AssertJUnit.assertEquals;
import org.testng.annotations.Test;

public class PrimesTest {
    @Test
    public void fifthThousandThPrime() {
        Primes p = new Primes() {
            @Override
            protected void log(String msg) {
            }
        };
        int last = p.compute();
        assertEquals("5000th prime is", 48611, last);
    }
}
