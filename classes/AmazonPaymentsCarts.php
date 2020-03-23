<?php
/**
 * 2013-2017 Amazon Advanced Payment APIs Modul
 *
 * for Support please visit www.patworx.de
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Academic Free License (AFL 3.0)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://opensource.org/licenses/afl-3.0.php
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to license@prestashop.com so we can send you a copy immediately.
 *
 *  @author    patworx multimedia GmbH <service@patworx.de>
 *  @copyright 2013-2017 patworx multimedia GmbH
 *  @license   http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
 */

class AmazonPaymentsCarts extends ObjectModel
{
    public $id_customer;

    public $id_cart;

    public $amazon_order_reference_id;

    public static $definition = array(
        'table' => 'amz_carts',
        'primary' => 'id',
        'fields' => array(
            'id_customer' => array('type' => self::TYPE_INT, 'validate' => 'isNullOrUnsignedId', 'copy_post' => false),
            'id_cart' => array('type' => self::TYPE_INT, 'validate' => 'isNullOrUnsignedId', 'copy_post' => false),
            'amazon_order_reference_id' => array('type' => self::TYPE_STRING, 'validate' => 'isGenericName', 'required' => false, 'size' => 255),
            'cart' => array('type' => self::TYPE_STRING, 'required' => false),
        ),
    );

    public static function findByAmazonOrderReferenceId($amazon_order_reference_id)
    {
        $result = Db::getInstance(_PS_USE_SQL_SLAVE_)->getRow(
            'SELECT a.`id` FROM `' . _DB_PREFIX_ . 'amz_carts` a 
                WHERE a.`amazon_order_reference_id` = "' . pSQL($amazon_order_reference_id) . '"'
        );
        if ($result['id']) {
            return new self($result['id']);
        } else {
            return false;
        }
    }
}
