import polyglot

class Natural:
    n = 2

    def next(self):
        r = self.n
        self.n = self.n + 1
        return r

def create():
  return Natural()

polyglot.export_value("Natural", create);
