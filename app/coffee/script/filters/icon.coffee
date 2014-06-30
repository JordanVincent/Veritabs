Veritabs.filter "icon", ->
  (tab) ->
    icon = tab.favIconUrl

    if icon and icon.indexOf("chrome://") is -1
      icon
    else
      chrome.extension.getURL("img/empty.png")