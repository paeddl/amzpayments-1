{*
* Amazon Advanced Payment APIs Modul
* for Support please visit www.patworx.de
*
*  @author patworx multimedia GmbH <service@patworx.de>
*  In collaboration with alkim media
*  @copyright  2013-2020 patworx multimedia GmbH
*  @license    Released under the GNU General Public License
*}
<div id="payWithAmazonMainDivAbove"{if $hide_button} style="display:none;"{/if}>
	<div id="payWithAmazonDivAbove" class="{if $create_account}amz_create_account{/if}">
	</div>
</div>
{literal}<script> bindCartButton('payWithAmazonDivAbove'); </script>{/literal}