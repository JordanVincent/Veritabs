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
              <div 
                id="t_fixBtn" class="t_barBtn" 
                ng-hide="state.tiny" 
                ng-click="state.fixed = !state.fixed; refresh();" 
                ng-class="{active:state.fixed}" >
              </div> 
              <div 
                id="t_newBtn" 
                class="t_barBtn" 
                ng-click="clickNewBtn()" >{{a}}
              </div> 
              <div 
                id="t_resizeBtn"
                ng-hide="state.tiny" 
                resize="state" 
                stop="refresh()"
                class="t_barBtn">
              </div>      
            </div> 
          </div> 
          <div id="t_content" scroll> 
            <div 
              id="t_tabContainer" 
              ui-sortable="sortableOptions" 
              ng-model="state.tabs"
              >
              <div 
                ng-repeat="tab in state.tabs" 
                class="t_item" 
                ng-class="{active:tab.active}" 
                ng-style="{'left': tab.hover && state.options.right ? -185 : 0 , 'width': tab.hover ? 200 : 'auto' }"
                ng-model="tab" 
                ng-click="$parent.activateTab(tab)"
                tab-hover="state"
              >
                <img class="t_ico" ng-src="{{tab | icon}}">
                <span class="t_title">{{tab.title}}{{a}}</span>
                <span class="close" ng-click="$parent.closeTab(tab)" ></span>
              </div>

            </div> 
          </div> 
          <div id="t_bottomPanel" > 
            <a 
              id="t_settingsBtn"
              class="t_barBtn" 
              ng-hide="state.tiny"  
              ng-click="clickSettingsBtn()" 
              ng-href="{{optionsUrl}}"
              target="_blank"
              >
            </a> 
            <div 
              id="t_spacerBtn"
              class="t_barBtn t_spacer"
              ng-hide="state.tiny" >
            </div> 
            <div 
              id="t_tinyModeBtn" 
              class="t_barBtn" 
              ng-click="state.tiny = ! state.tiny; refresh();" 
              ng-class="{active:state.tiny}" >
            </div> 
          </div> 
        </div> 
        <div id="t_handler" ></div>
      </div>
    </div>
    """

  # To be executed at the end
  angular.bootstrap $("#t_sidebar"), ['veritabs']