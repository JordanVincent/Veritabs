  # Create the sidebar
  $("body").before """
    <div 
      ng-csp 
      ng-controller="PanelController" 
      ng-model="state" 
      id="t_sidebar" 
      show="state"
      ng-style="{'width': state.tiny ? 30 : state.width}"
    > 
      <div id="t_inner">
        <div id="t_panel"> 
          <div id="t_topPanel"> 
            <div id="t_topPanelCommon"> 
              <div ng-hide="state.tiny" id="t_fixBtn" class="t_barBtn" ng-click="state.fixed = !state.fixed" ng-class="{active:state.fixed}" ></div> 
              <div id="t_newBtn" class="t_barBtn" ng-click="clickNewBtn()" ></div> 
              <div ng-hide="state.tiny" id="t_resizeBtn" resize="state" class="t_barBtn"></div>      
            </div> 
          </div> 
          <div id="t_content" > 
            <div id="t_tabContainer">

              <div 
                ng-repeat="tab in state.tabs" 
                class="t_item" 
                ng-class="{active:tab.active}" 
                ng-style="{'left': tab.hover && state.options.right ? -185 : 0 , 'width': tab.hover ? 200 : 'auto' }"
                tab-hover="state"
                ng-model="tab" 
              >
                <img class="t_ico" ng-src="{{tab | icon}}">
                <span class="t_title">{{tab.title}}</span>
                <span class="close" ng-click="closeTab(tab)" ></span>
              </div>

            </div> 
          </div> 
          <div id="t_bottomPanel" > 
            <div ng-hide="state.tiny" id="t_settingsBtn" class="t_barBtn" ng-click="clickSettingsBtn()" ></div> 
            <div ng-hide="state.tiny" id="t_spacerBtn" class="t_barBtn t_spacer"></div> 
            <div id="t_tinyModeBtn" class="t_barBtn" ng-click="state.tiny = ! state.tiny" ng-class="{active:state.tiny}" ></div> 
          </div> 
        </div> 
        <div id="t_handler" ></div>
      </div>
    </div>
    """

  # To be executed at the end
  angular.bootstrap $("#t_sidebar"), ['veritabs']