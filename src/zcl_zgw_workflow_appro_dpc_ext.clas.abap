class ZCL_ZGW_WORKFLOW_APPRO_DPC_EXT definition
  public
  inheriting from ZCL_ZGW_WORKFLOW_APPRO_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_EXPANDED_ENTITYSET
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_EXPANDED_ENTITY
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ZGW_WORKFLOW_APPRO_DPC_EXT IMPLEMENTATION.


  method /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_EXPANDED_ENTITY.
**TRY.
*SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_EXPANDED_ENTITY(
**  EXPORTING
**    iv_entity_name           =
**    iv_entity_set_name       =
**    iv_source_name           =
**    it_key_tab               =
**    it_navigation_path       =
**    io_expand                =
**    io_tech_request_context  =
**  IMPORTING
**    er_entity                =
**    es_response_context      =
**    et_expanded_clauses      =
**    et_expanded_tech_clauses =
*       ).
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.

*    data: ls_APPROVALFLOW_HEADER type ZCL_ZGW_WORKFLOW_APPRO_mPC_EXT=>TS_APPROVALFLOW_HEADER,
*          ls_header TYPE y229_st_header.
*    READ TABLE it_key_tab INTO data(is_key_tab1) with key name = 'DocumentId'.
*    READ TABLE it_key_tab INTO data(is_key_tab2) with key name = 'DocumentType'.
*    CONSTANTS : lc_headertolane     TYPE string VALUE 'HEADERTOLANES',
*                lc_headertonode     TYPE string VALUE 'HEADERTONODES',
*                lc_headertocomments TYPE string VALUE 'HEADERTOAPPRVCOMMENTS'.
*        CASE iv_entity_name.
*      WHEN 'HeaderEntity'.
*
*        ls_header-document_id = is_key_tab1-value.
*        ls_header-document_type = is_key_tab2-value.
*        ls_header-created_on = sy-datum.
*        MOVE-CORRESPONDING ls_header TO ls_APPROVALFLOW_HEADER.
*        me->get_approvalflow(
*          EXPORTING
*            is_header = ls_header                                               " Workflow Approval Preview Header
*          IMPORTING
*            et_lanes  = ls_APPROVALFLOW_HEADER-headertolanes                   " Workflow Approval View Lanes
*            et_nodes  = ls_APPROVALFLOW_HEADER-headertonodes                   " Workflow Approval View Nodes
*        ).
*
*        me->get_approval_comments(
*          EXPORTING
*            is_header   = ls_header                                             " Workflow Approval Preview Header
*          IMPORTING
*            et_comments = ls_APPROVALFLOW_HEADER-headertoapprvcomments         " Workflow Approval View Lanes
*        ).
*
*        copy_data_to_ref(
*          EXPORTING
*            is_data = ls_APPROVALFLOW_HEADER
*          CHANGING
*            cr_data = er_entity
*        ).
*        APPEND lc_headertolane TO et_expanded_tech_clauses.
*        APPEND lc_headertonode TO et_expanded_tech_clauses.
*        APPEND lc_headertocomments TO et_expanded_tech_clauses.
*
*    ENDCASE.

  endmethod.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_expanded_entityset.
**TRY.
*SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_EXPANDED_ENTITYSET(
**  EXPORTING
**    iv_entity_name           =
**    iv_entity_set_name       =
**    iv_source_name           =
**    it_filter_select_options =
**    it_order                 =
**    is_paging                =
**    it_navigation_path       =
**    it_key_tab               =
**    iv_filter_string         =
**    iv_search_string         =
**    io_expand                =
**    io_tech_request_context  =
**  IMPORTING
**    er_entityset             =
**    et_expanded_clauses      =
**    et_expanded_tech_clauses =
**    es_response_context      =
*       ).
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.

*    DATA: gs_deep   TYPE zcl_zgw_workflow_appro_mpc_ext=>ts_deep,
*          gt_deep   TYPE TABLE OF zcl_zgw_workflow_appro_mpc_ext=>ts_deep,
*          gt_header TYPE TABLE OF zcl_zgw_workflow_appro_mpc_ext=>ts_headertable,
*          gs_header TYPE zcl_zgw_workflow_appro_mpc_ext=>ts_headertable.




  ENDMETHOD.
ENDCLASS.
