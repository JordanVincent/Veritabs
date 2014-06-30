class DataStorage

  # TODO catch error
  # Save the state of the extension in local storage
  saveState: (state) ->
    state = _.cloneDeep(state)
    state = @_removeTabsFromState(state)

    chrome.storage.sync.set
      state: state
    , =>
      @_displayError()

  # TODO catch error
  # Load the state saved in local storage
  loadState: (callback, target) ->
    chrome.storage.sync.get "state", (items) =>
      @_displayError()

      if items and items.state
        state = @_removeTabsFromState(items.state)
        callback.call(target, state) if callback

  # Removes tabs otherwise QUOTA_BYTES_PER_ITEM is exceded when saving
  _removeTabsFromState: (state) ->
    delete state.tabs
    state

  # Logs the error if existing
  _displayError: ->
    console.error(chrome.runtime.lastError) if chrome.runtime.lastError

window.DataStorage = new DataStorage