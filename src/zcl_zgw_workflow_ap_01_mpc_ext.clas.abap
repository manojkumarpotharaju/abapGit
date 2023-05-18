CLASS zcl_zgw_workflow_ap_01_mpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zgw_workflow_ap_01_mpc
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      BEGIN OF ts_nodestoquickview.
        INCLUDE TYPE ts_approvalflow_nodes.
    TYPES nodestoquickview TYPE STANDARD TABLE OF ts_approvalflow_quickview WITH DEFAULT KEY.
    TYPES nodestogroups TYPE STANDARD TABLE OF ts_groups WITH DEFAULT KEY.
    TYPES nodestoelements TYPE STANDARD TABLE OF ts_elements WITH DEFAULT KEY.
    TYPES END OF ts_nodestoquickview .
    TYPES:
      BEGIN OF ts_approverheader .

        INCLUDE TYPE ts_apprheader.
    TYPES   headertolanes TYPE STANDARD TABLE OF ts_approvalflow_lanes WITH DEFAULT KEY.
    TYPES headertocomments TYPE STANDARD TABLE OF ts_approvalflow_comments WITH DEFAULT KEY.
    TYPES headertonodes TYPE STANDARD TABLE OF ts_nodestoquickview WITH DEFAULT KEY.
    TYPES END OF ts_approverheader .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ZGW_WORKFLOW_AP_01_MPC_EXT IMPLEMENTATION.
ENDCLASS.
