CLASS zcl_zgw_workflow_ap_01_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zgw_workflow_ap_01_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES ts_nodestoquickview TYPE zcl_zgw_workflow_ap_01_mpc_ext=>ts_nodestoquickview .
    TYPES:
      tt_nodestoquickview TYPE TABLE OF zcl_zgw_workflow_ap_01_mpc_ext=>ts_nodestoquickview .

    METHODS /iwbep/if_mgw_appl_srv_runtime~get_expanded_entity
        REDEFINITION .
protected section.

  methods APPRHEADERSET_GET_ENTITY
    redefinition .
private section.

  methods GET_APPROVAL_COMMENTS
    importing
      !IS_HEADER type Y229_ST_HEADER
    exporting
      !ET_COMMENTS type Y229_TT_COMMENTS .
  methods GET_APPROVALFLOW_DETAILS
    importing
      !IS_HEADER type Y229_ST_HEADER
    exporting
      !ET_LANES type Y229_TT_LANES
      !ET_NODES type TT_NODESTOQUICKVIEW .
ENDCLASS.



CLASS ZCL_ZGW_WORKFLOW_AP_01_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_expanded_entity.
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

    DATA: ls_apprheader TYPE zcl_zgw_workflow_ap_01_mpc_ext=>ts_approverheader,
          ls_header     TYPE y229_st_header.
    READ TABLE it_key_tab INTO DATA(is_key_tab1) WITH KEY name = 'DocumentId'.
    READ TABLE it_key_tab INTO DATA(is_key_tab2) WITH KEY name = 'DocumentType'.

    CONSTANTS: lc_headertonodes    TYPE string VALUE 'HEADERTONODES/NODESTOQUICKVIEW',
               lc_headertonodes1   TYPE string VALUE 'HEADERTONODES/NODESTOGROUPS',
               lc_headertonodes2   TYPE string VALUE 'HEADERTONODES/NODESTOELEMENTS',
               lc_headertolanes    TYPE string VALUE 'HEADERTOLANES',
               lc_headertocomments TYPE string VALUE 'HEADERTOCOMMENTS',
               lc_nodestoquickview TYPE string VALUE 'NODESTOQUICKVIEW',
               lc_quickviewtogroup TYPE string VALUE 'QUICKVIEWTOGROUP'.

    CASE iv_entity_name.
      WHEN 'ApprHeader'.
        ls_header-document_id = is_key_tab1-value.
        ls_header-document_type = is_key_tab2-value.
        ls_header-created_on = sy-datum.
        MOVE-CORRESPONDING ls_header TO ls_apprheader.
        me->get_approvalflow_details(
        EXPORTING
          is_header = ls_header
          IMPORTING
            et_nodes = ls_apprheader-headertonodes
            et_lanes = ls_apprheader-headertolanes
            ).
        me->get_approval_comments(
        EXPORTING
          is_header = ls_header
          IMPORTING
            et_comments = ls_apprheader-headertocomments
            ).
        copy_data_to_ref(
        EXPORTING
          is_data = ls_apprheader
          CHANGING
            cr_data = er_entity
            ).

        APPEND lc_headertolanes TO et_expanded_tech_clauses.
        APPEND lc_headertonodes TO et_expanded_tech_clauses.
        APPEND lc_headertonodes1 to et_expanded_tech_clauses.
        APPEND lc_headertonodes2 to et_expanded_tech_clauses.
        APPEND lc_headertocomments TO et_expanded_tech_clauses.

    ENDCASE.

  ENDMETHOD.


  METHOD apprheaderset_get_entity.
**TRY.
*SUPER->APPRHEADERSET_GET_ENTITY(
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_request_object       =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**  IMPORTING
**    er_entity               =
**    es_response_context     =
*       ).
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.


    READ TABLE it_key_tab INTO DATA(is_key_tab1) WITH KEY name = 'DocumentId'.
    READ TABLE it_key_tab INTO DATA(is_key_tab2) WITH KEY name = 'DocumentType'.
    er_entity-created_on = sy-datum.
    er_entity-document_id = is_key_tab1-value.
    er_entity-document_type = is_key_tab2-value.
  ENDMETHOD.


  METHOD get_approvalflow_details.

data: ls_lanes TYPE y229_st_lanes,
      ls_nodes TYPE  ts_nodestoquickview,
      ls_quickview TYPE y229_st_quickview,
      ls_groups TYPE ZST_WF_APPRV_QVGRPS,
      ls_elements TYPE ZST_WF_APPRV_QVGRP_E.

*********Lanes****************
 ls_lanes-document_id  = is_header-document_id.
    ls_lanes-document_type  = is_header-document_type.
    ls_lanes-id       = '0'.
    ls_lanes-icon     = 'sap-icon://person-placeholder'.
    ls_lanes-label    = 'Supervisor'.
    ls_lanes-position = 0.
    APPEND ls_lanes TO et_lanes.
    ls_lanes-id       = '1'.
    ls_lanes-icon     = 'sap-icon://person-placeholder'.
    ls_lanes-label    = 'Financial Approver1'.
    ls_lanes-position = 1.
    APPEND ls_lanes TO et_lanes.
    ls_lanes-id       = '2'.
    ls_lanes-icon     = 'sap-icon://person-placeholder'.
    ls_lanes-label    = 'Financial Approver 2'.
    ls_lanes-position = 2.
    APPEND ls_lanes TO et_lanes.
    ls_lanes-id       = '3'.
    ls_lanes-icon     = 'sap-icon://person-placeholder'.
    ls_lanes-label    = 'Ap Audit'.
    ls_lanes-position = 3.
    APPEND ls_lanes TO et_lanes.

**********Nodes**********************

*----------Node1-----*
    ls_nodes-id                 = 1.
    ls_nodes-lane               = 0.
    ls_nodes-title              = 'Approver1'.
    ls_nodes-titleabbreviation  = 'APR 1' .
    ls_nodes-children           = '[4, 2]'.
    ls_nodes-state              = 'Positive'.
    ls_nodes-statetext          = 'Approved'.
    ls_nodes-highlighted        = abap_false.
    ls_nodes-focused            = abap_false.
    ls_nodes-type               = 'Single'.
    ls_nodes-texts              = '[Approval Date 23/04/2023]'.

     ls_quickview-nodeid = '1'.
    ls_quickview-header = 'Approver Info'.
    ls_quickview-icon = 'sap-icon://person-placeholder'.
    ls_quickview-title = 'Approver 4'.
    ls_quickview-description = 'Manager'.
    APPEND ls_quickview to ls_nodes-nodestoquickview.

    ls_groups-pageid = '1'.
    ls_groups-groupid = '1'.
    ls_groups-heading = 'Contact Details'.
    APPEND ls_groups TO ls_nodes-nodestogroups.
    ls_groups-pageid = '1'.
    ls_groups-groupid = '1'.
    ls_groups-heading = 'Request Details'.
    APPEND ls_groups TO ls_nodes-nodestogroups.
    ls_groups-pageid = '1'.
    ls_groups-groupid = '1'.
    ls_groups-heading = 'Request Status'.
    APPEND ls_groups TO ls_nodes-nodestogroups.

*    *----------Node2-----*

    ls_nodes-id                 = 2.
    ls_nodes-lane               = 1.
    ls_nodes-title              = 'Approver4'.
    ls_nodes-titleabbreviation  = 'APR 4' .
    ls_nodes-children           = '[21]'.
    ls_nodes-state              = 'Positive'.
    ls_nodes-statetext          = 'Approved'.
    ls_nodes-highlighted        = abap_false.
    ls_nodes-focused            = abap_false.
    ls_nodes-type               = 'Single'.
    ls_nodes-texts              = '[Approval Date", "01/23/2023]'.

     ls_quickview-nodeid = '2'.
    ls_quickview-header = 'Approver Info'.
    ls_quickview-icon = 'sap-icon://person-placeholder'.
    ls_quickview-title = 'Approver 4'.
    ls_quickview-description = 'Consultant'.
    APPEND ls_quickview to ls_nodes-nodestoquickview.

     ls_groups-pageid = '2'.
    ls_groups-groupid = '2'.
    ls_groups-heading = 'Contact Details'.
    APPEND ls_groups TO ls_nodes-nodestogroups.
    ls_groups-pageid = '2'.
    ls_groups-groupid = '2'.
    ls_groups-heading = 'Request details'.
    APPEND ls_groups TO ls_nodes-nodestogroups.
    ls_groups-pageid = '2'.
    ls_groups-groupid = '2'.
    ls_groups-heading = 'Request Status'.
     APPEND ls_groups TO ls_nodes-nodestogroups.



*    *----------Node21-----*

    ls_nodes-id                 = 21.
    ls_nodes-lane               = 2.
    ls_nodes-title              = 'Approvers'.
    ls_nodes-titleabbreviation  = 'APRS' .
    ls_nodes-children           = '[3]'.
    ls_nodes-state              = 'Negative'.
    ls_nodes-statetext          = 'Approval Pending'.
    ls_nodes-highlighted        = abap_false.
    ls_nodes-focused            = abap_false.
    ls_nodes-type               = 'Single'.
    ls_nodes-texts              = '[Pending]'.

     ls_quickview-nodeid = '21'.
    ls_quickview-header = 'Approver Info'.
    ls_quickview-icon = 'sap-icon://person-placeholder'.
    ls_quickview-title = 'Approver 4'.
    ls_quickview-description = 'Senior Consultant'.
     APPEND ls_quickview to ls_nodes-nodestoquickview.

     ls_groups-pageid = '21'.
    ls_groups-groupid = '21'.
    ls_groups-heading = 'Contact Details'.
     APPEND ls_groups TO ls_nodes-nodestogroups.
    ls_groups-pageid = '21'.
    ls_groups-groupid = '21'.
    ls_groups-heading = 'Request details'.
    APPEND ls_groups TO ls_nodes-nodestogroups.
    ls_groups-pageid = '21'.
    ls_groups-groupid = '21'.
    ls_groups-heading = 'Request Status'.
     APPEND ls_groups TO ls_nodes-nodestogroups.

*     *----------Node3-----*

    ls_nodes-id                 = 3.
    ls_nodes-lane               = 3.
    ls_nodes-title              = 'Approver6'.
    ls_nodes-titleabbreviation  = 'APR 6' .
    ls_nodes-children           = '[]'.
    ls_nodes-state              = 'Neutral'.
    ls_nodes-statetext          = ''.
    ls_nodes-highlighted        = abap_false.
    ls_nodes-focused            = abap_false.
    ls_nodes-type               = 'Single'.
    ls_nodes-texts              = ''.

     ls_quickview-nodeid = '3'.
    ls_quickview-header = 'Approver Info'.
    ls_quickview-icon = 'sap-icon://person-placeholder'.
    ls_quickview-title = 'Approver 3'.
    ls_quickview-description = 'HR Manager'.
    APPEND ls_quickview to ls_nodes-nodestoquickview.

    ls_groups-pageid = '3'.
    ls_groups-groupid = '3'.
    ls_groups-heading = 'Contact Details'.
    APPEND ls_groups TO ls_nodes-nodestogroups.
    ls_groups-pageid = '3'.
    ls_groups-groupid = '3'.
    ls_groups-heading = 'Request details'.
     APPEND ls_groups TO ls_nodes-nodestogroups.
    ls_groups-pageid = '3'.
    ls_groups-groupid = '3'.
    ls_groups-heading = 'Request Status'.
     APPEND ls_groups TO ls_nodes-nodestogroups.


*    *----------Node4-----*

    ls_nodes-id                 = 4.
    ls_nodes-lane               = 1.
    ls_nodes-title              = 'Approver3'.
    ls_nodes-titleabbreviation  = 'APR 3' .
    ls_nodes-children           = '[21]'.
    ls_nodes-state              = 'Positive'.
    ls_nodes-statetext          = 'Approved'.
    ls_nodes-highlighted        = abap_false.
    ls_nodes-focused            = abap_false.
    ls_nodes-type               = 'Single'.
    ls_nodes-texts              = '["Approved", "02/23/2023"]'.

     ls_quickview-nodeid = '4'.
    ls_quickview-header = 'Approver Info'.
    ls_quickview-icon = 'sap-icon://person-placeholder'.
    ls_quickview-title = 'Approver 2'.
    ls_quickview-description = 'Senior Manager'.
     APPEND ls_quickview to ls_nodes-nodestoquickview.


    ls_groups-pageid = '4'.
    ls_groups-groupid = '4'.
    ls_groups-heading = 'Contact Details'.
    APPEND ls_groups TO ls_nodes-nodestogroups.
    ls_groups-pageid = '4'.
    ls_groups-groupid = '4'.
    ls_groups-heading = 'Request details'.
     APPEND ls_groups TO ls_nodes-nodestogroups.
    ls_groups-pageid = '4'.
    ls_groups-groupid = '4'.
    ls_groups-heading = 'Request Status'.
     APPEND ls_groups TO ls_nodes-nodestogroups.


*    *----------Node5-----*

    ls_nodes-id                 = 5.
    ls_nodes-lane               = 0.
    ls_nodes-title              = 'Approver2'.
    ls_nodes-titleabbreviation  = 'APR 2' .
    ls_nodes-children           = '[2, 4]'.
    ls_nodes-state              = 'Positive'.
    ls_nodes-statetext          = 'Approved'.
    ls_nodes-highlighted        = abap_false.
    ls_nodes-focused            = abap_false.
    ls_nodes-type               = 'Single'.
    ls_nodes-texts              = '["Approved", "01/20/2023"]'.

    ls_quickview-nodeid = '5'.
    ls_quickview-header = 'Approver Info'.
    ls_quickview-icon = 'sap-icon://person-placeholder'.
    ls_quickview-title = 'Approver 1'.
    ls_quickview-description = 'Team Lead'.
     APPEND ls_quickview to ls_nodes-nodestoquickview.

 ls_groups-pageid = '5'.
    ls_groups-groupid = '5'.
    ls_groups-heading = 'Contact Details'.
     APPEND ls_groups TO ls_nodes-nodestogroups.
    ls_groups-pageid = '5'.
    ls_groups-groupid = '5'.
    ls_groups-heading = 'Request details'.
     APPEND ls_groups TO ls_nodes-nodestogroups.
    ls_groups-pageid = '5'.
    ls_groups-groupid = '5'.
    ls_groups-heading = 'Request Status'.
     APPEND ls_groups TO ls_nodes-nodestogroups.





*    DATA: ls_quickview TYPE y229_st_quickview.
*
*    ls_quickview-nodeid = '1'.
*    ls_quickview-pageid = 'employeePageId'.
*    ls_quickview-header = 'Approver Info'.
*    ls_quickview-icon = 'sap-icon://person-placeholder'.
*    ls_quickview-title = 'Approver 1'.
*    ls_quickview-description = 'Account Manager'.
*
*    APPEND ls_quickview TO et_quickview.
*
*    ls_quickview-nodeid = '2'.
*    ls_quickview-pageid = 'employeePageId'.
*    ls_quickview-header = 'Approver Info'.
*    ls_quickview-icon = 'sap-icon://person-placeholder'.
*    ls_quickview-title = 'Approver 4'.
*    ls_quickview-description = 'Manager'.
*
*    APPEND ls_quickview TO et_quickview.
*
*    ls_quickview-nodeid = '3'.
*    ls_quickview-pageid = 'employeePageId'.
*    ls_quickview-header = 'Approver Info'.
*    ls_quickview-icon = 'sap-icon://person-placeholder'.
*    ls_quickview-title = 'Approver 4'.
*    ls_quickview-description = 'Area Manager'.
*
*    APPEND ls_quickview TO et_quickview.
*
*    ls_quickview-nodeid = '4'.
*    ls_quickview-pageid = 'employeePageId'.
*    ls_quickview-header = 'Approver Info'.
*    ls_quickview-icon = 'sap-icon://person-placeholder'.
*    ls_quickview-title = 'Approver 3'.
*    ls_quickview-description = 'Team Leader'.
*
*    APPEND ls_quickview TO et_quickview.
*
*    ls_quickview-nodeid = '5'.
*    ls_quickview-pageid = 'employeePageId'.
*    ls_quickview-header = 'Approver Info'.
*    ls_quickview-icon = 'sap-icon://person-placeholder'.
*    ls_quickview-title = 'Approver2'.
*    ls_quickview-description = 'Senior Manager'.
*
*    APPEND ls_quickview TO et_quickview.
*
*    ls_quickview-nodeid = '6'.
*    ls_quickview-pageid = 'employeePageId'.
*    ls_quickview-header = 'Approver Info'.
*    ls_quickview-icon = 'sap-icon://person-placeholder'.
*    ls_quickview-title = 'Approver 2'.
*    ls_quickview-description = 'Senior Consultant'.
*
*    APPEND ls_quickview TO et_quickview.




  ENDMETHOD.


  METHOD get_approval_comments.

    DATA: ls_apprcomments TYPE y229_st_comments.

    ls_apprcomments-apprname = 'Approver 1'.
    ls_apprcomments-apprdate = sy-datum.
    ls_apprcomments-state = 'Success'.
    ls_apprcomments-comments = 'Approved'.
    APPEND ls_apprcomments TO et_comments.

    ls_apprcomments-apprname = 'Approver 2'.
    ls_apprcomments-apprdate = sy-datum.
    ls_apprcomments-state = 'Information'.
    ls_apprcomments-comments = 'Sent for Approval'.
    APPEND ls_apprcomments TO et_comments.

    ls_apprcomments-apprname = 'Approver 3'.
    ls_apprcomments-apprdate = sy-datum.
    ls_apprcomments-state = 'Error'.
    ls_apprcomments-comments = 'Rejected'.
    APPEND ls_apprcomments TO et_comments.

    ls_apprcomments-apprname = 'Approver 4'.
    ls_apprcomments-apprdate = sy-datum.
    ls_apprcomments-state = 'None'.
    ls_apprcomments-comments = 'Documents missing'.
    APPEND ls_apprcomments TO et_comments.

    ls_apprcomments-apprname = 'Approver 5'.
    ls_apprcomments-apprdate = sy-datum.
    ls_apprcomments-state = 'Success'.
    ls_apprcomments-comments = 'Approved'.
    APPEND ls_apprcomments TO et_comments.

    ls_apprcomments-apprname = 'Approver 6'.
    ls_apprcomments-apprdate = sy-datum.
    ls_apprcomments-state = 'Information'.
    ls_apprcomments-comments = 'Missing Dcouments'.
    APPEND ls_apprcomments TO et_comments.
  ENDMETHOD.
ENDCLASS.
