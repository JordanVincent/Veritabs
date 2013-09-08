// Copyright (c) 2013 Jordan Vincent. All rights reserved.

// Init
chrome.extension.sendMessage({type: 'init'}, function(response) {
	var active = response.state.active;
console.log(response.state);
	setAllowed(response.state.tabs);
	activate(active);
});

// Btn activate
$('#t_activateBtn').click(function(){

	var active = $(this).hasClass('active');
	activate(!active);

	chrome.extension.sendMessage({type: 'active', active:!active}, function(response) {
		window.close();
	});
});

// Btn settings
$('#t_settingsBtn').click(function(){

	chrome.extension.sendMessage({type: 'settings', settings:true}, function(response) {
		window.close();
	});

});

// Activate or deactivate the extension
function activate(active){
	if (active){
		$('#t_activateBtn').addClass('active');
		$('#t_activateBtn').html('Deactivate');
		chrome.browserAction.setIcon({
			path:{
				"19": chrome.extension.getURL("img/icons/icon19.png"),    
      			"38": chrome.extension.getURL("img/icons/icon38.png") 	
      	}},function(){console.log('on')}); 
	}else {
		$('#t_activateBtn').removeClass('active');
		$('#t_activateBtn').html('Activate');
		chrome.browserAction.setIcon({
			path:{
				"19": chrome.extension.getURL("img/icons/icon19off.png"),    
      			"38": chrome.extension.getURL("img/icons/icon38off.png") 	
      	}},function(){console.log('off')}); 
	}
}

function setAllowed(tabs){

	var i=0;
	for (i; i<tabs.length && !tabs[i].active; i++){}

	if (i<tabs.length && tabs[i].active && (tabs[i].url.indexOf("chrome://") !== -1) || tabs[i].url.indexOf("chrome-extension://") !== -1 ){
		$('#t_info').show();
	}else $('#t_info').hide();	
}