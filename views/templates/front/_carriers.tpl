{*
* Amazon Advanced Payment APIs Modul
* for Support please visit www.patworx.de
*
*  @author patworx multimedia GmbH <service@patworx.de>
*  In collaboration with alkim media
*  @copyright  2013-2020 patworx multimedia GmbH
*  @license    Released under the GNU General Public License
*}

{if isset($delivery_options)}

  <div id="hook-display-before-carrier">
    {$hookDisplayBeforeCarrier nofilter}
  </div>
  
  {if $delivery_options|count}
    <h3>{l s='Please select your shipping method' mod='amzpayments'}</h3>
  {/if}

  <div class="delivery-options-list">
    {if $delivery_options|count}
    
        <div class="form-fields">
          {block name='delivery_options'}
            <div class="delivery-options">
              {foreach from=$delivery_options item=carrier key=carrier_id}
                  <div class="delivery-option row">
                    <div class="col-md-1">
                      <span class="custom-radio pull-xs-left">
                        <input type="radio" name="delivery_option[{$id_address}]" id="delivery_option_{$carrier.id}" value="{$carrier_id}"{if $delivery_option == $carrier_id} checked{/if}>
                        <span></span>
                      </span>
                    </div>
                    <label for="delivery_option_{$carrier.id}" class="col-md-11 delivery-option-2">
                      <div class="row">
                        <div class="col-md-1">
                          {if $carrier.logo}
                            <img src="{$carrier.logo}" alt="{$carrier.name}">
                            {else}
                            &nbsp;
                          {/if}
                        </div>
                        <div class="col-md-4 text-xs-left">
                          <span class="h6 carrier-name">{$carrier.name}</span>
                        </div>
                        <div class="col-md-4">
                          <span class="carrier-delay">{$carrier.delay}</span>
                        </div>
                        <div class="col-md-3">
                          <span class="carrier-price">{$carrier.price}</span>
                        </div>
                      </label>
                    </div>
                  </div>
              {/foreach}
            </div>
          {/block}
          <div class="order-options">            
			{if $recyclablePackAllowed}
              <label>
                <input type="checkbox" name="recyclable" value="1" {if $recyclable} checked {/if}>
                <span>{l s='I would like to receive my order in recycled packaging.' d='Shop.Theme.Checkout'}</span>
              </label>
            {/if}
            {if $gift.allowed}
              <label>
                <input type="checkbox" name="gift" value="1" {if $gift.isGift} checked {/if}>
                <span>{$gift.label}</span>
              </label>
              <label for="gift_message">{l s='If you\'d like, you can add a note to the gift:' d='Shop.Theme.Checkout'}</label>
              <textarea rows="2" cols="120" id="gift_message" name="gift_message">{$gift.message}</textarea>
            {/if}
          </div>
        </div>
    {else}
      <p class="alert alert-danger">{l s='Unfortunately, there are no carriers available for your delivery address.' d='Shop.Theme.Checkout'}</p>
    {/if}
  </div>

  <div id="hook-display-after-carrier">
    {$hookDisplayAfterCarrier nofilter}
  </div>

  <div id="extra_carrier"></div>

{else}
	<p>{l s='Please wait...' mod='amzpayments'}</p>
{/if}