// Copyright (c) 2013 Jordan Vincent. All rights reserved.

// Map containing the ports
var ports = {};

// The current state of the plugin
var state = {
    tabs: [],
    active:     true,   // either the extension is active or not
    visible:    true,   // state opened/closed of the bar
    fixed:      false,  // either the bar is fixed or not
    width:      200,    // Width of the bar
    settings:   false,  // The settings page is open
    tiny:       false,  // The tiny mode
    options: {
        right:  false   // true if the bar is positioned at the right
    }
};

// Open storage
loadState(function(){
    refreshTab(null);
});

// Connexion established 
chrome.extension.onConnect.addListener(function(port) {

    // Remove port when disconnected
	port.onDisconnect.addListener(function() {

		delete ports[port.sender.tab.id];
	});

    // Adding the port by its tab id
	ports[port.sender.tab.id] = port;

    // Init the tab
    refreshTab(port.sender.tab.id);

    // Message listener
    port.onMessage.addListener(function(msg) {

// TODO cleaning
        if (msg.type == "init")
        {   }

        else if (msg.type == "openSideBar")
            state.visible = true;
            
        else if (msg.type == "closeSideBar")
            state.visible = false;

        else if (msg.type == "close")
            chrome.tabs.remove(msg.tabId);

        else if (msg.type == "activate")
            chrome.tabs.highlight({tabs:[msg.tabIndex]},function(window) {});

        else if (msg.type == "new")
            chrome.tabs.create({},function(){});

        else if (msg.type == "move")
            chrome.tabs.move(msg.tabId, {index:msg.posIndex});

        else if (msg.type == "width")
            state.width = msg.width;

        else if (msg.type == "fix")
            state.fixed = msg.fixed;

        else if (msg.type == "tiny")
            state.tiny = msg.tiny;

        else if (msg.type == "settings"){
            state.settings = msg.settings;
            console.log(state);
        }

        else if (msg.type == "settingsOptions")
            state.options = msg.options;
        
        if ( msg.type == "width" || msg.type == "fix" || msg.type == "tiny" || msg.type == "settingsOptions" )
            saveState();
        // refreshTabs();
    });
});

// Messages between the popup and the background
chrome.extension.onMessage.addListener(
    function(request, sender, sendResponse) {

        if (request.type == 'active'){
            state.active = request.active;
            refreshTab(null);
            saveState();

        }else if (request.type == 'settings'){
            state.settings = request.settings;
            refreshTab(null);

        }else if (request.type == 'init'){
           // Nothing 
        }

        sendResponse({state: state});
});
/*
chrome.extension.sendMessage({type: 'active', active:true}, function(response) {
    console.log(response);
});*/

/* LISTENERS */

// Tab activated
chrome.tabs.onActivated.addListener(function(activeInfo) {
    refreshTab(activeInfo.tabId);  
});

// Window removed
/*chrome.windows.onRemoved.addListener(function(windowId){

    // If last window removed, we save the current state
    chrome.windows.getAll(null, function(windows){
        alert(windows);
        if (windows.length <= 1){
            saveState();
        }
    })  
});*/

// Returns the current tab, null if not found
// Params: - callback (function(tab)) 
function getCurrentTab(callback){
    chrome.tabs.query(
    {
        active: true,
        windowType:"normal", 
        windowId:chrome.windows.WINDOW_ID_CURRENT 
        
    }, function(tabs){
        var tab = (tabs.length > 0 ? tabs[0] : null);
        if (callback !== "undefined")
            callback.call(this,tab);
    }); 
}

// Send a message to refresh the tab, if tabId is null, it refreshes the current tab
// Params: tabId (integer) the tab to refresh
function refreshTab(tabId){

    var sendTabs = function(tabId){

        chrome.tabs.query(
        {
            //windowType:"normal", 
            windowId:chrome.windows.WINDOW_ID_CURRENT 
            
        }, function(tabs){
            state.tabs = tabs;

            // At the init, the port is not intentiated first
            if (ports[tabId])
                ports[tabId].postMessage({type:'refresh', state:state});
        }); 
    };

    if (tabId === 'undefined' || tabId == null){
        getCurrentTab(function(tab){
            if (tab != null){
                sendTabs(tab.id);
            }  
        });
    }else sendTabs(tabId);
}

// TODO catch error
// Save the state of the extension in local storage
function saveState(){

    state.settings = false;

    chrome.storage.sync.set({'state': state}, function() {
        console.error('error ?', chrome.runtime.lastError);
    });
}

// TODO catch error
// Load the state saved in local storage
function loadState(callback){

    chrome.storage.sync.get('state', function(items) {

        if (items && items.state){
            var currentTabs = state.tabs;
            state = items.state;
            state.tabs = currentTabs;
            state.visible = false;// TODO remove...
console.log(state);
            console.error('error ?', chrome.runtime.lastError);

            if (callback !== "undefined"){ 
                callback.call(this);
            }
        }
    });
}





