package org.apidesign.demo.sieve.eratosthenes;

import org.testng.AssertJUnit;
import org.testng.annotations.Test;

public class PrimesTest {
    class PrimesNoLog : Primes() {
        override fun log(msg: String) {}
    }

    @Test
    public fun fifthThousandThPrime() {
        val p : Primes = PrimesNoLog()
        var last : Int = p.compute();
        AssertJUnit.assertEquals("100000th prime is", 1_299_709, last);
    }
}
