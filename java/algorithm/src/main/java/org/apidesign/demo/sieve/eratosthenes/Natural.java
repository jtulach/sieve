package org.apidesign.demo.sieve.eratosthenes;

final class Natural {
    private int cnt = 2;

    int next() {
        return cnt++;
    }
}
