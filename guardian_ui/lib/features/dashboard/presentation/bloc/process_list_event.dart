sealed class ProcessListEvent {
  const ProcessListEvent();
}

class ProcessListLoadRequested extends ProcessListEvent {
  const ProcessListLoadRequested();
}

class ProcessListNextPageRequested extends ProcessListEvent {
  const ProcessListNextPageRequested();
}

class ProcessListRefreshRequested extends ProcessListEvent {
  const ProcessListRefreshRequested();
}
