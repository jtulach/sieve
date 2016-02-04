natural <- function() {
  2:9999999999
}
naturalTail <- function(v) {
  v[2:9999999999]
}
Interop.export('Natural', natural)
Interop.export('Tail', naturalTail)
