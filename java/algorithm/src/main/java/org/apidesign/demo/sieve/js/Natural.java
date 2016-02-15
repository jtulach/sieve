package org.apidesign.demo.sieve.js;

final class Natural {
    private Integer cnt = 2;

    int next() {
        return cnt++;
    }
}
