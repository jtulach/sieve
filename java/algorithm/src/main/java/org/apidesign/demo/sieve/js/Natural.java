package org.apidesign.demo.sieve.js;

final class Natural {
    private int cnt = 2;

    int next() {
        return cnt++;
    }
}
