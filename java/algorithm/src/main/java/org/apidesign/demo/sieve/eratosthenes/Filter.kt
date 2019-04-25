package org.apidesign.demo.sieve.eratosthenes;

final class Filter(private val number: Int) {
    private var next: Filter? = null;
    private var last: Filter = this;

    fun acceptAndAdd(n: Int): Boolean {
        var filter: Filter? = this;
        val upto: Double = Math.sqrt(n.toDouble())
        while (filter != null) {
            val reminder : Int = Math.floorMod(n, filter.number)
            if (reminder == 0) {
                return false;
            }
            if (filter.number > upto) {
                val newFilter = Filter(n);
                last.next = newFilter;
                last = newFilter;
                return true;
            }
            filter = filter.next;
        }
        return false
    }
}
