class State

  # attributes

  tabs:         []    # all the current tabs
  active:       true  # either the extension is active or not
  visible:      true  # state opened/closed of the bar
  fixed:        false # either the bar is fixed or not
  width:        200   # width of the bar
  tiny:         false # the tiny mode
  options:
    right:      false # position the bar on the right
    fullscreen: false # show the bar only on fullscreen mode
    condensed:  false # tabs' height is reduced

window.state = new State