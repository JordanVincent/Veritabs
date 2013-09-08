// Copyright (c) 2013 Jordan Vincent. All rights reserved.

( function($){

// The current state of the plugin
var state = {
    tabs: 		[],
    active: 	true,   // either the extension is active or not
    visible: 	true, 	// State opened/closed of the bar
    fixed: 		false,  // Either the bar is fixed or not
    width: 		200,    // Width of the bar
    resizing: 	false,	// Either the user is currently resizing the bar
    settings: 	false,	// The settings page is open
    tiny: 		false,  // The tiny mode
    options: {
    	right: 	false   // true if the bar is positioned at the right
    }   
};

// Create the sidebar
$('body').before(
	'<div id="t_sidebar" style="width:'+state.width+';" >'+
		'<div id="t_inner">'+
			'<div id="t_panel">'+
				'<div id="t_topPanel">'+
					'<div id="t_topPanelFullS" >'+
						'<div id="t_prevBtn" class="t_barBtn"></div>'+
						'<div id="t_nextBtn" class="t_barBtn"></div>'+
						'<div id="t_reloadBtn" class="t_barBtn"></div>'+
						'<div id="t_homeBtn" class="t_barBtn"></div>'+
					'</div>'+
					'<div id="t_topPanelCommon">'+
						'<div id="t_fixBtn" class="t_barBtn"></div>'+
						'<div id="t_newBtn" class="t_barBtn"></div>'+
						'<div id="t_resizeBtn" class="t_barBtn"></div>'+
					'</div>'+
				'</div>'+
				'<div id="t_content" >'+
					'<div id="t_tabContainer"></div>'+
				'</div>'+
				'<div id="t_bottomPanel" >'+
					'<div id="t_settingsBtn" class="t_barBtn"></div>'+
					'<div id="t_spacerBtn" class="t_barBtn t_spacer"></div>'+
					'<div id="t_tinyModeBtn" class="t_barBtn"></div>'+
				'</div>'+
			'</div>'+
			'<div id="t_handler" ></div>'+
		'</div>'+
	'</div>'
);

// DOM elements
var $sidebar 		= $('#t_sidebar'),
	$inner 			= $('#t_inner'),
	$panel 			= $('#t_panel'),
	$content 		= $('#t_content'),
	$tabContainer 	= $('#t_tabContainer'),
	$topPanel 		= $('#t_topPanel'),
	$topPanelFullS 	= $('#t_topPanelFullS'),
	$topPanelCommon = $('#t_topPanelCommon'),
	$bottomPanel 	= $('#t_bottomPanel'),
	
	$prevBtn 		= $('#t_prevBtn'),
	$nextBtn 		= $('#t_nextBtn'),
	$reloadBtn 		= $('#t_reloadBtn'),
	$homeBtn 		= $('#t_homeBtn'),
	$fixBtn 		= $('#t_fixBtn'),
	$newBtn 		= $('#t_newBtn'),
	$resizeBtn 		= $('#t_resizeBtn'),
	$settingsBtn 	= $('#t_settingsBtn'),
	$spacerBtn		= $('#t_spacerBtn'),
	$tinyModeBtn 	= $('#t_tinyModeBtn');

////////////////// EVENTS //////////////////

// Open the sidebar when the mouse hit the left border
// Close it if the mouse doesn't focus
$('html').mousemove(function(e){

	// Open
	if (mustOpenPanel(e.pageX)){
		state.visible = true; 
		$sidebar.fadeIn();
		port.postMessage({type: "openSideBar"});
			
	// Close
	} else if (mustClosePanel(e.pageX)){
		state.visible = false; 
		$sidebar.fadeOut();
		port.postMessage({type: "closeSideBar"});
	}
});

// Buttons 

// Sticks the bar
$fixBtn.click(function(){

	state.fixed = !state.fixed;
	setFixed(state.fixed);

	port.postMessage({type: "fix", fixed:state.fixed});
});

// Fix or not the panel
function setFixed(fixed){

	if (fixed){ 
		$fixBtn.addClass('active'); 
		$sidebar.show();

	}else $fixBtn.removeClass('active');
}

// Creates a new tab
$newBtn.click(function(){
	console.log(port);
	port.postMessage({type: "new"});
});

// Resizes the panel
$resizeBtn.draggable({
	helper: "",
	
	start: function(){
		state.resizing = true;

	},
	drag: function(e,ui){

		if (state.options.right){
			state.width = document.width-ui.offset.left;	
			$sidebar.width(state.width);

		}else{
			state.width = ui.position.left+15;	
			$sidebar.width(state.width);
		} 
	},
	stop: function(){
		state.resizing = false;
		port.postMessage({type: "width", width: state.width});
	}
});

// Goes to the settings page
$settingsBtn.click(function(){
	openSettingsPage();
});

// Switch to Tiny Mode
$tinyModeBtn.click(function(){

	state.tiny = !state.tiny;
	setTinyMode(state.tiny);

	port.postMessage({type: "tiny", tiny:state.tiny});
});

// Set the tiny mode
function setTinyMode(tiny){

	if (tiny){ 
		$tinyModeBtn.addClass('active'); 
		$fixBtn.hide();
		$resizeBtn.hide();
		$settingsBtn.hide();
		$spacerBtn.hide();
		$sidebar.width(30);

	}else{
		$tinyModeBtn.removeClass('active');
		$fixBtn.show();
		$resizeBtn.show();
		$settingsBtn.show();
		$spacerBtn.show();
		$sidebar.width(state.width); 
	}
	tabsHoverHandler();
}

// Scroolling through the panel
window.onmousewheel = document.onmousewheel = function(e) {

    if($(e.srcElement).parents("#t_content").size() != 0 || $(e.srcElement).get(0) == $("#t_content").get(0)) {

        e = e || window.event;

        if (e.preventDefault)
            e.preventDefault();

        e.returnValue = false;
		scrollBy(e.wheelDeltaY);
    }
};

/////// CONNEXION TO BACKGROUND SCRIPT ///////

// Port connexion
var port = chrome.extension.connect();

port.postMessage({type: "init"});

// Message received
port.onMessage.addListener(function(msg) {
console.log(msg);
	if (msg.type == 'refresh'){

		var newState = msg.state,
			tabs = newState.tabs;

		// Tabs refreshing
		removeTabs();
		createTabs(tabs);

		// State refreshing
		refreshState(newState);

	}
});

// Port disconnected -> reconnect
port.onDisconnect.addListener(function(a) {
	reConnectPort();
});

////////////////// TOOL BOX //////////////////

// Creates the settings page
function openSettingsPage(){

	state.settings = true; 
	port.postMessage({type: "settings", settings:state.settings});

	$settingsBtn.addClass('active');
	$('html > *').not('head').css('-webkit-filter', 'blur(2px)');
	
	$('body').before(
		'<div id="t_overlay" >'+
			'<div id="t_settings">'+
				'<div id="t_settingsHeader">'+
					'<h1>Veritabs</h1>'+
					'<h2>Organize your tabs vertically</h2>'+
				'</div>'+
				'<div id="t_settingsContent">'+
					'<div id="t_settingsNavigation" >'+
						'<ul>'+
							'<li class="active" anchor="settings" >Settings</li>'+
							'<li anchor="news" >Comming soon</li>'+
						'</ul>'+
					'</div>'+
					'<div id="t_settingsDetails" >'+
						'<div class="t_settingsPanel" anchor="settings">'+
							'<h2>Settings</h2>'+
							'<label><input type="checkbox" '+(state.options.right?'checked="checked"':'')+'" name="right" value=""><span>Attach the bar to the right side of the screen</span></label>'+
							//'<label><input type="checkbox" name="" value=""><span>Only show when too many tabs</span></label>'+
						'</div>'+
						'<div class="t_settingsPanel" style="display:none;" anchor="news">'+
							'<h2>Comming Soon</h2>'+
							'<p>List of new features coming soon:</p>'+
							'<ul>'+
								'<li>Groups of tabs</li>'+
								'<li>Enhancing the full screen experience</li>'+
							'</ul>'+
						'</div>'+
					'</div>'+
				'</div>'+
				'<div id="t_copyright">This plugin has been designed and developed by <a href="http://jordan-vincent.com" target="_blank">Jordan Vincent</a>.<br>&copy; 2013 Jordan Vincent All Rights Reserved.</div>'+
			'</div>'+
		'</div>'
	);
	var $overlay = $('#t_overlay');

	$overlay.fadeIn();

	// Click on the buttons on the navigation panel
	$('#t_settingsNavigation li').click(function(){
		var anchor = $(this).attr('anchor');

		$('#t_settingsNavigation li').removeClass('active');
		$(this).addClass('active');

		$('.t_settingsPanel').hide();
		$('.t_settingsPanel[anchor="'+anchor+'"]').show();	
	});

	// Click on a setting option
	$('#t_settingsDetails input').change(function(){

		var optionName = $(this).attr('name'),
			optionValue = $(this).is(':checked');

		// set the state to the new value
		if (optionName){
			state.options[optionName] = optionValue;
			port.postMessage({type: "settingsOptions", options:state.options});
		}

		fixToRightSide(state.options.right);
		tabsHoverHandler();

	});

	// Quit settings page
	$overlay.click(function(e){
		if (e.target == $overlay[0]){
			closeSettingsPage();
		}
	});
}

// Removes the settings page
function closeSettingsPage(){
	var $overlay = $('#t_overlay');

	$settingsBtn.removeClass('active');

	$overlay.fadeOut(400, function(){
		$overlay.remove();
		$('html > *').not('head').css('-webkit-filter', 'blur(0px)');

		state.settings = false; 
		console.log(state);
		port.postMessage({type: "settings", settings:state.settings});
	});
}

// Returns true if the settings page is open
function isSettingsPageOpen(){
	return ( $('#t_overlay').size() != 0 ?  true : false );
}

// Reconnect the port when disconnected
function reConnectPort(){
	port = chrome.extension.connect();
	port.postMessage({type: "toto"});

	port.onDisconnect.addListener(function(a) {
		reConnectPort();
	});
}

// Creates the tabs 
function createTabs(tabs){

	for (var i=0 ; i<tabs.length; i++){
	
		var tabIconSrc = tabs[i].favIconUrl;
		tabIconSrc = (
			tabIconSrc && tabIconSrc.indexOf("chrome://") === -1?
			tabIconSrc:
			chrome.extension.getURL("img/empty.png")
		);
		
		var active = (tabs[i].active?"active":"");
		$tabContainer.append('<div id="tab'+tabs[i].id+'" tabId='+tabs[i].id+' class="t_item '+active+'" ><img class="t_ico" src="'+tabIconSrc+'"></img><span class="t_title">'+tabs[i].title+'</span><span class="close"></span></div>');
	}

	// Handlers
	tabsClickHandler();
	tabsHoverHandler();
	tabsDragDropHandler();
}

// Refresh the curent state using the state given in paramenter
function refreshState(newState){

	state = newState;

	// opened/closed
	( state.visible ? $sidebar.show() : $sidebar.hide() ); 
	
	// width
	$sidebar.width(state.width); 
	
	// fixed
	setFixed(state.fixed); 

	// settings page
	if (state.settings && !isSettingsPageOpen()) openSettingsPage();
	else if (!state.settings && isSettingsPageOpen()) closeSettingsPage();

	// right/left
	fixToRightSide(state.options.right);

	// tiny mode
	setTinyMode(state.tiny);

	// active
	if (!state.active)
		$sidebar.hide();

	
}

// Removes the tabs
function removeTabs(){
	$('#t_sidebar .t_item').remove();
}

// Handler for the click event on the tabs
function tabsClickHandler(){

	$('#t_sidebar .t_item').click(function(e){
		var tabId = parseInt($(this).attr("tabId"));

		if (e.target == $(this).children('.close')[0]){
			port.postMessage({type: "close", tabId: tabId});
			$(this).remove();
		}
		else
			port.postMessage({type: "activate", tabIndex:$('.t_item').index(this)});
	});
}

// Handler for the hover event on the tabs
function tabsHoverHandler(){

	if (state.tiny){
		$('#t_sidebar .t_item').hover(function(e){
			
			$('#t_sidebar .t_item').width('auto');
			$(this).width(200); // DOTO set anim to 200ms

			if (state.options.right){ 
				$('#t_sidebar .t_item').position().left = 0;
				$(this).css({left:-185});		
			}
		},function(e){
			$('#t_sidebar .t_item').width('auto');
			if (state.options.right) $('#t_sidebar .t_item').css({left:0});		
		});
	}else{
		$('#t_sidebar .t_item').unbind('hover');
	}
}



// Handler for the click event on the tabs
function tabsDragDropHandler(){

	$tabContainer.sortable({
		axis:'y',
		revert: 300,
		scroll: false,
		helper: function(e,elt) { 
			return elt.clone(); 
		},
		stop: function( event, ui ) {
			
			var tab = ui.item;
			var tabId = parseInt(tab.attr("tabId"));
			var newPos = $('.t_item').index(ui.item);

			port.postMessage({type: "move", tabId: tabId, posIndex: newPos});
		},
		sort: function( event, ui ) {
			
			var helperY = ui.helper.position().top,
				helperH = ui.helper.height(),
				h 		= $content.height(),
				posY 	= $tabContainer.position().top,
				margin	= 40;


			//console.log(helperY,posY,helperH);

			// List begining
			if ( helperY - margin < -posY )
				scrollBy(helperH*5);

			// List ending
			else if ( (helperY+helperH+margin) > (-posY+h) )
				scrollBy(-helperH*5);
		
		}
    });
}

// Scrolls the tab container of dy px
// params: dy: the number of pixel to scroll, negative to the bottom, positive to the top
function scrollBy(dy){

	var posY = $tabContainer.position().top+dy;
	scrollTo(posY);
}

// Scrolls the tab container to y
// params: y: the vertical position
function scrollTo(y){

	var h = $content.height(),
		H = $tabContainer.height();

	if (y > 0) y = 0; 			// Begining of the scroll
	else if (H<h) y = 0;		// No scroll needed 
	else if (H+y<h) y = h-H;	// End of the scroll

	$tabContainer.animate(
		{'top': y},
		{queue: false, duration: 200}
	);
}

// Fix the bar to the right side of the screen if the parameter is true, to the left otherwise 
// Params: right (bool)
function fixToRightSide(right){

	if (right){
		$sidebar.css('right',0);
		$topPanelCommon.css('-webkit-flex-direction','row-reverse');
		$fixBtn.css('-webkit-transform','scaleX(-1)');

	}else{ 
		$sidebar.css('right','auto');
		$topPanelCommon.css('-webkit-flex-direction','row');
		$fixBtn.css('-webkit-transform','none');
	}
}

// Return true if the panel must close considering the value x of the mouse
// Params: x (integer)
function mustClosePanel(x){
	return ( 
		(
			(
				(!state.options.right && x > state.width ) 
				|| (state.options.right && x < document.width-state.width )
			) 
			&& !state.fixed && !state.resizing && !state.settings && state.visible && !state.tiny
		)|| !state.active // TODO manage the state.active better
	);
}

// Return true if the panel must open considering the value x of the mouse
// Params: x (integer)
function mustOpenPanel(x){

	return ((
		(
			(
				(!state.options.right && x == 0 )
				|| (state.options.right && x >= document.width-10 )
			)
			&& !state.settings && !state.visible 
		)|| state.tiny) && state.active // TODO manage the state.active better
	);
}

})(jQuery) // Allow using the $ tag

