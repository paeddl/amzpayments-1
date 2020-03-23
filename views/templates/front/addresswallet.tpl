{*
* Amazon Advanced Payment APIs Modul
* for Support please visit www.patworx.de
*
*  @author patworx multimedia GmbH <service@patworx.de>
*  In collaboration with alkim media
*  @copyright  2013-2019 patworx multimedia GmbH
*  @license    Released under the GNU General Public License
*}
{extends file='page.tpl'}

{block name='page_content'}
{nocache}

<h4>{l s='Select your delivery address and your payment method from your Amazon account, to go through the checkout quickly and easily.' mod='amzpayments'}</h4>

<div class="row">
	{if !$virtual_cart}
		<div class="col-xs-12 col-sm-6">
			<div class="row">
				<div class="col-xs-12" id="addressBookWidgetDivBs">
				</div>
				<div class="col-xs-12" id="addressMissings">
				</div>
			</div>
		</div>
	{/if}
	<div class="col-xs-12 col-sm-6">
		<div class="row">
			<div class="col-xs-12" id="walletWidgetDivBs">
			</div>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-xs-12 text-right addressWalletSubmit">
		<button type="button" id="submitAddress" name="submitAddress" class="button btn btn-default button-medium" style="display:none;" data-continue="{l s='Continue' mod='amzpayments'}" data-change="{l s='Save changes' mod='amzpayments'}">
			<span>
				{l s='Continue' mod='amzpayments'}
			</span>
		</button>
	</div>
</div>

{literal}
<script>
jQuery(document).ready(function($) {

    var redirectURL = LOGINREDIRECTAMZ;

	{/literal}{if !$virtual_cart}{literal}
		new OffAmazonPayments.Widgets.AddressBook({
			sellerId: '{/literal}{$sellerID|escape:'htmlall':'UTF-8'}{literal}',
			{/literal}{if isset($amz_session) && $amz_session != ''}{literal}amazonOrderReferenceId: '{/literal}{$amz_session|escape:'htmlall':'UTF-8'}{literal}', {/literal}{/if}{literal}
			onOrderReferenceCreate: function(orderReference) {
				 amazonOrderReferenceId = orderReference.getAmazonOrderReferenceId();
			},
			onAddressSelect: function(orderReference) {
				updateAddressSelection(amazonOrderReferenceId);
			},
			{/literal}{if isset($widgetreadonly)}{literal}
			displayMode: "Read",
			{/literal}{/if}{literal}
			design: {
				designMode: 'responsive'
			},
			onError: function(error) {
				console.log(error.getErrorCode());
				console.log(error.getErrorMessage());
			}
		}).bind("addressBookWidgetDivBs");
	{/literal}{/if}{literal}

	walletWidget = new OffAmazonPayments.Widgets.Wallet({
		sellerId: '{/literal}{$sellerID|escape:'htmlall':'UTF-8'}{literal}',
		{/literal}{if isset($amz_session) && $amz_session != ''}{literal}amazonOrderReferenceId: '{/literal}{$amz_session|escape:'htmlall':'UTF-8'}{literal}', {/literal}{/if}{literal}
		{/literal}{if $virtual_cart}{literal}
			{/literal}{if !isset($amz_session) || $amz_session == ''}{literal}
			onOrderReferenceCreate: function(orderReference) {
				amazonOrderReferenceId = orderReference.getAmazonOrderReferenceId();
			},
			{/literal}{/if}{literal}
		{/literal}{/if}{literal}
		design: {
			designMode: 'responsive'
		},
		onPaymentSelect: function(orderReference) {
			updateAddressSelection(amazonOrderReferenceId);
		},
		onError: function(error) {
			console.log(error.getErrorMessage());
		}
	});	
	walletWidget.setPresentmentCurrency("{/literal}{$currency->iso_code}{literal}");
	walletWidget.bind("walletWidgetDivBs");
});


function updateAddressSelection(amazonOrderReferenceId)
{
	$("#submitAddress").fadeOut();
	var idAddress_delivery = 0;
	var idAddress_invoice = idAddress_delivery;
	var returnback = {/literal}'{if isset($step)}{$step|escape:'javascript':'UTF-8'}{/if}'{literal};
	
	var additional_fields = '';
	$("#addressMissings .additional_field").each(function() {
		additional_fields += '&add[' + $(this).attr("name") + ']=' + $(this).val();		
	});
	
	$.ajax({
		type: 'POST',
		headers: { "cache-control": "no-cache" },
		url: '{/literal}{$ajaxSetAddressUrl nofilter}{literal}' + '?rand=' + new Date().getTime(),
		async: true,
		cache: false,
		dataType : "json",
		data: 'src=addresswallet&returnback=' + returnback + '&amazonOrderReferenceId=' + amazonOrderReferenceId + '&allow_refresh=1&ajax=true&method=updateAddressesSelected&id_address_delivery=' + idAddress_delivery + '&id_address_invoice=' + idAddress_invoice + additional_fields,
		success: function(jsonData)
		{
			if (jsonData.hasError)
			{
				var errors = '';
				for(var error in jsonData.errors)
					if(error !== 'indexOf')
						errors += $('<div />').html(jsonData.errors[error]).text() + "\n";
				alert(errors);
				
				if (jsonData.fields_html) {
					$("#addressMissings").empty();
					$("#addressMissings").html(jsonData.fields_html);
					$("#submitAddress span").text($("#submitAddress").attr("data-change"));
					$("#submitAddress").fadeIn();
					$("#submitAddress").unbind('click').on('click', function() { updateAddressSelection(amazonOrderReferenceId); });
				}
				
			}
			else
			{
				$("#submitAddress span").text($("#submitAddress").attr("data-continue"));
				$("#submitAddress").fadeIn();
				$("#submitAddress").unbind('click').on('click', function() { window.location.href = jsonData.redirect; });
			}
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			if (textStatus !== 'abort')
				alert("TECHNICAL ERROR: unable to save adresses \n\nDetails:\nError thrown: " + XMLHttpRequest + "\n" + 'Text status: ' + textStatus);
		}
	});
}

</script>
{/literal}

{/nocache}

{/block}