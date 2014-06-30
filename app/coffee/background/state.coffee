class State

  # attributes

  tabs:     []    # all the current tabs
  active:   true  # either the extension is active or not
  visible:  true  # state opened/closed of the bar
  fixed:    false # either the bar is fixed or not
  width:    200   # width of the bar
  tiny:     false # the tiny mode
  options:
    right:  false # true if the bar is positioned at the right

window.state = new State