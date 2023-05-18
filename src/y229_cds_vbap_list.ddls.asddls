@AbapCatalog.sqlViewName: 'Y229_CDS_LIST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'cds view for sales document item'
define view y229_cds_vbap_list 
as select from vbap as sales_doc_item
inner join makt as material_desc on material_desc.matnr = sales_doc_item.matnr
{
   key sales_doc_item.vbeln as Sales_document,
   key sales_doc_item.posnr as Item,
   sales_doc_item.matnr as Material,
   material_desc.maktx as Description,
   sales_doc_item.matkl as Material_Group,
   sales_doc_item.pstyv as Item_Cat 
}
